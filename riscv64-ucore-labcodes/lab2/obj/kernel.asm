
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
ffffffffc020003e:	47e60613          	addi	a2,a2,1150 # ffffffffc02064b8 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
<<<<<<< HEAD
ffffffffc020004a:	219010ef          	jal	ra,ffffffffc0201a62 <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	a2650513          	addi	a0,a0,-1498 # ffffffffc0201a78 <etext+0x4>
=======
ffffffffc020004a:	768010ef          	jal	ra,ffffffffc02017b2 <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	c7e50513          	addi	a0,a0,-898 # ffffffffc0201cd0 <etext>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>
ffffffffc020005e:	0dc000ef          	jal	ra,ffffffffc020013a <print_kerninfo>
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>
<<<<<<< HEAD
ffffffffc0200066:	30c010ef          	jal	ra,ffffffffc0201372 <pmm_init>
=======
ffffffffc0200066:	0c5000ef          	jal	ra,ffffffffc020092a <pmm_init>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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
<<<<<<< HEAD
ffffffffc02000a6:	4cc010ef          	jal	ra,ffffffffc0201572 <vprintfmt>
=======
ffffffffc02000a6:	78a010ef          	jal	ra,ffffffffc0201830 <vprintfmt>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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
<<<<<<< HEAD
ffffffffc02000dc:	496010ef          	jal	ra,ffffffffc0201572 <vprintfmt>
=======
ffffffffc02000dc:	754010ef          	jal	ra,ffffffffc0201830 <vprintfmt>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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

<<<<<<< HEAD
ffffffffc020013a <print_kerninfo>:
ffffffffc020013a:	1141                	addi	sp,sp,-16
ffffffffc020013c:	00002517          	auipc	a0,0x2
ffffffffc0200140:	95c50513          	addi	a0,a0,-1700 # ffffffffc0201a98 <etext+0x24>
ffffffffc0200144:	e406                	sd	ra,8(sp)
ffffffffc0200146:	f6dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020014a:	00000597          	auipc	a1,0x0
ffffffffc020014e:	ee858593          	addi	a1,a1,-280 # ffffffffc0200032 <kern_init>
ffffffffc0200152:	00002517          	auipc	a0,0x2
ffffffffc0200156:	96650513          	addi	a0,a0,-1690 # ffffffffc0201ab8 <etext+0x44>
ffffffffc020015a:	f59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020015e:	00002597          	auipc	a1,0x2
ffffffffc0200162:	91658593          	addi	a1,a1,-1770 # ffffffffc0201a74 <etext>
ffffffffc0200166:	00002517          	auipc	a0,0x2
ffffffffc020016a:	97250513          	addi	a0,a0,-1678 # ffffffffc0201ad8 <etext+0x64>
ffffffffc020016e:	f45ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200172:	00006597          	auipc	a1,0x6
ffffffffc0200176:	ea658593          	addi	a1,a1,-346 # ffffffffc0206018 <free_area>
ffffffffc020017a:	00002517          	auipc	a0,0x2
ffffffffc020017e:	97e50513          	addi	a0,a0,-1666 # ffffffffc0201af8 <etext+0x84>
ffffffffc0200182:	f31ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200186:	00006597          	auipc	a1,0x6
ffffffffc020018a:	2fa58593          	addi	a1,a1,762 # ffffffffc0206480 <end>
ffffffffc020018e:	00002517          	auipc	a0,0x2
ffffffffc0200192:	98a50513          	addi	a0,a0,-1654 # ffffffffc0201b18 <etext+0xa4>
ffffffffc0200196:	f1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020019a:	00006597          	auipc	a1,0x6
ffffffffc020019e:	6e558593          	addi	a1,a1,1765 # ffffffffc020687f <end+0x3ff>
ffffffffc02001a2:	00000797          	auipc	a5,0x0
ffffffffc02001a6:	e9078793          	addi	a5,a5,-368 # ffffffffc0200032 <kern_init>
ffffffffc02001aa:	40f587b3          	sub	a5,a1,a5
ffffffffc02001ae:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02001b2:	60a2                	ld	ra,8(sp)
ffffffffc02001b4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001b8:	95be                	add	a1,a1,a5
ffffffffc02001ba:	85a9                	srai	a1,a1,0xa
ffffffffc02001bc:	00002517          	auipc	a0,0x2
ffffffffc02001c0:	97c50513          	addi	a0,a0,-1668 # ffffffffc0201b38 <etext+0xc4>
ffffffffc02001c4:	0141                	addi	sp,sp,16
ffffffffc02001c6:	b5f5                	j	ffffffffc02000b2 <cprintf>

ffffffffc02001c8 <print_stackframe>:
ffffffffc02001c8:	1141                	addi	sp,sp,-16
ffffffffc02001ca:	00002617          	auipc	a2,0x2
ffffffffc02001ce:	99e60613          	addi	a2,a2,-1634 # ffffffffc0201b68 <etext+0xf4>
ffffffffc02001d2:	04e00593          	li	a1,78
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201b80 <etext+0x10c>
ffffffffc02001de:	e406                	sd	ra,8(sp)
ffffffffc02001e0:	1cc000ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc02001e4 <mon_help>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	00002617          	auipc	a2,0x2
ffffffffc02001ea:	9b260613          	addi	a2,a2,-1614 # ffffffffc0201b98 <etext+0x124>
ffffffffc02001ee:	00002597          	auipc	a1,0x2
ffffffffc02001f2:	9ca58593          	addi	a1,a1,-1590 # ffffffffc0201bb8 <etext+0x144>
ffffffffc02001f6:	00002517          	auipc	a0,0x2
ffffffffc02001fa:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0201bc0 <etext+0x14c>
ffffffffc02001fe:	e406                	sd	ra,8(sp)
ffffffffc0200200:	eb3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200204:	00002617          	auipc	a2,0x2
ffffffffc0200208:	9cc60613          	addi	a2,a2,-1588 # ffffffffc0201bd0 <etext+0x15c>
ffffffffc020020c:	00002597          	auipc	a1,0x2
ffffffffc0200210:	9ec58593          	addi	a1,a1,-1556 # ffffffffc0201bf8 <etext+0x184>
ffffffffc0200214:	00002517          	auipc	a0,0x2
ffffffffc0200218:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0201bc0 <etext+0x14c>
ffffffffc020021c:	e97ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200220:	00002617          	auipc	a2,0x2
ffffffffc0200224:	9e860613          	addi	a2,a2,-1560 # ffffffffc0201c08 <etext+0x194>
ffffffffc0200228:	00002597          	auipc	a1,0x2
ffffffffc020022c:	a0058593          	addi	a1,a1,-1536 # ffffffffc0201c28 <etext+0x1b4>
ffffffffc0200230:	00002517          	auipc	a0,0x2
ffffffffc0200234:	99050513          	addi	a0,a0,-1648 # ffffffffc0201bc0 <etext+0x14c>
ffffffffc0200238:	e7bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020023c:	60a2                	ld	ra,8(sp)
ffffffffc020023e:	4501                	li	a0,0
ffffffffc0200240:	0141                	addi	sp,sp,16
ffffffffc0200242:	8082                	ret

ffffffffc0200244 <mon_kerninfo>:
ffffffffc0200244:	1141                	addi	sp,sp,-16
ffffffffc0200246:	e406                	sd	ra,8(sp)
ffffffffc0200248:	ef3ff0ef          	jal	ra,ffffffffc020013a <print_kerninfo>
ffffffffc020024c:	60a2                	ld	ra,8(sp)
ffffffffc020024e:	4501                	li	a0,0
ffffffffc0200250:	0141                	addi	sp,sp,16
ffffffffc0200252:	8082                	ret

ffffffffc0200254 <mon_backtrace>:
ffffffffc0200254:	1141                	addi	sp,sp,-16
ffffffffc0200256:	e406                	sd	ra,8(sp)
ffffffffc0200258:	f71ff0ef          	jal	ra,ffffffffc02001c8 <print_stackframe>
ffffffffc020025c:	60a2                	ld	ra,8(sp)
ffffffffc020025e:	4501                	li	a0,0
ffffffffc0200260:	0141                	addi	sp,sp,16
ffffffffc0200262:	8082                	ret

ffffffffc0200264 <kmonitor>:
ffffffffc0200264:	7115                	addi	sp,sp,-224
ffffffffc0200266:	ed5e                	sd	s7,152(sp)
ffffffffc0200268:	8baa                	mv	s7,a0
ffffffffc020026a:	00002517          	auipc	a0,0x2
ffffffffc020026e:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0201c38 <etext+0x1c4>
ffffffffc0200272:	ed86                	sd	ra,216(sp)
ffffffffc0200274:	e9a2                	sd	s0,208(sp)
ffffffffc0200276:	e5a6                	sd	s1,200(sp)
ffffffffc0200278:	e1ca                	sd	s2,192(sp)
ffffffffc020027a:	fd4e                	sd	s3,184(sp)
ffffffffc020027c:	f952                	sd	s4,176(sp)
ffffffffc020027e:	f556                	sd	s5,168(sp)
ffffffffc0200280:	f15a                	sd	s6,160(sp)
ffffffffc0200282:	e962                	sd	s8,144(sp)
ffffffffc0200284:	e566                	sd	s9,136(sp)
ffffffffc0200286:	e16a                	sd	s10,128(sp)
ffffffffc0200288:	e2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	9d450513          	addi	a0,a0,-1580 # ffffffffc0201c60 <etext+0x1ec>
=======
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
ffffffffc020016c:	b8850513          	addi	a0,a0,-1144 # ffffffffc0201cf0 <etext+0x20>
ffffffffc0200170:	e43e                	sd	a5,8(sp)
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	c5a50513          	addi	a0,a0,-934 # ffffffffc0201dd8 <etext+0x108>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
ffffffffc0200196:	1141                	addi	sp,sp,-16
ffffffffc0200198:	00002517          	auipc	a0,0x2
ffffffffc020019c:	b7850513          	addi	a0,a0,-1160 # ffffffffc0201d10 <etext+0x40>
ffffffffc02001a0:	e406                	sd	ra,8(sp)
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00002517          	auipc	a0,0x2
ffffffffc02001b2:	b8250513          	addi	a0,a0,-1150 # ffffffffc0201d30 <etext+0x60>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ba:	00002597          	auipc	a1,0x2
ffffffffc02001be:	b1658593          	addi	a1,a1,-1258 # ffffffffc0201cd0 <etext>
ffffffffc02001c2:	00002517          	auipc	a0,0x2
ffffffffc02001c6:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0201d50 <etext+0x80>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4a58593          	addi	a1,a1,-438 # ffffffffc0206018 <free_area>
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0201d70 <etext+0xa0>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	2d658593          	addi	a1,a1,726 # ffffffffc02064b8 <end>
ffffffffc02001ea:	00002517          	auipc	a0,0x2
ffffffffc02001ee:	ba650513          	addi	a0,a0,-1114 # ffffffffc0201d90 <etext+0xc0>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	6c158593          	addi	a1,a1,1729 # ffffffffc02068b7 <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020020e:	60a2                	ld	ra,8(sp)
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00002517          	auipc	a0,0x2
ffffffffc020021c:	b9850513          	addi	a0,a0,-1128 # ffffffffc0201db0 <etext+0xe0>
ffffffffc0200220:	0141                	addi	sp,sp,16
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00002617          	auipc	a2,0x2
ffffffffc020022a:	bba60613          	addi	a2,a2,-1094 # ffffffffc0201de0 <etext+0x110>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00002517          	auipc	a0,0x2
ffffffffc0200236:	bc650513          	addi	a0,a0,-1082 # ffffffffc0201df8 <etext+0x128>
ffffffffc020023a:	e406                	sd	ra,8(sp)
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
ffffffffc0200240:	1141                	addi	sp,sp,-16
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	bce60613          	addi	a2,a2,-1074 # ffffffffc0201e10 <etext+0x140>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	be658593          	addi	a1,a1,-1050 # ffffffffc0201e30 <etext+0x160>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	be650513          	addi	a0,a0,-1050 # ffffffffc0201e38 <etext+0x168>
ffffffffc020025a:	e406                	sd	ra,8(sp)
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	be860613          	addi	a2,a2,-1048 # ffffffffc0201e48 <etext+0x178>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	c0858593          	addi	a1,a1,-1016 # ffffffffc0201e70 <etext+0x1a0>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	bc850513          	addi	a0,a0,-1080 # ffffffffc0201e38 <etext+0x168>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00002617          	auipc	a2,0x2
ffffffffc0200280:	c0460613          	addi	a2,a2,-1020 # ffffffffc0201e80 <etext+0x1b0>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	c1c58593          	addi	a1,a1,-996 # ffffffffc0201ea0 <etext+0x1d0>
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	bac50513          	addi	a0,a0,-1108 # ffffffffc0201e38 <etext+0x168>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200298:	000b8563          	beqz	s7,ffffffffc02002a2 <kmonitor+0x3e>
ffffffffc020029c:	855e                	mv	a0,s7
ffffffffc020029e:	3a4000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002a2:	00002c17          	auipc	s8,0x2
ffffffffc02002a6:	a2ec0c13          	addi	s8,s8,-1490 # ffffffffc0201cd0 <commands>
ffffffffc02002aa:	00002917          	auipc	s2,0x2
ffffffffc02002ae:	9de90913          	addi	s2,s2,-1570 # ffffffffc0201c88 <etext+0x214>
ffffffffc02002b2:	00002497          	auipc	s1,0x2
ffffffffc02002b6:	9de48493          	addi	s1,s1,-1570 # ffffffffc0201c90 <etext+0x21c>
ffffffffc02002ba:	49bd                	li	s3,15
ffffffffc02002bc:	00002b17          	auipc	s6,0x2
ffffffffc02002c0:	9dcb0b13          	addi	s6,s6,-1572 # ffffffffc0201c98 <etext+0x224>
ffffffffc02002c4:	00002a17          	auipc	s4,0x2
ffffffffc02002c8:	8f4a0a13          	addi	s4,s4,-1804 # ffffffffc0201bb8 <etext+0x144>
ffffffffc02002cc:	4a8d                	li	s5,3
ffffffffc02002ce:	854a                	mv	a0,s2
ffffffffc02002d0:	624010ef          	jal	ra,ffffffffc02018f4 <readline>
ffffffffc02002d4:	842a                	mv	s0,a0
ffffffffc02002d6:	dd65                	beqz	a0,ffffffffc02002ce <kmonitor+0x6a>
ffffffffc02002d8:	00054583          	lbu	a1,0(a0)
ffffffffc02002dc:	4c81                	li	s9,0
ffffffffc02002de:	e1bd                	bnez	a1,ffffffffc0200344 <kmonitor+0xe0>
ffffffffc02002e0:	fe0c87e3          	beqz	s9,ffffffffc02002ce <kmonitor+0x6a>
ffffffffc02002e4:	6582                	ld	a1,0(sp)
ffffffffc02002e6:	00002d17          	auipc	s10,0x2
ffffffffc02002ea:	9ead0d13          	addi	s10,s10,-1558 # ffffffffc0201cd0 <commands>
ffffffffc02002ee:	8552                	mv	a0,s4
ffffffffc02002f0:	4401                	li	s0,0
ffffffffc02002f2:	0d61                	addi	s10,s10,24
ffffffffc02002f4:	73a010ef          	jal	ra,ffffffffc0201a2e <strcmp>
ffffffffc02002f8:	c919                	beqz	a0,ffffffffc020030e <kmonitor+0xaa>
ffffffffc02002fa:	2405                	addiw	s0,s0,1
ffffffffc02002fc:	0b540063          	beq	s0,s5,ffffffffc020039c <kmonitor+0x138>
ffffffffc0200300:	000d3503          	ld	a0,0(s10)
ffffffffc0200304:	6582                	ld	a1,0(sp)
ffffffffc0200306:	0d61                	addi	s10,s10,24
ffffffffc0200308:	726010ef          	jal	ra,ffffffffc0201a2e <strcmp>
ffffffffc020030c:	f57d                	bnez	a0,ffffffffc02002fa <kmonitor+0x96>
ffffffffc020030e:	00141793          	slli	a5,s0,0x1
ffffffffc0200312:	97a2                	add	a5,a5,s0
ffffffffc0200314:	078e                	slli	a5,a5,0x3
ffffffffc0200316:	97e2                	add	a5,a5,s8
ffffffffc0200318:	6b9c                	ld	a5,16(a5)
ffffffffc020031a:	865e                	mv	a2,s7
ffffffffc020031c:	002c                	addi	a1,sp,8
ffffffffc020031e:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200322:	9782                	jalr	a5
ffffffffc0200324:	fa0555e3          	bgez	a0,ffffffffc02002ce <kmonitor+0x6a>
ffffffffc0200328:	60ee                	ld	ra,216(sp)
ffffffffc020032a:	644e                	ld	s0,208(sp)
ffffffffc020032c:	64ae                	ld	s1,200(sp)
ffffffffc020032e:	690e                	ld	s2,192(sp)
ffffffffc0200330:	79ea                	ld	s3,184(sp)
ffffffffc0200332:	7a4a                	ld	s4,176(sp)
ffffffffc0200334:	7aaa                	ld	s5,168(sp)
ffffffffc0200336:	7b0a                	ld	s6,160(sp)
ffffffffc0200338:	6bea                	ld	s7,152(sp)
ffffffffc020033a:	6c4a                	ld	s8,144(sp)
ffffffffc020033c:	6caa                	ld	s9,136(sp)
ffffffffc020033e:	6d0a                	ld	s10,128(sp)
ffffffffc0200340:	612d                	addi	sp,sp,224
ffffffffc0200342:	8082                	ret
ffffffffc0200344:	8526                	mv	a0,s1
ffffffffc0200346:	706010ef          	jal	ra,ffffffffc0201a4c <strchr>
ffffffffc020034a:	c901                	beqz	a0,ffffffffc020035a <kmonitor+0xf6>
ffffffffc020034c:	00144583          	lbu	a1,1(s0)
ffffffffc0200350:	00040023          	sb	zero,0(s0)
ffffffffc0200354:	0405                	addi	s0,s0,1
ffffffffc0200356:	d5c9                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200358:	b7f5                	j	ffffffffc0200344 <kmonitor+0xe0>
ffffffffc020035a:	00044783          	lbu	a5,0(s0)
ffffffffc020035e:	d3c9                	beqz	a5,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200360:	033c8963          	beq	s9,s3,ffffffffc0200392 <kmonitor+0x12e>
ffffffffc0200364:	003c9793          	slli	a5,s9,0x3
ffffffffc0200368:	0118                	addi	a4,sp,128
ffffffffc020036a:	97ba                	add	a5,a5,a4
ffffffffc020036c:	f887b023          	sd	s0,-128(a5)
ffffffffc0200370:	00044583          	lbu	a1,0(s0)
ffffffffc0200374:	2c85                	addiw	s9,s9,1
ffffffffc0200376:	e591                	bnez	a1,ffffffffc0200382 <kmonitor+0x11e>
ffffffffc0200378:	b7b5                	j	ffffffffc02002e4 <kmonitor+0x80>
ffffffffc020037a:	00144583          	lbu	a1,1(s0)
ffffffffc020037e:	0405                	addi	s0,s0,1
ffffffffc0200380:	d1a5                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200382:	8526                	mv	a0,s1
ffffffffc0200384:	6c8010ef          	jal	ra,ffffffffc0201a4c <strchr>
ffffffffc0200388:	d96d                	beqz	a0,ffffffffc020037a <kmonitor+0x116>
ffffffffc020038a:	00044583          	lbu	a1,0(s0)
ffffffffc020038e:	d9a9                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200390:	bf55                	j	ffffffffc0200344 <kmonitor+0xe0>
ffffffffc0200392:	45c1                	li	a1,16
ffffffffc0200394:	855a                	mv	a0,s6
ffffffffc0200396:	d1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020039a:	b7e9                	j	ffffffffc0200364 <kmonitor+0x100>
ffffffffc020039c:	6582                	ld	a1,0(sp)
ffffffffc020039e:	00002517          	auipc	a0,0x2
ffffffffc02003a2:	91a50513          	addi	a0,a0,-1766 # ffffffffc0201cb8 <etext+0x244>
ffffffffc02003a6:	d0dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003aa:	b715                	j	ffffffffc02002ce <kmonitor+0x6a>

<<<<<<< HEAD
ffffffffc02003ac <__panic>:
ffffffffc02003ac:	00006317          	auipc	t1,0x6
ffffffffc02003b0:	08430313          	addi	t1,t1,132 # ffffffffc0206430 <is_panic>
ffffffffc02003b4:	00032e03          	lw	t3,0(t1)
ffffffffc02003b8:	715d                	addi	sp,sp,-80
ffffffffc02003ba:	ec06                	sd	ra,24(sp)
ffffffffc02003bc:	e822                	sd	s0,16(sp)
ffffffffc02003be:	f436                	sd	a3,40(sp)
ffffffffc02003c0:	f83a                	sd	a4,48(sp)
ffffffffc02003c2:	fc3e                	sd	a5,56(sp)
ffffffffc02003c4:	e0c2                	sd	a6,64(sp)
ffffffffc02003c6:	e4c6                	sd	a7,72(sp)
ffffffffc02003c8:	020e1a63          	bnez	t3,ffffffffc02003fc <__panic+0x50>
ffffffffc02003cc:	4785                	li	a5,1
ffffffffc02003ce:	00f32023          	sw	a5,0(t1)
ffffffffc02003d2:	8432                	mv	s0,a2
ffffffffc02003d4:	103c                	addi	a5,sp,40
ffffffffc02003d6:	862e                	mv	a2,a1
ffffffffc02003d8:	85aa                	mv	a1,a0
ffffffffc02003da:	00002517          	auipc	a0,0x2
ffffffffc02003de:	93e50513          	addi	a0,a0,-1730 # ffffffffc0201d18 <commands+0x48>
ffffffffc02003e2:	e43e                	sd	a5,8(sp)
ffffffffc02003e4:	ccfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003e8:	65a2                	ld	a1,8(sp)
ffffffffc02003ea:	8522                	mv	a0,s0
ffffffffc02003ec:	ca7ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc02003f0:	00001517          	auipc	a0,0x1
ffffffffc02003f4:	77050513          	addi	a0,a0,1904 # ffffffffc0201b60 <etext+0xec>
ffffffffc02003f8:	cbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003fc:	062000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0200400:	4501                	li	a0,0
ffffffffc0200402:	e63ff0ef          	jal	ra,ffffffffc0200264 <kmonitor>
ffffffffc0200406:	bfed                	j	ffffffffc0200400 <__panic+0x54>
=======
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
ffffffffc02002ca:	bea50513          	addi	a0,a0,-1046 # ffffffffc0201eb0 <etext+0x1e0>
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
ffffffffc02002ec:	bf050513          	addi	a0,a0,-1040 # ffffffffc0201ed8 <etext+0x208>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	c4ac0c13          	addi	s8,s8,-950 # ffffffffc0201f48 <commands>
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	bfa90913          	addi	s2,s2,-1030 # ffffffffc0201f00 <etext+0x230>
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	bfa48493          	addi	s1,s1,-1030 # ffffffffc0201f08 <etext+0x238>
ffffffffc0200316:	49bd                	li	s3,15
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	bf8b0b13          	addi	s6,s6,-1032 # ffffffffc0201f10 <etext+0x240>
ffffffffc0200320:	00002a17          	auipc	s4,0x2
ffffffffc0200324:	b10a0a13          	addi	s4,s4,-1264 # ffffffffc0201e30 <etext+0x160>
ffffffffc0200328:	4a8d                	li	s5,3
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	087010ef          	jal	ra,ffffffffc0201bb2 <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
ffffffffc0200338:	4c81                	li	s9,0
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	c06d0d13          	addi	s10,s10,-1018 # ffffffffc0201f48 <commands>
ffffffffc020034a:	8552                	mv	a0,s4
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
ffffffffc0200350:	42e010ef          	jal	ra,ffffffffc020177e <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
ffffffffc0200362:	0d61                	addi	s10,s10,24
ffffffffc0200364:	41a010ef          	jal	ra,ffffffffc020177e <strcmp>
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
ffffffffc02003a2:	3fa010ef          	jal	ra,ffffffffc020179c <strchr>
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
ffffffffc02003e0:	3bc010ef          	jal	ra,ffffffffc020179c <strchr>
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
ffffffffc02003fe:	b3650513          	addi	a0,a0,-1226 # ffffffffc0201f30 <etext+0x260>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158

ffffffffc0200408 <clock_init>:
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200414:	c0102573          	rdtime	a0
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
<<<<<<< HEAD
ffffffffc0200420:	5a2010ef          	jal	ra,ffffffffc02019c2 <sbi_set_timer>
=======
ffffffffc0200420:	061010ef          	jal	ra,ffffffffc0201c80 <sbi_set_timer>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b923          	sd	zero,18(a5) # ffffffffc0206438 <ticks>
ffffffffc020042e:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200432:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201d38 <commands+0x68>
=======
ffffffffc0200432:	b6250513          	addi	a0,a0,-1182 # ffffffffc0201f90 <commands+0x48>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200436:	0141                	addi	sp,sp,16
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
ffffffffc020043a:	c0102573          	rdtime	a0
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
<<<<<<< HEAD
ffffffffc0200446:	57c0106f          	j	ffffffffc02019c2 <sbi_set_timer>
=======
ffffffffc0200446:	03b0106f          	j	ffffffffc0201c80 <sbi_set_timer>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158

ffffffffc020044a <cons_init>:
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:
<<<<<<< HEAD
ffffffffc020044c:	0ff57513          	andi	a0,a0,255
ffffffffc0200450:	5580106f          	j	ffffffffc02019a8 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	5880106f          	j	ffffffffc02019dc <sbi_console_getchar>
=======
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	0170106f          	j	ffffffffc0201c66 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	0470106f          	j	ffffffffc0201c9a <sbi_console_getchar>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158

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
<<<<<<< HEAD
ffffffffc0200482:	8da50513          	addi	a0,a0,-1830 # ffffffffc0201d58 <commands+0x88>
=======
ffffffffc0200482:	b3250513          	addi	a0,a0,-1230 # ffffffffc0201fb0 <commands+0x68>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200486:	e406                	sd	ra,8(sp)
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200492:	8e250513          	addi	a0,a0,-1822 # ffffffffc0201d70 <commands+0xa0>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0201d88 <commands+0xb8>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	8f650513          	addi	a0,a0,-1802 # ffffffffc0201da0 <commands+0xd0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	90050513          	addi	a0,a0,-1792 # ffffffffc0201db8 <commands+0xe8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201dd0 <commands+0x100>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	91450513          	addi	a0,a0,-1772 # ffffffffc0201de8 <commands+0x118>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	91e50513          	addi	a0,a0,-1762 # ffffffffc0201e00 <commands+0x130>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	92850513          	addi	a0,a0,-1752 # ffffffffc0201e18 <commands+0x148>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	93250513          	addi	a0,a0,-1742 # ffffffffc0201e30 <commands+0x160>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	93c50513          	addi	a0,a0,-1732 # ffffffffc0201e48 <commands+0x178>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	94650513          	addi	a0,a0,-1722 # ffffffffc0201e60 <commands+0x190>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	95050513          	addi	a0,a0,-1712 # ffffffffc0201e78 <commands+0x1a8>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	95a50513          	addi	a0,a0,-1702 # ffffffffc0201e90 <commands+0x1c0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	96450513          	addi	a0,a0,-1692 # ffffffffc0201ea8 <commands+0x1d8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	96e50513          	addi	a0,a0,-1682 # ffffffffc0201ec0 <commands+0x1f0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	97850513          	addi	a0,a0,-1672 # ffffffffc0201ed8 <commands+0x208>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	98250513          	addi	a0,a0,-1662 # ffffffffc0201ef0 <commands+0x220>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	98c50513          	addi	a0,a0,-1652 # ffffffffc0201f08 <commands+0x238>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	99650513          	addi	a0,a0,-1642 # ffffffffc0201f20 <commands+0x250>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	9a050513          	addi	a0,a0,-1632 # ffffffffc0201f38 <commands+0x268>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0201f50 <commands+0x280>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	9b450513          	addi	a0,a0,-1612 # ffffffffc0201f68 <commands+0x298>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	9be50513          	addi	a0,a0,-1602 # ffffffffc0201f80 <commands+0x2b0>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	9c850513          	addi	a0,a0,-1592 # ffffffffc0201f98 <commands+0x2c8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	9d250513          	addi	a0,a0,-1582 # ffffffffc0201fb0 <commands+0x2e0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0201fc8 <commands+0x2f8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	9e650513          	addi	a0,a0,-1562 # ffffffffc0201fe0 <commands+0x310>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	9f050513          	addi	a0,a0,-1552 # ffffffffc0201ff8 <commands+0x328>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0202010 <commands+0x340>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	a0450513          	addi	a0,a0,-1532 # ffffffffc0202028 <commands+0x358>
=======
ffffffffc0200492:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0201fc8 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	b4450513          	addi	a0,a0,-1212 # ffffffffc0201fe0 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0201ff8 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	b5850513          	addi	a0,a0,-1192 # ffffffffc0202010 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	b6250513          	addi	a0,a0,-1182 # ffffffffc0202028 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0202040 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	b7650513          	addi	a0,a0,-1162 # ffffffffc0202058 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	b8050513          	addi	a0,a0,-1152 # ffffffffc0202070 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0202088 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	b9450513          	addi	a0,a0,-1132 # ffffffffc02020a0 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	b9e50513          	addi	a0,a0,-1122 # ffffffffc02020b8 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	ba850513          	addi	a0,a0,-1112 # ffffffffc02020d0 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	bb250513          	addi	a0,a0,-1102 # ffffffffc02020e8 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0202100 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	bc650513          	addi	a0,a0,-1082 # ffffffffc0202118 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	bd050513          	addi	a0,a0,-1072 # ffffffffc0202130 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	bda50513          	addi	a0,a0,-1062 # ffffffffc0202148 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	be450513          	addi	a0,a0,-1052 # ffffffffc0202160 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	bee50513          	addi	a0,a0,-1042 # ffffffffc0202178 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	bf850513          	addi	a0,a0,-1032 # ffffffffc0202190 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	c0250513          	addi	a0,a0,-1022 # ffffffffc02021a8 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	c0c50513          	addi	a0,a0,-1012 # ffffffffc02021c0 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	c1650513          	addi	a0,a0,-1002 # ffffffffc02021d8 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	c2050513          	addi	a0,a0,-992 # ffffffffc02021f0 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	c2a50513          	addi	a0,a0,-982 # ffffffffc0202208 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	c3450513          	addi	a0,a0,-972 # ffffffffc0202220 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	c3e50513          	addi	a0,a0,-962 # ffffffffc0202238 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	c4850513          	addi	a0,a0,-952 # ffffffffc0202250 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	c5250513          	addi	a0,a0,-942 # ffffffffc0202268 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	c5c50513          	addi	a0,a0,-932 # ffffffffc0202280 <commands+0x338>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
ffffffffc0200636:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020063a:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0202040 <commands+0x370>
=======
ffffffffc020063a:	c6250513          	addi	a0,a0,-926 # ffffffffc0202298 <commands+0x350>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc020063e:	0141                	addi	sp,sp,16
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
ffffffffc0200646:	85aa                	mv	a1,a0
ffffffffc0200648:	842a                	mv	s0,a0
ffffffffc020064a:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020064e:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0202058 <commands+0x388>
=======
ffffffffc020064e:	c6650513          	addi	a0,a0,-922 # ffffffffc02022b0 <commands+0x368>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200652:	e406                	sd	ra,8(sp)
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200666:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0202070 <commands+0x3a0>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	a1650513          	addi	a0,a0,-1514 # ffffffffc0202088 <commands+0x3b8>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	a1e50513          	addi	a0,a0,-1506 # ffffffffc02020a0 <commands+0x3d0>
=======
ffffffffc0200666:	c6650513          	addi	a0,a0,-922 # ffffffffc02022c8 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	c6e50513          	addi	a0,a0,-914 # ffffffffc02022e0 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	c7650513          	addi	a0,a0,-906 # ffffffffc02022f8 <commands+0x3b0>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020068e:	11843583          	ld	a1,280(s0)
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
ffffffffc0200696:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020069a:	a2250513          	addi	a0,a0,-1502 # ffffffffc02020b8 <commands+0x3e8>
=======
ffffffffc020069a:	c7a50513          	addi	a0,a0,-902 # ffffffffc0202310 <commands+0x3c8>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc020069e:	0141                	addi	sp,sp,16
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	08f76663          	bltu	a4,a5,ffffffffc0200738 <interrupt_handler+0x96>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
<<<<<<< HEAD
ffffffffc02006b4:	ae870713          	addi	a4,a4,-1304 # ffffffffc0202198 <commands+0x4c8>
=======
ffffffffc02006b4:	d4070713          	addi	a4,a4,-704 # ffffffffc02023f0 <commands+0x4a8>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
ffffffffc02006c2:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02006c6:	a6e50513          	addi	a0,a0,-1426 # ffffffffc0202130 <commands+0x460>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	a4450513          	addi	a0,a0,-1468 # ffffffffc0202110 <commands+0x440>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	9fa50513          	addi	a0,a0,-1542 # ffffffffc02020d0 <commands+0x400>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	a7050513          	addi	a0,a0,-1424 # ffffffffc0202150 <commands+0x480>
=======
ffffffffc02006c6:	cc650513          	addi	a0,a0,-826 # ffffffffc0202388 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0202368 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	c5250513          	addi	a0,a0,-942 # ffffffffc0202328 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	cc850513          	addi	a0,a0,-824 # ffffffffc02023a8 <commands+0x460>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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
<<<<<<< HEAD
ffffffffc0200728:	a5450513          	addi	a0,a0,-1452 # ffffffffc0202178 <commands+0x4a8>
ffffffffc020072c:	b259                	j	ffffffffc02000b2 <cprintf>
ffffffffc020072e:	00002517          	auipc	a0,0x2
ffffffffc0200732:	9c250513          	addi	a0,a0,-1598 # ffffffffc02020f0 <commands+0x420>
=======
ffffffffc0200728:	cac50513          	addi	a0,a0,-852 # ffffffffc02023d0 <commands+0x488>
ffffffffc020072c:	b259                	j	ffffffffc02000b2 <cprintf>
ffffffffc020072e:	00002517          	auipc	a0,0x2
ffffffffc0200732:	c1a50513          	addi	a0,a0,-998 # ffffffffc0202348 <commands+0x400>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>
ffffffffc0200738:	b729                	j	ffffffffc0200642 <print_trapframe>
ffffffffc020073a:	06400593          	li	a1,100
ffffffffc020073e:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200742:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0202168 <commands+0x498>
=======
ffffffffc0200742:	c8250513          	addi	a0,a0,-894 # ffffffffc02023c0 <commands+0x478>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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
<<<<<<< HEAD
ffffffffc0200760:	2980106f          	j	ffffffffc02019f8 <sbi_shutdown>
=======
ffffffffc0200760:	5560106f          	j	ffffffffc0201cb6 <sbi_shutdown>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158

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
<<<<<<< HEAD
ffffffffc0200784:	a4850513          	addi	a0,a0,-1464 # ffffffffc02021c8 <commands+0x4f8>
ffffffffc0200788:	92bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020078c:	10843583          	ld	a1,264(s0)
ffffffffc0200790:	00002517          	auipc	a0,0x2
ffffffffc0200794:	a6050513          	addi	a0,a0,-1440 # ffffffffc02021f0 <commands+0x520>
=======
ffffffffc0200784:	ca050513          	addi	a0,a0,-864 # ffffffffc0202420 <commands+0x4d8>
ffffffffc0200788:	92bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020078c:	10843583          	ld	a1,264(s0)
ffffffffc0200790:	00002517          	auipc	a0,0x2
ffffffffc0200794:	cb850513          	addi	a0,a0,-840 # ffffffffc0202448 <commands+0x500>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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
<<<<<<< HEAD
ffffffffc02007c2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc0202218 <commands+0x548>
ffffffffc02007c6:	8edff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02007ca:	10843583          	ld	a1,264(s0)
ffffffffc02007ce:	00002517          	auipc	a0,0x2
ffffffffc02007d2:	a2250513          	addi	a0,a0,-1502 # ffffffffc02021f0 <commands+0x520>
=======
ffffffffc02007c2:	cb250513          	addi	a0,a0,-846 # ffffffffc0202470 <commands+0x528>
ffffffffc02007c6:	8edff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02007ca:	10843583          	ld	a1,264(s0)
ffffffffc02007ce:	00002517          	auipc	a0,0x2
ffffffffc02007d2:	c7a50513          	addi	a0,a0,-902 # ffffffffc0202448 <commands+0x500>
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158
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

