
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
ffffffffc020003e:	46660613          	addi	a2,a2,1126 # ffffffffc02064a0 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	553010ef          	jal	ra,ffffffffc0201d9c <memset>
    cons_init();  // init the console
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	d5e50513          	addi	a0,a0,-674 # ffffffffc0201db0 <etext+0x2>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>

    print_kerninfo();
ffffffffc020005e:	0e4000ef          	jal	ra,ffffffffc0200142 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	314010ef          	jal	ra,ffffffffc020137a <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>

    // check slub pmm
    slub_init();
ffffffffc0200076:	692010ef          	jal	ra,ffffffffc0201708 <slub_init>
    slub_check();
ffffffffc020007a:	708010ef          	jal	ra,ffffffffc0201782 <slub_check>

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
ffffffffc02000ae:	7fe010ef          	jal	ra,ffffffffc02018ac <vprintfmt>
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
ffffffffc02000e4:	7c8010ef          	jal	ra,ffffffffc02018ac <vprintfmt>
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
ffffffffc0200148:	c8c50513          	addi	a0,a0,-884 # ffffffffc0201dd0 <etext+0x22>
ffffffffc020014c:	e406                	sd	ra,8(sp)
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200152:	00000597          	auipc	a1,0x0
ffffffffc0200156:	ee058593          	addi	a1,a1,-288 # ffffffffc0200032 <kern_init>
ffffffffc020015a:	00002517          	auipc	a0,0x2
ffffffffc020015e:	c9650513          	addi	a0,a0,-874 # ffffffffc0201df0 <etext+0x42>
ffffffffc0200162:	f59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200166:	00002597          	auipc	a1,0x2
ffffffffc020016a:	c4858593          	addi	a1,a1,-952 # ffffffffc0201dae <etext>
ffffffffc020016e:	00002517          	auipc	a0,0x2
ffffffffc0200172:	ca250513          	addi	a0,a0,-862 # ffffffffc0201e10 <etext+0x62>
ffffffffc0200176:	f45ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020017a:	00006597          	auipc	a1,0x6
ffffffffc020017e:	eb658593          	addi	a1,a1,-330 # ffffffffc0206030 <free_area>
ffffffffc0200182:	00002517          	auipc	a0,0x2
ffffffffc0200186:	cae50513          	addi	a0,a0,-850 # ffffffffc0201e30 <etext+0x82>
ffffffffc020018a:	f31ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020018e:	00006597          	auipc	a1,0x6
ffffffffc0200192:	31258593          	addi	a1,a1,786 # ffffffffc02064a0 <end>
ffffffffc0200196:	00002517          	auipc	a0,0x2
ffffffffc020019a:	cba50513          	addi	a0,a0,-838 # ffffffffc0201e50 <etext+0xa2>
ffffffffc020019e:	f1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001a2:	00006597          	auipc	a1,0x6
ffffffffc02001a6:	6fd58593          	addi	a1,a1,1789 # ffffffffc020689f <end+0x3ff>
ffffffffc02001aa:	00000797          	auipc	a5,0x0
ffffffffc02001ae:	e8878793          	addi	a5,a5,-376 # ffffffffc0200032 <kern_init>
ffffffffc02001b2:	40f587b3          	sub	a5,a1,a5
ffffffffc02001b6:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02001ba:	60a2                	ld	ra,8(sp)
ffffffffc02001bc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001c0:	95be                	add	a1,a1,a5
ffffffffc02001c2:	85a9                	srai	a1,a1,0xa
ffffffffc02001c4:	00002517          	auipc	a0,0x2
ffffffffc02001c8:	cac50513          	addi	a0,a0,-852 # ffffffffc0201e70 <etext+0xc2>
ffffffffc02001cc:	0141                	addi	sp,sp,16
ffffffffc02001ce:	b5f5                	j	ffffffffc02000ba <cprintf>

ffffffffc02001d0 <print_stackframe>:
ffffffffc02001d0:	1141                	addi	sp,sp,-16
ffffffffc02001d2:	00002617          	auipc	a2,0x2
ffffffffc02001d6:	cce60613          	addi	a2,a2,-818 # ffffffffc0201ea0 <etext+0xf2>
ffffffffc02001da:	04e00593          	li	a1,78
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	cda50513          	addi	a0,a0,-806 # ffffffffc0201eb8 <etext+0x10a>
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	1cc000ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02001ec <mon_help>:
ffffffffc02001ec:	1141                	addi	sp,sp,-16
ffffffffc02001ee:	00002617          	auipc	a2,0x2
ffffffffc02001f2:	ce260613          	addi	a2,a2,-798 # ffffffffc0201ed0 <etext+0x122>
ffffffffc02001f6:	00002597          	auipc	a1,0x2
ffffffffc02001fa:	cfa58593          	addi	a1,a1,-774 # ffffffffc0201ef0 <etext+0x142>
ffffffffc02001fe:	00002517          	auipc	a0,0x2
ffffffffc0200202:	cfa50513          	addi	a0,a0,-774 # ffffffffc0201ef8 <etext+0x14a>
ffffffffc0200206:	e406                	sd	ra,8(sp)
ffffffffc0200208:	eb3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020020c:	00002617          	auipc	a2,0x2
ffffffffc0200210:	cfc60613          	addi	a2,a2,-772 # ffffffffc0201f08 <etext+0x15a>
ffffffffc0200214:	00002597          	auipc	a1,0x2
ffffffffc0200218:	d1c58593          	addi	a1,a1,-740 # ffffffffc0201f30 <etext+0x182>
ffffffffc020021c:	00002517          	auipc	a0,0x2
ffffffffc0200220:	cdc50513          	addi	a0,a0,-804 # ffffffffc0201ef8 <etext+0x14a>
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00002617          	auipc	a2,0x2
ffffffffc020022c:	d1860613          	addi	a2,a2,-744 # ffffffffc0201f40 <etext+0x192>
ffffffffc0200230:	00002597          	auipc	a1,0x2
ffffffffc0200234:	d3058593          	addi	a1,a1,-720 # ffffffffc0201f60 <etext+0x1b2>
ffffffffc0200238:	00002517          	auipc	a0,0x2
ffffffffc020023c:	cc050513          	addi	a0,a0,-832 # ffffffffc0201ef8 <etext+0x14a>
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
ffffffffc0200276:	cfe50513          	addi	a0,a0,-770 # ffffffffc0201f70 <etext+0x1c2>
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
ffffffffc0200298:	d0450513          	addi	a0,a0,-764 # ffffffffc0201f98 <etext+0x1ea>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002a0:	000b8563          	beqz	s7,ffffffffc02002aa <kmonitor+0x3e>
ffffffffc02002a4:	855e                	mv	a0,s7
ffffffffc02002a6:	3a4000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc02002aa:	00002c17          	auipc	s8,0x2
ffffffffc02002ae:	d5ec0c13          	addi	s8,s8,-674 # ffffffffc0202008 <commands>
ffffffffc02002b2:	00002917          	auipc	s2,0x2
ffffffffc02002b6:	d0e90913          	addi	s2,s2,-754 # ffffffffc0201fc0 <etext+0x212>
ffffffffc02002ba:	00002497          	auipc	s1,0x2
ffffffffc02002be:	d0e48493          	addi	s1,s1,-754 # ffffffffc0201fc8 <etext+0x21a>
ffffffffc02002c2:	49bd                	li	s3,15
ffffffffc02002c4:	00002b17          	auipc	s6,0x2
ffffffffc02002c8:	d0cb0b13          	addi	s6,s6,-756 # ffffffffc0201fd0 <etext+0x222>
ffffffffc02002cc:	00002a17          	auipc	s4,0x2
ffffffffc02002d0:	c24a0a13          	addi	s4,s4,-988 # ffffffffc0201ef0 <etext+0x142>
ffffffffc02002d4:	4a8d                	li	s5,3
ffffffffc02002d6:	854a                	mv	a0,s2
ffffffffc02002d8:	157010ef          	jal	ra,ffffffffc0201c2e <readline>
ffffffffc02002dc:	842a                	mv	s0,a0
ffffffffc02002de:	dd65                	beqz	a0,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002e0:	00054583          	lbu	a1,0(a0)
ffffffffc02002e4:	4c81                	li	s9,0
ffffffffc02002e6:	e1bd                	bnez	a1,ffffffffc020034c <kmonitor+0xe0>
ffffffffc02002e8:	fe0c87e3          	beqz	s9,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002ec:	6582                	ld	a1,0(sp)
ffffffffc02002ee:	00002d17          	auipc	s10,0x2
ffffffffc02002f2:	d1ad0d13          	addi	s10,s10,-742 # ffffffffc0202008 <commands>
ffffffffc02002f6:	8552                	mv	a0,s4
ffffffffc02002f8:	4401                	li	s0,0
ffffffffc02002fa:	0d61                	addi	s10,s10,24
ffffffffc02002fc:	26d010ef          	jal	ra,ffffffffc0201d68 <strcmp>
ffffffffc0200300:	c919                	beqz	a0,ffffffffc0200316 <kmonitor+0xaa>
ffffffffc0200302:	2405                	addiw	s0,s0,1
ffffffffc0200304:	0b540063          	beq	s0,s5,ffffffffc02003a4 <kmonitor+0x138>
ffffffffc0200308:	000d3503          	ld	a0,0(s10)
ffffffffc020030c:	6582                	ld	a1,0(sp)
ffffffffc020030e:	0d61                	addi	s10,s10,24
ffffffffc0200310:	259010ef          	jal	ra,ffffffffc0201d68 <strcmp>
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
ffffffffc020034e:	239010ef          	jal	ra,ffffffffc0201d86 <strchr>
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
ffffffffc020038c:	1fb010ef          	jal	ra,ffffffffc0201d86 <strchr>
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
ffffffffc02003aa:	c4a50513          	addi	a0,a0,-950 # ffffffffc0201ff0 <etext+0x242>
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
ffffffffc02003e6:	c6e50513          	addi	a0,a0,-914 # ffffffffc0202050 <commands+0x48>
ffffffffc02003ea:	e43e                	sd	a5,8(sp)
ffffffffc02003ec:	ccfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003f0:	65a2                	ld	a1,8(sp)
ffffffffc02003f2:	8522                	mv	a0,s0
ffffffffc02003f4:	ca7ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
ffffffffc02003f8:	00002517          	auipc	a0,0x2
ffffffffc02003fc:	70850513          	addi	a0,a0,1800 # ffffffffc0202b00 <best_fit_pmm_manager+0x248>
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
ffffffffc0200428:	0d5010ef          	jal	ra,ffffffffc0201cfc <sbi_set_timer>
ffffffffc020042c:	60a2                	ld	ra,8(sp)
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	0207b123          	sd	zero,34(a5) # ffffffffc0206450 <ticks>
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	c3a50513          	addi	a0,a0,-966 # ffffffffc0202070 <commands+0x68>
ffffffffc020043e:	0141                	addi	sp,sp,16
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
ffffffffc0200442:	c0102573          	rdtime	a0
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	0af0106f          	j	ffffffffc0201cfc <sbi_set_timer>

ffffffffc0200452 <cons_init>:
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:
ffffffffc0200454:	0ff57513          	andi	a0,a0,255
ffffffffc0200458:	08b0106f          	j	ffffffffc0201ce2 <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
ffffffffc020045c:	0bb0106f          	j	ffffffffc0201d16 <sbi_console_getchar>

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
ffffffffc020048a:	c0a50513          	addi	a0,a0,-1014 # ffffffffc0202090 <commands+0x88>
ffffffffc020048e:	e406                	sd	ra,8(sp)
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00002517          	auipc	a0,0x2
ffffffffc020049a:	c1250513          	addi	a0,a0,-1006 # ffffffffc02020a8 <commands+0xa0>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	c1c50513          	addi	a0,a0,-996 # ffffffffc02020c0 <commands+0xb8>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	c2650513          	addi	a0,a0,-986 # ffffffffc02020d8 <commands+0xd0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	c3050513          	addi	a0,a0,-976 # ffffffffc02020f0 <commands+0xe8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00002517          	auipc	a0,0x2
ffffffffc02004d2:	c3a50513          	addi	a0,a0,-966 # ffffffffc0202108 <commands+0x100>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00002517          	auipc	a0,0x2
ffffffffc02004e0:	c4450513          	addi	a0,a0,-956 # ffffffffc0202120 <commands+0x118>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00002517          	auipc	a0,0x2
ffffffffc02004ee:	c4e50513          	addi	a0,a0,-946 # ffffffffc0202138 <commands+0x130>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00002517          	auipc	a0,0x2
ffffffffc02004fc:	c5850513          	addi	a0,a0,-936 # ffffffffc0202150 <commands+0x148>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00002517          	auipc	a0,0x2
ffffffffc020050a:	c6250513          	addi	a0,a0,-926 # ffffffffc0202168 <commands+0x160>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00002517          	auipc	a0,0x2
ffffffffc0200518:	c6c50513          	addi	a0,a0,-916 # ffffffffc0202180 <commands+0x178>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00002517          	auipc	a0,0x2
ffffffffc0200526:	c7650513          	addi	a0,a0,-906 # ffffffffc0202198 <commands+0x190>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00002517          	auipc	a0,0x2
ffffffffc0200534:	c8050513          	addi	a0,a0,-896 # ffffffffc02021b0 <commands+0x1a8>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00002517          	auipc	a0,0x2
ffffffffc0200542:	c8a50513          	addi	a0,a0,-886 # ffffffffc02021c8 <commands+0x1c0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00002517          	auipc	a0,0x2
ffffffffc0200550:	c9450513          	addi	a0,a0,-876 # ffffffffc02021e0 <commands+0x1d8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00002517          	auipc	a0,0x2
ffffffffc020055e:	c9e50513          	addi	a0,a0,-866 # ffffffffc02021f8 <commands+0x1f0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00002517          	auipc	a0,0x2
ffffffffc020056c:	ca850513          	addi	a0,a0,-856 # ffffffffc0202210 <commands+0x208>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	cb250513          	addi	a0,a0,-846 # ffffffffc0202228 <commands+0x220>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	cbc50513          	addi	a0,a0,-836 # ffffffffc0202240 <commands+0x238>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00002517          	auipc	a0,0x2
ffffffffc0200596:	cc650513          	addi	a0,a0,-826 # ffffffffc0202258 <commands+0x250>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00002517          	auipc	a0,0x2
ffffffffc02005a4:	cd050513          	addi	a0,a0,-816 # ffffffffc0202270 <commands+0x268>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00002517          	auipc	a0,0x2
ffffffffc02005b2:	cda50513          	addi	a0,a0,-806 # ffffffffc0202288 <commands+0x280>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00002517          	auipc	a0,0x2
ffffffffc02005c0:	ce450513          	addi	a0,a0,-796 # ffffffffc02022a0 <commands+0x298>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00002517          	auipc	a0,0x2
ffffffffc02005ce:	cee50513          	addi	a0,a0,-786 # ffffffffc02022b8 <commands+0x2b0>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00002517          	auipc	a0,0x2
ffffffffc02005dc:	cf850513          	addi	a0,a0,-776 # ffffffffc02022d0 <commands+0x2c8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	d0250513          	addi	a0,a0,-766 # ffffffffc02022e8 <commands+0x2e0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00002517          	auipc	a0,0x2
ffffffffc02005f8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0202300 <commands+0x2f8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00002517          	auipc	a0,0x2
ffffffffc0200606:	d1650513          	addi	a0,a0,-746 # ffffffffc0202318 <commands+0x310>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	d2050513          	addi	a0,a0,-736 # ffffffffc0202330 <commands+0x328>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	d2a50513          	addi	a0,a0,-726 # ffffffffc0202348 <commands+0x340>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00002517          	auipc	a0,0x2
ffffffffc0200630:	d3450513          	addi	a0,a0,-716 # ffffffffc0202360 <commands+0x358>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	d3a50513          	addi	a0,a0,-710 # ffffffffc0202378 <commands+0x370>
ffffffffc0200646:	0141                	addi	sp,sp,16
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
ffffffffc020064e:	85aa                	mv	a1,a0
ffffffffc0200650:	842a                	mv	s0,a0
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	d3e50513          	addi	a0,a0,-706 # ffffffffc0202390 <commands+0x388>
ffffffffc020065a:	e406                	sd	ra,8(sp)
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00002517          	auipc	a0,0x2
ffffffffc020066e:	d3e50513          	addi	a0,a0,-706 # ffffffffc02023a8 <commands+0x3a0>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	d4650513          	addi	a0,a0,-698 # ffffffffc02023c0 <commands+0x3b8>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00002517          	auipc	a0,0x2
ffffffffc020068e:	d4e50513          	addi	a0,a0,-690 # ffffffffc02023d8 <commands+0x3d0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200696:	11843583          	ld	a1,280(s0)
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
ffffffffc020069e:	00002517          	auipc	a0,0x2
ffffffffc02006a2:	d5250513          	addi	a0,a0,-686 # ffffffffc02023f0 <commands+0x3e8>
ffffffffc02006a6:	0141                	addi	sp,sp,16
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	08f76663          	bltu	a4,a5,ffffffffc0200740 <interrupt_handler+0x96>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	e1870713          	addi	a4,a4,-488 # ffffffffc02024d0 <commands+0x4c8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	d9e50513          	addi	a0,a0,-610 # ffffffffc0202468 <commands+0x460>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	d7450513          	addi	a0,a0,-652 # ffffffffc0202448 <commands+0x440>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
ffffffffc02006de:	00002517          	auipc	a0,0x2
ffffffffc02006e2:	d2a50513          	addi	a0,a0,-726 # ffffffffc0202408 <commands+0x400>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
ffffffffc02006e8:	00002517          	auipc	a0,0x2
ffffffffc02006ec:	da050513          	addi	a0,a0,-608 # ffffffffc0202488 <commands+0x480>
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
ffffffffc0200730:	d8450513          	addi	a0,a0,-636 # ffffffffc02024b0 <commands+0x4a8>
ffffffffc0200734:	b259                	j	ffffffffc02000ba <cprintf>
ffffffffc0200736:	00002517          	auipc	a0,0x2
ffffffffc020073a:	cf250513          	addi	a0,a0,-782 # ffffffffc0202428 <commands+0x420>
ffffffffc020073e:	bab5                	j	ffffffffc02000ba <cprintf>
ffffffffc0200740:	b729                	j	ffffffffc020064a <print_trapframe>
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	d5a50513          	addi	a0,a0,-678 # ffffffffc02024a0 <commands+0x498>
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
ffffffffc0200768:	5ca0106f          	j	ffffffffc0201d32 <sbi_shutdown>

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
ffffffffc020078c:	d7850513          	addi	a0,a0,-648 # ffffffffc0202500 <commands+0x4f8>
ffffffffc0200790:	92bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200794:	10843583          	ld	a1,264(s0)
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	d9050513          	addi	a0,a0,-624 # ffffffffc0202528 <commands+0x520>
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
ffffffffc02007ca:	d8a50513          	addi	a0,a0,-630 # ffffffffc0202550 <commands+0x548>
ffffffffc02007ce:	8edff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007d2:	10843583          	ld	a1,264(s0)
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	d5250513          	addi	a0,a0,-686 # ffffffffc0202528 <commands+0x520>
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

