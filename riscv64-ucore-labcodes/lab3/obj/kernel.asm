
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
ffffffffc020003e:	53660613          	addi	a2,a2,1334 # ffffffffc0211570 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	7db030ef          	jal	ra,ffffffffc0204024 <memset>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020004e:	00004597          	auipc	a1,0x4
ffffffffc0200052:	4a258593          	addi	a1,a1,1186 # ffffffffc02044f0 <etext>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	4ba50513          	addi	a0,a0,1210 # ffffffffc0204510 <etext+0x20>
ffffffffc020005e:	05c000ef          	jal	ra,ffffffffc02000ba <cprintf>

    print_kerninfo();
ffffffffc0200062:	0fc000ef          	jal	ra,ffffffffc020015e <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc0200066:	773020ef          	jal	ra,ffffffffc0202fd8 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	4fa000ef          	jal	ra,ffffffffc0200564 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020006e:	483000ef          	jal	ra,ffffffffc0200cf0 <vmm_init>

    ide_init();                 // init ide devices
ffffffffc0200072:	35e000ef          	jal	ra,ffffffffc02003d0 <ide_init>
    swap_init();                // init swap
ffffffffc0200076:	344010ef          	jal	ra,ffffffffc02013ba <swap_init>

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
ffffffffc02000ae:	00c040ef          	jal	ra,ffffffffc02040ba <vprintfmt>
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
ffffffffc02000e4:	7d7030ef          	jal	ra,ffffffffc02040ba <vprintfmt>
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
ffffffffc0200134:	3e850513          	addi	a0,a0,1000 # ffffffffc0204518 <etext+0x28>
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
ffffffffc020014a:	e8a50513          	addi	a0,a0,-374 # ffffffffc0205fd0 <default_pmm_manager+0x608>
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
ffffffffc0200164:	3d850513          	addi	a0,a0,984 # ffffffffc0204538 <etext+0x48>
void print_kerninfo(void) {
ffffffffc0200168:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020016a:	f51ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020016e:	00000597          	auipc	a1,0x0
ffffffffc0200172:	ec458593          	addi	a1,a1,-316 # ffffffffc0200032 <kern_init>
ffffffffc0200176:	00004517          	auipc	a0,0x4
ffffffffc020017a:	3e250513          	addi	a0,a0,994 # ffffffffc0204558 <etext+0x68>
ffffffffc020017e:	f3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200182:	00004597          	auipc	a1,0x4
ffffffffc0200186:	36e58593          	addi	a1,a1,878 # ffffffffc02044f0 <etext>
ffffffffc020018a:	00004517          	auipc	a0,0x4
ffffffffc020018e:	3ee50513          	addi	a0,a0,1006 # ffffffffc0204578 <etext+0x88>
ffffffffc0200192:	f29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200196:	0000a597          	auipc	a1,0xa
ffffffffc020019a:	eaa58593          	addi	a1,a1,-342 # ffffffffc020a040 <ide>
ffffffffc020019e:	00004517          	auipc	a0,0x4
ffffffffc02001a2:	3fa50513          	addi	a0,a0,1018 # ffffffffc0204598 <etext+0xa8>
ffffffffc02001a6:	f15ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc02001aa:	00011597          	auipc	a1,0x11
ffffffffc02001ae:	3c658593          	addi	a1,a1,966 # ffffffffc0211570 <end>
ffffffffc02001b2:	00004517          	auipc	a0,0x4
ffffffffc02001b6:	40650513          	addi	a0,a0,1030 # ffffffffc02045b8 <etext+0xc8>
ffffffffc02001ba:	f01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001be:	00011597          	auipc	a1,0x11
ffffffffc02001c2:	7b158593          	addi	a1,a1,1969 # ffffffffc021196f <end+0x3ff>
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
ffffffffc02001e4:	3f850513          	addi	a0,a0,1016 # ffffffffc02045d8 <etext+0xe8>
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
ffffffffc02001f2:	41a60613          	addi	a2,a2,1050 # ffffffffc0204608 <etext+0x118>
ffffffffc02001f6:	04e00593          	li	a1,78
ffffffffc02001fa:	00004517          	auipc	a0,0x4
ffffffffc02001fe:	42650513          	addi	a0,a0,1062 # ffffffffc0204620 <etext+0x130>
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
ffffffffc020020e:	42e60613          	addi	a2,a2,1070 # ffffffffc0204638 <etext+0x148>
ffffffffc0200212:	00004597          	auipc	a1,0x4
ffffffffc0200216:	44658593          	addi	a1,a1,1094 # ffffffffc0204658 <etext+0x168>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	44650513          	addi	a0,a0,1094 # ffffffffc0204660 <etext+0x170>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200222:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00004617          	auipc	a2,0x4
ffffffffc020022c:	44860613          	addi	a2,a2,1096 # ffffffffc0204670 <etext+0x180>
ffffffffc0200230:	00004597          	auipc	a1,0x4
ffffffffc0200234:	46858593          	addi	a1,a1,1128 # ffffffffc0204698 <etext+0x1a8>
ffffffffc0200238:	00004517          	auipc	a0,0x4
ffffffffc020023c:	42850513          	addi	a0,a0,1064 # ffffffffc0204660 <etext+0x170>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200244:	00004617          	auipc	a2,0x4
ffffffffc0200248:	46460613          	addi	a2,a2,1124 # ffffffffc02046a8 <etext+0x1b8>
ffffffffc020024c:	00004597          	auipc	a1,0x4
ffffffffc0200250:	47c58593          	addi	a1,a1,1148 # ffffffffc02046c8 <etext+0x1d8>
ffffffffc0200254:	00004517          	auipc	a0,0x4
ffffffffc0200258:	40c50513          	addi	a0,a0,1036 # ffffffffc0204660 <etext+0x170>
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
ffffffffc0200292:	44a50513          	addi	a0,a0,1098 # ffffffffc02046d8 <etext+0x1e8>
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
ffffffffc02002b4:	45050513          	addi	a0,a0,1104 # ffffffffc0204700 <etext+0x210>
ffffffffc02002b8:	e03ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002bc:	000b8563          	beqz	s7,ffffffffc02002c6 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002c0:	855e                	mv	a0,s7
ffffffffc02002c2:	48c000ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02002c6:	00004c17          	auipc	s8,0x4
ffffffffc02002ca:	4a2c0c13          	addi	s8,s8,1186 # ffffffffc0204768 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc02002ce:	00005917          	auipc	s2,0x5
ffffffffc02002d2:	29a90913          	addi	s2,s2,666 # ffffffffc0205568 <commands+0xe00>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d6:	00004497          	auipc	s1,0x4
ffffffffc02002da:	45248493          	addi	s1,s1,1106 # ffffffffc0204728 <etext+0x238>
        if (argc == MAXARGS - 1) {
ffffffffc02002de:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002e0:	00004b17          	auipc	s6,0x4
ffffffffc02002e4:	450b0b13          	addi	s6,s6,1104 # ffffffffc0204730 <etext+0x240>
        argv[argc ++] = buf;
ffffffffc02002e8:	00004a17          	auipc	s4,0x4
ffffffffc02002ec:	370a0a13          	addi	s4,s4,880 # ffffffffc0204658 <etext+0x168>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f0:	4a8d                	li	s5,3
        if ((buf = readline("")) != NULL) {
ffffffffc02002f2:	854a                	mv	a0,s2
ffffffffc02002f4:	148040ef          	jal	ra,ffffffffc020443c <readline>
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
ffffffffc020030e:	45ed0d13          	addi	s10,s10,1118 # ffffffffc0204768 <commands>
        argv[argc ++] = buf;
ffffffffc0200312:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200314:	4401                	li	s0,0
ffffffffc0200316:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200318:	4d9030ef          	jal	ra,ffffffffc0203ff0 <strcmp>
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
ffffffffc020032c:	4c5030ef          	jal	ra,ffffffffc0203ff0 <strcmp>
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
ffffffffc020036a:	4a5030ef          	jal	ra,ffffffffc020400e <strchr>
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
ffffffffc02003a8:	467030ef          	jal	ra,ffffffffc020400e <strchr>
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
ffffffffc02003c6:	38e50513          	addi	a0,a0,910 # ffffffffc0204750 <etext+0x260>
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
ffffffffc02003f6:	441030ef          	jal	ra,ffffffffc0204036 <memcpy>
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
ffffffffc020041a:	41d030ef          	jal	ra,ffffffffc0204036 <memcpy>
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
ffffffffc0200450:	36450513          	addi	a0,a0,868 # ffffffffc02047b0 <commands+0x48>
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
ffffffffc0200528:	2ac50513          	addi	a0,a0,684 # ffffffffc02047d0 <commands+0x68>
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
ffffffffc0200550:	2a460613          	addi	a2,a2,676 # ffffffffc02047f0 <commands+0x88>
ffffffffc0200554:	07900593          	li	a1,121
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	2b050513          	addi	a0,a0,688 # ffffffffc0204808 <commands+0xa0>
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
ffffffffc020058e:	29650513          	addi	a0,a0,662 # ffffffffc0204820 <commands+0xb8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200592:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200594:	b27ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200598:	640c                	ld	a1,8(s0)
ffffffffc020059a:	00004517          	auipc	a0,0x4
ffffffffc020059e:	29e50513          	addi	a0,a0,670 # ffffffffc0204838 <commands+0xd0>
ffffffffc02005a2:	b19ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005a6:	680c                	ld	a1,16(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	2a850513          	addi	a0,a0,680 # ffffffffc0204850 <commands+0xe8>
ffffffffc02005b0:	b0bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005b4:	6c0c                	ld	a1,24(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	2b250513          	addi	a0,a0,690 # ffffffffc0204868 <commands+0x100>
ffffffffc02005be:	afdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005c2:	700c                	ld	a1,32(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	2bc50513          	addi	a0,a0,700 # ffffffffc0204880 <commands+0x118>
ffffffffc02005cc:	aefff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005d0:	740c                	ld	a1,40(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	2c650513          	addi	a0,a0,710 # ffffffffc0204898 <commands+0x130>
ffffffffc02005da:	ae1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005de:	780c                	ld	a1,48(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	2d050513          	addi	a0,a0,720 # ffffffffc02048b0 <commands+0x148>
ffffffffc02005e8:	ad3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005ec:	7c0c                	ld	a1,56(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	2da50513          	addi	a0,a0,730 # ffffffffc02048c8 <commands+0x160>
ffffffffc02005f6:	ac5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02005fa:	602c                	ld	a1,64(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	2e450513          	addi	a0,a0,740 # ffffffffc02048e0 <commands+0x178>
ffffffffc0200604:	ab7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200608:	642c                	ld	a1,72(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	2ee50513          	addi	a0,a0,750 # ffffffffc02048f8 <commands+0x190>
ffffffffc0200612:	aa9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200616:	682c                	ld	a1,80(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	2f850513          	addi	a0,a0,760 # ffffffffc0204910 <commands+0x1a8>
ffffffffc0200620:	a9bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200624:	6c2c                	ld	a1,88(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	30250513          	addi	a0,a0,770 # ffffffffc0204928 <commands+0x1c0>
ffffffffc020062e:	a8dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200632:	702c                	ld	a1,96(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	30c50513          	addi	a0,a0,780 # ffffffffc0204940 <commands+0x1d8>
ffffffffc020063c:	a7fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200640:	742c                	ld	a1,104(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	31650513          	addi	a0,a0,790 # ffffffffc0204958 <commands+0x1f0>
ffffffffc020064a:	a71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020064e:	782c                	ld	a1,112(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	32050513          	addi	a0,a0,800 # ffffffffc0204970 <commands+0x208>
ffffffffc0200658:	a63ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020065c:	7c2c                	ld	a1,120(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	32a50513          	addi	a0,a0,810 # ffffffffc0204988 <commands+0x220>
ffffffffc0200666:	a55ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020066a:	604c                	ld	a1,128(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	33450513          	addi	a0,a0,820 # ffffffffc02049a0 <commands+0x238>
ffffffffc0200674:	a47ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200678:	644c                	ld	a1,136(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	33e50513          	addi	a0,a0,830 # ffffffffc02049b8 <commands+0x250>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200686:	684c                	ld	a1,144(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	34850513          	addi	a0,a0,840 # ffffffffc02049d0 <commands+0x268>
ffffffffc0200690:	a2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200694:	6c4c                	ld	a1,152(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	35250513          	addi	a0,a0,850 # ffffffffc02049e8 <commands+0x280>
ffffffffc020069e:	a1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006a2:	704c                	ld	a1,160(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	35c50513          	addi	a0,a0,860 # ffffffffc0204a00 <commands+0x298>
ffffffffc02006ac:	a0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006b0:	744c                	ld	a1,168(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	36650513          	addi	a0,a0,870 # ffffffffc0204a18 <commands+0x2b0>
ffffffffc02006ba:	a01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006be:	784c                	ld	a1,176(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	37050513          	addi	a0,a0,880 # ffffffffc0204a30 <commands+0x2c8>
ffffffffc02006c8:	9f3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006cc:	7c4c                	ld	a1,184(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	37a50513          	addi	a0,a0,890 # ffffffffc0204a48 <commands+0x2e0>
ffffffffc02006d6:	9e5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006da:	606c                	ld	a1,192(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	38450513          	addi	a0,a0,900 # ffffffffc0204a60 <commands+0x2f8>
ffffffffc02006e4:	9d7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006e8:	646c                	ld	a1,200(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	38e50513          	addi	a0,a0,910 # ffffffffc0204a78 <commands+0x310>
ffffffffc02006f2:	9c9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02006f6:	686c                	ld	a1,208(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	39850513          	addi	a0,a0,920 # ffffffffc0204a90 <commands+0x328>
ffffffffc0200700:	9bbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200704:	6c6c                	ld	a1,216(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	3a250513          	addi	a0,a0,930 # ffffffffc0204aa8 <commands+0x340>
ffffffffc020070e:	9adff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200712:	706c                	ld	a1,224(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	3ac50513          	addi	a0,a0,940 # ffffffffc0204ac0 <commands+0x358>
ffffffffc020071c:	99fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200720:	746c                	ld	a1,232(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	3b650513          	addi	a0,a0,950 # ffffffffc0204ad8 <commands+0x370>
ffffffffc020072a:	991ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020072e:	786c                	ld	a1,240(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	3c050513          	addi	a0,a0,960 # ffffffffc0204af0 <commands+0x388>
ffffffffc0200738:	983ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020073c:	7c6c                	ld	a1,248(s0)
}
ffffffffc020073e:	6402                	ld	s0,0(sp)
ffffffffc0200740:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	3c650513          	addi	a0,a0,966 # ffffffffc0204b08 <commands+0x3a0>
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
ffffffffc020075a:	3ca50513          	addi	a0,a0,970 # ffffffffc0204b20 <commands+0x3b8>
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
ffffffffc0200772:	3ca50513          	addi	a0,a0,970 # ffffffffc0204b38 <commands+0x3d0>
ffffffffc0200776:	945ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020077a:	10843583          	ld	a1,264(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	3d250513          	addi	a0,a0,978 # ffffffffc0204b50 <commands+0x3e8>
ffffffffc0200786:	935ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020078a:	11043583          	ld	a1,272(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	3da50513          	addi	a0,a0,986 # ffffffffc0204b68 <commands+0x400>
ffffffffc0200796:	925ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020079a:	11843583          	ld	a1,280(s0)
}
ffffffffc020079e:	6402                	ld	s0,0(sp)
ffffffffc02007a0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a2:	00004517          	auipc	a0,0x4
ffffffffc02007a6:	3de50513          	addi	a0,a0,990 # ffffffffc0204b80 <commands+0x418>
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
ffffffffc02007c2:	48a70713          	addi	a4,a4,1162 # ffffffffc0204c48 <commands+0x4e0>
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
ffffffffc02007d4:	42850513          	addi	a0,a0,1064 # ffffffffc0204bf8 <commands+0x490>
ffffffffc02007d8:	8e3ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007dc:	00004517          	auipc	a0,0x4
ffffffffc02007e0:	3fc50513          	addi	a0,a0,1020 # ffffffffc0204bd8 <commands+0x470>
ffffffffc02007e4:	8d7ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007e8:	00004517          	auipc	a0,0x4
ffffffffc02007ec:	3b050513          	addi	a0,a0,944 # ffffffffc0204b98 <commands+0x430>
ffffffffc02007f0:	8cbff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	3c450513          	addi	a0,a0,964 # ffffffffc0204bb8 <commands+0x450>
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
ffffffffc020084a:	3e250513          	addi	a0,a0,994 # ffffffffc0204c28 <commands+0x4c0>
ffffffffc020084e:	86dff06f          	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc0200852:	bdf5                	j	ffffffffc020074e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200854:	06400593          	li	a1,100
ffffffffc0200858:	00004517          	auipc	a0,0x4
ffffffffc020085c:	3c050513          	addi	a0,a0,960 # ffffffffc0204c18 <commands+0x4b0>
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
ffffffffc020088c:	5f070713          	addi	a4,a4,1520 # ffffffffc0204e78 <commands+0x710>
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
ffffffffc020089e:	5c650513          	addi	a0,a0,1478 # ffffffffc0204e60 <commands+0x6f8>
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
ffffffffc02008c0:	3bc50513          	addi	a0,a0,956 # ffffffffc0204c78 <commands+0x510>
}
ffffffffc02008c4:	6442                	ld	s0,16(sp)
ffffffffc02008c6:	60e2                	ld	ra,24(sp)
ffffffffc02008c8:	64a2                	ld	s1,8(sp)
ffffffffc02008ca:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008cc:	feeff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02008d0:	00004517          	auipc	a0,0x4
ffffffffc02008d4:	3c850513          	addi	a0,a0,968 # ffffffffc0204c98 <commands+0x530>
ffffffffc02008d8:	b7f5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("exception type:Illegal instruction\n");
ffffffffc02008da:	00004517          	auipc	a0,0x4
ffffffffc02008de:	3de50513          	addi	a0,a0,990 # ffffffffc0204cb8 <commands+0x550>
ffffffffc02008e2:	fd8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc02008e6:	10843583          	ld	a1,264(s0)
ffffffffc02008ea:	00004517          	auipc	a0,0x4
ffffffffc02008ee:	3f650513          	addi	a0,a0,1014 # ffffffffc0204ce0 <commands+0x578>
ffffffffc02008f2:	fc8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 4;//跳过导致异常的指令
ffffffffc02008f6:	10843783          	ld	a5,264(s0)
ffffffffc02008fa:	0791                	addi	a5,a5,4
ffffffffc02008fc:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc0200900:	bf4d                	j	ffffffffc02008b2 <exception_handler+0x3e>
            cprintf("exception type:breakpoint\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	40650513          	addi	a0,a0,1030 # ffffffffc0204d08 <commands+0x5a0>
ffffffffc020090a:	fb0ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc020090e:	10843583          	ld	a1,264(s0)
ffffffffc0200912:	00004517          	auipc	a0,0x4
ffffffffc0200916:	3ce50513          	addi	a0,a0,974 # ffffffffc0204ce0 <commands+0x578>
ffffffffc020091a:	fa0ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 2;//跳过导致异常的指令
ffffffffc020091e:	10843783          	ld	a5,264(s0)
ffffffffc0200922:	0789                	addi	a5,a5,2
ffffffffc0200924:	10f43423          	sd	a5,264(s0)
            break;
ffffffffc0200928:	b769                	j	ffffffffc02008b2 <exception_handler+0x3e>
            cprintf("Load address misaligned\n");
ffffffffc020092a:	00004517          	auipc	a0,0x4
ffffffffc020092e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0204d28 <commands+0x5c0>
ffffffffc0200932:	bf49                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200934:	00004517          	auipc	a0,0x4
ffffffffc0200938:	41450513          	addi	a0,a0,1044 # ffffffffc0204d48 <commands+0x5e0>
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
ffffffffc0200956:	40e60613          	addi	a2,a2,1038 # ffffffffc0204d60 <commands+0x5f8>
ffffffffc020095a:	0d600593          	li	a1,214
ffffffffc020095e:	00004517          	auipc	a0,0x4
ffffffffc0200962:	eaa50513          	addi	a0,a0,-342 # ffffffffc0204808 <commands+0xa0>
ffffffffc0200966:	f9cff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	41650513          	addi	a0,a0,1046 # ffffffffc0204d80 <commands+0x618>
ffffffffc0200972:	bf89                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	42450513          	addi	a0,a0,1060 # ffffffffc0204d98 <commands+0x630>
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
ffffffffc0200998:	3cc60613          	addi	a2,a2,972 # ffffffffc0204d60 <commands+0x5f8>
ffffffffc020099c:	0e000593          	li	a1,224
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	e6850513          	addi	a0,a0,-408 # ffffffffc0204808 <commands+0xa0>
ffffffffc02009a8:	f5aff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc02009ac:	00004517          	auipc	a0,0x4
ffffffffc02009b0:	40450513          	addi	a0,a0,1028 # ffffffffc0204db0 <commands+0x648>
ffffffffc02009b4:	bf01                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc02009b6:	00004517          	auipc	a0,0x4
ffffffffc02009ba:	41a50513          	addi	a0,a0,1050 # ffffffffc0204dd0 <commands+0x668>
ffffffffc02009be:	b719                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc02009c0:	00004517          	auipc	a0,0x4
ffffffffc02009c4:	43050513          	addi	a0,a0,1072 # ffffffffc0204df0 <commands+0x688>
ffffffffc02009c8:	bdf5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc02009ca:	00004517          	auipc	a0,0x4
ffffffffc02009ce:	44650513          	addi	a0,a0,1094 # ffffffffc0204e10 <commands+0x6a8>
ffffffffc02009d2:	bdcd                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	45c50513          	addi	a0,a0,1116 # ffffffffc0204e30 <commands+0x6c8>
ffffffffc02009dc:	b5e5                	j	ffffffffc02008c4 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc02009de:	00004517          	auipc	a0,0x4
ffffffffc02009e2:	46a50513          	addi	a0,a0,1130 # ffffffffc0204e48 <commands+0x6e0>
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
ffffffffc0200a02:	36260613          	addi	a2,a2,866 # ffffffffc0204d60 <commands+0x5f8>
ffffffffc0200a06:	0f600593          	li	a1,246
ffffffffc0200a0a:	00004517          	auipc	a0,0x4
ffffffffc0200a0e:	dfe50513          	addi	a0,a0,-514 # ffffffffc0204808 <commands+0xa0>
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
ffffffffc0200a2e:	33660613          	addi	a2,a2,822 # ffffffffc0204d60 <commands+0x5f8>
ffffffffc0200a32:	0fd00593          	li	a1,253
ffffffffc0200a36:	00004517          	auipc	a0,0x4
ffffffffc0200a3a:	dd250513          	addi	a0,a0,-558 # ffffffffc0204808 <commands+0xa0>
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
ffffffffc0200b16:	3a668693          	addi	a3,a3,934 # ffffffffc0204eb8 <commands+0x750>
ffffffffc0200b1a:	00004617          	auipc	a2,0x4
ffffffffc0200b1e:	3be60613          	addi	a2,a2,958 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200b22:	07d00593          	li	a1,125
ffffffffc0200b26:	00004517          	auipc	a0,0x4
ffffffffc0200b2a:	3ca50513          	addi	a0,a0,970 # ffffffffc0204ef0 <commands+0x788>
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
ffffffffc0200b3e:	15c030ef          	jal	ra,ffffffffc0203c9a <kmalloc>
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
ffffffffc0200b5a:	9e27a783          	lw	a5,-1566(a5) # ffffffffc0211538 <swap_init_ok>
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
ffffffffc0200b6e:	6b7000ef          	jal	ra,ffffffffc0201a24 <swap_init_mm>
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
ffffffffc0200b90:	10a030ef          	jal	ra,ffffffffc0203c9a <kmalloc>
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
ffffffffc0200c5e:	2a668693          	addi	a3,a3,678 # ffffffffc0204f00 <commands+0x798>
ffffffffc0200c62:	00004617          	auipc	a2,0x4
ffffffffc0200c66:	27660613          	addi	a2,a2,630 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200c6a:	08400593          	li	a1,132
ffffffffc0200c6e:	00004517          	auipc	a0,0x4
ffffffffc0200c72:	28250513          	addi	a0,a0,642 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0200c76:	c8cff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c7a:	00004697          	auipc	a3,0x4
ffffffffc0200c7e:	2c668693          	addi	a3,a3,710 # ffffffffc0204f40 <commands+0x7d8>
ffffffffc0200c82:	00004617          	auipc	a2,0x4
ffffffffc0200c86:	25660613          	addi	a2,a2,598 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200c8a:	07c00593          	li	a1,124
ffffffffc0200c8e:	00004517          	auipc	a0,0x4
ffffffffc0200c92:	26250513          	addi	a0,a0,610 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0200c96:	c6cff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200c9a:	00004697          	auipc	a3,0x4
ffffffffc0200c9e:	28668693          	addi	a3,a3,646 # ffffffffc0204f20 <commands+0x7b8>
ffffffffc0200ca2:	00004617          	auipc	a2,0x4
ffffffffc0200ca6:	23660613          	addi	a2,a2,566 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200caa:	07b00593          	li	a1,123
ffffffffc0200cae:	00004517          	auipc	a0,0x4
ffffffffc0200cb2:	24250513          	addi	a0,a0,578 # ffffffffc0204ef0 <commands+0x788>
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
ffffffffc0200cd6:	07e030ef          	jal	ra,ffffffffc0203d54 <kfree>
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
ffffffffc0200cec:	0680306f          	j	ffffffffc0203d54 <kfree>

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
ffffffffc0200d04:	6b1010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0200d08:	89aa                	mv	s3,a0
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200d0a:	6ab010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0200d0e:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200d10:	03000513          	li	a0,48
ffffffffc0200d14:	787020ef          	jal	ra,ffffffffc0203c9a <kmalloc>
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
ffffffffc0200d30:	80c7a783          	lw	a5,-2036(a5) # ffffffffc0211538 <swap_init_ok>
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
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
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
ffffffffc0200d58:	743020ef          	jal	ra,ffffffffc0203c9a <kmalloc>
ffffffffc0200d5c:	85aa                	mv	a1,a0
ffffffffc0200d5e:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d62:	f165                	bnez	a0,ffffffffc0200d42 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0200d64:	00004697          	auipc	a3,0x4
ffffffffc0200d68:	42c68693          	addi	a3,a3,1068 # ffffffffc0205190 <commands+0xa28>
ffffffffc0200d6c:	00004617          	auipc	a2,0x4
ffffffffc0200d70:	16c60613          	addi	a2,a2,364 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200d74:	0ce00593          	li	a1,206
ffffffffc0200d78:	00004517          	auipc	a0,0x4
ffffffffc0200d7c:	17850513          	addi	a0,a0,376 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0200d80:	b82ff0ef          	jal	ra,ffffffffc0200102 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200d84:	4a1000ef          	jal	ra,ffffffffc0201a24 <swap_init_mm>
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
ffffffffc0200dac:	6ef020ef          	jal	ra,ffffffffc0203c9a <kmalloc>
ffffffffc0200db0:	85aa                	mv	a1,a0
ffffffffc0200db2:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200db6:	fd79                	bnez	a0,ffffffffc0200d94 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0200db8:	00004697          	auipc	a3,0x4
ffffffffc0200dbc:	3d868693          	addi	a3,a3,984 # ffffffffc0205190 <commands+0xa28>
ffffffffc0200dc0:	00004617          	auipc	a2,0x4
ffffffffc0200dc4:	11860613          	addi	a2,a2,280 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200dc8:	0d400593          	li	a1,212
ffffffffc0200dcc:	00004517          	auipc	a0,0x4
ffffffffc0200dd0:	12450513          	addi	a0,a0,292 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0200dd4:	b2eff0ef          	jal	ra,ffffffffc0200102 <__panic>
    return listelm->next;
ffffffffc0200dd8:	649c                	ld	a5,8(s1)
ffffffffc0200dda:	471d                	li	a4,7
    }

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
ffffffffc0200e90:	1d450513          	addi	a0,a0,468 # ffffffffc0205060 <commands+0x8f8>
ffffffffc0200e94:	a26ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0200e98:	00004697          	auipc	a3,0x4
ffffffffc0200e9c:	1f068693          	addi	a3,a3,496 # ffffffffc0205088 <commands+0x920>
ffffffffc0200ea0:	00004617          	auipc	a2,0x4
ffffffffc0200ea4:	03860613          	addi	a2,a2,56 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0200ea8:	0f600593          	li	a1,246
ffffffffc0200eac:	00004517          	auipc	a0,0x4
ffffffffc0200eb0:	04450513          	addi	a0,a0,68 # ffffffffc0204ef0 <commands+0x788>
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
ffffffffc0200ece:	687020ef          	jal	ra,ffffffffc0203d54 <kfree>
    return listelm->next;
ffffffffc0200ed2:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0200ed4:	fea496e3          	bne	s1,a0,ffffffffc0200ec0 <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200ed8:	03000593          	li	a1,48
ffffffffc0200edc:	8526                	mv	a0,s1
ffffffffc0200ede:	677020ef          	jal	ra,ffffffffc0203d54 <kfree>
    }

    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200ee2:	4d3010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0200ee6:	3caa1163          	bne	s4,a0,ffffffffc02012a8 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0200eea:	00004517          	auipc	a0,0x4
ffffffffc0200eee:	1de50513          	addi	a0,a0,478 # ffffffffc02050c8 <commands+0x960>
ffffffffc0200ef2:	9c8ff0ef          	jal	ra,ffffffffc02000ba <cprintf>

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200ef6:	4bf010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0200efa:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200efc:	03000513          	li	a0,48
ffffffffc0200f00:	59b020ef          	jal	ra,ffffffffc0203c9a <kmalloc>
ffffffffc0200f04:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0200f06:	2a050163          	beqz	a0,ffffffffc02011a8 <vmm_init+0x4b8>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200f0a:	00010797          	auipc	a5,0x10
ffffffffc0200f0e:	62e7a783          	lw	a5,1582(a5) # ffffffffc0211538 <swap_init_ok>
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
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0200f2a:	00010917          	auipc	s2,0x10
ffffffffc0200f2e:	61e93903          	ld	s2,1566(s2) # ffffffffc0211548 <boot_pgdir>
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
ffffffffc0200f4a:	551020ef          	jal	ra,ffffffffc0203c9a <kmalloc>
ffffffffc0200f4e:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc0200f50:	28050063          	beqz	a0,ffffffffc02011d0 <vmm_init+0x4e0>
        vma->vm_end = vm_end;
ffffffffc0200f54:	002007b7          	lui	a5,0x200
ffffffffc0200f58:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc0200f5c:	4789                	li	a5,2

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

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc0200f6e:	10000593          	li	a1,256
ffffffffc0200f72:	8522                	mv	a0,s0
ffffffffc0200f74:	c37ff0ef          	jal	ra,ffffffffc0200baa <find_vma>
ffffffffc0200f78:	10000793          	li	a5,256

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
ffffffffc0200fb0:	68f010ef          	jal	ra,ffffffffc0202e3e <page_remove>
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
ffffffffc0200fb4:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0200fb8:	00010717          	auipc	a4,0x10
ffffffffc0200fbc:	59873703          	ld	a4,1432(a4) # ffffffffc0211550 <npage>
    return pa2page(PDE_ADDR(pde));
ffffffffc0200fc0:	078a                	slli	a5,a5,0x2
ffffffffc0200fc2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200fc4:	26e7f663          	bgeu	a5,a4,ffffffffc0201230 <vmm_init+0x540>
    return &pages[PPN(pa) - nbase];
ffffffffc0200fc8:	00005717          	auipc	a4,0x5
ffffffffc0200fcc:	4c073703          	ld	a4,1216(a4) # ffffffffc0206488 <nbase>
ffffffffc0200fd0:	8f99                	sub	a5,a5,a4
ffffffffc0200fd2:	00379713          	slli	a4,a5,0x3
ffffffffc0200fd6:	97ba                	add	a5,a5,a4
ffffffffc0200fd8:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc0200fda:	00010517          	auipc	a0,0x10
ffffffffc0200fde:	57e53503          	ld	a0,1406(a0) # ffffffffc0211558 <pages>
ffffffffc0200fe2:	953e                	add	a0,a0,a5
ffffffffc0200fe4:	4585                	li	a1,1
ffffffffc0200fe6:	38f010ef          	jal	ra,ffffffffc0202b74 <free_pages>
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
ffffffffc0201006:	54f020ef          	jal	ra,ffffffffc0203d54 <kfree>
    return listelm->next;
ffffffffc020100a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc020100c:	fea416e3          	bne	s0,a0,ffffffffc0200ff8 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0201010:	03000593          	li	a1,48
ffffffffc0201014:	8522                	mv	a0,s0
ffffffffc0201016:	53f020ef          	jal	ra,ffffffffc0203d54 <kfree>
    mm_destroy(mm);

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
ffffffffc020101a:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc020101c:	00010797          	auipc	a5,0x10
ffffffffc0201020:	4e07be23          	sd	zero,1276(a5) # ffffffffc0211518 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201024:	391010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0201028:	22a49063          	bne	s1,a0,ffffffffc0201248 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc020102c:	00004517          	auipc	a0,0x4
ffffffffc0201030:	12c50513          	addi	a0,a0,300 # ffffffffc0205158 <commands+0x9f0>
ffffffffc0201034:	886ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201038:	37d010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
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
ffffffffc0201058:	12450513          	addi	a0,a0,292 # ffffffffc0205178 <commands+0xa10>
}
ffffffffc020105c:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc020105e:	85cff06f          	j	ffffffffc02000ba <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201062:	1c3000ef          	jal	ra,ffffffffc0201a24 <swap_init_mm>
ffffffffc0201066:	b5d1                	j	ffffffffc0200f2a <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201068:	00004697          	auipc	a3,0x4
ffffffffc020106c:	f1068693          	addi	a3,a3,-240 # ffffffffc0204f78 <commands+0x810>
ffffffffc0201070:	00004617          	auipc	a2,0x4
ffffffffc0201074:	e6860613          	addi	a2,a2,-408 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201078:	0dd00593          	li	a1,221
ffffffffc020107c:	00004517          	auipc	a0,0x4
ffffffffc0201080:	e7450513          	addi	a0,a0,-396 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201084:	87eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0201088:	00004697          	auipc	a3,0x4
ffffffffc020108c:	fa868693          	addi	a3,a3,-88 # ffffffffc0205030 <commands+0x8c8>
ffffffffc0201090:	00004617          	auipc	a2,0x4
ffffffffc0201094:	e4860613          	addi	a2,a2,-440 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201098:	0ee00593          	li	a1,238
ffffffffc020109c:	00004517          	auipc	a0,0x4
ffffffffc02010a0:	e5450513          	addi	a0,a0,-428 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02010a4:	85eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc02010a8:	00004697          	auipc	a3,0x4
ffffffffc02010ac:	f5868693          	addi	a3,a3,-168 # ffffffffc0205000 <commands+0x898>
ffffffffc02010b0:	00004617          	auipc	a2,0x4
ffffffffc02010b4:	e2860613          	addi	a2,a2,-472 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02010b8:	0ed00593          	li	a1,237
ffffffffc02010bc:	00004517          	auipc	a0,0x4
ffffffffc02010c0:	e3450513          	addi	a0,a0,-460 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02010c4:	83eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02010c8:	00004697          	auipc	a3,0x4
ffffffffc02010cc:	e9868693          	addi	a3,a3,-360 # ffffffffc0204f60 <commands+0x7f8>
ffffffffc02010d0:	00004617          	auipc	a2,0x4
ffffffffc02010d4:	e0860613          	addi	a2,a2,-504 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02010d8:	0db00593          	li	a1,219
ffffffffc02010dc:	00004517          	auipc	a0,0x4
ffffffffc02010e0:	e1450513          	addi	a0,a0,-492 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02010e4:	81eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1 != NULL);
ffffffffc02010e8:	00004697          	auipc	a3,0x4
ffffffffc02010ec:	ec868693          	addi	a3,a3,-312 # ffffffffc0204fb0 <commands+0x848>
ffffffffc02010f0:	00004617          	auipc	a2,0x4
ffffffffc02010f4:	de860613          	addi	a2,a2,-536 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02010f8:	0e300593          	li	a1,227
ffffffffc02010fc:	00004517          	auipc	a0,0x4
ffffffffc0201100:	df450513          	addi	a0,a0,-524 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201104:	ffffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2 != NULL);
ffffffffc0201108:	00004697          	auipc	a3,0x4
ffffffffc020110c:	eb868693          	addi	a3,a3,-328 # ffffffffc0204fc0 <commands+0x858>
ffffffffc0201110:	00004617          	auipc	a2,0x4
ffffffffc0201114:	dc860613          	addi	a2,a2,-568 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201118:	0e500593          	li	a1,229
ffffffffc020111c:	00004517          	auipc	a0,0x4
ffffffffc0201120:	dd450513          	addi	a0,a0,-556 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201124:	fdffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma3 == NULL);
ffffffffc0201128:	00004697          	auipc	a3,0x4
ffffffffc020112c:	ea868693          	addi	a3,a3,-344 # ffffffffc0204fd0 <commands+0x868>
ffffffffc0201130:	00004617          	auipc	a2,0x4
ffffffffc0201134:	da860613          	addi	a2,a2,-600 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201138:	0e700593          	li	a1,231
ffffffffc020113c:	00004517          	auipc	a0,0x4
ffffffffc0201140:	db450513          	addi	a0,a0,-588 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201144:	fbffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma4 == NULL);
ffffffffc0201148:	00004697          	auipc	a3,0x4
ffffffffc020114c:	e9868693          	addi	a3,a3,-360 # ffffffffc0204fe0 <commands+0x878>
ffffffffc0201150:	00004617          	auipc	a2,0x4
ffffffffc0201154:	d8860613          	addi	a2,a2,-632 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201158:	0e900593          	li	a1,233
ffffffffc020115c:	00004517          	auipc	a0,0x4
ffffffffc0201160:	d9450513          	addi	a0,a0,-620 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201164:	f9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma5 == NULL);
ffffffffc0201168:	00004697          	auipc	a3,0x4
ffffffffc020116c:	e8868693          	addi	a3,a3,-376 # ffffffffc0204ff0 <commands+0x888>
ffffffffc0201170:	00004617          	auipc	a2,0x4
ffffffffc0201174:	d6860613          	addi	a2,a2,-664 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201178:	0eb00593          	li	a1,235
ffffffffc020117c:	00004517          	auipc	a0,0x4
ffffffffc0201180:	d7450513          	addi	a0,a0,-652 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201184:	f7ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0201188:	00004697          	auipc	a3,0x4
ffffffffc020118c:	f6068693          	addi	a3,a3,-160 # ffffffffc02050e8 <commands+0x980>
ffffffffc0201190:	00004617          	auipc	a2,0x4
ffffffffc0201194:	d4860613          	addi	a2,a2,-696 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201198:	10d00593          	li	a1,269
ffffffffc020119c:	00004517          	auipc	a0,0x4
ffffffffc02011a0:	d5450513          	addi	a0,a0,-684 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02011a4:	f5ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc02011a8:	00004697          	auipc	a3,0x4
ffffffffc02011ac:	ff868693          	addi	a3,a3,-8 # ffffffffc02051a0 <commands+0xa38>
ffffffffc02011b0:	00004617          	auipc	a2,0x4
ffffffffc02011b4:	d2860613          	addi	a2,a2,-728 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02011b8:	10a00593          	li	a1,266
ffffffffc02011bc:	00004517          	auipc	a0,0x4
ffffffffc02011c0:	d3450513          	addi	a0,a0,-716 # ffffffffc0204ef0 <commands+0x788>
    check_mm_struct = mm_create();
ffffffffc02011c4:	00010797          	auipc	a5,0x10
ffffffffc02011c8:	3407ba23          	sd	zero,852(a5) # ffffffffc0211518 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc02011cc:	f37fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(vma != NULL);
ffffffffc02011d0:	00004697          	auipc	a3,0x4
ffffffffc02011d4:	fc068693          	addi	a3,a3,-64 # ffffffffc0205190 <commands+0xa28>
ffffffffc02011d8:	00004617          	auipc	a2,0x4
ffffffffc02011dc:	d0060613          	addi	a2,a2,-768 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02011e0:	11100593          	li	a1,273
ffffffffc02011e4:	00004517          	auipc	a0,0x4
ffffffffc02011e8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02011ec:	f17fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc02011f0:	00004697          	auipc	a3,0x4
ffffffffc02011f4:	f0868693          	addi	a3,a3,-248 # ffffffffc02050f8 <commands+0x990>
ffffffffc02011f8:	00004617          	auipc	a2,0x4
ffffffffc02011fc:	ce060613          	addi	a2,a2,-800 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201200:	11600593          	li	a1,278
ffffffffc0201204:	00004517          	auipc	a0,0x4
ffffffffc0201208:	cec50513          	addi	a0,a0,-788 # ffffffffc0204ef0 <commands+0x788>
ffffffffc020120c:	ef7fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(sum == 0);
ffffffffc0201210:	00004697          	auipc	a3,0x4
ffffffffc0201214:	f0868693          	addi	a3,a3,-248 # ffffffffc0205118 <commands+0x9b0>
ffffffffc0201218:	00004617          	auipc	a2,0x4
ffffffffc020121c:	cc060613          	addi	a2,a2,-832 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201220:	12000593          	li	a1,288
ffffffffc0201224:	00004517          	auipc	a0,0x4
ffffffffc0201228:	ccc50513          	addi	a0,a0,-820 # ffffffffc0204ef0 <commands+0x788>
ffffffffc020122c:	ed7fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201230:	00004617          	auipc	a2,0x4
ffffffffc0201234:	ef860613          	addi	a2,a2,-264 # ffffffffc0205128 <commands+0x9c0>
ffffffffc0201238:	06500593          	li	a1,101
ffffffffc020123c:	00004517          	auipc	a0,0x4
ffffffffc0201240:	f0c50513          	addi	a0,a0,-244 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0201244:	ebffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201248:	00004697          	auipc	a3,0x4
ffffffffc020124c:	e5868693          	addi	a3,a3,-424 # ffffffffc02050a0 <commands+0x938>
ffffffffc0201250:	00004617          	auipc	a2,0x4
ffffffffc0201254:	c8860613          	addi	a2,a2,-888 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201258:	12e00593          	li	a1,302
ffffffffc020125c:	00004517          	auipc	a0,0x4
ffffffffc0201260:	c9450513          	addi	a0,a0,-876 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201264:	e9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201268:	00004697          	auipc	a3,0x4
ffffffffc020126c:	e3868693          	addi	a3,a3,-456 # ffffffffc02050a0 <commands+0x938>
ffffffffc0201270:	00004617          	auipc	a2,0x4
ffffffffc0201274:	c6860613          	addi	a2,a2,-920 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201278:	0bd00593          	li	a1,189
ffffffffc020127c:	00004517          	auipc	a0,0x4
ffffffffc0201280:	c7450513          	addi	a0,a0,-908 # ffffffffc0204ef0 <commands+0x788>
ffffffffc0201284:	e7ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(mm != NULL);
ffffffffc0201288:	00004697          	auipc	a3,0x4
ffffffffc020128c:	f3068693          	addi	a3,a3,-208 # ffffffffc02051b8 <commands+0xa50>
ffffffffc0201290:	00004617          	auipc	a2,0x4
ffffffffc0201294:	c4860613          	addi	a2,a2,-952 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201298:	0c700593          	li	a1,199
ffffffffc020129c:	00004517          	auipc	a0,0x4
ffffffffc02012a0:	c5450513          	addi	a0,a0,-940 # ffffffffc0204ef0 <commands+0x788>
ffffffffc02012a4:	e5ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02012a8:	00004697          	auipc	a3,0x4
ffffffffc02012ac:	df868693          	addi	a3,a3,-520 # ffffffffc02050a0 <commands+0x938>
ffffffffc02012b0:	00004617          	auipc	a2,0x4
ffffffffc02012b4:	c2860613          	addi	a2,a2,-984 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02012b8:	0fb00593          	li	a1,251
ffffffffc02012bc:	00004517          	auipc	a0,0x4
ffffffffc02012c0:	c3450513          	addi	a0,a0,-972 # ffffffffc0204ef0 <commands+0x788>
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
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
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


    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0201300:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0201302:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0201304:	85a2                	mv	a1,s0
ffffffffc0201306:	4605                	li	a2,1
ffffffffc0201308:	0e7010ef          	jal	ra,ffffffffc0202bee <get_pte>
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
ffffffffc0201314:	2287a783          	lw	a5,552(a5) # ffffffffc0211538 <swap_init_ok>
ffffffffc0201318:	cbad                	beqz	a5,ffffffffc020138a <do_pgfault+0xc2>
            struct Page *page = NULL;
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc020131a:	0030                	addi	a2,sp,8
ffffffffc020131c:	85a2                	mv	a1,s0
ffffffffc020131e:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0201320:	e402                	sd	zero,8(sp)
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc0201322:	02f000ef          	jal	ra,ffffffffc0201b50 <swap_in>
ffffffffc0201326:	e935                	bnez	a0,ffffffffc020139a <do_pgfault+0xd2>
            }
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            if (page_insert(mm->pgdir, page, addr, perm) != 0){
ffffffffc0201328:	65a2                	ld	a1,8(sp)
ffffffffc020132a:	6c88                	ld	a0,24(s1)
ffffffffc020132c:	86ca                	mv	a3,s2
ffffffffc020132e:	8622                	mv	a2,s0
ffffffffc0201330:	3a9010ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0201334:	892a                	mv	s2,a0
ffffffffc0201336:	e935                	bnez	a0,ffffffffc02013aa <do_pgfault+0xe2>
                cprintf("page_insert in do_pgfault failed\n");
                goto failed;
            }
            //(3) make the page swappable.
             // 标记页面为可交换
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0201338:	6622                	ld	a2,8(sp)
ffffffffc020133a:	4685                	li	a3,1
ffffffffc020133c:	85a2                	mv	a1,s0
ffffffffc020133e:	8526                	mv	a0,s1
ffffffffc0201340:	6f0000ef          	jal	ra,ffffffffc0201a30 <swap_map_swappable>


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
ffffffffc0201360:	083020ef          	jal	ra,ffffffffc0203be2 <pgdir_alloc_page>
   ret = 0;
ffffffffc0201364:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201366:	f16d                	bnez	a0,ffffffffc0201348 <do_pgfault+0x80>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0201368:	00004517          	auipc	a0,0x4
ffffffffc020136c:	e9050513          	addi	a0,a0,-368 # ffffffffc02051f8 <commands+0xa90>
ffffffffc0201370:	d4bfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201374:	5971                	li	s2,-4
            goto failed;
ffffffffc0201376:	bfc9                	j	ffffffffc0201348 <do_pgfault+0x80>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0201378:	85a2                	mv	a1,s0
ffffffffc020137a:	00004517          	auipc	a0,0x4
ffffffffc020137e:	e4e50513          	addi	a0,a0,-434 # ffffffffc02051c8 <commands+0xa60>
ffffffffc0201382:	d39fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = -E_INVAL;
ffffffffc0201386:	5975                	li	s2,-3
        goto failed;
ffffffffc0201388:	b7c1                	j	ffffffffc0201348 <do_pgfault+0x80>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc020138a:	00004517          	auipc	a0,0x4
ffffffffc020138e:	ede50513          	addi	a0,a0,-290 # ffffffffc0205268 <commands+0xb00>
ffffffffc0201392:	d29fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201396:	5971                	li	s2,-4
            goto failed;
ffffffffc0201398:	bf45                	j	ffffffffc0201348 <do_pgfault+0x80>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc020139a:	00004517          	auipc	a0,0x4
ffffffffc020139e:	e8650513          	addi	a0,a0,-378 # ffffffffc0205220 <commands+0xab8>
ffffffffc02013a2:	d19fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc02013a6:	5971                	li	s2,-4
ffffffffc02013a8:	b745                	j	ffffffffc0201348 <do_pgfault+0x80>
                cprintf("page_insert in do_pgfault failed\n");
ffffffffc02013aa:	00004517          	auipc	a0,0x4
ffffffffc02013ae:	e9650513          	addi	a0,a0,-362 # ffffffffc0205240 <commands+0xad8>
ffffffffc02013b2:	d09fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc02013b6:	5971                	li	s2,-4
ffffffffc02013b8:	bf41                	j	ffffffffc0201348 <do_pgfault+0x80>

ffffffffc02013ba <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc02013ba:	7135                	addi	sp,sp,-160
ffffffffc02013bc:	ed06                	sd	ra,152(sp)
ffffffffc02013be:	e922                	sd	s0,144(sp)
ffffffffc02013c0:	e526                	sd	s1,136(sp)
ffffffffc02013c2:	e14a                	sd	s2,128(sp)
ffffffffc02013c4:	fcce                	sd	s3,120(sp)
ffffffffc02013c6:	f8d2                	sd	s4,112(sp)
ffffffffc02013c8:	f4d6                	sd	s5,104(sp)
ffffffffc02013ca:	f0da                	sd	s6,96(sp)
ffffffffc02013cc:	ecde                	sd	s7,88(sp)
ffffffffc02013ce:	e8e2                	sd	s8,80(sp)
ffffffffc02013d0:	e4e6                	sd	s9,72(sp)
ffffffffc02013d2:	e0ea                	sd	s10,64(sp)
ffffffffc02013d4:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc02013d6:	267020ef          	jal	ra,ffffffffc0203e3c <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc02013da:	00010697          	auipc	a3,0x10
ffffffffc02013de:	14e6b683          	ld	a3,334(a3) # ffffffffc0211528 <max_swap_offset>
ffffffffc02013e2:	010007b7          	lui	a5,0x1000
ffffffffc02013e6:	ff968713          	addi	a4,a3,-7
ffffffffc02013ea:	17e1                	addi	a5,a5,-8
ffffffffc02013ec:	3ee7e063          	bltu	a5,a4,ffffffffc02017cc <swap_init+0x412>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     //sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
     sm = &swap_manager_lru;
ffffffffc02013f0:	00009797          	auipc	a5,0x9
ffffffffc02013f4:	c1078793          	addi	a5,a5,-1008 # ffffffffc020a000 <swap_manager_lru>
     int r = sm->init();
ffffffffc02013f8:	6798                	ld	a4,8(a5)
     sm = &swap_manager_lru;
ffffffffc02013fa:	00010b17          	auipc	s6,0x10
ffffffffc02013fe:	136b0b13          	addi	s6,s6,310 # ffffffffc0211530 <sm>
ffffffffc0201402:	00fb3023          	sd	a5,0(s6)
     int r = sm->init();
ffffffffc0201406:	9702                	jalr	a4
ffffffffc0201408:	89aa                	mv	s3,a0
     
     if (r == 0)
ffffffffc020140a:	c10d                	beqz	a0,ffffffffc020142c <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020140c:	60ea                	ld	ra,152(sp)
ffffffffc020140e:	644a                	ld	s0,144(sp)
ffffffffc0201410:	64aa                	ld	s1,136(sp)
ffffffffc0201412:	690a                	ld	s2,128(sp)
ffffffffc0201414:	7a46                	ld	s4,112(sp)
ffffffffc0201416:	7aa6                	ld	s5,104(sp)
ffffffffc0201418:	7b06                	ld	s6,96(sp)
ffffffffc020141a:	6be6                	ld	s7,88(sp)
ffffffffc020141c:	6c46                	ld	s8,80(sp)
ffffffffc020141e:	6ca6                	ld	s9,72(sp)
ffffffffc0201420:	6d06                	ld	s10,64(sp)
ffffffffc0201422:	7de2                	ld	s11,56(sp)
ffffffffc0201424:	854e                	mv	a0,s3
ffffffffc0201426:	79e6                	ld	s3,120(sp)
ffffffffc0201428:	610d                	addi	sp,sp,160
ffffffffc020142a:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020142c:	000b3783          	ld	a5,0(s6)
ffffffffc0201430:	00004517          	auipc	a0,0x4
ffffffffc0201434:	e9050513          	addi	a0,a0,-368 # ffffffffc02052c0 <commands+0xb58>
ffffffffc0201438:	00010497          	auipc	s1,0x10
ffffffffc020143c:	ca848493          	addi	s1,s1,-856 # ffffffffc02110e0 <free_area>
ffffffffc0201440:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0201442:	4785                	li	a5,1
ffffffffc0201444:	00010717          	auipc	a4,0x10
ffffffffc0201448:	0ef72a23          	sw	a5,244(a4) # ffffffffc0211538 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020144c:	c6ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201450:	649c                	ld	a5,8(s1)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc0201452:	4401                	li	s0,0
ffffffffc0201454:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201456:	2c978163          	beq	a5,s1,ffffffffc0201718 <swap_init+0x35e>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020145a:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020145e:	8b09                	andi	a4,a4,2
ffffffffc0201460:	2a070e63          	beqz	a4,ffffffffc020171c <swap_init+0x362>
        count ++, total += p->property;
ffffffffc0201464:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201468:	679c                	ld	a5,8(a5)
ffffffffc020146a:	2d05                	addiw	s10,s10,1
ffffffffc020146c:	9c39                	addw	s0,s0,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc020146e:	fe9796e3          	bne	a5,s1,ffffffffc020145a <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc0201472:	8922                	mv	s2,s0
ffffffffc0201474:	740010ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0201478:	47251663          	bne	a0,s2,ffffffffc02018e4 <swap_init+0x52a>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc020147c:	8622                	mv	a2,s0
ffffffffc020147e:	85ea                	mv	a1,s10
ffffffffc0201480:	00004517          	auipc	a0,0x4
ffffffffc0201484:	e8850513          	addi	a0,a0,-376 # ffffffffc0205308 <commands+0xba0>
ffffffffc0201488:	c33fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc020148c:	ea8ff0ef          	jal	ra,ffffffffc0200b34 <mm_create>
ffffffffc0201490:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc0201492:	52050963          	beqz	a0,ffffffffc02019c4 <swap_init+0x60a>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0201496:	00010797          	auipc	a5,0x10
ffffffffc020149a:	08278793          	addi	a5,a5,130 # ffffffffc0211518 <check_mm_struct>
ffffffffc020149e:	6398                	ld	a4,0(a5)
ffffffffc02014a0:	54071263          	bnez	a4,ffffffffc02019e4 <swap_init+0x62a>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02014a4:	00010b97          	auipc	s7,0x10
ffffffffc02014a8:	0a4bbb83          	ld	s7,164(s7) # ffffffffc0211548 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc02014ac:	000bb703          	ld	a4,0(s7)
     check_mm_struct = mm;
ffffffffc02014b0:	e388                	sd	a0,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02014b2:	01753c23          	sd	s7,24(a0)
     assert(pgdir[0] == 0);
ffffffffc02014b6:	3c071763          	bnez	a4,ffffffffc0201884 <swap_init+0x4ca>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc02014ba:	6599                	lui	a1,0x6
ffffffffc02014bc:	460d                	li	a2,3
ffffffffc02014be:	6505                	lui	a0,0x1
ffffffffc02014c0:	ebcff0ef          	jal	ra,ffffffffc0200b7c <vma_create>
ffffffffc02014c4:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc02014c6:	3c050f63          	beqz	a0,ffffffffc02018a4 <swap_init+0x4ea>

     insert_vma_struct(mm, vma);
ffffffffc02014ca:	8556                	mv	a0,s5
ffffffffc02014cc:	f1eff0ef          	jal	ra,ffffffffc0200bea <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc02014d0:	00004517          	auipc	a0,0x4
ffffffffc02014d4:	e7850513          	addi	a0,a0,-392 # ffffffffc0205348 <commands+0xbe0>
ffffffffc02014d8:	be3fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc02014dc:	018ab503          	ld	a0,24(s5)
ffffffffc02014e0:	4605                	li	a2,1
ffffffffc02014e2:	6585                	lui	a1,0x1
ffffffffc02014e4:	70a010ef          	jal	ra,ffffffffc0202bee <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc02014e8:	3c050e63          	beqz	a0,ffffffffc02018c4 <swap_init+0x50a>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc02014ec:	00004517          	auipc	a0,0x4
ffffffffc02014f0:	eac50513          	addi	a0,a0,-340 # ffffffffc0205398 <commands+0xc30>
ffffffffc02014f4:	00010917          	auipc	s2,0x10
ffffffffc02014f8:	b7c90913          	addi	s2,s2,-1156 # ffffffffc0211070 <check_rp>
ffffffffc02014fc:	bbffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201500:	00010a17          	auipc	s4,0x10
ffffffffc0201504:	b90a0a13          	addi	s4,s4,-1136 # ffffffffc0211090 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0201508:	8c4a                	mv	s8,s2
          check_rp[i] = alloc_page();
ffffffffc020150a:	4505                	li	a0,1
ffffffffc020150c:	5d6010ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201510:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc0201514:	28050c63          	beqz	a0,ffffffffc02017ac <swap_init+0x3f2>
ffffffffc0201518:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc020151a:	8b89                	andi	a5,a5,2
ffffffffc020151c:	26079863          	bnez	a5,ffffffffc020178c <swap_init+0x3d2>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201520:	0c21                	addi	s8,s8,8
ffffffffc0201522:	ff4c14e3          	bne	s8,s4,ffffffffc020150a <swap_init+0x150>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0201526:	609c                	ld	a5,0(s1)
ffffffffc0201528:	0084bd83          	ld	s11,8(s1)
    elm->prev = elm->next = elm;
ffffffffc020152c:	e084                	sd	s1,0(s1)
ffffffffc020152e:	f03e                	sd	a5,32(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc0201530:	489c                	lw	a5,16(s1)
ffffffffc0201532:	e484                	sd	s1,8(s1)
     nr_free = 0;
ffffffffc0201534:	00010c17          	auipc	s8,0x10
ffffffffc0201538:	b3cc0c13          	addi	s8,s8,-1220 # ffffffffc0211070 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc020153c:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc020153e:	00010797          	auipc	a5,0x10
ffffffffc0201542:	ba07a923          	sw	zero,-1102(a5) # ffffffffc02110f0 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0201546:	000c3503          	ld	a0,0(s8)
ffffffffc020154a:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020154c:	0c21                	addi	s8,s8,8
        free_pages(check_rp[i],1);
ffffffffc020154e:	626010ef          	jal	ra,ffffffffc0202b74 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201552:	ff4c1ae3          	bne	s8,s4,ffffffffc0201546 <swap_init+0x18c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0201556:	0104ac03          	lw	s8,16(s1)
ffffffffc020155a:	4791                	li	a5,4
ffffffffc020155c:	4afc1463          	bne	s8,a5,ffffffffc0201a04 <swap_init+0x64a>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0201560:	00004517          	auipc	a0,0x4
ffffffffc0201564:	ec050513          	addi	a0,a0,-320 # ffffffffc0205420 <commands+0xcb8>
ffffffffc0201568:	b53fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc020156c:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc020156e:	00010797          	auipc	a5,0x10
ffffffffc0201572:	fa07a923          	sw	zero,-78(a5) # ffffffffc0211520 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201576:	4529                	li	a0,10
ffffffffc0201578:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc020157c:	00010597          	auipc	a1,0x10
ffffffffc0201580:	fa45a583          	lw	a1,-92(a1) # ffffffffc0211520 <pgfault_num>
ffffffffc0201584:	4805                	li	a6,1
ffffffffc0201586:	00010797          	auipc	a5,0x10
ffffffffc020158a:	f9a78793          	addi	a5,a5,-102 # ffffffffc0211520 <pgfault_num>
ffffffffc020158e:	3f059b63          	bne	a1,a6,ffffffffc0201984 <swap_init+0x5ca>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0201592:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0201596:	4390                	lw	a2,0(a5)
ffffffffc0201598:	2601                	sext.w	a2,a2
ffffffffc020159a:	40b61563          	bne	a2,a1,ffffffffc02019a4 <swap_init+0x5ea>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc020159e:	6589                	lui	a1,0x2
ffffffffc02015a0:	452d                	li	a0,11
ffffffffc02015a2:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc02015a6:	4390                	lw	a2,0(a5)
ffffffffc02015a8:	4809                	li	a6,2
ffffffffc02015aa:	2601                	sext.w	a2,a2
ffffffffc02015ac:	35061c63          	bne	a2,a6,ffffffffc0201904 <swap_init+0x54a>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc02015b0:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc02015b4:	438c                	lw	a1,0(a5)
ffffffffc02015b6:	2581                	sext.w	a1,a1
ffffffffc02015b8:	36c59663          	bne	a1,a2,ffffffffc0201924 <swap_init+0x56a>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc02015bc:	658d                	lui	a1,0x3
ffffffffc02015be:	4531                	li	a0,12
ffffffffc02015c0:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc02015c4:	4390                	lw	a2,0(a5)
ffffffffc02015c6:	480d                	li	a6,3
ffffffffc02015c8:	2601                	sext.w	a2,a2
ffffffffc02015ca:	37061d63          	bne	a2,a6,ffffffffc0201944 <swap_init+0x58a>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc02015ce:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc02015d2:	438c                	lw	a1,0(a5)
ffffffffc02015d4:	2581                	sext.w	a1,a1
ffffffffc02015d6:	38c59763          	bne	a1,a2,ffffffffc0201964 <swap_init+0x5aa>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc02015da:	6591                	lui	a1,0x4
ffffffffc02015dc:	4535                	li	a0,13
ffffffffc02015de:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc02015e2:	4390                	lw	a2,0(a5)
ffffffffc02015e4:	2601                	sext.w	a2,a2
ffffffffc02015e6:	21861f63          	bne	a2,s8,ffffffffc0201804 <swap_init+0x44a>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc02015ea:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc02015ee:	439c                	lw	a5,0(a5)
ffffffffc02015f0:	2781                	sext.w	a5,a5
ffffffffc02015f2:	22c79963          	bne	a5,a2,ffffffffc0201824 <swap_init+0x46a>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc02015f6:	489c                	lw	a5,16(s1)
ffffffffc02015f8:	24079663          	bnez	a5,ffffffffc0201844 <swap_init+0x48a>
ffffffffc02015fc:	00010797          	auipc	a5,0x10
ffffffffc0201600:	a9478793          	addi	a5,a5,-1388 # ffffffffc0211090 <swap_in_seq_no>
ffffffffc0201604:	00010617          	auipc	a2,0x10
ffffffffc0201608:	ab460613          	addi	a2,a2,-1356 # ffffffffc02110b8 <swap_out_seq_no>
ffffffffc020160c:	00010517          	auipc	a0,0x10
ffffffffc0201610:	aac50513          	addi	a0,a0,-1364 # ffffffffc02110b8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0201614:	55fd                	li	a1,-1
ffffffffc0201616:	c38c                	sw	a1,0(a5)
ffffffffc0201618:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc020161a:	0791                	addi	a5,a5,4
ffffffffc020161c:	0611                	addi	a2,a2,4
ffffffffc020161e:	fef51ce3          	bne	a0,a5,ffffffffc0201616 <swap_init+0x25c>
ffffffffc0201622:	00010817          	auipc	a6,0x10
ffffffffc0201626:	a2e80813          	addi	a6,a6,-1490 # ffffffffc0211050 <check_ptep>
ffffffffc020162a:	00010897          	auipc	a7,0x10
ffffffffc020162e:	a4688893          	addi	a7,a7,-1466 # ffffffffc0211070 <check_rp>
ffffffffc0201632:	6585                	lui	a1,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc0201634:	00010c97          	auipc	s9,0x10
ffffffffc0201638:	f24c8c93          	addi	s9,s9,-220 # ffffffffc0211558 <pages>
ffffffffc020163c:	00005c17          	auipc	s8,0x5
ffffffffc0201640:	e4cc0c13          	addi	s8,s8,-436 # ffffffffc0206488 <nbase>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0201644:	00083023          	sd	zero,0(a6)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0201648:	4601                	li	a2,0
ffffffffc020164a:	855e                	mv	a0,s7
ffffffffc020164c:	ec46                	sd	a7,24(sp)
ffffffffc020164e:	e82e                	sd	a1,16(sp)
         check_ptep[i]=0;
ffffffffc0201650:	e442                	sd	a6,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0201652:	59c010ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc0201656:	6822                	ld	a6,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0201658:	65c2                	ld	a1,16(sp)
ffffffffc020165a:	68e2                	ld	a7,24(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020165c:	00a83023          	sd	a0,0(a6)
         assert(check_ptep[i] != NULL);
ffffffffc0201660:	00010317          	auipc	t1,0x10
ffffffffc0201664:	ef030313          	addi	t1,t1,-272 # ffffffffc0211550 <npage>
ffffffffc0201668:	16050e63          	beqz	a0,ffffffffc02017e4 <swap_init+0x42a>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020166c:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020166e:	0017f613          	andi	a2,a5,1
ffffffffc0201672:	0e060563          	beqz	a2,ffffffffc020175c <swap_init+0x3a2>
    if (PPN(pa) >= npage) {
ffffffffc0201676:	00033603          	ld	a2,0(t1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020167a:	078a                	slli	a5,a5,0x2
ffffffffc020167c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020167e:	0ec7fb63          	bgeu	a5,a2,ffffffffc0201774 <swap_init+0x3ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0201682:	000c3603          	ld	a2,0(s8)
ffffffffc0201686:	000cb503          	ld	a0,0(s9)
ffffffffc020168a:	0008bf03          	ld	t5,0(a7)
ffffffffc020168e:	8f91                	sub	a5,a5,a2
ffffffffc0201690:	00379613          	slli	a2,a5,0x3
ffffffffc0201694:	97b2                	add	a5,a5,a2
ffffffffc0201696:	078e                	slli	a5,a5,0x3
ffffffffc0201698:	97aa                	add	a5,a5,a0
ffffffffc020169a:	0aff1163          	bne	t5,a5,ffffffffc020173c <swap_init+0x382>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020169e:	6785                	lui	a5,0x1
ffffffffc02016a0:	95be                	add	a1,a1,a5
ffffffffc02016a2:	6795                	lui	a5,0x5
ffffffffc02016a4:	0821                	addi	a6,a6,8
ffffffffc02016a6:	08a1                	addi	a7,a7,8
ffffffffc02016a8:	f8f59ee3          	bne	a1,a5,ffffffffc0201644 <swap_init+0x28a>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc02016ac:	00004517          	auipc	a0,0x4
ffffffffc02016b0:	e5450513          	addi	a0,a0,-428 # ffffffffc0205500 <commands+0xd98>
ffffffffc02016b4:	a07fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = sm->check_swap();
ffffffffc02016b8:	000b3783          	ld	a5,0(s6)
ffffffffc02016bc:	7f9c                	ld	a5,56(a5)
ffffffffc02016be:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc02016c0:	1a051263          	bnez	a0,ffffffffc0201864 <swap_init+0x4aa>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc02016c4:	00093503          	ld	a0,0(s2)
ffffffffc02016c8:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02016ca:	0921                	addi	s2,s2,8
         free_pages(check_rp[i],1);
ffffffffc02016cc:	4a8010ef          	jal	ra,ffffffffc0202b74 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02016d0:	ff491ae3          	bne	s2,s4,ffffffffc02016c4 <swap_init+0x30a>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc02016d4:	8556                	mv	a0,s5
ffffffffc02016d6:	de4ff0ef          	jal	ra,ffffffffc0200cba <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc02016da:	77a2                	ld	a5,40(sp)
     free_list = free_list_store;
ffffffffc02016dc:	01b4b423          	sd	s11,8(s1)
     nr_free = nr_free_store;
ffffffffc02016e0:	c89c                	sw	a5,16(s1)
     free_list = free_list_store;
ffffffffc02016e2:	7782                	ld	a5,32(sp)
ffffffffc02016e4:	e09c                	sd	a5,0(s1)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016e6:	009d8a63          	beq	s11,s1,ffffffffc02016fa <swap_init+0x340>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc02016ea:	ff8da783          	lw	a5,-8(s11)
    return listelm->next;
ffffffffc02016ee:	008dbd83          	ld	s11,8(s11)
ffffffffc02016f2:	3d7d                	addiw	s10,s10,-1
ffffffffc02016f4:	9c1d                	subw	s0,s0,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016f6:	fe9d9ae3          	bne	s11,s1,ffffffffc02016ea <swap_init+0x330>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc02016fa:	8622                	mv	a2,s0
ffffffffc02016fc:	85ea                	mv	a1,s10
ffffffffc02016fe:	00004517          	auipc	a0,0x4
ffffffffc0201702:	e3250513          	addi	a0,a0,-462 # ffffffffc0205530 <commands+0xdc8>
ffffffffc0201706:	9b5fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc020170a:	00004517          	auipc	a0,0x4
ffffffffc020170e:	e4650513          	addi	a0,a0,-442 # ffffffffc0205550 <commands+0xde8>
ffffffffc0201712:	9a9fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201716:	b9dd                	j	ffffffffc020140c <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201718:	4901                	li	s2,0
ffffffffc020171a:	bba9                	j	ffffffffc0201474 <swap_init+0xba>
        assert(PageProperty(p));
ffffffffc020171c:	00004697          	auipc	a3,0x4
ffffffffc0201720:	bbc68693          	addi	a3,a3,-1092 # ffffffffc02052d8 <commands+0xb70>
ffffffffc0201724:	00003617          	auipc	a2,0x3
ffffffffc0201728:	7b460613          	addi	a2,a2,1972 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020172c:	0bc00593          	li	a1,188
ffffffffc0201730:	00004517          	auipc	a0,0x4
ffffffffc0201734:	b8050513          	addi	a0,a0,-1152 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201738:	9cbfe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020173c:	00004697          	auipc	a3,0x4
ffffffffc0201740:	d9c68693          	addi	a3,a3,-612 # ffffffffc02054d8 <commands+0xd70>
ffffffffc0201744:	00003617          	auipc	a2,0x3
ffffffffc0201748:	79460613          	addi	a2,a2,1940 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020174c:	0fc00593          	li	a1,252
ffffffffc0201750:	00004517          	auipc	a0,0x4
ffffffffc0201754:	b6050513          	addi	a0,a0,-1184 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201758:	9abfe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020175c:	00004617          	auipc	a2,0x4
ffffffffc0201760:	d5460613          	addi	a2,a2,-684 # ffffffffc02054b0 <commands+0xd48>
ffffffffc0201764:	07000593          	li	a1,112
ffffffffc0201768:	00004517          	auipc	a0,0x4
ffffffffc020176c:	9e050513          	addi	a0,a0,-1568 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0201770:	993fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201774:	00004617          	auipc	a2,0x4
ffffffffc0201778:	9b460613          	addi	a2,a2,-1612 # ffffffffc0205128 <commands+0x9c0>
ffffffffc020177c:	06500593          	li	a1,101
ffffffffc0201780:	00004517          	auipc	a0,0x4
ffffffffc0201784:	9c850513          	addi	a0,a0,-1592 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0201788:	97bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc020178c:	00004697          	auipc	a3,0x4
ffffffffc0201790:	c4c68693          	addi	a3,a3,-948 # ffffffffc02053d8 <commands+0xc70>
ffffffffc0201794:	00003617          	auipc	a2,0x3
ffffffffc0201798:	74460613          	addi	a2,a2,1860 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020179c:	0dd00593          	li	a1,221
ffffffffc02017a0:	00004517          	auipc	a0,0x4
ffffffffc02017a4:	b1050513          	addi	a0,a0,-1264 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02017a8:	95bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc02017ac:	00004697          	auipc	a3,0x4
ffffffffc02017b0:	c1468693          	addi	a3,a3,-1004 # ffffffffc02053c0 <commands+0xc58>
ffffffffc02017b4:	00003617          	auipc	a2,0x3
ffffffffc02017b8:	72460613          	addi	a2,a2,1828 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02017bc:	0dc00593          	li	a1,220
ffffffffc02017c0:	00004517          	auipc	a0,0x4
ffffffffc02017c4:	af050513          	addi	a0,a0,-1296 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02017c8:	93bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc02017cc:	00004617          	auipc	a2,0x4
ffffffffc02017d0:	ac460613          	addi	a2,a2,-1340 # ffffffffc0205290 <commands+0xb28>
ffffffffc02017d4:	02800593          	li	a1,40
ffffffffc02017d8:	00004517          	auipc	a0,0x4
ffffffffc02017dc:	ad850513          	addi	a0,a0,-1320 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02017e0:	923fe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc02017e4:	00004697          	auipc	a3,0x4
ffffffffc02017e8:	cb468693          	addi	a3,a3,-844 # ffffffffc0205498 <commands+0xd30>
ffffffffc02017ec:	00003617          	auipc	a2,0x3
ffffffffc02017f0:	6ec60613          	addi	a2,a2,1772 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02017f4:	0fb00593          	li	a1,251
ffffffffc02017f8:	00004517          	auipc	a0,0x4
ffffffffc02017fc:	ab850513          	addi	a0,a0,-1352 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201800:	903fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc0201804:	00004697          	auipc	a3,0x4
ffffffffc0201808:	c7468693          	addi	a3,a3,-908 # ffffffffc0205478 <commands+0xd10>
ffffffffc020180c:	00003617          	auipc	a2,0x3
ffffffffc0201810:	6cc60613          	addi	a2,a2,1740 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201814:	09f00593          	li	a1,159
ffffffffc0201818:	00004517          	auipc	a0,0x4
ffffffffc020181c:	a9850513          	addi	a0,a0,-1384 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201820:	8e3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc0201824:	00004697          	auipc	a3,0x4
ffffffffc0201828:	c5468693          	addi	a3,a3,-940 # ffffffffc0205478 <commands+0xd10>
ffffffffc020182c:	00003617          	auipc	a2,0x3
ffffffffc0201830:	6ac60613          	addi	a2,a2,1708 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201834:	0a100593          	li	a1,161
ffffffffc0201838:	00004517          	auipc	a0,0x4
ffffffffc020183c:	a7850513          	addi	a0,a0,-1416 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201840:	8c3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert( nr_free == 0);         
ffffffffc0201844:	00004697          	auipc	a3,0x4
ffffffffc0201848:	c4468693          	addi	a3,a3,-956 # ffffffffc0205488 <commands+0xd20>
ffffffffc020184c:	00003617          	auipc	a2,0x3
ffffffffc0201850:	68c60613          	addi	a2,a2,1676 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201854:	0f300593          	li	a1,243
ffffffffc0201858:	00004517          	auipc	a0,0x4
ffffffffc020185c:	a5850513          	addi	a0,a0,-1448 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201860:	8a3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(ret==0);
ffffffffc0201864:	00004697          	auipc	a3,0x4
ffffffffc0201868:	cc468693          	addi	a3,a3,-828 # ffffffffc0205528 <commands+0xdc0>
ffffffffc020186c:	00003617          	auipc	a2,0x3
ffffffffc0201870:	66c60613          	addi	a2,a2,1644 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201874:	10200593          	li	a1,258
ffffffffc0201878:	00004517          	auipc	a0,0x4
ffffffffc020187c:	a3850513          	addi	a0,a0,-1480 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201880:	883fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0201884:	00004697          	auipc	a3,0x4
ffffffffc0201888:	86468693          	addi	a3,a3,-1948 # ffffffffc02050e8 <commands+0x980>
ffffffffc020188c:	00003617          	auipc	a2,0x3
ffffffffc0201890:	64c60613          	addi	a2,a2,1612 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201894:	0cc00593          	li	a1,204
ffffffffc0201898:	00004517          	auipc	a0,0x4
ffffffffc020189c:	a1850513          	addi	a0,a0,-1512 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02018a0:	863fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(vma != NULL);
ffffffffc02018a4:	00004697          	auipc	a3,0x4
ffffffffc02018a8:	8ec68693          	addi	a3,a3,-1812 # ffffffffc0205190 <commands+0xa28>
ffffffffc02018ac:	00003617          	auipc	a2,0x3
ffffffffc02018b0:	62c60613          	addi	a2,a2,1580 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02018b4:	0cf00593          	li	a1,207
ffffffffc02018b8:	00004517          	auipc	a0,0x4
ffffffffc02018bc:	9f850513          	addi	a0,a0,-1544 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02018c0:	843fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc02018c4:	00004697          	auipc	a3,0x4
ffffffffc02018c8:	abc68693          	addi	a3,a3,-1348 # ffffffffc0205380 <commands+0xc18>
ffffffffc02018cc:	00003617          	auipc	a2,0x3
ffffffffc02018d0:	60c60613          	addi	a2,a2,1548 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02018d4:	0d700593          	li	a1,215
ffffffffc02018d8:	00004517          	auipc	a0,0x4
ffffffffc02018dc:	9d850513          	addi	a0,a0,-1576 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02018e0:	823fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(total == nr_free_pages());
ffffffffc02018e4:	00004697          	auipc	a3,0x4
ffffffffc02018e8:	a0468693          	addi	a3,a3,-1532 # ffffffffc02052e8 <commands+0xb80>
ffffffffc02018ec:	00003617          	auipc	a2,0x3
ffffffffc02018f0:	5ec60613          	addi	a2,a2,1516 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02018f4:	0bf00593          	li	a1,191
ffffffffc02018f8:	00004517          	auipc	a0,0x4
ffffffffc02018fc:	9b850513          	addi	a0,a0,-1608 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201900:	803fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc0201904:	00004697          	auipc	a3,0x4
ffffffffc0201908:	b5468693          	addi	a3,a3,-1196 # ffffffffc0205458 <commands+0xcf0>
ffffffffc020190c:	00003617          	auipc	a2,0x3
ffffffffc0201910:	5cc60613          	addi	a2,a2,1484 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201914:	09700593          	li	a1,151
ffffffffc0201918:	00004517          	auipc	a0,0x4
ffffffffc020191c:	99850513          	addi	a0,a0,-1640 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201920:	fe2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc0201924:	00004697          	auipc	a3,0x4
ffffffffc0201928:	b3468693          	addi	a3,a3,-1228 # ffffffffc0205458 <commands+0xcf0>
ffffffffc020192c:	00003617          	auipc	a2,0x3
ffffffffc0201930:	5ac60613          	addi	a2,a2,1452 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201934:	09900593          	li	a1,153
ffffffffc0201938:	00004517          	auipc	a0,0x4
ffffffffc020193c:	97850513          	addi	a0,a0,-1672 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201940:	fc2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201944:	00004697          	auipc	a3,0x4
ffffffffc0201948:	b2468693          	addi	a3,a3,-1244 # ffffffffc0205468 <commands+0xd00>
ffffffffc020194c:	00003617          	auipc	a2,0x3
ffffffffc0201950:	58c60613          	addi	a2,a2,1420 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201954:	09b00593          	li	a1,155
ffffffffc0201958:	00004517          	auipc	a0,0x4
ffffffffc020195c:	95850513          	addi	a0,a0,-1704 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201960:	fa2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201964:	00004697          	auipc	a3,0x4
ffffffffc0201968:	b0468693          	addi	a3,a3,-1276 # ffffffffc0205468 <commands+0xd00>
ffffffffc020196c:	00003617          	auipc	a2,0x3
ffffffffc0201970:	56c60613          	addi	a2,a2,1388 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201974:	09d00593          	li	a1,157
ffffffffc0201978:	00004517          	auipc	a0,0x4
ffffffffc020197c:	93850513          	addi	a0,a0,-1736 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201980:	f82fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc0201984:	00004697          	auipc	a3,0x4
ffffffffc0201988:	ac468693          	addi	a3,a3,-1340 # ffffffffc0205448 <commands+0xce0>
ffffffffc020198c:	00003617          	auipc	a2,0x3
ffffffffc0201990:	54c60613          	addi	a2,a2,1356 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201994:	09300593          	li	a1,147
ffffffffc0201998:	00004517          	auipc	a0,0x4
ffffffffc020199c:	91850513          	addi	a0,a0,-1768 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02019a0:	f62fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc02019a4:	00004697          	auipc	a3,0x4
ffffffffc02019a8:	aa468693          	addi	a3,a3,-1372 # ffffffffc0205448 <commands+0xce0>
ffffffffc02019ac:	00003617          	auipc	a2,0x3
ffffffffc02019b0:	52c60613          	addi	a2,a2,1324 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02019b4:	09500593          	li	a1,149
ffffffffc02019b8:	00004517          	auipc	a0,0x4
ffffffffc02019bc:	8f850513          	addi	a0,a0,-1800 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02019c0:	f42fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(mm != NULL);
ffffffffc02019c4:	00003697          	auipc	a3,0x3
ffffffffc02019c8:	7f468693          	addi	a3,a3,2036 # ffffffffc02051b8 <commands+0xa50>
ffffffffc02019cc:	00003617          	auipc	a2,0x3
ffffffffc02019d0:	50c60613          	addi	a2,a2,1292 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02019d4:	0c400593          	li	a1,196
ffffffffc02019d8:	00004517          	auipc	a0,0x4
ffffffffc02019dc:	8d850513          	addi	a0,a0,-1832 # ffffffffc02052b0 <commands+0xb48>
ffffffffc02019e0:	f22fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc02019e4:	00004697          	auipc	a3,0x4
ffffffffc02019e8:	94c68693          	addi	a3,a3,-1716 # ffffffffc0205330 <commands+0xbc8>
ffffffffc02019ec:	00003617          	auipc	a2,0x3
ffffffffc02019f0:	4ec60613          	addi	a2,a2,1260 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02019f4:	0c700593          	li	a1,199
ffffffffc02019f8:	00004517          	auipc	a0,0x4
ffffffffc02019fc:	8b850513          	addi	a0,a0,-1864 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201a00:	f02fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0201a04:	00004697          	auipc	a3,0x4
ffffffffc0201a08:	9f468693          	addi	a3,a3,-1548 # ffffffffc02053f8 <commands+0xc90>
ffffffffc0201a0c:	00003617          	auipc	a2,0x3
ffffffffc0201a10:	4cc60613          	addi	a2,a2,1228 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201a14:	0ea00593          	li	a1,234
ffffffffc0201a18:	00004517          	auipc	a0,0x4
ffffffffc0201a1c:	89850513          	addi	a0,a0,-1896 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201a20:	ee2fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201a24 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0201a24:	00010797          	auipc	a5,0x10
ffffffffc0201a28:	b0c7b783          	ld	a5,-1268(a5) # ffffffffc0211530 <sm>
ffffffffc0201a2c:	6b9c                	ld	a5,16(a5)
ffffffffc0201a2e:	8782                	jr	a5

ffffffffc0201a30 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0201a30:	00010797          	auipc	a5,0x10
ffffffffc0201a34:	b007b783          	ld	a5,-1280(a5) # ffffffffc0211530 <sm>
ffffffffc0201a38:	739c                	ld	a5,32(a5)
ffffffffc0201a3a:	8782                	jr	a5

ffffffffc0201a3c <swap_out>:
{
ffffffffc0201a3c:	711d                	addi	sp,sp,-96
ffffffffc0201a3e:	ec86                	sd	ra,88(sp)
ffffffffc0201a40:	e8a2                	sd	s0,80(sp)
ffffffffc0201a42:	e4a6                	sd	s1,72(sp)
ffffffffc0201a44:	e0ca                	sd	s2,64(sp)
ffffffffc0201a46:	fc4e                	sd	s3,56(sp)
ffffffffc0201a48:	f852                	sd	s4,48(sp)
ffffffffc0201a4a:	f456                	sd	s5,40(sp)
ffffffffc0201a4c:	f05a                	sd	s6,32(sp)
ffffffffc0201a4e:	ec5e                	sd	s7,24(sp)
ffffffffc0201a50:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0201a52:	cde9                	beqz	a1,ffffffffc0201b2c <swap_out+0xf0>
ffffffffc0201a54:	8a2e                	mv	s4,a1
ffffffffc0201a56:	892a                	mv	s2,a0
ffffffffc0201a58:	8ab2                	mv	s5,a2
ffffffffc0201a5a:	4401                	li	s0,0
ffffffffc0201a5c:	00010997          	auipc	s3,0x10
ffffffffc0201a60:	ad498993          	addi	s3,s3,-1324 # ffffffffc0211530 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a64:	00004b17          	auipc	s6,0x4
ffffffffc0201a68:	b6cb0b13          	addi	s6,s6,-1172 # ffffffffc02055d0 <commands+0xe68>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201a6c:	00004b97          	auipc	s7,0x4
ffffffffc0201a70:	b4cb8b93          	addi	s7,s7,-1204 # ffffffffc02055b8 <commands+0xe50>
ffffffffc0201a74:	a825                	j	ffffffffc0201aac <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a76:	67a2                	ld	a5,8(sp)
ffffffffc0201a78:	8626                	mv	a2,s1
ffffffffc0201a7a:	85a2                	mv	a1,s0
ffffffffc0201a7c:	63b4                	ld	a3,64(a5)
ffffffffc0201a7e:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0201a80:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a82:	82b1                	srli	a3,a3,0xc
ffffffffc0201a84:	0685                	addi	a3,a3,1
ffffffffc0201a86:	e34fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a8a:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0201a8c:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a8e:	613c                	ld	a5,64(a0)
ffffffffc0201a90:	83b1                	srli	a5,a5,0xc
ffffffffc0201a92:	0785                	addi	a5,a5,1
ffffffffc0201a94:	07a2                	slli	a5,a5,0x8
ffffffffc0201a96:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0201a9a:	0da010ef          	jal	ra,ffffffffc0202b74 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0201a9e:	01893503          	ld	a0,24(s2)
ffffffffc0201aa2:	85a6                	mv	a1,s1
ffffffffc0201aa4:	138020ef          	jal	ra,ffffffffc0203bdc <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0201aa8:	048a0d63          	beq	s4,s0,ffffffffc0201b02 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0201aac:	0009b783          	ld	a5,0(s3)
ffffffffc0201ab0:	8656                	mv	a2,s5
ffffffffc0201ab2:	002c                	addi	a1,sp,8
ffffffffc0201ab4:	7b9c                	ld	a5,48(a5)
ffffffffc0201ab6:	854a                	mv	a0,s2
ffffffffc0201ab8:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0201aba:	e12d                	bnez	a0,ffffffffc0201b1c <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0201abc:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201abe:	01893503          	ld	a0,24(s2)
ffffffffc0201ac2:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0201ac4:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201ac6:	85a6                	mv	a1,s1
ffffffffc0201ac8:	126010ef          	jal	ra,ffffffffc0202bee <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201acc:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201ace:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0201ad0:	8b85                	andi	a5,a5,1
ffffffffc0201ad2:	cfb9                	beqz	a5,ffffffffc0201b30 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0201ad4:	65a2                	ld	a1,8(sp)
ffffffffc0201ad6:	61bc                	ld	a5,64(a1)
ffffffffc0201ad8:	83b1                	srli	a5,a5,0xc
ffffffffc0201ada:	0785                	addi	a5,a5,1
ffffffffc0201adc:	00879513          	slli	a0,a5,0x8
ffffffffc0201ae0:	42e020ef          	jal	ra,ffffffffc0203f0e <swapfs_write>
ffffffffc0201ae4:	d949                	beqz	a0,ffffffffc0201a76 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201ae6:	855e                	mv	a0,s7
ffffffffc0201ae8:	dd2fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201aec:	0009b783          	ld	a5,0(s3)
ffffffffc0201af0:	6622                	ld	a2,8(sp)
ffffffffc0201af2:	4681                	li	a3,0
ffffffffc0201af4:	739c                	ld	a5,32(a5)
ffffffffc0201af6:	85a6                	mv	a1,s1
ffffffffc0201af8:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0201afa:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201afc:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0201afe:	fa8a17e3          	bne	s4,s0,ffffffffc0201aac <swap_out+0x70>
}
ffffffffc0201b02:	60e6                	ld	ra,88(sp)
ffffffffc0201b04:	8522                	mv	a0,s0
ffffffffc0201b06:	6446                	ld	s0,80(sp)
ffffffffc0201b08:	64a6                	ld	s1,72(sp)
ffffffffc0201b0a:	6906                	ld	s2,64(sp)
ffffffffc0201b0c:	79e2                	ld	s3,56(sp)
ffffffffc0201b0e:	7a42                	ld	s4,48(sp)
ffffffffc0201b10:	7aa2                	ld	s5,40(sp)
ffffffffc0201b12:	7b02                	ld	s6,32(sp)
ffffffffc0201b14:	6be2                	ld	s7,24(sp)
ffffffffc0201b16:	6c42                	ld	s8,16(sp)
ffffffffc0201b18:	6125                	addi	sp,sp,96
ffffffffc0201b1a:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0201b1c:	85a2                	mv	a1,s0
ffffffffc0201b1e:	00004517          	auipc	a0,0x4
ffffffffc0201b22:	a5250513          	addi	a0,a0,-1454 # ffffffffc0205570 <commands+0xe08>
ffffffffc0201b26:	d94fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                  break;
ffffffffc0201b2a:	bfe1                	j	ffffffffc0201b02 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0201b2c:	4401                	li	s0,0
ffffffffc0201b2e:	bfd1                	j	ffffffffc0201b02 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201b30:	00004697          	auipc	a3,0x4
ffffffffc0201b34:	a7068693          	addi	a3,a3,-1424 # ffffffffc02055a0 <commands+0xe38>
ffffffffc0201b38:	00003617          	auipc	a2,0x3
ffffffffc0201b3c:	3a060613          	addi	a2,a2,928 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201b40:	06800593          	li	a1,104
ffffffffc0201b44:	00003517          	auipc	a0,0x3
ffffffffc0201b48:	76c50513          	addi	a0,a0,1900 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201b4c:	db6fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201b50 <swap_in>:
{
ffffffffc0201b50:	7179                	addi	sp,sp,-48
ffffffffc0201b52:	e84a                	sd	s2,16(sp)
ffffffffc0201b54:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0201b56:	4505                	li	a0,1
{
ffffffffc0201b58:	ec26                	sd	s1,24(sp)
ffffffffc0201b5a:	e44e                	sd	s3,8(sp)
ffffffffc0201b5c:	f406                	sd	ra,40(sp)
ffffffffc0201b5e:	f022                	sd	s0,32(sp)
ffffffffc0201b60:	84ae                	mv	s1,a1
ffffffffc0201b62:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0201b64:	77f000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
     assert(result!=NULL);
ffffffffc0201b68:	c129                	beqz	a0,ffffffffc0201baa <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0201b6a:	842a                	mv	s0,a0
ffffffffc0201b6c:	01893503          	ld	a0,24(s2)
ffffffffc0201b70:	4601                	li	a2,0
ffffffffc0201b72:	85a6                	mv	a1,s1
ffffffffc0201b74:	07a010ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc0201b78:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0201b7a:	6108                	ld	a0,0(a0)
ffffffffc0201b7c:	85a2                	mv	a1,s0
ffffffffc0201b7e:	2f6020ef          	jal	ra,ffffffffc0203e74 <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0201b82:	00093583          	ld	a1,0(s2)
ffffffffc0201b86:	8626                	mv	a2,s1
ffffffffc0201b88:	00004517          	auipc	a0,0x4
ffffffffc0201b8c:	a9850513          	addi	a0,a0,-1384 # ffffffffc0205620 <commands+0xeb8>
ffffffffc0201b90:	81a1                	srli	a1,a1,0x8
ffffffffc0201b92:	d28fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201b96:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0201b98:	0089b023          	sd	s0,0(s3)
}
ffffffffc0201b9c:	7402                	ld	s0,32(sp)
ffffffffc0201b9e:	64e2                	ld	s1,24(sp)
ffffffffc0201ba0:	6942                	ld	s2,16(sp)
ffffffffc0201ba2:	69a2                	ld	s3,8(sp)
ffffffffc0201ba4:	4501                	li	a0,0
ffffffffc0201ba6:	6145                	addi	sp,sp,48
ffffffffc0201ba8:	8082                	ret
     assert(result!=NULL);
ffffffffc0201baa:	00004697          	auipc	a3,0x4
ffffffffc0201bae:	a6668693          	addi	a3,a3,-1434 # ffffffffc0205610 <commands+0xea8>
ffffffffc0201bb2:	00003617          	auipc	a2,0x3
ffffffffc0201bb6:	32660613          	addi	a2,a2,806 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201bba:	07e00593          	li	a1,126
ffffffffc0201bbe:	00003517          	auipc	a0,0x3
ffffffffc0201bc2:	6f250513          	addi	a0,a0,1778 # ffffffffc02052b0 <commands+0xb48>
ffffffffc0201bc6:	d3cfe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201bca <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201bca:	0000f797          	auipc	a5,0xf
ffffffffc0201bce:	51678793          	addi	a5,a5,1302 # ffffffffc02110e0 <free_area>
ffffffffc0201bd2:	e79c                	sd	a5,8(a5)
ffffffffc0201bd4:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201bd6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201bda:	8082                	ret

ffffffffc0201bdc <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201bdc:	0000f517          	auipc	a0,0xf
ffffffffc0201be0:	51456503          	lwu	a0,1300(a0) # ffffffffc02110f0 <free_area+0x10>
ffffffffc0201be4:	8082                	ret

ffffffffc0201be6 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201be6:	715d                	addi	sp,sp,-80
ffffffffc0201be8:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201bea:	0000f417          	auipc	s0,0xf
ffffffffc0201bee:	4f640413          	addi	s0,s0,1270 # ffffffffc02110e0 <free_area>
ffffffffc0201bf2:	641c                	ld	a5,8(s0)
ffffffffc0201bf4:	e486                	sd	ra,72(sp)
ffffffffc0201bf6:	fc26                	sd	s1,56(sp)
ffffffffc0201bf8:	f84a                	sd	s2,48(sp)
ffffffffc0201bfa:	f44e                	sd	s3,40(sp)
ffffffffc0201bfc:	f052                	sd	s4,32(sp)
ffffffffc0201bfe:	ec56                	sd	s5,24(sp)
ffffffffc0201c00:	e85a                	sd	s6,16(sp)
ffffffffc0201c02:	e45e                	sd	s7,8(sp)
ffffffffc0201c04:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201c06:	2c878763          	beq	a5,s0,ffffffffc0201ed4 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0201c0a:	4481                	li	s1,0
ffffffffc0201c0c:	4901                	li	s2,0
ffffffffc0201c0e:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201c12:	8b09                	andi	a4,a4,2
ffffffffc0201c14:	2c070463          	beqz	a4,ffffffffc0201edc <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0201c18:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201c1c:	679c                	ld	a5,8(a5)
ffffffffc0201c1e:	2905                	addiw	s2,s2,1
ffffffffc0201c20:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201c22:	fe8796e3          	bne	a5,s0,ffffffffc0201c0e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201c26:	89a6                	mv	s3,s1
ffffffffc0201c28:	78d000ef          	jal	ra,ffffffffc0202bb4 <nr_free_pages>
ffffffffc0201c2c:	71351863          	bne	a0,s3,ffffffffc020233c <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c30:	4505                	li	a0,1
ffffffffc0201c32:	6b1000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201c36:	8a2a                	mv	s4,a0
ffffffffc0201c38:	44050263          	beqz	a0,ffffffffc020207c <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c3c:	4505                	li	a0,1
ffffffffc0201c3e:	6a5000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201c42:	89aa                	mv	s3,a0
ffffffffc0201c44:	70050c63          	beqz	a0,ffffffffc020235c <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c48:	4505                	li	a0,1
ffffffffc0201c4a:	699000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201c4e:	8aaa                	mv	s5,a0
ffffffffc0201c50:	4a050663          	beqz	a0,ffffffffc02020fc <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201c54:	2b3a0463          	beq	s4,s3,ffffffffc0201efc <default_check+0x316>
ffffffffc0201c58:	2aaa0263          	beq	s4,a0,ffffffffc0201efc <default_check+0x316>
ffffffffc0201c5c:	2aa98063          	beq	s3,a0,ffffffffc0201efc <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201c60:	000a2783          	lw	a5,0(s4)
ffffffffc0201c64:	2a079c63          	bnez	a5,ffffffffc0201f1c <default_check+0x336>
ffffffffc0201c68:	0009a783          	lw	a5,0(s3)
ffffffffc0201c6c:	2a079863          	bnez	a5,ffffffffc0201f1c <default_check+0x336>
ffffffffc0201c70:	411c                	lw	a5,0(a0)
ffffffffc0201c72:	2a079563          	bnez	a5,ffffffffc0201f1c <default_check+0x336>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c76:	00010797          	auipc	a5,0x10
ffffffffc0201c7a:	8e27b783          	ld	a5,-1822(a5) # ffffffffc0211558 <pages>
ffffffffc0201c7e:	40fa0733          	sub	a4,s4,a5
ffffffffc0201c82:	870d                	srai	a4,a4,0x3
ffffffffc0201c84:	00004597          	auipc	a1,0x4
ffffffffc0201c88:	7fc5b583          	ld	a1,2044(a1) # ffffffffc0206480 <error_string+0x38>
ffffffffc0201c8c:	02b70733          	mul	a4,a4,a1
ffffffffc0201c90:	00004617          	auipc	a2,0x4
ffffffffc0201c94:	7f863603          	ld	a2,2040(a2) # ffffffffc0206488 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201c98:	00010697          	auipc	a3,0x10
ffffffffc0201c9c:	8b86b683          	ld	a3,-1864(a3) # ffffffffc0211550 <npage>
ffffffffc0201ca0:	06b2                	slli	a3,a3,0xc
ffffffffc0201ca2:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ca4:	0732                	slli	a4,a4,0xc
ffffffffc0201ca6:	28d77b63          	bgeu	a4,a3,ffffffffc0201f3c <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201caa:	40f98733          	sub	a4,s3,a5
ffffffffc0201cae:	870d                	srai	a4,a4,0x3
ffffffffc0201cb0:	02b70733          	mul	a4,a4,a1
ffffffffc0201cb4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201cb6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201cb8:	4cd77263          	bgeu	a4,a3,ffffffffc020217c <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201cbc:	40f507b3          	sub	a5,a0,a5
ffffffffc0201cc0:	878d                	srai	a5,a5,0x3
ffffffffc0201cc2:	02b787b3          	mul	a5,a5,a1
ffffffffc0201cc6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201cc8:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201cca:	30d7f963          	bgeu	a5,a3,ffffffffc0201fdc <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0201cce:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201cd0:	00043c03          	ld	s8,0(s0)
ffffffffc0201cd4:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201cd8:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201cdc:	e400                	sd	s0,8(s0)
ffffffffc0201cde:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201ce0:	0000f797          	auipc	a5,0xf
ffffffffc0201ce4:	4007a823          	sw	zero,1040(a5) # ffffffffc02110f0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201ce8:	5fb000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201cec:	2c051863          	bnez	a0,ffffffffc0201fbc <default_check+0x3d6>
    free_page(p0);
ffffffffc0201cf0:	4585                	li	a1,1
ffffffffc0201cf2:	8552                	mv	a0,s4
ffffffffc0201cf4:	681000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_page(p1);
ffffffffc0201cf8:	4585                	li	a1,1
ffffffffc0201cfa:	854e                	mv	a0,s3
ffffffffc0201cfc:	679000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_page(p2);
ffffffffc0201d00:	4585                	li	a1,1
ffffffffc0201d02:	8556                	mv	a0,s5
ffffffffc0201d04:	671000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    assert(nr_free == 3);
ffffffffc0201d08:	4818                	lw	a4,16(s0)
ffffffffc0201d0a:	478d                	li	a5,3
ffffffffc0201d0c:	28f71863          	bne	a4,a5,ffffffffc0201f9c <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201d10:	4505                	li	a0,1
ffffffffc0201d12:	5d1000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d16:	89aa                	mv	s3,a0
ffffffffc0201d18:	26050263          	beqz	a0,ffffffffc0201f7c <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201d1c:	4505                	li	a0,1
ffffffffc0201d1e:	5c5000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d22:	8aaa                	mv	s5,a0
ffffffffc0201d24:	3a050c63          	beqz	a0,ffffffffc02020dc <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201d28:	4505                	li	a0,1
ffffffffc0201d2a:	5b9000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d2e:	8a2a                	mv	s4,a0
ffffffffc0201d30:	38050663          	beqz	a0,ffffffffc02020bc <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0201d34:	4505                	li	a0,1
ffffffffc0201d36:	5ad000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d3a:	36051163          	bnez	a0,ffffffffc020209c <default_check+0x4b6>
    free_page(p0);
ffffffffc0201d3e:	4585                	li	a1,1
ffffffffc0201d40:	854e                	mv	a0,s3
ffffffffc0201d42:	633000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201d46:	641c                	ld	a5,8(s0)
ffffffffc0201d48:	20878a63          	beq	a5,s0,ffffffffc0201f5c <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0201d4c:	4505                	li	a0,1
ffffffffc0201d4e:	595000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d52:	30a99563          	bne	s3,a0,ffffffffc020205c <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0201d56:	4505                	li	a0,1
ffffffffc0201d58:	58b000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d5c:	2e051063          	bnez	a0,ffffffffc020203c <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0201d60:	481c                	lw	a5,16(s0)
ffffffffc0201d62:	2a079d63          	bnez	a5,ffffffffc020201c <default_check+0x436>
    free_page(p);
ffffffffc0201d66:	854e                	mv	a0,s3
ffffffffc0201d68:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201d6a:	01843023          	sd	s8,0(s0)
ffffffffc0201d6e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201d72:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201d76:	5ff000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_page(p1);
ffffffffc0201d7a:	4585                	li	a1,1
ffffffffc0201d7c:	8556                	mv	a0,s5
ffffffffc0201d7e:	5f7000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_page(p2);
ffffffffc0201d82:	4585                	li	a1,1
ffffffffc0201d84:	8552                	mv	a0,s4
ffffffffc0201d86:	5ef000ef          	jal	ra,ffffffffc0202b74 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201d8a:	4515                	li	a0,5
ffffffffc0201d8c:	557000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201d90:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201d92:	26050563          	beqz	a0,ffffffffc0201ffc <default_check+0x416>
ffffffffc0201d96:	651c                	ld	a5,8(a0)
ffffffffc0201d98:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0201d9a:	8b85                	andi	a5,a5,1
ffffffffc0201d9c:	54079063          	bnez	a5,ffffffffc02022dc <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201da0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201da2:	00043b03          	ld	s6,0(s0)
ffffffffc0201da6:	00843a83          	ld	s5,8(s0)
ffffffffc0201daa:	e000                	sd	s0,0(s0)
ffffffffc0201dac:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201dae:	535000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201db2:	50051563          	bnez	a0,ffffffffc02022bc <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201db6:	09098a13          	addi	s4,s3,144
ffffffffc0201dba:	8552                	mv	a0,s4
ffffffffc0201dbc:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201dbe:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201dc2:	0000f797          	auipc	a5,0xf
ffffffffc0201dc6:	3207a723          	sw	zero,814(a5) # ffffffffc02110f0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201dca:	5ab000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201dce:	4511                	li	a0,4
ffffffffc0201dd0:	513000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201dd4:	4c051463          	bnez	a0,ffffffffc020229c <default_check+0x6b6>
ffffffffc0201dd8:	0989b783          	ld	a5,152(s3)
ffffffffc0201ddc:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201dde:	8b85                	andi	a5,a5,1
ffffffffc0201de0:	48078e63          	beqz	a5,ffffffffc020227c <default_check+0x696>
ffffffffc0201de4:	0a89a703          	lw	a4,168(s3)
ffffffffc0201de8:	478d                	li	a5,3
ffffffffc0201dea:	48f71963          	bne	a4,a5,ffffffffc020227c <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201dee:	450d                	li	a0,3
ffffffffc0201df0:	4f3000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201df4:	8c2a                	mv	s8,a0
ffffffffc0201df6:	46050363          	beqz	a0,ffffffffc020225c <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0201dfa:	4505                	li	a0,1
ffffffffc0201dfc:	4e7000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201e00:	42051e63          	bnez	a0,ffffffffc020223c <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0201e04:	418a1c63          	bne	s4,s8,ffffffffc020221c <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201e08:	4585                	li	a1,1
ffffffffc0201e0a:	854e                	mv	a0,s3
ffffffffc0201e0c:	569000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_pages(p1, 3);
ffffffffc0201e10:	458d                	li	a1,3
ffffffffc0201e12:	8552                	mv	a0,s4
ffffffffc0201e14:	561000ef          	jal	ra,ffffffffc0202b74 <free_pages>
ffffffffc0201e18:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201e1c:	04898c13          	addi	s8,s3,72
ffffffffc0201e20:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201e22:	8b85                	andi	a5,a5,1
ffffffffc0201e24:	3c078c63          	beqz	a5,ffffffffc02021fc <default_check+0x616>
ffffffffc0201e28:	0189a703          	lw	a4,24(s3)
ffffffffc0201e2c:	4785                	li	a5,1
ffffffffc0201e2e:	3cf71763          	bne	a4,a5,ffffffffc02021fc <default_check+0x616>
ffffffffc0201e32:	008a3783          	ld	a5,8(s4)
ffffffffc0201e36:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201e38:	8b85                	andi	a5,a5,1
ffffffffc0201e3a:	3a078163          	beqz	a5,ffffffffc02021dc <default_check+0x5f6>
ffffffffc0201e3e:	018a2703          	lw	a4,24(s4)
ffffffffc0201e42:	478d                	li	a5,3
ffffffffc0201e44:	38f71c63          	bne	a4,a5,ffffffffc02021dc <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201e48:	4505                	li	a0,1
ffffffffc0201e4a:	499000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201e4e:	36a99763          	bne	s3,a0,ffffffffc02021bc <default_check+0x5d6>
    free_page(p0);
ffffffffc0201e52:	4585                	li	a1,1
ffffffffc0201e54:	521000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201e58:	4509                	li	a0,2
ffffffffc0201e5a:	489000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201e5e:	32aa1f63          	bne	s4,a0,ffffffffc020219c <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0201e62:	4589                	li	a1,2
ffffffffc0201e64:	511000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    free_page(p2);
ffffffffc0201e68:	4585                	li	a1,1
ffffffffc0201e6a:	8562                	mv	a0,s8
ffffffffc0201e6c:	509000ef          	jal	ra,ffffffffc0202b74 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201e70:	4515                	li	a0,5
ffffffffc0201e72:	471000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201e76:	89aa                	mv	s3,a0
ffffffffc0201e78:	48050263          	beqz	a0,ffffffffc02022fc <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0201e7c:	4505                	li	a0,1
ffffffffc0201e7e:	465000ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0201e82:	2c051d63          	bnez	a0,ffffffffc020215c <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0201e86:	481c                	lw	a5,16(s0)
ffffffffc0201e88:	2a079a63          	bnez	a5,ffffffffc020213c <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201e8c:	4595                	li	a1,5
ffffffffc0201e8e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201e90:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201e94:	01643023          	sd	s6,0(s0)
ffffffffc0201e98:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201e9c:	4d9000ef          	jal	ra,ffffffffc0202b74 <free_pages>
    return listelm->next;
ffffffffc0201ea0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201ea2:	00878963          	beq	a5,s0,ffffffffc0201eb4 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201ea6:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201eaa:	679c                	ld	a5,8(a5)
ffffffffc0201eac:	397d                	addiw	s2,s2,-1
ffffffffc0201eae:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201eb0:	fe879be3          	bne	a5,s0,ffffffffc0201ea6 <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0201eb4:	26091463          	bnez	s2,ffffffffc020211c <default_check+0x536>
    assert(total == 0);
ffffffffc0201eb8:	46049263          	bnez	s1,ffffffffc020231c <default_check+0x736>
}
ffffffffc0201ebc:	60a6                	ld	ra,72(sp)
ffffffffc0201ebe:	6406                	ld	s0,64(sp)
ffffffffc0201ec0:	74e2                	ld	s1,56(sp)
ffffffffc0201ec2:	7942                	ld	s2,48(sp)
ffffffffc0201ec4:	79a2                	ld	s3,40(sp)
ffffffffc0201ec6:	7a02                	ld	s4,32(sp)
ffffffffc0201ec8:	6ae2                	ld	s5,24(sp)
ffffffffc0201eca:	6b42                	ld	s6,16(sp)
ffffffffc0201ecc:	6ba2                	ld	s7,8(sp)
ffffffffc0201ece:	6c02                	ld	s8,0(sp)
ffffffffc0201ed0:	6161                	addi	sp,sp,80
ffffffffc0201ed2:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201ed4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201ed6:	4481                	li	s1,0
ffffffffc0201ed8:	4901                	li	s2,0
ffffffffc0201eda:	b3b9                	j	ffffffffc0201c28 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201edc:	00003697          	auipc	a3,0x3
ffffffffc0201ee0:	3fc68693          	addi	a3,a3,1020 # ffffffffc02052d8 <commands+0xb70>
ffffffffc0201ee4:	00003617          	auipc	a2,0x3
ffffffffc0201ee8:	ff460613          	addi	a2,a2,-12 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201eec:	0f000593          	li	a1,240
ffffffffc0201ef0:	00003517          	auipc	a0,0x3
ffffffffc0201ef4:	77050513          	addi	a0,a0,1904 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201ef8:	a0afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201efc:	00003697          	auipc	a3,0x3
ffffffffc0201f00:	7dc68693          	addi	a3,a3,2012 # ffffffffc02056d8 <commands+0xf70>
ffffffffc0201f04:	00003617          	auipc	a2,0x3
ffffffffc0201f08:	fd460613          	addi	a2,a2,-44 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201f0c:	0bd00593          	li	a1,189
ffffffffc0201f10:	00003517          	auipc	a0,0x3
ffffffffc0201f14:	75050513          	addi	a0,a0,1872 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201f18:	9eafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201f1c:	00003697          	auipc	a3,0x3
ffffffffc0201f20:	7e468693          	addi	a3,a3,2020 # ffffffffc0205700 <commands+0xf98>
ffffffffc0201f24:	00003617          	auipc	a2,0x3
ffffffffc0201f28:	fb460613          	addi	a2,a2,-76 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201f2c:	0be00593          	li	a1,190
ffffffffc0201f30:	00003517          	auipc	a0,0x3
ffffffffc0201f34:	73050513          	addi	a0,a0,1840 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201f38:	9cafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201f3c:	00004697          	auipc	a3,0x4
ffffffffc0201f40:	80468693          	addi	a3,a3,-2044 # ffffffffc0205740 <commands+0xfd8>
ffffffffc0201f44:	00003617          	auipc	a2,0x3
ffffffffc0201f48:	f9460613          	addi	a2,a2,-108 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201f4c:	0c000593          	li	a1,192
ffffffffc0201f50:	00003517          	auipc	a0,0x3
ffffffffc0201f54:	71050513          	addi	a0,a0,1808 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201f58:	9aafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201f5c:	00004697          	auipc	a3,0x4
ffffffffc0201f60:	86c68693          	addi	a3,a3,-1940 # ffffffffc02057c8 <commands+0x1060>
ffffffffc0201f64:	00003617          	auipc	a2,0x3
ffffffffc0201f68:	f7460613          	addi	a2,a2,-140 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201f6c:	0d900593          	li	a1,217
ffffffffc0201f70:	00003517          	auipc	a0,0x3
ffffffffc0201f74:	6f050513          	addi	a0,a0,1776 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201f78:	98afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f7c:	00003697          	auipc	a3,0x3
ffffffffc0201f80:	6fc68693          	addi	a3,a3,1788 # ffffffffc0205678 <commands+0xf10>
ffffffffc0201f84:	00003617          	auipc	a2,0x3
ffffffffc0201f88:	f5460613          	addi	a2,a2,-172 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201f8c:	0d200593          	li	a1,210
ffffffffc0201f90:	00003517          	auipc	a0,0x3
ffffffffc0201f94:	6d050513          	addi	a0,a0,1744 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201f98:	96afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 3);
ffffffffc0201f9c:	00004697          	auipc	a3,0x4
ffffffffc0201fa0:	81c68693          	addi	a3,a3,-2020 # ffffffffc02057b8 <commands+0x1050>
ffffffffc0201fa4:	00003617          	auipc	a2,0x3
ffffffffc0201fa8:	f3460613          	addi	a2,a2,-204 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201fac:	0d000593          	li	a1,208
ffffffffc0201fb0:	00003517          	auipc	a0,0x3
ffffffffc0201fb4:	6b050513          	addi	a0,a0,1712 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201fb8:	94afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201fbc:	00003697          	auipc	a3,0x3
ffffffffc0201fc0:	7e468693          	addi	a3,a3,2020 # ffffffffc02057a0 <commands+0x1038>
ffffffffc0201fc4:	00003617          	auipc	a2,0x3
ffffffffc0201fc8:	f1460613          	addi	a2,a2,-236 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201fcc:	0cb00593          	li	a1,203
ffffffffc0201fd0:	00003517          	auipc	a0,0x3
ffffffffc0201fd4:	69050513          	addi	a0,a0,1680 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201fd8:	92afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201fdc:	00003697          	auipc	a3,0x3
ffffffffc0201fe0:	7a468693          	addi	a3,a3,1956 # ffffffffc0205780 <commands+0x1018>
ffffffffc0201fe4:	00003617          	auipc	a2,0x3
ffffffffc0201fe8:	ef460613          	addi	a2,a2,-268 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0201fec:	0c200593          	li	a1,194
ffffffffc0201ff0:	00003517          	auipc	a0,0x3
ffffffffc0201ff4:	67050513          	addi	a0,a0,1648 # ffffffffc0205660 <commands+0xef8>
ffffffffc0201ff8:	90afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != NULL);
ffffffffc0201ffc:	00004697          	auipc	a3,0x4
ffffffffc0202000:	80468693          	addi	a3,a3,-2044 # ffffffffc0205800 <commands+0x1098>
ffffffffc0202004:	00003617          	auipc	a2,0x3
ffffffffc0202008:	ed460613          	addi	a2,a2,-300 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020200c:	0f800593          	li	a1,248
ffffffffc0202010:	00003517          	auipc	a0,0x3
ffffffffc0202014:	65050513          	addi	a0,a0,1616 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202018:	8eafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc020201c:	00003697          	auipc	a3,0x3
ffffffffc0202020:	46c68693          	addi	a3,a3,1132 # ffffffffc0205488 <commands+0xd20>
ffffffffc0202024:	00003617          	auipc	a2,0x3
ffffffffc0202028:	eb460613          	addi	a2,a2,-332 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020202c:	0df00593          	li	a1,223
ffffffffc0202030:	00003517          	auipc	a0,0x3
ffffffffc0202034:	63050513          	addi	a0,a0,1584 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202038:	8cafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020203c:	00003697          	auipc	a3,0x3
ffffffffc0202040:	76468693          	addi	a3,a3,1892 # ffffffffc02057a0 <commands+0x1038>
ffffffffc0202044:	00003617          	auipc	a2,0x3
ffffffffc0202048:	e9460613          	addi	a2,a2,-364 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020204c:	0dd00593          	li	a1,221
ffffffffc0202050:	00003517          	auipc	a0,0x3
ffffffffc0202054:	61050513          	addi	a0,a0,1552 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202058:	8aafe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020205c:	00003697          	auipc	a3,0x3
ffffffffc0202060:	78468693          	addi	a3,a3,1924 # ffffffffc02057e0 <commands+0x1078>
ffffffffc0202064:	00003617          	auipc	a2,0x3
ffffffffc0202068:	e7460613          	addi	a2,a2,-396 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020206c:	0dc00593          	li	a1,220
ffffffffc0202070:	00003517          	auipc	a0,0x3
ffffffffc0202074:	5f050513          	addi	a0,a0,1520 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202078:	88afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020207c:	00003697          	auipc	a3,0x3
ffffffffc0202080:	5fc68693          	addi	a3,a3,1532 # ffffffffc0205678 <commands+0xf10>
ffffffffc0202084:	00003617          	auipc	a2,0x3
ffffffffc0202088:	e5460613          	addi	a2,a2,-428 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020208c:	0b900593          	li	a1,185
ffffffffc0202090:	00003517          	auipc	a0,0x3
ffffffffc0202094:	5d050513          	addi	a0,a0,1488 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202098:	86afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020209c:	00003697          	auipc	a3,0x3
ffffffffc02020a0:	70468693          	addi	a3,a3,1796 # ffffffffc02057a0 <commands+0x1038>
ffffffffc02020a4:	00003617          	auipc	a2,0x3
ffffffffc02020a8:	e3460613          	addi	a2,a2,-460 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02020ac:	0d600593          	li	a1,214
ffffffffc02020b0:	00003517          	auipc	a0,0x3
ffffffffc02020b4:	5b050513          	addi	a0,a0,1456 # ffffffffc0205660 <commands+0xef8>
ffffffffc02020b8:	84afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020bc:	00003697          	auipc	a3,0x3
ffffffffc02020c0:	5fc68693          	addi	a3,a3,1532 # ffffffffc02056b8 <commands+0xf50>
ffffffffc02020c4:	00003617          	auipc	a2,0x3
ffffffffc02020c8:	e1460613          	addi	a2,a2,-492 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02020cc:	0d400593          	li	a1,212
ffffffffc02020d0:	00003517          	auipc	a0,0x3
ffffffffc02020d4:	59050513          	addi	a0,a0,1424 # ffffffffc0205660 <commands+0xef8>
ffffffffc02020d8:	82afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02020dc:	00003697          	auipc	a3,0x3
ffffffffc02020e0:	5bc68693          	addi	a3,a3,1468 # ffffffffc0205698 <commands+0xf30>
ffffffffc02020e4:	00003617          	auipc	a2,0x3
ffffffffc02020e8:	df460613          	addi	a2,a2,-524 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02020ec:	0d300593          	li	a1,211
ffffffffc02020f0:	00003517          	auipc	a0,0x3
ffffffffc02020f4:	57050513          	addi	a0,a0,1392 # ffffffffc0205660 <commands+0xef8>
ffffffffc02020f8:	80afe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020fc:	00003697          	auipc	a3,0x3
ffffffffc0202100:	5bc68693          	addi	a3,a3,1468 # ffffffffc02056b8 <commands+0xf50>
ffffffffc0202104:	00003617          	auipc	a2,0x3
ffffffffc0202108:	dd460613          	addi	a2,a2,-556 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020210c:	0bb00593          	li	a1,187
ffffffffc0202110:	00003517          	auipc	a0,0x3
ffffffffc0202114:	55050513          	addi	a0,a0,1360 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202118:	febfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(count == 0);
ffffffffc020211c:	00004697          	auipc	a3,0x4
ffffffffc0202120:	83468693          	addi	a3,a3,-1996 # ffffffffc0205950 <commands+0x11e8>
ffffffffc0202124:	00003617          	auipc	a2,0x3
ffffffffc0202128:	db460613          	addi	a2,a2,-588 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020212c:	12500593          	li	a1,293
ffffffffc0202130:	00003517          	auipc	a0,0x3
ffffffffc0202134:	53050513          	addi	a0,a0,1328 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202138:	fcbfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc020213c:	00003697          	auipc	a3,0x3
ffffffffc0202140:	34c68693          	addi	a3,a3,844 # ffffffffc0205488 <commands+0xd20>
ffffffffc0202144:	00003617          	auipc	a2,0x3
ffffffffc0202148:	d9460613          	addi	a2,a2,-620 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020214c:	11a00593          	li	a1,282
ffffffffc0202150:	00003517          	auipc	a0,0x3
ffffffffc0202154:	51050513          	addi	a0,a0,1296 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202158:	fabfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020215c:	00003697          	auipc	a3,0x3
ffffffffc0202160:	64468693          	addi	a3,a3,1604 # ffffffffc02057a0 <commands+0x1038>
ffffffffc0202164:	00003617          	auipc	a2,0x3
ffffffffc0202168:	d7460613          	addi	a2,a2,-652 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020216c:	11800593          	li	a1,280
ffffffffc0202170:	00003517          	auipc	a0,0x3
ffffffffc0202174:	4f050513          	addi	a0,a0,1264 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202178:	f8bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020217c:	00003697          	auipc	a3,0x3
ffffffffc0202180:	5e468693          	addi	a3,a3,1508 # ffffffffc0205760 <commands+0xff8>
ffffffffc0202184:	00003617          	auipc	a2,0x3
ffffffffc0202188:	d5460613          	addi	a2,a2,-684 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020218c:	0c100593          	li	a1,193
ffffffffc0202190:	00003517          	auipc	a0,0x3
ffffffffc0202194:	4d050513          	addi	a0,a0,1232 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202198:	f6bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020219c:	00003697          	auipc	a3,0x3
ffffffffc02021a0:	77468693          	addi	a3,a3,1908 # ffffffffc0205910 <commands+0x11a8>
ffffffffc02021a4:	00003617          	auipc	a2,0x3
ffffffffc02021a8:	d3460613          	addi	a2,a2,-716 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02021ac:	11200593          	li	a1,274
ffffffffc02021b0:	00003517          	auipc	a0,0x3
ffffffffc02021b4:	4b050513          	addi	a0,a0,1200 # ffffffffc0205660 <commands+0xef8>
ffffffffc02021b8:	f4bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02021bc:	00003697          	auipc	a3,0x3
ffffffffc02021c0:	73468693          	addi	a3,a3,1844 # ffffffffc02058f0 <commands+0x1188>
ffffffffc02021c4:	00003617          	auipc	a2,0x3
ffffffffc02021c8:	d1460613          	addi	a2,a2,-748 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02021cc:	11000593          	li	a1,272
ffffffffc02021d0:	00003517          	auipc	a0,0x3
ffffffffc02021d4:	49050513          	addi	a0,a0,1168 # ffffffffc0205660 <commands+0xef8>
ffffffffc02021d8:	f2bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02021dc:	00003697          	auipc	a3,0x3
ffffffffc02021e0:	6ec68693          	addi	a3,a3,1772 # ffffffffc02058c8 <commands+0x1160>
ffffffffc02021e4:	00003617          	auipc	a2,0x3
ffffffffc02021e8:	cf460613          	addi	a2,a2,-780 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02021ec:	10e00593          	li	a1,270
ffffffffc02021f0:	00003517          	auipc	a0,0x3
ffffffffc02021f4:	47050513          	addi	a0,a0,1136 # ffffffffc0205660 <commands+0xef8>
ffffffffc02021f8:	f0bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02021fc:	00003697          	auipc	a3,0x3
ffffffffc0202200:	6a468693          	addi	a3,a3,1700 # ffffffffc02058a0 <commands+0x1138>
ffffffffc0202204:	00003617          	auipc	a2,0x3
ffffffffc0202208:	cd460613          	addi	a2,a2,-812 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020220c:	10d00593          	li	a1,269
ffffffffc0202210:	00003517          	auipc	a0,0x3
ffffffffc0202214:	45050513          	addi	a0,a0,1104 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202218:	eebfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020221c:	00003697          	auipc	a3,0x3
ffffffffc0202220:	67468693          	addi	a3,a3,1652 # ffffffffc0205890 <commands+0x1128>
ffffffffc0202224:	00003617          	auipc	a2,0x3
ffffffffc0202228:	cb460613          	addi	a2,a2,-844 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020222c:	10800593          	li	a1,264
ffffffffc0202230:	00003517          	auipc	a0,0x3
ffffffffc0202234:	43050513          	addi	a0,a0,1072 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202238:	ecbfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020223c:	00003697          	auipc	a3,0x3
ffffffffc0202240:	56468693          	addi	a3,a3,1380 # ffffffffc02057a0 <commands+0x1038>
ffffffffc0202244:	00003617          	auipc	a2,0x3
ffffffffc0202248:	c9460613          	addi	a2,a2,-876 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020224c:	10700593          	li	a1,263
ffffffffc0202250:	00003517          	auipc	a0,0x3
ffffffffc0202254:	41050513          	addi	a0,a0,1040 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202258:	eabfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020225c:	00003697          	auipc	a3,0x3
ffffffffc0202260:	61468693          	addi	a3,a3,1556 # ffffffffc0205870 <commands+0x1108>
ffffffffc0202264:	00003617          	auipc	a2,0x3
ffffffffc0202268:	c7460613          	addi	a2,a2,-908 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020226c:	10600593          	li	a1,262
ffffffffc0202270:	00003517          	auipc	a0,0x3
ffffffffc0202274:	3f050513          	addi	a0,a0,1008 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202278:	e8bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020227c:	00003697          	auipc	a3,0x3
ffffffffc0202280:	5c468693          	addi	a3,a3,1476 # ffffffffc0205840 <commands+0x10d8>
ffffffffc0202284:	00003617          	auipc	a2,0x3
ffffffffc0202288:	c5460613          	addi	a2,a2,-940 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020228c:	10500593          	li	a1,261
ffffffffc0202290:	00003517          	auipc	a0,0x3
ffffffffc0202294:	3d050513          	addi	a0,a0,976 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202298:	e6bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020229c:	00003697          	auipc	a3,0x3
ffffffffc02022a0:	58c68693          	addi	a3,a3,1420 # ffffffffc0205828 <commands+0x10c0>
ffffffffc02022a4:	00003617          	auipc	a2,0x3
ffffffffc02022a8:	c3460613          	addi	a2,a2,-972 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02022ac:	10400593          	li	a1,260
ffffffffc02022b0:	00003517          	auipc	a0,0x3
ffffffffc02022b4:	3b050513          	addi	a0,a0,944 # ffffffffc0205660 <commands+0xef8>
ffffffffc02022b8:	e4bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02022bc:	00003697          	auipc	a3,0x3
ffffffffc02022c0:	4e468693          	addi	a3,a3,1252 # ffffffffc02057a0 <commands+0x1038>
ffffffffc02022c4:	00003617          	auipc	a2,0x3
ffffffffc02022c8:	c1460613          	addi	a2,a2,-1004 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02022cc:	0fe00593          	li	a1,254
ffffffffc02022d0:	00003517          	auipc	a0,0x3
ffffffffc02022d4:	39050513          	addi	a0,a0,912 # ffffffffc0205660 <commands+0xef8>
ffffffffc02022d8:	e2bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!PageProperty(p0));
ffffffffc02022dc:	00003697          	auipc	a3,0x3
ffffffffc02022e0:	53468693          	addi	a3,a3,1332 # ffffffffc0205810 <commands+0x10a8>
ffffffffc02022e4:	00003617          	auipc	a2,0x3
ffffffffc02022e8:	bf460613          	addi	a2,a2,-1036 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02022ec:	0f900593          	li	a1,249
ffffffffc02022f0:	00003517          	auipc	a0,0x3
ffffffffc02022f4:	37050513          	addi	a0,a0,880 # ffffffffc0205660 <commands+0xef8>
ffffffffc02022f8:	e0bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02022fc:	00003697          	auipc	a3,0x3
ffffffffc0202300:	63468693          	addi	a3,a3,1588 # ffffffffc0205930 <commands+0x11c8>
ffffffffc0202304:	00003617          	auipc	a2,0x3
ffffffffc0202308:	bd460613          	addi	a2,a2,-1068 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020230c:	11700593          	li	a1,279
ffffffffc0202310:	00003517          	auipc	a0,0x3
ffffffffc0202314:	35050513          	addi	a0,a0,848 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202318:	debfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == 0);
ffffffffc020231c:	00003697          	auipc	a3,0x3
ffffffffc0202320:	64468693          	addi	a3,a3,1604 # ffffffffc0205960 <commands+0x11f8>
ffffffffc0202324:	00003617          	auipc	a2,0x3
ffffffffc0202328:	bb460613          	addi	a2,a2,-1100 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020232c:	12600593          	li	a1,294
ffffffffc0202330:	00003517          	auipc	a0,0x3
ffffffffc0202334:	33050513          	addi	a0,a0,816 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202338:	dcbfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == nr_free_pages());
ffffffffc020233c:	00003697          	auipc	a3,0x3
ffffffffc0202340:	fac68693          	addi	a3,a3,-84 # ffffffffc02052e8 <commands+0xb80>
ffffffffc0202344:	00003617          	auipc	a2,0x3
ffffffffc0202348:	b9460613          	addi	a2,a2,-1132 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020234c:	0f300593          	li	a1,243
ffffffffc0202350:	00003517          	auipc	a0,0x3
ffffffffc0202354:	31050513          	addi	a0,a0,784 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202358:	dabfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020235c:	00003697          	auipc	a3,0x3
ffffffffc0202360:	33c68693          	addi	a3,a3,828 # ffffffffc0205698 <commands+0xf30>
ffffffffc0202364:	00003617          	auipc	a2,0x3
ffffffffc0202368:	b7460613          	addi	a2,a2,-1164 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020236c:	0ba00593          	li	a1,186
ffffffffc0202370:	00003517          	auipc	a0,0x3
ffffffffc0202374:	2f050513          	addi	a0,a0,752 # ffffffffc0205660 <commands+0xef8>
ffffffffc0202378:	d8bfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc020237c <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020237c:	1141                	addi	sp,sp,-16
ffffffffc020237e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202380:	14058a63          	beqz	a1,ffffffffc02024d4 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0202384:	00359693          	slli	a3,a1,0x3
ffffffffc0202388:	96ae                	add	a3,a3,a1
ffffffffc020238a:	068e                	slli	a3,a3,0x3
ffffffffc020238c:	96aa                	add	a3,a3,a0
ffffffffc020238e:	87aa                	mv	a5,a0
ffffffffc0202390:	02d50263          	beq	a0,a3,ffffffffc02023b4 <default_free_pages+0x38>
ffffffffc0202394:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202396:	8b05                	andi	a4,a4,1
ffffffffc0202398:	10071e63          	bnez	a4,ffffffffc02024b4 <default_free_pages+0x138>
ffffffffc020239c:	6798                	ld	a4,8(a5)
ffffffffc020239e:	8b09                	andi	a4,a4,2
ffffffffc02023a0:	10071a63          	bnez	a4,ffffffffc02024b4 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc02023a4:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02023a8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02023ac:	04878793          	addi	a5,a5,72
ffffffffc02023b0:	fed792e3          	bne	a5,a3,ffffffffc0202394 <default_free_pages+0x18>
    base->property = n;
ffffffffc02023b4:	2581                	sext.w	a1,a1
ffffffffc02023b6:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc02023b8:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02023bc:	4789                	li	a5,2
ffffffffc02023be:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02023c2:	0000f697          	auipc	a3,0xf
ffffffffc02023c6:	d1e68693          	addi	a3,a3,-738 # ffffffffc02110e0 <free_area>
ffffffffc02023ca:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02023cc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02023ce:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02023d2:	9db9                	addw	a1,a1,a4
ffffffffc02023d4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02023d6:	0ad78863          	beq	a5,a3,ffffffffc0202486 <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02023da:	fe078713          	addi	a4,a5,-32
ffffffffc02023de:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02023e2:	4581                	li	a1,0
            if (base < page) {
ffffffffc02023e4:	00e56a63          	bltu	a0,a4,ffffffffc02023f8 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc02023e8:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02023ea:	06d70263          	beq	a4,a3,ffffffffc020244e <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02023ee:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02023f0:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02023f4:	fee57ae3          	bgeu	a0,a4,ffffffffc02023e8 <default_free_pages+0x6c>
ffffffffc02023f8:	c199                	beqz	a1,ffffffffc02023fe <default_free_pages+0x82>
ffffffffc02023fa:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02023fe:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0202400:	e390                	sd	a2,0(a5)
ffffffffc0202402:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202404:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202406:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc0202408:	02d70063          	beq	a4,a3,ffffffffc0202428 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc020240c:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0202410:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc0202414:	02081613          	slli	a2,a6,0x20
ffffffffc0202418:	9201                	srli	a2,a2,0x20
ffffffffc020241a:	00361793          	slli	a5,a2,0x3
ffffffffc020241e:	97b2                	add	a5,a5,a2
ffffffffc0202420:	078e                	slli	a5,a5,0x3
ffffffffc0202422:	97ae                	add	a5,a5,a1
ffffffffc0202424:	02f50f63          	beq	a0,a5,ffffffffc0202462 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc0202428:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc020242a:	00d70f63          	beq	a4,a3,ffffffffc0202448 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc020242e:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc0202430:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc0202434:	02059613          	slli	a2,a1,0x20
ffffffffc0202438:	9201                	srli	a2,a2,0x20
ffffffffc020243a:	00361793          	slli	a5,a2,0x3
ffffffffc020243e:	97b2                	add	a5,a5,a2
ffffffffc0202440:	078e                	slli	a5,a5,0x3
ffffffffc0202442:	97aa                	add	a5,a5,a0
ffffffffc0202444:	04f68863          	beq	a3,a5,ffffffffc0202494 <default_free_pages+0x118>
}
ffffffffc0202448:	60a2                	ld	ra,8(sp)
ffffffffc020244a:	0141                	addi	sp,sp,16
ffffffffc020244c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020244e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202450:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc0202452:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202454:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202456:	02d70563          	beq	a4,a3,ffffffffc0202480 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc020245a:	8832                	mv	a6,a2
ffffffffc020245c:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020245e:	87ba                	mv	a5,a4
ffffffffc0202460:	bf41                	j	ffffffffc02023f0 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc0202462:	4d1c                	lw	a5,24(a0)
ffffffffc0202464:	0107883b          	addw	a6,a5,a6
ffffffffc0202468:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020246c:	57f5                	li	a5,-3
ffffffffc020246e:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202472:	7110                	ld	a2,32(a0)
ffffffffc0202474:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc0202476:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc0202478:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc020247a:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc020247c:	e390                	sd	a2,0(a5)
ffffffffc020247e:	b775                	j	ffffffffc020242a <default_free_pages+0xae>
ffffffffc0202480:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202482:	873e                	mv	a4,a5
ffffffffc0202484:	b761                	j	ffffffffc020240c <default_free_pages+0x90>
}
ffffffffc0202486:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202488:	e390                	sd	a2,0(a5)
ffffffffc020248a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020248c:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020248e:	f11c                	sd	a5,32(a0)
ffffffffc0202490:	0141                	addi	sp,sp,16
ffffffffc0202492:	8082                	ret
            base->property += p->property;
ffffffffc0202494:	ff872783          	lw	a5,-8(a4)
ffffffffc0202498:	fe870693          	addi	a3,a4,-24
ffffffffc020249c:	9dbd                	addw	a1,a1,a5
ffffffffc020249e:	cd0c                	sw	a1,24(a0)
ffffffffc02024a0:	57f5                	li	a5,-3
ffffffffc02024a2:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02024a6:	6314                	ld	a3,0(a4)
ffffffffc02024a8:	671c                	ld	a5,8(a4)
}
ffffffffc02024aa:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02024ac:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02024ae:	e394                	sd	a3,0(a5)
ffffffffc02024b0:	0141                	addi	sp,sp,16
ffffffffc02024b2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02024b4:	00003697          	auipc	a3,0x3
ffffffffc02024b8:	4c468693          	addi	a3,a3,1220 # ffffffffc0205978 <commands+0x1210>
ffffffffc02024bc:	00003617          	auipc	a2,0x3
ffffffffc02024c0:	a1c60613          	addi	a2,a2,-1508 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02024c4:	08300593          	li	a1,131
ffffffffc02024c8:	00003517          	auipc	a0,0x3
ffffffffc02024cc:	19850513          	addi	a0,a0,408 # ffffffffc0205660 <commands+0xef8>
ffffffffc02024d0:	c33fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc02024d4:	00003697          	auipc	a3,0x3
ffffffffc02024d8:	49c68693          	addi	a3,a3,1180 # ffffffffc0205970 <commands+0x1208>
ffffffffc02024dc:	00003617          	auipc	a2,0x3
ffffffffc02024e0:	9fc60613          	addi	a2,a2,-1540 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02024e4:	08000593          	li	a1,128
ffffffffc02024e8:	00003517          	auipc	a0,0x3
ffffffffc02024ec:	17850513          	addi	a0,a0,376 # ffffffffc0205660 <commands+0xef8>
ffffffffc02024f0:	c13fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02024f4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02024f4:	c959                	beqz	a0,ffffffffc020258a <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc02024f6:	0000f597          	auipc	a1,0xf
ffffffffc02024fa:	bea58593          	addi	a1,a1,-1046 # ffffffffc02110e0 <free_area>
ffffffffc02024fe:	0105a803          	lw	a6,16(a1)
ffffffffc0202502:	862a                	mv	a2,a0
ffffffffc0202504:	02081793          	slli	a5,a6,0x20
ffffffffc0202508:	9381                	srli	a5,a5,0x20
ffffffffc020250a:	00a7ee63          	bltu	a5,a0,ffffffffc0202526 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020250e:	87ae                	mv	a5,a1
ffffffffc0202510:	a801                	j	ffffffffc0202520 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0202512:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202516:	02071693          	slli	a3,a4,0x20
ffffffffc020251a:	9281                	srli	a3,a3,0x20
ffffffffc020251c:	00c6f763          	bgeu	a3,a2,ffffffffc020252a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0202520:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202522:	feb798e3          	bne	a5,a1,ffffffffc0202512 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0202526:	4501                	li	a0,0
}
ffffffffc0202528:	8082                	ret
    return listelm->prev;
ffffffffc020252a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020252e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0202532:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc0202536:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc020253a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020253e:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0202542:	02d67b63          	bgeu	a2,a3,ffffffffc0202578 <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc0202546:	00361693          	slli	a3,a2,0x3
ffffffffc020254a:	96b2                	add	a3,a3,a2
ffffffffc020254c:	068e                	slli	a3,a3,0x3
ffffffffc020254e:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc0202550:	41c7073b          	subw	a4,a4,t3
ffffffffc0202554:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202556:	00868613          	addi	a2,a3,8
ffffffffc020255a:	4709                	li	a4,2
ffffffffc020255c:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202560:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0202564:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc0202568:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020256c:	e310                	sd	a2,0(a4)
ffffffffc020256e:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0202572:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc0202574:	0316b023          	sd	a7,32(a3)
ffffffffc0202578:	41c8083b          	subw	a6,a6,t3
ffffffffc020257c:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202580:	5775                	li	a4,-3
ffffffffc0202582:	17a1                	addi	a5,a5,-24
ffffffffc0202584:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0202588:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020258a:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020258c:	00003697          	auipc	a3,0x3
ffffffffc0202590:	3e468693          	addi	a3,a3,996 # ffffffffc0205970 <commands+0x1208>
ffffffffc0202594:	00003617          	auipc	a2,0x3
ffffffffc0202598:	94460613          	addi	a2,a2,-1724 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020259c:	06200593          	li	a1,98
ffffffffc02025a0:	00003517          	auipc	a0,0x3
ffffffffc02025a4:	0c050513          	addi	a0,a0,192 # ffffffffc0205660 <commands+0xef8>
default_alloc_pages(size_t n) {
ffffffffc02025a8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02025aa:	b59fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02025ae <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02025ae:	1141                	addi	sp,sp,-16
ffffffffc02025b0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02025b2:	c9e1                	beqz	a1,ffffffffc0202682 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02025b4:	00359693          	slli	a3,a1,0x3
ffffffffc02025b8:	96ae                	add	a3,a3,a1
ffffffffc02025ba:	068e                	slli	a3,a3,0x3
ffffffffc02025bc:	96aa                	add	a3,a3,a0
ffffffffc02025be:	87aa                	mv	a5,a0
ffffffffc02025c0:	00d50f63          	beq	a0,a3,ffffffffc02025de <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02025c4:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02025c6:	8b05                	andi	a4,a4,1
ffffffffc02025c8:	cf49                	beqz	a4,ffffffffc0202662 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02025ca:	0007ac23          	sw	zero,24(a5)
ffffffffc02025ce:	0007b423          	sd	zero,8(a5)
ffffffffc02025d2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02025d6:	04878793          	addi	a5,a5,72
ffffffffc02025da:	fed795e3          	bne	a5,a3,ffffffffc02025c4 <default_init_memmap+0x16>
    base->property = n;
ffffffffc02025de:	2581                	sext.w	a1,a1
ffffffffc02025e0:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02025e2:	4789                	li	a5,2
ffffffffc02025e4:	00850713          	addi	a4,a0,8
ffffffffc02025e8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02025ec:	0000f697          	auipc	a3,0xf
ffffffffc02025f0:	af468693          	addi	a3,a3,-1292 # ffffffffc02110e0 <free_area>
ffffffffc02025f4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02025f6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02025f8:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02025fc:	9db9                	addw	a1,a1,a4
ffffffffc02025fe:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0202600:	04d78a63          	beq	a5,a3,ffffffffc0202654 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0202604:	fe078713          	addi	a4,a5,-32
ffffffffc0202608:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020260c:	4581                	li	a1,0
            if (base < page) {
ffffffffc020260e:	00e56a63          	bltu	a0,a4,ffffffffc0202622 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0202612:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0202614:	02d70263          	beq	a4,a3,ffffffffc0202638 <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc0202618:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020261a:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc020261e:	fee57ae3          	bgeu	a0,a4,ffffffffc0202612 <default_init_memmap+0x64>
ffffffffc0202622:	c199                	beqz	a1,ffffffffc0202628 <default_init_memmap+0x7a>
ffffffffc0202624:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202628:	6398                	ld	a4,0(a5)
}
ffffffffc020262a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020262c:	e390                	sd	a2,0(a5)
ffffffffc020262e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202630:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202632:	f118                	sd	a4,32(a0)
ffffffffc0202634:	0141                	addi	sp,sp,16
ffffffffc0202636:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202638:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020263a:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc020263c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020263e:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202640:	00d70663          	beq	a4,a3,ffffffffc020264c <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc0202644:	8832                	mv	a6,a2
ffffffffc0202646:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202648:	87ba                	mv	a5,a4
ffffffffc020264a:	bfc1                	j	ffffffffc020261a <default_init_memmap+0x6c>
}
ffffffffc020264c:	60a2                	ld	ra,8(sp)
ffffffffc020264e:	e290                	sd	a2,0(a3)
ffffffffc0202650:	0141                	addi	sp,sp,16
ffffffffc0202652:	8082                	ret
ffffffffc0202654:	60a2                	ld	ra,8(sp)
ffffffffc0202656:	e390                	sd	a2,0(a5)
ffffffffc0202658:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020265a:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020265c:	f11c                	sd	a5,32(a0)
ffffffffc020265e:	0141                	addi	sp,sp,16
ffffffffc0202660:	8082                	ret
        assert(PageReserved(p));
ffffffffc0202662:	00003697          	auipc	a3,0x3
ffffffffc0202666:	33e68693          	addi	a3,a3,830 # ffffffffc02059a0 <commands+0x1238>
ffffffffc020266a:	00003617          	auipc	a2,0x3
ffffffffc020266e:	86e60613          	addi	a2,a2,-1938 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202672:	04900593          	li	a1,73
ffffffffc0202676:	00003517          	auipc	a0,0x3
ffffffffc020267a:	fea50513          	addi	a0,a0,-22 # ffffffffc0205660 <commands+0xef8>
ffffffffc020267e:	a85fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc0202682:	00003697          	auipc	a3,0x3
ffffffffc0202686:	2ee68693          	addi	a3,a3,750 # ffffffffc0205970 <commands+0x1208>
ffffffffc020268a:	00003617          	auipc	a2,0x3
ffffffffc020268e:	84e60613          	addi	a2,a2,-1970 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202692:	04600593          	li	a1,70
ffffffffc0202696:	00003517          	auipc	a0,0x3
ffffffffc020269a:	fca50513          	addi	a0,a0,-54 # ffffffffc0205660 <commands+0xef8>
ffffffffc020269e:	a65fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02026a2 <_lru_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc02026a2:	0000f797          	auipc	a5,0xf
ffffffffc02026a6:	99e78793          	addi	a5,a5,-1634 # ffffffffc0211040 <pra_list_head>

static int
_lru_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc02026aa:	f51c                	sd	a5,40(a0)
ffffffffc02026ac:	e79c                	sd	a5,8(a5)
ffffffffc02026ae:	e39c                	sd	a5,0(a5)
     
     return 0;
}
ffffffffc02026b0:	4501                	li	a0,0
ffffffffc02026b2:	8082                	ret

ffffffffc02026b4 <_lru_init>:

static int
_lru_init(void)
{
    return 0;
}
ffffffffc02026b4:	4501                	li	a0,0
ffffffffc02026b6:	8082                	ret

ffffffffc02026b8 <_lru_set_unswappable>:

static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc02026b8:	4501                	li	a0,0
ffffffffc02026ba:	8082                	ret

ffffffffc02026bc <_lru_tick_event>:

static int
_lru_tick_event(struct mm_struct *mm)
{ 
    return 0;
}
ffffffffc02026bc:	4501                	li	a0,0
ffffffffc02026be:	8082                	ret

ffffffffc02026c0 <_lru_check_swap>:
_lru_check_swap(void) {
ffffffffc02026c0:	711d                	addi	sp,sp,-96
ffffffffc02026c2:	fc4e                	sd	s3,56(sp)
ffffffffc02026c4:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc02026c6:	00003517          	auipc	a0,0x3
ffffffffc02026ca:	33a50513          	addi	a0,a0,826 # ffffffffc0205a00 <default_pmm_manager+0x38>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02026ce:	698d                	lui	s3,0x3
ffffffffc02026d0:	4a31                	li	s4,12
_lru_check_swap(void) {
ffffffffc02026d2:	e0ca                	sd	s2,64(sp)
ffffffffc02026d4:	ec86                	sd	ra,88(sp)
ffffffffc02026d6:	e8a2                	sd	s0,80(sp)
ffffffffc02026d8:	e4a6                	sd	s1,72(sp)
ffffffffc02026da:	f456                	sd	s5,40(sp)
ffffffffc02026dc:	f05a                	sd	s6,32(sp)
ffffffffc02026de:	ec5e                	sd	s7,24(sp)
ffffffffc02026e0:	e862                	sd	s8,16(sp)
ffffffffc02026e2:	e466                	sd	s9,8(sp)
ffffffffc02026e4:	e06a                	sd	s10,0(sp)
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc02026e6:	9d5fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02026ea:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc02026ee:	0000f917          	auipc	s2,0xf
ffffffffc02026f2:	e3292903          	lw	s2,-462(s2) # ffffffffc0211520 <pgfault_num>
ffffffffc02026f6:	4791                	li	a5,4
ffffffffc02026f8:	16f91463          	bne	s2,a5,ffffffffc0202860 <_lru_check_swap+0x1a0>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc02026fc:	00003517          	auipc	a0,0x3
ffffffffc0202700:	34450513          	addi	a0,a0,836 # ffffffffc0205a40 <default_pmm_manager+0x78>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202704:	6a85                	lui	s5,0x1
ffffffffc0202706:	4b29                	li	s6,10
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0202708:	9b3fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020270c:	0000f417          	auipc	s0,0xf
ffffffffc0202710:	e1440413          	addi	s0,s0,-492 # ffffffffc0211520 <pgfault_num>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202714:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc0202718:	4004                	lw	s1,0(s0)
ffffffffc020271a:	2481                	sext.w	s1,s1
ffffffffc020271c:	2d249263          	bne	s1,s2,ffffffffc02029e0 <_lru_check_swap+0x320>
    cprintf("write Virt Page d in lru_check_swap\n");
ffffffffc0202720:	00003517          	auipc	a0,0x3
ffffffffc0202724:	34850513          	addi	a0,a0,840 # ffffffffc0205a68 <default_pmm_manager+0xa0>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202728:	6b91                	lui	s7,0x4
ffffffffc020272a:	4c35                	li	s8,13
    cprintf("write Virt Page d in lru_check_swap\n");
ffffffffc020272c:	98ffd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202730:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc0202734:	00042903          	lw	s2,0(s0)
ffffffffc0202738:	2901                	sext.w	s2,s2
ffffffffc020273a:	28991363          	bne	s2,s1,ffffffffc02029c0 <_lru_check_swap+0x300>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc020273e:	00003517          	auipc	a0,0x3
ffffffffc0202742:	35250513          	addi	a0,a0,850 # ffffffffc0205a90 <default_pmm_manager+0xc8>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202746:	6c89                	lui	s9,0x2
ffffffffc0202748:	4d2d                	li	s10,11
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc020274a:	971fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020274e:	01ac8023          	sb	s10,0(s9) # 2000 <kern_entry-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc0202752:	401c                	lw	a5,0(s0)
ffffffffc0202754:	2781                	sext.w	a5,a5
ffffffffc0202756:	25279563          	bne	a5,s2,ffffffffc02029a0 <_lru_check_swap+0x2e0>
    cprintf("write Virt Page e in lru_check_swap\n");
ffffffffc020275a:	00003517          	auipc	a0,0x3
ffffffffc020275e:	35e50513          	addi	a0,a0,862 # ffffffffc0205ab8 <default_pmm_manager+0xf0>
ffffffffc0202762:	959fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0202766:	6795                	lui	a5,0x5
ffffffffc0202768:	4739                	li	a4,14
ffffffffc020276a:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc020276e:	4004                	lw	s1,0(s0)
ffffffffc0202770:	4795                	li	a5,5
ffffffffc0202772:	2481                	sext.w	s1,s1
ffffffffc0202774:	20f49663          	bne	s1,a5,ffffffffc0202980 <_lru_check_swap+0x2c0>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc0202778:	00003517          	auipc	a0,0x3
ffffffffc020277c:	31850513          	addi	a0,a0,792 # ffffffffc0205a90 <default_pmm_manager+0xc8>
ffffffffc0202780:	93bfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202784:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==5);
ffffffffc0202788:	401c                	lw	a5,0(s0)
ffffffffc020278a:	2781                	sext.w	a5,a5
ffffffffc020278c:	1c979a63          	bne	a5,s1,ffffffffc0202960 <_lru_check_swap+0x2a0>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0202790:	00003517          	auipc	a0,0x3
ffffffffc0202794:	2b050513          	addi	a0,a0,688 # ffffffffc0205a40 <default_pmm_manager+0x78>
ffffffffc0202798:	923fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc020279c:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc02027a0:	401c                	lw	a5,0(s0)
ffffffffc02027a2:	4719                	li	a4,6
ffffffffc02027a4:	2781                	sext.w	a5,a5
ffffffffc02027a6:	18e79d63          	bne	a5,a4,ffffffffc0202940 <_lru_check_swap+0x280>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc02027aa:	00003517          	auipc	a0,0x3
ffffffffc02027ae:	2e650513          	addi	a0,a0,742 # ffffffffc0205a90 <default_pmm_manager+0xc8>
ffffffffc02027b2:	909fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02027b6:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==7);
ffffffffc02027ba:	401c                	lw	a5,0(s0)
ffffffffc02027bc:	471d                	li	a4,7
ffffffffc02027be:	2781                	sext.w	a5,a5
ffffffffc02027c0:	16e79063          	bne	a5,a4,ffffffffc0202920 <_lru_check_swap+0x260>
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc02027c4:	00003517          	auipc	a0,0x3
ffffffffc02027c8:	23c50513          	addi	a0,a0,572 # ffffffffc0205a00 <default_pmm_manager+0x38>
ffffffffc02027cc:	8effd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02027d0:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc02027d4:	401c                	lw	a5,0(s0)
ffffffffc02027d6:	4721                	li	a4,8
ffffffffc02027d8:	2781                	sext.w	a5,a5
ffffffffc02027da:	12e79363          	bne	a5,a4,ffffffffc0202900 <_lru_check_swap+0x240>
    cprintf("write Virt Page d in lru_check_swap\n");
ffffffffc02027de:	00003517          	auipc	a0,0x3
ffffffffc02027e2:	28a50513          	addi	a0,a0,650 # ffffffffc0205a68 <default_pmm_manager+0xa0>
ffffffffc02027e6:	8d5fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02027ea:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc02027ee:	401c                	lw	a5,0(s0)
ffffffffc02027f0:	4725                	li	a4,9
ffffffffc02027f2:	2781                	sext.w	a5,a5
ffffffffc02027f4:	0ee79663          	bne	a5,a4,ffffffffc02028e0 <_lru_check_swap+0x220>
    cprintf("write Virt Page e in lru_check_swap\n");
ffffffffc02027f8:	00003517          	auipc	a0,0x3
ffffffffc02027fc:	2c050513          	addi	a0,a0,704 # ffffffffc0205ab8 <default_pmm_manager+0xf0>
ffffffffc0202800:	8bbfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0202804:	6795                	lui	a5,0x5
ffffffffc0202806:	4739                	li	a4,14
ffffffffc0202808:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==10);
ffffffffc020280c:	4004                	lw	s1,0(s0)
ffffffffc020280e:	47a9                	li	a5,10
ffffffffc0202810:	2481                	sext.w	s1,s1
ffffffffc0202812:	0af49763          	bne	s1,a5,ffffffffc02028c0 <_lru_check_swap+0x200>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0202816:	00003517          	auipc	a0,0x3
ffffffffc020281a:	22a50513          	addi	a0,a0,554 # ffffffffc0205a40 <default_pmm_manager+0x78>
ffffffffc020281e:	89dfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202822:	6785                	lui	a5,0x1
ffffffffc0202824:	0007c783          	lbu	a5,0(a5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202828:	06979c63          	bne	a5,s1,ffffffffc02028a0 <_lru_check_swap+0x1e0>
    assert(pgfault_num==11);
ffffffffc020282c:	401c                	lw	a5,0(s0)
ffffffffc020282e:	472d                	li	a4,11
ffffffffc0202830:	2781                	sext.w	a5,a5
ffffffffc0202832:	04e79763          	bne	a5,a4,ffffffffc0202880 <_lru_check_swap+0x1c0>
    cprintf("LRU test passed!\n");
ffffffffc0202836:	00003517          	auipc	a0,0x3
ffffffffc020283a:	34250513          	addi	a0,a0,834 # ffffffffc0205b78 <default_pmm_manager+0x1b0>
ffffffffc020283e:	87dfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0202842:	60e6                	ld	ra,88(sp)
ffffffffc0202844:	6446                	ld	s0,80(sp)
ffffffffc0202846:	64a6                	ld	s1,72(sp)
ffffffffc0202848:	6906                	ld	s2,64(sp)
ffffffffc020284a:	79e2                	ld	s3,56(sp)
ffffffffc020284c:	7a42                	ld	s4,48(sp)
ffffffffc020284e:	7aa2                	ld	s5,40(sp)
ffffffffc0202850:	7b02                	ld	s6,32(sp)
ffffffffc0202852:	6be2                	ld	s7,24(sp)
ffffffffc0202854:	6c42                	ld	s8,16(sp)
ffffffffc0202856:	6ca2                	ld	s9,8(sp)
ffffffffc0202858:	6d02                	ld	s10,0(sp)
ffffffffc020285a:	4501                	li	a0,0
ffffffffc020285c:	6125                	addi	sp,sp,96
ffffffffc020285e:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0202860:	00003697          	auipc	a3,0x3
ffffffffc0202864:	c1868693          	addi	a3,a3,-1000 # ffffffffc0205478 <commands+0xd10>
ffffffffc0202868:	00002617          	auipc	a2,0x2
ffffffffc020286c:	67060613          	addi	a2,a2,1648 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202870:	05c00593          	li	a1,92
ffffffffc0202874:	00003517          	auipc	a0,0x3
ffffffffc0202878:	1b450513          	addi	a0,a0,436 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020287c:	887fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==11);
ffffffffc0202880:	00003697          	auipc	a3,0x3
ffffffffc0202884:	2e868693          	addi	a3,a3,744 # ffffffffc0205b68 <default_pmm_manager+0x1a0>
ffffffffc0202888:	00002617          	auipc	a2,0x2
ffffffffc020288c:	65060613          	addi	a2,a2,1616 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202890:	07e00593          	li	a1,126
ffffffffc0202894:	00003517          	auipc	a0,0x3
ffffffffc0202898:	19450513          	addi	a0,a0,404 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020289c:	867fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02028a0:	00003697          	auipc	a3,0x3
ffffffffc02028a4:	2a068693          	addi	a3,a3,672 # ffffffffc0205b40 <default_pmm_manager+0x178>
ffffffffc02028a8:	00002617          	auipc	a2,0x2
ffffffffc02028ac:	63060613          	addi	a2,a2,1584 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02028b0:	07c00593          	li	a1,124
ffffffffc02028b4:	00003517          	auipc	a0,0x3
ffffffffc02028b8:	17450513          	addi	a0,a0,372 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02028bc:	847fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==10);
ffffffffc02028c0:	00003697          	auipc	a3,0x3
ffffffffc02028c4:	27068693          	addi	a3,a3,624 # ffffffffc0205b30 <default_pmm_manager+0x168>
ffffffffc02028c8:	00002617          	auipc	a2,0x2
ffffffffc02028cc:	61060613          	addi	a2,a2,1552 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02028d0:	07a00593          	li	a1,122
ffffffffc02028d4:	00003517          	auipc	a0,0x3
ffffffffc02028d8:	15450513          	addi	a0,a0,340 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02028dc:	827fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==9);
ffffffffc02028e0:	00003697          	auipc	a3,0x3
ffffffffc02028e4:	24068693          	addi	a3,a3,576 # ffffffffc0205b20 <default_pmm_manager+0x158>
ffffffffc02028e8:	00002617          	auipc	a2,0x2
ffffffffc02028ec:	5f060613          	addi	a2,a2,1520 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02028f0:	07700593          	li	a1,119
ffffffffc02028f4:	00003517          	auipc	a0,0x3
ffffffffc02028f8:	13450513          	addi	a0,a0,308 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02028fc:	807fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==8);
ffffffffc0202900:	00003697          	auipc	a3,0x3
ffffffffc0202904:	21068693          	addi	a3,a3,528 # ffffffffc0205b10 <default_pmm_manager+0x148>
ffffffffc0202908:	00002617          	auipc	a2,0x2
ffffffffc020290c:	5d060613          	addi	a2,a2,1488 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202910:	07400593          	li	a1,116
ffffffffc0202914:	00003517          	auipc	a0,0x3
ffffffffc0202918:	11450513          	addi	a0,a0,276 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020291c:	fe6fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==7);
ffffffffc0202920:	00003697          	auipc	a3,0x3
ffffffffc0202924:	1e068693          	addi	a3,a3,480 # ffffffffc0205b00 <default_pmm_manager+0x138>
ffffffffc0202928:	00002617          	auipc	a2,0x2
ffffffffc020292c:	5b060613          	addi	a2,a2,1456 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202930:	07100593          	li	a1,113
ffffffffc0202934:	00003517          	auipc	a0,0x3
ffffffffc0202938:	0f450513          	addi	a0,a0,244 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020293c:	fc6fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==6);
ffffffffc0202940:	00003697          	auipc	a3,0x3
ffffffffc0202944:	1b068693          	addi	a3,a3,432 # ffffffffc0205af0 <default_pmm_manager+0x128>
ffffffffc0202948:	00002617          	auipc	a2,0x2
ffffffffc020294c:	59060613          	addi	a2,a2,1424 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202950:	06e00593          	li	a1,110
ffffffffc0202954:	00003517          	auipc	a0,0x3
ffffffffc0202958:	0d450513          	addi	a0,a0,212 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020295c:	fa6fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202960:	00003697          	auipc	a3,0x3
ffffffffc0202964:	18068693          	addi	a3,a3,384 # ffffffffc0205ae0 <default_pmm_manager+0x118>
ffffffffc0202968:	00002617          	auipc	a2,0x2
ffffffffc020296c:	57060613          	addi	a2,a2,1392 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202970:	06b00593          	li	a1,107
ffffffffc0202974:	00003517          	auipc	a0,0x3
ffffffffc0202978:	0b450513          	addi	a0,a0,180 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020297c:	f86fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202980:	00003697          	auipc	a3,0x3
ffffffffc0202984:	16068693          	addi	a3,a3,352 # ffffffffc0205ae0 <default_pmm_manager+0x118>
ffffffffc0202988:	00002617          	auipc	a2,0x2
ffffffffc020298c:	55060613          	addi	a2,a2,1360 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202990:	06800593          	li	a1,104
ffffffffc0202994:	00003517          	auipc	a0,0x3
ffffffffc0202998:	09450513          	addi	a0,a0,148 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc020299c:	f66fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02029a0:	00003697          	auipc	a3,0x3
ffffffffc02029a4:	ad868693          	addi	a3,a3,-1320 # ffffffffc0205478 <commands+0xd10>
ffffffffc02029a8:	00002617          	auipc	a2,0x2
ffffffffc02029ac:	53060613          	addi	a2,a2,1328 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02029b0:	06500593          	li	a1,101
ffffffffc02029b4:	00003517          	auipc	a0,0x3
ffffffffc02029b8:	07450513          	addi	a0,a0,116 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02029bc:	f46fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02029c0:	00003697          	auipc	a3,0x3
ffffffffc02029c4:	ab868693          	addi	a3,a3,-1352 # ffffffffc0205478 <commands+0xd10>
ffffffffc02029c8:	00002617          	auipc	a2,0x2
ffffffffc02029cc:	51060613          	addi	a2,a2,1296 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02029d0:	06200593          	li	a1,98
ffffffffc02029d4:	00003517          	auipc	a0,0x3
ffffffffc02029d8:	05450513          	addi	a0,a0,84 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02029dc:	f26fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02029e0:	00003697          	auipc	a3,0x3
ffffffffc02029e4:	a9868693          	addi	a3,a3,-1384 # ffffffffc0205478 <commands+0xd10>
ffffffffc02029e8:	00002617          	auipc	a2,0x2
ffffffffc02029ec:	4f060613          	addi	a2,a2,1264 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02029f0:	05f00593          	li	a1,95
ffffffffc02029f4:	00003517          	auipc	a0,0x3
ffffffffc02029f8:	03450513          	addi	a0,a0,52 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc02029fc:	f06fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a00 <_lru_swap_out_victim>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202a00:	7518                	ld	a4,40(a0)
{
ffffffffc0202a02:	1141                	addi	sp,sp,-16
ffffffffc0202a04:	e406                	sd	ra,8(sp)
    assert(head != NULL);
ffffffffc0202a06:	c731                	beqz	a4,ffffffffc0202a52 <_lru_swap_out_victim+0x52>
    assert(in_tick==0);
ffffffffc0202a08:	e60d                	bnez	a2,ffffffffc0202a32 <_lru_swap_out_victim+0x32>
    return listelm->prev;
ffffffffc0202a0a:	631c                	ld	a5,0(a4)
    if (entry != head) {
ffffffffc0202a0c:	00f70d63          	beq	a4,a5,ffffffffc0202a26 <_lru_swap_out_victim+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202a10:	6394                	ld	a3,0(a5)
ffffffffc0202a12:	6798                	ld	a4,8(a5)
}
ffffffffc0202a14:	60a2                	ld	ra,8(sp)
        *ptr_page = le2page(entry, pra_page_link);
ffffffffc0202a16:	fd078793          	addi	a5,a5,-48
    prev->next = next;
ffffffffc0202a1a:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0202a1c:	e314                	sd	a3,0(a4)
ffffffffc0202a1e:	e19c                	sd	a5,0(a1)
}
ffffffffc0202a20:	4501                	li	a0,0
ffffffffc0202a22:	0141                	addi	sp,sp,16
ffffffffc0202a24:	8082                	ret
ffffffffc0202a26:	60a2                	ld	ra,8(sp)
        *ptr_page = NULL;
ffffffffc0202a28:	0005b023          	sd	zero,0(a1)
}
ffffffffc0202a2c:	4501                	li	a0,0
ffffffffc0202a2e:	0141                	addi	sp,sp,16
ffffffffc0202a30:	8082                	ret
    assert(in_tick==0);
ffffffffc0202a32:	00003697          	auipc	a3,0x3
ffffffffc0202a36:	16e68693          	addi	a3,a3,366 # ffffffffc0205ba0 <default_pmm_manager+0x1d8>
ffffffffc0202a3a:	00002617          	auipc	a2,0x2
ffffffffc0202a3e:	49e60613          	addi	a2,a2,1182 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202a42:	02800593          	li	a1,40
ffffffffc0202a46:	00003517          	auipc	a0,0x3
ffffffffc0202a4a:	fe250513          	addi	a0,a0,-30 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc0202a4e:	eb4fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(head != NULL);
ffffffffc0202a52:	00003697          	auipc	a3,0x3
ffffffffc0202a56:	13e68693          	addi	a3,a3,318 # ffffffffc0205b90 <default_pmm_manager+0x1c8>
ffffffffc0202a5a:	00002617          	auipc	a2,0x2
ffffffffc0202a5e:	47e60613          	addi	a2,a2,1150 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202a62:	02700593          	li	a1,39
ffffffffc0202a66:	00003517          	auipc	a0,0x3
ffffffffc0202a6a:	fc250513          	addi	a0,a0,-62 # ffffffffc0205a28 <default_pmm_manager+0x60>
ffffffffc0202a6e:	e94fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a72 <_lru_map_swappable>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202a72:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc0202a74:	cb91                	beqz	a5,ffffffffc0202a88 <_lru_map_swappable+0x16>
    __list_add(elm, listelm, listelm->next);
ffffffffc0202a76:	6794                	ld	a3,8(a5)
ffffffffc0202a78:	03060713          	addi	a4,a2,48
}
ffffffffc0202a7c:	4501                	li	a0,0
    prev->next = next->prev = elm;
ffffffffc0202a7e:	e298                	sd	a4,0(a3)
ffffffffc0202a80:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0202a82:	fe14                	sd	a3,56(a2)
    elm->prev = prev;
ffffffffc0202a84:	fa1c                	sd	a5,48(a2)
ffffffffc0202a86:	8082                	ret
{
ffffffffc0202a88:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0202a8a:	00003697          	auipc	a3,0x3
ffffffffc0202a8e:	12668693          	addi	a3,a3,294 # ffffffffc0205bb0 <default_pmm_manager+0x1e8>
ffffffffc0202a92:	00002617          	auipc	a2,0x2
ffffffffc0202a96:	44660613          	addi	a2,a2,1094 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0202a9a:	45f1                	li	a1,28
ffffffffc0202a9c:	00003517          	auipc	a0,0x3
ffffffffc0202aa0:	f8c50513          	addi	a0,a0,-116 # ffffffffc0205a28 <default_pmm_manager+0x60>
{
ffffffffc0202aa4:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc0202aa6:	e5cfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202aaa <pa2page.part.0>:
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202aaa:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202aac:	00002617          	auipc	a2,0x2
ffffffffc0202ab0:	67c60613          	addi	a2,a2,1660 # ffffffffc0205128 <commands+0x9c0>
ffffffffc0202ab4:	06500593          	li	a1,101
ffffffffc0202ab8:	00002517          	auipc	a0,0x2
ffffffffc0202abc:	69050513          	addi	a0,a0,1680 # ffffffffc0205148 <commands+0x9e0>
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202ac0:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202ac2:	e40fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202ac6 <pte2page.part.0>:
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202ac6:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202ac8:	00003617          	auipc	a2,0x3
ffffffffc0202acc:	9e860613          	addi	a2,a2,-1560 # ffffffffc02054b0 <commands+0xd48>
ffffffffc0202ad0:	07000593          	li	a1,112
ffffffffc0202ad4:	00002517          	auipc	a0,0x2
ffffffffc0202ad8:	67450513          	addi	a0,a0,1652 # ffffffffc0205148 <commands+0x9e0>
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202adc:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202ade:	e24fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202ae2 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0202ae2:	7139                	addi	sp,sp,-64
ffffffffc0202ae4:	f426                	sd	s1,40(sp)
ffffffffc0202ae6:	f04a                	sd	s2,32(sp)
ffffffffc0202ae8:	ec4e                	sd	s3,24(sp)
ffffffffc0202aea:	e852                	sd	s4,16(sp)
ffffffffc0202aec:	e456                	sd	s5,8(sp)
ffffffffc0202aee:	e05a                	sd	s6,0(sp)
ffffffffc0202af0:	fc06                	sd	ra,56(sp)
ffffffffc0202af2:	f822                	sd	s0,48(sp)
ffffffffc0202af4:	84aa                	mv	s1,a0
ffffffffc0202af6:	0000f917          	auipc	s2,0xf
ffffffffc0202afa:	a6a90913          	addi	s2,s2,-1430 # ffffffffc0211560 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202afe:	4a05                	li	s4,1
ffffffffc0202b00:	0000fa97          	auipc	s5,0xf
ffffffffc0202b04:	a38a8a93          	addi	s5,s5,-1480 # ffffffffc0211538 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b08:	0005099b          	sext.w	s3,a0
ffffffffc0202b0c:	0000fb17          	auipc	s6,0xf
ffffffffc0202b10:	a0cb0b13          	addi	s6,s6,-1524 # ffffffffc0211518 <check_mm_struct>
ffffffffc0202b14:	a01d                	j	ffffffffc0202b3a <alloc_pages+0x58>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202b16:	00093783          	ld	a5,0(s2)
ffffffffc0202b1a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b1c:	9782                	jalr	a5
ffffffffc0202b1e:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b20:	4601                	li	a2,0
ffffffffc0202b22:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202b24:	ec0d                	bnez	s0,ffffffffc0202b5e <alloc_pages+0x7c>
ffffffffc0202b26:	029a6c63          	bltu	s4,s1,ffffffffc0202b5e <alloc_pages+0x7c>
ffffffffc0202b2a:	000aa783          	lw	a5,0(s5)
ffffffffc0202b2e:	2781                	sext.w	a5,a5
ffffffffc0202b30:	c79d                	beqz	a5,ffffffffc0202b5e <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b32:	000b3503          	ld	a0,0(s6)
ffffffffc0202b36:	f07fe0ef          	jal	ra,ffffffffc0201a3c <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b3a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b3e:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202b40:	8526                	mv	a0,s1
ffffffffc0202b42:	dbf1                	beqz	a5,ffffffffc0202b16 <alloc_pages+0x34>
        intr_disable();
ffffffffc0202b44:	9abfd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202b48:	00093783          	ld	a5,0(s2)
ffffffffc0202b4c:	8526                	mv	a0,s1
ffffffffc0202b4e:	6f9c                	ld	a5,24(a5)
ffffffffc0202b50:	9782                	jalr	a5
ffffffffc0202b52:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202b54:	995fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b58:	4601                	li	a2,0
ffffffffc0202b5a:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202b5c:	d469                	beqz	s0,ffffffffc0202b26 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0202b5e:	70e2                	ld	ra,56(sp)
ffffffffc0202b60:	8522                	mv	a0,s0
ffffffffc0202b62:	7442                	ld	s0,48(sp)
ffffffffc0202b64:	74a2                	ld	s1,40(sp)
ffffffffc0202b66:	7902                	ld	s2,32(sp)
ffffffffc0202b68:	69e2                	ld	s3,24(sp)
ffffffffc0202b6a:	6a42                	ld	s4,16(sp)
ffffffffc0202b6c:	6aa2                	ld	s5,8(sp)
ffffffffc0202b6e:	6b02                	ld	s6,0(sp)
ffffffffc0202b70:	6121                	addi	sp,sp,64
ffffffffc0202b72:	8082                	ret

ffffffffc0202b74 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b74:	100027f3          	csrr	a5,sstatus
ffffffffc0202b78:	8b89                	andi	a5,a5,2
ffffffffc0202b7a:	e799                	bnez	a5,ffffffffc0202b88 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc0202b7c:	0000f797          	auipc	a5,0xf
ffffffffc0202b80:	9e47b783          	ld	a5,-1564(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202b84:	739c                	ld	a5,32(a5)
ffffffffc0202b86:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0202b88:	1101                	addi	sp,sp,-32
ffffffffc0202b8a:	ec06                	sd	ra,24(sp)
ffffffffc0202b8c:	e822                	sd	s0,16(sp)
ffffffffc0202b8e:	e426                	sd	s1,8(sp)
ffffffffc0202b90:	842a                	mv	s0,a0
ffffffffc0202b92:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202b94:	95bfd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202b98:	0000f797          	auipc	a5,0xf
ffffffffc0202b9c:	9c87b783          	ld	a5,-1592(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ba0:	739c                	ld	a5,32(a5)
ffffffffc0202ba2:	85a6                	mv	a1,s1
ffffffffc0202ba4:	8522                	mv	a0,s0
ffffffffc0202ba6:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc0202ba8:	6442                	ld	s0,16(sp)
ffffffffc0202baa:	60e2                	ld	ra,24(sp)
ffffffffc0202bac:	64a2                	ld	s1,8(sp)
ffffffffc0202bae:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202bb0:	939fd06f          	j	ffffffffc02004e8 <intr_enable>

ffffffffc0202bb4 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202bb4:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb8:	8b89                	andi	a5,a5,2
ffffffffc0202bba:	e799                	bnez	a5,ffffffffc0202bc8 <nr_free_pages+0x14>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202bbc:	0000f797          	auipc	a5,0xf
ffffffffc0202bc0:	9a47b783          	ld	a5,-1628(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202bc4:	779c                	ld	a5,40(a5)
ffffffffc0202bc6:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0202bc8:	1141                	addi	sp,sp,-16
ffffffffc0202bca:	e406                	sd	ra,8(sp)
ffffffffc0202bcc:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202bce:	921fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202bd2:	0000f797          	auipc	a5,0xf
ffffffffc0202bd6:	98e7b783          	ld	a5,-1650(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202bda:	779c                	ld	a5,40(a5)
ffffffffc0202bdc:	9782                	jalr	a5
ffffffffc0202bde:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202be0:	909fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202be4:	60a2                	ld	ra,8(sp)
ffffffffc0202be6:	8522                	mv	a0,s0
ffffffffc0202be8:	6402                	ld	s0,0(sp)
ffffffffc0202bea:	0141                	addi	sp,sp,16
ffffffffc0202bec:	8082                	ret

ffffffffc0202bee <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202bee:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202bf2:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202bf6:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202bf8:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202bfa:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202bfc:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c00:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c02:	f84a                	sd	s2,48(sp)
ffffffffc0202c04:	f44e                	sd	s3,40(sp)
ffffffffc0202c06:	f052                	sd	s4,32(sp)
ffffffffc0202c08:	e486                	sd	ra,72(sp)
ffffffffc0202c0a:	e0a2                	sd	s0,64(sp)
ffffffffc0202c0c:	ec56                	sd	s5,24(sp)
ffffffffc0202c0e:	e85a                	sd	s6,16(sp)
ffffffffc0202c10:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c12:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c16:	892e                	mv	s2,a1
ffffffffc0202c18:	8a32                	mv	s4,a2
ffffffffc0202c1a:	0000f997          	auipc	s3,0xf
ffffffffc0202c1e:	93698993          	addi	s3,s3,-1738 # ffffffffc0211550 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c22:	efb5                	bnez	a5,ffffffffc0202c9e <get_pte+0xb0>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202c24:	14060c63          	beqz	a2,ffffffffc0202d7c <get_pte+0x18e>
ffffffffc0202c28:	4505                	li	a0,1
ffffffffc0202c2a:	eb9ff0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0202c2e:	842a                	mv	s0,a0
ffffffffc0202c30:	14050663          	beqz	a0,ffffffffc0202d7c <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c34:	0000fb97          	auipc	s7,0xf
ffffffffc0202c38:	924b8b93          	addi	s7,s7,-1756 # ffffffffc0211558 <pages>
ffffffffc0202c3c:	000bb503          	ld	a0,0(s7)
ffffffffc0202c40:	00004b17          	auipc	s6,0x4
ffffffffc0202c44:	840b3b03          	ld	s6,-1984(s6) # ffffffffc0206480 <error_string+0x38>
ffffffffc0202c48:	00080ab7          	lui	s5,0x80
ffffffffc0202c4c:	40a40533          	sub	a0,s0,a0
ffffffffc0202c50:	850d                	srai	a0,a0,0x3
ffffffffc0202c52:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202c56:	0000f997          	auipc	s3,0xf
ffffffffc0202c5a:	8fa98993          	addi	s3,s3,-1798 # ffffffffc0211550 <npage>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202c5e:	4785                	li	a5,1
ffffffffc0202c60:	0009b703          	ld	a4,0(s3)
ffffffffc0202c64:	c01c                	sw	a5,0(s0)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c66:	9556                	add	a0,a0,s5
ffffffffc0202c68:	00c51793          	slli	a5,a0,0xc
ffffffffc0202c6c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c6e:	0532                	slli	a0,a0,0xc
ffffffffc0202c70:	14e7fd63          	bgeu	a5,a4,ffffffffc0202dca <get_pte+0x1dc>
ffffffffc0202c74:	0000f797          	auipc	a5,0xf
ffffffffc0202c78:	8f47b783          	ld	a5,-1804(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0202c7c:	6605                	lui	a2,0x1
ffffffffc0202c7e:	4581                	li	a1,0
ffffffffc0202c80:	953e                	add	a0,a0,a5
ffffffffc0202c82:	3a2010ef          	jal	ra,ffffffffc0204024 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c86:	000bb683          	ld	a3,0(s7)
ffffffffc0202c8a:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c8e:	868d                	srai	a3,a3,0x3
ffffffffc0202c90:	036686b3          	mul	a3,a3,s6
ffffffffc0202c94:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202c96:	06aa                	slli	a3,a3,0xa
ffffffffc0202c98:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202c9c:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202c9e:	77fd                	lui	a5,0xfffff
ffffffffc0202ca0:	068a                	slli	a3,a3,0x2
ffffffffc0202ca2:	0009b703          	ld	a4,0(s3)
ffffffffc0202ca6:	8efd                	and	a3,a3,a5
ffffffffc0202ca8:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202cac:	0ce7fa63          	bgeu	a5,a4,ffffffffc0202d80 <get_pte+0x192>
ffffffffc0202cb0:	0000fa97          	auipc	s5,0xf
ffffffffc0202cb4:	8b8a8a93          	addi	s5,s5,-1864 # ffffffffc0211568 <va_pa_offset>
ffffffffc0202cb8:	000ab403          	ld	s0,0(s5)
ffffffffc0202cbc:	01595793          	srli	a5,s2,0x15
ffffffffc0202cc0:	1ff7f793          	andi	a5,a5,511
ffffffffc0202cc4:	96a2                	add	a3,a3,s0
ffffffffc0202cc6:	00379413          	slli	s0,a5,0x3
ffffffffc0202cca:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc0202ccc:	6014                	ld	a3,0(s0)
ffffffffc0202cce:	0016f793          	andi	a5,a3,1
ffffffffc0202cd2:	ebad                	bnez	a5,ffffffffc0202d44 <get_pte+0x156>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202cd4:	0a0a0463          	beqz	s4,ffffffffc0202d7c <get_pte+0x18e>
ffffffffc0202cd8:	4505                	li	a0,1
ffffffffc0202cda:	e09ff0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0202cde:	84aa                	mv	s1,a0
ffffffffc0202ce0:	cd51                	beqz	a0,ffffffffc0202d7c <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202ce2:	0000fb97          	auipc	s7,0xf
ffffffffc0202ce6:	876b8b93          	addi	s7,s7,-1930 # ffffffffc0211558 <pages>
ffffffffc0202cea:	000bb503          	ld	a0,0(s7)
ffffffffc0202cee:	00003b17          	auipc	s6,0x3
ffffffffc0202cf2:	792b3b03          	ld	s6,1938(s6) # ffffffffc0206480 <error_string+0x38>
ffffffffc0202cf6:	00080a37          	lui	s4,0x80
ffffffffc0202cfa:	40a48533          	sub	a0,s1,a0
ffffffffc0202cfe:	850d                	srai	a0,a0,0x3
ffffffffc0202d00:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202d04:	4785                	li	a5,1
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202d06:	0009b703          	ld	a4,0(s3)
ffffffffc0202d0a:	c09c                	sw	a5,0(s1)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202d0c:	9552                	add	a0,a0,s4
ffffffffc0202d0e:	00c51793          	slli	a5,a0,0xc
ffffffffc0202d12:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d14:	0532                	slli	a0,a0,0xc
ffffffffc0202d16:	08e7fd63          	bgeu	a5,a4,ffffffffc0202db0 <get_pte+0x1c2>
ffffffffc0202d1a:	000ab783          	ld	a5,0(s5)
ffffffffc0202d1e:	6605                	lui	a2,0x1
ffffffffc0202d20:	4581                	li	a1,0
ffffffffc0202d22:	953e                	add	a0,a0,a5
ffffffffc0202d24:	300010ef          	jal	ra,ffffffffc0204024 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202d28:	000bb683          	ld	a3,0(s7)
ffffffffc0202d2c:	40d486b3          	sub	a3,s1,a3
ffffffffc0202d30:	868d                	srai	a3,a3,0x3
ffffffffc0202d32:	036686b3          	mul	a3,a3,s6
ffffffffc0202d36:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202d38:	06aa                	slli	a3,a3,0xa
ffffffffc0202d3a:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202d3e:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202d40:	0009b703          	ld	a4,0(s3)
ffffffffc0202d44:	068a                	slli	a3,a3,0x2
ffffffffc0202d46:	757d                	lui	a0,0xfffff
ffffffffc0202d48:	8ee9                	and	a3,a3,a0
ffffffffc0202d4a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202d4e:	04e7f563          	bgeu	a5,a4,ffffffffc0202d98 <get_pte+0x1aa>
ffffffffc0202d52:	000ab503          	ld	a0,0(s5)
ffffffffc0202d56:	00c95913          	srli	s2,s2,0xc
ffffffffc0202d5a:	1ff97913          	andi	s2,s2,511
ffffffffc0202d5e:	96aa                	add	a3,a3,a0
ffffffffc0202d60:	00391513          	slli	a0,s2,0x3
ffffffffc0202d64:	9536                	add	a0,a0,a3
}
ffffffffc0202d66:	60a6                	ld	ra,72(sp)
ffffffffc0202d68:	6406                	ld	s0,64(sp)
ffffffffc0202d6a:	74e2                	ld	s1,56(sp)
ffffffffc0202d6c:	7942                	ld	s2,48(sp)
ffffffffc0202d6e:	79a2                	ld	s3,40(sp)
ffffffffc0202d70:	7a02                	ld	s4,32(sp)
ffffffffc0202d72:	6ae2                	ld	s5,24(sp)
ffffffffc0202d74:	6b42                	ld	s6,16(sp)
ffffffffc0202d76:	6ba2                	ld	s7,8(sp)
ffffffffc0202d78:	6161                	addi	sp,sp,80
ffffffffc0202d7a:	8082                	ret
            return NULL;
ffffffffc0202d7c:	4501                	li	a0,0
ffffffffc0202d7e:	b7e5                	j	ffffffffc0202d66 <get_pte+0x178>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202d80:	00003617          	auipc	a2,0x3
ffffffffc0202d84:	e6860613          	addi	a2,a2,-408 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0202d88:	10200593          	li	a1,258
ffffffffc0202d8c:	00003517          	auipc	a0,0x3
ffffffffc0202d90:	e8450513          	addi	a0,a0,-380 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0202d94:	b6efd0ef          	jal	ra,ffffffffc0200102 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202d98:	00003617          	auipc	a2,0x3
ffffffffc0202d9c:	e5060613          	addi	a2,a2,-432 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0202da0:	10f00593          	li	a1,271
ffffffffc0202da4:	00003517          	auipc	a0,0x3
ffffffffc0202da8:	e6c50513          	addi	a0,a0,-404 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0202dac:	b56fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202db0:	86aa                	mv	a3,a0
ffffffffc0202db2:	00003617          	auipc	a2,0x3
ffffffffc0202db6:	e3660613          	addi	a2,a2,-458 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0202dba:	10b00593          	li	a1,267
ffffffffc0202dbe:	00003517          	auipc	a0,0x3
ffffffffc0202dc2:	e5250513          	addi	a0,a0,-430 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0202dc6:	b3cfd0ef          	jal	ra,ffffffffc0200102 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202dca:	86aa                	mv	a3,a0
ffffffffc0202dcc:	00003617          	auipc	a2,0x3
ffffffffc0202dd0:	e1c60613          	addi	a2,a2,-484 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0202dd4:	0ff00593          	li	a1,255
ffffffffc0202dd8:	00003517          	auipc	a0,0x3
ffffffffc0202ddc:	e3850513          	addi	a0,a0,-456 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0202de0:	b22fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202de4 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202de4:	1141                	addi	sp,sp,-16
ffffffffc0202de6:	e022                	sd	s0,0(sp)
ffffffffc0202de8:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202dea:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202dec:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202dee:	e01ff0ef          	jal	ra,ffffffffc0202bee <get_pte>
    if (ptep_store != NULL) {
ffffffffc0202df2:	c011                	beqz	s0,ffffffffc0202df6 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0202df4:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202df6:	c511                	beqz	a0,ffffffffc0202e02 <get_page+0x1e>
ffffffffc0202df8:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202dfa:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202dfc:	0017f713          	andi	a4,a5,1
ffffffffc0202e00:	e709                	bnez	a4,ffffffffc0202e0a <get_page+0x26>
}
ffffffffc0202e02:	60a2                	ld	ra,8(sp)
ffffffffc0202e04:	6402                	ld	s0,0(sp)
ffffffffc0202e06:	0141                	addi	sp,sp,16
ffffffffc0202e08:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202e0a:	078a                	slli	a5,a5,0x2
ffffffffc0202e0c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e0e:	0000e717          	auipc	a4,0xe
ffffffffc0202e12:	74273703          	ld	a4,1858(a4) # ffffffffc0211550 <npage>
ffffffffc0202e16:	02e7f263          	bgeu	a5,a4,ffffffffc0202e3a <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e1a:	fff80537          	lui	a0,0xfff80
ffffffffc0202e1e:	97aa                	add	a5,a5,a0
ffffffffc0202e20:	60a2                	ld	ra,8(sp)
ffffffffc0202e22:	6402                	ld	s0,0(sp)
ffffffffc0202e24:	00379513          	slli	a0,a5,0x3
ffffffffc0202e28:	97aa                	add	a5,a5,a0
ffffffffc0202e2a:	078e                	slli	a5,a5,0x3
ffffffffc0202e2c:	0000e517          	auipc	a0,0xe
ffffffffc0202e30:	72c53503          	ld	a0,1836(a0) # ffffffffc0211558 <pages>
ffffffffc0202e34:	953e                	add	a0,a0,a5
ffffffffc0202e36:	0141                	addi	sp,sp,16
ffffffffc0202e38:	8082                	ret
ffffffffc0202e3a:	c71ff0ef          	jal	ra,ffffffffc0202aaa <pa2page.part.0>

ffffffffc0202e3e <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202e3e:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e40:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202e42:	ec06                	sd	ra,24(sp)
ffffffffc0202e44:	e822                	sd	s0,16(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e46:	da9ff0ef          	jal	ra,ffffffffc0202bee <get_pte>
    if (ptep != NULL) {
ffffffffc0202e4a:	c511                	beqz	a0,ffffffffc0202e56 <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0202e4c:	611c                	ld	a5,0(a0)
ffffffffc0202e4e:	842a                	mv	s0,a0
ffffffffc0202e50:	0017f713          	andi	a4,a5,1
ffffffffc0202e54:	e709                	bnez	a4,ffffffffc0202e5e <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0202e56:	60e2                	ld	ra,24(sp)
ffffffffc0202e58:	6442                	ld	s0,16(sp)
ffffffffc0202e5a:	6105                	addi	sp,sp,32
ffffffffc0202e5c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202e5e:	078a                	slli	a5,a5,0x2
ffffffffc0202e60:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e62:	0000e717          	auipc	a4,0xe
ffffffffc0202e66:	6ee73703          	ld	a4,1774(a4) # ffffffffc0211550 <npage>
ffffffffc0202e6a:	06e7f563          	bgeu	a5,a4,ffffffffc0202ed4 <page_remove+0x96>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e6e:	fff80737          	lui	a4,0xfff80
ffffffffc0202e72:	97ba                	add	a5,a5,a4
ffffffffc0202e74:	00379513          	slli	a0,a5,0x3
ffffffffc0202e78:	97aa                	add	a5,a5,a0
ffffffffc0202e7a:	078e                	slli	a5,a5,0x3
ffffffffc0202e7c:	0000e517          	auipc	a0,0xe
ffffffffc0202e80:	6dc53503          	ld	a0,1756(a0) # ffffffffc0211558 <pages>
ffffffffc0202e84:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202e86:	411c                	lw	a5,0(a0)
ffffffffc0202e88:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202e8c:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202e8e:	cb09                	beqz	a4,ffffffffc0202ea0 <page_remove+0x62>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202e90:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202e94:	12000073          	sfence.vma
}
ffffffffc0202e98:	60e2                	ld	ra,24(sp)
ffffffffc0202e9a:	6442                	ld	s0,16(sp)
ffffffffc0202e9c:	6105                	addi	sp,sp,32
ffffffffc0202e9e:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202ea0:	100027f3          	csrr	a5,sstatus
ffffffffc0202ea4:	8b89                	andi	a5,a5,2
ffffffffc0202ea6:	eb89                	bnez	a5,ffffffffc0202eb8 <page_remove+0x7a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202ea8:	0000e797          	auipc	a5,0xe
ffffffffc0202eac:	6b87b783          	ld	a5,1720(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202eb0:	739c                	ld	a5,32(a5)
ffffffffc0202eb2:	4585                	li	a1,1
ffffffffc0202eb4:	9782                	jalr	a5
    if (flag) {
ffffffffc0202eb6:	bfe9                	j	ffffffffc0202e90 <page_remove+0x52>
        intr_disable();
ffffffffc0202eb8:	e42a                	sd	a0,8(sp)
ffffffffc0202eba:	e34fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202ebe:	0000e797          	auipc	a5,0xe
ffffffffc0202ec2:	6a27b783          	ld	a5,1698(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ec6:	739c                	ld	a5,32(a5)
ffffffffc0202ec8:	6522                	ld	a0,8(sp)
ffffffffc0202eca:	4585                	li	a1,1
ffffffffc0202ecc:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ece:	e1afd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202ed2:	bf7d                	j	ffffffffc0202e90 <page_remove+0x52>
ffffffffc0202ed4:	bd7ff0ef          	jal	ra,ffffffffc0202aaa <pa2page.part.0>

ffffffffc0202ed8 <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202ed8:	7179                	addi	sp,sp,-48
ffffffffc0202eda:	87b2                	mv	a5,a2
ffffffffc0202edc:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202ede:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202ee0:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202ee2:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202ee4:	ec26                	sd	s1,24(sp)
ffffffffc0202ee6:	f406                	sd	ra,40(sp)
ffffffffc0202ee8:	e84a                	sd	s2,16(sp)
ffffffffc0202eea:	e44e                	sd	s3,8(sp)
ffffffffc0202eec:	e052                	sd	s4,0(sp)
ffffffffc0202eee:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202ef0:	cffff0ef          	jal	ra,ffffffffc0202bee <get_pte>
    if (ptep == NULL) {
ffffffffc0202ef4:	cd71                	beqz	a0,ffffffffc0202fd0 <page_insert+0xf8>
    page->ref += 1;
ffffffffc0202ef6:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_V) {
ffffffffc0202ef8:	611c                	ld	a5,0(a0)
ffffffffc0202efa:	89aa                	mv	s3,a0
ffffffffc0202efc:	0016871b          	addiw	a4,a3,1
ffffffffc0202f00:	c018                	sw	a4,0(s0)
ffffffffc0202f02:	0017f713          	andi	a4,a5,1
ffffffffc0202f06:	e331                	bnez	a4,ffffffffc0202f4a <page_insert+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202f08:	0000e797          	auipc	a5,0xe
ffffffffc0202f0c:	6507b783          	ld	a5,1616(a5) # ffffffffc0211558 <pages>
ffffffffc0202f10:	40f407b3          	sub	a5,s0,a5
ffffffffc0202f14:	878d                	srai	a5,a5,0x3
ffffffffc0202f16:	00003417          	auipc	s0,0x3
ffffffffc0202f1a:	56a43403          	ld	s0,1386(s0) # ffffffffc0206480 <error_string+0x38>
ffffffffc0202f1e:	028787b3          	mul	a5,a5,s0
ffffffffc0202f22:	00080437          	lui	s0,0x80
ffffffffc0202f26:	97a2                	add	a5,a5,s0
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202f28:	07aa                	slli	a5,a5,0xa
ffffffffc0202f2a:	8cdd                	or	s1,s1,a5
ffffffffc0202f2c:	0014e493          	ori	s1,s1,1
            page_ref_dec(page);
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202f30:	0099b023          	sd	s1,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202f34:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0202f38:	4501                	li	a0,0
}
ffffffffc0202f3a:	70a2                	ld	ra,40(sp)
ffffffffc0202f3c:	7402                	ld	s0,32(sp)
ffffffffc0202f3e:	64e2                	ld	s1,24(sp)
ffffffffc0202f40:	6942                	ld	s2,16(sp)
ffffffffc0202f42:	69a2                	ld	s3,8(sp)
ffffffffc0202f44:	6a02                	ld	s4,0(sp)
ffffffffc0202f46:	6145                	addi	sp,sp,48
ffffffffc0202f48:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202f4a:	00279713          	slli	a4,a5,0x2
ffffffffc0202f4e:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202f50:	0000e797          	auipc	a5,0xe
ffffffffc0202f54:	6007b783          	ld	a5,1536(a5) # ffffffffc0211550 <npage>
ffffffffc0202f58:	06f77e63          	bgeu	a4,a5,ffffffffc0202fd4 <page_insert+0xfc>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f5c:	fff807b7          	lui	a5,0xfff80
ffffffffc0202f60:	973e                	add	a4,a4,a5
ffffffffc0202f62:	0000ea17          	auipc	s4,0xe
ffffffffc0202f66:	5f6a0a13          	addi	s4,s4,1526 # ffffffffc0211558 <pages>
ffffffffc0202f6a:	000a3783          	ld	a5,0(s4)
ffffffffc0202f6e:	00371913          	slli	s2,a4,0x3
ffffffffc0202f72:	993a                	add	s2,s2,a4
ffffffffc0202f74:	090e                	slli	s2,s2,0x3
ffffffffc0202f76:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0202f78:	03240063          	beq	s0,s2,ffffffffc0202f98 <page_insert+0xc0>
    page->ref -= 1;
ffffffffc0202f7c:	00092783          	lw	a5,0(s2)
ffffffffc0202f80:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202f84:	00e92023          	sw	a4,0(s2)
        if (page_ref(page) ==
ffffffffc0202f88:	cb11                	beqz	a4,ffffffffc0202f9c <page_insert+0xc4>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202f8a:	0009b023          	sd	zero,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202f8e:	12000073          	sfence.vma
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202f92:	000a3783          	ld	a5,0(s4)
}
ffffffffc0202f96:	bfad                	j	ffffffffc0202f10 <page_insert+0x38>
    page->ref -= 1;
ffffffffc0202f98:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202f9a:	bf9d                	j	ffffffffc0202f10 <page_insert+0x38>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202f9c:	100027f3          	csrr	a5,sstatus
ffffffffc0202fa0:	8b89                	andi	a5,a5,2
ffffffffc0202fa2:	eb91                	bnez	a5,ffffffffc0202fb6 <page_insert+0xde>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202fa4:	0000e797          	auipc	a5,0xe
ffffffffc0202fa8:	5bc7b783          	ld	a5,1468(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202fac:	739c                	ld	a5,32(a5)
ffffffffc0202fae:	4585                	li	a1,1
ffffffffc0202fb0:	854a                	mv	a0,s2
ffffffffc0202fb2:	9782                	jalr	a5
    if (flag) {
ffffffffc0202fb4:	bfd9                	j	ffffffffc0202f8a <page_insert+0xb2>
        intr_disable();
ffffffffc0202fb6:	d38fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202fba:	0000e797          	auipc	a5,0xe
ffffffffc0202fbe:	5a67b783          	ld	a5,1446(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202fc2:	739c                	ld	a5,32(a5)
ffffffffc0202fc4:	4585                	li	a1,1
ffffffffc0202fc6:	854a                	mv	a0,s2
ffffffffc0202fc8:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fca:	d1efd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202fce:	bf75                	j	ffffffffc0202f8a <page_insert+0xb2>
        return -E_NO_MEM;
ffffffffc0202fd0:	5571                	li	a0,-4
ffffffffc0202fd2:	b7a5                	j	ffffffffc0202f3a <page_insert+0x62>
ffffffffc0202fd4:	ad7ff0ef          	jal	ra,ffffffffc0202aaa <pa2page.part.0>

ffffffffc0202fd8 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202fd8:	00003797          	auipc	a5,0x3
ffffffffc0202fdc:	9f078793          	addi	a5,a5,-1552 # ffffffffc02059c8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202fe0:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0202fe2:	7159                	addi	sp,sp,-112
ffffffffc0202fe4:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202fe6:	00003517          	auipc	a0,0x3
ffffffffc0202fea:	c3a50513          	addi	a0,a0,-966 # ffffffffc0205c20 <default_pmm_manager+0x258>
    pmm_manager = &default_pmm_manager;
ffffffffc0202fee:	0000eb97          	auipc	s7,0xe
ffffffffc0202ff2:	572b8b93          	addi	s7,s7,1394 # ffffffffc0211560 <pmm_manager>
void pmm_init(void) {
ffffffffc0202ff6:	f486                	sd	ra,104(sp)
ffffffffc0202ff8:	f0a2                	sd	s0,96(sp)
ffffffffc0202ffa:	eca6                	sd	s1,88(sp)
ffffffffc0202ffc:	e8ca                	sd	s2,80(sp)
ffffffffc0202ffe:	e4ce                	sd	s3,72(sp)
ffffffffc0203000:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0203002:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0203006:	e0d2                	sd	s4,64(sp)
ffffffffc0203008:	fc56                	sd	s5,56(sp)
ffffffffc020300a:	f062                	sd	s8,32(sp)
ffffffffc020300c:	ec66                	sd	s9,24(sp)
ffffffffc020300e:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0203010:	8aafd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0203014:	000bb783          	ld	a5,0(s7)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0203018:	4445                	li	s0,17
ffffffffc020301a:	40100913          	li	s2,1025
    pmm_manager->init();
ffffffffc020301e:	679c                	ld	a5,8(a5)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0203020:	0000e997          	auipc	s3,0xe
ffffffffc0203024:	54898993          	addi	s3,s3,1352 # ffffffffc0211568 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0203028:	0000e497          	auipc	s1,0xe
ffffffffc020302c:	52848493          	addi	s1,s1,1320 # ffffffffc0211550 <npage>
    pmm_manager->init();
ffffffffc0203030:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0203032:	57f5                	li	a5,-3
ffffffffc0203034:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0203036:	07e006b7          	lui	a3,0x7e00
ffffffffc020303a:	01b41613          	slli	a2,s0,0x1b
ffffffffc020303e:	01591593          	slli	a1,s2,0x15
ffffffffc0203042:	00003517          	auipc	a0,0x3
ffffffffc0203046:	bf650513          	addi	a0,a0,-1034 # ffffffffc0205c38 <default_pmm_manager+0x270>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc020304a:	00f9b023          	sd	a5,0(s3)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc020304e:	86cfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0203052:	00003517          	auipc	a0,0x3
ffffffffc0203056:	c1650513          	addi	a0,a0,-1002 # ffffffffc0205c68 <default_pmm_manager+0x2a0>
ffffffffc020305a:	860fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020305e:	01b41693          	slli	a3,s0,0x1b
ffffffffc0203062:	16fd                	addi	a3,a3,-1
ffffffffc0203064:	07e005b7          	lui	a1,0x7e00
ffffffffc0203068:	01591613          	slli	a2,s2,0x15
ffffffffc020306c:	00003517          	auipc	a0,0x3
ffffffffc0203070:	c1450513          	addi	a0,a0,-1004 # ffffffffc0205c80 <default_pmm_manager+0x2b8>
ffffffffc0203074:	846fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0203078:	777d                	lui	a4,0xfffff
ffffffffc020307a:	0000f797          	auipc	a5,0xf
ffffffffc020307e:	4f578793          	addi	a5,a5,1269 # ffffffffc021256f <end+0xfff>
ffffffffc0203082:	8ff9                	and	a5,a5,a4
ffffffffc0203084:	0000eb17          	auipc	s6,0xe
ffffffffc0203088:	4d4b0b13          	addi	s6,s6,1236 # ffffffffc0211558 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020308c:	00088737          	lui	a4,0x88
ffffffffc0203090:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0203092:	00fb3023          	sd	a5,0(s6)
ffffffffc0203096:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0203098:	4701                	li	a4,0
ffffffffc020309a:	4505                	li	a0,1
ffffffffc020309c:	fff805b7          	lui	a1,0xfff80
ffffffffc02030a0:	a019                	j	ffffffffc02030a6 <pmm_init+0xce>
        SetPageReserved(pages + i);
ffffffffc02030a2:	000b3783          	ld	a5,0(s6)
ffffffffc02030a6:	97b6                	add	a5,a5,a3
ffffffffc02030a8:	07a1                	addi	a5,a5,8
ffffffffc02030aa:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02030ae:	609c                	ld	a5,0(s1)
ffffffffc02030b0:	0705                	addi	a4,a4,1
ffffffffc02030b2:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc02030b6:	00b78633          	add	a2,a5,a1
ffffffffc02030ba:	fec764e3          	bltu	a4,a2,ffffffffc02030a2 <pmm_init+0xca>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02030be:	000b3503          	ld	a0,0(s6)
ffffffffc02030c2:	00379693          	slli	a3,a5,0x3
ffffffffc02030c6:	96be                	add	a3,a3,a5
ffffffffc02030c8:	fdc00737          	lui	a4,0xfdc00
ffffffffc02030cc:	972a                	add	a4,a4,a0
ffffffffc02030ce:	068e                	slli	a3,a3,0x3
ffffffffc02030d0:	96ba                	add	a3,a3,a4
ffffffffc02030d2:	c0200737          	lui	a4,0xc0200
ffffffffc02030d6:	64e6e463          	bltu	a3,a4,ffffffffc020371e <pmm_init+0x746>
ffffffffc02030da:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc02030de:	4645                	li	a2,17
ffffffffc02030e0:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02030e2:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02030e4:	4ec6e263          	bltu	a3,a2,ffffffffc02035c8 <pmm_init+0x5f0>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02030e8:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc02030ec:	0000e917          	auipc	s2,0xe
ffffffffc02030f0:	45c90913          	addi	s2,s2,1116 # ffffffffc0211548 <boot_pgdir>
    pmm_manager->check();
ffffffffc02030f4:	7b9c                	ld	a5,48(a5)
ffffffffc02030f6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02030f8:	00003517          	auipc	a0,0x3
ffffffffc02030fc:	bd850513          	addi	a0,a0,-1064 # ffffffffc0205cd0 <default_pmm_manager+0x308>
ffffffffc0203100:	fbbfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0203104:	00006697          	auipc	a3,0x6
ffffffffc0203108:	efc68693          	addi	a3,a3,-260 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc020310c:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203110:	c02007b7          	lui	a5,0xc0200
ffffffffc0203114:	62f6e163          	bltu	a3,a5,ffffffffc0203736 <pmm_init+0x75e>
ffffffffc0203118:	0009b783          	ld	a5,0(s3)
ffffffffc020311c:	8e9d                	sub	a3,a3,a5
ffffffffc020311e:	0000e797          	auipc	a5,0xe
ffffffffc0203122:	42d7b123          	sd	a3,1058(a5) # ffffffffc0211540 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203126:	100027f3          	csrr	a5,sstatus
ffffffffc020312a:	8b89                	andi	a5,a5,2
ffffffffc020312c:	4c079763          	bnez	a5,ffffffffc02035fa <pmm_init+0x622>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203130:	000bb783          	ld	a5,0(s7)
ffffffffc0203134:	779c                	ld	a5,40(a5)
ffffffffc0203136:	9782                	jalr	a5
ffffffffc0203138:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020313a:	6098                	ld	a4,0(s1)
ffffffffc020313c:	c80007b7          	lui	a5,0xc8000
ffffffffc0203140:	83b1                	srli	a5,a5,0xc
ffffffffc0203142:	62e7e663          	bltu	a5,a4,ffffffffc020376e <pmm_init+0x796>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0203146:	00093503          	ld	a0,0(s2)
ffffffffc020314a:	60050263          	beqz	a0,ffffffffc020374e <pmm_init+0x776>
ffffffffc020314e:	03451793          	slli	a5,a0,0x34
ffffffffc0203152:	5e079e63          	bnez	a5,ffffffffc020374e <pmm_init+0x776>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0203156:	4601                	li	a2,0
ffffffffc0203158:	4581                	li	a1,0
ffffffffc020315a:	c8bff0ef          	jal	ra,ffffffffc0202de4 <get_page>
ffffffffc020315e:	66051a63          	bnez	a0,ffffffffc02037d2 <pmm_init+0x7fa>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc0203162:	4505                	li	a0,1
ffffffffc0203164:	97fff0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0203168:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc020316a:	00093503          	ld	a0,0(s2)
ffffffffc020316e:	4681                	li	a3,0
ffffffffc0203170:	4601                	li	a2,0
ffffffffc0203172:	85d2                	mv	a1,s4
ffffffffc0203174:	d65ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203178:	62051d63          	bnez	a0,ffffffffc02037b2 <pmm_init+0x7da>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc020317c:	00093503          	ld	a0,0(s2)
ffffffffc0203180:	4601                	li	a2,0
ffffffffc0203182:	4581                	li	a1,0
ffffffffc0203184:	a6bff0ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc0203188:	60050563          	beqz	a0,ffffffffc0203792 <pmm_init+0x7ba>
    assert(pte2page(*ptep) == p1);
ffffffffc020318c:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020318e:	0017f713          	andi	a4,a5,1
ffffffffc0203192:	5e070e63          	beqz	a4,ffffffffc020378e <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc0203196:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203198:	078a                	slli	a5,a5,0x2
ffffffffc020319a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020319c:	56c7ff63          	bgeu	a5,a2,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02031a0:	fff80737          	lui	a4,0xfff80
ffffffffc02031a4:	97ba                	add	a5,a5,a4
ffffffffc02031a6:	000b3683          	ld	a3,0(s6)
ffffffffc02031aa:	00379713          	slli	a4,a5,0x3
ffffffffc02031ae:	97ba                	add	a5,a5,a4
ffffffffc02031b0:	078e                	slli	a5,a5,0x3
ffffffffc02031b2:	97b6                	add	a5,a5,a3
ffffffffc02031b4:	14fa18e3          	bne	s4,a5,ffffffffc0203b04 <pmm_init+0xb2c>
    assert(page_ref(p1) == 1);
ffffffffc02031b8:	000a2703          	lw	a4,0(s4)
ffffffffc02031bc:	4785                	li	a5,1
ffffffffc02031be:	16f71fe3          	bne	a4,a5,ffffffffc0203b3c <pmm_init+0xb64>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc02031c2:	00093503          	ld	a0,0(s2)
ffffffffc02031c6:	77fd                	lui	a5,0xfffff
ffffffffc02031c8:	6114                	ld	a3,0(a0)
ffffffffc02031ca:	068a                	slli	a3,a3,0x2
ffffffffc02031cc:	8efd                	and	a3,a3,a5
ffffffffc02031ce:	00c6d713          	srli	a4,a3,0xc
ffffffffc02031d2:	14c779e3          	bgeu	a4,a2,ffffffffc0203b24 <pmm_init+0xb4c>
ffffffffc02031d6:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02031da:	96e2                	add	a3,a3,s8
ffffffffc02031dc:	0006ba83          	ld	s5,0(a3)
ffffffffc02031e0:	0a8a                	slli	s5,s5,0x2
ffffffffc02031e2:	00fafab3          	and	s5,s5,a5
ffffffffc02031e6:	00cad793          	srli	a5,s5,0xc
ffffffffc02031ea:	66c7f463          	bgeu	a5,a2,ffffffffc0203852 <pmm_init+0x87a>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02031ee:	4601                	li	a2,0
ffffffffc02031f0:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02031f2:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02031f4:	9fbff0ef          	jal	ra,ffffffffc0202bee <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02031f8:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02031fa:	63551c63          	bne	a0,s5,ffffffffc0203832 <pmm_init+0x85a>

    p2 = alloc_page();
ffffffffc02031fe:	4505                	li	a0,1
ffffffffc0203200:	8e3ff0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0203204:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203206:	00093503          	ld	a0,0(s2)
ffffffffc020320a:	46d1                	li	a3,20
ffffffffc020320c:	6605                	lui	a2,0x1
ffffffffc020320e:	85d6                	mv	a1,s5
ffffffffc0203210:	cc9ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203214:	5c051f63          	bnez	a0,ffffffffc02037f2 <pmm_init+0x81a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203218:	00093503          	ld	a0,0(s2)
ffffffffc020321c:	4601                	li	a2,0
ffffffffc020321e:	6585                	lui	a1,0x1
ffffffffc0203220:	9cfff0ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc0203224:	12050ce3          	beqz	a0,ffffffffc0203b5c <pmm_init+0xb84>
    assert(*ptep & PTE_U);
ffffffffc0203228:	611c                	ld	a5,0(a0)
ffffffffc020322a:	0107f713          	andi	a4,a5,16
ffffffffc020322e:	72070f63          	beqz	a4,ffffffffc020396c <pmm_init+0x994>
    assert(*ptep & PTE_W);
ffffffffc0203232:	8b91                	andi	a5,a5,4
ffffffffc0203234:	6e078c63          	beqz	a5,ffffffffc020392c <pmm_init+0x954>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0203238:	00093503          	ld	a0,0(s2)
ffffffffc020323c:	611c                	ld	a5,0(a0)
ffffffffc020323e:	8bc1                	andi	a5,a5,16
ffffffffc0203240:	6c078663          	beqz	a5,ffffffffc020390c <pmm_init+0x934>
    assert(page_ref(p2) == 1);
ffffffffc0203244:	000aa703          	lw	a4,0(s5)
ffffffffc0203248:	4785                	li	a5,1
ffffffffc020324a:	5cf71463          	bne	a4,a5,ffffffffc0203812 <pmm_init+0x83a>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc020324e:	4681                	li	a3,0
ffffffffc0203250:	6605                	lui	a2,0x1
ffffffffc0203252:	85d2                	mv	a1,s4
ffffffffc0203254:	c85ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203258:	66051a63          	bnez	a0,ffffffffc02038cc <pmm_init+0x8f4>
    assert(page_ref(p1) == 2);
ffffffffc020325c:	000a2703          	lw	a4,0(s4)
ffffffffc0203260:	4789                	li	a5,2
ffffffffc0203262:	64f71563          	bne	a4,a5,ffffffffc02038ac <pmm_init+0x8d4>
    assert(page_ref(p2) == 0);
ffffffffc0203266:	000aa783          	lw	a5,0(s5)
ffffffffc020326a:	62079163          	bnez	a5,ffffffffc020388c <pmm_init+0x8b4>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020326e:	00093503          	ld	a0,0(s2)
ffffffffc0203272:	4601                	li	a2,0
ffffffffc0203274:	6585                	lui	a1,0x1
ffffffffc0203276:	979ff0ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc020327a:	5e050963          	beqz	a0,ffffffffc020386c <pmm_init+0x894>
    assert(pte2page(*ptep) == p1);
ffffffffc020327e:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0203280:	00177793          	andi	a5,a4,1
ffffffffc0203284:	50078563          	beqz	a5,ffffffffc020378e <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc0203288:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020328a:	00271793          	slli	a5,a4,0x2
ffffffffc020328e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203290:	48d7f563          	bgeu	a5,a3,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203294:	fff806b7          	lui	a3,0xfff80
ffffffffc0203298:	97b6                	add	a5,a5,a3
ffffffffc020329a:	000b3603          	ld	a2,0(s6)
ffffffffc020329e:	00379693          	slli	a3,a5,0x3
ffffffffc02032a2:	97b6                	add	a5,a5,a3
ffffffffc02032a4:	078e                	slli	a5,a5,0x3
ffffffffc02032a6:	97b2                	add	a5,a5,a2
ffffffffc02032a8:	72fa1263          	bne	s4,a5,ffffffffc02039cc <pmm_init+0x9f4>
    assert((*ptep & PTE_U) == 0);
ffffffffc02032ac:	8b41                	andi	a4,a4,16
ffffffffc02032ae:	6e071f63          	bnez	a4,ffffffffc02039ac <pmm_init+0x9d4>

    page_remove(boot_pgdir, 0x0);
ffffffffc02032b2:	00093503          	ld	a0,0(s2)
ffffffffc02032b6:	4581                	li	a1,0
ffffffffc02032b8:	b87ff0ef          	jal	ra,ffffffffc0202e3e <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02032bc:	000a2703          	lw	a4,0(s4)
ffffffffc02032c0:	4785                	li	a5,1
ffffffffc02032c2:	6cf71563          	bne	a4,a5,ffffffffc020398c <pmm_init+0x9b4>
    assert(page_ref(p2) == 0);
ffffffffc02032c6:	000aa783          	lw	a5,0(s5)
ffffffffc02032ca:	78079d63          	bnez	a5,ffffffffc0203a64 <pmm_init+0xa8c>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc02032ce:	00093503          	ld	a0,0(s2)
ffffffffc02032d2:	6585                	lui	a1,0x1
ffffffffc02032d4:	b6bff0ef          	jal	ra,ffffffffc0202e3e <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02032d8:	000a2783          	lw	a5,0(s4)
ffffffffc02032dc:	76079463          	bnez	a5,ffffffffc0203a44 <pmm_init+0xa6c>
    assert(page_ref(p2) == 0);
ffffffffc02032e0:	000aa783          	lw	a5,0(s5)
ffffffffc02032e4:	74079063          	bnez	a5,ffffffffc0203a24 <pmm_init+0xa4c>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc02032e8:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc02032ec:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02032ee:	000a3783          	ld	a5,0(s4)
ffffffffc02032f2:	078a                	slli	a5,a5,0x2
ffffffffc02032f4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032f6:	42c7f263          	bgeu	a5,a2,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02032fa:	fff80737          	lui	a4,0xfff80
ffffffffc02032fe:	973e                	add	a4,a4,a5
ffffffffc0203300:	00371793          	slli	a5,a4,0x3
ffffffffc0203304:	000b3503          	ld	a0,0(s6)
ffffffffc0203308:	97ba                	add	a5,a5,a4
ffffffffc020330a:	078e                	slli	a5,a5,0x3
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc020330c:	00f50733          	add	a4,a0,a5
ffffffffc0203310:	4314                	lw	a3,0(a4)
ffffffffc0203312:	4705                	li	a4,1
ffffffffc0203314:	6ee69863          	bne	a3,a4,ffffffffc0203a04 <pmm_init+0xa2c>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203318:	4037d693          	srai	a3,a5,0x3
ffffffffc020331c:	00003c97          	auipc	s9,0x3
ffffffffc0203320:	164cbc83          	ld	s9,356(s9) # ffffffffc0206480 <error_string+0x38>
ffffffffc0203324:	039686b3          	mul	a3,a3,s9
ffffffffc0203328:	000805b7          	lui	a1,0x80
ffffffffc020332c:	96ae                	add	a3,a3,a1
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020332e:	00c69713          	slli	a4,a3,0xc
ffffffffc0203332:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203334:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203336:	6ac77b63          	bgeu	a4,a2,ffffffffc02039ec <pmm_init+0xa14>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc020333a:	0009b703          	ld	a4,0(s3)
ffffffffc020333e:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0203340:	629c                	ld	a5,0(a3)
ffffffffc0203342:	078a                	slli	a5,a5,0x2
ffffffffc0203344:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203346:	3cc7fa63          	bgeu	a5,a2,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020334a:	8f8d                	sub	a5,a5,a1
ffffffffc020334c:	00379713          	slli	a4,a5,0x3
ffffffffc0203350:	97ba                	add	a5,a5,a4
ffffffffc0203352:	078e                	slli	a5,a5,0x3
ffffffffc0203354:	953e                	add	a0,a0,a5
ffffffffc0203356:	100027f3          	csrr	a5,sstatus
ffffffffc020335a:	8b89                	andi	a5,a5,2
ffffffffc020335c:	2e079963          	bnez	a5,ffffffffc020364e <pmm_init+0x676>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203360:	000bb783          	ld	a5,0(s7)
ffffffffc0203364:	4585                	li	a1,1
ffffffffc0203366:	739c                	ld	a5,32(a5)
ffffffffc0203368:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020336a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc020336e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203370:	078a                	slli	a5,a5,0x2
ffffffffc0203372:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203374:	3ae7f363          	bgeu	a5,a4,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203378:	fff80737          	lui	a4,0xfff80
ffffffffc020337c:	97ba                	add	a5,a5,a4
ffffffffc020337e:	000b3503          	ld	a0,0(s6)
ffffffffc0203382:	00379713          	slli	a4,a5,0x3
ffffffffc0203386:	97ba                	add	a5,a5,a4
ffffffffc0203388:	078e                	slli	a5,a5,0x3
ffffffffc020338a:	953e                	add	a0,a0,a5
ffffffffc020338c:	100027f3          	csrr	a5,sstatus
ffffffffc0203390:	8b89                	andi	a5,a5,2
ffffffffc0203392:	2a079263          	bnez	a5,ffffffffc0203636 <pmm_init+0x65e>
ffffffffc0203396:	000bb783          	ld	a5,0(s7)
ffffffffc020339a:	4585                	li	a1,1
ffffffffc020339c:	739c                	ld	a5,32(a5)
ffffffffc020339e:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02033a0:	00093783          	ld	a5,0(s2)
ffffffffc02033a4:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc02033a8:	100027f3          	csrr	a5,sstatus
ffffffffc02033ac:	8b89                	andi	a5,a5,2
ffffffffc02033ae:	26079a63          	bnez	a5,ffffffffc0203622 <pmm_init+0x64a>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02033b2:	000bb783          	ld	a5,0(s7)
ffffffffc02033b6:	779c                	ld	a5,40(a5)
ffffffffc02033b8:	9782                	jalr	a5
ffffffffc02033ba:	8a2a                	mv	s4,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02033bc:	73441463          	bne	s0,s4,ffffffffc0203ae4 <pmm_init+0xb0c>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02033c0:	00003517          	auipc	a0,0x3
ffffffffc02033c4:	bf850513          	addi	a0,a0,-1032 # ffffffffc0205fb8 <default_pmm_manager+0x5f0>
ffffffffc02033c8:	cf3fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02033cc:	100027f3          	csrr	a5,sstatus
ffffffffc02033d0:	8b89                	andi	a5,a5,2
ffffffffc02033d2:	22079e63          	bnez	a5,ffffffffc020360e <pmm_init+0x636>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02033d6:	000bb783          	ld	a5,0(s7)
ffffffffc02033da:	779c                	ld	a5,40(a5)
ffffffffc02033dc:	9782                	jalr	a5
ffffffffc02033de:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02033e0:	6098                	ld	a4,0(s1)
ffffffffc02033e2:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02033e6:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02033e8:	00c71793          	slli	a5,a4,0xc
ffffffffc02033ec:	6a05                	lui	s4,0x1
ffffffffc02033ee:	02f47c63          	bgeu	s0,a5,ffffffffc0203426 <pmm_init+0x44e>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02033f2:	00c45793          	srli	a5,s0,0xc
ffffffffc02033f6:	00093503          	ld	a0,0(s2)
ffffffffc02033fa:	30e7f363          	bgeu	a5,a4,ffffffffc0203700 <pmm_init+0x728>
ffffffffc02033fe:	0009b583          	ld	a1,0(s3)
ffffffffc0203402:	4601                	li	a2,0
ffffffffc0203404:	95a2                	add	a1,a1,s0
ffffffffc0203406:	fe8ff0ef          	jal	ra,ffffffffc0202bee <get_pte>
ffffffffc020340a:	2c050b63          	beqz	a0,ffffffffc02036e0 <pmm_init+0x708>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020340e:	611c                	ld	a5,0(a0)
ffffffffc0203410:	078a                	slli	a5,a5,0x2
ffffffffc0203412:	0157f7b3          	and	a5,a5,s5
ffffffffc0203416:	2a879563          	bne	a5,s0,ffffffffc02036c0 <pmm_init+0x6e8>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020341a:	6098                	ld	a4,0(s1)
ffffffffc020341c:	9452                	add	s0,s0,s4
ffffffffc020341e:	00c71793          	slli	a5,a4,0xc
ffffffffc0203422:	fcf468e3          	bltu	s0,a5,ffffffffc02033f2 <pmm_init+0x41a>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc0203426:	00093783          	ld	a5,0(s2)
ffffffffc020342a:	639c                	ld	a5,0(a5)
ffffffffc020342c:	68079c63          	bnez	a5,ffffffffc0203ac4 <pmm_init+0xaec>

    struct Page *p;
    p = alloc_page();
ffffffffc0203430:	4505                	li	a0,1
ffffffffc0203432:	eb0ff0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0203436:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203438:	00093503          	ld	a0,0(s2)
ffffffffc020343c:	4699                	li	a3,6
ffffffffc020343e:	10000613          	li	a2,256
ffffffffc0203442:	85d6                	mv	a1,s5
ffffffffc0203444:	a95ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203448:	64051e63          	bnez	a0,ffffffffc0203aa4 <pmm_init+0xacc>
    assert(page_ref(p) == 1);
ffffffffc020344c:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc0203450:	4785                	li	a5,1
ffffffffc0203452:	62f71963          	bne	a4,a5,ffffffffc0203a84 <pmm_init+0xaac>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203456:	00093503          	ld	a0,0(s2)
ffffffffc020345a:	6405                	lui	s0,0x1
ffffffffc020345c:	4699                	li	a3,6
ffffffffc020345e:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0203462:	85d6                	mv	a1,s5
ffffffffc0203464:	a75ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203468:	48051263          	bnez	a0,ffffffffc02038ec <pmm_init+0x914>
    assert(page_ref(p) == 2);
ffffffffc020346c:	000aa703          	lw	a4,0(s5)
ffffffffc0203470:	4789                	li	a5,2
ffffffffc0203472:	74f71563          	bne	a4,a5,ffffffffc0203bbc <pmm_init+0xbe4>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0203476:	00003597          	auipc	a1,0x3
ffffffffc020347a:	c7a58593          	addi	a1,a1,-902 # ffffffffc02060f0 <default_pmm_manager+0x728>
ffffffffc020347e:	10000513          	li	a0,256
ffffffffc0203482:	35d000ef          	jal	ra,ffffffffc0203fde <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203486:	10040593          	addi	a1,s0,256
ffffffffc020348a:	10000513          	li	a0,256
ffffffffc020348e:	363000ef          	jal	ra,ffffffffc0203ff0 <strcmp>
ffffffffc0203492:	70051563          	bnez	a0,ffffffffc0203b9c <pmm_init+0xbc4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203496:	000b3683          	ld	a3,0(s6)
ffffffffc020349a:	00080d37          	lui	s10,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020349e:	547d                	li	s0,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034a0:	40da86b3          	sub	a3,s5,a3
ffffffffc02034a4:	868d                	srai	a3,a3,0x3
ffffffffc02034a6:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034aa:	609c                	ld	a5,0(s1)
ffffffffc02034ac:	8031                	srli	s0,s0,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034ae:	96ea                	add	a3,a3,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034b0:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034b4:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034b6:	52f77b63          	bgeu	a4,a5,ffffffffc02039ec <pmm_init+0xa14>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02034ba:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034be:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02034c2:	96be                	add	a3,a3,a5
ffffffffc02034c4:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb90>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034c8:	2e1000ef          	jal	ra,ffffffffc0203fa8 <strlen>
ffffffffc02034cc:	6a051863          	bnez	a0,ffffffffc0203b7c <pmm_init+0xba4>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc02034d0:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc02034d4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02034d6:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02034da:	078a                	slli	a5,a5,0x2
ffffffffc02034dc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02034de:	22e7fe63          	bgeu	a5,a4,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02034e2:	41a787b3          	sub	a5,a5,s10
ffffffffc02034e6:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034ea:	96be                	add	a3,a3,a5
ffffffffc02034ec:	03968cb3          	mul	s9,a3,s9
ffffffffc02034f0:	01ac86b3          	add	a3,s9,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034f4:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02034f6:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034f8:	4ee47a63          	bgeu	s0,a4,ffffffffc02039ec <pmm_init+0xa14>
ffffffffc02034fc:	0009b403          	ld	s0,0(s3)
ffffffffc0203500:	9436                	add	s0,s0,a3
ffffffffc0203502:	100027f3          	csrr	a5,sstatus
ffffffffc0203506:	8b89                	andi	a5,a5,2
ffffffffc0203508:	1a079163          	bnez	a5,ffffffffc02036aa <pmm_init+0x6d2>
    { pmm_manager->free_pages(base, n); }
ffffffffc020350c:	000bb783          	ld	a5,0(s7)
ffffffffc0203510:	4585                	li	a1,1
ffffffffc0203512:	8556                	mv	a0,s5
ffffffffc0203514:	739c                	ld	a5,32(a5)
ffffffffc0203516:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203518:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc020351a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020351c:	078a                	slli	a5,a5,0x2
ffffffffc020351e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203520:	1ee7fd63          	bgeu	a5,a4,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203524:	fff80737          	lui	a4,0xfff80
ffffffffc0203528:	97ba                	add	a5,a5,a4
ffffffffc020352a:	000b3503          	ld	a0,0(s6)
ffffffffc020352e:	00379713          	slli	a4,a5,0x3
ffffffffc0203532:	97ba                	add	a5,a5,a4
ffffffffc0203534:	078e                	slli	a5,a5,0x3
ffffffffc0203536:	953e                	add	a0,a0,a5
ffffffffc0203538:	100027f3          	csrr	a5,sstatus
ffffffffc020353c:	8b89                	andi	a5,a5,2
ffffffffc020353e:	14079a63          	bnez	a5,ffffffffc0203692 <pmm_init+0x6ba>
ffffffffc0203542:	000bb783          	ld	a5,0(s7)
ffffffffc0203546:	4585                	li	a1,1
ffffffffc0203548:	739c                	ld	a5,32(a5)
ffffffffc020354a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020354c:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0203550:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203552:	078a                	slli	a5,a5,0x2
ffffffffc0203554:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203556:	1ce7f263          	bgeu	a5,a4,ffffffffc020371a <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020355a:	fff80737          	lui	a4,0xfff80
ffffffffc020355e:	97ba                	add	a5,a5,a4
ffffffffc0203560:	000b3503          	ld	a0,0(s6)
ffffffffc0203564:	00379713          	slli	a4,a5,0x3
ffffffffc0203568:	97ba                	add	a5,a5,a4
ffffffffc020356a:	078e                	slli	a5,a5,0x3
ffffffffc020356c:	953e                	add	a0,a0,a5
ffffffffc020356e:	100027f3          	csrr	a5,sstatus
ffffffffc0203572:	8b89                	andi	a5,a5,2
ffffffffc0203574:	10079363          	bnez	a5,ffffffffc020367a <pmm_init+0x6a2>
ffffffffc0203578:	000bb783          	ld	a5,0(s7)
ffffffffc020357c:	4585                	li	a1,1
ffffffffc020357e:	739c                	ld	a5,32(a5)
ffffffffc0203580:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0203582:	00093783          	ld	a5,0(s2)
ffffffffc0203586:	0007b023          	sd	zero,0(a5)
ffffffffc020358a:	100027f3          	csrr	a5,sstatus
ffffffffc020358e:	8b89                	andi	a5,a5,2
ffffffffc0203590:	0c079b63          	bnez	a5,ffffffffc0203666 <pmm_init+0x68e>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203594:	000bb783          	ld	a5,0(s7)
ffffffffc0203598:	779c                	ld	a5,40(a5)
ffffffffc020359a:	9782                	jalr	a5
ffffffffc020359c:	842a                	mv	s0,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc020359e:	3a8c1763          	bne	s8,s0,ffffffffc020394c <pmm_init+0x974>
}
ffffffffc02035a2:	7406                	ld	s0,96(sp)
ffffffffc02035a4:	70a6                	ld	ra,104(sp)
ffffffffc02035a6:	64e6                	ld	s1,88(sp)
ffffffffc02035a8:	6946                	ld	s2,80(sp)
ffffffffc02035aa:	69a6                	ld	s3,72(sp)
ffffffffc02035ac:	6a06                	ld	s4,64(sp)
ffffffffc02035ae:	7ae2                	ld	s5,56(sp)
ffffffffc02035b0:	7b42                	ld	s6,48(sp)
ffffffffc02035b2:	7ba2                	ld	s7,40(sp)
ffffffffc02035b4:	7c02                	ld	s8,32(sp)
ffffffffc02035b6:	6ce2                	ld	s9,24(sp)
ffffffffc02035b8:	6d42                	ld	s10,16(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02035ba:	00003517          	auipc	a0,0x3
ffffffffc02035be:	bae50513          	addi	a0,a0,-1106 # ffffffffc0206168 <default_pmm_manager+0x7a0>
}
ffffffffc02035c2:	6165                	addi	sp,sp,112
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02035c4:	af7fc06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02035c8:	6705                	lui	a4,0x1
ffffffffc02035ca:	177d                	addi	a4,a4,-1
ffffffffc02035cc:	96ba                	add	a3,a3,a4
ffffffffc02035ce:	777d                	lui	a4,0xfffff
ffffffffc02035d0:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc02035d2:	00c75693          	srli	a3,a4,0xc
ffffffffc02035d6:	14f6f263          	bgeu	a3,a5,ffffffffc020371a <pmm_init+0x742>
    pmm_manager->init_memmap(base, n);
ffffffffc02035da:	000bb803          	ld	a6,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc02035de:	95b6                	add	a1,a1,a3
ffffffffc02035e0:	00359793          	slli	a5,a1,0x3
ffffffffc02035e4:	97ae                	add	a5,a5,a1
ffffffffc02035e6:	01083683          	ld	a3,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02035ea:	40e60733          	sub	a4,a2,a4
ffffffffc02035ee:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02035f0:	00c75593          	srli	a1,a4,0xc
ffffffffc02035f4:	953e                	add	a0,a0,a5
ffffffffc02035f6:	9682                	jalr	a3
}
ffffffffc02035f8:	bcc5                	j	ffffffffc02030e8 <pmm_init+0x110>
        intr_disable();
ffffffffc02035fa:	ef5fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02035fe:	000bb783          	ld	a5,0(s7)
ffffffffc0203602:	779c                	ld	a5,40(a5)
ffffffffc0203604:	9782                	jalr	a5
ffffffffc0203606:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203608:	ee1fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020360c:	b63d                	j	ffffffffc020313a <pmm_init+0x162>
        intr_disable();
ffffffffc020360e:	ee1fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203612:	000bb783          	ld	a5,0(s7)
ffffffffc0203616:	779c                	ld	a5,40(a5)
ffffffffc0203618:	9782                	jalr	a5
ffffffffc020361a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020361c:	ecdfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203620:	b3c1                	j	ffffffffc02033e0 <pmm_init+0x408>
        intr_disable();
ffffffffc0203622:	ecdfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203626:	000bb783          	ld	a5,0(s7)
ffffffffc020362a:	779c                	ld	a5,40(a5)
ffffffffc020362c:	9782                	jalr	a5
ffffffffc020362e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203630:	eb9fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203634:	b361                	j	ffffffffc02033bc <pmm_init+0x3e4>
ffffffffc0203636:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203638:	eb7fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc020363c:	000bb783          	ld	a5,0(s7)
ffffffffc0203640:	6522                	ld	a0,8(sp)
ffffffffc0203642:	4585                	li	a1,1
ffffffffc0203644:	739c                	ld	a5,32(a5)
ffffffffc0203646:	9782                	jalr	a5
        intr_enable();
ffffffffc0203648:	ea1fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020364c:	bb91                	j	ffffffffc02033a0 <pmm_init+0x3c8>
ffffffffc020364e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203650:	e9ffc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203654:	000bb783          	ld	a5,0(s7)
ffffffffc0203658:	6522                	ld	a0,8(sp)
ffffffffc020365a:	4585                	li	a1,1
ffffffffc020365c:	739c                	ld	a5,32(a5)
ffffffffc020365e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203660:	e89fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203664:	b319                	j	ffffffffc020336a <pmm_init+0x392>
        intr_disable();
ffffffffc0203666:	e89fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc020366a:	000bb783          	ld	a5,0(s7)
ffffffffc020366e:	779c                	ld	a5,40(a5)
ffffffffc0203670:	9782                	jalr	a5
ffffffffc0203672:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203674:	e75fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203678:	b71d                	j	ffffffffc020359e <pmm_init+0x5c6>
ffffffffc020367a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020367c:	e73fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203680:	000bb783          	ld	a5,0(s7)
ffffffffc0203684:	6522                	ld	a0,8(sp)
ffffffffc0203686:	4585                	li	a1,1
ffffffffc0203688:	739c                	ld	a5,32(a5)
ffffffffc020368a:	9782                	jalr	a5
        intr_enable();
ffffffffc020368c:	e5dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203690:	bdcd                	j	ffffffffc0203582 <pmm_init+0x5aa>
ffffffffc0203692:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203694:	e5bfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203698:	000bb783          	ld	a5,0(s7)
ffffffffc020369c:	6522                	ld	a0,8(sp)
ffffffffc020369e:	4585                	li	a1,1
ffffffffc02036a0:	739c                	ld	a5,32(a5)
ffffffffc02036a2:	9782                	jalr	a5
        intr_enable();
ffffffffc02036a4:	e45fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02036a8:	b555                	j	ffffffffc020354c <pmm_init+0x574>
        intr_disable();
ffffffffc02036aa:	e45fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02036ae:	000bb783          	ld	a5,0(s7)
ffffffffc02036b2:	4585                	li	a1,1
ffffffffc02036b4:	8556                	mv	a0,s5
ffffffffc02036b6:	739c                	ld	a5,32(a5)
ffffffffc02036b8:	9782                	jalr	a5
        intr_enable();
ffffffffc02036ba:	e2ffc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02036be:	bda9                	j	ffffffffc0203518 <pmm_init+0x540>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02036c0:	00003697          	auipc	a3,0x3
ffffffffc02036c4:	95868693          	addi	a3,a3,-1704 # ffffffffc0206018 <default_pmm_manager+0x650>
ffffffffc02036c8:	00002617          	auipc	a2,0x2
ffffffffc02036cc:	81060613          	addi	a2,a2,-2032 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02036d0:	1ce00593          	li	a1,462
ffffffffc02036d4:	00002517          	auipc	a0,0x2
ffffffffc02036d8:	53c50513          	addi	a0,a0,1340 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02036dc:	a27fc0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02036e0:	00003697          	auipc	a3,0x3
ffffffffc02036e4:	8f868693          	addi	a3,a3,-1800 # ffffffffc0205fd8 <default_pmm_manager+0x610>
ffffffffc02036e8:	00001617          	auipc	a2,0x1
ffffffffc02036ec:	7f060613          	addi	a2,a2,2032 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02036f0:	1cd00593          	li	a1,461
ffffffffc02036f4:	00002517          	auipc	a0,0x2
ffffffffc02036f8:	51c50513          	addi	a0,a0,1308 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02036fc:	a07fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203700:	86a2                	mv	a3,s0
ffffffffc0203702:	00002617          	auipc	a2,0x2
ffffffffc0203706:	4e660613          	addi	a2,a2,1254 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc020370a:	1cd00593          	li	a1,461
ffffffffc020370e:	00002517          	auipc	a0,0x2
ffffffffc0203712:	50250513          	addi	a0,a0,1282 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203716:	9edfc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc020371a:	b90ff0ef          	jal	ra,ffffffffc0202aaa <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020371e:	00002617          	auipc	a2,0x2
ffffffffc0203722:	58a60613          	addi	a2,a2,1418 # ffffffffc0205ca8 <default_pmm_manager+0x2e0>
ffffffffc0203726:	07700593          	li	a1,119
ffffffffc020372a:	00002517          	auipc	a0,0x2
ffffffffc020372e:	4e650513          	addi	a0,a0,1254 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203732:	9d1fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203736:	00002617          	auipc	a2,0x2
ffffffffc020373a:	57260613          	addi	a2,a2,1394 # ffffffffc0205ca8 <default_pmm_manager+0x2e0>
ffffffffc020373e:	0bd00593          	li	a1,189
ffffffffc0203742:	00002517          	auipc	a0,0x2
ffffffffc0203746:	4ce50513          	addi	a0,a0,1230 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020374a:	9b9fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc020374e:	00002697          	auipc	a3,0x2
ffffffffc0203752:	5c268693          	addi	a3,a3,1474 # ffffffffc0205d10 <default_pmm_manager+0x348>
ffffffffc0203756:	00001617          	auipc	a2,0x1
ffffffffc020375a:	78260613          	addi	a2,a2,1922 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020375e:	19300593          	li	a1,403
ffffffffc0203762:	00002517          	auipc	a0,0x2
ffffffffc0203766:	4ae50513          	addi	a0,a0,1198 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020376a:	999fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020376e:	00002697          	auipc	a3,0x2
ffffffffc0203772:	58268693          	addi	a3,a3,1410 # ffffffffc0205cf0 <default_pmm_manager+0x328>
ffffffffc0203776:	00001617          	auipc	a2,0x1
ffffffffc020377a:	76260613          	addi	a2,a2,1890 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020377e:	19200593          	li	a1,402
ffffffffc0203782:	00002517          	auipc	a0,0x2
ffffffffc0203786:	48e50513          	addi	a0,a0,1166 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020378a:	979fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc020378e:	b38ff0ef          	jal	ra,ffffffffc0202ac6 <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0203792:	00002697          	auipc	a3,0x2
ffffffffc0203796:	60e68693          	addi	a3,a3,1550 # ffffffffc0205da0 <default_pmm_manager+0x3d8>
ffffffffc020379a:	00001617          	auipc	a2,0x1
ffffffffc020379e:	73e60613          	addi	a2,a2,1854 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02037a2:	19a00593          	li	a1,410
ffffffffc02037a6:	00002517          	auipc	a0,0x2
ffffffffc02037aa:	46a50513          	addi	a0,a0,1130 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02037ae:	955fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02037b2:	00002697          	auipc	a3,0x2
ffffffffc02037b6:	5be68693          	addi	a3,a3,1470 # ffffffffc0205d70 <default_pmm_manager+0x3a8>
ffffffffc02037ba:	00001617          	auipc	a2,0x1
ffffffffc02037be:	71e60613          	addi	a2,a2,1822 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02037c2:	19800593          	li	a1,408
ffffffffc02037c6:	00002517          	auipc	a0,0x2
ffffffffc02037ca:	44a50513          	addi	a0,a0,1098 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02037ce:	935fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02037d2:	00002697          	auipc	a3,0x2
ffffffffc02037d6:	57668693          	addi	a3,a3,1398 # ffffffffc0205d48 <default_pmm_manager+0x380>
ffffffffc02037da:	00001617          	auipc	a2,0x1
ffffffffc02037de:	6fe60613          	addi	a2,a2,1790 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02037e2:	19400593          	li	a1,404
ffffffffc02037e6:	00002517          	auipc	a0,0x2
ffffffffc02037ea:	42a50513          	addi	a0,a0,1066 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02037ee:	915fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02037f2:	00002697          	auipc	a3,0x2
ffffffffc02037f6:	63668693          	addi	a3,a3,1590 # ffffffffc0205e28 <default_pmm_manager+0x460>
ffffffffc02037fa:	00001617          	auipc	a2,0x1
ffffffffc02037fe:	6de60613          	addi	a2,a2,1758 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203802:	1a300593          	li	a1,419
ffffffffc0203806:	00002517          	auipc	a0,0x2
ffffffffc020380a:	40a50513          	addi	a0,a0,1034 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020380e:	8f5fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203812:	00002697          	auipc	a3,0x2
ffffffffc0203816:	6b668693          	addi	a3,a3,1718 # ffffffffc0205ec8 <default_pmm_manager+0x500>
ffffffffc020381a:	00001617          	auipc	a2,0x1
ffffffffc020381e:	6be60613          	addi	a2,a2,1726 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203822:	1a800593          	li	a1,424
ffffffffc0203826:	00002517          	auipc	a0,0x2
ffffffffc020382a:	3ea50513          	addi	a0,a0,1002 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020382e:	8d5fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203832:	00002697          	auipc	a3,0x2
ffffffffc0203836:	5ce68693          	addi	a3,a3,1486 # ffffffffc0205e00 <default_pmm_manager+0x438>
ffffffffc020383a:	00001617          	auipc	a2,0x1
ffffffffc020383e:	69e60613          	addi	a2,a2,1694 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203842:	1a000593          	li	a1,416
ffffffffc0203846:	00002517          	auipc	a0,0x2
ffffffffc020384a:	3ca50513          	addi	a0,a0,970 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc020384e:	8b5fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203852:	86d6                	mv	a3,s5
ffffffffc0203854:	00002617          	auipc	a2,0x2
ffffffffc0203858:	39460613          	addi	a2,a2,916 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc020385c:	19f00593          	li	a1,415
ffffffffc0203860:	00002517          	auipc	a0,0x2
ffffffffc0203864:	3b050513          	addi	a0,a0,944 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203868:	89bfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020386c:	00002697          	auipc	a3,0x2
ffffffffc0203870:	5f468693          	addi	a3,a3,1524 # ffffffffc0205e60 <default_pmm_manager+0x498>
ffffffffc0203874:	00001617          	auipc	a2,0x1
ffffffffc0203878:	66460613          	addi	a2,a2,1636 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020387c:	1ad00593          	li	a1,429
ffffffffc0203880:	00002517          	auipc	a0,0x2
ffffffffc0203884:	39050513          	addi	a0,a0,912 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203888:	87bfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020388c:	00002697          	auipc	a3,0x2
ffffffffc0203890:	69c68693          	addi	a3,a3,1692 # ffffffffc0205f28 <default_pmm_manager+0x560>
ffffffffc0203894:	00001617          	auipc	a2,0x1
ffffffffc0203898:	64460613          	addi	a2,a2,1604 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020389c:	1ac00593          	li	a1,428
ffffffffc02038a0:	00002517          	auipc	a0,0x2
ffffffffc02038a4:	37050513          	addi	a0,a0,880 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02038a8:	85bfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02038ac:	00002697          	auipc	a3,0x2
ffffffffc02038b0:	66468693          	addi	a3,a3,1636 # ffffffffc0205f10 <default_pmm_manager+0x548>
ffffffffc02038b4:	00001617          	auipc	a2,0x1
ffffffffc02038b8:	62460613          	addi	a2,a2,1572 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02038bc:	1ab00593          	li	a1,427
ffffffffc02038c0:	00002517          	auipc	a0,0x2
ffffffffc02038c4:	35050513          	addi	a0,a0,848 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02038c8:	83bfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02038cc:	00002697          	auipc	a3,0x2
ffffffffc02038d0:	61468693          	addi	a3,a3,1556 # ffffffffc0205ee0 <default_pmm_manager+0x518>
ffffffffc02038d4:	00001617          	auipc	a2,0x1
ffffffffc02038d8:	60460613          	addi	a2,a2,1540 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02038dc:	1aa00593          	li	a1,426
ffffffffc02038e0:	00002517          	auipc	a0,0x2
ffffffffc02038e4:	33050513          	addi	a0,a0,816 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02038e8:	81bfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02038ec:	00002697          	auipc	a3,0x2
ffffffffc02038f0:	7ac68693          	addi	a3,a3,1964 # ffffffffc0206098 <default_pmm_manager+0x6d0>
ffffffffc02038f4:	00001617          	auipc	a2,0x1
ffffffffc02038f8:	5e460613          	addi	a2,a2,1508 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02038fc:	1d800593          	li	a1,472
ffffffffc0203900:	00002517          	auipc	a0,0x2
ffffffffc0203904:	31050513          	addi	a0,a0,784 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203908:	ffafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020390c:	00002697          	auipc	a3,0x2
ffffffffc0203910:	5a468693          	addi	a3,a3,1444 # ffffffffc0205eb0 <default_pmm_manager+0x4e8>
ffffffffc0203914:	00001617          	auipc	a2,0x1
ffffffffc0203918:	5c460613          	addi	a2,a2,1476 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020391c:	1a700593          	li	a1,423
ffffffffc0203920:	00002517          	auipc	a0,0x2
ffffffffc0203924:	2f050513          	addi	a0,a0,752 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203928:	fdafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020392c:	00002697          	auipc	a3,0x2
ffffffffc0203930:	57468693          	addi	a3,a3,1396 # ffffffffc0205ea0 <default_pmm_manager+0x4d8>
ffffffffc0203934:	00001617          	auipc	a2,0x1
ffffffffc0203938:	5a460613          	addi	a2,a2,1444 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020393c:	1a600593          	li	a1,422
ffffffffc0203940:	00002517          	auipc	a0,0x2
ffffffffc0203944:	2d050513          	addi	a0,a0,720 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203948:	fbafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc020394c:	00002697          	auipc	a3,0x2
ffffffffc0203950:	64c68693          	addi	a3,a3,1612 # ffffffffc0205f98 <default_pmm_manager+0x5d0>
ffffffffc0203954:	00001617          	auipc	a2,0x1
ffffffffc0203958:	58460613          	addi	a2,a2,1412 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020395c:	1e800593          	li	a1,488
ffffffffc0203960:	00002517          	auipc	a0,0x2
ffffffffc0203964:	2b050513          	addi	a0,a0,688 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203968:	f9afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_U);
ffffffffc020396c:	00002697          	auipc	a3,0x2
ffffffffc0203970:	52468693          	addi	a3,a3,1316 # ffffffffc0205e90 <default_pmm_manager+0x4c8>
ffffffffc0203974:	00001617          	auipc	a2,0x1
ffffffffc0203978:	56460613          	addi	a2,a2,1380 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020397c:	1a500593          	li	a1,421
ffffffffc0203980:	00002517          	auipc	a0,0x2
ffffffffc0203984:	29050513          	addi	a0,a0,656 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203988:	f7afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020398c:	00002697          	auipc	a3,0x2
ffffffffc0203990:	45c68693          	addi	a3,a3,1116 # ffffffffc0205de8 <default_pmm_manager+0x420>
ffffffffc0203994:	00001617          	auipc	a2,0x1
ffffffffc0203998:	54460613          	addi	a2,a2,1348 # ffffffffc0204ed8 <commands+0x770>
ffffffffc020399c:	1b200593          	li	a1,434
ffffffffc02039a0:	00002517          	auipc	a0,0x2
ffffffffc02039a4:	27050513          	addi	a0,a0,624 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02039a8:	f5afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02039ac:	00002697          	auipc	a3,0x2
ffffffffc02039b0:	59468693          	addi	a3,a3,1428 # ffffffffc0205f40 <default_pmm_manager+0x578>
ffffffffc02039b4:	00001617          	auipc	a2,0x1
ffffffffc02039b8:	52460613          	addi	a2,a2,1316 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02039bc:	1af00593          	li	a1,431
ffffffffc02039c0:	00002517          	auipc	a0,0x2
ffffffffc02039c4:	25050513          	addi	a0,a0,592 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02039c8:	f3afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02039cc:	00002697          	auipc	a3,0x2
ffffffffc02039d0:	40468693          	addi	a3,a3,1028 # ffffffffc0205dd0 <default_pmm_manager+0x408>
ffffffffc02039d4:	00001617          	auipc	a2,0x1
ffffffffc02039d8:	50460613          	addi	a2,a2,1284 # ffffffffc0204ed8 <commands+0x770>
ffffffffc02039dc:	1ae00593          	li	a1,430
ffffffffc02039e0:	00002517          	auipc	a0,0x2
ffffffffc02039e4:	23050513          	addi	a0,a0,560 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc02039e8:	f1afc0ef          	jal	ra,ffffffffc0200102 <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02039ec:	00002617          	auipc	a2,0x2
ffffffffc02039f0:	1fc60613          	addi	a2,a2,508 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc02039f4:	06a00593          	li	a1,106
ffffffffc02039f8:	00001517          	auipc	a0,0x1
ffffffffc02039fc:	75050513          	addi	a0,a0,1872 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0203a00:	f02fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0203a04:	00002697          	auipc	a3,0x2
ffffffffc0203a08:	56c68693          	addi	a3,a3,1388 # ffffffffc0205f70 <default_pmm_manager+0x5a8>
ffffffffc0203a0c:	00001617          	auipc	a2,0x1
ffffffffc0203a10:	4cc60613          	addi	a2,a2,1228 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203a14:	1b900593          	li	a1,441
ffffffffc0203a18:	00002517          	auipc	a0,0x2
ffffffffc0203a1c:	1f850513          	addi	a0,a0,504 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203a20:	ee2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203a24:	00002697          	auipc	a3,0x2
ffffffffc0203a28:	50468693          	addi	a3,a3,1284 # ffffffffc0205f28 <default_pmm_manager+0x560>
ffffffffc0203a2c:	00001617          	auipc	a2,0x1
ffffffffc0203a30:	4ac60613          	addi	a2,a2,1196 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203a34:	1b700593          	li	a1,439
ffffffffc0203a38:	00002517          	auipc	a0,0x2
ffffffffc0203a3c:	1d850513          	addi	a0,a0,472 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203a40:	ec2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203a44:	00002697          	auipc	a3,0x2
ffffffffc0203a48:	51468693          	addi	a3,a3,1300 # ffffffffc0205f58 <default_pmm_manager+0x590>
ffffffffc0203a4c:	00001617          	auipc	a2,0x1
ffffffffc0203a50:	48c60613          	addi	a2,a2,1164 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203a54:	1b600593          	li	a1,438
ffffffffc0203a58:	00002517          	auipc	a0,0x2
ffffffffc0203a5c:	1b850513          	addi	a0,a0,440 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203a60:	ea2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203a64:	00002697          	auipc	a3,0x2
ffffffffc0203a68:	4c468693          	addi	a3,a3,1220 # ffffffffc0205f28 <default_pmm_manager+0x560>
ffffffffc0203a6c:	00001617          	auipc	a2,0x1
ffffffffc0203a70:	46c60613          	addi	a2,a2,1132 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203a74:	1b300593          	li	a1,435
ffffffffc0203a78:	00002517          	auipc	a0,0x2
ffffffffc0203a7c:	19850513          	addi	a0,a0,408 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203a80:	e82fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203a84:	00002697          	auipc	a3,0x2
ffffffffc0203a88:	5fc68693          	addi	a3,a3,1532 # ffffffffc0206080 <default_pmm_manager+0x6b8>
ffffffffc0203a8c:	00001617          	auipc	a2,0x1
ffffffffc0203a90:	44c60613          	addi	a2,a2,1100 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203a94:	1d700593          	li	a1,471
ffffffffc0203a98:	00002517          	auipc	a0,0x2
ffffffffc0203a9c:	17850513          	addi	a0,a0,376 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203aa0:	e62fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203aa4:	00002697          	auipc	a3,0x2
ffffffffc0203aa8:	5a468693          	addi	a3,a3,1444 # ffffffffc0206048 <default_pmm_manager+0x680>
ffffffffc0203aac:	00001617          	auipc	a2,0x1
ffffffffc0203ab0:	42c60613          	addi	a2,a2,1068 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203ab4:	1d600593          	li	a1,470
ffffffffc0203ab8:	00002517          	auipc	a0,0x2
ffffffffc0203abc:	15850513          	addi	a0,a0,344 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203ac0:	e42fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0203ac4:	00002697          	auipc	a3,0x2
ffffffffc0203ac8:	56c68693          	addi	a3,a3,1388 # ffffffffc0206030 <default_pmm_manager+0x668>
ffffffffc0203acc:	00001617          	auipc	a2,0x1
ffffffffc0203ad0:	40c60613          	addi	a2,a2,1036 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203ad4:	1d200593          	li	a1,466
ffffffffc0203ad8:	00002517          	auipc	a0,0x2
ffffffffc0203adc:	13850513          	addi	a0,a0,312 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203ae0:	e22fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203ae4:	00002697          	auipc	a3,0x2
ffffffffc0203ae8:	4b468693          	addi	a3,a3,1204 # ffffffffc0205f98 <default_pmm_manager+0x5d0>
ffffffffc0203aec:	00001617          	auipc	a2,0x1
ffffffffc0203af0:	3ec60613          	addi	a2,a2,1004 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203af4:	1c000593          	li	a1,448
ffffffffc0203af8:	00002517          	auipc	a0,0x2
ffffffffc0203afc:	11850513          	addi	a0,a0,280 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b00:	e02fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203b04:	00002697          	auipc	a3,0x2
ffffffffc0203b08:	2cc68693          	addi	a3,a3,716 # ffffffffc0205dd0 <default_pmm_manager+0x408>
ffffffffc0203b0c:	00001617          	auipc	a2,0x1
ffffffffc0203b10:	3cc60613          	addi	a2,a2,972 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203b14:	19b00593          	li	a1,411
ffffffffc0203b18:	00002517          	auipc	a0,0x2
ffffffffc0203b1c:	0f850513          	addi	a0,a0,248 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b20:	de2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203b24:	00002617          	auipc	a2,0x2
ffffffffc0203b28:	0c460613          	addi	a2,a2,196 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0203b2c:	19e00593          	li	a1,414
ffffffffc0203b30:	00002517          	auipc	a0,0x2
ffffffffc0203b34:	0e050513          	addi	a0,a0,224 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b38:	dcafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203b3c:	00002697          	auipc	a3,0x2
ffffffffc0203b40:	2ac68693          	addi	a3,a3,684 # ffffffffc0205de8 <default_pmm_manager+0x420>
ffffffffc0203b44:	00001617          	auipc	a2,0x1
ffffffffc0203b48:	39460613          	addi	a2,a2,916 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203b4c:	19c00593          	li	a1,412
ffffffffc0203b50:	00002517          	auipc	a0,0x2
ffffffffc0203b54:	0c050513          	addi	a0,a0,192 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b58:	daafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203b5c:	00002697          	auipc	a3,0x2
ffffffffc0203b60:	30468693          	addi	a3,a3,772 # ffffffffc0205e60 <default_pmm_manager+0x498>
ffffffffc0203b64:	00001617          	auipc	a2,0x1
ffffffffc0203b68:	37460613          	addi	a2,a2,884 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203b6c:	1a400593          	li	a1,420
ffffffffc0203b70:	00002517          	auipc	a0,0x2
ffffffffc0203b74:	0a050513          	addi	a0,a0,160 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b78:	d8afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203b7c:	00002697          	auipc	a3,0x2
ffffffffc0203b80:	5c468693          	addi	a3,a3,1476 # ffffffffc0206140 <default_pmm_manager+0x778>
ffffffffc0203b84:	00001617          	auipc	a2,0x1
ffffffffc0203b88:	35460613          	addi	a2,a2,852 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203b8c:	1e000593          	li	a1,480
ffffffffc0203b90:	00002517          	auipc	a0,0x2
ffffffffc0203b94:	08050513          	addi	a0,a0,128 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203b98:	d6afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203b9c:	00002697          	auipc	a3,0x2
ffffffffc0203ba0:	56c68693          	addi	a3,a3,1388 # ffffffffc0206108 <default_pmm_manager+0x740>
ffffffffc0203ba4:	00001617          	auipc	a2,0x1
ffffffffc0203ba8:	33460613          	addi	a2,a2,820 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203bac:	1dd00593          	li	a1,477
ffffffffc0203bb0:	00002517          	auipc	a0,0x2
ffffffffc0203bb4:	06050513          	addi	a0,a0,96 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203bb8:	d4afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203bbc:	00002697          	auipc	a3,0x2
ffffffffc0203bc0:	51c68693          	addi	a3,a3,1308 # ffffffffc02060d8 <default_pmm_manager+0x710>
ffffffffc0203bc4:	00001617          	auipc	a2,0x1
ffffffffc0203bc8:	31460613          	addi	a2,a2,788 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203bcc:	1d900593          	li	a1,473
ffffffffc0203bd0:	00002517          	auipc	a0,0x2
ffffffffc0203bd4:	04050513          	addi	a0,a0,64 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203bd8:	d2afc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203bdc <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0203bdc:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc0203be0:	8082                	ret

ffffffffc0203be2 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203be2:	7179                	addi	sp,sp,-48
ffffffffc0203be4:	e84a                	sd	s2,16(sp)
ffffffffc0203be6:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0203be8:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203bea:	f022                	sd	s0,32(sp)
ffffffffc0203bec:	ec26                	sd	s1,24(sp)
ffffffffc0203bee:	e44e                	sd	s3,8(sp)
ffffffffc0203bf0:	f406                	sd	ra,40(sp)
ffffffffc0203bf2:	84ae                	mv	s1,a1
ffffffffc0203bf4:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0203bf6:	eedfe0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
ffffffffc0203bfa:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0203bfc:	cd09                	beqz	a0,ffffffffc0203c16 <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0203bfe:	85aa                	mv	a1,a0
ffffffffc0203c00:	86ce                	mv	a3,s3
ffffffffc0203c02:	8626                	mv	a2,s1
ffffffffc0203c04:	854a                	mv	a0,s2
ffffffffc0203c06:	ad2ff0ef          	jal	ra,ffffffffc0202ed8 <page_insert>
ffffffffc0203c0a:	ed21                	bnez	a0,ffffffffc0203c62 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0203c0c:	0000e797          	auipc	a5,0xe
ffffffffc0203c10:	92c7a783          	lw	a5,-1748(a5) # ffffffffc0211538 <swap_init_ok>
ffffffffc0203c14:	eb89                	bnez	a5,ffffffffc0203c26 <pgdir_alloc_page+0x44>
}
ffffffffc0203c16:	70a2                	ld	ra,40(sp)
ffffffffc0203c18:	8522                	mv	a0,s0
ffffffffc0203c1a:	7402                	ld	s0,32(sp)
ffffffffc0203c1c:	64e2                	ld	s1,24(sp)
ffffffffc0203c1e:	6942                	ld	s2,16(sp)
ffffffffc0203c20:	69a2                	ld	s3,8(sp)
ffffffffc0203c22:	6145                	addi	sp,sp,48
ffffffffc0203c24:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0203c26:	4681                	li	a3,0
ffffffffc0203c28:	8622                	mv	a2,s0
ffffffffc0203c2a:	85a6                	mv	a1,s1
ffffffffc0203c2c:	0000e517          	auipc	a0,0xe
ffffffffc0203c30:	8ec53503          	ld	a0,-1812(a0) # ffffffffc0211518 <check_mm_struct>
ffffffffc0203c34:	dfdfd0ef          	jal	ra,ffffffffc0201a30 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0203c38:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0203c3a:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0203c3c:	4785                	li	a5,1
ffffffffc0203c3e:	fcf70ce3          	beq	a4,a5,ffffffffc0203c16 <pgdir_alloc_page+0x34>
ffffffffc0203c42:	00002697          	auipc	a3,0x2
ffffffffc0203c46:	54668693          	addi	a3,a3,1350 # ffffffffc0206188 <default_pmm_manager+0x7c0>
ffffffffc0203c4a:	00001617          	auipc	a2,0x1
ffffffffc0203c4e:	28e60613          	addi	a2,a2,654 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203c52:	17a00593          	li	a1,378
ffffffffc0203c56:	00002517          	auipc	a0,0x2
ffffffffc0203c5a:	fba50513          	addi	a0,a0,-70 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203c5e:	ca4fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203c62:	100027f3          	csrr	a5,sstatus
ffffffffc0203c66:	8b89                	andi	a5,a5,2
ffffffffc0203c68:	eb99                	bnez	a5,ffffffffc0203c7e <pgdir_alloc_page+0x9c>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203c6a:	0000e797          	auipc	a5,0xe
ffffffffc0203c6e:	8f67b783          	ld	a5,-1802(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203c72:	739c                	ld	a5,32(a5)
ffffffffc0203c74:	8522                	mv	a0,s0
ffffffffc0203c76:	4585                	li	a1,1
ffffffffc0203c78:	9782                	jalr	a5
            return NULL;
ffffffffc0203c7a:	4401                	li	s0,0
ffffffffc0203c7c:	bf69                	j	ffffffffc0203c16 <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0203c7e:	871fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203c82:	0000e797          	auipc	a5,0xe
ffffffffc0203c86:	8de7b783          	ld	a5,-1826(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203c8a:	739c                	ld	a5,32(a5)
ffffffffc0203c8c:	8522                	mv	a0,s0
ffffffffc0203c8e:	4585                	li	a1,1
ffffffffc0203c90:	9782                	jalr	a5
            return NULL;
ffffffffc0203c92:	4401                	li	s0,0
        intr_enable();
ffffffffc0203c94:	855fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203c98:	bfbd                	j	ffffffffc0203c16 <pgdir_alloc_page+0x34>

ffffffffc0203c9a <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc0203c9a:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c9c:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc0203c9e:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203ca0:	fff50713          	addi	a4,a0,-1
ffffffffc0203ca4:	17f9                	addi	a5,a5,-2
ffffffffc0203ca6:	04e7ea63          	bltu	a5,a4,ffffffffc0203cfa <kmalloc+0x60>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203caa:	6785                	lui	a5,0x1
ffffffffc0203cac:	17fd                	addi	a5,a5,-1
ffffffffc0203cae:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc0203cb0:	8131                	srli	a0,a0,0xc
ffffffffc0203cb2:	e31fe0ef          	jal	ra,ffffffffc0202ae2 <alloc_pages>
    assert(base != NULL);
ffffffffc0203cb6:	cd3d                	beqz	a0,ffffffffc0203d34 <kmalloc+0x9a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203cb8:	0000e797          	auipc	a5,0xe
ffffffffc0203cbc:	8a07b783          	ld	a5,-1888(a5) # ffffffffc0211558 <pages>
ffffffffc0203cc0:	8d1d                	sub	a0,a0,a5
ffffffffc0203cc2:	00002697          	auipc	a3,0x2
ffffffffc0203cc6:	7be6b683          	ld	a3,1982(a3) # ffffffffc0206480 <error_string+0x38>
ffffffffc0203cca:	850d                	srai	a0,a0,0x3
ffffffffc0203ccc:	02d50533          	mul	a0,a0,a3
ffffffffc0203cd0:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203cd4:	0000e717          	auipc	a4,0xe
ffffffffc0203cd8:	87c73703          	ld	a4,-1924(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203cdc:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203cde:	00c51793          	slli	a5,a0,0xc
ffffffffc0203ce2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ce4:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203ce6:	02e7fa63          	bgeu	a5,a4,ffffffffc0203d1a <kmalloc+0x80>
    ptr = page2kva(base);
    return ptr;
}
ffffffffc0203cea:	60a2                	ld	ra,8(sp)
ffffffffc0203cec:	0000e797          	auipc	a5,0xe
ffffffffc0203cf0:	87c7b783          	ld	a5,-1924(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203cf4:	953e                	add	a0,a0,a5
ffffffffc0203cf6:	0141                	addi	sp,sp,16
ffffffffc0203cf8:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203cfa:	00002697          	auipc	a3,0x2
ffffffffc0203cfe:	4a668693          	addi	a3,a3,1190 # ffffffffc02061a0 <default_pmm_manager+0x7d8>
ffffffffc0203d02:	00001617          	auipc	a2,0x1
ffffffffc0203d06:	1d660613          	addi	a2,a2,470 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203d0a:	1f000593          	li	a1,496
ffffffffc0203d0e:	00002517          	auipc	a0,0x2
ffffffffc0203d12:	f0250513          	addi	a0,a0,-254 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203d16:	becfc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203d1a:	86aa                	mv	a3,a0
ffffffffc0203d1c:	00002617          	auipc	a2,0x2
ffffffffc0203d20:	ecc60613          	addi	a2,a2,-308 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0203d24:	06a00593          	li	a1,106
ffffffffc0203d28:	00001517          	auipc	a0,0x1
ffffffffc0203d2c:	42050513          	addi	a0,a0,1056 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0203d30:	bd2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(base != NULL);
ffffffffc0203d34:	00002697          	auipc	a3,0x2
ffffffffc0203d38:	48c68693          	addi	a3,a3,1164 # ffffffffc02061c0 <default_pmm_manager+0x7f8>
ffffffffc0203d3c:	00001617          	auipc	a2,0x1
ffffffffc0203d40:	19c60613          	addi	a2,a2,412 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203d44:	1f300593          	li	a1,499
ffffffffc0203d48:	00002517          	auipc	a0,0x2
ffffffffc0203d4c:	ec850513          	addi	a0,a0,-312 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203d50:	bb2fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203d54 <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0203d54:	1101                	addi	sp,sp,-32
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d56:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0203d58:	ec06                	sd	ra,24(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d5a:	fff58713          	addi	a4,a1,-1
ffffffffc0203d5e:	17f9                	addi	a5,a5,-2
ffffffffc0203d60:	0ae7ee63          	bltu	a5,a4,ffffffffc0203e1c <kfree+0xc8>
    assert(ptr != NULL);
ffffffffc0203d64:	cd41                	beqz	a0,ffffffffc0203dfc <kfree+0xa8>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203d66:	6785                	lui	a5,0x1
ffffffffc0203d68:	17fd                	addi	a5,a5,-1
ffffffffc0203d6a:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203d6c:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d70:	81b1                	srli	a1,a1,0xc
ffffffffc0203d72:	06f56863          	bltu	a0,a5,ffffffffc0203de2 <kfree+0x8e>
ffffffffc0203d76:	0000d697          	auipc	a3,0xd
ffffffffc0203d7a:	7f26b683          	ld	a3,2034(a3) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203d7e:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage) {
ffffffffc0203d80:	8131                	srli	a0,a0,0xc
ffffffffc0203d82:	0000d797          	auipc	a5,0xd
ffffffffc0203d86:	7ce7b783          	ld	a5,1998(a5) # ffffffffc0211550 <npage>
ffffffffc0203d8a:	04f57a63          	bgeu	a0,a5,ffffffffc0203dde <kfree+0x8a>
    return &pages[PPN(pa) - nbase];
ffffffffc0203d8e:	fff806b7          	lui	a3,0xfff80
ffffffffc0203d92:	9536                	add	a0,a0,a3
ffffffffc0203d94:	00351793          	slli	a5,a0,0x3
ffffffffc0203d98:	953e                	add	a0,a0,a5
ffffffffc0203d9a:	050e                	slli	a0,a0,0x3
ffffffffc0203d9c:	0000d797          	auipc	a5,0xd
ffffffffc0203da0:	7bc7b783          	ld	a5,1980(a5) # ffffffffc0211558 <pages>
ffffffffc0203da4:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203da6:	100027f3          	csrr	a5,sstatus
ffffffffc0203daa:	8b89                	andi	a5,a5,2
ffffffffc0203dac:	eb89                	bnez	a5,ffffffffc0203dbe <kfree+0x6a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203dae:	0000d797          	auipc	a5,0xd
ffffffffc0203db2:	7b27b783          	ld	a5,1970(a5) # ffffffffc0211560 <pmm_manager>
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc0203db6:	60e2                	ld	ra,24(sp)
    { pmm_manager->free_pages(base, n); }
ffffffffc0203db8:	739c                	ld	a5,32(a5)
}
ffffffffc0203dba:	6105                	addi	sp,sp,32
    { pmm_manager->free_pages(base, n); }
ffffffffc0203dbc:	8782                	jr	a5
        intr_disable();
ffffffffc0203dbe:	e42a                	sd	a0,8(sp)
ffffffffc0203dc0:	e02e                	sd	a1,0(sp)
ffffffffc0203dc2:	f2cfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203dc6:	0000d797          	auipc	a5,0xd
ffffffffc0203dca:	79a7b783          	ld	a5,1946(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203dce:	6582                	ld	a1,0(sp)
ffffffffc0203dd0:	6522                	ld	a0,8(sp)
ffffffffc0203dd2:	739c                	ld	a5,32(a5)
ffffffffc0203dd4:	9782                	jalr	a5
}
ffffffffc0203dd6:	60e2                	ld	ra,24(sp)
ffffffffc0203dd8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203dda:	f0efc06f          	j	ffffffffc02004e8 <intr_enable>
ffffffffc0203dde:	ccdfe0ef          	jal	ra,ffffffffc0202aaa <pa2page.part.0>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203de2:	86aa                	mv	a3,a0
ffffffffc0203de4:	00002617          	auipc	a2,0x2
ffffffffc0203de8:	ec460613          	addi	a2,a2,-316 # ffffffffc0205ca8 <default_pmm_manager+0x2e0>
ffffffffc0203dec:	06c00593          	li	a1,108
ffffffffc0203df0:	00001517          	auipc	a0,0x1
ffffffffc0203df4:	35850513          	addi	a0,a0,856 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0203df8:	b0afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(ptr != NULL);
ffffffffc0203dfc:	00002697          	auipc	a3,0x2
ffffffffc0203e00:	3d468693          	addi	a3,a3,980 # ffffffffc02061d0 <default_pmm_manager+0x808>
ffffffffc0203e04:	00001617          	auipc	a2,0x1
ffffffffc0203e08:	0d460613          	addi	a2,a2,212 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203e0c:	1fa00593          	li	a1,506
ffffffffc0203e10:	00002517          	auipc	a0,0x2
ffffffffc0203e14:	e0050513          	addi	a0,a0,-512 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203e18:	aeafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203e1c:	00002697          	auipc	a3,0x2
ffffffffc0203e20:	38468693          	addi	a3,a3,900 # ffffffffc02061a0 <default_pmm_manager+0x7d8>
ffffffffc0203e24:	00001617          	auipc	a2,0x1
ffffffffc0203e28:	0b460613          	addi	a2,a2,180 # ffffffffc0204ed8 <commands+0x770>
ffffffffc0203e2c:	1f900593          	li	a1,505
ffffffffc0203e30:	00002517          	auipc	a0,0x2
ffffffffc0203e34:	de050513          	addi	a0,a0,-544 # ffffffffc0205c10 <default_pmm_manager+0x248>
ffffffffc0203e38:	acafc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e3c <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0203e3c:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203e3e:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203e40:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203e42:	d90fc0ef          	jal	ra,ffffffffc02003d2 <ide_device_valid>
ffffffffc0203e46:	cd01                	beqz	a0,ffffffffc0203e5e <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203e48:	4505                	li	a0,1
ffffffffc0203e4a:	d8efc0ef          	jal	ra,ffffffffc02003d8 <ide_device_size>
}
ffffffffc0203e4e:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203e50:	810d                	srli	a0,a0,0x3
ffffffffc0203e52:	0000d797          	auipc	a5,0xd
ffffffffc0203e56:	6ca7bb23          	sd	a0,1750(a5) # ffffffffc0211528 <max_swap_offset>
}
ffffffffc0203e5a:	0141                	addi	sp,sp,16
ffffffffc0203e5c:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203e5e:	00002617          	auipc	a2,0x2
ffffffffc0203e62:	38260613          	addi	a2,a2,898 # ffffffffc02061e0 <default_pmm_manager+0x818>
ffffffffc0203e66:	45b5                	li	a1,13
ffffffffc0203e68:	00002517          	auipc	a0,0x2
ffffffffc0203e6c:	39850513          	addi	a0,a0,920 # ffffffffc0206200 <default_pmm_manager+0x838>
ffffffffc0203e70:	a92fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e74 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203e74:	1141                	addi	sp,sp,-16
ffffffffc0203e76:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e78:	00855793          	srli	a5,a0,0x8
ffffffffc0203e7c:	c3a5                	beqz	a5,ffffffffc0203edc <swapfs_read+0x68>
ffffffffc0203e7e:	0000d717          	auipc	a4,0xd
ffffffffc0203e82:	6aa73703          	ld	a4,1706(a4) # ffffffffc0211528 <max_swap_offset>
ffffffffc0203e86:	04e7fb63          	bgeu	a5,a4,ffffffffc0203edc <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e8a:	0000d617          	auipc	a2,0xd
ffffffffc0203e8e:	6ce63603          	ld	a2,1742(a2) # ffffffffc0211558 <pages>
ffffffffc0203e92:	8d91                	sub	a1,a1,a2
ffffffffc0203e94:	4035d613          	srai	a2,a1,0x3
ffffffffc0203e98:	00002597          	auipc	a1,0x2
ffffffffc0203e9c:	5e85b583          	ld	a1,1512(a1) # ffffffffc0206480 <error_string+0x38>
ffffffffc0203ea0:	02b60633          	mul	a2,a2,a1
ffffffffc0203ea4:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203ea8:	00002797          	auipc	a5,0x2
ffffffffc0203eac:	5e07b783          	ld	a5,1504(a5) # ffffffffc0206488 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203eb0:	0000d717          	auipc	a4,0xd
ffffffffc0203eb4:	6a073703          	ld	a4,1696(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203eb8:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203eba:	00c61793          	slli	a5,a2,0xc
ffffffffc0203ebe:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ec0:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203ec2:	02e7f963          	bgeu	a5,a4,ffffffffc0203ef4 <swapfs_read+0x80>
}
ffffffffc0203ec6:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203ec8:	0000d797          	auipc	a5,0xd
ffffffffc0203ecc:	6a07b783          	ld	a5,1696(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203ed0:	46a1                	li	a3,8
ffffffffc0203ed2:	963e                	add	a2,a2,a5
ffffffffc0203ed4:	4505                	li	a0,1
}
ffffffffc0203ed6:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203ed8:	d06fc06f          	j	ffffffffc02003de <ide_read_secs>
ffffffffc0203edc:	86aa                	mv	a3,a0
ffffffffc0203ede:	00002617          	auipc	a2,0x2
ffffffffc0203ee2:	33a60613          	addi	a2,a2,826 # ffffffffc0206218 <default_pmm_manager+0x850>
ffffffffc0203ee6:	45d1                	li	a1,20
ffffffffc0203ee8:	00002517          	auipc	a0,0x2
ffffffffc0203eec:	31850513          	addi	a0,a0,792 # ffffffffc0206200 <default_pmm_manager+0x838>
ffffffffc0203ef0:	a12fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203ef4:	86b2                	mv	a3,a2
ffffffffc0203ef6:	06a00593          	li	a1,106
ffffffffc0203efa:	00002617          	auipc	a2,0x2
ffffffffc0203efe:	cee60613          	addi	a2,a2,-786 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0203f02:	00001517          	auipc	a0,0x1
ffffffffc0203f06:	24650513          	addi	a0,a0,582 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0203f0a:	9f8fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203f0e <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203f0e:	1141                	addi	sp,sp,-16
ffffffffc0203f10:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f12:	00855793          	srli	a5,a0,0x8
ffffffffc0203f16:	c3a5                	beqz	a5,ffffffffc0203f76 <swapfs_write+0x68>
ffffffffc0203f18:	0000d717          	auipc	a4,0xd
ffffffffc0203f1c:	61073703          	ld	a4,1552(a4) # ffffffffc0211528 <max_swap_offset>
ffffffffc0203f20:	04e7fb63          	bgeu	a5,a4,ffffffffc0203f76 <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203f24:	0000d617          	auipc	a2,0xd
ffffffffc0203f28:	63463603          	ld	a2,1588(a2) # ffffffffc0211558 <pages>
ffffffffc0203f2c:	8d91                	sub	a1,a1,a2
ffffffffc0203f2e:	4035d613          	srai	a2,a1,0x3
ffffffffc0203f32:	00002597          	auipc	a1,0x2
ffffffffc0203f36:	54e5b583          	ld	a1,1358(a1) # ffffffffc0206480 <error_string+0x38>
ffffffffc0203f3a:	02b60633          	mul	a2,a2,a1
ffffffffc0203f3e:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203f42:	00002797          	auipc	a5,0x2
ffffffffc0203f46:	5467b783          	ld	a5,1350(a5) # ffffffffc0206488 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f4a:	0000d717          	auipc	a4,0xd
ffffffffc0203f4e:	60673703          	ld	a4,1542(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203f52:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f54:	00c61793          	slli	a5,a2,0xc
ffffffffc0203f58:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f5a:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f5c:	02e7f963          	bgeu	a5,a4,ffffffffc0203f8e <swapfs_write+0x80>
}
ffffffffc0203f60:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f62:	0000d797          	auipc	a5,0xd
ffffffffc0203f66:	6067b783          	ld	a5,1542(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203f6a:	46a1                	li	a3,8
ffffffffc0203f6c:	963e                	add	a2,a2,a5
ffffffffc0203f6e:	4505                	li	a0,1
}
ffffffffc0203f70:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f72:	c90fc06f          	j	ffffffffc0200402 <ide_write_secs>
ffffffffc0203f76:	86aa                	mv	a3,a0
ffffffffc0203f78:	00002617          	auipc	a2,0x2
ffffffffc0203f7c:	2a060613          	addi	a2,a2,672 # ffffffffc0206218 <default_pmm_manager+0x850>
ffffffffc0203f80:	45e5                	li	a1,25
ffffffffc0203f82:	00002517          	auipc	a0,0x2
ffffffffc0203f86:	27e50513          	addi	a0,a0,638 # ffffffffc0206200 <default_pmm_manager+0x838>
ffffffffc0203f8a:	978fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203f8e:	86b2                	mv	a3,a2
ffffffffc0203f90:	06a00593          	li	a1,106
ffffffffc0203f94:	00002617          	auipc	a2,0x2
ffffffffc0203f98:	c5460613          	addi	a2,a2,-940 # ffffffffc0205be8 <default_pmm_manager+0x220>
ffffffffc0203f9c:	00001517          	auipc	a0,0x1
ffffffffc0203fa0:	1ac50513          	addi	a0,a0,428 # ffffffffc0205148 <commands+0x9e0>
ffffffffc0203fa4:	95efc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203fa8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203fa8:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203fac:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203fae:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203fb0:	cb81                	beqz	a5,ffffffffc0203fc0 <strlen+0x18>
        cnt ++;
ffffffffc0203fb2:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203fb4:	00a707b3          	add	a5,a4,a0
ffffffffc0203fb8:	0007c783          	lbu	a5,0(a5)
ffffffffc0203fbc:	fbfd                	bnez	a5,ffffffffc0203fb2 <strlen+0xa>
ffffffffc0203fbe:	8082                	ret
    }
    return cnt;
}
ffffffffc0203fc0:	8082                	ret

ffffffffc0203fc2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203fc2:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203fc4:	e589                	bnez	a1,ffffffffc0203fce <strnlen+0xc>
ffffffffc0203fc6:	a811                	j	ffffffffc0203fda <strnlen+0x18>
        cnt ++;
ffffffffc0203fc8:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203fca:	00f58863          	beq	a1,a5,ffffffffc0203fda <strnlen+0x18>
ffffffffc0203fce:	00f50733          	add	a4,a0,a5
ffffffffc0203fd2:	00074703          	lbu	a4,0(a4)
ffffffffc0203fd6:	fb6d                	bnez	a4,ffffffffc0203fc8 <strnlen+0x6>
ffffffffc0203fd8:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203fda:	852e                	mv	a0,a1
ffffffffc0203fdc:	8082                	ret

ffffffffc0203fde <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203fde:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203fe0:	0005c703          	lbu	a4,0(a1)
ffffffffc0203fe4:	0785                	addi	a5,a5,1
ffffffffc0203fe6:	0585                	addi	a1,a1,1
ffffffffc0203fe8:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203fec:	fb75                	bnez	a4,ffffffffc0203fe0 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203fee:	8082                	ret

ffffffffc0203ff0 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203ff0:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203ff4:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203ff8:	cb89                	beqz	a5,ffffffffc020400a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0203ffa:	0505                	addi	a0,a0,1
ffffffffc0203ffc:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203ffe:	fee789e3          	beq	a5,a4,ffffffffc0203ff0 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204002:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204006:	9d19                	subw	a0,a0,a4
ffffffffc0204008:	8082                	ret
ffffffffc020400a:	4501                	li	a0,0
ffffffffc020400c:	bfed                	j	ffffffffc0204006 <strcmp+0x16>

ffffffffc020400e <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc020400e:	00054783          	lbu	a5,0(a0)
ffffffffc0204012:	c799                	beqz	a5,ffffffffc0204020 <strchr+0x12>
        if (*s == c) {
ffffffffc0204014:	00f58763          	beq	a1,a5,ffffffffc0204022 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0204018:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020401c:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020401e:	fbfd                	bnez	a5,ffffffffc0204014 <strchr+0x6>
    }
    return NULL;
ffffffffc0204020:	4501                	li	a0,0
}
ffffffffc0204022:	8082                	ret

ffffffffc0204024 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204024:	ca01                	beqz	a2,ffffffffc0204034 <memset+0x10>
ffffffffc0204026:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204028:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020402a:	0785                	addi	a5,a5,1
ffffffffc020402c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204030:	fec79de3          	bne	a5,a2,ffffffffc020402a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204034:	8082                	ret

ffffffffc0204036 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204036:	ca19                	beqz	a2,ffffffffc020404c <memcpy+0x16>
ffffffffc0204038:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020403a:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020403c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204040:	0585                	addi	a1,a1,1
ffffffffc0204042:	0785                	addi	a5,a5,1
ffffffffc0204044:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204048:	fec59ae3          	bne	a1,a2,ffffffffc020403c <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020404c:	8082                	ret

ffffffffc020404e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020404e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204052:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0204054:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204058:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020405a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020405e:	f022                	sd	s0,32(sp)
ffffffffc0204060:	ec26                	sd	s1,24(sp)
ffffffffc0204062:	e84a                	sd	s2,16(sp)
ffffffffc0204064:	f406                	sd	ra,40(sp)
ffffffffc0204066:	e44e                	sd	s3,8(sp)
ffffffffc0204068:	84aa                	mv	s1,a0
ffffffffc020406a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020406c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0204070:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0204072:	03067e63          	bgeu	a2,a6,ffffffffc02040ae <printnum+0x60>
ffffffffc0204076:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0204078:	00805763          	blez	s0,ffffffffc0204086 <printnum+0x38>
ffffffffc020407c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020407e:	85ca                	mv	a1,s2
ffffffffc0204080:	854e                	mv	a0,s3
ffffffffc0204082:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0204084:	fc65                	bnez	s0,ffffffffc020407c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204086:	1a02                	slli	s4,s4,0x20
ffffffffc0204088:	00002797          	auipc	a5,0x2
ffffffffc020408c:	1b078793          	addi	a5,a5,432 # ffffffffc0206238 <default_pmm_manager+0x870>
ffffffffc0204090:	020a5a13          	srli	s4,s4,0x20
ffffffffc0204094:	9a3e                	add	s4,s4,a5
}
ffffffffc0204096:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204098:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020409c:	70a2                	ld	ra,40(sp)
ffffffffc020409e:	69a2                	ld	s3,8(sp)
ffffffffc02040a0:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040a2:	85ca                	mv	a1,s2
ffffffffc02040a4:	87a6                	mv	a5,s1
}
ffffffffc02040a6:	6942                	ld	s2,16(sp)
ffffffffc02040a8:	64e2                	ld	s1,24(sp)
ffffffffc02040aa:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040ac:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02040ae:	03065633          	divu	a2,a2,a6
ffffffffc02040b2:	8722                	mv	a4,s0
ffffffffc02040b4:	f9bff0ef          	jal	ra,ffffffffc020404e <printnum>
ffffffffc02040b8:	b7f9                	j	ffffffffc0204086 <printnum+0x38>

ffffffffc02040ba <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02040ba:	7119                	addi	sp,sp,-128
ffffffffc02040bc:	f4a6                	sd	s1,104(sp)
ffffffffc02040be:	f0ca                	sd	s2,96(sp)
ffffffffc02040c0:	ecce                	sd	s3,88(sp)
ffffffffc02040c2:	e8d2                	sd	s4,80(sp)
ffffffffc02040c4:	e4d6                	sd	s5,72(sp)
ffffffffc02040c6:	e0da                	sd	s6,64(sp)
ffffffffc02040c8:	fc5e                	sd	s7,56(sp)
ffffffffc02040ca:	f06a                	sd	s10,32(sp)
ffffffffc02040cc:	fc86                	sd	ra,120(sp)
ffffffffc02040ce:	f8a2                	sd	s0,112(sp)
ffffffffc02040d0:	f862                	sd	s8,48(sp)
ffffffffc02040d2:	f466                	sd	s9,40(sp)
ffffffffc02040d4:	ec6e                	sd	s11,24(sp)
ffffffffc02040d6:	892a                	mv	s2,a0
ffffffffc02040d8:	84ae                	mv	s1,a1
ffffffffc02040da:	8d32                	mv	s10,a2
ffffffffc02040dc:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02040de:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02040e2:	5b7d                	li	s6,-1
ffffffffc02040e4:	00002a97          	auipc	s5,0x2
ffffffffc02040e8:	188a8a93          	addi	s5,s5,392 # ffffffffc020626c <default_pmm_manager+0x8a4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02040ec:	00002b97          	auipc	s7,0x2
ffffffffc02040f0:	35cb8b93          	addi	s7,s7,860 # ffffffffc0206448 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02040f4:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc02040f8:	001d0413          	addi	s0,s10,1
ffffffffc02040fc:	01350a63          	beq	a0,s3,ffffffffc0204110 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0204100:	c121                	beqz	a0,ffffffffc0204140 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0204102:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204104:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0204106:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204108:	fff44503          	lbu	a0,-1(s0)
ffffffffc020410c:	ff351ae3          	bne	a0,s3,ffffffffc0204100 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204110:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0204114:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0204118:	4c81                	li	s9,0
ffffffffc020411a:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020411c:	5c7d                	li	s8,-1
ffffffffc020411e:	5dfd                	li	s11,-1
ffffffffc0204120:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0204124:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204126:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020412a:	0ff5f593          	zext.b	a1,a1
ffffffffc020412e:	00140d13          	addi	s10,s0,1
ffffffffc0204132:	04b56263          	bltu	a0,a1,ffffffffc0204176 <vprintfmt+0xbc>
ffffffffc0204136:	058a                	slli	a1,a1,0x2
ffffffffc0204138:	95d6                	add	a1,a1,s5
ffffffffc020413a:	4194                	lw	a3,0(a1)
ffffffffc020413c:	96d6                	add	a3,a3,s5
ffffffffc020413e:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204140:	70e6                	ld	ra,120(sp)
ffffffffc0204142:	7446                	ld	s0,112(sp)
ffffffffc0204144:	74a6                	ld	s1,104(sp)
ffffffffc0204146:	7906                	ld	s2,96(sp)
ffffffffc0204148:	69e6                	ld	s3,88(sp)
ffffffffc020414a:	6a46                	ld	s4,80(sp)
ffffffffc020414c:	6aa6                	ld	s5,72(sp)
ffffffffc020414e:	6b06                	ld	s6,64(sp)
ffffffffc0204150:	7be2                	ld	s7,56(sp)
ffffffffc0204152:	7c42                	ld	s8,48(sp)
ffffffffc0204154:	7ca2                	ld	s9,40(sp)
ffffffffc0204156:	7d02                	ld	s10,32(sp)
ffffffffc0204158:	6de2                	ld	s11,24(sp)
ffffffffc020415a:	6109                	addi	sp,sp,128
ffffffffc020415c:	8082                	ret
            padc = '0';
ffffffffc020415e:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0204160:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204164:	846a                	mv	s0,s10
ffffffffc0204166:	00140d13          	addi	s10,s0,1
ffffffffc020416a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020416e:	0ff5f593          	zext.b	a1,a1
ffffffffc0204172:	fcb572e3          	bgeu	a0,a1,ffffffffc0204136 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0204176:	85a6                	mv	a1,s1
ffffffffc0204178:	02500513          	li	a0,37
ffffffffc020417c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020417e:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204182:	8d22                	mv	s10,s0
ffffffffc0204184:	f73788e3          	beq	a5,s3,ffffffffc02040f4 <vprintfmt+0x3a>
ffffffffc0204188:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020418c:	1d7d                	addi	s10,s10,-1
ffffffffc020418e:	ff379de3          	bne	a5,s3,ffffffffc0204188 <vprintfmt+0xce>
ffffffffc0204192:	b78d                	j	ffffffffc02040f4 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0204194:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0204198:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020419c:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020419e:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02041a2:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02041a6:	02d86463          	bltu	a6,a3,ffffffffc02041ce <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02041aa:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02041ae:	002c169b          	slliw	a3,s8,0x2
ffffffffc02041b2:	0186873b          	addw	a4,a3,s8
ffffffffc02041b6:	0017171b          	slliw	a4,a4,0x1
ffffffffc02041ba:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02041bc:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02041c0:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02041c2:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02041c6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02041ca:	fed870e3          	bgeu	a6,a3,ffffffffc02041aa <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02041ce:	f40ddce3          	bgez	s11,ffffffffc0204126 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02041d2:	8de2                	mv	s11,s8
ffffffffc02041d4:	5c7d                	li	s8,-1
ffffffffc02041d6:	bf81                	j	ffffffffc0204126 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02041d8:	fffdc693          	not	a3,s11
ffffffffc02041dc:	96fd                	srai	a3,a3,0x3f
ffffffffc02041de:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041e2:	00144603          	lbu	a2,1(s0)
ffffffffc02041e6:	2d81                	sext.w	s11,s11
ffffffffc02041e8:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02041ea:	bf35                	j	ffffffffc0204126 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02041ec:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041f0:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02041f4:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041f6:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02041f8:	bfd9                	j	ffffffffc02041ce <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02041fa:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02041fc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204200:	01174463          	blt	a4,a7,ffffffffc0204208 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204204:	1a088e63          	beqz	a7,ffffffffc02043c0 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0204208:	000a3603          	ld	a2,0(s4)
ffffffffc020420c:	46c1                	li	a3,16
ffffffffc020420e:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204210:	2781                	sext.w	a5,a5
ffffffffc0204212:	876e                	mv	a4,s11
ffffffffc0204214:	85a6                	mv	a1,s1
ffffffffc0204216:	854a                	mv	a0,s2
ffffffffc0204218:	e37ff0ef          	jal	ra,ffffffffc020404e <printnum>
            break;
ffffffffc020421c:	bde1                	j	ffffffffc02040f4 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020421e:	000a2503          	lw	a0,0(s4)
ffffffffc0204222:	85a6                	mv	a1,s1
ffffffffc0204224:	0a21                	addi	s4,s4,8
ffffffffc0204226:	9902                	jalr	s2
            break;
ffffffffc0204228:	b5f1                	j	ffffffffc02040f4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020422a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020422c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204230:	01174463          	blt	a4,a7,ffffffffc0204238 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0204234:	18088163          	beqz	a7,ffffffffc02043b6 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0204238:	000a3603          	ld	a2,0(s4)
ffffffffc020423c:	46a9                	li	a3,10
ffffffffc020423e:	8a2e                	mv	s4,a1
ffffffffc0204240:	bfc1                	j	ffffffffc0204210 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204242:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0204246:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204248:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020424a:	bdf1                	j	ffffffffc0204126 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020424c:	85a6                	mv	a1,s1
ffffffffc020424e:	02500513          	li	a0,37
ffffffffc0204252:	9902                	jalr	s2
            break;
ffffffffc0204254:	b545                	j	ffffffffc02040f4 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204256:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020425a:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020425c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020425e:	b5e1                	j	ffffffffc0204126 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0204260:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204262:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204266:	01174463          	blt	a4,a7,ffffffffc020426e <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020426a:	14088163          	beqz	a7,ffffffffc02043ac <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020426e:	000a3603          	ld	a2,0(s4)
ffffffffc0204272:	46a1                	li	a3,8
ffffffffc0204274:	8a2e                	mv	s4,a1
ffffffffc0204276:	bf69                	j	ffffffffc0204210 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0204278:	03000513          	li	a0,48
ffffffffc020427c:	85a6                	mv	a1,s1
ffffffffc020427e:	e03e                	sd	a5,0(sp)
ffffffffc0204280:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204282:	85a6                	mv	a1,s1
ffffffffc0204284:	07800513          	li	a0,120
ffffffffc0204288:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020428a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020428c:	6782                	ld	a5,0(sp)
ffffffffc020428e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204290:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0204294:	bfb5                	j	ffffffffc0204210 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204296:	000a3403          	ld	s0,0(s4)
ffffffffc020429a:	008a0713          	addi	a4,s4,8
ffffffffc020429e:	e03a                	sd	a4,0(sp)
ffffffffc02042a0:	14040263          	beqz	s0,ffffffffc02043e4 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02042a4:	0fb05763          	blez	s11,ffffffffc0204392 <vprintfmt+0x2d8>
ffffffffc02042a8:	02d00693          	li	a3,45
ffffffffc02042ac:	0cd79163          	bne	a5,a3,ffffffffc020436e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042b0:	00044783          	lbu	a5,0(s0)
ffffffffc02042b4:	0007851b          	sext.w	a0,a5
ffffffffc02042b8:	cf85                	beqz	a5,ffffffffc02042f0 <vprintfmt+0x236>
ffffffffc02042ba:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02042be:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042c2:	000c4563          	bltz	s8,ffffffffc02042cc <vprintfmt+0x212>
ffffffffc02042c6:	3c7d                	addiw	s8,s8,-1
ffffffffc02042c8:	036c0263          	beq	s8,s6,ffffffffc02042ec <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02042cc:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02042ce:	0e0c8e63          	beqz	s9,ffffffffc02043ca <vprintfmt+0x310>
ffffffffc02042d2:	3781                	addiw	a5,a5,-32
ffffffffc02042d4:	0ef47b63          	bgeu	s0,a5,ffffffffc02043ca <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02042d8:	03f00513          	li	a0,63
ffffffffc02042dc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042de:	000a4783          	lbu	a5,0(s4)
ffffffffc02042e2:	3dfd                	addiw	s11,s11,-1
ffffffffc02042e4:	0a05                	addi	s4,s4,1
ffffffffc02042e6:	0007851b          	sext.w	a0,a5
ffffffffc02042ea:	ffe1                	bnez	a5,ffffffffc02042c2 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02042ec:	01b05963          	blez	s11,ffffffffc02042fe <vprintfmt+0x244>
ffffffffc02042f0:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02042f2:	85a6                	mv	a1,s1
ffffffffc02042f4:	02000513          	li	a0,32
ffffffffc02042f8:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02042fa:	fe0d9be3          	bnez	s11,ffffffffc02042f0 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02042fe:	6a02                	ld	s4,0(sp)
ffffffffc0204300:	bbd5                	j	ffffffffc02040f4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204302:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204304:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0204308:	01174463          	blt	a4,a7,ffffffffc0204310 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020430c:	08088d63          	beqz	a7,ffffffffc02043a6 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204310:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204314:	0a044d63          	bltz	s0,ffffffffc02043ce <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0204318:	8622                	mv	a2,s0
ffffffffc020431a:	8a66                	mv	s4,s9
ffffffffc020431c:	46a9                	li	a3,10
ffffffffc020431e:	bdcd                	j	ffffffffc0204210 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204320:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204324:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0204326:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0204328:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020432c:	8fb5                	xor	a5,a5,a3
ffffffffc020432e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204332:	02d74163          	blt	a4,a3,ffffffffc0204354 <vprintfmt+0x29a>
ffffffffc0204336:	00369793          	slli	a5,a3,0x3
ffffffffc020433a:	97de                	add	a5,a5,s7
ffffffffc020433c:	639c                	ld	a5,0(a5)
ffffffffc020433e:	cb99                	beqz	a5,ffffffffc0204354 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204340:	86be                	mv	a3,a5
ffffffffc0204342:	00002617          	auipc	a2,0x2
ffffffffc0204346:	f2660613          	addi	a2,a2,-218 # ffffffffc0206268 <default_pmm_manager+0x8a0>
ffffffffc020434a:	85a6                	mv	a1,s1
ffffffffc020434c:	854a                	mv	a0,s2
ffffffffc020434e:	0ce000ef          	jal	ra,ffffffffc020441c <printfmt>
ffffffffc0204352:	b34d                	j	ffffffffc02040f4 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204354:	00002617          	auipc	a2,0x2
ffffffffc0204358:	f0460613          	addi	a2,a2,-252 # ffffffffc0206258 <default_pmm_manager+0x890>
ffffffffc020435c:	85a6                	mv	a1,s1
ffffffffc020435e:	854a                	mv	a0,s2
ffffffffc0204360:	0bc000ef          	jal	ra,ffffffffc020441c <printfmt>
ffffffffc0204364:	bb41                	j	ffffffffc02040f4 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0204366:	00002417          	auipc	s0,0x2
ffffffffc020436a:	eea40413          	addi	s0,s0,-278 # ffffffffc0206250 <default_pmm_manager+0x888>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020436e:	85e2                	mv	a1,s8
ffffffffc0204370:	8522                	mv	a0,s0
ffffffffc0204372:	e43e                	sd	a5,8(sp)
ffffffffc0204374:	c4fff0ef          	jal	ra,ffffffffc0203fc2 <strnlen>
ffffffffc0204378:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020437c:	01b05b63          	blez	s11,ffffffffc0204392 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0204380:	67a2                	ld	a5,8(sp)
ffffffffc0204382:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204386:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0204388:	85a6                	mv	a1,s1
ffffffffc020438a:	8552                	mv	a0,s4
ffffffffc020438c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020438e:	fe0d9ce3          	bnez	s11,ffffffffc0204386 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204392:	00044783          	lbu	a5,0(s0)
ffffffffc0204396:	00140a13          	addi	s4,s0,1
ffffffffc020439a:	0007851b          	sext.w	a0,a5
ffffffffc020439e:	d3a5                	beqz	a5,ffffffffc02042fe <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02043a0:	05e00413          	li	s0,94
ffffffffc02043a4:	bf39                	j	ffffffffc02042c2 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02043a6:	000a2403          	lw	s0,0(s4)
ffffffffc02043aa:	b7ad                	j	ffffffffc0204314 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02043ac:	000a6603          	lwu	a2,0(s4)
ffffffffc02043b0:	46a1                	li	a3,8
ffffffffc02043b2:	8a2e                	mv	s4,a1
ffffffffc02043b4:	bdb1                	j	ffffffffc0204210 <vprintfmt+0x156>
ffffffffc02043b6:	000a6603          	lwu	a2,0(s4)
ffffffffc02043ba:	46a9                	li	a3,10
ffffffffc02043bc:	8a2e                	mv	s4,a1
ffffffffc02043be:	bd89                	j	ffffffffc0204210 <vprintfmt+0x156>
ffffffffc02043c0:	000a6603          	lwu	a2,0(s4)
ffffffffc02043c4:	46c1                	li	a3,16
ffffffffc02043c6:	8a2e                	mv	s4,a1
ffffffffc02043c8:	b5a1                	j	ffffffffc0204210 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02043ca:	9902                	jalr	s2
ffffffffc02043cc:	bf09                	j	ffffffffc02042de <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02043ce:	85a6                	mv	a1,s1
ffffffffc02043d0:	02d00513          	li	a0,45
ffffffffc02043d4:	e03e                	sd	a5,0(sp)
ffffffffc02043d6:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02043d8:	6782                	ld	a5,0(sp)
ffffffffc02043da:	8a66                	mv	s4,s9
ffffffffc02043dc:	40800633          	neg	a2,s0
ffffffffc02043e0:	46a9                	li	a3,10
ffffffffc02043e2:	b53d                	j	ffffffffc0204210 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02043e4:	03b05163          	blez	s11,ffffffffc0204406 <vprintfmt+0x34c>
ffffffffc02043e8:	02d00693          	li	a3,45
ffffffffc02043ec:	f6d79de3          	bne	a5,a3,ffffffffc0204366 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02043f0:	00002417          	auipc	s0,0x2
ffffffffc02043f4:	e6040413          	addi	s0,s0,-416 # ffffffffc0206250 <default_pmm_manager+0x888>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02043f8:	02800793          	li	a5,40
ffffffffc02043fc:	02800513          	li	a0,40
ffffffffc0204400:	00140a13          	addi	s4,s0,1
ffffffffc0204404:	bd6d                	j	ffffffffc02042be <vprintfmt+0x204>
ffffffffc0204406:	00002a17          	auipc	s4,0x2
ffffffffc020440a:	e4ba0a13          	addi	s4,s4,-437 # ffffffffc0206251 <default_pmm_manager+0x889>
ffffffffc020440e:	02800513          	li	a0,40
ffffffffc0204412:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204416:	05e00413          	li	s0,94
ffffffffc020441a:	b565                	j	ffffffffc02042c2 <vprintfmt+0x208>

ffffffffc020441c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020441c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020441e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204422:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204424:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204426:	ec06                	sd	ra,24(sp)
ffffffffc0204428:	f83a                	sd	a4,48(sp)
ffffffffc020442a:	fc3e                	sd	a5,56(sp)
ffffffffc020442c:	e0c2                	sd	a6,64(sp)
ffffffffc020442e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204430:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204432:	c89ff0ef          	jal	ra,ffffffffc02040ba <vprintfmt>
}
ffffffffc0204436:	60e2                	ld	ra,24(sp)
ffffffffc0204438:	6161                	addi	sp,sp,80
ffffffffc020443a:	8082                	ret

ffffffffc020443c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020443c:	715d                	addi	sp,sp,-80
ffffffffc020443e:	e486                	sd	ra,72(sp)
ffffffffc0204440:	e0a6                	sd	s1,64(sp)
ffffffffc0204442:	fc4a                	sd	s2,56(sp)
ffffffffc0204444:	f84e                	sd	s3,48(sp)
ffffffffc0204446:	f452                	sd	s4,40(sp)
ffffffffc0204448:	f056                	sd	s5,32(sp)
ffffffffc020444a:	ec5a                	sd	s6,24(sp)
ffffffffc020444c:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020444e:	c901                	beqz	a0,ffffffffc020445e <readline+0x22>
ffffffffc0204450:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0204452:	00002517          	auipc	a0,0x2
ffffffffc0204456:	e1650513          	addi	a0,a0,-490 # ffffffffc0206268 <default_pmm_manager+0x8a0>
ffffffffc020445a:	c61fb0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc020445e:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204460:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0204462:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0204464:	4aa9                	li	s5,10
ffffffffc0204466:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0204468:	0000db97          	auipc	s7,0xd
ffffffffc020446c:	c90b8b93          	addi	s7,s7,-880 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204470:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0204474:	c7ffb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc0204478:	00054a63          	bltz	a0,ffffffffc020448c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020447c:	00a95a63          	bge	s2,a0,ffffffffc0204490 <readline+0x54>
ffffffffc0204480:	029a5263          	bge	s4,s1,ffffffffc02044a4 <readline+0x68>
        c = getchar();
ffffffffc0204484:	c6ffb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc0204488:	fe055ae3          	bgez	a0,ffffffffc020447c <readline+0x40>
            return NULL;
ffffffffc020448c:	4501                	li	a0,0
ffffffffc020448e:	a091                	j	ffffffffc02044d2 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0204490:	03351463          	bne	a0,s3,ffffffffc02044b8 <readline+0x7c>
ffffffffc0204494:	e8a9                	bnez	s1,ffffffffc02044e6 <readline+0xaa>
        c = getchar();
ffffffffc0204496:	c5dfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc020449a:	fe0549e3          	bltz	a0,ffffffffc020448c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020449e:	fea959e3          	bge	s2,a0,ffffffffc0204490 <readline+0x54>
ffffffffc02044a2:	4481                	li	s1,0
            cputchar(c);
ffffffffc02044a4:	e42a                	sd	a0,8(sp)
ffffffffc02044a6:	c4bfb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc02044aa:	6522                	ld	a0,8(sp)
ffffffffc02044ac:	009b87b3          	add	a5,s7,s1
ffffffffc02044b0:	2485                	addiw	s1,s1,1
ffffffffc02044b2:	00a78023          	sb	a0,0(a5)
ffffffffc02044b6:	bf7d                	j	ffffffffc0204474 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02044b8:	01550463          	beq	a0,s5,ffffffffc02044c0 <readline+0x84>
ffffffffc02044bc:	fb651ce3          	bne	a0,s6,ffffffffc0204474 <readline+0x38>
            cputchar(c);
ffffffffc02044c0:	c31fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc02044c4:	0000d517          	auipc	a0,0xd
ffffffffc02044c8:	c3450513          	addi	a0,a0,-972 # ffffffffc02110f8 <buf>
ffffffffc02044cc:	94aa                	add	s1,s1,a0
ffffffffc02044ce:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02044d2:	60a6                	ld	ra,72(sp)
ffffffffc02044d4:	6486                	ld	s1,64(sp)
ffffffffc02044d6:	7962                	ld	s2,56(sp)
ffffffffc02044d8:	79c2                	ld	s3,48(sp)
ffffffffc02044da:	7a22                	ld	s4,40(sp)
ffffffffc02044dc:	7a82                	ld	s5,32(sp)
ffffffffc02044de:	6b62                	ld	s6,24(sp)
ffffffffc02044e0:	6bc2                	ld	s7,16(sp)
ffffffffc02044e2:	6161                	addi	sp,sp,80
ffffffffc02044e4:	8082                	ret
            cputchar(c);
ffffffffc02044e6:	4521                	li	a0,8
ffffffffc02044e8:	c09fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc02044ec:	34fd                	addiw	s1,s1,-1
ffffffffc02044ee:	b759                	j	ffffffffc0204474 <readline+0x38>
