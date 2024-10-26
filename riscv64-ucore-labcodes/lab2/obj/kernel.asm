
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
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
ffffffffc0200024:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
void grade_backtrace(void);


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	ffe50513          	addi	a0,a0,-2 # ffffffffc0206030 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	47e60613          	addi	a2,a2,1150 # ffffffffc02064b8 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	488010ef          	jal	ra,ffffffffc02014d2 <memset>
    cons_init();  // init the console
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	99e50513          	addi	a0,a0,-1634 # ffffffffc02019f0 <etext>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>

    print_kerninfo();
ffffffffc020005e:	140000ef          	jal	ra,ffffffffc020019e <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	0cd000ef          	jal	ra,ffffffffc0200932 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>

    // check slub pmm
    slub_init();
ffffffffc0200076:	43f000ef          	jal	ra,ffffffffc0200cb4 <slub_init>
    slub_check();
ffffffffc020007a:	4af000ef          	jal	ra,ffffffffc0200d28 <slub_check>

    /* do nothing */
    while (1)
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
ffffffffc0200088:	3cc000ef          	jal	ra,ffffffffc0200454 <cons_putc>
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
ffffffffc02000ae:	4a2010ef          	jal	ra,ffffffffc0201550 <vprintfmt>
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
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
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
ffffffffc02000e4:	46c010ef          	jal	ra,ffffffffc0201550 <vprintfmt>
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
ffffffffc02000f0:	a695                	j	ffffffffc0200454 <cons_putc>

ffffffffc02000f2 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02000f2:	1101                	addi	sp,sp,-32
ffffffffc02000f4:	e822                	sd	s0,16(sp)
ffffffffc02000f6:	ec06                	sd	ra,24(sp)
ffffffffc02000f8:	e426                	sd	s1,8(sp)
ffffffffc02000fa:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02000fc:	00054503          	lbu	a0,0(a0)
ffffffffc0200100:	c51d                	beqz	a0,ffffffffc020012e <cputs+0x3c>
ffffffffc0200102:	0405                	addi	s0,s0,1
ffffffffc0200104:	4485                	li	s1,1
ffffffffc0200106:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200108:	34c000ef          	jal	ra,ffffffffc0200454 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020010c:	00044503          	lbu	a0,0(s0)
ffffffffc0200110:	008487bb          	addw	a5,s1,s0
ffffffffc0200114:	0405                	addi	s0,s0,1
ffffffffc0200116:	f96d                	bnez	a0,ffffffffc0200108 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200118:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc020011c:	4529                	li	a0,10
ffffffffc020011e:	336000ef          	jal	ra,ffffffffc0200454 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	8522                	mv	a0,s0
ffffffffc0200126:	6442                	ld	s0,16(sp)
ffffffffc0200128:	64a2                	ld	s1,8(sp)
ffffffffc020012a:	6105                	addi	sp,sp,32
ffffffffc020012c:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc020012e:	4405                	li	s0,1
ffffffffc0200130:	b7f5                	j	ffffffffc020011c <cputs+0x2a>

ffffffffc0200132 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200132:	1141                	addi	sp,sp,-16
ffffffffc0200134:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200136:	326000ef          	jal	ra,ffffffffc020045c <cons_getc>
ffffffffc020013a:	dd75                	beqz	a0,ffffffffc0200136 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020013c:	60a2                	ld	ra,8(sp)
ffffffffc020013e:	0141                	addi	sp,sp,16
ffffffffc0200140:	8082                	ret

ffffffffc0200142 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200142:	00006317          	auipc	t1,0x6
ffffffffc0200146:	30630313          	addi	t1,t1,774 # ffffffffc0206448 <is_panic>
ffffffffc020014a:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020014e:	715d                	addi	sp,sp,-80
ffffffffc0200150:	ec06                	sd	ra,24(sp)
ffffffffc0200152:	e822                	sd	s0,16(sp)
ffffffffc0200154:	f436                	sd	a3,40(sp)
ffffffffc0200156:	f83a                	sd	a4,48(sp)
ffffffffc0200158:	fc3e                	sd	a5,56(sp)
ffffffffc020015a:	e0c2                	sd	a6,64(sp)
ffffffffc020015c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020015e:	020e1a63          	bnez	t3,ffffffffc0200192 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200162:	4785                	li	a5,1
ffffffffc0200164:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200168:	8432                	mv	s0,a2
ffffffffc020016a:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020016c:	862e                	mv	a2,a1
ffffffffc020016e:	85aa                	mv	a1,a0
ffffffffc0200170:	00002517          	auipc	a0,0x2
ffffffffc0200174:	8a050513          	addi	a0,a0,-1888 # ffffffffc0201a10 <etext+0x20>
    va_start(ap, fmt);
ffffffffc0200178:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020017a:	f41ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    vcprintf(fmt, ap);
ffffffffc020017e:	65a2                	ld	a1,8(sp)
ffffffffc0200180:	8522                	mv	a0,s0
ffffffffc0200182:	f19ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
    cprintf("\n");
ffffffffc0200186:	00002517          	auipc	a0,0x2
ffffffffc020018a:	25250513          	addi	a0,a0,594 # ffffffffc02023d8 <commands+0x770>
ffffffffc020018e:	f2dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200192:	2d4000ef          	jal	ra,ffffffffc0200466 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200196:	4501                	li	a0,0
ffffffffc0200198:	130000ef          	jal	ra,ffffffffc02002c8 <kmonitor>
    while (1) {
ffffffffc020019c:	bfed                	j	ffffffffc0200196 <__panic+0x54>

ffffffffc020019e <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020019e:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001a0:	00002517          	auipc	a0,0x2
ffffffffc02001a4:	89050513          	addi	a0,a0,-1904 # ffffffffc0201a30 <etext+0x40>
void print_kerninfo(void) {
ffffffffc02001a8:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001aa:	f11ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001ae:	00000597          	auipc	a1,0x0
ffffffffc02001b2:	e8458593          	addi	a1,a1,-380 # ffffffffc0200032 <kern_init>
ffffffffc02001b6:	00002517          	auipc	a0,0x2
ffffffffc02001ba:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201a50 <etext+0x60>
ffffffffc02001be:	efdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001c2:	00002597          	auipc	a1,0x2
ffffffffc02001c6:	82e58593          	addi	a1,a1,-2002 # ffffffffc02019f0 <etext>
ffffffffc02001ca:	00002517          	auipc	a0,0x2
ffffffffc02001ce:	8a650513          	addi	a0,a0,-1882 # ffffffffc0201a70 <etext+0x80>
ffffffffc02001d2:	ee9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001d6:	00006597          	auipc	a1,0x6
ffffffffc02001da:	e5a58593          	addi	a1,a1,-422 # ffffffffc0206030 <free_area>
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	8b250513          	addi	a0,a0,-1870 # ffffffffc0201a90 <etext+0xa0>
ffffffffc02001e6:	ed5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001ea:	00006597          	auipc	a1,0x6
ffffffffc02001ee:	2ce58593          	addi	a1,a1,718 # ffffffffc02064b8 <end>
ffffffffc02001f2:	00002517          	auipc	a0,0x2
ffffffffc02001f6:	8be50513          	addi	a0,a0,-1858 # ffffffffc0201ab0 <etext+0xc0>
ffffffffc02001fa:	ec1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001fe:	00006597          	auipc	a1,0x6
ffffffffc0200202:	6b958593          	addi	a1,a1,1721 # ffffffffc02068b7 <end+0x3ff>
ffffffffc0200206:	00000797          	auipc	a5,0x0
ffffffffc020020a:	e2c78793          	addi	a5,a5,-468 # ffffffffc0200032 <kern_init>
ffffffffc020020e:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200212:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200218:	3ff5f593          	andi	a1,a1,1023
ffffffffc020021c:	95be                	add	a1,a1,a5
ffffffffc020021e:	85a9                	srai	a1,a1,0xa
ffffffffc0200220:	00002517          	auipc	a0,0x2
ffffffffc0200224:	8b050513          	addi	a0,a0,-1872 # ffffffffc0201ad0 <etext+0xe0>
}
ffffffffc0200228:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020022a:	bd41                	j	ffffffffc02000ba <cprintf>

ffffffffc020022c <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc020022c:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc020022e:	00002617          	auipc	a2,0x2
ffffffffc0200232:	8d260613          	addi	a2,a2,-1838 # ffffffffc0201b00 <etext+0x110>
ffffffffc0200236:	04e00593          	li	a1,78
ffffffffc020023a:	00002517          	auipc	a0,0x2
ffffffffc020023e:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201b18 <etext+0x128>
void print_stackframe(void) {
ffffffffc0200242:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200244:	effff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200248 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200248:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020024a:	00002617          	auipc	a2,0x2
ffffffffc020024e:	8e660613          	addi	a2,a2,-1818 # ffffffffc0201b30 <etext+0x140>
ffffffffc0200252:	00002597          	auipc	a1,0x2
ffffffffc0200256:	8fe58593          	addi	a1,a1,-1794 # ffffffffc0201b50 <etext+0x160>
ffffffffc020025a:	00002517          	auipc	a0,0x2
ffffffffc020025e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0201b58 <etext+0x168>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200262:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200264:	e57ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200268:	00002617          	auipc	a2,0x2
ffffffffc020026c:	90060613          	addi	a2,a2,-1792 # ffffffffc0201b68 <etext+0x178>
ffffffffc0200270:	00002597          	auipc	a1,0x2
ffffffffc0200274:	92058593          	addi	a1,a1,-1760 # ffffffffc0201b90 <etext+0x1a0>
ffffffffc0200278:	00002517          	auipc	a0,0x2
ffffffffc020027c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0201b58 <etext+0x168>
ffffffffc0200280:	e3bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200284:	00002617          	auipc	a2,0x2
ffffffffc0200288:	91c60613          	addi	a2,a2,-1764 # ffffffffc0201ba0 <etext+0x1b0>
ffffffffc020028c:	00002597          	auipc	a1,0x2
ffffffffc0200290:	93458593          	addi	a1,a1,-1740 # ffffffffc0201bc0 <etext+0x1d0>
ffffffffc0200294:	00002517          	auipc	a0,0x2
ffffffffc0200298:	8c450513          	addi	a0,a0,-1852 # ffffffffc0201b58 <etext+0x168>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    }
    return 0;
}
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	4501                	li	a0,0
ffffffffc02002a4:	0141                	addi	sp,sp,16
ffffffffc02002a6:	8082                	ret

ffffffffc02002a8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a8:	1141                	addi	sp,sp,-16
ffffffffc02002aa:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002ac:	ef3ff0ef          	jal	ra,ffffffffc020019e <print_kerninfo>
    return 0;
}
ffffffffc02002b0:	60a2                	ld	ra,8(sp)
ffffffffc02002b2:	4501                	li	a0,0
ffffffffc02002b4:	0141                	addi	sp,sp,16
ffffffffc02002b6:	8082                	ret

ffffffffc02002b8 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b8:	1141                	addi	sp,sp,-16
ffffffffc02002ba:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002bc:	f71ff0ef          	jal	ra,ffffffffc020022c <print_stackframe>
    return 0;
}
ffffffffc02002c0:	60a2                	ld	ra,8(sp)
ffffffffc02002c2:	4501                	li	a0,0
ffffffffc02002c4:	0141                	addi	sp,sp,16
ffffffffc02002c6:	8082                	ret

ffffffffc02002c8 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002c8:	7115                	addi	sp,sp,-224
ffffffffc02002ca:	ed5e                	sd	s7,152(sp)
ffffffffc02002cc:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002ce:	00002517          	auipc	a0,0x2
ffffffffc02002d2:	90250513          	addi	a0,a0,-1790 # ffffffffc0201bd0 <etext+0x1e0>
kmonitor(struct trapframe *tf) {
ffffffffc02002d6:	ed86                	sd	ra,216(sp)
ffffffffc02002d8:	e9a2                	sd	s0,208(sp)
ffffffffc02002da:	e5a6                	sd	s1,200(sp)
ffffffffc02002dc:	e1ca                	sd	s2,192(sp)
ffffffffc02002de:	fd4e                	sd	s3,184(sp)
ffffffffc02002e0:	f952                	sd	s4,176(sp)
ffffffffc02002e2:	f556                	sd	s5,168(sp)
ffffffffc02002e4:	f15a                	sd	s6,160(sp)
ffffffffc02002e6:	e962                	sd	s8,144(sp)
ffffffffc02002e8:	e566                	sd	s9,136(sp)
ffffffffc02002ea:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002ec:	dcfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002f0:	00002517          	auipc	a0,0x2
ffffffffc02002f4:	90850513          	addi	a0,a0,-1784 # ffffffffc0201bf8 <etext+0x208>
ffffffffc02002f8:	dc3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002fc:	000b8563          	beqz	s7,ffffffffc0200306 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200300:	855e                	mv	a0,s7
ffffffffc0200302:	348000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc0200306:	00002c17          	auipc	s8,0x2
ffffffffc020030a:	962c0c13          	addi	s8,s8,-1694 # ffffffffc0201c68 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020030e:	00002917          	auipc	s2,0x2
ffffffffc0200312:	91290913          	addi	s2,s2,-1774 # ffffffffc0201c20 <etext+0x230>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200316:	00002497          	auipc	s1,0x2
ffffffffc020031a:	91248493          	addi	s1,s1,-1774 # ffffffffc0201c28 <etext+0x238>
        if (argc == MAXARGS - 1) {
ffffffffc020031e:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200320:	00002b17          	auipc	s6,0x2
ffffffffc0200324:	910b0b13          	addi	s6,s6,-1776 # ffffffffc0201c30 <etext+0x240>
        argv[argc ++] = buf;
ffffffffc0200328:	00002a17          	auipc	s4,0x2
ffffffffc020032c:	828a0a13          	addi	s4,s4,-2008 # ffffffffc0201b50 <etext+0x160>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200330:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200332:	854a                	mv	a0,s2
ffffffffc0200334:	59e010ef          	jal	ra,ffffffffc02018d2 <readline>
ffffffffc0200338:	842a                	mv	s0,a0
ffffffffc020033a:	dd65                	beqz	a0,ffffffffc0200332 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033c:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200340:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200342:	e1bd                	bnez	a1,ffffffffc02003a8 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200344:	fe0c87e3          	beqz	s9,ffffffffc0200332 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200348:	6582                	ld	a1,0(sp)
ffffffffc020034a:	00002d17          	auipc	s10,0x2
ffffffffc020034e:	91ed0d13          	addi	s10,s10,-1762 # ffffffffc0201c68 <commands>
        argv[argc ++] = buf;
ffffffffc0200352:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200354:	4401                	li	s0,0
ffffffffc0200356:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200358:	146010ef          	jal	ra,ffffffffc020149e <strcmp>
ffffffffc020035c:	c919                	beqz	a0,ffffffffc0200372 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020035e:	2405                	addiw	s0,s0,1
ffffffffc0200360:	0b540063          	beq	s0,s5,ffffffffc0200400 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200364:	000d3503          	ld	a0,0(s10)
ffffffffc0200368:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020036a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020036c:	132010ef          	jal	ra,ffffffffc020149e <strcmp>
ffffffffc0200370:	f57d                	bnez	a0,ffffffffc020035e <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200372:	00141793          	slli	a5,s0,0x1
ffffffffc0200376:	97a2                	add	a5,a5,s0
ffffffffc0200378:	078e                	slli	a5,a5,0x3
ffffffffc020037a:	97e2                	add	a5,a5,s8
ffffffffc020037c:	6b9c                	ld	a5,16(a5)
ffffffffc020037e:	865e                	mv	a2,s7
ffffffffc0200380:	002c                	addi	a1,sp,8
ffffffffc0200382:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200386:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200388:	fa0555e3          	bgez	a0,ffffffffc0200332 <kmonitor+0x6a>
}
ffffffffc020038c:	60ee                	ld	ra,216(sp)
ffffffffc020038e:	644e                	ld	s0,208(sp)
ffffffffc0200390:	64ae                	ld	s1,200(sp)
ffffffffc0200392:	690e                	ld	s2,192(sp)
ffffffffc0200394:	79ea                	ld	s3,184(sp)
ffffffffc0200396:	7a4a                	ld	s4,176(sp)
ffffffffc0200398:	7aaa                	ld	s5,168(sp)
ffffffffc020039a:	7b0a                	ld	s6,160(sp)
ffffffffc020039c:	6bea                	ld	s7,152(sp)
ffffffffc020039e:	6c4a                	ld	s8,144(sp)
ffffffffc02003a0:	6caa                	ld	s9,136(sp)
ffffffffc02003a2:	6d0a                	ld	s10,128(sp)
ffffffffc02003a4:	612d                	addi	sp,sp,224
ffffffffc02003a6:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a8:	8526                	mv	a0,s1
ffffffffc02003aa:	112010ef          	jal	ra,ffffffffc02014bc <strchr>
ffffffffc02003ae:	c901                	beqz	a0,ffffffffc02003be <kmonitor+0xf6>
ffffffffc02003b0:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003b4:	00040023          	sb	zero,0(s0)
ffffffffc02003b8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ba:	d5c9                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003bc:	b7f5                	j	ffffffffc02003a8 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc02003be:	00044783          	lbu	a5,0(s0)
ffffffffc02003c2:	d3c9                	beqz	a5,ffffffffc0200344 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02003c4:	033c8963          	beq	s9,s3,ffffffffc02003f6 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc02003c8:	003c9793          	slli	a5,s9,0x3
ffffffffc02003cc:	0118                	addi	a4,sp,128
ffffffffc02003ce:	97ba                	add	a5,a5,a4
ffffffffc02003d0:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003d4:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003d8:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003da:	e591                	bnez	a1,ffffffffc02003e6 <kmonitor+0x11e>
ffffffffc02003dc:	b7b5                	j	ffffffffc0200348 <kmonitor+0x80>
ffffffffc02003de:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003e2:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003e4:	d1a5                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003e6:	8526                	mv	a0,s1
ffffffffc02003e8:	0d4010ef          	jal	ra,ffffffffc02014bc <strchr>
ffffffffc02003ec:	d96d                	beqz	a0,ffffffffc02003de <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ee:	00044583          	lbu	a1,0(s0)
ffffffffc02003f2:	d9a9                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003f4:	bf55                	j	ffffffffc02003a8 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003f6:	45c1                	li	a1,16
ffffffffc02003f8:	855a                	mv	a0,s6
ffffffffc02003fa:	cc1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003fe:	b7e9                	j	ffffffffc02003c8 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200400:	6582                	ld	a1,0(sp)
ffffffffc0200402:	00002517          	auipc	a0,0x2
ffffffffc0200406:	84e50513          	addi	a0,a0,-1970 # ffffffffc0201c50 <etext+0x260>
ffffffffc020040a:	cb1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    return 0;
ffffffffc020040e:	b715                	j	ffffffffc0200332 <kmonitor+0x6a>

ffffffffc0200410 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200410:	1141                	addi	sp,sp,-16
ffffffffc0200412:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc0200414:	02000793          	li	a5,32
ffffffffc0200418:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020041c:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200420:	67e1                	lui	a5,0x18
ffffffffc0200422:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200426:	953e                	add	a0,a0,a5
ffffffffc0200428:	578010ef          	jal	ra,ffffffffc02019a0 <sbi_set_timer>
}
ffffffffc020042c:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	0207b123          	sd	zero,34(a5) # ffffffffc0206450 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	87a50513          	addi	a0,a0,-1926 # ffffffffc0201cb0 <commands+0x48>
}
ffffffffc020043e:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200442:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	5520106f          	j	ffffffffc02019a0 <sbi_set_timer>

