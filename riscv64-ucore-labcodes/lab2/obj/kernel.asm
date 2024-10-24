
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
ffffffffc020003e:	49e60613          	addi	a2,a2,1182 # ffffffffc02064d8 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	76f010ef          	jal	ra,ffffffffc0201fb8 <memset>
    cons_init();  // init the console
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	f7e50513          	addi	a0,a0,-130 # ffffffffc0201fd0 <etext+0x6>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>

    print_kerninfo();
ffffffffc020005e:	0e4000ef          	jal	ra,ffffffffc0200142 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	572010ef          	jal	ra,ffffffffc02015d8 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>

    // check slub pmm
    slub_init();
ffffffffc0200076:	0e3010ef          	jal	ra,ffffffffc0201958 <slub_init>
    slub_check();
ffffffffc020007a:	0eb010ef          	jal	ra,ffffffffc0201964 <slub_check>

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
ffffffffc02000ae:	21b010ef          	jal	ra,ffffffffc0201ac8 <vprintfmt>
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
ffffffffc02000e4:	1e5010ef          	jal	ra,ffffffffc0201ac8 <vprintfmt>
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
ffffffffc0200148:	eac50513          	addi	a0,a0,-340 # ffffffffc0201ff0 <etext+0x26>
ffffffffc020014c:	e406                	sd	ra,8(sp)
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200152:	00000597          	auipc	a1,0x0
ffffffffc0200156:	ee058593          	addi	a1,a1,-288 # ffffffffc0200032 <kern_init>
ffffffffc020015a:	00002517          	auipc	a0,0x2
ffffffffc020015e:	eb650513          	addi	a0,a0,-330 # ffffffffc0202010 <etext+0x46>
ffffffffc0200162:	f59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200166:	00002597          	auipc	a1,0x2
ffffffffc020016a:	e6458593          	addi	a1,a1,-412 # ffffffffc0201fca <etext>
ffffffffc020016e:	00002517          	auipc	a0,0x2
ffffffffc0200172:	ec250513          	addi	a0,a0,-318 # ffffffffc0202030 <etext+0x66>
ffffffffc0200176:	f45ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020017a:	00006597          	auipc	a1,0x6
ffffffffc020017e:	eb658593          	addi	a1,a1,-330 # ffffffffc0206030 <free_area>
ffffffffc0200182:	00002517          	auipc	a0,0x2
ffffffffc0200186:	ece50513          	addi	a0,a0,-306 # ffffffffc0202050 <etext+0x86>
ffffffffc020018a:	f31ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020018e:	00006597          	auipc	a1,0x6
ffffffffc0200192:	34a58593          	addi	a1,a1,842 # ffffffffc02064d8 <end>
ffffffffc0200196:	00002517          	auipc	a0,0x2
ffffffffc020019a:	eda50513          	addi	a0,a0,-294 # ffffffffc0202070 <etext+0xa6>
ffffffffc020019e:	f1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001a2:	00006597          	auipc	a1,0x6
ffffffffc02001a6:	73558593          	addi	a1,a1,1845 # ffffffffc02068d7 <end+0x3ff>
ffffffffc02001aa:	00000797          	auipc	a5,0x0
ffffffffc02001ae:	e8878793          	addi	a5,a5,-376 # ffffffffc0200032 <kern_init>
ffffffffc02001b2:	40f587b3          	sub	a5,a1,a5
ffffffffc02001b6:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02001ba:	60a2                	ld	ra,8(sp)
ffffffffc02001bc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001c0:	95be                	add	a1,a1,a5
ffffffffc02001c2:	85a9                	srai	a1,a1,0xa
ffffffffc02001c4:	00002517          	auipc	a0,0x2
ffffffffc02001c8:	ecc50513          	addi	a0,a0,-308 # ffffffffc0202090 <etext+0xc6>
ffffffffc02001cc:	0141                	addi	sp,sp,16
ffffffffc02001ce:	b5f5                	j	ffffffffc02000ba <cprintf>

ffffffffc02001d0 <print_stackframe>:
ffffffffc02001d0:	1141                	addi	sp,sp,-16
ffffffffc02001d2:	00002617          	auipc	a2,0x2
ffffffffc02001d6:	eee60613          	addi	a2,a2,-274 # ffffffffc02020c0 <etext+0xf6>
ffffffffc02001da:	04e00593          	li	a1,78
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	efa50513          	addi	a0,a0,-262 # ffffffffc02020d8 <etext+0x10e>
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	1cc000ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc02001ec <mon_help>:
ffffffffc02001ec:	1141                	addi	sp,sp,-16
ffffffffc02001ee:	00002617          	auipc	a2,0x2
ffffffffc02001f2:	f0260613          	addi	a2,a2,-254 # ffffffffc02020f0 <etext+0x126>
ffffffffc02001f6:	00002597          	auipc	a1,0x2
ffffffffc02001fa:	f1a58593          	addi	a1,a1,-230 # ffffffffc0202110 <etext+0x146>
ffffffffc02001fe:	00002517          	auipc	a0,0x2
ffffffffc0200202:	f1a50513          	addi	a0,a0,-230 # ffffffffc0202118 <etext+0x14e>
ffffffffc0200206:	e406                	sd	ra,8(sp)
ffffffffc0200208:	eb3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020020c:	00002617          	auipc	a2,0x2
ffffffffc0200210:	f1c60613          	addi	a2,a2,-228 # ffffffffc0202128 <etext+0x15e>
ffffffffc0200214:	00002597          	auipc	a1,0x2
ffffffffc0200218:	f3c58593          	addi	a1,a1,-196 # ffffffffc0202150 <etext+0x186>
ffffffffc020021c:	00002517          	auipc	a0,0x2
ffffffffc0200220:	efc50513          	addi	a0,a0,-260 # ffffffffc0202118 <etext+0x14e>
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00002617          	auipc	a2,0x2
ffffffffc020022c:	f3860613          	addi	a2,a2,-200 # ffffffffc0202160 <etext+0x196>
ffffffffc0200230:	00002597          	auipc	a1,0x2
ffffffffc0200234:	f5058593          	addi	a1,a1,-176 # ffffffffc0202180 <etext+0x1b6>
ffffffffc0200238:	00002517          	auipc	a0,0x2
ffffffffc020023c:	ee050513          	addi	a0,a0,-288 # ffffffffc0202118 <etext+0x14e>
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
ffffffffc0200276:	f1e50513          	addi	a0,a0,-226 # ffffffffc0202190 <etext+0x1c6>
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
ffffffffc0200298:	f2450513          	addi	a0,a0,-220 # ffffffffc02021b8 <etext+0x1ee>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002a0:	000b8563          	beqz	s7,ffffffffc02002aa <kmonitor+0x3e>
ffffffffc02002a4:	855e                	mv	a0,s7
ffffffffc02002a6:	3a4000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc02002aa:	00002c17          	auipc	s8,0x2
ffffffffc02002ae:	f7ec0c13          	addi	s8,s8,-130 # ffffffffc0202228 <commands>
ffffffffc02002b2:	00002917          	auipc	s2,0x2
ffffffffc02002b6:	f2e90913          	addi	s2,s2,-210 # ffffffffc02021e0 <etext+0x216>
ffffffffc02002ba:	00002497          	auipc	s1,0x2
ffffffffc02002be:	f2e48493          	addi	s1,s1,-210 # ffffffffc02021e8 <etext+0x21e>
ffffffffc02002c2:	49bd                	li	s3,15
ffffffffc02002c4:	00002b17          	auipc	s6,0x2
ffffffffc02002c8:	f2cb0b13          	addi	s6,s6,-212 # ffffffffc02021f0 <etext+0x226>
ffffffffc02002cc:	00002a17          	auipc	s4,0x2
ffffffffc02002d0:	e44a0a13          	addi	s4,s4,-444 # ffffffffc0202110 <etext+0x146>
ffffffffc02002d4:	4a8d                	li	s5,3
ffffffffc02002d6:	854a                	mv	a0,s2
ffffffffc02002d8:	373010ef          	jal	ra,ffffffffc0201e4a <readline>
ffffffffc02002dc:	842a                	mv	s0,a0
ffffffffc02002de:	dd65                	beqz	a0,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002e0:	00054583          	lbu	a1,0(a0)
ffffffffc02002e4:	4c81                	li	s9,0
ffffffffc02002e6:	e1bd                	bnez	a1,ffffffffc020034c <kmonitor+0xe0>
ffffffffc02002e8:	fe0c87e3          	beqz	s9,ffffffffc02002d6 <kmonitor+0x6a>
ffffffffc02002ec:	6582                	ld	a1,0(sp)
ffffffffc02002ee:	00002d17          	auipc	s10,0x2
ffffffffc02002f2:	f3ad0d13          	addi	s10,s10,-198 # ffffffffc0202228 <commands>
ffffffffc02002f6:	8552                	mv	a0,s4
ffffffffc02002f8:	4401                	li	s0,0
ffffffffc02002fa:	0d61                	addi	s10,s10,24
ffffffffc02002fc:	489010ef          	jal	ra,ffffffffc0201f84 <strcmp>
ffffffffc0200300:	c919                	beqz	a0,ffffffffc0200316 <kmonitor+0xaa>
ffffffffc0200302:	2405                	addiw	s0,s0,1
ffffffffc0200304:	0b540063          	beq	s0,s5,ffffffffc02003a4 <kmonitor+0x138>
ffffffffc0200308:	000d3503          	ld	a0,0(s10)
ffffffffc020030c:	6582                	ld	a1,0(sp)
ffffffffc020030e:	0d61                	addi	s10,s10,24
ffffffffc0200310:	475010ef          	jal	ra,ffffffffc0201f84 <strcmp>
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
ffffffffc020034e:	455010ef          	jal	ra,ffffffffc0201fa2 <strchr>
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
ffffffffc020038c:	417010ef          	jal	ra,ffffffffc0201fa2 <strchr>
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
ffffffffc02003aa:	e6a50513          	addi	a0,a0,-406 # ffffffffc0202210 <etext+0x246>
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
ffffffffc02003e6:	e8e50513          	addi	a0,a0,-370 # ffffffffc0202270 <commands+0x48>
ffffffffc02003ea:	e43e                	sd	a5,8(sp)
ffffffffc02003ec:	ccfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003f0:	65a2                	ld	a1,8(sp)
ffffffffc02003f2:	8522                	mv	a0,s0
ffffffffc02003f4:	ca7ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
ffffffffc02003f8:	00002517          	auipc	a0,0x2
ffffffffc02003fc:	cc050513          	addi	a0,a0,-832 # ffffffffc02020b8 <etext+0xee>
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
ffffffffc0200428:	2f1010ef          	jal	ra,ffffffffc0201f18 <sbi_set_timer>
ffffffffc020042c:	60a2                	ld	ra,8(sp)
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	0207b123          	sd	zero,34(a5) # ffffffffc0206450 <ticks>
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	e5a50513          	addi	a0,a0,-422 # ffffffffc0202290 <commands+0x68>
ffffffffc020043e:	0141                	addi	sp,sp,16
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
ffffffffc0200442:	c0102573          	rdtime	a0
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	2cb0106f          	j	ffffffffc0201f18 <sbi_set_timer>

