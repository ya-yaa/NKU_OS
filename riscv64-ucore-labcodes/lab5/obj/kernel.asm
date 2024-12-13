
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc0200024:	c020b137          	lui	sp,0xc020b

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

int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	000a7517          	auipc	a0,0xa7
ffffffffc0200036:	2d650513          	addi	a0,a0,726 # ffffffffc02a7308 <buf>
ffffffffc020003a:	000b3617          	auipc	a2,0xb3
ffffffffc020003e:	82a60613          	addi	a2,a2,-2006 # ffffffffc02b2864 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	572060ef          	jal	ra,ffffffffc02065bc <memset>
    cons_init();                // init the console
ffffffffc020004e:	52a000ef          	jal	ra,ffffffffc0200578 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00006597          	auipc	a1,0x6
ffffffffc0200056:	59658593          	addi	a1,a1,1430 # ffffffffc02065e8 <etext+0x2>
ffffffffc020005a:	00006517          	auipc	a0,0x6
ffffffffc020005e:	5ae50513          	addi	a0,a0,1454 # ffffffffc0206608 <etext+0x22>
ffffffffc0200062:	11e000ef          	jal	ra,ffffffffc0200180 <cprintf>

    print_kerninfo();
ffffffffc0200066:	1a2000ef          	jal	ra,ffffffffc0200208 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006a:	508020ef          	jal	ra,ffffffffc0202572 <pmm_init>

    pic_init();                 // init interrupt controller
ffffffffc020006e:	5de000ef          	jal	ra,ffffffffc020064c <pic_init>
    idt_init();                 // init interrupt descriptor table
ffffffffc0200072:	5dc000ef          	jal	ra,ffffffffc020064e <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc0200076:	438040ef          	jal	ra,ffffffffc02044ae <vmm_init>
    proc_init();                // init process table
ffffffffc020007a:	4bd050ef          	jal	ra,ffffffffc0205d36 <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc020007e:	56c000ef          	jal	ra,ffffffffc02005ea <ide_init>
    swap_init();                // init swap
ffffffffc0200082:	396030ef          	jal	ra,ffffffffc0203418 <swap_init>

    clock_init();               // init clock interrupt
ffffffffc0200086:	4a0000ef          	jal	ra,ffffffffc0200526 <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc020008a:	5b6000ef          	jal	ra,ffffffffc0200640 <intr_enable>
    
    cpu_idle();                 // run idle process
ffffffffc020008e:	63f050ef          	jal	ra,ffffffffc0205ecc <cpu_idle>

ffffffffc0200092 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0200092:	715d                	addi	sp,sp,-80
ffffffffc0200094:	e486                	sd	ra,72(sp)
ffffffffc0200096:	e0a6                	sd	s1,64(sp)
ffffffffc0200098:	fc4a                	sd	s2,56(sp)
ffffffffc020009a:	f84e                	sd	s3,48(sp)
ffffffffc020009c:	f452                	sd	s4,40(sp)
ffffffffc020009e:	f056                	sd	s5,32(sp)
ffffffffc02000a0:	ec5a                	sd	s6,24(sp)
ffffffffc02000a2:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000a4:	c901                	beqz	a0,ffffffffc02000b4 <readline+0x22>
ffffffffc02000a6:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000a8:	00006517          	auipc	a0,0x6
ffffffffc02000ac:	56850513          	addi	a0,a0,1384 # ffffffffc0206610 <etext+0x2a>
ffffffffc02000b0:	0d0000ef          	jal	ra,ffffffffc0200180 <cprintf>
readline(const char *prompt) {
ffffffffc02000b4:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000b6:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000b8:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ba:	4aa9                	li	s5,10
ffffffffc02000bc:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000be:	000a7b97          	auipc	s7,0xa7
ffffffffc02000c2:	24ab8b93          	addi	s7,s7,586 # ffffffffc02a7308 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c6:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000ca:	12e000ef          	jal	ra,ffffffffc02001f8 <getchar>
        if (c < 0) {
ffffffffc02000ce:	00054a63          	bltz	a0,ffffffffc02000e2 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d2:	00a95a63          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000d6:	029a5263          	bge	s4,s1,ffffffffc02000fa <readline+0x68>
        c = getchar();
ffffffffc02000da:	11e000ef          	jal	ra,ffffffffc02001f8 <getchar>
        if (c < 0) {
ffffffffc02000de:	fe055ae3          	bgez	a0,ffffffffc02000d2 <readline+0x40>
            return NULL;
ffffffffc02000e2:	4501                	li	a0,0
ffffffffc02000e4:	a091                	j	ffffffffc0200128 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000e6:	03351463          	bne	a0,s3,ffffffffc020010e <readline+0x7c>
ffffffffc02000ea:	e8a9                	bnez	s1,ffffffffc020013c <readline+0xaa>
        c = getchar();
ffffffffc02000ec:	10c000ef          	jal	ra,ffffffffc02001f8 <getchar>
        if (c < 0) {
ffffffffc02000f0:	fe0549e3          	bltz	a0,ffffffffc02000e2 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000f4:	fea959e3          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000f8:	4481                	li	s1,0
            cputchar(c);
ffffffffc02000fa:	e42a                	sd	a0,8(sp)
ffffffffc02000fc:	0ba000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            buf[i ++] = c;
ffffffffc0200100:	6522                	ld	a0,8(sp)
ffffffffc0200102:	009b87b3          	add	a5,s7,s1
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	00a78023          	sb	a0,0(a5)
ffffffffc020010c:	bf7d                	j	ffffffffc02000ca <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020010e:	01550463          	beq	a0,s5,ffffffffc0200116 <readline+0x84>
ffffffffc0200112:	fb651ce3          	bne	a0,s6,ffffffffc02000ca <readline+0x38>
            cputchar(c);
ffffffffc0200116:	0a0000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            buf[i] = '\0';
ffffffffc020011a:	000a7517          	auipc	a0,0xa7
ffffffffc020011e:	1ee50513          	addi	a0,a0,494 # ffffffffc02a7308 <buf>
ffffffffc0200122:	94aa                	add	s1,s1,a0
ffffffffc0200124:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200128:	60a6                	ld	ra,72(sp)
ffffffffc020012a:	6486                	ld	s1,64(sp)
ffffffffc020012c:	7962                	ld	s2,56(sp)
ffffffffc020012e:	79c2                	ld	s3,48(sp)
ffffffffc0200130:	7a22                	ld	s4,40(sp)
ffffffffc0200132:	7a82                	ld	s5,32(sp)
ffffffffc0200134:	6b62                	ld	s6,24(sp)
ffffffffc0200136:	6bc2                	ld	s7,16(sp)
ffffffffc0200138:	6161                	addi	sp,sp,80
ffffffffc020013a:	8082                	ret
            cputchar(c);
ffffffffc020013c:	4521                	li	a0,8
ffffffffc020013e:	078000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            i --;
ffffffffc0200142:	34fd                	addiw	s1,s1,-1
ffffffffc0200144:	b759                	j	ffffffffc02000ca <readline+0x38>

ffffffffc0200146 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200146:	1141                	addi	sp,sp,-16
ffffffffc0200148:	e022                	sd	s0,0(sp)
ffffffffc020014a:	e406                	sd	ra,8(sp)
ffffffffc020014c:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020014e:	42c000ef          	jal	ra,ffffffffc020057a <cons_putc>
    (*cnt) ++;
ffffffffc0200152:	401c                	lw	a5,0(s0)
}
ffffffffc0200154:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200156:	2785                	addiw	a5,a5,1
ffffffffc0200158:	c01c                	sw	a5,0(s0)
}
ffffffffc020015a:	6402                	ld	s0,0(sp)
ffffffffc020015c:	0141                	addi	sp,sp,16
ffffffffc020015e:	8082                	ret

ffffffffc0200160 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200160:	1101                	addi	sp,sp,-32
ffffffffc0200162:	862a                	mv	a2,a0
ffffffffc0200164:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200166:	00000517          	auipc	a0,0x0
ffffffffc020016a:	fe050513          	addi	a0,a0,-32 # ffffffffc0200146 <cputch>
ffffffffc020016e:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200170:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200172:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200174:	04a060ef          	jal	ra,ffffffffc02061be <vprintfmt>
    return cnt;
}
ffffffffc0200178:	60e2                	ld	ra,24(sp)
ffffffffc020017a:	4532                	lw	a0,12(sp)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200180:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200182:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200186:	8e2a                	mv	t3,a0
ffffffffc0200188:	f42e                	sd	a1,40(sp)
ffffffffc020018a:	f832                	sd	a2,48(sp)
ffffffffc020018c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020018e:	00000517          	auipc	a0,0x0
ffffffffc0200192:	fb850513          	addi	a0,a0,-72 # ffffffffc0200146 <cputch>
ffffffffc0200196:	004c                	addi	a1,sp,4
ffffffffc0200198:	869a                	mv	a3,t1
ffffffffc020019a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc020019c:	ec06                	sd	ra,24(sp)
ffffffffc020019e:	e0ba                	sd	a4,64(sp)
ffffffffc02001a0:	e4be                	sd	a5,72(sp)
ffffffffc02001a2:	e8c2                	sd	a6,80(sp)
ffffffffc02001a4:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001a6:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001a8:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02001aa:	014060ef          	jal	ra,ffffffffc02061be <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001ae:	60e2                	ld	ra,24(sp)
ffffffffc02001b0:	4512                	lw	a0,4(sp)
ffffffffc02001b2:	6125                	addi	sp,sp,96
ffffffffc02001b4:	8082                	ret

ffffffffc02001b6 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02001b6:	a6d1                	j	ffffffffc020057a <cons_putc>

ffffffffc02001b8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02001b8:	1101                	addi	sp,sp,-32
ffffffffc02001ba:	e822                	sd	s0,16(sp)
ffffffffc02001bc:	ec06                	sd	ra,24(sp)
ffffffffc02001be:	e426                	sd	s1,8(sp)
ffffffffc02001c0:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02001c2:	00054503          	lbu	a0,0(a0)
ffffffffc02001c6:	c51d                	beqz	a0,ffffffffc02001f4 <cputs+0x3c>
ffffffffc02001c8:	0405                	addi	s0,s0,1
ffffffffc02001ca:	4485                	li	s1,1
ffffffffc02001cc:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001ce:	3ac000ef          	jal	ra,ffffffffc020057a <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001d2:	00044503          	lbu	a0,0(s0)
ffffffffc02001d6:	008487bb          	addw	a5,s1,s0
ffffffffc02001da:	0405                	addi	s0,s0,1
ffffffffc02001dc:	f96d                	bnez	a0,ffffffffc02001ce <cputs+0x16>
    (*cnt) ++;
ffffffffc02001de:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001e2:	4529                	li	a0,10
ffffffffc02001e4:	396000ef          	jal	ra,ffffffffc020057a <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001e8:	60e2                	ld	ra,24(sp)
ffffffffc02001ea:	8522                	mv	a0,s0
ffffffffc02001ec:	6442                	ld	s0,16(sp)
ffffffffc02001ee:	64a2                	ld	s1,8(sp)
ffffffffc02001f0:	6105                	addi	sp,sp,32
ffffffffc02001f2:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001f4:	4405                	li	s0,1
ffffffffc02001f6:	b7f5                	j	ffffffffc02001e2 <cputs+0x2a>

ffffffffc02001f8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001f8:	1141                	addi	sp,sp,-16
ffffffffc02001fa:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001fc:	3b2000ef          	jal	ra,ffffffffc02005ae <cons_getc>
ffffffffc0200200:	dd75                	beqz	a0,ffffffffc02001fc <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200202:	60a2                	ld	ra,8(sp)
ffffffffc0200204:	0141                	addi	sp,sp,16
ffffffffc0200206:	8082                	ret

ffffffffc0200208 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200208:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020020a:	00006517          	auipc	a0,0x6
ffffffffc020020e:	40e50513          	addi	a0,a0,1038 # ffffffffc0206618 <etext+0x32>
void print_kerninfo(void) {
ffffffffc0200212:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200214:	f6dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200218:	00000597          	auipc	a1,0x0
ffffffffc020021c:	e1a58593          	addi	a1,a1,-486 # ffffffffc0200032 <kern_init>
ffffffffc0200220:	00006517          	auipc	a0,0x6
ffffffffc0200224:	41850513          	addi	a0,a0,1048 # ffffffffc0206638 <etext+0x52>
ffffffffc0200228:	f59ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020022c:	00006597          	auipc	a1,0x6
ffffffffc0200230:	3ba58593          	addi	a1,a1,954 # ffffffffc02065e6 <etext>
ffffffffc0200234:	00006517          	auipc	a0,0x6
ffffffffc0200238:	42450513          	addi	a0,a0,1060 # ffffffffc0206658 <etext+0x72>
ffffffffc020023c:	f45ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200240:	000a7597          	auipc	a1,0xa7
ffffffffc0200244:	0c858593          	addi	a1,a1,200 # ffffffffc02a7308 <buf>
ffffffffc0200248:	00006517          	auipc	a0,0x6
ffffffffc020024c:	43050513          	addi	a0,a0,1072 # ffffffffc0206678 <etext+0x92>
ffffffffc0200250:	f31ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200254:	000b2597          	auipc	a1,0xb2
ffffffffc0200258:	61058593          	addi	a1,a1,1552 # ffffffffc02b2864 <end>
ffffffffc020025c:	00006517          	auipc	a0,0x6
ffffffffc0200260:	43c50513          	addi	a0,a0,1084 # ffffffffc0206698 <etext+0xb2>
ffffffffc0200264:	f1dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200268:	000b3597          	auipc	a1,0xb3
ffffffffc020026c:	9fb58593          	addi	a1,a1,-1541 # ffffffffc02b2c63 <end+0x3ff>
ffffffffc0200270:	00000797          	auipc	a5,0x0
ffffffffc0200274:	dc278793          	addi	a5,a5,-574 # ffffffffc0200032 <kern_init>
ffffffffc0200278:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020027c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200280:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200282:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200286:	95be                	add	a1,a1,a5
ffffffffc0200288:	85a9                	srai	a1,a1,0xa
ffffffffc020028a:	00006517          	auipc	a0,0x6
ffffffffc020028e:	42e50513          	addi	a0,a0,1070 # ffffffffc02066b8 <etext+0xd2>
}
ffffffffc0200292:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	b5f5                	j	ffffffffc0200180 <cprintf>

ffffffffc0200296 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200296:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200298:	00006617          	auipc	a2,0x6
ffffffffc020029c:	45060613          	addi	a2,a2,1104 # ffffffffc02066e8 <etext+0x102>
ffffffffc02002a0:	04d00593          	li	a1,77
ffffffffc02002a4:	00006517          	auipc	a0,0x6
ffffffffc02002a8:	45c50513          	addi	a0,a0,1116 # ffffffffc0206700 <etext+0x11a>
void print_stackframe(void) {
ffffffffc02002ac:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ae:	1cc000ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02002b2 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b2:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002b4:	00006617          	auipc	a2,0x6
ffffffffc02002b8:	46460613          	addi	a2,a2,1124 # ffffffffc0206718 <etext+0x132>
ffffffffc02002bc:	00006597          	auipc	a1,0x6
ffffffffc02002c0:	47c58593          	addi	a1,a1,1148 # ffffffffc0206738 <etext+0x152>
ffffffffc02002c4:	00006517          	auipc	a0,0x6
ffffffffc02002c8:	47c50513          	addi	a0,a0,1148 # ffffffffc0206740 <etext+0x15a>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ce:	eb3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02002d2:	00006617          	auipc	a2,0x6
ffffffffc02002d6:	47e60613          	addi	a2,a2,1150 # ffffffffc0206750 <etext+0x16a>
ffffffffc02002da:	00006597          	auipc	a1,0x6
ffffffffc02002de:	49e58593          	addi	a1,a1,1182 # ffffffffc0206778 <etext+0x192>
ffffffffc02002e2:	00006517          	auipc	a0,0x6
ffffffffc02002e6:	45e50513          	addi	a0,a0,1118 # ffffffffc0206740 <etext+0x15a>
ffffffffc02002ea:	e97ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02002ee:	00006617          	auipc	a2,0x6
ffffffffc02002f2:	49a60613          	addi	a2,a2,1178 # ffffffffc0206788 <etext+0x1a2>
ffffffffc02002f6:	00006597          	auipc	a1,0x6
ffffffffc02002fa:	4b258593          	addi	a1,a1,1202 # ffffffffc02067a8 <etext+0x1c2>
ffffffffc02002fe:	00006517          	auipc	a0,0x6
ffffffffc0200302:	44250513          	addi	a0,a0,1090 # ffffffffc0206740 <etext+0x15a>
ffffffffc0200306:	e7bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    }
    return 0;
}
ffffffffc020030a:	60a2                	ld	ra,8(sp)
ffffffffc020030c:	4501                	li	a0,0
ffffffffc020030e:	0141                	addi	sp,sp,16
ffffffffc0200310:	8082                	ret

ffffffffc0200312 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200312:	1141                	addi	sp,sp,-16
ffffffffc0200314:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200316:	ef3ff0ef          	jal	ra,ffffffffc0200208 <print_kerninfo>
    return 0;
}
ffffffffc020031a:	60a2                	ld	ra,8(sp)
ffffffffc020031c:	4501                	li	a0,0
ffffffffc020031e:	0141                	addi	sp,sp,16
ffffffffc0200320:	8082                	ret

ffffffffc0200322 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200322:	1141                	addi	sp,sp,-16
ffffffffc0200324:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200326:	f71ff0ef          	jal	ra,ffffffffc0200296 <print_stackframe>
    return 0;
}
ffffffffc020032a:	60a2                	ld	ra,8(sp)
ffffffffc020032c:	4501                	li	a0,0
ffffffffc020032e:	0141                	addi	sp,sp,16
ffffffffc0200330:	8082                	ret

ffffffffc0200332 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200332:	7115                	addi	sp,sp,-224
ffffffffc0200334:	ed5e                	sd	s7,152(sp)
ffffffffc0200336:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200338:	00006517          	auipc	a0,0x6
ffffffffc020033c:	48050513          	addi	a0,a0,1152 # ffffffffc02067b8 <etext+0x1d2>
kmonitor(struct trapframe *tf) {
ffffffffc0200340:	ed86                	sd	ra,216(sp)
ffffffffc0200342:	e9a2                	sd	s0,208(sp)
ffffffffc0200344:	e5a6                	sd	s1,200(sp)
ffffffffc0200346:	e1ca                	sd	s2,192(sp)
ffffffffc0200348:	fd4e                	sd	s3,184(sp)
ffffffffc020034a:	f952                	sd	s4,176(sp)
ffffffffc020034c:	f556                	sd	s5,168(sp)
ffffffffc020034e:	f15a                	sd	s6,160(sp)
ffffffffc0200350:	e962                	sd	s8,144(sp)
ffffffffc0200352:	e566                	sd	s9,136(sp)
ffffffffc0200354:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200356:	e2bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020035a:	00006517          	auipc	a0,0x6
ffffffffc020035e:	48650513          	addi	a0,a0,1158 # ffffffffc02067e0 <etext+0x1fa>
ffffffffc0200362:	e1fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    if (tf != NULL) {
ffffffffc0200366:	000b8563          	beqz	s7,ffffffffc0200370 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020036a:	855e                	mv	a0,s7
ffffffffc020036c:	4c8000ef          	jal	ra,ffffffffc0200834 <print_trapframe>
ffffffffc0200370:	00006c17          	auipc	s8,0x6
ffffffffc0200374:	4e0c0c13          	addi	s8,s8,1248 # ffffffffc0206850 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200378:	00006917          	auipc	s2,0x6
ffffffffc020037c:	49090913          	addi	s2,s2,1168 # ffffffffc0206808 <etext+0x222>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200380:	00006497          	auipc	s1,0x6
ffffffffc0200384:	49048493          	addi	s1,s1,1168 # ffffffffc0206810 <etext+0x22a>
        if (argc == MAXARGS - 1) {
ffffffffc0200388:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020038a:	00006b17          	auipc	s6,0x6
ffffffffc020038e:	48eb0b13          	addi	s6,s6,1166 # ffffffffc0206818 <etext+0x232>
        argv[argc ++] = buf;
ffffffffc0200392:	00006a17          	auipc	s4,0x6
ffffffffc0200396:	3a6a0a13          	addi	s4,s4,934 # ffffffffc0206738 <etext+0x152>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039a:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020039c:	854a                	mv	a0,s2
ffffffffc020039e:	cf5ff0ef          	jal	ra,ffffffffc0200092 <readline>
ffffffffc02003a2:	842a                	mv	s0,a0
ffffffffc02003a4:	dd65                	beqz	a0,ffffffffc020039c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a6:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003aa:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ac:	e1bd                	bnez	a1,ffffffffc0200412 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02003ae:	fe0c87e3          	beqz	s9,ffffffffc020039c <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003b2:	6582                	ld	a1,0(sp)
ffffffffc02003b4:	00006d17          	auipc	s10,0x6
ffffffffc02003b8:	49cd0d13          	addi	s10,s10,1180 # ffffffffc0206850 <commands>
        argv[argc ++] = buf;
ffffffffc02003bc:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003be:	4401                	li	s0,0
ffffffffc02003c0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003c2:	1c6060ef          	jal	ra,ffffffffc0206588 <strcmp>
ffffffffc02003c6:	c919                	beqz	a0,ffffffffc02003dc <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003c8:	2405                	addiw	s0,s0,1
ffffffffc02003ca:	0b540063          	beq	s0,s5,ffffffffc020046a <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ce:	000d3503          	ld	a0,0(s10)
ffffffffc02003d2:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003d6:	1b2060ef          	jal	ra,ffffffffc0206588 <strcmp>
ffffffffc02003da:	f57d                	bnez	a0,ffffffffc02003c8 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003dc:	00141793          	slli	a5,s0,0x1
ffffffffc02003e0:	97a2                	add	a5,a5,s0
ffffffffc02003e2:	078e                	slli	a5,a5,0x3
ffffffffc02003e4:	97e2                	add	a5,a5,s8
ffffffffc02003e6:	6b9c                	ld	a5,16(a5)
ffffffffc02003e8:	865e                	mv	a2,s7
ffffffffc02003ea:	002c                	addi	a1,sp,8
ffffffffc02003ec:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003f0:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003f2:	fa0555e3          	bgez	a0,ffffffffc020039c <kmonitor+0x6a>
}
ffffffffc02003f6:	60ee                	ld	ra,216(sp)
ffffffffc02003f8:	644e                	ld	s0,208(sp)
ffffffffc02003fa:	64ae                	ld	s1,200(sp)
ffffffffc02003fc:	690e                	ld	s2,192(sp)
ffffffffc02003fe:	79ea                	ld	s3,184(sp)
ffffffffc0200400:	7a4a                	ld	s4,176(sp)
ffffffffc0200402:	7aaa                	ld	s5,168(sp)
ffffffffc0200404:	7b0a                	ld	s6,160(sp)
ffffffffc0200406:	6bea                	ld	s7,152(sp)
ffffffffc0200408:	6c4a                	ld	s8,144(sp)
ffffffffc020040a:	6caa                	ld	s9,136(sp)
ffffffffc020040c:	6d0a                	ld	s10,128(sp)
ffffffffc020040e:	612d                	addi	sp,sp,224
ffffffffc0200410:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200412:	8526                	mv	a0,s1
ffffffffc0200414:	192060ef          	jal	ra,ffffffffc02065a6 <strchr>
ffffffffc0200418:	c901                	beqz	a0,ffffffffc0200428 <kmonitor+0xf6>
ffffffffc020041a:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc020041e:	00040023          	sb	zero,0(s0)
ffffffffc0200422:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200424:	d5c9                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc0200426:	b7f5                	j	ffffffffc0200412 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200428:	00044783          	lbu	a5,0(s0)
ffffffffc020042c:	d3c9                	beqz	a5,ffffffffc02003ae <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc020042e:	033c8963          	beq	s9,s3,ffffffffc0200460 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200432:	003c9793          	slli	a5,s9,0x3
ffffffffc0200436:	0118                	addi	a4,sp,128
ffffffffc0200438:	97ba                	add	a5,a5,a4
ffffffffc020043a:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020043e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200442:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200444:	e591                	bnez	a1,ffffffffc0200450 <kmonitor+0x11e>
ffffffffc0200446:	b7b5                	j	ffffffffc02003b2 <kmonitor+0x80>
ffffffffc0200448:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020044c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020044e:	d1a5                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc0200450:	8526                	mv	a0,s1
ffffffffc0200452:	154060ef          	jal	ra,ffffffffc02065a6 <strchr>
ffffffffc0200456:	d96d                	beqz	a0,ffffffffc0200448 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200458:	00044583          	lbu	a1,0(s0)
ffffffffc020045c:	d9a9                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc020045e:	bf55                	j	ffffffffc0200412 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200460:	45c1                	li	a1,16
ffffffffc0200462:	855a                	mv	a0,s6
ffffffffc0200464:	d1dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200468:	b7e9                	j	ffffffffc0200432 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020046a:	6582                	ld	a1,0(sp)
ffffffffc020046c:	00006517          	auipc	a0,0x6
ffffffffc0200470:	3cc50513          	addi	a0,a0,972 # ffffffffc0206838 <etext+0x252>
ffffffffc0200474:	d0dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    return 0;
ffffffffc0200478:	b715                	j	ffffffffc020039c <kmonitor+0x6a>

ffffffffc020047a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020047a:	000b2317          	auipc	t1,0xb2
ffffffffc020047e:	35630313          	addi	t1,t1,854 # ffffffffc02b27d0 <is_panic>
ffffffffc0200482:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200486:	715d                	addi	sp,sp,-80
ffffffffc0200488:	ec06                	sd	ra,24(sp)
ffffffffc020048a:	e822                	sd	s0,16(sp)
ffffffffc020048c:	f436                	sd	a3,40(sp)
ffffffffc020048e:	f83a                	sd	a4,48(sp)
ffffffffc0200490:	fc3e                	sd	a5,56(sp)
ffffffffc0200492:	e0c2                	sd	a6,64(sp)
ffffffffc0200494:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200496:	020e1a63          	bnez	t3,ffffffffc02004ca <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020049a:	4785                	li	a5,1
ffffffffc020049c:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004a0:	8432                	mv	s0,a2
ffffffffc02004a2:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004a4:	862e                	mv	a2,a1
ffffffffc02004a6:	85aa                	mv	a1,a0
ffffffffc02004a8:	00006517          	auipc	a0,0x6
ffffffffc02004ac:	3f050513          	addi	a0,a0,1008 # ffffffffc0206898 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004b0:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b2:	ccfff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004b6:	65a2                	ld	a1,8(sp)
ffffffffc02004b8:	8522                	mv	a0,s0
ffffffffc02004ba:	ca7ff0ef          	jal	ra,ffffffffc0200160 <vcprintf>
    cprintf("\n");
ffffffffc02004be:	00007517          	auipc	a0,0x7
ffffffffc02004c2:	39250513          	addi	a0,a0,914 # ffffffffc0207850 <default_pmm_manager+0x518>
ffffffffc02004c6:	cbbff0ef          	jal	ra,ffffffffc0200180 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004ca:	4501                	li	a0,0
ffffffffc02004cc:	4581                	li	a1,0
ffffffffc02004ce:	4601                	li	a2,0
ffffffffc02004d0:	48a1                	li	a7,8
ffffffffc02004d2:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004d6:	170000ef          	jal	ra,ffffffffc0200646 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004da:	4501                	li	a0,0
ffffffffc02004dc:	e57ff0ef          	jal	ra,ffffffffc0200332 <kmonitor>
    while (1) {
ffffffffc02004e0:	bfed                	j	ffffffffc02004da <__panic+0x60>

ffffffffc02004e2 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004e2:	715d                	addi	sp,sp,-80
ffffffffc02004e4:	832e                	mv	t1,a1
ffffffffc02004e6:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004e8:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004ea:	8432                	mv	s0,a2
ffffffffc02004ec:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ee:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc02004f0:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004f2:	00006517          	auipc	a0,0x6
ffffffffc02004f6:	3c650513          	addi	a0,a0,966 # ffffffffc02068b8 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004fa:	ec06                	sd	ra,24(sp)
ffffffffc02004fc:	f436                	sd	a3,40(sp)
ffffffffc02004fe:	f83a                	sd	a4,48(sp)
ffffffffc0200500:	e0c2                	sd	a6,64(sp)
ffffffffc0200502:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200504:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	c7bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020050a:	65a2                	ld	a1,8(sp)
ffffffffc020050c:	8522                	mv	a0,s0
ffffffffc020050e:	c53ff0ef          	jal	ra,ffffffffc0200160 <vcprintf>
    cprintf("\n");
ffffffffc0200512:	00007517          	auipc	a0,0x7
ffffffffc0200516:	33e50513          	addi	a0,a0,830 # ffffffffc0207850 <default_pmm_manager+0x518>
ffffffffc020051a:	c67ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    va_end(ap);
}
ffffffffc020051e:	60e2                	ld	ra,24(sp)
ffffffffc0200520:	6442                	ld	s0,16(sp)
ffffffffc0200522:	6161                	addi	sp,sp,80
ffffffffc0200524:	8082                	ret

ffffffffc0200526 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200526:	67e1                	lui	a5,0x18
ffffffffc0200528:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd578>
ffffffffc020052c:	000b2717          	auipc	a4,0xb2
ffffffffc0200530:	2af73a23          	sd	a5,692(a4) # ffffffffc02b27e0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200534:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200538:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020053a:	953e                	add	a0,a0,a5
ffffffffc020053c:	4601                	li	a2,0
ffffffffc020053e:	4881                	li	a7,0
ffffffffc0200540:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200544:	02000793          	li	a5,32
ffffffffc0200548:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020054c:	00006517          	auipc	a0,0x6
ffffffffc0200550:	38c50513          	addi	a0,a0,908 # ffffffffc02068d8 <commands+0x88>
    ticks = 0;
ffffffffc0200554:	000b2797          	auipc	a5,0xb2
ffffffffc0200558:	2807b223          	sd	zero,644(a5) # ffffffffc02b27d8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020055c:	b115                	j	ffffffffc0200180 <cprintf>

ffffffffc020055e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020055e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200562:	000b2797          	auipc	a5,0xb2
ffffffffc0200566:	27e7b783          	ld	a5,638(a5) # ffffffffc02b27e0 <timebase>
ffffffffc020056a:	953e                	add	a0,a0,a5
ffffffffc020056c:	4581                	li	a1,0
ffffffffc020056e:	4601                	li	a2,0
ffffffffc0200570:	4881                	li	a7,0
ffffffffc0200572:	00000073          	ecall
ffffffffc0200576:	8082                	ret

ffffffffc0200578 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200578:	8082                	ret

ffffffffc020057a <cons_putc>:
#include <sched.h>
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020057a:	100027f3          	csrr	a5,sstatus
ffffffffc020057e:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200580:	0ff57513          	andi	a0,a0,255
ffffffffc0200584:	e799                	bnez	a5,ffffffffc0200592 <cons_putc+0x18>
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4885                	li	a7,1
ffffffffc020058c:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200590:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200592:	1101                	addi	sp,sp,-32
ffffffffc0200594:	ec06                	sd	ra,24(sp)
ffffffffc0200596:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200598:	0ae000ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc020059c:	6522                	ld	a0,8(sp)
ffffffffc020059e:	4581                	li	a1,0
ffffffffc02005a0:	4601                	li	a2,0
ffffffffc02005a2:	4885                	li	a7,1
ffffffffc02005a4:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005a8:	60e2                	ld	ra,24(sp)
ffffffffc02005aa:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02005ac:	a851                	j	ffffffffc0200640 <intr_enable>

ffffffffc02005ae <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02005ae:	100027f3          	csrr	a5,sstatus
ffffffffc02005b2:	8b89                	andi	a5,a5,2
ffffffffc02005b4:	eb89                	bnez	a5,ffffffffc02005c6 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005b6:	4501                	li	a0,0
ffffffffc02005b8:	4581                	li	a1,0
ffffffffc02005ba:	4601                	li	a2,0
ffffffffc02005bc:	4889                	li	a7,2
ffffffffc02005be:	00000073          	ecall
ffffffffc02005c2:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005c4:	8082                	ret
int cons_getc(void) {
ffffffffc02005c6:	1101                	addi	sp,sp,-32
ffffffffc02005c8:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005ca:	07c000ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc02005ce:	4501                	li	a0,0
ffffffffc02005d0:	4581                	li	a1,0
ffffffffc02005d2:	4601                	li	a2,0
ffffffffc02005d4:	4889                	li	a7,2
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	2501                	sext.w	a0,a0
ffffffffc02005dc:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005de:	062000ef          	jal	ra,ffffffffc0200640 <intr_enable>
}
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6522                	ld	a0,8(sp)
ffffffffc02005e6:	6105                	addi	sp,sp,32
ffffffffc02005e8:	8082                	ret

ffffffffc02005ea <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02005ea:	8082                	ret

ffffffffc02005ec <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02005ec:	00253513          	sltiu	a0,a0,2
ffffffffc02005f0:	8082                	ret

ffffffffc02005f2 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02005f2:	03800513          	li	a0,56
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005f8:	000a7797          	auipc	a5,0xa7
ffffffffc02005fc:	11078793          	addi	a5,a5,272 # ffffffffc02a7708 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc0200600:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc0200604:	1141                	addi	sp,sp,-16
ffffffffc0200606:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200608:	95be                	add	a1,a1,a5
ffffffffc020060a:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc020060e:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200610:	7bf050ef          	jal	ra,ffffffffc02065ce <memcpy>
    return 0;
}
ffffffffc0200614:	60a2                	ld	ra,8(sp)
ffffffffc0200616:	4501                	li	a0,0
ffffffffc0200618:	0141                	addi	sp,sp,16
ffffffffc020061a:	8082                	ret

ffffffffc020061c <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc020061c:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200620:	000a7517          	auipc	a0,0xa7
ffffffffc0200624:	0e850513          	addi	a0,a0,232 # ffffffffc02a7708 <ide>
                   size_t nsecs) {
ffffffffc0200628:	1141                	addi	sp,sp,-16
ffffffffc020062a:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020062c:	953e                	add	a0,a0,a5
ffffffffc020062e:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc0200632:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200634:	79b050ef          	jal	ra,ffffffffc02065ce <memcpy>
    return 0;
}
ffffffffc0200638:	60a2                	ld	ra,8(sp)
ffffffffc020063a:	4501                	li	a0,0
ffffffffc020063c:	0141                	addi	sp,sp,16
ffffffffc020063e:	8082                	ret

ffffffffc0200640 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200640:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200644:	8082                	ret

ffffffffc0200646 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200646:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020064a:	8082                	ret

ffffffffc020064c <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020064c:	8082                	ret

ffffffffc020064e <idt_init>:
void
idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020064e:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200652:	00000797          	auipc	a5,0x0
ffffffffc0200656:	65a78793          	addi	a5,a5,1626 # ffffffffc0200cac <__alltraps>
ffffffffc020065a:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020065e:	000407b7          	lui	a5,0x40
ffffffffc0200662:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200666:	8082                	ret

ffffffffc0200668 <print_regs>:
    cprintf("  tval 0x%08x\n", tf->tval);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs* gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200668:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs* gpr) {
ffffffffc020066a:	1141                	addi	sp,sp,-16
ffffffffc020066c:	e022                	sd	s0,0(sp)
ffffffffc020066e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200670:	00006517          	auipc	a0,0x6
ffffffffc0200674:	28850513          	addi	a0,a0,648 # ffffffffc02068f8 <commands+0xa8>
void print_regs(struct pushregs* gpr) {
ffffffffc0200678:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020067a:	b07ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020067e:	640c                	ld	a1,8(s0)
ffffffffc0200680:	00006517          	auipc	a0,0x6
ffffffffc0200684:	29050513          	addi	a0,a0,656 # ffffffffc0206910 <commands+0xc0>
ffffffffc0200688:	af9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020068c:	680c                	ld	a1,16(s0)
ffffffffc020068e:	00006517          	auipc	a0,0x6
ffffffffc0200692:	29a50513          	addi	a0,a0,666 # ffffffffc0206928 <commands+0xd8>
ffffffffc0200696:	aebff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020069a:	6c0c                	ld	a1,24(s0)
ffffffffc020069c:	00006517          	auipc	a0,0x6
ffffffffc02006a0:	2a450513          	addi	a0,a0,676 # ffffffffc0206940 <commands+0xf0>
ffffffffc02006a4:	addff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02006a8:	700c                	ld	a1,32(s0)
ffffffffc02006aa:	00006517          	auipc	a0,0x6
ffffffffc02006ae:	2ae50513          	addi	a0,a0,686 # ffffffffc0206958 <commands+0x108>
ffffffffc02006b2:	acfff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02006b6:	740c                	ld	a1,40(s0)
ffffffffc02006b8:	00006517          	auipc	a0,0x6
ffffffffc02006bc:	2b850513          	addi	a0,a0,696 # ffffffffc0206970 <commands+0x120>
ffffffffc02006c0:	ac1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02006c4:	780c                	ld	a1,48(s0)
ffffffffc02006c6:	00006517          	auipc	a0,0x6
ffffffffc02006ca:	2c250513          	addi	a0,a0,706 # ffffffffc0206988 <commands+0x138>
ffffffffc02006ce:	ab3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02006d2:	7c0c                	ld	a1,56(s0)
ffffffffc02006d4:	00006517          	auipc	a0,0x6
ffffffffc02006d8:	2cc50513          	addi	a0,a0,716 # ffffffffc02069a0 <commands+0x150>
ffffffffc02006dc:	aa5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02006e0:	602c                	ld	a1,64(s0)
ffffffffc02006e2:	00006517          	auipc	a0,0x6
ffffffffc02006e6:	2d650513          	addi	a0,a0,726 # ffffffffc02069b8 <commands+0x168>
ffffffffc02006ea:	a97ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006ee:	642c                	ld	a1,72(s0)
ffffffffc02006f0:	00006517          	auipc	a0,0x6
ffffffffc02006f4:	2e050513          	addi	a0,a0,736 # ffffffffc02069d0 <commands+0x180>
ffffffffc02006f8:	a89ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02006fc:	682c                	ld	a1,80(s0)
ffffffffc02006fe:	00006517          	auipc	a0,0x6
ffffffffc0200702:	2ea50513          	addi	a0,a0,746 # ffffffffc02069e8 <commands+0x198>
ffffffffc0200706:	a7bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020070a:	6c2c                	ld	a1,88(s0)
ffffffffc020070c:	00006517          	auipc	a0,0x6
ffffffffc0200710:	2f450513          	addi	a0,a0,756 # ffffffffc0206a00 <commands+0x1b0>
ffffffffc0200714:	a6dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200718:	702c                	ld	a1,96(s0)
ffffffffc020071a:	00006517          	auipc	a0,0x6
ffffffffc020071e:	2fe50513          	addi	a0,a0,766 # ffffffffc0206a18 <commands+0x1c8>
ffffffffc0200722:	a5fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200726:	742c                	ld	a1,104(s0)
ffffffffc0200728:	00006517          	auipc	a0,0x6
ffffffffc020072c:	30850513          	addi	a0,a0,776 # ffffffffc0206a30 <commands+0x1e0>
ffffffffc0200730:	a51ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200734:	782c                	ld	a1,112(s0)
ffffffffc0200736:	00006517          	auipc	a0,0x6
ffffffffc020073a:	31250513          	addi	a0,a0,786 # ffffffffc0206a48 <commands+0x1f8>
ffffffffc020073e:	a43ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200742:	7c2c                	ld	a1,120(s0)
ffffffffc0200744:	00006517          	auipc	a0,0x6
ffffffffc0200748:	31c50513          	addi	a0,a0,796 # ffffffffc0206a60 <commands+0x210>
ffffffffc020074c:	a35ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200750:	604c                	ld	a1,128(s0)
ffffffffc0200752:	00006517          	auipc	a0,0x6
ffffffffc0200756:	32650513          	addi	a0,a0,806 # ffffffffc0206a78 <commands+0x228>
ffffffffc020075a:	a27ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020075e:	644c                	ld	a1,136(s0)
ffffffffc0200760:	00006517          	auipc	a0,0x6
ffffffffc0200764:	33050513          	addi	a0,a0,816 # ffffffffc0206a90 <commands+0x240>
ffffffffc0200768:	a19ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020076c:	684c                	ld	a1,144(s0)
ffffffffc020076e:	00006517          	auipc	a0,0x6
ffffffffc0200772:	33a50513          	addi	a0,a0,826 # ffffffffc0206aa8 <commands+0x258>
ffffffffc0200776:	a0bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020077a:	6c4c                	ld	a1,152(s0)
ffffffffc020077c:	00006517          	auipc	a0,0x6
ffffffffc0200780:	34450513          	addi	a0,a0,836 # ffffffffc0206ac0 <commands+0x270>
ffffffffc0200784:	9fdff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200788:	704c                	ld	a1,160(s0)
ffffffffc020078a:	00006517          	auipc	a0,0x6
ffffffffc020078e:	34e50513          	addi	a0,a0,846 # ffffffffc0206ad8 <commands+0x288>
ffffffffc0200792:	9efff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200796:	744c                	ld	a1,168(s0)
ffffffffc0200798:	00006517          	auipc	a0,0x6
ffffffffc020079c:	35850513          	addi	a0,a0,856 # ffffffffc0206af0 <commands+0x2a0>
ffffffffc02007a0:	9e1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02007a4:	784c                	ld	a1,176(s0)
ffffffffc02007a6:	00006517          	auipc	a0,0x6
ffffffffc02007aa:	36250513          	addi	a0,a0,866 # ffffffffc0206b08 <commands+0x2b8>
ffffffffc02007ae:	9d3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02007b2:	7c4c                	ld	a1,184(s0)
ffffffffc02007b4:	00006517          	auipc	a0,0x6
ffffffffc02007b8:	36c50513          	addi	a0,a0,876 # ffffffffc0206b20 <commands+0x2d0>
ffffffffc02007bc:	9c5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02007c0:	606c                	ld	a1,192(s0)
ffffffffc02007c2:	00006517          	auipc	a0,0x6
ffffffffc02007c6:	37650513          	addi	a0,a0,886 # ffffffffc0206b38 <commands+0x2e8>
ffffffffc02007ca:	9b7ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02007ce:	646c                	ld	a1,200(s0)
ffffffffc02007d0:	00006517          	auipc	a0,0x6
ffffffffc02007d4:	38050513          	addi	a0,a0,896 # ffffffffc0206b50 <commands+0x300>
ffffffffc02007d8:	9a9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02007dc:	686c                	ld	a1,208(s0)
ffffffffc02007de:	00006517          	auipc	a0,0x6
ffffffffc02007e2:	38a50513          	addi	a0,a0,906 # ffffffffc0206b68 <commands+0x318>
ffffffffc02007e6:	99bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007ea:	6c6c                	ld	a1,216(s0)
ffffffffc02007ec:	00006517          	auipc	a0,0x6
ffffffffc02007f0:	39450513          	addi	a0,a0,916 # ffffffffc0206b80 <commands+0x330>
ffffffffc02007f4:	98dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007f8:	706c                	ld	a1,224(s0)
ffffffffc02007fa:	00006517          	auipc	a0,0x6
ffffffffc02007fe:	39e50513          	addi	a0,a0,926 # ffffffffc0206b98 <commands+0x348>
ffffffffc0200802:	97fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200806:	746c                	ld	a1,232(s0)
ffffffffc0200808:	00006517          	auipc	a0,0x6
ffffffffc020080c:	3a850513          	addi	a0,a0,936 # ffffffffc0206bb0 <commands+0x360>
ffffffffc0200810:	971ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200814:	786c                	ld	a1,240(s0)
ffffffffc0200816:	00006517          	auipc	a0,0x6
ffffffffc020081a:	3b250513          	addi	a0,a0,946 # ffffffffc0206bc8 <commands+0x378>
ffffffffc020081e:	963ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200822:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200824:	6402                	ld	s0,0(sp)
ffffffffc0200826:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200828:	00006517          	auipc	a0,0x6
ffffffffc020082c:	3b850513          	addi	a0,a0,952 # ffffffffc0206be0 <commands+0x390>
}
ffffffffc0200830:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200832:	b2b9                	j	ffffffffc0200180 <cprintf>

ffffffffc0200834 <print_trapframe>:
print_trapframe(struct trapframe *tf) {
ffffffffc0200834:	1141                	addi	sp,sp,-16
ffffffffc0200836:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200838:	85aa                	mv	a1,a0
print_trapframe(struct trapframe *tf) {
ffffffffc020083a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020083c:	00006517          	auipc	a0,0x6
ffffffffc0200840:	3bc50513          	addi	a0,a0,956 # ffffffffc0206bf8 <commands+0x3a8>
print_trapframe(struct trapframe *tf) {
ffffffffc0200844:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200846:	93bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    print_regs(&tf->gpr);
ffffffffc020084a:	8522                	mv	a0,s0
ffffffffc020084c:	e1dff0ef          	jal	ra,ffffffffc0200668 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200850:	10043583          	ld	a1,256(s0)
ffffffffc0200854:	00006517          	auipc	a0,0x6
ffffffffc0200858:	3bc50513          	addi	a0,a0,956 # ffffffffc0206c10 <commands+0x3c0>
ffffffffc020085c:	925ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200860:	10843583          	ld	a1,264(s0)
ffffffffc0200864:	00006517          	auipc	a0,0x6
ffffffffc0200868:	3c450513          	addi	a0,a0,964 # ffffffffc0206c28 <commands+0x3d8>
ffffffffc020086c:	915ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200870:	11043583          	ld	a1,272(s0)
ffffffffc0200874:	00006517          	auipc	a0,0x6
ffffffffc0200878:	3cc50513          	addi	a0,a0,972 # ffffffffc0206c40 <commands+0x3f0>
ffffffffc020087c:	905ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200880:	11843583          	ld	a1,280(s0)
}
ffffffffc0200884:	6402                	ld	s0,0(sp)
ffffffffc0200886:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200888:	00006517          	auipc	a0,0x6
ffffffffc020088c:	3c850513          	addi	a0,a0,968 # ffffffffc0206c50 <commands+0x400>
}
ffffffffc0200890:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200892:	8efff06f          	j	ffffffffc0200180 <cprintf>

ffffffffc0200896 <pgfault_handler>:
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int
pgfault_handler(struct trapframe *tf) {
ffffffffc0200896:	1101                	addi	sp,sp,-32
ffffffffc0200898:	e426                	sd	s1,8(sp)
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
ffffffffc020089a:	000b2497          	auipc	s1,0xb2
ffffffffc020089e:	f9e48493          	addi	s1,s1,-98 # ffffffffc02b2838 <check_mm_struct>
ffffffffc02008a2:	609c                	ld	a5,0(s1)
pgfault_handler(struct trapframe *tf) {
ffffffffc02008a4:	e822                	sd	s0,16(sp)
ffffffffc02008a6:	ec06                	sd	ra,24(sp)
ffffffffc02008a8:	842a                	mv	s0,a0
    if(check_mm_struct !=NULL) { //used for test check_swap
ffffffffc02008aa:	cbad                	beqz	a5,ffffffffc020091c <pgfault_handler+0x86>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02008ac:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008b0:	11053583          	ld	a1,272(a0)
ffffffffc02008b4:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02008b8:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008bc:	c7b1                	beqz	a5,ffffffffc0200908 <pgfault_handler+0x72>
ffffffffc02008be:	11843703          	ld	a4,280(s0)
ffffffffc02008c2:	47bd                	li	a5,15
ffffffffc02008c4:	05700693          	li	a3,87
ffffffffc02008c8:	00f70463          	beq	a4,a5,ffffffffc02008d0 <pgfault_handler+0x3a>
ffffffffc02008cc:	05200693          	li	a3,82
ffffffffc02008d0:	00006517          	auipc	a0,0x6
ffffffffc02008d4:	39850513          	addi	a0,a0,920 # ffffffffc0206c68 <commands+0x418>
ffffffffc02008d8:	8a9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            print_pgfault(tf);
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
ffffffffc02008dc:	6088                	ld	a0,0(s1)
ffffffffc02008de:	cd1d                	beqz	a0,ffffffffc020091c <pgfault_handler+0x86>
        assert(current == idleproc);
ffffffffc02008e0:	000b2717          	auipc	a4,0xb2
ffffffffc02008e4:	f6873703          	ld	a4,-152(a4) # ffffffffc02b2848 <current>
ffffffffc02008e8:	000b2797          	auipc	a5,0xb2
ffffffffc02008ec:	f687b783          	ld	a5,-152(a5) # ffffffffc02b2850 <idleproc>
ffffffffc02008f0:	04f71663          	bne	a4,a5,ffffffffc020093c <pgfault_handler+0xa6>
            print_pgfault(tf);
            panic("unhandled page fault.\n");
        }
        mm = current->mm;
    }
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008f4:	11043603          	ld	a2,272(s0)
ffffffffc02008f8:	11843583          	ld	a1,280(s0)
}
ffffffffc02008fc:	6442                	ld	s0,16(sp)
ffffffffc02008fe:	60e2                	ld	ra,24(sp)
ffffffffc0200900:	64a2                	ld	s1,8(sp)
ffffffffc0200902:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200904:	0ea0406f          	j	ffffffffc02049ee <do_pgfault>
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200908:	11843703          	ld	a4,280(s0)
ffffffffc020090c:	47bd                	li	a5,15
ffffffffc020090e:	05500613          	li	a2,85
ffffffffc0200912:	05700693          	li	a3,87
ffffffffc0200916:	faf71be3          	bne	a4,a5,ffffffffc02008cc <pgfault_handler+0x36>
ffffffffc020091a:	bf5d                	j	ffffffffc02008d0 <pgfault_handler+0x3a>
        if (current == NULL) {
ffffffffc020091c:	000b2797          	auipc	a5,0xb2
ffffffffc0200920:	f2c7b783          	ld	a5,-212(a5) # ffffffffc02b2848 <current>
ffffffffc0200924:	cf85                	beqz	a5,ffffffffc020095c <pgfault_handler+0xc6>
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200926:	11043603          	ld	a2,272(s0)
ffffffffc020092a:	11843583          	ld	a1,280(s0)
}
ffffffffc020092e:	6442                	ld	s0,16(sp)
ffffffffc0200930:	60e2                	ld	ra,24(sp)
ffffffffc0200932:	64a2                	ld	s1,8(sp)
        mm = current->mm;
ffffffffc0200934:	7788                	ld	a0,40(a5)
}
ffffffffc0200936:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200938:	0b60406f          	j	ffffffffc02049ee <do_pgfault>
        assert(current == idleproc);
ffffffffc020093c:	00006697          	auipc	a3,0x6
ffffffffc0200940:	34c68693          	addi	a3,a3,844 # ffffffffc0206c88 <commands+0x438>
ffffffffc0200944:	00006617          	auipc	a2,0x6
ffffffffc0200948:	35c60613          	addi	a2,a2,860 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020094c:	06b00593          	li	a1,107
ffffffffc0200950:	00006517          	auipc	a0,0x6
ffffffffc0200954:	36850513          	addi	a0,a0,872 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200958:	b23ff0ef          	jal	ra,ffffffffc020047a <__panic>
            print_trapframe(tf);
ffffffffc020095c:	8522                	mv	a0,s0
ffffffffc020095e:	ed7ff0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200962:	10043783          	ld	a5,256(s0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200966:	11043583          	ld	a1,272(s0)
ffffffffc020096a:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020096e:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200972:	e399                	bnez	a5,ffffffffc0200978 <pgfault_handler+0xe2>
ffffffffc0200974:	05500613          	li	a2,85
ffffffffc0200978:	11843703          	ld	a4,280(s0)
ffffffffc020097c:	47bd                	li	a5,15
ffffffffc020097e:	02f70663          	beq	a4,a5,ffffffffc02009aa <pgfault_handler+0x114>
ffffffffc0200982:	05200693          	li	a3,82
ffffffffc0200986:	00006517          	auipc	a0,0x6
ffffffffc020098a:	2e250513          	addi	a0,a0,738 # ffffffffc0206c68 <commands+0x418>
ffffffffc020098e:	ff2ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            panic("unhandled page fault.\n");
ffffffffc0200992:	00006617          	auipc	a2,0x6
ffffffffc0200996:	33e60613          	addi	a2,a2,830 # ffffffffc0206cd0 <commands+0x480>
ffffffffc020099a:	07200593          	li	a1,114
ffffffffc020099e:	00006517          	auipc	a0,0x6
ffffffffc02009a2:	31a50513          	addi	a0,a0,794 # ffffffffc0206cb8 <commands+0x468>
ffffffffc02009a6:	ad5ff0ef          	jal	ra,ffffffffc020047a <__panic>
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02009aa:	05700693          	li	a3,87
ffffffffc02009ae:	bfe1                	j	ffffffffc0200986 <pgfault_handler+0xf0>

ffffffffc02009b0 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02009b0:	11853783          	ld	a5,280(a0)
ffffffffc02009b4:	472d                	li	a4,11
ffffffffc02009b6:	0786                	slli	a5,a5,0x1
ffffffffc02009b8:	8385                	srli	a5,a5,0x1
ffffffffc02009ba:	08f76363          	bltu	a4,a5,ffffffffc0200a40 <interrupt_handler+0x90>
ffffffffc02009be:	00006717          	auipc	a4,0x6
ffffffffc02009c2:	3ca70713          	addi	a4,a4,970 # ffffffffc0206d88 <commands+0x538>
ffffffffc02009c6:	078a                	slli	a5,a5,0x2
ffffffffc02009c8:	97ba                	add	a5,a5,a4
ffffffffc02009ca:	439c                	lw	a5,0(a5)
ffffffffc02009cc:	97ba                	add	a5,a5,a4
ffffffffc02009ce:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02009d0:	00006517          	auipc	a0,0x6
ffffffffc02009d4:	37850513          	addi	a0,a0,888 # ffffffffc0206d48 <commands+0x4f8>
ffffffffc02009d8:	fa8ff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02009dc:	00006517          	auipc	a0,0x6
ffffffffc02009e0:	34c50513          	addi	a0,a0,844 # ffffffffc0206d28 <commands+0x4d8>
ffffffffc02009e4:	f9cff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02009e8:	00006517          	auipc	a0,0x6
ffffffffc02009ec:	30050513          	addi	a0,a0,768 # ffffffffc0206ce8 <commands+0x498>
ffffffffc02009f0:	f90ff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02009f4:	00006517          	auipc	a0,0x6
ffffffffc02009f8:	31450513          	addi	a0,a0,788 # ffffffffc0206d08 <commands+0x4b8>
ffffffffc02009fc:	f84ff06f          	j	ffffffffc0200180 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a00:	1141                	addi	sp,sp,-16
ffffffffc0200a02:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc0200a04:	b5bff0ef          	jal	ra,ffffffffc020055e <clock_set_next_event>
            if (++ticks % TICK_NUM == 0 && current) {
ffffffffc0200a08:	000b2697          	auipc	a3,0xb2
ffffffffc0200a0c:	dd068693          	addi	a3,a3,-560 # ffffffffc02b27d8 <ticks>
ffffffffc0200a10:	629c                	ld	a5,0(a3)
ffffffffc0200a12:	06400713          	li	a4,100
ffffffffc0200a16:	0785                	addi	a5,a5,1
ffffffffc0200a18:	02e7f733          	remu	a4,a5,a4
ffffffffc0200a1c:	e29c                	sd	a5,0(a3)
ffffffffc0200a1e:	eb01                	bnez	a4,ffffffffc0200a2e <interrupt_handler+0x7e>
ffffffffc0200a20:	000b2797          	auipc	a5,0xb2
ffffffffc0200a24:	e287b783          	ld	a5,-472(a5) # ffffffffc02b2848 <current>
ffffffffc0200a28:	c399                	beqz	a5,ffffffffc0200a2e <interrupt_handler+0x7e>
                // print_ticks();
                current->need_resched = 1;
ffffffffc0200a2a:	4705                	li	a4,1
ffffffffc0200a2c:	ef98                	sd	a4,24(a5)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a2e:	60a2                	ld	ra,8(sp)
ffffffffc0200a30:	0141                	addi	sp,sp,16
ffffffffc0200a32:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a34:	00006517          	auipc	a0,0x6
ffffffffc0200a38:	33450513          	addi	a0,a0,820 # ffffffffc0206d68 <commands+0x518>
ffffffffc0200a3c:	f44ff06f          	j	ffffffffc0200180 <cprintf>
            print_trapframe(tf);
ffffffffc0200a40:	bbd5                	j	ffffffffc0200834 <print_trapframe>

ffffffffc0200a42 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf,uintptr_t kstacktop);
void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200a42:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200a46:	1101                	addi	sp,sp,-32
ffffffffc0200a48:	e822                	sd	s0,16(sp)
ffffffffc0200a4a:	ec06                	sd	ra,24(sp)
ffffffffc0200a4c:	e426                	sd	s1,8(sp)
ffffffffc0200a4e:	473d                	li	a4,15
ffffffffc0200a50:	842a                	mv	s0,a0
ffffffffc0200a52:	18f76563          	bltu	a4,a5,ffffffffc0200bdc <exception_handler+0x19a>
ffffffffc0200a56:	00006717          	auipc	a4,0x6
ffffffffc0200a5a:	4fa70713          	addi	a4,a4,1274 # ffffffffc0206f50 <commands+0x700>
ffffffffc0200a5e:	078a                	slli	a5,a5,0x2
ffffffffc0200a60:	97ba                	add	a5,a5,a4
ffffffffc0200a62:	439c                	lw	a5,0(a5)
ffffffffc0200a64:	97ba                	add	a5,a5,a4
ffffffffc0200a66:	8782                	jr	a5
            //cprintf("Environment call from U-mode\n");
            tf->epc += 4;
            syscall();
            break;
        case CAUSE_SUPERVISOR_ECALL:
            cprintf("Environment call from S-mode\n");
ffffffffc0200a68:	00006517          	auipc	a0,0x6
ffffffffc0200a6c:	44050513          	addi	a0,a0,1088 # ffffffffc0206ea8 <commands+0x658>
ffffffffc0200a70:	f10ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            tf->epc += 4;
ffffffffc0200a74:	10843783          	ld	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a78:	60e2                	ld	ra,24(sp)
ffffffffc0200a7a:	64a2                	ld	s1,8(sp)
            tf->epc += 4;
ffffffffc0200a7c:	0791                	addi	a5,a5,4
ffffffffc0200a7e:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200a82:	6442                	ld	s0,16(sp)
ffffffffc0200a84:	6105                	addi	sp,sp,32
            syscall();
ffffffffc0200a86:	6360506f          	j	ffffffffc02060bc <syscall>
            cprintf("Environment call from H-mode\n");
ffffffffc0200a8a:	00006517          	auipc	a0,0x6
ffffffffc0200a8e:	43e50513          	addi	a0,a0,1086 # ffffffffc0206ec8 <commands+0x678>
}
ffffffffc0200a92:	6442                	ld	s0,16(sp)
ffffffffc0200a94:	60e2                	ld	ra,24(sp)
ffffffffc0200a96:	64a2                	ld	s1,8(sp)
ffffffffc0200a98:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc0200a9a:	ee6ff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("Environment call from M-mode\n");
ffffffffc0200a9e:	00006517          	auipc	a0,0x6
ffffffffc0200aa2:	44a50513          	addi	a0,a0,1098 # ffffffffc0206ee8 <commands+0x698>
ffffffffc0200aa6:	b7f5                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200aa8:	00006517          	auipc	a0,0x6
ffffffffc0200aac:	46050513          	addi	a0,a0,1120 # ffffffffc0206f08 <commands+0x6b8>
ffffffffc0200ab0:	b7cd                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200ab2:	00006517          	auipc	a0,0x6
ffffffffc0200ab6:	46e50513          	addi	a0,a0,1134 # ffffffffc0206f20 <commands+0x6d0>
ffffffffc0200aba:	ec6ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200abe:	8522                	mv	a0,s0
ffffffffc0200ac0:	dd7ff0ef          	jal	ra,ffffffffc0200896 <pgfault_handler>
ffffffffc0200ac4:	84aa                	mv	s1,a0
ffffffffc0200ac6:	12051d63          	bnez	a0,ffffffffc0200c00 <exception_handler+0x1be>
}
ffffffffc0200aca:	60e2                	ld	ra,24(sp)
ffffffffc0200acc:	6442                	ld	s0,16(sp)
ffffffffc0200ace:	64a2                	ld	s1,8(sp)
ffffffffc0200ad0:	6105                	addi	sp,sp,32
ffffffffc0200ad2:	8082                	ret
            cprintf("Store/AMO page fault\n");
ffffffffc0200ad4:	00006517          	auipc	a0,0x6
ffffffffc0200ad8:	46450513          	addi	a0,a0,1124 # ffffffffc0206f38 <commands+0x6e8>
ffffffffc0200adc:	ea4ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200ae0:	8522                	mv	a0,s0
ffffffffc0200ae2:	db5ff0ef          	jal	ra,ffffffffc0200896 <pgfault_handler>
ffffffffc0200ae6:	84aa                	mv	s1,a0
ffffffffc0200ae8:	d16d                	beqz	a0,ffffffffc0200aca <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200aea:	8522                	mv	a0,s0
ffffffffc0200aec:	d49ff0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200af0:	86a6                	mv	a3,s1
ffffffffc0200af2:	00006617          	auipc	a2,0x6
ffffffffc0200af6:	36660613          	addi	a2,a2,870 # ffffffffc0206e58 <commands+0x608>
ffffffffc0200afa:	0f800593          	li	a1,248
ffffffffc0200afe:	00006517          	auipc	a0,0x6
ffffffffc0200b02:	1ba50513          	addi	a0,a0,442 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200b06:	975ff0ef          	jal	ra,ffffffffc020047a <__panic>
            cprintf("Instruction address misaligned\n");
ffffffffc0200b0a:	00006517          	auipc	a0,0x6
ffffffffc0200b0e:	2ae50513          	addi	a0,a0,686 # ffffffffc0206db8 <commands+0x568>
ffffffffc0200b12:	b741                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Instruction access fault\n");
ffffffffc0200b14:	00006517          	auipc	a0,0x6
ffffffffc0200b18:	2c450513          	addi	a0,a0,708 # ffffffffc0206dd8 <commands+0x588>
ffffffffc0200b1c:	bf9d                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc0200b1e:	00006517          	auipc	a0,0x6
ffffffffc0200b22:	2da50513          	addi	a0,a0,730 # ffffffffc0206df8 <commands+0x5a8>
ffffffffc0200b26:	b7b5                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200b28:	00006517          	auipc	a0,0x6
ffffffffc0200b2c:	2e850513          	addi	a0,a0,744 # ffffffffc0206e10 <commands+0x5c0>
ffffffffc0200b30:	e50ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if(tf->gpr.a7 == 10){
ffffffffc0200b34:	6458                	ld	a4,136(s0)
ffffffffc0200b36:	47a9                	li	a5,10
ffffffffc0200b38:	f8f719e3          	bne	a4,a5,ffffffffc0200aca <exception_handler+0x88>
                tf->epc += 4;
ffffffffc0200b3c:	10843783          	ld	a5,264(s0)
ffffffffc0200b40:	0791                	addi	a5,a5,4
ffffffffc0200b42:	10f43423          	sd	a5,264(s0)
                syscall();
ffffffffc0200b46:	576050ef          	jal	ra,ffffffffc02060bc <syscall>
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b4a:	000b2797          	auipc	a5,0xb2
ffffffffc0200b4e:	cfe7b783          	ld	a5,-770(a5) # ffffffffc02b2848 <current>
ffffffffc0200b52:	6b9c                	ld	a5,16(a5)
ffffffffc0200b54:	8522                	mv	a0,s0
}
ffffffffc0200b56:	6442                	ld	s0,16(sp)
ffffffffc0200b58:	60e2                	ld	ra,24(sp)
ffffffffc0200b5a:	64a2                	ld	s1,8(sp)
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b5c:	6589                	lui	a1,0x2
ffffffffc0200b5e:	95be                	add	a1,a1,a5
}
ffffffffc0200b60:	6105                	addi	sp,sp,32
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b62:	ac21                	j	ffffffffc0200d7a <kernel_execve_ret>
            cprintf("Load address misaligned\n");
ffffffffc0200b64:	00006517          	auipc	a0,0x6
ffffffffc0200b68:	2bc50513          	addi	a0,a0,700 # ffffffffc0206e20 <commands+0x5d0>
ffffffffc0200b6c:	b71d                	j	ffffffffc0200a92 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200b6e:	00006517          	auipc	a0,0x6
ffffffffc0200b72:	2d250513          	addi	a0,a0,722 # ffffffffc0206e40 <commands+0x5f0>
ffffffffc0200b76:	e0aff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200b7a:	8522                	mv	a0,s0
ffffffffc0200b7c:	d1bff0ef          	jal	ra,ffffffffc0200896 <pgfault_handler>
ffffffffc0200b80:	84aa                	mv	s1,a0
ffffffffc0200b82:	d521                	beqz	a0,ffffffffc0200aca <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200b84:	8522                	mv	a0,s0
ffffffffc0200b86:	cafff0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b8a:	86a6                	mv	a3,s1
ffffffffc0200b8c:	00006617          	auipc	a2,0x6
ffffffffc0200b90:	2cc60613          	addi	a2,a2,716 # ffffffffc0206e58 <commands+0x608>
ffffffffc0200b94:	0cd00593          	li	a1,205
ffffffffc0200b98:	00006517          	auipc	a0,0x6
ffffffffc0200b9c:	12050513          	addi	a0,a0,288 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200ba0:	8dbff0ef          	jal	ra,ffffffffc020047a <__panic>
            cprintf("Store/AMO access fault\n");
ffffffffc0200ba4:	00006517          	auipc	a0,0x6
ffffffffc0200ba8:	2ec50513          	addi	a0,a0,748 # ffffffffc0206e90 <commands+0x640>
ffffffffc0200bac:	dd4ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200bb0:	8522                	mv	a0,s0
ffffffffc0200bb2:	ce5ff0ef          	jal	ra,ffffffffc0200896 <pgfault_handler>
ffffffffc0200bb6:	84aa                	mv	s1,a0
ffffffffc0200bb8:	f00509e3          	beqz	a0,ffffffffc0200aca <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200bbc:	8522                	mv	a0,s0
ffffffffc0200bbe:	c77ff0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200bc2:	86a6                	mv	a3,s1
ffffffffc0200bc4:	00006617          	auipc	a2,0x6
ffffffffc0200bc8:	29460613          	addi	a2,a2,660 # ffffffffc0206e58 <commands+0x608>
ffffffffc0200bcc:	0d700593          	li	a1,215
ffffffffc0200bd0:	00006517          	auipc	a0,0x6
ffffffffc0200bd4:	0e850513          	addi	a0,a0,232 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200bd8:	8a3ff0ef          	jal	ra,ffffffffc020047a <__panic>
            print_trapframe(tf);
ffffffffc0200bdc:	8522                	mv	a0,s0
}
ffffffffc0200bde:	6442                	ld	s0,16(sp)
ffffffffc0200be0:	60e2                	ld	ra,24(sp)
ffffffffc0200be2:	64a2                	ld	s1,8(sp)
ffffffffc0200be4:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200be6:	b1b9                	j	ffffffffc0200834 <print_trapframe>
            panic("AMO address misaligned\n");
ffffffffc0200be8:	00006617          	auipc	a2,0x6
ffffffffc0200bec:	29060613          	addi	a2,a2,656 # ffffffffc0206e78 <commands+0x628>
ffffffffc0200bf0:	0d100593          	li	a1,209
ffffffffc0200bf4:	00006517          	auipc	a0,0x6
ffffffffc0200bf8:	0c450513          	addi	a0,a0,196 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200bfc:	87fff0ef          	jal	ra,ffffffffc020047a <__panic>
                print_trapframe(tf);
ffffffffc0200c00:	8522                	mv	a0,s0
ffffffffc0200c02:	c33ff0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200c06:	86a6                	mv	a3,s1
ffffffffc0200c08:	00006617          	auipc	a2,0x6
ffffffffc0200c0c:	25060613          	addi	a2,a2,592 # ffffffffc0206e58 <commands+0x608>
ffffffffc0200c10:	0f100593          	li	a1,241
ffffffffc0200c14:	00006517          	auipc	a0,0x6
ffffffffc0200c18:	0a450513          	addi	a0,a0,164 # ffffffffc0206cb8 <commands+0x468>
ffffffffc0200c1c:	85fff0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0200c20 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
ffffffffc0200c20:	1101                	addi	sp,sp,-32
ffffffffc0200c22:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
//    cputs("some trap");
    if (current == NULL) {
ffffffffc0200c24:	000b2417          	auipc	s0,0xb2
ffffffffc0200c28:	c2440413          	addi	s0,s0,-988 # ffffffffc02b2848 <current>
ffffffffc0200c2c:	6018                	ld	a4,0(s0)
trap(struct trapframe *tf) {
ffffffffc0200c2e:	ec06                	sd	ra,24(sp)
ffffffffc0200c30:	e426                	sd	s1,8(sp)
ffffffffc0200c32:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c34:	11853683          	ld	a3,280(a0)
    if (current == NULL) {
ffffffffc0200c38:	cf1d                	beqz	a4,ffffffffc0200c76 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200c3a:	10053483          	ld	s1,256(a0)
        trap_dispatch(tf);
    } else {
        struct trapframe *otf = current->tf;
ffffffffc0200c3e:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200c42:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200c44:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c48:	0206c463          	bltz	a3,ffffffffc0200c70 <trap+0x50>
        exception_handler(tf);
ffffffffc0200c4c:	df7ff0ef          	jal	ra,ffffffffc0200a42 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200c50:	601c                	ld	a5,0(s0)
ffffffffc0200c52:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel) {
ffffffffc0200c56:	e499                	bnez	s1,ffffffffc0200c64 <trap+0x44>
            if (current->flags & PF_EXITING) {
ffffffffc0200c58:	0b07a703          	lw	a4,176(a5)
ffffffffc0200c5c:	8b05                	andi	a4,a4,1
ffffffffc0200c5e:	e329                	bnez	a4,ffffffffc0200ca0 <trap+0x80>
                do_exit(-E_KILLED);
            }
            if (current->need_resched) {
ffffffffc0200c60:	6f9c                	ld	a5,24(a5)
ffffffffc0200c62:	eb85                	bnez	a5,ffffffffc0200c92 <trap+0x72>
                schedule();
            }
        }
    }
}
ffffffffc0200c64:	60e2                	ld	ra,24(sp)
ffffffffc0200c66:	6442                	ld	s0,16(sp)
ffffffffc0200c68:	64a2                	ld	s1,8(sp)
ffffffffc0200c6a:	6902                	ld	s2,0(sp)
ffffffffc0200c6c:	6105                	addi	sp,sp,32
ffffffffc0200c6e:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200c70:	d41ff0ef          	jal	ra,ffffffffc02009b0 <interrupt_handler>
ffffffffc0200c74:	bff1                	j	ffffffffc0200c50 <trap+0x30>
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c76:	0006c863          	bltz	a3,ffffffffc0200c86 <trap+0x66>
}
ffffffffc0200c7a:	6442                	ld	s0,16(sp)
ffffffffc0200c7c:	60e2                	ld	ra,24(sp)
ffffffffc0200c7e:	64a2                	ld	s1,8(sp)
ffffffffc0200c80:	6902                	ld	s2,0(sp)
ffffffffc0200c82:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200c84:	bb7d                	j	ffffffffc0200a42 <exception_handler>
}
ffffffffc0200c86:	6442                	ld	s0,16(sp)
ffffffffc0200c88:	60e2                	ld	ra,24(sp)
ffffffffc0200c8a:	64a2                	ld	s1,8(sp)
ffffffffc0200c8c:	6902                	ld	s2,0(sp)
ffffffffc0200c8e:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200c90:	b305                	j	ffffffffc02009b0 <interrupt_handler>
}
ffffffffc0200c92:	6442                	ld	s0,16(sp)
ffffffffc0200c94:	60e2                	ld	ra,24(sp)
ffffffffc0200c96:	64a2                	ld	s1,8(sp)
ffffffffc0200c98:	6902                	ld	s2,0(sp)
ffffffffc0200c9a:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200c9c:	3340506f          	j	ffffffffc0205fd0 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200ca0:	555d                	li	a0,-9
ffffffffc0200ca2:	67c040ef          	jal	ra,ffffffffc020531e <do_exit>
            if (current->need_resched) {
ffffffffc0200ca6:	601c                	ld	a5,0(s0)
ffffffffc0200ca8:	bf65                	j	ffffffffc0200c60 <trap+0x40>
	...

ffffffffc0200cac <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200cac:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200cb0:	00011463          	bnez	sp,ffffffffc0200cb8 <__alltraps+0xc>
ffffffffc0200cb4:	14002173          	csrr	sp,sscratch
ffffffffc0200cb8:	712d                	addi	sp,sp,-288
ffffffffc0200cba:	e002                	sd	zero,0(sp)
ffffffffc0200cbc:	e406                	sd	ra,8(sp)
ffffffffc0200cbe:	ec0e                	sd	gp,24(sp)
ffffffffc0200cc0:	f012                	sd	tp,32(sp)
ffffffffc0200cc2:	f416                	sd	t0,40(sp)
ffffffffc0200cc4:	f81a                	sd	t1,48(sp)
ffffffffc0200cc6:	fc1e                	sd	t2,56(sp)
ffffffffc0200cc8:	e0a2                	sd	s0,64(sp)
ffffffffc0200cca:	e4a6                	sd	s1,72(sp)
ffffffffc0200ccc:	e8aa                	sd	a0,80(sp)
ffffffffc0200cce:	ecae                	sd	a1,88(sp)
ffffffffc0200cd0:	f0b2                	sd	a2,96(sp)
ffffffffc0200cd2:	f4b6                	sd	a3,104(sp)
ffffffffc0200cd4:	f8ba                	sd	a4,112(sp)
ffffffffc0200cd6:	fcbe                	sd	a5,120(sp)
ffffffffc0200cd8:	e142                	sd	a6,128(sp)
ffffffffc0200cda:	e546                	sd	a7,136(sp)
ffffffffc0200cdc:	e94a                	sd	s2,144(sp)
ffffffffc0200cde:	ed4e                	sd	s3,152(sp)
ffffffffc0200ce0:	f152                	sd	s4,160(sp)
ffffffffc0200ce2:	f556                	sd	s5,168(sp)
ffffffffc0200ce4:	f95a                	sd	s6,176(sp)
ffffffffc0200ce6:	fd5e                	sd	s7,184(sp)
ffffffffc0200ce8:	e1e2                	sd	s8,192(sp)
ffffffffc0200cea:	e5e6                	sd	s9,200(sp)
ffffffffc0200cec:	e9ea                	sd	s10,208(sp)
ffffffffc0200cee:	edee                	sd	s11,216(sp)
ffffffffc0200cf0:	f1f2                	sd	t3,224(sp)
ffffffffc0200cf2:	f5f6                	sd	t4,232(sp)
ffffffffc0200cf4:	f9fa                	sd	t5,240(sp)
ffffffffc0200cf6:	fdfe                	sd	t6,248(sp)
ffffffffc0200cf8:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200cfc:	100024f3          	csrr	s1,sstatus
ffffffffc0200d00:	14102973          	csrr	s2,sepc
ffffffffc0200d04:	143029f3          	csrr	s3,stval
ffffffffc0200d08:	14202a73          	csrr	s4,scause
ffffffffc0200d0c:	e822                	sd	s0,16(sp)
ffffffffc0200d0e:	e226                	sd	s1,256(sp)
ffffffffc0200d10:	e64a                	sd	s2,264(sp)
ffffffffc0200d12:	ea4e                	sd	s3,272(sp)
ffffffffc0200d14:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d16:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d18:	f09ff0ef          	jal	ra,ffffffffc0200c20 <trap>

ffffffffc0200d1c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d1c:	6492                	ld	s1,256(sp)
ffffffffc0200d1e:	6932                	ld	s2,264(sp)
ffffffffc0200d20:	1004f413          	andi	s0,s1,256
ffffffffc0200d24:	e401                	bnez	s0,ffffffffc0200d2c <__trapret+0x10>
ffffffffc0200d26:	1200                	addi	s0,sp,288
ffffffffc0200d28:	14041073          	csrw	sscratch,s0
ffffffffc0200d2c:	10049073          	csrw	sstatus,s1
ffffffffc0200d30:	14191073          	csrw	sepc,s2
ffffffffc0200d34:	60a2                	ld	ra,8(sp)
ffffffffc0200d36:	61e2                	ld	gp,24(sp)
ffffffffc0200d38:	7202                	ld	tp,32(sp)
ffffffffc0200d3a:	72a2                	ld	t0,40(sp)
ffffffffc0200d3c:	7342                	ld	t1,48(sp)
ffffffffc0200d3e:	73e2                	ld	t2,56(sp)
ffffffffc0200d40:	6406                	ld	s0,64(sp)
ffffffffc0200d42:	64a6                	ld	s1,72(sp)
ffffffffc0200d44:	6546                	ld	a0,80(sp)
ffffffffc0200d46:	65e6                	ld	a1,88(sp)
ffffffffc0200d48:	7606                	ld	a2,96(sp)
ffffffffc0200d4a:	76a6                	ld	a3,104(sp)
ffffffffc0200d4c:	7746                	ld	a4,112(sp)
ffffffffc0200d4e:	77e6                	ld	a5,120(sp)
ffffffffc0200d50:	680a                	ld	a6,128(sp)
ffffffffc0200d52:	68aa                	ld	a7,136(sp)
ffffffffc0200d54:	694a                	ld	s2,144(sp)
ffffffffc0200d56:	69ea                	ld	s3,152(sp)
ffffffffc0200d58:	7a0a                	ld	s4,160(sp)
ffffffffc0200d5a:	7aaa                	ld	s5,168(sp)
ffffffffc0200d5c:	7b4a                	ld	s6,176(sp)
ffffffffc0200d5e:	7bea                	ld	s7,184(sp)
ffffffffc0200d60:	6c0e                	ld	s8,192(sp)
ffffffffc0200d62:	6cae                	ld	s9,200(sp)
ffffffffc0200d64:	6d4e                	ld	s10,208(sp)
ffffffffc0200d66:	6dee                	ld	s11,216(sp)
ffffffffc0200d68:	7e0e                	ld	t3,224(sp)
ffffffffc0200d6a:	7eae                	ld	t4,232(sp)
ffffffffc0200d6c:	7f4e                	ld	t5,240(sp)
ffffffffc0200d6e:	7fee                	ld	t6,248(sp)
ffffffffc0200d70:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200d72:	10200073          	sret

ffffffffc0200d76 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200d76:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200d78:	b755                	j	ffffffffc0200d1c <__trapret>

ffffffffc0200d7a <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200d7a:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200d7e:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200d82:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200d86:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200d8a:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200d8e:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200d92:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200d96:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200d9a:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200d9e:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200da0:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200da2:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200da4:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200da6:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200da8:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200daa:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200dac:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200dae:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200db0:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200db2:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200db4:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200db6:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200db8:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200dba:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200dbc:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200dbe:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200dc0:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200dc2:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200dc4:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200dc6:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200dc8:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200dca:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200dcc:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200dce:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200dd0:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200dd2:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200dd4:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200dd6:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200dd8:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200dda:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200ddc:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200dde:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200de0:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200de2:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200de4:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200de6:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200de8:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200dea:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200dec:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200dee:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200df0:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200df2:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200df4:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200df6:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200df8:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200dfa:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200dfc:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200dfe:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200e00:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200e02:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200e04:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200e06:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200e08:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200e0a:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200e0c:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200e0e:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200e10:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200e12:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200e14:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200e16:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200e18:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200e1a:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200e1c:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200e1e:	812e                	mv	sp,a1
ffffffffc0200e20:	bdf5                	j	ffffffffc0200d1c <__trapret>

ffffffffc0200e22 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200e22:	000ae797          	auipc	a5,0xae
ffffffffc0200e26:	8e678793          	addi	a5,a5,-1818 # ffffffffc02ae708 <free_area>
ffffffffc0200e2a:	e79c                	sd	a5,8(a5)
ffffffffc0200e2c:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200e2e:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200e32:	8082                	ret

ffffffffc0200e34 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200e34:	000ae517          	auipc	a0,0xae
ffffffffc0200e38:	8e456503          	lwu	a0,-1820(a0) # ffffffffc02ae718 <free_area+0x10>
ffffffffc0200e3c:	8082                	ret

ffffffffc0200e3e <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200e3e:	715d                	addi	sp,sp,-80
ffffffffc0200e40:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200e42:	000ae417          	auipc	s0,0xae
ffffffffc0200e46:	8c640413          	addi	s0,s0,-1850 # ffffffffc02ae708 <free_area>
ffffffffc0200e4a:	641c                	ld	a5,8(s0)
ffffffffc0200e4c:	e486                	sd	ra,72(sp)
ffffffffc0200e4e:	fc26                	sd	s1,56(sp)
ffffffffc0200e50:	f84a                	sd	s2,48(sp)
ffffffffc0200e52:	f44e                	sd	s3,40(sp)
ffffffffc0200e54:	f052                	sd	s4,32(sp)
ffffffffc0200e56:	ec56                	sd	s5,24(sp)
ffffffffc0200e58:	e85a                	sd	s6,16(sp)
ffffffffc0200e5a:	e45e                	sd	s7,8(sp)
ffffffffc0200e5c:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e5e:	2a878d63          	beq	a5,s0,ffffffffc0201118 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200e62:	4481                	li	s1,0
ffffffffc0200e64:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e66:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e6a:	8b09                	andi	a4,a4,2
ffffffffc0200e6c:	2a070a63          	beqz	a4,ffffffffc0201120 <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0200e70:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e74:	679c                	ld	a5,8(a5)
ffffffffc0200e76:	2905                	addiw	s2,s2,1
ffffffffc0200e78:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e7a:	fe8796e3          	bne	a5,s0,ffffffffc0200e66 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200e7e:	89a6                	mv	s3,s1
ffffffffc0200e80:	729000ef          	jal	ra,ffffffffc0201da8 <nr_free_pages>
ffffffffc0200e84:	6f351e63          	bne	a0,s3,ffffffffc0201580 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e88:	4505                	li	a0,1
ffffffffc0200e8a:	64d000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200e8e:	8aaa                	mv	s5,a0
ffffffffc0200e90:	42050863          	beqz	a0,ffffffffc02012c0 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e94:	4505                	li	a0,1
ffffffffc0200e96:	641000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200e9a:	89aa                	mv	s3,a0
ffffffffc0200e9c:	70050263          	beqz	a0,ffffffffc02015a0 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200ea0:	4505                	li	a0,1
ffffffffc0200ea2:	635000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200ea6:	8a2a                	mv	s4,a0
ffffffffc0200ea8:	48050c63          	beqz	a0,ffffffffc0201340 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200eac:	293a8a63          	beq	s5,s3,ffffffffc0201140 <default_check+0x302>
ffffffffc0200eb0:	28aa8863          	beq	s5,a0,ffffffffc0201140 <default_check+0x302>
ffffffffc0200eb4:	28a98663          	beq	s3,a0,ffffffffc0201140 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200eb8:	000aa783          	lw	a5,0(s5)
ffffffffc0200ebc:	2a079263          	bnez	a5,ffffffffc0201160 <default_check+0x322>
ffffffffc0200ec0:	0009a783          	lw	a5,0(s3)
ffffffffc0200ec4:	28079e63          	bnez	a5,ffffffffc0201160 <default_check+0x322>
ffffffffc0200ec8:	411c                	lw	a5,0(a0)
ffffffffc0200eca:	28079b63          	bnez	a5,ffffffffc0201160 <default_check+0x322>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0200ece:	000b2797          	auipc	a5,0xb2
ffffffffc0200ed2:	93a7b783          	ld	a5,-1734(a5) # ffffffffc02b2808 <pages>
ffffffffc0200ed6:	40fa8733          	sub	a4,s5,a5
ffffffffc0200eda:	00008617          	auipc	a2,0x8
ffffffffc0200ede:	e4e63603          	ld	a2,-434(a2) # ffffffffc0208d28 <nbase>
ffffffffc0200ee2:	8719                	srai	a4,a4,0x6
ffffffffc0200ee4:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ee6:	000b2697          	auipc	a3,0xb2
ffffffffc0200eea:	91a6b683          	ld	a3,-1766(a3) # ffffffffc02b2800 <npage>
ffffffffc0200eee:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ef0:	0732                	slli	a4,a4,0xc
ffffffffc0200ef2:	28d77763          	bgeu	a4,a3,ffffffffc0201180 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200ef6:	40f98733          	sub	a4,s3,a5
ffffffffc0200efa:	8719                	srai	a4,a4,0x6
ffffffffc0200efc:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200efe:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200f00:	4cd77063          	bgeu	a4,a3,ffffffffc02013c0 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200f04:	40f507b3          	sub	a5,a0,a5
ffffffffc0200f08:	8799                	srai	a5,a5,0x6
ffffffffc0200f0a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f0c:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f0e:	30d7f963          	bgeu	a5,a3,ffffffffc0201220 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200f12:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f14:	00043c03          	ld	s8,0(s0)
ffffffffc0200f18:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200f1c:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200f20:	e400                	sd	s0,8(s0)
ffffffffc0200f22:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200f24:	000ad797          	auipc	a5,0xad
ffffffffc0200f28:	7e07aa23          	sw	zero,2036(a5) # ffffffffc02ae718 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200f2c:	5ab000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f30:	2c051863          	bnez	a0,ffffffffc0201200 <default_check+0x3c2>
    free_page(p0);
ffffffffc0200f34:	4585                	li	a1,1
ffffffffc0200f36:	8556                	mv	a0,s5
ffffffffc0200f38:	631000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_page(p1);
ffffffffc0200f3c:	4585                	li	a1,1
ffffffffc0200f3e:	854e                	mv	a0,s3
ffffffffc0200f40:	629000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_page(p2);
ffffffffc0200f44:	4585                	li	a1,1
ffffffffc0200f46:	8552                	mv	a0,s4
ffffffffc0200f48:	621000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    assert(nr_free == 3);
ffffffffc0200f4c:	4818                	lw	a4,16(s0)
ffffffffc0200f4e:	478d                	li	a5,3
ffffffffc0200f50:	28f71863          	bne	a4,a5,ffffffffc02011e0 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f54:	4505                	li	a0,1
ffffffffc0200f56:	581000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f5a:	89aa                	mv	s3,a0
ffffffffc0200f5c:	26050263          	beqz	a0,ffffffffc02011c0 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f60:	4505                	li	a0,1
ffffffffc0200f62:	575000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f66:	8aaa                	mv	s5,a0
ffffffffc0200f68:	3a050c63          	beqz	a0,ffffffffc0201320 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f6c:	4505                	li	a0,1
ffffffffc0200f6e:	569000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f72:	8a2a                	mv	s4,a0
ffffffffc0200f74:	38050663          	beqz	a0,ffffffffc0201300 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200f78:	4505                	li	a0,1
ffffffffc0200f7a:	55d000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f7e:	36051163          	bnez	a0,ffffffffc02012e0 <default_check+0x4a2>
    free_page(p0);
ffffffffc0200f82:	4585                	li	a1,1
ffffffffc0200f84:	854e                	mv	a0,s3
ffffffffc0200f86:	5e3000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200f8a:	641c                	ld	a5,8(s0)
ffffffffc0200f8c:	20878a63          	beq	a5,s0,ffffffffc02011a0 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0200f90:	4505                	li	a0,1
ffffffffc0200f92:	545000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200f96:	30a99563          	bne	s3,a0,ffffffffc02012a0 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0200f9a:	4505                	li	a0,1
ffffffffc0200f9c:	53b000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200fa0:	2e051063          	bnez	a0,ffffffffc0201280 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0200fa4:	481c                	lw	a5,16(s0)
ffffffffc0200fa6:	2a079d63          	bnez	a5,ffffffffc0201260 <default_check+0x422>
    free_page(p);
ffffffffc0200faa:	854e                	mv	a0,s3
ffffffffc0200fac:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200fae:	01843023          	sd	s8,0(s0)
ffffffffc0200fb2:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200fb6:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200fba:	5af000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_page(p1);
ffffffffc0200fbe:	4585                	li	a1,1
ffffffffc0200fc0:	8556                	mv	a0,s5
ffffffffc0200fc2:	5a7000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_page(p2);
ffffffffc0200fc6:	4585                	li	a1,1
ffffffffc0200fc8:	8552                	mv	a0,s4
ffffffffc0200fca:	59f000ef          	jal	ra,ffffffffc0201d68 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200fce:	4515                	li	a0,5
ffffffffc0200fd0:	507000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200fd4:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200fd6:	26050563          	beqz	a0,ffffffffc0201240 <default_check+0x402>
ffffffffc0200fda:	651c                	ld	a5,8(a0)
ffffffffc0200fdc:	8385                	srli	a5,a5,0x1
ffffffffc0200fde:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0200fe0:	54079063          	bnez	a5,ffffffffc0201520 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200fe4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fe6:	00043b03          	ld	s6,0(s0)
ffffffffc0200fea:	00843a83          	ld	s5,8(s0)
ffffffffc0200fee:	e000                	sd	s0,0(s0)
ffffffffc0200ff0:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200ff2:	4e5000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0200ff6:	50051563          	bnez	a0,ffffffffc0201500 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200ffa:	08098a13          	addi	s4,s3,128
ffffffffc0200ffe:	8552                	mv	a0,s4
ffffffffc0201000:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201002:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201006:	000ad797          	auipc	a5,0xad
ffffffffc020100a:	7007a923          	sw	zero,1810(a5) # ffffffffc02ae718 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020100e:	55b000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201012:	4511                	li	a0,4
ffffffffc0201014:	4c3000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201018:	4c051463          	bnez	a0,ffffffffc02014e0 <default_check+0x6a2>
ffffffffc020101c:	0889b783          	ld	a5,136(s3)
ffffffffc0201020:	8385                	srli	a5,a5,0x1
ffffffffc0201022:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201024:	48078e63          	beqz	a5,ffffffffc02014c0 <default_check+0x682>
ffffffffc0201028:	0909a703          	lw	a4,144(s3)
ffffffffc020102c:	478d                	li	a5,3
ffffffffc020102e:	48f71963          	bne	a4,a5,ffffffffc02014c0 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201032:	450d                	li	a0,3
ffffffffc0201034:	4a3000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201038:	8c2a                	mv	s8,a0
ffffffffc020103a:	46050363          	beqz	a0,ffffffffc02014a0 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc020103e:	4505                	li	a0,1
ffffffffc0201040:	497000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201044:	42051e63          	bnez	a0,ffffffffc0201480 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201048:	418a1c63          	bne	s4,s8,ffffffffc0201460 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020104c:	4585                	li	a1,1
ffffffffc020104e:	854e                	mv	a0,s3
ffffffffc0201050:	519000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_pages(p1, 3);
ffffffffc0201054:	458d                	li	a1,3
ffffffffc0201056:	8552                	mv	a0,s4
ffffffffc0201058:	511000ef          	jal	ra,ffffffffc0201d68 <free_pages>
ffffffffc020105c:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201060:	04098c13          	addi	s8,s3,64
ffffffffc0201064:	8385                	srli	a5,a5,0x1
ffffffffc0201066:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201068:	3c078c63          	beqz	a5,ffffffffc0201440 <default_check+0x602>
ffffffffc020106c:	0109a703          	lw	a4,16(s3)
ffffffffc0201070:	4785                	li	a5,1
ffffffffc0201072:	3cf71763          	bne	a4,a5,ffffffffc0201440 <default_check+0x602>
ffffffffc0201076:	008a3783          	ld	a5,8(s4)
ffffffffc020107a:	8385                	srli	a5,a5,0x1
ffffffffc020107c:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020107e:	3a078163          	beqz	a5,ffffffffc0201420 <default_check+0x5e2>
ffffffffc0201082:	010a2703          	lw	a4,16(s4)
ffffffffc0201086:	478d                	li	a5,3
ffffffffc0201088:	38f71c63          	bne	a4,a5,ffffffffc0201420 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020108c:	4505                	li	a0,1
ffffffffc020108e:	449000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201092:	36a99763          	bne	s3,a0,ffffffffc0201400 <default_check+0x5c2>
    free_page(p0);
ffffffffc0201096:	4585                	li	a1,1
ffffffffc0201098:	4d1000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020109c:	4509                	li	a0,2
ffffffffc020109e:	439000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc02010a2:	32aa1f63          	bne	s4,a0,ffffffffc02013e0 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc02010a6:	4589                	li	a1,2
ffffffffc02010a8:	4c1000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    free_page(p2);
ffffffffc02010ac:	4585                	li	a1,1
ffffffffc02010ae:	8562                	mv	a0,s8
ffffffffc02010b0:	4b9000ef          	jal	ra,ffffffffc0201d68 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02010b4:	4515                	li	a0,5
ffffffffc02010b6:	421000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc02010ba:	89aa                	mv	s3,a0
ffffffffc02010bc:	48050263          	beqz	a0,ffffffffc0201540 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc02010c0:	4505                	li	a0,1
ffffffffc02010c2:	415000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc02010c6:	2c051d63          	bnez	a0,ffffffffc02013a0 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc02010ca:	481c                	lw	a5,16(s0)
ffffffffc02010cc:	2a079a63          	bnez	a5,ffffffffc0201380 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02010d0:	4595                	li	a1,5
ffffffffc02010d2:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02010d4:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02010d8:	01643023          	sd	s6,0(s0)
ffffffffc02010dc:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02010e0:	489000ef          	jal	ra,ffffffffc0201d68 <free_pages>
    return listelm->next;
ffffffffc02010e4:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010e6:	00878963          	beq	a5,s0,ffffffffc02010f8 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02010ea:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010ee:	679c                	ld	a5,8(a5)
ffffffffc02010f0:	397d                	addiw	s2,s2,-1
ffffffffc02010f2:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010f4:	fe879be3          	bne	a5,s0,ffffffffc02010ea <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02010f8:	26091463          	bnez	s2,ffffffffc0201360 <default_check+0x522>
    assert(total == 0);
ffffffffc02010fc:	46049263          	bnez	s1,ffffffffc0201560 <default_check+0x722>
}
ffffffffc0201100:	60a6                	ld	ra,72(sp)
ffffffffc0201102:	6406                	ld	s0,64(sp)
ffffffffc0201104:	74e2                	ld	s1,56(sp)
ffffffffc0201106:	7942                	ld	s2,48(sp)
ffffffffc0201108:	79a2                	ld	s3,40(sp)
ffffffffc020110a:	7a02                	ld	s4,32(sp)
ffffffffc020110c:	6ae2                	ld	s5,24(sp)
ffffffffc020110e:	6b42                	ld	s6,16(sp)
ffffffffc0201110:	6ba2                	ld	s7,8(sp)
ffffffffc0201112:	6c02                	ld	s8,0(sp)
ffffffffc0201114:	6161                	addi	sp,sp,80
ffffffffc0201116:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201118:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020111a:	4481                	li	s1,0
ffffffffc020111c:	4901                	li	s2,0
ffffffffc020111e:	b38d                	j	ffffffffc0200e80 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201120:	00006697          	auipc	a3,0x6
ffffffffc0201124:	e7068693          	addi	a3,a3,-400 # ffffffffc0206f90 <commands+0x740>
ffffffffc0201128:	00006617          	auipc	a2,0x6
ffffffffc020112c:	b7860613          	addi	a2,a2,-1160 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201130:	0f000593          	li	a1,240
ffffffffc0201134:	00006517          	auipc	a0,0x6
ffffffffc0201138:	e6c50513          	addi	a0,a0,-404 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020113c:	b3eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201140:	00006697          	auipc	a3,0x6
ffffffffc0201144:	ef868693          	addi	a3,a3,-264 # ffffffffc0207038 <commands+0x7e8>
ffffffffc0201148:	00006617          	auipc	a2,0x6
ffffffffc020114c:	b5860613          	addi	a2,a2,-1192 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201150:	0bd00593          	li	a1,189
ffffffffc0201154:	00006517          	auipc	a0,0x6
ffffffffc0201158:	e4c50513          	addi	a0,a0,-436 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020115c:	b1eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201160:	00006697          	auipc	a3,0x6
ffffffffc0201164:	f0068693          	addi	a3,a3,-256 # ffffffffc0207060 <commands+0x810>
ffffffffc0201168:	00006617          	auipc	a2,0x6
ffffffffc020116c:	b3860613          	addi	a2,a2,-1224 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201170:	0be00593          	li	a1,190
ffffffffc0201174:	00006517          	auipc	a0,0x6
ffffffffc0201178:	e2c50513          	addi	a0,a0,-468 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020117c:	afeff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201180:	00006697          	auipc	a3,0x6
ffffffffc0201184:	f2068693          	addi	a3,a3,-224 # ffffffffc02070a0 <commands+0x850>
ffffffffc0201188:	00006617          	auipc	a2,0x6
ffffffffc020118c:	b1860613          	addi	a2,a2,-1256 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201190:	0c000593          	li	a1,192
ffffffffc0201194:	00006517          	auipc	a0,0x6
ffffffffc0201198:	e0c50513          	addi	a0,a0,-500 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020119c:	adeff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(!list_empty(&free_list));
ffffffffc02011a0:	00006697          	auipc	a3,0x6
ffffffffc02011a4:	f8868693          	addi	a3,a3,-120 # ffffffffc0207128 <commands+0x8d8>
ffffffffc02011a8:	00006617          	auipc	a2,0x6
ffffffffc02011ac:	af860613          	addi	a2,a2,-1288 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02011b0:	0d900593          	li	a1,217
ffffffffc02011b4:	00006517          	auipc	a0,0x6
ffffffffc02011b8:	dec50513          	addi	a0,a0,-532 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02011bc:	abeff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011c0:	00006697          	auipc	a3,0x6
ffffffffc02011c4:	e1868693          	addi	a3,a3,-488 # ffffffffc0206fd8 <commands+0x788>
ffffffffc02011c8:	00006617          	auipc	a2,0x6
ffffffffc02011cc:	ad860613          	addi	a2,a2,-1320 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02011d0:	0d200593          	li	a1,210
ffffffffc02011d4:	00006517          	auipc	a0,0x6
ffffffffc02011d8:	dcc50513          	addi	a0,a0,-564 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02011dc:	a9eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free == 3);
ffffffffc02011e0:	00006697          	auipc	a3,0x6
ffffffffc02011e4:	f3868693          	addi	a3,a3,-200 # ffffffffc0207118 <commands+0x8c8>
ffffffffc02011e8:	00006617          	auipc	a2,0x6
ffffffffc02011ec:	ab860613          	addi	a2,a2,-1352 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02011f0:	0d000593          	li	a1,208
ffffffffc02011f4:	00006517          	auipc	a0,0x6
ffffffffc02011f8:	dac50513          	addi	a0,a0,-596 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02011fc:	a7eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201200:	00006697          	auipc	a3,0x6
ffffffffc0201204:	f0068693          	addi	a3,a3,-256 # ffffffffc0207100 <commands+0x8b0>
ffffffffc0201208:	00006617          	auipc	a2,0x6
ffffffffc020120c:	a9860613          	addi	a2,a2,-1384 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201210:	0cb00593          	li	a1,203
ffffffffc0201214:	00006517          	auipc	a0,0x6
ffffffffc0201218:	d8c50513          	addi	a0,a0,-628 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020121c:	a5eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201220:	00006697          	auipc	a3,0x6
ffffffffc0201224:	ec068693          	addi	a3,a3,-320 # ffffffffc02070e0 <commands+0x890>
ffffffffc0201228:	00006617          	auipc	a2,0x6
ffffffffc020122c:	a7860613          	addi	a2,a2,-1416 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201230:	0c200593          	li	a1,194
ffffffffc0201234:	00006517          	auipc	a0,0x6
ffffffffc0201238:	d6c50513          	addi	a0,a0,-660 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020123c:	a3eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(p0 != NULL);
ffffffffc0201240:	00006697          	auipc	a3,0x6
ffffffffc0201244:	f3068693          	addi	a3,a3,-208 # ffffffffc0207170 <commands+0x920>
ffffffffc0201248:	00006617          	auipc	a2,0x6
ffffffffc020124c:	a5860613          	addi	a2,a2,-1448 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201250:	0f800593          	li	a1,248
ffffffffc0201254:	00006517          	auipc	a0,0x6
ffffffffc0201258:	d4c50513          	addi	a0,a0,-692 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020125c:	a1eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free == 0);
ffffffffc0201260:	00006697          	auipc	a3,0x6
ffffffffc0201264:	f0068693          	addi	a3,a3,-256 # ffffffffc0207160 <commands+0x910>
ffffffffc0201268:	00006617          	auipc	a2,0x6
ffffffffc020126c:	a3860613          	addi	a2,a2,-1480 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201270:	0df00593          	li	a1,223
ffffffffc0201274:	00006517          	auipc	a0,0x6
ffffffffc0201278:	d2c50513          	addi	a0,a0,-724 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020127c:	9feff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201280:	00006697          	auipc	a3,0x6
ffffffffc0201284:	e8068693          	addi	a3,a3,-384 # ffffffffc0207100 <commands+0x8b0>
ffffffffc0201288:	00006617          	auipc	a2,0x6
ffffffffc020128c:	a1860613          	addi	a2,a2,-1512 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201290:	0dd00593          	li	a1,221
ffffffffc0201294:	00006517          	auipc	a0,0x6
ffffffffc0201298:	d0c50513          	addi	a0,a0,-756 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020129c:	9deff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02012a0:	00006697          	auipc	a3,0x6
ffffffffc02012a4:	ea068693          	addi	a3,a3,-352 # ffffffffc0207140 <commands+0x8f0>
ffffffffc02012a8:	00006617          	auipc	a2,0x6
ffffffffc02012ac:	9f860613          	addi	a2,a2,-1544 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02012b0:	0dc00593          	li	a1,220
ffffffffc02012b4:	00006517          	auipc	a0,0x6
ffffffffc02012b8:	cec50513          	addi	a0,a0,-788 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02012bc:	9beff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012c0:	00006697          	auipc	a3,0x6
ffffffffc02012c4:	d1868693          	addi	a3,a3,-744 # ffffffffc0206fd8 <commands+0x788>
ffffffffc02012c8:	00006617          	auipc	a2,0x6
ffffffffc02012cc:	9d860613          	addi	a2,a2,-1576 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02012d0:	0b900593          	li	a1,185
ffffffffc02012d4:	00006517          	auipc	a0,0x6
ffffffffc02012d8:	ccc50513          	addi	a0,a0,-820 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02012dc:	99eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012e0:	00006697          	auipc	a3,0x6
ffffffffc02012e4:	e2068693          	addi	a3,a3,-480 # ffffffffc0207100 <commands+0x8b0>
ffffffffc02012e8:	00006617          	auipc	a2,0x6
ffffffffc02012ec:	9b860613          	addi	a2,a2,-1608 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02012f0:	0d600593          	li	a1,214
ffffffffc02012f4:	00006517          	auipc	a0,0x6
ffffffffc02012f8:	cac50513          	addi	a0,a0,-852 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02012fc:	97eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201300:	00006697          	auipc	a3,0x6
ffffffffc0201304:	d1868693          	addi	a3,a3,-744 # ffffffffc0207018 <commands+0x7c8>
ffffffffc0201308:	00006617          	auipc	a2,0x6
ffffffffc020130c:	99860613          	addi	a2,a2,-1640 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201310:	0d400593          	li	a1,212
ffffffffc0201314:	00006517          	auipc	a0,0x6
ffffffffc0201318:	c8c50513          	addi	a0,a0,-884 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020131c:	95eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201320:	00006697          	auipc	a3,0x6
ffffffffc0201324:	cd868693          	addi	a3,a3,-808 # ffffffffc0206ff8 <commands+0x7a8>
ffffffffc0201328:	00006617          	auipc	a2,0x6
ffffffffc020132c:	97860613          	addi	a2,a2,-1672 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201330:	0d300593          	li	a1,211
ffffffffc0201334:	00006517          	auipc	a0,0x6
ffffffffc0201338:	c6c50513          	addi	a0,a0,-916 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020133c:	93eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201340:	00006697          	auipc	a3,0x6
ffffffffc0201344:	cd868693          	addi	a3,a3,-808 # ffffffffc0207018 <commands+0x7c8>
ffffffffc0201348:	00006617          	auipc	a2,0x6
ffffffffc020134c:	95860613          	addi	a2,a2,-1704 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201350:	0bb00593          	li	a1,187
ffffffffc0201354:	00006517          	auipc	a0,0x6
ffffffffc0201358:	c4c50513          	addi	a0,a0,-948 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020135c:	91eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(count == 0);
ffffffffc0201360:	00006697          	auipc	a3,0x6
ffffffffc0201364:	f6068693          	addi	a3,a3,-160 # ffffffffc02072c0 <commands+0xa70>
ffffffffc0201368:	00006617          	auipc	a2,0x6
ffffffffc020136c:	93860613          	addi	a2,a2,-1736 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201370:	12500593          	li	a1,293
ffffffffc0201374:	00006517          	auipc	a0,0x6
ffffffffc0201378:	c2c50513          	addi	a0,a0,-980 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020137c:	8feff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free == 0);
ffffffffc0201380:	00006697          	auipc	a3,0x6
ffffffffc0201384:	de068693          	addi	a3,a3,-544 # ffffffffc0207160 <commands+0x910>
ffffffffc0201388:	00006617          	auipc	a2,0x6
ffffffffc020138c:	91860613          	addi	a2,a2,-1768 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201390:	11a00593          	li	a1,282
ffffffffc0201394:	00006517          	auipc	a0,0x6
ffffffffc0201398:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020139c:	8deff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013a0:	00006697          	auipc	a3,0x6
ffffffffc02013a4:	d6068693          	addi	a3,a3,-672 # ffffffffc0207100 <commands+0x8b0>
ffffffffc02013a8:	00006617          	auipc	a2,0x6
ffffffffc02013ac:	8f860613          	addi	a2,a2,-1800 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02013b0:	11800593          	li	a1,280
ffffffffc02013b4:	00006517          	auipc	a0,0x6
ffffffffc02013b8:	bec50513          	addi	a0,a0,-1044 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02013bc:	8beff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02013c0:	00006697          	auipc	a3,0x6
ffffffffc02013c4:	d0068693          	addi	a3,a3,-768 # ffffffffc02070c0 <commands+0x870>
ffffffffc02013c8:	00006617          	auipc	a2,0x6
ffffffffc02013cc:	8d860613          	addi	a2,a2,-1832 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02013d0:	0c100593          	li	a1,193
ffffffffc02013d4:	00006517          	auipc	a0,0x6
ffffffffc02013d8:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02013dc:	89eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02013e0:	00006697          	auipc	a3,0x6
ffffffffc02013e4:	ea068693          	addi	a3,a3,-352 # ffffffffc0207280 <commands+0xa30>
ffffffffc02013e8:	00006617          	auipc	a2,0x6
ffffffffc02013ec:	8b860613          	addi	a2,a2,-1864 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02013f0:	11200593          	li	a1,274
ffffffffc02013f4:	00006517          	auipc	a0,0x6
ffffffffc02013f8:	bac50513          	addi	a0,a0,-1108 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02013fc:	87eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201400:	00006697          	auipc	a3,0x6
ffffffffc0201404:	e6068693          	addi	a3,a3,-416 # ffffffffc0207260 <commands+0xa10>
ffffffffc0201408:	00006617          	auipc	a2,0x6
ffffffffc020140c:	89860613          	addi	a2,a2,-1896 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201410:	11000593          	li	a1,272
ffffffffc0201414:	00006517          	auipc	a0,0x6
ffffffffc0201418:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020141c:	85eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201420:	00006697          	auipc	a3,0x6
ffffffffc0201424:	e1868693          	addi	a3,a3,-488 # ffffffffc0207238 <commands+0x9e8>
ffffffffc0201428:	00006617          	auipc	a2,0x6
ffffffffc020142c:	87860613          	addi	a2,a2,-1928 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201430:	10e00593          	li	a1,270
ffffffffc0201434:	00006517          	auipc	a0,0x6
ffffffffc0201438:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020143c:	83eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201440:	00006697          	auipc	a3,0x6
ffffffffc0201444:	dd068693          	addi	a3,a3,-560 # ffffffffc0207210 <commands+0x9c0>
ffffffffc0201448:	00006617          	auipc	a2,0x6
ffffffffc020144c:	85860613          	addi	a2,a2,-1960 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201450:	10d00593          	li	a1,269
ffffffffc0201454:	00006517          	auipc	a0,0x6
ffffffffc0201458:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020145c:	81eff0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201460:	00006697          	auipc	a3,0x6
ffffffffc0201464:	da068693          	addi	a3,a3,-608 # ffffffffc0207200 <commands+0x9b0>
ffffffffc0201468:	00006617          	auipc	a2,0x6
ffffffffc020146c:	83860613          	addi	a2,a2,-1992 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201470:	10800593          	li	a1,264
ffffffffc0201474:	00006517          	auipc	a0,0x6
ffffffffc0201478:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020147c:	ffffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201480:	00006697          	auipc	a3,0x6
ffffffffc0201484:	c8068693          	addi	a3,a3,-896 # ffffffffc0207100 <commands+0x8b0>
ffffffffc0201488:	00006617          	auipc	a2,0x6
ffffffffc020148c:	81860613          	addi	a2,a2,-2024 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201490:	10700593          	li	a1,263
ffffffffc0201494:	00006517          	auipc	a0,0x6
ffffffffc0201498:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020149c:	fdffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02014a0:	00006697          	auipc	a3,0x6
ffffffffc02014a4:	d4068693          	addi	a3,a3,-704 # ffffffffc02071e0 <commands+0x990>
ffffffffc02014a8:	00005617          	auipc	a2,0x5
ffffffffc02014ac:	7f860613          	addi	a2,a2,2040 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02014b0:	10600593          	li	a1,262
ffffffffc02014b4:	00006517          	auipc	a0,0x6
ffffffffc02014b8:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02014bc:	fbffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02014c0:	00006697          	auipc	a3,0x6
ffffffffc02014c4:	cf068693          	addi	a3,a3,-784 # ffffffffc02071b0 <commands+0x960>
ffffffffc02014c8:	00005617          	auipc	a2,0x5
ffffffffc02014cc:	7d860613          	addi	a2,a2,2008 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02014d0:	10500593          	li	a1,261
ffffffffc02014d4:	00006517          	auipc	a0,0x6
ffffffffc02014d8:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02014dc:	f9ffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02014e0:	00006697          	auipc	a3,0x6
ffffffffc02014e4:	cb868693          	addi	a3,a3,-840 # ffffffffc0207198 <commands+0x948>
ffffffffc02014e8:	00005617          	auipc	a2,0x5
ffffffffc02014ec:	7b860613          	addi	a2,a2,1976 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02014f0:	10400593          	li	a1,260
ffffffffc02014f4:	00006517          	auipc	a0,0x6
ffffffffc02014f8:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02014fc:	f7ffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201500:	00006697          	auipc	a3,0x6
ffffffffc0201504:	c0068693          	addi	a3,a3,-1024 # ffffffffc0207100 <commands+0x8b0>
ffffffffc0201508:	00005617          	auipc	a2,0x5
ffffffffc020150c:	79860613          	addi	a2,a2,1944 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201510:	0fe00593          	li	a1,254
ffffffffc0201514:	00006517          	auipc	a0,0x6
ffffffffc0201518:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020151c:	f5ffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(!PageProperty(p0));
ffffffffc0201520:	00006697          	auipc	a3,0x6
ffffffffc0201524:	c6068693          	addi	a3,a3,-928 # ffffffffc0207180 <commands+0x930>
ffffffffc0201528:	00005617          	auipc	a2,0x5
ffffffffc020152c:	77860613          	addi	a2,a2,1912 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201530:	0f900593          	li	a1,249
ffffffffc0201534:	00006517          	auipc	a0,0x6
ffffffffc0201538:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020153c:	f3ffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201540:	00006697          	auipc	a3,0x6
ffffffffc0201544:	d6068693          	addi	a3,a3,-672 # ffffffffc02072a0 <commands+0xa50>
ffffffffc0201548:	00005617          	auipc	a2,0x5
ffffffffc020154c:	75860613          	addi	a2,a2,1880 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201550:	11700593          	li	a1,279
ffffffffc0201554:	00006517          	auipc	a0,0x6
ffffffffc0201558:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020155c:	f1ffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(total == 0);
ffffffffc0201560:	00006697          	auipc	a3,0x6
ffffffffc0201564:	d7068693          	addi	a3,a3,-656 # ffffffffc02072d0 <commands+0xa80>
ffffffffc0201568:	00005617          	auipc	a2,0x5
ffffffffc020156c:	73860613          	addi	a2,a2,1848 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201570:	12600593          	li	a1,294
ffffffffc0201574:	00006517          	auipc	a0,0x6
ffffffffc0201578:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020157c:	efffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201580:	00006697          	auipc	a3,0x6
ffffffffc0201584:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206fb8 <commands+0x768>
ffffffffc0201588:	00005617          	auipc	a2,0x5
ffffffffc020158c:	71860613          	addi	a2,a2,1816 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201590:	0f300593          	li	a1,243
ffffffffc0201594:	00006517          	auipc	a0,0x6
ffffffffc0201598:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020159c:	edffe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02015a0:	00006697          	auipc	a3,0x6
ffffffffc02015a4:	a5868693          	addi	a3,a3,-1448 # ffffffffc0206ff8 <commands+0x7a8>
ffffffffc02015a8:	00005617          	auipc	a2,0x5
ffffffffc02015ac:	6f860613          	addi	a2,a2,1784 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02015b0:	0ba00593          	li	a1,186
ffffffffc02015b4:	00006517          	auipc	a0,0x6
ffffffffc02015b8:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02015bc:	ebffe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02015c0 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02015c0:	1141                	addi	sp,sp,-16
ffffffffc02015c2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015c4:	12058f63          	beqz	a1,ffffffffc0201702 <default_free_pages+0x142>
    for (; p != base + n; p ++) {
ffffffffc02015c8:	00659693          	slli	a3,a1,0x6
ffffffffc02015cc:	96aa                	add	a3,a3,a0
ffffffffc02015ce:	87aa                	mv	a5,a0
ffffffffc02015d0:	02d50263          	beq	a0,a3,ffffffffc02015f4 <default_free_pages+0x34>
ffffffffc02015d4:	6798                	ld	a4,8(a5)
ffffffffc02015d6:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015d8:	10071563          	bnez	a4,ffffffffc02016e2 <default_free_pages+0x122>
ffffffffc02015dc:	6798                	ld	a4,8(a5)
ffffffffc02015de:	8b09                	andi	a4,a4,2
ffffffffc02015e0:	10071163          	bnez	a4,ffffffffc02016e2 <default_free_pages+0x122>
        p->flags = 0;
ffffffffc02015e4:	0007b423          	sd	zero,8(a5)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc02015e8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015ec:	04078793          	addi	a5,a5,64
ffffffffc02015f0:	fed792e3          	bne	a5,a3,ffffffffc02015d4 <default_free_pages+0x14>
    base->property = n;
ffffffffc02015f4:	2581                	sext.w	a1,a1
ffffffffc02015f6:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02015f8:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015fc:	4789                	li	a5,2
ffffffffc02015fe:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201602:	000ad697          	auipc	a3,0xad
ffffffffc0201606:	10668693          	addi	a3,a3,262 # ffffffffc02ae708 <free_area>
ffffffffc020160a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020160c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020160e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201612:	9db9                	addw	a1,a1,a4
ffffffffc0201614:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201616:	08d78f63          	beq	a5,a3,ffffffffc02016b4 <default_free_pages+0xf4>
            struct Page* page = le2page(le, page_link);
ffffffffc020161a:	fe878713          	addi	a4,a5,-24
ffffffffc020161e:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201622:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201624:	00e56a63          	bltu	a0,a4,ffffffffc0201638 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201628:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020162a:	04d70a63          	beq	a4,a3,ffffffffc020167e <default_free_pages+0xbe>
    for (; p != base + n; p ++) {
ffffffffc020162e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201630:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201634:	fee57ae3          	bgeu	a0,a4,ffffffffc0201628 <default_free_pages+0x68>
ffffffffc0201638:	c199                	beqz	a1,ffffffffc020163e <default_free_pages+0x7e>
ffffffffc020163a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020163e:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201640:	e390                	sd	a2,0(a5)
ffffffffc0201642:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201644:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201646:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201648:	00d70c63          	beq	a4,a3,ffffffffc0201660 <default_free_pages+0xa0>
        if (p + p->property == base) {
ffffffffc020164c:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201650:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0201654:	02059793          	slli	a5,a1,0x20
ffffffffc0201658:	83e9                	srli	a5,a5,0x1a
ffffffffc020165a:	97b2                	add	a5,a5,a2
ffffffffc020165c:	02f50b63          	beq	a0,a5,ffffffffc0201692 <default_free_pages+0xd2>
    return listelm->next;
ffffffffc0201660:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0201662:	00d70b63          	beq	a4,a3,ffffffffc0201678 <default_free_pages+0xb8>
        if (base + base->property == p) {
ffffffffc0201666:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201668:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc020166c:	02061793          	slli	a5,a2,0x20
ffffffffc0201670:	83e9                	srli	a5,a5,0x1a
ffffffffc0201672:	97aa                	add	a5,a5,a0
ffffffffc0201674:	04f68763          	beq	a3,a5,ffffffffc02016c2 <default_free_pages+0x102>
}
ffffffffc0201678:	60a2                	ld	ra,8(sp)
ffffffffc020167a:	0141                	addi	sp,sp,16
ffffffffc020167c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020167e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201680:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201682:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201684:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201686:	02d70463          	beq	a4,a3,ffffffffc02016ae <default_free_pages+0xee>
    prev->next = next->prev = elm;
ffffffffc020168a:	8832                	mv	a6,a2
ffffffffc020168c:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020168e:	87ba                	mv	a5,a4
ffffffffc0201690:	b745                	j	ffffffffc0201630 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201692:	491c                	lw	a5,16(a0)
ffffffffc0201694:	9dbd                	addw	a1,a1,a5
ffffffffc0201696:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020169a:	57f5                	li	a5,-3
ffffffffc020169c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02016a0:	6d0c                	ld	a1,24(a0)
ffffffffc02016a2:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc02016a4:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02016a6:	e59c                	sd	a5,8(a1)
    return listelm->next;
ffffffffc02016a8:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02016aa:	e38c                	sd	a1,0(a5)
ffffffffc02016ac:	bf5d                	j	ffffffffc0201662 <default_free_pages+0xa2>
ffffffffc02016ae:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02016b0:	873e                	mv	a4,a5
ffffffffc02016b2:	bf69                	j	ffffffffc020164c <default_free_pages+0x8c>
}
ffffffffc02016b4:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02016b6:	e390                	sd	a2,0(a5)
ffffffffc02016b8:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02016ba:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02016bc:	ed1c                	sd	a5,24(a0)
ffffffffc02016be:	0141                	addi	sp,sp,16
ffffffffc02016c0:	8082                	ret
            base->property += p->property;
ffffffffc02016c2:	ff872783          	lw	a5,-8(a4)
ffffffffc02016c6:	ff070693          	addi	a3,a4,-16
ffffffffc02016ca:	9e3d                	addw	a2,a2,a5
ffffffffc02016cc:	c910                	sw	a2,16(a0)
ffffffffc02016ce:	57f5                	li	a5,-3
ffffffffc02016d0:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02016d4:	6314                	ld	a3,0(a4)
ffffffffc02016d6:	671c                	ld	a5,8(a4)
}
ffffffffc02016d8:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02016da:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02016dc:	e394                	sd	a3,0(a5)
ffffffffc02016de:	0141                	addi	sp,sp,16
ffffffffc02016e0:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016e2:	00006697          	auipc	a3,0x6
ffffffffc02016e6:	c0668693          	addi	a3,a3,-1018 # ffffffffc02072e8 <commands+0xa98>
ffffffffc02016ea:	00005617          	auipc	a2,0x5
ffffffffc02016ee:	5b660613          	addi	a2,a2,1462 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02016f2:	08300593          	li	a1,131
ffffffffc02016f6:	00006517          	auipc	a0,0x6
ffffffffc02016fa:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02016fe:	d7dfe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(n > 0);
ffffffffc0201702:	00006697          	auipc	a3,0x6
ffffffffc0201706:	bde68693          	addi	a3,a3,-1058 # ffffffffc02072e0 <commands+0xa90>
ffffffffc020170a:	00005617          	auipc	a2,0x5
ffffffffc020170e:	59660613          	addi	a2,a2,1430 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201712:	08000593          	li	a1,128
ffffffffc0201716:	00006517          	auipc	a0,0x6
ffffffffc020171a:	88a50513          	addi	a0,a0,-1910 # ffffffffc0206fa0 <commands+0x750>
ffffffffc020171e:	d5dfe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201722 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201722:	c941                	beqz	a0,ffffffffc02017b2 <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc0201724:	000ad597          	auipc	a1,0xad
ffffffffc0201728:	fe458593          	addi	a1,a1,-28 # ffffffffc02ae708 <free_area>
ffffffffc020172c:	0105a803          	lw	a6,16(a1)
ffffffffc0201730:	872a                	mv	a4,a0
ffffffffc0201732:	02081793          	slli	a5,a6,0x20
ffffffffc0201736:	9381                	srli	a5,a5,0x20
ffffffffc0201738:	00a7ee63          	bltu	a5,a0,ffffffffc0201754 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020173c:	87ae                	mv	a5,a1
ffffffffc020173e:	a801                	j	ffffffffc020174e <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201740:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201744:	02069613          	slli	a2,a3,0x20
ffffffffc0201748:	9201                	srli	a2,a2,0x20
ffffffffc020174a:	00e67763          	bgeu	a2,a4,ffffffffc0201758 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc020174e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201750:	feb798e3          	bne	a5,a1,ffffffffc0201740 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201754:	4501                	li	a0,0
}
ffffffffc0201756:	8082                	ret
    return listelm->prev;
ffffffffc0201758:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020175c:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201760:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201764:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201768:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020176c:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201770:	02c77863          	bgeu	a4,a2,ffffffffc02017a0 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201774:	071a                	slli	a4,a4,0x6
ffffffffc0201776:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201778:	41c686bb          	subw	a3,a3,t3
ffffffffc020177c:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020177e:	00870613          	addi	a2,a4,8
ffffffffc0201782:	4689                	li	a3,2
ffffffffc0201784:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201788:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020178c:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201790:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201794:	e290                	sd	a2,0(a3)
ffffffffc0201796:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020179a:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020179c:	01173c23          	sd	a7,24(a4)
ffffffffc02017a0:	41c8083b          	subw	a6,a6,t3
ffffffffc02017a4:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02017a8:	5775                	li	a4,-3
ffffffffc02017aa:	17c1                	addi	a5,a5,-16
ffffffffc02017ac:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02017b0:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02017b2:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02017b4:	00006697          	auipc	a3,0x6
ffffffffc02017b8:	b2c68693          	addi	a3,a3,-1236 # ffffffffc02072e0 <commands+0xa90>
ffffffffc02017bc:	00005617          	auipc	a2,0x5
ffffffffc02017c0:	4e460613          	addi	a2,a2,1252 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02017c4:	06200593          	li	a1,98
ffffffffc02017c8:	00005517          	auipc	a0,0x5
ffffffffc02017cc:	7d850513          	addi	a0,a0,2008 # ffffffffc0206fa0 <commands+0x750>
default_alloc_pages(size_t n) {
ffffffffc02017d0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017d2:	ca9fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02017d6 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02017d6:	1141                	addi	sp,sp,-16
ffffffffc02017d8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017da:	c5f1                	beqz	a1,ffffffffc02018a6 <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc02017dc:	00659693          	slli	a3,a1,0x6
ffffffffc02017e0:	96aa                	add	a3,a3,a0
ffffffffc02017e2:	87aa                	mv	a5,a0
ffffffffc02017e4:	00d50f63          	beq	a0,a3,ffffffffc0201802 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02017e8:	6798                	ld	a4,8(a5)
ffffffffc02017ea:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02017ec:	cf49                	beqz	a4,ffffffffc0201886 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02017ee:	0007a823          	sw	zero,16(a5)
ffffffffc02017f2:	0007b423          	sd	zero,8(a5)
ffffffffc02017f6:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02017fa:	04078793          	addi	a5,a5,64
ffffffffc02017fe:	fed795e3          	bne	a5,a3,ffffffffc02017e8 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201802:	2581                	sext.w	a1,a1
ffffffffc0201804:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201806:	4789                	li	a5,2
ffffffffc0201808:	00850713          	addi	a4,a0,8
ffffffffc020180c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201810:	000ad697          	auipc	a3,0xad
ffffffffc0201814:	ef868693          	addi	a3,a3,-264 # ffffffffc02ae708 <free_area>
ffffffffc0201818:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020181a:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020181c:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201820:	9db9                	addw	a1,a1,a4
ffffffffc0201822:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201824:	04d78a63          	beq	a5,a3,ffffffffc0201878 <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc0201828:	fe878713          	addi	a4,a5,-24
ffffffffc020182c:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201830:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201832:	00e56a63          	bltu	a0,a4,ffffffffc0201846 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201836:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201838:	02d70263          	beq	a4,a3,ffffffffc020185c <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc020183c:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020183e:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201842:	fee57ae3          	bgeu	a0,a4,ffffffffc0201836 <default_init_memmap+0x60>
ffffffffc0201846:	c199                	beqz	a1,ffffffffc020184c <default_init_memmap+0x76>
ffffffffc0201848:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020184c:	6398                	ld	a4,0(a5)
}
ffffffffc020184e:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201850:	e390                	sd	a2,0(a5)
ffffffffc0201852:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201854:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201856:	ed18                	sd	a4,24(a0)
ffffffffc0201858:	0141                	addi	sp,sp,16
ffffffffc020185a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020185c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020185e:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201860:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201862:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201864:	00d70663          	beq	a4,a3,ffffffffc0201870 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201868:	8832                	mv	a6,a2
ffffffffc020186a:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020186c:	87ba                	mv	a5,a4
ffffffffc020186e:	bfc1                	j	ffffffffc020183e <default_init_memmap+0x68>
}
ffffffffc0201870:	60a2                	ld	ra,8(sp)
ffffffffc0201872:	e290                	sd	a2,0(a3)
ffffffffc0201874:	0141                	addi	sp,sp,16
ffffffffc0201876:	8082                	ret
ffffffffc0201878:	60a2                	ld	ra,8(sp)
ffffffffc020187a:	e390                	sd	a2,0(a5)
ffffffffc020187c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020187e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201880:	ed1c                	sd	a5,24(a0)
ffffffffc0201882:	0141                	addi	sp,sp,16
ffffffffc0201884:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201886:	00006697          	auipc	a3,0x6
ffffffffc020188a:	a8a68693          	addi	a3,a3,-1398 # ffffffffc0207310 <commands+0xac0>
ffffffffc020188e:	00005617          	auipc	a2,0x5
ffffffffc0201892:	41260613          	addi	a2,a2,1042 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201896:	04900593          	li	a1,73
ffffffffc020189a:	00005517          	auipc	a0,0x5
ffffffffc020189e:	70650513          	addi	a0,a0,1798 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02018a2:	bd9fe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(n > 0);
ffffffffc02018a6:	00006697          	auipc	a3,0x6
ffffffffc02018aa:	a3a68693          	addi	a3,a3,-1478 # ffffffffc02072e0 <commands+0xa90>
ffffffffc02018ae:	00005617          	auipc	a2,0x5
ffffffffc02018b2:	3f260613          	addi	a2,a2,1010 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02018b6:	04600593          	li	a1,70
ffffffffc02018ba:	00005517          	auipc	a0,0x5
ffffffffc02018be:	6e650513          	addi	a0,a0,1766 # ffffffffc0206fa0 <commands+0x750>
ffffffffc02018c2:	bb9fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02018c6 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02018c6:	c94d                	beqz	a0,ffffffffc0201978 <slob_free+0xb2>
{
ffffffffc02018c8:	1141                	addi	sp,sp,-16
ffffffffc02018ca:	e022                	sd	s0,0(sp)
ffffffffc02018cc:	e406                	sd	ra,8(sp)
ffffffffc02018ce:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02018d0:	e9c1                	bnez	a1,ffffffffc0201960 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018d2:	100027f3          	csrr	a5,sstatus
ffffffffc02018d6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02018d8:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018da:	ebd9                	bnez	a5,ffffffffc0201970 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018dc:	000a6617          	auipc	a2,0xa6
ffffffffc02018e0:	a1c60613          	addi	a2,a2,-1508 # ffffffffc02a72f8 <slobfree>
ffffffffc02018e4:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018e6:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018e8:	679c                	ld	a5,8(a5)
ffffffffc02018ea:	02877a63          	bgeu	a4,s0,ffffffffc020191e <slob_free+0x58>
ffffffffc02018ee:	00f46463          	bltu	s0,a5,ffffffffc02018f6 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018f2:	fef76ae3          	bltu	a4,a5,ffffffffc02018e6 <slob_free+0x20>
			break;

	if (b + b->units == cur->next) {
ffffffffc02018f6:	400c                	lw	a1,0(s0)
ffffffffc02018f8:	00459693          	slli	a3,a1,0x4
ffffffffc02018fc:	96a2                	add	a3,a3,s0
ffffffffc02018fe:	02d78a63          	beq	a5,a3,ffffffffc0201932 <slob_free+0x6c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc0201902:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201904:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc0201906:	00469793          	slli	a5,a3,0x4
ffffffffc020190a:	97ba                	add	a5,a5,a4
ffffffffc020190c:	02f40e63          	beq	s0,a5,ffffffffc0201948 <slob_free+0x82>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc0201910:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201912:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc0201914:	e129                	bnez	a0,ffffffffc0201956 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201916:	60a2                	ld	ra,8(sp)
ffffffffc0201918:	6402                	ld	s0,0(sp)
ffffffffc020191a:	0141                	addi	sp,sp,16
ffffffffc020191c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020191e:	fcf764e3          	bltu	a4,a5,ffffffffc02018e6 <slob_free+0x20>
ffffffffc0201922:	fcf472e3          	bgeu	s0,a5,ffffffffc02018e6 <slob_free+0x20>
	if (b + b->units == cur->next) {
ffffffffc0201926:	400c                	lw	a1,0(s0)
ffffffffc0201928:	00459693          	slli	a3,a1,0x4
ffffffffc020192c:	96a2                	add	a3,a3,s0
ffffffffc020192e:	fcd79ae3          	bne	a5,a3,ffffffffc0201902 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201932:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201934:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201936:	9db5                	addw	a1,a1,a3
ffffffffc0201938:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b) {
ffffffffc020193a:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020193c:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc020193e:	00469793          	slli	a5,a3,0x4
ffffffffc0201942:	97ba                	add	a5,a5,a4
ffffffffc0201944:	fcf416e3          	bne	s0,a5,ffffffffc0201910 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201948:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc020194a:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc020194c:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc020194e:	9ebd                	addw	a3,a3,a5
ffffffffc0201950:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201952:	e70c                	sd	a1,8(a4)
ffffffffc0201954:	d169                	beqz	a0,ffffffffc0201916 <slob_free+0x50>
}
ffffffffc0201956:	6402                	ld	s0,0(sp)
ffffffffc0201958:	60a2                	ld	ra,8(sp)
ffffffffc020195a:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020195c:	ce5fe06f          	j	ffffffffc0200640 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201960:	25bd                	addiw	a1,a1,15
ffffffffc0201962:	8191                	srli	a1,a1,0x4
ffffffffc0201964:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201966:	100027f3          	csrr	a5,sstatus
ffffffffc020196a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020196c:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020196e:	d7bd                	beqz	a5,ffffffffc02018dc <slob_free+0x16>
        intr_disable();
ffffffffc0201970:	cd7fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc0201974:	4505                	li	a0,1
ffffffffc0201976:	b79d                	j	ffffffffc02018dc <slob_free+0x16>
ffffffffc0201978:	8082                	ret

ffffffffc020197a <__slob_get_free_pages.constprop.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc020197a:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020197c:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc020197e:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201982:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc0201984:	352000ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
  if(!page)
ffffffffc0201988:	c91d                	beqz	a0,ffffffffc02019be <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc020198a:	000b1697          	auipc	a3,0xb1
ffffffffc020198e:	e7e6b683          	ld	a3,-386(a3) # ffffffffc02b2808 <pages>
ffffffffc0201992:	8d15                	sub	a0,a0,a3
ffffffffc0201994:	8519                	srai	a0,a0,0x6
ffffffffc0201996:	00007697          	auipc	a3,0x7
ffffffffc020199a:	3926b683          	ld	a3,914(a3) # ffffffffc0208d28 <nbase>
ffffffffc020199e:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc02019a0:	00c51793          	slli	a5,a0,0xc
ffffffffc02019a4:	83b1                	srli	a5,a5,0xc
ffffffffc02019a6:	000b1717          	auipc	a4,0xb1
ffffffffc02019aa:	e5a73703          	ld	a4,-422(a4) # ffffffffc02b2800 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02019ae:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02019b0:	00e7fa63          	bgeu	a5,a4,ffffffffc02019c4 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02019b4:	000b1697          	auipc	a3,0xb1
ffffffffc02019b8:	e646b683          	ld	a3,-412(a3) # ffffffffc02b2818 <va_pa_offset>
ffffffffc02019bc:	9536                	add	a0,a0,a3
}
ffffffffc02019be:	60a2                	ld	ra,8(sp)
ffffffffc02019c0:	0141                	addi	sp,sp,16
ffffffffc02019c2:	8082                	ret
ffffffffc02019c4:	86aa                	mv	a3,a0
ffffffffc02019c6:	00006617          	auipc	a2,0x6
ffffffffc02019ca:	9aa60613          	addi	a2,a2,-1622 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc02019ce:	06900593          	li	a1,105
ffffffffc02019d2:	00006517          	auipc	a0,0x6
ffffffffc02019d6:	9c650513          	addi	a0,a0,-1594 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc02019da:	aa1fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02019de <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02019de:	1101                	addi	sp,sp,-32
ffffffffc02019e0:	ec06                	sd	ra,24(sp)
ffffffffc02019e2:	e822                	sd	s0,16(sp)
ffffffffc02019e4:	e426                	sd	s1,8(sp)
ffffffffc02019e6:	e04a                	sd	s2,0(sp)
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02019e8:	01050713          	addi	a4,a0,16
ffffffffc02019ec:	6785                	lui	a5,0x1
ffffffffc02019ee:	0cf77363          	bgeu	a4,a5,ffffffffc0201ab4 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02019f2:	00f50493          	addi	s1,a0,15
ffffffffc02019f6:	8091                	srli	s1,s1,0x4
ffffffffc02019f8:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019fa:	10002673          	csrr	a2,sstatus
ffffffffc02019fe:	8a09                	andi	a2,a2,2
ffffffffc0201a00:	e25d                	bnez	a2,ffffffffc0201aa6 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201a02:	000a6917          	auipc	s2,0xa6
ffffffffc0201a06:	8f690913          	addi	s2,s2,-1802 # ffffffffc02a72f8 <slobfree>
ffffffffc0201a0a:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201a0e:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201a10:	4398                	lw	a4,0(a5)
ffffffffc0201a12:	08975e63          	bge	a4,s1,ffffffffc0201aae <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree) {
ffffffffc0201a16:	00f68b63          	beq	a3,a5,ffffffffc0201a2c <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201a1a:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201a1c:	4018                	lw	a4,0(s0)
ffffffffc0201a1e:	02975a63          	bge	a4,s1,ffffffffc0201a52 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree) {
ffffffffc0201a22:	00093683          	ld	a3,0(s2)
ffffffffc0201a26:	87a2                	mv	a5,s0
ffffffffc0201a28:	fef699e3          	bne	a3,a5,ffffffffc0201a1a <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc0201a2c:	ee31                	bnez	a2,ffffffffc0201a88 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201a2e:	4501                	li	a0,0
ffffffffc0201a30:	f4bff0ef          	jal	ra,ffffffffc020197a <__slob_get_free_pages.constprop.0>
ffffffffc0201a34:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201a36:	cd05                	beqz	a0,ffffffffc0201a6e <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201a38:	6585                	lui	a1,0x1
ffffffffc0201a3a:	e8dff0ef          	jal	ra,ffffffffc02018c6 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a3e:	10002673          	csrr	a2,sstatus
ffffffffc0201a42:	8a09                	andi	a2,a2,2
ffffffffc0201a44:	ee05                	bnez	a2,ffffffffc0201a7c <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201a46:	00093783          	ld	a5,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201a4a:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201a4c:	4018                	lw	a4,0(s0)
ffffffffc0201a4e:	fc974ae3          	blt	a4,s1,ffffffffc0201a22 <slob_alloc.constprop.0+0x44>
			if (cur->units == units) /* exact fit? */
ffffffffc0201a52:	04e48763          	beq	s1,a4,ffffffffc0201aa0 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201a56:	00449693          	slli	a3,s1,0x4
ffffffffc0201a5a:	96a2                	add	a3,a3,s0
ffffffffc0201a5c:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201a5e:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201a60:	9f05                	subw	a4,a4,s1
ffffffffc0201a62:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201a64:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201a66:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201a68:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc0201a6c:	e20d                	bnez	a2,ffffffffc0201a8e <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201a6e:	60e2                	ld	ra,24(sp)
ffffffffc0201a70:	8522                	mv	a0,s0
ffffffffc0201a72:	6442                	ld	s0,16(sp)
ffffffffc0201a74:	64a2                	ld	s1,8(sp)
ffffffffc0201a76:	6902                	ld	s2,0(sp)
ffffffffc0201a78:	6105                	addi	sp,sp,32
ffffffffc0201a7a:	8082                	ret
        intr_disable();
ffffffffc0201a7c:	bcbfe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
			cur = slobfree;
ffffffffc0201a80:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201a84:	4605                	li	a2,1
ffffffffc0201a86:	b7d1                	j	ffffffffc0201a4a <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201a88:	bb9fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0201a8c:	b74d                	j	ffffffffc0201a2e <slob_alloc.constprop.0+0x50>
ffffffffc0201a8e:	bb3fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
}
ffffffffc0201a92:	60e2                	ld	ra,24(sp)
ffffffffc0201a94:	8522                	mv	a0,s0
ffffffffc0201a96:	6442                	ld	s0,16(sp)
ffffffffc0201a98:	64a2                	ld	s1,8(sp)
ffffffffc0201a9a:	6902                	ld	s2,0(sp)
ffffffffc0201a9c:	6105                	addi	sp,sp,32
ffffffffc0201a9e:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201aa0:	6418                	ld	a4,8(s0)
ffffffffc0201aa2:	e798                	sd	a4,8(a5)
ffffffffc0201aa4:	b7d1                	j	ffffffffc0201a68 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201aa6:	ba1fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc0201aaa:	4605                	li	a2,1
ffffffffc0201aac:	bf99                	j	ffffffffc0201a02 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201aae:	843e                	mv	s0,a5
ffffffffc0201ab0:	87b6                	mv	a5,a3
ffffffffc0201ab2:	b745                	j	ffffffffc0201a52 <slob_alloc.constprop.0+0x74>
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201ab4:	00006697          	auipc	a3,0x6
ffffffffc0201ab8:	8f468693          	addi	a3,a3,-1804 # ffffffffc02073a8 <default_pmm_manager+0x70>
ffffffffc0201abc:	00005617          	auipc	a2,0x5
ffffffffc0201ac0:	1e460613          	addi	a2,a2,484 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0201ac4:	06400593          	li	a1,100
ffffffffc0201ac8:	00006517          	auipc	a0,0x6
ffffffffc0201acc:	90050513          	addi	a0,a0,-1792 # ffffffffc02073c8 <default_pmm_manager+0x90>
ffffffffc0201ad0:	9abfe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201ad4 <kmalloc_init>:
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
kmalloc_init(void) {
ffffffffc0201ad4:	1141                	addi	sp,sp,-16
  cprintf("use SLOB allocator\n");
ffffffffc0201ad6:	00006517          	auipc	a0,0x6
ffffffffc0201ada:	90a50513          	addi	a0,a0,-1782 # ffffffffc02073e0 <default_pmm_manager+0xa8>
kmalloc_init(void) {
ffffffffc0201ade:	e406                	sd	ra,8(sp)
  cprintf("use SLOB allocator\n");
ffffffffc0201ae0:	ea0fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    slob_init();
    cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201ae4:	60a2                	ld	ra,8(sp)
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ae6:	00006517          	auipc	a0,0x6
ffffffffc0201aea:	91250513          	addi	a0,a0,-1774 # ffffffffc02073f8 <default_pmm_manager+0xc0>
}
ffffffffc0201aee:	0141                	addi	sp,sp,16
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201af0:	e90fe06f          	j	ffffffffc0200180 <cprintf>

ffffffffc0201af4 <kallocated>:
}

size_t
kallocated(void) {
   return slob_allocated();
}
ffffffffc0201af4:	4501                	li	a0,0
ffffffffc0201af6:	8082                	ret

ffffffffc0201af8 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201af8:	1101                	addi	sp,sp,-32
ffffffffc0201afa:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201afc:	6905                	lui	s2,0x1
{
ffffffffc0201afe:	e822                	sd	s0,16(sp)
ffffffffc0201b00:	ec06                	sd	ra,24(sp)
ffffffffc0201b02:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201b04:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc1>
{
ffffffffc0201b08:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201b0a:	04a7f963          	bgeu	a5,a0,ffffffffc0201b5c <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201b0e:	4561                	li	a0,24
ffffffffc0201b10:	ecfff0ef          	jal	ra,ffffffffc02019de <slob_alloc.constprop.0>
ffffffffc0201b14:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201b16:	c929                	beqz	a0,ffffffffc0201b68 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201b18:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201b1c:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201b1e:	00f95763          	bge	s2,a5,ffffffffc0201b2c <kmalloc+0x34>
ffffffffc0201b22:	6705                	lui	a4,0x1
ffffffffc0201b24:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201b26:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201b28:	fef74ee3          	blt	a4,a5,ffffffffc0201b24 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201b2c:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201b2e:	e4dff0ef          	jal	ra,ffffffffc020197a <__slob_get_free_pages.constprop.0>
ffffffffc0201b32:	e488                	sd	a0,8(s1)
ffffffffc0201b34:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc0201b36:	c525                	beqz	a0,ffffffffc0201b9e <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b38:	100027f3          	csrr	a5,sstatus
ffffffffc0201b3c:	8b89                	andi	a5,a5,2
ffffffffc0201b3e:	ef8d                	bnez	a5,ffffffffc0201b78 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201b40:	000b1797          	auipc	a5,0xb1
ffffffffc0201b44:	ca878793          	addi	a5,a5,-856 # ffffffffc02b27e8 <bigblocks>
ffffffffc0201b48:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b4a:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b4c:	e898                	sd	a4,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc0201b4e:	60e2                	ld	ra,24(sp)
ffffffffc0201b50:	8522                	mv	a0,s0
ffffffffc0201b52:	6442                	ld	s0,16(sp)
ffffffffc0201b54:	64a2                	ld	s1,8(sp)
ffffffffc0201b56:	6902                	ld	s2,0(sp)
ffffffffc0201b58:	6105                	addi	sp,sp,32
ffffffffc0201b5a:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201b5c:	0541                	addi	a0,a0,16
ffffffffc0201b5e:	e81ff0ef          	jal	ra,ffffffffc02019de <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201b62:	01050413          	addi	s0,a0,16
ffffffffc0201b66:	f565                	bnez	a0,ffffffffc0201b4e <kmalloc+0x56>
ffffffffc0201b68:	4401                	li	s0,0
}
ffffffffc0201b6a:	60e2                	ld	ra,24(sp)
ffffffffc0201b6c:	8522                	mv	a0,s0
ffffffffc0201b6e:	6442                	ld	s0,16(sp)
ffffffffc0201b70:	64a2                	ld	s1,8(sp)
ffffffffc0201b72:	6902                	ld	s2,0(sp)
ffffffffc0201b74:	6105                	addi	sp,sp,32
ffffffffc0201b76:	8082                	ret
        intr_disable();
ffffffffc0201b78:	acffe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201b7c:	000b1797          	auipc	a5,0xb1
ffffffffc0201b80:	c6c78793          	addi	a5,a5,-916 # ffffffffc02b27e8 <bigblocks>
ffffffffc0201b84:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b86:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b88:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201b8a:	ab7fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
		return bb->pages;
ffffffffc0201b8e:	6480                	ld	s0,8(s1)
}
ffffffffc0201b90:	60e2                	ld	ra,24(sp)
ffffffffc0201b92:	64a2                	ld	s1,8(sp)
ffffffffc0201b94:	8522                	mv	a0,s0
ffffffffc0201b96:	6442                	ld	s0,16(sp)
ffffffffc0201b98:	6902                	ld	s2,0(sp)
ffffffffc0201b9a:	6105                	addi	sp,sp,32
ffffffffc0201b9c:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b9e:	45e1                	li	a1,24
ffffffffc0201ba0:	8526                	mv	a0,s1
ffffffffc0201ba2:	d25ff0ef          	jal	ra,ffffffffc02018c6 <slob_free>
  return __kmalloc(size, 0);
ffffffffc0201ba6:	b765                	j	ffffffffc0201b4e <kmalloc+0x56>

ffffffffc0201ba8 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201ba8:	c169                	beqz	a0,ffffffffc0201c6a <kfree+0xc2>
{
ffffffffc0201baa:	1101                	addi	sp,sp,-32
ffffffffc0201bac:	e822                	sd	s0,16(sp)
ffffffffc0201bae:	ec06                	sd	ra,24(sp)
ffffffffc0201bb0:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc0201bb2:	03451793          	slli	a5,a0,0x34
ffffffffc0201bb6:	842a                	mv	s0,a0
ffffffffc0201bb8:	e3d9                	bnez	a5,ffffffffc0201c3e <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201bba:	100027f3          	csrr	a5,sstatus
ffffffffc0201bbe:	8b89                	andi	a5,a5,2
ffffffffc0201bc0:	e7d9                	bnez	a5,ffffffffc0201c4e <kfree+0xa6>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201bc2:	000b1797          	auipc	a5,0xb1
ffffffffc0201bc6:	c267b783          	ld	a5,-986(a5) # ffffffffc02b27e8 <bigblocks>
    return 0;
ffffffffc0201bca:	4601                	li	a2,0
ffffffffc0201bcc:	cbad                	beqz	a5,ffffffffc0201c3e <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201bce:	000b1697          	auipc	a3,0xb1
ffffffffc0201bd2:	c1a68693          	addi	a3,a3,-998 # ffffffffc02b27e8 <bigblocks>
ffffffffc0201bd6:	a021                	j	ffffffffc0201bde <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201bd8:	01048693          	addi	a3,s1,16
ffffffffc0201bdc:	c3a5                	beqz	a5,ffffffffc0201c3c <kfree+0x94>
			if (bb->pages == block) {
ffffffffc0201bde:	6798                	ld	a4,8(a5)
ffffffffc0201be0:	84be                	mv	s1,a5
				*last = bb->next;
ffffffffc0201be2:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc0201be4:	fe871ae3          	bne	a4,s0,ffffffffc0201bd8 <kfree+0x30>
				*last = bb->next;
ffffffffc0201be8:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201bea:	ee2d                	bnez	a2,ffffffffc0201c64 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201bec:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201bf0:	4098                	lw	a4,0(s1)
ffffffffc0201bf2:	08f46963          	bltu	s0,a5,ffffffffc0201c84 <kfree+0xdc>
ffffffffc0201bf6:	000b1697          	auipc	a3,0xb1
ffffffffc0201bfa:	c226b683          	ld	a3,-990(a3) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0201bfe:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage) {
ffffffffc0201c00:	8031                	srli	s0,s0,0xc
ffffffffc0201c02:	000b1797          	auipc	a5,0xb1
ffffffffc0201c06:	bfe7b783          	ld	a5,-1026(a5) # ffffffffc02b2800 <npage>
ffffffffc0201c0a:	06f47163          	bgeu	s0,a5,ffffffffc0201c6c <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201c0e:	00007517          	auipc	a0,0x7
ffffffffc0201c12:	11a53503          	ld	a0,282(a0) # ffffffffc0208d28 <nbase>
ffffffffc0201c16:	8c09                	sub	s0,s0,a0
ffffffffc0201c18:	041a                	slli	s0,s0,0x6
  free_pages(kva2page(kva), 1 << order);
ffffffffc0201c1a:	000b1517          	auipc	a0,0xb1
ffffffffc0201c1e:	bee53503          	ld	a0,-1042(a0) # ffffffffc02b2808 <pages>
ffffffffc0201c22:	4585                	li	a1,1
ffffffffc0201c24:	9522                	add	a0,a0,s0
ffffffffc0201c26:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201c2a:	13e000ef          	jal	ra,ffffffffc0201d68 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201c2e:	6442                	ld	s0,16(sp)
ffffffffc0201c30:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c32:	8526                	mv	a0,s1
}
ffffffffc0201c34:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c36:	45e1                	li	a1,24
}
ffffffffc0201c38:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c3a:	b171                	j	ffffffffc02018c6 <slob_free>
ffffffffc0201c3c:	e20d                	bnez	a2,ffffffffc0201c5e <kfree+0xb6>
ffffffffc0201c3e:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201c42:	6442                	ld	s0,16(sp)
ffffffffc0201c44:	60e2                	ld	ra,24(sp)
ffffffffc0201c46:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c48:	4581                	li	a1,0
}
ffffffffc0201c4a:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c4c:	b9ad                	j	ffffffffc02018c6 <slob_free>
        intr_disable();
ffffffffc0201c4e:	9f9fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201c52:	000b1797          	auipc	a5,0xb1
ffffffffc0201c56:	b967b783          	ld	a5,-1130(a5) # ffffffffc02b27e8 <bigblocks>
        return 1;
ffffffffc0201c5a:	4605                	li	a2,1
ffffffffc0201c5c:	fbad                	bnez	a5,ffffffffc0201bce <kfree+0x26>
        intr_enable();
ffffffffc0201c5e:	9e3fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0201c62:	bff1                	j	ffffffffc0201c3e <kfree+0x96>
ffffffffc0201c64:	9ddfe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0201c68:	b751                	j	ffffffffc0201bec <kfree+0x44>
ffffffffc0201c6a:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201c6c:	00005617          	auipc	a2,0x5
ffffffffc0201c70:	7d460613          	addi	a2,a2,2004 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc0201c74:	06200593          	li	a1,98
ffffffffc0201c78:	00005517          	auipc	a0,0x5
ffffffffc0201c7c:	72050513          	addi	a0,a0,1824 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0201c80:	ffafe0ef          	jal	ra,ffffffffc020047a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201c84:	86a2                	mv	a3,s0
ffffffffc0201c86:	00005617          	auipc	a2,0x5
ffffffffc0201c8a:	79260613          	addi	a2,a2,1938 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0201c8e:	06e00593          	li	a1,110
ffffffffc0201c92:	00005517          	auipc	a0,0x5
ffffffffc0201c96:	70650513          	addi	a0,a0,1798 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0201c9a:	fe0fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201c9e <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc0201c9e:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201ca0:	00005617          	auipc	a2,0x5
ffffffffc0201ca4:	7a060613          	addi	a2,a2,1952 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc0201ca8:	06200593          	li	a1,98
ffffffffc0201cac:	00005517          	auipc	a0,0x5
ffffffffc0201cb0:	6ec50513          	addi	a0,a0,1772 # ffffffffc0207398 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0201cb4:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201cb6:	fc4fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201cba <pte2page.part.0>:
pte2page(pte_t pte) {
ffffffffc0201cba:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201cbc:	00005617          	auipc	a2,0x5
ffffffffc0201cc0:	7a460613          	addi	a2,a2,1956 # ffffffffc0207460 <default_pmm_manager+0x128>
ffffffffc0201cc4:	07400593          	li	a1,116
ffffffffc0201cc8:	00005517          	auipc	a0,0x5
ffffffffc0201ccc:	6d050513          	addi	a0,a0,1744 # ffffffffc0207398 <default_pmm_manager+0x60>
pte2page(pte_t pte) {
ffffffffc0201cd0:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201cd2:	fa8fe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201cd6 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0201cd6:	7139                	addi	sp,sp,-64
ffffffffc0201cd8:	f426                	sd	s1,40(sp)
ffffffffc0201cda:	f04a                	sd	s2,32(sp)
ffffffffc0201cdc:	ec4e                	sd	s3,24(sp)
ffffffffc0201cde:	e852                	sd	s4,16(sp)
ffffffffc0201ce0:	e456                	sd	s5,8(sp)
ffffffffc0201ce2:	e05a                	sd	s6,0(sp)
ffffffffc0201ce4:	fc06                	sd	ra,56(sp)
ffffffffc0201ce6:	f822                	sd	s0,48(sp)
ffffffffc0201ce8:	84aa                	mv	s1,a0
ffffffffc0201cea:	000b1917          	auipc	s2,0xb1
ffffffffc0201cee:	b2690913          	addi	s2,s2,-1242 # ffffffffc02b2810 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201cf2:	4a05                	li	s4,1
ffffffffc0201cf4:	000b1a97          	auipc	s5,0xb1
ffffffffc0201cf8:	b3ca8a93          	addi	s5,s5,-1220 # ffffffffc02b2830 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0201cfc:	0005099b          	sext.w	s3,a0
ffffffffc0201d00:	000b1b17          	auipc	s6,0xb1
ffffffffc0201d04:	b38b0b13          	addi	s6,s6,-1224 # ffffffffc02b2838 <check_mm_struct>
ffffffffc0201d08:	a01d                	j	ffffffffc0201d2e <alloc_pages+0x58>
            page = pmm_manager->alloc_pages(n);
ffffffffc0201d0a:	00093783          	ld	a5,0(s2)
ffffffffc0201d0e:	6f9c                	ld	a5,24(a5)
ffffffffc0201d10:	9782                	jalr	a5
ffffffffc0201d12:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0201d14:	4601                	li	a2,0
ffffffffc0201d16:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201d18:	ec0d                	bnez	s0,ffffffffc0201d52 <alloc_pages+0x7c>
ffffffffc0201d1a:	029a6c63          	bltu	s4,s1,ffffffffc0201d52 <alloc_pages+0x7c>
ffffffffc0201d1e:	000aa783          	lw	a5,0(s5)
ffffffffc0201d22:	2781                	sext.w	a5,a5
ffffffffc0201d24:	c79d                	beqz	a5,ffffffffc0201d52 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201d26:	000b3503          	ld	a0,0(s6)
ffffffffc0201d2a:	64d010ef          	jal	ra,ffffffffc0203b76 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d2e:	100027f3          	csrr	a5,sstatus
ffffffffc0201d32:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0201d34:	8526                	mv	a0,s1
ffffffffc0201d36:	dbf1                	beqz	a5,ffffffffc0201d0a <alloc_pages+0x34>
        intr_disable();
ffffffffc0201d38:	90ffe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0201d3c:	00093783          	ld	a5,0(s2)
ffffffffc0201d40:	8526                	mv	a0,s1
ffffffffc0201d42:	6f9c                	ld	a5,24(a5)
ffffffffc0201d44:	9782                	jalr	a5
ffffffffc0201d46:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201d48:	8f9fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201d4c:	4601                	li	a2,0
ffffffffc0201d4e:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201d50:	d469                	beqz	s0,ffffffffc0201d1a <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0201d52:	70e2                	ld	ra,56(sp)
ffffffffc0201d54:	8522                	mv	a0,s0
ffffffffc0201d56:	7442                	ld	s0,48(sp)
ffffffffc0201d58:	74a2                	ld	s1,40(sp)
ffffffffc0201d5a:	7902                	ld	s2,32(sp)
ffffffffc0201d5c:	69e2                	ld	s3,24(sp)
ffffffffc0201d5e:	6a42                	ld	s4,16(sp)
ffffffffc0201d60:	6aa2                	ld	s5,8(sp)
ffffffffc0201d62:	6b02                	ld	s6,0(sp)
ffffffffc0201d64:	6121                	addi	sp,sp,64
ffffffffc0201d66:	8082                	ret

ffffffffc0201d68 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d68:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6c:	8b89                	andi	a5,a5,2
ffffffffc0201d6e:	e799                	bnez	a5,ffffffffc0201d7c <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201d70:	000b1797          	auipc	a5,0xb1
ffffffffc0201d74:	aa07b783          	ld	a5,-1376(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0201d78:	739c                	ld	a5,32(a5)
ffffffffc0201d7a:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201d7c:	1101                	addi	sp,sp,-32
ffffffffc0201d7e:	ec06                	sd	ra,24(sp)
ffffffffc0201d80:	e822                	sd	s0,16(sp)
ffffffffc0201d82:	e426                	sd	s1,8(sp)
ffffffffc0201d84:	842a                	mv	s0,a0
ffffffffc0201d86:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201d88:	8bffe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201d8c:	000b1797          	auipc	a5,0xb1
ffffffffc0201d90:	a847b783          	ld	a5,-1404(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0201d94:	739c                	ld	a5,32(a5)
ffffffffc0201d96:	85a6                	mv	a1,s1
ffffffffc0201d98:	8522                	mv	a0,s0
ffffffffc0201d9a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201d9c:	6442                	ld	s0,16(sp)
ffffffffc0201d9e:	60e2                	ld	ra,24(sp)
ffffffffc0201da0:	64a2                	ld	s1,8(sp)
ffffffffc0201da2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201da4:	89dfe06f          	j	ffffffffc0200640 <intr_enable>

ffffffffc0201da8 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201da8:	100027f3          	csrr	a5,sstatus
ffffffffc0201dac:	8b89                	andi	a5,a5,2
ffffffffc0201dae:	e799                	bnez	a5,ffffffffc0201dbc <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201db0:	000b1797          	auipc	a5,0xb1
ffffffffc0201db4:	a607b783          	ld	a5,-1440(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0201db8:	779c                	ld	a5,40(a5)
ffffffffc0201dba:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201dbc:	1141                	addi	sp,sp,-16
ffffffffc0201dbe:	e406                	sd	ra,8(sp)
ffffffffc0201dc0:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201dc2:	885fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201dc6:	000b1797          	auipc	a5,0xb1
ffffffffc0201dca:	a4a7b783          	ld	a5,-1462(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0201dce:	779c                	ld	a5,40(a5)
ffffffffc0201dd0:	9782                	jalr	a5
ffffffffc0201dd2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201dd4:	86dfe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201dd8:	60a2                	ld	ra,8(sp)
ffffffffc0201dda:	8522                	mv	a0,s0
ffffffffc0201ddc:	6402                	ld	s0,0(sp)
ffffffffc0201dde:	0141                	addi	sp,sp,16
ffffffffc0201de0:	8082                	ret

ffffffffc0201de2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201de2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201de6:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201dea:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201dec:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201dee:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201df0:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201df4:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201df6:	f04a                	sd	s2,32(sp)
ffffffffc0201df8:	ec4e                	sd	s3,24(sp)
ffffffffc0201dfa:	e852                	sd	s4,16(sp)
ffffffffc0201dfc:	fc06                	sd	ra,56(sp)
ffffffffc0201dfe:	f822                	sd	s0,48(sp)
ffffffffc0201e00:	e456                	sd	s5,8(sp)
ffffffffc0201e02:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e04:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201e08:	892e                	mv	s2,a1
ffffffffc0201e0a:	89b2                	mv	s3,a2
ffffffffc0201e0c:	000b1a17          	auipc	s4,0xb1
ffffffffc0201e10:	9f4a0a13          	addi	s4,s4,-1548 # ffffffffc02b2800 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e14:	e7b5                	bnez	a5,ffffffffc0201e80 <get_pte+0x9e>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201e16:	12060b63          	beqz	a2,ffffffffc0201f4c <get_pte+0x16a>
ffffffffc0201e1a:	4505                	li	a0,1
ffffffffc0201e1c:	ebbff0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201e20:	842a                	mv	s0,a0
ffffffffc0201e22:	12050563          	beqz	a0,ffffffffc0201f4c <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201e26:	000b1b17          	auipc	s6,0xb1
ffffffffc0201e2a:	9e2b0b13          	addi	s6,s6,-1566 # ffffffffc02b2808 <pages>
ffffffffc0201e2e:	000b3503          	ld	a0,0(s6)
ffffffffc0201e32:	00080ab7          	lui	s5,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e36:	000b1a17          	auipc	s4,0xb1
ffffffffc0201e3a:	9caa0a13          	addi	s4,s4,-1590 # ffffffffc02b2800 <npage>
ffffffffc0201e3e:	40a40533          	sub	a0,s0,a0
ffffffffc0201e42:	8519                	srai	a0,a0,0x6
ffffffffc0201e44:	9556                	add	a0,a0,s5
ffffffffc0201e46:	000a3703          	ld	a4,0(s4)
ffffffffc0201e4a:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201e4e:	4685                	li	a3,1
ffffffffc0201e50:	c014                	sw	a3,0(s0)
ffffffffc0201e52:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e54:	0532                	slli	a0,a0,0xc
ffffffffc0201e56:	14e7f263          	bgeu	a5,a4,ffffffffc0201f9a <get_pte+0x1b8>
ffffffffc0201e5a:	000b1797          	auipc	a5,0xb1
ffffffffc0201e5e:	9be7b783          	ld	a5,-1602(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0201e62:	6605                	lui	a2,0x1
ffffffffc0201e64:	4581                	li	a1,0
ffffffffc0201e66:	953e                	add	a0,a0,a5
ffffffffc0201e68:	754040ef          	jal	ra,ffffffffc02065bc <memset>
    return page - pages + nbase;
ffffffffc0201e6c:	000b3683          	ld	a3,0(s6)
ffffffffc0201e70:	40d406b3          	sub	a3,s0,a3
ffffffffc0201e74:	8699                	srai	a3,a3,0x6
ffffffffc0201e76:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vma");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e78:	06aa                	slli	a3,a3,0xa
ffffffffc0201e7a:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e7e:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201e80:	77fd                	lui	a5,0xfffff
ffffffffc0201e82:	068a                	slli	a3,a3,0x2
ffffffffc0201e84:	000a3703          	ld	a4,0(s4)
ffffffffc0201e88:	8efd                	and	a3,a3,a5
ffffffffc0201e8a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e8e:	0ce7f163          	bgeu	a5,a4,ffffffffc0201f50 <get_pte+0x16e>
ffffffffc0201e92:	000b1a97          	auipc	s5,0xb1
ffffffffc0201e96:	986a8a93          	addi	s5,s5,-1658 # ffffffffc02b2818 <va_pa_offset>
ffffffffc0201e9a:	000ab403          	ld	s0,0(s5)
ffffffffc0201e9e:	01595793          	srli	a5,s2,0x15
ffffffffc0201ea2:	1ff7f793          	andi	a5,a5,511
ffffffffc0201ea6:	96a2                	add	a3,a3,s0
ffffffffc0201ea8:	00379413          	slli	s0,a5,0x3
ffffffffc0201eac:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc0201eae:	6014                	ld	a3,0(s0)
ffffffffc0201eb0:	0016f793          	andi	a5,a3,1
ffffffffc0201eb4:	e3ad                	bnez	a5,ffffffffc0201f16 <get_pte+0x134>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201eb6:	08098b63          	beqz	s3,ffffffffc0201f4c <get_pte+0x16a>
ffffffffc0201eba:	4505                	li	a0,1
ffffffffc0201ebc:	e1bff0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0201ec0:	84aa                	mv	s1,a0
ffffffffc0201ec2:	c549                	beqz	a0,ffffffffc0201f4c <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201ec4:	000b1b17          	auipc	s6,0xb1
ffffffffc0201ec8:	944b0b13          	addi	s6,s6,-1724 # ffffffffc02b2808 <pages>
ffffffffc0201ecc:	000b3503          	ld	a0,0(s6)
ffffffffc0201ed0:	000809b7          	lui	s3,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ed4:	000a3703          	ld	a4,0(s4)
ffffffffc0201ed8:	40a48533          	sub	a0,s1,a0
ffffffffc0201edc:	8519                	srai	a0,a0,0x6
ffffffffc0201ede:	954e                	add	a0,a0,s3
ffffffffc0201ee0:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201ee4:	4685                	li	a3,1
ffffffffc0201ee6:	c094                	sw	a3,0(s1)
ffffffffc0201ee8:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201eea:	0532                	slli	a0,a0,0xc
ffffffffc0201eec:	08e7fa63          	bgeu	a5,a4,ffffffffc0201f80 <get_pte+0x19e>
ffffffffc0201ef0:	000ab783          	ld	a5,0(s5)
ffffffffc0201ef4:	6605                	lui	a2,0x1
ffffffffc0201ef6:	4581                	li	a1,0
ffffffffc0201ef8:	953e                	add	a0,a0,a5
ffffffffc0201efa:	6c2040ef          	jal	ra,ffffffffc02065bc <memset>
    return page - pages + nbase;
ffffffffc0201efe:	000b3683          	ld	a3,0(s6)
ffffffffc0201f02:	40d486b3          	sub	a3,s1,a3
ffffffffc0201f06:	8699                	srai	a3,a3,0x6
ffffffffc0201f08:	96ce                	add	a3,a3,s3
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f0a:	06aa                	slli	a3,a3,0xa
ffffffffc0201f0c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f10:	e014                	sd	a3,0(s0)
        }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f12:	000a3703          	ld	a4,0(s4)
ffffffffc0201f16:	068a                	slli	a3,a3,0x2
ffffffffc0201f18:	757d                	lui	a0,0xfffff
ffffffffc0201f1a:	8ee9                	and	a3,a3,a0
ffffffffc0201f1c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f20:	04e7f463          	bgeu	a5,a4,ffffffffc0201f68 <get_pte+0x186>
ffffffffc0201f24:	000ab503          	ld	a0,0(s5)
ffffffffc0201f28:	00c95913          	srli	s2,s2,0xc
ffffffffc0201f2c:	1ff97913          	andi	s2,s2,511
ffffffffc0201f30:	96aa                	add	a3,a3,a0
ffffffffc0201f32:	00391513          	slli	a0,s2,0x3
ffffffffc0201f36:	9536                	add	a0,a0,a3
}
ffffffffc0201f38:	70e2                	ld	ra,56(sp)
ffffffffc0201f3a:	7442                	ld	s0,48(sp)
ffffffffc0201f3c:	74a2                	ld	s1,40(sp)
ffffffffc0201f3e:	7902                	ld	s2,32(sp)
ffffffffc0201f40:	69e2                	ld	s3,24(sp)
ffffffffc0201f42:	6a42                	ld	s4,16(sp)
ffffffffc0201f44:	6aa2                	ld	s5,8(sp)
ffffffffc0201f46:	6b02                	ld	s6,0(sp)
ffffffffc0201f48:	6121                	addi	sp,sp,64
ffffffffc0201f4a:	8082                	ret
            return NULL;
ffffffffc0201f4c:	4501                	li	a0,0
ffffffffc0201f4e:	b7ed                	j	ffffffffc0201f38 <get_pte+0x156>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f50:	00005617          	auipc	a2,0x5
ffffffffc0201f54:	42060613          	addi	a2,a2,1056 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0201f58:	0e300593          	li	a1,227
ffffffffc0201f5c:	00005517          	auipc	a0,0x5
ffffffffc0201f60:	52c50513          	addi	a0,a0,1324 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0201f64:	d16fe0ef          	jal	ra,ffffffffc020047a <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f68:	00005617          	auipc	a2,0x5
ffffffffc0201f6c:	40860613          	addi	a2,a2,1032 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0201f70:	0ee00593          	li	a1,238
ffffffffc0201f74:	00005517          	auipc	a0,0x5
ffffffffc0201f78:	51450513          	addi	a0,a0,1300 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0201f7c:	cfefe0ef          	jal	ra,ffffffffc020047a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f80:	86aa                	mv	a3,a0
ffffffffc0201f82:	00005617          	auipc	a2,0x5
ffffffffc0201f86:	3ee60613          	addi	a2,a2,1006 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0201f8a:	0eb00593          	li	a1,235
ffffffffc0201f8e:	00005517          	auipc	a0,0x5
ffffffffc0201f92:	4fa50513          	addi	a0,a0,1274 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0201f96:	ce4fe0ef          	jal	ra,ffffffffc020047a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f9a:	86aa                	mv	a3,a0
ffffffffc0201f9c:	00005617          	auipc	a2,0x5
ffffffffc0201fa0:	3d460613          	addi	a2,a2,980 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0201fa4:	0df00593          	li	a1,223
ffffffffc0201fa8:	00005517          	auipc	a0,0x5
ffffffffc0201fac:	4e050513          	addi	a0,a0,1248 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0201fb0:	ccafe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0201fb4 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201fb4:	1141                	addi	sp,sp,-16
ffffffffc0201fb6:	e022                	sd	s0,0(sp)
ffffffffc0201fb8:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fba:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201fbc:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fbe:	e25ff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0201fc2:	c011                	beqz	s0,ffffffffc0201fc6 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0201fc4:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201fc6:	c511                	beqz	a0,ffffffffc0201fd2 <get_page+0x1e>
ffffffffc0201fc8:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201fca:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201fcc:	0017f713          	andi	a4,a5,1
ffffffffc0201fd0:	e709                	bnez	a4,ffffffffc0201fda <get_page+0x26>
}
ffffffffc0201fd2:	60a2                	ld	ra,8(sp)
ffffffffc0201fd4:	6402                	ld	s0,0(sp)
ffffffffc0201fd6:	0141                	addi	sp,sp,16
ffffffffc0201fd8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201fda:	078a                	slli	a5,a5,0x2
ffffffffc0201fdc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201fde:	000b1717          	auipc	a4,0xb1
ffffffffc0201fe2:	82273703          	ld	a4,-2014(a4) # ffffffffc02b2800 <npage>
ffffffffc0201fe6:	00e7ff63          	bgeu	a5,a4,ffffffffc0202004 <get_page+0x50>
ffffffffc0201fea:	60a2                	ld	ra,8(sp)
ffffffffc0201fec:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0201fee:	fff80537          	lui	a0,0xfff80
ffffffffc0201ff2:	97aa                	add	a5,a5,a0
ffffffffc0201ff4:	079a                	slli	a5,a5,0x6
ffffffffc0201ff6:	000b1517          	auipc	a0,0xb1
ffffffffc0201ffa:	81253503          	ld	a0,-2030(a0) # ffffffffc02b2808 <pages>
ffffffffc0201ffe:	953e                	add	a0,a0,a5
ffffffffc0202000:	0141                	addi	sp,sp,16
ffffffffc0202002:	8082                	ret
ffffffffc0202004:	c9bff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>

ffffffffc0202008 <unmap_range>:
        *ptep = 0;                  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0202008:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020200a:	00c5e7b3          	or	a5,a1,a2
void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc020200e:	f486                	sd	ra,104(sp)
ffffffffc0202010:	f0a2                	sd	s0,96(sp)
ffffffffc0202012:	eca6                	sd	s1,88(sp)
ffffffffc0202014:	e8ca                	sd	s2,80(sp)
ffffffffc0202016:	e4ce                	sd	s3,72(sp)
ffffffffc0202018:	e0d2                	sd	s4,64(sp)
ffffffffc020201a:	fc56                	sd	s5,56(sp)
ffffffffc020201c:	f85a                	sd	s6,48(sp)
ffffffffc020201e:	f45e                	sd	s7,40(sp)
ffffffffc0202020:	f062                	sd	s8,32(sp)
ffffffffc0202022:	ec66                	sd	s9,24(sp)
ffffffffc0202024:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202026:	17d2                	slli	a5,a5,0x34
ffffffffc0202028:	e3ed                	bnez	a5,ffffffffc020210a <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020202a:	002007b7          	lui	a5,0x200
ffffffffc020202e:	842e                	mv	s0,a1
ffffffffc0202030:	0ef5ed63          	bltu	a1,a5,ffffffffc020212a <unmap_range+0x122>
ffffffffc0202034:	8932                	mv	s2,a2
ffffffffc0202036:	0ec5fa63          	bgeu	a1,a2,ffffffffc020212a <unmap_range+0x122>
ffffffffc020203a:	4785                	li	a5,1
ffffffffc020203c:	07fe                	slli	a5,a5,0x1f
ffffffffc020203e:	0ec7e663          	bltu	a5,a2,ffffffffc020212a <unmap_range+0x122>
ffffffffc0202042:	89aa                	mv	s3,a0
            continue;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202044:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202046:	000b0c97          	auipc	s9,0xb0
ffffffffc020204a:	7bac8c93          	addi	s9,s9,1978 # ffffffffc02b2800 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020204e:	000b0c17          	auipc	s8,0xb0
ffffffffc0202052:	7bac0c13          	addi	s8,s8,1978 # ffffffffc02b2808 <pages>
ffffffffc0202056:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020205a:	000b0d17          	auipc	s10,0xb0
ffffffffc020205e:	7b6d0d13          	addi	s10,s10,1974 # ffffffffc02b2810 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202062:	00200b37          	lui	s6,0x200
ffffffffc0202066:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020206a:	4601                	li	a2,0
ffffffffc020206c:	85a2                	mv	a1,s0
ffffffffc020206e:	854e                	mv	a0,s3
ffffffffc0202070:	d73ff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0202074:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc0202076:	cd29                	beqz	a0,ffffffffc02020d0 <unmap_range+0xc8>
        if (*ptep != 0) {
ffffffffc0202078:	611c                	ld	a5,0(a0)
ffffffffc020207a:	e395                	bnez	a5,ffffffffc020209e <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020207c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020207e:	ff2466e3          	bltu	s0,s2,ffffffffc020206a <unmap_range+0x62>
}
ffffffffc0202082:	70a6                	ld	ra,104(sp)
ffffffffc0202084:	7406                	ld	s0,96(sp)
ffffffffc0202086:	64e6                	ld	s1,88(sp)
ffffffffc0202088:	6946                	ld	s2,80(sp)
ffffffffc020208a:	69a6                	ld	s3,72(sp)
ffffffffc020208c:	6a06                	ld	s4,64(sp)
ffffffffc020208e:	7ae2                	ld	s5,56(sp)
ffffffffc0202090:	7b42                	ld	s6,48(sp)
ffffffffc0202092:	7ba2                	ld	s7,40(sp)
ffffffffc0202094:	7c02                	ld	s8,32(sp)
ffffffffc0202096:	6ce2                	ld	s9,24(sp)
ffffffffc0202098:	6d42                	ld	s10,16(sp)
ffffffffc020209a:	6165                	addi	sp,sp,112
ffffffffc020209c:	8082                	ret
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc020209e:	0017f713          	andi	a4,a5,1
ffffffffc02020a2:	df69                	beqz	a4,ffffffffc020207c <unmap_range+0x74>
    if (PPN(pa) >= npage) {
ffffffffc02020a4:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02020a8:	078a                	slli	a5,a5,0x2
ffffffffc02020aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02020ac:	08e7ff63          	bgeu	a5,a4,ffffffffc020214a <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc02020b0:	000c3503          	ld	a0,0(s8)
ffffffffc02020b4:	97de                	add	a5,a5,s7
ffffffffc02020b6:	079a                	slli	a5,a5,0x6
ffffffffc02020b8:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02020ba:	411c                	lw	a5,0(a0)
ffffffffc02020bc:	fff7871b          	addiw	a4,a5,-1
ffffffffc02020c0:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02020c2:	cf11                	beqz	a4,ffffffffc02020de <unmap_range+0xd6>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc02020c4:	0004b023          	sd	zero,0(s1)
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020c8:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02020cc:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02020ce:	bf45                	j	ffffffffc020207e <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02020d0:	945a                	add	s0,s0,s6
ffffffffc02020d2:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02020d6:	d455                	beqz	s0,ffffffffc0202082 <unmap_range+0x7a>
ffffffffc02020d8:	f92469e3          	bltu	s0,s2,ffffffffc020206a <unmap_range+0x62>
ffffffffc02020dc:	b75d                	j	ffffffffc0202082 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02020de:	100027f3          	csrr	a5,sstatus
ffffffffc02020e2:	8b89                	andi	a5,a5,2
ffffffffc02020e4:	e799                	bnez	a5,ffffffffc02020f2 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02020e6:	000d3783          	ld	a5,0(s10)
ffffffffc02020ea:	4585                	li	a1,1
ffffffffc02020ec:	739c                	ld	a5,32(a5)
ffffffffc02020ee:	9782                	jalr	a5
    if (flag) {
ffffffffc02020f0:	bfd1                	j	ffffffffc02020c4 <unmap_range+0xbc>
ffffffffc02020f2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02020f4:	d52fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc02020f8:	000d3783          	ld	a5,0(s10)
ffffffffc02020fc:	6522                	ld	a0,8(sp)
ffffffffc02020fe:	4585                	li	a1,1
ffffffffc0202100:	739c                	ld	a5,32(a5)
ffffffffc0202102:	9782                	jalr	a5
        intr_enable();
ffffffffc0202104:	d3cfe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202108:	bf75                	j	ffffffffc02020c4 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020210a:	00005697          	auipc	a3,0x5
ffffffffc020210e:	38e68693          	addi	a3,a3,910 # ffffffffc0207498 <default_pmm_manager+0x160>
ffffffffc0202112:	00005617          	auipc	a2,0x5
ffffffffc0202116:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020211a:	10f00593          	li	a1,271
ffffffffc020211e:	00005517          	auipc	a0,0x5
ffffffffc0202122:	36a50513          	addi	a0,a0,874 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202126:	b54fe0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020212a:	00005697          	auipc	a3,0x5
ffffffffc020212e:	39e68693          	addi	a3,a3,926 # ffffffffc02074c8 <default_pmm_manager+0x190>
ffffffffc0202132:	00005617          	auipc	a2,0x5
ffffffffc0202136:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020213a:	11000593          	li	a1,272
ffffffffc020213e:	00005517          	auipc	a0,0x5
ffffffffc0202142:	34a50513          	addi	a0,a0,842 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202146:	b34fe0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc020214a:	b55ff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>

ffffffffc020214e <exit_range>:
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc020214e:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202150:	00c5e7b3          	or	a5,a1,a2
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0202154:	fc86                	sd	ra,120(sp)
ffffffffc0202156:	f8a2                	sd	s0,112(sp)
ffffffffc0202158:	f4a6                	sd	s1,104(sp)
ffffffffc020215a:	f0ca                	sd	s2,96(sp)
ffffffffc020215c:	ecce                	sd	s3,88(sp)
ffffffffc020215e:	e8d2                	sd	s4,80(sp)
ffffffffc0202160:	e4d6                	sd	s5,72(sp)
ffffffffc0202162:	e0da                	sd	s6,64(sp)
ffffffffc0202164:	fc5e                	sd	s7,56(sp)
ffffffffc0202166:	f862                	sd	s8,48(sp)
ffffffffc0202168:	f466                	sd	s9,40(sp)
ffffffffc020216a:	f06a                	sd	s10,32(sp)
ffffffffc020216c:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020216e:	17d2                	slli	a5,a5,0x34
ffffffffc0202170:	20079a63          	bnez	a5,ffffffffc0202384 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202174:	002007b7          	lui	a5,0x200
ffffffffc0202178:	24f5e463          	bltu	a1,a5,ffffffffc02023c0 <exit_range+0x272>
ffffffffc020217c:	8ab2                	mv	s5,a2
ffffffffc020217e:	24c5f163          	bgeu	a1,a2,ffffffffc02023c0 <exit_range+0x272>
ffffffffc0202182:	4785                	li	a5,1
ffffffffc0202184:	07fe                	slli	a5,a5,0x1f
ffffffffc0202186:	22c7ed63          	bltu	a5,a2,ffffffffc02023c0 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020218a:	c00009b7          	lui	s3,0xc0000
ffffffffc020218e:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202192:	ffe00937          	lui	s2,0xffe00
ffffffffc0202196:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020219a:	5cfd                	li	s9,-1
ffffffffc020219c:	8c2a                	mv	s8,a0
ffffffffc020219e:	0125f933          	and	s2,a1,s2
ffffffffc02021a2:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage) {
ffffffffc02021a4:	000b0d17          	auipc	s10,0xb0
ffffffffc02021a8:	65cd0d13          	addi	s10,s10,1628 # ffffffffc02b2800 <npage>
    return KADDR(page2pa(page));
ffffffffc02021ac:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02021b0:	000b0717          	auipc	a4,0xb0
ffffffffc02021b4:	65870713          	addi	a4,a4,1624 # ffffffffc02b2808 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc02021b8:	000b0d97          	auipc	s11,0xb0
ffffffffc02021bc:	658d8d93          	addi	s11,s11,1624 # ffffffffc02b2810 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02021c0:	c0000437          	lui	s0,0xc0000
ffffffffc02021c4:	944e                	add	s0,s0,s3
ffffffffc02021c6:	8079                	srli	s0,s0,0x1e
ffffffffc02021c8:	1ff47413          	andi	s0,s0,511
ffffffffc02021cc:	040e                	slli	s0,s0,0x3
ffffffffc02021ce:	9462                	add	s0,s0,s8
ffffffffc02021d0:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed8>
        if (pde1&PTE_V){
ffffffffc02021d4:	001a7793          	andi	a5,s4,1
ffffffffc02021d8:	eb99                	bnez	a5,ffffffffc02021ee <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02021da:	12098463          	beqz	s3,ffffffffc0202302 <exit_range+0x1b4>
ffffffffc02021de:	400007b7          	lui	a5,0x40000
ffffffffc02021e2:	97ce                	add	a5,a5,s3
ffffffffc02021e4:	894e                	mv	s2,s3
ffffffffc02021e6:	1159fe63          	bgeu	s3,s5,ffffffffc0202302 <exit_range+0x1b4>
ffffffffc02021ea:	89be                	mv	s3,a5
ffffffffc02021ec:	bfd1                	j	ffffffffc02021c0 <exit_range+0x72>
    if (PPN(pa) >= npage) {
ffffffffc02021ee:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02021f2:	0a0a                	slli	s4,s4,0x2
ffffffffc02021f4:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage) {
ffffffffc02021f8:	1cfa7263          	bgeu	s4,a5,ffffffffc02023bc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02021fc:	fff80637          	lui	a2,0xfff80
ffffffffc0202200:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202202:	000806b7          	lui	a3,0x80
ffffffffc0202206:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202208:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020220c:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020220e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202210:	18f5fa63          	bgeu	a1,a5,ffffffffc02023a4 <exit_range+0x256>
ffffffffc0202214:	000b0817          	auipc	a6,0xb0
ffffffffc0202218:	60480813          	addi	a6,a6,1540 # ffffffffc02b2818 <va_pa_offset>
ffffffffc020221c:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202220:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202222:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202226:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202228:	00080337          	lui	t1,0x80
ffffffffc020222c:	6885                	lui	a7,0x1
ffffffffc020222e:	a819                	j	ffffffffc0202244 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202230:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202232:	002007b7          	lui	a5,0x200
ffffffffc0202236:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start+PDSIZE && d0start < end);
ffffffffc0202238:	08090c63          	beqz	s2,ffffffffc02022d0 <exit_range+0x182>
ffffffffc020223c:	09397a63          	bgeu	s2,s3,ffffffffc02022d0 <exit_range+0x182>
ffffffffc0202240:	0f597063          	bgeu	s2,s5,ffffffffc0202320 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202244:	01595493          	srli	s1,s2,0x15
ffffffffc0202248:	1ff4f493          	andi	s1,s1,511
ffffffffc020224c:	048e                	slli	s1,s1,0x3
ffffffffc020224e:	94da                	add	s1,s1,s6
ffffffffc0202250:	609c                	ld	a5,0(s1)
                if (pde0&PTE_V) {
ffffffffc0202252:	0017f693          	andi	a3,a5,1
ffffffffc0202256:	dee9                	beqz	a3,ffffffffc0202230 <exit_range+0xe2>
    if (PPN(pa) >= npage) {
ffffffffc0202258:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020225c:	078a                	slli	a5,a5,0x2
ffffffffc020225e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202260:	14b7fe63          	bgeu	a5,a1,ffffffffc02023bc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202264:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202266:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020226a:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020226e:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202272:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202274:	12bef863          	bgeu	t4,a1,ffffffffc02023a4 <exit_range+0x256>
ffffffffc0202278:	00083783          	ld	a5,0(a6)
ffffffffc020227c:	96be                	add	a3,a3,a5
                    for (int i = 0;i <NPTEENTRY;i++)
ffffffffc020227e:	011685b3          	add	a1,a3,a7
                        if (pt[i]&PTE_V){
ffffffffc0202282:	629c                	ld	a5,0(a3)
ffffffffc0202284:	8b85                	andi	a5,a5,1
ffffffffc0202286:	f7d5                	bnez	a5,ffffffffc0202232 <exit_range+0xe4>
                    for (int i = 0;i <NPTEENTRY;i++)
ffffffffc0202288:	06a1                	addi	a3,a3,8
ffffffffc020228a:	fed59ce3          	bne	a1,a3,ffffffffc0202282 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc020228e:	631c                	ld	a5,0(a4)
ffffffffc0202290:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202292:	100027f3          	csrr	a5,sstatus
ffffffffc0202296:	8b89                	andi	a5,a5,2
ffffffffc0202298:	e7d9                	bnez	a5,ffffffffc0202326 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020229a:	000db783          	ld	a5,0(s11)
ffffffffc020229e:	4585                	li	a1,1
ffffffffc02022a0:	e032                	sd	a2,0(sp)
ffffffffc02022a2:	739c                	ld	a5,32(a5)
ffffffffc02022a4:	9782                	jalr	a5
    if (flag) {
ffffffffc02022a6:	6602                	ld	a2,0(sp)
ffffffffc02022a8:	000b0817          	auipc	a6,0xb0
ffffffffc02022ac:	57080813          	addi	a6,a6,1392 # ffffffffc02b2818 <va_pa_offset>
ffffffffc02022b0:	fff80e37          	lui	t3,0xfff80
ffffffffc02022b4:	00080337          	lui	t1,0x80
ffffffffc02022b8:	6885                	lui	a7,0x1
ffffffffc02022ba:	000b0717          	auipc	a4,0xb0
ffffffffc02022be:	54e70713          	addi	a4,a4,1358 # ffffffffc02b2808 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02022c2:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc02022c6:	002007b7          	lui	a5,0x200
ffffffffc02022ca:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start+PDSIZE && d0start < end);
ffffffffc02022cc:	f60918e3          	bnez	s2,ffffffffc020223c <exit_range+0xee>
            if (free_pd0) {
ffffffffc02022d0:	f00b85e3          	beqz	s7,ffffffffc02021da <exit_range+0x8c>
    if (PPN(pa) >= npage) {
ffffffffc02022d4:	000d3783          	ld	a5,0(s10)
ffffffffc02022d8:	0efa7263          	bgeu	s4,a5,ffffffffc02023bc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02022dc:	6308                	ld	a0,0(a4)
ffffffffc02022de:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02022e0:	100027f3          	csrr	a5,sstatus
ffffffffc02022e4:	8b89                	andi	a5,a5,2
ffffffffc02022e6:	efad                	bnez	a5,ffffffffc0202360 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02022e8:	000db783          	ld	a5,0(s11)
ffffffffc02022ec:	4585                	li	a1,1
ffffffffc02022ee:	739c                	ld	a5,32(a5)
ffffffffc02022f0:	9782                	jalr	a5
ffffffffc02022f2:	000b0717          	auipc	a4,0xb0
ffffffffc02022f6:	51670713          	addi	a4,a4,1302 # ffffffffc02b2808 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02022fa:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02022fe:	ee0990e3          	bnez	s3,ffffffffc02021de <exit_range+0x90>
}
ffffffffc0202302:	70e6                	ld	ra,120(sp)
ffffffffc0202304:	7446                	ld	s0,112(sp)
ffffffffc0202306:	74a6                	ld	s1,104(sp)
ffffffffc0202308:	7906                	ld	s2,96(sp)
ffffffffc020230a:	69e6                	ld	s3,88(sp)
ffffffffc020230c:	6a46                	ld	s4,80(sp)
ffffffffc020230e:	6aa6                	ld	s5,72(sp)
ffffffffc0202310:	6b06                	ld	s6,64(sp)
ffffffffc0202312:	7be2                	ld	s7,56(sp)
ffffffffc0202314:	7c42                	ld	s8,48(sp)
ffffffffc0202316:	7ca2                	ld	s9,40(sp)
ffffffffc0202318:	7d02                	ld	s10,32(sp)
ffffffffc020231a:	6de2                	ld	s11,24(sp)
ffffffffc020231c:	6109                	addi	sp,sp,128
ffffffffc020231e:	8082                	ret
            if (free_pd0) {
ffffffffc0202320:	ea0b8fe3          	beqz	s7,ffffffffc02021de <exit_range+0x90>
ffffffffc0202324:	bf45                	j	ffffffffc02022d4 <exit_range+0x186>
ffffffffc0202326:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202328:	e42a                	sd	a0,8(sp)
ffffffffc020232a:	b1cfe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020232e:	000db783          	ld	a5,0(s11)
ffffffffc0202332:	6522                	ld	a0,8(sp)
ffffffffc0202334:	4585                	li	a1,1
ffffffffc0202336:	739c                	ld	a5,32(a5)
ffffffffc0202338:	9782                	jalr	a5
        intr_enable();
ffffffffc020233a:	b06fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc020233e:	6602                	ld	a2,0(sp)
ffffffffc0202340:	000b0717          	auipc	a4,0xb0
ffffffffc0202344:	4c870713          	addi	a4,a4,1224 # ffffffffc02b2808 <pages>
ffffffffc0202348:	6885                	lui	a7,0x1
ffffffffc020234a:	00080337          	lui	t1,0x80
ffffffffc020234e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202352:	000b0817          	auipc	a6,0xb0
ffffffffc0202356:	4c680813          	addi	a6,a6,1222 # ffffffffc02b2818 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020235a:	0004b023          	sd	zero,0(s1)
ffffffffc020235e:	b7a5                	j	ffffffffc02022c6 <exit_range+0x178>
ffffffffc0202360:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202362:	ae4fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202366:	000db783          	ld	a5,0(s11)
ffffffffc020236a:	6502                	ld	a0,0(sp)
ffffffffc020236c:	4585                	li	a1,1
ffffffffc020236e:	739c                	ld	a5,32(a5)
ffffffffc0202370:	9782                	jalr	a5
        intr_enable();
ffffffffc0202372:	acefe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202376:	000b0717          	auipc	a4,0xb0
ffffffffc020237a:	49270713          	addi	a4,a4,1170 # ffffffffc02b2808 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020237e:	00043023          	sd	zero,0(s0)
ffffffffc0202382:	bfb5                	j	ffffffffc02022fe <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202384:	00005697          	auipc	a3,0x5
ffffffffc0202388:	11468693          	addi	a3,a3,276 # ffffffffc0207498 <default_pmm_manager+0x160>
ffffffffc020238c:	00005617          	auipc	a2,0x5
ffffffffc0202390:	91460613          	addi	a2,a2,-1772 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202394:	12000593          	li	a1,288
ffffffffc0202398:	00005517          	auipc	a0,0x5
ffffffffc020239c:	0f050513          	addi	a0,a0,240 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02023a0:	8dafe0ef          	jal	ra,ffffffffc020047a <__panic>
    return KADDR(page2pa(page));
ffffffffc02023a4:	00005617          	auipc	a2,0x5
ffffffffc02023a8:	fcc60613          	addi	a2,a2,-52 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc02023ac:	06900593          	li	a1,105
ffffffffc02023b0:	00005517          	auipc	a0,0x5
ffffffffc02023b4:	fe850513          	addi	a0,a0,-24 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc02023b8:	8c2fe0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc02023bc:	8e3ff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02023c0:	00005697          	auipc	a3,0x5
ffffffffc02023c4:	10868693          	addi	a3,a3,264 # ffffffffc02074c8 <default_pmm_manager+0x190>
ffffffffc02023c8:	00005617          	auipc	a2,0x5
ffffffffc02023cc:	8d860613          	addi	a2,a2,-1832 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02023d0:	12100593          	li	a1,289
ffffffffc02023d4:	00005517          	auipc	a0,0x5
ffffffffc02023d8:	0b450513          	addi	a0,a0,180 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02023dc:	89efe0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02023e0 <page_remove>:
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc02023e0:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02023e2:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc02023e4:	ec26                	sd	s1,24(sp)
ffffffffc02023e6:	f406                	sd	ra,40(sp)
ffffffffc02023e8:	f022                	sd	s0,32(sp)
ffffffffc02023ea:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02023ec:	9f7ff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
    if (ptep != NULL) {
ffffffffc02023f0:	c511                	beqz	a0,ffffffffc02023fc <page_remove+0x1c>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc02023f2:	611c                	ld	a5,0(a0)
ffffffffc02023f4:	842a                	mv	s0,a0
ffffffffc02023f6:	0017f713          	andi	a4,a5,1
ffffffffc02023fa:	e711                	bnez	a4,ffffffffc0202406 <page_remove+0x26>
}
ffffffffc02023fc:	70a2                	ld	ra,40(sp)
ffffffffc02023fe:	7402                	ld	s0,32(sp)
ffffffffc0202400:	64e2                	ld	s1,24(sp)
ffffffffc0202402:	6145                	addi	sp,sp,48
ffffffffc0202404:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202406:	078a                	slli	a5,a5,0x2
ffffffffc0202408:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020240a:	000b0717          	auipc	a4,0xb0
ffffffffc020240e:	3f673703          	ld	a4,1014(a4) # ffffffffc02b2800 <npage>
ffffffffc0202412:	06e7f363          	bgeu	a5,a4,ffffffffc0202478 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202416:	fff80537          	lui	a0,0xfff80
ffffffffc020241a:	97aa                	add	a5,a5,a0
ffffffffc020241c:	079a                	slli	a5,a5,0x6
ffffffffc020241e:	000b0517          	auipc	a0,0xb0
ffffffffc0202422:	3ea53503          	ld	a0,1002(a0) # ffffffffc02b2808 <pages>
ffffffffc0202426:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202428:	411c                	lw	a5,0(a0)
ffffffffc020242a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020242e:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202430:	cb11                	beqz	a4,ffffffffc0202444 <page_remove+0x64>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202432:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202436:	12048073          	sfence.vma	s1
}
ffffffffc020243a:	70a2                	ld	ra,40(sp)
ffffffffc020243c:	7402                	ld	s0,32(sp)
ffffffffc020243e:	64e2                	ld	s1,24(sp)
ffffffffc0202440:	6145                	addi	sp,sp,48
ffffffffc0202442:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202444:	100027f3          	csrr	a5,sstatus
ffffffffc0202448:	8b89                	andi	a5,a5,2
ffffffffc020244a:	eb89                	bnez	a5,ffffffffc020245c <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020244c:	000b0797          	auipc	a5,0xb0
ffffffffc0202450:	3c47b783          	ld	a5,964(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0202454:	739c                	ld	a5,32(a5)
ffffffffc0202456:	4585                	li	a1,1
ffffffffc0202458:	9782                	jalr	a5
    if (flag) {
ffffffffc020245a:	bfe1                	j	ffffffffc0202432 <page_remove+0x52>
        intr_disable();
ffffffffc020245c:	e42a                	sd	a0,8(sp)
ffffffffc020245e:	9e8fe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202462:	000b0797          	auipc	a5,0xb0
ffffffffc0202466:	3ae7b783          	ld	a5,942(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc020246a:	739c                	ld	a5,32(a5)
ffffffffc020246c:	6522                	ld	a0,8(sp)
ffffffffc020246e:	4585                	li	a1,1
ffffffffc0202470:	9782                	jalr	a5
        intr_enable();
ffffffffc0202472:	9cefe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202476:	bf75                	j	ffffffffc0202432 <page_remove+0x52>
ffffffffc0202478:	827ff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>

ffffffffc020247c <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc020247c:	7139                	addi	sp,sp,-64
ffffffffc020247e:	e852                	sd	s4,16(sp)
ffffffffc0202480:	8a32                	mv	s4,a2
ffffffffc0202482:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202484:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202486:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202488:	85d2                	mv	a1,s4
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc020248a:	f426                	sd	s1,40(sp)
ffffffffc020248c:	fc06                	sd	ra,56(sp)
ffffffffc020248e:	f04a                	sd	s2,32(sp)
ffffffffc0202490:	ec4e                	sd	s3,24(sp)
ffffffffc0202492:	e456                	sd	s5,8(sp)
ffffffffc0202494:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202496:	94dff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
    if (ptep == NULL) {
ffffffffc020249a:	c961                	beqz	a0,ffffffffc020256a <page_insert+0xee>
    page->ref += 1;
ffffffffc020249c:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc020249e:	611c                	ld	a5,0(a0)
ffffffffc02024a0:	89aa                	mv	s3,a0
ffffffffc02024a2:	0016871b          	addiw	a4,a3,1
ffffffffc02024a6:	c018                	sw	a4,0(s0)
ffffffffc02024a8:	0017f713          	andi	a4,a5,1
ffffffffc02024ac:	ef05                	bnez	a4,ffffffffc02024e4 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc02024ae:	000b0717          	auipc	a4,0xb0
ffffffffc02024b2:	35a73703          	ld	a4,858(a4) # ffffffffc02b2808 <pages>
ffffffffc02024b6:	8c19                	sub	s0,s0,a4
ffffffffc02024b8:	000807b7          	lui	a5,0x80
ffffffffc02024bc:	8419                	srai	s0,s0,0x6
ffffffffc02024be:	943e                	add	s0,s0,a5
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02024c0:	042a                	slli	s0,s0,0xa
ffffffffc02024c2:	8cc1                	or	s1,s1,s0
ffffffffc02024c4:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02024c8:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ed8>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02024cc:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02024d0:	4501                	li	a0,0
}
ffffffffc02024d2:	70e2                	ld	ra,56(sp)
ffffffffc02024d4:	7442                	ld	s0,48(sp)
ffffffffc02024d6:	74a2                	ld	s1,40(sp)
ffffffffc02024d8:	7902                	ld	s2,32(sp)
ffffffffc02024da:	69e2                	ld	s3,24(sp)
ffffffffc02024dc:	6a42                	ld	s4,16(sp)
ffffffffc02024de:	6aa2                	ld	s5,8(sp)
ffffffffc02024e0:	6121                	addi	sp,sp,64
ffffffffc02024e2:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02024e4:	078a                	slli	a5,a5,0x2
ffffffffc02024e6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02024e8:	000b0717          	auipc	a4,0xb0
ffffffffc02024ec:	31873703          	ld	a4,792(a4) # ffffffffc02b2800 <npage>
ffffffffc02024f0:	06e7ff63          	bgeu	a5,a4,ffffffffc020256e <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02024f4:	000b0a97          	auipc	s5,0xb0
ffffffffc02024f8:	314a8a93          	addi	s5,s5,788 # ffffffffc02b2808 <pages>
ffffffffc02024fc:	000ab703          	ld	a4,0(s5)
ffffffffc0202500:	fff80937          	lui	s2,0xfff80
ffffffffc0202504:	993e                	add	s2,s2,a5
ffffffffc0202506:	091a                	slli	s2,s2,0x6
ffffffffc0202508:	993a                	add	s2,s2,a4
        if (p == page) {
ffffffffc020250a:	01240c63          	beq	s0,s2,ffffffffc0202522 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020250e:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fccd79c>
ffffffffc0202512:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202516:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc020251a:	c691                	beqz	a3,ffffffffc0202526 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020251c:	120a0073          	sfence.vma	s4
}
ffffffffc0202520:	bf59                	j	ffffffffc02024b6 <page_insert+0x3a>
ffffffffc0202522:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202524:	bf49                	j	ffffffffc02024b6 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202526:	100027f3          	csrr	a5,sstatus
ffffffffc020252a:	8b89                	andi	a5,a5,2
ffffffffc020252c:	ef91                	bnez	a5,ffffffffc0202548 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020252e:	000b0797          	auipc	a5,0xb0
ffffffffc0202532:	2e27b783          	ld	a5,738(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0202536:	739c                	ld	a5,32(a5)
ffffffffc0202538:	4585                	li	a1,1
ffffffffc020253a:	854a                	mv	a0,s2
ffffffffc020253c:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020253e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202542:	120a0073          	sfence.vma	s4
ffffffffc0202546:	bf85                	j	ffffffffc02024b6 <page_insert+0x3a>
        intr_disable();
ffffffffc0202548:	8fefe0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020254c:	000b0797          	auipc	a5,0xb0
ffffffffc0202550:	2c47b783          	ld	a5,708(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc0202554:	739c                	ld	a5,32(a5)
ffffffffc0202556:	4585                	li	a1,1
ffffffffc0202558:	854a                	mv	a0,s2
ffffffffc020255a:	9782                	jalr	a5
        intr_enable();
ffffffffc020255c:	8e4fe0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202560:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202564:	120a0073          	sfence.vma	s4
ffffffffc0202568:	b7b9                	j	ffffffffc02024b6 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020256a:	5571                	li	a0,-4
ffffffffc020256c:	b79d                	j	ffffffffc02024d2 <page_insert+0x56>
ffffffffc020256e:	f30ff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>

ffffffffc0202572 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202572:	00005797          	auipc	a5,0x5
ffffffffc0202576:	dc678793          	addi	a5,a5,-570 # ffffffffc0207338 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020257a:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc020257c:	711d                	addi	sp,sp,-96
ffffffffc020257e:	ec5e                	sd	s7,24(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202580:	00005517          	auipc	a0,0x5
ffffffffc0202584:	f6050513          	addi	a0,a0,-160 # ffffffffc02074e0 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202588:	000b0b97          	auipc	s7,0xb0
ffffffffc020258c:	288b8b93          	addi	s7,s7,648 # ffffffffc02b2810 <pmm_manager>
void pmm_init(void) {
ffffffffc0202590:	ec86                	sd	ra,88(sp)
ffffffffc0202592:	e4a6                	sd	s1,72(sp)
ffffffffc0202594:	fc4e                	sd	s3,56(sp)
ffffffffc0202596:	f05a                	sd	s6,32(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202598:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc020259c:	e8a2                	sd	s0,80(sp)
ffffffffc020259e:	e0ca                	sd	s2,64(sp)
ffffffffc02025a0:	f852                	sd	s4,48(sp)
ffffffffc02025a2:	f456                	sd	s5,40(sp)
ffffffffc02025a4:	e862                	sd	s8,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02025a6:	bdbfd0ef          	jal	ra,ffffffffc0200180 <cprintf>
    pmm_manager->init();
ffffffffc02025aa:	000bb783          	ld	a5,0(s7)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc02025ae:	000b0997          	auipc	s3,0xb0
ffffffffc02025b2:	26a98993          	addi	s3,s3,618 # ffffffffc02b2818 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc02025b6:	000b0497          	auipc	s1,0xb0
ffffffffc02025ba:	24a48493          	addi	s1,s1,586 # ffffffffc02b2800 <npage>
    pmm_manager->init();
ffffffffc02025be:	679c                	ld	a5,8(a5)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02025c0:	000b0b17          	auipc	s6,0xb0
ffffffffc02025c4:	248b0b13          	addi	s6,s6,584 # ffffffffc02b2808 <pages>
    pmm_manager->init();
ffffffffc02025c8:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc02025ca:	57f5                	li	a5,-3
ffffffffc02025cc:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02025ce:	00005517          	auipc	a0,0x5
ffffffffc02025d2:	f2a50513          	addi	a0,a0,-214 # ffffffffc02074f8 <default_pmm_manager+0x1c0>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc02025d6:	00f9b023          	sd	a5,0(s3)
    cprintf("physcial memory map:\n");
ffffffffc02025da:	ba7fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02025de:	46c5                	li	a3,17
ffffffffc02025e0:	06ee                	slli	a3,a3,0x1b
ffffffffc02025e2:	40100613          	li	a2,1025
ffffffffc02025e6:	07e005b7          	lui	a1,0x7e00
ffffffffc02025ea:	16fd                	addi	a3,a3,-1
ffffffffc02025ec:	0656                	slli	a2,a2,0x15
ffffffffc02025ee:	00005517          	auipc	a0,0x5
ffffffffc02025f2:	f2250513          	addi	a0,a0,-222 # ffffffffc0207510 <default_pmm_manager+0x1d8>
ffffffffc02025f6:	b8bfd0ef          	jal	ra,ffffffffc0200180 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02025fa:	777d                	lui	a4,0xfffff
ffffffffc02025fc:	000b1797          	auipc	a5,0xb1
ffffffffc0202600:	26778793          	addi	a5,a5,615 # ffffffffc02b3863 <end+0xfff>
ffffffffc0202604:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0202606:	00088737          	lui	a4,0x88
ffffffffc020260a:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020260c:	00fb3023          	sd	a5,0(s6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0202610:	4701                	li	a4,0
ffffffffc0202612:	4585                	li	a1,1
ffffffffc0202614:	fff80837          	lui	a6,0xfff80
ffffffffc0202618:	a019                	j	ffffffffc020261e <pmm_init+0xac>
        SetPageReserved(pages + i);
ffffffffc020261a:	000b3783          	ld	a5,0(s6)
ffffffffc020261e:	00671693          	slli	a3,a4,0x6
ffffffffc0202622:	97b6                	add	a5,a5,a3
ffffffffc0202624:	07a1                	addi	a5,a5,8
ffffffffc0202626:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020262a:	6090                	ld	a2,0(s1)
ffffffffc020262c:	0705                	addi	a4,a4,1
ffffffffc020262e:	010607b3          	add	a5,a2,a6
ffffffffc0202632:	fef764e3          	bltu	a4,a5,ffffffffc020261a <pmm_init+0xa8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202636:	000b3503          	ld	a0,0(s6)
ffffffffc020263a:	079a                	slli	a5,a5,0x6
ffffffffc020263c:	c0200737          	lui	a4,0xc0200
ffffffffc0202640:	00f506b3          	add	a3,a0,a5
ffffffffc0202644:	60e6e563          	bltu	a3,a4,ffffffffc0202c4e <pmm_init+0x6dc>
ffffffffc0202648:	0009b583          	ld	a1,0(s3)
    if (freemem < mem_end) {
ffffffffc020264c:	4745                	li	a4,17
ffffffffc020264e:	076e                	slli	a4,a4,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202650:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end) {
ffffffffc0202652:	4ae6e563          	bltu	a3,a4,ffffffffc0202afc <pmm_init+0x58a>
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202656:	00005517          	auipc	a0,0x5
ffffffffc020265a:	ee250513          	addi	a0,a0,-286 # ffffffffc0207538 <default_pmm_manager+0x200>
ffffffffc020265e:	b23fd0ef          	jal	ra,ffffffffc0200180 <cprintf>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0202662:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0202666:	000b0917          	auipc	s2,0xb0
ffffffffc020266a:	19290913          	addi	s2,s2,402 # ffffffffc02b27f8 <boot_pgdir>
    pmm_manager->check();
ffffffffc020266e:	7b9c                	ld	a5,48(a5)
ffffffffc0202670:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202672:	00005517          	auipc	a0,0x5
ffffffffc0202676:	ede50513          	addi	a0,a0,-290 # ffffffffc0207550 <default_pmm_manager+0x218>
ffffffffc020267a:	b07fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020267e:	00009697          	auipc	a3,0x9
ffffffffc0202682:	98268693          	addi	a3,a3,-1662 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc0202686:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc020268a:	c02007b7          	lui	a5,0xc0200
ffffffffc020268e:	5cf6ec63          	bltu	a3,a5,ffffffffc0202c66 <pmm_init+0x6f4>
ffffffffc0202692:	0009b783          	ld	a5,0(s3)
ffffffffc0202696:	8e9d                	sub	a3,a3,a5
ffffffffc0202698:	000b0797          	auipc	a5,0xb0
ffffffffc020269c:	14d7bc23          	sd	a3,344(a5) # ffffffffc02b27f0 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02026a0:	100027f3          	csrr	a5,sstatus
ffffffffc02026a4:	8b89                	andi	a5,a5,2
ffffffffc02026a6:	48079263          	bnez	a5,ffffffffc0202b2a <pmm_init+0x5b8>
        ret = pmm_manager->nr_free_pages();
ffffffffc02026aa:	000bb783          	ld	a5,0(s7)
ffffffffc02026ae:	779c                	ld	a5,40(a5)
ffffffffc02026b0:	9782                	jalr	a5
ffffffffc02026b2:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02026b4:	6098                	ld	a4,0(s1)
ffffffffc02026b6:	c80007b7          	lui	a5,0xc8000
ffffffffc02026ba:	83b1                	srli	a5,a5,0xc
ffffffffc02026bc:	5ee7e163          	bltu	a5,a4,ffffffffc0202c9e <pmm_init+0x72c>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02026c0:	00093503          	ld	a0,0(s2)
ffffffffc02026c4:	5a050d63          	beqz	a0,ffffffffc0202c7e <pmm_init+0x70c>
ffffffffc02026c8:	03451793          	slli	a5,a0,0x34
ffffffffc02026cc:	5a079963          	bnez	a5,ffffffffc0202c7e <pmm_init+0x70c>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02026d0:	4601                	li	a2,0
ffffffffc02026d2:	4581                	li	a1,0
ffffffffc02026d4:	8e1ff0ef          	jal	ra,ffffffffc0201fb4 <get_page>
ffffffffc02026d8:	62051563          	bnez	a0,ffffffffc0202d02 <pmm_init+0x790>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02026dc:	4505                	li	a0,1
ffffffffc02026de:	df8ff0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc02026e2:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02026e4:	00093503          	ld	a0,0(s2)
ffffffffc02026e8:	4681                	li	a3,0
ffffffffc02026ea:	4601                	li	a2,0
ffffffffc02026ec:	85d2                	mv	a1,s4
ffffffffc02026ee:	d8fff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc02026f2:	5e051863          	bnez	a0,ffffffffc0202ce2 <pmm_init+0x770>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02026f6:	00093503          	ld	a0,0(s2)
ffffffffc02026fa:	4601                	li	a2,0
ffffffffc02026fc:	4581                	li	a1,0
ffffffffc02026fe:	ee4ff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0202702:	5c050063          	beqz	a0,ffffffffc0202cc2 <pmm_init+0x750>
    assert(pte2page(*ptep) == p1);
ffffffffc0202706:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0202708:	0017f713          	andi	a4,a5,1
ffffffffc020270c:	5a070963          	beqz	a4,ffffffffc0202cbe <pmm_init+0x74c>
    if (PPN(pa) >= npage) {
ffffffffc0202710:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202712:	078a                	slli	a5,a5,0x2
ffffffffc0202714:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202716:	52e7fa63          	bgeu	a5,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc020271a:	000b3683          	ld	a3,0(s6)
ffffffffc020271e:	fff80637          	lui	a2,0xfff80
ffffffffc0202722:	97b2                	add	a5,a5,a2
ffffffffc0202724:	079a                	slli	a5,a5,0x6
ffffffffc0202726:	97b6                	add	a5,a5,a3
ffffffffc0202728:	10fa16e3          	bne	s4,a5,ffffffffc0203034 <pmm_init+0xac2>
    assert(page_ref(p1) == 1);
ffffffffc020272c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202730:	4785                	li	a5,1
ffffffffc0202732:	12f69de3          	bne	a3,a5,ffffffffc020306c <pmm_init+0xafa>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202736:	00093503          	ld	a0,0(s2)
ffffffffc020273a:	77fd                	lui	a5,0xfffff
ffffffffc020273c:	6114                	ld	a3,0(a0)
ffffffffc020273e:	068a                	slli	a3,a3,0x2
ffffffffc0202740:	8efd                	and	a3,a3,a5
ffffffffc0202742:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202746:	10e677e3          	bgeu	a2,a4,ffffffffc0203054 <pmm_init+0xae2>
ffffffffc020274a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020274e:	96e2                	add	a3,a3,s8
ffffffffc0202750:	0006ba83          	ld	s5,0(a3)
ffffffffc0202754:	0a8a                	slli	s5,s5,0x2
ffffffffc0202756:	00fafab3          	and	s5,s5,a5
ffffffffc020275a:	00cad793          	srli	a5,s5,0xc
ffffffffc020275e:	62e7f263          	bgeu	a5,a4,ffffffffc0202d82 <pmm_init+0x810>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202762:	4601                	li	a2,0
ffffffffc0202764:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202766:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202768:	e7aff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020276c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020276e:	5f551a63          	bne	a0,s5,ffffffffc0202d62 <pmm_init+0x7f0>

    p2 = alloc_page();
ffffffffc0202772:	4505                	li	a0,1
ffffffffc0202774:	d62ff0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0202778:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020277a:	00093503          	ld	a0,0(s2)
ffffffffc020277e:	46d1                	li	a3,20
ffffffffc0202780:	6605                	lui	a2,0x1
ffffffffc0202782:	85d6                	mv	a1,s5
ffffffffc0202784:	cf9ff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc0202788:	58051d63          	bnez	a0,ffffffffc0202d22 <pmm_init+0x7b0>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020278c:	00093503          	ld	a0,0(s2)
ffffffffc0202790:	4601                	li	a2,0
ffffffffc0202792:	6585                	lui	a1,0x1
ffffffffc0202794:	e4eff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0202798:	0e050ae3          	beqz	a0,ffffffffc020308c <pmm_init+0xb1a>
    assert(*ptep & PTE_U);
ffffffffc020279c:	611c                	ld	a5,0(a0)
ffffffffc020279e:	0107f713          	andi	a4,a5,16
ffffffffc02027a2:	6e070d63          	beqz	a4,ffffffffc0202e9c <pmm_init+0x92a>
    assert(*ptep & PTE_W);
ffffffffc02027a6:	8b91                	andi	a5,a5,4
ffffffffc02027a8:	6a078a63          	beqz	a5,ffffffffc0202e5c <pmm_init+0x8ea>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc02027ac:	00093503          	ld	a0,0(s2)
ffffffffc02027b0:	611c                	ld	a5,0(a0)
ffffffffc02027b2:	8bc1                	andi	a5,a5,16
ffffffffc02027b4:	68078463          	beqz	a5,ffffffffc0202e3c <pmm_init+0x8ca>
    assert(page_ref(p2) == 1);
ffffffffc02027b8:	000aa703          	lw	a4,0(s5)
ffffffffc02027bc:	4785                	li	a5,1
ffffffffc02027be:	58f71263          	bne	a4,a5,ffffffffc0202d42 <pmm_init+0x7d0>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02027c2:	4681                	li	a3,0
ffffffffc02027c4:	6605                	lui	a2,0x1
ffffffffc02027c6:	85d2                	mv	a1,s4
ffffffffc02027c8:	cb5ff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc02027cc:	62051863          	bnez	a0,ffffffffc0202dfc <pmm_init+0x88a>
    assert(page_ref(p1) == 2);
ffffffffc02027d0:	000a2703          	lw	a4,0(s4)
ffffffffc02027d4:	4789                	li	a5,2
ffffffffc02027d6:	60f71363          	bne	a4,a5,ffffffffc0202ddc <pmm_init+0x86a>
    assert(page_ref(p2) == 0);
ffffffffc02027da:	000aa783          	lw	a5,0(s5)
ffffffffc02027de:	5c079f63          	bnez	a5,ffffffffc0202dbc <pmm_init+0x84a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02027e2:	00093503          	ld	a0,0(s2)
ffffffffc02027e6:	4601                	li	a2,0
ffffffffc02027e8:	6585                	lui	a1,0x1
ffffffffc02027ea:	df8ff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc02027ee:	5a050763          	beqz	a0,ffffffffc0202d9c <pmm_init+0x82a>
    assert(pte2page(*ptep) == p1);
ffffffffc02027f2:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02027f4:	00177793          	andi	a5,a4,1
ffffffffc02027f8:	4c078363          	beqz	a5,ffffffffc0202cbe <pmm_init+0x74c>
    if (PPN(pa) >= npage) {
ffffffffc02027fc:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02027fe:	00271793          	slli	a5,a4,0x2
ffffffffc0202802:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202804:	44d7f363          	bgeu	a5,a3,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc0202808:	000b3683          	ld	a3,0(s6)
ffffffffc020280c:	fff80637          	lui	a2,0xfff80
ffffffffc0202810:	97b2                	add	a5,a5,a2
ffffffffc0202812:	079a                	slli	a5,a5,0x6
ffffffffc0202814:	97b6                	add	a5,a5,a3
ffffffffc0202816:	6efa1363          	bne	s4,a5,ffffffffc0202efc <pmm_init+0x98a>
    assert((*ptep & PTE_U) == 0);
ffffffffc020281a:	8b41                	andi	a4,a4,16
ffffffffc020281c:	6c071063          	bnez	a4,ffffffffc0202edc <pmm_init+0x96a>

    page_remove(boot_pgdir, 0x0);
ffffffffc0202820:	00093503          	ld	a0,0(s2)
ffffffffc0202824:	4581                	li	a1,0
ffffffffc0202826:	bbbff0ef          	jal	ra,ffffffffc02023e0 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020282a:	000a2703          	lw	a4,0(s4)
ffffffffc020282e:	4785                	li	a5,1
ffffffffc0202830:	68f71663          	bne	a4,a5,ffffffffc0202ebc <pmm_init+0x94a>
    assert(page_ref(p2) == 0);
ffffffffc0202834:	000aa783          	lw	a5,0(s5)
ffffffffc0202838:	74079e63          	bnez	a5,ffffffffc0202f94 <pmm_init+0xa22>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc020283c:	00093503          	ld	a0,0(s2)
ffffffffc0202840:	6585                	lui	a1,0x1
ffffffffc0202842:	b9fff0ef          	jal	ra,ffffffffc02023e0 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202846:	000a2783          	lw	a5,0(s4)
ffffffffc020284a:	72079563          	bnez	a5,ffffffffc0202f74 <pmm_init+0xa02>
    assert(page_ref(p2) == 0);
ffffffffc020284e:	000aa783          	lw	a5,0(s5)
ffffffffc0202852:	70079163          	bnez	a5,ffffffffc0202f54 <pmm_init+0x9e2>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202856:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020285a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020285c:	000a3683          	ld	a3,0(s4)
ffffffffc0202860:	068a                	slli	a3,a3,0x2
ffffffffc0202862:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202864:	3ee6f363          	bgeu	a3,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc0202868:	fff807b7          	lui	a5,0xfff80
ffffffffc020286c:	000b3503          	ld	a0,0(s6)
ffffffffc0202870:	96be                	add	a3,a3,a5
ffffffffc0202872:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202874:	00d507b3          	add	a5,a0,a3
ffffffffc0202878:	4390                	lw	a2,0(a5)
ffffffffc020287a:	4785                	li	a5,1
ffffffffc020287c:	6af61c63          	bne	a2,a5,ffffffffc0202f34 <pmm_init+0x9c2>
    return page - pages + nbase;
ffffffffc0202880:	8699                	srai	a3,a3,0x6
ffffffffc0202882:	000805b7          	lui	a1,0x80
ffffffffc0202886:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0202888:	00c69613          	slli	a2,a3,0xc
ffffffffc020288c:	8231                	srli	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020288e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202890:	68e67663          	bgeu	a2,a4,ffffffffc0202f1c <pmm_init+0x9aa>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202894:	0009b603          	ld	a2,0(s3)
ffffffffc0202898:	96b2                	add	a3,a3,a2
    return pa2page(PDE_ADDR(pde));
ffffffffc020289a:	629c                	ld	a5,0(a3)
ffffffffc020289c:	078a                	slli	a5,a5,0x2
ffffffffc020289e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02028a0:	3ae7f563          	bgeu	a5,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc02028a4:	8f8d                	sub	a5,a5,a1
ffffffffc02028a6:	079a                	slli	a5,a5,0x6
ffffffffc02028a8:	953e                	add	a0,a0,a5
ffffffffc02028aa:	100027f3          	csrr	a5,sstatus
ffffffffc02028ae:	8b89                	andi	a5,a5,2
ffffffffc02028b0:	2c079763          	bnez	a5,ffffffffc0202b7e <pmm_init+0x60c>
        pmm_manager->free_pages(base, n);
ffffffffc02028b4:	000bb783          	ld	a5,0(s7)
ffffffffc02028b8:	4585                	li	a1,1
ffffffffc02028ba:	739c                	ld	a5,32(a5)
ffffffffc02028bc:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02028be:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02028c2:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02028c4:	078a                	slli	a5,a5,0x2
ffffffffc02028c6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02028c8:	38e7f163          	bgeu	a5,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc02028cc:	000b3503          	ld	a0,0(s6)
ffffffffc02028d0:	fff80737          	lui	a4,0xfff80
ffffffffc02028d4:	97ba                	add	a5,a5,a4
ffffffffc02028d6:	079a                	slli	a5,a5,0x6
ffffffffc02028d8:	953e                	add	a0,a0,a5
ffffffffc02028da:	100027f3          	csrr	a5,sstatus
ffffffffc02028de:	8b89                	andi	a5,a5,2
ffffffffc02028e0:	28079363          	bnez	a5,ffffffffc0202b66 <pmm_init+0x5f4>
ffffffffc02028e4:	000bb783          	ld	a5,0(s7)
ffffffffc02028e8:	4585                	li	a1,1
ffffffffc02028ea:	739c                	ld	a5,32(a5)
ffffffffc02028ec:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02028ee:	00093783          	ld	a5,0(s2)
ffffffffc02028f2:	0007b023          	sd	zero,0(a5) # fffffffffff80000 <end+0x3fccd79c>
  asm volatile("sfence.vma");
ffffffffc02028f6:	12000073          	sfence.vma
ffffffffc02028fa:	100027f3          	csrr	a5,sstatus
ffffffffc02028fe:	8b89                	andi	a5,a5,2
ffffffffc0202900:	24079963          	bnez	a5,ffffffffc0202b52 <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202904:	000bb783          	ld	a5,0(s7)
ffffffffc0202908:	779c                	ld	a5,40(a5)
ffffffffc020290a:	9782                	jalr	a5
ffffffffc020290c:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc020290e:	71441363          	bne	s0,s4,ffffffffc0203014 <pmm_init+0xaa2>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202912:	00005517          	auipc	a0,0x5
ffffffffc0202916:	f2650513          	addi	a0,a0,-218 # ffffffffc0207838 <default_pmm_manager+0x500>
ffffffffc020291a:	867fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020291e:	100027f3          	csrr	a5,sstatus
ffffffffc0202922:	8b89                	andi	a5,a5,2
ffffffffc0202924:	20079d63          	bnez	a5,ffffffffc0202b3e <pmm_init+0x5cc>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202928:	000bb783          	ld	a5,0(s7)
ffffffffc020292c:	779c                	ld	a5,40(a5)
ffffffffc020292e:	9782                	jalr	a5
ffffffffc0202930:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0202932:	6098                	ld	a4,0(s1)
ffffffffc0202934:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202938:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020293a:	00c71793          	slli	a5,a4,0xc
ffffffffc020293e:	6a05                	lui	s4,0x1
ffffffffc0202940:	02f47c63          	bgeu	s0,a5,ffffffffc0202978 <pmm_init+0x406>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202944:	00c45793          	srli	a5,s0,0xc
ffffffffc0202948:	00093503          	ld	a0,0(s2)
ffffffffc020294c:	2ee7f263          	bgeu	a5,a4,ffffffffc0202c30 <pmm_init+0x6be>
ffffffffc0202950:	0009b583          	ld	a1,0(s3)
ffffffffc0202954:	4601                	li	a2,0
ffffffffc0202956:	95a2                	add	a1,a1,s0
ffffffffc0202958:	c8aff0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc020295c:	2a050a63          	beqz	a0,ffffffffc0202c10 <pmm_init+0x69e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202960:	611c                	ld	a5,0(a0)
ffffffffc0202962:	078a                	slli	a5,a5,0x2
ffffffffc0202964:	0157f7b3          	and	a5,a5,s5
ffffffffc0202968:	28879463          	bne	a5,s0,ffffffffc0202bf0 <pmm_init+0x67e>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020296c:	6098                	ld	a4,0(s1)
ffffffffc020296e:	9452                	add	s0,s0,s4
ffffffffc0202970:	00c71793          	slli	a5,a4,0xc
ffffffffc0202974:	fcf468e3          	bltu	s0,a5,ffffffffc0202944 <pmm_init+0x3d2>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc0202978:	00093783          	ld	a5,0(s2)
ffffffffc020297c:	639c                	ld	a5,0(a5)
ffffffffc020297e:	66079b63          	bnez	a5,ffffffffc0202ff4 <pmm_init+0xa82>

    struct Page *p;
    p = alloc_page();
ffffffffc0202982:	4505                	li	a0,1
ffffffffc0202984:	b52ff0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0202988:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020298a:	00093503          	ld	a0,0(s2)
ffffffffc020298e:	4699                	li	a3,6
ffffffffc0202990:	10000613          	li	a2,256
ffffffffc0202994:	85d6                	mv	a1,s5
ffffffffc0202996:	ae7ff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc020299a:	62051d63          	bnez	a0,ffffffffc0202fd4 <pmm_init+0xa62>
    assert(page_ref(p) == 1);
ffffffffc020299e:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fd4c79c>
ffffffffc02029a2:	4785                	li	a5,1
ffffffffc02029a4:	60f71863          	bne	a4,a5,ffffffffc0202fb4 <pmm_init+0xa42>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02029a8:	00093503          	ld	a0,0(s2)
ffffffffc02029ac:	6405                	lui	s0,0x1
ffffffffc02029ae:	4699                	li	a3,6
ffffffffc02029b0:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab0>
ffffffffc02029b4:	85d6                	mv	a1,s5
ffffffffc02029b6:	ac7ff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc02029ba:	46051163          	bnez	a0,ffffffffc0202e1c <pmm_init+0x8aa>
    assert(page_ref(p) == 2);
ffffffffc02029be:	000aa703          	lw	a4,0(s5)
ffffffffc02029c2:	4789                	li	a5,2
ffffffffc02029c4:	72f71463          	bne	a4,a5,ffffffffc02030ec <pmm_init+0xb7a>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02029c8:	00005597          	auipc	a1,0x5
ffffffffc02029cc:	fa858593          	addi	a1,a1,-88 # ffffffffc0207970 <default_pmm_manager+0x638>
ffffffffc02029d0:	10000513          	li	a0,256
ffffffffc02029d4:	3a3030ef          	jal	ra,ffffffffc0206576 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02029d8:	10040593          	addi	a1,s0,256
ffffffffc02029dc:	10000513          	li	a0,256
ffffffffc02029e0:	3a9030ef          	jal	ra,ffffffffc0206588 <strcmp>
ffffffffc02029e4:	6e051463          	bnez	a0,ffffffffc02030cc <pmm_init+0xb5a>
    return page - pages + nbase;
ffffffffc02029e8:	000b3683          	ld	a3,0(s6)
ffffffffc02029ec:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc02029f0:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc02029f2:	40da86b3          	sub	a3,s5,a3
ffffffffc02029f6:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02029f8:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc02029fa:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc02029fc:	8031                	srli	s0,s0,0xc
ffffffffc02029fe:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a02:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a04:	50f77c63          	bgeu	a4,a5,ffffffffc0202f1c <pmm_init+0x9aa>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202a08:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202a0c:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202a10:	96be                	add	a3,a3,a5
ffffffffc0202a12:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202a16:	32b030ef          	jal	ra,ffffffffc0206540 <strlen>
ffffffffc0202a1a:	68051963          	bnez	a0,ffffffffc02030ac <pmm_init+0xb3a>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0202a1e:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0202a22:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a24:	000a3683          	ld	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202a28:	068a                	slli	a3,a3,0x2
ffffffffc0202a2a:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202a2c:	20f6ff63          	bgeu	a3,a5,ffffffffc0202c4a <pmm_init+0x6d8>
    return KADDR(page2pa(page));
ffffffffc0202a30:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a32:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a34:	4ef47463          	bgeu	s0,a5,ffffffffc0202f1c <pmm_init+0x9aa>
ffffffffc0202a38:	0009b403          	ld	s0,0(s3)
ffffffffc0202a3c:	9436                	add	s0,s0,a3
ffffffffc0202a3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202a42:	8b89                	andi	a5,a5,2
ffffffffc0202a44:	18079b63          	bnez	a5,ffffffffc0202bda <pmm_init+0x668>
        pmm_manager->free_pages(base, n);
ffffffffc0202a48:	000bb783          	ld	a5,0(s7)
ffffffffc0202a4c:	4585                	li	a1,1
ffffffffc0202a4e:	8556                	mv	a0,s5
ffffffffc0202a50:	739c                	ld	a5,32(a5)
ffffffffc0202a52:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a54:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202a56:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a58:	078a                	slli	a5,a5,0x2
ffffffffc0202a5a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202a5c:	1ee7f763          	bgeu	a5,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a60:	000b3503          	ld	a0,0(s6)
ffffffffc0202a64:	fff80737          	lui	a4,0xfff80
ffffffffc0202a68:	97ba                	add	a5,a5,a4
ffffffffc0202a6a:	079a                	slli	a5,a5,0x6
ffffffffc0202a6c:	953e                	add	a0,a0,a5
ffffffffc0202a6e:	100027f3          	csrr	a5,sstatus
ffffffffc0202a72:	8b89                	andi	a5,a5,2
ffffffffc0202a74:	14079763          	bnez	a5,ffffffffc0202bc2 <pmm_init+0x650>
ffffffffc0202a78:	000bb783          	ld	a5,0(s7)
ffffffffc0202a7c:	4585                	li	a1,1
ffffffffc0202a7e:	739c                	ld	a5,32(a5)
ffffffffc0202a80:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a82:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0202a86:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a88:	078a                	slli	a5,a5,0x2
ffffffffc0202a8a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202a8c:	1ae7ff63          	bgeu	a5,a4,ffffffffc0202c4a <pmm_init+0x6d8>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a90:	000b3503          	ld	a0,0(s6)
ffffffffc0202a94:	fff80737          	lui	a4,0xfff80
ffffffffc0202a98:	97ba                	add	a5,a5,a4
ffffffffc0202a9a:	079a                	slli	a5,a5,0x6
ffffffffc0202a9c:	953e                	add	a0,a0,a5
ffffffffc0202a9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202aa2:	8b89                	andi	a5,a5,2
ffffffffc0202aa4:	10079363          	bnez	a5,ffffffffc0202baa <pmm_init+0x638>
ffffffffc0202aa8:	000bb783          	ld	a5,0(s7)
ffffffffc0202aac:	4585                	li	a1,1
ffffffffc0202aae:	739c                	ld	a5,32(a5)
ffffffffc0202ab0:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0202ab2:	00093783          	ld	a5,0(s2)
ffffffffc0202ab6:	0007b023          	sd	zero,0(a5)
  asm volatile("sfence.vma");
ffffffffc0202aba:	12000073          	sfence.vma
ffffffffc0202abe:	100027f3          	csrr	a5,sstatus
ffffffffc0202ac2:	8b89                	andi	a5,a5,2
ffffffffc0202ac4:	0c079963          	bnez	a5,ffffffffc0202b96 <pmm_init+0x624>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ac8:	000bb783          	ld	a5,0(s7)
ffffffffc0202acc:	779c                	ld	a5,40(a5)
ffffffffc0202ace:	9782                	jalr	a5
ffffffffc0202ad0:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc0202ad2:	3a8c1563          	bne	s8,s0,ffffffffc0202e7c <pmm_init+0x90a>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ad6:	00005517          	auipc	a0,0x5
ffffffffc0202ada:	f1250513          	addi	a0,a0,-238 # ffffffffc02079e8 <default_pmm_manager+0x6b0>
ffffffffc0202ade:	ea2fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc0202ae2:	6446                	ld	s0,80(sp)
ffffffffc0202ae4:	60e6                	ld	ra,88(sp)
ffffffffc0202ae6:	64a6                	ld	s1,72(sp)
ffffffffc0202ae8:	6906                	ld	s2,64(sp)
ffffffffc0202aea:	79e2                	ld	s3,56(sp)
ffffffffc0202aec:	7a42                	ld	s4,48(sp)
ffffffffc0202aee:	7aa2                	ld	s5,40(sp)
ffffffffc0202af0:	7b02                	ld	s6,32(sp)
ffffffffc0202af2:	6be2                	ld	s7,24(sp)
ffffffffc0202af4:	6c42                	ld	s8,16(sp)
ffffffffc0202af6:	6125                	addi	sp,sp,96
    kmalloc_init();
ffffffffc0202af8:	fddfe06f          	j	ffffffffc0201ad4 <kmalloc_init>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202afc:	6785                	lui	a5,0x1
ffffffffc0202afe:	17fd                	addi	a5,a5,-1
ffffffffc0202b00:	96be                	add	a3,a3,a5
ffffffffc0202b02:	77fd                	lui	a5,0xfffff
ffffffffc0202b04:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage) {
ffffffffc0202b06:	00c7d693          	srli	a3,a5,0xc
ffffffffc0202b0a:	14c6f063          	bgeu	a3,a2,ffffffffc0202c4a <pmm_init+0x6d8>
    pmm_manager->init_memmap(base, n);
ffffffffc0202b0e:	000bb603          	ld	a2,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0202b12:	96c2                	add	a3,a3,a6
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202b14:	40f707b3          	sub	a5,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202b18:	6a10                	ld	a2,16(a2)
ffffffffc0202b1a:	069a                	slli	a3,a3,0x6
ffffffffc0202b1c:	00c7d593          	srli	a1,a5,0xc
ffffffffc0202b20:	9536                	add	a0,a0,a3
ffffffffc0202b22:	9602                	jalr	a2
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202b24:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202b28:	b63d                	j	ffffffffc0202656 <pmm_init+0xe4>
        intr_disable();
ffffffffc0202b2a:	b1dfd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b2e:	000bb783          	ld	a5,0(s7)
ffffffffc0202b32:	779c                	ld	a5,40(a5)
ffffffffc0202b34:	9782                	jalr	a5
ffffffffc0202b36:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202b38:	b09fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202b3c:	bea5                	j	ffffffffc02026b4 <pmm_init+0x142>
        intr_disable();
ffffffffc0202b3e:	b09fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202b42:	000bb783          	ld	a5,0(s7)
ffffffffc0202b46:	779c                	ld	a5,40(a5)
ffffffffc0202b48:	9782                	jalr	a5
ffffffffc0202b4a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202b4c:	af5fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202b50:	b3cd                	j	ffffffffc0202932 <pmm_init+0x3c0>
        intr_disable();
ffffffffc0202b52:	af5fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202b56:	000bb783          	ld	a5,0(s7)
ffffffffc0202b5a:	779c                	ld	a5,40(a5)
ffffffffc0202b5c:	9782                	jalr	a5
ffffffffc0202b5e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202b60:	ae1fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202b64:	b36d                	j	ffffffffc020290e <pmm_init+0x39c>
ffffffffc0202b66:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202b68:	adffd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202b6c:	000bb783          	ld	a5,0(s7)
ffffffffc0202b70:	6522                	ld	a0,8(sp)
ffffffffc0202b72:	4585                	li	a1,1
ffffffffc0202b74:	739c                	ld	a5,32(a5)
ffffffffc0202b76:	9782                	jalr	a5
        intr_enable();
ffffffffc0202b78:	ac9fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202b7c:	bb8d                	j	ffffffffc02028ee <pmm_init+0x37c>
ffffffffc0202b7e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202b80:	ac7fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202b84:	000bb783          	ld	a5,0(s7)
ffffffffc0202b88:	6522                	ld	a0,8(sp)
ffffffffc0202b8a:	4585                	li	a1,1
ffffffffc0202b8c:	739c                	ld	a5,32(a5)
ffffffffc0202b8e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202b90:	ab1fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202b94:	b32d                	j	ffffffffc02028be <pmm_init+0x34c>
        intr_disable();
ffffffffc0202b96:	ab1fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b9a:	000bb783          	ld	a5,0(s7)
ffffffffc0202b9e:	779c                	ld	a5,40(a5)
ffffffffc0202ba0:	9782                	jalr	a5
ffffffffc0202ba2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202ba4:	a9dfd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202ba8:	b72d                	j	ffffffffc0202ad2 <pmm_init+0x560>
ffffffffc0202baa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202bac:	a9bfd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202bb0:	000bb783          	ld	a5,0(s7)
ffffffffc0202bb4:	6522                	ld	a0,8(sp)
ffffffffc0202bb6:	4585                	li	a1,1
ffffffffc0202bb8:	739c                	ld	a5,32(a5)
ffffffffc0202bba:	9782                	jalr	a5
        intr_enable();
ffffffffc0202bbc:	a85fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202bc0:	bdcd                	j	ffffffffc0202ab2 <pmm_init+0x540>
ffffffffc0202bc2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202bc4:	a83fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202bc8:	000bb783          	ld	a5,0(s7)
ffffffffc0202bcc:	6522                	ld	a0,8(sp)
ffffffffc0202bce:	4585                	li	a1,1
ffffffffc0202bd0:	739c                	ld	a5,32(a5)
ffffffffc0202bd2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202bd4:	a6dfd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202bd8:	b56d                	j	ffffffffc0202a82 <pmm_init+0x510>
        intr_disable();
ffffffffc0202bda:	a6dfd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
ffffffffc0202bde:	000bb783          	ld	a5,0(s7)
ffffffffc0202be2:	4585                	li	a1,1
ffffffffc0202be4:	8556                	mv	a0,s5
ffffffffc0202be6:	739c                	ld	a5,32(a5)
ffffffffc0202be8:	9782                	jalr	a5
        intr_enable();
ffffffffc0202bea:	a57fd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0202bee:	b59d                	j	ffffffffc0202a54 <pmm_init+0x4e2>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bf0:	00005697          	auipc	a3,0x5
ffffffffc0202bf4:	ca868693          	addi	a3,a3,-856 # ffffffffc0207898 <default_pmm_manager+0x560>
ffffffffc0202bf8:	00004617          	auipc	a2,0x4
ffffffffc0202bfc:	0a860613          	addi	a2,a2,168 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202c00:	22f00593          	li	a1,559
ffffffffc0202c04:	00005517          	auipc	a0,0x5
ffffffffc0202c08:	88450513          	addi	a0,a0,-1916 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c0c:	86ffd0ef          	jal	ra,ffffffffc020047a <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202c10:	00005697          	auipc	a3,0x5
ffffffffc0202c14:	c4868693          	addi	a3,a3,-952 # ffffffffc0207858 <default_pmm_manager+0x520>
ffffffffc0202c18:	00004617          	auipc	a2,0x4
ffffffffc0202c1c:	08860613          	addi	a2,a2,136 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202c20:	22e00593          	li	a1,558
ffffffffc0202c24:	00005517          	auipc	a0,0x5
ffffffffc0202c28:	86450513          	addi	a0,a0,-1948 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c2c:	84ffd0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0202c30:	86a2                	mv	a3,s0
ffffffffc0202c32:	00004617          	auipc	a2,0x4
ffffffffc0202c36:	73e60613          	addi	a2,a2,1854 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0202c3a:	22e00593          	li	a1,558
ffffffffc0202c3e:	00005517          	auipc	a0,0x5
ffffffffc0202c42:	84a50513          	addi	a0,a0,-1974 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c46:	835fd0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0202c4a:	854ff0ef          	jal	ra,ffffffffc0201c9e <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202c4e:	00004617          	auipc	a2,0x4
ffffffffc0202c52:	7ca60613          	addi	a2,a2,1994 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0202c56:	07f00593          	li	a1,127
ffffffffc0202c5a:	00005517          	auipc	a0,0x5
ffffffffc0202c5e:	82e50513          	addi	a0,a0,-2002 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c62:	819fd0ef          	jal	ra,ffffffffc020047a <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0202c66:	00004617          	auipc	a2,0x4
ffffffffc0202c6a:	7b260613          	addi	a2,a2,1970 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0202c6e:	0c100593          	li	a1,193
ffffffffc0202c72:	00005517          	auipc	a0,0x5
ffffffffc0202c76:	81650513          	addi	a0,a0,-2026 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c7a:	801fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0202c7e:	00005697          	auipc	a3,0x5
ffffffffc0202c82:	91268693          	addi	a3,a3,-1774 # ffffffffc0207590 <default_pmm_manager+0x258>
ffffffffc0202c86:	00004617          	auipc	a2,0x4
ffffffffc0202c8a:	01a60613          	addi	a2,a2,26 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202c8e:	1f200593          	li	a1,498
ffffffffc0202c92:	00004517          	auipc	a0,0x4
ffffffffc0202c96:	7f650513          	addi	a0,a0,2038 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202c9a:	fe0fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202c9e:	00005697          	auipc	a3,0x5
ffffffffc0202ca2:	8d268693          	addi	a3,a3,-1838 # ffffffffc0207570 <default_pmm_manager+0x238>
ffffffffc0202ca6:	00004617          	auipc	a2,0x4
ffffffffc0202caa:	ffa60613          	addi	a2,a2,-6 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202cae:	1f100593          	li	a1,497
ffffffffc0202cb2:	00004517          	auipc	a0,0x4
ffffffffc0202cb6:	7d650513          	addi	a0,a0,2006 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202cba:	fc0fd0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0202cbe:	ffdfe0ef          	jal	ra,ffffffffc0201cba <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0202cc2:	00005697          	auipc	a3,0x5
ffffffffc0202cc6:	95e68693          	addi	a3,a3,-1698 # ffffffffc0207620 <default_pmm_manager+0x2e8>
ffffffffc0202cca:	00004617          	auipc	a2,0x4
ffffffffc0202cce:	fd660613          	addi	a2,a2,-42 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202cd2:	1fa00593          	li	a1,506
ffffffffc0202cd6:	00004517          	auipc	a0,0x4
ffffffffc0202cda:	7b250513          	addi	a0,a0,1970 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202cde:	f9cfd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0202ce2:	00005697          	auipc	a3,0x5
ffffffffc0202ce6:	90e68693          	addi	a3,a3,-1778 # ffffffffc02075f0 <default_pmm_manager+0x2b8>
ffffffffc0202cea:	00004617          	auipc	a2,0x4
ffffffffc0202cee:	fb660613          	addi	a2,a2,-74 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202cf2:	1f700593          	li	a1,503
ffffffffc0202cf6:	00004517          	auipc	a0,0x4
ffffffffc0202cfa:	79250513          	addi	a0,a0,1938 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202cfe:	f7cfd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0202d02:	00005697          	auipc	a3,0x5
ffffffffc0202d06:	8c668693          	addi	a3,a3,-1850 # ffffffffc02075c8 <default_pmm_manager+0x290>
ffffffffc0202d0a:	00004617          	auipc	a2,0x4
ffffffffc0202d0e:	f9660613          	addi	a2,a2,-106 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202d12:	1f300593          	li	a1,499
ffffffffc0202d16:	00004517          	auipc	a0,0x4
ffffffffc0202d1a:	77250513          	addi	a0,a0,1906 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202d1e:	f5cfd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202d22:	00005697          	auipc	a3,0x5
ffffffffc0202d26:	98668693          	addi	a3,a3,-1658 # ffffffffc02076a8 <default_pmm_manager+0x370>
ffffffffc0202d2a:	00004617          	auipc	a2,0x4
ffffffffc0202d2e:	f7660613          	addi	a2,a2,-138 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202d32:	20300593          	li	a1,515
ffffffffc0202d36:	00004517          	auipc	a0,0x4
ffffffffc0202d3a:	75250513          	addi	a0,a0,1874 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202d3e:	f3cfd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202d42:	00005697          	auipc	a3,0x5
ffffffffc0202d46:	a0668693          	addi	a3,a3,-1530 # ffffffffc0207748 <default_pmm_manager+0x410>
ffffffffc0202d4a:	00004617          	auipc	a2,0x4
ffffffffc0202d4e:	f5660613          	addi	a2,a2,-170 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202d52:	20800593          	li	a1,520
ffffffffc0202d56:	00004517          	auipc	a0,0x4
ffffffffc0202d5a:	73250513          	addi	a0,a0,1842 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202d5e:	f1cfd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202d62:	00005697          	auipc	a3,0x5
ffffffffc0202d66:	91e68693          	addi	a3,a3,-1762 # ffffffffc0207680 <default_pmm_manager+0x348>
ffffffffc0202d6a:	00004617          	auipc	a2,0x4
ffffffffc0202d6e:	f3660613          	addi	a2,a2,-202 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202d72:	20000593          	li	a1,512
ffffffffc0202d76:	00004517          	auipc	a0,0x4
ffffffffc0202d7a:	71250513          	addi	a0,a0,1810 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202d7e:	efcfd0ef          	jal	ra,ffffffffc020047a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d82:	86d6                	mv	a3,s5
ffffffffc0202d84:	00004617          	auipc	a2,0x4
ffffffffc0202d88:	5ec60613          	addi	a2,a2,1516 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0202d8c:	1ff00593          	li	a1,511
ffffffffc0202d90:	00004517          	auipc	a0,0x4
ffffffffc0202d94:	6f850513          	addi	a0,a0,1784 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202d98:	ee2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0202d9c:	00005697          	auipc	a3,0x5
ffffffffc0202da0:	94468693          	addi	a3,a3,-1724 # ffffffffc02076e0 <default_pmm_manager+0x3a8>
ffffffffc0202da4:	00004617          	auipc	a2,0x4
ffffffffc0202da8:	efc60613          	addi	a2,a2,-260 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202dac:	20d00593          	li	a1,525
ffffffffc0202db0:	00004517          	auipc	a0,0x4
ffffffffc0202db4:	6d850513          	addi	a0,a0,1752 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202db8:	ec2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202dbc:	00005697          	auipc	a3,0x5
ffffffffc0202dc0:	9ec68693          	addi	a3,a3,-1556 # ffffffffc02077a8 <default_pmm_manager+0x470>
ffffffffc0202dc4:	00004617          	auipc	a2,0x4
ffffffffc0202dc8:	edc60613          	addi	a2,a2,-292 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202dcc:	20c00593          	li	a1,524
ffffffffc0202dd0:	00004517          	auipc	a0,0x4
ffffffffc0202dd4:	6b850513          	addi	a0,a0,1720 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202dd8:	ea2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202ddc:	00005697          	auipc	a3,0x5
ffffffffc0202de0:	9b468693          	addi	a3,a3,-1612 # ffffffffc0207790 <default_pmm_manager+0x458>
ffffffffc0202de4:	00004617          	auipc	a2,0x4
ffffffffc0202de8:	ebc60613          	addi	a2,a2,-324 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202dec:	20b00593          	li	a1,523
ffffffffc0202df0:	00004517          	auipc	a0,0x4
ffffffffc0202df4:	69850513          	addi	a0,a0,1688 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202df8:	e82fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0202dfc:	00005697          	auipc	a3,0x5
ffffffffc0202e00:	96468693          	addi	a3,a3,-1692 # ffffffffc0207760 <default_pmm_manager+0x428>
ffffffffc0202e04:	00004617          	auipc	a2,0x4
ffffffffc0202e08:	e9c60613          	addi	a2,a2,-356 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202e0c:	20a00593          	li	a1,522
ffffffffc0202e10:	00004517          	auipc	a0,0x4
ffffffffc0202e14:	67850513          	addi	a0,a0,1656 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202e18:	e62fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202e1c:	00005697          	auipc	a3,0x5
ffffffffc0202e20:	afc68693          	addi	a3,a3,-1284 # ffffffffc0207918 <default_pmm_manager+0x5e0>
ffffffffc0202e24:	00004617          	auipc	a2,0x4
ffffffffc0202e28:	e7c60613          	addi	a2,a2,-388 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202e2c:	23900593          	li	a1,569
ffffffffc0202e30:	00004517          	auipc	a0,0x4
ffffffffc0202e34:	65850513          	addi	a0,a0,1624 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202e38:	e42fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0202e3c:	00005697          	auipc	a3,0x5
ffffffffc0202e40:	8f468693          	addi	a3,a3,-1804 # ffffffffc0207730 <default_pmm_manager+0x3f8>
ffffffffc0202e44:	00004617          	auipc	a2,0x4
ffffffffc0202e48:	e5c60613          	addi	a2,a2,-420 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202e4c:	20700593          	li	a1,519
ffffffffc0202e50:	00004517          	auipc	a0,0x4
ffffffffc0202e54:	63850513          	addi	a0,a0,1592 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202e58:	e22fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202e5c:	00005697          	auipc	a3,0x5
ffffffffc0202e60:	8c468693          	addi	a3,a3,-1852 # ffffffffc0207720 <default_pmm_manager+0x3e8>
ffffffffc0202e64:	00004617          	auipc	a2,0x4
ffffffffc0202e68:	e3c60613          	addi	a2,a2,-452 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202e6c:	20600593          	li	a1,518
ffffffffc0202e70:	00004517          	auipc	a0,0x4
ffffffffc0202e74:	61850513          	addi	a0,a0,1560 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202e78:	e02fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0202e7c:	00005697          	auipc	a3,0x5
ffffffffc0202e80:	99c68693          	addi	a3,a3,-1636 # ffffffffc0207818 <default_pmm_manager+0x4e0>
ffffffffc0202e84:	00004617          	auipc	a2,0x4
ffffffffc0202e88:	e1c60613          	addi	a2,a2,-484 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202e8c:	24a00593          	li	a1,586
ffffffffc0202e90:	00004517          	auipc	a0,0x4
ffffffffc0202e94:	5f850513          	addi	a0,a0,1528 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202e98:	de2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202e9c:	00005697          	auipc	a3,0x5
ffffffffc0202ea0:	87468693          	addi	a3,a3,-1932 # ffffffffc0207710 <default_pmm_manager+0x3d8>
ffffffffc0202ea4:	00004617          	auipc	a2,0x4
ffffffffc0202ea8:	dfc60613          	addi	a2,a2,-516 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202eac:	20500593          	li	a1,517
ffffffffc0202eb0:	00004517          	auipc	a0,0x4
ffffffffc0202eb4:	5d850513          	addi	a0,a0,1496 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202eb8:	dc2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202ebc:	00004697          	auipc	a3,0x4
ffffffffc0202ec0:	7ac68693          	addi	a3,a3,1964 # ffffffffc0207668 <default_pmm_manager+0x330>
ffffffffc0202ec4:	00004617          	auipc	a2,0x4
ffffffffc0202ec8:	ddc60613          	addi	a2,a2,-548 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202ecc:	21200593          	li	a1,530
ffffffffc0202ed0:	00004517          	auipc	a0,0x4
ffffffffc0202ed4:	5b850513          	addi	a0,a0,1464 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202ed8:	da2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202edc:	00005697          	auipc	a3,0x5
ffffffffc0202ee0:	8e468693          	addi	a3,a3,-1820 # ffffffffc02077c0 <default_pmm_manager+0x488>
ffffffffc0202ee4:	00004617          	auipc	a2,0x4
ffffffffc0202ee8:	dbc60613          	addi	a2,a2,-580 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202eec:	20f00593          	li	a1,527
ffffffffc0202ef0:	00004517          	auipc	a0,0x4
ffffffffc0202ef4:	59850513          	addi	a0,a0,1432 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202ef8:	d82fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202efc:	00004697          	auipc	a3,0x4
ffffffffc0202f00:	75468693          	addi	a3,a3,1876 # ffffffffc0207650 <default_pmm_manager+0x318>
ffffffffc0202f04:	00004617          	auipc	a2,0x4
ffffffffc0202f08:	d9c60613          	addi	a2,a2,-612 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202f0c:	20e00593          	li	a1,526
ffffffffc0202f10:	00004517          	auipc	a0,0x4
ffffffffc0202f14:	57850513          	addi	a0,a0,1400 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202f18:	d62fd0ef          	jal	ra,ffffffffc020047a <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f1c:	00004617          	auipc	a2,0x4
ffffffffc0202f20:	45460613          	addi	a2,a2,1108 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0202f24:	06900593          	li	a1,105
ffffffffc0202f28:	00004517          	auipc	a0,0x4
ffffffffc0202f2c:	47050513          	addi	a0,a0,1136 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0202f30:	d4afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202f34:	00005697          	auipc	a3,0x5
ffffffffc0202f38:	8bc68693          	addi	a3,a3,-1860 # ffffffffc02077f0 <default_pmm_manager+0x4b8>
ffffffffc0202f3c:	00004617          	auipc	a2,0x4
ffffffffc0202f40:	d6460613          	addi	a2,a2,-668 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202f44:	21900593          	li	a1,537
ffffffffc0202f48:	00004517          	auipc	a0,0x4
ffffffffc0202f4c:	54050513          	addi	a0,a0,1344 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202f50:	d2afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f54:	00005697          	auipc	a3,0x5
ffffffffc0202f58:	85468693          	addi	a3,a3,-1964 # ffffffffc02077a8 <default_pmm_manager+0x470>
ffffffffc0202f5c:	00004617          	auipc	a2,0x4
ffffffffc0202f60:	d4460613          	addi	a2,a2,-700 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202f64:	21700593          	li	a1,535
ffffffffc0202f68:	00004517          	auipc	a0,0x4
ffffffffc0202f6c:	52050513          	addi	a0,a0,1312 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202f70:	d0afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f74:	00005697          	auipc	a3,0x5
ffffffffc0202f78:	86468693          	addi	a3,a3,-1948 # ffffffffc02077d8 <default_pmm_manager+0x4a0>
ffffffffc0202f7c:	00004617          	auipc	a2,0x4
ffffffffc0202f80:	d2460613          	addi	a2,a2,-732 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202f84:	21600593          	li	a1,534
ffffffffc0202f88:	00004517          	auipc	a0,0x4
ffffffffc0202f8c:	50050513          	addi	a0,a0,1280 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202f90:	ceafd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f94:	00005697          	auipc	a3,0x5
ffffffffc0202f98:	81468693          	addi	a3,a3,-2028 # ffffffffc02077a8 <default_pmm_manager+0x470>
ffffffffc0202f9c:	00004617          	auipc	a2,0x4
ffffffffc0202fa0:	d0460613          	addi	a2,a2,-764 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202fa4:	21300593          	li	a1,531
ffffffffc0202fa8:	00004517          	auipc	a0,0x4
ffffffffc0202fac:	4e050513          	addi	a0,a0,1248 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202fb0:	ccafd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fb4:	00005697          	auipc	a3,0x5
ffffffffc0202fb8:	94c68693          	addi	a3,a3,-1716 # ffffffffc0207900 <default_pmm_manager+0x5c8>
ffffffffc0202fbc:	00004617          	auipc	a2,0x4
ffffffffc0202fc0:	ce460613          	addi	a2,a2,-796 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202fc4:	23800593          	li	a1,568
ffffffffc0202fc8:	00004517          	auipc	a0,0x4
ffffffffc0202fcc:	4c050513          	addi	a0,a0,1216 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202fd0:	caafd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202fd4:	00005697          	auipc	a3,0x5
ffffffffc0202fd8:	8f468693          	addi	a3,a3,-1804 # ffffffffc02078c8 <default_pmm_manager+0x590>
ffffffffc0202fdc:	00004617          	auipc	a2,0x4
ffffffffc0202fe0:	cc460613          	addi	a2,a2,-828 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0202fe4:	23700593          	li	a1,567
ffffffffc0202fe8:	00004517          	auipc	a0,0x4
ffffffffc0202fec:	4a050513          	addi	a0,a0,1184 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0202ff0:	c8afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0202ff4:	00005697          	auipc	a3,0x5
ffffffffc0202ff8:	8bc68693          	addi	a3,a3,-1860 # ffffffffc02078b0 <default_pmm_manager+0x578>
ffffffffc0202ffc:	00004617          	auipc	a2,0x4
ffffffffc0203000:	ca460613          	addi	a2,a2,-860 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203004:	23300593          	li	a1,563
ffffffffc0203008:	00004517          	auipc	a0,0x4
ffffffffc020300c:	48050513          	addi	a0,a0,1152 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203010:	c6afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203014:	00005697          	auipc	a3,0x5
ffffffffc0203018:	80468693          	addi	a3,a3,-2044 # ffffffffc0207818 <default_pmm_manager+0x4e0>
ffffffffc020301c:	00004617          	auipc	a2,0x4
ffffffffc0203020:	c8460613          	addi	a2,a2,-892 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203024:	22100593          	li	a1,545
ffffffffc0203028:	00004517          	auipc	a0,0x4
ffffffffc020302c:	46050513          	addi	a0,a0,1120 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203030:	c4afd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203034:	00004697          	auipc	a3,0x4
ffffffffc0203038:	61c68693          	addi	a3,a3,1564 # ffffffffc0207650 <default_pmm_manager+0x318>
ffffffffc020303c:	00004617          	auipc	a2,0x4
ffffffffc0203040:	c6460613          	addi	a2,a2,-924 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203044:	1fb00593          	li	a1,507
ffffffffc0203048:	00004517          	auipc	a0,0x4
ffffffffc020304c:	44050513          	addi	a0,a0,1088 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203050:	c2afd0ef          	jal	ra,ffffffffc020047a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203054:	00004617          	auipc	a2,0x4
ffffffffc0203058:	31c60613          	addi	a2,a2,796 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc020305c:	1fe00593          	li	a1,510
ffffffffc0203060:	00004517          	auipc	a0,0x4
ffffffffc0203064:	42850513          	addi	a0,a0,1064 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203068:	c12fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020306c:	00004697          	auipc	a3,0x4
ffffffffc0203070:	5fc68693          	addi	a3,a3,1532 # ffffffffc0207668 <default_pmm_manager+0x330>
ffffffffc0203074:	00004617          	auipc	a2,0x4
ffffffffc0203078:	c2c60613          	addi	a2,a2,-980 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020307c:	1fc00593          	li	a1,508
ffffffffc0203080:	00004517          	auipc	a0,0x4
ffffffffc0203084:	40850513          	addi	a0,a0,1032 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203088:	bf2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020308c:	00004697          	auipc	a3,0x4
ffffffffc0203090:	65468693          	addi	a3,a3,1620 # ffffffffc02076e0 <default_pmm_manager+0x3a8>
ffffffffc0203094:	00004617          	auipc	a2,0x4
ffffffffc0203098:	c0c60613          	addi	a2,a2,-1012 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020309c:	20400593          	li	a1,516
ffffffffc02030a0:	00004517          	auipc	a0,0x4
ffffffffc02030a4:	3e850513          	addi	a0,a0,1000 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02030a8:	bd2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02030ac:	00005697          	auipc	a3,0x5
ffffffffc02030b0:	91468693          	addi	a3,a3,-1772 # ffffffffc02079c0 <default_pmm_manager+0x688>
ffffffffc02030b4:	00004617          	auipc	a2,0x4
ffffffffc02030b8:	bec60613          	addi	a2,a2,-1044 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02030bc:	24100593          	li	a1,577
ffffffffc02030c0:	00004517          	auipc	a0,0x4
ffffffffc02030c4:	3c850513          	addi	a0,a0,968 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02030c8:	bb2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02030cc:	00005697          	auipc	a3,0x5
ffffffffc02030d0:	8bc68693          	addi	a3,a3,-1860 # ffffffffc0207988 <default_pmm_manager+0x650>
ffffffffc02030d4:	00004617          	auipc	a2,0x4
ffffffffc02030d8:	bcc60613          	addi	a2,a2,-1076 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02030dc:	23e00593          	li	a1,574
ffffffffc02030e0:	00004517          	auipc	a0,0x4
ffffffffc02030e4:	3a850513          	addi	a0,a0,936 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02030e8:	b92fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(page_ref(p) == 2);
ffffffffc02030ec:	00005697          	auipc	a3,0x5
ffffffffc02030f0:	86c68693          	addi	a3,a3,-1940 # ffffffffc0207958 <default_pmm_manager+0x620>
ffffffffc02030f4:	00004617          	auipc	a2,0x4
ffffffffc02030f8:	bac60613          	addi	a2,a2,-1108 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02030fc:	23a00593          	li	a1,570
ffffffffc0203100:	00004517          	auipc	a0,0x4
ffffffffc0203104:	38850513          	addi	a0,a0,904 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203108:	b72fd0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020310c <copy_range>:
               bool share) {               
ffffffffc020310c:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);//确保 start 和 end 都是页对齐的
ffffffffc020310e:	00d667b3          	or	a5,a2,a3
               bool share) {               
ffffffffc0203112:	f486                	sd	ra,104(sp)
ffffffffc0203114:	f0a2                	sd	s0,96(sp)
ffffffffc0203116:	eca6                	sd	s1,88(sp)
ffffffffc0203118:	e8ca                	sd	s2,80(sp)
ffffffffc020311a:	e4ce                	sd	s3,72(sp)
ffffffffc020311c:	e0d2                	sd	s4,64(sp)
ffffffffc020311e:	fc56                	sd	s5,56(sp)
ffffffffc0203120:	f85a                	sd	s6,48(sp)
ffffffffc0203122:	f45e                	sd	s7,40(sp)
ffffffffc0203124:	f062                	sd	s8,32(sp)
ffffffffc0203126:	ec66                	sd	s9,24(sp)
ffffffffc0203128:	e86a                	sd	s10,16(sp)
ffffffffc020312a:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);//确保 start 和 end 都是页对齐的
ffffffffc020312c:	17d2                	slli	a5,a5,0x34
ffffffffc020312e:	1e079763          	bnez	a5,ffffffffc020331c <copy_range+0x210>
    assert(USER_ACCESS(start, end));
ffffffffc0203132:	002007b7          	lui	a5,0x200
ffffffffc0203136:	8432                	mv	s0,a2
ffffffffc0203138:	16f66a63          	bltu	a2,a5,ffffffffc02032ac <copy_range+0x1a0>
ffffffffc020313c:	8936                	mv	s2,a3
ffffffffc020313e:	16d67763          	bgeu	a2,a3,ffffffffc02032ac <copy_range+0x1a0>
ffffffffc0203142:	4785                	li	a5,1
ffffffffc0203144:	07fe                	slli	a5,a5,0x1f
ffffffffc0203146:	16d7e363          	bltu	a5,a3,ffffffffc02032ac <copy_range+0x1a0>
ffffffffc020314a:	5b7d                	li	s6,-1
ffffffffc020314c:	8aaa                	mv	s5,a0
ffffffffc020314e:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0203150:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc0203152:	000afc97          	auipc	s9,0xaf
ffffffffc0203156:	6aec8c93          	addi	s9,s9,1710 # ffffffffc02b2800 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020315a:	000afc17          	auipc	s8,0xaf
ffffffffc020315e:	6aec0c13          	addi	s8,s8,1710 # ffffffffc02b2808 <pages>
    return page - pages + nbase;
ffffffffc0203162:	00080bb7          	lui	s7,0x80
    return KADDR(page2pa(page));
ffffffffc0203166:	00cb5b13          	srli	s6,s6,0xc
        pte_t *ptep = get_pte(from, start, 0), *nptep;//获取源进程 from 在 start 地址的页表项
ffffffffc020316a:	4601                	li	a2,0
ffffffffc020316c:	85a2                	mv	a1,s0
ffffffffc020316e:	854e                	mv	a0,s3
ffffffffc0203170:	c73fe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0203174:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc0203176:	c175                	beqz	a0,ffffffffc020325a <copy_range+0x14e>
        if (*ptep & PTE_V) {//指向的页表项有效
ffffffffc0203178:	611c                	ld	a5,0(a0)
ffffffffc020317a:	8b85                	andi	a5,a5,1
ffffffffc020317c:	e785                	bnez	a5,ffffffffc02031a4 <copy_range+0x98>
        start += PGSIZE;
ffffffffc020317e:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203180:	ff2465e3          	bltu	s0,s2,ffffffffc020316a <copy_range+0x5e>
    return 0;
ffffffffc0203184:	4501                	li	a0,0
}
ffffffffc0203186:	70a6                	ld	ra,104(sp)
ffffffffc0203188:	7406                	ld	s0,96(sp)
ffffffffc020318a:	64e6                	ld	s1,88(sp)
ffffffffc020318c:	6946                	ld	s2,80(sp)
ffffffffc020318e:	69a6                	ld	s3,72(sp)
ffffffffc0203190:	6a06                	ld	s4,64(sp)
ffffffffc0203192:	7ae2                	ld	s5,56(sp)
ffffffffc0203194:	7b42                	ld	s6,48(sp)
ffffffffc0203196:	7ba2                	ld	s7,40(sp)
ffffffffc0203198:	7c02                	ld	s8,32(sp)
ffffffffc020319a:	6ce2                	ld	s9,24(sp)
ffffffffc020319c:	6d42                	ld	s10,16(sp)
ffffffffc020319e:	6da2                	ld	s11,8(sp)
ffffffffc02031a0:	6165                	addi	sp,sp,112
ffffffffc02031a2:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL) {
ffffffffc02031a4:	4605                	li	a2,1
ffffffffc02031a6:	85a2                	mv	a1,s0
ffffffffc02031a8:	8556                	mv	a0,s5
ffffffffc02031aa:	c39fe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc02031ae:	c161                	beqz	a0,ffffffffc020326e <copy_range+0x162>
            uint32_t perm = (*ptep & PTE_USER);//获取源页表项的权限标志：可供用户空间访问
ffffffffc02031b0:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V)) {
ffffffffc02031b2:	0017f713          	andi	a4,a5,1
ffffffffc02031b6:	01f7f493          	andi	s1,a5,31
ffffffffc02031ba:	14070563          	beqz	a4,ffffffffc0203304 <copy_range+0x1f8>
    if (PPN(pa) >= npage) {
ffffffffc02031be:	000cb683          	ld	a3,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02031c2:	078a                	slli	a5,a5,0x2
ffffffffc02031c4:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02031c8:	12d77263          	bgeu	a4,a3,ffffffffc02032ec <copy_range+0x1e0>
    return &pages[PPN(pa) - nbase];
ffffffffc02031cc:	000c3783          	ld	a5,0(s8)
ffffffffc02031d0:	fff806b7          	lui	a3,0xfff80
ffffffffc02031d4:	9736                	add	a4,a4,a3
ffffffffc02031d6:	071a                	slli	a4,a4,0x6
            struct Page *npage = alloc_page();//为目标进程分配一个新的页面
ffffffffc02031d8:	4505                	li	a0,1
ffffffffc02031da:	00e78db3          	add	s11,a5,a4
ffffffffc02031de:	af9fe0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc02031e2:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc02031e4:	0a0d8463          	beqz	s11,ffffffffc020328c <copy_range+0x180>
            assert(npage != NULL);
ffffffffc02031e8:	c175                	beqz	a0,ffffffffc02032cc <copy_range+0x1c0>
    return page - pages + nbase;
ffffffffc02031ea:	000c3703          	ld	a4,0(s8)
    return KADDR(page2pa(page));
ffffffffc02031ee:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc02031f2:	40ed86b3          	sub	a3,s11,a4
ffffffffc02031f6:	8699                	srai	a3,a3,0x6
ffffffffc02031f8:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc02031fa:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02031fe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203200:	06c7fa63          	bgeu	a5,a2,ffffffffc0203274 <copy_range+0x168>
    return page - pages + nbase;
ffffffffc0203204:	40e507b3          	sub	a5,a0,a4
    return KADDR(page2pa(page));
ffffffffc0203208:	000af717          	auipc	a4,0xaf
ffffffffc020320c:	61070713          	addi	a4,a4,1552 # ffffffffc02b2818 <va_pa_offset>
ffffffffc0203210:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203212:	8799                	srai	a5,a5,0x6
ffffffffc0203214:	97de                	add	a5,a5,s7
    return KADDR(page2pa(page));
ffffffffc0203216:	0167f733          	and	a4,a5,s6
ffffffffc020321a:	96aa                	add	a3,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020321c:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020321e:	04c77a63          	bgeu	a4,a2,ffffffffc0203272 <copy_range+0x166>
            memcpy(dst_kvaddr, *src_kvaddr, PGSIZE);//将源页面的内容复制到目标页面
ffffffffc0203222:	628c                	ld	a1,0(a3)
ffffffffc0203224:	6605                	lui	a2,0x1
ffffffffc0203226:	953e                	add	a0,a0,a5
ffffffffc0203228:	3a6030ef          	jal	ra,ffffffffc02065ce <memcpy>
            ret = page_insert(to, npage, start, perm);//将目标页的物理地址与目标进程的线性地址（start）映射
ffffffffc020322c:	86a6                	mv	a3,s1
ffffffffc020322e:	8622                	mv	a2,s0
ffffffffc0203230:	85ea                	mv	a1,s10
ffffffffc0203232:	8556                	mv	a0,s5
ffffffffc0203234:	a48ff0ef          	jal	ra,ffffffffc020247c <page_insert>
            assert(ret == 0);
ffffffffc0203238:	d139                	beqz	a0,ffffffffc020317e <copy_range+0x72>
ffffffffc020323a:	00004697          	auipc	a3,0x4
ffffffffc020323e:	7ee68693          	addi	a3,a3,2030 # ffffffffc0207a28 <default_pmm_manager+0x6f0>
ffffffffc0203242:	00004617          	auipc	a2,0x4
ffffffffc0203246:	a5e60613          	addi	a2,a2,-1442 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020324a:	19300593          	li	a1,403
ffffffffc020324e:	00004517          	auipc	a0,0x4
ffffffffc0203252:	23a50513          	addi	a0,a0,570 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203256:	a24fd0ef          	jal	ra,ffffffffc020047a <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);//继续检查下一个地址区域
ffffffffc020325a:	00200637          	lui	a2,0x200
ffffffffc020325e:	9432                	add	s0,s0,a2
ffffffffc0203260:	ffe00637          	lui	a2,0xffe00
ffffffffc0203264:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc0203266:	dc19                	beqz	s0,ffffffffc0203184 <copy_range+0x78>
ffffffffc0203268:	f12461e3          	bltu	s0,s2,ffffffffc020316a <copy_range+0x5e>
ffffffffc020326c:	bf21                	j	ffffffffc0203184 <copy_range+0x78>
                return -E_NO_MEM;
ffffffffc020326e:	5571                	li	a0,-4
ffffffffc0203270:	bf19                	j	ffffffffc0203186 <copy_range+0x7a>
ffffffffc0203272:	86be                	mv	a3,a5
ffffffffc0203274:	00004617          	auipc	a2,0x4
ffffffffc0203278:	0fc60613          	addi	a2,a2,252 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc020327c:	06900593          	li	a1,105
ffffffffc0203280:	00004517          	auipc	a0,0x4
ffffffffc0203284:	11850513          	addi	a0,a0,280 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0203288:	9f2fd0ef          	jal	ra,ffffffffc020047a <__panic>
            assert(page != NULL);
ffffffffc020328c:	00004697          	auipc	a3,0x4
ffffffffc0203290:	77c68693          	addi	a3,a3,1916 # ffffffffc0207a08 <default_pmm_manager+0x6d0>
ffffffffc0203294:	00004617          	auipc	a2,0x4
ffffffffc0203298:	a0c60613          	addi	a2,a2,-1524 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020329c:	17900593          	li	a1,377
ffffffffc02032a0:	00004517          	auipc	a0,0x4
ffffffffc02032a4:	1e850513          	addi	a0,a0,488 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02032a8:	9d2fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02032ac:	00004697          	auipc	a3,0x4
ffffffffc02032b0:	21c68693          	addi	a3,a3,540 # ffffffffc02074c8 <default_pmm_manager+0x190>
ffffffffc02032b4:	00004617          	auipc	a2,0x4
ffffffffc02032b8:	9ec60613          	addi	a2,a2,-1556 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02032bc:	16400593          	li	a1,356
ffffffffc02032c0:	00004517          	auipc	a0,0x4
ffffffffc02032c4:	1c850513          	addi	a0,a0,456 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02032c8:	9b2fd0ef          	jal	ra,ffffffffc020047a <__panic>
            assert(npage != NULL);
ffffffffc02032cc:	00004697          	auipc	a3,0x4
ffffffffc02032d0:	74c68693          	addi	a3,a3,1868 # ffffffffc0207a18 <default_pmm_manager+0x6e0>
ffffffffc02032d4:	00004617          	auipc	a2,0x4
ffffffffc02032d8:	9cc60613          	addi	a2,a2,-1588 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02032dc:	17a00593          	li	a1,378
ffffffffc02032e0:	00004517          	auipc	a0,0x4
ffffffffc02032e4:	1a850513          	addi	a0,a0,424 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02032e8:	992fd0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02032ec:	00004617          	auipc	a2,0x4
ffffffffc02032f0:	15460613          	addi	a2,a2,340 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc02032f4:	06200593          	li	a1,98
ffffffffc02032f8:	00004517          	auipc	a0,0x4
ffffffffc02032fc:	0a050513          	addi	a0,a0,160 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0203300:	97afd0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203304:	00004617          	auipc	a2,0x4
ffffffffc0203308:	15c60613          	addi	a2,a2,348 # ffffffffc0207460 <default_pmm_manager+0x128>
ffffffffc020330c:	07400593          	li	a1,116
ffffffffc0203310:	00004517          	auipc	a0,0x4
ffffffffc0203314:	08850513          	addi	a0,a0,136 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0203318:	962fd0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);//确保 start 和 end 都是页对齐的
ffffffffc020331c:	00004697          	auipc	a3,0x4
ffffffffc0203320:	17c68693          	addi	a3,a3,380 # ffffffffc0207498 <default_pmm_manager+0x160>
ffffffffc0203324:	00004617          	auipc	a2,0x4
ffffffffc0203328:	97c60613          	addi	a2,a2,-1668 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020332c:	16300593          	li	a1,355
ffffffffc0203330:	00004517          	auipc	a0,0x4
ffffffffc0203334:	15850513          	addi	a0,a0,344 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc0203338:	942fd0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020333c <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020333c:	12058073          	sfence.vma	a1
}
ffffffffc0203340:	8082                	ret

ffffffffc0203342 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203342:	7179                	addi	sp,sp,-48
ffffffffc0203344:	e84a                	sd	s2,16(sp)
ffffffffc0203346:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0203348:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc020334a:	f022                	sd	s0,32(sp)
ffffffffc020334c:	ec26                	sd	s1,24(sp)
ffffffffc020334e:	e44e                	sd	s3,8(sp)
ffffffffc0203350:	f406                	sd	ra,40(sp)
ffffffffc0203352:	84ae                	mv	s1,a1
ffffffffc0203354:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0203356:	981fe0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc020335a:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc020335c:	cd05                	beqz	a0,ffffffffc0203394 <pgdir_alloc_page+0x52>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc020335e:	85aa                	mv	a1,a0
ffffffffc0203360:	86ce                	mv	a3,s3
ffffffffc0203362:	8626                	mv	a2,s1
ffffffffc0203364:	854a                	mv	a0,s2
ffffffffc0203366:	916ff0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc020336a:	ed0d                	bnez	a0,ffffffffc02033a4 <pgdir_alloc_page+0x62>
        if (swap_init_ok) {
ffffffffc020336c:	000af797          	auipc	a5,0xaf
ffffffffc0203370:	4c47a783          	lw	a5,1220(a5) # ffffffffc02b2830 <swap_init_ok>
ffffffffc0203374:	c385                	beqz	a5,ffffffffc0203394 <pgdir_alloc_page+0x52>
            if (check_mm_struct != NULL) {
ffffffffc0203376:	000af517          	auipc	a0,0xaf
ffffffffc020337a:	4c253503          	ld	a0,1218(a0) # ffffffffc02b2838 <check_mm_struct>
ffffffffc020337e:	c919                	beqz	a0,ffffffffc0203394 <pgdir_alloc_page+0x52>
                swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0203380:	4681                	li	a3,0
ffffffffc0203382:	8622                	mv	a2,s0
ffffffffc0203384:	85a6                	mv	a1,s1
ffffffffc0203386:	7e4000ef          	jal	ra,ffffffffc0203b6a <swap_map_swappable>
                assert(page_ref(page) == 1);
ffffffffc020338a:	4018                	lw	a4,0(s0)
                page->pra_vaddr = la;
ffffffffc020338c:	fc04                	sd	s1,56(s0)
                assert(page_ref(page) == 1);
ffffffffc020338e:	4785                	li	a5,1
ffffffffc0203390:	04f71663          	bne	a4,a5,ffffffffc02033dc <pgdir_alloc_page+0x9a>
}
ffffffffc0203394:	70a2                	ld	ra,40(sp)
ffffffffc0203396:	8522                	mv	a0,s0
ffffffffc0203398:	7402                	ld	s0,32(sp)
ffffffffc020339a:	64e2                	ld	s1,24(sp)
ffffffffc020339c:	6942                	ld	s2,16(sp)
ffffffffc020339e:	69a2                	ld	s3,8(sp)
ffffffffc02033a0:	6145                	addi	sp,sp,48
ffffffffc02033a2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02033a4:	100027f3          	csrr	a5,sstatus
ffffffffc02033a8:	8b89                	andi	a5,a5,2
ffffffffc02033aa:	eb99                	bnez	a5,ffffffffc02033c0 <pgdir_alloc_page+0x7e>
        pmm_manager->free_pages(base, n);
ffffffffc02033ac:	000af797          	auipc	a5,0xaf
ffffffffc02033b0:	4647b783          	ld	a5,1124(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc02033b4:	739c                	ld	a5,32(a5)
ffffffffc02033b6:	8522                	mv	a0,s0
ffffffffc02033b8:	4585                	li	a1,1
ffffffffc02033ba:	9782                	jalr	a5
            return NULL;
ffffffffc02033bc:	4401                	li	s0,0
ffffffffc02033be:	bfd9                	j	ffffffffc0203394 <pgdir_alloc_page+0x52>
        intr_disable();
ffffffffc02033c0:	a86fd0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02033c4:	000af797          	auipc	a5,0xaf
ffffffffc02033c8:	44c7b783          	ld	a5,1100(a5) # ffffffffc02b2810 <pmm_manager>
ffffffffc02033cc:	739c                	ld	a5,32(a5)
ffffffffc02033ce:	8522                	mv	a0,s0
ffffffffc02033d0:	4585                	li	a1,1
ffffffffc02033d2:	9782                	jalr	a5
            return NULL;
ffffffffc02033d4:	4401                	li	s0,0
        intr_enable();
ffffffffc02033d6:	a6afd0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc02033da:	bf6d                	j	ffffffffc0203394 <pgdir_alloc_page+0x52>
                assert(page_ref(page) == 1);
ffffffffc02033dc:	00004697          	auipc	a3,0x4
ffffffffc02033e0:	65c68693          	addi	a3,a3,1628 # ffffffffc0207a38 <default_pmm_manager+0x700>
ffffffffc02033e4:	00004617          	auipc	a2,0x4
ffffffffc02033e8:	8bc60613          	addi	a2,a2,-1860 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02033ec:	1d200593          	li	a1,466
ffffffffc02033f0:	00004517          	auipc	a0,0x4
ffffffffc02033f4:	09850513          	addi	a0,a0,152 # ffffffffc0207488 <default_pmm_manager+0x150>
ffffffffc02033f8:	882fd0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02033fc <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc02033fc:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02033fe:	00004617          	auipc	a2,0x4
ffffffffc0203402:	04260613          	addi	a2,a2,66 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc0203406:	06200593          	li	a1,98
ffffffffc020340a:	00004517          	auipc	a0,0x4
ffffffffc020340e:	f8e50513          	addi	a0,a0,-114 # ffffffffc0207398 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0203412:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0203414:	866fd0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0203418 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc0203418:	7135                	addi	sp,sp,-160
ffffffffc020341a:	ed06                	sd	ra,152(sp)
ffffffffc020341c:	e922                	sd	s0,144(sp)
ffffffffc020341e:	e526                	sd	s1,136(sp)
ffffffffc0203420:	e14a                	sd	s2,128(sp)
ffffffffc0203422:	fcce                	sd	s3,120(sp)
ffffffffc0203424:	f8d2                	sd	s4,112(sp)
ffffffffc0203426:	f4d6                	sd	s5,104(sp)
ffffffffc0203428:	f0da                	sd	s6,96(sp)
ffffffffc020342a:	ecde                	sd	s7,88(sp)
ffffffffc020342c:	e8e2                	sd	s8,80(sp)
ffffffffc020342e:	e4e6                	sd	s9,72(sp)
ffffffffc0203430:	e0ea                	sd	s10,64(sp)
ffffffffc0203432:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc0203434:	752010ef          	jal	ra,ffffffffc0204b86 <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0203438:	000af697          	auipc	a3,0xaf
ffffffffc020343c:	3e86b683          	ld	a3,1000(a3) # ffffffffc02b2820 <max_swap_offset>
ffffffffc0203440:	010007b7          	lui	a5,0x1000
ffffffffc0203444:	ff968713          	addi	a4,a3,-7
ffffffffc0203448:	17e1                	addi	a5,a5,-8
ffffffffc020344a:	42e7e663          	bltu	a5,a4,ffffffffc0203876 <swap_init+0x45e>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }
     

     sm = &swap_manager_fifo;
ffffffffc020344e:	000a4797          	auipc	a5,0xa4
ffffffffc0203452:	e6a78793          	addi	a5,a5,-406 # ffffffffc02a72b8 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0203456:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc0203458:	000afb97          	auipc	s7,0xaf
ffffffffc020345c:	3d0b8b93          	addi	s7,s7,976 # ffffffffc02b2828 <sm>
ffffffffc0203460:	00fbb023          	sd	a5,0(s7)
     int r = sm->init();
ffffffffc0203464:	9702                	jalr	a4
ffffffffc0203466:	892a                	mv	s2,a0
     
     if (r == 0)
ffffffffc0203468:	c10d                	beqz	a0,ffffffffc020348a <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020346a:	60ea                	ld	ra,152(sp)
ffffffffc020346c:	644a                	ld	s0,144(sp)
ffffffffc020346e:	64aa                	ld	s1,136(sp)
ffffffffc0203470:	79e6                	ld	s3,120(sp)
ffffffffc0203472:	7a46                	ld	s4,112(sp)
ffffffffc0203474:	7aa6                	ld	s5,104(sp)
ffffffffc0203476:	7b06                	ld	s6,96(sp)
ffffffffc0203478:	6be6                	ld	s7,88(sp)
ffffffffc020347a:	6c46                	ld	s8,80(sp)
ffffffffc020347c:	6ca6                	ld	s9,72(sp)
ffffffffc020347e:	6d06                	ld	s10,64(sp)
ffffffffc0203480:	7de2                	ld	s11,56(sp)
ffffffffc0203482:	854a                	mv	a0,s2
ffffffffc0203484:	690a                	ld	s2,128(sp)
ffffffffc0203486:	610d                	addi	sp,sp,160
ffffffffc0203488:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020348a:	000bb783          	ld	a5,0(s7)
ffffffffc020348e:	00004517          	auipc	a0,0x4
ffffffffc0203492:	5f250513          	addi	a0,a0,1522 # ffffffffc0207a80 <default_pmm_manager+0x748>
    return listelm->next;
ffffffffc0203496:	000ab417          	auipc	s0,0xab
ffffffffc020349a:	27240413          	addi	s0,s0,626 # ffffffffc02ae708 <free_area>
ffffffffc020349e:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc02034a0:	4785                	li	a5,1
ffffffffc02034a2:	000af717          	auipc	a4,0xaf
ffffffffc02034a6:	38f72723          	sw	a5,910(a4) # ffffffffc02b2830 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02034aa:	cd7fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02034ae:	641c                	ld	a5,8(s0)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc02034b0:	4d01                	li	s10,0
ffffffffc02034b2:	4d81                	li	s11,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02034b4:	34878163          	beq	a5,s0,ffffffffc02037f6 <swap_init+0x3de>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02034b8:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02034bc:	8b09                	andi	a4,a4,2
ffffffffc02034be:	32070e63          	beqz	a4,ffffffffc02037fa <swap_init+0x3e2>
        count ++, total += p->property;
ffffffffc02034c2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02034c6:	679c                	ld	a5,8(a5)
ffffffffc02034c8:	2d85                	addiw	s11,s11,1
ffffffffc02034ca:	01a70d3b          	addw	s10,a4,s10
     while ((le = list_next(le)) != &free_list) {
ffffffffc02034ce:	fe8795e3          	bne	a5,s0,ffffffffc02034b8 <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc02034d2:	84ea                	mv	s1,s10
ffffffffc02034d4:	8d5fe0ef          	jal	ra,ffffffffc0201da8 <nr_free_pages>
ffffffffc02034d8:	42951763          	bne	a0,s1,ffffffffc0203906 <swap_init+0x4ee>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc02034dc:	866a                	mv	a2,s10
ffffffffc02034de:	85ee                	mv	a1,s11
ffffffffc02034e0:	00004517          	auipc	a0,0x4
ffffffffc02034e4:	5b850513          	addi	a0,a0,1464 # ffffffffc0207a98 <default_pmm_manager+0x760>
ffffffffc02034e8:	c99fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc02034ec:	42b000ef          	jal	ra,ffffffffc0204116 <mm_create>
ffffffffc02034f0:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc02034f2:	46050a63          	beqz	a0,ffffffffc0203966 <swap_init+0x54e>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc02034f6:	000af797          	auipc	a5,0xaf
ffffffffc02034fa:	34278793          	addi	a5,a5,834 # ffffffffc02b2838 <check_mm_struct>
ffffffffc02034fe:	6398                	ld	a4,0(a5)
ffffffffc0203500:	3e071363          	bnez	a4,ffffffffc02038e6 <swap_init+0x4ce>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0203504:	000af717          	auipc	a4,0xaf
ffffffffc0203508:	2f470713          	addi	a4,a4,756 # ffffffffc02b27f8 <boot_pgdir>
ffffffffc020350c:	00073b03          	ld	s6,0(a4)
     check_mm_struct = mm;
ffffffffc0203510:	e388                	sd	a0,0(a5)
     assert(pgdir[0] == 0);
ffffffffc0203512:	000b3783          	ld	a5,0(s6)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0203516:	01653c23          	sd	s6,24(a0)
     assert(pgdir[0] == 0);
ffffffffc020351a:	42079663          	bnez	a5,ffffffffc0203946 <swap_init+0x52e>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc020351e:	6599                	lui	a1,0x6
ffffffffc0203520:	460d                	li	a2,3
ffffffffc0203522:	6505                	lui	a0,0x1
ffffffffc0203524:	43b000ef          	jal	ra,ffffffffc020415e <vma_create>
ffffffffc0203528:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc020352a:	52050a63          	beqz	a0,ffffffffc0203a5e <swap_init+0x646>

     insert_vma_struct(mm, vma);
ffffffffc020352e:	8556                	mv	a0,s5
ffffffffc0203530:	49d000ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0203534:	00004517          	auipc	a0,0x4
ffffffffc0203538:	5d450513          	addi	a0,a0,1492 # ffffffffc0207b08 <default_pmm_manager+0x7d0>
ffffffffc020353c:	c45fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0203540:	018ab503          	ld	a0,24(s5)
ffffffffc0203544:	4605                	li	a2,1
ffffffffc0203546:	6585                	lui	a1,0x1
ffffffffc0203548:	89bfe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc020354c:	4c050963          	beqz	a0,ffffffffc0203a1e <swap_init+0x606>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0203550:	00004517          	auipc	a0,0x4
ffffffffc0203554:	60850513          	addi	a0,a0,1544 # ffffffffc0207b58 <default_pmm_manager+0x820>
ffffffffc0203558:	000ab497          	auipc	s1,0xab
ffffffffc020355c:	1e848493          	addi	s1,s1,488 # ffffffffc02ae740 <check_rp>
ffffffffc0203560:	c21fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203564:	000ab997          	auipc	s3,0xab
ffffffffc0203568:	1fc98993          	addi	s3,s3,508 # ffffffffc02ae760 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc020356c:	8a26                	mv	s4,s1
          check_rp[i] = alloc_page();
ffffffffc020356e:	4505                	li	a0,1
ffffffffc0203570:	f66fe0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0203574:	00aa3023          	sd	a0,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
          assert(check_rp[i] != NULL );
ffffffffc0203578:	2c050f63          	beqz	a0,ffffffffc0203856 <swap_init+0x43e>
ffffffffc020357c:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc020357e:	8b89                	andi	a5,a5,2
ffffffffc0203580:	34079363          	bnez	a5,ffffffffc02038c6 <swap_init+0x4ae>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203584:	0a21                	addi	s4,s4,8
ffffffffc0203586:	ff3a14e3          	bne	s4,s3,ffffffffc020356e <swap_init+0x156>
     }
     list_entry_t free_list_store = free_list;
ffffffffc020358a:	601c                	ld	a5,0(s0)
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
ffffffffc020358c:	000aba17          	auipc	s4,0xab
ffffffffc0203590:	1b4a0a13          	addi	s4,s4,436 # ffffffffc02ae740 <check_rp>
    elm->prev = elm->next = elm;
ffffffffc0203594:	e000                	sd	s0,0(s0)
     list_entry_t free_list_store = free_list;
ffffffffc0203596:	ec3e                	sd	a5,24(sp)
ffffffffc0203598:	641c                	ld	a5,8(s0)
ffffffffc020359a:	e400                	sd	s0,8(s0)
ffffffffc020359c:	f03e                	sd	a5,32(sp)
     unsigned int nr_free_store = nr_free;
ffffffffc020359e:	481c                	lw	a5,16(s0)
ffffffffc02035a0:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc02035a2:	000ab797          	auipc	a5,0xab
ffffffffc02035a6:	1607ab23          	sw	zero,374(a5) # ffffffffc02ae718 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc02035aa:	000a3503          	ld	a0,0(s4)
ffffffffc02035ae:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02035b0:	0a21                	addi	s4,s4,8
        free_pages(check_rp[i],1);
ffffffffc02035b2:	fb6fe0ef          	jal	ra,ffffffffc0201d68 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02035b6:	ff3a1ae3          	bne	s4,s3,ffffffffc02035aa <swap_init+0x192>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02035ba:	01042a03          	lw	s4,16(s0)
ffffffffc02035be:	4791                	li	a5,4
ffffffffc02035c0:	42fa1f63          	bne	s4,a5,ffffffffc02039fe <swap_init+0x5e6>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc02035c4:	00004517          	auipc	a0,0x4
ffffffffc02035c8:	61c50513          	addi	a0,a0,1564 # ffffffffc0207be0 <default_pmm_manager+0x8a8>
ffffffffc02035cc:	bb5fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02035d0:	6705                	lui	a4,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc02035d2:	000af797          	auipc	a5,0xaf
ffffffffc02035d6:	2607a723          	sw	zero,622(a5) # ffffffffc02b2840 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02035da:	4629                	li	a2,10
ffffffffc02035dc:	00c70023          	sb	a2,0(a4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
     assert(pgfault_num==1);
ffffffffc02035e0:	000af697          	auipc	a3,0xaf
ffffffffc02035e4:	2606a683          	lw	a3,608(a3) # ffffffffc02b2840 <pgfault_num>
ffffffffc02035e8:	4585                	li	a1,1
ffffffffc02035ea:	000af797          	auipc	a5,0xaf
ffffffffc02035ee:	25678793          	addi	a5,a5,598 # ffffffffc02b2840 <pgfault_num>
ffffffffc02035f2:	54b69663          	bne	a3,a1,ffffffffc0203b3e <swap_init+0x726>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc02035f6:	00c70823          	sb	a2,16(a4)
     assert(pgfault_num==1);
ffffffffc02035fa:	4398                	lw	a4,0(a5)
ffffffffc02035fc:	2701                	sext.w	a4,a4
ffffffffc02035fe:	3ed71063          	bne	a4,a3,ffffffffc02039de <swap_init+0x5c6>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203602:	6689                	lui	a3,0x2
ffffffffc0203604:	462d                	li	a2,11
ffffffffc0203606:	00c68023          	sb	a2,0(a3) # 2000 <_binary_obj___user_faultread_out_size-0x7bb0>
     assert(pgfault_num==2);
ffffffffc020360a:	4398                	lw	a4,0(a5)
ffffffffc020360c:	4589                	li	a1,2
ffffffffc020360e:	2701                	sext.w	a4,a4
ffffffffc0203610:	4ab71763          	bne	a4,a1,ffffffffc0203abe <swap_init+0x6a6>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0203614:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==2);
ffffffffc0203618:	4394                	lw	a3,0(a5)
ffffffffc020361a:	2681                	sext.w	a3,a3
ffffffffc020361c:	4ce69163          	bne	a3,a4,ffffffffc0203ade <swap_init+0x6c6>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0203620:	668d                	lui	a3,0x3
ffffffffc0203622:	4631                	li	a2,12
ffffffffc0203624:	00c68023          	sb	a2,0(a3) # 3000 <_binary_obj___user_faultread_out_size-0x6bb0>
     assert(pgfault_num==3);
ffffffffc0203628:	4398                	lw	a4,0(a5)
ffffffffc020362a:	458d                	li	a1,3
ffffffffc020362c:	2701                	sext.w	a4,a4
ffffffffc020362e:	4cb71863          	bne	a4,a1,ffffffffc0203afe <swap_init+0x6e6>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0203632:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==3);
ffffffffc0203636:	4394                	lw	a3,0(a5)
ffffffffc0203638:	2681                	sext.w	a3,a3
ffffffffc020363a:	4ee69263          	bne	a3,a4,ffffffffc0203b1e <swap_init+0x706>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc020363e:	6691                	lui	a3,0x4
ffffffffc0203640:	4635                	li	a2,13
ffffffffc0203642:	00c68023          	sb	a2,0(a3) # 4000 <_binary_obj___user_faultread_out_size-0x5bb0>
     assert(pgfault_num==4);
ffffffffc0203646:	4398                	lw	a4,0(a5)
ffffffffc0203648:	2701                	sext.w	a4,a4
ffffffffc020364a:	43471a63          	bne	a4,s4,ffffffffc0203a7e <swap_init+0x666>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc020364e:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==4);
ffffffffc0203652:	439c                	lw	a5,0(a5)
ffffffffc0203654:	2781                	sext.w	a5,a5
ffffffffc0203656:	44e79463          	bne	a5,a4,ffffffffc0203a9e <swap_init+0x686>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc020365a:	481c                	lw	a5,16(s0)
ffffffffc020365c:	2c079563          	bnez	a5,ffffffffc0203926 <swap_init+0x50e>
ffffffffc0203660:	000ab797          	auipc	a5,0xab
ffffffffc0203664:	10078793          	addi	a5,a5,256 # ffffffffc02ae760 <swap_in_seq_no>
ffffffffc0203668:	000ab717          	auipc	a4,0xab
ffffffffc020366c:	12070713          	addi	a4,a4,288 # ffffffffc02ae788 <swap_out_seq_no>
ffffffffc0203670:	000ab617          	auipc	a2,0xab
ffffffffc0203674:	11860613          	addi	a2,a2,280 # ffffffffc02ae788 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0203678:	56fd                	li	a3,-1
ffffffffc020367a:	c394                	sw	a3,0(a5)
ffffffffc020367c:	c314                	sw	a3,0(a4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc020367e:	0791                	addi	a5,a5,4
ffffffffc0203680:	0711                	addi	a4,a4,4
ffffffffc0203682:	fec79ce3          	bne	a5,a2,ffffffffc020367a <swap_init+0x262>
ffffffffc0203686:	000ab717          	auipc	a4,0xab
ffffffffc020368a:	09a70713          	addi	a4,a4,154 # ffffffffc02ae720 <check_ptep>
ffffffffc020368e:	000ab697          	auipc	a3,0xab
ffffffffc0203692:	0b268693          	addi	a3,a3,178 # ffffffffc02ae740 <check_rp>
ffffffffc0203696:	6585                	lui	a1,0x1
    if (PPN(pa) >= npage) {
ffffffffc0203698:	000afc17          	auipc	s8,0xaf
ffffffffc020369c:	168c0c13          	addi	s8,s8,360 # ffffffffc02b2800 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02036a0:	000afc97          	auipc	s9,0xaf
ffffffffc02036a4:	168c8c93          	addi	s9,s9,360 # ffffffffc02b2808 <pages>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc02036a8:	00073023          	sd	zero,0(a4)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02036ac:	4601                	li	a2,0
ffffffffc02036ae:	855a                	mv	a0,s6
ffffffffc02036b0:	e836                	sd	a3,16(sp)
ffffffffc02036b2:	e42e                	sd	a1,8(sp)
         check_ptep[i]=0;
ffffffffc02036b4:	e03a                	sd	a4,0(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02036b6:	f2cfe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc02036ba:	6702                	ld	a4,0(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc02036bc:	65a2                	ld	a1,8(sp)
ffffffffc02036be:	66c2                	ld	a3,16(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02036c0:	e308                	sd	a0,0(a4)
         assert(check_ptep[i] != NULL);
ffffffffc02036c2:	1c050663          	beqz	a0,ffffffffc020388e <swap_init+0x476>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc02036c6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02036c8:	0017f613          	andi	a2,a5,1
ffffffffc02036cc:	1e060163          	beqz	a2,ffffffffc02038ae <swap_init+0x496>
    if (PPN(pa) >= npage) {
ffffffffc02036d0:	000c3603          	ld	a2,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc02036d4:	078a                	slli	a5,a5,0x2
ffffffffc02036d6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02036d8:	14c7f363          	bgeu	a5,a2,ffffffffc020381e <swap_init+0x406>
    return &pages[PPN(pa) - nbase];
ffffffffc02036dc:	00005617          	auipc	a2,0x5
ffffffffc02036e0:	64c60613          	addi	a2,a2,1612 # ffffffffc0208d28 <nbase>
ffffffffc02036e4:	00063a03          	ld	s4,0(a2)
ffffffffc02036e8:	000cb603          	ld	a2,0(s9)
ffffffffc02036ec:	6288                	ld	a0,0(a3)
ffffffffc02036ee:	414787b3          	sub	a5,a5,s4
ffffffffc02036f2:	079a                	slli	a5,a5,0x6
ffffffffc02036f4:	97b2                	add	a5,a5,a2
ffffffffc02036f6:	14f51063          	bne	a0,a5,ffffffffc0203836 <swap_init+0x41e>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02036fa:	6785                	lui	a5,0x1
ffffffffc02036fc:	95be                	add	a1,a1,a5
ffffffffc02036fe:	6795                	lui	a5,0x5
ffffffffc0203700:	0721                	addi	a4,a4,8
ffffffffc0203702:	06a1                	addi	a3,a3,8
ffffffffc0203704:	faf592e3          	bne	a1,a5,ffffffffc02036a8 <swap_init+0x290>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0203708:	00004517          	auipc	a0,0x4
ffffffffc020370c:	58050513          	addi	a0,a0,1408 # ffffffffc0207c88 <default_pmm_manager+0x950>
ffffffffc0203710:	a71fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    int ret = sm->check_swap();
ffffffffc0203714:	000bb783          	ld	a5,0(s7)
ffffffffc0203718:	7f9c                	ld	a5,56(a5)
ffffffffc020371a:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc020371c:	32051163          	bnez	a0,ffffffffc0203a3e <swap_init+0x626>

     nr_free = nr_free_store;
ffffffffc0203720:	77a2                	ld	a5,40(sp)
ffffffffc0203722:	c81c                	sw	a5,16(s0)
     free_list = free_list_store;
ffffffffc0203724:	67e2                	ld	a5,24(sp)
ffffffffc0203726:	e01c                	sd	a5,0(s0)
ffffffffc0203728:	7782                	ld	a5,32(sp)
ffffffffc020372a:	e41c                	sd	a5,8(s0)

     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc020372c:	6088                	ld	a0,0(s1)
ffffffffc020372e:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203730:	04a1                	addi	s1,s1,8
         free_pages(check_rp[i],1);
ffffffffc0203732:	e36fe0ef          	jal	ra,ffffffffc0201d68 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203736:	ff349be3          	bne	s1,s3,ffffffffc020372c <swap_init+0x314>
     } 

     //free_page(pte2page(*temp_ptep));

     mm->pgdir = NULL;
ffffffffc020373a:	000abc23          	sd	zero,24(s5)
     mm_destroy(mm);
ffffffffc020373e:	8556                	mv	a0,s5
ffffffffc0203740:	35d000ef          	jal	ra,ffffffffc020429c <mm_destroy>
     check_mm_struct = NULL;

     pde_t *pd1=pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0203744:	000af797          	auipc	a5,0xaf
ffffffffc0203748:	0b478793          	addi	a5,a5,180 # ffffffffc02b27f8 <boot_pgdir>
ffffffffc020374c:	639c                	ld	a5,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc020374e:	000c3703          	ld	a4,0(s8)
     check_mm_struct = NULL;
ffffffffc0203752:	000af697          	auipc	a3,0xaf
ffffffffc0203756:	0e06b323          	sd	zero,230(a3) # ffffffffc02b2838 <check_mm_struct>
    return pa2page(PDE_ADDR(pde));
ffffffffc020375a:	639c                	ld	a5,0(a5)
ffffffffc020375c:	078a                	slli	a5,a5,0x2
ffffffffc020375e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203760:	0ae7fd63          	bgeu	a5,a4,ffffffffc020381a <swap_init+0x402>
    return &pages[PPN(pa) - nbase];
ffffffffc0203764:	414786b3          	sub	a3,a5,s4
ffffffffc0203768:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc020376a:	8699                	srai	a3,a3,0x6
ffffffffc020376c:	96d2                	add	a3,a3,s4
    return KADDR(page2pa(page));
ffffffffc020376e:	00c69793          	slli	a5,a3,0xc
ffffffffc0203772:	83b1                	srli	a5,a5,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0203774:	000cb503          	ld	a0,0(s9)
    return page2ppn(page) << PGSHIFT;
ffffffffc0203778:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020377a:	22e7f663          	bgeu	a5,a4,ffffffffc02039a6 <swap_init+0x58e>
     free_page(pde2page(pd0[0]));
ffffffffc020377e:	000af797          	auipc	a5,0xaf
ffffffffc0203782:	09a7b783          	ld	a5,154(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0203786:	96be                	add	a3,a3,a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203788:	629c                	ld	a5,0(a3)
ffffffffc020378a:	078a                	slli	a5,a5,0x2
ffffffffc020378c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020378e:	08e7f663          	bgeu	a5,a4,ffffffffc020381a <swap_init+0x402>
    return &pages[PPN(pa) - nbase];
ffffffffc0203792:	414787b3          	sub	a5,a5,s4
ffffffffc0203796:	079a                	slli	a5,a5,0x6
ffffffffc0203798:	953e                	add	a0,a0,a5
ffffffffc020379a:	4585                	li	a1,1
ffffffffc020379c:	dccfe0ef          	jal	ra,ffffffffc0201d68 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc02037a0:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage) {
ffffffffc02037a4:	000c3703          	ld	a4,0(s8)
    return pa2page(PDE_ADDR(pde));
ffffffffc02037a8:	078a                	slli	a5,a5,0x2
ffffffffc02037aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02037ac:	06e7f763          	bgeu	a5,a4,ffffffffc020381a <swap_init+0x402>
    return &pages[PPN(pa) - nbase];
ffffffffc02037b0:	000cb503          	ld	a0,0(s9)
ffffffffc02037b4:	414787b3          	sub	a5,a5,s4
ffffffffc02037b8:	079a                	slli	a5,a5,0x6
     free_page(pde2page(pd1[0]));
ffffffffc02037ba:	4585                	li	a1,1
ffffffffc02037bc:	953e                	add	a0,a0,a5
ffffffffc02037be:	daafe0ef          	jal	ra,ffffffffc0201d68 <free_pages>
     pgdir[0] = 0;
ffffffffc02037c2:	000b3023          	sd	zero,0(s6)
  asm volatile("sfence.vma");
ffffffffc02037c6:	12000073          	sfence.vma
    return listelm->next;
ffffffffc02037ca:	641c                	ld	a5,8(s0)
     flush_tlb();

     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02037cc:	00878a63          	beq	a5,s0,ffffffffc02037e0 <swap_init+0x3c8>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc02037d0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02037d4:	679c                	ld	a5,8(a5)
ffffffffc02037d6:	3dfd                	addiw	s11,s11,-1
ffffffffc02037d8:	40ed0d3b          	subw	s10,s10,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc02037dc:	fe879ae3          	bne	a5,s0,ffffffffc02037d0 <swap_init+0x3b8>
     }
     assert(count==0);
ffffffffc02037e0:	1c0d9f63          	bnez	s11,ffffffffc02039be <swap_init+0x5a6>
     assert(total==0);
ffffffffc02037e4:	1a0d1163          	bnez	s10,ffffffffc0203986 <swap_init+0x56e>

     cprintf("check_swap() succeeded!\n");
ffffffffc02037e8:	00004517          	auipc	a0,0x4
ffffffffc02037ec:	4f050513          	addi	a0,a0,1264 # ffffffffc0207cd8 <default_pmm_manager+0x9a0>
ffffffffc02037f0:	991fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc02037f4:	b99d                	j	ffffffffc020346a <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc02037f6:	4481                	li	s1,0
ffffffffc02037f8:	b9f1                	j	ffffffffc02034d4 <swap_init+0xbc>
        assert(PageProperty(p));
ffffffffc02037fa:	00003697          	auipc	a3,0x3
ffffffffc02037fe:	79668693          	addi	a3,a3,1942 # ffffffffc0206f90 <commands+0x740>
ffffffffc0203802:	00003617          	auipc	a2,0x3
ffffffffc0203806:	49e60613          	addi	a2,a2,1182 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020380a:	0bc00593          	li	a1,188
ffffffffc020380e:	00004517          	auipc	a0,0x4
ffffffffc0203812:	26250513          	addi	a0,a0,610 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203816:	c65fc0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc020381a:	be3ff0ef          	jal	ra,ffffffffc02033fc <pa2page.part.0>
        panic("pa2page called with invalid pa");
ffffffffc020381e:	00004617          	auipc	a2,0x4
ffffffffc0203822:	c2260613          	addi	a2,a2,-990 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc0203826:	06200593          	li	a1,98
ffffffffc020382a:	00004517          	auipc	a0,0x4
ffffffffc020382e:	b6e50513          	addi	a0,a0,-1170 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0203832:	c49fc0ef          	jal	ra,ffffffffc020047a <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0203836:	00004697          	auipc	a3,0x4
ffffffffc020383a:	42a68693          	addi	a3,a3,1066 # ffffffffc0207c60 <default_pmm_manager+0x928>
ffffffffc020383e:	00003617          	auipc	a2,0x3
ffffffffc0203842:	46260613          	addi	a2,a2,1122 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203846:	0fc00593          	li	a1,252
ffffffffc020384a:	00004517          	auipc	a0,0x4
ffffffffc020384e:	22650513          	addi	a0,a0,550 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203852:	c29fc0ef          	jal	ra,ffffffffc020047a <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0203856:	00004697          	auipc	a3,0x4
ffffffffc020385a:	32a68693          	addi	a3,a3,810 # ffffffffc0207b80 <default_pmm_manager+0x848>
ffffffffc020385e:	00003617          	auipc	a2,0x3
ffffffffc0203862:	44260613          	addi	a2,a2,1090 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203866:	0dc00593          	li	a1,220
ffffffffc020386a:	00004517          	auipc	a0,0x4
ffffffffc020386e:	20650513          	addi	a0,a0,518 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203872:	c09fc0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0203876:	00004617          	auipc	a2,0x4
ffffffffc020387a:	1da60613          	addi	a2,a2,474 # ffffffffc0207a50 <default_pmm_manager+0x718>
ffffffffc020387e:	02800593          	li	a1,40
ffffffffc0203882:	00004517          	auipc	a0,0x4
ffffffffc0203886:	1ee50513          	addi	a0,a0,494 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc020388a:	bf1fc0ef          	jal	ra,ffffffffc020047a <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc020388e:	00004697          	auipc	a3,0x4
ffffffffc0203892:	3ba68693          	addi	a3,a3,954 # ffffffffc0207c48 <default_pmm_manager+0x910>
ffffffffc0203896:	00003617          	auipc	a2,0x3
ffffffffc020389a:	40a60613          	addi	a2,a2,1034 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020389e:	0fb00593          	li	a1,251
ffffffffc02038a2:	00004517          	auipc	a0,0x4
ffffffffc02038a6:	1ce50513          	addi	a0,a0,462 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc02038aa:	bd1fc0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02038ae:	00004617          	auipc	a2,0x4
ffffffffc02038b2:	bb260613          	addi	a2,a2,-1102 # ffffffffc0207460 <default_pmm_manager+0x128>
ffffffffc02038b6:	07400593          	li	a1,116
ffffffffc02038ba:	00004517          	auipc	a0,0x4
ffffffffc02038be:	ade50513          	addi	a0,a0,-1314 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc02038c2:	bb9fc0ef          	jal	ra,ffffffffc020047a <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc02038c6:	00004697          	auipc	a3,0x4
ffffffffc02038ca:	2d268693          	addi	a3,a3,722 # ffffffffc0207b98 <default_pmm_manager+0x860>
ffffffffc02038ce:	00003617          	auipc	a2,0x3
ffffffffc02038d2:	3d260613          	addi	a2,a2,978 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02038d6:	0dd00593          	li	a1,221
ffffffffc02038da:	00004517          	auipc	a0,0x4
ffffffffc02038de:	19650513          	addi	a0,a0,406 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc02038e2:	b99fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(check_mm_struct == NULL);
ffffffffc02038e6:	00004697          	auipc	a3,0x4
ffffffffc02038ea:	1ea68693          	addi	a3,a3,490 # ffffffffc0207ad0 <default_pmm_manager+0x798>
ffffffffc02038ee:	00003617          	auipc	a2,0x3
ffffffffc02038f2:	3b260613          	addi	a2,a2,946 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02038f6:	0c700593          	li	a1,199
ffffffffc02038fa:	00004517          	auipc	a0,0x4
ffffffffc02038fe:	17650513          	addi	a0,a0,374 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203902:	b79fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(total == nr_free_pages());
ffffffffc0203906:	00003697          	auipc	a3,0x3
ffffffffc020390a:	6b268693          	addi	a3,a3,1714 # ffffffffc0206fb8 <commands+0x768>
ffffffffc020390e:	00003617          	auipc	a2,0x3
ffffffffc0203912:	39260613          	addi	a2,a2,914 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203916:	0bf00593          	li	a1,191
ffffffffc020391a:	00004517          	auipc	a0,0x4
ffffffffc020391e:	15650513          	addi	a0,a0,342 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203922:	b59fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert( nr_free == 0);         
ffffffffc0203926:	00004697          	auipc	a3,0x4
ffffffffc020392a:	83a68693          	addi	a3,a3,-1990 # ffffffffc0207160 <commands+0x910>
ffffffffc020392e:	00003617          	auipc	a2,0x3
ffffffffc0203932:	37260613          	addi	a2,a2,882 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203936:	0f300593          	li	a1,243
ffffffffc020393a:	00004517          	auipc	a0,0x4
ffffffffc020393e:	13650513          	addi	a0,a0,310 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203942:	b39fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgdir[0] == 0);
ffffffffc0203946:	00004697          	auipc	a3,0x4
ffffffffc020394a:	1a268693          	addi	a3,a3,418 # ffffffffc0207ae8 <default_pmm_manager+0x7b0>
ffffffffc020394e:	00003617          	auipc	a2,0x3
ffffffffc0203952:	35260613          	addi	a2,a2,850 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203956:	0cc00593          	li	a1,204
ffffffffc020395a:	00004517          	auipc	a0,0x4
ffffffffc020395e:	11650513          	addi	a0,a0,278 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203962:	b19fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(mm != NULL);
ffffffffc0203966:	00004697          	auipc	a3,0x4
ffffffffc020396a:	15a68693          	addi	a3,a3,346 # ffffffffc0207ac0 <default_pmm_manager+0x788>
ffffffffc020396e:	00003617          	auipc	a2,0x3
ffffffffc0203972:	33260613          	addi	a2,a2,818 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203976:	0c400593          	li	a1,196
ffffffffc020397a:	00004517          	auipc	a0,0x4
ffffffffc020397e:	0f650513          	addi	a0,a0,246 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203982:	af9fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(total==0);
ffffffffc0203986:	00004697          	auipc	a3,0x4
ffffffffc020398a:	34268693          	addi	a3,a3,834 # ffffffffc0207cc8 <default_pmm_manager+0x990>
ffffffffc020398e:	00003617          	auipc	a2,0x3
ffffffffc0203992:	31260613          	addi	a2,a2,786 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203996:	11e00593          	li	a1,286
ffffffffc020399a:	00004517          	auipc	a0,0x4
ffffffffc020399e:	0d650513          	addi	a0,a0,214 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc02039a2:	ad9fc0ef          	jal	ra,ffffffffc020047a <__panic>
    return KADDR(page2pa(page));
ffffffffc02039a6:	00004617          	auipc	a2,0x4
ffffffffc02039aa:	9ca60613          	addi	a2,a2,-1590 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc02039ae:	06900593          	li	a1,105
ffffffffc02039b2:	00004517          	auipc	a0,0x4
ffffffffc02039b6:	9e650513          	addi	a0,a0,-1562 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc02039ba:	ac1fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(count==0);
ffffffffc02039be:	00004697          	auipc	a3,0x4
ffffffffc02039c2:	2fa68693          	addi	a3,a3,762 # ffffffffc0207cb8 <default_pmm_manager+0x980>
ffffffffc02039c6:	00003617          	auipc	a2,0x3
ffffffffc02039ca:	2da60613          	addi	a2,a2,730 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02039ce:	11d00593          	li	a1,285
ffffffffc02039d2:	00004517          	auipc	a0,0x4
ffffffffc02039d6:	09e50513          	addi	a0,a0,158 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc02039da:	aa1fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==1);
ffffffffc02039de:	00004697          	auipc	a3,0x4
ffffffffc02039e2:	22a68693          	addi	a3,a3,554 # ffffffffc0207c08 <default_pmm_manager+0x8d0>
ffffffffc02039e6:	00003617          	auipc	a2,0x3
ffffffffc02039ea:	2ba60613          	addi	a2,a2,698 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02039ee:	09500593          	li	a1,149
ffffffffc02039f2:	00004517          	auipc	a0,0x4
ffffffffc02039f6:	07e50513          	addi	a0,a0,126 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc02039fa:	a81fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02039fe:	00004697          	auipc	a3,0x4
ffffffffc0203a02:	1ba68693          	addi	a3,a3,442 # ffffffffc0207bb8 <default_pmm_manager+0x880>
ffffffffc0203a06:	00003617          	auipc	a2,0x3
ffffffffc0203a0a:	29a60613          	addi	a2,a2,666 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203a0e:	0ea00593          	li	a1,234
ffffffffc0203a12:	00004517          	auipc	a0,0x4
ffffffffc0203a16:	05e50513          	addi	a0,a0,94 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203a1a:	a61fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0203a1e:	00004697          	auipc	a3,0x4
ffffffffc0203a22:	12268693          	addi	a3,a3,290 # ffffffffc0207b40 <default_pmm_manager+0x808>
ffffffffc0203a26:	00003617          	auipc	a2,0x3
ffffffffc0203a2a:	27a60613          	addi	a2,a2,634 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203a2e:	0d700593          	li	a1,215
ffffffffc0203a32:	00004517          	auipc	a0,0x4
ffffffffc0203a36:	03e50513          	addi	a0,a0,62 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203a3a:	a41fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(ret==0);
ffffffffc0203a3e:	00004697          	auipc	a3,0x4
ffffffffc0203a42:	27268693          	addi	a3,a3,626 # ffffffffc0207cb0 <default_pmm_manager+0x978>
ffffffffc0203a46:	00003617          	auipc	a2,0x3
ffffffffc0203a4a:	25a60613          	addi	a2,a2,602 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203a4e:	10200593          	li	a1,258
ffffffffc0203a52:	00004517          	auipc	a0,0x4
ffffffffc0203a56:	01e50513          	addi	a0,a0,30 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203a5a:	a21fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(vma != NULL);
ffffffffc0203a5e:	00004697          	auipc	a3,0x4
ffffffffc0203a62:	09a68693          	addi	a3,a3,154 # ffffffffc0207af8 <default_pmm_manager+0x7c0>
ffffffffc0203a66:	00003617          	auipc	a2,0x3
ffffffffc0203a6a:	23a60613          	addi	a2,a2,570 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203a6e:	0cf00593          	li	a1,207
ffffffffc0203a72:	00004517          	auipc	a0,0x4
ffffffffc0203a76:	ffe50513          	addi	a0,a0,-2 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203a7a:	a01fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==4);
ffffffffc0203a7e:	00004697          	auipc	a3,0x4
ffffffffc0203a82:	1ba68693          	addi	a3,a3,442 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc0203a86:	00003617          	auipc	a2,0x3
ffffffffc0203a8a:	21a60613          	addi	a2,a2,538 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203a8e:	09f00593          	li	a1,159
ffffffffc0203a92:	00004517          	auipc	a0,0x4
ffffffffc0203a96:	fde50513          	addi	a0,a0,-34 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203a9a:	9e1fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==4);
ffffffffc0203a9e:	00004697          	auipc	a3,0x4
ffffffffc0203aa2:	19a68693          	addi	a3,a3,410 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc0203aa6:	00003617          	auipc	a2,0x3
ffffffffc0203aaa:	1fa60613          	addi	a2,a2,506 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203aae:	0a100593          	li	a1,161
ffffffffc0203ab2:	00004517          	auipc	a0,0x4
ffffffffc0203ab6:	fbe50513          	addi	a0,a0,-66 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203aba:	9c1fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==2);
ffffffffc0203abe:	00004697          	auipc	a3,0x4
ffffffffc0203ac2:	15a68693          	addi	a3,a3,346 # ffffffffc0207c18 <default_pmm_manager+0x8e0>
ffffffffc0203ac6:	00003617          	auipc	a2,0x3
ffffffffc0203aca:	1da60613          	addi	a2,a2,474 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203ace:	09700593          	li	a1,151
ffffffffc0203ad2:	00004517          	auipc	a0,0x4
ffffffffc0203ad6:	f9e50513          	addi	a0,a0,-98 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203ada:	9a1fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==2);
ffffffffc0203ade:	00004697          	auipc	a3,0x4
ffffffffc0203ae2:	13a68693          	addi	a3,a3,314 # ffffffffc0207c18 <default_pmm_manager+0x8e0>
ffffffffc0203ae6:	00003617          	auipc	a2,0x3
ffffffffc0203aea:	1ba60613          	addi	a2,a2,442 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203aee:	09900593          	li	a1,153
ffffffffc0203af2:	00004517          	auipc	a0,0x4
ffffffffc0203af6:	f7e50513          	addi	a0,a0,-130 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203afa:	981fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==3);
ffffffffc0203afe:	00004697          	auipc	a3,0x4
ffffffffc0203b02:	12a68693          	addi	a3,a3,298 # ffffffffc0207c28 <default_pmm_manager+0x8f0>
ffffffffc0203b06:	00003617          	auipc	a2,0x3
ffffffffc0203b0a:	19a60613          	addi	a2,a2,410 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203b0e:	09b00593          	li	a1,155
ffffffffc0203b12:	00004517          	auipc	a0,0x4
ffffffffc0203b16:	f5e50513          	addi	a0,a0,-162 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203b1a:	961fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==3);
ffffffffc0203b1e:	00004697          	auipc	a3,0x4
ffffffffc0203b22:	10a68693          	addi	a3,a3,266 # ffffffffc0207c28 <default_pmm_manager+0x8f0>
ffffffffc0203b26:	00003617          	auipc	a2,0x3
ffffffffc0203b2a:	17a60613          	addi	a2,a2,378 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203b2e:	09d00593          	li	a1,157
ffffffffc0203b32:	00004517          	auipc	a0,0x4
ffffffffc0203b36:	f3e50513          	addi	a0,a0,-194 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203b3a:	941fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(pgfault_num==1);
ffffffffc0203b3e:	00004697          	auipc	a3,0x4
ffffffffc0203b42:	0ca68693          	addi	a3,a3,202 # ffffffffc0207c08 <default_pmm_manager+0x8d0>
ffffffffc0203b46:	00003617          	auipc	a2,0x3
ffffffffc0203b4a:	15a60613          	addi	a2,a2,346 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203b4e:	09300593          	li	a1,147
ffffffffc0203b52:	00004517          	auipc	a0,0x4
ffffffffc0203b56:	f1e50513          	addi	a0,a0,-226 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203b5a:	921fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0203b5e <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0203b5e:	000af797          	auipc	a5,0xaf
ffffffffc0203b62:	cca7b783          	ld	a5,-822(a5) # ffffffffc02b2828 <sm>
ffffffffc0203b66:	6b9c                	ld	a5,16(a5)
ffffffffc0203b68:	8782                	jr	a5

ffffffffc0203b6a <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0203b6a:	000af797          	auipc	a5,0xaf
ffffffffc0203b6e:	cbe7b783          	ld	a5,-834(a5) # ffffffffc02b2828 <sm>
ffffffffc0203b72:	739c                	ld	a5,32(a5)
ffffffffc0203b74:	8782                	jr	a5

ffffffffc0203b76 <swap_out>:
{
ffffffffc0203b76:	711d                	addi	sp,sp,-96
ffffffffc0203b78:	ec86                	sd	ra,88(sp)
ffffffffc0203b7a:	e8a2                	sd	s0,80(sp)
ffffffffc0203b7c:	e4a6                	sd	s1,72(sp)
ffffffffc0203b7e:	e0ca                	sd	s2,64(sp)
ffffffffc0203b80:	fc4e                	sd	s3,56(sp)
ffffffffc0203b82:	f852                	sd	s4,48(sp)
ffffffffc0203b84:	f456                	sd	s5,40(sp)
ffffffffc0203b86:	f05a                	sd	s6,32(sp)
ffffffffc0203b88:	ec5e                	sd	s7,24(sp)
ffffffffc0203b8a:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0203b8c:	cde9                	beqz	a1,ffffffffc0203c66 <swap_out+0xf0>
ffffffffc0203b8e:	8a2e                	mv	s4,a1
ffffffffc0203b90:	892a                	mv	s2,a0
ffffffffc0203b92:	8ab2                	mv	s5,a2
ffffffffc0203b94:	4401                	li	s0,0
ffffffffc0203b96:	000af997          	auipc	s3,0xaf
ffffffffc0203b9a:	c9298993          	addi	s3,s3,-878 # ffffffffc02b2828 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203b9e:	00004b17          	auipc	s6,0x4
ffffffffc0203ba2:	1bab0b13          	addi	s6,s6,442 # ffffffffc0207d58 <default_pmm_manager+0xa20>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203ba6:	00004b97          	auipc	s7,0x4
ffffffffc0203baa:	19ab8b93          	addi	s7,s7,410 # ffffffffc0207d40 <default_pmm_manager+0xa08>
ffffffffc0203bae:	a825                	j	ffffffffc0203be6 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203bb0:	67a2                	ld	a5,8(sp)
ffffffffc0203bb2:	8626                	mv	a2,s1
ffffffffc0203bb4:	85a2                	mv	a1,s0
ffffffffc0203bb6:	7f94                	ld	a3,56(a5)
ffffffffc0203bb8:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0203bba:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203bbc:	82b1                	srli	a3,a3,0xc
ffffffffc0203bbe:	0685                	addi	a3,a3,1
ffffffffc0203bc0:	dc0fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0203bc4:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0203bc6:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0203bc8:	7d1c                	ld	a5,56(a0)
ffffffffc0203bca:	83b1                	srli	a5,a5,0xc
ffffffffc0203bcc:	0785                	addi	a5,a5,1
ffffffffc0203bce:	07a2                	slli	a5,a5,0x8
ffffffffc0203bd0:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0203bd4:	994fe0ef          	jal	ra,ffffffffc0201d68 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0203bd8:	01893503          	ld	a0,24(s2)
ffffffffc0203bdc:	85a6                	mv	a1,s1
ffffffffc0203bde:	f5eff0ef          	jal	ra,ffffffffc020333c <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0203be2:	048a0d63          	beq	s4,s0,ffffffffc0203c3c <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0203be6:	0009b783          	ld	a5,0(s3)
ffffffffc0203bea:	8656                	mv	a2,s5
ffffffffc0203bec:	002c                	addi	a1,sp,8
ffffffffc0203bee:	7b9c                	ld	a5,48(a5)
ffffffffc0203bf0:	854a                	mv	a0,s2
ffffffffc0203bf2:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0203bf4:	e12d                	bnez	a0,ffffffffc0203c56 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0203bf6:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203bf8:	01893503          	ld	a0,24(s2)
ffffffffc0203bfc:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0203bfe:	7f84                	ld	s1,56(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203c00:	85a6                	mv	a1,s1
ffffffffc0203c02:	9e0fe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203c06:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203c08:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203c0a:	8b85                	andi	a5,a5,1
ffffffffc0203c0c:	cfb9                	beqz	a5,ffffffffc0203c6a <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0203c0e:	65a2                	ld	a1,8(sp)
ffffffffc0203c10:	7d9c                	ld	a5,56(a1)
ffffffffc0203c12:	83b1                	srli	a5,a5,0xc
ffffffffc0203c14:	0785                	addi	a5,a5,1
ffffffffc0203c16:	00879513          	slli	a0,a5,0x8
ffffffffc0203c1a:	032010ef          	jal	ra,ffffffffc0204c4c <swapfs_write>
ffffffffc0203c1e:	d949                	beqz	a0,ffffffffc0203bb0 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203c20:	855e                	mv	a0,s7
ffffffffc0203c22:	d5efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203c26:	0009b783          	ld	a5,0(s3)
ffffffffc0203c2a:	6622                	ld	a2,8(sp)
ffffffffc0203c2c:	4681                	li	a3,0
ffffffffc0203c2e:	739c                	ld	a5,32(a5)
ffffffffc0203c30:	85a6                	mv	a1,s1
ffffffffc0203c32:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0203c34:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203c36:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0203c38:	fa8a17e3          	bne	s4,s0,ffffffffc0203be6 <swap_out+0x70>
}
ffffffffc0203c3c:	60e6                	ld	ra,88(sp)
ffffffffc0203c3e:	8522                	mv	a0,s0
ffffffffc0203c40:	6446                	ld	s0,80(sp)
ffffffffc0203c42:	64a6                	ld	s1,72(sp)
ffffffffc0203c44:	6906                	ld	s2,64(sp)
ffffffffc0203c46:	79e2                	ld	s3,56(sp)
ffffffffc0203c48:	7a42                	ld	s4,48(sp)
ffffffffc0203c4a:	7aa2                	ld	s5,40(sp)
ffffffffc0203c4c:	7b02                	ld	s6,32(sp)
ffffffffc0203c4e:	6be2                	ld	s7,24(sp)
ffffffffc0203c50:	6c42                	ld	s8,16(sp)
ffffffffc0203c52:	6125                	addi	sp,sp,96
ffffffffc0203c54:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0203c56:	85a2                	mv	a1,s0
ffffffffc0203c58:	00004517          	auipc	a0,0x4
ffffffffc0203c5c:	0a050513          	addi	a0,a0,160 # ffffffffc0207cf8 <default_pmm_manager+0x9c0>
ffffffffc0203c60:	d20fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                  break;
ffffffffc0203c64:	bfe1                	j	ffffffffc0203c3c <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0203c66:	4401                	li	s0,0
ffffffffc0203c68:	bfd1                	j	ffffffffc0203c3c <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203c6a:	00004697          	auipc	a3,0x4
ffffffffc0203c6e:	0be68693          	addi	a3,a3,190 # ffffffffc0207d28 <default_pmm_manager+0x9f0>
ffffffffc0203c72:	00003617          	auipc	a2,0x3
ffffffffc0203c76:	02e60613          	addi	a2,a2,46 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203c7a:	06800593          	li	a1,104
ffffffffc0203c7e:	00004517          	auipc	a0,0x4
ffffffffc0203c82:	df250513          	addi	a0,a0,-526 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203c86:	ff4fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0203c8a <swap_in>:
{
ffffffffc0203c8a:	7179                	addi	sp,sp,-48
ffffffffc0203c8c:	e84a                	sd	s2,16(sp)
ffffffffc0203c8e:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0203c90:	4505                	li	a0,1
{
ffffffffc0203c92:	ec26                	sd	s1,24(sp)
ffffffffc0203c94:	e44e                	sd	s3,8(sp)
ffffffffc0203c96:	f406                	sd	ra,40(sp)
ffffffffc0203c98:	f022                	sd	s0,32(sp)
ffffffffc0203c9a:	84ae                	mv	s1,a1
ffffffffc0203c9c:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0203c9e:	838fe0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
     assert(result!=NULL);
ffffffffc0203ca2:	c129                	beqz	a0,ffffffffc0203ce4 <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0203ca4:	842a                	mv	s0,a0
ffffffffc0203ca6:	01893503          	ld	a0,24(s2)
ffffffffc0203caa:	4601                	li	a2,0
ffffffffc0203cac:	85a6                	mv	a1,s1
ffffffffc0203cae:	934fe0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0203cb2:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0203cb4:	6108                	ld	a0,0(a0)
ffffffffc0203cb6:	85a2                	mv	a1,s0
ffffffffc0203cb8:	707000ef          	jal	ra,ffffffffc0204bbe <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0203cbc:	00093583          	ld	a1,0(s2)
ffffffffc0203cc0:	8626                	mv	a2,s1
ffffffffc0203cc2:	00004517          	auipc	a0,0x4
ffffffffc0203cc6:	0e650513          	addi	a0,a0,230 # ffffffffc0207da8 <default_pmm_manager+0xa70>
ffffffffc0203cca:	81a1                	srli	a1,a1,0x8
ffffffffc0203ccc:	cb4fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc0203cd0:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0203cd2:	0089b023          	sd	s0,0(s3)
}
ffffffffc0203cd6:	7402                	ld	s0,32(sp)
ffffffffc0203cd8:	64e2                	ld	s1,24(sp)
ffffffffc0203cda:	6942                	ld	s2,16(sp)
ffffffffc0203cdc:	69a2                	ld	s3,8(sp)
ffffffffc0203cde:	4501                	li	a0,0
ffffffffc0203ce0:	6145                	addi	sp,sp,48
ffffffffc0203ce2:	8082                	ret
     assert(result!=NULL);
ffffffffc0203ce4:	00004697          	auipc	a3,0x4
ffffffffc0203ce8:	0b468693          	addi	a3,a3,180 # ffffffffc0207d98 <default_pmm_manager+0xa60>
ffffffffc0203cec:	00003617          	auipc	a2,0x3
ffffffffc0203cf0:	fb460613          	addi	a2,a2,-76 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203cf4:	07e00593          	li	a1,126
ffffffffc0203cf8:	00004517          	auipc	a0,0x4
ffffffffc0203cfc:	d7850513          	addi	a0,a0,-648 # ffffffffc0207a70 <default_pmm_manager+0x738>
ffffffffc0203d00:	f7afc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0203d04 <_fifo_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc0203d04:	000ab797          	auipc	a5,0xab
ffffffffc0203d08:	aac78793          	addi	a5,a5,-1364 # ffffffffc02ae7b0 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc0203d0c:	f51c                	sd	a5,40(a0)
ffffffffc0203d0e:	e79c                	sd	a5,8(a5)
ffffffffc0203d10:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc0203d12:	4501                	li	a0,0
ffffffffc0203d14:	8082                	ret

ffffffffc0203d16 <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc0203d16:	4501                	li	a0,0
ffffffffc0203d18:	8082                	ret

ffffffffc0203d1a <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0203d1a:	4501                	li	a0,0
ffffffffc0203d1c:	8082                	ret

ffffffffc0203d1e <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0203d1e:	4501                	li	a0,0
ffffffffc0203d20:	8082                	ret

ffffffffc0203d22 <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc0203d22:	711d                	addi	sp,sp,-96
ffffffffc0203d24:	fc4e                	sd	s3,56(sp)
ffffffffc0203d26:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0203d28:	00004517          	auipc	a0,0x4
ffffffffc0203d2c:	0c050513          	addi	a0,a0,192 # ffffffffc0207de8 <default_pmm_manager+0xab0>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0203d30:	698d                	lui	s3,0x3
ffffffffc0203d32:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc0203d34:	e0ca                	sd	s2,64(sp)
ffffffffc0203d36:	ec86                	sd	ra,88(sp)
ffffffffc0203d38:	e8a2                	sd	s0,80(sp)
ffffffffc0203d3a:	e4a6                	sd	s1,72(sp)
ffffffffc0203d3c:	f456                	sd	s5,40(sp)
ffffffffc0203d3e:	f05a                	sd	s6,32(sp)
ffffffffc0203d40:	ec5e                	sd	s7,24(sp)
ffffffffc0203d42:	e862                	sd	s8,16(sp)
ffffffffc0203d44:	e466                	sd	s9,8(sp)
ffffffffc0203d46:	e06a                	sd	s10,0(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0203d48:	c38fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0203d4c:	01498023          	sb	s4,0(s3) # 3000 <_binary_obj___user_faultread_out_size-0x6bb0>
    assert(pgfault_num==4);
ffffffffc0203d50:	000af917          	auipc	s2,0xaf
ffffffffc0203d54:	af092903          	lw	s2,-1296(s2) # ffffffffc02b2840 <pgfault_num>
ffffffffc0203d58:	4791                	li	a5,4
ffffffffc0203d5a:	14f91e63          	bne	s2,a5,ffffffffc0203eb6 <_fifo_check_swap+0x194>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0203d5e:	00004517          	auipc	a0,0x4
ffffffffc0203d62:	0ca50513          	addi	a0,a0,202 # ffffffffc0207e28 <default_pmm_manager+0xaf0>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203d66:	6a85                	lui	s5,0x1
ffffffffc0203d68:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0203d6a:	c16fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203d6e:	000af417          	auipc	s0,0xaf
ffffffffc0203d72:	ad240413          	addi	s0,s0,-1326 # ffffffffc02b2840 <pgfault_num>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203d76:	016a8023          	sb	s6,0(s5) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
    assert(pgfault_num==4);
ffffffffc0203d7a:	4004                	lw	s1,0(s0)
ffffffffc0203d7c:	2481                	sext.w	s1,s1
ffffffffc0203d7e:	2b249c63          	bne	s1,s2,ffffffffc0204036 <_fifo_check_swap+0x314>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0203d82:	00004517          	auipc	a0,0x4
ffffffffc0203d86:	0ce50513          	addi	a0,a0,206 # ffffffffc0207e50 <default_pmm_manager+0xb18>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0203d8a:	6b91                	lui	s7,0x4
ffffffffc0203d8c:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0203d8e:	bf2fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0203d92:	018b8023          	sb	s8,0(s7) # 4000 <_binary_obj___user_faultread_out_size-0x5bb0>
    assert(pgfault_num==4);
ffffffffc0203d96:	00042903          	lw	s2,0(s0)
ffffffffc0203d9a:	2901                	sext.w	s2,s2
ffffffffc0203d9c:	26991d63          	bne	s2,s1,ffffffffc0204016 <_fifo_check_swap+0x2f4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0203da0:	00004517          	auipc	a0,0x4
ffffffffc0203da4:	0d850513          	addi	a0,a0,216 # ffffffffc0207e78 <default_pmm_manager+0xb40>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203da8:	6c89                	lui	s9,0x2
ffffffffc0203daa:	4d2d                	li	s10,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0203dac:	bd4fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203db0:	01ac8023          	sb	s10,0(s9) # 2000 <_binary_obj___user_faultread_out_size-0x7bb0>
    assert(pgfault_num==4);
ffffffffc0203db4:	401c                	lw	a5,0(s0)
ffffffffc0203db6:	2781                	sext.w	a5,a5
ffffffffc0203db8:	23279f63          	bne	a5,s2,ffffffffc0203ff6 <_fifo_check_swap+0x2d4>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc0203dbc:	00004517          	auipc	a0,0x4
ffffffffc0203dc0:	0e450513          	addi	a0,a0,228 # ffffffffc0207ea0 <default_pmm_manager+0xb68>
ffffffffc0203dc4:	bbcfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0203dc8:	6795                	lui	a5,0x5
ffffffffc0203dca:	4739                	li	a4,14
ffffffffc0203dcc:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_faultread_out_size-0x4bb0>
    assert(pgfault_num==5);
ffffffffc0203dd0:	4004                	lw	s1,0(s0)
ffffffffc0203dd2:	4795                	li	a5,5
ffffffffc0203dd4:	2481                	sext.w	s1,s1
ffffffffc0203dd6:	20f49063          	bne	s1,a5,ffffffffc0203fd6 <_fifo_check_swap+0x2b4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0203dda:	00004517          	auipc	a0,0x4
ffffffffc0203dde:	09e50513          	addi	a0,a0,158 # ffffffffc0207e78 <default_pmm_manager+0xb40>
ffffffffc0203de2:	b9efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203de6:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==5);
ffffffffc0203dea:	401c                	lw	a5,0(s0)
ffffffffc0203dec:	2781                	sext.w	a5,a5
ffffffffc0203dee:	1c979463          	bne	a5,s1,ffffffffc0203fb6 <_fifo_check_swap+0x294>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0203df2:	00004517          	auipc	a0,0x4
ffffffffc0203df6:	03650513          	addi	a0,a0,54 # ffffffffc0207e28 <default_pmm_manager+0xaf0>
ffffffffc0203dfa:	b86fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203dfe:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc0203e02:	401c                	lw	a5,0(s0)
ffffffffc0203e04:	4719                	li	a4,6
ffffffffc0203e06:	2781                	sext.w	a5,a5
ffffffffc0203e08:	18e79763          	bne	a5,a4,ffffffffc0203f96 <_fifo_check_swap+0x274>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0203e0c:	00004517          	auipc	a0,0x4
ffffffffc0203e10:	06c50513          	addi	a0,a0,108 # ffffffffc0207e78 <default_pmm_manager+0xb40>
ffffffffc0203e14:	b6cfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203e18:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==7);
ffffffffc0203e1c:	401c                	lw	a5,0(s0)
ffffffffc0203e1e:	471d                	li	a4,7
ffffffffc0203e20:	2781                	sext.w	a5,a5
ffffffffc0203e22:	14e79a63          	bne	a5,a4,ffffffffc0203f76 <_fifo_check_swap+0x254>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0203e26:	00004517          	auipc	a0,0x4
ffffffffc0203e2a:	fc250513          	addi	a0,a0,-62 # ffffffffc0207de8 <default_pmm_manager+0xab0>
ffffffffc0203e2e:	b52fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0203e32:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc0203e36:	401c                	lw	a5,0(s0)
ffffffffc0203e38:	4721                	li	a4,8
ffffffffc0203e3a:	2781                	sext.w	a5,a5
ffffffffc0203e3c:	10e79d63          	bne	a5,a4,ffffffffc0203f56 <_fifo_check_swap+0x234>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0203e40:	00004517          	auipc	a0,0x4
ffffffffc0203e44:	01050513          	addi	a0,a0,16 # ffffffffc0207e50 <default_pmm_manager+0xb18>
ffffffffc0203e48:	b38fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0203e4c:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc0203e50:	401c                	lw	a5,0(s0)
ffffffffc0203e52:	4725                	li	a4,9
ffffffffc0203e54:	2781                	sext.w	a5,a5
ffffffffc0203e56:	0ee79063          	bne	a5,a4,ffffffffc0203f36 <_fifo_check_swap+0x214>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc0203e5a:	00004517          	auipc	a0,0x4
ffffffffc0203e5e:	04650513          	addi	a0,a0,70 # ffffffffc0207ea0 <default_pmm_manager+0xb68>
ffffffffc0203e62:	b1efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0203e66:	6795                	lui	a5,0x5
ffffffffc0203e68:	4739                	li	a4,14
ffffffffc0203e6a:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_faultread_out_size-0x4bb0>
    assert(pgfault_num==10);
ffffffffc0203e6e:	4004                	lw	s1,0(s0)
ffffffffc0203e70:	47a9                	li	a5,10
ffffffffc0203e72:	2481                	sext.w	s1,s1
ffffffffc0203e74:	0af49163          	bne	s1,a5,ffffffffc0203f16 <_fifo_check_swap+0x1f4>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0203e78:	00004517          	auipc	a0,0x4
ffffffffc0203e7c:	fb050513          	addi	a0,a0,-80 # ffffffffc0207e28 <default_pmm_manager+0xaf0>
ffffffffc0203e80:	b00fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203e84:	6785                	lui	a5,0x1
ffffffffc0203e86:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0203e8a:	06979663          	bne	a5,s1,ffffffffc0203ef6 <_fifo_check_swap+0x1d4>
    assert(pgfault_num==11);
ffffffffc0203e8e:	401c                	lw	a5,0(s0)
ffffffffc0203e90:	472d                	li	a4,11
ffffffffc0203e92:	2781                	sext.w	a5,a5
ffffffffc0203e94:	04e79163          	bne	a5,a4,ffffffffc0203ed6 <_fifo_check_swap+0x1b4>
}
ffffffffc0203e98:	60e6                	ld	ra,88(sp)
ffffffffc0203e9a:	6446                	ld	s0,80(sp)
ffffffffc0203e9c:	64a6                	ld	s1,72(sp)
ffffffffc0203e9e:	6906                	ld	s2,64(sp)
ffffffffc0203ea0:	79e2                	ld	s3,56(sp)
ffffffffc0203ea2:	7a42                	ld	s4,48(sp)
ffffffffc0203ea4:	7aa2                	ld	s5,40(sp)
ffffffffc0203ea6:	7b02                	ld	s6,32(sp)
ffffffffc0203ea8:	6be2                	ld	s7,24(sp)
ffffffffc0203eaa:	6c42                	ld	s8,16(sp)
ffffffffc0203eac:	6ca2                	ld	s9,8(sp)
ffffffffc0203eae:	6d02                	ld	s10,0(sp)
ffffffffc0203eb0:	4501                	li	a0,0
ffffffffc0203eb2:	6125                	addi	sp,sp,96
ffffffffc0203eb4:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0203eb6:	00004697          	auipc	a3,0x4
ffffffffc0203eba:	d8268693          	addi	a3,a3,-638 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc0203ebe:	00003617          	auipc	a2,0x3
ffffffffc0203ec2:	de260613          	addi	a2,a2,-542 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203ec6:	05100593          	li	a1,81
ffffffffc0203eca:	00004517          	auipc	a0,0x4
ffffffffc0203ece:	f4650513          	addi	a0,a0,-186 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203ed2:	da8fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==11);
ffffffffc0203ed6:	00004697          	auipc	a3,0x4
ffffffffc0203eda:	07a68693          	addi	a3,a3,122 # ffffffffc0207f50 <default_pmm_manager+0xc18>
ffffffffc0203ede:	00003617          	auipc	a2,0x3
ffffffffc0203ee2:	dc260613          	addi	a2,a2,-574 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203ee6:	07300593          	li	a1,115
ffffffffc0203eea:	00004517          	auipc	a0,0x4
ffffffffc0203eee:	f2650513          	addi	a0,a0,-218 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203ef2:	d88fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203ef6:	00004697          	auipc	a3,0x4
ffffffffc0203efa:	03268693          	addi	a3,a3,50 # ffffffffc0207f28 <default_pmm_manager+0xbf0>
ffffffffc0203efe:	00003617          	auipc	a2,0x3
ffffffffc0203f02:	da260613          	addi	a2,a2,-606 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203f06:	07100593          	li	a1,113
ffffffffc0203f0a:	00004517          	auipc	a0,0x4
ffffffffc0203f0e:	f0650513          	addi	a0,a0,-250 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203f12:	d68fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==10);
ffffffffc0203f16:	00004697          	auipc	a3,0x4
ffffffffc0203f1a:	00268693          	addi	a3,a3,2 # ffffffffc0207f18 <default_pmm_manager+0xbe0>
ffffffffc0203f1e:	00003617          	auipc	a2,0x3
ffffffffc0203f22:	d8260613          	addi	a2,a2,-638 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203f26:	06f00593          	li	a1,111
ffffffffc0203f2a:	00004517          	auipc	a0,0x4
ffffffffc0203f2e:	ee650513          	addi	a0,a0,-282 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203f32:	d48fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==9);
ffffffffc0203f36:	00004697          	auipc	a3,0x4
ffffffffc0203f3a:	fd268693          	addi	a3,a3,-46 # ffffffffc0207f08 <default_pmm_manager+0xbd0>
ffffffffc0203f3e:	00003617          	auipc	a2,0x3
ffffffffc0203f42:	d6260613          	addi	a2,a2,-670 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203f46:	06c00593          	li	a1,108
ffffffffc0203f4a:	00004517          	auipc	a0,0x4
ffffffffc0203f4e:	ec650513          	addi	a0,a0,-314 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203f52:	d28fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==8);
ffffffffc0203f56:	00004697          	auipc	a3,0x4
ffffffffc0203f5a:	fa268693          	addi	a3,a3,-94 # ffffffffc0207ef8 <default_pmm_manager+0xbc0>
ffffffffc0203f5e:	00003617          	auipc	a2,0x3
ffffffffc0203f62:	d4260613          	addi	a2,a2,-702 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203f66:	06900593          	li	a1,105
ffffffffc0203f6a:	00004517          	auipc	a0,0x4
ffffffffc0203f6e:	ea650513          	addi	a0,a0,-346 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203f72:	d08fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==7);
ffffffffc0203f76:	00004697          	auipc	a3,0x4
ffffffffc0203f7a:	f7268693          	addi	a3,a3,-142 # ffffffffc0207ee8 <default_pmm_manager+0xbb0>
ffffffffc0203f7e:	00003617          	auipc	a2,0x3
ffffffffc0203f82:	d2260613          	addi	a2,a2,-734 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203f86:	06600593          	li	a1,102
ffffffffc0203f8a:	00004517          	auipc	a0,0x4
ffffffffc0203f8e:	e8650513          	addi	a0,a0,-378 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203f92:	ce8fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==6);
ffffffffc0203f96:	00004697          	auipc	a3,0x4
ffffffffc0203f9a:	f4268693          	addi	a3,a3,-190 # ffffffffc0207ed8 <default_pmm_manager+0xba0>
ffffffffc0203f9e:	00003617          	auipc	a2,0x3
ffffffffc0203fa2:	d0260613          	addi	a2,a2,-766 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203fa6:	06300593          	li	a1,99
ffffffffc0203faa:	00004517          	auipc	a0,0x4
ffffffffc0203fae:	e6650513          	addi	a0,a0,-410 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203fb2:	cc8fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==5);
ffffffffc0203fb6:	00004697          	auipc	a3,0x4
ffffffffc0203fba:	f1268693          	addi	a3,a3,-238 # ffffffffc0207ec8 <default_pmm_manager+0xb90>
ffffffffc0203fbe:	00003617          	auipc	a2,0x3
ffffffffc0203fc2:	ce260613          	addi	a2,a2,-798 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203fc6:	06000593          	li	a1,96
ffffffffc0203fca:	00004517          	auipc	a0,0x4
ffffffffc0203fce:	e4650513          	addi	a0,a0,-442 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203fd2:	ca8fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==5);
ffffffffc0203fd6:	00004697          	auipc	a3,0x4
ffffffffc0203fda:	ef268693          	addi	a3,a3,-270 # ffffffffc0207ec8 <default_pmm_manager+0xb90>
ffffffffc0203fde:	00003617          	auipc	a2,0x3
ffffffffc0203fe2:	cc260613          	addi	a2,a2,-830 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0203fe6:	05d00593          	li	a1,93
ffffffffc0203fea:	00004517          	auipc	a0,0x4
ffffffffc0203fee:	e2650513          	addi	a0,a0,-474 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0203ff2:	c88fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==4);
ffffffffc0203ff6:	00004697          	auipc	a3,0x4
ffffffffc0203ffa:	c4268693          	addi	a3,a3,-958 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc0203ffe:	00003617          	auipc	a2,0x3
ffffffffc0204002:	ca260613          	addi	a2,a2,-862 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204006:	05a00593          	li	a1,90
ffffffffc020400a:	00004517          	auipc	a0,0x4
ffffffffc020400e:	e0650513          	addi	a0,a0,-506 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0204012:	c68fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==4);
ffffffffc0204016:	00004697          	auipc	a3,0x4
ffffffffc020401a:	c2268693          	addi	a3,a3,-990 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc020401e:	00003617          	auipc	a2,0x3
ffffffffc0204022:	c8260613          	addi	a2,a2,-894 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204026:	05700593          	li	a1,87
ffffffffc020402a:	00004517          	auipc	a0,0x4
ffffffffc020402e:	de650513          	addi	a0,a0,-538 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0204032:	c48fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgfault_num==4);
ffffffffc0204036:	00004697          	auipc	a3,0x4
ffffffffc020403a:	c0268693          	addi	a3,a3,-1022 # ffffffffc0207c38 <default_pmm_manager+0x900>
ffffffffc020403e:	00003617          	auipc	a2,0x3
ffffffffc0204042:	c6260613          	addi	a2,a2,-926 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204046:	05400593          	li	a1,84
ffffffffc020404a:	00004517          	auipc	a0,0x4
ffffffffc020404e:	dc650513          	addi	a0,a0,-570 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0204052:	c28fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204056 <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0204056:	751c                	ld	a5,40(a0)
{
ffffffffc0204058:	1141                	addi	sp,sp,-16
ffffffffc020405a:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc020405c:	cf91                	beqz	a5,ffffffffc0204078 <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc020405e:	ee0d                	bnez	a2,ffffffffc0204098 <_fifo_swap_out_victim+0x42>
    return listelm->next;
ffffffffc0204060:	679c                	ld	a5,8(a5)
}
ffffffffc0204062:	60a2                	ld	ra,8(sp)
ffffffffc0204064:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0204066:	6394                	ld	a3,0(a5)
ffffffffc0204068:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc020406a:	fd878793          	addi	a5,a5,-40
    prev->next = next;
ffffffffc020406e:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204070:	e314                	sd	a3,0(a4)
ffffffffc0204072:	e19c                	sd	a5,0(a1)
}
ffffffffc0204074:	0141                	addi	sp,sp,16
ffffffffc0204076:	8082                	ret
         assert(head != NULL);
ffffffffc0204078:	00004697          	auipc	a3,0x4
ffffffffc020407c:	ee868693          	addi	a3,a3,-280 # ffffffffc0207f60 <default_pmm_manager+0xc28>
ffffffffc0204080:	00003617          	auipc	a2,0x3
ffffffffc0204084:	c2060613          	addi	a2,a2,-992 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204088:	04100593          	li	a1,65
ffffffffc020408c:	00004517          	auipc	a0,0x4
ffffffffc0204090:	d8450513          	addi	a0,a0,-636 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc0204094:	be6fc0ef          	jal	ra,ffffffffc020047a <__panic>
     assert(in_tick==0);
ffffffffc0204098:	00004697          	auipc	a3,0x4
ffffffffc020409c:	ed868693          	addi	a3,a3,-296 # ffffffffc0207f70 <default_pmm_manager+0xc38>
ffffffffc02040a0:	00003617          	auipc	a2,0x3
ffffffffc02040a4:	c0060613          	addi	a2,a2,-1024 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02040a8:	04200593          	li	a1,66
ffffffffc02040ac:	00004517          	auipc	a0,0x4
ffffffffc02040b0:	d6450513          	addi	a0,a0,-668 # ffffffffc0207e10 <default_pmm_manager+0xad8>
ffffffffc02040b4:	bc6fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02040b8 <_fifo_map_swappable>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc02040b8:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc02040ba:	cb91                	beqz	a5,ffffffffc02040ce <_fifo_map_swappable+0x16>
    __list_add(elm, listelm->prev, listelm);
ffffffffc02040bc:	6394                	ld	a3,0(a5)
ffffffffc02040be:	02860713          	addi	a4,a2,40
    prev->next = next->prev = elm;
ffffffffc02040c2:	e398                	sd	a4,0(a5)
ffffffffc02040c4:	e698                	sd	a4,8(a3)
}
ffffffffc02040c6:	4501                	li	a0,0
    elm->next = next;
ffffffffc02040c8:	fa1c                	sd	a5,48(a2)
    elm->prev = prev;
ffffffffc02040ca:	f614                	sd	a3,40(a2)
ffffffffc02040cc:	8082                	ret
{
ffffffffc02040ce:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc02040d0:	00004697          	auipc	a3,0x4
ffffffffc02040d4:	eb068693          	addi	a3,a3,-336 # ffffffffc0207f80 <default_pmm_manager+0xc48>
ffffffffc02040d8:	00003617          	auipc	a2,0x3
ffffffffc02040dc:	bc860613          	addi	a2,a2,-1080 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02040e0:	03200593          	li	a1,50
ffffffffc02040e4:	00004517          	auipc	a0,0x4
ffffffffc02040e8:	d2c50513          	addi	a0,a0,-724 # ffffffffc0207e10 <default_pmm_manager+0xad8>
{
ffffffffc02040ec:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc02040ee:	b8cfc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02040f2 <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02040f2:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02040f4:	00004697          	auipc	a3,0x4
ffffffffc02040f8:	ec468693          	addi	a3,a3,-316 # ffffffffc0207fb8 <default_pmm_manager+0xc80>
ffffffffc02040fc:	00003617          	auipc	a2,0x3
ffffffffc0204100:	ba460613          	addi	a2,a2,-1116 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204104:	06d00593          	li	a1,109
ffffffffc0204108:	00004517          	auipc	a0,0x4
ffffffffc020410c:	ed050513          	addi	a0,a0,-304 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0204110:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0204112:	b68fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204116 <mm_create>:
mm_create(void) {
ffffffffc0204116:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0204118:	04000513          	li	a0,64
mm_create(void) {
ffffffffc020411c:	e022                	sd	s0,0(sp)
ffffffffc020411e:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0204120:	9d9fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc0204124:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0204126:	c505                	beqz	a0,ffffffffc020414e <mm_create+0x38>
    elm->prev = elm->next = elm;
ffffffffc0204128:	e408                	sd	a0,8(s0)
ffffffffc020412a:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc020412c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0204130:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0204134:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0204138:	000ae797          	auipc	a5,0xae
ffffffffc020413c:	6f87a783          	lw	a5,1784(a5) # ffffffffc02b2830 <swap_init_ok>
ffffffffc0204140:	ef81                	bnez	a5,ffffffffc0204158 <mm_create+0x42>
        else mm->sm_priv = NULL;
ffffffffc0204142:	02053423          	sd	zero,40(a0)
    return mm->mm_count;
}

static inline void
set_mm_count(struct mm_struct *mm, int val) {
    mm->mm_count = val;
ffffffffc0204146:	02042823          	sw	zero,48(s0)

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
    *lock = 0;
ffffffffc020414a:	02043c23          	sd	zero,56(s0)
}
ffffffffc020414e:	60a2                	ld	ra,8(sp)
ffffffffc0204150:	8522                	mv	a0,s0
ffffffffc0204152:	6402                	ld	s0,0(sp)
ffffffffc0204154:	0141                	addi	sp,sp,16
ffffffffc0204156:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0204158:	a07ff0ef          	jal	ra,ffffffffc0203b5e <swap_init_mm>
ffffffffc020415c:	b7ed                	j	ffffffffc0204146 <mm_create+0x30>

ffffffffc020415e <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc020415e:	1101                	addi	sp,sp,-32
ffffffffc0204160:	e04a                	sd	s2,0(sp)
ffffffffc0204162:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0204164:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc0204168:	e822                	sd	s0,16(sp)
ffffffffc020416a:	e426                	sd	s1,8(sp)
ffffffffc020416c:	ec06                	sd	ra,24(sp)
ffffffffc020416e:	84ae                	mv	s1,a1
ffffffffc0204170:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0204172:	987fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
    if (vma != NULL) {
ffffffffc0204176:	c509                	beqz	a0,ffffffffc0204180 <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0204178:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc020417c:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020417e:	cd00                	sw	s0,24(a0)
}
ffffffffc0204180:	60e2                	ld	ra,24(sp)
ffffffffc0204182:	6442                	ld	s0,16(sp)
ffffffffc0204184:	64a2                	ld	s1,8(sp)
ffffffffc0204186:	6902                	ld	s2,0(sp)
ffffffffc0204188:	6105                	addi	sp,sp,32
ffffffffc020418a:	8082                	ret

ffffffffc020418c <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc020418c:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc020418e:	c505                	beqz	a0,ffffffffc02041b6 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0204190:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0204192:	c501                	beqz	a0,ffffffffc020419a <find_vma+0xe>
ffffffffc0204194:	651c                	ld	a5,8(a0)
ffffffffc0204196:	02f5f263          	bgeu	a1,a5,ffffffffc02041ba <find_vma+0x2e>
    return listelm->next;
ffffffffc020419a:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc020419c:	00f68d63          	beq	a3,a5,ffffffffc02041b6 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc02041a0:	fe87b703          	ld	a4,-24(a5)
ffffffffc02041a4:	00e5e663          	bltu	a1,a4,ffffffffc02041b0 <find_vma+0x24>
ffffffffc02041a8:	ff07b703          	ld	a4,-16(a5)
ffffffffc02041ac:	00e5ec63          	bltu	a1,a4,ffffffffc02041c4 <find_vma+0x38>
ffffffffc02041b0:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc02041b2:	fef697e3          	bne	a3,a5,ffffffffc02041a0 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc02041b6:	4501                	li	a0,0
}
ffffffffc02041b8:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc02041ba:	691c                	ld	a5,16(a0)
ffffffffc02041bc:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020419a <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc02041c0:	ea88                	sd	a0,16(a3)
ffffffffc02041c2:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc02041c4:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc02041c8:	ea88                	sd	a0,16(a3)
ffffffffc02041ca:	8082                	ret

ffffffffc02041cc <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc02041cc:	6590                	ld	a2,8(a1)
ffffffffc02041ce:	0105b803          	ld	a6,16(a1) # 1010 <_binary_obj___user_faultread_out_size-0x8ba0>
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc02041d2:	1141                	addi	sp,sp,-16
ffffffffc02041d4:	e406                	sd	ra,8(sp)
ffffffffc02041d6:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc02041d8:	01066763          	bltu	a2,a6,ffffffffc02041e6 <insert_vma_struct+0x1a>
ffffffffc02041dc:	a085                	j	ffffffffc020423c <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc02041de:	fe87b703          	ld	a4,-24(a5)
ffffffffc02041e2:	04e66863          	bltu	a2,a4,ffffffffc0204232 <insert_vma_struct+0x66>
ffffffffc02041e6:	86be                	mv	a3,a5
ffffffffc02041e8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02041ea:	fef51ae3          	bne	a0,a5,ffffffffc02041de <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc02041ee:	02a68463          	beq	a3,a0,ffffffffc0204216 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02041f2:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02041f6:	fe86b883          	ld	a7,-24(a3)
ffffffffc02041fa:	08e8f163          	bgeu	a7,a4,ffffffffc020427c <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02041fe:	04e66f63          	bltu	a2,a4,ffffffffc020425c <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0204202:	00f50a63          	beq	a0,a5,ffffffffc0204216 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0204206:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020420a:	05076963          	bltu	a4,a6,ffffffffc020425c <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020420e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0204212:	02c77363          	bgeu	a4,a2,ffffffffc0204238 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0204216:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0204218:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020421a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020421e:	e390                	sd	a2,0(a5)
ffffffffc0204220:	e690                	sd	a2,8(a3)
}
ffffffffc0204222:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0204224:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0204226:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0204228:	0017079b          	addiw	a5,a4,1
ffffffffc020422c:	d11c                	sw	a5,32(a0)
}
ffffffffc020422e:	0141                	addi	sp,sp,16
ffffffffc0204230:	8082                	ret
    if (le_prev != list) {
ffffffffc0204232:	fca690e3          	bne	a3,a0,ffffffffc02041f2 <insert_vma_struct+0x26>
ffffffffc0204236:	bfd1                	j	ffffffffc020420a <insert_vma_struct+0x3e>
ffffffffc0204238:	ebbff0ef          	jal	ra,ffffffffc02040f2 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc020423c:	00004697          	auipc	a3,0x4
ffffffffc0204240:	dac68693          	addi	a3,a3,-596 # ffffffffc0207fe8 <default_pmm_manager+0xcb0>
ffffffffc0204244:	00003617          	auipc	a2,0x3
ffffffffc0204248:	a5c60613          	addi	a2,a2,-1444 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020424c:	07400593          	li	a1,116
ffffffffc0204250:	00004517          	auipc	a0,0x4
ffffffffc0204254:	d8850513          	addi	a0,a0,-632 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204258:	a22fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020425c:	00004697          	auipc	a3,0x4
ffffffffc0204260:	dcc68693          	addi	a3,a3,-564 # ffffffffc0208028 <default_pmm_manager+0xcf0>
ffffffffc0204264:	00003617          	auipc	a2,0x3
ffffffffc0204268:	a3c60613          	addi	a2,a2,-1476 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020426c:	06c00593          	li	a1,108
ffffffffc0204270:	00004517          	auipc	a0,0x4
ffffffffc0204274:	d6850513          	addi	a0,a0,-664 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204278:	a02fc0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020427c:	00004697          	auipc	a3,0x4
ffffffffc0204280:	d8c68693          	addi	a3,a3,-628 # ffffffffc0208008 <default_pmm_manager+0xcd0>
ffffffffc0204284:	00003617          	auipc	a2,0x3
ffffffffc0204288:	a1c60613          	addi	a2,a2,-1508 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020428c:	06b00593          	li	a1,107
ffffffffc0204290:	00004517          	auipc	a0,0x4
ffffffffc0204294:	d4850513          	addi	a0,a0,-696 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204298:	9e2fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020429c <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);
ffffffffc020429c:	591c                	lw	a5,48(a0)
mm_destroy(struct mm_struct *mm) {
ffffffffc020429e:	1141                	addi	sp,sp,-16
ffffffffc02042a0:	e406                	sd	ra,8(sp)
ffffffffc02042a2:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02042a4:	e78d                	bnez	a5,ffffffffc02042ce <mm_destroy+0x32>
ffffffffc02042a6:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02042a8:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc02042aa:	00a40c63          	beq	s0,a0,ffffffffc02042c2 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02042ae:	6118                	ld	a4,0(a0)
ffffffffc02042b0:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc02042b2:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02042b4:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02042b6:	e398                	sd	a4,0(a5)
ffffffffc02042b8:	8f1fd0ef          	jal	ra,ffffffffc0201ba8 <kfree>
    return listelm->next;
ffffffffc02042bc:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02042be:	fea418e3          	bne	s0,a0,ffffffffc02042ae <mm_destroy+0x12>
    }
    kfree(mm); //kfree mm
ffffffffc02042c2:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc02042c4:	6402                	ld	s0,0(sp)
ffffffffc02042c6:	60a2                	ld	ra,8(sp)
ffffffffc02042c8:	0141                	addi	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc02042ca:	8dffd06f          	j	ffffffffc0201ba8 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02042ce:	00004697          	auipc	a3,0x4
ffffffffc02042d2:	d7a68693          	addi	a3,a3,-646 # ffffffffc0208048 <default_pmm_manager+0xd10>
ffffffffc02042d6:	00003617          	auipc	a2,0x3
ffffffffc02042da:	9ca60613          	addi	a2,a2,-1590 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02042de:	09400593          	li	a1,148
ffffffffc02042e2:	00004517          	auipc	a0,0x4
ffffffffc02042e6:	cf650513          	addi	a0,a0,-778 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02042ea:	990fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02042ee <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
ffffffffc02042ee:	7139                	addi	sp,sp,-64
ffffffffc02042f0:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02042f2:	6405                	lui	s0,0x1
ffffffffc02042f4:	147d                	addi	s0,s0,-1
ffffffffc02042f6:	77fd                	lui	a5,0xfffff
ffffffffc02042f8:	9622                	add	a2,a2,s0
ffffffffc02042fa:	962e                	add	a2,a2,a1
       struct vma_struct **vma_store) {
ffffffffc02042fc:	f426                	sd	s1,40(sp)
ffffffffc02042fe:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0204300:	00f5f4b3          	and	s1,a1,a5
       struct vma_struct **vma_store) {
ffffffffc0204304:	f04a                	sd	s2,32(sp)
ffffffffc0204306:	ec4e                	sd	s3,24(sp)
ffffffffc0204308:	e852                	sd	s4,16(sp)
ffffffffc020430a:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end)) {
ffffffffc020430c:	002005b7          	lui	a1,0x200
ffffffffc0204310:	00f67433          	and	s0,a2,a5
ffffffffc0204314:	06b4e363          	bltu	s1,a1,ffffffffc020437a <mm_map+0x8c>
ffffffffc0204318:	0684f163          	bgeu	s1,s0,ffffffffc020437a <mm_map+0x8c>
ffffffffc020431c:	4785                	li	a5,1
ffffffffc020431e:	07fe                	slli	a5,a5,0x1f
ffffffffc0204320:	0487ed63          	bltu	a5,s0,ffffffffc020437a <mm_map+0x8c>
ffffffffc0204324:	89aa                	mv	s3,a0
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0204326:	cd21                	beqz	a0,ffffffffc020437e <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
ffffffffc0204328:	85a6                	mv	a1,s1
ffffffffc020432a:	8ab6                	mv	s5,a3
ffffffffc020432c:	8a3a                	mv	s4,a4
ffffffffc020432e:	e5fff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc0204332:	c501                	beqz	a0,ffffffffc020433a <mm_map+0x4c>
ffffffffc0204334:	651c                	ld	a5,8(a0)
ffffffffc0204336:	0487e263          	bltu	a5,s0,ffffffffc020437a <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020433a:	03000513          	li	a0,48
ffffffffc020433e:	fbafd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc0204342:	892a                	mv	s2,a0
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0204344:	5571                	li	a0,-4
    if (vma != NULL) {
ffffffffc0204346:	02090163          	beqz	s2,ffffffffc0204368 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc020434a:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc020434c:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0204350:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0204354:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0204358:	85ca                	mv	a1,s2
ffffffffc020435a:	e73ff0ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc020435e:	4501                	li	a0,0
    if (vma_store != NULL) {
ffffffffc0204360:	000a0463          	beqz	s4,ffffffffc0204368 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0204364:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0204368:	70e2                	ld	ra,56(sp)
ffffffffc020436a:	7442                	ld	s0,48(sp)
ffffffffc020436c:	74a2                	ld	s1,40(sp)
ffffffffc020436e:	7902                	ld	s2,32(sp)
ffffffffc0204370:	69e2                	ld	s3,24(sp)
ffffffffc0204372:	6a42                	ld	s4,16(sp)
ffffffffc0204374:	6aa2                	ld	s5,8(sp)
ffffffffc0204376:	6121                	addi	sp,sp,64
ffffffffc0204378:	8082                	ret
        return -E_INVAL;
ffffffffc020437a:	5575                	li	a0,-3
ffffffffc020437c:	b7f5                	j	ffffffffc0204368 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc020437e:	00003697          	auipc	a3,0x3
ffffffffc0204382:	74268693          	addi	a3,a3,1858 # ffffffffc0207ac0 <default_pmm_manager+0x788>
ffffffffc0204386:	00003617          	auipc	a2,0x3
ffffffffc020438a:	91a60613          	addi	a2,a2,-1766 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020438e:	0a700593          	li	a1,167
ffffffffc0204392:	00004517          	auipc	a0,0x4
ffffffffc0204396:	c4650513          	addi	a0,a0,-954 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020439a:	8e0fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020439e <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
ffffffffc020439e:	7139                	addi	sp,sp,-64
ffffffffc02043a0:	fc06                	sd	ra,56(sp)
ffffffffc02043a2:	f822                	sd	s0,48(sp)
ffffffffc02043a4:	f426                	sd	s1,40(sp)
ffffffffc02043a6:	f04a                	sd	s2,32(sp)
ffffffffc02043a8:	ec4e                	sd	s3,24(sp)
ffffffffc02043aa:	e852                	sd	s4,16(sp)
ffffffffc02043ac:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02043ae:	c52d                	beqz	a0,ffffffffc0204418 <dup_mmap+0x7a>
ffffffffc02043b0:	892a                	mv	s2,a0
ffffffffc02043b2:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02043b4:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02043b6:	e595                	bnez	a1,ffffffffc02043e2 <dup_mmap+0x44>
ffffffffc02043b8:	a085                	j	ffffffffc0204418 <dup_mmap+0x7a>
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL) {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02043ba:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc02043bc:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ee0>
        vma->vm_end = vm_end;
ffffffffc02043c0:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc02043c4:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc02043c8:	e05ff0ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
ffffffffc02043cc:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc02043d0:	fe843603          	ld	a2,-24(s0)
ffffffffc02043d4:	6c8c                	ld	a1,24(s1)
ffffffffc02043d6:	01893503          	ld	a0,24(s2)
ffffffffc02043da:	4701                	li	a4,0
ffffffffc02043dc:	d31fe0ef          	jal	ra,ffffffffc020310c <copy_range>
ffffffffc02043e0:	e105                	bnez	a0,ffffffffc0204400 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc02043e2:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list) {
ffffffffc02043e4:	02848863          	beq	s1,s0,ffffffffc0204414 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02043e8:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02043ec:	fe843a83          	ld	s5,-24(s0)
ffffffffc02043f0:	ff043a03          	ld	s4,-16(s0)
ffffffffc02043f4:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02043f8:	f00fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc02043fc:	85aa                	mv	a1,a0
    if (vma != NULL) {
ffffffffc02043fe:	fd55                	bnez	a0,ffffffffc02043ba <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0204400:	5571                	li	a0,-4
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0204402:	70e2                	ld	ra,56(sp)
ffffffffc0204404:	7442                	ld	s0,48(sp)
ffffffffc0204406:	74a2                	ld	s1,40(sp)
ffffffffc0204408:	7902                	ld	s2,32(sp)
ffffffffc020440a:	69e2                	ld	s3,24(sp)
ffffffffc020440c:	6a42                	ld	s4,16(sp)
ffffffffc020440e:	6aa2                	ld	s5,8(sp)
ffffffffc0204410:	6121                	addi	sp,sp,64
ffffffffc0204412:	8082                	ret
    return 0;
ffffffffc0204414:	4501                	li	a0,0
ffffffffc0204416:	b7f5                	j	ffffffffc0204402 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0204418:	00004697          	auipc	a3,0x4
ffffffffc020441c:	c4868693          	addi	a3,a3,-952 # ffffffffc0208060 <default_pmm_manager+0xd28>
ffffffffc0204420:	00003617          	auipc	a2,0x3
ffffffffc0204424:	88060613          	addi	a2,a2,-1920 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204428:	0c000593          	li	a1,192
ffffffffc020442c:	00004517          	auipc	a0,0x4
ffffffffc0204430:	bac50513          	addi	a0,a0,-1108 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204434:	846fc0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204438 <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
ffffffffc0204438:	1101                	addi	sp,sp,-32
ffffffffc020443a:	ec06                	sd	ra,24(sp)
ffffffffc020443c:	e822                	sd	s0,16(sp)
ffffffffc020443e:	e426                	sd	s1,8(sp)
ffffffffc0204440:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0204442:	c531                	beqz	a0,ffffffffc020448e <exit_mmap+0x56>
ffffffffc0204444:	591c                	lw	a5,48(a0)
ffffffffc0204446:	84aa                	mv	s1,a0
ffffffffc0204448:	e3b9                	bnez	a5,ffffffffc020448e <exit_mmap+0x56>
    return listelm->next;
ffffffffc020444a:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc020444c:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
ffffffffc0204450:	02850663          	beq	a0,s0,ffffffffc020447c <exit_mmap+0x44>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0204454:	ff043603          	ld	a2,-16(s0)
ffffffffc0204458:	fe843583          	ld	a1,-24(s0)
ffffffffc020445c:	854a                	mv	a0,s2
ffffffffc020445e:	babfd0ef          	jal	ra,ffffffffc0202008 <unmap_range>
ffffffffc0204462:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0204464:	fe8498e3          	bne	s1,s0,ffffffffc0204454 <exit_mmap+0x1c>
ffffffffc0204468:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list) {
ffffffffc020446a:	00848c63          	beq	s1,s0,ffffffffc0204482 <exit_mmap+0x4a>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc020446e:	ff043603          	ld	a2,-16(s0)
ffffffffc0204472:	fe843583          	ld	a1,-24(s0)
ffffffffc0204476:	854a                	mv	a0,s2
ffffffffc0204478:	cd7fd0ef          	jal	ra,ffffffffc020214e <exit_range>
ffffffffc020447c:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc020447e:	fe8498e3          	bne	s1,s0,ffffffffc020446e <exit_mmap+0x36>
    }
}
ffffffffc0204482:	60e2                	ld	ra,24(sp)
ffffffffc0204484:	6442                	ld	s0,16(sp)
ffffffffc0204486:	64a2                	ld	s1,8(sp)
ffffffffc0204488:	6902                	ld	s2,0(sp)
ffffffffc020448a:	6105                	addi	sp,sp,32
ffffffffc020448c:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc020448e:	00004697          	auipc	a3,0x4
ffffffffc0204492:	bf268693          	addi	a3,a3,-1038 # ffffffffc0208080 <default_pmm_manager+0xd48>
ffffffffc0204496:	00003617          	auipc	a2,0x3
ffffffffc020449a:	80a60613          	addi	a2,a2,-2038 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020449e:	0d600593          	li	a1,214
ffffffffc02044a2:	00004517          	auipc	a0,0x4
ffffffffc02044a6:	b3650513          	addi	a0,a0,-1226 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02044aa:	fd1fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02044ae <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc02044ae:	7139                	addi	sp,sp,-64
ffffffffc02044b0:	f822                	sd	s0,48(sp)
ffffffffc02044b2:	f426                	sd	s1,40(sp)
ffffffffc02044b4:	fc06                	sd	ra,56(sp)
ffffffffc02044b6:	f04a                	sd	s2,32(sp)
ffffffffc02044b8:	ec4e                	sd	s3,24(sp)
ffffffffc02044ba:	e852                	sd	s4,16(sp)
ffffffffc02044bc:	e456                	sd	s5,8(sp)

static void
check_vma_struct(void) {
    // size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
ffffffffc02044be:	c59ff0ef          	jal	ra,ffffffffc0204116 <mm_create>
    assert(mm != NULL);
ffffffffc02044c2:	84aa                	mv	s1,a0
ffffffffc02044c4:	03200413          	li	s0,50
ffffffffc02044c8:	e919                	bnez	a0,ffffffffc02044de <vmm_init+0x30>
ffffffffc02044ca:	a991                	j	ffffffffc020491e <vmm_init+0x470>
        vma->vm_start = vm_start;
ffffffffc02044cc:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02044ce:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02044d0:	00052c23          	sw	zero,24(a0)

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
ffffffffc02044d4:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02044d6:	8526                	mv	a0,s1
ffffffffc02044d8:	cf5ff0ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc02044dc:	c80d                	beqz	s0,ffffffffc020450e <vmm_init+0x60>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02044de:	03000513          	li	a0,48
ffffffffc02044e2:	e16fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc02044e6:	85aa                	mv	a1,a0
ffffffffc02044e8:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc02044ec:	f165                	bnez	a0,ffffffffc02044cc <vmm_init+0x1e>
        assert(vma != NULL);
ffffffffc02044ee:	00003697          	auipc	a3,0x3
ffffffffc02044f2:	60a68693          	addi	a3,a3,1546 # ffffffffc0207af8 <default_pmm_manager+0x7c0>
ffffffffc02044f6:	00002617          	auipc	a2,0x2
ffffffffc02044fa:	7aa60613          	addi	a2,a2,1962 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02044fe:	11300593          	li	a1,275
ffffffffc0204502:	00004517          	auipc	a0,0x4
ffffffffc0204506:	ad650513          	addi	a0,a0,-1322 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020450a:	f71fb0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc020450e:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0204512:	1f900913          	li	s2,505
ffffffffc0204516:	a819                	j	ffffffffc020452c <vmm_init+0x7e>
        vma->vm_start = vm_start;
ffffffffc0204518:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc020451a:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020451c:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0204520:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0204522:	8526                	mv	a0,s1
ffffffffc0204524:	ca9ff0ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0204528:	03240a63          	beq	s0,s2,ffffffffc020455c <vmm_init+0xae>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020452c:	03000513          	li	a0,48
ffffffffc0204530:	dc8fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc0204534:	85aa                	mv	a1,a0
ffffffffc0204536:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc020453a:	fd79                	bnez	a0,ffffffffc0204518 <vmm_init+0x6a>
        assert(vma != NULL);
ffffffffc020453c:	00003697          	auipc	a3,0x3
ffffffffc0204540:	5bc68693          	addi	a3,a3,1468 # ffffffffc0207af8 <default_pmm_manager+0x7c0>
ffffffffc0204544:	00002617          	auipc	a2,0x2
ffffffffc0204548:	75c60613          	addi	a2,a2,1884 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020454c:	11900593          	li	a1,281
ffffffffc0204550:	00004517          	auipc	a0,0x4
ffffffffc0204554:	a8850513          	addi	a0,a0,-1400 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204558:	f23fb0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc020455c:	649c                	ld	a5,8(s1)
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
        assert(le != &(mm->mmap_list));
ffffffffc020455e:	471d                	li	a4,7
    for (i = 1; i <= step2; i ++) {
ffffffffc0204560:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0204564:	2cf48d63          	beq	s1,a5,ffffffffc020483e <vmm_init+0x390>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0204568:	fe87b683          	ld	a3,-24(a5) # ffffffffffffefe8 <end+0x3fd4c784>
ffffffffc020456c:	ffe70613          	addi	a2,a4,-2
ffffffffc0204570:	24d61763          	bne	a2,a3,ffffffffc02047be <vmm_init+0x310>
ffffffffc0204574:	ff07b683          	ld	a3,-16(a5)
ffffffffc0204578:	24e69363          	bne	a3,a4,ffffffffc02047be <vmm_init+0x310>
    for (i = 1; i <= step2; i ++) {
ffffffffc020457c:	0715                	addi	a4,a4,5
ffffffffc020457e:	679c                	ld	a5,8(a5)
ffffffffc0204580:	feb712e3          	bne	a4,a1,ffffffffc0204564 <vmm_init+0xb6>
ffffffffc0204584:	4a1d                	li	s4,7
ffffffffc0204586:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0204588:	1f900a93          	li	s5,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc020458c:	85a2                	mv	a1,s0
ffffffffc020458e:	8526                	mv	a0,s1
ffffffffc0204590:	bfdff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc0204594:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0204596:	30050463          	beqz	a0,ffffffffc020489e <vmm_init+0x3f0>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc020459a:	00140593          	addi	a1,s0,1
ffffffffc020459e:	8526                	mv	a0,s1
ffffffffc02045a0:	bedff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc02045a4:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc02045a6:	2c050c63          	beqz	a0,ffffffffc020487e <vmm_init+0x3d0>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc02045aa:	85d2                	mv	a1,s4
ffffffffc02045ac:	8526                	mv	a0,s1
ffffffffc02045ae:	bdfff0ef          	jal	ra,ffffffffc020418c <find_vma>
        assert(vma3 == NULL);
ffffffffc02045b2:	2a051663          	bnez	a0,ffffffffc020485e <vmm_init+0x3b0>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc02045b6:	00340593          	addi	a1,s0,3
ffffffffc02045ba:	8526                	mv	a0,s1
ffffffffc02045bc:	bd1ff0ef          	jal	ra,ffffffffc020418c <find_vma>
        assert(vma4 == NULL);
ffffffffc02045c0:	30051f63          	bnez	a0,ffffffffc02048de <vmm_init+0x430>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc02045c4:	00440593          	addi	a1,s0,4
ffffffffc02045c8:	8526                	mv	a0,s1
ffffffffc02045ca:	bc3ff0ef          	jal	ra,ffffffffc020418c <find_vma>
        assert(vma5 == NULL);
ffffffffc02045ce:	2e051863          	bnez	a0,ffffffffc02048be <vmm_init+0x410>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc02045d2:	00893783          	ld	a5,8(s2)
ffffffffc02045d6:	20879463          	bne	a5,s0,ffffffffc02047de <vmm_init+0x330>
ffffffffc02045da:	01093783          	ld	a5,16(s2)
ffffffffc02045de:	20fa1063          	bne	s4,a5,ffffffffc02047de <vmm_init+0x330>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc02045e2:	0089b783          	ld	a5,8(s3)
ffffffffc02045e6:	20879c63          	bne	a5,s0,ffffffffc02047fe <vmm_init+0x350>
ffffffffc02045ea:	0109b783          	ld	a5,16(s3)
ffffffffc02045ee:	20fa1863          	bne	s4,a5,ffffffffc02047fe <vmm_init+0x350>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc02045f2:	0415                	addi	s0,s0,5
ffffffffc02045f4:	0a15                	addi	s4,s4,5
ffffffffc02045f6:	f9541be3          	bne	s0,s5,ffffffffc020458c <vmm_init+0xde>
ffffffffc02045fa:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc02045fc:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc02045fe:	85a2                	mv	a1,s0
ffffffffc0204600:	8526                	mv	a0,s1
ffffffffc0204602:	b8bff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc0204606:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc020460a:	c90d                	beqz	a0,ffffffffc020463c <vmm_init+0x18e>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc020460c:	6914                	ld	a3,16(a0)
ffffffffc020460e:	6510                	ld	a2,8(a0)
ffffffffc0204610:	00004517          	auipc	a0,0x4
ffffffffc0204614:	b9050513          	addi	a0,a0,-1136 # ffffffffc02081a0 <default_pmm_manager+0xe68>
ffffffffc0204618:	b69fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc020461c:	00004697          	auipc	a3,0x4
ffffffffc0204620:	bac68693          	addi	a3,a3,-1108 # ffffffffc02081c8 <default_pmm_manager+0xe90>
ffffffffc0204624:	00002617          	auipc	a2,0x2
ffffffffc0204628:	67c60613          	addi	a2,a2,1660 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020462c:	13b00593          	li	a1,315
ffffffffc0204630:	00004517          	auipc	a0,0x4
ffffffffc0204634:	9a850513          	addi	a0,a0,-1624 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204638:	e43fb0ef          	jal	ra,ffffffffc020047a <__panic>
    for (i =4; i>=0; i--) {
ffffffffc020463c:	147d                	addi	s0,s0,-1
ffffffffc020463e:	fd2410e3          	bne	s0,s2,ffffffffc02045fe <vmm_init+0x150>
    }

    mm_destroy(mm);
ffffffffc0204642:	8526                	mv	a0,s1
ffffffffc0204644:	c59ff0ef          	jal	ra,ffffffffc020429c <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0204648:	00004517          	auipc	a0,0x4
ffffffffc020464c:	b9850513          	addi	a0,a0,-1128 # ffffffffc02081e0 <default_pmm_manager+0xea8>
ffffffffc0204650:	b31fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204654:	f54fd0ef          	jal	ra,ffffffffc0201da8 <nr_free_pages>
ffffffffc0204658:	892a                	mv	s2,a0

    check_mm_struct = mm_create();
ffffffffc020465a:	abdff0ef          	jal	ra,ffffffffc0204116 <mm_create>
ffffffffc020465e:	000ae797          	auipc	a5,0xae
ffffffffc0204662:	1ca7bd23          	sd	a0,474(a5) # ffffffffc02b2838 <check_mm_struct>
ffffffffc0204666:	842a                	mv	s0,a0
    assert(check_mm_struct != NULL);
ffffffffc0204668:	28050b63          	beqz	a0,ffffffffc02048fe <vmm_init+0x450>

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc020466c:	000ae497          	auipc	s1,0xae
ffffffffc0204670:	18c4b483          	ld	s1,396(s1) # ffffffffc02b27f8 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0204674:	609c                	ld	a5,0(s1)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0204676:	ed04                	sd	s1,24(a0)
    assert(pgdir[0] == 0);
ffffffffc0204678:	2e079f63          	bnez	a5,ffffffffc0204976 <vmm_init+0x4c8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020467c:	03000513          	li	a0,48
ffffffffc0204680:	c78fd0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc0204684:	89aa                	mv	s3,a0
    if (vma != NULL) {
ffffffffc0204686:	18050c63          	beqz	a0,ffffffffc020481e <vmm_init+0x370>
        vma->vm_end = vm_end;
ffffffffc020468a:	002007b7          	lui	a5,0x200
ffffffffc020468e:	00f9b823          	sd	a5,16(s3)
        vma->vm_flags = vm_flags;
ffffffffc0204692:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc0204694:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0204696:	00f9ac23          	sw	a5,24(s3)
    insert_vma_struct(mm, vma);
ffffffffc020469a:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc020469c:	0009b423          	sd	zero,8(s3)
    insert_vma_struct(mm, vma);
ffffffffc02046a0:	b2dff0ef          	jal	ra,ffffffffc02041cc <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc02046a4:	10000593          	li	a1,256
ffffffffc02046a8:	8522                	mv	a0,s0
ffffffffc02046aa:	ae3ff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc02046ae:	10000793          	li	a5,256

    int i, sum = 0;

    for (i = 0; i < 100; i ++) {
ffffffffc02046b2:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc02046b6:	2ea99063          	bne	s3,a0,ffffffffc0204996 <vmm_init+0x4e8>
        *(char *)(addr + i) = i;
ffffffffc02046ba:	00f78023          	sb	a5,0(a5) # 200000 <_binary_obj___user_exit_out_size+0x1f4ed8>
    for (i = 0; i < 100; i ++) {
ffffffffc02046be:	0785                	addi	a5,a5,1
ffffffffc02046c0:	fee79de3          	bne	a5,a4,ffffffffc02046ba <vmm_init+0x20c>
        sum += i;
ffffffffc02046c4:	6705                	lui	a4,0x1
ffffffffc02046c6:	10000793          	li	a5,256
ffffffffc02046ca:	35670713          	addi	a4,a4,854 # 1356 <_binary_obj___user_faultread_out_size-0x885a>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc02046ce:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc02046d2:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc02046d6:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc02046d8:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc02046da:	fec79ce3          	bne	a5,a2,ffffffffc02046d2 <vmm_init+0x224>
    }

    assert(sum == 0);
ffffffffc02046de:	2e071863          	bnez	a4,ffffffffc02049ce <vmm_init+0x520>
    return pa2page(PDE_ADDR(pde));
ffffffffc02046e2:	609c                	ld	a5,0(s1)
    if (PPN(pa) >= npage) {
ffffffffc02046e4:	000aea97          	auipc	s5,0xae
ffffffffc02046e8:	11ca8a93          	addi	s5,s5,284 # ffffffffc02b2800 <npage>
ffffffffc02046ec:	000ab603          	ld	a2,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02046f0:	078a                	slli	a5,a5,0x2
ffffffffc02046f2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02046f4:	2cc7f163          	bgeu	a5,a2,ffffffffc02049b6 <vmm_init+0x508>
    return &pages[PPN(pa) - nbase];
ffffffffc02046f8:	00004a17          	auipc	s4,0x4
ffffffffc02046fc:	630a3a03          	ld	s4,1584(s4) # ffffffffc0208d28 <nbase>
ffffffffc0204700:	414787b3          	sub	a5,a5,s4
ffffffffc0204704:	079a                	slli	a5,a5,0x6
    return page - pages + nbase;
ffffffffc0204706:	8799                	srai	a5,a5,0x6
ffffffffc0204708:	97d2                	add	a5,a5,s4
    return KADDR(page2pa(page));
ffffffffc020470a:	00c79713          	slli	a4,a5,0xc
ffffffffc020470e:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204710:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0204714:	24c77563          	bgeu	a4,a2,ffffffffc020495e <vmm_init+0x4b0>
ffffffffc0204718:	000ae997          	auipc	s3,0xae
ffffffffc020471c:	1009b983          	ld	s3,256(s3) # ffffffffc02b2818 <va_pa_offset>

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc0204720:	4581                	li	a1,0
ffffffffc0204722:	8526                	mv	a0,s1
ffffffffc0204724:	99b6                	add	s3,s3,a3
ffffffffc0204726:	cbbfd0ef          	jal	ra,ffffffffc02023e0 <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc020472a:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc020472e:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0204732:	078a                	slli	a5,a5,0x2
ffffffffc0204734:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0204736:	28e7f063          	bgeu	a5,a4,ffffffffc02049b6 <vmm_init+0x508>
    return &pages[PPN(pa) - nbase];
ffffffffc020473a:	000ae997          	auipc	s3,0xae
ffffffffc020473e:	0ce98993          	addi	s3,s3,206 # ffffffffc02b2808 <pages>
ffffffffc0204742:	0009b503          	ld	a0,0(s3)
ffffffffc0204746:	414787b3          	sub	a5,a5,s4
ffffffffc020474a:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd0[0]));
ffffffffc020474c:	953e                	add	a0,a0,a5
ffffffffc020474e:	4585                	li	a1,1
ffffffffc0204750:	e18fd0ef          	jal	ra,ffffffffc0201d68 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0204754:	609c                	ld	a5,0(s1)
    if (PPN(pa) >= npage) {
ffffffffc0204756:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020475a:	078a                	slli	a5,a5,0x2
ffffffffc020475c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020475e:	24e7fc63          	bgeu	a5,a4,ffffffffc02049b6 <vmm_init+0x508>
    return &pages[PPN(pa) - nbase];
ffffffffc0204762:	0009b503          	ld	a0,0(s3)
ffffffffc0204766:	414787b3          	sub	a5,a5,s4
ffffffffc020476a:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc020476c:	4585                	li	a1,1
ffffffffc020476e:	953e                	add	a0,a0,a5
ffffffffc0204770:	df8fd0ef          	jal	ra,ffffffffc0201d68 <free_pages>
    pgdir[0] = 0;
ffffffffc0204774:	0004b023          	sd	zero,0(s1)
  asm volatile("sfence.vma");
ffffffffc0204778:	12000073          	sfence.vma
    flush_tlb();

    mm->pgdir = NULL;
    mm_destroy(mm);
ffffffffc020477c:	8522                	mv	a0,s0
    mm->pgdir = NULL;
ffffffffc020477e:	00043c23          	sd	zero,24(s0)
    mm_destroy(mm);
ffffffffc0204782:	b1bff0ef          	jal	ra,ffffffffc020429c <mm_destroy>
    check_mm_struct = NULL;
ffffffffc0204786:	000ae797          	auipc	a5,0xae
ffffffffc020478a:	0a07b923          	sd	zero,178(a5) # ffffffffc02b2838 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020478e:	e1afd0ef          	jal	ra,ffffffffc0201da8 <nr_free_pages>
ffffffffc0204792:	1aa91663          	bne	s2,a0,ffffffffc020493e <vmm_init+0x490>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc0204796:	00004517          	auipc	a0,0x4
ffffffffc020479a:	ada50513          	addi	a0,a0,-1318 # ffffffffc0208270 <default_pmm_manager+0xf38>
ffffffffc020479e:	9e3fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc02047a2:	7442                	ld	s0,48(sp)
ffffffffc02047a4:	70e2                	ld	ra,56(sp)
ffffffffc02047a6:	74a2                	ld	s1,40(sp)
ffffffffc02047a8:	7902                	ld	s2,32(sp)
ffffffffc02047aa:	69e2                	ld	s3,24(sp)
ffffffffc02047ac:	6a42                	ld	s4,16(sp)
ffffffffc02047ae:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc02047b0:	00004517          	auipc	a0,0x4
ffffffffc02047b4:	ae050513          	addi	a0,a0,-1312 # ffffffffc0208290 <default_pmm_manager+0xf58>
}
ffffffffc02047b8:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc02047ba:	9c7fb06f          	j	ffffffffc0200180 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02047be:	00004697          	auipc	a3,0x4
ffffffffc02047c2:	8fa68693          	addi	a3,a3,-1798 # ffffffffc02080b8 <default_pmm_manager+0xd80>
ffffffffc02047c6:	00002617          	auipc	a2,0x2
ffffffffc02047ca:	4da60613          	addi	a2,a2,1242 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02047ce:	12200593          	li	a1,290
ffffffffc02047d2:	00004517          	auipc	a0,0x4
ffffffffc02047d6:	80650513          	addi	a0,a0,-2042 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02047da:	ca1fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc02047de:	00004697          	auipc	a3,0x4
ffffffffc02047e2:	96268693          	addi	a3,a3,-1694 # ffffffffc0208140 <default_pmm_manager+0xe08>
ffffffffc02047e6:	00002617          	auipc	a2,0x2
ffffffffc02047ea:	4ba60613          	addi	a2,a2,1210 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02047ee:	13200593          	li	a1,306
ffffffffc02047f2:	00003517          	auipc	a0,0x3
ffffffffc02047f6:	7e650513          	addi	a0,a0,2022 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02047fa:	c81fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc02047fe:	00004697          	auipc	a3,0x4
ffffffffc0204802:	97268693          	addi	a3,a3,-1678 # ffffffffc0208170 <default_pmm_manager+0xe38>
ffffffffc0204806:	00002617          	auipc	a2,0x2
ffffffffc020480a:	49a60613          	addi	a2,a2,1178 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020480e:	13300593          	li	a1,307
ffffffffc0204812:	00003517          	auipc	a0,0x3
ffffffffc0204816:	7c650513          	addi	a0,a0,1990 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020481a:	c61fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(vma != NULL);
ffffffffc020481e:	00003697          	auipc	a3,0x3
ffffffffc0204822:	2da68693          	addi	a3,a3,730 # ffffffffc0207af8 <default_pmm_manager+0x7c0>
ffffffffc0204826:	00002617          	auipc	a2,0x2
ffffffffc020482a:	47a60613          	addi	a2,a2,1146 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020482e:	15200593          	li	a1,338
ffffffffc0204832:	00003517          	auipc	a0,0x3
ffffffffc0204836:	7a650513          	addi	a0,a0,1958 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020483a:	c41fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc020483e:	00004697          	auipc	a3,0x4
ffffffffc0204842:	86268693          	addi	a3,a3,-1950 # ffffffffc02080a0 <default_pmm_manager+0xd68>
ffffffffc0204846:	00002617          	auipc	a2,0x2
ffffffffc020484a:	45a60613          	addi	a2,a2,1114 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020484e:	12000593          	li	a1,288
ffffffffc0204852:	00003517          	auipc	a0,0x3
ffffffffc0204856:	78650513          	addi	a0,a0,1926 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020485a:	c21fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma3 == NULL);
ffffffffc020485e:	00004697          	auipc	a3,0x4
ffffffffc0204862:	8b268693          	addi	a3,a3,-1870 # ffffffffc0208110 <default_pmm_manager+0xdd8>
ffffffffc0204866:	00002617          	auipc	a2,0x2
ffffffffc020486a:	43a60613          	addi	a2,a2,1082 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020486e:	12c00593          	li	a1,300
ffffffffc0204872:	00003517          	auipc	a0,0x3
ffffffffc0204876:	76650513          	addi	a0,a0,1894 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020487a:	c01fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma2 != NULL);
ffffffffc020487e:	00004697          	auipc	a3,0x4
ffffffffc0204882:	88268693          	addi	a3,a3,-1918 # ffffffffc0208100 <default_pmm_manager+0xdc8>
ffffffffc0204886:	00002617          	auipc	a2,0x2
ffffffffc020488a:	41a60613          	addi	a2,a2,1050 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020488e:	12a00593          	li	a1,298
ffffffffc0204892:	00003517          	auipc	a0,0x3
ffffffffc0204896:	74650513          	addi	a0,a0,1862 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020489a:	be1fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma1 != NULL);
ffffffffc020489e:	00004697          	auipc	a3,0x4
ffffffffc02048a2:	85268693          	addi	a3,a3,-1966 # ffffffffc02080f0 <default_pmm_manager+0xdb8>
ffffffffc02048a6:	00002617          	auipc	a2,0x2
ffffffffc02048aa:	3fa60613          	addi	a2,a2,1018 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02048ae:	12800593          	li	a1,296
ffffffffc02048b2:	00003517          	auipc	a0,0x3
ffffffffc02048b6:	72650513          	addi	a0,a0,1830 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02048ba:	bc1fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma5 == NULL);
ffffffffc02048be:	00004697          	auipc	a3,0x4
ffffffffc02048c2:	87268693          	addi	a3,a3,-1934 # ffffffffc0208130 <default_pmm_manager+0xdf8>
ffffffffc02048c6:	00002617          	auipc	a2,0x2
ffffffffc02048ca:	3da60613          	addi	a2,a2,986 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02048ce:	13000593          	li	a1,304
ffffffffc02048d2:	00003517          	auipc	a0,0x3
ffffffffc02048d6:	70650513          	addi	a0,a0,1798 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02048da:	ba1fb0ef          	jal	ra,ffffffffc020047a <__panic>
        assert(vma4 == NULL);
ffffffffc02048de:	00004697          	auipc	a3,0x4
ffffffffc02048e2:	84268693          	addi	a3,a3,-1982 # ffffffffc0208120 <default_pmm_manager+0xde8>
ffffffffc02048e6:	00002617          	auipc	a2,0x2
ffffffffc02048ea:	3ba60613          	addi	a2,a2,954 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02048ee:	12e00593          	li	a1,302
ffffffffc02048f2:	00003517          	auipc	a0,0x3
ffffffffc02048f6:	6e650513          	addi	a0,a0,1766 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02048fa:	b81fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(check_mm_struct != NULL);
ffffffffc02048fe:	00004697          	auipc	a3,0x4
ffffffffc0204902:	90268693          	addi	a3,a3,-1790 # ffffffffc0208200 <default_pmm_manager+0xec8>
ffffffffc0204906:	00002617          	auipc	a2,0x2
ffffffffc020490a:	39a60613          	addi	a2,a2,922 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020490e:	14b00593          	li	a1,331
ffffffffc0204912:	00003517          	auipc	a0,0x3
ffffffffc0204916:	6c650513          	addi	a0,a0,1734 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020491a:	b61fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(mm != NULL);
ffffffffc020491e:	00003697          	auipc	a3,0x3
ffffffffc0204922:	1a268693          	addi	a3,a3,418 # ffffffffc0207ac0 <default_pmm_manager+0x788>
ffffffffc0204926:	00002617          	auipc	a2,0x2
ffffffffc020492a:	37a60613          	addi	a2,a2,890 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020492e:	10c00593          	li	a1,268
ffffffffc0204932:	00003517          	auipc	a0,0x3
ffffffffc0204936:	6a650513          	addi	a0,a0,1702 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020493a:	b41fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020493e:	00004697          	auipc	a3,0x4
ffffffffc0204942:	90a68693          	addi	a3,a3,-1782 # ffffffffc0208248 <default_pmm_manager+0xf10>
ffffffffc0204946:	00002617          	auipc	a2,0x2
ffffffffc020494a:	35a60613          	addi	a2,a2,858 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020494e:	17000593          	li	a1,368
ffffffffc0204952:	00003517          	auipc	a0,0x3
ffffffffc0204956:	68650513          	addi	a0,a0,1670 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc020495a:	b21fb0ef          	jal	ra,ffffffffc020047a <__panic>
    return KADDR(page2pa(page));
ffffffffc020495e:	00003617          	auipc	a2,0x3
ffffffffc0204962:	a1260613          	addi	a2,a2,-1518 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0204966:	06900593          	li	a1,105
ffffffffc020496a:	00003517          	auipc	a0,0x3
ffffffffc020496e:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0204972:	b09fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgdir[0] == 0);
ffffffffc0204976:	00003697          	auipc	a3,0x3
ffffffffc020497a:	17268693          	addi	a3,a3,370 # ffffffffc0207ae8 <default_pmm_manager+0x7b0>
ffffffffc020497e:	00002617          	auipc	a2,0x2
ffffffffc0204982:	32260613          	addi	a2,a2,802 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0204986:	14f00593          	li	a1,335
ffffffffc020498a:	00003517          	auipc	a0,0x3
ffffffffc020498e:	64e50513          	addi	a0,a0,1614 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc0204992:	ae9fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0204996:	00004697          	auipc	a3,0x4
ffffffffc020499a:	88268693          	addi	a3,a3,-1918 # ffffffffc0208218 <default_pmm_manager+0xee0>
ffffffffc020499e:	00002617          	auipc	a2,0x2
ffffffffc02049a2:	30260613          	addi	a2,a2,770 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02049a6:	15700593          	li	a1,343
ffffffffc02049aa:	00003517          	auipc	a0,0x3
ffffffffc02049ae:	62e50513          	addi	a0,a0,1582 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02049b2:	ac9fb0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02049b6:	00003617          	auipc	a2,0x3
ffffffffc02049ba:	a8a60613          	addi	a2,a2,-1398 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc02049be:	06200593          	li	a1,98
ffffffffc02049c2:	00003517          	auipc	a0,0x3
ffffffffc02049c6:	9d650513          	addi	a0,a0,-1578 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc02049ca:	ab1fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(sum == 0);
ffffffffc02049ce:	00004697          	auipc	a3,0x4
ffffffffc02049d2:	86a68693          	addi	a3,a3,-1942 # ffffffffc0208238 <default_pmm_manager+0xf00>
ffffffffc02049d6:	00002617          	auipc	a2,0x2
ffffffffc02049da:	2ca60613          	addi	a2,a2,714 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02049de:	16300593          	li	a1,355
ffffffffc02049e2:	00003517          	auipc	a0,0x3
ffffffffc02049e6:	5f650513          	addi	a0,a0,1526 # ffffffffc0207fd8 <default_pmm_manager+0xca0>
ffffffffc02049ea:	a91fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02049ee <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02049ee:	7179                	addi	sp,sp,-48
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02049f0:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02049f2:	f022                	sd	s0,32(sp)
ffffffffc02049f4:	ec26                	sd	s1,24(sp)
ffffffffc02049f6:	f406                	sd	ra,40(sp)
ffffffffc02049f8:	e84a                	sd	s2,16(sp)
ffffffffc02049fa:	8432                	mv	s0,a2
ffffffffc02049fc:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02049fe:	f8eff0ef          	jal	ra,ffffffffc020418c <find_vma>

    pgfault_num++;
ffffffffc0204a02:	000ae797          	auipc	a5,0xae
ffffffffc0204a06:	e3e7a783          	lw	a5,-450(a5) # ffffffffc02b2840 <pgfault_num>
ffffffffc0204a0a:	2785                	addiw	a5,a5,1
ffffffffc0204a0c:	000ae717          	auipc	a4,0xae
ffffffffc0204a10:	e2f72a23          	sw	a5,-460(a4) # ffffffffc02b2840 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0204a14:	c551                	beqz	a0,ffffffffc0204aa0 <do_pgfault+0xb2>
ffffffffc0204a16:	651c                	ld	a5,8(a0)
ffffffffc0204a18:	08f46463          	bltu	s0,a5,ffffffffc0204aa0 <do_pgfault+0xb2>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0204a1c:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0204a1e:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0204a20:	8b89                	andi	a5,a5,2
ffffffffc0204a22:	efb1                	bnez	a5,ffffffffc0204a7e <do_pgfault+0x90>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0204a24:	75fd                	lui	a1,0xfffff

    pte_t *ptep=NULL;
  
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0204a26:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0204a28:	8c6d                	and	s0,s0,a1
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0204a2a:	4605                	li	a2,1
ffffffffc0204a2c:	85a2                	mv	a1,s0
ffffffffc0204a2e:	bb4fd0ef          	jal	ra,ffffffffc0201de2 <get_pte>
ffffffffc0204a32:	c945                	beqz	a0,ffffffffc0204ae2 <do_pgfault+0xf4>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc0204a34:	610c                	ld	a1,0(a0)
ffffffffc0204a36:	c5b1                	beqz	a1,ffffffffc0204a82 <do_pgfault+0x94>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
         if (swap_init_ok) {
ffffffffc0204a38:	000ae797          	auipc	a5,0xae
ffffffffc0204a3c:	df87a783          	lw	a5,-520(a5) # ffffffffc02b2830 <swap_init_ok>
ffffffffc0204a40:	cbad                	beqz	a5,ffffffffc0204ab2 <do_pgfault+0xc4>
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            //分配一个页面并从交换分区加载数据
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc0204a42:	0030                	addi	a2,sp,8
ffffffffc0204a44:	85a2                	mv	a1,s0
ffffffffc0204a46:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0204a48:	e402                	sd	zero,8(sp)
            if (swap_in(mm, addr, &page) != 0 ){
ffffffffc0204a4a:	a40ff0ef          	jal	ra,ffffffffc0203c8a <swap_in>
ffffffffc0204a4e:	e935                	bnez	a0,ffffffffc0204ac2 <do_pgfault+0xd4>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            //建立页面的物理地址与虚拟地址之间的映射关系
            if (page_insert(mm->pgdir, page, addr, perm) != 0){
ffffffffc0204a50:	65a2                	ld	a1,8(sp)
ffffffffc0204a52:	6c88                	ld	a0,24(s1)
ffffffffc0204a54:	86ca                	mv	a3,s2
ffffffffc0204a56:	8622                	mv	a2,s0
ffffffffc0204a58:	a25fd0ef          	jal	ra,ffffffffc020247c <page_insert>
ffffffffc0204a5c:	892a                	mv	s2,a0
ffffffffc0204a5e:	e935                	bnez	a0,ffffffffc0204ad2 <do_pgfault+0xe4>
                cprintf("page_insert in do_pgfault failed\n");
                goto failed;
            }
            //(3) make the page swappable.
             // 标记页面为可交换
            swap_map_swappable(mm, addr, page, 0);
ffffffffc0204a60:	6622                	ld	a2,8(sp)
ffffffffc0204a62:	4681                	li	a3,0
ffffffffc0204a64:	85a2                	mv	a1,s0
ffffffffc0204a66:	8526                	mv	a0,s1
ffffffffc0204a68:	902ff0ef          	jal	ra,ffffffffc0203b6a <swap_map_swappable>

            //设置页面的虚拟地址 
            page->pra_vaddr = addr;
ffffffffc0204a6c:	67a2                	ld	a5,8(sp)
ffffffffc0204a6e:	ff80                	sd	s0,56(a5)
        }
   }
   ret = 0;
failed:
    return ret;
}
ffffffffc0204a70:	70a2                	ld	ra,40(sp)
ffffffffc0204a72:	7402                	ld	s0,32(sp)
ffffffffc0204a74:	64e2                	ld	s1,24(sp)
ffffffffc0204a76:	854a                	mv	a0,s2
ffffffffc0204a78:	6942                	ld	s2,16(sp)
ffffffffc0204a7a:	6145                	addi	sp,sp,48
ffffffffc0204a7c:	8082                	ret
        perm |= READ_WRITE;
ffffffffc0204a7e:	495d                	li	s2,23
ffffffffc0204a80:	b755                	j	ffffffffc0204a24 <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0204a82:	6c88                	ld	a0,24(s1)
ffffffffc0204a84:	864a                	mv	a2,s2
ffffffffc0204a86:	85a2                	mv	a1,s0
ffffffffc0204a88:	8bbfe0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
   ret = 0;
ffffffffc0204a8c:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0204a8e:	f16d                	bnez	a0,ffffffffc0204a70 <do_pgfault+0x82>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0204a90:	00004517          	auipc	a0,0x4
ffffffffc0204a94:	86850513          	addi	a0,a0,-1944 # ffffffffc02082f8 <default_pmm_manager+0xfc0>
ffffffffc0204a98:	ee8fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204a9c:	5971                	li	s2,-4
            goto failed;
ffffffffc0204a9e:	bfc9                	j	ffffffffc0204a70 <do_pgfault+0x82>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0204aa0:	85a2                	mv	a1,s0
ffffffffc0204aa2:	00004517          	auipc	a0,0x4
ffffffffc0204aa6:	80650513          	addi	a0,a0,-2042 # ffffffffc02082a8 <default_pmm_manager+0xf70>
ffffffffc0204aaa:	ed6fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    int ret = -E_INVAL;
ffffffffc0204aae:	5975                	li	s2,-3
        goto failed;
ffffffffc0204ab0:	b7c1                	j	ffffffffc0204a70 <do_pgfault+0x82>
            cprintf("no swap设置页面的虚拟地址 _init_ok but ptep is %x, failed\n", *ptep);
ffffffffc0204ab2:	00004517          	auipc	a0,0x4
ffffffffc0204ab6:	8b650513          	addi	a0,a0,-1866 # ffffffffc0208368 <default_pmm_manager+0x1030>
ffffffffc0204aba:	ec6fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204abe:	5971                	li	s2,-4
            goto failed;
ffffffffc0204ac0:	bf45                	j	ffffffffc0204a70 <do_pgfault+0x82>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc0204ac2:	00004517          	auipc	a0,0x4
ffffffffc0204ac6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0208320 <default_pmm_manager+0xfe8>
ffffffffc0204aca:	eb6fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204ace:	5971                	li	s2,-4
ffffffffc0204ad0:	b745                	j	ffffffffc0204a70 <do_pgfault+0x82>
                cprintf("page_insert in do_pgfault failed\n");
ffffffffc0204ad2:	00004517          	auipc	a0,0x4
ffffffffc0204ad6:	86e50513          	addi	a0,a0,-1938 # ffffffffc0208340 <default_pmm_manager+0x1008>
ffffffffc0204ada:	ea6fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204ade:	5971                	li	s2,-4
ffffffffc0204ae0:	bf41                	j	ffffffffc0204a70 <do_pgfault+0x82>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc0204ae2:	00003517          	auipc	a0,0x3
ffffffffc0204ae6:	7f650513          	addi	a0,a0,2038 # ffffffffc02082d8 <default_pmm_manager+0xfa0>
ffffffffc0204aea:	e96fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204aee:	5971                	li	s2,-4
        goto failed;
ffffffffc0204af0:	b741                	j	ffffffffc0204a70 <do_pgfault+0x82>

ffffffffc0204af2 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
ffffffffc0204af2:	7179                	addi	sp,sp,-48
ffffffffc0204af4:	f022                	sd	s0,32(sp)
ffffffffc0204af6:	f406                	sd	ra,40(sp)
ffffffffc0204af8:	ec26                	sd	s1,24(sp)
ffffffffc0204afa:	e84a                	sd	s2,16(sp)
ffffffffc0204afc:	e44e                	sd	s3,8(sp)
ffffffffc0204afe:	e052                	sd	s4,0(sp)
ffffffffc0204b00:	842e                	mv	s0,a1
    if (mm != NULL) {
ffffffffc0204b02:	c135                	beqz	a0,ffffffffc0204b66 <user_mem_check+0x74>
        if (!USER_ACCESS(addr, addr + len)) {
ffffffffc0204b04:	002007b7          	lui	a5,0x200
ffffffffc0204b08:	04f5e663          	bltu	a1,a5,ffffffffc0204b54 <user_mem_check+0x62>
ffffffffc0204b0c:	00c584b3          	add	s1,a1,a2
ffffffffc0204b10:	0495f263          	bgeu	a1,s1,ffffffffc0204b54 <user_mem_check+0x62>
ffffffffc0204b14:	4785                	li	a5,1
ffffffffc0204b16:	07fe                	slli	a5,a5,0x1f
ffffffffc0204b18:	0297ee63          	bltu	a5,s1,ffffffffc0204b54 <user_mem_check+0x62>
ffffffffc0204b1c:	892a                	mv	s2,a0
ffffffffc0204b1e:	89b6                	mv	s3,a3
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK)) {
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc0204b20:	6a05                	lui	s4,0x1
ffffffffc0204b22:	a821                	j	ffffffffc0204b3a <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc0204b24:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc0204b28:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc0204b2a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc0204b2c:	c685                	beqz	a3,ffffffffc0204b54 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc0204b2e:	c399                	beqz	a5,ffffffffc0204b34 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc0204b30:	02e46263          	bltu	s0,a4,ffffffffc0204b54 <user_mem_check+0x62>
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0204b34:	6900                	ld	s0,16(a0)
        while (start < end) {
ffffffffc0204b36:	04947663          	bgeu	s0,s1,ffffffffc0204b82 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
ffffffffc0204b3a:	85a2                	mv	a1,s0
ffffffffc0204b3c:	854a                	mv	a0,s2
ffffffffc0204b3e:	e4eff0ef          	jal	ra,ffffffffc020418c <find_vma>
ffffffffc0204b42:	c909                	beqz	a0,ffffffffc0204b54 <user_mem_check+0x62>
ffffffffc0204b44:	6518                	ld	a4,8(a0)
ffffffffc0204b46:	00e46763          	bltu	s0,a4,ffffffffc0204b54 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc0204b4a:	4d1c                	lw	a5,24(a0)
ffffffffc0204b4c:	fc099ce3          	bnez	s3,ffffffffc0204b24 <user_mem_check+0x32>
ffffffffc0204b50:	8b85                	andi	a5,a5,1
ffffffffc0204b52:	f3ed                	bnez	a5,ffffffffc0204b34 <user_mem_check+0x42>
            return 0;
ffffffffc0204b54:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0204b56:	70a2                	ld	ra,40(sp)
ffffffffc0204b58:	7402                	ld	s0,32(sp)
ffffffffc0204b5a:	64e2                	ld	s1,24(sp)
ffffffffc0204b5c:	6942                	ld	s2,16(sp)
ffffffffc0204b5e:	69a2                	ld	s3,8(sp)
ffffffffc0204b60:	6a02                	ld	s4,0(sp)
ffffffffc0204b62:	6145                	addi	sp,sp,48
ffffffffc0204b64:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0204b66:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b6a:	4501                	li	a0,0
ffffffffc0204b6c:	fef5e5e3          	bltu	a1,a5,ffffffffc0204b56 <user_mem_check+0x64>
ffffffffc0204b70:	962e                	add	a2,a2,a1
ffffffffc0204b72:	fec5f2e3          	bgeu	a1,a2,ffffffffc0204b56 <user_mem_check+0x64>
ffffffffc0204b76:	c8000537          	lui	a0,0xc8000
ffffffffc0204b7a:	0505                	addi	a0,a0,1
ffffffffc0204b7c:	00a63533          	sltu	a0,a2,a0
ffffffffc0204b80:	bfd9                	j	ffffffffc0204b56 <user_mem_check+0x64>
        return 1;
ffffffffc0204b82:	4505                	li	a0,1
ffffffffc0204b84:	bfc9                	j	ffffffffc0204b56 <user_mem_check+0x64>

ffffffffc0204b86 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0204b86:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204b88:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0204b8a:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204b8c:	a61fb0ef          	jal	ra,ffffffffc02005ec <ide_device_valid>
ffffffffc0204b90:	cd01                	beqz	a0,ffffffffc0204ba8 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204b92:	4505                	li	a0,1
ffffffffc0204b94:	a5ffb0ef          	jal	ra,ffffffffc02005f2 <ide_device_size>
}
ffffffffc0204b98:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204b9a:	810d                	srli	a0,a0,0x3
ffffffffc0204b9c:	000ae797          	auipc	a5,0xae
ffffffffc0204ba0:	c8a7b223          	sd	a0,-892(a5) # ffffffffc02b2820 <max_swap_offset>
}
ffffffffc0204ba4:	0141                	addi	sp,sp,16
ffffffffc0204ba6:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0204ba8:	00004617          	auipc	a2,0x4
ffffffffc0204bac:	80860613          	addi	a2,a2,-2040 # ffffffffc02083b0 <default_pmm_manager+0x1078>
ffffffffc0204bb0:	45b5                	li	a1,13
ffffffffc0204bb2:	00004517          	auipc	a0,0x4
ffffffffc0204bb6:	81e50513          	addi	a0,a0,-2018 # ffffffffc02083d0 <default_pmm_manager+0x1098>
ffffffffc0204bba:	8c1fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204bbe <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0204bbe:	1141                	addi	sp,sp,-16
ffffffffc0204bc0:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204bc2:	00855793          	srli	a5,a0,0x8
ffffffffc0204bc6:	cbb1                	beqz	a5,ffffffffc0204c1a <swapfs_read+0x5c>
ffffffffc0204bc8:	000ae717          	auipc	a4,0xae
ffffffffc0204bcc:	c5873703          	ld	a4,-936(a4) # ffffffffc02b2820 <max_swap_offset>
ffffffffc0204bd0:	04e7f563          	bgeu	a5,a4,ffffffffc0204c1a <swapfs_read+0x5c>
    return page - pages + nbase;
ffffffffc0204bd4:	000ae617          	auipc	a2,0xae
ffffffffc0204bd8:	c3463603          	ld	a2,-972(a2) # ffffffffc02b2808 <pages>
ffffffffc0204bdc:	8d91                	sub	a1,a1,a2
ffffffffc0204bde:	4065d613          	srai	a2,a1,0x6
ffffffffc0204be2:	00004717          	auipc	a4,0x4
ffffffffc0204be6:	14673703          	ld	a4,326(a4) # ffffffffc0208d28 <nbase>
ffffffffc0204bea:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc0204bec:	00c61713          	slli	a4,a2,0xc
ffffffffc0204bf0:	8331                	srli	a4,a4,0xc
ffffffffc0204bf2:	000ae697          	auipc	a3,0xae
ffffffffc0204bf6:	c0e6b683          	ld	a3,-1010(a3) # ffffffffc02b2800 <npage>
ffffffffc0204bfa:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bfe:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0204c00:	02d77963          	bgeu	a4,a3,ffffffffc0204c32 <swapfs_read+0x74>
}
ffffffffc0204c04:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c06:	000ae797          	auipc	a5,0xae
ffffffffc0204c0a:	c127b783          	ld	a5,-1006(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0204c0e:	46a1                	li	a3,8
ffffffffc0204c10:	963e                	add	a2,a2,a5
ffffffffc0204c12:	4505                	li	a0,1
}
ffffffffc0204c14:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c16:	9e3fb06f          	j	ffffffffc02005f8 <ide_read_secs>
ffffffffc0204c1a:	86aa                	mv	a3,a0
ffffffffc0204c1c:	00003617          	auipc	a2,0x3
ffffffffc0204c20:	7cc60613          	addi	a2,a2,1996 # ffffffffc02083e8 <default_pmm_manager+0x10b0>
ffffffffc0204c24:	45d1                	li	a1,20
ffffffffc0204c26:	00003517          	auipc	a0,0x3
ffffffffc0204c2a:	7aa50513          	addi	a0,a0,1962 # ffffffffc02083d0 <default_pmm_manager+0x1098>
ffffffffc0204c2e:	84dfb0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0204c32:	86b2                	mv	a3,a2
ffffffffc0204c34:	06900593          	li	a1,105
ffffffffc0204c38:	00002617          	auipc	a2,0x2
ffffffffc0204c3c:	73860613          	addi	a2,a2,1848 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0204c40:	00002517          	auipc	a0,0x2
ffffffffc0204c44:	75850513          	addi	a0,a0,1880 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0204c48:	833fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204c4c <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0204c4c:	1141                	addi	sp,sp,-16
ffffffffc0204c4e:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c50:	00855793          	srli	a5,a0,0x8
ffffffffc0204c54:	cbb1                	beqz	a5,ffffffffc0204ca8 <swapfs_write+0x5c>
ffffffffc0204c56:	000ae717          	auipc	a4,0xae
ffffffffc0204c5a:	bca73703          	ld	a4,-1078(a4) # ffffffffc02b2820 <max_swap_offset>
ffffffffc0204c5e:	04e7f563          	bgeu	a5,a4,ffffffffc0204ca8 <swapfs_write+0x5c>
    return page - pages + nbase;
ffffffffc0204c62:	000ae617          	auipc	a2,0xae
ffffffffc0204c66:	ba663603          	ld	a2,-1114(a2) # ffffffffc02b2808 <pages>
ffffffffc0204c6a:	8d91                	sub	a1,a1,a2
ffffffffc0204c6c:	4065d613          	srai	a2,a1,0x6
ffffffffc0204c70:	00004717          	auipc	a4,0x4
ffffffffc0204c74:	0b873703          	ld	a4,184(a4) # ffffffffc0208d28 <nbase>
ffffffffc0204c78:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc0204c7a:	00c61713          	slli	a4,a2,0xc
ffffffffc0204c7e:	8331                	srli	a4,a4,0xc
ffffffffc0204c80:	000ae697          	auipc	a3,0xae
ffffffffc0204c84:	b806b683          	ld	a3,-1152(a3) # ffffffffc02b2800 <npage>
ffffffffc0204c88:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c8c:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0204c8e:	02d77963          	bgeu	a4,a3,ffffffffc0204cc0 <swapfs_write+0x74>
}
ffffffffc0204c92:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c94:	000ae797          	auipc	a5,0xae
ffffffffc0204c98:	b847b783          	ld	a5,-1148(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0204c9c:	46a1                	li	a3,8
ffffffffc0204c9e:	963e                	add	a2,a2,a5
ffffffffc0204ca0:	4505                	li	a0,1
}
ffffffffc0204ca2:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204ca4:	979fb06f          	j	ffffffffc020061c <ide_write_secs>
ffffffffc0204ca8:	86aa                	mv	a3,a0
ffffffffc0204caa:	00003617          	auipc	a2,0x3
ffffffffc0204cae:	73e60613          	addi	a2,a2,1854 # ffffffffc02083e8 <default_pmm_manager+0x10b0>
ffffffffc0204cb2:	45e5                	li	a1,25
ffffffffc0204cb4:	00003517          	auipc	a0,0x3
ffffffffc0204cb8:	71c50513          	addi	a0,a0,1820 # ffffffffc02083d0 <default_pmm_manager+0x1098>
ffffffffc0204cbc:	fbefb0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0204cc0:	86b2                	mv	a3,a2
ffffffffc0204cc2:	06900593          	li	a1,105
ffffffffc0204cc6:	00002617          	auipc	a2,0x2
ffffffffc0204cca:	6aa60613          	addi	a2,a2,1706 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0204cce:	00002517          	auipc	a0,0x2
ffffffffc0204cd2:	6ca50513          	addi	a0,a0,1738 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0204cd6:	fa4fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204cda <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204cda:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204cdc:	9402                	jalr	s0

	jal do_exit
ffffffffc0204cde:	640000ef          	jal	ra,ffffffffc020531e <do_exit>

ffffffffc0204ce2 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc0204ce2:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204ce4:	10800513          	li	a0,264
alloc_proc(void) {
ffffffffc0204ce8:	e022                	sd	s0,0(sp)
ffffffffc0204cea:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204cec:	e0dfc0ef          	jal	ra,ffffffffc0201af8 <kmalloc>
ffffffffc0204cf0:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc0204cf2:	cd21                	beqz	a0,ffffffffc0204d4a <alloc_proc+0x68>
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */

        proc->state = PROC_UNINIT;
ffffffffc0204cf4:	57fd                	li	a5,-1
ffffffffc0204cf6:	1782                	slli	a5,a5,0x20
ffffffffc0204cf8:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0204cfa:	07000613          	li	a2,112
ffffffffc0204cfe:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0204d00:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0204d04:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0204d08:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0204d0c:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0204d10:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0204d14:	03050513          	addi	a0,a0,48
ffffffffc0204d18:	0a5010ef          	jal	ra,ffffffffc02065bc <memset>
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
ffffffffc0204d1c:	000ae797          	auipc	a5,0xae
ffffffffc0204d20:	ad47b783          	ld	a5,-1324(a5) # ffffffffc02b27f0 <boot_cr3>
        proc->tf = NULL;
ffffffffc0204d24:	0a043023          	sd	zero,160(s0)
        proc->cr3 = boot_cr3;
ffffffffc0204d28:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc0204d2a:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0204d2e:	4641                	li	a2,16
ffffffffc0204d30:	4581                	li	a1,0
ffffffffc0204d32:	0b440513          	addi	a0,s0,180
ffffffffc0204d36:	087010ef          	jal	ra,ffffffffc02065bc <memset>
        proc->wait_state = 0;
ffffffffc0204d3a:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL; //当前进程的子进程
ffffffffc0204d3e:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL; // 当前进程的上一个兄弟进程
ffffffffc0204d42:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL; // 当前进程的下一个兄弟进程
ffffffffc0204d46:	0e043c23          	sd	zero,248(s0)
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
     */
    }
    return proc;
}
ffffffffc0204d4a:	60a2                	ld	ra,8(sp)
ffffffffc0204d4c:	8522                	mv	a0,s0
ffffffffc0204d4e:	6402                	ld	s0,0(sp)
ffffffffc0204d50:	0141                	addi	sp,sp,16
ffffffffc0204d52:	8082                	ret

ffffffffc0204d54 <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc0204d54:	000ae797          	auipc	a5,0xae
ffffffffc0204d58:	af47b783          	ld	a5,-1292(a5) # ffffffffc02b2848 <current>
ffffffffc0204d5c:	73c8                	ld	a0,160(a5)
ffffffffc0204d5e:	818fc06f          	j	ffffffffc0200d76 <forkrets>

ffffffffc0204d62 <user_main>:

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d62:	000ae797          	auipc	a5,0xae
ffffffffc0204d66:	ae67b783          	ld	a5,-1306(a5) # ffffffffc02b2848 <current>
ffffffffc0204d6a:	43cc                	lw	a1,4(a5)
user_main(void *arg) {
ffffffffc0204d6c:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d6e:	00003617          	auipc	a2,0x3
ffffffffc0204d72:	69a60613          	addi	a2,a2,1690 # ffffffffc0208408 <default_pmm_manager+0x10d0>
ffffffffc0204d76:	00003517          	auipc	a0,0x3
ffffffffc0204d7a:	6a250513          	addi	a0,a0,1698 # ffffffffc0208418 <default_pmm_manager+0x10e0>
user_main(void *arg) {
ffffffffc0204d7e:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d80:	c00fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0204d84:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0204d88:	be478793          	addi	a5,a5,-1052 # a968 <_binary_obj___user_forktest_out_size>
ffffffffc0204d8c:	e43e                	sd	a5,8(sp)
ffffffffc0204d8e:	00003517          	auipc	a0,0x3
ffffffffc0204d92:	67a50513          	addi	a0,a0,1658 # ffffffffc0208408 <default_pmm_manager+0x10d0>
ffffffffc0204d96:	00046797          	auipc	a5,0x46
ffffffffc0204d9a:	97278793          	addi	a5,a5,-1678 # ffffffffc024a708 <_binary_obj___user_forktest_out_start>
ffffffffc0204d9e:	f03e                	sd	a5,32(sp)
ffffffffc0204da0:	f42a                	sd	a0,40(sp)
    int64_t ret=0, len = strlen(name);
ffffffffc0204da2:	e802                	sd	zero,16(sp)
ffffffffc0204da4:	79c010ef          	jal	ra,ffffffffc0206540 <strlen>
ffffffffc0204da8:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204daa:	4511                	li	a0,4
ffffffffc0204dac:	55a2                	lw	a1,40(sp)
ffffffffc0204dae:	4662                	lw	a2,24(sp)
ffffffffc0204db0:	5682                	lw	a3,32(sp)
ffffffffc0204db2:	4722                	lw	a4,8(sp)
ffffffffc0204db4:	48a9                	li	a7,10
ffffffffc0204db6:	9002                	ebreak
ffffffffc0204db8:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204dba:	65c2                	ld	a1,16(sp)
ffffffffc0204dbc:	00003517          	auipc	a0,0x3
ffffffffc0204dc0:	68450513          	addi	a0,a0,1668 # ffffffffc0208440 <default_pmm_manager+0x1108>
ffffffffc0204dc4:	bbcfb0ef          	jal	ra,ffffffffc0200180 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204dc8:	00003617          	auipc	a2,0x3
ffffffffc0204dcc:	68860613          	addi	a2,a2,1672 # ffffffffc0208450 <default_pmm_manager+0x1118>
ffffffffc0204dd0:	36300593          	li	a1,867
ffffffffc0204dd4:	00003517          	auipc	a0,0x3
ffffffffc0204dd8:	69c50513          	addi	a0,a0,1692 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0204ddc:	e9efb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204de0 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204de0:	6d14                	ld	a3,24(a0)
put_pgdir(struct mm_struct *mm) {
ffffffffc0204de2:	1141                	addi	sp,sp,-16
ffffffffc0204de4:	e406                	sd	ra,8(sp)
ffffffffc0204de6:	c02007b7          	lui	a5,0xc0200
ffffffffc0204dea:	02f6ee63          	bltu	a3,a5,ffffffffc0204e26 <put_pgdir+0x46>
ffffffffc0204dee:	000ae517          	auipc	a0,0xae
ffffffffc0204df2:	a2a53503          	ld	a0,-1494(a0) # ffffffffc02b2818 <va_pa_offset>
ffffffffc0204df6:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage) {
ffffffffc0204df8:	82b1                	srli	a3,a3,0xc
ffffffffc0204dfa:	000ae797          	auipc	a5,0xae
ffffffffc0204dfe:	a067b783          	ld	a5,-1530(a5) # ffffffffc02b2800 <npage>
ffffffffc0204e02:	02f6fe63          	bgeu	a3,a5,ffffffffc0204e3e <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204e06:	00004517          	auipc	a0,0x4
ffffffffc0204e0a:	f2253503          	ld	a0,-222(a0) # ffffffffc0208d28 <nbase>
}
ffffffffc0204e0e:	60a2                	ld	ra,8(sp)
ffffffffc0204e10:	8e89                	sub	a3,a3,a0
ffffffffc0204e12:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204e14:	000ae517          	auipc	a0,0xae
ffffffffc0204e18:	9f453503          	ld	a0,-1548(a0) # ffffffffc02b2808 <pages>
ffffffffc0204e1c:	4585                	li	a1,1
ffffffffc0204e1e:	9536                	add	a0,a0,a3
}
ffffffffc0204e20:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204e22:	f47fc06f          	j	ffffffffc0201d68 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204e26:	00002617          	auipc	a2,0x2
ffffffffc0204e2a:	5f260613          	addi	a2,a2,1522 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0204e2e:	06e00593          	li	a1,110
ffffffffc0204e32:	00002517          	auipc	a0,0x2
ffffffffc0204e36:	56650513          	addi	a0,a0,1382 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0204e3a:	e40fb0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204e3e:	00002617          	auipc	a2,0x2
ffffffffc0204e42:	60260613          	addi	a2,a2,1538 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc0204e46:	06200593          	li	a1,98
ffffffffc0204e4a:	00002517          	auipc	a0,0x2
ffffffffc0204e4e:	54e50513          	addi	a0,a0,1358 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0204e52:	e28fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0204e56 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc0204e56:	7179                	addi	sp,sp,-48
ffffffffc0204e58:	ec4a                	sd	s2,24(sp)
    if (proc != current) {
ffffffffc0204e5a:	000ae917          	auipc	s2,0xae
ffffffffc0204e5e:	9ee90913          	addi	s2,s2,-1554 # ffffffffc02b2848 <current>
proc_run(struct proc_struct *proc) {
ffffffffc0204e62:	f026                	sd	s1,32(sp)
    if (proc != current) {
ffffffffc0204e64:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc0204e68:	f406                	sd	ra,40(sp)
ffffffffc0204e6a:	e84e                	sd	s3,16(sp)
    if (proc != current) {
ffffffffc0204e6c:	02a48863          	beq	s1,a0,ffffffffc0204e9c <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204e70:	100027f3          	csrr	a5,sstatus
ffffffffc0204e74:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204e76:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204e78:	ef9d                	bnez	a5,ffffffffc0204eb6 <proc_run+0x60>

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned long cr3) {
    write_csr(satp, 0x8000000000000000 | (cr3 >> RISCV_PGSHIFT));
ffffffffc0204e7a:	755c                	ld	a5,168(a0)
ffffffffc0204e7c:	577d                	li	a4,-1
ffffffffc0204e7e:	177e                	slli	a4,a4,0x3f
ffffffffc0204e80:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0204e82:	00a93023          	sd	a0,0(s2)
ffffffffc0204e86:	8fd9                	or	a5,a5,a4
ffffffffc0204e88:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc0204e8c:	03050593          	addi	a1,a0,48
ffffffffc0204e90:	03048513          	addi	a0,s1,48
ffffffffc0204e94:	052010ef          	jal	ra,ffffffffc0205ee6 <switch_to>
    if (flag) {
ffffffffc0204e98:	00099863          	bnez	s3,ffffffffc0204ea8 <proc_run+0x52>
}
ffffffffc0204e9c:	70a2                	ld	ra,40(sp)
ffffffffc0204e9e:	7482                	ld	s1,32(sp)
ffffffffc0204ea0:	6962                	ld	s2,24(sp)
ffffffffc0204ea2:	69c2                	ld	s3,16(sp)
ffffffffc0204ea4:	6145                	addi	sp,sp,48
ffffffffc0204ea6:	8082                	ret
ffffffffc0204ea8:	70a2                	ld	ra,40(sp)
ffffffffc0204eaa:	7482                	ld	s1,32(sp)
ffffffffc0204eac:	6962                	ld	s2,24(sp)
ffffffffc0204eae:	69c2                	ld	s3,16(sp)
ffffffffc0204eb0:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0204eb2:	f8efb06f          	j	ffffffffc0200640 <intr_enable>
ffffffffc0204eb6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0204eb8:	f8efb0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc0204ebc:	6522                	ld	a0,8(sp)
ffffffffc0204ebe:	4985                	li	s3,1
ffffffffc0204ec0:	bf6d                	j	ffffffffc0204e7a <proc_run+0x24>

ffffffffc0204ec2 <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204ec2:	7159                	addi	sp,sp,-112
ffffffffc0204ec4:	e8ca                	sd	s2,80(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204ec6:	000ae917          	auipc	s2,0xae
ffffffffc0204eca:	99a90913          	addi	s2,s2,-1638 # ffffffffc02b2860 <nr_process>
ffffffffc0204ece:	00092703          	lw	a4,0(s2)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204ed2:	f486                	sd	ra,104(sp)
ffffffffc0204ed4:	f0a2                	sd	s0,96(sp)
ffffffffc0204ed6:	eca6                	sd	s1,88(sp)
ffffffffc0204ed8:	e4ce                	sd	s3,72(sp)
ffffffffc0204eda:	e0d2                	sd	s4,64(sp)
ffffffffc0204edc:	fc56                	sd	s5,56(sp)
ffffffffc0204ede:	f85a                	sd	s6,48(sp)
ffffffffc0204ee0:	f45e                	sd	s7,40(sp)
ffffffffc0204ee2:	f062                	sd	s8,32(sp)
ffffffffc0204ee4:	ec66                	sd	s9,24(sp)
ffffffffc0204ee6:	e86a                	sd	s10,16(sp)
ffffffffc0204ee8:	e46e                	sd	s11,8(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204eea:	6785                	lui	a5,0x1
ffffffffc0204eec:	32f75f63          	bge	a4,a5,ffffffffc020522a <do_fork+0x368>
ffffffffc0204ef0:	8a2a                	mv	s4,a0
ffffffffc0204ef2:	89ae                	mv	s3,a1
ffffffffc0204ef4:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0204ef6:	dedff0ef          	jal	ra,ffffffffc0204ce2 <alloc_proc>
ffffffffc0204efa:	84aa                	mv	s1,a0
    if (!proc) {
ffffffffc0204efc:	2c050763          	beqz	a0,ffffffffc02051ca <do_fork+0x308>
    proc->parent = current;//将子进程的父节点设置为当前进程
ffffffffc0204f00:	000aea97          	auipc	s5,0xae
ffffffffc0204f04:	948a8a93          	addi	s5,s5,-1720 # ffffffffc02b2848 <current>
ffffffffc0204f08:	000ab783          	ld	a5,0(s5)
    assert(current->wait_state == 0);
ffffffffc0204f0c:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ac4>
    proc->parent = current;//将子进程的父节点设置为当前进程
ffffffffc0204f10:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc0204f12:	38071263          	bnez	a4,ffffffffc0205296 <do_fork+0x3d4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204f16:	4509                	li	a0,2
ffffffffc0204f18:	dbffc0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
    if (page != NULL) {
ffffffffc0204f1c:	2c050663          	beqz	a0,ffffffffc02051e8 <do_fork+0x326>
    return page - pages + nbase;
ffffffffc0204f20:	000aed97          	auipc	s11,0xae
ffffffffc0204f24:	8e8d8d93          	addi	s11,s11,-1816 # ffffffffc02b2808 <pages>
ffffffffc0204f28:	000db683          	ld	a3,0(s11)
    return KADDR(page2pa(page));
ffffffffc0204f2c:	000aed17          	auipc	s10,0xae
ffffffffc0204f30:	8d4d0d13          	addi	s10,s10,-1836 # ffffffffc02b2800 <npage>
    return page - pages + nbase;
ffffffffc0204f34:	00004c97          	auipc	s9,0x4
ffffffffc0204f38:	df4cbc83          	ld	s9,-524(s9) # ffffffffc0208d28 <nbase>
ffffffffc0204f3c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204f40:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204f42:	5c7d                	li	s8,-1
ffffffffc0204f44:	000d3783          	ld	a5,0(s10)
    return page - pages + nbase;
ffffffffc0204f48:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0204f4a:	00cc5c13          	srli	s8,s8,0xc
ffffffffc0204f4e:	0186f733          	and	a4,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f52:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f54:	30f77863          	bgeu	a4,a5,ffffffffc0205264 <do_fork+0x3a2>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204f58:	000ab703          	ld	a4,0(s5)
ffffffffc0204f5c:	000aea97          	auipc	s5,0xae
ffffffffc0204f60:	8bca8a93          	addi	s5,s5,-1860 # ffffffffc02b2818 <va_pa_offset>
ffffffffc0204f64:	000ab783          	ld	a5,0(s5)
ffffffffc0204f68:	02873b83          	ld	s7,40(a4)
ffffffffc0204f6c:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204f6e:	e894                	sd	a3,16(s1)
    if (oldmm == NULL) {
ffffffffc0204f70:	020b8863          	beqz	s7,ffffffffc0204fa0 <do_fork+0xde>
    if (clone_flags & CLONE_VM) {
ffffffffc0204f74:	100a7a13          	andi	s4,s4,256
ffffffffc0204f78:	1c0a0063          	beqz	s4,ffffffffc0205138 <do_fork+0x276>
}

static inline int
mm_count_inc(struct mm_struct *mm) {
    mm->mm_count += 1;
ffffffffc0204f7c:	030ba703          	lw	a4,48(s7)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc0204f80:	018bb783          	ld	a5,24(s7)
ffffffffc0204f84:	c02006b7          	lui	a3,0xc0200
ffffffffc0204f88:	2705                	addiw	a4,a4,1
ffffffffc0204f8a:	02eba823          	sw	a4,48(s7)
    proc->mm = mm;
ffffffffc0204f8e:	0374b423          	sd	s7,40(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc0204f92:	2ed7e563          	bltu	a5,a3,ffffffffc020527c <do_fork+0x3ba>
ffffffffc0204f96:	000ab703          	ld	a4,0(s5)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204f9a:	6894                	ld	a3,16(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc0204f9c:	8f99                	sub	a5,a5,a4
ffffffffc0204f9e:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204fa0:	6789                	lui	a5,0x2
ffffffffc0204fa2:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>
ffffffffc0204fa6:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204fa8:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204faa:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0204fac:	87b6                	mv	a5,a3
ffffffffc0204fae:	12040893          	addi	a7,s0,288
ffffffffc0204fb2:	00063803          	ld	a6,0(a2)
ffffffffc0204fb6:	6608                	ld	a0,8(a2)
ffffffffc0204fb8:	6a0c                	ld	a1,16(a2)
ffffffffc0204fba:	6e18                	ld	a4,24(a2)
ffffffffc0204fbc:	0107b023          	sd	a6,0(a5)
ffffffffc0204fc0:	e788                	sd	a0,8(a5)
ffffffffc0204fc2:	eb8c                	sd	a1,16(a5)
ffffffffc0204fc4:	ef98                	sd	a4,24(a5)
ffffffffc0204fc6:	02060613          	addi	a2,a2,32
ffffffffc0204fca:	02078793          	addi	a5,a5,32
ffffffffc0204fce:	ff1612e3          	bne	a2,a7,ffffffffc0204fb2 <do_fork+0xf0>
    proc->tf->gpr.a0 = 0;
ffffffffc0204fd2:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x1e>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204fd6:	12098e63          	beqz	s3,ffffffffc0205112 <do_fork+0x250>
ffffffffc0204fda:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204fde:	00000797          	auipc	a5,0x0
ffffffffc0204fe2:	d7678793          	addi	a5,a5,-650 # ffffffffc0204d54 <forkret>
ffffffffc0204fe6:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204fe8:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204fea:	100027f3          	csrr	a5,sstatus
ffffffffc0204fee:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204ff0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204ff2:	12079f63          	bnez	a5,ffffffffc0205130 <do_fork+0x26e>
    if (++ last_pid >= MAX_PID) {
ffffffffc0204ff6:	000a2817          	auipc	a6,0xa2
ffffffffc0204ffa:	30a80813          	addi	a6,a6,778 # ffffffffc02a7300 <last_pid.1>
ffffffffc0204ffe:	00082783          	lw	a5,0(a6)
ffffffffc0205002:	6709                	lui	a4,0x2
ffffffffc0205004:	0017851b          	addiw	a0,a5,1
ffffffffc0205008:	00a82023          	sw	a0,0(a6)
ffffffffc020500c:	08e55c63          	bge	a0,a4,ffffffffc02050a4 <do_fork+0x1e2>
    if (last_pid >= next_safe) {
ffffffffc0205010:	000a2317          	auipc	t1,0xa2
ffffffffc0205014:	2f430313          	addi	t1,t1,756 # ffffffffc02a7304 <next_safe.0>
ffffffffc0205018:	00032783          	lw	a5,0(t1)
ffffffffc020501c:	000ad417          	auipc	s0,0xad
ffffffffc0205020:	7a440413          	addi	s0,s0,1956 # ffffffffc02b27c0 <proc_list>
ffffffffc0205024:	08f55863          	bge	a0,a5,ffffffffc02050b4 <do_fork+0x1f2>
    proc->pid = get_pid();//获取当前进程PID
ffffffffc0205028:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020502a:	45a9                	li	a1,10
ffffffffc020502c:	2501                	sext.w	a0,a0
ffffffffc020502e:	10e010ef          	jal	ra,ffffffffc020613c <hash32>
ffffffffc0205032:	02051793          	slli	a5,a0,0x20
ffffffffc0205036:	000a9717          	auipc	a4,0xa9
ffffffffc020503a:	78a70713          	addi	a4,a4,1930 # ffffffffc02ae7c0 <hash_list>
ffffffffc020503e:	83f1                	srli	a5,a5,0x1c
ffffffffc0205040:	97ba                	add	a5,a5,a4
    __list_add(elm, listelm, listelm->next);
ffffffffc0205042:	6788                	ld	a0,8(a5)
    if ((proc->optr = proc->parent->cptr) != NULL) { //将新进程的上一个兄弟进程字段指向其父进程的 cptr 字段
ffffffffc0205044:	7090                	ld	a2,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0205046:	0d848713          	addi	a4,s1,216
    prev->next = next->prev = elm;
ffffffffc020504a:	e118                	sd	a4,0(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc020504c:	640c                	ld	a1,8(s0)
    prev->next = next->prev = elm;
ffffffffc020504e:	e798                	sd	a4,8(a5)
    if ((proc->optr = proc->parent->cptr) != NULL) { //将新进程的上一个兄弟进程字段指向其父进程的 cptr 字段
ffffffffc0205050:	7a74                	ld	a3,240(a2)
    list_add(&proc_list, &(proc->list_link));//这行代码将当前进程 proc 插入到进程列表 proc_list 中
ffffffffc0205052:	0c848713          	addi	a4,s1,200
    elm->next = next;
ffffffffc0205056:	f0e8                	sd	a0,224(s1)
    elm->prev = prev;
ffffffffc0205058:	ecfc                	sd	a5,216(s1)
    prev->next = next->prev = elm;
ffffffffc020505a:	e198                	sd	a4,0(a1)
ffffffffc020505c:	e418                	sd	a4,8(s0)
    elm->next = next;
ffffffffc020505e:	e8ec                	sd	a1,208(s1)
    elm->prev = prev;
ffffffffc0205060:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;//将当前进程的下一个兄弟进程字段设置为 NULL
ffffffffc0205062:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL) { //将新进程的上一个兄弟进程字段指向其父进程的 cptr 字段
ffffffffc0205066:	10d4b023          	sd	a3,256(s1)
ffffffffc020506a:	c291                	beqz	a3,ffffffffc020506e <do_fork+0x1ac>
        proc->optr->yptr = proc;//该子进程的 yptr 设置为当前进程 proc，形成兄弟链
ffffffffc020506c:	fee4                	sd	s1,248(a3)
    nr_process ++;//进程数加1
ffffffffc020506e:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;//父进程指向这个子进程
ffffffffc0205072:	fa64                	sd	s1,240(a2)
    nr_process ++;//进程数加1
ffffffffc0205074:	2785                	addiw	a5,a5,1
ffffffffc0205076:	00f92023          	sw	a5,0(s2)
    if (flag) {
ffffffffc020507a:	14099a63          	bnez	s3,ffffffffc02051ce <do_fork+0x30c>
    wakeup_proc(proc);
ffffffffc020507e:	8526                	mv	a0,s1
ffffffffc0205080:	6d1000ef          	jal	ra,ffffffffc0205f50 <wakeup_proc>
    ret = proc->pid;
ffffffffc0205084:	40c8                	lw	a0,4(s1)
}
ffffffffc0205086:	70a6                	ld	ra,104(sp)
ffffffffc0205088:	7406                	ld	s0,96(sp)
ffffffffc020508a:	64e6                	ld	s1,88(sp)
ffffffffc020508c:	6946                	ld	s2,80(sp)
ffffffffc020508e:	69a6                	ld	s3,72(sp)
ffffffffc0205090:	6a06                	ld	s4,64(sp)
ffffffffc0205092:	7ae2                	ld	s5,56(sp)
ffffffffc0205094:	7b42                	ld	s6,48(sp)
ffffffffc0205096:	7ba2                	ld	s7,40(sp)
ffffffffc0205098:	7c02                	ld	s8,32(sp)
ffffffffc020509a:	6ce2                	ld	s9,24(sp)
ffffffffc020509c:	6d42                	ld	s10,16(sp)
ffffffffc020509e:	6da2                	ld	s11,8(sp)
ffffffffc02050a0:	6165                	addi	sp,sp,112
ffffffffc02050a2:	8082                	ret
        last_pid = 1;
ffffffffc02050a4:	4785                	li	a5,1
ffffffffc02050a6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02050aa:	4505                	li	a0,1
ffffffffc02050ac:	000a2317          	auipc	t1,0xa2
ffffffffc02050b0:	25830313          	addi	t1,t1,600 # ffffffffc02a7304 <next_safe.0>
    return listelm->next;
ffffffffc02050b4:	000ad417          	auipc	s0,0xad
ffffffffc02050b8:	70c40413          	addi	s0,s0,1804 # ffffffffc02b27c0 <proc_list>
ffffffffc02050bc:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02050c0:	6789                	lui	a5,0x2
ffffffffc02050c2:	00f32023          	sw	a5,0(t1)
ffffffffc02050c6:	86aa                	mv	a3,a0
ffffffffc02050c8:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc02050ca:	6e89                	lui	t4,0x2
ffffffffc02050cc:	108e0963          	beq	t3,s0,ffffffffc02051de <do_fork+0x31c>
ffffffffc02050d0:	88ae                	mv	a7,a1
ffffffffc02050d2:	87f2                	mv	a5,t3
ffffffffc02050d4:	6609                	lui	a2,0x2
ffffffffc02050d6:	a811                	j	ffffffffc02050ea <do_fork+0x228>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02050d8:	00e6d663          	bge	a3,a4,ffffffffc02050e4 <do_fork+0x222>
ffffffffc02050dc:	00c75463          	bge	a4,a2,ffffffffc02050e4 <do_fork+0x222>
ffffffffc02050e0:	863a                	mv	a2,a4
ffffffffc02050e2:	4885                	li	a7,1
ffffffffc02050e4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02050e6:	00878d63          	beq	a5,s0,ffffffffc0205100 <do_fork+0x23e>
            if (proc->pid == last_pid) {
ffffffffc02050ea:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc02050ee:	fed715e3          	bne	a4,a3,ffffffffc02050d8 <do_fork+0x216>
                if (++ last_pid >= next_safe) {
ffffffffc02050f2:	2685                	addiw	a3,a3,1
ffffffffc02050f4:	0ec6d063          	bge	a3,a2,ffffffffc02051d4 <do_fork+0x312>
ffffffffc02050f8:	679c                	ld	a5,8(a5)
ffffffffc02050fa:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc02050fc:	fe8797e3          	bne	a5,s0,ffffffffc02050ea <do_fork+0x228>
ffffffffc0205100:	c581                	beqz	a1,ffffffffc0205108 <do_fork+0x246>
ffffffffc0205102:	00d82023          	sw	a3,0(a6)
ffffffffc0205106:	8536                	mv	a0,a3
ffffffffc0205108:	f20880e3          	beqz	a7,ffffffffc0205028 <do_fork+0x166>
ffffffffc020510c:	00c32023          	sw	a2,0(t1)
ffffffffc0205110:	bf21                	j	ffffffffc0205028 <do_fork+0x166>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0205112:	89b6                	mv	s3,a3
ffffffffc0205114:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0205118:	00000797          	auipc	a5,0x0
ffffffffc020511c:	c3c78793          	addi	a5,a5,-964 # ffffffffc0204d54 <forkret>
ffffffffc0205120:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0205122:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205124:	100027f3          	csrr	a5,sstatus
ffffffffc0205128:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020512a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020512c:	ec0785e3          	beqz	a5,ffffffffc0204ff6 <do_fork+0x134>
        intr_disable();
ffffffffc0205130:	d16fb0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc0205134:	4985                	li	s3,1
ffffffffc0205136:	b5c1                	j	ffffffffc0204ff6 <do_fork+0x134>
    if ((mm = mm_create()) == NULL) {
ffffffffc0205138:	fdffe0ef          	jal	ra,ffffffffc0204116 <mm_create>
ffffffffc020513c:	8b2a                	mv	s6,a0
ffffffffc020513e:	c159                	beqz	a0,ffffffffc02051c4 <do_fork+0x302>
    if ((page = alloc_page()) == NULL) {
ffffffffc0205140:	4505                	li	a0,1
ffffffffc0205142:	b95fc0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0205146:	cd25                	beqz	a0,ffffffffc02051be <do_fork+0x2fc>
    return page - pages + nbase;
ffffffffc0205148:	000db683          	ld	a3,0(s11)
    return KADDR(page2pa(page));
ffffffffc020514c:	000d3783          	ld	a5,0(s10)
    return page - pages + nbase;
ffffffffc0205150:	40d506b3          	sub	a3,a0,a3
ffffffffc0205154:	8699                	srai	a3,a3,0x6
ffffffffc0205156:	96e6                	add	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0205158:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc020515c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020515e:	10fc7363          	bgeu	s8,a5,ffffffffc0205264 <do_fork+0x3a2>
ffffffffc0205162:	000aba03          	ld	s4,0(s5)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0205166:	6605                	lui	a2,0x1
ffffffffc0205168:	000ad597          	auipc	a1,0xad
ffffffffc020516c:	6905b583          	ld	a1,1680(a1) # ffffffffc02b27f8 <boot_pgdir>
ffffffffc0205170:	9a36                	add	s4,s4,a3
ffffffffc0205172:	8552                	mv	a0,s4
ffffffffc0205174:	45a010ef          	jal	ra,ffffffffc02065ce <memcpy>
}

static inline void
lock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        lock(&(mm->mm_lock));
ffffffffc0205178:	038b8c13          	addi	s8,s7,56
    mm->pgdir = pgdir;
ffffffffc020517c:	014b3c23          	sd	s4,24(s6)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0205180:	4785                	li	a5,1
ffffffffc0205182:	40fc37af          	amoor.d	a5,a5,(s8)
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
ffffffffc0205186:	8b85                	andi	a5,a5,1
ffffffffc0205188:	4a05                	li	s4,1
ffffffffc020518a:	c799                	beqz	a5,ffffffffc0205198 <do_fork+0x2d6>
        schedule();
ffffffffc020518c:	645000ef          	jal	ra,ffffffffc0205fd0 <schedule>
ffffffffc0205190:	414c37af          	amoor.d	a5,s4,(s8)
    while (!try_lock(lock)) {
ffffffffc0205194:	8b85                	andi	a5,a5,1
ffffffffc0205196:	fbfd                	bnez	a5,ffffffffc020518c <do_fork+0x2ca>
        ret = dup_mmap(mm, oldmm);
ffffffffc0205198:	85de                	mv	a1,s7
ffffffffc020519a:	855a                	mv	a0,s6
ffffffffc020519c:	a02ff0ef          	jal	ra,ffffffffc020439e <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02051a0:	57f9                	li	a5,-2
ffffffffc02051a2:	60fc37af          	amoand.d	a5,a5,(s8)
ffffffffc02051a6:	8b85                	andi	a5,a5,1
    }
}

static inline void
unlock(lock_t *lock) {
    if (!test_and_clear_bit(0, lock)) {
ffffffffc02051a8:	10078763          	beqz	a5,ffffffffc02052b6 <do_fork+0x3f4>
good_mm:
ffffffffc02051ac:	8bda                	mv	s7,s6
    if (ret != 0) {
ffffffffc02051ae:	dc0507e3          	beqz	a0,ffffffffc0204f7c <do_fork+0xba>
    exit_mmap(mm);
ffffffffc02051b2:	855a                	mv	a0,s6
ffffffffc02051b4:	a84ff0ef          	jal	ra,ffffffffc0204438 <exit_mmap>
    put_pgdir(mm);
ffffffffc02051b8:	855a                	mv	a0,s6
ffffffffc02051ba:	c27ff0ef          	jal	ra,ffffffffc0204de0 <put_pgdir>
    mm_destroy(mm);
ffffffffc02051be:	855a                	mv	a0,s6
ffffffffc02051c0:	8dcff0ef          	jal	ra,ffffffffc020429c <mm_destroy>
    kfree(proc);
ffffffffc02051c4:	8526                	mv	a0,s1
ffffffffc02051c6:	9e3fc0ef          	jal	ra,ffffffffc0201ba8 <kfree>
    ret = -E_NO_MEM;
ffffffffc02051ca:	5571                	li	a0,-4
    return ret;
ffffffffc02051cc:	bd6d                	j	ffffffffc0205086 <do_fork+0x1c4>
        intr_enable();
ffffffffc02051ce:	c72fb0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc02051d2:	b575                	j	ffffffffc020507e <do_fork+0x1bc>
                    if (last_pid >= MAX_PID) {
ffffffffc02051d4:	01d6c363          	blt	a3,t4,ffffffffc02051da <do_fork+0x318>
                        last_pid = 1;
ffffffffc02051d8:	4685                	li	a3,1
                    goto repeat;
ffffffffc02051da:	4585                	li	a1,1
ffffffffc02051dc:	bdc5                	j	ffffffffc02050cc <do_fork+0x20a>
ffffffffc02051de:	c9a1                	beqz	a1,ffffffffc020522e <do_fork+0x36c>
ffffffffc02051e0:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02051e4:	8536                	mv	a0,a3
ffffffffc02051e6:	b589                	j	ffffffffc0205028 <do_fork+0x166>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02051e8:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02051ea:	c02007b7          	lui	a5,0xc0200
ffffffffc02051ee:	04f6ef63          	bltu	a3,a5,ffffffffc020524c <do_fork+0x38a>
ffffffffc02051f2:	000ad797          	auipc	a5,0xad
ffffffffc02051f6:	6267b783          	ld	a5,1574(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc02051fa:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc02051fe:	83b1                	srli	a5,a5,0xc
ffffffffc0205200:	000ad717          	auipc	a4,0xad
ffffffffc0205204:	60073703          	ld	a4,1536(a4) # ffffffffc02b2800 <npage>
ffffffffc0205208:	02e7f663          	bgeu	a5,a4,ffffffffc0205234 <do_fork+0x372>
    return &pages[PPN(pa) - nbase];
ffffffffc020520c:	00004717          	auipc	a4,0x4
ffffffffc0205210:	b1c73703          	ld	a4,-1252(a4) # ffffffffc0208d28 <nbase>
ffffffffc0205214:	8f99                	sub	a5,a5,a4
ffffffffc0205216:	079a                	slli	a5,a5,0x6
ffffffffc0205218:	000ad517          	auipc	a0,0xad
ffffffffc020521c:	5f053503          	ld	a0,1520(a0) # ffffffffc02b2808 <pages>
ffffffffc0205220:	4589                	li	a1,2
ffffffffc0205222:	953e                	add	a0,a0,a5
ffffffffc0205224:	b45fc0ef          	jal	ra,ffffffffc0201d68 <free_pages>
}
ffffffffc0205228:	bf71                	j	ffffffffc02051c4 <do_fork+0x302>
    int ret = -E_NO_FREE_PROC;
ffffffffc020522a:	556d                	li	a0,-5
ffffffffc020522c:	bda9                	j	ffffffffc0205086 <do_fork+0x1c4>
    return last_pid;
ffffffffc020522e:	00082503          	lw	a0,0(a6)
ffffffffc0205232:	bbdd                	j	ffffffffc0205028 <do_fork+0x166>
        panic("pa2page called with invalid pa");
ffffffffc0205234:	00002617          	auipc	a2,0x2
ffffffffc0205238:	20c60613          	addi	a2,a2,524 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc020523c:	06200593          	li	a1,98
ffffffffc0205240:	00002517          	auipc	a0,0x2
ffffffffc0205244:	15850513          	addi	a0,a0,344 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205248:	a32fb0ef          	jal	ra,ffffffffc020047a <__panic>
    return pa2page(PADDR(kva));
ffffffffc020524c:	00002617          	auipc	a2,0x2
ffffffffc0205250:	1cc60613          	addi	a2,a2,460 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0205254:	06e00593          	li	a1,110
ffffffffc0205258:	00002517          	auipc	a0,0x2
ffffffffc020525c:	14050513          	addi	a0,a0,320 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205260:	a1afb0ef          	jal	ra,ffffffffc020047a <__panic>
    return KADDR(page2pa(page));
ffffffffc0205264:	00002617          	auipc	a2,0x2
ffffffffc0205268:	10c60613          	addi	a2,a2,268 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc020526c:	06900593          	li	a1,105
ffffffffc0205270:	00002517          	auipc	a0,0x2
ffffffffc0205274:	12850513          	addi	a0,a0,296 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205278:	a02fb0ef          	jal	ra,ffffffffc020047a <__panic>
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020527c:	86be                	mv	a3,a5
ffffffffc020527e:	00002617          	auipc	a2,0x2
ffffffffc0205282:	19a60613          	addi	a2,a2,410 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0205286:	16e00593          	li	a1,366
ffffffffc020528a:	00003517          	auipc	a0,0x3
ffffffffc020528e:	1e650513          	addi	a0,a0,486 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205292:	9e8fb0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(current->wait_state == 0);
ffffffffc0205296:	00003697          	auipc	a3,0x3
ffffffffc020529a:	1f268693          	addi	a3,a3,498 # ffffffffc0208488 <default_pmm_manager+0x1150>
ffffffffc020529e:	00002617          	auipc	a2,0x2
ffffffffc02052a2:	a0260613          	addi	a2,a2,-1534 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02052a6:	1ae00593          	li	a1,430
ffffffffc02052aa:	00003517          	auipc	a0,0x3
ffffffffc02052ae:	1c650513          	addi	a0,a0,454 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc02052b2:	9c8fb0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("Unlock failed.\n");
ffffffffc02052b6:	00003617          	auipc	a2,0x3
ffffffffc02052ba:	1f260613          	addi	a2,a2,498 # ffffffffc02084a8 <default_pmm_manager+0x1170>
ffffffffc02052be:	03100593          	li	a1,49
ffffffffc02052c2:	00003517          	auipc	a0,0x3
ffffffffc02052c6:	1f650513          	addi	a0,a0,502 # ffffffffc02084b8 <default_pmm_manager+0x1180>
ffffffffc02052ca:	9b0fb0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc02052ce <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02052ce:	7129                	addi	sp,sp,-320
ffffffffc02052d0:	fa22                	sd	s0,304(sp)
ffffffffc02052d2:	f626                	sd	s1,296(sp)
ffffffffc02052d4:	f24a                	sd	s2,288(sp)
ffffffffc02052d6:	84ae                	mv	s1,a1
ffffffffc02052d8:	892a                	mv	s2,a0
ffffffffc02052da:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02052dc:	4581                	li	a1,0
ffffffffc02052de:	12000613          	li	a2,288
ffffffffc02052e2:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02052e4:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02052e6:	2d6010ef          	jal	ra,ffffffffc02065bc <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02052ea:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02052ec:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02052ee:	100027f3          	csrr	a5,sstatus
ffffffffc02052f2:	edd7f793          	andi	a5,a5,-291
ffffffffc02052f6:	1207e793          	ori	a5,a5,288
ffffffffc02052fa:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02052fc:	860a                	mv	a2,sp
ffffffffc02052fe:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0205302:	00000797          	auipc	a5,0x0
ffffffffc0205306:	9d878793          	addi	a5,a5,-1576 # ffffffffc0204cda <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020530a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020530c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020530e:	bb5ff0ef          	jal	ra,ffffffffc0204ec2 <do_fork>
}
ffffffffc0205312:	70f2                	ld	ra,312(sp)
ffffffffc0205314:	7452                	ld	s0,304(sp)
ffffffffc0205316:	74b2                	ld	s1,296(sp)
ffffffffc0205318:	7912                	ld	s2,288(sp)
ffffffffc020531a:	6131                	addi	sp,sp,320
ffffffffc020531c:	8082                	ret

ffffffffc020531e <do_exit>:
do_exit(int error_code) {
ffffffffc020531e:	7179                	addi	sp,sp,-48
ffffffffc0205320:	f022                	sd	s0,32(sp)
    if (current == idleproc) {
ffffffffc0205322:	000ad417          	auipc	s0,0xad
ffffffffc0205326:	52640413          	addi	s0,s0,1318 # ffffffffc02b2848 <current>
ffffffffc020532a:	601c                	ld	a5,0(s0)
do_exit(int error_code) {
ffffffffc020532c:	f406                	sd	ra,40(sp)
ffffffffc020532e:	ec26                	sd	s1,24(sp)
ffffffffc0205330:	e84a                	sd	s2,16(sp)
ffffffffc0205332:	e44e                	sd	s3,8(sp)
ffffffffc0205334:	e052                	sd	s4,0(sp)
    if (current == idleproc) {
ffffffffc0205336:	000ad717          	auipc	a4,0xad
ffffffffc020533a:	51a73703          	ld	a4,1306(a4) # ffffffffc02b2850 <idleproc>
ffffffffc020533e:	0ce78c63          	beq	a5,a4,ffffffffc0205416 <do_exit+0xf8>
    if (current == initproc) {
ffffffffc0205342:	000ad497          	auipc	s1,0xad
ffffffffc0205346:	51648493          	addi	s1,s1,1302 # ffffffffc02b2858 <initproc>
ffffffffc020534a:	6098                	ld	a4,0(s1)
ffffffffc020534c:	0ee78b63          	beq	a5,a4,ffffffffc0205442 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0205350:	0287b983          	ld	s3,40(a5)
ffffffffc0205354:	892a                	mv	s2,a0
    if (mm != NULL) {
ffffffffc0205356:	02098663          	beqz	s3,ffffffffc0205382 <do_exit+0x64>
ffffffffc020535a:	000ad797          	auipc	a5,0xad
ffffffffc020535e:	4967b783          	ld	a5,1174(a5) # ffffffffc02b27f0 <boot_cr3>
ffffffffc0205362:	577d                	li	a4,-1
ffffffffc0205364:	177e                	slli	a4,a4,0x3f
ffffffffc0205366:	83b1                	srli	a5,a5,0xc
ffffffffc0205368:	8fd9                	or	a5,a5,a4
ffffffffc020536a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020536e:	0309a783          	lw	a5,48(s3)
ffffffffc0205372:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205376:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc020537a:	cb55                	beqz	a4,ffffffffc020542e <do_exit+0x110>
        current->mm = NULL;
ffffffffc020537c:	601c                	ld	a5,0(s0)
ffffffffc020537e:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0205382:	601c                	ld	a5,0(s0)
ffffffffc0205384:	470d                	li	a4,3
ffffffffc0205386:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0205388:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020538c:	100027f3          	csrr	a5,sstatus
ffffffffc0205390:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205392:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205394:	e3f9                	bnez	a5,ffffffffc020545a <do_exit+0x13c>
        proc = current->parent;
ffffffffc0205396:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD) {
ffffffffc0205398:	800007b7          	lui	a5,0x80000
ffffffffc020539c:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020539e:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD) {
ffffffffc02053a0:	0ec52703          	lw	a4,236(a0)
ffffffffc02053a4:	0af70f63          	beq	a4,a5,ffffffffc0205462 <do_exit+0x144>
        while (current->cptr != NULL) {
ffffffffc02053a8:	6018                	ld	a4,0(s0)
ffffffffc02053aa:	7b7c                	ld	a5,240(a4)
ffffffffc02053ac:	c3a1                	beqz	a5,ffffffffc02053ec <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02053ae:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02053b2:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02053b4:	0985                	addi	s3,s3,1
ffffffffc02053b6:	a021                	j	ffffffffc02053be <do_exit+0xa0>
        while (current->cptr != NULL) {
ffffffffc02053b8:	6018                	ld	a4,0(s0)
ffffffffc02053ba:	7b7c                	ld	a5,240(a4)
ffffffffc02053bc:	cb85                	beqz	a5,ffffffffc02053ec <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02053be:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fd8>
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02053c2:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02053c4:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02053c6:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02053c8:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02053cc:	10e7b023          	sd	a4,256(a5)
ffffffffc02053d0:	c311                	beqz	a4,ffffffffc02053d4 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02053d2:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02053d4:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02053d6:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02053d8:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02053da:	fd271fe3          	bne	a4,s2,ffffffffc02053b8 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02053de:	0ec52783          	lw	a5,236(a0)
ffffffffc02053e2:	fd379be3          	bne	a5,s3,ffffffffc02053b8 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02053e6:	36b000ef          	jal	ra,ffffffffc0205f50 <wakeup_proc>
ffffffffc02053ea:	b7f9                	j	ffffffffc02053b8 <do_exit+0x9a>
    if (flag) {
ffffffffc02053ec:	020a1263          	bnez	s4,ffffffffc0205410 <do_exit+0xf2>
    schedule();
ffffffffc02053f0:	3e1000ef          	jal	ra,ffffffffc0205fd0 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02053f4:	601c                	ld	a5,0(s0)
ffffffffc02053f6:	00003617          	auipc	a2,0x3
ffffffffc02053fa:	0fa60613          	addi	a2,a2,250 # ffffffffc02084f0 <default_pmm_manager+0x11b8>
ffffffffc02053fe:	21a00593          	li	a1,538
ffffffffc0205402:	43d4                	lw	a3,4(a5)
ffffffffc0205404:	00003517          	auipc	a0,0x3
ffffffffc0205408:	06c50513          	addi	a0,a0,108 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020540c:	86efb0ef          	jal	ra,ffffffffc020047a <__panic>
        intr_enable();
ffffffffc0205410:	a30fb0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc0205414:	bff1                	j	ffffffffc02053f0 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0205416:	00003617          	auipc	a2,0x3
ffffffffc020541a:	0ba60613          	addi	a2,a2,186 # ffffffffc02084d0 <default_pmm_manager+0x1198>
ffffffffc020541e:	1ee00593          	li	a1,494
ffffffffc0205422:	00003517          	auipc	a0,0x3
ffffffffc0205426:	04e50513          	addi	a0,a0,78 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020542a:	850fb0ef          	jal	ra,ffffffffc020047a <__panic>
            exit_mmap(mm);
ffffffffc020542e:	854e                	mv	a0,s3
ffffffffc0205430:	808ff0ef          	jal	ra,ffffffffc0204438 <exit_mmap>
            put_pgdir(mm);
ffffffffc0205434:	854e                	mv	a0,s3
ffffffffc0205436:	9abff0ef          	jal	ra,ffffffffc0204de0 <put_pgdir>
            mm_destroy(mm);
ffffffffc020543a:	854e                	mv	a0,s3
ffffffffc020543c:	e61fe0ef          	jal	ra,ffffffffc020429c <mm_destroy>
ffffffffc0205440:	bf35                	j	ffffffffc020537c <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0205442:	00003617          	auipc	a2,0x3
ffffffffc0205446:	09e60613          	addi	a2,a2,158 # ffffffffc02084e0 <default_pmm_manager+0x11a8>
ffffffffc020544a:	1f100593          	li	a1,497
ffffffffc020544e:	00003517          	auipc	a0,0x3
ffffffffc0205452:	02250513          	addi	a0,a0,34 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205456:	824fb0ef          	jal	ra,ffffffffc020047a <__panic>
        intr_disable();
ffffffffc020545a:	9ecfb0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc020545e:	4a05                	li	s4,1
ffffffffc0205460:	bf1d                	j	ffffffffc0205396 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0205462:	2ef000ef          	jal	ra,ffffffffc0205f50 <wakeup_proc>
ffffffffc0205466:	b789                	j	ffffffffc02053a8 <do_exit+0x8a>

ffffffffc0205468 <do_wait.part.0>:
do_wait(int pid, int *code_store) {
ffffffffc0205468:	715d                	addi	sp,sp,-80
ffffffffc020546a:	fc26                	sd	s1,56(sp)
ffffffffc020546c:	f84a                	sd	s2,48(sp)
        current->wait_state = WT_CHILD;
ffffffffc020546e:	800004b7          	lui	s1,0x80000
    if (0 < pid && pid < MAX_PID) {
ffffffffc0205472:	6909                	lui	s2,0x2
do_wait(int pid, int *code_store) {
ffffffffc0205474:	f44e                	sd	s3,40(sp)
ffffffffc0205476:	f052                	sd	s4,32(sp)
ffffffffc0205478:	ec56                	sd	s5,24(sp)
ffffffffc020547a:	e85a                	sd	s6,16(sp)
ffffffffc020547c:	e45e                	sd	s7,8(sp)
ffffffffc020547e:	e486                	sd	ra,72(sp)
ffffffffc0205480:	e0a2                	sd	s0,64(sp)
ffffffffc0205482:	8b2a                	mv	s6,a0
ffffffffc0205484:	89ae                	mv	s3,a1
        proc = current->cptr;
ffffffffc0205486:	000adb97          	auipc	s7,0xad
ffffffffc020548a:	3c2b8b93          	addi	s7,s7,962 # ffffffffc02b2848 <current>
    if (0 < pid && pid < MAX_PID) {
ffffffffc020548e:	00050a9b          	sext.w	s5,a0
ffffffffc0205492:	fff50a1b          	addiw	s4,a0,-1
ffffffffc0205496:	1979                	addi	s2,s2,-2
        current->wait_state = WT_CHILD;
ffffffffc0205498:	0485                	addi	s1,s1,1
    if (pid != 0) {
ffffffffc020549a:	060b0f63          	beqz	s6,ffffffffc0205518 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID) {
ffffffffc020549e:	03496763          	bltu	s2,s4,ffffffffc02054cc <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02054a2:	45a9                	li	a1,10
ffffffffc02054a4:	8556                	mv	a0,s5
ffffffffc02054a6:	497000ef          	jal	ra,ffffffffc020613c <hash32>
ffffffffc02054aa:	02051713          	slli	a4,a0,0x20
ffffffffc02054ae:	8371                	srli	a4,a4,0x1c
ffffffffc02054b0:	000a9797          	auipc	a5,0xa9
ffffffffc02054b4:	31078793          	addi	a5,a5,784 # ffffffffc02ae7c0 <hash_list>
ffffffffc02054b8:	973e                	add	a4,a4,a5
ffffffffc02054ba:	843a                	mv	s0,a4
        while ((le = list_next(le)) != list) {
ffffffffc02054bc:	a029                	j	ffffffffc02054c6 <do_wait.part.0+0x5e>
            if (proc->pid == pid) {
ffffffffc02054be:	f2c42783          	lw	a5,-212(s0)
ffffffffc02054c2:	03678163          	beq	a5,s6,ffffffffc02054e4 <do_wait.part.0+0x7c>
ffffffffc02054c6:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list) {
ffffffffc02054c8:	fe871be3          	bne	a4,s0,ffffffffc02054be <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02054cc:	5579                	li	a0,-2
}
ffffffffc02054ce:	60a6                	ld	ra,72(sp)
ffffffffc02054d0:	6406                	ld	s0,64(sp)
ffffffffc02054d2:	74e2                	ld	s1,56(sp)
ffffffffc02054d4:	7942                	ld	s2,48(sp)
ffffffffc02054d6:	79a2                	ld	s3,40(sp)
ffffffffc02054d8:	7a02                	ld	s4,32(sp)
ffffffffc02054da:	6ae2                	ld	s5,24(sp)
ffffffffc02054dc:	6b42                	ld	s6,16(sp)
ffffffffc02054de:	6ba2                	ld	s7,8(sp)
ffffffffc02054e0:	6161                	addi	sp,sp,80
ffffffffc02054e2:	8082                	ret
        if (proc != NULL && proc->parent == current) {
ffffffffc02054e4:	000bb683          	ld	a3,0(s7)
ffffffffc02054e8:	f4843783          	ld	a5,-184(s0)
ffffffffc02054ec:	fed790e3          	bne	a5,a3,ffffffffc02054cc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02054f0:	f2842703          	lw	a4,-216(s0)
ffffffffc02054f4:	478d                	li	a5,3
ffffffffc02054f6:	0ef70b63          	beq	a4,a5,ffffffffc02055ec <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02054fa:	4785                	li	a5,1
ffffffffc02054fc:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02054fe:	0e96a623          	sw	s1,236(a3)
        schedule();
ffffffffc0205502:	2cf000ef          	jal	ra,ffffffffc0205fd0 <schedule>
        if (current->flags & PF_EXITING) {
ffffffffc0205506:	000bb783          	ld	a5,0(s7)
ffffffffc020550a:	0b07a783          	lw	a5,176(a5)
ffffffffc020550e:	8b85                	andi	a5,a5,1
ffffffffc0205510:	d7c9                	beqz	a5,ffffffffc020549a <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0205512:	555d                	li	a0,-9
ffffffffc0205514:	e0bff0ef          	jal	ra,ffffffffc020531e <do_exit>
        proc = current->cptr;
ffffffffc0205518:	000bb683          	ld	a3,0(s7)
ffffffffc020551c:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr) {
ffffffffc020551e:	d45d                	beqz	s0,ffffffffc02054cc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0205520:	470d                	li	a4,3
ffffffffc0205522:	a021                	j	ffffffffc020552a <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0205524:	10043403          	ld	s0,256(s0)
ffffffffc0205528:	d869                	beqz	s0,ffffffffc02054fa <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc020552a:	401c                	lw	a5,0(s0)
ffffffffc020552c:	fee79ce3          	bne	a5,a4,ffffffffc0205524 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc) {
ffffffffc0205530:	000ad797          	auipc	a5,0xad
ffffffffc0205534:	3207b783          	ld	a5,800(a5) # ffffffffc02b2850 <idleproc>
ffffffffc0205538:	0c878963          	beq	a5,s0,ffffffffc020560a <do_wait.part.0+0x1a2>
ffffffffc020553c:	000ad797          	auipc	a5,0xad
ffffffffc0205540:	31c7b783          	ld	a5,796(a5) # ffffffffc02b2858 <initproc>
ffffffffc0205544:	0cf40363          	beq	s0,a5,ffffffffc020560a <do_wait.part.0+0x1a2>
    if (code_store != NULL) {
ffffffffc0205548:	00098663          	beqz	s3,ffffffffc0205554 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020554c:	0e842783          	lw	a5,232(s0)
ffffffffc0205550:	00f9a023          	sw	a5,0(s3) # ffffffff80000000 <_binary_obj___user_exit_out_size+0xffffffff7fff4ed8>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205554:	100027f3          	csrr	a5,sstatus
ffffffffc0205558:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020555a:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020555c:	e7c1                	bnez	a5,ffffffffc02055e4 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020555e:	6c70                	ld	a2,216(s0)
ffffffffc0205560:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL) {
ffffffffc0205562:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0205566:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0205568:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020556a:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020556c:	6470                	ld	a2,200(s0)
ffffffffc020556e:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0205570:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0205572:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL) {
ffffffffc0205574:	c319                	beqz	a4,ffffffffc020557a <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0205576:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL) {
ffffffffc0205578:	7c7c                	ld	a5,248(s0)
ffffffffc020557a:	c3b5                	beqz	a5,ffffffffc02055de <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020557c:	10e7b023          	sd	a4,256(a5)
    nr_process --;
ffffffffc0205580:	000ad717          	auipc	a4,0xad
ffffffffc0205584:	2e070713          	addi	a4,a4,736 # ffffffffc02b2860 <nr_process>
ffffffffc0205588:	431c                	lw	a5,0(a4)
ffffffffc020558a:	37fd                	addiw	a5,a5,-1
ffffffffc020558c:	c31c                	sw	a5,0(a4)
    if (flag) {
ffffffffc020558e:	e5a9                	bnez	a1,ffffffffc02055d8 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0205590:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0205592:	c02007b7          	lui	a5,0xc0200
ffffffffc0205596:	04f6ee63          	bltu	a3,a5,ffffffffc02055f2 <do_wait.part.0+0x18a>
ffffffffc020559a:	000ad797          	auipc	a5,0xad
ffffffffc020559e:	27e7b783          	ld	a5,638(a5) # ffffffffc02b2818 <va_pa_offset>
ffffffffc02055a2:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc02055a4:	82b1                	srli	a3,a3,0xc
ffffffffc02055a6:	000ad797          	auipc	a5,0xad
ffffffffc02055aa:	25a7b783          	ld	a5,602(a5) # ffffffffc02b2800 <npage>
ffffffffc02055ae:	06f6fa63          	bgeu	a3,a5,ffffffffc0205622 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02055b2:	00003517          	auipc	a0,0x3
ffffffffc02055b6:	77653503          	ld	a0,1910(a0) # ffffffffc0208d28 <nbase>
ffffffffc02055ba:	8e89                	sub	a3,a3,a0
ffffffffc02055bc:	069a                	slli	a3,a3,0x6
ffffffffc02055be:	000ad517          	auipc	a0,0xad
ffffffffc02055c2:	24a53503          	ld	a0,586(a0) # ffffffffc02b2808 <pages>
ffffffffc02055c6:	9536                	add	a0,a0,a3
ffffffffc02055c8:	4589                	li	a1,2
ffffffffc02055ca:	f9efc0ef          	jal	ra,ffffffffc0201d68 <free_pages>
    kfree(proc);
ffffffffc02055ce:	8522                	mv	a0,s0
ffffffffc02055d0:	dd8fc0ef          	jal	ra,ffffffffc0201ba8 <kfree>
    return 0;
ffffffffc02055d4:	4501                	li	a0,0
ffffffffc02055d6:	bde5                	j	ffffffffc02054ce <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02055d8:	868fb0ef          	jal	ra,ffffffffc0200640 <intr_enable>
ffffffffc02055dc:	bf55                	j	ffffffffc0205590 <do_wait.part.0+0x128>
       proc->parent->cptr = proc->optr;
ffffffffc02055de:	701c                	ld	a5,32(s0)
ffffffffc02055e0:	fbf8                	sd	a4,240(a5)
ffffffffc02055e2:	bf79                	j	ffffffffc0205580 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02055e4:	862fb0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc02055e8:	4585                	li	a1,1
ffffffffc02055ea:	bf95                	j	ffffffffc020555e <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02055ec:	f2840413          	addi	s0,s0,-216
ffffffffc02055f0:	b781                	j	ffffffffc0205530 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02055f2:	00002617          	auipc	a2,0x2
ffffffffc02055f6:	e2660613          	addi	a2,a2,-474 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc02055fa:	06e00593          	li	a1,110
ffffffffc02055fe:	00002517          	auipc	a0,0x2
ffffffffc0205602:	d9a50513          	addi	a0,a0,-614 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205606:	e75fa0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020560a:	00003617          	auipc	a2,0x3
ffffffffc020560e:	f0660613          	addi	a2,a2,-250 # ffffffffc0208510 <default_pmm_manager+0x11d8>
ffffffffc0205612:	31100593          	li	a1,785
ffffffffc0205616:	00003517          	auipc	a0,0x3
ffffffffc020561a:	e5a50513          	addi	a0,a0,-422 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020561e:	e5dfa0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0205622:	00002617          	auipc	a2,0x2
ffffffffc0205626:	e1e60613          	addi	a2,a2,-482 # ffffffffc0207440 <default_pmm_manager+0x108>
ffffffffc020562a:	06200593          	li	a1,98
ffffffffc020562e:	00002517          	auipc	a0,0x2
ffffffffc0205632:	d6a50513          	addi	a0,a0,-662 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205636:	e45fa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020563a <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc020563a:	1141                	addi	sp,sp,-16
ffffffffc020563c:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020563e:	f6afc0ef          	jal	ra,ffffffffc0201da8 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0205642:	cb2fc0ef          	jal	ra,ffffffffc0201af4 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0205646:	4601                	li	a2,0
ffffffffc0205648:	4581                	li	a1,0
ffffffffc020564a:	fffff517          	auipc	a0,0xfffff
ffffffffc020564e:	71850513          	addi	a0,a0,1816 # ffffffffc0204d62 <user_main>
ffffffffc0205652:	c7dff0ef          	jal	ra,ffffffffc02052ce <kernel_thread>
    if (pid <= 0) {
ffffffffc0205656:	00a04563          	bgtz	a0,ffffffffc0205660 <init_main+0x26>
ffffffffc020565a:	a071                	j	ffffffffc02056e6 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
ffffffffc020565c:	175000ef          	jal	ra,ffffffffc0205fd0 <schedule>
    if (code_store != NULL) {
ffffffffc0205660:	4581                	li	a1,0
ffffffffc0205662:	4501                	li	a0,0
ffffffffc0205664:	e05ff0ef          	jal	ra,ffffffffc0205468 <do_wait.part.0>
    while (do_wait(0, NULL) == 0) {
ffffffffc0205668:	d975                	beqz	a0,ffffffffc020565c <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020566a:	00003517          	auipc	a0,0x3
ffffffffc020566e:	ee650513          	addi	a0,a0,-282 # ffffffffc0208550 <default_pmm_manager+0x1218>
ffffffffc0205672:	b0ffa0ef          	jal	ra,ffffffffc0200180 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0205676:	000ad797          	auipc	a5,0xad
ffffffffc020567a:	1e27b783          	ld	a5,482(a5) # ffffffffc02b2858 <initproc>
ffffffffc020567e:	7bf8                	ld	a4,240(a5)
ffffffffc0205680:	e339                	bnez	a4,ffffffffc02056c6 <init_main+0x8c>
ffffffffc0205682:	7ff8                	ld	a4,248(a5)
ffffffffc0205684:	e329                	bnez	a4,ffffffffc02056c6 <init_main+0x8c>
ffffffffc0205686:	1007b703          	ld	a4,256(a5)
ffffffffc020568a:	ef15                	bnez	a4,ffffffffc02056c6 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020568c:	000ad697          	auipc	a3,0xad
ffffffffc0205690:	1d46a683          	lw	a3,468(a3) # ffffffffc02b2860 <nr_process>
ffffffffc0205694:	4709                	li	a4,2
ffffffffc0205696:	0ae69463          	bne	a3,a4,ffffffffc020573e <init_main+0x104>
    return listelm->next;
ffffffffc020569a:	000ad697          	auipc	a3,0xad
ffffffffc020569e:	12668693          	addi	a3,a3,294 # ffffffffc02b27c0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02056a2:	6698                	ld	a4,8(a3)
ffffffffc02056a4:	0c878793          	addi	a5,a5,200
ffffffffc02056a8:	06f71b63          	bne	a4,a5,ffffffffc020571e <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02056ac:	629c                	ld	a5,0(a3)
ffffffffc02056ae:	04f71863          	bne	a4,a5,ffffffffc02056fe <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02056b2:	00003517          	auipc	a0,0x3
ffffffffc02056b6:	f8650513          	addi	a0,a0,-122 # ffffffffc0208638 <default_pmm_manager+0x1300>
ffffffffc02056ba:	ac7fa0ef          	jal	ra,ffffffffc0200180 <cprintf>
    return 0;
}
ffffffffc02056be:	60a2                	ld	ra,8(sp)
ffffffffc02056c0:	4501                	li	a0,0
ffffffffc02056c2:	0141                	addi	sp,sp,16
ffffffffc02056c4:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02056c6:	00003697          	auipc	a3,0x3
ffffffffc02056ca:	eb268693          	addi	a3,a3,-334 # ffffffffc0208578 <default_pmm_manager+0x1240>
ffffffffc02056ce:	00001617          	auipc	a2,0x1
ffffffffc02056d2:	5d260613          	addi	a2,a2,1490 # ffffffffc0206ca0 <commands+0x450>
ffffffffc02056d6:	37600593          	li	a1,886
ffffffffc02056da:	00003517          	auipc	a0,0x3
ffffffffc02056de:	d9650513          	addi	a0,a0,-618 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc02056e2:	d99fa0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("create user_main failed.\n");
ffffffffc02056e6:	00003617          	auipc	a2,0x3
ffffffffc02056ea:	e4a60613          	addi	a2,a2,-438 # ffffffffc0208530 <default_pmm_manager+0x11f8>
ffffffffc02056ee:	36e00593          	li	a1,878
ffffffffc02056f2:	00003517          	auipc	a0,0x3
ffffffffc02056f6:	d7e50513          	addi	a0,a0,-642 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc02056fa:	d81fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02056fe:	00003697          	auipc	a3,0x3
ffffffffc0205702:	f0a68693          	addi	a3,a3,-246 # ffffffffc0208608 <default_pmm_manager+0x12d0>
ffffffffc0205706:	00001617          	auipc	a2,0x1
ffffffffc020570a:	59a60613          	addi	a2,a2,1434 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020570e:	37900593          	li	a1,889
ffffffffc0205712:	00003517          	auipc	a0,0x3
ffffffffc0205716:	d5e50513          	addi	a0,a0,-674 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020571a:	d61fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020571e:	00003697          	auipc	a3,0x3
ffffffffc0205722:	eba68693          	addi	a3,a3,-326 # ffffffffc02085d8 <default_pmm_manager+0x12a0>
ffffffffc0205726:	00001617          	auipc	a2,0x1
ffffffffc020572a:	57a60613          	addi	a2,a2,1402 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020572e:	37800593          	li	a1,888
ffffffffc0205732:	00003517          	auipc	a0,0x3
ffffffffc0205736:	d3e50513          	addi	a0,a0,-706 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020573a:	d41fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(nr_process == 2);
ffffffffc020573e:	00003697          	auipc	a3,0x3
ffffffffc0205742:	e8a68693          	addi	a3,a3,-374 # ffffffffc02085c8 <default_pmm_manager+0x1290>
ffffffffc0205746:	00001617          	auipc	a2,0x1
ffffffffc020574a:	55a60613          	addi	a2,a2,1370 # ffffffffc0206ca0 <commands+0x450>
ffffffffc020574e:	37700593          	li	a1,887
ffffffffc0205752:	00003517          	auipc	a0,0x3
ffffffffc0205756:	d1e50513          	addi	a0,a0,-738 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc020575a:	d21fa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020575e <do_execve>:
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc020575e:	7171                	addi	sp,sp,-176
ffffffffc0205760:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205762:	000add97          	auipc	s11,0xad
ffffffffc0205766:	0e6d8d93          	addi	s11,s11,230 # ffffffffc02b2848 <current>
ffffffffc020576a:	000db783          	ld	a5,0(s11)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc020576e:	e54e                	sd	s3,136(sp)
ffffffffc0205770:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205772:	0287b983          	ld	s3,40(a5)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0205776:	e94a                	sd	s2,144(sp)
ffffffffc0205778:	f4de                	sd	s7,104(sp)
ffffffffc020577a:	892a                	mv	s2,a0
ffffffffc020577c:	8bb2                	mv	s7,a2
ffffffffc020577e:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc0205780:	862e                	mv	a2,a1
ffffffffc0205782:	4681                	li	a3,0
ffffffffc0205784:	85aa                	mv	a1,a0
ffffffffc0205786:	854e                	mv	a0,s3
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0205788:	f506                	sd	ra,168(sp)
ffffffffc020578a:	f122                	sd	s0,160(sp)
ffffffffc020578c:	e152                	sd	s4,128(sp)
ffffffffc020578e:	fcd6                	sd	s5,120(sp)
ffffffffc0205790:	f8da                	sd	s6,112(sp)
ffffffffc0205792:	f0e2                	sd	s8,96(sp)
ffffffffc0205794:	ece6                	sd	s9,88(sp)
ffffffffc0205796:	e8ea                	sd	s10,80(sp)
ffffffffc0205798:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc020579a:	b58ff0ef          	jal	ra,ffffffffc0204af2 <user_mem_check>
ffffffffc020579e:	40050863          	beqz	a0,ffffffffc0205bae <do_execve+0x450>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02057a2:	4641                	li	a2,16
ffffffffc02057a4:	4581                	li	a1,0
ffffffffc02057a6:	1808                	addi	a0,sp,48
ffffffffc02057a8:	615000ef          	jal	ra,ffffffffc02065bc <memset>
    memcpy(local_name, name, len);
ffffffffc02057ac:	47bd                	li	a5,15
ffffffffc02057ae:	8626                	mv	a2,s1
ffffffffc02057b0:	1e97e063          	bltu	a5,s1,ffffffffc0205990 <do_execve+0x232>
ffffffffc02057b4:	85ca                	mv	a1,s2
ffffffffc02057b6:	1808                	addi	a0,sp,48
ffffffffc02057b8:	617000ef          	jal	ra,ffffffffc02065ce <memcpy>
    if (mm != NULL) {
ffffffffc02057bc:	1e098163          	beqz	s3,ffffffffc020599e <do_execve+0x240>
        cputs("mm != NULL");
ffffffffc02057c0:	00002517          	auipc	a0,0x2
ffffffffc02057c4:	30050513          	addi	a0,a0,768 # ffffffffc0207ac0 <default_pmm_manager+0x788>
ffffffffc02057c8:	9f1fa0ef          	jal	ra,ffffffffc02001b8 <cputs>
ffffffffc02057cc:	000ad797          	auipc	a5,0xad
ffffffffc02057d0:	0247b783          	ld	a5,36(a5) # ffffffffc02b27f0 <boot_cr3>
ffffffffc02057d4:	577d                	li	a4,-1
ffffffffc02057d6:	177e                	slli	a4,a4,0x3f
ffffffffc02057d8:	83b1                	srli	a5,a5,0xc
ffffffffc02057da:	8fd9                	or	a5,a5,a4
ffffffffc02057dc:	18079073          	csrw	satp,a5
ffffffffc02057e0:	0309a783          	lw	a5,48(s3)
ffffffffc02057e4:	fff7871b          	addiw	a4,a5,-1
ffffffffc02057e8:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc02057ec:	2c070263          	beqz	a4,ffffffffc0205ab0 <do_execve+0x352>
        current->mm = NULL;
ffffffffc02057f0:	000db783          	ld	a5,0(s11)
ffffffffc02057f4:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL) {
ffffffffc02057f8:	91ffe0ef          	jal	ra,ffffffffc0204116 <mm_create>
ffffffffc02057fc:	84aa                	mv	s1,a0
ffffffffc02057fe:	1c050b63          	beqz	a0,ffffffffc02059d4 <do_execve+0x276>
    if ((page = alloc_page()) == NULL) {
ffffffffc0205802:	4505                	li	a0,1
ffffffffc0205804:	cd2fc0ef          	jal	ra,ffffffffc0201cd6 <alloc_pages>
ffffffffc0205808:	3a050763          	beqz	a0,ffffffffc0205bb6 <do_execve+0x458>
    return page - pages + nbase;
ffffffffc020580c:	000adc97          	auipc	s9,0xad
ffffffffc0205810:	ffcc8c93          	addi	s9,s9,-4 # ffffffffc02b2808 <pages>
ffffffffc0205814:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0205818:	000adc17          	auipc	s8,0xad
ffffffffc020581c:	fe8c0c13          	addi	s8,s8,-24 # ffffffffc02b2800 <npage>
    return page - pages + nbase;
ffffffffc0205820:	00003717          	auipc	a4,0x3
ffffffffc0205824:	50873703          	ld	a4,1288(a4) # ffffffffc0208d28 <nbase>
ffffffffc0205828:	40d506b3          	sub	a3,a0,a3
ffffffffc020582c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020582e:	5afd                	li	s5,-1
ffffffffc0205830:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0205834:	96ba                	add	a3,a3,a4
ffffffffc0205836:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205838:	00cad713          	srli	a4,s5,0xc
ffffffffc020583c:	ec3a                	sd	a4,24(sp)
ffffffffc020583e:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0205840:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205842:	36f77e63          	bgeu	a4,a5,ffffffffc0205bbe <do_execve+0x460>
ffffffffc0205846:	000adb17          	auipc	s6,0xad
ffffffffc020584a:	fd2b0b13          	addi	s6,s6,-46 # ffffffffc02b2818 <va_pa_offset>
ffffffffc020584e:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0205852:	6605                	lui	a2,0x1
ffffffffc0205854:	000ad597          	auipc	a1,0xad
ffffffffc0205858:	fa45b583          	ld	a1,-92(a1) # ffffffffc02b27f8 <boot_pgdir>
ffffffffc020585c:	9936                	add	s2,s2,a3
ffffffffc020585e:	854a                	mv	a0,s2
ffffffffc0205860:	56f000ef          	jal	ra,ffffffffc02065ce <memcpy>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0205864:	7782                	ld	a5,32(sp)
ffffffffc0205866:	4398                	lw	a4,0(a5)
ffffffffc0205868:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc020586c:	0124bc23          	sd	s2,24(s1) # ffffffff80000018 <_binary_obj___user_exit_out_size+0xffffffff7fff4ef0>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0205870:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b9457>
ffffffffc0205874:	14f71663          	bne	a4,a5,ffffffffc02059c0 <do_execve+0x262>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0205878:	7682                	ld	a3,32(sp)
ffffffffc020587a:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020587e:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0205882:	00371793          	slli	a5,a4,0x3
ffffffffc0205886:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0205888:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020588a:	078e                	slli	a5,a5,0x3
ffffffffc020588c:	97ce                	add	a5,a5,s3
ffffffffc020588e:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph ++) {
ffffffffc0205890:	00f9fc63          	bgeu	s3,a5,ffffffffc02058a8 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD) {
ffffffffc0205894:	0009a783          	lw	a5,0(s3)
ffffffffc0205898:	4705                	li	a4,1
ffffffffc020589a:	12e78f63          	beq	a5,a4,ffffffffc02059d8 <do_execve+0x27a>
    for (; ph < ph_end; ph ++) {
ffffffffc020589e:	77a2                	ld	a5,40(sp)
ffffffffc02058a0:	03898993          	addi	s3,s3,56
ffffffffc02058a4:	fef9e8e3          	bltu	s3,a5,ffffffffc0205894 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
ffffffffc02058a8:	4701                	li	a4,0
ffffffffc02058aa:	46ad                	li	a3,11
ffffffffc02058ac:	00100637          	lui	a2,0x100
ffffffffc02058b0:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02058b4:	8526                	mv	a0,s1
ffffffffc02058b6:	a39fe0ef          	jal	ra,ffffffffc02042ee <mm_map>
ffffffffc02058ba:	8a2a                	mv	s4,a0
ffffffffc02058bc:	1e051063          	bnez	a0,ffffffffc0205a9c <do_execve+0x33e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc02058c0:	6c88                	ld	a0,24(s1)
ffffffffc02058c2:	467d                	li	a2,31
ffffffffc02058c4:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02058c8:	a7bfd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc02058cc:	38050163          	beqz	a0,ffffffffc0205c4e <do_execve+0x4f0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc02058d0:	6c88                	ld	a0,24(s1)
ffffffffc02058d2:	467d                	li	a2,31
ffffffffc02058d4:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02058d8:	a6bfd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc02058dc:	34050963          	beqz	a0,ffffffffc0205c2e <do_execve+0x4d0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc02058e0:	6c88                	ld	a0,24(s1)
ffffffffc02058e2:	467d                	li	a2,31
ffffffffc02058e4:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02058e8:	a5bfd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc02058ec:	32050163          	beqz	a0,ffffffffc0205c0e <do_execve+0x4b0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc02058f0:	6c88                	ld	a0,24(s1)
ffffffffc02058f2:	467d                	li	a2,31
ffffffffc02058f4:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02058f8:	a4bfd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc02058fc:	2e050963          	beqz	a0,ffffffffc0205bee <do_execve+0x490>
    mm->mm_count += 1;
ffffffffc0205900:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0205902:	000db603          	ld	a2,0(s11)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0205906:	6c94                	ld	a3,24(s1)
ffffffffc0205908:	2785                	addiw	a5,a5,1
ffffffffc020590a:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc020590c:	f604                	sd	s1,40(a2)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc020590e:	c02007b7          	lui	a5,0xc0200
ffffffffc0205912:	2cf6e263          	bltu	a3,a5,ffffffffc0205bd6 <do_execve+0x478>
ffffffffc0205916:	000b3783          	ld	a5,0(s6)
ffffffffc020591a:	577d                	li	a4,-1
ffffffffc020591c:	177e                	slli	a4,a4,0x3f
ffffffffc020591e:	8e9d                	sub	a3,a3,a5
ffffffffc0205920:	00c6d793          	srli	a5,a3,0xc
ffffffffc0205924:	f654                	sd	a3,168(a2)
ffffffffc0205926:	8fd9                	or	a5,a5,a4
ffffffffc0205928:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc020592c:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc020592e:	4581                	li	a1,0
ffffffffc0205930:	12000613          	li	a2,288
ffffffffc0205934:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0205936:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc020593a:	483000ef          	jal	ra,ffffffffc02065bc <memset>
    tf->epc = elf->e_entry;
ffffffffc020593e:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205940:	000db483          	ld	s1,0(s11)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0205944:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0205948:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc020594a:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020594c:	0b448493          	addi	s1,s1,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0205950:	07fe                	slli	a5,a5,0x1f
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205952:	4641                	li	a2,16
ffffffffc0205954:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0205956:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0205958:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc020595c:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205960:	8526                	mv	a0,s1
ffffffffc0205962:	45b000ef          	jal	ra,ffffffffc02065bc <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205966:	463d                	li	a2,15
ffffffffc0205968:	180c                	addi	a1,sp,48
ffffffffc020596a:	8526                	mv	a0,s1
ffffffffc020596c:	463000ef          	jal	ra,ffffffffc02065ce <memcpy>
}
ffffffffc0205970:	70aa                	ld	ra,168(sp)
ffffffffc0205972:	740a                	ld	s0,160(sp)
ffffffffc0205974:	64ea                	ld	s1,152(sp)
ffffffffc0205976:	694a                	ld	s2,144(sp)
ffffffffc0205978:	69aa                	ld	s3,136(sp)
ffffffffc020597a:	7ae6                	ld	s5,120(sp)
ffffffffc020597c:	7b46                	ld	s6,112(sp)
ffffffffc020597e:	7ba6                	ld	s7,104(sp)
ffffffffc0205980:	7c06                	ld	s8,96(sp)
ffffffffc0205982:	6ce6                	ld	s9,88(sp)
ffffffffc0205984:	6d46                	ld	s10,80(sp)
ffffffffc0205986:	6da6                	ld	s11,72(sp)
ffffffffc0205988:	8552                	mv	a0,s4
ffffffffc020598a:	6a0a                	ld	s4,128(sp)
ffffffffc020598c:	614d                	addi	sp,sp,176
ffffffffc020598e:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0205990:	463d                	li	a2,15
ffffffffc0205992:	85ca                	mv	a1,s2
ffffffffc0205994:	1808                	addi	a0,sp,48
ffffffffc0205996:	439000ef          	jal	ra,ffffffffc02065ce <memcpy>
    if (mm != NULL) {
ffffffffc020599a:	e20993e3          	bnez	s3,ffffffffc02057c0 <do_execve+0x62>
    if (current->mm != NULL) {
ffffffffc020599e:	000db783          	ld	a5,0(s11)
ffffffffc02059a2:	779c                	ld	a5,40(a5)
ffffffffc02059a4:	e4078ae3          	beqz	a5,ffffffffc02057f8 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02059a8:	00003617          	auipc	a2,0x3
ffffffffc02059ac:	cb060613          	addi	a2,a2,-848 # ffffffffc0208658 <default_pmm_manager+0x1320>
ffffffffc02059b0:	22400593          	li	a1,548
ffffffffc02059b4:	00003517          	auipc	a0,0x3
ffffffffc02059b8:	abc50513          	addi	a0,a0,-1348 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc02059bc:	abffa0ef          	jal	ra,ffffffffc020047a <__panic>
    put_pgdir(mm);
ffffffffc02059c0:	8526                	mv	a0,s1
ffffffffc02059c2:	c1eff0ef          	jal	ra,ffffffffc0204de0 <put_pgdir>
    mm_destroy(mm);
ffffffffc02059c6:	8526                	mv	a0,s1
ffffffffc02059c8:	8d5fe0ef          	jal	ra,ffffffffc020429c <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc02059cc:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc02059ce:	8552                	mv	a0,s4
ffffffffc02059d0:	94fff0ef          	jal	ra,ffffffffc020531e <do_exit>
    int ret = -E_NO_MEM;
ffffffffc02059d4:	5a71                	li	s4,-4
ffffffffc02059d6:	bfe5                	j	ffffffffc02059ce <do_execve+0x270>
        if (ph->p_filesz > ph->p_memsz) {
ffffffffc02059d8:	0289b603          	ld	a2,40(s3)
ffffffffc02059dc:	0209b783          	ld	a5,32(s3)
ffffffffc02059e0:	1cf66d63          	bltu	a2,a5,ffffffffc0205bba <do_execve+0x45c>
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc02059e4:	0049a783          	lw	a5,4(s3)
ffffffffc02059e8:	0017f693          	andi	a3,a5,1
ffffffffc02059ec:	c291                	beqz	a3,ffffffffc02059f0 <do_execve+0x292>
ffffffffc02059ee:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc02059f0:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc02059f4:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc02059f6:	e779                	bnez	a4,ffffffffc0205ac4 <do_execve+0x366>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc02059f8:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc02059fa:	c781                	beqz	a5,ffffffffc0205a02 <do_execve+0x2a4>
ffffffffc02059fc:	0016e693          	ori	a3,a3,1
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc0205a00:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0205a02:	0026f793          	andi	a5,a3,2
ffffffffc0205a06:	e3f1                	bnez	a5,ffffffffc0205aca <do_execve+0x36c>
        if (vm_flags & VM_EXEC) perm |= PTE_X;
ffffffffc0205a08:	0046f793          	andi	a5,a3,4
ffffffffc0205a0c:	c399                	beqz	a5,ffffffffc0205a12 <do_execve+0x2b4>
ffffffffc0205a0e:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
ffffffffc0205a12:	0109b583          	ld	a1,16(s3)
ffffffffc0205a16:	4701                	li	a4,0
ffffffffc0205a18:	8526                	mv	a0,s1
ffffffffc0205a1a:	8d5fe0ef          	jal	ra,ffffffffc02042ee <mm_map>
ffffffffc0205a1e:	8a2a                	mv	s4,a0
ffffffffc0205a20:	ed35                	bnez	a0,ffffffffc0205a9c <do_execve+0x33e>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205a22:	0109bb83          	ld	s7,16(s3)
ffffffffc0205a26:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0205a28:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205a2c:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205a30:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205a34:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0205a36:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205a38:	993e                	add	s2,s2,a5
        while (start < end) {
ffffffffc0205a3a:	054be963          	bltu	s7,s4,ffffffffc0205a8c <do_execve+0x32e>
ffffffffc0205a3e:	aa95                	j	ffffffffc0205bb2 <do_execve+0x454>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205a40:	6785                	lui	a5,0x1
ffffffffc0205a42:	415b8533          	sub	a0,s7,s5
ffffffffc0205a46:	9abe                	add	s5,s5,a5
ffffffffc0205a48:	417a8633          	sub	a2,s5,s7
            if (end < la) {
ffffffffc0205a4c:	015a7463          	bgeu	s4,s5,ffffffffc0205a54 <do_execve+0x2f6>
                size -= la - end;
ffffffffc0205a50:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0205a54:	000cb683          	ld	a3,0(s9)
ffffffffc0205a58:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205a5a:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0205a5e:	40d406b3          	sub	a3,s0,a3
ffffffffc0205a62:	8699                	srai	a3,a3,0x6
ffffffffc0205a64:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205a66:	67e2                	ld	a5,24(sp)
ffffffffc0205a68:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205a6c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205a6e:	14b87863          	bgeu	a6,a1,ffffffffc0205bbe <do_execve+0x460>
ffffffffc0205a72:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0205a76:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0205a78:	9bb2                	add	s7,s7,a2
ffffffffc0205a7a:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0205a7c:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0205a7e:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0205a80:	34f000ef          	jal	ra,ffffffffc02065ce <memcpy>
            start += size, from += size;
ffffffffc0205a84:	6622                	ld	a2,8(sp)
ffffffffc0205a86:	9932                	add	s2,s2,a2
        while (start < end) {
ffffffffc0205a88:	054bf363          	bgeu	s7,s4,ffffffffc0205ace <do_execve+0x370>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0205a8c:	6c88                	ld	a0,24(s1)
ffffffffc0205a8e:	866a                	mv	a2,s10
ffffffffc0205a90:	85d6                	mv	a1,s5
ffffffffc0205a92:	8b1fd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc0205a96:	842a                	mv	s0,a0
ffffffffc0205a98:	f545                	bnez	a0,ffffffffc0205a40 <do_execve+0x2e2>
        ret = -E_NO_MEM;
ffffffffc0205a9a:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0205a9c:	8526                	mv	a0,s1
ffffffffc0205a9e:	99bfe0ef          	jal	ra,ffffffffc0204438 <exit_mmap>
    put_pgdir(mm);
ffffffffc0205aa2:	8526                	mv	a0,s1
ffffffffc0205aa4:	b3cff0ef          	jal	ra,ffffffffc0204de0 <put_pgdir>
    mm_destroy(mm);
ffffffffc0205aa8:	8526                	mv	a0,s1
ffffffffc0205aaa:	ff2fe0ef          	jal	ra,ffffffffc020429c <mm_destroy>
    return ret;
ffffffffc0205aae:	b705                	j	ffffffffc02059ce <do_execve+0x270>
            exit_mmap(mm);
ffffffffc0205ab0:	854e                	mv	a0,s3
ffffffffc0205ab2:	987fe0ef          	jal	ra,ffffffffc0204438 <exit_mmap>
            put_pgdir(mm);
ffffffffc0205ab6:	854e                	mv	a0,s3
ffffffffc0205ab8:	b28ff0ef          	jal	ra,ffffffffc0204de0 <put_pgdir>
            mm_destroy(mm);
ffffffffc0205abc:	854e                	mv	a0,s3
ffffffffc0205abe:	fdefe0ef          	jal	ra,ffffffffc020429c <mm_destroy>
ffffffffc0205ac2:	b33d                	j	ffffffffc02057f0 <do_execve+0x92>
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0205ac4:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205ac8:	fb95                	bnez	a5,ffffffffc02059fc <do_execve+0x29e>
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0205aca:	4d5d                	li	s10,23
ffffffffc0205acc:	bf35                	j	ffffffffc0205a08 <do_execve+0x2aa>
        end = ph->p_va + ph->p_memsz;
ffffffffc0205ace:	0109b683          	ld	a3,16(s3)
ffffffffc0205ad2:	0289b903          	ld	s2,40(s3)
ffffffffc0205ad6:	9936                	add	s2,s2,a3
        if (start < la) {
ffffffffc0205ad8:	075bfd63          	bgeu	s7,s5,ffffffffc0205b52 <do_execve+0x3f4>
            if (start == end) {
ffffffffc0205adc:	dd7901e3          	beq	s2,s7,ffffffffc020589e <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205ae0:	6785                	lui	a5,0x1
ffffffffc0205ae2:	00fb8533          	add	a0,s7,a5
ffffffffc0205ae6:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0205aea:	41790a33          	sub	s4,s2,s7
            if (end < la) {
ffffffffc0205aee:	0b597d63          	bgeu	s2,s5,ffffffffc0205ba8 <do_execve+0x44a>
    return page - pages + nbase;
ffffffffc0205af2:	000cb683          	ld	a3,0(s9)
ffffffffc0205af6:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205af8:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0205afc:	40d406b3          	sub	a3,s0,a3
ffffffffc0205b00:	8699                	srai	a3,a3,0x6
ffffffffc0205b02:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205b04:	67e2                	ld	a5,24(sp)
ffffffffc0205b06:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205b0a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205b0c:	0ac5f963          	bgeu	a1,a2,ffffffffc0205bbe <do_execve+0x460>
ffffffffc0205b10:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205b14:	8652                	mv	a2,s4
ffffffffc0205b16:	4581                	li	a1,0
ffffffffc0205b18:	96c2                	add	a3,a3,a6
ffffffffc0205b1a:	9536                	add	a0,a0,a3
ffffffffc0205b1c:	2a1000ef          	jal	ra,ffffffffc02065bc <memset>
            start += size;
ffffffffc0205b20:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0205b24:	03597463          	bgeu	s2,s5,ffffffffc0205b4c <do_execve+0x3ee>
ffffffffc0205b28:	d6e90be3          	beq	s2,a4,ffffffffc020589e <do_execve+0x140>
ffffffffc0205b2c:	00003697          	auipc	a3,0x3
ffffffffc0205b30:	b5468693          	addi	a3,a3,-1196 # ffffffffc0208680 <default_pmm_manager+0x1348>
ffffffffc0205b34:	00001617          	auipc	a2,0x1
ffffffffc0205b38:	16c60613          	addi	a2,a2,364 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205b3c:	27900593          	li	a1,633
ffffffffc0205b40:	00003517          	auipc	a0,0x3
ffffffffc0205b44:	93050513          	addi	a0,a0,-1744 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205b48:	933fa0ef          	jal	ra,ffffffffc020047a <__panic>
ffffffffc0205b4c:	ff5710e3          	bne	a4,s5,ffffffffc0205b2c <do_execve+0x3ce>
ffffffffc0205b50:	8bd6                	mv	s7,s5
        while (start < end) {
ffffffffc0205b52:	d52bf6e3          	bgeu	s7,s2,ffffffffc020589e <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0205b56:	6c88                	ld	a0,24(s1)
ffffffffc0205b58:	866a                	mv	a2,s10
ffffffffc0205b5a:	85d6                	mv	a1,s5
ffffffffc0205b5c:	fe6fd0ef          	jal	ra,ffffffffc0203342 <pgdir_alloc_page>
ffffffffc0205b60:	842a                	mv	s0,a0
ffffffffc0205b62:	dd05                	beqz	a0,ffffffffc0205a9a <do_execve+0x33c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205b64:	6785                	lui	a5,0x1
ffffffffc0205b66:	415b8533          	sub	a0,s7,s5
ffffffffc0205b6a:	9abe                	add	s5,s5,a5
ffffffffc0205b6c:	417a8633          	sub	a2,s5,s7
            if (end < la) {
ffffffffc0205b70:	01597463          	bgeu	s2,s5,ffffffffc0205b78 <do_execve+0x41a>
                size -= la - end;
ffffffffc0205b74:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0205b78:	000cb683          	ld	a3,0(s9)
ffffffffc0205b7c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205b7e:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0205b82:	40d406b3          	sub	a3,s0,a3
ffffffffc0205b86:	8699                	srai	a3,a3,0x6
ffffffffc0205b88:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205b8a:	67e2                	ld	a5,24(sp)
ffffffffc0205b8c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205b90:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205b92:	02b87663          	bgeu	a6,a1,ffffffffc0205bbe <do_execve+0x460>
ffffffffc0205b96:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205b9a:	4581                	li	a1,0
            start += size;
ffffffffc0205b9c:	9bb2                	add	s7,s7,a2
ffffffffc0205b9e:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0205ba0:	9536                	add	a0,a0,a3
ffffffffc0205ba2:	21b000ef          	jal	ra,ffffffffc02065bc <memset>
ffffffffc0205ba6:	b775                	j	ffffffffc0205b52 <do_execve+0x3f4>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205ba8:	417a8a33          	sub	s4,s5,s7
ffffffffc0205bac:	b799                	j	ffffffffc0205af2 <do_execve+0x394>
        return -E_INVAL;
ffffffffc0205bae:	5a75                	li	s4,-3
ffffffffc0205bb0:	b3c1                	j	ffffffffc0205970 <do_execve+0x212>
        while (start < end) {
ffffffffc0205bb2:	86de                	mv	a3,s7
ffffffffc0205bb4:	bf39                	j	ffffffffc0205ad2 <do_execve+0x374>
    int ret = -E_NO_MEM;
ffffffffc0205bb6:	5a71                	li	s4,-4
ffffffffc0205bb8:	bdc5                	j	ffffffffc0205aa8 <do_execve+0x34a>
            ret = -E_INVAL_ELF;
ffffffffc0205bba:	5a61                	li	s4,-8
ffffffffc0205bbc:	b5c5                	j	ffffffffc0205a9c <do_execve+0x33e>
ffffffffc0205bbe:	00001617          	auipc	a2,0x1
ffffffffc0205bc2:	7b260613          	addi	a2,a2,1970 # ffffffffc0207370 <default_pmm_manager+0x38>
ffffffffc0205bc6:	06900593          	li	a1,105
ffffffffc0205bca:	00001517          	auipc	a0,0x1
ffffffffc0205bce:	7ce50513          	addi	a0,a0,1998 # ffffffffc0207398 <default_pmm_manager+0x60>
ffffffffc0205bd2:	8a9fa0ef          	jal	ra,ffffffffc020047a <__panic>
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0205bd6:	00002617          	auipc	a2,0x2
ffffffffc0205bda:	84260613          	addi	a2,a2,-1982 # ffffffffc0207418 <default_pmm_manager+0xe0>
ffffffffc0205bde:	29400593          	li	a1,660
ffffffffc0205be2:	00003517          	auipc	a0,0x3
ffffffffc0205be6:	88e50513          	addi	a0,a0,-1906 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205bea:	891fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0205bee:	00003697          	auipc	a3,0x3
ffffffffc0205bf2:	baa68693          	addi	a3,a3,-1110 # ffffffffc0208798 <default_pmm_manager+0x1460>
ffffffffc0205bf6:	00001617          	auipc	a2,0x1
ffffffffc0205bfa:	0aa60613          	addi	a2,a2,170 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205bfe:	28f00593          	li	a1,655
ffffffffc0205c02:	00003517          	auipc	a0,0x3
ffffffffc0205c06:	86e50513          	addi	a0,a0,-1938 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205c0a:	871fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc0205c0e:	00003697          	auipc	a3,0x3
ffffffffc0205c12:	b4268693          	addi	a3,a3,-1214 # ffffffffc0208750 <default_pmm_manager+0x1418>
ffffffffc0205c16:	00001617          	auipc	a2,0x1
ffffffffc0205c1a:	08a60613          	addi	a2,a2,138 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205c1e:	28e00593          	li	a1,654
ffffffffc0205c22:	00003517          	auipc	a0,0x3
ffffffffc0205c26:	84e50513          	addi	a0,a0,-1970 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205c2a:	851fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc0205c2e:	00003697          	auipc	a3,0x3
ffffffffc0205c32:	ada68693          	addi	a3,a3,-1318 # ffffffffc0208708 <default_pmm_manager+0x13d0>
ffffffffc0205c36:	00001617          	auipc	a2,0x1
ffffffffc0205c3a:	06a60613          	addi	a2,a2,106 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205c3e:	28d00593          	li	a1,653
ffffffffc0205c42:	00003517          	auipc	a0,0x3
ffffffffc0205c46:	82e50513          	addi	a0,a0,-2002 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205c4a:	831fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc0205c4e:	00003697          	auipc	a3,0x3
ffffffffc0205c52:	a7268693          	addi	a3,a3,-1422 # ffffffffc02086c0 <default_pmm_manager+0x1388>
ffffffffc0205c56:	00001617          	auipc	a2,0x1
ffffffffc0205c5a:	04a60613          	addi	a2,a2,74 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205c5e:	28c00593          	li	a1,652
ffffffffc0205c62:	00003517          	auipc	a0,0x3
ffffffffc0205c66:	80e50513          	addi	a0,a0,-2034 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205c6a:	811fa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0205c6e <do_yield>:
    current->need_resched = 1;
ffffffffc0205c6e:	000ad797          	auipc	a5,0xad
ffffffffc0205c72:	bda7b783          	ld	a5,-1062(a5) # ffffffffc02b2848 <current>
ffffffffc0205c76:	4705                	li	a4,1
ffffffffc0205c78:	ef98                	sd	a4,24(a5)
}
ffffffffc0205c7a:	4501                	li	a0,0
ffffffffc0205c7c:	8082                	ret

ffffffffc0205c7e <do_wait>:
do_wait(int pid, int *code_store) {
ffffffffc0205c7e:	1101                	addi	sp,sp,-32
ffffffffc0205c80:	e822                	sd	s0,16(sp)
ffffffffc0205c82:	e426                	sd	s1,8(sp)
ffffffffc0205c84:	ec06                	sd	ra,24(sp)
ffffffffc0205c86:	842e                	mv	s0,a1
ffffffffc0205c88:	84aa                	mv	s1,a0
    if (code_store != NULL) {
ffffffffc0205c8a:	c999                	beqz	a1,ffffffffc0205ca0 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0205c8c:	000ad797          	auipc	a5,0xad
ffffffffc0205c90:	bbc7b783          	ld	a5,-1092(a5) # ffffffffc02b2848 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
ffffffffc0205c94:	7788                	ld	a0,40(a5)
ffffffffc0205c96:	4685                	li	a3,1
ffffffffc0205c98:	4611                	li	a2,4
ffffffffc0205c9a:	e59fe0ef          	jal	ra,ffffffffc0204af2 <user_mem_check>
ffffffffc0205c9e:	c909                	beqz	a0,ffffffffc0205cb0 <do_wait+0x32>
ffffffffc0205ca0:	85a2                	mv	a1,s0
}
ffffffffc0205ca2:	6442                	ld	s0,16(sp)
ffffffffc0205ca4:	60e2                	ld	ra,24(sp)
ffffffffc0205ca6:	8526                	mv	a0,s1
ffffffffc0205ca8:	64a2                	ld	s1,8(sp)
ffffffffc0205caa:	6105                	addi	sp,sp,32
ffffffffc0205cac:	fbcff06f          	j	ffffffffc0205468 <do_wait.part.0>
ffffffffc0205cb0:	60e2                	ld	ra,24(sp)
ffffffffc0205cb2:	6442                	ld	s0,16(sp)
ffffffffc0205cb4:	64a2                	ld	s1,8(sp)
ffffffffc0205cb6:	5575                	li	a0,-3
ffffffffc0205cb8:	6105                	addi	sp,sp,32
ffffffffc0205cba:	8082                	ret

ffffffffc0205cbc <do_kill>:
do_kill(int pid) {
ffffffffc0205cbc:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID) {
ffffffffc0205cbe:	6789                	lui	a5,0x2
do_kill(int pid) {
ffffffffc0205cc0:	e406                	sd	ra,8(sp)
ffffffffc0205cc2:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID) {
ffffffffc0205cc4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205cc8:	17f9                	addi	a5,a5,-2
ffffffffc0205cca:	02e7e863          	bltu	a5,a4,ffffffffc0205cfa <do_kill+0x3e>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205cce:	842a                	mv	s0,a0
ffffffffc0205cd0:	45a9                	li	a1,10
ffffffffc0205cd2:	2501                	sext.w	a0,a0
ffffffffc0205cd4:	468000ef          	jal	ra,ffffffffc020613c <hash32>
ffffffffc0205cd8:	02051693          	slli	a3,a0,0x20
ffffffffc0205cdc:	82f1                	srli	a3,a3,0x1c
ffffffffc0205cde:	000a9797          	auipc	a5,0xa9
ffffffffc0205ce2:	ae278793          	addi	a5,a5,-1310 # ffffffffc02ae7c0 <hash_list>
ffffffffc0205ce6:	96be                	add	a3,a3,a5
ffffffffc0205ce8:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list) {
ffffffffc0205cea:	a029                	j	ffffffffc0205cf4 <do_kill+0x38>
            if (proc->pid == pid) {
ffffffffc0205cec:	f2c52703          	lw	a4,-212(a0)
ffffffffc0205cf0:	00870b63          	beq	a4,s0,ffffffffc0205d06 <do_kill+0x4a>
ffffffffc0205cf4:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list) {
ffffffffc0205cf6:	fea69be3          	bne	a3,a0,ffffffffc0205cec <do_kill+0x30>
    return -E_INVAL;
ffffffffc0205cfa:	5475                	li	s0,-3
}
ffffffffc0205cfc:	60a2                	ld	ra,8(sp)
ffffffffc0205cfe:	8522                	mv	a0,s0
ffffffffc0205d00:	6402                	ld	s0,0(sp)
ffffffffc0205d02:	0141                	addi	sp,sp,16
ffffffffc0205d04:	8082                	ret
        if (!(proc->flags & PF_EXITING)) {
ffffffffc0205d06:	fd852703          	lw	a4,-40(a0)
ffffffffc0205d0a:	00177693          	andi	a3,a4,1
ffffffffc0205d0e:	e295                	bnez	a3,ffffffffc0205d32 <do_kill+0x76>
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0205d10:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0205d12:	00176713          	ori	a4,a4,1
ffffffffc0205d16:	fce52c23          	sw	a4,-40(a0)
            return 0;
ffffffffc0205d1a:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0205d1c:	fe06d0e3          	bgez	a3,ffffffffc0205cfc <do_kill+0x40>
                wakeup_proc(proc);
ffffffffc0205d20:	f2850513          	addi	a0,a0,-216
ffffffffc0205d24:	22c000ef          	jal	ra,ffffffffc0205f50 <wakeup_proc>
}
ffffffffc0205d28:	60a2                	ld	ra,8(sp)
ffffffffc0205d2a:	8522                	mv	a0,s0
ffffffffc0205d2c:	6402                	ld	s0,0(sp)
ffffffffc0205d2e:	0141                	addi	sp,sp,16
ffffffffc0205d30:	8082                	ret
        return -E_KILLED;
ffffffffc0205d32:	545d                	li	s0,-9
ffffffffc0205d34:	b7e1                	j	ffffffffc0205cfc <do_kill+0x40>

ffffffffc0205d36 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc0205d36:	1101                	addi	sp,sp,-32
ffffffffc0205d38:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205d3a:	000ad797          	auipc	a5,0xad
ffffffffc0205d3e:	a8678793          	addi	a5,a5,-1402 # ffffffffc02b27c0 <proc_list>
ffffffffc0205d42:	ec06                	sd	ra,24(sp)
ffffffffc0205d44:	e822                	sd	s0,16(sp)
ffffffffc0205d46:	e04a                	sd	s2,0(sp)
ffffffffc0205d48:	000a9497          	auipc	s1,0xa9
ffffffffc0205d4c:	a7848493          	addi	s1,s1,-1416 # ffffffffc02ae7c0 <hash_list>
ffffffffc0205d50:	e79c                	sd	a5,8(a5)
ffffffffc0205d52:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc0205d54:	000ad717          	auipc	a4,0xad
ffffffffc0205d58:	a6c70713          	addi	a4,a4,-1428 # ffffffffc02b27c0 <proc_list>
ffffffffc0205d5c:	87a6                	mv	a5,s1
ffffffffc0205d5e:	e79c                	sd	a5,8(a5)
ffffffffc0205d60:	e39c                	sd	a5,0(a5)
ffffffffc0205d62:	07c1                	addi	a5,a5,16
ffffffffc0205d64:	fef71de3          	bne	a4,a5,ffffffffc0205d5e <proc_init+0x28>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0205d68:	f7bfe0ef          	jal	ra,ffffffffc0204ce2 <alloc_proc>
ffffffffc0205d6c:	000ad917          	auipc	s2,0xad
ffffffffc0205d70:	ae490913          	addi	s2,s2,-1308 # ffffffffc02b2850 <idleproc>
ffffffffc0205d74:	00a93023          	sd	a0,0(s2)
ffffffffc0205d78:	0e050e63          	beqz	a0,ffffffffc0205e74 <proc_init+0x13e>
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205d7c:	4789                	li	a5,2
ffffffffc0205d7e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205d80:	00003797          	auipc	a5,0x3
ffffffffc0205d84:	28078793          	addi	a5,a5,640 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205d88:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205d8c:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0205d8e:	4785                	li	a5,1
ffffffffc0205d90:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205d92:	4641                	li	a2,16
ffffffffc0205d94:	4581                	li	a1,0
ffffffffc0205d96:	8522                	mv	a0,s0
ffffffffc0205d98:	025000ef          	jal	ra,ffffffffc02065bc <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205d9c:	463d                	li	a2,15
ffffffffc0205d9e:	00003597          	auipc	a1,0x3
ffffffffc0205da2:	a5a58593          	addi	a1,a1,-1446 # ffffffffc02087f8 <default_pmm_manager+0x14c0>
ffffffffc0205da6:	8522                	mv	a0,s0
ffffffffc0205da8:	027000ef          	jal	ra,ffffffffc02065ce <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc0205dac:	000ad717          	auipc	a4,0xad
ffffffffc0205db0:	ab470713          	addi	a4,a4,-1356 # ffffffffc02b2860 <nr_process>
ffffffffc0205db4:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0205db6:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205dba:	4601                	li	a2,0
    nr_process ++;
ffffffffc0205dbc:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205dbe:	4581                	li	a1,0
ffffffffc0205dc0:	00000517          	auipc	a0,0x0
ffffffffc0205dc4:	87a50513          	addi	a0,a0,-1926 # ffffffffc020563a <init_main>
    nr_process ++;
ffffffffc0205dc8:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0205dca:	000ad797          	auipc	a5,0xad
ffffffffc0205dce:	a6d7bf23          	sd	a3,-1410(a5) # ffffffffc02b2848 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205dd2:	cfcff0ef          	jal	ra,ffffffffc02052ce <kernel_thread>
ffffffffc0205dd6:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc0205dd8:	08a05263          	blez	a0,ffffffffc0205e5c <proc_init+0x126>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0205ddc:	6789                	lui	a5,0x2
ffffffffc0205dde:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205de2:	17f9                	addi	a5,a5,-2
ffffffffc0205de4:	2501                	sext.w	a0,a0
ffffffffc0205de6:	02e7e263          	bltu	a5,a4,ffffffffc0205e0a <proc_init+0xd4>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205dea:	45a9                	li	a1,10
ffffffffc0205dec:	350000ef          	jal	ra,ffffffffc020613c <hash32>
ffffffffc0205df0:	02051693          	slli	a3,a0,0x20
ffffffffc0205df4:	82f1                	srli	a3,a3,0x1c
ffffffffc0205df6:	96a6                	add	a3,a3,s1
ffffffffc0205df8:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0205dfa:	a029                	j	ffffffffc0205e04 <proc_init+0xce>
            if (proc->pid == pid) {
ffffffffc0205dfc:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc0205e00:	04870b63          	beq	a4,s0,ffffffffc0205e56 <proc_init+0x120>
    return listelm->next;
ffffffffc0205e04:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0205e06:	fef69be3          	bne	a3,a5,ffffffffc0205dfc <proc_init+0xc6>
    return NULL;
ffffffffc0205e0a:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205e0c:	0b478493          	addi	s1,a5,180
ffffffffc0205e10:	4641                	li	a2,16
ffffffffc0205e12:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205e14:	000ad417          	auipc	s0,0xad
ffffffffc0205e18:	a4440413          	addi	s0,s0,-1468 # ffffffffc02b2858 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205e1c:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205e1e:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205e20:	79c000ef          	jal	ra,ffffffffc02065bc <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205e24:	463d                	li	a2,15
ffffffffc0205e26:	00003597          	auipc	a1,0x3
ffffffffc0205e2a:	9fa58593          	addi	a1,a1,-1542 # ffffffffc0208820 <default_pmm_manager+0x14e8>
ffffffffc0205e2e:	8526                	mv	a0,s1
ffffffffc0205e30:	79e000ef          	jal	ra,ffffffffc02065ce <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205e34:	00093783          	ld	a5,0(s2)
ffffffffc0205e38:	cbb5                	beqz	a5,ffffffffc0205eac <proc_init+0x176>
ffffffffc0205e3a:	43dc                	lw	a5,4(a5)
ffffffffc0205e3c:	eba5                	bnez	a5,ffffffffc0205eac <proc_init+0x176>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205e3e:	601c                	ld	a5,0(s0)
ffffffffc0205e40:	c7b1                	beqz	a5,ffffffffc0205e8c <proc_init+0x156>
ffffffffc0205e42:	43d8                	lw	a4,4(a5)
ffffffffc0205e44:	4785                	li	a5,1
ffffffffc0205e46:	04f71363          	bne	a4,a5,ffffffffc0205e8c <proc_init+0x156>
}
ffffffffc0205e4a:	60e2                	ld	ra,24(sp)
ffffffffc0205e4c:	6442                	ld	s0,16(sp)
ffffffffc0205e4e:	64a2                	ld	s1,8(sp)
ffffffffc0205e50:	6902                	ld	s2,0(sp)
ffffffffc0205e52:	6105                	addi	sp,sp,32
ffffffffc0205e54:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205e56:	f2878793          	addi	a5,a5,-216
ffffffffc0205e5a:	bf4d                	j	ffffffffc0205e0c <proc_init+0xd6>
        panic("create init_main failed.\n");
ffffffffc0205e5c:	00003617          	auipc	a2,0x3
ffffffffc0205e60:	9a460613          	addi	a2,a2,-1628 # ffffffffc0208800 <default_pmm_manager+0x14c8>
ffffffffc0205e64:	39900593          	li	a1,921
ffffffffc0205e68:	00002517          	auipc	a0,0x2
ffffffffc0205e6c:	60850513          	addi	a0,a0,1544 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205e70:	e0afa0ef          	jal	ra,ffffffffc020047a <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205e74:	00003617          	auipc	a2,0x3
ffffffffc0205e78:	96c60613          	addi	a2,a2,-1684 # ffffffffc02087e0 <default_pmm_manager+0x14a8>
ffffffffc0205e7c:	38b00593          	li	a1,907
ffffffffc0205e80:	00002517          	auipc	a0,0x2
ffffffffc0205e84:	5f050513          	addi	a0,a0,1520 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205e88:	df2fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205e8c:	00003697          	auipc	a3,0x3
ffffffffc0205e90:	9c468693          	addi	a3,a3,-1596 # ffffffffc0208850 <default_pmm_manager+0x1518>
ffffffffc0205e94:	00001617          	auipc	a2,0x1
ffffffffc0205e98:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205e9c:	3a000593          	li	a1,928
ffffffffc0205ea0:	00002517          	auipc	a0,0x2
ffffffffc0205ea4:	5d050513          	addi	a0,a0,1488 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205ea8:	dd2fa0ef          	jal	ra,ffffffffc020047a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205eac:	00003697          	auipc	a3,0x3
ffffffffc0205eb0:	97c68693          	addi	a3,a3,-1668 # ffffffffc0208828 <default_pmm_manager+0x14f0>
ffffffffc0205eb4:	00001617          	auipc	a2,0x1
ffffffffc0205eb8:	dec60613          	addi	a2,a2,-532 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205ebc:	39f00593          	li	a1,927
ffffffffc0205ec0:	00002517          	auipc	a0,0x2
ffffffffc0205ec4:	5b050513          	addi	a0,a0,1456 # ffffffffc0208470 <default_pmm_manager+0x1138>
ffffffffc0205ec8:	db2fa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0205ecc <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc0205ecc:	1141                	addi	sp,sp,-16
ffffffffc0205ece:	e022                	sd	s0,0(sp)
ffffffffc0205ed0:	e406                	sd	ra,8(sp)
ffffffffc0205ed2:	000ad417          	auipc	s0,0xad
ffffffffc0205ed6:	97640413          	addi	s0,s0,-1674 # ffffffffc02b2848 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0205eda:	6018                	ld	a4,0(s0)
ffffffffc0205edc:	6f1c                	ld	a5,24(a4)
ffffffffc0205ede:	dffd                	beqz	a5,ffffffffc0205edc <cpu_idle+0x10>
            schedule();
ffffffffc0205ee0:	0f0000ef          	jal	ra,ffffffffc0205fd0 <schedule>
ffffffffc0205ee4:	bfdd                	j	ffffffffc0205eda <cpu_idle+0xe>

ffffffffc0205ee6 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205ee6:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205eea:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205eee:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205ef0:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205ef2:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205ef6:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205efa:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205efe:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0205f02:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205f06:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205f0a:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205f0e:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0205f12:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205f16:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205f1a:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205f1e:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205f22:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205f24:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205f26:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205f2a:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205f2e:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205f32:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205f36:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205f3a:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205f3e:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205f42:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205f46:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205f4a:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205f4e:	8082                	ret

ffffffffc0205f50 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205f50:	4118                	lw	a4,0(a0)
wakeup_proc(struct proc_struct *proc) {
ffffffffc0205f52:	1101                	addi	sp,sp,-32
ffffffffc0205f54:	ec06                	sd	ra,24(sp)
ffffffffc0205f56:	e822                	sd	s0,16(sp)
ffffffffc0205f58:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205f5a:	478d                	li	a5,3
ffffffffc0205f5c:	04f70b63          	beq	a4,a5,ffffffffc0205fb2 <wakeup_proc+0x62>
ffffffffc0205f60:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205f62:	100027f3          	csrr	a5,sstatus
ffffffffc0205f66:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205f68:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205f6a:	ef9d                	bnez	a5,ffffffffc0205fa8 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0205f6c:	4789                	li	a5,2
ffffffffc0205f6e:	02f70163          	beq	a4,a5,ffffffffc0205f90 <wakeup_proc+0x40>
            proc->state = PROC_RUNNABLE;
ffffffffc0205f72:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205f74:	0e042623          	sw	zero,236(s0)
    if (flag) {
ffffffffc0205f78:	e491                	bnez	s1,ffffffffc0205f84 <wakeup_proc+0x34>
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205f7a:	60e2                	ld	ra,24(sp)
ffffffffc0205f7c:	6442                	ld	s0,16(sp)
ffffffffc0205f7e:	64a2                	ld	s1,8(sp)
ffffffffc0205f80:	6105                	addi	sp,sp,32
ffffffffc0205f82:	8082                	ret
ffffffffc0205f84:	6442                	ld	s0,16(sp)
ffffffffc0205f86:	60e2                	ld	ra,24(sp)
ffffffffc0205f88:	64a2                	ld	s1,8(sp)
ffffffffc0205f8a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205f8c:	eb4fa06f          	j	ffffffffc0200640 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205f90:	00003617          	auipc	a2,0x3
ffffffffc0205f94:	92060613          	addi	a2,a2,-1760 # ffffffffc02088b0 <default_pmm_manager+0x1578>
ffffffffc0205f98:	45c9                	li	a1,18
ffffffffc0205f9a:	00003517          	auipc	a0,0x3
ffffffffc0205f9e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0208898 <default_pmm_manager+0x1560>
ffffffffc0205fa2:	d40fa0ef          	jal	ra,ffffffffc02004e2 <__warn>
ffffffffc0205fa6:	bfc9                	j	ffffffffc0205f78 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205fa8:	e9efa0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0205fac:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205fae:	4485                	li	s1,1
ffffffffc0205fb0:	bf75                	j	ffffffffc0205f6c <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205fb2:	00003697          	auipc	a3,0x3
ffffffffc0205fb6:	8c668693          	addi	a3,a3,-1850 # ffffffffc0208878 <default_pmm_manager+0x1540>
ffffffffc0205fba:	00001617          	auipc	a2,0x1
ffffffffc0205fbe:	ce660613          	addi	a2,a2,-794 # ffffffffc0206ca0 <commands+0x450>
ffffffffc0205fc2:	45a5                	li	a1,9
ffffffffc0205fc4:	00003517          	auipc	a0,0x3
ffffffffc0205fc8:	8d450513          	addi	a0,a0,-1836 # ffffffffc0208898 <default_pmm_manager+0x1560>
ffffffffc0205fcc:	caefa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc0205fd0 <schedule>:

void
schedule(void) {
ffffffffc0205fd0:	1141                	addi	sp,sp,-16
ffffffffc0205fd2:	e406                	sd	ra,8(sp)
ffffffffc0205fd4:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205fd6:	100027f3          	csrr	a5,sstatus
ffffffffc0205fda:	8b89                	andi	a5,a5,2
ffffffffc0205fdc:	4401                	li	s0,0
ffffffffc0205fde:	efbd                	bnez	a5,ffffffffc020605c <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205fe0:	000ad897          	auipc	a7,0xad
ffffffffc0205fe4:	8688b883          	ld	a7,-1944(a7) # ffffffffc02b2848 <current>
ffffffffc0205fe8:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205fec:	000ad517          	auipc	a0,0xad
ffffffffc0205ff0:	86453503          	ld	a0,-1948(a0) # ffffffffc02b2850 <idleproc>
ffffffffc0205ff4:	04a88e63          	beq	a7,a0,ffffffffc0206050 <schedule+0x80>
ffffffffc0205ff8:	0c888693          	addi	a3,a7,200
ffffffffc0205ffc:	000ac617          	auipc	a2,0xac
ffffffffc0206000:	7c460613          	addi	a2,a2,1988 # ffffffffc02b27c0 <proc_list>
        le = last;
ffffffffc0206004:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0206006:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206008:	4809                	li	a6,2
ffffffffc020600a:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020600c:	00c78863          	beq	a5,a2,ffffffffc020601c <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206010:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0206014:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206018:	03070163          	beq	a4,a6,ffffffffc020603a <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc020601c:	fef697e3          	bne	a3,a5,ffffffffc020600a <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0206020:	ed89                	bnez	a1,ffffffffc020603a <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0206022:	451c                	lw	a5,8(a0)
ffffffffc0206024:	2785                	addiw	a5,a5,1
ffffffffc0206026:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0206028:	00a88463          	beq	a7,a0,ffffffffc0206030 <schedule+0x60>
            proc_run(next);
ffffffffc020602c:	e2bfe0ef          	jal	ra,ffffffffc0204e56 <proc_run>
    if (flag) {
ffffffffc0206030:	e819                	bnez	s0,ffffffffc0206046 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0206032:	60a2                	ld	ra,8(sp)
ffffffffc0206034:	6402                	ld	s0,0(sp)
ffffffffc0206036:	0141                	addi	sp,sp,16
ffffffffc0206038:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc020603a:	4198                	lw	a4,0(a1)
ffffffffc020603c:	4789                	li	a5,2
ffffffffc020603e:	fef712e3          	bne	a4,a5,ffffffffc0206022 <schedule+0x52>
ffffffffc0206042:	852e                	mv	a0,a1
ffffffffc0206044:	bff9                	j	ffffffffc0206022 <schedule+0x52>
}
ffffffffc0206046:	6402                	ld	s0,0(sp)
ffffffffc0206048:	60a2                	ld	ra,8(sp)
ffffffffc020604a:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020604c:	df4fa06f          	j	ffffffffc0200640 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0206050:	000ac617          	auipc	a2,0xac
ffffffffc0206054:	77060613          	addi	a2,a2,1904 # ffffffffc02b27c0 <proc_list>
ffffffffc0206058:	86b2                	mv	a3,a2
ffffffffc020605a:	b76d                	j	ffffffffc0206004 <schedule+0x34>
        intr_disable();
ffffffffc020605c:	deafa0ef          	jal	ra,ffffffffc0200646 <intr_disable>
        return 1;
ffffffffc0206060:	4405                	li	s0,1
ffffffffc0206062:	bfbd                	j	ffffffffc0205fe0 <schedule+0x10>

ffffffffc0206064 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0206064:	000ac797          	auipc	a5,0xac
ffffffffc0206068:	7e47b783          	ld	a5,2020(a5) # ffffffffc02b2848 <current>
}
ffffffffc020606c:	43c8                	lw	a0,4(a5)
ffffffffc020606e:	8082                	ret

ffffffffc0206070 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0206070:	4501                	li	a0,0
ffffffffc0206072:	8082                	ret

ffffffffc0206074 <sys_putc>:
    cputchar(c);
ffffffffc0206074:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0206076:	1141                	addi	sp,sp,-16
ffffffffc0206078:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020607a:	93cfa0ef          	jal	ra,ffffffffc02001b6 <cputchar>
}
ffffffffc020607e:	60a2                	ld	ra,8(sp)
ffffffffc0206080:	4501                	li	a0,0
ffffffffc0206082:	0141                	addi	sp,sp,16
ffffffffc0206084:	8082                	ret

ffffffffc0206086 <sys_kill>:
    return do_kill(pid);
ffffffffc0206086:	4108                	lw	a0,0(a0)
ffffffffc0206088:	c35ff06f          	j	ffffffffc0205cbc <do_kill>

ffffffffc020608c <sys_yield>:
    return do_yield();
ffffffffc020608c:	be3ff06f          	j	ffffffffc0205c6e <do_yield>

ffffffffc0206090 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0206090:	6d14                	ld	a3,24(a0)
ffffffffc0206092:	6910                	ld	a2,16(a0)
ffffffffc0206094:	650c                	ld	a1,8(a0)
ffffffffc0206096:	6108                	ld	a0,0(a0)
ffffffffc0206098:	ec6ff06f          	j	ffffffffc020575e <do_execve>

ffffffffc020609c <sys_wait>:
    return do_wait(pid, store);
ffffffffc020609c:	650c                	ld	a1,8(a0)
ffffffffc020609e:	4108                	lw	a0,0(a0)
ffffffffc02060a0:	bdfff06f          	j	ffffffffc0205c7e <do_wait>

ffffffffc02060a4 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02060a4:	000ac797          	auipc	a5,0xac
ffffffffc02060a8:	7a47b783          	ld	a5,1956(a5) # ffffffffc02b2848 <current>
ffffffffc02060ac:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02060ae:	4501                	li	a0,0
ffffffffc02060b0:	6a0c                	ld	a1,16(a2)
ffffffffc02060b2:	e11fe06f          	j	ffffffffc0204ec2 <do_fork>

ffffffffc02060b6 <sys_exit>:
    return do_exit(error_code);
ffffffffc02060b6:	4108                	lw	a0,0(a0)
ffffffffc02060b8:	a66ff06f          	j	ffffffffc020531e <do_exit>

ffffffffc02060bc <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02060bc:	715d                	addi	sp,sp,-80
ffffffffc02060be:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02060c0:	000ac497          	auipc	s1,0xac
ffffffffc02060c4:	78848493          	addi	s1,s1,1928 # ffffffffc02b2848 <current>
ffffffffc02060c8:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02060ca:	e0a2                	sd	s0,64(sp)
ffffffffc02060cc:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02060ce:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02060d0:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02060d2:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02060d4:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02060d8:	0327ee63          	bltu	a5,s2,ffffffffc0206114 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02060dc:	00391713          	slli	a4,s2,0x3
ffffffffc02060e0:	00003797          	auipc	a5,0x3
ffffffffc02060e4:	83878793          	addi	a5,a5,-1992 # ffffffffc0208918 <syscalls>
ffffffffc02060e8:	97ba                	add	a5,a5,a4
ffffffffc02060ea:	639c                	ld	a5,0(a5)
ffffffffc02060ec:	c785                	beqz	a5,ffffffffc0206114 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02060ee:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02060f0:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02060f2:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02060f4:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02060f6:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02060f8:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02060fa:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02060fc:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02060fe:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc0206100:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0206102:	0028                	addi	a0,sp,8
ffffffffc0206104:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0206106:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0206108:	e828                	sd	a0,80(s0)
}
ffffffffc020610a:	6406                	ld	s0,64(sp)
ffffffffc020610c:	74e2                	ld	s1,56(sp)
ffffffffc020610e:	7942                	ld	s2,48(sp)
ffffffffc0206110:	6161                	addi	sp,sp,80
ffffffffc0206112:	8082                	ret
    print_trapframe(tf);
ffffffffc0206114:	8522                	mv	a0,s0
ffffffffc0206116:	f1efa0ef          	jal	ra,ffffffffc0200834 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020611a:	609c                	ld	a5,0(s1)
ffffffffc020611c:	86ca                	mv	a3,s2
ffffffffc020611e:	00002617          	auipc	a2,0x2
ffffffffc0206122:	7b260613          	addi	a2,a2,1970 # ffffffffc02088d0 <default_pmm_manager+0x1598>
ffffffffc0206126:	43d8                	lw	a4,4(a5)
ffffffffc0206128:	06200593          	li	a1,98
ffffffffc020612c:	0b478793          	addi	a5,a5,180
ffffffffc0206130:	00002517          	auipc	a0,0x2
ffffffffc0206134:	7d050513          	addi	a0,a0,2000 # ffffffffc0208900 <default_pmm_manager+0x15c8>
ffffffffc0206138:	b42fa0ef          	jal	ra,ffffffffc020047a <__panic>

ffffffffc020613c <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020613c:	9e3707b7          	lui	a5,0x9e370
ffffffffc0206140:	2785                	addiw	a5,a5,1
ffffffffc0206142:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0206146:	02000793          	li	a5,32
ffffffffc020614a:	9f8d                	subw	a5,a5,a1
}
ffffffffc020614c:	00f5553b          	srlw	a0,a0,a5
ffffffffc0206150:	8082                	ret

ffffffffc0206152 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0206152:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206156:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0206158:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020615c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020615e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206162:	f022                	sd	s0,32(sp)
ffffffffc0206164:	ec26                	sd	s1,24(sp)
ffffffffc0206166:	e84a                	sd	s2,16(sp)
ffffffffc0206168:	f406                	sd	ra,40(sp)
ffffffffc020616a:	e44e                	sd	s3,8(sp)
ffffffffc020616c:	84aa                	mv	s1,a0
ffffffffc020616e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0206170:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0206174:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0206176:	03067e63          	bgeu	a2,a6,ffffffffc02061b2 <printnum+0x60>
ffffffffc020617a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020617c:	00805763          	blez	s0,ffffffffc020618a <printnum+0x38>
ffffffffc0206180:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0206182:	85ca                	mv	a1,s2
ffffffffc0206184:	854e                	mv	a0,s3
ffffffffc0206186:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0206188:	fc65                	bnez	s0,ffffffffc0206180 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020618a:	1a02                	slli	s4,s4,0x20
ffffffffc020618c:	00003797          	auipc	a5,0x3
ffffffffc0206190:	88c78793          	addi	a5,a5,-1908 # ffffffffc0208a18 <syscalls+0x100>
ffffffffc0206194:	020a5a13          	srli	s4,s4,0x20
ffffffffc0206198:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020619a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020619c:	000a4503          	lbu	a0,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
}
ffffffffc02061a0:	70a2                	ld	ra,40(sp)
ffffffffc02061a2:	69a2                	ld	s3,8(sp)
ffffffffc02061a4:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061a6:	85ca                	mv	a1,s2
ffffffffc02061a8:	87a6                	mv	a5,s1
}
ffffffffc02061aa:	6942                	ld	s2,16(sp)
ffffffffc02061ac:	64e2                	ld	s1,24(sp)
ffffffffc02061ae:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061b0:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02061b2:	03065633          	divu	a2,a2,a6
ffffffffc02061b6:	8722                	mv	a4,s0
ffffffffc02061b8:	f9bff0ef          	jal	ra,ffffffffc0206152 <printnum>
ffffffffc02061bc:	b7f9                	j	ffffffffc020618a <printnum+0x38>

ffffffffc02061be <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02061be:	7119                	addi	sp,sp,-128
ffffffffc02061c0:	f4a6                	sd	s1,104(sp)
ffffffffc02061c2:	f0ca                	sd	s2,96(sp)
ffffffffc02061c4:	ecce                	sd	s3,88(sp)
ffffffffc02061c6:	e8d2                	sd	s4,80(sp)
ffffffffc02061c8:	e4d6                	sd	s5,72(sp)
ffffffffc02061ca:	e0da                	sd	s6,64(sp)
ffffffffc02061cc:	fc5e                	sd	s7,56(sp)
ffffffffc02061ce:	f06a                	sd	s10,32(sp)
ffffffffc02061d0:	fc86                	sd	ra,120(sp)
ffffffffc02061d2:	f8a2                	sd	s0,112(sp)
ffffffffc02061d4:	f862                	sd	s8,48(sp)
ffffffffc02061d6:	f466                	sd	s9,40(sp)
ffffffffc02061d8:	ec6e                	sd	s11,24(sp)
ffffffffc02061da:	892a                	mv	s2,a0
ffffffffc02061dc:	84ae                	mv	s1,a1
ffffffffc02061de:	8d32                	mv	s10,a2
ffffffffc02061e0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02061e2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02061e6:	5b7d                	li	s6,-1
ffffffffc02061e8:	00003a97          	auipc	s5,0x3
ffffffffc02061ec:	85ca8a93          	addi	s5,s5,-1956 # ffffffffc0208a44 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02061f0:	00003b97          	auipc	s7,0x3
ffffffffc02061f4:	a70b8b93          	addi	s7,s7,-1424 # ffffffffc0208c60 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02061f8:	000d4503          	lbu	a0,0(s10)
ffffffffc02061fc:	001d0413          	addi	s0,s10,1
ffffffffc0206200:	01350a63          	beq	a0,s3,ffffffffc0206214 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0206204:	c121                	beqz	a0,ffffffffc0206244 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0206206:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0206208:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020620a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020620c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0206210:	ff351ae3          	bne	a0,s3,ffffffffc0206204 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206214:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0206218:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020621c:	4c81                	li	s9,0
ffffffffc020621e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0206220:	5c7d                	li	s8,-1
ffffffffc0206222:	5dfd                	li	s11,-1
ffffffffc0206224:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0206228:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020622a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020622e:	0ff5f593          	andi	a1,a1,255
ffffffffc0206232:	00140d13          	addi	s10,s0,1
ffffffffc0206236:	04b56263          	bltu	a0,a1,ffffffffc020627a <vprintfmt+0xbc>
ffffffffc020623a:	058a                	slli	a1,a1,0x2
ffffffffc020623c:	95d6                	add	a1,a1,s5
ffffffffc020623e:	4194                	lw	a3,0(a1)
ffffffffc0206240:	96d6                	add	a3,a3,s5
ffffffffc0206242:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0206244:	70e6                	ld	ra,120(sp)
ffffffffc0206246:	7446                	ld	s0,112(sp)
ffffffffc0206248:	74a6                	ld	s1,104(sp)
ffffffffc020624a:	7906                	ld	s2,96(sp)
ffffffffc020624c:	69e6                	ld	s3,88(sp)
ffffffffc020624e:	6a46                	ld	s4,80(sp)
ffffffffc0206250:	6aa6                	ld	s5,72(sp)
ffffffffc0206252:	6b06                	ld	s6,64(sp)
ffffffffc0206254:	7be2                	ld	s7,56(sp)
ffffffffc0206256:	7c42                	ld	s8,48(sp)
ffffffffc0206258:	7ca2                	ld	s9,40(sp)
ffffffffc020625a:	7d02                	ld	s10,32(sp)
ffffffffc020625c:	6de2                	ld	s11,24(sp)
ffffffffc020625e:	6109                	addi	sp,sp,128
ffffffffc0206260:	8082                	ret
            padc = '0';
ffffffffc0206262:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0206264:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206268:	846a                	mv	s0,s10
ffffffffc020626a:	00140d13          	addi	s10,s0,1
ffffffffc020626e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0206272:	0ff5f593          	andi	a1,a1,255
ffffffffc0206276:	fcb572e3          	bgeu	a0,a1,ffffffffc020623a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020627a:	85a6                	mv	a1,s1
ffffffffc020627c:	02500513          	li	a0,37
ffffffffc0206280:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0206282:	fff44783          	lbu	a5,-1(s0)
ffffffffc0206286:	8d22                	mv	s10,s0
ffffffffc0206288:	f73788e3          	beq	a5,s3,ffffffffc02061f8 <vprintfmt+0x3a>
ffffffffc020628c:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0206290:	1d7d                	addi	s10,s10,-1
ffffffffc0206292:	ff379de3          	bne	a5,s3,ffffffffc020628c <vprintfmt+0xce>
ffffffffc0206296:	b78d                	j	ffffffffc02061f8 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0206298:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020629c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062a0:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02062a2:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02062a6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02062aa:	02d86463          	bltu	a6,a3,ffffffffc02062d2 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02062ae:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02062b2:	002c169b          	slliw	a3,s8,0x2
ffffffffc02062b6:	0186873b          	addw	a4,a3,s8
ffffffffc02062ba:	0017171b          	slliw	a4,a4,0x1
ffffffffc02062be:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02062c0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02062c4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02062c6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02062ca:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02062ce:	fed870e3          	bgeu	a6,a3,ffffffffc02062ae <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02062d2:	f40ddce3          	bgez	s11,ffffffffc020622a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02062d6:	8de2                	mv	s11,s8
ffffffffc02062d8:	5c7d                	li	s8,-1
ffffffffc02062da:	bf81                	j	ffffffffc020622a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02062dc:	fffdc693          	not	a3,s11
ffffffffc02062e0:	96fd                	srai	a3,a3,0x3f
ffffffffc02062e2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062e6:	00144603          	lbu	a2,1(s0)
ffffffffc02062ea:	2d81                	sext.w	s11,s11
ffffffffc02062ec:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02062ee:	bf35                	j	ffffffffc020622a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02062f0:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062f4:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02062f8:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062fa:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02062fc:	bfd9                	j	ffffffffc02062d2 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02062fe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206300:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206304:	01174463          	blt	a4,a7,ffffffffc020630c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0206308:	1a088e63          	beqz	a7,ffffffffc02064c4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020630c:	000a3603          	ld	a2,0(s4)
ffffffffc0206310:	46c1                	li	a3,16
ffffffffc0206312:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0206314:	2781                	sext.w	a5,a5
ffffffffc0206316:	876e                	mv	a4,s11
ffffffffc0206318:	85a6                	mv	a1,s1
ffffffffc020631a:	854a                	mv	a0,s2
ffffffffc020631c:	e37ff0ef          	jal	ra,ffffffffc0206152 <printnum>
            break;
ffffffffc0206320:	bde1                	j	ffffffffc02061f8 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0206322:	000a2503          	lw	a0,0(s4)
ffffffffc0206326:	85a6                	mv	a1,s1
ffffffffc0206328:	0a21                	addi	s4,s4,8
ffffffffc020632a:	9902                	jalr	s2
            break;
ffffffffc020632c:	b5f1                	j	ffffffffc02061f8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020632e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206330:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206334:	01174463          	blt	a4,a7,ffffffffc020633c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0206338:	18088163          	beqz	a7,ffffffffc02064ba <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020633c:	000a3603          	ld	a2,0(s4)
ffffffffc0206340:	46a9                	li	a3,10
ffffffffc0206342:	8a2e                	mv	s4,a1
ffffffffc0206344:	bfc1                	j	ffffffffc0206314 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206346:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020634a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020634c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020634e:	bdf1                	j	ffffffffc020622a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0206350:	85a6                	mv	a1,s1
ffffffffc0206352:	02500513          	li	a0,37
ffffffffc0206356:	9902                	jalr	s2
            break;
ffffffffc0206358:	b545                	j	ffffffffc02061f8 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020635a:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020635e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206360:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0206362:	b5e1                	j	ffffffffc020622a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0206364:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206366:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020636a:	01174463          	blt	a4,a7,ffffffffc0206372 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020636e:	14088163          	beqz	a7,ffffffffc02064b0 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0206372:	000a3603          	ld	a2,0(s4)
ffffffffc0206376:	46a1                	li	a3,8
ffffffffc0206378:	8a2e                	mv	s4,a1
ffffffffc020637a:	bf69                	j	ffffffffc0206314 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020637c:	03000513          	li	a0,48
ffffffffc0206380:	85a6                	mv	a1,s1
ffffffffc0206382:	e03e                	sd	a5,0(sp)
ffffffffc0206384:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0206386:	85a6                	mv	a1,s1
ffffffffc0206388:	07800513          	li	a0,120
ffffffffc020638c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020638e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0206390:	6782                	ld	a5,0(sp)
ffffffffc0206392:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0206394:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0206398:	bfb5                	j	ffffffffc0206314 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020639a:	000a3403          	ld	s0,0(s4)
ffffffffc020639e:	008a0713          	addi	a4,s4,8
ffffffffc02063a2:	e03a                	sd	a4,0(sp)
ffffffffc02063a4:	14040263          	beqz	s0,ffffffffc02064e8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02063a8:	0fb05763          	blez	s11,ffffffffc0206496 <vprintfmt+0x2d8>
ffffffffc02063ac:	02d00693          	li	a3,45
ffffffffc02063b0:	0cd79163          	bne	a5,a3,ffffffffc0206472 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02063b4:	00044783          	lbu	a5,0(s0)
ffffffffc02063b8:	0007851b          	sext.w	a0,a5
ffffffffc02063bc:	cf85                	beqz	a5,ffffffffc02063f4 <vprintfmt+0x236>
ffffffffc02063be:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02063c2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02063c6:	000c4563          	bltz	s8,ffffffffc02063d0 <vprintfmt+0x212>
ffffffffc02063ca:	3c7d                	addiw	s8,s8,-1
ffffffffc02063cc:	036c0263          	beq	s8,s6,ffffffffc02063f0 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02063d0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02063d2:	0e0c8e63          	beqz	s9,ffffffffc02064ce <vprintfmt+0x310>
ffffffffc02063d6:	3781                	addiw	a5,a5,-32
ffffffffc02063d8:	0ef47b63          	bgeu	s0,a5,ffffffffc02064ce <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02063dc:	03f00513          	li	a0,63
ffffffffc02063e0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02063e2:	000a4783          	lbu	a5,0(s4)
ffffffffc02063e6:	3dfd                	addiw	s11,s11,-1
ffffffffc02063e8:	0a05                	addi	s4,s4,1
ffffffffc02063ea:	0007851b          	sext.w	a0,a5
ffffffffc02063ee:	ffe1                	bnez	a5,ffffffffc02063c6 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02063f0:	01b05963          	blez	s11,ffffffffc0206402 <vprintfmt+0x244>
ffffffffc02063f4:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02063f6:	85a6                	mv	a1,s1
ffffffffc02063f8:	02000513          	li	a0,32
ffffffffc02063fc:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02063fe:	fe0d9be3          	bnez	s11,ffffffffc02063f4 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206402:	6a02                	ld	s4,0(sp)
ffffffffc0206404:	bbd5                	j	ffffffffc02061f8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0206406:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206408:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020640c:	01174463          	blt	a4,a7,ffffffffc0206414 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0206410:	08088d63          	beqz	a7,ffffffffc02064aa <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0206414:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0206418:	0a044d63          	bltz	s0,ffffffffc02064d2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020641c:	8622                	mv	a2,s0
ffffffffc020641e:	8a66                	mv	s4,s9
ffffffffc0206420:	46a9                	li	a3,10
ffffffffc0206422:	bdcd                	j	ffffffffc0206314 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0206424:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206428:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020642a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020642c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0206430:	8fb5                	xor	a5,a5,a3
ffffffffc0206432:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206436:	02d74163          	blt	a4,a3,ffffffffc0206458 <vprintfmt+0x29a>
ffffffffc020643a:	00369793          	slli	a5,a3,0x3
ffffffffc020643e:	97de                	add	a5,a5,s7
ffffffffc0206440:	639c                	ld	a5,0(a5)
ffffffffc0206442:	cb99                	beqz	a5,ffffffffc0206458 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0206444:	86be                	mv	a3,a5
ffffffffc0206446:	00000617          	auipc	a2,0x0
ffffffffc020644a:	1ca60613          	addi	a2,a2,458 # ffffffffc0206610 <etext+0x2a>
ffffffffc020644e:	85a6                	mv	a1,s1
ffffffffc0206450:	854a                	mv	a0,s2
ffffffffc0206452:	0ce000ef          	jal	ra,ffffffffc0206520 <printfmt>
ffffffffc0206456:	b34d                	j	ffffffffc02061f8 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0206458:	00002617          	auipc	a2,0x2
ffffffffc020645c:	5e060613          	addi	a2,a2,1504 # ffffffffc0208a38 <syscalls+0x120>
ffffffffc0206460:	85a6                	mv	a1,s1
ffffffffc0206462:	854a                	mv	a0,s2
ffffffffc0206464:	0bc000ef          	jal	ra,ffffffffc0206520 <printfmt>
ffffffffc0206468:	bb41                	j	ffffffffc02061f8 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020646a:	00002417          	auipc	s0,0x2
ffffffffc020646e:	5c640413          	addi	s0,s0,1478 # ffffffffc0208a30 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206472:	85e2                	mv	a1,s8
ffffffffc0206474:	8522                	mv	a0,s0
ffffffffc0206476:	e43e                	sd	a5,8(sp)
ffffffffc0206478:	0e2000ef          	jal	ra,ffffffffc020655a <strnlen>
ffffffffc020647c:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0206480:	01b05b63          	blez	s11,ffffffffc0206496 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0206484:	67a2                	ld	a5,8(sp)
ffffffffc0206486:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020648a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020648c:	85a6                	mv	a1,s1
ffffffffc020648e:	8552                	mv	a0,s4
ffffffffc0206490:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206492:	fe0d9ce3          	bnez	s11,ffffffffc020648a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206496:	00044783          	lbu	a5,0(s0)
ffffffffc020649a:	00140a13          	addi	s4,s0,1
ffffffffc020649e:	0007851b          	sext.w	a0,a5
ffffffffc02064a2:	d3a5                	beqz	a5,ffffffffc0206402 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02064a4:	05e00413          	li	s0,94
ffffffffc02064a8:	bf39                	j	ffffffffc02063c6 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02064aa:	000a2403          	lw	s0,0(s4)
ffffffffc02064ae:	b7ad                	j	ffffffffc0206418 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02064b0:	000a6603          	lwu	a2,0(s4)
ffffffffc02064b4:	46a1                	li	a3,8
ffffffffc02064b6:	8a2e                	mv	s4,a1
ffffffffc02064b8:	bdb1                	j	ffffffffc0206314 <vprintfmt+0x156>
ffffffffc02064ba:	000a6603          	lwu	a2,0(s4)
ffffffffc02064be:	46a9                	li	a3,10
ffffffffc02064c0:	8a2e                	mv	s4,a1
ffffffffc02064c2:	bd89                	j	ffffffffc0206314 <vprintfmt+0x156>
ffffffffc02064c4:	000a6603          	lwu	a2,0(s4)
ffffffffc02064c8:	46c1                	li	a3,16
ffffffffc02064ca:	8a2e                	mv	s4,a1
ffffffffc02064cc:	b5a1                	j	ffffffffc0206314 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02064ce:	9902                	jalr	s2
ffffffffc02064d0:	bf09                	j	ffffffffc02063e2 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02064d2:	85a6                	mv	a1,s1
ffffffffc02064d4:	02d00513          	li	a0,45
ffffffffc02064d8:	e03e                	sd	a5,0(sp)
ffffffffc02064da:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02064dc:	6782                	ld	a5,0(sp)
ffffffffc02064de:	8a66                	mv	s4,s9
ffffffffc02064e0:	40800633          	neg	a2,s0
ffffffffc02064e4:	46a9                	li	a3,10
ffffffffc02064e6:	b53d                	j	ffffffffc0206314 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02064e8:	03b05163          	blez	s11,ffffffffc020650a <vprintfmt+0x34c>
ffffffffc02064ec:	02d00693          	li	a3,45
ffffffffc02064f0:	f6d79de3          	bne	a5,a3,ffffffffc020646a <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02064f4:	00002417          	auipc	s0,0x2
ffffffffc02064f8:	53c40413          	addi	s0,s0,1340 # ffffffffc0208a30 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02064fc:	02800793          	li	a5,40
ffffffffc0206500:	02800513          	li	a0,40
ffffffffc0206504:	00140a13          	addi	s4,s0,1
ffffffffc0206508:	bd6d                	j	ffffffffc02063c2 <vprintfmt+0x204>
ffffffffc020650a:	00002a17          	auipc	s4,0x2
ffffffffc020650e:	527a0a13          	addi	s4,s4,1319 # ffffffffc0208a31 <syscalls+0x119>
ffffffffc0206512:	02800513          	li	a0,40
ffffffffc0206516:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020651a:	05e00413          	li	s0,94
ffffffffc020651e:	b565                	j	ffffffffc02063c6 <vprintfmt+0x208>

ffffffffc0206520 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206520:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0206522:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206526:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206528:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020652a:	ec06                	sd	ra,24(sp)
ffffffffc020652c:	f83a                	sd	a4,48(sp)
ffffffffc020652e:	fc3e                	sd	a5,56(sp)
ffffffffc0206530:	e0c2                	sd	a6,64(sp)
ffffffffc0206532:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0206534:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206536:	c89ff0ef          	jal	ra,ffffffffc02061be <vprintfmt>
}
ffffffffc020653a:	60e2                	ld	ra,24(sp)
ffffffffc020653c:	6161                	addi	sp,sp,80
ffffffffc020653e:	8082                	ret

ffffffffc0206540 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0206540:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0206544:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0206546:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0206548:	cb81                	beqz	a5,ffffffffc0206558 <strlen+0x18>
        cnt ++;
ffffffffc020654a:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020654c:	00a707b3          	add	a5,a4,a0
ffffffffc0206550:	0007c783          	lbu	a5,0(a5)
ffffffffc0206554:	fbfd                	bnez	a5,ffffffffc020654a <strlen+0xa>
ffffffffc0206556:	8082                	ret
    }
    return cnt;
}
ffffffffc0206558:	8082                	ret

ffffffffc020655a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020655a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020655c:	e589                	bnez	a1,ffffffffc0206566 <strnlen+0xc>
ffffffffc020655e:	a811                	j	ffffffffc0206572 <strnlen+0x18>
        cnt ++;
ffffffffc0206560:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206562:	00f58863          	beq	a1,a5,ffffffffc0206572 <strnlen+0x18>
ffffffffc0206566:	00f50733          	add	a4,a0,a5
ffffffffc020656a:	00074703          	lbu	a4,0(a4)
ffffffffc020656e:	fb6d                	bnez	a4,ffffffffc0206560 <strnlen+0x6>
ffffffffc0206570:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0206572:	852e                	mv	a0,a1
ffffffffc0206574:	8082                	ret

ffffffffc0206576 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0206576:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0206578:	0005c703          	lbu	a4,0(a1)
ffffffffc020657c:	0785                	addi	a5,a5,1
ffffffffc020657e:	0585                	addi	a1,a1,1
ffffffffc0206580:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0206584:	fb75                	bnez	a4,ffffffffc0206578 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0206586:	8082                	ret

ffffffffc0206588 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206588:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020658c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206590:	cb89                	beqz	a5,ffffffffc02065a2 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0206592:	0505                	addi	a0,a0,1
ffffffffc0206594:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206596:	fee789e3          	beq	a5,a4,ffffffffc0206588 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020659a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020659e:	9d19                	subw	a0,a0,a4
ffffffffc02065a0:	8082                	ret
ffffffffc02065a2:	4501                	li	a0,0
ffffffffc02065a4:	bfed                	j	ffffffffc020659e <strcmp+0x16>

ffffffffc02065a6 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02065a6:	00054783          	lbu	a5,0(a0)
ffffffffc02065aa:	c799                	beqz	a5,ffffffffc02065b8 <strchr+0x12>
        if (*s == c) {
ffffffffc02065ac:	00f58763          	beq	a1,a5,ffffffffc02065ba <strchr+0x14>
    while (*s != '\0') {
ffffffffc02065b0:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02065b4:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02065b6:	fbfd                	bnez	a5,ffffffffc02065ac <strchr+0x6>
    }
    return NULL;
ffffffffc02065b8:	4501                	li	a0,0
}
ffffffffc02065ba:	8082                	ret

ffffffffc02065bc <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02065bc:	ca01                	beqz	a2,ffffffffc02065cc <memset+0x10>
ffffffffc02065be:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02065c0:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02065c2:	0785                	addi	a5,a5,1
ffffffffc02065c4:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02065c8:	fec79de3          	bne	a5,a2,ffffffffc02065c2 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02065cc:	8082                	ret

ffffffffc02065ce <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02065ce:	ca19                	beqz	a2,ffffffffc02065e4 <memcpy+0x16>
ffffffffc02065d0:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02065d2:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02065d4:	0005c703          	lbu	a4,0(a1)
ffffffffc02065d8:	0585                	addi	a1,a1,1
ffffffffc02065da:	0785                	addi	a5,a5,1
ffffffffc02065dc:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02065e0:	fec59ae3          	bne	a1,a2,ffffffffc02065d4 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02065e4:	8082                	ret
