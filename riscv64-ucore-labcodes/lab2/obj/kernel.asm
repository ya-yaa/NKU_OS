
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
ffffffffc020003e:	44660613          	addi	a2,a2,1094 # ffffffffc0206480 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	50a010ef          	jal	ra,ffffffffc0201554 <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	a2650513          	addi	a0,a0,-1498 # ffffffffc0201a78 <etext+0x6>
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
ffffffffc02000a6:	52c010ef          	jal	ra,ffffffffc02015d2 <vprintfmt>
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
ffffffffc02000dc:	4f6010ef          	jal	ra,ffffffffc02015d2 <vprintfmt>
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
ffffffffc0200168:	00002517          	auipc	a0,0x2
ffffffffc020016c:	93050513          	addi	a0,a0,-1744 # ffffffffc0201a98 <etext+0x26>
ffffffffc0200170:	e43e                	sd	a5,8(sp)
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	a0250513          	addi	a0,a0,-1534 # ffffffffc0201b80 <etext+0x10e>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
ffffffffc0200196:	1141                	addi	sp,sp,-16
ffffffffc0200198:	00002517          	auipc	a0,0x2
ffffffffc020019c:	92050513          	addi	a0,a0,-1760 # ffffffffc0201ab8 <etext+0x46>
ffffffffc02001a0:	e406                	sd	ra,8(sp)
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00002517          	auipc	a0,0x2
ffffffffc02001b2:	92a50513          	addi	a0,a0,-1750 # ffffffffc0201ad8 <etext+0x66>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ba:	00002597          	auipc	a1,0x2
ffffffffc02001be:	8b858593          	addi	a1,a1,-1864 # ffffffffc0201a72 <etext>
ffffffffc02001c2:	00002517          	auipc	a0,0x2
ffffffffc02001c6:	93650513          	addi	a0,a0,-1738 # ffffffffc0201af8 <etext+0x86>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4a58593          	addi	a1,a1,-438 # ffffffffc0206018 <free_area>
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	94250513          	addi	a0,a0,-1726 # ffffffffc0201b18 <etext+0xa6>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	29e58593          	addi	a1,a1,670 # ffffffffc0206480 <end>
ffffffffc02001ea:	00002517          	auipc	a0,0x2
ffffffffc02001ee:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201b38 <etext+0xc6>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	68958593          	addi	a1,a1,1673 # ffffffffc020687f <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020020e:	60a2                	ld	ra,8(sp)
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00002517          	auipc	a0,0x2
ffffffffc020021c:	94050513          	addi	a0,a0,-1728 # ffffffffc0201b58 <etext+0xe6>
ffffffffc0200220:	0141                	addi	sp,sp,16
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00002617          	auipc	a2,0x2
ffffffffc020022a:	96260613          	addi	a2,a2,-1694 # ffffffffc0201b88 <etext+0x116>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00002517          	auipc	a0,0x2
ffffffffc0200236:	96e50513          	addi	a0,a0,-1682 # ffffffffc0201ba0 <etext+0x12e>
ffffffffc020023a:	e406                	sd	ra,8(sp)
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
ffffffffc0200240:	1141                	addi	sp,sp,-16
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	97660613          	addi	a2,a2,-1674 # ffffffffc0201bb8 <etext+0x146>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	98e58593          	addi	a1,a1,-1650 # ffffffffc0201bd8 <etext+0x166>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	98e50513          	addi	a0,a0,-1650 # ffffffffc0201be0 <etext+0x16e>
ffffffffc020025a:	e406                	sd	ra,8(sp)
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	99060613          	addi	a2,a2,-1648 # ffffffffc0201bf0 <etext+0x17e>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	9b058593          	addi	a1,a1,-1616 # ffffffffc0201c18 <etext+0x1a6>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	97050513          	addi	a0,a0,-1680 # ffffffffc0201be0 <etext+0x16e>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00002617          	auipc	a2,0x2
ffffffffc0200280:	9ac60613          	addi	a2,a2,-1620 # ffffffffc0201c28 <etext+0x1b6>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	9c458593          	addi	a1,a1,-1596 # ffffffffc0201c48 <etext+0x1d6>
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	95450513          	addi	a0,a0,-1708 # ffffffffc0201be0 <etext+0x16e>
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
ffffffffc02002c6:	00002517          	auipc	a0,0x2
ffffffffc02002ca:	99250513          	addi	a0,a0,-1646 # ffffffffc0201c58 <etext+0x1e6>
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
ffffffffc02002e8:	00002517          	auipc	a0,0x2
ffffffffc02002ec:	99850513          	addi	a0,a0,-1640 # ffffffffc0201c80 <etext+0x20e>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	9f2c0c13          	addi	s8,s8,-1550 # ffffffffc0201cf0 <commands>
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	9a290913          	addi	s2,s2,-1630 # ffffffffc0201ca8 <etext+0x236>
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	9a248493          	addi	s1,s1,-1630 # ffffffffc0201cb0 <etext+0x23e>
ffffffffc0200316:	49bd                	li	s3,15
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	9a0b0b13          	addi	s6,s6,-1632 # ffffffffc0201cb8 <etext+0x246>
ffffffffc0200320:	00002a17          	auipc	s4,0x2
ffffffffc0200324:	8b8a0a13          	addi	s4,s4,-1864 # ffffffffc0201bd8 <etext+0x166>
ffffffffc0200328:	4a8d                	li	s5,3
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	628010ef          	jal	ra,ffffffffc0201954 <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
ffffffffc0200338:	4c81                	li	s9,0
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	9aed0d13          	addi	s10,s10,-1618 # ffffffffc0201cf0 <commands>
ffffffffc020034a:	8552                	mv	a0,s4
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
ffffffffc0200350:	1d0010ef          	jal	ra,ffffffffc0201520 <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
ffffffffc0200362:	0d61                	addi	s10,s10,24
ffffffffc0200364:	1bc010ef          	jal	ra,ffffffffc0201520 <strcmp>
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
ffffffffc02003a2:	19c010ef          	jal	ra,ffffffffc020153e <strchr>
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
ffffffffc02003e0:	15e010ef          	jal	ra,ffffffffc020153e <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00002517          	auipc	a0,0x2
ffffffffc02003fe:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201cd8 <etext+0x266>
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
ffffffffc0200420:	602010ef          	jal	ra,ffffffffc0201a22 <sbi_set_timer>
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b923          	sd	zero,18(a5) # ffffffffc0206438 <ticks>
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201d38 <commands+0x48>
ffffffffc0200436:	0141                	addi	sp,sp,16
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
ffffffffc020043a:	c0102573          	rdtime	a0
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	5dc0106f          	j	ffffffffc0201a22 <sbi_set_timer>