<<<<<<< HEAD
ffffffffc02008ae <best_fit_init>:
ffffffffc02008ae:	00005797          	auipc	a5,0x5
ffffffffc02008b2:	76a78793          	addi	a5,a5,1898 # ffffffffc0206018 <free_area>
ffffffffc02008b6:	e79c                	sd	a5,8(a5)
ffffffffc02008b8:	e39c                	sd	a5,0(a5)
ffffffffc02008ba:	0007a823          	sw	zero,16(a5)
ffffffffc02008be:	8082                	ret

ffffffffc02008c0 <best_fit_nr_free_pages>:
ffffffffc02008c0:	00005517          	auipc	a0,0x5
ffffffffc02008c4:	76856503          	lwu	a0,1896(a0) # ffffffffc0206028 <free_area+0x10>
ffffffffc02008c8:	8082                	ret

ffffffffc02008ca <best_fit_alloc_pages>:
ffffffffc02008ca:	c14d                	beqz	a0,ffffffffc020096c <best_fit_alloc_pages+0xa2>
ffffffffc02008cc:	00005617          	auipc	a2,0x5
ffffffffc02008d0:	74c60613          	addi	a2,a2,1868 # ffffffffc0206018 <free_area>
ffffffffc02008d4:	01062803          	lw	a6,16(a2)
ffffffffc02008d8:	86aa                	mv	a3,a0
ffffffffc02008da:	02081793          	slli	a5,a6,0x20
ffffffffc02008de:	9381                	srli	a5,a5,0x20
ffffffffc02008e0:	08a7e463          	bltu	a5,a0,ffffffffc0200968 <best_fit_alloc_pages+0x9e>
ffffffffc02008e4:	661c                	ld	a5,8(a2)
ffffffffc02008e6:	0018059b          	addiw	a1,a6,1
ffffffffc02008ea:	1582                	slli	a1,a1,0x20
ffffffffc02008ec:	9181                	srli	a1,a1,0x20
ffffffffc02008ee:	4501                	li	a0,0
ffffffffc02008f0:	06c78b63          	beq	a5,a2,ffffffffc0200966 <best_fit_alloc_pages+0x9c>
ffffffffc02008f4:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02008f8:	00d76763          	bltu	a4,a3,ffffffffc0200906 <best_fit_alloc_pages+0x3c>
ffffffffc02008fc:	00b77563          	bgeu	a4,a1,ffffffffc0200906 <best_fit_alloc_pages+0x3c>
ffffffffc0200900:	fe878513          	addi	a0,a5,-24
ffffffffc0200904:	85ba                	mv	a1,a4
ffffffffc0200906:	679c                	ld	a5,8(a5)
ffffffffc0200908:	fec796e3          	bne	a5,a2,ffffffffc02008f4 <best_fit_alloc_pages+0x2a>
ffffffffc020090c:	cd29                	beqz	a0,ffffffffc0200966 <best_fit_alloc_pages+0x9c>
ffffffffc020090e:	711c                	ld	a5,32(a0)
ffffffffc0200910:	6d18                	ld	a4,24(a0)
ffffffffc0200912:	490c                	lw	a1,16(a0)
ffffffffc0200914:	0006889b          	sext.w	a7,a3
ffffffffc0200918:	e71c                	sd	a5,8(a4)
ffffffffc020091a:	e398                	sd	a4,0(a5)
ffffffffc020091c:	02059793          	slli	a5,a1,0x20
ffffffffc0200920:	9381                	srli	a5,a5,0x20
ffffffffc0200922:	02f6f863          	bgeu	a3,a5,ffffffffc0200952 <best_fit_alloc_pages+0x88>
ffffffffc0200926:	00269793          	slli	a5,a3,0x2
ffffffffc020092a:	97b6                	add	a5,a5,a3
ffffffffc020092c:	078e                	slli	a5,a5,0x3
ffffffffc020092e:	97aa                	add	a5,a5,a0
ffffffffc0200930:	411585bb          	subw	a1,a1,a7
ffffffffc0200934:	cb8c                	sw	a1,16(a5)
ffffffffc0200936:	4689                	li	a3,2
ffffffffc0200938:	00878593          	addi	a1,a5,8
ffffffffc020093c:	40d5b02f          	amoor.d	zero,a3,(a1)
ffffffffc0200940:	6714                	ld	a3,8(a4)
ffffffffc0200942:	01878593          	addi	a1,a5,24
ffffffffc0200946:	01062803          	lw	a6,16(a2)
ffffffffc020094a:	e28c                	sd	a1,0(a3)
ffffffffc020094c:	e70c                	sd	a1,8(a4)
ffffffffc020094e:	f394                	sd	a3,32(a5)
ffffffffc0200950:	ef98                	sd	a4,24(a5)
ffffffffc0200952:	4118083b          	subw	a6,a6,a7
ffffffffc0200956:	01062823          	sw	a6,16(a2)
ffffffffc020095a:	57f5                	li	a5,-3
ffffffffc020095c:	00850713          	addi	a4,a0,8
ffffffffc0200960:	60f7302f          	amoand.d	zero,a5,(a4)
ffffffffc0200964:	8082                	ret
ffffffffc0200966:	8082                	ret
ffffffffc0200968:	4501                	li	a0,0
ffffffffc020096a:	8082                	ret
ffffffffc020096c:	1141                	addi	sp,sp,-16
ffffffffc020096e:	00002697          	auipc	a3,0x2
ffffffffc0200972:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0202238 <commands+0x568>
ffffffffc0200976:	00002617          	auipc	a2,0x2
ffffffffc020097a:	8ca60613          	addi	a2,a2,-1846 # ffffffffc0202240 <commands+0x570>
ffffffffc020097e:	06a00593          	li	a1,106
ffffffffc0200982:	00002517          	auipc	a0,0x2
ffffffffc0200986:	8d650513          	addi	a0,a0,-1834 # ffffffffc0202258 <commands+0x588>
ffffffffc020098a:	e406                	sd	ra,8(sp)
ffffffffc020098c:	a21ff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0200990 <best_fit_check>:
ffffffffc0200990:	715d                	addi	sp,sp,-80
ffffffffc0200992:	e0a2                	sd	s0,64(sp)
ffffffffc0200994:	00005417          	auipc	s0,0x5
ffffffffc0200998:	68440413          	addi	s0,s0,1668 # ffffffffc0206018 <free_area>
ffffffffc020099c:	641c                	ld	a5,8(s0)
ffffffffc020099e:	e486                	sd	ra,72(sp)
ffffffffc02009a0:	fc26                	sd	s1,56(sp)
ffffffffc02009a2:	f84a                	sd	s2,48(sp)
ffffffffc02009a4:	f44e                	sd	s3,40(sp)
ffffffffc02009a6:	f052                	sd	s4,32(sp)
ffffffffc02009a8:	ec56                	sd	s5,24(sp)
ffffffffc02009aa:	e85a                	sd	s6,16(sp)
ffffffffc02009ac:	e45e                	sd	s7,8(sp)
ffffffffc02009ae:	e062                	sd	s8,0(sp)
ffffffffc02009b0:	26878b63          	beq	a5,s0,ffffffffc0200c26 <best_fit_check+0x296>
ffffffffc02009b4:	4481                	li	s1,0
ffffffffc02009b6:	4901                	li	s2,0
ffffffffc02009b8:	ff07b703          	ld	a4,-16(a5)
ffffffffc02009bc:	8b09                	andi	a4,a4,2
ffffffffc02009be:	26070863          	beqz	a4,ffffffffc0200c2e <best_fit_check+0x29e>
ffffffffc02009c2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02009c6:	679c                	ld	a5,8(a5)
ffffffffc02009c8:	2905                	addiw	s2,s2,1
ffffffffc02009ca:	9cb9                	addw	s1,s1,a4
ffffffffc02009cc:	fe8796e3          	bne	a5,s0,ffffffffc02009b8 <best_fit_check+0x28>
ffffffffc02009d0:	89a6                	mv	s3,s1
ffffffffc02009d2:	167000ef          	jal	ra,ffffffffc0201338 <nr_free_pages>
ffffffffc02009d6:	33351c63          	bne	a0,s3,ffffffffc0200d0e <best_fit_check+0x37e>
ffffffffc02009da:	4505                	li	a0,1
ffffffffc02009dc:	0df000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc02009e0:	8a2a                	mv	s4,a0
ffffffffc02009e2:	36050663          	beqz	a0,ffffffffc0200d4e <best_fit_check+0x3be>
ffffffffc02009e6:	4505                	li	a0,1
ffffffffc02009e8:	0d3000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc02009ec:	89aa                	mv	s3,a0
ffffffffc02009ee:	34050063          	beqz	a0,ffffffffc0200d2e <best_fit_check+0x39e>
ffffffffc02009f2:	4505                	li	a0,1
ffffffffc02009f4:	0c7000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc02009f8:	8aaa                	mv	s5,a0
ffffffffc02009fa:	2c050a63          	beqz	a0,ffffffffc0200cce <best_fit_check+0x33e>
ffffffffc02009fe:	253a0863          	beq	s4,s3,ffffffffc0200c4e <best_fit_check+0x2be>
ffffffffc0200a02:	24aa0663          	beq	s4,a0,ffffffffc0200c4e <best_fit_check+0x2be>
ffffffffc0200a06:	24a98463          	beq	s3,a0,ffffffffc0200c4e <best_fit_check+0x2be>
ffffffffc0200a0a:	000a2783          	lw	a5,0(s4)
ffffffffc0200a0e:	26079063          	bnez	a5,ffffffffc0200c6e <best_fit_check+0x2de>
ffffffffc0200a12:	0009a783          	lw	a5,0(s3)
ffffffffc0200a16:	24079c63          	bnez	a5,ffffffffc0200c6e <best_fit_check+0x2de>
ffffffffc0200a1a:	411c                	lw	a5,0(a0)
ffffffffc0200a1c:	24079963          	bnez	a5,ffffffffc0200c6e <best_fit_check+0x2de>
ffffffffc0200a20:	00006797          	auipc	a5,0x6
ffffffffc0200a24:	a307b783          	ld	a5,-1488(a5) # ffffffffc0206450 <pages>
ffffffffc0200a28:	40fa0733          	sub	a4,s4,a5
ffffffffc0200a2c:	870d                	srai	a4,a4,0x3
ffffffffc0200a2e:	00002597          	auipc	a1,0x2
ffffffffc0200a32:	efa5b583          	ld	a1,-262(a1) # ffffffffc0202928 <error_string+0x38>
ffffffffc0200a36:	02b70733          	mul	a4,a4,a1
ffffffffc0200a3a:	00002617          	auipc	a2,0x2
ffffffffc0200a3e:	ef663603          	ld	a2,-266(a2) # ffffffffc0202930 <nbase>
ffffffffc0200a42:	00006697          	auipc	a3,0x6
ffffffffc0200a46:	a066b683          	ld	a3,-1530(a3) # ffffffffc0206448 <npage>
ffffffffc0200a4a:	06b2                	slli	a3,a3,0xc
ffffffffc0200a4c:	9732                	add	a4,a4,a2
ffffffffc0200a4e:	0732                	slli	a4,a4,0xc
ffffffffc0200a50:	22d77f63          	bgeu	a4,a3,ffffffffc0200c8e <best_fit_check+0x2fe>
ffffffffc0200a54:	40f98733          	sub	a4,s3,a5
ffffffffc0200a58:	870d                	srai	a4,a4,0x3
ffffffffc0200a5a:	02b70733          	mul	a4,a4,a1
ffffffffc0200a5e:	9732                	add	a4,a4,a2
ffffffffc0200a60:	0732                	slli	a4,a4,0xc
ffffffffc0200a62:	3ed77663          	bgeu	a4,a3,ffffffffc0200e4e <best_fit_check+0x4be>
ffffffffc0200a66:	40f507b3          	sub	a5,a0,a5
ffffffffc0200a6a:	878d                	srai	a5,a5,0x3
ffffffffc0200a6c:	02b787b3          	mul	a5,a5,a1
ffffffffc0200a70:	97b2                	add	a5,a5,a2
ffffffffc0200a72:	07b2                	slli	a5,a5,0xc
ffffffffc0200a74:	3ad7fd63          	bgeu	a5,a3,ffffffffc0200e2e <best_fit_check+0x49e>
ffffffffc0200a78:	4505                	li	a0,1
ffffffffc0200a7a:	00043c03          	ld	s8,0(s0)
ffffffffc0200a7e:	00843b83          	ld	s7,8(s0)
ffffffffc0200a82:	01042b03          	lw	s6,16(s0)
ffffffffc0200a86:	e400                	sd	s0,8(s0)
ffffffffc0200a88:	e000                	sd	s0,0(s0)
ffffffffc0200a8a:	00005797          	auipc	a5,0x5
ffffffffc0200a8e:	5807af23          	sw	zero,1438(a5) # ffffffffc0206028 <free_area+0x10>
ffffffffc0200a92:	029000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200a96:	36051c63          	bnez	a0,ffffffffc0200e0e <best_fit_check+0x47e>
ffffffffc0200a9a:	4585                	li	a1,1
ffffffffc0200a9c:	8552                	mv	a0,s4
ffffffffc0200a9e:	05b000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200aa2:	4585                	li	a1,1
ffffffffc0200aa4:	854e                	mv	a0,s3
ffffffffc0200aa6:	053000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200aaa:	4585                	li	a1,1
ffffffffc0200aac:	8556                	mv	a0,s5
ffffffffc0200aae:	04b000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200ab2:	4818                	lw	a4,16(s0)
ffffffffc0200ab4:	478d                	li	a5,3
ffffffffc0200ab6:	32f71c63          	bne	a4,a5,ffffffffc0200dee <best_fit_check+0x45e>
ffffffffc0200aba:	4505                	li	a0,1
ffffffffc0200abc:	7fe000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200ac0:	89aa                	mv	s3,a0
ffffffffc0200ac2:	30050663          	beqz	a0,ffffffffc0200dce <best_fit_check+0x43e>
ffffffffc0200ac6:	4505                	li	a0,1
ffffffffc0200ac8:	7f2000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200acc:	8aaa                	mv	s5,a0
ffffffffc0200ace:	2e050063          	beqz	a0,ffffffffc0200dae <best_fit_check+0x41e>
ffffffffc0200ad2:	4505                	li	a0,1
ffffffffc0200ad4:	7e6000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200ad8:	8a2a                	mv	s4,a0
ffffffffc0200ada:	2a050a63          	beqz	a0,ffffffffc0200d8e <best_fit_check+0x3fe>
ffffffffc0200ade:	4505                	li	a0,1
ffffffffc0200ae0:	7da000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200ae4:	28051563          	bnez	a0,ffffffffc0200d6e <best_fit_check+0x3de>
ffffffffc0200ae8:	4585                	li	a1,1
ffffffffc0200aea:	854e                	mv	a0,s3
ffffffffc0200aec:	00d000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200af0:	641c                	ld	a5,8(s0)
ffffffffc0200af2:	1a878e63          	beq	a5,s0,ffffffffc0200cae <best_fit_check+0x31e>
ffffffffc0200af6:	4505                	li	a0,1
ffffffffc0200af8:	7c2000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200afc:	52a99963          	bne	s3,a0,ffffffffc020102e <best_fit_check+0x69e>
ffffffffc0200b00:	4505                	li	a0,1
ffffffffc0200b02:	7b8000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200b06:	50051463          	bnez	a0,ffffffffc020100e <best_fit_check+0x67e>
ffffffffc0200b0a:	481c                	lw	a5,16(s0)
ffffffffc0200b0c:	4e079163          	bnez	a5,ffffffffc0200fee <best_fit_check+0x65e>
ffffffffc0200b10:	854e                	mv	a0,s3
ffffffffc0200b12:	4585                	li	a1,1
ffffffffc0200b14:	01843023          	sd	s8,0(s0)
ffffffffc0200b18:	01743423          	sd	s7,8(s0)
ffffffffc0200b1c:	01642823          	sw	s6,16(s0)
ffffffffc0200b20:	7d8000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200b24:	4585                	li	a1,1
ffffffffc0200b26:	8556                	mv	a0,s5
ffffffffc0200b28:	7d0000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200b2c:	4585                	li	a1,1
ffffffffc0200b2e:	8552                	mv	a0,s4
ffffffffc0200b30:	7c8000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200b34:	4515                	li	a0,5
ffffffffc0200b36:	784000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200b3a:	89aa                	mv	s3,a0
ffffffffc0200b3c:	48050963          	beqz	a0,ffffffffc0200fce <best_fit_check+0x63e>
ffffffffc0200b40:	651c                	ld	a5,8(a0)
ffffffffc0200b42:	8385                	srli	a5,a5,0x1
ffffffffc0200b44:	8b85                	andi	a5,a5,1
ffffffffc0200b46:	46079463          	bnez	a5,ffffffffc0200fae <best_fit_check+0x61e>
ffffffffc0200b4a:	4505                	li	a0,1
ffffffffc0200b4c:	00043a83          	ld	s5,0(s0)
ffffffffc0200b50:	00843a03          	ld	s4,8(s0)
ffffffffc0200b54:	e000                	sd	s0,0(s0)
ffffffffc0200b56:	e400                	sd	s0,8(s0)
ffffffffc0200b58:	762000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200b5c:	42051963          	bnez	a0,ffffffffc0200f8e <best_fit_check+0x5fe>
ffffffffc0200b60:	4589                	li	a1,2
ffffffffc0200b62:	02898513          	addi	a0,s3,40
ffffffffc0200b66:	01042b03          	lw	s6,16(s0)
ffffffffc0200b6a:	0a098c13          	addi	s8,s3,160
ffffffffc0200b6e:	00005797          	auipc	a5,0x5
ffffffffc0200b72:	4a07ad23          	sw	zero,1210(a5) # ffffffffc0206028 <free_area+0x10>
ffffffffc0200b76:	782000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200b7a:	8562                	mv	a0,s8
ffffffffc0200b7c:	4585                	li	a1,1
ffffffffc0200b7e:	77a000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200b82:	4511                	li	a0,4
ffffffffc0200b84:	736000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200b88:	3e051363          	bnez	a0,ffffffffc0200f6e <best_fit_check+0x5de>
ffffffffc0200b8c:	0309b783          	ld	a5,48(s3)
ffffffffc0200b90:	8385                	srli	a5,a5,0x1
ffffffffc0200b92:	8b85                	andi	a5,a5,1
ffffffffc0200b94:	3a078d63          	beqz	a5,ffffffffc0200f4e <best_fit_check+0x5be>
ffffffffc0200b98:	0389a703          	lw	a4,56(s3)
ffffffffc0200b9c:	4789                	li	a5,2
ffffffffc0200b9e:	3af71863          	bne	a4,a5,ffffffffc0200f4e <best_fit_check+0x5be>
ffffffffc0200ba2:	4505                	li	a0,1
ffffffffc0200ba4:	716000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200ba8:	8baa                	mv	s7,a0
ffffffffc0200baa:	38050263          	beqz	a0,ffffffffc0200f2e <best_fit_check+0x59e>
ffffffffc0200bae:	4509                	li	a0,2
ffffffffc0200bb0:	70a000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200bb4:	34050d63          	beqz	a0,ffffffffc0200f0e <best_fit_check+0x57e>
ffffffffc0200bb8:	337c1b63          	bne	s8,s7,ffffffffc0200eee <best_fit_check+0x55e>
ffffffffc0200bbc:	854e                	mv	a0,s3
ffffffffc0200bbe:	4595                	li	a1,5
ffffffffc0200bc0:	738000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200bc4:	4515                	li	a0,5
ffffffffc0200bc6:	6f4000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200bca:	89aa                	mv	s3,a0
ffffffffc0200bcc:	30050163          	beqz	a0,ffffffffc0200ece <best_fit_check+0x53e>
ffffffffc0200bd0:	4505                	li	a0,1
ffffffffc0200bd2:	6e8000ef          	jal	ra,ffffffffc02012ba <alloc_pages>
ffffffffc0200bd6:	2c051c63          	bnez	a0,ffffffffc0200eae <best_fit_check+0x51e>
ffffffffc0200bda:	481c                	lw	a5,16(s0)
ffffffffc0200bdc:	2a079963          	bnez	a5,ffffffffc0200e8e <best_fit_check+0x4fe>
ffffffffc0200be0:	4595                	li	a1,5
ffffffffc0200be2:	854e                	mv	a0,s3
ffffffffc0200be4:	01642823          	sw	s6,16(s0)
ffffffffc0200be8:	01543023          	sd	s5,0(s0)
ffffffffc0200bec:	01443423          	sd	s4,8(s0)
ffffffffc0200bf0:	708000ef          	jal	ra,ffffffffc02012f8 <free_pages>
ffffffffc0200bf4:	641c                	ld	a5,8(s0)
ffffffffc0200bf6:	00878963          	beq	a5,s0,ffffffffc0200c08 <best_fit_check+0x278>
ffffffffc0200bfa:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200bfe:	679c                	ld	a5,8(a5)
ffffffffc0200c00:	397d                	addiw	s2,s2,-1
ffffffffc0200c02:	9c99                	subw	s1,s1,a4
ffffffffc0200c04:	fe879be3          	bne	a5,s0,ffffffffc0200bfa <best_fit_check+0x26a>
ffffffffc0200c08:	26091363          	bnez	s2,ffffffffc0200e6e <best_fit_check+0x4de>
ffffffffc0200c0c:	e0ed                	bnez	s1,ffffffffc0200cee <best_fit_check+0x35e>
ffffffffc0200c0e:	60a6                	ld	ra,72(sp)
ffffffffc0200c10:	6406                	ld	s0,64(sp)
ffffffffc0200c12:	74e2                	ld	s1,56(sp)
ffffffffc0200c14:	7942                	ld	s2,48(sp)
ffffffffc0200c16:	79a2                	ld	s3,40(sp)
ffffffffc0200c18:	7a02                	ld	s4,32(sp)
ffffffffc0200c1a:	6ae2                	ld	s5,24(sp)
ffffffffc0200c1c:	6b42                	ld	s6,16(sp)
ffffffffc0200c1e:	6ba2                	ld	s7,8(sp)
ffffffffc0200c20:	6c02                	ld	s8,0(sp)
ffffffffc0200c22:	6161                	addi	sp,sp,80
ffffffffc0200c24:	8082                	ret
ffffffffc0200c26:	4981                	li	s3,0
ffffffffc0200c28:	4481                	li	s1,0
ffffffffc0200c2a:	4901                	li	s2,0
ffffffffc0200c2c:	b35d                	j	ffffffffc02009d2 <best_fit_check+0x42>
ffffffffc0200c2e:	00001697          	auipc	a3,0x1
ffffffffc0200c32:	64268693          	addi	a3,a3,1602 # ffffffffc0202270 <commands+0x5a0>
ffffffffc0200c36:	00001617          	auipc	a2,0x1
ffffffffc0200c3a:	60a60613          	addi	a2,a2,1546 # ffffffffc0202240 <commands+0x570>
ffffffffc0200c3e:	10900593          	li	a1,265
ffffffffc0200c42:	00001517          	auipc	a0,0x1
ffffffffc0200c46:	61650513          	addi	a0,a0,1558 # ffffffffc0202258 <commands+0x588>
ffffffffc0200c4a:	f62ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200c4e:	00001697          	auipc	a3,0x1
ffffffffc0200c52:	6b268693          	addi	a3,a3,1714 # ffffffffc0202300 <commands+0x630>
ffffffffc0200c56:	00001617          	auipc	a2,0x1
ffffffffc0200c5a:	5ea60613          	addi	a2,a2,1514 # ffffffffc0202240 <commands+0x570>
ffffffffc0200c5e:	0d500593          	li	a1,213
ffffffffc0200c62:	00001517          	auipc	a0,0x1
ffffffffc0200c66:	5f650513          	addi	a0,a0,1526 # ffffffffc0202258 <commands+0x588>
ffffffffc0200c6a:	f42ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200c6e:	00001697          	auipc	a3,0x1
ffffffffc0200c72:	6ba68693          	addi	a3,a3,1722 # ffffffffc0202328 <commands+0x658>
ffffffffc0200c76:	00001617          	auipc	a2,0x1
ffffffffc0200c7a:	5ca60613          	addi	a2,a2,1482 # ffffffffc0202240 <commands+0x570>
ffffffffc0200c7e:	0d600593          	li	a1,214
ffffffffc0200c82:	00001517          	auipc	a0,0x1
ffffffffc0200c86:	5d650513          	addi	a0,a0,1494 # ffffffffc0202258 <commands+0x588>
ffffffffc0200c8a:	f22ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200c8e:	00001697          	auipc	a3,0x1
ffffffffc0200c92:	6da68693          	addi	a3,a3,1754 # ffffffffc0202368 <commands+0x698>
ffffffffc0200c96:	00001617          	auipc	a2,0x1
ffffffffc0200c9a:	5aa60613          	addi	a2,a2,1450 # ffffffffc0202240 <commands+0x570>
ffffffffc0200c9e:	0d800593          	li	a1,216
ffffffffc0200ca2:	00001517          	auipc	a0,0x1
ffffffffc0200ca6:	5b650513          	addi	a0,a0,1462 # ffffffffc0202258 <commands+0x588>
ffffffffc0200caa:	f02ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200cae:	00001697          	auipc	a3,0x1
ffffffffc0200cb2:	74268693          	addi	a3,a3,1858 # ffffffffc02023f0 <commands+0x720>
ffffffffc0200cb6:	00001617          	auipc	a2,0x1
ffffffffc0200cba:	58a60613          	addi	a2,a2,1418 # ffffffffc0202240 <commands+0x570>
ffffffffc0200cbe:	0f100593          	li	a1,241
ffffffffc0200cc2:	00001517          	auipc	a0,0x1
ffffffffc0200cc6:	59650513          	addi	a0,a0,1430 # ffffffffc0202258 <commands+0x588>
ffffffffc0200cca:	ee2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200cce:	00001697          	auipc	a3,0x1
ffffffffc0200cd2:	61268693          	addi	a3,a3,1554 # ffffffffc02022e0 <commands+0x610>
ffffffffc0200cd6:	00001617          	auipc	a2,0x1
ffffffffc0200cda:	56a60613          	addi	a2,a2,1386 # ffffffffc0202240 <commands+0x570>
ffffffffc0200cde:	0d300593          	li	a1,211
ffffffffc0200ce2:	00001517          	auipc	a0,0x1
ffffffffc0200ce6:	57650513          	addi	a0,a0,1398 # ffffffffc0202258 <commands+0x588>
ffffffffc0200cea:	ec2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200cee:	00002697          	auipc	a3,0x2
ffffffffc0200cf2:	83268693          	addi	a3,a3,-1998 # ffffffffc0202520 <commands+0x850>
ffffffffc0200cf6:	00001617          	auipc	a2,0x1
ffffffffc0200cfa:	54a60613          	addi	a2,a2,1354 # ffffffffc0202240 <commands+0x570>
ffffffffc0200cfe:	14b00593          	li	a1,331
ffffffffc0200d02:	00001517          	auipc	a0,0x1
ffffffffc0200d06:	55650513          	addi	a0,a0,1366 # ffffffffc0202258 <commands+0x588>
ffffffffc0200d0a:	ea2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200d0e:	00001697          	auipc	a3,0x1
ffffffffc0200d12:	57268693          	addi	a3,a3,1394 # ffffffffc0202280 <commands+0x5b0>
ffffffffc0200d16:	00001617          	auipc	a2,0x1
ffffffffc0200d1a:	52a60613          	addi	a2,a2,1322 # ffffffffc0202240 <commands+0x570>
ffffffffc0200d1e:	10c00593          	li	a1,268
ffffffffc0200d22:	00001517          	auipc	a0,0x1
ffffffffc0200d26:	53650513          	addi	a0,a0,1334 # ffffffffc0202258 <commands+0x588>
ffffffffc0200d2a:	e82ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200d2e:	00001697          	auipc	a3,0x1
ffffffffc0200d32:	59268693          	addi	a3,a3,1426 # ffffffffc02022c0 <commands+0x5f0>
ffffffffc0200d36:	00001617          	auipc	a2,0x1
ffffffffc0200d3a:	50a60613          	addi	a2,a2,1290 # ffffffffc0202240 <commands+0x570>
ffffffffc0200d3e:	0d200593          	li	a1,210
ffffffffc0200d42:	00001517          	auipc	a0,0x1
ffffffffc0200d46:	51650513          	addi	a0,a0,1302 # ffffffffc0202258 <commands+0x588>
ffffffffc0200d4a:	e62ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200d4e:	00001697          	auipc	a3,0x1
ffffffffc0200d52:	55268693          	addi	a3,a3,1362 # ffffffffc02022a0 <commands+0x5d0>
ffffffffc0200d56:	00001617          	auipc	a2,0x1
ffffffffc0200d5a:	4ea60613          	addi	a2,a2,1258 # ffffffffc0202240 <commands+0x570>
ffffffffc0200d5e:	0d100593          	li	a1,209
ffffffffc0200d62:	00001517          	auipc	a0,0x1
ffffffffc0200d66:	4f650513          	addi	a0,a0,1270 # ffffffffc0202258 <commands+0x588>
ffffffffc0200d6a:	e42ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200d6e:	00001697          	auipc	a3,0x1
ffffffffc0200d72:	65a68693          	addi	a3,a3,1626 # ffffffffc02023c8 <commands+0x6f8>
ffffffffc0200d76:	00001617          	auipc	a2,0x1
ffffffffc0200d7a:	4ca60613          	addi	a2,a2,1226 # ffffffffc0202240 <commands+0x570>
ffffffffc0200d7e:	0ee00593          	li	a1,238
ffffffffc0200d82:	00001517          	auipc	a0,0x1
ffffffffc0200d86:	4d650513          	addi	a0,a0,1238 # ffffffffc0202258 <commands+0x588>
ffffffffc0200d8a:	e22ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200d8e:	00001697          	auipc	a3,0x1
ffffffffc0200d92:	55268693          	addi	a3,a3,1362 # ffffffffc02022e0 <commands+0x610>
ffffffffc0200d96:	00001617          	auipc	a2,0x1
ffffffffc0200d9a:	4aa60613          	addi	a2,a2,1194 # ffffffffc0202240 <commands+0x570>
ffffffffc0200d9e:	0ec00593          	li	a1,236
ffffffffc0200da2:	00001517          	auipc	a0,0x1
ffffffffc0200da6:	4b650513          	addi	a0,a0,1206 # ffffffffc0202258 <commands+0x588>
ffffffffc0200daa:	e02ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200dae:	00001697          	auipc	a3,0x1
ffffffffc0200db2:	51268693          	addi	a3,a3,1298 # ffffffffc02022c0 <commands+0x5f0>
ffffffffc0200db6:	00001617          	auipc	a2,0x1
ffffffffc0200dba:	48a60613          	addi	a2,a2,1162 # ffffffffc0202240 <commands+0x570>
ffffffffc0200dbe:	0eb00593          	li	a1,235
ffffffffc0200dc2:	00001517          	auipc	a0,0x1
ffffffffc0200dc6:	49650513          	addi	a0,a0,1174 # ffffffffc0202258 <commands+0x588>
ffffffffc0200dca:	de2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200dce:	00001697          	auipc	a3,0x1
ffffffffc0200dd2:	4d268693          	addi	a3,a3,1234 # ffffffffc02022a0 <commands+0x5d0>
ffffffffc0200dd6:	00001617          	auipc	a2,0x1
ffffffffc0200dda:	46a60613          	addi	a2,a2,1130 # ffffffffc0202240 <commands+0x570>
ffffffffc0200dde:	0ea00593          	li	a1,234
ffffffffc0200de2:	00001517          	auipc	a0,0x1
ffffffffc0200de6:	47650513          	addi	a0,a0,1142 # ffffffffc0202258 <commands+0x588>
ffffffffc0200dea:	dc2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200dee:	00001697          	auipc	a3,0x1
ffffffffc0200df2:	5f268693          	addi	a3,a3,1522 # ffffffffc02023e0 <commands+0x710>
ffffffffc0200df6:	00001617          	auipc	a2,0x1
ffffffffc0200dfa:	44a60613          	addi	a2,a2,1098 # ffffffffc0202240 <commands+0x570>
ffffffffc0200dfe:	0e800593          	li	a1,232
ffffffffc0200e02:	00001517          	auipc	a0,0x1
ffffffffc0200e06:	45650513          	addi	a0,a0,1110 # ffffffffc0202258 <commands+0x588>
ffffffffc0200e0a:	da2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200e0e:	00001697          	auipc	a3,0x1
ffffffffc0200e12:	5ba68693          	addi	a3,a3,1466 # ffffffffc02023c8 <commands+0x6f8>
ffffffffc0200e16:	00001617          	auipc	a2,0x1
ffffffffc0200e1a:	42a60613          	addi	a2,a2,1066 # ffffffffc0202240 <commands+0x570>
ffffffffc0200e1e:	0e300593          	li	a1,227
ffffffffc0200e22:	00001517          	auipc	a0,0x1
ffffffffc0200e26:	43650513          	addi	a0,a0,1078 # ffffffffc0202258 <commands+0x588>
ffffffffc0200e2a:	d82ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200e2e:	00001697          	auipc	a3,0x1
ffffffffc0200e32:	57a68693          	addi	a3,a3,1402 # ffffffffc02023a8 <commands+0x6d8>
ffffffffc0200e36:	00001617          	auipc	a2,0x1
ffffffffc0200e3a:	40a60613          	addi	a2,a2,1034 # ffffffffc0202240 <commands+0x570>
ffffffffc0200e3e:	0da00593          	li	a1,218
ffffffffc0200e42:	00001517          	auipc	a0,0x1
ffffffffc0200e46:	41650513          	addi	a0,a0,1046 # ffffffffc0202258 <commands+0x588>
ffffffffc0200e4a:	d62ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200e4e:	00001697          	auipc	a3,0x1
ffffffffc0200e52:	53a68693          	addi	a3,a3,1338 # ffffffffc0202388 <commands+0x6b8>
ffffffffc0200e56:	00001617          	auipc	a2,0x1
ffffffffc0200e5a:	3ea60613          	addi	a2,a2,1002 # ffffffffc0202240 <commands+0x570>
ffffffffc0200e5e:	0d900593          	li	a1,217
ffffffffc0200e62:	00001517          	auipc	a0,0x1
ffffffffc0200e66:	3f650513          	addi	a0,a0,1014 # ffffffffc0202258 <commands+0x588>
ffffffffc0200e6a:	d42ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200e6e:	00001697          	auipc	a3,0x1
ffffffffc0200e72:	6a268693          	addi	a3,a3,1698 # ffffffffc0202510 <commands+0x840>
ffffffffc0200e76:	00001617          	auipc	a2,0x1
ffffffffc0200e7a:	3ca60613          	addi	a2,a2,970 # ffffffffc0202240 <commands+0x570>
ffffffffc0200e7e:	14a00593          	li	a1,330
ffffffffc0200e82:	00001517          	auipc	a0,0x1
ffffffffc0200e86:	3d650513          	addi	a0,a0,982 # ffffffffc0202258 <commands+0x588>
ffffffffc0200e8a:	d22ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200e8e:	00001697          	auipc	a3,0x1
ffffffffc0200e92:	59a68693          	addi	a3,a3,1434 # ffffffffc0202428 <commands+0x758>
ffffffffc0200e96:	00001617          	auipc	a2,0x1
ffffffffc0200e9a:	3aa60613          	addi	a2,a2,938 # ffffffffc0202240 <commands+0x570>
ffffffffc0200e9e:	13f00593          	li	a1,319
ffffffffc0200ea2:	00001517          	auipc	a0,0x1
ffffffffc0200ea6:	3b650513          	addi	a0,a0,950 # ffffffffc0202258 <commands+0x588>
ffffffffc0200eaa:	d02ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200eae:	00001697          	auipc	a3,0x1
ffffffffc0200eb2:	51a68693          	addi	a3,a3,1306 # ffffffffc02023c8 <commands+0x6f8>
ffffffffc0200eb6:	00001617          	auipc	a2,0x1
ffffffffc0200eba:	38a60613          	addi	a2,a2,906 # ffffffffc0202240 <commands+0x570>
ffffffffc0200ebe:	13900593          	li	a1,313
ffffffffc0200ec2:	00001517          	auipc	a0,0x1
ffffffffc0200ec6:	39650513          	addi	a0,a0,918 # ffffffffc0202258 <commands+0x588>
ffffffffc0200eca:	ce2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200ece:	00001697          	auipc	a3,0x1
ffffffffc0200ed2:	62268693          	addi	a3,a3,1570 # ffffffffc02024f0 <commands+0x820>
ffffffffc0200ed6:	00001617          	auipc	a2,0x1
ffffffffc0200eda:	36a60613          	addi	a2,a2,874 # ffffffffc0202240 <commands+0x570>
ffffffffc0200ede:	13800593          	li	a1,312
ffffffffc0200ee2:	00001517          	auipc	a0,0x1
ffffffffc0200ee6:	37650513          	addi	a0,a0,886 # ffffffffc0202258 <commands+0x588>
ffffffffc0200eea:	cc2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200eee:	00001697          	auipc	a3,0x1
ffffffffc0200ef2:	5f268693          	addi	a3,a3,1522 # ffffffffc02024e0 <commands+0x810>
ffffffffc0200ef6:	00001617          	auipc	a2,0x1
ffffffffc0200efa:	34a60613          	addi	a2,a2,842 # ffffffffc0202240 <commands+0x570>
ffffffffc0200efe:	13000593          	li	a1,304
ffffffffc0200f02:	00001517          	auipc	a0,0x1
ffffffffc0200f06:	35650513          	addi	a0,a0,854 # ffffffffc0202258 <commands+0x588>
ffffffffc0200f0a:	ca2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200f0e:	00001697          	auipc	a3,0x1
ffffffffc0200f12:	5ba68693          	addi	a3,a3,1466 # ffffffffc02024c8 <commands+0x7f8>
ffffffffc0200f16:	00001617          	auipc	a2,0x1
ffffffffc0200f1a:	32a60613          	addi	a2,a2,810 # ffffffffc0202240 <commands+0x570>
ffffffffc0200f1e:	12f00593          	li	a1,303
ffffffffc0200f22:	00001517          	auipc	a0,0x1
ffffffffc0200f26:	33650513          	addi	a0,a0,822 # ffffffffc0202258 <commands+0x588>
ffffffffc0200f2a:	c82ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200f2e:	00001697          	auipc	a3,0x1
ffffffffc0200f32:	57a68693          	addi	a3,a3,1402 # ffffffffc02024a8 <commands+0x7d8>
ffffffffc0200f36:	00001617          	auipc	a2,0x1
ffffffffc0200f3a:	30a60613          	addi	a2,a2,778 # ffffffffc0202240 <commands+0x570>
ffffffffc0200f3e:	12e00593          	li	a1,302
ffffffffc0200f42:	00001517          	auipc	a0,0x1
ffffffffc0200f46:	31650513          	addi	a0,a0,790 # ffffffffc0202258 <commands+0x588>
ffffffffc0200f4a:	c62ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200f4e:	00001697          	auipc	a3,0x1
ffffffffc0200f52:	52a68693          	addi	a3,a3,1322 # ffffffffc0202478 <commands+0x7a8>
ffffffffc0200f56:	00001617          	auipc	a2,0x1
ffffffffc0200f5a:	2ea60613          	addi	a2,a2,746 # ffffffffc0202240 <commands+0x570>
ffffffffc0200f5e:	12c00593          	li	a1,300
ffffffffc0200f62:	00001517          	auipc	a0,0x1
ffffffffc0200f66:	2f650513          	addi	a0,a0,758 # ffffffffc0202258 <commands+0x588>
ffffffffc0200f6a:	c42ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200f6e:	00001697          	auipc	a3,0x1
ffffffffc0200f72:	4f268693          	addi	a3,a3,1266 # ffffffffc0202460 <commands+0x790>
ffffffffc0200f76:	00001617          	auipc	a2,0x1
ffffffffc0200f7a:	2ca60613          	addi	a2,a2,714 # ffffffffc0202240 <commands+0x570>
ffffffffc0200f7e:	12b00593          	li	a1,299
ffffffffc0200f82:	00001517          	auipc	a0,0x1
ffffffffc0200f86:	2d650513          	addi	a0,a0,726 # ffffffffc0202258 <commands+0x588>
ffffffffc0200f8a:	c22ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200f8e:	00001697          	auipc	a3,0x1
ffffffffc0200f92:	43a68693          	addi	a3,a3,1082 # ffffffffc02023c8 <commands+0x6f8>
ffffffffc0200f96:	00001617          	auipc	a2,0x1
ffffffffc0200f9a:	2aa60613          	addi	a2,a2,682 # ffffffffc0202240 <commands+0x570>
ffffffffc0200f9e:	11f00593          	li	a1,287
ffffffffc0200fa2:	00001517          	auipc	a0,0x1
ffffffffc0200fa6:	2b650513          	addi	a0,a0,694 # ffffffffc0202258 <commands+0x588>
ffffffffc0200faa:	c02ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200fae:	00001697          	auipc	a3,0x1
ffffffffc0200fb2:	49a68693          	addi	a3,a3,1178 # ffffffffc0202448 <commands+0x778>
ffffffffc0200fb6:	00001617          	auipc	a2,0x1
ffffffffc0200fba:	28a60613          	addi	a2,a2,650 # ffffffffc0202240 <commands+0x570>
ffffffffc0200fbe:	11600593          	li	a1,278
ffffffffc0200fc2:	00001517          	auipc	a0,0x1
ffffffffc0200fc6:	29650513          	addi	a0,a0,662 # ffffffffc0202258 <commands+0x588>
ffffffffc0200fca:	be2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200fce:	00001697          	auipc	a3,0x1
ffffffffc0200fd2:	46a68693          	addi	a3,a3,1130 # ffffffffc0202438 <commands+0x768>
ffffffffc0200fd6:	00001617          	auipc	a2,0x1
ffffffffc0200fda:	26a60613          	addi	a2,a2,618 # ffffffffc0202240 <commands+0x570>
ffffffffc0200fde:	11500593          	li	a1,277
ffffffffc0200fe2:	00001517          	auipc	a0,0x1
ffffffffc0200fe6:	27650513          	addi	a0,a0,630 # ffffffffc0202258 <commands+0x588>
ffffffffc0200fea:	bc2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc0200fee:	00001697          	auipc	a3,0x1
ffffffffc0200ff2:	43a68693          	addi	a3,a3,1082 # ffffffffc0202428 <commands+0x758>
ffffffffc0200ff6:	00001617          	auipc	a2,0x1
ffffffffc0200ffa:	24a60613          	addi	a2,a2,586 # ffffffffc0202240 <commands+0x570>
ffffffffc0200ffe:	0f700593          	li	a1,247
ffffffffc0201002:	00001517          	auipc	a0,0x1
ffffffffc0201006:	25650513          	addi	a0,a0,598 # ffffffffc0202258 <commands+0x588>
ffffffffc020100a:	ba2ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc020100e:	00001697          	auipc	a3,0x1
ffffffffc0201012:	3ba68693          	addi	a3,a3,954 # ffffffffc02023c8 <commands+0x6f8>
ffffffffc0201016:	00001617          	auipc	a2,0x1
ffffffffc020101a:	22a60613          	addi	a2,a2,554 # ffffffffc0202240 <commands+0x570>
ffffffffc020101e:	0f500593          	li	a1,245
ffffffffc0201022:	00001517          	auipc	a0,0x1
ffffffffc0201026:	23650513          	addi	a0,a0,566 # ffffffffc0202258 <commands+0x588>
ffffffffc020102a:	b82ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc020102e:	00001697          	auipc	a3,0x1
ffffffffc0201032:	3da68693          	addi	a3,a3,986 # ffffffffc0202408 <commands+0x738>
ffffffffc0201036:	00001617          	auipc	a2,0x1
ffffffffc020103a:	20a60613          	addi	a2,a2,522 # ffffffffc0202240 <commands+0x570>
ffffffffc020103e:	0f400593          	li	a1,244
ffffffffc0201042:	00001517          	auipc	a0,0x1
ffffffffc0201046:	21650513          	addi	a0,a0,534 # ffffffffc0202258 <commands+0x588>
ffffffffc020104a:	b62ff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc020104e <best_fit_free_pages>:
ffffffffc020104e:	1141                	addi	sp,sp,-16
ffffffffc0201050:	e406                	sd	ra,8(sp)
ffffffffc0201052:	14058a63          	beqz	a1,ffffffffc02011a6 <best_fit_free_pages+0x158>
ffffffffc0201056:	00259693          	slli	a3,a1,0x2
ffffffffc020105a:	96ae                	add	a3,a3,a1
ffffffffc020105c:	068e                	slli	a3,a3,0x3
ffffffffc020105e:	96aa                	add	a3,a3,a0
ffffffffc0201060:	87aa                	mv	a5,a0
ffffffffc0201062:	02d50263          	beq	a0,a3,ffffffffc0201086 <best_fit_free_pages+0x38>
ffffffffc0201066:	6798                	ld	a4,8(a5)
ffffffffc0201068:	8b05                	andi	a4,a4,1
ffffffffc020106a:	10071e63          	bnez	a4,ffffffffc0201186 <best_fit_free_pages+0x138>
ffffffffc020106e:	6798                	ld	a4,8(a5)
ffffffffc0201070:	8b09                	andi	a4,a4,2
ffffffffc0201072:	10071a63          	bnez	a4,ffffffffc0201186 <best_fit_free_pages+0x138>
ffffffffc0201076:	0007b423          	sd	zero,8(a5)
ffffffffc020107a:	0007a023          	sw	zero,0(a5)
ffffffffc020107e:	02878793          	addi	a5,a5,40
ffffffffc0201082:	fed792e3          	bne	a5,a3,ffffffffc0201066 <best_fit_free_pages+0x18>
ffffffffc0201086:	2581                	sext.w	a1,a1
ffffffffc0201088:	c90c                	sw	a1,16(a0)
ffffffffc020108a:	00850893          	addi	a7,a0,8
ffffffffc020108e:	4789                	li	a5,2
ffffffffc0201090:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201094:	00005697          	auipc	a3,0x5
ffffffffc0201098:	f8468693          	addi	a3,a3,-124 # ffffffffc0206018 <free_area>
ffffffffc020109c:	4a98                	lw	a4,16(a3)
ffffffffc020109e:	669c                	ld	a5,8(a3)
ffffffffc02010a0:	01850613          	addi	a2,a0,24
ffffffffc02010a4:	9db9                	addw	a1,a1,a4
ffffffffc02010a6:	ca8c                	sw	a1,16(a3)
ffffffffc02010a8:	0ad78863          	beq	a5,a3,ffffffffc0201158 <best_fit_free_pages+0x10a>
ffffffffc02010ac:	fe878713          	addi	a4,a5,-24
ffffffffc02010b0:	0006b803          	ld	a6,0(a3)
ffffffffc02010b4:	4581                	li	a1,0
ffffffffc02010b6:	00e56a63          	bltu	a0,a4,ffffffffc02010ca <best_fit_free_pages+0x7c>
ffffffffc02010ba:	6798                	ld	a4,8(a5)
ffffffffc02010bc:	06d70263          	beq	a4,a3,ffffffffc0201120 <best_fit_free_pages+0xd2>
ffffffffc02010c0:	87ba                	mv	a5,a4
ffffffffc02010c2:	fe878713          	addi	a4,a5,-24
ffffffffc02010c6:	fee57ae3          	bgeu	a0,a4,ffffffffc02010ba <best_fit_free_pages+0x6c>
ffffffffc02010ca:	c199                	beqz	a1,ffffffffc02010d0 <best_fit_free_pages+0x82>
ffffffffc02010cc:	0106b023          	sd	a6,0(a3)
ffffffffc02010d0:	6398                	ld	a4,0(a5)
ffffffffc02010d2:	e390                	sd	a2,0(a5)
ffffffffc02010d4:	e710                	sd	a2,8(a4)
ffffffffc02010d6:	f11c                	sd	a5,32(a0)
ffffffffc02010d8:	ed18                	sd	a4,24(a0)
ffffffffc02010da:	02d70063          	beq	a4,a3,ffffffffc02010fa <best_fit_free_pages+0xac>
ffffffffc02010de:	ff872803          	lw	a6,-8(a4)
ffffffffc02010e2:	fe870593          	addi	a1,a4,-24
ffffffffc02010e6:	02081613          	slli	a2,a6,0x20
ffffffffc02010ea:	9201                	srli	a2,a2,0x20
ffffffffc02010ec:	00261793          	slli	a5,a2,0x2
ffffffffc02010f0:	97b2                	add	a5,a5,a2
ffffffffc02010f2:	078e                	slli	a5,a5,0x3
ffffffffc02010f4:	97ae                	add	a5,a5,a1
ffffffffc02010f6:	02f50f63          	beq	a0,a5,ffffffffc0201134 <best_fit_free_pages+0xe6>
ffffffffc02010fa:	7118                	ld	a4,32(a0)
ffffffffc02010fc:	00d70f63          	beq	a4,a3,ffffffffc020111a <best_fit_free_pages+0xcc>
ffffffffc0201100:	490c                	lw	a1,16(a0)
ffffffffc0201102:	fe870693          	addi	a3,a4,-24
ffffffffc0201106:	02059613          	slli	a2,a1,0x20
ffffffffc020110a:	9201                	srli	a2,a2,0x20
ffffffffc020110c:	00261793          	slli	a5,a2,0x2
ffffffffc0201110:	97b2                	add	a5,a5,a2
ffffffffc0201112:	078e                	slli	a5,a5,0x3
ffffffffc0201114:	97aa                	add	a5,a5,a0
ffffffffc0201116:	04f68863          	beq	a3,a5,ffffffffc0201166 <best_fit_free_pages+0x118>
ffffffffc020111a:	60a2                	ld	ra,8(sp)
ffffffffc020111c:	0141                	addi	sp,sp,16
ffffffffc020111e:	8082                	ret
ffffffffc0201120:	e790                	sd	a2,8(a5)
ffffffffc0201122:	f114                	sd	a3,32(a0)
ffffffffc0201124:	6798                	ld	a4,8(a5)
ffffffffc0201126:	ed1c                	sd	a5,24(a0)
ffffffffc0201128:	02d70563          	beq	a4,a3,ffffffffc0201152 <best_fit_free_pages+0x104>
ffffffffc020112c:	8832                	mv	a6,a2
ffffffffc020112e:	4585                	li	a1,1
ffffffffc0201130:	87ba                	mv	a5,a4
ffffffffc0201132:	bf41                	j	ffffffffc02010c2 <best_fit_free_pages+0x74>
ffffffffc0201134:	491c                	lw	a5,16(a0)
ffffffffc0201136:	0107883b          	addw	a6,a5,a6
ffffffffc020113a:	ff072c23          	sw	a6,-8(a4)
ffffffffc020113e:	57f5                	li	a5,-3
ffffffffc0201140:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201144:	6d10                	ld	a2,24(a0)
ffffffffc0201146:	711c                	ld	a5,32(a0)
ffffffffc0201148:	852e                	mv	a0,a1
ffffffffc020114a:	e61c                	sd	a5,8(a2)
ffffffffc020114c:	6718                	ld	a4,8(a4)
ffffffffc020114e:	e390                	sd	a2,0(a5)
ffffffffc0201150:	b775                	j	ffffffffc02010fc <best_fit_free_pages+0xae>
ffffffffc0201152:	e290                	sd	a2,0(a3)
ffffffffc0201154:	873e                	mv	a4,a5
ffffffffc0201156:	b761                	j	ffffffffc02010de <best_fit_free_pages+0x90>
ffffffffc0201158:	60a2                	ld	ra,8(sp)
ffffffffc020115a:	e390                	sd	a2,0(a5)
ffffffffc020115c:	e790                	sd	a2,8(a5)
ffffffffc020115e:	f11c                	sd	a5,32(a0)
ffffffffc0201160:	ed1c                	sd	a5,24(a0)
ffffffffc0201162:	0141                	addi	sp,sp,16
ffffffffc0201164:	8082                	ret
ffffffffc0201166:	ff872783          	lw	a5,-8(a4)
ffffffffc020116a:	ff070693          	addi	a3,a4,-16
ffffffffc020116e:	9dbd                	addw	a1,a1,a5
ffffffffc0201170:	c90c                	sw	a1,16(a0)
ffffffffc0201172:	57f5                	li	a5,-3
ffffffffc0201174:	60f6b02f          	amoand.d	zero,a5,(a3)
ffffffffc0201178:	6314                	ld	a3,0(a4)
ffffffffc020117a:	671c                	ld	a5,8(a4)
ffffffffc020117c:	60a2                	ld	ra,8(sp)
ffffffffc020117e:	e69c                	sd	a5,8(a3)
ffffffffc0201180:	e394                	sd	a3,0(a5)
ffffffffc0201182:	0141                	addi	sp,sp,16
ffffffffc0201184:	8082                	ret
ffffffffc0201186:	00001697          	auipc	a3,0x1
ffffffffc020118a:	3aa68693          	addi	a3,a3,938 # ffffffffc0202530 <commands+0x860>
ffffffffc020118e:	00001617          	auipc	a2,0x1
ffffffffc0201192:	0b260613          	addi	a2,a2,178 # ffffffffc0202240 <commands+0x570>
ffffffffc0201196:	09100593          	li	a1,145
ffffffffc020119a:	00001517          	auipc	a0,0x1
ffffffffc020119e:	0be50513          	addi	a0,a0,190 # ffffffffc0202258 <commands+0x588>
ffffffffc02011a2:	a0aff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc02011a6:	00001697          	auipc	a3,0x1
ffffffffc02011aa:	09268693          	addi	a3,a3,146 # ffffffffc0202238 <commands+0x568>
ffffffffc02011ae:	00001617          	auipc	a2,0x1
ffffffffc02011b2:	09260613          	addi	a2,a2,146 # ffffffffc0202240 <commands+0x570>
ffffffffc02011b6:	08e00593          	li	a1,142
ffffffffc02011ba:	00001517          	auipc	a0,0x1
ffffffffc02011be:	09e50513          	addi	a0,a0,158 # ffffffffc0202258 <commands+0x588>
ffffffffc02011c2:	9eaff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc02011c6 <best_fit_init_memmap>:
ffffffffc02011c6:	1141                	addi	sp,sp,-16
ffffffffc02011c8:	e406                	sd	ra,8(sp)
ffffffffc02011ca:	c9e1                	beqz	a1,ffffffffc020129a <best_fit_init_memmap+0xd4>
ffffffffc02011cc:	00259693          	slli	a3,a1,0x2
ffffffffc02011d0:	96ae                	add	a3,a3,a1
ffffffffc02011d2:	068e                	slli	a3,a3,0x3
ffffffffc02011d4:	96aa                	add	a3,a3,a0
ffffffffc02011d6:	87aa                	mv	a5,a0
ffffffffc02011d8:	00d50f63          	beq	a0,a3,ffffffffc02011f6 <best_fit_init_memmap+0x30>
ffffffffc02011dc:	6798                	ld	a4,8(a5)
ffffffffc02011de:	8b05                	andi	a4,a4,1
ffffffffc02011e0:	cf49                	beqz	a4,ffffffffc020127a <best_fit_init_memmap+0xb4>
ffffffffc02011e2:	0007a823          	sw	zero,16(a5)
ffffffffc02011e6:	0007b423          	sd	zero,8(a5)
ffffffffc02011ea:	0007a023          	sw	zero,0(a5)
ffffffffc02011ee:	02878793          	addi	a5,a5,40
ffffffffc02011f2:	fed795e3          	bne	a5,a3,ffffffffc02011dc <best_fit_init_memmap+0x16>
ffffffffc02011f6:	2581                	sext.w	a1,a1
ffffffffc02011f8:	c90c                	sw	a1,16(a0)
ffffffffc02011fa:	4789                	li	a5,2
ffffffffc02011fc:	00850713          	addi	a4,a0,8
ffffffffc0201200:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201204:	00005697          	auipc	a3,0x5
ffffffffc0201208:	e1468693          	addi	a3,a3,-492 # ffffffffc0206018 <free_area>
ffffffffc020120c:	4a98                	lw	a4,16(a3)
ffffffffc020120e:	669c                	ld	a5,8(a3)
ffffffffc0201210:	01850613          	addi	a2,a0,24
ffffffffc0201214:	9db9                	addw	a1,a1,a4
ffffffffc0201216:	ca8c                	sw	a1,16(a3)
ffffffffc0201218:	04d78a63          	beq	a5,a3,ffffffffc020126c <best_fit_init_memmap+0xa6>
ffffffffc020121c:	fe878713          	addi	a4,a5,-24
ffffffffc0201220:	0006b803          	ld	a6,0(a3)
ffffffffc0201224:	4581                	li	a1,0
ffffffffc0201226:	00e56a63          	bltu	a0,a4,ffffffffc020123a <best_fit_init_memmap+0x74>
ffffffffc020122a:	6798                	ld	a4,8(a5)
ffffffffc020122c:	02d70263          	beq	a4,a3,ffffffffc0201250 <best_fit_init_memmap+0x8a>
ffffffffc0201230:	87ba                	mv	a5,a4
ffffffffc0201232:	fe878713          	addi	a4,a5,-24
ffffffffc0201236:	fee57ae3          	bgeu	a0,a4,ffffffffc020122a <best_fit_init_memmap+0x64>
ffffffffc020123a:	c199                	beqz	a1,ffffffffc0201240 <best_fit_init_memmap+0x7a>
ffffffffc020123c:	0106b023          	sd	a6,0(a3)
ffffffffc0201240:	6398                	ld	a4,0(a5)
ffffffffc0201242:	60a2                	ld	ra,8(sp)
ffffffffc0201244:	e390                	sd	a2,0(a5)
ffffffffc0201246:	e710                	sd	a2,8(a4)
ffffffffc0201248:	f11c                	sd	a5,32(a0)
ffffffffc020124a:	ed18                	sd	a4,24(a0)
ffffffffc020124c:	0141                	addi	sp,sp,16
ffffffffc020124e:	8082                	ret
ffffffffc0201250:	e790                	sd	a2,8(a5)
ffffffffc0201252:	f114                	sd	a3,32(a0)
ffffffffc0201254:	6798                	ld	a4,8(a5)
ffffffffc0201256:	ed1c                	sd	a5,24(a0)
ffffffffc0201258:	00d70663          	beq	a4,a3,ffffffffc0201264 <best_fit_init_memmap+0x9e>
ffffffffc020125c:	8832                	mv	a6,a2
ffffffffc020125e:	4585                	li	a1,1
ffffffffc0201260:	87ba                	mv	a5,a4
ffffffffc0201262:	bfc1                	j	ffffffffc0201232 <best_fit_init_memmap+0x6c>
ffffffffc0201264:	60a2                	ld	ra,8(sp)
ffffffffc0201266:	e290                	sd	a2,0(a3)
ffffffffc0201268:	0141                	addi	sp,sp,16
ffffffffc020126a:	8082                	ret
ffffffffc020126c:	60a2                	ld	ra,8(sp)
ffffffffc020126e:	e390                	sd	a2,0(a5)
ffffffffc0201270:	e790                	sd	a2,8(a5)
ffffffffc0201272:	f11c                	sd	a5,32(a0)
ffffffffc0201274:	ed1c                	sd	a5,24(a0)
ffffffffc0201276:	0141                	addi	sp,sp,16
ffffffffc0201278:	8082                	ret
ffffffffc020127a:	00001697          	auipc	a3,0x1
ffffffffc020127e:	2de68693          	addi	a3,a3,734 # ffffffffc0202558 <commands+0x888>
ffffffffc0201282:	00001617          	auipc	a2,0x1
ffffffffc0201286:	fbe60613          	addi	a2,a2,-66 # ffffffffc0202240 <commands+0x570>
ffffffffc020128a:	04a00593          	li	a1,74
ffffffffc020128e:	00001517          	auipc	a0,0x1
ffffffffc0201292:	fca50513          	addi	a0,a0,-54 # ffffffffc0202258 <commands+0x588>
ffffffffc0201296:	916ff0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc020129a:	00001697          	auipc	a3,0x1
ffffffffc020129e:	f9e68693          	addi	a3,a3,-98 # ffffffffc0202238 <commands+0x568>
ffffffffc02012a2:	00001617          	auipc	a2,0x1
ffffffffc02012a6:	f9e60613          	addi	a2,a2,-98 # ffffffffc0202240 <commands+0x570>
ffffffffc02012aa:	04700593          	li	a1,71
ffffffffc02012ae:	00001517          	auipc	a0,0x1
ffffffffc02012b2:	faa50513          	addi	a0,a0,-86 # ffffffffc0202258 <commands+0x588>
ffffffffc02012b6:	8f6ff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc02012ba <alloc_pages>:
ffffffffc02012ba:	100027f3          	csrr	a5,sstatus
ffffffffc02012be:	8b89                	andi	a5,a5,2
ffffffffc02012c0:	e799                	bnez	a5,ffffffffc02012ce <alloc_pages+0x14>
ffffffffc02012c2:	00005797          	auipc	a5,0x5
ffffffffc02012c6:	1967b783          	ld	a5,406(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02012ca:	6f9c                	ld	a5,24(a5)
ffffffffc02012cc:	8782                	jr	a5
ffffffffc02012ce:	1141                	addi	sp,sp,-16
ffffffffc02012d0:	e406                	sd	ra,8(sp)
ffffffffc02012d2:	e022                	sd	s0,0(sp)
ffffffffc02012d4:	842a                	mv	s0,a0
ffffffffc02012d6:	988ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc02012da:	00005797          	auipc	a5,0x5
ffffffffc02012de:	17e7b783          	ld	a5,382(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02012e2:	6f9c                	ld	a5,24(a5)
ffffffffc02012e4:	8522                	mv	a0,s0
ffffffffc02012e6:	9782                	jalr	a5
ffffffffc02012e8:	842a                	mv	s0,a0
ffffffffc02012ea:	96eff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc02012ee:	60a2                	ld	ra,8(sp)
ffffffffc02012f0:	8522                	mv	a0,s0
ffffffffc02012f2:	6402                	ld	s0,0(sp)
ffffffffc02012f4:	0141                	addi	sp,sp,16
ffffffffc02012f6:	8082                	ret

ffffffffc02012f8 <free_pages>:
ffffffffc02012f8:	100027f3          	csrr	a5,sstatus
ffffffffc02012fc:	8b89                	andi	a5,a5,2
ffffffffc02012fe:	e799                	bnez	a5,ffffffffc020130c <free_pages+0x14>
ffffffffc0201300:	00005797          	auipc	a5,0x5
ffffffffc0201304:	1587b783          	ld	a5,344(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201308:	739c                	ld	a5,32(a5)
ffffffffc020130a:	8782                	jr	a5
ffffffffc020130c:	1101                	addi	sp,sp,-32
ffffffffc020130e:	ec06                	sd	ra,24(sp)
ffffffffc0201310:	e822                	sd	s0,16(sp)
ffffffffc0201312:	e426                	sd	s1,8(sp)
ffffffffc0201314:	842a                	mv	s0,a0
ffffffffc0201316:	84ae                	mv	s1,a1
ffffffffc0201318:	946ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020131c:	00005797          	auipc	a5,0x5
ffffffffc0201320:	13c7b783          	ld	a5,316(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201324:	739c                	ld	a5,32(a5)
ffffffffc0201326:	85a6                	mv	a1,s1
ffffffffc0201328:	8522                	mv	a0,s0
ffffffffc020132a:	9782                	jalr	a5
ffffffffc020132c:	6442                	ld	s0,16(sp)
ffffffffc020132e:	60e2                	ld	ra,24(sp)
ffffffffc0201330:	64a2                	ld	s1,8(sp)
ffffffffc0201332:	6105                	addi	sp,sp,32
ffffffffc0201334:	924ff06f          	j	ffffffffc0200458 <intr_enable>

ffffffffc0201338 <nr_free_pages>:
ffffffffc0201338:	100027f3          	csrr	a5,sstatus
ffffffffc020133c:	8b89                	andi	a5,a5,2
ffffffffc020133e:	e799                	bnez	a5,ffffffffc020134c <nr_free_pages+0x14>
ffffffffc0201340:	00005797          	auipc	a5,0x5
ffffffffc0201344:	1187b783          	ld	a5,280(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201348:	779c                	ld	a5,40(a5)
ffffffffc020134a:	8782                	jr	a5
ffffffffc020134c:	1141                	addi	sp,sp,-16
ffffffffc020134e:	e406                	sd	ra,8(sp)
ffffffffc0201350:	e022                	sd	s0,0(sp)
ffffffffc0201352:	90cff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0201356:	00005797          	auipc	a5,0x5
ffffffffc020135a:	1027b783          	ld	a5,258(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020135e:	779c                	ld	a5,40(a5)
ffffffffc0201360:	9782                	jalr	a5
ffffffffc0201362:	842a                	mv	s0,a0
ffffffffc0201364:	8f4ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc0201368:	60a2                	ld	ra,8(sp)
ffffffffc020136a:	8522                	mv	a0,s0
ffffffffc020136c:	6402                	ld	s0,0(sp)
ffffffffc020136e:	0141                	addi	sp,sp,16
ffffffffc0201370:	8082                	ret

ffffffffc0201372 <pmm_init>:
ffffffffc0201372:	00001797          	auipc	a5,0x1
ffffffffc0201376:	20e78793          	addi	a5,a5,526 # ffffffffc0202580 <best_fit_pmm_manager>
ffffffffc020137a:	638c                	ld	a1,0(a5)
ffffffffc020137c:	1101                	addi	sp,sp,-32
ffffffffc020137e:	e426                	sd	s1,8(sp)
ffffffffc0201380:	00001517          	auipc	a0,0x1
ffffffffc0201384:	23850513          	addi	a0,a0,568 # ffffffffc02025b8 <best_fit_pmm_manager+0x38>
ffffffffc0201388:	00005497          	auipc	s1,0x5
ffffffffc020138c:	0d048493          	addi	s1,s1,208 # ffffffffc0206458 <pmm_manager>
ffffffffc0201390:	ec06                	sd	ra,24(sp)
ffffffffc0201392:	e822                	sd	s0,16(sp)
ffffffffc0201394:	e09c                	sd	a5,0(s1)
ffffffffc0201396:	d1dfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020139a:	609c                	ld	a5,0(s1)
ffffffffc020139c:	00005417          	auipc	s0,0x5
ffffffffc02013a0:	0d440413          	addi	s0,s0,212 # ffffffffc0206470 <va_pa_offset>
ffffffffc02013a4:	679c                	ld	a5,8(a5)
ffffffffc02013a6:	9782                	jalr	a5
ffffffffc02013a8:	57f5                	li	a5,-3
ffffffffc02013aa:	07fa                	slli	a5,a5,0x1e
ffffffffc02013ac:	00001517          	auipc	a0,0x1
ffffffffc02013b0:	22450513          	addi	a0,a0,548 # ffffffffc02025d0 <best_fit_pmm_manager+0x50>
ffffffffc02013b4:	e01c                	sd	a5,0(s0)
ffffffffc02013b6:	cfdfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02013ba:	46c5                	li	a3,17
ffffffffc02013bc:	06ee                	slli	a3,a3,0x1b
ffffffffc02013be:	40100613          	li	a2,1025
ffffffffc02013c2:	16fd                	addi	a3,a3,-1
ffffffffc02013c4:	07e005b7          	lui	a1,0x7e00
ffffffffc02013c8:	0656                	slli	a2,a2,0x15
ffffffffc02013ca:	00001517          	auipc	a0,0x1
ffffffffc02013ce:	21e50513          	addi	a0,a0,542 # ffffffffc02025e8 <best_fit_pmm_manager+0x68>
ffffffffc02013d2:	ce1fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02013d6:	777d                	lui	a4,0xfffff
ffffffffc02013d8:	00006797          	auipc	a5,0x6
ffffffffc02013dc:	0a778793          	addi	a5,a5,167 # ffffffffc020747f <end+0xfff>
ffffffffc02013e0:	8ff9                	and	a5,a5,a4
ffffffffc02013e2:	00005517          	auipc	a0,0x5
ffffffffc02013e6:	06650513          	addi	a0,a0,102 # ffffffffc0206448 <npage>
ffffffffc02013ea:	00088737          	lui	a4,0x88
ffffffffc02013ee:	00005597          	auipc	a1,0x5
ffffffffc02013f2:	06258593          	addi	a1,a1,98 # ffffffffc0206450 <pages>
ffffffffc02013f6:	e118                	sd	a4,0(a0)
ffffffffc02013f8:	e19c                	sd	a5,0(a1)
ffffffffc02013fa:	4681                	li	a3,0
ffffffffc02013fc:	4701                	li	a4,0
ffffffffc02013fe:	4885                	li	a7,1
ffffffffc0201400:	fff80837          	lui	a6,0xfff80
ffffffffc0201404:	a011                	j	ffffffffc0201408 <pmm_init+0x96>
ffffffffc0201406:	619c                	ld	a5,0(a1)
ffffffffc0201408:	97b6                	add	a5,a5,a3
ffffffffc020140a:	07a1                	addi	a5,a5,8
ffffffffc020140c:	4117b02f          	amoor.d	zero,a7,(a5)
ffffffffc0201410:	611c                	ld	a5,0(a0)
ffffffffc0201412:	0705                	addi	a4,a4,1
ffffffffc0201414:	02868693          	addi	a3,a3,40
ffffffffc0201418:	01078633          	add	a2,a5,a6
ffffffffc020141c:	fec765e3          	bltu	a4,a2,ffffffffc0201406 <pmm_init+0x94>
ffffffffc0201420:	6190                	ld	a2,0(a1)
ffffffffc0201422:	00279713          	slli	a4,a5,0x2
ffffffffc0201426:	973e                	add	a4,a4,a5
ffffffffc0201428:	fec006b7          	lui	a3,0xfec00
ffffffffc020142c:	070e                	slli	a4,a4,0x3
ffffffffc020142e:	96b2                	add	a3,a3,a2
ffffffffc0201430:	96ba                	add	a3,a3,a4
ffffffffc0201432:	c0200737          	lui	a4,0xc0200
ffffffffc0201436:	08e6ef63          	bltu	a3,a4,ffffffffc02014d4 <pmm_init+0x162>
ffffffffc020143a:	6018                	ld	a4,0(s0)
ffffffffc020143c:	45c5                	li	a1,17
ffffffffc020143e:	05ee                	slli	a1,a1,0x1b
ffffffffc0201440:	8e99                	sub	a3,a3,a4
ffffffffc0201442:	04b6e863          	bltu	a3,a1,ffffffffc0201492 <pmm_init+0x120>
ffffffffc0201446:	609c                	ld	a5,0(s1)
ffffffffc0201448:	7b9c                	ld	a5,48(a5)
ffffffffc020144a:	9782                	jalr	a5
ffffffffc020144c:	00001517          	auipc	a0,0x1
ffffffffc0201450:	23450513          	addi	a0,a0,564 # ffffffffc0202680 <best_fit_pmm_manager+0x100>
ffffffffc0201454:	c5ffe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201458:	00004597          	auipc	a1,0x4
ffffffffc020145c:	ba858593          	addi	a1,a1,-1112 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0201460:	00005797          	auipc	a5,0x5
ffffffffc0201464:	00b7b423          	sd	a1,8(a5) # ffffffffc0206468 <satp_virtual>
ffffffffc0201468:	c02007b7          	lui	a5,0xc0200
ffffffffc020146c:	08f5e063          	bltu	a1,a5,ffffffffc02014ec <pmm_init+0x17a>
ffffffffc0201470:	6010                	ld	a2,0(s0)
ffffffffc0201472:	6442                	ld	s0,16(sp)
ffffffffc0201474:	60e2                	ld	ra,24(sp)
ffffffffc0201476:	64a2                	ld	s1,8(sp)
ffffffffc0201478:	40c58633          	sub	a2,a1,a2
ffffffffc020147c:	00005797          	auipc	a5,0x5
ffffffffc0201480:	fec7b223          	sd	a2,-28(a5) # ffffffffc0206460 <satp_physical>
ffffffffc0201484:	00001517          	auipc	a0,0x1
ffffffffc0201488:	21c50513          	addi	a0,a0,540 # ffffffffc02026a0 <best_fit_pmm_manager+0x120>
ffffffffc020148c:	6105                	addi	sp,sp,32
ffffffffc020148e:	c25fe06f          	j	ffffffffc02000b2 <cprintf>
ffffffffc0201492:	6705                	lui	a4,0x1
ffffffffc0201494:	177d                	addi	a4,a4,-1
ffffffffc0201496:	96ba                	add	a3,a3,a4
ffffffffc0201498:	777d                	lui	a4,0xfffff
ffffffffc020149a:	8ef9                	and	a3,a3,a4
ffffffffc020149c:	00c6d513          	srli	a0,a3,0xc
ffffffffc02014a0:	00f57e63          	bgeu	a0,a5,ffffffffc02014bc <pmm_init+0x14a>
ffffffffc02014a4:	609c                	ld	a5,0(s1)
ffffffffc02014a6:	982a                	add	a6,a6,a0
ffffffffc02014a8:	00281513          	slli	a0,a6,0x2
ffffffffc02014ac:	9542                	add	a0,a0,a6
ffffffffc02014ae:	6b9c                	ld	a5,16(a5)
ffffffffc02014b0:	8d95                	sub	a1,a1,a3
ffffffffc02014b2:	050e                	slli	a0,a0,0x3
ffffffffc02014b4:	81b1                	srli	a1,a1,0xc
ffffffffc02014b6:	9532                	add	a0,a0,a2
ffffffffc02014b8:	9782                	jalr	a5
ffffffffc02014ba:	b771                	j	ffffffffc0201446 <pmm_init+0xd4>
ffffffffc02014bc:	00001617          	auipc	a2,0x1
ffffffffc02014c0:	19460613          	addi	a2,a2,404 # ffffffffc0202650 <best_fit_pmm_manager+0xd0>
ffffffffc02014c4:	06b00593          	li	a1,107
ffffffffc02014c8:	00001517          	auipc	a0,0x1
ffffffffc02014cc:	1a850513          	addi	a0,a0,424 # ffffffffc0202670 <best_fit_pmm_manager+0xf0>
ffffffffc02014d0:	eddfe0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc02014d4:	00001617          	auipc	a2,0x1
ffffffffc02014d8:	14460613          	addi	a2,a2,324 # ffffffffc0202618 <best_fit_pmm_manager+0x98>
ffffffffc02014dc:	06e00593          	li	a1,110
ffffffffc02014e0:	00001517          	auipc	a0,0x1
ffffffffc02014e4:	16050513          	addi	a0,a0,352 # ffffffffc0202640 <best_fit_pmm_manager+0xc0>
ffffffffc02014e8:	ec5fe0ef          	jal	ra,ffffffffc02003ac <__panic>
ffffffffc02014ec:	86ae                	mv	a3,a1
ffffffffc02014ee:	00001617          	auipc	a2,0x1
ffffffffc02014f2:	12a60613          	addi	a2,a2,298 # ffffffffc0202618 <best_fit_pmm_manager+0x98>
ffffffffc02014f6:	08900593          	li	a1,137
ffffffffc02014fa:	00001517          	auipc	a0,0x1
ffffffffc02014fe:	14650513          	addi	a0,a0,326 # ffffffffc0202640 <best_fit_pmm_manager+0xc0>
ffffffffc0201502:	eabfe0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0201506 <printnum>:
ffffffffc0201506:	02069813          	slli	a6,a3,0x20
ffffffffc020150a:	7179                	addi	sp,sp,-48
ffffffffc020150c:	02085813          	srli	a6,a6,0x20
ffffffffc0201510:	e052                	sd	s4,0(sp)
ffffffffc0201512:	03067a33          	remu	s4,a2,a6
ffffffffc0201516:	f022                	sd	s0,32(sp)
ffffffffc0201518:	ec26                	sd	s1,24(sp)
ffffffffc020151a:	e84a                	sd	s2,16(sp)
ffffffffc020151c:	f406                	sd	ra,40(sp)
ffffffffc020151e:	e44e                	sd	s3,8(sp)
ffffffffc0201520:	84aa                	mv	s1,a0
ffffffffc0201522:	892e                	mv	s2,a1
ffffffffc0201524:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201528:	2a01                	sext.w	s4,s4
ffffffffc020152a:	03067e63          	bgeu	a2,a6,ffffffffc0201566 <printnum+0x60>
ffffffffc020152e:	89be                	mv	s3,a5
ffffffffc0201530:	00805763          	blez	s0,ffffffffc020153e <printnum+0x38>
ffffffffc0201534:	347d                	addiw	s0,s0,-1
ffffffffc0201536:	85ca                	mv	a1,s2
ffffffffc0201538:	854e                	mv	a0,s3
ffffffffc020153a:	9482                	jalr	s1
ffffffffc020153c:	fc65                	bnez	s0,ffffffffc0201534 <printnum+0x2e>
ffffffffc020153e:	1a02                	slli	s4,s4,0x20
ffffffffc0201540:	00001797          	auipc	a5,0x1
ffffffffc0201544:	1a078793          	addi	a5,a5,416 # ffffffffc02026e0 <best_fit_pmm_manager+0x160>
ffffffffc0201548:	020a5a13          	srli	s4,s4,0x20
ffffffffc020154c:	9a3e                	add	s4,s4,a5
ffffffffc020154e:	7402                	ld	s0,32(sp)
ffffffffc0201550:	000a4503          	lbu	a0,0(s4)
ffffffffc0201554:	70a2                	ld	ra,40(sp)
ffffffffc0201556:	69a2                	ld	s3,8(sp)
ffffffffc0201558:	6a02                	ld	s4,0(sp)
ffffffffc020155a:	85ca                	mv	a1,s2
ffffffffc020155c:	87a6                	mv	a5,s1
ffffffffc020155e:	6942                	ld	s2,16(sp)
ffffffffc0201560:	64e2                	ld	s1,24(sp)
ffffffffc0201562:	6145                	addi	sp,sp,48
ffffffffc0201564:	8782                	jr	a5
ffffffffc0201566:	03065633          	divu	a2,a2,a6
ffffffffc020156a:	8722                	mv	a4,s0
ffffffffc020156c:	f9bff0ef          	jal	ra,ffffffffc0201506 <printnum>
ffffffffc0201570:	b7f9                	j	ffffffffc020153e <printnum+0x38>

ffffffffc0201572 <vprintfmt>:
ffffffffc0201572:	7119                	addi	sp,sp,-128
ffffffffc0201574:	f4a6                	sd	s1,104(sp)
ffffffffc0201576:	f0ca                	sd	s2,96(sp)
ffffffffc0201578:	ecce                	sd	s3,88(sp)
ffffffffc020157a:	e8d2                	sd	s4,80(sp)
ffffffffc020157c:	e4d6                	sd	s5,72(sp)
ffffffffc020157e:	e0da                	sd	s6,64(sp)
ffffffffc0201580:	fc5e                	sd	s7,56(sp)
ffffffffc0201582:	f06a                	sd	s10,32(sp)
ffffffffc0201584:	fc86                	sd	ra,120(sp)
ffffffffc0201586:	f8a2                	sd	s0,112(sp)
ffffffffc0201588:	f862                	sd	s8,48(sp)
ffffffffc020158a:	f466                	sd	s9,40(sp)
ffffffffc020158c:	ec6e                	sd	s11,24(sp)
ffffffffc020158e:	892a                	mv	s2,a0
ffffffffc0201590:	84ae                	mv	s1,a1
ffffffffc0201592:	8d32                	mv	s10,a2
ffffffffc0201594:	8a36                	mv	s4,a3
ffffffffc0201596:	02500993          	li	s3,37
ffffffffc020159a:	5b7d                	li	s6,-1
ffffffffc020159c:	00001a97          	auipc	s5,0x1
ffffffffc02015a0:	178a8a93          	addi	s5,s5,376 # ffffffffc0202714 <best_fit_pmm_manager+0x194>
ffffffffc02015a4:	00001b97          	auipc	s7,0x1
ffffffffc02015a8:	34cb8b93          	addi	s7,s7,844 # ffffffffc02028f0 <error_string>
ffffffffc02015ac:	000d4503          	lbu	a0,0(s10)
ffffffffc02015b0:	001d0413          	addi	s0,s10,1
ffffffffc02015b4:	01350a63          	beq	a0,s3,ffffffffc02015c8 <vprintfmt+0x56>
ffffffffc02015b8:	c121                	beqz	a0,ffffffffc02015f8 <vprintfmt+0x86>
ffffffffc02015ba:	85a6                	mv	a1,s1
ffffffffc02015bc:	0405                	addi	s0,s0,1
ffffffffc02015be:	9902                	jalr	s2
ffffffffc02015c0:	fff44503          	lbu	a0,-1(s0)
ffffffffc02015c4:	ff351ae3          	bne	a0,s3,ffffffffc02015b8 <vprintfmt+0x46>
ffffffffc02015c8:	00044603          	lbu	a2,0(s0)
ffffffffc02015cc:	02000793          	li	a5,32
ffffffffc02015d0:	4c81                	li	s9,0
ffffffffc02015d2:	4881                	li	a7,0
ffffffffc02015d4:	5c7d                	li	s8,-1
ffffffffc02015d6:	5dfd                	li	s11,-1
ffffffffc02015d8:	05500513          	li	a0,85
ffffffffc02015dc:	4825                	li	a6,9
ffffffffc02015de:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02015e2:	0ff5f593          	andi	a1,a1,255
ffffffffc02015e6:	00140d13          	addi	s10,s0,1
ffffffffc02015ea:	04b56263          	bltu	a0,a1,ffffffffc020162e <vprintfmt+0xbc>
ffffffffc02015ee:	058a                	slli	a1,a1,0x2
ffffffffc02015f0:	95d6                	add	a1,a1,s5
ffffffffc02015f2:	4194                	lw	a3,0(a1)
ffffffffc02015f4:	96d6                	add	a3,a3,s5
ffffffffc02015f6:	8682                	jr	a3
ffffffffc02015f8:	70e6                	ld	ra,120(sp)
ffffffffc02015fa:	7446                	ld	s0,112(sp)
ffffffffc02015fc:	74a6                	ld	s1,104(sp)
ffffffffc02015fe:	7906                	ld	s2,96(sp)
ffffffffc0201600:	69e6                	ld	s3,88(sp)
ffffffffc0201602:	6a46                	ld	s4,80(sp)
ffffffffc0201604:	6aa6                	ld	s5,72(sp)
ffffffffc0201606:	6b06                	ld	s6,64(sp)
ffffffffc0201608:	7be2                	ld	s7,56(sp)
ffffffffc020160a:	7c42                	ld	s8,48(sp)
ffffffffc020160c:	7ca2                	ld	s9,40(sp)
ffffffffc020160e:	7d02                	ld	s10,32(sp)
ffffffffc0201610:	6de2                	ld	s11,24(sp)
ffffffffc0201612:	6109                	addi	sp,sp,128
ffffffffc0201614:	8082                	ret
ffffffffc0201616:	87b2                	mv	a5,a2
ffffffffc0201618:	00144603          	lbu	a2,1(s0)
ffffffffc020161c:	846a                	mv	s0,s10
ffffffffc020161e:	00140d13          	addi	s10,s0,1
ffffffffc0201622:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201626:	0ff5f593          	andi	a1,a1,255
ffffffffc020162a:	fcb572e3          	bgeu	a0,a1,ffffffffc02015ee <vprintfmt+0x7c>
ffffffffc020162e:	85a6                	mv	a1,s1
ffffffffc0201630:	02500513          	li	a0,37
ffffffffc0201634:	9902                	jalr	s2
ffffffffc0201636:	fff44783          	lbu	a5,-1(s0)
ffffffffc020163a:	8d22                	mv	s10,s0
ffffffffc020163c:	f73788e3          	beq	a5,s3,ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc0201640:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201644:	1d7d                	addi	s10,s10,-1
ffffffffc0201646:	ff379de3          	bne	a5,s3,ffffffffc0201640 <vprintfmt+0xce>
ffffffffc020164a:	b78d                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc020164c:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0201650:	00144603          	lbu	a2,1(s0)
ffffffffc0201654:	846a                	mv	s0,s10
ffffffffc0201656:	fd06069b          	addiw	a3,a2,-48
ffffffffc020165a:	0006059b          	sext.w	a1,a2
ffffffffc020165e:	02d86463          	bltu	a6,a3,ffffffffc0201686 <vprintfmt+0x114>
ffffffffc0201662:	00144603          	lbu	a2,1(s0)
ffffffffc0201666:	002c169b          	slliw	a3,s8,0x2
ffffffffc020166a:	0186873b          	addw	a4,a3,s8
ffffffffc020166e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201672:	9f2d                	addw	a4,a4,a1
ffffffffc0201674:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201678:	0405                	addi	s0,s0,1
ffffffffc020167a:	fd070c1b          	addiw	s8,a4,-48
ffffffffc020167e:	0006059b          	sext.w	a1,a2
ffffffffc0201682:	fed870e3          	bgeu	a6,a3,ffffffffc0201662 <vprintfmt+0xf0>
ffffffffc0201686:	f40ddce3          	bgez	s11,ffffffffc02015de <vprintfmt+0x6c>
ffffffffc020168a:	8de2                	mv	s11,s8
ffffffffc020168c:	5c7d                	li	s8,-1
ffffffffc020168e:	bf81                	j	ffffffffc02015de <vprintfmt+0x6c>
ffffffffc0201690:	fffdc693          	not	a3,s11
ffffffffc0201694:	96fd                	srai	a3,a3,0x3f
ffffffffc0201696:	00ddfdb3          	and	s11,s11,a3
ffffffffc020169a:	00144603          	lbu	a2,1(s0)
ffffffffc020169e:	2d81                	sext.w	s11,s11
ffffffffc02016a0:	846a                	mv	s0,s10
ffffffffc02016a2:	bf35                	j	ffffffffc02015de <vprintfmt+0x6c>
ffffffffc02016a4:	000a2c03          	lw	s8,0(s4)
ffffffffc02016a8:	00144603          	lbu	a2,1(s0)
ffffffffc02016ac:	0a21                	addi	s4,s4,8
ffffffffc02016ae:	846a                	mv	s0,s10
ffffffffc02016b0:	bfd9                	j	ffffffffc0201686 <vprintfmt+0x114>
ffffffffc02016b2:	4705                	li	a4,1
ffffffffc02016b4:	008a0593          	addi	a1,s4,8
ffffffffc02016b8:	01174463          	blt	a4,a7,ffffffffc02016c0 <vprintfmt+0x14e>
ffffffffc02016bc:	1a088e63          	beqz	a7,ffffffffc0201878 <vprintfmt+0x306>
ffffffffc02016c0:	000a3603          	ld	a2,0(s4)
ffffffffc02016c4:	46c1                	li	a3,16
ffffffffc02016c6:	8a2e                	mv	s4,a1
ffffffffc02016c8:	2781                	sext.w	a5,a5
ffffffffc02016ca:	876e                	mv	a4,s11
ffffffffc02016cc:	85a6                	mv	a1,s1
ffffffffc02016ce:	854a                	mv	a0,s2
ffffffffc02016d0:	e37ff0ef          	jal	ra,ffffffffc0201506 <printnum>
ffffffffc02016d4:	bde1                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc02016d6:	000a2503          	lw	a0,0(s4)
ffffffffc02016da:	85a6                	mv	a1,s1
ffffffffc02016dc:	0a21                	addi	s4,s4,8
ffffffffc02016de:	9902                	jalr	s2
ffffffffc02016e0:	b5f1                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc02016e2:	4705                	li	a4,1
ffffffffc02016e4:	008a0593          	addi	a1,s4,8
ffffffffc02016e8:	01174463          	blt	a4,a7,ffffffffc02016f0 <vprintfmt+0x17e>
ffffffffc02016ec:	18088163          	beqz	a7,ffffffffc020186e <vprintfmt+0x2fc>
ffffffffc02016f0:	000a3603          	ld	a2,0(s4)
ffffffffc02016f4:	46a9                	li	a3,10
ffffffffc02016f6:	8a2e                	mv	s4,a1
ffffffffc02016f8:	bfc1                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc02016fa:	00144603          	lbu	a2,1(s0)
ffffffffc02016fe:	4c85                	li	s9,1
ffffffffc0201700:	846a                	mv	s0,s10
ffffffffc0201702:	bdf1                	j	ffffffffc02015de <vprintfmt+0x6c>
ffffffffc0201704:	85a6                	mv	a1,s1
ffffffffc0201706:	02500513          	li	a0,37
ffffffffc020170a:	9902                	jalr	s2
ffffffffc020170c:	b545                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc020170e:	00144603          	lbu	a2,1(s0)
ffffffffc0201712:	2885                	addiw	a7,a7,1
ffffffffc0201714:	846a                	mv	s0,s10
ffffffffc0201716:	b5e1                	j	ffffffffc02015de <vprintfmt+0x6c>
ffffffffc0201718:	4705                	li	a4,1
ffffffffc020171a:	008a0593          	addi	a1,s4,8
ffffffffc020171e:	01174463          	blt	a4,a7,ffffffffc0201726 <vprintfmt+0x1b4>
ffffffffc0201722:	14088163          	beqz	a7,ffffffffc0201864 <vprintfmt+0x2f2>
ffffffffc0201726:	000a3603          	ld	a2,0(s4)
ffffffffc020172a:	46a1                	li	a3,8
ffffffffc020172c:	8a2e                	mv	s4,a1
ffffffffc020172e:	bf69                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc0201730:	03000513          	li	a0,48
ffffffffc0201734:	85a6                	mv	a1,s1
ffffffffc0201736:	e03e                	sd	a5,0(sp)
ffffffffc0201738:	9902                	jalr	s2
ffffffffc020173a:	85a6                	mv	a1,s1
ffffffffc020173c:	07800513          	li	a0,120
ffffffffc0201740:	9902                	jalr	s2
ffffffffc0201742:	0a21                	addi	s4,s4,8
ffffffffc0201744:	6782                	ld	a5,0(sp)
ffffffffc0201746:	46c1                	li	a3,16
ffffffffc0201748:	ff8a3603          	ld	a2,-8(s4)
ffffffffc020174c:	bfb5                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc020174e:	000a3403          	ld	s0,0(s4)
ffffffffc0201752:	008a0713          	addi	a4,s4,8
ffffffffc0201756:	e03a                	sd	a4,0(sp)
ffffffffc0201758:	14040263          	beqz	s0,ffffffffc020189c <vprintfmt+0x32a>
ffffffffc020175c:	0fb05763          	blez	s11,ffffffffc020184a <vprintfmt+0x2d8>
ffffffffc0201760:	02d00693          	li	a3,45
ffffffffc0201764:	0cd79163          	bne	a5,a3,ffffffffc0201826 <vprintfmt+0x2b4>
ffffffffc0201768:	00044783          	lbu	a5,0(s0)
ffffffffc020176c:	0007851b          	sext.w	a0,a5
ffffffffc0201770:	cf85                	beqz	a5,ffffffffc02017a8 <vprintfmt+0x236>
ffffffffc0201772:	00140a13          	addi	s4,s0,1
ffffffffc0201776:	05e00413          	li	s0,94
ffffffffc020177a:	000c4563          	bltz	s8,ffffffffc0201784 <vprintfmt+0x212>
ffffffffc020177e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201780:	036c0263          	beq	s8,s6,ffffffffc02017a4 <vprintfmt+0x232>
ffffffffc0201784:	85a6                	mv	a1,s1
ffffffffc0201786:	0e0c8e63          	beqz	s9,ffffffffc0201882 <vprintfmt+0x310>
ffffffffc020178a:	3781                	addiw	a5,a5,-32
ffffffffc020178c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201882 <vprintfmt+0x310>
ffffffffc0201790:	03f00513          	li	a0,63
ffffffffc0201794:	9902                	jalr	s2
ffffffffc0201796:	000a4783          	lbu	a5,0(s4)
ffffffffc020179a:	3dfd                	addiw	s11,s11,-1
ffffffffc020179c:	0a05                	addi	s4,s4,1
ffffffffc020179e:	0007851b          	sext.w	a0,a5
ffffffffc02017a2:	ffe1                	bnez	a5,ffffffffc020177a <vprintfmt+0x208>
ffffffffc02017a4:	01b05963          	blez	s11,ffffffffc02017b6 <vprintfmt+0x244>
ffffffffc02017a8:	3dfd                	addiw	s11,s11,-1
ffffffffc02017aa:	85a6                	mv	a1,s1
ffffffffc02017ac:	02000513          	li	a0,32
ffffffffc02017b0:	9902                	jalr	s2
ffffffffc02017b2:	fe0d9be3          	bnez	s11,ffffffffc02017a8 <vprintfmt+0x236>
ffffffffc02017b6:	6a02                	ld	s4,0(sp)
ffffffffc02017b8:	bbd5                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc02017ba:	4705                	li	a4,1
ffffffffc02017bc:	008a0c93          	addi	s9,s4,8
ffffffffc02017c0:	01174463          	blt	a4,a7,ffffffffc02017c8 <vprintfmt+0x256>
ffffffffc02017c4:	08088d63          	beqz	a7,ffffffffc020185e <vprintfmt+0x2ec>
ffffffffc02017c8:	000a3403          	ld	s0,0(s4)
ffffffffc02017cc:	0a044d63          	bltz	s0,ffffffffc0201886 <vprintfmt+0x314>
ffffffffc02017d0:	8622                	mv	a2,s0
ffffffffc02017d2:	8a66                	mv	s4,s9
ffffffffc02017d4:	46a9                	li	a3,10
ffffffffc02017d6:	bdcd                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc02017d8:	000a2783          	lw	a5,0(s4)
ffffffffc02017dc:	4719                	li	a4,6
ffffffffc02017de:	0a21                	addi	s4,s4,8
ffffffffc02017e0:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02017e4:	8fb5                	xor	a5,a5,a3
ffffffffc02017e6:	40d786bb          	subw	a3,a5,a3
ffffffffc02017ea:	02d74163          	blt	a4,a3,ffffffffc020180c <vprintfmt+0x29a>
ffffffffc02017ee:	00369793          	slli	a5,a3,0x3
ffffffffc02017f2:	97de                	add	a5,a5,s7
ffffffffc02017f4:	639c                	ld	a5,0(a5)
ffffffffc02017f6:	cb99                	beqz	a5,ffffffffc020180c <vprintfmt+0x29a>
ffffffffc02017f8:	86be                	mv	a3,a5
ffffffffc02017fa:	00001617          	auipc	a2,0x1
ffffffffc02017fe:	f1660613          	addi	a2,a2,-234 # ffffffffc0202710 <best_fit_pmm_manager+0x190>
ffffffffc0201802:	85a6                	mv	a1,s1
ffffffffc0201804:	854a                	mv	a0,s2
ffffffffc0201806:	0ce000ef          	jal	ra,ffffffffc02018d4 <printfmt>
ffffffffc020180a:	b34d                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc020180c:	00001617          	auipc	a2,0x1
ffffffffc0201810:	ef460613          	addi	a2,a2,-268 # ffffffffc0202700 <best_fit_pmm_manager+0x180>
ffffffffc0201814:	85a6                	mv	a1,s1
ffffffffc0201816:	854a                	mv	a0,s2
ffffffffc0201818:	0bc000ef          	jal	ra,ffffffffc02018d4 <printfmt>
ffffffffc020181c:	bb41                	j	ffffffffc02015ac <vprintfmt+0x3a>
ffffffffc020181e:	00001417          	auipc	s0,0x1
ffffffffc0201822:	eda40413          	addi	s0,s0,-294 # ffffffffc02026f8 <best_fit_pmm_manager+0x178>
ffffffffc0201826:	85e2                	mv	a1,s8
ffffffffc0201828:	8522                	mv	a0,s0
ffffffffc020182a:	e43e                	sd	a5,8(sp)
ffffffffc020182c:	1e6000ef          	jal	ra,ffffffffc0201a12 <strnlen>
ffffffffc0201830:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201834:	01b05b63          	blez	s11,ffffffffc020184a <vprintfmt+0x2d8>
ffffffffc0201838:	67a2                	ld	a5,8(sp)
ffffffffc020183a:	00078a1b          	sext.w	s4,a5
ffffffffc020183e:	3dfd                	addiw	s11,s11,-1
ffffffffc0201840:	85a6                	mv	a1,s1
ffffffffc0201842:	8552                	mv	a0,s4
ffffffffc0201844:	9902                	jalr	s2
ffffffffc0201846:	fe0d9ce3          	bnez	s11,ffffffffc020183e <vprintfmt+0x2cc>
ffffffffc020184a:	00044783          	lbu	a5,0(s0)
ffffffffc020184e:	00140a13          	addi	s4,s0,1
ffffffffc0201852:	0007851b          	sext.w	a0,a5
ffffffffc0201856:	d3a5                	beqz	a5,ffffffffc02017b6 <vprintfmt+0x244>
ffffffffc0201858:	05e00413          	li	s0,94
ffffffffc020185c:	bf39                	j	ffffffffc020177a <vprintfmt+0x208>
ffffffffc020185e:	000a2403          	lw	s0,0(s4)
ffffffffc0201862:	b7ad                	j	ffffffffc02017cc <vprintfmt+0x25a>
ffffffffc0201864:	000a6603          	lwu	a2,0(s4)
ffffffffc0201868:	46a1                	li	a3,8
ffffffffc020186a:	8a2e                	mv	s4,a1
ffffffffc020186c:	bdb1                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc020186e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201872:	46a9                	li	a3,10
ffffffffc0201874:	8a2e                	mv	s4,a1
ffffffffc0201876:	bd89                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc0201878:	000a6603          	lwu	a2,0(s4)
ffffffffc020187c:	46c1                	li	a3,16
ffffffffc020187e:	8a2e                	mv	s4,a1
ffffffffc0201880:	b5a1                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc0201882:	9902                	jalr	s2
ffffffffc0201884:	bf09                	j	ffffffffc0201796 <vprintfmt+0x224>
ffffffffc0201886:	85a6                	mv	a1,s1
ffffffffc0201888:	02d00513          	li	a0,45
ffffffffc020188c:	e03e                	sd	a5,0(sp)
ffffffffc020188e:	9902                	jalr	s2
ffffffffc0201890:	6782                	ld	a5,0(sp)
ffffffffc0201892:	8a66                	mv	s4,s9
ffffffffc0201894:	40800633          	neg	a2,s0
ffffffffc0201898:	46a9                	li	a3,10
ffffffffc020189a:	b53d                	j	ffffffffc02016c8 <vprintfmt+0x156>
ffffffffc020189c:	03b05163          	blez	s11,ffffffffc02018be <vprintfmt+0x34c>
ffffffffc02018a0:	02d00693          	li	a3,45
ffffffffc02018a4:	f6d79de3          	bne	a5,a3,ffffffffc020181e <vprintfmt+0x2ac>
ffffffffc02018a8:	00001417          	auipc	s0,0x1
ffffffffc02018ac:	e5040413          	addi	s0,s0,-432 # ffffffffc02026f8 <best_fit_pmm_manager+0x178>
ffffffffc02018b0:	02800793          	li	a5,40
ffffffffc02018b4:	02800513          	li	a0,40
ffffffffc02018b8:	00140a13          	addi	s4,s0,1
ffffffffc02018bc:	bd6d                	j	ffffffffc0201776 <vprintfmt+0x204>
ffffffffc02018be:	00001a17          	auipc	s4,0x1
ffffffffc02018c2:	e3ba0a13          	addi	s4,s4,-453 # ffffffffc02026f9 <best_fit_pmm_manager+0x179>
ffffffffc02018c6:	02800513          	li	a0,40
ffffffffc02018ca:	02800793          	li	a5,40
ffffffffc02018ce:	05e00413          	li	s0,94
ffffffffc02018d2:	b565                	j	ffffffffc020177a <vprintfmt+0x208>

ffffffffc02018d4 <printfmt>:
ffffffffc02018d4:	715d                	addi	sp,sp,-80
ffffffffc02018d6:	02810313          	addi	t1,sp,40
ffffffffc02018da:	f436                	sd	a3,40(sp)
ffffffffc02018dc:	869a                	mv	a3,t1
ffffffffc02018de:	ec06                	sd	ra,24(sp)
ffffffffc02018e0:	f83a                	sd	a4,48(sp)
ffffffffc02018e2:	fc3e                	sd	a5,56(sp)
ffffffffc02018e4:	e0c2                	sd	a6,64(sp)
ffffffffc02018e6:	e4c6                	sd	a7,72(sp)
ffffffffc02018e8:	e41a                	sd	t1,8(sp)
ffffffffc02018ea:	c89ff0ef          	jal	ra,ffffffffc0201572 <vprintfmt>
ffffffffc02018ee:	60e2                	ld	ra,24(sp)
ffffffffc02018f0:	6161                	addi	sp,sp,80
ffffffffc02018f2:	8082                	ret

ffffffffc02018f4 <readline>:
ffffffffc02018f4:	715d                	addi	sp,sp,-80
ffffffffc02018f6:	e486                	sd	ra,72(sp)
ffffffffc02018f8:	e0a6                	sd	s1,64(sp)
ffffffffc02018fa:	fc4a                	sd	s2,56(sp)
ffffffffc02018fc:	f84e                	sd	s3,48(sp)
ffffffffc02018fe:	f452                	sd	s4,40(sp)
ffffffffc0201900:	f056                	sd	s5,32(sp)
ffffffffc0201902:	ec5a                	sd	s6,24(sp)
ffffffffc0201904:	e85e                	sd	s7,16(sp)
ffffffffc0201906:	c901                	beqz	a0,ffffffffc0201916 <readline+0x22>
ffffffffc0201908:	85aa                	mv	a1,a0
ffffffffc020190a:	00001517          	auipc	a0,0x1
ffffffffc020190e:	e0650513          	addi	a0,a0,-506 # ffffffffc0202710 <best_fit_pmm_manager+0x190>
ffffffffc0201912:	fa0fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201916:	4481                	li	s1,0
ffffffffc0201918:	497d                	li	s2,31
ffffffffc020191a:	49a1                	li	s3,8
ffffffffc020191c:	4aa9                	li	s5,10
ffffffffc020191e:	4b35                	li	s6,13
ffffffffc0201920:	00004b97          	auipc	s7,0x4
ffffffffc0201924:	710b8b93          	addi	s7,s7,1808 # ffffffffc0206030 <buf>
ffffffffc0201928:	3fe00a13          	li	s4,1022
ffffffffc020192c:	ffefe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201930:	00054a63          	bltz	a0,ffffffffc0201944 <readline+0x50>
ffffffffc0201934:	00a95a63          	bge	s2,a0,ffffffffc0201948 <readline+0x54>
ffffffffc0201938:	029a5263          	bge	s4,s1,ffffffffc020195c <readline+0x68>
ffffffffc020193c:	feefe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201940:	fe055ae3          	bgez	a0,ffffffffc0201934 <readline+0x40>
ffffffffc0201944:	4501                	li	a0,0
ffffffffc0201946:	a091                	j	ffffffffc020198a <readline+0x96>
ffffffffc0201948:	03351463          	bne	a0,s3,ffffffffc0201970 <readline+0x7c>
ffffffffc020194c:	e8a9                	bnez	s1,ffffffffc020199e <readline+0xaa>
ffffffffc020194e:	fdcfe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201952:	fe0549e3          	bltz	a0,ffffffffc0201944 <readline+0x50>
ffffffffc0201956:	fea959e3          	bge	s2,a0,ffffffffc0201948 <readline+0x54>
ffffffffc020195a:	4481                	li	s1,0
ffffffffc020195c:	e42a                	sd	a0,8(sp)
ffffffffc020195e:	f8afe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201962:	6522                	ld	a0,8(sp)
ffffffffc0201964:	009b87b3          	add	a5,s7,s1
ffffffffc0201968:	2485                	addiw	s1,s1,1
ffffffffc020196a:	00a78023          	sb	a0,0(a5)
ffffffffc020196e:	bf7d                	j	ffffffffc020192c <readline+0x38>
ffffffffc0201970:	01550463          	beq	a0,s5,ffffffffc0201978 <readline+0x84>
ffffffffc0201974:	fb651ce3          	bne	a0,s6,ffffffffc020192c <readline+0x38>
ffffffffc0201978:	f70fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc020197c:	00004517          	auipc	a0,0x4
ffffffffc0201980:	6b450513          	addi	a0,a0,1716 # ffffffffc0206030 <buf>
ffffffffc0201984:	94aa                	add	s1,s1,a0
ffffffffc0201986:	00048023          	sb	zero,0(s1)
ffffffffc020198a:	60a6                	ld	ra,72(sp)
ffffffffc020198c:	6486                	ld	s1,64(sp)
ffffffffc020198e:	7962                	ld	s2,56(sp)
ffffffffc0201990:	79c2                	ld	s3,48(sp)
ffffffffc0201992:	7a22                	ld	s4,40(sp)
ffffffffc0201994:	7a82                	ld	s5,32(sp)
ffffffffc0201996:	6b62                	ld	s6,24(sp)
ffffffffc0201998:	6bc2                	ld	s7,16(sp)
ffffffffc020199a:	6161                	addi	sp,sp,80
ffffffffc020199c:	8082                	ret
ffffffffc020199e:	4521                	li	a0,8
ffffffffc02019a0:	f48fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02019a4:	34fd                	addiw	s1,s1,-1
ffffffffc02019a6:	b759                	j	ffffffffc020192c <readline+0x38>

ffffffffc02019a8 <sbi_console_putchar>:
ffffffffc02019a8:	4781                	li	a5,0
ffffffffc02019aa:	00004717          	auipc	a4,0x4
ffffffffc02019ae:	65e73703          	ld	a4,1630(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc02019b2:	88ba                	mv	a7,a4
ffffffffc02019b4:	852a                	mv	a0,a0
ffffffffc02019b6:	85be                	mv	a1,a5
ffffffffc02019b8:	863e                	mv	a2,a5
ffffffffc02019ba:	00000073          	ecall
ffffffffc02019be:	87aa                	mv	a5,a0
ffffffffc02019c0:	8082                	ret

ffffffffc02019c2 <sbi_set_timer>:
ffffffffc02019c2:	4781                	li	a5,0
ffffffffc02019c4:	00005717          	auipc	a4,0x5
ffffffffc02019c8:	ab473703          	ld	a4,-1356(a4) # ffffffffc0206478 <SBI_SET_TIMER>
ffffffffc02019cc:	88ba                	mv	a7,a4
ffffffffc02019ce:	852a                	mv	a0,a0
ffffffffc02019d0:	85be                	mv	a1,a5
ffffffffc02019d2:	863e                	mv	a2,a5
ffffffffc02019d4:	00000073          	ecall
ffffffffc02019d8:	87aa                	mv	a5,a0
ffffffffc02019da:	8082                	ret

ffffffffc02019dc <sbi_console_getchar>:
ffffffffc02019dc:	4501                	li	a0,0
ffffffffc02019de:	00004797          	auipc	a5,0x4
ffffffffc02019e2:	6227b783          	ld	a5,1570(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc02019e6:	88be                	mv	a7,a5
ffffffffc02019e8:	852a                	mv	a0,a0
ffffffffc02019ea:	85aa                	mv	a1,a0
ffffffffc02019ec:	862a                	mv	a2,a0
ffffffffc02019ee:	00000073          	ecall
ffffffffc02019f2:	852a                	mv	a0,a0
ffffffffc02019f4:	2501                	sext.w	a0,a0
ffffffffc02019f6:	8082                	ret

ffffffffc02019f8 <sbi_shutdown>:
ffffffffc02019f8:	4781                	li	a5,0
ffffffffc02019fa:	00004717          	auipc	a4,0x4
ffffffffc02019fe:	61673703          	ld	a4,1558(a4) # ffffffffc0206010 <SBI_SHUTDOWN>
ffffffffc0201a02:	88ba                	mv	a7,a4
ffffffffc0201a04:	853e                	mv	a0,a5
ffffffffc0201a06:	85be                	mv	a1,a5
ffffffffc0201a08:	863e                	mv	a2,a5
ffffffffc0201a0a:	00000073          	ecall
ffffffffc0201a0e:	87aa                	mv	a5,a0
ffffffffc0201a10:	8082                	ret

ffffffffc0201a12 <strnlen>:
ffffffffc0201a12:	4781                	li	a5,0
ffffffffc0201a14:	e589                	bnez	a1,ffffffffc0201a1e <strnlen+0xc>
ffffffffc0201a16:	a811                	j	ffffffffc0201a2a <strnlen+0x18>
ffffffffc0201a18:	0785                	addi	a5,a5,1
ffffffffc0201a1a:	00f58863          	beq	a1,a5,ffffffffc0201a2a <strnlen+0x18>
ffffffffc0201a1e:	00f50733          	add	a4,a0,a5
ffffffffc0201a22:	00074703          	lbu	a4,0(a4)
ffffffffc0201a26:	fb6d                	bnez	a4,ffffffffc0201a18 <strnlen+0x6>
ffffffffc0201a28:	85be                	mv	a1,a5
ffffffffc0201a2a:	852e                	mv	a0,a1
ffffffffc0201a2c:	8082                	ret

ffffffffc0201a2e <strcmp>:
ffffffffc0201a2e:	00054783          	lbu	a5,0(a0)
ffffffffc0201a32:	0005c703          	lbu	a4,0(a1)
ffffffffc0201a36:	cb89                	beqz	a5,ffffffffc0201a48 <strcmp+0x1a>
ffffffffc0201a38:	0505                	addi	a0,a0,1
ffffffffc0201a3a:	0585                	addi	a1,a1,1
ffffffffc0201a3c:	fee789e3          	beq	a5,a4,ffffffffc0201a2e <strcmp>
ffffffffc0201a40:	0007851b          	sext.w	a0,a5
ffffffffc0201a44:	9d19                	subw	a0,a0,a4
ffffffffc0201a46:	8082                	ret
ffffffffc0201a48:	4501                	li	a0,0
ffffffffc0201a4a:	bfed                	j	ffffffffc0201a44 <strcmp+0x16>

ffffffffc0201a4c <strchr>:
ffffffffc0201a4c:	00054783          	lbu	a5,0(a0)
ffffffffc0201a50:	c799                	beqz	a5,ffffffffc0201a5e <strchr+0x12>
ffffffffc0201a52:	00f58763          	beq	a1,a5,ffffffffc0201a60 <strchr+0x14>
ffffffffc0201a56:	00154783          	lbu	a5,1(a0)
ffffffffc0201a5a:	0505                	addi	a0,a0,1
ffffffffc0201a5c:	fbfd                	bnez	a5,ffffffffc0201a52 <strchr+0x6>
ffffffffc0201a5e:	4501                	li	a0,0
ffffffffc0201a60:	8082                	ret

ffffffffc0201a62 <memset>:
ffffffffc0201a62:	ca01                	beqz	a2,ffffffffc0201a72 <memset+0x10>
ffffffffc0201a64:	962a                	add	a2,a2,a0
ffffffffc0201a66:	87aa                	mv	a5,a0
ffffffffc0201a68:	0785                	addi	a5,a5,1
ffffffffc0201a6a:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201a6e:	fec79de3          	bne	a5,a2,ffffffffc0201a68 <memset+0x6>
ffffffffc0201a72:	8082                	ret
=======
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

ffffffffc020092a <pmm_init>:
    pmm_manager = &buddy_pmm_manager;
ffffffffc020092a:	00002797          	auipc	a5,0x2
ffffffffc020092e:	f4678793          	addi	a5,a5,-186 # ffffffffc0202870 <buddy_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200932:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200934:	1101                	addi	sp,sp,-32
ffffffffc0200936:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200938:	00002517          	auipc	a0,0x2
ffffffffc020093c:	b5850513          	addi	a0,a0,-1192 # ffffffffc0202490 <commands+0x548>
    pmm_manager = &buddy_pmm_manager;
ffffffffc0200940:	00006497          	auipc	s1,0x6
ffffffffc0200944:	b1848493          	addi	s1,s1,-1256 # ffffffffc0206458 <pmm_manager>
void pmm_init(void) {
ffffffffc0200948:	ec06                	sd	ra,24(sp)
ffffffffc020094a:	e822                	sd	s0,16(sp)
    pmm_manager = &buddy_pmm_manager;
ffffffffc020094c:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020094e:	f64ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc0200952:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200954:	00006417          	auipc	s0,0x6
ffffffffc0200958:	b1c40413          	addi	s0,s0,-1252 # ffffffffc0206470 <va_pa_offset>
    pmm_manager->init();
ffffffffc020095c:	679c                	ld	a5,8(a5)
ffffffffc020095e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200960:	57f5                	li	a5,-3
ffffffffc0200962:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0200964:	00002517          	auipc	a0,0x2
ffffffffc0200968:	b4450513          	addi	a0,a0,-1212 # ffffffffc02024a8 <commands+0x560>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020096c:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc020096e:	f44ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200972:	46c5                	li	a3,17
ffffffffc0200974:	06ee                	slli	a3,a3,0x1b
ffffffffc0200976:	40100613          	li	a2,1025
ffffffffc020097a:	16fd                	addi	a3,a3,-1
ffffffffc020097c:	07e005b7          	lui	a1,0x7e00
ffffffffc0200980:	0656                	slli	a2,a2,0x15
ffffffffc0200982:	00002517          	auipc	a0,0x2
ffffffffc0200986:	b3e50513          	addi	a0,a0,-1218 # ffffffffc02024c0 <commands+0x578>
ffffffffc020098a:	f28ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020098e:	777d                	lui	a4,0xfffff
ffffffffc0200990:	00007797          	auipc	a5,0x7
ffffffffc0200994:	b2778793          	addi	a5,a5,-1241 # ffffffffc02074b7 <end+0xfff>
ffffffffc0200998:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc020099a:	00006517          	auipc	a0,0x6
ffffffffc020099e:	aae50513          	addi	a0,a0,-1362 # ffffffffc0206448 <npage>
ffffffffc02009a2:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009a6:	00006597          	auipc	a1,0x6
ffffffffc02009aa:	aaa58593          	addi	a1,a1,-1366 # ffffffffc0206450 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02009ae:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009b0:	e19c                	sd	a5,0(a1)
ffffffffc02009b2:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02009b4:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02009b6:	4885                	li	a7,1
ffffffffc02009b8:	fff80837          	lui	a6,0xfff80
ffffffffc02009bc:	a011                	j	ffffffffc02009c0 <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc02009be:	619c                	ld	a5,0(a1)
ffffffffc02009c0:	97b6                	add	a5,a5,a3
ffffffffc02009c2:	07a1                	addi	a5,a5,8
ffffffffc02009c4:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02009c8:	611c                	ld	a5,0(a0)
ffffffffc02009ca:	0705                	addi	a4,a4,1
ffffffffc02009cc:	02868693          	addi	a3,a3,40
ffffffffc02009d0:	01078633          	add	a2,a5,a6
ffffffffc02009d4:	fec765e3          	bltu	a4,a2,ffffffffc02009be <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02009d8:	6190                	ld	a2,0(a1)
ffffffffc02009da:	00279713          	slli	a4,a5,0x2
ffffffffc02009de:	973e                	add	a4,a4,a5
ffffffffc02009e0:	fec006b7          	lui	a3,0xfec00
ffffffffc02009e4:	070e                	slli	a4,a4,0x3
ffffffffc02009e6:	96b2                	add	a3,a3,a2
ffffffffc02009e8:	96ba                	add	a3,a3,a4
ffffffffc02009ea:	c0200737          	lui	a4,0xc0200
ffffffffc02009ee:	08e6ef63          	bltu	a3,a4,ffffffffc0200a8c <pmm_init+0x162>
ffffffffc02009f2:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc02009f4:	45c5                	li	a1,17
ffffffffc02009f6:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02009f8:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02009fa:	04b6e863          	bltu	a3,a1,ffffffffc0200a4a <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02009fe:	609c                	ld	a5,0(s1)
ffffffffc0200a00:	7b9c                	ld	a5,48(a5)
ffffffffc0200a02:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200a04:	00002517          	auipc	a0,0x2
ffffffffc0200a08:	b5450513          	addi	a0,a0,-1196 # ffffffffc0202558 <commands+0x610>
ffffffffc0200a0c:	ea6ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200a10:	00004597          	auipc	a1,0x4
ffffffffc0200a14:	5f058593          	addi	a1,a1,1520 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200a18:	00006797          	auipc	a5,0x6
ffffffffc0200a1c:	a4b7b823          	sd	a1,-1456(a5) # ffffffffc0206468 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a20:	c02007b7          	lui	a5,0xc0200
ffffffffc0200a24:	08f5e063          	bltu	a1,a5,ffffffffc0200aa4 <pmm_init+0x17a>
ffffffffc0200a28:	6010                	ld	a2,0(s0)
}
ffffffffc0200a2a:	6442                	ld	s0,16(sp)
ffffffffc0200a2c:	60e2                	ld	ra,24(sp)
ffffffffc0200a2e:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a30:	40c58633          	sub	a2,a1,a2
ffffffffc0200a34:	00006797          	auipc	a5,0x6
ffffffffc0200a38:	a2c7b623          	sd	a2,-1492(a5) # ffffffffc0206460 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a3c:	00002517          	auipc	a0,0x2
ffffffffc0200a40:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0202578 <commands+0x630>
}
ffffffffc0200a44:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200a46:	e6cff06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200a4a:	6705                	lui	a4,0x1
ffffffffc0200a4c:	177d                	addi	a4,a4,-1
ffffffffc0200a4e:	96ba                	add	a3,a3,a4
ffffffffc0200a50:	777d                	lui	a4,0xfffff
ffffffffc0200a52:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200a54:	00c6d513          	srli	a0,a3,0xc
ffffffffc0200a58:	00f57e63          	bgeu	a0,a5,ffffffffc0200a74 <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc0200a5c:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200a5e:	982a                	add	a6,a6,a0
ffffffffc0200a60:	00281513          	slli	a0,a6,0x2
ffffffffc0200a64:	9542                	add	a0,a0,a6
ffffffffc0200a66:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200a68:	8d95                	sub	a1,a1,a3
ffffffffc0200a6a:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200a6c:	81b1                	srli	a1,a1,0xc
ffffffffc0200a6e:	9532                	add	a0,a0,a2
ffffffffc0200a70:	9782                	jalr	a5
}
ffffffffc0200a72:	b771                	j	ffffffffc02009fe <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0200a74:	00002617          	auipc	a2,0x2
ffffffffc0200a78:	ab460613          	addi	a2,a2,-1356 # ffffffffc0202528 <commands+0x5e0>
ffffffffc0200a7c:	06b00593          	li	a1,107
ffffffffc0200a80:	00002517          	auipc	a0,0x2
ffffffffc0200a84:	ac850513          	addi	a0,a0,-1336 # ffffffffc0202548 <commands+0x600>
ffffffffc0200a88:	eb2ff0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a8c:	00002617          	auipc	a2,0x2
ffffffffc0200a90:	a6460613          	addi	a2,a2,-1436 # ffffffffc02024f0 <commands+0x5a8>
ffffffffc0200a94:	06f00593          	li	a1,111
ffffffffc0200a98:	00002517          	auipc	a0,0x2
ffffffffc0200a9c:	a8050513          	addi	a0,a0,-1408 # ffffffffc0202518 <commands+0x5d0>
ffffffffc0200aa0:	e9aff0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200aa4:	86ae                	mv	a3,a1
ffffffffc0200aa6:	00002617          	auipc	a2,0x2
ffffffffc0200aaa:	a4a60613          	addi	a2,a2,-1462 # ffffffffc02024f0 <commands+0x5a8>
ffffffffc0200aae:	08a00593          	li	a1,138
ffffffffc0200ab2:	00002517          	auipc	a0,0x2
ffffffffc0200ab6:	a6650513          	addi	a0,a0,-1434 # ffffffffc0202518 <commands+0x5d0>
ffffffffc0200aba:	e80ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200abe <buddy_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200abe:	00005797          	auipc	a5,0x5
ffffffffc0200ac2:	55a78793          	addi	a5,a5,1370 # ffffffffc0206018 <free_area>
ffffffffc0200ac6:	e79c                	sd	a5,8(a5)
ffffffffc0200ac8:	e39c                	sd	a5,0(a5)

//初始化 buddy 系统的自由列表和自由页计数
static void buddy_init(void)
{
    list_init(&free_list);//管理空闲页
    nr_free = 0;
ffffffffc0200aca:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200ace:	8082                	ret

ffffffffc0200ad0 <buddy_nr_free_pages>:
//获取自由页计数
static size_t
buddy_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200ad0:	00005517          	auipc	a0,0x5
ffffffffc0200ad4:	55856503          	lwu	a0,1368(a0) # ffffffffc0206028 <free_area+0x10>
ffffffffc0200ad8:	8082                	ret

ffffffffc0200ada <buddy_free_pages>:
{
ffffffffc0200ada:	1141                	addi	sp,sp,-16
ffffffffc0200adc:	e406                	sd	ra,8(sp)
ffffffffc0200ade:	e022                	sd	s0,0(sp)
    assert(n > 0);
ffffffffc0200ae0:	20058763          	beqz	a1,ffffffffc0200cee <buddy_free_pages+0x214>
    size_t length = POWER_ROUND_UP(n);
ffffffffc0200ae4:	0015d793          	srli	a5,a1,0x1
ffffffffc0200ae8:	8fcd                	or	a5,a5,a1
ffffffffc0200aea:	0027d713          	srli	a4,a5,0x2
ffffffffc0200aee:	8fd9                	or	a5,a5,a4
ffffffffc0200af0:	0047d713          	srli	a4,a5,0x4
ffffffffc0200af4:	8f5d                	or	a4,a4,a5
ffffffffc0200af6:	00875793          	srli	a5,a4,0x8
ffffffffc0200afa:	8f5d                	or	a4,a4,a5
ffffffffc0200afc:	01075793          	srli	a5,a4,0x10
ffffffffc0200b00:	8fd9                	or	a5,a5,a4
ffffffffc0200b02:	8385                	srli	a5,a5,0x1
ffffffffc0200b04:	00b7f733          	and	a4,a5,a1
ffffffffc0200b08:	8e2e                	mv	t3,a1
ffffffffc0200b0a:	1a071c63          	bnez	a4,ffffffffc0200cc2 <buddy_free_pages+0x1e8>
    size_t begin = (base - allocate_area);//计算要释放的页在 allocate_area 中的起始偏移
ffffffffc0200b0e:	00006897          	auipc	a7,0x6
ffffffffc0200b12:	96a8b883          	ld	a7,-1686(a7) # ffffffffc0206478 <allocate_area>
ffffffffc0200b16:	411506b3          	sub	a3,a0,a7
ffffffffc0200b1a:	00002797          	auipc	a5,0x2
ffffffffc0200b1e:	fde7b783          	ld	a5,-34(a5) # ffffffffc0202af8 <nbase+0x8>
ffffffffc0200b22:	868d                	srai	a3,a3,0x3
ffffffffc0200b24:	02f686b3          	mul	a3,a3,a5
    size_t block = BUDDY_BLOCK(begin, end);//计算要释放的页所在的节点索引
ffffffffc0200b28:	00006817          	auipc	a6,0x6
ffffffffc0200b2c:	95883803          	ld	a6,-1704(a6) # ffffffffc0206480 <full_tree_size>
    for (; p != base + n; p++)
ffffffffc0200b30:	00259613          	slli	a2,a1,0x2
ffffffffc0200b34:	962e                	add	a2,a2,a1
ffffffffc0200b36:	060e                	slli	a2,a2,0x3
ffffffffc0200b38:	962a                	add	a2,a2,a0
ffffffffc0200b3a:	87aa                	mv	a5,a0
    size_t block = BUDDY_BLOCK(begin, end);//计算要释放的页所在的节点索引
ffffffffc0200b3c:	03c6d6b3          	divu	a3,a3,t3
ffffffffc0200b40:	03c85733          	divu	a4,a6,t3
ffffffffc0200b44:	96ba                	add	a3,a3,a4
    for (; p != base + n; p++)
ffffffffc0200b46:	00c50e63          	beq	a0,a2,ffffffffc0200b62 <buddy_free_pages+0x88>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200b4a:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p));
ffffffffc0200b4c:	8b05                	andi	a4,a4,1
ffffffffc0200b4e:	18071063          	bnez	a4,ffffffffc0200cce <buddy_free_pages+0x1f4>
        p->flags = 0;
ffffffffc0200b52:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200b56:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0200b5a:	02878793          	addi	a5,a5,40
ffffffffc0200b5e:	fec796e3          	bne	a5,a2,ffffffffc0200b4a <buddy_free_pages+0x70>
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc0200b62:	00005317          	auipc	t1,0x5
ffffffffc0200b66:	4b630313          	addi	t1,t1,1206 # ffffffffc0206018 <free_area>
    nr_free += length;
ffffffffc0200b6a:	01032783          	lw	a5,16(t1)
ffffffffc0200b6e:	00833603          	ld	a2,8(t1)
    base->property = length;
ffffffffc0200b72:	000e071b          	sext.w	a4,t3
ffffffffc0200b76:	c918                	sw	a4,16(a0)
    list_add(&free_list, &(base->page_link));
ffffffffc0200b78:	01850e93          	addi	t4,a0,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200b7c:	01d63023          	sd	t4,0(a2)
    nr_free += length;
ffffffffc0200b80:	9fb9                	addw	a5,a5,a4
    record_area[block] = length;
ffffffffc0200b82:	00006597          	auipc	a1,0x6
ffffffffc0200b86:	9165b583          	ld	a1,-1770(a1) # ffffffffc0206498 <record_area>
ffffffffc0200b8a:	00369713          	slli	a4,a3,0x3
    elm->next = next;
ffffffffc0200b8e:	f110                	sd	a2,32(a0)
    elm->prev = prev;
ffffffffc0200b90:	00653c23          	sd	t1,24(a0)
    nr_free += length;
ffffffffc0200b94:	00f32823          	sw	a5,16(t1)
    prev->next = next->prev = elm;
ffffffffc0200b98:	01d33423          	sd	t4,8(t1)
    record_area[block] = length;
ffffffffc0200b9c:	972e                	add	a4,a4,a1
ffffffffc0200b9e:	01c73023          	sd	t3,0(a4) # fffffffffffff000 <end+0x3fdf8b48>
    while (block != TREE_ROOT)
ffffffffc0200ba2:	4785                	li	a5,1
ffffffffc0200ba4:	4505                	li	a0,1
ffffffffc0200ba6:	06f68563          	beq	a3,a5,ffffffffc0200c10 <buddy_free_pages+0x136>
        size_t left = LEFT_CHILD(block);
ffffffffc0200baa:	ffe6f793          	andi	a5,a3,-2
        block = PARENT(block);
ffffffffc0200bae:	8285                	srli	a3,a3,0x1
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right))
ffffffffc0200bb0:	00f6e733          	or	a4,a3,a5
ffffffffc0200bb4:	00275613          	srli	a2,a4,0x2
ffffffffc0200bb8:	8f51                	or	a4,a4,a2
ffffffffc0200bba:	00475613          	srli	a2,a4,0x4
ffffffffc0200bbe:	8e59                	or	a2,a2,a4
ffffffffc0200bc0:	00865713          	srli	a4,a2,0x8
ffffffffc0200bc4:	8e59                	or	a2,a2,a4
ffffffffc0200bc6:	01065713          	srli	a4,a2,0x10
ffffffffc0200bca:	8f51                	or	a4,a4,a2
ffffffffc0200bcc:	00379e13          	slli	t3,a5,0x3
ffffffffc0200bd0:	8305                	srli	a4,a4,0x1
ffffffffc0200bd2:	9e2e                	add	t3,t3,a1
ffffffffc0200bd4:	00f77f33          	and	t5,a4,a5
ffffffffc0200bd8:	000e3283          	ld	t0,0(t3)
        size_t left = LEFT_CHILD(block);
ffffffffc0200bdc:	863e                	mv	a2,a5
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right))
ffffffffc0200bde:	000f0663          	beqz	t5,ffffffffc0200bea <buddy_free_pages+0x110>
ffffffffc0200be2:	fff74713          	not	a4,a4
ffffffffc0200be6:	00f77633          	and	a2,a4,a5
ffffffffc0200bea:	02c85733          	divu	a4,a6,a2
            record_area[block] = record_area[left] * 2;
ffffffffc0200bee:	00369613          	slli	a2,a3,0x3
ffffffffc0200bf2:	00c58eb3          	add	t4,a1,a2
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right))
ffffffffc0200bf6:	02e28163          	beq	t0,a4,ffffffffc0200c18 <buddy_free_pages+0x13e>
            record_area[block] = record_area[LEFT_CHILD(block)] | record_area[RIGHT_CHILD(block)];
