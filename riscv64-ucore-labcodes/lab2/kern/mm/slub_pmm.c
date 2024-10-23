// 参照其他实验文件中的kmalloc.c文件

// mmu.h文件中
// #define PGSIZE          4096                    // bytes mapped by a page
// #define PGSHIFT         12                      // log2(PGSIZE)
#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <assert.h>
#include <kmalloc.h>
#include <sync.h>
#include <pmm.h>
#include <stdio.h>

// 小块
struct slob_block {
	int units;  // 供分配的块大小
	struct slob_block *next;  // 下一个块
};
typedef struct slob_block slob_t;

#define SLOB_UNIT sizeof(slob_t)  // 小块的总大小
#define SLOB_UNITS(size) (((size) + SLOB_UNIT - 1)/SLOB_UNIT)  // 转换size为需要的块数，向上取整

// 大页
struct bigblock {
	int order;  // 阶数，说明大小
	void *pages;  // 这个页的起始地址
	struct bigblock *next;  // 下个页
};
typedef struct bigblock bigblock_t;

static slob_t arena = { .next = &arena, .units = 1 };  // 小块链表头，初始时指向自身。
static slob_t *slobfree = &arena;  // 当前可用的空闲小块链表，初始指向arena。
static bigblock_t *bigblocks;  // 大页的链表，初始为空。


// slob块管理部分
// 将一个size大小的新块加入链表
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;

	if (!block)
		return;

	if (size)
		b->units = SLOB_UNITS(size);  

    // 从slobfree开始遍历，寻找到合适的cur位置插入，b要在cur和cur->next之间
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->units == cur->next) {
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->units == b) {
		cur->units += b->units;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
    
    // 更新空闲块位置
	slobfree = cur;
}

// 小块分配(传入size是算上头部slob_t的)
static void *slob_alloc(size_t size)
{
	assert(size < PGSIZE );

	slob_t *prev, *cur;
	int units = SLOB_UNITS(size);

	prev = slobfree;  // 从头遍历小块链表
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
		
        if (cur->units >= units) { // 如果当前足够大
            // 刚刚好，直接从链表中取出
			if (cur->units == units)
				prev->next = cur->next;
            // 比需要的大，取下需要的部分，剩下的合并到后面的小块
			else { 
                // 一个指针加法，在当前块指针的基础上偏移units个SLOB单位
                // 使得prev->next指向剩余块的起始位置，将当前块分为两部分
				prev->next = cur + units;  

				prev->next->units = cur->units - units;
				prev->next->next = cur->next;  // 剩余块被连入链表
				cur->units = units;  // units大小的块被取出
			}
			slobfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == slobfree) {  // 链表遍历结束了，还没找到。需要扩展内存

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (slob_t *)alloc_pages(1);  
			if (!cur)  // 如果获取失败，返回 0
				return 0;

			slob_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
			cur = slobfree;  // 从新分配的页再次循环
		}
	}
}

// 大页
// 确定阶数
static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
		order++;
	return order;
}

// 总slub分配算法(传入申请的大小)
static void *slub_alloc(size_t size)
{
	slob_t *m;
	bigblock_t *bb;
    
    // 申请size+slot_t小于一页，用小块分配。
    // 如果分配成功，则返回 (void *)(m + 1)，跳过了一个 slob_t 的单位,指向实际可用的内存地址。
    // 如果分配失败，返回 0
	if (size < PGSIZE - SLOB_UNIT) {
		m = slob_alloc(size + SLOB_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = slob_alloc(sizeof(bigblock_t));
	if (!bb)
		return 0;
    
	bb->order = ((size - 1) >> PGSHIFT) + 1;
	bb->pages = (void *)alloc_pages(bb->order);

	if (bb->pages) {
		bb->next = bigblocks;
		bigblocks = bb;
		return bb->pages;
	}

	slob_free(bb, sizeof(bigblock_t));
	return 0;
}

// 总slub释放算法
void slub_free(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
			if (bb->pages == block) {
				*last = bb->next;
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}





void
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
slub_init(void) {
    slob_init();
    cprintf("slub_init() succeeded!\n");
}

size_t
slob_allocated(void) {
  return 0;
}

size_t
kallocated(void) {
   return slob_allocated();
}





unsigned int ksize(const void *block)
{
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
}