ffffffffc020044a <cons_init>:
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	5b80106f          	j	ffffffffc0201a08 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	5e80106f          	j	ffffffffc0201a3c <sbi_console_getchar>

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
ffffffffc020047e:	00002517          	auipc	a0,0x2
ffffffffc0200482:	8da50513          	addi	a0,a0,-1830 # ffffffffc0201d58 <commands+0x68>
ffffffffc0200486:	e406                	sd	ra,8(sp)
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00002517          	auipc	a0,0x2
ffffffffc0200492:	8e250513          	addi	a0,a0,-1822 # ffffffffc0201d70 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0201d88 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	8f650513          	addi	a0,a0,-1802 # ffffffffc0201da0 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	90050513          	addi	a0,a0,-1792 # ffffffffc0201db8 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201dd0 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	91450513          	addi	a0,a0,-1772 # ffffffffc0201de8 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	91e50513          	addi	a0,a0,-1762 # ffffffffc0201e00 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	92850513          	addi	a0,a0,-1752 # ffffffffc0201e18 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	93250513          	addi	a0,a0,-1742 # ffffffffc0201e30 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	93c50513          	addi	a0,a0,-1732 # ffffffffc0201e48 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	94650513          	addi	a0,a0,-1722 # ffffffffc0201e60 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	95050513          	addi	a0,a0,-1712 # ffffffffc0201e78 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	95a50513          	addi	a0,a0,-1702 # ffffffffc0201e90 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	96450513          	addi	a0,a0,-1692 # ffffffffc0201ea8 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	96e50513          	addi	a0,a0,-1682 # ffffffffc0201ec0 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	97850513          	addi	a0,a0,-1672 # ffffffffc0201ed8 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	98250513          	addi	a0,a0,-1662 # ffffffffc0201ef0 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	98c50513          	addi	a0,a0,-1652 # ffffffffc0201f08 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	99650513          	addi	a0,a0,-1642 # ffffffffc0201f20 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	9a050513          	addi	a0,a0,-1632 # ffffffffc0201f38 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201f50 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	9b450513          	addi	a0,a0,-1612 # ffffffffc0201f68 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	9be50513          	addi	a0,a0,-1602 # ffffffffc0201f80 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	9c850513          	addi	a0,a0,-1592 # ffffffffc0201f98 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	9d250513          	addi	a0,a0,-1582 # ffffffffc0201fb0 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0201fc8 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	9e650513          	addi	a0,a0,-1562 # ffffffffc0201fe0 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	9f050513          	addi	a0,a0,-1552 # ffffffffc0201ff8 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0202010 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	a0450513          	addi	a0,a0,-1532 # ffffffffc0202028 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0202040 <commands+0x350>
ffffffffc020063e:	0141                	addi	sp,sp,16
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
ffffffffc0200646:	85aa                	mv	a1,a0
ffffffffc0200648:	842a                	mv	s0,a0
ffffffffc020064a:	00002517          	auipc	a0,0x2
ffffffffc020064e:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0202058 <commands+0x368>
ffffffffc0200652:	e406                	sd	ra,8(sp)
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
ffffffffc0200666:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0202070 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	a1650513          	addi	a0,a0,-1514 # ffffffffc0202088 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	a1e50513          	addi	a0,a0,-1506 # ffffffffc02020a0 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020068e:	11843583          	ld	a1,280(s0)
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	a2250513          	addi	a0,a0,-1502 # ffffffffc02020b8 <commands+0x3c8>
ffffffffc020069e:	0141                	addi	sp,sp,16
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	08f76663          	bltu	a4,a5,ffffffffc0200738 <interrupt_handler+0x96>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
ffffffffc02006b4:	ae870713          	addi	a4,a4,-1304 # ffffffffc0202198 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
ffffffffc02006c2:	00002517          	auipc	a0,0x2
ffffffffc02006c6:	a6e50513          	addi	a0,a0,-1426 # ffffffffc0202130 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	a4450513          	addi	a0,a0,-1468 # ffffffffc0202110 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	9fa50513          	addi	a0,a0,-1542 # ffffffffc02020d0 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	a7050513          	addi	a0,a0,-1424 # ffffffffc0202150 <commands+0x460>
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
ffffffffc0200724:	00002517          	auipc	a0,0x2
ffffffffc0200728:	a5450513          	addi	a0,a0,-1452 # ffffffffc0202178 <commands+0x488>
ffffffffc020072c:	b259                	j	ffffffffc02000b2 <cprintf>
ffffffffc020072e:	00002517          	auipc	a0,0x2
ffffffffc0200732:	9c250513          	addi	a0,a0,-1598 # ffffffffc02020f0 <commands+0x400>
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>
ffffffffc0200738:	b729                	j	ffffffffc0200642 <print_trapframe>
ffffffffc020073a:	06400593          	li	a1,100
ffffffffc020073e:	00002517          	auipc	a0,0x2
ffffffffc0200742:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0202168 <commands+0x478>
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
ffffffffc0200760:	2f80106f          	j	ffffffffc0201a58 <sbi_shutdown>

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
ffffffffc0200780:	00002517          	auipc	a0,0x2
ffffffffc0200784:	a4850513          	addi	a0,a0,-1464 # ffffffffc02021c8 <commands+0x4d8>
ffffffffc0200788:	92bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020078c:	10843583          	ld	a1,264(s0)
ffffffffc0200790:	00002517          	auipc	a0,0x2
ffffffffc0200794:	a6050513          	addi	a0,a0,-1440 # ffffffffc02021f0 <commands+0x500>
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
ffffffffc02007be:	00002517          	auipc	a0,0x2
ffffffffc02007c2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0202218 <commands+0x528>
ffffffffc02007c6:	8edff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02007ca:	10843583          	ld	a1,264(s0)
ffffffffc02007ce:	00002517          	auipc	a0,0x2
ffffffffc02007d2:	a2250513          	addi	a0,a0,-1502 # ffffffffc02021f0 <commands+0x500>
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
ffffffffc02008ae:	100027f3          	csrr	a5,sstatus
ffffffffc02008b2:	8b89                	andi	a5,a5,2
ffffffffc02008b4:	e799                	bnez	a5,ffffffffc02008c2 <alloc_pages+0x14>
ffffffffc02008b6:	00006797          	auipc	a5,0x6
ffffffffc02008ba:	ba27b783          	ld	a5,-1118(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008be:	6f9c                	ld	a5,24(a5)
ffffffffc02008c0:	8782                	jr	a5
ffffffffc02008c2:	1141                	addi	sp,sp,-16
ffffffffc02008c4:	e406                	sd	ra,8(sp)
ffffffffc02008c6:	e022                	sd	s0,0(sp)
ffffffffc02008c8:	842a                	mv	s0,a0
ffffffffc02008ca:	b95ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc02008ce:	00006797          	auipc	a5,0x6
ffffffffc02008d2:	b8a7b783          	ld	a5,-1142(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008d6:	6f9c                	ld	a5,24(a5)
ffffffffc02008d8:	8522                	mv	a0,s0
ffffffffc02008da:	9782                	jalr	a5
ffffffffc02008dc:	842a                	mv	s0,a0
ffffffffc02008de:	b7bff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc02008e2:	60a2                	ld	ra,8(sp)
ffffffffc02008e4:	8522                	mv	a0,s0
ffffffffc02008e6:	6402                	ld	s0,0(sp)
ffffffffc02008e8:	0141                	addi	sp,sp,16
ffffffffc02008ea:	8082                	ret

ffffffffc02008ec <free_pages>:
ffffffffc02008ec:	100027f3          	csrr	a5,sstatus
ffffffffc02008f0:	8b89                	andi	a5,a5,2
ffffffffc02008f2:	e799                	bnez	a5,ffffffffc0200900 <free_pages+0x14>
ffffffffc02008f4:	00006797          	auipc	a5,0x6
ffffffffc02008f8:	b647b783          	ld	a5,-1180(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02008fc:	739c                	ld	a5,32(a5)
ffffffffc02008fe:	8782                	jr	a5
ffffffffc0200900:	1101                	addi	sp,sp,-32
ffffffffc0200902:	ec06                	sd	ra,24(sp)
ffffffffc0200904:	e822                	sd	s0,16(sp)
ffffffffc0200906:	e426                	sd	s1,8(sp)
ffffffffc0200908:	842a                	mv	s0,a0
ffffffffc020090a:	84ae                	mv	s1,a1
ffffffffc020090c:	b53ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0200910:	00006797          	auipc	a5,0x6
ffffffffc0200914:	b487b783          	ld	a5,-1208(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0200918:	739c                	ld	a5,32(a5)
ffffffffc020091a:	85a6                	mv	a1,s1
ffffffffc020091c:	8522                	mv	a0,s0
ffffffffc020091e:	9782                	jalr	a5
ffffffffc0200920:	6442                	ld	s0,16(sp)
ffffffffc0200922:	60e2                	ld	ra,24(sp)
ffffffffc0200924:	64a2                	ld	s1,8(sp)
ffffffffc0200926:	6105                	addi	sp,sp,32
ffffffffc0200928:	be05                	j	ffffffffc0200458 <intr_enable>

ffffffffc020092a <nr_free_pages>:
ffffffffc020092a:	100027f3          	csrr	a5,sstatus
ffffffffc020092e:	8b89                	andi	a5,a5,2
ffffffffc0200930:	e799                	bnez	a5,ffffffffc020093e <nr_free_pages+0x14>
ffffffffc0200932:	00006797          	auipc	a5,0x6
ffffffffc0200936:	b267b783          	ld	a5,-1242(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020093a:	779c                	ld	a5,40(a5)
ffffffffc020093c:	8782                	jr	a5
ffffffffc020093e:	1141                	addi	sp,sp,-16
ffffffffc0200940:	e406                	sd	ra,8(sp)
ffffffffc0200942:	e022                	sd	s0,0(sp)
ffffffffc0200944:	b1bff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0200948:	00006797          	auipc	a5,0x6
ffffffffc020094c:	b107b783          	ld	a5,-1264(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0200950:	779c                	ld	a5,40(a5)
ffffffffc0200952:	9782                	jalr	a5
ffffffffc0200954:	842a                	mv	s0,a0
ffffffffc0200956:	b03ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc020095a:	60a2                	ld	ra,8(sp)
ffffffffc020095c:	8522                	mv	a0,s0
ffffffffc020095e:	6402                	ld	s0,0(sp)
ffffffffc0200960:	0141                	addi	sp,sp,16
ffffffffc0200962:	8082                	ret

ffffffffc0200964 <pmm_init>:
ffffffffc0200964:	00002797          	auipc	a5,0x2
ffffffffc0200968:	d4478793          	addi	a5,a5,-700 # ffffffffc02026a8 <best_fit_pmm_manager>
ffffffffc020096c:	638c                	ld	a1,0(a5)
ffffffffc020096e:	1101                	addi	sp,sp,-32
ffffffffc0200970:	e426                	sd	s1,8(sp)
ffffffffc0200972:	00002517          	auipc	a0,0x2
ffffffffc0200976:	8c650513          	addi	a0,a0,-1850 # ffffffffc0202238 <commands+0x548>
ffffffffc020097a:	00006497          	auipc	s1,0x6
ffffffffc020097e:	ade48493          	addi	s1,s1,-1314 # ffffffffc0206458 <pmm_manager>
ffffffffc0200982:	ec06                	sd	ra,24(sp)
ffffffffc0200984:	e822                	sd	s0,16(sp)
ffffffffc0200986:	e09c                	sd	a5,0(s1)
ffffffffc0200988:	f2aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020098c:	609c                	ld	a5,0(s1)
ffffffffc020098e:	00006417          	auipc	s0,0x6
ffffffffc0200992:	ae240413          	addi	s0,s0,-1310 # ffffffffc0206470 <va_pa_offset>
ffffffffc0200996:	679c                	ld	a5,8(a5)
ffffffffc0200998:	9782                	jalr	a5
ffffffffc020099a:	57f5                	li	a5,-3
ffffffffc020099c:	07fa                	slli	a5,a5,0x1e
ffffffffc020099e:	00002517          	auipc	a0,0x2
ffffffffc02009a2:	8b250513          	addi	a0,a0,-1870 # ffffffffc0202250 <commands+0x560>
ffffffffc02009a6:	e01c                	sd	a5,0(s0)
ffffffffc02009a8:	f0aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02009ac:	46c5                	li	a3,17
ffffffffc02009ae:	06ee                	slli	a3,a3,0x1b
ffffffffc02009b0:	40100613          	li	a2,1025
ffffffffc02009b4:	16fd                	addi	a3,a3,-1
ffffffffc02009b6:	07e005b7          	lui	a1,0x7e00
ffffffffc02009ba:	0656                	slli	a2,a2,0x15
ffffffffc02009bc:	00002517          	auipc	a0,0x2
ffffffffc02009c0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0202268 <commands+0x578>
ffffffffc02009c4:	eeeff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02009c8:	777d                	lui	a4,0xfffff
ffffffffc02009ca:	00007797          	auipc	a5,0x7
ffffffffc02009ce:	ab578793          	addi	a5,a5,-1355 # ffffffffc020747f <end+0xfff>
ffffffffc02009d2:	8ff9                	and	a5,a5,a4
ffffffffc02009d4:	00006517          	auipc	a0,0x6
ffffffffc02009d8:	a7450513          	addi	a0,a0,-1420 # ffffffffc0206448 <npage>
ffffffffc02009dc:	00088737          	lui	a4,0x88
ffffffffc02009e0:	00006597          	auipc	a1,0x6
ffffffffc02009e4:	a7058593          	addi	a1,a1,-1424 # ffffffffc0206450 <pages>
ffffffffc02009e8:	e118                	sd	a4,0(a0)
ffffffffc02009ea:	e19c                	sd	a5,0(a1)
ffffffffc02009ec:	4681                	li	a3,0
ffffffffc02009ee:	4701                	li	a4,0
ffffffffc02009f0:	4885                	li	a7,1
ffffffffc02009f2:	fff80837          	lui	a6,0xfff80
ffffffffc02009f6:	a011                	j	ffffffffc02009fa <pmm_init+0x96>
ffffffffc02009f8:	619c                	ld	a5,0(a1)
ffffffffc02009fa:	97b6                	add	a5,a5,a3
ffffffffc02009fc:	07a1                	addi	a5,a5,8
ffffffffc02009fe:	4117b02f          	amoor.d	zero,a7,(a5)
ffffffffc0200a02:	611c                	ld	a5,0(a0)
ffffffffc0200a04:	0705                	addi	a4,a4,1
ffffffffc0200a06:	02868693          	addi	a3,a3,40
ffffffffc0200a0a:	01078633          	add	a2,a5,a6
ffffffffc0200a0e:	fec765e3          	bltu	a4,a2,ffffffffc02009f8 <pmm_init+0x94>
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
ffffffffc0200a2e:	45c5                	li	a1,17
ffffffffc0200a30:	05ee                	slli	a1,a1,0x1b
ffffffffc0200a32:	8e99                	sub	a3,a3,a4
ffffffffc0200a34:	04b6e863          	bltu	a3,a1,ffffffffc0200a84 <pmm_init+0x120>
ffffffffc0200a38:	609c                	ld	a5,0(s1)
ffffffffc0200a3a:	7b9c                	ld	a5,48(a5)
ffffffffc0200a3c:	9782                	jalr	a5
ffffffffc0200a3e:	00002517          	auipc	a0,0x2
ffffffffc0200a42:	8c250513          	addi	a0,a0,-1854 # ffffffffc0202300 <commands+0x610>
ffffffffc0200a46:	e6cff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200a4a:	00004597          	auipc	a1,0x4
ffffffffc0200a4e:	5b658593          	addi	a1,a1,1462 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200a52:	00006797          	auipc	a5,0x6
ffffffffc0200a56:	a0b7bb23          	sd	a1,-1514(a5) # ffffffffc0206468 <satp_virtual>
ffffffffc0200a5a:	c02007b7          	lui	a5,0xc0200
ffffffffc0200a5e:	08f5e063          	bltu	a1,a5,ffffffffc0200ade <pmm_init+0x17a>
ffffffffc0200a62:	6010                	ld	a2,0(s0)
ffffffffc0200a64:	6442                	ld	s0,16(sp)
ffffffffc0200a66:	60e2                	ld	ra,24(sp)
ffffffffc0200a68:	64a2                	ld	s1,8(sp)
ffffffffc0200a6a:	40c58633          	sub	a2,a1,a2
ffffffffc0200a6e:	00006797          	auipc	a5,0x6
ffffffffc0200a72:	9ec7b923          	sd	a2,-1550(a5) # ffffffffc0206460 <satp_physical>
ffffffffc0200a76:	00002517          	auipc	a0,0x2
ffffffffc0200a7a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0202320 <commands+0x630>
ffffffffc0200a7e:	6105                	addi	sp,sp,32
ffffffffc0200a80:	e32ff06f          	j	ffffffffc02000b2 <cprintf>
ffffffffc0200a84:	6705                	lui	a4,0x1
ffffffffc0200a86:	177d                	addi	a4,a4,-1
ffffffffc0200a88:	96ba                	add	a3,a3,a4
ffffffffc0200a8a:	777d                	lui	a4,0xfffff
ffffffffc0200a8c:	8ef9                	and	a3,a3,a4
ffffffffc0200a8e:	00c6d513          	srli	a0,a3,0xc
ffffffffc0200a92:	00f57e63          	bgeu	a0,a5,ffffffffc0200aae <pmm_init+0x14a>
ffffffffc0200a96:	609c                	ld	a5,0(s1)
ffffffffc0200a98:	982a                	add	a6,a6,a0
ffffffffc0200a9a:	00281513          	slli	a0,a6,0x2
ffffffffc0200a9e:	9542                	add	a0,a0,a6
ffffffffc0200aa0:	6b9c                	ld	a5,16(a5)
ffffffffc0200aa2:	8d95                	sub	a1,a1,a3
ffffffffc0200aa4:	050e                	slli	a0,a0,0x3
ffffffffc0200aa6:	81b1                	srli	a1,a1,0xc
ffffffffc0200aa8:	9532                	add	a0,a0,a2
ffffffffc0200aaa:	9782                	jalr	a5
ffffffffc0200aac:	b771                	j	ffffffffc0200a38 <pmm_init+0xd4>
ffffffffc0200aae:	00002617          	auipc	a2,0x2
ffffffffc0200ab2:	82260613          	addi	a2,a2,-2014 # ffffffffc02022d0 <commands+0x5e0>
ffffffffc0200ab6:	06b00593          	li	a1,107
ffffffffc0200aba:	00002517          	auipc	a0,0x2
ffffffffc0200abe:	83650513          	addi	a0,a0,-1994 # ffffffffc02022f0 <commands+0x600>
ffffffffc0200ac2:	e78ff0ef          	jal	ra,ffffffffc020013a <__panic>
ffffffffc0200ac6:	00001617          	auipc	a2,0x1
ffffffffc0200aca:	7d260613          	addi	a2,a2,2002 # ffffffffc0202298 <commands+0x5a8>
ffffffffc0200ace:	06e00593          	li	a1,110
ffffffffc0200ad2:	00001517          	auipc	a0,0x1
ffffffffc0200ad6:	7ee50513          	addi	a0,a0,2030 # ffffffffc02022c0 <commands+0x5d0>
ffffffffc0200ada:	e60ff0ef          	jal	ra,ffffffffc020013a <__panic>
ffffffffc0200ade:	86ae                	mv	a3,a1
ffffffffc0200ae0:	00001617          	auipc	a2,0x1
ffffffffc0200ae4:	7b860613          	addi	a2,a2,1976 # ffffffffc0202298 <commands+0x5a8>
ffffffffc0200ae8:	08900593          	li	a1,137
ffffffffc0200aec:	00001517          	auipc	a0,0x1
ffffffffc0200af0:	7d450513          	addi	a0,a0,2004 # ffffffffc02022c0 <commands+0x5d0>
ffffffffc0200af4:	e46ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200af8 <best_fit_init>:
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
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200b04:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b08:	8082                	ret

ffffffffc0200b0a <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200b0a:	00005517          	auipc	a0,0x5
ffffffffc0200b0e:	51e56503          	lwu	a0,1310(a0) # ffffffffc0206028 <free_area+0x10>
ffffffffc0200b12:	8082                	ret

ffffffffc0200b14 <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc0200b14:	c14d                	beqz	a0,ffffffffc0200bb6 <best_fit_alloc_pages+0xa2>
    if (n > nr_free) {
ffffffffc0200b16:	00005617          	auipc	a2,0x5
ffffffffc0200b1a:	50260613          	addi	a2,a2,1282 # ffffffffc0206018 <free_area>
ffffffffc0200b1e:	01062803          	lw	a6,16(a2)
ffffffffc0200b22:	86aa                	mv	a3,a0
ffffffffc0200b24:	02081793          	slli	a5,a6,0x20
ffffffffc0200b28:	9381                	srli	a5,a5,0x20
ffffffffc0200b2a:	08a7e463          	bltu	a5,a0,ffffffffc0200bb2 <best_fit_alloc_pages+0x9e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b2e:	661c                	ld	a5,8(a2)
    size_t min_size = nr_free + 1;
ffffffffc0200b30:	0018059b          	addiw	a1,a6,1
ffffffffc0200b34:	1582                	slli	a1,a1,0x20
ffffffffc0200b36:	9181                	srli	a1,a1,0x20
    struct Page *page = NULL;
ffffffffc0200b38:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b3a:	06c78b63          	beq	a5,a2,ffffffffc0200bb0 <best_fit_alloc_pages+0x9c>
        if (p->property >= n && p->property < min_size) {  // 新找到的比已找到的最小还小，就更换
ffffffffc0200b3e:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0200b42:	00d76763          	bltu	a4,a3,ffffffffc0200b50 <best_fit_alloc_pages+0x3c>
ffffffffc0200b46:	00b77563          	bgeu	a4,a1,ffffffffc0200b50 <best_fit_alloc_pages+0x3c>
        struct Page *p = le2page(le, page_link);
ffffffffc0200b4a:	fe878513          	addi	a0,a5,-24
ffffffffc0200b4e:	85ba                	mv	a1,a4
ffffffffc0200b50:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b52:	fec796e3          	bne	a5,a2,ffffffffc0200b3e <best_fit_alloc_pages+0x2a>
    if (page != NULL) {
ffffffffc0200b56:	cd29                	beqz	a0,ffffffffc0200bb0 <best_fit_alloc_pages+0x9c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200b58:	711c                	ld	a5,32(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200b5a:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc0200b5c:	490c                	lw	a1,16(a0)
            p->property = page->property - n;
ffffffffc0200b5e:	0006889b          	sext.w	a7,a3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200b62:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200b64:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc0200b66:	02059793          	slli	a5,a1,0x20
ffffffffc0200b6a:	9381                	srli	a5,a5,0x20
ffffffffc0200b6c:	02f6f863          	bgeu	a3,a5,ffffffffc0200b9c <best_fit_alloc_pages+0x88>
            struct Page *p = page + n;
ffffffffc0200b70:	00269793          	slli	a5,a3,0x2
ffffffffc0200b74:	97b6                	add	a5,a5,a3
ffffffffc0200b76:	078e                	slli	a5,a5,0x3
ffffffffc0200b78:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc0200b7a:	411585bb          	subw	a1,a1,a7
ffffffffc0200b7e:	cb8c                	sw	a1,16(a5)
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200b80:	4689                	li	a3,2
ffffffffc0200b82:	00878593          	addi	a1,a5,8
ffffffffc0200b86:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200b8a:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0200b8c:	01878593          	addi	a1,a5,24
        nr_free -= n;
ffffffffc0200b90:	01062803          	lw	a6,16(a2)
    prev->next = next->prev = elm;
ffffffffc0200b94:	e28c                	sd	a1,0(a3)
ffffffffc0200b96:	e70c                	sd	a1,8(a4)
    elm->next = next;
ffffffffc0200b98:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200b9a:	ef98                	sd	a4,24(a5)
ffffffffc0200b9c:	4118083b          	subw	a6,a6,a7
ffffffffc0200ba0:	01062823          	sw	a6,16(a2)
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200ba4:	57f5                	li	a5,-3
ffffffffc0200ba6:	00850713          	addi	a4,a0,8
ffffffffc0200baa:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200bae:	8082                	ret
}
ffffffffc0200bb0:	8082                	ret
        return NULL;
ffffffffc0200bb2:	4501                	li	a0,0
ffffffffc0200bb4:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0200bb6:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200bb8:	00001697          	auipc	a3,0x1
ffffffffc0200bbc:	7a868693          	addi	a3,a3,1960 # ffffffffc0202360 <commands+0x670>
ffffffffc0200bc0:	00001617          	auipc	a2,0x1
ffffffffc0200bc4:	7a860613          	addi	a2,a2,1960 # ffffffffc0202368 <commands+0x678>
ffffffffc0200bc8:	06a00593          	li	a1,106
ffffffffc0200bcc:	00001517          	auipc	a0,0x1
ffffffffc0200bd0:	7b450513          	addi	a0,a0,1972 # ffffffffc0202380 <commands+0x690>
best_fit_alloc_pages(size_t n) {
ffffffffc0200bd4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200bd6:	d64ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200bda <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200bda:	715d                	addi	sp,sp,-80
ffffffffc0200bdc:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0200bde:	00005417          	auipc	s0,0x5
ffffffffc0200be2:	43a40413          	addi	s0,s0,1082 # ffffffffc0206018 <free_area>
ffffffffc0200be6:	641c                	ld	a5,8(s0)
ffffffffc0200be8:	e486                	sd	ra,72(sp)
ffffffffc0200bea:	fc26                	sd	s1,56(sp)
ffffffffc0200bec:	f84a                	sd	s2,48(sp)
ffffffffc0200bee:	f44e                	sd	s3,40(sp)
ffffffffc0200bf0:	f052                	sd	s4,32(sp)
ffffffffc0200bf2:	ec56                	sd	s5,24(sp)
ffffffffc0200bf4:	e85a                	sd	s6,16(sp)
ffffffffc0200bf6:	e45e                	sd	s7,8(sp)
ffffffffc0200bf8:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200bfa:	26878b63          	beq	a5,s0,ffffffffc0200e70 <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc0200bfe:	4481                	li	s1,0
ffffffffc0200c00:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c02:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200c06:	8b09                	andi	a4,a4,2
ffffffffc0200c08:	26070863          	beqz	a4,ffffffffc0200e78 <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc0200c0c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200c10:	679c                	ld	a5,8(a5)
ffffffffc0200c12:	2905                	addiw	s2,s2,1
ffffffffc0200c14:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c16:	fe8796e3          	bne	a5,s0,ffffffffc0200c02 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200c1a:	89a6                	mv	s3,s1
ffffffffc0200c1c:	d0fff0ef          	jal	ra,ffffffffc020092a <nr_free_pages>
ffffffffc0200c20:	33351c63          	bne	a0,s3,ffffffffc0200f58 <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c24:	4505                	li	a0,1
ffffffffc0200c26:	c89ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200c2a:	8a2a                	mv	s4,a0
ffffffffc0200c2c:	36050663          	beqz	a0,ffffffffc0200f98 <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c30:	4505                	li	a0,1
ffffffffc0200c32:	c7dff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200c36:	89aa                	mv	s3,a0
ffffffffc0200c38:	34050063          	beqz	a0,ffffffffc0200f78 <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c3c:	4505                	li	a0,1
ffffffffc0200c3e:	c71ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200c42:	8aaa                	mv	s5,a0
ffffffffc0200c44:	2c050a63          	beqz	a0,ffffffffc0200f18 <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200c48:	253a0863          	beq	s4,s3,ffffffffc0200e98 <best_fit_check+0x2be>
ffffffffc0200c4c:	24aa0663          	beq	s4,a0,ffffffffc0200e98 <best_fit_check+0x2be>
ffffffffc0200c50:	24a98463          	beq	s3,a0,ffffffffc0200e98 <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200c54:	000a2783          	lw	a5,0(s4)
ffffffffc0200c58:	26079063          	bnez	a5,ffffffffc0200eb8 <best_fit_check+0x2de>
ffffffffc0200c5c:	0009a783          	lw	a5,0(s3)
ffffffffc0200c60:	24079c63          	bnez	a5,ffffffffc0200eb8 <best_fit_check+0x2de>
ffffffffc0200c64:	411c                	lw	a5,0(a0)
ffffffffc0200c66:	24079963          	bnez	a5,ffffffffc0200eb8 <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c6a:	00005797          	auipc	a5,0x5
ffffffffc0200c6e:	7e67b783          	ld	a5,2022(a5) # ffffffffc0206450 <pages>
ffffffffc0200c72:	40fa0733          	sub	a4,s4,a5
ffffffffc0200c76:	870d                	srai	a4,a4,0x3
ffffffffc0200c78:	00002597          	auipc	a1,0x2
ffffffffc0200c7c:	cb85b583          	ld	a1,-840(a1) # ffffffffc0202930 <nbase+0x8>
ffffffffc0200c80:	02b70733          	mul	a4,a4,a1
ffffffffc0200c84:	00002617          	auipc	a2,0x2
ffffffffc0200c88:	ca463603          	ld	a2,-860(a2) # ffffffffc0202928 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200c8c:	00005697          	auipc	a3,0x5
ffffffffc0200c90:	7bc6b683          	ld	a3,1980(a3) # ffffffffc0206448 <npage>
ffffffffc0200c94:	06b2                	slli	a3,a3,0xc
ffffffffc0200c96:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c98:	0732                	slli	a4,a4,0xc
ffffffffc0200c9a:	22d77f63          	bgeu	a4,a3,ffffffffc0200ed8 <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c9e:	40f98733          	sub	a4,s3,a5
ffffffffc0200ca2:	870d                	srai	a4,a4,0x3
ffffffffc0200ca4:	02b70733          	mul	a4,a4,a1
ffffffffc0200ca8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200caa:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200cac:	3ed77663          	bgeu	a4,a3,ffffffffc0201098 <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cb0:	40f507b3          	sub	a5,a0,a5
ffffffffc0200cb4:	878d                	srai	a5,a5,0x3
ffffffffc0200cb6:	02b787b3          	mul	a5,a5,a1
ffffffffc0200cba:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200cbc:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200cbe:	3ad7fd63          	bgeu	a5,a3,ffffffffc0201078 <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200cc2:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200cc4:	00043c03          	ld	s8,0(s0)
ffffffffc0200cc8:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200ccc:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200cd0:	e400                	sd	s0,8(s0)
ffffffffc0200cd2:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200cd4:	00005797          	auipc	a5,0x5
ffffffffc0200cd8:	3407aa23          	sw	zero,852(a5) # ffffffffc0206028 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200cdc:	bd3ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200ce0:	36051c63          	bnez	a0,ffffffffc0201058 <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200ce4:	4585                	li	a1,1
ffffffffc0200ce6:	8552                	mv	a0,s4
ffffffffc0200ce8:	c05ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p1);
ffffffffc0200cec:	4585                	li	a1,1
ffffffffc0200cee:	854e                	mv	a0,s3
ffffffffc0200cf0:	bfdff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p2);
ffffffffc0200cf4:	4585                	li	a1,1
ffffffffc0200cf6:	8556                	mv	a0,s5
ffffffffc0200cf8:	bf5ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert(nr_free == 3);
ffffffffc0200cfc:	4818                	lw	a4,16(s0)
ffffffffc0200cfe:	478d                	li	a5,3
ffffffffc0200d00:	32f71c63          	bne	a4,a5,ffffffffc0201038 <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d04:	4505                	li	a0,1
ffffffffc0200d06:	ba9ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d0a:	89aa                	mv	s3,a0
ffffffffc0200d0c:	30050663          	beqz	a0,ffffffffc0201018 <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d10:	4505                	li	a0,1
ffffffffc0200d12:	b9dff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d16:	8aaa                	mv	s5,a0
ffffffffc0200d18:	2e050063          	beqz	a0,ffffffffc0200ff8 <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d1c:	4505                	li	a0,1
ffffffffc0200d1e:	b91ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d22:	8a2a                	mv	s4,a0
ffffffffc0200d24:	2a050a63          	beqz	a0,ffffffffc0200fd8 <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc0200d28:	4505                	li	a0,1
ffffffffc0200d2a:	b85ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d2e:	28051563          	bnez	a0,ffffffffc0200fb8 <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200d32:	4585                	li	a1,1
ffffffffc0200d34:	854e                	mv	a0,s3
ffffffffc0200d36:	bb7ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200d3a:	641c                	ld	a5,8(s0)
ffffffffc0200d3c:	1a878e63          	beq	a5,s0,ffffffffc0200ef8 <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200d40:	4505                	li	a0,1
ffffffffc0200d42:	b6dff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d46:	52a99963          	bne	s3,a0,ffffffffc0201278 <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc0200d4a:	4505                	li	a0,1
ffffffffc0200d4c:	b63ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d50:	50051463          	bnez	a0,ffffffffc0201258 <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200d54:	481c                	lw	a5,16(s0)
ffffffffc0200d56:	4e079163          	bnez	a5,ffffffffc0201238 <best_fit_check+0x65e>
    free_page(p);
ffffffffc0200d5a:	854e                	mv	a0,s3
ffffffffc0200d5c:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200d5e:	01843023          	sd	s8,0(s0)
ffffffffc0200d62:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200d66:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200d6a:	b83ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p1);
ffffffffc0200d6e:	4585                	li	a1,1
ffffffffc0200d70:	8556                	mv	a0,s5
ffffffffc0200d72:	b7bff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p2);
ffffffffc0200d76:	4585                	li	a1,1
ffffffffc0200d78:	8552                	mv	a0,s4
ffffffffc0200d7a:	b73ff0ef          	jal	ra,ffffffffc02008ec <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200d7e:	4515                	li	a0,5
ffffffffc0200d80:	b2fff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200d84:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200d86:	48050963          	beqz	a0,ffffffffc0201218 <best_fit_check+0x63e>
ffffffffc0200d8a:	651c                	ld	a5,8(a0)
ffffffffc0200d8c:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200d8e:	8b85                	andi	a5,a5,1
ffffffffc0200d90:	46079463          	bnez	a5,ffffffffc02011f8 <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200d94:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d96:	00043a83          	ld	s5,0(s0)
ffffffffc0200d9a:	00843a03          	ld	s4,8(s0)
ffffffffc0200d9e:	e000                	sd	s0,0(s0)
ffffffffc0200da0:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200da2:	b0dff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200da6:	42051963          	bnez	a0,ffffffffc02011d8 <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200daa:	4589                	li	a1,2
ffffffffc0200dac:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200db0:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200db4:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200db8:	00005797          	auipc	a5,0x5
ffffffffc0200dbc:	2607a823          	sw	zero,624(a5) # ffffffffc0206028 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200dc0:	b2dff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200dc4:	8562                	mv	a0,s8
ffffffffc0200dc6:	4585                	li	a1,1
ffffffffc0200dc8:	b25ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200dcc:	4511                	li	a0,4
ffffffffc0200dce:	ae1ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200dd2:	3e051363          	bnez	a0,ffffffffc02011b8 <best_fit_check+0x5de>
ffffffffc0200dd6:	0309b783          	ld	a5,48(s3)
ffffffffc0200dda:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200ddc:	8b85                	andi	a5,a5,1
ffffffffc0200dde:	3a078d63          	beqz	a5,ffffffffc0201198 <best_fit_check+0x5be>
ffffffffc0200de2:	0389a703          	lw	a4,56(s3)
ffffffffc0200de6:	4789                	li	a5,2
ffffffffc0200de8:	3af71863          	bne	a4,a5,ffffffffc0201198 <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200dec:	4505                	li	a0,1
ffffffffc0200dee:	ac1ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200df2:	8baa                	mv	s7,a0
ffffffffc0200df4:	38050263          	beqz	a0,ffffffffc0201178 <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200df8:	4509                	li	a0,2
ffffffffc0200dfa:	ab5ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200dfe:	34050d63          	beqz	a0,ffffffffc0201158 <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200e02:	337c1b63          	bne	s8,s7,ffffffffc0201138 <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200e06:	854e                	mv	a0,s3
ffffffffc0200e08:	4595                	li	a1,5
ffffffffc0200e0a:	ae3ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200e0e:	4515                	li	a0,5
ffffffffc0200e10:	a9fff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200e14:	89aa                	mv	s3,a0
ffffffffc0200e16:	30050163          	beqz	a0,ffffffffc0201118 <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200e1a:	4505                	li	a0,1
ffffffffc0200e1c:	a93ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0200e20:	2c051c63          	bnez	a0,ffffffffc02010f8 <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200e24:	481c                	lw	a5,16(s0)
ffffffffc0200e26:	2a079963          	bnez	a5,ffffffffc02010d8 <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200e2a:	4595                	li	a1,5
ffffffffc0200e2c:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200e2e:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200e32:	01543023          	sd	s5,0(s0)
ffffffffc0200e36:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200e3a:	ab3ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    return listelm->next;
ffffffffc0200e3e:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e40:	00878963          	beq	a5,s0,ffffffffc0200e52 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200e44:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e48:	679c                	ld	a5,8(a5)
ffffffffc0200e4a:	397d                	addiw	s2,s2,-1
ffffffffc0200e4c:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e4e:	fe879be3          	bne	a5,s0,ffffffffc0200e44 <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200e52:	26091363          	bnez	s2,ffffffffc02010b8 <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200e56:	e0ed                	bnez	s1,ffffffffc0200f38 <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200e58:	60a6                	ld	ra,72(sp)
ffffffffc0200e5a:	6406                	ld	s0,64(sp)
ffffffffc0200e5c:	74e2                	ld	s1,56(sp)
ffffffffc0200e5e:	7942                	ld	s2,48(sp)
ffffffffc0200e60:	79a2                	ld	s3,40(sp)
ffffffffc0200e62:	7a02                	ld	s4,32(sp)
ffffffffc0200e64:	6ae2                	ld	s5,24(sp)
ffffffffc0200e66:	6b42                	ld	s6,16(sp)
ffffffffc0200e68:	6ba2                	ld	s7,8(sp)
ffffffffc0200e6a:	6c02                	ld	s8,0(sp)
ffffffffc0200e6c:	6161                	addi	sp,sp,80
ffffffffc0200e6e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e70:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200e72:	4481                	li	s1,0
ffffffffc0200e74:	4901                	li	s2,0
ffffffffc0200e76:	b35d                	j	ffffffffc0200c1c <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc0200e78:	00001697          	auipc	a3,0x1
ffffffffc0200e7c:	52068693          	addi	a3,a3,1312 # ffffffffc0202398 <commands+0x6a8>
ffffffffc0200e80:	00001617          	auipc	a2,0x1
ffffffffc0200e84:	4e860613          	addi	a2,a2,1256 # ffffffffc0202368 <commands+0x678>
ffffffffc0200e88:	10900593          	li	a1,265
ffffffffc0200e8c:	00001517          	auipc	a0,0x1
ffffffffc0200e90:	4f450513          	addi	a0,a0,1268 # ffffffffc0202380 <commands+0x690>
ffffffffc0200e94:	aa6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e98:	00001697          	auipc	a3,0x1
ffffffffc0200e9c:	59068693          	addi	a3,a3,1424 # ffffffffc0202428 <commands+0x738>
ffffffffc0200ea0:	00001617          	auipc	a2,0x1
ffffffffc0200ea4:	4c860613          	addi	a2,a2,1224 # ffffffffc0202368 <commands+0x678>
ffffffffc0200ea8:	0d500593          	li	a1,213
ffffffffc0200eac:	00001517          	auipc	a0,0x1
ffffffffc0200eb0:	4d450513          	addi	a0,a0,1236 # ffffffffc0202380 <commands+0x690>
ffffffffc0200eb4:	a86ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200eb8:	00001697          	auipc	a3,0x1
ffffffffc0200ebc:	59868693          	addi	a3,a3,1432 # ffffffffc0202450 <commands+0x760>
ffffffffc0200ec0:	00001617          	auipc	a2,0x1
ffffffffc0200ec4:	4a860613          	addi	a2,a2,1192 # ffffffffc0202368 <commands+0x678>
ffffffffc0200ec8:	0d600593          	li	a1,214
ffffffffc0200ecc:	00001517          	auipc	a0,0x1
ffffffffc0200ed0:	4b450513          	addi	a0,a0,1204 # ffffffffc0202380 <commands+0x690>
ffffffffc0200ed4:	a66ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ed8:	00001697          	auipc	a3,0x1
ffffffffc0200edc:	5b868693          	addi	a3,a3,1464 # ffffffffc0202490 <commands+0x7a0>
ffffffffc0200ee0:	00001617          	auipc	a2,0x1
ffffffffc0200ee4:	48860613          	addi	a2,a2,1160 # ffffffffc0202368 <commands+0x678>
ffffffffc0200ee8:	0d800593          	li	a1,216
ffffffffc0200eec:	00001517          	auipc	a0,0x1
ffffffffc0200ef0:	49450513          	addi	a0,a0,1172 # ffffffffc0202380 <commands+0x690>
ffffffffc0200ef4:	a46ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200ef8:	00001697          	auipc	a3,0x1
ffffffffc0200efc:	62068693          	addi	a3,a3,1568 # ffffffffc0202518 <commands+0x828>
ffffffffc0200f00:	00001617          	auipc	a2,0x1
ffffffffc0200f04:	46860613          	addi	a2,a2,1128 # ffffffffc0202368 <commands+0x678>
ffffffffc0200f08:	0f100593          	li	a1,241
ffffffffc0200f0c:	00001517          	auipc	a0,0x1
ffffffffc0200f10:	47450513          	addi	a0,a0,1140 # ffffffffc0202380 <commands+0x690>
ffffffffc0200f14:	a26ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f18:	00001697          	auipc	a3,0x1
ffffffffc0200f1c:	4f068693          	addi	a3,a3,1264 # ffffffffc0202408 <commands+0x718>
ffffffffc0200f20:	00001617          	auipc	a2,0x1
ffffffffc0200f24:	44860613          	addi	a2,a2,1096 # ffffffffc0202368 <commands+0x678>
ffffffffc0200f28:	0d300593          	li	a1,211
ffffffffc0200f2c:	00001517          	auipc	a0,0x1
ffffffffc0200f30:	45450513          	addi	a0,a0,1108 # ffffffffc0202380 <commands+0x690>
ffffffffc0200f34:	a06ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == 0);
ffffffffc0200f38:	00001697          	auipc	a3,0x1
ffffffffc0200f3c:	71068693          	addi	a3,a3,1808 # ffffffffc0202648 <commands+0x958>
ffffffffc0200f40:	00001617          	auipc	a2,0x1
ffffffffc0200f44:	42860613          	addi	a2,a2,1064 # ffffffffc0202368 <commands+0x678>
ffffffffc0200f48:	14b00593          	li	a1,331
ffffffffc0200f4c:	00001517          	auipc	a0,0x1
ffffffffc0200f50:	43450513          	addi	a0,a0,1076 # ffffffffc0202380 <commands+0x690>
ffffffffc0200f54:	9e6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == nr_free_pages());
ffffffffc0200f58:	00001697          	auipc	a3,0x1
ffffffffc0200f5c:	45068693          	addi	a3,a3,1104 # ffffffffc02023a8 <commands+0x6b8>
ffffffffc0200f60:	00001617          	auipc	a2,0x1
ffffffffc0200f64:	40860613          	addi	a2,a2,1032 # ffffffffc0202368 <commands+0x678>
ffffffffc0200f68:	10c00593          	li	a1,268
ffffffffc0200f6c:	00001517          	auipc	a0,0x1
ffffffffc0200f70:	41450513          	addi	a0,a0,1044 # ffffffffc0202380 <commands+0x690>
ffffffffc0200f74:	9c6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f78:	00001697          	auipc	a3,0x1
ffffffffc0200f7c:	47068693          	addi	a3,a3,1136 # ffffffffc02023e8 <commands+0x6f8>
ffffffffc0200f80:	00001617          	auipc	a2,0x1
ffffffffc0200f84:	3e860613          	addi	a2,a2,1000 # ffffffffc0202368 <commands+0x678>
ffffffffc0200f88:	0d200593          	li	a1,210
ffffffffc0200f8c:	00001517          	auipc	a0,0x1
ffffffffc0200f90:	3f450513          	addi	a0,a0,1012 # ffffffffc0202380 <commands+0x690>
ffffffffc0200f94:	9a6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f98:	00001697          	auipc	a3,0x1
ffffffffc0200f9c:	43068693          	addi	a3,a3,1072 # ffffffffc02023c8 <commands+0x6d8>
ffffffffc0200fa0:	00001617          	auipc	a2,0x1
ffffffffc0200fa4:	3c860613          	addi	a2,a2,968 # ffffffffc0202368 <commands+0x678>
ffffffffc0200fa8:	0d100593          	li	a1,209
ffffffffc0200fac:	00001517          	auipc	a0,0x1
ffffffffc0200fb0:	3d450513          	addi	a0,a0,980 # ffffffffc0202380 <commands+0x690>
ffffffffc0200fb4:	986ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fb8:	00001697          	auipc	a3,0x1
ffffffffc0200fbc:	53868693          	addi	a3,a3,1336 # ffffffffc02024f0 <commands+0x800>
ffffffffc0200fc0:	00001617          	auipc	a2,0x1
ffffffffc0200fc4:	3a860613          	addi	a2,a2,936 # ffffffffc0202368 <commands+0x678>
ffffffffc0200fc8:	0ee00593          	li	a1,238
ffffffffc0200fcc:	00001517          	auipc	a0,0x1
ffffffffc0200fd0:	3b450513          	addi	a0,a0,948 # ffffffffc0202380 <commands+0x690>
ffffffffc0200fd4:	966ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200fd8:	00001697          	auipc	a3,0x1
ffffffffc0200fdc:	43068693          	addi	a3,a3,1072 # ffffffffc0202408 <commands+0x718>
ffffffffc0200fe0:	00001617          	auipc	a2,0x1
ffffffffc0200fe4:	38860613          	addi	a2,a2,904 # ffffffffc0202368 <commands+0x678>
ffffffffc0200fe8:	0ec00593          	li	a1,236
ffffffffc0200fec:	00001517          	auipc	a0,0x1
ffffffffc0200ff0:	39450513          	addi	a0,a0,916 # ffffffffc0202380 <commands+0x690>
ffffffffc0200ff4:	946ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ff8:	00001697          	auipc	a3,0x1
ffffffffc0200ffc:	3f068693          	addi	a3,a3,1008 # ffffffffc02023e8 <commands+0x6f8>
ffffffffc0201000:	00001617          	auipc	a2,0x1
ffffffffc0201004:	36860613          	addi	a2,a2,872 # ffffffffc0202368 <commands+0x678>
ffffffffc0201008:	0eb00593          	li	a1,235
ffffffffc020100c:	00001517          	auipc	a0,0x1
ffffffffc0201010:	37450513          	addi	a0,a0,884 # ffffffffc0202380 <commands+0x690>
ffffffffc0201014:	926ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201018:	00001697          	auipc	a3,0x1
ffffffffc020101c:	3b068693          	addi	a3,a3,944 # ffffffffc02023c8 <commands+0x6d8>
ffffffffc0201020:	00001617          	auipc	a2,0x1
ffffffffc0201024:	34860613          	addi	a2,a2,840 # ffffffffc0202368 <commands+0x678>
ffffffffc0201028:	0ea00593          	li	a1,234
ffffffffc020102c:	00001517          	auipc	a0,0x1
ffffffffc0201030:	35450513          	addi	a0,a0,852 # ffffffffc0202380 <commands+0x690>
ffffffffc0201034:	906ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 3);
ffffffffc0201038:	00001697          	auipc	a3,0x1
ffffffffc020103c:	4d068693          	addi	a3,a3,1232 # ffffffffc0202508 <commands+0x818>
ffffffffc0201040:	00001617          	auipc	a2,0x1
ffffffffc0201044:	32860613          	addi	a2,a2,808 # ffffffffc0202368 <commands+0x678>
ffffffffc0201048:	0e800593          	li	a1,232
ffffffffc020104c:	00001517          	auipc	a0,0x1
ffffffffc0201050:	33450513          	addi	a0,a0,820 # ffffffffc0202380 <commands+0x690>
ffffffffc0201054:	8e6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201058:	00001697          	auipc	a3,0x1
ffffffffc020105c:	49868693          	addi	a3,a3,1176 # ffffffffc02024f0 <commands+0x800>
ffffffffc0201060:	00001617          	auipc	a2,0x1
ffffffffc0201064:	30860613          	addi	a2,a2,776 # ffffffffc0202368 <commands+0x678>
ffffffffc0201068:	0e300593          	li	a1,227
ffffffffc020106c:	00001517          	auipc	a0,0x1
ffffffffc0201070:	31450513          	addi	a0,a0,788 # ffffffffc0202380 <commands+0x690>
ffffffffc0201074:	8c6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201078:	00001697          	auipc	a3,0x1
ffffffffc020107c:	45868693          	addi	a3,a3,1112 # ffffffffc02024d0 <commands+0x7e0>
ffffffffc0201080:	00001617          	auipc	a2,0x1
ffffffffc0201084:	2e860613          	addi	a2,a2,744 # ffffffffc0202368 <commands+0x678>
ffffffffc0201088:	0da00593          	li	a1,218
ffffffffc020108c:	00001517          	auipc	a0,0x1
ffffffffc0201090:	2f450513          	addi	a0,a0,756 # ffffffffc0202380 <commands+0x690>
ffffffffc0201094:	8a6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201098:	00001697          	auipc	a3,0x1
ffffffffc020109c:	41868693          	addi	a3,a3,1048 # ffffffffc02024b0 <commands+0x7c0>
ffffffffc02010a0:	00001617          	auipc	a2,0x1
ffffffffc02010a4:	2c860613          	addi	a2,a2,712 # ffffffffc0202368 <commands+0x678>
ffffffffc02010a8:	0d900593          	li	a1,217
ffffffffc02010ac:	00001517          	auipc	a0,0x1
ffffffffc02010b0:	2d450513          	addi	a0,a0,724 # ffffffffc0202380 <commands+0x690>
ffffffffc02010b4:	886ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(count == 0);
ffffffffc02010b8:	00001697          	auipc	a3,0x1
ffffffffc02010bc:	58068693          	addi	a3,a3,1408 # ffffffffc0202638 <commands+0x948>
ffffffffc02010c0:	00001617          	auipc	a2,0x1
ffffffffc02010c4:	2a860613          	addi	a2,a2,680 # ffffffffc0202368 <commands+0x678>
ffffffffc02010c8:	14a00593          	li	a1,330
ffffffffc02010cc:	00001517          	auipc	a0,0x1
ffffffffc02010d0:	2b450513          	addi	a0,a0,692 # ffffffffc0202380 <commands+0x690>
ffffffffc02010d4:	866ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc02010d8:	00001697          	auipc	a3,0x1
ffffffffc02010dc:	47868693          	addi	a3,a3,1144 # ffffffffc0202550 <commands+0x860>
ffffffffc02010e0:	00001617          	auipc	a2,0x1
ffffffffc02010e4:	28860613          	addi	a2,a2,648 # ffffffffc0202368 <commands+0x678>
ffffffffc02010e8:	13f00593          	li	a1,319
ffffffffc02010ec:	00001517          	auipc	a0,0x1
ffffffffc02010f0:	29450513          	addi	a0,a0,660 # ffffffffc0202380 <commands+0x690>
ffffffffc02010f4:	846ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010f8:	00001697          	auipc	a3,0x1
ffffffffc02010fc:	3f868693          	addi	a3,a3,1016 # ffffffffc02024f0 <commands+0x800>
ffffffffc0201100:	00001617          	auipc	a2,0x1
ffffffffc0201104:	26860613          	addi	a2,a2,616 # ffffffffc0202368 <commands+0x678>
ffffffffc0201108:	13900593          	li	a1,313
ffffffffc020110c:	00001517          	auipc	a0,0x1
ffffffffc0201110:	27450513          	addi	a0,a0,628 # ffffffffc0202380 <commands+0x690>
ffffffffc0201114:	826ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201118:	00001697          	auipc	a3,0x1
ffffffffc020111c:	50068693          	addi	a3,a3,1280 # ffffffffc0202618 <commands+0x928>
ffffffffc0201120:	00001617          	auipc	a2,0x1
ffffffffc0201124:	24860613          	addi	a2,a2,584 # ffffffffc0202368 <commands+0x678>
ffffffffc0201128:	13800593          	li	a1,312
ffffffffc020112c:	00001517          	auipc	a0,0x1
ffffffffc0201130:	25450513          	addi	a0,a0,596 # ffffffffc0202380 <commands+0x690>
ffffffffc0201134:	806ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 4 == p1);
ffffffffc0201138:	00001697          	auipc	a3,0x1
ffffffffc020113c:	4d068693          	addi	a3,a3,1232 # ffffffffc0202608 <commands+0x918>
ffffffffc0201140:	00001617          	auipc	a2,0x1
ffffffffc0201144:	22860613          	addi	a2,a2,552 # ffffffffc0202368 <commands+0x678>
ffffffffc0201148:	13000593          	li	a1,304
ffffffffc020114c:	00001517          	auipc	a0,0x1
ffffffffc0201150:	23450513          	addi	a0,a0,564 # ffffffffc0202380 <commands+0x690>
ffffffffc0201154:	fe7fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0201158:	00001697          	auipc	a3,0x1
ffffffffc020115c:	49868693          	addi	a3,a3,1176 # ffffffffc02025f0 <commands+0x900>
ffffffffc0201160:	00001617          	auipc	a2,0x1
ffffffffc0201164:	20860613          	addi	a2,a2,520 # ffffffffc0202368 <commands+0x678>
ffffffffc0201168:	12f00593          	li	a1,303
ffffffffc020116c:	00001517          	auipc	a0,0x1
ffffffffc0201170:	21450513          	addi	a0,a0,532 # ffffffffc0202380 <commands+0x690>
ffffffffc0201174:	fc7fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0201178:	00001697          	auipc	a3,0x1
ffffffffc020117c:	45868693          	addi	a3,a3,1112 # ffffffffc02025d0 <commands+0x8e0>
ffffffffc0201180:	00001617          	auipc	a2,0x1
ffffffffc0201184:	1e860613          	addi	a2,a2,488 # ffffffffc0202368 <commands+0x678>
ffffffffc0201188:	12e00593          	li	a1,302
ffffffffc020118c:	00001517          	auipc	a0,0x1
ffffffffc0201190:	1f450513          	addi	a0,a0,500 # ffffffffc0202380 <commands+0x690>
ffffffffc0201194:	fa7fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0201198:	00001697          	auipc	a3,0x1
ffffffffc020119c:	40868693          	addi	a3,a3,1032 # ffffffffc02025a0 <commands+0x8b0>
ffffffffc02011a0:	00001617          	auipc	a2,0x1
ffffffffc02011a4:	1c860613          	addi	a2,a2,456 # ffffffffc0202368 <commands+0x678>
ffffffffc02011a8:	12c00593          	li	a1,300
ffffffffc02011ac:	00001517          	auipc	a0,0x1
ffffffffc02011b0:	1d450513          	addi	a0,a0,468 # ffffffffc0202380 <commands+0x690>
ffffffffc02011b4:	f87fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02011b8:	00001697          	auipc	a3,0x1
ffffffffc02011bc:	3d068693          	addi	a3,a3,976 # ffffffffc0202588 <commands+0x898>
ffffffffc02011c0:	00001617          	auipc	a2,0x1
ffffffffc02011c4:	1a860613          	addi	a2,a2,424 # ffffffffc0202368 <commands+0x678>
ffffffffc02011c8:	12b00593          	li	a1,299
ffffffffc02011cc:	00001517          	auipc	a0,0x1
ffffffffc02011d0:	1b450513          	addi	a0,a0,436 # ffffffffc0202380 <commands+0x690>
ffffffffc02011d4:	f67fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011d8:	00001697          	auipc	a3,0x1
ffffffffc02011dc:	31868693          	addi	a3,a3,792 # ffffffffc02024f0 <commands+0x800>
ffffffffc02011e0:	00001617          	auipc	a2,0x1
ffffffffc02011e4:	18860613          	addi	a2,a2,392 # ffffffffc0202368 <commands+0x678>
ffffffffc02011e8:	11f00593          	li	a1,287
ffffffffc02011ec:	00001517          	auipc	a0,0x1
ffffffffc02011f0:	19450513          	addi	a0,a0,404 # ffffffffc0202380 <commands+0x690>
ffffffffc02011f4:	f47fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageProperty(p0));
ffffffffc02011f8:	00001697          	auipc	a3,0x1
ffffffffc02011fc:	37868693          	addi	a3,a3,888 # ffffffffc0202570 <commands+0x880>
ffffffffc0201200:	00001617          	auipc	a2,0x1
ffffffffc0201204:	16860613          	addi	a2,a2,360 # ffffffffc0202368 <commands+0x678>
ffffffffc0201208:	11600593          	li	a1,278
ffffffffc020120c:	00001517          	auipc	a0,0x1
ffffffffc0201210:	17450513          	addi	a0,a0,372 # ffffffffc0202380 <commands+0x690>
ffffffffc0201214:	f27fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc0201218:	00001697          	auipc	a3,0x1
ffffffffc020121c:	34868693          	addi	a3,a3,840 # ffffffffc0202560 <commands+0x870>
ffffffffc0201220:	00001617          	auipc	a2,0x1
ffffffffc0201224:	14860613          	addi	a2,a2,328 # ffffffffc0202368 <commands+0x678>
ffffffffc0201228:	11500593          	li	a1,277
ffffffffc020122c:	00001517          	auipc	a0,0x1
ffffffffc0201230:	15450513          	addi	a0,a0,340 # ffffffffc0202380 <commands+0x690>
ffffffffc0201234:	f07fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0201238:	00001697          	auipc	a3,0x1
ffffffffc020123c:	31868693          	addi	a3,a3,792 # ffffffffc0202550 <commands+0x860>
ffffffffc0201240:	00001617          	auipc	a2,0x1
ffffffffc0201244:	12860613          	addi	a2,a2,296 # ffffffffc0202368 <commands+0x678>
ffffffffc0201248:	0f700593          	li	a1,247
ffffffffc020124c:	00001517          	auipc	a0,0x1
ffffffffc0201250:	13450513          	addi	a0,a0,308 # ffffffffc0202380 <commands+0x690>
ffffffffc0201254:	ee7fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201258:	00001697          	auipc	a3,0x1
ffffffffc020125c:	29868693          	addi	a3,a3,664 # ffffffffc02024f0 <commands+0x800>
ffffffffc0201260:	00001617          	auipc	a2,0x1
ffffffffc0201264:	10860613          	addi	a2,a2,264 # ffffffffc0202368 <commands+0x678>
ffffffffc0201268:	0f500593          	li	a1,245
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	11450513          	addi	a0,a0,276 # ffffffffc0202380 <commands+0x690>
ffffffffc0201274:	ec7fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201278:	00001697          	auipc	a3,0x1
ffffffffc020127c:	2b868693          	addi	a3,a3,696 # ffffffffc0202530 <commands+0x840>
ffffffffc0201280:	00001617          	auipc	a2,0x1
ffffffffc0201284:	0e860613          	addi	a2,a2,232 # ffffffffc0202368 <commands+0x678>
ffffffffc0201288:	0f400593          	li	a1,244
ffffffffc020128c:	00001517          	auipc	a0,0x1
ffffffffc0201290:	0f450513          	addi	a0,a0,244 # ffffffffc0202380 <commands+0x690>
ffffffffc0201294:	ea7fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201298 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0201298:	1141                	addi	sp,sp,-16
ffffffffc020129a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020129c:	14058a63          	beqz	a1,ffffffffc02013f0 <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc02012a0:	00259693          	slli	a3,a1,0x2
ffffffffc02012a4:	96ae                	add	a3,a3,a1
ffffffffc02012a6:	068e                	slli	a3,a3,0x3
ffffffffc02012a8:	96aa                	add	a3,a3,a0
ffffffffc02012aa:	87aa                	mv	a5,a0
ffffffffc02012ac:	02d50263          	beq	a0,a3,ffffffffc02012d0 <best_fit_free_pages+0x38>
ffffffffc02012b0:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02012b2:	8b05                	andi	a4,a4,1
ffffffffc02012b4:	10071e63          	bnez	a4,ffffffffc02013d0 <best_fit_free_pages+0x138>
ffffffffc02012b8:	6798                	ld	a4,8(a5)
ffffffffc02012ba:	8b09                	andi	a4,a4,2
ffffffffc02012bc:	10071a63          	bnez	a4,ffffffffc02013d0 <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc02012c0:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02012c4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02012c8:	02878793          	addi	a5,a5,40
ffffffffc02012cc:	fed792e3          	bne	a5,a3,ffffffffc02012b0 <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc02012d0:	2581                	sext.w	a1,a1
ffffffffc02012d2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02012d4:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02012d8:	4789                	li	a5,2
ffffffffc02012da:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02012de:	00005697          	auipc	a3,0x5
ffffffffc02012e2:	d3a68693          	addi	a3,a3,-710 # ffffffffc0206018 <free_area>
ffffffffc02012e6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02012e8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02012ea:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02012ee:	9db9                	addw	a1,a1,a4
ffffffffc02012f0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02012f2:	0ad78863          	beq	a5,a3,ffffffffc02013a2 <best_fit_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02012f6:	fe878713          	addi	a4,a5,-24
ffffffffc02012fa:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02012fe:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201300:	00e56a63          	bltu	a0,a4,ffffffffc0201314 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc0201304:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201306:	06d70263          	beq	a4,a3,ffffffffc020136a <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc020130a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020130c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201310:	fee57ae3          	bgeu	a0,a4,ffffffffc0201304 <best_fit_free_pages+0x6c>
ffffffffc0201314:	c199                	beqz	a1,ffffffffc020131a <best_fit_free_pages+0x82>
ffffffffc0201316:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020131a:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc020131c:	e390                	sd	a2,0(a5)
ffffffffc020131e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201320:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201322:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201324:	02d70063          	beq	a4,a3,ffffffffc0201344 <best_fit_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201328:	ff872803          	lw	a6,-8(a4) # ffffffffffffeff8 <end+0x3fdf8b78>
        p = le2page(le, page_link);
ffffffffc020132c:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc0201330:	02081613          	slli	a2,a6,0x20
ffffffffc0201334:	9201                	srli	a2,a2,0x20
ffffffffc0201336:	00261793          	slli	a5,a2,0x2
ffffffffc020133a:	97b2                	add	a5,a5,a2
ffffffffc020133c:	078e                	slli	a5,a5,0x3
ffffffffc020133e:	97ae                	add	a5,a5,a1
ffffffffc0201340:	02f50f63          	beq	a0,a5,ffffffffc020137e <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc0201344:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0201346:	00d70f63          	beq	a4,a3,ffffffffc0201364 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc020134a:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc020134c:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0201350:	02059613          	slli	a2,a1,0x20
ffffffffc0201354:	9201                	srli	a2,a2,0x20
ffffffffc0201356:	00261793          	slli	a5,a2,0x2
ffffffffc020135a:	97b2                	add	a5,a5,a2
ffffffffc020135c:	078e                	slli	a5,a5,0x3
ffffffffc020135e:	97aa                	add	a5,a5,a0
ffffffffc0201360:	04f68863          	beq	a3,a5,ffffffffc02013b0 <best_fit_free_pages+0x118>
}
ffffffffc0201364:	60a2                	ld	ra,8(sp)
ffffffffc0201366:	0141                	addi	sp,sp,16
ffffffffc0201368:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020136a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020136c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020136e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201370:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201372:	02d70563          	beq	a4,a3,ffffffffc020139c <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201376:	8832                	mv	a6,a2
ffffffffc0201378:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020137a:	87ba                	mv	a5,a4
ffffffffc020137c:	bf41                	j	ffffffffc020130c <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc020137e:	491c                	lw	a5,16(a0)
ffffffffc0201380:	0107883b          	addw	a6,a5,a6
ffffffffc0201384:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201388:	57f5                	li	a5,-3
ffffffffc020138a:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020138e:	6d10                	ld	a2,24(a0)
ffffffffc0201390:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201392:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc0201394:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201396:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201398:	e390                	sd	a2,0(a5)
ffffffffc020139a:	b775                	j	ffffffffc0201346 <best_fit_free_pages+0xae>
ffffffffc020139c:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020139e:	873e                	mv	a4,a5
ffffffffc02013a0:	b761                	j	ffffffffc0201328 <best_fit_free_pages+0x90>
}
ffffffffc02013a2:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02013a4:	e390                	sd	a2,0(a5)
ffffffffc02013a6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013a8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02013aa:	ed1c                	sd	a5,24(a0)
ffffffffc02013ac:	0141                	addi	sp,sp,16
ffffffffc02013ae:	8082                	ret
            base->property += p->property;
