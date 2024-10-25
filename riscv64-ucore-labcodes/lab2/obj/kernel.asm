
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
ffffffffc020001c:	18029073          	csrw	satp,t0
ffffffffc0200020:	12000073          	sfence.vma
ffffffffc0200024:	c0205137          	lui	sp,0xc0205
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
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
ffffffffc020004a:	1c1010ef          	jal	ra,ffffffffc0201a0a <memset>
    cons_init();  // init the console
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0201a20 <etext+0x4>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>

    print_kerninfo();
ffffffffc020005e:	0e4000ef          	jal	ra,ffffffffc0200142 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	795000ef          	jal	ra,ffffffffc0200ffa <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>

    // check slub pmm
    slub_init();
ffffffffc0200076:	306010ef          	jal	ra,ffffffffc020137c <slub_init>
    slub_check();
ffffffffc020007a:	376010ef          	jal	ra,ffffffffc02013f0 <slub_check>

    /* do nothing */
    while (1)
ffffffffc020007e:	a001                	j	ffffffffc020007e <kern_init+0x4c>

ffffffffc0200080 <cputch>:
ffffffffc0200080:	1141                	addi	sp,sp,-16
ffffffffc0200082:	e022                	sd	s0,0(sp)
ffffffffc0200084:	e406                	sd	ra,8(sp)
ffffffffc0200086:	842e                	mv	s0,a1
ffffffffc0200088:	3cc000ef          	jal	ra,ffffffffc0200454 <cons_putc>
ffffffffc020008c:	401c                	lw	a5,0(s0)
ffffffffc020008e:	60a2                	ld	ra,8(sp)
ffffffffc0200090:	2785                	addiw	a5,a5,1
ffffffffc0200092:	c01c                	sw	a5,0(s0)
ffffffffc0200094:	6402                	ld	s0,0(sp)
ffffffffc0200096:	0141                	addi	sp,sp,16
ffffffffc0200098:	8082                	ret

ffffffffc020009a <vcprintf>:
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	862a                	mv	a2,a0
ffffffffc020009e:	86ae                	mv	a3,a1
ffffffffc02000a0:	00000517          	auipc	a0,0x0
ffffffffc02000a4:	fe050513          	addi	a0,a0,-32 # ffffffffc0200080 <cputch>
ffffffffc02000a8:	006c                	addi	a1,sp,12
ffffffffc02000aa:	ec06                	sd	ra,24(sp)
ffffffffc02000ac:	c602                	sw	zero,12(sp)
ffffffffc02000ae:	46c010ef          	jal	ra,ffffffffc020151a <vprintfmt>
ffffffffc02000b2:	60e2                	ld	ra,24(sp)
ffffffffc02000b4:	4532                	lw	a0,12(sp)
ffffffffc02000b6:	6105                	addi	sp,sp,32
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <cprintf>:
ffffffffc02000ba:	711d                	addi	sp,sp,-96
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
ffffffffc02000c0:	8e2a                	mv	t3,a0
ffffffffc02000c2:	f42e                	sd	a1,40(sp)
ffffffffc02000c4:	f832                	sd	a2,48(sp)
ffffffffc02000c6:	fc36                	sd	a3,56(sp)
ffffffffc02000c8:	00000517          	auipc	a0,0x0
ffffffffc02000cc:	fb850513          	addi	a0,a0,-72 # ffffffffc0200080 <cputch>
ffffffffc02000d0:	004c                	addi	a1,sp,4
ffffffffc02000d2:	869a                	mv	a3,t1
ffffffffc02000d4:	8672                	mv	a2,t3
ffffffffc02000d6:	ec06                	sd	ra,24(sp)
ffffffffc02000d8:	e0ba                	sd	a4,64(sp)
ffffffffc02000da:	e4be                	sd	a5,72(sp)
ffffffffc02000dc:	e8c2                	sd	a6,80(sp)
ffffffffc02000de:	ecc6                	sd	a7,88(sp)
ffffffffc02000e0:	e41a                	sd	t1,8(sp)
ffffffffc02000e2:	c202                	sw	zero,4(sp)
ffffffffc02000e4:	436010ef          	jal	ra,ffffffffc020151a <vprintfmt>
ffffffffc02000e8:	60e2                	ld	ra,24(sp)
ffffffffc02000ea:	4512                	lw	a0,4(sp)
ffffffffc02000ec:	6125                	addi	sp,sp,96
ffffffffc02000ee:	8082                	ret

ffffffffc02000f0 <cputchar>:
ffffffffc02000f0:	a695                	j	ffffffffc0200454 <cons_putc>

ffffffffc02000f2 <cputs>:
ffffffffc02000f2:	1101                	addi	sp,sp,-32
ffffffffc02000f4:	e822                	sd	s0,16(sp)
ffffffffc02000f6:	ec06                	sd	ra,24(sp)
ffffffffc02000f8:	e426                	sd	s1,8(sp)
ffffffffc02000fa:	842a                	mv	s0,a0
ffffffffc02000fc:	00054503          	lbu	a0,0(a0)
ffffffffc0200100:	c51d                	beqz	a0,ffffffffc020012e <cputs+0x3c>
ffffffffc0200102:	0405                	addi	s0,s0,1
ffffffffc0200104:	4485                	li	s1,1
ffffffffc0200106:	9c81                	subw	s1,s1,s0
ffffffffc0200108:	34c000ef          	jal	ra,ffffffffc0200454 <cons_putc>
ffffffffc020010c:	00044503          	lbu	a0,0(s0)
ffffffffc0200110:	008487bb          	addw	a5,s1,s0
ffffffffc0200114:	0405                	addi	s0,s0,1
ffffffffc0200116:	f96d                	bnez	a0,ffffffffc0200108 <cputs+0x16>
ffffffffc0200118:	0017841b          	addiw	s0,a5,1
ffffffffc020011c:	4529                	li	a0,10
ffffffffc020011e:	336000ef          	jal	ra,ffffffffc0200454 <cons_putc>
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	8522                	mv	a0,s0
ffffffffc0200126:	6442                	ld	s0,16(sp)
ffffffffc0200128:	64a2                	ld	s1,8(sp)
ffffffffc020012a:	6105                	addi	sp,sp,32
ffffffffc020012c:	8082                	ret
ffffffffc020012e:	4405                	li	s0,1
ffffffffc0200130:	b7f5                	j	ffffffffc020011c <cputs+0x2a>

ffffffffc0200132 <getchar>:
ffffffffc0200132:	1141                	addi	sp,sp,-16
ffffffffc0200134:	e406                	sd	ra,8(sp)
ffffffffc0200136:	326000ef          	jal	ra,ffffffffc020045c <cons_getc>
ffffffffc020013a:	dd75                	beqz	a0,ffffffffc0200136 <getchar+0x4>
ffffffffc020013c:	60a2                	ld	ra,8(sp)
ffffffffc020013e:	0141                	addi	sp,sp,16
ffffffffc0200140:	8082                	ret

ffffffffc0200142 <print_kerninfo>:
ffffffffc0200142:	1141                	addi	sp,sp,-16
ffffffffc0200144:	00002517          	auipc	a0,0x2
ffffffffc0200148:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0201a40 <etext+0x24>
ffffffffc020014c:	e406                	sd	ra,8(sp)
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200152:	00000597          	auipc	a1,0x0
ffffffffc0200156:	ee058593          	addi	a1,a1,-288 # ffffffffc0200032 <kern_init>
ffffffffc020015a:	00002517          	auipc	a0,0x2
ffffffffc020015e:	90650513          	addi	a0,a0,-1786 # ffffffffc0201a60 <etext+0x44>
ffffffffc0200162:	f59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200166:	00002597          	auipc	a1,0x2
ffffffffc020016a:	8b658593          	addi	a1,a1,-1866 # ffffffffc0201a1c <etext>
ffffffffc020016e:	00002517          	auipc	a0,0x2
ffffffffc0200172:	91250513          	addi	a0,a0,-1774 # ffffffffc0201a80 <etext+0x64>
ffffffffc0200176:	f45ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020017a:	00006597          	auipc	a1,0x6
ffffffffc020017e:	eb658593          	addi	a1,a1,-330 # ffffffffc0206030 <free_area>
ffffffffc0200182:	00002517          	auipc	a0,0x2
ffffffffc0200186:	91e50513          	addi	a0,a0,-1762 # ffffffffc0201aa0 <etext+0x84>
ffffffffc020018a:	f31ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020018e:	00006597          	auipc	a1,0x6
ffffffffc0200192:	32a58593          	addi	a1,a1,810 # ffffffffc02064b8 <end>
ffffffffc0200196:	00002517          	auipc	a0,0x2
ffffffffc020019a:	92a50513          	addi	a0,a0,-1750 # ffffffffc0201ac0 <etext+0xa4>
ffffffffc020019e:	f1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001a2:	00006597          	auipc	a1,0x6
ffffffffc02001a6:	71558593          	addi	a1,a1,1813 # ffffffffc02068b7 <end+0x3ff>
ffffffffc02001aa:	00000797          	auipc	a5,0x0
ffffffffc02001ae:	e8878793          	addi	a5,a5,-376 # ffffffffc0200032 <kern_init>
ffffffffc02001b2:	40f587b3          	sub	a5,a1,a5
ffffffffc02001b6:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02001ba:	60a2                	ld	ra,8(sp)
ffffffffc02001bc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001c0:	95be                	add	a1,a1,a5
ffffffffc02001c2:	85a9                	srai	a1,a1,0xa
ffffffffc02001c4:	00002517          	auipc	a0,0x2
ffffffffc02001c8:	91c50513          	addi	a0,a0,-1764 # ffffffffc0201ae0 <etext+0xc4>
ffffffffc02001cc:	0141                	addi	sp,sp,16
ffffffffc02001ce:	b5f5                	j	ffffffffc02000ba <cprintf>

ffffffffc02001d0 <print_stackframe>:
ffffffffc02001d0:	1141                	addi	sp,sp,-16
ffffffffc02001d2:	00002617          	auipc	a2,0x2
ffffffffc02001d6:	93e60613          	addi	a2,a2,-1730 # ffffffffc0201b10 <etext+0xf4>
ffffffffc02001da:	04e00593          	li	a1,78
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201b28 <etext+0x10c>
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	1cc000ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02001ec <mon_help>:
ffffffffc02001ec:	1141                	addi	sp,sp,-16
ffffffffc02001ee:	00002617          	auipc	a2,0x2
ffffffffc02001f2:	95260613          	addi	a2,a2,-1710 # ffffffffc0201b40 <etext+0x124>
ffffffffc02001f6:	00002597          	auipc	a1,0x2
ffffffffc02001fa:	96a58593          	addi	a1,a1,-1686 # ffffffffc0201b60 <etext+0x144>
ffffffffc02001fe:	00002517          	auipc	a0,0x2
ffffffffc0200202:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201b68 <etext+0x14c>
ffffffffc0200206:	e406                	sd	ra,8(sp)
ffffffffc0200208:	eb3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020020c:	00002617          	auipc	a2,0x2
ffffffffc0200210:	96c60613          	addi	a2,a2,-1684 # ffffffffc0201b78 <etext+0x15c>
ffffffffc0200214:	00002597          	auipc	a1,0x2
ffffffffc0200218:	98c58593          	addi	a1,a1,-1652 # ffffffffc0201ba0 <etext+0x184>
ffffffffc020021c:	00002517          	auipc	a0,0x2
ffffffffc0200220:	94c50513          	addi	a0,a0,-1716 # ffffffffc0201b68 <etext+0x14c>
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00002617          	auipc	a2,0x2
ffffffffc020022c:	98860613          	addi	a2,a2,-1656 # ffffffffc0201bb0 <etext+0x194>
ffffffffc0200230:	00002597          	auipc	a1,0x2
ffffffffc0200234:	9a058593          	addi	a1,a1,-1632 # ffffffffc0201bd0 <etext+0x1b4>
ffffffffc0200238:	00002517          	auipc	a0,0x2
ffffffffc020023c:	93050513          	addi	a0,a0,-1744 # ffffffffc0201b68 <etext+0x14c>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200244:	60a2                	ld	ra,8(sp)
ffffffffc0200246:	4501                	li	a0,0
ffffffffc0200248:	0141                	addi	sp,sp,16
ffffffffc020024a:	8082                	ret

ffffffffc020024c <mon_kerninfo>:
ffffffffc020024c:	1141                	addi	sp,sp,-16
ffffffffc020024e:	e406                	sd	ra,8(sp)
ffffffffc0200250:	ef3ff0ef          	jal	ra,ffffffffc0200142 <print_kerninfo>
ffffffffc0200254:	60a2                	ld	ra,8(sp)
ffffffffc0200256:	4501                	li	a0,0
ffffffffc0200258:	0141                	addi	sp,sp,16
ffffffffc020025a:	8082                	ret

ffffffffc020025c <mon_backtrace>:
ffffffffc020025c:	1141                	addi	sp,sp,-16
ffffffffc020025e:	e406                	sd	ra,8(sp)
ffffffffc0200260:	f71ff0ef          	jal	ra,ffffffffc02001d0 <print_stackframe>
ffffffffc0200264:	60a2                	ld	ra,8(sp)
ffffffffc0200266:	4501                	li	a0,0
ffffffffc0200268:	0141                	addi	sp,sp,16
ffffffffc020026a:	8082                	ret

ffffffffc020026c <kmonitor>:
ffffffffc020026c:	7115                	addi	sp,sp,-224
ffffffffc020026e:	ed5e                	sd	s7,152(sp)
ffffffffc0200270:	8baa                	mv	s7,a0
ffffffffc0200272:	00002517          	auipc	a0,0x2
ffffffffc0200276:	96e50513          	addi	a0,a0,-1682 # ffffffffc0201be0 <etext+0x1c4>
ffffffffc020027a:	ed86                	sd	ra,216(sp)
ffffffffc020027c:	e9a2                	sd	s0,208(sp)
ffffffffc020027e:	e5a6                	sd	s1,200(sp)
ffffffffc0200280:	e1ca                	sd	s2,192(sp)
ffffffffc0200282:	fd4e                	sd	s3,184(sp)
ffffffffc0200284:	f952                	sd	s4,176(sp)
ffffffffc0200286:	f556                	sd	s5,168(sp)
ffffffffc0200288:	f15a                	sd	s6,160(sp)
ffffffffc020028a:	e962                	sd	s8,144(sp)
ffffffffc020028c:	e566                	sd	s9,136(sp)
ffffffffc020028e:	e16a                	sd	s10,128(sp)
ffffffffc0200290:	e2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200294:	00002517          	auipc	a0,0x2
ffffffffc0200298:	97450513          	addi	a0,a0,-1676 # ffffffffc0201c08 <etext+0x1ec>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002a0:	000b8563          	beqz	s7,ffffffffc02002aa <kmonitor+0x3e>
ffffffffc02002a4:	855e                	mv	a0,s7
ffffffffc02002a6:	3a4000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc02002aa:	00002c17          	auipc	s8,0x2
ffffffffc02002ae:	9cec0c13          	addi	s8,s8,-1586 # ffffffffc0201c78 <commands>
ffffffffc02002b2:	00002917          	auipc	s2,0x2
ffffffffc02002b6:	97e90913          	addi	s2,s2,-1666 # ffffffffc0201c30 <etext+0x214>
ffffffffc02002ba:	00002497          	auipc	s1,0x2
ffffffffc02002be:	97e48493          	addi	s1,s1,-1666 # ffffffffc0201c38 <etext+0x21c>
ffffffffc02002c2:	49bd                	li	s3,15
ffffffffc02002c4:	00002b17          	auipc	s6,0x2
ffffffffc02002c8:	97cb0b13          	addi	s6,s6,-1668 # ffffffffc0201c40 <etext+0x224>
ffffffffc02002cc:	00002a17          	auipc	s4,0x2
ffffffffc02002d0:	894a0a13          	addi	s4,s4,-1900 # ffffffffc0201b60 <etext+0x144>
ffffffffc02002d4:	4a8d                	li	s5,3
ffffffffc02002d6:	854a                	mv	a0,s2
ffffffffc02002d8:	5c4010ef          	jal	ra,ffffffffc020189c <readline>
ffffffffc02002dc:	842a                	mv	s0,a0
ffffffffc02002de:	dd65                	beqz	a0,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002e0:	00054583          	lbu	a1,0(a0)
ffffffffc02002e4:	4c81                	li	s9,0
ffffffffc02002e6:	e1bd                	bnez	a1,ffffffffc020034c <kmonitor+0xe0>
ffffffffc02002e8:	fe0c87e3          	beqz	s9,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002ec:	6582                	ld	a1,0(sp)
ffffffffc02002ee:	00002d17          	auipc	s10,0x2
ffffffffc02002f2:	98ad0d13          	addi	s10,s10,-1654 # ffffffffc0201c78 <commands>
ffffffffc02002f6:	8552                	mv	a0,s4
ffffffffc02002f8:	4401                	li	s0,0
ffffffffc02002fa:	0d61                	addi	s10,s10,24
ffffffffc02002fc:	6da010ef          	jal	ra,ffffffffc02019d6 <strcmp>
ffffffffc0200300:	c919                	beqz	a0,ffffffffc0200316 <kmonitor+0xaa>
ffffffffc0200302:	2405                	addiw	s0,s0,1
ffffffffc0200304:	0b540063          	beq	s0,s5,ffffffffc02003a4 <kmonitor+0x138>
ffffffffc0200308:	000d3503          	ld	a0,0(s10)
ffffffffc020030c:	6582                	ld	a1,0(sp)
ffffffffc020030e:	0d61                	addi	s10,s10,24
ffffffffc0200310:	6c6010ef          	jal	ra,ffffffffc02019d6 <strcmp>
ffffffffc0200314:	f57d                	bnez	a0,ffffffffc0200302 <kmonitor+0x96>
ffffffffc0200316:	00141793          	slli	a5,s0,0x1
ffffffffc020031a:	97a2                	add	a5,a5,s0
ffffffffc020031c:	078e                	slli	a5,a5,0x3
ffffffffc020031e:	97e2                	add	a5,a5,s8
ffffffffc0200320:	6b9c                	ld	a5,16(a5)
ffffffffc0200322:	865e                	mv	a2,s7
ffffffffc0200324:	002c                	addi	a1,sp,8
ffffffffc0200326:	fffc851b          	addiw	a0,s9,-1
ffffffffc020032a:	9782                	jalr	a5
ffffffffc020032c:	fa0555e3          	bgez	a0,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc0200330:	60ee                	ld	ra,216(sp)
ffffffffc0200332:	644e                	ld	s0,208(sp)
ffffffffc0200334:	64ae                	ld	s1,200(sp)
ffffffffc0200336:	690e                	ld	s2,192(sp)
ffffffffc0200338:	79ea                	ld	s3,184(sp)
ffffffffc020033a:	7a4a                	ld	s4,176(sp)
ffffffffc020033c:	7aaa                	ld	s5,168(sp)
ffffffffc020033e:	7b0a                	ld	s6,160(sp)
ffffffffc0200340:	6bea                	ld	s7,152(sp)
ffffffffc0200342:	6c4a                	ld	s8,144(sp)
ffffffffc0200344:	6caa                	ld	s9,136(sp)
ffffffffc0200346:	6d0a                	ld	s10,128(sp)
ffffffffc0200348:	612d                	addi	sp,sp,224
ffffffffc020034a:	8082                	ret
ffffffffc020034c:	8526                	mv	a0,s1
ffffffffc020034e:	6a6010ef          	jal	ra,ffffffffc02019f4 <strchr>
ffffffffc0200352:	c901                	beqz	a0,ffffffffc0200362 <kmonitor+0xf6>
ffffffffc0200354:	00144583          	lbu	a1,1(s0)
ffffffffc0200358:	00040023          	sb	zero,0(s0)
ffffffffc020035c:	0405                	addi	s0,s0,1
ffffffffc020035e:	d5c9                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc0200360:	b7f5                	j	ffffffffc020034c <kmonitor+0xe0>
ffffffffc0200362:	00044783          	lbu	a5,0(s0)
ffffffffc0200366:	d3c9                	beqz	a5,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc0200368:	033c8963          	beq	s9,s3,ffffffffc020039a <kmonitor+0x12e>
ffffffffc020036c:	003c9793          	slli	a5,s9,0x3
ffffffffc0200370:	0118                	addi	a4,sp,128
ffffffffc0200372:	97ba                	add	a5,a5,a4
ffffffffc0200374:	f887b023          	sd	s0,-128(a5)
ffffffffc0200378:	00044583          	lbu	a1,0(s0)
ffffffffc020037c:	2c85                	addiw	s9,s9,1
ffffffffc020037e:	e591                	bnez	a1,ffffffffc020038a <kmonitor+0x11e>
ffffffffc0200380:	b7b5                	j	ffffffffc02002ec <kmonitor+0x80>
ffffffffc0200382:	00144583          	lbu	a1,1(s0)
ffffffffc0200386:	0405                	addi	s0,s0,1
ffffffffc0200388:	d1a5                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc020038a:	8526                	mv	a0,s1
ffffffffc020038c:	668010ef          	jal	ra,ffffffffc02019f4 <strchr>
ffffffffc0200390:	d96d                	beqz	a0,ffffffffc0200382 <kmonitor+0x116>
ffffffffc0200392:	00044583          	lbu	a1,0(s0)
ffffffffc0200396:	d9a9                	beqz	a1,ffffffffc02002e8 <kmonitor+0x7c>
ffffffffc0200398:	bf55                	j	ffffffffc020034c <kmonitor+0xe0>
ffffffffc020039a:	45c1                	li	a1,16
ffffffffc020039c:	855a                	mv	a0,s6
ffffffffc020039e:	d1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003a2:	b7e9                	j	ffffffffc020036c <kmonitor+0x100>
ffffffffc02003a4:	6582                	ld	a1,0(sp)
ffffffffc02003a6:	00002517          	auipc	a0,0x2
ffffffffc02003aa:	8ba50513          	addi	a0,a0,-1862 # ffffffffc0201c60 <etext+0x244>
ffffffffc02003ae:	d0dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003b2:	b715                	j	ffffffffc02002d6 <kmonitor+0x6a>