ffffffffc0200452 <cons_init>:
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:
ffffffffc0200454:	0ff57513          	andi	a0,a0,255
ffffffffc0200458:	2a70106f          	j	ffffffffc0201efe <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
ffffffffc020045c:	2d70106f          	j	ffffffffc0201f32 <sbi_console_getchar>

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
ffffffffc020048a:	e2a50513          	addi	a0,a0,-470 # ffffffffc02022b0 <commands+0x88>
ffffffffc020048e:	e406                	sd	ra,8(sp)
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00002517          	auipc	a0,0x2
ffffffffc020049a:	e3250513          	addi	a0,a0,-462 # ffffffffc02022c8 <commands+0xa0>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	e3c50513          	addi	a0,a0,-452 # ffffffffc02022e0 <commands+0xb8>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	e4650513          	addi	a0,a0,-442 # ffffffffc02022f8 <commands+0xd0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	e5050513          	addi	a0,a0,-432 # ffffffffc0202310 <commands+0xe8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00002517          	auipc	a0,0x2
ffffffffc02004d2:	e5a50513          	addi	a0,a0,-422 # ffffffffc0202328 <commands+0x100>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00002517          	auipc	a0,0x2
ffffffffc02004e0:	e6450513          	addi	a0,a0,-412 # ffffffffc0202340 <commands+0x118>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00002517          	auipc	a0,0x2
ffffffffc02004ee:	e6e50513          	addi	a0,a0,-402 # ffffffffc0202358 <commands+0x130>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00002517          	auipc	a0,0x2
ffffffffc02004fc:	e7850513          	addi	a0,a0,-392 # ffffffffc0202370 <commands+0x148>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00002517          	auipc	a0,0x2
ffffffffc020050a:	e8250513          	addi	a0,a0,-382 # ffffffffc0202388 <commands+0x160>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00002517          	auipc	a0,0x2
ffffffffc0200518:	e8c50513          	addi	a0,a0,-372 # ffffffffc02023a0 <commands+0x178>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00002517          	auipc	a0,0x2
ffffffffc0200526:	e9650513          	addi	a0,a0,-362 # ffffffffc02023b8 <commands+0x190>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00002517          	auipc	a0,0x2
ffffffffc0200534:	ea050513          	addi	a0,a0,-352 # ffffffffc02023d0 <commands+0x1a8>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00002517          	auipc	a0,0x2
ffffffffc0200542:	eaa50513          	addi	a0,a0,-342 # ffffffffc02023e8 <commands+0x1c0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00002517          	auipc	a0,0x2
ffffffffc0200550:	eb450513          	addi	a0,a0,-332 # ffffffffc0202400 <commands+0x1d8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00002517          	auipc	a0,0x2
ffffffffc020055e:	ebe50513          	addi	a0,a0,-322 # ffffffffc0202418 <commands+0x1f0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00002517          	auipc	a0,0x2
ffffffffc020056c:	ec850513          	addi	a0,a0,-312 # ffffffffc0202430 <commands+0x208>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	ed250513          	addi	a0,a0,-302 # ffffffffc0202448 <commands+0x220>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	edc50513          	addi	a0,a0,-292 # ffffffffc0202460 <commands+0x238>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00002517          	auipc	a0,0x2
ffffffffc0200596:	ee650513          	addi	a0,a0,-282 # ffffffffc0202478 <commands+0x250>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00002517          	auipc	a0,0x2
ffffffffc02005a4:	ef050513          	addi	a0,a0,-272 # ffffffffc0202490 <commands+0x268>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00002517          	auipc	a0,0x2
ffffffffc02005b2:	efa50513          	addi	a0,a0,-262 # ffffffffc02024a8 <commands+0x280>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00002517          	auipc	a0,0x2
ffffffffc02005c0:	f0450513          	addi	a0,a0,-252 # ffffffffc02024c0 <commands+0x298>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00002517          	auipc	a0,0x2
ffffffffc02005ce:	f0e50513          	addi	a0,a0,-242 # ffffffffc02024d8 <commands+0x2b0>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00002517          	auipc	a0,0x2
ffffffffc02005dc:	f1850513          	addi	a0,a0,-232 # ffffffffc02024f0 <commands+0x2c8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	f2250513          	addi	a0,a0,-222 # ffffffffc0202508 <commands+0x2e0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00002517          	auipc	a0,0x2
ffffffffc02005f8:	f2c50513          	addi	a0,a0,-212 # ffffffffc0202520 <commands+0x2f8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00002517          	auipc	a0,0x2
ffffffffc0200606:	f3650513          	addi	a0,a0,-202 # ffffffffc0202538 <commands+0x310>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	f4050513          	addi	a0,a0,-192 # ffffffffc0202550 <commands+0x328>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	f4a50513          	addi	a0,a0,-182 # ffffffffc0202568 <commands+0x340>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00002517          	auipc	a0,0x2
ffffffffc0200630:	f5450513          	addi	a0,a0,-172 # ffffffffc0202580 <commands+0x358>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	f5a50513          	addi	a0,a0,-166 # ffffffffc0202598 <commands+0x370>
ffffffffc0200646:	0141                	addi	sp,sp,16
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
ffffffffc020064e:	85aa                	mv	a1,a0
ffffffffc0200650:	842a                	mv	s0,a0
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	f5e50513          	addi	a0,a0,-162 # ffffffffc02025b0 <commands+0x388>
ffffffffc020065a:	e406                	sd	ra,8(sp)
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00002517          	auipc	a0,0x2
ffffffffc020066e:	f5e50513          	addi	a0,a0,-162 # ffffffffc02025c8 <commands+0x3a0>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	f6650513          	addi	a0,a0,-154 # ffffffffc02025e0 <commands+0x3b8>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00002517          	auipc	a0,0x2
ffffffffc020068e:	f6e50513          	addi	a0,a0,-146 # ffffffffc02025f8 <commands+0x3d0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200696:	11843583          	ld	a1,280(s0)
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
ffffffffc020069e:	00002517          	auipc	a0,0x2
ffffffffc02006a2:	f7250513          	addi	a0,a0,-142 # ffffffffc0202610 <commands+0x3e8>
ffffffffc02006a6:	0141                	addi	sp,sp,16
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	08f76663          	bltu	a4,a5,ffffffffc0200740 <interrupt_handler+0x96>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	03870713          	addi	a4,a4,56 # ffffffffc02026f0 <commands+0x4c8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	fbe50513          	addi	a0,a0,-66 # ffffffffc0202688 <commands+0x460>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	f9450513          	addi	a0,a0,-108 # ffffffffc0202668 <commands+0x440>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
ffffffffc02006de:	00002517          	auipc	a0,0x2
ffffffffc02006e2:	f4a50513          	addi	a0,a0,-182 # ffffffffc0202628 <commands+0x400>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
ffffffffc02006e8:	00002517          	auipc	a0,0x2
ffffffffc02006ec:	fc050513          	addi	a0,a0,-64 # ffffffffc02026a8 <commands+0x480>
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
ffffffffc0200730:	fa450513          	addi	a0,a0,-92 # ffffffffc02026d0 <commands+0x4a8>
ffffffffc0200734:	b259                	j	ffffffffc02000ba <cprintf>
ffffffffc0200736:	00002517          	auipc	a0,0x2
ffffffffc020073a:	f1250513          	addi	a0,a0,-238 # ffffffffc0202648 <commands+0x420>
ffffffffc020073e:	bab5                	j	ffffffffc02000ba <cprintf>
ffffffffc0200740:	b729                	j	ffffffffc020064a <print_trapframe>
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	f7a50513          	addi	a0,a0,-134 # ffffffffc02026c0 <commands+0x498>
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
ffffffffc0200768:	7e60106f          	j	ffffffffc0201f4e <sbi_shutdown>

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
ffffffffc020078c:	f9850513          	addi	a0,a0,-104 # ffffffffc0202720 <commands+0x4f8>
ffffffffc0200790:	92bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200794:	10843583          	ld	a1,264(s0)
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	fb050513          	addi	a0,a0,-80 # ffffffffc0202748 <commands+0x520>
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
ffffffffc02007ca:	faa50513          	addi	a0,a0,-86 # ffffffffc0202770 <commands+0x548>
ffffffffc02007ce:	8edff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007d2:	10843583          	ld	a1,264(s0)
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	f7250513          	addi	a0,a0,-142 # ffffffffc0202748 <commands+0x520>
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
ffffffffc02008d6:	e022                	sd	s0,0(sp)
ffffffffc02008d8:	20058763          	beqz	a1,ffffffffc0200ae6 <buddy_free_pages+0x214>
ffffffffc02008dc:	0015d793          	srli	a5,a1,0x1
ffffffffc02008e0:	8fcd                	or	a5,a5,a1
ffffffffc02008e2:	0027d713          	srli	a4,a5,0x2
ffffffffc02008e6:	8fd9                	or	a5,a5,a4
ffffffffc02008e8:	0047d713          	srli	a4,a5,0x4
ffffffffc02008ec:	8f5d                	or	a4,a4,a5
ffffffffc02008ee:	00875793          	srli	a5,a4,0x8
ffffffffc02008f2:	8f5d                	or	a4,a4,a5
ffffffffc02008f4:	01075793          	srli	a5,a4,0x10
ffffffffc02008f8:	8fd9                	or	a5,a5,a4
ffffffffc02008fa:	8385                	srli	a5,a5,0x1
ffffffffc02008fc:	00b7f733          	and	a4,a5,a1
ffffffffc0200900:	8e2e                	mv	t3,a1
ffffffffc0200902:	1a071c63          	bnez	a4,ffffffffc0200aba <buddy_free_pages+0x1e8>
ffffffffc0200906:	00006897          	auipc	a7,0x6
ffffffffc020090a:	b5a8b883          	ld	a7,-1190(a7) # ffffffffc0206460 <allocate_area>
ffffffffc020090e:	411506b3          	sub	a3,a0,a7
ffffffffc0200912:	00002797          	auipc	a5,0x2
ffffffffc0200916:	55e7b783          	ld	a5,1374(a5) # ffffffffc0202e70 <error_string+0x38>
ffffffffc020091a:	868d                	srai	a3,a3,0x3
ffffffffc020091c:	02f686b3          	mul	a3,a3,a5
ffffffffc0200920:	00006817          	auipc	a6,0x6
ffffffffc0200924:	b4883803          	ld	a6,-1208(a6) # ffffffffc0206468 <full_tree_size>
ffffffffc0200928:	00259613          	slli	a2,a1,0x2
ffffffffc020092c:	962e                	add	a2,a2,a1
ffffffffc020092e:	060e                	slli	a2,a2,0x3
ffffffffc0200930:	962a                	add	a2,a2,a0
ffffffffc0200932:	87aa                	mv	a5,a0
ffffffffc0200934:	03c6d6b3          	divu	a3,a3,t3
ffffffffc0200938:	03c85733          	divu	a4,a6,t3
ffffffffc020093c:	96ba                	add	a3,a3,a4
ffffffffc020093e:	00c50e63          	beq	a0,a2,ffffffffc020095a <buddy_free_pages+0x88>
ffffffffc0200942:	6798                	ld	a4,8(a5)
ffffffffc0200944:	8b05                	andi	a4,a4,1
ffffffffc0200946:	18071063          	bnez	a4,ffffffffc0200ac6 <buddy_free_pages+0x1f4>
ffffffffc020094a:	0007b423          	sd	zero,8(a5)
ffffffffc020094e:	0007a023          	sw	zero,0(a5)
ffffffffc0200952:	02878793          	addi	a5,a5,40
ffffffffc0200956:	fec796e3          	bne	a5,a2,ffffffffc0200942 <buddy_free_pages+0x70>
ffffffffc020095a:	00005317          	auipc	t1,0x5
ffffffffc020095e:	6d630313          	addi	t1,t1,1750 # ffffffffc0206030 <free_area>
ffffffffc0200962:	01032783          	lw	a5,16(t1)
ffffffffc0200966:	00833603          	ld	a2,8(t1)
ffffffffc020096a:	000e071b          	sext.w	a4,t3
ffffffffc020096e:	c918                	sw	a4,16(a0)
ffffffffc0200970:	01850e93          	addi	t4,a0,24
ffffffffc0200974:	01d63023          	sd	t4,0(a2)
ffffffffc0200978:	9fb9                	addw	a5,a5,a4
ffffffffc020097a:	00006597          	auipc	a1,0x6
ffffffffc020097e:	b065b583          	ld	a1,-1274(a1) # ffffffffc0206480 <record_area>
ffffffffc0200982:	00369713          	slli	a4,a3,0x3
ffffffffc0200986:	f110                	sd	a2,32(a0)
ffffffffc0200988:	00653c23          	sd	t1,24(a0)
ffffffffc020098c:	00f32823          	sw	a5,16(t1)
ffffffffc0200990:	01d33423          	sd	t4,8(t1)
ffffffffc0200994:	972e                	add	a4,a4,a1
ffffffffc0200996:	01c73023          	sd	t3,0(a4)
ffffffffc020099a:	4785                	li	a5,1
ffffffffc020099c:	4505                	li	a0,1
ffffffffc020099e:	06f68563          	beq	a3,a5,ffffffffc0200a08 <buddy_free_pages+0x136>
ffffffffc02009a2:	ffe6f793          	andi	a5,a3,-2
ffffffffc02009a6:	8285                	srli	a3,a3,0x1
ffffffffc02009a8:	00f6e733          	or	a4,a3,a5
ffffffffc02009ac:	00275613          	srli	a2,a4,0x2
ffffffffc02009b0:	8f51                	or	a4,a4,a2
ffffffffc02009b2:	00475613          	srli	a2,a4,0x4
ffffffffc02009b6:	8e59                	or	a2,a2,a4
ffffffffc02009b8:	00865713          	srli	a4,a2,0x8
ffffffffc02009bc:	8e59                	or	a2,a2,a4
ffffffffc02009be:	01065713          	srli	a4,a2,0x10
ffffffffc02009c2:	8f51                	or	a4,a4,a2
ffffffffc02009c4:	00379e13          	slli	t3,a5,0x3
ffffffffc02009c8:	8305                	srli	a4,a4,0x1
ffffffffc02009ca:	9e2e                	add	t3,t3,a1
ffffffffc02009cc:	00f77f33          	and	t5,a4,a5
ffffffffc02009d0:	000e3283          	ld	t0,0(t3)
ffffffffc02009d4:	863e                	mv	a2,a5
ffffffffc02009d6:	000f0663          	beqz	t5,ffffffffc02009e2 <buddy_free_pages+0x110>
ffffffffc02009da:	fff74713          	not	a4,a4
ffffffffc02009de:	00f77633          	and	a2,a4,a5
ffffffffc02009e2:	02c85733          	divu	a4,a6,a2
ffffffffc02009e6:	00369613          	slli	a2,a3,0x3
ffffffffc02009ea:	00c58eb3          	add	t4,a1,a2
ffffffffc02009ee:	02e28163          	beq	t0,a4,ffffffffc0200a10 <buddy_free_pages+0x13e>
ffffffffc02009f2:	00469793          	slli	a5,a3,0x4
ffffffffc02009f6:	97ae                	add	a5,a5,a1
ffffffffc02009f8:	9676                	add	a2,a2,t4
ffffffffc02009fa:	679c                	ld	a5,8(a5)
ffffffffc02009fc:	6218                	ld	a4,0(a2)
ffffffffc02009fe:	8fd9                	or	a5,a5,a4
ffffffffc0200a00:	00feb023          	sd	a5,0(t4)
ffffffffc0200a04:	f8a69fe3          	bne	a3,a0,ffffffffc02009a2 <buddy_free_pages+0xd0>
ffffffffc0200a08:	60a2                	ld	ra,8(sp)
ffffffffc0200a0a:	6402                	ld	s0,0(sp)
ffffffffc0200a0c:	0141                	addi	sp,sp,16
ffffffffc0200a0e:	8082                	ret
ffffffffc0200a10:	00178f93          	addi	t6,a5,1
ffffffffc0200a14:	8385                	srli	a5,a5,0x1
ffffffffc0200a16:	01f7e7b3          	or	a5,a5,t6
ffffffffc0200a1a:	0027d393          	srli	t2,a5,0x2
ffffffffc0200a1e:	00f3e7b3          	or	a5,t2,a5
ffffffffc0200a22:	0047d393          	srli	t2,a5,0x4
ffffffffc0200a26:	00f3e3b3          	or	t2,t2,a5
ffffffffc0200a2a:	0083d793          	srli	a5,t2,0x8
ffffffffc0200a2e:	0077e3b3          	or	t2,a5,t2
ffffffffc0200a32:	0103d793          	srli	a5,t2,0x10
ffffffffc0200a36:	0077e7b3          	or	a5,a5,t2
ffffffffc0200a3a:	8385                	srli	a5,a5,0x1
ffffffffc0200a3c:	01f7f3b3          	and	t2,a5,t6
ffffffffc0200a40:	008e3403          	ld	s0,8(t3)
ffffffffc0200a44:	00038663          	beqz	t2,ffffffffc0200a50 <buddy_free_pages+0x17e>
ffffffffc0200a48:	fff7c793          	not	a5,a5
ffffffffc0200a4c:	00ffffb3          	and	t6,t6,a5
ffffffffc0200a50:	03f85fb3          	divu	t6,a6,t6
ffffffffc0200a54:	f9f41fe3          	bne	s0,t6,ffffffffc02009f2 <buddy_free_pages+0x120>
ffffffffc0200a58:	02ef0733          	mul	a4,t5,a4
ffffffffc0200a5c:	0286                	slli	t0,t0,0x1
ffffffffc0200a5e:	028383b3          	mul	t2,t2,s0
ffffffffc0200a62:	00271793          	slli	a5,a4,0x2
ffffffffc0200a66:	973e                	add	a4,a4,a5
ffffffffc0200a68:	00371793          	slli	a5,a4,0x3
ffffffffc0200a6c:	97c6                	add	a5,a5,a7
ffffffffc0200a6e:	7390                	ld	a2,32(a5)
ffffffffc0200a70:	0187bf83          	ld	t6,24(a5)
ffffffffc0200a74:	01878f13          	addi	t5,a5,24
ffffffffc0200a78:	00cfb423          	sd	a2,8(t6)
ffffffffc0200a7c:	00239713          	slli	a4,t2,0x2
ffffffffc0200a80:	93ba                	add	t2,t2,a4
ffffffffc0200a82:	00339713          	slli	a4,t2,0x3
ffffffffc0200a86:	01f63023          	sd	t6,0(a2)
ffffffffc0200a8a:	9746                	add	a4,a4,a7
ffffffffc0200a8c:	6f10                	ld	a2,24(a4)
ffffffffc0200a8e:	7318                	ld	a4,32(a4)
ffffffffc0200a90:	e618                	sd	a4,8(a2)
ffffffffc0200a92:	e310                	sd	a2,0(a4)
ffffffffc0200a94:	005eb023          	sd	t0,0(t4)
ffffffffc0200a98:	000e3703          	ld	a4,0(t3)
ffffffffc0200a9c:	00833603          	ld	a2,8(t1)
ffffffffc0200aa0:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200aa4:	cb98                	sw	a4,16(a5)
ffffffffc0200aa6:	01e63023          	sd	t5,0(a2)
ffffffffc0200aaa:	01e33423          	sd	t5,8(t1)
ffffffffc0200aae:	f390                	sd	a2,32(a5)
ffffffffc0200ab0:	0067bc23          	sd	t1,24(a5)
ffffffffc0200ab4:	eea697e3          	bne	a3,a0,ffffffffc02009a2 <buddy_free_pages+0xd0>
ffffffffc0200ab8:	bf81                	j	ffffffffc0200a08 <buddy_free_pages+0x136>
ffffffffc0200aba:	fff7c793          	not	a5,a5
ffffffffc0200abe:	8fed                	and	a5,a5,a1
ffffffffc0200ac0:	00179e13          	slli	t3,a5,0x1
ffffffffc0200ac4:	b589                	j	ffffffffc0200906 <buddy_free_pages+0x34>
ffffffffc0200ac6:	00002697          	auipc	a3,0x2
ffffffffc0200aca:	d0268693          	addi	a3,a3,-766 # ffffffffc02027c8 <commands+0x5a0>
ffffffffc0200ace:	00002617          	auipc	a2,0x2
ffffffffc0200ad2:	cca60613          	addi	a2,a2,-822 # ffffffffc0202798 <commands+0x570>
ffffffffc0200ad6:	0cb00593          	li	a1,203
ffffffffc0200ada:	00002517          	auipc	a0,0x2
ffffffffc0200ade:	cd650513          	addi	a0,a0,-810 # ffffffffc02027b0 <commands+0x588>
ffffffffc0200ae2:	8d3ff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc0200ae6:	00002697          	auipc	a3,0x2
ffffffffc0200aea:	caa68693          	addi	a3,a3,-854 # ffffffffc0202790 <commands+0x568>
ffffffffc0200aee:	00002617          	auipc	a2,0x2
ffffffffc0200af2:	caa60613          	addi	a2,a2,-854 # ffffffffc0202798 <commands+0x570>
ffffffffc0200af6:	0c100593          	li	a1,193
ffffffffc0200afa:	00002517          	auipc	a0,0x2
ffffffffc0200afe:	cb650513          	addi	a0,a0,-842 # ffffffffc02027b0 <commands+0x588>
ffffffffc0200b02:	8b3ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200b06 <buddy_allocate_pages>:
ffffffffc0200b06:	1e050063          	beqz	a0,ffffffffc0200ce6 <buddy_allocate_pages+0x1e0>
ffffffffc0200b0a:	00155793          	srli	a5,a0,0x1
ffffffffc0200b0e:	8fc9                	or	a5,a5,a0
ffffffffc0200b10:	0027d713          	srli	a4,a5,0x2
ffffffffc0200b14:	8fd9                	or	a5,a5,a4
ffffffffc0200b16:	0047d713          	srli	a4,a5,0x4
ffffffffc0200b1a:	8f5d                	or	a4,a4,a5
ffffffffc0200b1c:	00875793          	srli	a5,a4,0x8
ffffffffc0200b20:	8f5d                	or	a4,a4,a5
ffffffffc0200b22:	01075793          	srli	a5,a4,0x10
ffffffffc0200b26:	8fd9                	or	a5,a5,a4
ffffffffc0200b28:	8385                	srli	a5,a5,0x1
ffffffffc0200b2a:	00a7f733          	and	a4,a5,a0
ffffffffc0200b2e:	18071963          	bnez	a4,ffffffffc0200cc0 <buddy_allocate_pages+0x1ba>
ffffffffc0200b32:	00006897          	auipc	a7,0x6
ffffffffc0200b36:	94e8b883          	ld	a7,-1714(a7) # ffffffffc0206480 <record_area>
ffffffffc0200b3a:	0088b783          	ld	a5,8(a7)
ffffffffc0200b3e:	00888f93          	addi	t6,a7,8
ffffffffc0200b42:	16a7e763          	bltu	a5,a0,ffffffffc0200cb0 <buddy_allocate_pages+0x1aa>
ffffffffc0200b46:	00006e97          	auipc	t4,0x6
ffffffffc0200b4a:	922ebe83          	ld	t4,-1758(t4) # ffffffffc0206468 <full_tree_size>
ffffffffc0200b4e:	4585                	li	a1,1
ffffffffc0200b50:	02bed5b3          	divu	a1,t4,a1
ffffffffc0200b54:	00006317          	auipc	t1,0x6
ffffffffc0200b58:	90c33303          	ld	t1,-1780(t1) # ffffffffc0206460 <allocate_area>
ffffffffc0200b5c:	4801                	li	a6,0
ffffffffc0200b5e:	4601                	li	a2,0
ffffffffc0200b60:	4685                	li	a3,1
ffffffffc0200b62:	00005f17          	auipc	t5,0x5
ffffffffc0200b66:	4cef0f13          	addi	t5,t5,1230 # ffffffffc0206030 <free_area>
ffffffffc0200b6a:	06b57e63          	bgeu	a0,a1,ffffffffc0200be6 <buddy_allocate_pages+0xe0>
ffffffffc0200b6e:	00169713          	slli	a4,a3,0x1
ffffffffc0200b72:	00469613          	slli	a2,a3,0x4
ffffffffc0200b76:	00170293          	addi	t0,a4,1
ffffffffc0200b7a:	00c88e33          	add	t3,a7,a2
ffffffffc0200b7e:	0af58f63          	beq	a1,a5,ffffffffc0200c3c <buddy_allocate_pages+0x136>
ffffffffc0200b82:	000e3783          	ld	a5,0(t3)
ffffffffc0200b86:	00a7f5b3          	and	a1,a5,a0
ffffffffc0200b8a:	12059163          	bnez	a1,ffffffffc0200cac <buddy_allocate_pages+0x1a6>
ffffffffc0200b8e:	0621                	addi	a2,a2,8
ffffffffc0200b90:	9646                	add	a2,a2,a7
ffffffffc0200b92:	620c                	ld	a1,0(a2)
ffffffffc0200b94:	00a5f833          	and	a6,a1,a0
ffffffffc0200b98:	10081e63          	bnez	a6,ffffffffc0200cb4 <buddy_allocate_pages+0x1ae>
ffffffffc0200b9c:	00a7f763          	bgeu	a5,a0,ffffffffc0200baa <buddy_allocate_pages+0xa4>
ffffffffc0200ba0:	12a5e963          	bltu	a1,a0,ffffffffc0200cd2 <buddy_allocate_pages+0x1cc>
ffffffffc0200ba4:	87ae                	mv	a5,a1
ffffffffc0200ba6:	8e32                	mv	t3,a2
ffffffffc0200ba8:	8716                	mv	a4,t0
ffffffffc0200baa:	00175613          	srli	a2,a4,0x1
ffffffffc0200bae:	8e59                	or	a2,a2,a4
ffffffffc0200bb0:	00265693          	srli	a3,a2,0x2
ffffffffc0200bb4:	8e55                	or	a2,a2,a3
ffffffffc0200bb6:	00465693          	srli	a3,a2,0x4
ffffffffc0200bba:	8ed1                	or	a3,a3,a2
ffffffffc0200bbc:	0086d613          	srli	a2,a3,0x8
ffffffffc0200bc0:	8ed1                	or	a3,a3,a2
ffffffffc0200bc2:	0106d613          	srli	a2,a3,0x10
ffffffffc0200bc6:	8e55                	or	a2,a2,a3
ffffffffc0200bc8:	8205                	srli	a2,a2,0x1
ffffffffc0200bca:	00e67833          	and	a6,a2,a4
ffffffffc0200bce:	85ba                	mv	a1,a4
ffffffffc0200bd0:	00080563          	beqz	a6,ffffffffc0200bda <buddy_allocate_pages+0xd4>
ffffffffc0200bd4:	fff64593          	not	a1,a2
ffffffffc0200bd8:	8df9                	and	a1,a1,a4
ffffffffc0200bda:	02bed5b3          	divu	a1,t4,a1
ffffffffc0200bde:	8ff2                	mv	t6,t3
ffffffffc0200be0:	86ba                	mv	a3,a4
ffffffffc0200be2:	f8b566e3          	bltu	a0,a1,ffffffffc0200b6e <buddy_allocate_pages+0x68>
ffffffffc0200be6:	0e081263          	bnez	a6,ffffffffc0200cca <buddy_allocate_pages+0x1c4>
ffffffffc0200bea:	8636                	mv	a2,a3
ffffffffc0200bec:	02ced633          	divu	a2,t4,a2
ffffffffc0200bf0:	00005597          	auipc	a1,0x5
ffffffffc0200bf4:	44058593          	addi	a1,a1,1088 # ffffffffc0206030 <free_area>
ffffffffc0200bf8:	4998                	lw	a4,16(a1)
ffffffffc0200bfa:	4e05                	li	t3,1
ffffffffc0200bfc:	9f09                	subw	a4,a4,a0
ffffffffc0200bfe:	030607b3          	mul	a5,a2,a6
ffffffffc0200c02:	00279513          	slli	a0,a5,0x2
ffffffffc0200c06:	953e                	add	a0,a0,a5
ffffffffc0200c08:	050e                	slli	a0,a0,0x3
ffffffffc0200c0a:	951a                	add	a0,a0,t1
ffffffffc0200c0c:	6d10                	ld	a2,24(a0)
ffffffffc0200c0e:	711c                	ld	a5,32(a0)
ffffffffc0200c10:	e61c                	sd	a5,8(a2)
ffffffffc0200c12:	e390                	sd	a2,0(a5)
ffffffffc0200c14:	000fb023          	sd	zero,0(t6)
ffffffffc0200c18:	c998                	sw	a4,16(a1)
ffffffffc0200c1a:	0dc68563          	beq	a3,t3,ffffffffc0200ce4 <buddy_allocate_pages+0x1de>
ffffffffc0200c1e:	4585                	li	a1,1
ffffffffc0200c20:	8285                	srli	a3,a3,0x1
ffffffffc0200c22:	00469793          	slli	a5,a3,0x4
ffffffffc0200c26:	97c6                	add	a5,a5,a7
ffffffffc0200c28:	6390                	ld	a2,0(a5)
ffffffffc0200c2a:	6798                	ld	a4,8(a5)
ffffffffc0200c2c:	00369793          	slli	a5,a3,0x3
ffffffffc0200c30:	97c6                	add	a5,a5,a7
ffffffffc0200c32:	8f51                	or	a4,a4,a2
ffffffffc0200c34:	e398                	sd	a4,0(a5)
ffffffffc0200c36:	feb695e3          	bne	a3,a1,ffffffffc0200c20 <buddy_allocate_pages+0x11a>
ffffffffc0200c3a:	8082                	ret
ffffffffc0200c3c:	03078833          	mul	a6,a5,a6
ffffffffc0200c40:	0017d393          	srli	t2,a5,0x1
ffffffffc0200c44:	00281693          	slli	a3,a6,0x2
ffffffffc0200c48:	96c2                	add	a3,a3,a6
ffffffffc0200c4a:	068e                	slli	a3,a3,0x3
ffffffffc0200c4c:	969a                	add	a3,a3,t1
ffffffffc0200c4e:	97c2                	add	a5,a5,a6
ffffffffc0200c50:	728c                	ld	a1,32(a3)
ffffffffc0200c52:	0186b283          	ld	t0,24(a3)
ffffffffc0200c56:	983e                	add	a6,a6,a5
ffffffffc0200c58:	00185813          	srli	a6,a6,0x1
ffffffffc0200c5c:	4a9c                	lw	a5,16(a3)
ffffffffc0200c5e:	00281613          	slli	a2,a6,0x2
ffffffffc0200c62:	00b2b423          	sd	a1,8(t0)
ffffffffc0200c66:	9642                	add	a2,a2,a6
ffffffffc0200c68:	0055b023          	sd	t0,0(a1)
ffffffffc0200c6c:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200c70:	060e                	slli	a2,a2,0x3
ffffffffc0200c72:	ca9c                	sw	a5,16(a3)
ffffffffc0200c74:	961a                	add	a2,a2,t1
ffffffffc0200c76:	ca1c                	sw	a5,16(a2)
ffffffffc0200c78:	007e3023          	sd	t2,0(t3)
ffffffffc0200c7c:	000fb783          	ld	a5,0(t6)
ffffffffc0200c80:	008f3f83          	ld	t6,8(t5)
ffffffffc0200c84:	01868593          	addi	a1,a3,24
ffffffffc0200c88:	8385                	srli	a5,a5,0x1
ffffffffc0200c8a:	00fe3423          	sd	a5,8(t3)
ffffffffc0200c8e:	00bfb023          	sd	a1,0(t6)
ffffffffc0200c92:	01860813          	addi	a6,a2,24
ffffffffc0200c96:	03f6b023          	sd	t6,32(a3)
ffffffffc0200c9a:	0106bc23          	sd	a6,24(a3)
ffffffffc0200c9e:	000e3783          	ld	a5,0(t3)
ffffffffc0200ca2:	010f3423          	sd	a6,8(t5)
ffffffffc0200ca6:	f20c                	sd	a1,32(a2)
ffffffffc0200ca8:	01e63c23          	sd	t5,24(a2)
ffffffffc0200cac:	eea7ffe3          	bgeu	a5,a0,ffffffffc0200baa <buddy_allocate_pages+0xa4>
ffffffffc0200cb0:	4501                	li	a0,0
ffffffffc0200cb2:	8082                	ret
ffffffffc0200cb4:	87ae                	mv	a5,a1
ffffffffc0200cb6:	8e32                	mv	t3,a2
ffffffffc0200cb8:	8716                	mv	a4,t0
ffffffffc0200cba:	eea7f8e3          	bgeu	a5,a0,ffffffffc0200baa <buddy_allocate_pages+0xa4>
ffffffffc0200cbe:	bfcd                	j	ffffffffc0200cb0 <buddy_allocate_pages+0x1aa>
ffffffffc0200cc0:	fff7c793          	not	a5,a5
ffffffffc0200cc4:	8d7d                	and	a0,a0,a5
ffffffffc0200cc6:	0506                	slli	a0,a0,0x1
ffffffffc0200cc8:	b5ad                	j	ffffffffc0200b32 <buddy_allocate_pages+0x2c>
ffffffffc0200cca:	fff64613          	not	a2,a2
ffffffffc0200cce:	8e75                	and	a2,a2,a3
ffffffffc0200cd0:	bf31                	j	ffffffffc0200bec <buddy_allocate_pages+0xe6>
ffffffffc0200cd2:	00369e13          	slli	t3,a3,0x3
ffffffffc0200cd6:	9e46                	add	t3,t3,a7
ffffffffc0200cd8:	000e3783          	ld	a5,0(t3)
ffffffffc0200cdc:	8736                	mv	a4,a3
ffffffffc0200cde:	eca7f6e3          	bgeu	a5,a0,ffffffffc0200baa <buddy_allocate_pages+0xa4>
ffffffffc0200ce2:	b7f9                	j	ffffffffc0200cb0 <buddy_allocate_pages+0x1aa>
ffffffffc0200ce4:	8082                	ret
ffffffffc0200ce6:	1141                	addi	sp,sp,-16
ffffffffc0200ce8:	00002697          	auipc	a3,0x2
ffffffffc0200cec:	aa868693          	addi	a3,a3,-1368 # ffffffffc0202790 <commands+0x568>
ffffffffc0200cf0:	00002617          	auipc	a2,0x2
ffffffffc0200cf4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0202798 <commands+0x570>
ffffffffc0200cf8:	08500593          	li	a1,133
ffffffffc0200cfc:	00002517          	auipc	a0,0x2
ffffffffc0200d00:	ab450513          	addi	a0,a0,-1356 # ffffffffc02027b0 <commands+0x588>
ffffffffc0200d04:	e406                	sd	ra,8(sp)
ffffffffc0200d06:	eaeff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0200d0a <buddy_init_memmap.part.0>:
ffffffffc0200d0a:	00259793          	slli	a5,a1,0x2
ffffffffc0200d0e:	97ae                	add	a5,a5,a1
ffffffffc0200d10:	7179                	addi	sp,sp,-48
ffffffffc0200d12:	078e                	slli	a5,a5,0x3
ffffffffc0200d14:	00f506b3          	add	a3,a0,a5
ffffffffc0200d18:	f406                	sd	ra,40(sp)
ffffffffc0200d1a:	f022                	sd	s0,32(sp)
ffffffffc0200d1c:	ec26                	sd	s1,24(sp)
ffffffffc0200d1e:	e84a                	sd	s2,16(sp)
ffffffffc0200d20:	e44e                	sd	s3,8(sp)
ffffffffc0200d22:	882a                	mv	a6,a0
ffffffffc0200d24:	87aa                	mv	a5,a0
ffffffffc0200d26:	00d57e63          	bgeu	a0,a3,ffffffffc0200d42 <buddy_init_memmap.part.0+0x38>
ffffffffc0200d2a:	6798                	ld	a4,8(a5)
ffffffffc0200d2c:	8b05                	andi	a4,a4,1
ffffffffc0200d2e:	2c070b63          	beqz	a4,ffffffffc0201004 <buddy_init_memmap.part.0+0x2fa>
ffffffffc0200d32:	0007a823          	sw	zero,16(a5)
ffffffffc0200d36:	0007b423          	sd	zero,8(a5)
ffffffffc0200d3a:	02878793          	addi	a5,a5,40
ffffffffc0200d3e:	fed7e6e3          	bltu	a5,a3,ffffffffc0200d2a <buddy_init_memmap.part.0+0x20>
ffffffffc0200d42:	00005797          	auipc	a5,0x5
ffffffffc0200d46:	74b7b723          	sd	a1,1870(a5) # ffffffffc0206490 <total_size>
ffffffffc0200d4a:	1ff00793          	li	a5,511
ffffffffc0200d4e:	06b7f763          	bgeu	a5,a1,ffffffffc0200dbc <buddy_init_memmap.part.0+0xb2>
ffffffffc0200d52:	0015d793          	srli	a5,a1,0x1
ffffffffc0200d56:	8fcd                	or	a5,a5,a1
ffffffffc0200d58:	0027d713          	srli	a4,a5,0x2
ffffffffc0200d5c:	8fd9                	or	a5,a5,a4
ffffffffc0200d5e:	0047d713          	srli	a4,a5,0x4
ffffffffc0200d62:	8f5d                	or	a4,a4,a5
ffffffffc0200d64:	00875793          	srli	a5,a4,0x8
ffffffffc0200d68:	8f5d                	or	a4,a4,a5
ffffffffc0200d6a:	01075793          	srli	a5,a4,0x10
ffffffffc0200d6e:	8fd9                	or	a5,a5,a4
ffffffffc0200d70:	8385                	srli	a5,a5,0x1
ffffffffc0200d72:	00f5f6b3          	and	a3,a1,a5
ffffffffc0200d76:	872e                	mv	a4,a1
ffffffffc0200d78:	c689                	beqz	a3,ffffffffc0200d82 <buddy_init_memmap.part.0+0x78>
ffffffffc0200d7a:	fff7c793          	not	a5,a5
ffffffffc0200d7e:	00b7f733          	and	a4,a5,a1
ffffffffc0200d82:	00471613          	slli	a2,a4,0x4
ffffffffc0200d86:	8231                	srli	a2,a2,0xc
ffffffffc0200d88:	00005497          	auipc	s1,0x5
ffffffffc0200d8c:	6e048493          	addi	s1,s1,1760 # ffffffffc0206468 <full_tree_size>
ffffffffc0200d90:	00005697          	auipc	a3,0x5
ffffffffc0200d94:	6f868693          	addi	a3,a3,1784 # ffffffffc0206488 <record_area_size>
ffffffffc0200d98:	00161793          	slli	a5,a2,0x1
ffffffffc0200d9c:	e098                	sd	a4,0(s1)
ffffffffc0200d9e:	e290                	sd	a2,0(a3)
ffffffffc0200da0:	00f70533          	add	a0,a4,a5
ffffffffc0200da4:	20b56e63          	bltu	a0,a1,ffffffffc0200fc0 <buddy_init_memmap.part.0+0x2b6>
ffffffffc0200da8:	40c586b3          	sub	a3,a1,a2
ffffffffc0200dac:	24d76263          	bltu	a4,a3,ffffffffc0200ff0 <buddy_init_memmap.part.0+0x2e6>
ffffffffc0200db0:	00261713          	slli	a4,a2,0x2
ffffffffc0200db4:	9732                	add	a4,a4,a2
ffffffffc0200db6:	070e                	slli	a4,a4,0x3
ffffffffc0200db8:	0632                	slli	a2,a2,0xc
ffffffffc0200dba:	a881                	j	ffffffffc0200e0a <buddy_init_memmap.part.0+0x100>
ffffffffc0200dbc:	15fd                	addi	a1,a1,-1
ffffffffc0200dbe:	0015d713          	srli	a4,a1,0x1
ffffffffc0200dc2:	00b767b3          	or	a5,a4,a1
ffffffffc0200dc6:	0027d713          	srli	a4,a5,0x2
ffffffffc0200dca:	8f5d                	or	a4,a4,a5
ffffffffc0200dcc:	00475793          	srli	a5,a4,0x4
ffffffffc0200dd0:	8f5d                	or	a4,a4,a5
ffffffffc0200dd2:	00875793          	srli	a5,a4,0x8
ffffffffc0200dd6:	8fd9                	or	a5,a5,a4
ffffffffc0200dd8:	8385                	srli	a5,a5,0x1
ffffffffc0200dda:	00f5f733          	and	a4,a1,a5
ffffffffc0200dde:	86ae                	mv	a3,a1
ffffffffc0200de0:	cb01                	beqz	a4,ffffffffc0200df0 <buddy_init_memmap.part.0+0xe6>
ffffffffc0200de2:	fff7c793          	not	a5,a5
ffffffffc0200de6:	8fed                	and	a5,a5,a1
ffffffffc0200de8:	00179593          	slli	a1,a5,0x1
ffffffffc0200dec:	20d5e063          	bltu	a1,a3,ffffffffc0200fec <buddy_init_memmap.part.0+0x2e2>
ffffffffc0200df0:	4785                	li	a5,1
ffffffffc0200df2:	00005497          	auipc	s1,0x5
ffffffffc0200df6:	67648493          	addi	s1,s1,1654 # ffffffffc0206468 <full_tree_size>
ffffffffc0200dfa:	00005717          	auipc	a4,0x5
ffffffffc0200dfe:	68f73723          	sd	a5,1678(a4) # ffffffffc0206488 <record_area_size>
ffffffffc0200e02:	e08c                	sd	a1,0(s1)
ffffffffc0200e04:	6605                	lui	a2,0x1
ffffffffc0200e06:	02800713          	li	a4,40
ffffffffc0200e0a:	00005797          	auipc	a5,0x5
ffffffffc0200e0e:	6967b783          	ld	a5,1686(a5) # ffffffffc02064a0 <pages>
ffffffffc0200e12:	40f807b3          	sub	a5,a6,a5
ffffffffc0200e16:	00002597          	auipc	a1,0x2
ffffffffc0200e1a:	05a5b583          	ld	a1,90(a1) # ffffffffc0202e70 <error_string+0x38>
ffffffffc0200e1e:	878d                	srai	a5,a5,0x3
ffffffffc0200e20:	02b787b3          	mul	a5,a5,a1
ffffffffc0200e24:	00002517          	auipc	a0,0x2
ffffffffc0200e28:	05453503          	ld	a0,84(a0) # ffffffffc0202e78 <nbase>
ffffffffc0200e2c:	9742                	add	a4,a4,a6
ffffffffc0200e2e:	00005997          	auipc	s3,0x5
ffffffffc0200e32:	64a98993          	addi	s3,s3,1610 # ffffffffc0206478 <real_tree_size>
ffffffffc0200e36:	00005417          	auipc	s0,0x5
ffffffffc0200e3a:	64a40413          	addi	s0,s0,1610 # ffffffffc0206480 <record_area>
ffffffffc0200e3e:	4581                	li	a1,0
ffffffffc0200e40:	00005917          	auipc	s2,0x5
ffffffffc0200e44:	62090913          	addi	s2,s2,1568 # ffffffffc0206460 <allocate_area>
ffffffffc0200e48:	00d9b023          	sd	a3,0(s3)
ffffffffc0200e4c:	00e93023          	sd	a4,0(s2)
ffffffffc0200e50:	97aa                	add	a5,a5,a0
ffffffffc0200e52:	5575                	li	a0,-3
ffffffffc0200e54:	07b2                	slli	a5,a5,0xc
ffffffffc0200e56:	057a                	slli	a0,a0,0x1e
ffffffffc0200e58:	953e                	add	a0,a0,a5
ffffffffc0200e5a:	e008                	sd	a0,0(s0)
ffffffffc0200e5c:	00005797          	auipc	a5,0x5
ffffffffc0200e60:	6107ba23          	sd	a6,1556(a5) # ffffffffc0206470 <physical_area>
ffffffffc0200e64:	154010ef          	jal	ra,ffffffffc0201fb8 <memset>
ffffffffc0200e68:	00005897          	auipc	a7,0x5
ffffffffc0200e6c:	1c888893          	addi	a7,a7,456 # ffffffffc0206030 <free_area>
ffffffffc0200e70:	0009b683          	ld	a3,0(s3)
ffffffffc0200e74:	0108a783          	lw	a5,16(a7)
ffffffffc0200e78:	6010                	ld	a2,0(s0)
ffffffffc0200e7a:	6098                	ld	a4,0(s1)
ffffffffc0200e7c:	9fb5                	addw	a5,a5,a3
ffffffffc0200e7e:	00f8a823          	sw	a5,16(a7)
ffffffffc0200e82:	e614                	sd	a3,8(a2)
ffffffffc0200e84:	0006859b          	sext.w	a1,a3
ffffffffc0200e88:	10068a63          	beqz	a3,ffffffffc0200f9c <buddy_init_memmap.part.0+0x292>
ffffffffc0200e8c:	16e6f963          	bgeu	a3,a4,ffffffffc0200ffe <buddy_init_memmap.part.0+0x2f4>
ffffffffc0200e90:	4785                	li	a5,1
ffffffffc0200e92:	4309                	li	t1,2
ffffffffc0200e94:	00479613          	slli	a2,a5,0x4
ffffffffc0200e98:	8305                	srli	a4,a4,0x1
ffffffffc0200e9a:	00860e93          	addi	t4,a2,8 # 1008 <kern_entry-0xffffffffc01feff8>
ffffffffc0200e9e:	00179e13          	slli	t3,a5,0x1
ffffffffc0200ea2:	10d77463          	bgeu	a4,a3,ffffffffc0200faa <buddy_init_memmap.part.0+0x2a0>
ffffffffc0200ea6:	0017d513          	srli	a0,a5,0x1
ffffffffc0200eaa:	8d5d                	or	a0,a0,a5
ffffffffc0200eac:	00255813          	srli	a6,a0,0x2
ffffffffc0200eb0:	00a86533          	or	a0,a6,a0
ffffffffc0200eb4:	00455813          	srli	a6,a0,0x4
ffffffffc0200eb8:	00a86833          	or	a6,a6,a0
ffffffffc0200ebc:	00885513          	srli	a0,a6,0x8
ffffffffc0200ec0:	01056833          	or	a6,a0,a6
ffffffffc0200ec4:	01085513          	srli	a0,a6,0x10
ffffffffc0200ec8:	01056533          	or	a0,a0,a6
ffffffffc0200ecc:	8105                	srli	a0,a0,0x1
ffffffffc0200ece:	00f57f33          	and	t5,a0,a5
ffffffffc0200ed2:	00093583          	ld	a1,0(s2)
ffffffffc0200ed6:	0004b803          	ld	a6,0(s1)
ffffffffc0200eda:	000f0563          	beqz	t5,ffffffffc0200ee4 <buddy_init_memmap.part.0+0x1da>
ffffffffc0200ede:	fff54513          	not	a0,a0
ffffffffc0200ee2:	8fe9                	and	a5,a5,a0
ffffffffc0200ee4:	02f857b3          	divu	a5,a6,a5
ffffffffc0200ee8:	0088b803          	ld	a6,8(a7)
ffffffffc0200eec:	03e787b3          	mul	a5,a5,t5
ffffffffc0200ef0:	00279513          	slli	a0,a5,0x2
ffffffffc0200ef4:	97aa                	add	a5,a5,a0
ffffffffc0200ef6:	078e                	slli	a5,a5,0x3
ffffffffc0200ef8:	97ae                	add	a5,a5,a1
ffffffffc0200efa:	01878593          	addi	a1,a5,24
ffffffffc0200efe:	cb98                	sw	a4,16(a5)
ffffffffc0200f00:	00b83023          	sd	a1,0(a6)
ffffffffc0200f04:	00b8b423          	sd	a1,8(a7)
ffffffffc0200f08:	0307b023          	sd	a6,32(a5)
ffffffffc0200f0c:	0117bc23          	sd	a7,24(a5)
ffffffffc0200f10:	0007a023          	sw	zero,0(a5)
ffffffffc0200f14:	07a1                	addi	a5,a5,8
ffffffffc0200f16:	4067b02f          	amoor.d	zero,t1,(a5)
ffffffffc0200f1a:	600c                	ld	a1,0(s0)
ffffffffc0200f1c:	8e99                	sub	a3,a3,a4
ffffffffc0200f1e:	001e0793          	addi	a5,t3,1
ffffffffc0200f22:	962e                	add	a2,a2,a1
ffffffffc0200f24:	e218                	sd	a4,0(a2)
ffffffffc0200f26:	95f6                	add	a1,a1,t4
ffffffffc0200f28:	e194                	sd	a3,0(a1)
ffffffffc0200f2a:	f6e6e5e3          	bltu	a3,a4,ffffffffc0200e94 <buddy_init_memmap.part.0+0x18a>
ffffffffc0200f2e:	0017d613          	srli	a2,a5,0x1
ffffffffc0200f32:	8e5d                	or	a2,a2,a5
ffffffffc0200f34:	00265713          	srli	a4,a2,0x2
ffffffffc0200f38:	8e59                	or	a2,a2,a4
ffffffffc0200f3a:	00465713          	srli	a4,a2,0x4
ffffffffc0200f3e:	8f51                	or	a4,a4,a2
ffffffffc0200f40:	00875613          	srli	a2,a4,0x8
ffffffffc0200f44:	8f51                	or	a4,a4,a2
ffffffffc0200f46:	01075613          	srli	a2,a4,0x10
ffffffffc0200f4a:	8e59                	or	a2,a2,a4
ffffffffc0200f4c:	8205                	srli	a2,a2,0x1
ffffffffc0200f4e:	00f67833          	and	a6,a2,a5
ffffffffc0200f52:	00093703          	ld	a4,0(s2)
ffffffffc0200f56:	6088                	ld	a0,0(s1)
ffffffffc0200f58:	0006859b          	sext.w	a1,a3
ffffffffc0200f5c:	00080e63          	beqz	a6,ffffffffc0200f78 <buddy_init_memmap.part.0+0x26e>
ffffffffc0200f60:	fff64613          	not	a2,a2
ffffffffc0200f64:	8ff1                	and	a5,a5,a2
ffffffffc0200f66:	02f557b3          	divu	a5,a0,a5
ffffffffc0200f6a:	030787b3          	mul	a5,a5,a6
ffffffffc0200f6e:	00279693          	slli	a3,a5,0x2
ffffffffc0200f72:	97b6                	add	a5,a5,a3
ffffffffc0200f74:	078e                	slli	a5,a5,0x3
ffffffffc0200f76:	973e                	add	a4,a4,a5
ffffffffc0200f78:	cb0c                	sw	a1,16(a4)
ffffffffc0200f7a:	00072023          	sw	zero,0(a4)
ffffffffc0200f7e:	4789                	li	a5,2
ffffffffc0200f80:	00870693          	addi	a3,a4,8
ffffffffc0200f84:	40f6b02f          	amoor.d	zero,a5,(a3)
ffffffffc0200f88:	0088b783          	ld	a5,8(a7)
ffffffffc0200f8c:	01870693          	addi	a3,a4,24
ffffffffc0200f90:	e394                	sd	a3,0(a5)
ffffffffc0200f92:	00d8b423          	sd	a3,8(a7)
ffffffffc0200f96:	f31c                	sd	a5,32(a4)
ffffffffc0200f98:	01173c23          	sd	a7,24(a4)
ffffffffc0200f9c:	70a2                	ld	ra,40(sp)
ffffffffc0200f9e:	7402                	ld	s0,32(sp)
ffffffffc0200fa0:	64e2                	ld	s1,24(sp)
ffffffffc0200fa2:	6942                	ld	s2,16(sp)
ffffffffc0200fa4:	69a2                	ld	s3,8(sp)
ffffffffc0200fa6:	6145                	addi	sp,sp,48
ffffffffc0200fa8:	8082                	ret
ffffffffc0200faa:	601c                	ld	a5,0(s0)
ffffffffc0200fac:	963e                	add	a2,a2,a5
ffffffffc0200fae:	e214                	sd	a3,0(a2)
ffffffffc0200fb0:	97f6                	add	a5,a5,t4
ffffffffc0200fb2:	0007b023          	sd	zero,0(a5)
ffffffffc0200fb6:	d2fd                	beqz	a3,ffffffffc0200f9c <buddy_init_memmap.part.0+0x292>
ffffffffc0200fb8:	87f2                	mv	a5,t3
ffffffffc0200fba:	ece6ede3          	bltu	a3,a4,ffffffffc0200e94 <buddy_init_memmap.part.0+0x18a>
ffffffffc0200fbe:	bf85                	j	ffffffffc0200f2e <buddy_init_memmap.part.0+0x224>
ffffffffc0200fc0:	0706                	slli	a4,a4,0x1
ffffffffc0200fc2:	e29c                	sd	a5,0(a3)
ffffffffc0200fc4:	e098                	sd	a4,0(s1)
ffffffffc0200fc6:	40f586b3          	sub	a3,a1,a5
ffffffffc0200fca:	00d76963          	bltu	a4,a3,ffffffffc0200fdc <buddy_init_memmap.part.0+0x2d2>
ffffffffc0200fce:	00279713          	slli	a4,a5,0x2
ffffffffc0200fd2:	973e                	add	a4,a4,a5
ffffffffc0200fd4:	070e                	slli	a4,a4,0x3
ffffffffc0200fd6:	00c79613          	slli	a2,a5,0xc
ffffffffc0200fda:	bd05                	j	ffffffffc0200e0a <buddy_init_memmap.part.0+0x100>
ffffffffc0200fdc:	86ba                	mv	a3,a4
ffffffffc0200fde:	00279713          	slli	a4,a5,0x2
ffffffffc0200fe2:	973e                	add	a4,a4,a5
ffffffffc0200fe4:	070e                	slli	a4,a4,0x3
ffffffffc0200fe6:	00c79613          	slli	a2,a5,0xc
ffffffffc0200fea:	b505                	j	ffffffffc0200e0a <buddy_init_memmap.part.0+0x100>
ffffffffc0200fec:	86ae                	mv	a3,a1
ffffffffc0200fee:	b509                	j	ffffffffc0200df0 <buddy_init_memmap.part.0+0xe6>
ffffffffc0200ff0:	86ba                	mv	a3,a4
ffffffffc0200ff2:	00261713          	slli	a4,a2,0x2
ffffffffc0200ff6:	9732                	add	a4,a4,a2
ffffffffc0200ff8:	070e                	slli	a4,a4,0x3
ffffffffc0200ffa:	0632                	slli	a2,a2,0xc
ffffffffc0200ffc:	b539                	j	ffffffffc0200e0a <buddy_init_memmap.part.0+0x100>
ffffffffc0200ffe:	00093703          	ld	a4,0(s2)
ffffffffc0201002:	bf9d                	j	ffffffffc0200f78 <buddy_init_memmap.part.0+0x26e>
ffffffffc0201004:	00001697          	auipc	a3,0x1
ffffffffc0201008:	7dc68693          	addi	a3,a3,2012 # ffffffffc02027e0 <commands+0x5b8>
ffffffffc020100c:	00001617          	auipc	a2,0x1
ffffffffc0201010:	78c60613          	addi	a2,a2,1932 # ffffffffc0202798 <commands+0x570>
ffffffffc0201014:	03300593          	li	a1,51
ffffffffc0201018:	00001517          	auipc	a0,0x1
ffffffffc020101c:	79850513          	addi	a0,a0,1944 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201020:	b94ff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc0201024 <buddy_init_memmap>:
ffffffffc0201024:	c191                	beqz	a1,ffffffffc0201028 <buddy_init_memmap+0x4>
ffffffffc0201026:	b1d5                	j	ffffffffc0200d0a <buddy_init_memmap.part.0>
ffffffffc0201028:	1141                	addi	sp,sp,-16
ffffffffc020102a:	00001697          	auipc	a3,0x1
ffffffffc020102e:	76668693          	addi	a3,a3,1894 # ffffffffc0202790 <commands+0x568>
ffffffffc0201032:	00001617          	auipc	a2,0x1
ffffffffc0201036:	76660613          	addi	a2,a2,1894 # ffffffffc0202798 <commands+0x570>
ffffffffc020103a:	02f00593          	li	a1,47
ffffffffc020103e:	00001517          	auipc	a0,0x1
ffffffffc0201042:	77250513          	addi	a0,a0,1906 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201046:	e406                	sd	ra,8(sp)
ffffffffc0201048:	b6cff0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020104c <alloc_check>:
ffffffffc020104c:	715d                	addi	sp,sp,-80
ffffffffc020104e:	f84a                	sd	s2,48(sp)
ffffffffc0201050:	00005917          	auipc	s2,0x5
ffffffffc0201054:	42090913          	addi	s2,s2,1056 # ffffffffc0206470 <physical_area>
ffffffffc0201058:	00093783          	ld	a5,0(s2)
ffffffffc020105c:	66a9                	lui	a3,0xa
ffffffffc020105e:	f44e                	sd	s3,40(sp)
ffffffffc0201060:	e486                	sd	ra,72(sp)
ffffffffc0201062:	e0a2                	sd	s0,64(sp)
ffffffffc0201064:	fc26                	sd	s1,56(sp)
ffffffffc0201066:	f052                	sd	s4,32(sp)
ffffffffc0201068:	ec56                	sd	s5,24(sp)
ffffffffc020106a:	e85a                	sd	s6,16(sp)
ffffffffc020106c:	e45e                	sd	s7,8(sp)
ffffffffc020106e:	00005997          	auipc	s3,0x5
ffffffffc0201072:	4229b983          	ld	s3,1058(s3) # ffffffffc0206490 <total_size>
ffffffffc0201076:	4605                	li	a2,1
ffffffffc0201078:	05068693          	addi	a3,a3,80 # a050 <kern_entry-0xffffffffc01f5fb0>
ffffffffc020107c:	00878713          	addi	a4,a5,8
ffffffffc0201080:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc0201084:	00093503          	ld	a0,0(s2)
ffffffffc0201088:	02878793          	addi	a5,a5,40
ffffffffc020108c:	00d50733          	add	a4,a0,a3
ffffffffc0201090:	fee7e6e3          	bltu	a5,a4,ffffffffc020107c <alloc_check+0x30>
ffffffffc0201094:	00005497          	auipc	s1,0x5
ffffffffc0201098:	f9c48493          	addi	s1,s1,-100 # ffffffffc0206030 <free_area>
ffffffffc020109c:	40200593          	li	a1,1026
ffffffffc02010a0:	e484                	sd	s1,8(s1)
ffffffffc02010a2:	e084                	sd	s1,0(s1)
ffffffffc02010a4:	00005797          	auipc	a5,0x5
ffffffffc02010a8:	f807ae23          	sw	zero,-100(a5) # ffffffffc0206040 <free_area+0x10>
ffffffffc02010ac:	c5fff0ef          	jal	ra,ffffffffc0200d0a <buddy_init_memmap.part.0>
ffffffffc02010b0:	4505                	li	a0,1
ffffffffc02010b2:	4a8000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02010b6:	8a2a                	mv	s4,a0
ffffffffc02010b8:	34050163          	beqz	a0,ffffffffc02013fa <alloc_check+0x3ae>
ffffffffc02010bc:	4505                	li	a0,1
ffffffffc02010be:	49c000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02010c2:	8b2a                	mv	s6,a0
ffffffffc02010c4:	30050b63          	beqz	a0,ffffffffc02013da <alloc_check+0x38e>
ffffffffc02010c8:	4505                	li	a0,1
ffffffffc02010ca:	490000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02010ce:	8aaa                	mv	s5,a0
ffffffffc02010d0:	2e050563          	beqz	a0,ffffffffc02013ba <alloc_check+0x36e>
ffffffffc02010d4:	4505                	li	a0,1
ffffffffc02010d6:	484000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02010da:	8baa                	mv	s7,a0
ffffffffc02010dc:	2a050f63          	beqz	a0,ffffffffc020139a <alloc_check+0x34e>
ffffffffc02010e0:	028a0793          	addi	a5,s4,40
ffffffffc02010e4:	34fb1b63          	bne	s6,a5,ffffffffc020143a <alloc_check+0x3ee>
ffffffffc02010e8:	050a0793          	addi	a5,s4,80
ffffffffc02010ec:	32fa9763          	bne	s5,a5,ffffffffc020141a <alloc_check+0x3ce>
ffffffffc02010f0:	078a0793          	addi	a5,s4,120
ffffffffc02010f4:	38f51363          	bne	a0,a5,ffffffffc020147a <alloc_check+0x42e>
ffffffffc02010f8:	000a2783          	lw	a5,0(s4)
ffffffffc02010fc:	18079f63          	bnez	a5,ffffffffc020129a <alloc_check+0x24e>
ffffffffc0201100:	000b2783          	lw	a5,0(s6)
ffffffffc0201104:	18079b63          	bnez	a5,ffffffffc020129a <alloc_check+0x24e>
ffffffffc0201108:	000aa783          	lw	a5,0(s5)
ffffffffc020110c:	18079763          	bnez	a5,ffffffffc020129a <alloc_check+0x24e>
ffffffffc0201110:	411c                	lw	a5,0(a0)
ffffffffc0201112:	18079463          	bnez	a5,ffffffffc020129a <alloc_check+0x24e>
ffffffffc0201116:	00005797          	auipc	a5,0x5
ffffffffc020111a:	38a7b783          	ld	a5,906(a5) # ffffffffc02064a0 <pages>
ffffffffc020111e:	40fa0733          	sub	a4,s4,a5
ffffffffc0201122:	870d                	srai	a4,a4,0x3
ffffffffc0201124:	00002597          	auipc	a1,0x2
ffffffffc0201128:	d4c5b583          	ld	a1,-692(a1) # ffffffffc0202e70 <error_string+0x38>
ffffffffc020112c:	02b70733          	mul	a4,a4,a1
ffffffffc0201130:	00002617          	auipc	a2,0x2
ffffffffc0201134:	d4863603          	ld	a2,-696(a2) # ffffffffc0202e78 <nbase>
ffffffffc0201138:	00005697          	auipc	a3,0x5
ffffffffc020113c:	3606b683          	ld	a3,864(a3) # ffffffffc0206498 <npage>
ffffffffc0201140:	06b2                	slli	a3,a3,0xc
ffffffffc0201142:	9732                	add	a4,a4,a2
ffffffffc0201144:	0732                	slli	a4,a4,0xc
ffffffffc0201146:	3cd77a63          	bgeu	a4,a3,ffffffffc020151a <alloc_check+0x4ce>
ffffffffc020114a:	40fb0733          	sub	a4,s6,a5
ffffffffc020114e:	870d                	srai	a4,a4,0x3
ffffffffc0201150:	02b70733          	mul	a4,a4,a1
ffffffffc0201154:	9732                	add	a4,a4,a2
ffffffffc0201156:	0732                	slli	a4,a4,0xc
ffffffffc0201158:	18d77163          	bgeu	a4,a3,ffffffffc02012da <alloc_check+0x28e>
ffffffffc020115c:	40fa8733          	sub	a4,s5,a5
ffffffffc0201160:	870d                	srai	a4,a4,0x3
ffffffffc0201162:	02b70733          	mul	a4,a4,a1
ffffffffc0201166:	9732                	add	a4,a4,a2
ffffffffc0201168:	0732                	slli	a4,a4,0xc
ffffffffc020116a:	20d77863          	bgeu	a4,a3,ffffffffc020137a <alloc_check+0x32e>
ffffffffc020116e:	40f507b3          	sub	a5,a0,a5
ffffffffc0201172:	878d                	srai	a5,a5,0x3
ffffffffc0201174:	02b787b3          	mul	a5,a5,a1
ffffffffc0201178:	00005417          	auipc	s0,0x5
ffffffffc020117c:	eb840413          	addi	s0,s0,-328 # ffffffffc0206030 <free_area>
ffffffffc0201180:	97b2                	add	a5,a5,a2
ffffffffc0201182:	07b2                	slli	a5,a5,0xc
ffffffffc0201184:	00d7e963          	bltu	a5,a3,ffffffffc0201196 <alloc_check+0x14a>
ffffffffc0201188:	aa49                	j	ffffffffc020131a <alloc_check+0x2ce>
ffffffffc020118a:	ff846503          	lwu	a0,-8(s0)
ffffffffc020118e:	979ff0ef          	jal	ra,ffffffffc0200b06 <buddy_allocate_pages>
ffffffffc0201192:	0e050463          	beqz	a0,ffffffffc020127a <alloc_check+0x22e>
ffffffffc0201196:	6400                	ld	s0,8(s0)
ffffffffc0201198:	fe9419e3          	bne	s0,s1,ffffffffc020118a <alloc_check+0x13e>
ffffffffc020119c:	4505                	li	a0,1
ffffffffc020119e:	3bc000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02011a2:	2a051c63          	bnez	a0,ffffffffc020145a <alloc_check+0x40e>
ffffffffc02011a6:	4585                	li	a1,1
ffffffffc02011a8:	8552                	mv	a0,s4
ffffffffc02011aa:	3ee000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc02011ae:	4585                	li	a1,1
ffffffffc02011b0:	855a                	mv	a0,s6
ffffffffc02011b2:	3e6000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc02011b6:	4585                	li	a1,1
ffffffffc02011b8:	8556                	mv	a0,s5
ffffffffc02011ba:	3de000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc02011be:	4818                	lw	a4,16(s0)
ffffffffc02011c0:	478d                	li	a5,3
ffffffffc02011c2:	16f71c63          	bne	a4,a5,ffffffffc020133a <alloc_check+0x2ee>
ffffffffc02011c6:	4505                	li	a0,1
ffffffffc02011c8:	392000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02011cc:	8a2a                	mv	s4,a0
ffffffffc02011ce:	30050663          	beqz	a0,ffffffffc02014da <alloc_check+0x48e>
ffffffffc02011d2:	4509                	li	a0,2
ffffffffc02011d4:	386000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02011d8:	842a                	mv	s0,a0
ffffffffc02011da:	2e050063          	beqz	a0,ffffffffc02014ba <alloc_check+0x46e>
ffffffffc02011de:	05050793          	addi	a5,a0,80
ffffffffc02011e2:	2afa1c63          	bne	s4,a5,ffffffffc020149a <alloc_check+0x44e>
ffffffffc02011e6:	4505                	li	a0,1
ffffffffc02011e8:	372000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02011ec:	34051763          	bnez	a0,ffffffffc020153a <alloc_check+0x4ee>
ffffffffc02011f0:	4589                	li	a1,2
ffffffffc02011f2:	8522                	mv	a0,s0
ffffffffc02011f4:	3a4000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc02011f8:	4585                	li	a1,1
ffffffffc02011fa:	8552                	mv	a0,s4
ffffffffc02011fc:	39c000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc0201200:	855e                	mv	a0,s7
ffffffffc0201202:	4585                	li	a1,1
ffffffffc0201204:	394000ef          	jal	ra,ffffffffc0201598 <free_pages>
ffffffffc0201208:	4511                	li	a0,4
ffffffffc020120a:	350000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc020120e:	14a41663          	bne	s0,a0,ffffffffc020135a <alloc_check+0x30e>
ffffffffc0201212:	4505                	li	a0,1
ffffffffc0201214:	346000ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc0201218:	2e051163          	bnez	a0,ffffffffc02014fa <alloc_check+0x4ae>
ffffffffc020121c:	489c                	lw	a5,16(s1)
ffffffffc020121e:	eff1                	bnez	a5,ffffffffc02012fa <alloc_check+0x2ae>
ffffffffc0201220:	00093783          	ld	a5,0(s2)
ffffffffc0201224:	00299693          	slli	a3,s3,0x2
ffffffffc0201228:	96ce                	add	a3,a3,s3
ffffffffc020122a:	068e                	slli	a3,a3,0x3
ffffffffc020122c:	00d78733          	add	a4,a5,a3
ffffffffc0201230:	04e7f363          	bgeu	a5,a4,ffffffffc0201276 <alloc_check+0x22a>
ffffffffc0201234:	4605                	li	a2,1
ffffffffc0201236:	00878713          	addi	a4,a5,8
ffffffffc020123a:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc020123e:	00093503          	ld	a0,0(s2)
ffffffffc0201242:	02878793          	addi	a5,a5,40
ffffffffc0201246:	00d50733          	add	a4,a0,a3
ffffffffc020124a:	fee7e6e3          	bltu	a5,a4,ffffffffc0201236 <alloc_check+0x1ea>
ffffffffc020124e:	e484                	sd	s1,8(s1)
ffffffffc0201250:	e084                	sd	s1,0(s1)
ffffffffc0201252:	00005797          	auipc	a5,0x5
ffffffffc0201256:	de07a723          	sw	zero,-530(a5) # ffffffffc0206040 <free_area+0x10>
ffffffffc020125a:	06098063          	beqz	s3,ffffffffc02012ba <alloc_check+0x26e>
ffffffffc020125e:	6406                	ld	s0,64(sp)
ffffffffc0201260:	60a6                	ld	ra,72(sp)
ffffffffc0201262:	74e2                	ld	s1,56(sp)
ffffffffc0201264:	7942                	ld	s2,48(sp)
ffffffffc0201266:	7a02                	ld	s4,32(sp)
ffffffffc0201268:	6ae2                	ld	s5,24(sp)
ffffffffc020126a:	6b42                	ld	s6,16(sp)
ffffffffc020126c:	6ba2                	ld	s7,8(sp)
ffffffffc020126e:	85ce                	mv	a1,s3
ffffffffc0201270:	79a2                	ld	s3,40(sp)
ffffffffc0201272:	6161                	addi	sp,sp,80
ffffffffc0201274:	bc59                	j	ffffffffc0200d0a <buddy_init_memmap.part.0>
ffffffffc0201276:	853e                	mv	a0,a5
ffffffffc0201278:	bfd9                	j	ffffffffc020124e <alloc_check+0x202>
ffffffffc020127a:	00001697          	auipc	a3,0x1
ffffffffc020127e:	6fe68693          	addi	a3,a3,1790 # ffffffffc0202978 <commands+0x750>
ffffffffc0201282:	00001617          	auipc	a2,0x1
ffffffffc0201286:	51660613          	addi	a2,a2,1302 # ffffffffc0202798 <commands+0x570>
ffffffffc020128a:	11100593          	li	a1,273
ffffffffc020128e:	00001517          	auipc	a0,0x1
ffffffffc0201292:	52250513          	addi	a0,a0,1314 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201296:	91eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020129a:	00001697          	auipc	a3,0x1
ffffffffc020129e:	60668693          	addi	a3,a3,1542 # ffffffffc02028a0 <commands+0x678>
ffffffffc02012a2:	00001617          	auipc	a2,0x1
ffffffffc02012a6:	4f660613          	addi	a2,a2,1270 # ffffffffc0202798 <commands+0x570>
ffffffffc02012aa:	10600593          	li	a1,262
ffffffffc02012ae:	00001517          	auipc	a0,0x1
ffffffffc02012b2:	50250513          	addi	a0,a0,1282 # ffffffffc02027b0 <commands+0x588>
ffffffffc02012b6:	8feff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02012ba:	00001697          	auipc	a3,0x1
ffffffffc02012be:	4d668693          	addi	a3,a3,1238 # ffffffffc0202790 <commands+0x568>
ffffffffc02012c2:	00001617          	auipc	a2,0x1
ffffffffc02012c6:	4d660613          	addi	a2,a2,1238 # ffffffffc0202798 <commands+0x570>
ffffffffc02012ca:	02f00593          	li	a1,47
ffffffffc02012ce:	00001517          	auipc	a0,0x1
ffffffffc02012d2:	4e250513          	addi	a0,a0,1250 # ffffffffc02027b0 <commands+0x588>
ffffffffc02012d6:	8deff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02012da:	00001697          	auipc	a3,0x1
ffffffffc02012de:	63e68693          	addi	a3,a3,1598 # ffffffffc0202918 <commands+0x6f0>
ffffffffc02012e2:	00001617          	auipc	a2,0x1
ffffffffc02012e6:	4b660613          	addi	a2,a2,1206 # ffffffffc0202798 <commands+0x570>
ffffffffc02012ea:	10900593          	li	a1,265
ffffffffc02012ee:	00001517          	auipc	a0,0x1
ffffffffc02012f2:	4c250513          	addi	a0,a0,1218 # ffffffffc02027b0 <commands+0x588>
ffffffffc02012f6:	8beff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02012fa:	00001697          	auipc	a3,0x1
ffffffffc02012fe:	72668693          	addi	a3,a3,1830 # ffffffffc0202a20 <commands+0x7f8>
ffffffffc0201302:	00001617          	auipc	a2,0x1
ffffffffc0201306:	49660613          	addi	a2,a2,1174 # ffffffffc0202798 <commands+0x570>
ffffffffc020130a:	12800593          	li	a1,296
ffffffffc020130e:	00001517          	auipc	a0,0x1
ffffffffc0201312:	4a250513          	addi	a0,a0,1186 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201316:	89eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020131a:	00001697          	auipc	a3,0x1
ffffffffc020131e:	63e68693          	addi	a3,a3,1598 # ffffffffc0202958 <commands+0x730>
ffffffffc0201322:	00001617          	auipc	a2,0x1
ffffffffc0201326:	47660613          	addi	a2,a2,1142 # ffffffffc0202798 <commands+0x570>
ffffffffc020132a:	10b00593          	li	a1,267
ffffffffc020132e:	00001517          	auipc	a0,0x1
ffffffffc0201332:	48250513          	addi	a0,a0,1154 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201336:	87eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020133a:	00001697          	auipc	a3,0x1
ffffffffc020133e:	68668693          	addi	a3,a3,1670 # ffffffffc02029c0 <commands+0x798>
ffffffffc0201342:	00001617          	auipc	a2,0x1
ffffffffc0201346:	45660613          	addi	a2,a2,1110 # ffffffffc0202798 <commands+0x570>
ffffffffc020134a:	11900593          	li	a1,281
ffffffffc020134e:	00001517          	auipc	a0,0x1
ffffffffc0201352:	46250513          	addi	a0,a0,1122 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201356:	85eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020135a:	00001697          	auipc	a3,0x1
ffffffffc020135e:	6a668693          	addi	a3,a3,1702 # ffffffffc0202a00 <commands+0x7d8>
ffffffffc0201362:	00001617          	auipc	a2,0x1
ffffffffc0201366:	43660613          	addi	a2,a2,1078 # ffffffffc0202798 <commands+0x570>
ffffffffc020136a:	12500593          	li	a1,293
ffffffffc020136e:	00001517          	auipc	a0,0x1
ffffffffc0201372:	44250513          	addi	a0,a0,1090 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201376:	83eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020137a:	00001697          	auipc	a3,0x1
ffffffffc020137e:	5be68693          	addi	a3,a3,1470 # ffffffffc0202938 <commands+0x710>
ffffffffc0201382:	00001617          	auipc	a2,0x1
ffffffffc0201386:	41660613          	addi	a2,a2,1046 # ffffffffc0202798 <commands+0x570>
ffffffffc020138a:	10a00593          	li	a1,266
ffffffffc020138e:	00001517          	auipc	a0,0x1
ffffffffc0201392:	42250513          	addi	a0,a0,1058 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201396:	81eff0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020139a:	00001697          	auipc	a3,0x1
ffffffffc020139e:	4b668693          	addi	a3,a3,1206 # ffffffffc0202850 <commands+0x628>
ffffffffc02013a2:	00001617          	auipc	a2,0x1
ffffffffc02013a6:	3f660613          	addi	a2,a2,1014 # ffffffffc0202798 <commands+0x570>
ffffffffc02013aa:	10100593          	li	a1,257
ffffffffc02013ae:	00001517          	auipc	a0,0x1
ffffffffc02013b2:	40250513          	addi	a0,a0,1026 # ffffffffc02027b0 <commands+0x588>
ffffffffc02013b6:	ffffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02013ba:	00001697          	auipc	a3,0x1
ffffffffc02013be:	47668693          	addi	a3,a3,1142 # ffffffffc0202830 <commands+0x608>
ffffffffc02013c2:	00001617          	auipc	a2,0x1
ffffffffc02013c6:	3d660613          	addi	a2,a2,982 # ffffffffc0202798 <commands+0x570>
ffffffffc02013ca:	10000593          	li	a1,256
ffffffffc02013ce:	00001517          	auipc	a0,0x1
ffffffffc02013d2:	3e250513          	addi	a0,a0,994 # ffffffffc02027b0 <commands+0x588>
ffffffffc02013d6:	fdffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02013da:	00001697          	auipc	a3,0x1
ffffffffc02013de:	43668693          	addi	a3,a3,1078 # ffffffffc0202810 <commands+0x5e8>
ffffffffc02013e2:	00001617          	auipc	a2,0x1
ffffffffc02013e6:	3b660613          	addi	a2,a2,950 # ffffffffc0202798 <commands+0x570>
ffffffffc02013ea:	0ff00593          	li	a1,255
ffffffffc02013ee:	00001517          	auipc	a0,0x1
ffffffffc02013f2:	3c250513          	addi	a0,a0,962 # ffffffffc02027b0 <commands+0x588>
ffffffffc02013f6:	fbffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02013fa:	00001697          	auipc	a3,0x1
ffffffffc02013fe:	3f668693          	addi	a3,a3,1014 # ffffffffc02027f0 <commands+0x5c8>
ffffffffc0201402:	00001617          	auipc	a2,0x1
ffffffffc0201406:	39660613          	addi	a2,a2,918 # ffffffffc0202798 <commands+0x570>
ffffffffc020140a:	0fe00593          	li	a1,254
ffffffffc020140e:	00001517          	auipc	a0,0x1
ffffffffc0201412:	3a250513          	addi	a0,a0,930 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201416:	f9ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020141a:	00001697          	auipc	a3,0x1
ffffffffc020141e:	46668693          	addi	a3,a3,1126 # ffffffffc0202880 <commands+0x658>
ffffffffc0201422:	00001617          	auipc	a2,0x1
ffffffffc0201426:	37660613          	addi	a2,a2,886 # ffffffffc0202798 <commands+0x570>
ffffffffc020142a:	10400593          	li	a1,260
ffffffffc020142e:	00001517          	auipc	a0,0x1
ffffffffc0201432:	38250513          	addi	a0,a0,898 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201436:	f7ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020143a:	00001697          	auipc	a3,0x1
ffffffffc020143e:	43668693          	addi	a3,a3,1078 # ffffffffc0202870 <commands+0x648>
ffffffffc0201442:	00001617          	auipc	a2,0x1
ffffffffc0201446:	35660613          	addi	a2,a2,854 # ffffffffc0202798 <commands+0x570>
ffffffffc020144a:	10300593          	li	a1,259
ffffffffc020144e:	00001517          	auipc	a0,0x1
ffffffffc0201452:	36250513          	addi	a0,a0,866 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201456:	f5ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020145a:	00001697          	auipc	a3,0x1
ffffffffc020145e:	54e68693          	addi	a3,a3,1358 # ffffffffc02029a8 <commands+0x780>
ffffffffc0201462:	00001617          	auipc	a2,0x1
ffffffffc0201466:	33660613          	addi	a2,a2,822 # ffffffffc0202798 <commands+0x570>
ffffffffc020146a:	11400593          	li	a1,276
ffffffffc020146e:	00001517          	auipc	a0,0x1
ffffffffc0201472:	34250513          	addi	a0,a0,834 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201476:	f3ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020147a:	00001697          	auipc	a3,0x1
ffffffffc020147e:	41668693          	addi	a3,a3,1046 # ffffffffc0202890 <commands+0x668>
ffffffffc0201482:	00001617          	auipc	a2,0x1
ffffffffc0201486:	31660613          	addi	a2,a2,790 # ffffffffc0202798 <commands+0x570>
ffffffffc020148a:	10500593          	li	a1,261
ffffffffc020148e:	00001517          	auipc	a0,0x1
ffffffffc0201492:	32250513          	addi	a0,a0,802 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201496:	f1ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020149a:	00001697          	auipc	a3,0x1
ffffffffc020149e:	55668693          	addi	a3,a3,1366 # ffffffffc02029f0 <commands+0x7c8>
ffffffffc02014a2:	00001617          	auipc	a2,0x1
ffffffffc02014a6:	2f660613          	addi	a2,a2,758 # ffffffffc0202798 <commands+0x570>
ffffffffc02014aa:	11d00593          	li	a1,285
ffffffffc02014ae:	00001517          	auipc	a0,0x1
ffffffffc02014b2:	30250513          	addi	a0,a0,770 # ffffffffc02027b0 <commands+0x588>
ffffffffc02014b6:	efffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02014ba:	00001697          	auipc	a3,0x1
ffffffffc02014be:	51668693          	addi	a3,a3,1302 # ffffffffc02029d0 <commands+0x7a8>
ffffffffc02014c2:	00001617          	auipc	a2,0x1
ffffffffc02014c6:	2d660613          	addi	a2,a2,726 # ffffffffc0202798 <commands+0x570>
ffffffffc02014ca:	11c00593          	li	a1,284
ffffffffc02014ce:	00001517          	auipc	a0,0x1
ffffffffc02014d2:	2e250513          	addi	a0,a0,738 # ffffffffc02027b0 <commands+0x588>
ffffffffc02014d6:	edffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02014da:	00001697          	auipc	a3,0x1
ffffffffc02014de:	33668693          	addi	a3,a3,822 # ffffffffc0202810 <commands+0x5e8>
ffffffffc02014e2:	00001617          	auipc	a2,0x1
ffffffffc02014e6:	2b660613          	addi	a2,a2,694 # ffffffffc0202798 <commands+0x570>
ffffffffc02014ea:	11b00593          	li	a1,283
ffffffffc02014ee:	00001517          	auipc	a0,0x1
ffffffffc02014f2:	2c250513          	addi	a0,a0,706 # ffffffffc02027b0 <commands+0x588>
ffffffffc02014f6:	ebffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc02014fa:	00001697          	auipc	a3,0x1
ffffffffc02014fe:	4ae68693          	addi	a3,a3,1198 # ffffffffc02029a8 <commands+0x780>
ffffffffc0201502:	00001617          	auipc	a2,0x1
ffffffffc0201506:	29660613          	addi	a2,a2,662 # ffffffffc0202798 <commands+0x570>
ffffffffc020150a:	12600593          	li	a1,294
ffffffffc020150e:	00001517          	auipc	a0,0x1
ffffffffc0201512:	2a250513          	addi	a0,a0,674 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201516:	e9ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020151a:	00001697          	auipc	a3,0x1
ffffffffc020151e:	3de68693          	addi	a3,a3,990 # ffffffffc02028f8 <commands+0x6d0>
ffffffffc0201522:	00001617          	auipc	a2,0x1
ffffffffc0201526:	27660613          	addi	a2,a2,630 # ffffffffc0202798 <commands+0x570>
ffffffffc020152a:	10800593          	li	a1,264
ffffffffc020152e:	00001517          	auipc	a0,0x1
ffffffffc0201532:	28250513          	addi	a0,a0,642 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201536:	e7ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
ffffffffc020153a:	00001697          	auipc	a3,0x1
ffffffffc020153e:	46e68693          	addi	a3,a3,1134 # ffffffffc02029a8 <commands+0x780>
ffffffffc0201542:	00001617          	auipc	a2,0x1
ffffffffc0201546:	25660613          	addi	a2,a2,598 # ffffffffc0202798 <commands+0x570>
ffffffffc020154a:	11f00593          	li	a1,287
ffffffffc020154e:	00001517          	auipc	a0,0x1
ffffffffc0201552:	26250513          	addi	a0,a0,610 # ffffffffc02027b0 <commands+0x588>
ffffffffc0201556:	e5ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020155a <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020155a:	100027f3          	csrr	a5,sstatus
ffffffffc020155e:	8b89                	andi	a5,a5,2
ffffffffc0201560:	e799                	bnez	a5,ffffffffc020156e <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201562:	00005797          	auipc	a5,0x5
ffffffffc0201566:	f467b783          	ld	a5,-186(a5) # ffffffffc02064a8 <pmm_manager>
ffffffffc020156a:	6f9c                	ld	a5,24(a5)
ffffffffc020156c:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc020156e:	1141                	addi	sp,sp,-16
ffffffffc0201570:	e406                	sd	ra,8(sp)
ffffffffc0201572:	e022                	sd	s0,0(sp)
ffffffffc0201574:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201576:	ef1fe0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020157a:	00005797          	auipc	a5,0x5
ffffffffc020157e:	f2e7b783          	ld	a5,-210(a5) # ffffffffc02064a8 <pmm_manager>
ffffffffc0201582:	6f9c                	ld	a5,24(a5)
ffffffffc0201584:	8522                	mv	a0,s0
ffffffffc0201586:	9782                	jalr	a5
ffffffffc0201588:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc020158a:	ed7fe0ef          	jal	ra,ffffffffc0200460 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020158e:	60a2                	ld	ra,8(sp)
ffffffffc0201590:	8522                	mv	a0,s0
ffffffffc0201592:	6402                	ld	s0,0(sp)
ffffffffc0201594:	0141                	addi	sp,sp,16
ffffffffc0201596:	8082                	ret