ffffffffc02013b0:	ff872783          	lw	a5,-8(a4)
ffffffffc02013b4:	ff070693          	addi	a3,a4,-16
ffffffffc02013b8:	9dbd                	addw	a1,a1,a5
ffffffffc02013ba:	c90c                	sw	a1,16(a0)
ffffffffc02013bc:	57f5                	li	a5,-3
ffffffffc02013be:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02013c2:	6314                	ld	a3,0(a4)
ffffffffc02013c4:	671c                	ld	a5,8(a4)
}
ffffffffc02013c6:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02013c8:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02013ca:	e394                	sd	a3,0(a5)
ffffffffc02013cc:	0141                	addi	sp,sp,16
ffffffffc02013ce:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02013d0:	00001697          	auipc	a3,0x1
ffffffffc02013d4:	28868693          	addi	a3,a3,648 # ffffffffc0202658 <commands+0x968>
ffffffffc02013d8:	00001617          	auipc	a2,0x1
ffffffffc02013dc:	f9060613          	addi	a2,a2,-112 # ffffffffc0202368 <commands+0x678>
ffffffffc02013e0:	09100593          	li	a1,145
ffffffffc02013e4:	00001517          	auipc	a0,0x1
ffffffffc02013e8:	f9c50513          	addi	a0,a0,-100 # ffffffffc0202380 <commands+0x690>
ffffffffc02013ec:	d4ffe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02013f0:	00001697          	auipc	a3,0x1
ffffffffc02013f4:	f7068693          	addi	a3,a3,-144 # ffffffffc0202360 <commands+0x670>
ffffffffc02013f8:	00001617          	auipc	a2,0x1
ffffffffc02013fc:	f7060613          	addi	a2,a2,-144 # ffffffffc0202368 <commands+0x678>
ffffffffc0201400:	08e00593          	li	a1,142
ffffffffc0201404:	00001517          	auipc	a0,0x1
ffffffffc0201408:	f7c50513          	addi	a0,a0,-132 # ffffffffc0202380 <commands+0x690>
ffffffffc020140c:	d2ffe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201410 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc0201410:	1141                	addi	sp,sp,-16
ffffffffc0201412:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201414:	c9e1                	beqz	a1,ffffffffc02014e4 <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201416:	00259693          	slli	a3,a1,0x2
ffffffffc020141a:	96ae                	add	a3,a3,a1
ffffffffc020141c:	068e                	slli	a3,a3,0x3
ffffffffc020141e:	96aa                	add	a3,a3,a0
ffffffffc0201420:	87aa                	mv	a5,a0
ffffffffc0201422:	00d50f63          	beq	a0,a3,ffffffffc0201440 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201426:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201428:	8b05                	andi	a4,a4,1
ffffffffc020142a:	cf49                	beqz	a4,ffffffffc02014c4 <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020142c:	0007a823          	sw	zero,16(a5)
ffffffffc0201430:	0007b423          	sd	zero,8(a5)
ffffffffc0201434:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201438:	02878793          	addi	a5,a5,40
ffffffffc020143c:	fed795e3          	bne	a5,a3,ffffffffc0201426 <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc0201440:	2581                	sext.w	a1,a1
ffffffffc0201442:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201444:	4789                	li	a5,2
ffffffffc0201446:	00850713          	addi	a4,a0,8
ffffffffc020144a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020144e:	00005697          	auipc	a3,0x5
ffffffffc0201452:	bca68693          	addi	a3,a3,-1078 # ffffffffc0206018 <free_area>
ffffffffc0201456:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201458:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020145a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020145e:	9db9                	addw	a1,a1,a4
ffffffffc0201460:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201462:	04d78a63          	beq	a5,a3,ffffffffc02014b6 <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201466:	fe878713          	addi	a4,a5,-24
ffffffffc020146a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020146e:	4581                	li	a1,0
             if (base < page) {
ffffffffc0201470:	00e56a63          	bltu	a0,a4,ffffffffc0201484 <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc0201474:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201476:	02d70263          	beq	a4,a3,ffffffffc020149a <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020147a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020147c:	fe878713          	addi	a4,a5,-24
             if (base < page) {
ffffffffc0201480:	fee57ae3          	bgeu	a0,a4,ffffffffc0201474 <best_fit_init_memmap+0x64>
ffffffffc0201484:	c199                	beqz	a1,ffffffffc020148a <best_fit_init_memmap+0x7a>
ffffffffc0201486:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020148a:	6398                	ld	a4,0(a5)
}
ffffffffc020148c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020148e:	e390                	sd	a2,0(a5)
ffffffffc0201490:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201492:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201494:	ed18                	sd	a4,24(a0)
ffffffffc0201496:	0141                	addi	sp,sp,16
ffffffffc0201498:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020149a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020149c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020149e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02014a0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02014a2:	00d70663          	beq	a4,a3,ffffffffc02014ae <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02014a6:	8832                	mv	a6,a2
ffffffffc02014a8:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02014aa:	87ba                	mv	a5,a4
ffffffffc02014ac:	bfc1                	j	ffffffffc020147c <best_fit_init_memmap+0x6c>
}
ffffffffc02014ae:	60a2                	ld	ra,8(sp)
ffffffffc02014b0:	e290                	sd	a2,0(a3)
ffffffffc02014b2:	0141                	addi	sp,sp,16
ffffffffc02014b4:	8082                	ret
ffffffffc02014b6:	60a2                	ld	ra,8(sp)
ffffffffc02014b8:	e390                	sd	a2,0(a5)
ffffffffc02014ba:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02014bc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02014be:	ed1c                	sd	a5,24(a0)
ffffffffc02014c0:	0141                	addi	sp,sp,16
ffffffffc02014c2:	8082                	ret
        assert(PageReserved(p));