ffffffffc02003b4 <__panic>:
ffffffffc02003b4:	00006317          	auipc	t1,0x6
ffffffffc02003b8:	09430313          	addi	t1,t1,148 # ffffffffc0206448 <is_panic>
ffffffffc02003bc:	00032e03          	lw	t3,0(t1)
ffffffffc02003c0:	715d                	addi	sp,sp,-80
ffffffffc02003c2:	ec06                	sd	ra,24(sp)
ffffffffc02003c4:	e822                	sd	s0,16(sp)
ffffffffc02003c6:	f436                	sd	a3,40(sp)
ffffffffc02003c8:	f83a                	sd	a4,48(sp)
ffffffffc02003ca:	fc3e                	sd	a5,56(sp)
ffffffffc02003cc:	e0c2                	sd	a6,64(sp)
ffffffffc02003ce:	e4c6                	sd	a7,72(sp)
ffffffffc02003d0:	020e1a63          	bnez	t3,ffffffffc0200404 <__panic+0x50>
ffffffffc02003d4:	4785                	li	a5,1
ffffffffc02003d6:	00f32023          	sw	a5,0(t1)
ffffffffc02003da:	8432                	mv	s0,a2
ffffffffc02003dc:	103c                	addi	a5,sp,40
ffffffffc02003de:	862e                	mv	a2,a1
ffffffffc02003e0:	85aa                	mv	a1,a0
ffffffffc02003e2:	00002517          	auipc	a0,0x2
ffffffffc02003e6:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201cc0 <commands+0x48>
ffffffffc02003ea:	e43e                	sd	a5,8(sp)
ffffffffc02003ec:	ccfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003f0:	65a2                	ld	a1,8(sp)
ffffffffc02003f2:	8522                	mv	a0,s0
ffffffffc02003f4:	ca7ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
ffffffffc02003f8:	00002517          	auipc	a0,0x2
ffffffffc02003fc:	1b850513          	addi	a0,a0,440 # ffffffffc02025b0 <buddy_pmm_manager+0x248>
ffffffffc0200400:	cbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200404:	062000ef          	jal	ra,ffffffffc0200466 <intr_disable>
ffffffffc0200408:	4501                	li	a0,0
ffffffffc020040a:	e63ff0ef          	jal	ra,ffffffffc020026c <kmonitor>
ffffffffc020040e:	bfed                	j	ffffffffc0200408 <__panic+0x54>

ffffffffc0200410 <clock_init>:
ffffffffc0200410:	1141                	addi	sp,sp,-16
ffffffffc0200412:	e406                	sd	ra,8(sp)
ffffffffc0200414:	02000793          	li	a5,32
ffffffffc0200418:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020041c:	c0102573          	rdtime	a0
ffffffffc0200420:	67e1                	lui	a5,0x18
ffffffffc0200422:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200426:	953e                	add	a0,a0,a5
ffffffffc0200428:	542010ef          	jal	ra,ffffffffc020196a <sbi_set_timer>
ffffffffc020042c:	60a2                	ld	ra,8(sp)
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	0207b123          	sd	zero,34(a5) # ffffffffc0206450 <ticks>
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0201ce0 <commands+0x68>
ffffffffc020043e:	0141                	addi	sp,sp,16
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
ffffffffc0200442:	c0102573          	rdtime	a0
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	51c0106f          	j	ffffffffc020196a <sbi_set_timer>

ffffffffc0200452 <cons_init>:
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:
ffffffffc0200454:	0ff57513          	andi	a0,a0,255
ffffffffc0200458:	4f80106f          	j	ffffffffc0201950 <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
ffffffffc020045c:	5280106f          	j	ffffffffc0201984 <sbi_console_getchar>

ffffffffc0200460 <intr_enable>:
ffffffffc0200460:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200464:	8082                	ret

ffffffffc0200466 <intr_disable>:
ffffffffc0200466:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020046a:	8082                	ret

ffffffffc020046c <idt_init>:
ffffffffc020046c:	14005073          	csrwi	sscratch,0
ffffffffc0200470:	00000797          	auipc	a5,0x0
ffffffffc0200474:	39078793          	addi	a5,a5,912 # ffffffffc0200800 <__alltraps>
ffffffffc0200478:	10579073          	csrw	stvec,a5
ffffffffc020047c:	8082                	ret

ffffffffc020047e <print_regs>:
ffffffffc020047e:	610c                	ld	a1,0(a0)
ffffffffc0200480:	1141                	addi	sp,sp,-16
ffffffffc0200482:	e022                	sd	s0,0(sp)
ffffffffc0200484:	842a                	mv	s0,a0
ffffffffc0200486:	00002517          	auipc	a0,0x2
ffffffffc020048a:	87a50513          	addi	a0,a0,-1926 # ffffffffc0201d00 <commands+0x88>
ffffffffc020048e:	e406                	sd	ra,8(sp)
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00002517          	auipc	a0,0x2
ffffffffc020049a:	88250513          	addi	a0,a0,-1918 # ffffffffc0201d18 <commands+0xa0>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	88c50513          	addi	a0,a0,-1908 # ffffffffc0201d30 <commands+0xb8>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	89650513          	addi	a0,a0,-1898 # ffffffffc0201d48 <commands+0xd0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	8a050513          	addi	a0,a0,-1888 # ffffffffc0201d60 <commands+0xe8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00002517          	auipc	a0,0x2
ffffffffc02004d2:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0201d78 <commands+0x100>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00002517          	auipc	a0,0x2
ffffffffc02004e0:	8b450513          	addi	a0,a0,-1868 # ffffffffc0201d90 <commands+0x118>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00002517          	auipc	a0,0x2
ffffffffc02004ee:	8be50513          	addi	a0,a0,-1858 # ffffffffc0201da8 <commands+0x130>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00002517          	auipc	a0,0x2
ffffffffc02004fc:	8c850513          	addi	a0,a0,-1848 # ffffffffc0201dc0 <commands+0x148>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00002517          	auipc	a0,0x2
ffffffffc020050a:	8d250513          	addi	a0,a0,-1838 # ffffffffc0201dd8 <commands+0x160>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00002517          	auipc	a0,0x2
ffffffffc0200518:	8dc50513          	addi	a0,a0,-1828 # ffffffffc0201df0 <commands+0x178>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00002517          	auipc	a0,0x2
ffffffffc0200526:	8e650513          	addi	a0,a0,-1818 # ffffffffc0201e08 <commands+0x190>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00002517          	auipc	a0,0x2
ffffffffc0200534:	8f050513          	addi	a0,a0,-1808 # ffffffffc0201e20 <commands+0x1a8>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00002517          	auipc	a0,0x2
ffffffffc0200542:	8fa50513          	addi	a0,a0,-1798 # ffffffffc0201e38 <commands+0x1c0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00002517          	auipc	a0,0x2
ffffffffc0200550:	90450513          	addi	a0,a0,-1788 # ffffffffc0201e50 <commands+0x1d8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00002517          	auipc	a0,0x2
ffffffffc020055e:	90e50513          	addi	a0,a0,-1778 # ffffffffc0201e68 <commands+0x1f0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00002517          	auipc	a0,0x2
ffffffffc020056c:	91850513          	addi	a0,a0,-1768 # ffffffffc0201e80 <commands+0x208>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	92250513          	addi	a0,a0,-1758 # ffffffffc0201e98 <commands+0x220>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	92c50513          	addi	a0,a0,-1748 # ffffffffc0201eb0 <commands+0x238>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00002517          	auipc	a0,0x2
ffffffffc0200596:	93650513          	addi	a0,a0,-1738 # ffffffffc0201ec8 <commands+0x250>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00002517          	auipc	a0,0x2
ffffffffc02005a4:	94050513          	addi	a0,a0,-1728 # ffffffffc0201ee0 <commands+0x268>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00002517          	auipc	a0,0x2
ffffffffc02005b2:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201ef8 <commands+0x280>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00002517          	auipc	a0,0x2
ffffffffc02005c0:	95450513          	addi	a0,a0,-1708 # ffffffffc0201f10 <commands+0x298>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00002517          	auipc	a0,0x2
ffffffffc02005ce:	95e50513          	addi	a0,a0,-1698 # ffffffffc0201f28 <commands+0x2b0>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00002517          	auipc	a0,0x2
ffffffffc02005dc:	96850513          	addi	a0,a0,-1688 # ffffffffc0201f40 <commands+0x2c8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	97250513          	addi	a0,a0,-1678 # ffffffffc0201f58 <commands+0x2e0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00002517          	auipc	a0,0x2
ffffffffc02005f8:	97c50513          	addi	a0,a0,-1668 # ffffffffc0201f70 <commands+0x2f8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00002517          	auipc	a0,0x2
ffffffffc0200606:	98650513          	addi	a0,a0,-1658 # ffffffffc0201f88 <commands+0x310>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	99050513          	addi	a0,a0,-1648 # ffffffffc0201fa0 <commands+0x328>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	99a50513          	addi	a0,a0,-1638 # ffffffffc0201fb8 <commands+0x340>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00002517          	auipc	a0,0x2
ffffffffc0200630:	9a450513          	addi	a0,a0,-1628 # ffffffffc0201fd0 <commands+0x358>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201fe8 <commands+0x370>
ffffffffc0200646:	0141                	addi	sp,sp,16
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
ffffffffc020064e:	85aa                	mv	a1,a0
ffffffffc0200650:	842a                	mv	s0,a0
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0202000 <commands+0x388>
ffffffffc020065a:	e406                	sd	ra,8(sp)
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00002517          	auipc	a0,0x2
ffffffffc020066e:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0202018 <commands+0x3a0>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	9b650513          	addi	a0,a0,-1610 # ffffffffc0202030 <commands+0x3b8>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00002517          	auipc	a0,0x2
ffffffffc020068e:	9be50513          	addi	a0,a0,-1602 # ffffffffc0202048 <commands+0x3d0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200696:	11843583          	ld	a1,280(s0)
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
ffffffffc020069e:	00002517          	auipc	a0,0x2
ffffffffc02006a2:	9c250513          	addi	a0,a0,-1598 # ffffffffc0202060 <commands+0x3e8>
ffffffffc02006a6:	0141                	addi	sp,sp,16
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	08f76663          	bltu	a4,a5,ffffffffc0200740 <interrupt_handler+0x96>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	a8870713          	addi	a4,a4,-1400 # ffffffffc0202140 <commands+0x4c8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	a0e50513          	addi	a0,a0,-1522 # ffffffffc02020d8 <commands+0x460>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	9e450513          	addi	a0,a0,-1564 # ffffffffc02020b8 <commands+0x440>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
ffffffffc02006de:	00002517          	auipc	a0,0x2
ffffffffc02006e2:	99a50513          	addi	a0,a0,-1638 # ffffffffc0202078 <commands+0x400>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
ffffffffc02006e8:	00002517          	auipc	a0,0x2
ffffffffc02006ec:	a1050513          	addi	a0,a0,-1520 # ffffffffc02020f8 <commands+0x480>
ffffffffc02006f0:	b2e9                	j	ffffffffc02000ba <cprintf>
ffffffffc02006f2:	1141                	addi	sp,sp,-16
ffffffffc02006f4:	e022                	sd	s0,0(sp)
ffffffffc02006f6:	e406                	sd	ra,8(sp)
ffffffffc02006f8:	d4bff0ef          	jal	ra,ffffffffc0200442 <clock_set_next_event>
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
ffffffffc020071c:	6018                	ld	a4,0(s0)
ffffffffc020071e:	47a9                	li	a5,10
ffffffffc0200720:	04f70163          	beq	a4,a5,ffffffffc0200762 <interrupt_handler+0xb8>
ffffffffc0200724:	60a2                	ld	ra,8(sp)
ffffffffc0200726:	6402                	ld	s0,0(sp)
ffffffffc0200728:	0141                	addi	sp,sp,16
ffffffffc020072a:	8082                	ret
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	9f450513          	addi	a0,a0,-1548 # ffffffffc0202120 <commands+0x4a8>
ffffffffc0200734:	b259                	j	ffffffffc02000ba <cprintf>
ffffffffc0200736:	00002517          	auipc	a0,0x2
ffffffffc020073a:	96250513          	addi	a0,a0,-1694 # ffffffffc0202098 <commands+0x420>
ffffffffc020073e:	bab5                	j	ffffffffc02000ba <cprintf>
ffffffffc0200740:	b729                	j	ffffffffc020064a <print_trapframe>
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0202110 <commands+0x498>
ffffffffc020074e:	96dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200752:	00006797          	auipc	a5,0x6
ffffffffc0200756:	ce07bf23          	sd	zero,-770(a5) # ffffffffc0206450 <ticks>
ffffffffc020075a:	601c                	ld	a5,0(s0)
ffffffffc020075c:	0785                	addi	a5,a5,1
ffffffffc020075e:	e01c                	sd	a5,0(s0)
ffffffffc0200760:	bf75                	j	ffffffffc020071c <interrupt_handler+0x72>
ffffffffc0200762:	6402                	ld	s0,0(sp)
ffffffffc0200764:	60a2                	ld	ra,8(sp)
ffffffffc0200766:	0141                	addi	sp,sp,16
ffffffffc0200768:	2380106f          	j	ffffffffc02019a0 <sbi_shutdown>

ffffffffc020076c <exception_handler>:
ffffffffc020076c:	11853783          	ld	a5,280(a0)
ffffffffc0200770:	1141                	addi	sp,sp,-16
ffffffffc0200772:	e022                	sd	s0,0(sp)
ffffffffc0200774:	e406                	sd	ra,8(sp)
ffffffffc0200776:	470d                	li	a4,3
ffffffffc0200778:	842a                	mv	s0,a0
ffffffffc020077a:	04e78663          	beq	a5,a4,ffffffffc02007c6 <exception_handler+0x5a>
ffffffffc020077e:	02f76c63          	bltu	a4,a5,ffffffffc02007b6 <exception_handler+0x4a>
ffffffffc0200782:	4709                	li	a4,2
ffffffffc0200784:	02e79563          	bne	a5,a4,ffffffffc02007ae <exception_handler+0x42>
ffffffffc0200788:	00002517          	auipc	a0,0x2
ffffffffc020078c:	9e850513          	addi	a0,a0,-1560 # ffffffffc0202170 <commands+0x4f8>
ffffffffc0200790:	92bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200794:	10843583          	ld	a1,264(s0)
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	a0050513          	addi	a0,a0,-1536 # ffffffffc0202198 <commands+0x520>
ffffffffc02007a0:	91bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007a4:	10843783          	ld	a5,264(s0)
ffffffffc02007a8:	0791                	addi	a5,a5,4
ffffffffc02007aa:	10f43423          	sd	a5,264(s0)
ffffffffc02007ae:	60a2                	ld	ra,8(sp)
ffffffffc02007b0:	6402                	ld	s0,0(sp)
ffffffffc02007b2:	0141                	addi	sp,sp,16
ffffffffc02007b4:	8082                	ret
ffffffffc02007b6:	17f1                	addi	a5,a5,-4
ffffffffc02007b8:	471d                	li	a4,7
ffffffffc02007ba:	fef77ae3          	bgeu	a4,a5,ffffffffc02007ae <exception_handler+0x42>
ffffffffc02007be:	6402                	ld	s0,0(sp)
ffffffffc02007c0:	60a2                	ld	ra,8(sp)
ffffffffc02007c2:	0141                	addi	sp,sp,16
ffffffffc02007c4:	b559                	j	ffffffffc020064a <print_trapframe>
ffffffffc02007c6:	00002517          	auipc	a0,0x2
ffffffffc02007ca:	9fa50513          	addi	a0,a0,-1542 # ffffffffc02021c0 <commands+0x548>
ffffffffc02007ce:	8edff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007d2:	10843583          	ld	a1,264(s0)
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	9c250513          	addi	a0,a0,-1598 # ffffffffc0202198 <commands+0x520>
ffffffffc02007de:	8ddff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007e2:	10843783          	ld	a5,264(s0)
ffffffffc02007e6:	60a2                	ld	ra,8(sp)
ffffffffc02007e8:	0789                	addi	a5,a5,2
ffffffffc02007ea:	10f43423          	sd	a5,264(s0)
ffffffffc02007ee:	6402                	ld	s0,0(sp)
ffffffffc02007f0:	0141                	addi	sp,sp,16
ffffffffc02007f2:	8082                	ret

ffffffffc02007f4 <trap>:
ffffffffc02007f4:	11853783          	ld	a5,280(a0)
ffffffffc02007f8:	0007c363          	bltz	a5,ffffffffc02007fe <trap+0xa>
ffffffffc02007fc:	bf85                	j	ffffffffc020076c <exception_handler>
ffffffffc02007fe:	b575                	j	ffffffffc02006aa <interrupt_handler>

ffffffffc0200800 <__alltraps>:
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
ffffffffc0200862:	850a                	mv	a0,sp
ffffffffc0200864:	f91ff0ef          	jal	ra,ffffffffc02007f4 <trap>

ffffffffc0200868 <__trapret>:
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
ffffffffc02008b2:	10200073          	sret