ffffffffc0201598 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201598:	100027f3          	csrr	a5,sstatus
ffffffffc020159c:	8b89                	andi	a5,a5,2
ffffffffc020159e:	e799                	bnez	a5,ffffffffc02015ac <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02015a0:	00005797          	auipc	a5,0x5
ffffffffc02015a4:	f087b783          	ld	a5,-248(a5) # ffffffffc02064a8 <pmm_manager>
ffffffffc02015a8:	739c                	ld	a5,32(a5)
ffffffffc02015aa:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02015ac:	1101                	addi	sp,sp,-32
ffffffffc02015ae:	ec06                	sd	ra,24(sp)
ffffffffc02015b0:	e822                	sd	s0,16(sp)
ffffffffc02015b2:	e426                	sd	s1,8(sp)
ffffffffc02015b4:	842a                	mv	s0,a0
ffffffffc02015b6:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02015b8:	eaffe0ef          	jal	ra,ffffffffc0200466 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02015bc:	00005797          	auipc	a5,0x5
ffffffffc02015c0:	eec7b783          	ld	a5,-276(a5) # ffffffffc02064a8 <pmm_manager>
ffffffffc02015c4:	739c                	ld	a5,32(a5)
ffffffffc02015c6:	85a6                	mv	a1,s1
ffffffffc02015c8:	8522                	mv	a0,s0
ffffffffc02015ca:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02015cc:	6442                	ld	s0,16(sp)
ffffffffc02015ce:	60e2                	ld	ra,24(sp)
ffffffffc02015d0:	64a2                	ld	s1,8(sp)
ffffffffc02015d2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02015d4:	e8dfe06f          	j	ffffffffc0200460 <intr_enable>

