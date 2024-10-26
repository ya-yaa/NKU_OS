#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>
#include <stdio.h>

static free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

bool is_power_of_2(int x)
{
    return !(x & (x - 1));
}

unsigned get_power(unsigned n)
{
    unsigned i = 0;
    double tmp = n;
    while (tmp > 1)
    {
        tmp /= 2;
        i++;
    }
    return i;
}

unsigned *buddy;
int length;
struct Page *base0;

static void
buddy_init(void)
{
    list_init(&free_list);
    nr_free = 0;
}

static void
buddy_init_memmap(struct Page *base, size_t n)
{
    
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++)
    {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    //保存起始页面指针
    base0 = base;

    int i = get_power(n);
    //计算buddy数组长度
    length = 2 * (1 << (i));
    
    unsigned node_size = length;

    //计算buddy数组起始地址
    buddy = (unsigned *)(base + length);

    for (i = 0; i < length; ++i)
    {
        if (is_power_of_2(i + 1))
            node_size /= 2;
        buddy[i] = node_size;
    }
}

static struct Page *
buddy_alloc_pages(size_t n)
{
    assert(n > 0);
    if (n > nr_free)
    {
        return NULL;
    }
    struct Page *page = NULL; //指向页面分配的指针
   
    unsigned index = 0;//从根节点开始寻找
    unsigned node_size;//储存当前节点大小
    unsigned offect = 0;//存储偏移量

 
    if (n <= 0)
        n = 1;
    else if (!is_power_of_2(n))
    {
        unsigned pw = get_power(n);
        n = (1 << pw);
    }
    

    if (buddy[index] < n) //如果根节点大小小于n，则找不到合适的节点
        offect = -1;
    //从根节点往下找，直到大小等于n
    for (node_size = length / 2; node_size != n; node_size /= 2)
    {
        //如果左子节点大小大于等于n，移动到左节点
        if (buddy[2 * index + 1] >= n)
        {
            index = 2 * index + 1;
        }
        //反之移动到右节点
        else
        {
            index = 2 * index + 2;
        }
    }
   
    //找到的节点标记为已分配
    buddy[index] = 0;

    //计算分配页面的偏移量
    offect = (index + 1) * node_size - length / 2;
   

    while (index > 0)
    {
        if (index % 2 == 0)
        {
            index = (index - 2) / 2;
        }
        else
        {
            index = (index - 1) / 2;
        }

        //更新父节点大小为较大子节点大小
        buddy[index] = (buddy[2 * index + 1] > buddy[2 * index + 2]) ? buddy[2 * index + 1] : buddy[2 * index + 2];
     }
    
    //计算分配页面的地址
    page = base0 + offect;
    page->property = n;
    int i = get_power(n);
    unsigned size = (1 << i);
    nr_free -= size;
    for (struct Page *p = page; p != page + size; p++)
    {
        ClearPageProperty(p);
    }
    return page;
}

static void
buddy_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);
    int i = get_power(n);
    unsigned size = (1 << i);

    struct Page *p = base;
    for (; p != base + size; p++)
    {
        assert(!PageReserved(p) && !PageProperty(p));
        set_page_ref(p, 0);
    }
    nr_free += size;

    //计算偏移量
    unsigned offect = base - base0;

    unsigned node_size = size;

    //计算索引
    unsigned index = length / 2 + offect - 1;

    buddy[index] = node_size;

    //从当前节点向上更新父节点，直到根节点
    while (index)
    {
        if (index % 2 == 0)
        {
            index = (index - 2) / 2;
        }
        else
        {
            index = (index - 1) / 2;
        }
        node_size *= 2;
        unsigned left = buddy[2 * index + 1];
        unsigned right = buddy[2 * index + 2];
        if (left + right == node_size)
            buddy[index] = node_size;
        else
            buddy[index] = (left > right) ? left : right;
    }
}

static size_t
buddy_nr_free_pages(void)
{
    return nr_free;
}


static void
buddy_check(void)
{
    cprintf("buddy check%s\n", "!");
    struct Page *p0, *p1, *p2, *A, *B, *C, *D;
    p0 = p1 = p2 = A = B = C = D = NULL;

    // cprintf("alloc p0\n");
    assert((p0 = alloc_page()) != NULL);
    // cprintf("alloc A\n");
    assert((A = alloc_page()) != NULL);
    // cprintf("alloc B\n");
    assert((B = alloc_page()) != NULL);

    // cprintf("before free p0,A,B buddy[0] %u\n", buddy[0]);

    assert(p0 != A && p0 != B && A != B);
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);

    // cprintf("free p0\n");
    free_page(p0);
    // cprintf("free A\n");
    free_page(A);
    // cprintf("free B\n");
    free_page(B);
    // cprintf("after free p0,A,B buddy[0] %u\n", buddy[0]);

    p0 = alloc_pages(100);
    p1 = alloc_pages(100);
    A = alloc_pages(64);

    // 检验p1和p2是否相邻，并且分配内存是否是大于分配内存的2的幂次
    assert(p1 = p0 + 128);
    // 检验A和p1是否相邻
    assert(A == p1 + 128);

    // 检验p0释放后分配D是否使用了D的空间
    free_page(p0);
    D = alloc_pages(32);
    assert(D == p0);

    // 检验释放后内存的合并是否正确
    free_page(D);
    free_page(p1);
    p2 = alloc_pages(256);
    assert(p0 == p2);

    free_page(p2);
    free_page(A);
}
// 这个结构体在
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};