ffffffffc0200452 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200454:	0ff57513          	zext.b	a0,a0
ffffffffc0200458:	52e0106f          	j	ffffffffc0201986 <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc020045c:	55e0106f          	j	ffffffffc02019ba <sbi_console_getchar>

ffffffffc0200460 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200460:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200464:	8082                	ret

ffffffffc0200466 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200466:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020046a:	8082                	ret

ffffffffc020046c <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020046c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200470:	00000797          	auipc	a5,0x0
ffffffffc0200474:	39078793          	addi	a5,a5,912 # ffffffffc0200800 <__alltraps>
ffffffffc0200478:	10579073          	csrw	stvec,a5
}
ffffffffc020047c:	8082                	ret

ffffffffc020047e <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020047e:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200480:	1141                	addi	sp,sp,-16
ffffffffc0200482:	e022                	sd	s0,0(sp)
ffffffffc0200484:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200486:	00002517          	auipc	a0,0x2
ffffffffc020048a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201cd0 <commands+0x68>
void print_regs(struct pushregs *gpr) {
ffffffffc020048e:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00002517          	auipc	a0,0x2
ffffffffc020049a:	85250513          	addi	a0,a0,-1966 # ffffffffc0201ce8 <commands+0x80>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	85c50513          	addi	a0,a0,-1956 # ffffffffc0201d00 <commands+0x98>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	86650513          	addi	a0,a0,-1946 # ffffffffc0201d18 <commands+0xb0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	87050513          	addi	a0,a0,-1936 # ffffffffc0201d30 <commands+0xc8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00002517          	auipc	a0,0x2
ffffffffc02004d2:	87a50513          	addi	a0,a0,-1926 # ffffffffc0201d48 <commands+0xe0>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00002517          	auipc	a0,0x2
ffffffffc02004e0:	88450513          	addi	a0,a0,-1916 # ffffffffc0201d60 <commands+0xf8>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00002517          	auipc	a0,0x2
ffffffffc02004ee:	88e50513          	addi	a0,a0,-1906 # ffffffffc0201d78 <commands+0x110>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00002517          	auipc	a0,0x2
ffffffffc02004fc:	89850513          	addi	a0,a0,-1896 # ffffffffc0201d90 <commands+0x128>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00002517          	auipc	a0,0x2
ffffffffc020050a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201da8 <commands+0x140>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00002517          	auipc	a0,0x2
ffffffffc0200518:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0201dc0 <commands+0x158>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00002517          	auipc	a0,0x2
ffffffffc0200526:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201dd8 <commands+0x170>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00002517          	auipc	a0,0x2
ffffffffc0200534:	8c050513          	addi	a0,a0,-1856 # ffffffffc0201df0 <commands+0x188>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00002517          	auipc	a0,0x2
ffffffffc0200542:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201e08 <commands+0x1a0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00002517          	auipc	a0,0x2
ffffffffc0200550:	8d450513          	addi	a0,a0,-1836 # ffffffffc0201e20 <commands+0x1b8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00002517          	auipc	a0,0x2
ffffffffc020055e:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201e38 <commands+0x1d0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00002517          	auipc	a0,0x2
ffffffffc020056c:	8e850513          	addi	a0,a0,-1816 # ffffffffc0201e50 <commands+0x1e8>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	8f250513          	addi	a0,a0,-1806 # ffffffffc0201e68 <commands+0x200>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0201e80 <commands+0x218>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00002517          	auipc	a0,0x2
ffffffffc0200596:	90650513          	addi	a0,a0,-1786 # ffffffffc0201e98 <commands+0x230>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00002517          	auipc	a0,0x2
ffffffffc02005a4:	91050513          	addi	a0,a0,-1776 # ffffffffc0201eb0 <commands+0x248>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00002517          	auipc	a0,0x2
ffffffffc02005b2:	91a50513          	addi	a0,a0,-1766 # ffffffffc0201ec8 <commands+0x260>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00002517          	auipc	a0,0x2
ffffffffc02005c0:	92450513          	addi	a0,a0,-1756 # ffffffffc0201ee0 <commands+0x278>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00002517          	auipc	a0,0x2
ffffffffc02005ce:	92e50513          	addi	a0,a0,-1746 # ffffffffc0201ef8 <commands+0x290>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00002517          	auipc	a0,0x2
ffffffffc02005dc:	93850513          	addi	a0,a0,-1736 # ffffffffc0201f10 <commands+0x2a8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	94250513          	addi	a0,a0,-1726 # ffffffffc0201f28 <commands+0x2c0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00002517          	auipc	a0,0x2
ffffffffc02005f8:	94c50513          	addi	a0,a0,-1716 # ffffffffc0201f40 <commands+0x2d8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00002517          	auipc	a0,0x2
ffffffffc0200606:	95650513          	addi	a0,a0,-1706 # ffffffffc0201f58 <commands+0x2f0>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	96050513          	addi	a0,a0,-1696 # ffffffffc0201f70 <commands+0x308>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201f88 <commands+0x320>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00002517          	auipc	a0,0x2
ffffffffc0200630:	97450513          	addi	a0,a0,-1676 # ffffffffc0201fa0 <commands+0x338>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
}
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	97a50513          	addi	a0,a0,-1670 # ffffffffc0201fb8 <commands+0x350>
}
ffffffffc0200646:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020064e:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200650:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	97e50513          	addi	a0,a0,-1666 # ffffffffc0201fd0 <commands+0x368>
void print_trapframe(struct trapframe *tf) {
ffffffffc020065a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00002517          	auipc	a0,0x2
ffffffffc020066e:	97e50513          	addi	a0,a0,-1666 # ffffffffc0201fe8 <commands+0x380>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	98650513          	addi	a0,a0,-1658 # ffffffffc0202000 <commands+0x398>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00002517          	auipc	a0,0x2
ffffffffc020068e:	98e50513          	addi	a0,a0,-1650 # ffffffffc0202018 <commands+0x3b0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	11843583          	ld	a1,280(s0)
}
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020069e:	00002517          	auipc	a0,0x2
ffffffffc02006a2:	99250513          	addi	a0,a0,-1646 # ffffffffc0202030 <commands+0x3c8>
}
ffffffffc02006a6:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	08f76663          	bltu	a4,a5,ffffffffc0200740 <interrupt_handler+0x96>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	a5870713          	addi	a4,a4,-1448 # ffffffffc0202110 <commands+0x4a8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	9de50513          	addi	a0,a0,-1570 # ffffffffc02020a8 <commands+0x440>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	9b450513          	addi	a0,a0,-1612 # ffffffffc0202088 <commands+0x420>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006de:	00002517          	auipc	a0,0x2
ffffffffc02006e2:	96a50513          	addi	a0,a0,-1686 # ffffffffc0202048 <commands+0x3e0>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e8:	00002517          	auipc	a0,0x2
ffffffffc02006ec:	9e050513          	addi	a0,a0,-1568 # ffffffffc02020c8 <commands+0x460>
ffffffffc02006f0:	b2e9                	j	ffffffffc02000ba <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02006f2:	1141                	addi	sp,sp,-16
ffffffffc02006f4:	e022                	sd	s0,0(sp)
ffffffffc02006f6:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02006f8:	d4bff0ef          	jal	ra,ffffffffc0200442 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02006fc:	00006697          	auipc	a3,0x6
ffffffffc0200700:	d5468693          	addi	a3,a3,-684 # ffffffffc0206450 <ticks>
ffffffffc0200704:	629c                	ld	a5,0(a3)
ffffffffc0200706:	06400713          	li	a4,100
ffffffffc020070a:	00006417          	auipc	s0,0x6
ffffffffc020070e:	d4e40413          	addi	s0,s0,-690 # ffffffffc0206458 <num>
ffffffffc0200712:	0785                	addi	a5,a5,1
ffffffffc0200714:	02e7f733          	remu	a4,a5,a4
ffffffffc0200718:	e29c                	sd	a5,0(a3)
ffffffffc020071a:	c705                	beqz	a4,ffffffffc0200742 <interrupt_handler+0x98>
                print_ticks();
                ticks = 0;
                ++num;
            }
            if(num == 10){
ffffffffc020071c:	6018                	ld	a4,0(s0)
ffffffffc020071e:	47a9                	li	a5,10
ffffffffc0200720:	04f70163          	beq	a4,a5,ffffffffc0200762 <interrupt_handler+0xb8>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200724:	60a2                	ld	ra,8(sp)
ffffffffc0200726:	6402                	ld	s0,0(sp)
ffffffffc0200728:	0141                	addi	sp,sp,16
ffffffffc020072a:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	9c450513          	addi	a0,a0,-1596 # ffffffffc02020f0 <commands+0x488>
ffffffffc0200734:	b259                	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200736:	00002517          	auipc	a0,0x2
ffffffffc020073a:	93250513          	addi	a0,a0,-1742 # ffffffffc0202068 <commands+0x400>
ffffffffc020073e:	bab5                	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc0200740:	b729                	j	ffffffffc020064a <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	99a50513          	addi	a0,a0,-1638 # ffffffffc02020e0 <commands+0x478>
ffffffffc020074e:	96dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
                ticks = 0;
ffffffffc0200752:	00006797          	auipc	a5,0x6
ffffffffc0200756:	ce07bf23          	sd	zero,-770(a5) # ffffffffc0206450 <ticks>
                ++num;
ffffffffc020075a:	601c                	ld	a5,0(s0)
ffffffffc020075c:	0785                	addi	a5,a5,1
ffffffffc020075e:	e01c                	sd	a5,0(s0)
ffffffffc0200760:	bf75                	j	ffffffffc020071c <interrupt_handler+0x72>
}
ffffffffc0200762:	6402                	ld	s0,0(sp)
ffffffffc0200764:	60a2                	ld	ra,8(sp)
ffffffffc0200766:	0141                	addi	sp,sp,16
                sbi_shutdown();
ffffffffc0200768:	26e0106f          	j	ffffffffc02019d6 <sbi_shutdown>

ffffffffc020076c <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc020076c:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200770:	1141                	addi	sp,sp,-16
ffffffffc0200772:	e022                	sd	s0,0(sp)
ffffffffc0200774:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200776:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200778:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc020077a:	04e78663          	beq	a5,a4,ffffffffc02007c6 <exception_handler+0x5a>
ffffffffc020077e:	02f76c63          	bltu	a4,a5,ffffffffc02007b6 <exception_handler+0x4a>
ffffffffc0200782:	4709                	li	a4,2
ffffffffc0200784:	02e79563          	bne	a5,a4,ffffffffc02007ae <exception_handler+0x42>
            break;
        case CAUSE_FAULT_FETCH:
            break;
        case CAUSE_ILLEGAL_INSTRUCTION:
            // 非法指令异常处理
            cprintf("exception type:Illegal instruction\n");
ffffffffc0200788:	00002517          	auipc	a0,0x2
ffffffffc020078c:	9b850513          	addi	a0,a0,-1608 # ffffffffc0202140 <commands+0x4d8>
ffffffffc0200790:	92bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc0200794:	10843583          	ld	a1,264(s0)
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	9d050513          	addi	a0,a0,-1584 # ffffffffc0202168 <commands+0x500>
ffffffffc02007a0:	91bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 4;//跳过导致异常的指令
ffffffffc02007a4:	10843783          	ld	a5,264(s0)
ffffffffc02007a8:	0791                	addi	a5,a5,4
ffffffffc02007aa:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02007ae:	60a2                	ld	ra,8(sp)
ffffffffc02007b0:	6402                	ld	s0,0(sp)
ffffffffc02007b2:	0141                	addi	sp,sp,16
ffffffffc02007b4:	8082                	ret
    switch (tf->cause) {
ffffffffc02007b6:	17f1                	addi	a5,a5,-4
ffffffffc02007b8:	471d                	li	a4,7
ffffffffc02007ba:	fef77ae3          	bgeu	a4,a5,ffffffffc02007ae <exception_handler+0x42>
}
ffffffffc02007be:	6402                	ld	s0,0(sp)
ffffffffc02007c0:	60a2                	ld	ra,8(sp)
ffffffffc02007c2:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc02007c4:	b559                	j	ffffffffc020064a <print_trapframe>
            cprintf("exception type:breakpoint\n");
ffffffffc02007c6:	00002517          	auipc	a0,0x2
ffffffffc02007ca:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0202190 <commands+0x528>
ffffffffc02007ce:	8edff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
ffffffffc02007d2:	10843583          	ld	a1,264(s0)
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	99250513          	addi	a0,a0,-1646 # ffffffffc0202168 <commands+0x500>
ffffffffc02007de:	8ddff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            tf->epc += 2;//跳过导致异常的指令
ffffffffc02007e2:	10843783          	ld	a5,264(s0)
}
ffffffffc02007e6:	60a2                	ld	ra,8(sp)
            tf->epc += 2;//跳过导致异常的指令
ffffffffc02007e8:	0789                	addi	a5,a5,2
ffffffffc02007ea:	10f43423          	sd	a5,264(s0)
}
ffffffffc02007ee:	6402                	ld	s0,0(sp)
ffffffffc02007f0:	0141                	addi	sp,sp,16
ffffffffc02007f2:	8082                	ret

ffffffffc02007f4 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc02007f4:	11853783          	ld	a5,280(a0)
ffffffffc02007f8:	0007c363          	bltz	a5,ffffffffc02007fe <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc02007fc:	bf85                	j	ffffffffc020076c <exception_handler>
        interrupt_handler(tf);
ffffffffc02007fe:	b575                	j	ffffffffc02006aa <interrupt_handler>

ffffffffc0200800 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200800:	14011073          	csrw	sscratch,sp
ffffffffc0200804:	712d                	addi	sp,sp,-288
ffffffffc0200806:	e002                	sd	zero,0(sp)
ffffffffc0200808:	e406                	sd	ra,8(sp)
ffffffffc020080a:	ec0e                	sd	gp,24(sp)
ffffffffc020080c:	f012                	sd	tp,32(sp)
ffffffffc020080e:	f416                	sd	t0,40(sp)
ffffffffc0200810:	f81a                	sd	t1,48(sp)
ffffffffc0200812:	fc1e                	sd	t2,56(sp)
ffffffffc0200814:	e0a2                	sd	s0,64(sp)
ffffffffc0200816:	e4a6                	sd	s1,72(sp)
ffffffffc0200818:	e8aa                	sd	a0,80(sp)
ffffffffc020081a:	ecae                	sd	a1,88(sp)
ffffffffc020081c:	f0b2                	sd	a2,96(sp)
ffffffffc020081e:	f4b6                	sd	a3,104(sp)
ffffffffc0200820:	f8ba                	sd	a4,112(sp)
ffffffffc0200822:	fcbe                	sd	a5,120(sp)
ffffffffc0200824:	e142                	sd	a6,128(sp)
ffffffffc0200826:	e546                	sd	a7,136(sp)
ffffffffc0200828:	e94a                	sd	s2,144(sp)
ffffffffc020082a:	ed4e                	sd	s3,152(sp)
ffffffffc020082c:	f152                	sd	s4,160(sp)
ffffffffc020082e:	f556                	sd	s5,168(sp)
ffffffffc0200830:	f95a                	sd	s6,176(sp)
ffffffffc0200832:	fd5e                	sd	s7,184(sp)
ffffffffc0200834:	e1e2                	sd	s8,192(sp)
ffffffffc0200836:	e5e6                	sd	s9,200(sp)
ffffffffc0200838:	e9ea                	sd	s10,208(sp)
ffffffffc020083a:	edee                	sd	s11,216(sp)
ffffffffc020083c:	f1f2                	sd	t3,224(sp)
ffffffffc020083e:	f5f6                	sd	t4,232(sp)
ffffffffc0200840:	f9fa                	sd	t5,240(sp)
ffffffffc0200842:	fdfe                	sd	t6,248(sp)
ffffffffc0200844:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200848:	100024f3          	csrr	s1,sstatus
ffffffffc020084c:	14102973          	csrr	s2,sepc
ffffffffc0200850:	143029f3          	csrr	s3,stval
ffffffffc0200854:	14202a73          	csrr	s4,scause
ffffffffc0200858:	e822                	sd	s0,16(sp)
ffffffffc020085a:	e226                	sd	s1,256(sp)
ffffffffc020085c:	e64a                	sd	s2,264(sp)
ffffffffc020085e:	ea4e                	sd	s3,272(sp)
ffffffffc0200860:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200862:	850a                	mv	a0,sp
    jal trap
ffffffffc0200864:	f91ff0ef          	jal	ra,ffffffffc02007f4 <trap>

ffffffffc0200868 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200868:	6492                	ld	s1,256(sp)
ffffffffc020086a:	6932                	ld	s2,264(sp)
ffffffffc020086c:	10049073          	csrw	sstatus,s1
ffffffffc0200870:	14191073          	csrw	sepc,s2
ffffffffc0200874:	60a2                	ld	ra,8(sp)
ffffffffc0200876:	61e2                	ld	gp,24(sp)
ffffffffc0200878:	7202                	ld	tp,32(sp)
ffffffffc020087a:	72a2                	ld	t0,40(sp)
ffffffffc020087c:	7342                	ld	t1,48(sp)
ffffffffc020087e:	73e2                	ld	t2,56(sp)
ffffffffc0200880:	6406                	ld	s0,64(sp)
ffffffffc0200882:	64a6                	ld	s1,72(sp)
ffffffffc0200884:	6546                	ld	a0,80(sp)
ffffffffc0200886:	65e6                	ld	a1,88(sp)
ffffffffc0200888:	7606                	ld	a2,96(sp)
ffffffffc020088a:	76a6                	ld	a3,104(sp)
ffffffffc020088c:	7746                	ld	a4,112(sp)
ffffffffc020088e:	77e6                	ld	a5,120(sp)
ffffffffc0200890:	680a                	ld	a6,128(sp)
ffffffffc0200892:	68aa                	ld	a7,136(sp)
ffffffffc0200894:	694a                	ld	s2,144(sp)
ffffffffc0200896:	69ea                	ld	s3,152(sp)
ffffffffc0200898:	7a0a                	ld	s4,160(sp)
ffffffffc020089a:	7aaa                	ld	s5,168(sp)
ffffffffc020089c:	7b4a                	ld	s6,176(sp)
ffffffffc020089e:	7bea                	ld	s7,184(sp)
ffffffffc02008a0:	6c0e                	ld	s8,192(sp)
ffffffffc02008a2:	6cae                	ld	s9,200(sp)
ffffffffc02008a4:	6d4e                	ld	s10,208(sp)
ffffffffc02008a6:	6dee                	ld	s11,216(sp)
ffffffffc02008a8:	7e0e                	ld	t3,224(sp)
ffffffffc02008aa:	7eae                	ld	t4,232(sp)
ffffffffc02008ac:	7f4e                	ld	t5,240(sp)
ffffffffc02008ae:	7fee                	ld	t6,248(sp)
ffffffffc02008b0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02008b2:	10200073          	sret