ffffffffc02015d8 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc02015d8:	00001797          	auipc	a5,0x1
ffffffffc02015dc:	47078793          	addi	a5,a5,1136 # ffffffffc0202a48 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02015e0:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02015e2:	1101                	addi	sp,sp,-32
ffffffffc02015e4:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02015e6:	00001517          	auipc	a0,0x1
ffffffffc02015ea:	49a50513          	addi	a0,a0,1178 # ffffffffc0202a80 <buddy_pmm_manager+0x38>
    pmm_manager = &buddy_pmm_manager;
ffffffffc02015ee:	00005497          	auipc	s1,0x5
ffffffffc02015f2:	eba48493          	addi	s1,s1,-326 # ffffffffc02064a8 <pmm_manager>
void pmm_init(void) {
ffffffffc02015f6:	ec06                	sd	ra,24(sp)
ffffffffc02015f8:	e822                	sd	s0,16(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc02015fa:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02015fc:	abffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0201600:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201602:	00005417          	auipc	s0,0x5
ffffffffc0201606:	ebe40413          	addi	s0,s0,-322 # ffffffffc02064c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc020160a:	679c                	ld	a5,8(a5)
ffffffffc020160c:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020160e:	57f5                	li	a5,-3
ffffffffc0201610:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201612:	00001517          	auipc	a0,0x1
ffffffffc0201616:	48650513          	addi	a0,a0,1158 # ffffffffc0202a98 <buddy_pmm_manager+0x50>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020161a:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc020161c:	a9ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201620:	46c5                	li	a3,17
ffffffffc0201622:	06ee                	slli	a3,a3,0x1b
ffffffffc0201624:	40100613          	li	a2,1025
ffffffffc0201628:	16fd                	addi	a3,a3,-1
ffffffffc020162a:	07e005b7          	lui	a1,0x7e00
ffffffffc020162e:	0656                	slli	a2,a2,0x15
ffffffffc0201630:	00001517          	auipc	a0,0x1
ffffffffc0201634:	48050513          	addi	a0,a0,1152 # ffffffffc0202ab0 <buddy_pmm_manager+0x68>
ffffffffc0201638:	a83fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020163c:	777d                	lui	a4,0xfffff
ffffffffc020163e:	00006797          	auipc	a5,0x6
ffffffffc0201642:	e9978793          	addi	a5,a5,-359 # ffffffffc02074d7 <end+0xfff>
ffffffffc0201646:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201648:	00005517          	auipc	a0,0x5
ffffffffc020164c:	e5050513          	addi	a0,a0,-432 # ffffffffc0206498 <npage>
ffffffffc0201650:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201654:	00005597          	auipc	a1,0x5
ffffffffc0201658:	e4c58593          	addi	a1,a1,-436 # ffffffffc02064a0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020165c:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020165e:	e19c                	sd	a5,0(a1)
ffffffffc0201660:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201662:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201664:	4885                	li	a7,1
ffffffffc0201666:	fff80837          	lui	a6,0xfff80
ffffffffc020166a:	a011                	j	ffffffffc020166e <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc020166c:	619c                	ld	a5,0(a1)
ffffffffc020166e:	97b6                	add	a5,a5,a3
ffffffffc0201670:	07a1                	addi	a5,a5,8
ffffffffc0201672:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201676:	611c                	ld	a5,0(a0)
ffffffffc0201678:	0705                	addi	a4,a4,1
ffffffffc020167a:	02868693          	addi	a3,a3,40
ffffffffc020167e:	01078633          	add	a2,a5,a6
ffffffffc0201682:	fec765e3          	bltu	a4,a2,ffffffffc020166c <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201686:	6190                	ld	a2,0(a1)
ffffffffc0201688:	00279713          	slli	a4,a5,0x2
ffffffffc020168c:	973e                	add	a4,a4,a5
ffffffffc020168e:	fec006b7          	lui	a3,0xfec00
ffffffffc0201692:	070e                	slli	a4,a4,0x3
ffffffffc0201694:	96b2                	add	a3,a3,a2
ffffffffc0201696:	96ba                	add	a3,a3,a4
ffffffffc0201698:	c0200737          	lui	a4,0xc0200
ffffffffc020169c:	08e6ef63          	bltu	a3,a4,ffffffffc020173a <pmm_init+0x162>
ffffffffc02016a0:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc02016a2:	45c5                	li	a1,17
ffffffffc02016a4:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02016a6:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02016a8:	04b6e863          	bltu	a3,a1,ffffffffc02016f8 <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02016ac:	609c                	ld	a5,0(s1)
ffffffffc02016ae:	7b9c                	ld	a5,48(a5)
ffffffffc02016b0:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02016b2:	00001517          	auipc	a0,0x1
ffffffffc02016b6:	49650513          	addi	a0,a0,1174 # ffffffffc0202b48 <buddy_pmm_manager+0x100>
ffffffffc02016ba:	a01fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02016be:	00004597          	auipc	a1,0x4
ffffffffc02016c2:	94258593          	addi	a1,a1,-1726 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02016c6:	00005797          	auipc	a5,0x5
ffffffffc02016ca:	deb7b923          	sd	a1,-526(a5) # ffffffffc02064b8 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02016ce:	c02007b7          	lui	a5,0xc0200
ffffffffc02016d2:	08f5e063          	bltu	a1,a5,ffffffffc0201752 <pmm_init+0x17a>
ffffffffc02016d6:	6010                	ld	a2,0(s0)
}
ffffffffc02016d8:	6442                	ld	s0,16(sp)
ffffffffc02016da:	60e2                	ld	ra,24(sp)
ffffffffc02016dc:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02016de:	40c58633          	sub	a2,a1,a2
ffffffffc02016e2:	00005797          	auipc	a5,0x5
ffffffffc02016e6:	dcc7b723          	sd	a2,-562(a5) # ffffffffc02064b0 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02016ea:	00001517          	auipc	a0,0x1
ffffffffc02016ee:	47e50513          	addi	a0,a0,1150 # ffffffffc0202b68 <buddy_pmm_manager+0x120>
}
ffffffffc02016f2:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02016f4:	9c7fe06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02016f8:	6705                	lui	a4,0x1
ffffffffc02016fa:	177d                	addi	a4,a4,-1
ffffffffc02016fc:	96ba                	add	a3,a3,a4
ffffffffc02016fe:	777d                	lui	a4,0xfffff
ffffffffc0201700:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0201702:	00c6d513          	srli	a0,a3,0xc
ffffffffc0201706:	00f57e63          	bgeu	a0,a5,ffffffffc0201722 <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc020170a:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc020170c:	982a                	add	a6,a6,a0
ffffffffc020170e:	00281513          	slli	a0,a6,0x2
ffffffffc0201712:	9542                	add	a0,a0,a6
ffffffffc0201714:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201716:	8d95                	sub	a1,a1,a3
ffffffffc0201718:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc020171a:	81b1                	srli	a1,a1,0xc
ffffffffc020171c:	9532                	add	a0,a0,a2
ffffffffc020171e:	9782                	jalr	a5
}
ffffffffc0201720:	b771                	j	ffffffffc02016ac <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0201722:	00001617          	auipc	a2,0x1
ffffffffc0201726:	3f660613          	addi	a2,a2,1014 # ffffffffc0202b18 <buddy_pmm_manager+0xd0>
ffffffffc020172a:	06b00593          	li	a1,107
ffffffffc020172e:	00001517          	auipc	a0,0x1
ffffffffc0201732:	40a50513          	addi	a0,a0,1034 # ffffffffc0202b38 <buddy_pmm_manager+0xf0>
ffffffffc0201736:	c7ffe0ef          	jal	ra,ffffffffc02003b4 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020173a:	00001617          	auipc	a2,0x1
ffffffffc020173e:	3a660613          	addi	a2,a2,934 # ffffffffc0202ae0 <buddy_pmm_manager+0x98>
ffffffffc0201742:	07200593          	li	a1,114
ffffffffc0201746:	00001517          	auipc	a0,0x1
ffffffffc020174a:	3c250513          	addi	a0,a0,962 # ffffffffc0202b08 <buddy_pmm_manager+0xc0>
ffffffffc020174e:	c67fe0ef          	jal	ra,ffffffffc02003b4 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201752:	86ae                	mv	a3,a1
ffffffffc0201754:	00001617          	auipc	a2,0x1
ffffffffc0201758:	38c60613          	addi	a2,a2,908 # ffffffffc0202ae0 <buddy_pmm_manager+0x98>
ffffffffc020175c:	08d00593          	li	a1,141
ffffffffc0201760:	00001517          	auipc	a0,0x1
ffffffffc0201764:	3a850513          	addi	a0,a0,936 # ffffffffc0202b08 <buddy_pmm_manager+0xc0>
ffffffffc0201768:	c4dfe0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020176c <slob_free>:
// 将一个size大小的新块加入链表
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;

	if (!block)
