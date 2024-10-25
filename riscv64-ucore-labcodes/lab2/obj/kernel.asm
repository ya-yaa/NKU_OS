
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
ffffffffc0200036:	ffe50513          	addi	a0,a0,-2 # ffffffffc0206030 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	47e60613          	addi	a2,a2,1150 # ffffffffc02064b8 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	4d4010ef          	jal	ra,ffffffffc020151e <memset>
ffffffffc020004e:	404000ef          	jal	ra,ffffffffc0200452 <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0201a40 <etext+0x4>
ffffffffc020005a:	098000ef          	jal	ra,ffffffffc02000f2 <cputs>
ffffffffc020005e:	140000ef          	jal	ra,ffffffffc020019e <print_kerninfo>
ffffffffc0200062:	40a000ef          	jal	ra,ffffffffc020046c <idt_init>
ffffffffc0200066:	0cd000ef          	jal	ra,ffffffffc0200932 <pmm_init>
ffffffffc020006a:	402000ef          	jal	ra,ffffffffc020046c <idt_init>
ffffffffc020006e:	3a2000ef          	jal	ra,ffffffffc0200410 <clock_init>
ffffffffc0200072:	3ee000ef          	jal	ra,ffffffffc0200460 <intr_enable>
ffffffffc0200076:	44b000ef          	jal	ra,ffffffffc0200cc0 <slub_init>
ffffffffc020007a:	4c1000ef          	jal	ra,ffffffffc0200d3a <slub_check>
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
ffffffffc02000ae:	4ee010ef          	jal	ra,ffffffffc020159c <vprintfmt>
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
ffffffffc02000e4:	4b8010ef          	jal	ra,ffffffffc020159c <vprintfmt>
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

ffffffffc0200142 <__panic>:
ffffffffc0200142:	00006317          	auipc	t1,0x6
ffffffffc0200146:	30630313          	addi	t1,t1,774 # ffffffffc0206448 <is_panic>
ffffffffc020014a:	00032e03          	lw	t3,0(t1)
ffffffffc020014e:	715d                	addi	sp,sp,-80
ffffffffc0200150:	ec06                	sd	ra,24(sp)
ffffffffc0200152:	e822                	sd	s0,16(sp)
ffffffffc0200154:	f436                	sd	a3,40(sp)
ffffffffc0200156:	f83a                	sd	a4,48(sp)
ffffffffc0200158:	fc3e                	sd	a5,56(sp)
ffffffffc020015a:	e0c2                	sd	a6,64(sp)
ffffffffc020015c:	e4c6                	sd	a7,72(sp)
ffffffffc020015e:	020e1a63          	bnez	t3,ffffffffc0200192 <__panic+0x50>
ffffffffc0200162:	4785                	li	a5,1
ffffffffc0200164:	00f32023          	sw	a5,0(t1)
ffffffffc0200168:	8432                	mv	s0,a2
ffffffffc020016a:	103c                	addi	a5,sp,40
ffffffffc020016c:	862e                	mv	a2,a1
ffffffffc020016e:	85aa                	mv	a1,a0
ffffffffc0200170:	00002517          	auipc	a0,0x2
ffffffffc0200174:	8f050513          	addi	a0,a0,-1808 # ffffffffc0201a60 <etext+0x24>
ffffffffc0200178:	e43e                	sd	a5,8(sp)
ffffffffc020017a:	f41ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020017e:	65a2                	ld	a1,8(sp)
ffffffffc0200180:	8522                	mv	a0,s0
ffffffffc0200182:	f19ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
ffffffffc0200186:	00002517          	auipc	a0,0x2
ffffffffc020018a:	2a250513          	addi	a0,a0,674 # ffffffffc0202428 <commands+0x770>
ffffffffc020018e:	f2dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200192:	2d4000ef          	jal	ra,ffffffffc0200466 <intr_disable>
ffffffffc0200196:	4501                	li	a0,0
ffffffffc0200198:	130000ef          	jal	ra,ffffffffc02002c8 <kmonitor>
ffffffffc020019c:	bfed                	j	ffffffffc0200196 <__panic+0x54>

ffffffffc020019e <print_kerninfo>:
ffffffffc020019e:	1141                	addi	sp,sp,-16
ffffffffc02001a0:	00002517          	auipc	a0,0x2
ffffffffc02001a4:	8e050513          	addi	a0,a0,-1824 # ffffffffc0201a80 <etext+0x44>
ffffffffc02001a8:	e406                	sd	ra,8(sp)
ffffffffc02001aa:	f11ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001ae:	00000597          	auipc	a1,0x0
ffffffffc02001b2:	e8458593          	addi	a1,a1,-380 # ffffffffc0200032 <kern_init>
ffffffffc02001b6:	00002517          	auipc	a0,0x2
ffffffffc02001ba:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201aa0 <etext+0x64>
ffffffffc02001be:	efdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001c2:	00002597          	auipc	a1,0x2
ffffffffc02001c6:	87a58593          	addi	a1,a1,-1926 # ffffffffc0201a3c <etext>
ffffffffc02001ca:	00002517          	auipc	a0,0x2
ffffffffc02001ce:	8f650513          	addi	a0,a0,-1802 # ffffffffc0201ac0 <etext+0x84>
ffffffffc02001d2:	ee9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001d6:	00006597          	auipc	a1,0x6
ffffffffc02001da:	e5a58593          	addi	a1,a1,-422 # ffffffffc0206030 <free_area>
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	90250513          	addi	a0,a0,-1790 # ffffffffc0201ae0 <etext+0xa4>
ffffffffc02001e6:	ed5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001ea:	00006597          	auipc	a1,0x6
ffffffffc02001ee:	2ce58593          	addi	a1,a1,718 # ffffffffc02064b8 <end>
ffffffffc02001f2:	00002517          	auipc	a0,0x2
ffffffffc02001f6:	90e50513          	addi	a0,a0,-1778 # ffffffffc0201b00 <etext+0xc4>
ffffffffc02001fa:	ec1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001fe:	00006597          	auipc	a1,0x6
ffffffffc0200202:	6b958593          	addi	a1,a1,1721 # ffffffffc02068b7 <end+0x3ff>
ffffffffc0200206:	00000797          	auipc	a5,0x0
ffffffffc020020a:	e2c78793          	addi	a5,a5,-468 # ffffffffc0200032 <kern_init>
ffffffffc020020e:	40f587b3          	sub	a5,a1,a5
ffffffffc0200212:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	3ff5f593          	andi	a1,a1,1023
ffffffffc020021c:	95be                	add	a1,a1,a5
ffffffffc020021e:	85a9                	srai	a1,a1,0xa
ffffffffc0200220:	00002517          	auipc	a0,0x2
ffffffffc0200224:	90050513          	addi	a0,a0,-1792 # ffffffffc0201b20 <etext+0xe4>
ffffffffc0200228:	0141                	addi	sp,sp,16
ffffffffc020022a:	bd41                	j	ffffffffc02000ba <cprintf>

ffffffffc020022c <print_stackframe>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	00002617          	auipc	a2,0x2
ffffffffc0200232:	92260613          	addi	a2,a2,-1758 # ffffffffc0201b50 <etext+0x114>
ffffffffc0200236:	04e00593          	li	a1,78
ffffffffc020023a:	00002517          	auipc	a0,0x2
ffffffffc020023e:	92e50513          	addi	a0,a0,-1746 # ffffffffc0201b68 <etext+0x12c>
ffffffffc0200242:	e406                	sd	ra,8(sp)
ffffffffc0200244:	effff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200248 <mon_help>:
ffffffffc0200248:	1141                	addi	sp,sp,-16
ffffffffc020024a:	00002617          	auipc	a2,0x2
ffffffffc020024e:	93660613          	addi	a2,a2,-1738 # ffffffffc0201b80 <etext+0x144>
ffffffffc0200252:	00002597          	auipc	a1,0x2
ffffffffc0200256:	94e58593          	addi	a1,a1,-1714 # ffffffffc0201ba0 <etext+0x164>
ffffffffc020025a:	00002517          	auipc	a0,0x2
ffffffffc020025e:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201ba8 <etext+0x16c>
ffffffffc0200262:	e406                	sd	ra,8(sp)
ffffffffc0200264:	e57ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200268:	00002617          	auipc	a2,0x2
ffffffffc020026c:	95060613          	addi	a2,a2,-1712 # ffffffffc0201bb8 <etext+0x17c>
ffffffffc0200270:	00002597          	auipc	a1,0x2
ffffffffc0200274:	97058593          	addi	a1,a1,-1680 # ffffffffc0201be0 <etext+0x1a4>
ffffffffc0200278:	00002517          	auipc	a0,0x2
ffffffffc020027c:	93050513          	addi	a0,a0,-1744 # ffffffffc0201ba8 <etext+0x16c>
ffffffffc0200280:	e3bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200284:	00002617          	auipc	a2,0x2
ffffffffc0200288:	96c60613          	addi	a2,a2,-1684 # ffffffffc0201bf0 <etext+0x1b4>
ffffffffc020028c:	00002597          	auipc	a1,0x2
ffffffffc0200290:	98458593          	addi	a1,a1,-1660 # ffffffffc0201c10 <etext+0x1d4>
ffffffffc0200294:	00002517          	auipc	a0,0x2
ffffffffc0200298:	91450513          	addi	a0,a0,-1772 # ffffffffc0201ba8 <etext+0x16c>
ffffffffc020029c:	e1fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	4501                	li	a0,0
ffffffffc02002a4:	0141                	addi	sp,sp,16
ffffffffc02002a6:	8082                	ret

ffffffffc02002a8 <mon_kerninfo>:
ffffffffc02002a8:	1141                	addi	sp,sp,-16
ffffffffc02002aa:	e406                	sd	ra,8(sp)
ffffffffc02002ac:	ef3ff0ef          	jal	ra,ffffffffc020019e <print_kerninfo>
ffffffffc02002b0:	60a2                	ld	ra,8(sp)
ffffffffc02002b2:	4501                	li	a0,0
ffffffffc02002b4:	0141                	addi	sp,sp,16
ffffffffc02002b6:	8082                	ret

ffffffffc02002b8 <mon_backtrace>:
ffffffffc02002b8:	1141                	addi	sp,sp,-16
ffffffffc02002ba:	e406                	sd	ra,8(sp)
ffffffffc02002bc:	f71ff0ef          	jal	ra,ffffffffc020022c <print_stackframe>
ffffffffc02002c0:	60a2                	ld	ra,8(sp)
ffffffffc02002c2:	4501                	li	a0,0
ffffffffc02002c4:	0141                	addi	sp,sp,16
ffffffffc02002c6:	8082                	ret

ffffffffc02002c8 <kmonitor>:
ffffffffc02002c8:	7115                	addi	sp,sp,-224
ffffffffc02002ca:	ed5e                	sd	s7,152(sp)
ffffffffc02002cc:	8baa                	mv	s7,a0
ffffffffc02002ce:	00002517          	auipc	a0,0x2
ffffffffc02002d2:	95250513          	addi	a0,a0,-1710 # ffffffffc0201c20 <etext+0x1e4>
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
ffffffffc02002ec:	dcfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002f0:	00002517          	auipc	a0,0x2
ffffffffc02002f4:	95850513          	addi	a0,a0,-1704 # ffffffffc0201c48 <etext+0x20c>
ffffffffc02002f8:	dc3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02002fc:	000b8563          	beqz	s7,ffffffffc0200306 <kmonitor+0x3e>
ffffffffc0200300:	855e                	mv	a0,s7
ffffffffc0200302:	348000ef          	jal	ra,ffffffffc020064a <print_trapframe>
ffffffffc0200306:	00002c17          	auipc	s8,0x2
ffffffffc020030a:	9b2c0c13          	addi	s8,s8,-1614 # ffffffffc0201cb8 <commands>
ffffffffc020030e:	00002917          	auipc	s2,0x2
ffffffffc0200312:	96290913          	addi	s2,s2,-1694 # ffffffffc0201c70 <etext+0x234>
ffffffffc0200316:	00002497          	auipc	s1,0x2
ffffffffc020031a:	96248493          	addi	s1,s1,-1694 # ffffffffc0201c78 <etext+0x23c>
ffffffffc020031e:	49bd                	li	s3,15
ffffffffc0200320:	00002b17          	auipc	s6,0x2
ffffffffc0200324:	960b0b13          	addi	s6,s6,-1696 # ffffffffc0201c80 <etext+0x244>
ffffffffc0200328:	00002a17          	auipc	s4,0x2
ffffffffc020032c:	878a0a13          	addi	s4,s4,-1928 # ffffffffc0201ba0 <etext+0x164>
ffffffffc0200330:	4a8d                	li	s5,3
ffffffffc0200332:	854a                	mv	a0,s2
ffffffffc0200334:	5ea010ef          	jal	ra,ffffffffc020191e <readline>
ffffffffc0200338:	842a                	mv	s0,a0
ffffffffc020033a:	dd65                	beqz	a0,ffffffffc0200332 <kmonitor+0x6a>
ffffffffc020033c:	00054583          	lbu	a1,0(a0)
ffffffffc0200340:	4c81                	li	s9,0
ffffffffc0200342:	e1bd                	bnez	a1,ffffffffc02003a8 <kmonitor+0xe0>
ffffffffc0200344:	fe0c87e3          	beqz	s9,ffffffffc0200332 <kmonitor+0x6a>
ffffffffc0200348:	6582                	ld	a1,0(sp)
ffffffffc020034a:	00002d17          	auipc	s10,0x2
ffffffffc020034e:	96ed0d13          	addi	s10,s10,-1682 # ffffffffc0201cb8 <commands>
ffffffffc0200352:	8552                	mv	a0,s4
ffffffffc0200354:	4401                	li	s0,0
ffffffffc0200356:	0d61                	addi	s10,s10,24
ffffffffc0200358:	192010ef          	jal	ra,ffffffffc02014ea <strcmp>
ffffffffc020035c:	c919                	beqz	a0,ffffffffc0200372 <kmonitor+0xaa>
ffffffffc020035e:	2405                	addiw	s0,s0,1
ffffffffc0200360:	0b540063          	beq	s0,s5,ffffffffc0200400 <kmonitor+0x138>
ffffffffc0200364:	000d3503          	ld	a0,0(s10)
ffffffffc0200368:	6582                	ld	a1,0(sp)
ffffffffc020036a:	0d61                	addi	s10,s10,24
ffffffffc020036c:	17e010ef          	jal	ra,ffffffffc02014ea <strcmp>
ffffffffc0200370:	f57d                	bnez	a0,ffffffffc020035e <kmonitor+0x96>
ffffffffc0200372:	00141793          	slli	a5,s0,0x1
ffffffffc0200376:	97a2                	add	a5,a5,s0
ffffffffc0200378:	078e                	slli	a5,a5,0x3
ffffffffc020037a:	97e2                	add	a5,a5,s8
ffffffffc020037c:	6b9c                	ld	a5,16(a5)
ffffffffc020037e:	865e                	mv	a2,s7
ffffffffc0200380:	002c                	addi	a1,sp,8
ffffffffc0200382:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200386:	9782                	jalr	a5
ffffffffc0200388:	fa0555e3          	bgez	a0,ffffffffc0200332 <kmonitor+0x6a>
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
ffffffffc02003a8:	8526                	mv	a0,s1
ffffffffc02003aa:	15e010ef          	jal	ra,ffffffffc0201508 <strchr>
ffffffffc02003ae:	c901                	beqz	a0,ffffffffc02003be <kmonitor+0xf6>
ffffffffc02003b0:	00144583          	lbu	a1,1(s0)
ffffffffc02003b4:	00040023          	sb	zero,0(s0)
ffffffffc02003b8:	0405                	addi	s0,s0,1
ffffffffc02003ba:	d5c9                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003bc:	b7f5                	j	ffffffffc02003a8 <kmonitor+0xe0>
ffffffffc02003be:	00044783          	lbu	a5,0(s0)
ffffffffc02003c2:	d3c9                	beqz	a5,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003c4:	033c8963          	beq	s9,s3,ffffffffc02003f6 <kmonitor+0x12e>
ffffffffc02003c8:	003c9793          	slli	a5,s9,0x3
ffffffffc02003cc:	0118                	addi	a4,sp,128
ffffffffc02003ce:	97ba                	add	a5,a5,a4
ffffffffc02003d0:	f887b023          	sd	s0,-128(a5)
ffffffffc02003d4:	00044583          	lbu	a1,0(s0)
ffffffffc02003d8:	2c85                	addiw	s9,s9,1
ffffffffc02003da:	e591                	bnez	a1,ffffffffc02003e6 <kmonitor+0x11e>
ffffffffc02003dc:	b7b5                	j	ffffffffc0200348 <kmonitor+0x80>
ffffffffc02003de:	00144583          	lbu	a1,1(s0)
ffffffffc02003e2:	0405                	addi	s0,s0,1
ffffffffc02003e4:	d1a5                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003e6:	8526                	mv	a0,s1
ffffffffc02003e8:	120010ef          	jal	ra,ffffffffc0201508 <strchr>
ffffffffc02003ec:	d96d                	beqz	a0,ffffffffc02003de <kmonitor+0x116>
ffffffffc02003ee:	00044583          	lbu	a1,0(s0)
ffffffffc02003f2:	d9a9                	beqz	a1,ffffffffc0200344 <kmonitor+0x7c>
ffffffffc02003f4:	bf55                	j	ffffffffc02003a8 <kmonitor+0xe0>
ffffffffc02003f6:	45c1                	li	a1,16
ffffffffc02003f8:	855a                	mv	a0,s6
ffffffffc02003fa:	cc1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003fe:	b7e9                	j	ffffffffc02003c8 <kmonitor+0x100>
ffffffffc0200400:	6582                	ld	a1,0(sp)
ffffffffc0200402:	00002517          	auipc	a0,0x2
ffffffffc0200406:	89e50513          	addi	a0,a0,-1890 # ffffffffc0201ca0 <etext+0x264>
ffffffffc020040a:	cb1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020040e:	b715                	j	ffffffffc0200332 <kmonitor+0x6a>

