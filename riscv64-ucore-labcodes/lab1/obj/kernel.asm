
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	01660613          	addi	a2,a2,22 # 80204028 <end>
int kern_init(void) {
    8020001a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
int kern_init(void) {
    80200020:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
    80200022:	1d9000ef          	jal	ra,802009fa <memset>

    cons_init();  // init the console
    80200026:	150000ef          	jal	ra,80200176 <cons_init>

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	9e658593          	addi	a1,a1,-1562 # 80200a10 <etext+0x4>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	9fe50513          	addi	a0,a0,-1538 # 80200a30 <etext+0x24>
    8020003a:	036000ef          	jal	ra,80200070 <cprintf>

    print_kerninfo();
    8020003e:	068000ef          	jal	ra,802000a6 <print_kerninfo>

    // grade_backtrace();

    idt_init();  // init interrupt descriptor table
    80200042:	144000ef          	jal	ra,80200186 <idt_init>

    // rdtime in mbare mode crashes
    clock_init();  // init clock interrupt
    80200046:	0ee000ef          	jal	ra,80200134 <clock_init>

    intr_enable();  // enable irq interrupt
    8020004a:	136000ef          	jal	ra,80200180 <intr_enable>
    
    asm("mret");// 测试非法指令异常
    8020004e:	30200073          	mret
    asm("ebreak");// 测试断点异常
    80200052:	9002                	ebreak
    
    while (1)
    80200054:	a001                	j	80200054 <kern_init+0x4a>

0000000080200056 <cputch>:
    80200056:	1141                	addi	sp,sp,-16
    80200058:	e022                	sd	s0,0(sp)
    8020005a:	e406                	sd	ra,8(sp)
    8020005c:	842e                	mv	s0,a1
    8020005e:	11a000ef          	jal	ra,80200178 <cons_putc>
    80200062:	401c                	lw	a5,0(s0)
    80200064:	60a2                	ld	ra,8(sp)
    80200066:	2785                	addiw	a5,a5,1
    80200068:	c01c                	sw	a5,0(s0)
    8020006a:	6402                	ld	s0,0(sp)
    8020006c:	0141                	addi	sp,sp,16
    8020006e:	8082                	ret

0000000080200070 <cprintf>:
    80200070:	711d                	addi	sp,sp,-96
    80200072:	02810313          	addi	t1,sp,40 # 80204028 <end>
    80200076:	8e2a                	mv	t3,a0
    80200078:	f42e                	sd	a1,40(sp)
    8020007a:	f832                	sd	a2,48(sp)
    8020007c:	fc36                	sd	a3,56(sp)
    8020007e:	00000517          	auipc	a0,0x0
    80200082:	fd850513          	addi	a0,a0,-40 # 80200056 <cputch>
    80200086:	004c                	addi	a1,sp,4
    80200088:	869a                	mv	a3,t1
    8020008a:	8672                	mv	a2,t3
    8020008c:	ec06                	sd	ra,24(sp)
    8020008e:	e0ba                	sd	a4,64(sp)
    80200090:	e4be                	sd	a5,72(sp)
    80200092:	e8c2                	sd	a6,80(sp)
    80200094:	ecc6                	sd	a7,88(sp)
    80200096:	e41a                	sd	t1,8(sp)
    80200098:	c202                	sw	zero,4(sp)
    8020009a:	574000ef          	jal	ra,8020060e <vprintfmt>
    8020009e:	60e2                	ld	ra,24(sp)
    802000a0:	4512                	lw	a0,4(sp)
    802000a2:	6125                	addi	sp,sp,96
    802000a4:	8082                	ret

00000000802000a6 <print_kerninfo>:
    802000a6:	1141                	addi	sp,sp,-16
    802000a8:	00001517          	auipc	a0,0x1
    802000ac:	99050513          	addi	a0,a0,-1648 # 80200a38 <etext+0x2c>
    802000b0:	e406                	sd	ra,8(sp)
    802000b2:	fbfff0ef          	jal	ra,80200070 <cprintf>
    802000b6:	00000597          	auipc	a1,0x0
    802000ba:	f5458593          	addi	a1,a1,-172 # 8020000a <kern_init>
    802000be:	00001517          	auipc	a0,0x1
    802000c2:	99a50513          	addi	a0,a0,-1638 # 80200a58 <etext+0x4c>
    802000c6:	fabff0ef          	jal	ra,80200070 <cprintf>
    802000ca:	00001597          	auipc	a1,0x1
    802000ce:	94258593          	addi	a1,a1,-1726 # 80200a0c <etext>
    802000d2:	00001517          	auipc	a0,0x1
    802000d6:	9a650513          	addi	a0,a0,-1626 # 80200a78 <etext+0x6c>
    802000da:	f97ff0ef          	jal	ra,80200070 <cprintf>
    802000de:	00004597          	auipc	a1,0x4
    802000e2:	f3258593          	addi	a1,a1,-206 # 80204010 <ticks>
    802000e6:	00001517          	auipc	a0,0x1
    802000ea:	9b250513          	addi	a0,a0,-1614 # 80200a98 <etext+0x8c>
    802000ee:	f83ff0ef          	jal	ra,80200070 <cprintf>
    802000f2:	00004597          	auipc	a1,0x4
    802000f6:	f3658593          	addi	a1,a1,-202 # 80204028 <end>
    802000fa:	00001517          	auipc	a0,0x1
    802000fe:	9be50513          	addi	a0,a0,-1602 # 80200ab8 <etext+0xac>
    80200102:	f6fff0ef          	jal	ra,80200070 <cprintf>
    80200106:	00004597          	auipc	a1,0x4
    8020010a:	32158593          	addi	a1,a1,801 # 80204427 <end+0x3ff>
    8020010e:	00000797          	auipc	a5,0x0
    80200112:	efc78793          	addi	a5,a5,-260 # 8020000a <kern_init>
    80200116:	40f587b3          	sub	a5,a1,a5
    8020011a:	43f7d593          	srai	a1,a5,0x3f
    8020011e:	60a2                	ld	ra,8(sp)
    80200120:	3ff5f593          	andi	a1,a1,1023
    80200124:	95be                	add	a1,a1,a5
    80200126:	85a9                	srai	a1,a1,0xa
    80200128:	00001517          	auipc	a0,0x1
    8020012c:	9b050513          	addi	a0,a0,-1616 # 80200ad8 <etext+0xcc>
    80200130:	0141                	addi	sp,sp,16
    80200132:	bf3d                	j	80200070 <cprintf>

0000000080200134 <clock_init>:
    80200134:	1141                	addi	sp,sp,-16
    80200136:	e406                	sd	ra,8(sp)
    80200138:	02000793          	li	a5,32
    8020013c:	1047a7f3          	csrrs	a5,sie,a5
    80200140:	c0102573          	rdtime	a0
    80200144:	67e1                	lui	a5,0x18
    80200146:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020014a:	953e                	add	a0,a0,a5
    8020014c:	05f000ef          	jal	ra,802009aa <sbi_set_timer>
    80200150:	60a2                	ld	ra,8(sp)
    80200152:	00004797          	auipc	a5,0x4
    80200156:	ea07bf23          	sd	zero,-322(a5) # 80204010 <ticks>
    8020015a:	00001517          	auipc	a0,0x1
    8020015e:	9ae50513          	addi	a0,a0,-1618 # 80200b08 <etext+0xfc>
    80200162:	0141                	addi	sp,sp,16
    80200164:	b731                	j	80200070 <cprintf>

0000000080200166 <clock_set_next_event>:
    80200166:	c0102573          	rdtime	a0
    8020016a:	67e1                	lui	a5,0x18
    8020016c:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200170:	953e                	add	a0,a0,a5
    80200172:	0390006f          	j	802009aa <sbi_set_timer>

0000000080200176 <cons_init>:
    80200176:	8082                	ret

0000000080200178 <cons_putc>:
    80200178:	0ff57513          	zext.b	a0,a0
    8020017c:	0150006f          	j	80200990 <sbi_console_putchar>

0000000080200180 <intr_enable>:
    80200180:	100167f3          	csrrsi	a5,sstatus,2
    80200184:	8082                	ret

0000000080200186 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200186:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    8020018a:	00000797          	auipc	a5,0x0
    8020018e:	36278793          	addi	a5,a5,866 # 802004ec <__alltraps>
    80200192:	10579073          	csrw	stvec,a5
}
    80200196:	8082                	ret

0000000080200198 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200198:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    8020019a:	1141                	addi	sp,sp,-16
    8020019c:	e022                	sd	s0,0(sp)
    8020019e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a0:	00001517          	auipc	a0,0x1
    802001a4:	98850513          	addi	a0,a0,-1656 # 80200b28 <etext+0x11c>
void print_regs(struct pushregs *gpr) {
    802001a8:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001aa:	ec7ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001ae:	640c                	ld	a1,8(s0)
    802001b0:	00001517          	auipc	a0,0x1
    802001b4:	99050513          	addi	a0,a0,-1648 # 80200b40 <etext+0x134>
    802001b8:	eb9ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001bc:	680c                	ld	a1,16(s0)
    802001be:	00001517          	auipc	a0,0x1
    802001c2:	99a50513          	addi	a0,a0,-1638 # 80200b58 <etext+0x14c>
    802001c6:	eabff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001ca:	6c0c                	ld	a1,24(s0)
    802001cc:	00001517          	auipc	a0,0x1
    802001d0:	9a450513          	addi	a0,a0,-1628 # 80200b70 <etext+0x164>
    802001d4:	e9dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d8:	700c                	ld	a1,32(s0)
    802001da:	00001517          	auipc	a0,0x1
    802001de:	9ae50513          	addi	a0,a0,-1618 # 80200b88 <etext+0x17c>
    802001e2:	e8fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e6:	740c                	ld	a1,40(s0)
    802001e8:	00001517          	auipc	a0,0x1
    802001ec:	9b850513          	addi	a0,a0,-1608 # 80200ba0 <etext+0x194>
    802001f0:	e81ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001f4:	780c                	ld	a1,48(s0)
    802001f6:	00001517          	auipc	a0,0x1
    802001fa:	9c250513          	addi	a0,a0,-1598 # 80200bb8 <etext+0x1ac>
    802001fe:	e73ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    80200202:	7c0c                	ld	a1,56(s0)
    80200204:	00001517          	auipc	a0,0x1
    80200208:	9cc50513          	addi	a0,a0,-1588 # 80200bd0 <etext+0x1c4>
    8020020c:	e65ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    80200210:	602c                	ld	a1,64(s0)
    80200212:	00001517          	auipc	a0,0x1
    80200216:	9d650513          	addi	a0,a0,-1578 # 80200be8 <etext+0x1dc>
    8020021a:	e57ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    8020021e:	642c                	ld	a1,72(s0)
    80200220:	00001517          	auipc	a0,0x1
    80200224:	9e050513          	addi	a0,a0,-1568 # 80200c00 <etext+0x1f4>
    80200228:	e49ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    8020022c:	682c                	ld	a1,80(s0)
    8020022e:	00001517          	auipc	a0,0x1
    80200232:	9ea50513          	addi	a0,a0,-1558 # 80200c18 <etext+0x20c>
    80200236:	e3bff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    8020023a:	6c2c                	ld	a1,88(s0)
    8020023c:	00001517          	auipc	a0,0x1
    80200240:	9f450513          	addi	a0,a0,-1548 # 80200c30 <etext+0x224>
    80200244:	e2dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200248:	702c                	ld	a1,96(s0)
    8020024a:	00001517          	auipc	a0,0x1
    8020024e:	9fe50513          	addi	a0,a0,-1538 # 80200c48 <etext+0x23c>
    80200252:	e1fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200256:	742c                	ld	a1,104(s0)
    80200258:	00001517          	auipc	a0,0x1
    8020025c:	a0850513          	addi	a0,a0,-1528 # 80200c60 <etext+0x254>
    80200260:	e11ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    80200264:	782c                	ld	a1,112(s0)
    80200266:	00001517          	auipc	a0,0x1
    8020026a:	a1250513          	addi	a0,a0,-1518 # 80200c78 <etext+0x26c>
    8020026e:	e03ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    80200272:	7c2c                	ld	a1,120(s0)
    80200274:	00001517          	auipc	a0,0x1
    80200278:	a1c50513          	addi	a0,a0,-1508 # 80200c90 <etext+0x284>
    8020027c:	df5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    80200280:	604c                	ld	a1,128(s0)
    80200282:	00001517          	auipc	a0,0x1
    80200286:	a2650513          	addi	a0,a0,-1498 # 80200ca8 <etext+0x29c>
    8020028a:	de7ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    8020028e:	644c                	ld	a1,136(s0)
    80200290:	00001517          	auipc	a0,0x1
    80200294:	a3050513          	addi	a0,a0,-1488 # 80200cc0 <etext+0x2b4>
    80200298:	dd9ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    8020029c:	684c                	ld	a1,144(s0)
    8020029e:	00001517          	auipc	a0,0x1
    802002a2:	a3a50513          	addi	a0,a0,-1478 # 80200cd8 <etext+0x2cc>
    802002a6:	dcbff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002aa:	6c4c                	ld	a1,152(s0)
    802002ac:	00001517          	auipc	a0,0x1
    802002b0:	a4450513          	addi	a0,a0,-1468 # 80200cf0 <etext+0x2e4>
    802002b4:	dbdff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b8:	704c                	ld	a1,160(s0)
    802002ba:	00001517          	auipc	a0,0x1
    802002be:	a4e50513          	addi	a0,a0,-1458 # 80200d08 <etext+0x2fc>
    802002c2:	dafff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c6:	744c                	ld	a1,168(s0)
    802002c8:	00001517          	auipc	a0,0x1
    802002cc:	a5850513          	addi	a0,a0,-1448 # 80200d20 <etext+0x314>
    802002d0:	da1ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002d4:	784c                	ld	a1,176(s0)
    802002d6:	00001517          	auipc	a0,0x1
    802002da:	a6250513          	addi	a0,a0,-1438 # 80200d38 <etext+0x32c>
    802002de:	d93ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002e2:	7c4c                	ld	a1,184(s0)
    802002e4:	00001517          	auipc	a0,0x1
    802002e8:	a6c50513          	addi	a0,a0,-1428 # 80200d50 <etext+0x344>
    802002ec:	d85ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002f0:	606c                	ld	a1,192(s0)
    802002f2:	00001517          	auipc	a0,0x1
    802002f6:	a7650513          	addi	a0,a0,-1418 # 80200d68 <etext+0x35c>
    802002fa:	d77ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002fe:	646c                	ld	a1,200(s0)
    80200300:	00001517          	auipc	a0,0x1
    80200304:	a8050513          	addi	a0,a0,-1408 # 80200d80 <etext+0x374>
    80200308:	d69ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    8020030c:	686c                	ld	a1,208(s0)
    8020030e:	00001517          	auipc	a0,0x1
    80200312:	a8a50513          	addi	a0,a0,-1398 # 80200d98 <etext+0x38c>
    80200316:	d5bff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    8020031a:	6c6c                	ld	a1,216(s0)
    8020031c:	00001517          	auipc	a0,0x1
    80200320:	a9450513          	addi	a0,a0,-1388 # 80200db0 <etext+0x3a4>
    80200324:	d4dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200328:	706c                	ld	a1,224(s0)
    8020032a:	00001517          	auipc	a0,0x1
    8020032e:	a9e50513          	addi	a0,a0,-1378 # 80200dc8 <etext+0x3bc>
    80200332:	d3fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200336:	746c                	ld	a1,232(s0)
    80200338:	00001517          	auipc	a0,0x1
    8020033c:	aa850513          	addi	a0,a0,-1368 # 80200de0 <etext+0x3d4>
    80200340:	d31ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    80200344:	786c                	ld	a1,240(s0)
    80200346:	00001517          	auipc	a0,0x1
    8020034a:	ab250513          	addi	a0,a0,-1358 # 80200df8 <etext+0x3ec>
    8020034e:	d23ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	7c6c                	ld	a1,248(s0)
}
    80200354:	6402                	ld	s0,0(sp)
    80200356:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200358:	00001517          	auipc	a0,0x1
    8020035c:	ab850513          	addi	a0,a0,-1352 # 80200e10 <etext+0x404>
}
    80200360:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200362:	b339                	j	80200070 <cprintf>