ffffffffc02014c4:	00001697          	auipc	a3,0x1
ffffffffc02014c8:	1bc68693          	addi	a3,a3,444 # ffffffffc0202680 <commands+0x990>
ffffffffc02014cc:	00001617          	auipc	a2,0x1
ffffffffc02014d0:	e9c60613          	addi	a2,a2,-356 # ffffffffc0202368 <commands+0x678>
ffffffffc02014d4:	04a00593          	li	a1,74
ffffffffc02014d8:	00001517          	auipc	a0,0x1
ffffffffc02014dc:	ea850513          	addi	a0,a0,-344 # ffffffffc0202380 <commands+0x690>
ffffffffc02014e0:	c5bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02014e4:	00001697          	auipc	a3,0x1
ffffffffc02014e8:	e7c68693          	addi	a3,a3,-388 # ffffffffc0202360 <commands+0x670>
ffffffffc02014ec:	00001617          	auipc	a2,0x1
ffffffffc02014f0:	e7c60613          	addi	a2,a2,-388 # ffffffffc0202368 <commands+0x678>
ffffffffc02014f4:	04700593          	li	a1,71
ffffffffc02014f8:	00001517          	auipc	a0,0x1
ffffffffc02014fc:	e8850513          	addi	a0,a0,-376 # ffffffffc0202380 <commands+0x690>
ffffffffc0201500:	c3bfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201504 <strnlen>:
ffffffffc0201504:	4781                	li	a5,0
ffffffffc0201506:	e589                	bnez	a1,ffffffffc0201510 <strnlen+0xc>
ffffffffc0201508:	a811                	j	ffffffffc020151c <strnlen+0x18>
ffffffffc020150a:	0785                	addi	a5,a5,1
ffffffffc020150c:	00f58863          	beq	a1,a5,ffffffffc020151c <strnlen+0x18>
ffffffffc0201510:	00f50733          	add	a4,a0,a5
ffffffffc0201514:	00074703          	lbu	a4,0(a4)
ffffffffc0201518:	fb6d                	bnez	a4,ffffffffc020150a <strnlen+0x6>
ffffffffc020151a:	85be                	mv	a1,a5
ffffffffc020151c:	852e                	mv	a0,a1
ffffffffc020151e:	8082                	ret