ffffffffc02008b6 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008b6:	100027f3          	csrr	a5,sstatus
ffffffffc02008ba:	8b89                	andi	a5,a5,2
ffffffffc02008bc:	e799                	bnez	a5,ffffffffc02008ca <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02008be:	00006797          	auipc	a5,0x6
ffffffffc02008c2:	bb27b783          	ld	a5,-1102(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc02008c6:	6f9c                	ld	a5,24(a5)
ffffffffc02008c8:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02008ca:	1141                	addi	sp,sp,-16
ffffffffc02008cc:	e406                	sd	ra,8(sp)
ffffffffc02008ce:	e022                	sd	s0,0(sp)
ffffffffc02008d0:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02008d2:	b95ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02008d6:	00006797          	auipc	a5,0x6
ffffffffc02008da:	b9a7b783          	ld	a5,-1126(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc02008de:	6f9c                	ld	a5,24(a5)
ffffffffc02008e0:	8522                	mv	a0,s0
ffffffffc02008e2:	9782                	jalr	a5
ffffffffc02008e4:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02008e6:	b7bff0ef          	jal	ra,ffffffffc0200460 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02008ea:	60a2                	ld	ra,8(sp)
ffffffffc02008ec:	8522                	mv	a0,s0
ffffffffc02008ee:	6402                	ld	s0,0(sp)
ffffffffc02008f0:	0141                	addi	sp,sp,16
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008f4:	100027f3          	csrr	a5,sstatus
ffffffffc02008f8:	8b89                	andi	a5,a5,2
ffffffffc02008fa:	e799                	bnez	a5,ffffffffc0200908 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02008fc:	00006797          	auipc	a5,0x6
ffffffffc0200900:	b747b783          	ld	a5,-1164(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc0200904:	739c                	ld	a5,32(a5)
ffffffffc0200906:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0200908:	1101                	addi	sp,sp,-32
ffffffffc020090a:	ec06                	sd	ra,24(sp)
ffffffffc020090c:	e822                	sd	s0,16(sp)
ffffffffc020090e:	e426                	sd	s1,8(sp)
ffffffffc0200910:	842a                	mv	s0,a0
ffffffffc0200912:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200914:	b53ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200918:	00006797          	auipc	a5,0x6
ffffffffc020091c:	b587b783          	ld	a5,-1192(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc0200920:	739c                	ld	a5,32(a5)
ffffffffc0200922:	85a6                	mv	a1,s1
ffffffffc0200924:	8522                	mv	a0,s0
ffffffffc0200926:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200928:	6442                	ld	s0,16(sp)
ffffffffc020092a:	60e2                	ld	ra,24(sp)
ffffffffc020092c:	64a2                	ld	s1,8(sp)
ffffffffc020092e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200930:	be05                	j	ffffffffc0200460 <intr_enable>

ffffffffc0200932 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200932:	00002797          	auipc	a5,0x2
ffffffffc0200936:	c4e78793          	addi	a5,a5,-946 # ffffffffc0202580 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020093a:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020093c:	1101                	addi	sp,sp,-32
ffffffffc020093e:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200940:	00002517          	auipc	a0,0x2
ffffffffc0200944:	87050513          	addi	a0,a0,-1936 # ffffffffc02021b0 <commands+0x548>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200948:	00006497          	auipc	s1,0x6
ffffffffc020094c:	b2848493          	addi	s1,s1,-1240 # ffffffffc0206470 <pmm_manager>
void pmm_init(void) {
ffffffffc0200950:	ec06                	sd	ra,24(sp)
ffffffffc0200952:	e822                	sd	s0,16(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200954:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200956:	f64ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc020095a:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020095c:	00006417          	auipc	s0,0x6
ffffffffc0200960:	b2c40413          	addi	s0,s0,-1236 # ffffffffc0206488 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200964:	679c                	ld	a5,8(a5)
ffffffffc0200966:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200968:	57f5                	li	a5,-3
ffffffffc020096a:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc020096c:	00002517          	auipc	a0,0x2
ffffffffc0200970:	85c50513          	addi	a0,a0,-1956 # ffffffffc02021c8 <commands+0x560>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200974:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc0200976:	f44ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc020097a:	46c5                	li	a3,17
ffffffffc020097c:	06ee                	slli	a3,a3,0x1b
ffffffffc020097e:	40100613          	li	a2,1025
ffffffffc0200982:	16fd                	addi	a3,a3,-1
ffffffffc0200984:	07e005b7          	lui	a1,0x7e00
ffffffffc0200988:	0656                	slli	a2,a2,0x15
ffffffffc020098a:	00002517          	auipc	a0,0x2
ffffffffc020098e:	85650513          	addi	a0,a0,-1962 # ffffffffc02021e0 <commands+0x578>
ffffffffc0200992:	f28ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200996:	777d                	lui	a4,0xfffff
ffffffffc0200998:	00007797          	auipc	a5,0x7
ffffffffc020099c:	b1f78793          	addi	a5,a5,-1249 # ffffffffc02074b7 <end+0xfff>
ffffffffc02009a0:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc02009a2:	00006517          	auipc	a0,0x6
ffffffffc02009a6:	abe50513          	addi	a0,a0,-1346 # ffffffffc0206460 <npage>
ffffffffc02009aa:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009ae:	00006597          	auipc	a1,0x6
ffffffffc02009b2:	aba58593          	addi	a1,a1,-1350 # ffffffffc0206468 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02009b6:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009b8:	e19c                	sd	a5,0(a1)
ffffffffc02009ba:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02009bc:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02009be:	4885                	li	a7,1
ffffffffc02009c0:	fff80837          	lui	a6,0xfff80
ffffffffc02009c4:	a011                	j	ffffffffc02009c8 <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc02009c6:	619c                	ld	a5,0(a1)
ffffffffc02009c8:	97b6                	add	a5,a5,a3
ffffffffc02009ca:	07a1                	addi	a5,a5,8
ffffffffc02009cc:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02009d0:	611c                	ld	a5,0(a0)
ffffffffc02009d2:	0705                	addi	a4,a4,1
ffffffffc02009d4:	02868693          	addi	a3,a3,40
ffffffffc02009d8:	01078633          	add	a2,a5,a6
ffffffffc02009dc:	fec765e3          	bltu	a4,a2,ffffffffc02009c6 <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02009e0:	6190                	ld	a2,0(a1)
ffffffffc02009e2:	00279713          	slli	a4,a5,0x2
ffffffffc02009e6:	973e                	add	a4,a4,a5
ffffffffc02009e8:	fec006b7          	lui	a3,0xfec00
ffffffffc02009ec:	070e                	slli	a4,a4,0x3
ffffffffc02009ee:	96b2                	add	a3,a3,a2
ffffffffc02009f0:	96ba                	add	a3,a3,a4
ffffffffc02009f2:	c0200737          	lui	a4,0xc0200
ffffffffc02009f6:	08e6ef63          	bltu	a3,a4,ffffffffc0200a94 <pmm_init+0x162>
ffffffffc02009fa:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc02009fc:	45c5                	li	a1,17
ffffffffc02009fe:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a00:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200a02:	04b6e863          	bltu	a3,a1,ffffffffc0200a52 <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200a06:	609c                	ld	a5,0(s1)
ffffffffc0200a08:	7b9c                	ld	a5,48(a5)
ffffffffc0200a0a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200a0c:	00002517          	auipc	a0,0x2
ffffffffc0200a10:	86c50513          	addi	a0,a0,-1940 # ffffffffc0202278 <commands+0x610>
ffffffffc0200a14:	ea6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200a18:	00004597          	auipc	a1,0x4
ffffffffc0200a1c:	5e858593          	addi	a1,a1,1512 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200a20:	00006797          	auipc	a5,0x6
ffffffffc0200a24:	a6b7b023          	sd	a1,-1440(a5) # ffffffffc0206480 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a28:	c02007b7          	lui	a5,0xc0200
ffffffffc0200a2c:	08f5e063          	bltu	a1,a5,ffffffffc0200aac <pmm_init+0x17a>
ffffffffc0200a30:	6010                	ld	a2,0(s0)
}
ffffffffc0200a32:	6442                	ld	s0,16(sp)
ffffffffc0200a34:	60e2                	ld	ra,24(sp)
ffffffffc0200a36:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a38:	40c58633          	sub	a2,a1,a2
ffffffffc0200a3c:	00006797          	auipc	a5,0x6
ffffffffc0200a40:	a2c7be23          	sd	a2,-1476(a5) # ffffffffc0206478 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a44:	00002517          	auipc	a0,0x2
ffffffffc0200a48:	85450513          	addi	a0,a0,-1964 # ffffffffc0202298 <commands+0x630>
}
ffffffffc0200a4c:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a4e:	e6cff06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200a52:	6705                	lui	a4,0x1
ffffffffc0200a54:	177d                	addi	a4,a4,-1
ffffffffc0200a56:	96ba                	add	a3,a3,a4
ffffffffc0200a58:	777d                	lui	a4,0xfffff
ffffffffc0200a5a:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200a5c:	00c6d513          	srli	a0,a3,0xc
ffffffffc0200a60:	00f57e63          	bgeu	a0,a5,ffffffffc0200a7c <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc0200a64:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200a66:	982a                	add	a6,a6,a0
ffffffffc0200a68:	00281513          	slli	a0,a6,0x2
ffffffffc0200a6c:	9542                	add	a0,a0,a6
ffffffffc0200a6e:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200a70:	8d95                	sub	a1,a1,a3
ffffffffc0200a72:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200a74:	81b1                	srli	a1,a1,0xc
ffffffffc0200a76:	9532                	add	a0,a0,a2
ffffffffc0200a78:	9782                	jalr	a5
}
ffffffffc0200a7a:	b771                	j	ffffffffc0200a06 <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0200a7c:	00001617          	auipc	a2,0x1
ffffffffc0200a80:	7cc60613          	addi	a2,a2,1996 # ffffffffc0202248 <commands+0x5e0>
ffffffffc0200a84:	06b00593          	li	a1,107
ffffffffc0200a88:	00001517          	auipc	a0,0x1
ffffffffc0200a8c:	7e050513          	addi	a0,a0,2016 # ffffffffc0202268 <commands+0x600>
ffffffffc0200a90:	eb2ff0ef          	jal	ra,ffffffffc0200142 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a94:	00001617          	auipc	a2,0x1
ffffffffc0200a98:	77c60613          	addi	a2,a2,1916 # ffffffffc0202210 <commands+0x5a8>
ffffffffc0200a9c:	07200593          	li	a1,114
ffffffffc0200aa0:	00001517          	auipc	a0,0x1
ffffffffc0200aa4:	79850513          	addi	a0,a0,1944 # ffffffffc0202238 <commands+0x5d0>
ffffffffc0200aa8:	e9aff0ef          	jal	ra,ffffffffc0200142 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200aac:	86ae                	mv	a3,a1
ffffffffc0200aae:	00001617          	auipc	a2,0x1
ffffffffc0200ab2:	76260613          	addi	a2,a2,1890 # ffffffffc0202210 <commands+0x5a8>
ffffffffc0200ab6:	08d00593          	li	a1,141
ffffffffc0200aba:	00001517          	auipc	a0,0x1
ffffffffc0200abe:	77e50513          	addi	a0,a0,1918 # ffffffffc0202238 <commands+0x5d0>
ffffffffc0200ac2:	e80ff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200ac6 <obj_free>:
// 将一个size大小的新块加入链表
static void obj_free(void *block, int size)
{
	obj_t *cur, *b = (obj_t *)block;

	if (!block)
ffffffffc0200ac6:	cd1d                	beqz	a0,ffffffffc0200b04 <obj_free+0x3e>
		return;

	if (size)
ffffffffc0200ac8:	ed9d                	bnez	a1,ffffffffc0200b06 <obj_free+0x40>
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->objsize == cur->next) {
ffffffffc0200aca:	4114                	lw	a3,0(a0)
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0200acc:	00005597          	auipc	a1,0x5
ffffffffc0200ad0:	54458593          	addi	a1,a1,1348 # ffffffffc0206010 <objfree>
ffffffffc0200ad4:	619c                	ld	a5,0(a1)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0200ad6:	873e                	mv	a4,a5
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0200ad8:	679c                	ld	a5,8(a5)
ffffffffc0200ada:	02a77b63          	bgeu	a4,a0,ffffffffc0200b10 <obj_free+0x4a>
ffffffffc0200ade:	00f56463          	bltu	a0,a5,ffffffffc0200ae6 <obj_free+0x20>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0200ae2:	fef76ae3          	bltu	a4,a5,ffffffffc0200ad6 <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc0200ae6:	00469613          	slli	a2,a3,0x4
ffffffffc0200aea:	962a                	add	a2,a2,a0
ffffffffc0200aec:	02c78b63          	beq	a5,a2,ffffffffc0200b22 <obj_free+0x5c>
		b->objsize += cur->next->objsize;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->objsize == b) {
ffffffffc0200af0:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0200af2:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc0200af4:	00469793          	slli	a5,a3,0x4
ffffffffc0200af8:	97ba                	add	a5,a5,a4
ffffffffc0200afa:	02f50f63          	beq	a0,a5,ffffffffc0200b38 <obj_free+0x72>
		cur->objsize += b->objsize;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
ffffffffc0200afe:	e708                	sd	a0,8(a4)
    
    // 更新空闲块位置
	objfree = cur;
ffffffffc0200b00:	e198                	sd	a4,0(a1)
ffffffffc0200b02:	8082                	ret
}
ffffffffc0200b04:	8082                	ret
		b->objsize = OBJ_UNITS(size);  
ffffffffc0200b06:	00f5869b          	addiw	a3,a1,15
ffffffffc0200b0a:	8691                	srai	a3,a3,0x4
ffffffffc0200b0c:	c114                	sw	a3,0(a0)
ffffffffc0200b0e:	bf7d                	j	ffffffffc0200acc <obj_free+0x6>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0200b10:	fcf763e3          	bltu	a4,a5,ffffffffc0200ad6 <obj_free+0x10>
ffffffffc0200b14:	fcf571e3          	bgeu	a0,a5,ffffffffc0200ad6 <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc0200b18:	00469613          	slli	a2,a3,0x4
ffffffffc0200b1c:	962a                	add	a2,a2,a0
ffffffffc0200b1e:	fcc799e3          	bne	a5,a2,ffffffffc0200af0 <obj_free+0x2a>
		b->objsize += cur->next->objsize;
ffffffffc0200b22:	4390                	lw	a2,0(a5)
		b->next = cur->next->next;
ffffffffc0200b24:	679c                	ld	a5,8(a5)
		b->objsize += cur->next->objsize;
ffffffffc0200b26:	9eb1                	addw	a3,a3,a2
ffffffffc0200b28:	c114                	sw	a3,0(a0)
	if (cur + cur->objsize == b) {
ffffffffc0200b2a:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0200b2c:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc0200b2e:	00469793          	slli	a5,a3,0x4
ffffffffc0200b32:	97ba                	add	a5,a5,a4
ffffffffc0200b34:	fcf515e3          	bne	a0,a5,ffffffffc0200afe <obj_free+0x38>
		cur->objsize += b->objsize;
ffffffffc0200b38:	411c                	lw	a5,0(a0)
		cur->next = b->next;
ffffffffc0200b3a:	6510                	ld	a2,8(a0)
	objfree = cur;
ffffffffc0200b3c:	e198                	sd	a4,0(a1)
		cur->objsize += b->objsize;
ffffffffc0200b3e:	9ebd                	addw	a3,a3,a5
ffffffffc0200b40:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0200b42:	e710                	sd	a2,8(a4)
	objfree = cur;
ffffffffc0200b44:	8082                	ret

ffffffffc0200b46 <obj_alloc>:

// 小块分配(传入size是算上头部obj_t的)
static void *obj_alloc(size_t size)
{
ffffffffc0200b46:	1101                	addi	sp,sp,-32
ffffffffc0200b48:	ec06                	sd	ra,24(sp)
ffffffffc0200b4a:	e822                	sd	s0,16(sp)
ffffffffc0200b4c:	e426                	sd	s1,8(sp)
ffffffffc0200b4e:	e04a                	sd	s2,0(sp)
	assert(size < PGSIZE);
ffffffffc0200b50:	6785                	lui	a5,0x1
ffffffffc0200b52:	08f57363          	bgeu	a0,a5,ffffffffc0200bd8 <obj_alloc+0x92>

	obj_t *prev, *cur;
	int objsize = OBJ_UNITS(size);

	prev = objfree;  // 从头遍历小块链表
ffffffffc0200b56:	00005417          	auipc	s0,0x5
ffffffffc0200b5a:	4ba40413          	addi	s0,s0,1210 # ffffffffc0206010 <objfree>
ffffffffc0200b5e:	6010                	ld	a2,0(s0)
	int objsize = OBJ_UNITS(size);
ffffffffc0200b60:	053d                	addi	a0,a0,15
ffffffffc0200b62:	00455913          	srli	s2,a0,0x4
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0200b66:	6618                	ld	a4,8(a2)
	int objsize = OBJ_UNITS(size);
ffffffffc0200b68:	0009049b          	sext.w	s1,s2
		
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0200b6c:	4314                	lw	a3,0(a4)
ffffffffc0200b6e:	0696d263          	bge	a3,s1,ffffffffc0200bd2 <obj_alloc+0x8c>
			}
			objfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc0200b72:	00e60a63          	beq	a2,a4,ffffffffc0200b86 <obj_alloc+0x40>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0200b76:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0200b78:	4394                	lw	a3,0(a5)
ffffffffc0200b7a:	0296d363          	bge	a3,s1,ffffffffc0200ba0 <obj_alloc+0x5a>
		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc0200b7e:	6010                	ld	a2,0(s0)
ffffffffc0200b80:	873e                	mv	a4,a5
ffffffffc0200b82:	fee61ae3          	bne	a2,a4,ffffffffc0200b76 <obj_alloc+0x30>

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (obj_t *)alloc_pages(1);  
ffffffffc0200b86:	4505                	li	a0,1
ffffffffc0200b88:	d2fff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc0200b8c:	87aa                	mv	a5,a0
			if (!cur)  // 如果获取失败，返回 0
ffffffffc0200b8e:	c51d                	beqz	a0,ffffffffc0200bbc <obj_alloc+0x76>
				return 0;

			obj_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
ffffffffc0200b90:	6585                	lui	a1,0x1
ffffffffc0200b92:	f35ff0ef          	jal	ra,ffffffffc0200ac6 <obj_free>
			cur = objfree;  // 从新分配的页前一个块再次循环
ffffffffc0200b96:	6018                	ld	a4,0(s0)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0200b98:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0200b9a:	4394                	lw	a3,0(a5)
ffffffffc0200b9c:	fe96c1e3          	blt	a3,s1,ffffffffc0200b7e <obj_alloc+0x38>
			if (cur->objsize == objsize)
ffffffffc0200ba0:	02d48563          	beq	s1,a3,ffffffffc0200bca <obj_alloc+0x84>
				prev->next = cur + objsize;  
ffffffffc0200ba4:	0912                	slli	s2,s2,0x4
ffffffffc0200ba6:	993e                	add	s2,s2,a5
ffffffffc0200ba8:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8b50>
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc0200bac:	6790                	ld	a2,8(a5)
				prev->next->objsize = cur->objsize - objsize;
ffffffffc0200bae:	9e85                	subw	a3,a3,s1
ffffffffc0200bb0:	00d92023          	sw	a3,0(s2)
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc0200bb4:	00c93423          	sd	a2,8(s2)
				cur->objsize = objsize;  // units大小的块被取出
ffffffffc0200bb8:	c384                	sw	s1,0(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0200bba:	e018                	sd	a4,0(s0)
		}
	}
}
ffffffffc0200bbc:	60e2                	ld	ra,24(sp)
ffffffffc0200bbe:	6442                	ld	s0,16(sp)
ffffffffc0200bc0:	64a2                	ld	s1,8(sp)
ffffffffc0200bc2:	6902                	ld	s2,0(sp)
ffffffffc0200bc4:	853e                	mv	a0,a5
ffffffffc0200bc6:	6105                	addi	sp,sp,32
ffffffffc0200bc8:	8082                	ret
				prev->next = cur->next;
ffffffffc0200bca:	6794                	ld	a3,8(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0200bcc:	e018                	sd	a4,0(s0)
				prev->next = cur->next;
ffffffffc0200bce:	e714                	sd	a3,8(a4)
			return cur;
ffffffffc0200bd0:	b7f5                	j	ffffffffc0200bbc <obj_alloc+0x76>
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0200bd2:	87ba                	mv	a5,a4
ffffffffc0200bd4:	8732                	mv	a4,a2
ffffffffc0200bd6:	b7e9                	j	ffffffffc0200ba0 <obj_alloc+0x5a>
	assert(size < PGSIZE);
ffffffffc0200bd8:	00001697          	auipc	a3,0x1
ffffffffc0200bdc:	70068693          	addi	a3,a3,1792 # ffffffffc02022d8 <commands+0x670>
ffffffffc0200be0:	00001617          	auipc	a2,0x1
ffffffffc0200be4:	70860613          	addi	a2,a2,1800 # ffffffffc02022e8 <commands+0x680>
ffffffffc0200be8:	04a00593          	li	a1,74
ffffffffc0200bec:	00001517          	auipc	a0,0x1
ffffffffc0200bf0:	71450513          	addi	a0,a0,1812 # ffffffffc0202300 <commands+0x698>
ffffffffc0200bf4:	d4eff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200bf8 <slub_alloc.part.0>:
		order++;
	return order;
}

// 总slub分配算法(传入申请的大小)
void *slub_alloc(size_t size)
ffffffffc0200bf8:	1101                	addi	sp,sp,-32
ffffffffc0200bfa:	e822                	sd	s0,16(sp)
ffffffffc0200bfc:	842a                	mv	s0,a0
		m = obj_alloc(size + OBJ_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc0200bfe:	02000513          	li	a0,32
void *slub_alloc(size_t size)
ffffffffc0200c02:	ec06                	sd	ra,24(sp)
ffffffffc0200c04:	e426                	sd	s1,8(sp)
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc0200c06:	f41ff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
	if (!bb)
ffffffffc0200c0a:	cd05                	beqz	a0,ffffffffc0200c42 <slub_alloc.part.0+0x4a>
		return 0;
    
    // 分配大页
	bb->order = ((size - 1) >> PGSHIFT) + 1;  // PGSHIFT为12，向右移12位的效果相当于除以2^12即4096）
ffffffffc0200c0c:	fff40793          	addi	a5,s0,-1
ffffffffc0200c10:	83b1                	srli	a5,a5,0xc
ffffffffc0200c12:	84aa                	mv	s1,a0
ffffffffc0200c14:	0017851b          	addiw	a0,a5,1
ffffffffc0200c18:	c088                	sw	a0,0(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc0200c1a:	c9dff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    
	// 设置大块标志
    bb->is_bigblock = 1;
ffffffffc0200c1e:	4785                	li	a5,1
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc0200c20:	e488                	sd	a0,8(s1)
    bb->is_bigblock = 1;
ffffffffc0200c22:	cc9c                	sw	a5,24(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc0200c24:	842a                	mv	s0,a0
    
	// 分配成功，将其插入到大块链表的头部。
	if (bb->pages) {
ffffffffc0200c26:	c50d                	beqz	a0,ffffffffc0200c50 <slub_alloc.part.0+0x58>
		bb->next = bigblocks_head;
ffffffffc0200c28:	00006797          	auipc	a5,0x6
ffffffffc0200c2c:	86878793          	addi	a5,a5,-1944 # ffffffffc0206490 <bigblocks_head>
ffffffffc0200c30:	6398                	ld	a4,0(a5)
	}
    
    // 如果页分配失败，释放之前为bigblock_t结构体分配的内存。返回0。
	obj_free(bb, sizeof(bigblock_t));
	return 0;
}
ffffffffc0200c32:	60e2                	ld	ra,24(sp)
ffffffffc0200c34:	8522                	mv	a0,s0
ffffffffc0200c36:	6442                	ld	s0,16(sp)
		bigblocks_head = bb;
ffffffffc0200c38:	e384                	sd	s1,0(a5)
		bb->next = bigblocks_head;
ffffffffc0200c3a:	e898                	sd	a4,16(s1)
}
ffffffffc0200c3c:	64a2                	ld	s1,8(sp)
ffffffffc0200c3e:	6105                	addi	sp,sp,32
ffffffffc0200c40:	8082                	ret
		return 0;
ffffffffc0200c42:	4401                	li	s0,0
}
ffffffffc0200c44:	60e2                	ld	ra,24(sp)
ffffffffc0200c46:	8522                	mv	a0,s0
ffffffffc0200c48:	6442                	ld	s0,16(sp)
ffffffffc0200c4a:	64a2                	ld	s1,8(sp)
ffffffffc0200c4c:	6105                	addi	sp,sp,32
ffffffffc0200c4e:	8082                	ret
	obj_free(bb, sizeof(bigblock_t));
ffffffffc0200c50:	8526                	mv	a0,s1
ffffffffc0200c52:	02000593          	li	a1,32
ffffffffc0200c56:	e71ff0ef          	jal	ra,ffffffffc0200ac6 <obj_free>
}
ffffffffc0200c5a:	60e2                	ld	ra,24(sp)
ffffffffc0200c5c:	8522                	mv	a0,s0
ffffffffc0200c5e:	6442                	ld	s0,16(sp)
ffffffffc0200c60:	64a2                	ld	s1,8(sp)
ffffffffc0200c62:	6105                	addi	sp,sp,32
ffffffffc0200c64:	8082                	ret

ffffffffc0200c66 <slub_free>:
{
    // bb用于遍历记录大块内存的链表。
    // last用于指向链表中前一个节点的next指针
	bigblock_t *bb, **last = &bigblocks_head;

	if (!block)
ffffffffc0200c66:	c531                	beqz	a0,ffffffffc0200cb2 <slub_free+0x4c>
{
ffffffffc0200c68:	1141                	addi	sp,sp,-16
		return;

	// 判断是否是大块
	// 遍历大块链表
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc0200c6a:	00006717          	auipc	a4,0x6
ffffffffc0200c6e:	82670713          	addi	a4,a4,-2010 # ffffffffc0206490 <bigblocks_head>
{
ffffffffc0200c72:	e022                	sd	s0,0(sp)
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc0200c74:	6300                	ld	s0,0(a4)
{
ffffffffc0200c76:	e406                	sd	ra,8(sp)
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc0200c78:	e411                	bnez	s0,ffffffffc0200c84 <slub_free+0x1e>
ffffffffc0200c7a:	a035                	j	ffffffffc0200ca6 <slub_free+0x40>
ffffffffc0200c7c:	01040713          	addi	a4,s0,16
ffffffffc0200c80:	6800                	ld	s0,16(s0)
ffffffffc0200c82:	c015                	beqz	s0,ffffffffc0200ca6 <slub_free+0x40>
        if (bb->pages == block && bb->is_bigblock) {
ffffffffc0200c84:	641c                	ld	a5,8(s0)
ffffffffc0200c86:	fea79be3          	bne	a5,a0,ffffffffc0200c7c <slub_free+0x16>
ffffffffc0200c8a:	4c1c                	lw	a5,24(s0)
ffffffffc0200c8c:	dbe5                	beqz	a5,ffffffffc0200c7c <slub_free+0x16>
            // 确认是大块
            *last = bb->next;  // 从链表中移除当前节点
ffffffffc0200c8e:	681c                	ld	a5,16(s0)
			// call pmm->free_pages to free a continuous n*PAGESIZE memory
            free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc0200c90:	400c                	lw	a1,0(s0)
            *last = bb->next;  // 从链表中移除当前节点
ffffffffc0200c92:	e31c                	sd	a5,0(a4)
            free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc0200c94:	c61ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
            obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc0200c98:	8522                	mv	a0,s0
        }
    }

	obj_free((obj_t *)block - 1, 0);
	return;
}
ffffffffc0200c9a:	6402                	ld	s0,0(sp)
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
            obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc0200c9e:	02000593          	li	a1,32
}
ffffffffc0200ca2:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc0200ca4:	b50d                	j	ffffffffc0200ac6 <obj_free>
}
ffffffffc0200ca6:	6402                	ld	s0,0(sp)
ffffffffc0200ca8:	60a2                	ld	ra,8(sp)
	obj_free((obj_t *)block - 1, 0);
ffffffffc0200caa:	4581                	li	a1,0
ffffffffc0200cac:	1541                	addi	a0,a0,-16
}
ffffffffc0200cae:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc0200cb0:	bd19                	j	ffffffffc0200ac6 <obj_free>
ffffffffc0200cb2:	8082                	ret