ffffffffc02008b6 <buddy_init>:
ffffffffc02008b6:	00005797          	auipc	a5,0x5
ffffffffc02008ba:	77a78793          	addi	a5,a5,1914 # ffffffffc0206030 <free_area>
ffffffffc02008be:	e79c                	sd	a5,8(a5)
ffffffffc02008c0:	e39c                	sd	a5,0(a5)
ffffffffc02008c2:	0007a823          	sw	zero,16(a5)
ffffffffc02008c6:	8082                	ret

ffffffffc02008c8 <buddy_nr_free_pages>:
ffffffffc02008c8:	00005517          	auipc	a0,0x5
ffffffffc02008cc:	77856503          	lwu	a0,1912(a0) # ffffffffc0206040 <free_area+0x10>
ffffffffc02008d0:	8082                	ret

ffffffffc02008d2 <buddy_free_pages>:
ffffffffc02008d2:	1141                	addi	sp,sp,-16
ffffffffc02008d4:	e406                	sd	ra,8(sp)
ffffffffc02008d6:	16058863          	beqz	a1,ffffffffc0200a46 <buddy_free_pages+0x174>
ffffffffc02008da:	0005879b          	sext.w	a5,a1
ffffffffc02008de:	4705                	li	a4,1
ffffffffc02008e0:	d21587d3          	fcvt.d.wu	fa5,a1
ffffffffc02008e4:	12f77d63          	bgeu	a4,a5,ffffffffc0200a1e <buddy_free_pages+0x14c>
ffffffffc02008e8:	4781                	li	a5,0
ffffffffc02008ea:	00002717          	auipc	a4,0x2
ffffffffc02008ee:	f4673687          	fld	fa3,-186(a4) # ffffffffc0202830 <error_string+0x38>
ffffffffc02008f2:	00002717          	auipc	a4,0x2
ffffffffc02008f6:	f4673707          	fld	fa4,-186(a4) # ffffffffc0202838 <error_string+0x40>
ffffffffc02008fa:	12d7f7d3          	fmul.d	fa5,fa5,fa3
ffffffffc02008fe:	2785                	addiw	a5,a5,1
ffffffffc0200900:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200904:	fb7d                	bnez	a4,ffffffffc02008fa <buddy_free_pages+0x28>
ffffffffc0200906:	4705                	li	a4,1
ffffffffc0200908:	00f717bb          	sllw	a5,a4,a5
ffffffffc020090c:	02079713          	slli	a4,a5,0x20
ffffffffc0200910:	9301                	srli	a4,a4,0x20
ffffffffc0200912:	00271693          	slli	a3,a4,0x2
ffffffffc0200916:	96ba                	add	a3,a3,a4
ffffffffc0200918:	068e                	slli	a3,a3,0x3
ffffffffc020091a:	96aa                	add	a3,a3,a0
ffffffffc020091c:	0007861b          	sext.w	a2,a5
ffffffffc0200920:	00d50f63          	beq	a0,a3,ffffffffc020093e <buddy_free_pages+0x6c>
ffffffffc0200924:	87aa                	mv	a5,a0
ffffffffc0200926:	6798                	ld	a4,8(a5)
ffffffffc0200928:	8b05                	andi	a4,a4,1
ffffffffc020092a:	ef75                	bnez	a4,ffffffffc0200a26 <buddy_free_pages+0x154>
ffffffffc020092c:	6798                	ld	a4,8(a5)
ffffffffc020092e:	8b09                	andi	a4,a4,2
ffffffffc0200930:	eb7d                	bnez	a4,ffffffffc0200a26 <buddy_free_pages+0x154>
ffffffffc0200932:	0007a023          	sw	zero,0(a5)
ffffffffc0200936:	02878793          	addi	a5,a5,40
ffffffffc020093a:	fed796e3          	bne	a5,a3,ffffffffc0200926 <buddy_free_pages+0x54>
ffffffffc020093e:	00006797          	auipc	a5,0x6
ffffffffc0200942:	b227b783          	ld	a5,-1246(a5) # ffffffffc0206460 <base0>
ffffffffc0200946:	8d1d                	sub	a0,a0,a5
ffffffffc0200948:	40355793          	srai	a5,a0,0x3
ffffffffc020094c:	00002717          	auipc	a4,0x2
ffffffffc0200950:	ef473703          	ld	a4,-268(a4) # ffffffffc0202840 <error_string+0x48>
ffffffffc0200954:	02e78733          	mul	a4,a5,a4
ffffffffc0200958:	00005517          	auipc	a0,0x5
ffffffffc020095c:	6d850513          	addi	a0,a0,1752 # ffffffffc0206030 <free_area>
ffffffffc0200960:	00006817          	auipc	a6,0x6
ffffffffc0200964:	b1082803          	lw	a6,-1264(a6) # ffffffffc0206470 <length>
ffffffffc0200968:	4914                	lw	a3,16(a0)
ffffffffc020096a:	01f8579b          	srliw	a5,a6,0x1f
ffffffffc020096e:	010787bb          	addw	a5,a5,a6
ffffffffc0200972:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200976:	9e35                	addw	a2,a2,a3
ffffffffc0200978:	37fd                	addiw	a5,a5,-1
ffffffffc020097a:	c910                	sw	a2,16(a0)
ffffffffc020097c:	9fb9                	addw	a5,a5,a4
ffffffffc020097e:	4705                	li	a4,1
ffffffffc0200980:	02071693          	slli	a3,a4,0x20
ffffffffc0200984:	9281                	srli	a3,a3,0x20
ffffffffc0200986:	02b6f363          	bgeu	a3,a1,ffffffffc02009ac <buddy_free_pages+0xda>
ffffffffc020098a:	0017f693          	andi	a3,a5,1
ffffffffc020098e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200992:	ea81                	bnez	a3,ffffffffc02009a2 <buddy_free_pages+0xd0>
ffffffffc0200994:	37f9                	addiw	a5,a5,-2
ffffffffc0200996:	0017d79b          	srliw	a5,a5,0x1
ffffffffc020099a:	f3fd                	bnez	a5,ffffffffc0200980 <buddy_free_pages+0xae>
ffffffffc020099c:	60a2                	ld	ra,8(sp)
ffffffffc020099e:	0141                	addi	sp,sp,16
ffffffffc02009a0:	8082                	ret
ffffffffc02009a2:	37fd                	addiw	a5,a5,-1
ffffffffc02009a4:	0017d79b          	srliw	a5,a5,0x1
ffffffffc02009a8:	ffe1                	bnez	a5,ffffffffc0200980 <buddy_free_pages+0xae>
ffffffffc02009aa:	bfcd                	j	ffffffffc020099c <buddy_free_pages+0xca>
ffffffffc02009ac:	02079613          	slli	a2,a5,0x20
ffffffffc02009b0:	00006517          	auipc	a0,0x6
ffffffffc02009b4:	ab853503          	ld	a0,-1352(a0) # ffffffffc0206468 <buddy>
ffffffffc02009b8:	01e65693          	srli	a3,a2,0x1e
ffffffffc02009bc:	96aa                	add	a3,a3,a0
ffffffffc02009be:	c298                	sw	a4,0(a3)
ffffffffc02009c0:	dff1                	beqz	a5,ffffffffc020099c <buddy_free_pages+0xca>
ffffffffc02009c2:	0017f693          	andi	a3,a5,1
ffffffffc02009c6:	eaa1                	bnez	a3,ffffffffc0200a16 <buddy_free_pages+0x144>
ffffffffc02009c8:	37f9                	addiw	a5,a5,-2
ffffffffc02009ca:	0017d79b          	srliw	a5,a5,0x1
ffffffffc02009ce:	0017969b          	slliw	a3,a5,0x1
ffffffffc02009d2:	0026861b          	addiw	a2,a3,2
ffffffffc02009d6:	1602                	slli	a2,a2,0x20
ffffffffc02009d8:	2685                	addiw	a3,a3,1
ffffffffc02009da:	02069593          	slli	a1,a3,0x20
ffffffffc02009de:	9201                	srli	a2,a2,0x20
ffffffffc02009e0:	01e5d693          	srli	a3,a1,0x1e
ffffffffc02009e4:	060a                	slli	a2,a2,0x2
ffffffffc02009e6:	96aa                	add	a3,a3,a0
ffffffffc02009e8:	962a                	add	a2,a2,a0
ffffffffc02009ea:	428c                	lw	a1,0(a3)
ffffffffc02009ec:	4210                	lw	a2,0(a2)
ffffffffc02009ee:	0017181b          	slliw	a6,a4,0x1
ffffffffc02009f2:	02079713          	slli	a4,a5,0x20
ffffffffc02009f6:	01e75693          	srli	a3,a4,0x1e
ffffffffc02009fa:	00c588bb          	addw	a7,a1,a2
ffffffffc02009fe:	0008071b          	sext.w	a4,a6
ffffffffc0200a02:	96aa                	add	a3,a3,a0
ffffffffc0200a04:	00e88663          	beq	a7,a4,ffffffffc0200a10 <buddy_free_pages+0x13e>
ffffffffc0200a08:	882e                	mv	a6,a1
ffffffffc0200a0a:	00c5f363          	bgeu	a1,a2,ffffffffc0200a10 <buddy_free_pages+0x13e>
ffffffffc0200a0e:	8832                	mv	a6,a2
ffffffffc0200a10:	0106a023          	sw	a6,0(a3)
ffffffffc0200a14:	b775                	j	ffffffffc02009c0 <buddy_free_pages+0xee>
ffffffffc0200a16:	37fd                	addiw	a5,a5,-1
ffffffffc0200a18:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200a1c:	bf4d                	j	ffffffffc02009ce <buddy_free_pages+0xfc>
ffffffffc0200a1e:	4605                	li	a2,1
ffffffffc0200a20:	02850693          	addi	a3,a0,40
ffffffffc0200a24:	b701                	j	ffffffffc0200924 <buddy_free_pages+0x52>
ffffffffc0200a26:	00001697          	auipc	a3,0x1
ffffffffc0200a2a:	7f268693          	addi	a3,a3,2034 # ffffffffc0202218 <commands+0x5a0>
ffffffffc0200a2e:	00001617          	auipc	a2,0x1
ffffffffc0200a32:	7ba60613          	addi	a2,a2,1978 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200a36:	0a200593          	li	a1,162
ffffffffc0200a3a:	00001517          	auipc	a0,0x1
ffffffffc0200a3e:	7c650513          	addi	a0,a0,1990 # ffffffffc0202200 <commands+0x588>
ffffffffc0200a42:	973ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200a46:	00001697          	auipc	a3,0x1
ffffffffc0200a4a:	79a68693          	addi	a3,a3,1946 # ffffffffc02021e0 <commands+0x568>
ffffffffc0200a4e:	00001617          	auipc	a2,0x1
ffffffffc0200a52:	79a60613          	addi	a2,a2,1946 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200a56:	09b00593          	li	a1,155
ffffffffc0200a5a:	00001517          	auipc	a0,0x1
ffffffffc0200a5e:	7a650513          	addi	a0,a0,1958 # ffffffffc0202200 <commands+0x588>
ffffffffc0200a62:	953ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200a66 <buddy_alloc_pages>:
ffffffffc0200a66:	1e050263          	beqz	a0,ffffffffc0200c4a <buddy_alloc_pages+0x1e4>
ffffffffc0200a6a:	00005817          	auipc	a6,0x5
ffffffffc0200a6e:	5c680813          	addi	a6,a6,1478 # ffffffffc0206030 <free_area>
ffffffffc0200a72:	01086783          	lwu	a5,16(a6)
ffffffffc0200a76:	1aa7ee63          	bltu	a5,a0,ffffffffc0200c32 <buddy_alloc_pages+0x1cc>
ffffffffc0200a7a:	0005031b          	sext.w	t1,a0
ffffffffc0200a7e:	fff5079b          	addiw	a5,a0,-1
ffffffffc0200a82:	00f377b3          	and	a5,t1,a5
ffffffffc0200a86:	2781                	sext.w	a5,a5
ffffffffc0200a88:	d21507d3          	fcvt.d.wu	fa5,a0
ffffffffc0200a8c:	16079a63          	bnez	a5,ffffffffc0200c00 <buddy_alloc_pages+0x19a>
ffffffffc0200a90:	00006897          	auipc	a7,0x6
ffffffffc0200a94:	9e088893          	addi	a7,a7,-1568 # ffffffffc0206470 <length>
ffffffffc0200a98:	0008a703          	lw	a4,0(a7)
ffffffffc0200a9c:	00006617          	auipc	a2,0x6
ffffffffc0200aa0:	9cc63603          	ld	a2,-1588(a2) # ffffffffc0206468 <buddy>
ffffffffc0200aa4:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0200aa8:	9fb9                	addw	a5,a5,a4
ffffffffc0200aaa:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200aae:	02079693          	slli	a3,a5,0x20
ffffffffc0200ab2:	9281                	srli	a3,a3,0x20
ffffffffc0200ab4:	0007871b          	sext.w	a4,a5
ffffffffc0200ab8:	0ad50963          	beq	a0,a3,ffffffffc0200b6a <buddy_alloc_pages+0x104>
ffffffffc0200abc:	4781                	li	a5,0
ffffffffc0200abe:	0017959b          	slliw	a1,a5,0x1
ffffffffc0200ac2:	0015879b          	addiw	a5,a1,1
ffffffffc0200ac6:	02079e13          	slli	t3,a5,0x20
ffffffffc0200aca:	01ee5693          	srli	a3,t3,0x1e
ffffffffc0200ace:	96b2                	add	a3,a3,a2
ffffffffc0200ad0:	0006e683          	lwu	a3,0(a3)
ffffffffc0200ad4:	00a6f463          	bgeu	a3,a0,ffffffffc0200adc <buddy_alloc_pages+0x76>
ffffffffc0200ad8:	0025879b          	addiw	a5,a1,2
ffffffffc0200adc:	0017571b          	srliw	a4,a4,0x1
ffffffffc0200ae0:	02071693          	slli	a3,a4,0x20
ffffffffc0200ae4:	9281                	srli	a3,a3,0x20
ffffffffc0200ae6:	fca69ce3          	bne	a3,a0,ffffffffc0200abe <buddy_alloc_pages+0x58>
ffffffffc0200aea:	00178e1b          	addiw	t3,a5,1
ffffffffc0200aee:	02ee073b          	mulw	a4,t3,a4
ffffffffc0200af2:	02079593          	slli	a1,a5,0x20
ffffffffc0200af6:	01e5d693          	srli	a3,a1,0x1e
ffffffffc0200afa:	96b2                	add	a3,a3,a2
ffffffffc0200afc:	0006a023          	sw	zero,0(a3)
ffffffffc0200b00:	0008a683          	lw	a3,0(a7)
ffffffffc0200b04:	01f6de1b          	srliw	t3,a3,0x1f
ffffffffc0200b08:	00de0e3b          	addw	t3,t3,a3
ffffffffc0200b0c:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc0200b10:	41c70e3b          	subw	t3,a4,t3
ffffffffc0200b14:	e7a1                	bnez	a5,ffffffffc0200b5c <buddy_alloc_pages+0xf6>
ffffffffc0200b16:	a0b5                	j	ffffffffc0200b82 <buddy_alloc_pages+0x11c>
ffffffffc0200b18:	37f9                	addiw	a5,a5,-2
ffffffffc0200b1a:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200b1e:	0017871b          	addiw	a4,a5,1
ffffffffc0200b22:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200b26:	fff7069b          	addiw	a3,a4,-1
ffffffffc0200b2a:	1702                	slli	a4,a4,0x20
ffffffffc0200b2c:	02069593          	slli	a1,a3,0x20
ffffffffc0200b30:	9301                	srli	a4,a4,0x20
ffffffffc0200b32:	01e5d693          	srli	a3,a1,0x1e
ffffffffc0200b36:	070a                	slli	a4,a4,0x2
ffffffffc0200b38:	9732                	add	a4,a4,a2
ffffffffc0200b3a:	96b2                	add	a3,a3,a2
ffffffffc0200b3c:	430c                	lw	a1,0(a4)
ffffffffc0200b3e:	4294                	lw	a3,0(a3)
ffffffffc0200b40:	02079513          	slli	a0,a5,0x20
ffffffffc0200b44:	01e55713          	srli	a4,a0,0x1e
ffffffffc0200b48:	0006889b          	sext.w	a7,a3
ffffffffc0200b4c:	0005851b          	sext.w	a0,a1
ffffffffc0200b50:	9732                	add	a4,a4,a2
ffffffffc0200b52:	00a8f363          	bgeu	a7,a0,ffffffffc0200b58 <buddy_alloc_pages+0xf2>
ffffffffc0200b56:	86ae                	mv	a3,a1
ffffffffc0200b58:	c314                	sw	a3,0(a4)
ffffffffc0200b5a:	c785                	beqz	a5,ffffffffc0200b82 <buddy_alloc_pages+0x11c>
ffffffffc0200b5c:	0017f693          	andi	a3,a5,1
ffffffffc0200b60:	dec5                	beqz	a3,ffffffffc0200b18 <buddy_alloc_pages+0xb2>
ffffffffc0200b62:	37fd                	addiw	a5,a5,-1
ffffffffc0200b64:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200b68:	bf5d                	j	ffffffffc0200b1e <buddy_alloc_pages+0xb8>
ffffffffc0200b6a:	00062023          	sw	zero,0(a2)
ffffffffc0200b6e:	0008a703          	lw	a4,0(a7)
ffffffffc0200b72:	01f75e1b          	srliw	t3,a4,0x1f
ffffffffc0200b76:	00ee0e3b          	addw	t3,t3,a4
ffffffffc0200b7a:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc0200b7e:	41c78e3b          	subw	t3,a5,t3
ffffffffc0200b82:	020e1793          	slli	a5,t3,0x20
ffffffffc0200b86:	9381                	srli	a5,a5,0x20
ffffffffc0200b88:	00279513          	slli	a0,a5,0x2
ffffffffc0200b8c:	97aa                	add	a5,a5,a0
ffffffffc0200b8e:	078e                	slli	a5,a5,0x3
ffffffffc0200b90:	00006517          	auipc	a0,0x6
ffffffffc0200b94:	8d053503          	ld	a0,-1840(a0) # ffffffffc0206460 <base0>
ffffffffc0200b98:	953e                	add	a0,a0,a5
ffffffffc0200b9a:	00652823          	sw	t1,16(a0)
ffffffffc0200b9e:	4785                	li	a5,1
ffffffffc0200ba0:	0867fb63          	bgeu	a5,t1,ffffffffc0200c36 <buddy_alloc_pages+0x1d0>
ffffffffc0200ba4:	4781                	li	a5,0
ffffffffc0200ba6:	00002717          	auipc	a4,0x2
ffffffffc0200baa:	c8a73687          	fld	fa3,-886(a4) # ffffffffc0202830 <error_string+0x38>
ffffffffc0200bae:	00002717          	auipc	a4,0x2
ffffffffc0200bb2:	c8a73707          	fld	fa4,-886(a4) # ffffffffc0202838 <error_string+0x40>
ffffffffc0200bb6:	12d7f7d3          	fmul.d	fa5,fa5,fa3
ffffffffc0200bba:	2785                	addiw	a5,a5,1
ffffffffc0200bbc:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200bc0:	fb7d                	bnez	a4,ffffffffc0200bb6 <buddy_alloc_pages+0x150>
ffffffffc0200bc2:	4705                	li	a4,1
ffffffffc0200bc4:	00f717bb          	sllw	a5,a4,a5
ffffffffc0200bc8:	02079693          	slli	a3,a5,0x20
ffffffffc0200bcc:	9281                	srli	a3,a3,0x20
ffffffffc0200bce:	00269713          	slli	a4,a3,0x2
ffffffffc0200bd2:	9736                	add	a4,a4,a3
ffffffffc0200bd4:	070e                	slli	a4,a4,0x3
ffffffffc0200bd6:	01082683          	lw	a3,16(a6)
ffffffffc0200bda:	972a                	add	a4,a4,a0
ffffffffc0200bdc:	40f687bb          	subw	a5,a3,a5
ffffffffc0200be0:	00f82823          	sw	a5,16(a6)
ffffffffc0200be4:	00e50d63          	beq	a0,a4,ffffffffc0200bfe <buddy_alloc_pages+0x198>
ffffffffc0200be8:	87aa                	mv	a5,a0
ffffffffc0200bea:	56f5                	li	a3,-3
ffffffffc0200bec:	00878613          	addi	a2,a5,8
ffffffffc0200bf0:	60d6302f          	amoand.d	zero,a3,(a2)
ffffffffc0200bf4:	02878793          	addi	a5,a5,40
ffffffffc0200bf8:	fee79ae3          	bne	a5,a4,ffffffffc0200bec <buddy_alloc_pages+0x186>
ffffffffc0200bfc:	8082                	ret
ffffffffc0200bfe:	8082                	ret
ffffffffc0200c00:	4785                	li	a5,1
ffffffffc0200c02:	02f50e63          	beq	a0,a5,ffffffffc0200c3e <buddy_alloc_pages+0x1d8>
ffffffffc0200c06:	4781                	li	a5,0
ffffffffc0200c08:	00002717          	auipc	a4,0x2
ffffffffc0200c0c:	c2873687          	fld	fa3,-984(a4) # ffffffffc0202830 <error_string+0x38>
ffffffffc0200c10:	00002717          	auipc	a4,0x2
ffffffffc0200c14:	c2873707          	fld	fa4,-984(a4) # ffffffffc0202838 <error_string+0x40>
ffffffffc0200c18:	12d7f7d3          	fmul.d	fa5,fa5,fa3
ffffffffc0200c1c:	2785                	addiw	a5,a5,1
ffffffffc0200c1e:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200c22:	fb7d                	bnez	a4,ffffffffc0200c18 <buddy_alloc_pages+0x1b2>
ffffffffc0200c24:	4705                	li	a4,1
ffffffffc0200c26:	00f7153b          	sllw	a0,a4,a5
ffffffffc0200c2a:	d21507d3          	fcvt.d.wu	fa5,a0
ffffffffc0200c2e:	832a                	mv	t1,a0
ffffffffc0200c30:	b585                	j	ffffffffc0200a90 <buddy_alloc_pages+0x2a>
ffffffffc0200c32:	4501                	li	a0,0
ffffffffc0200c34:	8082                	ret
ffffffffc0200c36:	4785                	li	a5,1
ffffffffc0200c38:	02800713          	li	a4,40
ffffffffc0200c3c:	bf69                	j	ffffffffc0200bd6 <buddy_alloc_pages+0x170>
ffffffffc0200c3e:	00002797          	auipc	a5,0x2
ffffffffc0200c42:	bfa7b787          	fld	fa5,-1030(a5) # ffffffffc0202838 <error_string+0x40>
ffffffffc0200c46:	4305                	li	t1,1
ffffffffc0200c48:	b5a1                	j	ffffffffc0200a90 <buddy_alloc_pages+0x2a>
ffffffffc0200c4a:	1141                	addi	sp,sp,-16
ffffffffc0200c4c:	00001697          	auipc	a3,0x1
ffffffffc0200c50:	59468693          	addi	a3,a3,1428 # ffffffffc02021e0 <commands+0x568>
ffffffffc0200c54:	00001617          	auipc	a2,0x1
ffffffffc0200c58:	59460613          	addi	a2,a2,1428 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200c5c:	04f00593          	li	a1,79
ffffffffc0200c60:	00001517          	auipc	a0,0x1
ffffffffc0200c64:	5a050513          	addi	a0,a0,1440 # ffffffffc0202200 <commands+0x588>
ffffffffc0200c68:	e406                	sd	ra,8(sp)
ffffffffc0200c6a:	f4aff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200c6e <buddy_check>:
ffffffffc0200c6e:	1101                	addi	sp,sp,-32
ffffffffc0200c70:	00001597          	auipc	a1,0x1
ffffffffc0200c74:	5d058593          	addi	a1,a1,1488 # ffffffffc0202240 <commands+0x5c8>
ffffffffc0200c78:	00001517          	auipc	a0,0x1
ffffffffc0200c7c:	5d050513          	addi	a0,a0,1488 # ffffffffc0202248 <commands+0x5d0>
ffffffffc0200c80:	ec06                	sd	ra,24(sp)
ffffffffc0200c82:	e822                	sd	s0,16(sp)
ffffffffc0200c84:	e426                	sd	s1,8(sp)
ffffffffc0200c86:	e04a                	sd	s2,0(sp)
ffffffffc0200c88:	c32ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200c8c:	4505                	li	a0,1
ffffffffc0200c8e:	2ee000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200c92:	14050263          	beqz	a0,ffffffffc0200dd6 <buddy_check+0x168>
ffffffffc0200c96:	842a                	mv	s0,a0
ffffffffc0200c98:	4505                	li	a0,1
ffffffffc0200c9a:	2e2000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200c9e:	84aa                	mv	s1,a0
ffffffffc0200ca0:	10050b63          	beqz	a0,ffffffffc0200db6 <buddy_check+0x148>
ffffffffc0200ca4:	4505                	li	a0,1
ffffffffc0200ca6:	2d6000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200caa:	892a                	mv	s2,a0
ffffffffc0200cac:	0e050563          	beqz	a0,ffffffffc0200d96 <buddy_check+0x128>
ffffffffc0200cb0:	0a940363          	beq	s0,s1,ffffffffc0200d56 <buddy_check+0xe8>
ffffffffc0200cb4:	0aa40163          	beq	s0,a0,ffffffffc0200d56 <buddy_check+0xe8>
ffffffffc0200cb8:	08a48f63          	beq	s1,a0,ffffffffc0200d56 <buddy_check+0xe8>
ffffffffc0200cbc:	401c                	lw	a5,0(s0)
ffffffffc0200cbe:	efc5                	bnez	a5,ffffffffc0200d76 <buddy_check+0x108>
ffffffffc0200cc0:	409c                	lw	a5,0(s1)
ffffffffc0200cc2:	ebd5                	bnez	a5,ffffffffc0200d76 <buddy_check+0x108>
ffffffffc0200cc4:	411c                	lw	a5,0(a0)
ffffffffc0200cc6:	ebc5                	bnez	a5,ffffffffc0200d76 <buddy_check+0x108>
ffffffffc0200cc8:	8522                	mv	a0,s0
ffffffffc0200cca:	4585                	li	a1,1
ffffffffc0200ccc:	2ee000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200cd0:	8526                	mv	a0,s1
ffffffffc0200cd2:	4585                	li	a1,1
ffffffffc0200cd4:	2e6000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200cd8:	4585                	li	a1,1
ffffffffc0200cda:	854a                	mv	a0,s2
ffffffffc0200cdc:	2de000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200ce0:	06400513          	li	a0,100
ffffffffc0200ce4:	298000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200ce8:	842a                	mv	s0,a0
ffffffffc0200cea:	06400513          	li	a0,100
ffffffffc0200cee:	28e000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200cf2:	04000513          	li	a0,64
ffffffffc0200cf6:	286000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200cfa:	678d                	lui	a5,0x3
ffffffffc0200cfc:	80078793          	addi	a5,a5,-2048 # 2800 <kern_entry-0xffffffffc01fd800>
ffffffffc0200d00:	6705                	lui	a4,0x1
ffffffffc0200d02:	40070713          	addi	a4,a4,1024 # 1400 <kern_entry-0xffffffffc01fec00>
ffffffffc0200d06:	97a2                	add	a5,a5,s0
ffffffffc0200d08:	892a                	mv	s2,a0
ffffffffc0200d0a:	00e404b3          	add	s1,s0,a4
ffffffffc0200d0e:	12f51463          	bne	a0,a5,ffffffffc0200e36 <buddy_check+0x1c8>
ffffffffc0200d12:	8522                	mv	a0,s0
ffffffffc0200d14:	4585                	li	a1,1
ffffffffc0200d16:	2a4000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200d1a:	02000513          	li	a0,32
ffffffffc0200d1e:	25e000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200d22:	0ea41a63          	bne	s0,a0,ffffffffc0200e16 <buddy_check+0x1a8>
ffffffffc0200d26:	4585                	li	a1,1
ffffffffc0200d28:	292000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200d2c:	8526                	mv	a0,s1
ffffffffc0200d2e:	4585                	li	a1,1
ffffffffc0200d30:	28a000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200d34:	10000513          	li	a0,256
ffffffffc0200d38:	244000ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0200d3c:	0aa41d63          	bne	s0,a0,ffffffffc0200df6 <buddy_check+0x188>
ffffffffc0200d40:	4585                	li	a1,1
ffffffffc0200d42:	278000ef          	jal	ra,ffffffffc0200fba <free_pages>
ffffffffc0200d46:	6442                	ld	s0,16(sp)
ffffffffc0200d48:	60e2                	ld	ra,24(sp)
ffffffffc0200d4a:	64a2                	ld	s1,8(sp)
ffffffffc0200d4c:	854a                	mv	a0,s2
ffffffffc0200d4e:	6902                	ld	s2,0(sp)
ffffffffc0200d50:	4585                	li	a1,1
ffffffffc0200d52:	6105                	addi	sp,sp,32
ffffffffc0200d54:	a49d                	j	ffffffffc0200fba <free_pages>
ffffffffc0200d56:	00001697          	auipc	a3,0x1
ffffffffc0200d5a:	56268693          	addi	a3,a3,1378 # ffffffffc02022b8 <commands+0x640>
ffffffffc0200d5e:	00001617          	auipc	a2,0x1
ffffffffc0200d62:	48a60613          	addi	a2,a2,1162 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200d66:	0ed00593          	li	a1,237
ffffffffc0200d6a:	00001517          	auipc	a0,0x1
ffffffffc0200d6e:	49650513          	addi	a0,a0,1174 # ffffffffc0202200 <commands+0x588>
ffffffffc0200d72:	e42ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200d76:	00001697          	auipc	a3,0x1
ffffffffc0200d7a:	56268693          	addi	a3,a3,1378 # ffffffffc02022d8 <commands+0x660>
ffffffffc0200d7e:	00001617          	auipc	a2,0x1
ffffffffc0200d82:	46a60613          	addi	a2,a2,1130 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200d86:	0ee00593          	li	a1,238
ffffffffc0200d8a:	00001517          	auipc	a0,0x1
ffffffffc0200d8e:	47650513          	addi	a0,a0,1142 # ffffffffc0202200 <commands+0x588>
ffffffffc0200d92:	e22ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200d96:	00001697          	auipc	a3,0x1
ffffffffc0200d9a:	50268693          	addi	a3,a3,1282 # ffffffffc0202298 <commands+0x620>
ffffffffc0200d9e:	00001617          	auipc	a2,0x1
ffffffffc0200da2:	44a60613          	addi	a2,a2,1098 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200da6:	0e900593          	li	a1,233
ffffffffc0200daa:	00001517          	auipc	a0,0x1
ffffffffc0200dae:	45650513          	addi	a0,a0,1110 # ffffffffc0202200 <commands+0x588>
ffffffffc0200db2:	e02ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200db6:	00001697          	auipc	a3,0x1
ffffffffc0200dba:	4c268693          	addi	a3,a3,1218 # ffffffffc0202278 <commands+0x600>
ffffffffc0200dbe:	00001617          	auipc	a2,0x1
ffffffffc0200dc2:	42a60613          	addi	a2,a2,1066 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200dc6:	0e700593          	li	a1,231
ffffffffc0200dca:	00001517          	auipc	a0,0x1
ffffffffc0200dce:	43650513          	addi	a0,a0,1078 # ffffffffc0202200 <commands+0x588>
ffffffffc0200dd2:	de2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200dd6:	00001697          	auipc	a3,0x1
ffffffffc0200dda:	48268693          	addi	a3,a3,1154 # ffffffffc0202258 <commands+0x5e0>
ffffffffc0200dde:	00001617          	auipc	a2,0x1
ffffffffc0200de2:	40a60613          	addi	a2,a2,1034 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200de6:	0e500593          	li	a1,229
ffffffffc0200dea:	00001517          	auipc	a0,0x1
ffffffffc0200dee:	41650513          	addi	a0,a0,1046 # ffffffffc0202200 <commands+0x588>
ffffffffc0200df2:	dc2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200df6:	00001697          	auipc	a3,0x1
ffffffffc0200dfa:	53a68693          	addi	a3,a3,1338 # ffffffffc0202330 <commands+0x6b8>
ffffffffc0200dfe:	00001617          	auipc	a2,0x1
ffffffffc0200e02:	3ea60613          	addi	a2,a2,1002 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200e06:	10a00593          	li	a1,266
ffffffffc0200e0a:	00001517          	auipc	a0,0x1
ffffffffc0200e0e:	3f650513          	addi	a0,a0,1014 # ffffffffc0202200 <commands+0x588>
ffffffffc0200e12:	da2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200e16:	00001697          	auipc	a3,0x1
ffffffffc0200e1a:	51268693          	addi	a3,a3,1298 # ffffffffc0202328 <commands+0x6b0>
ffffffffc0200e1e:	00001617          	auipc	a2,0x1
ffffffffc0200e22:	3ca60613          	addi	a2,a2,970 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200e26:	10400593          	li	a1,260
ffffffffc0200e2a:	00001517          	auipc	a0,0x1
ffffffffc0200e2e:	3d650513          	addi	a0,a0,982 # ffffffffc0202200 <commands+0x588>
ffffffffc0200e32:	d82ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200e36:	00001697          	auipc	a3,0x1
ffffffffc0200e3a:	4e268693          	addi	a3,a3,1250 # ffffffffc0202318 <commands+0x6a0>
ffffffffc0200e3e:	00001617          	auipc	a2,0x1
ffffffffc0200e42:	3aa60613          	addi	a2,a2,938 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200e46:	0ff00593          	li	a1,255
ffffffffc0200e4a:	00001517          	auipc	a0,0x1
ffffffffc0200e4e:	3b650513          	addi	a0,a0,950 # ffffffffc0202200 <commands+0x588>
ffffffffc0200e52:	d62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200e56 <buddy_init_memmap>:
ffffffffc0200e56:	1141                	addi	sp,sp,-16
ffffffffc0200e58:	e406                	sd	ra,8(sp)
ffffffffc0200e5a:	10058163          	beqz	a1,ffffffffc0200f5c <buddy_init_memmap+0x106>
ffffffffc0200e5e:	00259693          	slli	a3,a1,0x2
ffffffffc0200e62:	96ae                	add	a3,a3,a1
ffffffffc0200e64:	068e                	slli	a3,a3,0x3
ffffffffc0200e66:	96aa                	add	a3,a3,a0
ffffffffc0200e68:	87aa                	mv	a5,a0
ffffffffc0200e6a:	4609                	li	a2,2
ffffffffc0200e6c:	02d50363          	beq	a0,a3,ffffffffc0200e92 <buddy_init_memmap+0x3c>
ffffffffc0200e70:	6798                	ld	a4,8(a5)
ffffffffc0200e72:	8b05                	andi	a4,a4,1
ffffffffc0200e74:	c761                	beqz	a4,ffffffffc0200f3c <buddy_init_memmap+0xe6>
ffffffffc0200e76:	0007a823          	sw	zero,16(a5)
ffffffffc0200e7a:	0007b423          	sd	zero,8(a5)
ffffffffc0200e7e:	0007a023          	sw	zero,0(a5)
ffffffffc0200e82:	00878713          	addi	a4,a5,8
ffffffffc0200e86:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc0200e8a:	02878793          	addi	a5,a5,40
ffffffffc0200e8e:	fed791e3          	bne	a5,a3,ffffffffc0200e70 <buddy_init_memmap+0x1a>
ffffffffc0200e92:	2581                	sext.w	a1,a1
ffffffffc0200e94:	c90c                	sw	a1,16(a0)
ffffffffc0200e96:	4689                	li	a3,2
ffffffffc0200e98:	00850793          	addi	a5,a0,8
ffffffffc0200e9c:	40d7b02f          	amoor.d	zero,a3,(a5)
ffffffffc0200ea0:	00005717          	auipc	a4,0x5
ffffffffc0200ea4:	19070713          	addi	a4,a4,400 # ffffffffc0206030 <free_area>
ffffffffc0200ea8:	4b1c                	lw	a5,16(a4)
ffffffffc0200eaa:	00005617          	auipc	a2,0x5
ffffffffc0200eae:	5aa63b23          	sd	a0,1462(a2) # ffffffffc0206460 <base0>
ffffffffc0200eb2:	4605                	li	a2,1
ffffffffc0200eb4:	9fad                	addw	a5,a5,a1
ffffffffc0200eb6:	cb1c                	sw	a5,16(a4)
ffffffffc0200eb8:	d21587d3          	fcvt.d.wu	fa5,a1
ffffffffc0200ebc:	06b67363          	bgeu	a2,a1,ffffffffc0200f22 <buddy_init_memmap+0xcc>
ffffffffc0200ec0:	4781                	li	a5,0
ffffffffc0200ec2:	00002717          	auipc	a4,0x2
ffffffffc0200ec6:	96e73687          	fld	fa3,-1682(a4) # ffffffffc0202830 <error_string+0x38>
ffffffffc0200eca:	00002717          	auipc	a4,0x2
ffffffffc0200ece:	96e73707          	fld	fa4,-1682(a4) # ffffffffc0202838 <error_string+0x40>
ffffffffc0200ed2:	12d7f7d3          	fmul.d	fa5,fa5,fa3
ffffffffc0200ed6:	2785                	addiw	a5,a5,1
ffffffffc0200ed8:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200edc:	fb7d                	bnez	a4,ffffffffc0200ed2 <buddy_init_memmap+0x7c>
ffffffffc0200ede:	4709                	li	a4,2
ffffffffc0200ee0:	00f7163b          	sllw	a2,a4,a5
ffffffffc0200ee4:	00261713          	slli	a4,a2,0x2
ffffffffc0200ee8:	9732                	add	a4,a4,a2
ffffffffc0200eea:	070e                	slli	a4,a4,0x3
ffffffffc0200eec:	00005597          	auipc	a1,0x5
ffffffffc0200ef0:	58458593          	addi	a1,a1,1412 # ffffffffc0206470 <length>
ffffffffc0200ef4:	972a                	add	a4,a4,a0
ffffffffc0200ef6:	c190                	sw	a2,0(a1)
ffffffffc0200ef8:	00005797          	auipc	a5,0x5
ffffffffc0200efc:	56e7b823          	sd	a4,1392(a5) # ffffffffc0206468 <buddy>
ffffffffc0200f00:	00c05e63          	blez	a2,ffffffffc0200f1c <buddy_init_memmap+0xc6>
ffffffffc0200f04:	4781                	li	a5,0
ffffffffc0200f06:	86be                	mv	a3,a5
ffffffffc0200f08:	2785                	addiw	a5,a5,1
ffffffffc0200f0a:	8efd                	and	a3,a3,a5
ffffffffc0200f0c:	e299                	bnez	a3,ffffffffc0200f12 <buddy_init_memmap+0xbc>
ffffffffc0200f0e:	0016561b          	srliw	a2,a2,0x1
ffffffffc0200f12:	c310                	sw	a2,0(a4)
ffffffffc0200f14:	4194                	lw	a3,0(a1)
ffffffffc0200f16:	0711                	addi	a4,a4,4
ffffffffc0200f18:	fed7c7e3          	blt	a5,a3,ffffffffc0200f06 <buddy_init_memmap+0xb0>
ffffffffc0200f1c:	60a2                	ld	ra,8(sp)
ffffffffc0200f1e:	0141                	addi	sp,sp,16
ffffffffc0200f20:	8082                	ret
ffffffffc0200f22:	00005597          	auipc	a1,0x5
ffffffffc0200f26:	54e58593          	addi	a1,a1,1358 # ffffffffc0206470 <length>
ffffffffc0200f2a:	05050713          	addi	a4,a0,80
ffffffffc0200f2e:	c194                	sw	a3,0(a1)
ffffffffc0200f30:	00005797          	auipc	a5,0x5
ffffffffc0200f34:	52e7bc23          	sd	a4,1336(a5) # ffffffffc0206468 <buddy>
ffffffffc0200f38:	4609                	li	a2,2
ffffffffc0200f3a:	b7e9                	j	ffffffffc0200f04 <buddy_init_memmap+0xae>
ffffffffc0200f3c:	00001697          	auipc	a3,0x1
ffffffffc0200f40:	40468693          	addi	a3,a3,1028 # ffffffffc0202340 <commands+0x6c8>
ffffffffc0200f44:	00001617          	auipc	a2,0x1
ffffffffc0200f48:	2a460613          	addi	a2,a2,676 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200f4c:	03000593          	li	a1,48
ffffffffc0200f50:	00001517          	auipc	a0,0x1
ffffffffc0200f54:	2b050513          	addi	a0,a0,688 # ffffffffc0202200 <commands+0x588>
ffffffffc0200f58:	c5cff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200f5c:	00001697          	auipc	a3,0x1
ffffffffc0200f60:	28468693          	addi	a3,a3,644 # ffffffffc02021e0 <commands+0x568>
ffffffffc0200f64:	00001617          	auipc	a2,0x1
ffffffffc0200f68:	28460613          	addi	a2,a2,644 # ffffffffc02021e8 <commands+0x570>
ffffffffc0200f6c:	02c00593          	li	a1,44
ffffffffc0200f70:	00001517          	auipc	a0,0x1
ffffffffc0200f74:	29050513          	addi	a0,a0,656 # ffffffffc0202200 <commands+0x588>
ffffffffc0200f78:	c3cff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200f7c <alloc_pages>:
ffffffffc0200f7c:	100027f3          	csrr	a5,sstatus
ffffffffc0200f80:	8b89                	andi	a5,a5,2
ffffffffc0200f82:	e799                	bnez	a5,ffffffffc0200f90 <alloc_pages+0x14>
ffffffffc0200f84:	00005797          	auipc	a5,0x5
ffffffffc0200f88:	5047b783          	ld	a5,1284(a5) # ffffffffc0206488 <pmm_manager>
ffffffffc0200f8c:	6f9c                	ld	a5,24(a5)
ffffffffc0200f8e:	8782                	jr	a5
ffffffffc0200f90:	1141                	addi	sp,sp,-16
ffffffffc0200f92:	e406                	sd	ra,8(sp)
ffffffffc0200f94:	e022                	sd	s0,0(sp)
ffffffffc0200f96:	842a                	mv	s0,a0
ffffffffc0200f98:	cceff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
ffffffffc0200f9c:	00005797          	auipc	a5,0x5
ffffffffc0200fa0:	4ec7b783          	ld	a5,1260(a5) # ffffffffc0206488 <pmm_manager>
ffffffffc0200fa4:	6f9c                	ld	a5,24(a5)
ffffffffc0200fa6:	8522                	mv	a0,s0
ffffffffc0200fa8:	9782                	jalr	a5
ffffffffc0200faa:	842a                	mv	s0,a0
ffffffffc0200fac:	cb4ff0ef          	jal	ra,ffffffffc0200460 <intr_enable>
ffffffffc0200fb0:	60a2                	ld	ra,8(sp)
ffffffffc0200fb2:	8522                	mv	a0,s0
ffffffffc0200fb4:	6402                	ld	s0,0(sp)
ffffffffc0200fb6:	0141                	addi	sp,sp,16
ffffffffc0200fb8:	8082                	ret