ffffffffc0200bfa:	00469793          	slli	a5,a3,0x4
ffffffffc0200bfe:	97ae                	add	a5,a5,a1
ffffffffc0200c00:	9676                	add	a2,a2,t4
ffffffffc0200c02:	679c                	ld	a5,8(a5)
ffffffffc0200c04:	6218                	ld	a4,0(a2)
ffffffffc0200c06:	8fd9                	or	a5,a5,a4
ffffffffc0200c08:	00feb023          	sd	a5,0(t4)
    while (block != TREE_ROOT)
ffffffffc0200c0c:	f8a69fe3          	bne	a3,a0,ffffffffc0200baa <buddy_free_pages+0xd0>
}
ffffffffc0200c10:	60a2                	ld	ra,8(sp)
ffffffffc0200c12:	6402                	ld	s0,0(sp)
ffffffffc0200c14:	0141                	addi	sp,sp,16
ffffffffc0200c16:	8082                	ret
        size_t right = RIGHT_CHILD(block);
ffffffffc0200c18:	00178f93          	addi	t6,a5,1
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right))
ffffffffc0200c1c:	8385                	srli	a5,a5,0x1
ffffffffc0200c1e:	01f7e7b3          	or	a5,a5,t6
ffffffffc0200c22:	0027d393          	srli	t2,a5,0x2
ffffffffc0200c26:	00f3e7b3          	or	a5,t2,a5
ffffffffc0200c2a:	0047d393          	srli	t2,a5,0x4
ffffffffc0200c2e:	00f3e3b3          	or	t2,t2,a5
ffffffffc0200c32:	0083d793          	srli	a5,t2,0x8
ffffffffc0200c36:	0077e3b3          	or	t2,a5,t2
ffffffffc0200c3a:	0103d793          	srli	a5,t2,0x10
ffffffffc0200c3e:	0077e7b3          	or	a5,a5,t2
ffffffffc0200c42:	8385                	srli	a5,a5,0x1
ffffffffc0200c44:	01f7f3b3          	and	t2,a5,t6
ffffffffc0200c48:	008e3403          	ld	s0,8(t3)
ffffffffc0200c4c:	00038663          	beqz	t2,ffffffffc0200c58 <buddy_free_pages+0x17e>
ffffffffc0200c50:	fff7c793          	not	a5,a5
ffffffffc0200c54:	00ffffb3          	and	t6,t6,a5
ffffffffc0200c58:	03f85fb3          	divu	t6,a6,t6
ffffffffc0200c5c:	f9f41fe3          	bne	s0,t6,ffffffffc0200bfa <buddy_free_pages+0x120>
            list_del(&(allocate_area[lbegin].page_link));
