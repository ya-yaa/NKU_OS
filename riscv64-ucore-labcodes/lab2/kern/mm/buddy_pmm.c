#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_pmm.h>

#define LEFT_CHILD(index)   ((index) * 2)
#define RIGHT_CHILD(index)  (((index) * 2) + 1)
#define PARENT(index)       ((index) / 2)
#define MAX(a, b)           ((a) > (b) ? (a) : (b))
#define BUDDY_MAX_DEPTH 30

#define KADDR(addr) ((size_t *)((uintptr_t)(addr) + PHYSICAL_MEMORY_OFFSET))

static unsigned int* buddy_page;//数组，记录每个节点的最长空闲块大小
static unsigned int buddy_page_num;//管理内存页数量
static unsigned int useable_page_num;//可用内存页数量
static struct Page* useable_page_base;//可用内存页基地址

static free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

//初始化 buddy 系统的自由列表和自由页计数
static void buddy_init(void)
{
    list_init(&free_list);//管理空闲页
    nr_free = 0;
}

//初始化伙伴系统内存映射
static void
buddy_init_memmap(struct Page *base, size_t n) {
    // 检查参数
    assert((n > 0));
    // 获得伙伴系统的各参数
    // 可使用内存页数 && 管理内存页数
    //设定每512个页面需要一个管理页
    useable_page_num = 1;
    // 计算 useable_page_num
    for (int i = 1; i < BUDDY_MAX_DEPTH; i++) {
        useable_page_num *= 2;
        if (useable_page_num + (useable_page_num / 512) >= n) {
            break;
        }
    }
    useable_page_num /= 2;
    //计算需要得到的管理页数目
    buddy_page_num = (useable_page_num / 512) + 1;
    // 可使用内存页基址
    useable_page_base = base + buddy_page_num;
    // 初始化所有页权限
    for (int i = 0; i != buddy_page_num; i++){
        SetPageReserved(base + i);
    }
    for (int i = buddy_page_num; i != n; i++){
        ClearPageReserved(base + i);
        SetPageProperty(base + i);
        set_page_ref(base + i, 0);
    }
    // 初始化管理页 (自底向上)
    buddy_page = (unsigned int*)KADDR(page2pa(base));
    for (int i = useable_page_num; i < useable_page_num *2; i++){
        buddy_page[i] = 1;
    }
    for (int i = useable_page_num - 1; i > 0; i--){
        buddy_page[i] = buddy_page[i * 2] * 2;
    }
}

//分配页面
static struct
Page* buddy_alloc_pages(size_t n) {
    // 检查参数
    assert(n > 0);
    // 需要的页数太大, 返回NULL(分配失败)
    if (n > buddy_page[1]){
        return NULL;
    }
    // 找到需要的页区
    unsigned int index = 1;
    while(1){
        if (buddy_page[LEFT_CHILD(index)] >= n){
            index = LEFT_CHILD(index);
        }
        else if (buddy_page[RIGHT_CHILD(index)] >= n){
            index = RIGHT_CHILD(index);
        }
        else{
            break;
        }
    }
    // 分配
    unsigned int size = buddy_page[index];
    buddy_page[index] = 0;
    
    //计算新页面基地址
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
    for (struct Page* p = new_page; p != new_page + size; p++){
        ClearPageProperty(p);
        set_page_ref(p, 0);
    }
    // 更新上方节点
    index = PARENT(index);
    while(index > 0){
        buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
        index = PARENT(index);
    }
    // 返回分配到的page
    return new_page;
}

static void
buddy_free_pages(struct Page *base, size_t n) {
    // 检查参数
    assert(n > 0);
    // 释放
    for (struct Page *p = base; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        SetPageProperty(p);
        set_page_ref(p, 0);
    }
    // 维护
    unsigned int index = useable_page_num + (unsigned int)(base - useable_page_base), size = 1;
    //查找合适父节点
    while(buddy_page[index] > 0){
        index=PARENT(index);
        size *= 2;
    }
    buddy_page[index] = size;
    //循环更新到根节点
    while((index = PARENT(index)) > 0){
        size *= 2;
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
            buddy_page[index] = size;
        }
        else{
            buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
        }
    }
}

//获取可用内存页数
static size_t
buddy_nr_free_pages(void) {
    return buddy_page[1];
}

static void
buddy_check(void) {
    int all_pages = nr_free_pages();
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
    // 分配两个组页
    p0 = alloc_pages(1);
    assert(p0 != NULL);
    p1 = alloc_pages(2);
    assert(p1 == p0 + 2);
    assert(!PageReserved(p0) && !PageProperty(p0));
    assert(!PageReserved(p1) && !PageProperty(p1));
    // 再分配两个组页
    p2 = alloc_pages(1);
    assert(p2 == p0 + 1);
    p3 = alloc_pages(8);
    assert(p3 == p0 + 8);
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
    // 回收页
    free_pages(p1, 2);
    assert(PageProperty(p1) && PageProperty(p1 + 1));
    assert(p1->ref == 0);
    free_pages(p0, 1);
    free_pages(p2, 1);
    // 回收后再分配
    p2 = alloc_pages(3);
    assert(p2 == p0);
    free_pages(p2, 3);
    assert((p2 + 2)->ref == 0);
    assert(nr_free_pages() == all_pages >> 1);

    p1 = alloc_pages(129);
    assert(p1 == p0 + 256);
    free_pages(p1, 256);
    free_pages(p3, 8);
}

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};