ffffffffc0200fba <free_pages>:
ffffffffc0200fba:	100027f3          	csrr	a5,sstatus
ffffffffc0200fbe:	8b89                	andi	a5,a5,2
ffffffffc0200fc0:	e799                	bnez	a5,ffffffffc0200fce <free_pages+0x14>
ffffffffc0200fc2:	00005797          	auipc	a5,0x5
ffffffffc0200fc6:	4c67b783          	ld	a5,1222(a5) # ffffffffc0206488 <pmm_manager>
ffffffffc0200fca:	739c                	ld	a5,32(a5)
ffffffffc0200fcc:	8782                	jr	a5
ffffffffc0200fce:	1101                	addi	sp,sp,-32
ffffffffc0200fd0:	ec06                	sd	ra,24(sp)
ffffffffc0200fd2:	e822                	sd	s0,16(sp)
ffffffffc0200fd4:	e426                	sd	s1,8(sp)
ffffffffc0200fd6:	842a                	mv	s0,a0
ffffffffc0200fd8:	84ae                	mv	s1,a1
ffffffffc0200fda:	c8cff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
ffffffffc0200fde:	00005797          	auipc	a5,0x5
ffffffffc0200fe2:	4aa7b783          	ld	a5,1194(a5) # ffffffffc0206488 <pmm_manager>
ffffffffc0200fe6:	739c                	ld	a5,32(a5)
ffffffffc0200fe8:	85a6                	mv	a1,s1
ffffffffc0200fea:	8522                	mv	a0,s0
ffffffffc0200fec:	9782                	jalr	a5
ffffffffc0200fee:	6442                	ld	s0,16(sp)
ffffffffc0200ff0:	60e2                	ld	ra,24(sp)
ffffffffc0200ff2:	64a2                	ld	s1,8(sp)
ffffffffc0200ff4:	6105                	addi	sp,sp,32
ffffffffc0200ff6:	c6aff06f          	j	ffffffffc0200460 <intr_enable>