ffffffffc0200c60:	02ef0733          	mul	a4,t5,a4
            record_area[block] = record_area[left] * 2;
ffffffffc0200c64:	0286                	slli	t0,t0,0x1
            list_del(&(allocate_area[rbegin].page_link));
ffffffffc0200c66:	028383b3          	mul	t2,t2,s0
            list_del(&(allocate_area[lbegin].page_link));
ffffffffc0200c6a:	00271793          	slli	a5,a4,0x2
ffffffffc0200c6e:	973e                	add	a4,a4,a5
ffffffffc0200c70:	00371793          	slli	a5,a4,0x3
ffffffffc0200c74:	97c6                	add	a5,a5,a7
    __list_del(listelm->prev, listelm->next);
ffffffffc0200c76:	7390                	ld	a2,32(a5)
ffffffffc0200c78:	0187bf83          	ld	t6,24(a5)
            list_add(&free_list, &(allocate_area[lbegin].page_link));
ffffffffc0200c7c:	01878f13          	addi	t5,a5,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200c80:	00cfb423          	sd	a2,8(t6)
            list_del(&(allocate_area[rbegin].page_link));
ffffffffc0200c84:	00239713          	slli	a4,t2,0x2
ffffffffc0200c88:	93ba                	add	t2,t2,a4
ffffffffc0200c8a:	00339713          	slli	a4,t2,0x3
    next->prev = prev;
