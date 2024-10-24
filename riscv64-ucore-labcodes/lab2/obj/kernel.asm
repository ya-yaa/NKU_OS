
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
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	fe650513          	addi	a0,a0,-26 # ffffffffc0206018 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	46660613          	addi	a2,a2,1126 # ffffffffc02064a0 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	1a0010ef          	jal	ra,ffffffffc02011ea <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00001517          	auipc	a0,0x1
ffffffffc0200056:	6b650513          	addi	a0,a0,1718 # ffffffffc0201708 <etext>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>
ffffffffc0200066:	0ff000ef          	jal	ra,ffffffffc0200964 <pmm_init>
ffffffffc020006a:	3fa000ef          	jal	ra,ffffffffc0200464 <idt_init>
ffffffffc020006e:	39a000ef          	jal	ra,ffffffffc0200408 <clock_init>
ffffffffc0200072:	3e6000ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc0200076:	a001                	j	ffffffffc0200076 <kern_init+0x44>

ffffffffc0200078 <cputch>:
ffffffffc0200078:	1141                	addi	sp,sp,-16
ffffffffc020007a:	e022                	sd	s0,0(sp)
ffffffffc020007c:	e406                	sd	ra,8(sp)
ffffffffc020007e:	842e                	mv	s0,a1
ffffffffc0200080:	3cc000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc0200084:	401c                	lw	a5,0(s0)
ffffffffc0200086:	60a2                	ld	ra,8(sp)
ffffffffc0200088:	2785                	addiw	a5,a5,1
ffffffffc020008a:	c01c                	sw	a5,0(s0)
ffffffffc020008c:	6402                	ld	s0,0(sp)
ffffffffc020008e:	0141                	addi	sp,sp,16
ffffffffc0200090:	8082                	ret

ffffffffc0200092 <vcprintf>:
ffffffffc0200092:	1101                	addi	sp,sp,-32
ffffffffc0200094:	862a                	mv	a2,a0
ffffffffc0200096:	86ae                	mv	a3,a1
ffffffffc0200098:	00000517          	auipc	a0,0x0
ffffffffc020009c:	fe050513          	addi	a0,a0,-32 # ffffffffc0200078 <cputch>
ffffffffc02000a0:	006c                	addi	a1,sp,12
ffffffffc02000a2:	ec06                	sd	ra,24(sp)
ffffffffc02000a4:	c602                	sw	zero,12(sp)
ffffffffc02000a6:	1c2010ef          	jal	ra,ffffffffc0201268 <vprintfmt>
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
ffffffffc02000ac:	4532                	lw	a0,12(sp)
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <cprintf>:
ffffffffc02000b2:	711d                	addi	sp,sp,-96
ffffffffc02000b4:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
ffffffffc02000b8:	8e2a                	mv	t3,a0
ffffffffc02000ba:	f42e                	sd	a1,40(sp)
ffffffffc02000bc:	f832                	sd	a2,48(sp)
ffffffffc02000be:	fc36                	sd	a3,56(sp)
ffffffffc02000c0:	00000517          	auipc	a0,0x0
ffffffffc02000c4:	fb850513          	addi	a0,a0,-72 # ffffffffc0200078 <cputch>
ffffffffc02000c8:	004c                	addi	a1,sp,4
ffffffffc02000ca:	869a                	mv	a3,t1
ffffffffc02000cc:	8672                	mv	a2,t3
ffffffffc02000ce:	ec06                	sd	ra,24(sp)
ffffffffc02000d0:	e0ba                	sd	a4,64(sp)
ffffffffc02000d2:	e4be                	sd	a5,72(sp)
ffffffffc02000d4:	e8c2                	sd	a6,80(sp)
ffffffffc02000d6:	ecc6                	sd	a7,88(sp)
ffffffffc02000d8:	e41a                	sd	t1,8(sp)
ffffffffc02000da:	c202                	sw	zero,4(sp)
ffffffffc02000dc:	18c010ef          	jal	ra,ffffffffc0201268 <vprintfmt>
ffffffffc02000e0:	60e2                	ld	ra,24(sp)
ffffffffc02000e2:	4512                	lw	a0,4(sp)
ffffffffc02000e4:	6125                	addi	sp,sp,96
ffffffffc02000e6:	8082                	ret

ffffffffc02000e8 <cputchar>:
ffffffffc02000e8:	a695                	j	ffffffffc020044c <cons_putc>

ffffffffc02000ea <cputs>:
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	e822                	sd	s0,16(sp)
ffffffffc02000ee:	ec06                	sd	ra,24(sp)
ffffffffc02000f0:	e426                	sd	s1,8(sp)
ffffffffc02000f2:	842a                	mv	s0,a0
ffffffffc02000f4:	00054503          	lbu	a0,0(a0)
ffffffffc02000f8:	c51d                	beqz	a0,ffffffffc0200126 <cputs+0x3c>
ffffffffc02000fa:	0405                	addi	s0,s0,1
ffffffffc02000fc:	4485                	li	s1,1
ffffffffc02000fe:	9c81                	subw	s1,s1,s0
ffffffffc0200100:	34c000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc0200104:	00044503          	lbu	a0,0(s0)
ffffffffc0200108:	008487bb          	addw	a5,s1,s0
ffffffffc020010c:	0405                	addi	s0,s0,1
ffffffffc020010e:	f96d                	bnez	a0,ffffffffc0200100 <cputs+0x16>
ffffffffc0200110:	0017841b          	addiw	s0,a5,1
ffffffffc0200114:	4529                	li	a0,10
ffffffffc0200116:	336000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	8522                	mv	a0,s0
ffffffffc020011e:	6442                	ld	s0,16(sp)
ffffffffc0200120:	64a2                	ld	s1,8(sp)
ffffffffc0200122:	6105                	addi	sp,sp,32
ffffffffc0200124:	8082                	ret
ffffffffc0200126:	4405                	li	s0,1
ffffffffc0200128:	b7f5                	j	ffffffffc0200114 <cputs+0x2a>

ffffffffc020012a <getchar>:
ffffffffc020012a:	1141                	addi	sp,sp,-16
ffffffffc020012c:	e406                	sd	ra,8(sp)
ffffffffc020012e:	326000ef          	jal	ra,ffffffffc0200454 <cons_getc>
ffffffffc0200132:	dd75                	beqz	a0,ffffffffc020012e <getchar+0x4>
ffffffffc0200134:	60a2                	ld	ra,8(sp)
ffffffffc0200136:	0141                	addi	sp,sp,16
ffffffffc0200138:	8082                	ret

ffffffffc020013a <__panic>:
ffffffffc020013a:	00006317          	auipc	t1,0x6
ffffffffc020013e:	2f630313          	addi	t1,t1,758 # ffffffffc0206430 <is_panic>
ffffffffc0200142:	00032e03          	lw	t3,0(t1)
ffffffffc0200146:	715d                	addi	sp,sp,-80
ffffffffc0200148:	ec06                	sd	ra,24(sp)
ffffffffc020014a:	e822                	sd	s0,16(sp)
ffffffffc020014c:	f436                	sd	a3,40(sp)
ffffffffc020014e:	f83a                	sd	a4,48(sp)
ffffffffc0200150:	fc3e                	sd	a5,56(sp)
ffffffffc0200152:	e0c2                	sd	a6,64(sp)
ffffffffc0200154:	e4c6                	sd	a7,72(sp)
ffffffffc0200156:	020e1a63          	bnez	t3,ffffffffc020018a <__panic+0x50>
ffffffffc020015a:	4785                	li	a5,1
ffffffffc020015c:	00f32023          	sw	a5,0(t1)
ffffffffc0200160:	8432                	mv	s0,a2
ffffffffc0200162:	103c                	addi	a5,sp,40
ffffffffc0200164:	862e                	mv	a2,a1
ffffffffc0200166:	85aa                	mv	a1,a0
ffffffffc0200168:	00001517          	auipc	a0,0x1
ffffffffc020016c:	5c050513          	addi	a0,a0,1472 # ffffffffc0201728 <etext+0x20>
ffffffffc0200170:	e43e                	sd	a5,8(sp)
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc020017e:	00001517          	auipc	a0,0x1
ffffffffc0200182:	69250513          	addi	a0,a0,1682 # ffffffffc0201810 <etext+0x108>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
ffffffffc0200196:	1141                	addi	sp,sp,-16
ffffffffc0200198:	00001517          	auipc	a0,0x1
ffffffffc020019c:	5b050513          	addi	a0,a0,1456 # ffffffffc0201748 <etext+0x40>
ffffffffc02001a0:	e406                	sd	ra,8(sp)
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00001517          	auipc	a0,0x1
ffffffffc02001b2:	5ba50513          	addi	a0,a0,1466 # ffffffffc0201768 <etext+0x60>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	54e58593          	addi	a1,a1,1358 # ffffffffc0201708 <etext>
ffffffffc02001c2:	00001517          	auipc	a0,0x1
ffffffffc02001c6:	5c650513          	addi	a0,a0,1478 # ffffffffc0201788 <etext+0x80>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4a58593          	addi	a1,a1,-438 # ffffffffc0206018 <free_area>
ffffffffc02001d6:	00001517          	auipc	a0,0x1
ffffffffc02001da:	5d250513          	addi	a0,a0,1490 # ffffffffc02017a8 <etext+0xa0>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	2be58593          	addi	a1,a1,702 # ffffffffc02064a0 <end>
ffffffffc02001ea:	00001517          	auipc	a0,0x1
ffffffffc02001ee:	5de50513          	addi	a0,a0,1502 # ffffffffc02017c8 <etext+0xc0>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	6a958593          	addi	a1,a1,1705 # ffffffffc020689f <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020020e:	60a2                	ld	ra,8(sp)
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00001517          	auipc	a0,0x1
ffffffffc020021c:	5d050513          	addi	a0,a0,1488 # ffffffffc02017e8 <etext+0xe0>
ffffffffc0200220:	0141                	addi	sp,sp,16
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00001617          	auipc	a2,0x1
ffffffffc020022a:	5f260613          	addi	a2,a2,1522 # ffffffffc0201818 <etext+0x110>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00001517          	auipc	a0,0x1
ffffffffc0200236:	5fe50513          	addi	a0,a0,1534 # ffffffffc0201830 <etext+0x128>
ffffffffc020023a:	e406                	sd	ra,8(sp)
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
ffffffffc0200240:	1141                	addi	sp,sp,-16
ffffffffc0200242:	00001617          	auipc	a2,0x1
ffffffffc0200246:	60660613          	addi	a2,a2,1542 # ffffffffc0201848 <etext+0x140>
ffffffffc020024a:	00001597          	auipc	a1,0x1
ffffffffc020024e:	61e58593          	addi	a1,a1,1566 # ffffffffc0201868 <etext+0x160>
ffffffffc0200252:	00001517          	auipc	a0,0x1
ffffffffc0200256:	61e50513          	addi	a0,a0,1566 # ffffffffc0201870 <etext+0x168>
ffffffffc020025a:	e406                	sd	ra,8(sp)
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00001617          	auipc	a2,0x1
ffffffffc0200264:	62060613          	addi	a2,a2,1568 # ffffffffc0201880 <etext+0x178>
ffffffffc0200268:	00001597          	auipc	a1,0x1
ffffffffc020026c:	64058593          	addi	a1,a1,1600 # ffffffffc02018a8 <etext+0x1a0>
ffffffffc0200270:	00001517          	auipc	a0,0x1
ffffffffc0200274:	60050513          	addi	a0,a0,1536 # ffffffffc0201870 <etext+0x168>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00001617          	auipc	a2,0x1
ffffffffc0200280:	63c60613          	addi	a2,a2,1596 # ffffffffc02018b8 <etext+0x1b0>
ffffffffc0200284:	00001597          	auipc	a1,0x1
ffffffffc0200288:	65458593          	addi	a1,a1,1620 # ffffffffc02018d8 <etext+0x1d0>
ffffffffc020028c:	00001517          	auipc	a0,0x1
ffffffffc0200290:	5e450513          	addi	a0,a0,1508 # ffffffffc0201870 <etext+0x168>
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200298:	60a2                	ld	ra,8(sp)
ffffffffc020029a:	4501                	li	a0,0
ffffffffc020029c:	0141                	addi	sp,sp,16
ffffffffc020029e:	8082                	ret

ffffffffc02002a0 <mon_kerninfo>:
ffffffffc02002a0:	1141                	addi	sp,sp,-16
ffffffffc02002a2:	e406                	sd	ra,8(sp)
ffffffffc02002a4:	ef3ff0ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
ffffffffc02002a8:	60a2                	ld	ra,8(sp)
ffffffffc02002aa:	4501                	li	a0,0
ffffffffc02002ac:	0141                	addi	sp,sp,16
ffffffffc02002ae:	8082                	ret

ffffffffc02002b0 <mon_backtrace>:
ffffffffc02002b0:	1141                	addi	sp,sp,-16
ffffffffc02002b2:	e406                	sd	ra,8(sp)
ffffffffc02002b4:	f71ff0ef          	jal	ra,ffffffffc0200224 <print_stackframe>
ffffffffc02002b8:	60a2                	ld	ra,8(sp)
ffffffffc02002ba:	4501                	li	a0,0
ffffffffc02002bc:	0141                	addi	sp,sp,16
ffffffffc02002be:	8082                	ret

ffffffffc02002c0 <kmonitor>:
ffffffffc02002c0:	7115                	addi	sp,sp,-224
ffffffffc02002c2:	ed5e                	sd	s7,152(sp)
ffffffffc02002c4:	8baa                	mv	s7,a0
ffffffffc02002c6:	00001517          	auipc	a0,0x1
ffffffffc02002ca:	62250513          	addi	a0,a0,1570 # ffffffffc02018e8 <etext+0x1e0>
ffffffffc02002ce:	ed86                	sd	ra,216(sp)
ffffffffc02002d0:	e9a2                	sd	s0,208(sp)
ffffffffc02002d2:	e5a6                	sd	s1,200(sp)
ffffffffc02002d4:	e1ca                	sd	s2,192(sp)
ffffffffc02002d6:	fd4e                	sd	s3,184(sp)
ffffffffc02002d8:	f952                	sd	s4,176(sp)
ffffffffc02002da:	f556                	sd	s5,168(sp)
ffffffffc02002dc:	f15a                	sd	s6,160(sp)
ffffffffc02002de:	e962                	sd	s8,144(sp)
ffffffffc02002e0:	e566                	sd	s9,136(sp)
ffffffffc02002e2:	e16a                	sd	s10,128(sp)
ffffffffc02002e4:	dcfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002e8:	00001517          	auipc	a0,0x1
ffffffffc02002ec:	62850513          	addi	a0,a0,1576 # ffffffffc0201910 <etext+0x208>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00001c17          	auipc	s8,0x1
ffffffffc0200302:	682c0c13          	addi	s8,s8,1666 # ffffffffc0201980 <commands>
ffffffffc0200306:	00001917          	auipc	s2,0x1
ffffffffc020030a:	63290913          	addi	s2,s2,1586 # ffffffffc0201938 <etext+0x230>
ffffffffc020030e:	00001497          	auipc	s1,0x1
ffffffffc0200312:	63248493          	addi	s1,s1,1586 # ffffffffc0201940 <etext+0x238>
ffffffffc0200316:	49bd                	li	s3,15
ffffffffc0200318:	00001b17          	auipc	s6,0x1
ffffffffc020031c:	630b0b13          	addi	s6,s6,1584 # ffffffffc0201948 <etext+0x240>
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	548a0a13          	addi	s4,s4,1352 # ffffffffc0201868 <etext+0x160>
ffffffffc0200328:	4a8d                	li	s5,3
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	2be010ef          	jal	ra,ffffffffc02015ea <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
ffffffffc0200338:	4c81                	li	s9,0
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00001d17          	auipc	s10,0x1
ffffffffc0200346:	63ed0d13          	addi	s10,s10,1598 # ffffffffc0201980 <commands>
ffffffffc020034a:	8552                	mv	a0,s4
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
ffffffffc0200350:	667000ef          	jal	ra,ffffffffc02011b6 <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
ffffffffc0200362:	0d61                	addi	s10,s10,24
ffffffffc0200364:	653000ef          	jal	ra,ffffffffc02011b6 <strcmp>
ffffffffc0200368:	f57d                	bnez	a0,ffffffffc0200356 <kmonitor+0x96>
ffffffffc020036a:	00141793          	slli	a5,s0,0x1
ffffffffc020036e:	97a2                	add	a5,a5,s0
ffffffffc0200370:	078e                	slli	a5,a5,0x3
ffffffffc0200372:	97e2                	add	a5,a5,s8
ffffffffc0200374:	6b9c                	ld	a5,16(a5)
ffffffffc0200376:	865e                	mv	a2,s7
ffffffffc0200378:	002c                	addi	a1,sp,8
ffffffffc020037a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020037e:	9782                	jalr	a5
ffffffffc0200380:	fa0555e3          	bgez	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200384:	60ee                	ld	ra,216(sp)
ffffffffc0200386:	644e                	ld	s0,208(sp)
ffffffffc0200388:	64ae                	ld	s1,200(sp)
ffffffffc020038a:	690e                	ld	s2,192(sp)
ffffffffc020038c:	79ea                	ld	s3,184(sp)
ffffffffc020038e:	7a4a                	ld	s4,176(sp)
ffffffffc0200390:	7aaa                	ld	s5,168(sp)
ffffffffc0200392:	7b0a                	ld	s6,160(sp)
ffffffffc0200394:	6bea                	ld	s7,152(sp)
ffffffffc0200396:	6c4a                	ld	s8,144(sp)
ffffffffc0200398:	6caa                	ld	s9,136(sp)
ffffffffc020039a:	6d0a                	ld	s10,128(sp)
ffffffffc020039c:	612d                	addi	sp,sp,224
ffffffffc020039e:	8082                	ret
ffffffffc02003a0:	8526                	mv	a0,s1
ffffffffc02003a2:	633000ef          	jal	ra,ffffffffc02011d4 <strchr>
ffffffffc02003a6:	c901                	beqz	a0,ffffffffc02003b6 <kmonitor+0xf6>
ffffffffc02003a8:	00144583          	lbu	a1,1(s0)
ffffffffc02003ac:	00040023          	sb	zero,0(s0)
ffffffffc02003b0:	0405                	addi	s0,s0,1
ffffffffc02003b2:	d5c9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003b4:	b7f5                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003b6:	00044783          	lbu	a5,0(s0)
ffffffffc02003ba:	d3c9                	beqz	a5,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003bc:	033c8963          	beq	s9,s3,ffffffffc02003ee <kmonitor+0x12e>
ffffffffc02003c0:	003c9793          	slli	a5,s9,0x3
ffffffffc02003c4:	0118                	addi	a4,sp,128
ffffffffc02003c6:	97ba                	add	a5,a5,a4
ffffffffc02003c8:	f887b023          	sd	s0,-128(a5)
ffffffffc02003cc:	00044583          	lbu	a1,0(s0)
ffffffffc02003d0:	2c85                	addiw	s9,s9,1
ffffffffc02003d2:	e591                	bnez	a1,ffffffffc02003de <kmonitor+0x11e>
ffffffffc02003d4:	b7b5                	j	ffffffffc0200340 <kmonitor+0x80>
ffffffffc02003d6:	00144583          	lbu	a1,1(s0)
ffffffffc02003da:	0405                	addi	s0,s0,1
ffffffffc02003dc:	d1a5                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	5f5000ef          	jal	ra,ffffffffc02011d4 <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00001517          	auipc	a0,0x1
ffffffffc02003fe:	56e50513          	addi	a0,a0,1390 # ffffffffc0201968 <etext+0x260>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>