ffffffffc0200410 <clock_init>:
ffffffffc0200410:	1141                	addi	sp,sp,-16
ffffffffc0200412:	e406                	sd	ra,8(sp)
ffffffffc0200414:	02000793          	li	a5,32
ffffffffc0200418:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020041c:	c0102573          	rdtime	a0
ffffffffc0200420:	67e1                	lui	a5,0x18
ffffffffc0200422:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200426:	953e                	add	a0,a0,a5
ffffffffc0200428:	5c4010ef          	jal	ra,ffffffffc02019ec <sbi_set_timer>
ffffffffc020042c:	60a2                	ld	ra,8(sp)
ffffffffc020042e:	00006797          	auipc	a5,0x6
ffffffffc0200432:	0207b123          	sd	zero,34(a5) # ffffffffc0206450 <ticks>
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201d00 <commands+0x48>
ffffffffc020043e:	0141                	addi	sp,sp,16
ffffffffc0200440:	b9ad                	j	ffffffffc02000ba <cprintf>

ffffffffc0200442 <clock_set_next_event>:
ffffffffc0200442:	c0102573          	rdtime	a0
ffffffffc0200446:	67e1                	lui	a5,0x18
ffffffffc0200448:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020044c:	953e                	add	a0,a0,a5
ffffffffc020044e:	59e0106f          	j	ffffffffc02019ec <sbi_set_timer>

ffffffffc0200452 <cons_init>:
ffffffffc0200452:	8082                	ret

ffffffffc0200454 <cons_putc>:
ffffffffc0200454:	0ff57513          	zext.b	a0,a0
ffffffffc0200458:	57a0106f          	j	ffffffffc02019d2 <sbi_console_putchar>