ffffffffc0201520 <strcmp>:
ffffffffc0201520:	00054783          	lbu	a5,0(a0)
ffffffffc0201524:	0005c703          	lbu	a4,0(a1)
ffffffffc0201528:	cb89                	beqz	a5,ffffffffc020153a <strcmp+0x1a>
ffffffffc020152a:	0505                	addi	a0,a0,1
ffffffffc020152c:	0585                	addi	a1,a1,1
ffffffffc020152e:	fee789e3          	beq	a5,a4,ffffffffc0201520 <strcmp>
ffffffffc0201532:	0007851b          	sext.w	a0,a5
ffffffffc0201536:	9d19                	subw	a0,a0,a4
ffffffffc0201538:	8082                	ret
ffffffffc020153a:	4501                	li	a0,0
ffffffffc020153c:	bfed                	j	ffffffffc0201536 <strcmp+0x16>

ffffffffc020153e <strchr>:
ffffffffc020153e:	00054783          	lbu	a5,0(a0)
ffffffffc0201542:	c799                	beqz	a5,ffffffffc0201550 <strchr+0x12>
ffffffffc0201544:	00f58763          	beq	a1,a5,ffffffffc0201552 <strchr+0x14>
ffffffffc0201548:	00154783          	lbu	a5,1(a0)
ffffffffc020154c:	0505                	addi	a0,a0,1
ffffffffc020154e:	fbfd                	bnez	a5,ffffffffc0201544 <strchr+0x6>
ffffffffc0201550:	4501                	li	a0,0
ffffffffc0201552:	8082                	ret