ffffffffc0200c8e:	01f63023          	sd	t6,0(a2)
ffffffffc0200c92:	9746                	add	a4,a4,a7
    __list_del(listelm->prev, listelm->next);
ffffffffc0200c94:	6f10                	ld	a2,24(a4)
ffffffffc0200c96:	7318                	ld	a4,32(a4)
    prev->next = next;
ffffffffc0200c98:	e618                	sd	a4,8(a2)
    next->prev = prev;
ffffffffc0200c9a:	e310                	sd	a2,0(a4)
            record_area[block] = record_area[left] * 2;
ffffffffc0200c9c:	005eb023          	sd	t0,0(t4)
            allocate_area[lbegin].property = record_area[left] * 2;
ffffffffc0200ca0:	000e3703          	ld	a4,0(t3)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200ca4:	00833603          	ld	a2,8(t1)
ffffffffc0200ca8:	0017171b          	slliw	a4,a4,0x1
ffffffffc0200cac:	cb98                	sw	a4,16(a5)
    prev->next = next->prev = elm;
ffffffffc0200cae:	01e63023          	sd	t5,0(a2)
ffffffffc0200cb2:	01e33423          	sd	t5,8(t1)
    elm->next = next;
ffffffffc0200cb6:	f390                	sd	a2,32(a5)
    elm->prev = prev;
ffffffffc0200cb8:	0067bc23          	sd	t1,24(a5)
    while (block != TREE_ROOT)
ffffffffc0200cbc:	eea697e3          	bne	a3,a0,ffffffffc0200baa <buddy_free_pages+0xd0>
ffffffffc0200cc0:	bf81                	j	ffffffffc0200c10 <buddy_free_pages+0x136>
    size_t length = POWER_ROUND_UP(n);
ffffffffc0200cc2:	fff7c793          	not	a5,a5
ffffffffc0200cc6:	8fed                	and	a5,a5,a1
ffffffffc0200cc8:	00179e13          	slli	t3,a5,0x1
ffffffffc0200ccc:	b589                	j	ffffffffc0200b0e <buddy_free_pages+0x34>
        assert(!PageReserved(p));
ffffffffc0200cce:	00002697          	auipc	a3,0x2
ffffffffc0200cd2:	92268693          	addi	a3,a3,-1758 # ffffffffc02025f0 <commands+0x6a8>
ffffffffc0200cd6:	00002617          	auipc	a2,0x2
ffffffffc0200cda:	8ea60613          	addi	a2,a2,-1814 # ffffffffc02025c0 <commands+0x678>
ffffffffc0200cde:	0cb00593          	li	a1,203
ffffffffc0200ce2:	00002517          	auipc	a0,0x2
ffffffffc0200ce6:	8f650513          	addi	a0,a0,-1802 # ffffffffc02025d8 <commands+0x690>
ffffffffc0200cea:	c50ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0200cee:	00002697          	auipc	a3,0x2
ffffffffc0200cf2:	8ca68693          	addi	a3,a3,-1846 # ffffffffc02025b8 <commands+0x670>
ffffffffc0200cf6:	00002617          	auipc	a2,0x2
ffffffffc0200cfa:	8ca60613          	addi	a2,a2,-1846 # ffffffffc02025c0 <commands+0x678>
ffffffffc0200cfe:	0c100593          	li	a1,193
ffffffffc0200d02:	00002517          	auipc	a0,0x2
ffffffffc0200d06:	8d650513          	addi	a0,a0,-1834 # ffffffffc02025d8 <commands+0x690>
ffffffffc0200d0a:	c30ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200d0e <buddy_allocate_pages>:
    assert(n > 0);
ffffffffc0200d0e:	1e050063          	beqz	a0,ffffffffc0200eee <buddy_allocate_pages+0x1e0>
    size_t length = POWER_ROUND_UP(n);//请求分配的页数 n 向上取整到最近的 2 的幂次方
ffffffffc0200d12:	00155793          	srli	a5,a0,0x1
ffffffffc0200d16:	8fc9                	or	a5,a5,a0
ffffffffc0200d18:	0027d713          	srli	a4,a5,0x2
ffffffffc0200d1c:	8fd9                	or	a5,a5,a4
ffffffffc0200d1e:	0047d713          	srli	a4,a5,0x4
ffffffffc0200d22:	8f5d                	or	a4,a4,a5
ffffffffc0200d24:	00875793          	srli	a5,a4,0x8
ffffffffc0200d28:	8f5d                	or	a4,a4,a5
ffffffffc0200d2a:	01075793          	srli	a5,a4,0x10
ffffffffc0200d2e:	8fd9                	or	a5,a5,a4
ffffffffc0200d30:	8385                	srli	a5,a5,0x1
ffffffffc0200d32:	00a7f733          	and	a4,a5,a0
ffffffffc0200d36:	18071963          	bnez	a4,ffffffffc0200ec8 <buddy_allocate_pages+0x1ba>
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200d3a:	00005897          	auipc	a7,0x5
ffffffffc0200d3e:	75e8b883          	ld	a7,1886(a7) # ffffffffc0206498 <record_area>
ffffffffc0200d42:	0088b783          	ld	a5,8(a7)
ffffffffc0200d46:	00888f93          	addi	t6,a7,8
ffffffffc0200d4a:	16a7e763          	bltu	a5,a0,ffffffffc0200eb8 <buddy_allocate_pages+0x1aa>
ffffffffc0200d4e:	00005e97          	auipc	t4,0x5
ffffffffc0200d52:	732ebe83          	ld	t4,1842(t4) # ffffffffc0206480 <full_tree_size>
    size_t block = TREE_ROOT;//当前处理的节点索引
ffffffffc0200d56:	4585                	li	a1,1
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200d58:	02bed5b3          	divu	a1,t4,a1
            list_del(&(allocate_area[begin].page_link));
ffffffffc0200d5c:	00005317          	auipc	t1,0x5
ffffffffc0200d60:	71c33303          	ld	t1,1820(t1) # ffffffffc0206478 <allocate_area>
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200d64:	4801                	li	a6,0
ffffffffc0200d66:	4601                	li	a2,0
    size_t block = TREE_ROOT;//当前处理的节点索引