ffffffffc0200408 <clock_init>:
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200414:	c0102573          	rdtime	a0
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	298010ef          	jal	ra,ffffffffc02016b8 <sbi_set_timer>
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b923          	sd	zero,18(a5) # ffffffffc0206438 <ticks>
ffffffffc020042e:	00001517          	auipc	a0,0x1
ffffffffc0200432:	59a50513          	addi	a0,a0,1434 # ffffffffc02019c8 <commands+0x48>
ffffffffc0200436:	0141                	addi	sp,sp,16
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
ffffffffc020043a:	c0102573          	rdtime	a0
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	2720106f          	j	ffffffffc02016b8 <sbi_set_timer>

ffffffffc020044a <cons_init>:
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	24e0106f          	j	ffffffffc020169e <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	27e0106f          	j	ffffffffc02016d2 <sbi_console_getchar>

ffffffffc0200458 <intr_enable>:
ffffffffc0200458:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020045c:	8082                	ret

ffffffffc020045e <intr_disable>:
ffffffffc020045e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200462:	8082                	ret

ffffffffc0200464 <idt_init>:
ffffffffc0200464:	14005073          	csrwi	sscratch,0
ffffffffc0200468:	00000797          	auipc	a5,0x0
ffffffffc020046c:	39078793          	addi	a5,a5,912 # ffffffffc02007f8 <__alltraps>
ffffffffc0200470:	10579073          	csrw	stvec,a5
ffffffffc0200474:	8082                	ret

ffffffffc0200476 <print_regs>:
ffffffffc0200476:	610c                	ld	a1,0(a0)
ffffffffc0200478:	1141                	addi	sp,sp,-16
ffffffffc020047a:	e022                	sd	s0,0(sp)
ffffffffc020047c:	842a                	mv	s0,a0
ffffffffc020047e:	00001517          	auipc	a0,0x1
ffffffffc0200482:	56a50513          	addi	a0,a0,1386 # ffffffffc02019e8 <commands+0x68>
ffffffffc0200486:	e406                	sd	ra,8(sp)
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00001517          	auipc	a0,0x1
ffffffffc0200492:	57250513          	addi	a0,a0,1394 # ffffffffc0201a00 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00001517          	auipc	a0,0x1
ffffffffc02004a0:	57c50513          	addi	a0,a0,1404 # ffffffffc0201a18 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00001517          	auipc	a0,0x1
ffffffffc02004ae:	58650513          	addi	a0,a0,1414 # ffffffffc0201a30 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00001517          	auipc	a0,0x1
ffffffffc02004bc:	59050513          	addi	a0,a0,1424 # ffffffffc0201a48 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00001517          	auipc	a0,0x1
ffffffffc02004ca:	59a50513          	addi	a0,a0,1434 # ffffffffc0201a60 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00001517          	auipc	a0,0x1
ffffffffc02004d8:	5a450513          	addi	a0,a0,1444 # ffffffffc0201a78 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00001517          	auipc	a0,0x1
ffffffffc02004e6:	5ae50513          	addi	a0,a0,1454 # ffffffffc0201a90 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00001517          	auipc	a0,0x1
ffffffffc02004f4:	5b850513          	addi	a0,a0,1464 # ffffffffc0201aa8 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00001517          	auipc	a0,0x1
ffffffffc0200502:	5c250513          	addi	a0,a0,1474 # ffffffffc0201ac0 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00001517          	auipc	a0,0x1
ffffffffc0200510:	5cc50513          	addi	a0,a0,1484 # ffffffffc0201ad8 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00001517          	auipc	a0,0x1
ffffffffc020051e:	5d650513          	addi	a0,a0,1494 # ffffffffc0201af0 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00001517          	auipc	a0,0x1
ffffffffc020052c:	5e050513          	addi	a0,a0,1504 # ffffffffc0201b08 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00001517          	auipc	a0,0x1
ffffffffc020053a:	5ea50513          	addi	a0,a0,1514 # ffffffffc0201b20 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00001517          	auipc	a0,0x1
ffffffffc0200548:	5f450513          	addi	a0,a0,1524 # ffffffffc0201b38 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00001517          	auipc	a0,0x1
ffffffffc0200556:	5fe50513          	addi	a0,a0,1534 # ffffffffc0201b50 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00001517          	auipc	a0,0x1
ffffffffc0200564:	60850513          	addi	a0,a0,1544 # ffffffffc0201b68 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00001517          	auipc	a0,0x1
ffffffffc0200572:	61250513          	addi	a0,a0,1554 # ffffffffc0201b80 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00001517          	auipc	a0,0x1
ffffffffc0200580:	61c50513          	addi	a0,a0,1564 # ffffffffc0201b98 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00001517          	auipc	a0,0x1
ffffffffc020058e:	62650513          	addi	a0,a0,1574 # ffffffffc0201bb0 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00001517          	auipc	a0,0x1
ffffffffc020059c:	63050513          	addi	a0,a0,1584 # ffffffffc0201bc8 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00001517          	auipc	a0,0x1
ffffffffc02005aa:	63a50513          	addi	a0,a0,1594 # ffffffffc0201be0 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00001517          	auipc	a0,0x1
ffffffffc02005b8:	64450513          	addi	a0,a0,1604 # ffffffffc0201bf8 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00001517          	auipc	a0,0x1
ffffffffc02005c6:	64e50513          	addi	a0,a0,1614 # ffffffffc0201c10 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00001517          	auipc	a0,0x1
ffffffffc02005d4:	65850513          	addi	a0,a0,1624 # ffffffffc0201c28 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00001517          	auipc	a0,0x1
ffffffffc02005e2:	66250513          	addi	a0,a0,1634 # ffffffffc0201c40 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00001517          	auipc	a0,0x1
ffffffffc02005f0:	66c50513          	addi	a0,a0,1644 # ffffffffc0201c58 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00001517          	auipc	a0,0x1
ffffffffc02005fe:	67650513          	addi	a0,a0,1654 # ffffffffc0201c70 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00001517          	auipc	a0,0x1
ffffffffc020060c:	68050513          	addi	a0,a0,1664 # ffffffffc0201c88 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00001517          	auipc	a0,0x1
ffffffffc020061a:	68a50513          	addi	a0,a0,1674 # ffffffffc0201ca0 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00001517          	auipc	a0,0x1
ffffffffc0200628:	69450513          	addi	a0,a0,1684 # ffffffffc0201cb8 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
ffffffffc0200636:	00001517          	auipc	a0,0x1
ffffffffc020063a:	69a50513          	addi	a0,a0,1690 # ffffffffc0201cd0 <commands+0x350>
ffffffffc020063e:	0141                	addi	sp,sp,16
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
ffffffffc0200646:	85aa                	mv	a1,a0
ffffffffc0200648:	842a                	mv	s0,a0
ffffffffc020064a:	00001517          	auipc	a0,0x1
ffffffffc020064e:	69e50513          	addi	a0,a0,1694 # ffffffffc0201ce8 <commands+0x368>
ffffffffc0200652:	e406                	sd	ra,8(sp)
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00001517          	auipc	a0,0x1
ffffffffc0200666:	69e50513          	addi	a0,a0,1694 # ffffffffc0201d00 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00001517          	auipc	a0,0x1
ffffffffc0200676:	6a650513          	addi	a0,a0,1702 # ffffffffc0201d18 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00001517          	auipc	a0,0x1
ffffffffc0200686:	6ae50513          	addi	a0,a0,1710 # ffffffffc0201d30 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020068e:	11843583          	ld	a1,280(s0)
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
ffffffffc0200696:	00001517          	auipc	a0,0x1
ffffffffc020069a:	6b250513          	addi	a0,a0,1714 # ffffffffc0201d48 <commands+0x3c8>
ffffffffc020069e:	0141                	addi	sp,sp,16
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	08f76663          	bltu	a4,a5,ffffffffc0200738 <interrupt_handler+0x96>
ffffffffc02006b0:	00001717          	auipc	a4,0x1
ffffffffc02006b4:	77870713          	addi	a4,a4,1912 # ffffffffc0201e28 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
ffffffffc02006c2:	00001517          	auipc	a0,0x1
ffffffffc02006c6:	6fe50513          	addi	a0,a0,1790 # ffffffffc0201dc0 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00001517          	auipc	a0,0x1
ffffffffc02006d0:	6d450513          	addi	a0,a0,1748 # ffffffffc0201da0 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00001517          	auipc	a0,0x1
ffffffffc02006da:	68a50513          	addi	a0,a0,1674 # ffffffffc0201d60 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00001517          	auipc	a0,0x1
ffffffffc02006e4:	70050513          	addi	a0,a0,1792 # ffffffffc0201de0 <commands+0x460>
ffffffffc02006e8:	b2e9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006ea:	1141                	addi	sp,sp,-16
ffffffffc02006ec:	e022                	sd	s0,0(sp)
ffffffffc02006ee:	e406                	sd	ra,8(sp)
ffffffffc02006f0:	d4bff0ef          	jal	ra,ffffffffc020043a <clock_set_next_event>
ffffffffc02006f4:	00006697          	auipc	a3,0x6
ffffffffc02006f8:	d4468693          	addi	a3,a3,-700 # ffffffffc0206438 <ticks>
ffffffffc02006fc:	629c                	ld	a5,0(a3)
ffffffffc02006fe:	06400713          	li	a4,100
ffffffffc0200702:	00006417          	auipc	s0,0x6
ffffffffc0200706:	d3e40413          	addi	s0,s0,-706 # ffffffffc0206440 <num>
ffffffffc020070a:	0785                	addi	a5,a5,1
ffffffffc020070c:	02e7f733          	remu	a4,a5,a4
ffffffffc0200710:	e29c                	sd	a5,0(a3)
ffffffffc0200712:	c705                	beqz	a4,ffffffffc020073a <interrupt_handler+0x98>
ffffffffc0200714:	6018                	ld	a4,0(s0)
ffffffffc0200716:	47a9                	li	a5,10
ffffffffc0200718:	04f70163          	beq	a4,a5,ffffffffc020075a <interrupt_handler+0xb8>
ffffffffc020071c:	60a2                	ld	ra,8(sp)
ffffffffc020071e:	6402                	ld	s0,0(sp)
ffffffffc0200720:	0141                	addi	sp,sp,16
ffffffffc0200722:	8082                	ret
ffffffffc0200724:	00001517          	auipc	a0,0x1
ffffffffc0200728:	6e450513          	addi	a0,a0,1764 # ffffffffc0201e08 <commands+0x488>
ffffffffc020072c:	b259                	j	ffffffffc02000b2 <cprintf>
ffffffffc020072e:	00001517          	auipc	a0,0x1
ffffffffc0200732:	65250513          	addi	a0,a0,1618 # ffffffffc0201d80 <commands+0x400>
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>
ffffffffc0200738:	b729                	j	ffffffffc0200642 <print_trapframe>
ffffffffc020073a:	06400593          	li	a1,100
ffffffffc020073e:	00001517          	auipc	a0,0x1
ffffffffc0200742:	6ba50513          	addi	a0,a0,1722 # ffffffffc0201df8 <commands+0x478>
ffffffffc0200746:	96dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020074a:	00006797          	auipc	a5,0x6
ffffffffc020074e:	ce07b723          	sd	zero,-786(a5) # ffffffffc0206438 <ticks>
ffffffffc0200752:	601c                	ld	a5,0(s0)
ffffffffc0200754:	0785                	addi	a5,a5,1
ffffffffc0200756:	e01c                	sd	a5,0(s0)
ffffffffc0200758:	bf75                	j	ffffffffc0200714 <interrupt_handler+0x72>
ffffffffc020075a:	6402                	ld	s0,0(sp)
ffffffffc020075c:	60a2                	ld	ra,8(sp)
ffffffffc020075e:	0141                	addi	sp,sp,16
ffffffffc0200760:	78f0006f          	j	ffffffffc02016ee <sbi_shutdown>

ffffffffc0200764 <exception_handler>:
ffffffffc0200764:	11853783          	ld	a5,280(a0)
ffffffffc0200768:	1141                	addi	sp,sp,-16
ffffffffc020076a:	e022                	sd	s0,0(sp)
ffffffffc020076c:	e406                	sd	ra,8(sp)
ffffffffc020076e:	470d                	li	a4,3
ffffffffc0200770:	842a                	mv	s0,a0
ffffffffc0200772:	04e78663          	beq	a5,a4,ffffffffc02007be <exception_handler+0x5a>
ffffffffc0200776:	02f76c63          	bltu	a4,a5,ffffffffc02007ae <exception_handler+0x4a>
ffffffffc020077a:	4709                	li	a4,2
ffffffffc020077c:	02e79563          	bne	a5,a4,ffffffffc02007a6 <exception_handler+0x42>
ffffffffc0200780:	00001517          	auipc	a0,0x1
ffffffffc0200784:	6d850513          	addi	a0,a0,1752 # ffffffffc0201e58 <commands+0x4d8>
ffffffffc0200788:	92bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020078c:	10843583          	ld	a1,264(s0)
ffffffffc0200790:	00001517          	auipc	a0,0x1
ffffffffc0200794:	6f050513          	addi	a0,a0,1776 # ffffffffc0201e80 <commands+0x500>
ffffffffc0200798:	91bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020079c:	10843783          	ld	a5,264(s0)
ffffffffc02007a0:	0791                	addi	a5,a5,4
ffffffffc02007a2:	10f43423          	sd	a5,264(s0)
ffffffffc02007a6:	60a2                	ld	ra,8(sp)
ffffffffc02007a8:	6402                	ld	s0,0(sp)
ffffffffc02007aa:	0141                	addi	sp,sp,16
ffffffffc02007ac:	8082                	ret
ffffffffc02007ae:	17f1                	addi	a5,a5,-4
ffffffffc02007b0:	471d                	li	a4,7
ffffffffc02007b2:	fef77ae3          	bgeu	a4,a5,ffffffffc02007a6 <exception_handler+0x42>
ffffffffc02007b6:	6402                	ld	s0,0(sp)
ffffffffc02007b8:	60a2                	ld	ra,8(sp)
ffffffffc02007ba:	0141                	addi	sp,sp,16
ffffffffc02007bc:	b559                	j	ffffffffc0200642 <print_trapframe>
ffffffffc02007be:	00001517          	auipc	a0,0x1
ffffffffc02007c2:	6ea50513          	addi	a0,a0,1770 # ffffffffc0201ea8 <commands+0x528>
ffffffffc02007c6:	8edff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02007ca:	10843583          	ld	a1,264(s0)
ffffffffc02007ce:	00001517          	auipc	a0,0x1
ffffffffc02007d2:	6b250513          	addi	a0,a0,1714 # ffffffffc0201e80 <commands+0x500>
ffffffffc02007d6:	8ddff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02007da:	10843783          	ld	a5,264(s0)
ffffffffc02007de:	60a2                	ld	ra,8(sp)
ffffffffc02007e0:	0789                	addi	a5,a5,2
ffffffffc02007e2:	10f43423          	sd	a5,264(s0)
ffffffffc02007e6:	6402                	ld	s0,0(sp)
ffffffffc02007e8:	0141                	addi	sp,sp,16
ffffffffc02007ea:	8082                	ret