ffffffffc0200cb4 <slub_init>:

void slub_init(void) {
    cprintf("slub_init() succeeded!\n");
ffffffffc0200cb4:	00001517          	auipc	a0,0x1
ffffffffc0200cb8:	66450513          	addi	a0,a0,1636 # ffffffffc0202318 <commands+0x6b0>
ffffffffc0200cbc:	bfeff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200cc0 <print_objs>:
}

// 输出object链表信息
void print_objs(){
ffffffffc0200cc0:	7179                	addi	sp,sp,-48
ffffffffc0200cc2:	e84a                	sd	s2,16(sp)
	int object_count = 0;
	cprintf("objsizes: ");
ffffffffc0200cc4:	00001517          	auipc	a0,0x1
ffffffffc0200cc8:	66c50513          	addi	a0,a0,1644 # ffffffffc0202330 <commands+0x6c8>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc0200ccc:	00005917          	auipc	s2,0x5
ffffffffc0200cd0:	33490913          	addi	s2,s2,820 # ffffffffc0206000 <arena>
void print_objs(){
ffffffffc0200cd4:	f022                	sd	s0,32(sp)
ffffffffc0200cd6:	ec26                	sd	s1,24(sp)
ffffffffc0200cd8:	f406                	sd	ra,40(sp)
ffffffffc0200cda:	e44e                	sd	s3,8(sp)
	cprintf("objsizes: ");
ffffffffc0200cdc:	bdeff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc0200ce0:	00893403          	ld	s0,8(s2)
	int object_count = 0;
ffffffffc0200ce4:	4481                	li	s1,0
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc0200ce6:	01240e63          	beq	s0,s2,ffffffffc0200d02 <print_objs+0x42>
		cprintf("%d ", curr->objsize);
ffffffffc0200cea:	00001997          	auipc	s3,0x1
ffffffffc0200cee:	65698993          	addi	s3,s3,1622 # ffffffffc0202340 <commands+0x6d8>
ffffffffc0200cf2:	400c                	lw	a1,0(s0)
ffffffffc0200cf4:	854e                	mv	a0,s3
		object_count ++;
ffffffffc0200cf6:	2485                	addiw	s1,s1,1
		cprintf("%d ", curr->objsize);
ffffffffc0200cf8:	bc2ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc0200cfc:	6400                	ld	s0,8(s0)
ffffffffc0200cfe:	ff241ae3          	bne	s0,s2,ffffffffc0200cf2 <print_objs+0x32>
	}    
	cprintf("Total number of objs: %d\n", object_count);
ffffffffc0200d02:	85a6                	mv	a1,s1
ffffffffc0200d04:	00001517          	auipc	a0,0x1
ffffffffc0200d08:	64450513          	addi	a0,a0,1604 # ffffffffc0202348 <commands+0x6e0>
ffffffffc0200d0c:	baeff0ef          	jal	ra,ffffffffc02000ba <cprintf>
	cprintf("\n");
}
ffffffffc0200d10:	7402                	ld	s0,32(sp)
ffffffffc0200d12:	70a2                	ld	ra,40(sp)
ffffffffc0200d14:	64e2                	ld	s1,24(sp)
ffffffffc0200d16:	6942                	ld	s2,16(sp)
ffffffffc0200d18:	69a2                	ld	s3,8(sp)
	cprintf("\n");
ffffffffc0200d1a:	00001517          	auipc	a0,0x1
ffffffffc0200d1e:	6be50513          	addi	a0,a0,1726 # ffffffffc02023d8 <commands+0x770>
}
ffffffffc0200d22:	6145                	addi	sp,sp,48
	cprintf("\n");