0000000080200364 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    80200364:	1141                	addi	sp,sp,-16
    80200366:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200368:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    8020036a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    8020036c:	00001517          	auipc	a0,0x1
    80200370:	abc50513          	addi	a0,a0,-1348 # 80200e28 <etext+0x41c>
void print_trapframe(struct trapframe *tf) {
    80200374:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200376:	cfbff0ef          	jal	ra,80200070 <cprintf>
    print_regs(&tf->gpr);
    8020037a:	8522                	mv	a0,s0
    8020037c:	e1dff0ef          	jal	ra,80200198 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    80200380:	10043583          	ld	a1,256(s0)
    80200384:	00001517          	auipc	a0,0x1
    80200388:	abc50513          	addi	a0,a0,-1348 # 80200e40 <etext+0x434>
    8020038c:	ce5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    80200390:	10843583          	ld	a1,264(s0)
    80200394:	00001517          	auipc	a0,0x1
    80200398:	ac450513          	addi	a0,a0,-1340 # 80200e58 <etext+0x44c>
    8020039c:	cd5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    802003a0:	11043583          	ld	a1,272(s0)
    802003a4:	00001517          	auipc	a0,0x1
    802003a8:	acc50513          	addi	a0,a0,-1332 # 80200e70 <etext+0x464>
    802003ac:	cc5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b0:	11843583          	ld	a1,280(s0)
}
    802003b4:	6402                	ld	s0,0(sp)
    802003b6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b8:	00001517          	auipc	a0,0x1
    802003bc:	ad050513          	addi	a0,a0,-1328 # 80200e88 <etext+0x47c>
}
    802003c0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003c2:	b17d                	j	80200070 <cprintf>