ffffffffc0200d68:	4685                	li	a3,1
    __list_add(elm, listelm, listelm->next);
ffffffffc0200d6a:	00005f17          	auipc	t5,0x5
ffffffffc0200d6e:	2aef0f13          	addi	t5,t5,686 # ffffffffc0206018 <free_area>
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200d72:	06b57e63          	bgeu	a0,a1,ffffffffc0200dee <buddy_allocate_pages+0xe0>
        size_t left = LEFT_CHILD(block);
ffffffffc0200d76:	00169713          	slli	a4,a3,0x1
            record_area[left] = record_area[block] / 2 ;
ffffffffc0200d7a:	00469613          	slli	a2,a3,0x4
        size_t right = RIGHT_CHILD(block);
ffffffffc0200d7e:	00170293          	addi	t0,a4,1
            record_area[left] = record_area[block] / 2 ;
ffffffffc0200d82:	00c88e33          	add	t3,a7,a2
        if (BUDDY_EMPTY(block))//如果当前节点为空
ffffffffc0200d86:	0af58f63          	beq	a1,a5,ffffffffc0200e44 <buddy_allocate_pages+0x136>
        else if (length & record_area[left])
ffffffffc0200d8a:	000e3783          	ld	a5,0(t3)
ffffffffc0200d8e:	00a7f5b3          	and	a1,a5,a0
ffffffffc0200d92:	12059163          	bnez	a1,ffffffffc0200eb4 <buddy_allocate_pages+0x1a6>
        else if (length & record_area[right])
ffffffffc0200d96:	0621                	addi	a2,a2,8
ffffffffc0200d98:	9646                	add	a2,a2,a7
ffffffffc0200d9a:	620c                	ld	a1,0(a2)
ffffffffc0200d9c:	00a5f833          	and	a6,a1,a0
ffffffffc0200da0:	10081e63          	bnez	a6,ffffffffc0200ebc <buddy_allocate_pages+0x1ae>
        else if (length <= record_area[left])
ffffffffc0200da4:	00a7f763          	bgeu	a5,a0,ffffffffc0200db2 <buddy_allocate_pages+0xa4>
        else if (length <= record_area[right])
ffffffffc0200da8:	12a5e963          	bltu	a1,a0,ffffffffc0200eda <buddy_allocate_pages+0x1cc>
ffffffffc0200dac:	87ae                	mv	a5,a1
ffffffffc0200dae:	8e32                	mv	t3,a2
            block = right;
ffffffffc0200db0:	8716                	mv	a4,t0
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200db2:	00175613          	srli	a2,a4,0x1
ffffffffc0200db6:	8e59                	or	a2,a2,a4
ffffffffc0200db8:	00265693          	srli	a3,a2,0x2
ffffffffc0200dbc:	8e55                	or	a2,a2,a3
ffffffffc0200dbe:	00465693          	srli	a3,a2,0x4
ffffffffc0200dc2:	8ed1                	or	a3,a3,a2
ffffffffc0200dc4:	0086d613          	srli	a2,a3,0x8
ffffffffc0200dc8:	8ed1                	or	a3,a3,a2
ffffffffc0200dca:	0106d613          	srli	a2,a3,0x10
ffffffffc0200dce:	8e55                	or	a2,a2,a3
ffffffffc0200dd0:	8205                	srli	a2,a2,0x1
ffffffffc0200dd2:	00e67833          	and	a6,a2,a4
ffffffffc0200dd6:	85ba                	mv	a1,a4
ffffffffc0200dd8:	00080563          	beqz	a6,ffffffffc0200de2 <buddy_allocate_pages+0xd4>
ffffffffc0200ddc:	fff64593          	not	a1,a2
ffffffffc0200de0:	8df9                	and	a1,a1,a4
ffffffffc0200de2:	02bed5b3          	divu	a1,t4,a1
ffffffffc0200de6:	8ff2                	mv	t6,t3
ffffffffc0200de8:	86ba                	mv	a3,a4
ffffffffc0200dea:	f8b566e3          	bltu	a0,a1,ffffffffc0200d76 <buddy_allocate_pages+0x68>
    page = &(allocate_area[NODE_BEGINNING(block)]);//获取当前节点对应的物理页指针
ffffffffc0200dee:	0e081263          	bnez	a6,ffffffffc0200ed2 <buddy_allocate_pages+0x1c4>
ffffffffc0200df2:	8636                	mv	a2,a3
ffffffffc0200df4:	02ced633          	divu	a2,t4,a2
    nr_free -= length;//更新空闲页计数器，减少分配出去的页数
ffffffffc0200df8:	00005597          	auipc	a1,0x5
ffffffffc0200dfc:	22058593          	addi	a1,a1,544 # ffffffffc0206018 <free_area>
ffffffffc0200e00:	4998                	lw	a4,16(a1)
    while (block != TREE_ROOT)
ffffffffc0200e02:	4e05                	li	t3,1
    nr_free -= length;//更新空闲页计数器，减少分配出去的页数
ffffffffc0200e04:	9f09                	subw	a4,a4,a0
    page = &(allocate_area[NODE_BEGINNING(block)]);//获取当前节点对应的物理页指针
ffffffffc0200e06:	030607b3          	mul	a5,a2,a6
ffffffffc0200e0a:	00279513          	slli	a0,a5,0x2
ffffffffc0200e0e:	953e                	add	a0,a0,a5
ffffffffc0200e10:	050e                	slli	a0,a0,0x3
ffffffffc0200e12:	951a                	add	a0,a0,t1
    __list_del(listelm->prev, listelm->next);
ffffffffc0200e14:	6d10                	ld	a2,24(a0)
ffffffffc0200e16:	711c                	ld	a5,32(a0)
    prev->next = next;
ffffffffc0200e18:	e61c                	sd	a5,8(a2)
    next->prev = prev;
ffffffffc0200e1a:	e390                	sd	a2,0(a5)
    record_area[block] = 0;//清空当前节点的记录大小
ffffffffc0200e1c:	000fb023          	sd	zero,0(t6)
    nr_free -= length;//更新空闲页计数器，减少分配出去的页数
ffffffffc0200e20:	c998                	sw	a4,16(a1)
    while (block != TREE_ROOT)
ffffffffc0200e22:	0dc68563          	beq	a3,t3,ffffffffc0200eec <buddy_allocate_pages+0x1de>
ffffffffc0200e26:	4585                	li	a1,1
        block = PARENT(block);
ffffffffc0200e28:	8285                	srli	a3,a3,0x1
        record_area[block] = record_area[LEFT_CHILD(block)] | record_area[RIGHT_CHILD(block)];
ffffffffc0200e2a:	00469793          	slli	a5,a3,0x4
ffffffffc0200e2e:	97c6                	add	a5,a5,a7
ffffffffc0200e30:	6390                	ld	a2,0(a5)
ffffffffc0200e32:	6798                	ld	a4,8(a5)
ffffffffc0200e34:	00369793          	slli	a5,a3,0x3
ffffffffc0200e38:	97c6                	add	a5,a5,a7
ffffffffc0200e3a:	8f51                	or	a4,a4,a2
ffffffffc0200e3c:	e398                	sd	a4,0(a5)
    while (block != TREE_ROOT)
ffffffffc0200e3e:	feb695e3          	bne	a3,a1,ffffffffc0200e28 <buddy_allocate_pages+0x11a>
ffffffffc0200e42:	8082                	ret
            size_t begin = NODE_BEGINNING(block);
ffffffffc0200e44:	03078833          	mul	a6,a5,a6
            record_area[left] = record_area[block] / 2 ;
ffffffffc0200e48:	0017d393          	srli	t2,a5,0x1
            list_del(&(allocate_area[begin].page_link));
ffffffffc0200e4c:	00281693          	slli	a3,a6,0x2
ffffffffc0200e50:	96c2                	add	a3,a3,a6
ffffffffc0200e52:	068e                	slli	a3,a3,0x3
ffffffffc0200e54:	969a                	add	a3,a3,t1
            size_t end = NODE_ENDDING(block);
ffffffffc0200e56:	97c2                	add	a5,a5,a6
    __list_del(listelm->prev, listelm->next);
ffffffffc0200e58:	728c                	ld	a1,32(a3)
ffffffffc0200e5a:	0186b283          	ld	t0,24(a3)
            size_t mid = (begin + end) / 2;
ffffffffc0200e5e:	983e                	add	a6,a6,a5
ffffffffc0200e60:	00185813          	srli	a6,a6,0x1
            allocate_area[begin].property /= 2;
ffffffffc0200e64:	4a9c                	lw	a5,16(a3)
            allocate_area[mid].property = allocate_area[begin].property;
ffffffffc0200e66:	00281613          	slli	a2,a6,0x2
    prev->next = next;
ffffffffc0200e6a:	00b2b423          	sd	a1,8(t0)
ffffffffc0200e6e:	9642                	add	a2,a2,a6
    next->prev = prev;
ffffffffc0200e70:	0055b023          	sd	t0,0(a1)
            allocate_area[begin].property /= 2;
ffffffffc0200e74:	0017d79b          	srliw	a5,a5,0x1
            allocate_area[mid].property = allocate_area[begin].property;
ffffffffc0200e78:	060e                	slli	a2,a2,0x3
            allocate_area[begin].property /= 2;
ffffffffc0200e7a:	ca9c                	sw	a5,16(a3)
            allocate_area[mid].property = allocate_area[begin].property;
ffffffffc0200e7c:	961a                	add	a2,a2,t1
ffffffffc0200e7e:	ca1c                	sw	a5,16(a2)
            record_area[left] = record_area[block] / 2 ;
ffffffffc0200e80:	007e3023          	sd	t2,0(t3)
            record_area[right] = record_area[block] / 2;
ffffffffc0200e84:	000fb783          	ld	a5,0(t6)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200e88:	008f3f83          	ld	t6,8(t5)
            list_add(&free_list, &(allocate_area[begin].page_link));
ffffffffc0200e8c:	01868593          	addi	a1,a3,24
            record_area[right] = record_area[block] / 2;
ffffffffc0200e90:	8385                	srli	a5,a5,0x1
ffffffffc0200e92:	00fe3423          	sd	a5,8(t3)
    prev->next = next->prev = elm;
ffffffffc0200e96:	00bfb023          	sd	a1,0(t6)
            list_add(&free_list, &(allocate_area[mid].page_link));
ffffffffc0200e9a:	01860813          	addi	a6,a2,24
    elm->next = next;
ffffffffc0200e9e:	03f6b023          	sd	t6,32(a3)
    prev->next = next->prev = elm;
ffffffffc0200ea2:	0106bc23          	sd	a6,24(a3)
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200ea6:	000e3783          	ld	a5,0(t3)
ffffffffc0200eaa:	010f3423          	sd	a6,8(t5)
    elm->next = next;
ffffffffc0200eae:	f20c                	sd	a1,32(a2)
    elm->prev = prev;
ffffffffc0200eb0:	01e63c23          	sd	t5,24(a2)
ffffffffc0200eb4:	eea7ffe3          	bgeu	a5,a0,ffffffffc0200db2 <buddy_allocate_pages+0xa4>
        return NULL;
ffffffffc0200eb8:	4501                	li	a0,0
ffffffffc0200eba:	8082                	ret
ffffffffc0200ebc:	87ae                	mv	a5,a1
ffffffffc0200ebe:	8e32                	mv	t3,a2
            block = right;
ffffffffc0200ec0:	8716                	mv	a4,t0
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200ec2:	eea7f8e3          	bgeu	a5,a0,ffffffffc0200db2 <buddy_allocate_pages+0xa4>
ffffffffc0200ec6:	bfcd                	j	ffffffffc0200eb8 <buddy_allocate_pages+0x1aa>
    size_t length = POWER_ROUND_UP(n);//请求分配的页数 n 向上取整到最近的 2 的幂次方
ffffffffc0200ec8:	fff7c793          	not	a5,a5
ffffffffc0200ecc:	8d7d                	and	a0,a0,a5
ffffffffc0200ece:	0506                	slli	a0,a0,0x1
ffffffffc0200ed0:	b5ad                	j	ffffffffc0200d3a <buddy_allocate_pages+0x2c>
    page = &(allocate_area[NODE_BEGINNING(block)]);//获取当前节点对应的物理页指针
ffffffffc0200ed2:	fff64613          	not	a2,a2
ffffffffc0200ed6:	8e75                	and	a2,a2,a3
ffffffffc0200ed8:	bf31                	j	ffffffffc0200df4 <buddy_allocate_pages+0xe6>
    while (length <= record_area[block] && length < NODE_LENGTH(block))
ffffffffc0200eda:	00369e13          	slli	t3,a3,0x3
ffffffffc0200ede:	9e46                	add	t3,t3,a7
ffffffffc0200ee0:	000e3783          	ld	a5,0(t3)
ffffffffc0200ee4:	8736                	mv	a4,a3
ffffffffc0200ee6:	eca7f6e3          	bgeu	a5,a0,ffffffffc0200db2 <buddy_allocate_pages+0xa4>
ffffffffc0200eea:	b7f9                	j	ffffffffc0200eb8 <buddy_allocate_pages+0x1aa>
}
ffffffffc0200eec:	8082                	ret
{
ffffffffc0200eee:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200ef0:	00001697          	auipc	a3,0x1
ffffffffc0200ef4:	6c868693          	addi	a3,a3,1736 # ffffffffc02025b8 <commands+0x670>
ffffffffc0200ef8:	00001617          	auipc	a2,0x1
ffffffffc0200efc:	6c860613          	addi	a2,a2,1736 # ffffffffc02025c0 <commands+0x678>
ffffffffc0200f00:	08500593          	li	a1,133
ffffffffc0200f04:	00001517          	auipc	a0,0x1
ffffffffc0200f08:	6d450513          	addi	a0,a0,1748 # ffffffffc02025d8 <commands+0x690>
{
ffffffffc0200f0c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200f0e:	a2cff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200f12 <buddy_init_memmap.part.0>:
    for (p = base; p < base + n; p++)
ffffffffc0200f12:	00259793          	slli	a5,a1,0x2
ffffffffc0200f16:	97ae                	add	a5,a5,a1
static void buddy_init_memmap(struct Page *base, size_t n)
ffffffffc0200f18:	7179                	addi	sp,sp,-48
    for (p = base; p < base + n; p++)
ffffffffc0200f1a:	078e                	slli	a5,a5,0x3
ffffffffc0200f1c:	00f506b3          	add	a3,a0,a5
static void buddy_init_memmap(struct Page *base, size_t n)
ffffffffc0200f20:	f406                	sd	ra,40(sp)
ffffffffc0200f22:	f022                	sd	s0,32(sp)
ffffffffc0200f24:	ec26                	sd	s1,24(sp)
ffffffffc0200f26:	e84a                	sd	s2,16(sp)
ffffffffc0200f28:	e44e                	sd	s3,8(sp)
ffffffffc0200f2a:	882a                	mv	a6,a0
    for (p = base; p < base + n; p++)
ffffffffc0200f2c:	87aa                	mv	a5,a0
ffffffffc0200f2e:	00d57e63          	bgeu	a0,a3,ffffffffc0200f4a <buddy_init_memmap.part.0+0x38>
ffffffffc0200f32:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));//标记为保留状态
ffffffffc0200f34:	8b05                	andi	a4,a4,1
ffffffffc0200f36:	2c070b63          	beqz	a4,ffffffffc020120c <buddy_init_memmap.part.0+0x2fa>
        p->flags = p->property = 0;//清除页的标志和属性字段
ffffffffc0200f3a:	0007a823          	sw	zero,16(a5)
ffffffffc0200f3e:	0007b423          	sd	zero,8(a5)
    for (p = base; p < base + n; p++)
ffffffffc0200f42:	02878793          	addi	a5,a5,40
ffffffffc0200f46:	fed7e6e3          	bltu	a5,a3,ffffffffc0200f32 <buddy_init_memmap.part.0+0x20>
    total_size = n;
ffffffffc0200f4a:	00005797          	auipc	a5,0x5
ffffffffc0200f4e:	54b7bf23          	sd	a1,1374(a5) # ffffffffc02064a8 <total_size>
    if (n < 512)
ffffffffc0200f52:	1ff00793          	li	a5,511
ffffffffc0200f56:	06b7f763          	bgeu	a5,a1,ffffffffc0200fc4 <buddy_init_memmap.part.0+0xb2>
        full_tree_size = POWER_ROUND_DOWN(n);
ffffffffc0200f5a:	0015d793          	srli	a5,a1,0x1
ffffffffc0200f5e:	8fcd                	or	a5,a5,a1
ffffffffc0200f60:	0027d713          	srli	a4,a5,0x2
ffffffffc0200f64:	8fd9                	or	a5,a5,a4
ffffffffc0200f66:	0047d713          	srli	a4,a5,0x4
ffffffffc0200f6a:	8f5d                	or	a4,a4,a5
ffffffffc0200f6c:	00875793          	srli	a5,a4,0x8
ffffffffc0200f70:	8f5d                	or	a4,a4,a5
ffffffffc0200f72:	01075793          	srli	a5,a4,0x10
ffffffffc0200f76:	8fd9                	or	a5,a5,a4
ffffffffc0200f78:	8385                	srli	a5,a5,0x1
ffffffffc0200f7a:	00f5f6b3          	and	a3,a1,a5
ffffffffc0200f7e:	872e                	mv	a4,a1
ffffffffc0200f80:	c689                	beqz	a3,ffffffffc0200f8a <buddy_init_memmap.part.0+0x78>
ffffffffc0200f82:	fff7c793          	not	a5,a5
ffffffffc0200f86:	00b7f733          	and	a4,a5,a1
        record_area_size = full_tree_size * sizeof(size_t) * 2 / PGSIZE;
ffffffffc0200f8a:	00471613          	slli	a2,a4,0x4
ffffffffc0200f8e:	8231                	srli	a2,a2,0xc
        full_tree_size = POWER_ROUND_DOWN(n);
ffffffffc0200f90:	00005497          	auipc	s1,0x5
ffffffffc0200f94:	4f048493          	addi	s1,s1,1264 # ffffffffc0206480 <full_tree_size>
        record_area_size = full_tree_size * sizeof(size_t) * 2 / PGSIZE;
ffffffffc0200f98:	00005697          	auipc	a3,0x5
ffffffffc0200f9c:	50868693          	addi	a3,a3,1288 # ffffffffc02064a0 <record_area_size>
        if (n > full_tree_size + (record_area_size << 1))
ffffffffc0200fa0:	00161793          	slli	a5,a2,0x1
        full_tree_size = POWER_ROUND_DOWN(n);
ffffffffc0200fa4:	e098                	sd	a4,0(s1)
        record_area_size = full_tree_size * sizeof(size_t) * 2 / PGSIZE;
ffffffffc0200fa6:	e290                	sd	a2,0(a3)
        if (n > full_tree_size + (record_area_size << 1))
ffffffffc0200fa8:	00f70533          	add	a0,a4,a5
ffffffffc0200fac:	20b56e63          	bltu	a0,a1,ffffffffc02011c8 <buddy_init_memmap.part.0+0x2b6>
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc0200fb0:	40c586b3          	sub	a3,a1,a2
ffffffffc0200fb4:	24d76263          	bltu	a4,a3,ffffffffc02011f8 <buddy_init_memmap.part.0+0x2e6>
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc0200fb8:	00261713          	slli	a4,a2,0x2
ffffffffc0200fbc:	9732                	add	a4,a4,a2
ffffffffc0200fbe:	070e                	slli	a4,a4,0x3
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc0200fc0:	0632                	slli	a2,a2,0xc
ffffffffc0200fc2:	a881                	j	ffffffffc0201012 <buddy_init_memmap.part.0+0x100>
        full_tree_size = POWER_ROUND_UP(n - 1);
ffffffffc0200fc4:	15fd                	addi	a1,a1,-1
ffffffffc0200fc6:	0015d713          	srli	a4,a1,0x1
ffffffffc0200fca:	00b767b3          	or	a5,a4,a1
ffffffffc0200fce:	0027d713          	srli	a4,a5,0x2
ffffffffc0200fd2:	8f5d                	or	a4,a4,a5
ffffffffc0200fd4:	00475793          	srli	a5,a4,0x4
ffffffffc0200fd8:	8f5d                	or	a4,a4,a5
ffffffffc0200fda:	00875793          	srli	a5,a4,0x8
ffffffffc0200fde:	8fd9                	or	a5,a5,a4
ffffffffc0200fe0:	8385                	srli	a5,a5,0x1
ffffffffc0200fe2:	00f5f733          	and	a4,a1,a5
ffffffffc0200fe6:	86ae                	mv	a3,a1
ffffffffc0200fe8:	cb01                	beqz	a4,ffffffffc0200ff8 <buddy_init_memmap.part.0+0xe6>
ffffffffc0200fea:	fff7c793          	not	a5,a5
ffffffffc0200fee:	8fed                	and	a5,a5,a1
ffffffffc0200ff0:	00179593          	slli	a1,a5,0x1
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc0200ff4:	20d5e063          	bltu	a1,a3,ffffffffc02011f4 <buddy_init_memmap.part.0+0x2e2>
        record_area_size = 1;
ffffffffc0200ff8:	4785                	li	a5,1
        full_tree_size = POWER_ROUND_UP(n - 1);
ffffffffc0200ffa:	00005497          	auipc	s1,0x5
ffffffffc0200ffe:	48648493          	addi	s1,s1,1158 # ffffffffc0206480 <full_tree_size>
        record_area_size = 1;
ffffffffc0201002:	00005717          	auipc	a4,0x5
ffffffffc0201006:	48f73f23          	sd	a5,1182(a4) # ffffffffc02064a0 <record_area_size>
        full_tree_size = POWER_ROUND_UP(n - 1);
ffffffffc020100a:	e08c                	sd	a1,0(s1)
        record_area_size = 1;
ffffffffc020100c:	6605                	lui	a2,0x1
ffffffffc020100e:	02800713          	li	a4,40
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201012:	00005797          	auipc	a5,0x5
ffffffffc0201016:	43e7b783          	ld	a5,1086(a5) # ffffffffc0206450 <pages>
ffffffffc020101a:	40f807b3          	sub	a5,a6,a5
ffffffffc020101e:	00002597          	auipc	a1,0x2
ffffffffc0201022:	ada5b583          	ld	a1,-1318(a1) # ffffffffc0202af8 <nbase+0x8>
ffffffffc0201026:	878d                	srai	a5,a5,0x3
ffffffffc0201028:	02b787b3          	mul	a5,a5,a1
ffffffffc020102c:	00002517          	auipc	a0,0x2
ffffffffc0201030:	ac453503          	ld	a0,-1340(a0) # ffffffffc0202af0 <nbase>
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc0201034:	9742                	add	a4,a4,a6
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc0201036:	00005997          	auipc	s3,0x5
ffffffffc020103a:	45a98993          	addi	s3,s3,1114 # ffffffffc0206490 <real_tree_size>
    record_area = KADDR(page2pa(base));//记录区域的基地址，获得物理地址对应的虚拟地址。
ffffffffc020103e:	00005417          	auipc	s0,0x5
ffffffffc0201042:	45a40413          	addi	s0,s0,1114 # ffffffffc0206498 <record_area>
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc0201046:	4581                	li	a1,0
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc0201048:	00005917          	auipc	s2,0x5
ffffffffc020104c:	43090913          	addi	s2,s2,1072 # ffffffffc0206478 <allocate_area>
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc0201050:	00d9b023          	sd	a3,0(s3)
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc0201054:	00e93023          	sd	a4,0(s2)
ffffffffc0201058:	97aa                	add	a5,a5,a0
    record_area = KADDR(page2pa(base));//记录区域的基地址，获得物理地址对应的虚拟地址。
ffffffffc020105a:	5575                	li	a0,-3
    return page2ppn(page) << PGSHIFT;
ffffffffc020105c:	07b2                	slli	a5,a5,0xc
ffffffffc020105e:	057a                	slli	a0,a0,0x1e
ffffffffc0201060:	953e                	add	a0,a0,a5
ffffffffc0201062:	e008                	sd	a0,0(s0)
    physical_area = base;//物理内存的基地址
ffffffffc0201064:	00005797          	auipc	a5,0x5
ffffffffc0201068:	4307b223          	sd	a6,1060(a5) # ffffffffc0206488 <physical_area>
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc020106c:	746000ef          	jal	ra,ffffffffc02017b2 <memset>
    nr_free += real_tree_size;//更新自由页计数器
ffffffffc0201070:	00005897          	auipc	a7,0x5
ffffffffc0201074:	fa888893          	addi	a7,a7,-88 # ffffffffc0206018 <free_area>
ffffffffc0201078:	0009b683          	ld	a3,0(s3)
ffffffffc020107c:	0108a783          	lw	a5,16(a7)
    record_area[block] = real_subtree_size;
ffffffffc0201080:	6010                	ld	a2,0(s0)
    size_t full_subtree_size = full_tree_size;//当前处理的子树的满二叉树大小
ffffffffc0201082:	6098                	ld	a4,0(s1)
    nr_free += real_tree_size;//更新自由页计数器
ffffffffc0201084:	9fb5                	addw	a5,a5,a3
ffffffffc0201086:	00f8a823          	sw	a5,16(a7)
    record_area[block] = real_subtree_size;
ffffffffc020108a:	e614                	sd	a3,8(a2)
    nr_free += real_tree_size;//更新自由页计数器
ffffffffc020108c:	0006859b          	sext.w	a1,a3
    while (real_subtree_size > 0 && real_subtree_size < full_subtree_size)
ffffffffc0201090:	10068a63          	beqz	a3,ffffffffc02011a4 <buddy_init_memmap.part.0+0x292>
ffffffffc0201094:	16e6f963          	bgeu	a3,a4,ffffffffc0201206 <buddy_init_memmap.part.0+0x2f4>
    size_t block = TREE_ROOT;//当前处理的节点索引
ffffffffc0201098:	4785                	li	a5,1
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020109a:	4309                	li	t1,2
            record_area[LEFT_CHILD(block)] = full_subtree_size;//设置左子节点的大小
ffffffffc020109c:	00479613          	slli	a2,a5,0x4
        full_subtree_size >>= 1;//将子树大小分成一半
ffffffffc02010a0:	8305                	srli	a4,a4,0x1
            record_area[RIGHT_CHILD(block)] = real_subtree_size;//设置右子节点的大小
ffffffffc02010a2:	00860e93          	addi	t4,a2,8 # 1008 <kern_entry-0xffffffffc01feff8>
            block = RIGHT_CHILD(block);//将当前节点设置为右子节点，以便继续处理
ffffffffc02010a6:	00179e13          	slli	t3,a5,0x1
        if (real_subtree_size > full_subtree_size)
ffffffffc02010aa:	10d77463          	bgeu	a4,a3,ffffffffc02011b2 <buddy_init_memmap.part.0+0x2a0>
            struct Page *page = &allocate_area[NODE_BEGINNING(block)];
ffffffffc02010ae:	0017d513          	srli	a0,a5,0x1
ffffffffc02010b2:	8d5d                	or	a0,a0,a5
ffffffffc02010b4:	00255813          	srli	a6,a0,0x2
ffffffffc02010b8:	00a86533          	or	a0,a6,a0
ffffffffc02010bc:	00455813          	srli	a6,a0,0x4
ffffffffc02010c0:	00a86833          	or	a6,a6,a0
ffffffffc02010c4:	00885513          	srli	a0,a6,0x8
ffffffffc02010c8:	01056833          	or	a6,a0,a6
ffffffffc02010cc:	01085513          	srli	a0,a6,0x10
ffffffffc02010d0:	01056533          	or	a0,a0,a6
ffffffffc02010d4:	8105                	srli	a0,a0,0x1
ffffffffc02010d6:	00f57f33          	and	t5,a0,a5
ffffffffc02010da:	00093583          	ld	a1,0(s2)
ffffffffc02010de:	0004b803          	ld	a6,0(s1)
ffffffffc02010e2:	000f0563          	beqz	t5,ffffffffc02010ec <buddy_init_memmap.part.0+0x1da>
ffffffffc02010e6:	fff54513          	not	a0,a0
ffffffffc02010ea:	8fe9                	and	a5,a5,a0
ffffffffc02010ec:	02f857b3          	divu	a5,a6,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02010f0:	0088b803          	ld	a6,8(a7)
ffffffffc02010f4:	03e787b3          	mul	a5,a5,t5
ffffffffc02010f8:	00279513          	slli	a0,a5,0x2
ffffffffc02010fc:	97aa                	add	a5,a5,a0
ffffffffc02010fe:	078e                	slli	a5,a5,0x3
ffffffffc0201100:	97ae                	add	a5,a5,a1
            list_add(&(free_list), &(page->page_link));
ffffffffc0201102:	01878593          	addi	a1,a5,24
            page->property = full_subtree_size;
ffffffffc0201106:	cb98                	sw	a4,16(a5)
    prev->next = next->prev = elm;
ffffffffc0201108:	00b83023          	sd	a1,0(a6)
ffffffffc020110c:	00b8b423          	sd	a1,8(a7)
    elm->next = next;
ffffffffc0201110:	0307b023          	sd	a6,32(a5)
    elm->prev = prev;
ffffffffc0201114:	0117bc23          	sd	a7,24(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201118:	0007a023          	sw	zero,0(a5)
ffffffffc020111c:	07a1                	addi	a5,a5,8
ffffffffc020111e:	4067b02f          	amoor.d	zero,t1,(a5)
            record_area[LEFT_CHILD(block)] = full_subtree_size;//设置左子节点的大小
ffffffffc0201122:	600c                	ld	a1,0(s0)
            real_subtree_size -= full_subtree_size;//减去已分配的大小
ffffffffc0201124:	8e99                	sub	a3,a3,a4
            block = RIGHT_CHILD(block);//将当前节点设置为右子节点，以便继续处理
ffffffffc0201126:	001e0793          	addi	a5,t3,1
            record_area[LEFT_CHILD(block)] = full_subtree_size;//设置左子节点的大小
ffffffffc020112a:	962e                	add	a2,a2,a1
ffffffffc020112c:	e218                	sd	a4,0(a2)
            record_area[RIGHT_CHILD(block)] = real_subtree_size;//设置右子节点的大小
ffffffffc020112e:	95f6                	add	a1,a1,t4
ffffffffc0201130:	e194                	sd	a3,0(a1)
    while (real_subtree_size > 0 && real_subtree_size < full_subtree_size)
ffffffffc0201132:	f6e6e5e3          	bltu	a3,a4,ffffffffc020109c <buddy_init_memmap.part.0+0x18a>
        struct Page *page = &allocate_area[NODE_BEGINNING(block)];
ffffffffc0201136:	0017d613          	srli	a2,a5,0x1
ffffffffc020113a:	8e5d                	or	a2,a2,a5
ffffffffc020113c:	00265713          	srli	a4,a2,0x2
ffffffffc0201140:	8e59                	or	a2,a2,a4
ffffffffc0201142:	00465713          	srli	a4,a2,0x4
ffffffffc0201146:	8f51                	or	a4,a4,a2
ffffffffc0201148:	00875613          	srli	a2,a4,0x8
ffffffffc020114c:	8f51                	or	a4,a4,a2
ffffffffc020114e:	01075613          	srli	a2,a4,0x10
ffffffffc0201152:	8e59                	or	a2,a2,a4
ffffffffc0201154:	8205                	srli	a2,a2,0x1
ffffffffc0201156:	00f67833          	and	a6,a2,a5
ffffffffc020115a:	00093703          	ld	a4,0(s2)
ffffffffc020115e:	6088                	ld	a0,0(s1)
        page->property = real_subtree_size;
ffffffffc0201160:	0006859b          	sext.w	a1,a3
        struct Page *page = &allocate_area[NODE_BEGINNING(block)];
ffffffffc0201164:	00080e63          	beqz	a6,ffffffffc0201180 <buddy_init_memmap.part.0+0x26e>
ffffffffc0201168:	fff64613          	not	a2,a2
ffffffffc020116c:	8ff1                	and	a5,a5,a2
ffffffffc020116e:	02f557b3          	divu	a5,a0,a5
ffffffffc0201172:	030787b3          	mul	a5,a5,a6
ffffffffc0201176:	00279693          	slli	a3,a5,0x2
ffffffffc020117a:	97b6                	add	a5,a5,a3
ffffffffc020117c:	078e                	slli	a5,a5,0x3
ffffffffc020117e:	973e                	add	a4,a4,a5
        page->property = real_subtree_size;
ffffffffc0201180:	cb0c                	sw	a1,16(a4)
ffffffffc0201182:	00072023          	sw	zero,0(a4)
ffffffffc0201186:	4789                	li	a5,2
ffffffffc0201188:	00870693          	addi	a3,a4,8
ffffffffc020118c:	40f6b02f          	amoor.d	zero,a5,(a3)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201190:	0088b783          	ld	a5,8(a7)
        list_add(&(free_list), &(page->page_link));
ffffffffc0201194:	01870693          	addi	a3,a4,24
    prev->next = next->prev = elm;
ffffffffc0201198:	e394                	sd	a3,0(a5)
ffffffffc020119a:	00d8b423          	sd	a3,8(a7)
    elm->next = next;
ffffffffc020119e:	f31c                	sd	a5,32(a4)
    elm->prev = prev;
ffffffffc02011a0:	01173c23          	sd	a7,24(a4)
}
ffffffffc02011a4:	70a2                	ld	ra,40(sp)
ffffffffc02011a6:	7402                	ld	s0,32(sp)
ffffffffc02011a8:	64e2                	ld	s1,24(sp)
ffffffffc02011aa:	6942                	ld	s2,16(sp)
ffffffffc02011ac:	69a2                	ld	s3,8(sp)
ffffffffc02011ae:	6145                	addi	sp,sp,48
ffffffffc02011b0:	8082                	ret
            record_area[LEFT_CHILD(block)] = real_subtree_size;
ffffffffc02011b2:	601c                	ld	a5,0(s0)
ffffffffc02011b4:	963e                	add	a2,a2,a5
ffffffffc02011b6:	e214                	sd	a3,0(a2)
            record_area[RIGHT_CHILD(block)] = 0;
ffffffffc02011b8:	97f6                	add	a5,a5,t4
ffffffffc02011ba:	0007b023          	sd	zero,0(a5)
    while (real_subtree_size > 0 && real_subtree_size < full_subtree_size)
ffffffffc02011be:	d2fd                	beqz	a3,ffffffffc02011a4 <buddy_init_memmap.part.0+0x292>
            block = LEFT_CHILD(block);
ffffffffc02011c0:	87f2                	mv	a5,t3
    while (real_subtree_size > 0 && real_subtree_size < full_subtree_size)
ffffffffc02011c2:	ece6ede3          	bltu	a3,a4,ffffffffc020109c <buddy_init_memmap.part.0+0x18a>
ffffffffc02011c6:	bf85                	j	ffffffffc0201136 <buddy_init_memmap.part.0+0x224>
            full_tree_size <<= 1;
ffffffffc02011c8:	0706                	slli	a4,a4,0x1
            record_area_size <<= 1;