ffffffffc0200d24:	b96ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200d28 <slub_check>:

    
void slub_check()
{
ffffffffc0200d28:	1101                	addi	sp,sp,-32
    cprintf("slub check begin\n");
ffffffffc0200d2a:	00001517          	auipc	a0,0x1
ffffffffc0200d2e:	63e50513          	addi	a0,a0,1598 # ffffffffc0202368 <commands+0x700>
{
ffffffffc0200d32:	ec06                	sd	ra,24(sp)
ffffffffc0200d34:	e822                	sd	s0,16(sp)
ffffffffc0200d36:	e426                	sd	s1,8(sp)
    cprintf("slub check begin\n");
ffffffffc0200d38:	b82ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_objs();
ffffffffc0200d3c:	f85ff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>


    cprintf("alloc test start:\n");
ffffffffc0200d40:	00001517          	auipc	a0,0x1
ffffffffc0200d44:	64050513          	addi	a0,a0,1600 # ffffffffc0202380 <commands+0x718>
ffffffffc0200d48:	b72ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    // 测试申请
	cprintf("p1 alloc 4096\n");
ffffffffc0200d4c:	00001517          	auipc	a0,0x1
ffffffffc0200d50:	64c50513          	addi	a0,a0,1612 # ffffffffc0202398 <commands+0x730>
ffffffffc0200d54:	b66ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
	if (size < PGSIZE - OBJ_UNIT) {
ffffffffc0200d58:	6505                	lui	a0,0x1
ffffffffc0200d5a:	e9fff0ef          	jal	ra,ffffffffc0200bf8 <slub_alloc.part.0>
ffffffffc0200d5e:	84aa                	mv	s1,a0
	void* p1 = slub_alloc(4096);
	print_objs();
ffffffffc0200d60:	f61ff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>

	cprintf("p2 alloc 2\n");
ffffffffc0200d64:	00001517          	auipc	a0,0x1
ffffffffc0200d68:	64450513          	addi	a0,a0,1604 # ffffffffc02023a8 <commands+0x740>
ffffffffc0200d6c:	b4eff0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc0200d70:	4549                	li	a0,18
ffffffffc0200d72:	dd5ff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
    void* p2 = slub_alloc(2);
	print_objs();
ffffffffc0200d76:	f4bff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>

	cprintf("p3 alloc 32\n");
ffffffffc0200d7a:	00001517          	auipc	a0,0x1
ffffffffc0200d7e:	63e50513          	addi	a0,a0,1598 # ffffffffc02023b8 <commands+0x750>
ffffffffc0200d82:	b38ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc0200d86:	03000513          	li	a0,48
ffffffffc0200d8a:	dbdff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
ffffffffc0200d8e:	842a                	mv	s0,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0200d90:	c119                	beqz	a0,ffffffffc0200d96 <slub_check+0x6e>
ffffffffc0200d92:	01050413          	addi	s0,a0,16
    void* p3 = slub_alloc(32);
    print_objs();
ffffffffc0200d96:	f2bff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>

    
	cprintf("free test start:\n");
ffffffffc0200d9a:	00001517          	auipc	a0,0x1
ffffffffc0200d9e:	62e50513          	addi	a0,a0,1582 # ffffffffc02023c8 <commands+0x760>
ffffffffc0200da2:	b18ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
	// 测试释放
    cprintf("free p1\n");
ffffffffc0200da6:	00001517          	auipc	a0,0x1
ffffffffc0200daa:	63a50513          	addi	a0,a0,1594 # ffffffffc02023e0 <commands+0x778>
ffffffffc0200dae:	b0cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p1);
ffffffffc0200db2:	8526                	mv	a0,s1
ffffffffc0200db4:	eb3ff0ef          	jal	ra,ffffffffc0200c66 <slub_free>
    print_objs();
ffffffffc0200db8:	f09ff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>

	cprintf("free p3\n");
ffffffffc0200dbc:	00001517          	auipc	a0,0x1
ffffffffc0200dc0:	63450513          	addi	a0,a0,1588 # ffffffffc02023f0 <commands+0x788>
ffffffffc0200dc4:	af6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p3);
ffffffffc0200dc8:	8522                	mv	a0,s0
ffffffffc0200dca:	e9dff0ef          	jal	ra,ffffffffc0200c66 <slub_free>
    print_objs();
ffffffffc0200dce:	ef3ff0ef          	jal	ra,ffffffffc0200cc0 <print_objs>

    cprintf("slub check end\n");
ffffffffc0200dd2:	6442                	ld	s0,16(sp)
ffffffffc0200dd4:	60e2                	ld	ra,24(sp)
ffffffffc0200dd6:	64a2                	ld	s1,8(sp)
    cprintf("slub check end\n");
ffffffffc0200dd8:	00001517          	auipc	a0,0x1
ffffffffc0200ddc:	62850513          	addi	a0,a0,1576 # ffffffffc0202400 <commands+0x798>
ffffffffc0200de0:	6105                	addi	sp,sp,32
    cprintf("slub check end\n");
ffffffffc0200de2:	ad8ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200de6 <buddy_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200de6:	00005797          	auipc	a5,0x5
ffffffffc0200dea:	24a78793          	addi	a5,a5,586 # ffffffffc0206030 <free_area>
ffffffffc0200dee:	e79c                	sd	a5,8(a5)
ffffffffc0200df0:	e39c                	sd	a5,0(a5)

static void
buddy_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200df2:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200df6:	8082                	ret

ffffffffc0200df8 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200df8:	00005517          	auipc	a0,0x5
ffffffffc0200dfc:	24856503          	lwu	a0,584(a0) # ffffffffc0206040 <free_area+0x10>
ffffffffc0200e00:	8082                	ret

ffffffffc0200e02 <buddy_free_pages>:
{
ffffffffc0200e02:	1141                	addi	sp,sp,-16
ffffffffc0200e04:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200e06:	14058263          	beqz	a1,ffffffffc0200f4a <buddy_free_pages+0x148>
    int i = get_power(n);
ffffffffc0200e0a:	0005871b          	sext.w	a4,a1
    while (tmp > 1)
ffffffffc0200e0e:	4785                	li	a5,1
    double tmp = n;
ffffffffc0200e10:	d21587d3          	fcvt.d.wu	fa5,a1
    while (tmp > 1)
ffffffffc0200e14:	10e7f763          	bgeu	a5,a4,ffffffffc0200f22 <buddy_free_pages+0x120>
    unsigned i = 0;
ffffffffc0200e18:	4781                	li	a5,0
ffffffffc0200e1a:	00002717          	auipc	a4,0x2
ffffffffc0200e1e:	9e673687          	fld	fa3,-1562(a4) # ffffffffc0202800 <error_string+0x38>
ffffffffc0200e22:	00002717          	auipc	a4,0x2
ffffffffc0200e26:	9e673707          	fld	fa4,-1562(a4) # ffffffffc0202808 <error_string+0x40>
        tmp /= 2;
ffffffffc0200e2a:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc0200e2e:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc0200e30:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200e34:	fb7d                	bnez	a4,ffffffffc0200e2a <buddy_free_pages+0x28>
    unsigned size = (1 << i);
ffffffffc0200e36:	4605                	li	a2,1
ffffffffc0200e38:	00f6163b          	sllw	a2,a2,a5
    for (; p != base + size; p++)
ffffffffc0200e3c:	02061793          	slli	a5,a2,0x20
ffffffffc0200e40:	9381                	srli	a5,a5,0x20
ffffffffc0200e42:	00279693          	slli	a3,a5,0x2
ffffffffc0200e46:	96be                	add	a3,a3,a5
ffffffffc0200e48:	068e                	slli	a3,a3,0x3
ffffffffc0200e4a:	96aa                	add	a3,a3,a0
ffffffffc0200e4c:	00d50f63          	beq	a0,a3,ffffffffc0200e6a <buddy_free_pages+0x68>
ffffffffc0200e50:	87aa                	mv	a5,a0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e52:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200e54:	8b05                	andi	a4,a4,1
ffffffffc0200e56:	eb71                	bnez	a4,ffffffffc0200f2a <buddy_free_pages+0x128>
ffffffffc0200e58:	6798                	ld	a4,8(a5)
ffffffffc0200e5a:	8b09                	andi	a4,a4,2
ffffffffc0200e5c:	e779                	bnez	a4,ffffffffc0200f2a <buddy_free_pages+0x128>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200e5e:	0007a023          	sw	zero,0(a5)
    for (; p != base + size; p++)
ffffffffc0200e62:	02878793          	addi	a5,a5,40
ffffffffc0200e66:	fed796e3          	bne	a5,a3,ffffffffc0200e52 <buddy_free_pages+0x50>
    unsigned offect = base - base0;
ffffffffc0200e6a:	00005797          	auipc	a5,0x5
ffffffffc0200e6e:	62e7b783          	ld	a5,1582(a5) # ffffffffc0206498 <base0>
ffffffffc0200e72:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e76:	878d                	srai	a5,a5,0x3
ffffffffc0200e78:	00002717          	auipc	a4,0x2
ffffffffc0200e7c:	99873703          	ld	a4,-1640(a4) # ffffffffc0202810 <error_string+0x48>
ffffffffc0200e80:	02e78733          	mul	a4,a5,a4
    unsigned index = length / 2 + offect - 1;
ffffffffc0200e84:	00005697          	auipc	a3,0x5
ffffffffc0200e88:	6246a683          	lw	a3,1572(a3) # ffffffffc02064a8 <length>
ffffffffc0200e8c:	01f6d79b          	srliw	a5,a3,0x1f
ffffffffc0200e90:	9fb5                	addw	a5,a5,a3
    nr_free += size;
ffffffffc0200e92:	00005597          	auipc	a1,0x5
ffffffffc0200e96:	19e58593          	addi	a1,a1,414 # ffffffffc0206030 <free_area>
    unsigned index = length / 2 + offect - 1;
ffffffffc0200e9a:	4017d79b          	sraiw	a5,a5,0x1
    nr_free += size;
ffffffffc0200e9e:	4994                	lw	a3,16(a1)
    unsigned index = length / 2 + offect - 1;
ffffffffc0200ea0:	37fd                	addiw	a5,a5,-1
    buddy[index] = node_size;
ffffffffc0200ea2:	00005517          	auipc	a0,0x5
ffffffffc0200ea6:	5fe53503          	ld	a0,1534(a0) # ffffffffc02064a0 <buddy>
    nr_free += size;
ffffffffc0200eaa:	9eb1                	addw	a3,a3,a2
    unsigned index = length / 2 + offect - 1;
ffffffffc0200eac:	9fb9                	addw	a5,a5,a4
    buddy[index] = node_size;
ffffffffc0200eae:	02079813          	slli	a6,a5,0x20
ffffffffc0200eb2:	01e85713          	srli	a4,a6,0x1e
    nr_free += size;
ffffffffc0200eb6:	c994                	sw	a3,16(a1)
    buddy[index] = node_size;
ffffffffc0200eb8:	972a                	add	a4,a4,a0
ffffffffc0200eba:	c310                	sw	a2,0(a4)
    while (index)
ffffffffc0200ebc:	eba9                	bnez	a5,ffffffffc0200f0e <buddy_free_pages+0x10c>
ffffffffc0200ebe:	a8b9                	j	ffffffffc0200f1c <buddy_free_pages+0x11a>
            index = (index - 2) / 2;
ffffffffc0200ec0:	37f9                	addiw	a5,a5,-2
ffffffffc0200ec2:	0017d79b          	srliw	a5,a5,0x1
        unsigned left = buddy[2 * index + 1];
ffffffffc0200ec6:	0017971b          	slliw	a4,a5,0x1
        unsigned right = buddy[2 * index + 2];
ffffffffc0200eca:	0027069b          	addiw	a3,a4,2
ffffffffc0200ece:	1682                	slli	a3,a3,0x20
        unsigned left = buddy[2 * index + 1];
ffffffffc0200ed0:	2705                	addiw	a4,a4,1
ffffffffc0200ed2:	02071593          	slli	a1,a4,0x20
        unsigned right = buddy[2 * index + 2];
ffffffffc0200ed6:	9281                	srli	a3,a3,0x20
        unsigned left = buddy[2 * index + 1];
ffffffffc0200ed8:	01e5d713          	srli	a4,a1,0x1e
        unsigned right = buddy[2 * index + 2];
ffffffffc0200edc:	068a                	slli	a3,a3,0x2
        unsigned left = buddy[2 * index + 1];
ffffffffc0200ede:	972a                	add	a4,a4,a0
        unsigned right = buddy[2 * index + 2];
ffffffffc0200ee0:	96aa                	add	a3,a3,a0
        unsigned left = buddy[2 * index + 1];
ffffffffc0200ee2:	430c                	lw	a1,0(a4)
        unsigned right = buddy[2 * index + 2];
ffffffffc0200ee4:	4294                	lw	a3,0(a3)
        node_size *= 2;
ffffffffc0200ee6:	0016181b          	slliw	a6,a2,0x1
            buddy[index] = node_size;
ffffffffc0200eea:	02079613          	slli	a2,a5,0x20
ffffffffc0200eee:	01e65713          	srli	a4,a2,0x1e
        if (left + right == node_size)
ffffffffc0200ef2:	00d588bb          	addw	a7,a1,a3
        node_size *= 2;
ffffffffc0200ef6:	0008061b          	sext.w	a2,a6
            buddy[index] = node_size;
ffffffffc0200efa:	972a                	add	a4,a4,a0
        if (left + right == node_size)
ffffffffc0200efc:	00c88663          	beq	a7,a2,ffffffffc0200f08 <buddy_free_pages+0x106>
            buddy[index] = (left > right) ? left : right;
ffffffffc0200f00:	882e                	mv	a6,a1
ffffffffc0200f02:	00d5f363          	bgeu	a1,a3,ffffffffc0200f08 <buddy_free_pages+0x106>
ffffffffc0200f06:	8836                	mv	a6,a3
ffffffffc0200f08:	01072023          	sw	a6,0(a4)
    while (index)
ffffffffc0200f0c:	cb81                	beqz	a5,ffffffffc0200f1c <buddy_free_pages+0x11a>
        if (index % 2 == 0)
ffffffffc0200f0e:	0017f713          	andi	a4,a5,1
ffffffffc0200f12:	d75d                	beqz	a4,ffffffffc0200ec0 <buddy_free_pages+0xbe>
            index = (index - 1) / 2;
ffffffffc0200f14:	37fd                	addiw	a5,a5,-1
ffffffffc0200f16:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200f1a:	b775                	j	ffffffffc0200ec6 <buddy_free_pages+0xc4>
}
ffffffffc0200f1c:	60a2                	ld	ra,8(sp)
ffffffffc0200f1e:	0141                	addi	sp,sp,16
ffffffffc0200f20:	8082                	ret
    while (tmp > 1)
ffffffffc0200f22:	4605                	li	a2,1
ffffffffc0200f24:	02850693          	addi	a3,a0,40
ffffffffc0200f28:	b725                	j	ffffffffc0200e50 <buddy_free_pages+0x4e>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200f2a:	00001697          	auipc	a3,0x1
ffffffffc0200f2e:	50668693          	addi	a3,a3,1286 # ffffffffc0202430 <commands+0x7c8>
ffffffffc0200f32:	00001617          	auipc	a2,0x1
ffffffffc0200f36:	3b660613          	addi	a2,a2,950 # ffffffffc02022e8 <commands+0x680>
ffffffffc0200f3a:	0a200593          	li	a1,162
ffffffffc0200f3e:	00001517          	auipc	a0,0x1
ffffffffc0200f42:	4da50513          	addi	a0,a0,1242 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0200f46:	9fcff0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(n > 0);
ffffffffc0200f4a:	00001697          	auipc	a3,0x1
ffffffffc0200f4e:	4c668693          	addi	a3,a3,1222 # ffffffffc0202410 <commands+0x7a8>
ffffffffc0200f52:	00001617          	auipc	a2,0x1
ffffffffc0200f56:	39660613          	addi	a2,a2,918 # ffffffffc02022e8 <commands+0x680>
ffffffffc0200f5a:	09b00593          	li	a1,155
ffffffffc0200f5e:	00001517          	auipc	a0,0x1
ffffffffc0200f62:	4ba50513          	addi	a0,a0,1210 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0200f66:	9dcff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200f6a <buddy_alloc_pages>:
    assert(n > 0);
ffffffffc0200f6a:	1e050263          	beqz	a0,ffffffffc020114e <buddy_alloc_pages+0x1e4>
    if (n > nr_free)
ffffffffc0200f6e:	00005817          	auipc	a6,0x5
ffffffffc0200f72:	0c280813          	addi	a6,a6,194 # ffffffffc0206030 <free_area>
ffffffffc0200f76:	01086783          	lwu	a5,16(a6)
ffffffffc0200f7a:	1aa7ee63          	bltu	a5,a0,ffffffffc0201136 <buddy_alloc_pages+0x1cc>
    else if (!is_power_of_2(n))
ffffffffc0200f7e:	0005031b          	sext.w	t1,a0
    return !(x & (x - 1));
ffffffffc0200f82:	fff5079b          	addiw	a5,a0,-1
ffffffffc0200f86:	00f377b3          	and	a5,t1,a5
    else if (!is_power_of_2(n))
ffffffffc0200f8a:	2781                	sext.w	a5,a5
    double tmp = n;
ffffffffc0200f8c:	d21507d3          	fcvt.d.wu	fa5,a0
    else if (!is_power_of_2(n))
ffffffffc0200f90:	16079a63          	bnez	a5,ffffffffc0201104 <buddy_alloc_pages+0x19a>
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc0200f94:	00005897          	auipc	a7,0x5
ffffffffc0200f98:	51488893          	addi	a7,a7,1300 # ffffffffc02064a8 <length>
ffffffffc0200f9c:	0008a703          	lw	a4,0(a7)
    if (buddy[index] < n) //如果根节点大小小于n，则找不到合适的节点
ffffffffc0200fa0:	00005617          	auipc	a2,0x5
ffffffffc0200fa4:	50063603          	ld	a2,1280(a2) # ffffffffc02064a0 <buddy>
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc0200fa8:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0200fac:	9fb9                	addw	a5,a5,a4
ffffffffc0200fae:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200fb2:	02079693          	slli	a3,a5,0x20
ffffffffc0200fb6:	9281                	srli	a3,a3,0x20
ffffffffc0200fb8:	0007871b          	sext.w	a4,a5
ffffffffc0200fbc:	0ad50963          	beq	a0,a3,ffffffffc020106e <buddy_alloc_pages+0x104>
    unsigned index = 0;//从根节点开始寻找
ffffffffc0200fc0:	4781                	li	a5,0
        if (buddy[2 * index + 1] >= n)
ffffffffc0200fc2:	0017959b          	slliw	a1,a5,0x1
ffffffffc0200fc6:	0015879b          	addiw	a5,a1,1
ffffffffc0200fca:	02079e13          	slli	t3,a5,0x20
ffffffffc0200fce:	01ee5693          	srli	a3,t3,0x1e
ffffffffc0200fd2:	96b2                	add	a3,a3,a2
ffffffffc0200fd4:	0006e683          	lwu	a3,0(a3)
ffffffffc0200fd8:	00a6f463          	bgeu	a3,a0,ffffffffc0200fe0 <buddy_alloc_pages+0x76>
            index = 2 * index + 2;
ffffffffc0200fdc:	0025879b          	addiw	a5,a1,2
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc0200fe0:	0017571b          	srliw	a4,a4,0x1
ffffffffc0200fe4:	02071693          	slli	a3,a4,0x20
ffffffffc0200fe8:	9281                	srli	a3,a3,0x20
ffffffffc0200fea:	fca69ce3          	bne	a3,a0,ffffffffc0200fc2 <buddy_alloc_pages+0x58>
    offect = (index + 1) * node_size - length / 2;
ffffffffc0200fee:	00178e1b          	addiw	t3,a5,1
ffffffffc0200ff2:	02ee073b          	mulw	a4,t3,a4
    buddy[index] = 0;
ffffffffc0200ff6:	02079593          	slli	a1,a5,0x20
ffffffffc0200ffa:	01e5d693          	srli	a3,a1,0x1e
ffffffffc0200ffe:	96b2                	add	a3,a3,a2
ffffffffc0201000:	0006a023          	sw	zero,0(a3)
    offect = (index + 1) * node_size - length / 2;
ffffffffc0201004:	0008a683          	lw	a3,0(a7)
ffffffffc0201008:	01f6de1b          	srliw	t3,a3,0x1f
ffffffffc020100c:	00de0e3b          	addw	t3,t3,a3
ffffffffc0201010:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc0201014:	41c70e3b          	subw	t3,a4,t3
    while (index > 0)
ffffffffc0201018:	e7a1                	bnez	a5,ffffffffc0201060 <buddy_alloc_pages+0xf6>
ffffffffc020101a:	a0b5                	j	ffffffffc0201086 <buddy_alloc_pages+0x11c>
            index = (index - 2) / 2;
ffffffffc020101c:	37f9                	addiw	a5,a5,-2
ffffffffc020101e:	0017d79b          	srliw	a5,a5,0x1
        buddy[index] = (buddy[2 * index + 1] > buddy[2 * index + 2]) ? buddy[2 * index + 1] : buddy[2 * index + 2];
ffffffffc0201022:	0017871b          	addiw	a4,a5,1
ffffffffc0201026:	0017171b          	slliw	a4,a4,0x1
ffffffffc020102a:	fff7069b          	addiw	a3,a4,-1
ffffffffc020102e:	1702                	slli	a4,a4,0x20
ffffffffc0201030:	02069593          	slli	a1,a3,0x20
ffffffffc0201034:	9301                	srli	a4,a4,0x20
ffffffffc0201036:	01e5d693          	srli	a3,a1,0x1e
ffffffffc020103a:	070a                	slli	a4,a4,0x2
ffffffffc020103c:	9732                	add	a4,a4,a2
ffffffffc020103e:	96b2                	add	a3,a3,a2
ffffffffc0201040:	430c                	lw	a1,0(a4)
ffffffffc0201042:	4294                	lw	a3,0(a3)
ffffffffc0201044:	02079513          	slli	a0,a5,0x20
ffffffffc0201048:	01e55713          	srli	a4,a0,0x1e
ffffffffc020104c:	0006889b          	sext.w	a7,a3
ffffffffc0201050:	0005851b          	sext.w	a0,a1
ffffffffc0201054:	9732                	add	a4,a4,a2
ffffffffc0201056:	00a8f363          	bgeu	a7,a0,ffffffffc020105c <buddy_alloc_pages+0xf2>
ffffffffc020105a:	86ae                	mv	a3,a1
ffffffffc020105c:	c314                	sw	a3,0(a4)
    while (index > 0)
ffffffffc020105e:	c785                	beqz	a5,ffffffffc0201086 <buddy_alloc_pages+0x11c>
        if (index % 2 == 0)
ffffffffc0201060:	0017f693          	andi	a3,a5,1
ffffffffc0201064:	dec5                	beqz	a3,ffffffffc020101c <buddy_alloc_pages+0xb2>
            index = (index - 1) / 2;
ffffffffc0201066:	37fd                	addiw	a5,a5,-1
ffffffffc0201068:	0017d79b          	srliw	a5,a5,0x1
ffffffffc020106c:	bf5d                	j	ffffffffc0201022 <buddy_alloc_pages+0xb8>
    buddy[index] = 0;
ffffffffc020106e:	00062023          	sw	zero,0(a2)
    offect = (index + 1) * node_size - length / 2;
ffffffffc0201072:	0008a703          	lw	a4,0(a7)
ffffffffc0201076:	01f75e1b          	srliw	t3,a4,0x1f
ffffffffc020107a:	00ee0e3b          	addw	t3,t3,a4
ffffffffc020107e:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc0201082:	41c78e3b          	subw	t3,a5,t3
    page = base0 + offect;
ffffffffc0201086:	020e1793          	slli	a5,t3,0x20
ffffffffc020108a:	9381                	srli	a5,a5,0x20
ffffffffc020108c:	00279513          	slli	a0,a5,0x2
ffffffffc0201090:	97aa                	add	a5,a5,a0
ffffffffc0201092:	078e                	slli	a5,a5,0x3
ffffffffc0201094:	00005517          	auipc	a0,0x5
ffffffffc0201098:	40453503          	ld	a0,1028(a0) # ffffffffc0206498 <base0>
ffffffffc020109c:	953e                	add	a0,a0,a5
    page->property = n;
ffffffffc020109e:	00652823          	sw	t1,16(a0)
    while (tmp > 1)
ffffffffc02010a2:	4785                	li	a5,1
ffffffffc02010a4:	0867fb63          	bgeu	a5,t1,ffffffffc020113a <buddy_alloc_pages+0x1d0>
    unsigned i = 0;
ffffffffc02010a8:	4781                	li	a5,0
ffffffffc02010aa:	00001717          	auipc	a4,0x1
ffffffffc02010ae:	75673687          	fld	fa3,1878(a4) # ffffffffc0202800 <error_string+0x38>
ffffffffc02010b2:	00001717          	auipc	a4,0x1
ffffffffc02010b6:	75673707          	fld	fa4,1878(a4) # ffffffffc0202808 <error_string+0x40>
        tmp /= 2;
ffffffffc02010ba:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc02010be:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc02010c0:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc02010c4:	fb7d                	bnez	a4,ffffffffc02010ba <buddy_alloc_pages+0x150>
    unsigned size = (1 << i);
ffffffffc02010c6:	4705                	li	a4,1
ffffffffc02010c8:	00f717bb          	sllw	a5,a4,a5
    for (struct Page *p = page; p != page + size; p++)
ffffffffc02010cc:	02079693          	slli	a3,a5,0x20
ffffffffc02010d0:	9281                	srli	a3,a3,0x20
ffffffffc02010d2:	00269713          	slli	a4,a3,0x2
ffffffffc02010d6:	9736                	add	a4,a4,a3
ffffffffc02010d8:	070e                	slli	a4,a4,0x3
    nr_free -= size;
ffffffffc02010da:	01082683          	lw	a3,16(a6)
    for (struct Page *p = page; p != page + size; p++)
ffffffffc02010de:	972a                	add	a4,a4,a0
    nr_free -= size;
ffffffffc02010e0:	40f687bb          	subw	a5,a3,a5
ffffffffc02010e4:	00f82823          	sw	a5,16(a6)
    for (struct Page *p = page; p != page + size; p++)
ffffffffc02010e8:	00e50d63          	beq	a0,a4,ffffffffc0201102 <buddy_alloc_pages+0x198>
ffffffffc02010ec:	87aa                	mv	a5,a0
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02010ee:	56f5                	li	a3,-3
ffffffffc02010f0:	00878613          	addi	a2,a5,8
ffffffffc02010f4:	60d6302f          	amoand.d	zero,a3,(a2)
ffffffffc02010f8:	02878793          	addi	a5,a5,40
ffffffffc02010fc:	fee79ae3          	bne	a5,a4,ffffffffc02010f0 <buddy_alloc_pages+0x186>
ffffffffc0201100:	8082                	ret
}
ffffffffc0201102:	8082                	ret
    while (tmp > 1)
