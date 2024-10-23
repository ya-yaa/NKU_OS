#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>

static free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static size_t total_size;          // 总的物理内存大小
static size_t full_tree_size;      // 二叉树大小
static size_t record_area_size;    // 记录节点信息的页大小
static size_t real_tree_size;      // 可分配页的大小
static size_t *record_area;        // 记录页面的头指针
static struct Page *physical_area; // 物理内存的头指针
static struct Page *allocate_area; // 可分配内存的头指针

#define TREE_ROOT (1)
#define LEFT_CHILD(a) ((a) << 1)
#define RIGHT_CHILD(a) (((a) << 1) + 1)
#define PARENT(a) ((a) >> 1)
#define NODE_LENGTH(a) (full_tree_size / POWER_ROUND_DOWN(a))
#define NODE_BEGINNING(a) (POWER_REMAINDER(a) * NODE_LENGTH(a))              // the head address of a node
#define NODE_ENDDING(a) ((POWER_REMAINDER(a) + 1) * NODE_LENGTH(a))          // the end address of a node
#define BUDDY_BLOCK(a, b) (full_tree_size / ((b) - (a)) + (a) / ((b) - (a))) // get the index of a node by its address
#define BUDDY_EMPTY(a) (record_area[(a)] == NODE_LENGTH(a))

#define OR_SHIFT_RIGHT(a, n) ((a) | ((a) >> (n)))
#define ALL_BIT_TO_ONE(a) (OR_SHIFT_RIGHT(OR_SHIFT_RIGHT(OR_SHIFT_RIGHT(OR_SHIFT_RIGHT(OR_SHIFT_RIGHT(a, 1), 2), 4), 8), 16))
#define POWER_REMAINDER(a) ((a) & (ALL_BIT_TO_ONE(a) >> 1))
#define POWER_ROUND_UP(a) (POWER_REMAINDER(a) ? (((a)-POWER_REMAINDER(a)) << 1) : (a))
#define POWER_ROUND_DOWN(a) (POWER_REMAINDER(a) ? ((a)-POWER_REMAINDER(a)) : (a))

#define KADDR(addr) ((size_t *)((uintptr_t)(addr) + PHYSICAL_MEMORY_OFFSET))

//初始化 buddy 系统的自由列表和自由页计数
static void buddy_init(void)
{
    list_init(&free_list);//管理空闲页
    nr_free = 0;
}

//初始化物理内存映射
static void buddy_init_memmap(struct Page *base, size_t n)
{
    assert(n > 0);
    struct Page *p;
    for (p = base; p < base + n; p++)
    {
        assert(PageReserved(p));//标记为保留状态
        p->flags = p->property = 0;//清除页的标志和属性字段
    }
    total_size = n;
    //将树的大小向上取整到物理内存最近的2的幂
    if (n < 512)
    {
        full_tree_size = POWER_ROUND_UP(n - 1);
        record_area_size = 1;
    }
    else
    {
        full_tree_size = POWER_ROUND_DOWN(n);
        record_area_size = full_tree_size * sizeof(size_t) * 2 / PGSIZE;
        if (n > full_tree_size + (record_area_size << 1))
        {
            full_tree_size <<= 1;
            record_area_size <<= 1;
        }
    }
    //实际可以分配的树大小，确保不超过总的物理内存减去记录区域大小
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;

    physical_area = base;//物理内存的基地址
    record_area = KADDR(page2pa(base));//记录区域的基地址，获得物理地址对应的虚拟地址。
    allocate_area = base + record_area_size;// 可分配内存的基地址
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容

    nr_free += real_tree_size;//更新自由页计数器
    size_t block = TREE_ROOT;//当前处理的节点索引
    size_t real_subtree_size = real_tree_size;//当前处理的子树的实际大小
    size_t full_subtree_size = full_tree_size;//当前处理的子树的满二叉树大小
    
    //如果 real_subtree_size 大于 full_subtree_size，则创建一个新的节点，并将其添加到自由列表中
    record_area[block] = real_subtree_size;
    while (real_subtree_size > 0 && real_subtree_size < full_subtree_size)
    {
        full_subtree_size >>= 1;//将子树大小分成一半
        //如果当前子树的实际大小超过该子树的一半，需要创建一个新的节点，并将其添加到自由列表中
        if (real_subtree_size > full_subtree_size)
        {
            //获取当前节点的物理页指针。
            struct Page *page = &allocate_area[NODE_BEGINNING(block)];
            //设置页的属性为 full_subtree_size
            page->property = full_subtree_size;
            //将页添加到自由列表中
            list_add(&(free_list), &(page->page_link));
            //设置页的引用计数为 0
            set_page_ref(page, 0);
            //设置页的属性标志
            SetPageProperty(page);
            record_area[LEFT_CHILD(block)] = full_subtree_size;//设置左子节点的大小
            real_subtree_size -= full_subtree_size;//减去已分配的大小
            record_area[RIGHT_CHILD(block)] = real_subtree_size;//设置右子节点的大小
            block = RIGHT_CHILD(block);//将当前节点设置为右子节点，以便继续处理
        }
        else
        {
            //当前子树的实际大小小于或等于一半，不需要创建新的节点
            // 设置左子节点的大小
            record_area[LEFT_CHILD(block)] = real_subtree_size;
            //设置右子节点的大小为 0，表示该子树已经处理完毕
            record_area[RIGHT_CHILD(block)] = 0;
            //将当前节点设置为左子节点，以便继续处理
            block = LEFT_CHILD(block);
        }
    }

    //处理剩余的real_subtree_size
    if (real_subtree_size > 0)
    {
        struct Page *page = &allocate_area[NODE_BEGINNING(block)];
        page->property = real_subtree_size;
        set_page_ref(page, 0);
        SetPageProperty(page);
        list_add(&(free_list), &(page->page_link));
    }
}