ffffffffc02011ca:	e29c                	sd	a5,0(a3)
            full_tree_size <<= 1;
ffffffffc02011cc:	e098                	sd	a4,0(s1)
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc02011ce:	40f586b3          	sub	a3,a1,a5
ffffffffc02011d2:	00d76963          	bltu	a4,a3,ffffffffc02011e4 <buddy_init_memmap.part.0+0x2d2>
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc02011d6:	00279713          	slli	a4,a5,0x2
ffffffffc02011da:	973e                	add	a4,a4,a5
ffffffffc02011dc:	070e                	slli	a4,a4,0x3
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc02011de:	00c79613          	slli	a2,a5,0xc
ffffffffc02011e2:	bd05                	j	ffffffffc0201012 <buddy_init_memmap.part.0+0x100>
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc02011e4:	86ba                	mv	a3,a4
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc02011e6:	00279713          	slli	a4,a5,0x2
ffffffffc02011ea:	973e                	add	a4,a4,a5
ffffffffc02011ec:	070e                	slli	a4,a4,0x3
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc02011ee:	00c79613          	slli	a2,a5,0xc
ffffffffc02011f2:	b505                	j	ffffffffc0201012 <buddy_init_memmap.part.0+0x100>
    real_tree_size = (full_tree_size < total_size - record_area_size) ? full_tree_size : total_size - record_area_size;
ffffffffc02011f4:	86ae                	mv	a3,a1
ffffffffc02011f6:	b509                	j	ffffffffc0200ff8 <buddy_init_memmap.part.0+0xe6>
ffffffffc02011f8:	86ba                	mv	a3,a4
    allocate_area = base + record_area_size;// 可分配内存的基地址
ffffffffc02011fa:	00261713          	slli	a4,a2,0x2
ffffffffc02011fe:	9732                	add	a4,a4,a2
ffffffffc0201200:	070e                	slli	a4,a4,0x3
    memset(record_area, 0, record_area_size * PGSIZE);//清零记录区域的内容
ffffffffc0201202:	0632                	slli	a2,a2,0xc
ffffffffc0201204:	b539                	j	ffffffffc0201012 <buddy_init_memmap.part.0+0x100>
        struct Page *page = &allocate_area[NODE_BEGINNING(block)];
ffffffffc0201206:	00093703          	ld	a4,0(s2)
ffffffffc020120a:	bf9d                	j	ffffffffc0201180 <buddy_init_memmap.part.0+0x26e>
        assert(PageReserved(p));//标记为保留状态
ffffffffc020120c:	00001697          	auipc	a3,0x1
ffffffffc0201210:	3fc68693          	addi	a3,a3,1020 # ffffffffc0202608 <commands+0x6c0>
ffffffffc0201214:	00001617          	auipc	a2,0x1
ffffffffc0201218:	3ac60613          	addi	a2,a2,940 # ffffffffc02025c0 <commands+0x678>
ffffffffc020121c:	03300593          	li	a1,51
ffffffffc0201220:	00001517          	auipc	a0,0x1
ffffffffc0201224:	3b850513          	addi	a0,a0,952 # ffffffffc02025d8 <commands+0x690>
ffffffffc0201228:	f13fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc020122c <buddy_init_memmap>:
    assert(n > 0);
ffffffffc020122c:	c191                	beqz	a1,ffffffffc0201230 <buddy_init_memmap+0x4>
ffffffffc020122e:	b1d5                	j	ffffffffc0200f12 <buddy_init_memmap.part.0>
{
ffffffffc0201230:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201232:	00001697          	auipc	a3,0x1
ffffffffc0201236:	38668693          	addi	a3,a3,902 # ffffffffc02025b8 <commands+0x670>
ffffffffc020123a:	00001617          	auipc	a2,0x1
ffffffffc020123e:	38660613          	addi	a2,a2,902 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201242:	02f00593          	li	a1,47
ffffffffc0201246:	00001517          	auipc	a0,0x1
ffffffffc020124a:	39250513          	addi	a0,a0,914 # ffffffffc02025d8 <commands+0x690>
{
ffffffffc020124e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201250:	eebfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201254 <alloc_check>:

static void alloc_check(void)
{
ffffffffc0201254:	715d                	addi	sp,sp,-80
ffffffffc0201256:	f84a                	sd	s2,48(sp)
    size_t total_size_store = total_size;
    struct Page *p;
    for (p = physical_area; p < physical_area + 1026; p++)
ffffffffc0201258:	00005917          	auipc	s2,0x5
ffffffffc020125c:	23090913          	addi	s2,s2,560 # ffffffffc0206488 <physical_area>
ffffffffc0201260:	00093783          	ld	a5,0(s2)
ffffffffc0201264:	66a9                	lui	a3,0xa
{
ffffffffc0201266:	f44e                	sd	s3,40(sp)
ffffffffc0201268:	e486                	sd	ra,72(sp)
ffffffffc020126a:	e0a2                	sd	s0,64(sp)
ffffffffc020126c:	fc26                	sd	s1,56(sp)
ffffffffc020126e:	f052                	sd	s4,32(sp)
ffffffffc0201270:	ec56                	sd	s5,24(sp)
ffffffffc0201272:	e85a                	sd	s6,16(sp)
ffffffffc0201274:	e45e                	sd	s7,8(sp)
    size_t total_size_store = total_size;
ffffffffc0201276:	00005997          	auipc	s3,0x5
ffffffffc020127a:	2329b983          	ld	s3,562(s3) # ffffffffc02064a8 <total_size>
ffffffffc020127e:	4605                	li	a2,1
    for (p = physical_area; p < physical_area + 1026; p++)
ffffffffc0201280:	05068693          	addi	a3,a3,80 # a050 <kern_entry-0xffffffffc01f5fb0>
ffffffffc0201284:	00878713          	addi	a4,a5,8
ffffffffc0201288:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc020128c:	00093503          	ld	a0,0(s2)
ffffffffc0201290:	02878793          	addi	a5,a5,40
ffffffffc0201294:	00d50733          	add	a4,a0,a3
ffffffffc0201298:	fee7e6e3          	bltu	a5,a4,ffffffffc0201284 <alloc_check+0x30>
    elm->prev = elm->next = elm;
ffffffffc020129c:	00005497          	auipc	s1,0x5
ffffffffc02012a0:	d7c48493          	addi	s1,s1,-644 # ffffffffc0206018 <free_area>
ffffffffc02012a4:	40200593          	li	a1,1026
ffffffffc02012a8:	e484                	sd	s1,8(s1)
ffffffffc02012aa:	e084                	sd	s1,0(s1)
    nr_free = 0;
ffffffffc02012ac:	00005797          	auipc	a5,0x5
ffffffffc02012b0:	d607ae23          	sw	zero,-644(a5) # ffffffffc0206028 <free_area+0x10>
    assert(n > 0);
ffffffffc02012b4:	c5fff0ef          	jal	ra,ffffffffc0200f12 <buddy_init_memmap.part.0>
    buddy_init();
    buddy_init_memmap(physical_area, 1026);

    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012b8:	4505                	li	a0,1
ffffffffc02012ba:	df4ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02012be:	8a2a                	mv	s4,a0
ffffffffc02012c0:	34050163          	beqz	a0,ffffffffc0201602 <alloc_check+0x3ae>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012c4:	4505                	li	a0,1
ffffffffc02012c6:	de8ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02012ca:	8b2a                	mv	s6,a0
ffffffffc02012cc:	30050b63          	beqz	a0,ffffffffc02015e2 <alloc_check+0x38e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012d0:	4505                	li	a0,1
ffffffffc02012d2:	ddcff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02012d6:	8aaa                	mv	s5,a0
ffffffffc02012d8:	2e050563          	beqz	a0,ffffffffc02015c2 <alloc_check+0x36e>
    assert((p3 = alloc_page()) != NULL);
ffffffffc02012dc:	4505                	li	a0,1
ffffffffc02012de:	dd0ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02012e2:	8baa                	mv	s7,a0
ffffffffc02012e4:	2a050f63          	beqz	a0,ffffffffc02015a2 <alloc_check+0x34e>

    assert(p0 + 1 == p1);
ffffffffc02012e8:	028a0793          	addi	a5,s4,40
ffffffffc02012ec:	34fb1b63          	bne	s6,a5,ffffffffc0201642 <alloc_check+0x3ee>
    assert(p1 + 1 == p2);
ffffffffc02012f0:	050a0793          	addi	a5,s4,80
ffffffffc02012f4:	32fa9763          	bne	s5,a5,ffffffffc0201622 <alloc_check+0x3ce>
    assert(p2 + 1 == p3);
ffffffffc02012f8:	078a0793          	addi	a5,s4,120
ffffffffc02012fc:	38f51363          	bne	a0,a5,ffffffffc0201682 <alloc_check+0x42e>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
ffffffffc0201300:	000a2783          	lw	a5,0(s4)
ffffffffc0201304:	18079f63          	bnez	a5,ffffffffc02014a2 <alloc_check+0x24e>
ffffffffc0201308:	000b2783          	lw	a5,0(s6)
ffffffffc020130c:	18079b63          	bnez	a5,ffffffffc02014a2 <alloc_check+0x24e>
ffffffffc0201310:	000aa783          	lw	a5,0(s5)
ffffffffc0201314:	18079763          	bnez	a5,ffffffffc02014a2 <alloc_check+0x24e>
ffffffffc0201318:	411c                	lw	a5,0(a0)
ffffffffc020131a:	18079463          	bnez	a5,ffffffffc02014a2 <alloc_check+0x24e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020131e:	00005797          	auipc	a5,0x5
ffffffffc0201322:	1327b783          	ld	a5,306(a5) # ffffffffc0206450 <pages>
ffffffffc0201326:	40fa0733          	sub	a4,s4,a5
ffffffffc020132a:	870d                	srai	a4,a4,0x3
ffffffffc020132c:	00001597          	auipc	a1,0x1
ffffffffc0201330:	7cc5b583          	ld	a1,1996(a1) # ffffffffc0202af8 <nbase+0x8>
ffffffffc0201334:	02b70733          	mul	a4,a4,a1
ffffffffc0201338:	00001617          	auipc	a2,0x1
ffffffffc020133c:	7b863603          	ld	a2,1976(a2) # ffffffffc0202af0 <nbase>

    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201340:	00005697          	auipc	a3,0x5
ffffffffc0201344:	1086b683          	ld	a3,264(a3) # ffffffffc0206448 <npage>
ffffffffc0201348:	06b2                	slli	a3,a3,0xc
ffffffffc020134a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020134c:	0732                	slli	a4,a4,0xc
ffffffffc020134e:	3cd77a63          	bgeu	a4,a3,ffffffffc0201722 <alloc_check+0x4ce>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201352:	40fb0733          	sub	a4,s6,a5
ffffffffc0201356:	870d                	srai	a4,a4,0x3
ffffffffc0201358:	02b70733          	mul	a4,a4,a1
ffffffffc020135c:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020135e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201360:	18d77163          	bgeu	a4,a3,ffffffffc02014e2 <alloc_check+0x28e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201364:	40fa8733          	sub	a4,s5,a5
ffffffffc0201368:	870d                	srai	a4,a4,0x3
ffffffffc020136a:	02b70733          	mul	a4,a4,a1
ffffffffc020136e:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201370:	0732                	slli	a4,a4,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201372:	20d77863          	bgeu	a4,a3,ffffffffc0201582 <alloc_check+0x32e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201376:	40f507b3          	sub	a5,a0,a5
ffffffffc020137a:	878d                	srai	a5,a5,0x3
ffffffffc020137c:	02b787b3          	mul	a5,a5,a1
    assert(page2pa(p3) < npage * PGSIZE);

    list_entry_t *le = &free_list;
ffffffffc0201380:	00005417          	auipc	s0,0x5
ffffffffc0201384:	c9840413          	addi	s0,s0,-872 # ffffffffc0206018 <free_area>
ffffffffc0201388:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020138a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p3) < npage * PGSIZE);
ffffffffc020138c:	00d7e963          	bltu	a5,a3,ffffffffc020139e <alloc_check+0x14a>
ffffffffc0201390:	aa49                	j	ffffffffc0201522 <alloc_check+0x2ce>
    while ((le = list_next(le)) != &free_list)
    {
        p = le2page(le, page_link);
        assert(buddy_allocate_pages(p->property) != NULL);
ffffffffc0201392:	ff846503          	lwu	a0,-8(s0)
ffffffffc0201396:	979ff0ef          	jal	ra,ffffffffc0200d0e <buddy_allocate_pages>
ffffffffc020139a:	0e050463          	beqz	a0,ffffffffc0201482 <alloc_check+0x22e>
    return listelm->next;
ffffffffc020139e:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != &free_list)
ffffffffc02013a0:	fe9419e3          	bne	s0,s1,ffffffffc0201392 <alloc_check+0x13e>
    }

    assert(alloc_page() == NULL);
ffffffffc02013a4:	4505                	li	a0,1
ffffffffc02013a6:	d08ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02013aa:	2a051c63          	bnez	a0,ffffffffc0201662 <alloc_check+0x40e>

    free_page(p0);
ffffffffc02013ae:	4585                	li	a1,1
ffffffffc02013b0:	8552                	mv	a0,s4
ffffffffc02013b2:	d3aff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p1);
ffffffffc02013b6:	4585                	li	a1,1
ffffffffc02013b8:	855a                	mv	a0,s6
ffffffffc02013ba:	d32ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p2);
ffffffffc02013be:	4585                	li	a1,1
ffffffffc02013c0:	8556                	mv	a0,s5
ffffffffc02013c2:	d2aff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    assert(nr_free == 3);
ffffffffc02013c6:	4818                	lw	a4,16(s0)
ffffffffc02013c8:	478d                	li	a5,3
ffffffffc02013ca:	16f71c63          	bne	a4,a5,ffffffffc0201542 <alloc_check+0x2ee>

    assert((p1 = alloc_page()) != NULL);
ffffffffc02013ce:	4505                	li	a0,1
ffffffffc02013d0:	cdeff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02013d4:	8a2a                	mv	s4,a0
ffffffffc02013d6:	30050663          	beqz	a0,ffffffffc02016e2 <alloc_check+0x48e>
    assert((p0 = alloc_pages(2)) != NULL);
ffffffffc02013da:	4509                	li	a0,2
ffffffffc02013dc:	cd2ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02013e0:	842a                	mv	s0,a0
ffffffffc02013e2:	2e050063          	beqz	a0,ffffffffc02016c2 <alloc_check+0x46e>
    assert(p0 + 2 == p1);
ffffffffc02013e6:	05050793          	addi	a5,a0,80
ffffffffc02013ea:	2afa1c63          	bne	s4,a5,ffffffffc02016a2 <alloc_check+0x44e>

    assert(alloc_page() == NULL);
ffffffffc02013ee:	4505                	li	a0,1
ffffffffc02013f0:	cbeff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc02013f4:	34051763          	bnez	a0,ffffffffc0201742 <alloc_check+0x4ee>

    free_pages(p0, 2);
ffffffffc02013f8:	4589                	li	a1,2
ffffffffc02013fa:	8522                	mv	a0,s0
ffffffffc02013fc:	cf0ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p1);
ffffffffc0201400:	4585                	li	a1,1
ffffffffc0201402:	8552                	mv	a0,s4
ffffffffc0201404:	ce8ff0ef          	jal	ra,ffffffffc02008ec <free_pages>
    free_page(p3);
ffffffffc0201408:	855e                	mv	a0,s7
ffffffffc020140a:	4585                	li	a1,1
ffffffffc020140c:	ce0ff0ef          	jal	ra,ffffffffc02008ec <free_pages>

    assert((p = alloc_pages(4)) == p0);
ffffffffc0201410:	4511                	li	a0,4
ffffffffc0201412:	c9cff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0201416:	14a41663          	bne	s0,a0,ffffffffc0201562 <alloc_check+0x30e>
    assert(alloc_page() == NULL);
ffffffffc020141a:	4505                	li	a0,1
ffffffffc020141c:	c92ff0ef          	jal	ra,ffffffffc02008ae <alloc_pages>
ffffffffc0201420:	2e051163          	bnez	a0,ffffffffc0201702 <alloc_check+0x4ae>

    assert(nr_free == 0);
ffffffffc0201424:	489c                	lw	a5,16(s1)
ffffffffc0201426:	eff1                	bnez	a5,ffffffffc0201502 <alloc_check+0x2ae>

    for (p = physical_area; p < physical_area + total_size_store; p++)
ffffffffc0201428:	00093783          	ld	a5,0(s2)
ffffffffc020142c:	00299693          	slli	a3,s3,0x2
ffffffffc0201430:	96ce                	add	a3,a3,s3
ffffffffc0201432:	068e                	slli	a3,a3,0x3
ffffffffc0201434:	00d78733          	add	a4,a5,a3
ffffffffc0201438:	04e7f363          	bgeu	a5,a4,ffffffffc020147e <alloc_check+0x22a>
ffffffffc020143c:	4605                	li	a2,1
ffffffffc020143e:	00878713          	addi	a4,a5,8
ffffffffc0201442:	40c7302f          	amoor.d	zero,a2,(a4)
ffffffffc0201446:	00093503          	ld	a0,0(s2)
ffffffffc020144a:	02878793          	addi	a5,a5,40
ffffffffc020144e:	00d50733          	add	a4,a0,a3
ffffffffc0201452:	fee7e6e3          	bltu	a5,a4,ffffffffc020143e <alloc_check+0x1ea>
    elm->prev = elm->next = elm;
ffffffffc0201456:	e484                	sd	s1,8(s1)
ffffffffc0201458:	e084                	sd	s1,0(s1)
    nr_free = 0;
ffffffffc020145a:	00005797          	auipc	a5,0x5
ffffffffc020145e:	bc07a723          	sw	zero,-1074(a5) # ffffffffc0206028 <free_area+0x10>
    assert(n > 0);
ffffffffc0201462:	06098063          	beqz	s3,ffffffffc02014c2 <alloc_check+0x26e>
        SetPageReserved(p);
    buddy_init();
    buddy_init_memmap(physical_area, total_size_store);
}
ffffffffc0201466:	6406                	ld	s0,64(sp)
ffffffffc0201468:	60a6                	ld	ra,72(sp)
ffffffffc020146a:	74e2                	ld	s1,56(sp)
ffffffffc020146c:	7942                	ld	s2,48(sp)
ffffffffc020146e:	7a02                	ld	s4,32(sp)
ffffffffc0201470:	6ae2                	ld	s5,24(sp)
ffffffffc0201472:	6b42                	ld	s6,16(sp)
ffffffffc0201474:	6ba2                	ld	s7,8(sp)
ffffffffc0201476:	85ce                	mv	a1,s3
ffffffffc0201478:	79a2                	ld	s3,40(sp)
ffffffffc020147a:	6161                	addi	sp,sp,80
ffffffffc020147c:	bc59                	j	ffffffffc0200f12 <buddy_init_memmap.part.0>
    for (p = physical_area; p < physical_area + total_size_store; p++)
ffffffffc020147e:	853e                	mv	a0,a5
ffffffffc0201480:	bfd9                	j	ffffffffc0201456 <alloc_check+0x202>
        assert(buddy_allocate_pages(p->property) != NULL);
ffffffffc0201482:	00001697          	auipc	a3,0x1
ffffffffc0201486:	31e68693          	addi	a3,a3,798 # ffffffffc02027a0 <commands+0x858>
ffffffffc020148a:	00001617          	auipc	a2,0x1
ffffffffc020148e:	13660613          	addi	a2,a2,310 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201492:	11100593          	li	a1,273
ffffffffc0201496:	00001517          	auipc	a0,0x1
ffffffffc020149a:	14250513          	addi	a0,a0,322 # ffffffffc02025d8 <commands+0x690>
ffffffffc020149e:	c9dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
ffffffffc02014a2:	00001697          	auipc	a3,0x1
ffffffffc02014a6:	22668693          	addi	a3,a3,550 # ffffffffc02026c8 <commands+0x780>
ffffffffc02014aa:	00001617          	auipc	a2,0x1
ffffffffc02014ae:	11660613          	addi	a2,a2,278 # ffffffffc02025c0 <commands+0x678>
ffffffffc02014b2:	10600593          	li	a1,262
ffffffffc02014b6:	00001517          	auipc	a0,0x1
ffffffffc02014ba:	12250513          	addi	a0,a0,290 # ffffffffc02025d8 <commands+0x690>
ffffffffc02014be:	c7dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02014c2:	00001697          	auipc	a3,0x1
ffffffffc02014c6:	0f668693          	addi	a3,a3,246 # ffffffffc02025b8 <commands+0x670>
ffffffffc02014ca:	00001617          	auipc	a2,0x1
ffffffffc02014ce:	0f660613          	addi	a2,a2,246 # ffffffffc02025c0 <commands+0x678>
ffffffffc02014d2:	02f00593          	li	a1,47
ffffffffc02014d6:	00001517          	auipc	a0,0x1
ffffffffc02014da:	10250513          	addi	a0,a0,258 # ffffffffc02025d8 <commands+0x690>
ffffffffc02014de:	c5dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02014e2:	00001697          	auipc	a3,0x1
ffffffffc02014e6:	25e68693          	addi	a3,a3,606 # ffffffffc0202740 <commands+0x7f8>
ffffffffc02014ea:	00001617          	auipc	a2,0x1
ffffffffc02014ee:	0d660613          	addi	a2,a2,214 # ffffffffc02025c0 <commands+0x678>
ffffffffc02014f2:	10900593          	li	a1,265
ffffffffc02014f6:	00001517          	auipc	a0,0x1
ffffffffc02014fa:	0e250513          	addi	a0,a0,226 # ffffffffc02025d8 <commands+0x690>
ffffffffc02014fe:	c3dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0201502:	00001697          	auipc	a3,0x1
ffffffffc0201506:	34668693          	addi	a3,a3,838 # ffffffffc0202848 <commands+0x900>
ffffffffc020150a:	00001617          	auipc	a2,0x1
ffffffffc020150e:	0b660613          	addi	a2,a2,182 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201512:	12800593          	li	a1,296
ffffffffc0201516:	00001517          	auipc	a0,0x1
ffffffffc020151a:	0c250513          	addi	a0,a0,194 # ffffffffc02025d8 <commands+0x690>
ffffffffc020151e:	c1dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
ffffffffc0201522:	00001697          	auipc	a3,0x1
ffffffffc0201526:	25e68693          	addi	a3,a3,606 # ffffffffc0202780 <commands+0x838>
ffffffffc020152a:	00001617          	auipc	a2,0x1
ffffffffc020152e:	09660613          	addi	a2,a2,150 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201532:	10b00593          	li	a1,267
ffffffffc0201536:	00001517          	auipc	a0,0x1
ffffffffc020153a:	0a250513          	addi	a0,a0,162 # ffffffffc02025d8 <commands+0x690>
ffffffffc020153e:	bfdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 3);
ffffffffc0201542:	00001697          	auipc	a3,0x1
ffffffffc0201546:	2a668693          	addi	a3,a3,678 # ffffffffc02027e8 <commands+0x8a0>
ffffffffc020154a:	00001617          	auipc	a2,0x1
ffffffffc020154e:	07660613          	addi	a2,a2,118 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201552:	11900593          	li	a1,281
ffffffffc0201556:	00001517          	auipc	a0,0x1
ffffffffc020155a:	08250513          	addi	a0,a0,130 # ffffffffc02025d8 <commands+0x690>
ffffffffc020155e:	bddfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p = alloc_pages(4)) == p0);
ffffffffc0201562:	00001697          	auipc	a3,0x1
ffffffffc0201566:	2c668693          	addi	a3,a3,710 # ffffffffc0202828 <commands+0x8e0>
ffffffffc020156a:	00001617          	auipc	a2,0x1
ffffffffc020156e:	05660613          	addi	a2,a2,86 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201572:	12500593          	li	a1,293
ffffffffc0201576:	00001517          	auipc	a0,0x1
ffffffffc020157a:	06250513          	addi	a0,a0,98 # ffffffffc02025d8 <commands+0x690>
ffffffffc020157e:	bbdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201582:	00001697          	auipc	a3,0x1
ffffffffc0201586:	1de68693          	addi	a3,a3,478 # ffffffffc0202760 <commands+0x818>
ffffffffc020158a:	00001617          	auipc	a2,0x1
ffffffffc020158e:	03660613          	addi	a2,a2,54 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201592:	10a00593          	li	a1,266
ffffffffc0201596:	00001517          	auipc	a0,0x1
ffffffffc020159a:	04250513          	addi	a0,a0,66 # ffffffffc02025d8 <commands+0x690>
ffffffffc020159e:	b9dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p3 = alloc_page()) != NULL);
ffffffffc02015a2:	00001697          	auipc	a3,0x1
ffffffffc02015a6:	0d668693          	addi	a3,a3,214 # ffffffffc0202678 <commands+0x730>
ffffffffc02015aa:	00001617          	auipc	a2,0x1
ffffffffc02015ae:	01660613          	addi	a2,a2,22 # ffffffffc02025c0 <commands+0x678>
ffffffffc02015b2:	10100593          	li	a1,257
ffffffffc02015b6:	00001517          	auipc	a0,0x1
ffffffffc02015ba:	02250513          	addi	a0,a0,34 # ffffffffc02025d8 <commands+0x690>
ffffffffc02015be:	b7dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02015c2:	00001697          	auipc	a3,0x1
ffffffffc02015c6:	09668693          	addi	a3,a3,150 # ffffffffc0202658 <commands+0x710>
ffffffffc02015ca:	00001617          	auipc	a2,0x1
ffffffffc02015ce:	ff660613          	addi	a2,a2,-10 # ffffffffc02025c0 <commands+0x678>
ffffffffc02015d2:	10000593          	li	a1,256
ffffffffc02015d6:	00001517          	auipc	a0,0x1
ffffffffc02015da:	00250513          	addi	a0,a0,2 # ffffffffc02025d8 <commands+0x690>
ffffffffc02015de:	b5dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02015e2:	00001697          	auipc	a3,0x1
ffffffffc02015e6:	05668693          	addi	a3,a3,86 # ffffffffc0202638 <commands+0x6f0>
ffffffffc02015ea:	00001617          	auipc	a2,0x1
ffffffffc02015ee:	fd660613          	addi	a2,a2,-42 # ffffffffc02025c0 <commands+0x678>
ffffffffc02015f2:	0ff00593          	li	a1,255
ffffffffc02015f6:	00001517          	auipc	a0,0x1
ffffffffc02015fa:	fe250513          	addi	a0,a0,-30 # ffffffffc02025d8 <commands+0x690>
ffffffffc02015fe:	b3dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201602:	00001697          	auipc	a3,0x1
ffffffffc0201606:	01668693          	addi	a3,a3,22 # ffffffffc0202618 <commands+0x6d0>
ffffffffc020160a:	00001617          	auipc	a2,0x1
ffffffffc020160e:	fb660613          	addi	a2,a2,-74 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201612:	0fe00593          	li	a1,254
ffffffffc0201616:	00001517          	auipc	a0,0x1
ffffffffc020161a:	fc250513          	addi	a0,a0,-62 # ffffffffc02025d8 <commands+0x690>
ffffffffc020161e:	b1dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 + 1 == p2);
ffffffffc0201622:	00001697          	auipc	a3,0x1
ffffffffc0201626:	08668693          	addi	a3,a3,134 # ffffffffc02026a8 <commands+0x760>
ffffffffc020162a:	00001617          	auipc	a2,0x1
ffffffffc020162e:	f9660613          	addi	a2,a2,-106 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201632:	10400593          	li	a1,260
ffffffffc0201636:	00001517          	auipc	a0,0x1
ffffffffc020163a:	fa250513          	addi	a0,a0,-94 # ffffffffc02025d8 <commands+0x690>
ffffffffc020163e:	afdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 1 == p1);
ffffffffc0201642:	00001697          	auipc	a3,0x1
ffffffffc0201646:	05668693          	addi	a3,a3,86 # ffffffffc0202698 <commands+0x750>
ffffffffc020164a:	00001617          	auipc	a2,0x1
ffffffffc020164e:	f7660613          	addi	a2,a2,-138 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201652:	10300593          	li	a1,259
ffffffffc0201656:	00001517          	auipc	a0,0x1
ffffffffc020165a:	f8250513          	addi	a0,a0,-126 # ffffffffc02025d8 <commands+0x690>
ffffffffc020165e:	addfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201662:	00001697          	auipc	a3,0x1
ffffffffc0201666:	16e68693          	addi	a3,a3,366 # ffffffffc02027d0 <commands+0x888>
ffffffffc020166a:	00001617          	auipc	a2,0x1
ffffffffc020166e:	f5660613          	addi	a2,a2,-170 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201672:	11400593          	li	a1,276
ffffffffc0201676:	00001517          	auipc	a0,0x1
ffffffffc020167a:	f6250513          	addi	a0,a0,-158 # ffffffffc02025d8 <commands+0x690>
ffffffffc020167e:	abdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p2 + 1 == p3);
ffffffffc0201682:	00001697          	auipc	a3,0x1
ffffffffc0201686:	03668693          	addi	a3,a3,54 # ffffffffc02026b8 <commands+0x770>
ffffffffc020168a:	00001617          	auipc	a2,0x1
ffffffffc020168e:	f3660613          	addi	a2,a2,-202 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201692:	10500593          	li	a1,261
ffffffffc0201696:	00001517          	auipc	a0,0x1
ffffffffc020169a:	f4250513          	addi	a0,a0,-190 # ffffffffc02025d8 <commands+0x690>
ffffffffc020169e:	a9dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 2 == p1);
ffffffffc02016a2:	00001697          	auipc	a3,0x1
ffffffffc02016a6:	17668693          	addi	a3,a3,374 # ffffffffc0202818 <commands+0x8d0>
ffffffffc02016aa:	00001617          	auipc	a2,0x1
ffffffffc02016ae:	f1660613          	addi	a2,a2,-234 # ffffffffc02025c0 <commands+0x678>
ffffffffc02016b2:	11d00593          	li	a1,285
ffffffffc02016b6:	00001517          	auipc	a0,0x1
ffffffffc02016ba:	f2250513          	addi	a0,a0,-222 # ffffffffc02025d8 <commands+0x690>
ffffffffc02016be:	a7dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_pages(2)) != NULL);
ffffffffc02016c2:	00001697          	auipc	a3,0x1
ffffffffc02016c6:	13668693          	addi	a3,a3,310 # ffffffffc02027f8 <commands+0x8b0>
ffffffffc02016ca:	00001617          	auipc	a2,0x1
ffffffffc02016ce:	ef660613          	addi	a2,a2,-266 # ffffffffc02025c0 <commands+0x678>
ffffffffc02016d2:	11c00593          	li	a1,284
ffffffffc02016d6:	00001517          	auipc	a0,0x1
ffffffffc02016da:	f0250513          	addi	a0,a0,-254 # ffffffffc02025d8 <commands+0x690>
ffffffffc02016de:	a5dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02016e2:	00001697          	auipc	a3,0x1
ffffffffc02016e6:	f5668693          	addi	a3,a3,-170 # ffffffffc0202638 <commands+0x6f0>
ffffffffc02016ea:	00001617          	auipc	a2,0x1
ffffffffc02016ee:	ed660613          	addi	a2,a2,-298 # ffffffffc02025c0 <commands+0x678>
ffffffffc02016f2:	11b00593          	li	a1,283
ffffffffc02016f6:	00001517          	auipc	a0,0x1
ffffffffc02016fa:	ee250513          	addi	a0,a0,-286 # ffffffffc02025d8 <commands+0x690>
ffffffffc02016fe:	a3dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201702:	00001697          	auipc	a3,0x1
ffffffffc0201706:	0ce68693          	addi	a3,a3,206 # ffffffffc02027d0 <commands+0x888>
ffffffffc020170a:	00001617          	auipc	a2,0x1
ffffffffc020170e:	eb660613          	addi	a2,a2,-330 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201712:	12600593          	li	a1,294
ffffffffc0201716:	00001517          	auipc	a0,0x1
ffffffffc020171a:	ec250513          	addi	a0,a0,-318 # ffffffffc02025d8 <commands+0x690>
ffffffffc020171e:	a1dfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201722:	00001697          	auipc	a3,0x1
ffffffffc0201726:	ffe68693          	addi	a3,a3,-2 # ffffffffc0202720 <commands+0x7d8>
ffffffffc020172a:	00001617          	auipc	a2,0x1
ffffffffc020172e:	e9660613          	addi	a2,a2,-362 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201732:	10800593          	li	a1,264
ffffffffc0201736:	00001517          	auipc	a0,0x1
ffffffffc020173a:	ea250513          	addi	a0,a0,-350 # ffffffffc02025d8 <commands+0x690>
ffffffffc020173e:	9fdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201742:	00001697          	auipc	a3,0x1
ffffffffc0201746:	08e68693          	addi	a3,a3,142 # ffffffffc02027d0 <commands+0x888>
ffffffffc020174a:	00001617          	auipc	a2,0x1
ffffffffc020174e:	e7660613          	addi	a2,a2,-394 # ffffffffc02025c0 <commands+0x678>
ffffffffc0201752:	11f00593          	li	a1,287
ffffffffc0201756:	00001517          	auipc	a0,0x1
ffffffffc020175a:	e8250513          	addi	a0,a0,-382 # ffffffffc02025d8 <commands+0x690>
ffffffffc020175e:	9ddfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201762 <strnlen>:
ffffffffc0201762:	4781                	li	a5,0
ffffffffc0201764:	e589                	bnez	a1,ffffffffc020176e <strnlen+0xc>
ffffffffc0201766:	a811                	j	ffffffffc020177a <strnlen+0x18>
ffffffffc0201768:	0785                	addi	a5,a5,1
ffffffffc020176a:	00f58863          	beq	a1,a5,ffffffffc020177a <strnlen+0x18>
ffffffffc020176e:	00f50733          	add	a4,a0,a5
ffffffffc0201772:	00074703          	lbu	a4,0(a4)
ffffffffc0201776:	fb6d                	bnez	a4,ffffffffc0201768 <strnlen+0x6>
ffffffffc0201778:	85be                	mv	a1,a5
ffffffffc020177a:	852e                	mv	a0,a1
ffffffffc020177c:	8082                	ret

ffffffffc020177e <strcmp>:
ffffffffc020177e:	00054783          	lbu	a5,0(a0)
ffffffffc0201782:	0005c703          	lbu	a4,0(a1)
ffffffffc0201786:	cb89                	beqz	a5,ffffffffc0201798 <strcmp+0x1a>
ffffffffc0201788:	0505                	addi	a0,a0,1
ffffffffc020178a:	0585                	addi	a1,a1,1
ffffffffc020178c:	fee789e3          	beq	a5,a4,ffffffffc020177e <strcmp>
ffffffffc0201790:	0007851b          	sext.w	a0,a5
ffffffffc0201794:	9d19                	subw	a0,a0,a4
ffffffffc0201796:	8082                	ret
ffffffffc0201798:	4501                	li	a0,0
ffffffffc020179a:	bfed                	j	ffffffffc0201794 <strcmp+0x16>