ffffffffc0201104:	4785                	li	a5,1
ffffffffc0201106:	02f50e63          	beq	a0,a5,ffffffffc0201142 <buddy_alloc_pages+0x1d8>
    unsigned i = 0;
ffffffffc020110a:	4781                	li	a5,0
ffffffffc020110c:	00001717          	auipc	a4,0x1
ffffffffc0201110:	6f473687          	fld	fa3,1780(a4) # ffffffffc0202800 <error_string+0x38>
ffffffffc0201114:	00001717          	auipc	a4,0x1
ffffffffc0201118:	6f473707          	fld	fa4,1780(a4) # ffffffffc0202808 <error_string+0x40>
        tmp /= 2;
ffffffffc020111c:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc0201120:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc0201122:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0201126:	fb7d                	bnez	a4,ffffffffc020111c <buddy_alloc_pages+0x1b2>
        n = (1 << pw);
ffffffffc0201128:	4705                	li	a4,1
ffffffffc020112a:	00f7153b          	sllw	a0,a4,a5
    double tmp = n;
ffffffffc020112e:	d21507d3          	fcvt.d.wu	fa5,a0
    page->property = n;
ffffffffc0201132:	832a                	mv	t1,a0
ffffffffc0201134:	b585                	j	ffffffffc0200f94 <buddy_alloc_pages+0x2a>
        return NULL;
ffffffffc0201136:	4501                	li	a0,0
ffffffffc0201138:	8082                	ret
    while (tmp > 1)
ffffffffc020113a:	4785                	li	a5,1
ffffffffc020113c:	02800713          	li	a4,40
ffffffffc0201140:	bf69                	j	ffffffffc02010da <buddy_alloc_pages+0x170>
ffffffffc0201142:	00001797          	auipc	a5,0x1
ffffffffc0201146:	6c67b787          	fld	fa5,1734(a5) # ffffffffc0202808 <error_string+0x40>
ffffffffc020114a:	4305                	li	t1,1
        n = (1 << pw);