00000000802003c4 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    802003c4:	11853783          	ld	a5,280(a0)
    802003c8:	472d                	li	a4,11
    802003ca:	0786                	slli	a5,a5,0x1
    802003cc:	8385                	srli	a5,a5,0x1
    802003ce:	08f76163          	bltu	a4,a5,80200450 <interrupt_handler+0x8c>
    802003d2:	00001717          	auipc	a4,0x1
    802003d6:	b7e70713          	addi	a4,a4,-1154 # 80200f50 <etext+0x544>
    802003da:	078a                	slli	a5,a5,0x2
    802003dc:	97ba                	add	a5,a5,a4
    802003de:	439c                	lw	a5,0(a5)
    802003e0:	97ba                	add	a5,a5,a4
    802003e2:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003e4:	00001517          	auipc	a0,0x1
    802003e8:	b1c50513          	addi	a0,a0,-1252 # 80200f00 <etext+0x4f4>
    802003ec:	b151                	j	80200070 <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003ee:	00001517          	auipc	a0,0x1
    802003f2:	af250513          	addi	a0,a0,-1294 # 80200ee0 <etext+0x4d4>
    802003f6:	b9ad                	j	80200070 <cprintf>
            cprintf("User software interrupt\n");
    802003f8:	00001517          	auipc	a0,0x1
    802003fc:	aa850513          	addi	a0,a0,-1368 # 80200ea0 <etext+0x494>
    80200400:	b985                	j	80200070 <cprintf>
            cprintf("Supervisor software interrupt\n");
    80200402:	00001517          	auipc	a0,0x1
    80200406:	abe50513          	addi	a0,a0,-1346 # 80200ec0 <etext+0x4b4>
    8020040a:	b19d                	j	80200070 <cprintf>