ffffffffc02007ec <trap>:
ffffffffc02007ec:	11853783          	ld	a5,280(a0)
ffffffffc02007f0:	0007c363          	bltz	a5,ffffffffc02007f6 <trap+0xa>
ffffffffc02007f4:	bf85                	j	ffffffffc0200764 <exception_handler>
ffffffffc02007f6:	b575                	j	ffffffffc02006a2 <interrupt_handler>

ffffffffc02007f8 <__alltraps>:
ffffffffc02007f8:	14011073          	csrw	sscratch,sp
ffffffffc02007fc:	712d                	addi	sp,sp,-288
ffffffffc02007fe:	e002                	sd	zero,0(sp)
ffffffffc0200800:	e406                	sd	ra,8(sp)
ffffffffc0200802:	ec0e                	sd	gp,24(sp)
ffffffffc0200804:	f012                	sd	tp,32(sp)
ffffffffc0200806:	f416                	sd	t0,40(sp)
ffffffffc0200808:	f81a                	sd	t1,48(sp)
ffffffffc020080a:	fc1e                	sd	t2,56(sp)
ffffffffc020080c:	e0a2                	sd	s0,64(sp)
ffffffffc020080e:	e4a6                	sd	s1,72(sp)
ffffffffc0200810:	e8aa                	sd	a0,80(sp)
ffffffffc0200812:	ecae                	sd	a1,88(sp)
ffffffffc0200814:	f0b2                	sd	a2,96(sp)
ffffffffc0200816:	f4b6                	sd	a3,104(sp)
ffffffffc0200818:	f8ba                	sd	a4,112(sp)
ffffffffc020081a:	fcbe                	sd	a5,120(sp)
ffffffffc020081c:	e142                	sd	a6,128(sp)
ffffffffc020081e:	e546                	sd	a7,136(sp)
ffffffffc0200820:	e94a                	sd	s2,144(sp)
ffffffffc0200822:	ed4e                	sd	s3,152(sp)
ffffffffc0200824:	f152                	sd	s4,160(sp)
ffffffffc0200826:	f556                	sd	s5,168(sp)
ffffffffc0200828:	f95a                	sd	s6,176(sp)
ffffffffc020082a:	fd5e                	sd	s7,184(sp)
ffffffffc020082c:	e1e2                	sd	s8,192(sp)
ffffffffc020082e:	e5e6                	sd	s9,200(sp)
ffffffffc0200830:	e9ea                	sd	s10,208(sp)
ffffffffc0200832:	edee                	sd	s11,216(sp)
ffffffffc0200834:	f1f2                	sd	t3,224(sp)
ffffffffc0200836:	f5f6                	sd	t4,232(sp)
ffffffffc0200838:	f9fa                	sd	t5,240(sp)
ffffffffc020083a:	fdfe                	sd	t6,248(sp)
ffffffffc020083c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200840:	100024f3          	csrr	s1,sstatus
ffffffffc0200844:	14102973          	csrr	s2,sepc
ffffffffc0200848:	143029f3          	csrr	s3,stval
ffffffffc020084c:	14202a73          	csrr	s4,scause
ffffffffc0200850:	e822                	sd	s0,16(sp)
ffffffffc0200852:	e226                	sd	s1,256(sp)
ffffffffc0200854:	e64a                	sd	s2,264(sp)
ffffffffc0200856:	ea4e                	sd	s3,272(sp)
ffffffffc0200858:	ee52                	sd	s4,280(sp)
ffffffffc020085a:	850a                	mv	a0,sp
ffffffffc020085c:	f91ff0ef          	jal	ra,ffffffffc02007ec <trap>

ffffffffc0200860 <__trapret>:
ffffffffc0200860:	6492                	ld	s1,256(sp)
ffffffffc0200862:	6932                	ld	s2,264(sp)
ffffffffc0200864:	10049073          	csrw	sstatus,s1
ffffffffc0200868:	14191073          	csrw	sepc,s2
ffffffffc020086c:	60a2                	ld	ra,8(sp)
ffffffffc020086e:	61e2                	ld	gp,24(sp)
ffffffffc0200870:	7202                	ld	tp,32(sp)
ffffffffc0200872:	72a2                	ld	t0,40(sp)
ffffffffc0200874:	7342                	ld	t1,48(sp)
ffffffffc0200876:	73e2                	ld	t2,56(sp)
ffffffffc0200878:	6406                	ld	s0,64(sp)
ffffffffc020087a:	64a6                	ld	s1,72(sp)
ffffffffc020087c:	6546                	ld	a0,80(sp)
ffffffffc020087e:	65e6                	ld	a1,88(sp)
ffffffffc0200880:	7606                	ld	a2,96(sp)
ffffffffc0200882:	76a6                	ld	a3,104(sp)
ffffffffc0200884:	7746                	ld	a4,112(sp)
ffffffffc0200886:	77e6                	ld	a5,120(sp)
ffffffffc0200888:	680a                	ld	a6,128(sp)
ffffffffc020088a:	68aa                	ld	a7,136(sp)
ffffffffc020088c:	694a                	ld	s2,144(sp)
ffffffffc020088e:	69ea                	ld	s3,152(sp)
ffffffffc0200890:	7a0a                	ld	s4,160(sp)
ffffffffc0200892:	7aaa                	ld	s5,168(sp)
ffffffffc0200894:	7b4a                	ld	s6,176(sp)
ffffffffc0200896:	7bea                	ld	s7,184(sp)
ffffffffc0200898:	6c0e                	ld	s8,192(sp)
ffffffffc020089a:	6cae                	ld	s9,200(sp)
ffffffffc020089c:	6d4e                	ld	s10,208(sp)
ffffffffc020089e:	6dee                	ld	s11,216(sp)
ffffffffc02008a0:	7e0e                	ld	t3,224(sp)
ffffffffc02008a2:	7eae                	ld	t4,232(sp)
ffffffffc02008a4:	7f4e                	ld	t5,240(sp)
ffffffffc02008a6:	7fee                	ld	t6,248(sp)
ffffffffc02008a8:	6142                	ld	sp,16(sp)
ffffffffc02008aa:	10200073          	sret