ffffffffc0200ffa <pmm_init>:
ffffffffc0200ffa:	00001797          	auipc	a5,0x1
ffffffffc0200ffe:	36e78793          	addi	a5,a5,878 # ffffffffc0202368 <buddy_pmm_manager>
ffffffffc0201002:	638c                	ld	a1,0(a5)
ffffffffc0201004:	1101                	addi	sp,sp,-32
ffffffffc0201006:	e426                	sd	s1,8(sp)
ffffffffc0201008:	00001517          	auipc	a0,0x1
ffffffffc020100c:	39850513          	addi	a0,a0,920 # ffffffffc02023a0 <buddy_pmm_manager+0x38>
ffffffffc0201010:	00005497          	auipc	s1,0x5
ffffffffc0201014:	47848493          	addi	s1,s1,1144 # ffffffffc0206488 <pmm_manager>
ffffffffc0201018:	ec06                	sd	ra,24(sp)
ffffffffc020101a:	e822                	sd	s0,16(sp)
ffffffffc020101c:	e09c                	sd	a5,0(s1)
ffffffffc020101e:	89cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201022:	609c                	ld	a5,0(s1)
ffffffffc0201024:	00005417          	auipc	s0,0x5
ffffffffc0201028:	47c40413          	addi	s0,s0,1148 # ffffffffc02064a0 <va_pa_offset>
ffffffffc020102c:	679c                	ld	a5,8(a5)
ffffffffc020102e:	9782                	jalr	a5
ffffffffc0201030:	57f5                	li	a5,-3
ffffffffc0201032:	07fa                	slli	a5,a5,0x1e
ffffffffc0201034:	00001517          	auipc	a0,0x1
ffffffffc0201038:	38450513          	addi	a0,a0,900 # ffffffffc02023b8 <buddy_pmm_manager+0x50>
ffffffffc020103c:	e01c                	sd	a5,0(s0)
ffffffffc020103e:	87cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201042:	46c5                	li	a3,17
ffffffffc0201044:	06ee                	slli	a3,a3,0x1b
ffffffffc0201046:	40100613          	li	a2,1025
ffffffffc020104a:	16fd                	addi	a3,a3,-1
ffffffffc020104c:	07e005b7          	lui	a1,0x7e00
ffffffffc0201050:	0656                	slli	a2,a2,0x15
ffffffffc0201052:	00001517          	auipc	a0,0x1
ffffffffc0201056:	37e50513          	addi	a0,a0,894 # ffffffffc02023d0 <buddy_pmm_manager+0x68>
ffffffffc020105a:	860ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020105e:	777d                	lui	a4,0xfffff
ffffffffc0201060:	00006797          	auipc	a5,0x6
ffffffffc0201064:	45778793          	addi	a5,a5,1111 # ffffffffc02074b7 <end+0xfff>
ffffffffc0201068:	8ff9                	and	a5,a5,a4
ffffffffc020106a:	00005517          	auipc	a0,0x5
ffffffffc020106e:	40e50513          	addi	a0,a0,1038 # ffffffffc0206478 <npage>
ffffffffc0201072:	00088737          	lui	a4,0x88
ffffffffc0201076:	00005597          	auipc	a1,0x5
ffffffffc020107a:	40a58593          	addi	a1,a1,1034 # ffffffffc0206480 <pages>
ffffffffc020107e:	e118                	sd	a4,0(a0)
ffffffffc0201080:	e19c                	sd	a5,0(a1)
ffffffffc0201082:	4681                	li	a3,0
ffffffffc0201084:	4701                	li	a4,0
ffffffffc0201086:	4885                	li	a7,1
ffffffffc0201088:	fff80837          	lui	a6,0xfff80
ffffffffc020108c:	a011                	j	ffffffffc0201090 <pmm_init+0x96>
ffffffffc020108e:	619c                	ld	a5,0(a1)
ffffffffc0201090:	97b6                	add	a5,a5,a3
ffffffffc0201092:	07a1                	addi	a5,a5,8
ffffffffc0201094:	4117b02f          	amoor.d	zero,a7,(a5)
ffffffffc0201098:	611c                	ld	a5,0(a0)
ffffffffc020109a:	0705                	addi	a4,a4,1
ffffffffc020109c:	02868693          	addi	a3,a3,40
ffffffffc02010a0:	01078633          	add	a2,a5,a6
ffffffffc02010a4:	fec765e3          	bltu	a4,a2,ffffffffc020108e <pmm_init+0x94>
ffffffffc02010a8:	6190                	ld	a2,0(a1)
ffffffffc02010aa:	00279713          	slli	a4,a5,0x2
ffffffffc02010ae:	973e                	add	a4,a4,a5
ffffffffc02010b0:	fec006b7          	lui	a3,0xfec00
ffffffffc02010b4:	070e                	slli	a4,a4,0x3
ffffffffc02010b6:	96b2                	add	a3,a3,a2
ffffffffc02010b8:	96ba                	add	a3,a3,a4
ffffffffc02010ba:	c0200737          	lui	a4,0xc0200
ffffffffc02010be:	08e6ef63          	bltu	a3,a4,ffffffffc020115c <pmm_init+0x162>
ffffffffc02010c2:	6018                	ld	a4,0(s0)
ffffffffc02010c4:	45c5                	li	a1,17
ffffffffc02010c6:	05ee                	slli	a1,a1,0x1b
ffffffffc02010c8:	8e99                	sub	a3,a3,a4
ffffffffc02010ca:	04b6e863          	bltu	a3,a1,ffffffffc020111a <pmm_init+0x120>
ffffffffc02010ce:	609c                	ld	a5,0(s1)
ffffffffc02010d0:	7b9c                	ld	a5,48(a5)
ffffffffc02010d2:	9782                	jalr	a5
ffffffffc02010d4:	00001517          	auipc	a0,0x1
ffffffffc02010d8:	39450513          	addi	a0,a0,916 # ffffffffc0202468 <buddy_pmm_manager+0x100>
ffffffffc02010dc:	fdffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02010e0:	00004597          	auipc	a1,0x4
ffffffffc02010e4:	f2058593          	addi	a1,a1,-224 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02010e8:	00005797          	auipc	a5,0x5
ffffffffc02010ec:	3ab7b823          	sd	a1,944(a5) # ffffffffc0206498 <satp_virtual>
ffffffffc02010f0:	c02007b7          	lui	a5,0xc0200
ffffffffc02010f4:	08f5e063          	bltu	a1,a5,ffffffffc0201174 <pmm_init+0x17a>
ffffffffc02010f8:	6010                	ld	a2,0(s0)
ffffffffc02010fa:	6442                	ld	s0,16(sp)
ffffffffc02010fc:	60e2                	ld	ra,24(sp)
ffffffffc02010fe:	64a2                	ld	s1,8(sp)
ffffffffc0201100:	40c58633          	sub	a2,a1,a2
ffffffffc0201104:	00005797          	auipc	a5,0x5
ffffffffc0201108:	38c7b623          	sd	a2,908(a5) # ffffffffc0206490 <satp_physical>
ffffffffc020110c:	00001517          	auipc	a0,0x1
ffffffffc0201110:	37c50513          	addi	a0,a0,892 # ffffffffc0202488 <buddy_pmm_manager+0x120>
ffffffffc0201114:	6105                	addi	sp,sp,32
ffffffffc0201116:	fa5fe06f          	j	ffffffffc02000ba <cprintf>
ffffffffc020111a:	6705                	lui	a4,0x1
ffffffffc020111c:	177d                	addi	a4,a4,-1
ffffffffc020111e:	96ba                	add	a3,a3,a4
ffffffffc0201120:	777d                	lui	a4,0xfffff
ffffffffc0201122:	8ef9                	and	a3,a3,a4
ffffffffc0201124:	00c6d513          	srli	a0,a3,0xc
ffffffffc0201128:	00f57e63          	bgeu	a0,a5,ffffffffc0201144 <pmm_init+0x14a>
ffffffffc020112c:	609c                	ld	a5,0(s1)
ffffffffc020112e:	982a                	add	a6,a6,a0
ffffffffc0201130:	00281513          	slli	a0,a6,0x2
ffffffffc0201134:	9542                	add	a0,a0,a6
ffffffffc0201136:	6b9c                	ld	a5,16(a5)
ffffffffc0201138:	8d95                	sub	a1,a1,a3
ffffffffc020113a:	050e                	slli	a0,a0,0x3
ffffffffc020113c:	81b1                	srli	a1,a1,0xc
ffffffffc020113e:	9532                	add	a0,a0,a2
ffffffffc0201140:	9782                	jalr	a5
ffffffffc0201142:	b771                	j	ffffffffc02010ce <pmm_init+0xd4>
ffffffffc0201144:	00001617          	auipc	a2,0x1
ffffffffc0201148:	2f460613          	addi	a2,a2,756 # ffffffffc0202438 <buddy_pmm_manager+0xd0>
ffffffffc020114c:	06b00593          	li	a1,107
ffffffffc0201150:	00001517          	auipc	a0,0x1
ffffffffc0201154:	30850513          	addi	a0,a0,776 # ffffffffc0202458 <buddy_pmm_manager+0xf0>
ffffffffc0201158:	a5cff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020115c:	00001617          	auipc	a2,0x1
ffffffffc0201160:	2a460613          	addi	a2,a2,676 # ffffffffc0202400 <buddy_pmm_manager+0x98>
ffffffffc0201164:	07200593          	li	a1,114
ffffffffc0201168:	00001517          	auipc	a0,0x1
ffffffffc020116c:	2c050513          	addi	a0,a0,704 # ffffffffc0202428 <buddy_pmm_manager+0xc0>
ffffffffc0201170:	a44ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0201174:	86ae                	mv	a3,a1
ffffffffc0201176:	00001617          	auipc	a2,0x1
ffffffffc020117a:	28a60613          	addi	a2,a2,650 # ffffffffc0202400 <buddy_pmm_manager+0x98>
ffffffffc020117e:	08d00593          	li	a1,141
ffffffffc0201182:	00001517          	auipc	a0,0x1
ffffffffc0201186:	2a650513          	addi	a0,a0,678 # ffffffffc0202428 <buddy_pmm_manager+0xc0>
ffffffffc020118a:	a2aff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020118e <obj_free>:
// 将一个size大小的新块加入链表
static void obj_free(void *block, int size)
{
	obj_t *cur, *b = (obj_t *)block;

	if (!block)
ffffffffc020118e:	cd1d                	beqz	a0,ffffffffc02011cc <obj_free+0x3e>
		return;

	if (size)
ffffffffc0201190:	ed9d                	bnez	a1,ffffffffc02011ce <obj_free+0x40>
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->objsize == cur->next) {
ffffffffc0201192:	4114                	lw	a3,0(a0)
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201194:	00005597          	auipc	a1,0x5
ffffffffc0201198:	e7c58593          	addi	a1,a1,-388 # ffffffffc0206010 <objfree>
ffffffffc020119c:	619c                	ld	a5,0(a1)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020119e:	873e                	mv	a4,a5
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02011a0:	679c                	ld	a5,8(a5)
ffffffffc02011a2:	02a77b63          	bgeu	a4,a0,ffffffffc02011d8 <obj_free+0x4a>
ffffffffc02011a6:	00f56463          	bltu	a0,a5,ffffffffc02011ae <obj_free+0x20>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02011aa:	fef76ae3          	bltu	a4,a5,ffffffffc020119e <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc02011ae:	00469613          	slli	a2,a3,0x4
ffffffffc02011b2:	962a                	add	a2,a2,a0
ffffffffc02011b4:	02c78b63          	beq	a5,a2,ffffffffc02011ea <obj_free+0x5c>
		b->objsize += cur->next->objsize;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->objsize == b) {
ffffffffc02011b8:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02011ba:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc02011bc:	00469793          	slli	a5,a3,0x4
ffffffffc02011c0:	97ba                	add	a5,a5,a4
ffffffffc02011c2:	02f50f63          	beq	a0,a5,ffffffffc0201200 <obj_free+0x72>
		cur->objsize += b->objsize;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
ffffffffc02011c6:	e708                	sd	a0,8(a4)
    
    // 更新空闲块位置
	objfree = cur;
ffffffffc02011c8:	e198                	sd	a4,0(a1)
ffffffffc02011ca:	8082                	ret
}
ffffffffc02011cc:	8082                	ret
		b->objsize = OBJ_UNITS(size);  
ffffffffc02011ce:	00f5869b          	addiw	a3,a1,15
ffffffffc02011d2:	8691                	srai	a3,a3,0x4
ffffffffc02011d4:	c114                	sw	a3,0(a0)
ffffffffc02011d6:	bf7d                	j	ffffffffc0201194 <obj_free+0x6>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02011d8:	fcf763e3          	bltu	a4,a5,ffffffffc020119e <obj_free+0x10>
ffffffffc02011dc:	fcf571e3          	bgeu	a0,a5,ffffffffc020119e <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc02011e0:	00469613          	slli	a2,a3,0x4
ffffffffc02011e4:	962a                	add	a2,a2,a0
ffffffffc02011e6:	fcc799e3          	bne	a5,a2,ffffffffc02011b8 <obj_free+0x2a>
		b->objsize += cur->next->objsize;
ffffffffc02011ea:	4390                	lw	a2,0(a5)
		b->next = cur->next->next;
ffffffffc02011ec:	679c                	ld	a5,8(a5)
		b->objsize += cur->next->objsize;