void interrupt_handler(struct trapframe *tf) {
    8020040c:	1141                	addi	sp,sp,-16
    8020040e:	e022                	sd	s0,0(sp)
    80200410:	e406                	sd	ra,8(sp)
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
             /* LAB1 EXERCISE2   2211532 :  */
            //(1)设置下次时钟中断- clock_set_next_event()
            clock_set_next_event();
    80200412:	d55ff0ef          	jal	ra,80200166 <clock_set_next_event>
            //(2)计数器（ticks）加一
            ++ticks;
    80200416:	00004797          	auipc	a5,0x4
    8020041a:	bfa78793          	addi	a5,a5,-1030 # 80204010 <ticks>
    8020041e:	6398                	ld	a4,0(a5)
            //(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            if (ticks == TICK_NUM) {
    80200420:	06400693          	li	a3,100
    80200424:	00004417          	auipc	s0,0x4
    80200428:	bf440413          	addi	s0,s0,-1036 # 80204018 <num>
            ++ticks;
    8020042c:	0705                	addi	a4,a4,1
    8020042e:	e398                	sd	a4,0(a5)
            if (ticks == TICK_NUM) {
    80200430:	639c                	ld	a5,0(a5)
    80200432:	02d78063          	beq	a5,a3,80200452 <interrupt_handler+0x8e>
                print_ticks();
                ticks = 0;
                ++num;
            }
            //(4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            if(num == 10){
    80200436:	6018                	ld	a4,0(s0)
    80200438:	47a9                	li	a5,10
    8020043a:	02f70c63          	beq	a4,a5,80200472 <interrupt_handler+0xae>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    8020043e:	60a2                	ld	ra,8(sp)
    80200440:	6402                	ld	s0,0(sp)
    80200442:	0141                	addi	sp,sp,16
    80200444:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    80200446:	00001517          	auipc	a0,0x1
    8020044a:	aea50513          	addi	a0,a0,-1302 # 80200f30 <etext+0x524>
    8020044e:	b10d                	j	80200070 <cprintf>
            print_trapframe(tf);
    80200450:	bf11                	j	80200364 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
    80200452:	06400593          	li	a1,100
    80200456:	00001517          	auipc	a0,0x1
    8020045a:	aca50513          	addi	a0,a0,-1334 # 80200f20 <etext+0x514>
    8020045e:	c13ff0ef          	jal	ra,80200070 <cprintf>
                ticks = 0;
    80200462:	00004797          	auipc	a5,0x4
    80200466:	ba07b723          	sd	zero,-1106(a5) # 80204010 <ticks>
                ++num;
    8020046a:	601c                	ld	a5,0(s0)
    8020046c:	0785                	addi	a5,a5,1
    8020046e:	e01c                	sd	a5,0(s0)
    80200470:	b7d9                	j	80200436 <interrupt_handler+0x72>
}
    80200472:	6402                	ld	s0,0(sp)
    80200474:	60a2                	ld	ra,8(sp)
    80200476:	0141                	addi	sp,sp,16
                sbi_shutdown();
    80200478:	a3b1                	j	802009c4 <sbi_shutdown>