ffffffffc020176c:	cd1d                	beqz	a0,ffffffffc02017aa <slob_free+0x3e>
		return;

	if (size)
ffffffffc020176e:	ed9d                	bnez	a1,ffffffffc02017ac <slob_free+0x40>
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
        // b正好在环状列表开头末尾的特殊情况
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;
    // 如果b和后面的相邻，与后面合并
	if (b + b->units == cur->next) {
ffffffffc0201770:	4114                	lw	a3,0(a0)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201772:	00005597          	auipc	a1,0x5
ffffffffc0201776:	89e58593          	addi	a1,a1,-1890 # ffffffffc0206010 <slobfree>
ffffffffc020177a:	619c                	ld	a5,0(a1)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020177c:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020177e:	679c                	ld	a5,8(a5)
ffffffffc0201780:	02a77b63          	bgeu	a4,a0,ffffffffc02017b6 <slob_free+0x4a>
ffffffffc0201784:	00f56463          	bltu	a0,a5,ffffffffc020178c <slob_free+0x20>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201788:	fef76ae3          	bltu	a4,a5,ffffffffc020177c <slob_free+0x10>
	if (b + b->units == cur->next) {
ffffffffc020178c:	00469613          	slli	a2,a3,0x4
ffffffffc0201790:	962a                	add	a2,a2,a0
ffffffffc0201792:	02c78b63          	beq	a5,a2,ffffffffc02017c8 <slob_free+0x5c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else  // 否则b的右侧指针连入链表
		b->next = cur->next;
    // 如果b和前面相邻，与前面合并
	if (cur + cur->units == b) {
ffffffffc0201796:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201798:	e51c                	sd	a5,8(a0)
	if (cur + cur->units == b) {
ffffffffc020179a:	00469793          	slli	a5,a3,0x4
ffffffffc020179e:	97ba                	add	a5,a5,a4
ffffffffc02017a0:	02f50f63          	beq	a0,a5,ffffffffc02017de <slob_free+0x72>
		cur->units += b->units;
		cur->next = b->next;
	} else  // 否则curnext指向b（b前侧连入链表）
		cur->next = b;
ffffffffc02017a4:	e708                	sd	a0,8(a4)
    
    // 更新空闲块位置
	slobfree = cur;
ffffffffc02017a6:	e198                	sd	a4,0(a1)
ffffffffc02017a8:	8082                	ret
}
ffffffffc02017aa:	8082                	ret
		b->units = SLOB_UNITS(size);  
ffffffffc02017ac:	00f5869b          	addiw	a3,a1,15
ffffffffc02017b0:	8691                	srai	a3,a3,0x4
ffffffffc02017b2:	c114                	sw	a3,0(a0)
ffffffffc02017b4:	bf7d                	j	ffffffffc0201772 <slob_free+0x6>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02017b6:	fcf763e3          	bltu	a4,a5,ffffffffc020177c <slob_free+0x10>
ffffffffc02017ba:	fcf571e3          	bgeu	a0,a5,ffffffffc020177c <slob_free+0x10>
	if (b + b->units == cur->next) {
ffffffffc02017be:	00469613          	slli	a2,a3,0x4
ffffffffc02017c2:	962a                	add	a2,a2,a0
ffffffffc02017c4:	fcc799e3          	bne	a5,a2,ffffffffc0201796 <slob_free+0x2a>
		b->units += cur->next->units;
ffffffffc02017c8:	4390                	lw	a2,0(a5)
		b->next = cur->next->next;
ffffffffc02017ca:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02017cc:	9eb1                	addw	a3,a3,a2
ffffffffc02017ce:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b) {
ffffffffc02017d0:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02017d2:	e51c                	sd	a5,8(a0)
	if (cur + cur->units == b) {
ffffffffc02017d4:	00469793          	slli	a5,a3,0x4
ffffffffc02017d8:	97ba                	add	a5,a5,a4
ffffffffc02017da:	fcf515e3          	bne	a0,a5,ffffffffc02017a4 <slob_free+0x38>
		cur->units += b->units;
ffffffffc02017de:	411c                	lw	a5,0(a0)
		cur->next = b->next;
ffffffffc02017e0:	6510                	ld	a2,8(a0)
	slobfree = cur;
ffffffffc02017e2:	e198                	sd	a4,0(a1)
		cur->units += b->units;
ffffffffc02017e4:	9ebd                	addw	a3,a3,a5
ffffffffc02017e6:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc02017e8:	e710                	sd	a2,8(a4)
	slobfree = cur;
ffffffffc02017ea:	8082                	ret

ffffffffc02017ec <slob_alloc>:

// 小块分配(传入size是算上头部slob_t的)
static void *slob_alloc(size_t size)
{
ffffffffc02017ec:	1101                	addi	sp,sp,-32
ffffffffc02017ee:	ec06                	sd	ra,24(sp)
ffffffffc02017f0:	e822                	sd	s0,16(sp)
ffffffffc02017f2:	e426                	sd	s1,8(sp)
ffffffffc02017f4:	e04a                	sd	s2,0(sp)
	assert(size < PGSIZE );
ffffffffc02017f6:	6785                	lui	a5,0x1
ffffffffc02017f8:	08f57363          	bgeu	a0,a5,ffffffffc020187e <slob_alloc+0x92>

	slob_t *prev, *cur;
	int units = SLOB_UNITS(size);

	prev = slobfree;  // 从头遍历小块链表
ffffffffc02017fc:	00005417          	auipc	s0,0x5
ffffffffc0201800:	81440413          	addi	s0,s0,-2028 # ffffffffc0206010 <slobfree>
ffffffffc0201804:	6010                	ld	a2,0(s0)
	int units = SLOB_UNITS(size);
ffffffffc0201806:	053d                	addi	a0,a0,15
ffffffffc0201808:	00455913          	srli	s2,a0,0x4
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020180c:	6618                	ld	a4,8(a2)
	int units = SLOB_UNITS(size);
ffffffffc020180e:	0009049b          	sext.w	s1,s2
		
        if (cur->units >= units) { // 如果当前足够大
ffffffffc0201812:	4314                	lw	a3,0(a4)
ffffffffc0201814:	0696d263          	bge	a3,s1,ffffffffc0201878 <slob_alloc+0x8c>
			}
			slobfree = prev;  // 更新当前可用的空闲小块链表位置
			return cur;
		}

		if (cur == slobfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc0201818:	00e60a63          	beq	a2,a4,ffffffffc020182c <slob_alloc+0x40>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020181c:	671c                	ld	a5,8(a4)
        if (cur->units >= units) { // 如果当前足够大
ffffffffc020181e:	4394                	lw	a3,0(a5)
ffffffffc0201820:	0296d363          	bge	a3,s1,ffffffffc0201846 <slob_alloc+0x5a>
		if (cur == slobfree) {  // 链表遍历结束了，还没找到。需要扩展内存
ffffffffc0201824:	6010                	ld	a2,0(s0)
ffffffffc0201826:	873e                	mv	a4,a5
ffffffffc0201828:	fee61ae3          	bne	a2,a4,ffffffffc020181c <slob_alloc+0x30>

			if (size == PGSIZE){return 0;} // 应该直接分配一页，不予扩展
		    
            // call pmm->alloc_pages to allocate a continuous n*PAGESIZE
			cur = (slob_t *)alloc_pages(1);  
ffffffffc020182c:	4505                	li	a0,1
ffffffffc020182e:	d2dff0ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc0201832:	87aa                	mv	a5,a0
			if (!cur)  // 如果获取失败，返回 0
ffffffffc0201834:	c51d                	beqz	a0,ffffffffc0201862 <slob_alloc+0x76>
				return 0;

			slob_free(cur, PGSIZE);  // 将新分配的页加入到空闲链表中
ffffffffc0201836:	6585                	lui	a1,0x1
ffffffffc0201838:	f35ff0ef          	jal	ra,ffffffffc020176c <slob_free>
			cur = slobfree;  // 从新分配的页再次循环
ffffffffc020183c:	6018                	ld	a4,0(s0)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020183e:	671c                	ld	a5,8(a4)
        if (cur->units >= units) { // 如果当前足够大
ffffffffc0201840:	4394                	lw	a3,0(a5)
ffffffffc0201842:	fe96c1e3          	blt	a3,s1,ffffffffc0201824 <slob_alloc+0x38>
			if (cur->units == units)
ffffffffc0201846:	02d48563          	beq	s1,a3,ffffffffc0201870 <slob_alloc+0x84>
				prev->next = cur + units;  
ffffffffc020184a:	0912                	slli	s2,s2,0x4
ffffffffc020184c:	993e                	add	s2,s2,a5
ffffffffc020184e:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8b30>
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc0201852:	6790                	ld	a2,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201854:	9e85                	subw	a3,a3,s1
ffffffffc0201856:	00d92023          	sw	a3,0(s2)
				prev->next->next = cur->next;  // 剩余块被连入链表
ffffffffc020185a:	00c93423          	sd	a2,8(s2)
				cur->units = units;  // units大小的块被取出
ffffffffc020185e:	c384                	sw	s1,0(a5)
			slobfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201860:	e018                	sd	a4,0(s0)
		}
	}
}
ffffffffc0201862:	60e2                	ld	ra,24(sp)
ffffffffc0201864:	6442                	ld	s0,16(sp)
ffffffffc0201866:	64a2                	ld	s1,8(sp)
ffffffffc0201868:	6902                	ld	s2,0(sp)
ffffffffc020186a:	853e                	mv	a0,a5
ffffffffc020186c:	6105                	addi	sp,sp,32
ffffffffc020186e:	8082                	ret
				prev->next = cur->next;
ffffffffc0201870:	6794                	ld	a3,8(a5)
			slobfree = prev;  // 更新当前可用的空闲小块链表位置
ffffffffc0201872:	e018                	sd	a4,0(s0)
				prev->next = cur->next;
ffffffffc0201874:	e714                	sd	a3,8(a4)
			return cur;
ffffffffc0201876:	b7f5                	j	ffffffffc0201862 <slob_alloc+0x76>
        if (cur->units >= units) { // 如果当前足够大
ffffffffc0201878:	87ba                	mv	a5,a4
ffffffffc020187a:	8732                	mv	a4,a2
ffffffffc020187c:	b7e9                	j	ffffffffc0201846 <slob_alloc+0x5a>
	assert(size < PGSIZE );
ffffffffc020187e:	00001697          	auipc	a3,0x1
ffffffffc0201882:	32a68693          	addi	a3,a3,810 # ffffffffc0202ba8 <buddy_pmm_manager+0x160>
ffffffffc0201886:	00001617          	auipc	a2,0x1
ffffffffc020188a:	f1260613          	addi	a2,a2,-238 # ffffffffc0202798 <commands+0x570>
ffffffffc020188e:	04f00593          	li	a1,79
ffffffffc0201892:	00001517          	auipc	a0,0x1
ffffffffc0201896:	32650513          	addi	a0,a0,806 # ffffffffc0202bb8 <buddy_pmm_manager+0x170>
ffffffffc020189a:	b1bfe0ef          	jal	ra,ffffffffc02003b4 <__panic>

ffffffffc020189e <slub_alloc.part.0>:
		order++;
	return order;
}

// 总slub分配算法(传入申请的大小)
void *slub_alloc(size_t size)
ffffffffc020189e:	1101                	addi	sp,sp,-32
ffffffffc02018a0:	e822                	sd	s0,16(sp)
ffffffffc02018a2:	842a                	mv	s0,a0
		m = slob_alloc(size + SLOB_UNIT);
		return m ? (void *)(m + 1) : 0;
	}
    
    // 为bigblock_t结构体先分配一小块
	bb = slob_alloc(sizeof(bigblock_t));
ffffffffc02018a4:	4561                	li	a0,24
void *slub_alloc(size_t size)
ffffffffc02018a6:	ec06                	sd	ra,24(sp)
ffffffffc02018a8:	e426                	sd	s1,8(sp)
	bb = slob_alloc(sizeof(bigblock_t));
ffffffffc02018aa:	f43ff0ef          	jal	ra,ffffffffc02017ec <slob_alloc>
	if (!bb)
ffffffffc02018ae:	c915                	beqz	a0,ffffffffc02018e2 <slub_alloc.part.0+0x44>
		return 0;
    
    // 分配大页
	bb->order = ((size - 1) >> PGSHIFT) + 1;  // PGSHIFT为12，向右移12位的效果相当于除以2^12即4096）
ffffffffc02018b0:	fff40793          	addi	a5,s0,-1
ffffffffc02018b4:	83b1                	srli	a5,a5,0xc
ffffffffc02018b6:	84aa                	mv	s1,a0
ffffffffc02018b8:	0017851b          	addiw	a0,a5,1
ffffffffc02018bc:	c088                	sw	a0,0(s1)
	bb->pages = (void *)alloc_pages(bb->order);  // 分配2^order个页
ffffffffc02018be:	c9dff0ef          	jal	ra,ffffffffc020155a <alloc_pages>
ffffffffc02018c2:	e488                	sd	a0,8(s1)
ffffffffc02018c4:	842a                	mv	s0,a0

    // 分配成功，将其插入到大块链表的头部。
	if (bb->pages) {
ffffffffc02018c6:	c50d                	beqz	a0,ffffffffc02018f0 <slub_alloc.part.0+0x52>
		bb->next = bigblocks;
ffffffffc02018c8:	00005797          	auipc	a5,0x5
ffffffffc02018cc:	c0078793          	addi	a5,a5,-1024 # ffffffffc02064c8 <bigblocks>
ffffffffc02018d0:	6398                	ld	a4,0(a5)
	}
    
    // 如果页分配失败，释放之前为bigblock_t结构体分配的内存。返回0。
	slob_free(bb, sizeof(bigblock_t));
	return 0;
}
ffffffffc02018d2:	60e2                	ld	ra,24(sp)
ffffffffc02018d4:	8522                	mv	a0,s0
ffffffffc02018d6:	6442                	ld	s0,16(sp)
		bigblocks = bb;
ffffffffc02018d8:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02018da:	e898                	sd	a4,16(s1)
}
ffffffffc02018dc:	64a2                	ld	s1,8(sp)
ffffffffc02018de:	6105                	addi	sp,sp,32
ffffffffc02018e0:	8082                	ret
		return 0;
ffffffffc02018e2:	4401                	li	s0,0
}
ffffffffc02018e4:	60e2                	ld	ra,24(sp)
ffffffffc02018e6:	8522                	mv	a0,s0
ffffffffc02018e8:	6442                	ld	s0,16(sp)
ffffffffc02018ea:	64a2                	ld	s1,8(sp)
ffffffffc02018ec:	6105                	addi	sp,sp,32
ffffffffc02018ee:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc02018f0:	8526                	mv	a0,s1
ffffffffc02018f2:	45e1                	li	a1,24
ffffffffc02018f4:	e79ff0ef          	jal	ra,ffffffffc020176c <slob_free>
}
ffffffffc02018f8:	60e2                	ld	ra,24(sp)
ffffffffc02018fa:	8522                	mv	a0,s0
ffffffffc02018fc:	6442                	ld	s0,16(sp)
ffffffffc02018fe:	64a2                	ld	s1,8(sp)
ffffffffc0201900:	6105                	addi	sp,sp,32
ffffffffc0201902:	8082                	ret