ffffffffc02011ee:	9eb1                	addw	a3,a3,a2
ffffffffc02011f0:	c114                	sw	a3,0(a0)
	if (cur + cur->objsize == b) {
ffffffffc02011f2:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02011f4:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc02011f6:	00469793          	slli	a5,a3,0x4
ffffffffc02011fa:	97ba                	add	a5,a5,a4
ffffffffc02011fc:	fcf515e3          	bne	a0,a5,ffffffffc02011c6 <obj_free+0x38>
		cur->objsize += b->objsize;
ffffffffc0201200:	411c                	lw	a5,0(a0)
		cur->next = b->next;
ffffffffc0201202:	6510                	ld	a2,8(a0)
	objfree = cur;
ffffffffc0201204:	e198                	sd	a4,0(a1)
		cur->objsize += b->objsize;
ffffffffc0201206:	9ebd                	addw	a3,a3,a5
ffffffffc0201208:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc020120a:	e710                	sd	a2,8(a4)
	objfree = cur;
ffffffffc020120c:	8082                	ret

ffffffffc020120e <obj_alloc>:

// 小块分配(传入size是算上头部obj_t的)
static void *obj_alloc(size_t size)
{
ffffffffc020120e:	1101                	addi	sp,sp,-32
ffffffffc0201210:	ec06                	sd	ra,24(sp)
ffffffffc0201212:	e822                	sd	s0,16(sp)
ffffffffc0201214:	e426                	sd	s1,8(sp)
ffffffffc0201216:	e04a                	sd	s2,0(sp)
	assert(size < PGSIZE);
ffffffffc0201218:	6785                	lui	a5,0x1
ffffffffc020121a:	08f57363          	bgeu	a0,a5,ffffffffc02012a0 <obj_alloc+0x92>

	obj_t *prev, *cur;
	int objsize = OBJ_UNITS(size);

	prev = objfree;  // 从头遍历小块链表
ffffffffc020121e:	00005417          	auipc	s0,0x5
ffffffffc0201222:	df240413          	addi	s0,s0,-526 # ffffffffc0206010 <objfree>
ffffffffc0201226:	6010                	ld	a2,0(s0)
	int objsize = OBJ_UNITS(size);
ffffffffc0201228:	053d                	addi	a0,a0,15
ffffffffc020122a:	00455913          	srli	s2,a0,0x4
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020122e:	6618                	ld	a4,8(a2)
	int objsize = OBJ_UNITS(size);
ffffffffc0201230:	0009049b          	sext.w	s1,s2
		
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0201234:	4314                	lw	a3,0(a4)
ffffffffc0201236:	0696d263          	bge	a3,s1,ffffffffc020129a <obj_alloc+0x8c>
			}
			objfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc020123a:	00e60a63          	beq	a2,a4,ffffffffc020124e <obj_alloc+0x40>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020123e:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0201240:	4394                	lw	a3,0(a5)
ffffffffc0201242:	0296d363          	bge	a3,s1,ffffffffc0201268 <obj_alloc+0x5a>
		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc0201246:	6010                	ld	a2,0(s0)
ffffffffc0201248:	873e                	mv	a4,a5
ffffffffc020124a:	fee61ae3          	bne	a2,a4,ffffffffc020123e <obj_alloc+0x30>

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (obj_t *)alloc_pages(1);  
ffffffffc020124e:	4505                	li	a0,1
ffffffffc0201250:	d2dff0ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
ffffffffc0201254:	87aa                	mv	a5,a0
			if (!cur)  // 如果获取失败，返回 0
ffffffffc0201256:	c51d                	beqz	a0,ffffffffc0201284 <obj_alloc+0x76>
				return 0;

			obj_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
ffffffffc0201258:	6585                	lui	a1,0x1
ffffffffc020125a:	f35ff0ef          	jal	ra,ffffffffc020118e <obj_free>
			cur = objfree;  // 从新分配的页前一个块再次循环
ffffffffc020125e:	6018                	ld	a4,0(s0)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201260:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc0201262:	4394                	lw	a3,0(a5)
ffffffffc0201264:	fe96c1e3          	blt	a3,s1,ffffffffc0201246 <obj_alloc+0x38>
			if (cur->objsize == objsize)
ffffffffc0201268:	02d48563          	beq	s1,a3,ffffffffc0201292 <obj_alloc+0x84>
				prev->next = cur + objsize;  
ffffffffc020126c:	0912                	slli	s2,s2,0x4
ffffffffc020126e:	993e                	add	s2,s2,a5
ffffffffc0201270:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8b50>
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc0201274:	6790                	ld	a2,8(a5)
				prev->next->objsize = cur->objsize - objsize;
ffffffffc0201276:	9e85                	subw	a3,a3,s1
ffffffffc0201278:	00d92023          	sw	a3,0(s2)
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc020127c:	00c93423          	sd	a2,8(s2)
				cur->objsize = objsize;  // units大小的块被取出
ffffffffc0201280:	c384                	sw	s1,0(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201282:	e018                	sd	a4,0(s0)
		}
	}
}
ffffffffc0201284:	60e2                	ld	ra,24(sp)
ffffffffc0201286:	6442                	ld	s0,16(sp)
ffffffffc0201288:	64a2                	ld	s1,8(sp)
ffffffffc020128a:	6902                	ld	s2,0(sp)
ffffffffc020128c:	853e                	mv	a0,a5
ffffffffc020128e:	6105                	addi	sp,sp,32
ffffffffc0201290:	8082                	ret
				prev->next = cur->next;
ffffffffc0201292:	6794                	ld	a3,8(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201294:	e018                	sd	a4,0(s0)
				prev->next = cur->next;
ffffffffc0201296:	e714                	sd	a3,8(a4)
			return cur;
ffffffffc0201298:	b7f5                	j	ffffffffc0201284 <obj_alloc+0x76>
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc020129a:	87ba                	mv	a5,a4
ffffffffc020129c:	8732                	mv	a4,a2
ffffffffc020129e:	b7e9                	j	ffffffffc0201268 <obj_alloc+0x5a>
	assert(size < PGSIZE);
ffffffffc02012a0:	00001697          	auipc	a3,0x1
ffffffffc02012a4:	22868693          	addi	a3,a3,552 # ffffffffc02024c8 <buddy_pmm_manager+0x160>
ffffffffc02012a8:	00001617          	auipc	a2,0x1
ffffffffc02012ac:	f4060613          	addi	a2,a2,-192 # ffffffffc02021e8 <commands+0x570>
ffffffffc02012b0:	04a00593          	li	a1,74
ffffffffc02012b4:	00001517          	auipc	a0,0x1
ffffffffc02012b8:	22450513          	addi	a0,a0,548 # ffffffffc02024d8 <buddy_pmm_manager+0x170>
ffffffffc02012bc:	8f8ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02012c0 <slub_alloc.part.0>:
		order++;
	return order;
}

// 总slub分配算法(传入申请的大小)
void *slub_alloc(size_t size)
ffffffffc02012c0:	1101                	addi	sp,sp,-32
ffffffffc02012c2:	e822                	sd	s0,16(sp)
ffffffffc02012c4:	842a                	mv	s0,a0
		m = obj_alloc(size + OBJ_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc02012c6:	02000513          	li	a0,32
void *slub_alloc(size_t size)
ffffffffc02012ca:	ec06                	sd	ra,24(sp)
ffffffffc02012cc:	e426                	sd	s1,8(sp)
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc02012ce:	f41ff0ef          	jal	ra,ffffffffc020120e <obj_alloc>
	if (!bb)
ffffffffc02012d2:	cd05                	beqz	a0,ffffffffc020130a <slub_alloc.part.0+0x4a>
		return 0;
    
    // 分配大页
	bb->order = ((size - 1) >> PGSHIFT) + 1;  // PGSHIFT为12，向右移12位的效果相当于除以2^12即4096）
ffffffffc02012d4:	fff40793          	addi	a5,s0,-1
ffffffffc02012d8:	83b1                	srli	a5,a5,0xc
ffffffffc02012da:	84aa                	mv	s1,a0
ffffffffc02012dc:	0017851b          	addiw	a0,a5,1
ffffffffc02012e0:	c088                	sw	a0,0(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc02012e2:	c9bff0ef          	jal	ra,ffffffffc0200f7c <alloc_pages>
    
	// 设置大块标志
    bb->is_bigblock = 1;
ffffffffc02012e6:	4785                	li	a5,1
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc02012e8:	e488                	sd	a0,8(s1)
    bb->is_bigblock = 1;
ffffffffc02012ea:	cc9c                	sw	a5,24(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc02012ec:	842a                	mv	s0,a0
    
	// 分配成功，将其插入到大块链表的头部。
	if (bb->pages) {
ffffffffc02012ee:	c50d                	beqz	a0,ffffffffc0201318 <slub_alloc.part.0+0x58>
		bb->next = bigblocks_head;
ffffffffc02012f0:	00005797          	auipc	a5,0x5
ffffffffc02012f4:	1b878793          	addi	a5,a5,440 # ffffffffc02064a8 <bigblocks_head>
ffffffffc02012f8:	6398                	ld	a4,0(a5)
	}
    
    // 如果页分配失败，释放之前为bigblock_t结构体分配的内存。返回0。
	obj_free(bb, sizeof(bigblock_t));
	return 0;
}
ffffffffc02012fa:	60e2                	ld	ra,24(sp)
ffffffffc02012fc:	8522                	mv	a0,s0
ffffffffc02012fe:	6442                	ld	s0,16(sp)
		bigblocks_head = bb;
ffffffffc0201300:	e384                	sd	s1,0(a5)
		bb->next = bigblocks_head;
ffffffffc0201302:	e898                	sd	a4,16(s1)
}
ffffffffc0201304:	64a2                	ld	s1,8(sp)
ffffffffc0201306:	6105                	addi	sp,sp,32
ffffffffc0201308:	8082                	ret
		return 0;
ffffffffc020130a:	4401                	li	s0,0
}
ffffffffc020130c:	60e2                	ld	ra,24(sp)
ffffffffc020130e:	8522                	mv	a0,s0
ffffffffc0201310:	6442                	ld	s0,16(sp)
ffffffffc0201312:	64a2                	ld	s1,8(sp)
ffffffffc0201314:	6105                	addi	sp,sp,32
ffffffffc0201316:	8082                	ret
	obj_free(bb, sizeof(bigblock_t));
ffffffffc0201318:	8526                	mv	a0,s1
ffffffffc020131a:	02000593          	li	a1,32
ffffffffc020131e:	e71ff0ef          	jal	ra,ffffffffc020118e <obj_free>
}
ffffffffc0201322:	60e2                	ld	ra,24(sp)
ffffffffc0201324:	8522                	mv	a0,s0
ffffffffc0201326:	6442                	ld	s0,16(sp)
ffffffffc0201328:	64a2                	ld	s1,8(sp)
ffffffffc020132a:	6105                	addi	sp,sp,32
ffffffffc020132c:	8082                	ret

ffffffffc020132e <slub_free>:
{
    // bb用于遍历记录大块内存的链表。
    // last用于指向链表中前一个节点的next指针
	bigblock_t *bb, **last = &bigblocks_head;

	if (!block)
ffffffffc020132e:	c531                	beqz	a0,ffffffffc020137a <slub_free+0x4c>
{
ffffffffc0201330:	1141                	addi	sp,sp,-16
    //         }
    //     }
    // }

	/* 遍历大块链表 */
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc0201332:	00005717          	auipc	a4,0x5
ffffffffc0201336:	17670713          	addi	a4,a4,374 # ffffffffc02064a8 <bigblocks_head>
{
ffffffffc020133a:	e022                	sd	s0,0(sp)
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc020133c:	6300                	ld	s0,0(a4)
{
ffffffffc020133e:	e406                	sd	ra,8(sp)
    for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc0201340:	e411                	bnez	s0,ffffffffc020134c <slub_free+0x1e>
ffffffffc0201342:	a035                	j	ffffffffc020136e <slub_free+0x40>
ffffffffc0201344:	01040713          	addi	a4,s0,16
ffffffffc0201348:	6800                	ld	s0,16(s0)
ffffffffc020134a:	c015                	beqz	s0,ffffffffc020136e <slub_free+0x40>
        if (bb->pages == block && bb->is_bigblock) {
ffffffffc020134c:	641c                	ld	a5,8(s0)
ffffffffc020134e:	fea79be3          	bne	a5,a0,ffffffffc0201344 <slub_free+0x16>
ffffffffc0201352:	4c1c                	lw	a5,24(s0)
ffffffffc0201354:	dbe5                	beqz	a5,ffffffffc0201344 <slub_free+0x16>
            // 确认是大块
            *last = bb->next;  // 从链表中移除当前节点
ffffffffc0201356:	681c                	ld	a5,16(s0)
			// call pmm->free_pages to free a continuous n*PAGESIZE memory
            free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc0201358:	400c                	lw	a1,0(s0)
            *last = bb->next;  // 从链表中移除当前节点
ffffffffc020135a:	e31c                	sd	a5,0(a4)
            free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc020135c:	c5fff0ef          	jal	ra,ffffffffc0200fba <free_pages>
            obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc0201360:	8522                	mv	a0,s0
    }


	obj_free((obj_t *)block - 1, 0);
	return;
}
ffffffffc0201362:	6402                	ld	s0,0(sp)
ffffffffc0201364:	60a2                	ld	ra,8(sp)
            obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc0201366:	02000593          	li	a1,32
}
ffffffffc020136a:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc020136c:	b50d                	j	ffffffffc020118e <obj_free>
}
ffffffffc020136e:	6402                	ld	s0,0(sp)
ffffffffc0201370:	60a2                	ld	ra,8(sp)
	obj_free((obj_t *)block - 1, 0);
ffffffffc0201372:	4581                	li	a1,0
ffffffffc0201374:	1541                	addi	a0,a0,-16
}
ffffffffc0201376:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc0201378:	bd19                	j	ffffffffc020118e <obj_free>
ffffffffc020137a:	8082                	ret

ffffffffc020137c <slub_init>:

void slub_init(void) {
    cprintf("slub_init() succeeded!\n");
ffffffffc020137c:	00001517          	auipc	a0,0x1
ffffffffc0201380:	17450513          	addi	a0,a0,372 # ffffffffc02024f0 <buddy_pmm_manager+0x188>
ffffffffc0201384:	d37fe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201388 <print_objs>:
}

// 输出object链表信息
void print_objs(){
ffffffffc0201388:	7179                	addi	sp,sp,-48
ffffffffc020138a:	e84a                	sd	s2,16(sp)
	int object_count = 0;
	cprintf("objsizes: ");
ffffffffc020138c:	00001517          	auipc	a0,0x1
ffffffffc0201390:	17c50513          	addi	a0,a0,380 # ffffffffc0202508 <buddy_pmm_manager+0x1a0>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc0201394:	00005917          	auipc	s2,0x5
ffffffffc0201398:	c6c90913          	addi	s2,s2,-916 # ffffffffc0206000 <arena>
void print_objs(){
ffffffffc020139c:	f022                	sd	s0,32(sp)
ffffffffc020139e:	ec26                	sd	s1,24(sp)
ffffffffc02013a0:	f406                	sd	ra,40(sp)
ffffffffc02013a2:	e44e                	sd	s3,8(sp)
	cprintf("objsizes: ");
ffffffffc02013a4:	d17fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc02013a8:	00893403          	ld	s0,8(s2)
	int object_count = 0;
ffffffffc02013ac:	4481                	li	s1,0
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc02013ae:	01240e63          	beq	s0,s2,ffffffffc02013ca <print_objs+0x42>
		cprintf("%d ", curr->objsize);
ffffffffc02013b2:	00001997          	auipc	s3,0x1
ffffffffc02013b6:	16698993          	addi	s3,s3,358 # ffffffffc0202518 <buddy_pmm_manager+0x1b0>
ffffffffc02013ba:	400c                	lw	a1,0(s0)
ffffffffc02013bc:	854e                	mv	a0,s3
		object_count ++;
ffffffffc02013be:	2485                	addiw	s1,s1,1
		cprintf("%d ", curr->objsize);
ffffffffc02013c0:	cfbfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = arena.next; curr != &arena; curr = curr->next){
ffffffffc02013c4:	6400                	ld	s0,8(s0)
ffffffffc02013c6:	ff241ae3          	bne	s0,s2,ffffffffc02013ba <print_objs+0x32>
	}    
	cprintf("Total number of objs: %d\n", object_count);
ffffffffc02013ca:	85a6                	mv	a1,s1
ffffffffc02013cc:	00001517          	auipc	a0,0x1
ffffffffc02013d0:	15450513          	addi	a0,a0,340 # ffffffffc0202520 <buddy_pmm_manager+0x1b8>
ffffffffc02013d4:	ce7fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	cprintf("\n");
}
ffffffffc02013d8:	7402                	ld	s0,32(sp)
ffffffffc02013da:	70a2                	ld	ra,40(sp)
ffffffffc02013dc:	64e2                	ld	s1,24(sp)
ffffffffc02013de:	6942                	ld	s2,16(sp)
ffffffffc02013e0:	69a2                	ld	s3,8(sp)
	cprintf("\n");
ffffffffc02013e2:	00001517          	auipc	a0,0x1
ffffffffc02013e6:	1ce50513          	addi	a0,a0,462 # ffffffffc02025b0 <buddy_pmm_manager+0x248>
}
ffffffffc02013ea:	6145                	addi	sp,sp,48
	cprintf("\n");