ffffffffc020179c <strchr>:
ffffffffc020179c:	00054783          	lbu	a5,0(a0)
ffffffffc02017a0:	c799                	beqz	a5,ffffffffc02017ae <strchr+0x12>
ffffffffc02017a2:	00f58763          	beq	a1,a5,ffffffffc02017b0 <strchr+0x14>
ffffffffc02017a6:	00154783          	lbu	a5,1(a0)
ffffffffc02017aa:	0505                	addi	a0,a0,1
ffffffffc02017ac:	fbfd                	bnez	a5,ffffffffc02017a2 <strchr+0x6>
ffffffffc02017ae:	4501                	li	a0,0
ffffffffc02017b0:	8082                	ret

ffffffffc02017b2 <memset>:
ffffffffc02017b2:	ca01                	beqz	a2,ffffffffc02017c2 <memset+0x10>
ffffffffc02017b4:	962a                	add	a2,a2,a0
ffffffffc02017b6:	87aa                	mv	a5,a0
ffffffffc02017b8:	0785                	addi	a5,a5,1
ffffffffc02017ba:	feb78fa3          	sb	a1,-1(a5)
ffffffffc02017be:	fec79de3          	bne	a5,a2,ffffffffc02017b8 <memset+0x6>
ffffffffc02017c2:	8082                	ret

ffffffffc02017c4 <printnum>:
ffffffffc02017c4:	02069813          	slli	a6,a3,0x20
ffffffffc02017c8:	7179                	addi	sp,sp,-48
ffffffffc02017ca:	02085813          	srli	a6,a6,0x20
ffffffffc02017ce:	e052                	sd	s4,0(sp)
ffffffffc02017d0:	03067a33          	remu	s4,a2,a6
ffffffffc02017d4:	f022                	sd	s0,32(sp)
ffffffffc02017d6:	ec26                	sd	s1,24(sp)
ffffffffc02017d8:	e84a                	sd	s2,16(sp)
ffffffffc02017da:	f406                	sd	ra,40(sp)
ffffffffc02017dc:	e44e                	sd	s3,8(sp)
ffffffffc02017de:	84aa                	mv	s1,a0
ffffffffc02017e0:	892e                	mv	s2,a1
ffffffffc02017e2:	fff7041b          	addiw	s0,a4,-1
ffffffffc02017e6:	2a01                	sext.w	s4,s4
ffffffffc02017e8:	03067e63          	bgeu	a2,a6,ffffffffc0201824 <printnum+0x60>
ffffffffc02017ec:	89be                	mv	s3,a5
ffffffffc02017ee:	00805763          	blez	s0,ffffffffc02017fc <printnum+0x38>
ffffffffc02017f2:	347d                	addiw	s0,s0,-1
ffffffffc02017f4:	85ca                	mv	a1,s2
ffffffffc02017f6:	854e                	mv	a0,s3
ffffffffc02017f8:	9482                	jalr	s1
ffffffffc02017fa:	fc65                	bnez	s0,ffffffffc02017f2 <printnum+0x2e>
ffffffffc02017fc:	1a02                	slli	s4,s4,0x20
ffffffffc02017fe:	00001797          	auipc	a5,0x1
ffffffffc0201802:	0aa78793          	addi	a5,a5,170 # ffffffffc02028a8 <buddy_pmm_manager+0x38>
ffffffffc0201806:	020a5a13          	srli	s4,s4,0x20
ffffffffc020180a:	9a3e                	add	s4,s4,a5
ffffffffc020180c:	7402                	ld	s0,32(sp)
ffffffffc020180e:	000a4503          	lbu	a0,0(s4)
ffffffffc0201812:	70a2                	ld	ra,40(sp)
ffffffffc0201814:	69a2                	ld	s3,8(sp)
ffffffffc0201816:	6a02                	ld	s4,0(sp)
ffffffffc0201818:	85ca                	mv	a1,s2
ffffffffc020181a:	87a6                	mv	a5,s1
ffffffffc020181c:	6942                	ld	s2,16(sp)
ffffffffc020181e:	64e2                	ld	s1,24(sp)
ffffffffc0201820:	6145                	addi	sp,sp,48
ffffffffc0201822:	8782                	jr	a5
ffffffffc0201824:	03065633          	divu	a2,a2,a6
ffffffffc0201828:	8722                	mv	a4,s0
ffffffffc020182a:	f9bff0ef          	jal	ra,ffffffffc02017c4 <printnum>
ffffffffc020182e:	b7f9                	j	ffffffffc02017fc <printnum+0x38>

ffffffffc0201830 <vprintfmt>:
ffffffffc0201830:	7119                	addi	sp,sp,-128
ffffffffc0201832:	f4a6                	sd	s1,104(sp)
ffffffffc0201834:	f0ca                	sd	s2,96(sp)
ffffffffc0201836:	ecce                	sd	s3,88(sp)
ffffffffc0201838:	e8d2                	sd	s4,80(sp)
ffffffffc020183a:	e4d6                	sd	s5,72(sp)
ffffffffc020183c:	e0da                	sd	s6,64(sp)
ffffffffc020183e:	fc5e                	sd	s7,56(sp)
ffffffffc0201840:	f06a                	sd	s10,32(sp)
ffffffffc0201842:	fc86                	sd	ra,120(sp)
ffffffffc0201844:	f8a2                	sd	s0,112(sp)
ffffffffc0201846:	f862                	sd	s8,48(sp)
ffffffffc0201848:	f466                	sd	s9,40(sp)
ffffffffc020184a:	ec6e                	sd	s11,24(sp)
ffffffffc020184c:	892a                	mv	s2,a0
ffffffffc020184e:	84ae                	mv	s1,a1
ffffffffc0201850:	8d32                	mv	s10,a2
ffffffffc0201852:	8a36                	mv	s4,a3
ffffffffc0201854:	02500993          	li	s3,37
ffffffffc0201858:	5b7d                	li	s6,-1
ffffffffc020185a:	00001a97          	auipc	s5,0x1
ffffffffc020185e:	082a8a93          	addi	s5,s5,130 # ffffffffc02028dc <buddy_pmm_manager+0x6c>
ffffffffc0201862:	00001b97          	auipc	s7,0x1
ffffffffc0201866:	256b8b93          	addi	s7,s7,598 # ffffffffc0202ab8 <error_string>
ffffffffc020186a:	000d4503          	lbu	a0,0(s10)
ffffffffc020186e:	001d0413          	addi	s0,s10,1
ffffffffc0201872:	01350a63          	beq	a0,s3,ffffffffc0201886 <vprintfmt+0x56>
ffffffffc0201876:	c121                	beqz	a0,ffffffffc02018b6 <vprintfmt+0x86>
ffffffffc0201878:	85a6                	mv	a1,s1
ffffffffc020187a:	0405                	addi	s0,s0,1
ffffffffc020187c:	9902                	jalr	s2
ffffffffc020187e:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201882:	ff351ae3          	bne	a0,s3,ffffffffc0201876 <vprintfmt+0x46>
ffffffffc0201886:	00044603          	lbu	a2,0(s0)
ffffffffc020188a:	02000793          	li	a5,32
ffffffffc020188e:	4c81                	li	s9,0
ffffffffc0201890:	4881                	li	a7,0
ffffffffc0201892:	5c7d                	li	s8,-1
ffffffffc0201894:	5dfd                	li	s11,-1
ffffffffc0201896:	05500513          	li	a0,85
ffffffffc020189a:	4825                	li	a6,9
ffffffffc020189c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02018a0:	0ff5f593          	zext.b	a1,a1
ffffffffc02018a4:	00140d13          	addi	s10,s0,1
ffffffffc02018a8:	04b56263          	bltu	a0,a1,ffffffffc02018ec <vprintfmt+0xbc>
ffffffffc02018ac:	058a                	slli	a1,a1,0x2
ffffffffc02018ae:	95d6                	add	a1,a1,s5
ffffffffc02018b0:	4194                	lw	a3,0(a1)
ffffffffc02018b2:	96d6                	add	a3,a3,s5
ffffffffc02018b4:	8682                	jr	a3
ffffffffc02018b6:	70e6                	ld	ra,120(sp)
ffffffffc02018b8:	7446                	ld	s0,112(sp)
ffffffffc02018ba:	74a6                	ld	s1,104(sp)
ffffffffc02018bc:	7906                	ld	s2,96(sp)
ffffffffc02018be:	69e6                	ld	s3,88(sp)
ffffffffc02018c0:	6a46                	ld	s4,80(sp)
ffffffffc02018c2:	6aa6                	ld	s5,72(sp)
ffffffffc02018c4:	6b06                	ld	s6,64(sp)
ffffffffc02018c6:	7be2                	ld	s7,56(sp)
ffffffffc02018c8:	7c42                	ld	s8,48(sp)
ffffffffc02018ca:	7ca2                	ld	s9,40(sp)
ffffffffc02018cc:	7d02                	ld	s10,32(sp)
ffffffffc02018ce:	6de2                	ld	s11,24(sp)
ffffffffc02018d0:	6109                	addi	sp,sp,128
ffffffffc02018d2:	8082                	ret
ffffffffc02018d4:	87b2                	mv	a5,a2
ffffffffc02018d6:	00144603          	lbu	a2,1(s0)
ffffffffc02018da:	846a                	mv	s0,s10
ffffffffc02018dc:	00140d13          	addi	s10,s0,1
ffffffffc02018e0:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02018e4:	0ff5f593          	zext.b	a1,a1
ffffffffc02018e8:	fcb572e3          	bgeu	a0,a1,ffffffffc02018ac <vprintfmt+0x7c>
ffffffffc02018ec:	85a6                	mv	a1,s1
ffffffffc02018ee:	02500513          	li	a0,37
ffffffffc02018f2:	9902                	jalr	s2
ffffffffc02018f4:	fff44783          	lbu	a5,-1(s0)
ffffffffc02018f8:	8d22                	mv	s10,s0
ffffffffc02018fa:	f73788e3          	beq	a5,s3,ffffffffc020186a <vprintfmt+0x3a>
ffffffffc02018fe:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201902:	1d7d                	addi	s10,s10,-1
ffffffffc0201904:	ff379de3          	bne	a5,s3,ffffffffc02018fe <vprintfmt+0xce>
ffffffffc0201908:	b78d                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc020190a:	fd060c1b          	addiw	s8,a2,-48
ffffffffc020190e:	00144603          	lbu	a2,1(s0)
ffffffffc0201912:	846a                	mv	s0,s10
ffffffffc0201914:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201918:	0006059b          	sext.w	a1,a2
ffffffffc020191c:	02d86463          	bltu	a6,a3,ffffffffc0201944 <vprintfmt+0x114>
ffffffffc0201920:	00144603          	lbu	a2,1(s0)
ffffffffc0201924:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201928:	0186873b          	addw	a4,a3,s8
ffffffffc020192c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201930:	9f2d                	addw	a4,a4,a1
ffffffffc0201932:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201936:	0405                	addi	s0,s0,1
ffffffffc0201938:	fd070c1b          	addiw	s8,a4,-48
ffffffffc020193c:	0006059b          	sext.w	a1,a2
ffffffffc0201940:	fed870e3          	bgeu	a6,a3,ffffffffc0201920 <vprintfmt+0xf0>
ffffffffc0201944:	f40ddce3          	bgez	s11,ffffffffc020189c <vprintfmt+0x6c>
ffffffffc0201948:	8de2                	mv	s11,s8
ffffffffc020194a:	5c7d                	li	s8,-1
ffffffffc020194c:	bf81                	j	ffffffffc020189c <vprintfmt+0x6c>
ffffffffc020194e:	fffdc693          	not	a3,s11
ffffffffc0201952:	96fd                	srai	a3,a3,0x3f
ffffffffc0201954:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201958:	00144603          	lbu	a2,1(s0)
ffffffffc020195c:	2d81                	sext.w	s11,s11
ffffffffc020195e:	846a                	mv	s0,s10
ffffffffc0201960:	bf35                	j	ffffffffc020189c <vprintfmt+0x6c>
ffffffffc0201962:	000a2c03          	lw	s8,0(s4)
ffffffffc0201966:	00144603          	lbu	a2,1(s0)
ffffffffc020196a:	0a21                	addi	s4,s4,8
ffffffffc020196c:	846a                	mv	s0,s10
ffffffffc020196e:	bfd9                	j	ffffffffc0201944 <vprintfmt+0x114>
ffffffffc0201970:	4705                	li	a4,1
ffffffffc0201972:	008a0593          	addi	a1,s4,8
ffffffffc0201976:	01174463          	blt	a4,a7,ffffffffc020197e <vprintfmt+0x14e>
ffffffffc020197a:	1a088e63          	beqz	a7,ffffffffc0201b36 <vprintfmt+0x306>
ffffffffc020197e:	000a3603          	ld	a2,0(s4)
ffffffffc0201982:	46c1                	li	a3,16
ffffffffc0201984:	8a2e                	mv	s4,a1
ffffffffc0201986:	2781                	sext.w	a5,a5
ffffffffc0201988:	876e                	mv	a4,s11
ffffffffc020198a:	85a6                	mv	a1,s1
ffffffffc020198c:	854a                	mv	a0,s2
ffffffffc020198e:	e37ff0ef          	jal	ra,ffffffffc02017c4 <printnum>
ffffffffc0201992:	bde1                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc0201994:	000a2503          	lw	a0,0(s4)
ffffffffc0201998:	85a6                	mv	a1,s1
ffffffffc020199a:	0a21                	addi	s4,s4,8
ffffffffc020199c:	9902                	jalr	s2
ffffffffc020199e:	b5f1                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc02019a0:	4705                	li	a4,1
ffffffffc02019a2:	008a0593          	addi	a1,s4,8
ffffffffc02019a6:	01174463          	blt	a4,a7,ffffffffc02019ae <vprintfmt+0x17e>
ffffffffc02019aa:	18088163          	beqz	a7,ffffffffc0201b2c <vprintfmt+0x2fc>
ffffffffc02019ae:	000a3603          	ld	a2,0(s4)
ffffffffc02019b2:	46a9                	li	a3,10
ffffffffc02019b4:	8a2e                	mv	s4,a1
ffffffffc02019b6:	bfc1                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc02019b8:	00144603          	lbu	a2,1(s0)
ffffffffc02019bc:	4c85                	li	s9,1
ffffffffc02019be:	846a                	mv	s0,s10
ffffffffc02019c0:	bdf1                	j	ffffffffc020189c <vprintfmt+0x6c>
ffffffffc02019c2:	85a6                	mv	a1,s1
ffffffffc02019c4:	02500513          	li	a0,37
ffffffffc02019c8:	9902                	jalr	s2
ffffffffc02019ca:	b545                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc02019cc:	00144603          	lbu	a2,1(s0)
ffffffffc02019d0:	2885                	addiw	a7,a7,1
ffffffffc02019d2:	846a                	mv	s0,s10
ffffffffc02019d4:	b5e1                	j	ffffffffc020189c <vprintfmt+0x6c>
ffffffffc02019d6:	4705                	li	a4,1
ffffffffc02019d8:	008a0593          	addi	a1,s4,8
ffffffffc02019dc:	01174463          	blt	a4,a7,ffffffffc02019e4 <vprintfmt+0x1b4>
ffffffffc02019e0:	14088163          	beqz	a7,ffffffffc0201b22 <vprintfmt+0x2f2>
ffffffffc02019e4:	000a3603          	ld	a2,0(s4)
ffffffffc02019e8:	46a1                	li	a3,8
ffffffffc02019ea:	8a2e                	mv	s4,a1
ffffffffc02019ec:	bf69                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc02019ee:	03000513          	li	a0,48
ffffffffc02019f2:	85a6                	mv	a1,s1
ffffffffc02019f4:	e03e                	sd	a5,0(sp)
ffffffffc02019f6:	9902                	jalr	s2
ffffffffc02019f8:	85a6                	mv	a1,s1
ffffffffc02019fa:	07800513          	li	a0,120
ffffffffc02019fe:	9902                	jalr	s2
ffffffffc0201a00:	0a21                	addi	s4,s4,8
ffffffffc0201a02:	6782                	ld	a5,0(sp)
ffffffffc0201a04:	46c1                	li	a3,16
ffffffffc0201a06:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201a0a:	bfb5                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201a0c:	000a3403          	ld	s0,0(s4)
ffffffffc0201a10:	008a0713          	addi	a4,s4,8
ffffffffc0201a14:	e03a                	sd	a4,0(sp)
ffffffffc0201a16:	14040263          	beqz	s0,ffffffffc0201b5a <vprintfmt+0x32a>
ffffffffc0201a1a:	0fb05763          	blez	s11,ffffffffc0201b08 <vprintfmt+0x2d8>
ffffffffc0201a1e:	02d00693          	li	a3,45
ffffffffc0201a22:	0cd79163          	bne	a5,a3,ffffffffc0201ae4 <vprintfmt+0x2b4>
ffffffffc0201a26:	00044783          	lbu	a5,0(s0)
ffffffffc0201a2a:	0007851b          	sext.w	a0,a5
ffffffffc0201a2e:	cf85                	beqz	a5,ffffffffc0201a66 <vprintfmt+0x236>
ffffffffc0201a30:	00140a13          	addi	s4,s0,1
ffffffffc0201a34:	05e00413          	li	s0,94
ffffffffc0201a38:	000c4563          	bltz	s8,ffffffffc0201a42 <vprintfmt+0x212>
ffffffffc0201a3c:	3c7d                	addiw	s8,s8,-1
ffffffffc0201a3e:	036c0263          	beq	s8,s6,ffffffffc0201a62 <vprintfmt+0x232>
ffffffffc0201a42:	85a6                	mv	a1,s1
ffffffffc0201a44:	0e0c8e63          	beqz	s9,ffffffffc0201b40 <vprintfmt+0x310>
ffffffffc0201a48:	3781                	addiw	a5,a5,-32
ffffffffc0201a4a:	0ef47b63          	bgeu	s0,a5,ffffffffc0201b40 <vprintfmt+0x310>
ffffffffc0201a4e:	03f00513          	li	a0,63
ffffffffc0201a52:	9902                	jalr	s2
ffffffffc0201a54:	000a4783          	lbu	a5,0(s4)
ffffffffc0201a58:	3dfd                	addiw	s11,s11,-1
ffffffffc0201a5a:	0a05                	addi	s4,s4,1
ffffffffc0201a5c:	0007851b          	sext.w	a0,a5
ffffffffc0201a60:	ffe1                	bnez	a5,ffffffffc0201a38 <vprintfmt+0x208>
ffffffffc0201a62:	01b05963          	blez	s11,ffffffffc0201a74 <vprintfmt+0x244>
ffffffffc0201a66:	3dfd                	addiw	s11,s11,-1
ffffffffc0201a68:	85a6                	mv	a1,s1
ffffffffc0201a6a:	02000513          	li	a0,32
ffffffffc0201a6e:	9902                	jalr	s2
ffffffffc0201a70:	fe0d9be3          	bnez	s11,ffffffffc0201a66 <vprintfmt+0x236>
ffffffffc0201a74:	6a02                	ld	s4,0(sp)
ffffffffc0201a76:	bbd5                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc0201a78:	4705                	li	a4,1
ffffffffc0201a7a:	008a0c93          	addi	s9,s4,8
ffffffffc0201a7e:	01174463          	blt	a4,a7,ffffffffc0201a86 <vprintfmt+0x256>
ffffffffc0201a82:	08088d63          	beqz	a7,ffffffffc0201b1c <vprintfmt+0x2ec>
ffffffffc0201a86:	000a3403          	ld	s0,0(s4)
ffffffffc0201a8a:	0a044d63          	bltz	s0,ffffffffc0201b44 <vprintfmt+0x314>
ffffffffc0201a8e:	8622                	mv	a2,s0
ffffffffc0201a90:	8a66                	mv	s4,s9
ffffffffc0201a92:	46a9                	li	a3,10
ffffffffc0201a94:	bdcd                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201a96:	000a2783          	lw	a5,0(s4)
ffffffffc0201a9a:	4719                	li	a4,6
ffffffffc0201a9c:	0a21                	addi	s4,s4,8
ffffffffc0201a9e:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201aa2:	8fb5                	xor	a5,a5,a3
ffffffffc0201aa4:	40d786bb          	subw	a3,a5,a3
ffffffffc0201aa8:	02d74163          	blt	a4,a3,ffffffffc0201aca <vprintfmt+0x29a>
ffffffffc0201aac:	00369793          	slli	a5,a3,0x3
ffffffffc0201ab0:	97de                	add	a5,a5,s7
ffffffffc0201ab2:	639c                	ld	a5,0(a5)
ffffffffc0201ab4:	cb99                	beqz	a5,ffffffffc0201aca <vprintfmt+0x29a>
ffffffffc0201ab6:	86be                	mv	a3,a5
ffffffffc0201ab8:	00001617          	auipc	a2,0x1
ffffffffc0201abc:	e2060613          	addi	a2,a2,-480 # ffffffffc02028d8 <buddy_pmm_manager+0x68>
ffffffffc0201ac0:	85a6                	mv	a1,s1
ffffffffc0201ac2:	854a                	mv	a0,s2
ffffffffc0201ac4:	0ce000ef          	jal	ra,ffffffffc0201b92 <printfmt>
ffffffffc0201ac8:	b34d                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc0201aca:	00001617          	auipc	a2,0x1
ffffffffc0201ace:	dfe60613          	addi	a2,a2,-514 # ffffffffc02028c8 <buddy_pmm_manager+0x58>
ffffffffc0201ad2:	85a6                	mv	a1,s1
ffffffffc0201ad4:	854a                	mv	a0,s2
ffffffffc0201ad6:	0bc000ef          	jal	ra,ffffffffc0201b92 <printfmt>
ffffffffc0201ada:	bb41                	j	ffffffffc020186a <vprintfmt+0x3a>
ffffffffc0201adc:	00001417          	auipc	s0,0x1
ffffffffc0201ae0:	de440413          	addi	s0,s0,-540 # ffffffffc02028c0 <buddy_pmm_manager+0x50>
ffffffffc0201ae4:	85e2                	mv	a1,s8
ffffffffc0201ae6:	8522                	mv	a0,s0
ffffffffc0201ae8:	e43e                	sd	a5,8(sp)
ffffffffc0201aea:	c79ff0ef          	jal	ra,ffffffffc0201762 <strnlen>
ffffffffc0201aee:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201af2:	01b05b63          	blez	s11,ffffffffc0201b08 <vprintfmt+0x2d8>
ffffffffc0201af6:	67a2                	ld	a5,8(sp)
ffffffffc0201af8:	00078a1b          	sext.w	s4,a5
ffffffffc0201afc:	3dfd                	addiw	s11,s11,-1
ffffffffc0201afe:	85a6                	mv	a1,s1
ffffffffc0201b00:	8552                	mv	a0,s4
ffffffffc0201b02:	9902                	jalr	s2
ffffffffc0201b04:	fe0d9ce3          	bnez	s11,ffffffffc0201afc <vprintfmt+0x2cc>
ffffffffc0201b08:	00044783          	lbu	a5,0(s0)
ffffffffc0201b0c:	00140a13          	addi	s4,s0,1
ffffffffc0201b10:	0007851b          	sext.w	a0,a5
ffffffffc0201b14:	d3a5                	beqz	a5,ffffffffc0201a74 <vprintfmt+0x244>
ffffffffc0201b16:	05e00413          	li	s0,94
ffffffffc0201b1a:	bf39                	j	ffffffffc0201a38 <vprintfmt+0x208>
ffffffffc0201b1c:	000a2403          	lw	s0,0(s4)
ffffffffc0201b20:	b7ad                	j	ffffffffc0201a8a <vprintfmt+0x25a>
ffffffffc0201b22:	000a6603          	lwu	a2,0(s4)
ffffffffc0201b26:	46a1                	li	a3,8
ffffffffc0201b28:	8a2e                	mv	s4,a1
ffffffffc0201b2a:	bdb1                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201b2c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201b30:	46a9                	li	a3,10
ffffffffc0201b32:	8a2e                	mv	s4,a1
ffffffffc0201b34:	bd89                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201b36:	000a6603          	lwu	a2,0(s4)
ffffffffc0201b3a:	46c1                	li	a3,16
ffffffffc0201b3c:	8a2e                	mv	s4,a1
ffffffffc0201b3e:	b5a1                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201b40:	9902                	jalr	s2
ffffffffc0201b42:	bf09                	j	ffffffffc0201a54 <vprintfmt+0x224>
ffffffffc0201b44:	85a6                	mv	a1,s1
ffffffffc0201b46:	02d00513          	li	a0,45
ffffffffc0201b4a:	e03e                	sd	a5,0(sp)
ffffffffc0201b4c:	9902                	jalr	s2
ffffffffc0201b4e:	6782                	ld	a5,0(sp)
ffffffffc0201b50:	8a66                	mv	s4,s9
ffffffffc0201b52:	40800633          	neg	a2,s0
ffffffffc0201b56:	46a9                	li	a3,10
ffffffffc0201b58:	b53d                	j	ffffffffc0201986 <vprintfmt+0x156>
ffffffffc0201b5a:	03b05163          	blez	s11,ffffffffc0201b7c <vprintfmt+0x34c>
ffffffffc0201b5e:	02d00693          	li	a3,45
ffffffffc0201b62:	f6d79de3          	bne	a5,a3,ffffffffc0201adc <vprintfmt+0x2ac>
ffffffffc0201b66:	00001417          	auipc	s0,0x1
ffffffffc0201b6a:	d5a40413          	addi	s0,s0,-678 # ffffffffc02028c0 <buddy_pmm_manager+0x50>
ffffffffc0201b6e:	02800793          	li	a5,40
ffffffffc0201b72:	02800513          	li	a0,40
ffffffffc0201b76:	00140a13          	addi	s4,s0,1
ffffffffc0201b7a:	bd6d                	j	ffffffffc0201a34 <vprintfmt+0x204>
ffffffffc0201b7c:	00001a17          	auipc	s4,0x1
ffffffffc0201b80:	d45a0a13          	addi	s4,s4,-699 # ffffffffc02028c1 <buddy_pmm_manager+0x51>
ffffffffc0201b84:	02800513          	li	a0,40
ffffffffc0201b88:	02800793          	li	a5,40
ffffffffc0201b8c:	05e00413          	li	s0,94
ffffffffc0201b90:	b565                	j	ffffffffc0201a38 <vprintfmt+0x208>

ffffffffc0201b92 <printfmt>:
ffffffffc0201b92:	715d                	addi	sp,sp,-80
ffffffffc0201b94:	02810313          	addi	t1,sp,40
ffffffffc0201b98:	f436                	sd	a3,40(sp)
ffffffffc0201b9a:	869a                	mv	a3,t1
ffffffffc0201b9c:	ec06                	sd	ra,24(sp)
ffffffffc0201b9e:	f83a                	sd	a4,48(sp)
ffffffffc0201ba0:	fc3e                	sd	a5,56(sp)
ffffffffc0201ba2:	e0c2                	sd	a6,64(sp)
ffffffffc0201ba4:	e4c6                	sd	a7,72(sp)
ffffffffc0201ba6:	e41a                	sd	t1,8(sp)
ffffffffc0201ba8:	c89ff0ef          	jal	ra,ffffffffc0201830 <vprintfmt>
ffffffffc0201bac:	60e2                	ld	ra,24(sp)
ffffffffc0201bae:	6161                	addi	sp,sp,80
ffffffffc0201bb0:	8082                	ret

ffffffffc0201bb2 <readline>:
ffffffffc0201bb2:	715d                	addi	sp,sp,-80
ffffffffc0201bb4:	e486                	sd	ra,72(sp)
ffffffffc0201bb6:	e0a6                	sd	s1,64(sp)
ffffffffc0201bb8:	fc4a                	sd	s2,56(sp)
ffffffffc0201bba:	f84e                	sd	s3,48(sp)
ffffffffc0201bbc:	f452                	sd	s4,40(sp)
ffffffffc0201bbe:	f056                	sd	s5,32(sp)
ffffffffc0201bc0:	ec5a                	sd	s6,24(sp)
ffffffffc0201bc2:	e85e                	sd	s7,16(sp)
ffffffffc0201bc4:	c901                	beqz	a0,ffffffffc0201bd4 <readline+0x22>
ffffffffc0201bc6:	85aa                	mv	a1,a0
ffffffffc0201bc8:	00001517          	auipc	a0,0x1
ffffffffc0201bcc:	d1050513          	addi	a0,a0,-752 # ffffffffc02028d8 <buddy_pmm_manager+0x68>
ffffffffc0201bd0:	ce2fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201bd4:	4481                	li	s1,0
ffffffffc0201bd6:	497d                	li	s2,31
ffffffffc0201bd8:	49a1                	li	s3,8
ffffffffc0201bda:	4aa9                	li	s5,10
ffffffffc0201bdc:	4b35                	li	s6,13
ffffffffc0201bde:	00004b97          	auipc	s7,0x4
ffffffffc0201be2:	452b8b93          	addi	s7,s7,1106 # ffffffffc0206030 <buf>
ffffffffc0201be6:	3fe00a13          	li	s4,1022
ffffffffc0201bea:	d40fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201bee:	00054a63          	bltz	a0,ffffffffc0201c02 <readline+0x50>
ffffffffc0201bf2:	00a95a63          	bge	s2,a0,ffffffffc0201c06 <readline+0x54>
ffffffffc0201bf6:	029a5263          	bge	s4,s1,ffffffffc0201c1a <readline+0x68>
ffffffffc0201bfa:	d30fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201bfe:	fe055ae3          	bgez	a0,ffffffffc0201bf2 <readline+0x40>
ffffffffc0201c02:	4501                	li	a0,0
ffffffffc0201c04:	a091                	j	ffffffffc0201c48 <readline+0x96>
ffffffffc0201c06:	03351463          	bne	a0,s3,ffffffffc0201c2e <readline+0x7c>
ffffffffc0201c0a:	e8a9                	bnez	s1,ffffffffc0201c5c <readline+0xaa>
ffffffffc0201c0c:	d1efe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201c10:	fe0549e3          	bltz	a0,ffffffffc0201c02 <readline+0x50>
ffffffffc0201c14:	fea959e3          	bge	s2,a0,ffffffffc0201c06 <readline+0x54>
ffffffffc0201c18:	4481                	li	s1,0
ffffffffc0201c1a:	e42a                	sd	a0,8(sp)
ffffffffc0201c1c:	cccfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201c20:	6522                	ld	a0,8(sp)
ffffffffc0201c22:	009b87b3          	add	a5,s7,s1
ffffffffc0201c26:	2485                	addiw	s1,s1,1
ffffffffc0201c28:	00a78023          	sb	a0,0(a5)
ffffffffc0201c2c:	bf7d                	j	ffffffffc0201bea <readline+0x38>
ffffffffc0201c2e:	01550463          	beq	a0,s5,ffffffffc0201c36 <readline+0x84>
ffffffffc0201c32:	fb651ce3          	bne	a0,s6,ffffffffc0201bea <readline+0x38>
ffffffffc0201c36:	cb2fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201c3a:	00004517          	auipc	a0,0x4
ffffffffc0201c3e:	3f650513          	addi	a0,a0,1014 # ffffffffc0206030 <buf>
ffffffffc0201c42:	94aa                	add	s1,s1,a0
ffffffffc0201c44:	00048023          	sb	zero,0(s1)
ffffffffc0201c48:	60a6                	ld	ra,72(sp)
ffffffffc0201c4a:	6486                	ld	s1,64(sp)
ffffffffc0201c4c:	7962                	ld	s2,56(sp)
ffffffffc0201c4e:	79c2                	ld	s3,48(sp)
ffffffffc0201c50:	7a22                	ld	s4,40(sp)
ffffffffc0201c52:	7a82                	ld	s5,32(sp)
ffffffffc0201c54:	6b62                	ld	s6,24(sp)
ffffffffc0201c56:	6bc2                	ld	s7,16(sp)
ffffffffc0201c58:	6161                	addi	sp,sp,80
ffffffffc0201c5a:	8082                	ret
ffffffffc0201c5c:	4521                	li	a0,8
ffffffffc0201c5e:	c8afe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201c62:	34fd                	addiw	s1,s1,-1
ffffffffc0201c64:	b759                	j	ffffffffc0201bea <readline+0x38>

ffffffffc0201c66 <sbi_console_putchar>:
ffffffffc0201c66:	4781                	li	a5,0
ffffffffc0201c68:	00004717          	auipc	a4,0x4
ffffffffc0201c6c:	3a073703          	ld	a4,928(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201c70:	88ba                	mv	a7,a4
ffffffffc0201c72:	852a                	mv	a0,a0
ffffffffc0201c74:	85be                	mv	a1,a5
ffffffffc0201c76:	863e                	mv	a2,a5
ffffffffc0201c78:	00000073          	ecall
ffffffffc0201c7c:	87aa                	mv	a5,a0
ffffffffc0201c7e:	8082                	ret

ffffffffc0201c80 <sbi_set_timer>:
ffffffffc0201c80:	4781                	li	a5,0
ffffffffc0201c82:	00005717          	auipc	a4,0x5
ffffffffc0201c86:	82e73703          	ld	a4,-2002(a4) # ffffffffc02064b0 <SBI_SET_TIMER>
ffffffffc0201c8a:	88ba                	mv	a7,a4
ffffffffc0201c8c:	852a                	mv	a0,a0
ffffffffc0201c8e:	85be                	mv	a1,a5
ffffffffc0201c90:	863e                	mv	a2,a5
ffffffffc0201c92:	00000073          	ecall
ffffffffc0201c96:	87aa                	mv	a5,a0
ffffffffc0201c98:	8082                	ret

ffffffffc0201c9a <sbi_console_getchar>:
ffffffffc0201c9a:	4501                	li	a0,0
ffffffffc0201c9c:	00004797          	auipc	a5,0x4
ffffffffc0201ca0:	3647b783          	ld	a5,868(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201ca4:	88be                	mv	a7,a5
ffffffffc0201ca6:	852a                	mv	a0,a0
ffffffffc0201ca8:	85aa                	mv	a1,a0
ffffffffc0201caa:	862a                	mv	a2,a0
ffffffffc0201cac:	00000073          	ecall
ffffffffc0201cb0:	852a                	mv	a0,a0
ffffffffc0201cb2:	2501                	sext.w	a0,a0
ffffffffc0201cb4:	8082                	ret

ffffffffc0201cb6 <sbi_shutdown>:
ffffffffc0201cb6:	4781                	li	a5,0
ffffffffc0201cb8:	00004717          	auipc	a4,0x4
ffffffffc0201cbc:	35873703          	ld	a4,856(a4) # ffffffffc0206010 <SBI_SHUTDOWN>
ffffffffc0201cc0:	88ba                	mv	a7,a4
ffffffffc0201cc2:	853e                	mv	a0,a5
ffffffffc0201cc4:	85be                	mv	a1,a5
ffffffffc0201cc6:	863e                	mv	a2,a5
ffffffffc0201cc8:	00000073          	ecall
ffffffffc0201ccc:	87aa                	mv	a5,a0
ffffffffc0201cce:	8082                	ret
>>>>>>> f432445ac6e7da9fa8425c8f78cb0361b8c5b158