ffffffffc02008b6 <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02008b6:	00005797          	auipc	a5,0x5
ffffffffc02008ba:	77a78793          	addi	a5,a5,1914 # ffffffffc0206030 <free_area>
ffffffffc02008be:	e79c                	sd	a5,8(a5)
ffffffffc02008c0:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc02008c2:	0007a823          	sw	zero,16(a5)
}
ffffffffc02008c6:	8082                	ret

ffffffffc02008c8 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc02008c8:	00005517          	auipc	a0,0x5
ffffffffc02008cc:	77856503          	lwu	a0,1912(a0) # ffffffffc0206040 <free_area+0x10>
ffffffffc02008d0:	8082                	ret

ffffffffc02008d2 <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc02008d2:	c14d                	beqz	a0,ffffffffc0200974 <best_fit_alloc_pages+0xa2>
    if (n > nr_free) {
ffffffffc02008d4:	00005617          	auipc	a2,0x5
ffffffffc02008d8:	75c60613          	addi	a2,a2,1884 # ffffffffc0206030 <free_area>
ffffffffc02008dc:	01062803          	lw	a6,16(a2)
ffffffffc02008e0:	86aa                	mv	a3,a0
ffffffffc02008e2:	02081793          	slli	a5,a6,0x20
ffffffffc02008e6:	9381                	srli	a5,a5,0x20
ffffffffc02008e8:	08a7e463          	bltu	a5,a0,ffffffffc0200970 <best_fit_alloc_pages+0x9e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02008ec:	661c                	ld	a5,8(a2)
    size_t min_size = nr_free + 1;
ffffffffc02008ee:	0018059b          	addiw	a1,a6,1
ffffffffc02008f2:	1582                	slli	a1,a1,0x20
ffffffffc02008f4:	9181                	srli	a1,a1,0x20
    struct Page *page = NULL;
ffffffffc02008f6:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
ffffffffc02008f8:	06c78b63          	beq	a5,a2,ffffffffc020096e <best_fit_alloc_pages+0x9c>
        if (p->property >= n && p->property < min_size) {  // 新找到的比已找到的最小还小，就更换
ffffffffc02008fc:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0200900:	00d76763          	bltu	a4,a3,ffffffffc020090e <best_fit_alloc_pages+0x3c>
ffffffffc0200904:	00b77563          	bgeu	a4,a1,ffffffffc020090e <best_fit_alloc_pages+0x3c>
        struct Page *p = le2page(le, page_link);
ffffffffc0200908:	fe878513          	addi	a0,a5,-24
ffffffffc020090c:	85ba                	mv	a1,a4
ffffffffc020090e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200910:	fec796e3          	bne	a5,a2,ffffffffc02008fc <best_fit_alloc_pages+0x2a>
    if (page != NULL) {
ffffffffc0200914:	cd29                	beqz	a0,ffffffffc020096e <best_fit_alloc_pages+0x9c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200916:	711c                	ld	a5,32(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200918:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc020091a:	490c                	lw	a1,16(a0)
            p->property = page->property - n;
ffffffffc020091c:	0006889b          	sext.w	a7,a3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200920:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200922:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc0200924:	02059793          	slli	a5,a1,0x20
ffffffffc0200928:	9381                	srli	a5,a5,0x20
ffffffffc020092a:	02f6f863          	bgeu	a3,a5,ffffffffc020095a <best_fit_alloc_pages+0x88>
            struct Page *p = page + n;
ffffffffc020092e:	00269793          	slli	a5,a3,0x2
ffffffffc0200932:	97b6                	add	a5,a5,a3
ffffffffc0200934:	078e                	slli	a5,a5,0x3
ffffffffc0200936:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc0200938:	411585bb          	subw	a1,a1,a7
ffffffffc020093c:	cb8c                	sw	a1,16(a5)
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020093e:	4689                	li	a3,2
ffffffffc0200940:	00878593          	addi	a1,a5,8
ffffffffc0200944:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200948:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc020094a:	01878593          	addi	a1,a5,24
        nr_free -= n;
ffffffffc020094e:	01062803          	lw	a6,16(a2)
    prev->next = next->prev = elm;
ffffffffc0200952:	e28c                	sd	a1,0(a3)
ffffffffc0200954:	e70c                	sd	a1,8(a4)
    elm->next = next;
ffffffffc0200956:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200958:	ef98                	sd	a4,24(a5)
ffffffffc020095a:	4118083b          	subw	a6,a6,a7
ffffffffc020095e:	01062823          	sw	a6,16(a2)
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200962:	57f5                	li	a5,-3
ffffffffc0200964:	00850713          	addi	a4,a0,8
ffffffffc0200968:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc020096c:	8082                	ret
}
ffffffffc020096e:	8082                	ret
        return NULL;
ffffffffc0200970:	4501                	li	a0,0
ffffffffc0200972:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0200974:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200976:	00002697          	auipc	a3,0x2
ffffffffc020097a:	bfa68693          	addi	a3,a3,-1030 # ffffffffc0202570 <commands+0x568>
ffffffffc020097e:	00002617          	auipc	a2,0x2
ffffffffc0200982:	bfa60613          	addi	a2,a2,-1030 # ffffffffc0202578 <commands+0x570>
ffffffffc0200986:	06a00593          	li	a1,106
ffffffffc020098a:	00002517          	auipc	a0,0x2
ffffffffc020098e:	c0650513          	addi	a0,a0,-1018 # ffffffffc0202590 <commands+0x588>
best_fit_alloc_pages(size_t n) {
ffffffffc0200992:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200994:	a21ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200998 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200998:	715d                	addi	sp,sp,-80
ffffffffc020099a:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc020099c:	00005417          	auipc	s0,0x5
ffffffffc02009a0:	69440413          	addi	s0,s0,1684 # ffffffffc0206030 <free_area>
ffffffffc02009a4:	641c                	ld	a5,8(s0)
ffffffffc02009a6:	e486                	sd	ra,72(sp)
ffffffffc02009a8:	fc26                	sd	s1,56(sp)
ffffffffc02009aa:	f84a                	sd	s2,48(sp)
ffffffffc02009ac:	f44e                	sd	s3,40(sp)
ffffffffc02009ae:	f052                	sd	s4,32(sp)
ffffffffc02009b0:	ec56                	sd	s5,24(sp)
ffffffffc02009b2:	e85a                	sd	s6,16(sp)
ffffffffc02009b4:	e45e                	sd	s7,8(sp)
ffffffffc02009b6:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02009b8:	26878b63          	beq	a5,s0,ffffffffc0200c2e <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc02009bc:	4481                	li	s1,0
ffffffffc02009be:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02009c0:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02009c4:	8b09                	andi	a4,a4,2
ffffffffc02009c6:	26070863          	beqz	a4,ffffffffc0200c36 <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc02009ca:	ff87a703          	lw	a4,-8(a5)
ffffffffc02009ce:	679c                	ld	a5,8(a5)
ffffffffc02009d0:	2905                	addiw	s2,s2,1
ffffffffc02009d2:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02009d4:	fe8796e3          	bne	a5,s0,ffffffffc02009c0 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02009d8:	89a6                	mv	s3,s1
ffffffffc02009da:	167000ef          	jal	ra,ffffffffc0201340 <nr_free_pages>
ffffffffc02009de:	33351c63          	bne	a0,s3,ffffffffc0200d16 <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02009e2:	4505                	li	a0,1
ffffffffc02009e4:	0df000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc02009e8:	8a2a                	mv	s4,a0
ffffffffc02009ea:	36050663          	beqz	a0,ffffffffc0200d56 <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02009ee:	4505                	li	a0,1
ffffffffc02009f0:	0d3000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc02009f4:	89aa                	mv	s3,a0
ffffffffc02009f6:	34050063          	beqz	a0,ffffffffc0200d36 <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02009fa:	4505                	li	a0,1
ffffffffc02009fc:	0c7000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200a00:	8aaa                	mv	s5,a0
ffffffffc0200a02:	2c050a63          	beqz	a0,ffffffffc0200cd6 <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200a06:	253a0863          	beq	s4,s3,ffffffffc0200c56 <best_fit_check+0x2be>
ffffffffc0200a0a:	24aa0663          	beq	s4,a0,ffffffffc0200c56 <best_fit_check+0x2be>
ffffffffc0200a0e:	24a98463          	beq	s3,a0,ffffffffc0200c56 <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200a12:	000a2783          	lw	a5,0(s4)
ffffffffc0200a16:	26079063          	bnez	a5,ffffffffc0200c76 <best_fit_check+0x2de>
ffffffffc0200a1a:	0009a783          	lw	a5,0(s3)
ffffffffc0200a1e:	24079c63          	bnez	a5,ffffffffc0200c76 <best_fit_check+0x2de>
ffffffffc0200a22:	411c                	lw	a5,0(a0)
ffffffffc0200a24:	24079963          	bnez	a5,ffffffffc0200c76 <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200a28:	00006797          	auipc	a5,0x6
ffffffffc0200a2c:	a407b783          	ld	a5,-1472(a5) # ffffffffc0206468 <pages>
ffffffffc0200a30:	40fa0733          	sub	a4,s4,a5
ffffffffc0200a34:	870d                	srai	a4,a4,0x3
ffffffffc0200a36:	00002597          	auipc	a1,0x2
ffffffffc0200a3a:	34a5b583          	ld	a1,842(a1) # ffffffffc0202d80 <error_string+0x38>
ffffffffc0200a3e:	02b70733          	mul	a4,a4,a1
ffffffffc0200a42:	00002617          	auipc	a2,0x2
ffffffffc0200a46:	34663603          	ld	a2,838(a2) # ffffffffc0202d88 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200a4a:	00006697          	auipc	a3,0x6
ffffffffc0200a4e:	a166b683          	ld	a3,-1514(a3) # ffffffffc0206460 <npage>
ffffffffc0200a52:	06b2                	slli	a3,a3,0xc
ffffffffc0200a54:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200a56:	0732                	slli	a4,a4,0xc
ffffffffc0200a58:	22d77f63          	bgeu	a4,a3,ffffffffc0200c96 <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200a5c:	40f98733          	sub	a4,s3,a5
ffffffffc0200a60:	870d                	srai	a4,a4,0x3
ffffffffc0200a62:	02b70733          	mul	a4,a4,a1
ffffffffc0200a66:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200a68:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200a6a:	3ed77663          	bgeu	a4,a3,ffffffffc0200e56 <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200a6e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200a72:	878d                	srai	a5,a5,0x3
ffffffffc0200a74:	02b787b3          	mul	a5,a5,a1
ffffffffc0200a78:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200a7a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200a7c:	3ad7fd63          	bgeu	a5,a3,ffffffffc0200e36 <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200a80:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200a82:	00043c03          	ld	s8,0(s0)
ffffffffc0200a86:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200a8a:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200a8e:	e400                	sd	s0,8(s0)
ffffffffc0200a90:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200a92:	00005797          	auipc	a5,0x5
ffffffffc0200a96:	5a07a723          	sw	zero,1454(a5) # ffffffffc0206040 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200a9a:	029000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200a9e:	36051c63          	bnez	a0,ffffffffc0200e16 <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200aa2:	4585                	li	a1,1
ffffffffc0200aa4:	8552                	mv	a0,s4
ffffffffc0200aa6:	05b000ef          	jal	ra,ffffffffc0201300 <free_pages>
    free_page(p1);
ffffffffc0200aaa:	4585                	li	a1,1
ffffffffc0200aac:	854e                	mv	a0,s3
ffffffffc0200aae:	053000ef          	jal	ra,ffffffffc0201300 <free_pages>
    free_page(p2);
ffffffffc0200ab2:	4585                	li	a1,1
ffffffffc0200ab4:	8556                	mv	a0,s5
ffffffffc0200ab6:	04b000ef          	jal	ra,ffffffffc0201300 <free_pages>
    assert(nr_free == 3);
ffffffffc0200aba:	4818                	lw	a4,16(s0)
ffffffffc0200abc:	478d                	li	a5,3
ffffffffc0200abe:	32f71c63          	bne	a4,a5,ffffffffc0200df6 <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ac2:	4505                	li	a0,1
ffffffffc0200ac4:	7fe000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200ac8:	89aa                	mv	s3,a0
ffffffffc0200aca:	30050663          	beqz	a0,ffffffffc0200dd6 <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ace:	4505                	li	a0,1
ffffffffc0200ad0:	7f2000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200ad4:	8aaa                	mv	s5,a0
ffffffffc0200ad6:	2e050063          	beqz	a0,ffffffffc0200db6 <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200ada:	4505                	li	a0,1
ffffffffc0200adc:	7e6000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200ae0:	8a2a                	mv	s4,a0
ffffffffc0200ae2:	2a050a63          	beqz	a0,ffffffffc0200d96 <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc0200ae6:	4505                	li	a0,1
ffffffffc0200ae8:	7da000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200aec:	28051563          	bnez	a0,ffffffffc0200d76 <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200af0:	4585                	li	a1,1
ffffffffc0200af2:	854e                	mv	a0,s3
ffffffffc0200af4:	00d000ef          	jal	ra,ffffffffc0201300 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200af8:	641c                	ld	a5,8(s0)
ffffffffc0200afa:	1a878e63          	beq	a5,s0,ffffffffc0200cb6 <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200afe:	4505                	li	a0,1
ffffffffc0200b00:	7c2000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200b04:	52a99963          	bne	s3,a0,ffffffffc0201036 <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc0200b08:	4505                	li	a0,1
ffffffffc0200b0a:	7b8000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200b0e:	50051463          	bnez	a0,ffffffffc0201016 <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200b12:	481c                	lw	a5,16(s0)
ffffffffc0200b14:	4e079163          	bnez	a5,ffffffffc0200ff6 <best_fit_check+0x65e>
    free_page(p);
ffffffffc0200b18:	854e                	mv	a0,s3
ffffffffc0200b1a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200b1c:	01843023          	sd	s8,0(s0)
ffffffffc0200b20:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200b24:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200b28:	7d8000ef          	jal	ra,ffffffffc0201300 <free_pages>
    free_page(p1);
ffffffffc0200b2c:	4585                	li	a1,1
ffffffffc0200b2e:	8556                	mv	a0,s5
ffffffffc0200b30:	7d0000ef          	jal	ra,ffffffffc0201300 <free_pages>
    free_page(p2);
ffffffffc0200b34:	4585                	li	a1,1
ffffffffc0200b36:	8552                	mv	a0,s4
ffffffffc0200b38:	7c8000ef          	jal	ra,ffffffffc0201300 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200b3c:	4515                	li	a0,5
ffffffffc0200b3e:	784000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200b42:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200b44:	48050963          	beqz	a0,ffffffffc0200fd6 <best_fit_check+0x63e>
ffffffffc0200b48:	651c                	ld	a5,8(a0)
ffffffffc0200b4a:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200b4c:	8b85                	andi	a5,a5,1
ffffffffc0200b4e:	46079463          	bnez	a5,ffffffffc0200fb6 <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200b52:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200b54:	00043a83          	ld	s5,0(s0)
ffffffffc0200b58:	00843a03          	ld	s4,8(s0)
ffffffffc0200b5c:	e000                	sd	s0,0(s0)
ffffffffc0200b5e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200b60:	762000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200b64:	42051963          	bnez	a0,ffffffffc0200f96 <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200b68:	4589                	li	a1,2
ffffffffc0200b6a:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200b6e:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200b72:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200b76:	00005797          	auipc	a5,0x5
ffffffffc0200b7a:	4c07a523          	sw	zero,1226(a5) # ffffffffc0206040 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200b7e:	782000ef          	jal	ra,ffffffffc0201300 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200b82:	8562                	mv	a0,s8
ffffffffc0200b84:	4585                	li	a1,1
ffffffffc0200b86:	77a000ef          	jal	ra,ffffffffc0201300 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200b8a:	4511                	li	a0,4
ffffffffc0200b8c:	736000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200b90:	3e051363          	bnez	a0,ffffffffc0200f76 <best_fit_check+0x5de>
ffffffffc0200b94:	0309b783          	ld	a5,48(s3)
ffffffffc0200b98:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200b9a:	8b85                	andi	a5,a5,1
ffffffffc0200b9c:	3a078d63          	beqz	a5,ffffffffc0200f56 <best_fit_check+0x5be>
ffffffffc0200ba0:	0389a703          	lw	a4,56(s3)
ffffffffc0200ba4:	4789                	li	a5,2
ffffffffc0200ba6:	3af71863          	bne	a4,a5,ffffffffc0200f56 <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200baa:	4505                	li	a0,1
ffffffffc0200bac:	716000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200bb0:	8baa                	mv	s7,a0
ffffffffc0200bb2:	38050263          	beqz	a0,ffffffffc0200f36 <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200bb6:	4509                	li	a0,2
ffffffffc0200bb8:	70a000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200bbc:	34050d63          	beqz	a0,ffffffffc0200f16 <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200bc0:	337c1b63          	bne	s8,s7,ffffffffc0200ef6 <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200bc4:	854e                	mv	a0,s3
ffffffffc0200bc6:	4595                	li	a1,5
ffffffffc0200bc8:	738000ef          	jal	ra,ffffffffc0201300 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200bcc:	4515                	li	a0,5
ffffffffc0200bce:	6f4000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200bd2:	89aa                	mv	s3,a0
ffffffffc0200bd4:	30050163          	beqz	a0,ffffffffc0200ed6 <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200bd8:	4505                	li	a0,1
ffffffffc0200bda:	6e8000ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc0200bde:	2c051c63          	bnez	a0,ffffffffc0200eb6 <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200be2:	481c                	lw	a5,16(s0)
ffffffffc0200be4:	2a079963          	bnez	a5,ffffffffc0200e96 <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200be8:	4595                	li	a1,5
ffffffffc0200bea:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200bec:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200bf0:	01543023          	sd	s5,0(s0)
ffffffffc0200bf4:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200bf8:	708000ef          	jal	ra,ffffffffc0201300 <free_pages>
    return listelm->next;
ffffffffc0200bfc:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200bfe:	00878963          	beq	a5,s0,ffffffffc0200c10 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200c02:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200c06:	679c                	ld	a5,8(a5)
ffffffffc0200c08:	397d                	addiw	s2,s2,-1
ffffffffc0200c0a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c0c:	fe879be3          	bne	a5,s0,ffffffffc0200c02 <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200c10:	26091363          	bnez	s2,ffffffffc0200e76 <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200c14:	e0ed                	bnez	s1,ffffffffc0200cf6 <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200c16:	60a6                	ld	ra,72(sp)
ffffffffc0200c18:	6406                	ld	s0,64(sp)
ffffffffc0200c1a:	74e2                	ld	s1,56(sp)
ffffffffc0200c1c:	7942                	ld	s2,48(sp)
ffffffffc0200c1e:	79a2                	ld	s3,40(sp)
ffffffffc0200c20:	7a02                	ld	s4,32(sp)
ffffffffc0200c22:	6ae2                	ld	s5,24(sp)
ffffffffc0200c24:	6b42                	ld	s6,16(sp)
ffffffffc0200c26:	6ba2                	ld	s7,8(sp)
ffffffffc0200c28:	6c02                	ld	s8,0(sp)
ffffffffc0200c2a:	6161                	addi	sp,sp,80
ffffffffc0200c2c:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c2e:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200c30:	4481                	li	s1,0
ffffffffc0200c32:	4901                	li	s2,0
ffffffffc0200c34:	b35d                	j	ffffffffc02009da <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc0200c36:	00002697          	auipc	a3,0x2
ffffffffc0200c3a:	97268693          	addi	a3,a3,-1678 # ffffffffc02025a8 <commands+0x5a0>
ffffffffc0200c3e:	00002617          	auipc	a2,0x2
ffffffffc0200c42:	93a60613          	addi	a2,a2,-1734 # ffffffffc0202578 <commands+0x570>
ffffffffc0200c46:	10900593          	li	a1,265
ffffffffc0200c4a:	00002517          	auipc	a0,0x2
ffffffffc0200c4e:	94650513          	addi	a0,a0,-1722 # ffffffffc0202590 <commands+0x588>
ffffffffc0200c52:	f62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200c56:	00002697          	auipc	a3,0x2
ffffffffc0200c5a:	9e268693          	addi	a3,a3,-1566 # ffffffffc0202638 <commands+0x630>
ffffffffc0200c5e:	00002617          	auipc	a2,0x2
ffffffffc0200c62:	91a60613          	addi	a2,a2,-1766 # ffffffffc0202578 <commands+0x570>
ffffffffc0200c66:	0d500593          	li	a1,213
ffffffffc0200c6a:	00002517          	auipc	a0,0x2
ffffffffc0200c6e:	92650513          	addi	a0,a0,-1754 # ffffffffc0202590 <commands+0x588>
ffffffffc0200c72:	f42ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200c76:	00002697          	auipc	a3,0x2
ffffffffc0200c7a:	9ea68693          	addi	a3,a3,-1558 # ffffffffc0202660 <commands+0x658>
ffffffffc0200c7e:	00002617          	auipc	a2,0x2
ffffffffc0200c82:	8fa60613          	addi	a2,a2,-1798 # ffffffffc0202578 <commands+0x570>
ffffffffc0200c86:	0d600593          	li	a1,214
ffffffffc0200c8a:	00002517          	auipc	a0,0x2
ffffffffc0200c8e:	90650513          	addi	a0,a0,-1786 # ffffffffc0202590 <commands+0x588>
ffffffffc0200c92:	f22ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200c96:	00002697          	auipc	a3,0x2
ffffffffc0200c9a:	a0a68693          	addi	a3,a3,-1526 # ffffffffc02026a0 <commands+0x698>
ffffffffc0200c9e:	00002617          	auipc	a2,0x2
ffffffffc0200ca2:	8da60613          	addi	a2,a2,-1830 # ffffffffc0202578 <commands+0x570>
ffffffffc0200ca6:	0d800593          	li	a1,216
ffffffffc0200caa:	00002517          	auipc	a0,0x2
ffffffffc0200cae:	8e650513          	addi	a0,a0,-1818 # ffffffffc0202590 <commands+0x588>
ffffffffc0200cb2:	f02ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200cb6:	00002697          	auipc	a3,0x2
ffffffffc0200cba:	a7268693          	addi	a3,a3,-1422 # ffffffffc0202728 <commands+0x720>
ffffffffc0200cbe:	00002617          	auipc	a2,0x2
ffffffffc0200cc2:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0202578 <commands+0x570>
ffffffffc0200cc6:	0f100593          	li	a1,241
ffffffffc0200cca:	00002517          	auipc	a0,0x2
ffffffffc0200cce:	8c650513          	addi	a0,a0,-1850 # ffffffffc0202590 <commands+0x588>
ffffffffc0200cd2:	ee2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200cd6:	00002697          	auipc	a3,0x2
ffffffffc0200cda:	94268693          	addi	a3,a3,-1726 # ffffffffc0202618 <commands+0x610>
ffffffffc0200cde:	00002617          	auipc	a2,0x2
ffffffffc0200ce2:	89a60613          	addi	a2,a2,-1894 # ffffffffc0202578 <commands+0x570>
ffffffffc0200ce6:	0d300593          	li	a1,211
ffffffffc0200cea:	00002517          	auipc	a0,0x2
ffffffffc0200cee:	8a650513          	addi	a0,a0,-1882 # ffffffffc0202590 <commands+0x588>
ffffffffc0200cf2:	ec2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(total == 0);
ffffffffc0200cf6:	00002697          	auipc	a3,0x2
ffffffffc0200cfa:	b6268693          	addi	a3,a3,-1182 # ffffffffc0202858 <commands+0x850>
ffffffffc0200cfe:	00002617          	auipc	a2,0x2
ffffffffc0200d02:	87a60613          	addi	a2,a2,-1926 # ffffffffc0202578 <commands+0x570>
ffffffffc0200d06:	14b00593          	li	a1,331
ffffffffc0200d0a:	00002517          	auipc	a0,0x2
ffffffffc0200d0e:	88650513          	addi	a0,a0,-1914 # ffffffffc0202590 <commands+0x588>
ffffffffc0200d12:	ea2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(total == nr_free_pages());
ffffffffc0200d16:	00002697          	auipc	a3,0x2
ffffffffc0200d1a:	8a268693          	addi	a3,a3,-1886 # ffffffffc02025b8 <commands+0x5b0>
ffffffffc0200d1e:	00002617          	auipc	a2,0x2
ffffffffc0200d22:	85a60613          	addi	a2,a2,-1958 # ffffffffc0202578 <commands+0x570>
ffffffffc0200d26:	10c00593          	li	a1,268
ffffffffc0200d2a:	00002517          	auipc	a0,0x2
ffffffffc0200d2e:	86650513          	addi	a0,a0,-1946 # ffffffffc0202590 <commands+0x588>
ffffffffc0200d32:	e82ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d36:	00002697          	auipc	a3,0x2
ffffffffc0200d3a:	8c268693          	addi	a3,a3,-1854 # ffffffffc02025f8 <commands+0x5f0>
ffffffffc0200d3e:	00002617          	auipc	a2,0x2
ffffffffc0200d42:	83a60613          	addi	a2,a2,-1990 # ffffffffc0202578 <commands+0x570>
ffffffffc0200d46:	0d200593          	li	a1,210
ffffffffc0200d4a:	00002517          	auipc	a0,0x2
ffffffffc0200d4e:	84650513          	addi	a0,a0,-1978 # ffffffffc0202590 <commands+0x588>
ffffffffc0200d52:	e62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d56:	00002697          	auipc	a3,0x2
ffffffffc0200d5a:	88268693          	addi	a3,a3,-1918 # ffffffffc02025d8 <commands+0x5d0>
ffffffffc0200d5e:	00002617          	auipc	a2,0x2
ffffffffc0200d62:	81a60613          	addi	a2,a2,-2022 # ffffffffc0202578 <commands+0x570>
ffffffffc0200d66:	0d100593          	li	a1,209
ffffffffc0200d6a:	00002517          	auipc	a0,0x2
ffffffffc0200d6e:	82650513          	addi	a0,a0,-2010 # ffffffffc0202590 <commands+0x588>
ffffffffc0200d72:	e42ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200d76:	00002697          	auipc	a3,0x2
ffffffffc0200d7a:	98a68693          	addi	a3,a3,-1654 # ffffffffc0202700 <commands+0x6f8>
ffffffffc0200d7e:	00001617          	auipc	a2,0x1
ffffffffc0200d82:	7fa60613          	addi	a2,a2,2042 # ffffffffc0202578 <commands+0x570>
ffffffffc0200d86:	0ee00593          	li	a1,238
ffffffffc0200d8a:	00002517          	auipc	a0,0x2
ffffffffc0200d8e:	80650513          	addi	a0,a0,-2042 # ffffffffc0202590 <commands+0x588>
ffffffffc0200d92:	e22ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d96:	00002697          	auipc	a3,0x2
ffffffffc0200d9a:	88268693          	addi	a3,a3,-1918 # ffffffffc0202618 <commands+0x610>
ffffffffc0200d9e:	00001617          	auipc	a2,0x1
ffffffffc0200da2:	7da60613          	addi	a2,a2,2010 # ffffffffc0202578 <commands+0x570>
ffffffffc0200da6:	0ec00593          	li	a1,236
ffffffffc0200daa:	00001517          	auipc	a0,0x1
ffffffffc0200dae:	7e650513          	addi	a0,a0,2022 # ffffffffc0202590 <commands+0x588>
ffffffffc0200db2:	e02ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200db6:	00002697          	auipc	a3,0x2
ffffffffc0200dba:	84268693          	addi	a3,a3,-1982 # ffffffffc02025f8 <commands+0x5f0>
ffffffffc0200dbe:	00001617          	auipc	a2,0x1
ffffffffc0200dc2:	7ba60613          	addi	a2,a2,1978 # ffffffffc0202578 <commands+0x570>
ffffffffc0200dc6:	0eb00593          	li	a1,235
ffffffffc0200dca:	00001517          	auipc	a0,0x1
ffffffffc0200dce:	7c650513          	addi	a0,a0,1990 # ffffffffc0202590 <commands+0x588>
ffffffffc0200dd2:	de2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200dd6:	00002697          	auipc	a3,0x2
ffffffffc0200dda:	80268693          	addi	a3,a3,-2046 # ffffffffc02025d8 <commands+0x5d0>
ffffffffc0200dde:	00001617          	auipc	a2,0x1
ffffffffc0200de2:	79a60613          	addi	a2,a2,1946 # ffffffffc0202578 <commands+0x570>
ffffffffc0200de6:	0ea00593          	li	a1,234
ffffffffc0200dea:	00001517          	auipc	a0,0x1
ffffffffc0200dee:	7a650513          	addi	a0,a0,1958 # ffffffffc0202590 <commands+0x588>
ffffffffc0200df2:	dc2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(nr_free == 3);
ffffffffc0200df6:	00002697          	auipc	a3,0x2
ffffffffc0200dfa:	92268693          	addi	a3,a3,-1758 # ffffffffc0202718 <commands+0x710>
ffffffffc0200dfe:	00001617          	auipc	a2,0x1
ffffffffc0200e02:	77a60613          	addi	a2,a2,1914 # ffffffffc0202578 <commands+0x570>
ffffffffc0200e06:	0e800593          	li	a1,232
ffffffffc0200e0a:	00001517          	auipc	a0,0x1
ffffffffc0200e0e:	78650513          	addi	a0,a0,1926 # ffffffffc0202590 <commands+0x588>
ffffffffc0200e12:	da2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200e16:	00002697          	auipc	a3,0x2
ffffffffc0200e1a:	8ea68693          	addi	a3,a3,-1814 # ffffffffc0202700 <commands+0x6f8>
ffffffffc0200e1e:	00001617          	auipc	a2,0x1
ffffffffc0200e22:	75a60613          	addi	a2,a2,1882 # ffffffffc0202578 <commands+0x570>
ffffffffc0200e26:	0e300593          	li	a1,227
ffffffffc0200e2a:	00001517          	auipc	a0,0x1
ffffffffc0200e2e:	76650513          	addi	a0,a0,1894 # ffffffffc0202590 <commands+0x588>
ffffffffc0200e32:	d82ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200e36:	00002697          	auipc	a3,0x2
ffffffffc0200e3a:	8aa68693          	addi	a3,a3,-1878 # ffffffffc02026e0 <commands+0x6d8>
ffffffffc0200e3e:	00001617          	auipc	a2,0x1
ffffffffc0200e42:	73a60613          	addi	a2,a2,1850 # ffffffffc0202578 <commands+0x570>
ffffffffc0200e46:	0da00593          	li	a1,218
ffffffffc0200e4a:	00001517          	auipc	a0,0x1
ffffffffc0200e4e:	74650513          	addi	a0,a0,1862 # ffffffffc0202590 <commands+0x588>
ffffffffc0200e52:	d62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200e56:	00002697          	auipc	a3,0x2
ffffffffc0200e5a:	86a68693          	addi	a3,a3,-1942 # ffffffffc02026c0 <commands+0x6b8>
ffffffffc0200e5e:	00001617          	auipc	a2,0x1
ffffffffc0200e62:	71a60613          	addi	a2,a2,1818 # ffffffffc0202578 <commands+0x570>
ffffffffc0200e66:	0d900593          	li	a1,217
ffffffffc0200e6a:	00001517          	auipc	a0,0x1
ffffffffc0200e6e:	72650513          	addi	a0,a0,1830 # ffffffffc0202590 <commands+0x588>
ffffffffc0200e72:	d42ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(count == 0);
ffffffffc0200e76:	00002697          	auipc	a3,0x2
ffffffffc0200e7a:	9d268693          	addi	a3,a3,-1582 # ffffffffc0202848 <commands+0x840>
ffffffffc0200e7e:	00001617          	auipc	a2,0x1
ffffffffc0200e82:	6fa60613          	addi	a2,a2,1786 # ffffffffc0202578 <commands+0x570>
ffffffffc0200e86:	14a00593          	li	a1,330
ffffffffc0200e8a:	00001517          	auipc	a0,0x1
ffffffffc0200e8e:	70650513          	addi	a0,a0,1798 # ffffffffc0202590 <commands+0x588>
ffffffffc0200e92:	d22ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(nr_free == 0);
ffffffffc0200e96:	00002697          	auipc	a3,0x2
ffffffffc0200e9a:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0202760 <commands+0x758>
ffffffffc0200e9e:	00001617          	auipc	a2,0x1
ffffffffc0200ea2:	6da60613          	addi	a2,a2,1754 # ffffffffc0202578 <commands+0x570>
ffffffffc0200ea6:	13f00593          	li	a1,319
ffffffffc0200eaa:	00001517          	auipc	a0,0x1
ffffffffc0200eae:	6e650513          	addi	a0,a0,1766 # ffffffffc0202590 <commands+0x588>
ffffffffc0200eb2:	d02ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200eb6:	00002697          	auipc	a3,0x2
ffffffffc0200eba:	84a68693          	addi	a3,a3,-1974 # ffffffffc0202700 <commands+0x6f8>
ffffffffc0200ebe:	00001617          	auipc	a2,0x1
ffffffffc0200ec2:	6ba60613          	addi	a2,a2,1722 # ffffffffc0202578 <commands+0x570>
ffffffffc0200ec6:	13900593          	li	a1,313
ffffffffc0200eca:	00001517          	auipc	a0,0x1
ffffffffc0200ece:	6c650513          	addi	a0,a0,1734 # ffffffffc0202590 <commands+0x588>
ffffffffc0200ed2:	ce2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200ed6:	00002697          	auipc	a3,0x2
ffffffffc0200eda:	95268693          	addi	a3,a3,-1710 # ffffffffc0202828 <commands+0x820>
ffffffffc0200ede:	00001617          	auipc	a2,0x1
ffffffffc0200ee2:	69a60613          	addi	a2,a2,1690 # ffffffffc0202578 <commands+0x570>
ffffffffc0200ee6:	13800593          	li	a1,312
ffffffffc0200eea:	00001517          	auipc	a0,0x1
ffffffffc0200eee:	6a650513          	addi	a0,a0,1702 # ffffffffc0202590 <commands+0x588>
ffffffffc0200ef2:	cc2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(p0 + 4 == p1);
ffffffffc0200ef6:	00002697          	auipc	a3,0x2
ffffffffc0200efa:	92268693          	addi	a3,a3,-1758 # ffffffffc0202818 <commands+0x810>
ffffffffc0200efe:	00001617          	auipc	a2,0x1
ffffffffc0200f02:	67a60613          	addi	a2,a2,1658 # ffffffffc0202578 <commands+0x570>
ffffffffc0200f06:	13000593          	li	a1,304
ffffffffc0200f0a:	00001517          	auipc	a0,0x1
ffffffffc0200f0e:	68650513          	addi	a0,a0,1670 # ffffffffc0202590 <commands+0x588>
ffffffffc0200f12:	ca2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200f16:	00002697          	auipc	a3,0x2
ffffffffc0200f1a:	8ea68693          	addi	a3,a3,-1814 # ffffffffc0202800 <commands+0x7f8>
ffffffffc0200f1e:	00001617          	auipc	a2,0x1
ffffffffc0200f22:	65a60613          	addi	a2,a2,1626 # ffffffffc0202578 <commands+0x570>
ffffffffc0200f26:	12f00593          	li	a1,303
ffffffffc0200f2a:	00001517          	auipc	a0,0x1
ffffffffc0200f2e:	66650513          	addi	a0,a0,1638 # ffffffffc0202590 <commands+0x588>
ffffffffc0200f32:	c82ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200f36:	00002697          	auipc	a3,0x2
ffffffffc0200f3a:	8aa68693          	addi	a3,a3,-1878 # ffffffffc02027e0 <commands+0x7d8>
ffffffffc0200f3e:	00001617          	auipc	a2,0x1
ffffffffc0200f42:	63a60613          	addi	a2,a2,1594 # ffffffffc0202578 <commands+0x570>
ffffffffc0200f46:	12e00593          	li	a1,302
ffffffffc0200f4a:	00001517          	auipc	a0,0x1
ffffffffc0200f4e:	64650513          	addi	a0,a0,1606 # ffffffffc0202590 <commands+0x588>
ffffffffc0200f52:	c62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200f56:	00002697          	auipc	a3,0x2
ffffffffc0200f5a:	85a68693          	addi	a3,a3,-1958 # ffffffffc02027b0 <commands+0x7a8>
ffffffffc0200f5e:	00001617          	auipc	a2,0x1
ffffffffc0200f62:	61a60613          	addi	a2,a2,1562 # ffffffffc0202578 <commands+0x570>
ffffffffc0200f66:	12c00593          	li	a1,300
ffffffffc0200f6a:	00001517          	auipc	a0,0x1
ffffffffc0200f6e:	62650513          	addi	a0,a0,1574 # ffffffffc0202590 <commands+0x588>
ffffffffc0200f72:	c42ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f76:	00002697          	auipc	a3,0x2
ffffffffc0200f7a:	82268693          	addi	a3,a3,-2014 # ffffffffc0202798 <commands+0x790>
ffffffffc0200f7e:	00001617          	auipc	a2,0x1
ffffffffc0200f82:	5fa60613          	addi	a2,a2,1530 # ffffffffc0202578 <commands+0x570>
ffffffffc0200f86:	12b00593          	li	a1,299
ffffffffc0200f8a:	00001517          	auipc	a0,0x1
ffffffffc0200f8e:	60650513          	addi	a0,a0,1542 # ffffffffc0202590 <commands+0x588>
ffffffffc0200f92:	c22ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f96:	00001697          	auipc	a3,0x1
ffffffffc0200f9a:	76a68693          	addi	a3,a3,1898 # ffffffffc0202700 <commands+0x6f8>
ffffffffc0200f9e:	00001617          	auipc	a2,0x1
ffffffffc0200fa2:	5da60613          	addi	a2,a2,1498 # ffffffffc0202578 <commands+0x570>
ffffffffc0200fa6:	11f00593          	li	a1,287
ffffffffc0200faa:	00001517          	auipc	a0,0x1
ffffffffc0200fae:	5e650513          	addi	a0,a0,1510 # ffffffffc0202590 <commands+0x588>
ffffffffc0200fb2:	c02ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(!PageProperty(p0));
ffffffffc0200fb6:	00001697          	auipc	a3,0x1
ffffffffc0200fba:	7ca68693          	addi	a3,a3,1994 # ffffffffc0202780 <commands+0x778>
ffffffffc0200fbe:	00001617          	auipc	a2,0x1
ffffffffc0200fc2:	5ba60613          	addi	a2,a2,1466 # ffffffffc0202578 <commands+0x570>
ffffffffc0200fc6:	11600593          	li	a1,278
ffffffffc0200fca:	00001517          	auipc	a0,0x1
ffffffffc0200fce:	5c650513          	addi	a0,a0,1478 # ffffffffc0202590 <commands+0x588>
ffffffffc0200fd2:	be2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(p0 != NULL);
ffffffffc0200fd6:	00001697          	auipc	a3,0x1
ffffffffc0200fda:	79a68693          	addi	a3,a3,1946 # ffffffffc0202770 <commands+0x768>
ffffffffc0200fde:	00001617          	auipc	a2,0x1
ffffffffc0200fe2:	59a60613          	addi	a2,a2,1434 # ffffffffc0202578 <commands+0x570>
ffffffffc0200fe6:	11500593          	li	a1,277
ffffffffc0200fea:	00001517          	auipc	a0,0x1
ffffffffc0200fee:	5a650513          	addi	a0,a0,1446 # ffffffffc0202590 <commands+0x588>
ffffffffc0200ff2:	bc2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(nr_free == 0);
ffffffffc0200ff6:	00001697          	auipc	a3,0x1
ffffffffc0200ffa:	76a68693          	addi	a3,a3,1898 # ffffffffc0202760 <commands+0x758>
ffffffffc0200ffe:	00001617          	auipc	a2,0x1
ffffffffc0201002:	57a60613          	addi	a2,a2,1402 # ffffffffc0202578 <commands+0x570>
ffffffffc0201006:	0f700593          	li	a1,247
ffffffffc020100a:	00001517          	auipc	a0,0x1
ffffffffc020100e:	58650513          	addi	a0,a0,1414 # ffffffffc0202590 <commands+0x588>
ffffffffc0201012:	ba2ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201016:	00001697          	auipc	a3,0x1
ffffffffc020101a:	6ea68693          	addi	a3,a3,1770 # ffffffffc0202700 <commands+0x6f8>
ffffffffc020101e:	00001617          	auipc	a2,0x1
ffffffffc0201022:	55a60613          	addi	a2,a2,1370 # ffffffffc0202578 <commands+0x570>
ffffffffc0201026:	0f500593          	li	a1,245
ffffffffc020102a:	00001517          	auipc	a0,0x1
ffffffffc020102e:	56650513          	addi	a0,a0,1382 # ffffffffc0202590 <commands+0x588>
ffffffffc0201032:	b82ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201036:	00001697          	auipc	a3,0x1
ffffffffc020103a:	70a68693          	addi	a3,a3,1802 # ffffffffc0202740 <commands+0x738>
ffffffffc020103e:	00001617          	auipc	a2,0x1
ffffffffc0201042:	53a60613          	addi	a2,a2,1338 # ffffffffc0202578 <commands+0x570>
ffffffffc0201046:	0f400593          	li	a1,244
ffffffffc020104a:	00001517          	auipc	a0,0x1
ffffffffc020104e:	54650513          	addi	a0,a0,1350 # ffffffffc0202590 <commands+0x588>
ffffffffc0201052:	b62ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0201056 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0201056:	1141                	addi	sp,sp,-16
ffffffffc0201058:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020105a:	14058a63          	beqz	a1,ffffffffc02011ae <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020105e:	00259693          	slli	a3,a1,0x2
ffffffffc0201062:	96ae                	add	a3,a3,a1
ffffffffc0201064:	068e                	slli	a3,a3,0x3
ffffffffc0201066:	96aa                	add	a3,a3,a0
ffffffffc0201068:	87aa                	mv	a5,a0
ffffffffc020106a:	02d50263          	beq	a0,a3,ffffffffc020108e <best_fit_free_pages+0x38>
ffffffffc020106e:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201070:	8b05                	andi	a4,a4,1
ffffffffc0201072:	10071e63          	bnez	a4,ffffffffc020118e <best_fit_free_pages+0x138>
ffffffffc0201076:	6798                	ld	a4,8(a5)
ffffffffc0201078:	8b09                	andi	a4,a4,2
ffffffffc020107a:	10071a63          	bnez	a4,ffffffffc020118e <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc020107e:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201082:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201086:	02878793          	addi	a5,a5,40
ffffffffc020108a:	fed792e3          	bne	a5,a3,ffffffffc020106e <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc020108e:	2581                	sext.w	a1,a1
ffffffffc0201090:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201092:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201096:	4789                	li	a5,2
ffffffffc0201098:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020109c:	00005697          	auipc	a3,0x5
ffffffffc02010a0:	f9468693          	addi	a3,a3,-108 # ffffffffc0206030 <free_area>
ffffffffc02010a4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02010a6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02010a8:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02010ac:	9db9                	addw	a1,a1,a4
ffffffffc02010ae:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02010b0:	0ad78863          	beq	a5,a3,ffffffffc0201160 <best_fit_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02010b4:	fe878713          	addi	a4,a5,-24
ffffffffc02010b8:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02010bc:	4581                	li	a1,0
            if (base < page) {
ffffffffc02010be:	00e56a63          	bltu	a0,a4,ffffffffc02010d2 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc02010c2:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02010c4:	06d70263          	beq	a4,a3,ffffffffc0201128 <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02010c8:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02010ca:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02010ce:	fee57ae3          	bgeu	a0,a4,ffffffffc02010c2 <best_fit_free_pages+0x6c>
ffffffffc02010d2:	c199                	beqz	a1,ffffffffc02010d8 <best_fit_free_pages+0x82>
ffffffffc02010d4:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02010d8:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02010da:	e390                	sd	a2,0(a5)
ffffffffc02010dc:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02010de:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02010e0:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02010e2:	02d70063          	beq	a4,a3,ffffffffc0201102 <best_fit_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc02010e6:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02010ea:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc02010ee:	02081613          	slli	a2,a6,0x20
ffffffffc02010f2:	9201                	srli	a2,a2,0x20
ffffffffc02010f4:	00261793          	slli	a5,a2,0x2
ffffffffc02010f8:	97b2                	add	a5,a5,a2
ffffffffc02010fa:	078e                	slli	a5,a5,0x3
ffffffffc02010fc:	97ae                	add	a5,a5,a1
ffffffffc02010fe:	02f50f63          	beq	a0,a5,ffffffffc020113c <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc0201102:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0201104:	00d70f63          	beq	a4,a3,ffffffffc0201122 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0201108:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc020110a:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc020110e:	02059613          	slli	a2,a1,0x20
ffffffffc0201112:	9201                	srli	a2,a2,0x20
ffffffffc0201114:	00261793          	slli	a5,a2,0x2
ffffffffc0201118:	97b2                	add	a5,a5,a2
ffffffffc020111a:	078e                	slli	a5,a5,0x3
ffffffffc020111c:	97aa                	add	a5,a5,a0
ffffffffc020111e:	04f68863          	beq	a3,a5,ffffffffc020116e <best_fit_free_pages+0x118>
}
ffffffffc0201122:	60a2                	ld	ra,8(sp)
ffffffffc0201124:	0141                	addi	sp,sp,16
ffffffffc0201126:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201128:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020112a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020112c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020112e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201130:	02d70563          	beq	a4,a3,ffffffffc020115a <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201134:	8832                	mv	a6,a2
ffffffffc0201136:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201138:	87ba                	mv	a5,a4
ffffffffc020113a:	bf41                	j	ffffffffc02010ca <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc020113c:	491c                	lw	a5,16(a0)
ffffffffc020113e:	0107883b          	addw	a6,a5,a6
ffffffffc0201142:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201146:	57f5                	li	a5,-3
ffffffffc0201148:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020114c:	6d10                	ld	a2,24(a0)
ffffffffc020114e:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201150:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc0201152:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201154:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201156:	e390                	sd	a2,0(a5)
ffffffffc0201158:	b775                	j	ffffffffc0201104 <best_fit_free_pages+0xae>
ffffffffc020115a:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020115c:	873e                	mv	a4,a5
ffffffffc020115e:	b761                	j	ffffffffc02010e6 <best_fit_free_pages+0x90>
}
ffffffffc0201160:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201162:	e390                	sd	a2,0(a5)
ffffffffc0201164:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201166:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201168:	ed1c                	sd	a5,24(a0)
ffffffffc020116a:	0141                	addi	sp,sp,16
ffffffffc020116c:	8082                	ret
            base->property += p->property;
ffffffffc020116e:	ff872783          	lw	a5,-8(a4)
ffffffffc0201172:	ff070693          	addi	a3,a4,-16
ffffffffc0201176:	9dbd                	addw	a1,a1,a5
ffffffffc0201178:	c90c                	sw	a1,16(a0)
ffffffffc020117a:	57f5                	li	a5,-3
ffffffffc020117c:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201180:	6314                	ld	a3,0(a4)
ffffffffc0201182:	671c                	ld	a5,8(a4)
}
ffffffffc0201184:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201186:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201188:	e394                	sd	a3,0(a5)
ffffffffc020118a:	0141                	addi	sp,sp,16
ffffffffc020118c:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020118e:	00001697          	auipc	a3,0x1
ffffffffc0201192:	6da68693          	addi	a3,a3,1754 # ffffffffc0202868 <commands+0x860>
ffffffffc0201196:	00001617          	auipc	a2,0x1
ffffffffc020119a:	3e260613          	addi	a2,a2,994 # ffffffffc0202578 <commands+0x570>
ffffffffc020119e:	09100593          	li	a1,145
ffffffffc02011a2:	00001517          	auipc	a0,0x1
ffffffffc02011a6:	3ee50513          	addi	a0,a0,1006 # ffffffffc0202590 <commands+0x588>
ffffffffc02011aa:	a0aff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(n > 0);
ffffffffc02011ae:	00001697          	auipc	a3,0x1
ffffffffc02011b2:	3c268693          	addi	a3,a3,962 # ffffffffc0202570 <commands+0x568>
ffffffffc02011b6:	00001617          	auipc	a2,0x1
ffffffffc02011ba:	3c260613          	addi	a2,a2,962 # ffffffffc0202578 <commands+0x570>
ffffffffc02011be:	08e00593          	li	a1,142
ffffffffc02011c2:	00001517          	auipc	a0,0x1
ffffffffc02011c6:	3ce50513          	addi	a0,a0,974 # ffffffffc0202590 <commands+0x588>
ffffffffc02011ca:	9eaff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02011ce <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc02011ce:	1141                	addi	sp,sp,-16
ffffffffc02011d0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02011d2:	c9e1                	beqz	a1,ffffffffc02012a2 <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02011d4:	00259693          	slli	a3,a1,0x2
ffffffffc02011d8:	96ae                	add	a3,a3,a1
ffffffffc02011da:	068e                	slli	a3,a3,0x3
ffffffffc02011dc:	96aa                	add	a3,a3,a0
ffffffffc02011de:	87aa                	mv	a5,a0
ffffffffc02011e0:	00d50f63          	beq	a0,a3,ffffffffc02011fe <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02011e4:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02011e6:	8b05                	andi	a4,a4,1
ffffffffc02011e8:	cf49                	beqz	a4,ffffffffc0201282 <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02011ea:	0007a823          	sw	zero,16(a5)
ffffffffc02011ee:	0007b423          	sd	zero,8(a5)
ffffffffc02011f2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02011f6:	02878793          	addi	a5,a5,40
ffffffffc02011fa:	fed795e3          	bne	a5,a3,ffffffffc02011e4 <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc02011fe:	2581                	sext.w	a1,a1
ffffffffc0201200:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201202:	4789                	li	a5,2
ffffffffc0201204:	00850713          	addi	a4,a0,8
ffffffffc0201208:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020120c:	00005697          	auipc	a3,0x5
ffffffffc0201210:	e2468693          	addi	a3,a3,-476 # ffffffffc0206030 <free_area>
ffffffffc0201214:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201216:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201218:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020121c:	9db9                	addw	a1,a1,a4
ffffffffc020121e:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201220:	04d78a63          	beq	a5,a3,ffffffffc0201274 <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201224:	fe878713          	addi	a4,a5,-24
ffffffffc0201228:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020122c:	4581                	li	a1,0
             if (base < page) {
ffffffffc020122e:	00e56a63          	bltu	a0,a4,ffffffffc0201242 <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc0201232:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201234:	02d70263          	beq	a4,a3,ffffffffc0201258 <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc0201238:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020123a:	fe878713          	addi	a4,a5,-24
             if (base < page) {
ffffffffc020123e:	fee57ae3          	bgeu	a0,a4,ffffffffc0201232 <best_fit_init_memmap+0x64>
ffffffffc0201242:	c199                	beqz	a1,ffffffffc0201248 <best_fit_init_memmap+0x7a>
ffffffffc0201244:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201248:	6398                	ld	a4,0(a5)
}
ffffffffc020124a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020124c:	e390                	sd	a2,0(a5)
ffffffffc020124e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201250:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201252:	ed18                	sd	a4,24(a0)
ffffffffc0201254:	0141                	addi	sp,sp,16
ffffffffc0201256:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201258:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020125a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020125c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020125e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201260:	00d70663          	beq	a4,a3,ffffffffc020126c <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc0201264:	8832                	mv	a6,a2
ffffffffc0201266:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201268:	87ba                	mv	a5,a4
ffffffffc020126a:	bfc1                	j	ffffffffc020123a <best_fit_init_memmap+0x6c>
}
ffffffffc020126c:	60a2                	ld	ra,8(sp)
ffffffffc020126e:	e290                	sd	a2,0(a3)
ffffffffc0201270:	0141                	addi	sp,sp,16
ffffffffc0201272:	8082                	ret
ffffffffc0201274:	60a2                	ld	ra,8(sp)
ffffffffc0201276:	e390                	sd	a2,0(a5)
ffffffffc0201278:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020127a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020127c:	ed1c                	sd	a5,24(a0)
ffffffffc020127e:	0141                	addi	sp,sp,16
ffffffffc0201280:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201282:	00001697          	auipc	a3,0x1
ffffffffc0201286:	60e68693          	addi	a3,a3,1550 # ffffffffc0202890 <commands+0x888>
ffffffffc020128a:	00001617          	auipc	a2,0x1
ffffffffc020128e:	2ee60613          	addi	a2,a2,750 # ffffffffc0202578 <commands+0x570>
ffffffffc0201292:	04a00593          	li	a1,74
ffffffffc0201296:	00001517          	auipc	a0,0x1
ffffffffc020129a:	2fa50513          	addi	a0,a0,762 # ffffffffc0202590 <commands+0x588>
ffffffffc020129e:	916ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
    assert(n > 0);
ffffffffc02012a2:	00001697          	auipc	a3,0x1
ffffffffc02012a6:	2ce68693          	addi	a3,a3,718 # ffffffffc0202570 <commands+0x568>
ffffffffc02012aa:	00001617          	auipc	a2,0x1
ffffffffc02012ae:	2ce60613          	addi	a2,a2,718 # ffffffffc0202578 <commands+0x570>
ffffffffc02012b2:	04700593          	li	a1,71
ffffffffc02012b6:	00001517          	auipc	a0,0x1
ffffffffc02012ba:	2da50513          	addi	a0,a0,730 # ffffffffc0202590 <commands+0x588>
ffffffffc02012be:	8f6ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02012c2 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02012c2:	100027f3          	csrr	a5,sstatus
ffffffffc02012c6:	8b89                	andi	a5,a5,2
ffffffffc02012c8:	e799                	bnez	a5,ffffffffc02012d6 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02012ca:	00005797          	auipc	a5,0x5
ffffffffc02012ce:	1a67b783          	ld	a5,422(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc02012d2:	6f9c                	ld	a5,24(a5)
ffffffffc02012d4:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02012d6:	1141                	addi	sp,sp,-16
ffffffffc02012d8:	e406                	sd	ra,8(sp)
ffffffffc02012da:	e022                	sd	s0,0(sp)
ffffffffc02012dc:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02012de:	988ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02012e2:	00005797          	auipc	a5,0x5
ffffffffc02012e6:	18e7b783          	ld	a5,398(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc02012ea:	6f9c                	ld	a5,24(a5)
ffffffffc02012ec:	8522                	mv	a0,s0
ffffffffc02012ee:	9782                	jalr	a5
ffffffffc02012f0:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02012f2:	96eff0ef          	jal	ra,ffffffffc0200460 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02012f6:	60a2                	ld	ra,8(sp)
ffffffffc02012f8:	8522                	mv	a0,s0
ffffffffc02012fa:	6402                	ld	s0,0(sp)
ffffffffc02012fc:	0141                	addi	sp,sp,16
ffffffffc02012fe:	8082                	ret

ffffffffc0201300 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201300:	100027f3          	csrr	a5,sstatus
ffffffffc0201304:	8b89                	andi	a5,a5,2
ffffffffc0201306:	e799                	bnez	a5,ffffffffc0201314 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201308:	00005797          	auipc	a5,0x5
ffffffffc020130c:	1687b783          	ld	a5,360(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc0201310:	739c                	ld	a5,32(a5)
ffffffffc0201312:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201314:	1101                	addi	sp,sp,-32
ffffffffc0201316:	ec06                	sd	ra,24(sp)
ffffffffc0201318:	e822                	sd	s0,16(sp)
ffffffffc020131a:	e426                	sd	s1,8(sp)
ffffffffc020131c:	842a                	mv	s0,a0
ffffffffc020131e:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201320:	946ff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201324:	00005797          	auipc	a5,0x5
ffffffffc0201328:	14c7b783          	ld	a5,332(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc020132c:	739c                	ld	a5,32(a5)
ffffffffc020132e:	85a6                	mv	a1,s1
ffffffffc0201330:	8522                	mv	a0,s0
ffffffffc0201332:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201334:	6442                	ld	s0,16(sp)
ffffffffc0201336:	60e2                	ld	ra,24(sp)
ffffffffc0201338:	64a2                	ld	s1,8(sp)
ffffffffc020133a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020133c:	924ff06f          	j	ffffffffc0200460 <intr_enable>

ffffffffc0201340 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201340:	100027f3          	csrr	a5,sstatus
ffffffffc0201344:	8b89                	andi	a5,a5,2
ffffffffc0201346:	e799                	bnez	a5,ffffffffc0201354 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201348:	00005797          	auipc	a5,0x5
ffffffffc020134c:	1287b783          	ld	a5,296(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc0201350:	779c                	ld	a5,40(a5)
ffffffffc0201352:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201354:	1141                	addi	sp,sp,-16
ffffffffc0201356:	e406                	sd	ra,8(sp)
ffffffffc0201358:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020135a:	90cff0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020135e:	00005797          	auipc	a5,0x5
ffffffffc0201362:	1127b783          	ld	a5,274(a5) # ffffffffc0206470 <pmm_manager>
ffffffffc0201366:	779c                	ld	a5,40(a5)
ffffffffc0201368:	9782                	jalr	a5
ffffffffc020136a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020136c:	8f4ff0ef          	jal	ra,ffffffffc0200460 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201370:	60a2                	ld	ra,8(sp)
ffffffffc0201372:	8522                	mv	a0,s0
ffffffffc0201374:	6402                	ld	s0,0(sp)
ffffffffc0201376:	0141                	addi	sp,sp,16
ffffffffc0201378:	8082                	ret

ffffffffc020137a <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc020137a:	00001797          	auipc	a5,0x1
ffffffffc020137e:	53e78793          	addi	a5,a5,1342 # ffffffffc02028b8 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201382:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201384:	1101                	addi	sp,sp,-32
ffffffffc0201386:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201388:	00001517          	auipc	a0,0x1
ffffffffc020138c:	56850513          	addi	a0,a0,1384 # ffffffffc02028f0 <best_fit_pmm_manager+0x38>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201390:	00005497          	auipc	s1,0x5
ffffffffc0201394:	0e048493          	addi	s1,s1,224 # ffffffffc0206470 <pmm_manager>
void pmm_init(void) {
ffffffffc0201398:	ec06                	sd	ra,24(sp)
ffffffffc020139a:	e822                	sd	s0,16(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc020139c:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020139e:	d1dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc02013a2:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02013a4:	00005417          	auipc	s0,0x5
ffffffffc02013a8:	0e440413          	addi	s0,s0,228 # ffffffffc0206488 <va_pa_offset>
    pmm_manager->init();
ffffffffc02013ac:	679c                	ld	a5,8(a5)
ffffffffc02013ae:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02013b0:	57f5                	li	a5,-3
ffffffffc02013b2:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02013b4:	00001517          	auipc	a0,0x1
ffffffffc02013b8:	55450513          	addi	a0,a0,1364 # ffffffffc0202908 <best_fit_pmm_manager+0x50>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02013bc:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc02013be:	cfdfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02013c2:	46c5                	li	a3,17
ffffffffc02013c4:	06ee                	slli	a3,a3,0x1b
ffffffffc02013c6:	40100613          	li	a2,1025
ffffffffc02013ca:	16fd                	addi	a3,a3,-1
ffffffffc02013cc:	07e005b7          	lui	a1,0x7e00
ffffffffc02013d0:	0656                	slli	a2,a2,0x15
ffffffffc02013d2:	00001517          	auipc	a0,0x1
ffffffffc02013d6:	54e50513          	addi	a0,a0,1358 # ffffffffc0202920 <best_fit_pmm_manager+0x68>
ffffffffc02013da:	ce1fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02013de:	777d                	lui	a4,0xfffff
ffffffffc02013e0:	00006797          	auipc	a5,0x6
ffffffffc02013e4:	0bf78793          	addi	a5,a5,191 # ffffffffc020749f <end+0xfff>
ffffffffc02013e8:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc02013ea:	00005517          	auipc	a0,0x5
ffffffffc02013ee:	07650513          	addi	a0,a0,118 # ffffffffc0206460 <npage>
ffffffffc02013f2:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02013f6:	00005597          	auipc	a1,0x5
ffffffffc02013fa:	07258593          	addi	a1,a1,114 # ffffffffc0206468 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02013fe:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201400:	e19c                	sd	a5,0(a1)
ffffffffc0201402:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201404:	4701                	li	a4,0
ffffffffc0201406:	4885                	li	a7,1
ffffffffc0201408:	fff80837          	lui	a6,0xfff80
ffffffffc020140c:	a011                	j	ffffffffc0201410 <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc020140e:	619c                	ld	a5,0(a1)
ffffffffc0201410:	97b6                	add	a5,a5,a3
ffffffffc0201412:	07a1                	addi	a5,a5,8
ffffffffc0201414:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201418:	611c                	ld	a5,0(a0)
ffffffffc020141a:	0705                	addi	a4,a4,1
ffffffffc020141c:	02868693          	addi	a3,a3,40
ffffffffc0201420:	01078633          	add	a2,a5,a6
ffffffffc0201424:	fec765e3          	bltu	a4,a2,ffffffffc020140e <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201428:	6190                	ld	a2,0(a1)
ffffffffc020142a:	00279713          	slli	a4,a5,0x2
ffffffffc020142e:	973e                	add	a4,a4,a5
ffffffffc0201430:	fec006b7          	lui	a3,0xfec00
ffffffffc0201434:	070e                	slli	a4,a4,0x3
ffffffffc0201436:	96b2                	add	a3,a3,a2
ffffffffc0201438:	96ba                	add	a3,a3,a4
ffffffffc020143a:	c0200737          	lui	a4,0xc0200
ffffffffc020143e:	08e6ef63          	bltu	a3,a4,ffffffffc02014dc <pmm_init+0x162>
ffffffffc0201442:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc0201444:	45c5                	li	a1,17
ffffffffc0201446:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201448:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc020144a:	04b6e863          	bltu	a3,a1,ffffffffc020149a <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020144e:	609c                	ld	a5,0(s1)
ffffffffc0201450:	7b9c                	ld	a5,48(a5)
ffffffffc0201452:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201454:	00001517          	auipc	a0,0x1
ffffffffc0201458:	56450513          	addi	a0,a0,1380 # ffffffffc02029b8 <best_fit_pmm_manager+0x100>
ffffffffc020145c:	c5ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201460:	00004597          	auipc	a1,0x4
ffffffffc0201464:	ba058593          	addi	a1,a1,-1120 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0201468:	00005797          	auipc	a5,0x5
ffffffffc020146c:	00b7bc23          	sd	a1,24(a5) # ffffffffc0206480 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201470:	c02007b7          	lui	a5,0xc0200
ffffffffc0201474:	08f5e063          	bltu	a1,a5,ffffffffc02014f4 <pmm_init+0x17a>
ffffffffc0201478:	6010                	ld	a2,0(s0)
}
ffffffffc020147a:	6442                	ld	s0,16(sp)
ffffffffc020147c:	60e2                	ld	ra,24(sp)
ffffffffc020147e:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201480:	40c58633          	sub	a2,a1,a2
ffffffffc0201484:	00005797          	auipc	a5,0x5
ffffffffc0201488:	fec7ba23          	sd	a2,-12(a5) # ffffffffc0206478 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020148c:	00001517          	auipc	a0,0x1
ffffffffc0201490:	54c50513          	addi	a0,a0,1356 # ffffffffc02029d8 <best_fit_pmm_manager+0x120>
}
ffffffffc0201494:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201496:	c25fe06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020149a:	6705                	lui	a4,0x1
ffffffffc020149c:	177d                	addi	a4,a4,-1
ffffffffc020149e:	96ba                	add	a3,a3,a4
ffffffffc02014a0:	777d                	lui	a4,0xfffff
ffffffffc02014a2:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02014a4:	00c6d513          	srli	a0,a3,0xc
ffffffffc02014a8:	00f57e63          	bgeu	a0,a5,ffffffffc02014c4 <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc02014ac:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02014ae:	982a                	add	a6,a6,a0
ffffffffc02014b0:	00281513          	slli	a0,a6,0x2
ffffffffc02014b4:	9542                	add	a0,a0,a6
ffffffffc02014b6:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02014b8:	8d95                	sub	a1,a1,a3
ffffffffc02014ba:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02014bc:	81b1                	srli	a1,a1,0xc
ffffffffc02014be:	9532                	add	a0,a0,a2
ffffffffc02014c0:	9782                	jalr	a5
}
ffffffffc02014c2:	b771                	j	ffffffffc020144e <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc02014c4:	00001617          	auipc	a2,0x1
ffffffffc02014c8:	4c460613          	addi	a2,a2,1220 # ffffffffc0202988 <best_fit_pmm_manager+0xd0>
ffffffffc02014cc:	06b00593          	li	a1,107
ffffffffc02014d0:	00001517          	auipc	a0,0x1
ffffffffc02014d4:	4d850513          	addi	a0,a0,1240 # ffffffffc02029a8 <best_fit_pmm_manager+0xf0>
ffffffffc02014d8:	eddfe0ef          	jal	ra,ffffffffc02003b4 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02014dc:	00001617          	auipc	a2,0x1
ffffffffc02014e0:	47460613          	addi	a2,a2,1140 # ffffffffc0202950 <best_fit_pmm_manager+0x98>
ffffffffc02014e4:	07200593          	li	a1,114
ffffffffc02014e8:	00001517          	auipc	a0,0x1
ffffffffc02014ec:	49050513          	addi	a0,a0,1168 # ffffffffc0202978 <best_fit_pmm_manager+0xc0>
ffffffffc02014f0:	ec5fe0ef          	jal	ra,ffffffffc02003b4 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc02014f4:	86ae                	mv	a3,a1
ffffffffc02014f6:	00001617          	auipc	a2,0x1
ffffffffc02014fa:	45a60613          	addi	a2,a2,1114 # ffffffffc0202950 <best_fit_pmm_manager+0x98>
ffffffffc02014fe:	08d00593          	li	a1,141
ffffffffc0201502:	00001517          	auipc	a0,0x1
ffffffffc0201506:	47650513          	addi	a0,a0,1142 # ffffffffc0202978 <best_fit_pmm_manager+0xc0>
ffffffffc020150a:	eabfe0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020150e <obj_free>:
// 将一个size大小的新块加入链表
static void obj_free(void *block, int size)
{
	obj_t *cur, *b = (obj_t *)block;

	if (!block)
ffffffffc020150e:	cd1d                	beqz	a0,ffffffffc020154c <obj_free+0x3e>
		return;

	if (size)
ffffffffc0201510:	ed9d                	bnez	a1,ffffffffc020154e <obj_free+0x40>
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->objsize == cur->next) {
ffffffffc0201512:	4114                	lw	a3,0(a0)
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201514:	00005597          	auipc	a1,0x5
ffffffffc0201518:	afc58593          	addi	a1,a1,-1284 # ffffffffc0206010 <objfree>
ffffffffc020151c:	619c                	ld	a5,0(a1)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020151e:	873e                	mv	a4,a5
	for (cur = objfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201520:	679c                	ld	a5,8(a5)
ffffffffc0201522:	02a77b63          	bgeu	a4,a0,ffffffffc0201558 <obj_free+0x4a>
ffffffffc0201526:	00f56463          	bltu	a0,a5,ffffffffc020152e <obj_free+0x20>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020152a:	fef76ae3          	bltu	a4,a5,ffffffffc020151e <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc020152e:	00469613          	slli	a2,a3,0x4
ffffffffc0201532:	962a                	add	a2,a2,a0
ffffffffc0201534:	02c78b63          	beq	a5,a2,ffffffffc020156a <obj_free+0x5c>
		b->objsize += cur->next->objsize;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->objsize == b) {
ffffffffc0201538:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc020153a:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc020153c:	00469793          	slli	a5,a3,0x4
ffffffffc0201540:	97ba                	add	a5,a5,a4
ffffffffc0201542:	02f50f63          	beq	a0,a5,ffffffffc0201580 <obj_free+0x72>
		cur->objsize += b->objsize;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
ffffffffc0201546:	e708                	sd	a0,8(a4)
    
    // 更新空闲块位置
	objfree = cur;
ffffffffc0201548:	e198                	sd	a4,0(a1)
ffffffffc020154a:	8082                	ret
}
ffffffffc020154c:	8082                	ret
		b->objsize = OBJ_UNITS(size);  
ffffffffc020154e:	00f5869b          	addiw	a3,a1,15
ffffffffc0201552:	8691                	srai	a3,a3,0x4
ffffffffc0201554:	c114                	sw	a3,0(a0)
ffffffffc0201556:	bf7d                	j	ffffffffc0201514 <obj_free+0x6>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201558:	fcf763e3          	bltu	a4,a5,ffffffffc020151e <obj_free+0x10>
ffffffffc020155c:	fcf571e3          	bgeu	a0,a5,ffffffffc020151e <obj_free+0x10>
	if (b + b->objsize == cur->next) {
ffffffffc0201560:	00469613          	slli	a2,a3,0x4
ffffffffc0201564:	962a                	add	a2,a2,a0
ffffffffc0201566:	fcc799e3          	bne	a5,a2,ffffffffc0201538 <obj_free+0x2a>
		b->objsize += cur->next->objsize;
ffffffffc020156a:	4390                	lw	a2,0(a5)
		b->next = cur->next->next;
ffffffffc020156c:	679c                	ld	a5,8(a5)
		b->objsize += cur->next->objsize;
ffffffffc020156e:	9eb1                	addw	a3,a3,a2
ffffffffc0201570:	c114                	sw	a3,0(a0)
	if (cur + cur->objsize == b) {
ffffffffc0201572:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201574:	e51c                	sd	a5,8(a0)
	if (cur + cur->objsize == b) {
ffffffffc0201576:	00469793          	slli	a5,a3,0x4
ffffffffc020157a:	97ba                	add	a5,a5,a4
ffffffffc020157c:	fcf515e3          	bne	a0,a5,ffffffffc0201546 <obj_free+0x38>
		cur->objsize += b->objsize;
ffffffffc0201580:	411c                	lw	a5,0(a0)
		cur->next = b->next;
ffffffffc0201582:	6510                	ld	a2,8(a0)
	objfree = cur;
ffffffffc0201584:	e198                	sd	a4,0(a1)
		cur->objsize += b->objsize;
ffffffffc0201586:	9ebd                	addw	a3,a3,a5
ffffffffc0201588:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc020158a:	e710                	sd	a2,8(a4)
	objfree = cur;
ffffffffc020158c:	8082                	ret

ffffffffc020158e <obj_alloc>:

// 小块分配(传入size是算上头部obj_t的)
static void *obj_alloc(size_t size)
{
ffffffffc020158e:	1101                	addi	sp,sp,-32
ffffffffc0201590:	ec06                	sd	ra,24(sp)
ffffffffc0201592:	e822                	sd	s0,16(sp)
ffffffffc0201594:	e426                	sd	s1,8(sp)
ffffffffc0201596:	e04a                	sd	s2,0(sp)
	assert(size < PGSIZE);
ffffffffc0201598:	6785                	lui	a5,0x1
ffffffffc020159a:	08f57363          	bgeu	a0,a5,ffffffffc0201620 <obj_alloc+0x92>

	obj_t *prev, *cur;
	int objsize = OBJ_UNITS(size);

	prev = objfree;  // 从头遍历小块链表
ffffffffc020159e:	00005417          	auipc	s0,0x5
ffffffffc02015a2:	a7240413          	addi	s0,s0,-1422 # ffffffffc0206010 <objfree>
ffffffffc02015a6:	6010                	ld	a2,0(s0)
	int objsize = OBJ_UNITS(size);
ffffffffc02015a8:	053d                	addi	a0,a0,15
ffffffffc02015aa:	00455913          	srli	s2,a0,0x4
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02015ae:	6618                	ld	a4,8(a2)
	int objsize = OBJ_UNITS(size);
ffffffffc02015b0:	0009049b          	sext.w	s1,s2
		
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc02015b4:	4314                	lw	a3,0(a4)
ffffffffc02015b6:	0696d263          	bge	a3,s1,ffffffffc020161a <obj_alloc+0x8c>
			}
			objfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc02015ba:	00e60a63          	beq	a2,a4,ffffffffc02015ce <obj_alloc+0x40>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02015be:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc02015c0:	4394                	lw	a3,0(a5)
ffffffffc02015c2:	0296d363          	bge	a3,s1,ffffffffc02015e8 <obj_alloc+0x5a>
		if (cur == objfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc02015c6:	6010                	ld	a2,0(s0)
ffffffffc02015c8:	873e                	mv	a4,a5
ffffffffc02015ca:	fee61ae3          	bne	a2,a4,ffffffffc02015be <obj_alloc+0x30>

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (obj_t *)alloc_pages(1);  
ffffffffc02015ce:	4505                	li	a0,1
ffffffffc02015d0:	cf3ff0ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
ffffffffc02015d4:	87aa                	mv	a5,a0
			if (!cur)  // 如果获取失败，返回 0
ffffffffc02015d6:	c51d                	beqz	a0,ffffffffc0201604 <obj_alloc+0x76>
				return 0;

			obj_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
ffffffffc02015d8:	6585                	lui	a1,0x1
ffffffffc02015da:	f35ff0ef          	jal	ra,ffffffffc020150e <obj_free>
			cur = objfree;  // 从新分配的页再次循环
ffffffffc02015de:	6018                	ld	a4,0(s0)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02015e0:	671c                	ld	a5,8(a4)
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc02015e2:	4394                	lw	a3,0(a5)
ffffffffc02015e4:	fe96c1e3          	blt	a3,s1,ffffffffc02015c6 <obj_alloc+0x38>
			if (cur->objsize == objsize)
ffffffffc02015e8:	02d48563          	beq	s1,a3,ffffffffc0201612 <obj_alloc+0x84>
				prev->next = cur + objsize;  
ffffffffc02015ec:	0912                	slli	s2,s2,0x4
ffffffffc02015ee:	993e                	add	s2,s2,a5
ffffffffc02015f0:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8b68>
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc02015f4:	6790                	ld	a2,8(a5)
				prev->next->objsize = cur->objsize - objsize;
ffffffffc02015f6:	9e85                	subw	a3,a3,s1
ffffffffc02015f8:	00d92023          	sw	a3,0(s2)
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc02015fc:	00c93423          	sd	a2,8(s2)
				cur->objsize = objsize;  // units大小的块被取出
ffffffffc0201600:	c384                	sw	s1,0(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201602:	e018                	sd	a4,0(s0)
		}
	}
}
ffffffffc0201604:	60e2                	ld	ra,24(sp)
ffffffffc0201606:	6442                	ld	s0,16(sp)
ffffffffc0201608:	64a2                	ld	s1,8(sp)
ffffffffc020160a:	6902                	ld	s2,0(sp)
ffffffffc020160c:	853e                	mv	a0,a5
ffffffffc020160e:	6105                	addi	sp,sp,32
ffffffffc0201610:	8082                	ret
				prev->next = cur->next;
ffffffffc0201612:	6794                	ld	a3,8(a5)
			objfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201614:	e018                	sd	a4,0(s0)
				prev->next = cur->next;
ffffffffc0201616:	e714                	sd	a3,8(a4)
			return cur;
ffffffffc0201618:	b7f5                	j	ffffffffc0201604 <obj_alloc+0x76>
        if (cur->objsize >= objsize) { // 如果当前足够大
ffffffffc020161a:	87ba                	mv	a5,a4
ffffffffc020161c:	8732                	mv	a4,a2
ffffffffc020161e:	b7e9                	j	ffffffffc02015e8 <obj_alloc+0x5a>
	assert(size < PGSIZE);
ffffffffc0201620:	00001697          	auipc	a3,0x1
ffffffffc0201624:	3f868693          	addi	a3,a3,1016 # ffffffffc0202a18 <best_fit_pmm_manager+0x160>
ffffffffc0201628:	00001617          	auipc	a2,0x1
ffffffffc020162c:	f5060613          	addi	a2,a2,-176 # ffffffffc0202578 <commands+0x570>
ffffffffc0201630:	04a00593          	li	a1,74
ffffffffc0201634:	00001517          	auipc	a0,0x1
ffffffffc0201638:	3f450513          	addi	a0,a0,1012 # ffffffffc0202a28 <best_fit_pmm_manager+0x170>
ffffffffc020163c:	d79fe0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0201640 <slub_alloc.part.0>:
		order++;
	return order;
}

// 总slub分配算法(传入申请的大小)
void *slub_alloc(size_t size)
ffffffffc0201640:	1101                	addi	sp,sp,-32
ffffffffc0201642:	e822                	sd	s0,16(sp)
ffffffffc0201644:	842a                	mv	s0,a0
		m = obj_alloc(size + OBJ_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc0201646:	02000513          	li	a0,32
void *slub_alloc(size_t size)
ffffffffc020164a:	ec06                	sd	ra,24(sp)
ffffffffc020164c:	e426                	sd	s1,8(sp)
	bb = obj_alloc(sizeof(bigblock_t));
ffffffffc020164e:	f41ff0ef          	jal	ra,ffffffffc020158e <obj_alloc>
	if (!bb)
ffffffffc0201652:	cd05                	beqz	a0,ffffffffc020168a <slub_alloc.part.0+0x4a>
		return 0;
    
    // 分配大页
	bb->order = ((size - 1) >> PGSHIFT) + 1;  // PGSHIFT为12，向右移12位的效果相当于除以2^12即4096）
ffffffffc0201654:	fff40793          	addi	a5,s0,-1
ffffffffc0201658:	83b1                	srli	a5,a5,0xc
ffffffffc020165a:	84aa                	mv	s1,a0
ffffffffc020165c:	0017851b          	addiw	a0,a5,1
ffffffffc0201660:	c088                	sw	a0,0(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc0201662:	c61ff0ef          	jal	ra,ffffffffc02012c2 <alloc_pages>
    
	// 设置大块标志
    bb->is_bigblock = 1;
ffffffffc0201666:	4785                	li	a5,1
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc0201668:	e488                	sd	a0,8(s1)
    bb->is_bigblock = 1;
ffffffffc020166a:	cc9c                	sw	a5,24(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc020166c:	842a                	mv	s0,a0
    
	// 分配成功，将其插入到大块链表的头部。
	if (bb->pages) {
ffffffffc020166e:	c50d                	beqz	a0,ffffffffc0201698 <slub_alloc.part.0+0x58>
		bb->next = bigblocks_head;
ffffffffc0201670:	00005797          	auipc	a5,0x5
ffffffffc0201674:	e2078793          	addi	a5,a5,-480 # ffffffffc0206490 <bigblocks_head>
ffffffffc0201678:	6398                	ld	a4,0(a5)
	}
    
    // 如果页分配失败，释放之前为bigblock_t结构体分配的内存。返回0。
	obj_free(bb, sizeof(bigblock_t));
	return 0;
}
ffffffffc020167a:	60e2                	ld	ra,24(sp)
ffffffffc020167c:	8522                	mv	a0,s0
ffffffffc020167e:	6442                	ld	s0,16(sp)
		bigblocks_head = bb;
ffffffffc0201680:	e384                	sd	s1,0(a5)
		bb->next = bigblocks_head;
ffffffffc0201682:	e898                	sd	a4,16(s1)
}
ffffffffc0201684:	64a2                	ld	s1,8(sp)
ffffffffc0201686:	6105                	addi	sp,sp,32
ffffffffc0201688:	8082                	ret
		return 0;
ffffffffc020168a:	4401                	li	s0,0
}
ffffffffc020168c:	60e2                	ld	ra,24(sp)
ffffffffc020168e:	8522                	mv	a0,s0
ffffffffc0201690:	6442                	ld	s0,16(sp)
ffffffffc0201692:	64a2                	ld	s1,8(sp)
ffffffffc0201694:	6105                	addi	sp,sp,32
ffffffffc0201696:	8082                	ret
	obj_free(bb, sizeof(bigblock_t));
ffffffffc0201698:	8526                	mv	a0,s1
ffffffffc020169a:	02000593          	li	a1,32
ffffffffc020169e:	e71ff0ef          	jal	ra,ffffffffc020150e <obj_free>
}
ffffffffc02016a2:	60e2                	ld	ra,24(sp)
ffffffffc02016a4:	8522                	mv	a0,s0
ffffffffc02016a6:	6442                	ld	s0,16(sp)
ffffffffc02016a8:	64a2                	ld	s1,8(sp)
ffffffffc02016aa:	6105                	addi	sp,sp,32
ffffffffc02016ac:	8082                	ret

ffffffffc02016ae <slub_free>:
{
    // bb用于遍历记录大块内存的链表。
    // last用于指向链表中前一个节点的next指针
	bigblock_t *bb, **last = &bigblocks_head;

	if (!block)
ffffffffc02016ae:	cd21                	beqz	a0,ffffffffc0201706 <slub_free+0x58>
		return;

	// 判断是否是大块
    if (!((unsigned long)block & (PGSIZE - 1))) {
ffffffffc02016b0:	03451793          	slli	a5,a0,0x34
ffffffffc02016b4:	e7b1                	bnez	a5,ffffffffc0201700 <slub_free+0x52>
{
ffffffffc02016b6:	1141                	addi	sp,sp,-16
        /* 遍历大块链表 */
        for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc02016b8:	00005717          	auipc	a4,0x5
ffffffffc02016bc:	dd870713          	addi	a4,a4,-552 # ffffffffc0206490 <bigblocks_head>
{
ffffffffc02016c0:	e022                	sd	s0,0(sp)
        for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc02016c2:	6300                	ld	s0,0(a4)
{
ffffffffc02016c4:	e406                	sd	ra,8(sp)
        for (bb = bigblocks_head; bb != NULL; last = &bb->next, bb = bb->next) {
ffffffffc02016c6:	e411                	bnez	s0,ffffffffc02016d2 <slub_free+0x24>
ffffffffc02016c8:	a035                	j	ffffffffc02016f4 <slub_free+0x46>
ffffffffc02016ca:	01040713          	addi	a4,s0,16
ffffffffc02016ce:	6800                	ld	s0,16(s0)
ffffffffc02016d0:	c015                	beqz	s0,ffffffffc02016f4 <slub_free+0x46>
            if (bb->pages == block && bb->is_bigblock) {
ffffffffc02016d2:	641c                	ld	a5,8(s0)
ffffffffc02016d4:	fea79be3          	bne	a5,a0,ffffffffc02016ca <slub_free+0x1c>
ffffffffc02016d8:	4c1c                	lw	a5,24(s0)
ffffffffc02016da:	dbe5                	beqz	a5,ffffffffc02016ca <slub_free+0x1c>
                // 确认是大块
                *last = bb->next;  // 从链表中移除当前节点
ffffffffc02016dc:	681c                	ld	a5,16(s0)
				// call pmm->free_pages to free a continuous n*PAGESIZE memory
                free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc02016de:	400c                	lw	a1,0(s0)
                *last = bb->next;  // 从链表中移除当前节点
ffffffffc02016e0:	e31c                	sd	a5,0(a4)
                free_pages((struct Page *)block, bb->order);  // 释放大块页
ffffffffc02016e2:	c1fff0ef          	jal	ra,ffffffffc0201300 <free_pages>
                obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc02016e6:	8522                	mv	a0,s0
        }
    }

	obj_free((obj_t *)block - 1, 0);
	return;
}
ffffffffc02016e8:	6402                	ld	s0,0(sp)
ffffffffc02016ea:	60a2                	ld	ra,8(sp)
                obj_free(bb, sizeof(bigblock_t));  // 释放 bigblock_t 结构体
ffffffffc02016ec:	02000593          	li	a1,32
}
ffffffffc02016f0:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc02016f2:	bd31                	j	ffffffffc020150e <obj_free>
}
ffffffffc02016f4:	6402                	ld	s0,0(sp)
ffffffffc02016f6:	60a2                	ld	ra,8(sp)
	obj_free((obj_t *)block - 1, 0);
ffffffffc02016f8:	4581                	li	a1,0
ffffffffc02016fa:	1541                	addi	a0,a0,-16
}
ffffffffc02016fc:	0141                	addi	sp,sp,16
	obj_free((obj_t *)block - 1, 0);
ffffffffc02016fe:	bd01                	j	ffffffffc020150e <obj_free>
ffffffffc0201700:	4581                	li	a1,0
ffffffffc0201702:	1541                	addi	a0,a0,-16
ffffffffc0201704:	b529                	j	ffffffffc020150e <obj_free>
ffffffffc0201706:	8082                	ret

ffffffffc0201708 <slub_init>:

void slub_init(void) {
    cprintf("slub_init() succeeded!\n");
ffffffffc0201708:	00001517          	auipc	a0,0x1
ffffffffc020170c:	33850513          	addi	a0,a0,824 # ffffffffc0202a40 <best_fit_pmm_manager+0x188>
ffffffffc0201710:	9abfe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201714 <print_objs>:
}

// 输出object链表信息
void print_objs(){
ffffffffc0201714:	7179                	addi	sp,sp,-48
	int object_count = 0;
	cprintf("objsizes: ");
ffffffffc0201716:	00001517          	auipc	a0,0x1
ffffffffc020171a:	34250513          	addi	a0,a0,834 # ffffffffc0202a58 <best_fit_pmm_manager+0x1a0>
void print_objs(){
ffffffffc020171e:	f022                	sd	s0,32(sp)
ffffffffc0201720:	ec26                	sd	s1,24(sp)
ffffffffc0201722:	e84a                	sd	s2,16(sp)
ffffffffc0201724:	f406                	sd	ra,40(sp)
ffffffffc0201726:	e44e                	sd	s3,8(sp)
    for(obj_t* curr = objfree->next; curr != objfree; curr = curr->next){
ffffffffc0201728:	00005917          	auipc	s2,0x5
ffffffffc020172c:	8e890913          	addi	s2,s2,-1816 # ffffffffc0206010 <objfree>
	cprintf("objsizes: ");
ffffffffc0201730:	98bfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = objfree->next; curr != objfree; curr = curr->next){
ffffffffc0201734:	00093783          	ld	a5,0(s2)
	int object_count = 0;
ffffffffc0201738:	4481                	li	s1,0
    for(obj_t* curr = objfree->next; curr != objfree; curr = curr->next){
ffffffffc020173a:	6780                	ld	s0,8(a5)
ffffffffc020173c:	02878063          	beq	a5,s0,ffffffffc020175c <print_objs+0x48>
		cprintf("%d ", curr->objsize);
ffffffffc0201740:	00001997          	auipc	s3,0x1
ffffffffc0201744:	32898993          	addi	s3,s3,808 # ffffffffc0202a68 <best_fit_pmm_manager+0x1b0>
ffffffffc0201748:	400c                	lw	a1,0(s0)
ffffffffc020174a:	854e                	mv	a0,s3
		object_count ++;
ffffffffc020174c:	2485                	addiw	s1,s1,1
		cprintf("%d ", curr->objsize);
ffffffffc020174e:	96dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(obj_t* curr = objfree->next; curr != objfree; curr = curr->next){
ffffffffc0201752:	00093783          	ld	a5,0(s2)
ffffffffc0201756:	6400                	ld	s0,8(s0)
ffffffffc0201758:	fe8798e3          	bne	a5,s0,ffffffffc0201748 <print_objs+0x34>
	}    
	cprintf("Total number of objs: %d\n", object_count);
ffffffffc020175c:	85a6                	mv	a1,s1
ffffffffc020175e:	00001517          	auipc	a0,0x1
ffffffffc0201762:	31250513          	addi	a0,a0,786 # ffffffffc0202a70 <best_fit_pmm_manager+0x1b8>
ffffffffc0201766:	955fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	cprintf("\n");
}
ffffffffc020176a:	7402                	ld	s0,32(sp)
ffffffffc020176c:	70a2                	ld	ra,40(sp)
ffffffffc020176e:	64e2                	ld	s1,24(sp)
ffffffffc0201770:	6942                	ld	s2,16(sp)
ffffffffc0201772:	69a2                	ld	s3,8(sp)
	cprintf("\n");
ffffffffc0201774:	00001517          	auipc	a0,0x1
ffffffffc0201778:	38c50513          	addi	a0,a0,908 # ffffffffc0202b00 <best_fit_pmm_manager+0x248>
}
ffffffffc020177c:	6145                	addi	sp,sp,48
	cprintf("\n");
ffffffffc020177e:	93dfe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201782 <slub_check>:

    
void slub_check()
{
ffffffffc0201782:	1101                	addi	sp,sp,-32
    cprintf("slub check begin\n");
ffffffffc0201784:	00001517          	auipc	a0,0x1
ffffffffc0201788:	30c50513          	addi	a0,a0,780 # ffffffffc0202a90 <best_fit_pmm_manager+0x1d8>
{
ffffffffc020178c:	ec06                	sd	ra,24(sp)
ffffffffc020178e:	e822                	sd	s0,16(sp)
ffffffffc0201790:	e426                	sd	s1,8(sp)
    cprintf("slub check begin\n");
ffffffffc0201792:	929fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_objs();
ffffffffc0201796:	f7fff0ef          	jal	ra,ffffffffc0201714 <print_objs>


    cprintf("alloc test start:\n");
ffffffffc020179a:	00001517          	auipc	a0,0x1
ffffffffc020179e:	30e50513          	addi	a0,a0,782 # ffffffffc0202aa8 <best_fit_pmm_manager+0x1f0>
ffffffffc02017a2:	919fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    // 测试申请
	cprintf("p1 alloc 4096\n");
ffffffffc02017a6:	00001517          	auipc	a0,0x1
ffffffffc02017aa:	31a50513          	addi	a0,a0,794 # ffffffffc0202ac0 <best_fit_pmm_manager+0x208>
ffffffffc02017ae:	90dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	if (size < PGSIZE - OBJ_UNIT) {
ffffffffc02017b2:	6505                	lui	a0,0x1
ffffffffc02017b4:	e8dff0ef          	jal	ra,ffffffffc0201640 <slub_alloc.part.0>
ffffffffc02017b8:	84aa                	mv	s1,a0
	void* p1 = slub_alloc(4096);
	print_objs();
ffffffffc02017ba:	f5bff0ef          	jal	ra,ffffffffc0201714 <print_objs>

	cprintf("p2 alloc 2\n");
ffffffffc02017be:	00001517          	auipc	a0,0x1
ffffffffc02017c2:	31250513          	addi	a0,a0,786 # ffffffffc0202ad0 <best_fit_pmm_manager+0x218>
ffffffffc02017c6:	8f5fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc02017ca:	4549                	li	a0,18
ffffffffc02017cc:	dc3ff0ef          	jal	ra,ffffffffc020158e <obj_alloc>
    void* p2 = slub_alloc(2);
	print_objs();
ffffffffc02017d0:	f45ff0ef          	jal	ra,ffffffffc0201714 <print_objs>

	cprintf("p3 alloc 32\n");
ffffffffc02017d4:	00001517          	auipc	a0,0x1
ffffffffc02017d8:	30c50513          	addi	a0,a0,780 # ffffffffc0202ae0 <best_fit_pmm_manager+0x228>
ffffffffc02017dc:	8dffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = obj_alloc(size + OBJ_UNIT);
ffffffffc02017e0:	03000513          	li	a0,48
ffffffffc02017e4:	dabff0ef          	jal	ra,ffffffffc020158e <obj_alloc>
ffffffffc02017e8:	842a                	mv	s0,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc02017ea:	c119                	beqz	a0,ffffffffc02017f0 <slub_check+0x6e>
ffffffffc02017ec:	01050413          	addi	s0,a0,16
    void* p3 = slub_alloc(32);
    print_objs();
ffffffffc02017f0:	f25ff0ef          	jal	ra,ffffffffc0201714 <print_objs>

    
	cprintf("free test start:\n");
ffffffffc02017f4:	00001517          	auipc	a0,0x1
ffffffffc02017f8:	2fc50513          	addi	a0,a0,764 # ffffffffc0202af0 <best_fit_pmm_manager+0x238>
ffffffffc02017fc:	8bffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	// 测试释放
    cprintf("free p1\n");
ffffffffc0201800:	00001517          	auipc	a0,0x1
ffffffffc0201804:	30850513          	addi	a0,a0,776 # ffffffffc0202b08 <best_fit_pmm_manager+0x250>
ffffffffc0201808:	8b3fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p1);
ffffffffc020180c:	8526                	mv	a0,s1
ffffffffc020180e:	ea1ff0ef          	jal	ra,ffffffffc02016ae <slub_free>
    print_objs();
ffffffffc0201812:	f03ff0ef          	jal	ra,ffffffffc0201714 <print_objs>

	cprintf("free p3\n");
ffffffffc0201816:	00001517          	auipc	a0,0x1
ffffffffc020181a:	30250513          	addi	a0,a0,770 # ffffffffc0202b18 <best_fit_pmm_manager+0x260>
ffffffffc020181e:	89dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p3);
ffffffffc0201822:	8522                	mv	a0,s0
ffffffffc0201824:	e8bff0ef          	jal	ra,ffffffffc02016ae <slub_free>
    print_objs();
ffffffffc0201828:	eedff0ef          	jal	ra,ffffffffc0201714 <print_objs>

    cprintf("slub check end\n");
ffffffffc020182c:	6442                	ld	s0,16(sp)
ffffffffc020182e:	60e2                	ld	ra,24(sp)
ffffffffc0201830:	64a2                	ld	s1,8(sp)
    cprintf("slub check end\n");
ffffffffc0201832:	00001517          	auipc	a0,0x1
ffffffffc0201836:	2f650513          	addi	a0,a0,758 # ffffffffc0202b28 <best_fit_pmm_manager+0x270>
ffffffffc020183a:	6105                	addi	sp,sp,32
    cprintf("slub check end\n");
ffffffffc020183c:	87ffe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201840 <printnum>:
ffffffffc0201840:	02069813          	slli	a6,a3,0x20
ffffffffc0201844:	7179                	addi	sp,sp,-48
ffffffffc0201846:	02085813          	srli	a6,a6,0x20
ffffffffc020184a:	e052                	sd	s4,0(sp)
ffffffffc020184c:	03067a33          	remu	s4,a2,a6
ffffffffc0201850:	f022                	sd	s0,32(sp)
ffffffffc0201852:	ec26                	sd	s1,24(sp)
ffffffffc0201854:	e84a                	sd	s2,16(sp)
ffffffffc0201856:	f406                	sd	ra,40(sp)
ffffffffc0201858:	e44e                	sd	s3,8(sp)
ffffffffc020185a:	84aa                	mv	s1,a0
ffffffffc020185c:	892e                	mv	s2,a1
ffffffffc020185e:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201862:	2a01                	sext.w	s4,s4
ffffffffc0201864:	03067e63          	bgeu	a2,a6,ffffffffc02018a0 <printnum+0x60>
ffffffffc0201868:	89be                	mv	s3,a5
ffffffffc020186a:	00805763          	blez	s0,ffffffffc0201878 <printnum+0x38>
ffffffffc020186e:	347d                	addiw	s0,s0,-1
ffffffffc0201870:	85ca                	mv	a1,s2
ffffffffc0201872:	854e                	mv	a0,s3
ffffffffc0201874:	9482                	jalr	s1
ffffffffc0201876:	fc65                	bnez	s0,ffffffffc020186e <printnum+0x2e>
ffffffffc0201878:	1a02                	slli	s4,s4,0x20
ffffffffc020187a:	00001797          	auipc	a5,0x1
ffffffffc020187e:	2be78793          	addi	a5,a5,702 # ffffffffc0202b38 <best_fit_pmm_manager+0x280>
ffffffffc0201882:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201886:	9a3e                	add	s4,s4,a5
ffffffffc0201888:	7402                	ld	s0,32(sp)
ffffffffc020188a:	000a4503          	lbu	a0,0(s4)
ffffffffc020188e:	70a2                	ld	ra,40(sp)
ffffffffc0201890:	69a2                	ld	s3,8(sp)
ffffffffc0201892:	6a02                	ld	s4,0(sp)
ffffffffc0201894:	85ca                	mv	a1,s2
ffffffffc0201896:	87a6                	mv	a5,s1
ffffffffc0201898:	6942                	ld	s2,16(sp)
ffffffffc020189a:	64e2                	ld	s1,24(sp)
ffffffffc020189c:	6145                	addi	sp,sp,48
ffffffffc020189e:	8782                	jr	a5
ffffffffc02018a0:	03065633          	divu	a2,a2,a6
ffffffffc02018a4:	8722                	mv	a4,s0
ffffffffc02018a6:	f9bff0ef          	jal	ra,ffffffffc0201840 <printnum>
ffffffffc02018aa:	b7f9                	j	ffffffffc0201878 <printnum+0x38>

ffffffffc02018ac <vprintfmt>:
ffffffffc02018ac:	7119                	addi	sp,sp,-128
ffffffffc02018ae:	f4a6                	sd	s1,104(sp)
ffffffffc02018b0:	f0ca                	sd	s2,96(sp)
ffffffffc02018b2:	ecce                	sd	s3,88(sp)
ffffffffc02018b4:	e8d2                	sd	s4,80(sp)
ffffffffc02018b6:	e4d6                	sd	s5,72(sp)
ffffffffc02018b8:	e0da                	sd	s6,64(sp)
ffffffffc02018ba:	fc5e                	sd	s7,56(sp)
ffffffffc02018bc:	f06a                	sd	s10,32(sp)
ffffffffc02018be:	fc86                	sd	ra,120(sp)
ffffffffc02018c0:	f8a2                	sd	s0,112(sp)
ffffffffc02018c2:	f862                	sd	s8,48(sp)
ffffffffc02018c4:	f466                	sd	s9,40(sp)
ffffffffc02018c6:	ec6e                	sd	s11,24(sp)
ffffffffc02018c8:	892a                	mv	s2,a0
ffffffffc02018ca:	84ae                	mv	s1,a1
ffffffffc02018cc:	8d32                	mv	s10,a2
ffffffffc02018ce:	8a36                	mv	s4,a3
ffffffffc02018d0:	02500993          	li	s3,37
ffffffffc02018d4:	5b7d                	li	s6,-1
ffffffffc02018d6:	00001a97          	auipc	s5,0x1
ffffffffc02018da:	296a8a93          	addi	s5,s5,662 # ffffffffc0202b6c <best_fit_pmm_manager+0x2b4>
ffffffffc02018de:	00001b97          	auipc	s7,0x1
ffffffffc02018e2:	46ab8b93          	addi	s7,s7,1130 # ffffffffc0202d48 <error_string>
ffffffffc02018e6:	000d4503          	lbu	a0,0(s10)
ffffffffc02018ea:	001d0413          	addi	s0,s10,1
ffffffffc02018ee:	01350a63          	beq	a0,s3,ffffffffc0201902 <vprintfmt+0x56>
ffffffffc02018f2:	c121                	beqz	a0,ffffffffc0201932 <vprintfmt+0x86>
ffffffffc02018f4:	85a6                	mv	a1,s1
ffffffffc02018f6:	0405                	addi	s0,s0,1
ffffffffc02018f8:	9902                	jalr	s2
ffffffffc02018fa:	fff44503          	lbu	a0,-1(s0)
ffffffffc02018fe:	ff351ae3          	bne	a0,s3,ffffffffc02018f2 <vprintfmt+0x46>
ffffffffc0201902:	00044603          	lbu	a2,0(s0)
ffffffffc0201906:	02000793          	li	a5,32
ffffffffc020190a:	4c81                	li	s9,0
ffffffffc020190c:	4881                	li	a7,0
ffffffffc020190e:	5c7d                	li	s8,-1
ffffffffc0201910:	5dfd                	li	s11,-1
ffffffffc0201912:	05500513          	li	a0,85
ffffffffc0201916:	4825                	li	a6,9
ffffffffc0201918:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020191c:	0ff5f593          	andi	a1,a1,255
ffffffffc0201920:	00140d13          	addi	s10,s0,1
ffffffffc0201924:	04b56263          	bltu	a0,a1,ffffffffc0201968 <vprintfmt+0xbc>
ffffffffc0201928:	058a                	slli	a1,a1,0x2
ffffffffc020192a:	95d6                	add	a1,a1,s5
ffffffffc020192c:	4194                	lw	a3,0(a1)
ffffffffc020192e:	96d6                	add	a3,a3,s5
ffffffffc0201930:	8682                	jr	a3
ffffffffc0201932:	70e6                	ld	ra,120(sp)
ffffffffc0201934:	7446                	ld	s0,112(sp)
ffffffffc0201936:	74a6                	ld	s1,104(sp)
ffffffffc0201938:	7906                	ld	s2,96(sp)
ffffffffc020193a:	69e6                	ld	s3,88(sp)
ffffffffc020193c:	6a46                	ld	s4,80(sp)
ffffffffc020193e:	6aa6                	ld	s5,72(sp)
ffffffffc0201940:	6b06                	ld	s6,64(sp)
ffffffffc0201942:	7be2                	ld	s7,56(sp)
ffffffffc0201944:	7c42                	ld	s8,48(sp)
ffffffffc0201946:	7ca2                	ld	s9,40(sp)
ffffffffc0201948:	7d02                	ld	s10,32(sp)
ffffffffc020194a:	6de2                	ld	s11,24(sp)
ffffffffc020194c:	6109                	addi	sp,sp,128
ffffffffc020194e:	8082                	ret
ffffffffc0201950:	87b2                	mv	a5,a2
ffffffffc0201952:	00144603          	lbu	a2,1(s0)
ffffffffc0201956:	846a                	mv	s0,s10
ffffffffc0201958:	00140d13          	addi	s10,s0,1
ffffffffc020195c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201960:	0ff5f593          	andi	a1,a1,255
ffffffffc0201964:	fcb572e3          	bgeu	a0,a1,ffffffffc0201928 <vprintfmt+0x7c>
ffffffffc0201968:	85a6                	mv	a1,s1
ffffffffc020196a:	02500513          	li	a0,37
ffffffffc020196e:	9902                	jalr	s2
ffffffffc0201970:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201974:	8d22                	mv	s10,s0
ffffffffc0201976:	f73788e3          	beq	a5,s3,ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc020197a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020197e:	1d7d                	addi	s10,s10,-1
ffffffffc0201980:	ff379de3          	bne	a5,s3,ffffffffc020197a <vprintfmt+0xce>
ffffffffc0201984:	b78d                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201986:	fd060c1b          	addiw	s8,a2,-48
ffffffffc020198a:	00144603          	lbu	a2,1(s0)
ffffffffc020198e:	846a                	mv	s0,s10
ffffffffc0201990:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201994:	0006059b          	sext.w	a1,a2
ffffffffc0201998:	02d86463          	bltu	a6,a3,ffffffffc02019c0 <vprintfmt+0x114>
ffffffffc020199c:	00144603          	lbu	a2,1(s0)
ffffffffc02019a0:	002c169b          	slliw	a3,s8,0x2
ffffffffc02019a4:	0186873b          	addw	a4,a3,s8
ffffffffc02019a8:	0017171b          	slliw	a4,a4,0x1
ffffffffc02019ac:	9f2d                	addw	a4,a4,a1
ffffffffc02019ae:	fd06069b          	addiw	a3,a2,-48
ffffffffc02019b2:	0405                	addi	s0,s0,1
ffffffffc02019b4:	fd070c1b          	addiw	s8,a4,-48
ffffffffc02019b8:	0006059b          	sext.w	a1,a2
ffffffffc02019bc:	fed870e3          	bgeu	a6,a3,ffffffffc020199c <vprintfmt+0xf0>
ffffffffc02019c0:	f40ddce3          	bgez	s11,ffffffffc0201918 <vprintfmt+0x6c>
ffffffffc02019c4:	8de2                	mv	s11,s8
ffffffffc02019c6:	5c7d                	li	s8,-1
ffffffffc02019c8:	bf81                	j	ffffffffc0201918 <vprintfmt+0x6c>
ffffffffc02019ca:	fffdc693          	not	a3,s11
ffffffffc02019ce:	96fd                	srai	a3,a3,0x3f
ffffffffc02019d0:	00ddfdb3          	and	s11,s11,a3
ffffffffc02019d4:	00144603          	lbu	a2,1(s0)
ffffffffc02019d8:	2d81                	sext.w	s11,s11
ffffffffc02019da:	846a                	mv	s0,s10
ffffffffc02019dc:	bf35                	j	ffffffffc0201918 <vprintfmt+0x6c>
ffffffffc02019de:	000a2c03          	lw	s8,0(s4)
ffffffffc02019e2:	00144603          	lbu	a2,1(s0)
ffffffffc02019e6:	0a21                	addi	s4,s4,8
ffffffffc02019e8:	846a                	mv	s0,s10
ffffffffc02019ea:	bfd9                	j	ffffffffc02019c0 <vprintfmt+0x114>
ffffffffc02019ec:	4705                	li	a4,1
ffffffffc02019ee:	008a0593          	addi	a1,s4,8
ffffffffc02019f2:	01174463          	blt	a4,a7,ffffffffc02019fa <vprintfmt+0x14e>
ffffffffc02019f6:	1a088e63          	beqz	a7,ffffffffc0201bb2 <vprintfmt+0x306>
ffffffffc02019fa:	000a3603          	ld	a2,0(s4)
ffffffffc02019fe:	46c1                	li	a3,16
ffffffffc0201a00:	8a2e                	mv	s4,a1
ffffffffc0201a02:	2781                	sext.w	a5,a5
ffffffffc0201a04:	876e                	mv	a4,s11
ffffffffc0201a06:	85a6                	mv	a1,s1
ffffffffc0201a08:	854a                	mv	a0,s2
ffffffffc0201a0a:	e37ff0ef          	jal	ra,ffffffffc0201840 <printnum>
ffffffffc0201a0e:	bde1                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201a10:	000a2503          	lw	a0,0(s4)
ffffffffc0201a14:	85a6                	mv	a1,s1
ffffffffc0201a16:	0a21                	addi	s4,s4,8
ffffffffc0201a18:	9902                	jalr	s2
ffffffffc0201a1a:	b5f1                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201a1c:	4705                	li	a4,1
ffffffffc0201a1e:	008a0593          	addi	a1,s4,8
ffffffffc0201a22:	01174463          	blt	a4,a7,ffffffffc0201a2a <vprintfmt+0x17e>
ffffffffc0201a26:	18088163          	beqz	a7,ffffffffc0201ba8 <vprintfmt+0x2fc>
ffffffffc0201a2a:	000a3603          	ld	a2,0(s4)
ffffffffc0201a2e:	46a9                	li	a3,10
ffffffffc0201a30:	8a2e                	mv	s4,a1
ffffffffc0201a32:	bfc1                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201a34:	00144603          	lbu	a2,1(s0)
ffffffffc0201a38:	4c85                	li	s9,1
ffffffffc0201a3a:	846a                	mv	s0,s10
ffffffffc0201a3c:	bdf1                	j	ffffffffc0201918 <vprintfmt+0x6c>
ffffffffc0201a3e:	85a6                	mv	a1,s1
ffffffffc0201a40:	02500513          	li	a0,37
ffffffffc0201a44:	9902                	jalr	s2
ffffffffc0201a46:	b545                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201a48:	00144603          	lbu	a2,1(s0)
ffffffffc0201a4c:	2885                	addiw	a7,a7,1
ffffffffc0201a4e:	846a                	mv	s0,s10
ffffffffc0201a50:	b5e1                	j	ffffffffc0201918 <vprintfmt+0x6c>
ffffffffc0201a52:	4705                	li	a4,1
ffffffffc0201a54:	008a0593          	addi	a1,s4,8
ffffffffc0201a58:	01174463          	blt	a4,a7,ffffffffc0201a60 <vprintfmt+0x1b4>
ffffffffc0201a5c:	14088163          	beqz	a7,ffffffffc0201b9e <vprintfmt+0x2f2>
ffffffffc0201a60:	000a3603          	ld	a2,0(s4)
ffffffffc0201a64:	46a1                	li	a3,8
ffffffffc0201a66:	8a2e                	mv	s4,a1
ffffffffc0201a68:	bf69                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201a6a:	03000513          	li	a0,48
ffffffffc0201a6e:	85a6                	mv	a1,s1
ffffffffc0201a70:	e03e                	sd	a5,0(sp)
ffffffffc0201a72:	9902                	jalr	s2
ffffffffc0201a74:	85a6                	mv	a1,s1
ffffffffc0201a76:	07800513          	li	a0,120
ffffffffc0201a7a:	9902                	jalr	s2
ffffffffc0201a7c:	0a21                	addi	s4,s4,8
ffffffffc0201a7e:	6782                	ld	a5,0(sp)
ffffffffc0201a80:	46c1                	li	a3,16
ffffffffc0201a82:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201a86:	bfb5                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201a88:	000a3403          	ld	s0,0(s4)
ffffffffc0201a8c:	008a0713          	addi	a4,s4,8
ffffffffc0201a90:	e03a                	sd	a4,0(sp)
ffffffffc0201a92:	14040263          	beqz	s0,ffffffffc0201bd6 <vprintfmt+0x32a>
ffffffffc0201a96:	0fb05763          	blez	s11,ffffffffc0201b84 <vprintfmt+0x2d8>
ffffffffc0201a9a:	02d00693          	li	a3,45
ffffffffc0201a9e:	0cd79163          	bne	a5,a3,ffffffffc0201b60 <vprintfmt+0x2b4>
ffffffffc0201aa2:	00044783          	lbu	a5,0(s0)
ffffffffc0201aa6:	0007851b          	sext.w	a0,a5
ffffffffc0201aaa:	cf85                	beqz	a5,ffffffffc0201ae2 <vprintfmt+0x236>
ffffffffc0201aac:	00140a13          	addi	s4,s0,1
ffffffffc0201ab0:	05e00413          	li	s0,94
ffffffffc0201ab4:	000c4563          	bltz	s8,ffffffffc0201abe <vprintfmt+0x212>
ffffffffc0201ab8:	3c7d                	addiw	s8,s8,-1
ffffffffc0201aba:	036c0263          	beq	s8,s6,ffffffffc0201ade <vprintfmt+0x232>
ffffffffc0201abe:	85a6                	mv	a1,s1
ffffffffc0201ac0:	0e0c8e63          	beqz	s9,ffffffffc0201bbc <vprintfmt+0x310>
ffffffffc0201ac4:	3781                	addiw	a5,a5,-32
ffffffffc0201ac6:	0ef47b63          	bgeu	s0,a5,ffffffffc0201bbc <vprintfmt+0x310>
ffffffffc0201aca:	03f00513          	li	a0,63
ffffffffc0201ace:	9902                	jalr	s2
ffffffffc0201ad0:	000a4783          	lbu	a5,0(s4)
ffffffffc0201ad4:	3dfd                	addiw	s11,s11,-1
ffffffffc0201ad6:	0a05                	addi	s4,s4,1
ffffffffc0201ad8:	0007851b          	sext.w	a0,a5
ffffffffc0201adc:	ffe1                	bnez	a5,ffffffffc0201ab4 <vprintfmt+0x208>
ffffffffc0201ade:	01b05963          	blez	s11,ffffffffc0201af0 <vprintfmt+0x244>
ffffffffc0201ae2:	3dfd                	addiw	s11,s11,-1
ffffffffc0201ae4:	85a6                	mv	a1,s1
ffffffffc0201ae6:	02000513          	li	a0,32
ffffffffc0201aea:	9902                	jalr	s2
ffffffffc0201aec:	fe0d9be3          	bnez	s11,ffffffffc0201ae2 <vprintfmt+0x236>
ffffffffc0201af0:	6a02                	ld	s4,0(sp)
ffffffffc0201af2:	bbd5                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201af4:	4705                	li	a4,1
ffffffffc0201af6:	008a0c93          	addi	s9,s4,8
ffffffffc0201afa:	01174463          	blt	a4,a7,ffffffffc0201b02 <vprintfmt+0x256>
ffffffffc0201afe:	08088d63          	beqz	a7,ffffffffc0201b98 <vprintfmt+0x2ec>
ffffffffc0201b02:	000a3403          	ld	s0,0(s4)
ffffffffc0201b06:	0a044d63          	bltz	s0,ffffffffc0201bc0 <vprintfmt+0x314>
ffffffffc0201b0a:	8622                	mv	a2,s0
ffffffffc0201b0c:	8a66                	mv	s4,s9
ffffffffc0201b0e:	46a9                	li	a3,10
ffffffffc0201b10:	bdcd                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201b12:	000a2783          	lw	a5,0(s4)
ffffffffc0201b16:	4719                	li	a4,6
ffffffffc0201b18:	0a21                	addi	s4,s4,8
ffffffffc0201b1a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201b1e:	8fb5                	xor	a5,a5,a3
ffffffffc0201b20:	40d786bb          	subw	a3,a5,a3
ffffffffc0201b24:	02d74163          	blt	a4,a3,ffffffffc0201b46 <vprintfmt+0x29a>
ffffffffc0201b28:	00369793          	slli	a5,a3,0x3
ffffffffc0201b2c:	97de                	add	a5,a5,s7
ffffffffc0201b2e:	639c                	ld	a5,0(a5)
ffffffffc0201b30:	cb99                	beqz	a5,ffffffffc0201b46 <vprintfmt+0x29a>
ffffffffc0201b32:	86be                	mv	a3,a5
ffffffffc0201b34:	00001617          	auipc	a2,0x1
ffffffffc0201b38:	03460613          	addi	a2,a2,52 # ffffffffc0202b68 <best_fit_pmm_manager+0x2b0>
ffffffffc0201b3c:	85a6                	mv	a1,s1
ffffffffc0201b3e:	854a                	mv	a0,s2
ffffffffc0201b40:	0ce000ef          	jal	ra,ffffffffc0201c0e <printfmt>
ffffffffc0201b44:	b34d                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201b46:	00001617          	auipc	a2,0x1
ffffffffc0201b4a:	01260613          	addi	a2,a2,18 # ffffffffc0202b58 <best_fit_pmm_manager+0x2a0>
ffffffffc0201b4e:	85a6                	mv	a1,s1
ffffffffc0201b50:	854a                	mv	a0,s2
ffffffffc0201b52:	0bc000ef          	jal	ra,ffffffffc0201c0e <printfmt>
ffffffffc0201b56:	bb41                	j	ffffffffc02018e6 <vprintfmt+0x3a>
ffffffffc0201b58:	00001417          	auipc	s0,0x1
ffffffffc0201b5c:	ff840413          	addi	s0,s0,-8 # ffffffffc0202b50 <best_fit_pmm_manager+0x298>
ffffffffc0201b60:	85e2                	mv	a1,s8
ffffffffc0201b62:	8522                	mv	a0,s0
ffffffffc0201b64:	e43e                	sd	a5,8(sp)
ffffffffc0201b66:	1e6000ef          	jal	ra,ffffffffc0201d4c <strnlen>
ffffffffc0201b6a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201b6e:	01b05b63          	blez	s11,ffffffffc0201b84 <vprintfmt+0x2d8>
ffffffffc0201b72:	67a2                	ld	a5,8(sp)
ffffffffc0201b74:	00078a1b          	sext.w	s4,a5
ffffffffc0201b78:	3dfd                	addiw	s11,s11,-1
ffffffffc0201b7a:	85a6                	mv	a1,s1
ffffffffc0201b7c:	8552                	mv	a0,s4
ffffffffc0201b7e:	9902                	jalr	s2
ffffffffc0201b80:	fe0d9ce3          	bnez	s11,ffffffffc0201b78 <vprintfmt+0x2cc>
ffffffffc0201b84:	00044783          	lbu	a5,0(s0)
ffffffffc0201b88:	00140a13          	addi	s4,s0,1
ffffffffc0201b8c:	0007851b          	sext.w	a0,a5
ffffffffc0201b90:	d3a5                	beqz	a5,ffffffffc0201af0 <vprintfmt+0x244>
ffffffffc0201b92:	05e00413          	li	s0,94
ffffffffc0201b96:	bf39                	j	ffffffffc0201ab4 <vprintfmt+0x208>
ffffffffc0201b98:	000a2403          	lw	s0,0(s4)
ffffffffc0201b9c:	b7ad                	j	ffffffffc0201b06 <vprintfmt+0x25a>
ffffffffc0201b9e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ba2:	46a1                	li	a3,8
ffffffffc0201ba4:	8a2e                	mv	s4,a1
ffffffffc0201ba6:	bdb1                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201ba8:	000a6603          	lwu	a2,0(s4)
ffffffffc0201bac:	46a9                	li	a3,10
ffffffffc0201bae:	8a2e                	mv	s4,a1
ffffffffc0201bb0:	bd89                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201bb2:	000a6603          	lwu	a2,0(s4)
ffffffffc0201bb6:	46c1                	li	a3,16
ffffffffc0201bb8:	8a2e                	mv	s4,a1
ffffffffc0201bba:	b5a1                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201bbc:	9902                	jalr	s2
ffffffffc0201bbe:	bf09                	j	ffffffffc0201ad0 <vprintfmt+0x224>
ffffffffc0201bc0:	85a6                	mv	a1,s1
ffffffffc0201bc2:	02d00513          	li	a0,45
ffffffffc0201bc6:	e03e                	sd	a5,0(sp)
ffffffffc0201bc8:	9902                	jalr	s2
ffffffffc0201bca:	6782                	ld	a5,0(sp)
ffffffffc0201bcc:	8a66                	mv	s4,s9
ffffffffc0201bce:	40800633          	neg	a2,s0
ffffffffc0201bd2:	46a9                	li	a3,10
ffffffffc0201bd4:	b53d                	j	ffffffffc0201a02 <vprintfmt+0x156>
ffffffffc0201bd6:	03b05163          	blez	s11,ffffffffc0201bf8 <vprintfmt+0x34c>
ffffffffc0201bda:	02d00693          	li	a3,45
ffffffffc0201bde:	f6d79de3          	bne	a5,a3,ffffffffc0201b58 <vprintfmt+0x2ac>
ffffffffc0201be2:	00001417          	auipc	s0,0x1
ffffffffc0201be6:	f6e40413          	addi	s0,s0,-146 # ffffffffc0202b50 <best_fit_pmm_manager+0x298>
ffffffffc0201bea:	02800793          	li	a5,40
ffffffffc0201bee:	02800513          	li	a0,40
ffffffffc0201bf2:	00140a13          	addi	s4,s0,1
ffffffffc0201bf6:	bd6d                	j	ffffffffc0201ab0 <vprintfmt+0x204>
ffffffffc0201bf8:	00001a17          	auipc	s4,0x1
ffffffffc0201bfc:	f59a0a13          	addi	s4,s4,-167 # ffffffffc0202b51 <best_fit_pmm_manager+0x299>
ffffffffc0201c00:	02800513          	li	a0,40
ffffffffc0201c04:	02800793          	li	a5,40
ffffffffc0201c08:	05e00413          	li	s0,94
ffffffffc0201c0c:	b565                	j	ffffffffc0201ab4 <vprintfmt+0x208>

ffffffffc0201c0e <printfmt>:
ffffffffc0201c0e:	715d                	addi	sp,sp,-80
ffffffffc0201c10:	02810313          	addi	t1,sp,40
ffffffffc0201c14:	f436                	sd	a3,40(sp)
ffffffffc0201c16:	869a                	mv	a3,t1
ffffffffc0201c18:	ec06                	sd	ra,24(sp)
ffffffffc0201c1a:	f83a                	sd	a4,48(sp)
ffffffffc0201c1c:	fc3e                	sd	a5,56(sp)
ffffffffc0201c1e:	e0c2                	sd	a6,64(sp)
ffffffffc0201c20:	e4c6                	sd	a7,72(sp)
ffffffffc0201c22:	e41a                	sd	t1,8(sp)
ffffffffc0201c24:	c89ff0ef          	jal	ra,ffffffffc02018ac <vprintfmt>
ffffffffc0201c28:	60e2                	ld	ra,24(sp)
ffffffffc0201c2a:	6161                	addi	sp,sp,80
ffffffffc0201c2c:	8082                	ret

ffffffffc0201c2e <readline>:
ffffffffc0201c2e:	715d                	addi	sp,sp,-80
ffffffffc0201c30:	e486                	sd	ra,72(sp)
ffffffffc0201c32:	e0a6                	sd	s1,64(sp)
ffffffffc0201c34:	fc4a                	sd	s2,56(sp)
ffffffffc0201c36:	f84e                	sd	s3,48(sp)
ffffffffc0201c38:	f452                	sd	s4,40(sp)
ffffffffc0201c3a:	f056                	sd	s5,32(sp)
ffffffffc0201c3c:	ec5a                	sd	s6,24(sp)
ffffffffc0201c3e:	e85e                	sd	s7,16(sp)
ffffffffc0201c40:	c901                	beqz	a0,ffffffffc0201c50 <readline+0x22>
ffffffffc0201c42:	85aa                	mv	a1,a0
ffffffffc0201c44:	00001517          	auipc	a0,0x1
ffffffffc0201c48:	f2450513          	addi	a0,a0,-220 # ffffffffc0202b68 <best_fit_pmm_manager+0x2b0>
ffffffffc0201c4c:	c6efe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201c50:	4481                	li	s1,0
ffffffffc0201c52:	497d                	li	s2,31
ffffffffc0201c54:	49a1                	li	s3,8
ffffffffc0201c56:	4aa9                	li	s5,10
ffffffffc0201c58:	4b35                	li	s6,13
ffffffffc0201c5a:	00004b97          	auipc	s7,0x4
ffffffffc0201c5e:	3eeb8b93          	addi	s7,s7,1006 # ffffffffc0206048 <buf>
ffffffffc0201c62:	3fe00a13          	li	s4,1022
ffffffffc0201c66:	cccfe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201c6a:	00054a63          	bltz	a0,ffffffffc0201c7e <readline+0x50>
ffffffffc0201c6e:	00a95a63          	bge	s2,a0,ffffffffc0201c82 <readline+0x54>
ffffffffc0201c72:	029a5263          	bge	s4,s1,ffffffffc0201c96 <readline+0x68>
ffffffffc0201c76:	cbcfe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201c7a:	fe055ae3          	bgez	a0,ffffffffc0201c6e <readline+0x40>
ffffffffc0201c7e:	4501                	li	a0,0
ffffffffc0201c80:	a091                	j	ffffffffc0201cc4 <readline+0x96>
ffffffffc0201c82:	03351463          	bne	a0,s3,ffffffffc0201caa <readline+0x7c>
ffffffffc0201c86:	e8a9                	bnez	s1,ffffffffc0201cd8 <readline+0xaa>
ffffffffc0201c88:	caafe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201c8c:	fe0549e3          	bltz	a0,ffffffffc0201c7e <readline+0x50>
ffffffffc0201c90:	fea959e3          	bge	s2,a0,ffffffffc0201c82 <readline+0x54>
ffffffffc0201c94:	4481                	li	s1,0
ffffffffc0201c96:	e42a                	sd	a0,8(sp)
ffffffffc0201c98:	c58fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201c9c:	6522                	ld	a0,8(sp)
ffffffffc0201c9e:	009b87b3          	add	a5,s7,s1
ffffffffc0201ca2:	2485                	addiw	s1,s1,1
ffffffffc0201ca4:	00a78023          	sb	a0,0(a5)
ffffffffc0201ca8:	bf7d                	j	ffffffffc0201c66 <readline+0x38>
ffffffffc0201caa:	01550463          	beq	a0,s5,ffffffffc0201cb2 <readline+0x84>
ffffffffc0201cae:	fb651ce3          	bne	a0,s6,ffffffffc0201c66 <readline+0x38>
ffffffffc0201cb2:	c3efe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201cb6:	00004517          	auipc	a0,0x4
ffffffffc0201cba:	39250513          	addi	a0,a0,914 # ffffffffc0206048 <buf>
ffffffffc0201cbe:	94aa                	add	s1,s1,a0
ffffffffc0201cc0:	00048023          	sb	zero,0(s1)
ffffffffc0201cc4:	60a6                	ld	ra,72(sp)
ffffffffc0201cc6:	6486                	ld	s1,64(sp)
ffffffffc0201cc8:	7962                	ld	s2,56(sp)
ffffffffc0201cca:	79c2                	ld	s3,48(sp)
ffffffffc0201ccc:	7a22                	ld	s4,40(sp)
ffffffffc0201cce:	7a82                	ld	s5,32(sp)
ffffffffc0201cd0:	6b62                	ld	s6,24(sp)
ffffffffc0201cd2:	6bc2                	ld	s7,16(sp)
ffffffffc0201cd4:	6161                	addi	sp,sp,80
ffffffffc0201cd6:	8082                	ret
ffffffffc0201cd8:	4521                	li	a0,8
ffffffffc0201cda:	c16fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201cde:	34fd                	addiw	s1,s1,-1
ffffffffc0201ce0:	b759                	j	ffffffffc0201c66 <readline+0x38>

ffffffffc0201ce2 <sbi_console_putchar>:
ffffffffc0201ce2:	4781                	li	a5,0
ffffffffc0201ce4:	00004717          	auipc	a4,0x4
ffffffffc0201ce8:	33c73703          	ld	a4,828(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201cec:	88ba                	mv	a7,a4
ffffffffc0201cee:	852a                	mv	a0,a0
ffffffffc0201cf0:	85be                	mv	a1,a5
ffffffffc0201cf2:	863e                	mv	a2,a5
ffffffffc0201cf4:	00000073          	ecall
ffffffffc0201cf8:	87aa                	mv	a5,a0
ffffffffc0201cfa:	8082                	ret

ffffffffc0201cfc <sbi_set_timer>:
ffffffffc0201cfc:	4781                	li	a5,0
ffffffffc0201cfe:	00004717          	auipc	a4,0x4
ffffffffc0201d02:	79a73703          	ld	a4,1946(a4) # ffffffffc0206498 <SBI_SET_TIMER>
ffffffffc0201d06:	88ba                	mv	a7,a4
ffffffffc0201d08:	852a                	mv	a0,a0
ffffffffc0201d0a:	85be                	mv	a1,a5
ffffffffc0201d0c:	863e                	mv	a2,a5
ffffffffc0201d0e:	00000073          	ecall
ffffffffc0201d12:	87aa                	mv	a5,a0
ffffffffc0201d14:	8082                	ret

ffffffffc0201d16 <sbi_console_getchar>:
ffffffffc0201d16:	4501                	li	a0,0
ffffffffc0201d18:	00004797          	auipc	a5,0x4
ffffffffc0201d1c:	3007b783          	ld	a5,768(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201d20:	88be                	mv	a7,a5
ffffffffc0201d22:	852a                	mv	a0,a0
ffffffffc0201d24:	85aa                	mv	a1,a0
ffffffffc0201d26:	862a                	mv	a2,a0
ffffffffc0201d28:	00000073          	ecall
ffffffffc0201d2c:	852a                	mv	a0,a0
ffffffffc0201d2e:	2501                	sext.w	a0,a0
ffffffffc0201d30:	8082                	ret

ffffffffc0201d32 <sbi_shutdown>:
ffffffffc0201d32:	4781                	li	a5,0
ffffffffc0201d34:	00004717          	auipc	a4,0x4
ffffffffc0201d38:	2f473703          	ld	a4,756(a4) # ffffffffc0206028 <SBI_SHUTDOWN>
ffffffffc0201d3c:	88ba                	mv	a7,a4
ffffffffc0201d3e:	853e                	mv	a0,a5
ffffffffc0201d40:	85be                	mv	a1,a5
ffffffffc0201d42:	863e                	mv	a2,a5
ffffffffc0201d44:	00000073          	ecall
ffffffffc0201d48:	87aa                	mv	a5,a0
ffffffffc0201d4a:	8082                	ret

ffffffffc0201d4c <strnlen>:
ffffffffc0201d4c:	4781                	li	a5,0
ffffffffc0201d4e:	e589                	bnez	a1,ffffffffc0201d58 <strnlen+0xc>
ffffffffc0201d50:	a811                	j	ffffffffc0201d64 <strnlen+0x18>
ffffffffc0201d52:	0785                	addi	a5,a5,1
ffffffffc0201d54:	00f58863          	beq	a1,a5,ffffffffc0201d64 <strnlen+0x18>
ffffffffc0201d58:	00f50733          	add	a4,a0,a5
ffffffffc0201d5c:	00074703          	lbu	a4,0(a4)
ffffffffc0201d60:	fb6d                	bnez	a4,ffffffffc0201d52 <strnlen+0x6>
ffffffffc0201d62:	85be                	mv	a1,a5
ffffffffc0201d64:	852e                	mv	a0,a1
ffffffffc0201d66:	8082                	ret

ffffffffc0201d68 <strcmp>:
ffffffffc0201d68:	00054783          	lbu	a5,0(a0)
ffffffffc0201d6c:	0005c703          	lbu	a4,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201d70:	cb89                	beqz	a5,ffffffffc0201d82 <strcmp+0x1a>
ffffffffc0201d72:	0505                	addi	a0,a0,1
ffffffffc0201d74:	0585                	addi	a1,a1,1
ffffffffc0201d76:	fee789e3          	beq	a5,a4,ffffffffc0201d68 <strcmp>
ffffffffc0201d7a:	0007851b          	sext.w	a0,a5
ffffffffc0201d7e:	9d19                	subw	a0,a0,a4
ffffffffc0201d80:	8082                	ret
ffffffffc0201d82:	4501                	li	a0,0
ffffffffc0201d84:	bfed                	j	ffffffffc0201d7e <strcmp+0x16>

ffffffffc0201d86 <strchr>:
ffffffffc0201d86:	00054783          	lbu	a5,0(a0)
ffffffffc0201d8a:	c799                	beqz	a5,ffffffffc0201d98 <strchr+0x12>
ffffffffc0201d8c:	00f58763          	beq	a1,a5,ffffffffc0201d9a <strchr+0x14>
ffffffffc0201d90:	00154783          	lbu	a5,1(a0)
ffffffffc0201d94:	0505                	addi	a0,a0,1
ffffffffc0201d96:	fbfd                	bnez	a5,ffffffffc0201d8c <strchr+0x6>
ffffffffc0201d98:	4501                	li	a0,0
ffffffffc0201d9a:	8082                	ret

ffffffffc0201d9c <memset>:
ffffffffc0201d9c:	ca01                	beqz	a2,ffffffffc0201dac <memset+0x10>
ffffffffc0201d9e:	962a                	add	a2,a2,a0
ffffffffc0201da0:	87aa                	mv	a5,a0
ffffffffc0201da2:	0785                	addi	a5,a5,1
ffffffffc0201da4:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201da8:	fec79de3          	bne	a5,a2,ffffffffc0201da2 <memset+0x6>
ffffffffc0201dac:	8082                	ret