ffffffffc020045c <cons_getc>:
ffffffffc020045c:	5aa0106f          	j	ffffffffc0201a06 <sbi_console_getchar>

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
ffffffffc020048a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201d20 <commands+0x68>
ffffffffc020048e:	e406                	sd	ra,8(sp)
ffffffffc0200490:	c2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200494:	640c                	ld	a1,8(s0)
ffffffffc0200496:	00002517          	auipc	a0,0x2
ffffffffc020049a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201d38 <commands+0x80>
ffffffffc020049e:	c1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004a2:	680c                	ld	a1,16(s0)
ffffffffc02004a4:	00002517          	auipc	a0,0x2
ffffffffc02004a8:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0201d50 <commands+0x98>
ffffffffc02004ac:	c0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004b0:	6c0c                	ld	a1,24(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201d68 <commands+0xb0>
ffffffffc02004ba:	c01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004be:	700c                	ld	a1,32(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	8c050513          	addi	a0,a0,-1856 # ffffffffc0201d80 <commands+0xc8>
ffffffffc02004c8:	bf3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004cc:	740c                	ld	a1,40(s0)
ffffffffc02004ce:	00002517          	auipc	a0,0x2
ffffffffc02004d2:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201d98 <commands+0xe0>
ffffffffc02004d6:	be5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004da:	780c                	ld	a1,48(s0)
ffffffffc02004dc:	00002517          	auipc	a0,0x2
ffffffffc02004e0:	8d450513          	addi	a0,a0,-1836 # ffffffffc0201db0 <commands+0xf8>
ffffffffc02004e4:	bd7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004e8:	7c0c                	ld	a1,56(s0)
ffffffffc02004ea:	00002517          	auipc	a0,0x2
ffffffffc02004ee:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201dc8 <commands+0x110>
ffffffffc02004f2:	bc9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02004f6:	602c                	ld	a1,64(s0)
ffffffffc02004f8:	00002517          	auipc	a0,0x2
ffffffffc02004fc:	8e850513          	addi	a0,a0,-1816 # ffffffffc0201de0 <commands+0x128>
ffffffffc0200500:	bbbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200504:	642c                	ld	a1,72(s0)
ffffffffc0200506:	00002517          	auipc	a0,0x2
ffffffffc020050a:	8f250513          	addi	a0,a0,-1806 # ffffffffc0201df8 <commands+0x140>
ffffffffc020050e:	badff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200512:	682c                	ld	a1,80(s0)
ffffffffc0200514:	00002517          	auipc	a0,0x2
ffffffffc0200518:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0201e10 <commands+0x158>
ffffffffc020051c:	b9fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200520:	6c2c                	ld	a1,88(s0)
ffffffffc0200522:	00002517          	auipc	a0,0x2
ffffffffc0200526:	90650513          	addi	a0,a0,-1786 # ffffffffc0201e28 <commands+0x170>
ffffffffc020052a:	b91ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020052e:	702c                	ld	a1,96(s0)
ffffffffc0200530:	00002517          	auipc	a0,0x2
ffffffffc0200534:	91050513          	addi	a0,a0,-1776 # ffffffffc0201e40 <commands+0x188>
ffffffffc0200538:	b83ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020053c:	742c                	ld	a1,104(s0)
ffffffffc020053e:	00002517          	auipc	a0,0x2
ffffffffc0200542:	91a50513          	addi	a0,a0,-1766 # ffffffffc0201e58 <commands+0x1a0>
ffffffffc0200546:	b75ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020054a:	782c                	ld	a1,112(s0)
ffffffffc020054c:	00002517          	auipc	a0,0x2
ffffffffc0200550:	92450513          	addi	a0,a0,-1756 # ffffffffc0201e70 <commands+0x1b8>
ffffffffc0200554:	b67ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200558:	7c2c                	ld	a1,120(s0)
ffffffffc020055a:	00002517          	auipc	a0,0x2
ffffffffc020055e:	92e50513          	addi	a0,a0,-1746 # ffffffffc0201e88 <commands+0x1d0>
ffffffffc0200562:	b59ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200566:	604c                	ld	a1,128(s0)
ffffffffc0200568:	00002517          	auipc	a0,0x2
ffffffffc020056c:	93850513          	addi	a0,a0,-1736 # ffffffffc0201ea0 <commands+0x1e8>
ffffffffc0200570:	b4bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200574:	644c                	ld	a1,136(s0)
ffffffffc0200576:	00002517          	auipc	a0,0x2
ffffffffc020057a:	94250513          	addi	a0,a0,-1726 # ffffffffc0201eb8 <commands+0x200>
ffffffffc020057e:	b3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200582:	684c                	ld	a1,144(s0)
ffffffffc0200584:	00002517          	auipc	a0,0x2
ffffffffc0200588:	94c50513          	addi	a0,a0,-1716 # ffffffffc0201ed0 <commands+0x218>
ffffffffc020058c:	b2fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200590:	6c4c                	ld	a1,152(s0)
ffffffffc0200592:	00002517          	auipc	a0,0x2
ffffffffc0200596:	95650513          	addi	a0,a0,-1706 # ffffffffc0201ee8 <commands+0x230>
ffffffffc020059a:	b21ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020059e:	704c                	ld	a1,160(s0)
ffffffffc02005a0:	00002517          	auipc	a0,0x2
ffffffffc02005a4:	96050513          	addi	a0,a0,-1696 # ffffffffc0201f00 <commands+0x248>
ffffffffc02005a8:	b13ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ac:	744c                	ld	a1,168(s0)
ffffffffc02005ae:	00002517          	auipc	a0,0x2
ffffffffc02005b2:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201f18 <commands+0x260>
ffffffffc02005b6:	b05ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ba:	784c                	ld	a1,176(s0)
ffffffffc02005bc:	00002517          	auipc	a0,0x2
ffffffffc02005c0:	97450513          	addi	a0,a0,-1676 # ffffffffc0201f30 <commands+0x278>
ffffffffc02005c4:	af7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005c8:	7c4c                	ld	a1,184(s0)
ffffffffc02005ca:	00002517          	auipc	a0,0x2
ffffffffc02005ce:	97e50513          	addi	a0,a0,-1666 # ffffffffc0201f48 <commands+0x290>
ffffffffc02005d2:	ae9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005d6:	606c                	ld	a1,192(s0)
ffffffffc02005d8:	00002517          	auipc	a0,0x2
ffffffffc02005dc:	98850513          	addi	a0,a0,-1656 # ffffffffc0201f60 <commands+0x2a8>
ffffffffc02005e0:	adbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005e4:	646c                	ld	a1,200(s0)
ffffffffc02005e6:	00002517          	auipc	a0,0x2
ffffffffc02005ea:	99250513          	addi	a0,a0,-1646 # ffffffffc0201f78 <commands+0x2c0>
ffffffffc02005ee:	acdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005f2:	686c                	ld	a1,208(s0)
ffffffffc02005f4:	00002517          	auipc	a0,0x2
ffffffffc02005f8:	99c50513          	addi	a0,a0,-1636 # ffffffffc0201f90 <commands+0x2d8>
ffffffffc02005fc:	abfff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200600:	6c6c                	ld	a1,216(s0)
ffffffffc0200602:	00002517          	auipc	a0,0x2
ffffffffc0200606:	9a650513          	addi	a0,a0,-1626 # ffffffffc0201fa8 <commands+0x2f0>
ffffffffc020060a:	ab1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020060e:	706c                	ld	a1,224(s0)
ffffffffc0200610:	00002517          	auipc	a0,0x2
ffffffffc0200614:	9b050513          	addi	a0,a0,-1616 # ffffffffc0201fc0 <commands+0x308>
ffffffffc0200618:	aa3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020061c:	746c                	ld	a1,232(s0)
ffffffffc020061e:	00002517          	auipc	a0,0x2
ffffffffc0200622:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0201fd8 <commands+0x320>
ffffffffc0200626:	a95ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020062a:	786c                	ld	a1,240(s0)
ffffffffc020062c:	00002517          	auipc	a0,0x2
ffffffffc0200630:	9c450513          	addi	a0,a0,-1596 # ffffffffc0201ff0 <commands+0x338>
ffffffffc0200634:	a87ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200638:	7c6c                	ld	a1,248(s0)
ffffffffc020063a:	6402                	ld	s0,0(sp)
ffffffffc020063c:	60a2                	ld	ra,8(sp)
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0202008 <commands+0x350>
ffffffffc0200646:	0141                	addi	sp,sp,16
ffffffffc0200648:	bc8d                	j	ffffffffc02000ba <cprintf>

ffffffffc020064a <print_trapframe>:
ffffffffc020064a:	1141                	addi	sp,sp,-16
ffffffffc020064c:	e022                	sd	s0,0(sp)
ffffffffc020064e:	85aa                	mv	a1,a0
ffffffffc0200650:	842a                	mv	s0,a0
ffffffffc0200652:	00002517          	auipc	a0,0x2
ffffffffc0200656:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0202020 <commands+0x368>
ffffffffc020065a:	e406                	sd	ra,8(sp)
ffffffffc020065c:	a5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200660:	8522                	mv	a0,s0
ffffffffc0200662:	e1dff0ef          	jal	ra,ffffffffc020047e <print_regs>
ffffffffc0200666:	10043583          	ld	a1,256(s0)
ffffffffc020066a:	00002517          	auipc	a0,0x2
ffffffffc020066e:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0202038 <commands+0x380>
ffffffffc0200672:	a49ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200676:	10843583          	ld	a1,264(s0)
ffffffffc020067a:	00002517          	auipc	a0,0x2
ffffffffc020067e:	9d650513          	addi	a0,a0,-1578 # ffffffffc0202050 <commands+0x398>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200686:	11043583          	ld	a1,272(s0)
ffffffffc020068a:	00002517          	auipc	a0,0x2
ffffffffc020068e:	9de50513          	addi	a0,a0,-1570 # ffffffffc0202068 <commands+0x3b0>
ffffffffc0200692:	a29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200696:	11843583          	ld	a1,280(s0)
ffffffffc020069a:	6402                	ld	s0,0(sp)
ffffffffc020069c:	60a2                	ld	ra,8(sp)
ffffffffc020069e:	00002517          	auipc	a0,0x2
ffffffffc02006a2:	9e250513          	addi	a0,a0,-1566 # ffffffffc0202080 <commands+0x3c8>
ffffffffc02006a6:	0141                	addi	sp,sp,16
ffffffffc02006a8:	bc09                	j	ffffffffc02000ba <cprintf>

ffffffffc02006aa <interrupt_handler>:
ffffffffc02006aa:	11853783          	ld	a5,280(a0)
ffffffffc02006ae:	472d                	li	a4,11
ffffffffc02006b0:	0786                	slli	a5,a5,0x1
ffffffffc02006b2:	8385                	srli	a5,a5,0x1
ffffffffc02006b4:	08f76663          	bltu	a4,a5,ffffffffc0200740 <interrupt_handler+0x96>
ffffffffc02006b8:	00002717          	auipc	a4,0x2
ffffffffc02006bc:	aa870713          	addi	a4,a4,-1368 # ffffffffc0202160 <commands+0x4a8>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	a2e50513          	addi	a0,a0,-1490 # ffffffffc02020f8 <commands+0x440>
ffffffffc02006d2:	b2e5                	j	ffffffffc02000ba <cprintf>
ffffffffc02006d4:	00002517          	auipc	a0,0x2
ffffffffc02006d8:	a0450513          	addi	a0,a0,-1532 # ffffffffc02020d8 <commands+0x420>
ffffffffc02006dc:	baf9                	j	ffffffffc02000ba <cprintf>
ffffffffc02006de:	00002517          	auipc	a0,0x2
ffffffffc02006e2:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0202098 <commands+0x3e0>
ffffffffc02006e6:	bad1                	j	ffffffffc02000ba <cprintf>
ffffffffc02006e8:	00002517          	auipc	a0,0x2
ffffffffc02006ec:	a3050513          	addi	a0,a0,-1488 # ffffffffc0202118 <commands+0x460>
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
ffffffffc0200730:	a1450513          	addi	a0,a0,-1516 # ffffffffc0202140 <commands+0x488>
ffffffffc0200734:	b259                	j	ffffffffc02000ba <cprintf>
ffffffffc0200736:	00002517          	auipc	a0,0x2
ffffffffc020073a:	98250513          	addi	a0,a0,-1662 # ffffffffc02020b8 <commands+0x400>
ffffffffc020073e:	bab5                	j	ffffffffc02000ba <cprintf>
ffffffffc0200740:	b729                	j	ffffffffc020064a <print_trapframe>
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	9ea50513          	addi	a0,a0,-1558 # ffffffffc0202130 <commands+0x478>
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
ffffffffc0200768:	2ba0106f          	j	ffffffffc0201a22 <sbi_shutdown>

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
ffffffffc020078c:	a0850513          	addi	a0,a0,-1528 # ffffffffc0202190 <commands+0x4d8>
ffffffffc0200790:	92bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200794:	10843583          	ld	a1,264(s0)
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	a2050513          	addi	a0,a0,-1504 # ffffffffc02021b8 <commands+0x500>
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
ffffffffc02007ca:	a1a50513          	addi	a0,a0,-1510 # ffffffffc02021e0 <commands+0x528>
ffffffffc02007ce:	8edff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02007d2:	10843583          	ld	a1,264(s0)
ffffffffc02007d6:	00002517          	auipc	a0,0x2
ffffffffc02007da:	9e250513          	addi	a0,a0,-1566 # ffffffffc02021b8 <commands+0x500>
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
ffffffffc0200936:	ca678793          	addi	a5,a5,-858 # ffffffffc02025d8 <buddy_pmm_manager>
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
ffffffffc0200944:	8c050513          	addi	a0,a0,-1856 # ffffffffc0202200 <commands+0x548>
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
ffffffffc0200970:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0202218 <commands+0x560>
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
ffffffffc020098e:	8a650513          	addi	a0,a0,-1882 # ffffffffc0202230 <commands+0x578>
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
ffffffffc0200a10:	8bc50513          	addi	a0,a0,-1860 # ffffffffc02022c8 <commands+0x610>
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
ffffffffc0200a48:	8a450513          	addi	a0,a0,-1884 # ffffffffc02022e8 <commands+0x630>
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
ffffffffc0200a7c:	00002617          	auipc	a2,0x2
ffffffffc0200a80:	81c60613          	addi	a2,a2,-2020 # ffffffffc0202298 <commands+0x5e0>
ffffffffc0200a84:	06b00593          	li	a1,107
ffffffffc0200a88:	00002517          	auipc	a0,0x2
ffffffffc0200a8c:	83050513          	addi	a0,a0,-2000 # ffffffffc02022b8 <commands+0x600>
ffffffffc0200a90:	eb2ff0ef          	jal	ra,ffffffffc0200142 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a94:	00001617          	auipc	a2,0x1
ffffffffc0200a98:	7cc60613          	addi	a2,a2,1996 # ffffffffc0202260 <commands+0x5a8>
ffffffffc0200a9c:	07200593          	li	a1,114
ffffffffc0200aa0:	00001517          	auipc	a0,0x1
ffffffffc0200aa4:	7e850513          	addi	a0,a0,2024 # ffffffffc0202288 <commands+0x5d0>
ffffffffc0200aa8:	e9aff0ef          	jal	ra,ffffffffc0200142 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200aac:	86ae                	mv	a3,a1
ffffffffc0200aae:	00001617          	auipc	a2,0x1
ffffffffc0200ab2:	7b260613          	addi	a2,a2,1970 # ffffffffc0202260 <commands+0x5a8>
ffffffffc0200ab6:	08d00593          	li	a1,141
ffffffffc0200aba:	00001517          	auipc	a0,0x1
ffffffffc0200abe:	7ce50513          	addi	a0,a0,1998 # ffffffffc0202288 <commands+0x5d0>
ffffffffc0200ac2:	e80ff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200ac6 <obj_free>:
ffffffffc0200ac6:	cd1d                	beqz	a0,ffffffffc0200b04 <obj_free+0x3e>
ffffffffc0200ac8:	ed9d                	bnez	a1,ffffffffc0200b06 <obj_free+0x40>
ffffffffc0200aca:	4114                	lw	a3,0(a0)
ffffffffc0200acc:	00005597          	auipc	a1,0x5
ffffffffc0200ad0:	54458593          	addi	a1,a1,1348 # ffffffffc0206010 <objfree>
ffffffffc0200ad4:	619c                	ld	a5,0(a1)
ffffffffc0200ad6:	873e                	mv	a4,a5
ffffffffc0200ad8:	679c                	ld	a5,8(a5)
ffffffffc0200ada:	02a77b63          	bgeu	a4,a0,ffffffffc0200b10 <obj_free+0x4a>
ffffffffc0200ade:	00f56463          	bltu	a0,a5,ffffffffc0200ae6 <obj_free+0x20>
ffffffffc0200ae2:	fef76ae3          	bltu	a4,a5,ffffffffc0200ad6 <obj_free+0x10>
ffffffffc0200ae6:	00469613          	slli	a2,a3,0x4
ffffffffc0200aea:	962a                	add	a2,a2,a0
ffffffffc0200aec:	02c78b63          	beq	a5,a2,ffffffffc0200b22 <obj_free+0x5c>
ffffffffc0200af0:	4314                	lw	a3,0(a4)
ffffffffc0200af2:	e51c                	sd	a5,8(a0)
ffffffffc0200af4:	00469793          	slli	a5,a3,0x4
ffffffffc0200af8:	97ba                	add	a5,a5,a4
ffffffffc0200afa:	02f50f63          	beq	a0,a5,ffffffffc0200b38 <obj_free+0x72>
ffffffffc0200afe:	e708                	sd	a0,8(a4)
ffffffffc0200b00:	e198                	sd	a4,0(a1)
ffffffffc0200b02:	8082                	ret
ffffffffc0200b04:	8082                	ret
ffffffffc0200b06:	00f5869b          	addiw	a3,a1,15
ffffffffc0200b0a:	8691                	srai	a3,a3,0x4
ffffffffc0200b0c:	c114                	sw	a3,0(a0)
ffffffffc0200b0e:	bf7d                	j	ffffffffc0200acc <obj_free+0x6>
ffffffffc0200b10:	fcf763e3          	bltu	a4,a5,ffffffffc0200ad6 <obj_free+0x10>
ffffffffc0200b14:	fcf571e3          	bgeu	a0,a5,ffffffffc0200ad6 <obj_free+0x10>
ffffffffc0200b18:	00469613          	slli	a2,a3,0x4
ffffffffc0200b1c:	962a                	add	a2,a2,a0
ffffffffc0200b1e:	fcc799e3          	bne	a5,a2,ffffffffc0200af0 <obj_free+0x2a>
ffffffffc0200b22:	4390                	lw	a2,0(a5)
ffffffffc0200b24:	679c                	ld	a5,8(a5)
ffffffffc0200b26:	9eb1                	addw	a3,a3,a2
ffffffffc0200b28:	c114                	sw	a3,0(a0)
ffffffffc0200b2a:	4314                	lw	a3,0(a4)
ffffffffc0200b2c:	e51c                	sd	a5,8(a0)
ffffffffc0200b2e:	00469793          	slli	a5,a3,0x4
ffffffffc0200b32:	97ba                	add	a5,a5,a4
ffffffffc0200b34:	fcf515e3          	bne	a0,a5,ffffffffc0200afe <obj_free+0x38>
ffffffffc0200b38:	411c                	lw	a5,0(a0)
ffffffffc0200b3a:	6510                	ld	a2,8(a0)
ffffffffc0200b3c:	e198                	sd	a4,0(a1)
ffffffffc0200b3e:	9ebd                	addw	a3,a3,a5
ffffffffc0200b40:	c314                	sw	a3,0(a4)
ffffffffc0200b42:	e710                	sd	a2,8(a4)
ffffffffc0200b44:	8082                	ret

ffffffffc0200b46 <obj_alloc>:
ffffffffc0200b46:	1101                	addi	sp,sp,-32
ffffffffc0200b48:	ec06                	sd	ra,24(sp)
ffffffffc0200b4a:	e822                	sd	s0,16(sp)
ffffffffc0200b4c:	e426                	sd	s1,8(sp)
ffffffffc0200b4e:	e04a                	sd	s2,0(sp)
ffffffffc0200b50:	6785                	lui	a5,0x1
ffffffffc0200b52:	08f57363          	bgeu	a0,a5,ffffffffc0200bd8 <obj_alloc+0x92>
ffffffffc0200b56:	00005417          	auipc	s0,0x5
ffffffffc0200b5a:	4ba40413          	addi	s0,s0,1210 # ffffffffc0206010 <objfree>
ffffffffc0200b5e:	6010                	ld	a2,0(s0)
ffffffffc0200b60:	053d                	addi	a0,a0,15
ffffffffc0200b62:	00455913          	srli	s2,a0,0x4
ffffffffc0200b66:	6618                	ld	a4,8(a2)
ffffffffc0200b68:	0009049b          	sext.w	s1,s2
ffffffffc0200b6c:	4314                	lw	a3,0(a4)
ffffffffc0200b6e:	0696d263          	bge	a3,s1,ffffffffc0200bd2 <obj_alloc+0x8c>
ffffffffc0200b72:	00e60a63          	beq	a2,a4,ffffffffc0200b86 <obj_alloc+0x40>
ffffffffc0200b76:	671c                	ld	a5,8(a4)
ffffffffc0200b78:	4394                	lw	a3,0(a5)
ffffffffc0200b7a:	0296d363          	bge	a3,s1,ffffffffc0200ba0 <obj_alloc+0x5a>
ffffffffc0200b7e:	6010                	ld	a2,0(s0)
ffffffffc0200b80:	873e                	mv	a4,a5
ffffffffc0200b82:	fee61ae3          	bne	a2,a4,ffffffffc0200b76 <obj_alloc+0x30>
ffffffffc0200b86:	4505                	li	a0,1
ffffffffc0200b88:	d2fff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc0200b8c:	87aa                	mv	a5,a0
ffffffffc0200b8e:	c51d                	beqz	a0,ffffffffc0200bbc <obj_alloc+0x76>
ffffffffc0200b90:	6585                	lui	a1,0x1
ffffffffc0200b92:	f35ff0ef          	jal	ra,ffffffffc0200ac6 <obj_free>
ffffffffc0200b96:	6018                	ld	a4,0(s0)
ffffffffc0200b98:	671c                	ld	a5,8(a4)
ffffffffc0200b9a:	4394                	lw	a3,0(a5)
ffffffffc0200b9c:	fe96c1e3          	blt	a3,s1,ffffffffc0200b7e <obj_alloc+0x38>
ffffffffc0200ba0:	02d48563          	beq	s1,a3,ffffffffc0200bca <obj_alloc+0x84>
ffffffffc0200ba4:	0912                	slli	s2,s2,0x4
ffffffffc0200ba6:	993e                	add	s2,s2,a5
ffffffffc0200ba8:	01273423          	sd	s2,8(a4) # fffffffffffff008 <end+0x3fdf8b50>
ffffffffc0200bac:	6790                	ld	a2,8(a5)
ffffffffc0200bae:	9e85                	subw	a3,a3,s1
ffffffffc0200bb0:	00d92023          	sw	a3,0(s2)
ffffffffc0200bb4:	00c93423          	sd	a2,8(s2)
ffffffffc0200bb8:	c384                	sw	s1,0(a5)
ffffffffc0200bba:	e018                	sd	a4,0(s0)
ffffffffc0200bbc:	60e2                	ld	ra,24(sp)
ffffffffc0200bbe:	6442                	ld	s0,16(sp)
ffffffffc0200bc0:	64a2                	ld	s1,8(sp)
ffffffffc0200bc2:	6902                	ld	s2,0(sp)
ffffffffc0200bc4:	853e                	mv	a0,a5
ffffffffc0200bc6:	6105                	addi	sp,sp,32
ffffffffc0200bc8:	8082                	ret
ffffffffc0200bca:	6794                	ld	a3,8(a5)
ffffffffc0200bcc:	e018                	sd	a4,0(s0)
ffffffffc0200bce:	e714                	sd	a3,8(a4)
ffffffffc0200bd0:	b7f5                	j	ffffffffc0200bbc <obj_alloc+0x76>
ffffffffc0200bd2:	87ba                	mv	a5,a4
ffffffffc0200bd4:	8732                	mv	a4,a2
ffffffffc0200bd6:	b7e9                	j	ffffffffc0200ba0 <obj_alloc+0x5a>
ffffffffc0200bd8:	00001697          	auipc	a3,0x1
ffffffffc0200bdc:	75068693          	addi	a3,a3,1872 # ffffffffc0202328 <commands+0x670>
ffffffffc0200be0:	00001617          	auipc	a2,0x1
ffffffffc0200be4:	75860613          	addi	a2,a2,1880 # ffffffffc0202338 <commands+0x680>
ffffffffc0200be8:	04a00593          	li	a1,74
ffffffffc0200bec:	00001517          	auipc	a0,0x1
ffffffffc0200bf0:	76450513          	addi	a0,a0,1892 # ffffffffc0202350 <commands+0x698>
ffffffffc0200bf4:	d4eff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200bf8 <slub_alloc.part.0>:
ffffffffc0200bf8:	1101                	addi	sp,sp,-32
ffffffffc0200bfa:	e822                	sd	s0,16(sp)
ffffffffc0200bfc:	842a                	mv	s0,a0
ffffffffc0200bfe:	02000513          	li	a0,32
ffffffffc0200c02:	ec06                	sd	ra,24(sp)
ffffffffc0200c04:	e426                	sd	s1,8(sp)
ffffffffc0200c06:	f41ff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
ffffffffc0200c0a:	cd05                	beqz	a0,ffffffffc0200c42 <slub_alloc.part.0+0x4a>
ffffffffc0200c0c:	fff40793          	addi	a5,s0,-1
ffffffffc0200c10:	83b1                	srli	a5,a5,0xc
ffffffffc0200c12:	84aa                	mv	s1,a0
ffffffffc0200c14:	0017851b          	addiw	a0,a5,1
ffffffffc0200c18:	c088                	sw	a0,0(s1)
ffffffffc0200c1a:	c9dff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc0200c1e:	4785                	li	a5,1
ffffffffc0200c20:	e488                	sd	a0,8(s1)
ffffffffc0200c22:	cc9c                	sw	a5,24(s1)
ffffffffc0200c24:	842a                	mv	s0,a0
ffffffffc0200c26:	c50d                	beqz	a0,ffffffffc0200c50 <slub_alloc.part.0+0x58>
ffffffffc0200c28:	00006797          	auipc	a5,0x6
ffffffffc0200c2c:	86878793          	addi	a5,a5,-1944 # ffffffffc0206490 <bigblocks_head>
ffffffffc0200c30:	6398                	ld	a4,0(a5)
ffffffffc0200c32:	60e2                	ld	ra,24(sp)
ffffffffc0200c34:	8522                	mv	a0,s0
ffffffffc0200c36:	6442                	ld	s0,16(sp)
ffffffffc0200c38:	e384                	sd	s1,0(a5)
ffffffffc0200c3a:	e898                	sd	a4,16(s1)
ffffffffc0200c3c:	64a2                	ld	s1,8(sp)
ffffffffc0200c3e:	6105                	addi	sp,sp,32
ffffffffc0200c40:	8082                	ret
ffffffffc0200c42:	4401                	li	s0,0
ffffffffc0200c44:	60e2                	ld	ra,24(sp)
ffffffffc0200c46:	8522                	mv	a0,s0
ffffffffc0200c48:	6442                	ld	s0,16(sp)
ffffffffc0200c4a:	64a2                	ld	s1,8(sp)
ffffffffc0200c4c:	6105                	addi	sp,sp,32
ffffffffc0200c4e:	8082                	ret
ffffffffc0200c50:	8526                	mv	a0,s1
ffffffffc0200c52:	02000593          	li	a1,32
ffffffffc0200c56:	e71ff0ef          	jal	ra,ffffffffc0200ac6 <obj_free>
ffffffffc0200c5a:	60e2                	ld	ra,24(sp)
ffffffffc0200c5c:	8522                	mv	a0,s0
ffffffffc0200c5e:	6442                	ld	s0,16(sp)
ffffffffc0200c60:	64a2                	ld	s1,8(sp)
ffffffffc0200c62:	6105                	addi	sp,sp,32
ffffffffc0200c64:	8082                	ret

ffffffffc0200c66 <slub_free>:
ffffffffc0200c66:	cd21                	beqz	a0,ffffffffc0200cbe <slub_free+0x58>
ffffffffc0200c68:	03451793          	slli	a5,a0,0x34
ffffffffc0200c6c:	e7b1                	bnez	a5,ffffffffc0200cb8 <slub_free+0x52>
ffffffffc0200c6e:	1141                	addi	sp,sp,-16
ffffffffc0200c70:	00006717          	auipc	a4,0x6
ffffffffc0200c74:	82070713          	addi	a4,a4,-2016 # ffffffffc0206490 <bigblocks_head>
ffffffffc0200c78:	e022                	sd	s0,0(sp)
ffffffffc0200c7a:	6300                	ld	s0,0(a4)
ffffffffc0200c7c:	e406                	sd	ra,8(sp)
ffffffffc0200c7e:	e411                	bnez	s0,ffffffffc0200c8a <slub_free+0x24>
ffffffffc0200c80:	a035                	j	ffffffffc0200cac <slub_free+0x46>
ffffffffc0200c82:	01040713          	addi	a4,s0,16
ffffffffc0200c86:	6800                	ld	s0,16(s0)
ffffffffc0200c88:	c015                	beqz	s0,ffffffffc0200cac <slub_free+0x46>
ffffffffc0200c8a:	641c                	ld	a5,8(s0)
ffffffffc0200c8c:	fea79be3          	bne	a5,a0,ffffffffc0200c82 <slub_free+0x1c>
ffffffffc0200c90:	4c1c                	lw	a5,24(s0)
ffffffffc0200c92:	dbe5                	beqz	a5,ffffffffc0200c82 <slub_free+0x1c>
ffffffffc0200c94:	681c                	ld	a5,16(s0)
ffffffffc0200c96:	400c                	lw	a1,0(s0)
ffffffffc0200c98:	e31c                	sd	a5,0(a4)
ffffffffc0200c9a:	c5bff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
ffffffffc0200c9e:	8522                	mv	a0,s0
ffffffffc0200ca0:	6402                	ld	s0,0(sp)
ffffffffc0200ca2:	60a2                	ld	ra,8(sp)
ffffffffc0200ca4:	02000593          	li	a1,32
ffffffffc0200ca8:	0141                	addi	sp,sp,16
ffffffffc0200caa:	bd31                	j	ffffffffc0200ac6 <obj_free>
ffffffffc0200cac:	6402                	ld	s0,0(sp)
ffffffffc0200cae:	60a2                	ld	ra,8(sp)
ffffffffc0200cb0:	4581                	li	a1,0
ffffffffc0200cb2:	1541                	addi	a0,a0,-16
ffffffffc0200cb4:	0141                	addi	sp,sp,16
ffffffffc0200cb6:	bd01                	j	ffffffffc0200ac6 <obj_free>
ffffffffc0200cb8:	4581                	li	a1,0
ffffffffc0200cba:	1541                	addi	a0,a0,-16
ffffffffc0200cbc:	b529                	j	ffffffffc0200ac6 <obj_free>
ffffffffc0200cbe:	8082                	ret

ffffffffc0200cc0 <slub_init>:
ffffffffc0200cc0:	00001517          	auipc	a0,0x1
ffffffffc0200cc4:	6a850513          	addi	a0,a0,1704 # ffffffffc0202368 <commands+0x6b0>
ffffffffc0200cc8:	bf2ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200ccc <print_objs>:
ffffffffc0200ccc:	7179                	addi	sp,sp,-48
ffffffffc0200cce:	00001517          	auipc	a0,0x1
ffffffffc0200cd2:	6b250513          	addi	a0,a0,1714 # ffffffffc0202380 <commands+0x6c8>
ffffffffc0200cd6:	f022                	sd	s0,32(sp)
ffffffffc0200cd8:	ec26                	sd	s1,24(sp)
ffffffffc0200cda:	e84a                	sd	s2,16(sp)
ffffffffc0200cdc:	f406                	sd	ra,40(sp)
ffffffffc0200cde:	e44e                	sd	s3,8(sp)
ffffffffc0200ce0:	00005917          	auipc	s2,0x5
ffffffffc0200ce4:	33090913          	addi	s2,s2,816 # ffffffffc0206010 <objfree>
ffffffffc0200ce8:	bd2ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200cec:	00093783          	ld	a5,0(s2)
ffffffffc0200cf0:	4481                	li	s1,0
ffffffffc0200cf2:	6780                	ld	s0,8(a5)
ffffffffc0200cf4:	02878063          	beq	a5,s0,ffffffffc0200d14 <print_objs+0x48>
ffffffffc0200cf8:	00001997          	auipc	s3,0x1
ffffffffc0200cfc:	69898993          	addi	s3,s3,1688 # ffffffffc0202390 <commands+0x6d8>
ffffffffc0200d00:	400c                	lw	a1,0(s0)
ffffffffc0200d02:	854e                	mv	a0,s3
ffffffffc0200d04:	2485                	addiw	s1,s1,1
ffffffffc0200d06:	bb4ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d0a:	00093783          	ld	a5,0(s2)
ffffffffc0200d0e:	6400                	ld	s0,8(s0)
ffffffffc0200d10:	fe8798e3          	bne	a5,s0,ffffffffc0200d00 <print_objs+0x34>
ffffffffc0200d14:	85a6                	mv	a1,s1
ffffffffc0200d16:	00001517          	auipc	a0,0x1
ffffffffc0200d1a:	68250513          	addi	a0,a0,1666 # ffffffffc0202398 <commands+0x6e0>
ffffffffc0200d1e:	b9cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d22:	7402                	ld	s0,32(sp)
ffffffffc0200d24:	70a2                	ld	ra,40(sp)
ffffffffc0200d26:	64e2                	ld	s1,24(sp)
ffffffffc0200d28:	6942                	ld	s2,16(sp)
ffffffffc0200d2a:	69a2                	ld	s3,8(sp)
ffffffffc0200d2c:	00001517          	auipc	a0,0x1
ffffffffc0200d30:	6fc50513          	addi	a0,a0,1788 # ffffffffc0202428 <commands+0x770>
ffffffffc0200d34:	6145                	addi	sp,sp,48
ffffffffc0200d36:	b84ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200d3a <slub_check>:
ffffffffc0200d3a:	1101                	addi	sp,sp,-32
ffffffffc0200d3c:	00001517          	auipc	a0,0x1
ffffffffc0200d40:	67c50513          	addi	a0,a0,1660 # ffffffffc02023b8 <commands+0x700>
ffffffffc0200d44:	ec06                	sd	ra,24(sp)
ffffffffc0200d46:	e822                	sd	s0,16(sp)
ffffffffc0200d48:	e426                	sd	s1,8(sp)
ffffffffc0200d4a:	b70ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d4e:	f7fff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200d52:	00001517          	auipc	a0,0x1
ffffffffc0200d56:	67e50513          	addi	a0,a0,1662 # ffffffffc02023d0 <commands+0x718>
ffffffffc0200d5a:	b60ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d5e:	00001517          	auipc	a0,0x1
ffffffffc0200d62:	68a50513          	addi	a0,a0,1674 # ffffffffc02023e8 <commands+0x730>
ffffffffc0200d66:	b54ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d6a:	6505                	lui	a0,0x1
ffffffffc0200d6c:	e8dff0ef          	jal	ra,ffffffffc0200bf8 <slub_alloc.part.0>
ffffffffc0200d70:	84aa                	mv	s1,a0
ffffffffc0200d72:	f5bff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200d76:	00001517          	auipc	a0,0x1
ffffffffc0200d7a:	68250513          	addi	a0,a0,1666 # ffffffffc02023f8 <commands+0x740>
ffffffffc0200d7e:	b3cff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d82:	4549                	li	a0,18
ffffffffc0200d84:	dc3ff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
ffffffffc0200d88:	f45ff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200d8c:	00001517          	auipc	a0,0x1
ffffffffc0200d90:	67c50513          	addi	a0,a0,1660 # ffffffffc0202408 <commands+0x750>
ffffffffc0200d94:	b26ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200d98:	03000513          	li	a0,48
ffffffffc0200d9c:	dabff0ef          	jal	ra,ffffffffc0200b46 <obj_alloc>
ffffffffc0200da0:	842a                	mv	s0,a0
ffffffffc0200da2:	c119                	beqz	a0,ffffffffc0200da8 <slub_check+0x6e>
ffffffffc0200da4:	01050413          	addi	s0,a0,16
ffffffffc0200da8:	f25ff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200dac:	00001517          	auipc	a0,0x1
ffffffffc0200db0:	66c50513          	addi	a0,a0,1644 # ffffffffc0202418 <commands+0x760>
ffffffffc0200db4:	b06ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200db8:	00001517          	auipc	a0,0x1
ffffffffc0200dbc:	67850513          	addi	a0,a0,1656 # ffffffffc0202430 <commands+0x778>
ffffffffc0200dc0:	afaff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200dc4:	8526                	mv	a0,s1
ffffffffc0200dc6:	ea1ff0ef          	jal	ra,ffffffffc0200c66 <slub_free>
ffffffffc0200dca:	f03ff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200dce:	00001517          	auipc	a0,0x1
ffffffffc0200dd2:	67250513          	addi	a0,a0,1650 # ffffffffc0202440 <commands+0x788>
ffffffffc0200dd6:	ae4ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200dda:	8522                	mv	a0,s0
ffffffffc0200ddc:	e8bff0ef          	jal	ra,ffffffffc0200c66 <slub_free>
ffffffffc0200de0:	eedff0ef          	jal	ra,ffffffffc0200ccc <print_objs>
ffffffffc0200de4:	00001517          	auipc	a0,0x1
ffffffffc0200de8:	66c50513          	addi	a0,a0,1644 # ffffffffc0202450 <commands+0x798>
ffffffffc0200dec:	aceff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200df0:	6442                	ld	s0,16(sp)
ffffffffc0200df2:	60e2                	ld	ra,24(sp)
ffffffffc0200df4:	64a2                	ld	s1,8(sp)
ffffffffc0200df6:	45c1                	li	a1,16
ffffffffc0200df8:	00001517          	auipc	a0,0x1
ffffffffc0200dfc:	66850513          	addi	a0,a0,1640 # ffffffffc0202460 <commands+0x7a8>
ffffffffc0200e00:	6105                	addi	sp,sp,32
ffffffffc0200e02:	ab8ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200e06 <buddy_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200e06:	00005797          	auipc	a5,0x5
ffffffffc0200e0a:	22a78793          	addi	a5,a5,554 # ffffffffc0206030 <free_area>
ffffffffc0200e0e:	e79c                	sd	a5,8(a5)
ffffffffc0200e10:	e39c                	sd	a5,0(a5)

static void
buddy_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200e12:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200e16:	8082                	ret

ffffffffc0200e18 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200e18:	00005517          	auipc	a0,0x5
ffffffffc0200e1c:	22856503          	lwu	a0,552(a0) # ffffffffc0206040 <free_area+0x10>
ffffffffc0200e20:	8082                	ret

ffffffffc0200e22 <buddy_free_pages>:
{
ffffffffc0200e22:	1141                	addi	sp,sp,-16
ffffffffc0200e24:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200e26:	16058863          	beqz	a1,ffffffffc0200f96 <buddy_free_pages+0x174>
    int i = get_power(n);
ffffffffc0200e2a:	0005879b          	sext.w	a5,a1
    while (tmp > 1)
ffffffffc0200e2e:	4705                	li	a4,1
    double tmp = n;
ffffffffc0200e30:	d21587d3          	fcvt.d.wu	fa5,a1
    while (tmp > 1)
ffffffffc0200e34:	12f77d63          	bgeu	a4,a5,ffffffffc0200f6e <buddy_free_pages+0x14c>
    unsigned i = 0;
ffffffffc0200e38:	4781                	li	a5,0
ffffffffc0200e3a:	00002717          	auipc	a4,0x2
ffffffffc0200e3e:	a1e73687          	fld	fa3,-1506(a4) # ffffffffc0202858 <error_string+0x38>
ffffffffc0200e42:	00002717          	auipc	a4,0x2
ffffffffc0200e46:	a1e73707          	fld	fa4,-1506(a4) # ffffffffc0202860 <error_string+0x40>
        tmp /= 2;
ffffffffc0200e4a:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc0200e4e:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc0200e50:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0200e54:	fb7d                	bnez	a4,ffffffffc0200e4a <buddy_free_pages+0x28>
    unsigned size = (1 << i);
ffffffffc0200e56:	4705                	li	a4,1
ffffffffc0200e58:	00f717bb          	sllw	a5,a4,a5
    for (; p != base + size; p++)
ffffffffc0200e5c:	02079713          	slli	a4,a5,0x20
ffffffffc0200e60:	9301                	srli	a4,a4,0x20
ffffffffc0200e62:	00271693          	slli	a3,a4,0x2
ffffffffc0200e66:	96ba                	add	a3,a3,a4
ffffffffc0200e68:	068e                	slli	a3,a3,0x3
ffffffffc0200e6a:	96aa                	add	a3,a3,a0
    unsigned size = (1 << i);
ffffffffc0200e6c:	0007861b          	sext.w	a2,a5
    for (; p != base + size; p++)
ffffffffc0200e70:	00d50f63          	beq	a0,a3,ffffffffc0200e8e <buddy_free_pages+0x6c>
ffffffffc0200e74:	87aa                	mv	a5,a0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e76:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200e78:	8b05                	andi	a4,a4,1
ffffffffc0200e7a:	ef75                	bnez	a4,ffffffffc0200f76 <buddy_free_pages+0x154>
ffffffffc0200e7c:	6798                	ld	a4,8(a5)
ffffffffc0200e7e:	8b09                	andi	a4,a4,2
ffffffffc0200e80:	eb7d                	bnez	a4,ffffffffc0200f76 <buddy_free_pages+0x154>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200e82:	0007a023          	sw	zero,0(a5)
    for (; p != base + size; p++)
ffffffffc0200e86:	02878793          	addi	a5,a5,40
ffffffffc0200e8a:	fed796e3          	bne	a5,a3,ffffffffc0200e76 <buddy_free_pages+0x54>
    unsigned offect = base - base0;
ffffffffc0200e8e:	00005797          	auipc	a5,0x5
ffffffffc0200e92:	60a7b783          	ld	a5,1546(a5) # ffffffffc0206498 <base0>
ffffffffc0200e96:	8d1d                	sub	a0,a0,a5
ffffffffc0200e98:	40355793          	srai	a5,a0,0x3
ffffffffc0200e9c:	00002717          	auipc	a4,0x2
ffffffffc0200ea0:	9cc73703          	ld	a4,-1588(a4) # ffffffffc0202868 <error_string+0x48>
ffffffffc0200ea4:	02e78733          	mul	a4,a5,a4
    nr_free += size;
ffffffffc0200ea8:	00005517          	auipc	a0,0x5
ffffffffc0200eac:	18850513          	addi	a0,a0,392 # ffffffffc0206030 <free_area>
    unsigned index = length / 2 + offect - 1;
ffffffffc0200eb0:	00005817          	auipc	a6,0x5
ffffffffc0200eb4:	5f882803          	lw	a6,1528(a6) # ffffffffc02064a8 <length>
    nr_free += size;
ffffffffc0200eb8:	4914                	lw	a3,16(a0)
    unsigned index = length / 2 + offect - 1;
ffffffffc0200eba:	01f8579b          	srliw	a5,a6,0x1f
ffffffffc0200ebe:	010787bb          	addw	a5,a5,a6
ffffffffc0200ec2:	4017d79b          	sraiw	a5,a5,0x1
    nr_free += size;
ffffffffc0200ec6:	9e35                	addw	a2,a2,a3
    unsigned index = length / 2 + offect - 1;
ffffffffc0200ec8:	37fd                	addiw	a5,a5,-1
    nr_free += size;
ffffffffc0200eca:	c910                	sw	a2,16(a0)
    unsigned index = length / 2 + offect - 1;
ffffffffc0200ecc:	9fb9                	addw	a5,a5,a4
    unsigned node_size = 1;
ffffffffc0200ece:	4705                	li	a4,1
    while (node_size < n)
ffffffffc0200ed0:	02071693          	slli	a3,a4,0x20
ffffffffc0200ed4:	9281                	srli	a3,a3,0x20
ffffffffc0200ed6:	02b6f363          	bgeu	a3,a1,ffffffffc0200efc <buddy_free_pages+0xda>
        if (index % 2 == 0)
ffffffffc0200eda:	0017f693          	andi	a3,a5,1
        node_size *= 2;
ffffffffc0200ede:	0017171b          	slliw	a4,a4,0x1
        if (index % 2 == 0)
ffffffffc0200ee2:	ea81                	bnez	a3,ffffffffc0200ef2 <buddy_free_pages+0xd0>
            index = (index - 2) / 2;
ffffffffc0200ee4:	37f9                	addiw	a5,a5,-2
ffffffffc0200ee6:	0017d79b          	srliw	a5,a5,0x1
        if (index == 0)
ffffffffc0200eea:	f3fd                	bnez	a5,ffffffffc0200ed0 <buddy_free_pages+0xae>
}
ffffffffc0200eec:	60a2                	ld	ra,8(sp)
ffffffffc0200eee:	0141                	addi	sp,sp,16
ffffffffc0200ef0:	8082                	ret
            index = (index - 1) / 2;
ffffffffc0200ef2:	37fd                	addiw	a5,a5,-1
ffffffffc0200ef4:	0017d79b          	srliw	a5,a5,0x1
        if (index == 0)
ffffffffc0200ef8:	ffe1                	bnez	a5,ffffffffc0200ed0 <buddy_free_pages+0xae>
ffffffffc0200efa:	bfcd                	j	ffffffffc0200eec <buddy_free_pages+0xca>
    buddy[index] = node_size;
ffffffffc0200efc:	02079613          	slli	a2,a5,0x20
ffffffffc0200f00:	00005517          	auipc	a0,0x5
ffffffffc0200f04:	5a053503          	ld	a0,1440(a0) # ffffffffc02064a0 <buddy>
ffffffffc0200f08:	01e65693          	srli	a3,a2,0x1e
ffffffffc0200f0c:	96aa                	add	a3,a3,a0
ffffffffc0200f0e:	c298                	sw	a4,0(a3)
    while (index)
ffffffffc0200f10:	dff1                	beqz	a5,ffffffffc0200eec <buddy_free_pages+0xca>
        if (index % 2 == 0)
ffffffffc0200f12:	0017f693          	andi	a3,a5,1
ffffffffc0200f16:	eaa1                	bnez	a3,ffffffffc0200f66 <buddy_free_pages+0x144>
            index = (index - 2) / 2;
ffffffffc0200f18:	37f9                	addiw	a5,a5,-2
ffffffffc0200f1a:	0017d79b          	srliw	a5,a5,0x1
        unsigned left = buddy[2 * index + 1];
ffffffffc0200f1e:	0017969b          	slliw	a3,a5,0x1
        unsigned right = buddy[2 * index + 2];
ffffffffc0200f22:	0026861b          	addiw	a2,a3,2
ffffffffc0200f26:	1602                	slli	a2,a2,0x20
        unsigned left = buddy[2 * index + 1];
ffffffffc0200f28:	2685                	addiw	a3,a3,1
ffffffffc0200f2a:	02069593          	slli	a1,a3,0x20
        unsigned right = buddy[2 * index + 2];
ffffffffc0200f2e:	9201                	srli	a2,a2,0x20
        unsigned left = buddy[2 * index + 1];
ffffffffc0200f30:	01e5d693          	srli	a3,a1,0x1e
        unsigned right = buddy[2 * index + 2];
ffffffffc0200f34:	060a                	slli	a2,a2,0x2
        unsigned left = buddy[2 * index + 1];
ffffffffc0200f36:	96aa                	add	a3,a3,a0
        unsigned right = buddy[2 * index + 2];
ffffffffc0200f38:	962a                	add	a2,a2,a0
        unsigned left = buddy[2 * index + 1];
ffffffffc0200f3a:	428c                	lw	a1,0(a3)
        unsigned right = buddy[2 * index + 2];
ffffffffc0200f3c:	4210                	lw	a2,0(a2)
        node_size *= 2;
ffffffffc0200f3e:	0017181b          	slliw	a6,a4,0x1
            buddy[index] = node_size;
ffffffffc0200f42:	02079713          	slli	a4,a5,0x20
ffffffffc0200f46:	01e75693          	srli	a3,a4,0x1e
        if (left + right == node_size)
ffffffffc0200f4a:	00c588bb          	addw	a7,a1,a2
        node_size *= 2;
ffffffffc0200f4e:	0008071b          	sext.w	a4,a6
            buddy[index] = node_size;
ffffffffc0200f52:	96aa                	add	a3,a3,a0
        if (left + right == node_size)
ffffffffc0200f54:	00e88663          	beq	a7,a4,ffffffffc0200f60 <buddy_free_pages+0x13e>
            buddy[index] = (left > right) ? left : right;
ffffffffc0200f58:	882e                	mv	a6,a1
ffffffffc0200f5a:	00c5f363          	bgeu	a1,a2,ffffffffc0200f60 <buddy_free_pages+0x13e>
ffffffffc0200f5e:	8832                	mv	a6,a2
ffffffffc0200f60:	0106a023          	sw	a6,0(a3)
    while (index)
ffffffffc0200f64:	b775                	j	ffffffffc0200f10 <buddy_free_pages+0xee>
            index = (index - 1) / 2;
ffffffffc0200f66:	37fd                	addiw	a5,a5,-1
ffffffffc0200f68:	0017d79b          	srliw	a5,a5,0x1
ffffffffc0200f6c:	bf4d                	j	ffffffffc0200f1e <buddy_free_pages+0xfc>
    while (tmp > 1)
ffffffffc0200f6e:	4605                	li	a2,1
ffffffffc0200f70:	02850693          	addi	a3,a0,40
ffffffffc0200f74:	b701                	j	ffffffffc0200e74 <buddy_free_pages+0x52>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200f76:	00001697          	auipc	a3,0x1
ffffffffc0200f7a:	51268693          	addi	a3,a3,1298 # ffffffffc0202488 <commands+0x7d0>
ffffffffc0200f7e:	00001617          	auipc	a2,0x1
ffffffffc0200f82:	3ba60613          	addi	a2,a2,954 # ffffffffc0202338 <commands+0x680>
ffffffffc0200f86:	0a200593          	li	a1,162
ffffffffc0200f8a:	00001517          	auipc	a0,0x1
ffffffffc0200f8e:	4e650513          	addi	a0,a0,1254 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0200f92:	9b0ff0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(n > 0);
ffffffffc0200f96:	00001697          	auipc	a3,0x1
ffffffffc0200f9a:	4d268693          	addi	a3,a3,1234 # ffffffffc0202468 <commands+0x7b0>
ffffffffc0200f9e:	00001617          	auipc	a2,0x1
ffffffffc0200fa2:	39a60613          	addi	a2,a2,922 # ffffffffc0202338 <commands+0x680>
ffffffffc0200fa6:	09b00593          	li	a1,155
ffffffffc0200faa:	00001517          	auipc	a0,0x1
ffffffffc0200fae:	4c650513          	addi	a0,a0,1222 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0200fb2:	990ff0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc0200fb6 <buddy_alloc_pages>:
    assert(n > 0);
ffffffffc0200fb6:	1e050263          	beqz	a0,ffffffffc020119a <buddy_alloc_pages+0x1e4>
    if (n > nr_free)
ffffffffc0200fba:	00005817          	auipc	a6,0x5
ffffffffc0200fbe:	07680813          	addi	a6,a6,118 # ffffffffc0206030 <free_area>
ffffffffc0200fc2:	01086783          	lwu	a5,16(a6)
ffffffffc0200fc6:	1aa7ee63          	bltu	a5,a0,ffffffffc0201182 <buddy_alloc_pages+0x1cc>
    else if (!is_power_of_2(n))
ffffffffc0200fca:	0005031b          	sext.w	t1,a0
    return !(x & (x - 1));
ffffffffc0200fce:	fff5079b          	addiw	a5,a0,-1
ffffffffc0200fd2:	00f377b3          	and	a5,t1,a5
    else if (!is_power_of_2(n))
ffffffffc0200fd6:	2781                	sext.w	a5,a5
    double tmp = n;
ffffffffc0200fd8:	d21507d3          	fcvt.d.wu	fa5,a0
    else if (!is_power_of_2(n))
ffffffffc0200fdc:	16079a63          	bnez	a5,ffffffffc0201150 <buddy_alloc_pages+0x19a>
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc0200fe0:	00005897          	auipc	a7,0x5
ffffffffc0200fe4:	4c888893          	addi	a7,a7,1224 # ffffffffc02064a8 <length>
ffffffffc0200fe8:	0008a703          	lw	a4,0(a7)
    if (buddy[index] < n) //如果根节点大小小于n，则找不到合适的节点
ffffffffc0200fec:	00005617          	auipc	a2,0x5
ffffffffc0200ff0:	4b463603          	ld	a2,1204(a2) # ffffffffc02064a0 <buddy>
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc0200ff4:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0200ff8:	9fb9                	addw	a5,a5,a4
ffffffffc0200ffa:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200ffe:	02079693          	slli	a3,a5,0x20
ffffffffc0201002:	9281                	srli	a3,a3,0x20
ffffffffc0201004:	0007871b          	sext.w	a4,a5
ffffffffc0201008:	0ad50963          	beq	a0,a3,ffffffffc02010ba <buddy_alloc_pages+0x104>
    unsigned index = 0;//从根节点开始寻找
ffffffffc020100c:	4781                	li	a5,0
        if (buddy[2 * index + 1] >= n)
ffffffffc020100e:	0017959b          	slliw	a1,a5,0x1
ffffffffc0201012:	0015879b          	addiw	a5,a1,1
ffffffffc0201016:	02079e13          	slli	t3,a5,0x20
ffffffffc020101a:	01ee5693          	srli	a3,t3,0x1e
ffffffffc020101e:	96b2                	add	a3,a3,a2
ffffffffc0201020:	0006e683          	lwu	a3,0(a3)
ffffffffc0201024:	00a6f463          	bgeu	a3,a0,ffffffffc020102c <buddy_alloc_pages+0x76>
            index = 2 * index + 2;
ffffffffc0201028:	0025879b          	addiw	a5,a1,2
    for (node_size = length / 2; node_size != n; node_size /= 2)
ffffffffc020102c:	0017571b          	srliw	a4,a4,0x1
ffffffffc0201030:	02071693          	slli	a3,a4,0x20
ffffffffc0201034:	9281                	srli	a3,a3,0x20
ffffffffc0201036:	fca69ce3          	bne	a3,a0,ffffffffc020100e <buddy_alloc_pages+0x58>
    offect = (index + 1) * node_size - length / 2;
ffffffffc020103a:	00178e1b          	addiw	t3,a5,1
ffffffffc020103e:	02ee073b          	mulw	a4,t3,a4
    buddy[index] = 0;
ffffffffc0201042:	02079593          	slli	a1,a5,0x20
ffffffffc0201046:	01e5d693          	srli	a3,a1,0x1e
ffffffffc020104a:	96b2                	add	a3,a3,a2
ffffffffc020104c:	0006a023          	sw	zero,0(a3)
    offect = (index + 1) * node_size - length / 2;
ffffffffc0201050:	0008a683          	lw	a3,0(a7)
ffffffffc0201054:	01f6de1b          	srliw	t3,a3,0x1f
ffffffffc0201058:	00de0e3b          	addw	t3,t3,a3
ffffffffc020105c:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc0201060:	41c70e3b          	subw	t3,a4,t3
    while (index > 0)
ffffffffc0201064:	e7a1                	bnez	a5,ffffffffc02010ac <buddy_alloc_pages+0xf6>
ffffffffc0201066:	a0b5                	j	ffffffffc02010d2 <buddy_alloc_pages+0x11c>
            index = (index - 2) / 2;
ffffffffc0201068:	37f9                	addiw	a5,a5,-2
ffffffffc020106a:	0017d79b          	srliw	a5,a5,0x1
        buddy[index] = (buddy[2 * index + 1] > buddy[2 * index + 2]) ? buddy[2 * index + 1] : buddy[2 * index + 2];
ffffffffc020106e:	0017871b          	addiw	a4,a5,1
ffffffffc0201072:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201076:	fff7069b          	addiw	a3,a4,-1
ffffffffc020107a:	1702                	slli	a4,a4,0x20
ffffffffc020107c:	02069593          	slli	a1,a3,0x20
ffffffffc0201080:	9301                	srli	a4,a4,0x20
ffffffffc0201082:	01e5d693          	srli	a3,a1,0x1e
ffffffffc0201086:	070a                	slli	a4,a4,0x2
ffffffffc0201088:	9732                	add	a4,a4,a2
ffffffffc020108a:	96b2                	add	a3,a3,a2
ffffffffc020108c:	430c                	lw	a1,0(a4)
ffffffffc020108e:	4294                	lw	a3,0(a3)
ffffffffc0201090:	02079513          	slli	a0,a5,0x20
ffffffffc0201094:	01e55713          	srli	a4,a0,0x1e
ffffffffc0201098:	0006889b          	sext.w	a7,a3
ffffffffc020109c:	0005851b          	sext.w	a0,a1
ffffffffc02010a0:	9732                	add	a4,a4,a2
ffffffffc02010a2:	00a8f363          	bgeu	a7,a0,ffffffffc02010a8 <buddy_alloc_pages+0xf2>
ffffffffc02010a6:	86ae                	mv	a3,a1
ffffffffc02010a8:	c314                	sw	a3,0(a4)
    while (index > 0)
ffffffffc02010aa:	c785                	beqz	a5,ffffffffc02010d2 <buddy_alloc_pages+0x11c>
        if (index % 2 == 0)
ffffffffc02010ac:	0017f693          	andi	a3,a5,1
ffffffffc02010b0:	dec5                	beqz	a3,ffffffffc0201068 <buddy_alloc_pages+0xb2>
            index = (index - 1) / 2;
ffffffffc02010b2:	37fd                	addiw	a5,a5,-1
ffffffffc02010b4:	0017d79b          	srliw	a5,a5,0x1
ffffffffc02010b8:	bf5d                	j	ffffffffc020106e <buddy_alloc_pages+0xb8>
    buddy[index] = 0;
ffffffffc02010ba:	00062023          	sw	zero,0(a2)
    offect = (index + 1) * node_size - length / 2;
ffffffffc02010be:	0008a703          	lw	a4,0(a7)
ffffffffc02010c2:	01f75e1b          	srliw	t3,a4,0x1f
ffffffffc02010c6:	00ee0e3b          	addw	t3,t3,a4
ffffffffc02010ca:	401e5e1b          	sraiw	t3,t3,0x1
ffffffffc02010ce:	41c78e3b          	subw	t3,a5,t3
    page = base0 + offect;
ffffffffc02010d2:	020e1793          	slli	a5,t3,0x20
ffffffffc02010d6:	9381                	srli	a5,a5,0x20
ffffffffc02010d8:	00279513          	slli	a0,a5,0x2
ffffffffc02010dc:	97aa                	add	a5,a5,a0
ffffffffc02010de:	078e                	slli	a5,a5,0x3
ffffffffc02010e0:	00005517          	auipc	a0,0x5
ffffffffc02010e4:	3b853503          	ld	a0,952(a0) # ffffffffc0206498 <base0>
ffffffffc02010e8:	953e                	add	a0,a0,a5
    page->property = n;
ffffffffc02010ea:	00652823          	sw	t1,16(a0)
    while (tmp > 1)
ffffffffc02010ee:	4785                	li	a5,1
ffffffffc02010f0:	0867fb63          	bgeu	a5,t1,ffffffffc0201186 <buddy_alloc_pages+0x1d0>
    unsigned i = 0;
ffffffffc02010f4:	4781                	li	a5,0
ffffffffc02010f6:	00001717          	auipc	a4,0x1
ffffffffc02010fa:	76273687          	fld	fa3,1890(a4) # ffffffffc0202858 <error_string+0x38>
ffffffffc02010fe:	00001717          	auipc	a4,0x1
ffffffffc0201102:	76273707          	fld	fa4,1890(a4) # ffffffffc0202860 <error_string+0x40>
        tmp /= 2;
ffffffffc0201106:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc020110a:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc020110c:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0201110:	fb7d                	bnez	a4,ffffffffc0201106 <buddy_alloc_pages+0x150>
    unsigned size = (1 << i);
ffffffffc0201112:	4705                	li	a4,1
ffffffffc0201114:	00f717bb          	sllw	a5,a4,a5
    for (struct Page *p = page; p != page + size; p++)
ffffffffc0201118:	02079693          	slli	a3,a5,0x20
ffffffffc020111c:	9281                	srli	a3,a3,0x20
ffffffffc020111e:	00269713          	slli	a4,a3,0x2
ffffffffc0201122:	9736                	add	a4,a4,a3
ffffffffc0201124:	070e                	slli	a4,a4,0x3
    nr_free -= size;
ffffffffc0201126:	01082683          	lw	a3,16(a6)
    for (struct Page *p = page; p != page + size; p++)
ffffffffc020112a:	972a                	add	a4,a4,a0
    nr_free -= size;
ffffffffc020112c:	40f687bb          	subw	a5,a3,a5
ffffffffc0201130:	00f82823          	sw	a5,16(a6)
    for (struct Page *p = page; p != page + size; p++)
ffffffffc0201134:	00e50d63          	beq	a0,a4,ffffffffc020114e <buddy_alloc_pages+0x198>
ffffffffc0201138:	87aa                	mv	a5,a0
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020113a:	56f5                	li	a3,-3
ffffffffc020113c:	00878613          	addi	a2,a5,8
ffffffffc0201140:	60d6302f          	amoand.d	zero,a3,(a2)
ffffffffc0201144:	02878793          	addi	a5,a5,40
ffffffffc0201148:	fee79ae3          	bne	a5,a4,ffffffffc020113c <buddy_alloc_pages+0x186>
ffffffffc020114c:	8082                	ret
}
ffffffffc020114e:	8082                	ret
    while (tmp > 1)
ffffffffc0201150:	4785                	li	a5,1
ffffffffc0201152:	02f50e63          	beq	a0,a5,ffffffffc020118e <buddy_alloc_pages+0x1d8>
    unsigned i = 0;
ffffffffc0201156:	4781                	li	a5,0
ffffffffc0201158:	00001717          	auipc	a4,0x1
ffffffffc020115c:	70073687          	fld	fa3,1792(a4) # ffffffffc0202858 <error_string+0x38>
ffffffffc0201160:	00001717          	auipc	a4,0x1
ffffffffc0201164:	70073707          	fld	fa4,1792(a4) # ffffffffc0202860 <error_string+0x40>
        tmp /= 2;
ffffffffc0201168:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc020116c:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc020116e:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc0201172:	fb7d                	bnez	a4,ffffffffc0201168 <buddy_alloc_pages+0x1b2>
        n = (1 << pw);
ffffffffc0201174:	4705                	li	a4,1
ffffffffc0201176:	00f7153b          	sllw	a0,a4,a5
    double tmp = n;
ffffffffc020117a:	d21507d3          	fcvt.d.wu	fa5,a0
    page->property = n;
ffffffffc020117e:	832a                	mv	t1,a0
ffffffffc0201180:	b585                	j	ffffffffc0200fe0 <buddy_alloc_pages+0x2a>
        return NULL;
ffffffffc0201182:	4501                	li	a0,0
ffffffffc0201184:	8082                	ret
    while (tmp > 1)
ffffffffc0201186:	4785                	li	a5,1
ffffffffc0201188:	02800713          	li	a4,40
ffffffffc020118c:	bf69                	j	ffffffffc0201126 <buddy_alloc_pages+0x170>
ffffffffc020118e:	00001797          	auipc	a5,0x1
ffffffffc0201192:	6d27b787          	fld	fa5,1746(a5) # ffffffffc0202860 <error_string+0x40>
ffffffffc0201196:	4305                	li	t1,1
        n = (1 << pw);
ffffffffc0201198:	b5a1                	j	ffffffffc0200fe0 <buddy_alloc_pages+0x2a>
{
ffffffffc020119a:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020119c:	00001697          	auipc	a3,0x1
ffffffffc02011a0:	2cc68693          	addi	a3,a3,716 # ffffffffc0202468 <commands+0x7b0>
ffffffffc02011a4:	00001617          	auipc	a2,0x1
ffffffffc02011a8:	19460613          	addi	a2,a2,404 # ffffffffc0202338 <commands+0x680>
ffffffffc02011ac:	04f00593          	li	a1,79
ffffffffc02011b0:	00001517          	auipc	a0,0x1
ffffffffc02011b4:	2c050513          	addi	a0,a0,704 # ffffffffc0202470 <commands+0x7b8>
{
ffffffffc02011b8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02011ba:	f89fe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc02011be <buddy_check>:


static void
buddy_check(void)
{
ffffffffc02011be:	1101                	addi	sp,sp,-32
    cprintf("buddy check%s\n", "!");
ffffffffc02011c0:	00001597          	auipc	a1,0x1
ffffffffc02011c4:	2f058593          	addi	a1,a1,752 # ffffffffc02024b0 <commands+0x7f8>
ffffffffc02011c8:	00001517          	auipc	a0,0x1
ffffffffc02011cc:	2f050513          	addi	a0,a0,752 # ffffffffc02024b8 <commands+0x800>
{
ffffffffc02011d0:	ec06                	sd	ra,24(sp)
ffffffffc02011d2:	e822                	sd	s0,16(sp)
ffffffffc02011d4:	e426                	sd	s1,8(sp)
ffffffffc02011d6:	e04a                	sd	s2,0(sp)
    cprintf("buddy check%s\n", "!");
ffffffffc02011d8:	ee3fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    struct Page *p0, *p1, *p2, *A, *B, *C, *D;
    p0 = p1 = p2 = A = B = C = D = NULL;

    // cprintf("alloc p0\n");
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011dc:	4505                	li	a0,1
ffffffffc02011de:	ed8ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011e2:	14050363          	beqz	a0,ffffffffc0201328 <buddy_check+0x16a>
ffffffffc02011e6:	842a                	mv	s0,a0
    // cprintf("alloc A\n");
    assert((A = alloc_page()) != NULL);
ffffffffc02011e8:	4505                	li	a0,1
ffffffffc02011ea:	eccff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011ee:	84aa                	mv	s1,a0
ffffffffc02011f0:	10050c63          	beqz	a0,ffffffffc0201308 <buddy_check+0x14a>
    // cprintf("alloc B\n");
    assert((B = alloc_page()) != NULL);
ffffffffc02011f4:	4505                	li	a0,1
ffffffffc02011f6:	ec0ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc02011fa:	892a                	mv	s2,a0
ffffffffc02011fc:	0e050663          	beqz	a0,ffffffffc02012e8 <buddy_check+0x12a>

    // cprintf("before free p0,A,B buddy[0] %u\n", buddy[0]);

    assert(p0 != A && p0 != B && A != B);
ffffffffc0201200:	0a940463          	beq	s0,s1,ffffffffc02012a8 <buddy_check+0xea>
ffffffffc0201204:	0aa40263          	beq	s0,a0,ffffffffc02012a8 <buddy_check+0xea>
ffffffffc0201208:	0aa48063          	beq	s1,a0,ffffffffc02012a8 <buddy_check+0xea>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
ffffffffc020120c:	401c                	lw	a5,0(s0)
ffffffffc020120e:	efcd                	bnez	a5,ffffffffc02012c8 <buddy_check+0x10a>
ffffffffc0201210:	409c                	lw	a5,0(s1)
ffffffffc0201212:	ebdd                	bnez	a5,ffffffffc02012c8 <buddy_check+0x10a>
ffffffffc0201214:	411c                	lw	a5,0(a0)
ffffffffc0201216:	ebcd                	bnez	a5,ffffffffc02012c8 <buddy_check+0x10a>

    // cprintf("free p0\n");
    free_page(p0);
ffffffffc0201218:	8522                	mv	a0,s0
ffffffffc020121a:	4585                	li	a1,1
ffffffffc020121c:	ed8ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("free A\n");
    free_page(A);
ffffffffc0201220:	8526                	mv	a0,s1
ffffffffc0201222:	4585                	li	a1,1
ffffffffc0201224:	ed0ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("free B\n");
    free_page(B);
ffffffffc0201228:	4585                	li	a1,1
ffffffffc020122a:	854a                	mv	a0,s2
ffffffffc020122c:	ec8ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    // cprintf("after free p0,A,B buddy[0] %u\n", buddy[0]);

    p0 = alloc_pages(100);
ffffffffc0201230:	06400513          	li	a0,100
ffffffffc0201234:	e82ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
ffffffffc0201238:	842a                	mv	s0,a0
    p1 = alloc_pages(100);
ffffffffc020123a:	06400513          	li	a0,100
ffffffffc020123e:	e78ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    A = alloc_pages(64);
ffffffffc0201242:	04000513          	li	a0,64
ffffffffc0201246:	e70ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>

    // 检验p1和p2是否相邻，并且分配内存是否是大于分配内存的2的幂次
    assert(p1 = p0 + 128);
    // 检验A和p1是否相邻
    assert(A == p1 + 128);
ffffffffc020124a:	678d                	lui	a5,0x3
ffffffffc020124c:	80078793          	addi	a5,a5,-2048 # 2800 <kern_entry-0xffffffffc01fd800>
    assert(p1 = p0 + 128);
ffffffffc0201250:	6705                	lui	a4,0x1
ffffffffc0201252:	40070713          	addi	a4,a4,1024 # 1400 <kern_entry-0xffffffffc01fec00>
    assert(A == p1 + 128);
ffffffffc0201256:	97a2                	add	a5,a5,s0
    A = alloc_pages(64);
ffffffffc0201258:	892a                	mv	s2,a0
    assert(p1 = p0 + 128);
ffffffffc020125a:	00e404b3          	add	s1,s0,a4
    assert(A == p1 + 128);
ffffffffc020125e:	12f51563          	bne	a0,a5,ffffffffc0201388 <buddy_check+0x1ca>

    // 检验p0释放后分配D是否使用了D的空间
    free_page(p0);
ffffffffc0201262:	8522                	mv	a0,s0
ffffffffc0201264:	4585                	li	a1,1
ffffffffc0201266:	e8eff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    D = alloc_pages(32);
ffffffffc020126a:	02000513          	li	a0,32
ffffffffc020126e:	e48ff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    assert(D == p0);
ffffffffc0201272:	0ea41b63          	bne	s0,a0,ffffffffc0201368 <buddy_check+0x1aa>

    // 检验释放后内存的合并是否正确
    free_page(D);
ffffffffc0201276:	4585                	li	a1,1
ffffffffc0201278:	e7cff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    free_page(p1);
ffffffffc020127c:	8526                	mv	a0,s1
ffffffffc020127e:	4585                	li	a1,1
ffffffffc0201280:	e74ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    p2 = alloc_pages(256);
ffffffffc0201284:	10000513          	li	a0,256
ffffffffc0201288:	e2eff0ef          	jal	ra,ffffffffc02008b6 <alloc_pages>
    assert(p0 == p2);
ffffffffc020128c:	0aa41e63          	bne	s0,a0,ffffffffc0201348 <buddy_check+0x18a>

    free_page(p2);
ffffffffc0201290:	4585                	li	a1,1
ffffffffc0201292:	e62ff0ef          	jal	ra,ffffffffc02008f4 <free_pages>
    free_page(A);
}
ffffffffc0201296:	6442                	ld	s0,16(sp)
ffffffffc0201298:	60e2                	ld	ra,24(sp)
ffffffffc020129a:	64a2                	ld	s1,8(sp)
    free_page(A);
ffffffffc020129c:	854a                	mv	a0,s2
}
ffffffffc020129e:	6902                	ld	s2,0(sp)
    free_page(A);
ffffffffc02012a0:	4585                	li	a1,1
}
ffffffffc02012a2:	6105                	addi	sp,sp,32
    free_page(A);
ffffffffc02012a4:	e50ff06f          	j	ffffffffc02008f4 <free_pages>
    assert(p0 != A && p0 != B && A != B);
ffffffffc02012a8:	00001697          	auipc	a3,0x1
ffffffffc02012ac:	28068693          	addi	a3,a3,640 # ffffffffc0202528 <commands+0x870>
ffffffffc02012b0:	00001617          	auipc	a2,0x1
ffffffffc02012b4:	08860613          	addi	a2,a2,136 # ffffffffc0202338 <commands+0x680>
ffffffffc02012b8:	0ed00593          	li	a1,237
ffffffffc02012bc:	00001517          	auipc	a0,0x1
ffffffffc02012c0:	1b450513          	addi	a0,a0,436 # ffffffffc0202470 <commands+0x7b8>
ffffffffc02012c4:	e7ffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
ffffffffc02012c8:	00001697          	auipc	a3,0x1
ffffffffc02012cc:	28068693          	addi	a3,a3,640 # ffffffffc0202548 <commands+0x890>
ffffffffc02012d0:	00001617          	auipc	a2,0x1
ffffffffc02012d4:	06860613          	addi	a2,a2,104 # ffffffffc0202338 <commands+0x680>
ffffffffc02012d8:	0ee00593          	li	a1,238
ffffffffc02012dc:	00001517          	auipc	a0,0x1
ffffffffc02012e0:	19450513          	addi	a0,a0,404 # ffffffffc0202470 <commands+0x7b8>
ffffffffc02012e4:	e5ffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((B = alloc_page()) != NULL);
ffffffffc02012e8:	00001697          	auipc	a3,0x1
ffffffffc02012ec:	22068693          	addi	a3,a3,544 # ffffffffc0202508 <commands+0x850>
ffffffffc02012f0:	00001617          	auipc	a2,0x1
ffffffffc02012f4:	04860613          	addi	a2,a2,72 # ffffffffc0202338 <commands+0x680>
ffffffffc02012f8:	0e900593          	li	a1,233
ffffffffc02012fc:	00001517          	auipc	a0,0x1
ffffffffc0201300:	17450513          	addi	a0,a0,372 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0201304:	e3ffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((A = alloc_page()) != NULL);
ffffffffc0201308:	00001697          	auipc	a3,0x1
ffffffffc020130c:	1e068693          	addi	a3,a3,480 # ffffffffc02024e8 <commands+0x830>
ffffffffc0201310:	00001617          	auipc	a2,0x1
ffffffffc0201314:	02860613          	addi	a2,a2,40 # ffffffffc0202338 <commands+0x680>
ffffffffc0201318:	0e700593          	li	a1,231
ffffffffc020131c:	00001517          	auipc	a0,0x1
ffffffffc0201320:	15450513          	addi	a0,a0,340 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0201324:	e1ffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201328:	00001697          	auipc	a3,0x1
ffffffffc020132c:	1a068693          	addi	a3,a3,416 # ffffffffc02024c8 <commands+0x810>
ffffffffc0201330:	00001617          	auipc	a2,0x1
ffffffffc0201334:	00860613          	addi	a2,a2,8 # ffffffffc0202338 <commands+0x680>
ffffffffc0201338:	0e500593          	li	a1,229
ffffffffc020133c:	00001517          	auipc	a0,0x1
ffffffffc0201340:	13450513          	addi	a0,a0,308 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0201344:	dfffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(p0 == p2);
ffffffffc0201348:	00001697          	auipc	a3,0x1
ffffffffc020134c:	25868693          	addi	a3,a3,600 # ffffffffc02025a0 <commands+0x8e8>
ffffffffc0201350:	00001617          	auipc	a2,0x1
ffffffffc0201354:	fe860613          	addi	a2,a2,-24 # ffffffffc0202338 <commands+0x680>
ffffffffc0201358:	10a00593          	li	a1,266
ffffffffc020135c:	00001517          	auipc	a0,0x1
ffffffffc0201360:	11450513          	addi	a0,a0,276 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0201364:	ddffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(D == p0);
ffffffffc0201368:	00001697          	auipc	a3,0x1
ffffffffc020136c:	23068693          	addi	a3,a3,560 # ffffffffc0202598 <commands+0x8e0>
ffffffffc0201370:	00001617          	auipc	a2,0x1
ffffffffc0201374:	fc860613          	addi	a2,a2,-56 # ffffffffc0202338 <commands+0x680>
ffffffffc0201378:	10400593          	li	a1,260
ffffffffc020137c:	00001517          	auipc	a0,0x1
ffffffffc0201380:	0f450513          	addi	a0,a0,244 # ffffffffc0202470 <commands+0x7b8>
ffffffffc0201384:	dbffe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(A == p1 + 128);
ffffffffc0201388:	00001697          	auipc	a3,0x1
ffffffffc020138c:	20068693          	addi	a3,a3,512 # ffffffffc0202588 <commands+0x8d0>
ffffffffc0201390:	00001617          	auipc	a2,0x1
ffffffffc0201394:	fa860613          	addi	a2,a2,-88 # ffffffffc0202338 <commands+0x680>
ffffffffc0201398:	0ff00593          	li	a1,255
ffffffffc020139c:	00001517          	auipc	a0,0x1
ffffffffc02013a0:	0d450513          	addi	a0,a0,212 # ffffffffc0202470 <commands+0x7b8>
ffffffffc02013a4:	d9ffe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc02013a8 <buddy_init_memmap>:
{
ffffffffc02013a8:	1141                	addi	sp,sp,-16
ffffffffc02013aa:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02013ac:	10058163          	beqz	a1,ffffffffc02014ae <buddy_init_memmap+0x106>
    for (; p != base + n; p++)
ffffffffc02013b0:	00259693          	slli	a3,a1,0x2
ffffffffc02013b4:	96ae                	add	a3,a3,a1
ffffffffc02013b6:	068e                	slli	a3,a3,0x3
ffffffffc02013b8:	96aa                	add	a3,a3,a0
ffffffffc02013ba:	87aa                	mv	a5,a0
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02013bc:	4609                	li	a2,2
ffffffffc02013be:	02d50363          	beq	a0,a3,ffffffffc02013e4 <buddy_init_memmap+0x3c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02013c2:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02013c4:	8b05                	andi	a4,a4,1
ffffffffc02013c6:	c761                	beqz	a4,ffffffffc020148e <buddy_init_memmap+0xe6>
        p->flags = p->property = 0;
ffffffffc02013c8:	0007a823          	sw	zero,16(a5)
ffffffffc02013cc:	0007b423          	sd	zero,8(a5)
ffffffffc02013d0:	0007a023          	sw	zero,0(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02013d4:	00878713          	addi	a4,a5,8
ffffffffc02013d8:	40c7302f          	amoor.d	zero,a2,(a4)
    for (; p != base + n; p++)
ffffffffc02013dc:	02878793          	addi	a5,a5,40
ffffffffc02013e0:	fed791e3          	bne	a5,a3,ffffffffc02013c2 <buddy_init_memmap+0x1a>
    base->property = n;
ffffffffc02013e4:	2581                	sext.w	a1,a1
ffffffffc02013e6:	c90c                	sw	a1,16(a0)
ffffffffc02013e8:	4689                	li	a3,2
ffffffffc02013ea:	00850793          	addi	a5,a0,8
ffffffffc02013ee:	40d7b02f          	amoor.d	zero,a3,(a5)
    nr_free += n;
ffffffffc02013f2:	00005717          	auipc	a4,0x5
ffffffffc02013f6:	c3e70713          	addi	a4,a4,-962 # ffffffffc0206030 <free_area>
ffffffffc02013fa:	4b1c                	lw	a5,16(a4)
    base0 = base;
ffffffffc02013fc:	00005617          	auipc	a2,0x5
ffffffffc0201400:	08a63e23          	sd	a0,156(a2) # ffffffffc0206498 <base0>
    while (tmp > 1)
ffffffffc0201404:	4605                	li	a2,1
    nr_free += n;
ffffffffc0201406:	9fad                	addw	a5,a5,a1
ffffffffc0201408:	cb1c                	sw	a5,16(a4)
    double tmp = n;
ffffffffc020140a:	d21587d3          	fcvt.d.wu	fa5,a1
    while (tmp > 1)
ffffffffc020140e:	06b67363          	bgeu	a2,a1,ffffffffc0201474 <buddy_init_memmap+0xcc>
    unsigned i = 0;
ffffffffc0201412:	4781                	li	a5,0
ffffffffc0201414:	00001717          	auipc	a4,0x1
ffffffffc0201418:	44473687          	fld	fa3,1092(a4) # ffffffffc0202858 <error_string+0x38>
ffffffffc020141c:	00001717          	auipc	a4,0x1
ffffffffc0201420:	44473707          	fld	fa4,1092(a4) # ffffffffc0202860 <error_string+0x40>
        tmp /= 2;
ffffffffc0201424:	12d7f7d3          	fmul.d	fa5,fa5,fa3
        i++;
ffffffffc0201428:	2785                	addiw	a5,a5,1
    while (tmp > 1)
ffffffffc020142a:	a2f71753          	flt.d	a4,fa4,fa5
ffffffffc020142e:	fb7d                	bnez	a4,ffffffffc0201424 <buddy_init_memmap+0x7c>
    length = 2 * (1 << (i));
ffffffffc0201430:	4709                	li	a4,2
ffffffffc0201432:	00f7163b          	sllw	a2,a4,a5
    buddy = (unsigned *)(base + length);
ffffffffc0201436:	00261713          	slli	a4,a2,0x2
ffffffffc020143a:	9732                	add	a4,a4,a2
ffffffffc020143c:	070e                	slli	a4,a4,0x3
    length = 2 * (1 << (i));
ffffffffc020143e:	00005597          	auipc	a1,0x5
ffffffffc0201442:	06a58593          	addi	a1,a1,106 # ffffffffc02064a8 <length>
    buddy = (unsigned *)(base + length);
ffffffffc0201446:	972a                	add	a4,a4,a0
    length = 2 * (1 << (i));
ffffffffc0201448:	c190                	sw	a2,0(a1)
    buddy = (unsigned *)(base + length);
ffffffffc020144a:	00005797          	auipc	a5,0x5
ffffffffc020144e:	04e7bb23          	sd	a4,86(a5) # ffffffffc02064a0 <buddy>
    for (i = 0; i < length; ++i)
ffffffffc0201452:	00c05e63          	blez	a2,ffffffffc020146e <buddy_init_memmap+0xc6>
    unsigned node_size = length;
ffffffffc0201456:	4781                	li	a5,0
        if (is_power_of_2(i + 1))
ffffffffc0201458:	86be                	mv	a3,a5
ffffffffc020145a:	2785                	addiw	a5,a5,1
ffffffffc020145c:	8efd                	and	a3,a3,a5
ffffffffc020145e:	e299                	bnez	a3,ffffffffc0201464 <buddy_init_memmap+0xbc>
            node_size /= 2;
ffffffffc0201460:	0016561b          	srliw	a2,a2,0x1
        buddy[i] = node_size;
ffffffffc0201464:	c310                	sw	a2,0(a4)
    for (i = 0; i < length; ++i)
ffffffffc0201466:	4194                	lw	a3,0(a1)
ffffffffc0201468:	0711                	addi	a4,a4,4
ffffffffc020146a:	fed7c7e3          	blt	a5,a3,ffffffffc0201458 <buddy_init_memmap+0xb0>
}
ffffffffc020146e:	60a2                	ld	ra,8(sp)
ffffffffc0201470:	0141                	addi	sp,sp,16
ffffffffc0201472:	8082                	ret
    length = 2 * (1 << (i));
ffffffffc0201474:	00005597          	auipc	a1,0x5
ffffffffc0201478:	03458593          	addi	a1,a1,52 # ffffffffc02064a8 <length>
    buddy = (unsigned *)(base + length);
ffffffffc020147c:	05050713          	addi	a4,a0,80
    length = 2 * (1 << (i));
ffffffffc0201480:	c194                	sw	a3,0(a1)
    buddy = (unsigned *)(base + length);
ffffffffc0201482:	00005797          	auipc	a5,0x5
ffffffffc0201486:	00e7bf23          	sd	a4,30(a5) # ffffffffc02064a0 <buddy>
    unsigned node_size = length;
ffffffffc020148a:	4609                	li	a2,2
ffffffffc020148c:	b7e9                	j	ffffffffc0201456 <buddy_init_memmap+0xae>
        assert(PageReserved(p));
ffffffffc020148e:	00001697          	auipc	a3,0x1
ffffffffc0201492:	12268693          	addi	a3,a3,290 # ffffffffc02025b0 <commands+0x8f8>
ffffffffc0201496:	00001617          	auipc	a2,0x1
ffffffffc020149a:	ea260613          	addi	a2,a2,-350 # ffffffffc0202338 <commands+0x680>
ffffffffc020149e:	03000593          	li	a1,48
ffffffffc02014a2:	00001517          	auipc	a0,0x1
ffffffffc02014a6:	fce50513          	addi	a0,a0,-50 # ffffffffc0202470 <commands+0x7b8>
ffffffffc02014aa:	c99fe0ef          	jal	ra,ffffffffc0200142 <__panic>
    assert(n > 0);
ffffffffc02014ae:	00001697          	auipc	a3,0x1
ffffffffc02014b2:	fba68693          	addi	a3,a3,-70 # ffffffffc0202468 <commands+0x7b0>
ffffffffc02014b6:	00001617          	auipc	a2,0x1
ffffffffc02014ba:	e8260613          	addi	a2,a2,-382 # ffffffffc0202338 <commands+0x680>
ffffffffc02014be:	02c00593          	li	a1,44
ffffffffc02014c2:	00001517          	auipc	a0,0x1
ffffffffc02014c6:	fae50513          	addi	a0,a0,-82 # ffffffffc0202470 <commands+0x7b8>
ffffffffc02014ca:	c79fe0ef          	jal	ra,ffffffffc0200142 <__panic>

ffffffffc02014ce <strnlen>:
ffffffffc02014ce:	4781                	li	a5,0
ffffffffc02014d0:	e589                	bnez	a1,ffffffffc02014da <strnlen+0xc>
ffffffffc02014d2:	a811                	j	ffffffffc02014e6 <strnlen+0x18>
ffffffffc02014d4:	0785                	addi	a5,a5,1
ffffffffc02014d6:	00f58863          	beq	a1,a5,ffffffffc02014e6 <strnlen+0x18>
ffffffffc02014da:	00f50733          	add	a4,a0,a5
ffffffffc02014de:	00074703          	lbu	a4,0(a4)
ffffffffc02014e2:	fb6d                	bnez	a4,ffffffffc02014d4 <strnlen+0x6>
ffffffffc02014e4:	85be                	mv	a1,a5
ffffffffc02014e6:	852e                	mv	a0,a1
ffffffffc02014e8:	8082                	ret

ffffffffc02014ea <strcmp>:
ffffffffc02014ea:	00054783          	lbu	a5,0(a0)
ffffffffc02014ee:	0005c703          	lbu	a4,0(a1)
ffffffffc02014f2:	cb89                	beqz	a5,ffffffffc0201504 <strcmp+0x1a>
ffffffffc02014f4:	0505                	addi	a0,a0,1
ffffffffc02014f6:	0585                	addi	a1,a1,1
ffffffffc02014f8:	fee789e3          	beq	a5,a4,ffffffffc02014ea <strcmp>
ffffffffc02014fc:	0007851b          	sext.w	a0,a5
ffffffffc0201500:	9d19                	subw	a0,a0,a4
ffffffffc0201502:	8082                	ret
ffffffffc0201504:	4501                	li	a0,0
ffffffffc0201506:	bfed                	j	ffffffffc0201500 <strcmp+0x16>

ffffffffc0201508 <strchr>:
ffffffffc0201508:	00054783          	lbu	a5,0(a0)
ffffffffc020150c:	c799                	beqz	a5,ffffffffc020151a <strchr+0x12>
ffffffffc020150e:	00f58763          	beq	a1,a5,ffffffffc020151c <strchr+0x14>
ffffffffc0201512:	00154783          	lbu	a5,1(a0)
ffffffffc0201516:	0505                	addi	a0,a0,1
ffffffffc0201518:	fbfd                	bnez	a5,ffffffffc020150e <strchr+0x6>
ffffffffc020151a:	4501                	li	a0,0
ffffffffc020151c:	8082                	ret

ffffffffc020151e <memset>:
ffffffffc020151e:	ca01                	beqz	a2,ffffffffc020152e <memset+0x10>
ffffffffc0201520:	962a                	add	a2,a2,a0
ffffffffc0201522:	87aa                	mv	a5,a0
ffffffffc0201524:	0785                	addi	a5,a5,1
ffffffffc0201526:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020152a:	fec79de3          	bne	a5,a2,ffffffffc0201524 <memset+0x6>
ffffffffc020152e:	8082                	ret

ffffffffc0201530 <printnum>:
ffffffffc0201530:	02069813          	slli	a6,a3,0x20
ffffffffc0201534:	7179                	addi	sp,sp,-48
ffffffffc0201536:	02085813          	srli	a6,a6,0x20
ffffffffc020153a:	e052                	sd	s4,0(sp)
ffffffffc020153c:	03067a33          	remu	s4,a2,a6
ffffffffc0201540:	f022                	sd	s0,32(sp)
ffffffffc0201542:	ec26                	sd	s1,24(sp)
ffffffffc0201544:	e84a                	sd	s2,16(sp)
ffffffffc0201546:	f406                	sd	ra,40(sp)
ffffffffc0201548:	e44e                	sd	s3,8(sp)
ffffffffc020154a:	84aa                	mv	s1,a0
ffffffffc020154c:	892e                	mv	s2,a1
ffffffffc020154e:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201552:	2a01                	sext.w	s4,s4
ffffffffc0201554:	03067e63          	bgeu	a2,a6,ffffffffc0201590 <printnum+0x60>
ffffffffc0201558:	89be                	mv	s3,a5
ffffffffc020155a:	00805763          	blez	s0,ffffffffc0201568 <printnum+0x38>
ffffffffc020155e:	347d                	addiw	s0,s0,-1
ffffffffc0201560:	85ca                	mv	a1,s2
ffffffffc0201562:	854e                	mv	a0,s3
ffffffffc0201564:	9482                	jalr	s1
ffffffffc0201566:	fc65                	bnez	s0,ffffffffc020155e <printnum+0x2e>
ffffffffc0201568:	1a02                	slli	s4,s4,0x20
ffffffffc020156a:	00001797          	auipc	a5,0x1
ffffffffc020156e:	0a678793          	addi	a5,a5,166 # ffffffffc0202610 <buddy_pmm_manager+0x38>
ffffffffc0201572:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201576:	9a3e                	add	s4,s4,a5
ffffffffc0201578:	7402                	ld	s0,32(sp)
ffffffffc020157a:	000a4503          	lbu	a0,0(s4)
ffffffffc020157e:	70a2                	ld	ra,40(sp)
ffffffffc0201580:	69a2                	ld	s3,8(sp)
ffffffffc0201582:	6a02                	ld	s4,0(sp)
ffffffffc0201584:	85ca                	mv	a1,s2
ffffffffc0201586:	87a6                	mv	a5,s1
ffffffffc0201588:	6942                	ld	s2,16(sp)
ffffffffc020158a:	64e2                	ld	s1,24(sp)
ffffffffc020158c:	6145                	addi	sp,sp,48
ffffffffc020158e:	8782                	jr	a5
ffffffffc0201590:	03065633          	divu	a2,a2,a6
ffffffffc0201594:	8722                	mv	a4,s0
ffffffffc0201596:	f9bff0ef          	jal	ra,ffffffffc0201530 <printnum>
ffffffffc020159a:	b7f9                	j	ffffffffc0201568 <printnum+0x38>

ffffffffc020159c <vprintfmt>:
ffffffffc020159c:	7119                	addi	sp,sp,-128
ffffffffc020159e:	f4a6                	sd	s1,104(sp)
ffffffffc02015a0:	f0ca                	sd	s2,96(sp)
ffffffffc02015a2:	ecce                	sd	s3,88(sp)
ffffffffc02015a4:	e8d2                	sd	s4,80(sp)
ffffffffc02015a6:	e4d6                	sd	s5,72(sp)
ffffffffc02015a8:	e0da                	sd	s6,64(sp)
ffffffffc02015aa:	fc5e                	sd	s7,56(sp)
ffffffffc02015ac:	f06a                	sd	s10,32(sp)
ffffffffc02015ae:	fc86                	sd	ra,120(sp)
ffffffffc02015b0:	f8a2                	sd	s0,112(sp)
ffffffffc02015b2:	f862                	sd	s8,48(sp)
ffffffffc02015b4:	f466                	sd	s9,40(sp)
ffffffffc02015b6:	ec6e                	sd	s11,24(sp)
ffffffffc02015b8:	892a                	mv	s2,a0
ffffffffc02015ba:	84ae                	mv	s1,a1
ffffffffc02015bc:	8d32                	mv	s10,a2
ffffffffc02015be:	8a36                	mv	s4,a3
ffffffffc02015c0:	02500993          	li	s3,37
ffffffffc02015c4:	5b7d                	li	s6,-1
ffffffffc02015c6:	00001a97          	auipc	s5,0x1
ffffffffc02015ca:	07ea8a93          	addi	s5,s5,126 # ffffffffc0202644 <buddy_pmm_manager+0x6c>
ffffffffc02015ce:	00001b97          	auipc	s7,0x1
ffffffffc02015d2:	252b8b93          	addi	s7,s7,594 # ffffffffc0202820 <error_string>
ffffffffc02015d6:	000d4503          	lbu	a0,0(s10)
ffffffffc02015da:	001d0413          	addi	s0,s10,1
ffffffffc02015de:	01350a63          	beq	a0,s3,ffffffffc02015f2 <vprintfmt+0x56>
ffffffffc02015e2:	c121                	beqz	a0,ffffffffc0201622 <vprintfmt+0x86>
ffffffffc02015e4:	85a6                	mv	a1,s1
ffffffffc02015e6:	0405                	addi	s0,s0,1
ffffffffc02015e8:	9902                	jalr	s2
ffffffffc02015ea:	fff44503          	lbu	a0,-1(s0)
ffffffffc02015ee:	ff351ae3          	bne	a0,s3,ffffffffc02015e2 <vprintfmt+0x46>
ffffffffc02015f2:	00044603          	lbu	a2,0(s0)
ffffffffc02015f6:	02000793          	li	a5,32
ffffffffc02015fa:	4c81                	li	s9,0
ffffffffc02015fc:	4881                	li	a7,0
ffffffffc02015fe:	5c7d                	li	s8,-1
ffffffffc0201600:	5dfd                	li	s11,-1
ffffffffc0201602:	05500513          	li	a0,85
ffffffffc0201606:	4825                	li	a6,9
ffffffffc0201608:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020160c:	0ff5f593          	zext.b	a1,a1
ffffffffc0201610:	00140d13          	addi	s10,s0,1
ffffffffc0201614:	04b56263          	bltu	a0,a1,ffffffffc0201658 <vprintfmt+0xbc>
ffffffffc0201618:	058a                	slli	a1,a1,0x2
ffffffffc020161a:	95d6                	add	a1,a1,s5
ffffffffc020161c:	4194                	lw	a3,0(a1)
ffffffffc020161e:	96d6                	add	a3,a3,s5
ffffffffc0201620:	8682                	jr	a3
ffffffffc0201622:	70e6                	ld	ra,120(sp)
ffffffffc0201624:	7446                	ld	s0,112(sp)
ffffffffc0201626:	74a6                	ld	s1,104(sp)
ffffffffc0201628:	7906                	ld	s2,96(sp)
ffffffffc020162a:	69e6                	ld	s3,88(sp)
ffffffffc020162c:	6a46                	ld	s4,80(sp)
ffffffffc020162e:	6aa6                	ld	s5,72(sp)
ffffffffc0201630:	6b06                	ld	s6,64(sp)
ffffffffc0201632:	7be2                	ld	s7,56(sp)
ffffffffc0201634:	7c42                	ld	s8,48(sp)
ffffffffc0201636:	7ca2                	ld	s9,40(sp)
ffffffffc0201638:	7d02                	ld	s10,32(sp)
ffffffffc020163a:	6de2                	ld	s11,24(sp)
ffffffffc020163c:	6109                	addi	sp,sp,128
ffffffffc020163e:	8082                	ret
ffffffffc0201640:	87b2                	mv	a5,a2
ffffffffc0201642:	00144603          	lbu	a2,1(s0)
ffffffffc0201646:	846a                	mv	s0,s10
ffffffffc0201648:	00140d13          	addi	s10,s0,1
ffffffffc020164c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201650:	0ff5f593          	zext.b	a1,a1
ffffffffc0201654:	fcb572e3          	bgeu	a0,a1,ffffffffc0201618 <vprintfmt+0x7c>
ffffffffc0201658:	85a6                	mv	a1,s1
ffffffffc020165a:	02500513          	li	a0,37
ffffffffc020165e:	9902                	jalr	s2
ffffffffc0201660:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201664:	8d22                	mv	s10,s0
ffffffffc0201666:	f73788e3          	beq	a5,s3,ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc020166a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020166e:	1d7d                	addi	s10,s10,-1
ffffffffc0201670:	ff379de3          	bne	a5,s3,ffffffffc020166a <vprintfmt+0xce>
ffffffffc0201674:	b78d                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc0201676:	fd060c1b          	addiw	s8,a2,-48
ffffffffc020167a:	00144603          	lbu	a2,1(s0)
ffffffffc020167e:	846a                	mv	s0,s10
ffffffffc0201680:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201684:	0006059b          	sext.w	a1,a2
ffffffffc0201688:	02d86463          	bltu	a6,a3,ffffffffc02016b0 <vprintfmt+0x114>
ffffffffc020168c:	00144603          	lbu	a2,1(s0)
ffffffffc0201690:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201694:	0186873b          	addw	a4,a3,s8
ffffffffc0201698:	0017171b          	slliw	a4,a4,0x1
ffffffffc020169c:	9f2d                	addw	a4,a4,a1
ffffffffc020169e:	fd06069b          	addiw	a3,a2,-48
ffffffffc02016a2:	0405                	addi	s0,s0,1
ffffffffc02016a4:	fd070c1b          	addiw	s8,a4,-48
ffffffffc02016a8:	0006059b          	sext.w	a1,a2
ffffffffc02016ac:	fed870e3          	bgeu	a6,a3,ffffffffc020168c <vprintfmt+0xf0>
ffffffffc02016b0:	f40ddce3          	bgez	s11,ffffffffc0201608 <vprintfmt+0x6c>
ffffffffc02016b4:	8de2                	mv	s11,s8
ffffffffc02016b6:	5c7d                	li	s8,-1
ffffffffc02016b8:	bf81                	j	ffffffffc0201608 <vprintfmt+0x6c>
ffffffffc02016ba:	fffdc693          	not	a3,s11
ffffffffc02016be:	96fd                	srai	a3,a3,0x3f
ffffffffc02016c0:	00ddfdb3          	and	s11,s11,a3
ffffffffc02016c4:	00144603          	lbu	a2,1(s0)
ffffffffc02016c8:	2d81                	sext.w	s11,s11
ffffffffc02016ca:	846a                	mv	s0,s10
ffffffffc02016cc:	bf35                	j	ffffffffc0201608 <vprintfmt+0x6c>
ffffffffc02016ce:	000a2c03          	lw	s8,0(s4)
ffffffffc02016d2:	00144603          	lbu	a2,1(s0)
ffffffffc02016d6:	0a21                	addi	s4,s4,8
ffffffffc02016d8:	846a                	mv	s0,s10
ffffffffc02016da:	bfd9                	j	ffffffffc02016b0 <vprintfmt+0x114>
ffffffffc02016dc:	4705                	li	a4,1
ffffffffc02016de:	008a0593          	addi	a1,s4,8
ffffffffc02016e2:	01174463          	blt	a4,a7,ffffffffc02016ea <vprintfmt+0x14e>
ffffffffc02016e6:	1a088e63          	beqz	a7,ffffffffc02018a2 <vprintfmt+0x306>
ffffffffc02016ea:	000a3603          	ld	a2,0(s4)
ffffffffc02016ee:	46c1                	li	a3,16
ffffffffc02016f0:	8a2e                	mv	s4,a1
ffffffffc02016f2:	2781                	sext.w	a5,a5
ffffffffc02016f4:	876e                	mv	a4,s11
ffffffffc02016f6:	85a6                	mv	a1,s1
ffffffffc02016f8:	854a                	mv	a0,s2
ffffffffc02016fa:	e37ff0ef          	jal	ra,ffffffffc0201530 <printnum>
ffffffffc02016fe:	bde1                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc0201700:	000a2503          	lw	a0,0(s4)
ffffffffc0201704:	85a6                	mv	a1,s1
ffffffffc0201706:	0a21                	addi	s4,s4,8
ffffffffc0201708:	9902                	jalr	s2
ffffffffc020170a:	b5f1                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc020170c:	4705                	li	a4,1
ffffffffc020170e:	008a0593          	addi	a1,s4,8
ffffffffc0201712:	01174463          	blt	a4,a7,ffffffffc020171a <vprintfmt+0x17e>
ffffffffc0201716:	18088163          	beqz	a7,ffffffffc0201898 <vprintfmt+0x2fc>
ffffffffc020171a:	000a3603          	ld	a2,0(s4)
ffffffffc020171e:	46a9                	li	a3,10
ffffffffc0201720:	8a2e                	mv	s4,a1
ffffffffc0201722:	bfc1                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc0201724:	00144603          	lbu	a2,1(s0)
ffffffffc0201728:	4c85                	li	s9,1
ffffffffc020172a:	846a                	mv	s0,s10
ffffffffc020172c:	bdf1                	j	ffffffffc0201608 <vprintfmt+0x6c>
ffffffffc020172e:	85a6                	mv	a1,s1
ffffffffc0201730:	02500513          	li	a0,37
ffffffffc0201734:	9902                	jalr	s2
ffffffffc0201736:	b545                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc0201738:	00144603          	lbu	a2,1(s0)
ffffffffc020173c:	2885                	addiw	a7,a7,1
ffffffffc020173e:	846a                	mv	s0,s10
ffffffffc0201740:	b5e1                	j	ffffffffc0201608 <vprintfmt+0x6c>
ffffffffc0201742:	4705                	li	a4,1
ffffffffc0201744:	008a0593          	addi	a1,s4,8
ffffffffc0201748:	01174463          	blt	a4,a7,ffffffffc0201750 <vprintfmt+0x1b4>
ffffffffc020174c:	14088163          	beqz	a7,ffffffffc020188e <vprintfmt+0x2f2>
ffffffffc0201750:	000a3603          	ld	a2,0(s4)
ffffffffc0201754:	46a1                	li	a3,8
ffffffffc0201756:	8a2e                	mv	s4,a1
ffffffffc0201758:	bf69                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc020175a:	03000513          	li	a0,48
ffffffffc020175e:	85a6                	mv	a1,s1
ffffffffc0201760:	e03e                	sd	a5,0(sp)
ffffffffc0201762:	9902                	jalr	s2
ffffffffc0201764:	85a6                	mv	a1,s1
ffffffffc0201766:	07800513          	li	a0,120
ffffffffc020176a:	9902                	jalr	s2
ffffffffc020176c:	0a21                	addi	s4,s4,8
ffffffffc020176e:	6782                	ld	a5,0(sp)
ffffffffc0201770:	46c1                	li	a3,16
ffffffffc0201772:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201776:	bfb5                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc0201778:	000a3403          	ld	s0,0(s4)
ffffffffc020177c:	008a0713          	addi	a4,s4,8
ffffffffc0201780:	e03a                	sd	a4,0(sp)
ffffffffc0201782:	14040263          	beqz	s0,ffffffffc02018c6 <vprintfmt+0x32a>
ffffffffc0201786:	0fb05763          	blez	s11,ffffffffc0201874 <vprintfmt+0x2d8>
ffffffffc020178a:	02d00693          	li	a3,45
ffffffffc020178e:	0cd79163          	bne	a5,a3,ffffffffc0201850 <vprintfmt+0x2b4>
ffffffffc0201792:	00044783          	lbu	a5,0(s0)
ffffffffc0201796:	0007851b          	sext.w	a0,a5
ffffffffc020179a:	cf85                	beqz	a5,ffffffffc02017d2 <vprintfmt+0x236>
ffffffffc020179c:	00140a13          	addi	s4,s0,1
ffffffffc02017a0:	05e00413          	li	s0,94
ffffffffc02017a4:	000c4563          	bltz	s8,ffffffffc02017ae <vprintfmt+0x212>
ffffffffc02017a8:	3c7d                	addiw	s8,s8,-1
ffffffffc02017aa:	036c0263          	beq	s8,s6,ffffffffc02017ce <vprintfmt+0x232>
ffffffffc02017ae:	85a6                	mv	a1,s1
ffffffffc02017b0:	0e0c8e63          	beqz	s9,ffffffffc02018ac <vprintfmt+0x310>
ffffffffc02017b4:	3781                	addiw	a5,a5,-32
ffffffffc02017b6:	0ef47b63          	bgeu	s0,a5,ffffffffc02018ac <vprintfmt+0x310>
ffffffffc02017ba:	03f00513          	li	a0,63
ffffffffc02017be:	9902                	jalr	s2
ffffffffc02017c0:	000a4783          	lbu	a5,0(s4)
ffffffffc02017c4:	3dfd                	addiw	s11,s11,-1
ffffffffc02017c6:	0a05                	addi	s4,s4,1
ffffffffc02017c8:	0007851b          	sext.w	a0,a5
ffffffffc02017cc:	ffe1                	bnez	a5,ffffffffc02017a4 <vprintfmt+0x208>
ffffffffc02017ce:	01b05963          	blez	s11,ffffffffc02017e0 <vprintfmt+0x244>
ffffffffc02017d2:	3dfd                	addiw	s11,s11,-1
ffffffffc02017d4:	85a6                	mv	a1,s1
ffffffffc02017d6:	02000513          	li	a0,32
ffffffffc02017da:	9902                	jalr	s2
ffffffffc02017dc:	fe0d9be3          	bnez	s11,ffffffffc02017d2 <vprintfmt+0x236>
ffffffffc02017e0:	6a02                	ld	s4,0(sp)
ffffffffc02017e2:	bbd5                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc02017e4:	4705                	li	a4,1
ffffffffc02017e6:	008a0c93          	addi	s9,s4,8
ffffffffc02017ea:	01174463          	blt	a4,a7,ffffffffc02017f2 <vprintfmt+0x256>
ffffffffc02017ee:	08088d63          	beqz	a7,ffffffffc0201888 <vprintfmt+0x2ec>
ffffffffc02017f2:	000a3403          	ld	s0,0(s4)
ffffffffc02017f6:	0a044d63          	bltz	s0,ffffffffc02018b0 <vprintfmt+0x314>
ffffffffc02017fa:	8622                	mv	a2,s0
ffffffffc02017fc:	8a66                	mv	s4,s9
ffffffffc02017fe:	46a9                	li	a3,10
ffffffffc0201800:	bdcd                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc0201802:	000a2783          	lw	a5,0(s4)
ffffffffc0201806:	4719                	li	a4,6
ffffffffc0201808:	0a21                	addi	s4,s4,8
ffffffffc020180a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020180e:	8fb5                	xor	a5,a5,a3
ffffffffc0201810:	40d786bb          	subw	a3,a5,a3
ffffffffc0201814:	02d74163          	blt	a4,a3,ffffffffc0201836 <vprintfmt+0x29a>
ffffffffc0201818:	00369793          	slli	a5,a3,0x3
ffffffffc020181c:	97de                	add	a5,a5,s7
ffffffffc020181e:	639c                	ld	a5,0(a5)
ffffffffc0201820:	cb99                	beqz	a5,ffffffffc0201836 <vprintfmt+0x29a>
ffffffffc0201822:	86be                	mv	a3,a5
ffffffffc0201824:	00001617          	auipc	a2,0x1
ffffffffc0201828:	e1c60613          	addi	a2,a2,-484 # ffffffffc0202640 <buddy_pmm_manager+0x68>
ffffffffc020182c:	85a6                	mv	a1,s1
ffffffffc020182e:	854a                	mv	a0,s2
ffffffffc0201830:	0ce000ef          	jal	ra,ffffffffc02018fe <printfmt>
ffffffffc0201834:	b34d                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc0201836:	00001617          	auipc	a2,0x1
ffffffffc020183a:	dfa60613          	addi	a2,a2,-518 # ffffffffc0202630 <buddy_pmm_manager+0x58>
ffffffffc020183e:	85a6                	mv	a1,s1
ffffffffc0201840:	854a                	mv	a0,s2
ffffffffc0201842:	0bc000ef          	jal	ra,ffffffffc02018fe <printfmt>
ffffffffc0201846:	bb41                	j	ffffffffc02015d6 <vprintfmt+0x3a>
ffffffffc0201848:	00001417          	auipc	s0,0x1
ffffffffc020184c:	de040413          	addi	s0,s0,-544 # ffffffffc0202628 <buddy_pmm_manager+0x50>
ffffffffc0201850:	85e2                	mv	a1,s8
ffffffffc0201852:	8522                	mv	a0,s0
ffffffffc0201854:	e43e                	sd	a5,8(sp)
ffffffffc0201856:	c79ff0ef          	jal	ra,ffffffffc02014ce <strnlen>
ffffffffc020185a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020185e:	01b05b63          	blez	s11,ffffffffc0201874 <vprintfmt+0x2d8>
ffffffffc0201862:	67a2                	ld	a5,8(sp)
ffffffffc0201864:	00078a1b          	sext.w	s4,a5
ffffffffc0201868:	3dfd                	addiw	s11,s11,-1
ffffffffc020186a:	85a6                	mv	a1,s1
ffffffffc020186c:	8552                	mv	a0,s4
ffffffffc020186e:	9902                	jalr	s2
ffffffffc0201870:	fe0d9ce3          	bnez	s11,ffffffffc0201868 <vprintfmt+0x2cc>
ffffffffc0201874:	00044783          	lbu	a5,0(s0)
ffffffffc0201878:	00140a13          	addi	s4,s0,1
ffffffffc020187c:	0007851b          	sext.w	a0,a5
ffffffffc0201880:	d3a5                	beqz	a5,ffffffffc02017e0 <vprintfmt+0x244>
ffffffffc0201882:	05e00413          	li	s0,94
ffffffffc0201886:	bf39                	j	ffffffffc02017a4 <vprintfmt+0x208>
ffffffffc0201888:	000a2403          	lw	s0,0(s4)
ffffffffc020188c:	b7ad                	j	ffffffffc02017f6 <vprintfmt+0x25a>
ffffffffc020188e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201892:	46a1                	li	a3,8
ffffffffc0201894:	8a2e                	mv	s4,a1
ffffffffc0201896:	bdb1                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc0201898:	000a6603          	lwu	a2,0(s4)
ffffffffc020189c:	46a9                	li	a3,10
ffffffffc020189e:	8a2e                	mv	s4,a1
ffffffffc02018a0:	bd89                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc02018a2:	000a6603          	lwu	a2,0(s4)
ffffffffc02018a6:	46c1                	li	a3,16
ffffffffc02018a8:	8a2e                	mv	s4,a1
ffffffffc02018aa:	b5a1                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc02018ac:	9902                	jalr	s2
ffffffffc02018ae:	bf09                	j	ffffffffc02017c0 <vprintfmt+0x224>
ffffffffc02018b0:	85a6                	mv	a1,s1
ffffffffc02018b2:	02d00513          	li	a0,45
ffffffffc02018b6:	e03e                	sd	a5,0(sp)
ffffffffc02018b8:	9902                	jalr	s2
ffffffffc02018ba:	6782                	ld	a5,0(sp)
ffffffffc02018bc:	8a66                	mv	s4,s9
ffffffffc02018be:	40800633          	neg	a2,s0
ffffffffc02018c2:	46a9                	li	a3,10
ffffffffc02018c4:	b53d                	j	ffffffffc02016f2 <vprintfmt+0x156>
ffffffffc02018c6:	03b05163          	blez	s11,ffffffffc02018e8 <vprintfmt+0x34c>
ffffffffc02018ca:	02d00693          	li	a3,45
ffffffffc02018ce:	f6d79de3          	bne	a5,a3,ffffffffc0201848 <vprintfmt+0x2ac>
ffffffffc02018d2:	00001417          	auipc	s0,0x1
ffffffffc02018d6:	d5640413          	addi	s0,s0,-682 # ffffffffc0202628 <buddy_pmm_manager+0x50>
ffffffffc02018da:	02800793          	li	a5,40
ffffffffc02018de:	02800513          	li	a0,40
ffffffffc02018e2:	00140a13          	addi	s4,s0,1
ffffffffc02018e6:	bd6d                	j	ffffffffc02017a0 <vprintfmt+0x204>
ffffffffc02018e8:	00001a17          	auipc	s4,0x1
ffffffffc02018ec:	d41a0a13          	addi	s4,s4,-703 # ffffffffc0202629 <buddy_pmm_manager+0x51>
ffffffffc02018f0:	02800513          	li	a0,40
ffffffffc02018f4:	02800793          	li	a5,40
ffffffffc02018f8:	05e00413          	li	s0,94
ffffffffc02018fc:	b565                	j	ffffffffc02017a4 <vprintfmt+0x208>

ffffffffc02018fe <printfmt>:
ffffffffc02018fe:	715d                	addi	sp,sp,-80
ffffffffc0201900:	02810313          	addi	t1,sp,40
ffffffffc0201904:	f436                	sd	a3,40(sp)
ffffffffc0201906:	869a                	mv	a3,t1
ffffffffc0201908:	ec06                	sd	ra,24(sp)
ffffffffc020190a:	f83a                	sd	a4,48(sp)
ffffffffc020190c:	fc3e                	sd	a5,56(sp)
ffffffffc020190e:	e0c2                	sd	a6,64(sp)
ffffffffc0201910:	e4c6                	sd	a7,72(sp)
ffffffffc0201912:	e41a                	sd	t1,8(sp)
ffffffffc0201914:	c89ff0ef          	jal	ra,ffffffffc020159c <vprintfmt>
ffffffffc0201918:	60e2                	ld	ra,24(sp)
ffffffffc020191a:	6161                	addi	sp,sp,80
ffffffffc020191c:	8082                	ret

ffffffffc020191e <readline>:
ffffffffc020191e:	715d                	addi	sp,sp,-80
ffffffffc0201920:	e486                	sd	ra,72(sp)
ffffffffc0201922:	e0a6                	sd	s1,64(sp)
ffffffffc0201924:	fc4a                	sd	s2,56(sp)
ffffffffc0201926:	f84e                	sd	s3,48(sp)
ffffffffc0201928:	f452                	sd	s4,40(sp)
ffffffffc020192a:	f056                	sd	s5,32(sp)
ffffffffc020192c:	ec5a                	sd	s6,24(sp)
ffffffffc020192e:	e85e                	sd	s7,16(sp)
ffffffffc0201930:	c901                	beqz	a0,ffffffffc0201940 <readline+0x22>
ffffffffc0201932:	85aa                	mv	a1,a0
ffffffffc0201934:	00001517          	auipc	a0,0x1
ffffffffc0201938:	d0c50513          	addi	a0,a0,-756 # ffffffffc0202640 <buddy_pmm_manager+0x68>
ffffffffc020193c:	f7efe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201940:	4481                	li	s1,0
ffffffffc0201942:	497d                	li	s2,31
ffffffffc0201944:	49a1                	li	s3,8
ffffffffc0201946:	4aa9                	li	s5,10
ffffffffc0201948:	4b35                	li	s6,13
ffffffffc020194a:	00004b97          	auipc	s7,0x4
ffffffffc020194e:	6feb8b93          	addi	s7,s7,1790 # ffffffffc0206048 <buf>
ffffffffc0201952:	3fe00a13          	li	s4,1022
ffffffffc0201956:	fdcfe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc020195a:	00054a63          	bltz	a0,ffffffffc020196e <readline+0x50>
ffffffffc020195e:	00a95a63          	bge	s2,a0,ffffffffc0201972 <readline+0x54>
ffffffffc0201962:	029a5263          	bge	s4,s1,ffffffffc0201986 <readline+0x68>
ffffffffc0201966:	fccfe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc020196a:	fe055ae3          	bgez	a0,ffffffffc020195e <readline+0x40>
ffffffffc020196e:	4501                	li	a0,0
ffffffffc0201970:	a091                	j	ffffffffc02019b4 <readline+0x96>
ffffffffc0201972:	03351463          	bne	a0,s3,ffffffffc020199a <readline+0x7c>
ffffffffc0201976:	e8a9                	bnez	s1,ffffffffc02019c8 <readline+0xaa>
ffffffffc0201978:	fbafe0ef          	jal	ra,ffffffffc0200132 <getchar>
ffffffffc020197c:	fe0549e3          	bltz	a0,ffffffffc020196e <readline+0x50>
ffffffffc0201980:	fea959e3          	bge	s2,a0,ffffffffc0201972 <readline+0x54>
ffffffffc0201984:	4481                	li	s1,0
ffffffffc0201986:	e42a                	sd	a0,8(sp)
ffffffffc0201988:	f68fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc020198c:	6522                	ld	a0,8(sp)
ffffffffc020198e:	009b87b3          	add	a5,s7,s1
ffffffffc0201992:	2485                	addiw	s1,s1,1
ffffffffc0201994:	00a78023          	sb	a0,0(a5)
ffffffffc0201998:	bf7d                	j	ffffffffc0201956 <readline+0x38>
ffffffffc020199a:	01550463          	beq	a0,s5,ffffffffc02019a2 <readline+0x84>
ffffffffc020199e:	fb651ce3          	bne	a0,s6,ffffffffc0201956 <readline+0x38>
ffffffffc02019a2:	f4efe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc02019a6:	00004517          	auipc	a0,0x4
ffffffffc02019aa:	6a250513          	addi	a0,a0,1698 # ffffffffc0206048 <buf>
ffffffffc02019ae:	94aa                	add	s1,s1,a0
ffffffffc02019b0:	00048023          	sb	zero,0(s1)
ffffffffc02019b4:	60a6                	ld	ra,72(sp)
ffffffffc02019b6:	6486                	ld	s1,64(sp)
ffffffffc02019b8:	7962                	ld	s2,56(sp)
ffffffffc02019ba:	79c2                	ld	s3,48(sp)
ffffffffc02019bc:	7a22                	ld	s4,40(sp)
ffffffffc02019be:	7a82                	ld	s5,32(sp)
ffffffffc02019c0:	6b62                	ld	s6,24(sp)
ffffffffc02019c2:	6bc2                	ld	s7,16(sp)
ffffffffc02019c4:	6161                	addi	sp,sp,80
ffffffffc02019c6:	8082                	ret
ffffffffc02019c8:	4521                	li	a0,8
ffffffffc02019ca:	f26fe0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc02019ce:	34fd                	addiw	s1,s1,-1
ffffffffc02019d0:	b759                	j	ffffffffc0201956 <readline+0x38>

ffffffffc02019d2 <sbi_console_putchar>:
ffffffffc02019d2:	4781                	li	a5,0
ffffffffc02019d4:	00004717          	auipc	a4,0x4
ffffffffc02019d8:	64c73703          	ld	a4,1612(a4) # ffffffffc0206020 <SBI_CONSOLE_PUTCHAR>
ffffffffc02019dc:	88ba                	mv	a7,a4
ffffffffc02019de:	852a                	mv	a0,a0
ffffffffc02019e0:	85be                	mv	a1,a5
ffffffffc02019e2:	863e                	mv	a2,a5
ffffffffc02019e4:	00000073          	ecall
ffffffffc02019e8:	87aa                	mv	a5,a0
ffffffffc02019ea:	8082                	ret

ffffffffc02019ec <sbi_set_timer>:
ffffffffc02019ec:	4781                	li	a5,0
ffffffffc02019ee:	00005717          	auipc	a4,0x5
ffffffffc02019f2:	ac273703          	ld	a4,-1342(a4) # ffffffffc02064b0 <SBI_SET_TIMER>
ffffffffc02019f6:	88ba                	mv	a7,a4
ffffffffc02019f8:	852a                	mv	a0,a0
ffffffffc02019fa:	85be                	mv	a1,a5
ffffffffc02019fc:	863e                	mv	a2,a5
ffffffffc02019fe:	00000073          	ecall
ffffffffc0201a02:	87aa                	mv	a5,a0
ffffffffc0201a04:	8082                	ret

ffffffffc0201a06 <sbi_console_getchar>:
ffffffffc0201a06:	4501                	li	a0,0
ffffffffc0201a08:	00004797          	auipc	a5,0x4
ffffffffc0201a0c:	6107b783          	ld	a5,1552(a5) # ffffffffc0206018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201a10:	88be                	mv	a7,a5
ffffffffc0201a12:	852a                	mv	a0,a0
ffffffffc0201a14:	85aa                	mv	a1,a0
ffffffffc0201a16:	862a                	mv	a2,a0
ffffffffc0201a18:	00000073          	ecall
ffffffffc0201a1c:	852a                	mv	a0,a0
ffffffffc0201a1e:	2501                	sext.w	a0,a0
ffffffffc0201a20:	8082                	ret

ffffffffc0201a22 <sbi_shutdown>:
ffffffffc0201a22:	4781                	li	a5,0
ffffffffc0201a24:	00004717          	auipc	a4,0x4
ffffffffc0201a28:	60473703          	ld	a4,1540(a4) # ffffffffc0206028 <SBI_SHUTDOWN>
ffffffffc0201a2c:	88ba                	mv	a7,a4
ffffffffc0201a2e:	853e                	mv	a0,a5
ffffffffc0201a30:	85be                	mv	a1,a5
ffffffffc0201a32:	863e                	mv	a2,a5
ffffffffc0201a34:	00000073          	ecall
ffffffffc0201a38:	87aa                	mv	a5,a0
ffffffffc0201a3a:	8082                	ret