ffffffffc0201554 <memset>:
ffffffffc0201554:	ca01                	beqz	a2,ffffffffc0201564 <memset+0x10>
ffffffffc0201556:	962a                	add	a2,a2,a0
ffffffffc0201558:	87aa                	mv	a5,a0
ffffffffc020155a:	0785                	addi	a5,a5,1
ffffffffc020155c:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201560:	fec79de3          	bne	a5,a2,ffffffffc020155a <memset+0x6>
ffffffffc0201564:	8082                	ret

ffffffffc0201566 <printnum>:
ffffffffc0201566:	02069813          	slli	a6,a3,0x20
ffffffffc020156a:	7179                	addi	sp,sp,-48
ffffffffc020156c:	02085813          	srli	a6,a6,0x20
ffffffffc0201570:	e052                	sd	s4,0(sp)
ffffffffc0201572:	03067a33          	remu	s4,a2,a6
ffffffffc0201576:	f022                	sd	s0,32(sp)
ffffffffc0201578:	ec26                	sd	s1,24(sp)
ffffffffc020157a:	e84a                	sd	s2,16(sp)
ffffffffc020157c:	f406                	sd	ra,40(sp)
ffffffffc020157e:	e44e                	sd	s3,8(sp)
ffffffffc0201580:	84aa                	mv	s1,a0
ffffffffc0201582:	892e                	mv	s2,a1
ffffffffc0201584:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201588:	2a01                	sext.w	s4,s4
ffffffffc020158a:	03067e63          	bgeu	a2,a6,ffffffffc02015c6 <printnum+0x60>
ffffffffc020158e:	89be                	mv	s3,a5
ffffffffc0201590:	00805763          	blez	s0,ffffffffc020159e <printnum+0x38>
ffffffffc0201594:	347d                	addiw	s0,s0,-1
ffffffffc0201596:	85ca                	mv	a1,s2
ffffffffc0201598:	854e                	mv	a0,s3
ffffffffc020159a:	9482                	jalr	s1
ffffffffc020159c:	fc65                	bnez	s0,ffffffffc0201594 <printnum+0x2e>
ffffffffc020159e:	1a02                	slli	s4,s4,0x20
ffffffffc02015a0:	00001797          	auipc	a5,0x1
ffffffffc02015a4:	14078793          	addi	a5,a5,320 # ffffffffc02026e0 <best_fit_pmm_manager+0x38>
ffffffffc02015a8:	020a5a13          	srli	s4,s4,0x20
ffffffffc02015ac:	9a3e                	add	s4,s4,a5
ffffffffc02015ae:	7402                	ld	s0,32(sp)
ffffffffc02015b0:	000a4503          	lbu	a0,0(s4)
ffffffffc02015b4:	70a2                	ld	ra,40(sp)
ffffffffc02015b6:	69a2                	ld	s3,8(sp)
ffffffffc02015b8:	6a02                	ld	s4,0(sp)
ffffffffc02015ba:	85ca                	mv	a1,s2
ffffffffc02015bc:	87a6                	mv	a5,s1
ffffffffc02015be:	6942                	ld	s2,16(sp)
ffffffffc02015c0:	64e2                	ld	s1,24(sp)
ffffffffc02015c2:	6145                	addi	sp,sp,48
ffffffffc02015c4:	8782                	jr	a5
ffffffffc02015c6:	03065633          	divu	a2,a2,a6
ffffffffc02015ca:	8722                	mv	a4,s0
ffffffffc02015cc:	f9bff0ef          	jal	ra,ffffffffc0201566 <printnum>
ffffffffc02015d0:	b7f9                	j	ffffffffc020159e <printnum+0x38>