ffffffffc0201904 <slub_free>:
{
    // bb用于遍历记录大块内存的链表。
    // last用于指向链表中前一个节点的next指针
	bigblock_t *bb, **last = &bigblocks;

	if (!block)
ffffffffc0201904:	c531                	beqz	a0,ffffffffc0201950 <slub_free+0x4c>
		return;

	if (!((unsigned long)block & (PGSIZE-1))) {
ffffffffc0201906:	03451793          	slli	a5,a0,0x34
ffffffffc020190a:	e7a1                	bnez	a5,ffffffffc0201952 <slub_free+0x4e>
		/* might be on the big block list */
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc020190c:	00005697          	auipc	a3,0x5
ffffffffc0201910:	bbc68693          	addi	a3,a3,-1092 # ffffffffc02064c8 <bigblocks>
ffffffffc0201914:	629c                	ld	a5,0(a3)
ffffffffc0201916:	cf95                	beqz	a5,ffffffffc0201952 <slub_free+0x4e>
{
ffffffffc0201918:	1141                	addi	sp,sp,-16
ffffffffc020191a:	e406                	sd	ra,8(sp)
ffffffffc020191c:	e022                	sd	s0,0(sp)
ffffffffc020191e:	a021                	j	ffffffffc0201926 <slub_free+0x22>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201920:	01040693          	addi	a3,s0,16
ffffffffc0201924:	c385                	beqz	a5,ffffffffc0201944 <slub_free+0x40>
			if (bb->pages == block) {
ffffffffc0201926:	6798                	ld	a4,8(a5)
ffffffffc0201928:	843e                	mv	s0,a5
				*last = bb->next;
ffffffffc020192a:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc020192c:	fea71ae3          	bne	a4,a0,ffffffffc0201920 <slub_free+0x1c>
                // call pmm->free_pages to free a continuous n*PAGESIZE memory
				free_pages((struct Page *)block, bb->order);
ffffffffc0201930:	400c                	lw	a1,0(s0)
				*last = bb->next;
ffffffffc0201932:	e29c                	sd	a5,0(a3)
				free_pages((struct Page *)block, bb->order);
ffffffffc0201934:	c65ff0ef          	jal	ra,ffffffffc0201598 <free_pages>
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201938:	8522                	mv	a0,s0
		}
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc020193a:	6402                	ld	s0,0(sp)
ffffffffc020193c:	60a2                	ld	ra,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc020193e:	45e1                	li	a1,24
}
ffffffffc0201940:	0141                	addi	sp,sp,16
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201942:	b52d                	j	ffffffffc020176c <slob_free>
}
ffffffffc0201944:	6402                	ld	s0,0(sp)
ffffffffc0201946:	60a2                	ld	ra,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201948:	4581                	li	a1,0
ffffffffc020194a:	1541                	addi	a0,a0,-16
}
ffffffffc020194c:	0141                	addi	sp,sp,16
	slob_free((slob_t *)block - 1, 0);
ffffffffc020194e:	bd39                	j	ffffffffc020176c <slob_free>
ffffffffc0201950:	8082                	ret
ffffffffc0201952:	4581                	li	a1,0
ffffffffc0201954:	1541                	addi	a0,a0,-16
ffffffffc0201956:	bd19                	j	ffffffffc020176c <slob_free>

ffffffffc0201958 <slub_init>:

void slub_init(void) {
    cprintf("slub_init() succeeded!\n");
ffffffffc0201958:	00001517          	auipc	a0,0x1
ffffffffc020195c:	27850513          	addi	a0,a0,632 # ffffffffc0202bd0 <buddy_pmm_manager+0x188>
ffffffffc0201960:	f5afe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201964 <slub_check>:
    return len;
}


