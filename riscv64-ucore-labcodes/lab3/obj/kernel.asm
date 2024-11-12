
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc020001c:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200020:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200024:	c0209137          	lui	sp,0xc0209

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:


int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	0000a517          	auipc	a0,0xa
ffffffffc0200036:	00e50513          	addi	a0,a0,14 # ffffffffc020a040 <ide>
ffffffffc020003a:	00011617          	auipc	a2,0x11
ffffffffc020003e:	53e60613          	addi	a2,a2,1342 # ffffffffc0211578 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	73f030ef          	jal	ra,ffffffffc0203f88 <memset>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020004e:	00004597          	auipc	a1,0x4
ffffffffc0200052:	40a58593          	addi	a1,a1,1034 # ffffffffc0204458 <etext+0x4>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	42250513          	addi	a0,a0,1058 # ffffffffc0204478 <etext+0x24>
ffffffffc020005e:	05c000ef          	jal	ra,ffffffffc02000ba <cprintf>

    print_kerninfo();
ffffffffc0200062:	0fc000ef          	jal	ra,ffffffffc020015e <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc0200066:	6d7020ef          	jal	ra,ffffffffc0202f3c <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	4fa000ef          	jal	ra,ffffffffc0200564 <idt_init>
    //初始化虚拟内存管理
    vmm_init();                 // init virtual memory management
ffffffffc020006e:	483000ef          	jal	ra,ffffffffc0200cf0 <vmm_init>
    //初始化硬盘
    ide_init();                 // init ide devices
ffffffffc0200072:	35e000ef          	jal	ra,ffffffffc02003d0 <ide_init>
    //初始化页面置换算法             
    swap_init();                // init swap
ffffffffc0200076:	6b0010ef          	jal	ra,ffffffffc0201726 <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020007a:	3ac000ef          	jal	ra,ffffffffc0200426 <clock_init>
    // intr_enable();              // enable irq interrupt



    /* do nothing */
    while (1);
ffffffffc020007e:	a001                	j	ffffffffc020007e <kern_init+0x4c>

ffffffffc0200080 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200080:	1141                	addi	sp,sp,-16
ffffffffc0200082:	e022                	sd	s0,0(sp)
ffffffffc0200084:	e406                	sd	ra,8(sp)
ffffffffc0200086:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200088:	3f0000ef          	jal	ra,ffffffffc0200478 <cons_putc>
    (*cnt) ++;
ffffffffc020008c:	401c                	lw	a5,0(s0)
}
ffffffffc020008e:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200090:	2785                	addiw	a5,a5,1
ffffffffc0200092:	c01c                	sw	a5,0(s0)
}
ffffffffc0200094:	6402                	ld	s0,0(sp)
ffffffffc0200096:	0141                	addi	sp,sp,16
ffffffffc0200098:	8082                	ret

ffffffffc020009a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	862a                	mv	a2,a0
ffffffffc020009e:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a0:	00000517          	auipc	a0,0x0
ffffffffc02000a4:	fe050513          	addi	a0,a0,-32 # ffffffffc0200080 <cputch>
ffffffffc02000a8:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000aa:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000ac:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ae:	771030ef          	jal	ra,ffffffffc020401e <vprintfmt>
    return cnt;
}
ffffffffc02000b2:	60e2                	ld	ra,24(sp)
ffffffffc02000b4:	4532                	lw	a0,12(sp)
ffffffffc02000b6:	6105                	addi	sp,sp,32
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000ba:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000c0:	8e2a                	mv	t3,a0
ffffffffc02000c2:	f42e                	sd	a1,40(sp)
ffffffffc02000c4:	f832                	sd	a2,48(sp)
ffffffffc02000c6:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c8:	00000517          	auipc	a0,0x0
ffffffffc02000cc:	fb850513          	addi	a0,a0,-72 # ffffffffc0200080 <cputch>
ffffffffc02000d0:	004c                	addi	a1,sp,4
ffffffffc02000d2:	869a                	mv	a3,t1
ffffffffc02000d4:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000d6:	ec06                	sd	ra,24(sp)
ffffffffc02000d8:	e0ba                	sd	a4,64(sp)
ffffffffc02000da:	e4be                	sd	a5,72(sp)
ffffffffc02000dc:	e8c2                	sd	a6,80(sp)
ffffffffc02000de:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000e0:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000e2:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e4:	73b030ef          	jal	ra,ffffffffc020401e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000e8:	60e2                	ld	ra,24(sp)
ffffffffc02000ea:	4512                	lw	a0,4(sp)
ffffffffc02000ec:	6125                	addi	sp,sp,96
ffffffffc02000ee:	8082                	ret

ffffffffc02000f0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000f0:	a661                	j	ffffffffc0200478 <cons_putc>

ffffffffc02000f2 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02000f2:	1141                	addi	sp,sp,-16
ffffffffc02000f4:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02000f6:	3b6000ef          	jal	ra,ffffffffc02004ac <cons_getc>
ffffffffc02000fa:	dd75                	beqz	a0,ffffffffc02000f6 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02000fc:	60a2                	ld	ra,8(sp)
ffffffffc02000fe:	0141                	addi	sp,sp,16
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200102:	00011317          	auipc	t1,0x11
ffffffffc0200106:	3f630313          	addi	t1,t1,1014 # ffffffffc02114f8 <is_panic>
ffffffffc020010a:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020010e:	715d                	addi	sp,sp,-80
ffffffffc0200110:	ec06                	sd	ra,24(sp)
ffffffffc0200112:	e822                	sd	s0,16(sp)
ffffffffc0200114:	f436                	sd	a3,40(sp)
ffffffffc0200116:	f83a                	sd	a4,48(sp)
ffffffffc0200118:	fc3e                	sd	a5,56(sp)
ffffffffc020011a:	e0c2                	sd	a6,64(sp)
ffffffffc020011c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020011e:	020e1a63          	bnez	t3,ffffffffc0200152 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200122:	4785                	li	a5,1
ffffffffc0200124:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200128:	8432                	mv	s0,a2
ffffffffc020012a:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020012c:	862e                	mv	a2,a1
ffffffffc020012e:	85aa                	mv	a1,a0
ffffffffc0200130:	00004517          	auipc	a0,0x4
ffffffffc0200134:	35050513          	addi	a0,a0,848 # ffffffffc0204480 <etext+0x2c>
    va_start(ap, fmt);
ffffffffc0200138:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020013a:	f81ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    vcprintf(fmt, ap);
ffffffffc020013e:	65a2                	ld	a1,8(sp)
ffffffffc0200140:	8522                	mv	a0,s0
ffffffffc0200142:	f59ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
    cprintf("\n");
ffffffffc0200146:	00006517          	auipc	a0,0x6
ffffffffc020014a:	d1250513          	addi	a0,a0,-750 # ffffffffc0205e58 <default_pmm_manager+0x420>
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200152:	39c000ef          	jal	ra,ffffffffc02004ee <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200156:	4501                	li	a0,0
ffffffffc0200158:	130000ef          	jal	ra,ffffffffc0200288 <kmonitor>
    while (1) {
ffffffffc020015c:	bfed                	j	ffffffffc0200156 <__panic+0x54>

ffffffffc020015e <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020015e:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200160:	00004517          	auipc	a0,0x4
ffffffffc0200164:	34050513          	addi	a0,a0,832 # ffffffffc02044a0 <etext+0x4c>
void print_kerninfo(void) {
ffffffffc0200168:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020016a:	f51ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020016e:	00000597          	auipc	a1,0x0
ffffffffc0200172:	ec458593          	addi	a1,a1,-316 # ffffffffc0200032 <kern_init>
ffffffffc0200176:	00004517          	auipc	a0,0x4
ffffffffc020017a:	34a50513          	addi	a0,a0,842 # ffffffffc02044c0 <etext+0x6c>
ffffffffc020017e:	f3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200182:	00004597          	auipc	a1,0x4
ffffffffc0200186:	2d258593          	addi	a1,a1,722 # ffffffffc0204454 <etext>
ffffffffc020018a:	00004517          	auipc	a0,0x4
ffffffffc020018e:	35650513          	addi	a0,a0,854 # ffffffffc02044e0 <etext+0x8c>
ffffffffc0200192:	f29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200196:	0000a597          	auipc	a1,0xa
ffffffffc020019a:	eaa58593          	addi	a1,a1,-342 # ffffffffc020a040 <ide>
ffffffffc020019e:	00004517          	auipc	a0,0x4
ffffffffc02001a2:	36250513          	addi	a0,a0,866 # ffffffffc0204500 <etext+0xac>
ffffffffc02001a6:	f15ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc02001aa:	00011597          	auipc	a1,0x11
ffffffffc02001ae:	3ce58593          	addi	a1,a1,974 # ffffffffc0211578 <end>
ffffffffc02001b2:	00004517          	auipc	a0,0x4
ffffffffc02001b6:	36e50513          	addi	a0,a0,878 # ffffffffc0204520 <etext+0xcc>
ffffffffc02001ba:	f01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001be:	00011597          	auipc	a1,0x11
ffffffffc02001c2:	7b958593          	addi	a1,a1,1977 # ffffffffc0211977 <end+0x3ff>
ffffffffc02001c6:	00000797          	auipc	a5,0x0
ffffffffc02001ca:	e6c78793          	addi	a5,a5,-404 # ffffffffc0200032 <kern_init>
ffffffffc02001ce:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d2:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001d6:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d8:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001dc:	95be                	add	a1,a1,a5
ffffffffc02001de:	85a9                	srai	a1,a1,0xa
ffffffffc02001e0:	00004517          	auipc	a0,0x4
ffffffffc02001e4:	36050513          	addi	a0,a0,864 # ffffffffc0204540 <etext+0xec>
}
ffffffffc02001e8:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ea:	bdc1                	j	ffffffffc02000ba <cprintf>

ffffffffc02001ec <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001ec:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc02001ee:	00004617          	auipc	a2,0x4
ffffffffc02001f2:	38260613          	addi	a2,a2,898 # ffffffffc0204570 <etext+0x11c>
ffffffffc02001f6:	04e00593          	li	a1,78
ffffffffc02001fa:	00004517          	auipc	a0,0x4
ffffffffc02001fe:	38e50513          	addi	a0,a0,910 # ffffffffc0204588 <etext+0x134>
void print_stackframe(void) {
ffffffffc0200202:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200204:	effff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200208 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200208:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020020a:	00004617          	auipc	a2,0x4
ffffffffc020020e:	39660613          	addi	a2,a2,918 # ffffffffc02045a0 <etext+0x14c>
ffffffffc0200212:	00004597          	auipc	a1,0x4
ffffffffc0200216:	3ae58593          	addi	a1,a1,942 # ffffffffc02045c0 <etext+0x16c>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	3ae50513          	addi	a0,a0,942 # ffffffffc02045c8 <etext+0x174>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200222:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00004617          	auipc	a2,0x4
ffffffffc020022c:	3b060613          	addi	a2,a2,944 # ffffffffc02045d8 <etext+0x184>
ffffffffc0200230:	00004597          	auipc	a1,0x4
ffffffffc0200234:	3d058593          	addi	a1,a1,976 # ffffffffc0204600 <etext+0x1ac>
ffffffffc0200238:	00004517          	auipc	a0,0x4
ffffffffc020023c:	39050513          	addi	a0,a0,912 # ffffffffc02045c8 <etext+0x174>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200244:	00004617          	auipc	a2,0x4
ffffffffc0200248:	3cc60613          	addi	a2,a2,972 # ffffffffc0204610 <etext+0x1bc>
ffffffffc020024c:	00004597          	auipc	a1,0x4
ffffffffc0200250:	3e458593          	addi	a1,a1,996 # ffffffffc0204630 <etext+0x1dc>
ffffffffc0200254:	00004517          	auipc	a0,0x4
ffffffffc0200258:	37450513          	addi	a0,a0,884 # ffffffffc02045c8 <etext+0x174>
ffffffffc020025c:	e5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    }
    return 0;
}
ffffffffc0200260:	60a2                	ld	ra,8(sp)
ffffffffc0200262:	4501                	li	a0,0
ffffffffc0200264:	0141                	addi	sp,sp,16
ffffffffc0200266:	8082                	ret

ffffffffc0200268 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200268:	1141                	addi	sp,sp,-16
ffffffffc020026a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020026c:	ef3ff0ef          	jal	ra,ffffffffc020015e <print_kerninfo>
    return 0;
}
ffffffffc0200270:	60a2                	ld	ra,8(sp)
ffffffffc0200272:	4501                	li	a0,0
ffffffffc0200274:	0141                	addi	sp,sp,16
ffffffffc0200276:	8082                	ret

ffffffffc0200278 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200278:	1141                	addi	sp,sp,-16
ffffffffc020027a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020027c:	f71ff0ef          	jal	ra,ffffffffc02001ec <print_stackframe>
    return 0;
}
ffffffffc0200280:	60a2                	ld	ra,8(sp)
ffffffffc0200282:	4501                	li	a0,0
ffffffffc0200284:	0141                	addi	sp,sp,16
ffffffffc0200286:	8082                	ret

ffffffffc0200288 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200288:	7115                	addi	sp,sp,-224
ffffffffc020028a:	ed5e                	sd	s7,152(sp)
ffffffffc020028c:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020028e:	00004517          	auipc	a0,0x4
ffffffffc0200292:	3b250513          	addi	a0,a0,946 # ffffffffc0204640 <etext+0x1ec>
kmonitor(struct trapframe *tf) {
ffffffffc0200296:	ed86                	sd	ra,216(sp)
ffffffffc0200298:	e9a2                	sd	s0,208(sp)
ffffffffc020029a:	e5a6                	sd	s1,200(sp)
ffffffffc020029c:	e1ca                	sd	s2,192(sp)
ffffffffc020029e:	fd4e                	sd	s3,184(sp)
ffffffffc02002a0:	f952                	sd	s4,176(sp)
ffffffffc02002a2:	f556                	sd	s5,168(sp)
ffffffffc02002a4:	f15a                	sd	s6,160(sp)
ffffffffc02002a6:	e962                	sd	s8,144(sp)
ffffffffc02002a8:	e566                	sd	s9,136(sp)
ffffffffc02002aa:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002ac:	e0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002b0:	00004517          	auipc	a0,0x4
ffffffffc02002b4:	3b850513          	addi	a0,a0,952 # ffffffffc0204668 <etext+0x214>
ffffffffc02002b8:	e03ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002bc:	000b8563          	beqz	s7,ffffffffc02002c6 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002c0:	855e                	mv	a0,s7
ffffffffc02002c2:	48c000ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02002c6:	00004c17          	auipc	s8,0x4
ffffffffc02002ca:	40ac0c13          	addi	s8,s8,1034 # ffffffffc02046d0 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc02002ce:	00005917          	auipc	s2,0x5
ffffffffc02002d2:	30a90913          	addi	s2,s2,778 # ffffffffc02055d8 <commands+0xf08>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d6:	00004497          	auipc	s1,0x4
ffffffffc02002da:	3ba48493          	addi	s1,s1,954 # ffffffffc0204690 <etext+0x23c>
        if (argc == MAXARGS - 1) {
ffffffffc02002de:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002e0:	00004b17          	auipc	s6,0x4
ffffffffc02002e4:	3b8b0b13          	addi	s6,s6,952 # ffffffffc0204698 <etext+0x244>
        argv[argc ++] = buf;
ffffffffc02002e8:	00004a17          	auipc	s4,0x4
ffffffffc02002ec:	2d8a0a13          	addi	s4,s4,728 # ffffffffc02045c0 <etext+0x16c>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f0:	4a8d                	li	s5,3
        if ((buf = readline("")) != NULL) {
ffffffffc02002f2:	854a                	mv	a0,s2
ffffffffc02002f4:	0ac040ef          	jal	ra,ffffffffc02043a0 <readline>
ffffffffc02002f8:	842a                	mv	s0,a0
ffffffffc02002fa:	dd65                	beqz	a0,ffffffffc02002f2 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002fc:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200300:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200302:	e1bd                	bnez	a1,ffffffffc0200368 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200304:	fe0c87e3          	beqz	s9,ffffffffc02002f2 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200308:	6582                	ld	a1,0(sp)
ffffffffc020030a:	00004d17          	auipc	s10,0x4
ffffffffc020030e:	3c6d0d13          	addi	s10,s10,966 # ffffffffc02046d0 <commands>
        argv[argc ++] = buf;
ffffffffc0200312:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200314:	4401                	li	s0,0
ffffffffc0200316:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200318:	43d030ef          	jal	ra,ffffffffc0203f54 <strcmp>
ffffffffc020031c:	c919                	beqz	a0,ffffffffc0200332 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020031e:	2405                	addiw	s0,s0,1
ffffffffc0200320:	0b540063          	beq	s0,s5,ffffffffc02003c0 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200324:	000d3503          	ld	a0,0(s10)
ffffffffc0200328:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020032a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020032c:	429030ef          	jal	ra,ffffffffc0203f54 <strcmp>
ffffffffc0200330:	f57d                	bnez	a0,ffffffffc020031e <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200332:	00141793          	slli	a5,s0,0x1
ffffffffc0200336:	97a2                	add	a5,a5,s0
ffffffffc0200338:	078e                	slli	a5,a5,0x3
ffffffffc020033a:	97e2                	add	a5,a5,s8
ffffffffc020033c:	6b9c                	ld	a5,16(a5)
ffffffffc020033e:	865e                	mv	a2,s7
ffffffffc0200340:	002c                	addi	a1,sp,8
ffffffffc0200342:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200346:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200348:	fa0555e3          	bgez	a0,ffffffffc02002f2 <kmonitor+0x6a>
}
ffffffffc020034c:	60ee                	ld	ra,216(sp)
ffffffffc020034e:	644e                	ld	s0,208(sp)
ffffffffc0200350:	64ae                	ld	s1,200(sp)
ffffffffc0200352:	690e                	ld	s2,192(sp)
ffffffffc0200354:	79ea                	ld	s3,184(sp)
ffffffffc0200356:	7a4a                	ld	s4,176(sp)
ffffffffc0200358:	7aaa                	ld	s5,168(sp)
ffffffffc020035a:	7b0a                	ld	s6,160(sp)
ffffffffc020035c:	6bea                	ld	s7,152(sp)
ffffffffc020035e:	6c4a                	ld	s8,144(sp)
ffffffffc0200360:	6caa                	ld	s9,136(sp)
ffffffffc0200362:	6d0a                	ld	s10,128(sp)
ffffffffc0200364:	612d                	addi	sp,sp,224
ffffffffc0200366:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200368:	8526                	mv	a0,s1
ffffffffc020036a:	409030ef          	jal	ra,ffffffffc0203f72 <strchr>
ffffffffc020036e:	c901                	beqz	a0,ffffffffc020037e <kmonitor+0xf6>
ffffffffc0200370:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200374:	00040023          	sb	zero,0(s0)
ffffffffc0200378:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020037a:	d5c9                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc020037c:	b7f5                	j	ffffffffc0200368 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc020037e:	00044783          	lbu	a5,0(s0)
ffffffffc0200382:	d3c9                	beqz	a5,ffffffffc0200304 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200384:	033c8963          	beq	s9,s3,ffffffffc02003b6 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200388:	003c9793          	slli	a5,s9,0x3
ffffffffc020038c:	0118                	addi	a4,sp,128
ffffffffc020038e:	97ba                	add	a5,a5,a4
ffffffffc0200390:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200394:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200398:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020039a:	e591                	bnez	a1,ffffffffc02003a6 <kmonitor+0x11e>
ffffffffc020039c:	b7b5                	j	ffffffffc0200308 <kmonitor+0x80>
ffffffffc020039e:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003a2:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a4:	d1a5                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc02003a6:	8526                	mv	a0,s1
ffffffffc02003a8:	3cb030ef          	jal	ra,ffffffffc0203f72 <strchr>
ffffffffc02003ac:	d96d                	beqz	a0,ffffffffc020039e <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ae:	00044583          	lbu	a1,0(s0)
ffffffffc02003b2:	d9a9                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc02003b4:	bf55                	j	ffffffffc0200368 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003b6:	45c1                	li	a1,16
ffffffffc02003b8:	855a                	mv	a0,s6
ffffffffc02003ba:	d01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003be:	b7e9                	j	ffffffffc0200388 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003c0:	6582                	ld	a1,0(sp)
ffffffffc02003c2:	00004517          	auipc	a0,0x4
ffffffffc02003c6:	2f650513          	addi	a0,a0,758 # ffffffffc02046b8 <etext+0x264>
ffffffffc02003ca:	cf1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    return 0;
ffffffffc02003ce:	b715                	j	ffffffffc02002f2 <kmonitor+0x6a>

ffffffffc02003d0 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02003d0:	8082                	ret

ffffffffc02003d2 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02003d2:	00253513          	sltiu	a0,a0,2
ffffffffc02003d6:	8082                	ret

ffffffffc02003d8 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02003d8:	03800513          	li	a0,56
ffffffffc02003dc:	8082                	ret

ffffffffc02003de <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003de:	0000a797          	auipc	a5,0xa
ffffffffc02003e2:	c6278793          	addi	a5,a5,-926 # ffffffffc020a040 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc02003e6:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02003ea:	1141                	addi	sp,sp,-16
ffffffffc02003ec:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003ee:	95be                	add	a1,a1,a5
ffffffffc02003f0:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02003f4:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003f6:	3a5030ef          	jal	ra,ffffffffc0203f9a <memcpy>
    return 0;
}
ffffffffc02003fa:	60a2                	ld	ra,8(sp)
ffffffffc02003fc:	4501                	li	a0,0
ffffffffc02003fe:	0141                	addi	sp,sp,16
ffffffffc0200400:	8082                	ret

ffffffffc0200402 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc0200402:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200406:	0000a517          	auipc	a0,0xa
ffffffffc020040a:	c3a50513          	addi	a0,a0,-966 # ffffffffc020a040 <ide>
                   size_t nsecs) {
ffffffffc020040e:	1141                	addi	sp,sp,-16
ffffffffc0200410:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200412:	953e                	add	a0,a0,a5
ffffffffc0200414:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc0200418:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020041a:	381030ef          	jal	ra,ffffffffc0203f9a <memcpy>
    return 0;
}
ffffffffc020041e:	60a2                	ld	ra,8(sp)
ffffffffc0200420:	4501                	li	a0,0
ffffffffc0200422:	0141                	addi	sp,sp,16
ffffffffc0200424:	8082                	ret

ffffffffc0200426 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200426:	67e1                	lui	a5,0x18
ffffffffc0200428:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020042c:	00011717          	auipc	a4,0x11
ffffffffc0200430:	0cf73e23          	sd	a5,220(a4) # ffffffffc0211508 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200434:	c0102573          	rdtime	a0
static inline void sbi_set_timer(uint64_t stime_value)
{
#if __riscv_xlen == 32
	SBI_CALL_2(SBI_SET_TIMER, stime_value, stime_value >> 32);
#else
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200438:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043a:	953e                	add	a0,a0,a5
ffffffffc020043c:	4601                	li	a2,0
ffffffffc020043e:	4881                	li	a7,0
ffffffffc0200440:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200444:	02000793          	li	a5,32
ffffffffc0200448:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020044c:	00004517          	auipc	a0,0x4
ffffffffc0200450:	2cc50513          	addi	a0,a0,716 # ffffffffc0204718 <commands+0x48>
    ticks = 0;
ffffffffc0200454:	00011797          	auipc	a5,0x11
ffffffffc0200458:	0a07b623          	sd	zero,172(a5) # ffffffffc0211500 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020045c:	b9b9                	j	ffffffffc02000ba <cprintf>

ffffffffc020045e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020045e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200462:	00011797          	auipc	a5,0x11
ffffffffc0200466:	0a67b783          	ld	a5,166(a5) # ffffffffc0211508 <timebase>
ffffffffc020046a:	953e                	add	a0,a0,a5
ffffffffc020046c:	4581                	li	a1,0
ffffffffc020046e:	4601                	li	a2,0
ffffffffc0200470:	4881                	li	a7,0
ffffffffc0200472:	00000073          	ecall
ffffffffc0200476:	8082                	ret

ffffffffc0200478 <cons_putc>:
#include <intr.h>
#include <mmu.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200478:	100027f3          	csrr	a5,sstatus
ffffffffc020047c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020047e:	0ff57513          	zext.b	a0,a0
ffffffffc0200482:	e799                	bnez	a5,ffffffffc0200490 <cons_putc+0x18>
ffffffffc0200484:	4581                	li	a1,0
ffffffffc0200486:	4601                	li	a2,0
ffffffffc0200488:	4885                	li	a7,1
ffffffffc020048a:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc020048e:	8082                	ret

/* cons_init - initializes the console devices */
void cons_init(void) {}

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200490:	1101                	addi	sp,sp,-32
ffffffffc0200492:	ec06                	sd	ra,24(sp)
ffffffffc0200494:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200496:	058000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020049a:	6522                	ld	a0,8(sp)
ffffffffc020049c:	4581                	li	a1,0
ffffffffc020049e:	4601                	li	a2,0
ffffffffc02004a0:	4885                	li	a7,1
ffffffffc02004a2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004a6:	60e2                	ld	ra,24(sp)
ffffffffc02004a8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004aa:	a83d                	j	ffffffffc02004e8 <intr_enable>

ffffffffc02004ac <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004ac:	100027f3          	csrr	a5,sstatus
ffffffffc02004b0:	8b89                	andi	a5,a5,2
ffffffffc02004b2:	eb89                	bnez	a5,ffffffffc02004c4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004b4:	4501                	li	a0,0
ffffffffc02004b6:	4581                	li	a1,0
ffffffffc02004b8:	4601                	li	a2,0
ffffffffc02004ba:	4889                	li	a7,2
ffffffffc02004bc:	00000073          	ecall
ffffffffc02004c0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02004c2:	8082                	ret
int cons_getc(void) {
ffffffffc02004c4:	1101                	addi	sp,sp,-32
ffffffffc02004c6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02004c8:	026000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02004cc:	4501                	li	a0,0
ffffffffc02004ce:	4581                	li	a1,0
ffffffffc02004d0:	4601                	li	a2,0
ffffffffc02004d2:	4889                	li	a7,2
ffffffffc02004d4:	00000073          	ecall
ffffffffc02004d8:	2501                	sext.w	a0,a0
ffffffffc02004da:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02004dc:	00c000ef          	jal	ra,ffffffffc02004e8 <intr_enable>
}
ffffffffc02004e0:	60e2                	ld	ra,24(sp)
ffffffffc02004e2:	6522                	ld	a0,8(sp)
ffffffffc02004e4:	6105                	addi	sp,sp,32
ffffffffc02004e6:	8082                	ret

ffffffffc02004e8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004e8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004ec:	8082                	ret

ffffffffc02004ee <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004ee:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02004f4:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc02004f8:	1141                	addi	sp,sp,-16
ffffffffc02004fa:	e022                	sd	s0,0(sp)
ffffffffc02004fc:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02004fe:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200502:	11053583          	ld	a1,272(a0)
static int pgfault_handler(struct trapframe *tf) {
ffffffffc0200506:	842a                	mv	s0,a0
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200508:	05500613          	li	a2,85
ffffffffc020050c:	c399                	beqz	a5,ffffffffc0200512 <pgfault_handler+0x1e>
ffffffffc020050e:	04b00613          	li	a2,75
ffffffffc0200512:	11843703          	ld	a4,280(s0)
ffffffffc0200516:	47bd                	li	a5,15
ffffffffc0200518:	05700693          	li	a3,87
ffffffffc020051c:	00f70463          	beq	a4,a5,ffffffffc0200524 <pgfault_handler+0x30>
ffffffffc0200520:	05200693          	li	a3,82
ffffffffc0200524:	00004517          	auipc	a0,0x4
ffffffffc0200528:	21450513          	addi	a0,a0,532 # ffffffffc0204738 <commands+0x68>
ffffffffc020052c:	b8fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc0200530:	00011517          	auipc	a0,0x11
ffffffffc0200534:	fe853503          	ld	a0,-24(a0) # ffffffffc0211518 <check_mm_struct>
ffffffffc0200538:	c911                	beqz	a0,ffffffffc020054c <pgfault_handler+0x58>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc020053a:	11043603          	ld	a2,272(s0)
ffffffffc020053e:	11843583          	ld	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc0200542:	6402                	ld	s0,0(sp)
ffffffffc0200544:	60a2                	ld	ra,8(sp)
ffffffffc0200546:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200548:	5810006f          	j	ffffffffc02012c8 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc020054c:	00004617          	auipc	a2,0x4
ffffffffc0200550:	20c60613          	addi	a2,a2,524 # ffffffffc0204758 <commands+0x88>
ffffffffc0200554:	07900593          	li	a1,121
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	21850513          	addi	a0,a0,536 # ffffffffc0204770 <commands+0xa0>
ffffffffc0200560:	ba3ff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200564 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200564:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc0200568:	00000797          	auipc	a5,0x0
ffffffffc020056c:	4e878793          	addi	a5,a5,1256 # ffffffffc0200a50 <__alltraps>
ffffffffc0200570:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SIE);
ffffffffc0200574:	100167f3          	csrrsi	a5,sstatus,2
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200578:	000407b7          	lui	a5,0x40
ffffffffc020057c:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200580:	8082                	ret

ffffffffc0200582 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200582:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200584:	1141                	addi	sp,sp,-16
ffffffffc0200586:	e022                	sd	s0,0(sp)
ffffffffc0200588:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020058a:	00004517          	auipc	a0,0x4
ffffffffc020058e:	1fe50513          	addi	a0,a0,510 # ffffffffc0204788 <commands+0xb8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200592:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200594:	b27ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200598:	640c                	ld	a1,8(s0)
ffffffffc020059a:	00004517          	auipc	a0,0x4
ffffffffc020059e:	20650513          	addi	a0,a0,518 # ffffffffc02047a0 <commands+0xd0>
ffffffffc02005a2:	b19ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005a6:	680c                	ld	a1,16(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	21050513          	addi	a0,a0,528 # ffffffffc02047b8 <commands+0xe8>
ffffffffc02005b0:	b0bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005b4:	6c0c                	ld	a1,24(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	21a50513          	addi	a0,a0,538 # ffffffffc02047d0 <commands+0x100>
ffffffffc02005be:	afdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005c2:	700c                	ld	a1,32(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	22450513          	addi	a0,a0,548 # ffffffffc02047e8 <commands+0x118>
ffffffffc02005cc:	aefff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005d0:	740c                	ld	a1,40(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	22e50513          	addi	a0,a0,558 # ffffffffc0204800 <commands+0x130>
ffffffffc02005da:	ae1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005de:	780c                	ld	a1,48(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	23850513          	addi	a0,a0,568 # ffffffffc0204818 <commands+0x148>
ffffffffc02005e8:	ad3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005ec:	7c0c                	ld	a1,56(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	24250513          	addi	a0,a0,578 # ffffffffc0204830 <commands+0x160>
ffffffffc02005f6:	ac5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02005fa:	602c                	ld	a1,64(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	24c50513          	addi	a0,a0,588 # ffffffffc0204848 <commands+0x178>
ffffffffc0200604:	ab7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200608:	642c                	ld	a1,72(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	25650513          	addi	a0,a0,598 # ffffffffc0204860 <commands+0x190>
ffffffffc0200612:	aa9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200616:	682c                	ld	a1,80(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	26050513          	addi	a0,a0,608 # ffffffffc0204878 <commands+0x1a8>
ffffffffc0200620:	a9bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200624:	6c2c                	ld	a1,88(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	26a50513          	addi	a0,a0,618 # ffffffffc0204890 <commands+0x1c0>
ffffffffc020062e:	a8dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200632:	702c                	ld	a1,96(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	27450513          	addi	a0,a0,628 # ffffffffc02048a8 <commands+0x1d8>
ffffffffc020063c:	a7fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200640:	742c                	ld	a1,104(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	27e50513          	addi	a0,a0,638 # ffffffffc02048c0 <commands+0x1f0>
ffffffffc020064a:	a71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020064e:	782c                	ld	a1,112(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	28850513          	addi	a0,a0,648 # ffffffffc02048d8 <commands+0x208>
ffffffffc0200658:	a63ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020065c:	7c2c                	ld	a1,120(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	29250513          	addi	a0,a0,658 # ffffffffc02048f0 <commands+0x220>
ffffffffc0200666:	a55ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020066a:	604c                	ld	a1,128(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	29c50513          	addi	a0,a0,668 # ffffffffc0204908 <commands+0x238>
ffffffffc0200674:	a47ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200678:	644c                	ld	a1,136(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	2a650513          	addi	a0,a0,678 # ffffffffc0204920 <commands+0x250>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200686:	684c                	ld	a1,144(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	2b050513          	addi	a0,a0,688 # ffffffffc0204938 <commands+0x268>
ffffffffc0200690:	a2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200694:	6c4c                	ld	a1,152(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	2ba50513          	addi	a0,a0,698 # ffffffffc0204950 <commands+0x280>
ffffffffc020069e:	a1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006a2:	704c                	ld	a1,160(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	2c450513          	addi	a0,a0,708 # ffffffffc0204968 <commands+0x298>
ffffffffc02006ac:	a0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006b0:	744c                	ld	a1,168(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	2ce50513          	addi	a0,a0,718 # ffffffffc0204980 <commands+0x2b0>
ffffffffc02006ba:	a01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006be:	784c                	ld	a1,176(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	2d850513          	addi	a0,a0,728 # ffffffffc0204998 <commands+0x2c8>
ffffffffc02006c8:	9f3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006cc:	7c4c                	ld	a1,184(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	2e250513          	addi	a0,a0,738 # ffffffffc02049b0 <commands+0x2e0>
ffffffffc02006d6:	9e5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006da:	606c                	ld	a1,192(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	2ec50513          	addi	a0,a0,748 # ffffffffc02049c8 <commands+0x2f8>
ffffffffc02006e4:	9d7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006e8:	646c                	ld	a1,200(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	2f650513          	addi	a0,a0,758 # ffffffffc02049e0 <commands+0x310>
ffffffffc02006f2:	9c9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02006f6:	686c                	ld	a1,208(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	30050513          	addi	a0,a0,768 # ffffffffc02049f8 <commands+0x328>
ffffffffc0200700:	9bbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200704:	6c6c                	ld	a1,216(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	30a50513          	addi	a0,a0,778 # ffffffffc0204a10 <commands+0x340>
ffffffffc020070e:	9adff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200712:	706c                	ld	a1,224(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	31450513          	addi	a0,a0,788 # ffffffffc0204a28 <commands+0x358>
ffffffffc020071c:	99fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200720:	746c                	ld	a1,232(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	31e50513          	addi	a0,a0,798 # ffffffffc0204a40 <commands+0x370>
ffffffffc020072a:	991ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020072e:	786c                	ld	a1,240(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	32850513          	addi	a0,a0,808 # ffffffffc0204a58 <commands+0x388>
ffffffffc0200738:	983ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020073c:	7c6c                	ld	a1,248(s0)
}
ffffffffc020073e:	6402                	ld	s0,0(sp)
ffffffffc0200740:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	32e50513          	addi	a0,a0,814 # ffffffffc0204a70 <commands+0x3a0>
}
ffffffffc020074a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020074c:	b2bd                	j	ffffffffc02000ba <cprintf>

ffffffffc020074e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020074e:	1141                	addi	sp,sp,-16
ffffffffc0200750:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200752:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200754:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200756:	00004517          	auipc	a0,0x4
ffffffffc020075a:	33250513          	addi	a0,a0,818 # ffffffffc0204a88 <commands+0x3b8>
void print_trapframe(struct trapframe *tf) {
ffffffffc020075e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200760:	95bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200764:	8522                	mv	a0,s0
ffffffffc0200766:	e1dff0ef          	jal	ra,ffffffffc0200582 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020076a:	10043583          	ld	a1,256(s0)
ffffffffc020076e:	00004517          	auipc	a0,0x4
ffffffffc0200772:	33250513          	addi	a0,a0,818 # ffffffffc0204aa0 <commands+0x3d0>
ffffffffc0200776:	945ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020077a:	10843583          	ld	a1,264(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	33a50513          	addi	a0,a0,826 # ffffffffc0204ab8 <commands+0x3e8>
ffffffffc0200786:	935ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020078a:	11043583          	ld	a1,272(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	34250513          	addi	a0,a0,834 # ffffffffc0204ad0 <commands+0x400>
ffffffffc0200796:	925ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020079a:	11843583          	ld	a1,280(s0)
}
ffffffffc020079e:	6402                	ld	s0,0(sp)
ffffffffc02007a0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a2:	00004517          	auipc	a0,0x4
ffffffffc02007a6:	34650513          	addi	a0,a0,838 # ffffffffc0204ae8 <commands+0x418>
}
ffffffffc02007aa:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007ac:	90fff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc02007b0 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02007b0:	11853783          	ld	a5,280(a0)
ffffffffc02007b4:	472d                	li	a4,11
ffffffffc02007b6:	0786                	slli	a5,a5,0x1
ffffffffc02007b8:	8385                	srli	a5,a5,0x1
ffffffffc02007ba:	08f76c63          	bltu	a4,a5,ffffffffc0200852 <interrupt_handler+0xa2>
ffffffffc02007be:	00004717          	auipc	a4,0x4
ffffffffc02007c2:	3f270713          	addi	a4,a4,1010 # ffffffffc0204bb0 <commands+0x4e0>
ffffffffc02007c6:	078a                	slli	a5,a5,0x2
ffffffffc02007c8:	97ba                	add	a5,a5,a4
ffffffffc02007ca:	439c                	lw	a5,0(a5)
ffffffffc02007cc:	97ba                	add	a5,a5,a4
ffffffffc02007ce:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02007d0:	00004517          	auipc	a0,0x4
ffffffffc02007d4:	39050513          	addi	a0,a0,912 # ffffffffc0204b60 <commands+0x490>
ffffffffc02007d8:	8e3ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007dc:	00004517          	auipc	a0,0x4
ffffffffc02007e0:	36450513          	addi	a0,a0,868 # ffffffffc0204b40 <commands+0x470>
ffffffffc02007e4:	8d7ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007e8:	00004517          	auipc	a0,0x4
ffffffffc02007ec:	31850513          	addi	a0,a0,792 # ffffffffc0204b00 <commands+0x430>
ffffffffc02007f0:	8cbff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	32c50513          	addi	a0,a0,812 # ffffffffc0204b20 <commands+0x450>
ffffffffc02007fc:	8bfff06f          	j	ffffffffc02000ba <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200800:	1141                	addi	sp,sp,-16
ffffffffc0200802:	e022                	sd	s0,0(sp)
ffffffffc0200804:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc0200806:	c59ff0ef          	jal	ra,ffffffffc020045e <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc020080a:	00011697          	auipc	a3,0x11
ffffffffc020080e:	cf668693          	addi	a3,a3,-778 # ffffffffc0211500 <ticks>
ffffffffc0200812:	629c                	ld	a5,0(a3)
ffffffffc0200814:	06400713          	li	a4,100
ffffffffc0200818:	00011417          	auipc	s0,0x11
ffffffffc020081c:	cf840413          	addi	s0,s0,-776 # ffffffffc0211510 <num>
ffffffffc0200820:	0785                	addi	a5,a5,1
ffffffffc0200822:	02e7f733          	remu	a4,a5,a4
ffffffffc0200826:	e29c                	sd	a5,0(a3)
ffffffffc0200828:	c715                	beqz	a4,ffffffffc0200854 <interrupt_handler+0xa4>
                print_ticks();
                ticks = 0;
                ++num;
            }
            if(num == 10){
ffffffffc020082a:	6018                	ld	a4,0(s0)
ffffffffc020082c:	47a9                	li	a5,10
ffffffffc020082e:	00f71863          	bne	a4,a5,ffffffffc020083e <interrupt_handler+0x8e>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200832:	4501                	li	a0,0
ffffffffc0200834:	4581                	li	a1,0
ffffffffc0200836:	4601                	li	a2,0
ffffffffc0200838:	48a1                	li	a7,8
ffffffffc020083a:	00000073          	ecall
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc020083e:	60a2                	ld	ra,8(sp)
ffffffffc0200840:	6402                	ld	s0,0(sp)
ffffffffc0200842:	0141                	addi	sp,sp,16
ffffffffc0200844:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200846:	00004517          	auipc	a0,0x4
ffffffffc020084a:	34a50513          	addi	a0,a0,842 # ffffffffc0204b90 <commands+0x4c0>
ffffffffc020084e:	86dff06f          	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc0200852:	bdf5                	j	ffffffffc020074e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200854:	06400593          	li	a1,100
ffffffffc0200858:	00004517          	auipc	a0,0x4
ffffffffc020085c:	32850513          	addi	a0,a0,808 # ffffffffc0204b80 <commands+0x4b0>
ffffffffc0200860:	85bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
                ticks = 0;
ffffffffc0200864:	00011797          	auipc	a5,0x11
ffffffffc0200868:	c807be23          	sd	zero,-868(a5) # ffffffffc0211500 <ticks>
                ++num;
ffffffffc020086c:	601c                	ld	a5,0(s0)
ffffffffc020086e:	0785                	addi	a5,a5,1
ffffffffc0200870:	e01c                	sd	a5,0(s0)
ffffffffc0200872:	bf65                	j	ffffffffc020082a <interrupt_handler+0x7a>

ffffffffc0200874 <exception_handler>:


void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200874:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200878:	1101                	addi	sp,sp,-32
ffffffffc020087a:	e822                	sd	s0,16(sp)
ffffffffc020087c:	ec06                	sd	ra,24(sp)
ffffffffc020087e:	e426                	sd	s1,8(sp)
ffffffffc0200880:	473d                	li	a4,15
ffffffffc0200882:	842a                	mv	s0,a0
ffffffffc0200884:	18f76963          	bltu	a4,a5,ffffffffc0200a16 <exception_handler+0x1a2>
ffffffffc0200888:	00004717          	auipc	a4,0x4
ffffffffc020088c:	55870713          	addi	a4,a4,1368 # ffffffffc0204de0 <commands+0x710>
ffffffffc0200890:	078a                	slli	a5,a5,0x2
ffffffffc0200892:	97ba                	add	a5,a5,a4
ffffffffc0200894:	439c                	lw	a5,0(a5)
ffffffffc0200896:	97ba                	add	a5,a5,a4
ffffffffc0200898:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc020089a:	00004517          	auipc	a0,0x4
ffffffffc020089e:	52e50513          	addi	a0,a0,1326 # ffffffffc0204dc8 <commands+0x6f8>
ffffffffc02008a2:	819ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02008a6:	8522                	mv	a0,s0
ffffffffc02008a8:	c4dff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc02008ac:	84aa                	mv	s1,a0
ffffffffc02008ae:	16051a63          	bnez	a0,ffffffffc0200a22 <exception_handler+0x1ae>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02008b2:	60e2                	ld	ra,24(sp)
ffffffffc02008b4:	6442                	ld	s0,16(sp)
ffffffffc02008b6:	64a2                	ld	s1,8(sp)
ffffffffc02008b8:	6105                	addi	sp,sp,32
ffffffffc02008ba:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc02008bc:	00004517          	auipc	a0,0x4
ffffffffc02008c0:	32450513          	addi	a0,a0,804 # ffffffffc0204be0 <commands+0x510>
}
ffffffffc02008c4:	6442                	ld	s0,16(sp)
ffffffffc02008c6:	60e2                	ld	ra,24(sp)
ffffffffc02008c8:	64a2                	ld	s1,8(sp)
ffffffffc02008ca:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008cc:	feeff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02008d0:	00004517          	auipc	a0,0x4
ffffffffc02008d4:	33050513          	addi	a0,a0,816 # ffffffffc0204c00 <commands+0x530>
ffffffffc02008d8:	b7f5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("exception type:Illegal instruction\n");
ffffffffc02008da:	00004517          	auipc	a0,0x4
ffffffffc02008de:	34650513          	addi	a0,a0,838 # ffffffffc0204c20 <commands+0x550>
ffffffffc02008e2:	fd8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc02008e6:	10843583          	ld	a1,264(s0)
ffffffffc02008ea:	00004517          	auipc	a0,0x4
ffffffffc02008ee:	35e50513          	addi	a0,a0,862 # ffffffffc0204c48 <commands+0x578>
ffffffffc02008f2:	fc8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 4;//跳过导致异常的指令
ffffffffc02008f6:	10843783          	ld	a5,264(s0)
ffffffffc02008fa:	0791                	addi	a5,a5,4
ffffffffc02008fc:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc0200900:	bf4d                	j	ffffffffc02008b2 <exception_handler+0x3e>
            cprintf("exception type:breakpoint\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	36e50513          	addi	a0,a0,878 # ffffffffc0204c70 <commands+0x5a0>
ffffffffc020090a:	fb0ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc020090e:	10843583          	ld	a1,264(s0)
ffffffffc0200912:	00004517          	auipc	a0,0x4
ffffffffc0200916:	33650513          	addi	a0,a0,822 # ffffffffc0204c48 <commands+0x578>
ffffffffc020091a:	fa0ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 2;//跳过导致异常的指令
ffffffffc020091e:	10843783          	ld	a5,264(s0)
ffffffffc0200922:	0789                	addi	a5,a5,2
ffffffffc0200924:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc0200928:	b769                	j	ffffffffc02008b2 <exception_handler+0x3e>
            cprintf("Load address misaligned\n");
ffffffffc020092a:	00004517          	auipc	a0,0x4
ffffffffc020092e:	36650513          	addi	a0,a0,870 # ffffffffc0204c90 <commands+0x5c0>
ffffffffc0200932:	bf49                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200934:	00004517          	auipc	a0,0x4
ffffffffc0200938:	37c50513          	addi	a0,a0,892 # ffffffffc0204cb0 <commands+0x5e0>
ffffffffc020093c:	f7eff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200940:	8522                	mv	a0,s0
ffffffffc0200942:	bb3ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200946:	84aa                	mv	s1,a0
ffffffffc0200948:	d52d                	beqz	a0,ffffffffc02008b2 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc020094a:	8522                	mv	a0,s0
ffffffffc020094c:	e03ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200950:	86a6                	mv	a3,s1
ffffffffc0200952:	00004617          	auipc	a2,0x4
ffffffffc0200956:	37660613          	addi	a2,a2,886 # ffffffffc0204cc8 <commands+0x5f8>
ffffffffc020095a:	0d600593          	li	a1,214
ffffffffc020095e:	00004517          	auipc	a0,0x4
ffffffffc0200962:	e1250513          	addi	a0,a0,-494 # ffffffffc0204770 <commands+0xa0>
ffffffffc0200966:	f9cff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	37e50513          	addi	a0,a0,894 # ffffffffc0204ce8 <commands+0x618>
ffffffffc0200972:	bf89                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	38c50513          	addi	a0,a0,908 # ffffffffc0204d00 <commands+0x630>
ffffffffc020097c:	f3eff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200980:	8522                	mv	a0,s0
ffffffffc0200982:	b73ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200986:	84aa                	mv	s1,a0
ffffffffc0200988:	f20505e3          	beqz	a0,ffffffffc02008b2 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc020098c:	8522                	mv	a0,s0
ffffffffc020098e:	dc1ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200992:	86a6                	mv	a3,s1
ffffffffc0200994:	00004617          	auipc	a2,0x4
ffffffffc0200998:	33460613          	addi	a2,a2,820 # ffffffffc0204cc8 <commands+0x5f8>
ffffffffc020099c:	0e000593          	li	a1,224
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	dd050513          	addi	a0,a0,-560 # ffffffffc0204770 <commands+0xa0>
ffffffffc02009a8:	f5aff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc02009ac:	00004517          	auipc	a0,0x4
ffffffffc02009b0:	36c50513          	addi	a0,a0,876 # ffffffffc0204d18 <commands+0x648>
ffffffffc02009b4:	bf01                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc02009b6:	00004517          	auipc	a0,0x4
ffffffffc02009ba:	38250513          	addi	a0,a0,898 # ffffffffc0204d38 <commands+0x668>
ffffffffc02009be:	b719                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc02009c0:	00004517          	auipc	a0,0x4
ffffffffc02009c4:	39850513          	addi	a0,a0,920 # ffffffffc0204d58 <commands+0x688>
ffffffffc02009c8:	bdf5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc02009ca:	00004517          	auipc	a0,0x4
ffffffffc02009ce:	3ae50513          	addi	a0,a0,942 # ffffffffc0204d78 <commands+0x6a8>
ffffffffc02009d2:	bdcd                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	3c450513          	addi	a0,a0,964 # ffffffffc0204d98 <commands+0x6c8>
ffffffffc02009dc:	b5e5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc02009de:	00004517          	auipc	a0,0x4
ffffffffc02009e2:	3d250513          	addi	a0,a0,978 # ffffffffc0204db0 <commands+0x6e0>
ffffffffc02009e6:	ed4ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02009ea:	8522                	mv	a0,s0
ffffffffc02009ec:	b09ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc02009f0:	84aa                	mv	s1,a0
ffffffffc02009f2:	ec0500e3          	beqz	a0,ffffffffc02008b2 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009f6:	8522                	mv	a0,s0
ffffffffc02009f8:	d57ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009fc:	86a6                	mv	a3,s1
ffffffffc02009fe:	00004617          	auipc	a2,0x4
ffffffffc0200a02:	2ca60613          	addi	a2,a2,714 # ffffffffc0204cc8 <commands+0x5f8>
ffffffffc0200a06:	0f600593          	li	a1,246
ffffffffc0200a0a:	00004517          	auipc	a0,0x4
ffffffffc0200a0e:	d6650513          	addi	a0,a0,-666 # ffffffffc0204770 <commands+0xa0>
ffffffffc0200a12:	ef0ff0ef          	jal	ra,ffffffffc0200102 <__panic>
            print_trapframe(tf);
ffffffffc0200a16:	8522                	mv	a0,s0
}
ffffffffc0200a18:	6442                	ld	s0,16(sp)
ffffffffc0200a1a:	60e2                	ld	ra,24(sp)
ffffffffc0200a1c:	64a2                	ld	s1,8(sp)
ffffffffc0200a1e:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200a20:	b33d                	j	ffffffffc020074e <print_trapframe>
                print_trapframe(tf);
ffffffffc0200a22:	8522                	mv	a0,s0
ffffffffc0200a24:	d2bff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a28:	86a6                	mv	a3,s1
ffffffffc0200a2a:	00004617          	auipc	a2,0x4
ffffffffc0200a2e:	29e60613          	addi	a2,a2,670 # ffffffffc0204cc8 <commands+0x5f8>
ffffffffc0200a32:	0fd00593          	li	a1,253
ffffffffc0200a36:	00004517          	auipc	a0,0x4
ffffffffc0200a3a:	d3a50513          	addi	a0,a0,-710 # ffffffffc0204770 <commands+0xa0>
ffffffffc0200a3e:	ec4ff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200a42 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200a42:	11853783          	ld	a5,280(a0)
ffffffffc0200a46:	0007c363          	bltz	a5,ffffffffc0200a4c <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200a4a:	b52d                	j	ffffffffc0200874 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200a4c:	b395                	j	ffffffffc02007b0 <interrupt_handler>
	...

ffffffffc0200a50 <__alltraps>:
    .endm

    .align 4
    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200a50:	14011073          	csrw	sscratch,sp
ffffffffc0200a54:	712d                	addi	sp,sp,-288
ffffffffc0200a56:	e406                	sd	ra,8(sp)
ffffffffc0200a58:	ec0e                	sd	gp,24(sp)
ffffffffc0200a5a:	f012                	sd	tp,32(sp)
ffffffffc0200a5c:	f416                	sd	t0,40(sp)
ffffffffc0200a5e:	f81a                	sd	t1,48(sp)
ffffffffc0200a60:	fc1e                	sd	t2,56(sp)
ffffffffc0200a62:	e0a2                	sd	s0,64(sp)
ffffffffc0200a64:	e4a6                	sd	s1,72(sp)
ffffffffc0200a66:	e8aa                	sd	a0,80(sp)
ffffffffc0200a68:	ecae                	sd	a1,88(sp)
ffffffffc0200a6a:	f0b2                	sd	a2,96(sp)
ffffffffc0200a6c:	f4b6                	sd	a3,104(sp)
ffffffffc0200a6e:	f8ba                	sd	a4,112(sp)
ffffffffc0200a70:	fcbe                	sd	a5,120(sp)
ffffffffc0200a72:	e142                	sd	a6,128(sp)
ffffffffc0200a74:	e546                	sd	a7,136(sp)
ffffffffc0200a76:	e94a                	sd	s2,144(sp)
ffffffffc0200a78:	ed4e                	sd	s3,152(sp)
ffffffffc0200a7a:	f152                	sd	s4,160(sp)
ffffffffc0200a7c:	f556                	sd	s5,168(sp)
ffffffffc0200a7e:	f95a                	sd	s6,176(sp)
ffffffffc0200a80:	fd5e                	sd	s7,184(sp)
ffffffffc0200a82:	e1e2                	sd	s8,192(sp)
ffffffffc0200a84:	e5e6                	sd	s9,200(sp)
ffffffffc0200a86:	e9ea                	sd	s10,208(sp)
ffffffffc0200a88:	edee                	sd	s11,216(sp)
ffffffffc0200a8a:	f1f2                	sd	t3,224(sp)
ffffffffc0200a8c:	f5f6                	sd	t4,232(sp)
ffffffffc0200a8e:	f9fa                	sd	t5,240(sp)
ffffffffc0200a90:	fdfe                	sd	t6,248(sp)
ffffffffc0200a92:	14002473          	csrr	s0,sscratch
ffffffffc0200a96:	100024f3          	csrr	s1,sstatus
ffffffffc0200a9a:	14102973          	csrr	s2,sepc
ffffffffc0200a9e:	143029f3          	csrr	s3,stval
ffffffffc0200aa2:	14202a73          	csrr	s4,scause
ffffffffc0200aa6:	e822                	sd	s0,16(sp)
ffffffffc0200aa8:	e226                	sd	s1,256(sp)
ffffffffc0200aaa:	e64a                	sd	s2,264(sp)
ffffffffc0200aac:	ea4e                	sd	s3,272(sp)
ffffffffc0200aae:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ab0:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ab2:	f91ff0ef          	jal	ra,ffffffffc0200a42 <trap>

ffffffffc0200ab6 <__trapret>:
    // sp should be the same as before "jal trap"
    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ab6:	6492                	ld	s1,256(sp)
ffffffffc0200ab8:	6932                	ld	s2,264(sp)
ffffffffc0200aba:	10049073          	csrw	sstatus,s1
ffffffffc0200abe:	14191073          	csrw	sepc,s2
ffffffffc0200ac2:	60a2                	ld	ra,8(sp)
ffffffffc0200ac4:	61e2                	ld	gp,24(sp)
ffffffffc0200ac6:	7202                	ld	tp,32(sp)
ffffffffc0200ac8:	72a2                	ld	t0,40(sp)
ffffffffc0200aca:	7342                	ld	t1,48(sp)
ffffffffc0200acc:	73e2                	ld	t2,56(sp)
ffffffffc0200ace:	6406                	ld	s0,64(sp)
ffffffffc0200ad0:	64a6                	ld	s1,72(sp)
ffffffffc0200ad2:	6546                	ld	a0,80(sp)
ffffffffc0200ad4:	65e6                	ld	a1,88(sp)
ffffffffc0200ad6:	7606                	ld	a2,96(sp)
ffffffffc0200ad8:	76a6                	ld	a3,104(sp)
ffffffffc0200ada:	7746                	ld	a4,112(sp)
ffffffffc0200adc:	77e6                	ld	a5,120(sp)
ffffffffc0200ade:	680a                	ld	a6,128(sp)
ffffffffc0200ae0:	68aa                	ld	a7,136(sp)
ffffffffc0200ae2:	694a                	ld	s2,144(sp)
ffffffffc0200ae4:	69ea                	ld	s3,152(sp)
ffffffffc0200ae6:	7a0a                	ld	s4,160(sp)
ffffffffc0200ae8:	7aaa                	ld	s5,168(sp)
ffffffffc0200aea:	7b4a                	ld	s6,176(sp)
ffffffffc0200aec:	7bea                	ld	s7,184(sp)
ffffffffc0200aee:	6c0e                	ld	s8,192(sp)
ffffffffc0200af0:	6cae                	ld	s9,200(sp)
ffffffffc0200af2:	6d4e                	ld	s10,208(sp)
ffffffffc0200af4:	6dee                	ld	s11,216(sp)
ffffffffc0200af6:	7e0e                	ld	t3,224(sp)
ffffffffc0200af8:	7eae                	ld	t4,232(sp)
ffffffffc0200afa:	7f4e                	ld	t5,240(sp)
ffffffffc0200afc:	7fee                	ld	t6,248(sp)
ffffffffc0200afe:	6142                	ld	sp,16(sp)
    // go back from supervisor call
    sret
ffffffffc0200b00:	10200073          	sret
	...

ffffffffc0200b10 <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0200b10:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0200b12:	00004697          	auipc	a3,0x4
ffffffffc0200b16:	30e68693          	addi	a3,a3,782 # ffffffffc0204e20 <commands+0x750>
ffffffffc0200b1a:	00004617          	auipc	a2,0x4
ffffffffc0200b1e:	32660613          	addi	a2,a2,806 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200b22:	07d00593          	li	a1,125
ffffffffc0200b26:	00004517          	auipc	a0,0x4
ffffffffc0200b2a:	33250513          	addi	a0,a0,818 # ffffffffc0204e58 <commands+0x788>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0200b2e:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0200b30:	dd2ff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200b34 <mm_create>:
mm_create(void) {
ffffffffc0200b34:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200b36:	03000513          	li	a0,48
mm_create(void) {
ffffffffc0200b3a:	e022                	sd	s0,0(sp)
ffffffffc0200b3c:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200b3e:	0c0030ef          	jal	ra,ffffffffc0203bfe <kmalloc>
ffffffffc0200b42:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0200b44:	c105                	beqz	a0,ffffffffc0200b64 <mm_create+0x30>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200b46:	e408                	sd	a0,8(s0)
ffffffffc0200b48:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0200b4a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200b4e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200b52:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200b56:	00011797          	auipc	a5,0x11
ffffffffc0200b5a:	9ea7a783          	lw	a5,-1558(a5) # ffffffffc0211540 <swap_init_ok>
ffffffffc0200b5e:	eb81                	bnez	a5,ffffffffc0200b6e <mm_create+0x3a>
        else mm->sm_priv = NULL;
ffffffffc0200b60:	02053423          	sd	zero,40(a0)
}
ffffffffc0200b64:	60a2                	ld	ra,8(sp)
ffffffffc0200b66:	8522                	mv	a0,s0
ffffffffc0200b68:	6402                	ld	s0,0(sp)
ffffffffc0200b6a:	0141                	addi	sp,sp,16
ffffffffc0200b6c:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200b6e:	222010ef          	jal	ra,ffffffffc0201d90 <swap_init_mm>
}
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
ffffffffc0200b74:	8522                	mv	a0,s0
ffffffffc0200b76:	6402                	ld	s0,0(sp)
ffffffffc0200b78:	0141                	addi	sp,sp,16
ffffffffc0200b7a:	8082                	ret

ffffffffc0200b7c <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0200b7c:	1101                	addi	sp,sp,-32
ffffffffc0200b7e:	e04a                	sd	s2,0(sp)
ffffffffc0200b80:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200b82:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0200b86:	e822                	sd	s0,16(sp)
ffffffffc0200b88:	e426                	sd	s1,8(sp)
ffffffffc0200b8a:	ec06                	sd	ra,24(sp)
ffffffffc0200b8c:	84ae                	mv	s1,a1
ffffffffc0200b8e:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200b90:	06e030ef          	jal	ra,ffffffffc0203bfe <kmalloc>
    if (vma != NULL) {
ffffffffc0200b94:	c509                	beqz	a0,ffffffffc0200b9e <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0200b96:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200b9a:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200b9c:	ed00                	sd	s0,24(a0)
}
ffffffffc0200b9e:	60e2                	ld	ra,24(sp)
ffffffffc0200ba0:	6442                	ld	s0,16(sp)
ffffffffc0200ba2:	64a2                	ld	s1,8(sp)
ffffffffc0200ba4:	6902                	ld	s2,0(sp)
ffffffffc0200ba6:	6105                	addi	sp,sp,32
ffffffffc0200ba8:	8082                	ret

ffffffffc0200baa <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0200baa:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0200bac:	c505                	beqz	a0,ffffffffc0200bd4 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0200bae:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0200bb0:	c501                	beqz	a0,ffffffffc0200bb8 <find_vma+0xe>
ffffffffc0200bb2:	651c                	ld	a5,8(a0)
ffffffffc0200bb4:	02f5f263          	bgeu	a1,a5,ffffffffc0200bd8 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200bb8:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0200bba:	00f68d63          	beq	a3,a5,ffffffffc0200bd4 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0200bbe:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200bc2:	00e5e663          	bltu	a1,a4,ffffffffc0200bce <find_vma+0x24>
ffffffffc0200bc6:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200bca:	00e5ec63          	bltu	a1,a4,ffffffffc0200be2 <find_vma+0x38>
ffffffffc0200bce:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0200bd0:	fef697e3          	bne	a3,a5,ffffffffc0200bbe <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0200bd4:	4501                	li	a0,0
}
ffffffffc0200bd6:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0200bd8:	691c                	ld	a5,16(a0)
ffffffffc0200bda:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0200bb8 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0200bde:	ea88                	sd	a0,16(a3)
ffffffffc0200be0:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0200be2:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0200be6:	ea88                	sd	a0,16(a3)
ffffffffc0200be8:	8082                	ret

ffffffffc0200bea <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200bea:	6590                	ld	a2,8(a1)
ffffffffc0200bec:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0200bf0:	1141                	addi	sp,sp,-16
ffffffffc0200bf2:	e406                	sd	ra,8(sp)
ffffffffc0200bf4:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200bf6:	01066763          	bltu	a2,a6,ffffffffc0200c04 <insert_vma_struct+0x1a>
ffffffffc0200bfa:	a085                	j	ffffffffc0200c5a <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0200bfc:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200c00:	04e66863          	bltu	a2,a4,ffffffffc0200c50 <insert_vma_struct+0x66>
ffffffffc0200c04:	86be                	mv	a3,a5
ffffffffc0200c06:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0200c08:	fef51ae3          	bne	a0,a5,ffffffffc0200bfc <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0200c0c:	02a68463          	beq	a3,a0,ffffffffc0200c34 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0200c10:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200c14:	fe86b883          	ld	a7,-24(a3)
ffffffffc0200c18:	08e8f163          	bgeu	a7,a4,ffffffffc0200c9a <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c1c:	04e66f63          	bltu	a2,a4,ffffffffc0200c7a <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0200c20:	00f50a63          	beq	a0,a5,ffffffffc0200c34 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0200c24:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c28:	05076963          	bltu	a4,a6,ffffffffc0200c7a <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0200c2c:	ff07b603          	ld	a2,-16(a5)
ffffffffc0200c30:	02c77363          	bgeu	a4,a2,ffffffffc0200c56 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0200c34:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0200c36:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0200c38:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200c3c:	e390                	sd	a2,0(a5)
ffffffffc0200c3e:	e690                	sd	a2,8(a3)
}
ffffffffc0200c40:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0200c42:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0200c44:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0200c46:	0017079b          	addiw	a5,a4,1
ffffffffc0200c4a:	d11c                	sw	a5,32(a0)
}
ffffffffc0200c4c:	0141                	addi	sp,sp,16
ffffffffc0200c4e:	8082                	ret
    if (le_prev != list) {
ffffffffc0200c50:	fca690e3          	bne	a3,a0,ffffffffc0200c10 <insert_vma_struct+0x26>
ffffffffc0200c54:	bfd1                	j	ffffffffc0200c28 <insert_vma_struct+0x3e>
ffffffffc0200c56:	ebbff0ef          	jal	ra,ffffffffc0200b10 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200c5a:	00004697          	auipc	a3,0x4
ffffffffc0200c5e:	20e68693          	addi	a3,a3,526 # ffffffffc0204e68 <commands+0x798>
ffffffffc0200c62:	00004617          	auipc	a2,0x4
ffffffffc0200c66:	1de60613          	addi	a2,a2,478 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200c6a:	08400593          	li	a1,132
ffffffffc0200c6e:	00004517          	auipc	a0,0x4
ffffffffc0200c72:	1ea50513          	addi	a0,a0,490 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200c76:	c8cff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c7a:	00004697          	auipc	a3,0x4
ffffffffc0200c7e:	22e68693          	addi	a3,a3,558 # ffffffffc0204ea8 <commands+0x7d8>
ffffffffc0200c82:	00004617          	auipc	a2,0x4
ffffffffc0200c86:	1be60613          	addi	a2,a2,446 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200c8a:	07c00593          	li	a1,124
ffffffffc0200c8e:	00004517          	auipc	a0,0x4
ffffffffc0200c92:	1ca50513          	addi	a0,a0,458 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200c96:	c6cff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200c9a:	00004697          	auipc	a3,0x4
ffffffffc0200c9e:	1ee68693          	addi	a3,a3,494 # ffffffffc0204e88 <commands+0x7b8>
ffffffffc0200ca2:	00004617          	auipc	a2,0x4
ffffffffc0200ca6:	19e60613          	addi	a2,a2,414 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200caa:	07b00593          	li	a1,123
ffffffffc0200cae:	00004517          	auipc	a0,0x4
ffffffffc0200cb2:	1aa50513          	addi	a0,a0,426 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200cb6:	c4cff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200cba <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
ffffffffc0200cba:	1141                	addi	sp,sp,-16
ffffffffc0200cbc:	e022                	sd	s0,0(sp)
ffffffffc0200cbe:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0200cc0:	6508                	ld	a0,8(a0)
ffffffffc0200cc2:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0200cc4:	00a40e63          	beq	s0,a0,ffffffffc0200ce0 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200cc8:	6118                	ld	a4,0(a0)
ffffffffc0200cca:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200ccc:	03000593          	li	a1,48
ffffffffc0200cd0:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200cd2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200cd4:	e398                	sd	a4,0(a5)
ffffffffc0200cd6:	7e3020ef          	jal	ra,ffffffffc0203cb8 <kfree>
    return listelm->next;
ffffffffc0200cda:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200cdc:	fea416e3          	bne	s0,a0,ffffffffc0200cc8 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200ce0:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0200ce2:	6402                	ld	s0,0(sp)
ffffffffc0200ce4:	60a2                	ld	ra,8(sp)
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200ce6:	03000593          	li	a1,48
}
ffffffffc0200cea:	0141                	addi	sp,sp,16
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200cec:	7cd0206f          	j	ffffffffc0203cb8 <kfree>

ffffffffc0200cf0 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0200cf0:	715d                	addi	sp,sp,-80
ffffffffc0200cf2:	e486                	sd	ra,72(sp)
ffffffffc0200cf4:	f44e                	sd	s3,40(sp)
ffffffffc0200cf6:	f052                	sd	s4,32(sp)
ffffffffc0200cf8:	e0a2                	sd	s0,64(sp)
ffffffffc0200cfa:	fc26                	sd	s1,56(sp)
ffffffffc0200cfc:	f84a                	sd	s2,48(sp)
ffffffffc0200cfe:	ec56                	sd	s5,24(sp)
ffffffffc0200d00:	e85a                	sd	s6,16(sp)
ffffffffc0200d02:	e45e                	sd	s7,8(sp)
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200d04:	615010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0200d08:	89aa                	mv	s3,a0
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();//获取当前系统中可用的空闲页面数量
ffffffffc0200d0a:	60f010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0200d0e:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200d10:	03000513          	li	a0,48
ffffffffc0200d14:	6eb020ef          	jal	ra,ffffffffc0203bfe <kmalloc>
    if (mm != NULL) {
ffffffffc0200d18:	56050863          	beqz	a0,ffffffffc0201288 <vmm_init+0x598>
    elm->prev = elm->next = elm;
ffffffffc0200d1c:	e508                	sd	a0,8(a0)
ffffffffc0200d1e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0200d20:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200d24:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200d28:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200d2c:	00011797          	auipc	a5,0x11
ffffffffc0200d30:	8147a783          	lw	a5,-2028(a5) # ffffffffc0211540 <swap_init_ok>
ffffffffc0200d34:	84aa                	mv	s1,a0
ffffffffc0200d36:	e7b9                	bnez	a5,ffffffffc0200d84 <vmm_init+0x94>
        else mm->sm_priv = NULL;
ffffffffc0200d38:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc0200d3c:	03200413          	li	s0,50
ffffffffc0200d40:	a811                	j	ffffffffc0200d54 <vmm_init+0x64>
        vma->vm_start = vm_start;
ffffffffc0200d42:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200d44:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200d46:	00053c23          	sd	zero,24(a0)

    int step1 = 10, step2 = step1 * 10;

    int i;
    //每次创建一个新的 VMA 结构，并插入到内存管理结构 mm 中。
    for (i = step1; i >= 1; i --) {
ffffffffc0200d4a:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200d4c:	8526                	mv	a0,s1
ffffffffc0200d4e:	e9dff0ef          	jal	ra,ffffffffc0200bea <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0200d52:	cc05                	beqz	s0,ffffffffc0200d8a <vmm_init+0x9a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200d54:	03000513          	li	a0,48
ffffffffc0200d58:	6a7020ef          	jal	ra,ffffffffc0203bfe <kmalloc>
ffffffffc0200d5c:	85aa                	mv	a1,a0
ffffffffc0200d5e:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d62:	f165                	bnez	a0,ffffffffc0200d42 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0200d64:	00004697          	auipc	a3,0x4
ffffffffc0200d68:	39468693          	addi	a3,a3,916 # ffffffffc02050f8 <commands+0xa28>
ffffffffc0200d6c:	00004617          	auipc	a2,0x4
ffffffffc0200d70:	0d460613          	addi	a2,a2,212 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200d74:	0cf00593          	li	a1,207
ffffffffc0200d78:	00004517          	auipc	a0,0x4
ffffffffc0200d7c:	0e050513          	addi	a0,a0,224 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200d80:	b82ff0ef          	jal	ra,ffffffffc0200102 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200d84:	00c010ef          	jal	ra,ffffffffc0201d90 <swap_init_mm>
ffffffffc0200d88:	bf55                	j	ffffffffc0200d3c <vmm_init+0x4c>
ffffffffc0200d8a:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200d8e:	1f900913          	li	s2,505
ffffffffc0200d92:	a819                	j	ffffffffc0200da8 <vmm_init+0xb8>
        vma->vm_start = vm_start;
ffffffffc0200d94:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200d96:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200d98:	00053c23          	sd	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200d9c:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200d9e:	8526                	mv	a0,s1
ffffffffc0200da0:	e4bff0ef          	jal	ra,ffffffffc0200bea <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200da4:	03240a63          	beq	s0,s2,ffffffffc0200dd8 <vmm_init+0xe8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200da8:	03000513          	li	a0,48
ffffffffc0200dac:	653020ef          	jal	ra,ffffffffc0203bfe <kmalloc>
ffffffffc0200db0:	85aa                	mv	a1,a0
ffffffffc0200db2:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200db6:	fd79                	bnez	a0,ffffffffc0200d94 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0200db8:	00004697          	auipc	a3,0x4
ffffffffc0200dbc:	34068693          	addi	a3,a3,832 # ffffffffc02050f8 <commands+0xa28>
ffffffffc0200dc0:	00004617          	auipc	a2,0x4
ffffffffc0200dc4:	08060613          	addi	a2,a2,128 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200dc8:	0d500593          	li	a1,213
ffffffffc0200dcc:	00004517          	auipc	a0,0x4
ffffffffc0200dd0:	08c50513          	addi	a0,a0,140 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200dd4:	b2eff0ef          	jal	ra,ffffffffc0200102 <__panic>
    return listelm->next;
ffffffffc0200dd8:	649c                	ld	a5,8(s1)
ffffffffc0200dda:	471d                	li	a4,7
    }

    //验证 VMA 结构的顺序
    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0200ddc:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0200de0:	2ef48463          	beq	s1,a5,ffffffffc02010c8 <vmm_init+0x3d8>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0200de4:	fe87b603          	ld	a2,-24(a5)
ffffffffc0200de8:	ffe70693          	addi	a3,a4,-2
ffffffffc0200dec:	26d61e63          	bne	a2,a3,ffffffffc0201068 <vmm_init+0x378>
ffffffffc0200df0:	ff07b683          	ld	a3,-16(a5)
ffffffffc0200df4:	26e69a63          	bne	a3,a4,ffffffffc0201068 <vmm_init+0x378>
    for (i = 1; i <= step2; i ++) {
ffffffffc0200df8:	0715                	addi	a4,a4,5
ffffffffc0200dfa:	679c                	ld	a5,8(a5)
ffffffffc0200dfc:	feb712e3          	bne	a4,a1,ffffffffc0200de0 <vmm_init+0xf0>
ffffffffc0200e00:	4b1d                	li	s6,7
ffffffffc0200e02:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0200e04:	1f900b93          	li	s7,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0200e08:	85a2                	mv	a1,s0
ffffffffc0200e0a:	8526                	mv	a0,s1
ffffffffc0200e0c:	d9fff0ef          	jal	ra,ffffffffc0200baa <find_vma>
ffffffffc0200e10:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0200e12:	2c050b63          	beqz	a0,ffffffffc02010e8 <vmm_init+0x3f8>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0200e16:	00140593          	addi	a1,s0,1
ffffffffc0200e1a:	8526                	mv	a0,s1
ffffffffc0200e1c:	d8fff0ef          	jal	ra,ffffffffc0200baa <find_vma>
ffffffffc0200e20:	8aaa                	mv	s5,a0
        assert(vma2 != NULL);
ffffffffc0200e22:	2e050363          	beqz	a0,ffffffffc0201108 <vmm_init+0x418>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0200e26:	85da                	mv	a1,s6
ffffffffc0200e28:	8526                	mv	a0,s1
ffffffffc0200e2a:	d81ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
        assert(vma3 == NULL);
ffffffffc0200e2e:	2e051d63          	bnez	a0,ffffffffc0201128 <vmm_init+0x438>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0200e32:	00340593          	addi	a1,s0,3
ffffffffc0200e36:	8526                	mv	a0,s1
ffffffffc0200e38:	d73ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
        assert(vma4 == NULL);
ffffffffc0200e3c:	30051663          	bnez	a0,ffffffffc0201148 <vmm_init+0x458>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0200e40:	00440593          	addi	a1,s0,4
ffffffffc0200e44:	8526                	mv	a0,s1
ffffffffc0200e46:	d65ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
        assert(vma5 == NULL);
ffffffffc0200e4a:	30051f63          	bnez	a0,ffffffffc0201168 <vmm_init+0x478>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0200e4e:	00893783          	ld	a5,8(s2)
ffffffffc0200e52:	24879b63          	bne	a5,s0,ffffffffc02010a8 <vmm_init+0x3b8>
ffffffffc0200e56:	01093783          	ld	a5,16(s2)
ffffffffc0200e5a:	25679763          	bne	a5,s6,ffffffffc02010a8 <vmm_init+0x3b8>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0200e5e:	008ab783          	ld	a5,8(s5)
ffffffffc0200e62:	22879363          	bne	a5,s0,ffffffffc0201088 <vmm_init+0x398>
ffffffffc0200e66:	010ab783          	ld	a5,16(s5)
ffffffffc0200e6a:	21679f63          	bne	a5,s6,ffffffffc0201088 <vmm_init+0x398>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0200e6e:	0415                	addi	s0,s0,5
ffffffffc0200e70:	0b15                	addi	s6,s6,5
ffffffffc0200e72:	f9741be3          	bne	s0,s7,ffffffffc0200e08 <vmm_init+0x118>
ffffffffc0200e76:	4411                	li	s0,4
    }

    //验证地址小于 5 的情况
    for (i =4; i>=0; i--) {
ffffffffc0200e78:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0200e7a:	85a2                	mv	a1,s0
ffffffffc0200e7c:	8526                	mv	a0,s1
ffffffffc0200e7e:	d2dff0ef          	jal	ra,ffffffffc0200baa <find_vma>
ffffffffc0200e82:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0200e86:	c90d                	beqz	a0,ffffffffc0200eb8 <vmm_init+0x1c8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0200e88:	6914                	ld	a3,16(a0)
ffffffffc0200e8a:	6510                	ld	a2,8(a0)
ffffffffc0200e8c:	00004517          	auipc	a0,0x4
ffffffffc0200e90:	13c50513          	addi	a0,a0,316 # ffffffffc0204fc8 <commands+0x8f8>
ffffffffc0200e94:	a26ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0200e98:	00004697          	auipc	a3,0x4
ffffffffc0200e9c:	15868693          	addi	a3,a3,344 # ffffffffc0204ff0 <commands+0x920>
ffffffffc0200ea0:	00004617          	auipc	a2,0x4
ffffffffc0200ea4:	fa060613          	addi	a2,a2,-96 # ffffffffc0204e40 <commands+0x770>
ffffffffc0200ea8:	0f900593          	li	a1,249
ffffffffc0200eac:	00004517          	auipc	a0,0x4
ffffffffc0200eb0:	fac50513          	addi	a0,a0,-84 # ffffffffc0204e58 <commands+0x788>
ffffffffc0200eb4:	a4eff0ef          	jal	ra,ffffffffc0200102 <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0200eb8:	147d                	addi	s0,s0,-1
ffffffffc0200eba:	fd2410e3          	bne	s0,s2,ffffffffc0200e7a <vmm_init+0x18a>
ffffffffc0200ebe:	a811                	j	ffffffffc0200ed2 <vmm_init+0x1e2>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ec0:	6118                	ld	a4,0(a0)
ffffffffc0200ec2:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200ec4:	03000593          	li	a1,48
ffffffffc0200ec8:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0200eca:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200ecc:	e398                	sd	a4,0(a5)
ffffffffc0200ece:	5eb020ef          	jal	ra,ffffffffc0203cb8 <kfree>
    return listelm->next;
ffffffffc0200ed2:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0200ed4:	fea496e3          	bne	s1,a0,ffffffffc0200ec0 <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200ed8:	03000593          	li	a1,48
ffffffffc0200edc:	8526                	mv	a0,s1
ffffffffc0200ede:	5db020ef          	jal	ra,ffffffffc0203cb8 <kfree>
    }

    //销毁内存管理结构
    mm_destroy(mm);
    //验证空闲页面数
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200ee2:	437010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0200ee6:	3caa1163          	bne	s4,a0,ffffffffc02012a8 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0200eea:	00004517          	auipc	a0,0x4
ffffffffc0200eee:	14650513          	addi	a0,a0,326 # ffffffffc0205030 <commands+0x960>
ffffffffc0200ef2:	9c8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200ef6:	423010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0200efa:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200efc:	03000513          	li	a0,48
ffffffffc0200f00:	4ff020ef          	jal	ra,ffffffffc0203bfe <kmalloc>
ffffffffc0200f04:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0200f06:	2a050163          	beqz	a0,ffffffffc02011a8 <vmm_init+0x4b8>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200f0a:	00010797          	auipc	a5,0x10
ffffffffc0200f0e:	6367a783          	lw	a5,1590(a5) # ffffffffc0211540 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc0200f12:	e508                	sd	a0,8(a0)
ffffffffc0200f14:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0200f16:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200f1a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200f1e:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200f22:	14079063          	bnez	a5,ffffffffc0201062 <vmm_init+0x372>
        else mm->sm_priv = NULL;
ffffffffc0200f26:	02053423          	sd	zero,40(a0)
    check_mm_struct = mm_create();

    assert(check_mm_struct != NULL);
    struct mm_struct *mm = check_mm_struct;
    //设置页目录
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0200f2a:	00010917          	auipc	s2,0x10
ffffffffc0200f2e:	62693903          	ld	s2,1574(s2) # ffffffffc0211550 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0200f32:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc0200f36:	00010717          	auipc	a4,0x10
ffffffffc0200f3a:	5e873123          	sd	s0,1506(a4) # ffffffffc0211518 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0200f3e:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc0200f42:	24079363          	bnez	a5,ffffffffc0201188 <vmm_init+0x498>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200f46:	03000513          	li	a0,48
ffffffffc0200f4a:	4b5020ef          	jal	ra,ffffffffc0203bfe <kmalloc>
ffffffffc0200f4e:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc0200f50:	28050063          	beqz	a0,ffffffffc02011d0 <vmm_init+0x4e0>
        vma->vm_end = vm_end;
ffffffffc0200f54:	002007b7          	lui	a5,0x200
ffffffffc0200f58:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc0200f5c:	4789                	li	a5,2
    //创建并插入 VMA 结构
    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);

    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc0200f5e:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0200f60:	00fa3c23          	sd	a5,24(s4)
    insert_vma_struct(mm, vma);
ffffffffc0200f64:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0200f66:	000a3423          	sd	zero,8(s4)
    insert_vma_struct(mm, vma);
ffffffffc0200f6a:	c81ff0ef          	jal	ra,ffffffffc0200bea <insert_vma_struct>
    //验证 VMA 结构
    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc0200f6e:	10000593          	li	a1,256
ffffffffc0200f72:	8522                	mv	a0,s0
ffffffffc0200f74:	c37ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
ffffffffc0200f78:	10000793          	li	a5,256
    //写入数据并验证
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc0200f7c:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc0200f80:	26aa1863          	bne	s4,a0,ffffffffc02011f0 <vmm_init+0x500>
        *(char *)(addr + i) = i;
ffffffffc0200f84:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc0200f88:	0785                	addi	a5,a5,1
ffffffffc0200f8a:	fee79de3          	bne	a5,a4,ffffffffc0200f84 <vmm_init+0x294>
        sum += i;
ffffffffc0200f8e:	6705                	lui	a4,0x1
ffffffffc0200f90:	10000793          	li	a5,256
ffffffffc0200f94:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0200f98:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc0200f9c:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc0200fa0:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc0200fa2:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0200fa4:	fec79ce3          	bne	a5,a2,ffffffffc0200f9c <vmm_init+0x2ac>
    }
    assert(sum == 0);
ffffffffc0200fa8:	26071463          	bnez	a4,ffffffffc0201210 <vmm_init+0x520>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc0200fac:	4581                	li	a1,0
ffffffffc0200fae:	854a                	mv	a0,s2
ffffffffc0200fb0:	5f3010ef          	jal	ra,ffffffffc0202da2 <page_remove>
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
ffffffffc0200fb4:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0200fb8:	00010717          	auipc	a4,0x10
ffffffffc0200fbc:	5a073703          	ld	a4,1440(a4) # ffffffffc0211558 <npage>
    return pa2page(PDE_ADDR(pde));
ffffffffc0200fc0:	078a                	slli	a5,a5,0x2
ffffffffc0200fc2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200fc4:	26e7f663          	bgeu	a5,a4,ffffffffc0201230 <vmm_init+0x540>
    return &pages[PPN(pa) - nbase];
ffffffffc0200fc8:	00005717          	auipc	a4,0x5
ffffffffc0200fcc:	34873703          	ld	a4,840(a4) # ffffffffc0206310 <nbase>
ffffffffc0200fd0:	8f99                	sub	a5,a5,a4
ffffffffc0200fd2:	00379713          	slli	a4,a5,0x3
ffffffffc0200fd6:	97ba                	add	a5,a5,a4
ffffffffc0200fd8:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc0200fda:	00010517          	auipc	a0,0x10
ffffffffc0200fde:	58653503          	ld	a0,1414(a0) # ffffffffc0211560 <pages>
ffffffffc0200fe2:	953e                	add	a0,a0,a5
ffffffffc0200fe4:	4585                	li	a1,1
ffffffffc0200fe6:	2f3010ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    return listelm->next;
ffffffffc0200fea:	6408                	ld	a0,8(s0)

    pgdir[0] = 0;
ffffffffc0200fec:	00093023          	sd	zero,0(s2)

    mm->pgdir = NULL;
ffffffffc0200ff0:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200ff4:	00a40e63          	beq	s0,a0,ffffffffc0201010 <vmm_init+0x320>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ff8:	6118                	ld	a4,0(a0)
ffffffffc0200ffa:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200ffc:	03000593          	li	a1,48
ffffffffc0201000:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0201002:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201004:	e398                	sd	a4,0(a5)
ffffffffc0201006:	4b3020ef          	jal	ra,ffffffffc0203cb8 <kfree>
    return listelm->next;
ffffffffc020100a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc020100c:	fea416e3          	bne	s0,a0,ffffffffc0200ff8 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0201010:	03000593          	li	a1,48
ffffffffc0201014:	8522                	mv	a0,s0
ffffffffc0201016:	4a3020ef          	jal	ra,ffffffffc0203cb8 <kfree>
    mm_destroy(mm);

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
ffffffffc020101a:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc020101c:	00010797          	auipc	a5,0x10
ffffffffc0201020:	4e07be23          	sd	zero,1276(a5) # ffffffffc0211518 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201024:	2f5010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0201028:	22a49063          	bne	s1,a0,ffffffffc0201248 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc020102c:	00004517          	auipc	a0,0x4
ffffffffc0201030:	09450513          	addi	a0,a0,148 # ffffffffc02050c0 <commands+0x9f0>
ffffffffc0201034:	886ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201038:	2e1010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
    nr_free_pages_store--;	// szx : Sv39三级页表多占一个内存页，所以执行此操作
ffffffffc020103c:	19fd                	addi	s3,s3,-1
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020103e:	22a99563          	bne	s3,a0,ffffffffc0201268 <vmm_init+0x578>
}
ffffffffc0201042:	6406                	ld	s0,64(sp)
ffffffffc0201044:	60a6                	ld	ra,72(sp)
ffffffffc0201046:	74e2                	ld	s1,56(sp)
ffffffffc0201048:	7942                	ld	s2,48(sp)
ffffffffc020104a:	79a2                	ld	s3,40(sp)
ffffffffc020104c:	7a02                	ld	s4,32(sp)
ffffffffc020104e:	6ae2                	ld	s5,24(sp)
ffffffffc0201050:	6b42                	ld	s6,16(sp)
ffffffffc0201052:	6ba2                	ld	s7,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201054:	00004517          	auipc	a0,0x4
ffffffffc0201058:	08c50513          	addi	a0,a0,140 # ffffffffc02050e0 <commands+0xa10>
}
ffffffffc020105c:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc020105e:	85cff06f          	j	ffffffffc02000ba <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201062:	52f000ef          	jal	ra,ffffffffc0201d90 <swap_init_mm>
ffffffffc0201066:	b5d1                	j	ffffffffc0200f2a <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201068:	00004697          	auipc	a3,0x4
ffffffffc020106c:	e7868693          	addi	a3,a3,-392 # ffffffffc0204ee0 <commands+0x810>
ffffffffc0201070:	00004617          	auipc	a2,0x4
ffffffffc0201074:	dd060613          	addi	a2,a2,-560 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201078:	0df00593          	li	a1,223
ffffffffc020107c:	00004517          	auipc	a0,0x4
ffffffffc0201080:	ddc50513          	addi	a0,a0,-548 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201084:	87eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0201088:	00004697          	auipc	a3,0x4
ffffffffc020108c:	f1068693          	addi	a3,a3,-240 # ffffffffc0204f98 <commands+0x8c8>
ffffffffc0201090:	00004617          	auipc	a2,0x4
ffffffffc0201094:	db060613          	addi	a2,a2,-592 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201098:	0f000593          	li	a1,240
ffffffffc020109c:	00004517          	auipc	a0,0x4
ffffffffc02010a0:	dbc50513          	addi	a0,a0,-580 # ffffffffc0204e58 <commands+0x788>
ffffffffc02010a4:	85eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc02010a8:	00004697          	auipc	a3,0x4
ffffffffc02010ac:	ec068693          	addi	a3,a3,-320 # ffffffffc0204f68 <commands+0x898>
ffffffffc02010b0:	00004617          	auipc	a2,0x4
ffffffffc02010b4:	d9060613          	addi	a2,a2,-624 # ffffffffc0204e40 <commands+0x770>
ffffffffc02010b8:	0ef00593          	li	a1,239
ffffffffc02010bc:	00004517          	auipc	a0,0x4
ffffffffc02010c0:	d9c50513          	addi	a0,a0,-612 # ffffffffc0204e58 <commands+0x788>
ffffffffc02010c4:	83eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02010c8:	00004697          	auipc	a3,0x4
ffffffffc02010cc:	e0068693          	addi	a3,a3,-512 # ffffffffc0204ec8 <commands+0x7f8>
ffffffffc02010d0:	00004617          	auipc	a2,0x4
ffffffffc02010d4:	d7060613          	addi	a2,a2,-656 # ffffffffc0204e40 <commands+0x770>
ffffffffc02010d8:	0dd00593          	li	a1,221
ffffffffc02010dc:	00004517          	auipc	a0,0x4
ffffffffc02010e0:	d7c50513          	addi	a0,a0,-644 # ffffffffc0204e58 <commands+0x788>
ffffffffc02010e4:	81eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1 != NULL);
ffffffffc02010e8:	00004697          	auipc	a3,0x4
ffffffffc02010ec:	e3068693          	addi	a3,a3,-464 # ffffffffc0204f18 <commands+0x848>
ffffffffc02010f0:	00004617          	auipc	a2,0x4
ffffffffc02010f4:	d5060613          	addi	a2,a2,-688 # ffffffffc0204e40 <commands+0x770>
ffffffffc02010f8:	0e500593          	li	a1,229
ffffffffc02010fc:	00004517          	auipc	a0,0x4
ffffffffc0201100:	d5c50513          	addi	a0,a0,-676 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201104:	ffffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2 != NULL);
ffffffffc0201108:	00004697          	auipc	a3,0x4
ffffffffc020110c:	e2068693          	addi	a3,a3,-480 # ffffffffc0204f28 <commands+0x858>
ffffffffc0201110:	00004617          	auipc	a2,0x4
ffffffffc0201114:	d3060613          	addi	a2,a2,-720 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201118:	0e700593          	li	a1,231
ffffffffc020111c:	00004517          	auipc	a0,0x4
ffffffffc0201120:	d3c50513          	addi	a0,a0,-708 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201124:	fdffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma3 == NULL);
ffffffffc0201128:	00004697          	auipc	a3,0x4
ffffffffc020112c:	e1068693          	addi	a3,a3,-496 # ffffffffc0204f38 <commands+0x868>
ffffffffc0201130:	00004617          	auipc	a2,0x4
ffffffffc0201134:	d1060613          	addi	a2,a2,-752 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201138:	0e900593          	li	a1,233
ffffffffc020113c:	00004517          	auipc	a0,0x4
ffffffffc0201140:	d1c50513          	addi	a0,a0,-740 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201144:	fbffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma4 == NULL);
ffffffffc0201148:	00004697          	auipc	a3,0x4
ffffffffc020114c:	e0068693          	addi	a3,a3,-512 # ffffffffc0204f48 <commands+0x878>
ffffffffc0201150:	00004617          	auipc	a2,0x4
ffffffffc0201154:	cf060613          	addi	a2,a2,-784 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201158:	0eb00593          	li	a1,235
ffffffffc020115c:	00004517          	auipc	a0,0x4
ffffffffc0201160:	cfc50513          	addi	a0,a0,-772 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201164:	f9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma5 == NULL);
ffffffffc0201168:	00004697          	auipc	a3,0x4
ffffffffc020116c:	df068693          	addi	a3,a3,-528 # ffffffffc0204f58 <commands+0x888>
ffffffffc0201170:	00004617          	auipc	a2,0x4
ffffffffc0201174:	cd060613          	addi	a2,a2,-816 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201178:	0ed00593          	li	a1,237
ffffffffc020117c:	00004517          	auipc	a0,0x4
ffffffffc0201180:	cdc50513          	addi	a0,a0,-804 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201184:	f7ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0201188:	00004697          	auipc	a3,0x4
ffffffffc020118c:	ec868693          	addi	a3,a3,-312 # ffffffffc0205050 <commands+0x980>
ffffffffc0201190:	00004617          	auipc	a2,0x4
ffffffffc0201194:	cb060613          	addi	a2,a2,-848 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201198:	11200593          	li	a1,274
ffffffffc020119c:	00004517          	auipc	a0,0x4
ffffffffc02011a0:	cbc50513          	addi	a0,a0,-836 # ffffffffc0204e58 <commands+0x788>
ffffffffc02011a4:	f5ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc02011a8:	00004697          	auipc	a3,0x4
ffffffffc02011ac:	f6068693          	addi	a3,a3,-160 # ffffffffc0205108 <commands+0xa38>
ffffffffc02011b0:	00004617          	auipc	a2,0x4
ffffffffc02011b4:	c9060613          	addi	a2,a2,-880 # ffffffffc0204e40 <commands+0x770>
ffffffffc02011b8:	10e00593          	li	a1,270
ffffffffc02011bc:	00004517          	auipc	a0,0x4
ffffffffc02011c0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0204e58 <commands+0x788>
    check_mm_struct = mm_create();
ffffffffc02011c4:	00010797          	auipc	a5,0x10
ffffffffc02011c8:	3407ba23          	sd	zero,852(a5) # ffffffffc0211518 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc02011cc:	f37fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(vma != NULL);
ffffffffc02011d0:	00004697          	auipc	a3,0x4
ffffffffc02011d4:	f2868693          	addi	a3,a3,-216 # ffffffffc02050f8 <commands+0xa28>
ffffffffc02011d8:	00004617          	auipc	a2,0x4
ffffffffc02011dc:	c6860613          	addi	a2,a2,-920 # ffffffffc0204e40 <commands+0x770>
ffffffffc02011e0:	11600593          	li	a1,278
ffffffffc02011e4:	00004517          	auipc	a0,0x4
ffffffffc02011e8:	c7450513          	addi	a0,a0,-908 # ffffffffc0204e58 <commands+0x788>
ffffffffc02011ec:	f17fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc02011f0:	00004697          	auipc	a3,0x4
ffffffffc02011f4:	e7068693          	addi	a3,a3,-400 # ffffffffc0205060 <commands+0x990>
ffffffffc02011f8:	00004617          	auipc	a2,0x4
ffffffffc02011fc:	c4860613          	addi	a2,a2,-952 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201200:	11b00593          	li	a1,283
ffffffffc0201204:	00004517          	auipc	a0,0x4
ffffffffc0201208:	c5450513          	addi	a0,a0,-940 # ffffffffc0204e58 <commands+0x788>
ffffffffc020120c:	ef7fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(sum == 0);
ffffffffc0201210:	00004697          	auipc	a3,0x4
ffffffffc0201214:	e7068693          	addi	a3,a3,-400 # ffffffffc0205080 <commands+0x9b0>
ffffffffc0201218:	00004617          	auipc	a2,0x4
ffffffffc020121c:	c2860613          	addi	a2,a2,-984 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201220:	12500593          	li	a1,293
ffffffffc0201224:	00004517          	auipc	a0,0x4
ffffffffc0201228:	c3450513          	addi	a0,a0,-972 # ffffffffc0204e58 <commands+0x788>
ffffffffc020122c:	ed7fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201230:	00004617          	auipc	a2,0x4
ffffffffc0201234:	e6060613          	addi	a2,a2,-416 # ffffffffc0205090 <commands+0x9c0>
ffffffffc0201238:	06500593          	li	a1,101
ffffffffc020123c:	00004517          	auipc	a0,0x4
ffffffffc0201240:	e7450513          	addi	a0,a0,-396 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0201244:	ebffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201248:	00004697          	auipc	a3,0x4
ffffffffc020124c:	dc068693          	addi	a3,a3,-576 # ffffffffc0205008 <commands+0x938>
ffffffffc0201250:	00004617          	auipc	a2,0x4
ffffffffc0201254:	bf060613          	addi	a2,a2,-1040 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201258:	13300593          	li	a1,307
ffffffffc020125c:	00004517          	auipc	a0,0x4
ffffffffc0201260:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201264:	e9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201268:	00004697          	auipc	a3,0x4
ffffffffc020126c:	da068693          	addi	a3,a3,-608 # ffffffffc0205008 <commands+0x938>
ffffffffc0201270:	00004617          	auipc	a2,0x4
ffffffffc0201274:	bd060613          	addi	a2,a2,-1072 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201278:	0bd00593          	li	a1,189
ffffffffc020127c:	00004517          	auipc	a0,0x4
ffffffffc0201280:	bdc50513          	addi	a0,a0,-1060 # ffffffffc0204e58 <commands+0x788>
ffffffffc0201284:	e7ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(mm != NULL);
ffffffffc0201288:	00004697          	auipc	a3,0x4
ffffffffc020128c:	e9868693          	addi	a3,a3,-360 # ffffffffc0205120 <commands+0xa50>
ffffffffc0201290:	00004617          	auipc	a2,0x4
ffffffffc0201294:	bb060613          	addi	a2,a2,-1104 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201298:	0c700593          	li	a1,199
ffffffffc020129c:	00004517          	auipc	a0,0x4
ffffffffc02012a0:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0204e58 <commands+0x788>
ffffffffc02012a4:	e5ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02012a8:	00004697          	auipc	a3,0x4
ffffffffc02012ac:	d6068693          	addi	a3,a3,-672 # ffffffffc0205008 <commands+0x938>
ffffffffc02012b0:	00004617          	auipc	a2,0x4
ffffffffc02012b4:	b9060613          	addi	a2,a2,-1136 # ffffffffc0204e40 <commands+0x770>
ffffffffc02012b8:	0ff00593          	li	a1,255
ffffffffc02012bc:	00004517          	auipc	a0,0x4
ffffffffc02012c0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204e58 <commands+0x788>
ffffffffc02012c4:	e3ffe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02012c8 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02012c8:	7179                	addi	sp,sp,-48
    int ret = -E_INVAL;
    //try to find a vma which include addr
    //查找包含地址的VMA结构
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02012ca:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02012cc:	f022                	sd	s0,32(sp)
ffffffffc02012ce:	ec26                	sd	s1,24(sp)
ffffffffc02012d0:	f406                	sd	ra,40(sp)
ffffffffc02012d2:	e84a                	sd	s2,16(sp)
ffffffffc02012d4:	8432                	mv	s0,a2
ffffffffc02012d6:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02012d8:	8d3ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
    //统计页错误次数
    pgfault_num++;
ffffffffc02012dc:	00010797          	auipc	a5,0x10
ffffffffc02012e0:	2447a783          	lw	a5,580(a5) # ffffffffc0211520 <pgfault_num>
ffffffffc02012e4:	2785                	addiw	a5,a5,1
ffffffffc02012e6:	00010717          	auipc	a4,0x10
ffffffffc02012ea:	22f72d23          	sw	a5,570(a4) # ffffffffc0211520 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc02012ee:	c549                	beqz	a0,ffffffffc0201378 <do_pgfault+0xb0>
ffffffffc02012f0:	651c                	ld	a5,8(a0)
ffffffffc02012f2:	08f46363          	bltu	s0,a5,ffffffffc0201378 <do_pgfault+0xb0>
     * THEN
     *    continue process
     */
    //设置权限，对其地址
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc02012f6:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc02012f8:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc02012fa:	8b89                	andi	a5,a5,2
ffffffffc02012fc:	efa9                	bnez	a5,ffffffffc0201356 <do_pgfault+0x8e>
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02012fe:	75fd                	lui	a1,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */

   //获取页表条目的指针 
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0201300:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0201302:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0201304:	85a2                	mv	a1,s0
ffffffffc0201306:	4605                	li	a2,1
ffffffffc0201308:	04b010ef          	jal	ra,ffffffffc0202b52 <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {
ffffffffc020130c:	610c                	ld	a1,0(a0)
ffffffffc020130e:	c5b1                	beqz	a1,ffffffffc020135a <do_pgfault+0x92>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc0201310:	00010797          	auipc	a5,0x10
ffffffffc0201314:	2307a783          	lw	a5,560(a5) # ffffffffc0211540 <swap_init_ok>
ffffffffc0201318:	cbad                	beqz	a5,ffffffffc020138a <do_pgfault+0xc2>
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            //分配一个页面并从交换分区加载数据
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc020131a:	0030                	addi	a2,sp,8
ffffffffc020131c:	85a2                	mv	a1,s0
ffffffffc020131e:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0201320:	e402                	sd	zero,8(sp)
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc0201322:	39b000ef          	jal	ra,ffffffffc0201ebc <swap_in>
ffffffffc0201326:	e935                	bnez	a0,ffffffffc020139a <do_pgfault+0xd2>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            //建立页面的物理地址与虚拟地址之间的映射关系
            if (page_insert(mm->pgdir, page, addr, perm) != 0){
ffffffffc0201328:	65a2                	ld	a1,8(sp)
ffffffffc020132a:	6c88                	ld	a0,24(s1)
ffffffffc020132c:	86ca                	mv	a3,s2
ffffffffc020132e:	8622                	mv	a2,s0
ffffffffc0201330:	30d010ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc0201334:	892a                	mv	s2,a0
ffffffffc0201336:	e935                	bnez	a0,ffffffffc02013aa <do_pgfault+0xe2>
                cprintf("page_insert in do_pgfault failed\n");
                goto failed;
            }
            //(3) make the page swappable.
             // 标记页面为可交换
            swap_map_swappable(mm, addr, page, 0);
ffffffffc0201338:	6622                	ld	a2,8(sp)
ffffffffc020133a:	4681                	li	a3,0
ffffffffc020133c:	85a2                	mv	a1,s0
ffffffffc020133e:	8526                	mv	a0,s1
ffffffffc0201340:	25d000ef          	jal	ra,ffffffffc0201d9c <swap_map_swappable>

            //设置页面的虚拟地址 
            page->pra_vaddr = addr;
ffffffffc0201344:	67a2                	ld	a5,8(sp)
ffffffffc0201346:	e3a0                	sd	s0,64(a5)
   }

   ret = 0;
failed:
    return ret;
}
ffffffffc0201348:	70a2                	ld	ra,40(sp)
ffffffffc020134a:	7402                	ld	s0,32(sp)
ffffffffc020134c:	64e2                	ld	s1,24(sp)
ffffffffc020134e:	854a                	mv	a0,s2
ffffffffc0201350:	6942                	ld	s2,16(sp)
ffffffffc0201352:	6145                	addi	sp,sp,48
ffffffffc0201354:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc0201356:	4959                	li	s2,22
ffffffffc0201358:	b75d                	j	ffffffffc02012fe <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020135a:	6c88                	ld	a0,24(s1)
ffffffffc020135c:	864a                	mv	a2,s2
ffffffffc020135e:	85a2                	mv	a1,s0
ffffffffc0201360:	7e6020ef          	jal	ra,ffffffffc0203b46 <pgdir_alloc_page>
   ret = 0;
ffffffffc0201364:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201366:	f16d                	bnez	a0,ffffffffc0201348 <do_pgfault+0x80>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0201368:	00004517          	auipc	a0,0x4
ffffffffc020136c:	df850513          	addi	a0,a0,-520 # ffffffffc0205160 <commands+0xa90>
ffffffffc0201370:	d4bfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201374:	5971                	li	s2,-4
            goto failed;
ffffffffc0201376:	bfc9                	j	ffffffffc0201348 <do_pgfault+0x80>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0201378:	85a2                	mv	a1,s0
ffffffffc020137a:	00004517          	auipc	a0,0x4
ffffffffc020137e:	db650513          	addi	a0,a0,-586 # ffffffffc0205130 <commands+0xa60>
ffffffffc0201382:	d39fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = -E_INVAL;
ffffffffc0201386:	5975                	li	s2,-3
        goto failed;
ffffffffc0201388:	b7c1                	j	ffffffffc0201348 <do_pgfault+0x80>
            cprintf("no swap设置页面的虚拟地址 _init_ok but ptep is %x, failed\n", *ptep);
ffffffffc020138a:	00004517          	auipc	a0,0x4
ffffffffc020138e:	e4650513          	addi	a0,a0,-442 # ffffffffc02051d0 <commands+0xb00>
ffffffffc0201392:	d29fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201396:	5971                	li	s2,-4
            goto failed;
ffffffffc0201398:	bf45                	j	ffffffffc0201348 <do_pgfault+0x80>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc020139a:	00004517          	auipc	a0,0x4
ffffffffc020139e:	dee50513          	addi	a0,a0,-530 # ffffffffc0205188 <commands+0xab8>
ffffffffc02013a2:	d19fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc02013a6:	5971                	li	s2,-4
ffffffffc02013a8:	b745                	j	ffffffffc0201348 <do_pgfault+0x80>
                cprintf("page_insert in do_pgfault failed\n");
ffffffffc02013aa:	00004517          	auipc	a0,0x4
ffffffffc02013ae:	dfe50513          	addi	a0,a0,-514 # ffffffffc02051a8 <commands+0xad8>
ffffffffc02013b2:	d09fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc02013b6:	5971                	li	s2,-4
ffffffffc02013b8:	bf41                	j	ffffffffc0201348 <do_pgfault+0x80>

ffffffffc02013ba <_clock_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc02013ba:	00010797          	auipc	a5,0x10
ffffffffc02013be:	c8678793          	addi	a5,a5,-890 # ffffffffc0211040 <pra_list_head>
     // 初始化当前指针curr_ptr指向pra_list_head，表示当前页面替换位置为链表头
     // 将mm的私有成员指针指向pra_list_head，用于后续的页面替换算法操作
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     list_init(&pra_list_head);
     curr_ptr=&pra_list_head;
     mm->sm_priv = &pra_list_head; 
ffffffffc02013c2:	f51c                	sd	a5,40(a0)
ffffffffc02013c4:	e79c                	sd	a5,8(a5)
ffffffffc02013c6:	e39c                	sd	a5,0(a5)
     curr_ptr=&pra_list_head;
ffffffffc02013c8:	00010717          	auipc	a4,0x10
ffffffffc02013cc:	16f73023          	sd	a5,352(a4) # ffffffffc0211528 <curr_ptr>
     return 0;
}
ffffffffc02013d0:	4501                	li	a0,0
ffffffffc02013d2:	8082                	ret

ffffffffc02013d4 <_clock_init>:

static int
_clock_init(void)
{
    return 0;
}
ffffffffc02013d4:	4501                	li	a0,0
ffffffffc02013d6:	8082                	ret

ffffffffc02013d8 <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc02013d8:	4501                	li	a0,0
ffffffffc02013da:	8082                	ret

ffffffffc02013dc <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc02013dc:	4501                	li	a0,0
ffffffffc02013de:	8082                	ret

ffffffffc02013e0 <_clock_check_swap>:
_clock_check_swap(void) {
ffffffffc02013e0:	1141                	addi	sp,sp,-16
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02013e2:	4731                	li	a4,12
_clock_check_swap(void) {
ffffffffc02013e4:	e406                	sd	ra,8(sp)
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02013e6:	678d                	lui	a5,0x3
ffffffffc02013e8:	00e78023          	sb	a4,0(a5) # 3000 <kern_entry-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc02013ec:	00010697          	auipc	a3,0x10
ffffffffc02013f0:	1346a683          	lw	a3,308(a3) # ffffffffc0211520 <pgfault_num>
ffffffffc02013f4:	4711                	li	a4,4
ffffffffc02013f6:	0ae69963          	bne	a3,a4,ffffffffc02014a8 <_clock_check_swap+0xc8>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02013fa:	6705                	lui	a4,0x1
ffffffffc02013fc:	4629                	li	a2,10
ffffffffc02013fe:	00010797          	auipc	a5,0x10
ffffffffc0201402:	12278793          	addi	a5,a5,290 # ffffffffc0211520 <pgfault_num>
ffffffffc0201406:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc020140a:	4398                	lw	a4,0(a5)
ffffffffc020140c:	2701                	sext.w	a4,a4
ffffffffc020140e:	20d71d63          	bne	a4,a3,ffffffffc0201628 <_clock_check_swap+0x248>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0201412:	6691                	lui	a3,0x4
ffffffffc0201414:	4635                	li	a2,13
ffffffffc0201416:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc020141a:	4394                	lw	a3,0(a5)
ffffffffc020141c:	2681                	sext.w	a3,a3
ffffffffc020141e:	1ee69563          	bne	a3,a4,ffffffffc0201608 <_clock_check_swap+0x228>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201422:	6709                	lui	a4,0x2
ffffffffc0201424:	462d                	li	a2,11
ffffffffc0201426:	00c70023          	sb	a2,0(a4) # 2000 <kern_entry-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc020142a:	4398                	lw	a4,0(a5)
ffffffffc020142c:	2701                	sext.w	a4,a4
ffffffffc020142e:	1ad71d63          	bne	a4,a3,ffffffffc02015e8 <_clock_check_swap+0x208>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0201432:	6715                	lui	a4,0x5
ffffffffc0201434:	46b9                	li	a3,14
ffffffffc0201436:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc020143a:	4398                	lw	a4,0(a5)
ffffffffc020143c:	4695                	li	a3,5
ffffffffc020143e:	2701                	sext.w	a4,a4
ffffffffc0201440:	18d71463          	bne	a4,a3,ffffffffc02015c8 <_clock_check_swap+0x1e8>
    assert(pgfault_num==5);
ffffffffc0201444:	4394                	lw	a3,0(a5)
ffffffffc0201446:	2681                	sext.w	a3,a3
ffffffffc0201448:	16e69063          	bne	a3,a4,ffffffffc02015a8 <_clock_check_swap+0x1c8>
    assert(pgfault_num==5);
ffffffffc020144c:	4398                	lw	a4,0(a5)
ffffffffc020144e:	2701                	sext.w	a4,a4
ffffffffc0201450:	12d71c63          	bne	a4,a3,ffffffffc0201588 <_clock_check_swap+0x1a8>
    assert(pgfault_num==5);
ffffffffc0201454:	4394                	lw	a3,0(a5)
ffffffffc0201456:	2681                	sext.w	a3,a3
ffffffffc0201458:	10e69863          	bne	a3,a4,ffffffffc0201568 <_clock_check_swap+0x188>
    assert(pgfault_num==5);
ffffffffc020145c:	4398                	lw	a4,0(a5)
ffffffffc020145e:	2701                	sext.w	a4,a4
ffffffffc0201460:	0ed71463          	bne	a4,a3,ffffffffc0201548 <_clock_check_swap+0x168>
    assert(pgfault_num==5);
ffffffffc0201464:	4394                	lw	a3,0(a5)
ffffffffc0201466:	2681                	sext.w	a3,a3
ffffffffc0201468:	0ce69063          	bne	a3,a4,ffffffffc0201528 <_clock_check_swap+0x148>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc020146c:	6715                	lui	a4,0x5
ffffffffc020146e:	46b9                	li	a3,14
ffffffffc0201470:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc0201474:	4398                	lw	a4,0(a5)
ffffffffc0201476:	4695                	li	a3,5
ffffffffc0201478:	2701                	sext.w	a4,a4
ffffffffc020147a:	08d71763          	bne	a4,a3,ffffffffc0201508 <_clock_check_swap+0x128>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc020147e:	6705                	lui	a4,0x1
ffffffffc0201480:	00074683          	lbu	a3,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201484:	4729                	li	a4,10
ffffffffc0201486:	06e69163          	bne	a3,a4,ffffffffc02014e8 <_clock_check_swap+0x108>
    assert(pgfault_num==6);
ffffffffc020148a:	439c                	lw	a5,0(a5)
ffffffffc020148c:	4719                	li	a4,6
ffffffffc020148e:	2781                	sext.w	a5,a5
ffffffffc0201490:	02e79c63          	bne	a5,a4,ffffffffc02014c8 <_clock_check_swap+0xe8>
    cprintf("CLOCK test passed!\n");
ffffffffc0201494:	00004517          	auipc	a0,0x4
ffffffffc0201498:	df450513          	addi	a0,a0,-524 # ffffffffc0205288 <commands+0xbb8>
ffffffffc020149c:	c1ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc02014a0:	60a2                	ld	ra,8(sp)
ffffffffc02014a2:	4501                	li	a0,0
ffffffffc02014a4:	0141                	addi	sp,sp,16
ffffffffc02014a6:	8082                	ret
    assert(pgfault_num==4);
ffffffffc02014a8:	00004697          	auipc	a3,0x4
ffffffffc02014ac:	d7068693          	addi	a3,a3,-656 # ffffffffc0205218 <commands+0xb48>
ffffffffc02014b0:	00004617          	auipc	a2,0x4
ffffffffc02014b4:	99060613          	addi	a2,a2,-1648 # ffffffffc0204e40 <commands+0x770>
ffffffffc02014b8:	09300593          	li	a1,147
ffffffffc02014bc:	00004517          	auipc	a0,0x4
ffffffffc02014c0:	d6c50513          	addi	a0,a0,-660 # ffffffffc0205228 <commands+0xb58>
ffffffffc02014c4:	c3ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==6);
ffffffffc02014c8:	00004697          	auipc	a3,0x4
ffffffffc02014cc:	db068693          	addi	a3,a3,-592 # ffffffffc0205278 <commands+0xba8>
ffffffffc02014d0:	00004617          	auipc	a2,0x4
ffffffffc02014d4:	97060613          	addi	a2,a2,-1680 # ffffffffc0204e40 <commands+0x770>
ffffffffc02014d8:	0aa00593          	li	a1,170
ffffffffc02014dc:	00004517          	auipc	a0,0x4
ffffffffc02014e0:	d4c50513          	addi	a0,a0,-692 # ffffffffc0205228 <commands+0xb58>
ffffffffc02014e4:	c1ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02014e8:	00004697          	auipc	a3,0x4
ffffffffc02014ec:	d6868693          	addi	a3,a3,-664 # ffffffffc0205250 <commands+0xb80>
ffffffffc02014f0:	00004617          	auipc	a2,0x4
ffffffffc02014f4:	95060613          	addi	a2,a2,-1712 # ffffffffc0204e40 <commands+0x770>
ffffffffc02014f8:	0a800593          	li	a1,168
ffffffffc02014fc:	00004517          	auipc	a0,0x4
ffffffffc0201500:	d2c50513          	addi	a0,a0,-724 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201504:	bfffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0201508:	00004697          	auipc	a3,0x4
ffffffffc020150c:	d3868693          	addi	a3,a3,-712 # ffffffffc0205240 <commands+0xb70>
ffffffffc0201510:	00004617          	auipc	a2,0x4
ffffffffc0201514:	93060613          	addi	a2,a2,-1744 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201518:	0a700593          	li	a1,167
ffffffffc020151c:	00004517          	auipc	a0,0x4
ffffffffc0201520:	d0c50513          	addi	a0,a0,-756 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201524:	bdffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0201528:	00004697          	auipc	a3,0x4
ffffffffc020152c:	d1868693          	addi	a3,a3,-744 # ffffffffc0205240 <commands+0xb70>
ffffffffc0201530:	00004617          	auipc	a2,0x4
ffffffffc0201534:	91060613          	addi	a2,a2,-1776 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201538:	0a500593          	li	a1,165
ffffffffc020153c:	00004517          	auipc	a0,0x4
ffffffffc0201540:	cec50513          	addi	a0,a0,-788 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201544:	bbffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0201548:	00004697          	auipc	a3,0x4
ffffffffc020154c:	cf868693          	addi	a3,a3,-776 # ffffffffc0205240 <commands+0xb70>
ffffffffc0201550:	00004617          	auipc	a2,0x4
ffffffffc0201554:	8f060613          	addi	a2,a2,-1808 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201558:	0a300593          	li	a1,163
ffffffffc020155c:	00004517          	auipc	a0,0x4
ffffffffc0201560:	ccc50513          	addi	a0,a0,-820 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201564:	b9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0201568:	00004697          	auipc	a3,0x4
ffffffffc020156c:	cd868693          	addi	a3,a3,-808 # ffffffffc0205240 <commands+0xb70>
ffffffffc0201570:	00004617          	auipc	a2,0x4
ffffffffc0201574:	8d060613          	addi	a2,a2,-1840 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201578:	0a100593          	li	a1,161
ffffffffc020157c:	00004517          	auipc	a0,0x4
ffffffffc0201580:	cac50513          	addi	a0,a0,-852 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201584:	b7ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0201588:	00004697          	auipc	a3,0x4
ffffffffc020158c:	cb868693          	addi	a3,a3,-840 # ffffffffc0205240 <commands+0xb70>
ffffffffc0201590:	00004617          	auipc	a2,0x4
ffffffffc0201594:	8b060613          	addi	a2,a2,-1872 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201598:	09f00593          	li	a1,159
ffffffffc020159c:	00004517          	auipc	a0,0x4
ffffffffc02015a0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0205228 <commands+0xb58>
ffffffffc02015a4:	b5ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02015a8:	00004697          	auipc	a3,0x4
ffffffffc02015ac:	c9868693          	addi	a3,a3,-872 # ffffffffc0205240 <commands+0xb70>
ffffffffc02015b0:	00004617          	auipc	a2,0x4
ffffffffc02015b4:	89060613          	addi	a2,a2,-1904 # ffffffffc0204e40 <commands+0x770>
ffffffffc02015b8:	09d00593          	li	a1,157
ffffffffc02015bc:	00004517          	auipc	a0,0x4
ffffffffc02015c0:	c6c50513          	addi	a0,a0,-916 # ffffffffc0205228 <commands+0xb58>
ffffffffc02015c4:	b3ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02015c8:	00004697          	auipc	a3,0x4
ffffffffc02015cc:	c7868693          	addi	a3,a3,-904 # ffffffffc0205240 <commands+0xb70>
ffffffffc02015d0:	00004617          	auipc	a2,0x4
ffffffffc02015d4:	87060613          	addi	a2,a2,-1936 # ffffffffc0204e40 <commands+0x770>
ffffffffc02015d8:	09b00593          	li	a1,155
ffffffffc02015dc:	00004517          	auipc	a0,0x4
ffffffffc02015e0:	c4c50513          	addi	a0,a0,-948 # ffffffffc0205228 <commands+0xb58>
ffffffffc02015e4:	b1ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02015e8:	00004697          	auipc	a3,0x4
ffffffffc02015ec:	c3068693          	addi	a3,a3,-976 # ffffffffc0205218 <commands+0xb48>
ffffffffc02015f0:	00004617          	auipc	a2,0x4
ffffffffc02015f4:	85060613          	addi	a2,a2,-1968 # ffffffffc0204e40 <commands+0x770>
ffffffffc02015f8:	09900593          	li	a1,153
ffffffffc02015fc:	00004517          	auipc	a0,0x4
ffffffffc0201600:	c2c50513          	addi	a0,a0,-980 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201604:	afffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc0201608:	00004697          	auipc	a3,0x4
ffffffffc020160c:	c1068693          	addi	a3,a3,-1008 # ffffffffc0205218 <commands+0xb48>
ffffffffc0201610:	00004617          	auipc	a2,0x4
ffffffffc0201614:	83060613          	addi	a2,a2,-2000 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201618:	09700593          	li	a1,151
ffffffffc020161c:	00004517          	auipc	a0,0x4
ffffffffc0201620:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201624:	adffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc0201628:	00004697          	auipc	a3,0x4
ffffffffc020162c:	bf068693          	addi	a3,a3,-1040 # ffffffffc0205218 <commands+0xb48>
ffffffffc0201630:	00004617          	auipc	a2,0x4
ffffffffc0201634:	81060613          	addi	a2,a2,-2032 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201638:	09500593          	li	a1,149
ffffffffc020163c:	00004517          	auipc	a0,0x4
ffffffffc0201640:	bec50513          	addi	a0,a0,-1044 # ffffffffc0205228 <commands+0xb58>
ffffffffc0201644:	abffe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201648 <_clock_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0201648:	7518                	ld	a4,40(a0)
{
ffffffffc020164a:	1141                	addi	sp,sp,-16
ffffffffc020164c:	e406                	sd	ra,8(sp)
     assert(head != NULL);
ffffffffc020164e:	cb2d                	beqz	a4,ffffffffc02016c0 <_clock_swap_out_victim+0x78>
     assert(in_tick==0);
ffffffffc0201650:	ea21                	bnez	a2,ffffffffc02016a0 <_clock_swap_out_victim+0x58>
        list_entry_t *entry = head->prev;
ffffffffc0201652:	631c                	ld	a5,0(a4)
ffffffffc0201654:	86ae                	mv	a3,a1
        if (entry == head) {
ffffffffc0201656:	02e78f63          	beq	a5,a4,ffffffffc0201694 <_clock_swap_out_victim+0x4c>
        if(!page->visited)
ffffffffc020165a:	fe07b603          	ld	a2,-32(a5)
ffffffffc020165e:	00010717          	auipc	a4,0x10
ffffffffc0201662:	eca70713          	addi	a4,a4,-310 # ffffffffc0211528 <curr_ptr>
ffffffffc0201666:	630c                	ld	a1,0(a4)
ffffffffc0201668:	c609                	beqz	a2,ffffffffc0201672 <_clock_swap_out_victim+0x2a>
            page->visited =0;
ffffffffc020166a:	fe07b023          	sd	zero,-32(a5)
        if(!page->visited)
ffffffffc020166e:	e31c                	sd	a5,0(a4)
            page->visited =0;
ffffffffc0201670:	85be                	mv	a1,a5
    __list_del(listelm->prev, listelm->next);
ffffffffc0201672:	6390                	ld	a2,0(a5)
ffffffffc0201674:	6798                	ld	a4,8(a5)
        struct Page* page = le2page(entry,pra_page_link);// 获取页面指针
ffffffffc0201676:	fd078793          	addi	a5,a5,-48
            cprintf("curr_ptr %p\n", curr_ptr);
ffffffffc020167a:	00004517          	auipc	a0,0x4
ffffffffc020167e:	c4650513          	addi	a0,a0,-954 # ffffffffc02052c0 <commands+0xbf0>
    prev->next = next;
ffffffffc0201682:	e618                	sd	a4,8(a2)
    next->prev = prev;
ffffffffc0201684:	e310                	sd	a2,0(a4)
            *ptr_page = page;
ffffffffc0201686:	e29c                	sd	a5,0(a3)
            cprintf("curr_ptr %p\n", curr_ptr);
ffffffffc0201688:	a33fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc020168c:	60a2                	ld	ra,8(sp)
ffffffffc020168e:	4501                	li	a0,0
ffffffffc0201690:	0141                	addi	sp,sp,16
ffffffffc0201692:	8082                	ret
ffffffffc0201694:	60a2                	ld	ra,8(sp)
            *ptr_page = NULL;
ffffffffc0201696:	0005b023          	sd	zero,0(a1) # fffffffffffff000 <end+0x3fdeda88>
}
ffffffffc020169a:	4501                	li	a0,0
ffffffffc020169c:	0141                	addi	sp,sp,16
ffffffffc020169e:	8082                	ret
     assert(in_tick==0);
ffffffffc02016a0:	00004697          	auipc	a3,0x4
ffffffffc02016a4:	c1068693          	addi	a3,a3,-1008 # ffffffffc02052b0 <commands+0xbe0>
ffffffffc02016a8:	00003617          	auipc	a2,0x3
ffffffffc02016ac:	79860613          	addi	a2,a2,1944 # ffffffffc0204e40 <commands+0x770>
ffffffffc02016b0:	04a00593          	li	a1,74
ffffffffc02016b4:	00004517          	auipc	a0,0x4
ffffffffc02016b8:	b7450513          	addi	a0,a0,-1164 # ffffffffc0205228 <commands+0xb58>
ffffffffc02016bc:	a47fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(head != NULL);
ffffffffc02016c0:	00004697          	auipc	a3,0x4
ffffffffc02016c4:	be068693          	addi	a3,a3,-1056 # ffffffffc02052a0 <commands+0xbd0>
ffffffffc02016c8:	00003617          	auipc	a2,0x3
ffffffffc02016cc:	77860613          	addi	a2,a2,1912 # ffffffffc0204e40 <commands+0x770>
ffffffffc02016d0:	04900593          	li	a1,73
ffffffffc02016d4:	00004517          	auipc	a0,0x4
ffffffffc02016d8:	b5450513          	addi	a0,a0,-1196 # ffffffffc0205228 <commands+0xb58>
ffffffffc02016dc:	a27fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02016e0 <_clock_map_swappable>:
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02016e0:	00010697          	auipc	a3,0x10
ffffffffc02016e4:	e486b683          	ld	a3,-440(a3) # ffffffffc0211528 <curr_ptr>
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc02016e8:	751c                	ld	a5,40(a0)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02016ea:	ce81                	beqz	a3,ffffffffc0201702 <_clock_map_swappable+0x22>
    __list_add(elm, listelm, listelm->next);
ffffffffc02016ec:	6794                	ld	a3,8(a5)
ffffffffc02016ee:	03060713          	addi	a4,a2,48
}
ffffffffc02016f2:	4501                	li	a0,0
    prev->next = next->prev = elm;
ffffffffc02016f4:	e298                	sd	a4,0(a3)
ffffffffc02016f6:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc02016f8:	fa1c                	sd	a5,48(a2)
    page->visited = 1;
ffffffffc02016fa:	4785                	li	a5,1
    elm->next = next;
ffffffffc02016fc:	fe14                	sd	a3,56(a2)
ffffffffc02016fe:	ea1c                	sd	a5,16(a2)
}
ffffffffc0201700:	8082                	ret
{
ffffffffc0201702:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0201704:	00004697          	auipc	a3,0x4
ffffffffc0201708:	bcc68693          	addi	a3,a3,-1076 # ffffffffc02052d0 <commands+0xc00>
ffffffffc020170c:	00003617          	auipc	a2,0x3
ffffffffc0201710:	73460613          	addi	a2,a2,1844 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201714:	03700593          	li	a1,55
ffffffffc0201718:	00004517          	auipc	a0,0x4
ffffffffc020171c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0205228 <commands+0xb58>
{
ffffffffc0201720:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0201722:	9e1fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201726 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc0201726:	7135                	addi	sp,sp,-160
ffffffffc0201728:	ed06                	sd	ra,152(sp)
ffffffffc020172a:	e922                	sd	s0,144(sp)
ffffffffc020172c:	e526                	sd	s1,136(sp)
ffffffffc020172e:	e14a                	sd	s2,128(sp)
ffffffffc0201730:	fcce                	sd	s3,120(sp)
ffffffffc0201732:	f8d2                	sd	s4,112(sp)
ffffffffc0201734:	f4d6                	sd	s5,104(sp)
ffffffffc0201736:	f0da                	sd	s6,96(sp)
ffffffffc0201738:	ecde                	sd	s7,88(sp)
ffffffffc020173a:	e8e2                	sd	s8,80(sp)
ffffffffc020173c:	e4e6                	sd	s9,72(sp)
ffffffffc020173e:	e0ea                	sd	s10,64(sp)
ffffffffc0201740:	fc6e                	sd	s11,56(sp)
     swapfs_init();//初始化交换文件系统，负责设置交换分区的基本结构和参数。
ffffffffc0201742:	65e020ef          	jal	ra,ffffffffc0203da0 <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0201746:	00010697          	auipc	a3,0x10
ffffffffc020174a:	dea6b683          	ld	a3,-534(a3) # ffffffffc0211530 <max_swap_offset>
ffffffffc020174e:	010007b7          	lui	a5,0x1000
ffffffffc0201752:	ff968713          	addi	a4,a3,-7
ffffffffc0201756:	17e1                	addi	a5,a5,-8
ffffffffc0201758:	3ee7e063          	bltu	a5,a4,ffffffffc0201b38 <swap_init+0x412>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc020175c:	00009797          	auipc	a5,0x9
ffffffffc0201760:	8a478793          	addi	a5,a5,-1884 # ffffffffc020a000 <swap_manager_clock>
     //sm = &swap_manager_lru;
     int r = sm->init();//初始化选定的页面替换算法
ffffffffc0201764:	6798                	ld	a4,8(a5)
     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc0201766:	00010b17          	auipc	s6,0x10
ffffffffc020176a:	dd2b0b13          	addi	s6,s6,-558 # ffffffffc0211538 <sm>
ffffffffc020176e:	00fb3023          	sd	a5,0(s6)
     int r = sm->init();//初始化选定的页面替换算法
ffffffffc0201772:	9702                	jalr	a4
ffffffffc0201774:	89aa                	mv	s3,a0
     
     if (r == 0)
ffffffffc0201776:	c10d                	beqz	a0,ffffffffc0201798 <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc0201778:	60ea                	ld	ra,152(sp)
ffffffffc020177a:	644a                	ld	s0,144(sp)
ffffffffc020177c:	64aa                	ld	s1,136(sp)
ffffffffc020177e:	690a                	ld	s2,128(sp)
ffffffffc0201780:	7a46                	ld	s4,112(sp)
ffffffffc0201782:	7aa6                	ld	s5,104(sp)
ffffffffc0201784:	7b06                	ld	s6,96(sp)
ffffffffc0201786:	6be6                	ld	s7,88(sp)
ffffffffc0201788:	6c46                	ld	s8,80(sp)
ffffffffc020178a:	6ca6                	ld	s9,72(sp)
ffffffffc020178c:	6d06                	ld	s10,64(sp)
ffffffffc020178e:	7de2                	ld	s11,56(sp)
ffffffffc0201790:	854e                	mv	a0,s3
ffffffffc0201792:	79e6                	ld	s3,120(sp)
ffffffffc0201794:	610d                	addi	sp,sp,160
ffffffffc0201796:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0201798:	000b3783          	ld	a5,0(s6)
ffffffffc020179c:	00004517          	auipc	a0,0x4
ffffffffc02017a0:	ba450513          	addi	a0,a0,-1116 # ffffffffc0205340 <commands+0xc70>
    return listelm->next;
ffffffffc02017a4:	00010497          	auipc	s1,0x10
ffffffffc02017a8:	93c48493          	addi	s1,s1,-1732 # ffffffffc02110e0 <free_area>
ffffffffc02017ac:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc02017ae:	4785                	li	a5,1
ffffffffc02017b0:	00010717          	auipc	a4,0x10
ffffffffc02017b4:	d8f72823          	sw	a5,-624(a4) # ffffffffc0211540 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02017b8:	903fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02017bc:	649c                	ld	a5,8(s1)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc02017be:	4401                	li	s0,0
ffffffffc02017c0:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02017c2:	2c978163          	beq	a5,s1,ffffffffc0201a84 <swap_init+0x35e>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02017c6:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02017ca:	8b09                	andi	a4,a4,2
ffffffffc02017cc:	2a070e63          	beqz	a4,ffffffffc0201a88 <swap_init+0x362>
        count ++, total += p->property;
ffffffffc02017d0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02017d4:	679c                	ld	a5,8(a5)
ffffffffc02017d6:	2d05                	addiw	s10,s10,1
ffffffffc02017d8:	9c39                	addw	s0,s0,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc02017da:	fe9796e3          	bne	a5,s1,ffffffffc02017c6 <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc02017de:	8922                	mv	s2,s0
ffffffffc02017e0:	338010ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc02017e4:	47251663          	bne	a0,s2,ffffffffc0201c50 <swap_init+0x52a>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc02017e8:	8622                	mv	a2,s0
ffffffffc02017ea:	85ea                	mv	a1,s10
ffffffffc02017ec:	00004517          	auipc	a0,0x4
ffffffffc02017f0:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0205388 <commands+0xcb8>
ffffffffc02017f4:	8c7fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc02017f8:	b3cff0ef          	jal	ra,ffffffffc0200b34 <mm_create>
ffffffffc02017fc:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc02017fe:	52050963          	beqz	a0,ffffffffc0201d30 <swap_init+0x60a>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0201802:	00010797          	auipc	a5,0x10
ffffffffc0201806:	d1678793          	addi	a5,a5,-746 # ffffffffc0211518 <check_mm_struct>
ffffffffc020180a:	6398                	ld	a4,0(a5)
ffffffffc020180c:	54071263          	bnez	a4,ffffffffc0201d50 <swap_init+0x62a>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0201810:	00010b97          	auipc	s7,0x10
ffffffffc0201814:	d40bbb83          	ld	s7,-704(s7) # ffffffffc0211550 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc0201818:	000bb703          	ld	a4,0(s7)
     check_mm_struct = mm;
ffffffffc020181c:	e388                	sd	a0,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc020181e:	01753c23          	sd	s7,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0201822:	3c071763          	bnez	a4,ffffffffc0201bf0 <swap_init+0x4ca>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc0201826:	6599                	lui	a1,0x6
ffffffffc0201828:	460d                	li	a2,3
ffffffffc020182a:	6505                	lui	a0,0x1
ffffffffc020182c:	b50ff0ef          	jal	ra,ffffffffc0200b7c <vma_create>
ffffffffc0201830:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0201832:	3c050f63          	beqz	a0,ffffffffc0201c10 <swap_init+0x4ea>

     insert_vma_struct(mm, vma);
ffffffffc0201836:	8556                	mv	a0,s5
ffffffffc0201838:	bb2ff0ef          	jal	ra,ffffffffc0200bea <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc020183c:	00004517          	auipc	a0,0x4
ffffffffc0201840:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02053c8 <commands+0xcf8>
ffffffffc0201844:	877fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0201848:	018ab503          	ld	a0,24(s5)
ffffffffc020184c:	4605                	li	a2,1
ffffffffc020184e:	6585                	lui	a1,0x1
ffffffffc0201850:	302010ef          	jal	ra,ffffffffc0202b52 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0201854:	3c050e63          	beqz	a0,ffffffffc0201c30 <swap_init+0x50a>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0201858:	00004517          	auipc	a0,0x4
ffffffffc020185c:	bc050513          	addi	a0,a0,-1088 # ffffffffc0205418 <commands+0xd48>
ffffffffc0201860:	00010917          	auipc	s2,0x10
ffffffffc0201864:	81090913          	addi	s2,s2,-2032 # ffffffffc0211070 <check_rp>
ffffffffc0201868:	853fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020186c:	00010a17          	auipc	s4,0x10
ffffffffc0201870:	824a0a13          	addi	s4,s4,-2012 # ffffffffc0211090 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0201874:	8c4a                	mv	s8,s2
          check_rp[i] = alloc_page();
ffffffffc0201876:	4505                	li	a0,1
ffffffffc0201878:	1ce010ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020187c:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc0201880:	28050c63          	beqz	a0,ffffffffc0201b18 <swap_init+0x3f2>
ffffffffc0201884:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0201886:	8b89                	andi	a5,a5,2
ffffffffc0201888:	26079863          	bnez	a5,ffffffffc0201af8 <swap_init+0x3d2>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020188c:	0c21                	addi	s8,s8,8
ffffffffc020188e:	ff4c14e3          	bne	s8,s4,ffffffffc0201876 <swap_init+0x150>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0201892:	609c                	ld	a5,0(s1)
ffffffffc0201894:	0084bd83          	ld	s11,8(s1)
    elm->prev = elm->next = elm;
ffffffffc0201898:	e084                	sd	s1,0(s1)
ffffffffc020189a:	f03e                	sd	a5,32(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc020189c:	489c                	lw	a5,16(s1)
ffffffffc020189e:	e484                	sd	s1,8(s1)
     nr_free = 0;
ffffffffc02018a0:	0000fc17          	auipc	s8,0xf
ffffffffc02018a4:	7d0c0c13          	addi	s8,s8,2000 # ffffffffc0211070 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc02018a8:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc02018aa:	00010797          	auipc	a5,0x10
ffffffffc02018ae:	8407a323          	sw	zero,-1978(a5) # ffffffffc02110f0 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc02018b2:	000c3503          	ld	a0,0(s8)
ffffffffc02018b6:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02018b8:	0c21                	addi	s8,s8,8
        free_pages(check_rp[i],1);
ffffffffc02018ba:	21e010ef          	jal	ra,ffffffffc0202ad8 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02018be:	ff4c1ae3          	bne	s8,s4,ffffffffc02018b2 <swap_init+0x18c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02018c2:	0104ac03          	lw	s8,16(s1)
ffffffffc02018c6:	4791                	li	a5,4
ffffffffc02018c8:	4afc1463          	bne	s8,a5,ffffffffc0201d70 <swap_init+0x64a>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc02018cc:	00004517          	auipc	a0,0x4
ffffffffc02018d0:	bd450513          	addi	a0,a0,-1068 # ffffffffc02054a0 <commands+0xdd0>
ffffffffc02018d4:	fe6fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02018d8:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc02018da:	00010797          	auipc	a5,0x10
ffffffffc02018de:	c407a323          	sw	zero,-954(a5) # ffffffffc0211520 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02018e2:	4529                	li	a0,10
ffffffffc02018e4:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc02018e8:	00010597          	auipc	a1,0x10
ffffffffc02018ec:	c385a583          	lw	a1,-968(a1) # ffffffffc0211520 <pgfault_num>
ffffffffc02018f0:	4805                	li	a6,1
ffffffffc02018f2:	00010797          	auipc	a5,0x10
ffffffffc02018f6:	c2e78793          	addi	a5,a5,-978 # ffffffffc0211520 <pgfault_num>
ffffffffc02018fa:	3f059b63          	bne	a1,a6,ffffffffc0201cf0 <swap_init+0x5ca>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc02018fe:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0201902:	4390                	lw	a2,0(a5)
ffffffffc0201904:	2601                	sext.w	a2,a2
ffffffffc0201906:	40b61563          	bne	a2,a1,ffffffffc0201d10 <swap_init+0x5ea>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc020190a:	6589                	lui	a1,0x2
ffffffffc020190c:	452d                	li	a0,11
ffffffffc020190e:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0201912:	4390                	lw	a2,0(a5)
ffffffffc0201914:	4809                	li	a6,2
ffffffffc0201916:	2601                	sext.w	a2,a2
ffffffffc0201918:	35061c63          	bne	a2,a6,ffffffffc0201c70 <swap_init+0x54a>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc020191c:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc0201920:	438c                	lw	a1,0(a5)
ffffffffc0201922:	2581                	sext.w	a1,a1
ffffffffc0201924:	36c59663          	bne	a1,a2,ffffffffc0201c90 <swap_init+0x56a>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0201928:	658d                	lui	a1,0x3
ffffffffc020192a:	4531                	li	a0,12
ffffffffc020192c:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0201930:	4390                	lw	a2,0(a5)
ffffffffc0201932:	480d                	li	a6,3
ffffffffc0201934:	2601                	sext.w	a2,a2
ffffffffc0201936:	37061d63          	bne	a2,a6,ffffffffc0201cb0 <swap_init+0x58a>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc020193a:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc020193e:	438c                	lw	a1,0(a5)
ffffffffc0201940:	2581                	sext.w	a1,a1
ffffffffc0201942:	38c59763          	bne	a1,a2,ffffffffc0201cd0 <swap_init+0x5aa>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc0201946:	6591                	lui	a1,0x4
ffffffffc0201948:	4535                	li	a0,13
ffffffffc020194a:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc020194e:	4390                	lw	a2,0(a5)
ffffffffc0201950:	2601                	sext.w	a2,a2
ffffffffc0201952:	21861f63          	bne	a2,s8,ffffffffc0201b70 <swap_init+0x44a>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc0201956:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc020195a:	439c                	lw	a5,0(a5)
ffffffffc020195c:	2781                	sext.w	a5,a5
ffffffffc020195e:	22c79963          	bne	a5,a2,ffffffffc0201b90 <swap_init+0x46a>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0201962:	489c                	lw	a5,16(s1)
ffffffffc0201964:	24079663          	bnez	a5,ffffffffc0201bb0 <swap_init+0x48a>
ffffffffc0201968:	0000f797          	auipc	a5,0xf
ffffffffc020196c:	72878793          	addi	a5,a5,1832 # ffffffffc0211090 <swap_in_seq_no>
ffffffffc0201970:	0000f617          	auipc	a2,0xf
ffffffffc0201974:	74860613          	addi	a2,a2,1864 # ffffffffc02110b8 <swap_out_seq_no>
ffffffffc0201978:	0000f517          	auipc	a0,0xf
ffffffffc020197c:	74050513          	addi	a0,a0,1856 # ffffffffc02110b8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0201980:	55fd                	li	a1,-1
ffffffffc0201982:	c38c                	sw	a1,0(a5)
ffffffffc0201984:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0201986:	0791                	addi	a5,a5,4
ffffffffc0201988:	0611                	addi	a2,a2,4
ffffffffc020198a:	fef51ce3          	bne	a0,a5,ffffffffc0201982 <swap_init+0x25c>
ffffffffc020198e:	0000f817          	auipc	a6,0xf
ffffffffc0201992:	6c280813          	addi	a6,a6,1730 # ffffffffc0211050 <check_ptep>
ffffffffc0201996:	0000f897          	auipc	a7,0xf
ffffffffc020199a:	6da88893          	addi	a7,a7,1754 # ffffffffc0211070 <check_rp>
ffffffffc020199e:	6585                	lui	a1,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc02019a0:	00010c97          	auipc	s9,0x10
ffffffffc02019a4:	bc0c8c93          	addi	s9,s9,-1088 # ffffffffc0211560 <pages>
ffffffffc02019a8:	00005c17          	auipc	s8,0x5
ffffffffc02019ac:	968c0c13          	addi	s8,s8,-1688 # ffffffffc0206310 <nbase>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc02019b0:	00083023          	sd	zero,0(a6)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02019b4:	4601                	li	a2,0
ffffffffc02019b6:	855e                	mv	a0,s7
ffffffffc02019b8:	ec46                	sd	a7,24(sp)
ffffffffc02019ba:	e82e                	sd	a1,16(sp)
         check_ptep[i]=0;
ffffffffc02019bc:	e442                	sd	a6,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02019be:	194010ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc02019c2:	6822                	ld	a6,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc02019c4:	65c2                	ld	a1,16(sp)
ffffffffc02019c6:	68e2                	ld	a7,24(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02019c8:	00a83023          	sd	a0,0(a6)
         assert(check_ptep[i] != NULL);
ffffffffc02019cc:	00010317          	auipc	t1,0x10
ffffffffc02019d0:	b8c30313          	addi	t1,t1,-1140 # ffffffffc0211558 <npage>
ffffffffc02019d4:	16050e63          	beqz	a0,ffffffffc0201b50 <swap_init+0x42a>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc02019d8:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02019da:	0017f613          	andi	a2,a5,1
ffffffffc02019de:	0e060563          	beqz	a2,ffffffffc0201ac8 <swap_init+0x3a2>
    if (PPN(pa) >= npage) {
ffffffffc02019e2:	00033603          	ld	a2,0(t1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02019e6:	078a                	slli	a5,a5,0x2
ffffffffc02019e8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02019ea:	0ec7fb63          	bgeu	a5,a2,ffffffffc0201ae0 <swap_init+0x3ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02019ee:	000c3603          	ld	a2,0(s8)
ffffffffc02019f2:	000cb503          	ld	a0,0(s9)
ffffffffc02019f6:	0008bf03          	ld	t5,0(a7)
ffffffffc02019fa:	8f91                	sub	a5,a5,a2
ffffffffc02019fc:	00379613          	slli	a2,a5,0x3
ffffffffc0201a00:	97b2                	add	a5,a5,a2
ffffffffc0201a02:	078e                	slli	a5,a5,0x3
ffffffffc0201a04:	97aa                	add	a5,a5,a0
ffffffffc0201a06:	0aff1163          	bne	t5,a5,ffffffffc0201aa8 <swap_init+0x382>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201a0a:	6785                	lui	a5,0x1
ffffffffc0201a0c:	95be                	add	a1,a1,a5
ffffffffc0201a0e:	6795                	lui	a5,0x5
ffffffffc0201a10:	0821                	addi	a6,a6,8
ffffffffc0201a12:	08a1                	addi	a7,a7,8
ffffffffc0201a14:	f8f59ee3          	bne	a1,a5,ffffffffc02019b0 <swap_init+0x28a>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0201a18:	00004517          	auipc	a0,0x4
ffffffffc0201a1c:	b5850513          	addi	a0,a0,-1192 # ffffffffc0205570 <commands+0xea0>
ffffffffc0201a20:	e9afe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = sm->check_swap();
ffffffffc0201a24:	000b3783          	ld	a5,0(s6)
ffffffffc0201a28:	7f9c                	ld	a5,56(a5)
ffffffffc0201a2a:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc0201a2c:	1a051263          	bnez	a0,ffffffffc0201bd0 <swap_init+0x4aa>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc0201a30:	00093503          	ld	a0,0(s2)
ffffffffc0201a34:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201a36:	0921                	addi	s2,s2,8
         free_pages(check_rp[i],1);
ffffffffc0201a38:	0a0010ef          	jal	ra,ffffffffc0202ad8 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201a3c:	ff491ae3          	bne	s2,s4,ffffffffc0201a30 <swap_init+0x30a>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc0201a40:	8556                	mv	a0,s5
ffffffffc0201a42:	a78ff0ef          	jal	ra,ffffffffc0200cba <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc0201a46:	77a2                	ld	a5,40(sp)
     free_list = free_list_store;
ffffffffc0201a48:	01b4b423          	sd	s11,8(s1)
     nr_free = nr_free_store;
ffffffffc0201a4c:	c89c                	sw	a5,16(s1)
     free_list = free_list_store;
ffffffffc0201a4e:	7782                	ld	a5,32(sp)
ffffffffc0201a50:	e09c                	sd	a5,0(s1)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201a52:	009d8a63          	beq	s11,s1,ffffffffc0201a66 <swap_init+0x340>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0201a56:	ff8da783          	lw	a5,-8(s11)
    return listelm->next;
ffffffffc0201a5a:	008dbd83          	ld	s11,8(s11)
ffffffffc0201a5e:	3d7d                	addiw	s10,s10,-1
ffffffffc0201a60:	9c1d                	subw	s0,s0,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201a62:	fe9d9ae3          	bne	s11,s1,ffffffffc0201a56 <swap_init+0x330>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc0201a66:	8622                	mv	a2,s0
ffffffffc0201a68:	85ea                	mv	a1,s10
ffffffffc0201a6a:	00004517          	auipc	a0,0x4
ffffffffc0201a6e:	b3650513          	addi	a0,a0,-1226 # ffffffffc02055a0 <commands+0xed0>
ffffffffc0201a72:	e48fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc0201a76:	00004517          	auipc	a0,0x4
ffffffffc0201a7a:	b4a50513          	addi	a0,a0,-1206 # ffffffffc02055c0 <commands+0xef0>
ffffffffc0201a7e:	e3cfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201a82:	b9dd                	j	ffffffffc0201778 <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201a84:	4901                	li	s2,0
ffffffffc0201a86:	bba9                	j	ffffffffc02017e0 <swap_init+0xba>
        assert(PageProperty(p));
ffffffffc0201a88:	00004697          	auipc	a3,0x4
ffffffffc0201a8c:	8d068693          	addi	a3,a3,-1840 # ffffffffc0205358 <commands+0xc88>
ffffffffc0201a90:	00003617          	auipc	a2,0x3
ffffffffc0201a94:	3b060613          	addi	a2,a2,944 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201a98:	0bc00593          	li	a1,188
ffffffffc0201a9c:	00004517          	auipc	a0,0x4
ffffffffc0201aa0:	89450513          	addi	a0,a0,-1900 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201aa4:	e5efe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0201aa8:	00004697          	auipc	a3,0x4
ffffffffc0201aac:	aa068693          	addi	a3,a3,-1376 # ffffffffc0205548 <commands+0xe78>
ffffffffc0201ab0:	00003617          	auipc	a2,0x3
ffffffffc0201ab4:	39060613          	addi	a2,a2,912 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201ab8:	0fc00593          	li	a1,252
ffffffffc0201abc:	00004517          	auipc	a0,0x4
ffffffffc0201ac0:	87450513          	addi	a0,a0,-1932 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201ac4:	e3efe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0201ac8:	00004617          	auipc	a2,0x4
ffffffffc0201acc:	a5860613          	addi	a2,a2,-1448 # ffffffffc0205520 <commands+0xe50>
ffffffffc0201ad0:	07000593          	li	a1,112
ffffffffc0201ad4:	00003517          	auipc	a0,0x3
ffffffffc0201ad8:	5dc50513          	addi	a0,a0,1500 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0201adc:	e26fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201ae0:	00003617          	auipc	a2,0x3
ffffffffc0201ae4:	5b060613          	addi	a2,a2,1456 # ffffffffc0205090 <commands+0x9c0>
ffffffffc0201ae8:	06500593          	li	a1,101
ffffffffc0201aec:	00003517          	auipc	a0,0x3
ffffffffc0201af0:	5c450513          	addi	a0,a0,1476 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0201af4:	e0efe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0201af8:	00004697          	auipc	a3,0x4
ffffffffc0201afc:	96068693          	addi	a3,a3,-1696 # ffffffffc0205458 <commands+0xd88>
ffffffffc0201b00:	00003617          	auipc	a2,0x3
ffffffffc0201b04:	34060613          	addi	a2,a2,832 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201b08:	0dd00593          	li	a1,221
ffffffffc0201b0c:	00004517          	auipc	a0,0x4
ffffffffc0201b10:	82450513          	addi	a0,a0,-2012 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201b14:	deefe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0201b18:	00004697          	auipc	a3,0x4
ffffffffc0201b1c:	92868693          	addi	a3,a3,-1752 # ffffffffc0205440 <commands+0xd70>
ffffffffc0201b20:	00003617          	auipc	a2,0x3
ffffffffc0201b24:	32060613          	addi	a2,a2,800 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201b28:	0dc00593          	li	a1,220
ffffffffc0201b2c:	00004517          	auipc	a0,0x4
ffffffffc0201b30:	80450513          	addi	a0,a0,-2044 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201b34:	dcefe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0201b38:	00003617          	auipc	a2,0x3
ffffffffc0201b3c:	7d860613          	addi	a2,a2,2008 # ffffffffc0205310 <commands+0xc40>
ffffffffc0201b40:	02800593          	li	a1,40
ffffffffc0201b44:	00003517          	auipc	a0,0x3
ffffffffc0201b48:	7ec50513          	addi	a0,a0,2028 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201b4c:	db6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0201b50:	00004697          	auipc	a3,0x4
ffffffffc0201b54:	9b868693          	addi	a3,a3,-1608 # ffffffffc0205508 <commands+0xe38>
ffffffffc0201b58:	00003617          	auipc	a2,0x3
ffffffffc0201b5c:	2e860613          	addi	a2,a2,744 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201b60:	0fb00593          	li	a1,251
ffffffffc0201b64:	00003517          	auipc	a0,0x3
ffffffffc0201b68:	7cc50513          	addi	a0,a0,1996 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201b6c:	d96fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc0201b70:	00003697          	auipc	a3,0x3
ffffffffc0201b74:	6a868693          	addi	a3,a3,1704 # ffffffffc0205218 <commands+0xb48>
ffffffffc0201b78:	00003617          	auipc	a2,0x3
ffffffffc0201b7c:	2c860613          	addi	a2,a2,712 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201b80:	09f00593          	li	a1,159
ffffffffc0201b84:	00003517          	auipc	a0,0x3
ffffffffc0201b88:	7ac50513          	addi	a0,a0,1964 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201b8c:	d76fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc0201b90:	00003697          	auipc	a3,0x3
ffffffffc0201b94:	68868693          	addi	a3,a3,1672 # ffffffffc0205218 <commands+0xb48>
ffffffffc0201b98:	00003617          	auipc	a2,0x3
ffffffffc0201b9c:	2a860613          	addi	a2,a2,680 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201ba0:	0a100593          	li	a1,161
ffffffffc0201ba4:	00003517          	auipc	a0,0x3
ffffffffc0201ba8:	78c50513          	addi	a0,a0,1932 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201bac:	d56fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert( nr_free == 0);         
ffffffffc0201bb0:	00004697          	auipc	a3,0x4
ffffffffc0201bb4:	94868693          	addi	a3,a3,-1720 # ffffffffc02054f8 <commands+0xe28>
ffffffffc0201bb8:	00003617          	auipc	a2,0x3
ffffffffc0201bbc:	28860613          	addi	a2,a2,648 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201bc0:	0f300593          	li	a1,243
ffffffffc0201bc4:	00003517          	auipc	a0,0x3
ffffffffc0201bc8:	76c50513          	addi	a0,a0,1900 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201bcc:	d36fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(ret==0);
ffffffffc0201bd0:	00004697          	auipc	a3,0x4
ffffffffc0201bd4:	9c868693          	addi	a3,a3,-1592 # ffffffffc0205598 <commands+0xec8>
ffffffffc0201bd8:	00003617          	auipc	a2,0x3
ffffffffc0201bdc:	26860613          	addi	a2,a2,616 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201be0:	10200593          	li	a1,258
ffffffffc0201be4:	00003517          	auipc	a0,0x3
ffffffffc0201be8:	74c50513          	addi	a0,a0,1868 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201bec:	d16fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0201bf0:	00003697          	auipc	a3,0x3
ffffffffc0201bf4:	46068693          	addi	a3,a3,1120 # ffffffffc0205050 <commands+0x980>
ffffffffc0201bf8:	00003617          	auipc	a2,0x3
ffffffffc0201bfc:	24860613          	addi	a2,a2,584 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201c00:	0cc00593          	li	a1,204
ffffffffc0201c04:	00003517          	auipc	a0,0x3
ffffffffc0201c08:	72c50513          	addi	a0,a0,1836 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201c0c:	cf6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(vma != NULL);
ffffffffc0201c10:	00003697          	auipc	a3,0x3
ffffffffc0201c14:	4e868693          	addi	a3,a3,1256 # ffffffffc02050f8 <commands+0xa28>
ffffffffc0201c18:	00003617          	auipc	a2,0x3
ffffffffc0201c1c:	22860613          	addi	a2,a2,552 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201c20:	0cf00593          	li	a1,207
ffffffffc0201c24:	00003517          	auipc	a0,0x3
ffffffffc0201c28:	70c50513          	addi	a0,a0,1804 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201c2c:	cd6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0201c30:	00003697          	auipc	a3,0x3
ffffffffc0201c34:	7d068693          	addi	a3,a3,2000 # ffffffffc0205400 <commands+0xd30>
ffffffffc0201c38:	00003617          	auipc	a2,0x3
ffffffffc0201c3c:	20860613          	addi	a2,a2,520 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201c40:	0d700593          	li	a1,215
ffffffffc0201c44:	00003517          	auipc	a0,0x3
ffffffffc0201c48:	6ec50513          	addi	a0,a0,1772 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201c4c:	cb6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(total == nr_free_pages());
ffffffffc0201c50:	00003697          	auipc	a3,0x3
ffffffffc0201c54:	71868693          	addi	a3,a3,1816 # ffffffffc0205368 <commands+0xc98>
ffffffffc0201c58:	00003617          	auipc	a2,0x3
ffffffffc0201c5c:	1e860613          	addi	a2,a2,488 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201c60:	0bf00593          	li	a1,191
ffffffffc0201c64:	00003517          	auipc	a0,0x3
ffffffffc0201c68:	6cc50513          	addi	a0,a0,1740 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201c6c:	c96fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc0201c70:	00004697          	auipc	a3,0x4
ffffffffc0201c74:	86868693          	addi	a3,a3,-1944 # ffffffffc02054d8 <commands+0xe08>
ffffffffc0201c78:	00003617          	auipc	a2,0x3
ffffffffc0201c7c:	1c860613          	addi	a2,a2,456 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201c80:	09700593          	li	a1,151
ffffffffc0201c84:	00003517          	auipc	a0,0x3
ffffffffc0201c88:	6ac50513          	addi	a0,a0,1708 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201c8c:	c76fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc0201c90:	00004697          	auipc	a3,0x4
ffffffffc0201c94:	84868693          	addi	a3,a3,-1976 # ffffffffc02054d8 <commands+0xe08>
ffffffffc0201c98:	00003617          	auipc	a2,0x3
ffffffffc0201c9c:	1a860613          	addi	a2,a2,424 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201ca0:	09900593          	li	a1,153
ffffffffc0201ca4:	00003517          	auipc	a0,0x3
ffffffffc0201ca8:	68c50513          	addi	a0,a0,1676 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201cac:	c56fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201cb0:	00004697          	auipc	a3,0x4
ffffffffc0201cb4:	83868693          	addi	a3,a3,-1992 # ffffffffc02054e8 <commands+0xe18>
ffffffffc0201cb8:	00003617          	auipc	a2,0x3
ffffffffc0201cbc:	18860613          	addi	a2,a2,392 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201cc0:	09b00593          	li	a1,155
ffffffffc0201cc4:	00003517          	auipc	a0,0x3
ffffffffc0201cc8:	66c50513          	addi	a0,a0,1644 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201ccc:	c36fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201cd0:	00004697          	auipc	a3,0x4
ffffffffc0201cd4:	81868693          	addi	a3,a3,-2024 # ffffffffc02054e8 <commands+0xe18>
ffffffffc0201cd8:	00003617          	auipc	a2,0x3
ffffffffc0201cdc:	16860613          	addi	a2,a2,360 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201ce0:	09d00593          	li	a1,157
ffffffffc0201ce4:	00003517          	auipc	a0,0x3
ffffffffc0201ce8:	64c50513          	addi	a0,a0,1612 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201cec:	c16fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc0201cf0:	00003697          	auipc	a3,0x3
ffffffffc0201cf4:	7d868693          	addi	a3,a3,2008 # ffffffffc02054c8 <commands+0xdf8>
ffffffffc0201cf8:	00003617          	auipc	a2,0x3
ffffffffc0201cfc:	14860613          	addi	a2,a2,328 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201d00:	09300593          	li	a1,147
ffffffffc0201d04:	00003517          	auipc	a0,0x3
ffffffffc0201d08:	62c50513          	addi	a0,a0,1580 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201d0c:	bf6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc0201d10:	00003697          	auipc	a3,0x3
ffffffffc0201d14:	7b868693          	addi	a3,a3,1976 # ffffffffc02054c8 <commands+0xdf8>
ffffffffc0201d18:	00003617          	auipc	a2,0x3
ffffffffc0201d1c:	12860613          	addi	a2,a2,296 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201d20:	09500593          	li	a1,149
ffffffffc0201d24:	00003517          	auipc	a0,0x3
ffffffffc0201d28:	60c50513          	addi	a0,a0,1548 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201d2c:	bd6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(mm != NULL);
ffffffffc0201d30:	00003697          	auipc	a3,0x3
ffffffffc0201d34:	3f068693          	addi	a3,a3,1008 # ffffffffc0205120 <commands+0xa50>
ffffffffc0201d38:	00003617          	auipc	a2,0x3
ffffffffc0201d3c:	10860613          	addi	a2,a2,264 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201d40:	0c400593          	li	a1,196
ffffffffc0201d44:	00003517          	auipc	a0,0x3
ffffffffc0201d48:	5ec50513          	addi	a0,a0,1516 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201d4c:	bb6fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0201d50:	00003697          	auipc	a3,0x3
ffffffffc0201d54:	66068693          	addi	a3,a3,1632 # ffffffffc02053b0 <commands+0xce0>
ffffffffc0201d58:	00003617          	auipc	a2,0x3
ffffffffc0201d5c:	0e860613          	addi	a2,a2,232 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201d60:	0c700593          	li	a1,199
ffffffffc0201d64:	00003517          	auipc	a0,0x3
ffffffffc0201d68:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201d6c:	b96fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0201d70:	00003697          	auipc	a3,0x3
ffffffffc0201d74:	70868693          	addi	a3,a3,1800 # ffffffffc0205478 <commands+0xda8>
ffffffffc0201d78:	00003617          	auipc	a2,0x3
ffffffffc0201d7c:	0c860613          	addi	a2,a2,200 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201d80:	0ea00593          	li	a1,234
ffffffffc0201d84:	00003517          	auipc	a0,0x3
ffffffffc0201d88:	5ac50513          	addi	a0,a0,1452 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201d8c:	b76fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201d90 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0201d90:	0000f797          	auipc	a5,0xf
ffffffffc0201d94:	7a87b783          	ld	a5,1960(a5) # ffffffffc0211538 <sm>
ffffffffc0201d98:	6b9c                	ld	a5,16(a5)
ffffffffc0201d9a:	8782                	jr	a5

ffffffffc0201d9c <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0201d9c:	0000f797          	auipc	a5,0xf
ffffffffc0201da0:	79c7b783          	ld	a5,1948(a5) # ffffffffc0211538 <sm>
ffffffffc0201da4:	739c                	ld	a5,32(a5)
ffffffffc0201da6:	8782                	jr	a5

ffffffffc0201da8 <swap_out>:
{
ffffffffc0201da8:	711d                	addi	sp,sp,-96
ffffffffc0201daa:	ec86                	sd	ra,88(sp)
ffffffffc0201dac:	e8a2                	sd	s0,80(sp)
ffffffffc0201dae:	e4a6                	sd	s1,72(sp)
ffffffffc0201db0:	e0ca                	sd	s2,64(sp)
ffffffffc0201db2:	fc4e                	sd	s3,56(sp)
ffffffffc0201db4:	f852                	sd	s4,48(sp)
ffffffffc0201db6:	f456                	sd	s5,40(sp)
ffffffffc0201db8:	f05a                	sd	s6,32(sp)
ffffffffc0201dba:	ec5e                	sd	s7,24(sp)
ffffffffc0201dbc:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0201dbe:	cde9                	beqz	a1,ffffffffc0201e98 <swap_out+0xf0>
ffffffffc0201dc0:	8a2e                	mv	s4,a1
ffffffffc0201dc2:	892a                	mv	s2,a0
ffffffffc0201dc4:	8ab2                	mv	s5,a2
ffffffffc0201dc6:	4401                	li	s0,0
ffffffffc0201dc8:	0000f997          	auipc	s3,0xf
ffffffffc0201dcc:	77098993          	addi	s3,s3,1904 # ffffffffc0211538 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201dd0:	00004b17          	auipc	s6,0x4
ffffffffc0201dd4:	870b0b13          	addi	s6,s6,-1936 # ffffffffc0205640 <commands+0xf70>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201dd8:	00004b97          	auipc	s7,0x4
ffffffffc0201ddc:	850b8b93          	addi	s7,s7,-1968 # ffffffffc0205628 <commands+0xf58>
ffffffffc0201de0:	a825                	j	ffffffffc0201e18 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201de2:	67a2                	ld	a5,8(sp)
ffffffffc0201de4:	8626                	mv	a2,s1
ffffffffc0201de6:	85a2                	mv	a1,s0
ffffffffc0201de8:	63b4                	ld	a3,64(a5)
ffffffffc0201dea:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0201dec:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201dee:	82b1                	srli	a3,a3,0xc
ffffffffc0201df0:	0685                	addi	a3,a3,1
ffffffffc0201df2:	ac8fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201df6:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0201df8:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201dfa:	613c                	ld	a5,64(a0)
ffffffffc0201dfc:	83b1                	srli	a5,a5,0xc
ffffffffc0201dfe:	0785                	addi	a5,a5,1
ffffffffc0201e00:	07a2                	slli	a5,a5,0x8
ffffffffc0201e02:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0201e06:	4d3000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0201e0a:	01893503          	ld	a0,24(s2)
ffffffffc0201e0e:	85a6                	mv	a1,s1
ffffffffc0201e10:	531010ef          	jal	ra,ffffffffc0203b40 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0201e14:	048a0d63          	beq	s4,s0,ffffffffc0201e6e <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0201e18:	0009b783          	ld	a5,0(s3)
ffffffffc0201e1c:	8656                	mv	a2,s5
ffffffffc0201e1e:	002c                	addi	a1,sp,8
ffffffffc0201e20:	7b9c                	ld	a5,48(a5)
ffffffffc0201e22:	854a                	mv	a0,s2
ffffffffc0201e24:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0201e26:	e12d                	bnez	a0,ffffffffc0201e88 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0201e28:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201e2a:	01893503          	ld	a0,24(s2)
ffffffffc0201e2e:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0201e30:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201e32:	85a6                	mv	a1,s1
ffffffffc0201e34:	51f000ef          	jal	ra,ffffffffc0202b52 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201e38:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201e3a:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0201e3c:	8b85                	andi	a5,a5,1
ffffffffc0201e3e:	cfb9                	beqz	a5,ffffffffc0201e9c <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0201e40:	65a2                	ld	a1,8(sp)
ffffffffc0201e42:	61bc                	ld	a5,64(a1)
ffffffffc0201e44:	83b1                	srli	a5,a5,0xc
ffffffffc0201e46:	0785                	addi	a5,a5,1
ffffffffc0201e48:	00879513          	slli	a0,a5,0x8
ffffffffc0201e4c:	026020ef          	jal	ra,ffffffffc0203e72 <swapfs_write>
ffffffffc0201e50:	d949                	beqz	a0,ffffffffc0201de2 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201e52:	855e                	mv	a0,s7
ffffffffc0201e54:	a66fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201e58:	0009b783          	ld	a5,0(s3)
ffffffffc0201e5c:	6622                	ld	a2,8(sp)
ffffffffc0201e5e:	4681                	li	a3,0
ffffffffc0201e60:	739c                	ld	a5,32(a5)
ffffffffc0201e62:	85a6                	mv	a1,s1
ffffffffc0201e64:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0201e66:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201e68:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0201e6a:	fa8a17e3          	bne	s4,s0,ffffffffc0201e18 <swap_out+0x70>
}
ffffffffc0201e6e:	60e6                	ld	ra,88(sp)
ffffffffc0201e70:	8522                	mv	a0,s0
ffffffffc0201e72:	6446                	ld	s0,80(sp)
ffffffffc0201e74:	64a6                	ld	s1,72(sp)
ffffffffc0201e76:	6906                	ld	s2,64(sp)
ffffffffc0201e78:	79e2                	ld	s3,56(sp)
ffffffffc0201e7a:	7a42                	ld	s4,48(sp)
ffffffffc0201e7c:	7aa2                	ld	s5,40(sp)
ffffffffc0201e7e:	7b02                	ld	s6,32(sp)
ffffffffc0201e80:	6be2                	ld	s7,24(sp)
ffffffffc0201e82:	6c42                	ld	s8,16(sp)
ffffffffc0201e84:	6125                	addi	sp,sp,96
ffffffffc0201e86:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0201e88:	85a2                	mv	a1,s0
ffffffffc0201e8a:	00003517          	auipc	a0,0x3
ffffffffc0201e8e:	75650513          	addi	a0,a0,1878 # ffffffffc02055e0 <commands+0xf10>
ffffffffc0201e92:	a28fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                  break;
ffffffffc0201e96:	bfe1                	j	ffffffffc0201e6e <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0201e98:	4401                	li	s0,0
ffffffffc0201e9a:	bfd1                	j	ffffffffc0201e6e <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201e9c:	00003697          	auipc	a3,0x3
ffffffffc0201ea0:	77468693          	addi	a3,a3,1908 # ffffffffc0205610 <commands+0xf40>
ffffffffc0201ea4:	00003617          	auipc	a2,0x3
ffffffffc0201ea8:	f9c60613          	addi	a2,a2,-100 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201eac:	06800593          	li	a1,104
ffffffffc0201eb0:	00003517          	auipc	a0,0x3
ffffffffc0201eb4:	48050513          	addi	a0,a0,1152 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201eb8:	a4afe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201ebc <swap_in>:
{
ffffffffc0201ebc:	7179                	addi	sp,sp,-48
ffffffffc0201ebe:	e84a                	sd	s2,16(sp)
ffffffffc0201ec0:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0201ec2:	4505                	li	a0,1
{
ffffffffc0201ec4:	ec26                	sd	s1,24(sp)
ffffffffc0201ec6:	e44e                	sd	s3,8(sp)
ffffffffc0201ec8:	f406                	sd	ra,40(sp)
ffffffffc0201eca:	f022                	sd	s0,32(sp)
ffffffffc0201ecc:	84ae                	mv	s1,a1
ffffffffc0201ece:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0201ed0:	377000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
     assert(result!=NULL);
ffffffffc0201ed4:	c129                	beqz	a0,ffffffffc0201f16 <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0201ed6:	842a                	mv	s0,a0
ffffffffc0201ed8:	01893503          	ld	a0,24(s2)
ffffffffc0201edc:	4601                	li	a2,0
ffffffffc0201ede:	85a6                	mv	a1,s1
ffffffffc0201ee0:	473000ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc0201ee4:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0201ee6:	6108                	ld	a0,0(a0)
ffffffffc0201ee8:	85a2                	mv	a1,s0
ffffffffc0201eea:	6ef010ef          	jal	ra,ffffffffc0203dd8 <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0201eee:	00093583          	ld	a1,0(s2)
ffffffffc0201ef2:	8626                	mv	a2,s1
ffffffffc0201ef4:	00003517          	auipc	a0,0x3
ffffffffc0201ef8:	79c50513          	addi	a0,a0,1948 # ffffffffc0205690 <commands+0xfc0>
ffffffffc0201efc:	81a1                	srli	a1,a1,0x8
ffffffffc0201efe:	9bcfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201f02:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0201f04:	0089b023          	sd	s0,0(s3)
}
ffffffffc0201f08:	7402                	ld	s0,32(sp)
ffffffffc0201f0a:	64e2                	ld	s1,24(sp)
ffffffffc0201f0c:	6942                	ld	s2,16(sp)
ffffffffc0201f0e:	69a2                	ld	s3,8(sp)
ffffffffc0201f10:	4501                	li	a0,0
ffffffffc0201f12:	6145                	addi	sp,sp,48
ffffffffc0201f14:	8082                	ret
     assert(result!=NULL);
ffffffffc0201f16:	00003697          	auipc	a3,0x3
ffffffffc0201f1a:	76a68693          	addi	a3,a3,1898 # ffffffffc0205680 <commands+0xfb0>
ffffffffc0201f1e:	00003617          	auipc	a2,0x3
ffffffffc0201f22:	f2260613          	addi	a2,a2,-222 # ffffffffc0204e40 <commands+0x770>
ffffffffc0201f26:	07e00593          	li	a1,126
ffffffffc0201f2a:	00003517          	auipc	a0,0x3
ffffffffc0201f2e:	40650513          	addi	a0,a0,1030 # ffffffffc0205330 <commands+0xc60>
ffffffffc0201f32:	9d0fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201f36 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201f36:	0000f797          	auipc	a5,0xf
ffffffffc0201f3a:	1aa78793          	addi	a5,a5,426 # ffffffffc02110e0 <free_area>
ffffffffc0201f3e:	e79c                	sd	a5,8(a5)
ffffffffc0201f40:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201f42:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201f46:	8082                	ret

ffffffffc0201f48 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201f48:	0000f517          	auipc	a0,0xf
ffffffffc0201f4c:	1a856503          	lwu	a0,424(a0) # ffffffffc02110f0 <free_area+0x10>
ffffffffc0201f50:	8082                	ret

ffffffffc0201f52 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201f52:	715d                	addi	sp,sp,-80
ffffffffc0201f54:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201f56:	0000f417          	auipc	s0,0xf
ffffffffc0201f5a:	18a40413          	addi	s0,s0,394 # ffffffffc02110e0 <free_area>
ffffffffc0201f5e:	641c                	ld	a5,8(s0)
ffffffffc0201f60:	e486                	sd	ra,72(sp)
ffffffffc0201f62:	fc26                	sd	s1,56(sp)
ffffffffc0201f64:	f84a                	sd	s2,48(sp)
ffffffffc0201f66:	f44e                	sd	s3,40(sp)
ffffffffc0201f68:	f052                	sd	s4,32(sp)
ffffffffc0201f6a:	ec56                	sd	s5,24(sp)
ffffffffc0201f6c:	e85a                	sd	s6,16(sp)
ffffffffc0201f6e:	e45e                	sd	s7,8(sp)
ffffffffc0201f70:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201f72:	2c878763          	beq	a5,s0,ffffffffc0202240 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0201f76:	4481                	li	s1,0
ffffffffc0201f78:	4901                	li	s2,0
ffffffffc0201f7a:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201f7e:	8b09                	andi	a4,a4,2
ffffffffc0201f80:	2c070463          	beqz	a4,ffffffffc0202248 <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0201f84:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201f88:	679c                	ld	a5,8(a5)
ffffffffc0201f8a:	2905                	addiw	s2,s2,1
ffffffffc0201f8c:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201f8e:	fe8796e3          	bne	a5,s0,ffffffffc0201f7a <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201f92:	89a6                	mv	s3,s1
ffffffffc0201f94:	385000ef          	jal	ra,ffffffffc0202b18 <nr_free_pages>
ffffffffc0201f98:	71351863          	bne	a0,s3,ffffffffc02026a8 <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f9c:	4505                	li	a0,1
ffffffffc0201f9e:	2a9000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0201fa2:	8a2a                	mv	s4,a0
ffffffffc0201fa4:	44050263          	beqz	a0,ffffffffc02023e8 <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201fa8:	4505                	li	a0,1
ffffffffc0201faa:	29d000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0201fae:	89aa                	mv	s3,a0
ffffffffc0201fb0:	70050c63          	beqz	a0,ffffffffc02026c8 <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201fb4:	4505                	li	a0,1
ffffffffc0201fb6:	291000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0201fba:	8aaa                	mv	s5,a0
ffffffffc0201fbc:	4a050663          	beqz	a0,ffffffffc0202468 <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201fc0:	2b3a0463          	beq	s4,s3,ffffffffc0202268 <default_check+0x316>
ffffffffc0201fc4:	2aaa0263          	beq	s4,a0,ffffffffc0202268 <default_check+0x316>
ffffffffc0201fc8:	2aa98063          	beq	s3,a0,ffffffffc0202268 <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201fcc:	000a2783          	lw	a5,0(s4)
ffffffffc0201fd0:	2a079c63          	bnez	a5,ffffffffc0202288 <default_check+0x336>
ffffffffc0201fd4:	0009a783          	lw	a5,0(s3)
ffffffffc0201fd8:	2a079863          	bnez	a5,ffffffffc0202288 <default_check+0x336>
ffffffffc0201fdc:	411c                	lw	a5,0(a0)
ffffffffc0201fde:	2a079563          	bnez	a5,ffffffffc0202288 <default_check+0x336>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201fe2:	0000f797          	auipc	a5,0xf
ffffffffc0201fe6:	57e7b783          	ld	a5,1406(a5) # ffffffffc0211560 <pages>
ffffffffc0201fea:	40fa0733          	sub	a4,s4,a5
ffffffffc0201fee:	870d                	srai	a4,a4,0x3
ffffffffc0201ff0:	00004597          	auipc	a1,0x4
ffffffffc0201ff4:	3185b583          	ld	a1,792(a1) # ffffffffc0206308 <error_string+0x38>
ffffffffc0201ff8:	02b70733          	mul	a4,a4,a1
ffffffffc0201ffc:	00004617          	auipc	a2,0x4
ffffffffc0202000:	31463603          	ld	a2,788(a2) # ffffffffc0206310 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0202004:	0000f697          	auipc	a3,0xf
ffffffffc0202008:	5546b683          	ld	a3,1364(a3) # ffffffffc0211558 <npage>
ffffffffc020200c:	06b2                	slli	a3,a3,0xc
ffffffffc020200e:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202010:	0732                	slli	a4,a4,0xc
ffffffffc0202012:	28d77b63          	bgeu	a4,a3,ffffffffc02022a8 <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202016:	40f98733          	sub	a4,s3,a5
ffffffffc020201a:	870d                	srai	a4,a4,0x3
ffffffffc020201c:	02b70733          	mul	a4,a4,a1
ffffffffc0202020:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202022:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0202024:	4cd77263          	bgeu	a4,a3,ffffffffc02024e8 <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202028:	40f507b3          	sub	a5,a0,a5
ffffffffc020202c:	878d                	srai	a5,a5,0x3
ffffffffc020202e:	02b787b3          	mul	a5,a5,a1
ffffffffc0202032:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202034:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0202036:	30d7f963          	bgeu	a5,a3,ffffffffc0202348 <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc020203a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020203c:	00043c03          	ld	s8,0(s0)
ffffffffc0202040:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0202044:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0202048:	e400                	sd	s0,8(s0)
ffffffffc020204a:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc020204c:	0000f797          	auipc	a5,0xf
ffffffffc0202050:	0a07a223          	sw	zero,164(a5) # ffffffffc02110f0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0202054:	1f3000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202058:	2c051863          	bnez	a0,ffffffffc0202328 <default_check+0x3d6>
    free_page(p0);
ffffffffc020205c:	4585                	li	a1,1
ffffffffc020205e:	8552                	mv	a0,s4
ffffffffc0202060:	279000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_page(p1);
ffffffffc0202064:	4585                	li	a1,1
ffffffffc0202066:	854e                	mv	a0,s3
ffffffffc0202068:	271000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_page(p2);
ffffffffc020206c:	4585                	li	a1,1
ffffffffc020206e:	8556                	mv	a0,s5
ffffffffc0202070:	269000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    assert(nr_free == 3);
ffffffffc0202074:	4818                	lw	a4,16(s0)
ffffffffc0202076:	478d                	li	a5,3
ffffffffc0202078:	28f71863          	bne	a4,a5,ffffffffc0202308 <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020207c:	4505                	li	a0,1
ffffffffc020207e:	1c9000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202082:	89aa                	mv	s3,a0
ffffffffc0202084:	26050263          	beqz	a0,ffffffffc02022e8 <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202088:	4505                	li	a0,1
ffffffffc020208a:	1bd000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020208e:	8aaa                	mv	s5,a0
ffffffffc0202090:	3a050c63          	beqz	a0,ffffffffc0202448 <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202094:	4505                	li	a0,1
ffffffffc0202096:	1b1000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020209a:	8a2a                	mv	s4,a0
ffffffffc020209c:	38050663          	beqz	a0,ffffffffc0202428 <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc02020a0:	4505                	li	a0,1
ffffffffc02020a2:	1a5000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02020a6:	36051163          	bnez	a0,ffffffffc0202408 <default_check+0x4b6>
    free_page(p0);
ffffffffc02020aa:	4585                	li	a1,1
ffffffffc02020ac:	854e                	mv	a0,s3
ffffffffc02020ae:	22b000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02020b2:	641c                	ld	a5,8(s0)
ffffffffc02020b4:	20878a63          	beq	a5,s0,ffffffffc02022c8 <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc02020b8:	4505                	li	a0,1
ffffffffc02020ba:	18d000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02020be:	30a99563          	bne	s3,a0,ffffffffc02023c8 <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc02020c2:	4505                	li	a0,1
ffffffffc02020c4:	183000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02020c8:	2e051063          	bnez	a0,ffffffffc02023a8 <default_check+0x456>
    assert(nr_free == 0);
ffffffffc02020cc:	481c                	lw	a5,16(s0)
ffffffffc02020ce:	2a079d63          	bnez	a5,ffffffffc0202388 <default_check+0x436>
    free_page(p);
ffffffffc02020d2:	854e                	mv	a0,s3
ffffffffc02020d4:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02020d6:	01843023          	sd	s8,0(s0)
ffffffffc02020da:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02020de:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02020e2:	1f7000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_page(p1);
ffffffffc02020e6:	4585                	li	a1,1
ffffffffc02020e8:	8556                	mv	a0,s5
ffffffffc02020ea:	1ef000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_page(p2);
ffffffffc02020ee:	4585                	li	a1,1
ffffffffc02020f0:	8552                	mv	a0,s4
ffffffffc02020f2:	1e7000ef          	jal	ra,ffffffffc0202ad8 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02020f6:	4515                	li	a0,5
ffffffffc02020f8:	14f000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02020fc:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02020fe:	26050563          	beqz	a0,ffffffffc0202368 <default_check+0x416>
ffffffffc0202102:	651c                	ld	a5,8(a0)
ffffffffc0202104:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0202106:	8b85                	andi	a5,a5,1
ffffffffc0202108:	54079063          	bnez	a5,ffffffffc0202648 <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020210c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020210e:	00043b03          	ld	s6,0(s0)
ffffffffc0202112:	00843a83          	ld	s5,8(s0)
ffffffffc0202116:	e000                	sd	s0,0(s0)
ffffffffc0202118:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020211a:	12d000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020211e:	50051563          	bnez	a0,ffffffffc0202628 <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0202122:	09098a13          	addi	s4,s3,144
ffffffffc0202126:	8552                	mv	a0,s4
ffffffffc0202128:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020212a:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020212e:	0000f797          	auipc	a5,0xf
ffffffffc0202132:	fc07a123          	sw	zero,-62(a5) # ffffffffc02110f0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0202136:	1a3000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020213a:	4511                	li	a0,4
ffffffffc020213c:	10b000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202140:	4c051463          	bnez	a0,ffffffffc0202608 <default_check+0x6b6>
ffffffffc0202144:	0989b783          	ld	a5,152(s3)
ffffffffc0202148:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020214a:	8b85                	andi	a5,a5,1
ffffffffc020214c:	48078e63          	beqz	a5,ffffffffc02025e8 <default_check+0x696>
ffffffffc0202150:	0a89a703          	lw	a4,168(s3)
ffffffffc0202154:	478d                	li	a5,3
ffffffffc0202156:	48f71963          	bne	a4,a5,ffffffffc02025e8 <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020215a:	450d                	li	a0,3
ffffffffc020215c:	0eb000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202160:	8c2a                	mv	s8,a0
ffffffffc0202162:	46050363          	beqz	a0,ffffffffc02025c8 <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0202166:	4505                	li	a0,1
ffffffffc0202168:	0df000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020216c:	42051e63          	bnez	a0,ffffffffc02025a8 <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0202170:	418a1c63          	bne	s4,s8,ffffffffc0202588 <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0202174:	4585                	li	a1,1
ffffffffc0202176:	854e                	mv	a0,s3
ffffffffc0202178:	161000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_pages(p1, 3);
ffffffffc020217c:	458d                	li	a1,3
ffffffffc020217e:	8552                	mv	a0,s4
ffffffffc0202180:	159000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
ffffffffc0202184:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0202188:	04898c13          	addi	s8,s3,72
ffffffffc020218c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020218e:	8b85                	andi	a5,a5,1
ffffffffc0202190:	3c078c63          	beqz	a5,ffffffffc0202568 <default_check+0x616>
ffffffffc0202194:	0189a703          	lw	a4,24(s3)
ffffffffc0202198:	4785                	li	a5,1
ffffffffc020219a:	3cf71763          	bne	a4,a5,ffffffffc0202568 <default_check+0x616>
ffffffffc020219e:	008a3783          	ld	a5,8(s4)
ffffffffc02021a2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02021a4:	8b85                	andi	a5,a5,1
ffffffffc02021a6:	3a078163          	beqz	a5,ffffffffc0202548 <default_check+0x5f6>
ffffffffc02021aa:	018a2703          	lw	a4,24(s4)
ffffffffc02021ae:	478d                	li	a5,3
ffffffffc02021b0:	38f71c63          	bne	a4,a5,ffffffffc0202548 <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02021b4:	4505                	li	a0,1
ffffffffc02021b6:	091000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02021ba:	36a99763          	bne	s3,a0,ffffffffc0202528 <default_check+0x5d6>
    free_page(p0);
ffffffffc02021be:	4585                	li	a1,1
ffffffffc02021c0:	119000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02021c4:	4509                	li	a0,2
ffffffffc02021c6:	081000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02021ca:	32aa1f63          	bne	s4,a0,ffffffffc0202508 <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc02021ce:	4589                	li	a1,2
ffffffffc02021d0:	109000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    free_page(p2);
ffffffffc02021d4:	4585                	li	a1,1
ffffffffc02021d6:	8562                	mv	a0,s8
ffffffffc02021d8:	101000ef          	jal	ra,ffffffffc0202ad8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02021dc:	4515                	li	a0,5
ffffffffc02021de:	069000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02021e2:	89aa                	mv	s3,a0
ffffffffc02021e4:	48050263          	beqz	a0,ffffffffc0202668 <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc02021e8:	4505                	li	a0,1
ffffffffc02021ea:	05d000ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02021ee:	2c051d63          	bnez	a0,ffffffffc02024c8 <default_check+0x576>

    assert(nr_free == 0);
ffffffffc02021f2:	481c                	lw	a5,16(s0)
ffffffffc02021f4:	2a079a63          	bnez	a5,ffffffffc02024a8 <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02021f8:	4595                	li	a1,5
ffffffffc02021fa:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02021fc:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0202200:	01643023          	sd	s6,0(s0)
ffffffffc0202204:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0202208:	0d1000ef          	jal	ra,ffffffffc0202ad8 <free_pages>
    return listelm->next;
ffffffffc020220c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020220e:	00878963          	beq	a5,s0,ffffffffc0202220 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0202212:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202216:	679c                	ld	a5,8(a5)
ffffffffc0202218:	397d                	addiw	s2,s2,-1
ffffffffc020221a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020221c:	fe879be3          	bne	a5,s0,ffffffffc0202212 <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0202220:	26091463          	bnez	s2,ffffffffc0202488 <default_check+0x536>
    assert(total == 0);
ffffffffc0202224:	46049263          	bnez	s1,ffffffffc0202688 <default_check+0x736>
}
ffffffffc0202228:	60a6                	ld	ra,72(sp)
ffffffffc020222a:	6406                	ld	s0,64(sp)
ffffffffc020222c:	74e2                	ld	s1,56(sp)
ffffffffc020222e:	7942                	ld	s2,48(sp)
ffffffffc0202230:	79a2                	ld	s3,40(sp)
ffffffffc0202232:	7a02                	ld	s4,32(sp)
ffffffffc0202234:	6ae2                	ld	s5,24(sp)
ffffffffc0202236:	6b42                	ld	s6,16(sp)
ffffffffc0202238:	6ba2                	ld	s7,8(sp)
ffffffffc020223a:	6c02                	ld	s8,0(sp)
ffffffffc020223c:	6161                	addi	sp,sp,80
ffffffffc020223e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202240:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0202242:	4481                	li	s1,0
ffffffffc0202244:	4901                	li	s2,0
ffffffffc0202246:	b3b9                	j	ffffffffc0201f94 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0202248:	00003697          	auipc	a3,0x3
ffffffffc020224c:	11068693          	addi	a3,a3,272 # ffffffffc0205358 <commands+0xc88>
ffffffffc0202250:	00003617          	auipc	a2,0x3
ffffffffc0202254:	bf060613          	addi	a2,a2,-1040 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202258:	0f000593          	li	a1,240
ffffffffc020225c:	00003517          	auipc	a0,0x3
ffffffffc0202260:	47450513          	addi	a0,a0,1140 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202264:	e9ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0202268:	00003697          	auipc	a3,0x3
ffffffffc020226c:	4e068693          	addi	a3,a3,1248 # ffffffffc0205748 <commands+0x1078>
ffffffffc0202270:	00003617          	auipc	a2,0x3
ffffffffc0202274:	bd060613          	addi	a2,a2,-1072 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202278:	0bd00593          	li	a1,189
ffffffffc020227c:	00003517          	auipc	a0,0x3
ffffffffc0202280:	45450513          	addi	a0,a0,1108 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202284:	e7ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0202288:	00003697          	auipc	a3,0x3
ffffffffc020228c:	4e868693          	addi	a3,a3,1256 # ffffffffc0205770 <commands+0x10a0>
ffffffffc0202290:	00003617          	auipc	a2,0x3
ffffffffc0202294:	bb060613          	addi	a2,a2,-1104 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202298:	0be00593          	li	a1,190
ffffffffc020229c:	00003517          	auipc	a0,0x3
ffffffffc02022a0:	43450513          	addi	a0,a0,1076 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02022a4:	e5ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02022a8:	00003697          	auipc	a3,0x3
ffffffffc02022ac:	50868693          	addi	a3,a3,1288 # ffffffffc02057b0 <commands+0x10e0>
ffffffffc02022b0:	00003617          	auipc	a2,0x3
ffffffffc02022b4:	b9060613          	addi	a2,a2,-1136 # ffffffffc0204e40 <commands+0x770>
ffffffffc02022b8:	0c000593          	li	a1,192
ffffffffc02022bc:	00003517          	auipc	a0,0x3
ffffffffc02022c0:	41450513          	addi	a0,a0,1044 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02022c4:	e3ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02022c8:	00003697          	auipc	a3,0x3
ffffffffc02022cc:	57068693          	addi	a3,a3,1392 # ffffffffc0205838 <commands+0x1168>
ffffffffc02022d0:	00003617          	auipc	a2,0x3
ffffffffc02022d4:	b7060613          	addi	a2,a2,-1168 # ffffffffc0204e40 <commands+0x770>
ffffffffc02022d8:	0d900593          	li	a1,217
ffffffffc02022dc:	00003517          	auipc	a0,0x3
ffffffffc02022e0:	3f450513          	addi	a0,a0,1012 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02022e4:	e1ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02022e8:	00003697          	auipc	a3,0x3
ffffffffc02022ec:	40068693          	addi	a3,a3,1024 # ffffffffc02056e8 <commands+0x1018>
ffffffffc02022f0:	00003617          	auipc	a2,0x3
ffffffffc02022f4:	b5060613          	addi	a2,a2,-1200 # ffffffffc0204e40 <commands+0x770>
ffffffffc02022f8:	0d200593          	li	a1,210
ffffffffc02022fc:	00003517          	auipc	a0,0x3
ffffffffc0202300:	3d450513          	addi	a0,a0,980 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202304:	dfffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 3);
ffffffffc0202308:	00003697          	auipc	a3,0x3
ffffffffc020230c:	52068693          	addi	a3,a3,1312 # ffffffffc0205828 <commands+0x1158>
ffffffffc0202310:	00003617          	auipc	a2,0x3
ffffffffc0202314:	b3060613          	addi	a2,a2,-1232 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202318:	0d000593          	li	a1,208
ffffffffc020231c:	00003517          	auipc	a0,0x3
ffffffffc0202320:	3b450513          	addi	a0,a0,948 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202324:	ddffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202328:	00003697          	auipc	a3,0x3
ffffffffc020232c:	4e868693          	addi	a3,a3,1256 # ffffffffc0205810 <commands+0x1140>
ffffffffc0202330:	00003617          	auipc	a2,0x3
ffffffffc0202334:	b1060613          	addi	a2,a2,-1264 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202338:	0cb00593          	li	a1,203
ffffffffc020233c:	00003517          	auipc	a0,0x3
ffffffffc0202340:	39450513          	addi	a0,a0,916 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202344:	dbffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0202348:	00003697          	auipc	a3,0x3
ffffffffc020234c:	4a868693          	addi	a3,a3,1192 # ffffffffc02057f0 <commands+0x1120>
ffffffffc0202350:	00003617          	auipc	a2,0x3
ffffffffc0202354:	af060613          	addi	a2,a2,-1296 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202358:	0c200593          	li	a1,194
ffffffffc020235c:	00003517          	auipc	a0,0x3
ffffffffc0202360:	37450513          	addi	a0,a0,884 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202364:	d9ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != NULL);
ffffffffc0202368:	00003697          	auipc	a3,0x3
ffffffffc020236c:	50868693          	addi	a3,a3,1288 # ffffffffc0205870 <commands+0x11a0>
ffffffffc0202370:	00003617          	auipc	a2,0x3
ffffffffc0202374:	ad060613          	addi	a2,a2,-1328 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202378:	0f800593          	li	a1,248
ffffffffc020237c:	00003517          	auipc	a0,0x3
ffffffffc0202380:	35450513          	addi	a0,a0,852 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202384:	d7ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc0202388:	00003697          	auipc	a3,0x3
ffffffffc020238c:	17068693          	addi	a3,a3,368 # ffffffffc02054f8 <commands+0xe28>
ffffffffc0202390:	00003617          	auipc	a2,0x3
ffffffffc0202394:	ab060613          	addi	a2,a2,-1360 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202398:	0df00593          	li	a1,223
ffffffffc020239c:	00003517          	auipc	a0,0x3
ffffffffc02023a0:	33450513          	addi	a0,a0,820 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02023a4:	d5ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02023a8:	00003697          	auipc	a3,0x3
ffffffffc02023ac:	46868693          	addi	a3,a3,1128 # ffffffffc0205810 <commands+0x1140>
ffffffffc02023b0:	00003617          	auipc	a2,0x3
ffffffffc02023b4:	a9060613          	addi	a2,a2,-1392 # ffffffffc0204e40 <commands+0x770>
ffffffffc02023b8:	0dd00593          	li	a1,221
ffffffffc02023bc:	00003517          	auipc	a0,0x3
ffffffffc02023c0:	31450513          	addi	a0,a0,788 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02023c4:	d3ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02023c8:	00003697          	auipc	a3,0x3
ffffffffc02023cc:	48868693          	addi	a3,a3,1160 # ffffffffc0205850 <commands+0x1180>
ffffffffc02023d0:	00003617          	auipc	a2,0x3
ffffffffc02023d4:	a7060613          	addi	a2,a2,-1424 # ffffffffc0204e40 <commands+0x770>
ffffffffc02023d8:	0dc00593          	li	a1,220
ffffffffc02023dc:	00003517          	auipc	a0,0x3
ffffffffc02023e0:	2f450513          	addi	a0,a0,756 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02023e4:	d1ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02023e8:	00003697          	auipc	a3,0x3
ffffffffc02023ec:	30068693          	addi	a3,a3,768 # ffffffffc02056e8 <commands+0x1018>
ffffffffc02023f0:	00003617          	auipc	a2,0x3
ffffffffc02023f4:	a5060613          	addi	a2,a2,-1456 # ffffffffc0204e40 <commands+0x770>
ffffffffc02023f8:	0b900593          	li	a1,185
ffffffffc02023fc:	00003517          	auipc	a0,0x3
ffffffffc0202400:	2d450513          	addi	a0,a0,724 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202404:	cfffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202408:	00003697          	auipc	a3,0x3
ffffffffc020240c:	40868693          	addi	a3,a3,1032 # ffffffffc0205810 <commands+0x1140>
ffffffffc0202410:	00003617          	auipc	a2,0x3
ffffffffc0202414:	a3060613          	addi	a2,a2,-1488 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202418:	0d600593          	li	a1,214
ffffffffc020241c:	00003517          	auipc	a0,0x3
ffffffffc0202420:	2b450513          	addi	a0,a0,692 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202424:	cdffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202428:	00003697          	auipc	a3,0x3
ffffffffc020242c:	30068693          	addi	a3,a3,768 # ffffffffc0205728 <commands+0x1058>
ffffffffc0202430:	00003617          	auipc	a2,0x3
ffffffffc0202434:	a1060613          	addi	a2,a2,-1520 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202438:	0d400593          	li	a1,212
ffffffffc020243c:	00003517          	auipc	a0,0x3
ffffffffc0202440:	29450513          	addi	a0,a0,660 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202444:	cbffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202448:	00003697          	auipc	a3,0x3
ffffffffc020244c:	2c068693          	addi	a3,a3,704 # ffffffffc0205708 <commands+0x1038>
ffffffffc0202450:	00003617          	auipc	a2,0x3
ffffffffc0202454:	9f060613          	addi	a2,a2,-1552 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202458:	0d300593          	li	a1,211
ffffffffc020245c:	00003517          	auipc	a0,0x3
ffffffffc0202460:	27450513          	addi	a0,a0,628 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202464:	c9ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202468:	00003697          	auipc	a3,0x3
ffffffffc020246c:	2c068693          	addi	a3,a3,704 # ffffffffc0205728 <commands+0x1058>
ffffffffc0202470:	00003617          	auipc	a2,0x3
ffffffffc0202474:	9d060613          	addi	a2,a2,-1584 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202478:	0bb00593          	li	a1,187
ffffffffc020247c:	00003517          	auipc	a0,0x3
ffffffffc0202480:	25450513          	addi	a0,a0,596 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202484:	c7ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(count == 0);
ffffffffc0202488:	00003697          	auipc	a3,0x3
ffffffffc020248c:	53868693          	addi	a3,a3,1336 # ffffffffc02059c0 <commands+0x12f0>
ffffffffc0202490:	00003617          	auipc	a2,0x3
ffffffffc0202494:	9b060613          	addi	a2,a2,-1616 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202498:	12500593          	li	a1,293
ffffffffc020249c:	00003517          	auipc	a0,0x3
ffffffffc02024a0:	23450513          	addi	a0,a0,564 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02024a4:	c5ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc02024a8:	00003697          	auipc	a3,0x3
ffffffffc02024ac:	05068693          	addi	a3,a3,80 # ffffffffc02054f8 <commands+0xe28>
ffffffffc02024b0:	00003617          	auipc	a2,0x3
ffffffffc02024b4:	99060613          	addi	a2,a2,-1648 # ffffffffc0204e40 <commands+0x770>
ffffffffc02024b8:	11a00593          	li	a1,282
ffffffffc02024bc:	00003517          	auipc	a0,0x3
ffffffffc02024c0:	21450513          	addi	a0,a0,532 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02024c4:	c3ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02024c8:	00003697          	auipc	a3,0x3
ffffffffc02024cc:	34868693          	addi	a3,a3,840 # ffffffffc0205810 <commands+0x1140>
ffffffffc02024d0:	00003617          	auipc	a2,0x3
ffffffffc02024d4:	97060613          	addi	a2,a2,-1680 # ffffffffc0204e40 <commands+0x770>
ffffffffc02024d8:	11800593          	li	a1,280
ffffffffc02024dc:	00003517          	auipc	a0,0x3
ffffffffc02024e0:	1f450513          	addi	a0,a0,500 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02024e4:	c1ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02024e8:	00003697          	auipc	a3,0x3
ffffffffc02024ec:	2e868693          	addi	a3,a3,744 # ffffffffc02057d0 <commands+0x1100>
ffffffffc02024f0:	00003617          	auipc	a2,0x3
ffffffffc02024f4:	95060613          	addi	a2,a2,-1712 # ffffffffc0204e40 <commands+0x770>
ffffffffc02024f8:	0c100593          	li	a1,193
ffffffffc02024fc:	00003517          	auipc	a0,0x3
ffffffffc0202500:	1d450513          	addi	a0,a0,468 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202504:	bfffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0202508:	00003697          	auipc	a3,0x3
ffffffffc020250c:	47868693          	addi	a3,a3,1144 # ffffffffc0205980 <commands+0x12b0>
ffffffffc0202510:	00003617          	auipc	a2,0x3
ffffffffc0202514:	93060613          	addi	a2,a2,-1744 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202518:	11200593          	li	a1,274
ffffffffc020251c:	00003517          	auipc	a0,0x3
ffffffffc0202520:	1b450513          	addi	a0,a0,436 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202524:	bdffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0202528:	00003697          	auipc	a3,0x3
ffffffffc020252c:	43868693          	addi	a3,a3,1080 # ffffffffc0205960 <commands+0x1290>
ffffffffc0202530:	00003617          	auipc	a2,0x3
ffffffffc0202534:	91060613          	addi	a2,a2,-1776 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202538:	11000593          	li	a1,272
ffffffffc020253c:	00003517          	auipc	a0,0x3
ffffffffc0202540:	19450513          	addi	a0,a0,404 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202544:	bbffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0202548:	00003697          	auipc	a3,0x3
ffffffffc020254c:	3f068693          	addi	a3,a3,1008 # ffffffffc0205938 <commands+0x1268>
ffffffffc0202550:	00003617          	auipc	a2,0x3
ffffffffc0202554:	8f060613          	addi	a2,a2,-1808 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202558:	10e00593          	li	a1,270
ffffffffc020255c:	00003517          	auipc	a0,0x3
ffffffffc0202560:	17450513          	addi	a0,a0,372 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202564:	b9ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0202568:	00003697          	auipc	a3,0x3
ffffffffc020256c:	3a868693          	addi	a3,a3,936 # ffffffffc0205910 <commands+0x1240>
ffffffffc0202570:	00003617          	auipc	a2,0x3
ffffffffc0202574:	8d060613          	addi	a2,a2,-1840 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202578:	10d00593          	li	a1,269
ffffffffc020257c:	00003517          	auipc	a0,0x3
ffffffffc0202580:	15450513          	addi	a0,a0,340 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202584:	b7ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0202588:	00003697          	auipc	a3,0x3
ffffffffc020258c:	37868693          	addi	a3,a3,888 # ffffffffc0205900 <commands+0x1230>
ffffffffc0202590:	00003617          	auipc	a2,0x3
ffffffffc0202594:	8b060613          	addi	a2,a2,-1872 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202598:	10800593          	li	a1,264
ffffffffc020259c:	00003517          	auipc	a0,0x3
ffffffffc02025a0:	13450513          	addi	a0,a0,308 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02025a4:	b5ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02025a8:	00003697          	auipc	a3,0x3
ffffffffc02025ac:	26868693          	addi	a3,a3,616 # ffffffffc0205810 <commands+0x1140>
ffffffffc02025b0:	00003617          	auipc	a2,0x3
ffffffffc02025b4:	89060613          	addi	a2,a2,-1904 # ffffffffc0204e40 <commands+0x770>
ffffffffc02025b8:	10700593          	li	a1,263
ffffffffc02025bc:	00003517          	auipc	a0,0x3
ffffffffc02025c0:	11450513          	addi	a0,a0,276 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02025c4:	b3ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02025c8:	00003697          	auipc	a3,0x3
ffffffffc02025cc:	31868693          	addi	a3,a3,792 # ffffffffc02058e0 <commands+0x1210>
ffffffffc02025d0:	00003617          	auipc	a2,0x3
ffffffffc02025d4:	87060613          	addi	a2,a2,-1936 # ffffffffc0204e40 <commands+0x770>
ffffffffc02025d8:	10600593          	li	a1,262
ffffffffc02025dc:	00003517          	auipc	a0,0x3
ffffffffc02025e0:	0f450513          	addi	a0,a0,244 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02025e4:	b1ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02025e8:	00003697          	auipc	a3,0x3
ffffffffc02025ec:	2c868693          	addi	a3,a3,712 # ffffffffc02058b0 <commands+0x11e0>
ffffffffc02025f0:	00003617          	auipc	a2,0x3
ffffffffc02025f4:	85060613          	addi	a2,a2,-1968 # ffffffffc0204e40 <commands+0x770>
ffffffffc02025f8:	10500593          	li	a1,261
ffffffffc02025fc:	00003517          	auipc	a0,0x3
ffffffffc0202600:	0d450513          	addi	a0,a0,212 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202604:	afffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0202608:	00003697          	auipc	a3,0x3
ffffffffc020260c:	29068693          	addi	a3,a3,656 # ffffffffc0205898 <commands+0x11c8>
ffffffffc0202610:	00003617          	auipc	a2,0x3
ffffffffc0202614:	83060613          	addi	a2,a2,-2000 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202618:	10400593          	li	a1,260
ffffffffc020261c:	00003517          	auipc	a0,0x3
ffffffffc0202620:	0b450513          	addi	a0,a0,180 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202624:	adffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202628:	00003697          	auipc	a3,0x3
ffffffffc020262c:	1e868693          	addi	a3,a3,488 # ffffffffc0205810 <commands+0x1140>
ffffffffc0202630:	00003617          	auipc	a2,0x3
ffffffffc0202634:	81060613          	addi	a2,a2,-2032 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202638:	0fe00593          	li	a1,254
ffffffffc020263c:	00003517          	auipc	a0,0x3
ffffffffc0202640:	09450513          	addi	a0,a0,148 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202644:	abffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!PageProperty(p0));
ffffffffc0202648:	00003697          	auipc	a3,0x3
ffffffffc020264c:	23868693          	addi	a3,a3,568 # ffffffffc0205880 <commands+0x11b0>
ffffffffc0202650:	00002617          	auipc	a2,0x2
ffffffffc0202654:	7f060613          	addi	a2,a2,2032 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202658:	0f900593          	li	a1,249
ffffffffc020265c:	00003517          	auipc	a0,0x3
ffffffffc0202660:	07450513          	addi	a0,a0,116 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202664:	a9ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0202668:	00003697          	auipc	a3,0x3
ffffffffc020266c:	33868693          	addi	a3,a3,824 # ffffffffc02059a0 <commands+0x12d0>
ffffffffc0202670:	00002617          	auipc	a2,0x2
ffffffffc0202674:	7d060613          	addi	a2,a2,2000 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202678:	11700593          	li	a1,279
ffffffffc020267c:	00003517          	auipc	a0,0x3
ffffffffc0202680:	05450513          	addi	a0,a0,84 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202684:	a7ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == 0);
ffffffffc0202688:	00003697          	auipc	a3,0x3
ffffffffc020268c:	34868693          	addi	a3,a3,840 # ffffffffc02059d0 <commands+0x1300>
ffffffffc0202690:	00002617          	auipc	a2,0x2
ffffffffc0202694:	7b060613          	addi	a2,a2,1968 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202698:	12600593          	li	a1,294
ffffffffc020269c:	00003517          	auipc	a0,0x3
ffffffffc02026a0:	03450513          	addi	a0,a0,52 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02026a4:	a5ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == nr_free_pages());
ffffffffc02026a8:	00003697          	auipc	a3,0x3
ffffffffc02026ac:	cc068693          	addi	a3,a3,-832 # ffffffffc0205368 <commands+0xc98>
ffffffffc02026b0:	00002617          	auipc	a2,0x2
ffffffffc02026b4:	79060613          	addi	a2,a2,1936 # ffffffffc0204e40 <commands+0x770>
ffffffffc02026b8:	0f300593          	li	a1,243
ffffffffc02026bc:	00003517          	auipc	a0,0x3
ffffffffc02026c0:	01450513          	addi	a0,a0,20 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02026c4:	a3ffd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02026c8:	00003697          	auipc	a3,0x3
ffffffffc02026cc:	04068693          	addi	a3,a3,64 # ffffffffc0205708 <commands+0x1038>
ffffffffc02026d0:	00002617          	auipc	a2,0x2
ffffffffc02026d4:	77060613          	addi	a2,a2,1904 # ffffffffc0204e40 <commands+0x770>
ffffffffc02026d8:	0ba00593          	li	a1,186
ffffffffc02026dc:	00003517          	auipc	a0,0x3
ffffffffc02026e0:	ff450513          	addi	a0,a0,-12 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02026e4:	a1ffd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02026e8 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02026e8:	1141                	addi	sp,sp,-16
ffffffffc02026ea:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02026ec:	14058a63          	beqz	a1,ffffffffc0202840 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc02026f0:	00359693          	slli	a3,a1,0x3
ffffffffc02026f4:	96ae                	add	a3,a3,a1
ffffffffc02026f6:	068e                	slli	a3,a3,0x3
ffffffffc02026f8:	96aa                	add	a3,a3,a0
ffffffffc02026fa:	87aa                	mv	a5,a0
ffffffffc02026fc:	02d50263          	beq	a0,a3,ffffffffc0202720 <default_free_pages+0x38>
ffffffffc0202700:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202702:	8b05                	andi	a4,a4,1
ffffffffc0202704:	10071e63          	bnez	a4,ffffffffc0202820 <default_free_pages+0x138>
ffffffffc0202708:	6798                	ld	a4,8(a5)
ffffffffc020270a:	8b09                	andi	a4,a4,2
ffffffffc020270c:	10071a63          	bnez	a4,ffffffffc0202820 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc0202710:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202714:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0202718:	04878793          	addi	a5,a5,72
ffffffffc020271c:	fed792e3          	bne	a5,a3,ffffffffc0202700 <default_free_pages+0x18>
    base->property = n;
ffffffffc0202720:	2581                	sext.w	a1,a1
ffffffffc0202722:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc0202724:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202728:	4789                	li	a5,2
ffffffffc020272a:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020272e:	0000f697          	auipc	a3,0xf
ffffffffc0202732:	9b268693          	addi	a3,a3,-1614 # ffffffffc02110e0 <free_area>
ffffffffc0202736:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0202738:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020273a:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc020273e:	9db9                	addw	a1,a1,a4
ffffffffc0202740:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0202742:	0ad78863          	beq	a5,a3,ffffffffc02027f2 <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc0202746:	fe078713          	addi	a4,a5,-32
ffffffffc020274a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020274e:	4581                	li	a1,0
            if (base < page) {
ffffffffc0202750:	00e56a63          	bltu	a0,a4,ffffffffc0202764 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc0202754:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0202756:	06d70263          	beq	a4,a3,ffffffffc02027ba <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc020275a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020275c:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc0202760:	fee57ae3          	bgeu	a0,a4,ffffffffc0202754 <default_free_pages+0x6c>
ffffffffc0202764:	c199                	beqz	a1,ffffffffc020276a <default_free_pages+0x82>
ffffffffc0202766:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020276a:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc020276c:	e390                	sd	a2,0(a5)
ffffffffc020276e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202770:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202772:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc0202774:	02d70063          	beq	a4,a3,ffffffffc0202794 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0202778:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc020277c:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc0202780:	02081613          	slli	a2,a6,0x20
ffffffffc0202784:	9201                	srli	a2,a2,0x20
ffffffffc0202786:	00361793          	slli	a5,a2,0x3
ffffffffc020278a:	97b2                	add	a5,a5,a2
ffffffffc020278c:	078e                	slli	a5,a5,0x3
ffffffffc020278e:	97ae                	add	a5,a5,a1
ffffffffc0202790:	02f50f63          	beq	a0,a5,ffffffffc02027ce <default_free_pages+0xe6>
    return listelm->next;
ffffffffc0202794:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc0202796:	00d70f63          	beq	a4,a3,ffffffffc02027b4 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc020279a:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc020279c:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc02027a0:	02059613          	slli	a2,a1,0x20
ffffffffc02027a4:	9201                	srli	a2,a2,0x20
ffffffffc02027a6:	00361793          	slli	a5,a2,0x3
ffffffffc02027aa:	97b2                	add	a5,a5,a2
ffffffffc02027ac:	078e                	slli	a5,a5,0x3
ffffffffc02027ae:	97aa                	add	a5,a5,a0
ffffffffc02027b0:	04f68863          	beq	a3,a5,ffffffffc0202800 <default_free_pages+0x118>
}
ffffffffc02027b4:	60a2                	ld	ra,8(sp)
ffffffffc02027b6:	0141                	addi	sp,sp,16
ffffffffc02027b8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02027ba:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02027bc:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02027be:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02027c0:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02027c2:	02d70563          	beq	a4,a3,ffffffffc02027ec <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc02027c6:	8832                	mv	a6,a2
ffffffffc02027c8:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02027ca:	87ba                	mv	a5,a4
ffffffffc02027cc:	bf41                	j	ffffffffc020275c <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02027ce:	4d1c                	lw	a5,24(a0)
ffffffffc02027d0:	0107883b          	addw	a6,a5,a6
ffffffffc02027d4:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02027d8:	57f5                	li	a5,-3
ffffffffc02027da:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02027de:	7110                	ld	a2,32(a0)
ffffffffc02027e0:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc02027e2:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc02027e4:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc02027e6:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02027e8:	e390                	sd	a2,0(a5)
ffffffffc02027ea:	b775                	j	ffffffffc0202796 <default_free_pages+0xae>
ffffffffc02027ec:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02027ee:	873e                	mv	a4,a5
ffffffffc02027f0:	b761                	j	ffffffffc0202778 <default_free_pages+0x90>
}
ffffffffc02027f2:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02027f4:	e390                	sd	a2,0(a5)
ffffffffc02027f6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02027f8:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02027fa:	f11c                	sd	a5,32(a0)
ffffffffc02027fc:	0141                	addi	sp,sp,16
ffffffffc02027fe:	8082                	ret
            base->property += p->property;
ffffffffc0202800:	ff872783          	lw	a5,-8(a4)
ffffffffc0202804:	fe870693          	addi	a3,a4,-24
ffffffffc0202808:	9dbd                	addw	a1,a1,a5
ffffffffc020280a:	cd0c                	sw	a1,24(a0)
ffffffffc020280c:	57f5                	li	a5,-3
ffffffffc020280e:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202812:	6314                	ld	a3,0(a4)
ffffffffc0202814:	671c                	ld	a5,8(a4)
}
ffffffffc0202816:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0202818:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc020281a:	e394                	sd	a3,0(a5)
ffffffffc020281c:	0141                	addi	sp,sp,16
ffffffffc020281e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202820:	00003697          	auipc	a3,0x3
ffffffffc0202824:	1c868693          	addi	a3,a3,456 # ffffffffc02059e8 <commands+0x1318>
ffffffffc0202828:	00002617          	auipc	a2,0x2
ffffffffc020282c:	61860613          	addi	a2,a2,1560 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202830:	08300593          	li	a1,131
ffffffffc0202834:	00003517          	auipc	a0,0x3
ffffffffc0202838:	e9c50513          	addi	a0,a0,-356 # ffffffffc02056d0 <commands+0x1000>
ffffffffc020283c:	8c7fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc0202840:	00003697          	auipc	a3,0x3
ffffffffc0202844:	1a068693          	addi	a3,a3,416 # ffffffffc02059e0 <commands+0x1310>
ffffffffc0202848:	00002617          	auipc	a2,0x2
ffffffffc020284c:	5f860613          	addi	a2,a2,1528 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202850:	08000593          	li	a1,128
ffffffffc0202854:	00003517          	auipc	a0,0x3
ffffffffc0202858:	e7c50513          	addi	a0,a0,-388 # ffffffffc02056d0 <commands+0x1000>
ffffffffc020285c:	8a7fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202860 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0202860:	c959                	beqz	a0,ffffffffc02028f6 <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc0202862:	0000f597          	auipc	a1,0xf
ffffffffc0202866:	87e58593          	addi	a1,a1,-1922 # ffffffffc02110e0 <free_area>
ffffffffc020286a:	0105a803          	lw	a6,16(a1)
ffffffffc020286e:	862a                	mv	a2,a0
ffffffffc0202870:	02081793          	slli	a5,a6,0x20
ffffffffc0202874:	9381                	srli	a5,a5,0x20
ffffffffc0202876:	00a7ee63          	bltu	a5,a0,ffffffffc0202892 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020287a:	87ae                	mv	a5,a1
ffffffffc020287c:	a801                	j	ffffffffc020288c <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc020287e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202882:	02071693          	slli	a3,a4,0x20
ffffffffc0202886:	9281                	srli	a3,a3,0x20
ffffffffc0202888:	00c6f763          	bgeu	a3,a2,ffffffffc0202896 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc020288c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc020288e:	feb798e3          	bne	a5,a1,ffffffffc020287e <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0202892:	4501                	li	a0,0
}
ffffffffc0202894:	8082                	ret
    return listelm->prev;
ffffffffc0202896:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020289a:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020289e:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc02028a2:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc02028a6:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02028aa:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc02028ae:	02d67b63          	bgeu	a2,a3,ffffffffc02028e4 <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc02028b2:	00361693          	slli	a3,a2,0x3
ffffffffc02028b6:	96b2                	add	a3,a3,a2
ffffffffc02028b8:	068e                	slli	a3,a3,0x3
ffffffffc02028ba:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc02028bc:	41c7073b          	subw	a4,a4,t3
ffffffffc02028c0:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02028c2:	00868613          	addi	a2,a3,8
ffffffffc02028c6:	4709                	li	a4,2
ffffffffc02028c8:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02028cc:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02028d0:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc02028d4:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02028d8:	e310                	sd	a2,0(a4)
ffffffffc02028da:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02028de:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc02028e0:	0316b023          	sd	a7,32(a3)
ffffffffc02028e4:	41c8083b          	subw	a6,a6,t3
ffffffffc02028e8:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02028ec:	5775                	li	a4,-3
ffffffffc02028ee:	17a1                	addi	a5,a5,-24
ffffffffc02028f0:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02028f4:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02028f6:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02028f8:	00003697          	auipc	a3,0x3
ffffffffc02028fc:	0e868693          	addi	a3,a3,232 # ffffffffc02059e0 <commands+0x1310>
ffffffffc0202900:	00002617          	auipc	a2,0x2
ffffffffc0202904:	54060613          	addi	a2,a2,1344 # ffffffffc0204e40 <commands+0x770>
ffffffffc0202908:	06200593          	li	a1,98
ffffffffc020290c:	00003517          	auipc	a0,0x3
ffffffffc0202910:	dc450513          	addi	a0,a0,-572 # ffffffffc02056d0 <commands+0x1000>
default_alloc_pages(size_t n) {
ffffffffc0202914:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202916:	fecfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc020291a <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc020291a:	1141                	addi	sp,sp,-16
ffffffffc020291c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020291e:	c9e1                	beqz	a1,ffffffffc02029ee <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0202920:	00359693          	slli	a3,a1,0x3
ffffffffc0202924:	96ae                	add	a3,a3,a1
ffffffffc0202926:	068e                	slli	a3,a3,0x3
ffffffffc0202928:	96aa                	add	a3,a3,a0
ffffffffc020292a:	87aa                	mv	a5,a0
ffffffffc020292c:	00d50f63          	beq	a0,a3,ffffffffc020294a <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0202930:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0202932:	8b05                	andi	a4,a4,1
ffffffffc0202934:	cf49                	beqz	a4,ffffffffc02029ce <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0202936:	0007ac23          	sw	zero,24(a5)
ffffffffc020293a:	0007b423          	sd	zero,8(a5)
ffffffffc020293e:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0202942:	04878793          	addi	a5,a5,72
ffffffffc0202946:	fed795e3          	bne	a5,a3,ffffffffc0202930 <default_init_memmap+0x16>
    base->property = n;
ffffffffc020294a:	2581                	sext.w	a1,a1
ffffffffc020294c:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020294e:	4789                	li	a5,2
ffffffffc0202950:	00850713          	addi	a4,a0,8
ffffffffc0202954:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0202958:	0000e697          	auipc	a3,0xe
ffffffffc020295c:	78868693          	addi	a3,a3,1928 # ffffffffc02110e0 <free_area>
ffffffffc0202960:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0202962:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0202964:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0202968:	9db9                	addw	a1,a1,a4
ffffffffc020296a:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020296c:	04d78a63          	beq	a5,a3,ffffffffc02029c0 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0202970:	fe078713          	addi	a4,a5,-32
ffffffffc0202974:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0202978:	4581                	li	a1,0
            if (base < page) {
ffffffffc020297a:	00e56a63          	bltu	a0,a4,ffffffffc020298e <default_init_memmap+0x74>
    return listelm->next;
ffffffffc020297e:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0202980:	02d70263          	beq	a4,a3,ffffffffc02029a4 <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc0202984:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0202986:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc020298a:	fee57ae3          	bgeu	a0,a4,ffffffffc020297e <default_init_memmap+0x64>
ffffffffc020298e:	c199                	beqz	a1,ffffffffc0202994 <default_init_memmap+0x7a>
ffffffffc0202990:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202994:	6398                	ld	a4,0(a5)
}
ffffffffc0202996:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202998:	e390                	sd	a2,0(a5)
ffffffffc020299a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020299c:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020299e:	f118                	sd	a4,32(a0)
ffffffffc02029a0:	0141                	addi	sp,sp,16
ffffffffc02029a2:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02029a4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02029a6:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02029a8:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02029aa:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02029ac:	00d70663          	beq	a4,a3,ffffffffc02029b8 <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02029b0:	8832                	mv	a6,a2
ffffffffc02029b2:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02029b4:	87ba                	mv	a5,a4
ffffffffc02029b6:	bfc1                	j	ffffffffc0202986 <default_init_memmap+0x6c>
}
ffffffffc02029b8:	60a2                	ld	ra,8(sp)
ffffffffc02029ba:	e290                	sd	a2,0(a3)
ffffffffc02029bc:	0141                	addi	sp,sp,16
ffffffffc02029be:	8082                	ret
ffffffffc02029c0:	60a2                	ld	ra,8(sp)
ffffffffc02029c2:	e390                	sd	a2,0(a5)
ffffffffc02029c4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02029c6:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02029c8:	f11c                	sd	a5,32(a0)
ffffffffc02029ca:	0141                	addi	sp,sp,16
ffffffffc02029cc:	8082                	ret
        assert(PageReserved(p));
ffffffffc02029ce:	00003697          	auipc	a3,0x3
ffffffffc02029d2:	04268693          	addi	a3,a3,66 # ffffffffc0205a10 <commands+0x1340>
ffffffffc02029d6:	00002617          	auipc	a2,0x2
ffffffffc02029da:	46a60613          	addi	a2,a2,1130 # ffffffffc0204e40 <commands+0x770>
ffffffffc02029de:	04900593          	li	a1,73
ffffffffc02029e2:	00003517          	auipc	a0,0x3
ffffffffc02029e6:	cee50513          	addi	a0,a0,-786 # ffffffffc02056d0 <commands+0x1000>
ffffffffc02029ea:	f18fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc02029ee:	00003697          	auipc	a3,0x3
ffffffffc02029f2:	ff268693          	addi	a3,a3,-14 # ffffffffc02059e0 <commands+0x1310>
ffffffffc02029f6:	00002617          	auipc	a2,0x2
ffffffffc02029fa:	44a60613          	addi	a2,a2,1098 # ffffffffc0204e40 <commands+0x770>
ffffffffc02029fe:	04600593          	li	a1,70
ffffffffc0202a02:	00003517          	auipc	a0,0x3
ffffffffc0202a06:	cce50513          	addi	a0,a0,-818 # ffffffffc02056d0 <commands+0x1000>
ffffffffc0202a0a:	ef8fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a0e <pa2page.part.0>:
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202a0e:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202a10:	00002617          	auipc	a2,0x2
ffffffffc0202a14:	68060613          	addi	a2,a2,1664 # ffffffffc0205090 <commands+0x9c0>
ffffffffc0202a18:	06500593          	li	a1,101
ffffffffc0202a1c:	00002517          	auipc	a0,0x2
ffffffffc0202a20:	69450513          	addi	a0,a0,1684 # ffffffffc02050b0 <commands+0x9e0>
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202a24:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202a26:	edcfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a2a <pte2page.part.0>:
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202a2a:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202a2c:	00003617          	auipc	a2,0x3
ffffffffc0202a30:	af460613          	addi	a2,a2,-1292 # ffffffffc0205520 <commands+0xe50>
ffffffffc0202a34:	07000593          	li	a1,112
ffffffffc0202a38:	00002517          	auipc	a0,0x2
ffffffffc0202a3c:	67850513          	addi	a0,a0,1656 # ffffffffc02050b0 <commands+0x9e0>
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202a40:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202a42:	ec0fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a46 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0202a46:	7139                	addi	sp,sp,-64
ffffffffc0202a48:	f426                	sd	s1,40(sp)
ffffffffc0202a4a:	f04a                	sd	s2,32(sp)
ffffffffc0202a4c:	ec4e                	sd	s3,24(sp)
ffffffffc0202a4e:	e852                	sd	s4,16(sp)
ffffffffc0202a50:	e456                	sd	s5,8(sp)
ffffffffc0202a52:	e05a                	sd	s6,0(sp)
ffffffffc0202a54:	fc06                	sd	ra,56(sp)
ffffffffc0202a56:	f822                	sd	s0,48(sp)
ffffffffc0202a58:	84aa                	mv	s1,a0
ffffffffc0202a5a:	0000f917          	auipc	s2,0xf
ffffffffc0202a5e:	b0e90913          	addi	s2,s2,-1266 # ffffffffc0211568 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202a62:	4a05                	li	s4,1
ffffffffc0202a64:	0000fa97          	auipc	s5,0xf
ffffffffc0202a68:	adca8a93          	addi	s5,s5,-1316 # ffffffffc0211540 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a6c:	0005099b          	sext.w	s3,a0
ffffffffc0202a70:	0000fb17          	auipc	s6,0xf
ffffffffc0202a74:	aa8b0b13          	addi	s6,s6,-1368 # ffffffffc0211518 <check_mm_struct>
ffffffffc0202a78:	a01d                	j	ffffffffc0202a9e <alloc_pages+0x58>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202a7a:	00093783          	ld	a5,0(s2)
ffffffffc0202a7e:	6f9c                	ld	a5,24(a5)
ffffffffc0202a80:	9782                	jalr	a5
ffffffffc0202a82:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a84:	4601                	li	a2,0
ffffffffc0202a86:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202a88:	ec0d                	bnez	s0,ffffffffc0202ac2 <alloc_pages+0x7c>
ffffffffc0202a8a:	029a6c63          	bltu	s4,s1,ffffffffc0202ac2 <alloc_pages+0x7c>
ffffffffc0202a8e:	000aa783          	lw	a5,0(s5)
ffffffffc0202a92:	2781                	sext.w	a5,a5
ffffffffc0202a94:	c79d                	beqz	a5,ffffffffc0202ac2 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a96:	000b3503          	ld	a0,0(s6)
ffffffffc0202a9a:	b0eff0ef          	jal	ra,ffffffffc0201da8 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202a9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202aa2:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202aa4:	8526                	mv	a0,s1
ffffffffc0202aa6:	dbf1                	beqz	a5,ffffffffc0202a7a <alloc_pages+0x34>
        intr_disable();
ffffffffc0202aa8:	a47fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202aac:	00093783          	ld	a5,0(s2)
ffffffffc0202ab0:	8526                	mv	a0,s1
ffffffffc0202ab2:	6f9c                	ld	a5,24(a5)
ffffffffc0202ab4:	9782                	jalr	a5
ffffffffc0202ab6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202ab8:	a31fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202abc:	4601                	li	a2,0
ffffffffc0202abe:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202ac0:	d469                	beqz	s0,ffffffffc0202a8a <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0202ac2:	70e2                	ld	ra,56(sp)
ffffffffc0202ac4:	8522                	mv	a0,s0
ffffffffc0202ac6:	7442                	ld	s0,48(sp)
ffffffffc0202ac8:	74a2                	ld	s1,40(sp)
ffffffffc0202aca:	7902                	ld	s2,32(sp)
ffffffffc0202acc:	69e2                	ld	s3,24(sp)
ffffffffc0202ace:	6a42                	ld	s4,16(sp)
ffffffffc0202ad0:	6aa2                	ld	s5,8(sp)
ffffffffc0202ad2:	6b02                	ld	s6,0(sp)
ffffffffc0202ad4:	6121                	addi	sp,sp,64
ffffffffc0202ad6:	8082                	ret

ffffffffc0202ad8 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202ad8:	100027f3          	csrr	a5,sstatus
ffffffffc0202adc:	8b89                	andi	a5,a5,2
ffffffffc0202ade:	e799                	bnez	a5,ffffffffc0202aec <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc0202ae0:	0000f797          	auipc	a5,0xf
ffffffffc0202ae4:	a887b783          	ld	a5,-1400(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202ae8:	739c                	ld	a5,32(a5)
ffffffffc0202aea:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0202aec:	1101                	addi	sp,sp,-32
ffffffffc0202aee:	ec06                	sd	ra,24(sp)
ffffffffc0202af0:	e822                	sd	s0,16(sp)
ffffffffc0202af2:	e426                	sd	s1,8(sp)
ffffffffc0202af4:	842a                	mv	s0,a0
ffffffffc0202af6:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202af8:	9f7fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202afc:	0000f797          	auipc	a5,0xf
ffffffffc0202b00:	a6c7b783          	ld	a5,-1428(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202b04:	739c                	ld	a5,32(a5)
ffffffffc0202b06:	85a6                	mv	a1,s1
ffffffffc0202b08:	8522                	mv	a0,s0
ffffffffc0202b0a:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc0202b0c:	6442                	ld	s0,16(sp)
ffffffffc0202b0e:	60e2                	ld	ra,24(sp)
ffffffffc0202b10:	64a2                	ld	s1,8(sp)
ffffffffc0202b12:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202b14:	9d5fd06f          	j	ffffffffc02004e8 <intr_enable>

ffffffffc0202b18 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b18:	100027f3          	csrr	a5,sstatus
ffffffffc0202b1c:	8b89                	andi	a5,a5,2
ffffffffc0202b1e:	e799                	bnez	a5,ffffffffc0202b2c <nr_free_pages+0x14>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202b20:	0000f797          	auipc	a5,0xf
ffffffffc0202b24:	a487b783          	ld	a5,-1464(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202b28:	779c                	ld	a5,40(a5)
ffffffffc0202b2a:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0202b2c:	1141                	addi	sp,sp,-16
ffffffffc0202b2e:	e406                	sd	ra,8(sp)
ffffffffc0202b30:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202b32:	9bdfd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202b36:	0000f797          	auipc	a5,0xf
ffffffffc0202b3a:	a327b783          	ld	a5,-1486(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202b3e:	779c                	ld	a5,40(a5)
ffffffffc0202b40:	9782                	jalr	a5
ffffffffc0202b42:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202b44:	9a5fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202b48:	60a2                	ld	ra,8(sp)
ffffffffc0202b4a:	8522                	mv	a0,s0
ffffffffc0202b4c:	6402                	ld	s0,0(sp)
ffffffffc0202b4e:	0141                	addi	sp,sp,16
ffffffffc0202b50:	8082                	ret

ffffffffc0202b52 <get_pte>:
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    //获取一级页目录条目
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b52:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202b56:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b5a:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b5c:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b5e:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b60:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b64:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b66:	f84a                	sd	s2,48(sp)
ffffffffc0202b68:	f44e                	sd	s3,40(sp)
ffffffffc0202b6a:	f052                	sd	s4,32(sp)
ffffffffc0202b6c:	e486                	sd	ra,72(sp)
ffffffffc0202b6e:	e0a2                	sd	s0,64(sp)
ffffffffc0202b70:	ec56                	sd	s5,24(sp)
ffffffffc0202b72:	e85a                	sd	s6,16(sp)
ffffffffc0202b74:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b76:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b7a:	892e                	mv	s2,a1
ffffffffc0202b7c:	8a32                	mv	s4,a2
ffffffffc0202b7e:	0000f997          	auipc	s3,0xf
ffffffffc0202b82:	9da98993          	addi	s3,s3,-1574 # ffffffffc0211558 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b86:	efb5                	bnez	a5,ffffffffc0202c02 <get_pte+0xb0>
        struct Page *page;
        //分配新的页面
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202b88:	14060c63          	beqz	a2,ffffffffc0202ce0 <get_pte+0x18e>
ffffffffc0202b8c:	4505                	li	a0,1
ffffffffc0202b8e:	eb9ff0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202b92:	842a                	mv	s0,a0
ffffffffc0202b94:	14050663          	beqz	a0,ffffffffc0202ce0 <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202b98:	0000fb97          	auipc	s7,0xf
ffffffffc0202b9c:	9c8b8b93          	addi	s7,s7,-1592 # ffffffffc0211560 <pages>
ffffffffc0202ba0:	000bb503          	ld	a0,0(s7)
ffffffffc0202ba4:	00003b17          	auipc	s6,0x3
ffffffffc0202ba8:	764b3b03          	ld	s6,1892(s6) # ffffffffc0206308 <error_string+0x38>
ffffffffc0202bac:	00080ab7          	lui	s5,0x80
ffffffffc0202bb0:	40a40533          	sub	a0,s0,a0
ffffffffc0202bb4:	850d                	srai	a0,a0,0x3
ffffffffc0202bb6:	03650533          	mul	a0,a0,s6
        }
        //设置页面引用计数
        set_page_ref(page, 1);
        //获取物理地址并清零
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202bba:	0000f997          	auipc	s3,0xf
ffffffffc0202bbe:	99e98993          	addi	s3,s3,-1634 # ffffffffc0211558 <npage>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202bc2:	4785                	li	a5,1
ffffffffc0202bc4:	0009b703          	ld	a4,0(s3)
ffffffffc0202bc8:	c01c                	sw	a5,0(s0)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202bca:	9556                	add	a0,a0,s5
ffffffffc0202bcc:	00c51793          	slli	a5,a0,0xc
ffffffffc0202bd0:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202bd2:	0532                	slli	a0,a0,0xc
ffffffffc0202bd4:	14e7fd63          	bgeu	a5,a4,ffffffffc0202d2e <get_pte+0x1dc>
ffffffffc0202bd8:	0000f797          	auipc	a5,0xf
ffffffffc0202bdc:	9987b783          	ld	a5,-1640(a5) # ffffffffc0211570 <va_pa_offset>
ffffffffc0202be0:	6605                	lui	a2,0x1
ffffffffc0202be2:	4581                	li	a1,0
ffffffffc0202be4:	953e                	add	a0,a0,a5
ffffffffc0202be6:	3a2010ef          	jal	ra,ffffffffc0203f88 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202bea:	000bb683          	ld	a3,0(s7)
ffffffffc0202bee:	40d406b3          	sub	a3,s0,a3
ffffffffc0202bf2:	868d                	srai	a3,a3,0x3
ffffffffc0202bf4:	036686b3          	mul	a3,a3,s6
ffffffffc0202bf8:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202bfa:	06aa                	slli	a3,a3,0xa
ffffffffc0202bfc:	0116e693          	ori	a3,a3,17
        //更新一级页目录条目
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202c00:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202c02:	77fd                	lui	a5,0xfffff
ffffffffc0202c04:	068a                	slli	a3,a3,0x2
ffffffffc0202c06:	0009b703          	ld	a4,0(s3)
ffffffffc0202c0a:	8efd                	and	a3,a3,a5
ffffffffc0202c0c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202c10:	0ce7fa63          	bgeu	a5,a4,ffffffffc0202ce4 <get_pte+0x192>
ffffffffc0202c14:	0000fa97          	auipc	s5,0xf
ffffffffc0202c18:	95ca8a93          	addi	s5,s5,-1700 # ffffffffc0211570 <va_pa_offset>
ffffffffc0202c1c:	000ab403          	ld	s0,0(s5)
ffffffffc0202c20:	01595793          	srli	a5,s2,0x15
ffffffffc0202c24:	1ff7f793          	andi	a5,a5,511
ffffffffc0202c28:	96a2                	add	a3,a3,s0
ffffffffc0202c2a:	00379413          	slli	s0,a5,0x3
ffffffffc0202c2e:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc0202c30:	6014                	ld	a3,0(s0)
ffffffffc0202c32:	0016f793          	andi	a5,a3,1
ffffffffc0202c36:	ebad                	bnez	a5,ffffffffc0202ca8 <get_pte+0x156>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202c38:	0a0a0463          	beqz	s4,ffffffffc0202ce0 <get_pte+0x18e>
ffffffffc0202c3c:	4505                	li	a0,1
ffffffffc0202c3e:	e09ff0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0202c42:	84aa                	mv	s1,a0
ffffffffc0202c44:	cd51                	beqz	a0,ffffffffc0202ce0 <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c46:	0000fb97          	auipc	s7,0xf
ffffffffc0202c4a:	91ab8b93          	addi	s7,s7,-1766 # ffffffffc0211560 <pages>
ffffffffc0202c4e:	000bb503          	ld	a0,0(s7)
ffffffffc0202c52:	00003b17          	auipc	s6,0x3
ffffffffc0202c56:	6b6b3b03          	ld	s6,1718(s6) # ffffffffc0206308 <error_string+0x38>
ffffffffc0202c5a:	00080a37          	lui	s4,0x80
ffffffffc0202c5e:	40a48533          	sub	a0,s1,a0
ffffffffc0202c62:	850d                	srai	a0,a0,0x3
ffffffffc0202c64:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202c68:	4785                	li	a5,1
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202c6a:	0009b703          	ld	a4,0(s3)
ffffffffc0202c6e:	c09c                	sw	a5,0(s1)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c70:	9552                	add	a0,a0,s4
ffffffffc0202c72:	00c51793          	slli	a5,a0,0xc
ffffffffc0202c76:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c78:	0532                	slli	a0,a0,0xc
ffffffffc0202c7a:	08e7fd63          	bgeu	a5,a4,ffffffffc0202d14 <get_pte+0x1c2>
ffffffffc0202c7e:	000ab783          	ld	a5,0(s5)
ffffffffc0202c82:	6605                	lui	a2,0x1
ffffffffc0202c84:	4581                	li	a1,0
ffffffffc0202c86:	953e                	add	a0,a0,a5
ffffffffc0202c88:	300010ef          	jal	ra,ffffffffc0203f88 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c8c:	000bb683          	ld	a3,0(s7)
ffffffffc0202c90:	40d486b3          	sub	a3,s1,a3
ffffffffc0202c94:	868d                	srai	a3,a3,0x3
ffffffffc0202c96:	036686b3          	mul	a3,a3,s6
ffffffffc0202c9a:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202c9c:	06aa                	slli	a3,a3,0xa
ffffffffc0202c9e:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202ca2:	e014                	sd	a3,0(s0)
    }
    //将物理地址转换为内核虚拟地址，并获取对应的页表条目指针返回
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202ca4:	0009b703          	ld	a4,0(s3)
ffffffffc0202ca8:	068a                	slli	a3,a3,0x2
ffffffffc0202caa:	757d                	lui	a0,0xfffff
ffffffffc0202cac:	8ee9                	and	a3,a3,a0
ffffffffc0202cae:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202cb2:	04e7f563          	bgeu	a5,a4,ffffffffc0202cfc <get_pte+0x1aa>
ffffffffc0202cb6:	000ab503          	ld	a0,0(s5)
ffffffffc0202cba:	00c95913          	srli	s2,s2,0xc
ffffffffc0202cbe:	1ff97913          	andi	s2,s2,511
ffffffffc0202cc2:	96aa                	add	a3,a3,a0
ffffffffc0202cc4:	00391513          	slli	a0,s2,0x3
ffffffffc0202cc8:	9536                	add	a0,a0,a3
}
ffffffffc0202cca:	60a6                	ld	ra,72(sp)
ffffffffc0202ccc:	6406                	ld	s0,64(sp)
ffffffffc0202cce:	74e2                	ld	s1,56(sp)
ffffffffc0202cd0:	7942                	ld	s2,48(sp)
ffffffffc0202cd2:	79a2                	ld	s3,40(sp)
ffffffffc0202cd4:	7a02                	ld	s4,32(sp)
ffffffffc0202cd6:	6ae2                	ld	s5,24(sp)
ffffffffc0202cd8:	6b42                	ld	s6,16(sp)
ffffffffc0202cda:	6ba2                	ld	s7,8(sp)
ffffffffc0202cdc:	6161                	addi	sp,sp,80
ffffffffc0202cde:	8082                	ret
            return NULL;
ffffffffc0202ce0:	4501                	li	a0,0
ffffffffc0202ce2:	b7e5                	j	ffffffffc0202cca <get_pte+0x178>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202ce4:	00003617          	auipc	a2,0x3
ffffffffc0202ce8:	d8c60613          	addi	a2,a2,-628 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0202cec:	10700593          	li	a1,263
ffffffffc0202cf0:	00003517          	auipc	a0,0x3
ffffffffc0202cf4:	da850513          	addi	a0,a0,-600 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0202cf8:	c0afd0ef          	jal	ra,ffffffffc0200102 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202cfc:	00003617          	auipc	a2,0x3
ffffffffc0202d00:	d7460613          	addi	a2,a2,-652 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0202d04:	11500593          	li	a1,277
ffffffffc0202d08:	00003517          	auipc	a0,0x3
ffffffffc0202d0c:	d9050513          	addi	a0,a0,-624 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0202d10:	bf2fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202d14:	86aa                	mv	a3,a0
ffffffffc0202d16:	00003617          	auipc	a2,0x3
ffffffffc0202d1a:	d5a60613          	addi	a2,a2,-678 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0202d1e:	11000593          	li	a1,272
ffffffffc0202d22:	00003517          	auipc	a0,0x3
ffffffffc0202d26:	d7650513          	addi	a0,a0,-650 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0202d2a:	bd8fd0ef          	jal	ra,ffffffffc0200102 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202d2e:	86aa                	mv	a3,a0
ffffffffc0202d30:	00003617          	auipc	a2,0x3
ffffffffc0202d34:	d4060613          	addi	a2,a2,-704 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0202d38:	10300593          	li	a1,259
ffffffffc0202d3c:	00003517          	auipc	a0,0x3
ffffffffc0202d40:	d5c50513          	addi	a0,a0,-676 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0202d44:	bbefd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202d48 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202d48:	1141                	addi	sp,sp,-16
ffffffffc0202d4a:	e022                	sd	s0,0(sp)
ffffffffc0202d4c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d4e:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202d50:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d52:	e01ff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0202d56:	c011                	beqz	s0,ffffffffc0202d5a <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0202d58:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202d5a:	c511                	beqz	a0,ffffffffc0202d66 <get_page+0x1e>
ffffffffc0202d5c:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202d5e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202d60:	0017f713          	andi	a4,a5,1
ffffffffc0202d64:	e709                	bnez	a4,ffffffffc0202d6e <get_page+0x26>
}
ffffffffc0202d66:	60a2                	ld	ra,8(sp)
ffffffffc0202d68:	6402                	ld	s0,0(sp)
ffffffffc0202d6a:	0141                	addi	sp,sp,16
ffffffffc0202d6c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202d6e:	078a                	slli	a5,a5,0x2
ffffffffc0202d70:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202d72:	0000e717          	auipc	a4,0xe
ffffffffc0202d76:	7e673703          	ld	a4,2022(a4) # ffffffffc0211558 <npage>
ffffffffc0202d7a:	02e7f263          	bgeu	a5,a4,ffffffffc0202d9e <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d7e:	fff80537          	lui	a0,0xfff80
ffffffffc0202d82:	97aa                	add	a5,a5,a0
ffffffffc0202d84:	60a2                	ld	ra,8(sp)
ffffffffc0202d86:	6402                	ld	s0,0(sp)
ffffffffc0202d88:	00379513          	slli	a0,a5,0x3
ffffffffc0202d8c:	97aa                	add	a5,a5,a0
ffffffffc0202d8e:	078e                	slli	a5,a5,0x3
ffffffffc0202d90:	0000e517          	auipc	a0,0xe
ffffffffc0202d94:	7d053503          	ld	a0,2000(a0) # ffffffffc0211560 <pages>
ffffffffc0202d98:	953e                	add	a0,a0,a5
ffffffffc0202d9a:	0141                	addi	sp,sp,16
ffffffffc0202d9c:	8082                	ret
ffffffffc0202d9e:	c71ff0ef          	jal	ra,ffffffffc0202a0e <pa2page.part.0>

ffffffffc0202da2 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202da2:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202da4:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202da6:	ec06                	sd	ra,24(sp)
ffffffffc0202da8:	e822                	sd	s0,16(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202daa:	da9ff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
    if (ptep != NULL) {
ffffffffc0202dae:	c511                	beqz	a0,ffffffffc0202dba <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0202db0:	611c                	ld	a5,0(a0)
ffffffffc0202db2:	842a                	mv	s0,a0
ffffffffc0202db4:	0017f713          	andi	a4,a5,1
ffffffffc0202db8:	e709                	bnez	a4,ffffffffc0202dc2 <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0202dba:	60e2                	ld	ra,24(sp)
ffffffffc0202dbc:	6442                	ld	s0,16(sp)
ffffffffc0202dbe:	6105                	addi	sp,sp,32
ffffffffc0202dc0:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202dc2:	078a                	slli	a5,a5,0x2
ffffffffc0202dc4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202dc6:	0000e717          	auipc	a4,0xe
ffffffffc0202dca:	79273703          	ld	a4,1938(a4) # ffffffffc0211558 <npage>
ffffffffc0202dce:	06e7f563          	bgeu	a5,a4,ffffffffc0202e38 <page_remove+0x96>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dd2:	fff80737          	lui	a4,0xfff80
ffffffffc0202dd6:	97ba                	add	a5,a5,a4
ffffffffc0202dd8:	00379513          	slli	a0,a5,0x3
ffffffffc0202ddc:	97aa                	add	a5,a5,a0
ffffffffc0202dde:	078e                	slli	a5,a5,0x3
ffffffffc0202de0:	0000e517          	auipc	a0,0xe
ffffffffc0202de4:	78053503          	ld	a0,1920(a0) # ffffffffc0211560 <pages>
ffffffffc0202de8:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202dea:	411c                	lw	a5,0(a0)
ffffffffc0202dec:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202df0:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202df2:	cb09                	beqz	a4,ffffffffc0202e04 <page_remove+0x62>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202df4:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202df8:	12000073          	sfence.vma
}
ffffffffc0202dfc:	60e2                	ld	ra,24(sp)
ffffffffc0202dfe:	6442                	ld	s0,16(sp)
ffffffffc0202e00:	6105                	addi	sp,sp,32
ffffffffc0202e02:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202e04:	100027f3          	csrr	a5,sstatus
ffffffffc0202e08:	8b89                	andi	a5,a5,2
ffffffffc0202e0a:	eb89                	bnez	a5,ffffffffc0202e1c <page_remove+0x7a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202e0c:	0000e797          	auipc	a5,0xe
ffffffffc0202e10:	75c7b783          	ld	a5,1884(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202e14:	739c                	ld	a5,32(a5)
ffffffffc0202e16:	4585                	li	a1,1
ffffffffc0202e18:	9782                	jalr	a5
    if (flag) {
ffffffffc0202e1a:	bfe9                	j	ffffffffc0202df4 <page_remove+0x52>
        intr_disable();
ffffffffc0202e1c:	e42a                	sd	a0,8(sp)
ffffffffc0202e1e:	ed0fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202e22:	0000e797          	auipc	a5,0xe
ffffffffc0202e26:	7467b783          	ld	a5,1862(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202e2a:	739c                	ld	a5,32(a5)
ffffffffc0202e2c:	6522                	ld	a0,8(sp)
ffffffffc0202e2e:	4585                	li	a1,1
ffffffffc0202e30:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e32:	eb6fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202e36:	bf7d                	j	ffffffffc0202df4 <page_remove+0x52>
ffffffffc0202e38:	bd7ff0ef          	jal	ra,ffffffffc0202a0e <pa2page.part.0>

ffffffffc0202e3c <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e3c:	7179                	addi	sp,sp,-48
ffffffffc0202e3e:	87b2                	mv	a5,a2
ffffffffc0202e40:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e42:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e44:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e46:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e48:	ec26                	sd	s1,24(sp)
ffffffffc0202e4a:	f406                	sd	ra,40(sp)
ffffffffc0202e4c:	e84a                	sd	s2,16(sp)
ffffffffc0202e4e:	e44e                	sd	s3,8(sp)
ffffffffc0202e50:	e052                	sd	s4,0(sp)
ffffffffc0202e52:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e54:	cffff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
    if (ptep == NULL) {
ffffffffc0202e58:	cd71                	beqz	a0,ffffffffc0202f34 <page_insert+0xf8>
    page->ref += 1;
ffffffffc0202e5a:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);//增加一次引用
    if (*ptep & PTE_V) {
ffffffffc0202e5c:	611c                	ld	a5,0(a0)
ffffffffc0202e5e:	89aa                	mv	s3,a0
ffffffffc0202e60:	0016871b          	addiw	a4,a3,1
ffffffffc0202e64:	c018                	sw	a4,0(s0)
ffffffffc0202e66:	0017f713          	andi	a4,a5,1
ffffffffc0202e6a:	e331                	bnez	a4,ffffffffc0202eae <page_insert+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202e6c:	0000e797          	auipc	a5,0xe
ffffffffc0202e70:	6f47b783          	ld	a5,1780(a5) # ffffffffc0211560 <pages>
ffffffffc0202e74:	40f407b3          	sub	a5,s0,a5
ffffffffc0202e78:	878d                	srai	a5,a5,0x3
ffffffffc0202e7a:	00003417          	auipc	s0,0x3
ffffffffc0202e7e:	48e43403          	ld	s0,1166(s0) # ffffffffc0206308 <error_string+0x38>
ffffffffc0202e82:	028787b3          	mul	a5,a5,s0
ffffffffc0202e86:	00080437          	lui	s0,0x80
ffffffffc0202e8a:	97a2                	add	a5,a5,s0
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202e8c:	07aa                	slli	a5,a5,0xa
ffffffffc0202e8e:	8cdd                	or	s1,s1,a5
ffffffffc0202e90:	0014e493          	ori	s1,s1,1
            page_ref_dec(page);//减少一次引用
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202e94:	0099b023          	sd	s1,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202e98:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0202e9c:	4501                	li	a0,0
}
ffffffffc0202e9e:	70a2                	ld	ra,40(sp)
ffffffffc0202ea0:	7402                	ld	s0,32(sp)
ffffffffc0202ea2:	64e2                	ld	s1,24(sp)
ffffffffc0202ea4:	6942                	ld	s2,16(sp)
ffffffffc0202ea6:	69a2                	ld	s3,8(sp)
ffffffffc0202ea8:	6a02                	ld	s4,0(sp)
ffffffffc0202eaa:	6145                	addi	sp,sp,48
ffffffffc0202eac:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202eae:	00279713          	slli	a4,a5,0x2
ffffffffc0202eb2:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202eb4:	0000e797          	auipc	a5,0xe
ffffffffc0202eb8:	6a47b783          	ld	a5,1700(a5) # ffffffffc0211558 <npage>
ffffffffc0202ebc:	06f77e63          	bgeu	a4,a5,ffffffffc0202f38 <page_insert+0xfc>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ec0:	fff807b7          	lui	a5,0xfff80
ffffffffc0202ec4:	973e                	add	a4,a4,a5
ffffffffc0202ec6:	0000ea17          	auipc	s4,0xe
ffffffffc0202eca:	69aa0a13          	addi	s4,s4,1690 # ffffffffc0211560 <pages>
ffffffffc0202ece:	000a3783          	ld	a5,0(s4)
ffffffffc0202ed2:	00371913          	slli	s2,a4,0x3
ffffffffc0202ed6:	993a                	add	s2,s2,a4
ffffffffc0202ed8:	090e                	slli	s2,s2,0x3
ffffffffc0202eda:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0202edc:	03240063          	beq	s0,s2,ffffffffc0202efc <page_insert+0xc0>
    page->ref -= 1;
ffffffffc0202ee0:	00092783          	lw	a5,0(s2)
ffffffffc0202ee4:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202ee8:	00e92023          	sw	a4,0(s2)
        if (page_ref(page) ==
ffffffffc0202eec:	cb11                	beqz	a4,ffffffffc0202f00 <page_insert+0xc4>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202eee:	0009b023          	sd	zero,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202ef2:	12000073          	sfence.vma
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202ef6:	000a3783          	ld	a5,0(s4)
}
ffffffffc0202efa:	bfad                	j	ffffffffc0202e74 <page_insert+0x38>
    page->ref -= 1;
ffffffffc0202efc:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202efe:	bf9d                	j	ffffffffc0202e74 <page_insert+0x38>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202f00:	100027f3          	csrr	a5,sstatus
ffffffffc0202f04:	8b89                	andi	a5,a5,2
ffffffffc0202f06:	eb91                	bnez	a5,ffffffffc0202f1a <page_insert+0xde>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202f08:	0000e797          	auipc	a5,0xe
ffffffffc0202f0c:	6607b783          	ld	a5,1632(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202f10:	739c                	ld	a5,32(a5)
ffffffffc0202f12:	4585                	li	a1,1
ffffffffc0202f14:	854a                	mv	a0,s2
ffffffffc0202f16:	9782                	jalr	a5
    if (flag) {
ffffffffc0202f18:	bfd9                	j	ffffffffc0202eee <page_insert+0xb2>
        intr_disable();
ffffffffc0202f1a:	dd4fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202f1e:	0000e797          	auipc	a5,0xe
ffffffffc0202f22:	64a7b783          	ld	a5,1610(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0202f26:	739c                	ld	a5,32(a5)
ffffffffc0202f28:	4585                	li	a1,1
ffffffffc0202f2a:	854a                	mv	a0,s2
ffffffffc0202f2c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f2e:	dbafd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202f32:	bf75                	j	ffffffffc0202eee <page_insert+0xb2>
        return -E_NO_MEM;
ffffffffc0202f34:	5571                	li	a0,-4
ffffffffc0202f36:	b7a5                	j	ffffffffc0202e9e <page_insert+0x62>
ffffffffc0202f38:	ad7ff0ef          	jal	ra,ffffffffc0202a0e <pa2page.part.0>

ffffffffc0202f3c <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202f3c:	00003797          	auipc	a5,0x3
ffffffffc0202f40:	afc78793          	addi	a5,a5,-1284 # ffffffffc0205a38 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f44:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0202f46:	7159                	addi	sp,sp,-112
ffffffffc0202f48:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f4a:	00003517          	auipc	a0,0x3
ffffffffc0202f4e:	b5e50513          	addi	a0,a0,-1186 # ffffffffc0205aa8 <default_pmm_manager+0x70>
    pmm_manager = &default_pmm_manager;
ffffffffc0202f52:	0000eb97          	auipc	s7,0xe
ffffffffc0202f56:	616b8b93          	addi	s7,s7,1558 # ffffffffc0211568 <pmm_manager>
void pmm_init(void) {
ffffffffc0202f5a:	f486                	sd	ra,104(sp)
ffffffffc0202f5c:	f0a2                	sd	s0,96(sp)
ffffffffc0202f5e:	eca6                	sd	s1,88(sp)
ffffffffc0202f60:	e8ca                	sd	s2,80(sp)
ffffffffc0202f62:	e4ce                	sd	s3,72(sp)
ffffffffc0202f64:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202f66:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0202f6a:	e0d2                	sd	s4,64(sp)
ffffffffc0202f6c:	fc56                	sd	s5,56(sp)
ffffffffc0202f6e:	f062                	sd	s8,32(sp)
ffffffffc0202f70:	ec66                	sd	s9,24(sp)
ffffffffc0202f72:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f74:	946fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0202f78:	000bb783          	ld	a5,0(s7)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202f7c:	4445                	li	s0,17
ffffffffc0202f7e:	40100913          	li	s2,1025
    pmm_manager->init();
ffffffffc0202f82:	679c                	ld	a5,8(a5)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202f84:	0000e997          	auipc	s3,0xe
ffffffffc0202f88:	5ec98993          	addi	s3,s3,1516 # ffffffffc0211570 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0202f8c:	0000e497          	auipc	s1,0xe
ffffffffc0202f90:	5cc48493          	addi	s1,s1,1484 # ffffffffc0211558 <npage>
    pmm_manager->init();
ffffffffc0202f94:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202f96:	57f5                	li	a5,-3
ffffffffc0202f98:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202f9a:	07e006b7          	lui	a3,0x7e00
ffffffffc0202f9e:	01b41613          	slli	a2,s0,0x1b
ffffffffc0202fa2:	01591593          	slli	a1,s2,0x15
ffffffffc0202fa6:	00003517          	auipc	a0,0x3
ffffffffc0202faa:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0205ac0 <default_pmm_manager+0x88>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202fae:	00f9b023          	sd	a5,0(s3)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202fb2:	908fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0202fb6:	00003517          	auipc	a0,0x3
ffffffffc0202fba:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0205af0 <default_pmm_manager+0xb8>
ffffffffc0202fbe:	8fcfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202fc2:	01b41693          	slli	a3,s0,0x1b
ffffffffc0202fc6:	16fd                	addi	a3,a3,-1
ffffffffc0202fc8:	07e005b7          	lui	a1,0x7e00
ffffffffc0202fcc:	01591613          	slli	a2,s2,0x15
ffffffffc0202fd0:	00003517          	auipc	a0,0x3
ffffffffc0202fd4:	b3850513          	addi	a0,a0,-1224 # ffffffffc0205b08 <default_pmm_manager+0xd0>
ffffffffc0202fd8:	8e2fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202fdc:	777d                	lui	a4,0xfffff
ffffffffc0202fde:	0000f797          	auipc	a5,0xf
ffffffffc0202fe2:	59978793          	addi	a5,a5,1433 # ffffffffc0212577 <end+0xfff>
ffffffffc0202fe6:	8ff9                	and	a5,a5,a4
ffffffffc0202fe8:	0000eb17          	auipc	s6,0xe
ffffffffc0202fec:	578b0b13          	addi	s6,s6,1400 # ffffffffc0211560 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202ff0:	00088737          	lui	a4,0x88
ffffffffc0202ff4:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202ff6:	00fb3023          	sd	a5,0(s6)
ffffffffc0202ffa:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0202ffc:	4701                	li	a4,0
ffffffffc0202ffe:	4505                	li	a0,1
ffffffffc0203000:	fff805b7          	lui	a1,0xfff80
ffffffffc0203004:	a019                	j	ffffffffc020300a <pmm_init+0xce>
        SetPageReserved(pages + i);
ffffffffc0203006:	000b3783          	ld	a5,0(s6)
ffffffffc020300a:	97b6                	add	a5,a5,a3
ffffffffc020300c:	07a1                	addi	a5,a5,8
ffffffffc020300e:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0203012:	609c                	ld	a5,0(s1)
ffffffffc0203014:	0705                	addi	a4,a4,1
ffffffffc0203016:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc020301a:	00b78633          	add	a2,a5,a1
ffffffffc020301e:	fec764e3          	bltu	a4,a2,ffffffffc0203006 <pmm_init+0xca>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203022:	000b3503          	ld	a0,0(s6)
ffffffffc0203026:	00379693          	slli	a3,a5,0x3
ffffffffc020302a:	96be                	add	a3,a3,a5
ffffffffc020302c:	fdc00737          	lui	a4,0xfdc00
ffffffffc0203030:	972a                	add	a4,a4,a0
ffffffffc0203032:	068e                	slli	a3,a3,0x3
ffffffffc0203034:	96ba                	add	a3,a3,a4
ffffffffc0203036:	c0200737          	lui	a4,0xc0200
ffffffffc020303a:	64e6e463          	bltu	a3,a4,ffffffffc0203682 <pmm_init+0x746>
ffffffffc020303e:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc0203042:	4645                	li	a2,17
ffffffffc0203044:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203046:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0203048:	4ec6e263          	bltu	a3,a2,ffffffffc020352c <pmm_init+0x5f0>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020304c:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0203050:	0000e917          	auipc	s2,0xe
ffffffffc0203054:	50090913          	addi	s2,s2,1280 # ffffffffc0211550 <boot_pgdir>
    pmm_manager->check();
ffffffffc0203058:	7b9c                	ld	a5,48(a5)
ffffffffc020305a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020305c:	00003517          	auipc	a0,0x3
ffffffffc0203060:	afc50513          	addi	a0,a0,-1284 # ffffffffc0205b58 <default_pmm_manager+0x120>
ffffffffc0203064:	856fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0203068:	00006697          	auipc	a3,0x6
ffffffffc020306c:	f9868693          	addi	a3,a3,-104 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0203070:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203074:	c02007b7          	lui	a5,0xc0200
ffffffffc0203078:	62f6e163          	bltu	a3,a5,ffffffffc020369a <pmm_init+0x75e>
ffffffffc020307c:	0009b783          	ld	a5,0(s3)
ffffffffc0203080:	8e9d                	sub	a3,a3,a5
ffffffffc0203082:	0000e797          	auipc	a5,0xe
ffffffffc0203086:	4cd7b323          	sd	a3,1222(a5) # ffffffffc0211548 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020308a:	100027f3          	csrr	a5,sstatus
ffffffffc020308e:	8b89                	andi	a5,a5,2
ffffffffc0203090:	4c079763          	bnez	a5,ffffffffc020355e <pmm_init+0x622>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203094:	000bb783          	ld	a5,0(s7)
ffffffffc0203098:	779c                	ld	a5,40(a5)
ffffffffc020309a:	9782                	jalr	a5
ffffffffc020309c:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020309e:	6098                	ld	a4,0(s1)
ffffffffc02030a0:	c80007b7          	lui	a5,0xc8000
ffffffffc02030a4:	83b1                	srli	a5,a5,0xc
ffffffffc02030a6:	62e7e663          	bltu	a5,a4,ffffffffc02036d2 <pmm_init+0x796>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02030aa:	00093503          	ld	a0,0(s2)
ffffffffc02030ae:	60050263          	beqz	a0,ffffffffc02036b2 <pmm_init+0x776>
ffffffffc02030b2:	03451793          	slli	a5,a0,0x34
ffffffffc02030b6:	5e079e63          	bnez	a5,ffffffffc02036b2 <pmm_init+0x776>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02030ba:	4601                	li	a2,0
ffffffffc02030bc:	4581                	li	a1,0
ffffffffc02030be:	c8bff0ef          	jal	ra,ffffffffc0202d48 <get_page>
ffffffffc02030c2:	66051a63          	bnez	a0,ffffffffc0203736 <pmm_init+0x7fa>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02030c6:	4505                	li	a0,1
ffffffffc02030c8:	97fff0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc02030cc:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02030ce:	00093503          	ld	a0,0(s2)
ffffffffc02030d2:	4681                	li	a3,0
ffffffffc02030d4:	4601                	li	a2,0
ffffffffc02030d6:	85d2                	mv	a1,s4
ffffffffc02030d8:	d65ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc02030dc:	62051d63          	bnez	a0,ffffffffc0203716 <pmm_init+0x7da>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02030e0:	00093503          	ld	a0,0(s2)
ffffffffc02030e4:	4601                	li	a2,0
ffffffffc02030e6:	4581                	li	a1,0
ffffffffc02030e8:	a6bff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc02030ec:	60050563          	beqz	a0,ffffffffc02036f6 <pmm_init+0x7ba>
    assert(pte2page(*ptep) == p1);
ffffffffc02030f0:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02030f2:	0017f713          	andi	a4,a5,1
ffffffffc02030f6:	5e070e63          	beqz	a4,ffffffffc02036f2 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02030fa:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02030fc:	078a                	slli	a5,a5,0x2
ffffffffc02030fe:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203100:	56c7ff63          	bgeu	a5,a2,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203104:	fff80737          	lui	a4,0xfff80
ffffffffc0203108:	97ba                	add	a5,a5,a4
ffffffffc020310a:	000b3683          	ld	a3,0(s6)
ffffffffc020310e:	00379713          	slli	a4,a5,0x3
ffffffffc0203112:	97ba                	add	a5,a5,a4
ffffffffc0203114:	078e                	slli	a5,a5,0x3
ffffffffc0203116:	97b6                	add	a5,a5,a3
ffffffffc0203118:	14fa18e3          	bne	s4,a5,ffffffffc0203a68 <pmm_init+0xb2c>
    assert(page_ref(p1) == 1);
ffffffffc020311c:	000a2703          	lw	a4,0(s4)
ffffffffc0203120:	4785                	li	a5,1
ffffffffc0203122:	16f71fe3          	bne	a4,a5,ffffffffc0203aa0 <pmm_init+0xb64>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203126:	00093503          	ld	a0,0(s2)
ffffffffc020312a:	77fd                	lui	a5,0xfffff
ffffffffc020312c:	6114                	ld	a3,0(a0)
ffffffffc020312e:	068a                	slli	a3,a3,0x2
ffffffffc0203130:	8efd                	and	a3,a3,a5
ffffffffc0203132:	00c6d713          	srli	a4,a3,0xc
ffffffffc0203136:	14c779e3          	bgeu	a4,a2,ffffffffc0203a88 <pmm_init+0xb4c>
ffffffffc020313a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020313e:	96e2                	add	a3,a3,s8
ffffffffc0203140:	0006ba83          	ld	s5,0(a3)
ffffffffc0203144:	0a8a                	slli	s5,s5,0x2
ffffffffc0203146:	00fafab3          	and	s5,s5,a5
ffffffffc020314a:	00cad793          	srli	a5,s5,0xc
ffffffffc020314e:	66c7f463          	bgeu	a5,a2,ffffffffc02037b6 <pmm_init+0x87a>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203152:	4601                	li	a2,0
ffffffffc0203154:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203156:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203158:	9fbff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020315c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020315e:	63551c63          	bne	a0,s5,ffffffffc0203796 <pmm_init+0x85a>

    p2 = alloc_page();
ffffffffc0203162:	4505                	li	a0,1
ffffffffc0203164:	8e3ff0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0203168:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020316a:	00093503          	ld	a0,0(s2)
ffffffffc020316e:	46d1                	li	a3,20
ffffffffc0203170:	6605                	lui	a2,0x1
ffffffffc0203172:	85d6                	mv	a1,s5
ffffffffc0203174:	cc9ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc0203178:	5c051f63          	bnez	a0,ffffffffc0203756 <pmm_init+0x81a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020317c:	00093503          	ld	a0,0(s2)
ffffffffc0203180:	4601                	li	a2,0
ffffffffc0203182:	6585                	lui	a1,0x1
ffffffffc0203184:	9cfff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc0203188:	12050ce3          	beqz	a0,ffffffffc0203ac0 <pmm_init+0xb84>
    assert(*ptep & PTE_U);
ffffffffc020318c:	611c                	ld	a5,0(a0)
ffffffffc020318e:	0107f713          	andi	a4,a5,16
ffffffffc0203192:	72070f63          	beqz	a4,ffffffffc02038d0 <pmm_init+0x994>
    assert(*ptep & PTE_W);
ffffffffc0203196:	8b91                	andi	a5,a5,4
ffffffffc0203198:	6e078c63          	beqz	a5,ffffffffc0203890 <pmm_init+0x954>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020319c:	00093503          	ld	a0,0(s2)
ffffffffc02031a0:	611c                	ld	a5,0(a0)
ffffffffc02031a2:	8bc1                	andi	a5,a5,16
ffffffffc02031a4:	6c078663          	beqz	a5,ffffffffc0203870 <pmm_init+0x934>
    assert(page_ref(p2) == 1);
ffffffffc02031a8:	000aa703          	lw	a4,0(s5)
ffffffffc02031ac:	4785                	li	a5,1
ffffffffc02031ae:	5cf71463          	bne	a4,a5,ffffffffc0203776 <pmm_init+0x83a>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02031b2:	4681                	li	a3,0
ffffffffc02031b4:	6605                	lui	a2,0x1
ffffffffc02031b6:	85d2                	mv	a1,s4
ffffffffc02031b8:	c85ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc02031bc:	66051a63          	bnez	a0,ffffffffc0203830 <pmm_init+0x8f4>
    assert(page_ref(p1) == 2);
ffffffffc02031c0:	000a2703          	lw	a4,0(s4)
ffffffffc02031c4:	4789                	li	a5,2
ffffffffc02031c6:	64f71563          	bne	a4,a5,ffffffffc0203810 <pmm_init+0x8d4>
    assert(page_ref(p2) == 0);
ffffffffc02031ca:	000aa783          	lw	a5,0(s5)
ffffffffc02031ce:	62079163          	bnez	a5,ffffffffc02037f0 <pmm_init+0x8b4>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02031d2:	00093503          	ld	a0,0(s2)
ffffffffc02031d6:	4601                	li	a2,0
ffffffffc02031d8:	6585                	lui	a1,0x1
ffffffffc02031da:	979ff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc02031de:	5e050963          	beqz	a0,ffffffffc02037d0 <pmm_init+0x894>
    assert(pte2page(*ptep) == p1);
ffffffffc02031e2:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02031e4:	00177793          	andi	a5,a4,1
ffffffffc02031e8:	50078563          	beqz	a5,ffffffffc02036f2 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02031ec:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02031ee:	00271793          	slli	a5,a4,0x2
ffffffffc02031f2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02031f4:	48d7f563          	bgeu	a5,a3,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02031f8:	fff806b7          	lui	a3,0xfff80
ffffffffc02031fc:	97b6                	add	a5,a5,a3
ffffffffc02031fe:	000b3603          	ld	a2,0(s6)
ffffffffc0203202:	00379693          	slli	a3,a5,0x3
ffffffffc0203206:	97b6                	add	a5,a5,a3
ffffffffc0203208:	078e                	slli	a5,a5,0x3
ffffffffc020320a:	97b2                	add	a5,a5,a2
ffffffffc020320c:	72fa1263          	bne	s4,a5,ffffffffc0203930 <pmm_init+0x9f4>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203210:	8b41                	andi	a4,a4,16
ffffffffc0203212:	6e071f63          	bnez	a4,ffffffffc0203910 <pmm_init+0x9d4>

    page_remove(boot_pgdir, 0x0);
ffffffffc0203216:	00093503          	ld	a0,0(s2)
ffffffffc020321a:	4581                	li	a1,0
ffffffffc020321c:	b87ff0ef          	jal	ra,ffffffffc0202da2 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0203220:	000a2703          	lw	a4,0(s4)
ffffffffc0203224:	4785                	li	a5,1
ffffffffc0203226:	6cf71563          	bne	a4,a5,ffffffffc02038f0 <pmm_init+0x9b4>
    assert(page_ref(p2) == 0);
ffffffffc020322a:	000aa783          	lw	a5,0(s5)
ffffffffc020322e:	78079d63          	bnez	a5,ffffffffc02039c8 <pmm_init+0xa8c>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0203232:	00093503          	ld	a0,0(s2)
ffffffffc0203236:	6585                	lui	a1,0x1
ffffffffc0203238:	b6bff0ef          	jal	ra,ffffffffc0202da2 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc020323c:	000a2783          	lw	a5,0(s4)
ffffffffc0203240:	76079463          	bnez	a5,ffffffffc02039a8 <pmm_init+0xa6c>
    assert(page_ref(p2) == 0);
ffffffffc0203244:	000aa783          	lw	a5,0(s5)
ffffffffc0203248:	74079063          	bnez	a5,ffffffffc0203988 <pmm_init+0xa4c>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020324c:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203250:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203252:	000a3783          	ld	a5,0(s4)
ffffffffc0203256:	078a                	slli	a5,a5,0x2
ffffffffc0203258:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020325a:	42c7f263          	bgeu	a5,a2,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020325e:	fff80737          	lui	a4,0xfff80
ffffffffc0203262:	973e                	add	a4,a4,a5
ffffffffc0203264:	00371793          	slli	a5,a4,0x3
ffffffffc0203268:	000b3503          	ld	a0,0(s6)
ffffffffc020326c:	97ba                	add	a5,a5,a4
ffffffffc020326e:	078e                	slli	a5,a5,0x3
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0203270:	00f50733          	add	a4,a0,a5
ffffffffc0203274:	4314                	lw	a3,0(a4)
ffffffffc0203276:	4705                	li	a4,1
ffffffffc0203278:	6ee69863          	bne	a3,a4,ffffffffc0203968 <pmm_init+0xa2c>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020327c:	4037d693          	srai	a3,a5,0x3
ffffffffc0203280:	00003c97          	auipc	s9,0x3
ffffffffc0203284:	088cbc83          	ld	s9,136(s9) # ffffffffc0206308 <error_string+0x38>
ffffffffc0203288:	039686b3          	mul	a3,a3,s9
ffffffffc020328c:	000805b7          	lui	a1,0x80
ffffffffc0203290:	96ae                	add	a3,a3,a1
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203292:	00c69713          	slli	a4,a3,0xc
ffffffffc0203296:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203298:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020329a:	6ac77b63          	bgeu	a4,a2,ffffffffc0203950 <pmm_init+0xa14>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc020329e:	0009b703          	ld	a4,0(s3)
ffffffffc02032a2:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02032a4:	629c                	ld	a5,0(a3)
ffffffffc02032a6:	078a                	slli	a5,a5,0x2
ffffffffc02032a8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032aa:	3cc7fa63          	bgeu	a5,a2,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02032ae:	8f8d                	sub	a5,a5,a1
ffffffffc02032b0:	00379713          	slli	a4,a5,0x3
ffffffffc02032b4:	97ba                	add	a5,a5,a4
ffffffffc02032b6:	078e                	slli	a5,a5,0x3
ffffffffc02032b8:	953e                	add	a0,a0,a5
ffffffffc02032ba:	100027f3          	csrr	a5,sstatus
ffffffffc02032be:	8b89                	andi	a5,a5,2
ffffffffc02032c0:	2e079963          	bnez	a5,ffffffffc02035b2 <pmm_init+0x676>
    { pmm_manager->free_pages(base, n); }
ffffffffc02032c4:	000bb783          	ld	a5,0(s7)
ffffffffc02032c8:	4585                	li	a1,1
ffffffffc02032ca:	739c                	ld	a5,32(a5)
ffffffffc02032cc:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02032ce:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02032d2:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02032d4:	078a                	slli	a5,a5,0x2
ffffffffc02032d6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032d8:	3ae7f363          	bgeu	a5,a4,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02032dc:	fff80737          	lui	a4,0xfff80
ffffffffc02032e0:	97ba                	add	a5,a5,a4
ffffffffc02032e2:	000b3503          	ld	a0,0(s6)
ffffffffc02032e6:	00379713          	slli	a4,a5,0x3
ffffffffc02032ea:	97ba                	add	a5,a5,a4
ffffffffc02032ec:	078e                	slli	a5,a5,0x3
ffffffffc02032ee:	953e                	add	a0,a0,a5
ffffffffc02032f0:	100027f3          	csrr	a5,sstatus
ffffffffc02032f4:	8b89                	andi	a5,a5,2
ffffffffc02032f6:	2a079263          	bnez	a5,ffffffffc020359a <pmm_init+0x65e>
ffffffffc02032fa:	000bb783          	ld	a5,0(s7)
ffffffffc02032fe:	4585                	li	a1,1
ffffffffc0203300:	739c                	ld	a5,32(a5)
ffffffffc0203302:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0203304:	00093783          	ld	a5,0(s2)
ffffffffc0203308:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda88>
ffffffffc020330c:	100027f3          	csrr	a5,sstatus
ffffffffc0203310:	8b89                	andi	a5,a5,2
ffffffffc0203312:	26079a63          	bnez	a5,ffffffffc0203586 <pmm_init+0x64a>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203316:	000bb783          	ld	a5,0(s7)
ffffffffc020331a:	779c                	ld	a5,40(a5)
ffffffffc020331c:	9782                	jalr	a5
ffffffffc020331e:	8a2a                	mv	s4,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc0203320:	73441463          	bne	s0,s4,ffffffffc0203a48 <pmm_init+0xb0c>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0203324:	00003517          	auipc	a0,0x3
ffffffffc0203328:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0205e40 <default_pmm_manager+0x408>
ffffffffc020332c:	d8ffc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0203330:	100027f3          	csrr	a5,sstatus
ffffffffc0203334:	8b89                	andi	a5,a5,2
ffffffffc0203336:	22079e63          	bnez	a5,ffffffffc0203572 <pmm_init+0x636>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc020333a:	000bb783          	ld	a5,0(s7)
ffffffffc020333e:	779c                	ld	a5,40(a5)
ffffffffc0203340:	9782                	jalr	a5
ffffffffc0203342:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0203344:	6098                	ld	a4,0(s1)
ffffffffc0203346:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020334a:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020334c:	00c71793          	slli	a5,a4,0xc
ffffffffc0203350:	6a05                	lui	s4,0x1
ffffffffc0203352:	02f47c63          	bgeu	s0,a5,ffffffffc020338a <pmm_init+0x44e>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203356:	00c45793          	srli	a5,s0,0xc
ffffffffc020335a:	00093503          	ld	a0,0(s2)
ffffffffc020335e:	30e7f363          	bgeu	a5,a4,ffffffffc0203664 <pmm_init+0x728>
ffffffffc0203362:	0009b583          	ld	a1,0(s3)
ffffffffc0203366:	4601                	li	a2,0
ffffffffc0203368:	95a2                	add	a1,a1,s0
ffffffffc020336a:	fe8ff0ef          	jal	ra,ffffffffc0202b52 <get_pte>
ffffffffc020336e:	2c050b63          	beqz	a0,ffffffffc0203644 <pmm_init+0x708>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203372:	611c                	ld	a5,0(a0)
ffffffffc0203374:	078a                	slli	a5,a5,0x2
ffffffffc0203376:	0157f7b3          	and	a5,a5,s5
ffffffffc020337a:	2a879563          	bne	a5,s0,ffffffffc0203624 <pmm_init+0x6e8>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020337e:	6098                	ld	a4,0(s1)
ffffffffc0203380:	9452                	add	s0,s0,s4
ffffffffc0203382:	00c71793          	slli	a5,a4,0xc
ffffffffc0203386:	fcf468e3          	bltu	s0,a5,ffffffffc0203356 <pmm_init+0x41a>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc020338a:	00093783          	ld	a5,0(s2)
ffffffffc020338e:	639c                	ld	a5,0(a5)
ffffffffc0203390:	68079c63          	bnez	a5,ffffffffc0203a28 <pmm_init+0xaec>

    struct Page *p;
    p = alloc_page();
ffffffffc0203394:	4505                	li	a0,1
ffffffffc0203396:	eb0ff0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc020339a:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020339c:	00093503          	ld	a0,0(s2)
ffffffffc02033a0:	4699                	li	a3,6
ffffffffc02033a2:	10000613          	li	a2,256
ffffffffc02033a6:	85d6                	mv	a1,s5
ffffffffc02033a8:	a95ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc02033ac:	64051e63          	bnez	a0,ffffffffc0203a08 <pmm_init+0xacc>
    assert(page_ref(p) == 1);
ffffffffc02033b0:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda88>
ffffffffc02033b4:	4785                	li	a5,1
ffffffffc02033b6:	62f71963          	bne	a4,a5,ffffffffc02039e8 <pmm_init+0xaac>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02033ba:	00093503          	ld	a0,0(s2)
ffffffffc02033be:	6405                	lui	s0,0x1
ffffffffc02033c0:	4699                	li	a3,6
ffffffffc02033c2:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02033c6:	85d6                	mv	a1,s5
ffffffffc02033c8:	a75ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc02033cc:	48051263          	bnez	a0,ffffffffc0203850 <pmm_init+0x914>
    assert(page_ref(p) == 2);
ffffffffc02033d0:	000aa703          	lw	a4,0(s5)
ffffffffc02033d4:	4789                	li	a5,2
ffffffffc02033d6:	74f71563          	bne	a4,a5,ffffffffc0203b20 <pmm_init+0xbe4>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02033da:	00003597          	auipc	a1,0x3
ffffffffc02033de:	b9e58593          	addi	a1,a1,-1122 # ffffffffc0205f78 <default_pmm_manager+0x540>
ffffffffc02033e2:	10000513          	li	a0,256
ffffffffc02033e6:	35d000ef          	jal	ra,ffffffffc0203f42 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02033ea:	10040593          	addi	a1,s0,256
ffffffffc02033ee:	10000513          	li	a0,256
ffffffffc02033f2:	363000ef          	jal	ra,ffffffffc0203f54 <strcmp>
ffffffffc02033f6:	70051563          	bnez	a0,ffffffffc0203b00 <pmm_init+0xbc4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02033fa:	000b3683          	ld	a3,0(s6)
ffffffffc02033fe:	00080d37          	lui	s10,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203402:	547d                	li	s0,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203404:	40da86b3          	sub	a3,s5,a3
ffffffffc0203408:	868d                	srai	a3,a3,0x3
ffffffffc020340a:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020340e:	609c                	ld	a5,0(s1)
ffffffffc0203410:	8031                	srli	s0,s0,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203412:	96ea                	add	a3,a3,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203414:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203418:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020341a:	52f77b63          	bgeu	a4,a5,ffffffffc0203950 <pmm_init+0xa14>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020341e:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203422:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203426:	96be                	add	a3,a3,a5
ffffffffc0203428:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb88>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020342c:	2e1000ef          	jal	ra,ffffffffc0203f0c <strlen>
ffffffffc0203430:	6a051863          	bnez	a0,ffffffffc0203ae0 <pmm_init+0xba4>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0203434:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203438:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020343a:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020343e:	078a                	slli	a5,a5,0x2
ffffffffc0203440:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203442:	22e7fe63          	bgeu	a5,a4,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203446:	41a787b3          	sub	a5,a5,s10
ffffffffc020344a:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020344e:	96be                	add	a3,a3,a5
ffffffffc0203450:	03968cb3          	mul	s9,a3,s9
ffffffffc0203454:	01ac86b3          	add	a3,s9,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203458:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020345a:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020345c:	4ee47a63          	bgeu	s0,a4,ffffffffc0203950 <pmm_init+0xa14>
ffffffffc0203460:	0009b403          	ld	s0,0(s3)
ffffffffc0203464:	9436                	add	s0,s0,a3
ffffffffc0203466:	100027f3          	csrr	a5,sstatus
ffffffffc020346a:	8b89                	andi	a5,a5,2
ffffffffc020346c:	1a079163          	bnez	a5,ffffffffc020360e <pmm_init+0x6d2>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203470:	000bb783          	ld	a5,0(s7)
ffffffffc0203474:	4585                	li	a1,1
ffffffffc0203476:	8556                	mv	a0,s5
ffffffffc0203478:	739c                	ld	a5,32(a5)
ffffffffc020347a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020347c:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc020347e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203480:	078a                	slli	a5,a5,0x2
ffffffffc0203482:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203484:	1ee7fd63          	bgeu	a5,a4,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203488:	fff80737          	lui	a4,0xfff80
ffffffffc020348c:	97ba                	add	a5,a5,a4
ffffffffc020348e:	000b3503          	ld	a0,0(s6)
ffffffffc0203492:	00379713          	slli	a4,a5,0x3
ffffffffc0203496:	97ba                	add	a5,a5,a4
ffffffffc0203498:	078e                	slli	a5,a5,0x3
ffffffffc020349a:	953e                	add	a0,a0,a5
ffffffffc020349c:	100027f3          	csrr	a5,sstatus
ffffffffc02034a0:	8b89                	andi	a5,a5,2
ffffffffc02034a2:	14079a63          	bnez	a5,ffffffffc02035f6 <pmm_init+0x6ba>
ffffffffc02034a6:	000bb783          	ld	a5,0(s7)
ffffffffc02034aa:	4585                	li	a1,1
ffffffffc02034ac:	739c                	ld	a5,32(a5)
ffffffffc02034ae:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02034b0:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02034b4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02034b6:	078a                	slli	a5,a5,0x2
ffffffffc02034b8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02034ba:	1ce7f263          	bgeu	a5,a4,ffffffffc020367e <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02034be:	fff80737          	lui	a4,0xfff80
ffffffffc02034c2:	97ba                	add	a5,a5,a4
ffffffffc02034c4:	000b3503          	ld	a0,0(s6)
ffffffffc02034c8:	00379713          	slli	a4,a5,0x3
ffffffffc02034cc:	97ba                	add	a5,a5,a4
ffffffffc02034ce:	078e                	slli	a5,a5,0x3
ffffffffc02034d0:	953e                	add	a0,a0,a5
ffffffffc02034d2:	100027f3          	csrr	a5,sstatus
ffffffffc02034d6:	8b89                	andi	a5,a5,2
ffffffffc02034d8:	10079363          	bnez	a5,ffffffffc02035de <pmm_init+0x6a2>
ffffffffc02034dc:	000bb783          	ld	a5,0(s7)
ffffffffc02034e0:	4585                	li	a1,1
ffffffffc02034e2:	739c                	ld	a5,32(a5)
ffffffffc02034e4:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02034e6:	00093783          	ld	a5,0(s2)
ffffffffc02034ea:	0007b023          	sd	zero,0(a5)
ffffffffc02034ee:	100027f3          	csrr	a5,sstatus
ffffffffc02034f2:	8b89                	andi	a5,a5,2
ffffffffc02034f4:	0c079b63          	bnez	a5,ffffffffc02035ca <pmm_init+0x68e>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02034f8:	000bb783          	ld	a5,0(s7)
ffffffffc02034fc:	779c                	ld	a5,40(a5)
ffffffffc02034fe:	9782                	jalr	a5
ffffffffc0203500:	842a                	mv	s0,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc0203502:	3a8c1763          	bne	s8,s0,ffffffffc02038b0 <pmm_init+0x974>
}
ffffffffc0203506:	7406                	ld	s0,96(sp)
ffffffffc0203508:	70a6                	ld	ra,104(sp)
ffffffffc020350a:	64e6                	ld	s1,88(sp)
ffffffffc020350c:	6946                	ld	s2,80(sp)
ffffffffc020350e:	69a6                	ld	s3,72(sp)
ffffffffc0203510:	6a06                	ld	s4,64(sp)
ffffffffc0203512:	7ae2                	ld	s5,56(sp)
ffffffffc0203514:	7b42                	ld	s6,48(sp)
ffffffffc0203516:	7ba2                	ld	s7,40(sp)
ffffffffc0203518:	7c02                	ld	s8,32(sp)
ffffffffc020351a:	6ce2                	ld	s9,24(sp)
ffffffffc020351c:	6d42                	ld	s10,16(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc020351e:	00003517          	auipc	a0,0x3
ffffffffc0203522:	ad250513          	addi	a0,a0,-1326 # ffffffffc0205ff0 <default_pmm_manager+0x5b8>
}
ffffffffc0203526:	6165                	addi	sp,sp,112
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0203528:	b93fc06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020352c:	6705                	lui	a4,0x1
ffffffffc020352e:	177d                	addi	a4,a4,-1
ffffffffc0203530:	96ba                	add	a3,a3,a4
ffffffffc0203532:	777d                	lui	a4,0xfffff
ffffffffc0203534:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc0203536:	00c75693          	srli	a3,a4,0xc
ffffffffc020353a:	14f6f263          	bgeu	a3,a5,ffffffffc020367e <pmm_init+0x742>
    pmm_manager->init_memmap(base, n);
ffffffffc020353e:	000bb803          	ld	a6,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0203542:	95b6                	add	a1,a1,a3
ffffffffc0203544:	00359793          	slli	a5,a1,0x3
ffffffffc0203548:	97ae                	add	a5,a5,a1
ffffffffc020354a:	01083683          	ld	a3,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020354e:	40e60733          	sub	a4,a2,a4
ffffffffc0203552:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0203554:	00c75593          	srli	a1,a4,0xc
ffffffffc0203558:	953e                	add	a0,a0,a5
ffffffffc020355a:	9682                	jalr	a3
}
ffffffffc020355c:	bcc5                	j	ffffffffc020304c <pmm_init+0x110>
        intr_disable();
ffffffffc020355e:	f91fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203562:	000bb783          	ld	a5,0(s7)
ffffffffc0203566:	779c                	ld	a5,40(a5)
ffffffffc0203568:	9782                	jalr	a5
ffffffffc020356a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020356c:	f7dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203570:	b63d                	j	ffffffffc020309e <pmm_init+0x162>
        intr_disable();
ffffffffc0203572:	f7dfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203576:	000bb783          	ld	a5,0(s7)
ffffffffc020357a:	779c                	ld	a5,40(a5)
ffffffffc020357c:	9782                	jalr	a5
ffffffffc020357e:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203580:	f69fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203584:	b3c1                	j	ffffffffc0203344 <pmm_init+0x408>
        intr_disable();
ffffffffc0203586:	f69fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020358a:	000bb783          	ld	a5,0(s7)
ffffffffc020358e:	779c                	ld	a5,40(a5)
ffffffffc0203590:	9782                	jalr	a5
ffffffffc0203592:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203594:	f55fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203598:	b361                	j	ffffffffc0203320 <pmm_init+0x3e4>
ffffffffc020359a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020359c:	f53fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc02035a0:	000bb783          	ld	a5,0(s7)
ffffffffc02035a4:	6522                	ld	a0,8(sp)
ffffffffc02035a6:	4585                	li	a1,1
ffffffffc02035a8:	739c                	ld	a5,32(a5)
ffffffffc02035aa:	9782                	jalr	a5
        intr_enable();
ffffffffc02035ac:	f3dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035b0:	bb91                	j	ffffffffc0203304 <pmm_init+0x3c8>
ffffffffc02035b2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035b4:	f3bfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02035b8:	000bb783          	ld	a5,0(s7)
ffffffffc02035bc:	6522                	ld	a0,8(sp)
ffffffffc02035be:	4585                	li	a1,1
ffffffffc02035c0:	739c                	ld	a5,32(a5)
ffffffffc02035c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02035c4:	f25fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035c8:	b319                	j	ffffffffc02032ce <pmm_init+0x392>
        intr_disable();
ffffffffc02035ca:	f25fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02035ce:	000bb783          	ld	a5,0(s7)
ffffffffc02035d2:	779c                	ld	a5,40(a5)
ffffffffc02035d4:	9782                	jalr	a5
ffffffffc02035d6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02035d8:	f11fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035dc:	b71d                	j	ffffffffc0203502 <pmm_init+0x5c6>
ffffffffc02035de:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035e0:	f0ffc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc02035e4:	000bb783          	ld	a5,0(s7)
ffffffffc02035e8:	6522                	ld	a0,8(sp)
ffffffffc02035ea:	4585                	li	a1,1
ffffffffc02035ec:	739c                	ld	a5,32(a5)
ffffffffc02035ee:	9782                	jalr	a5
        intr_enable();
ffffffffc02035f0:	ef9fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035f4:	bdcd                	j	ffffffffc02034e6 <pmm_init+0x5aa>
ffffffffc02035f6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035f8:	ef7fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02035fc:	000bb783          	ld	a5,0(s7)
ffffffffc0203600:	6522                	ld	a0,8(sp)
ffffffffc0203602:	4585                	li	a1,1
ffffffffc0203604:	739c                	ld	a5,32(a5)
ffffffffc0203606:	9782                	jalr	a5
        intr_enable();
ffffffffc0203608:	ee1fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020360c:	b555                	j	ffffffffc02034b0 <pmm_init+0x574>
        intr_disable();
ffffffffc020360e:	ee1fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203612:	000bb783          	ld	a5,0(s7)
ffffffffc0203616:	4585                	li	a1,1
ffffffffc0203618:	8556                	mv	a0,s5
ffffffffc020361a:	739c                	ld	a5,32(a5)
ffffffffc020361c:	9782                	jalr	a5
        intr_enable();
ffffffffc020361e:	ecbfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203622:	bda9                	j	ffffffffc020347c <pmm_init+0x540>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203624:	00003697          	auipc	a3,0x3
ffffffffc0203628:	87c68693          	addi	a3,a3,-1924 # ffffffffc0205ea0 <default_pmm_manager+0x468>
ffffffffc020362c:	00002617          	auipc	a2,0x2
ffffffffc0203630:	81460613          	addi	a2,a2,-2028 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203634:	1d400593          	li	a1,468
ffffffffc0203638:	00002517          	auipc	a0,0x2
ffffffffc020363c:	46050513          	addi	a0,a0,1120 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203640:	ac3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203644:	00003697          	auipc	a3,0x3
ffffffffc0203648:	81c68693          	addi	a3,a3,-2020 # ffffffffc0205e60 <default_pmm_manager+0x428>
ffffffffc020364c:	00001617          	auipc	a2,0x1
ffffffffc0203650:	7f460613          	addi	a2,a2,2036 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203654:	1d300593          	li	a1,467
ffffffffc0203658:	00002517          	auipc	a0,0x2
ffffffffc020365c:	44050513          	addi	a0,a0,1088 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203660:	aa3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203664:	86a2                	mv	a3,s0
ffffffffc0203666:	00002617          	auipc	a2,0x2
ffffffffc020366a:	40a60613          	addi	a2,a2,1034 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc020366e:	1d300593          	li	a1,467
ffffffffc0203672:	00002517          	auipc	a0,0x2
ffffffffc0203676:	42650513          	addi	a0,a0,1062 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020367a:	a89fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc020367e:	b90ff0ef          	jal	ra,ffffffffc0202a0e <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203682:	00002617          	auipc	a2,0x2
ffffffffc0203686:	4ae60613          	addi	a2,a2,1198 # ffffffffc0205b30 <default_pmm_manager+0xf8>
ffffffffc020368a:	07700593          	li	a1,119
ffffffffc020368e:	00002517          	auipc	a0,0x2
ffffffffc0203692:	40a50513          	addi	a0,a0,1034 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203696:	a6dfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc020369a:	00002617          	auipc	a2,0x2
ffffffffc020369e:	49660613          	addi	a2,a2,1174 # ffffffffc0205b30 <default_pmm_manager+0xf8>
ffffffffc02036a2:	0bd00593          	li	a1,189
ffffffffc02036a6:	00002517          	auipc	a0,0x2
ffffffffc02036aa:	3f250513          	addi	a0,a0,1010 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02036ae:	a55fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02036b2:	00002697          	auipc	a3,0x2
ffffffffc02036b6:	4e668693          	addi	a3,a3,1254 # ffffffffc0205b98 <default_pmm_manager+0x160>
ffffffffc02036ba:	00001617          	auipc	a2,0x1
ffffffffc02036be:	78660613          	addi	a2,a2,1926 # ffffffffc0204e40 <commands+0x770>
ffffffffc02036c2:	19900593          	li	a1,409
ffffffffc02036c6:	00002517          	auipc	a0,0x2
ffffffffc02036ca:	3d250513          	addi	a0,a0,978 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02036ce:	a35fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02036d2:	00002697          	auipc	a3,0x2
ffffffffc02036d6:	4a668693          	addi	a3,a3,1190 # ffffffffc0205b78 <default_pmm_manager+0x140>
ffffffffc02036da:	00001617          	auipc	a2,0x1
ffffffffc02036de:	76660613          	addi	a2,a2,1894 # ffffffffc0204e40 <commands+0x770>
ffffffffc02036e2:	19800593          	li	a1,408
ffffffffc02036e6:	00002517          	auipc	a0,0x2
ffffffffc02036ea:	3b250513          	addi	a0,a0,946 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02036ee:	a15fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc02036f2:	b38ff0ef          	jal	ra,ffffffffc0202a2a <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02036f6:	00002697          	auipc	a3,0x2
ffffffffc02036fa:	53268693          	addi	a3,a3,1330 # ffffffffc0205c28 <default_pmm_manager+0x1f0>
ffffffffc02036fe:	00001617          	auipc	a2,0x1
ffffffffc0203702:	74260613          	addi	a2,a2,1858 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203706:	1a000593          	li	a1,416
ffffffffc020370a:	00002517          	auipc	a0,0x2
ffffffffc020370e:	38e50513          	addi	a0,a0,910 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203712:	9f1fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0203716:	00002697          	auipc	a3,0x2
ffffffffc020371a:	4e268693          	addi	a3,a3,1250 # ffffffffc0205bf8 <default_pmm_manager+0x1c0>
ffffffffc020371e:	00001617          	auipc	a2,0x1
ffffffffc0203722:	72260613          	addi	a2,a2,1826 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203726:	19e00593          	li	a1,414
ffffffffc020372a:	00002517          	auipc	a0,0x2
ffffffffc020372e:	36e50513          	addi	a0,a0,878 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203732:	9d1fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0203736:	00002697          	auipc	a3,0x2
ffffffffc020373a:	49a68693          	addi	a3,a3,1178 # ffffffffc0205bd0 <default_pmm_manager+0x198>
ffffffffc020373e:	00001617          	auipc	a2,0x1
ffffffffc0203742:	70260613          	addi	a2,a2,1794 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203746:	19a00593          	li	a1,410
ffffffffc020374a:	00002517          	auipc	a0,0x2
ffffffffc020374e:	34e50513          	addi	a0,a0,846 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203752:	9b1fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203756:	00002697          	auipc	a3,0x2
ffffffffc020375a:	55a68693          	addi	a3,a3,1370 # ffffffffc0205cb0 <default_pmm_manager+0x278>
ffffffffc020375e:	00001617          	auipc	a2,0x1
ffffffffc0203762:	6e260613          	addi	a2,a2,1762 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203766:	1a900593          	li	a1,425
ffffffffc020376a:	00002517          	auipc	a0,0x2
ffffffffc020376e:	32e50513          	addi	a0,a0,814 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203772:	991fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203776:	00002697          	auipc	a3,0x2
ffffffffc020377a:	5da68693          	addi	a3,a3,1498 # ffffffffc0205d50 <default_pmm_manager+0x318>
ffffffffc020377e:	00001617          	auipc	a2,0x1
ffffffffc0203782:	6c260613          	addi	a2,a2,1730 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203786:	1ae00593          	li	a1,430
ffffffffc020378a:	00002517          	auipc	a0,0x2
ffffffffc020378e:	30e50513          	addi	a0,a0,782 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203792:	971fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203796:	00002697          	auipc	a3,0x2
ffffffffc020379a:	4f268693          	addi	a3,a3,1266 # ffffffffc0205c88 <default_pmm_manager+0x250>
ffffffffc020379e:	00001617          	auipc	a2,0x1
ffffffffc02037a2:	6a260613          	addi	a2,a2,1698 # ffffffffc0204e40 <commands+0x770>
ffffffffc02037a6:	1a600593          	li	a1,422
ffffffffc02037aa:	00002517          	auipc	a0,0x2
ffffffffc02037ae:	2ee50513          	addi	a0,a0,750 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02037b2:	951fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02037b6:	86d6                	mv	a3,s5
ffffffffc02037b8:	00002617          	auipc	a2,0x2
ffffffffc02037bc:	2b860613          	addi	a2,a2,696 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc02037c0:	1a500593          	li	a1,421
ffffffffc02037c4:	00002517          	auipc	a0,0x2
ffffffffc02037c8:	2d450513          	addi	a0,a0,724 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02037cc:	937fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02037d0:	00002697          	auipc	a3,0x2
ffffffffc02037d4:	51868693          	addi	a3,a3,1304 # ffffffffc0205ce8 <default_pmm_manager+0x2b0>
ffffffffc02037d8:	00001617          	auipc	a2,0x1
ffffffffc02037dc:	66860613          	addi	a2,a2,1640 # ffffffffc0204e40 <commands+0x770>
ffffffffc02037e0:	1b300593          	li	a1,435
ffffffffc02037e4:	00002517          	auipc	a0,0x2
ffffffffc02037e8:	2b450513          	addi	a0,a0,692 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02037ec:	917fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02037f0:	00002697          	auipc	a3,0x2
ffffffffc02037f4:	5c068693          	addi	a3,a3,1472 # ffffffffc0205db0 <default_pmm_manager+0x378>
ffffffffc02037f8:	00001617          	auipc	a2,0x1
ffffffffc02037fc:	64860613          	addi	a2,a2,1608 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203800:	1b200593          	li	a1,434
ffffffffc0203804:	00002517          	auipc	a0,0x2
ffffffffc0203808:	29450513          	addi	a0,a0,660 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020380c:	8f7fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203810:	00002697          	auipc	a3,0x2
ffffffffc0203814:	58868693          	addi	a3,a3,1416 # ffffffffc0205d98 <default_pmm_manager+0x360>
ffffffffc0203818:	00001617          	auipc	a2,0x1
ffffffffc020381c:	62860613          	addi	a2,a2,1576 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203820:	1b100593          	li	a1,433
ffffffffc0203824:	00002517          	auipc	a0,0x2
ffffffffc0203828:	27450513          	addi	a0,a0,628 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020382c:	8d7fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0203830:	00002697          	auipc	a3,0x2
ffffffffc0203834:	53868693          	addi	a3,a3,1336 # ffffffffc0205d68 <default_pmm_manager+0x330>
ffffffffc0203838:	00001617          	auipc	a2,0x1
ffffffffc020383c:	60860613          	addi	a2,a2,1544 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203840:	1b000593          	li	a1,432
ffffffffc0203844:	00002517          	auipc	a0,0x2
ffffffffc0203848:	25450513          	addi	a0,a0,596 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020384c:	8b7fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203850:	00002697          	auipc	a3,0x2
ffffffffc0203854:	6d068693          	addi	a3,a3,1744 # ffffffffc0205f20 <default_pmm_manager+0x4e8>
ffffffffc0203858:	00001617          	auipc	a2,0x1
ffffffffc020385c:	5e860613          	addi	a2,a2,1512 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203860:	1de00593          	li	a1,478
ffffffffc0203864:	00002517          	auipc	a0,0x2
ffffffffc0203868:	23450513          	addi	a0,a0,564 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020386c:	897fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0203870:	00002697          	auipc	a3,0x2
ffffffffc0203874:	4c868693          	addi	a3,a3,1224 # ffffffffc0205d38 <default_pmm_manager+0x300>
ffffffffc0203878:	00001617          	auipc	a2,0x1
ffffffffc020387c:	5c860613          	addi	a2,a2,1480 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203880:	1ad00593          	li	a1,429
ffffffffc0203884:	00002517          	auipc	a0,0x2
ffffffffc0203888:	21450513          	addi	a0,a0,532 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020388c:	877fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203890:	00002697          	auipc	a3,0x2
ffffffffc0203894:	49868693          	addi	a3,a3,1176 # ffffffffc0205d28 <default_pmm_manager+0x2f0>
ffffffffc0203898:	00001617          	auipc	a2,0x1
ffffffffc020389c:	5a860613          	addi	a2,a2,1448 # ffffffffc0204e40 <commands+0x770>
ffffffffc02038a0:	1ac00593          	li	a1,428
ffffffffc02038a4:	00002517          	auipc	a0,0x2
ffffffffc02038a8:	1f450513          	addi	a0,a0,500 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02038ac:	857fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc02038b0:	00002697          	auipc	a3,0x2
ffffffffc02038b4:	57068693          	addi	a3,a3,1392 # ffffffffc0205e20 <default_pmm_manager+0x3e8>
ffffffffc02038b8:	00001617          	auipc	a2,0x1
ffffffffc02038bc:	58860613          	addi	a2,a2,1416 # ffffffffc0204e40 <commands+0x770>
ffffffffc02038c0:	1ee00593          	li	a1,494
ffffffffc02038c4:	00002517          	auipc	a0,0x2
ffffffffc02038c8:	1d450513          	addi	a0,a0,468 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02038cc:	837fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02038d0:	00002697          	auipc	a3,0x2
ffffffffc02038d4:	44868693          	addi	a3,a3,1096 # ffffffffc0205d18 <default_pmm_manager+0x2e0>
ffffffffc02038d8:	00001617          	auipc	a2,0x1
ffffffffc02038dc:	56860613          	addi	a2,a2,1384 # ffffffffc0204e40 <commands+0x770>
ffffffffc02038e0:	1ab00593          	li	a1,427
ffffffffc02038e4:	00002517          	auipc	a0,0x2
ffffffffc02038e8:	1b450513          	addi	a0,a0,436 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02038ec:	817fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02038f0:	00002697          	auipc	a3,0x2
ffffffffc02038f4:	38068693          	addi	a3,a3,896 # ffffffffc0205c70 <default_pmm_manager+0x238>
ffffffffc02038f8:	00001617          	auipc	a2,0x1
ffffffffc02038fc:	54860613          	addi	a2,a2,1352 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203900:	1b800593          	li	a1,440
ffffffffc0203904:	00002517          	auipc	a0,0x2
ffffffffc0203908:	19450513          	addi	a0,a0,404 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020390c:	ff6fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203910:	00002697          	auipc	a3,0x2
ffffffffc0203914:	4b868693          	addi	a3,a3,1208 # ffffffffc0205dc8 <default_pmm_manager+0x390>
ffffffffc0203918:	00001617          	auipc	a2,0x1
ffffffffc020391c:	52860613          	addi	a2,a2,1320 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203920:	1b500593          	li	a1,437
ffffffffc0203924:	00002517          	auipc	a0,0x2
ffffffffc0203928:	17450513          	addi	a0,a0,372 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020392c:	fd6fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203930:	00002697          	auipc	a3,0x2
ffffffffc0203934:	32868693          	addi	a3,a3,808 # ffffffffc0205c58 <default_pmm_manager+0x220>
ffffffffc0203938:	00001617          	auipc	a2,0x1
ffffffffc020393c:	50860613          	addi	a2,a2,1288 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203940:	1b400593          	li	a1,436
ffffffffc0203944:	00002517          	auipc	a0,0x2
ffffffffc0203948:	15450513          	addi	a0,a0,340 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc020394c:	fb6fc0ef          	jal	ra,ffffffffc0200102 <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203950:	00002617          	auipc	a2,0x2
ffffffffc0203954:	12060613          	addi	a2,a2,288 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0203958:	06a00593          	li	a1,106
ffffffffc020395c:	00001517          	auipc	a0,0x1
ffffffffc0203960:	75450513          	addi	a0,a0,1876 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0203964:	f9efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0203968:	00002697          	auipc	a3,0x2
ffffffffc020396c:	49068693          	addi	a3,a3,1168 # ffffffffc0205df8 <default_pmm_manager+0x3c0>
ffffffffc0203970:	00001617          	auipc	a2,0x1
ffffffffc0203974:	4d060613          	addi	a2,a2,1232 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203978:	1bf00593          	li	a1,447
ffffffffc020397c:	00002517          	auipc	a0,0x2
ffffffffc0203980:	11c50513          	addi	a0,a0,284 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203984:	f7efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203988:	00002697          	auipc	a3,0x2
ffffffffc020398c:	42868693          	addi	a3,a3,1064 # ffffffffc0205db0 <default_pmm_manager+0x378>
ffffffffc0203990:	00001617          	auipc	a2,0x1
ffffffffc0203994:	4b060613          	addi	a2,a2,1200 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203998:	1bd00593          	li	a1,445
ffffffffc020399c:	00002517          	auipc	a0,0x2
ffffffffc02039a0:	0fc50513          	addi	a0,a0,252 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02039a4:	f5efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02039a8:	00002697          	auipc	a3,0x2
ffffffffc02039ac:	43868693          	addi	a3,a3,1080 # ffffffffc0205de0 <default_pmm_manager+0x3a8>
ffffffffc02039b0:	00001617          	auipc	a2,0x1
ffffffffc02039b4:	49060613          	addi	a2,a2,1168 # ffffffffc0204e40 <commands+0x770>
ffffffffc02039b8:	1bc00593          	li	a1,444
ffffffffc02039bc:	00002517          	auipc	a0,0x2
ffffffffc02039c0:	0dc50513          	addi	a0,a0,220 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02039c4:	f3efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02039c8:	00002697          	auipc	a3,0x2
ffffffffc02039cc:	3e868693          	addi	a3,a3,1000 # ffffffffc0205db0 <default_pmm_manager+0x378>
ffffffffc02039d0:	00001617          	auipc	a2,0x1
ffffffffc02039d4:	47060613          	addi	a2,a2,1136 # ffffffffc0204e40 <commands+0x770>
ffffffffc02039d8:	1b900593          	li	a1,441
ffffffffc02039dc:	00002517          	auipc	a0,0x2
ffffffffc02039e0:	0bc50513          	addi	a0,a0,188 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc02039e4:	f1efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02039e8:	00002697          	auipc	a3,0x2
ffffffffc02039ec:	52068693          	addi	a3,a3,1312 # ffffffffc0205f08 <default_pmm_manager+0x4d0>
ffffffffc02039f0:	00001617          	auipc	a2,0x1
ffffffffc02039f4:	45060613          	addi	a2,a2,1104 # ffffffffc0204e40 <commands+0x770>
ffffffffc02039f8:	1dd00593          	li	a1,477
ffffffffc02039fc:	00002517          	auipc	a0,0x2
ffffffffc0203a00:	09c50513          	addi	a0,a0,156 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a04:	efefc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203a08:	00002697          	auipc	a3,0x2
ffffffffc0203a0c:	4c868693          	addi	a3,a3,1224 # ffffffffc0205ed0 <default_pmm_manager+0x498>
ffffffffc0203a10:	00001617          	auipc	a2,0x1
ffffffffc0203a14:	43060613          	addi	a2,a2,1072 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203a18:	1dc00593          	li	a1,476
ffffffffc0203a1c:	00002517          	auipc	a0,0x2
ffffffffc0203a20:	07c50513          	addi	a0,a0,124 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a24:	edefc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0203a28:	00002697          	auipc	a3,0x2
ffffffffc0203a2c:	49068693          	addi	a3,a3,1168 # ffffffffc0205eb8 <default_pmm_manager+0x480>
ffffffffc0203a30:	00001617          	auipc	a2,0x1
ffffffffc0203a34:	41060613          	addi	a2,a2,1040 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203a38:	1d800593          	li	a1,472
ffffffffc0203a3c:	00002517          	auipc	a0,0x2
ffffffffc0203a40:	05c50513          	addi	a0,a0,92 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a44:	ebefc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203a48:	00002697          	auipc	a3,0x2
ffffffffc0203a4c:	3d868693          	addi	a3,a3,984 # ffffffffc0205e20 <default_pmm_manager+0x3e8>
ffffffffc0203a50:	00001617          	auipc	a2,0x1
ffffffffc0203a54:	3f060613          	addi	a2,a2,1008 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203a58:	1c600593          	li	a1,454
ffffffffc0203a5c:	00002517          	auipc	a0,0x2
ffffffffc0203a60:	03c50513          	addi	a0,a0,60 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a64:	e9efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203a68:	00002697          	auipc	a3,0x2
ffffffffc0203a6c:	1f068693          	addi	a3,a3,496 # ffffffffc0205c58 <default_pmm_manager+0x220>
ffffffffc0203a70:	00001617          	auipc	a2,0x1
ffffffffc0203a74:	3d060613          	addi	a2,a2,976 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203a78:	1a100593          	li	a1,417
ffffffffc0203a7c:	00002517          	auipc	a0,0x2
ffffffffc0203a80:	01c50513          	addi	a0,a0,28 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a84:	e7efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203a88:	00002617          	auipc	a2,0x2
ffffffffc0203a8c:	fe860613          	addi	a2,a2,-24 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0203a90:	1a400593          	li	a1,420
ffffffffc0203a94:	00002517          	auipc	a0,0x2
ffffffffc0203a98:	00450513          	addi	a0,a0,4 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203a9c:	e66fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203aa0:	00002697          	auipc	a3,0x2
ffffffffc0203aa4:	1d068693          	addi	a3,a3,464 # ffffffffc0205c70 <default_pmm_manager+0x238>
ffffffffc0203aa8:	00001617          	auipc	a2,0x1
ffffffffc0203aac:	39860613          	addi	a2,a2,920 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203ab0:	1a200593          	li	a1,418
ffffffffc0203ab4:	00002517          	auipc	a0,0x2
ffffffffc0203ab8:	fe450513          	addi	a0,a0,-28 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203abc:	e46fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203ac0:	00002697          	auipc	a3,0x2
ffffffffc0203ac4:	22868693          	addi	a3,a3,552 # ffffffffc0205ce8 <default_pmm_manager+0x2b0>
ffffffffc0203ac8:	00001617          	auipc	a2,0x1
ffffffffc0203acc:	37860613          	addi	a2,a2,888 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203ad0:	1aa00593          	li	a1,426
ffffffffc0203ad4:	00002517          	auipc	a0,0x2
ffffffffc0203ad8:	fc450513          	addi	a0,a0,-60 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203adc:	e26fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203ae0:	00002697          	auipc	a3,0x2
ffffffffc0203ae4:	4e868693          	addi	a3,a3,1256 # ffffffffc0205fc8 <default_pmm_manager+0x590>
ffffffffc0203ae8:	00001617          	auipc	a2,0x1
ffffffffc0203aec:	35860613          	addi	a2,a2,856 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203af0:	1e600593          	li	a1,486
ffffffffc0203af4:	00002517          	auipc	a0,0x2
ffffffffc0203af8:	fa450513          	addi	a0,a0,-92 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203afc:	e06fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203b00:	00002697          	auipc	a3,0x2
ffffffffc0203b04:	49068693          	addi	a3,a3,1168 # ffffffffc0205f90 <default_pmm_manager+0x558>
ffffffffc0203b08:	00001617          	auipc	a2,0x1
ffffffffc0203b0c:	33860613          	addi	a2,a2,824 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203b10:	1e300593          	li	a1,483
ffffffffc0203b14:	00002517          	auipc	a0,0x2
ffffffffc0203b18:	f8450513          	addi	a0,a0,-124 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203b1c:	de6fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203b20:	00002697          	auipc	a3,0x2
ffffffffc0203b24:	44068693          	addi	a3,a3,1088 # ffffffffc0205f60 <default_pmm_manager+0x528>
ffffffffc0203b28:	00001617          	auipc	a2,0x1
ffffffffc0203b2c:	31860613          	addi	a2,a2,792 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203b30:	1df00593          	li	a1,479
ffffffffc0203b34:	00002517          	auipc	a0,0x2
ffffffffc0203b38:	f6450513          	addi	a0,a0,-156 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203b3c:	dc6fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203b40 <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0203b40:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc0203b44:	8082                	ret

ffffffffc0203b46 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203b46:	7179                	addi	sp,sp,-48
ffffffffc0203b48:	e84a                	sd	s2,16(sp)
ffffffffc0203b4a:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0203b4c:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203b4e:	f022                	sd	s0,32(sp)
ffffffffc0203b50:	ec26                	sd	s1,24(sp)
ffffffffc0203b52:	e44e                	sd	s3,8(sp)
ffffffffc0203b54:	f406                	sd	ra,40(sp)
ffffffffc0203b56:	84ae                	mv	s1,a1
ffffffffc0203b58:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0203b5a:	eedfe0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
ffffffffc0203b5e:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0203b60:	cd09                	beqz	a0,ffffffffc0203b7a <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0203b62:	85aa                	mv	a1,a0
ffffffffc0203b64:	86ce                	mv	a3,s3
ffffffffc0203b66:	8626                	mv	a2,s1
ffffffffc0203b68:	854a                	mv	a0,s2
ffffffffc0203b6a:	ad2ff0ef          	jal	ra,ffffffffc0202e3c <page_insert>
ffffffffc0203b6e:	ed21                	bnez	a0,ffffffffc0203bc6 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0203b70:	0000e797          	auipc	a5,0xe
ffffffffc0203b74:	9d07a783          	lw	a5,-1584(a5) # ffffffffc0211540 <swap_init_ok>
ffffffffc0203b78:	eb89                	bnez	a5,ffffffffc0203b8a <pgdir_alloc_page+0x44>
}
ffffffffc0203b7a:	70a2                	ld	ra,40(sp)
ffffffffc0203b7c:	8522                	mv	a0,s0
ffffffffc0203b7e:	7402                	ld	s0,32(sp)
ffffffffc0203b80:	64e2                	ld	s1,24(sp)
ffffffffc0203b82:	6942                	ld	s2,16(sp)
ffffffffc0203b84:	69a2                	ld	s3,8(sp)
ffffffffc0203b86:	6145                	addi	sp,sp,48
ffffffffc0203b88:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0203b8a:	4681                	li	a3,0
ffffffffc0203b8c:	8622                	mv	a2,s0
ffffffffc0203b8e:	85a6                	mv	a1,s1
ffffffffc0203b90:	0000e517          	auipc	a0,0xe
ffffffffc0203b94:	98853503          	ld	a0,-1656(a0) # ffffffffc0211518 <check_mm_struct>
ffffffffc0203b98:	a04fe0ef          	jal	ra,ffffffffc0201d9c <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0203b9c:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0203b9e:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0203ba0:	4785                	li	a5,1
ffffffffc0203ba2:	fcf70ce3          	beq	a4,a5,ffffffffc0203b7a <pgdir_alloc_page+0x34>
ffffffffc0203ba6:	00002697          	auipc	a3,0x2
ffffffffc0203baa:	46a68693          	addi	a3,a3,1130 # ffffffffc0206010 <default_pmm_manager+0x5d8>
ffffffffc0203bae:	00001617          	auipc	a2,0x1
ffffffffc0203bb2:	29260613          	addi	a2,a2,658 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203bb6:	18000593          	li	a1,384
ffffffffc0203bba:	00002517          	auipc	a0,0x2
ffffffffc0203bbe:	ede50513          	addi	a0,a0,-290 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203bc2:	d40fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203bc6:	100027f3          	csrr	a5,sstatus
ffffffffc0203bca:	8b89                	andi	a5,a5,2
ffffffffc0203bcc:	eb99                	bnez	a5,ffffffffc0203be2 <pgdir_alloc_page+0x9c>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203bce:	0000e797          	auipc	a5,0xe
ffffffffc0203bd2:	99a7b783          	ld	a5,-1638(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0203bd6:	739c                	ld	a5,32(a5)
ffffffffc0203bd8:	8522                	mv	a0,s0
ffffffffc0203bda:	4585                	li	a1,1
ffffffffc0203bdc:	9782                	jalr	a5
            return NULL;
ffffffffc0203bde:	4401                	li	s0,0
ffffffffc0203be0:	bf69                	j	ffffffffc0203b7a <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0203be2:	90dfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203be6:	0000e797          	auipc	a5,0xe
ffffffffc0203bea:	9827b783          	ld	a5,-1662(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0203bee:	739c                	ld	a5,32(a5)
ffffffffc0203bf0:	8522                	mv	a0,s0
ffffffffc0203bf2:	4585                	li	a1,1
ffffffffc0203bf4:	9782                	jalr	a5
            return NULL;
ffffffffc0203bf6:	4401                	li	s0,0
        intr_enable();
ffffffffc0203bf8:	8f1fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203bfc:	bfbd                	j	ffffffffc0203b7a <pgdir_alloc_page+0x34>

ffffffffc0203bfe <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc0203bfe:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c00:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc0203c02:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c04:	fff50713          	addi	a4,a0,-1
ffffffffc0203c08:	17f9                	addi	a5,a5,-2
ffffffffc0203c0a:	04e7ea63          	bltu	a5,a4,ffffffffc0203c5e <kmalloc+0x60>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203c0e:	6785                	lui	a5,0x1
ffffffffc0203c10:	17fd                	addi	a5,a5,-1
ffffffffc0203c12:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc0203c14:	8131                	srli	a0,a0,0xc
ffffffffc0203c16:	e31fe0ef          	jal	ra,ffffffffc0202a46 <alloc_pages>
    assert(base != NULL);
ffffffffc0203c1a:	cd3d                	beqz	a0,ffffffffc0203c98 <kmalloc+0x9a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c1c:	0000e797          	auipc	a5,0xe
ffffffffc0203c20:	9447b783          	ld	a5,-1724(a5) # ffffffffc0211560 <pages>
ffffffffc0203c24:	8d1d                	sub	a0,a0,a5
ffffffffc0203c26:	00002697          	auipc	a3,0x2
ffffffffc0203c2a:	6e26b683          	ld	a3,1762(a3) # ffffffffc0206308 <error_string+0x38>
ffffffffc0203c2e:	850d                	srai	a0,a0,0x3
ffffffffc0203c30:	02d50533          	mul	a0,a0,a3
ffffffffc0203c34:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c38:	0000e717          	auipc	a4,0xe
ffffffffc0203c3c:	92073703          	ld	a4,-1760(a4) # ffffffffc0211558 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c40:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c42:	00c51793          	slli	a5,a0,0xc
ffffffffc0203c46:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203c48:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c4a:	02e7fa63          	bgeu	a5,a4,ffffffffc0203c7e <kmalloc+0x80>
    ptr = page2kva(base);
    return ptr;
}
ffffffffc0203c4e:	60a2                	ld	ra,8(sp)
ffffffffc0203c50:	0000e797          	auipc	a5,0xe
ffffffffc0203c54:	9207b783          	ld	a5,-1760(a5) # ffffffffc0211570 <va_pa_offset>
ffffffffc0203c58:	953e                	add	a0,a0,a5
ffffffffc0203c5a:	0141                	addi	sp,sp,16
ffffffffc0203c5c:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c5e:	00002697          	auipc	a3,0x2
ffffffffc0203c62:	3ca68693          	addi	a3,a3,970 # ffffffffc0206028 <default_pmm_manager+0x5f0>
ffffffffc0203c66:	00001617          	auipc	a2,0x1
ffffffffc0203c6a:	1da60613          	addi	a2,a2,474 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203c6e:	1f600593          	li	a1,502
ffffffffc0203c72:	00002517          	auipc	a0,0x2
ffffffffc0203c76:	e2650513          	addi	a0,a0,-474 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203c7a:	c88fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203c7e:	86aa                	mv	a3,a0
ffffffffc0203c80:	00002617          	auipc	a2,0x2
ffffffffc0203c84:	df060613          	addi	a2,a2,-528 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0203c88:	06a00593          	li	a1,106
ffffffffc0203c8c:	00001517          	auipc	a0,0x1
ffffffffc0203c90:	42450513          	addi	a0,a0,1060 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0203c94:	c6efc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(base != NULL);
ffffffffc0203c98:	00002697          	auipc	a3,0x2
ffffffffc0203c9c:	3b068693          	addi	a3,a3,944 # ffffffffc0206048 <default_pmm_manager+0x610>
ffffffffc0203ca0:	00001617          	auipc	a2,0x1
ffffffffc0203ca4:	1a060613          	addi	a2,a2,416 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203ca8:	1f900593          	li	a1,505
ffffffffc0203cac:	00002517          	auipc	a0,0x2
ffffffffc0203cb0:	dec50513          	addi	a0,a0,-532 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203cb4:	c4efc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203cb8 <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0203cb8:	1101                	addi	sp,sp,-32
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203cba:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0203cbc:	ec06                	sd	ra,24(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203cbe:	fff58713          	addi	a4,a1,-1
ffffffffc0203cc2:	17f9                	addi	a5,a5,-2
ffffffffc0203cc4:	0ae7ee63          	bltu	a5,a4,ffffffffc0203d80 <kfree+0xc8>
    assert(ptr != NULL);
ffffffffc0203cc8:	cd41                	beqz	a0,ffffffffc0203d60 <kfree+0xa8>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203cca:	6785                	lui	a5,0x1
ffffffffc0203ccc:	17fd                	addi	a5,a5,-1
ffffffffc0203cce:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203cd0:	c02007b7          	lui	a5,0xc0200
ffffffffc0203cd4:	81b1                	srli	a1,a1,0xc
ffffffffc0203cd6:	06f56863          	bltu	a0,a5,ffffffffc0203d46 <kfree+0x8e>
ffffffffc0203cda:	0000e697          	auipc	a3,0xe
ffffffffc0203cde:	8966b683          	ld	a3,-1898(a3) # ffffffffc0211570 <va_pa_offset>
ffffffffc0203ce2:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage) {
ffffffffc0203ce4:	8131                	srli	a0,a0,0xc
ffffffffc0203ce6:	0000e797          	auipc	a5,0xe
ffffffffc0203cea:	8727b783          	ld	a5,-1934(a5) # ffffffffc0211558 <npage>
ffffffffc0203cee:	04f57a63          	bgeu	a0,a5,ffffffffc0203d42 <kfree+0x8a>
    return &pages[PPN(pa) - nbase];
ffffffffc0203cf2:	fff806b7          	lui	a3,0xfff80
ffffffffc0203cf6:	9536                	add	a0,a0,a3
ffffffffc0203cf8:	00351793          	slli	a5,a0,0x3
ffffffffc0203cfc:	953e                	add	a0,a0,a5
ffffffffc0203cfe:	050e                	slli	a0,a0,0x3
ffffffffc0203d00:	0000e797          	auipc	a5,0xe
ffffffffc0203d04:	8607b783          	ld	a5,-1952(a5) # ffffffffc0211560 <pages>
ffffffffc0203d08:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203d0a:	100027f3          	csrr	a5,sstatus
ffffffffc0203d0e:	8b89                	andi	a5,a5,2
ffffffffc0203d10:	eb89                	bnez	a5,ffffffffc0203d22 <kfree+0x6a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203d12:	0000e797          	auipc	a5,0xe
ffffffffc0203d16:	8567b783          	ld	a5,-1962(a5) # ffffffffc0211568 <pmm_manager>
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc0203d1a:	60e2                	ld	ra,24(sp)
    { pmm_manager->free_pages(base, n); }
ffffffffc0203d1c:	739c                	ld	a5,32(a5)
}
ffffffffc0203d1e:	6105                	addi	sp,sp,32
    { pmm_manager->free_pages(base, n); }
ffffffffc0203d20:	8782                	jr	a5
        intr_disable();
ffffffffc0203d22:	e42a                	sd	a0,8(sp)
ffffffffc0203d24:	e02e                	sd	a1,0(sp)
ffffffffc0203d26:	fc8fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203d2a:	0000e797          	auipc	a5,0xe
ffffffffc0203d2e:	83e7b783          	ld	a5,-1986(a5) # ffffffffc0211568 <pmm_manager>
ffffffffc0203d32:	6582                	ld	a1,0(sp)
ffffffffc0203d34:	6522                	ld	a0,8(sp)
ffffffffc0203d36:	739c                	ld	a5,32(a5)
ffffffffc0203d38:	9782                	jalr	a5
}
ffffffffc0203d3a:	60e2                	ld	ra,24(sp)
ffffffffc0203d3c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203d3e:	faafc06f          	j	ffffffffc02004e8 <intr_enable>
ffffffffc0203d42:	ccdfe0ef          	jal	ra,ffffffffc0202a0e <pa2page.part.0>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203d46:	86aa                	mv	a3,a0
ffffffffc0203d48:	00002617          	auipc	a2,0x2
ffffffffc0203d4c:	de860613          	addi	a2,a2,-536 # ffffffffc0205b30 <default_pmm_manager+0xf8>
ffffffffc0203d50:	06c00593          	li	a1,108
ffffffffc0203d54:	00001517          	auipc	a0,0x1
ffffffffc0203d58:	35c50513          	addi	a0,a0,860 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0203d5c:	ba6fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(ptr != NULL);
ffffffffc0203d60:	00002697          	auipc	a3,0x2
ffffffffc0203d64:	2f868693          	addi	a3,a3,760 # ffffffffc0206058 <default_pmm_manager+0x620>
ffffffffc0203d68:	00001617          	auipc	a2,0x1
ffffffffc0203d6c:	0d860613          	addi	a2,a2,216 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203d70:	20000593          	li	a1,512
ffffffffc0203d74:	00002517          	auipc	a0,0x2
ffffffffc0203d78:	d2450513          	addi	a0,a0,-732 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203d7c:	b86fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d80:	00002697          	auipc	a3,0x2
ffffffffc0203d84:	2a868693          	addi	a3,a3,680 # ffffffffc0206028 <default_pmm_manager+0x5f0>
ffffffffc0203d88:	00001617          	auipc	a2,0x1
ffffffffc0203d8c:	0b860613          	addi	a2,a2,184 # ffffffffc0204e40 <commands+0x770>
ffffffffc0203d90:	1ff00593          	li	a1,511
ffffffffc0203d94:	00002517          	auipc	a0,0x2
ffffffffc0203d98:	d0450513          	addi	a0,a0,-764 # ffffffffc0205a98 <default_pmm_manager+0x60>
ffffffffc0203d9c:	b66fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203da0 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0203da0:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {//检查交换设备的有效性
ffffffffc0203da2:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203da4:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {//检查交换设备的有效性
ffffffffc0203da6:	e2cfc0ef          	jal	ra,ffffffffc02003d2 <ide_device_valid>
ffffffffc0203daa:	cd01                	beqz	a0,ffffffffc0203dc2 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203dac:	4505                	li	a0,1
ffffffffc0203dae:	e2afc0ef          	jal	ra,ffffffffc02003d8 <ide_device_size>
}
ffffffffc0203db2:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203db4:	810d                	srli	a0,a0,0x3
ffffffffc0203db6:	0000d797          	auipc	a5,0xd
ffffffffc0203dba:	76a7bd23          	sd	a0,1914(a5) # ffffffffc0211530 <max_swap_offset>
}
ffffffffc0203dbe:	0141                	addi	sp,sp,16
ffffffffc0203dc0:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203dc2:	00002617          	auipc	a2,0x2
ffffffffc0203dc6:	2a660613          	addi	a2,a2,678 # ffffffffc0206068 <default_pmm_manager+0x630>
ffffffffc0203dca:	45b5                	li	a1,13
ffffffffc0203dcc:	00002517          	auipc	a0,0x2
ffffffffc0203dd0:	2bc50513          	addi	a0,a0,700 # ffffffffc0206088 <default_pmm_manager+0x650>
ffffffffc0203dd4:	b2efc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203dd8 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203dd8:	1141                	addi	sp,sp,-16
ffffffffc0203dda:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203ddc:	00855793          	srli	a5,a0,0x8
ffffffffc0203de0:	c3a5                	beqz	a5,ffffffffc0203e40 <swapfs_read+0x68>
ffffffffc0203de2:	0000d717          	auipc	a4,0xd
ffffffffc0203de6:	74e73703          	ld	a4,1870(a4) # ffffffffc0211530 <max_swap_offset>
ffffffffc0203dea:	04e7fb63          	bgeu	a5,a4,ffffffffc0203e40 <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203dee:	0000d617          	auipc	a2,0xd
ffffffffc0203df2:	77263603          	ld	a2,1906(a2) # ffffffffc0211560 <pages>
ffffffffc0203df6:	8d91                	sub	a1,a1,a2
ffffffffc0203df8:	4035d613          	srai	a2,a1,0x3
ffffffffc0203dfc:	00002597          	auipc	a1,0x2
ffffffffc0203e00:	50c5b583          	ld	a1,1292(a1) # ffffffffc0206308 <error_string+0x38>
ffffffffc0203e04:	02b60633          	mul	a2,a2,a1
ffffffffc0203e08:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203e0c:	00002797          	auipc	a5,0x2
ffffffffc0203e10:	5047b783          	ld	a5,1284(a5) # ffffffffc0206310 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e14:	0000d717          	auipc	a4,0xd
ffffffffc0203e18:	74473703          	ld	a4,1860(a4) # ffffffffc0211558 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e1c:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e1e:	00c61793          	slli	a5,a2,0xc
ffffffffc0203e22:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203e24:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e26:	02e7f963          	bgeu	a5,a4,ffffffffc0203e58 <swapfs_read+0x80>
}
ffffffffc0203e2a:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e2c:	0000d797          	auipc	a5,0xd
ffffffffc0203e30:	7447b783          	ld	a5,1860(a5) # ffffffffc0211570 <va_pa_offset>
ffffffffc0203e34:	46a1                	li	a3,8
ffffffffc0203e36:	963e                	add	a2,a2,a5
ffffffffc0203e38:	4505                	li	a0,1
}
ffffffffc0203e3a:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e3c:	da2fc06f          	j	ffffffffc02003de <ide_read_secs>
ffffffffc0203e40:	86aa                	mv	a3,a0
ffffffffc0203e42:	00002617          	auipc	a2,0x2
ffffffffc0203e46:	25e60613          	addi	a2,a2,606 # ffffffffc02060a0 <default_pmm_manager+0x668>
ffffffffc0203e4a:	45d1                	li	a1,20
ffffffffc0203e4c:	00002517          	auipc	a0,0x2
ffffffffc0203e50:	23c50513          	addi	a0,a0,572 # ffffffffc0206088 <default_pmm_manager+0x650>
ffffffffc0203e54:	aaefc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203e58:	86b2                	mv	a3,a2
ffffffffc0203e5a:	06a00593          	li	a1,106
ffffffffc0203e5e:	00002617          	auipc	a2,0x2
ffffffffc0203e62:	c1260613          	addi	a2,a2,-1006 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0203e66:	00001517          	auipc	a0,0x1
ffffffffc0203e6a:	24a50513          	addi	a0,a0,586 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0203e6e:	a94fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e72 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203e72:	1141                	addi	sp,sp,-16
ffffffffc0203e74:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e76:	00855793          	srli	a5,a0,0x8
ffffffffc0203e7a:	c3a5                	beqz	a5,ffffffffc0203eda <swapfs_write+0x68>
ffffffffc0203e7c:	0000d717          	auipc	a4,0xd
ffffffffc0203e80:	6b473703          	ld	a4,1716(a4) # ffffffffc0211530 <max_swap_offset>
ffffffffc0203e84:	04e7fb63          	bgeu	a5,a4,ffffffffc0203eda <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e88:	0000d617          	auipc	a2,0xd
ffffffffc0203e8c:	6d863603          	ld	a2,1752(a2) # ffffffffc0211560 <pages>
ffffffffc0203e90:	8d91                	sub	a1,a1,a2
ffffffffc0203e92:	4035d613          	srai	a2,a1,0x3
ffffffffc0203e96:	00002597          	auipc	a1,0x2
ffffffffc0203e9a:	4725b583          	ld	a1,1138(a1) # ffffffffc0206308 <error_string+0x38>
ffffffffc0203e9e:	02b60633          	mul	a2,a2,a1
ffffffffc0203ea2:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203ea6:	00002797          	auipc	a5,0x2
ffffffffc0203eaa:	46a7b783          	ld	a5,1130(a5) # ffffffffc0206310 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203eae:	0000d717          	auipc	a4,0xd
ffffffffc0203eb2:	6aa73703          	ld	a4,1706(a4) # ffffffffc0211558 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203eb6:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203eb8:	00c61793          	slli	a5,a2,0xc
ffffffffc0203ebc:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ebe:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203ec0:	02e7f963          	bgeu	a5,a4,ffffffffc0203ef2 <swapfs_write+0x80>
}
ffffffffc0203ec4:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203ec6:	0000d797          	auipc	a5,0xd
ffffffffc0203eca:	6aa7b783          	ld	a5,1706(a5) # ffffffffc0211570 <va_pa_offset>
ffffffffc0203ece:	46a1                	li	a3,8
ffffffffc0203ed0:	963e                	add	a2,a2,a5
ffffffffc0203ed2:	4505                	li	a0,1
}
ffffffffc0203ed4:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203ed6:	d2cfc06f          	j	ffffffffc0200402 <ide_write_secs>
ffffffffc0203eda:	86aa                	mv	a3,a0
ffffffffc0203edc:	00002617          	auipc	a2,0x2
ffffffffc0203ee0:	1c460613          	addi	a2,a2,452 # ffffffffc02060a0 <default_pmm_manager+0x668>
ffffffffc0203ee4:	45e5                	li	a1,25
ffffffffc0203ee6:	00002517          	auipc	a0,0x2
ffffffffc0203eea:	1a250513          	addi	a0,a0,418 # ffffffffc0206088 <default_pmm_manager+0x650>
ffffffffc0203eee:	a14fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203ef2:	86b2                	mv	a3,a2
ffffffffc0203ef4:	06a00593          	li	a1,106
ffffffffc0203ef8:	00002617          	auipc	a2,0x2
ffffffffc0203efc:	b7860613          	addi	a2,a2,-1160 # ffffffffc0205a70 <default_pmm_manager+0x38>
ffffffffc0203f00:	00001517          	auipc	a0,0x1
ffffffffc0203f04:	1b050513          	addi	a0,a0,432 # ffffffffc02050b0 <commands+0x9e0>
ffffffffc0203f08:	9fafc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203f0c <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203f0c:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203f10:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203f12:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203f14:	cb81                	beqz	a5,ffffffffc0203f24 <strlen+0x18>
        cnt ++;
ffffffffc0203f16:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203f18:	00a707b3          	add	a5,a4,a0
ffffffffc0203f1c:	0007c783          	lbu	a5,0(a5)
ffffffffc0203f20:	fbfd                	bnez	a5,ffffffffc0203f16 <strlen+0xa>
ffffffffc0203f22:	8082                	ret
    }
    return cnt;
}
ffffffffc0203f24:	8082                	ret

ffffffffc0203f26 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203f26:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203f28:	e589                	bnez	a1,ffffffffc0203f32 <strnlen+0xc>
ffffffffc0203f2a:	a811                	j	ffffffffc0203f3e <strnlen+0x18>
        cnt ++;
ffffffffc0203f2c:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203f2e:	00f58863          	beq	a1,a5,ffffffffc0203f3e <strnlen+0x18>
ffffffffc0203f32:	00f50733          	add	a4,a0,a5
ffffffffc0203f36:	00074703          	lbu	a4,0(a4)
ffffffffc0203f3a:	fb6d                	bnez	a4,ffffffffc0203f2c <strnlen+0x6>
ffffffffc0203f3c:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203f3e:	852e                	mv	a0,a1
ffffffffc0203f40:	8082                	ret

ffffffffc0203f42 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203f42:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203f44:	0005c703          	lbu	a4,0(a1)
ffffffffc0203f48:	0785                	addi	a5,a5,1
ffffffffc0203f4a:	0585                	addi	a1,a1,1
ffffffffc0203f4c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203f50:	fb75                	bnez	a4,ffffffffc0203f44 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203f52:	8082                	ret

ffffffffc0203f54 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f54:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f58:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f5c:	cb89                	beqz	a5,ffffffffc0203f6e <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0203f5e:	0505                	addi	a0,a0,1
ffffffffc0203f60:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f62:	fee789e3          	beq	a5,a4,ffffffffc0203f54 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f66:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203f6a:	9d19                	subw	a0,a0,a4
ffffffffc0203f6c:	8082                	ret
ffffffffc0203f6e:	4501                	li	a0,0
ffffffffc0203f70:	bfed                	j	ffffffffc0203f6a <strcmp+0x16>

ffffffffc0203f72 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203f72:	00054783          	lbu	a5,0(a0)
ffffffffc0203f76:	c799                	beqz	a5,ffffffffc0203f84 <strchr+0x12>
        if (*s == c) {
ffffffffc0203f78:	00f58763          	beq	a1,a5,ffffffffc0203f86 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203f7c:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203f80:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203f82:	fbfd                	bnez	a5,ffffffffc0203f78 <strchr+0x6>
    }
    return NULL;
ffffffffc0203f84:	4501                	li	a0,0
}
ffffffffc0203f86:	8082                	ret

ffffffffc0203f88 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203f88:	ca01                	beqz	a2,ffffffffc0203f98 <memset+0x10>
ffffffffc0203f8a:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203f8c:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203f8e:	0785                	addi	a5,a5,1
ffffffffc0203f90:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203f94:	fec79de3          	bne	a5,a2,ffffffffc0203f8e <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203f98:	8082                	ret

ffffffffc0203f9a <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203f9a:	ca19                	beqz	a2,ffffffffc0203fb0 <memcpy+0x16>
ffffffffc0203f9c:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203f9e:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203fa0:	0005c703          	lbu	a4,0(a1)
ffffffffc0203fa4:	0585                	addi	a1,a1,1
ffffffffc0203fa6:	0785                	addi	a5,a5,1
ffffffffc0203fa8:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203fac:	fec59ae3          	bne	a1,a2,ffffffffc0203fa0 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203fb0:	8082                	ret

ffffffffc0203fb2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203fb2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203fb6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203fb8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203fbc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203fbe:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203fc2:	f022                	sd	s0,32(sp)
ffffffffc0203fc4:	ec26                	sd	s1,24(sp)
ffffffffc0203fc6:	e84a                	sd	s2,16(sp)
ffffffffc0203fc8:	f406                	sd	ra,40(sp)
ffffffffc0203fca:	e44e                	sd	s3,8(sp)
ffffffffc0203fcc:	84aa                	mv	s1,a0
ffffffffc0203fce:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203fd0:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203fd4:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203fd6:	03067e63          	bgeu	a2,a6,ffffffffc0204012 <printnum+0x60>
ffffffffc0203fda:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203fdc:	00805763          	blez	s0,ffffffffc0203fea <printnum+0x38>
ffffffffc0203fe0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203fe2:	85ca                	mv	a1,s2
ffffffffc0203fe4:	854e                	mv	a0,s3
ffffffffc0203fe6:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203fe8:	fc65                	bnez	s0,ffffffffc0203fe0 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203fea:	1a02                	slli	s4,s4,0x20
ffffffffc0203fec:	00002797          	auipc	a5,0x2
ffffffffc0203ff0:	0d478793          	addi	a5,a5,212 # ffffffffc02060c0 <default_pmm_manager+0x688>
ffffffffc0203ff4:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203ff8:	9a3e                	add	s4,s4,a5
}
ffffffffc0203ffa:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ffc:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0204000:	70a2                	ld	ra,40(sp)
ffffffffc0204002:	69a2                	ld	s3,8(sp)
ffffffffc0204004:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204006:	85ca                	mv	a1,s2
ffffffffc0204008:	87a6                	mv	a5,s1
}
ffffffffc020400a:	6942                	ld	s2,16(sp)
ffffffffc020400c:	64e2                	ld	s1,24(sp)
ffffffffc020400e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204010:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0204012:	03065633          	divu	a2,a2,a6
ffffffffc0204016:	8722                	mv	a4,s0
ffffffffc0204018:	f9bff0ef          	jal	ra,ffffffffc0203fb2 <printnum>
ffffffffc020401c:	b7f9                	j	ffffffffc0203fea <printnum+0x38>

ffffffffc020401e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020401e:	7119                	addi	sp,sp,-128
ffffffffc0204020:	f4a6                	sd	s1,104(sp)
ffffffffc0204022:	f0ca                	sd	s2,96(sp)
ffffffffc0204024:	ecce                	sd	s3,88(sp)
ffffffffc0204026:	e8d2                	sd	s4,80(sp)
ffffffffc0204028:	e4d6                	sd	s5,72(sp)
ffffffffc020402a:	e0da                	sd	s6,64(sp)
ffffffffc020402c:	fc5e                	sd	s7,56(sp)
ffffffffc020402e:	f06a                	sd	s10,32(sp)
ffffffffc0204030:	fc86                	sd	ra,120(sp)
ffffffffc0204032:	f8a2                	sd	s0,112(sp)
ffffffffc0204034:	f862                	sd	s8,48(sp)
ffffffffc0204036:	f466                	sd	s9,40(sp)
ffffffffc0204038:	ec6e                	sd	s11,24(sp)
ffffffffc020403a:	892a                	mv	s2,a0
ffffffffc020403c:	84ae                	mv	s1,a1
ffffffffc020403e:	8d32                	mv	s10,a2
ffffffffc0204040:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204042:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0204046:	5b7d                	li	s6,-1
ffffffffc0204048:	00002a97          	auipc	s5,0x2
ffffffffc020404c:	0aca8a93          	addi	s5,s5,172 # ffffffffc02060f4 <default_pmm_manager+0x6bc>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204050:	00002b97          	auipc	s7,0x2
ffffffffc0204054:	280b8b93          	addi	s7,s7,640 # ffffffffc02062d0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204058:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc020405c:	001d0413          	addi	s0,s10,1
ffffffffc0204060:	01350a63          	beq	a0,s3,ffffffffc0204074 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0204064:	c121                	beqz	a0,ffffffffc02040a4 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0204066:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204068:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020406a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020406c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204070:	ff351ae3          	bne	a0,s3,ffffffffc0204064 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204074:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0204078:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020407c:	4c81                	li	s9,0
ffffffffc020407e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0204080:	5c7d                	li	s8,-1
ffffffffc0204082:	5dfd                	li	s11,-1
ffffffffc0204084:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0204088:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020408a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020408e:	0ff5f593          	zext.b	a1,a1
ffffffffc0204092:	00140d13          	addi	s10,s0,1
ffffffffc0204096:	04b56263          	bltu	a0,a1,ffffffffc02040da <vprintfmt+0xbc>
ffffffffc020409a:	058a                	slli	a1,a1,0x2
ffffffffc020409c:	95d6                	add	a1,a1,s5
ffffffffc020409e:	4194                	lw	a3,0(a1)
ffffffffc02040a0:	96d6                	add	a3,a3,s5
ffffffffc02040a2:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02040a4:	70e6                	ld	ra,120(sp)
ffffffffc02040a6:	7446                	ld	s0,112(sp)
ffffffffc02040a8:	74a6                	ld	s1,104(sp)
ffffffffc02040aa:	7906                	ld	s2,96(sp)
ffffffffc02040ac:	69e6                	ld	s3,88(sp)
ffffffffc02040ae:	6a46                	ld	s4,80(sp)
ffffffffc02040b0:	6aa6                	ld	s5,72(sp)
ffffffffc02040b2:	6b06                	ld	s6,64(sp)
ffffffffc02040b4:	7be2                	ld	s7,56(sp)
ffffffffc02040b6:	7c42                	ld	s8,48(sp)
ffffffffc02040b8:	7ca2                	ld	s9,40(sp)
ffffffffc02040ba:	7d02                	ld	s10,32(sp)
ffffffffc02040bc:	6de2                	ld	s11,24(sp)
ffffffffc02040be:	6109                	addi	sp,sp,128
ffffffffc02040c0:	8082                	ret
            padc = '0';
ffffffffc02040c2:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02040c4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040c8:	846a                	mv	s0,s10
ffffffffc02040ca:	00140d13          	addi	s10,s0,1
ffffffffc02040ce:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02040d2:	0ff5f593          	zext.b	a1,a1
ffffffffc02040d6:	fcb572e3          	bgeu	a0,a1,ffffffffc020409a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02040da:	85a6                	mv	a1,s1
ffffffffc02040dc:	02500513          	li	a0,37
ffffffffc02040e0:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02040e2:	fff44783          	lbu	a5,-1(s0)
ffffffffc02040e6:	8d22                	mv	s10,s0
ffffffffc02040e8:	f73788e3          	beq	a5,s3,ffffffffc0204058 <vprintfmt+0x3a>
ffffffffc02040ec:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02040f0:	1d7d                	addi	s10,s10,-1
ffffffffc02040f2:	ff379de3          	bne	a5,s3,ffffffffc02040ec <vprintfmt+0xce>
ffffffffc02040f6:	b78d                	j	ffffffffc0204058 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02040f8:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02040fc:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204100:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0204102:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0204106:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020410a:	02d86463          	bltu	a6,a3,ffffffffc0204132 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020410e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204112:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204116:	0186873b          	addw	a4,a3,s8
ffffffffc020411a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020411e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0204120:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0204124:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204126:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020412a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020412e:	fed870e3          	bgeu	a6,a3,ffffffffc020410e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0204132:	f40ddce3          	bgez	s11,ffffffffc020408a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0204136:	8de2                	mv	s11,s8
ffffffffc0204138:	5c7d                	li	s8,-1
ffffffffc020413a:	bf81                	j	ffffffffc020408a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020413c:	fffdc693          	not	a3,s11
ffffffffc0204140:	96fd                	srai	a3,a3,0x3f
ffffffffc0204142:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204146:	00144603          	lbu	a2,1(s0)
ffffffffc020414a:	2d81                	sext.w	s11,s11
ffffffffc020414c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020414e:	bf35                	j	ffffffffc020408a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0204150:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204154:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204158:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020415a:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020415c:	bfd9                	j	ffffffffc0204132 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020415e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204160:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204164:	01174463          	blt	a4,a7,ffffffffc020416c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204168:	1a088e63          	beqz	a7,ffffffffc0204324 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020416c:	000a3603          	ld	a2,0(s4)
ffffffffc0204170:	46c1                	li	a3,16
ffffffffc0204172:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204174:	2781                	sext.w	a5,a5
ffffffffc0204176:	876e                	mv	a4,s11
ffffffffc0204178:	85a6                	mv	a1,s1
ffffffffc020417a:	854a                	mv	a0,s2
ffffffffc020417c:	e37ff0ef          	jal	ra,ffffffffc0203fb2 <printnum>
            break;
ffffffffc0204180:	bde1                	j	ffffffffc0204058 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0204182:	000a2503          	lw	a0,0(s4)
ffffffffc0204186:	85a6                	mv	a1,s1
ffffffffc0204188:	0a21                	addi	s4,s4,8
ffffffffc020418a:	9902                	jalr	s2
            break;
ffffffffc020418c:	b5f1                	j	ffffffffc0204058 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020418e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204190:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204194:	01174463          	blt	a4,a7,ffffffffc020419c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0204198:	18088163          	beqz	a7,ffffffffc020431a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020419c:	000a3603          	ld	a2,0(s4)
ffffffffc02041a0:	46a9                	li	a3,10
ffffffffc02041a2:	8a2e                	mv	s4,a1
ffffffffc02041a4:	bfc1                	j	ffffffffc0204174 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041a6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02041aa:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041ac:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02041ae:	bdf1                	j	ffffffffc020408a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02041b0:	85a6                	mv	a1,s1
ffffffffc02041b2:	02500513          	li	a0,37
ffffffffc02041b6:	9902                	jalr	s2
            break;
ffffffffc02041b8:	b545                	j	ffffffffc0204058 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041ba:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02041be:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041c0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02041c2:	b5e1                	j	ffffffffc020408a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02041c4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02041c6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02041ca:	01174463          	blt	a4,a7,ffffffffc02041d2 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02041ce:	14088163          	beqz	a7,ffffffffc0204310 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02041d2:	000a3603          	ld	a2,0(s4)
ffffffffc02041d6:	46a1                	li	a3,8
ffffffffc02041d8:	8a2e                	mv	s4,a1
ffffffffc02041da:	bf69                	j	ffffffffc0204174 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02041dc:	03000513          	li	a0,48
ffffffffc02041e0:	85a6                	mv	a1,s1
ffffffffc02041e2:	e03e                	sd	a5,0(sp)
ffffffffc02041e4:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02041e6:	85a6                	mv	a1,s1
ffffffffc02041e8:	07800513          	li	a0,120
ffffffffc02041ec:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02041ee:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02041f0:	6782                	ld	a5,0(sp)
ffffffffc02041f2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02041f4:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02041f8:	bfb5                	j	ffffffffc0204174 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02041fa:	000a3403          	ld	s0,0(s4)
ffffffffc02041fe:	008a0713          	addi	a4,s4,8
ffffffffc0204202:	e03a                	sd	a4,0(sp)
ffffffffc0204204:	14040263          	beqz	s0,ffffffffc0204348 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0204208:	0fb05763          	blez	s11,ffffffffc02042f6 <vprintfmt+0x2d8>
ffffffffc020420c:	02d00693          	li	a3,45
ffffffffc0204210:	0cd79163          	bne	a5,a3,ffffffffc02042d2 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204214:	00044783          	lbu	a5,0(s0)
ffffffffc0204218:	0007851b          	sext.w	a0,a5
ffffffffc020421c:	cf85                	beqz	a5,ffffffffc0204254 <vprintfmt+0x236>
ffffffffc020421e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204222:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204226:	000c4563          	bltz	s8,ffffffffc0204230 <vprintfmt+0x212>
ffffffffc020422a:	3c7d                	addiw	s8,s8,-1
ffffffffc020422c:	036c0263          	beq	s8,s6,ffffffffc0204250 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0204230:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204232:	0e0c8e63          	beqz	s9,ffffffffc020432e <vprintfmt+0x310>
ffffffffc0204236:	3781                	addiw	a5,a5,-32
ffffffffc0204238:	0ef47b63          	bgeu	s0,a5,ffffffffc020432e <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020423c:	03f00513          	li	a0,63
ffffffffc0204240:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204242:	000a4783          	lbu	a5,0(s4)
ffffffffc0204246:	3dfd                	addiw	s11,s11,-1
ffffffffc0204248:	0a05                	addi	s4,s4,1
ffffffffc020424a:	0007851b          	sext.w	a0,a5
ffffffffc020424e:	ffe1                	bnez	a5,ffffffffc0204226 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0204250:	01b05963          	blez	s11,ffffffffc0204262 <vprintfmt+0x244>
ffffffffc0204254:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204256:	85a6                	mv	a1,s1
ffffffffc0204258:	02000513          	li	a0,32
ffffffffc020425c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020425e:	fe0d9be3          	bnez	s11,ffffffffc0204254 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204262:	6a02                	ld	s4,0(sp)
ffffffffc0204264:	bbd5                	j	ffffffffc0204058 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204266:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204268:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020426c:	01174463          	blt	a4,a7,ffffffffc0204274 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0204270:	08088d63          	beqz	a7,ffffffffc020430a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204274:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204278:	0a044d63          	bltz	s0,ffffffffc0204332 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020427c:	8622                	mv	a2,s0
ffffffffc020427e:	8a66                	mv	s4,s9
ffffffffc0204280:	46a9                	li	a3,10
ffffffffc0204282:	bdcd                	j	ffffffffc0204174 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204284:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204288:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc020428a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020428c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204290:	8fb5                	xor	a5,a5,a3
ffffffffc0204292:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204296:	02d74163          	blt	a4,a3,ffffffffc02042b8 <vprintfmt+0x29a>
ffffffffc020429a:	00369793          	slli	a5,a3,0x3
ffffffffc020429e:	97de                	add	a5,a5,s7
ffffffffc02042a0:	639c                	ld	a5,0(a5)
ffffffffc02042a2:	cb99                	beqz	a5,ffffffffc02042b8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02042a4:	86be                	mv	a3,a5
ffffffffc02042a6:	00002617          	auipc	a2,0x2
ffffffffc02042aa:	e4a60613          	addi	a2,a2,-438 # ffffffffc02060f0 <default_pmm_manager+0x6b8>
ffffffffc02042ae:	85a6                	mv	a1,s1
ffffffffc02042b0:	854a                	mv	a0,s2
ffffffffc02042b2:	0ce000ef          	jal	ra,ffffffffc0204380 <printfmt>
ffffffffc02042b6:	b34d                	j	ffffffffc0204058 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02042b8:	00002617          	auipc	a2,0x2
ffffffffc02042bc:	e2860613          	addi	a2,a2,-472 # ffffffffc02060e0 <default_pmm_manager+0x6a8>
ffffffffc02042c0:	85a6                	mv	a1,s1
ffffffffc02042c2:	854a                	mv	a0,s2
ffffffffc02042c4:	0bc000ef          	jal	ra,ffffffffc0204380 <printfmt>
ffffffffc02042c8:	bb41                	j	ffffffffc0204058 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02042ca:	00002417          	auipc	s0,0x2
ffffffffc02042ce:	e0e40413          	addi	s0,s0,-498 # ffffffffc02060d8 <default_pmm_manager+0x6a0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042d2:	85e2                	mv	a1,s8
ffffffffc02042d4:	8522                	mv	a0,s0
ffffffffc02042d6:	e43e                	sd	a5,8(sp)
ffffffffc02042d8:	c4fff0ef          	jal	ra,ffffffffc0203f26 <strnlen>
ffffffffc02042dc:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02042e0:	01b05b63          	blez	s11,ffffffffc02042f6 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02042e4:	67a2                	ld	a5,8(sp)
ffffffffc02042e6:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042ea:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02042ec:	85a6                	mv	a1,s1
ffffffffc02042ee:	8552                	mv	a0,s4
ffffffffc02042f0:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042f2:	fe0d9ce3          	bnez	s11,ffffffffc02042ea <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042f6:	00044783          	lbu	a5,0(s0)
ffffffffc02042fa:	00140a13          	addi	s4,s0,1
ffffffffc02042fe:	0007851b          	sext.w	a0,a5
ffffffffc0204302:	d3a5                	beqz	a5,ffffffffc0204262 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204304:	05e00413          	li	s0,94
ffffffffc0204308:	bf39                	j	ffffffffc0204226 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020430a:	000a2403          	lw	s0,0(s4)
ffffffffc020430e:	b7ad                	j	ffffffffc0204278 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0204310:	000a6603          	lwu	a2,0(s4)
ffffffffc0204314:	46a1                	li	a3,8
ffffffffc0204316:	8a2e                	mv	s4,a1
ffffffffc0204318:	bdb1                	j	ffffffffc0204174 <vprintfmt+0x156>
ffffffffc020431a:	000a6603          	lwu	a2,0(s4)
ffffffffc020431e:	46a9                	li	a3,10
ffffffffc0204320:	8a2e                	mv	s4,a1
ffffffffc0204322:	bd89                	j	ffffffffc0204174 <vprintfmt+0x156>
ffffffffc0204324:	000a6603          	lwu	a2,0(s4)
ffffffffc0204328:	46c1                	li	a3,16
ffffffffc020432a:	8a2e                	mv	s4,a1
ffffffffc020432c:	b5a1                	j	ffffffffc0204174 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020432e:	9902                	jalr	s2
ffffffffc0204330:	bf09                	j	ffffffffc0204242 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204332:	85a6                	mv	a1,s1
ffffffffc0204334:	02d00513          	li	a0,45
ffffffffc0204338:	e03e                	sd	a5,0(sp)
ffffffffc020433a:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020433c:	6782                	ld	a5,0(sp)
ffffffffc020433e:	8a66                	mv	s4,s9
ffffffffc0204340:	40800633          	neg	a2,s0
ffffffffc0204344:	46a9                	li	a3,10
ffffffffc0204346:	b53d                	j	ffffffffc0204174 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0204348:	03b05163          	blez	s11,ffffffffc020436a <vprintfmt+0x34c>
ffffffffc020434c:	02d00693          	li	a3,45
ffffffffc0204350:	f6d79de3          	bne	a5,a3,ffffffffc02042ca <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204354:	00002417          	auipc	s0,0x2
ffffffffc0204358:	d8440413          	addi	s0,s0,-636 # ffffffffc02060d8 <default_pmm_manager+0x6a0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020435c:	02800793          	li	a5,40
ffffffffc0204360:	02800513          	li	a0,40
ffffffffc0204364:	00140a13          	addi	s4,s0,1
ffffffffc0204368:	bd6d                	j	ffffffffc0204222 <vprintfmt+0x204>
ffffffffc020436a:	00002a17          	auipc	s4,0x2
ffffffffc020436e:	d6fa0a13          	addi	s4,s4,-657 # ffffffffc02060d9 <default_pmm_manager+0x6a1>
ffffffffc0204372:	02800513          	li	a0,40
ffffffffc0204376:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020437a:	05e00413          	li	s0,94
ffffffffc020437e:	b565                	j	ffffffffc0204226 <vprintfmt+0x208>

ffffffffc0204380 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204380:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204382:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204386:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204388:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020438a:	ec06                	sd	ra,24(sp)
ffffffffc020438c:	f83a                	sd	a4,48(sp)
ffffffffc020438e:	fc3e                	sd	a5,56(sp)
ffffffffc0204390:	e0c2                	sd	a6,64(sp)
ffffffffc0204392:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204394:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204396:	c89ff0ef          	jal	ra,ffffffffc020401e <vprintfmt>
}
ffffffffc020439a:	60e2                	ld	ra,24(sp)
ffffffffc020439c:	6161                	addi	sp,sp,80
ffffffffc020439e:	8082                	ret

ffffffffc02043a0 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02043a0:	715d                	addi	sp,sp,-80
ffffffffc02043a2:	e486                	sd	ra,72(sp)
ffffffffc02043a4:	e0a6                	sd	s1,64(sp)
ffffffffc02043a6:	fc4a                	sd	s2,56(sp)
ffffffffc02043a8:	f84e                	sd	s3,48(sp)
ffffffffc02043aa:	f452                	sd	s4,40(sp)
ffffffffc02043ac:	f056                	sd	s5,32(sp)
ffffffffc02043ae:	ec5a                	sd	s6,24(sp)
ffffffffc02043b0:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02043b2:	c901                	beqz	a0,ffffffffc02043c2 <readline+0x22>
ffffffffc02043b4:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02043b6:	00002517          	auipc	a0,0x2
ffffffffc02043ba:	d3a50513          	addi	a0,a0,-710 # ffffffffc02060f0 <default_pmm_manager+0x6b8>
ffffffffc02043be:	cfdfb0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc02043c2:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043c4:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02043c6:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02043c8:	4aa9                	li	s5,10
ffffffffc02043ca:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02043cc:	0000db97          	auipc	s7,0xd
ffffffffc02043d0:	d2cb8b93          	addi	s7,s7,-724 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043d4:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02043d8:	d1bfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043dc:	00054a63          	bltz	a0,ffffffffc02043f0 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043e0:	00a95a63          	bge	s2,a0,ffffffffc02043f4 <readline+0x54>
ffffffffc02043e4:	029a5263          	bge	s4,s1,ffffffffc0204408 <readline+0x68>
        c = getchar();
ffffffffc02043e8:	d0bfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043ec:	fe055ae3          	bgez	a0,ffffffffc02043e0 <readline+0x40>
            return NULL;
ffffffffc02043f0:	4501                	li	a0,0
ffffffffc02043f2:	a091                	j	ffffffffc0204436 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02043f4:	03351463          	bne	a0,s3,ffffffffc020441c <readline+0x7c>
ffffffffc02043f8:	e8a9                	bnez	s1,ffffffffc020444a <readline+0xaa>
        c = getchar();
ffffffffc02043fa:	cf9fb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043fe:	fe0549e3          	bltz	a0,ffffffffc02043f0 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204402:	fea959e3          	bge	s2,a0,ffffffffc02043f4 <readline+0x54>
ffffffffc0204406:	4481                	li	s1,0
            cputchar(c);
ffffffffc0204408:	e42a                	sd	a0,8(sp)
ffffffffc020440a:	ce7fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc020440e:	6522                	ld	a0,8(sp)
ffffffffc0204410:	009b87b3          	add	a5,s7,s1
ffffffffc0204414:	2485                	addiw	s1,s1,1
ffffffffc0204416:	00a78023          	sb	a0,0(a5)
ffffffffc020441a:	bf7d                	j	ffffffffc02043d8 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020441c:	01550463          	beq	a0,s5,ffffffffc0204424 <readline+0x84>
ffffffffc0204420:	fb651ce3          	bne	a0,s6,ffffffffc02043d8 <readline+0x38>
            cputchar(c);
ffffffffc0204424:	ccdfb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc0204428:	0000d517          	auipc	a0,0xd
ffffffffc020442c:	cd050513          	addi	a0,a0,-816 # ffffffffc02110f8 <buf>
ffffffffc0204430:	94aa                	add	s1,s1,a0
ffffffffc0204432:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0204436:	60a6                	ld	ra,72(sp)
ffffffffc0204438:	6486                	ld	s1,64(sp)
ffffffffc020443a:	7962                	ld	s2,56(sp)
ffffffffc020443c:	79c2                	ld	s3,48(sp)
ffffffffc020443e:	7a22                	ld	s4,40(sp)
ffffffffc0204440:	7a82                	ld	s5,32(sp)
ffffffffc0204442:	6b62                	ld	s6,24(sp)
ffffffffc0204444:	6bc2                	ld	s7,16(sp)
ffffffffc0204446:	6161                	addi	sp,sp,80
ffffffffc0204448:	8082                	ret
            cputchar(c);
ffffffffc020444a:	4521                	li	a0,8
ffffffffc020444c:	ca5fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc0204450:	34fd                	addiw	s1,s1,-1
ffffffffc0204452:	b759                	j	ffffffffc02043d8 <readline+0x38>