ffffffffc02015d2 <vprintfmt>:
ffffffffc02015d2:	7119                	addi	sp,sp,-128
ffffffffc02015d4:	f4a6                	sd	s1,104(sp)
ffffffffc02015d6:	f0ca                	sd	s2,96(sp)
ffffffffc02015d8:	ecce                	sd	s3,88(sp)
ffffffffc02015da:	e8d2                	sd	s4,80(sp)
ffffffffc02015dc:	e4d6                	sd	s5,72(sp)
ffffffffc02015de:	e0da                	sd	s6,64(sp)
ffffffffc02015e0:	fc5e                	sd	s7,56(sp)
ffffffffc02015e2:	f06a                	sd	s10,32(sp)
ffffffffc02015e4:	fc86                	sd	ra,120(sp)
ffffffffc02015e6:	f8a2                	sd	s0,112(sp)
ffffffffc02015e8:	f862                	sd	s8,48(sp)
ffffffffc02015ea:	f466                	sd	s9,40(sp)
ffffffffc02015ec:	ec6e                	sd	s11,24(sp)
ffffffffc02015ee:	892a                	mv	s2,a0
ffffffffc02015f0:	84ae                	mv	s1,a1
ffffffffc02015f2:	8d32                	mv	s10,a2
ffffffffc02015f4:	8a36                	mv	s4,a3
ffffffffc02015f6:	02500993          	li	s3,37
ffffffffc02015fa:	5b7d                	li	s6,-1
ffffffffc02015fc:	00001a97          	auipc	s5,0x1
ffffffffc0201600:	118a8a93          	addi	s5,s5,280 # ffffffffc0202714 <best_fit_pmm_manager+0x6c>
ffffffffc0201604:	00001b97          	auipc	s7,0x1
ffffffffc0201608:	2ecb8b93          	addi	s7,s7,748 # ffffffffc02028f0 <error_string>
ffffffffc020160c:	000d4503          	lbu	a0,0(s10)
ffffffffc0201610:	001d0413          	addi	s0,s10,1
ffffffffc0201614:	01350a63          	beq	a0,s3,ffffffffc0201628 <vprintfmt+0x56>
ffffffffc0201618:	c121                	beqz	a0,ffffffffc0201658 <vprintfmt+0x86>
ffffffffc020161a:	85a6                	mv	a1,s1
ffffffffc020161c:	0405                	addi	s0,s0,1
ffffffffc020161e:	9902                	jalr	s2
ffffffffc0201620:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201624:	ff351ae3          	bne	a0,s3,ffffffffc0201618 <vprintfmt+0x46>
ffffffffc0201628:	00044603          	lbu	a2,0(s0)
ffffffffc020162c:	02000793          	li	a5,32
ffffffffc0201630:	4c81                	li	s9,0
ffffffffc0201632:	4881                	li	a7,0
ffffffffc0201634:	5c7d                	li	s8,-1
ffffffffc0201636:	5dfd                	li	s11,-1
ffffffffc0201638:	05500513          	li	a0,85
ffffffffc020163c:	4825                	li	a6,9
ffffffffc020163e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201642:	0ff5f593          	zext.b	a1,a1
ffffffffc0201646:	00140d13          	addi	s10,s0,1
ffffffffc020164a:	04b56263          	bltu	a0,a1,ffffffffc020168e <vprintfmt+0xbc>
ffffffffc020164e:	058a                	slli	a1,a1,0x2
ffffffffc0201650:	95d6                	add	a1,a1,s5
ffffffffc0201652:	4194                	lw	a3,0(a1)
ffffffffc0201654:	96d6                	add	a3,a3,s5
ffffffffc0201656:	8682                	jr	a3
ffffffffc0201658:	70e6                	ld	ra,120(sp)
ffffffffc020165a:	7446                	ld	s0,112(sp)
ffffffffc020165c:	74a6                	ld	s1,104(sp)
ffffffffc020165e:	7906                	ld	s2,96(sp)
ffffffffc0201660:	69e6                	ld	s3,88(sp)
ffffffffc0201662:	6a46                	ld	s4,80(sp)
ffffffffc0201664:	6aa6                	ld	s5,72(sp)
ffffffffc0201666:	6b06                	ld	s6,64(sp)
ffffffffc0201668:	7be2                	ld	s7,56(sp)
ffffffffc020166a:	7c42                	ld	s8,48(sp)
ffffffffc020166c:	7ca2                	ld	s9,40(sp)
ffffffffc020166e:	7d02                	ld	s10,32(sp)
ffffffffc0201670:	6de2                	ld	s11,24(sp)
ffffffffc0201672:	6109                	addi	sp,sp,128
ffffffffc0201674:	8082                	ret
ffffffffc0201676:	87b2                	mv	a5,a2
ffffffffc0201678:	00144603          	lbu	a2,1(s0)
ffffffffc020167c:	846a                	mv	s0,s10
ffffffffc020167e:	00140d13          	addi	s10,s0,1
ffffffffc0201682:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201686:	0ff5f593          	zext.b	a1,a1
ffffffffc020168a:	fcb572e3          	bgeu	a0,a1,ffffffffc020164e <vprintfmt+0x7c>
ffffffffc020168e:	85a6                	mv	a1,s1
ffffffffc0201690:	02500513          	li	a0,37
ffffffffc0201694:	9902                	jalr	s2
ffffffffc0201696:	fff44783          	lbu	a5,-1(s0)
ffffffffc020169a:	8d22                	mv	s10,s0
ffffffffc020169c:	f73788e3          	beq	a5,s3,ffffffffc020160c <vprintfmt+0x3a>
ffffffffc02016a0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02016a4:	1d7d                	addi	s10,s10,-1
ffffffffc02016a6:	ff379de3          	bne	a5,s3,ffffffffc02016a0 <vprintfmt+0xce>
ffffffffc02016aa:	b78d                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc02016ac:	fd060c1b          	addiw	s8,a2,-48
ffffffffc02016b0:	00144603          	lbu	a2,1(s0)
ffffffffc02016b4:	846a                	mv	s0,s10
ffffffffc02016b6:	fd06069b          	addiw	a3,a2,-48
ffffffffc02016ba:	0006059b          	sext.w	a1,a2
ffffffffc02016be:	02d86463          	bltu	a6,a3,ffffffffc02016e6 <vprintfmt+0x114>
ffffffffc02016c2:	00144603          	lbu	a2,1(s0)
ffffffffc02016c6:	002c169b          	slliw	a3,s8,0x2
ffffffffc02016ca:	0186873b          	addw	a4,a3,s8
ffffffffc02016ce:	0017171b          	slliw	a4,a4,0x1
ffffffffc02016d2:	9f2d                	addw	a4,a4,a1
ffffffffc02016d4:	fd06069b          	addiw	a3,a2,-48
ffffffffc02016d8:	0405                	addi	s0,s0,1
ffffffffc02016da:	fd070c1b          	addiw	s8,a4,-48
ffffffffc02016de:	0006059b          	sext.w	a1,a2
ffffffffc02016e2:	fed870e3          	bgeu	a6,a3,ffffffffc02016c2 <vprintfmt+0xf0>
ffffffffc02016e6:	f40ddce3          	bgez	s11,ffffffffc020163e <vprintfmt+0x6c>
ffffffffc02016ea:	8de2                	mv	s11,s8
ffffffffc02016ec:	5c7d                	li	s8,-1
ffffffffc02016ee:	bf81                	j	ffffffffc020163e <vprintfmt+0x6c>
ffffffffc02016f0:	fffdc693          	not	a3,s11
ffffffffc02016f4:	96fd                	srai	a3,a3,0x3f
ffffffffc02016f6:	00ddfdb3          	and	s11,s11,a3
ffffffffc02016fa:	00144603          	lbu	a2,1(s0)
ffffffffc02016fe:	2d81                	sext.w	s11,s11
ffffffffc0201700:	846a                	mv	s0,s10
ffffffffc0201702:	bf35                	j	ffffffffc020163e <vprintfmt+0x6c>
ffffffffc0201704:	000a2c03          	lw	s8,0(s4)
ffffffffc0201708:	00144603          	lbu	a2,1(s0)
ffffffffc020170c:	0a21                	addi	s4,s4,8
ffffffffc020170e:	846a                	mv	s0,s10
ffffffffc0201710:	bfd9                	j	ffffffffc02016e6 <vprintfmt+0x114>
ffffffffc0201712:	4705                	li	a4,1
ffffffffc0201714:	008a0593          	addi	a1,s4,8
ffffffffc0201718:	01174463          	blt	a4,a7,ffffffffc0201720 <vprintfmt+0x14e>
ffffffffc020171c:	1a088e63          	beqz	a7,ffffffffc02018d8 <vprintfmt+0x306>
ffffffffc0201720:	000a3603          	ld	a2,0(s4)
ffffffffc0201724:	46c1                	li	a3,16
ffffffffc0201726:	8a2e                	mv	s4,a1
ffffffffc0201728:	2781                	sext.w	a5,a5
ffffffffc020172a:	876e                	mv	a4,s11
ffffffffc020172c:	85a6                	mv	a1,s1
ffffffffc020172e:	854a                	mv	a0,s2
ffffffffc0201730:	e37ff0ef          	jal	ra,ffffffffc0201566 <printnum>
ffffffffc0201734:	bde1                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc0201736:	000a2503          	lw	a0,0(s4)
ffffffffc020173a:	85a6                	mv	a1,s1
ffffffffc020173c:	0a21                	addi	s4,s4,8
ffffffffc020173e:	9902                	jalr	s2
ffffffffc0201740:	b5f1                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc0201742:	4705                	li	a4,1
ffffffffc0201744:	008a0593          	addi	a1,s4,8
ffffffffc0201748:	01174463          	blt	a4,a7,ffffffffc0201750 <vprintfmt+0x17e>
ffffffffc020174c:	18088163          	beqz	a7,ffffffffc02018ce <vprintfmt+0x2fc>
ffffffffc0201750:	000a3603          	ld	a2,0(s4)
ffffffffc0201754:	46a9                	li	a3,10
ffffffffc0201756:	8a2e                	mv	s4,a1
ffffffffc0201758:	bfc1                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc020175a:	00144603          	lbu	a2,1(s0)
ffffffffc020175e:	4c85                	li	s9,1
ffffffffc0201760:	846a                	mv	s0,s10
ffffffffc0201762:	bdf1                	j	ffffffffc020163e <vprintfmt+0x6c>
ffffffffc0201764:	85a6                	mv	a1,s1
ffffffffc0201766:	02500513          	li	a0,37
ffffffffc020176a:	9902                	jalr	s2
ffffffffc020176c:	b545                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc020176e:	00144603          	lbu	a2,1(s0)
ffffffffc0201772:	2885                	addiw	a7,a7,1
ffffffffc0201774:	846a                	mv	s0,s10
ffffffffc0201776:	b5e1                	j	ffffffffc020163e <vprintfmt+0x6c>
ffffffffc0201778:	4705                	li	a4,1
ffffffffc020177a:	008a0593          	addi	a1,s4,8
ffffffffc020177e:	01174463          	blt	a4,a7,ffffffffc0201786 <vprintfmt+0x1b4>
ffffffffc0201782:	14088163          	beqz	a7,ffffffffc02018c4 <vprintfmt+0x2f2>
ffffffffc0201786:	000a3603          	ld	a2,0(s4)
ffffffffc020178a:	46a1                	li	a3,8
ffffffffc020178c:	8a2e                	mv	s4,a1
ffffffffc020178e:	bf69                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc0201790:	03000513          	li	a0,48
ffffffffc0201794:	85a6                	mv	a1,s1
ffffffffc0201796:	e03e                	sd	a5,0(sp)
ffffffffc0201798:	9902                	jalr	s2
ffffffffc020179a:	85a6                	mv	a1,s1
ffffffffc020179c:	07800513          	li	a0,120
ffffffffc02017a0:	9902                	jalr	s2
ffffffffc02017a2:	0a21                	addi	s4,s4,8
ffffffffc02017a4:	6782                	ld	a5,0(sp)
ffffffffc02017a6:	46c1                	li	a3,16
ffffffffc02017a8:	ff8a3603          	ld	a2,-8(s4)
ffffffffc02017ac:	bfb5                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc02017ae:	000a3403          	ld	s0,0(s4)
ffffffffc02017b2:	008a0713          	addi	a4,s4,8
ffffffffc02017b6:	e03a                	sd	a4,0(sp)
ffffffffc02017b8:	14040263          	beqz	s0,ffffffffc02018fc <vprintfmt+0x32a>
ffffffffc02017bc:	0fb05763          	blez	s11,ffffffffc02018aa <vprintfmt+0x2d8>
ffffffffc02017c0:	02d00693          	li	a3,45
ffffffffc02017c4:	0cd79163          	bne	a5,a3,ffffffffc0201886 <vprintfmt+0x2b4>
ffffffffc02017c8:	00044783          	lbu	a5,0(s0)
ffffffffc02017cc:	0007851b          	sext.w	a0,a5
ffffffffc02017d0:	cf85                	beqz	a5,ffffffffc0201808 <vprintfmt+0x236>
ffffffffc02017d2:	00140a13          	addi	s4,s0,1
ffffffffc02017d6:	05e00413          	li	s0,94
ffffffffc02017da:	000c4563          	bltz	s8,ffffffffc02017e4 <vprintfmt+0x212>
ffffffffc02017de:	3c7d                	addiw	s8,s8,-1
ffffffffc02017e0:	036c0263          	beq	s8,s6,ffffffffc0201804 <vprintfmt+0x232>
ffffffffc02017e4:	85a6                	mv	a1,s1
ffffffffc02017e6:	0e0c8e63          	beqz	s9,ffffffffc02018e2 <vprintfmt+0x310>
ffffffffc02017ea:	3781                	addiw	a5,a5,-32
ffffffffc02017ec:	0ef47b63          	bgeu	s0,a5,ffffffffc02018e2 <vprintfmt+0x310>
ffffffffc02017f0:	03f00513          	li	a0,63
ffffffffc02017f4:	9902                	jalr	s2
ffffffffc02017f6:	000a4783          	lbu	a5,0(s4)
ffffffffc02017fa:	3dfd                	addiw	s11,s11,-1
ffffffffc02017fc:	0a05                	addi	s4,s4,1
ffffffffc02017fe:	0007851b          	sext.w	a0,a5
ffffffffc0201802:	ffe1                	bnez	a5,ffffffffc02017da <vprintfmt+0x208>
ffffffffc0201804:	01b05963          	blez	s11,ffffffffc0201816 <vprintfmt+0x244>
ffffffffc0201808:	3dfd                	addiw	s11,s11,-1
ffffffffc020180a:	85a6                	mv	a1,s1
ffffffffc020180c:	02000513          	li	a0,32
ffffffffc0201810:	9902                	jalr	s2
ffffffffc0201812:	fe0d9be3          	bnez	s11,ffffffffc0201808 <vprintfmt+0x236>
ffffffffc0201816:	6a02                	ld	s4,0(sp)
ffffffffc0201818:	bbd5                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc020181a:	4705                	li	a4,1
ffffffffc020181c:	008a0c93          	addi	s9,s4,8
ffffffffc0201820:	01174463          	blt	a4,a7,ffffffffc0201828 <vprintfmt+0x256>
ffffffffc0201824:	08088d63          	beqz	a7,ffffffffc02018be <vprintfmt+0x2ec>
ffffffffc0201828:	000a3403          	ld	s0,0(s4)
ffffffffc020182c:	0a044d63          	bltz	s0,ffffffffc02018e6 <vprintfmt+0x314>
ffffffffc0201830:	8622                	mv	a2,s0
ffffffffc0201832:	8a66                	mv	s4,s9
ffffffffc0201834:	46a9                	li	a3,10
ffffffffc0201836:	bdcd                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc0201838:	000a2783          	lw	a5,0(s4)
ffffffffc020183c:	4719                	li	a4,6
ffffffffc020183e:	0a21                	addi	s4,s4,8
ffffffffc0201840:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201844:	8fb5                	xor	a5,a5,a3
ffffffffc0201846:	40d786bb          	subw	a3,a5,a3
ffffffffc020184a:	02d74163          	blt	a4,a3,ffffffffc020186c <vprintfmt+0x29a>
ffffffffc020184e:	00369793          	slli	a5,a3,0x3
ffffffffc0201852:	97de                	add	a5,a5,s7
ffffffffc0201854:	639c                	ld	a5,0(a5)
ffffffffc0201856:	cb99                	beqz	a5,ffffffffc020186c <vprintfmt+0x29a>
ffffffffc0201858:	86be                	mv	a3,a5
ffffffffc020185a:	00001617          	auipc	a2,0x1
ffffffffc020185e:	eb660613          	addi	a2,a2,-330 # ffffffffc0202710 <best_fit_pmm_manager+0x68>
ffffffffc0201862:	85a6                	mv	a1,s1
ffffffffc0201864:	854a                	mv	a0,s2
ffffffffc0201866:	0ce000ef          	jal	ra,ffffffffc0201934 <printfmt>
ffffffffc020186a:	b34d                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc020186c:	00001617          	auipc	a2,0x1
ffffffffc0201870:	e9460613          	addi	a2,a2,-364 # ffffffffc0202700 <best_fit_pmm_manager+0x58>
ffffffffc0201874:	85a6                	mv	a1,s1
ffffffffc0201876:	854a                	mv	a0,s2
ffffffffc0201878:	0bc000ef          	jal	ra,ffffffffc0201934 <printfmt>
ffffffffc020187c:	bb41                	j	ffffffffc020160c <vprintfmt+0x3a>
ffffffffc020187e:	00001417          	auipc	s0,0x1
ffffffffc0201882:	e7a40413          	addi	s0,s0,-390 # ffffffffc02026f8 <best_fit_pmm_manager+0x50>
ffffffffc0201886:	85e2                	mv	a1,s8
ffffffffc0201888:	8522                	mv	a0,s0
ffffffffc020188a:	e43e                	sd	a5,8(sp)
ffffffffc020188c:	c79ff0ef          	jal	ra,ffffffffc0201504 <strnlen>
ffffffffc0201890:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201894:	01b05b63          	blez	s11,ffffffffc02018aa <vprintfmt+0x2d8>
ffffffffc0201898:	67a2                	ld	a5,8(sp)
ffffffffc020189a:	00078a1b          	sext.w	s4,a5
ffffffffc020189e:	3dfd                	addiw	s11,s11,-1
ffffffffc02018a0:	85a6                	mv	a1,s1
ffffffffc02018a2:	8552                	mv	a0,s4
ffffffffc02018a4:	9902                	jalr	s2
ffffffffc02018a6:	fe0d9ce3          	bnez	s11,ffffffffc020189e <vprintfmt+0x2cc>
ffffffffc02018aa:	00044783          	lbu	a5,0(s0)
ffffffffc02018ae:	00140a13          	addi	s4,s0,1
ffffffffc02018b2:	0007851b          	sext.w	a0,a5
ffffffffc02018b6:	d3a5                	beqz	a5,ffffffffc0201816 <vprintfmt+0x244>
ffffffffc02018b8:	05e00413          	li	s0,94
ffffffffc02018bc:	bf39                	j	ffffffffc02017da <vprintfmt+0x208>
ffffffffc02018be:	000a2403          	lw	s0,0(s4)
ffffffffc02018c2:	b7ad                	j	ffffffffc020182c <vprintfmt+0x25a>
ffffffffc02018c4:	000a6603          	lwu	a2,0(s4)
ffffffffc02018c8:	46a1                	li	a3,8
ffffffffc02018ca:	8a2e                	mv	s4,a1
ffffffffc02018cc:	bdb1                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc02018ce:	000a6603          	lwu	a2,0(s4)
ffffffffc02018d2:	46a9                	li	a3,10
ffffffffc02018d4:	8a2e                	mv	s4,a1
ffffffffc02018d6:	bd89                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc02018d8:	000a6603          	lwu	a2,0(s4)
ffffffffc02018dc:	46c1                	li	a3,16
ffffffffc02018de:	8a2e                	mv	s4,a1
ffffffffc02018e0:	b5a1                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc02018e2:	9902                	jalr	s2
ffffffffc02018e4:	bf09                	j	ffffffffc02017f6 <vprintfmt+0x224>
ffffffffc02018e6:	85a6                	mv	a1,s1
ffffffffc02018e8:	02d00513          	li	a0,45
ffffffffc02018ec:	e03e                	sd	a5,0(sp)
ffffffffc02018ee:	9902                	jalr	s2
ffffffffc02018f0:	6782                	ld	a5,0(sp)
ffffffffc02018f2:	8a66                	mv	s4,s9
ffffffffc02018f4:	40800633          	neg	a2,s0
ffffffffc02018f8:	46a9                	li	a3,10
ffffffffc02018fa:	b53d                	j	ffffffffc0201728 <vprintfmt+0x156>
ffffffffc02018fc:	03b05163          	blez	s11,ffffffffc020191e <vprintfmt+0x34c>
ffffffffc0201900:	02d00693          	li	a3,45
ffffffffc0201904:	f6d79de3          	bne	a5,a3,ffffffffc020187e <vprintfmt+0x2ac>
ffffffffc0201908:	00001417          	auipc	s0,0x1
ffffffffc020190c:	df040413          	addi	s0,s0,-528 # ffffffffc02026f8 <best_fit_pmm_manager+0x50>
ffffffffc0201910:	02800793          	li	a5,40
ffffffffc0201914:	02800513          	li	a0,40
ffffffffc0201918:	00140a13          	addi	s4,s0,1
ffffffffc020191c:	bd6d                	j	ffffffffc02017d6 <vprintfmt+0x204>
ffffffffc020191e:	00001a17          	auipc	s4,0x1
ffffffffc0201922:	ddba0a13          	addi	s4,s4,-549 # ffffffffc02026f9 <best_fit_pmm_manager+0x51>
ffffffffc0201926:	02800513          	li	a0,40
ffffffffc020192a:	02800793          	li	a5,40
ffffffffc020192e:	05e00413          	li	s0,94
ffffffffc0201932:	b565                	j	ffffffffc02017da <vprintfmt+0x208>