//分配页面
static struct Page *buddy_allocate_pages(size_t n)
{
    assert(n > 0);
    struct Page *page;//保存最终分配的页的指针
    size_t block = TREE_ROOT;//当前处理的节点索引
    size_t length = POWER_ROUND_UP(n);//请求分配的页数 n 向上取整到最近的 2 的幂次方

    //请求的页数小于当前节点所代表的内存块的长度
    while (length <= record_area[block] && length < NODE_LENGTH(block))
    {
        size_t left = LEFT_CHILD(block);
        size_t right = RIGHT_CHILD(block);
        if (BUDDY_EMPTY(block))//如果当前节点为空
        {
            size_t begin = NODE_BEGINNING(block);
            size_t end = NODE_ENDDING(block);
            size_t mid = (begin + end) / 2;
            //从自由列表中删除当前节点
            list_del(&(allocate_area[begin].page_link));
            //大小减半
            allocate_area[begin].property /= 2;
            //初始化中间节点的属性
            allocate_area[mid].property = allocate_area[begin].property;
            //设置左右子节点的记录大小
            record_area[left] = record_area[block] / 2 ;
            record_area[right] = record_area[block] / 2;
            //将分割后的新节点添加回自由列表
            list_add(&free_list, &(allocate_area[begin].page_link));
            list_add(&free_list, &(allocate_area[mid].page_link));
            // 将当前节点设置为左子节点
            block = left;
        }
        //如果请求的页数 length 小于左子节点的记录大小，则选择左子节点
        else if (length & record_area[left])
            block = left;
        else if (length & record_area[right])
            block = right;
        else if (length <= record_area[left])
            block = left;
        else if (length <= record_area[right])
            block = right;
    }
    //如果请求的页数 length 超过了当前节点的记录大小 record_area[block]，则无法满足请求
    if (length > record_area[block])
        return NULL;
    //如果找到了合适的节点
    page = &(allocate_area[NODE_BEGINNING(block)]);//获取当前节点对应的物理页指针
    list_del(&(page->page_link));// 从自由列表中删除当前节点
    record_area[block] = 0;//清空当前节点的记录大小
    nr_free -= length;//更新空闲页计数器，减少分配出去的页数
    //更新所有父节点的记录大小
    while (block != TREE_ROOT)
    {
        block = PARENT(block);
        record_area[block] = record_area[LEFT_CHILD(block)] | record_area[RIGHT_CHILD(block)];
    }
    return page;
}

//释放页面
static void buddy_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);
    struct Page *p = base;//指向要释放的页的起始位置
    size_t length = POWER_ROUND_UP(n);
    size_t begin = (base - allocate_area);//计算要释放的页在 allocate_area 中的起始偏移
    size_t end = begin + length;//计算要释放的页在 allocate_area 中的结束偏移
    size_t block = BUDDY_BLOCK(begin, end);//计算要释放的页所在的节点索引
    
    //清理要释放的页
    for (; p != base + n; p++)
    {
        assert(!PageReserved(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = length;
    list_add(&free_list, &(base->page_link));
    nr_free += length;
    record_area[block] = length;
    
    //合并相邻的空闲块
    while (block != TREE_ROOT)
    {
        block = PARENT(block);
        size_t left = LEFT_CHILD(block);
        size_t right = RIGHT_CHILD(block);
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right))
        {
            size_t lbegin = NODE_BEGINNING(left);
            size_t rbegin = NODE_BEGINNING(right);
            list_del(&(allocate_area[lbegin].page_link));
            list_del(&(allocate_area[rbegin].page_link));
            //设置父节点的记录大小为左子节点记录大小的两倍
            record_area[block] = record_area[left] * 2;
            //设置左子节点的属性为合并后的大小
            allocate_area[lbegin].property = record_area[left] * 2;
            //
            list_add(&free_list, &(allocate_area[lbegin].page_link));
        }
        else
            record_area[block] = record_area[LEFT_CHILD(block)] | record_area[RIGHT_CHILD(block)];
    }
}

//获取自由页计数
static size_t
buddy_nr_free_pages(void)
{
    return nr_free;
}

static void alloc_check(void)
{
    size_t total_size_store = total_size;
    struct Page *p;
    for (p = physical_area; p < physical_area + 1026; p++)
        SetPageReserved(p);
    buddy_init();
    buddy_init_memmap(physical_area, 1026);

    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);
    assert((p3 = alloc_page()) != NULL);

    assert(p0 + 1 == p1);
    assert(p1 + 1 == p2);
    assert(p2 + 1 == p3);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);
    assert(page2pa(p3) < npage * PGSIZE);

    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
    {
        p = le2page(le, page_link);
        assert(buddy_allocate_pages(p->property) != NULL);
    }

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p1 = alloc_page()) != NULL);
    assert((p0 = alloc_pages(2)) != NULL);
    assert(p0 + 2 == p1);

    assert(alloc_page() == NULL);

    free_pages(p0, 2);
    free_page(p1);
    free_page(p3);

    assert((p = alloc_pages(4)) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);

    for (p = physical_area; p < physical_area + total_size_store; p++)
        SetPageReserved(p);
    buddy_init();
    buddy_init_memmap(physical_area, total_size_store);
}

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_allocate_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = alloc_check,
};