ffffffffc020114c:	b5a1                	j	ffffffffc0200f94 <buddy_alloc_pages+0x2a>
{
ffffffffc020114e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201150:	00001697          	auipc	a3,0x1
ffffffffc0201154:	2c068693          	addi	a3,a3,704 # ffffffffc0202410 <commands+0x7a8>
ffffffffc0201158:	00001617          	auipc	a2,0x1
ffffffffc020115c:	19060613          	addi	a2,a2,400 # ffffffffc02022e8 <commands+0x680>
ffffffffc0201160:	04f00593          	li	a1,79
ffffffffc0201164:	00001517          	auipc	a0,0x1
ffffffffc0201168:	2b450513          	addi	a0,a0,692 # ffffffffc0202418 <commands+0x7b0>
{
ffffffffc020116c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020116e:	fd5fe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0201172 <buddy_check>:


static void
buddy_check(void)
{
ffffffffc0201172:	1101                	addi	sp,sp,-32
    cprintf("buddy check%s\n", "!");
ffffffffc0201174:	00001597          	auipc	a1,0x1
ffffffffc0201178:	2e458593          	addi	a1,a1,740 # ffffffffc0202458 <commands+0x7f0>
ffffffffc020117c:	00001517          	auipc	a0,0x1
ffffffffc0201180:	2e450513          	addi	a0,a0,740 # ffffffffc0202460 <commands+0x7f8>
{
ffffffffc0201184:	ec06                	sd	ra,24(sp)
ffffffffc0201186:	e822                	sd	s0,16(sp)
ffffffffc0201188:	e426                	sd	s1,8(sp)
ffffffffc020118a:	e04a                	sd	s2,0(sp)
    cprintf("buddy check%s\n", "!");
ffffffffc020118c:	f2ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    struct Page *p0, *p1, *p2, *A, *B, *C, *D;
    p0 = p1 = p2 = A = B = C = D = NULL;

    // cprintf("alloc p0\n");
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201190:	4505                	li	a0,1
ffffffffc0201192:	f24ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc0201196:	14050363          	beqz	a0,ffffffffc02012dc <buddy_check+0x16a>
ffffffffc020119a:	842a                	mv	s0,a0
    // cprintf("alloc A\n");
    assert((A = alloc_page()) != NULL);
ffffffffc020119c:	4505                	li	a0,1
ffffffffc020119e:	f18ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011a2:	84aa                	mv	s1,a0
ffffffffc02011a4:	10050c63          	beqz	a0,ffffffffc02012bc <buddy_check+0x14a>
    // cprintf("alloc B\n");
    assert((B = alloc_page()) != NULL);
ffffffffc02011a8:	4505                	li	a0,1
ffffffffc02011aa:	f0cff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011ae:	892a                	mv	s2,a0
ffffffffc02011b0:	0e050663          	beqz	a0,ffffffffc020129c <buddy_check+0x12a>

    // cprintf("before free p0,A,B buddy[0] %u\n", buddy[0]);

    assert(p0 != A && p0 != B && A != B);
ffffffffc02011b4:	0a940463          	beq	s0,s1,ffffffffc020125c <buddy_check+0xea>
ffffffffc02011b8:	0aa40263          	beq	s0,a0,ffffffffc020125c <buddy_check+0xea>
ffffffffc02011bc:	0aa48063          	beq	s1,a0,ffffffffc020125c <buddy_check+0xea>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
ffffffffc02011c0:	401c                	lw	a5,0(s0)
ffffffffc02011c2:	efcd                	bnez	a5,ffffffffc020127c <buddy_check+0x10a>
ffffffffc02011c4:	409c                	lw	a5,0(s1)
ffffffffc02011c6:	ebdd                	bnez	a5,ffffffffc020127c <buddy_check+0x10a>
ffffffffc02011c8:	411c                	lw	a5,0(a0)
ffffffffc02011ca:	ebcd                	bnez	a5,ffffffffc020127c <buddy_check+0x10a>

    // cprintf("free p0\n");
    free_page(p0);
ffffffffc02011cc:	8522                	mv	a0,s0
ffffffffc02011ce:	4585                	li	a1,1
ffffffffc02011d0:	f24ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("free A\n");
    free_page(A);
ffffffffc02011d4:	8526                	mv	a0,s1
ffffffffc02011d6:	4585                	li	a1,1
ffffffffc02011d8:	f1cff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("free B\n");
    free_page(B);
ffffffffc02011dc:	4585                	li	a1,1
ffffffffc02011de:	854a                	mv	a0,s2
ffffffffc02011e0:	f14ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("after free p0,A,B buddy[0] %u\n", buddy[0]);

    p0 = alloc_pages(100);
ffffffffc02011e4:	06400513          	li	a0,100
ffffffffc02011e8:	eceff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011ec:	842a                	mv	s0,a0
    p1 = alloc_pages(100);
ffffffffc02011ee:	06400513          	li	a0,100
ffffffffc02011f2:	ec4ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    A = alloc_pages(64);
ffffffffc02011f6:	04000513          	li	a0,64
ffffffffc02011fa:	ebcff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>

    // 检验p1和p2是否相邻，并且分配内存是否是大于分配内存的2的幂次
    assert(p1 = p0 + 128);
    // 检验A和p1是否相邻
    assert(A == p1 + 128);
ffffffffc02011fe:	678d                	lui	a5,0x3
ffffffffc0201200:	80078793          	addi	a5,a5,-2048 # 2800 <kern_entry-0xffffffffc01fd800>
    assert(p1 = p0 + 128);
ffffffffc0201204:	6705                	lui	a4,0x1
ffffffffc0201206:	40070713          	addi	a4,a4,1024 # 1400 <kern_entry-0xffffffffc01fec00>
    assert(A == p1 + 128);
ffffffffc020120a:	97a2                	add	a5,a5,s0
    A = alloc_pages(64);
ffffffffc020120c:	892a                	mv	s2,a0
    assert(p1 = p0 + 128);
ffffffffc020120e:	00e404b3          	add	s1,s0,a4
    assert(A == p1 + 128);
ffffffffc0201212:	12f51563          	bne	a0,a5,ffffffffc020133c <buddy_check+0x1ca>

    // 检验p0释放后分配D是否使用了D的空间
    free_page(p0);
ffffffffc0201216:	8522                	mv	a0,s0
ffffffffc0201218:	4585                	li	a1,1
ffffffffc020121a:	edaff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    D = alloc_pages(32);
ffffffffc020121e:	02000513          	li	a0,32
ffffffffc0201222:	e94ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    assert(D == p0);
ffffffffc0201226:	0ea41b63          	bne	s0,a0,ffffffffc020131c <buddy_check+0x1aa>

    // 检验释放后内存的合并是否正确
    free_page(D);
ffffffffc020122a:	4585                	li	a1,1
ffffffffc020122c:	ec8ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    free_page(p1);
ffffffffc0201230:	8526                	mv	a0,s1
ffffffffc0201232:	4585                	li	a1,1
ffffffffc0201234:	ec0ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    p2 = alloc_pages(256);
ffffffffc0201238:	10000513          	li	a0,256
ffffffffc020123c:	e7aff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    assert(p0 == p2);
ffffffffc0201240:	0aa41e63          	bne	s0,a0,ffffffffc02012fc <buddy_check+0x18a>

    free_page(p2);
ffffffffc0201244:	4585                	li	a1,1
ffffffffc0201246:	eaeff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    free_page(A);
}
ffffffffc020124a:	6442                	ld	s0,16(sp)
ffffffffc020124c:	60e2                	ld	ra,24(sp)
ffffffffc020124e:	64a2                	ld	s1,8(sp)
    free_page(A);
ffffffffc0201250:	854a                	mv	a0,s2
}
ffffffffc0201252:	6902                	ld	s2,0(sp)
    free_page(A);
ffffffffc0201254:	4585                	li	a1,1
}
ffffffffc0201256:	6105                	addi	sp,sp,32
    free_page(A);
ffffffffc0201258:	e9cff06f          	j	ffffffffc02008f4 <free_pages>
    assert(p0 != A && p0 != B && A != B);
ffffffffc020125c:	00001697          	auipc	a3,0x1
ffffffffc0201260:	27468693          	addi	a3,a3,628 # ffffffffc02024d0 <commands+0x868>
ffffffffc0201264:	00001617          	auipc	a2,0x1
ffffffffc0201268:	08460613          	addi	a2,a2,132 # ffffffffc02022e8 <commands+0x680>
ffffffffc020126c:	0dd00593          	li	a1,221
ffffffffc0201270:	00001517          	auipc	a0,0x1
ffffffffc0201274:	1a850513          	addi	a0,a0,424 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0201278:	ecbfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
ffffffffc020127c:	00001697          	auipc	a3,0x1
ffffffffc0201280:	27468693          	addi	a3,a3,628 # ffffffffc02024f0 <commands+0x888>
ffffffffc0201284:	00001617          	auipc	a2,0x1
ffffffffc0201288:	06460613          	addi	a2,a2,100 # ffffffffc02022e8 <commands+0x680>
ffffffffc020128c:	0de00593          	li	a1,222
ffffffffc0201290:	00001517          	auipc	a0,0x1
ffffffffc0201294:	18850513          	addi	a0,a0,392 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0201298:	eabfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((B = alloc_page()) != NULL);
ffffffffc020129c:	00001697          	auipc	a3,0x1
ffffffffc02012a0:	21468693          	addi	a3,a3,532 # ffffffffc02024b0 <commands+0x848>
ffffffffc02012a4:	00001617          	auipc	a2,0x1
ffffffffc02012a8:	04460613          	addi	a2,a2,68 # ffffffffc02022e8 <commands+0x680>
ffffffffc02012ac:	0d900593          	li	a1,217
ffffffffc02012b0:	00001517          	auipc	a0,0x1
ffffffffc02012b4:	16850513          	addi	a0,a0,360 # ffffffffc0202418 <commands+0x7b0>
ffffffffc02012b8:	e8bfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((A = alloc_page()) != NULL);
ffffffffc02012bc:	00001697          	auipc	a3,0x1
ffffffffc02012c0:	1d468693          	addi	a3,a3,468 # ffffffffc0202490 <commands+0x828>
ffffffffc02012c4:	00001617          	auipc	a2,0x1
ffffffffc02012c8:	02460613          	addi	a2,a2,36 # ffffffffc02022e8 <commands+0x680>
ffffffffc02012cc:	0d700593          	li	a1,215
ffffffffc02012d0:	00001517          	auipc	a0,0x1
ffffffffc02012d4:	14850513          	addi	a0,a0,328 # ffffffffc0202418 <commands+0x7b0>
ffffffffc02012d8:	e6bfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012dc:	00001697          	auipc	a3,0x1
ffffffffc02012e0:	19468693          	addi	a3,a3,404 # ffffffffc0202470 <commands+0x808>
ffffffffc02012e4:	00001617          	auipc	a2,0x1
ffffffffc02012e8:	00460613          	addi	a2,a2,4 # ffffffffc02022e8 <commands+0x680>
ffffffffc02012ec:	0d500593          	li	a1,213
ffffffffc02012f0:	00001517          	auipc	a0,0x1
ffffffffc02012f4:	12850513          	addi	a0,a0,296 # ffffffffc0202418 <commands+0x7b0>
ffffffffc02012f8:	e4bfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(p0 == p2);
ffffffffc02012fc:	00001697          	auipc	a3,0x1
ffffffffc0201300:	24c68693          	addi	a3,a3,588 # ffffffffc0202548 <commands+0x8e0>
ffffffffc0201304:	00001617          	auipc	a2,0x1
ffffffffc0201308:	fe460613          	addi	a2,a2,-28 # ffffffffc02022e8 <commands+0x680>
ffffffffc020130c:	0fa00593          	li	a1,250
ffffffffc0201310:	00001517          	auipc	a0,0x1
ffffffffc0201314:	10850513          	addi	a0,a0,264 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0201318:	e2bfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(D == p0);
ffffffffc020131c:	00001697          	auipc	a3,0x1
ffffffffc0201320:	22468693          	addi	a3,a3,548 # ffffffffc0202540 <commands+0x8d8>
ffffffffc0201324:	00001617          	auipc	a2,0x1
ffffffffc0201328:	fc460613          	addi	a2,a2,-60 # ffffffffc02022e8 <commands+0x680>
ffffffffc020132c:	0f400593          	li	a1,244
ffffffffc0201330:	00001517          	auipc	a0,0x1
ffffffffc0201334:	0e850513          	addi	a0,a0,232 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0201338:	e0bfe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(A == p1 + 128);
ffffffffc020133c:	00001697          	auipc	a3,0x1
ffffffffc0201340:	1f468693          	addi	a3,a3,500 # ffffffffc0202530 <commands+0x8c8>
ffffffffc0201344:	00001617          	auipc	a2,0x1
ffffffffc0201348:	fa460613          	addi	a2,a2,-92 # ffffffffc02022e8 <commands+0x680>
ffffffffc020134c:	0ef00593          	li	a1,239
ffffffffc0201350:	00001517          	auipc	a0,0x1
ffffffffc0201354:	0c850513          	addi	a0,a0,200 # ffffffffc0202418 <commands+0x7b0>
ffffffffc0201358:	debfe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc020135c <buddy_init_memmap>:
{
ffffffffc020135c:	1141                	addi	sp,sp,-16
ffffffffc020135e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201360:	10058163          	beqz	a1,ffffffffc0201462 <buddy_init_memmap+0x106>
    for (; p != base + n; p++)
ffffffffc0201364:	00259693          	slli	a3,a1,0x2
ffffffffc0201368:	96ae                	add	a3,a3,a1
ffffffffc020136a:	068e                	slli	a3,a3,0x3
ffffffffc020136c:	96aa                	add	a3,a3,a0
ffffffffc020136e:	87aa                	mv	a5,a0
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201370:	4609                	li	a2,2
ffffffffc0201372:	02d50363          	beq	a0,a3,ffffffffc0201398 <buddy_init_memmap+0x3c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201376:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201378:	8b05                	andi	a4,a4,1
ffffffffc020137a:	c761                	beqz	a4,ffffffffc0201442 <buddy_init_memmap+0xe6>
        p->flags = p->property = 0;
ffffffffc020137c:	0007a823          	sw	zero,16(a5)
ffffffffc0201380:	0007b423          	sd	zero,8(a5)
ffffffffc0201384:	0007a023          	sw	zero,0(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201388:	00878713          	addi	a4,a5,8
ffffffffc020138c:	40c7302f          	amoor.d	zero,a2,(a4)
    for (; p != base + n; p++)
ffffffffc0201390:	02878793          	addi	a5,a5,40
ffffffffc0201394:	fed791e3          	bne	a5,a3,ffffffffc0201376 <buddy_init_memmap+0x1a>
    base->property = n;
ffffffffc0201398:	2581                	sext.w	a1,a1
ffffffffc020139a:	c90c                	sw	a1,16(a0)
ffffffffc020139c:	4689                	li	a3,2
ffffffffc020139e:	00850793          	addi	a5,a0,8
ffffffffc02013a2:	40d7b02f          	amoor.d	zero,a3,(a5)
    nr_free += n;
ffffffffc02013a6:	00005717          	auipc	a4,0x5
ffffffffc02013aa:	c8a70713          	addi	a4,a4,-886 # ffffffffc0206030 <free_area>
ffffffffc02013ae:	4b1c                	lw	a5,16(a4)
    base0 = base;
ffffffffc02013b0:	00005617          	auipc	a2,0x5
ffffffffc02013b4:	0ea63423          	sd	a0,232(a2) # ffffffffc0206498 <base0>
    while (tmp > 1)
ffffffffc02013b8:	4605                	li	a2,1
    nr_free += n;
ffffffffc02013ba:	9fad                	addw	a5,a5,a1
ffffffffc02013bc:	cb1c                	sw	a5,16(a4)
    double tmp = n;
ffffffffc02013be:	d21587d3          	fcvt.d.wu	fa5,a1
    while (tmp > 1)
ffffffffc02013c2:	06b67363          	bgeu	a2,a1,ffffffffc0201428 <buddy_init_memmap+0xcc>
    unsigned i = 0;
ffffffffc02013c6:	4781                	li	a5,0
ffffffffc02013c8:	00001717          	auipc	a4,0x1
ffffffffc02013cc:	43873687          	fld	fa3,1080(a4) # ffffffffc0202800 <error_string+0x38>
ffffffffc02013d0:	00001717          	auipc	a4,0x1
ffffffffc02013d4:	43873707          	fld	fa4,1080(a4) # ffffffffc0202808 <error_string+0x40>
        tmp /= 2;
ffffffffc02013d8:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc02013dc:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc02013de:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc02013e2:	fb7d                	bnez	a4,ffffffffc02013d8 <buddy_init_memmap+0x7c>
    length = 2 * (1 << (i));
ffffffffc02013e4:	4709                	li	a4,2
ffffffffc02013e6:	00f7163b          	sllw	a2,a4,a5
    buddy = (unsigned *)(base + length);
ffffffffc02013ea:	00261713          	slli	a4,a2,0x2
ffffffffc02013ee:	9732                	add	a4,a4,a2
ffffffffc02013f0:	070e                	slli	a4,a4,0x3
    length = 2 * (1 << (i));
ffffffffc02013f2:	00005597          	auipc	a1,0x5
ffffffffc02013f6:	0b658593          	addi	a1,a1,182 # ffffffffc02064a8 <length>
    buddy = (unsigned *)(base + length);
ffffffffc02013fa:	972a                	add	a4,a4,a0
    length = 2 * (1 << (i));
ffffffffc02013fc:	c190                	sw	a2,0(a1)
    buddy = (unsigned *)(base + length);
ffffffffc02013fe:	00005797          	auipc	a5,0x5
ffffffffc0201402:	0ae7b123          	sd	a4,162(a5) # ffffffffc02064a0 <buddy>
    for (i = 0; i < length; ++i)
ffffffffc0201406:	00c05e63          	blez	a2,ffffffffc0201422 <buddy_init_memmap+0xc6>
    unsigned node_size = length;
ffffffffc020140a:	4781                	li	a5,0
        if (is_power_of_2(i + 1))
ffffffffc020140c:	86be                	mv	a3,a5
ffffffffc020140e:	2785                	addiw	a5,a5,1
ffffffffc0201410:	8efd                	and	a3,a3,a5
ffffffffc0201412:	e299                	bnez	a3,ffffffffc0201418 <buddy_init_memmap+0xbc>
            node_size /= 2;
ffffffffc0201414:	0016561b          	srliw	a2,a2,0x1
        buddy[i] = node_size;
ffffffffc0201418:	c310                	sw	a2,0(a4)
    for (i = 0; i < length; ++i)
ffffffffc020141a:	4194                	lw	a3,0(a1)
ffffffffc020141c:	0711                	addi	a4,a4,4
ffffffffc020141e:	fed7c7e3          	blt	a5,a3,ffffffffc020140c <buddy_init_memmap+0xb0>
}
ffffffffc0201422:	60a2                	ld	ra,8(sp)
ffffffffc0201424:	0141                	addi	sp,sp,16
ffffffffc0201426:	8082                	ret
    length = 2 * (1 << (i));
ffffffffc0201428:	00005597          	auipc	a1,0x5
ffffffffc020142c:	08058593          	addi	a1,a1,128 # ffffffffc02064a8 <length>
    buddy = (unsigned *)(base + length);
ffffffffc0201430:	05050713          	addi	a4,a0,80
    length = 2 * (1 << (i));
ffffffffc0201434:	c194                	sw	a3,0(a1)
    buddy = (unsigned *)(base + length);
ffffffffc0201436:	00005797          	auipc	a5,0x5
ffffffffc020143a:	06e7b523          	sd	a4,106(a5) # ffffffffc02064a0 <buddy>
    unsigned node_size = length;
ffffffffc020143e:	4609                	li	a2,2
ffffffffc0201440:	b7e9                	j	ffffffffc020140a <buddy_init_memmap+0xae>
        assert(PageReserved(p));
ffffffffc0201442:	00001697          	auipc	a3,0x1
ffffffffc0201446:	11668693          	addi	a3,a3,278 # ffffffffc0202558 <commands+0x8f0>
ffffffffc020144a:	00001617          	auipc	a2,0x1
ffffffffc020144e:	e9e60613          	addi	a2,a2,-354 # ffffffffc02022e8 <commands+0x680>
ffffffffc0201452:	03000593          	li	a1,48
ffffffffc0201456:	00001517          	auipc	a0,0x1
ffffffffc020145a:	fc250513          	addi	a0,a0,-62 # ffffffffc0202418 <commands+0x7b0>
ffffffffc020145e:	ce5fe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(n > 0);
ffffffffc0201462:	00001697          	auipc	a3,0x1
ffffffffc0201466:	fae68693          	addi	a3,a3,-82 # ffffffffc0202410 <commands+0x7a8>
ffffffffc020146a:	00001617          	auipc	a2,0x1
ffffffffc020146e:	e7e60613          	addi	a2,a2,-386 # ffffffffc02022e8 <commands+0x680>
ffffffffc0201472:	02c00593          	li	a1,44
ffffffffc0201476:	00001517          	auipc	a0,0x1
ffffffffc020147a:	fa250513          	addi	a0,a0,-94 # ffffffffc0202418 <commands+0x7b0>
ffffffffc020147e:	cc5fe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0201482 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201482:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201484:	e589                	bnez	a1,ffffffffc020148e <strnlen+0xc>
ffffffffc0201486:	a811                	j	ffffffffc020149a <strnlen+0x18>
        cnt ++;
ffffffffc0201488:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020148a:	00f58863          	beq	a1,a5,ffffffffc020149a <strnlen+0x18>
ffffffffc020148e:	00f50733          	add	a4,a0,a5
ffffffffc0201492:	00074703          	lbu	a4,0(a4)
ffffffffc0201496:	fb6d                	bnez	a4,ffffffffc0201488 <strnlen+0x6>
ffffffffc0201498:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020149a:	852e                	mv	a0,a1
ffffffffc020149c:	8082                	ret

ffffffffc020149e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020149e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02014a2:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02014a6:	cb89                	beqz	a5,ffffffffc02014b8 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02014a8:	0505                	addi	a0,a0,1
ffffffffc02014aa:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02014ac:	fee789e3          	beq	a5,a4,ffffffffc020149e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02014b0:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02014b4:	9d19                	subw	a0,a0,a4
ffffffffc02014b6:	8082                	ret
ffffffffc02014b8:	4501                	li	a0,0
ffffffffc02014ba:	bfed                	j	ffffffffc02014b4 <strcmp+0x16>

ffffffffc02014bc <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02014bc:	00054783          	lbu	a5,0(a0)
ffffffffc02014c0:	c799                	beqz	a5,ffffffffc02014ce <strchr+0x12>
        if (*s == c) {
ffffffffc02014c2:	00f58763          	beq	a1,a5,ffffffffc02014d0 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02014c6:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02014ca:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02014cc:	fbfd                	bnez	a5,ffffffffc02014c2 <strchr+0x6>
    }
    return NULL;
ffffffffc02014ce:	4501                	li	a0,0
}
ffffffffc02014d0:	8082                	ret

ffffffffc02014d2 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02014d2:	ca01                	beqz	a2,ffffffffc02014e2 <memset+0x10>
ffffffffc02014d4:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02014d6:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02014d8:	0785                	addi	a5,a5,1
ffffffffc02014da:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02014de:	fec79de3          	bne	a5,a2,ffffffffc02014d8 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02014e2:	8082                	ret

ffffffffc02014e4 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02014e4:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02014e8:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02014ea:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02014ee:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02014f0:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02014f4:	f022                	sd	s0,32(sp)
ffffffffc02014f6:	ec26                	sd	s1,24(sp)
ffffffffc02014f8:	e84a                	sd	s2,16(sp)
ffffffffc02014fa:	f406                	sd	ra,40(sp)
ffffffffc02014fc:	e44e                	sd	s3,8(sp)
ffffffffc02014fe:	84aa                	mv	s1,a0
ffffffffc0201500:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201502:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201506:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201508:	03067e63          	bgeu	a2,a6,ffffffffc0201544 <printnum+0x60>
ffffffffc020150c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020150e:	00805763          	blez	s0,ffffffffc020151c <printnum+0x38>
ffffffffc0201512:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201514:	85ca                	mv	a1,s2
ffffffffc0201516:	854e                	mv	a0,s3
ffffffffc0201518:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020151a:	fc65                	bnez	s0,ffffffffc0201512 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020151c:	1a02                	slli	s4,s4,0x20
ffffffffc020151e:	00001797          	auipc	a5,0x1
ffffffffc0201522:	09a78793          	addi	a5,a5,154 # ffffffffc02025b8 <buddy_pmm_manager+0x38>
ffffffffc0201526:	020a5a13          	srli	s4,s4,0x20
ffffffffc020152a:	9a3e                	add	s4,s4,a5
}
ffffffffc020152c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020152e:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201532:	70a2                	ld	ra,40(sp)
ffffffffc0201534:	69a2                	ld	s3,8(sp)
ffffffffc0201536:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201538:	85ca                	mv	a1,s2
ffffffffc020153a:	87a6                	mv	a5,s1
}
ffffffffc020153c:	6942                	ld	s2,16(sp)
ffffffffc020153e:	64e2                	ld	s1,24(sp)
ffffffffc0201540:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201542:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201544:	03065633          	divu	a2,a2,a6
ffffffffc0201548:	8722                	mv	a4,s0
ffffffffc020154a:	f9bff0ef          	jal	ra,ffffffffc02014e4 <printnum>
ffffffffc020154e:	b7f9                	j	ffffffffc020151c <printnum+0x38>

ffffffffc0201550 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201550:	7119                	addi	sp,sp,-128
ffffffffc0201552:	f4a6                	sd	s1,104(sp)
ffffffffc0201554:	f0ca                	sd	s2,96(sp)
ffffffffc0201556:	ecce                	sd	s3,88(sp)
ffffffffc0201558:	e8d2                	sd	s4,80(sp)
ffffffffc020155a:	e4d6                	sd	s5,72(sp)
ffffffffc020155c:	e0da                	sd	s6,64(sp)
ffffffffc020155e:	fc5e                	sd	s7,56(sp)
ffffffffc0201560:	f06a                	sd	s10,32(sp)
ffffffffc0201562:	fc86                	sd	ra,120(sp)
ffffffffc0201564:	f8a2                	sd	s0,112(sp)
ffffffffc0201566:	f862                	sd	s8,48(sp)
ffffffffc0201568:	f466                	sd	s9,40(sp)
ffffffffc020156a:	ec6e                	sd	s11,24(sp)
ffffffffc020156c:	892a                	mv	s2,a0
ffffffffc020156e:	84ae                	mv	s1,a1
ffffffffc0201570:	8d32                	mv	s10,a2
ffffffffc0201572:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201574:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0201578:	5b7d                	li	s6,-1
ffffffffc020157a:	00001a97          	auipc	s5,0x1
ffffffffc020157e:	072a8a93          	addi	s5,s5,114 # ffffffffc02025ec <buddy_pmm_manager+0x6c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201582:	00001b97          	auipc	s7,0x1
ffffffffc0201586:	246b8b93          	addi	s7,s7,582 # ffffffffc02027c8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020158a:	000d4503          	lbu	a0,0(s10)
ffffffffc020158e:	001d0413          	addi	s0,s10,1
ffffffffc0201592:	01350a63          	beq	a0,s3,ffffffffc02015a6 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201596:	c121                	beqz	a0,ffffffffc02015d6 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0201598:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020159a:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020159c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020159e:	fff44503          	lbu	a0,-1(s0)
ffffffffc02015a2:	ff351ae3          	bne	a0,s3,ffffffffc0201596 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015a6:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02015aa:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02015ae:	4c81                	li	s9,0
ffffffffc02015b0:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02015b2:	5c7d                	li	s8,-1
ffffffffc02015b4:	5dfd                	li	s11,-1
ffffffffc02015b6:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02015ba:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015bc:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02015c0:	0ff5f593          	zext.b	a1,a1
ffffffffc02015c4:	00140d13          	addi	s10,s0,1
ffffffffc02015c8:	04b56263          	bltu	a0,a1,ffffffffc020160c <vprintfmt+0xbc>
ffffffffc02015cc:	058a                	slli	a1,a1,0x2
ffffffffc02015ce:	95d6                	add	a1,a1,s5
ffffffffc02015d0:	4194                	lw	a3,0(a1)
ffffffffc02015d2:	96d6                	add	a3,a3,s5
ffffffffc02015d4:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02015d6:	70e6                	ld	ra,120(sp)
ffffffffc02015d8:	7446                	ld	s0,112(sp)
ffffffffc02015da:	74a6                	ld	s1,104(sp)
ffffffffc02015dc:	7906                	ld	s2,96(sp)
ffffffffc02015de:	69e6                	ld	s3,88(sp)
ffffffffc02015e0:	6a46                	ld	s4,80(sp)
ffffffffc02015e2:	6aa6                	ld	s5,72(sp)
ffffffffc02015e4:	6b06                	ld	s6,64(sp)
ffffffffc02015e6:	7be2                	ld	s7,56(sp)
ffffffffc02015e8:	7c42                	ld	s8,48(sp)
ffffffffc02015ea:	7ca2                	ld	s9,40(sp)
ffffffffc02015ec:	7d02                	ld	s10,32(sp)
ffffffffc02015ee:	6de2                	ld	s11,24(sp)
ffffffffc02015f0:	6109                	addi	sp,sp,128
ffffffffc02015f2:	8082                	ret
            padc = '0';
ffffffffc02015f4:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02015f6:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015fa:	846a                	mv	s0,s10
ffffffffc02015fc:	00140d13          	addi	s10,s0,1
ffffffffc0201600:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201604:	0ff5f593          	zext.b	a1,a1
ffffffffc0201608:	fcb572e3          	bgeu	a0,a1,ffffffffc02015cc <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020160c:	85a6                	mv	a1,s1
ffffffffc020160e:	02500513          	li	a0,37
ffffffffc0201612:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201614:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201618:	8d22                	mv	s10,s0
ffffffffc020161a:	f73788e3          	beq	a5,s3,ffffffffc020158a <vprintfmt+0x3a>
ffffffffc020161e:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201622:	1d7d                	addi	s10,s10,-1
ffffffffc0201624:	ff379de3          	bne	a5,s3,ffffffffc020161e <vprintfmt+0xce>
ffffffffc0201628:	b78d                	j	ffffffffc020158a <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020162a:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020162e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201632:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201634:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201638:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020163c:	02d86463          	bltu	a6,a3,ffffffffc0201664 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201640:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201644:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201648:	0186873b          	addw	a4,a3,s8
ffffffffc020164c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201650:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201652:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201656:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201658:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020165c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201660:	fed870e3          	bgeu	a6,a3,ffffffffc0201640 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201664:	f40ddce3          	bgez	s11,ffffffffc02015bc <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201668:	8de2                	mv	s11,s8
ffffffffc020166a:	5c7d                	li	s8,-1
ffffffffc020166c:	bf81                	j	ffffffffc02015bc <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020166e:	fffdc693          	not	a3,s11
ffffffffc0201672:	96fd                	srai	a3,a3,0x3f
ffffffffc0201674:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201678:	00144603          	lbu	a2,1(s0)
ffffffffc020167c:	2d81                	sext.w	s11,s11
ffffffffc020167e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201680:	bf35                	j	ffffffffc02015bc <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201682:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201686:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020168a:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020168c:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020168e:	bfd9                	j	ffffffffc0201664 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201690:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201692:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201696:	01174463          	blt	a4,a7,ffffffffc020169e <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020169a:	1a088e63          	beqz	a7,ffffffffc0201856 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020169e:	000a3603          	ld	a2,0(s4)
ffffffffc02016a2:	46c1                	li	a3,16
ffffffffc02016a4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02016a6:	2781                	sext.w	a5,a5
ffffffffc02016a8:	876e                	mv	a4,s11
ffffffffc02016aa:	85a6                	mv	a1,s1
ffffffffc02016ac:	854a                	mv	a0,s2
ffffffffc02016ae:	e37ff0ef          	jal	ra,ffffffffc02014e4 <printnum>
            break;