void slub_check()
{
ffffffffc0201964:	1101                	addi	sp,sp,-32
    cprintf("slub check begin\n");
ffffffffc0201966:	00001517          	auipc	a0,0x1
ffffffffc020196a:	28250513          	addi	a0,a0,642 # ffffffffc0202be8 <buddy_pmm_manager+0x1a0>
{
ffffffffc020196e:	e822                	sd	s0,16(sp)
ffffffffc0201970:	ec06                	sd	ra,24(sp)
ffffffffc0201972:	e426                	sd	s1,8(sp)
ffffffffc0201974:	e04a                	sd	s2,0(sp)
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201976:	00004417          	auipc	s0,0x4
ffffffffc020197a:	69a40413          	addi	s0,s0,1690 # ffffffffc0206010 <slobfree>
    cprintf("slub check begin\n");
ffffffffc020197e:	f3cfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201982:	6018                	ld	a4,0(s0)
    int len = 0;
ffffffffc0201984:	4581                	li	a1,0
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201986:	671c                	ld	a5,8(a4)
ffffffffc0201988:	00f70663          	beq	a4,a5,ffffffffc0201994 <slub_check+0x30>
ffffffffc020198c:	679c                	ld	a5,8(a5)
        len ++;
ffffffffc020198e:	2585                	addiw	a1,a1,1
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201990:	fef71ee3          	bne	a4,a5,ffffffffc020198c <slub_check+0x28>
    cprintf("slobfree len: %d\n", slobfree_len());
ffffffffc0201994:	00001517          	auipc	a0,0x1
ffffffffc0201998:	26c50513          	addi	a0,a0,620 # ffffffffc0202c00 <buddy_pmm_manager+0x1b8>
ffffffffc020199c:	f1efe0ef          	jal	ra,ffffffffc02000ba <cprintf>
	if (size < PGSIZE - SLOB_UNIT) {
ffffffffc02019a0:	6505                	lui	a0,0x1
ffffffffc02019a2:	efdff0ef          	jal	ra,ffffffffc020189e <slub_alloc.part.0>
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019a6:	6018                	ld	a4,0(s0)
    int len = 0;
ffffffffc02019a8:	4581                	li	a1,0
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019aa:	671c                	ld	a5,8(a4)
ffffffffc02019ac:	00f70663          	beq	a4,a5,ffffffffc02019b8 <slub_check+0x54>
ffffffffc02019b0:	679c                	ld	a5,8(a5)
        len ++;
ffffffffc02019b2:	2585                	addiw	a1,a1,1
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019b4:	fef71ee3          	bne	a4,a5,ffffffffc02019b0 <slub_check+0x4c>
    void* p1 = slub_alloc(4096);
    cprintf("slobfree len: %d\n", slobfree_len());
ffffffffc02019b8:	00001517          	auipc	a0,0x1
ffffffffc02019bc:	24850513          	addi	a0,a0,584 # ffffffffc0202c00 <buddy_pmm_manager+0x1b8>
ffffffffc02019c0:	efafe0ef          	jal	ra,ffffffffc02000ba <cprintf>
		m = slob_alloc(size + SLOB_UNIT);
ffffffffc02019c4:	4549                	li	a0,18
ffffffffc02019c6:	e27ff0ef          	jal	ra,ffffffffc02017ec <slob_alloc>
ffffffffc02019ca:	892a                	mv	s2,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc02019cc:	c119                	beqz	a0,ffffffffc02019d2 <slub_check+0x6e>
ffffffffc02019ce:	01050913          	addi	s2,a0,16
		m = slob_alloc(size + SLOB_UNIT);
ffffffffc02019d2:	4549                	li	a0,18
ffffffffc02019d4:	e19ff0ef          	jal	ra,ffffffffc02017ec <slob_alloc>
ffffffffc02019d8:	84aa                	mv	s1,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc02019da:	c119                	beqz	a0,ffffffffc02019e0 <slub_check+0x7c>
ffffffffc02019dc:	01050493          	addi	s1,a0,16
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019e0:	6018                	ld	a4,0(s0)
    int len = 0;
ffffffffc02019e2:	4581                	li	a1,0
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019e4:	671c                	ld	a5,8(a4)
ffffffffc02019e6:	00f70663          	beq	a4,a5,ffffffffc02019f2 <slub_check+0x8e>
ffffffffc02019ea:	679c                	ld	a5,8(a5)
        len ++;
ffffffffc02019ec:	2585                	addiw	a1,a1,1
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc02019ee:	fef71ee3          	bne	a4,a5,ffffffffc02019ea <slub_check+0x86>
    void* p2 = slub_alloc(2);
    void* p3 = slub_alloc(2);
    cprintf("slobfree len: %d\n", slobfree_len());
ffffffffc02019f2:	00001517          	auipc	a0,0x1
ffffffffc02019f6:	20e50513          	addi	a0,a0,526 # ffffffffc0202c00 <buddy_pmm_manager+0x1b8>
ffffffffc02019fa:	ec0fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p2);
ffffffffc02019fe:	854a                	mv	a0,s2
ffffffffc0201a00:	f05ff0ef          	jal	ra,ffffffffc0201904 <slub_free>
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a04:	6018                	ld	a4,0(s0)
    int len = 0;
ffffffffc0201a06:	4581                	li	a1,0
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a08:	671c                	ld	a5,8(a4)
ffffffffc0201a0a:	00f70663          	beq	a4,a5,ffffffffc0201a16 <slub_check+0xb2>
ffffffffc0201a0e:	679c                	ld	a5,8(a5)
        len ++;
ffffffffc0201a10:	2585                	addiw	a1,a1,1
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a12:	fef71ee3          	bne	a4,a5,ffffffffc0201a0e <slub_check+0xaa>
    cprintf("slobfree len: %d\n", slobfree_len());
ffffffffc0201a16:	00001517          	auipc	a0,0x1
ffffffffc0201a1a:	1ea50513          	addi	a0,a0,490 # ffffffffc0202c00 <buddy_pmm_manager+0x1b8>
ffffffffc0201a1e:	e9cfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    slub_free(p3);
ffffffffc0201a22:	8526                	mv	a0,s1
ffffffffc0201a24:	ee1ff0ef          	jal	ra,ffffffffc0201904 <slub_free>
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a28:	6018                	ld	a4,0(s0)
    int len = 0;
ffffffffc0201a2a:	4581                	li	a1,0
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a2c:	671c                	ld	a5,8(a4)
ffffffffc0201a2e:	00e78663          	beq	a5,a4,ffffffffc0201a3a <slub_check+0xd6>
ffffffffc0201a32:	679c                	ld	a5,8(a5)
        len ++;
ffffffffc0201a34:	2585                	addiw	a1,a1,1
    for(slob_t* curr = slobfree->next; curr != slobfree; curr = curr->next)
ffffffffc0201a36:	fef71ee3          	bne	a4,a5,ffffffffc0201a32 <slub_check+0xce>
    cprintf("slobfree len: %d\n", slobfree_len());
ffffffffc0201a3a:	00001517          	auipc	a0,0x1
ffffffffc0201a3e:	1c650513          	addi	a0,a0,454 # ffffffffc0202c00 <buddy_pmm_manager+0x1b8>
ffffffffc0201a42:	e78fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("slub check end\n");
}
ffffffffc0201a46:	6442                	ld	s0,16(sp)
ffffffffc0201a48:	60e2                	ld	ra,24(sp)
ffffffffc0201a4a:	64a2                	ld	s1,8(sp)
ffffffffc0201a4c:	6902                	ld	s2,0(sp)
    cprintf("slub check end\n");
ffffffffc0201a4e:	00001517          	auipc	a0,0x1
ffffffffc0201a52:	1ca50513          	addi	a0,a0,458 # ffffffffc0202c18 <buddy_pmm_manager+0x1d0>
}
ffffffffc0201a56:	6105                	addi	sp,sp,32
    cprintf("slub check end\n");
ffffffffc0201a58:	e62fe06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0201a5c <printnum>:
ffffffffc0201a5c:	02069813          	slli	a6,a3,0x20
ffffffffc0201a60:	7179                	addi	sp,sp,-48
ffffffffc0201a62:	02085813          	srli	a6,a6,0x20
ffffffffc0201a66:	e052                	sd	s4,0(sp)
ffffffffc0201a68:	03067a33          	remu	s4,a2,a6
ffffffffc0201a6c:	f022                	sd	s0,32(sp)
ffffffffc0201a6e:	ec26                	sd	s1,24(sp)
ffffffffc0201a70:	e84a                	sd	s2,16(sp)
ffffffffc0201a72:	f406                	sd	ra,40(sp)
ffffffffc0201a74:	e44e                	sd	s3,8(sp)
ffffffffc0201a76:	84aa                	mv	s1,a0
ffffffffc0201a78:	892e                	mv	s2,a1
ffffffffc0201a7a:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201a7e:	2a01                	sext.w	s4,s4
ffffffffc0201a80:	03067e63          	bgeu	a2,a6,ffffffffc0201abc <printnum+0x60>
ffffffffc0201a84:	89be                	mv	s3,a5
ffffffffc0201a86:	00805763          	blez	s0,ffffffffc0201a94 <printnum+0x38>
ffffffffc0201a8a:	347d                	addiw	s0,s0,-1
ffffffffc0201a8c:	85ca                	mv	a1,s2
ffffffffc0201a8e:	854e                	mv	a0,s3
ffffffffc0201a90:	9482                	jalr	s1
ffffffffc0201a92:	fc65                	bnez	s0,ffffffffc0201a8a <printnum+0x2e>
ffffffffc0201a94:	1a02                	slli	s4,s4,0x20
ffffffffc0201a96:	00001797          	auipc	a5,0x1
ffffffffc0201a9a:	19278793          	addi	a5,a5,402 # ffffffffc0202c28 <buddy_pmm_manager+0x1e0>
ffffffffc0201a9e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201aa2:	9a3e                	add	s4,s4,a5
ffffffffc0201aa4:	7402                	ld	s0,32(sp)
ffffffffc0201aa6:	000a4503          	lbu	a0,0(s4)
ffffffffc0201aaa:	70a2                	ld	ra,40(sp)
ffffffffc0201aac:	69a2                	ld	s3,8(sp)
ffffffffc0201aae:	6a02                	ld	s4,0(sp)
ffffffffc0201ab0:	85ca                	mv	a1,s2
ffffffffc0201ab2:	87a6                	mv	a5,s1
ffffffffc0201ab4:	6942                	ld	s2,16(sp)
ffffffffc0201ab6:	64e2                	ld	s1,24(sp)
ffffffffc0201ab8:	6145                	addi	sp,sp,48
ffffffffc0201aba:	8782                	jr	a5
ffffffffc0201abc:	03065633          	divu	a2,a2,a6
ffffffffc0201ac0:	8722                	mv	a4,s0
ffffffffc0201ac2:	f9bff0ef          	jal	ra,ffffffffc0201a5c <printnum>
ffffffffc0201ac6:	b7f9                	j	ffffffffc0201a94 <printnum+0x38>

ffffffffc0201ac8 <vprintfmt>:
ffffffffc0201ac8:	7119                	addi	sp,sp,-128
ffffffffc0201aca:	f4a6                	sd	s1,104(sp)
ffffffffc0201acc:	f0ca                	sd	s2,96(sp)
ffffffffc0201ace:	ecce                	sd	s3,88(sp)
ffffffffc0201ad0:	e8d2                	sd	s4,80(sp)
ffffffffc0201ad2:	e4d6                	sd	s5,72(sp)
ffffffffc0201ad4:	e0da                	sd	s6,64(sp)
ffffffffc0201ad6:	fc5e                	sd	s7,56(sp)
ffffffffc0201ad8:	f06a                	sd	s10,32(sp)
ffffffffc0201ada:	fc86                	sd	ra,120(sp)
ffffffffc0201adc:	f8a2                	sd	s0,112(sp)
ffffffffc0201ade:	f862                	sd	s8,48(sp)
ffffffffc0201ae0:	f466                	sd	s9,40(sp)
ffffffffc0201ae2:	ec6e                	sd	s11,24(sp)
ffffffffc0201ae4:	892a                	mv	s2,a0
ffffffffc0201ae6:	84ae                	mv	s1,a1
ffffffffc0201ae8:	8d32                	mv	s10,a2
ffffffffc0201aea:	8a36                	mv	s4,a3
ffffffffc0201aec:	02500993          	li	s3,37
ffffffffc0201af0:	5b7d                	li	s6,-1
ffffffffc0201af2:	00001a97          	auipc	s5,0x1
ffffffffc0201af6:	16aa8a93          	addi	s5,s5,362 # ffffffffc0202c5c <buddy_pmm_manager+0x214>
ffffffffc0201afa:	00001b97          	auipc	s7,0x1
ffffffffc0201afe:	33eb8b93          	addi	s7,s7,830 # ffffffffc0202e38 <error_string>
ffffffffc0201b02:	000d4503          	lbu	a0,0(s10)
ffffffffc0201b06:	001d0413          	addi	s0,s10,1
ffffffffc0201b0a:	01350a63          	beq	a0,s3,ffffffffc0201b1e <vprintfmt+0x56>
ffffffffc0201b0e:	c121                	beqz	a0,ffffffffc0201b4e <vprintfmt+0x86>
ffffffffc0201b10:	85a6                	mv	a1,s1
ffffffffc0201b12:	0405                	addi	s0,s0,1
ffffffffc0201b14:	9902                	jalr	s2
ffffffffc0201b16:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201b1a:	ff351ae3          	bne	a0,s3,ffffffffc0201b0e <vprintfmt+0x46>
ffffffffc0201b1e:	00044603          	lbu	a2,0(s0)
ffffffffc0201b22:	02000793          	li	a5,32
ffffffffc0201b26:	4c81                	li	s9,0
ffffffffc0201b28:	4881                	li	a7,0
ffffffffc0201b2a:	5c7d                	li	s8,-1
ffffffffc0201b2c:	5dfd                	li	s11,-1
ffffffffc0201b2e:	05500513          	li	a0,85
ffffffffc0201b32:	4825                	li	a6,9
ffffffffc0201b34:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201b38:	0ff5f593          	andi	a1,a1,255
ffffffffc0201b3c:	00140d13          	addi	s10,s0,1
ffffffffc0201b40:	04b56263          	bltu	a0,a1,ffffffffc0201b84 <vprintfmt+0xbc>
ffffffffc0201b44:	058a                	slli	a1,a1,0x2
ffffffffc0201b46:	95d6                	add	a1,a1,s5
ffffffffc0201b48:	4194                	lw	a3,0(a1)
ffffffffc0201b4a:	96d6                	add	a3,a3,s5
ffffffffc0201b4c:	8682                	jr	a3
ffffffffc0201b4e:	70e6                	ld	ra,120(sp)
ffffffffc0201b50:	7446                	ld	s0,112(sp)
ffffffffc0201b52:	74a6                	ld	s1,104(sp)
ffffffffc0201b54:	7906                	ld	s2,96(sp)
ffffffffc0201b56:	69e6                	ld	s3,88(sp)
ffffffffc0201b58:	6a46                	ld	s4,80(sp)
ffffffffc0201b5a:	6aa6                	ld	s5,72(sp)
ffffffffc0201b5c:	6b06                	ld	s6,64(sp)
ffffffffc0201b5e:	7be2                	ld	s7,56(sp)
ffffffffc0201b60:	7c42                	ld	s8,48(sp)
ffffffffc0201b62:	7ca2                	ld	s9,40(sp)
ffffffffc0201b64:	7d02                	ld	s10,32(sp)
ffffffffc0201b66:	6de2                	ld	s11,24(sp)
ffffffffc0201b68:	6109                	addi	sp,sp,128
ffffffffc0201b6a:	8082                	ret
ffffffffc0201b6c:	87b2                	mv	a5,a2
ffffffffc0201b6e:	00144603          	lbu	a2,1(s0)
ffffffffc0201b72:	846a                	mv	s0,s10
ffffffffc0201b74:	00140d13          	addi	s10,s0,1
ffffffffc0201b78:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201b7c:	0ff5f593          	andi	a1,a1,255
ffffffffc0201b80:	fcb572e3          	bgeu	a0,a1,ffffffffc0201b44 <vprintfmt+0x7c>
ffffffffc0201b84:	85a6                	mv	a1,s1
ffffffffc0201b86:	02500513          	li	a0,37
ffffffffc0201b8a:	9902                	jalr	s2
ffffffffc0201b8c:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201b90:	8d22                	mv	s10,s0
ffffffffc0201b92:	f73788e3          	beq	a5,s3,ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201b96:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201b9a:	1d7d                	addi	s10,s10,-1
ffffffffc0201b9c:	ff379de3          	bne	a5,s3,ffffffffc0201b96 <vprintfmt+0xce>
ffffffffc0201ba0:	b78d                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201ba2:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0201ba6:	00144603          	lbu	a2,1(s0)
ffffffffc0201baa:	846a                	mv	s0,s10
ffffffffc0201bac:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201bb0:	0006059b          	sext.w	a1,a2
ffffffffc0201bb4:	02d86463          	bltu	a6,a3,ffffffffc0201bdc <vprintfmt+0x114>
ffffffffc0201bb8:	00144603          	lbu	a2,1(s0)
ffffffffc0201bbc:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201bc0:	0186873b          	addw	a4,a3,s8
ffffffffc0201bc4:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201bc8:	9f2d                	addw	a4,a4,a1
ffffffffc0201bca:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201bce:	0405                	addi	s0,s0,1
ffffffffc0201bd0:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0201bd4:	0006059b          	sext.w	a1,a2
ffffffffc0201bd8:	fed870e3          	bgeu	a6,a3,ffffffffc0201bb8 <vprintfmt+0xf0>
ffffffffc0201bdc:	f40ddce3          	bgez	s11,ffffffffc0201b34 <vprintfmt+0x6c>
ffffffffc0201be0:	8de2                	mv	s11,s8
ffffffffc0201be2:	5c7d                	li	s8,-1
ffffffffc0201be4:	bf81                	j	ffffffffc0201b34 <vprintfmt+0x6c>
ffffffffc0201be6:	fffdc693          	not	a3,s11
ffffffffc0201bea:	96fd                	srai	a3,a3,0x3f
ffffffffc0201bec:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201bf0:	00144603          	lbu	a2,1(s0)
ffffffffc0201bf4:	2d81                	sext.w	s11,s11
ffffffffc0201bf6:	846a                	mv	s0,s10
ffffffffc0201bf8:	bf35                	j	ffffffffc0201b34 <vprintfmt+0x6c>
ffffffffc0201bfa:	000a2c03          	lw	s8,0(s4)
ffffffffc0201bfe:	00144603          	lbu	a2,1(s0)
ffffffffc0201c02:	0a21                	addi	s4,s4,8
ffffffffc0201c04:	846a                	mv	s0,s10
ffffffffc0201c06:	bfd9                	j	ffffffffc0201bdc <vprintfmt+0x114>
ffffffffc0201c08:	4705                	li	a4,1
ffffffffc0201c0a:	008a0593          	addi	a1,s4,8
ffffffffc0201c0e:	01174463          	blt	a4,a7,ffffffffc0201c16 <vprintfmt+0x14e>
ffffffffc0201c12:	1a088e63          	beqz	a7,ffffffffc0201dce <vprintfmt+0x306>
ffffffffc0201c16:	000a3603          	ld	a2,0(s4)
ffffffffc0201c1a:	46c1                	li	a3,16
ffffffffc0201c1c:	8a2e                	mv	s4,a1
ffffffffc0201c1e:	2781                	sext.w	a5,a5
ffffffffc0201c20:	876e                	mv	a4,s11
ffffffffc0201c22:	85a6                	mv	a1,s1
ffffffffc0201c24:	854a                	mv	a0,s2
ffffffffc0201c26:	e37ff0ef          	jal	ra,ffffffffc0201a5c <printnum>
ffffffffc0201c2a:	bde1                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201c2c:	000a2503          	lw	a0,0(s4)
ffffffffc0201c30:	85a6                	mv	a1,s1
ffffffffc0201c32:	0a21                	addi	s4,s4,8
ffffffffc0201c34:	9902                	jalr	s2
ffffffffc0201c36:	b5f1                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201c38:	4705                	li	a4,1
ffffffffc0201c3a:	008a0593          	addi	a1,s4,8
ffffffffc0201c3e:	01174463          	blt	a4,a7,ffffffffc0201c46 <vprintfmt+0x17e>
ffffffffc0201c42:	18088163          	beqz	a7,ffffffffc0201dc4 <vprintfmt+0x2fc>
ffffffffc0201c46:	000a3603          	ld	a2,0(s4)
ffffffffc0201c4a:	46a9                	li	a3,10
ffffffffc0201c4c:	8a2e                	mv	s4,a1
ffffffffc0201c4e:	bfc1                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201c50:	00144603          	lbu	a2,1(s0)
ffffffffc0201c54:	4c85                	li	s9,1
ffffffffc0201c56:	846a                	mv	s0,s10
ffffffffc0201c58:	bdf1                	j	ffffffffc0201b34 <vprintfmt+0x6c>
ffffffffc0201c5a:	85a6                	mv	a1,s1
ffffffffc0201c5c:	02500513          	li	a0,37
ffffffffc0201c60:	9902                	jalr	s2
ffffffffc0201c62:	b545                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201c64:	00144603          	lbu	a2,1(s0)
ffffffffc0201c68:	2885                	addiw	a7,a7,1
ffffffffc0201c6a:	846a                	mv	s0,s10
ffffffffc0201c6c:	b5e1                	j	ffffffffc0201b34 <vprintfmt+0x6c>
ffffffffc0201c6e:	4705                	li	a4,1
ffffffffc0201c70:	008a0593          	addi	a1,s4,8
ffffffffc0201c74:	01174463          	blt	a4,a7,ffffffffc0201c7c <vprintfmt+0x1b4>
ffffffffc0201c78:	14088163          	beqz	a7,ffffffffc0201dba <vprintfmt+0x2f2>
ffffffffc0201c7c:	000a3603          	ld	a2,0(s4)
ffffffffc0201c80:	46a1                	li	a3,8
ffffffffc0201c82:	8a2e                	mv	s4,a1
ffffffffc0201c84:	bf69                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201c86:	03000513          	li	a0,48
ffffffffc0201c8a:	85a6                	mv	a1,s1
ffffffffc0201c8c:	e03e                	sd	a5,0(sp)
ffffffffc0201c8e:	9902                	jalr	s2
ffffffffc0201c90:	85a6                	mv	a1,s1
ffffffffc0201c92:	07800513          	li	a0,120
ffffffffc0201c96:	9902                	jalr	s2
ffffffffc0201c98:	0a21                	addi	s4,s4,8
ffffffffc0201c9a:	6782                	ld	a5,0(sp)
ffffffffc0201c9c:	46c1                	li	a3,16
ffffffffc0201c9e:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201ca2:	bfb5                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201ca4:	000a3403          	ld	s0,0(s4)
ffffffffc0201ca8:	008a0713          	addi	a4,s4,8
ffffffffc0201cac:	e03a                	sd	a4,0(sp)
ffffffffc0201cae:	14040263          	beqz	s0,ffffffffc0201df2 <vprintfmt+0x32a>
ffffffffc0201cb2:	0fb05763          	blez	s11,ffffffffc0201da0 <vprintfmt+0x2d8>
ffffffffc0201cb6:	02d00693          	li	a3,45
ffffffffc0201cba:	0cd79163          	bne	a5,a3,ffffffffc0201d7c <vprintfmt+0x2b4>
ffffffffc0201cbe:	00044783          	lbu	a5,0(s0)
ffffffffc0201cc2:	0007851b          	sext.w	a0,a5
ffffffffc0201cc6:	cf85                	beqz	a5,ffffffffc0201cfe <vprintfmt+0x236>
ffffffffc0201cc8:	00140a13          	addi	s4,s0,1
ffffffffc0201ccc:	05e00413          	li	s0,94
ffffffffc0201cd0:	000c4563          	bltz	s8,ffffffffc0201cda <vprintfmt+0x212>
ffffffffc0201cd4:	3c7d                	addiw	s8,s8,-1
ffffffffc0201cd6:	036c0263          	beq	s8,s6,ffffffffc0201cfa <vprintfmt+0x232>
ffffffffc0201cda:	85a6                	mv	a1,s1
ffffffffc0201cdc:	0e0c8e63          	beqz	s9,ffffffffc0201dd8 <vprintfmt+0x310>
ffffffffc0201ce0:	3781                	addiw	a5,a5,-32
ffffffffc0201ce2:	0ef47b63          	bgeu	s0,a5,ffffffffc0201dd8 <vprintfmt+0x310>
ffffffffc0201ce6:	03f00513          	li	a0,63
ffffffffc0201cea:	9902                	jalr	s2
ffffffffc0201cec:	000a4783          	lbu	a5,0(s4)
ffffffffc0201cf0:	3dfd                	addiw	s11,s11,-1
ffffffffc0201cf2:	0a05                	addi	s4,s4,1
ffffffffc0201cf4:	0007851b          	sext.w	a0,a5
ffffffffc0201cf8:	ffe1                	bnez	a5,ffffffffc0201cd0 <vprintfmt+0x208>
ffffffffc0201cfa:	01b05963          	blez	s11,ffffffffc0201d0c <vprintfmt+0x244>
ffffffffc0201cfe:	3dfd                	addiw	s11,s11,-1
ffffffffc0201d00:	85a6                	mv	a1,s1
ffffffffc0201d02:	02000513          	li	a0,32
ffffffffc0201d06:	9902                	jalr	s2
ffffffffc0201d08:	fe0d9be3          	bnez	s11,ffffffffc0201cfe <vprintfmt+0x236>
ffffffffc0201d0c:	6a02                	ld	s4,0(sp)
ffffffffc0201d0e:	bbd5                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201d10:	4705                	li	a4,1
ffffffffc0201d12:	008a0c93          	addi	s9,s4,8
ffffffffc0201d16:	01174463          	blt	a4,a7,ffffffffc0201d1e <vprintfmt+0x256>
ffffffffc0201d1a:	08088d63          	beqz	a7,ffffffffc0201db4 <vprintfmt+0x2ec>
ffffffffc0201d1e:	000a3403          	ld	s0,0(s4)
ffffffffc0201d22:	0a044d63          	bltz	s0,ffffffffc0201ddc <vprintfmt+0x314>
ffffffffc0201d26:	8622                	mv	a2,s0
ffffffffc0201d28:	8a66                	mv	s4,s9
ffffffffc0201d2a:	46a9                	li	a3,10
ffffffffc0201d2c:	bdcd                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201d2e:	000a2783          	lw	a5,0(s4)
ffffffffc0201d32:	4719                	li	a4,6
ffffffffc0201d34:	0a21                	addi	s4,s4,8
ffffffffc0201d36:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201d3a:	8fb5                	xor	a5,a5,a3
ffffffffc0201d3c:	40d786bb          	subw	a3,a5,a3
ffffffffc0201d40:	02d74163          	blt	a4,a3,ffffffffc0201d62 <vprintfmt+0x29a>
ffffffffc0201d44:	00369793          	slli	a5,a3,0x3
ffffffffc0201d48:	97de                	add	a5,a5,s7
ffffffffc0201d4a:	639c                	ld	a5,0(a5)
ffffffffc0201d4c:	cb99                	beqz	a5,ffffffffc0201d62 <vprintfmt+0x29a>
ffffffffc0201d4e:	86be                	mv	a3,a5
ffffffffc0201d50:	00001617          	auipc	a2,0x1
ffffffffc0201d54:	f0860613          	addi	a2,a2,-248 # ffffffffc0202c58 <buddy_pmm_manager+0x210>
ffffffffc0201d58:	85a6                	mv	a1,s1
ffffffffc0201d5a:	854a                	mv	a0,s2
ffffffffc0201d5c:	0ce000ef          	jal	ra,ffffffffc0201e2a <printfmt>
ffffffffc0201d60:	b34d                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201d62:	00001617          	auipc	a2,0x1
ffffffffc0201d66:	ee660613          	addi	a2,a2,-282 # ffffffffc0202c48 <buddy_pmm_manager+0x200>
ffffffffc0201d6a:	85a6                	mv	a1,s1
ffffffffc0201d6c:	854a                	mv	a0,s2
ffffffffc0201d6e:	0bc000ef          	jal	ra,ffffffffc0201e2a <printfmt>
ffffffffc0201d72:	bb41                	j	ffffffffc0201b02 <vprintfmt+0x3a>
ffffffffc0201d74:	00001417          	auipc	s0,0x1
ffffffffc0201d78:	ecc40413          	addi	s0,s0,-308 # ffffffffc0202c40 <buddy_pmm_manager+0x1f8>
ffffffffc0201d7c:	85e2                	mv	a1,s8
ffffffffc0201d7e:	8522                	mv	a0,s0
ffffffffc0201d80:	e43e                	sd	a5,8(sp)
ffffffffc0201d82:	1e6000ef          	jal	ra,ffffffffc0201f68 <strnlen>
ffffffffc0201d86:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201d8a:	01b05b63          	blez	s11,ffffffffc0201da0 <vprintfmt+0x2d8>
ffffffffc0201d8e:	67a2                	ld	a5,8(sp)
ffffffffc0201d90:	00078a1b          	sext.w	s4,a5
ffffffffc0201d94:	3dfd                	addiw	s11,s11,-1
ffffffffc0201d96:	85a6                	mv	a1,s1
ffffffffc0201d98:	8552                	mv	a0,s4
ffffffffc0201d9a:	9902                	jalr	s2
ffffffffc0201d9c:	fe0d9ce3          	bnez	s11,ffffffffc0201d94 <vprintfmt+0x2cc>
ffffffffc0201da0:	00044783          	lbu	a5,0(s0)
ffffffffc0201da4:	00140a13          	addi	s4,s0,1
ffffffffc0201da8:	0007851b          	sext.w	a0,a5
ffffffffc0201dac:	d3a5                	beqz	a5,ffffffffc0201d0c <vprintfmt+0x244>
ffffffffc0201dae:	05e00413          	li	s0,94
ffffffffc0201db2:	bf39                	j	ffffffffc0201cd0 <vprintfmt+0x208>
ffffffffc0201db4:	000a2403          	lw	s0,0(s4)
ffffffffc0201db8:	b7ad                	j	ffffffffc0201d22 <vprintfmt+0x25a>
ffffffffc0201dba:	000a6603          	lwu	a2,0(s4)
ffffffffc0201dbe:	46a1                	li	a3,8
ffffffffc0201dc0:	8a2e                	mv	s4,a1
ffffffffc0201dc2:	bdb1                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201dc4:	000a6603          	lwu	a2,0(s4)
ffffffffc0201dc8:	46a9                	li	a3,10
ffffffffc0201dca:	8a2e                	mv	s4,a1
ffffffffc0201dcc:	bd89                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201dce:	000a6603          	lwu	a2,0(s4)
ffffffffc0201dd2:	46c1                	li	a3,16
ffffffffc0201dd4:	8a2e                	mv	s4,a1
ffffffffc0201dd6:	b5a1                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201dd8:	9902                	jalr	s2
ffffffffc0201dda:	bf09                	j	ffffffffc0201cec <vprintfmt+0x224>
ffffffffc0201ddc:	85a6                	mv	a1,s1
ffffffffc0201dde:	02d00513          	li	a0,45
ffffffffc0201de2:	e03e                	sd	a5,0(sp)
ffffffffc0201de4:	9902                	jalr	s2
ffffffffc0201de6:	6782                	ld	a5,0(sp)
ffffffffc0201de8:	8a66                	mv	s4,s9
ffffffffc0201dea:	40800633          	neg	a2,s0
ffffffffc0201dee:	46a9                	li	a3,10
ffffffffc0201df0:	b53d                	j	ffffffffc0201c1e <vprintfmt+0x156>
ffffffffc0201df2:	03b05163          	blez	s11,ffffffffc0201e14 <vprintfmt+0x34c>
ffffffffc0201df6:	02d00693          	li	a3,45
ffffffffc0201dfa:	f6d79de3          	bne	a5,a3,ffffffffc0201d74 <vprintfmt+0x2ac>
ffffffffc0201dfe:	00001417          	auipc	s0,0x1
ffffffffc0201e02:	e4240413          	addi	s0,s0,-446 # ffffffffc0202c40 <buddy_pmm_manager+0x1f8>
ffffffffc0201e06:	02800793          	li	a5,40
ffffffffc0201e0a:	02800513          	li	a0,40
ffffffffc0201e0e:	00140a13          	addi	s4,s0,1
ffffffffc0201e12:	bd6d                	j	ffffffffc0201ccc <vprintfmt+0x204>
ffffffffc0201e14:	00001a17          	auipc	s4,0x1
ffffffffc0201e18:	e2da0a13          	addi	s4,s4,-467 # ffffffffc0202c41 <buddy_pmm_manager+0x1f9>
ffffffffc0201e1c:	02800513          	li	a0,40
ffffffffc0201e20:	02800793          	li	a5,40
ffffffffc0201e24:	05e00413          	li	s0,94
ffffffffc0201e28:	b565                	j	ffffffffc0201cd0 <vprintfmt+0x208>