ffffffffc0201934 <printfmt>:
ffffffffc0201934:	715d                	addi	sp,sp,-80
ffffffffc0201936:	02810313          	addi	t1,sp,40
ffffffffc020193a:	f436                	sd	a3,40(sp)
ffffffffc020193c:	869a                	mv	a3,t1
ffffffffc020193e:	ec06                	sd	ra,24(sp)
ffffffffc0201940:	f83a                	sd	a4,48(sp)
ffffffffc0201942:	fc3e                	sd	a5,56(sp)
ffffffffc0201944:	e0c2                	sd	a6,64(sp)
ffffffffc0201946:	e4c6                	sd	a7,72(sp)
ffffffffc0201948:	e41a                	sd	t1,8(sp)
ffffffffc020194a:	c89ff0ef          	jal	ra,ffffffffc02015d2 <vprintfmt>
ffffffffc020194e:	60e2                	ld	ra,24(sp)
ffffffffc0201950:	6161                	addi	sp,sp,80
ffffffffc0201952:	8082                	ret

ffffffffc0201954 <readline>:
ffffffffc0201954:	715d                	addi	sp,sp,-80
ffffffffc0201956:	e486                	sd	ra,72(sp)
ffffffffc0201958:	e0a6                	sd	s1,64(sp)
ffffffffc020195a:	fc4a                	sd	s2,56(sp)
ffffffffc020195c:	f84e                	sd	s3,48(sp)
ffffffffc020195e:	f452                	sd	s4,40(sp)
ffffffffc0201960:	f056                	sd	s5,32(sp)
ffffffffc0201962:	ec5a                	sd	s6,24(sp)
ffffffffc0201964:	e85e                	sd	s7,16(sp)
ffffffffc0201966:	c901                	beqz	a0,ffffffffc0201976 <readline+0x22>
ffffffffc0201968:	85aa                	mv	a1,a0
ffffffffc020196a:	00001517          	auipc	a0,0x1
ffffffffc020196e:	da650513          	addi	a0,a0,-602 # ffffffffc0202710 <best_fit_pmm_manager+0x68>
ffffffffc0201972:	f40fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201976:	4481                	li	s1,0
ffffffffc0201978:	497d                	li	s2,31
ffffffffc020197a:	49a1                	li	s3,8
ffffffffc020197c:	4aa9                	li	s5,10
ffffffffc020197e:	4b35                	li	s6,13
ffffffffc0201980:	00004b97          	auipc	s7,0x4
ffffffffc0201984:	6b0b8b93          	addi	s7,s7,1712 # ffffffffc0206030 <buf>
ffffffffc0201988:	3fe00a13          	li	s4,1022
ffffffffc020198c:	f9efe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201990:	00054a63          	bltz	a0,ffffffffc02019a4 <readline+0x50>
ffffffffc0201994:	00a95a63          	bge	s2,a0,ffffffffc02019a8 <readline+0x54>
ffffffffc0201998:	029a5263          	bge	s4,s1,ffffffffc02019bc <readline+0x68>
ffffffffc020199c:	f8efe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc02019a0:	fe055ae3          	bgez	a0,ffffffffc0201994 <readline+0x40>
ffffffffc02019a4:	4501                	li	a0,0
ffffffffc02019a6:	a091                	j	ffffffffc02019ea <readline+0x96>
ffffffffc02019a8:	03351463          	bne	a0,s3,ffffffffc02019d0 <readline+0x7c>
ffffffffc02019ac:	e8a9                	bnez	s1,ffffffffc02019fe <readline+0xaa>
ffffffffc02019ae:	f7cfe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc02019b2:	fe0549e3          	bltz	a0,ffffffffc02019a4 <readline+0x50>
ffffffffc02019b6:	fea959e3          	bge	s2,a0,ffffffffc02019a8 <readline+0x54>
ffffffffc02019ba:	4481                	li	s1,0
ffffffffc02019bc:	e42a                	sd	a0,8(sp)
ffffffffc02019be:	f2afe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02019c2:	6522                	ld	a0,8(sp)
ffffffffc02019c4:	009b87b3          	add	a5,s7,s1
ffffffffc02019c8:	2485                	addiw	s1,s1,1
ffffffffc02019ca:	00a78023          	sb	a0,0(a5)
ffffffffc02019ce:	bf7d                	j	ffffffffc020198c <readline+0x38>
ffffffffc02019d0:	01550463          	beq	a0,s5,ffffffffc02019d8 <readline+0x84>
ffffffffc02019d4:	fb651ce3          	bne	a0,s6,ffffffffc020198c <readline+0x38>
ffffffffc02019d8:	f10fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02019dc:	00004517          	auipc	a0,0x4
ffffffffc02019e0:	65450513          	addi	a0,a0,1620 # ffffffffc0206030 <buf>
ffffffffc02019e4:	94aa                	add	s1,s1,a0
ffffffffc02019e6:	00048023          	sb	zero,0(s1)
ffffffffc02019ea:	60a6                	ld	ra,72(sp)
ffffffffc02019ec:	6486                	ld	s1,64(sp)
ffffffffc02019ee:	7962                	ld	s2,56(sp)
ffffffffc02019f0:	79c2                	ld	s3,48(sp)
ffffffffc02019f2:	7a22                	ld	s4,40(sp)
ffffffffc02019f4:	7a82                	ld	s5,32(sp)
ffffffffc02019f6:	6b62                	ld	s6,24(sp)
ffffffffc02019f8:	6bc2                	ld	s7,16(sp)
ffffffffc02019fa:	6161                	addi	sp,sp,80
ffffffffc02019fc:	8082                	ret
ffffffffc02019fe:	4521                	li	a0,8
ffffffffc0201a00:	ee8fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201a04:	34fd                	addiw	s1,s1,-1
ffffffffc0201a06:	b759                	j	ffffffffc020198c <readline+0x38>

ffffffffc0201a08 <sbi_console_putchar>:
ffffffffc0201a08:	4781                	li	a5,0
ffffffffc0201a0a:	00004717          	auipc	a4,0x4
ffffffffc0201a0e:	5fe73703          	ld	a4,1534(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201a12:	88ba                	mv	a7,a4
ffffffffc0201a14:	852a                	mv	a0,a0
ffffffffc0201a16:	85be                	mv	a1,a5
ffffffffc0201a18:	863e                	mv	a2,a5
ffffffffc0201a1a:	00000073          	ecall
ffffffffc0201a1e:	87aa                	mv	a5,a0
ffffffffc0201a20:	8082                	ret

ffffffffc0201a22 <sbi_set_timer>:
ffffffffc0201a22:	4781                	li	a5,0
ffffffffc0201a24:	00005717          	auipc	a4,0x5
ffffffffc0201a28:	a5473703          	ld	a4,-1452(a4) # ffffffffc0206478 <SBI_SET_TIMER>
ffffffffc0201a2c:	88ba                	mv	a7,a4
ffffffffc0201a2e:	852a                	mv	a0,a0
ffffffffc0201a30:	85be                	mv	a1,a5
ffffffffc0201a32:	863e                	mv	a2,a5
ffffffffc0201a34:	00000073          	ecall
ffffffffc0201a38:	87aa                	mv	a5,a0
ffffffffc0201a3a:	8082                	ret

ffffffffc0201a3c <sbi_console_getchar>:
ffffffffc0201a3c:	4501                	li	a0,0
ffffffffc0201a3e:	00004797          	auipc	a5,0x4
ffffffffc0201a42:	5c27b783          	ld	a5,1474(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201a46:	88be                	mv	a7,a5
ffffffffc0201a48:	852a                	mv	a0,a0
ffffffffc0201a4a:	85aa                	mv	a1,a0
ffffffffc0201a4c:	862a                	mv	a2,a0
ffffffffc0201a4e:	00000073          	ecall
ffffffffc0201a52:	852a                	mv	a0,a0
ffffffffc0201a54:	2501                	sext.w	a0,a0
ffffffffc0201a56:	8082                	ret

ffffffffc0201a58 <sbi_shutdown>:
ffffffffc0201a58:	4781                	li	a5,0
ffffffffc0201a5a:	00004717          	auipc	a4,0x4
ffffffffc0201a5e:	5b673703          	ld	a4,1462(a4) # ffffffffc0206010 <SBI_SHUTDOWN>
ffffffffc0201a62:	88ba                	mv	a7,a4
ffffffffc0201a64:	853e                	mv	a0,a5
ffffffffc0201a66:	85be                	mv	a1,a5
ffffffffc0201a68:	863e                	mv	a2,a5
ffffffffc0201a6a:	00000073          	ecall
ffffffffc0201a6e:	87aa                	mv	a5,a0
ffffffffc0201a70:	8082                	ret