ffffffffc02016b2:	bde1                	j	ffffffffc020158a <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02016b4:	000a2503          	lw	a0,0(s4)
ffffffffc02016b8:	85a6                	mv	a1,s1
ffffffffc02016ba:	0a21                	addi	s4,s4,8
ffffffffc02016bc:	9902                	jalr	s2
            break;
ffffffffc02016be:	b5f1                	j	ffffffffc020158a <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02016c0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016c2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02016c6:	01174463          	blt	a4,a7,ffffffffc02016ce <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02016ca:	18088163          	beqz	a7,ffffffffc020184c <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02016ce:	000a3603          	ld	a2,0(s4)
ffffffffc02016d2:	46a9                	li	a3,10
ffffffffc02016d4:	8a2e                	mv	s4,a1
ffffffffc02016d6:	bfc1                	j	ffffffffc02016a6 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016d8:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02016dc:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016de:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02016e0:	bdf1                	j	ffffffffc02015bc <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02016e2:	85a6                	mv	a1,s1
ffffffffc02016e4:	02500513          	li	a0,37
ffffffffc02016e8:	9902                	jalr	s2
            break;
ffffffffc02016ea:	b545                	j	ffffffffc020158a <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016ec:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02016f0:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016f2:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02016f4:	b5e1                	j	ffffffffc02015bc <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02016f6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016f8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02016fc:	01174463          	blt	a4,a7,ffffffffc0201704 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201700:	14088163          	beqz	a7,ffffffffc0201842 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201704:	000a3603          	ld	a2,0(s4)
ffffffffc0201708:	46a1                	li	a3,8
ffffffffc020170a:	8a2e                	mv	s4,a1
ffffffffc020170c:	bf69                	j	ffffffffc02016a6 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020170e:	03000513          	li	a0,48
ffffffffc0201712:	85a6                	mv	a1,s1
ffffffffc0201714:	e03e                	sd	a5,0(sp)
ffffffffc0201716:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201718:	85a6                	mv	a1,s1
ffffffffc020171a:	07800513          	li	a0,120
ffffffffc020171e:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201720:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201722:	6782                	ld	a5,0(sp)
ffffffffc0201724:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201726:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020172a:	bfb5                	j	ffffffffc02016a6 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020172c:	000a3403          	ld	s0,0(s4)
ffffffffc0201730:	008a0713          	addi	a4,s4,8
ffffffffc0201734:	e03a                	sd	a4,0(sp)
ffffffffc0201736:	14040263          	beqz	s0,ffffffffc020187a <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020173a:	0fb05763          	blez	s11,ffffffffc0201828 <vprintfmt+0x2d8>
ffffffffc020173e:	02d00693          	li	a3,45
ffffffffc0201742:	0cd79163          	bne	a5,a3,ffffffffc0201804 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201746:	00044783          	lbu	a5,0(s0)
ffffffffc020174a:	0007851b          	sext.w	a0,a5
ffffffffc020174e:	cf85                	beqz	a5,ffffffffc0201786 <vprintfmt+0x236>
ffffffffc0201750:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201754:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201758:	000c4563          	bltz	s8,ffffffffc0201762 <vprintfmt+0x212>
ffffffffc020175c:	3c7d                	addiw	s8,s8,-1
ffffffffc020175e:	036c0263          	beq	s8,s6,ffffffffc0201782 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201762:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201764:	0e0c8e63          	beqz	s9,ffffffffc0201860 <vprintfmt+0x310>
ffffffffc0201768:	3781                	addiw	a5,a5,-32
ffffffffc020176a:	0ef47b63          	bgeu	s0,a5,ffffffffc0201860 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020176e:	03f00513          	li	a0,63
ffffffffc0201772:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201774:	000a4783          	lbu	a5,0(s4)
ffffffffc0201778:	3dfd                	addiw	s11,s11,-1
ffffffffc020177a:	0a05                	addi	s4,s4,1
ffffffffc020177c:	0007851b          	sext.w	a0,a5
ffffffffc0201780:	ffe1                	bnez	a5,ffffffffc0201758 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201782:	01b05963          	blez	s11,ffffffffc0201794 <vprintfmt+0x244>
ffffffffc0201786:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201788:	85a6                	mv	a1,s1
ffffffffc020178a:	02000513          	li	a0,32
ffffffffc020178e:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201790:	fe0d9be3          	bnez	s11,ffffffffc0201786 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201794:	6a02                	ld	s4,0(sp)
ffffffffc0201796:	bbd5                	j	ffffffffc020158a <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201798:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020179a:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020179e:	01174463          	blt	a4,a7,ffffffffc02017a6 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02017a2:	08088d63          	beqz	a7,ffffffffc020183c <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02017a6:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02017aa:	0a044d63          	bltz	s0,ffffffffc0201864 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02017ae:	8622                	mv	a2,s0
ffffffffc02017b0:	8a66                	mv	s4,s9
ffffffffc02017b2:	46a9                	li	a3,10
ffffffffc02017b4:	bdcd                	j	ffffffffc02016a6 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02017b6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02017ba:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02017bc:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02017be:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02017c2:	8fb5                	xor	a5,a5,a3
ffffffffc02017c4:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02017c8:	02d74163          	blt	a4,a3,ffffffffc02017ea <vprintfmt+0x29a>
ffffffffc02017cc:	00369793          	slli	a5,a3,0x3
ffffffffc02017d0:	97de                	add	a5,a5,s7
ffffffffc02017d2:	639c                	ld	a5,0(a5)
ffffffffc02017d4:	cb99                	beqz	a5,ffffffffc02017ea <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02017d6:	86be                	mv	a3,a5
ffffffffc02017d8:	00001617          	auipc	a2,0x1
ffffffffc02017dc:	e1060613          	addi	a2,a2,-496 # ffffffffc02025e8 <buddy_pmm_manager+0x68>
ffffffffc02017e0:	85a6                	mv	a1,s1
ffffffffc02017e2:	854a                	mv	a0,s2
ffffffffc02017e4:	0ce000ef          	jal	ra,ffffffffc02018b2 <printfmt>
ffffffffc02017e8:	b34d                	j	ffffffffc020158a <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02017ea:	00001617          	auipc	a2,0x1
ffffffffc02017ee:	dee60613          	addi	a2,a2,-530 # ffffffffc02025d8 <buddy_pmm_manager+0x58>
ffffffffc02017f2:	85a6                	mv	a1,s1
ffffffffc02017f4:	854a                	mv	a0,s2
ffffffffc02017f6:	0bc000ef          	jal	ra,ffffffffc02018b2 <printfmt>
ffffffffc02017fa:	bb41                	j	ffffffffc020158a <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02017fc:	00001417          	auipc	s0,0x1
ffffffffc0201800:	dd440413          	addi	s0,s0,-556 # ffffffffc02025d0 <buddy_pmm_manager+0x50>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201804:	85e2                	mv	a1,s8
ffffffffc0201806:	8522                	mv	a0,s0
ffffffffc0201808:	e43e                	sd	a5,8(sp)
ffffffffc020180a:	c79ff0ef          	jal	ra,ffffffffc0201482 <strnlen>
ffffffffc020180e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201812:	01b05b63          	blez	s11,ffffffffc0201828 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201816:	67a2                	ld	a5,8(sp)
ffffffffc0201818:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020181c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020181e:	85a6                	mv	a1,s1
ffffffffc0201820:	8552                	mv	a0,s4
ffffffffc0201822:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201824:	fe0d9ce3          	bnez	s11,ffffffffc020181c <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201828:	00044783          	lbu	a5,0(s0)
ffffffffc020182c:	00140a13          	addi	s4,s0,1
ffffffffc0201830:	0007851b          	sext.w	a0,a5
ffffffffc0201834:	d3a5                	beqz	a5,ffffffffc0201794 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201836:	05e00413          	li	s0,94
ffffffffc020183a:	bf39                	j	ffffffffc0201758 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020183c:	000a2403          	lw	s0,0(s4)
ffffffffc0201840:	b7ad                	j	ffffffffc02017aa <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201842:	000a6603          	lwu	a2,0(s4)
ffffffffc0201846:	46a1                	li	a3,8
ffffffffc0201848:	8a2e                	mv	s4,a1
ffffffffc020184a:	bdb1                	j	ffffffffc02016a6 <vprintfmt+0x156>
ffffffffc020184c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201850:	46a9                	li	a3,10
ffffffffc0201852:	8a2e                	mv	s4,a1
ffffffffc0201854:	bd89                	j	ffffffffc02016a6 <vprintfmt+0x156>
ffffffffc0201856:	000a6603          	lwu	a2,0(s4)
ffffffffc020185a:	46c1                	li	a3,16
ffffffffc020185c:	8a2e                	mv	s4,a1
ffffffffc020185e:	b5a1                	j	ffffffffc02016a6 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201860:	9902                	jalr	s2
ffffffffc0201862:	bf09                	j	ffffffffc0201774 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201864:	85a6                	mv	a1,s1
ffffffffc0201866:	02d00513          	li	a0,45
ffffffffc020186a:	e03e                	sd	a5,0(sp)
ffffffffc020186c:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020186e:	6782                	ld	a5,0(sp)
ffffffffc0201870:	8a66                	mv	s4,s9
ffffffffc0201872:	40800633          	neg	a2,s0
ffffffffc0201876:	46a9                	li	a3,10
ffffffffc0201878:	b53d                	j	ffffffffc02016a6 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020187a:	03b05163          	blez	s11,ffffffffc020189c <vprintfmt+0x34c>
ffffffffc020187e:	02d00693          	li	a3,45
ffffffffc0201882:	f6d79de3          	bne	a5,a3,ffffffffc02017fc <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201886:	00001417          	auipc	s0,0x1
ffffffffc020188a:	d4a40413          	addi	s0,s0,-694 # ffffffffc02025d0 <buddy_pmm_manager+0x50>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020188e:	02800793          	li	a5,40
ffffffffc0201892:	02800513          	li	a0,40
ffffffffc0201896:	00140a13          	addi	s4,s0,1
ffffffffc020189a:	bd6d                	j	ffffffffc0201754 <vprintfmt+0x204>
ffffffffc020189c:	00001a17          	auipc	s4,0x1
ffffffffc02018a0:	d35a0a13          	addi	s4,s4,-715 # ffffffffc02025d1 <buddy_pmm_manager+0x51>
ffffffffc02018a4:	02800513          	li	a0,40
ffffffffc02018a8:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02018ac:	05e00413          	li	s0,94
ffffffffc02018b0:	b565                	j	ffffffffc0201758 <vprintfmt+0x208>

ffffffffc02018b2 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018b2:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02018b4:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018b8:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02018ba:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018bc:	ec06                	sd	ra,24(sp)
ffffffffc02018be:	f83a                	sd	a4,48(sp)
ffffffffc02018c0:	fc3e                	sd	a5,56(sp)
ffffffffc02018c2:	e0c2                	sd	a6,64(sp)
ffffffffc02018c4:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02018c6:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02018c8:	c89ff0ef          	jal	ra,ffffffffc0201550 <vprintfmt>
}
ffffffffc02018cc:	60e2                	ld	ra,24(sp)
ffffffffc02018ce:	6161                	addi	sp,sp,80
ffffffffc02018d0:	8082                	ret

ffffffffc02018d2 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02018d2:	715d                	addi	sp,sp,-80
ffffffffc02018d4:	e486                	sd	ra,72(sp)
ffffffffc02018d6:	e0a6                	sd	s1,64(sp)
ffffffffc02018d8:	fc4a                	sd	s2,56(sp)
ffffffffc02018da:	f84e                	sd	s3,48(sp)
ffffffffc02018dc:	f452                	sd	s4,40(sp)
ffffffffc02018de:	f056                	sd	s5,32(sp)
ffffffffc02018e0:	ec5a                	sd	s6,24(sp)
ffffffffc02018e2:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02018e4:	c901                	beqz	a0,ffffffffc02018f4 <readline+0x22>
ffffffffc02018e6:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02018e8:	00001517          	auipc	a0,0x1
ffffffffc02018ec:	d0050513          	addi	a0,a0,-768 # ffffffffc02025e8 <buddy_pmm_manager+0x68>
ffffffffc02018f0:	fcafe0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc02018f4:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02018f6:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02018f8:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02018fa:	4aa9                	li	s5,10
ffffffffc02018fc:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02018fe:	00004b97          	auipc	s7,0x4
ffffffffc0201902:	74ab8b93          	addi	s7,s7,1866 # ffffffffc0206048 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201906:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc020190a:	829fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc020190e:	00054a63          	bltz	a0,ffffffffc0201922 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201912:	00a95a63          	bge	s2,a0,ffffffffc0201926 <readline+0x54>
ffffffffc0201916:	029a5263          	bge	s4,s1,ffffffffc020193a <readline+0x68>
        c = getchar();
ffffffffc020191a:	819fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc020191e:	fe055ae3          	bgez	a0,ffffffffc0201912 <readline+0x40>
            return NULL;
ffffffffc0201922:	4501                	li	a0,0
ffffffffc0201924:	a091                	j	ffffffffc0201968 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201926:	03351463          	bne	a0,s3,ffffffffc020194e <readline+0x7c>
ffffffffc020192a:	e8a9                	bnez	s1,ffffffffc020197c <readline+0xaa>
        c = getchar();
ffffffffc020192c:	807fe0ef          	jal	ra,ffffffffc0200132 <getchar>
        if (c < 0) {
ffffffffc0201930:	fe0549e3          	bltz	a0,ffffffffc0201922 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201934:	fea959e3          	bge	s2,a0,ffffffffc0201926 <readline+0x54>
ffffffffc0201938:	4481                	li	s1,0
            cputchar(c);
ffffffffc020193a:	e42a                	sd	a0,8(sp)
ffffffffc020193c:	fb4fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc0201940:	6522                	ld	a0,8(sp)
ffffffffc0201942:	009b87b3          	add	a5,s7,s1
ffffffffc0201946:	2485                	addiw	s1,s1,1
ffffffffc0201948:	00a78023          	sb	a0,0(a5)
ffffffffc020194c:	bf7d                	j	ffffffffc020190a <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020194e:	01550463          	beq	a0,s5,ffffffffc0201956 <readline+0x84>
ffffffffc0201952:	fb651ce3          	bne	a0,s6,ffffffffc020190a <readline+0x38>
            cputchar(c);
ffffffffc0201956:	f9afe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc020195a:	00004517          	auipc	a0,0x4
ffffffffc020195e:	6ee50513          	addi	a0,a0,1774 # ffffffffc0206048 <buf>
ffffffffc0201962:	94aa                	add	s1,s1,a0
ffffffffc0201964:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0201968:	60a6                	ld	ra,72(sp)
ffffffffc020196a:	6486                	ld	s1,64(sp)
ffffffffc020196c:	7962                	ld	s2,56(sp)
ffffffffc020196e:	79c2                	ld	s3,48(sp)
ffffffffc0201970:	7a22                	ld	s4,40(sp)
ffffffffc0201972:	7a82                	ld	s5,32(sp)
ffffffffc0201974:	6b62                	ld	s6,24(sp)
ffffffffc0201976:	6bc2                	ld	s7,16(sp)
ffffffffc0201978:	6161                	addi	sp,sp,80
ffffffffc020197a:	8082                	ret
            cputchar(c);
ffffffffc020197c:	4521                	li	a0,8
ffffffffc020197e:	f72fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc0201982:	34fd                	addiw	s1,s1,-1
ffffffffc0201984:	b759                	j	ffffffffc020190a <readline+0x38>

ffffffffc0201986 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201986:	4781                	li	a5,0
ffffffffc0201988:	00004717          	auipc	a4,0x4
ffffffffc020198c:	69873703          	ld	a4,1688(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201990:	88ba                	mv	a7,a4
ffffffffc0201992:	852a                	mv	a0,a0
ffffffffc0201994:	85be                	mv	a1,a5
ffffffffc0201996:	863e                	mv	a2,a5
ffffffffc0201998:	00000073          	ecall
ffffffffc020199c:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc020199e:	8082                	ret

ffffffffc02019a0 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc02019a0:	4781                	li	a5,0
ffffffffc02019a2:	00005717          	auipc	a4,0x5
ffffffffc02019a6:	b0e73703          	ld	a4,-1266(a4) # ffffffffc02064b0 <SBI_SET_TIMER>
ffffffffc02019aa:	88ba                	mv	a7,a4
ffffffffc02019ac:	852a                	mv	a0,a0
ffffffffc02019ae:	85be                	mv	a1,a5
ffffffffc02019b0:	863e                	mv	a2,a5
ffffffffc02019b2:	00000073          	ecall
ffffffffc02019b6:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc02019b8:	8082                	ret

ffffffffc02019ba <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc02019ba:	4501                	li	a0,0
ffffffffc02019bc:	00004797          	auipc	a5,0x4
ffffffffc02019c0:	65c7b783          	ld	a5,1628(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc02019c4:	88be                	mv	a7,a5
ffffffffc02019c6:	852a                	mv	a0,a0
ffffffffc02019c8:	85aa                	mv	a1,a0
ffffffffc02019ca:	862a                	mv	a2,a0
ffffffffc02019cc:	00000073          	ecall
ffffffffc02019d0:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc02019d2:	2501                	sext.w	a0,a0
ffffffffc02019d4:	8082                	ret

ffffffffc02019d6 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc02019d6:	4781                	li	a5,0
ffffffffc02019d8:	00004717          	auipc	a4,0x4
ffffffffc02019dc:	65073703          	ld	a4,1616(a4) # ffffffffc0206028 <SBI_SHUTDOWN>
ffffffffc02019e0:	88ba                	mv	a7,a4
ffffffffc02019e2:	853e                	mv	a0,a5
ffffffffc02019e4:	85be                	mv	a1,a5
ffffffffc02019e6:	863e                	mv	a2,a5
ffffffffc02019e8:	00000073          	ecall
ffffffffc02019ec:	87aa                	mv	a5,a0
void sbi_shutdown(void)
{
    sbi_call(SBI_SHUTDOWN,0,0,0);
ffffffffc02019ee:	8082                	ret