ffffffffc02013ec:	ccffe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc02013f0 <slub_check>:

    
void slub_check()
{
ffffffffc02013f0:	1101                	addi	sp,sp,-32
    cprintf("slub check begin\n");
ffffffffc02013f2:	00001517          	auipc	a0,0x1
ffffffffc02013f6:	14e50513          	addi	a0,a0,334 # ffffffffc0202540 <buddy_pmm_manager+0x1d8>
{
ffffffffc02013fa:	ec06                	sd	ra,24(sp)
ffffffffc02013fc:	e822                	sd	s0,16(sp)
ffffffffc02013fe:	e426                	sd	s1,8(sp)
    cprintf("slub check begin\n");
ffffffffc0201400:	cbbfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_objs();
ffffffffc0201404:	f85ff0ef          	jal	ra,ffffffffc0201388 <print_objs>


    cprintf("alloc test start:\n");
ffffffffc0201408:	00001517          	auipc	a0,0x1
ffffffffc020140c:	15050513          	addi	a0,a0,336 # ffffffffc0202558 <buddy_pmm_manager+0x1f0>
ffffffffc0201410:	cabfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    // 测试申请
	cprintf("p1 alloc 4096\n");
ffffffffc0201414:	00001517          	auipc	a0,0x1
ffffffffc0201418:	15c50513          	addi	a0,a0,348 # ffffffffc0202570 <buddy_pmm_manager+0x208>
ffffffffc020141c:	c9ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	if (size < PGSIZE - OBJ_UNIT) {
ffffffffc0201420:	6505                	lui	a0,0x1
ffffffffc0201422:	e9fff0ef          	jal	ra,ffffffffc02012c0 <slub_alloc.part.0>
ffffffffc0201426:	84aa                	mv	s1,a0
	void* p1 = slub_alloc(4096);
	print_objs();
ffffffffc0201428:	f61ff0ef          	jal	ra,ffffffffc0201388 <print_objs>

	cprintf("p2 alloc 2\n");
ffffffffc020142c:	00001517          	auipc	a0,0x1
ffffffffc0201430:	15450513          	addi	a0,a0,340 # ffffffffc0202580 <buddy_pmm_manager+0x218>
ffffffffc0201434:	c87fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc0201438:	4549                	li	a0,18
ffffffffc020143a:	dd5ff0ef          	jal	ra,ffffffffc020120e <obj_alloc>
    void* p2 = slub_alloc(2);
	print_objs();
ffffffffc020143e:	f4bff0ef          	jal	ra,ffffffffc0201388 <print_objs>

	cprintf("p3 alloc 32\n");
ffffffffc0201442:	00001517          	auipc	a0,0x1
ffffffffc0201446:	14e50513          	addi	a0,a0,334 # ffffffffc0202590 <buddy_pmm_manager+0x228>
ffffffffc020144a:	c71fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc020144e:	03000513          	li	a0,48
ffffffffc0201452:	dbdff0ef          	jal	ra,ffffffffc020120e <obj_alloc>
ffffffffc0201456:	842a                	mv	s0,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201458:	c119                	beqz	a0,ffffffffc020145e <slub_check+0x6e>
ffffffffc020145a:	01050413          	addi	s0,a0,16
    void* p3 = slub_alloc(32);
    print_objs();
ffffffffc020145e:	f2bff0ef          	jal	ra,ffffffffc0201388 <print_objs>

    
	cprintf("free test start:\n");
ffffffffc0201462:	00001517          	auipc	a0,0x1
ffffffffc0201466:	13e50513          	addi	a0,a0,318 # ffffffffc02025a0 <buddy_pmm_manager+0x238>
ffffffffc020146a:	c51fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	// 测试释放
    cprintf("free p1\n");
ffffffffc020146e:	00001517          	auipc	a0,0x1
ffffffffc0201472:	14a50513          	addi	a0,a0,330 # ffffffffc02025b8 <buddy_pmm_manager+0x250>
ffffffffc0201476:	c45fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p1);
ffffffffc020147a:	8526                	mv	a0,s1
ffffffffc020147c:	eb3ff0ef          	jal	ra,ffffffffc020132e <slub_free>
    print_objs();
ffffffffc0201480:	f09ff0ef          	jal	ra,ffffffffc0201388 <print_objs>

	cprintf("free p3\n");
ffffffffc0201484:	00001517          	auipc	a0,0x1
ffffffffc0201488:	14450513          	addi	a0,a0,324 # ffffffffc02025c8 <buddy_pmm_manager+0x260>
ffffffffc020148c:	c2ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p3);
ffffffffc0201490:	8522                	mv	a0,s0
ffffffffc0201492:	e9dff0ef          	jal	ra,ffffffffc020132e <slub_free>
    print_objs();
ffffffffc0201496:	ef3ff0ef          	jal	ra,ffffffffc0201388 <print_objs>

    cprintf("slub check end\n");
ffffffffc020149a:	6442                	ld	s0,16(sp)
ffffffffc020149c:	60e2                	ld	ra,24(sp)
ffffffffc020149e:	64a2                	ld	s1,8(sp)
    cprintf("slub check end\n");
ffffffffc02014a0:	00001517          	auipc	a0,0x1
ffffffffc02014a4:	13850513          	addi	a0,a0,312 # ffffffffc02025d8 <buddy_pmm_manager+0x270>
ffffffffc02014a8:	6105                	addi	sp,sp,32
    cprintf("slub check end\n");
ffffffffc02014aa:	c11fe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc02014ae <printnum>:
ffffffffc02014ae:	02069813          	slli	a6,a3,0x20
ffffffffc02014b2:	7179                	addi	sp,sp,-48
ffffffffc02014b4:	02085813          	srli	a6,a6,0x20
ffffffffc02014b8:	e052                	sd	s4,0(sp)
ffffffffc02014ba:	03067a33          	remu	s4,a2,a6
ffffffffc02014be:	f022                	sd	s0,32(sp)
ffffffffc02014c0:	ec26                	sd	s1,24(sp)
ffffffffc02014c2:	e84a                	sd	s2,16(sp)
ffffffffc02014c4:	f406                	sd	ra,40(sp)
ffffffffc02014c6:	e44e                	sd	s3,8(sp)
ffffffffc02014c8:	84aa                	mv	s1,a0
ffffffffc02014ca:	892e                	mv	s2,a1
ffffffffc02014cc:	fff7041b          	addiw	s0,a4,-1
ffffffffc02014d0:	2a01                	sext.w	s4,s4
ffffffffc02014d2:	03067e63          	bgeu	a2,a6,ffffffffc020150e <printnum+0x60>
ffffffffc02014d6:	89be                	mv	s3,a5
ffffffffc02014d8:	00805763          	blez	s0,ffffffffc02014e6 <printnum+0x38>
ffffffffc02014dc:	347d                	addiw	s0,s0,-1
ffffffffc02014de:	85ca                	mv	a1,s2
ffffffffc02014e0:	854e                	mv	a0,s3
ffffffffc02014e2:	9482                	jalr	s1
ffffffffc02014e4:	fc65                	bnez	s0,ffffffffc02014dc <printnum+0x2e>
ffffffffc02014e6:	1a02                	slli	s4,s4,0x20
ffffffffc02014e8:	00001797          	auipc	a5,0x1
ffffffffc02014ec:	10078793          	addi	a5,a5,256 # ffffffffc02025e8 <buddy_pmm_manager+0x280>
ffffffffc02014f0:	020a5a13          	srli	s4,s4,0x20
ffffffffc02014f4:	9a3e                	add	s4,s4,a5
ffffffffc02014f6:	7402                	ld	s0,32(sp)
ffffffffc02014f8:	000a4503          	lbu	a0,0(s4)
ffffffffc02014fc:	70a2                	ld	ra,40(sp)
ffffffffc02014fe:	69a2                	ld	s3,8(sp)
ffffffffc0201500:	6a02                	ld	s4,0(sp)
ffffffffc0201502:	85ca                	mv	a1,s2
ffffffffc0201504:	87a6                	mv	a5,s1
ffffffffc0201506:	6942                	ld	s2,16(sp)
ffffffffc0201508:	64e2                	ld	s1,24(sp)
ffffffffc020150a:	6145                	addi	sp,sp,48
ffffffffc020150c:	8782                	jr	a5
ffffffffc020150e:	03065633          	divu	a2,a2,a6
ffffffffc0201512:	8722                	mv	a4,s0
ffffffffc0201514:	f9bff0ef          	jal	ra,ffffffffc02014ae <printnum>
ffffffffc0201518:	b7f9                	j	ffffffffc02014e6 <printnum+0x38>

ffffffffc020151a <vprintfmt>:
ffffffffc020151a:	7119                	addi	sp,sp,-128
ffffffffc020151c:	f4a6                	sd	s1,104(sp)
ffffffffc020151e:	f0ca                	sd	s2,96(sp)
ffffffffc0201520:	ecce                	sd	s3,88(sp)
ffffffffc0201522:	e8d2                	sd	s4,80(sp)
ffffffffc0201524:	e4d6                	sd	s5,72(sp)
ffffffffc0201526:	e0da                	sd	s6,64(sp)
ffffffffc0201528:	fc5e                	sd	s7,56(sp)
ffffffffc020152a:	f06a                	sd	s10,32(sp)
ffffffffc020152c:	fc86                	sd	ra,120(sp)
ffffffffc020152e:	f8a2                	sd	s0,112(sp)
ffffffffc0201530:	f862                	sd	s8,48(sp)
ffffffffc0201532:	f466                	sd	s9,40(sp)
ffffffffc0201534:	ec6e                	sd	s11,24(sp)
ffffffffc0201536:	892a                	mv	s2,a0
ffffffffc0201538:	84ae                	mv	s1,a1
ffffffffc020153a:	8d32                	mv	s10,a2
ffffffffc020153c:	8a36                	mv	s4,a3
ffffffffc020153e:	02500993          	li	s3,37
ffffffffc0201542:	5b7d                	li	s6,-1
ffffffffc0201544:	00001a97          	auipc	s5,0x1
ffffffffc0201548:	0d8a8a93          	addi	s5,s5,216 # ffffffffc020261c <buddy_pmm_manager+0x2b4>
ffffffffc020154c:	00001b97          	auipc	s7,0x1
ffffffffc0201550:	2acb8b93          	addi	s7,s7,684 # ffffffffc02027f8 <error_string>
ffffffffc0201554:	000d4503          	lbu	a0,0(s10)
ffffffffc0201558:	001d0413          	addi	s0,s10,1
ffffffffc020155c:	01350a63          	beq	a0,s3,ffffffffc0201570 <vprintfmt+0x56>
ffffffffc0201560:	c121                	beqz	a0,ffffffffc02015a0 <vprintfmt+0x86>
ffffffffc0201562:	85a6                	mv	a1,s1
ffffffffc0201564:	0405                	addi	s0,s0,1
ffffffffc0201566:	9902                	jalr	s2
ffffffffc0201568:	fff44503          	lbu	a0,-1(s0)
ffffffffc020156c:	ff351ae3          	bne	a0,s3,ffffffffc0201560 <vprintfmt+0x46>
ffffffffc0201570:	00044603          	lbu	a2,0(s0)
ffffffffc0201574:	02000793          	li	a5,32
ffffffffc0201578:	4c81                	li	s9,0
ffffffffc020157a:	4881                	li	a7,0
ffffffffc020157c:	5c7d                	li	s8,-1
ffffffffc020157e:	5dfd                	li	s11,-1
ffffffffc0201580:	05500513          	li	a0,85
ffffffffc0201584:	4825                	li	a6,9
ffffffffc0201586:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020158a:	0ff5f593          	andi	a1,a1,255
ffffffffc020158e:	00140d13          	addi	s10,s0,1
ffffffffc0201592:	04b56263          	bltu	a0,a1,ffffffffc02015d6 <vprintfmt+0xbc>
ffffffffc0201596:	058a                	slli	a1,a1,0x2
ffffffffc0201598:	95d6                	add	a1,a1,s5
ffffffffc020159a:	4194                	lw	a3,0(a1)
ffffffffc020159c:	96d6                	add	a3,a3,s5
ffffffffc020159e:	8682                	jr	a3
ffffffffc02015a0:	70e6                	ld	ra,120(sp)
ffffffffc02015a2:	7446                	ld	s0,112(sp)
ffffffffc02015a4:	74a6                	ld	s1,104(sp)
ffffffffc02015a6:	7906                	ld	s2,96(sp)
ffffffffc02015a8:	69e6                	ld	s3,88(sp)
ffffffffc02015aa:	6a46                	ld	s4,80(sp)
ffffffffc02015ac:	6aa6                	ld	s5,72(sp)
ffffffffc02015ae:	6b06                	ld	s6,64(sp)
ffffffffc02015b0:	7be2                	ld	s7,56(sp)
ffffffffc02015b2:	7c42                	ld	s8,48(sp)
ffffffffc02015b4:	7ca2                	ld	s9,40(sp)
ffffffffc02015b6:	7d02                	ld	s10,32(sp)
ffffffffc02015b8:	6de2                	ld	s11,24(sp)
ffffffffc02015ba:	6109                	addi	sp,sp,128
ffffffffc02015bc:	8082                	ret
ffffffffc02015be:	87b2                	mv	a5,a2
ffffffffc02015c0:	00144603          	lbu	a2,1(s0)
ffffffffc02015c4:	846a                	mv	s0,s10
ffffffffc02015c6:	00140d13          	addi	s10,s0,1
ffffffffc02015ca:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02015ce:	0ff5f593          	andi	a1,a1,255
ffffffffc02015d2:	fcb572e3          	bgeu	a0,a1,ffffffffc0201596 <vprintfmt+0x7c>
ffffffffc02015d6:	85a6                	mv	a1,s1
ffffffffc02015d8:	02500513          	li	a0,37
ffffffffc02015dc:	9902                	jalr	s2
ffffffffc02015de:	fff44783          	lbu	a5,-1(s0)
ffffffffc02015e2:	8d22                	mv	s10,s0
ffffffffc02015e4:	f73788e3          	beq	a5,s3,ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc02015e8:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02015ec:	1d7d                	addi	s10,s10,-1
ffffffffc02015ee:	ff379de3          	bne	a5,s3,ffffffffc02015e8 <vprintfmt+0xce>
ffffffffc02015f2:	b78d                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc02015f4:	fd060c1b          	addiw	s8,a2,-48
ffffffffc02015f8:	00144603          	lbu	a2,1(s0)
ffffffffc02015fc:	846a                	mv	s0,s10
ffffffffc02015fe:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201602:	0006059b          	sext.w	a1,a2
ffffffffc0201606:	02d86463          	bltu	a6,a3,ffffffffc020162e <vprintfmt+0x114>
ffffffffc020160a:	00144603          	lbu	a2,1(s0)
ffffffffc020160e:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201612:	0186873b          	addw	a4,a3,s8
ffffffffc0201616:	0017171b          	slliw	a4,a4,0x1
ffffffffc020161a:	9f2d                	addw	a4,a4,a1
ffffffffc020161c:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201620:	0405                	addi	s0,s0,1
ffffffffc0201622:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0201626:	0006059b          	sext.w	a1,a2
ffffffffc020162a:	fed870e3          	bgeu	a6,a3,ffffffffc020160a <vprintfmt+0xf0>
ffffffffc020162e:	f40ddce3          	bgez	s11,ffffffffc0201586 <vprintfmt+0x6c>
ffffffffc0201632:	8de2                	mv	s11,s8
ffffffffc0201634:	5c7d                	li	s8,-1
ffffffffc0201636:	bf81                	j	ffffffffc0201586 <vprintfmt+0x6c>
ffffffffc0201638:	fffdc693          	not	a3,s11
ffffffffc020163c:	96fd                	srai	a3,a3,0x3f
ffffffffc020163e:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201642:	00144603          	lbu	a2,1(s0)
ffffffffc0201646:	2d81                	sext.w	s11,s11
ffffffffc0201648:	846a                	mv	s0,s10
ffffffffc020164a:	bf35                	j	ffffffffc0201586 <vprintfmt+0x6c>
ffffffffc020164c:	000a2c03          	lw	s8,0(s4)
ffffffffc0201650:	00144603          	lbu	a2,1(s0)
ffffffffc0201654:	0a21                	addi	s4,s4,8
ffffffffc0201656:	846a                	mv	s0,s10
ffffffffc0201658:	bfd9                	j	ffffffffc020162e <vprintfmt+0x114>
ffffffffc020165a:	4705                	li	a4,1
ffffffffc020165c:	008a0593          	addi	a1,s4,8
ffffffffc0201660:	01174463          	blt	a4,a7,ffffffffc0201668 <vprintfmt+0x14e>
ffffffffc0201664:	1a088e63          	beqz	a7,ffffffffc0201820 <vprintfmt+0x306>
ffffffffc0201668:	000a3603          	ld	a2,0(s4)
ffffffffc020166c:	46c1                	li	a3,16
ffffffffc020166e:	8a2e                	mv	s4,a1
ffffffffc0201670:	2781                	sext.w	a5,a5
ffffffffc0201672:	876e                	mv	a4,s11
ffffffffc0201674:	85a6                	mv	a1,s1
ffffffffc0201676:	854a                	mv	a0,s2
ffffffffc0201678:	e37ff0ef          	jal	ra,ffffffffc02014ae <printnum>
ffffffffc020167c:	bde1                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc020167e:	000a2503          	lw	a0,0(s4)
ffffffffc0201682:	85a6                	mv	a1,s1
ffffffffc0201684:	0a21                	addi	s4,s4,8
ffffffffc0201686:	9902                	jalr	s2
ffffffffc0201688:	b5f1                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc020168a:	4705                	li	a4,1
ffffffffc020168c:	008a0593          	addi	a1,s4,8
ffffffffc0201690:	01174463          	blt	a4,a7,ffffffffc0201698 <vprintfmt+0x17e>
ffffffffc0201694:	18088163          	beqz	a7,ffffffffc0201816 <vprintfmt+0x2fc>
ffffffffc0201698:	000a3603          	ld	a2,0(s4)
ffffffffc020169c:	46a9                	li	a3,10
ffffffffc020169e:	8a2e                	mv	s4,a1
ffffffffc02016a0:	bfc1                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc02016a2:	00144603          	lbu	a2,1(s0)
ffffffffc02016a6:	4c85                	li	s9,1
ffffffffc02016a8:	846a                	mv	s0,s10
ffffffffc02016aa:	bdf1                	j	ffffffffc0201586 <vprintfmt+0x6c>
ffffffffc02016ac:	85a6                	mv	a1,s1
ffffffffc02016ae:	02500513          	li	a0,37
ffffffffc02016b2:	9902                	jalr	s2
ffffffffc02016b4:	b545                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc02016b6:	00144603          	lbu	a2,1(s0)
ffffffffc02016ba:	2885                	addiw	a7,a7,1
ffffffffc02016bc:	846a                	mv	s0,s10
ffffffffc02016be:	b5e1                	j	ffffffffc0201586 <vprintfmt+0x6c>
ffffffffc02016c0:	4705                	li	a4,1
ffffffffc02016c2:	008a0593          	addi	a1,s4,8
ffffffffc02016c6:	01174463          	blt	a4,a7,ffffffffc02016ce <vprintfmt+0x1b4>
ffffffffc02016ca:	14088163          	beqz	a7,ffffffffc020180c <vprintfmt+0x2f2>
ffffffffc02016ce:	000a3603          	ld	a2,0(s4)
ffffffffc02016d2:	46a1                	li	a3,8
ffffffffc02016d4:	8a2e                	mv	s4,a1
ffffffffc02016d6:	bf69                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc02016d8:	03000513          	li	a0,48
ffffffffc02016dc:	85a6                	mv	a1,s1
ffffffffc02016de:	e03e                	sd	a5,0(sp)
ffffffffc02016e0:	9902                	jalr	s2
ffffffffc02016e2:	85a6                	mv	a1,s1
ffffffffc02016e4:	07800513          	li	a0,120
ffffffffc02016e8:	9902                	jalr	s2
ffffffffc02016ea:	0a21                	addi	s4,s4,8
ffffffffc02016ec:	6782                	ld	a5,0(sp)
ffffffffc02016ee:	46c1                	li	a3,16
ffffffffc02016f0:	ff8a3603          	ld	a2,-8(s4)
ffffffffc02016f4:	bfb5                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc02016f6:	000a3403          	ld	s0,0(s4)
ffffffffc02016fa:	008a0713          	addi	a4,s4,8
ffffffffc02016fe:	e03a                	sd	a4,0(sp)
ffffffffc0201700:	14040263          	beqz	s0,ffffffffc0201844 <vprintfmt+0x32a>
ffffffffc0201704:	0fb05763          	blez	s11,ffffffffc02017f2 <vprintfmt+0x2d8>
ffffffffc0201708:	02d00693          	li	a3,45
ffffffffc020170c:	0cd79163          	bne	a5,a3,ffffffffc02017ce <vprintfmt+0x2b4>
ffffffffc0201710:	00044783          	lbu	a5,0(s0)
ffffffffc0201714:	0007851b          	sext.w	a0,a5
ffffffffc0201718:	cf85                	beqz	a5,ffffffffc0201750 <vprintfmt+0x236>
ffffffffc020171a:	00140a13          	addi	s4,s0,1
ffffffffc020171e:	05e00413          	li	s0,94
ffffffffc0201722:	000c4563          	bltz	s8,ffffffffc020172c <vprintfmt+0x212>
ffffffffc0201726:	3c7d                	addiw	s8,s8,-1
ffffffffc0201728:	036c0263          	beq	s8,s6,ffffffffc020174c <vprintfmt+0x232>
ffffffffc020172c:	85a6                	mv	a1,s1
ffffffffc020172e:	0e0c8e63          	beqz	s9,ffffffffc020182a <vprintfmt+0x310>
ffffffffc0201732:	3781                	addiw	a5,a5,-32
ffffffffc0201734:	0ef47b63          	bgeu	s0,a5,ffffffffc020182a <vprintfmt+0x310>
ffffffffc0201738:	03f00513          	li	a0,63
ffffffffc020173c:	9902                	jalr	s2
ffffffffc020173e:	000a4783          	lbu	a5,0(s4)
ffffffffc0201742:	3dfd                	addiw	s11,s11,-1
ffffffffc0201744:	0a05                	addi	s4,s4,1
ffffffffc0201746:	0007851b          	sext.w	a0,a5
ffffffffc020174a:	ffe1                	bnez	a5,ffffffffc0201722 <vprintfmt+0x208>
ffffffffc020174c:	01b05963          	blez	s11,ffffffffc020175e <vprintfmt+0x244>
ffffffffc0201750:	3dfd                	addiw	s11,s11,-1
ffffffffc0201752:	85a6                	mv	a1,s1
ffffffffc0201754:	02000513          	li	a0,32
ffffffffc0201758:	9902                	jalr	s2
ffffffffc020175a:	fe0d9be3          	bnez	s11,ffffffffc0201750 <vprintfmt+0x236>
ffffffffc020175e:	6a02                	ld	s4,0(sp)
ffffffffc0201760:	bbd5                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc0201762:	4705                	li	a4,1
ffffffffc0201764:	008a0c93          	addi	s9,s4,8
ffffffffc0201768:	01174463          	blt	a4,a7,ffffffffc0201770 <vprintfmt+0x256>
ffffffffc020176c:	08088d63          	beqz	a7,ffffffffc0201806 <vprintfmt+0x2ec>
ffffffffc0201770:	000a3403          	ld	s0,0(s4)
ffffffffc0201774:	0a044d63          	bltz	s0,ffffffffc020182e <vprintfmt+0x314>
ffffffffc0201778:	8622                	mv	a2,s0
ffffffffc020177a:	8a66                	mv	s4,s9
ffffffffc020177c:	46a9                	li	a3,10
ffffffffc020177e:	bdcd                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc0201780:	000a2783          	lw	a5,0(s4)
ffffffffc0201784:	4719                	li	a4,6
ffffffffc0201786:	0a21                	addi	s4,s4,8
ffffffffc0201788:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020178c:	8fb5                	xor	a5,a5,a3
ffffffffc020178e:	40d786bb          	subw	a3,a5,a3
ffffffffc0201792:	02d74163          	blt	a4,a3,ffffffffc02017b4 <vprintfmt+0x29a>
ffffffffc0201796:	00369793          	slli	a5,a3,0x3
ffffffffc020179a:	97de                	add	a5,a5,s7
ffffffffc020179c:	639c                	ld	a5,0(a5)
ffffffffc020179e:	cb99                	beqz	a5,ffffffffc02017b4 <vprintfmt+0x29a>
ffffffffc02017a0:	86be                	mv	a3,a5
ffffffffc02017a2:	00001617          	auipc	a2,0x1
ffffffffc02017a6:	e7660613          	addi	a2,a2,-394 # ffffffffc0202618 <buddy_pmm_manager+0x2b0>
ffffffffc02017aa:	85a6                	mv	a1,s1
ffffffffc02017ac:	854a                	mv	a0,s2
ffffffffc02017ae:	0ce000ef          	jal	ra,ffffffffc020187c <printfmt>
ffffffffc02017b2:	b34d                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc02017b4:	00001617          	auipc	a2,0x1
ffffffffc02017b8:	e5460613          	addi	a2,a2,-428 # ffffffffc0202608 <buddy_pmm_manager+0x2a0>
ffffffffc02017bc:	85a6                	mv	a1,s1
ffffffffc02017be:	854a                	mv	a0,s2
ffffffffc02017c0:	0bc000ef          	jal	ra,ffffffffc020187c <printfmt>
ffffffffc02017c4:	bb41                	j	ffffffffc0201554 <vprintfmt+0x3a>
ffffffffc02017c6:	00001417          	auipc	s0,0x1
ffffffffc02017ca:	e3a40413          	addi	s0,s0,-454 # ffffffffc0202600 <buddy_pmm_manager+0x298>
ffffffffc02017ce:	85e2                	mv	a1,s8
ffffffffc02017d0:	8522                	mv	a0,s0
ffffffffc02017d2:	e43e                	sd	a5,8(sp)
ffffffffc02017d4:	1e6000ef          	jal	ra,ffffffffc02019ba <strnlen>
ffffffffc02017d8:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02017dc:	01b05b63          	blez	s11,ffffffffc02017f2 <vprintfmt+0x2d8>
ffffffffc02017e0:	67a2                	ld	a5,8(sp)
ffffffffc02017e2:	00078a1b          	sext.w	s4,a5
ffffffffc02017e6:	3dfd                	addiw	s11,s11,-1
ffffffffc02017e8:	85a6                	mv	a1,s1
ffffffffc02017ea:	8552                	mv	a0,s4
ffffffffc02017ec:	9902                	jalr	s2
ffffffffc02017ee:	fe0d9ce3          	bnez	s11,ffffffffc02017e6 <vprintfmt+0x2cc>
ffffffffc02017f2:	00044783          	lbu	a5,0(s0)
ffffffffc02017f6:	00140a13          	addi	s4,s0,1
ffffffffc02017fa:	0007851b          	sext.w	a0,a5
ffffffffc02017fe:	d3a5                	beqz	a5,ffffffffc020175e <vprintfmt+0x244>
ffffffffc0201800:	05e00413          	li	s0,94
ffffffffc0201804:	bf39                	j	ffffffffc0201722 <vprintfmt+0x208>
ffffffffc0201806:	000a2403          	lw	s0,0(s4)
ffffffffc020180a:	b7ad                	j	ffffffffc0201774 <vprintfmt+0x25a>
ffffffffc020180c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201810:	46a1                	li	a3,8
ffffffffc0201812:	8a2e                	mv	s4,a1
ffffffffc0201814:	bdb1                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc0201816:	000a6603          	lwu	a2,0(s4)
ffffffffc020181a:	46a9                	li	a3,10
ffffffffc020181c:	8a2e                	mv	s4,a1
ffffffffc020181e:	bd89                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc0201820:	000a6603          	lwu	a2,0(s4)
ffffffffc0201824:	46c1                	li	a3,16
ffffffffc0201826:	8a2e                	mv	s4,a1
ffffffffc0201828:	b5a1                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc020182a:	9902                	jalr	s2
ffffffffc020182c:	bf09                	j	ffffffffc020173e <vprintfmt+0x224>
ffffffffc020182e:	85a6                	mv	a1,s1
ffffffffc0201830:	02d00513          	li	a0,45
ffffffffc0201834:	e03e                	sd	a5,0(sp)
ffffffffc0201836:	9902                	jalr	s2
ffffffffc0201838:	6782                	ld	a5,0(sp)
ffffffffc020183a:	8a66                	mv	s4,s9
ffffffffc020183c:	40800633          	neg	a2,s0
ffffffffc0201840:	46a9                	li	a3,10
ffffffffc0201842:	b53d                	j	ffffffffc0201670 <vprintfmt+0x156>
ffffffffc0201844:	03b05163          	blez	s11,ffffffffc0201866 <vprintfmt+0x34c>
ffffffffc0201848:	02d00693          	li	a3,45
ffffffffc020184c:	f6d79de3          	bne	a5,a3,ffffffffc02017c6 <vprintfmt+0x2ac>
ffffffffc0201850:	00001417          	auipc	s0,0x1
ffffffffc0201854:	db040413          	addi	s0,s0,-592 # ffffffffc0202600 <buddy_pmm_manager+0x298>
ffffffffc0201858:	02800793          	li	a5,40
ffffffffc020185c:	02800513          	li	a0,40
ffffffffc0201860:	00140a13          	addi	s4,s0,1
ffffffffc0201864:	bd6d                	j	ffffffffc020171e <vprintfmt+0x204>
ffffffffc0201866:	00001a17          	auipc	s4,0x1
ffffffffc020186a:	d9ba0a13          	addi	s4,s4,-613 # ffffffffc0202601 <buddy_pmm_manager+0x299>
ffffffffc020186e:	02800513          	li	a0,40
ffffffffc0201872:	02800793          	li	a5,40
ffffffffc0201876:	05e00413          	li	s0,94
ffffffffc020187a:	b565                	j	ffffffffc0201722 <vprintfmt+0x208>

ffffffffc020187c <printfmt>:
ffffffffc020187c:	715d                	addi	sp,sp,-80
ffffffffc020187e:	02810313          	addi	t1,sp,40
ffffffffc0201882:	f436                	sd	a3,40(sp)
ffffffffc0201884:	869a                	mv	a3,t1
ffffffffc0201886:	ec06                	sd	ra,24(sp)
ffffffffc0201888:	f83a                	sd	a4,48(sp)
ffffffffc020188a:	fc3e                	sd	a5,56(sp)
ffffffffc020188c:	e0c2                	sd	a6,64(sp)
ffffffffc020188e:	e4c6                	sd	a7,72(sp)
ffffffffc0201890:	e41a                	sd	t1,8(sp)
ffffffffc0201892:	c89ff0ef          	jal	ra,ffffffffc020151a <vprintfmt>
ffffffffc0201896:	60e2                	ld	ra,24(sp)
ffffffffc0201898:	6161                	addi	sp,sp,80
ffffffffc020189a:	8082                	ret

ffffffffc020189c <readline>:
ffffffffc020189c:	715d                	addi	sp,sp,-80
ffffffffc020189e:	e486                	sd	ra,72(sp)
ffffffffc02018a0:	e0a6                	sd	s1,64(sp)
ffffffffc02018a2:	fc4a                	sd	s2,56(sp)
ffffffffc02018a4:	f84e                	sd	s3,48(sp)
ffffffffc02018a6:	f452                	sd	s4,40(sp)
ffffffffc02018a8:	f056                	sd	s5,32(sp)
ffffffffc02018aa:	ec5a                	sd	s6,24(sp)
ffffffffc02018ac:	e85e                	sd	s7,16(sp)
ffffffffc02018ae:	c901                	beqz	a0,ffffffffc02018be <readline+0x22>
ffffffffc02018b0:	85aa                	mv	a1,a0
ffffffffc02018b2:	00001517          	auipc	a0,0x1
ffffffffc02018b6:	d6650513          	addi	a0,a0,-666 # ffffffffc0202618 <buddy_pmm_manager+0x2b0>
ffffffffc02018ba:	801fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02018be:	4481                	li	s1,0
ffffffffc02018c0:	497d                	li	s2,31
ffffffffc02018c2:	49a1                	li	s3,8
ffffffffc02018c4:	4aa9                	li	s5,10
ffffffffc02018c6:	4b35                	li	s6,13
ffffffffc02018c8:	00004b97          	auipc	s7,0x4
ffffffffc02018cc:	780b8b93          	addi	s7,s7,1920 # ffffffffc0206048 <buf>
ffffffffc02018d0:	3fe00a13          	li	s4,1022
ffffffffc02018d4:	85ffe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc02018d8:	00054a63          	bltz	a0,ffffffffc02018ec <readline+0x50>
ffffffffc02018dc:	00a95a63          	bge	s2,a0,ffffffffc02018f0 <readline+0x54>
ffffffffc02018e0:	029a5263          	bge	s4,s1,ffffffffc0201904 <readline+0x68>
ffffffffc02018e4:	84ffe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc02018e8:	fe055ae3          	bgez	a0,ffffffffc02018dc <readline+0x40>
ffffffffc02018ec:	4501                	li	a0,0
ffffffffc02018ee:	a091                	j	ffffffffc0201932 <readline+0x96>
ffffffffc02018f0:	03351463          	bne	a0,s3,ffffffffc0201918 <readline+0x7c>
ffffffffc02018f4:	e8a9                	bnez	s1,ffffffffc0201946 <readline+0xaa>
ffffffffc02018f6:	83dfe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc02018fa:	fe0549e3          	bltz	a0,ffffffffc02018ec <readline+0x50>
ffffffffc02018fe:	fea959e3          	bge	s2,a0,ffffffffc02018f0 <readline+0x54>
ffffffffc0201902:	4481                	li	s1,0
ffffffffc0201904:	e42a                	sd	a0,8(sp)
ffffffffc0201906:	feafe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc020190a:	6522                	ld	a0,8(sp)
ffffffffc020190c:	009b87b3          	add	a5,s7,s1
ffffffffc0201910:	2485                	addiw	s1,s1,1
ffffffffc0201912:	00a78023          	sb	a0,0(a5)
ffffffffc0201916:	bf7d                	j	ffffffffc02018d4 <readline+0x38>
ffffffffc0201918:	01550463          	beq	a0,s5,ffffffffc0201920 <readline+0x84>
ffffffffc020191c:	fb651ce3          	bne	a0,s6,ffffffffc02018d4 <readline+0x38>
ffffffffc0201920:	fd0fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201924:	00004517          	auipc	a0,0x4
ffffffffc0201928:	72450513          	addi	a0,a0,1828 # ffffffffc0206048 <buf>
ffffffffc020192c:	94aa                	add	s1,s1,a0
ffffffffc020192e:	00048023          	sb	zero,0(s1)
ffffffffc0201932:	60a6                	ld	ra,72(sp)
ffffffffc0201934:	6486                	ld	s1,64(sp)
ffffffffc0201936:	7962                	ld	s2,56(sp)
ffffffffc0201938:	79c2                	ld	s3,48(sp)
ffffffffc020193a:	7a22                	ld	s4,40(sp)
ffffffffc020193c:	7a82                	ld	s5,32(sp)
ffffffffc020193e:	6b62                	ld	s6,24(sp)
ffffffffc0201940:	6bc2                	ld	s7,16(sp)
ffffffffc0201942:	6161                	addi	sp,sp,80
ffffffffc0201944:	8082                	ret
ffffffffc0201946:	4521                	li	a0,8
ffffffffc0201948:	fa8fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc020194c:	34fd                	addiw	s1,s1,-1
ffffffffc020194e:	b759                	j	ffffffffc02018d4 <readline+0x38>

ffffffffc0201950 <sbi_console_putchar>:
ffffffffc0201950:	4781                	li	a5,0
ffffffffc0201952:	00004717          	auipc	a4,0x4
ffffffffc0201956:	6ce73703          	ld	a4,1742(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc020195a:	88ba                	mv	a7,a4
ffffffffc020195c:	852a                	mv	a0,a0
ffffffffc020195e:	85be                	mv	a1,a5
ffffffffc0201960:	863e                	mv	a2,a5
ffffffffc0201962:	00000073          	ecall
ffffffffc0201966:	87aa                	mv	a5,a0
ffffffffc0201968:	8082                	ret

ffffffffc020196a <sbi_set_timer>:
ffffffffc020196a:	4781                	li	a5,0
ffffffffc020196c:	00005717          	auipc	a4,0x5
ffffffffc0201970:	b4473703          	ld	a4,-1212(a4) # ffffffffc02064b0 <SBI_SET_TIMER>
ffffffffc0201974:	88ba                	mv	a7,a4
ffffffffc0201976:	852a                	mv	a0,a0
ffffffffc0201978:	85be                	mv	a1,a5
ffffffffc020197a:	863e                	mv	a2,a5
ffffffffc020197c:	00000073          	ecall
ffffffffc0201980:	87aa                	mv	a5,a0
ffffffffc0201982:	8082                	ret

ffffffffc0201984 <sbi_console_getchar>:
ffffffffc0201984:	4501                	li	a0,0
ffffffffc0201986:	00004797          	auipc	a5,0x4
ffffffffc020198a:	6927b783          	ld	a5,1682(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc020198e:	88be                	mv	a7,a5
ffffffffc0201990:	852a                	mv	a0,a0
ffffffffc0201992:	85aa                	mv	a1,a0
ffffffffc0201994:	862a                	mv	a2,a0
ffffffffc0201996:	00000073          	ecall
ffffffffc020199a:	852a                	mv	a0,a0
ffffffffc020199c:	2501                	sext.w	a0,a0
ffffffffc020199e:	8082                	ret

ffffffffc02019a0 <sbi_shutdown>:
ffffffffc02019a0:	4781                	li	a5,0
ffffffffc02019a2:	00004717          	auipc	a4,0x4
ffffffffc02019a6:	68673703          	ld	a4,1670(a4) # ffffffffc0206028 <SBI_SHUTDOWN>
ffffffffc02019aa:	88ba                	mv	a7,a4
ffffffffc02019ac:	853e                	mv	a0,a5
ffffffffc02019ae:	85be                	mv	a1,a5
ffffffffc02019b0:	863e                	mv	a2,a5
ffffffffc02019b2:	00000073          	ecall
ffffffffc02019b6:	87aa                	mv	a5,a0
ffffffffc02019b8:	8082                	ret

ffffffffc02019ba <strnlen>:
ffffffffc02019ba:	4781                	li	a5,0
ffffffffc02019bc:	e589                	bnez	a1,ffffffffc02019c6 <strnlen+0xc>
ffffffffc02019be:	a811                	j	ffffffffc02019d2 <strnlen+0x18>
ffffffffc02019c0:	0785                	addi	a5,a5,1
ffffffffc02019c2:	00f58863          	beq	a1,a5,ffffffffc02019d2 <strnlen+0x18>
ffffffffc02019c6:	00f50733          	add	a4,a0,a5
ffffffffc02019ca:	00074703          	lbu	a4,0(a4)
ffffffffc02019ce:	fb6d                	bnez	a4,ffffffffc02019c0 <strnlen+0x6>
ffffffffc02019d0:	85be                	mv	a1,a5
ffffffffc02019d2:	852e                	mv	a0,a1
ffffffffc02019d4:	8082                	ret

ffffffffc02019d6 <strcmp>:
ffffffffc02019d6:	00054783          	lbu	a5,0(a0)
ffffffffc02019da:	0005c703          	lbu	a4,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02019de:	cb89                	beqz	a5,ffffffffc02019f0 <strcmp+0x1a>
ffffffffc02019e0:	0505                	addi	a0,a0,1
ffffffffc02019e2:	0585                	addi	a1,a1,1
ffffffffc02019e4:	fee789e3          	beq	a5,a4,ffffffffc02019d6 <strcmp>
ffffffffc02019e8:	0007851b          	sext.w	a0,a5
ffffffffc02019ec:	9d19                	subw	a0,a0,a4
ffffffffc02019ee:	8082                	ret
ffffffffc02019f0:	4501                	li	a0,0
ffffffffc02019f2:	bfed                	j	ffffffffc02019ec <strcmp+0x16>

ffffffffc02019f4 <strchr>:
ffffffffc02019f4:	00054783          	lbu	a5,0(a0)
ffffffffc02019f8:	c799                	beqz	a5,ffffffffc0201a06 <strchr+0x12>
ffffffffc02019fa:	00f58763          	beq	a1,a5,ffffffffc0201a08 <strchr+0x14>
ffffffffc02019fe:	00154783          	lbu	a5,1(a0)
ffffffffc0201a02:	0505                	addi	a0,a0,1
ffffffffc0201a04:	fbfd                	bnez	a5,ffffffffc02019fa <strchr+0x6>
ffffffffc0201a06:	4501                	li	a0,0
ffffffffc0201a08:	8082                	ret

ffffffffc0201a0a <memset>:
ffffffffc0201a0a:	ca01                	beqz	a2,ffffffffc0201a1a <memset+0x10>
ffffffffc0201a0c:	962a                	add	a2,a2,a0
ffffffffc0201a0e:	87aa                	mv	a5,a0
ffffffffc0201a10:	0785                	addi	a5,a5,1
ffffffffc0201a12:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201a16:	fec79de3          	bne	a5,a2,ffffffffc0201a10 <memset+0x6>
ffffffffc0201a1a:	8082                	ret