000000008020047a <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
    8020047a:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
    8020047e:	1141                	addi	sp,sp,-16
    80200480:	e022                	sd	s0,0(sp)
    80200482:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
    80200484:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
    80200486:	842a                	mv	s0,a0
    switch (tf->cause) {
    80200488:	04e78663          	beq	a5,a4,802004d4 <exception_handler+0x5a>
    8020048c:	02f76c63          	bltu	a4,a5,802004c4 <exception_handler+0x4a>
    80200490:	4709                	li	a4,2
             /* LAB1 CHALLENGE3   2211849 :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("exception type:Illegal instruction");
    80200492:	00001517          	auipc	a0,0x1
    80200496:	aee50513          	addi	a0,a0,-1298 # 80200f80 <etext+0x574>
    switch (tf->cause) {
    8020049a:	02e79163          	bne	a5,a4,802004bc <exception_handler+0x42>
            /* LAB1 CHALLLENGE3   2211849 :  */
            /*(1)输出指令异常类型（ breakpoint）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("exception type:breakpoint");
    8020049e:	bd3ff0ef          	jal	ra,80200070 <cprintf>
            cprintf("Illegal instruction address: 0x%016llx\n", tf->epc);
    802004a2:	10843583          	ld	a1,264(s0)
    802004a6:	00001517          	auipc	a0,0x1
    802004aa:	b0250513          	addi	a0,a0,-1278 # 80200fa8 <etext+0x59c>
    802004ae:	bc3ff0ef          	jal	ra,80200070 <cprintf>
            tf->epc += 4;//跳过导致异常的指令
    802004b2:	10843783          	ld	a5,264(s0)
    802004b6:	0791                	addi	a5,a5,4
    802004b8:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    802004bc:	60a2                	ld	ra,8(sp)
    802004be:	6402                	ld	s0,0(sp)
    802004c0:	0141                	addi	sp,sp,16
    802004c2:	8082                	ret
    switch (tf->cause) {
    802004c4:	17f1                	addi	a5,a5,-4
    802004c6:	471d                	li	a4,7
    802004c8:	fef77ae3          	bgeu	a4,a5,802004bc <exception_handler+0x42>
}
    802004cc:	6402                	ld	s0,0(sp)
    802004ce:	60a2                	ld	ra,8(sp)
    802004d0:	0141                	addi	sp,sp,16
            print_trapframe(tf);
    802004d2:	bd49                	j	80200364 <print_trapframe>
            cprintf("exception type:breakpoint");
    802004d4:	00001517          	auipc	a0,0x1
    802004d8:	afc50513          	addi	a0,a0,-1284 # 80200fd0 <etext+0x5c4>
    802004dc:	b7c9                	j	8020049e <exception_handler+0x24>

00000000802004de <trap>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    802004de:	11853783          	ld	a5,280(a0)
    802004e2:	0007c363          	bltz	a5,802004e8 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    802004e6:	bf51                	j	8020047a <exception_handler>
        interrupt_handler(tf);
    802004e8:	bdf1                	j	802003c4 <interrupt_handler>
	...

00000000802004ec <__alltraps>:
    802004ec:	14011073          	csrw	sscratch,sp
    802004f0:	712d                	addi	sp,sp,-288
    802004f2:	e002                	sd	zero,0(sp)
    802004f4:	e406                	sd	ra,8(sp)
    802004f6:	ec0e                	sd	gp,24(sp)
    802004f8:	f012                	sd	tp,32(sp)
    802004fa:	f416                	sd	t0,40(sp)
    802004fc:	f81a                	sd	t1,48(sp)
    802004fe:	fc1e                	sd	t2,56(sp)
    80200500:	e0a2                	sd	s0,64(sp)
    80200502:	e4a6                	sd	s1,72(sp)
    80200504:	e8aa                	sd	a0,80(sp)
    80200506:	ecae                	sd	a1,88(sp)
    80200508:	f0b2                	sd	a2,96(sp)
    8020050a:	f4b6                	sd	a3,104(sp)
    8020050c:	f8ba                	sd	a4,112(sp)
    8020050e:	fcbe                	sd	a5,120(sp)
    80200510:	e142                	sd	a6,128(sp)
    80200512:	e546                	sd	a7,136(sp)
    80200514:	e94a                	sd	s2,144(sp)
    80200516:	ed4e                	sd	s3,152(sp)
    80200518:	f152                	sd	s4,160(sp)
    8020051a:	f556                	sd	s5,168(sp)
    8020051c:	f95a                	sd	s6,176(sp)
    8020051e:	fd5e                	sd	s7,184(sp)
    80200520:	e1e2                	sd	s8,192(sp)
    80200522:	e5e6                	sd	s9,200(sp)
    80200524:	e9ea                	sd	s10,208(sp)
    80200526:	edee                	sd	s11,216(sp)
    80200528:	f1f2                	sd	t3,224(sp)
    8020052a:	f5f6                	sd	t4,232(sp)
    8020052c:	f9fa                	sd	t5,240(sp)
    8020052e:	fdfe                	sd	t6,248(sp)
    80200530:	14001473          	csrrw	s0,sscratch,zero
    80200534:	100024f3          	csrr	s1,sstatus
    80200538:	14102973          	csrr	s2,sepc
    8020053c:	143029f3          	csrr	s3,stval
    80200540:	14202a73          	csrr	s4,scause
    80200544:	e822                	sd	s0,16(sp)
    80200546:	e226                	sd	s1,256(sp)
    80200548:	e64a                	sd	s2,264(sp)
    8020054a:	ea4e                	sd	s3,272(sp)
    8020054c:	ee52                	sd	s4,280(sp)
    8020054e:	850a                	mv	a0,sp
    80200550:	f8fff0ef          	jal	ra,802004de <trap>

0000000080200554 <__trapret>:
    80200554:	6492                	ld	s1,256(sp)
    80200556:	6932                	ld	s2,264(sp)
    80200558:	10049073          	csrw	sstatus,s1
    8020055c:	14191073          	csrw	sepc,s2
    80200560:	60a2                	ld	ra,8(sp)
    80200562:	61e2                	ld	gp,24(sp)
    80200564:	7202                	ld	tp,32(sp)
    80200566:	72a2                	ld	t0,40(sp)
    80200568:	7342                	ld	t1,48(sp)
    8020056a:	73e2                	ld	t2,56(sp)
    8020056c:	6406                	ld	s0,64(sp)
    8020056e:	64a6                	ld	s1,72(sp)
    80200570:	6546                	ld	a0,80(sp)
    80200572:	65e6                	ld	a1,88(sp)
    80200574:	7606                	ld	a2,96(sp)
    80200576:	76a6                	ld	a3,104(sp)
    80200578:	7746                	ld	a4,112(sp)
    8020057a:	77e6                	ld	a5,120(sp)
    8020057c:	680a                	ld	a6,128(sp)
    8020057e:	68aa                	ld	a7,136(sp)
    80200580:	694a                	ld	s2,144(sp)
    80200582:	69ea                	ld	s3,152(sp)
    80200584:	7a0a                	ld	s4,160(sp)
    80200586:	7aaa                	ld	s5,168(sp)
    80200588:	7b4a                	ld	s6,176(sp)
    8020058a:	7bea                	ld	s7,184(sp)
    8020058c:	6c0e                	ld	s8,192(sp)
    8020058e:	6cae                	ld	s9,200(sp)
    80200590:	6d4e                	ld	s10,208(sp)
    80200592:	6dee                	ld	s11,216(sp)
    80200594:	7e0e                	ld	t3,224(sp)
    80200596:	7eae                	ld	t4,232(sp)
    80200598:	7f4e                	ld	t5,240(sp)
    8020059a:	7fee                	ld	t6,248(sp)
    8020059c:	6142                	ld	sp,16(sp)
    8020059e:	10200073          	sret

00000000802005a2 <printnum>:
    802005a2:	02069813          	slli	a6,a3,0x20
    802005a6:	7179                	addi	sp,sp,-48
    802005a8:	02085813          	srli	a6,a6,0x20
    802005ac:	e052                	sd	s4,0(sp)
    802005ae:	03067a33          	remu	s4,a2,a6
    802005b2:	f022                	sd	s0,32(sp)
    802005b4:	ec26                	sd	s1,24(sp)
    802005b6:	e84a                	sd	s2,16(sp)
    802005b8:	f406                	sd	ra,40(sp)
    802005ba:	e44e                	sd	s3,8(sp)
    802005bc:	84aa                	mv	s1,a0
    802005be:	892e                	mv	s2,a1
    802005c0:	fff7041b          	addiw	s0,a4,-1
    802005c4:	2a01                	sext.w	s4,s4
    802005c6:	03067e63          	bgeu	a2,a6,80200602 <printnum+0x60>
    802005ca:	89be                	mv	s3,a5
    802005cc:	00805763          	blez	s0,802005da <printnum+0x38>
    802005d0:	347d                	addiw	s0,s0,-1
    802005d2:	85ca                	mv	a1,s2
    802005d4:	854e                	mv	a0,s3
    802005d6:	9482                	jalr	s1
    802005d8:	fc65                	bnez	s0,802005d0 <printnum+0x2e>
    802005da:	1a02                	slli	s4,s4,0x20
    802005dc:	00001797          	auipc	a5,0x1
    802005e0:	a1478793          	addi	a5,a5,-1516 # 80200ff0 <etext+0x5e4>
    802005e4:	020a5a13          	srli	s4,s4,0x20
    802005e8:	9a3e                	add	s4,s4,a5
    802005ea:	7402                	ld	s0,32(sp)
    802005ec:	000a4503          	lbu	a0,0(s4)
    802005f0:	70a2                	ld	ra,40(sp)
    802005f2:	69a2                	ld	s3,8(sp)
    802005f4:	6a02                	ld	s4,0(sp)
    802005f6:	85ca                	mv	a1,s2
    802005f8:	87a6                	mv	a5,s1
    802005fa:	6942                	ld	s2,16(sp)
    802005fc:	64e2                	ld	s1,24(sp)
    802005fe:	6145                	addi	sp,sp,48
    80200600:	8782                	jr	a5
    80200602:	03065633          	divu	a2,a2,a6
    80200606:	8722                	mv	a4,s0
    80200608:	f9bff0ef          	jal	ra,802005a2 <printnum>
    8020060c:	b7f9                	j	802005da <printnum+0x38>

000000008020060e <vprintfmt>:
    8020060e:	7119                	addi	sp,sp,-128
    80200610:	f4a6                	sd	s1,104(sp)
    80200612:	f0ca                	sd	s2,96(sp)
    80200614:	ecce                	sd	s3,88(sp)
    80200616:	e8d2                	sd	s4,80(sp)
    80200618:	e4d6                	sd	s5,72(sp)
    8020061a:	e0da                	sd	s6,64(sp)
    8020061c:	fc5e                	sd	s7,56(sp)
    8020061e:	f06a                	sd	s10,32(sp)
    80200620:	fc86                	sd	ra,120(sp)
    80200622:	f8a2                	sd	s0,112(sp)
    80200624:	f862                	sd	s8,48(sp)
    80200626:	f466                	sd	s9,40(sp)
    80200628:	ec6e                	sd	s11,24(sp)
    8020062a:	892a                	mv	s2,a0
    8020062c:	84ae                	mv	s1,a1
    8020062e:	8d32                	mv	s10,a2
    80200630:	8a36                	mv	s4,a3
    80200632:	02500993          	li	s3,37
    80200636:	5b7d                	li	s6,-1
    80200638:	00001a97          	auipc	s5,0x1
    8020063c:	9eca8a93          	addi	s5,s5,-1556 # 80201024 <etext+0x618>
    80200640:	00001b97          	auipc	s7,0x1
    80200644:	bc0b8b93          	addi	s7,s7,-1088 # 80201200 <error_string>
    80200648:	000d4503          	lbu	a0,0(s10)
    8020064c:	001d0413          	addi	s0,s10,1
    80200650:	01350a63          	beq	a0,s3,80200664 <vprintfmt+0x56>
    80200654:	c121                	beqz	a0,80200694 <vprintfmt+0x86>
    80200656:	85a6                	mv	a1,s1
    80200658:	0405                	addi	s0,s0,1
    8020065a:	9902                	jalr	s2
    8020065c:	fff44503          	lbu	a0,-1(s0)
    80200660:	ff351ae3          	bne	a0,s3,80200654 <vprintfmt+0x46>
    80200664:	00044603          	lbu	a2,0(s0)
    80200668:	02000793          	li	a5,32
    8020066c:	4c81                	li	s9,0
    8020066e:	4881                	li	a7,0
    80200670:	5c7d                	li	s8,-1
    80200672:	5dfd                	li	s11,-1
    80200674:	05500513          	li	a0,85
    80200678:	4825                	li	a6,9
    8020067a:	fdd6059b          	addiw	a1,a2,-35
    8020067e:	0ff5f593          	zext.b	a1,a1
    80200682:	00140d13          	addi	s10,s0,1
    80200686:	04b56263          	bltu	a0,a1,802006ca <vprintfmt+0xbc>
    8020068a:	058a                	slli	a1,a1,0x2
    8020068c:	95d6                	add	a1,a1,s5
    8020068e:	4194                	lw	a3,0(a1)
    80200690:	96d6                	add	a3,a3,s5
    80200692:	8682                	jr	a3
    80200694:	70e6                	ld	ra,120(sp)
    80200696:	7446                	ld	s0,112(sp)
    80200698:	74a6                	ld	s1,104(sp)
    8020069a:	7906                	ld	s2,96(sp)
    8020069c:	69e6                	ld	s3,88(sp)
    8020069e:	6a46                	ld	s4,80(sp)
    802006a0:	6aa6                	ld	s5,72(sp)
    802006a2:	6b06                	ld	s6,64(sp)
    802006a4:	7be2                	ld	s7,56(sp)
    802006a6:	7c42                	ld	s8,48(sp)
    802006a8:	7ca2                	ld	s9,40(sp)
    802006aa:	7d02                	ld	s10,32(sp)
    802006ac:	6de2                	ld	s11,24(sp)
    802006ae:	6109                	addi	sp,sp,128
    802006b0:	8082                	ret
    802006b2:	87b2                	mv	a5,a2
    802006b4:	00144603          	lbu	a2,1(s0)
    802006b8:	846a                	mv	s0,s10
    802006ba:	00140d13          	addi	s10,s0,1
    802006be:	fdd6059b          	addiw	a1,a2,-35
    802006c2:	0ff5f593          	zext.b	a1,a1
    802006c6:	fcb572e3          	bgeu	a0,a1,8020068a <vprintfmt+0x7c>
    802006ca:	85a6                	mv	a1,s1
    802006cc:	02500513          	li	a0,37
    802006d0:	9902                	jalr	s2
    802006d2:	fff44783          	lbu	a5,-1(s0)
    802006d6:	8d22                	mv	s10,s0
    802006d8:	f73788e3          	beq	a5,s3,80200648 <vprintfmt+0x3a>
    802006dc:	ffed4783          	lbu	a5,-2(s10)
    802006e0:	1d7d                	addi	s10,s10,-1
    802006e2:	ff379de3          	bne	a5,s3,802006dc <vprintfmt+0xce>
    802006e6:	b78d                	j	80200648 <vprintfmt+0x3a>
    802006e8:	fd060c1b          	addiw	s8,a2,-48
    802006ec:	00144603          	lbu	a2,1(s0)
    802006f0:	846a                	mv	s0,s10
    802006f2:	fd06069b          	addiw	a3,a2,-48
    802006f6:	0006059b          	sext.w	a1,a2
    802006fa:	02d86463          	bltu	a6,a3,80200722 <vprintfmt+0x114>
    802006fe:	00144603          	lbu	a2,1(s0)
    80200702:	002c169b          	slliw	a3,s8,0x2
    80200706:	0186873b          	addw	a4,a3,s8
    8020070a:	0017171b          	slliw	a4,a4,0x1
    8020070e:	9f2d                	addw	a4,a4,a1
    80200710:	fd06069b          	addiw	a3,a2,-48
    80200714:	0405                	addi	s0,s0,1
    80200716:	fd070c1b          	addiw	s8,a4,-48
    8020071a:	0006059b          	sext.w	a1,a2
    8020071e:	fed870e3          	bgeu	a6,a3,802006fe <vprintfmt+0xf0>
    80200722:	f40ddce3          	bgez	s11,8020067a <vprintfmt+0x6c>
    80200726:	8de2                	mv	s11,s8
    80200728:	5c7d                	li	s8,-1
    8020072a:	bf81                	j	8020067a <vprintfmt+0x6c>
    8020072c:	fffdc693          	not	a3,s11
    80200730:	96fd                	srai	a3,a3,0x3f
    80200732:	00ddfdb3          	and	s11,s11,a3
    80200736:	00144603          	lbu	a2,1(s0)
    8020073a:	2d81                	sext.w	s11,s11
    8020073c:	846a                	mv	s0,s10
    8020073e:	bf35                	j	8020067a <vprintfmt+0x6c>
    80200740:	000a2c03          	lw	s8,0(s4)
    80200744:	00144603          	lbu	a2,1(s0)
    80200748:	0a21                	addi	s4,s4,8
    8020074a:	846a                	mv	s0,s10
    8020074c:	bfd9                	j	80200722 <vprintfmt+0x114>
    8020074e:	4705                	li	a4,1
    80200750:	008a0593          	addi	a1,s4,8
    80200754:	01174463          	blt	a4,a7,8020075c <vprintfmt+0x14e>
    80200758:	1a088e63          	beqz	a7,80200914 <vprintfmt+0x306>
    8020075c:	000a3603          	ld	a2,0(s4)
    80200760:	46c1                	li	a3,16
    80200762:	8a2e                	mv	s4,a1
    80200764:	2781                	sext.w	a5,a5
    80200766:	876e                	mv	a4,s11
    80200768:	85a6                	mv	a1,s1
    8020076a:	854a                	mv	a0,s2
    8020076c:	e37ff0ef          	jal	ra,802005a2 <printnum>
    80200770:	bde1                	j	80200648 <vprintfmt+0x3a>
    80200772:	000a2503          	lw	a0,0(s4)
    80200776:	85a6                	mv	a1,s1
    80200778:	0a21                	addi	s4,s4,8
    8020077a:	9902                	jalr	s2
    8020077c:	b5f1                	j	80200648 <vprintfmt+0x3a>
    8020077e:	4705                	li	a4,1
    80200780:	008a0593          	addi	a1,s4,8
    80200784:	01174463          	blt	a4,a7,8020078c <vprintfmt+0x17e>
    80200788:	18088163          	beqz	a7,8020090a <vprintfmt+0x2fc>
    8020078c:	000a3603          	ld	a2,0(s4)
    80200790:	46a9                	li	a3,10
    80200792:	8a2e                	mv	s4,a1
    80200794:	bfc1                	j	80200764 <vprintfmt+0x156>
    80200796:	00144603          	lbu	a2,1(s0)
    8020079a:	4c85                	li	s9,1
    8020079c:	846a                	mv	s0,s10
    8020079e:	bdf1                	j	8020067a <vprintfmt+0x6c>
    802007a0:	85a6                	mv	a1,s1
    802007a2:	02500513          	li	a0,37
    802007a6:	9902                	jalr	s2
    802007a8:	b545                	j	80200648 <vprintfmt+0x3a>
    802007aa:	00144603          	lbu	a2,1(s0)
    802007ae:	2885                	addiw	a7,a7,1
    802007b0:	846a                	mv	s0,s10
    802007b2:	b5e1                	j	8020067a <vprintfmt+0x6c>
    802007b4:	4705                	li	a4,1
    802007b6:	008a0593          	addi	a1,s4,8
    802007ba:	01174463          	blt	a4,a7,802007c2 <vprintfmt+0x1b4>
    802007be:	14088163          	beqz	a7,80200900 <vprintfmt+0x2f2>
    802007c2:	000a3603          	ld	a2,0(s4)
    802007c6:	46a1                	li	a3,8
    802007c8:	8a2e                	mv	s4,a1
    802007ca:	bf69                	j	80200764 <vprintfmt+0x156>
    802007cc:	03000513          	li	a0,48
    802007d0:	85a6                	mv	a1,s1
    802007d2:	e03e                	sd	a5,0(sp)
    802007d4:	9902                	jalr	s2
    802007d6:	85a6                	mv	a1,s1
    802007d8:	07800513          	li	a0,120
    802007dc:	9902                	jalr	s2
    802007de:	0a21                	addi	s4,s4,8
    802007e0:	6782                	ld	a5,0(sp)
    802007e2:	46c1                	li	a3,16
    802007e4:	ff8a3603          	ld	a2,-8(s4)
    802007e8:	bfb5                	j	80200764 <vprintfmt+0x156>
    802007ea:	000a3403          	ld	s0,0(s4)
    802007ee:	008a0713          	addi	a4,s4,8
    802007f2:	e03a                	sd	a4,0(sp)
    802007f4:	14040263          	beqz	s0,80200938 <vprintfmt+0x32a>
    802007f8:	0fb05763          	blez	s11,802008e6 <vprintfmt+0x2d8>
    802007fc:	02d00693          	li	a3,45
    80200800:	0cd79163          	bne	a5,a3,802008c2 <vprintfmt+0x2b4>
    80200804:	00044783          	lbu	a5,0(s0)
    80200808:	0007851b          	sext.w	a0,a5
    8020080c:	cf85                	beqz	a5,80200844 <vprintfmt+0x236>
    8020080e:	00140a13          	addi	s4,s0,1
    80200812:	05e00413          	li	s0,94
    80200816:	000c4563          	bltz	s8,80200820 <vprintfmt+0x212>
    8020081a:	3c7d                	addiw	s8,s8,-1
    8020081c:	036c0263          	beq	s8,s6,80200840 <vprintfmt+0x232>
    80200820:	85a6                	mv	a1,s1
    80200822:	0e0c8e63          	beqz	s9,8020091e <vprintfmt+0x310>
    80200826:	3781                	addiw	a5,a5,-32
    80200828:	0ef47b63          	bgeu	s0,a5,8020091e <vprintfmt+0x310>
    8020082c:	03f00513          	li	a0,63
    80200830:	9902                	jalr	s2
    80200832:	000a4783          	lbu	a5,0(s4)
    80200836:	3dfd                	addiw	s11,s11,-1
    80200838:	0a05                	addi	s4,s4,1
    8020083a:	0007851b          	sext.w	a0,a5
    8020083e:	ffe1                	bnez	a5,80200816 <vprintfmt+0x208>
    80200840:	01b05963          	blez	s11,80200852 <vprintfmt+0x244>
    80200844:	3dfd                	addiw	s11,s11,-1
    80200846:	85a6                	mv	a1,s1
    80200848:	02000513          	li	a0,32
    8020084c:	9902                	jalr	s2
    8020084e:	fe0d9be3          	bnez	s11,80200844 <vprintfmt+0x236>
    80200852:	6a02                	ld	s4,0(sp)
    80200854:	bbd5                	j	80200648 <vprintfmt+0x3a>
    80200856:	4705                	li	a4,1
    80200858:	008a0c93          	addi	s9,s4,8
    8020085c:	01174463          	blt	a4,a7,80200864 <vprintfmt+0x256>
    80200860:	08088d63          	beqz	a7,802008fa <vprintfmt+0x2ec>
    80200864:	000a3403          	ld	s0,0(s4)
    80200868:	0a044d63          	bltz	s0,80200922 <vprintfmt+0x314>
    8020086c:	8622                	mv	a2,s0
    8020086e:	8a66                	mv	s4,s9
    80200870:	46a9                	li	a3,10
    80200872:	bdcd                	j	80200764 <vprintfmt+0x156>
    80200874:	000a2783          	lw	a5,0(s4)
    80200878:	4719                	li	a4,6
    8020087a:	0a21                	addi	s4,s4,8
    8020087c:	41f7d69b          	sraiw	a3,a5,0x1f
    80200880:	8fb5                	xor	a5,a5,a3
    80200882:	40d786bb          	subw	a3,a5,a3
    80200886:	02d74163          	blt	a4,a3,802008a8 <vprintfmt+0x29a>
    8020088a:	00369793          	slli	a5,a3,0x3
    8020088e:	97de                	add	a5,a5,s7
    80200890:	639c                	ld	a5,0(a5)
    80200892:	cb99                	beqz	a5,802008a8 <vprintfmt+0x29a>
    80200894:	86be                	mv	a3,a5
    80200896:	00000617          	auipc	a2,0x0
    8020089a:	78a60613          	addi	a2,a2,1930 # 80201020 <etext+0x614>
    8020089e:	85a6                	mv	a1,s1
    802008a0:	854a                	mv	a0,s2
    802008a2:	0ce000ef          	jal	ra,80200970 <printfmt>
    802008a6:	b34d                	j	80200648 <vprintfmt+0x3a>
    802008a8:	00000617          	auipc	a2,0x0
    802008ac:	76860613          	addi	a2,a2,1896 # 80201010 <etext+0x604>
    802008b0:	85a6                	mv	a1,s1
    802008b2:	854a                	mv	a0,s2
    802008b4:	0bc000ef          	jal	ra,80200970 <printfmt>
    802008b8:	bb41                	j	80200648 <vprintfmt+0x3a>
    802008ba:	00000417          	auipc	s0,0x0
    802008be:	74e40413          	addi	s0,s0,1870 # 80201008 <etext+0x5fc>
    802008c2:	85e2                	mv	a1,s8
    802008c4:	8522                	mv	a0,s0
    802008c6:	e43e                	sd	a5,8(sp)
    802008c8:	116000ef          	jal	ra,802009de <strnlen>
    802008cc:	40ad8dbb          	subw	s11,s11,a0
    802008d0:	01b05b63          	blez	s11,802008e6 <vprintfmt+0x2d8>
    802008d4:	67a2                	ld	a5,8(sp)
    802008d6:	00078a1b          	sext.w	s4,a5
    802008da:	3dfd                	addiw	s11,s11,-1
    802008dc:	85a6                	mv	a1,s1
    802008de:	8552                	mv	a0,s4
    802008e0:	9902                	jalr	s2
    802008e2:	fe0d9ce3          	bnez	s11,802008da <vprintfmt+0x2cc>
    802008e6:	00044783          	lbu	a5,0(s0)
    802008ea:	00140a13          	addi	s4,s0,1
    802008ee:	0007851b          	sext.w	a0,a5
    802008f2:	d3a5                	beqz	a5,80200852 <vprintfmt+0x244>
    802008f4:	05e00413          	li	s0,94
    802008f8:	bf39                	j	80200816 <vprintfmt+0x208>
    802008fa:	000a2403          	lw	s0,0(s4)
    802008fe:	b7ad                	j	80200868 <vprintfmt+0x25a>
    80200900:	000a6603          	lwu	a2,0(s4)
    80200904:	46a1                	li	a3,8
    80200906:	8a2e                	mv	s4,a1
    80200908:	bdb1                	j	80200764 <vprintfmt+0x156>
    8020090a:	000a6603          	lwu	a2,0(s4)
    8020090e:	46a9                	li	a3,10
    80200910:	8a2e                	mv	s4,a1
    80200912:	bd89                	j	80200764 <vprintfmt+0x156>
    80200914:	000a6603          	lwu	a2,0(s4)
    80200918:	46c1                	li	a3,16
    8020091a:	8a2e                	mv	s4,a1
    8020091c:	b5a1                	j	80200764 <vprintfmt+0x156>
    8020091e:	9902                	jalr	s2
    80200920:	bf09                	j	80200832 <vprintfmt+0x224>
    80200922:	85a6                	mv	a1,s1
    80200924:	02d00513          	li	a0,45
    80200928:	e03e                	sd	a5,0(sp)
    8020092a:	9902                	jalr	s2
    8020092c:	6782                	ld	a5,0(sp)
    8020092e:	8a66                	mv	s4,s9
    80200930:	40800633          	neg	a2,s0
    80200934:	46a9                	li	a3,10
    80200936:	b53d                	j	80200764 <vprintfmt+0x156>
    80200938:	03b05163          	blez	s11,8020095a <vprintfmt+0x34c>
    8020093c:	02d00693          	li	a3,45
    80200940:	f6d79de3          	bne	a5,a3,802008ba <vprintfmt+0x2ac>
    80200944:	00000417          	auipc	s0,0x0
    80200948:	6c440413          	addi	s0,s0,1732 # 80201008 <etext+0x5fc>
    8020094c:	02800793          	li	a5,40
    80200950:	02800513          	li	a0,40
    80200954:	00140a13          	addi	s4,s0,1
    80200958:	bd6d                	j	80200812 <vprintfmt+0x204>
    8020095a:	00000a17          	auipc	s4,0x0
    8020095e:	6afa0a13          	addi	s4,s4,1711 # 80201009 <etext+0x5fd>
    80200962:	02800513          	li	a0,40
    80200966:	02800793          	li	a5,40
    8020096a:	05e00413          	li	s0,94
    8020096e:	b565                	j	80200816 <vprintfmt+0x208>

0000000080200970 <printfmt>:
    80200970:	715d                	addi	sp,sp,-80
    80200972:	02810313          	addi	t1,sp,40
    80200976:	f436                	sd	a3,40(sp)
    80200978:	869a                	mv	a3,t1
    8020097a:	ec06                	sd	ra,24(sp)
    8020097c:	f83a                	sd	a4,48(sp)
    8020097e:	fc3e                	sd	a5,56(sp)
    80200980:	e0c2                	sd	a6,64(sp)
    80200982:	e4c6                	sd	a7,72(sp)
    80200984:	e41a                	sd	t1,8(sp)
    80200986:	c89ff0ef          	jal	ra,8020060e <vprintfmt>
    8020098a:	60e2                	ld	ra,24(sp)
    8020098c:	6161                	addi	sp,sp,80
    8020098e:	8082                	ret

0000000080200990 <sbi_console_putchar>:
    80200990:	4781                	li	a5,0
    80200992:	00003717          	auipc	a4,0x3
    80200996:	66e73703          	ld	a4,1646(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    8020099a:	88ba                	mv	a7,a4
    8020099c:	852a                	mv	a0,a0
    8020099e:	85be                	mv	a1,a5
    802009a0:	863e                	mv	a2,a5
    802009a2:	00000073          	ecall
    802009a6:	87aa                	mv	a5,a0
    802009a8:	8082                	ret

00000000802009aa <sbi_set_timer>:
    802009aa:	4781                	li	a5,0
    802009ac:	00003717          	auipc	a4,0x3
    802009b0:	67473703          	ld	a4,1652(a4) # 80204020 <SBI_SET_TIMER>
    802009b4:	88ba                	mv	a7,a4
    802009b6:	852a                	mv	a0,a0
    802009b8:	85be                	mv	a1,a5
    802009ba:	863e                	mv	a2,a5
    802009bc:	00000073          	ecall
    802009c0:	87aa                	mv	a5,a0
    802009c2:	8082                	ret

00000000802009c4 <sbi_shutdown>:
    802009c4:	4781                	li	a5,0
    802009c6:	00003717          	auipc	a4,0x3
    802009ca:	64273703          	ld	a4,1602(a4) # 80204008 <SBI_SHUTDOWN>
    802009ce:	88ba                	mv	a7,a4
    802009d0:	853e                	mv	a0,a5
    802009d2:	85be                	mv	a1,a5
    802009d4:	863e                	mv	a2,a5
    802009d6:	00000073          	ecall
    802009da:	87aa                	mv	a5,a0
    802009dc:	8082                	ret

00000000802009de <strnlen>:
    802009de:	4781                	li	a5,0
    802009e0:	e589                	bnez	a1,802009ea <strnlen+0xc>
    802009e2:	a811                	j	802009f6 <strnlen+0x18>
    802009e4:	0785                	addi	a5,a5,1
    802009e6:	00f58863          	beq	a1,a5,802009f6 <strnlen+0x18>
    802009ea:	00f50733          	add	a4,a0,a5
    802009ee:	00074703          	lbu	a4,0(a4)
    802009f2:	fb6d                	bnez	a4,802009e4 <strnlen+0x6>
    802009f4:	85be                	mv	a1,a5
    802009f6:	852e                	mv	a0,a1
    802009f8:	8082                	ret

00000000802009fa <memset>:
    802009fa:	ca01                	beqz	a2,80200a0a <memset+0x10>
    802009fc:	962a                	add	a2,a2,a0
    802009fe:	87aa                	mv	a5,a0
    80200a00:	0785                	addi	a5,a5,1
    80200a02:	feb78fa3          	sb	a1,-1(a5)
    80200a06:	fec79de3          	bne	a5,a2,80200a00 <memset+0x6>
    80200a0a:	8082                	ret