ffffffffc0201e2a <printfmt>:
ffffffffc0201e2a:	715d                	addi	sp,sp,-80
ffffffffc0201e2c:	02810313          	addi	t1,sp,40
ffffffffc0201e30:	f436                	sd	a3,40(sp)
ffffffffc0201e32:	869a                	mv	a3,t1
ffffffffc0201e34:	ec06                	sd	ra,24(sp)
ffffffffc0201e36:	f83a                	sd	a4,48(sp)
ffffffffc0201e38:	fc3e                	sd	a5,56(sp)
ffffffffc0201e3a:	e0c2                	sd	a6,64(sp)
ffffffffc0201e3c:	e4c6                	sd	a7,72(sp)
ffffffffc0201e3e:	e41a                	sd	t1,8(sp)
ffffffffc0201e40:	c89ff0ef          	jal	ra,ffffffffc0201ac8 <vprintfmt>
ffffffffc0201e44:	60e2                	ld	ra,24(sp)
ffffffffc0201e46:	6161                	addi	sp,sp,80
ffffffffc0201e48:	8082                	ret

ffffffffc0201e4a <readline>:
ffffffffc0201e4a:	715d                	addi	sp,sp,-80
ffffffffc0201e4c:	e486                	sd	ra,72(sp)
ffffffffc0201e4e:	e0a6                	sd	s1,64(sp)
ffffffffc0201e50:	fc4a                	sd	s2,56(sp)
ffffffffc0201e52:	f84e                	sd	s3,48(sp)
ffffffffc0201e54:	f452                	sd	s4,40(sp)
ffffffffc0201e56:	f056                	sd	s5,32(sp)
ffffffffc0201e58:	ec5a                	sd	s6,24(sp)
ffffffffc0201e5a:	e85e                	sd	s7,16(sp)
ffffffffc0201e5c:	c901                	beqz	a0,ffffffffc0201e6c <readline+0x22>
ffffffffc0201e5e:	85aa                	mv	a1,a0
ffffffffc0201e60:	00001517          	auipc	a0,0x1
ffffffffc0201e64:	df850513          	addi	a0,a0,-520 # ffffffffc0202c58 <buddy_pmm_manager+0x210>
ffffffffc0201e68:	a52fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201e6c:	4481                	li	s1,0
ffffffffc0201e6e:	497d                	li	s2,31
ffffffffc0201e70:	49a1                	li	s3,8
ffffffffc0201e72:	4aa9                	li	s5,10
ffffffffc0201e74:	4b35                	li	s6,13
ffffffffc0201e76:	00004b97          	auipc	s7,0x4
ffffffffc0201e7a:	1d2b8b93          	addi	s7,s7,466 # ffffffffc0206048 <buf>
ffffffffc0201e7e:	3fe00a13          	li	s4,1022
ffffffffc0201e82:	ab0fe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201e86:	00054a63          	bltz	a0,ffffffffc0201e9a <readline+0x50>
ffffffffc0201e8a:	00a95a63          	bge	s2,a0,ffffffffc0201e9e <readline+0x54>
ffffffffc0201e8e:	029a5263          	bge	s4,s1,ffffffffc0201eb2 <readline+0x68>
ffffffffc0201e92:	aa0fe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201e96:	fe055ae3          	bgez	a0,ffffffffc0201e8a <readline+0x40>
ffffffffc0201e9a:	4501                	li	a0,0
ffffffffc0201e9c:	a091                	j	ffffffffc0201ee0 <readline+0x96>
ffffffffc0201e9e:	03351463          	bne	a0,s3,ffffffffc0201ec6 <readline+0x7c>
ffffffffc0201ea2:	e8a9                	bnez	s1,ffffffffc0201ef4 <readline+0xaa>
ffffffffc0201ea4:	a8efe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc0201ea8:	fe0549e3          	bltz	a0,ffffffffc0201e9a <readline+0x50>
ffffffffc0201eac:	fea959e3          	bge	s2,a0,ffffffffc0201e9e <readline+0x54>
ffffffffc0201eb0:	4481                	li	s1,0
ffffffffc0201eb2:	e42a                	sd	a0,8(sp)
ffffffffc0201eb4:	a3cfe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201eb8:	6522                	ld	a0,8(sp)
ffffffffc0201eba:	009b87b3          	add	a5,s7,s1
ffffffffc0201ebe:	2485                	addiw	s1,s1,1
ffffffffc0201ec0:	00a78023          	sb	a0,0(a5)
ffffffffc0201ec4:	bf7d                	j	ffffffffc0201e82 <readline+0x38>
ffffffffc0201ec6:	01550463          	beq	a0,s5,ffffffffc0201ece <readline+0x84>
ffffffffc0201eca:	fb651ce3          	bne	a0,s6,ffffffffc0201e82 <readline+0x38>
ffffffffc0201ece:	a22fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201ed2:	00004517          	auipc	a0,0x4
ffffffffc0201ed6:	17650513          	addi	a0,a0,374 # ffffffffc0206048 <buf>
ffffffffc0201eda:	94aa                	add	s1,s1,a0
ffffffffc0201edc:	00048023          	sb	zero,0(s1)
ffffffffc0201ee0:	60a6                	ld	ra,72(sp)
ffffffffc0201ee2:	6486                	ld	s1,64(sp)
ffffffffc0201ee4:	7962                	ld	s2,56(sp)
ffffffffc0201ee6:	79c2                	ld	s3,48(sp)
ffffffffc0201ee8:	7a22                	ld	s4,40(sp)
ffffffffc0201eea:	7a82                	ld	s5,32(sp)
ffffffffc0201eec:	6b62                	ld	s6,24(sp)
ffffffffc0201eee:	6bc2                	ld	s7,16(sp)
ffffffffc0201ef0:	6161                	addi	sp,sp,80
ffffffffc0201ef2:	8082                	ret
ffffffffc0201ef4:	4521                	li	a0,8
ffffffffc0201ef6:	9fafe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0201efa:	34fd                	addiw	s1,s1,-1
ffffffffc0201efc:	b759                	j	ffffffffc0201e82 <readline+0x38>

ffffffffc0201efe <sbi_console_putchar>:
ffffffffc0201efe:	4781                	li	a5,0
ffffffffc0201f00:	00004717          	auipc	a4,0x4
ffffffffc0201f04:	12073703          	ld	a4,288(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201f08:	88ba                	mv	a7,a4
ffffffffc0201f0a:	852a                	mv	a0,a0
ffffffffc0201f0c:	85be                	mv	a1,a5
ffffffffc0201f0e:	863e                	mv	a2,a5
ffffffffc0201f10:	00000073          	ecall
ffffffffc0201f14:	87aa                	mv	a5,a0
ffffffffc0201f16:	8082                	ret

ffffffffc0201f18 <sbi_set_timer>:
ffffffffc0201f18:	4781                	li	a5,0
ffffffffc0201f1a:	00004717          	auipc	a4,0x4
ffffffffc0201f1e:	5b673703          	ld	a4,1462(a4) # ffffffffc02064d0 <SBI_SET_TIMER>
ffffffffc0201f22:	88ba                	mv	a7,a4
ffffffffc0201f24:	852a                	mv	a0,a0
ffffffffc0201f26:	85be                	mv	a1,a5
ffffffffc0201f28:	863e                	mv	a2,a5
ffffffffc0201f2a:	00000073          	ecall
ffffffffc0201f2e:	87aa                	mv	a5,a0
ffffffffc0201f30:	8082                	ret

ffffffffc0201f32 <sbi_console_getchar>:
ffffffffc0201f32:	4501                	li	a0,0
ffffffffc0201f34:	00004797          	auipc	a5,0x4
ffffffffc0201f38:	0e47b783          	ld	a5,228(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201f3c:	88be                	mv	a7,a5
ffffffffc0201f3e:	852a                	mv	a0,a0
ffffffffc0201f40:	85aa                	mv	a1,a0
ffffffffc0201f42:	862a                	mv	a2,a0
ffffffffc0201f44:	00000073          	ecall
ffffffffc0201f48:	852a                	mv	a0,a0
ffffffffc0201f4a:	2501                	sext.w	a0,a0
ffffffffc0201f4c:	8082                	ret

ffffffffc0201f4e <sbi_shutdown>:
ffffffffc0201f4e:	4781                	li	a5,0
ffffffffc0201f50:	00004717          	auipc	a4,0x4
ffffffffc0201f54:	0d873703          	ld	a4,216(a4) # ffffffffc0206028 <SBI_SHUTDOWN>
ffffffffc0201f58:	88ba                	mv	a7,a4
ffffffffc0201f5a:	853e                	mv	a0,a5
ffffffffc0201f5c:	85be                	mv	a1,a5
ffffffffc0201f5e:	863e                	mv	a2,a5
ffffffffc0201f60:	00000073          	ecall
ffffffffc0201f64:	87aa                	mv	a5,a0
ffffffffc0201f66:	8082                	ret

ffffffffc0201f68 <strnlen>:
ffffffffc0201f68:	4781                	li	a5,0
ffffffffc0201f6a:	e589                	bnez	a1,ffffffffc0201f74 <strnlen+0xc>
ffffffffc0201f6c:	a811                	j	ffffffffc0201f80 <strnlen+0x18>
ffffffffc0201f6e:	0785                	addi	a5,a5,1
ffffffffc0201f70:	00f58863          	beq	a1,a5,ffffffffc0201f80 <strnlen+0x18>
ffffffffc0201f74:	00f50733          	add	a4,a0,a5
ffffffffc0201f78:	00074703          	lbu	a4,0(a4)
ffffffffc0201f7c:	fb6d                	bnez	a4,ffffffffc0201f6e <strnlen+0x6>
ffffffffc0201f7e:	85be                	mv	a1,a5
ffffffffc0201f80:	852e                	mv	a0,a1
ffffffffc0201f82:	8082                	ret

ffffffffc0201f84 <strcmp>:
ffffffffc0201f84:	00054783          	lbu	a5,0(a0)
ffffffffc0201f88:	0005c703          	lbu	a4,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201f8c:	cb89                	beqz	a5,ffffffffc0201f9e <strcmp+0x1a>
ffffffffc0201f8e:	0505                	addi	a0,a0,1
ffffffffc0201f90:	0585                	addi	a1,a1,1
ffffffffc0201f92:	fee789e3          	beq	a5,a4,ffffffffc0201f84 <strcmp>
ffffffffc0201f96:	0007851b          	sext.w	a0,a5
ffffffffc0201f9a:	9d19                	subw	a0,a0,a4
ffffffffc0201f9c:	8082                	ret
ffffffffc0201f9e:	4501                	li	a0,0
ffffffffc0201fa0:	bfed                	j	ffffffffc0201f9a <strcmp+0x16>

ffffffffc0201fa2 <strchr>:
ffffffffc0201fa2:	00054783          	lbu	a5,0(a0)
ffffffffc0201fa6:	c799                	beqz	a5,ffffffffc0201fb4 <strchr+0x12>
ffffffffc0201fa8:	00f58763          	beq	a1,a5,ffffffffc0201fb6 <strchr+0x14>
ffffffffc0201fac:	00154783          	lbu	a5,1(a0)
ffffffffc0201fb0:	0505                	addi	a0,a0,1
ffffffffc0201fb2:	fbfd                	bnez	a5,ffffffffc0201fa8 <strchr+0x6>
ffffffffc0201fb4:	4501                	li	a0,0
ffffffffc0201fb6:	8082                	ret

ffffffffc0201fb8 <memset>:
ffffffffc0201fb8:	ca01                	beqz	a2,ffffffffc0201fc8 <memset+0x10>
ffffffffc0201fba:	962a                	add	a2,a2,a0
ffffffffc0201fbc:	87aa                	mv	a5,a0
ffffffffc0201fbe:	0785                	addi	a5,a5,1
ffffffffc0201fc0:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201fc4:	fec79de3          	bne	a5,a2,ffffffffc0201fbe <memset+0x6>
ffffffffc0201fc8:	8082                	ret