ffffffffc02008ae <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008ae:	100027f3          	csrr	a5,sstatus
ffffffffc02008b2:	8b89                	andi	a5,a5,2
ffffffffc02008b4:	e799                	bnez	a5,ffffffffc02008c2 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02008b6:	00006797          	auipc	a5,0x6
ffffffffc02008ba:	ba27b783          	ld	a5,-1118(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008be:	6f9c                	ld	a5,24(a5)
ffffffffc02008c0:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02008c2:	1141                	addi	sp,sp,-16
ffffffffc02008c4:	e406                	sd	ra,8(sp)
ffffffffc02008c6:	e022                	sd	s0,0(sp)
ffffffffc02008c8:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02008ca:	b95ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02008ce:	00006797          	auipc	a5,0x6
ffffffffc02008d2:	b8a7b783          	ld	a5,-1142(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008d6:	6f9c                	ld	a5,24(a5)
ffffffffc02008d8:	8522                	mv	a0,s0
ffffffffc02008da:	9782                	jalr	a5
ffffffffc02008dc:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02008de:	b7bff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02008e2:	60a2                	ld	ra,8(sp)
ffffffffc02008e4:	8522                	mv	a0,s0
ffffffffc02008e6:	6402                	ld	s0,0(sp)
ffffffffc02008e8:	0141                	addi	sp,sp,16
ffffffffc02008ea:	8082                	ret

ffffffffc02008ec <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008ec:	100027f3          	csrr	a5,sstatus
ffffffffc02008f0:	8b89                	andi	a5,a5,2
ffffffffc02008f2:	e799                	bnez	a5,ffffffffc0200900 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02008f4:	00006797          	auipc	a5,0x6
ffffffffc02008f8:	b647b783          	ld	a5,-1180(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008fc:	739c                	ld	a5,32(a5)
ffffffffc02008fe:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0200900:	1101                	addi	sp,sp,-32
ffffffffc0200902:	ec06                	sd	ra,24(sp)
ffffffffc0200904:	e822                	sd	s0,16(sp)
ffffffffc0200906:	e426                	sd	s1,8(sp)
ffffffffc0200908:	842a                	mv	s0,a0
ffffffffc020090a:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc020090c:	b53ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200910:	00006797          	auipc	a5,0x6
ffffffffc0200914:	b487b783          	ld	a5,-1208(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0200918:	739c                	ld	a5,32(a5)
ffffffffc020091a:	85a6                	mv	a1,s1
ffffffffc020091c:	8522                	mv	a0,s0
ffffffffc020091e:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200920:	6442                	ld	s0,16(sp)
ffffffffc0200922:	60e2                	ld	ra,24(sp)
ffffffffc0200924:	64a2                	ld	s1,8(sp)
ffffffffc0200926:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200928:	be05                	j	ffffffffc0200458 <intr_enable>

ffffffffc020092a <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020092a:	100027f3          	csrr	a5,sstatus
ffffffffc020092e:	8b89                	andi	a5,a5,2
ffffffffc0200930:	e799                	bnez	a5,ffffffffc020093e <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200932:	00006797          	auipc	a5,0x6
ffffffffc0200936:	b267b783          	ld	a5,-1242(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020093a:	779c                	ld	a5,40(a5)
ffffffffc020093c:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc020093e:	1141                	addi	sp,sp,-16
ffffffffc0200940:	e406                	sd	ra,8(sp)
ffffffffc0200942:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200944:	b1bff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200948:	00006797          	auipc	a5,0x6
ffffffffc020094c:	b107b783          	ld	a5,-1264(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0200950:	779c                	ld	a5,40(a5)
ffffffffc0200952:	9782                	jalr	a5
ffffffffc0200954:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200956:	b03ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc020095a:	60a2                	ld	ra,8(sp)
ffffffffc020095c:	8522                	mv	a0,s0
ffffffffc020095e:	6402                	ld	s0,0(sp)
ffffffffc0200960:	0141                	addi	sp,sp,16
ffffffffc0200962:	8082                	ret

ffffffffc0200964 <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200964:	00002797          	auipc	a5,0x2
ffffffffc0200968:	8ac78793          	addi	a5,a5,-1876 # ffffffffc0202210 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020096c:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020096e:	1101                	addi	sp,sp,-32
ffffffffc0200970:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200972:	00001517          	auipc	a0,0x1
ffffffffc0200976:	55650513          	addi	a0,a0,1366 # ffffffffc0201ec8 <commands+0x548>
    pmm_manager = &buddy_pmm_manager;
ffffffffc020097a:	00006497          	auipc	s1,0x6
ffffffffc020097e:	ade48493          	addi	s1,s1,-1314 # ffffffffc0206458 <pmm_manager>
void pmm_init(void) {
ffffffffc0200982:	ec06                	sd	ra,24(sp)
ffffffffc0200984:	e822                	sd	s0,16(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200986:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200988:	f2aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc020098c:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020098e:	00006417          	auipc	s0,0x6
ffffffffc0200992:	ae240413          	addi	s0,s0,-1310 # ffffffffc0206470 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200996:	679c                	ld	a5,8(a5)
ffffffffc0200998:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020099a:	57f5                	li	a5,-3
ffffffffc020099c:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc020099e:	00001517          	auipc	a0,0x1
ffffffffc02009a2:	54250513          	addi	a0,a0,1346 # ffffffffc0201ee0 <commands+0x560>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02009a6:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc02009a8:	f0aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02009ac:	46c5                	li	a3,17
ffffffffc02009ae:	06ee                	slli	a3,a3,0x1b
ffffffffc02009b0:	40100613          	li	a2,1025
ffffffffc02009b4:	16fd                	addi	a3,a3,-1
ffffffffc02009b6:	07e005b7          	lui	a1,0x7e00
ffffffffc02009ba:	0656                	slli	a2,a2,0x15
ffffffffc02009bc:	00001517          	auipc	a0,0x1
ffffffffc02009c0:	53c50513          	addi	a0,a0,1340 # ffffffffc0201ef8 <commands+0x578>
ffffffffc02009c4:	eeeff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009c8:	777d                	lui	a4,0xfffff
ffffffffc02009ca:	00007797          	auipc	a5,0x7
ffffffffc02009ce:	ad578793          	addi	a5,a5,-1323 # ffffffffc020749f <end+0xfff>
ffffffffc02009d2:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc02009d4:	00006517          	auipc	a0,0x6
ffffffffc02009d8:	a7450513          	addi	a0,a0,-1420 # ffffffffc0206448 <npage>
ffffffffc02009dc:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009e0:	00006597          	auipc	a1,0x6
ffffffffc02009e4:	a7058593          	addi	a1,a1,-1424 # ffffffffc0206450 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02009e8:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009ea:	e19c                	sd	a5,0(a1)
ffffffffc02009ec:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02009ee:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02009f0:	4885                	li	a7,1
ffffffffc02009f2:	fff80837          	lui	a6,0xfff80
ffffffffc02009f6:	a011                	j	ffffffffc02009fa <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc02009f8:	619c                	ld	a5,0(a1)
ffffffffc02009fa:	97b6                	add	a5,a5,a3
ffffffffc02009fc:	07a1                	addi	a5,a5,8
ffffffffc02009fe:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a02:	611c                	ld	a5,0(a0)
ffffffffc0200a04:	0705                	addi	a4,a4,1
ffffffffc0200a06:	02868693          	addi	a3,a3,40
ffffffffc0200a0a:	01078633          	add	a2,a5,a6
ffffffffc0200a0e:	fec765e3          	bltu	a4,a2,ffffffffc02009f8 <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a12:	6190                	ld	a2,0(a1)
ffffffffc0200a14:	00279713          	slli	a4,a5,0x2
ffffffffc0200a18:	973e                	add	a4,a4,a5
ffffffffc0200a1a:	fec006b7          	lui	a3,0xfec00
ffffffffc0200a1e:	070e                	slli	a4,a4,0x3
ffffffffc0200a20:	96b2                	add	a3,a3,a2
ffffffffc0200a22:	96ba                	add	a3,a3,a4
ffffffffc0200a24:	c0200737          	lui	a4,0xc0200
ffffffffc0200a28:	08e6ef63          	bltu	a3,a4,ffffffffc0200ac6 <pmm_init+0x162>
ffffffffc0200a2c:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc0200a2e:	45c5                	li	a1,17
ffffffffc0200a30:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a32:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200a34:	04b6e863          	bltu	a3,a1,ffffffffc0200a84 <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200a38:	609c                	ld	a5,0(s1)
ffffffffc0200a3a:	7b9c                	ld	a5,48(a5)
ffffffffc0200a3c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200a3e:	00001517          	auipc	a0,0x1
ffffffffc0200a42:	55250513          	addi	a0,a0,1362 # ffffffffc0201f90 <commands+0x610>
ffffffffc0200a46:	e6cff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200a4a:	00004597          	auipc	a1,0x4
ffffffffc0200a4e:	5b658593          	addi	a1,a1,1462 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200a52:	00006797          	auipc	a5,0x6
ffffffffc0200a56:	a0b7bb23          	sd	a1,-1514(a5) # ffffffffc0206468 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a5a:	c02007b7          	lui	a5,0xc0200
ffffffffc0200a5e:	08f5e063          	bltu	a1,a5,ffffffffc0200ade <pmm_init+0x17a>
ffffffffc0200a62:	6010                	ld	a2,0(s0)
}
ffffffffc0200a64:	6442                	ld	s0,16(sp)
ffffffffc0200a66:	60e2                	ld	ra,24(sp)
ffffffffc0200a68:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a6a:	40c58633          	sub	a2,a1,a2
ffffffffc0200a6e:	00006797          	auipc	a5,0x6
ffffffffc0200a72:	9ec7b923          	sd	a2,-1550(a5) # ffffffffc0206460 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a76:	00001517          	auipc	a0,0x1
ffffffffc0200a7a:	53a50513          	addi	a0,a0,1338 # ffffffffc0201fb0 <commands+0x630>
}
ffffffffc0200a7e:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a80:	e32ff06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200a84:	6705                	lui	a4,0x1
ffffffffc0200a86:	177d                	addi	a4,a4,-1
ffffffffc0200a88:	96ba                	add	a3,a3,a4
ffffffffc0200a8a:	777d                	lui	a4,0xfffff
ffffffffc0200a8c:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200a8e:	00c6d513          	srli	a0,a3,0xc
ffffffffc0200a92:	00f57e63          	bgeu	a0,a5,ffffffffc0200aae <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc0200a96:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200a98:	982a                	add	a6,a6,a0
ffffffffc0200a9a:	00281513          	slli	a0,a6,0x2
ffffffffc0200a9e:	9542                	add	a0,a0,a6
ffffffffc0200aa0:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200aa2:	8d95                	sub	a1,a1,a3
ffffffffc0200aa4:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200aa6:	81b1                	srli	a1,a1,0xc
ffffffffc0200aa8:	9532                	add	a0,a0,a2
ffffffffc0200aaa:	9782                	jalr	a5
}
ffffffffc0200aac:	b771                	j	ffffffffc0200a38 <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0200aae:	00001617          	auipc	a2,0x1
ffffffffc0200ab2:	4b260613          	addi	a2,a2,1202 # ffffffffc0201f60 <commands+0x5e0>
ffffffffc0200ab6:	06b00593          	li	a1,107
ffffffffc0200aba:	00001517          	auipc	a0,0x1
ffffffffc0200abe:	4c650513          	addi	a0,a0,1222 # ffffffffc0201f80 <commands+0x600>
ffffffffc0200ac2:	e78ff0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200ac6:	00001617          	auipc	a2,0x1
ffffffffc0200aca:	46260613          	addi	a2,a2,1122 # ffffffffc0201f28 <commands+0x5a8>
ffffffffc0200ace:	06f00593          	li	a1,111
ffffffffc0200ad2:	00001517          	auipc	a0,0x1
ffffffffc0200ad6:	47e50513          	addi	a0,a0,1150 # ffffffffc0201f50 <commands+0x5d0>
ffffffffc0200ada:	e60ff0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200ade:	86ae                	mv	a3,a1
ffffffffc0200ae0:	00001617          	auipc	a2,0x1
ffffffffc0200ae4:	44860613          	addi	a2,a2,1096 # ffffffffc0201f28 <commands+0x5a8>
ffffffffc0200ae8:	08a00593          	li	a1,138
ffffffffc0200aec:	00001517          	auipc	a0,0x1
ffffffffc0200af0:	46450513          	addi	a0,a0,1124 # ffffffffc0201f50 <commands+0x5d0>
ffffffffc0200af4:	e46ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200af8 <buddy_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200af8:	00005797          	auipc	a5,0x5
ffffffffc0200afc:	52078793          	addi	a5,a5,1312 # ffffffffc0206018 <free_area>
ffffffffc0200b00:	e79c                	sd	a5,8(a5)
ffffffffc0200b02:	e39c                	sd	a5,0(a5)

//初始化 buddy 系统的自由列表和自由页计数
static void buddy_init(void)
{
    list_init(&free_list);//管理空闲页
    nr_free = 0;
ffffffffc0200b04:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b08:	8082                	ret

ffffffffc0200b0a <buddy_nr_free_pages>:
    }
}

static size_t
buddy_nr_free_pages(void) {
    return buddy_page[1];
ffffffffc0200b0a:	00006797          	auipc	a5,0x6
ffffffffc0200b0e:	96e7b783          	ld	a5,-1682(a5) # ffffffffc0206478 <buddy_page>
}
ffffffffc0200b12:	0047e503          	lwu	a0,4(a5)
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <buddy_alloc_pages>:
    assert(n > 0);
ffffffffc0200b18:	c965                	beqz	a0,ffffffffc0200c08 <buddy_alloc_pages+0xf0>
    if (n > buddy_page[1]){
ffffffffc0200b1a:	00006817          	auipc	a6,0x6
ffffffffc0200b1e:	95e80813          	addi	a6,a6,-1698 # ffffffffc0206478 <buddy_page>
ffffffffc0200b22:	00083583          	ld	a1,0(a6)
ffffffffc0200b26:	0045e783          	lwu	a5,4(a1)
ffffffffc0200b2a:	0ca7ed63          	bltu	a5,a0,ffffffffc0200c04 <buddy_alloc_pages+0xec>
    unsigned int index = 1;
ffffffffc0200b2e:	4705                	li	a4,1
        if (buddy_page[LEFT_CHILD(index)] >= n){
ffffffffc0200b30:	0017169b          	slliw	a3,a4,0x1
ffffffffc0200b34:	02069793          	slli	a5,a3,0x20
ffffffffc0200b38:	83f9                	srli	a5,a5,0x1e
ffffffffc0200b3a:	97ae                	add	a5,a5,a1
ffffffffc0200b3c:	0007e783          	lwu	a5,0(a5)
ffffffffc0200b40:	0007061b          	sext.w	a2,a4
ffffffffc0200b44:	0006871b          	sext.w	a4,a3
ffffffffc0200b48:	fea7f4e3          	bgeu	a5,a0,ffffffffc0200b30 <buddy_alloc_pages+0x18>
        else if (buddy_page[RIGHT_CHILD(index)] >= n){
ffffffffc0200b4c:	2705                	addiw	a4,a4,1
ffffffffc0200b4e:	02071693          	slli	a3,a4,0x20
ffffffffc0200b52:	01e6d793          	srli	a5,a3,0x1e
ffffffffc0200b56:	97ae                	add	a5,a5,a1
ffffffffc0200b58:	0007e783          	lwu	a5,0(a5)
ffffffffc0200b5c:	fca7fae3          	bgeu	a5,a0,ffffffffc0200b30 <buddy_alloc_pages+0x18>
    unsigned int size = buddy_page[index];
ffffffffc0200b60:	02061713          	slli	a4,a2,0x20
ffffffffc0200b64:	01e75793          	srli	a5,a4,0x1e
ffffffffc0200b68:	95be                	add	a1,a1,a5
ffffffffc0200b6a:	4198                	lw	a4,0(a1)
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
ffffffffc0200b6c:	00006517          	auipc	a0,0x6
ffffffffc0200b70:	91c53503          	ld	a0,-1764(a0) # ffffffffc0206488 <useable_page_base>
    buddy_page[index] = 0;
ffffffffc0200b74:	0005a023          	sw	zero,0(a1)
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
ffffffffc0200b78:	02e607bb          	mulw	a5,a2,a4
    for (struct Page* p = new_page; p != new_page + size; p++){
ffffffffc0200b7c:	02071693          	slli	a3,a4,0x20
ffffffffc0200b80:	9281                	srli	a3,a3,0x20
ffffffffc0200b82:	00269713          	slli	a4,a3,0x2
ffffffffc0200b86:	9736                	add	a4,a4,a3
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
ffffffffc0200b88:	00006697          	auipc	a3,0x6
ffffffffc0200b8c:	9086a683          	lw	a3,-1784(a3) # ffffffffc0206490 <useable_page_num>
    for (struct Page* p = new_page; p != new_page + size; p++){
ffffffffc0200b90:	070e                	slli	a4,a4,0x3
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
ffffffffc0200b92:	9f95                	subw	a5,a5,a3
ffffffffc0200b94:	1782                	slli	a5,a5,0x20
ffffffffc0200b96:	9381                	srli	a5,a5,0x20
ffffffffc0200b98:	00279693          	slli	a3,a5,0x2
ffffffffc0200b9c:	97b6                	add	a5,a5,a3
ffffffffc0200b9e:	078e                	slli	a5,a5,0x3
ffffffffc0200ba0:	953e                	add	a0,a0,a5
    for (struct Page* p = new_page; p != new_page + size; p++){
ffffffffc0200ba2:	972a                	add	a4,a4,a0
ffffffffc0200ba4:	00e50e63          	beq	a0,a4,ffffffffc0200bc0 <buddy_alloc_pages+0xa8>
ffffffffc0200ba8:	87aa                	mv	a5,a0
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200baa:	56f5                	li	a3,-3
ffffffffc0200bac:	00878593          	addi	a1,a5,8
ffffffffc0200bb0:	60d5b02f          	amoand.d	zero,a3,(a1)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200bb4:	0007a023          	sw	zero,0(a5)
ffffffffc0200bb8:	02878793          	addi	a5,a5,40
ffffffffc0200bbc:	fee798e3          	bne	a5,a4,ffffffffc0200bac <buddy_alloc_pages+0x94>
    index = PARENT(index);
ffffffffc0200bc0:	0016561b          	srliw	a2,a2,0x1
    while(index > 0){
ffffffffc0200bc4:	c229                	beqz	a2,ffffffffc0200c06 <buddy_alloc_pages+0xee>
        buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
ffffffffc0200bc6:	00083683          	ld	a3,0(a6)
ffffffffc0200bca:	0016179b          	slliw	a5,a2,0x1
ffffffffc0200bce:	0017871b          	addiw	a4,a5,1
ffffffffc0200bd2:	1782                	slli	a5,a5,0x20
ffffffffc0200bd4:	02071593          	slli	a1,a4,0x20
ffffffffc0200bd8:	9381                	srli	a5,a5,0x20
ffffffffc0200bda:	01e5d713          	srli	a4,a1,0x1e
ffffffffc0200bde:	078a                	slli	a5,a5,0x2
ffffffffc0200be0:	97b6                	add	a5,a5,a3
ffffffffc0200be2:	9736                	add	a4,a4,a3
ffffffffc0200be4:	438c                	lw	a1,0(a5)
ffffffffc0200be6:	4318                	lw	a4,0(a4)
ffffffffc0200be8:	00261793          	slli	a5,a2,0x2
ffffffffc0200bec:	0005881b          	sext.w	a6,a1
ffffffffc0200bf0:	0007089b          	sext.w	a7,a4
ffffffffc0200bf4:	97b6                	add	a5,a5,a3
ffffffffc0200bf6:	0108f363          	bgeu	a7,a6,ffffffffc0200bfc <buddy_alloc_pages+0xe4>
ffffffffc0200bfa:	872e                	mv	a4,a1
ffffffffc0200bfc:	c398                	sw	a4,0(a5)
        index = PARENT(index);
ffffffffc0200bfe:	8205                	srli	a2,a2,0x1
    while(index > 0){
ffffffffc0200c00:	f669                	bnez	a2,ffffffffc0200bca <buddy_alloc_pages+0xb2>
ffffffffc0200c02:	8082                	ret
        return NULL;
ffffffffc0200c04:	4501                	li	a0,0
}
ffffffffc0200c06:	8082                	ret
Page* buddy_alloc_pages(size_t n) {
ffffffffc0200c08:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200c0a:	00001697          	auipc	a3,0x1
ffffffffc0200c0e:	3e668693          	addi	a3,a3,998 # ffffffffc0201ff0 <commands+0x670>
ffffffffc0200c12:	00001617          	auipc	a2,0x1
ffffffffc0200c16:	3e660613          	addi	a2,a2,998 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200c1a:	04a00593          	li	a1,74
ffffffffc0200c1e:	00001517          	auipc	a0,0x1
ffffffffc0200c22:	3f250513          	addi	a0,a0,1010 # ffffffffc0202010 <commands+0x690>
Page* buddy_alloc_pages(size_t n) {
ffffffffc0200c26:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c28:	d12ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200c2c <buddy_check>:

static void
buddy_check(void) {
ffffffffc0200c2c:	7179                	addi	sp,sp,-48
ffffffffc0200c2e:	e44e                	sd	s3,8(sp)
ffffffffc0200c30:	f406                	sd	ra,40(sp)
ffffffffc0200c32:	f022                	sd	s0,32(sp)
ffffffffc0200c34:	ec26                	sd	s1,24(sp)
ffffffffc0200c36:	e84a                	sd	s2,16(sp)
ffffffffc0200c38:	e052                	sd	s4,0(sp)
    int all_pages = nr_free_pages();
ffffffffc0200c3a:	cf1ff0ef          	jal	ra,ffffffffc020092a <nr_free_pages>
ffffffffc0200c3e:	89aa                	mv	s3,a0
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc0200c40:	2505                	addiw	a0,a0,1
ffffffffc0200c42:	c6dff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200c46:	26051263          	bnez	a0,ffffffffc0200eaa <buddy_check+0x27e>
    // 分配两个组页
    p0 = alloc_pages(1);
ffffffffc0200c4a:	4505                	li	a0,1
ffffffffc0200c4c:	c63ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200c50:	842a                	mv	s0,a0
    assert(p0 != NULL);
ffffffffc0200c52:	22050c63          	beqz	a0,ffffffffc0200e8a <buddy_check+0x25e>
    p1 = alloc_pages(2);
ffffffffc0200c56:	4509                	li	a0,2
ffffffffc0200c58:	c57ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
    assert(p1 == p0 + 2);
ffffffffc0200c5c:	05040793          	addi	a5,s0,80
    p1 = alloc_pages(2);
ffffffffc0200c60:	84aa                	mv	s1,a0
    assert(p1 == p0 + 2);
ffffffffc0200c62:	1af51463          	bne	a0,a5,ffffffffc0200e0a <buddy_check+0x1de>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c66:	641c                	ld	a5,8(s0)
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200c68:	8b85                	andi	a5,a5,1
ffffffffc0200c6a:	12079063          	bnez	a5,ffffffffc0200d8a <buddy_check+0x15e>
ffffffffc0200c6e:	641c                	ld	a5,8(s0)
ffffffffc0200c70:	8385                	srli	a5,a5,0x1
ffffffffc0200c72:	8b85                	andi	a5,a5,1
ffffffffc0200c74:	10079b63          	bnez	a5,ffffffffc0200d8a <buddy_check+0x15e>
ffffffffc0200c78:	651c                	ld	a5,8(a0)
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200c7a:	8b85                	andi	a5,a5,1
ffffffffc0200c7c:	0e079763          	bnez	a5,ffffffffc0200d6a <buddy_check+0x13e>
ffffffffc0200c80:	651c                	ld	a5,8(a0)
ffffffffc0200c82:	8385                	srli	a5,a5,0x1
ffffffffc0200c84:	8b85                	andi	a5,a5,1
ffffffffc0200c86:	0e079263          	bnez	a5,ffffffffc0200d6a <buddy_check+0x13e>
    // 再分配两个组页
    p2 = alloc_pages(1);
ffffffffc0200c8a:	4505                	li	a0,1
ffffffffc0200c8c:	c23ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
    assert(p2 == p0 + 1);
ffffffffc0200c90:	02840793          	addi	a5,s0,40
    p2 = alloc_pages(1);
ffffffffc0200c94:	8a2a                	mv	s4,a0
    assert(p2 == p0 + 1);
ffffffffc0200c96:	12f51a63          	bne	a0,a5,ffffffffc0200dca <buddy_check+0x19e>
    p3 = alloc_pages(8);
ffffffffc0200c9a:	4521                	li	a0,8
ffffffffc0200c9c:	c13ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
    assert(p3 == p0 + 8);
ffffffffc0200ca0:	14040793          	addi	a5,s0,320
    p3 = alloc_pages(8);
ffffffffc0200ca4:	892a                	mv	s2,a0
    assert(p3 == p0 + 8);
ffffffffc0200ca6:	24f51263          	bne	a0,a5,ffffffffc0200eea <buddy_check+0x2be>
ffffffffc0200caa:	651c                	ld	a5,8(a0)
ffffffffc0200cac:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc0200cae:	8b85                	andi	a5,a5,1
ffffffffc0200cb0:	efc9                	bnez	a5,ffffffffc0200d4a <buddy_check+0x11e>
ffffffffc0200cb2:	12053783          	ld	a5,288(a0)
ffffffffc0200cb6:	8385                	srli	a5,a5,0x1
ffffffffc0200cb8:	8b85                	andi	a5,a5,1
ffffffffc0200cba:	ebc1                	bnez	a5,ffffffffc0200d4a <buddy_check+0x11e>
ffffffffc0200cbc:	14853783          	ld	a5,328(a0)
ffffffffc0200cc0:	8385                	srli	a5,a5,0x1
ffffffffc0200cc2:	8b85                	andi	a5,a5,1
ffffffffc0200cc4:	c3d9                	beqz	a5,ffffffffc0200d4a <buddy_check+0x11e>
    // 回收页
    free_pages(p1, 2);
ffffffffc0200cc6:	4589                	li	a1,2
ffffffffc0200cc8:	8526                	mv	a0,s1
ffffffffc0200cca:	c23ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
ffffffffc0200cce:	649c                	ld	a5,8(s1)
ffffffffc0200cd0:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && PageProperty(p1 + 1));
ffffffffc0200cd2:	8b85                	andi	a5,a5,1
ffffffffc0200cd4:	0c078b63          	beqz	a5,ffffffffc0200daa <buddy_check+0x17e>
ffffffffc0200cd8:	789c                	ld	a5,48(s1)
ffffffffc0200cda:	8385                	srli	a5,a5,0x1
ffffffffc0200cdc:	8b85                	andi	a5,a5,1
ffffffffc0200cde:	c7f1                	beqz	a5,ffffffffc0200daa <buddy_check+0x17e>
    assert(p1->ref == 0);
ffffffffc0200ce0:	409c                	lw	a5,0(s1)
ffffffffc0200ce2:	14079463          	bnez	a5,ffffffffc0200e2a <buddy_check+0x1fe>
    free_pages(p0, 1);
ffffffffc0200ce6:	4585                	li	a1,1
ffffffffc0200ce8:	8522                	mv	a0,s0
ffffffffc0200cea:	c03ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_pages(p2, 1);
ffffffffc0200cee:	8552                	mv	a0,s4
ffffffffc0200cf0:	4585                	li	a1,1
ffffffffc0200cf2:	bfbff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
ffffffffc0200cf6:	450d                	li	a0,3
ffffffffc0200cf8:	bb7ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
    assert(p2 == p0);
ffffffffc0200cfc:	16a41763          	bne	s0,a0,ffffffffc0200e6a <buddy_check+0x23e>
    free_pages(p2, 3);
ffffffffc0200d00:	458d                	li	a1,3
ffffffffc0200d02:	bebff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert((p2 + 2)->ref == 0);
ffffffffc0200d06:	483c                	lw	a5,80(s0)
ffffffffc0200d08:	14079163          	bnez	a5,ffffffffc0200e4a <buddy_check+0x21e>
    assert(nr_free_pages() == all_pages >> 1);
ffffffffc0200d0c:	2981                	sext.w	s3,s3
ffffffffc0200d0e:	c1dff0ef          	jal	ra,ffffffffc020092a <nr_free_pages>
ffffffffc0200d12:	4019d993          	srai	s3,s3,0x1
ffffffffc0200d16:	0d351a63          	bne	a0,s3,ffffffffc0200dea <buddy_check+0x1be>

    p1 = alloc_pages(129);
ffffffffc0200d1a:	08100513          	li	a0,129
ffffffffc0200d1e:	b91ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
    assert(p1 == p0 + 256);
ffffffffc0200d22:	678d                	lui	a5,0x3
ffffffffc0200d24:	80078793          	addi	a5,a5,-2048 # 2800 <kern_entry-0xffffffffc01fd800>
ffffffffc0200d28:	943e                	add	s0,s0,a5
ffffffffc0200d2a:	1a851063          	bne	a0,s0,ffffffffc0200eca <buddy_check+0x29e>
    free_pages(p1, 256);
ffffffffc0200d2e:	10000593          	li	a1,256
ffffffffc0200d32:	bbbff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_pages(p3, 8);
}
ffffffffc0200d36:	7402                	ld	s0,32(sp)
ffffffffc0200d38:	70a2                	ld	ra,40(sp)
ffffffffc0200d3a:	64e2                	ld	s1,24(sp)
ffffffffc0200d3c:	69a2                	ld	s3,8(sp)
ffffffffc0200d3e:	6a02                	ld	s4,0(sp)
    free_pages(p3, 8);
ffffffffc0200d40:	854a                	mv	a0,s2
}
ffffffffc0200d42:	6942                	ld	s2,16(sp)
    free_pages(p3, 8);
ffffffffc0200d44:	45a1                	li	a1,8
}
ffffffffc0200d46:	6145                	addi	sp,sp,48
    free_pages(p3, 8);
ffffffffc0200d48:	b655                	j	ffffffffc02008ec <free_pages>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc0200d4a:	00001697          	auipc	a3,0x1
ffffffffc0200d4e:	39668693          	addi	a3,a3,918 # ffffffffc02020e0 <commands+0x760>
ffffffffc0200d52:	00001617          	auipc	a2,0x1
ffffffffc0200d56:	2a660613          	addi	a2,a2,678 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200d5a:	0ab00593          	li	a1,171
ffffffffc0200d5e:	00001517          	auipc	a0,0x1
ffffffffc0200d62:	2b250513          	addi	a0,a0,690 # ffffffffc0202010 <commands+0x690>
ffffffffc0200d66:	bd4ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200d6a:	00001697          	auipc	a3,0x1
ffffffffc0200d6e:	32e68693          	addi	a3,a3,814 # ffffffffc0202098 <commands+0x718>
ffffffffc0200d72:	00001617          	auipc	a2,0x1
ffffffffc0200d76:	28660613          	addi	a2,a2,646 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200d7a:	0a500593          	li	a1,165
ffffffffc0200d7e:	00001517          	auipc	a0,0x1
ffffffffc0200d82:	29250513          	addi	a0,a0,658 # ffffffffc0202010 <commands+0x690>
ffffffffc0200d86:	bb4ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200d8a:	00001697          	auipc	a3,0x1
ffffffffc0200d8e:	2e668693          	addi	a3,a3,742 # ffffffffc0202070 <commands+0x6f0>
ffffffffc0200d92:	00001617          	auipc	a2,0x1
ffffffffc0200d96:	26660613          	addi	a2,a2,614 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200d9a:	0a400593          	li	a1,164
ffffffffc0200d9e:	00001517          	auipc	a0,0x1
ffffffffc0200da2:	27250513          	addi	a0,a0,626 # ffffffffc0202010 <commands+0x690>
ffffffffc0200da6:	b94ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p1) && PageProperty(p1 + 1));
ffffffffc0200daa:	00001697          	auipc	a3,0x1
ffffffffc0200dae:	37e68693          	addi	a3,a3,894 # ffffffffc0202128 <commands+0x7a8>
ffffffffc0200db2:	00001617          	auipc	a2,0x1
ffffffffc0200db6:	24660613          	addi	a2,a2,582 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200dba:	0ae00593          	li	a1,174
ffffffffc0200dbe:	00001517          	auipc	a0,0x1
ffffffffc0200dc2:	25250513          	addi	a0,a0,594 # ffffffffc0202010 <commands+0x690>
ffffffffc0200dc6:	b74ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p2 == p0 + 1);
ffffffffc0200dca:	00001697          	auipc	a3,0x1
ffffffffc0200dce:	2f668693          	addi	a3,a3,758 # ffffffffc02020c0 <commands+0x740>
ffffffffc0200dd2:	00001617          	auipc	a2,0x1
ffffffffc0200dd6:	22660613          	addi	a2,a2,550 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200dda:	0a800593          	li	a1,168
ffffffffc0200dde:	00001517          	auipc	a0,0x1
ffffffffc0200de2:	23250513          	addi	a0,a0,562 # ffffffffc0202010 <commands+0x690>
ffffffffc0200de6:	b54ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free_pages() == all_pages >> 1);
ffffffffc0200dea:	00001697          	auipc	a3,0x1
ffffffffc0200dee:	3a668693          	addi	a3,a3,934 # ffffffffc0202190 <commands+0x810>
ffffffffc0200df2:	00001617          	auipc	a2,0x1
ffffffffc0200df6:	20660613          	addi	a2,a2,518 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200dfa:	0b700593          	li	a1,183
ffffffffc0200dfe:	00001517          	auipc	a0,0x1
ffffffffc0200e02:	21250513          	addi	a0,a0,530 # ffffffffc0202010 <commands+0x690>
ffffffffc0200e06:	b34ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 == p0 + 2);
ffffffffc0200e0a:	00001697          	auipc	a3,0x1
ffffffffc0200e0e:	25668693          	addi	a3,a3,598 # ffffffffc0202060 <commands+0x6e0>
ffffffffc0200e12:	00001617          	auipc	a2,0x1
ffffffffc0200e16:	1e660613          	addi	a2,a2,486 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200e1a:	0a300593          	li	a1,163
ffffffffc0200e1e:	00001517          	auipc	a0,0x1
ffffffffc0200e22:	1f250513          	addi	a0,a0,498 # ffffffffc0202010 <commands+0x690>
ffffffffc0200e26:	b14ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1->ref == 0);
ffffffffc0200e2a:	00001697          	auipc	a3,0x1
ffffffffc0200e2e:	32e68693          	addi	a3,a3,814 # ffffffffc0202158 <commands+0x7d8>
ffffffffc0200e32:	00001617          	auipc	a2,0x1
ffffffffc0200e36:	1c660613          	addi	a2,a2,454 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200e3a:	0af00593          	li	a1,175
ffffffffc0200e3e:	00001517          	auipc	a0,0x1
ffffffffc0200e42:	1d250513          	addi	a0,a0,466 # ffffffffc0202010 <commands+0x690>
ffffffffc0200e46:	af4ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 + 2)->ref == 0);
ffffffffc0200e4a:	00001697          	auipc	a3,0x1
ffffffffc0200e4e:	32e68693          	addi	a3,a3,814 # ffffffffc0202178 <commands+0x7f8>
ffffffffc0200e52:	00001617          	auipc	a2,0x1
ffffffffc0200e56:	1a660613          	addi	a2,a2,422 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200e5a:	0b600593          	li	a1,182
ffffffffc0200e5e:	00001517          	auipc	a0,0x1
ffffffffc0200e62:	1b250513          	addi	a0,a0,434 # ffffffffc0202010 <commands+0x690>
ffffffffc0200e66:	ad4ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p2 == p0);
ffffffffc0200e6a:	00001697          	auipc	a3,0x1
ffffffffc0200e6e:	2fe68693          	addi	a3,a3,766 # ffffffffc0202168 <commands+0x7e8>
ffffffffc0200e72:	00001617          	auipc	a2,0x1
ffffffffc0200e76:	18660613          	addi	a2,a2,390 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200e7a:	0b400593          	li	a1,180
ffffffffc0200e7e:	00001517          	auipc	a0,0x1
ffffffffc0200e82:	19250513          	addi	a0,a0,402 # ffffffffc0202010 <commands+0x690>
ffffffffc0200e86:	ab4ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc0200e8a:	00001697          	auipc	a3,0x1
ffffffffc0200e8e:	1c668693          	addi	a3,a3,454 # ffffffffc0202050 <commands+0x6d0>
ffffffffc0200e92:	00001617          	auipc	a2,0x1
ffffffffc0200e96:	16660613          	addi	a2,a2,358 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200e9a:	0a100593          	li	a1,161
ffffffffc0200e9e:	00001517          	auipc	a0,0x1
ffffffffc0200ea2:	17250513          	addi	a0,a0,370 # ffffffffc0202010 <commands+0x690>
ffffffffc0200ea6:	a94ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc0200eaa:	00001697          	auipc	a3,0x1
ffffffffc0200eae:	17e68693          	addi	a3,a3,382 # ffffffffc0202028 <commands+0x6a8>
ffffffffc0200eb2:	00001617          	auipc	a2,0x1
ffffffffc0200eb6:	14660613          	addi	a2,a2,326 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200eba:	09e00593          	li	a1,158
ffffffffc0200ebe:	00001517          	auipc	a0,0x1
ffffffffc0200ec2:	15250513          	addi	a0,a0,338 # ffffffffc0202010 <commands+0x690>
ffffffffc0200ec6:	a74ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 == p0 + 256);
ffffffffc0200eca:	00001697          	auipc	a3,0x1
ffffffffc0200ece:	2ee68693          	addi	a3,a3,750 # ffffffffc02021b8 <commands+0x838>
ffffffffc0200ed2:	00001617          	auipc	a2,0x1
ffffffffc0200ed6:	12660613          	addi	a2,a2,294 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200eda:	0ba00593          	li	a1,186
ffffffffc0200ede:	00001517          	auipc	a0,0x1
ffffffffc0200ee2:	13250513          	addi	a0,a0,306 # ffffffffc0202010 <commands+0x690>
ffffffffc0200ee6:	a54ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p3 == p0 + 8);
ffffffffc0200eea:	00001697          	auipc	a3,0x1
ffffffffc0200eee:	1e668693          	addi	a3,a3,486 # ffffffffc02020d0 <commands+0x750>
ffffffffc0200ef2:	00001617          	auipc	a2,0x1
ffffffffc0200ef6:	10660613          	addi	a2,a2,262 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0200efa:	0aa00593          	li	a1,170
ffffffffc0200efe:	00001517          	auipc	a0,0x1
ffffffffc0200f02:	11250513          	addi	a0,a0,274 # ffffffffc0202010 <commands+0x690>
ffffffffc0200f06:	a34ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200f0a <buddy_free_pages>:
buddy_free_pages(struct Page *base, size_t n) {
ffffffffc0200f0a:	1141                	addi	sp,sp,-16
ffffffffc0200f0c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200f0e:	10058563          	beqz	a1,ffffffffc0201018 <buddy_free_pages+0x10e>
    for (struct Page *p = base; p != base + n; p++) {
ffffffffc0200f12:	00259693          	slli	a3,a1,0x2
ffffffffc0200f16:	96ae                	add	a3,a3,a1
ffffffffc0200f18:	068e                	slli	a3,a3,0x3
ffffffffc0200f1a:	96aa                	add	a3,a3,a0
ffffffffc0200f1c:	87aa                	mv	a5,a0
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200f1e:	4609                	li	a2,2
ffffffffc0200f20:	02d50263          	beq	a0,a3,ffffffffc0200f44 <buddy_free_pages+0x3a>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200f24:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200f26:	8b05                	andi	a4,a4,1
ffffffffc0200f28:	eb61                	bnez	a4,ffffffffc0200ff8 <buddy_free_pages+0xee>
ffffffffc0200f2a:	6798                	ld	a4,8(a5)
ffffffffc0200f2c:	8b09                	andi	a4,a4,2
ffffffffc0200f2e:	e769                	bnez	a4,ffffffffc0200ff8 <buddy_free_pages+0xee>
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200f30:	00878713          	addi	a4,a5,8
ffffffffc0200f34:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc0200f38:	0007a023          	sw	zero,0(a5)
    for (struct Page *p = base; p != base + n; p++) {
ffffffffc0200f3c:	02878793          	addi	a5,a5,40
ffffffffc0200f40:	fed792e3          	bne	a5,a3,ffffffffc0200f24 <buddy_free_pages+0x1a>
    unsigned int index = useable_page_num + (unsigned int)(base - useable_page_base), size = 1;
ffffffffc0200f44:	00005797          	auipc	a5,0x5
ffffffffc0200f48:	5447b783          	ld	a5,1348(a5) # ffffffffc0206488 <useable_page_base>
ffffffffc0200f4c:	40f507b3          	sub	a5,a0,a5
ffffffffc0200f50:	878d                	srai	a5,a5,0x3
ffffffffc0200f52:	00001697          	auipc	a3,0x1
ffffffffc0200f56:	5466b683          	ld	a3,1350(a3) # ffffffffc0202498 <nbase+0x8>
ffffffffc0200f5a:	02d786b3          	mul	a3,a5,a3
ffffffffc0200f5e:	00005797          	auipc	a5,0x5
ffffffffc0200f62:	5327a783          	lw	a5,1330(a5) # ffffffffc0206490 <useable_page_num>
    while(buddy_page[index] > 0){
ffffffffc0200f66:	00005897          	auipc	a7,0x5
ffffffffc0200f6a:	5128b883          	ld	a7,1298(a7) # ffffffffc0206478 <buddy_page>
    unsigned int index = useable_page_num + (unsigned int)(base - useable_page_base), size = 1;
ffffffffc0200f6e:	4705                	li	a4,1
ffffffffc0200f70:	9fb5                	addw	a5,a5,a3
    while(buddy_page[index] > 0){
ffffffffc0200f72:	02079613          	slli	a2,a5,0x20
ffffffffc0200f76:	01e65693          	srli	a3,a2,0x1e
ffffffffc0200f7a:	96c6                	add	a3,a3,a7
ffffffffc0200f7c:	4290                	lw	a2,0(a3)
ffffffffc0200f7e:	ca19                	beqz	a2,ffffffffc0200f94 <buddy_free_pages+0x8a>
        index=PARENT(index);
ffffffffc0200f80:	0017d79b          	srliw	a5,a5,0x1
    while(buddy_page[index] > 0){
ffffffffc0200f84:	02079693          	slli	a3,a5,0x20
ffffffffc0200f88:	82f9                	srli	a3,a3,0x1e
ffffffffc0200f8a:	96c6                	add	a3,a3,a7
ffffffffc0200f8c:	4290                	lw	a2,0(a3)
        size <<= 1;
ffffffffc0200f8e:	0017171b          	slliw	a4,a4,0x1
    while(buddy_page[index] > 0){
ffffffffc0200f92:	f67d                	bnez	a2,ffffffffc0200f80 <buddy_free_pages+0x76>
    buddy_page[index] = size;
ffffffffc0200f94:	c298                	sw	a4,0(a3)
    while((index = PARENT(index)) > 0){
ffffffffc0200f96:	4685                	li	a3,1
ffffffffc0200f98:	0017d61b          	srliw	a2,a5,0x1
ffffffffc0200f9c:	4305                	li	t1,1
ffffffffc0200f9e:	00f6e463          	bltu	a3,a5,ffffffffc0200fa6 <buddy_free_pages+0x9c>
ffffffffc0200fa2:	a881                	j	ffffffffc0200ff2 <buddy_free_pages+0xe8>
ffffffffc0200fa4:	8636                	mv	a2,a3
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
ffffffffc0200fa6:	9bf9                	andi	a5,a5,-2
ffffffffc0200fa8:	02079693          	slli	a3,a5,0x20
ffffffffc0200fac:	2785                	addiw	a5,a5,1
ffffffffc0200fae:	02079593          	slli	a1,a5,0x20
ffffffffc0200fb2:	9281                	srli	a3,a3,0x20
ffffffffc0200fb4:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0200fb8:	068a                	slli	a3,a3,0x2
ffffffffc0200fba:	97c6                	add	a5,a5,a7
ffffffffc0200fbc:	96c6                	add	a3,a3,a7
ffffffffc0200fbe:	438c                	lw	a1,0(a5)
ffffffffc0200fc0:	4294                	lw	a3,0(a3)
        size <<= 1;
ffffffffc0200fc2:	0017151b          	slliw	a0,a4,0x1
            buddy_page[index] = size;
ffffffffc0200fc6:	02061713          	slli	a4,a2,0x20
ffffffffc0200fca:	01e75793          	srli	a5,a4,0x1e
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
ffffffffc0200fce:	00b6883b          	addw	a6,a3,a1
        size <<= 1;
ffffffffc0200fd2:	0005071b          	sext.w	a4,a0
            buddy_page[index] = size;
ffffffffc0200fd6:	97c6                	add	a5,a5,a7
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
ffffffffc0200fd8:	00e80663          	beq	a6,a4,ffffffffc0200fe4 <buddy_free_pages+0xda>
            buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
ffffffffc0200fdc:	8536                	mv	a0,a3
ffffffffc0200fde:	00b6f363          	bgeu	a3,a1,ffffffffc0200fe4 <buddy_free_pages+0xda>
ffffffffc0200fe2:	852e                	mv	a0,a1
ffffffffc0200fe4:	c388                	sw	a0,0(a5)
    while((index = PARENT(index)) > 0){
ffffffffc0200fe6:	0016569b          	srliw	a3,a2,0x1
ffffffffc0200fea:	0006079b          	sext.w	a5,a2
ffffffffc0200fee:	fac36be3          	bltu	t1,a2,ffffffffc0200fa4 <buddy_free_pages+0x9a>
}
ffffffffc0200ff2:	60a2                	ld	ra,8(sp)
ffffffffc0200ff4:	0141                	addi	sp,sp,16
ffffffffc0200ff6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ff8:	00001697          	auipc	a3,0x1
ffffffffc0200ffc:	1d068693          	addi	a3,a3,464 # ffffffffc02021c8 <commands+0x848>
ffffffffc0201000:	00001617          	auipc	a2,0x1
ffffffffc0201004:	ff860613          	addi	a2,a2,-8 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0201008:	07e00593          	li	a1,126
ffffffffc020100c:	00001517          	auipc	a0,0x1
ffffffffc0201010:	00450513          	addi	a0,a0,4 # ffffffffc0202010 <commands+0x690>
ffffffffc0201014:	926ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0201018:	00001697          	auipc	a3,0x1
ffffffffc020101c:	fd868693          	addi	a3,a3,-40 # ffffffffc0201ff0 <commands+0x670>
ffffffffc0201020:	00001617          	auipc	a2,0x1
ffffffffc0201024:	fd860613          	addi	a2,a2,-40 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0201028:	07b00593          	li	a1,123
ffffffffc020102c:	00001517          	auipc	a0,0x1
ffffffffc0201030:	fe450513          	addi	a0,a0,-28 # ffffffffc0202010 <commands+0x690>
ffffffffc0201034:	906ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201038 <buddy_init_memmap>:
    assert((n > 0));
ffffffffc0201038:	46f5                	li	a3,29
ffffffffc020103a:	4785                	li	a5,1
ffffffffc020103c:	e581                	bnez	a1,ffffffffc0201044 <buddy_init_memmap+0xc>
ffffffffc020103e:	aa25                	j	ffffffffc0201176 <buddy_init_memmap+0x13e>
    for (int i = 1; i < BUDDY_MAX_DEPTH; i++) {
ffffffffc0201040:	36fd                	addiw	a3,a3,-1
ffffffffc0201042:	ca91                	beqz	a3,ffffffffc0201056 <buddy_init_memmap+0x1e>
        useable_page_num *= 2;
ffffffffc0201044:	0017979b          	slliw	a5,a5,0x1
        if (useable_page_num + (useable_page_num / 512) >= n) {
ffffffffc0201048:	0097d71b          	srliw	a4,a5,0x9
ffffffffc020104c:	9f3d                	addw	a4,a4,a5
ffffffffc020104e:	1702                	slli	a4,a4,0x20
ffffffffc0201050:	9301                	srli	a4,a4,0x20
ffffffffc0201052:	feb767e3          	bltu	a4,a1,ffffffffc0201040 <buddy_init_memmap+0x8>
    buddy_page_num = (useable_page_num / 512) + 1;
ffffffffc0201056:	00a7d69b          	srliw	a3,a5,0xa
ffffffffc020105a:	2685                	addiw	a3,a3,1
    useable_page_base = base + buddy_page_num;
ffffffffc020105c:	02069613          	slli	a2,a3,0x20
ffffffffc0201060:	9201                	srli	a2,a2,0x20
ffffffffc0201062:	00261713          	slli	a4,a2,0x2
ffffffffc0201066:	9732                	add	a4,a4,a2
ffffffffc0201068:	070e                	slli	a4,a4,0x3
    useable_page_num /= 2;
ffffffffc020106a:	0017d79b          	srliw	a5,a5,0x1
    useable_page_base = base + buddy_page_num;
ffffffffc020106e:	972a                	add	a4,a4,a0
    useable_page_num /= 2;
ffffffffc0201070:	00005897          	auipc	a7,0x5
ffffffffc0201074:	42088893          	addi	a7,a7,1056 # ffffffffc0206490 <useable_page_num>
ffffffffc0201078:	00f8a023          	sw	a5,0(a7)
    buddy_page_num = (useable_page_num / 512) + 1;
ffffffffc020107c:	00005617          	auipc	a2,0x5
ffffffffc0201080:	40460613          	addi	a2,a2,1028 # ffffffffc0206480 <buddy_page_num>
    useable_page_base = base + buddy_page_num;
ffffffffc0201084:	00005797          	auipc	a5,0x5
ffffffffc0201088:	40e7b223          	sd	a4,1028(a5) # ffffffffc0206488 <useable_page_base>
    buddy_page_num = (useable_page_num / 512) + 1;
ffffffffc020108c:	c214                	sw	a3,0(a2)
    for (int i = 0; i != buddy_page_num; i++){
ffffffffc020108e:	00850793          	addi	a5,a0,8
ffffffffc0201092:	4701                	li	a4,0
ffffffffc0201094:	4805                	li	a6,1
ffffffffc0201096:	4107b02f          	amoor.d	zero,a6,(a5)
ffffffffc020109a:	4214                	lw	a3,0(a2)
ffffffffc020109c:	2705                	addiw	a4,a4,1
ffffffffc020109e:	02878793          	addi	a5,a5,40
ffffffffc02010a2:	fee69ae3          	bne	a3,a4,ffffffffc0201096 <buddy_init_memmap+0x5e>
    for (int i = buddy_page_num; i != n; i++){
ffffffffc02010a6:	1702                	slli	a4,a4,0x20
ffffffffc02010a8:	9301                	srli	a4,a4,0x20
ffffffffc02010aa:	02e58563          	beq	a1,a4,ffffffffc02010d4 <buddy_init_memmap+0x9c>
ffffffffc02010ae:	00271793          	slli	a5,a4,0x2
ffffffffc02010b2:	97ba                	add	a5,a5,a4
ffffffffc02010b4:	078e                	slli	a5,a5,0x3
ffffffffc02010b6:	07a1                	addi	a5,a5,8
ffffffffc02010b8:	97aa                	add	a5,a5,a0
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02010ba:	5879                	li	a6,-2
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02010bc:	4609                	li	a2,2
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02010be:	6107b02f          	amoand.d	zero,a6,(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02010c2:	40c7b02f          	amoor.d	zero,a2,(a5)
ffffffffc02010c6:	fe07ac23          	sw	zero,-8(a5)
ffffffffc02010ca:	0705                	addi	a4,a4,1
ffffffffc02010cc:	02878793          	addi	a5,a5,40
ffffffffc02010d0:	fee597e3          	bne	a1,a4,ffffffffc02010be <buddy_init_memmap+0x86>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02010d4:	00005697          	auipc	a3,0x5
ffffffffc02010d8:	37c6b683          	ld	a3,892(a3) # ffffffffc0206450 <pages>
ffffffffc02010dc:	40d506b3          	sub	a3,a0,a3
ffffffffc02010e0:	00001597          	auipc	a1,0x1
ffffffffc02010e4:	3b85b583          	ld	a1,952(a1) # ffffffffc0202498 <nbase+0x8>
ffffffffc02010e8:	868d                	srai	a3,a3,0x3
ffffffffc02010ea:	02b686b3          	mul	a3,a3,a1
ffffffffc02010ee:	00001597          	auipc	a1,0x1
ffffffffc02010f2:	3a25b583          	ld	a1,930(a1) # ffffffffc0202490 <nbase>
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
ffffffffc02010f6:	0008a783          	lw	a5,0(a7)
    buddy_page = (unsigned int*)KADDR(page2pa(base));
ffffffffc02010fa:	5775                	li	a4,-3
ffffffffc02010fc:	01e71813          	slli	a6,a4,0x1e
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
ffffffffc0201100:	0017989b          	slliw	a7,a5,0x1
ffffffffc0201104:	0007871b          	sext.w	a4,a5
ffffffffc0201108:	96ae                	add	a3,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc020110a:	00c69593          	slli	a1,a3,0xc
    buddy_page = (unsigned int*)KADDR(page2pa(base));
ffffffffc020110e:	01058533          	add	a0,a1,a6
ffffffffc0201112:	00005697          	auipc	a3,0x5
ffffffffc0201116:	36a6b323          	sd	a0,870(a3) # ffffffffc0206478 <buddy_page>
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
ffffffffc020111a:	0317f563          	bgeu	a5,a7,ffffffffc0201144 <buddy_init_memmap+0x10c>
ffffffffc020111e:	40f8863b          	subw	a2,a7,a5
ffffffffc0201122:	367d                	addiw	a2,a2,-1
ffffffffc0201124:	1602                	slli	a2,a2,0x20
ffffffffc0201126:	9201                	srli	a2,a2,0x20
ffffffffc0201128:	963a                	add	a2,a2,a4
ffffffffc020112a:	00480693          	addi	a3,a6,4
ffffffffc020112e:	070a                	slli	a4,a4,0x2
ffffffffc0201130:	060a                	slli	a2,a2,0x2
ffffffffc0201132:	9636                	add	a2,a2,a3
ffffffffc0201134:	9742                	add	a4,a4,a6
ffffffffc0201136:	972e                	add	a4,a4,a1
ffffffffc0201138:	962e                	add	a2,a2,a1
        buddy_page[i] = 1;
ffffffffc020113a:	4685                	li	a3,1
ffffffffc020113c:	c314                	sw	a3,0(a4)
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
ffffffffc020113e:	0711                	addi	a4,a4,4
ffffffffc0201140:	fee61ee3          	bne	a2,a4,ffffffffc020113c <buddy_init_memmap+0x104>
    for (int i = useable_page_num - 1; i > 0; i--){
ffffffffc0201144:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201148:	87ba                	mv	a5,a4
ffffffffc020114a:	02e05563          	blez	a4,ffffffffc0201174 <buddy_init_memmap+0x13c>
ffffffffc020114e:	00271693          	slli	a3,a4,0x2
ffffffffc0201152:	5775                	li	a4,-3
ffffffffc0201154:	077a                	slli	a4,a4,0x1e
ffffffffc0201156:	96ba                	add	a3,a3,a4
ffffffffc0201158:	0017979b          	slliw	a5,a5,0x1
ffffffffc020115c:	96ae                	add	a3,a3,a1
        buddy_page[i] = buddy_page[i << 1] << 1;
ffffffffc020115e:	00279713          	slli	a4,a5,0x2
ffffffffc0201162:	972a                	add	a4,a4,a0
ffffffffc0201164:	4318                	lw	a4,0(a4)
    for (int i = useable_page_num - 1; i > 0; i--){
ffffffffc0201166:	16f1                	addi	a3,a3,-4
ffffffffc0201168:	37f9                	addiw	a5,a5,-2
        buddy_page[i] = buddy_page[i << 1] << 1;
ffffffffc020116a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020116e:	c2d8                	sw	a4,4(a3)
    for (int i = useable_page_num - 1; i > 0; i--){
ffffffffc0201170:	f7fd                	bnez	a5,ffffffffc020115e <buddy_init_memmap+0x126>
ffffffffc0201172:	8082                	ret
ffffffffc0201174:	8082                	ret
buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc0201176:	1141                	addi	sp,sp,-16
    assert((n > 0));
ffffffffc0201178:	00001697          	auipc	a3,0x1
ffffffffc020117c:	07868693          	addi	a3,a3,120 # ffffffffc02021f0 <commands+0x870>
ffffffffc0201180:	00001617          	auipc	a2,0x1
ffffffffc0201184:	e7860613          	addi	a2,a2,-392 # ffffffffc0201ff8 <commands+0x678>
ffffffffc0201188:	02300593          	li	a1,35
ffffffffc020118c:	00001517          	auipc	a0,0x1
ffffffffc0201190:	e8450513          	addi	a0,a0,-380 # ffffffffc0202010 <commands+0x690>
buddy_init_memmap(struct Page *base, size_t n) {
ffffffffc0201194:	e406                	sd	ra,8(sp)
    assert((n > 0));
ffffffffc0201196:	fa5fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc020119a <strnlen>:
ffffffffc020119a:	4781                	li	a5,0
ffffffffc020119c:	e589                	bnez	a1,ffffffffc02011a6 <strnlen+0xc>
ffffffffc020119e:	a811                	j	ffffffffc02011b2 <strnlen+0x18>
ffffffffc02011a0:	0785                	addi	a5,a5,1
ffffffffc02011a2:	00f58863          	beq	a1,a5,ffffffffc02011b2 <strnlen+0x18>
ffffffffc02011a6:	00f50733          	add	a4,a0,a5
ffffffffc02011aa:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0x3fdf8b60>
ffffffffc02011ae:	fb6d                	bnez	a4,ffffffffc02011a0 <strnlen+0x6>
ffffffffc02011b0:	85be                	mv	a1,a5
ffffffffc02011b2:	852e                	mv	a0,a1
ffffffffc02011b4:	8082                	ret

ffffffffc02011b6 <strcmp>:
ffffffffc02011b6:	00054783          	lbu	a5,0(a0)
ffffffffc02011ba:	0005c703          	lbu	a4,0(a1)
ffffffffc02011be:	cb89                	beqz	a5,ffffffffc02011d0 <strcmp+0x1a>
ffffffffc02011c0:	0505                	addi	a0,a0,1
ffffffffc02011c2:	0585                	addi	a1,a1,1
ffffffffc02011c4:	fee789e3          	beq	a5,a4,ffffffffc02011b6 <strcmp>
ffffffffc02011c8:	0007851b          	sext.w	a0,a5
ffffffffc02011cc:	9d19                	subw	a0,a0,a4
ffffffffc02011ce:	8082                	ret
ffffffffc02011d0:	4501                	li	a0,0
ffffffffc02011d2:	bfed                	j	ffffffffc02011cc <strcmp+0x16>

ffffffffc02011d4 <strchr>:
ffffffffc02011d4:	00054783          	lbu	a5,0(a0)
ffffffffc02011d8:	c799                	beqz	a5,ffffffffc02011e6 <strchr+0x12>
ffffffffc02011da:	00f58763          	beq	a1,a5,ffffffffc02011e8 <strchr+0x14>
ffffffffc02011de:	00154783          	lbu	a5,1(a0)
ffffffffc02011e2:	0505                	addi	a0,a0,1
ffffffffc02011e4:	fbfd                	bnez	a5,ffffffffc02011da <strchr+0x6>
ffffffffc02011e6:	4501                	li	a0,0
ffffffffc02011e8:	8082                	ret

ffffffffc02011ea <memset>:
ffffffffc02011ea:	ca01                	beqz	a2,ffffffffc02011fa <memset+0x10>
ffffffffc02011ec:	962a                	add	a2,a2,a0
ffffffffc02011ee:	87aa                	mv	a5,a0
ffffffffc02011f0:	0785                	addi	a5,a5,1
ffffffffc02011f2:	feb78fa3          	sb	a1,-1(a5)
ffffffffc02011f6:	fec79de3          	bne	a5,a2,ffffffffc02011f0 <memset+0x6>
ffffffffc02011fa:	8082                	ret

ffffffffc02011fc <printnum>:
ffffffffc02011fc:	02069813          	slli	a6,a3,0x20
ffffffffc0201200:	7179                	addi	sp,sp,-48
ffffffffc0201202:	02085813          	srli	a6,a6,0x20
ffffffffc0201206:	e052                	sd	s4,0(sp)
ffffffffc0201208:	03067a33          	remu	s4,a2,a6
ffffffffc020120c:	f022                	sd	s0,32(sp)
ffffffffc020120e:	ec26                	sd	s1,24(sp)
ffffffffc0201210:	e84a                	sd	s2,16(sp)
ffffffffc0201212:	f406                	sd	ra,40(sp)
ffffffffc0201214:	e44e                	sd	s3,8(sp)
ffffffffc0201216:	84aa                	mv	s1,a0
ffffffffc0201218:	892e                	mv	s2,a1
ffffffffc020121a:	fff7041b          	addiw	s0,a4,-1
ffffffffc020121e:	2a01                	sext.w	s4,s4
ffffffffc0201220:	03067e63          	bgeu	a2,a6,ffffffffc020125c <printnum+0x60>
ffffffffc0201224:	89be                	mv	s3,a5
ffffffffc0201226:	00805763          	blez	s0,ffffffffc0201234 <printnum+0x38>
ffffffffc020122a:	347d                	addiw	s0,s0,-1
ffffffffc020122c:	85ca                	mv	a1,s2
ffffffffc020122e:	854e                	mv	a0,s3
ffffffffc0201230:	9482                	jalr	s1
ffffffffc0201232:	fc65                	bnez	s0,ffffffffc020122a <printnum+0x2e>
ffffffffc0201234:	1a02                	slli	s4,s4,0x20
ffffffffc0201236:	00001797          	auipc	a5,0x1
ffffffffc020123a:	01278793          	addi	a5,a5,18 # ffffffffc0202248 <buddy_pmm_manager+0x38>
ffffffffc020123e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201242:	9a3e                	add	s4,s4,a5
ffffffffc0201244:	7402                	ld	s0,32(sp)
ffffffffc0201246:	000a4503          	lbu	a0,0(s4)
ffffffffc020124a:	70a2                	ld	ra,40(sp)
ffffffffc020124c:	69a2                	ld	s3,8(sp)
ffffffffc020124e:	6a02                	ld	s4,0(sp)
ffffffffc0201250:	85ca                	mv	a1,s2
ffffffffc0201252:	87a6                	mv	a5,s1
ffffffffc0201254:	6942                	ld	s2,16(sp)
ffffffffc0201256:	64e2                	ld	s1,24(sp)
ffffffffc0201258:	6145                	addi	sp,sp,48
ffffffffc020125a:	8782                	jr	a5
ffffffffc020125c:	03065633          	divu	a2,a2,a6
ffffffffc0201260:	8722                	mv	a4,s0
ffffffffc0201262:	f9bff0ef          	jal	ra,ffffffffc02011fc <printnum>
ffffffffc0201266:	b7f9                	j	ffffffffc0201234 <printnum+0x38>

ffffffffc0201268 <vprintfmt>:
ffffffffc0201268:	7119                	addi	sp,sp,-128
ffffffffc020126a:	f4a6                	sd	s1,104(sp)
ffffffffc020126c:	f0ca                	sd	s2,96(sp)
ffffffffc020126e:	ecce                	sd	s3,88(sp)
ffffffffc0201270:	e8d2                	sd	s4,80(sp)
ffffffffc0201272:	e4d6                	sd	s5,72(sp)
ffffffffc0201274:	e0da                	sd	s6,64(sp)
ffffffffc0201276:	fc5e                	sd	s7,56(sp)
ffffffffc0201278:	f06a                	sd	s10,32(sp)
ffffffffc020127a:	fc86                	sd	ra,120(sp)
ffffffffc020127c:	f8a2                	sd	s0,112(sp)
ffffffffc020127e:	f862                	sd	s8,48(sp)
ffffffffc0201280:	f466                	sd	s9,40(sp)
ffffffffc0201282:	ec6e                	sd	s11,24(sp)
ffffffffc0201284:	892a                	mv	s2,a0
ffffffffc0201286:	84ae                	mv	s1,a1
ffffffffc0201288:	8d32                	mv	s10,a2
ffffffffc020128a:	8a36                	mv	s4,a3
ffffffffc020128c:	02500993          	li	s3,37
ffffffffc0201290:	5b7d                	li	s6,-1
ffffffffc0201292:	00001a97          	auipc	s5,0x1
ffffffffc0201296:	feaa8a93          	addi	s5,s5,-22 # ffffffffc020227c <buddy_pmm_manager+0x6c>
ffffffffc020129a:	00001b97          	auipc	s7,0x1
ffffffffc020129e:	1beb8b93          	addi	s7,s7,446 # ffffffffc0202458 <error_string>
ffffffffc02012a2:	000d4503          	lbu	a0,0(s10)
ffffffffc02012a6:	001d0413          	addi	s0,s10,1
ffffffffc02012aa:	01350a63          	beq	a0,s3,ffffffffc02012be <vprintfmt+0x56>
ffffffffc02012ae:	c121                	beqz	a0,ffffffffc02012ee <vprintfmt+0x86>
ffffffffc02012b0:	85a6                	mv	a1,s1
ffffffffc02012b2:	0405                	addi	s0,s0,1
ffffffffc02012b4:	9902                	jalr	s2
ffffffffc02012b6:	fff44503          	lbu	a0,-1(s0)
ffffffffc02012ba:	ff351ae3          	bne	a0,s3,ffffffffc02012ae <vprintfmt+0x46>
ffffffffc02012be:	00044603          	lbu	a2,0(s0)
ffffffffc02012c2:	02000793          	li	a5,32
ffffffffc02012c6:	4c81                	li	s9,0
ffffffffc02012c8:	4881                	li	a7,0
ffffffffc02012ca:	5c7d                	li	s8,-1
ffffffffc02012cc:	5dfd                	li	s11,-1
ffffffffc02012ce:	05500513          	li	a0,85
ffffffffc02012d2:	4825                	li	a6,9
ffffffffc02012d4:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02012d8:	0ff5f593          	zext.b	a1,a1
ffffffffc02012dc:	00140d13          	addi	s10,s0,1
ffffffffc02012e0:	04b56263          	bltu	a0,a1,ffffffffc0201324 <vprintfmt+0xbc>
ffffffffc02012e4:	058a                	slli	a1,a1,0x2
ffffffffc02012e6:	95d6                	add	a1,a1,s5
ffffffffc02012e8:	4194                	lw	a3,0(a1)
ffffffffc02012ea:	96d6                	add	a3,a3,s5
ffffffffc02012ec:	8682                	jr	a3
ffffffffc02012ee:	70e6                	ld	ra,120(sp)
ffffffffc02012f0:	7446                	ld	s0,112(sp)
ffffffffc02012f2:	74a6                	ld	s1,104(sp)
ffffffffc02012f4:	7906                	ld	s2,96(sp)
ffffffffc02012f6:	69e6                	ld	s3,88(sp)
ffffffffc02012f8:	6a46                	ld	s4,80(sp)
ffffffffc02012fa:	6aa6                	ld	s5,72(sp)
ffffffffc02012fc:	6b06                	ld	s6,64(sp)
ffffffffc02012fe:	7be2                	ld	s7,56(sp)
ffffffffc0201300:	7c42                	ld	s8,48(sp)
ffffffffc0201302:	7ca2                	ld	s9,40(sp)
ffffffffc0201304:	7d02                	ld	s10,32(sp)
ffffffffc0201306:	6de2                	ld	s11,24(sp)
ffffffffc0201308:	6109                	addi	sp,sp,128
ffffffffc020130a:	8082                	ret
ffffffffc020130c:	87b2                	mv	a5,a2
ffffffffc020130e:	00144603          	lbu	a2,1(s0)
ffffffffc0201312:	846a                	mv	s0,s10
ffffffffc0201314:	00140d13          	addi	s10,s0,1
ffffffffc0201318:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020131c:	0ff5f593          	zext.b	a1,a1
ffffffffc0201320:	fcb572e3          	bgeu	a0,a1,ffffffffc02012e4 <vprintfmt+0x7c>
ffffffffc0201324:	85a6                	mv	a1,s1
ffffffffc0201326:	02500513          	li	a0,37
ffffffffc020132a:	9902                	jalr	s2
ffffffffc020132c:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201330:	8d22                	mv	s10,s0
ffffffffc0201332:	f73788e3          	beq	a5,s3,ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc0201336:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020133a:	1d7d                	addi	s10,s10,-1
ffffffffc020133c:	ff379de3          	bne	a5,s3,ffffffffc0201336 <vprintfmt+0xce>
ffffffffc0201340:	b78d                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc0201342:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0201346:	00144603          	lbu	a2,1(s0)
ffffffffc020134a:	846a                	mv	s0,s10
ffffffffc020134c:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201350:	0006059b          	sext.w	a1,a2
ffffffffc0201354:	02d86463          	bltu	a6,a3,ffffffffc020137c <vprintfmt+0x114>
ffffffffc0201358:	00144603          	lbu	a2,1(s0)
ffffffffc020135c:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201360:	0186873b          	addw	a4,a3,s8
ffffffffc0201364:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201368:	9f2d                	addw	a4,a4,a1
ffffffffc020136a:	fd06069b          	addiw	a3,a2,-48
ffffffffc020136e:	0405                	addi	s0,s0,1
ffffffffc0201370:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0201374:	0006059b          	sext.w	a1,a2
ffffffffc0201378:	fed870e3          	bgeu	a6,a3,ffffffffc0201358 <vprintfmt+0xf0>
ffffffffc020137c:	f40ddce3          	bgez	s11,ffffffffc02012d4 <vprintfmt+0x6c>
ffffffffc0201380:	8de2                	mv	s11,s8
ffffffffc0201382:	5c7d                	li	s8,-1
ffffffffc0201384:	bf81                	j	ffffffffc02012d4 <vprintfmt+0x6c>
ffffffffc0201386:	fffdc693          	not	a3,s11
ffffffffc020138a:	96fd                	srai	a3,a3,0x3f
ffffffffc020138c:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201390:	00144603          	lbu	a2,1(s0)
ffffffffc0201394:	2d81                	sext.w	s11,s11
ffffffffc0201396:	846a                	mv	s0,s10
ffffffffc0201398:	bf35                	j	ffffffffc02012d4 <vprintfmt+0x6c>
ffffffffc020139a:	000a2c03          	lw	s8,0(s4)
ffffffffc020139e:	00144603          	lbu	a2,1(s0)
ffffffffc02013a2:	0a21                	addi	s4,s4,8
ffffffffc02013a4:	846a                	mv	s0,s10
ffffffffc02013a6:	bfd9                	j	ffffffffc020137c <vprintfmt+0x114>
ffffffffc02013a8:	4705                	li	a4,1
ffffffffc02013aa:	008a0593          	addi	a1,s4,8
ffffffffc02013ae:	01174463          	blt	a4,a7,ffffffffc02013b6 <vprintfmt+0x14e>
ffffffffc02013b2:	1a088e63          	beqz	a7,ffffffffc020156e <vprintfmt+0x306>
ffffffffc02013b6:	000a3603          	ld	a2,0(s4)
ffffffffc02013ba:	46c1                	li	a3,16
ffffffffc02013bc:	8a2e                	mv	s4,a1
ffffffffc02013be:	2781                	sext.w	a5,a5
ffffffffc02013c0:	876e                	mv	a4,s11
ffffffffc02013c2:	85a6                	mv	a1,s1
ffffffffc02013c4:	854a                	mv	a0,s2
ffffffffc02013c6:	e37ff0ef          	jal	ra,ffffffffc02011fc <printnum>
ffffffffc02013ca:	bde1                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc02013cc:	000a2503          	lw	a0,0(s4)
ffffffffc02013d0:	85a6                	mv	a1,s1
ffffffffc02013d2:	0a21                	addi	s4,s4,8
ffffffffc02013d4:	9902                	jalr	s2
ffffffffc02013d6:	b5f1                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc02013d8:	4705                	li	a4,1
ffffffffc02013da:	008a0593          	addi	a1,s4,8
ffffffffc02013de:	01174463          	blt	a4,a7,ffffffffc02013e6 <vprintfmt+0x17e>
ffffffffc02013e2:	18088163          	beqz	a7,ffffffffc0201564 <vprintfmt+0x2fc>
ffffffffc02013e6:	000a3603          	ld	a2,0(s4)
ffffffffc02013ea:	46a9                	li	a3,10
ffffffffc02013ec:	8a2e                	mv	s4,a1
ffffffffc02013ee:	bfc1                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc02013f0:	00144603          	lbu	a2,1(s0)
ffffffffc02013f4:	4c85                	li	s9,1
ffffffffc02013f6:	846a                	mv	s0,s10
ffffffffc02013f8:	bdf1                	j	ffffffffc02012d4 <vprintfmt+0x6c>
ffffffffc02013fa:	85a6                	mv	a1,s1
ffffffffc02013fc:	02500513          	li	a0,37
ffffffffc0201400:	9902                	jalr	s2
ffffffffc0201402:	b545                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc0201404:	00144603          	lbu	a2,1(s0)
ffffffffc0201408:	2885                	addiw	a7,a7,1
ffffffffc020140a:	846a                	mv	s0,s10
ffffffffc020140c:	b5e1                	j	ffffffffc02012d4 <vprintfmt+0x6c>
ffffffffc020140e:	4705                	li	a4,1
ffffffffc0201410:	008a0593          	addi	a1,s4,8
ffffffffc0201414:	01174463          	blt	a4,a7,ffffffffc020141c <vprintfmt+0x1b4>
ffffffffc0201418:	14088163          	beqz	a7,ffffffffc020155a <vprintfmt+0x2f2>
ffffffffc020141c:	000a3603          	ld	a2,0(s4)
ffffffffc0201420:	46a1                	li	a3,8
ffffffffc0201422:	8a2e                	mv	s4,a1
ffffffffc0201424:	bf69                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc0201426:	03000513          	li	a0,48
ffffffffc020142a:	85a6                	mv	a1,s1
ffffffffc020142c:	e03e                	sd	a5,0(sp)
ffffffffc020142e:	9902                	jalr	s2
ffffffffc0201430:	85a6                	mv	a1,s1
ffffffffc0201432:	07800513          	li	a0,120
ffffffffc0201436:	9902                	jalr	s2
ffffffffc0201438:	0a21                	addi	s4,s4,8
ffffffffc020143a:	6782                	ld	a5,0(sp)
ffffffffc020143c:	46c1                	li	a3,16
ffffffffc020143e:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201442:	bfb5                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc0201444:	000a3403          	ld	s0,0(s4)
ffffffffc0201448:	008a0713          	addi	a4,s4,8
ffffffffc020144c:	e03a                	sd	a4,0(sp)
ffffffffc020144e:	14040263          	beqz	s0,ffffffffc0201592 <vprintfmt+0x32a>
ffffffffc0201452:	0fb05763          	blez	s11,ffffffffc0201540 <vprintfmt+0x2d8>
ffffffffc0201456:	02d00693          	li	a3,45
ffffffffc020145a:	0cd79163          	bne	a5,a3,ffffffffc020151c <vprintfmt+0x2b4>
ffffffffc020145e:	00044783          	lbu	a5,0(s0)
ffffffffc0201462:	0007851b          	sext.w	a0,a5
ffffffffc0201466:	cf85                	beqz	a5,ffffffffc020149e <vprintfmt+0x236>
ffffffffc0201468:	00140a13          	addi	s4,s0,1
ffffffffc020146c:	05e00413          	li	s0,94
ffffffffc0201470:	000c4563          	bltz	s8,ffffffffc020147a <vprintfmt+0x212>
ffffffffc0201474:	3c7d                	addiw	s8,s8,-1
ffffffffc0201476:	036c0263          	beq	s8,s6,ffffffffc020149a <vprintfmt+0x232>
ffffffffc020147a:	85a6                	mv	a1,s1
ffffffffc020147c:	0e0c8e63          	beqz	s9,ffffffffc0201578 <vprintfmt+0x310>
ffffffffc0201480:	3781                	addiw	a5,a5,-32
ffffffffc0201482:	0ef47b63          	bgeu	s0,a5,ffffffffc0201578 <vprintfmt+0x310>
ffffffffc0201486:	03f00513          	li	a0,63
ffffffffc020148a:	9902                	jalr	s2
ffffffffc020148c:	000a4783          	lbu	a5,0(s4)
ffffffffc0201490:	3dfd                	addiw	s11,s11,-1
ffffffffc0201492:	0a05                	addi	s4,s4,1
ffffffffc0201494:	0007851b          	sext.w	a0,a5
ffffffffc0201498:	ffe1                	bnez	a5,ffffffffc0201470 <vprintfmt+0x208>
ffffffffc020149a:	01b05963          	blez	s11,ffffffffc02014ac <vprintfmt+0x244>
ffffffffc020149e:	3dfd                	addiw	s11,s11,-1
ffffffffc02014a0:	85a6                	mv	a1,s1
ffffffffc02014a2:	02000513          	li	a0,32
ffffffffc02014a6:	9902                	jalr	s2
ffffffffc02014a8:	fe0d9be3          	bnez	s11,ffffffffc020149e <vprintfmt+0x236>
ffffffffc02014ac:	6a02                	ld	s4,0(sp)
ffffffffc02014ae:	bbd5                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc02014b0:	4705                	li	a4,1
ffffffffc02014b2:	008a0c93          	addi	s9,s4,8
ffffffffc02014b6:	01174463          	blt	a4,a7,ffffffffc02014be <vprintfmt+0x256>
ffffffffc02014ba:	08088d63          	beqz	a7,ffffffffc0201554 <vprintfmt+0x2ec>
ffffffffc02014be:	000a3403          	ld	s0,0(s4)
ffffffffc02014c2:	0a044d63          	bltz	s0,ffffffffc020157c <vprintfmt+0x314>
ffffffffc02014c6:	8622                	mv	a2,s0
ffffffffc02014c8:	8a66                	mv	s4,s9
ffffffffc02014ca:	46a9                	li	a3,10
ffffffffc02014cc:	bdcd                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc02014ce:	000a2783          	lw	a5,0(s4)
ffffffffc02014d2:	4719                	li	a4,6
ffffffffc02014d4:	0a21                	addi	s4,s4,8
ffffffffc02014d6:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02014da:	8fb5                	xor	a5,a5,a3
ffffffffc02014dc:	40d786bb          	subw	a3,a5,a3
ffffffffc02014e0:	02d74163          	blt	a4,a3,ffffffffc0201502 <vprintfmt+0x29a>
ffffffffc02014e4:	00369793          	slli	a5,a3,0x3
ffffffffc02014e8:	97de                	add	a5,a5,s7
ffffffffc02014ea:	639c                	ld	a5,0(a5)
ffffffffc02014ec:	cb99                	beqz	a5,ffffffffc0201502 <vprintfmt+0x29a>
ffffffffc02014ee:	86be                	mv	a3,a5
ffffffffc02014f0:	00001617          	auipc	a2,0x1
ffffffffc02014f4:	d8860613          	addi	a2,a2,-632 # ffffffffc0202278 <buddy_pmm_manager+0x68>
ffffffffc02014f8:	85a6                	mv	a1,s1
ffffffffc02014fa:	854a                	mv	a0,s2
ffffffffc02014fc:	0ce000ef          	jal	ra,ffffffffc02015ca <printfmt>
ffffffffc0201500:	b34d                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc0201502:	00001617          	auipc	a2,0x1
ffffffffc0201506:	d6660613          	addi	a2,a2,-666 # ffffffffc0202268 <buddy_pmm_manager+0x58>
ffffffffc020150a:	85a6                	mv	a1,s1
ffffffffc020150c:	854a                	mv	a0,s2
ffffffffc020150e:	0bc000ef          	jal	ra,ffffffffc02015ca <printfmt>
ffffffffc0201512:	bb41                	j	ffffffffc02012a2 <vprintfmt+0x3a>
ffffffffc0201514:	00001417          	auipc	s0,0x1
ffffffffc0201518:	d4c40413          	addi	s0,s0,-692 # ffffffffc0202260 <buddy_pmm_manager+0x50>
ffffffffc020151c:	85e2                	mv	a1,s8
ffffffffc020151e:	8522                	mv	a0,s0
ffffffffc0201520:	e43e                	sd	a5,8(sp)
ffffffffc0201522:	c79ff0ef          	jal	ra,ffffffffc020119a <strnlen>
ffffffffc0201526:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020152a:	01b05b63          	blez	s11,ffffffffc0201540 <vprintfmt+0x2d8>
ffffffffc020152e:	67a2                	ld	a5,8(sp)
ffffffffc0201530:	00078a1b          	sext.w	s4,a5
ffffffffc0201534:	3dfd                	addiw	s11,s11,-1
ffffffffc0201536:	85a6                	mv	a1,s1
ffffffffc0201538:	8552                	mv	a0,s4
ffffffffc020153a:	9902                	jalr	s2
ffffffffc020153c:	fe0d9ce3          	bnez	s11,ffffffffc0201534 <vprintfmt+0x2cc>
ffffffffc0201540:	00044783          	lbu	a5,0(s0)
ffffffffc0201544:	00140a13          	addi	s4,s0,1
ffffffffc0201548:	0007851b          	sext.w	a0,a5
ffffffffc020154c:	d3a5                	beqz	a5,ffffffffc02014ac <vprintfmt+0x244>
ffffffffc020154e:	05e00413          	li	s0,94
ffffffffc0201552:	bf39                	j	ffffffffc0201470 <vprintfmt+0x208>
ffffffffc0201554:	000a2403          	lw	s0,0(s4)
ffffffffc0201558:	b7ad                	j	ffffffffc02014c2 <vprintfmt+0x25a>
ffffffffc020155a:	000a6603          	lwu	a2,0(s4)
ffffffffc020155e:	46a1                	li	a3,8
ffffffffc0201560:	8a2e                	mv	s4,a1
ffffffffc0201562:	bdb1                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc0201564:	000a6603          	lwu	a2,0(s4)
ffffffffc0201568:	46a9                	li	a3,10
ffffffffc020156a:	8a2e                	mv	s4,a1
ffffffffc020156c:	bd89                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc020156e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201572:	46c1                	li	a3,16
ffffffffc0201574:	8a2e                	mv	s4,a1
ffffffffc0201576:	b5a1                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc0201578:	9902                	jalr	s2
ffffffffc020157a:	bf09                	j	ffffffffc020148c <vprintfmt+0x224>
ffffffffc020157c:	85a6                	mv	a1,s1
ffffffffc020157e:	02d00513          	li	a0,45
ffffffffc0201582:	e03e                	sd	a5,0(sp)
ffffffffc0201584:	9902                	jalr	s2
ffffffffc0201586:	6782                	ld	a5,0(sp)
ffffffffc0201588:	8a66                	mv	s4,s9
ffffffffc020158a:	40800633          	neg	a2,s0
ffffffffc020158e:	46a9                	li	a3,10
ffffffffc0201590:	b53d                	j	ffffffffc02013be <vprintfmt+0x156>
ffffffffc0201592:	03b05163          	blez	s11,ffffffffc02015b4 <vprintfmt+0x34c>
ffffffffc0201596:	02d00693          	li	a3,45
ffffffffc020159a:	f6d79de3          	bne	a5,a3,ffffffffc0201514 <vprintfmt+0x2ac>
ffffffffc020159e:	00001417          	auipc	s0,0x1
ffffffffc02015a2:	cc240413          	addi	s0,s0,-830 # ffffffffc0202260 <buddy_pmm_manager+0x50>
ffffffffc02015a6:	02800793          	li	a5,40
ffffffffc02015aa:	02800513          	li	a0,40
ffffffffc02015ae:	00140a13          	addi	s4,s0,1
ffffffffc02015b2:	bd6d                	j	ffffffffc020146c <vprintfmt+0x204>
ffffffffc02015b4:	00001a17          	auipc	s4,0x1
ffffffffc02015b8:	cada0a13          	addi	s4,s4,-851 # ffffffffc0202261 <buddy_pmm_manager+0x51>
ffffffffc02015bc:	02800513          	li	a0,40
ffffffffc02015c0:	02800793          	li	a5,40
ffffffffc02015c4:	05e00413          	li	s0,94
ffffffffc02015c8:	b565                	j	ffffffffc0201470 <vprintfmt+0x208>

ffffffffc02015ca <printfmt>:
ffffffffc02015ca:	715d                	addi	sp,sp,-80
ffffffffc02015cc:	02810313          	addi	t1,sp,40
ffffffffc02015d0:	f436                	sd	a3,40(sp)
ffffffffc02015d2:	869a                	mv	a3,t1
ffffffffc02015d4:	ec06                	sd	ra,24(sp)
ffffffffc02015d6:	f83a                	sd	a4,48(sp)
ffffffffc02015d8:	fc3e                	sd	a5,56(sp)
ffffffffc02015da:	e0c2                	sd	a6,64(sp)
ffffffffc02015dc:	e4c6                	sd	a7,72(sp)
ffffffffc02015de:	e41a                	sd	t1,8(sp)
ffffffffc02015e0:	c89ff0ef          	jal	ra,ffffffffc0201268 <vprintfmt>
ffffffffc02015e4:	60e2                	ld	ra,24(sp)
ffffffffc02015e6:	6161                	addi	sp,sp,80
ffffffffc02015e8:	8082                	ret

ffffffffc02015ea <readline>:
ffffffffc02015ea:	715d                	addi	sp,sp,-80
ffffffffc02015ec:	e486                	sd	ra,72(sp)
ffffffffc02015ee:	e0a6                	sd	s1,64(sp)
ffffffffc02015f0:	fc4a                	sd	s2,56(sp)
ffffffffc02015f2:	f84e                	sd	s3,48(sp)
ffffffffc02015f4:	f452                	sd	s4,40(sp)
ffffffffc02015f6:	f056                	sd	s5,32(sp)
ffffffffc02015f8:	ec5a                	sd	s6,24(sp)
ffffffffc02015fa:	e85e                	sd	s7,16(sp)
ffffffffc02015fc:	c901                	beqz	a0,ffffffffc020160c <readline+0x22>
ffffffffc02015fe:	85aa                	mv	a1,a0
ffffffffc0201600:	00001517          	auipc	a0,0x1
ffffffffc0201604:	c7850513          	addi	a0,a0,-904 # ffffffffc0202278 <buddy_pmm_manager+0x68>
ffffffffc0201608:	aabfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020160c:	4481                	li	s1,0
ffffffffc020160e:	497d                	li	s2,31
ffffffffc0201610:	49a1                	li	s3,8
ffffffffc0201612:	4aa9                	li	s5,10
ffffffffc0201614:	4b35                	li	s6,13
ffffffffc0201616:	00005b97          	auipc	s7,0x5
ffffffffc020161a:	a1ab8b93          	addi	s7,s7,-1510 # ffffffffc0206030 <buf>
ffffffffc020161e:	3fe00a13          	li	s4,1022
ffffffffc0201622:	b09fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201626:	00054a63          	bltz	a0,ffffffffc020163a <readline+0x50>
ffffffffc020162a:	00a95a63          	bge	s2,a0,ffffffffc020163e <readline+0x54>
ffffffffc020162e:	029a5263          	bge	s4,s1,ffffffffc0201652 <readline+0x68>
ffffffffc0201632:	af9fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201636:	fe055ae3          	bgez	a0,ffffffffc020162a <readline+0x40>
ffffffffc020163a:	4501                	li	a0,0
ffffffffc020163c:	a091                	j	ffffffffc0201680 <readline+0x96>
ffffffffc020163e:	03351463          	bne	a0,s3,ffffffffc0201666 <readline+0x7c>
ffffffffc0201642:	e8a9                	bnez	s1,ffffffffc0201694 <readline+0xaa>
ffffffffc0201644:	ae7fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201648:	fe0549e3          	bltz	a0,ffffffffc020163a <readline+0x50>
ffffffffc020164c:	fea959e3          	bge	s2,a0,ffffffffc020163e <readline+0x54>
ffffffffc0201650:	4481                	li	s1,0
ffffffffc0201652:	e42a                	sd	a0,8(sp)
ffffffffc0201654:	a95fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201658:	6522                	ld	a0,8(sp)
ffffffffc020165a:	009b87b3          	add	a5,s7,s1
ffffffffc020165e:	2485                	addiw	s1,s1,1
ffffffffc0201660:	00a78023          	sb	a0,0(a5)
ffffffffc0201664:	bf7d                	j	ffffffffc0201622 <readline+0x38>
ffffffffc0201666:	01550463          	beq	a0,s5,ffffffffc020166e <readline+0x84>
ffffffffc020166a:	fb651ce3          	bne	a0,s6,ffffffffc0201622 <readline+0x38>
ffffffffc020166e:	a7bfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201672:	00005517          	auipc	a0,0x5
ffffffffc0201676:	9be50513          	addi	a0,a0,-1602 # ffffffffc0206030 <buf>
ffffffffc020167a:	94aa                	add	s1,s1,a0
ffffffffc020167c:	00048023          	sb	zero,0(s1)
ffffffffc0201680:	60a6                	ld	ra,72(sp)
ffffffffc0201682:	6486                	ld	s1,64(sp)
ffffffffc0201684:	7962                	ld	s2,56(sp)
ffffffffc0201686:	79c2                	ld	s3,48(sp)
ffffffffc0201688:	7a22                	ld	s4,40(sp)
ffffffffc020168a:	7a82                	ld	s5,32(sp)
ffffffffc020168c:	6b62                	ld	s6,24(sp)
ffffffffc020168e:	6bc2                	ld	s7,16(sp)
ffffffffc0201690:	6161                	addi	sp,sp,80
ffffffffc0201692:	8082                	ret
ffffffffc0201694:	4521                	li	a0,8
ffffffffc0201696:	a53fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc020169a:	34fd                	addiw	s1,s1,-1
ffffffffc020169c:	b759                	j	ffffffffc0201622 <readline+0x38>

ffffffffc020169e <sbi_console_putchar>:
ffffffffc020169e:	4781                	li	a5,0
ffffffffc02016a0:	00005717          	auipc	a4,0x5
ffffffffc02016a4:	96873703          	ld	a4,-1688(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc02016a8:	88ba                	mv	a7,a4
ffffffffc02016aa:	852a                	mv	a0,a0
ffffffffc02016ac:	85be                	mv	a1,a5
ffffffffc02016ae:	863e                	mv	a2,a5
ffffffffc02016b0:	00000073          	ecall
ffffffffc02016b4:	87aa                	mv	a5,a0
ffffffffc02016b6:	8082                	ret

ffffffffc02016b8 <sbi_set_timer>:
ffffffffc02016b8:	4781                	li	a5,0
ffffffffc02016ba:	00005717          	auipc	a4,0x5
ffffffffc02016be:	dde73703          	ld	a4,-546(a4) # ffffffffc0206498 <SBI_SET_TIMER>
ffffffffc02016c2:	88ba                	mv	a7,a4
ffffffffc02016c4:	852a                	mv	a0,a0
ffffffffc02016c6:	85be                	mv	a1,a5
ffffffffc02016c8:	863e                	mv	a2,a5
ffffffffc02016ca:	00000073          	ecall
ffffffffc02016ce:	87aa                	mv	a5,a0
ffffffffc02016d0:	8082                	ret

ffffffffc02016d2 <sbi_console_getchar>:
ffffffffc02016d2:	4501                	li	a0,0
ffffffffc02016d4:	00005797          	auipc	a5,0x5
ffffffffc02016d8:	92c7b783          	ld	a5,-1748(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc02016dc:	88be                	mv	a7,a5
ffffffffc02016de:	852a                	mv	a0,a0
ffffffffc02016e0:	85aa                	mv	a1,a0
ffffffffc02016e2:	862a                	mv	a2,a0
ffffffffc02016e4:	00000073          	ecall
ffffffffc02016e8:	852a                	mv	a0,a0
ffffffffc02016ea:	2501                	sext.w	a0,a0
ffffffffc02016ec:	8082                	ret

ffffffffc02016ee <sbi_shutdown>:
ffffffffc02016ee:	4781                	li	a5,0
ffffffffc02016f0:	00005717          	auipc	a4,0x5
ffffffffc02016f4:	92073703          	ld	a4,-1760(a4) # ffffffffc0206010 <SBI_SHUTDOWN>
ffffffffc02016f8:	88ba                	mv	a7,a4
ffffffffc02016fa:	853e                	mv	a0,a5
ffffffffc02016fc:	85be                	mv	a1,a5
ffffffffc02016fe:	863e                	mv	a2,a5
ffffffffc0201700:	00000073          	ecall
ffffffffc0201704:	87aa                	mv	a5,a0
ffffffffc0201706:	8082                	ret
