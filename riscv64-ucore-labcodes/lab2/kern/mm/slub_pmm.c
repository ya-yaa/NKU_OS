// 参照其他实验文件中的kmalloc.c文件

// mmu.h文件中
// #define PGSIZE          4096                    // bytes mapped by a page
// #define PGSHIFT         12                      // log2(PGSIZE)
#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <assert.h>
#include <pmm.h>
#include <stdio.h>
#include <slub_pmm.h>

// object小块
struct object {
	int objsize;  // 供分配的块大小
	struct object *next;  // 下一个块
};
typedef struct object obj_t;

#define OBJ_UNIT sizeof(obj_t)  // 小块的总大小
#define OBJ_UNITS(size) (((size) + OBJ_UNIT - 1)/OBJ_UNIT)  // 转换size为需要的块数，向上取整

// bigblock大块
struct bigblock {
	int order;  // 阶数，说明大小
	void *pages;  // 这个页的起始地址
	struct bigblock *next;  // 下个页
};
typedef struct bigblock bigblock_t;

static obj_t arena = { .next = &arena, .objsize = 1 };  // 小块链表头，初始时指向自身。
static obj_t *objfree = &arena;  // 当前可用的空闲小块链表，初始指向arena。
static bigblock_t *bigblocks;  // 大页的链表，初始为空。


// obj块管理部分
// 将一个size大小的新块加入链表
static void obj_free(void *block, int size)
{
	obj_t *cur, *b = (obj_t *)block;

	if (!block)
		return;

	if (size)
		b->objsize = OBJ_UNITS(size);  

    // 从objfree开始遍历，寻找到合适的cur位置插入，b要在cur和cur->next之间
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->objsize == cur->next) {
		b->objsize += cur->next->objsize;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->objsize == b) {
		cur->objsize += b->objsize;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
    
    // 更新空闲块位置
	objfree = cur;
}

// 小块分配(传入size是算上头部obj_t的)
static void *obj_alloc(size_t size)
{
	assert(size < PGSIZE);

	obj_t *prev, *cur;
	int objsize = OBJ_UNITS(size);

	prev = objfree;  // 从头遍历小块链表
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
		
        if (cur->objsize >= objsize) { // 如果当前足够大
            // 刚刚好，直接从链表中取出
			if (cur->objsize == objsize)
				prev->next = cur->next;
            // 比需要的大，取下需要的部分，剩下的合并到后面的小块
			else { 
                // 一个指针加法，在当前块指针的基础上偏移units个SLOB单位
                // 使得prev->next指向剩余块的起始位置，将当前块分为两部分
				prev->next = cur + objsize;  

				prev->next->objsize = cur->objsize - objsize;
				prev->next->next = cur->next;  // 剩余块被连入链表
				cur->objsize = objsize;  // units大小的块被取出
			}
			objfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (obj_t *)alloc_pages(1);  
			if (!cur)  // 如果获取失败，返回 0
				return 0;

			obj_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
			cur = objfree;  // 从新分配的页再次循环
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
void *slub_alloc(size_t size)
{
	obj_t *m;
	bigblock_t *bb;
    
    // 申请size+slot_t小于一页，用小块分配。
    // 如果分配成功，则返回 (void *)(m + 1)，跳过了一个 obj_t 的单位,指向实际可用的内存地址。
    // 如果分配失败，返回 0
	if (size < PGSIZE - OBJ_UNIT) {
		m = obj_alloc(size + OBJ_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = obj_alloc(sizeof(bigblock_t));
	if (!bb)
		return 0;
    
    // 分配大页
	bb->order = ((size - 1) >> PGSHIFT) + 1;  // PGSHIFT为12，向右移12位的效果相当于除以2^12即4096）
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页

    // 分配成功，将其插入到大块链表的头部。
	if (bb->pages) {
		bb->next = bigblocks;
		bigblocks = bb;
		return bb->pages;
	}
    
    // 如果页分配失败，释放之前为bigblock_t结构体分配的内存。返回0。
	obj_free(bb, sizeof(bigblock_t));
	return 0;
}

// 总slub释放算法
void slub_free(void *block)
{
    // bb用于遍历记录大块内存的链表。
    // last用于指向链表中前一个节点的next指针
	bigblock_t *bb, **last = &bigblocks;

	if (!block)
		return;

	if (!((unsigned long)block & (PGSIZE-1))) {
		/* might be on the big block list */
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
			if (bb->pages == block) {
				*last = bb->next;
                // call pmm->free_pages to free a continuous n*PAGESIZE memory
				free_pages((struct Page *)block, bb->order);
				obj_free(bb, sizeof(bigblock_t));
				return;
			}
		}
	}

	obj_free((obj_t *)block - 1, 0);
	return;
}

void slub_init(void) {
    cprintf("slub_init() succeeded!\n");
}

unsigned int slub_size(const void *block)
{
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
		return 0;

	if (!((unsigned long)block & (PGSIZE-1))) {
		for (bb = bigblocks; bb; bb = bb->next)
			if (bb->pages == block) {
				return bb->order << PGSHIFT;
			}
	}

	return ((obj_t *)block - 1)->objsize * OBJ_UNIT;
}

int objfree_len()
{
    int len = 0;
    for(obj_t* curr = objfree->next; curr != objfree; curr = curr->next)
        len ++;
    return len;
}


void slub_check()
{
    cprintf("slub check begin\n");
    cprintf("objfree len: %d\n", objfree_len());
    void* p1 = slub_alloc(4096);
    cprintf("objfree len: %d\n", objfree_len());
    void* p2 = slub_alloc(2);
    void* p3 = slub_alloc(2);
    cprintf("objfree len: %d\n", objfree_len());
    slub_free(p2);
    cprintf("objfree len: %d\n", objfree_len());
    slub_free(p3);
    cprintf("objfree len: %d\n", objfree_len());
    cprintf("slub check end\n");
}