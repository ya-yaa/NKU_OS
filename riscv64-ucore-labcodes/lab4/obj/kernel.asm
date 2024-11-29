
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c020a2b7          	lui	t0,0xc020a
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
ffffffffc020001c:	18029073          	csrw	satp,t0
ffffffffc0200020:	12000073          	sfence.vma
ffffffffc0200024:	c020a137          	lui	sp,0xc020a
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
ffffffffc0200032:	0000b517          	auipc	a0,0xb
ffffffffc0200036:	02e50513          	addi	a0,a0,46 # ffffffffc020b060 <buf>
ffffffffc020003a:	00016617          	auipc	a2,0x16
ffffffffc020003e:	59260613          	addi	a2,a2,1426 # ffffffffc02165cc <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	2af040ef          	jal	ra,ffffffffc0204af8 <memset>
ffffffffc020004e:	4fc000ef          	jal	ra,ffffffffc020054a <cons_init>
ffffffffc0200052:	00005597          	auipc	a1,0x5
ffffffffc0200056:	efe58593          	addi	a1,a1,-258 # ffffffffc0204f50 <etext+0x6>
ffffffffc020005a:	00005517          	auipc	a0,0x5
ffffffffc020005e:	f1650513          	addi	a0,a0,-234 # ffffffffc0204f70 <etext+0x26>
ffffffffc0200062:	06a000ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200066:	1be000ef          	jal	ra,ffffffffc0200224 <print_kerninfo>
ffffffffc020006a:	416030ef          	jal	ra,ffffffffc0203480 <pmm_init>
ffffffffc020006e:	54e000ef          	jal	ra,ffffffffc02005bc <pic_init>
ffffffffc0200072:	5c8000ef          	jal	ra,ffffffffc020063a <idt_init>
ffffffffc0200076:	4d5000ef          	jal	ra,ffffffffc0200d4a <vmm_init>
ffffffffc020007a:	6d2040ef          	jal	ra,ffffffffc020474c <proc_init>
ffffffffc020007e:	424000ef          	jal	ra,ffffffffc02004a2 <ide_init>
ffffffffc0200082:	37f010ef          	jal	ra,ffffffffc0201c00 <swap_init>
ffffffffc0200086:	472000ef          	jal	ra,ffffffffc02004f8 <clock_init>
ffffffffc020008a:	534000ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc020008e:	10d040ef          	jal	ra,ffffffffc020499a <cpu_idle>

ffffffffc0200092 <cputch>:
ffffffffc0200092:	1141                	addi	sp,sp,-16
ffffffffc0200094:	e022                	sd	s0,0(sp)
ffffffffc0200096:	e406                	sd	ra,8(sp)
ffffffffc0200098:	842e                	mv	s0,a1
ffffffffc020009a:	4b2000ef          	jal	ra,ffffffffc020054c <cons_putc>
ffffffffc020009e:	401c                	lw	a5,0(s0)
ffffffffc02000a0:	60a2                	ld	ra,8(sp)
ffffffffc02000a2:	2785                	addiw	a5,a5,1
ffffffffc02000a4:	c01c                	sw	a5,0(s0)
ffffffffc02000a6:	6402                	ld	s0,0(sp)
ffffffffc02000a8:	0141                	addi	sp,sp,16
ffffffffc02000aa:	8082                	ret

ffffffffc02000ac <vcprintf>:
ffffffffc02000ac:	1101                	addi	sp,sp,-32
ffffffffc02000ae:	862a                	mv	a2,a0
ffffffffc02000b0:	86ae                	mv	a3,a1
ffffffffc02000b2:	00000517          	auipc	a0,0x0
ffffffffc02000b6:	fe050513          	addi	a0,a0,-32 # ffffffffc0200092 <cputch>
ffffffffc02000ba:	006c                	addi	a1,sp,12
ffffffffc02000bc:	ec06                	sd	ra,24(sp)
ffffffffc02000be:	c602                	sw	zero,12(sp)
ffffffffc02000c0:	2f3040ef          	jal	ra,ffffffffc0204bb2 <vprintfmt>
ffffffffc02000c4:	60e2                	ld	ra,24(sp)
ffffffffc02000c6:	4532                	lw	a0,12(sp)
ffffffffc02000c8:	6105                	addi	sp,sp,32
ffffffffc02000ca:	8082                	ret

ffffffffc02000cc <cprintf>:
ffffffffc02000cc:	711d                	addi	sp,sp,-96
ffffffffc02000ce:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
ffffffffc02000d2:	8e2a                	mv	t3,a0
ffffffffc02000d4:	f42e                	sd	a1,40(sp)
ffffffffc02000d6:	f832                	sd	a2,48(sp)
ffffffffc02000d8:	fc36                	sd	a3,56(sp)
ffffffffc02000da:	00000517          	auipc	a0,0x0
ffffffffc02000de:	fb850513          	addi	a0,a0,-72 # ffffffffc0200092 <cputch>
ffffffffc02000e2:	004c                	addi	a1,sp,4
ffffffffc02000e4:	869a                	mv	a3,t1
ffffffffc02000e6:	8672                	mv	a2,t3
ffffffffc02000e8:	ec06                	sd	ra,24(sp)
ffffffffc02000ea:	e0ba                	sd	a4,64(sp)
ffffffffc02000ec:	e4be                	sd	a5,72(sp)
ffffffffc02000ee:	e8c2                	sd	a6,80(sp)
ffffffffc02000f0:	ecc6                	sd	a7,88(sp)
ffffffffc02000f2:	e41a                	sd	t1,8(sp)
ffffffffc02000f4:	c202                	sw	zero,4(sp)
ffffffffc02000f6:	2bd040ef          	jal	ra,ffffffffc0204bb2 <vprintfmt>
ffffffffc02000fa:	60e2                	ld	ra,24(sp)
ffffffffc02000fc:	4512                	lw	a0,4(sp)
ffffffffc02000fe:	6125                	addi	sp,sp,96
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <cputchar>:
ffffffffc0200102:	a1a9                	j	ffffffffc020054c <cons_putc>

ffffffffc0200104 <getchar>:
ffffffffc0200104:	1141                	addi	sp,sp,-16
ffffffffc0200106:	e406                	sd	ra,8(sp)
ffffffffc0200108:	478000ef          	jal	ra,ffffffffc0200580 <cons_getc>
ffffffffc020010c:	dd75                	beqz	a0,ffffffffc0200108 <getchar+0x4>
ffffffffc020010e:	60a2                	ld	ra,8(sp)
ffffffffc0200110:	0141                	addi	sp,sp,16
ffffffffc0200112:	8082                	ret

ffffffffc0200114 <readline>:
ffffffffc0200114:	715d                	addi	sp,sp,-80
ffffffffc0200116:	e486                	sd	ra,72(sp)
ffffffffc0200118:	e0a6                	sd	s1,64(sp)
ffffffffc020011a:	fc4a                	sd	s2,56(sp)
ffffffffc020011c:	f84e                	sd	s3,48(sp)
ffffffffc020011e:	f452                	sd	s4,40(sp)
ffffffffc0200120:	f056                	sd	s5,32(sp)
ffffffffc0200122:	ec5a                	sd	s6,24(sp)
ffffffffc0200124:	e85e                	sd	s7,16(sp)
ffffffffc0200126:	c901                	beqz	a0,ffffffffc0200136 <readline+0x22>
ffffffffc0200128:	85aa                	mv	a1,a0
ffffffffc020012a:	00005517          	auipc	a0,0x5
ffffffffc020012e:	e4e50513          	addi	a0,a0,-434 # ffffffffc0204f78 <etext+0x2e>
ffffffffc0200132:	f9bff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200136:	4481                	li	s1,0
ffffffffc0200138:	497d                	li	s2,31
ffffffffc020013a:	49a1                	li	s3,8
ffffffffc020013c:	4aa9                	li	s5,10
ffffffffc020013e:	4b35                	li	s6,13
ffffffffc0200140:	0000bb97          	auipc	s7,0xb
ffffffffc0200144:	f20b8b93          	addi	s7,s7,-224 # ffffffffc020b060 <buf>
ffffffffc0200148:	3fe00a13          	li	s4,1022
ffffffffc020014c:	fb9ff0ef          	jal	ra,ffffffffc0200104 <getchar>
ffffffffc0200150:	00054a63          	bltz	a0,ffffffffc0200164 <readline+0x50>
ffffffffc0200154:	00a95a63          	bge	s2,a0,ffffffffc0200168 <readline+0x54>
ffffffffc0200158:	029a5263          	bge	s4,s1,ffffffffc020017c <readline+0x68>
ffffffffc020015c:	fa9ff0ef          	jal	ra,ffffffffc0200104 <getchar>
ffffffffc0200160:	fe055ae3          	bgez	a0,ffffffffc0200154 <readline+0x40>
ffffffffc0200164:	4501                	li	a0,0
ffffffffc0200166:	a091                	j	ffffffffc02001aa <readline+0x96>
ffffffffc0200168:	03351463          	bne	a0,s3,ffffffffc0200190 <readline+0x7c>
ffffffffc020016c:	e8a9                	bnez	s1,ffffffffc02001be <readline+0xaa>
ffffffffc020016e:	f97ff0ef          	jal	ra,ffffffffc0200104 <getchar>
ffffffffc0200172:	fe0549e3          	bltz	a0,ffffffffc0200164 <readline+0x50>
ffffffffc0200176:	fea959e3          	bge	s2,a0,ffffffffc0200168 <readline+0x54>
ffffffffc020017a:	4481                	li	s1,0
ffffffffc020017c:	e42a                	sd	a0,8(sp)
ffffffffc020017e:	f85ff0ef          	jal	ra,ffffffffc0200102 <cputchar>
ffffffffc0200182:	6522                	ld	a0,8(sp)
ffffffffc0200184:	009b87b3          	add	a5,s7,s1
ffffffffc0200188:	2485                	addiw	s1,s1,1
ffffffffc020018a:	00a78023          	sb	a0,0(a5)
ffffffffc020018e:	bf7d                	j	ffffffffc020014c <readline+0x38>
ffffffffc0200190:	01550463          	beq	a0,s5,ffffffffc0200198 <readline+0x84>
ffffffffc0200194:	fb651ce3          	bne	a0,s6,ffffffffc020014c <readline+0x38>
ffffffffc0200198:	f6bff0ef          	jal	ra,ffffffffc0200102 <cputchar>
ffffffffc020019c:	0000b517          	auipc	a0,0xb
ffffffffc02001a0:	ec450513          	addi	a0,a0,-316 # ffffffffc020b060 <buf>
ffffffffc02001a4:	94aa                	add	s1,s1,a0
ffffffffc02001a6:	00048023          	sb	zero,0(s1)
ffffffffc02001aa:	60a6                	ld	ra,72(sp)
ffffffffc02001ac:	6486                	ld	s1,64(sp)
ffffffffc02001ae:	7962                	ld	s2,56(sp)
ffffffffc02001b0:	79c2                	ld	s3,48(sp)
ffffffffc02001b2:	7a22                	ld	s4,40(sp)
ffffffffc02001b4:	7a82                	ld	s5,32(sp)
ffffffffc02001b6:	6b62                	ld	s6,24(sp)
ffffffffc02001b8:	6bc2                	ld	s7,16(sp)
ffffffffc02001ba:	6161                	addi	sp,sp,80
ffffffffc02001bc:	8082                	ret
ffffffffc02001be:	4521                	li	a0,8
ffffffffc02001c0:	f43ff0ef          	jal	ra,ffffffffc0200102 <cputchar>
ffffffffc02001c4:	34fd                	addiw	s1,s1,-1
ffffffffc02001c6:	b759                	j	ffffffffc020014c <readline+0x38>

ffffffffc02001c8 <__panic>:
ffffffffc02001c8:	00016317          	auipc	t1,0x16
ffffffffc02001cc:	37030313          	addi	t1,t1,880 # ffffffffc0216538 <is_panic>
ffffffffc02001d0:	00032e03          	lw	t3,0(t1)
ffffffffc02001d4:	715d                	addi	sp,sp,-80
ffffffffc02001d6:	ec06                	sd	ra,24(sp)
ffffffffc02001d8:	e822                	sd	s0,16(sp)
ffffffffc02001da:	f436                	sd	a3,40(sp)
ffffffffc02001dc:	f83a                	sd	a4,48(sp)
ffffffffc02001de:	fc3e                	sd	a5,56(sp)
ffffffffc02001e0:	e0c2                	sd	a6,64(sp)
ffffffffc02001e2:	e4c6                	sd	a7,72(sp)
ffffffffc02001e4:	020e1a63          	bnez	t3,ffffffffc0200218 <__panic+0x50>
ffffffffc02001e8:	4785                	li	a5,1
ffffffffc02001ea:	00f32023          	sw	a5,0(t1)
ffffffffc02001ee:	8432                	mv	s0,a2
ffffffffc02001f0:	103c                	addi	a5,sp,40
ffffffffc02001f2:	862e                	mv	a2,a1
ffffffffc02001f4:	85aa                	mv	a1,a0
ffffffffc02001f6:	00005517          	auipc	a0,0x5
ffffffffc02001fa:	d8a50513          	addi	a0,a0,-630 # ffffffffc0204f80 <etext+0x36>
ffffffffc02001fe:	e43e                	sd	a5,8(sp)
ffffffffc0200200:	ecdff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200204:	65a2                	ld	a1,8(sp)
ffffffffc0200206:	8522                	mv	a0,s0
ffffffffc0200208:	ea5ff0ef          	jal	ra,ffffffffc02000ac <vcprintf>
ffffffffc020020c:	00007517          	auipc	a0,0x7
ffffffffc0200210:	84c50513          	addi	a0,a0,-1972 # ffffffffc0206a58 <default_pmm_manager+0x3b8>
ffffffffc0200214:	eb9ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200218:	3ac000ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc020021c:	4501                	li	a0,0
ffffffffc020021e:	130000ef          	jal	ra,ffffffffc020034e <kmonitor>
ffffffffc0200222:	bfed                	j	ffffffffc020021c <__panic+0x54>

ffffffffc0200224 <print_kerninfo>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00005517          	auipc	a0,0x5
ffffffffc020022a:	d7a50513          	addi	a0,a0,-646 # ffffffffc0204fa0 <etext+0x56>
ffffffffc020022e:	e406                	sd	ra,8(sp)
ffffffffc0200230:	e9dff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200234:	00000597          	auipc	a1,0x0
ffffffffc0200238:	dfe58593          	addi	a1,a1,-514 # ffffffffc0200032 <kern_init>
ffffffffc020023c:	00005517          	auipc	a0,0x5
ffffffffc0200240:	d8450513          	addi	a0,a0,-636 # ffffffffc0204fc0 <etext+0x76>
ffffffffc0200244:	e89ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200248:	00005597          	auipc	a1,0x5
ffffffffc020024c:	d0258593          	addi	a1,a1,-766 # ffffffffc0204f4a <etext>
ffffffffc0200250:	00005517          	auipc	a0,0x5
ffffffffc0200254:	d9050513          	addi	a0,a0,-624 # ffffffffc0204fe0 <etext+0x96>
ffffffffc0200258:	e75ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020025c:	0000b597          	auipc	a1,0xb
ffffffffc0200260:	e0458593          	addi	a1,a1,-508 # ffffffffc020b060 <buf>
ffffffffc0200264:	00005517          	auipc	a0,0x5
ffffffffc0200268:	d9c50513          	addi	a0,a0,-612 # ffffffffc0205000 <etext+0xb6>
ffffffffc020026c:	e61ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200270:	00016597          	auipc	a1,0x16
ffffffffc0200274:	35c58593          	addi	a1,a1,860 # ffffffffc02165cc <end>
ffffffffc0200278:	00005517          	auipc	a0,0x5
ffffffffc020027c:	da850513          	addi	a0,a0,-600 # ffffffffc0205020 <etext+0xd6>
ffffffffc0200280:	e4dff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200284:	00016597          	auipc	a1,0x16
ffffffffc0200288:	74758593          	addi	a1,a1,1863 # ffffffffc02169cb <end+0x3ff>
ffffffffc020028c:	00000797          	auipc	a5,0x0
ffffffffc0200290:	da678793          	addi	a5,a5,-602 # ffffffffc0200032 <kern_init>
ffffffffc0200294:	40f587b3          	sub	a5,a1,a5
ffffffffc0200298:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020029c:	60a2                	ld	ra,8(sp)
ffffffffc020029e:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a2:	95be                	add	a1,a1,a5
ffffffffc02002a4:	85a9                	srai	a1,a1,0xa
ffffffffc02002a6:	00005517          	auipc	a0,0x5
ffffffffc02002aa:	d9a50513          	addi	a0,a0,-614 # ffffffffc0205040 <etext+0xf6>
ffffffffc02002ae:	0141                	addi	sp,sp,16
ffffffffc02002b0:	bd31                	j	ffffffffc02000cc <cprintf>

ffffffffc02002b2 <print_stackframe>:
ffffffffc02002b2:	1141                	addi	sp,sp,-16
ffffffffc02002b4:	00005617          	auipc	a2,0x5
ffffffffc02002b8:	dbc60613          	addi	a2,a2,-580 # ffffffffc0205070 <etext+0x126>
ffffffffc02002bc:	04d00593          	li	a1,77
ffffffffc02002c0:	00005517          	auipc	a0,0x5
ffffffffc02002c4:	dc850513          	addi	a0,a0,-568 # ffffffffc0205088 <etext+0x13e>
ffffffffc02002c8:	e406                	sd	ra,8(sp)
ffffffffc02002ca:	effff0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc02002ce <mon_help>:
ffffffffc02002ce:	1141                	addi	sp,sp,-16
ffffffffc02002d0:	00005617          	auipc	a2,0x5
ffffffffc02002d4:	dd060613          	addi	a2,a2,-560 # ffffffffc02050a0 <etext+0x156>
ffffffffc02002d8:	00005597          	auipc	a1,0x5
ffffffffc02002dc:	de858593          	addi	a1,a1,-536 # ffffffffc02050c0 <etext+0x176>
ffffffffc02002e0:	00005517          	auipc	a0,0x5
ffffffffc02002e4:	de850513          	addi	a0,a0,-536 # ffffffffc02050c8 <etext+0x17e>
ffffffffc02002e8:	e406                	sd	ra,8(sp)
ffffffffc02002ea:	de3ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02002ee:	00005617          	auipc	a2,0x5
ffffffffc02002f2:	dea60613          	addi	a2,a2,-534 # ffffffffc02050d8 <etext+0x18e>
ffffffffc02002f6:	00005597          	auipc	a1,0x5
ffffffffc02002fa:	e0a58593          	addi	a1,a1,-502 # ffffffffc0205100 <etext+0x1b6>
ffffffffc02002fe:	00005517          	auipc	a0,0x5
ffffffffc0200302:	dca50513          	addi	a0,a0,-566 # ffffffffc02050c8 <etext+0x17e>
ffffffffc0200306:	dc7ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020030a:	00005617          	auipc	a2,0x5
ffffffffc020030e:	e0660613          	addi	a2,a2,-506 # ffffffffc0205110 <etext+0x1c6>
ffffffffc0200312:	00005597          	auipc	a1,0x5
ffffffffc0200316:	e1e58593          	addi	a1,a1,-482 # ffffffffc0205130 <etext+0x1e6>
ffffffffc020031a:	00005517          	auipc	a0,0x5
ffffffffc020031e:	dae50513          	addi	a0,a0,-594 # ffffffffc02050c8 <etext+0x17e>
ffffffffc0200322:	dabff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200326:	60a2                	ld	ra,8(sp)
ffffffffc0200328:	4501                	li	a0,0
ffffffffc020032a:	0141                	addi	sp,sp,16
ffffffffc020032c:	8082                	ret

ffffffffc020032e <mon_kerninfo>:
ffffffffc020032e:	1141                	addi	sp,sp,-16
ffffffffc0200330:	e406                	sd	ra,8(sp)
ffffffffc0200332:	ef3ff0ef          	jal	ra,ffffffffc0200224 <print_kerninfo>
ffffffffc0200336:	60a2                	ld	ra,8(sp)
ffffffffc0200338:	4501                	li	a0,0
ffffffffc020033a:	0141                	addi	sp,sp,16
ffffffffc020033c:	8082                	ret

ffffffffc020033e <mon_backtrace>:
ffffffffc020033e:	1141                	addi	sp,sp,-16
ffffffffc0200340:	e406                	sd	ra,8(sp)
ffffffffc0200342:	f71ff0ef          	jal	ra,ffffffffc02002b2 <print_stackframe>
ffffffffc0200346:	60a2                	ld	ra,8(sp)
ffffffffc0200348:	4501                	li	a0,0
ffffffffc020034a:	0141                	addi	sp,sp,16
ffffffffc020034c:	8082                	ret

ffffffffc020034e <kmonitor>:
ffffffffc020034e:	7115                	addi	sp,sp,-224
ffffffffc0200350:	ed5e                	sd	s7,152(sp)
ffffffffc0200352:	8baa                	mv	s7,a0
ffffffffc0200354:	00005517          	auipc	a0,0x5
ffffffffc0200358:	dec50513          	addi	a0,a0,-532 # ffffffffc0205140 <etext+0x1f6>
ffffffffc020035c:	ed86                	sd	ra,216(sp)
ffffffffc020035e:	e9a2                	sd	s0,208(sp)
ffffffffc0200360:	e5a6                	sd	s1,200(sp)
ffffffffc0200362:	e1ca                	sd	s2,192(sp)
ffffffffc0200364:	fd4e                	sd	s3,184(sp)
ffffffffc0200366:	f952                	sd	s4,176(sp)
ffffffffc0200368:	f556                	sd	s5,168(sp)
ffffffffc020036a:	f15a                	sd	s6,160(sp)
ffffffffc020036c:	e962                	sd	s8,144(sp)
ffffffffc020036e:	e566                	sd	s9,136(sp)
ffffffffc0200370:	e16a                	sd	s10,128(sp)
ffffffffc0200372:	d5bff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200376:	00005517          	auipc	a0,0x5
ffffffffc020037a:	df250513          	addi	a0,a0,-526 # ffffffffc0205168 <etext+0x21e>
ffffffffc020037e:	d4fff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200382:	000b8563          	beqz	s7,ffffffffc020038c <kmonitor+0x3e>
ffffffffc0200386:	855e                	mv	a0,s7
ffffffffc0200388:	49a000ef          	jal	ra,ffffffffc0200822 <print_trapframe>
ffffffffc020038c:	4501                	li	a0,0
ffffffffc020038e:	4581                	li	a1,0
ffffffffc0200390:	4601                	li	a2,0
ffffffffc0200392:	48a1                	li	a7,8
ffffffffc0200394:	00000073          	ecall
ffffffffc0200398:	00005c17          	auipc	s8,0x5
ffffffffc020039c:	e40c0c13          	addi	s8,s8,-448 # ffffffffc02051d8 <commands>
ffffffffc02003a0:	00005917          	auipc	s2,0x5
ffffffffc02003a4:	df090913          	addi	s2,s2,-528 # ffffffffc0205190 <etext+0x246>
ffffffffc02003a8:	00005497          	auipc	s1,0x5
ffffffffc02003ac:	df048493          	addi	s1,s1,-528 # ffffffffc0205198 <etext+0x24e>
ffffffffc02003b0:	49bd                	li	s3,15
ffffffffc02003b2:	00005b17          	auipc	s6,0x5
ffffffffc02003b6:	deeb0b13          	addi	s6,s6,-530 # ffffffffc02051a0 <etext+0x256>
ffffffffc02003ba:	00005a17          	auipc	s4,0x5
ffffffffc02003be:	d06a0a13          	addi	s4,s4,-762 # ffffffffc02050c0 <etext+0x176>
ffffffffc02003c2:	4a8d                	li	s5,3
ffffffffc02003c4:	854a                	mv	a0,s2
ffffffffc02003c6:	d4fff0ef          	jal	ra,ffffffffc0200114 <readline>
ffffffffc02003ca:	842a                	mv	s0,a0
ffffffffc02003cc:	dd65                	beqz	a0,ffffffffc02003c4 <kmonitor+0x76>
ffffffffc02003ce:	00054583          	lbu	a1,0(a0)
ffffffffc02003d2:	4c81                	li	s9,0
ffffffffc02003d4:	e1bd                	bnez	a1,ffffffffc020043a <kmonitor+0xec>
ffffffffc02003d6:	fe0c87e3          	beqz	s9,ffffffffc02003c4 <kmonitor+0x76>
ffffffffc02003da:	6582                	ld	a1,0(sp)
ffffffffc02003dc:	00005d17          	auipc	s10,0x5
ffffffffc02003e0:	dfcd0d13          	addi	s10,s10,-516 # ffffffffc02051d8 <commands>
ffffffffc02003e4:	8552                	mv	a0,s4
ffffffffc02003e6:	4401                	li	s0,0
ffffffffc02003e8:	0d61                	addi	s10,s10,24
ffffffffc02003ea:	6da040ef          	jal	ra,ffffffffc0204ac4 <strcmp>
ffffffffc02003ee:	c919                	beqz	a0,ffffffffc0200404 <kmonitor+0xb6>
ffffffffc02003f0:	2405                	addiw	s0,s0,1
ffffffffc02003f2:	0b540063          	beq	s0,s5,ffffffffc0200492 <kmonitor+0x144>
ffffffffc02003f6:	000d3503          	ld	a0,0(s10)
ffffffffc02003fa:	6582                	ld	a1,0(sp)
ffffffffc02003fc:	0d61                	addi	s10,s10,24
ffffffffc02003fe:	6c6040ef          	jal	ra,ffffffffc0204ac4 <strcmp>
ffffffffc0200402:	f57d                	bnez	a0,ffffffffc02003f0 <kmonitor+0xa2>
ffffffffc0200404:	00141793          	slli	a5,s0,0x1
ffffffffc0200408:	97a2                	add	a5,a5,s0
ffffffffc020040a:	078e                	slli	a5,a5,0x3
ffffffffc020040c:	97e2                	add	a5,a5,s8
ffffffffc020040e:	6b9c                	ld	a5,16(a5)
ffffffffc0200410:	865e                	mv	a2,s7
ffffffffc0200412:	002c                	addi	a1,sp,8
ffffffffc0200414:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200418:	9782                	jalr	a5
ffffffffc020041a:	fa0555e3          	bgez	a0,ffffffffc02003c4 <kmonitor+0x76>
ffffffffc020041e:	60ee                	ld	ra,216(sp)
ffffffffc0200420:	644e                	ld	s0,208(sp)
ffffffffc0200422:	64ae                	ld	s1,200(sp)
ffffffffc0200424:	690e                	ld	s2,192(sp)
ffffffffc0200426:	79ea                	ld	s3,184(sp)
ffffffffc0200428:	7a4a                	ld	s4,176(sp)
ffffffffc020042a:	7aaa                	ld	s5,168(sp)
ffffffffc020042c:	7b0a                	ld	s6,160(sp)
ffffffffc020042e:	6bea                	ld	s7,152(sp)
ffffffffc0200430:	6c4a                	ld	s8,144(sp)
ffffffffc0200432:	6caa                	ld	s9,136(sp)
ffffffffc0200434:	6d0a                	ld	s10,128(sp)
ffffffffc0200436:	612d                	addi	sp,sp,224
ffffffffc0200438:	8082                	ret
ffffffffc020043a:	8526                	mv	a0,s1
ffffffffc020043c:	6a6040ef          	jal	ra,ffffffffc0204ae2 <strchr>
ffffffffc0200440:	c901                	beqz	a0,ffffffffc0200450 <kmonitor+0x102>
ffffffffc0200442:	00144583          	lbu	a1,1(s0)
ffffffffc0200446:	00040023          	sb	zero,0(s0)
ffffffffc020044a:	0405                	addi	s0,s0,1
ffffffffc020044c:	d5c9                	beqz	a1,ffffffffc02003d6 <kmonitor+0x88>
ffffffffc020044e:	b7f5                	j	ffffffffc020043a <kmonitor+0xec>
ffffffffc0200450:	00044783          	lbu	a5,0(s0)
ffffffffc0200454:	d3c9                	beqz	a5,ffffffffc02003d6 <kmonitor+0x88>
ffffffffc0200456:	033c8963          	beq	s9,s3,ffffffffc0200488 <kmonitor+0x13a>
ffffffffc020045a:	003c9793          	slli	a5,s9,0x3
ffffffffc020045e:	0118                	addi	a4,sp,128
ffffffffc0200460:	97ba                	add	a5,a5,a4
ffffffffc0200462:	f887b023          	sd	s0,-128(a5)
ffffffffc0200466:	00044583          	lbu	a1,0(s0)
ffffffffc020046a:	2c85                	addiw	s9,s9,1
ffffffffc020046c:	e591                	bnez	a1,ffffffffc0200478 <kmonitor+0x12a>
ffffffffc020046e:	b7b5                	j	ffffffffc02003da <kmonitor+0x8c>
ffffffffc0200470:	00144583          	lbu	a1,1(s0)
ffffffffc0200474:	0405                	addi	s0,s0,1
ffffffffc0200476:	d1a5                	beqz	a1,ffffffffc02003d6 <kmonitor+0x88>
ffffffffc0200478:	8526                	mv	a0,s1
ffffffffc020047a:	668040ef          	jal	ra,ffffffffc0204ae2 <strchr>
ffffffffc020047e:	d96d                	beqz	a0,ffffffffc0200470 <kmonitor+0x122>
ffffffffc0200480:	00044583          	lbu	a1,0(s0)
ffffffffc0200484:	d9a9                	beqz	a1,ffffffffc02003d6 <kmonitor+0x88>
ffffffffc0200486:	bf55                	j	ffffffffc020043a <kmonitor+0xec>
ffffffffc0200488:	45c1                	li	a1,16
ffffffffc020048a:	855a                	mv	a0,s6
ffffffffc020048c:	c41ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200490:	b7e9                	j	ffffffffc020045a <kmonitor+0x10c>
ffffffffc0200492:	6582                	ld	a1,0(sp)
ffffffffc0200494:	00005517          	auipc	a0,0x5
ffffffffc0200498:	d2c50513          	addi	a0,a0,-724 # ffffffffc02051c0 <etext+0x276>
ffffffffc020049c:	c31ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02004a0:	b715                	j	ffffffffc02003c4 <kmonitor+0x76>

ffffffffc02004a2 <ide_init>:
ffffffffc02004a2:	8082                	ret

ffffffffc02004a4 <ide_device_valid>:
ffffffffc02004a4:	00253513          	sltiu	a0,a0,2
ffffffffc02004a8:	8082                	ret

ffffffffc02004aa <ide_device_size>:
ffffffffc02004aa:	03800513          	li	a0,56
ffffffffc02004ae:	8082                	ret

ffffffffc02004b0 <ide_read_secs>:
ffffffffc02004b0:	0000b797          	auipc	a5,0xb
ffffffffc02004b4:	fb078793          	addi	a5,a5,-80 # ffffffffc020b460 <ide>
ffffffffc02004b8:	0095959b          	slliw	a1,a1,0x9
ffffffffc02004bc:	1141                	addi	sp,sp,-16
ffffffffc02004be:	8532                	mv	a0,a2
ffffffffc02004c0:	95be                	add	a1,a1,a5
ffffffffc02004c2:	00969613          	slli	a2,a3,0x9
ffffffffc02004c6:	e406                	sd	ra,8(sp)
ffffffffc02004c8:	642040ef          	jal	ra,ffffffffc0204b0a <memcpy>
ffffffffc02004cc:	60a2                	ld	ra,8(sp)
ffffffffc02004ce:	4501                	li	a0,0
ffffffffc02004d0:	0141                	addi	sp,sp,16
ffffffffc02004d2:	8082                	ret

ffffffffc02004d4 <ide_write_secs>:
ffffffffc02004d4:	0095979b          	slliw	a5,a1,0x9
ffffffffc02004d8:	0000b517          	auipc	a0,0xb
ffffffffc02004dc:	f8850513          	addi	a0,a0,-120 # ffffffffc020b460 <ide>
ffffffffc02004e0:	1141                	addi	sp,sp,-16
ffffffffc02004e2:	85b2                	mv	a1,a2
ffffffffc02004e4:	953e                	add	a0,a0,a5
ffffffffc02004e6:	00969613          	slli	a2,a3,0x9
ffffffffc02004ea:	e406                	sd	ra,8(sp)
ffffffffc02004ec:	61e040ef          	jal	ra,ffffffffc0204b0a <memcpy>
ffffffffc02004f0:	60a2                	ld	ra,8(sp)
ffffffffc02004f2:	4501                	li	a0,0
ffffffffc02004f4:	0141                	addi	sp,sp,16
ffffffffc02004f6:	8082                	ret

ffffffffc02004f8 <clock_init>:
ffffffffc02004f8:	67e1                	lui	a5,0x18
ffffffffc02004fa:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004fe:	00016717          	auipc	a4,0x16
ffffffffc0200502:	04f73523          	sd	a5,74(a4) # ffffffffc0216548 <timebase>
ffffffffc0200506:	c0102573          	rdtime	a0
ffffffffc020050a:	4581                	li	a1,0
ffffffffc020050c:	953e                	add	a0,a0,a5
ffffffffc020050e:	4601                	li	a2,0
ffffffffc0200510:	4881                	li	a7,0
ffffffffc0200512:	00000073          	ecall
ffffffffc0200516:	02000793          	li	a5,32
ffffffffc020051a:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020051e:	00005517          	auipc	a0,0x5
ffffffffc0200522:	d0250513          	addi	a0,a0,-766 # ffffffffc0205220 <commands+0x48>
ffffffffc0200526:	00016797          	auipc	a5,0x16
ffffffffc020052a:	0007bd23          	sd	zero,26(a5) # ffffffffc0216540 <ticks>
ffffffffc020052e:	be79                	j	ffffffffc02000cc <cprintf>

ffffffffc0200530 <clock_set_next_event>:
ffffffffc0200530:	c0102573          	rdtime	a0
ffffffffc0200534:	00016797          	auipc	a5,0x16
ffffffffc0200538:	0147b783          	ld	a5,20(a5) # ffffffffc0216548 <timebase>
ffffffffc020053c:	953e                	add	a0,a0,a5
ffffffffc020053e:	4581                	li	a1,0
ffffffffc0200540:	4601                	li	a2,0
ffffffffc0200542:	4881                	li	a7,0
ffffffffc0200544:	00000073          	ecall
ffffffffc0200548:	8082                	ret

ffffffffc020054a <cons_init>:
ffffffffc020054a:	8082                	ret

ffffffffc020054c <cons_putc>:
ffffffffc020054c:	100027f3          	csrr	a5,sstatus
ffffffffc0200550:	8b89                	andi	a5,a5,2
ffffffffc0200552:	0ff57513          	zext.b	a0,a0
ffffffffc0200556:	e799                	bnez	a5,ffffffffc0200564 <cons_putc+0x18>
ffffffffc0200558:	4581                	li	a1,0
ffffffffc020055a:	4601                	li	a2,0
ffffffffc020055c:	4885                	li	a7,1
ffffffffc020055e:	00000073          	ecall
ffffffffc0200562:	8082                	ret
ffffffffc0200564:	1101                	addi	sp,sp,-32
ffffffffc0200566:	ec06                	sd	ra,24(sp)
ffffffffc0200568:	e42a                	sd	a0,8(sp)
ffffffffc020056a:	05a000ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc020056e:	6522                	ld	a0,8(sp)
ffffffffc0200570:	4581                	li	a1,0
ffffffffc0200572:	4601                	li	a2,0
ffffffffc0200574:	4885                	li	a7,1
ffffffffc0200576:	00000073          	ecall
ffffffffc020057a:	60e2                	ld	ra,24(sp)
ffffffffc020057c:	6105                	addi	sp,sp,32
ffffffffc020057e:	a081                	j	ffffffffc02005be <intr_enable>

ffffffffc0200580 <cons_getc>:
ffffffffc0200580:	100027f3          	csrr	a5,sstatus
ffffffffc0200584:	8b89                	andi	a5,a5,2
ffffffffc0200586:	eb89                	bnez	a5,ffffffffc0200598 <cons_getc+0x18>
ffffffffc0200588:	4501                	li	a0,0
ffffffffc020058a:	4581                	li	a1,0
ffffffffc020058c:	4601                	li	a2,0
ffffffffc020058e:	4889                	li	a7,2
ffffffffc0200590:	00000073          	ecall
ffffffffc0200594:	2501                	sext.w	a0,a0
ffffffffc0200596:	8082                	ret
ffffffffc0200598:	1101                	addi	sp,sp,-32
ffffffffc020059a:	ec06                	sd	ra,24(sp)
ffffffffc020059c:	028000ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02005a0:	4501                	li	a0,0
ffffffffc02005a2:	4581                	li	a1,0
ffffffffc02005a4:	4601                	li	a2,0
ffffffffc02005a6:	4889                	li	a7,2
ffffffffc02005a8:	00000073          	ecall
ffffffffc02005ac:	2501                	sext.w	a0,a0
ffffffffc02005ae:	e42a                	sd	a0,8(sp)
ffffffffc02005b0:	00e000ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc02005b4:	60e2                	ld	ra,24(sp)
ffffffffc02005b6:	6522                	ld	a0,8(sp)
ffffffffc02005b8:	6105                	addi	sp,sp,32
ffffffffc02005ba:	8082                	ret

ffffffffc02005bc <pic_init>:
ffffffffc02005bc:	8082                	ret

ffffffffc02005be <intr_enable>:
ffffffffc02005be:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02005c2:	8082                	ret

ffffffffc02005c4 <intr_disable>:
ffffffffc02005c4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02005c8:	8082                	ret

ffffffffc02005ca <pgfault_handler>:
ffffffffc02005ca:	10053783          	ld	a5,256(a0)
ffffffffc02005ce:	1141                	addi	sp,sp,-16
ffffffffc02005d0:	e022                	sd	s0,0(sp)
ffffffffc02005d2:	e406                	sd	ra,8(sp)
ffffffffc02005d4:	1007f793          	andi	a5,a5,256
ffffffffc02005d8:	11053583          	ld	a1,272(a0)
ffffffffc02005dc:	842a                	mv	s0,a0
ffffffffc02005de:	05500613          	li	a2,85
ffffffffc02005e2:	c399                	beqz	a5,ffffffffc02005e8 <pgfault_handler+0x1e>
ffffffffc02005e4:	04b00613          	li	a2,75
ffffffffc02005e8:	11843703          	ld	a4,280(s0)
ffffffffc02005ec:	47bd                	li	a5,15
ffffffffc02005ee:	05700693          	li	a3,87
ffffffffc02005f2:	00f70463          	beq	a4,a5,ffffffffc02005fa <pgfault_handler+0x30>
ffffffffc02005f6:	05200693          	li	a3,82
ffffffffc02005fa:	00005517          	auipc	a0,0x5
ffffffffc02005fe:	c4650513          	addi	a0,a0,-954 # ffffffffc0205240 <commands+0x68>
ffffffffc0200602:	acbff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200606:	00016517          	auipc	a0,0x16
ffffffffc020060a:	f4a53503          	ld	a0,-182(a0) # ffffffffc0216550 <check_mm_struct>
ffffffffc020060e:	c911                	beqz	a0,ffffffffc0200622 <pgfault_handler+0x58>
ffffffffc0200610:	11043603          	ld	a2,272(s0)
ffffffffc0200614:	11842583          	lw	a1,280(s0)
ffffffffc0200618:	6402                	ld	s0,0(sp)
ffffffffc020061a:	60a2                	ld	ra,8(sp)
ffffffffc020061c:	0141                	addi	sp,sp,16
ffffffffc020061e:	5010006f          	j	ffffffffc020131e <do_pgfault>
ffffffffc0200622:	00005617          	auipc	a2,0x5
ffffffffc0200626:	c3e60613          	addi	a2,a2,-962 # ffffffffc0205260 <commands+0x88>
ffffffffc020062a:	06200593          	li	a1,98
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	c4a50513          	addi	a0,a0,-950 # ffffffffc0205278 <commands+0xa0>
ffffffffc0200636:	b93ff0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020063a <idt_init>:
ffffffffc020063a:	14005073          	csrwi	sscratch,0
ffffffffc020063e:	00000797          	auipc	a5,0x0
ffffffffc0200642:	47a78793          	addi	a5,a5,1146 # ffffffffc0200ab8 <__alltraps>
ffffffffc0200646:	10579073          	csrw	stvec,a5
ffffffffc020064a:	000407b7          	lui	a5,0x40
ffffffffc020064e:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200652:	8082                	ret

ffffffffc0200654 <print_regs>:
ffffffffc0200654:	610c                	ld	a1,0(a0)
ffffffffc0200656:	1141                	addi	sp,sp,-16
ffffffffc0200658:	e022                	sd	s0,0(sp)
ffffffffc020065a:	842a                	mv	s0,a0
ffffffffc020065c:	00005517          	auipc	a0,0x5
ffffffffc0200660:	c3450513          	addi	a0,a0,-972 # ffffffffc0205290 <commands+0xb8>
ffffffffc0200664:	e406                	sd	ra,8(sp)
ffffffffc0200666:	a67ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020066a:	640c                	ld	a1,8(s0)
ffffffffc020066c:	00005517          	auipc	a0,0x5
ffffffffc0200670:	c3c50513          	addi	a0,a0,-964 # ffffffffc02052a8 <commands+0xd0>
ffffffffc0200674:	a59ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200678:	680c                	ld	a1,16(s0)
ffffffffc020067a:	00005517          	auipc	a0,0x5
ffffffffc020067e:	c4650513          	addi	a0,a0,-954 # ffffffffc02052c0 <commands+0xe8>
ffffffffc0200682:	a4bff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200686:	6c0c                	ld	a1,24(s0)
ffffffffc0200688:	00005517          	auipc	a0,0x5
ffffffffc020068c:	c5050513          	addi	a0,a0,-944 # ffffffffc02052d8 <commands+0x100>
ffffffffc0200690:	a3dff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200694:	700c                	ld	a1,32(s0)
ffffffffc0200696:	00005517          	auipc	a0,0x5
ffffffffc020069a:	c5a50513          	addi	a0,a0,-934 # ffffffffc02052f0 <commands+0x118>
ffffffffc020069e:	a2fff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006a2:	740c                	ld	a1,40(s0)
ffffffffc02006a4:	00005517          	auipc	a0,0x5
ffffffffc02006a8:	c6450513          	addi	a0,a0,-924 # ffffffffc0205308 <commands+0x130>
ffffffffc02006ac:	a21ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006b0:	780c                	ld	a1,48(s0)
ffffffffc02006b2:	00005517          	auipc	a0,0x5
ffffffffc02006b6:	c6e50513          	addi	a0,a0,-914 # ffffffffc0205320 <commands+0x148>
ffffffffc02006ba:	a13ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006be:	7c0c                	ld	a1,56(s0)
ffffffffc02006c0:	00005517          	auipc	a0,0x5
ffffffffc02006c4:	c7850513          	addi	a0,a0,-904 # ffffffffc0205338 <commands+0x160>
ffffffffc02006c8:	a05ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006cc:	602c                	ld	a1,64(s0)
ffffffffc02006ce:	00005517          	auipc	a0,0x5
ffffffffc02006d2:	c8250513          	addi	a0,a0,-894 # ffffffffc0205350 <commands+0x178>
ffffffffc02006d6:	9f7ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006da:	642c                	ld	a1,72(s0)
ffffffffc02006dc:	00005517          	auipc	a0,0x5
ffffffffc02006e0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0205368 <commands+0x190>
ffffffffc02006e4:	9e9ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006e8:	682c                	ld	a1,80(s0)
ffffffffc02006ea:	00005517          	auipc	a0,0x5
ffffffffc02006ee:	c9650513          	addi	a0,a0,-874 # ffffffffc0205380 <commands+0x1a8>
ffffffffc02006f2:	9dbff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02006f6:	6c2c                	ld	a1,88(s0)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	ca050513          	addi	a0,a0,-864 # ffffffffc0205398 <commands+0x1c0>
ffffffffc0200700:	9cdff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200704:	702c                	ld	a1,96(s0)
ffffffffc0200706:	00005517          	auipc	a0,0x5
ffffffffc020070a:	caa50513          	addi	a0,a0,-854 # ffffffffc02053b0 <commands+0x1d8>
ffffffffc020070e:	9bfff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200712:	742c                	ld	a1,104(s0)
ffffffffc0200714:	00005517          	auipc	a0,0x5
ffffffffc0200718:	cb450513          	addi	a0,a0,-844 # ffffffffc02053c8 <commands+0x1f0>
ffffffffc020071c:	9b1ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200720:	782c                	ld	a1,112(s0)
ffffffffc0200722:	00005517          	auipc	a0,0x5
ffffffffc0200726:	cbe50513          	addi	a0,a0,-834 # ffffffffc02053e0 <commands+0x208>
ffffffffc020072a:	9a3ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020072e:	7c2c                	ld	a1,120(s0)
ffffffffc0200730:	00005517          	auipc	a0,0x5
ffffffffc0200734:	cc850513          	addi	a0,a0,-824 # ffffffffc02053f8 <commands+0x220>
ffffffffc0200738:	995ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020073c:	604c                	ld	a1,128(s0)
ffffffffc020073e:	00005517          	auipc	a0,0x5
ffffffffc0200742:	cd250513          	addi	a0,a0,-814 # ffffffffc0205410 <commands+0x238>
ffffffffc0200746:	987ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020074a:	644c                	ld	a1,136(s0)
ffffffffc020074c:	00005517          	auipc	a0,0x5
ffffffffc0200750:	cdc50513          	addi	a0,a0,-804 # ffffffffc0205428 <commands+0x250>
ffffffffc0200754:	979ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200758:	684c                	ld	a1,144(s0)
ffffffffc020075a:	00005517          	auipc	a0,0x5
ffffffffc020075e:	ce650513          	addi	a0,a0,-794 # ffffffffc0205440 <commands+0x268>
ffffffffc0200762:	96bff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200766:	6c4c                	ld	a1,152(s0)
ffffffffc0200768:	00005517          	auipc	a0,0x5
ffffffffc020076c:	cf050513          	addi	a0,a0,-784 # ffffffffc0205458 <commands+0x280>
ffffffffc0200770:	95dff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200774:	704c                	ld	a1,160(s0)
ffffffffc0200776:	00005517          	auipc	a0,0x5
ffffffffc020077a:	cfa50513          	addi	a0,a0,-774 # ffffffffc0205470 <commands+0x298>
ffffffffc020077e:	94fff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200782:	744c                	ld	a1,168(s0)
ffffffffc0200784:	00005517          	auipc	a0,0x5
ffffffffc0200788:	d0450513          	addi	a0,a0,-764 # ffffffffc0205488 <commands+0x2b0>
ffffffffc020078c:	941ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200790:	784c                	ld	a1,176(s0)
ffffffffc0200792:	00005517          	auipc	a0,0x5
ffffffffc0200796:	d0e50513          	addi	a0,a0,-754 # ffffffffc02054a0 <commands+0x2c8>
ffffffffc020079a:	933ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020079e:	7c4c                	ld	a1,184(s0)
ffffffffc02007a0:	00005517          	auipc	a0,0x5
ffffffffc02007a4:	d1850513          	addi	a0,a0,-744 # ffffffffc02054b8 <commands+0x2e0>
ffffffffc02007a8:	925ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007ac:	606c                	ld	a1,192(s0)
ffffffffc02007ae:	00005517          	auipc	a0,0x5
ffffffffc02007b2:	d2250513          	addi	a0,a0,-734 # ffffffffc02054d0 <commands+0x2f8>
ffffffffc02007b6:	917ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007ba:	646c                	ld	a1,200(s0)
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	d2c50513          	addi	a0,a0,-724 # ffffffffc02054e8 <commands+0x310>
ffffffffc02007c4:	909ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007c8:	686c                	ld	a1,208(s0)
ffffffffc02007ca:	00005517          	auipc	a0,0x5
ffffffffc02007ce:	d3650513          	addi	a0,a0,-714 # ffffffffc0205500 <commands+0x328>
ffffffffc02007d2:	8fbff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007d6:	6c6c                	ld	a1,216(s0)
ffffffffc02007d8:	00005517          	auipc	a0,0x5
ffffffffc02007dc:	d4050513          	addi	a0,a0,-704 # ffffffffc0205518 <commands+0x340>
ffffffffc02007e0:	8edff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007e4:	706c                	ld	a1,224(s0)
ffffffffc02007e6:	00005517          	auipc	a0,0x5
ffffffffc02007ea:	d4a50513          	addi	a0,a0,-694 # ffffffffc0205530 <commands+0x358>
ffffffffc02007ee:	8dfff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02007f2:	746c                	ld	a1,232(s0)
ffffffffc02007f4:	00005517          	auipc	a0,0x5
ffffffffc02007f8:	d5450513          	addi	a0,a0,-684 # ffffffffc0205548 <commands+0x370>
ffffffffc02007fc:	8d1ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200800:	786c                	ld	a1,240(s0)
ffffffffc0200802:	00005517          	auipc	a0,0x5
ffffffffc0200806:	d5e50513          	addi	a0,a0,-674 # ffffffffc0205560 <commands+0x388>
ffffffffc020080a:	8c3ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020080e:	7c6c                	ld	a1,248(s0)
ffffffffc0200810:	6402                	ld	s0,0(sp)
ffffffffc0200812:	60a2                	ld	ra,8(sp)
ffffffffc0200814:	00005517          	auipc	a0,0x5
ffffffffc0200818:	d6450513          	addi	a0,a0,-668 # ffffffffc0205578 <commands+0x3a0>
ffffffffc020081c:	0141                	addi	sp,sp,16
ffffffffc020081e:	8afff06f          	j	ffffffffc02000cc <cprintf>

ffffffffc0200822 <print_trapframe>:
ffffffffc0200822:	1141                	addi	sp,sp,-16
ffffffffc0200824:	e022                	sd	s0,0(sp)
ffffffffc0200826:	85aa                	mv	a1,a0
ffffffffc0200828:	842a                	mv	s0,a0
ffffffffc020082a:	00005517          	auipc	a0,0x5
ffffffffc020082e:	d6650513          	addi	a0,a0,-666 # ffffffffc0205590 <commands+0x3b8>
ffffffffc0200832:	e406                	sd	ra,8(sp)
ffffffffc0200834:	899ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200838:	8522                	mv	a0,s0
ffffffffc020083a:	e1bff0ef          	jal	ra,ffffffffc0200654 <print_regs>
ffffffffc020083e:	10043583          	ld	a1,256(s0)
ffffffffc0200842:	00005517          	auipc	a0,0x5
ffffffffc0200846:	d6650513          	addi	a0,a0,-666 # ffffffffc02055a8 <commands+0x3d0>
ffffffffc020084a:	883ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020084e:	10843583          	ld	a1,264(s0)
ffffffffc0200852:	00005517          	auipc	a0,0x5
ffffffffc0200856:	d6e50513          	addi	a0,a0,-658 # ffffffffc02055c0 <commands+0x3e8>
ffffffffc020085a:	873ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020085e:	11043583          	ld	a1,272(s0)
ffffffffc0200862:	00005517          	auipc	a0,0x5
ffffffffc0200866:	d7650513          	addi	a0,a0,-650 # ffffffffc02055d8 <commands+0x400>
ffffffffc020086a:	863ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020086e:	11843583          	ld	a1,280(s0)
ffffffffc0200872:	6402                	ld	s0,0(sp)
ffffffffc0200874:	60a2                	ld	ra,8(sp)
ffffffffc0200876:	00005517          	auipc	a0,0x5
ffffffffc020087a:	d7a50513          	addi	a0,a0,-646 # ffffffffc02055f0 <commands+0x418>
ffffffffc020087e:	0141                	addi	sp,sp,16
ffffffffc0200880:	84dff06f          	j	ffffffffc02000cc <cprintf>

ffffffffc0200884 <interrupt_handler>:
ffffffffc0200884:	11853783          	ld	a5,280(a0)
ffffffffc0200888:	472d                	li	a4,11
ffffffffc020088a:	0786                	slli	a5,a5,0x1
ffffffffc020088c:	8385                	srli	a5,a5,0x1
ffffffffc020088e:	06f76c63          	bltu	a4,a5,ffffffffc0200906 <interrupt_handler+0x82>
ffffffffc0200892:	00005717          	auipc	a4,0x5
ffffffffc0200896:	e2670713          	addi	a4,a4,-474 # ffffffffc02056b8 <commands+0x4e0>
ffffffffc020089a:	078a                	slli	a5,a5,0x2
ffffffffc020089c:	97ba                	add	a5,a5,a4
ffffffffc020089e:	439c                	lw	a5,0(a5)
ffffffffc02008a0:	97ba                	add	a5,a5,a4
ffffffffc02008a2:	8782                	jr	a5
ffffffffc02008a4:	00005517          	auipc	a0,0x5
ffffffffc02008a8:	dc450513          	addi	a0,a0,-572 # ffffffffc0205668 <commands+0x490>
ffffffffc02008ac:	821ff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc02008b0:	00005517          	auipc	a0,0x5
ffffffffc02008b4:	d9850513          	addi	a0,a0,-616 # ffffffffc0205648 <commands+0x470>
ffffffffc02008b8:	815ff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc02008bc:	00005517          	auipc	a0,0x5
ffffffffc02008c0:	d4c50513          	addi	a0,a0,-692 # ffffffffc0205608 <commands+0x430>
ffffffffc02008c4:	809ff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc02008c8:	00005517          	auipc	a0,0x5
ffffffffc02008cc:	d6050513          	addi	a0,a0,-672 # ffffffffc0205628 <commands+0x450>
ffffffffc02008d0:	ffcff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc02008d4:	1141                	addi	sp,sp,-16
ffffffffc02008d6:	e406                	sd	ra,8(sp)
ffffffffc02008d8:	c59ff0ef          	jal	ra,ffffffffc0200530 <clock_set_next_event>
ffffffffc02008dc:	00016697          	auipc	a3,0x16
ffffffffc02008e0:	c6468693          	addi	a3,a3,-924 # ffffffffc0216540 <ticks>
ffffffffc02008e4:	629c                	ld	a5,0(a3)
ffffffffc02008e6:	06400713          	li	a4,100
ffffffffc02008ea:	0785                	addi	a5,a5,1
ffffffffc02008ec:	02e7f733          	remu	a4,a5,a4
ffffffffc02008f0:	e29c                	sd	a5,0(a3)
ffffffffc02008f2:	cb19                	beqz	a4,ffffffffc0200908 <interrupt_handler+0x84>
ffffffffc02008f4:	60a2                	ld	ra,8(sp)
ffffffffc02008f6:	0141                	addi	sp,sp,16
ffffffffc02008f8:	8082                	ret
ffffffffc02008fa:	00005517          	auipc	a0,0x5
ffffffffc02008fe:	d9e50513          	addi	a0,a0,-610 # ffffffffc0205698 <commands+0x4c0>
ffffffffc0200902:	fcaff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc0200906:	bf31                	j	ffffffffc0200822 <print_trapframe>
ffffffffc0200908:	60a2                	ld	ra,8(sp)
ffffffffc020090a:	06400593          	li	a1,100
ffffffffc020090e:	00005517          	auipc	a0,0x5
ffffffffc0200912:	d7a50513          	addi	a0,a0,-646 # ffffffffc0205688 <commands+0x4b0>
ffffffffc0200916:	0141                	addi	sp,sp,16
ffffffffc0200918:	fb4ff06f          	j	ffffffffc02000cc <cprintf>

ffffffffc020091c <exception_handler>:
ffffffffc020091c:	11853783          	ld	a5,280(a0)
ffffffffc0200920:	1101                	addi	sp,sp,-32
ffffffffc0200922:	e822                	sd	s0,16(sp)
ffffffffc0200924:	ec06                	sd	ra,24(sp)
ffffffffc0200926:	e426                	sd	s1,8(sp)
ffffffffc0200928:	473d                	li	a4,15
ffffffffc020092a:	842a                	mv	s0,a0
ffffffffc020092c:	14f76a63          	bltu	a4,a5,ffffffffc0200a80 <exception_handler+0x164>
ffffffffc0200930:	00005717          	auipc	a4,0x5
ffffffffc0200934:	f7070713          	addi	a4,a4,-144 # ffffffffc02058a0 <commands+0x6c8>
ffffffffc0200938:	078a                	slli	a5,a5,0x2
ffffffffc020093a:	97ba                	add	a5,a5,a4
ffffffffc020093c:	439c                	lw	a5,0(a5)
ffffffffc020093e:	97ba                	add	a5,a5,a4
ffffffffc0200940:	8782                	jr	a5
ffffffffc0200942:	00005517          	auipc	a0,0x5
ffffffffc0200946:	f4650513          	addi	a0,a0,-186 # ffffffffc0205888 <commands+0x6b0>
ffffffffc020094a:	f82ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020094e:	8522                	mv	a0,s0
ffffffffc0200950:	c7bff0ef          	jal	ra,ffffffffc02005ca <pgfault_handler>
ffffffffc0200954:	84aa                	mv	s1,a0
ffffffffc0200956:	12051b63          	bnez	a0,ffffffffc0200a8c <exception_handler+0x170>
ffffffffc020095a:	60e2                	ld	ra,24(sp)
ffffffffc020095c:	6442                	ld	s0,16(sp)
ffffffffc020095e:	64a2                	ld	s1,8(sp)
ffffffffc0200960:	6105                	addi	sp,sp,32
ffffffffc0200962:	8082                	ret
ffffffffc0200964:	00005517          	auipc	a0,0x5
ffffffffc0200968:	d8450513          	addi	a0,a0,-636 # ffffffffc02056e8 <commands+0x510>
ffffffffc020096c:	6442                	ld	s0,16(sp)
ffffffffc020096e:	60e2                	ld	ra,24(sp)
ffffffffc0200970:	64a2                	ld	s1,8(sp)
ffffffffc0200972:	6105                	addi	sp,sp,32
ffffffffc0200974:	f58ff06f          	j	ffffffffc02000cc <cprintf>
ffffffffc0200978:	00005517          	auipc	a0,0x5
ffffffffc020097c:	d9050513          	addi	a0,a0,-624 # ffffffffc0205708 <commands+0x530>
ffffffffc0200980:	b7f5                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200982:	00005517          	auipc	a0,0x5
ffffffffc0200986:	da650513          	addi	a0,a0,-602 # ffffffffc0205728 <commands+0x550>
ffffffffc020098a:	b7cd                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc020098c:	00005517          	auipc	a0,0x5
ffffffffc0200990:	db450513          	addi	a0,a0,-588 # ffffffffc0205740 <commands+0x568>
ffffffffc0200994:	bfe1                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200996:	00005517          	auipc	a0,0x5
ffffffffc020099a:	dba50513          	addi	a0,a0,-582 # ffffffffc0205750 <commands+0x578>
ffffffffc020099e:	b7f9                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	dd050513          	addi	a0,a0,-560 # ffffffffc0205770 <commands+0x598>
ffffffffc02009a8:	f24ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02009ac:	8522                	mv	a0,s0
ffffffffc02009ae:	c1dff0ef          	jal	ra,ffffffffc02005ca <pgfault_handler>
ffffffffc02009b2:	84aa                	mv	s1,a0
ffffffffc02009b4:	d15d                	beqz	a0,ffffffffc020095a <exception_handler+0x3e>
ffffffffc02009b6:	8522                	mv	a0,s0
ffffffffc02009b8:	e6bff0ef          	jal	ra,ffffffffc0200822 <print_trapframe>
ffffffffc02009bc:	86a6                	mv	a3,s1
ffffffffc02009be:	00005617          	auipc	a2,0x5
ffffffffc02009c2:	dca60613          	addi	a2,a2,-566 # ffffffffc0205788 <commands+0x5b0>
ffffffffc02009c6:	0b300593          	li	a1,179
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0205278 <commands+0xa0>
ffffffffc02009d2:	ff6ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02009d6:	00005517          	auipc	a0,0x5
ffffffffc02009da:	dd250513          	addi	a0,a0,-558 # ffffffffc02057a8 <commands+0x5d0>
ffffffffc02009de:	b779                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc02009e0:	00005517          	auipc	a0,0x5
ffffffffc02009e4:	de050513          	addi	a0,a0,-544 # ffffffffc02057c0 <commands+0x5e8>
ffffffffc02009e8:	ee4ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02009ec:	8522                	mv	a0,s0
ffffffffc02009ee:	bddff0ef          	jal	ra,ffffffffc02005ca <pgfault_handler>
ffffffffc02009f2:	84aa                	mv	s1,a0
ffffffffc02009f4:	d13d                	beqz	a0,ffffffffc020095a <exception_handler+0x3e>
ffffffffc02009f6:	8522                	mv	a0,s0
ffffffffc02009f8:	e2bff0ef          	jal	ra,ffffffffc0200822 <print_trapframe>
ffffffffc02009fc:	86a6                	mv	a3,s1
ffffffffc02009fe:	00005617          	auipc	a2,0x5
ffffffffc0200a02:	d8a60613          	addi	a2,a2,-630 # ffffffffc0205788 <commands+0x5b0>
ffffffffc0200a06:	0bd00593          	li	a1,189
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	86e50513          	addi	a0,a0,-1938 # ffffffffc0205278 <commands+0xa0>
ffffffffc0200a12:	fb6ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	dc250513          	addi	a0,a0,-574 # ffffffffc02057d8 <commands+0x600>
ffffffffc0200a1e:	b7b9                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200a20:	00005517          	auipc	a0,0x5
ffffffffc0200a24:	dd850513          	addi	a0,a0,-552 # ffffffffc02057f8 <commands+0x620>
ffffffffc0200a28:	b791                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200a2a:	00005517          	auipc	a0,0x5
ffffffffc0200a2e:	dee50513          	addi	a0,a0,-530 # ffffffffc0205818 <commands+0x640>
ffffffffc0200a32:	bf2d                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	e0450513          	addi	a0,a0,-508 # ffffffffc0205838 <commands+0x660>
ffffffffc0200a3c:	bf05                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200a3e:	00005517          	auipc	a0,0x5
ffffffffc0200a42:	e1a50513          	addi	a0,a0,-486 # ffffffffc0205858 <commands+0x680>
ffffffffc0200a46:	b71d                	j	ffffffffc020096c <exception_handler+0x50>
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	e2850513          	addi	a0,a0,-472 # ffffffffc0205870 <commands+0x698>
ffffffffc0200a50:	e7cff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200a54:	8522                	mv	a0,s0
ffffffffc0200a56:	b75ff0ef          	jal	ra,ffffffffc02005ca <pgfault_handler>
ffffffffc0200a5a:	84aa                	mv	s1,a0
ffffffffc0200a5c:	ee050fe3          	beqz	a0,ffffffffc020095a <exception_handler+0x3e>
ffffffffc0200a60:	8522                	mv	a0,s0
ffffffffc0200a62:	dc1ff0ef          	jal	ra,ffffffffc0200822 <print_trapframe>
ffffffffc0200a66:	86a6                	mv	a3,s1
ffffffffc0200a68:	00005617          	auipc	a2,0x5
ffffffffc0200a6c:	d2060613          	addi	a2,a2,-736 # ffffffffc0205788 <commands+0x5b0>
ffffffffc0200a70:	0d300593          	li	a1,211
ffffffffc0200a74:	00005517          	auipc	a0,0x5
ffffffffc0200a78:	80450513          	addi	a0,a0,-2044 # ffffffffc0205278 <commands+0xa0>
ffffffffc0200a7c:	f4cff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200a80:	8522                	mv	a0,s0
ffffffffc0200a82:	6442                	ld	s0,16(sp)
ffffffffc0200a84:	60e2                	ld	ra,24(sp)
ffffffffc0200a86:	64a2                	ld	s1,8(sp)
ffffffffc0200a88:	6105                	addi	sp,sp,32
ffffffffc0200a8a:	bb61                	j	ffffffffc0200822 <print_trapframe>
ffffffffc0200a8c:	8522                	mv	a0,s0
ffffffffc0200a8e:	d95ff0ef          	jal	ra,ffffffffc0200822 <print_trapframe>
ffffffffc0200a92:	86a6                	mv	a3,s1
ffffffffc0200a94:	00005617          	auipc	a2,0x5
ffffffffc0200a98:	cf460613          	addi	a2,a2,-780 # ffffffffc0205788 <commands+0x5b0>
ffffffffc0200a9c:	0da00593          	li	a1,218
ffffffffc0200aa0:	00004517          	auipc	a0,0x4
ffffffffc0200aa4:	7d850513          	addi	a0,a0,2008 # ffffffffc0205278 <commands+0xa0>
ffffffffc0200aa8:	f20ff0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0200aac <trap>:
ffffffffc0200aac:	11853783          	ld	a5,280(a0)
ffffffffc0200ab0:	0007c363          	bltz	a5,ffffffffc0200ab6 <trap+0xa>
ffffffffc0200ab4:	b5a5                	j	ffffffffc020091c <exception_handler>
ffffffffc0200ab6:	b3f9                	j	ffffffffc0200884 <interrupt_handler>

ffffffffc0200ab8 <__alltraps>:
ffffffffc0200ab8:	14011073          	csrw	sscratch,sp
ffffffffc0200abc:	712d                	addi	sp,sp,-288
ffffffffc0200abe:	e406                	sd	ra,8(sp)
ffffffffc0200ac0:	ec0e                	sd	gp,24(sp)
ffffffffc0200ac2:	f012                	sd	tp,32(sp)
ffffffffc0200ac4:	f416                	sd	t0,40(sp)
ffffffffc0200ac6:	f81a                	sd	t1,48(sp)
ffffffffc0200ac8:	fc1e                	sd	t2,56(sp)
ffffffffc0200aca:	e0a2                	sd	s0,64(sp)
ffffffffc0200acc:	e4a6                	sd	s1,72(sp)
ffffffffc0200ace:	e8aa                	sd	a0,80(sp)
ffffffffc0200ad0:	ecae                	sd	a1,88(sp)
ffffffffc0200ad2:	f0b2                	sd	a2,96(sp)
ffffffffc0200ad4:	f4b6                	sd	a3,104(sp)
ffffffffc0200ad6:	f8ba                	sd	a4,112(sp)
ffffffffc0200ad8:	fcbe                	sd	a5,120(sp)
ffffffffc0200ada:	e142                	sd	a6,128(sp)
ffffffffc0200adc:	e546                	sd	a7,136(sp)
ffffffffc0200ade:	e94a                	sd	s2,144(sp)
ffffffffc0200ae0:	ed4e                	sd	s3,152(sp)
ffffffffc0200ae2:	f152                	sd	s4,160(sp)
ffffffffc0200ae4:	f556                	sd	s5,168(sp)
ffffffffc0200ae6:	f95a                	sd	s6,176(sp)
ffffffffc0200ae8:	fd5e                	sd	s7,184(sp)
ffffffffc0200aea:	e1e2                	sd	s8,192(sp)
ffffffffc0200aec:	e5e6                	sd	s9,200(sp)
ffffffffc0200aee:	e9ea                	sd	s10,208(sp)
ffffffffc0200af0:	edee                	sd	s11,216(sp)
ffffffffc0200af2:	f1f2                	sd	t3,224(sp)
ffffffffc0200af4:	f5f6                	sd	t4,232(sp)
ffffffffc0200af6:	f9fa                	sd	t5,240(sp)
ffffffffc0200af8:	fdfe                	sd	t6,248(sp)
ffffffffc0200afa:	14002473          	csrr	s0,sscratch
ffffffffc0200afe:	100024f3          	csrr	s1,sstatus
ffffffffc0200b02:	14102973          	csrr	s2,sepc
ffffffffc0200b06:	143029f3          	csrr	s3,stval
ffffffffc0200b0a:	14202a73          	csrr	s4,scause
ffffffffc0200b0e:	e822                	sd	s0,16(sp)
ffffffffc0200b10:	e226                	sd	s1,256(sp)
ffffffffc0200b12:	e64a                	sd	s2,264(sp)
ffffffffc0200b14:	ea4e                	sd	s3,272(sp)
ffffffffc0200b16:	ee52                	sd	s4,280(sp)
ffffffffc0200b18:	850a                	mv	a0,sp
ffffffffc0200b1a:	f93ff0ef          	jal	ra,ffffffffc0200aac <trap>

ffffffffc0200b1e <__trapret>:
ffffffffc0200b1e:	6492                	ld	s1,256(sp)
ffffffffc0200b20:	6932                	ld	s2,264(sp)
ffffffffc0200b22:	10049073          	csrw	sstatus,s1
ffffffffc0200b26:	14191073          	csrw	sepc,s2
ffffffffc0200b2a:	60a2                	ld	ra,8(sp)
ffffffffc0200b2c:	61e2                	ld	gp,24(sp)
ffffffffc0200b2e:	7202                	ld	tp,32(sp)
ffffffffc0200b30:	72a2                	ld	t0,40(sp)
ffffffffc0200b32:	7342                	ld	t1,48(sp)
ffffffffc0200b34:	73e2                	ld	t2,56(sp)
ffffffffc0200b36:	6406                	ld	s0,64(sp)
ffffffffc0200b38:	64a6                	ld	s1,72(sp)
ffffffffc0200b3a:	6546                	ld	a0,80(sp)
ffffffffc0200b3c:	65e6                	ld	a1,88(sp)
ffffffffc0200b3e:	7606                	ld	a2,96(sp)
ffffffffc0200b40:	76a6                	ld	a3,104(sp)
ffffffffc0200b42:	7746                	ld	a4,112(sp)
ffffffffc0200b44:	77e6                	ld	a5,120(sp)
ffffffffc0200b46:	680a                	ld	a6,128(sp)
ffffffffc0200b48:	68aa                	ld	a7,136(sp)
ffffffffc0200b4a:	694a                	ld	s2,144(sp)
ffffffffc0200b4c:	69ea                	ld	s3,152(sp)
ffffffffc0200b4e:	7a0a                	ld	s4,160(sp)
ffffffffc0200b50:	7aaa                	ld	s5,168(sp)
ffffffffc0200b52:	7b4a                	ld	s6,176(sp)
ffffffffc0200b54:	7bea                	ld	s7,184(sp)
ffffffffc0200b56:	6c0e                	ld	s8,192(sp)
ffffffffc0200b58:	6cae                	ld	s9,200(sp)
ffffffffc0200b5a:	6d4e                	ld	s10,208(sp)
ffffffffc0200b5c:	6dee                	ld	s11,216(sp)
ffffffffc0200b5e:	7e0e                	ld	t3,224(sp)
ffffffffc0200b60:	7eae                	ld	t4,232(sp)
ffffffffc0200b62:	7f4e                	ld	t5,240(sp)
ffffffffc0200b64:	7fee                	ld	t6,248(sp)
ffffffffc0200b66:	6142                	ld	sp,16(sp)
ffffffffc0200b68:	10200073          	sret

ffffffffc0200b6c <forkrets>:
ffffffffc0200b6c:	812a                	mv	sp,a0
ffffffffc0200b6e:	bf45                	j	ffffffffc0200b1e <__trapret>
	...

ffffffffc0200b72 <check_vma_overlap.part.0>:
ffffffffc0200b72:	1141                	addi	sp,sp,-16
ffffffffc0200b74:	00005697          	auipc	a3,0x5
ffffffffc0200b78:	d6c68693          	addi	a3,a3,-660 # ffffffffc02058e0 <commands+0x708>
ffffffffc0200b7c:	00005617          	auipc	a2,0x5
ffffffffc0200b80:	d8460613          	addi	a2,a2,-636 # ffffffffc0205900 <commands+0x728>
ffffffffc0200b84:	07e00593          	li	a1,126
ffffffffc0200b88:	00005517          	auipc	a0,0x5
ffffffffc0200b8c:	d9050513          	addi	a0,a0,-624 # ffffffffc0205918 <commands+0x740>
ffffffffc0200b90:	e406                	sd	ra,8(sp)
ffffffffc0200b92:	e36ff0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0200b96 <mm_create>:
ffffffffc0200b96:	1141                	addi	sp,sp,-16
ffffffffc0200b98:	03000513          	li	a0,48
ffffffffc0200b9c:	e022                	sd	s0,0(sp)
ffffffffc0200b9e:	e406                	sd	ra,8(sp)
ffffffffc0200ba0:	69f000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200ba4:	842a                	mv	s0,a0
ffffffffc0200ba6:	c105                	beqz	a0,ffffffffc0200bc6 <mm_create+0x30>
ffffffffc0200ba8:	e408                	sd	a0,8(s0)
ffffffffc0200baa:	e008                	sd	a0,0(s0)
ffffffffc0200bac:	00053823          	sd	zero,16(a0)
ffffffffc0200bb0:	00053c23          	sd	zero,24(a0)
ffffffffc0200bb4:	02052023          	sw	zero,32(a0)
ffffffffc0200bb8:	00016797          	auipc	a5,0x16
ffffffffc0200bbc:	9c07a783          	lw	a5,-1600(a5) # ffffffffc0216578 <swap_init_ok>
ffffffffc0200bc0:	eb81                	bnez	a5,ffffffffc0200bd0 <mm_create+0x3a>
ffffffffc0200bc2:	02053423          	sd	zero,40(a0)
ffffffffc0200bc6:	60a2                	ld	ra,8(sp)
ffffffffc0200bc8:	8522                	mv	a0,s0
ffffffffc0200bca:	6402                	ld	s0,0(sp)
ffffffffc0200bcc:	0141                	addi	sp,sp,16
ffffffffc0200bce:	8082                	ret
ffffffffc0200bd0:	76a010ef          	jal	ra,ffffffffc020233a <swap_init_mm>
ffffffffc0200bd4:	60a2                	ld	ra,8(sp)
ffffffffc0200bd6:	8522                	mv	a0,s0
ffffffffc0200bd8:	6402                	ld	s0,0(sp)
ffffffffc0200bda:	0141                	addi	sp,sp,16
ffffffffc0200bdc:	8082                	ret

ffffffffc0200bde <vma_create>:
ffffffffc0200bde:	1101                	addi	sp,sp,-32
ffffffffc0200be0:	e04a                	sd	s2,0(sp)
ffffffffc0200be2:	892a                	mv	s2,a0
ffffffffc0200be4:	03000513          	li	a0,48
ffffffffc0200be8:	e822                	sd	s0,16(sp)
ffffffffc0200bea:	e426                	sd	s1,8(sp)
ffffffffc0200bec:	ec06                	sd	ra,24(sp)
ffffffffc0200bee:	84ae                	mv	s1,a1
ffffffffc0200bf0:	8432                	mv	s0,a2
ffffffffc0200bf2:	64d000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200bf6:	c509                	beqz	a0,ffffffffc0200c00 <vma_create+0x22>
ffffffffc0200bf8:	01253423          	sd	s2,8(a0)
ffffffffc0200bfc:	e904                	sd	s1,16(a0)
ffffffffc0200bfe:	cd00                	sw	s0,24(a0)
ffffffffc0200c00:	60e2                	ld	ra,24(sp)
ffffffffc0200c02:	6442                	ld	s0,16(sp)
ffffffffc0200c04:	64a2                	ld	s1,8(sp)
ffffffffc0200c06:	6902                	ld	s2,0(sp)
ffffffffc0200c08:	6105                	addi	sp,sp,32
ffffffffc0200c0a:	8082                	ret

ffffffffc0200c0c <find_vma>:
ffffffffc0200c0c:	86aa                	mv	a3,a0
ffffffffc0200c0e:	c505                	beqz	a0,ffffffffc0200c36 <find_vma+0x2a>
ffffffffc0200c10:	6908                	ld	a0,16(a0)
ffffffffc0200c12:	c501                	beqz	a0,ffffffffc0200c1a <find_vma+0xe>
ffffffffc0200c14:	651c                	ld	a5,8(a0)
ffffffffc0200c16:	02f5f263          	bgeu	a1,a5,ffffffffc0200c3a <find_vma+0x2e>
ffffffffc0200c1a:	669c                	ld	a5,8(a3)
ffffffffc0200c1c:	00f68d63          	beq	a3,a5,ffffffffc0200c36 <find_vma+0x2a>
ffffffffc0200c20:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200c24:	00e5e663          	bltu	a1,a4,ffffffffc0200c30 <find_vma+0x24>
ffffffffc0200c28:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200c2c:	00e5ec63          	bltu	a1,a4,ffffffffc0200c44 <find_vma+0x38>
ffffffffc0200c30:	679c                	ld	a5,8(a5)
ffffffffc0200c32:	fef697e3          	bne	a3,a5,ffffffffc0200c20 <find_vma+0x14>
ffffffffc0200c36:	4501                	li	a0,0
ffffffffc0200c38:	8082                	ret
ffffffffc0200c3a:	691c                	ld	a5,16(a0)
ffffffffc0200c3c:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0200c1a <find_vma+0xe>
ffffffffc0200c40:	ea88                	sd	a0,16(a3)
ffffffffc0200c42:	8082                	ret
ffffffffc0200c44:	fe078513          	addi	a0,a5,-32
ffffffffc0200c48:	ea88                	sd	a0,16(a3)
ffffffffc0200c4a:	8082                	ret

ffffffffc0200c4c <insert_vma_struct>:
ffffffffc0200c4c:	6590                	ld	a2,8(a1)
ffffffffc0200c4e:	0105b803          	ld	a6,16(a1)
ffffffffc0200c52:	1141                	addi	sp,sp,-16
ffffffffc0200c54:	e406                	sd	ra,8(sp)
ffffffffc0200c56:	87aa                	mv	a5,a0
ffffffffc0200c58:	01066763          	bltu	a2,a6,ffffffffc0200c66 <insert_vma_struct+0x1a>
ffffffffc0200c5c:	a085                	j	ffffffffc0200cbc <insert_vma_struct+0x70>
ffffffffc0200c5e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200c62:	04e66863          	bltu	a2,a4,ffffffffc0200cb2 <insert_vma_struct+0x66>
ffffffffc0200c66:	86be                	mv	a3,a5
ffffffffc0200c68:	679c                	ld	a5,8(a5)
ffffffffc0200c6a:	fef51ae3          	bne	a0,a5,ffffffffc0200c5e <insert_vma_struct+0x12>
ffffffffc0200c6e:	02a68463          	beq	a3,a0,ffffffffc0200c96 <insert_vma_struct+0x4a>
ffffffffc0200c72:	ff06b703          	ld	a4,-16(a3)
ffffffffc0200c76:	fe86b883          	ld	a7,-24(a3)
ffffffffc0200c7a:	08e8f163          	bgeu	a7,a4,ffffffffc0200cfc <insert_vma_struct+0xb0>
ffffffffc0200c7e:	04e66f63          	bltu	a2,a4,ffffffffc0200cdc <insert_vma_struct+0x90>
ffffffffc0200c82:	00f50a63          	beq	a0,a5,ffffffffc0200c96 <insert_vma_struct+0x4a>
ffffffffc0200c86:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200c8a:	05076963          	bltu	a4,a6,ffffffffc0200cdc <insert_vma_struct+0x90>
ffffffffc0200c8e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0200c92:	02c77363          	bgeu	a4,a2,ffffffffc0200cb8 <insert_vma_struct+0x6c>
ffffffffc0200c96:	5118                	lw	a4,32(a0)
ffffffffc0200c98:	e188                	sd	a0,0(a1)
ffffffffc0200c9a:	02058613          	addi	a2,a1,32
ffffffffc0200c9e:	e390                	sd	a2,0(a5)
ffffffffc0200ca0:	e690                	sd	a2,8(a3)
ffffffffc0200ca2:	60a2                	ld	ra,8(sp)
ffffffffc0200ca4:	f59c                	sd	a5,40(a1)
ffffffffc0200ca6:	f194                	sd	a3,32(a1)
ffffffffc0200ca8:	0017079b          	addiw	a5,a4,1
ffffffffc0200cac:	d11c                	sw	a5,32(a0)
ffffffffc0200cae:	0141                	addi	sp,sp,16
ffffffffc0200cb0:	8082                	ret
ffffffffc0200cb2:	fca690e3          	bne	a3,a0,ffffffffc0200c72 <insert_vma_struct+0x26>
ffffffffc0200cb6:	bfd1                	j	ffffffffc0200c8a <insert_vma_struct+0x3e>
ffffffffc0200cb8:	ebbff0ef          	jal	ra,ffffffffc0200b72 <check_vma_overlap.part.0>
ffffffffc0200cbc:	00005697          	auipc	a3,0x5
ffffffffc0200cc0:	c6c68693          	addi	a3,a3,-916 # ffffffffc0205928 <commands+0x750>
ffffffffc0200cc4:	00005617          	auipc	a2,0x5
ffffffffc0200cc8:	c3c60613          	addi	a2,a2,-964 # ffffffffc0205900 <commands+0x728>
ffffffffc0200ccc:	08500593          	li	a1,133
ffffffffc0200cd0:	00005517          	auipc	a0,0x5
ffffffffc0200cd4:	c4850513          	addi	a0,a0,-952 # ffffffffc0205918 <commands+0x740>
ffffffffc0200cd8:	cf0ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200cdc:	00005697          	auipc	a3,0x5
ffffffffc0200ce0:	c8c68693          	addi	a3,a3,-884 # ffffffffc0205968 <commands+0x790>
ffffffffc0200ce4:	00005617          	auipc	a2,0x5
ffffffffc0200ce8:	c1c60613          	addi	a2,a2,-996 # ffffffffc0205900 <commands+0x728>
ffffffffc0200cec:	07d00593          	li	a1,125
ffffffffc0200cf0:	00005517          	auipc	a0,0x5
ffffffffc0200cf4:	c2850513          	addi	a0,a0,-984 # ffffffffc0205918 <commands+0x740>
ffffffffc0200cf8:	cd0ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200cfc:	00005697          	auipc	a3,0x5
ffffffffc0200d00:	c4c68693          	addi	a3,a3,-948 # ffffffffc0205948 <commands+0x770>
ffffffffc0200d04:	00005617          	auipc	a2,0x5
ffffffffc0200d08:	bfc60613          	addi	a2,a2,-1028 # ffffffffc0205900 <commands+0x728>
ffffffffc0200d0c:	07c00593          	li	a1,124
ffffffffc0200d10:	00005517          	auipc	a0,0x5
ffffffffc0200d14:	c0850513          	addi	a0,a0,-1016 # ffffffffc0205918 <commands+0x740>
ffffffffc0200d18:	cb0ff0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0200d1c <mm_destroy>:
ffffffffc0200d1c:	1141                	addi	sp,sp,-16
ffffffffc0200d1e:	e022                	sd	s0,0(sp)
ffffffffc0200d20:	842a                	mv	s0,a0
ffffffffc0200d22:	6508                	ld	a0,8(a0)
ffffffffc0200d24:	e406                	sd	ra,8(sp)
ffffffffc0200d26:	00a40c63          	beq	s0,a0,ffffffffc0200d3e <mm_destroy+0x22>
ffffffffc0200d2a:	6118                	ld	a4,0(a0)
ffffffffc0200d2c:	651c                	ld	a5,8(a0)
ffffffffc0200d2e:	1501                	addi	a0,a0,-32
ffffffffc0200d30:	e71c                	sd	a5,8(a4)
ffffffffc0200d32:	e398                	sd	a4,0(a5)
ffffffffc0200d34:	5bb000ef          	jal	ra,ffffffffc0201aee <kfree>
ffffffffc0200d38:	6408                	ld	a0,8(s0)
ffffffffc0200d3a:	fea418e3          	bne	s0,a0,ffffffffc0200d2a <mm_destroy+0xe>
ffffffffc0200d3e:	8522                	mv	a0,s0
ffffffffc0200d40:	6402                	ld	s0,0(sp)
ffffffffc0200d42:	60a2                	ld	ra,8(sp)
ffffffffc0200d44:	0141                	addi	sp,sp,16
ffffffffc0200d46:	5a90006f          	j	ffffffffc0201aee <kfree>

ffffffffc0200d4a <vmm_init>:
ffffffffc0200d4a:	7139                	addi	sp,sp,-64
ffffffffc0200d4c:	03000513          	li	a0,48
ffffffffc0200d50:	fc06                	sd	ra,56(sp)
ffffffffc0200d52:	f822                	sd	s0,48(sp)
ffffffffc0200d54:	f426                	sd	s1,40(sp)
ffffffffc0200d56:	f04a                	sd	s2,32(sp)
ffffffffc0200d58:	ec4e                	sd	s3,24(sp)
ffffffffc0200d5a:	e852                	sd	s4,16(sp)
ffffffffc0200d5c:	e456                	sd	s5,8(sp)
ffffffffc0200d5e:	4e1000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200d62:	58050e63          	beqz	a0,ffffffffc02012fe <vmm_init+0x5b4>
ffffffffc0200d66:	e508                	sd	a0,8(a0)
ffffffffc0200d68:	e108                	sd	a0,0(a0)
ffffffffc0200d6a:	00053823          	sd	zero,16(a0)
ffffffffc0200d6e:	00053c23          	sd	zero,24(a0)
ffffffffc0200d72:	02052023          	sw	zero,32(a0)
ffffffffc0200d76:	00016797          	auipc	a5,0x16
ffffffffc0200d7a:	8027a783          	lw	a5,-2046(a5) # ffffffffc0216578 <swap_init_ok>
ffffffffc0200d7e:	84aa                	mv	s1,a0
ffffffffc0200d80:	e7b9                	bnez	a5,ffffffffc0200dce <vmm_init+0x84>
ffffffffc0200d82:	02053423          	sd	zero,40(a0)
ffffffffc0200d86:	03200413          	li	s0,50
ffffffffc0200d8a:	a811                	j	ffffffffc0200d9e <vmm_init+0x54>
ffffffffc0200d8c:	e500                	sd	s0,8(a0)
ffffffffc0200d8e:	e91c                	sd	a5,16(a0)
ffffffffc0200d90:	00052c23          	sw	zero,24(a0)
ffffffffc0200d94:	146d                	addi	s0,s0,-5
ffffffffc0200d96:	8526                	mv	a0,s1
ffffffffc0200d98:	eb5ff0ef          	jal	ra,ffffffffc0200c4c <insert_vma_struct>
ffffffffc0200d9c:	cc05                	beqz	s0,ffffffffc0200dd4 <vmm_init+0x8a>
ffffffffc0200d9e:	03000513          	li	a0,48
ffffffffc0200da2:	49d000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200da6:	85aa                	mv	a1,a0
ffffffffc0200da8:	00240793          	addi	a5,s0,2
ffffffffc0200dac:	f165                	bnez	a0,ffffffffc0200d8c <vmm_init+0x42>
ffffffffc0200dae:	00005697          	auipc	a3,0x5
ffffffffc0200db2:	e3268693          	addi	a3,a3,-462 # ffffffffc0205be0 <commands+0xa08>
ffffffffc0200db6:	00005617          	auipc	a2,0x5
ffffffffc0200dba:	b4a60613          	addi	a2,a2,-1206 # ffffffffc0205900 <commands+0x728>
ffffffffc0200dbe:	0c900593          	li	a1,201
ffffffffc0200dc2:	00005517          	auipc	a0,0x5
ffffffffc0200dc6:	b5650513          	addi	a0,a0,-1194 # ffffffffc0205918 <commands+0x740>
ffffffffc0200dca:	bfeff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200dce:	56c010ef          	jal	ra,ffffffffc020233a <swap_init_mm>
ffffffffc0200dd2:	bf55                	j	ffffffffc0200d86 <vmm_init+0x3c>
ffffffffc0200dd4:	03700413          	li	s0,55
ffffffffc0200dd8:	1f900913          	li	s2,505
ffffffffc0200ddc:	a819                	j	ffffffffc0200df2 <vmm_init+0xa8>
ffffffffc0200dde:	e500                	sd	s0,8(a0)
ffffffffc0200de0:	e91c                	sd	a5,16(a0)
ffffffffc0200de2:	00052c23          	sw	zero,24(a0)
ffffffffc0200de6:	0415                	addi	s0,s0,5
ffffffffc0200de8:	8526                	mv	a0,s1
ffffffffc0200dea:	e63ff0ef          	jal	ra,ffffffffc0200c4c <insert_vma_struct>
ffffffffc0200dee:	03240a63          	beq	s0,s2,ffffffffc0200e22 <vmm_init+0xd8>
ffffffffc0200df2:	03000513          	li	a0,48
ffffffffc0200df6:	449000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200dfa:	85aa                	mv	a1,a0
ffffffffc0200dfc:	00240793          	addi	a5,s0,2
ffffffffc0200e00:	fd79                	bnez	a0,ffffffffc0200dde <vmm_init+0x94>
ffffffffc0200e02:	00005697          	auipc	a3,0x5
ffffffffc0200e06:	dde68693          	addi	a3,a3,-546 # ffffffffc0205be0 <commands+0xa08>
ffffffffc0200e0a:	00005617          	auipc	a2,0x5
ffffffffc0200e0e:	af660613          	addi	a2,a2,-1290 # ffffffffc0205900 <commands+0x728>
ffffffffc0200e12:	0cf00593          	li	a1,207
ffffffffc0200e16:	00005517          	auipc	a0,0x5
ffffffffc0200e1a:	b0250513          	addi	a0,a0,-1278 # ffffffffc0205918 <commands+0x740>
ffffffffc0200e1e:	baaff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200e22:	649c                	ld	a5,8(s1)
ffffffffc0200e24:	471d                	li	a4,7
ffffffffc0200e26:	1fb00593          	li	a1,507
ffffffffc0200e2a:	30f48e63          	beq	s1,a5,ffffffffc0201146 <vmm_init+0x3fc>
ffffffffc0200e2e:	fe87b683          	ld	a3,-24(a5)
ffffffffc0200e32:	ffe70613          	addi	a2,a4,-2
ffffffffc0200e36:	2ad61863          	bne	a2,a3,ffffffffc02010e6 <vmm_init+0x39c>
ffffffffc0200e3a:	ff07b683          	ld	a3,-16(a5)
ffffffffc0200e3e:	2ae69463          	bne	a3,a4,ffffffffc02010e6 <vmm_init+0x39c>
ffffffffc0200e42:	0715                	addi	a4,a4,5
ffffffffc0200e44:	679c                	ld	a5,8(a5)
ffffffffc0200e46:	feb712e3          	bne	a4,a1,ffffffffc0200e2a <vmm_init+0xe0>
ffffffffc0200e4a:	4a1d                	li	s4,7
ffffffffc0200e4c:	4415                	li	s0,5
ffffffffc0200e4e:	1f900a93          	li	s5,505
ffffffffc0200e52:	85a2                	mv	a1,s0
ffffffffc0200e54:	8526                	mv	a0,s1
ffffffffc0200e56:	db7ff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200e5a:	892a                	mv	s2,a0
ffffffffc0200e5c:	34050563          	beqz	a0,ffffffffc02011a6 <vmm_init+0x45c>
ffffffffc0200e60:	00140593          	addi	a1,s0,1
ffffffffc0200e64:	8526                	mv	a0,s1
ffffffffc0200e66:	da7ff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200e6a:	89aa                	mv	s3,a0
ffffffffc0200e6c:	34050d63          	beqz	a0,ffffffffc02011c6 <vmm_init+0x47c>
ffffffffc0200e70:	85d2                	mv	a1,s4
ffffffffc0200e72:	8526                	mv	a0,s1
ffffffffc0200e74:	d99ff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200e78:	36051763          	bnez	a0,ffffffffc02011e6 <vmm_init+0x49c>
ffffffffc0200e7c:	00340593          	addi	a1,s0,3
ffffffffc0200e80:	8526                	mv	a0,s1
ffffffffc0200e82:	d8bff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200e86:	2e051063          	bnez	a0,ffffffffc0201166 <vmm_init+0x41c>
ffffffffc0200e8a:	00440593          	addi	a1,s0,4
ffffffffc0200e8e:	8526                	mv	a0,s1
ffffffffc0200e90:	d7dff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200e94:	2e051963          	bnez	a0,ffffffffc0201186 <vmm_init+0x43c>
ffffffffc0200e98:	00893783          	ld	a5,8(s2)
ffffffffc0200e9c:	26879563          	bne	a5,s0,ffffffffc0201106 <vmm_init+0x3bc>
ffffffffc0200ea0:	01093783          	ld	a5,16(s2)
ffffffffc0200ea4:	27479163          	bne	a5,s4,ffffffffc0201106 <vmm_init+0x3bc>
ffffffffc0200ea8:	0089b783          	ld	a5,8(s3)
ffffffffc0200eac:	26879d63          	bne	a5,s0,ffffffffc0201126 <vmm_init+0x3dc>
ffffffffc0200eb0:	0109b783          	ld	a5,16(s3)
ffffffffc0200eb4:	27479963          	bne	a5,s4,ffffffffc0201126 <vmm_init+0x3dc>
ffffffffc0200eb8:	0415                	addi	s0,s0,5
ffffffffc0200eba:	0a15                	addi	s4,s4,5
ffffffffc0200ebc:	f9541be3          	bne	s0,s5,ffffffffc0200e52 <vmm_init+0x108>
ffffffffc0200ec0:	4411                	li	s0,4
ffffffffc0200ec2:	597d                	li	s2,-1
ffffffffc0200ec4:	85a2                	mv	a1,s0
ffffffffc0200ec6:	8526                	mv	a0,s1
ffffffffc0200ec8:	d45ff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200ecc:	0004059b          	sext.w	a1,s0
ffffffffc0200ed0:	c90d                	beqz	a0,ffffffffc0200f02 <vmm_init+0x1b8>
ffffffffc0200ed2:	6914                	ld	a3,16(a0)
ffffffffc0200ed4:	6510                	ld	a2,8(a0)
ffffffffc0200ed6:	00005517          	auipc	a0,0x5
ffffffffc0200eda:	bb250513          	addi	a0,a0,-1102 # ffffffffc0205a88 <commands+0x8b0>
ffffffffc0200ede:	9eeff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200ee2:	00005697          	auipc	a3,0x5
ffffffffc0200ee6:	bce68693          	addi	a3,a3,-1074 # ffffffffc0205ab0 <commands+0x8d8>
ffffffffc0200eea:	00005617          	auipc	a2,0x5
ffffffffc0200eee:	a1660613          	addi	a2,a2,-1514 # ffffffffc0205900 <commands+0x728>
ffffffffc0200ef2:	0f100593          	li	a1,241
ffffffffc0200ef6:	00005517          	auipc	a0,0x5
ffffffffc0200efa:	a2250513          	addi	a0,a0,-1502 # ffffffffc0205918 <commands+0x740>
ffffffffc0200efe:	acaff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0200f02:	147d                	addi	s0,s0,-1
ffffffffc0200f04:	fd2410e3          	bne	s0,s2,ffffffffc0200ec4 <vmm_init+0x17a>
ffffffffc0200f08:	a801                	j	ffffffffc0200f18 <vmm_init+0x1ce>
ffffffffc0200f0a:	6118                	ld	a4,0(a0)
ffffffffc0200f0c:	651c                	ld	a5,8(a0)
ffffffffc0200f0e:	1501                	addi	a0,a0,-32
ffffffffc0200f10:	e71c                	sd	a5,8(a4)
ffffffffc0200f12:	e398                	sd	a4,0(a5)
ffffffffc0200f14:	3db000ef          	jal	ra,ffffffffc0201aee <kfree>
ffffffffc0200f18:	6488                	ld	a0,8(s1)
ffffffffc0200f1a:	fea498e3          	bne	s1,a0,ffffffffc0200f0a <vmm_init+0x1c0>
ffffffffc0200f1e:	8526                	mv	a0,s1
ffffffffc0200f20:	3cf000ef          	jal	ra,ffffffffc0201aee <kfree>
ffffffffc0200f24:	00005517          	auipc	a0,0x5
ffffffffc0200f28:	ba450513          	addi	a0,a0,-1116 # ffffffffc0205ac8 <commands+0x8f0>
ffffffffc0200f2c:	9a0ff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0200f30:	15e020ef          	jal	ra,ffffffffc020308e <nr_free_pages>
ffffffffc0200f34:	84aa                	mv	s1,a0
ffffffffc0200f36:	03000513          	li	a0,48
ffffffffc0200f3a:	305000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200f3e:	842a                	mv	s0,a0
ffffffffc0200f40:	2c050363          	beqz	a0,ffffffffc0201206 <vmm_init+0x4bc>
ffffffffc0200f44:	00015797          	auipc	a5,0x15
ffffffffc0200f48:	6347a783          	lw	a5,1588(a5) # ffffffffc0216578 <swap_init_ok>
ffffffffc0200f4c:	e508                	sd	a0,8(a0)
ffffffffc0200f4e:	e108                	sd	a0,0(a0)
ffffffffc0200f50:	00053823          	sd	zero,16(a0)
ffffffffc0200f54:	00053c23          	sd	zero,24(a0)
ffffffffc0200f58:	02052023          	sw	zero,32(a0)
ffffffffc0200f5c:	18079263          	bnez	a5,ffffffffc02010e0 <vmm_init+0x396>
ffffffffc0200f60:	02053423          	sd	zero,40(a0)
ffffffffc0200f64:	00015917          	auipc	s2,0x15
ffffffffc0200f68:	62493903          	ld	s2,1572(s2) # ffffffffc0216588 <boot_pgdir>
ffffffffc0200f6c:	00093783          	ld	a5,0(s2)
ffffffffc0200f70:	00015717          	auipc	a4,0x15
ffffffffc0200f74:	5e873023          	sd	s0,1504(a4) # ffffffffc0216550 <check_mm_struct>
ffffffffc0200f78:	01243c23          	sd	s2,24(s0)
ffffffffc0200f7c:	36079163          	bnez	a5,ffffffffc02012de <vmm_init+0x594>
ffffffffc0200f80:	03000513          	li	a0,48
ffffffffc0200f84:	2bb000ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc0200f88:	89aa                	mv	s3,a0
ffffffffc0200f8a:	2a050263          	beqz	a0,ffffffffc020122e <vmm_init+0x4e4>
ffffffffc0200f8e:	002007b7          	lui	a5,0x200
ffffffffc0200f92:	00f9b823          	sd	a5,16(s3)
ffffffffc0200f96:	4789                	li	a5,2
ffffffffc0200f98:	85aa                	mv	a1,a0
ffffffffc0200f9a:	00f9ac23          	sw	a5,24(s3)
ffffffffc0200f9e:	8522                	mv	a0,s0
ffffffffc0200fa0:	0009b423          	sd	zero,8(s3)
ffffffffc0200fa4:	ca9ff0ef          	jal	ra,ffffffffc0200c4c <insert_vma_struct>
ffffffffc0200fa8:	10000593          	li	a1,256
ffffffffc0200fac:	8522                	mv	a0,s0
ffffffffc0200fae:	c5fff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0200fb2:	10000793          	li	a5,256
ffffffffc0200fb6:	16400713          	li	a4,356
ffffffffc0200fba:	28a99a63          	bne	s3,a0,ffffffffc020124e <vmm_init+0x504>
ffffffffc0200fbe:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
ffffffffc0200fc2:	0785                	addi	a5,a5,1
ffffffffc0200fc4:	fee79de3          	bne	a5,a4,ffffffffc0200fbe <vmm_init+0x274>
ffffffffc0200fc8:	6705                	lui	a4,0x1
ffffffffc0200fca:	10000793          	li	a5,256
ffffffffc0200fce:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
ffffffffc0200fd2:	16400613          	li	a2,356
ffffffffc0200fd6:	0007c683          	lbu	a3,0(a5)
ffffffffc0200fda:	0785                	addi	a5,a5,1
ffffffffc0200fdc:	9f15                	subw	a4,a4,a3
ffffffffc0200fde:	fec79ce3          	bne	a5,a2,ffffffffc0200fd6 <vmm_init+0x28c>
ffffffffc0200fe2:	28071663          	bnez	a4,ffffffffc020126e <vmm_init+0x524>
ffffffffc0200fe6:	00093783          	ld	a5,0(s2)
ffffffffc0200fea:	00015a97          	auipc	s5,0x15
ffffffffc0200fee:	5a6a8a93          	addi	s5,s5,1446 # ffffffffc0216590 <npage>
ffffffffc0200ff2:	000ab603          	ld	a2,0(s5)
ffffffffc0200ff6:	078a                	slli	a5,a5,0x2
ffffffffc0200ff8:	83b1                	srli	a5,a5,0xc
ffffffffc0200ffa:	28c7fa63          	bgeu	a5,a2,ffffffffc020128e <vmm_init+0x544>
ffffffffc0200ffe:	00006a17          	auipc	s4,0x6
ffffffffc0201002:	07aa3a03          	ld	s4,122(s4) # ffffffffc0207078 <nbase>
ffffffffc0201006:	414787b3          	sub	a5,a5,s4
ffffffffc020100a:	079a                	slli	a5,a5,0x6
ffffffffc020100c:	8799                	srai	a5,a5,0x6
ffffffffc020100e:	97d2                	add	a5,a5,s4
ffffffffc0201010:	00c79713          	slli	a4,a5,0xc
ffffffffc0201014:	8331                	srli	a4,a4,0xc
ffffffffc0201016:	00c79693          	slli	a3,a5,0xc
ffffffffc020101a:	28c77663          	bgeu	a4,a2,ffffffffc02012a6 <vmm_init+0x55c>
ffffffffc020101e:	00015997          	auipc	s3,0x15
ffffffffc0201022:	58a9b983          	ld	s3,1418(s3) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0201026:	4581                	li	a1,0
ffffffffc0201028:	854a                	mv	a0,s2
ffffffffc020102a:	99b6                	add	s3,s3,a3
ffffffffc020102c:	2c2020ef          	jal	ra,ffffffffc02032ee <page_remove>
ffffffffc0201030:	0009b783          	ld	a5,0(s3)
ffffffffc0201034:	000ab703          	ld	a4,0(s5)
ffffffffc0201038:	078a                	slli	a5,a5,0x2
ffffffffc020103a:	83b1                	srli	a5,a5,0xc
ffffffffc020103c:	24e7f963          	bgeu	a5,a4,ffffffffc020128e <vmm_init+0x544>
ffffffffc0201040:	00015997          	auipc	s3,0x15
ffffffffc0201044:	55898993          	addi	s3,s3,1368 # ffffffffc0216598 <pages>
ffffffffc0201048:	0009b503          	ld	a0,0(s3)
ffffffffc020104c:	414787b3          	sub	a5,a5,s4
ffffffffc0201050:	079a                	slli	a5,a5,0x6
ffffffffc0201052:	953e                	add	a0,a0,a5
ffffffffc0201054:	4585                	li	a1,1
ffffffffc0201056:	7f9010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020105a:	00093783          	ld	a5,0(s2)
ffffffffc020105e:	000ab703          	ld	a4,0(s5)
ffffffffc0201062:	078a                	slli	a5,a5,0x2
ffffffffc0201064:	83b1                	srli	a5,a5,0xc
ffffffffc0201066:	22e7f463          	bgeu	a5,a4,ffffffffc020128e <vmm_init+0x544>
ffffffffc020106a:	0009b503          	ld	a0,0(s3)
ffffffffc020106e:	414787b3          	sub	a5,a5,s4
ffffffffc0201072:	079a                	slli	a5,a5,0x6
ffffffffc0201074:	4585                	li	a1,1
ffffffffc0201076:	953e                	add	a0,a0,a5
ffffffffc0201078:	7d7010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020107c:	00093023          	sd	zero,0(s2)
ffffffffc0201080:	12000073          	sfence.vma
ffffffffc0201084:	6408                	ld	a0,8(s0)
ffffffffc0201086:	00043c23          	sd	zero,24(s0)
ffffffffc020108a:	00a40c63          	beq	s0,a0,ffffffffc02010a2 <vmm_init+0x358>
ffffffffc020108e:	6118                	ld	a4,0(a0)
ffffffffc0201090:	651c                	ld	a5,8(a0)
ffffffffc0201092:	1501                	addi	a0,a0,-32
ffffffffc0201094:	e71c                	sd	a5,8(a4)
ffffffffc0201096:	e398                	sd	a4,0(a5)
ffffffffc0201098:	257000ef          	jal	ra,ffffffffc0201aee <kfree>
ffffffffc020109c:	6408                	ld	a0,8(s0)
ffffffffc020109e:	fea418e3          	bne	s0,a0,ffffffffc020108e <vmm_init+0x344>
ffffffffc02010a2:	8522                	mv	a0,s0
ffffffffc02010a4:	24b000ef          	jal	ra,ffffffffc0201aee <kfree>
ffffffffc02010a8:	00015797          	auipc	a5,0x15
ffffffffc02010ac:	4a07b423          	sd	zero,1192(a5) # ffffffffc0216550 <check_mm_struct>
ffffffffc02010b0:	7df010ef          	jal	ra,ffffffffc020308e <nr_free_pages>
ffffffffc02010b4:	20a49563          	bne	s1,a0,ffffffffc02012be <vmm_init+0x574>
ffffffffc02010b8:	00005517          	auipc	a0,0x5
ffffffffc02010bc:	af050513          	addi	a0,a0,-1296 # ffffffffc0205ba8 <commands+0x9d0>
ffffffffc02010c0:	80cff0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02010c4:	7442                	ld	s0,48(sp)
ffffffffc02010c6:	70e2                	ld	ra,56(sp)
ffffffffc02010c8:	74a2                	ld	s1,40(sp)
ffffffffc02010ca:	7902                	ld	s2,32(sp)
ffffffffc02010cc:	69e2                	ld	s3,24(sp)
ffffffffc02010ce:	6a42                	ld	s4,16(sp)
ffffffffc02010d0:	6aa2                	ld	s5,8(sp)
ffffffffc02010d2:	00005517          	auipc	a0,0x5
ffffffffc02010d6:	af650513          	addi	a0,a0,-1290 # ffffffffc0205bc8 <commands+0x9f0>
ffffffffc02010da:	6121                	addi	sp,sp,64
ffffffffc02010dc:	ff1fe06f          	j	ffffffffc02000cc <cprintf>
ffffffffc02010e0:	25a010ef          	jal	ra,ffffffffc020233a <swap_init_mm>
ffffffffc02010e4:	b541                	j	ffffffffc0200f64 <vmm_init+0x21a>
ffffffffc02010e6:	00005697          	auipc	a3,0x5
ffffffffc02010ea:	8ba68693          	addi	a3,a3,-1862 # ffffffffc02059a0 <commands+0x7c8>
ffffffffc02010ee:	00005617          	auipc	a2,0x5
ffffffffc02010f2:	81260613          	addi	a2,a2,-2030 # ffffffffc0205900 <commands+0x728>
ffffffffc02010f6:	0d800593          	li	a1,216
ffffffffc02010fa:	00005517          	auipc	a0,0x5
ffffffffc02010fe:	81e50513          	addi	a0,a0,-2018 # ffffffffc0205918 <commands+0x740>
ffffffffc0201102:	8c6ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201106:	00005697          	auipc	a3,0x5
ffffffffc020110a:	92268693          	addi	a3,a3,-1758 # ffffffffc0205a28 <commands+0x850>
ffffffffc020110e:	00004617          	auipc	a2,0x4
ffffffffc0201112:	7f260613          	addi	a2,a2,2034 # ffffffffc0205900 <commands+0x728>
ffffffffc0201116:	0e800593          	li	a1,232
ffffffffc020111a:	00004517          	auipc	a0,0x4
ffffffffc020111e:	7fe50513          	addi	a0,a0,2046 # ffffffffc0205918 <commands+0x740>
ffffffffc0201122:	8a6ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201126:	00005697          	auipc	a3,0x5
ffffffffc020112a:	93268693          	addi	a3,a3,-1742 # ffffffffc0205a58 <commands+0x880>
ffffffffc020112e:	00004617          	auipc	a2,0x4
ffffffffc0201132:	7d260613          	addi	a2,a2,2002 # ffffffffc0205900 <commands+0x728>
ffffffffc0201136:	0e900593          	li	a1,233
ffffffffc020113a:	00004517          	auipc	a0,0x4
ffffffffc020113e:	7de50513          	addi	a0,a0,2014 # ffffffffc0205918 <commands+0x740>
ffffffffc0201142:	886ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201146:	00005697          	auipc	a3,0x5
ffffffffc020114a:	84268693          	addi	a3,a3,-1982 # ffffffffc0205988 <commands+0x7b0>
ffffffffc020114e:	00004617          	auipc	a2,0x4
ffffffffc0201152:	7b260613          	addi	a2,a2,1970 # ffffffffc0205900 <commands+0x728>
ffffffffc0201156:	0d600593          	li	a1,214
ffffffffc020115a:	00004517          	auipc	a0,0x4
ffffffffc020115e:	7be50513          	addi	a0,a0,1982 # ffffffffc0205918 <commands+0x740>
ffffffffc0201162:	866ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201166:	00005697          	auipc	a3,0x5
ffffffffc020116a:	8a268693          	addi	a3,a3,-1886 # ffffffffc0205a08 <commands+0x830>
ffffffffc020116e:	00004617          	auipc	a2,0x4
ffffffffc0201172:	79260613          	addi	a2,a2,1938 # ffffffffc0205900 <commands+0x728>
ffffffffc0201176:	0e400593          	li	a1,228
ffffffffc020117a:	00004517          	auipc	a0,0x4
ffffffffc020117e:	79e50513          	addi	a0,a0,1950 # ffffffffc0205918 <commands+0x740>
ffffffffc0201182:	846ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201186:	00005697          	auipc	a3,0x5
ffffffffc020118a:	89268693          	addi	a3,a3,-1902 # ffffffffc0205a18 <commands+0x840>
ffffffffc020118e:	00004617          	auipc	a2,0x4
ffffffffc0201192:	77260613          	addi	a2,a2,1906 # ffffffffc0205900 <commands+0x728>
ffffffffc0201196:	0e600593          	li	a1,230
ffffffffc020119a:	00004517          	auipc	a0,0x4
ffffffffc020119e:	77e50513          	addi	a0,a0,1918 # ffffffffc0205918 <commands+0x740>
ffffffffc02011a2:	826ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02011a6:	00005697          	auipc	a3,0x5
ffffffffc02011aa:	83268693          	addi	a3,a3,-1998 # ffffffffc02059d8 <commands+0x800>
ffffffffc02011ae:	00004617          	auipc	a2,0x4
ffffffffc02011b2:	75260613          	addi	a2,a2,1874 # ffffffffc0205900 <commands+0x728>
ffffffffc02011b6:	0de00593          	li	a1,222
ffffffffc02011ba:	00004517          	auipc	a0,0x4
ffffffffc02011be:	75e50513          	addi	a0,a0,1886 # ffffffffc0205918 <commands+0x740>
ffffffffc02011c2:	806ff0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02011c6:	00005697          	auipc	a3,0x5
ffffffffc02011ca:	82268693          	addi	a3,a3,-2014 # ffffffffc02059e8 <commands+0x810>
ffffffffc02011ce:	00004617          	auipc	a2,0x4
ffffffffc02011d2:	73260613          	addi	a2,a2,1842 # ffffffffc0205900 <commands+0x728>
ffffffffc02011d6:	0e000593          	li	a1,224
ffffffffc02011da:	00004517          	auipc	a0,0x4
ffffffffc02011de:	73e50513          	addi	a0,a0,1854 # ffffffffc0205918 <commands+0x740>
ffffffffc02011e2:	fe7fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02011e6:	00005697          	auipc	a3,0x5
ffffffffc02011ea:	81268693          	addi	a3,a3,-2030 # ffffffffc02059f8 <commands+0x820>
ffffffffc02011ee:	00004617          	auipc	a2,0x4
ffffffffc02011f2:	71260613          	addi	a2,a2,1810 # ffffffffc0205900 <commands+0x728>
ffffffffc02011f6:	0e200593          	li	a1,226
ffffffffc02011fa:	00004517          	auipc	a0,0x4
ffffffffc02011fe:	71e50513          	addi	a0,a0,1822 # ffffffffc0205918 <commands+0x740>
ffffffffc0201202:	fc7fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201206:	00005697          	auipc	a3,0x5
ffffffffc020120a:	9ea68693          	addi	a3,a3,-1558 # ffffffffc0205bf0 <commands+0xa18>
ffffffffc020120e:	00004617          	auipc	a2,0x4
ffffffffc0201212:	6f260613          	addi	a2,a2,1778 # ffffffffc0205900 <commands+0x728>
ffffffffc0201216:	10100593          	li	a1,257
ffffffffc020121a:	00004517          	auipc	a0,0x4
ffffffffc020121e:	6fe50513          	addi	a0,a0,1790 # ffffffffc0205918 <commands+0x740>
ffffffffc0201222:	00015797          	auipc	a5,0x15
ffffffffc0201226:	3207b723          	sd	zero,814(a5) # ffffffffc0216550 <check_mm_struct>
ffffffffc020122a:	f9ffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020122e:	00005697          	auipc	a3,0x5
ffffffffc0201232:	9b268693          	addi	a3,a3,-1614 # ffffffffc0205be0 <commands+0xa08>
ffffffffc0201236:	00004617          	auipc	a2,0x4
ffffffffc020123a:	6ca60613          	addi	a2,a2,1738 # ffffffffc0205900 <commands+0x728>
ffffffffc020123e:	10800593          	li	a1,264
ffffffffc0201242:	00004517          	auipc	a0,0x4
ffffffffc0201246:	6d650513          	addi	a0,a0,1750 # ffffffffc0205918 <commands+0x740>
ffffffffc020124a:	f7ffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020124e:	00005697          	auipc	a3,0x5
ffffffffc0201252:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0205af8 <commands+0x920>
ffffffffc0201256:	00004617          	auipc	a2,0x4
ffffffffc020125a:	6aa60613          	addi	a2,a2,1706 # ffffffffc0205900 <commands+0x728>
ffffffffc020125e:	10d00593          	li	a1,269
ffffffffc0201262:	00004517          	auipc	a0,0x4
ffffffffc0201266:	6b650513          	addi	a0,a0,1718 # ffffffffc0205918 <commands+0x740>
ffffffffc020126a:	f5ffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020126e:	00005697          	auipc	a3,0x5
ffffffffc0201272:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0205b18 <commands+0x940>
ffffffffc0201276:	00004617          	auipc	a2,0x4
ffffffffc020127a:	68a60613          	addi	a2,a2,1674 # ffffffffc0205900 <commands+0x728>
ffffffffc020127e:	11700593          	li	a1,279
ffffffffc0201282:	00004517          	auipc	a0,0x4
ffffffffc0201286:	69650513          	addi	a0,a0,1686 # ffffffffc0205918 <commands+0x740>
ffffffffc020128a:	f3ffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020128e:	00005617          	auipc	a2,0x5
ffffffffc0201292:	89a60613          	addi	a2,a2,-1894 # ffffffffc0205b28 <commands+0x950>
ffffffffc0201296:	06200593          	li	a1,98
ffffffffc020129a:	00005517          	auipc	a0,0x5
ffffffffc020129e:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0205b48 <commands+0x970>
ffffffffc02012a2:	f27fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02012a6:	00005617          	auipc	a2,0x5
ffffffffc02012aa:	8b260613          	addi	a2,a2,-1870 # ffffffffc0205b58 <commands+0x980>
ffffffffc02012ae:	06900593          	li	a1,105
ffffffffc02012b2:	00005517          	auipc	a0,0x5
ffffffffc02012b6:	89650513          	addi	a0,a0,-1898 # ffffffffc0205b48 <commands+0x970>
ffffffffc02012ba:	f0ffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02012be:	00005697          	auipc	a3,0x5
ffffffffc02012c2:	8c268693          	addi	a3,a3,-1854 # ffffffffc0205b80 <commands+0x9a8>
ffffffffc02012c6:	00004617          	auipc	a2,0x4
ffffffffc02012ca:	63a60613          	addi	a2,a2,1594 # ffffffffc0205900 <commands+0x728>
ffffffffc02012ce:	12400593          	li	a1,292
ffffffffc02012d2:	00004517          	auipc	a0,0x4
ffffffffc02012d6:	64650513          	addi	a0,a0,1606 # ffffffffc0205918 <commands+0x740>
ffffffffc02012da:	eeffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02012de:	00005697          	auipc	a3,0x5
ffffffffc02012e2:	80a68693          	addi	a3,a3,-2038 # ffffffffc0205ae8 <commands+0x910>
ffffffffc02012e6:	00004617          	auipc	a2,0x4
ffffffffc02012ea:	61a60613          	addi	a2,a2,1562 # ffffffffc0205900 <commands+0x728>
ffffffffc02012ee:	10500593          	li	a1,261
ffffffffc02012f2:	00004517          	auipc	a0,0x4
ffffffffc02012f6:	62650513          	addi	a0,a0,1574 # ffffffffc0205918 <commands+0x740>
ffffffffc02012fa:	ecffe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02012fe:	00005697          	auipc	a3,0x5
ffffffffc0201302:	90a68693          	addi	a3,a3,-1782 # ffffffffc0205c08 <commands+0xa30>
ffffffffc0201306:	00004617          	auipc	a2,0x4
ffffffffc020130a:	5fa60613          	addi	a2,a2,1530 # ffffffffc0205900 <commands+0x728>
ffffffffc020130e:	0c200593          	li	a1,194
ffffffffc0201312:	00004517          	auipc	a0,0x4
ffffffffc0201316:	60650513          	addi	a0,a0,1542 # ffffffffc0205918 <commands+0x740>
ffffffffc020131a:	eaffe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020131e <do_pgfault>:
ffffffffc020131e:	7179                	addi	sp,sp,-48
ffffffffc0201320:	85b2                	mv	a1,a2
ffffffffc0201322:	f022                	sd	s0,32(sp)
ffffffffc0201324:	ec26                	sd	s1,24(sp)
ffffffffc0201326:	f406                	sd	ra,40(sp)
ffffffffc0201328:	e84a                	sd	s2,16(sp)
ffffffffc020132a:	8432                	mv	s0,a2
ffffffffc020132c:	84aa                	mv	s1,a0
ffffffffc020132e:	8dfff0ef          	jal	ra,ffffffffc0200c0c <find_vma>
ffffffffc0201332:	00015797          	auipc	a5,0x15
ffffffffc0201336:	2267a783          	lw	a5,550(a5) # ffffffffc0216558 <pgfault_num>
ffffffffc020133a:	2785                	addiw	a5,a5,1
ffffffffc020133c:	00015717          	auipc	a4,0x15
ffffffffc0201340:	20f72e23          	sw	a5,540(a4) # ffffffffc0216558 <pgfault_num>
ffffffffc0201344:	c551                	beqz	a0,ffffffffc02013d0 <do_pgfault+0xb2>
ffffffffc0201346:	651c                	ld	a5,8(a0)
ffffffffc0201348:	08f46463          	bltu	s0,a5,ffffffffc02013d0 <do_pgfault+0xb2>
ffffffffc020134c:	4d1c                	lw	a5,24(a0)
ffffffffc020134e:	4941                	li	s2,16
ffffffffc0201350:	8b89                	andi	a5,a5,2
ffffffffc0201352:	efb1                	bnez	a5,ffffffffc02013ae <do_pgfault+0x90>
ffffffffc0201354:	75fd                	lui	a1,0xfffff
ffffffffc0201356:	6c88                	ld	a0,24(s1)
ffffffffc0201358:	8c6d                	and	s0,s0,a1
ffffffffc020135a:	4605                	li	a2,1
ffffffffc020135c:	85a2                	mv	a1,s0
ffffffffc020135e:	56b010ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc0201362:	c945                	beqz	a0,ffffffffc0201412 <do_pgfault+0xf4>
ffffffffc0201364:	610c                	ld	a1,0(a0)
ffffffffc0201366:	c5b1                	beqz	a1,ffffffffc02013b2 <do_pgfault+0x94>
ffffffffc0201368:	00015797          	auipc	a5,0x15
ffffffffc020136c:	2107a783          	lw	a5,528(a5) # ffffffffc0216578 <swap_init_ok>
ffffffffc0201370:	cbad                	beqz	a5,ffffffffc02013e2 <do_pgfault+0xc4>
ffffffffc0201372:	0030                	addi	a2,sp,8
ffffffffc0201374:	85a2                	mv	a1,s0
ffffffffc0201376:	8526                	mv	a0,s1
ffffffffc0201378:	e402                	sd	zero,8(sp)
ffffffffc020137a:	0ec010ef          	jal	ra,ffffffffc0202466 <swap_in>
ffffffffc020137e:	e935                	bnez	a0,ffffffffc02013f2 <do_pgfault+0xd4>
ffffffffc0201380:	65a2                	ld	a1,8(sp)
ffffffffc0201382:	6c88                	ld	a0,24(s1)
ffffffffc0201384:	86ca                	mv	a3,s2
ffffffffc0201386:	8622                	mv	a2,s0
ffffffffc0201388:	002020ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc020138c:	892a                	mv	s2,a0
ffffffffc020138e:	e935                	bnez	a0,ffffffffc0201402 <do_pgfault+0xe4>
ffffffffc0201390:	6622                	ld	a2,8(sp)
ffffffffc0201392:	4681                	li	a3,0
ffffffffc0201394:	85a2                	mv	a1,s0
ffffffffc0201396:	8526                	mv	a0,s1
ffffffffc0201398:	7af000ef          	jal	ra,ffffffffc0202346 <swap_map_swappable>
ffffffffc020139c:	67a2                	ld	a5,8(sp)
ffffffffc020139e:	ff80                	sd	s0,56(a5)
ffffffffc02013a0:	70a2                	ld	ra,40(sp)
ffffffffc02013a2:	7402                	ld	s0,32(sp)
ffffffffc02013a4:	64e2                	ld	s1,24(sp)
ffffffffc02013a6:	854a                	mv	a0,s2
ffffffffc02013a8:	6942                	ld	s2,16(sp)
ffffffffc02013aa:	6145                	addi	sp,sp,48
ffffffffc02013ac:	8082                	ret
ffffffffc02013ae:	495d                	li	s2,23
ffffffffc02013b0:	b755                	j	ffffffffc0201354 <do_pgfault+0x36>
ffffffffc02013b2:	6c88                	ld	a0,24(s1)
ffffffffc02013b4:	864a                	mv	a2,s2
ffffffffc02013b6:	85a2                	mv	a1,s0
ffffffffc02013b8:	469020ef          	jal	ra,ffffffffc0204020 <pgdir_alloc_page>
ffffffffc02013bc:	4901                	li	s2,0
ffffffffc02013be:	f16d                	bnez	a0,ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc02013c0:	00005517          	auipc	a0,0x5
ffffffffc02013c4:	8a850513          	addi	a0,a0,-1880 # ffffffffc0205c68 <commands+0xa90>
ffffffffc02013c8:	d05fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02013cc:	5971                	li	s2,-4
ffffffffc02013ce:	bfc9                	j	ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc02013d0:	85a2                	mv	a1,s0
ffffffffc02013d2:	00005517          	auipc	a0,0x5
ffffffffc02013d6:	84650513          	addi	a0,a0,-1978 # ffffffffc0205c18 <commands+0xa40>
ffffffffc02013da:	cf3fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02013de:	5975                	li	s2,-3
ffffffffc02013e0:	b7c1                	j	ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc02013e2:	00005517          	auipc	a0,0x5
ffffffffc02013e6:	8f650513          	addi	a0,a0,-1802 # ffffffffc0205cd8 <commands+0xb00>
ffffffffc02013ea:	ce3fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02013ee:	5971                	li	s2,-4
ffffffffc02013f0:	bf45                	j	ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc02013f2:	00005517          	auipc	a0,0x5
ffffffffc02013f6:	89e50513          	addi	a0,a0,-1890 # ffffffffc0205c90 <commands+0xab8>
ffffffffc02013fa:	cd3fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02013fe:	5971                	li	s2,-4
ffffffffc0201400:	b745                	j	ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc0201402:	00005517          	auipc	a0,0x5
ffffffffc0201406:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0205cb0 <commands+0xad8>
ffffffffc020140a:	cc3fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020140e:	5971                	li	s2,-4
ffffffffc0201410:	bf41                	j	ffffffffc02013a0 <do_pgfault+0x82>
ffffffffc0201412:	00005517          	auipc	a0,0x5
ffffffffc0201416:	83650513          	addi	a0,a0,-1994 # ffffffffc0205c48 <commands+0xa70>
ffffffffc020141a:	cb3fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020141e:	5971                	li	s2,-4
ffffffffc0201420:	b741                	j	ffffffffc02013a0 <do_pgfault+0x82>

ffffffffc0201422 <_fifo_init_mm>:
ffffffffc0201422:	00011797          	auipc	a5,0x11
ffffffffc0201426:	03e78793          	addi	a5,a5,62 # ffffffffc0212460 <pra_list_head>
ffffffffc020142a:	f51c                	sd	a5,40(a0)
ffffffffc020142c:	e79c                	sd	a5,8(a5)
ffffffffc020142e:	e39c                	sd	a5,0(a5)
ffffffffc0201430:	4501                	li	a0,0
ffffffffc0201432:	8082                	ret

ffffffffc0201434 <_fifo_init>:
ffffffffc0201434:	4501                	li	a0,0
ffffffffc0201436:	8082                	ret

ffffffffc0201438 <_fifo_set_unswappable>:
ffffffffc0201438:	4501                	li	a0,0
ffffffffc020143a:	8082                	ret

ffffffffc020143c <_fifo_tick_event>:
ffffffffc020143c:	4501                	li	a0,0
ffffffffc020143e:	8082                	ret

ffffffffc0201440 <_fifo_check_swap>:
ffffffffc0201440:	711d                	addi	sp,sp,-96
ffffffffc0201442:	fc4e                	sd	s3,56(sp)
ffffffffc0201444:	f852                	sd	s4,48(sp)
ffffffffc0201446:	00005517          	auipc	a0,0x5
ffffffffc020144a:	8ba50513          	addi	a0,a0,-1862 # ffffffffc0205d00 <commands+0xb28>
ffffffffc020144e:	698d                	lui	s3,0x3
ffffffffc0201450:	4a31                	li	s4,12
ffffffffc0201452:	e0ca                	sd	s2,64(sp)
ffffffffc0201454:	ec86                	sd	ra,88(sp)
ffffffffc0201456:	e8a2                	sd	s0,80(sp)
ffffffffc0201458:	e4a6                	sd	s1,72(sp)
ffffffffc020145a:	f456                	sd	s5,40(sp)
ffffffffc020145c:	f05a                	sd	s6,32(sp)
ffffffffc020145e:	ec5e                	sd	s7,24(sp)
ffffffffc0201460:	e862                	sd	s8,16(sp)
ffffffffc0201462:	e466                	sd	s9,8(sp)
ffffffffc0201464:	e06a                	sd	s10,0(sp)
ffffffffc0201466:	c67fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020146a:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
ffffffffc020146e:	00015917          	auipc	s2,0x15
ffffffffc0201472:	0ea92903          	lw	s2,234(s2) # ffffffffc0216558 <pgfault_num>
ffffffffc0201476:	4791                	li	a5,4
ffffffffc0201478:	14f91e63          	bne	s2,a5,ffffffffc02015d4 <_fifo_check_swap+0x194>
ffffffffc020147c:	00005517          	auipc	a0,0x5
ffffffffc0201480:	8d450513          	addi	a0,a0,-1836 # ffffffffc0205d50 <commands+0xb78>
ffffffffc0201484:	6a85                	lui	s5,0x1
ffffffffc0201486:	4b29                	li	s6,10
ffffffffc0201488:	c45fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020148c:	00015417          	auipc	s0,0x15
ffffffffc0201490:	0cc40413          	addi	s0,s0,204 # ffffffffc0216558 <pgfault_num>
ffffffffc0201494:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201498:	4004                	lw	s1,0(s0)
ffffffffc020149a:	2481                	sext.w	s1,s1
ffffffffc020149c:	2b249c63          	bne	s1,s2,ffffffffc0201754 <_fifo_check_swap+0x314>
ffffffffc02014a0:	00005517          	auipc	a0,0x5
ffffffffc02014a4:	8d850513          	addi	a0,a0,-1832 # ffffffffc0205d78 <commands+0xba0>
ffffffffc02014a8:	6b91                	lui	s7,0x4
ffffffffc02014aa:	4c35                	li	s8,13
ffffffffc02014ac:	c21fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02014b0:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc02014b4:	00042903          	lw	s2,0(s0)
ffffffffc02014b8:	2901                	sext.w	s2,s2
ffffffffc02014ba:	26991d63          	bne	s2,s1,ffffffffc0201734 <_fifo_check_swap+0x2f4>
ffffffffc02014be:	00005517          	auipc	a0,0x5
ffffffffc02014c2:	8e250513          	addi	a0,a0,-1822 # ffffffffc0205da0 <commands+0xbc8>
ffffffffc02014c6:	6c89                	lui	s9,0x2
ffffffffc02014c8:	4d2d                	li	s10,11
ffffffffc02014ca:	c03fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02014ce:	01ac8023          	sb	s10,0(s9) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc02014d2:	401c                	lw	a5,0(s0)
ffffffffc02014d4:	2781                	sext.w	a5,a5
ffffffffc02014d6:	23279f63          	bne	a5,s2,ffffffffc0201714 <_fifo_check_swap+0x2d4>
ffffffffc02014da:	00005517          	auipc	a0,0x5
ffffffffc02014de:	8ee50513          	addi	a0,a0,-1810 # ffffffffc0205dc8 <commands+0xbf0>
ffffffffc02014e2:	bebfe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02014e6:	6795                	lui	a5,0x5
ffffffffc02014e8:	4739                	li	a4,14
ffffffffc02014ea:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc02014ee:	4004                	lw	s1,0(s0)
ffffffffc02014f0:	4795                	li	a5,5
ffffffffc02014f2:	2481                	sext.w	s1,s1
ffffffffc02014f4:	20f49063          	bne	s1,a5,ffffffffc02016f4 <_fifo_check_swap+0x2b4>
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	8a850513          	addi	a0,a0,-1880 # ffffffffc0205da0 <commands+0xbc8>
ffffffffc0201500:	bcdfe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201504:	01ac8023          	sb	s10,0(s9)
ffffffffc0201508:	401c                	lw	a5,0(s0)
ffffffffc020150a:	2781                	sext.w	a5,a5
ffffffffc020150c:	1c979463          	bne	a5,s1,ffffffffc02016d4 <_fifo_check_swap+0x294>
ffffffffc0201510:	00005517          	auipc	a0,0x5
ffffffffc0201514:	84050513          	addi	a0,a0,-1984 # ffffffffc0205d50 <commands+0xb78>
ffffffffc0201518:	bb5fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020151c:	016a8023          	sb	s6,0(s5)
ffffffffc0201520:	401c                	lw	a5,0(s0)
ffffffffc0201522:	4719                	li	a4,6
ffffffffc0201524:	2781                	sext.w	a5,a5
ffffffffc0201526:	18e79763          	bne	a5,a4,ffffffffc02016b4 <_fifo_check_swap+0x274>
ffffffffc020152a:	00005517          	auipc	a0,0x5
ffffffffc020152e:	87650513          	addi	a0,a0,-1930 # ffffffffc0205da0 <commands+0xbc8>
ffffffffc0201532:	b9bfe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201536:	01ac8023          	sb	s10,0(s9)
ffffffffc020153a:	401c                	lw	a5,0(s0)
ffffffffc020153c:	471d                	li	a4,7
ffffffffc020153e:	2781                	sext.w	a5,a5
ffffffffc0201540:	14e79a63          	bne	a5,a4,ffffffffc0201694 <_fifo_check_swap+0x254>
ffffffffc0201544:	00004517          	auipc	a0,0x4
ffffffffc0201548:	7bc50513          	addi	a0,a0,1980 # ffffffffc0205d00 <commands+0xb28>
ffffffffc020154c:	b81fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201550:	01498023          	sb	s4,0(s3)
ffffffffc0201554:	401c                	lw	a5,0(s0)
ffffffffc0201556:	4721                	li	a4,8
ffffffffc0201558:	2781                	sext.w	a5,a5
ffffffffc020155a:	10e79d63          	bne	a5,a4,ffffffffc0201674 <_fifo_check_swap+0x234>
ffffffffc020155e:	00005517          	auipc	a0,0x5
ffffffffc0201562:	81a50513          	addi	a0,a0,-2022 # ffffffffc0205d78 <commands+0xba0>
ffffffffc0201566:	b67fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020156a:	018b8023          	sb	s8,0(s7)
ffffffffc020156e:	401c                	lw	a5,0(s0)
ffffffffc0201570:	4725                	li	a4,9
ffffffffc0201572:	2781                	sext.w	a5,a5
ffffffffc0201574:	0ee79063          	bne	a5,a4,ffffffffc0201654 <_fifo_check_swap+0x214>
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	85050513          	addi	a0,a0,-1968 # ffffffffc0205dc8 <commands+0xbf0>
ffffffffc0201580:	b4dfe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201584:	6795                	lui	a5,0x5
ffffffffc0201586:	4739                	li	a4,14
ffffffffc0201588:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc020158c:	4004                	lw	s1,0(s0)
ffffffffc020158e:	47a9                	li	a5,10
ffffffffc0201590:	2481                	sext.w	s1,s1
ffffffffc0201592:	0af49163          	bne	s1,a5,ffffffffc0201634 <_fifo_check_swap+0x1f4>
ffffffffc0201596:	00004517          	auipc	a0,0x4
ffffffffc020159a:	7ba50513          	addi	a0,a0,1978 # ffffffffc0205d50 <commands+0xb78>
ffffffffc020159e:	b2ffe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02015a2:	6785                	lui	a5,0x1
ffffffffc02015a4:	0007c783          	lbu	a5,0(a5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02015a8:	06979663          	bne	a5,s1,ffffffffc0201614 <_fifo_check_swap+0x1d4>
ffffffffc02015ac:	401c                	lw	a5,0(s0)
ffffffffc02015ae:	472d                	li	a4,11
ffffffffc02015b0:	2781                	sext.w	a5,a5
ffffffffc02015b2:	04e79163          	bne	a5,a4,ffffffffc02015f4 <_fifo_check_swap+0x1b4>
ffffffffc02015b6:	60e6                	ld	ra,88(sp)
ffffffffc02015b8:	6446                	ld	s0,80(sp)
ffffffffc02015ba:	64a6                	ld	s1,72(sp)
ffffffffc02015bc:	6906                	ld	s2,64(sp)
ffffffffc02015be:	79e2                	ld	s3,56(sp)
ffffffffc02015c0:	7a42                	ld	s4,48(sp)
ffffffffc02015c2:	7aa2                	ld	s5,40(sp)
ffffffffc02015c4:	7b02                	ld	s6,32(sp)
ffffffffc02015c6:	6be2                	ld	s7,24(sp)
ffffffffc02015c8:	6c42                	ld	s8,16(sp)
ffffffffc02015ca:	6ca2                	ld	s9,8(sp)
ffffffffc02015cc:	6d02                	ld	s10,0(sp)
ffffffffc02015ce:	4501                	li	a0,0
ffffffffc02015d0:	6125                	addi	sp,sp,96
ffffffffc02015d2:	8082                	ret
ffffffffc02015d4:	00004697          	auipc	a3,0x4
ffffffffc02015d8:	75468693          	addi	a3,a3,1876 # ffffffffc0205d28 <commands+0xb50>
ffffffffc02015dc:	00004617          	auipc	a2,0x4
ffffffffc02015e0:	32460613          	addi	a2,a2,804 # ffffffffc0205900 <commands+0x728>
ffffffffc02015e4:	05100593          	li	a1,81
ffffffffc02015e8:	00004517          	auipc	a0,0x4
ffffffffc02015ec:	75050513          	addi	a0,a0,1872 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02015f0:	bd9fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02015f4:	00005697          	auipc	a3,0x5
ffffffffc02015f8:	88468693          	addi	a3,a3,-1916 # ffffffffc0205e78 <commands+0xca0>
ffffffffc02015fc:	00004617          	auipc	a2,0x4
ffffffffc0201600:	30460613          	addi	a2,a2,772 # ffffffffc0205900 <commands+0x728>
ffffffffc0201604:	07300593          	li	a1,115
ffffffffc0201608:	00004517          	auipc	a0,0x4
ffffffffc020160c:	73050513          	addi	a0,a0,1840 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201610:	bb9fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201614:	00005697          	auipc	a3,0x5
ffffffffc0201618:	83c68693          	addi	a3,a3,-1988 # ffffffffc0205e50 <commands+0xc78>
ffffffffc020161c:	00004617          	auipc	a2,0x4
ffffffffc0201620:	2e460613          	addi	a2,a2,740 # ffffffffc0205900 <commands+0x728>
ffffffffc0201624:	07100593          	li	a1,113
ffffffffc0201628:	00004517          	auipc	a0,0x4
ffffffffc020162c:	71050513          	addi	a0,a0,1808 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201630:	b99fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201634:	00005697          	auipc	a3,0x5
ffffffffc0201638:	80c68693          	addi	a3,a3,-2036 # ffffffffc0205e40 <commands+0xc68>
ffffffffc020163c:	00004617          	auipc	a2,0x4
ffffffffc0201640:	2c460613          	addi	a2,a2,708 # ffffffffc0205900 <commands+0x728>
ffffffffc0201644:	06f00593          	li	a1,111
ffffffffc0201648:	00004517          	auipc	a0,0x4
ffffffffc020164c:	6f050513          	addi	a0,a0,1776 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201650:	b79fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201654:	00004697          	auipc	a3,0x4
ffffffffc0201658:	7dc68693          	addi	a3,a3,2012 # ffffffffc0205e30 <commands+0xc58>
ffffffffc020165c:	00004617          	auipc	a2,0x4
ffffffffc0201660:	2a460613          	addi	a2,a2,676 # ffffffffc0205900 <commands+0x728>
ffffffffc0201664:	06c00593          	li	a1,108
ffffffffc0201668:	00004517          	auipc	a0,0x4
ffffffffc020166c:	6d050513          	addi	a0,a0,1744 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201670:	b59fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201674:	00004697          	auipc	a3,0x4
ffffffffc0201678:	7ac68693          	addi	a3,a3,1964 # ffffffffc0205e20 <commands+0xc48>
ffffffffc020167c:	00004617          	auipc	a2,0x4
ffffffffc0201680:	28460613          	addi	a2,a2,644 # ffffffffc0205900 <commands+0x728>
ffffffffc0201684:	06900593          	li	a1,105
ffffffffc0201688:	00004517          	auipc	a0,0x4
ffffffffc020168c:	6b050513          	addi	a0,a0,1712 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201690:	b39fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201694:	00004697          	auipc	a3,0x4
ffffffffc0201698:	77c68693          	addi	a3,a3,1916 # ffffffffc0205e10 <commands+0xc38>
ffffffffc020169c:	00004617          	auipc	a2,0x4
ffffffffc02016a0:	26460613          	addi	a2,a2,612 # ffffffffc0205900 <commands+0x728>
ffffffffc02016a4:	06600593          	li	a1,102
ffffffffc02016a8:	00004517          	auipc	a0,0x4
ffffffffc02016ac:	69050513          	addi	a0,a0,1680 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02016b0:	b19fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02016b4:	00004697          	auipc	a3,0x4
ffffffffc02016b8:	74c68693          	addi	a3,a3,1868 # ffffffffc0205e00 <commands+0xc28>
ffffffffc02016bc:	00004617          	auipc	a2,0x4
ffffffffc02016c0:	24460613          	addi	a2,a2,580 # ffffffffc0205900 <commands+0x728>
ffffffffc02016c4:	06300593          	li	a1,99
ffffffffc02016c8:	00004517          	auipc	a0,0x4
ffffffffc02016cc:	67050513          	addi	a0,a0,1648 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02016d0:	af9fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02016d4:	00004697          	auipc	a3,0x4
ffffffffc02016d8:	71c68693          	addi	a3,a3,1820 # ffffffffc0205df0 <commands+0xc18>
ffffffffc02016dc:	00004617          	auipc	a2,0x4
ffffffffc02016e0:	22460613          	addi	a2,a2,548 # ffffffffc0205900 <commands+0x728>
ffffffffc02016e4:	06000593          	li	a1,96
ffffffffc02016e8:	00004517          	auipc	a0,0x4
ffffffffc02016ec:	65050513          	addi	a0,a0,1616 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02016f0:	ad9fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02016f4:	00004697          	auipc	a3,0x4
ffffffffc02016f8:	6fc68693          	addi	a3,a3,1788 # ffffffffc0205df0 <commands+0xc18>
ffffffffc02016fc:	00004617          	auipc	a2,0x4
ffffffffc0201700:	20460613          	addi	a2,a2,516 # ffffffffc0205900 <commands+0x728>
ffffffffc0201704:	05d00593          	li	a1,93
ffffffffc0201708:	00004517          	auipc	a0,0x4
ffffffffc020170c:	63050513          	addi	a0,a0,1584 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201710:	ab9fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201714:	00004697          	auipc	a3,0x4
ffffffffc0201718:	61468693          	addi	a3,a3,1556 # ffffffffc0205d28 <commands+0xb50>
ffffffffc020171c:	00004617          	auipc	a2,0x4
ffffffffc0201720:	1e460613          	addi	a2,a2,484 # ffffffffc0205900 <commands+0x728>
ffffffffc0201724:	05a00593          	li	a1,90
ffffffffc0201728:	00004517          	auipc	a0,0x4
ffffffffc020172c:	61050513          	addi	a0,a0,1552 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201730:	a99fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201734:	00004697          	auipc	a3,0x4
ffffffffc0201738:	5f468693          	addi	a3,a3,1524 # ffffffffc0205d28 <commands+0xb50>
ffffffffc020173c:	00004617          	auipc	a2,0x4
ffffffffc0201740:	1c460613          	addi	a2,a2,452 # ffffffffc0205900 <commands+0x728>
ffffffffc0201744:	05700593          	li	a1,87
ffffffffc0201748:	00004517          	auipc	a0,0x4
ffffffffc020174c:	5f050513          	addi	a0,a0,1520 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201750:	a79fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201754:	00004697          	auipc	a3,0x4
ffffffffc0201758:	5d468693          	addi	a3,a3,1492 # ffffffffc0205d28 <commands+0xb50>
ffffffffc020175c:	00004617          	auipc	a2,0x4
ffffffffc0201760:	1a460613          	addi	a2,a2,420 # ffffffffc0205900 <commands+0x728>
ffffffffc0201764:	05400593          	li	a1,84
ffffffffc0201768:	00004517          	auipc	a0,0x4
ffffffffc020176c:	5d050513          	addi	a0,a0,1488 # ffffffffc0205d38 <commands+0xb60>
ffffffffc0201770:	a59fe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201774 <_fifo_swap_out_victim>:
ffffffffc0201774:	751c                	ld	a5,40(a0)
ffffffffc0201776:	1141                	addi	sp,sp,-16
ffffffffc0201778:	e406                	sd	ra,8(sp)
ffffffffc020177a:	cf91                	beqz	a5,ffffffffc0201796 <_fifo_swap_out_victim+0x22>
ffffffffc020177c:	ee0d                	bnez	a2,ffffffffc02017b6 <_fifo_swap_out_victim+0x42>
ffffffffc020177e:	679c                	ld	a5,8(a5)
ffffffffc0201780:	60a2                	ld	ra,8(sp)
ffffffffc0201782:	4501                	li	a0,0
ffffffffc0201784:	6394                	ld	a3,0(a5)
ffffffffc0201786:	6798                	ld	a4,8(a5)
ffffffffc0201788:	fd878793          	addi	a5,a5,-40
ffffffffc020178c:	e698                	sd	a4,8(a3)
ffffffffc020178e:	e314                	sd	a3,0(a4)
ffffffffc0201790:	e19c                	sd	a5,0(a1)
ffffffffc0201792:	0141                	addi	sp,sp,16
ffffffffc0201794:	8082                	ret
ffffffffc0201796:	00004697          	auipc	a3,0x4
ffffffffc020179a:	6f268693          	addi	a3,a3,1778 # ffffffffc0205e88 <commands+0xcb0>
ffffffffc020179e:	00004617          	auipc	a2,0x4
ffffffffc02017a2:	16260613          	addi	a2,a2,354 # ffffffffc0205900 <commands+0x728>
ffffffffc02017a6:	04100593          	li	a1,65
ffffffffc02017aa:	00004517          	auipc	a0,0x4
ffffffffc02017ae:	58e50513          	addi	a0,a0,1422 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02017b2:	a17fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02017b6:	00004697          	auipc	a3,0x4
ffffffffc02017ba:	6e268693          	addi	a3,a3,1762 # ffffffffc0205e98 <commands+0xcc0>
ffffffffc02017be:	00004617          	auipc	a2,0x4
ffffffffc02017c2:	14260613          	addi	a2,a2,322 # ffffffffc0205900 <commands+0x728>
ffffffffc02017c6:	04200593          	li	a1,66
ffffffffc02017ca:	00004517          	auipc	a0,0x4
ffffffffc02017ce:	56e50513          	addi	a0,a0,1390 # ffffffffc0205d38 <commands+0xb60>
ffffffffc02017d2:	9f7fe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc02017d6 <_fifo_map_swappable>:
ffffffffc02017d6:	751c                	ld	a5,40(a0)
ffffffffc02017d8:	cb91                	beqz	a5,ffffffffc02017ec <_fifo_map_swappable+0x16>
ffffffffc02017da:	6394                	ld	a3,0(a5)
ffffffffc02017dc:	02860713          	addi	a4,a2,40
ffffffffc02017e0:	e398                	sd	a4,0(a5)
ffffffffc02017e2:	e698                	sd	a4,8(a3)
ffffffffc02017e4:	4501                	li	a0,0
ffffffffc02017e6:	fa1c                	sd	a5,48(a2)
ffffffffc02017e8:	f614                	sd	a3,40(a2)
ffffffffc02017ea:	8082                	ret
ffffffffc02017ec:	1141                	addi	sp,sp,-16
ffffffffc02017ee:	00004697          	auipc	a3,0x4
ffffffffc02017f2:	6ba68693          	addi	a3,a3,1722 # ffffffffc0205ea8 <commands+0xcd0>
ffffffffc02017f6:	00004617          	auipc	a2,0x4
ffffffffc02017fa:	10a60613          	addi	a2,a2,266 # ffffffffc0205900 <commands+0x728>
ffffffffc02017fe:	03200593          	li	a1,50
ffffffffc0201802:	00004517          	auipc	a0,0x4
ffffffffc0201806:	53650513          	addi	a0,a0,1334 # ffffffffc0205d38 <commands+0xb60>
ffffffffc020180a:	e406                	sd	ra,8(sp)
ffffffffc020180c:	9bdfe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201810 <slob_free>:
ffffffffc0201810:	c94d                	beqz	a0,ffffffffc02018c2 <slob_free+0xb2>
ffffffffc0201812:	1141                	addi	sp,sp,-16
ffffffffc0201814:	e022                	sd	s0,0(sp)
ffffffffc0201816:	e406                	sd	ra,8(sp)
ffffffffc0201818:	842a                	mv	s0,a0
ffffffffc020181a:	e9c1                	bnez	a1,ffffffffc02018aa <slob_free+0x9a>
ffffffffc020181c:	100027f3          	csrr	a5,sstatus
ffffffffc0201820:	8b89                	andi	a5,a5,2
ffffffffc0201822:	4501                	li	a0,0
ffffffffc0201824:	ebd9                	bnez	a5,ffffffffc02018ba <slob_free+0xaa>
ffffffffc0201826:	0000a617          	auipc	a2,0xa
ffffffffc020182a:	82a60613          	addi	a2,a2,-2006 # ffffffffc020b050 <slobfree>
ffffffffc020182e:	621c                	ld	a5,0(a2)
ffffffffc0201830:	873e                	mv	a4,a5
ffffffffc0201832:	679c                	ld	a5,8(a5)
ffffffffc0201834:	02877a63          	bgeu	a4,s0,ffffffffc0201868 <slob_free+0x58>
ffffffffc0201838:	00f46463          	bltu	s0,a5,ffffffffc0201840 <slob_free+0x30>
ffffffffc020183c:	fef76ae3          	bltu	a4,a5,ffffffffc0201830 <slob_free+0x20>
ffffffffc0201840:	400c                	lw	a1,0(s0)
ffffffffc0201842:	00459693          	slli	a3,a1,0x4
ffffffffc0201846:	96a2                	add	a3,a3,s0
ffffffffc0201848:	02d78a63          	beq	a5,a3,ffffffffc020187c <slob_free+0x6c>
ffffffffc020184c:	4314                	lw	a3,0(a4)
ffffffffc020184e:	e41c                	sd	a5,8(s0)
ffffffffc0201850:	00469793          	slli	a5,a3,0x4
ffffffffc0201854:	97ba                	add	a5,a5,a4
ffffffffc0201856:	02f40e63          	beq	s0,a5,ffffffffc0201892 <slob_free+0x82>
ffffffffc020185a:	e700                	sd	s0,8(a4)
ffffffffc020185c:	e218                	sd	a4,0(a2)
ffffffffc020185e:	e129                	bnez	a0,ffffffffc02018a0 <slob_free+0x90>
ffffffffc0201860:	60a2                	ld	ra,8(sp)
ffffffffc0201862:	6402                	ld	s0,0(sp)
ffffffffc0201864:	0141                	addi	sp,sp,16
ffffffffc0201866:	8082                	ret
ffffffffc0201868:	fcf764e3          	bltu	a4,a5,ffffffffc0201830 <slob_free+0x20>
ffffffffc020186c:	fcf472e3          	bgeu	s0,a5,ffffffffc0201830 <slob_free+0x20>
ffffffffc0201870:	400c                	lw	a1,0(s0)
ffffffffc0201872:	00459693          	slli	a3,a1,0x4
ffffffffc0201876:	96a2                	add	a3,a3,s0
ffffffffc0201878:	fcd79ae3          	bne	a5,a3,ffffffffc020184c <slob_free+0x3c>
ffffffffc020187c:	4394                	lw	a3,0(a5)
ffffffffc020187e:	679c                	ld	a5,8(a5)
ffffffffc0201880:	9db5                	addw	a1,a1,a3
ffffffffc0201882:	c00c                	sw	a1,0(s0)
ffffffffc0201884:	4314                	lw	a3,0(a4)
ffffffffc0201886:	e41c                	sd	a5,8(s0)
ffffffffc0201888:	00469793          	slli	a5,a3,0x4
ffffffffc020188c:	97ba                	add	a5,a5,a4
ffffffffc020188e:	fcf416e3          	bne	s0,a5,ffffffffc020185a <slob_free+0x4a>
ffffffffc0201892:	401c                	lw	a5,0(s0)
ffffffffc0201894:	640c                	ld	a1,8(s0)
ffffffffc0201896:	e218                	sd	a4,0(a2)
ffffffffc0201898:	9ebd                	addw	a3,a3,a5
ffffffffc020189a:	c314                	sw	a3,0(a4)
ffffffffc020189c:	e70c                	sd	a1,8(a4)
ffffffffc020189e:	d169                	beqz	a0,ffffffffc0201860 <slob_free+0x50>
ffffffffc02018a0:	6402                	ld	s0,0(sp)
ffffffffc02018a2:	60a2                	ld	ra,8(sp)
ffffffffc02018a4:	0141                	addi	sp,sp,16
ffffffffc02018a6:	d19fe06f          	j	ffffffffc02005be <intr_enable>
ffffffffc02018aa:	25bd                	addiw	a1,a1,15
ffffffffc02018ac:	8191                	srli	a1,a1,0x4
ffffffffc02018ae:	c10c                	sw	a1,0(a0)
ffffffffc02018b0:	100027f3          	csrr	a5,sstatus
ffffffffc02018b4:	8b89                	andi	a5,a5,2
ffffffffc02018b6:	4501                	li	a0,0
ffffffffc02018b8:	d7bd                	beqz	a5,ffffffffc0201826 <slob_free+0x16>
ffffffffc02018ba:	d0bfe0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02018be:	4505                	li	a0,1
ffffffffc02018c0:	b79d                	j	ffffffffc0201826 <slob_free+0x16>
ffffffffc02018c2:	8082                	ret

ffffffffc02018c4 <__slob_get_free_pages.constprop.0>:
ffffffffc02018c4:	4785                	li	a5,1
ffffffffc02018c6:	1141                	addi	sp,sp,-16
ffffffffc02018c8:	00a7953b          	sllw	a0,a5,a0
ffffffffc02018cc:	e406                	sd	ra,8(sp)
ffffffffc02018ce:	6ee010ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02018d2:	c91d                	beqz	a0,ffffffffc0201908 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc02018d4:	00015697          	auipc	a3,0x15
ffffffffc02018d8:	cc46b683          	ld	a3,-828(a3) # ffffffffc0216598 <pages>
ffffffffc02018dc:	8d15                	sub	a0,a0,a3
ffffffffc02018de:	8519                	srai	a0,a0,0x6
ffffffffc02018e0:	00005697          	auipc	a3,0x5
ffffffffc02018e4:	7986b683          	ld	a3,1944(a3) # ffffffffc0207078 <nbase>
ffffffffc02018e8:	9536                	add	a0,a0,a3
ffffffffc02018ea:	00c51793          	slli	a5,a0,0xc
ffffffffc02018ee:	83b1                	srli	a5,a5,0xc
ffffffffc02018f0:	00015717          	auipc	a4,0x15
ffffffffc02018f4:	ca073703          	ld	a4,-864(a4) # ffffffffc0216590 <npage>
ffffffffc02018f8:	0532                	slli	a0,a0,0xc
ffffffffc02018fa:	00e7fa63          	bgeu	a5,a4,ffffffffc020190e <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02018fe:	00015697          	auipc	a3,0x15
ffffffffc0201902:	caa6b683          	ld	a3,-854(a3) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0201906:	9536                	add	a0,a0,a3
ffffffffc0201908:	60a2                	ld	ra,8(sp)
ffffffffc020190a:	0141                	addi	sp,sp,16
ffffffffc020190c:	8082                	ret
ffffffffc020190e:	86aa                	mv	a3,a0
ffffffffc0201910:	00004617          	auipc	a2,0x4
ffffffffc0201914:	24860613          	addi	a2,a2,584 # ffffffffc0205b58 <commands+0x980>
ffffffffc0201918:	06900593          	li	a1,105
ffffffffc020191c:	00004517          	auipc	a0,0x4
ffffffffc0201920:	22c50513          	addi	a0,a0,556 # ffffffffc0205b48 <commands+0x970>
ffffffffc0201924:	8a5fe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201928 <slob_alloc.constprop.0>:
ffffffffc0201928:	1101                	addi	sp,sp,-32
ffffffffc020192a:	ec06                	sd	ra,24(sp)
ffffffffc020192c:	e822                	sd	s0,16(sp)
ffffffffc020192e:	e426                	sd	s1,8(sp)
ffffffffc0201930:	e04a                	sd	s2,0(sp)
ffffffffc0201932:	01050713          	addi	a4,a0,16
ffffffffc0201936:	6785                	lui	a5,0x1
ffffffffc0201938:	0cf77363          	bgeu	a4,a5,ffffffffc02019fe <slob_alloc.constprop.0+0xd6>
ffffffffc020193c:	00f50493          	addi	s1,a0,15
ffffffffc0201940:	8091                	srli	s1,s1,0x4
ffffffffc0201942:	2481                	sext.w	s1,s1
ffffffffc0201944:	10002673          	csrr	a2,sstatus
ffffffffc0201948:	8a09                	andi	a2,a2,2
ffffffffc020194a:	e25d                	bnez	a2,ffffffffc02019f0 <slob_alloc.constprop.0+0xc8>
ffffffffc020194c:	00009917          	auipc	s2,0x9
ffffffffc0201950:	70490913          	addi	s2,s2,1796 # ffffffffc020b050 <slobfree>
ffffffffc0201954:	00093683          	ld	a3,0(s2)
ffffffffc0201958:	669c                	ld	a5,8(a3)
ffffffffc020195a:	4398                	lw	a4,0(a5)
ffffffffc020195c:	08975e63          	bge	a4,s1,ffffffffc02019f8 <slob_alloc.constprop.0+0xd0>
ffffffffc0201960:	00d78b63          	beq	a5,a3,ffffffffc0201976 <slob_alloc.constprop.0+0x4e>
ffffffffc0201964:	6780                	ld	s0,8(a5)
ffffffffc0201966:	4018                	lw	a4,0(s0)
ffffffffc0201968:	02975a63          	bge	a4,s1,ffffffffc020199c <slob_alloc.constprop.0+0x74>
ffffffffc020196c:	00093683          	ld	a3,0(s2)
ffffffffc0201970:	87a2                	mv	a5,s0
ffffffffc0201972:	fed799e3          	bne	a5,a3,ffffffffc0201964 <slob_alloc.constprop.0+0x3c>
ffffffffc0201976:	ee31                	bnez	a2,ffffffffc02019d2 <slob_alloc.constprop.0+0xaa>
ffffffffc0201978:	4501                	li	a0,0
ffffffffc020197a:	f4bff0ef          	jal	ra,ffffffffc02018c4 <__slob_get_free_pages.constprop.0>
ffffffffc020197e:	842a                	mv	s0,a0
ffffffffc0201980:	cd05                	beqz	a0,ffffffffc02019b8 <slob_alloc.constprop.0+0x90>
ffffffffc0201982:	6585                	lui	a1,0x1
ffffffffc0201984:	e8dff0ef          	jal	ra,ffffffffc0201810 <slob_free>
ffffffffc0201988:	10002673          	csrr	a2,sstatus
ffffffffc020198c:	8a09                	andi	a2,a2,2
ffffffffc020198e:	ee05                	bnez	a2,ffffffffc02019c6 <slob_alloc.constprop.0+0x9e>
ffffffffc0201990:	00093783          	ld	a5,0(s2)
ffffffffc0201994:	6780                	ld	s0,8(a5)
ffffffffc0201996:	4018                	lw	a4,0(s0)
ffffffffc0201998:	fc974ae3          	blt	a4,s1,ffffffffc020196c <slob_alloc.constprop.0+0x44>
ffffffffc020199c:	04e48763          	beq	s1,a4,ffffffffc02019ea <slob_alloc.constprop.0+0xc2>
ffffffffc02019a0:	00449693          	slli	a3,s1,0x4
ffffffffc02019a4:	96a2                	add	a3,a3,s0
ffffffffc02019a6:	e794                	sd	a3,8(a5)
ffffffffc02019a8:	640c                	ld	a1,8(s0)
ffffffffc02019aa:	9f05                	subw	a4,a4,s1
ffffffffc02019ac:	c298                	sw	a4,0(a3)
ffffffffc02019ae:	e68c                	sd	a1,8(a3)
ffffffffc02019b0:	c004                	sw	s1,0(s0)
ffffffffc02019b2:	00f93023          	sd	a5,0(s2)
ffffffffc02019b6:	e20d                	bnez	a2,ffffffffc02019d8 <slob_alloc.constprop.0+0xb0>
ffffffffc02019b8:	60e2                	ld	ra,24(sp)
ffffffffc02019ba:	8522                	mv	a0,s0
ffffffffc02019bc:	6442                	ld	s0,16(sp)
ffffffffc02019be:	64a2                	ld	s1,8(sp)
ffffffffc02019c0:	6902                	ld	s2,0(sp)
ffffffffc02019c2:	6105                	addi	sp,sp,32
ffffffffc02019c4:	8082                	ret
ffffffffc02019c6:	bfffe0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02019ca:	00093783          	ld	a5,0(s2)
ffffffffc02019ce:	4605                	li	a2,1
ffffffffc02019d0:	b7d1                	j	ffffffffc0201994 <slob_alloc.constprop.0+0x6c>
ffffffffc02019d2:	bedfe0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc02019d6:	b74d                	j	ffffffffc0201978 <slob_alloc.constprop.0+0x50>
ffffffffc02019d8:	be7fe0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc02019dc:	60e2                	ld	ra,24(sp)
ffffffffc02019de:	8522                	mv	a0,s0
ffffffffc02019e0:	6442                	ld	s0,16(sp)
ffffffffc02019e2:	64a2                	ld	s1,8(sp)
ffffffffc02019e4:	6902                	ld	s2,0(sp)
ffffffffc02019e6:	6105                	addi	sp,sp,32
ffffffffc02019e8:	8082                	ret
ffffffffc02019ea:	6418                	ld	a4,8(s0)
ffffffffc02019ec:	e798                	sd	a4,8(a5)
ffffffffc02019ee:	b7d1                	j	ffffffffc02019b2 <slob_alloc.constprop.0+0x8a>
ffffffffc02019f0:	bd5fe0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02019f4:	4605                	li	a2,1
ffffffffc02019f6:	bf99                	j	ffffffffc020194c <slob_alloc.constprop.0+0x24>
ffffffffc02019f8:	843e                	mv	s0,a5
ffffffffc02019fa:	87b6                	mv	a5,a3
ffffffffc02019fc:	b745                	j	ffffffffc020199c <slob_alloc.constprop.0+0x74>
ffffffffc02019fe:	00004697          	auipc	a3,0x4
ffffffffc0201a02:	4e268693          	addi	a3,a3,1250 # ffffffffc0205ee0 <commands+0xd08>
ffffffffc0201a06:	00004617          	auipc	a2,0x4
ffffffffc0201a0a:	efa60613          	addi	a2,a2,-262 # ffffffffc0205900 <commands+0x728>
ffffffffc0201a0e:	06300593          	li	a1,99
ffffffffc0201a12:	00004517          	auipc	a0,0x4
ffffffffc0201a16:	4ee50513          	addi	a0,a0,1262 # ffffffffc0205f00 <commands+0xd28>
ffffffffc0201a1a:	faefe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201a1e <kmalloc_init>:
ffffffffc0201a1e:	1141                	addi	sp,sp,-16
ffffffffc0201a20:	00004517          	auipc	a0,0x4
ffffffffc0201a24:	4f850513          	addi	a0,a0,1272 # ffffffffc0205f18 <commands+0xd40>
ffffffffc0201a28:	e406                	sd	ra,8(sp)
ffffffffc0201a2a:	ea2fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201a2e:	60a2                	ld	ra,8(sp)
ffffffffc0201a30:	00004517          	auipc	a0,0x4
ffffffffc0201a34:	50050513          	addi	a0,a0,1280 # ffffffffc0205f30 <commands+0xd58>
ffffffffc0201a38:	0141                	addi	sp,sp,16
ffffffffc0201a3a:	e92fe06f          	j	ffffffffc02000cc <cprintf>

ffffffffc0201a3e <kmalloc>:
ffffffffc0201a3e:	1101                	addi	sp,sp,-32
ffffffffc0201a40:	e04a                	sd	s2,0(sp)
ffffffffc0201a42:	6905                	lui	s2,0x1
ffffffffc0201a44:	e822                	sd	s0,16(sp)
ffffffffc0201a46:	ec06                	sd	ra,24(sp)
ffffffffc0201a48:	e426                	sd	s1,8(sp)
ffffffffc0201a4a:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201a4e:	842a                	mv	s0,a0
ffffffffc0201a50:	04a7f963          	bgeu	a5,a0,ffffffffc0201aa2 <kmalloc+0x64>
ffffffffc0201a54:	4561                	li	a0,24
ffffffffc0201a56:	ed3ff0ef          	jal	ra,ffffffffc0201928 <slob_alloc.constprop.0>
ffffffffc0201a5a:	84aa                	mv	s1,a0
ffffffffc0201a5c:	c929                	beqz	a0,ffffffffc0201aae <kmalloc+0x70>
ffffffffc0201a5e:	0004079b          	sext.w	a5,s0
ffffffffc0201a62:	4501                	li	a0,0
ffffffffc0201a64:	00f95763          	bge	s2,a5,ffffffffc0201a72 <kmalloc+0x34>
ffffffffc0201a68:	6705                	lui	a4,0x1
ffffffffc0201a6a:	8785                	srai	a5,a5,0x1
ffffffffc0201a6c:	2505                	addiw	a0,a0,1
ffffffffc0201a6e:	fef74ee3          	blt	a4,a5,ffffffffc0201a6a <kmalloc+0x2c>
ffffffffc0201a72:	c088                	sw	a0,0(s1)
ffffffffc0201a74:	e51ff0ef          	jal	ra,ffffffffc02018c4 <__slob_get_free_pages.constprop.0>
ffffffffc0201a78:	e488                	sd	a0,8(s1)
ffffffffc0201a7a:	842a                	mv	s0,a0
ffffffffc0201a7c:	c525                	beqz	a0,ffffffffc0201ae4 <kmalloc+0xa6>
ffffffffc0201a7e:	100027f3          	csrr	a5,sstatus
ffffffffc0201a82:	8b89                	andi	a5,a5,2
ffffffffc0201a84:	ef8d                	bnez	a5,ffffffffc0201abe <kmalloc+0x80>
ffffffffc0201a86:	00015797          	auipc	a5,0x15
ffffffffc0201a8a:	ada78793          	addi	a5,a5,-1318 # ffffffffc0216560 <bigblocks>
ffffffffc0201a8e:	6398                	ld	a4,0(a5)
ffffffffc0201a90:	e384                	sd	s1,0(a5)
ffffffffc0201a92:	e898                	sd	a4,16(s1)
ffffffffc0201a94:	60e2                	ld	ra,24(sp)
ffffffffc0201a96:	8522                	mv	a0,s0
ffffffffc0201a98:	6442                	ld	s0,16(sp)
ffffffffc0201a9a:	64a2                	ld	s1,8(sp)
ffffffffc0201a9c:	6902                	ld	s2,0(sp)
ffffffffc0201a9e:	6105                	addi	sp,sp,32
ffffffffc0201aa0:	8082                	ret
ffffffffc0201aa2:	0541                	addi	a0,a0,16
ffffffffc0201aa4:	e85ff0ef          	jal	ra,ffffffffc0201928 <slob_alloc.constprop.0>
ffffffffc0201aa8:	01050413          	addi	s0,a0,16
ffffffffc0201aac:	f565                	bnez	a0,ffffffffc0201a94 <kmalloc+0x56>
ffffffffc0201aae:	4401                	li	s0,0
ffffffffc0201ab0:	60e2                	ld	ra,24(sp)
ffffffffc0201ab2:	8522                	mv	a0,s0
ffffffffc0201ab4:	6442                	ld	s0,16(sp)
ffffffffc0201ab6:	64a2                	ld	s1,8(sp)
ffffffffc0201ab8:	6902                	ld	s2,0(sp)
ffffffffc0201aba:	6105                	addi	sp,sp,32
ffffffffc0201abc:	8082                	ret
ffffffffc0201abe:	b07fe0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0201ac2:	00015797          	auipc	a5,0x15
ffffffffc0201ac6:	a9e78793          	addi	a5,a5,-1378 # ffffffffc0216560 <bigblocks>
ffffffffc0201aca:	6398                	ld	a4,0(a5)
ffffffffc0201acc:	e384                	sd	s1,0(a5)
ffffffffc0201ace:	e898                	sd	a4,16(s1)
ffffffffc0201ad0:	aeffe0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0201ad4:	6480                	ld	s0,8(s1)
ffffffffc0201ad6:	60e2                	ld	ra,24(sp)
ffffffffc0201ad8:	64a2                	ld	s1,8(sp)
ffffffffc0201ada:	8522                	mv	a0,s0
ffffffffc0201adc:	6442                	ld	s0,16(sp)
ffffffffc0201ade:	6902                	ld	s2,0(sp)
ffffffffc0201ae0:	6105                	addi	sp,sp,32
ffffffffc0201ae2:	8082                	ret
ffffffffc0201ae4:	45e1                	li	a1,24
ffffffffc0201ae6:	8526                	mv	a0,s1
ffffffffc0201ae8:	d29ff0ef          	jal	ra,ffffffffc0201810 <slob_free>
ffffffffc0201aec:	b765                	j	ffffffffc0201a94 <kmalloc+0x56>

ffffffffc0201aee <kfree>:
ffffffffc0201aee:	c169                	beqz	a0,ffffffffc0201bb0 <kfree+0xc2>
ffffffffc0201af0:	1101                	addi	sp,sp,-32
ffffffffc0201af2:	e822                	sd	s0,16(sp)
ffffffffc0201af4:	ec06                	sd	ra,24(sp)
ffffffffc0201af6:	e426                	sd	s1,8(sp)
ffffffffc0201af8:	03451793          	slli	a5,a0,0x34
ffffffffc0201afc:	842a                	mv	s0,a0
ffffffffc0201afe:	e3d9                	bnez	a5,ffffffffc0201b84 <kfree+0x96>
ffffffffc0201b00:	100027f3          	csrr	a5,sstatus
ffffffffc0201b04:	8b89                	andi	a5,a5,2
ffffffffc0201b06:	e7d9                	bnez	a5,ffffffffc0201b94 <kfree+0xa6>
ffffffffc0201b08:	00015797          	auipc	a5,0x15
ffffffffc0201b0c:	a587b783          	ld	a5,-1448(a5) # ffffffffc0216560 <bigblocks>
ffffffffc0201b10:	4601                	li	a2,0
ffffffffc0201b12:	cbad                	beqz	a5,ffffffffc0201b84 <kfree+0x96>
ffffffffc0201b14:	00015697          	auipc	a3,0x15
ffffffffc0201b18:	a4c68693          	addi	a3,a3,-1460 # ffffffffc0216560 <bigblocks>
ffffffffc0201b1c:	a021                	j	ffffffffc0201b24 <kfree+0x36>
ffffffffc0201b1e:	01048693          	addi	a3,s1,16
ffffffffc0201b22:	c3a5                	beqz	a5,ffffffffc0201b82 <kfree+0x94>
ffffffffc0201b24:	6798                	ld	a4,8(a5)
ffffffffc0201b26:	84be                	mv	s1,a5
ffffffffc0201b28:	6b9c                	ld	a5,16(a5)
ffffffffc0201b2a:	fe871ae3          	bne	a4,s0,ffffffffc0201b1e <kfree+0x30>
ffffffffc0201b2e:	e29c                	sd	a5,0(a3)
ffffffffc0201b30:	ee2d                	bnez	a2,ffffffffc0201baa <kfree+0xbc>
ffffffffc0201b32:	c02007b7          	lui	a5,0xc0200
ffffffffc0201b36:	4098                	lw	a4,0(s1)
ffffffffc0201b38:	08f46963          	bltu	s0,a5,ffffffffc0201bca <kfree+0xdc>
ffffffffc0201b3c:	00015697          	auipc	a3,0x15
ffffffffc0201b40:	a6c6b683          	ld	a3,-1428(a3) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0201b44:	8c15                	sub	s0,s0,a3
ffffffffc0201b46:	8031                	srli	s0,s0,0xc
ffffffffc0201b48:	00015797          	auipc	a5,0x15
ffffffffc0201b4c:	a487b783          	ld	a5,-1464(a5) # ffffffffc0216590 <npage>
ffffffffc0201b50:	06f47163          	bgeu	s0,a5,ffffffffc0201bb2 <kfree+0xc4>
ffffffffc0201b54:	00005517          	auipc	a0,0x5
ffffffffc0201b58:	52453503          	ld	a0,1316(a0) # ffffffffc0207078 <nbase>
ffffffffc0201b5c:	8c09                	sub	s0,s0,a0
ffffffffc0201b5e:	041a                	slli	s0,s0,0x6
ffffffffc0201b60:	00015517          	auipc	a0,0x15
ffffffffc0201b64:	a3853503          	ld	a0,-1480(a0) # ffffffffc0216598 <pages>
ffffffffc0201b68:	4585                	li	a1,1
ffffffffc0201b6a:	9522                	add	a0,a0,s0
ffffffffc0201b6c:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201b70:	4de010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0201b74:	6442                	ld	s0,16(sp)
ffffffffc0201b76:	60e2                	ld	ra,24(sp)
ffffffffc0201b78:	8526                	mv	a0,s1
ffffffffc0201b7a:	64a2                	ld	s1,8(sp)
ffffffffc0201b7c:	45e1                	li	a1,24
ffffffffc0201b7e:	6105                	addi	sp,sp,32
ffffffffc0201b80:	b941                	j	ffffffffc0201810 <slob_free>
ffffffffc0201b82:	e20d                	bnez	a2,ffffffffc0201ba4 <kfree+0xb6>
ffffffffc0201b84:	ff040513          	addi	a0,s0,-16
ffffffffc0201b88:	6442                	ld	s0,16(sp)
ffffffffc0201b8a:	60e2                	ld	ra,24(sp)
ffffffffc0201b8c:	64a2                	ld	s1,8(sp)
ffffffffc0201b8e:	4581                	li	a1,0
ffffffffc0201b90:	6105                	addi	sp,sp,32
ffffffffc0201b92:	b9bd                	j	ffffffffc0201810 <slob_free>
ffffffffc0201b94:	a31fe0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0201b98:	00015797          	auipc	a5,0x15
ffffffffc0201b9c:	9c87b783          	ld	a5,-1592(a5) # ffffffffc0216560 <bigblocks>
ffffffffc0201ba0:	4605                	li	a2,1
ffffffffc0201ba2:	fbad                	bnez	a5,ffffffffc0201b14 <kfree+0x26>
ffffffffc0201ba4:	a1bfe0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0201ba8:	bff1                	j	ffffffffc0201b84 <kfree+0x96>
ffffffffc0201baa:	a15fe0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0201bae:	b751                	j	ffffffffc0201b32 <kfree+0x44>
ffffffffc0201bb0:	8082                	ret
ffffffffc0201bb2:	00004617          	auipc	a2,0x4
ffffffffc0201bb6:	f7660613          	addi	a2,a2,-138 # ffffffffc0205b28 <commands+0x950>
ffffffffc0201bba:	06200593          	li	a1,98
ffffffffc0201bbe:	00004517          	auipc	a0,0x4
ffffffffc0201bc2:	f8a50513          	addi	a0,a0,-118 # ffffffffc0205b48 <commands+0x970>
ffffffffc0201bc6:	e02fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201bca:	86a2                	mv	a3,s0
ffffffffc0201bcc:	00004617          	auipc	a2,0x4
ffffffffc0201bd0:	38460613          	addi	a2,a2,900 # ffffffffc0205f50 <commands+0xd78>
ffffffffc0201bd4:	06e00593          	li	a1,110
ffffffffc0201bd8:	00004517          	auipc	a0,0x4
ffffffffc0201bdc:	f7050513          	addi	a0,a0,-144 # ffffffffc0205b48 <commands+0x970>
ffffffffc0201be0:	de8fe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201be4 <pa2page.part.0>:
ffffffffc0201be4:	1141                	addi	sp,sp,-16
ffffffffc0201be6:	00004617          	auipc	a2,0x4
ffffffffc0201bea:	f4260613          	addi	a2,a2,-190 # ffffffffc0205b28 <commands+0x950>
ffffffffc0201bee:	06200593          	li	a1,98
ffffffffc0201bf2:	00004517          	auipc	a0,0x4
ffffffffc0201bf6:	f5650513          	addi	a0,a0,-170 # ffffffffc0205b48 <commands+0x970>
ffffffffc0201bfa:	e406                	sd	ra,8(sp)
ffffffffc0201bfc:	dccfe0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0201c00 <swap_init>:
ffffffffc0201c00:	7135                	addi	sp,sp,-160
ffffffffc0201c02:	ed06                	sd	ra,152(sp)
ffffffffc0201c04:	e922                	sd	s0,144(sp)
ffffffffc0201c06:	e526                	sd	s1,136(sp)
ffffffffc0201c08:	e14a                	sd	s2,128(sp)
ffffffffc0201c0a:	fcce                	sd	s3,120(sp)
ffffffffc0201c0c:	f8d2                	sd	s4,112(sp)
ffffffffc0201c0e:	f4d6                	sd	s5,104(sp)
ffffffffc0201c10:	f0da                	sd	s6,96(sp)
ffffffffc0201c12:	ecde                	sd	s7,88(sp)
ffffffffc0201c14:	e8e2                	sd	s8,80(sp)
ffffffffc0201c16:	e4e6                	sd	s9,72(sp)
ffffffffc0201c18:	e0ea                	sd	s10,64(sp)
ffffffffc0201c1a:	fc6e                	sd	s11,56(sp)
ffffffffc0201c1c:	4bc020ef          	jal	ra,ffffffffc02040d8 <swapfs_init>
ffffffffc0201c20:	00015697          	auipc	a3,0x15
ffffffffc0201c24:	9486b683          	ld	a3,-1720(a3) # ffffffffc0216568 <max_swap_offset>
ffffffffc0201c28:	010007b7          	lui	a5,0x1000
ffffffffc0201c2c:	ff968713          	addi	a4,a3,-7
ffffffffc0201c30:	17e1                	addi	a5,a5,-8
ffffffffc0201c32:	42e7e063          	bltu	a5,a4,ffffffffc0202052 <swap_init+0x452>
ffffffffc0201c36:	00009797          	auipc	a5,0x9
ffffffffc0201c3a:	3ca78793          	addi	a5,a5,970 # ffffffffc020b000 <swap_manager_fifo>
ffffffffc0201c3e:	6798                	ld	a4,8(a5)
ffffffffc0201c40:	00015b97          	auipc	s7,0x15
ffffffffc0201c44:	930b8b93          	addi	s7,s7,-1744 # ffffffffc0216570 <sm>
ffffffffc0201c48:	00fbb023          	sd	a5,0(s7)
ffffffffc0201c4c:	9702                	jalr	a4
ffffffffc0201c4e:	892a                	mv	s2,a0
ffffffffc0201c50:	c10d                	beqz	a0,ffffffffc0201c72 <swap_init+0x72>
ffffffffc0201c52:	60ea                	ld	ra,152(sp)
ffffffffc0201c54:	644a                	ld	s0,144(sp)
ffffffffc0201c56:	64aa                	ld	s1,136(sp)
ffffffffc0201c58:	79e6                	ld	s3,120(sp)
ffffffffc0201c5a:	7a46                	ld	s4,112(sp)
ffffffffc0201c5c:	7aa6                	ld	s5,104(sp)
ffffffffc0201c5e:	7b06                	ld	s6,96(sp)
ffffffffc0201c60:	6be6                	ld	s7,88(sp)
ffffffffc0201c62:	6c46                	ld	s8,80(sp)
ffffffffc0201c64:	6ca6                	ld	s9,72(sp)
ffffffffc0201c66:	6d06                	ld	s10,64(sp)
ffffffffc0201c68:	7de2                	ld	s11,56(sp)
ffffffffc0201c6a:	854a                	mv	a0,s2
ffffffffc0201c6c:	690a                	ld	s2,128(sp)
ffffffffc0201c6e:	610d                	addi	sp,sp,160
ffffffffc0201c70:	8082                	ret
ffffffffc0201c72:	000bb783          	ld	a5,0(s7)
ffffffffc0201c76:	00004517          	auipc	a0,0x4
ffffffffc0201c7a:	33250513          	addi	a0,a0,818 # ffffffffc0205fa8 <commands+0xdd0>
ffffffffc0201c7e:	00011417          	auipc	s0,0x11
ffffffffc0201c82:	88240413          	addi	s0,s0,-1918 # ffffffffc0212500 <free_area>
ffffffffc0201c86:	638c                	ld	a1,0(a5)
ffffffffc0201c88:	4785                	li	a5,1
ffffffffc0201c8a:	00015717          	auipc	a4,0x15
ffffffffc0201c8e:	8ef72723          	sw	a5,-1810(a4) # ffffffffc0216578 <swap_init_ok>
ffffffffc0201c92:	c3afe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201c96:	641c                	ld	a5,8(s0)
ffffffffc0201c98:	4d01                	li	s10,0
ffffffffc0201c9a:	4d81                	li	s11,0
ffffffffc0201c9c:	32878b63          	beq	a5,s0,ffffffffc0201fd2 <swap_init+0x3d2>
ffffffffc0201ca0:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201ca4:	8b09                	andi	a4,a4,2
ffffffffc0201ca6:	32070863          	beqz	a4,ffffffffc0201fd6 <swap_init+0x3d6>
ffffffffc0201caa:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201cae:	679c                	ld	a5,8(a5)
ffffffffc0201cb0:	2d85                	addiw	s11,s11,1
ffffffffc0201cb2:	01a70d3b          	addw	s10,a4,s10
ffffffffc0201cb6:	fe8795e3          	bne	a5,s0,ffffffffc0201ca0 <swap_init+0xa0>
ffffffffc0201cba:	84ea                	mv	s1,s10
ffffffffc0201cbc:	3d2010ef          	jal	ra,ffffffffc020308e <nr_free_pages>
ffffffffc0201cc0:	42951163          	bne	a0,s1,ffffffffc02020e2 <swap_init+0x4e2>
ffffffffc0201cc4:	866a                	mv	a2,s10
ffffffffc0201cc6:	85ee                	mv	a1,s11
ffffffffc0201cc8:	00004517          	auipc	a0,0x4
ffffffffc0201ccc:	32850513          	addi	a0,a0,808 # ffffffffc0205ff0 <commands+0xe18>
ffffffffc0201cd0:	bfcfe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201cd4:	ec3fe0ef          	jal	ra,ffffffffc0200b96 <mm_create>
ffffffffc0201cd8:	8aaa                	mv	s5,a0
ffffffffc0201cda:	46050463          	beqz	a0,ffffffffc0202142 <swap_init+0x542>
ffffffffc0201cde:	00015797          	auipc	a5,0x15
ffffffffc0201ce2:	87278793          	addi	a5,a5,-1934 # ffffffffc0216550 <check_mm_struct>
ffffffffc0201ce6:	6398                	ld	a4,0(a5)
ffffffffc0201ce8:	3c071d63          	bnez	a4,ffffffffc02020c2 <swap_init+0x4c2>
ffffffffc0201cec:	00015717          	auipc	a4,0x15
ffffffffc0201cf0:	89c70713          	addi	a4,a4,-1892 # ffffffffc0216588 <boot_pgdir>
ffffffffc0201cf4:	00073b03          	ld	s6,0(a4)
ffffffffc0201cf8:	e388                	sd	a0,0(a5)
ffffffffc0201cfa:	000b3783          	ld	a5,0(s6)
ffffffffc0201cfe:	01653c23          	sd	s6,24(a0)
ffffffffc0201d02:	42079063          	bnez	a5,ffffffffc0202122 <swap_init+0x522>
ffffffffc0201d06:	6599                	lui	a1,0x6
ffffffffc0201d08:	460d                	li	a2,3
ffffffffc0201d0a:	6505                	lui	a0,0x1
ffffffffc0201d0c:	ed3fe0ef          	jal	ra,ffffffffc0200bde <vma_create>
ffffffffc0201d10:	85aa                	mv	a1,a0
ffffffffc0201d12:	52050463          	beqz	a0,ffffffffc020223a <swap_init+0x63a>
ffffffffc0201d16:	8556                	mv	a0,s5
ffffffffc0201d18:	f35fe0ef          	jal	ra,ffffffffc0200c4c <insert_vma_struct>
ffffffffc0201d1c:	00004517          	auipc	a0,0x4
ffffffffc0201d20:	31450513          	addi	a0,a0,788 # ffffffffc0206030 <commands+0xe58>
ffffffffc0201d24:	ba8fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201d28:	018ab503          	ld	a0,24(s5)
ffffffffc0201d2c:	4605                	li	a2,1
ffffffffc0201d2e:	6585                	lui	a1,0x1
ffffffffc0201d30:	398010ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc0201d34:	4c050363          	beqz	a0,ffffffffc02021fa <swap_init+0x5fa>
ffffffffc0201d38:	00004517          	auipc	a0,0x4
ffffffffc0201d3c:	34850513          	addi	a0,a0,840 # ffffffffc0206080 <commands+0xea8>
ffffffffc0201d40:	00010497          	auipc	s1,0x10
ffffffffc0201d44:	75048493          	addi	s1,s1,1872 # ffffffffc0212490 <check_rp>
ffffffffc0201d48:	b84fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201d4c:	00010997          	auipc	s3,0x10
ffffffffc0201d50:	76498993          	addi	s3,s3,1892 # ffffffffc02124b0 <swap_in_seq_no>
ffffffffc0201d54:	8a26                	mv	s4,s1
ffffffffc0201d56:	4505                	li	a0,1
ffffffffc0201d58:	264010ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0201d5c:	00aa3023          	sd	a0,0(s4)
ffffffffc0201d60:	2c050963          	beqz	a0,ffffffffc0202032 <swap_init+0x432>
ffffffffc0201d64:	651c                	ld	a5,8(a0)
ffffffffc0201d66:	8b89                	andi	a5,a5,2
ffffffffc0201d68:	32079d63          	bnez	a5,ffffffffc02020a2 <swap_init+0x4a2>
ffffffffc0201d6c:	0a21                	addi	s4,s4,8
ffffffffc0201d6e:	ff3a14e3          	bne	s4,s3,ffffffffc0201d56 <swap_init+0x156>
ffffffffc0201d72:	601c                	ld	a5,0(s0)
ffffffffc0201d74:	00010a17          	auipc	s4,0x10
ffffffffc0201d78:	71ca0a13          	addi	s4,s4,1820 # ffffffffc0212490 <check_rp>
ffffffffc0201d7c:	e000                	sd	s0,0(s0)
ffffffffc0201d7e:	ec3e                	sd	a5,24(sp)
ffffffffc0201d80:	641c                	ld	a5,8(s0)
ffffffffc0201d82:	e400                	sd	s0,8(s0)
ffffffffc0201d84:	f03e                	sd	a5,32(sp)
ffffffffc0201d86:	481c                	lw	a5,16(s0)
ffffffffc0201d88:	f43e                	sd	a5,40(sp)
ffffffffc0201d8a:	00010797          	auipc	a5,0x10
ffffffffc0201d8e:	7807a323          	sw	zero,1926(a5) # ffffffffc0212510 <free_area+0x10>
ffffffffc0201d92:	000a3503          	ld	a0,0(s4)
ffffffffc0201d96:	4585                	li	a1,1
ffffffffc0201d98:	0a21                	addi	s4,s4,8
ffffffffc0201d9a:	2b4010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0201d9e:	ff3a1ae3          	bne	s4,s3,ffffffffc0201d92 <swap_init+0x192>
ffffffffc0201da2:	01042a03          	lw	s4,16(s0)
ffffffffc0201da6:	4791                	li	a5,4
ffffffffc0201da8:	42fa1963          	bne	s4,a5,ffffffffc02021da <swap_init+0x5da>
ffffffffc0201dac:	00004517          	auipc	a0,0x4
ffffffffc0201db0:	35c50513          	addi	a0,a0,860 # ffffffffc0206108 <commands+0xf30>
ffffffffc0201db4:	b18fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201db8:	6705                	lui	a4,0x1
ffffffffc0201dba:	00014797          	auipc	a5,0x14
ffffffffc0201dbe:	7807af23          	sw	zero,1950(a5) # ffffffffc0216558 <pgfault_num>
ffffffffc0201dc2:	4629                	li	a2,10
ffffffffc0201dc4:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201dc8:	00014697          	auipc	a3,0x14
ffffffffc0201dcc:	7906a683          	lw	a3,1936(a3) # ffffffffc0216558 <pgfault_num>
ffffffffc0201dd0:	4585                	li	a1,1
ffffffffc0201dd2:	00014797          	auipc	a5,0x14
ffffffffc0201dd6:	78678793          	addi	a5,a5,1926 # ffffffffc0216558 <pgfault_num>
ffffffffc0201dda:	54b69063          	bne	a3,a1,ffffffffc020231a <swap_init+0x71a>
ffffffffc0201dde:	00c70823          	sb	a2,16(a4)
ffffffffc0201de2:	4398                	lw	a4,0(a5)
ffffffffc0201de4:	2701                	sext.w	a4,a4
ffffffffc0201de6:	3cd71a63          	bne	a4,a3,ffffffffc02021ba <swap_init+0x5ba>
ffffffffc0201dea:	6689                	lui	a3,0x2
ffffffffc0201dec:	462d                	li	a2,11
ffffffffc0201dee:	00c68023          	sb	a2,0(a3) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc0201df2:	4398                	lw	a4,0(a5)
ffffffffc0201df4:	4589                	li	a1,2
ffffffffc0201df6:	2701                	sext.w	a4,a4
ffffffffc0201df8:	4ab71163          	bne	a4,a1,ffffffffc020229a <swap_init+0x69a>
ffffffffc0201dfc:	00c68823          	sb	a2,16(a3)
ffffffffc0201e00:	4394                	lw	a3,0(a5)
ffffffffc0201e02:	2681                	sext.w	a3,a3
ffffffffc0201e04:	4ae69b63          	bne	a3,a4,ffffffffc02022ba <swap_init+0x6ba>
ffffffffc0201e08:	668d                	lui	a3,0x3
ffffffffc0201e0a:	4631                	li	a2,12
ffffffffc0201e0c:	00c68023          	sb	a2,0(a3) # 3000 <kern_entry-0xffffffffc01fd000>
ffffffffc0201e10:	4398                	lw	a4,0(a5)
ffffffffc0201e12:	458d                	li	a1,3
ffffffffc0201e14:	2701                	sext.w	a4,a4
ffffffffc0201e16:	4cb71263          	bne	a4,a1,ffffffffc02022da <swap_init+0x6da>
ffffffffc0201e1a:	00c68823          	sb	a2,16(a3)
ffffffffc0201e1e:	4394                	lw	a3,0(a5)
ffffffffc0201e20:	2681                	sext.w	a3,a3
ffffffffc0201e22:	4ce69c63          	bne	a3,a4,ffffffffc02022fa <swap_init+0x6fa>
ffffffffc0201e26:	6691                	lui	a3,0x4
ffffffffc0201e28:	4635                	li	a2,13
ffffffffc0201e2a:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc0201e2e:	4398                	lw	a4,0(a5)
ffffffffc0201e30:	2701                	sext.w	a4,a4
ffffffffc0201e32:	43471463          	bne	a4,s4,ffffffffc020225a <swap_init+0x65a>
ffffffffc0201e36:	00c68823          	sb	a2,16(a3)
ffffffffc0201e3a:	439c                	lw	a5,0(a5)
ffffffffc0201e3c:	2781                	sext.w	a5,a5
ffffffffc0201e3e:	42e79e63          	bne	a5,a4,ffffffffc020227a <swap_init+0x67a>
ffffffffc0201e42:	481c                	lw	a5,16(s0)
ffffffffc0201e44:	2a079f63          	bnez	a5,ffffffffc0202102 <swap_init+0x502>
ffffffffc0201e48:	00010797          	auipc	a5,0x10
ffffffffc0201e4c:	66878793          	addi	a5,a5,1640 # ffffffffc02124b0 <swap_in_seq_no>
ffffffffc0201e50:	00010717          	auipc	a4,0x10
ffffffffc0201e54:	68870713          	addi	a4,a4,1672 # ffffffffc02124d8 <swap_out_seq_no>
ffffffffc0201e58:	00010617          	auipc	a2,0x10
ffffffffc0201e5c:	68060613          	addi	a2,a2,1664 # ffffffffc02124d8 <swap_out_seq_no>
ffffffffc0201e60:	56fd                	li	a3,-1
ffffffffc0201e62:	c394                	sw	a3,0(a5)
ffffffffc0201e64:	c314                	sw	a3,0(a4)
ffffffffc0201e66:	0791                	addi	a5,a5,4
ffffffffc0201e68:	0711                	addi	a4,a4,4
ffffffffc0201e6a:	fec79ce3          	bne	a5,a2,ffffffffc0201e62 <swap_init+0x262>
ffffffffc0201e6e:	00010717          	auipc	a4,0x10
ffffffffc0201e72:	60270713          	addi	a4,a4,1538 # ffffffffc0212470 <check_ptep>
ffffffffc0201e76:	00010697          	auipc	a3,0x10
ffffffffc0201e7a:	61a68693          	addi	a3,a3,1562 # ffffffffc0212490 <check_rp>
ffffffffc0201e7e:	6585                	lui	a1,0x1
ffffffffc0201e80:	00014c17          	auipc	s8,0x14
ffffffffc0201e84:	710c0c13          	addi	s8,s8,1808 # ffffffffc0216590 <npage>
ffffffffc0201e88:	00014c97          	auipc	s9,0x14
ffffffffc0201e8c:	710c8c93          	addi	s9,s9,1808 # ffffffffc0216598 <pages>
ffffffffc0201e90:	00073023          	sd	zero,0(a4)
ffffffffc0201e94:	4601                	li	a2,0
ffffffffc0201e96:	855a                	mv	a0,s6
ffffffffc0201e98:	e836                	sd	a3,16(sp)
ffffffffc0201e9a:	e42e                	sd	a1,8(sp)
ffffffffc0201e9c:	e03a                	sd	a4,0(sp)
ffffffffc0201e9e:	22a010ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc0201ea2:	6702                	ld	a4,0(sp)
ffffffffc0201ea4:	65a2                	ld	a1,8(sp)
ffffffffc0201ea6:	66c2                	ld	a3,16(sp)
ffffffffc0201ea8:	e308                	sd	a0,0(a4)
ffffffffc0201eaa:	1c050063          	beqz	a0,ffffffffc020206a <swap_init+0x46a>
ffffffffc0201eae:	611c                	ld	a5,0(a0)
ffffffffc0201eb0:	0017f613          	andi	a2,a5,1
ffffffffc0201eb4:	1c060b63          	beqz	a2,ffffffffc020208a <swap_init+0x48a>
ffffffffc0201eb8:	000c3603          	ld	a2,0(s8)
ffffffffc0201ebc:	078a                	slli	a5,a5,0x2
ffffffffc0201ebe:	83b1                	srli	a5,a5,0xc
ffffffffc0201ec0:	12c7fd63          	bgeu	a5,a2,ffffffffc0201ffa <swap_init+0x3fa>
ffffffffc0201ec4:	00005617          	auipc	a2,0x5
ffffffffc0201ec8:	1b460613          	addi	a2,a2,436 # ffffffffc0207078 <nbase>
ffffffffc0201ecc:	00063a03          	ld	s4,0(a2)
ffffffffc0201ed0:	000cb603          	ld	a2,0(s9)
ffffffffc0201ed4:	6288                	ld	a0,0(a3)
ffffffffc0201ed6:	414787b3          	sub	a5,a5,s4
ffffffffc0201eda:	079a                	slli	a5,a5,0x6
ffffffffc0201edc:	97b2                	add	a5,a5,a2
ffffffffc0201ede:	12f51a63          	bne	a0,a5,ffffffffc0202012 <swap_init+0x412>
ffffffffc0201ee2:	6785                	lui	a5,0x1
ffffffffc0201ee4:	95be                	add	a1,a1,a5
ffffffffc0201ee6:	6795                	lui	a5,0x5
ffffffffc0201ee8:	0721                	addi	a4,a4,8
ffffffffc0201eea:	06a1                	addi	a3,a3,8
ffffffffc0201eec:	faf592e3          	bne	a1,a5,ffffffffc0201e90 <swap_init+0x290>
ffffffffc0201ef0:	00004517          	auipc	a0,0x4
ffffffffc0201ef4:	2e850513          	addi	a0,a0,744 # ffffffffc02061d8 <commands+0x1000>
ffffffffc0201ef8:	9d4fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201efc:	000bb783          	ld	a5,0(s7)
ffffffffc0201f00:	7f9c                	ld	a5,56(a5)
ffffffffc0201f02:	9782                	jalr	a5
ffffffffc0201f04:	30051b63          	bnez	a0,ffffffffc020221a <swap_init+0x61a>
ffffffffc0201f08:	77a2                	ld	a5,40(sp)
ffffffffc0201f0a:	c81c                	sw	a5,16(s0)
ffffffffc0201f0c:	67e2                	ld	a5,24(sp)
ffffffffc0201f0e:	e01c                	sd	a5,0(s0)
ffffffffc0201f10:	7782                	ld	a5,32(sp)
ffffffffc0201f12:	e41c                	sd	a5,8(s0)
ffffffffc0201f14:	6088                	ld	a0,0(s1)
ffffffffc0201f16:	4585                	li	a1,1
ffffffffc0201f18:	04a1                	addi	s1,s1,8
ffffffffc0201f1a:	134010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0201f1e:	ff349be3          	bne	s1,s3,ffffffffc0201f14 <swap_init+0x314>
ffffffffc0201f22:	8556                	mv	a0,s5
ffffffffc0201f24:	df9fe0ef          	jal	ra,ffffffffc0200d1c <mm_destroy>
ffffffffc0201f28:	00014797          	auipc	a5,0x14
ffffffffc0201f2c:	66078793          	addi	a5,a5,1632 # ffffffffc0216588 <boot_pgdir>
ffffffffc0201f30:	639c                	ld	a5,0(a5)
ffffffffc0201f32:	000c3703          	ld	a4,0(s8)
ffffffffc0201f36:	639c                	ld	a5,0(a5)
ffffffffc0201f38:	078a                	slli	a5,a5,0x2
ffffffffc0201f3a:	83b1                	srli	a5,a5,0xc
ffffffffc0201f3c:	0ae7fd63          	bgeu	a5,a4,ffffffffc0201ff6 <swap_init+0x3f6>
ffffffffc0201f40:	414786b3          	sub	a3,a5,s4
ffffffffc0201f44:	069a                	slli	a3,a3,0x6
ffffffffc0201f46:	8699                	srai	a3,a3,0x6
ffffffffc0201f48:	96d2                	add	a3,a3,s4
ffffffffc0201f4a:	00c69793          	slli	a5,a3,0xc
ffffffffc0201f4e:	83b1                	srli	a5,a5,0xc
ffffffffc0201f50:	000cb503          	ld	a0,0(s9)
ffffffffc0201f54:	06b2                	slli	a3,a3,0xc
ffffffffc0201f56:	22e7f663          	bgeu	a5,a4,ffffffffc0202182 <swap_init+0x582>
ffffffffc0201f5a:	00014797          	auipc	a5,0x14
ffffffffc0201f5e:	64e7b783          	ld	a5,1614(a5) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0201f62:	96be                	add	a3,a3,a5
ffffffffc0201f64:	629c                	ld	a5,0(a3)
ffffffffc0201f66:	078a                	slli	a5,a5,0x2
ffffffffc0201f68:	83b1                	srli	a5,a5,0xc
ffffffffc0201f6a:	08e7f663          	bgeu	a5,a4,ffffffffc0201ff6 <swap_init+0x3f6>
ffffffffc0201f6e:	414787b3          	sub	a5,a5,s4
ffffffffc0201f72:	079a                	slli	a5,a5,0x6
ffffffffc0201f74:	953e                	add	a0,a0,a5
ffffffffc0201f76:	4585                	li	a1,1
ffffffffc0201f78:	0d6010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0201f7c:	000b3783          	ld	a5,0(s6)
ffffffffc0201f80:	000c3703          	ld	a4,0(s8)
ffffffffc0201f84:	078a                	slli	a5,a5,0x2
ffffffffc0201f86:	83b1                	srli	a5,a5,0xc
ffffffffc0201f88:	06e7f763          	bgeu	a5,a4,ffffffffc0201ff6 <swap_init+0x3f6>
ffffffffc0201f8c:	000cb503          	ld	a0,0(s9)
ffffffffc0201f90:	414787b3          	sub	a5,a5,s4
ffffffffc0201f94:	079a                	slli	a5,a5,0x6
ffffffffc0201f96:	4585                	li	a1,1
ffffffffc0201f98:	953e                	add	a0,a0,a5
ffffffffc0201f9a:	0b4010ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0201f9e:	000b3023          	sd	zero,0(s6)
ffffffffc0201fa2:	12000073          	sfence.vma
ffffffffc0201fa6:	641c                	ld	a5,8(s0)
ffffffffc0201fa8:	00878a63          	beq	a5,s0,ffffffffc0201fbc <swap_init+0x3bc>
ffffffffc0201fac:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201fb0:	679c                	ld	a5,8(a5)
ffffffffc0201fb2:	3dfd                	addiw	s11,s11,-1
ffffffffc0201fb4:	40ed0d3b          	subw	s10,s10,a4
ffffffffc0201fb8:	fe879ae3          	bne	a5,s0,ffffffffc0201fac <swap_init+0x3ac>
ffffffffc0201fbc:	1c0d9f63          	bnez	s11,ffffffffc020219a <swap_init+0x59a>
ffffffffc0201fc0:	1a0d1163          	bnez	s10,ffffffffc0202162 <swap_init+0x562>
ffffffffc0201fc4:	00004517          	auipc	a0,0x4
ffffffffc0201fc8:	26450513          	addi	a0,a0,612 # ffffffffc0206228 <commands+0x1050>
ffffffffc0201fcc:	900fe0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0201fd0:	b149                	j	ffffffffc0201c52 <swap_init+0x52>
ffffffffc0201fd2:	4481                	li	s1,0
ffffffffc0201fd4:	b1e5                	j	ffffffffc0201cbc <swap_init+0xbc>
ffffffffc0201fd6:	00004697          	auipc	a3,0x4
ffffffffc0201fda:	fea68693          	addi	a3,a3,-22 # ffffffffc0205fc0 <commands+0xde8>
ffffffffc0201fde:	00004617          	auipc	a2,0x4
ffffffffc0201fe2:	92260613          	addi	a2,a2,-1758 # ffffffffc0205900 <commands+0x728>
ffffffffc0201fe6:	0bd00593          	li	a1,189
ffffffffc0201fea:	00004517          	auipc	a0,0x4
ffffffffc0201fee:	fae50513          	addi	a0,a0,-82 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0201ff2:	9d6fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0201ff6:	befff0ef          	jal	ra,ffffffffc0201be4 <pa2page.part.0>
ffffffffc0201ffa:	00004617          	auipc	a2,0x4
ffffffffc0201ffe:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0205b28 <commands+0x950>
ffffffffc0202002:	06200593          	li	a1,98
ffffffffc0202006:	00004517          	auipc	a0,0x4
ffffffffc020200a:	b4250513          	addi	a0,a0,-1214 # ffffffffc0205b48 <commands+0x970>
ffffffffc020200e:	9bafe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202012:	00004697          	auipc	a3,0x4
ffffffffc0202016:	19e68693          	addi	a3,a3,414 # ffffffffc02061b0 <commands+0xfd8>
ffffffffc020201a:	00004617          	auipc	a2,0x4
ffffffffc020201e:	8e660613          	addi	a2,a2,-1818 # ffffffffc0205900 <commands+0x728>
ffffffffc0202022:	0fd00593          	li	a1,253
ffffffffc0202026:	00004517          	auipc	a0,0x4
ffffffffc020202a:	f7250513          	addi	a0,a0,-142 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020202e:	99afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202032:	00004697          	auipc	a3,0x4
ffffffffc0202036:	07668693          	addi	a3,a3,118 # ffffffffc02060a8 <commands+0xed0>
ffffffffc020203a:	00004617          	auipc	a2,0x4
ffffffffc020203e:	8c660613          	addi	a2,a2,-1850 # ffffffffc0205900 <commands+0x728>
ffffffffc0202042:	0dd00593          	li	a1,221
ffffffffc0202046:	00004517          	auipc	a0,0x4
ffffffffc020204a:	f5250513          	addi	a0,a0,-174 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020204e:	97afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202052:	00004617          	auipc	a2,0x4
ffffffffc0202056:	f2660613          	addi	a2,a2,-218 # ffffffffc0205f78 <commands+0xda0>
ffffffffc020205a:	02a00593          	li	a1,42
ffffffffc020205e:	00004517          	auipc	a0,0x4
ffffffffc0202062:	f3a50513          	addi	a0,a0,-198 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202066:	962fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020206a:	00004697          	auipc	a3,0x4
ffffffffc020206e:	10668693          	addi	a3,a3,262 # ffffffffc0206170 <commands+0xf98>
ffffffffc0202072:	00004617          	auipc	a2,0x4
ffffffffc0202076:	88e60613          	addi	a2,a2,-1906 # ffffffffc0205900 <commands+0x728>
ffffffffc020207a:	0fc00593          	li	a1,252
ffffffffc020207e:	00004517          	auipc	a0,0x4
ffffffffc0202082:	f1a50513          	addi	a0,a0,-230 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202086:	942fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020208a:	00004617          	auipc	a2,0x4
ffffffffc020208e:	0fe60613          	addi	a2,a2,254 # ffffffffc0206188 <commands+0xfb0>
ffffffffc0202092:	07400593          	li	a1,116
ffffffffc0202096:	00004517          	auipc	a0,0x4
ffffffffc020209a:	ab250513          	addi	a0,a0,-1358 # ffffffffc0205b48 <commands+0x970>
ffffffffc020209e:	92afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02020a2:	00004697          	auipc	a3,0x4
ffffffffc02020a6:	01e68693          	addi	a3,a3,30 # ffffffffc02060c0 <commands+0xee8>
ffffffffc02020aa:	00004617          	auipc	a2,0x4
ffffffffc02020ae:	85660613          	addi	a2,a2,-1962 # ffffffffc0205900 <commands+0x728>
ffffffffc02020b2:	0de00593          	li	a1,222
ffffffffc02020b6:	00004517          	auipc	a0,0x4
ffffffffc02020ba:	ee250513          	addi	a0,a0,-286 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02020be:	90afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02020c2:	00004697          	auipc	a3,0x4
ffffffffc02020c6:	f5668693          	addi	a3,a3,-170 # ffffffffc0206018 <commands+0xe40>
ffffffffc02020ca:	00004617          	auipc	a2,0x4
ffffffffc02020ce:	83660613          	addi	a2,a2,-1994 # ffffffffc0205900 <commands+0x728>
ffffffffc02020d2:	0c800593          	li	a1,200
ffffffffc02020d6:	00004517          	auipc	a0,0x4
ffffffffc02020da:	ec250513          	addi	a0,a0,-318 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02020de:	8eafe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02020e2:	00004697          	auipc	a3,0x4
ffffffffc02020e6:	eee68693          	addi	a3,a3,-274 # ffffffffc0205fd0 <commands+0xdf8>
ffffffffc02020ea:	00004617          	auipc	a2,0x4
ffffffffc02020ee:	81660613          	addi	a2,a2,-2026 # ffffffffc0205900 <commands+0x728>
ffffffffc02020f2:	0c000593          	li	a1,192
ffffffffc02020f6:	00004517          	auipc	a0,0x4
ffffffffc02020fa:	ea250513          	addi	a0,a0,-350 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02020fe:	8cafe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202102:	00004697          	auipc	a3,0x4
ffffffffc0202106:	05e68693          	addi	a3,a3,94 # ffffffffc0206160 <commands+0xf88>
ffffffffc020210a:	00003617          	auipc	a2,0x3
ffffffffc020210e:	7f660613          	addi	a2,a2,2038 # ffffffffc0205900 <commands+0x728>
ffffffffc0202112:	0f400593          	li	a1,244
ffffffffc0202116:	00004517          	auipc	a0,0x4
ffffffffc020211a:	e8250513          	addi	a0,a0,-382 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020211e:	8aafe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202122:	00004697          	auipc	a3,0x4
ffffffffc0202126:	9c668693          	addi	a3,a3,-1594 # ffffffffc0205ae8 <commands+0x910>
ffffffffc020212a:	00003617          	auipc	a2,0x3
ffffffffc020212e:	7d660613          	addi	a2,a2,2006 # ffffffffc0205900 <commands+0x728>
ffffffffc0202132:	0cd00593          	li	a1,205
ffffffffc0202136:	00004517          	auipc	a0,0x4
ffffffffc020213a:	e6250513          	addi	a0,a0,-414 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020213e:	88afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202142:	00004697          	auipc	a3,0x4
ffffffffc0202146:	ac668693          	addi	a3,a3,-1338 # ffffffffc0205c08 <commands+0xa30>
ffffffffc020214a:	00003617          	auipc	a2,0x3
ffffffffc020214e:	7b660613          	addi	a2,a2,1974 # ffffffffc0205900 <commands+0x728>
ffffffffc0202152:	0c500593          	li	a1,197
ffffffffc0202156:	00004517          	auipc	a0,0x4
ffffffffc020215a:	e4250513          	addi	a0,a0,-446 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020215e:	86afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202162:	00004697          	auipc	a3,0x4
ffffffffc0202166:	0b668693          	addi	a3,a3,182 # ffffffffc0206218 <commands+0x1040>
ffffffffc020216a:	00003617          	auipc	a2,0x3
ffffffffc020216e:	79660613          	addi	a2,a2,1942 # ffffffffc0205900 <commands+0x728>
ffffffffc0202172:	11d00593          	li	a1,285
ffffffffc0202176:	00004517          	auipc	a0,0x4
ffffffffc020217a:	e2250513          	addi	a0,a0,-478 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc020217e:	84afe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202182:	00004617          	auipc	a2,0x4
ffffffffc0202186:	9d660613          	addi	a2,a2,-1578 # ffffffffc0205b58 <commands+0x980>
ffffffffc020218a:	06900593          	li	a1,105
ffffffffc020218e:	00004517          	auipc	a0,0x4
ffffffffc0202192:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0205b48 <commands+0x970>
ffffffffc0202196:	832fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020219a:	00004697          	auipc	a3,0x4
ffffffffc020219e:	06e68693          	addi	a3,a3,110 # ffffffffc0206208 <commands+0x1030>
ffffffffc02021a2:	00003617          	auipc	a2,0x3
ffffffffc02021a6:	75e60613          	addi	a2,a2,1886 # ffffffffc0205900 <commands+0x728>
ffffffffc02021aa:	11c00593          	li	a1,284
ffffffffc02021ae:	00004517          	auipc	a0,0x4
ffffffffc02021b2:	dea50513          	addi	a0,a0,-534 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02021b6:	812fe0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02021ba:	00004697          	auipc	a3,0x4
ffffffffc02021be:	f7668693          	addi	a3,a3,-138 # ffffffffc0206130 <commands+0xf58>
ffffffffc02021c2:	00003617          	auipc	a2,0x3
ffffffffc02021c6:	73e60613          	addi	a2,a2,1854 # ffffffffc0205900 <commands+0x728>
ffffffffc02021ca:	09600593          	li	a1,150
ffffffffc02021ce:	00004517          	auipc	a0,0x4
ffffffffc02021d2:	dca50513          	addi	a0,a0,-566 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02021d6:	ff3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02021da:	00004697          	auipc	a3,0x4
ffffffffc02021de:	f0668693          	addi	a3,a3,-250 # ffffffffc02060e0 <commands+0xf08>
ffffffffc02021e2:	00003617          	auipc	a2,0x3
ffffffffc02021e6:	71e60613          	addi	a2,a2,1822 # ffffffffc0205900 <commands+0x728>
ffffffffc02021ea:	0eb00593          	li	a1,235
ffffffffc02021ee:	00004517          	auipc	a0,0x4
ffffffffc02021f2:	daa50513          	addi	a0,a0,-598 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02021f6:	fd3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02021fa:	00004697          	auipc	a3,0x4
ffffffffc02021fe:	e6e68693          	addi	a3,a3,-402 # ffffffffc0206068 <commands+0xe90>
ffffffffc0202202:	00003617          	auipc	a2,0x3
ffffffffc0202206:	6fe60613          	addi	a2,a2,1790 # ffffffffc0205900 <commands+0x728>
ffffffffc020220a:	0d800593          	li	a1,216
ffffffffc020220e:	00004517          	auipc	a0,0x4
ffffffffc0202212:	d8a50513          	addi	a0,a0,-630 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202216:	fb3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020221a:	00004697          	auipc	a3,0x4
ffffffffc020221e:	fe668693          	addi	a3,a3,-26 # ffffffffc0206200 <commands+0x1028>
ffffffffc0202222:	00003617          	auipc	a2,0x3
ffffffffc0202226:	6de60613          	addi	a2,a2,1758 # ffffffffc0205900 <commands+0x728>
ffffffffc020222a:	10300593          	li	a1,259
ffffffffc020222e:	00004517          	auipc	a0,0x4
ffffffffc0202232:	d6a50513          	addi	a0,a0,-662 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202236:	f93fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020223a:	00004697          	auipc	a3,0x4
ffffffffc020223e:	9a668693          	addi	a3,a3,-1626 # ffffffffc0205be0 <commands+0xa08>
ffffffffc0202242:	00003617          	auipc	a2,0x3
ffffffffc0202246:	6be60613          	addi	a2,a2,1726 # ffffffffc0205900 <commands+0x728>
ffffffffc020224a:	0d000593          	li	a1,208
ffffffffc020224e:	00004517          	auipc	a0,0x4
ffffffffc0202252:	d4a50513          	addi	a0,a0,-694 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202256:	f73fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020225a:	00004697          	auipc	a3,0x4
ffffffffc020225e:	ace68693          	addi	a3,a3,-1330 # ffffffffc0205d28 <commands+0xb50>
ffffffffc0202262:	00003617          	auipc	a2,0x3
ffffffffc0202266:	69e60613          	addi	a2,a2,1694 # ffffffffc0205900 <commands+0x728>
ffffffffc020226a:	0a000593          	li	a1,160
ffffffffc020226e:	00004517          	auipc	a0,0x4
ffffffffc0202272:	d2a50513          	addi	a0,a0,-726 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202276:	f53fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020227a:	00004697          	auipc	a3,0x4
ffffffffc020227e:	aae68693          	addi	a3,a3,-1362 # ffffffffc0205d28 <commands+0xb50>
ffffffffc0202282:	00003617          	auipc	a2,0x3
ffffffffc0202286:	67e60613          	addi	a2,a2,1662 # ffffffffc0205900 <commands+0x728>
ffffffffc020228a:	0a200593          	li	a1,162
ffffffffc020228e:	00004517          	auipc	a0,0x4
ffffffffc0202292:	d0a50513          	addi	a0,a0,-758 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202296:	f33fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020229a:	00004697          	auipc	a3,0x4
ffffffffc020229e:	ea668693          	addi	a3,a3,-346 # ffffffffc0206140 <commands+0xf68>
ffffffffc02022a2:	00003617          	auipc	a2,0x3
ffffffffc02022a6:	65e60613          	addi	a2,a2,1630 # ffffffffc0205900 <commands+0x728>
ffffffffc02022aa:	09800593          	li	a1,152
ffffffffc02022ae:	00004517          	auipc	a0,0x4
ffffffffc02022b2:	cea50513          	addi	a0,a0,-790 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02022b6:	f13fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02022ba:	00004697          	auipc	a3,0x4
ffffffffc02022be:	e8668693          	addi	a3,a3,-378 # ffffffffc0206140 <commands+0xf68>
ffffffffc02022c2:	00003617          	auipc	a2,0x3
ffffffffc02022c6:	63e60613          	addi	a2,a2,1598 # ffffffffc0205900 <commands+0x728>
ffffffffc02022ca:	09a00593          	li	a1,154
ffffffffc02022ce:	00004517          	auipc	a0,0x4
ffffffffc02022d2:	cca50513          	addi	a0,a0,-822 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02022d6:	ef3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02022da:	00004697          	auipc	a3,0x4
ffffffffc02022de:	e7668693          	addi	a3,a3,-394 # ffffffffc0206150 <commands+0xf78>
ffffffffc02022e2:	00003617          	auipc	a2,0x3
ffffffffc02022e6:	61e60613          	addi	a2,a2,1566 # ffffffffc0205900 <commands+0x728>
ffffffffc02022ea:	09c00593          	li	a1,156
ffffffffc02022ee:	00004517          	auipc	a0,0x4
ffffffffc02022f2:	caa50513          	addi	a0,a0,-854 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02022f6:	ed3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02022fa:	00004697          	auipc	a3,0x4
ffffffffc02022fe:	e5668693          	addi	a3,a3,-426 # ffffffffc0206150 <commands+0xf78>
ffffffffc0202302:	00003617          	auipc	a2,0x3
ffffffffc0202306:	5fe60613          	addi	a2,a2,1534 # ffffffffc0205900 <commands+0x728>
ffffffffc020230a:	09e00593          	li	a1,158
ffffffffc020230e:	00004517          	auipc	a0,0x4
ffffffffc0202312:	c8a50513          	addi	a0,a0,-886 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202316:	eb3fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020231a:	00004697          	auipc	a3,0x4
ffffffffc020231e:	e1668693          	addi	a3,a3,-490 # ffffffffc0206130 <commands+0xf58>
ffffffffc0202322:	00003617          	auipc	a2,0x3
ffffffffc0202326:	5de60613          	addi	a2,a2,1502 # ffffffffc0205900 <commands+0x728>
ffffffffc020232a:	09400593          	li	a1,148
ffffffffc020232e:	00004517          	auipc	a0,0x4
ffffffffc0202332:	c6a50513          	addi	a0,a0,-918 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202336:	e93fd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020233a <swap_init_mm>:
ffffffffc020233a:	00014797          	auipc	a5,0x14
ffffffffc020233e:	2367b783          	ld	a5,566(a5) # ffffffffc0216570 <sm>
ffffffffc0202342:	6b9c                	ld	a5,16(a5)
ffffffffc0202344:	8782                	jr	a5

ffffffffc0202346 <swap_map_swappable>:
ffffffffc0202346:	00014797          	auipc	a5,0x14
ffffffffc020234a:	22a7b783          	ld	a5,554(a5) # ffffffffc0216570 <sm>
ffffffffc020234e:	739c                	ld	a5,32(a5)
ffffffffc0202350:	8782                	jr	a5

ffffffffc0202352 <swap_out>:
ffffffffc0202352:	711d                	addi	sp,sp,-96
ffffffffc0202354:	ec86                	sd	ra,88(sp)
ffffffffc0202356:	e8a2                	sd	s0,80(sp)
ffffffffc0202358:	e4a6                	sd	s1,72(sp)
ffffffffc020235a:	e0ca                	sd	s2,64(sp)
ffffffffc020235c:	fc4e                	sd	s3,56(sp)
ffffffffc020235e:	f852                	sd	s4,48(sp)
ffffffffc0202360:	f456                	sd	s5,40(sp)
ffffffffc0202362:	f05a                	sd	s6,32(sp)
ffffffffc0202364:	ec5e                	sd	s7,24(sp)
ffffffffc0202366:	e862                	sd	s8,16(sp)
ffffffffc0202368:	cde9                	beqz	a1,ffffffffc0202442 <swap_out+0xf0>
ffffffffc020236a:	8a2e                	mv	s4,a1
ffffffffc020236c:	892a                	mv	s2,a0
ffffffffc020236e:	8ab2                	mv	s5,a2
ffffffffc0202370:	4401                	li	s0,0
ffffffffc0202372:	00014997          	auipc	s3,0x14
ffffffffc0202376:	1fe98993          	addi	s3,s3,510 # ffffffffc0216570 <sm>
ffffffffc020237a:	00004b17          	auipc	s6,0x4
ffffffffc020237e:	f2eb0b13          	addi	s6,s6,-210 # ffffffffc02062a8 <commands+0x10d0>
ffffffffc0202382:	00004b97          	auipc	s7,0x4
ffffffffc0202386:	f0eb8b93          	addi	s7,s7,-242 # ffffffffc0206290 <commands+0x10b8>
ffffffffc020238a:	a825                	j	ffffffffc02023c2 <swap_out+0x70>
ffffffffc020238c:	67a2                	ld	a5,8(sp)
ffffffffc020238e:	8626                	mv	a2,s1
ffffffffc0202390:	85a2                	mv	a1,s0
ffffffffc0202392:	7f94                	ld	a3,56(a5)
ffffffffc0202394:	855a                	mv	a0,s6
ffffffffc0202396:	2405                	addiw	s0,s0,1
ffffffffc0202398:	82b1                	srli	a3,a3,0xc
ffffffffc020239a:	0685                	addi	a3,a3,1
ffffffffc020239c:	d31fd0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02023a0:	6522                	ld	a0,8(sp)
ffffffffc02023a2:	4585                	li	a1,1
ffffffffc02023a4:	7d1c                	ld	a5,56(a0)
ffffffffc02023a6:	83b1                	srli	a5,a5,0xc
ffffffffc02023a8:	0785                	addi	a5,a5,1
ffffffffc02023aa:	07a2                	slli	a5,a5,0x8
ffffffffc02023ac:	00fc3023          	sd	a5,0(s8)
ffffffffc02023b0:	49f000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc02023b4:	01893503          	ld	a0,24(s2)
ffffffffc02023b8:	85a6                	mv	a1,s1
ffffffffc02023ba:	461010ef          	jal	ra,ffffffffc020401a <tlb_invalidate>
ffffffffc02023be:	048a0d63          	beq	s4,s0,ffffffffc0202418 <swap_out+0xc6>
ffffffffc02023c2:	0009b783          	ld	a5,0(s3)
ffffffffc02023c6:	8656                	mv	a2,s5
ffffffffc02023c8:	002c                	addi	a1,sp,8
ffffffffc02023ca:	7b9c                	ld	a5,48(a5)
ffffffffc02023cc:	854a                	mv	a0,s2
ffffffffc02023ce:	9782                	jalr	a5
ffffffffc02023d0:	e12d                	bnez	a0,ffffffffc0202432 <swap_out+0xe0>
ffffffffc02023d2:	67a2                	ld	a5,8(sp)
ffffffffc02023d4:	01893503          	ld	a0,24(s2)
ffffffffc02023d8:	4601                	li	a2,0
ffffffffc02023da:	7f84                	ld	s1,56(a5)
ffffffffc02023dc:	85a6                	mv	a1,s1
ffffffffc02023de:	4eb000ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02023e2:	611c                	ld	a5,0(a0)
ffffffffc02023e4:	8c2a                	mv	s8,a0
ffffffffc02023e6:	8b85                	andi	a5,a5,1
ffffffffc02023e8:	cfb9                	beqz	a5,ffffffffc0202446 <swap_out+0xf4>
ffffffffc02023ea:	65a2                	ld	a1,8(sp)
ffffffffc02023ec:	7d9c                	ld	a5,56(a1)
ffffffffc02023ee:	83b1                	srli	a5,a5,0xc
ffffffffc02023f0:	0785                	addi	a5,a5,1
ffffffffc02023f2:	00879513          	slli	a0,a5,0x8
ffffffffc02023f6:	5a9010ef          	jal	ra,ffffffffc020419e <swapfs_write>
ffffffffc02023fa:	d949                	beqz	a0,ffffffffc020238c <swap_out+0x3a>
ffffffffc02023fc:	855e                	mv	a0,s7
ffffffffc02023fe:	ccffd0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0202402:	0009b783          	ld	a5,0(s3)
ffffffffc0202406:	6622                	ld	a2,8(sp)
ffffffffc0202408:	4681                	li	a3,0
ffffffffc020240a:	739c                	ld	a5,32(a5)
ffffffffc020240c:	85a6                	mv	a1,s1
ffffffffc020240e:	854a                	mv	a0,s2
ffffffffc0202410:	2405                	addiw	s0,s0,1
ffffffffc0202412:	9782                	jalr	a5
ffffffffc0202414:	fa8a17e3          	bne	s4,s0,ffffffffc02023c2 <swap_out+0x70>
ffffffffc0202418:	60e6                	ld	ra,88(sp)
ffffffffc020241a:	8522                	mv	a0,s0
ffffffffc020241c:	6446                	ld	s0,80(sp)
ffffffffc020241e:	64a6                	ld	s1,72(sp)
ffffffffc0202420:	6906                	ld	s2,64(sp)
ffffffffc0202422:	79e2                	ld	s3,56(sp)
ffffffffc0202424:	7a42                	ld	s4,48(sp)
ffffffffc0202426:	7aa2                	ld	s5,40(sp)
ffffffffc0202428:	7b02                	ld	s6,32(sp)
ffffffffc020242a:	6be2                	ld	s7,24(sp)
ffffffffc020242c:	6c42                	ld	s8,16(sp)
ffffffffc020242e:	6125                	addi	sp,sp,96
ffffffffc0202430:	8082                	ret
ffffffffc0202432:	85a2                	mv	a1,s0
ffffffffc0202434:	00004517          	auipc	a0,0x4
ffffffffc0202438:	e1450513          	addi	a0,a0,-492 # ffffffffc0206248 <commands+0x1070>
ffffffffc020243c:	c91fd0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0202440:	bfe1                	j	ffffffffc0202418 <swap_out+0xc6>
ffffffffc0202442:	4401                	li	s0,0
ffffffffc0202444:	bfd1                	j	ffffffffc0202418 <swap_out+0xc6>
ffffffffc0202446:	00004697          	auipc	a3,0x4
ffffffffc020244a:	e3268693          	addi	a3,a3,-462 # ffffffffc0206278 <commands+0x10a0>
ffffffffc020244e:	00003617          	auipc	a2,0x3
ffffffffc0202452:	4b260613          	addi	a2,a2,1202 # ffffffffc0205900 <commands+0x728>
ffffffffc0202456:	06900593          	li	a1,105
ffffffffc020245a:	00004517          	auipc	a0,0x4
ffffffffc020245e:	b3e50513          	addi	a0,a0,-1218 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc0202462:	d67fd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202466 <swap_in>:
ffffffffc0202466:	7179                	addi	sp,sp,-48
ffffffffc0202468:	e84a                	sd	s2,16(sp)
ffffffffc020246a:	892a                	mv	s2,a0
ffffffffc020246c:	4505                	li	a0,1
ffffffffc020246e:	ec26                	sd	s1,24(sp)
ffffffffc0202470:	e44e                	sd	s3,8(sp)
ffffffffc0202472:	f406                	sd	ra,40(sp)
ffffffffc0202474:	f022                	sd	s0,32(sp)
ffffffffc0202476:	84ae                	mv	s1,a1
ffffffffc0202478:	89b2                	mv	s3,a2
ffffffffc020247a:	343000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc020247e:	c129                	beqz	a0,ffffffffc02024c0 <swap_in+0x5a>
ffffffffc0202480:	842a                	mv	s0,a0
ffffffffc0202482:	01893503          	ld	a0,24(s2)
ffffffffc0202486:	4601                	li	a2,0
ffffffffc0202488:	85a6                	mv	a1,s1
ffffffffc020248a:	43f000ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc020248e:	892a                	mv	s2,a0
ffffffffc0202490:	6108                	ld	a0,0(a0)
ffffffffc0202492:	85a2                	mv	a1,s0
ffffffffc0202494:	47d010ef          	jal	ra,ffffffffc0204110 <swapfs_read>
ffffffffc0202498:	00093583          	ld	a1,0(s2)
ffffffffc020249c:	8626                	mv	a2,s1
ffffffffc020249e:	00004517          	auipc	a0,0x4
ffffffffc02024a2:	e5a50513          	addi	a0,a0,-422 # ffffffffc02062f8 <commands+0x1120>
ffffffffc02024a6:	81a1                	srli	a1,a1,0x8
ffffffffc02024a8:	c25fd0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02024ac:	70a2                	ld	ra,40(sp)
ffffffffc02024ae:	0089b023          	sd	s0,0(s3)
ffffffffc02024b2:	7402                	ld	s0,32(sp)
ffffffffc02024b4:	64e2                	ld	s1,24(sp)
ffffffffc02024b6:	6942                	ld	s2,16(sp)
ffffffffc02024b8:	69a2                	ld	s3,8(sp)
ffffffffc02024ba:	4501                	li	a0,0
ffffffffc02024bc:	6145                	addi	sp,sp,48
ffffffffc02024be:	8082                	ret
ffffffffc02024c0:	00004697          	auipc	a3,0x4
ffffffffc02024c4:	e2868693          	addi	a3,a3,-472 # ffffffffc02062e8 <commands+0x1110>
ffffffffc02024c8:	00003617          	auipc	a2,0x3
ffffffffc02024cc:	43860613          	addi	a2,a2,1080 # ffffffffc0205900 <commands+0x728>
ffffffffc02024d0:	07f00593          	li	a1,127
ffffffffc02024d4:	00004517          	auipc	a0,0x4
ffffffffc02024d8:	ac450513          	addi	a0,a0,-1340 # ffffffffc0205f98 <commands+0xdc0>
ffffffffc02024dc:	cedfd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc02024e0 <default_init>:
ffffffffc02024e0:	00010797          	auipc	a5,0x10
ffffffffc02024e4:	02078793          	addi	a5,a5,32 # ffffffffc0212500 <free_area>
ffffffffc02024e8:	e79c                	sd	a5,8(a5)
ffffffffc02024ea:	e39c                	sd	a5,0(a5)
ffffffffc02024ec:	0007a823          	sw	zero,16(a5)
ffffffffc02024f0:	8082                	ret

ffffffffc02024f2 <default_nr_free_pages>:
ffffffffc02024f2:	00010517          	auipc	a0,0x10
ffffffffc02024f6:	01e56503          	lwu	a0,30(a0) # ffffffffc0212510 <free_area+0x10>
ffffffffc02024fa:	8082                	ret

ffffffffc02024fc <default_check>:
ffffffffc02024fc:	715d                	addi	sp,sp,-80
ffffffffc02024fe:	e0a2                	sd	s0,64(sp)
ffffffffc0202500:	00010417          	auipc	s0,0x10
ffffffffc0202504:	00040413          	mv	s0,s0
ffffffffc0202508:	641c                	ld	a5,8(s0)
ffffffffc020250a:	e486                	sd	ra,72(sp)
ffffffffc020250c:	fc26                	sd	s1,56(sp)
ffffffffc020250e:	f84a                	sd	s2,48(sp)
ffffffffc0202510:	f44e                	sd	s3,40(sp)
ffffffffc0202512:	f052                	sd	s4,32(sp)
ffffffffc0202514:	ec56                	sd	s5,24(sp)
ffffffffc0202516:	e85a                	sd	s6,16(sp)
ffffffffc0202518:	e45e                	sd	s7,8(sp)
ffffffffc020251a:	e062                	sd	s8,0(sp)
ffffffffc020251c:	2a878d63          	beq	a5,s0,ffffffffc02027d6 <default_check+0x2da>
ffffffffc0202520:	4481                	li	s1,0
ffffffffc0202522:	4901                	li	s2,0
ffffffffc0202524:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202528:	8b09                	andi	a4,a4,2
ffffffffc020252a:	2a070a63          	beqz	a4,ffffffffc02027de <default_check+0x2e2>
ffffffffc020252e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202532:	679c                	ld	a5,8(a5)
ffffffffc0202534:	2905                	addiw	s2,s2,1
ffffffffc0202536:	9cb9                	addw	s1,s1,a4
ffffffffc0202538:	fe8796e3          	bne	a5,s0,ffffffffc0202524 <default_check+0x28>
ffffffffc020253c:	89a6                	mv	s3,s1
ffffffffc020253e:	351000ef          	jal	ra,ffffffffc020308e <nr_free_pages>
ffffffffc0202542:	6f351e63          	bne	a0,s3,ffffffffc0202c3e <default_check+0x742>
ffffffffc0202546:	4505                	li	a0,1
ffffffffc0202548:	275000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc020254c:	8aaa                	mv	s5,a0
ffffffffc020254e:	42050863          	beqz	a0,ffffffffc020297e <default_check+0x482>
ffffffffc0202552:	4505                	li	a0,1
ffffffffc0202554:	269000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202558:	89aa                	mv	s3,a0
ffffffffc020255a:	70050263          	beqz	a0,ffffffffc0202c5e <default_check+0x762>
ffffffffc020255e:	4505                	li	a0,1
ffffffffc0202560:	25d000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202564:	8a2a                	mv	s4,a0
ffffffffc0202566:	48050c63          	beqz	a0,ffffffffc02029fe <default_check+0x502>
ffffffffc020256a:	293a8a63          	beq	s5,s3,ffffffffc02027fe <default_check+0x302>
ffffffffc020256e:	28aa8863          	beq	s5,a0,ffffffffc02027fe <default_check+0x302>
ffffffffc0202572:	28a98663          	beq	s3,a0,ffffffffc02027fe <default_check+0x302>
ffffffffc0202576:	000aa783          	lw	a5,0(s5)
ffffffffc020257a:	2a079263          	bnez	a5,ffffffffc020281e <default_check+0x322>
ffffffffc020257e:	0009a783          	lw	a5,0(s3)
ffffffffc0202582:	28079e63          	bnez	a5,ffffffffc020281e <default_check+0x322>
ffffffffc0202586:	411c                	lw	a5,0(a0)
ffffffffc0202588:	28079b63          	bnez	a5,ffffffffc020281e <default_check+0x322>
ffffffffc020258c:	00014797          	auipc	a5,0x14
ffffffffc0202590:	00c7b783          	ld	a5,12(a5) # ffffffffc0216598 <pages>
ffffffffc0202594:	40fa8733          	sub	a4,s5,a5
ffffffffc0202598:	00005617          	auipc	a2,0x5
ffffffffc020259c:	ae063603          	ld	a2,-1312(a2) # ffffffffc0207078 <nbase>
ffffffffc02025a0:	8719                	srai	a4,a4,0x6
ffffffffc02025a2:	9732                	add	a4,a4,a2
ffffffffc02025a4:	00014697          	auipc	a3,0x14
ffffffffc02025a8:	fec6b683          	ld	a3,-20(a3) # ffffffffc0216590 <npage>
ffffffffc02025ac:	06b2                	slli	a3,a3,0xc
ffffffffc02025ae:	0732                	slli	a4,a4,0xc
ffffffffc02025b0:	28d77763          	bgeu	a4,a3,ffffffffc020283e <default_check+0x342>
ffffffffc02025b4:	40f98733          	sub	a4,s3,a5
ffffffffc02025b8:	8719                	srai	a4,a4,0x6
ffffffffc02025ba:	9732                	add	a4,a4,a2
ffffffffc02025bc:	0732                	slli	a4,a4,0xc
ffffffffc02025be:	4cd77063          	bgeu	a4,a3,ffffffffc0202a7e <default_check+0x582>
ffffffffc02025c2:	40f507b3          	sub	a5,a0,a5
ffffffffc02025c6:	8799                	srai	a5,a5,0x6
ffffffffc02025c8:	97b2                	add	a5,a5,a2
ffffffffc02025ca:	07b2                	slli	a5,a5,0xc
ffffffffc02025cc:	30d7f963          	bgeu	a5,a3,ffffffffc02028de <default_check+0x3e2>
ffffffffc02025d0:	4505                	li	a0,1
ffffffffc02025d2:	00043c03          	ld	s8,0(s0) # ffffffffc0212500 <free_area>
ffffffffc02025d6:	00843b83          	ld	s7,8(s0)
ffffffffc02025da:	01042b03          	lw	s6,16(s0)
ffffffffc02025de:	e400                	sd	s0,8(s0)
ffffffffc02025e0:	e000                	sd	s0,0(s0)
ffffffffc02025e2:	00010797          	auipc	a5,0x10
ffffffffc02025e6:	f207a723          	sw	zero,-210(a5) # ffffffffc0212510 <free_area+0x10>
ffffffffc02025ea:	1d3000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02025ee:	2c051863          	bnez	a0,ffffffffc02028be <default_check+0x3c2>
ffffffffc02025f2:	4585                	li	a1,1
ffffffffc02025f4:	8556                	mv	a0,s5
ffffffffc02025f6:	259000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc02025fa:	4585                	li	a1,1
ffffffffc02025fc:	854e                	mv	a0,s3
ffffffffc02025fe:	251000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0202602:	4585                	li	a1,1
ffffffffc0202604:	8552                	mv	a0,s4
ffffffffc0202606:	249000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020260a:	4818                	lw	a4,16(s0)
ffffffffc020260c:	478d                	li	a5,3
ffffffffc020260e:	28f71863          	bne	a4,a5,ffffffffc020289e <default_check+0x3a2>
ffffffffc0202612:	4505                	li	a0,1
ffffffffc0202614:	1a9000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202618:	89aa                	mv	s3,a0
ffffffffc020261a:	26050263          	beqz	a0,ffffffffc020287e <default_check+0x382>
ffffffffc020261e:	4505                	li	a0,1
ffffffffc0202620:	19d000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202624:	8aaa                	mv	s5,a0
ffffffffc0202626:	3a050c63          	beqz	a0,ffffffffc02029de <default_check+0x4e2>
ffffffffc020262a:	4505                	li	a0,1
ffffffffc020262c:	191000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202630:	8a2a                	mv	s4,a0
ffffffffc0202632:	38050663          	beqz	a0,ffffffffc02029be <default_check+0x4c2>
ffffffffc0202636:	4505                	li	a0,1
ffffffffc0202638:	185000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc020263c:	36051163          	bnez	a0,ffffffffc020299e <default_check+0x4a2>
ffffffffc0202640:	4585                	li	a1,1
ffffffffc0202642:	854e                	mv	a0,s3
ffffffffc0202644:	20b000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0202648:	641c                	ld	a5,8(s0)
ffffffffc020264a:	20878a63          	beq	a5,s0,ffffffffc020285e <default_check+0x362>
ffffffffc020264e:	4505                	li	a0,1
ffffffffc0202650:	16d000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202654:	30a99563          	bne	s3,a0,ffffffffc020295e <default_check+0x462>
ffffffffc0202658:	4505                	li	a0,1
ffffffffc020265a:	163000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc020265e:	2e051063          	bnez	a0,ffffffffc020293e <default_check+0x442>
ffffffffc0202662:	481c                	lw	a5,16(s0)
ffffffffc0202664:	2a079d63          	bnez	a5,ffffffffc020291e <default_check+0x422>
ffffffffc0202668:	854e                	mv	a0,s3
ffffffffc020266a:	4585                	li	a1,1
ffffffffc020266c:	01843023          	sd	s8,0(s0)
ffffffffc0202670:	01743423          	sd	s7,8(s0)
ffffffffc0202674:	01642823          	sw	s6,16(s0)
ffffffffc0202678:	1d7000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020267c:	4585                	li	a1,1
ffffffffc020267e:	8556                	mv	a0,s5
ffffffffc0202680:	1cf000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0202684:	4585                	li	a1,1
ffffffffc0202686:	8552                	mv	a0,s4
ffffffffc0202688:	1c7000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020268c:	4515                	li	a0,5
ffffffffc020268e:	12f000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202692:	89aa                	mv	s3,a0
ffffffffc0202694:	26050563          	beqz	a0,ffffffffc02028fe <default_check+0x402>
ffffffffc0202698:	651c                	ld	a5,8(a0)
ffffffffc020269a:	8385                	srli	a5,a5,0x1
ffffffffc020269c:	8b85                	andi	a5,a5,1
ffffffffc020269e:	54079063          	bnez	a5,ffffffffc0202bde <default_check+0x6e2>
ffffffffc02026a2:	4505                	li	a0,1
ffffffffc02026a4:	00043b03          	ld	s6,0(s0)
ffffffffc02026a8:	00843a83          	ld	s5,8(s0)
ffffffffc02026ac:	e000                	sd	s0,0(s0)
ffffffffc02026ae:	e400                	sd	s0,8(s0)
ffffffffc02026b0:	10d000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02026b4:	50051563          	bnez	a0,ffffffffc0202bbe <default_check+0x6c2>
ffffffffc02026b8:	08098a13          	addi	s4,s3,128
ffffffffc02026bc:	8552                	mv	a0,s4
ffffffffc02026be:	458d                	li	a1,3
ffffffffc02026c0:	01042b83          	lw	s7,16(s0)
ffffffffc02026c4:	00010797          	auipc	a5,0x10
ffffffffc02026c8:	e407a623          	sw	zero,-436(a5) # ffffffffc0212510 <free_area+0x10>
ffffffffc02026cc:	183000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc02026d0:	4511                	li	a0,4
ffffffffc02026d2:	0eb000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02026d6:	4c051463          	bnez	a0,ffffffffc0202b9e <default_check+0x6a2>
ffffffffc02026da:	0889b783          	ld	a5,136(s3)
ffffffffc02026de:	8385                	srli	a5,a5,0x1
ffffffffc02026e0:	8b85                	andi	a5,a5,1
ffffffffc02026e2:	48078e63          	beqz	a5,ffffffffc0202b7e <default_check+0x682>
ffffffffc02026e6:	0909a703          	lw	a4,144(s3)
ffffffffc02026ea:	478d                	li	a5,3
ffffffffc02026ec:	48f71963          	bne	a4,a5,ffffffffc0202b7e <default_check+0x682>
ffffffffc02026f0:	450d                	li	a0,3
ffffffffc02026f2:	0cb000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02026f6:	8c2a                	mv	s8,a0
ffffffffc02026f8:	46050363          	beqz	a0,ffffffffc0202b5e <default_check+0x662>
ffffffffc02026fc:	4505                	li	a0,1
ffffffffc02026fe:	0bf000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202702:	42051e63          	bnez	a0,ffffffffc0202b3e <default_check+0x642>
ffffffffc0202706:	418a1c63          	bne	s4,s8,ffffffffc0202b1e <default_check+0x622>
ffffffffc020270a:	4585                	li	a1,1
ffffffffc020270c:	854e                	mv	a0,s3
ffffffffc020270e:	141000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0202712:	458d                	li	a1,3
ffffffffc0202714:	8552                	mv	a0,s4
ffffffffc0202716:	139000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020271a:	0089b783          	ld	a5,8(s3)
ffffffffc020271e:	04098c13          	addi	s8,s3,64
ffffffffc0202722:	8385                	srli	a5,a5,0x1
ffffffffc0202724:	8b85                	andi	a5,a5,1
ffffffffc0202726:	3c078c63          	beqz	a5,ffffffffc0202afe <default_check+0x602>
ffffffffc020272a:	0109a703          	lw	a4,16(s3)
ffffffffc020272e:	4785                	li	a5,1
ffffffffc0202730:	3cf71763          	bne	a4,a5,ffffffffc0202afe <default_check+0x602>
ffffffffc0202734:	008a3783          	ld	a5,8(s4)
ffffffffc0202738:	8385                	srli	a5,a5,0x1
ffffffffc020273a:	8b85                	andi	a5,a5,1
ffffffffc020273c:	3a078163          	beqz	a5,ffffffffc0202ade <default_check+0x5e2>
ffffffffc0202740:	010a2703          	lw	a4,16(s4)
ffffffffc0202744:	478d                	li	a5,3
ffffffffc0202746:	38f71c63          	bne	a4,a5,ffffffffc0202ade <default_check+0x5e2>
ffffffffc020274a:	4505                	li	a0,1
ffffffffc020274c:	071000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202750:	36a99763          	bne	s3,a0,ffffffffc0202abe <default_check+0x5c2>
ffffffffc0202754:	4585                	li	a1,1
ffffffffc0202756:	0f9000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020275a:	4509                	li	a0,2
ffffffffc020275c:	061000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202760:	32aa1f63          	bne	s4,a0,ffffffffc0202a9e <default_check+0x5a2>
ffffffffc0202764:	4589                	li	a1,2
ffffffffc0202766:	0e9000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc020276a:	4585                	li	a1,1
ffffffffc020276c:	8562                	mv	a0,s8
ffffffffc020276e:	0e1000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc0202772:	4515                	li	a0,5
ffffffffc0202774:	049000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202778:	89aa                	mv	s3,a0
ffffffffc020277a:	48050263          	beqz	a0,ffffffffc0202bfe <default_check+0x702>
ffffffffc020277e:	4505                	li	a0,1
ffffffffc0202780:	03d000ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0202784:	2c051d63          	bnez	a0,ffffffffc0202a5e <default_check+0x562>
ffffffffc0202788:	481c                	lw	a5,16(s0)
ffffffffc020278a:	2a079a63          	bnez	a5,ffffffffc0202a3e <default_check+0x542>
ffffffffc020278e:	4595                	li	a1,5
ffffffffc0202790:	854e                	mv	a0,s3
ffffffffc0202792:	01742823          	sw	s7,16(s0)
ffffffffc0202796:	01643023          	sd	s6,0(s0)
ffffffffc020279a:	01543423          	sd	s5,8(s0)
ffffffffc020279e:	0b1000ef          	jal	ra,ffffffffc020304e <free_pages>
ffffffffc02027a2:	641c                	ld	a5,8(s0)
ffffffffc02027a4:	00878963          	beq	a5,s0,ffffffffc02027b6 <default_check+0x2ba>
ffffffffc02027a8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02027ac:	679c                	ld	a5,8(a5)
ffffffffc02027ae:	397d                	addiw	s2,s2,-1
ffffffffc02027b0:	9c99                	subw	s1,s1,a4
ffffffffc02027b2:	fe879be3          	bne	a5,s0,ffffffffc02027a8 <default_check+0x2ac>
ffffffffc02027b6:	26091463          	bnez	s2,ffffffffc0202a1e <default_check+0x522>
ffffffffc02027ba:	46049263          	bnez	s1,ffffffffc0202c1e <default_check+0x722>
ffffffffc02027be:	60a6                	ld	ra,72(sp)
ffffffffc02027c0:	6406                	ld	s0,64(sp)
ffffffffc02027c2:	74e2                	ld	s1,56(sp)
ffffffffc02027c4:	7942                	ld	s2,48(sp)
ffffffffc02027c6:	79a2                	ld	s3,40(sp)
ffffffffc02027c8:	7a02                	ld	s4,32(sp)
ffffffffc02027ca:	6ae2                	ld	s5,24(sp)
ffffffffc02027cc:	6b42                	ld	s6,16(sp)
ffffffffc02027ce:	6ba2                	ld	s7,8(sp)
ffffffffc02027d0:	6c02                	ld	s8,0(sp)
ffffffffc02027d2:	6161                	addi	sp,sp,80
ffffffffc02027d4:	8082                	ret
ffffffffc02027d6:	4981                	li	s3,0
ffffffffc02027d8:	4481                	li	s1,0
ffffffffc02027da:	4901                	li	s2,0
ffffffffc02027dc:	b38d                	j	ffffffffc020253e <default_check+0x42>
ffffffffc02027de:	00003697          	auipc	a3,0x3
ffffffffc02027e2:	7e268693          	addi	a3,a3,2018 # ffffffffc0205fc0 <commands+0xde8>
ffffffffc02027e6:	00003617          	auipc	a2,0x3
ffffffffc02027ea:	11a60613          	addi	a2,a2,282 # ffffffffc0205900 <commands+0x728>
ffffffffc02027ee:	0f000593          	li	a1,240
ffffffffc02027f2:	00004517          	auipc	a0,0x4
ffffffffc02027f6:	b4650513          	addi	a0,a0,-1210 # ffffffffc0206338 <commands+0x1160>
ffffffffc02027fa:	9cffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02027fe:	00004697          	auipc	a3,0x4
ffffffffc0202802:	bb268693          	addi	a3,a3,-1102 # ffffffffc02063b0 <commands+0x11d8>
ffffffffc0202806:	00003617          	auipc	a2,0x3
ffffffffc020280a:	0fa60613          	addi	a2,a2,250 # ffffffffc0205900 <commands+0x728>
ffffffffc020280e:	0bd00593          	li	a1,189
ffffffffc0202812:	00004517          	auipc	a0,0x4
ffffffffc0202816:	b2650513          	addi	a0,a0,-1242 # ffffffffc0206338 <commands+0x1160>
ffffffffc020281a:	9affd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020281e:	00004697          	auipc	a3,0x4
ffffffffc0202822:	bba68693          	addi	a3,a3,-1094 # ffffffffc02063d8 <commands+0x1200>
ffffffffc0202826:	00003617          	auipc	a2,0x3
ffffffffc020282a:	0da60613          	addi	a2,a2,218 # ffffffffc0205900 <commands+0x728>
ffffffffc020282e:	0be00593          	li	a1,190
ffffffffc0202832:	00004517          	auipc	a0,0x4
ffffffffc0202836:	b0650513          	addi	a0,a0,-1274 # ffffffffc0206338 <commands+0x1160>
ffffffffc020283a:	98ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020283e:	00004697          	auipc	a3,0x4
ffffffffc0202842:	bda68693          	addi	a3,a3,-1062 # ffffffffc0206418 <commands+0x1240>
ffffffffc0202846:	00003617          	auipc	a2,0x3
ffffffffc020284a:	0ba60613          	addi	a2,a2,186 # ffffffffc0205900 <commands+0x728>
ffffffffc020284e:	0c000593          	li	a1,192
ffffffffc0202852:	00004517          	auipc	a0,0x4
ffffffffc0202856:	ae650513          	addi	a0,a0,-1306 # ffffffffc0206338 <commands+0x1160>
ffffffffc020285a:	96ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020285e:	00004697          	auipc	a3,0x4
ffffffffc0202862:	c4268693          	addi	a3,a3,-958 # ffffffffc02064a0 <commands+0x12c8>
ffffffffc0202866:	00003617          	auipc	a2,0x3
ffffffffc020286a:	09a60613          	addi	a2,a2,154 # ffffffffc0205900 <commands+0x728>
ffffffffc020286e:	0d900593          	li	a1,217
ffffffffc0202872:	00004517          	auipc	a0,0x4
ffffffffc0202876:	ac650513          	addi	a0,a0,-1338 # ffffffffc0206338 <commands+0x1160>
ffffffffc020287a:	94ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020287e:	00004697          	auipc	a3,0x4
ffffffffc0202882:	ad268693          	addi	a3,a3,-1326 # ffffffffc0206350 <commands+0x1178>
ffffffffc0202886:	00003617          	auipc	a2,0x3
ffffffffc020288a:	07a60613          	addi	a2,a2,122 # ffffffffc0205900 <commands+0x728>
ffffffffc020288e:	0d200593          	li	a1,210
ffffffffc0202892:	00004517          	auipc	a0,0x4
ffffffffc0202896:	aa650513          	addi	a0,a0,-1370 # ffffffffc0206338 <commands+0x1160>
ffffffffc020289a:	92ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020289e:	00004697          	auipc	a3,0x4
ffffffffc02028a2:	bf268693          	addi	a3,a3,-1038 # ffffffffc0206490 <commands+0x12b8>
ffffffffc02028a6:	00003617          	auipc	a2,0x3
ffffffffc02028aa:	05a60613          	addi	a2,a2,90 # ffffffffc0205900 <commands+0x728>
ffffffffc02028ae:	0d000593          	li	a1,208
ffffffffc02028b2:	00004517          	auipc	a0,0x4
ffffffffc02028b6:	a8650513          	addi	a0,a0,-1402 # ffffffffc0206338 <commands+0x1160>
ffffffffc02028ba:	90ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02028be:	00004697          	auipc	a3,0x4
ffffffffc02028c2:	bba68693          	addi	a3,a3,-1094 # ffffffffc0206478 <commands+0x12a0>
ffffffffc02028c6:	00003617          	auipc	a2,0x3
ffffffffc02028ca:	03a60613          	addi	a2,a2,58 # ffffffffc0205900 <commands+0x728>
ffffffffc02028ce:	0cb00593          	li	a1,203
ffffffffc02028d2:	00004517          	auipc	a0,0x4
ffffffffc02028d6:	a6650513          	addi	a0,a0,-1434 # ffffffffc0206338 <commands+0x1160>
ffffffffc02028da:	8effd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02028de:	00004697          	auipc	a3,0x4
ffffffffc02028e2:	b7a68693          	addi	a3,a3,-1158 # ffffffffc0206458 <commands+0x1280>
ffffffffc02028e6:	00003617          	auipc	a2,0x3
ffffffffc02028ea:	01a60613          	addi	a2,a2,26 # ffffffffc0205900 <commands+0x728>
ffffffffc02028ee:	0c200593          	li	a1,194
ffffffffc02028f2:	00004517          	auipc	a0,0x4
ffffffffc02028f6:	a4650513          	addi	a0,a0,-1466 # ffffffffc0206338 <commands+0x1160>
ffffffffc02028fa:	8cffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02028fe:	00004697          	auipc	a3,0x4
ffffffffc0202902:	bda68693          	addi	a3,a3,-1062 # ffffffffc02064d8 <commands+0x1300>
ffffffffc0202906:	00003617          	auipc	a2,0x3
ffffffffc020290a:	ffa60613          	addi	a2,a2,-6 # ffffffffc0205900 <commands+0x728>
ffffffffc020290e:	0f800593          	li	a1,248
ffffffffc0202912:	00004517          	auipc	a0,0x4
ffffffffc0202916:	a2650513          	addi	a0,a0,-1498 # ffffffffc0206338 <commands+0x1160>
ffffffffc020291a:	8affd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020291e:	00004697          	auipc	a3,0x4
ffffffffc0202922:	84268693          	addi	a3,a3,-1982 # ffffffffc0206160 <commands+0xf88>
ffffffffc0202926:	00003617          	auipc	a2,0x3
ffffffffc020292a:	fda60613          	addi	a2,a2,-38 # ffffffffc0205900 <commands+0x728>
ffffffffc020292e:	0df00593          	li	a1,223
ffffffffc0202932:	00004517          	auipc	a0,0x4
ffffffffc0202936:	a0650513          	addi	a0,a0,-1530 # ffffffffc0206338 <commands+0x1160>
ffffffffc020293a:	88ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020293e:	00004697          	auipc	a3,0x4
ffffffffc0202942:	b3a68693          	addi	a3,a3,-1222 # ffffffffc0206478 <commands+0x12a0>
ffffffffc0202946:	00003617          	auipc	a2,0x3
ffffffffc020294a:	fba60613          	addi	a2,a2,-70 # ffffffffc0205900 <commands+0x728>
ffffffffc020294e:	0dd00593          	li	a1,221
ffffffffc0202952:	00004517          	auipc	a0,0x4
ffffffffc0202956:	9e650513          	addi	a0,a0,-1562 # ffffffffc0206338 <commands+0x1160>
ffffffffc020295a:	86ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020295e:	00004697          	auipc	a3,0x4
ffffffffc0202962:	b5a68693          	addi	a3,a3,-1190 # ffffffffc02064b8 <commands+0x12e0>
ffffffffc0202966:	00003617          	auipc	a2,0x3
ffffffffc020296a:	f9a60613          	addi	a2,a2,-102 # ffffffffc0205900 <commands+0x728>
ffffffffc020296e:	0dc00593          	li	a1,220
ffffffffc0202972:	00004517          	auipc	a0,0x4
ffffffffc0202976:	9c650513          	addi	a0,a0,-1594 # ffffffffc0206338 <commands+0x1160>
ffffffffc020297a:	84ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020297e:	00004697          	auipc	a3,0x4
ffffffffc0202982:	9d268693          	addi	a3,a3,-1582 # ffffffffc0206350 <commands+0x1178>
ffffffffc0202986:	00003617          	auipc	a2,0x3
ffffffffc020298a:	f7a60613          	addi	a2,a2,-134 # ffffffffc0205900 <commands+0x728>
ffffffffc020298e:	0b900593          	li	a1,185
ffffffffc0202992:	00004517          	auipc	a0,0x4
ffffffffc0202996:	9a650513          	addi	a0,a0,-1626 # ffffffffc0206338 <commands+0x1160>
ffffffffc020299a:	82ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020299e:	00004697          	auipc	a3,0x4
ffffffffc02029a2:	ada68693          	addi	a3,a3,-1318 # ffffffffc0206478 <commands+0x12a0>
ffffffffc02029a6:	00003617          	auipc	a2,0x3
ffffffffc02029aa:	f5a60613          	addi	a2,a2,-166 # ffffffffc0205900 <commands+0x728>
ffffffffc02029ae:	0d600593          	li	a1,214
ffffffffc02029b2:	00004517          	auipc	a0,0x4
ffffffffc02029b6:	98650513          	addi	a0,a0,-1658 # ffffffffc0206338 <commands+0x1160>
ffffffffc02029ba:	80ffd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02029be:	00004697          	auipc	a3,0x4
ffffffffc02029c2:	9d268693          	addi	a3,a3,-1582 # ffffffffc0206390 <commands+0x11b8>
ffffffffc02029c6:	00003617          	auipc	a2,0x3
ffffffffc02029ca:	f3a60613          	addi	a2,a2,-198 # ffffffffc0205900 <commands+0x728>
ffffffffc02029ce:	0d400593          	li	a1,212
ffffffffc02029d2:	00004517          	auipc	a0,0x4
ffffffffc02029d6:	96650513          	addi	a0,a0,-1690 # ffffffffc0206338 <commands+0x1160>
ffffffffc02029da:	feefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02029de:	00004697          	auipc	a3,0x4
ffffffffc02029e2:	99268693          	addi	a3,a3,-1646 # ffffffffc0206370 <commands+0x1198>
ffffffffc02029e6:	00003617          	auipc	a2,0x3
ffffffffc02029ea:	f1a60613          	addi	a2,a2,-230 # ffffffffc0205900 <commands+0x728>
ffffffffc02029ee:	0d300593          	li	a1,211
ffffffffc02029f2:	00004517          	auipc	a0,0x4
ffffffffc02029f6:	94650513          	addi	a0,a0,-1722 # ffffffffc0206338 <commands+0x1160>
ffffffffc02029fa:	fcefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02029fe:	00004697          	auipc	a3,0x4
ffffffffc0202a02:	99268693          	addi	a3,a3,-1646 # ffffffffc0206390 <commands+0x11b8>
ffffffffc0202a06:	00003617          	auipc	a2,0x3
ffffffffc0202a0a:	efa60613          	addi	a2,a2,-262 # ffffffffc0205900 <commands+0x728>
ffffffffc0202a0e:	0bb00593          	li	a1,187
ffffffffc0202a12:	00004517          	auipc	a0,0x4
ffffffffc0202a16:	92650513          	addi	a0,a0,-1754 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202a1a:	faefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202a1e:	00004697          	auipc	a3,0x4
ffffffffc0202a22:	c0a68693          	addi	a3,a3,-1014 # ffffffffc0206628 <commands+0x1450>
ffffffffc0202a26:	00003617          	auipc	a2,0x3
ffffffffc0202a2a:	eda60613          	addi	a2,a2,-294 # ffffffffc0205900 <commands+0x728>
ffffffffc0202a2e:	12500593          	li	a1,293
ffffffffc0202a32:	00004517          	auipc	a0,0x4
ffffffffc0202a36:	90650513          	addi	a0,a0,-1786 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202a3a:	f8efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202a3e:	00003697          	auipc	a3,0x3
ffffffffc0202a42:	72268693          	addi	a3,a3,1826 # ffffffffc0206160 <commands+0xf88>
ffffffffc0202a46:	00003617          	auipc	a2,0x3
ffffffffc0202a4a:	eba60613          	addi	a2,a2,-326 # ffffffffc0205900 <commands+0x728>
ffffffffc0202a4e:	11a00593          	li	a1,282
ffffffffc0202a52:	00004517          	auipc	a0,0x4
ffffffffc0202a56:	8e650513          	addi	a0,a0,-1818 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202a5a:	f6efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202a5e:	00004697          	auipc	a3,0x4
ffffffffc0202a62:	a1a68693          	addi	a3,a3,-1510 # ffffffffc0206478 <commands+0x12a0>
ffffffffc0202a66:	00003617          	auipc	a2,0x3
ffffffffc0202a6a:	e9a60613          	addi	a2,a2,-358 # ffffffffc0205900 <commands+0x728>
ffffffffc0202a6e:	11800593          	li	a1,280
ffffffffc0202a72:	00004517          	auipc	a0,0x4
ffffffffc0202a76:	8c650513          	addi	a0,a0,-1850 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202a7a:	f4efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202a7e:	00004697          	auipc	a3,0x4
ffffffffc0202a82:	9ba68693          	addi	a3,a3,-1606 # ffffffffc0206438 <commands+0x1260>
ffffffffc0202a86:	00003617          	auipc	a2,0x3
ffffffffc0202a8a:	e7a60613          	addi	a2,a2,-390 # ffffffffc0205900 <commands+0x728>
ffffffffc0202a8e:	0c100593          	li	a1,193
ffffffffc0202a92:	00004517          	auipc	a0,0x4
ffffffffc0202a96:	8a650513          	addi	a0,a0,-1882 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202a9a:	f2efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202a9e:	00004697          	auipc	a3,0x4
ffffffffc0202aa2:	b4a68693          	addi	a3,a3,-1206 # ffffffffc02065e8 <commands+0x1410>
ffffffffc0202aa6:	00003617          	auipc	a2,0x3
ffffffffc0202aaa:	e5a60613          	addi	a2,a2,-422 # ffffffffc0205900 <commands+0x728>
ffffffffc0202aae:	11200593          	li	a1,274
ffffffffc0202ab2:	00004517          	auipc	a0,0x4
ffffffffc0202ab6:	88650513          	addi	a0,a0,-1914 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202aba:	f0efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202abe:	00004697          	auipc	a3,0x4
ffffffffc0202ac2:	b0a68693          	addi	a3,a3,-1270 # ffffffffc02065c8 <commands+0x13f0>
ffffffffc0202ac6:	00003617          	auipc	a2,0x3
ffffffffc0202aca:	e3a60613          	addi	a2,a2,-454 # ffffffffc0205900 <commands+0x728>
ffffffffc0202ace:	11000593          	li	a1,272
ffffffffc0202ad2:	00004517          	auipc	a0,0x4
ffffffffc0202ad6:	86650513          	addi	a0,a0,-1946 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202ada:	eeefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202ade:	00004697          	auipc	a3,0x4
ffffffffc0202ae2:	ac268693          	addi	a3,a3,-1342 # ffffffffc02065a0 <commands+0x13c8>
ffffffffc0202ae6:	00003617          	auipc	a2,0x3
ffffffffc0202aea:	e1a60613          	addi	a2,a2,-486 # ffffffffc0205900 <commands+0x728>
ffffffffc0202aee:	10e00593          	li	a1,270
ffffffffc0202af2:	00004517          	auipc	a0,0x4
ffffffffc0202af6:	84650513          	addi	a0,a0,-1978 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202afa:	ecefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202afe:	00004697          	auipc	a3,0x4
ffffffffc0202b02:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0206578 <commands+0x13a0>
ffffffffc0202b06:	00003617          	auipc	a2,0x3
ffffffffc0202b0a:	dfa60613          	addi	a2,a2,-518 # ffffffffc0205900 <commands+0x728>
ffffffffc0202b0e:	10d00593          	li	a1,269
ffffffffc0202b12:	00004517          	auipc	a0,0x4
ffffffffc0202b16:	82650513          	addi	a0,a0,-2010 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202b1a:	eaefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202b1e:	00004697          	auipc	a3,0x4
ffffffffc0202b22:	a4a68693          	addi	a3,a3,-1462 # ffffffffc0206568 <commands+0x1390>
ffffffffc0202b26:	00003617          	auipc	a2,0x3
ffffffffc0202b2a:	dda60613          	addi	a2,a2,-550 # ffffffffc0205900 <commands+0x728>
ffffffffc0202b2e:	10800593          	li	a1,264
ffffffffc0202b32:	00004517          	auipc	a0,0x4
ffffffffc0202b36:	80650513          	addi	a0,a0,-2042 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202b3a:	e8efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202b3e:	00004697          	auipc	a3,0x4
ffffffffc0202b42:	93a68693          	addi	a3,a3,-1734 # ffffffffc0206478 <commands+0x12a0>
ffffffffc0202b46:	00003617          	auipc	a2,0x3
ffffffffc0202b4a:	dba60613          	addi	a2,a2,-582 # ffffffffc0205900 <commands+0x728>
ffffffffc0202b4e:	10700593          	li	a1,263
ffffffffc0202b52:	00003517          	auipc	a0,0x3
ffffffffc0202b56:	7e650513          	addi	a0,a0,2022 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202b5a:	e6efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202b5e:	00004697          	auipc	a3,0x4
ffffffffc0202b62:	9ea68693          	addi	a3,a3,-1558 # ffffffffc0206548 <commands+0x1370>
ffffffffc0202b66:	00003617          	auipc	a2,0x3
ffffffffc0202b6a:	d9a60613          	addi	a2,a2,-614 # ffffffffc0205900 <commands+0x728>
ffffffffc0202b6e:	10600593          	li	a1,262
ffffffffc0202b72:	00003517          	auipc	a0,0x3
ffffffffc0202b76:	7c650513          	addi	a0,a0,1990 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202b7a:	e4efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202b7e:	00004697          	auipc	a3,0x4
ffffffffc0202b82:	99a68693          	addi	a3,a3,-1638 # ffffffffc0206518 <commands+0x1340>
ffffffffc0202b86:	00003617          	auipc	a2,0x3
ffffffffc0202b8a:	d7a60613          	addi	a2,a2,-646 # ffffffffc0205900 <commands+0x728>
ffffffffc0202b8e:	10500593          	li	a1,261
ffffffffc0202b92:	00003517          	auipc	a0,0x3
ffffffffc0202b96:	7a650513          	addi	a0,a0,1958 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202b9a:	e2efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202b9e:	00004697          	auipc	a3,0x4
ffffffffc0202ba2:	96268693          	addi	a3,a3,-1694 # ffffffffc0206500 <commands+0x1328>
ffffffffc0202ba6:	00003617          	auipc	a2,0x3
ffffffffc0202baa:	d5a60613          	addi	a2,a2,-678 # ffffffffc0205900 <commands+0x728>
ffffffffc0202bae:	10400593          	li	a1,260
ffffffffc0202bb2:	00003517          	auipc	a0,0x3
ffffffffc0202bb6:	78650513          	addi	a0,a0,1926 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202bba:	e0efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202bbe:	00004697          	auipc	a3,0x4
ffffffffc0202bc2:	8ba68693          	addi	a3,a3,-1862 # ffffffffc0206478 <commands+0x12a0>
ffffffffc0202bc6:	00003617          	auipc	a2,0x3
ffffffffc0202bca:	d3a60613          	addi	a2,a2,-710 # ffffffffc0205900 <commands+0x728>
ffffffffc0202bce:	0fe00593          	li	a1,254
ffffffffc0202bd2:	00003517          	auipc	a0,0x3
ffffffffc0202bd6:	76650513          	addi	a0,a0,1894 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202bda:	deefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202bde:	00004697          	auipc	a3,0x4
ffffffffc0202be2:	90a68693          	addi	a3,a3,-1782 # ffffffffc02064e8 <commands+0x1310>
ffffffffc0202be6:	00003617          	auipc	a2,0x3
ffffffffc0202bea:	d1a60613          	addi	a2,a2,-742 # ffffffffc0205900 <commands+0x728>
ffffffffc0202bee:	0f900593          	li	a1,249
ffffffffc0202bf2:	00003517          	auipc	a0,0x3
ffffffffc0202bf6:	74650513          	addi	a0,a0,1862 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202bfa:	dcefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202bfe:	00004697          	auipc	a3,0x4
ffffffffc0202c02:	a0a68693          	addi	a3,a3,-1526 # ffffffffc0206608 <commands+0x1430>
ffffffffc0202c06:	00003617          	auipc	a2,0x3
ffffffffc0202c0a:	cfa60613          	addi	a2,a2,-774 # ffffffffc0205900 <commands+0x728>
ffffffffc0202c0e:	11700593          	li	a1,279
ffffffffc0202c12:	00003517          	auipc	a0,0x3
ffffffffc0202c16:	72650513          	addi	a0,a0,1830 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202c1a:	daefd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202c1e:	00004697          	auipc	a3,0x4
ffffffffc0202c22:	a1a68693          	addi	a3,a3,-1510 # ffffffffc0206638 <commands+0x1460>
ffffffffc0202c26:	00003617          	auipc	a2,0x3
ffffffffc0202c2a:	cda60613          	addi	a2,a2,-806 # ffffffffc0205900 <commands+0x728>
ffffffffc0202c2e:	12600593          	li	a1,294
ffffffffc0202c32:	00003517          	auipc	a0,0x3
ffffffffc0202c36:	70650513          	addi	a0,a0,1798 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202c3a:	d8efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202c3e:	00003697          	auipc	a3,0x3
ffffffffc0202c42:	39268693          	addi	a3,a3,914 # ffffffffc0205fd0 <commands+0xdf8>
ffffffffc0202c46:	00003617          	auipc	a2,0x3
ffffffffc0202c4a:	cba60613          	addi	a2,a2,-838 # ffffffffc0205900 <commands+0x728>
ffffffffc0202c4e:	0f300593          	li	a1,243
ffffffffc0202c52:	00003517          	auipc	a0,0x3
ffffffffc0202c56:	6e650513          	addi	a0,a0,1766 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202c5a:	d6efd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202c5e:	00003697          	auipc	a3,0x3
ffffffffc0202c62:	71268693          	addi	a3,a3,1810 # ffffffffc0206370 <commands+0x1198>
ffffffffc0202c66:	00003617          	auipc	a2,0x3
ffffffffc0202c6a:	c9a60613          	addi	a2,a2,-870 # ffffffffc0205900 <commands+0x728>
ffffffffc0202c6e:	0ba00593          	li	a1,186
ffffffffc0202c72:	00003517          	auipc	a0,0x3
ffffffffc0202c76:	6c650513          	addi	a0,a0,1734 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202c7a:	d4efd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202c7e <default_free_pages>:
ffffffffc0202c7e:	1141                	addi	sp,sp,-16
ffffffffc0202c80:	e406                	sd	ra,8(sp)
ffffffffc0202c82:	12058f63          	beqz	a1,ffffffffc0202dc0 <default_free_pages+0x142>
ffffffffc0202c86:	00659693          	slli	a3,a1,0x6
ffffffffc0202c8a:	96aa                	add	a3,a3,a0
ffffffffc0202c8c:	87aa                	mv	a5,a0
ffffffffc0202c8e:	02d50263          	beq	a0,a3,ffffffffc0202cb2 <default_free_pages+0x34>
ffffffffc0202c92:	6798                	ld	a4,8(a5)
ffffffffc0202c94:	8b05                	andi	a4,a4,1
ffffffffc0202c96:	10071563          	bnez	a4,ffffffffc0202da0 <default_free_pages+0x122>
ffffffffc0202c9a:	6798                	ld	a4,8(a5)
ffffffffc0202c9c:	8b09                	andi	a4,a4,2
ffffffffc0202c9e:	10071163          	bnez	a4,ffffffffc0202da0 <default_free_pages+0x122>
ffffffffc0202ca2:	0007b423          	sd	zero,8(a5)
ffffffffc0202ca6:	0007a023          	sw	zero,0(a5)
ffffffffc0202caa:	04078793          	addi	a5,a5,64
ffffffffc0202cae:	fed792e3          	bne	a5,a3,ffffffffc0202c92 <default_free_pages+0x14>
ffffffffc0202cb2:	2581                	sext.w	a1,a1
ffffffffc0202cb4:	c90c                	sw	a1,16(a0)
ffffffffc0202cb6:	00850893          	addi	a7,a0,8
ffffffffc0202cba:	4789                	li	a5,2
ffffffffc0202cbc:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0202cc0:	00010697          	auipc	a3,0x10
ffffffffc0202cc4:	84068693          	addi	a3,a3,-1984 # ffffffffc0212500 <free_area>
ffffffffc0202cc8:	4a98                	lw	a4,16(a3)
ffffffffc0202cca:	669c                	ld	a5,8(a3)
ffffffffc0202ccc:	01850613          	addi	a2,a0,24
ffffffffc0202cd0:	9db9                	addw	a1,a1,a4
ffffffffc0202cd2:	ca8c                	sw	a1,16(a3)
ffffffffc0202cd4:	08d78f63          	beq	a5,a3,ffffffffc0202d72 <default_free_pages+0xf4>
ffffffffc0202cd8:	fe878713          	addi	a4,a5,-24
ffffffffc0202cdc:	0006b803          	ld	a6,0(a3)
ffffffffc0202ce0:	4581                	li	a1,0
ffffffffc0202ce2:	00e56a63          	bltu	a0,a4,ffffffffc0202cf6 <default_free_pages+0x78>
ffffffffc0202ce6:	6798                	ld	a4,8(a5)
ffffffffc0202ce8:	04d70a63          	beq	a4,a3,ffffffffc0202d3c <default_free_pages+0xbe>
ffffffffc0202cec:	87ba                	mv	a5,a4
ffffffffc0202cee:	fe878713          	addi	a4,a5,-24
ffffffffc0202cf2:	fee57ae3          	bgeu	a0,a4,ffffffffc0202ce6 <default_free_pages+0x68>
ffffffffc0202cf6:	c199                	beqz	a1,ffffffffc0202cfc <default_free_pages+0x7e>
ffffffffc0202cf8:	0106b023          	sd	a6,0(a3)
ffffffffc0202cfc:	6398                	ld	a4,0(a5)
ffffffffc0202cfe:	e390                	sd	a2,0(a5)
ffffffffc0202d00:	e710                	sd	a2,8(a4)
ffffffffc0202d02:	f11c                	sd	a5,32(a0)
ffffffffc0202d04:	ed18                	sd	a4,24(a0)
ffffffffc0202d06:	00d70c63          	beq	a4,a3,ffffffffc0202d1e <default_free_pages+0xa0>
ffffffffc0202d0a:	ff872583          	lw	a1,-8(a4)
ffffffffc0202d0e:	fe870613          	addi	a2,a4,-24
ffffffffc0202d12:	02059793          	slli	a5,a1,0x20
ffffffffc0202d16:	83e9                	srli	a5,a5,0x1a
ffffffffc0202d18:	97b2                	add	a5,a5,a2
ffffffffc0202d1a:	02f50b63          	beq	a0,a5,ffffffffc0202d50 <default_free_pages+0xd2>
ffffffffc0202d1e:	7118                	ld	a4,32(a0)
ffffffffc0202d20:	00d70b63          	beq	a4,a3,ffffffffc0202d36 <default_free_pages+0xb8>
ffffffffc0202d24:	4910                	lw	a2,16(a0)
ffffffffc0202d26:	fe870693          	addi	a3,a4,-24
ffffffffc0202d2a:	02061793          	slli	a5,a2,0x20
ffffffffc0202d2e:	83e9                	srli	a5,a5,0x1a
ffffffffc0202d30:	97aa                	add	a5,a5,a0
ffffffffc0202d32:	04f68763          	beq	a3,a5,ffffffffc0202d80 <default_free_pages+0x102>
ffffffffc0202d36:	60a2                	ld	ra,8(sp)
ffffffffc0202d38:	0141                	addi	sp,sp,16
ffffffffc0202d3a:	8082                	ret
ffffffffc0202d3c:	e790                	sd	a2,8(a5)
ffffffffc0202d3e:	f114                	sd	a3,32(a0)
ffffffffc0202d40:	6798                	ld	a4,8(a5)
ffffffffc0202d42:	ed1c                	sd	a5,24(a0)
ffffffffc0202d44:	02d70463          	beq	a4,a3,ffffffffc0202d6c <default_free_pages+0xee>
ffffffffc0202d48:	8832                	mv	a6,a2
ffffffffc0202d4a:	4585                	li	a1,1
ffffffffc0202d4c:	87ba                	mv	a5,a4
ffffffffc0202d4e:	b745                	j	ffffffffc0202cee <default_free_pages+0x70>
ffffffffc0202d50:	491c                	lw	a5,16(a0)
ffffffffc0202d52:	9dbd                	addw	a1,a1,a5
ffffffffc0202d54:	feb72c23          	sw	a1,-8(a4)
ffffffffc0202d58:	57f5                	li	a5,-3
ffffffffc0202d5a:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0202d5e:	6d0c                	ld	a1,24(a0)
ffffffffc0202d60:	711c                	ld	a5,32(a0)
ffffffffc0202d62:	8532                	mv	a0,a2
ffffffffc0202d64:	e59c                	sd	a5,8(a1)
ffffffffc0202d66:	6718                	ld	a4,8(a4)
ffffffffc0202d68:	e38c                	sd	a1,0(a5)
ffffffffc0202d6a:	bf5d                	j	ffffffffc0202d20 <default_free_pages+0xa2>
ffffffffc0202d6c:	e290                	sd	a2,0(a3)
ffffffffc0202d6e:	873e                	mv	a4,a5
ffffffffc0202d70:	bf69                	j	ffffffffc0202d0a <default_free_pages+0x8c>
ffffffffc0202d72:	60a2                	ld	ra,8(sp)
ffffffffc0202d74:	e390                	sd	a2,0(a5)
ffffffffc0202d76:	e790                	sd	a2,8(a5)
ffffffffc0202d78:	f11c                	sd	a5,32(a0)
ffffffffc0202d7a:	ed1c                	sd	a5,24(a0)
ffffffffc0202d7c:	0141                	addi	sp,sp,16
ffffffffc0202d7e:	8082                	ret
ffffffffc0202d80:	ff872783          	lw	a5,-8(a4)
ffffffffc0202d84:	ff070693          	addi	a3,a4,-16
ffffffffc0202d88:	9e3d                	addw	a2,a2,a5
ffffffffc0202d8a:	c910                	sw	a2,16(a0)
ffffffffc0202d8c:	57f5                	li	a5,-3
ffffffffc0202d8e:	60f6b02f          	amoand.d	zero,a5,(a3)
ffffffffc0202d92:	6314                	ld	a3,0(a4)
ffffffffc0202d94:	671c                	ld	a5,8(a4)
ffffffffc0202d96:	60a2                	ld	ra,8(sp)
ffffffffc0202d98:	e69c                	sd	a5,8(a3)
ffffffffc0202d9a:	e394                	sd	a3,0(a5)
ffffffffc0202d9c:	0141                	addi	sp,sp,16
ffffffffc0202d9e:	8082                	ret
ffffffffc0202da0:	00004697          	auipc	a3,0x4
ffffffffc0202da4:	8b068693          	addi	a3,a3,-1872 # ffffffffc0206650 <commands+0x1478>
ffffffffc0202da8:	00003617          	auipc	a2,0x3
ffffffffc0202dac:	b5860613          	addi	a2,a2,-1192 # ffffffffc0205900 <commands+0x728>
ffffffffc0202db0:	08300593          	li	a1,131
ffffffffc0202db4:	00003517          	auipc	a0,0x3
ffffffffc0202db8:	58450513          	addi	a0,a0,1412 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202dbc:	c0cfd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202dc0:	00004697          	auipc	a3,0x4
ffffffffc0202dc4:	88868693          	addi	a3,a3,-1912 # ffffffffc0206648 <commands+0x1470>
ffffffffc0202dc8:	00003617          	auipc	a2,0x3
ffffffffc0202dcc:	b3860613          	addi	a2,a2,-1224 # ffffffffc0205900 <commands+0x728>
ffffffffc0202dd0:	08000593          	li	a1,128
ffffffffc0202dd4:	00003517          	auipc	a0,0x3
ffffffffc0202dd8:	56450513          	addi	a0,a0,1380 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202ddc:	becfd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202de0 <default_alloc_pages>:
ffffffffc0202de0:	c941                	beqz	a0,ffffffffc0202e70 <default_alloc_pages+0x90>
ffffffffc0202de2:	0000f597          	auipc	a1,0xf
ffffffffc0202de6:	71e58593          	addi	a1,a1,1822 # ffffffffc0212500 <free_area>
ffffffffc0202dea:	0105a803          	lw	a6,16(a1)
ffffffffc0202dee:	872a                	mv	a4,a0
ffffffffc0202df0:	02081793          	slli	a5,a6,0x20
ffffffffc0202df4:	9381                	srli	a5,a5,0x20
ffffffffc0202df6:	00a7ee63          	bltu	a5,a0,ffffffffc0202e12 <default_alloc_pages+0x32>
ffffffffc0202dfa:	87ae                	mv	a5,a1
ffffffffc0202dfc:	a801                	j	ffffffffc0202e0c <default_alloc_pages+0x2c>
ffffffffc0202dfe:	ff87a683          	lw	a3,-8(a5)
ffffffffc0202e02:	02069613          	slli	a2,a3,0x20
ffffffffc0202e06:	9201                	srli	a2,a2,0x20
ffffffffc0202e08:	00e67763          	bgeu	a2,a4,ffffffffc0202e16 <default_alloc_pages+0x36>
ffffffffc0202e0c:	679c                	ld	a5,8(a5)
ffffffffc0202e0e:	feb798e3          	bne	a5,a1,ffffffffc0202dfe <default_alloc_pages+0x1e>
ffffffffc0202e12:	4501                	li	a0,0
ffffffffc0202e14:	8082                	ret
ffffffffc0202e16:	0007b883          	ld	a7,0(a5)
ffffffffc0202e1a:	0087b303          	ld	t1,8(a5)
ffffffffc0202e1e:	fe878513          	addi	a0,a5,-24
ffffffffc0202e22:	00070e1b          	sext.w	t3,a4
ffffffffc0202e26:	0068b423          	sd	t1,8(a7)
ffffffffc0202e2a:	01133023          	sd	a7,0(t1)
ffffffffc0202e2e:	02c77863          	bgeu	a4,a2,ffffffffc0202e5e <default_alloc_pages+0x7e>
ffffffffc0202e32:	071a                	slli	a4,a4,0x6
ffffffffc0202e34:	972a                	add	a4,a4,a0
ffffffffc0202e36:	41c686bb          	subw	a3,a3,t3
ffffffffc0202e3a:	cb14                	sw	a3,16(a4)
ffffffffc0202e3c:	00870613          	addi	a2,a4,8
ffffffffc0202e40:	4689                	li	a3,2
ffffffffc0202e42:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0202e46:	0088b683          	ld	a3,8(a7)
ffffffffc0202e4a:	01870613          	addi	a2,a4,24
ffffffffc0202e4e:	0105a803          	lw	a6,16(a1)
ffffffffc0202e52:	e290                	sd	a2,0(a3)
ffffffffc0202e54:	00c8b423          	sd	a2,8(a7)
ffffffffc0202e58:	f314                	sd	a3,32(a4)
ffffffffc0202e5a:	01173c23          	sd	a7,24(a4)
ffffffffc0202e5e:	41c8083b          	subw	a6,a6,t3
ffffffffc0202e62:	0105a823          	sw	a6,16(a1)
ffffffffc0202e66:	5775                	li	a4,-3
ffffffffc0202e68:	17c1                	addi	a5,a5,-16
ffffffffc0202e6a:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0202e6e:	8082                	ret
ffffffffc0202e70:	1141                	addi	sp,sp,-16
ffffffffc0202e72:	00003697          	auipc	a3,0x3
ffffffffc0202e76:	7d668693          	addi	a3,a3,2006 # ffffffffc0206648 <commands+0x1470>
ffffffffc0202e7a:	00003617          	auipc	a2,0x3
ffffffffc0202e7e:	a8660613          	addi	a2,a2,-1402 # ffffffffc0205900 <commands+0x728>
ffffffffc0202e82:	06200593          	li	a1,98
ffffffffc0202e86:	00003517          	auipc	a0,0x3
ffffffffc0202e8a:	4b250513          	addi	a0,a0,1202 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202e8e:	e406                	sd	ra,8(sp)
ffffffffc0202e90:	b38fd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202e94 <default_init_memmap>:
ffffffffc0202e94:	1141                	addi	sp,sp,-16
ffffffffc0202e96:	e406                	sd	ra,8(sp)
ffffffffc0202e98:	c5f1                	beqz	a1,ffffffffc0202f64 <default_init_memmap+0xd0>
ffffffffc0202e9a:	00659693          	slli	a3,a1,0x6
ffffffffc0202e9e:	96aa                	add	a3,a3,a0
ffffffffc0202ea0:	87aa                	mv	a5,a0
ffffffffc0202ea2:	00d50f63          	beq	a0,a3,ffffffffc0202ec0 <default_init_memmap+0x2c>
ffffffffc0202ea6:	6798                	ld	a4,8(a5)
ffffffffc0202ea8:	8b05                	andi	a4,a4,1
ffffffffc0202eaa:	cf49                	beqz	a4,ffffffffc0202f44 <default_init_memmap+0xb0>
ffffffffc0202eac:	0007a823          	sw	zero,16(a5)
ffffffffc0202eb0:	0007b423          	sd	zero,8(a5)
ffffffffc0202eb4:	0007a023          	sw	zero,0(a5)
ffffffffc0202eb8:	04078793          	addi	a5,a5,64
ffffffffc0202ebc:	fed795e3          	bne	a5,a3,ffffffffc0202ea6 <default_init_memmap+0x12>
ffffffffc0202ec0:	2581                	sext.w	a1,a1
ffffffffc0202ec2:	c90c                	sw	a1,16(a0)
ffffffffc0202ec4:	4789                	li	a5,2
ffffffffc0202ec6:	00850713          	addi	a4,a0,8
ffffffffc0202eca:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0202ece:	0000f697          	auipc	a3,0xf
ffffffffc0202ed2:	63268693          	addi	a3,a3,1586 # ffffffffc0212500 <free_area>
ffffffffc0202ed6:	4a98                	lw	a4,16(a3)
ffffffffc0202ed8:	669c                	ld	a5,8(a3)
ffffffffc0202eda:	01850613          	addi	a2,a0,24
ffffffffc0202ede:	9db9                	addw	a1,a1,a4
ffffffffc0202ee0:	ca8c                	sw	a1,16(a3)
ffffffffc0202ee2:	04d78a63          	beq	a5,a3,ffffffffc0202f36 <default_init_memmap+0xa2>
ffffffffc0202ee6:	fe878713          	addi	a4,a5,-24
ffffffffc0202eea:	0006b803          	ld	a6,0(a3)
ffffffffc0202eee:	4581                	li	a1,0
ffffffffc0202ef0:	00e56a63          	bltu	a0,a4,ffffffffc0202f04 <default_init_memmap+0x70>
ffffffffc0202ef4:	6798                	ld	a4,8(a5)
ffffffffc0202ef6:	02d70263          	beq	a4,a3,ffffffffc0202f1a <default_init_memmap+0x86>
ffffffffc0202efa:	87ba                	mv	a5,a4
ffffffffc0202efc:	fe878713          	addi	a4,a5,-24
ffffffffc0202f00:	fee57ae3          	bgeu	a0,a4,ffffffffc0202ef4 <default_init_memmap+0x60>
ffffffffc0202f04:	c199                	beqz	a1,ffffffffc0202f0a <default_init_memmap+0x76>
ffffffffc0202f06:	0106b023          	sd	a6,0(a3)
ffffffffc0202f0a:	6398                	ld	a4,0(a5)
ffffffffc0202f0c:	60a2                	ld	ra,8(sp)
ffffffffc0202f0e:	e390                	sd	a2,0(a5)
ffffffffc0202f10:	e710                	sd	a2,8(a4)
ffffffffc0202f12:	f11c                	sd	a5,32(a0)
ffffffffc0202f14:	ed18                	sd	a4,24(a0)
ffffffffc0202f16:	0141                	addi	sp,sp,16
ffffffffc0202f18:	8082                	ret
ffffffffc0202f1a:	e790                	sd	a2,8(a5)
ffffffffc0202f1c:	f114                	sd	a3,32(a0)
ffffffffc0202f1e:	6798                	ld	a4,8(a5)
ffffffffc0202f20:	ed1c                	sd	a5,24(a0)
ffffffffc0202f22:	00d70663          	beq	a4,a3,ffffffffc0202f2e <default_init_memmap+0x9a>
ffffffffc0202f26:	8832                	mv	a6,a2
ffffffffc0202f28:	4585                	li	a1,1
ffffffffc0202f2a:	87ba                	mv	a5,a4
ffffffffc0202f2c:	bfc1                	j	ffffffffc0202efc <default_init_memmap+0x68>
ffffffffc0202f2e:	60a2                	ld	ra,8(sp)
ffffffffc0202f30:	e290                	sd	a2,0(a3)
ffffffffc0202f32:	0141                	addi	sp,sp,16
ffffffffc0202f34:	8082                	ret
ffffffffc0202f36:	60a2                	ld	ra,8(sp)
ffffffffc0202f38:	e390                	sd	a2,0(a5)
ffffffffc0202f3a:	e790                	sd	a2,8(a5)
ffffffffc0202f3c:	f11c                	sd	a5,32(a0)
ffffffffc0202f3e:	ed1c                	sd	a5,24(a0)
ffffffffc0202f40:	0141                	addi	sp,sp,16
ffffffffc0202f42:	8082                	ret
ffffffffc0202f44:	00003697          	auipc	a3,0x3
ffffffffc0202f48:	73468693          	addi	a3,a3,1844 # ffffffffc0206678 <commands+0x14a0>
ffffffffc0202f4c:	00003617          	auipc	a2,0x3
ffffffffc0202f50:	9b460613          	addi	a2,a2,-1612 # ffffffffc0205900 <commands+0x728>
ffffffffc0202f54:	04900593          	li	a1,73
ffffffffc0202f58:	00003517          	auipc	a0,0x3
ffffffffc0202f5c:	3e050513          	addi	a0,a0,992 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202f60:	a68fd0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0202f64:	00003697          	auipc	a3,0x3
ffffffffc0202f68:	6e468693          	addi	a3,a3,1764 # ffffffffc0206648 <commands+0x1470>
ffffffffc0202f6c:	00003617          	auipc	a2,0x3
ffffffffc0202f70:	99460613          	addi	a2,a2,-1644 # ffffffffc0205900 <commands+0x728>
ffffffffc0202f74:	04600593          	li	a1,70
ffffffffc0202f78:	00003517          	auipc	a0,0x3
ffffffffc0202f7c:	3c050513          	addi	a0,a0,960 # ffffffffc0206338 <commands+0x1160>
ffffffffc0202f80:	a48fd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202f84 <pa2page.part.0>:
ffffffffc0202f84:	1141                	addi	sp,sp,-16
ffffffffc0202f86:	00003617          	auipc	a2,0x3
ffffffffc0202f8a:	ba260613          	addi	a2,a2,-1118 # ffffffffc0205b28 <commands+0x950>
ffffffffc0202f8e:	06200593          	li	a1,98
ffffffffc0202f92:	00003517          	auipc	a0,0x3
ffffffffc0202f96:	bb650513          	addi	a0,a0,-1098 # ffffffffc0205b48 <commands+0x970>
ffffffffc0202f9a:	e406                	sd	ra,8(sp)
ffffffffc0202f9c:	a2cfd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202fa0 <pte2page.part.0>:
ffffffffc0202fa0:	1141                	addi	sp,sp,-16
ffffffffc0202fa2:	00003617          	auipc	a2,0x3
ffffffffc0202fa6:	1e660613          	addi	a2,a2,486 # ffffffffc0206188 <commands+0xfb0>
ffffffffc0202faa:	07400593          	li	a1,116
ffffffffc0202fae:	00003517          	auipc	a0,0x3
ffffffffc0202fb2:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0205b48 <commands+0x970>
ffffffffc0202fb6:	e406                	sd	ra,8(sp)
ffffffffc0202fb8:	a10fd0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0202fbc <alloc_pages>:
ffffffffc0202fbc:	7139                	addi	sp,sp,-64
ffffffffc0202fbe:	f426                	sd	s1,40(sp)
ffffffffc0202fc0:	f04a                	sd	s2,32(sp)
ffffffffc0202fc2:	ec4e                	sd	s3,24(sp)
ffffffffc0202fc4:	e852                	sd	s4,16(sp)
ffffffffc0202fc6:	e456                	sd	s5,8(sp)
ffffffffc0202fc8:	e05a                	sd	s6,0(sp)
ffffffffc0202fca:	fc06                	sd	ra,56(sp)
ffffffffc0202fcc:	f822                	sd	s0,48(sp)
ffffffffc0202fce:	84aa                	mv	s1,a0
ffffffffc0202fd0:	00013917          	auipc	s2,0x13
ffffffffc0202fd4:	5d090913          	addi	s2,s2,1488 # ffffffffc02165a0 <pmm_manager>
ffffffffc0202fd8:	4a05                	li	s4,1
ffffffffc0202fda:	00013a97          	auipc	s5,0x13
ffffffffc0202fde:	59ea8a93          	addi	s5,s5,1438 # ffffffffc0216578 <swap_init_ok>
ffffffffc0202fe2:	0005099b          	sext.w	s3,a0
ffffffffc0202fe6:	00013b17          	auipc	s6,0x13
ffffffffc0202fea:	56ab0b13          	addi	s6,s6,1386 # ffffffffc0216550 <check_mm_struct>
ffffffffc0202fee:	a01d                	j	ffffffffc0203014 <alloc_pages+0x58>
ffffffffc0202ff0:	00093783          	ld	a5,0(s2)
ffffffffc0202ff4:	6f9c                	ld	a5,24(a5)
ffffffffc0202ff6:	9782                	jalr	a5
ffffffffc0202ff8:	842a                	mv	s0,a0
ffffffffc0202ffa:	4601                	li	a2,0
ffffffffc0202ffc:	85ce                	mv	a1,s3
ffffffffc0202ffe:	ec0d                	bnez	s0,ffffffffc0203038 <alloc_pages+0x7c>
ffffffffc0203000:	029a6c63          	bltu	s4,s1,ffffffffc0203038 <alloc_pages+0x7c>
ffffffffc0203004:	000aa783          	lw	a5,0(s5)
ffffffffc0203008:	2781                	sext.w	a5,a5
ffffffffc020300a:	c79d                	beqz	a5,ffffffffc0203038 <alloc_pages+0x7c>
ffffffffc020300c:	000b3503          	ld	a0,0(s6)
ffffffffc0203010:	b42ff0ef          	jal	ra,ffffffffc0202352 <swap_out>
ffffffffc0203014:	100027f3          	csrr	a5,sstatus
ffffffffc0203018:	8b89                	andi	a5,a5,2
ffffffffc020301a:	8526                	mv	a0,s1
ffffffffc020301c:	dbf1                	beqz	a5,ffffffffc0202ff0 <alloc_pages+0x34>
ffffffffc020301e:	da6fd0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203022:	00093783          	ld	a5,0(s2)
ffffffffc0203026:	8526                	mv	a0,s1
ffffffffc0203028:	6f9c                	ld	a5,24(a5)
ffffffffc020302a:	9782                	jalr	a5
ffffffffc020302c:	842a                	mv	s0,a0
ffffffffc020302e:	d90fd0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203032:	4601                	li	a2,0
ffffffffc0203034:	85ce                	mv	a1,s3
ffffffffc0203036:	d469                	beqz	s0,ffffffffc0203000 <alloc_pages+0x44>
ffffffffc0203038:	70e2                	ld	ra,56(sp)
ffffffffc020303a:	8522                	mv	a0,s0
ffffffffc020303c:	7442                	ld	s0,48(sp)
ffffffffc020303e:	74a2                	ld	s1,40(sp)
ffffffffc0203040:	7902                	ld	s2,32(sp)
ffffffffc0203042:	69e2                	ld	s3,24(sp)
ffffffffc0203044:	6a42                	ld	s4,16(sp)
ffffffffc0203046:	6aa2                	ld	s5,8(sp)
ffffffffc0203048:	6b02                	ld	s6,0(sp)
ffffffffc020304a:	6121                	addi	sp,sp,64
ffffffffc020304c:	8082                	ret

ffffffffc020304e <free_pages>:
ffffffffc020304e:	100027f3          	csrr	a5,sstatus
ffffffffc0203052:	8b89                	andi	a5,a5,2
ffffffffc0203054:	e799                	bnez	a5,ffffffffc0203062 <free_pages+0x14>
ffffffffc0203056:	00013797          	auipc	a5,0x13
ffffffffc020305a:	54a7b783          	ld	a5,1354(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc020305e:	739c                	ld	a5,32(a5)
ffffffffc0203060:	8782                	jr	a5
ffffffffc0203062:	1101                	addi	sp,sp,-32
ffffffffc0203064:	ec06                	sd	ra,24(sp)
ffffffffc0203066:	e822                	sd	s0,16(sp)
ffffffffc0203068:	e426                	sd	s1,8(sp)
ffffffffc020306a:	842a                	mv	s0,a0
ffffffffc020306c:	84ae                	mv	s1,a1
ffffffffc020306e:	d56fd0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203072:	00013797          	auipc	a5,0x13
ffffffffc0203076:	52e7b783          	ld	a5,1326(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc020307a:	739c                	ld	a5,32(a5)
ffffffffc020307c:	85a6                	mv	a1,s1
ffffffffc020307e:	8522                	mv	a0,s0
ffffffffc0203080:	9782                	jalr	a5
ffffffffc0203082:	6442                	ld	s0,16(sp)
ffffffffc0203084:	60e2                	ld	ra,24(sp)
ffffffffc0203086:	64a2                	ld	s1,8(sp)
ffffffffc0203088:	6105                	addi	sp,sp,32
ffffffffc020308a:	d34fd06f          	j	ffffffffc02005be <intr_enable>

ffffffffc020308e <nr_free_pages>:
ffffffffc020308e:	100027f3          	csrr	a5,sstatus
ffffffffc0203092:	8b89                	andi	a5,a5,2
ffffffffc0203094:	e799                	bnez	a5,ffffffffc02030a2 <nr_free_pages+0x14>
ffffffffc0203096:	00013797          	auipc	a5,0x13
ffffffffc020309a:	50a7b783          	ld	a5,1290(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc020309e:	779c                	ld	a5,40(a5)
ffffffffc02030a0:	8782                	jr	a5
ffffffffc02030a2:	1141                	addi	sp,sp,-16
ffffffffc02030a4:	e406                	sd	ra,8(sp)
ffffffffc02030a6:	e022                	sd	s0,0(sp)
ffffffffc02030a8:	d1cfd0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02030ac:	00013797          	auipc	a5,0x13
ffffffffc02030b0:	4f47b783          	ld	a5,1268(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc02030b4:	779c                	ld	a5,40(a5)
ffffffffc02030b6:	9782                	jalr	a5
ffffffffc02030b8:	842a                	mv	s0,a0
ffffffffc02030ba:	d04fd0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc02030be:	60a2                	ld	ra,8(sp)
ffffffffc02030c0:	8522                	mv	a0,s0
ffffffffc02030c2:	6402                	ld	s0,0(sp)
ffffffffc02030c4:	0141                	addi	sp,sp,16
ffffffffc02030c6:	8082                	ret

ffffffffc02030c8 <get_pte>:
ffffffffc02030c8:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02030cc:	1ff7f793          	andi	a5,a5,511
ffffffffc02030d0:	7139                	addi	sp,sp,-64
ffffffffc02030d2:	078e                	slli	a5,a5,0x3
ffffffffc02030d4:	f426                	sd	s1,40(sp)
ffffffffc02030d6:	00f504b3          	add	s1,a0,a5
ffffffffc02030da:	6094                	ld	a3,0(s1)
ffffffffc02030dc:	f04a                	sd	s2,32(sp)
ffffffffc02030de:	ec4e                	sd	s3,24(sp)
ffffffffc02030e0:	e852                	sd	s4,16(sp)
ffffffffc02030e2:	fc06                	sd	ra,56(sp)
ffffffffc02030e4:	f822                	sd	s0,48(sp)
ffffffffc02030e6:	e456                	sd	s5,8(sp)
ffffffffc02030e8:	e05a                	sd	s6,0(sp)
ffffffffc02030ea:	0016f793          	andi	a5,a3,1
ffffffffc02030ee:	892e                	mv	s2,a1
ffffffffc02030f0:	89b2                	mv	s3,a2
ffffffffc02030f2:	00013a17          	auipc	s4,0x13
ffffffffc02030f6:	49ea0a13          	addi	s4,s4,1182 # ffffffffc0216590 <npage>
ffffffffc02030fa:	e7b5                	bnez	a5,ffffffffc0203166 <get_pte+0x9e>
ffffffffc02030fc:	12060b63          	beqz	a2,ffffffffc0203232 <get_pte+0x16a>
ffffffffc0203100:	4505                	li	a0,1
ffffffffc0203102:	ebbff0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0203106:	842a                	mv	s0,a0
ffffffffc0203108:	12050563          	beqz	a0,ffffffffc0203232 <get_pte+0x16a>
ffffffffc020310c:	00013b17          	auipc	s6,0x13
ffffffffc0203110:	48cb0b13          	addi	s6,s6,1164 # ffffffffc0216598 <pages>
ffffffffc0203114:	000b3503          	ld	a0,0(s6)
ffffffffc0203118:	00080ab7          	lui	s5,0x80
ffffffffc020311c:	00013a17          	auipc	s4,0x13
ffffffffc0203120:	474a0a13          	addi	s4,s4,1140 # ffffffffc0216590 <npage>
ffffffffc0203124:	40a40533          	sub	a0,s0,a0
ffffffffc0203128:	8519                	srai	a0,a0,0x6
ffffffffc020312a:	9556                	add	a0,a0,s5
ffffffffc020312c:	000a3703          	ld	a4,0(s4)
ffffffffc0203130:	00c51793          	slli	a5,a0,0xc
ffffffffc0203134:	4685                	li	a3,1
ffffffffc0203136:	c014                	sw	a3,0(s0)
ffffffffc0203138:	83b1                	srli	a5,a5,0xc
ffffffffc020313a:	0532                	slli	a0,a0,0xc
ffffffffc020313c:	14e7f263          	bgeu	a5,a4,ffffffffc0203280 <get_pte+0x1b8>
ffffffffc0203140:	00013797          	auipc	a5,0x13
ffffffffc0203144:	4687b783          	ld	a5,1128(a5) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0203148:	6605                	lui	a2,0x1
ffffffffc020314a:	4581                	li	a1,0
ffffffffc020314c:	953e                	add	a0,a0,a5
ffffffffc020314e:	1ab010ef          	jal	ra,ffffffffc0204af8 <memset>
ffffffffc0203152:	000b3683          	ld	a3,0(s6)
ffffffffc0203156:	40d406b3          	sub	a3,s0,a3
ffffffffc020315a:	8699                	srai	a3,a3,0x6
ffffffffc020315c:	96d6                	add	a3,a3,s5
ffffffffc020315e:	06aa                	slli	a3,a3,0xa
ffffffffc0203160:	0116e693          	ori	a3,a3,17
ffffffffc0203164:	e094                	sd	a3,0(s1)
ffffffffc0203166:	77fd                	lui	a5,0xfffff
ffffffffc0203168:	068a                	slli	a3,a3,0x2
ffffffffc020316a:	000a3703          	ld	a4,0(s4)
ffffffffc020316e:	8efd                	and	a3,a3,a5
ffffffffc0203170:	00c6d793          	srli	a5,a3,0xc
ffffffffc0203174:	0ce7f163          	bgeu	a5,a4,ffffffffc0203236 <get_pte+0x16e>
ffffffffc0203178:	00013a97          	auipc	s5,0x13
ffffffffc020317c:	430a8a93          	addi	s5,s5,1072 # ffffffffc02165a8 <va_pa_offset>
ffffffffc0203180:	000ab403          	ld	s0,0(s5)
ffffffffc0203184:	01595793          	srli	a5,s2,0x15
ffffffffc0203188:	1ff7f793          	andi	a5,a5,511
ffffffffc020318c:	96a2                	add	a3,a3,s0
ffffffffc020318e:	00379413          	slli	s0,a5,0x3
ffffffffc0203192:	9436                	add	s0,s0,a3
ffffffffc0203194:	6014                	ld	a3,0(s0)
ffffffffc0203196:	0016f793          	andi	a5,a3,1
ffffffffc020319a:	e3ad                	bnez	a5,ffffffffc02031fc <get_pte+0x134>
ffffffffc020319c:	08098b63          	beqz	s3,ffffffffc0203232 <get_pte+0x16a>
ffffffffc02031a0:	4505                	li	a0,1
ffffffffc02031a2:	e1bff0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02031a6:	84aa                	mv	s1,a0
ffffffffc02031a8:	c549                	beqz	a0,ffffffffc0203232 <get_pte+0x16a>
ffffffffc02031aa:	00013b17          	auipc	s6,0x13
ffffffffc02031ae:	3eeb0b13          	addi	s6,s6,1006 # ffffffffc0216598 <pages>
ffffffffc02031b2:	000b3503          	ld	a0,0(s6)
ffffffffc02031b6:	000809b7          	lui	s3,0x80
ffffffffc02031ba:	000a3703          	ld	a4,0(s4)
ffffffffc02031be:	40a48533          	sub	a0,s1,a0
ffffffffc02031c2:	8519                	srai	a0,a0,0x6
ffffffffc02031c4:	954e                	add	a0,a0,s3
ffffffffc02031c6:	00c51793          	slli	a5,a0,0xc
ffffffffc02031ca:	4685                	li	a3,1
ffffffffc02031cc:	c094                	sw	a3,0(s1)
ffffffffc02031ce:	83b1                	srli	a5,a5,0xc
ffffffffc02031d0:	0532                	slli	a0,a0,0xc
ffffffffc02031d2:	08e7fa63          	bgeu	a5,a4,ffffffffc0203266 <get_pte+0x19e>
ffffffffc02031d6:	000ab783          	ld	a5,0(s5)
ffffffffc02031da:	6605                	lui	a2,0x1
ffffffffc02031dc:	4581                	li	a1,0
ffffffffc02031de:	953e                	add	a0,a0,a5
ffffffffc02031e0:	119010ef          	jal	ra,ffffffffc0204af8 <memset>
ffffffffc02031e4:	000b3683          	ld	a3,0(s6)
ffffffffc02031e8:	40d486b3          	sub	a3,s1,a3
ffffffffc02031ec:	8699                	srai	a3,a3,0x6
ffffffffc02031ee:	96ce                	add	a3,a3,s3
ffffffffc02031f0:	06aa                	slli	a3,a3,0xa
ffffffffc02031f2:	0116e693          	ori	a3,a3,17
ffffffffc02031f6:	e014                	sd	a3,0(s0)
ffffffffc02031f8:	000a3703          	ld	a4,0(s4)
ffffffffc02031fc:	068a                	slli	a3,a3,0x2
ffffffffc02031fe:	757d                	lui	a0,0xfffff
ffffffffc0203200:	8ee9                	and	a3,a3,a0
ffffffffc0203202:	00c6d793          	srli	a5,a3,0xc
ffffffffc0203206:	04e7f463          	bgeu	a5,a4,ffffffffc020324e <get_pte+0x186>
ffffffffc020320a:	000ab503          	ld	a0,0(s5)
ffffffffc020320e:	00c95913          	srli	s2,s2,0xc
ffffffffc0203212:	1ff97913          	andi	s2,s2,511
ffffffffc0203216:	96aa                	add	a3,a3,a0
ffffffffc0203218:	00391513          	slli	a0,s2,0x3
ffffffffc020321c:	9536                	add	a0,a0,a3
ffffffffc020321e:	70e2                	ld	ra,56(sp)
ffffffffc0203220:	7442                	ld	s0,48(sp)
ffffffffc0203222:	74a2                	ld	s1,40(sp)
ffffffffc0203224:	7902                	ld	s2,32(sp)
ffffffffc0203226:	69e2                	ld	s3,24(sp)
ffffffffc0203228:	6a42                	ld	s4,16(sp)
ffffffffc020322a:	6aa2                	ld	s5,8(sp)
ffffffffc020322c:	6b02                	ld	s6,0(sp)
ffffffffc020322e:	6121                	addi	sp,sp,64
ffffffffc0203230:	8082                	ret
ffffffffc0203232:	4501                	li	a0,0
ffffffffc0203234:	b7ed                	j	ffffffffc020321e <get_pte+0x156>
ffffffffc0203236:	00003617          	auipc	a2,0x3
ffffffffc020323a:	92260613          	addi	a2,a2,-1758 # ffffffffc0205b58 <commands+0x980>
ffffffffc020323e:	0e400593          	li	a1,228
ffffffffc0203242:	00003517          	auipc	a0,0x3
ffffffffc0203246:	49650513          	addi	a0,a0,1174 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc020324a:	f7ffc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc020324e:	00003617          	auipc	a2,0x3
ffffffffc0203252:	90a60613          	addi	a2,a2,-1782 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203256:	0ef00593          	li	a1,239
ffffffffc020325a:	00003517          	auipc	a0,0x3
ffffffffc020325e:	47e50513          	addi	a0,a0,1150 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203262:	f67fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203266:	86aa                	mv	a3,a0
ffffffffc0203268:	00003617          	auipc	a2,0x3
ffffffffc020326c:	8f060613          	addi	a2,a2,-1808 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203270:	0ec00593          	li	a1,236
ffffffffc0203274:	00003517          	auipc	a0,0x3
ffffffffc0203278:	46450513          	addi	a0,a0,1124 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc020327c:	f4dfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203280:	86aa                	mv	a3,a0
ffffffffc0203282:	00003617          	auipc	a2,0x3
ffffffffc0203286:	8d660613          	addi	a2,a2,-1834 # ffffffffc0205b58 <commands+0x980>
ffffffffc020328a:	0e100593          	li	a1,225
ffffffffc020328e:	00003517          	auipc	a0,0x3
ffffffffc0203292:	44a50513          	addi	a0,a0,1098 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203296:	f33fc0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020329a <get_page>:
ffffffffc020329a:	1141                	addi	sp,sp,-16
ffffffffc020329c:	e022                	sd	s0,0(sp)
ffffffffc020329e:	8432                	mv	s0,a2
ffffffffc02032a0:	4601                	li	a2,0
ffffffffc02032a2:	e406                	sd	ra,8(sp)
ffffffffc02032a4:	e25ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02032a8:	c011                	beqz	s0,ffffffffc02032ac <get_page+0x12>
ffffffffc02032aa:	e008                	sd	a0,0(s0)
ffffffffc02032ac:	c511                	beqz	a0,ffffffffc02032b8 <get_page+0x1e>
ffffffffc02032ae:	611c                	ld	a5,0(a0)
ffffffffc02032b0:	4501                	li	a0,0
ffffffffc02032b2:	0017f713          	andi	a4,a5,1
ffffffffc02032b6:	e709                	bnez	a4,ffffffffc02032c0 <get_page+0x26>
ffffffffc02032b8:	60a2                	ld	ra,8(sp)
ffffffffc02032ba:	6402                	ld	s0,0(sp)
ffffffffc02032bc:	0141                	addi	sp,sp,16
ffffffffc02032be:	8082                	ret
ffffffffc02032c0:	078a                	slli	a5,a5,0x2
ffffffffc02032c2:	83b1                	srli	a5,a5,0xc
ffffffffc02032c4:	00013717          	auipc	a4,0x13
ffffffffc02032c8:	2cc73703          	ld	a4,716(a4) # ffffffffc0216590 <npage>
ffffffffc02032cc:	00e7ff63          	bgeu	a5,a4,ffffffffc02032ea <get_page+0x50>
ffffffffc02032d0:	60a2                	ld	ra,8(sp)
ffffffffc02032d2:	6402                	ld	s0,0(sp)
ffffffffc02032d4:	fff80537          	lui	a0,0xfff80
ffffffffc02032d8:	97aa                	add	a5,a5,a0
ffffffffc02032da:	079a                	slli	a5,a5,0x6
ffffffffc02032dc:	00013517          	auipc	a0,0x13
ffffffffc02032e0:	2bc53503          	ld	a0,700(a0) # ffffffffc0216598 <pages>
ffffffffc02032e4:	953e                	add	a0,a0,a5
ffffffffc02032e6:	0141                	addi	sp,sp,16
ffffffffc02032e8:	8082                	ret
ffffffffc02032ea:	c9bff0ef          	jal	ra,ffffffffc0202f84 <pa2page.part.0>

ffffffffc02032ee <page_remove>:
ffffffffc02032ee:	7179                	addi	sp,sp,-48
ffffffffc02032f0:	4601                	li	a2,0
ffffffffc02032f2:	ec26                	sd	s1,24(sp)
ffffffffc02032f4:	f406                	sd	ra,40(sp)
ffffffffc02032f6:	f022                	sd	s0,32(sp)
ffffffffc02032f8:	84ae                	mv	s1,a1
ffffffffc02032fa:	dcfff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02032fe:	c511                	beqz	a0,ffffffffc020330a <page_remove+0x1c>
ffffffffc0203300:	611c                	ld	a5,0(a0)
ffffffffc0203302:	842a                	mv	s0,a0
ffffffffc0203304:	0017f713          	andi	a4,a5,1
ffffffffc0203308:	e711                	bnez	a4,ffffffffc0203314 <page_remove+0x26>
ffffffffc020330a:	70a2                	ld	ra,40(sp)
ffffffffc020330c:	7402                	ld	s0,32(sp)
ffffffffc020330e:	64e2                	ld	s1,24(sp)
ffffffffc0203310:	6145                	addi	sp,sp,48
ffffffffc0203312:	8082                	ret
ffffffffc0203314:	078a                	slli	a5,a5,0x2
ffffffffc0203316:	83b1                	srli	a5,a5,0xc
ffffffffc0203318:	00013717          	auipc	a4,0x13
ffffffffc020331c:	27873703          	ld	a4,632(a4) # ffffffffc0216590 <npage>
ffffffffc0203320:	06e7f363          	bgeu	a5,a4,ffffffffc0203386 <page_remove+0x98>
ffffffffc0203324:	fff80537          	lui	a0,0xfff80
ffffffffc0203328:	97aa                	add	a5,a5,a0
ffffffffc020332a:	079a                	slli	a5,a5,0x6
ffffffffc020332c:	00013517          	auipc	a0,0x13
ffffffffc0203330:	26c53503          	ld	a0,620(a0) # ffffffffc0216598 <pages>
ffffffffc0203334:	953e                	add	a0,a0,a5
ffffffffc0203336:	411c                	lw	a5,0(a0)
ffffffffc0203338:	fff7871b          	addiw	a4,a5,-1
ffffffffc020333c:	c118                	sw	a4,0(a0)
ffffffffc020333e:	cb11                	beqz	a4,ffffffffc0203352 <page_remove+0x64>
ffffffffc0203340:	00043023          	sd	zero,0(s0)
ffffffffc0203344:	12048073          	sfence.vma	s1
ffffffffc0203348:	70a2                	ld	ra,40(sp)
ffffffffc020334a:	7402                	ld	s0,32(sp)
ffffffffc020334c:	64e2                	ld	s1,24(sp)
ffffffffc020334e:	6145                	addi	sp,sp,48
ffffffffc0203350:	8082                	ret
ffffffffc0203352:	100027f3          	csrr	a5,sstatus
ffffffffc0203356:	8b89                	andi	a5,a5,2
ffffffffc0203358:	eb89                	bnez	a5,ffffffffc020336a <page_remove+0x7c>
ffffffffc020335a:	00013797          	auipc	a5,0x13
ffffffffc020335e:	2467b783          	ld	a5,582(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc0203362:	739c                	ld	a5,32(a5)
ffffffffc0203364:	4585                	li	a1,1
ffffffffc0203366:	9782                	jalr	a5
ffffffffc0203368:	bfe1                	j	ffffffffc0203340 <page_remove+0x52>
ffffffffc020336a:	e42a                	sd	a0,8(sp)
ffffffffc020336c:	a58fd0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203370:	00013797          	auipc	a5,0x13
ffffffffc0203374:	2307b783          	ld	a5,560(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc0203378:	739c                	ld	a5,32(a5)
ffffffffc020337a:	6522                	ld	a0,8(sp)
ffffffffc020337c:	4585                	li	a1,1
ffffffffc020337e:	9782                	jalr	a5
ffffffffc0203380:	a3efd0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203384:	bf75                	j	ffffffffc0203340 <page_remove+0x52>
ffffffffc0203386:	bffff0ef          	jal	ra,ffffffffc0202f84 <pa2page.part.0>

ffffffffc020338a <page_insert>:
ffffffffc020338a:	7139                	addi	sp,sp,-64
ffffffffc020338c:	e852                	sd	s4,16(sp)
ffffffffc020338e:	8a32                	mv	s4,a2
ffffffffc0203390:	f822                	sd	s0,48(sp)
ffffffffc0203392:	4605                	li	a2,1
ffffffffc0203394:	842e                	mv	s0,a1
ffffffffc0203396:	85d2                	mv	a1,s4
ffffffffc0203398:	f426                	sd	s1,40(sp)
ffffffffc020339a:	fc06                	sd	ra,56(sp)
ffffffffc020339c:	f04a                	sd	s2,32(sp)
ffffffffc020339e:	ec4e                	sd	s3,24(sp)
ffffffffc02033a0:	e456                	sd	s5,8(sp)
ffffffffc02033a2:	84b6                	mv	s1,a3
ffffffffc02033a4:	d25ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02033a8:	c961                	beqz	a0,ffffffffc0203478 <page_insert+0xee>
ffffffffc02033aa:	4014                	lw	a3,0(s0)
ffffffffc02033ac:	611c                	ld	a5,0(a0)
ffffffffc02033ae:	89aa                	mv	s3,a0
ffffffffc02033b0:	0016871b          	addiw	a4,a3,1
ffffffffc02033b4:	c018                	sw	a4,0(s0)
ffffffffc02033b6:	0017f713          	andi	a4,a5,1
ffffffffc02033ba:	ef05                	bnez	a4,ffffffffc02033f2 <page_insert+0x68>
ffffffffc02033bc:	00013717          	auipc	a4,0x13
ffffffffc02033c0:	1dc73703          	ld	a4,476(a4) # ffffffffc0216598 <pages>
ffffffffc02033c4:	8c19                	sub	s0,s0,a4
ffffffffc02033c6:	000807b7          	lui	a5,0x80
ffffffffc02033ca:	8419                	srai	s0,s0,0x6
ffffffffc02033cc:	943e                	add	s0,s0,a5
ffffffffc02033ce:	042a                	slli	s0,s0,0xa
ffffffffc02033d0:	8cc1                	or	s1,s1,s0
ffffffffc02033d2:	0014e493          	ori	s1,s1,1
ffffffffc02033d6:	0099b023          	sd	s1,0(s3) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc02033da:	120a0073          	sfence.vma	s4
ffffffffc02033de:	4501                	li	a0,0
ffffffffc02033e0:	70e2                	ld	ra,56(sp)
ffffffffc02033e2:	7442                	ld	s0,48(sp)
ffffffffc02033e4:	74a2                	ld	s1,40(sp)
ffffffffc02033e6:	7902                	ld	s2,32(sp)
ffffffffc02033e8:	69e2                	ld	s3,24(sp)
ffffffffc02033ea:	6a42                	ld	s4,16(sp)
ffffffffc02033ec:	6aa2                	ld	s5,8(sp)
ffffffffc02033ee:	6121                	addi	sp,sp,64
ffffffffc02033f0:	8082                	ret
ffffffffc02033f2:	078a                	slli	a5,a5,0x2
ffffffffc02033f4:	83b1                	srli	a5,a5,0xc
ffffffffc02033f6:	00013717          	auipc	a4,0x13
ffffffffc02033fa:	19a73703          	ld	a4,410(a4) # ffffffffc0216590 <npage>
ffffffffc02033fe:	06e7ff63          	bgeu	a5,a4,ffffffffc020347c <page_insert+0xf2>
ffffffffc0203402:	00013a97          	auipc	s5,0x13
ffffffffc0203406:	196a8a93          	addi	s5,s5,406 # ffffffffc0216598 <pages>
ffffffffc020340a:	000ab703          	ld	a4,0(s5)
ffffffffc020340e:	fff80937          	lui	s2,0xfff80
ffffffffc0203412:	993e                	add	s2,s2,a5
ffffffffc0203414:	091a                	slli	s2,s2,0x6
ffffffffc0203416:	993a                	add	s2,s2,a4
ffffffffc0203418:	01240c63          	beq	s0,s2,ffffffffc0203430 <page_insert+0xa6>
ffffffffc020341c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd69a34>
ffffffffc0203420:	fff7869b          	addiw	a3,a5,-1
ffffffffc0203424:	00d92023          	sw	a3,0(s2)
ffffffffc0203428:	c691                	beqz	a3,ffffffffc0203434 <page_insert+0xaa>
ffffffffc020342a:	120a0073          	sfence.vma	s4
ffffffffc020342e:	bf59                	j	ffffffffc02033c4 <page_insert+0x3a>
ffffffffc0203430:	c014                	sw	a3,0(s0)
ffffffffc0203432:	bf49                	j	ffffffffc02033c4 <page_insert+0x3a>
ffffffffc0203434:	100027f3          	csrr	a5,sstatus
ffffffffc0203438:	8b89                	andi	a5,a5,2
ffffffffc020343a:	ef91                	bnez	a5,ffffffffc0203456 <page_insert+0xcc>
ffffffffc020343c:	00013797          	auipc	a5,0x13
ffffffffc0203440:	1647b783          	ld	a5,356(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc0203444:	739c                	ld	a5,32(a5)
ffffffffc0203446:	4585                	li	a1,1
ffffffffc0203448:	854a                	mv	a0,s2
ffffffffc020344a:	9782                	jalr	a5
ffffffffc020344c:	000ab703          	ld	a4,0(s5)
ffffffffc0203450:	120a0073          	sfence.vma	s4
ffffffffc0203454:	bf85                	j	ffffffffc02033c4 <page_insert+0x3a>
ffffffffc0203456:	96efd0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc020345a:	00013797          	auipc	a5,0x13
ffffffffc020345e:	1467b783          	ld	a5,326(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc0203462:	739c                	ld	a5,32(a5)
ffffffffc0203464:	4585                	li	a1,1
ffffffffc0203466:	854a                	mv	a0,s2
ffffffffc0203468:	9782                	jalr	a5
ffffffffc020346a:	954fd0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc020346e:	000ab703          	ld	a4,0(s5)
ffffffffc0203472:	120a0073          	sfence.vma	s4
ffffffffc0203476:	b7b9                	j	ffffffffc02033c4 <page_insert+0x3a>
ffffffffc0203478:	5571                	li	a0,-4
ffffffffc020347a:	b79d                	j	ffffffffc02033e0 <page_insert+0x56>
ffffffffc020347c:	b09ff0ef          	jal	ra,ffffffffc0202f84 <pa2page.part.0>

ffffffffc0203480 <pmm_init>:
ffffffffc0203480:	00003797          	auipc	a5,0x3
ffffffffc0203484:	22078793          	addi	a5,a5,544 # ffffffffc02066a0 <default_pmm_manager>
ffffffffc0203488:	638c                	ld	a1,0(a5)
ffffffffc020348a:	711d                	addi	sp,sp,-96
ffffffffc020348c:	ec5e                	sd	s7,24(sp)
ffffffffc020348e:	00003517          	auipc	a0,0x3
ffffffffc0203492:	25a50513          	addi	a0,a0,602 # ffffffffc02066e8 <default_pmm_manager+0x48>
ffffffffc0203496:	00013b97          	auipc	s7,0x13
ffffffffc020349a:	10ab8b93          	addi	s7,s7,266 # ffffffffc02165a0 <pmm_manager>
ffffffffc020349e:	ec86                	sd	ra,88(sp)
ffffffffc02034a0:	e4a6                	sd	s1,72(sp)
ffffffffc02034a2:	fc4e                	sd	s3,56(sp)
ffffffffc02034a4:	f05a                	sd	s6,32(sp)
ffffffffc02034a6:	00fbb023          	sd	a5,0(s7)
ffffffffc02034aa:	e8a2                	sd	s0,80(sp)
ffffffffc02034ac:	e0ca                	sd	s2,64(sp)
ffffffffc02034ae:	f852                	sd	s4,48(sp)
ffffffffc02034b0:	f456                	sd	s5,40(sp)
ffffffffc02034b2:	e862                	sd	s8,16(sp)
ffffffffc02034b4:	c19fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02034b8:	000bb783          	ld	a5,0(s7)
ffffffffc02034bc:	00013997          	auipc	s3,0x13
ffffffffc02034c0:	0ec98993          	addi	s3,s3,236 # ffffffffc02165a8 <va_pa_offset>
ffffffffc02034c4:	00013497          	auipc	s1,0x13
ffffffffc02034c8:	0cc48493          	addi	s1,s1,204 # ffffffffc0216590 <npage>
ffffffffc02034cc:	679c                	ld	a5,8(a5)
ffffffffc02034ce:	00013b17          	auipc	s6,0x13
ffffffffc02034d2:	0cab0b13          	addi	s6,s6,202 # ffffffffc0216598 <pages>
ffffffffc02034d6:	9782                	jalr	a5
ffffffffc02034d8:	57f5                	li	a5,-3
ffffffffc02034da:	07fa                	slli	a5,a5,0x1e
ffffffffc02034dc:	00003517          	auipc	a0,0x3
ffffffffc02034e0:	22450513          	addi	a0,a0,548 # ffffffffc0206700 <default_pmm_manager+0x60>
ffffffffc02034e4:	00f9b023          	sd	a5,0(s3)
ffffffffc02034e8:	be5fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02034ec:	46c5                	li	a3,17
ffffffffc02034ee:	06ee                	slli	a3,a3,0x1b
ffffffffc02034f0:	40100613          	li	a2,1025
ffffffffc02034f4:	07e005b7          	lui	a1,0x7e00
ffffffffc02034f8:	16fd                	addi	a3,a3,-1
ffffffffc02034fa:	0656                	slli	a2,a2,0x15
ffffffffc02034fc:	00003517          	auipc	a0,0x3
ffffffffc0203500:	21c50513          	addi	a0,a0,540 # ffffffffc0206718 <default_pmm_manager+0x78>
ffffffffc0203504:	bc9fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0203508:	777d                	lui	a4,0xfffff
ffffffffc020350a:	00014797          	auipc	a5,0x14
ffffffffc020350e:	0c178793          	addi	a5,a5,193 # ffffffffc02175cb <end+0xfff>
ffffffffc0203512:	8ff9                	and	a5,a5,a4
ffffffffc0203514:	00088737          	lui	a4,0x88
ffffffffc0203518:	e098                	sd	a4,0(s1)
ffffffffc020351a:	00fb3023          	sd	a5,0(s6)
ffffffffc020351e:	4701                	li	a4,0
ffffffffc0203520:	4585                	li	a1,1
ffffffffc0203522:	fff80837          	lui	a6,0xfff80
ffffffffc0203526:	a019                	j	ffffffffc020352c <pmm_init+0xac>
ffffffffc0203528:	000b3783          	ld	a5,0(s6)
ffffffffc020352c:	00671693          	slli	a3,a4,0x6
ffffffffc0203530:	97b6                	add	a5,a5,a3
ffffffffc0203532:	07a1                	addi	a5,a5,8
ffffffffc0203534:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0203538:	6090                	ld	a2,0(s1)
ffffffffc020353a:	0705                	addi	a4,a4,1
ffffffffc020353c:	010607b3          	add	a5,a2,a6
ffffffffc0203540:	fef764e3          	bltu	a4,a5,ffffffffc0203528 <pmm_init+0xa8>
ffffffffc0203544:	000b3503          	ld	a0,0(s6)
ffffffffc0203548:	079a                	slli	a5,a5,0x6
ffffffffc020354a:	c0200737          	lui	a4,0xc0200
ffffffffc020354e:	00f506b3          	add	a3,a0,a5
ffffffffc0203552:	60e6e563          	bltu	a3,a4,ffffffffc0203b5c <pmm_init+0x6dc>
ffffffffc0203556:	0009b583          	ld	a1,0(s3)
ffffffffc020355a:	4745                	li	a4,17
ffffffffc020355c:	076e                	slli	a4,a4,0x1b
ffffffffc020355e:	8e8d                	sub	a3,a3,a1
ffffffffc0203560:	4ae6e563          	bltu	a3,a4,ffffffffc0203a0a <pmm_init+0x58a>
ffffffffc0203564:	00003517          	auipc	a0,0x3
ffffffffc0203568:	1dc50513          	addi	a0,a0,476 # ffffffffc0206740 <default_pmm_manager+0xa0>
ffffffffc020356c:	b61fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc0203570:	000bb783          	ld	a5,0(s7)
ffffffffc0203574:	00013917          	auipc	s2,0x13
ffffffffc0203578:	01490913          	addi	s2,s2,20 # ffffffffc0216588 <boot_pgdir>
ffffffffc020357c:	7b9c                	ld	a5,48(a5)
ffffffffc020357e:	9782                	jalr	a5
ffffffffc0203580:	00003517          	auipc	a0,0x3
ffffffffc0203584:	1d850513          	addi	a0,a0,472 # ffffffffc0206758 <default_pmm_manager+0xb8>
ffffffffc0203588:	b45fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020358c:	00007697          	auipc	a3,0x7
ffffffffc0203590:	a7468693          	addi	a3,a3,-1420 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0203594:	00d93023          	sd	a3,0(s2)
ffffffffc0203598:	c02007b7          	lui	a5,0xc0200
ffffffffc020359c:	5cf6ec63          	bltu	a3,a5,ffffffffc0203b74 <pmm_init+0x6f4>
ffffffffc02035a0:	0009b783          	ld	a5,0(s3)
ffffffffc02035a4:	8e9d                	sub	a3,a3,a5
ffffffffc02035a6:	00013797          	auipc	a5,0x13
ffffffffc02035aa:	fcd7bd23          	sd	a3,-38(a5) # ffffffffc0216580 <boot_cr3>
ffffffffc02035ae:	100027f3          	csrr	a5,sstatus
ffffffffc02035b2:	8b89                	andi	a5,a5,2
ffffffffc02035b4:	48079263          	bnez	a5,ffffffffc0203a38 <pmm_init+0x5b8>
ffffffffc02035b8:	000bb783          	ld	a5,0(s7)
ffffffffc02035bc:	779c                	ld	a5,40(a5)
ffffffffc02035be:	9782                	jalr	a5
ffffffffc02035c0:	842a                	mv	s0,a0
ffffffffc02035c2:	6098                	ld	a4,0(s1)
ffffffffc02035c4:	c80007b7          	lui	a5,0xc8000
ffffffffc02035c8:	83b1                	srli	a5,a5,0xc
ffffffffc02035ca:	5ee7e163          	bltu	a5,a4,ffffffffc0203bac <pmm_init+0x72c>
ffffffffc02035ce:	00093503          	ld	a0,0(s2)
ffffffffc02035d2:	5a050d63          	beqz	a0,ffffffffc0203b8c <pmm_init+0x70c>
ffffffffc02035d6:	03451793          	slli	a5,a0,0x34
ffffffffc02035da:	5a079963          	bnez	a5,ffffffffc0203b8c <pmm_init+0x70c>
ffffffffc02035de:	4601                	li	a2,0
ffffffffc02035e0:	4581                	li	a1,0
ffffffffc02035e2:	cb9ff0ef          	jal	ra,ffffffffc020329a <get_page>
ffffffffc02035e6:	62051563          	bnez	a0,ffffffffc0203c10 <pmm_init+0x790>
ffffffffc02035ea:	4505                	li	a0,1
ffffffffc02035ec:	9d1ff0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc02035f0:	8a2a                	mv	s4,a0
ffffffffc02035f2:	00093503          	ld	a0,0(s2)
ffffffffc02035f6:	4681                	li	a3,0
ffffffffc02035f8:	4601                	li	a2,0
ffffffffc02035fa:	85d2                	mv	a1,s4
ffffffffc02035fc:	d8fff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc0203600:	5e051863          	bnez	a0,ffffffffc0203bf0 <pmm_init+0x770>
ffffffffc0203604:	00093503          	ld	a0,0(s2)
ffffffffc0203608:	4601                	li	a2,0
ffffffffc020360a:	4581                	li	a1,0
ffffffffc020360c:	abdff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc0203610:	5c050063          	beqz	a0,ffffffffc0203bd0 <pmm_init+0x750>
ffffffffc0203614:	611c                	ld	a5,0(a0)
ffffffffc0203616:	0017f713          	andi	a4,a5,1
ffffffffc020361a:	5a070963          	beqz	a4,ffffffffc0203bcc <pmm_init+0x74c>
ffffffffc020361e:	6098                	ld	a4,0(s1)
ffffffffc0203620:	078a                	slli	a5,a5,0x2
ffffffffc0203622:	83b1                	srli	a5,a5,0xc
ffffffffc0203624:	52e7fa63          	bgeu	a5,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc0203628:	000b3683          	ld	a3,0(s6)
ffffffffc020362c:	fff80637          	lui	a2,0xfff80
ffffffffc0203630:	97b2                	add	a5,a5,a2
ffffffffc0203632:	079a                	slli	a5,a5,0x6
ffffffffc0203634:	97b6                	add	a5,a5,a3
ffffffffc0203636:	10fa16e3          	bne	s4,a5,ffffffffc0203f42 <pmm_init+0xac2>
ffffffffc020363a:	000a2683          	lw	a3,0(s4)
ffffffffc020363e:	4785                	li	a5,1
ffffffffc0203640:	12f69de3          	bne	a3,a5,ffffffffc0203f7a <pmm_init+0xafa>
ffffffffc0203644:	00093503          	ld	a0,0(s2)
ffffffffc0203648:	77fd                	lui	a5,0xfffff
ffffffffc020364a:	6114                	ld	a3,0(a0)
ffffffffc020364c:	068a                	slli	a3,a3,0x2
ffffffffc020364e:	8efd                	and	a3,a3,a5
ffffffffc0203650:	00c6d613          	srli	a2,a3,0xc
ffffffffc0203654:	10e677e3          	bgeu	a2,a4,ffffffffc0203f62 <pmm_init+0xae2>
ffffffffc0203658:	0009bc03          	ld	s8,0(s3)
ffffffffc020365c:	96e2                	add	a3,a3,s8
ffffffffc020365e:	0006ba83          	ld	s5,0(a3)
ffffffffc0203662:	0a8a                	slli	s5,s5,0x2
ffffffffc0203664:	00fafab3          	and	s5,s5,a5
ffffffffc0203668:	00cad793          	srli	a5,s5,0xc
ffffffffc020366c:	62e7f263          	bgeu	a5,a4,ffffffffc0203c90 <pmm_init+0x810>
ffffffffc0203670:	4601                	li	a2,0
ffffffffc0203672:	6585                	lui	a1,0x1
ffffffffc0203674:	9ae2                	add	s5,s5,s8
ffffffffc0203676:	a53ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc020367a:	0aa1                	addi	s5,s5,8
ffffffffc020367c:	5f551a63          	bne	a0,s5,ffffffffc0203c70 <pmm_init+0x7f0>
ffffffffc0203680:	4505                	li	a0,1
ffffffffc0203682:	93bff0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0203686:	8aaa                	mv	s5,a0
ffffffffc0203688:	00093503          	ld	a0,0(s2)
ffffffffc020368c:	46d1                	li	a3,20
ffffffffc020368e:	6605                	lui	a2,0x1
ffffffffc0203690:	85d6                	mv	a1,s5
ffffffffc0203692:	cf9ff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc0203696:	58051d63          	bnez	a0,ffffffffc0203c30 <pmm_init+0x7b0>
ffffffffc020369a:	00093503          	ld	a0,0(s2)
ffffffffc020369e:	4601                	li	a2,0
ffffffffc02036a0:	6585                	lui	a1,0x1
ffffffffc02036a2:	a27ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02036a6:	0e050ae3          	beqz	a0,ffffffffc0203f9a <pmm_init+0xb1a>
ffffffffc02036aa:	611c                	ld	a5,0(a0)
ffffffffc02036ac:	0107f713          	andi	a4,a5,16
ffffffffc02036b0:	6e070d63          	beqz	a4,ffffffffc0203daa <pmm_init+0x92a>
ffffffffc02036b4:	8b91                	andi	a5,a5,4
ffffffffc02036b6:	6a078a63          	beqz	a5,ffffffffc0203d6a <pmm_init+0x8ea>
ffffffffc02036ba:	00093503          	ld	a0,0(s2)
ffffffffc02036be:	611c                	ld	a5,0(a0)
ffffffffc02036c0:	8bc1                	andi	a5,a5,16
ffffffffc02036c2:	68078463          	beqz	a5,ffffffffc0203d4a <pmm_init+0x8ca>
ffffffffc02036c6:	000aa703          	lw	a4,0(s5)
ffffffffc02036ca:	4785                	li	a5,1
ffffffffc02036cc:	58f71263          	bne	a4,a5,ffffffffc0203c50 <pmm_init+0x7d0>
ffffffffc02036d0:	4681                	li	a3,0
ffffffffc02036d2:	6605                	lui	a2,0x1
ffffffffc02036d4:	85d2                	mv	a1,s4
ffffffffc02036d6:	cb5ff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc02036da:	62051863          	bnez	a0,ffffffffc0203d0a <pmm_init+0x88a>
ffffffffc02036de:	000a2703          	lw	a4,0(s4)
ffffffffc02036e2:	4789                	li	a5,2
ffffffffc02036e4:	60f71363          	bne	a4,a5,ffffffffc0203cea <pmm_init+0x86a>
ffffffffc02036e8:	000aa783          	lw	a5,0(s5)
ffffffffc02036ec:	5c079f63          	bnez	a5,ffffffffc0203cca <pmm_init+0x84a>
ffffffffc02036f0:	00093503          	ld	a0,0(s2)
ffffffffc02036f4:	4601                	li	a2,0
ffffffffc02036f6:	6585                	lui	a1,0x1
ffffffffc02036f8:	9d1ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc02036fc:	5a050763          	beqz	a0,ffffffffc0203caa <pmm_init+0x82a>
ffffffffc0203700:	6118                	ld	a4,0(a0)
ffffffffc0203702:	00177793          	andi	a5,a4,1
ffffffffc0203706:	4c078363          	beqz	a5,ffffffffc0203bcc <pmm_init+0x74c>
ffffffffc020370a:	6094                	ld	a3,0(s1)
ffffffffc020370c:	00271793          	slli	a5,a4,0x2
ffffffffc0203710:	83b1                	srli	a5,a5,0xc
ffffffffc0203712:	44d7f363          	bgeu	a5,a3,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc0203716:	000b3683          	ld	a3,0(s6)
ffffffffc020371a:	fff80637          	lui	a2,0xfff80
ffffffffc020371e:	97b2                	add	a5,a5,a2
ffffffffc0203720:	079a                	slli	a5,a5,0x6
ffffffffc0203722:	97b6                	add	a5,a5,a3
ffffffffc0203724:	6efa1363          	bne	s4,a5,ffffffffc0203e0a <pmm_init+0x98a>
ffffffffc0203728:	8b41                	andi	a4,a4,16
ffffffffc020372a:	6c071063          	bnez	a4,ffffffffc0203dea <pmm_init+0x96a>
ffffffffc020372e:	00093503          	ld	a0,0(s2)
ffffffffc0203732:	4581                	li	a1,0
ffffffffc0203734:	bbbff0ef          	jal	ra,ffffffffc02032ee <page_remove>
ffffffffc0203738:	000a2703          	lw	a4,0(s4)
ffffffffc020373c:	4785                	li	a5,1
ffffffffc020373e:	68f71663          	bne	a4,a5,ffffffffc0203dca <pmm_init+0x94a>
ffffffffc0203742:	000aa783          	lw	a5,0(s5)
ffffffffc0203746:	74079e63          	bnez	a5,ffffffffc0203ea2 <pmm_init+0xa22>
ffffffffc020374a:	00093503          	ld	a0,0(s2)
ffffffffc020374e:	6585                	lui	a1,0x1
ffffffffc0203750:	b9fff0ef          	jal	ra,ffffffffc02032ee <page_remove>
ffffffffc0203754:	000a2783          	lw	a5,0(s4)
ffffffffc0203758:	72079563          	bnez	a5,ffffffffc0203e82 <pmm_init+0xa02>
ffffffffc020375c:	000aa783          	lw	a5,0(s5)
ffffffffc0203760:	70079163          	bnez	a5,ffffffffc0203e62 <pmm_init+0x9e2>
ffffffffc0203764:	00093a03          	ld	s4,0(s2)
ffffffffc0203768:	6098                	ld	a4,0(s1)
ffffffffc020376a:	000a3683          	ld	a3,0(s4)
ffffffffc020376e:	068a                	slli	a3,a3,0x2
ffffffffc0203770:	82b1                	srli	a3,a3,0xc
ffffffffc0203772:	3ee6f363          	bgeu	a3,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc0203776:	fff807b7          	lui	a5,0xfff80
ffffffffc020377a:	000b3503          	ld	a0,0(s6)
ffffffffc020377e:	96be                	add	a3,a3,a5
ffffffffc0203780:	069a                	slli	a3,a3,0x6
ffffffffc0203782:	00d507b3          	add	a5,a0,a3
ffffffffc0203786:	4390                	lw	a2,0(a5)
ffffffffc0203788:	4785                	li	a5,1
ffffffffc020378a:	6af61c63          	bne	a2,a5,ffffffffc0203e42 <pmm_init+0x9c2>
ffffffffc020378e:	8699                	srai	a3,a3,0x6
ffffffffc0203790:	000805b7          	lui	a1,0x80
ffffffffc0203794:	96ae                	add	a3,a3,a1
ffffffffc0203796:	00c69613          	slli	a2,a3,0xc
ffffffffc020379a:	8231                	srli	a2,a2,0xc
ffffffffc020379c:	06b2                	slli	a3,a3,0xc
ffffffffc020379e:	68e67663          	bgeu	a2,a4,ffffffffc0203e2a <pmm_init+0x9aa>
ffffffffc02037a2:	0009b603          	ld	a2,0(s3)
ffffffffc02037a6:	96b2                	add	a3,a3,a2
ffffffffc02037a8:	629c                	ld	a5,0(a3)
ffffffffc02037aa:	078a                	slli	a5,a5,0x2
ffffffffc02037ac:	83b1                	srli	a5,a5,0xc
ffffffffc02037ae:	3ae7f563          	bgeu	a5,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc02037b2:	8f8d                	sub	a5,a5,a1
ffffffffc02037b4:	079a                	slli	a5,a5,0x6
ffffffffc02037b6:	953e                	add	a0,a0,a5
ffffffffc02037b8:	100027f3          	csrr	a5,sstatus
ffffffffc02037bc:	8b89                	andi	a5,a5,2
ffffffffc02037be:	2c079763          	bnez	a5,ffffffffc0203a8c <pmm_init+0x60c>
ffffffffc02037c2:	000bb783          	ld	a5,0(s7)
ffffffffc02037c6:	4585                	li	a1,1
ffffffffc02037c8:	739c                	ld	a5,32(a5)
ffffffffc02037ca:	9782                	jalr	a5
ffffffffc02037cc:	000a3783          	ld	a5,0(s4)
ffffffffc02037d0:	6098                	ld	a4,0(s1)
ffffffffc02037d2:	078a                	slli	a5,a5,0x2
ffffffffc02037d4:	83b1                	srli	a5,a5,0xc
ffffffffc02037d6:	38e7f163          	bgeu	a5,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc02037da:	000b3503          	ld	a0,0(s6)
ffffffffc02037de:	fff80737          	lui	a4,0xfff80
ffffffffc02037e2:	97ba                	add	a5,a5,a4
ffffffffc02037e4:	079a                	slli	a5,a5,0x6
ffffffffc02037e6:	953e                	add	a0,a0,a5
ffffffffc02037e8:	100027f3          	csrr	a5,sstatus
ffffffffc02037ec:	8b89                	andi	a5,a5,2
ffffffffc02037ee:	28079363          	bnez	a5,ffffffffc0203a74 <pmm_init+0x5f4>
ffffffffc02037f2:	000bb783          	ld	a5,0(s7)
ffffffffc02037f6:	4585                	li	a1,1
ffffffffc02037f8:	739c                	ld	a5,32(a5)
ffffffffc02037fa:	9782                	jalr	a5
ffffffffc02037fc:	00093783          	ld	a5,0(s2)
ffffffffc0203800:	0007b023          	sd	zero,0(a5) # fffffffffff80000 <end+0x3fd69a34>
ffffffffc0203804:	12000073          	sfence.vma
ffffffffc0203808:	100027f3          	csrr	a5,sstatus
ffffffffc020380c:	8b89                	andi	a5,a5,2
ffffffffc020380e:	24079963          	bnez	a5,ffffffffc0203a60 <pmm_init+0x5e0>
ffffffffc0203812:	000bb783          	ld	a5,0(s7)
ffffffffc0203816:	779c                	ld	a5,40(a5)
ffffffffc0203818:	9782                	jalr	a5
ffffffffc020381a:	8a2a                	mv	s4,a0
ffffffffc020381c:	71441363          	bne	s0,s4,ffffffffc0203f22 <pmm_init+0xaa2>
ffffffffc0203820:	00003517          	auipc	a0,0x3
ffffffffc0203824:	22050513          	addi	a0,a0,544 # ffffffffc0206a40 <default_pmm_manager+0x3a0>
ffffffffc0203828:	8a5fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc020382c:	100027f3          	csrr	a5,sstatus
ffffffffc0203830:	8b89                	andi	a5,a5,2
ffffffffc0203832:	20079d63          	bnez	a5,ffffffffc0203a4c <pmm_init+0x5cc>
ffffffffc0203836:	000bb783          	ld	a5,0(s7)
ffffffffc020383a:	779c                	ld	a5,40(a5)
ffffffffc020383c:	9782                	jalr	a5
ffffffffc020383e:	8c2a                	mv	s8,a0
ffffffffc0203840:	6098                	ld	a4,0(s1)
ffffffffc0203842:	c0200437          	lui	s0,0xc0200
ffffffffc0203846:	7afd                	lui	s5,0xfffff
ffffffffc0203848:	00c71793          	slli	a5,a4,0xc
ffffffffc020384c:	6a05                	lui	s4,0x1
ffffffffc020384e:	02f47c63          	bgeu	s0,a5,ffffffffc0203886 <pmm_init+0x406>
ffffffffc0203852:	00c45793          	srli	a5,s0,0xc
ffffffffc0203856:	00093503          	ld	a0,0(s2)
ffffffffc020385a:	2ee7f263          	bgeu	a5,a4,ffffffffc0203b3e <pmm_init+0x6be>
ffffffffc020385e:	0009b583          	ld	a1,0(s3)
ffffffffc0203862:	4601                	li	a2,0
ffffffffc0203864:	95a2                	add	a1,a1,s0
ffffffffc0203866:	863ff0ef          	jal	ra,ffffffffc02030c8 <get_pte>
ffffffffc020386a:	2a050a63          	beqz	a0,ffffffffc0203b1e <pmm_init+0x69e>
ffffffffc020386e:	611c                	ld	a5,0(a0)
ffffffffc0203870:	078a                	slli	a5,a5,0x2
ffffffffc0203872:	0157f7b3          	and	a5,a5,s5
ffffffffc0203876:	28879463          	bne	a5,s0,ffffffffc0203afe <pmm_init+0x67e>
ffffffffc020387a:	6098                	ld	a4,0(s1)
ffffffffc020387c:	9452                	add	s0,s0,s4
ffffffffc020387e:	00c71793          	slli	a5,a4,0xc
ffffffffc0203882:	fcf468e3          	bltu	s0,a5,ffffffffc0203852 <pmm_init+0x3d2>
ffffffffc0203886:	00093783          	ld	a5,0(s2)
ffffffffc020388a:	639c                	ld	a5,0(a5)
ffffffffc020388c:	66079b63          	bnez	a5,ffffffffc0203f02 <pmm_init+0xa82>
ffffffffc0203890:	4505                	li	a0,1
ffffffffc0203892:	f2aff0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0203896:	8aaa                	mv	s5,a0
ffffffffc0203898:	00093503          	ld	a0,0(s2)
ffffffffc020389c:	4699                	li	a3,6
ffffffffc020389e:	10000613          	li	a2,256
ffffffffc02038a2:	85d6                	mv	a1,s5
ffffffffc02038a4:	ae7ff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc02038a8:	62051d63          	bnez	a0,ffffffffc0203ee2 <pmm_init+0xa62>
ffffffffc02038ac:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fde8a34>
ffffffffc02038b0:	4785                	li	a5,1
ffffffffc02038b2:	60f71863          	bne	a4,a5,ffffffffc0203ec2 <pmm_init+0xa42>
ffffffffc02038b6:	00093503          	ld	a0,0(s2)
ffffffffc02038ba:	6405                	lui	s0,0x1
ffffffffc02038bc:	4699                	li	a3,6
ffffffffc02038be:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02038c2:	85d6                	mv	a1,s5
ffffffffc02038c4:	ac7ff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc02038c8:	46051163          	bnez	a0,ffffffffc0203d2a <pmm_init+0x8aa>
ffffffffc02038cc:	000aa703          	lw	a4,0(s5)
ffffffffc02038d0:	4789                	li	a5,2
ffffffffc02038d2:	72f71463          	bne	a4,a5,ffffffffc0203ffa <pmm_init+0xb7a>
ffffffffc02038d6:	00003597          	auipc	a1,0x3
ffffffffc02038da:	2a258593          	addi	a1,a1,674 # ffffffffc0206b78 <default_pmm_manager+0x4d8>
ffffffffc02038de:	10000513          	li	a0,256
ffffffffc02038e2:	1d0010ef          	jal	ra,ffffffffc0204ab2 <strcpy>
ffffffffc02038e6:	10040593          	addi	a1,s0,256
ffffffffc02038ea:	10000513          	li	a0,256
ffffffffc02038ee:	1d6010ef          	jal	ra,ffffffffc0204ac4 <strcmp>
ffffffffc02038f2:	6e051463          	bnez	a0,ffffffffc0203fda <pmm_init+0xb5a>
ffffffffc02038f6:	000b3683          	ld	a3,0(s6)
ffffffffc02038fa:	00080737          	lui	a4,0x80
ffffffffc02038fe:	547d                	li	s0,-1
ffffffffc0203900:	40da86b3          	sub	a3,s5,a3
ffffffffc0203904:	8699                	srai	a3,a3,0x6
ffffffffc0203906:	609c                	ld	a5,0(s1)
ffffffffc0203908:	96ba                	add	a3,a3,a4
ffffffffc020390a:	8031                	srli	s0,s0,0xc
ffffffffc020390c:	0086f733          	and	a4,a3,s0
ffffffffc0203910:	06b2                	slli	a3,a3,0xc
ffffffffc0203912:	50f77c63          	bgeu	a4,a5,ffffffffc0203e2a <pmm_init+0x9aa>
ffffffffc0203916:	0009b783          	ld	a5,0(s3)
ffffffffc020391a:	10000513          	li	a0,256
ffffffffc020391e:	96be                	add	a3,a3,a5
ffffffffc0203920:	10068023          	sb	zero,256(a3)
ffffffffc0203924:	158010ef          	jal	ra,ffffffffc0204a7c <strlen>
ffffffffc0203928:	68051963          	bnez	a0,ffffffffc0203fba <pmm_init+0xb3a>
ffffffffc020392c:	00093a03          	ld	s4,0(s2)
ffffffffc0203930:	609c                	ld	a5,0(s1)
ffffffffc0203932:	000a3683          	ld	a3,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0203936:	068a                	slli	a3,a3,0x2
ffffffffc0203938:	82b1                	srli	a3,a3,0xc
ffffffffc020393a:	20f6ff63          	bgeu	a3,a5,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc020393e:	8c75                	and	s0,s0,a3
ffffffffc0203940:	06b2                	slli	a3,a3,0xc
ffffffffc0203942:	4ef47463          	bgeu	s0,a5,ffffffffc0203e2a <pmm_init+0x9aa>
ffffffffc0203946:	0009b403          	ld	s0,0(s3)
ffffffffc020394a:	9436                	add	s0,s0,a3
ffffffffc020394c:	100027f3          	csrr	a5,sstatus
ffffffffc0203950:	8b89                	andi	a5,a5,2
ffffffffc0203952:	18079b63          	bnez	a5,ffffffffc0203ae8 <pmm_init+0x668>
ffffffffc0203956:	000bb783          	ld	a5,0(s7)
ffffffffc020395a:	4585                	li	a1,1
ffffffffc020395c:	8556                	mv	a0,s5
ffffffffc020395e:	739c                	ld	a5,32(a5)
ffffffffc0203960:	9782                	jalr	a5
ffffffffc0203962:	601c                	ld	a5,0(s0)
ffffffffc0203964:	6098                	ld	a4,0(s1)
ffffffffc0203966:	078a                	slli	a5,a5,0x2
ffffffffc0203968:	83b1                	srli	a5,a5,0xc
ffffffffc020396a:	1ee7f763          	bgeu	a5,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc020396e:	000b3503          	ld	a0,0(s6)
ffffffffc0203972:	fff80737          	lui	a4,0xfff80
ffffffffc0203976:	97ba                	add	a5,a5,a4
ffffffffc0203978:	079a                	slli	a5,a5,0x6
ffffffffc020397a:	953e                	add	a0,a0,a5
ffffffffc020397c:	100027f3          	csrr	a5,sstatus
ffffffffc0203980:	8b89                	andi	a5,a5,2
ffffffffc0203982:	14079763          	bnez	a5,ffffffffc0203ad0 <pmm_init+0x650>
ffffffffc0203986:	000bb783          	ld	a5,0(s7)
ffffffffc020398a:	4585                	li	a1,1
ffffffffc020398c:	739c                	ld	a5,32(a5)
ffffffffc020398e:	9782                	jalr	a5
ffffffffc0203990:	000a3783          	ld	a5,0(s4)
ffffffffc0203994:	6098                	ld	a4,0(s1)
ffffffffc0203996:	078a                	slli	a5,a5,0x2
ffffffffc0203998:	83b1                	srli	a5,a5,0xc
ffffffffc020399a:	1ae7ff63          	bgeu	a5,a4,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc020399e:	000b3503          	ld	a0,0(s6)
ffffffffc02039a2:	fff80737          	lui	a4,0xfff80
ffffffffc02039a6:	97ba                	add	a5,a5,a4
ffffffffc02039a8:	079a                	slli	a5,a5,0x6
ffffffffc02039aa:	953e                	add	a0,a0,a5
ffffffffc02039ac:	100027f3          	csrr	a5,sstatus
ffffffffc02039b0:	8b89                	andi	a5,a5,2
ffffffffc02039b2:	10079363          	bnez	a5,ffffffffc0203ab8 <pmm_init+0x638>
ffffffffc02039b6:	000bb783          	ld	a5,0(s7)
ffffffffc02039ba:	4585                	li	a1,1
ffffffffc02039bc:	739c                	ld	a5,32(a5)
ffffffffc02039be:	9782                	jalr	a5
ffffffffc02039c0:	00093783          	ld	a5,0(s2)
ffffffffc02039c4:	0007b023          	sd	zero,0(a5)
ffffffffc02039c8:	12000073          	sfence.vma
ffffffffc02039cc:	100027f3          	csrr	a5,sstatus
ffffffffc02039d0:	8b89                	andi	a5,a5,2
ffffffffc02039d2:	0c079963          	bnez	a5,ffffffffc0203aa4 <pmm_init+0x624>
ffffffffc02039d6:	000bb783          	ld	a5,0(s7)
ffffffffc02039da:	779c                	ld	a5,40(a5)
ffffffffc02039dc:	9782                	jalr	a5
ffffffffc02039de:	842a                	mv	s0,a0
ffffffffc02039e0:	3a8c1563          	bne	s8,s0,ffffffffc0203d8a <pmm_init+0x90a>
ffffffffc02039e4:	00003517          	auipc	a0,0x3
ffffffffc02039e8:	20c50513          	addi	a0,a0,524 # ffffffffc0206bf0 <default_pmm_manager+0x550>
ffffffffc02039ec:	ee0fc0ef          	jal	ra,ffffffffc02000cc <cprintf>
ffffffffc02039f0:	6446                	ld	s0,80(sp)
ffffffffc02039f2:	60e6                	ld	ra,88(sp)
ffffffffc02039f4:	64a6                	ld	s1,72(sp)
ffffffffc02039f6:	6906                	ld	s2,64(sp)
ffffffffc02039f8:	79e2                	ld	s3,56(sp)
ffffffffc02039fa:	7a42                	ld	s4,48(sp)
ffffffffc02039fc:	7aa2                	ld	s5,40(sp)
ffffffffc02039fe:	7b02                	ld	s6,32(sp)
ffffffffc0203a00:	6be2                	ld	s7,24(sp)
ffffffffc0203a02:	6c42                	ld	s8,16(sp)
ffffffffc0203a04:	6125                	addi	sp,sp,96
ffffffffc0203a06:	818fe06f          	j	ffffffffc0201a1e <kmalloc_init>
ffffffffc0203a0a:	6785                	lui	a5,0x1
ffffffffc0203a0c:	17fd                	addi	a5,a5,-1
ffffffffc0203a0e:	96be                	add	a3,a3,a5
ffffffffc0203a10:	77fd                	lui	a5,0xfffff
ffffffffc0203a12:	8ff5                	and	a5,a5,a3
ffffffffc0203a14:	00c7d693          	srli	a3,a5,0xc
ffffffffc0203a18:	14c6f063          	bgeu	a3,a2,ffffffffc0203b58 <pmm_init+0x6d8>
ffffffffc0203a1c:	000bb603          	ld	a2,0(s7)
ffffffffc0203a20:	96c2                	add	a3,a3,a6
ffffffffc0203a22:	40f707b3          	sub	a5,a4,a5
ffffffffc0203a26:	6a10                	ld	a2,16(a2)
ffffffffc0203a28:	069a                	slli	a3,a3,0x6
ffffffffc0203a2a:	00c7d593          	srli	a1,a5,0xc
ffffffffc0203a2e:	9536                	add	a0,a0,a3
ffffffffc0203a30:	9602                	jalr	a2
ffffffffc0203a32:	0009b583          	ld	a1,0(s3)
ffffffffc0203a36:	b63d                	j	ffffffffc0203564 <pmm_init+0xe4>
ffffffffc0203a38:	b8dfc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203a3c:	000bb783          	ld	a5,0(s7)
ffffffffc0203a40:	779c                	ld	a5,40(a5)
ffffffffc0203a42:	9782                	jalr	a5
ffffffffc0203a44:	842a                	mv	s0,a0
ffffffffc0203a46:	b79fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203a4a:	bea5                	j	ffffffffc02035c2 <pmm_init+0x142>
ffffffffc0203a4c:	b79fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203a50:	000bb783          	ld	a5,0(s7)
ffffffffc0203a54:	779c                	ld	a5,40(a5)
ffffffffc0203a56:	9782                	jalr	a5
ffffffffc0203a58:	8c2a                	mv	s8,a0
ffffffffc0203a5a:	b65fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203a5e:	b3cd                	j	ffffffffc0203840 <pmm_init+0x3c0>
ffffffffc0203a60:	b65fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203a64:	000bb783          	ld	a5,0(s7)
ffffffffc0203a68:	779c                	ld	a5,40(a5)
ffffffffc0203a6a:	9782                	jalr	a5
ffffffffc0203a6c:	8a2a                	mv	s4,a0
ffffffffc0203a6e:	b51fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203a72:	b36d                	j	ffffffffc020381c <pmm_init+0x39c>
ffffffffc0203a74:	e42a                	sd	a0,8(sp)
ffffffffc0203a76:	b4ffc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203a7a:	000bb783          	ld	a5,0(s7)
ffffffffc0203a7e:	6522                	ld	a0,8(sp)
ffffffffc0203a80:	4585                	li	a1,1
ffffffffc0203a82:	739c                	ld	a5,32(a5)
ffffffffc0203a84:	9782                	jalr	a5
ffffffffc0203a86:	b39fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203a8a:	bb8d                	j	ffffffffc02037fc <pmm_init+0x37c>
ffffffffc0203a8c:	e42a                	sd	a0,8(sp)
ffffffffc0203a8e:	b37fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203a92:	000bb783          	ld	a5,0(s7)
ffffffffc0203a96:	6522                	ld	a0,8(sp)
ffffffffc0203a98:	4585                	li	a1,1
ffffffffc0203a9a:	739c                	ld	a5,32(a5)
ffffffffc0203a9c:	9782                	jalr	a5
ffffffffc0203a9e:	b21fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203aa2:	b32d                	j	ffffffffc02037cc <pmm_init+0x34c>
ffffffffc0203aa4:	b21fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203aa8:	000bb783          	ld	a5,0(s7)
ffffffffc0203aac:	779c                	ld	a5,40(a5)
ffffffffc0203aae:	9782                	jalr	a5
ffffffffc0203ab0:	842a                	mv	s0,a0
ffffffffc0203ab2:	b0dfc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203ab6:	b72d                	j	ffffffffc02039e0 <pmm_init+0x560>
ffffffffc0203ab8:	e42a                	sd	a0,8(sp)
ffffffffc0203aba:	b0bfc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203abe:	000bb783          	ld	a5,0(s7)
ffffffffc0203ac2:	6522                	ld	a0,8(sp)
ffffffffc0203ac4:	4585                	li	a1,1
ffffffffc0203ac6:	739c                	ld	a5,32(a5)
ffffffffc0203ac8:	9782                	jalr	a5
ffffffffc0203aca:	af5fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203ace:	bdcd                	j	ffffffffc02039c0 <pmm_init+0x540>
ffffffffc0203ad0:	e42a                	sd	a0,8(sp)
ffffffffc0203ad2:	af3fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203ad6:	000bb783          	ld	a5,0(s7)
ffffffffc0203ada:	6522                	ld	a0,8(sp)
ffffffffc0203adc:	4585                	li	a1,1
ffffffffc0203ade:	739c                	ld	a5,32(a5)
ffffffffc0203ae0:	9782                	jalr	a5
ffffffffc0203ae2:	addfc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203ae6:	b56d                	j	ffffffffc0203990 <pmm_init+0x510>
ffffffffc0203ae8:	addfc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0203aec:	000bb783          	ld	a5,0(s7)
ffffffffc0203af0:	4585                	li	a1,1
ffffffffc0203af2:	8556                	mv	a0,s5
ffffffffc0203af4:	739c                	ld	a5,32(a5)
ffffffffc0203af6:	9782                	jalr	a5
ffffffffc0203af8:	ac7fc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0203afc:	b59d                	j	ffffffffc0203962 <pmm_init+0x4e2>
ffffffffc0203afe:	00003697          	auipc	a3,0x3
ffffffffc0203b02:	fa268693          	addi	a3,a3,-94 # ffffffffc0206aa0 <default_pmm_manager+0x400>
ffffffffc0203b06:	00002617          	auipc	a2,0x2
ffffffffc0203b0a:	dfa60613          	addi	a2,a2,-518 # ffffffffc0205900 <commands+0x728>
ffffffffc0203b0e:	19e00593          	li	a1,414
ffffffffc0203b12:	00003517          	auipc	a0,0x3
ffffffffc0203b16:	bc650513          	addi	a0,a0,-1082 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203b1a:	eaefc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203b1e:	00003697          	auipc	a3,0x3
ffffffffc0203b22:	f4268693          	addi	a3,a3,-190 # ffffffffc0206a60 <default_pmm_manager+0x3c0>
ffffffffc0203b26:	00002617          	auipc	a2,0x2
ffffffffc0203b2a:	dda60613          	addi	a2,a2,-550 # ffffffffc0205900 <commands+0x728>
ffffffffc0203b2e:	19d00593          	li	a1,413
ffffffffc0203b32:	00003517          	auipc	a0,0x3
ffffffffc0203b36:	ba650513          	addi	a0,a0,-1114 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203b3a:	e8efc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203b3e:	86a2                	mv	a3,s0
ffffffffc0203b40:	00002617          	auipc	a2,0x2
ffffffffc0203b44:	01860613          	addi	a2,a2,24 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203b48:	19d00593          	li	a1,413
ffffffffc0203b4c:	00003517          	auipc	a0,0x3
ffffffffc0203b50:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203b54:	e74fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203b58:	c2cff0ef          	jal	ra,ffffffffc0202f84 <pa2page.part.0>
ffffffffc0203b5c:	00002617          	auipc	a2,0x2
ffffffffc0203b60:	3f460613          	addi	a2,a2,1012 # ffffffffc0205f50 <commands+0xd78>
ffffffffc0203b64:	07f00593          	li	a1,127
ffffffffc0203b68:	00003517          	auipc	a0,0x3
ffffffffc0203b6c:	b7050513          	addi	a0,a0,-1168 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203b70:	e58fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203b74:	00002617          	auipc	a2,0x2
ffffffffc0203b78:	3dc60613          	addi	a2,a2,988 # ffffffffc0205f50 <commands+0xd78>
ffffffffc0203b7c:	0c300593          	li	a1,195
ffffffffc0203b80:	00003517          	auipc	a0,0x3
ffffffffc0203b84:	b5850513          	addi	a0,a0,-1192 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203b88:	e40fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203b8c:	00003697          	auipc	a3,0x3
ffffffffc0203b90:	c0c68693          	addi	a3,a3,-1012 # ffffffffc0206798 <default_pmm_manager+0xf8>
ffffffffc0203b94:	00002617          	auipc	a2,0x2
ffffffffc0203b98:	d6c60613          	addi	a2,a2,-660 # ffffffffc0205900 <commands+0x728>
ffffffffc0203b9c:	16100593          	li	a1,353
ffffffffc0203ba0:	00003517          	auipc	a0,0x3
ffffffffc0203ba4:	b3850513          	addi	a0,a0,-1224 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ba8:	e20fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203bac:	00003697          	auipc	a3,0x3
ffffffffc0203bb0:	bcc68693          	addi	a3,a3,-1076 # ffffffffc0206778 <default_pmm_manager+0xd8>
ffffffffc0203bb4:	00002617          	auipc	a2,0x2
ffffffffc0203bb8:	d4c60613          	addi	a2,a2,-692 # ffffffffc0205900 <commands+0x728>
ffffffffc0203bbc:	16000593          	li	a1,352
ffffffffc0203bc0:	00003517          	auipc	a0,0x3
ffffffffc0203bc4:	b1850513          	addi	a0,a0,-1256 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203bc8:	e00fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203bcc:	bd4ff0ef          	jal	ra,ffffffffc0202fa0 <pte2page.part.0>
ffffffffc0203bd0:	00003697          	auipc	a3,0x3
ffffffffc0203bd4:	c5868693          	addi	a3,a3,-936 # ffffffffc0206828 <default_pmm_manager+0x188>
ffffffffc0203bd8:	00002617          	auipc	a2,0x2
ffffffffc0203bdc:	d2860613          	addi	a2,a2,-728 # ffffffffc0205900 <commands+0x728>
ffffffffc0203be0:	16900593          	li	a1,361
ffffffffc0203be4:	00003517          	auipc	a0,0x3
ffffffffc0203be8:	af450513          	addi	a0,a0,-1292 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203bec:	ddcfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203bf0:	00003697          	auipc	a3,0x3
ffffffffc0203bf4:	c0868693          	addi	a3,a3,-1016 # ffffffffc02067f8 <default_pmm_manager+0x158>
ffffffffc0203bf8:	00002617          	auipc	a2,0x2
ffffffffc0203bfc:	d0860613          	addi	a2,a2,-760 # ffffffffc0205900 <commands+0x728>
ffffffffc0203c00:	16600593          	li	a1,358
ffffffffc0203c04:	00003517          	auipc	a0,0x3
ffffffffc0203c08:	ad450513          	addi	a0,a0,-1324 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203c0c:	dbcfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203c10:	00003697          	auipc	a3,0x3
ffffffffc0203c14:	bc068693          	addi	a3,a3,-1088 # ffffffffc02067d0 <default_pmm_manager+0x130>
ffffffffc0203c18:	00002617          	auipc	a2,0x2
ffffffffc0203c1c:	ce860613          	addi	a2,a2,-792 # ffffffffc0205900 <commands+0x728>
ffffffffc0203c20:	16200593          	li	a1,354
ffffffffc0203c24:	00003517          	auipc	a0,0x3
ffffffffc0203c28:	ab450513          	addi	a0,a0,-1356 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203c2c:	d9cfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203c30:	00003697          	auipc	a3,0x3
ffffffffc0203c34:	c8068693          	addi	a3,a3,-896 # ffffffffc02068b0 <default_pmm_manager+0x210>
ffffffffc0203c38:	00002617          	auipc	a2,0x2
ffffffffc0203c3c:	cc860613          	addi	a2,a2,-824 # ffffffffc0205900 <commands+0x728>
ffffffffc0203c40:	17200593          	li	a1,370
ffffffffc0203c44:	00003517          	auipc	a0,0x3
ffffffffc0203c48:	a9450513          	addi	a0,a0,-1388 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203c4c:	d7cfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203c50:	00003697          	auipc	a3,0x3
ffffffffc0203c54:	d0068693          	addi	a3,a3,-768 # ffffffffc0206950 <default_pmm_manager+0x2b0>
ffffffffc0203c58:	00002617          	auipc	a2,0x2
ffffffffc0203c5c:	ca860613          	addi	a2,a2,-856 # ffffffffc0205900 <commands+0x728>
ffffffffc0203c60:	17700593          	li	a1,375
ffffffffc0203c64:	00003517          	auipc	a0,0x3
ffffffffc0203c68:	a7450513          	addi	a0,a0,-1420 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203c6c:	d5cfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203c70:	00003697          	auipc	a3,0x3
ffffffffc0203c74:	c1868693          	addi	a3,a3,-1000 # ffffffffc0206888 <default_pmm_manager+0x1e8>
ffffffffc0203c78:	00002617          	auipc	a2,0x2
ffffffffc0203c7c:	c8860613          	addi	a2,a2,-888 # ffffffffc0205900 <commands+0x728>
ffffffffc0203c80:	16f00593          	li	a1,367
ffffffffc0203c84:	00003517          	auipc	a0,0x3
ffffffffc0203c88:	a5450513          	addi	a0,a0,-1452 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203c8c:	d3cfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203c90:	86d6                	mv	a3,s5
ffffffffc0203c92:	00002617          	auipc	a2,0x2
ffffffffc0203c96:	ec660613          	addi	a2,a2,-314 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203c9a:	16e00593          	li	a1,366
ffffffffc0203c9e:	00003517          	auipc	a0,0x3
ffffffffc0203ca2:	a3a50513          	addi	a0,a0,-1478 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ca6:	d22fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203caa:	00003697          	auipc	a3,0x3
ffffffffc0203cae:	c3e68693          	addi	a3,a3,-962 # ffffffffc02068e8 <default_pmm_manager+0x248>
ffffffffc0203cb2:	00002617          	auipc	a2,0x2
ffffffffc0203cb6:	c4e60613          	addi	a2,a2,-946 # ffffffffc0205900 <commands+0x728>
ffffffffc0203cba:	17c00593          	li	a1,380
ffffffffc0203cbe:	00003517          	auipc	a0,0x3
ffffffffc0203cc2:	a1a50513          	addi	a0,a0,-1510 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203cc6:	d02fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203cca:	00003697          	auipc	a3,0x3
ffffffffc0203cce:	ce668693          	addi	a3,a3,-794 # ffffffffc02069b0 <default_pmm_manager+0x310>
ffffffffc0203cd2:	00002617          	auipc	a2,0x2
ffffffffc0203cd6:	c2e60613          	addi	a2,a2,-978 # ffffffffc0205900 <commands+0x728>
ffffffffc0203cda:	17b00593          	li	a1,379
ffffffffc0203cde:	00003517          	auipc	a0,0x3
ffffffffc0203ce2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ce6:	ce2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203cea:	00003697          	auipc	a3,0x3
ffffffffc0203cee:	cae68693          	addi	a3,a3,-850 # ffffffffc0206998 <default_pmm_manager+0x2f8>
ffffffffc0203cf2:	00002617          	auipc	a2,0x2
ffffffffc0203cf6:	c0e60613          	addi	a2,a2,-1010 # ffffffffc0205900 <commands+0x728>
ffffffffc0203cfa:	17a00593          	li	a1,378
ffffffffc0203cfe:	00003517          	auipc	a0,0x3
ffffffffc0203d02:	9da50513          	addi	a0,a0,-1574 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203d06:	cc2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203d0a:	00003697          	auipc	a3,0x3
ffffffffc0203d0e:	c5e68693          	addi	a3,a3,-930 # ffffffffc0206968 <default_pmm_manager+0x2c8>
ffffffffc0203d12:	00002617          	auipc	a2,0x2
ffffffffc0203d16:	bee60613          	addi	a2,a2,-1042 # ffffffffc0205900 <commands+0x728>
ffffffffc0203d1a:	17900593          	li	a1,377
ffffffffc0203d1e:	00003517          	auipc	a0,0x3
ffffffffc0203d22:	9ba50513          	addi	a0,a0,-1606 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203d26:	ca2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203d2a:	00003697          	auipc	a3,0x3
ffffffffc0203d2e:	df668693          	addi	a3,a3,-522 # ffffffffc0206b20 <default_pmm_manager+0x480>
ffffffffc0203d32:	00002617          	auipc	a2,0x2
ffffffffc0203d36:	bce60613          	addi	a2,a2,-1074 # ffffffffc0205900 <commands+0x728>
ffffffffc0203d3a:	1a700593          	li	a1,423
ffffffffc0203d3e:	00003517          	auipc	a0,0x3
ffffffffc0203d42:	99a50513          	addi	a0,a0,-1638 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203d46:	c82fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203d4a:	00003697          	auipc	a3,0x3
ffffffffc0203d4e:	bee68693          	addi	a3,a3,-1042 # ffffffffc0206938 <default_pmm_manager+0x298>
ffffffffc0203d52:	00002617          	auipc	a2,0x2
ffffffffc0203d56:	bae60613          	addi	a2,a2,-1106 # ffffffffc0205900 <commands+0x728>
ffffffffc0203d5a:	17600593          	li	a1,374
ffffffffc0203d5e:	00003517          	auipc	a0,0x3
ffffffffc0203d62:	97a50513          	addi	a0,a0,-1670 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203d66:	c62fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203d6a:	00003697          	auipc	a3,0x3
ffffffffc0203d6e:	bbe68693          	addi	a3,a3,-1090 # ffffffffc0206928 <default_pmm_manager+0x288>
ffffffffc0203d72:	00002617          	auipc	a2,0x2
ffffffffc0203d76:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0205900 <commands+0x728>
ffffffffc0203d7a:	17500593          	li	a1,373
ffffffffc0203d7e:	00003517          	auipc	a0,0x3
ffffffffc0203d82:	95a50513          	addi	a0,a0,-1702 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203d86:	c42fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203d8a:	00003697          	auipc	a3,0x3
ffffffffc0203d8e:	c9668693          	addi	a3,a3,-874 # ffffffffc0206a20 <default_pmm_manager+0x380>
ffffffffc0203d92:	00002617          	auipc	a2,0x2
ffffffffc0203d96:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0205900 <commands+0x728>
ffffffffc0203d9a:	1b800593          	li	a1,440
ffffffffc0203d9e:	00003517          	auipc	a0,0x3
ffffffffc0203da2:	93a50513          	addi	a0,a0,-1734 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203da6:	c22fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203daa:	00003697          	auipc	a3,0x3
ffffffffc0203dae:	b6e68693          	addi	a3,a3,-1170 # ffffffffc0206918 <default_pmm_manager+0x278>
ffffffffc0203db2:	00002617          	auipc	a2,0x2
ffffffffc0203db6:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0205900 <commands+0x728>
ffffffffc0203dba:	17400593          	li	a1,372
ffffffffc0203dbe:	00003517          	auipc	a0,0x3
ffffffffc0203dc2:	91a50513          	addi	a0,a0,-1766 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203dc6:	c02fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203dca:	00003697          	auipc	a3,0x3
ffffffffc0203dce:	aa668693          	addi	a3,a3,-1370 # ffffffffc0206870 <default_pmm_manager+0x1d0>
ffffffffc0203dd2:	00002617          	auipc	a2,0x2
ffffffffc0203dd6:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0205900 <commands+0x728>
ffffffffc0203dda:	18100593          	li	a1,385
ffffffffc0203dde:	00003517          	auipc	a0,0x3
ffffffffc0203de2:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203de6:	be2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203dea:	00003697          	auipc	a3,0x3
ffffffffc0203dee:	bde68693          	addi	a3,a3,-1058 # ffffffffc02069c8 <default_pmm_manager+0x328>
ffffffffc0203df2:	00002617          	auipc	a2,0x2
ffffffffc0203df6:	b0e60613          	addi	a2,a2,-1266 # ffffffffc0205900 <commands+0x728>
ffffffffc0203dfa:	17e00593          	li	a1,382
ffffffffc0203dfe:	00003517          	auipc	a0,0x3
ffffffffc0203e02:	8da50513          	addi	a0,a0,-1830 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203e06:	bc2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203e0a:	00003697          	auipc	a3,0x3
ffffffffc0203e0e:	a4e68693          	addi	a3,a3,-1458 # ffffffffc0206858 <default_pmm_manager+0x1b8>
ffffffffc0203e12:	00002617          	auipc	a2,0x2
ffffffffc0203e16:	aee60613          	addi	a2,a2,-1298 # ffffffffc0205900 <commands+0x728>
ffffffffc0203e1a:	17d00593          	li	a1,381
ffffffffc0203e1e:	00003517          	auipc	a0,0x3
ffffffffc0203e22:	8ba50513          	addi	a0,a0,-1862 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203e26:	ba2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203e2a:	00002617          	auipc	a2,0x2
ffffffffc0203e2e:	d2e60613          	addi	a2,a2,-722 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203e32:	06900593          	li	a1,105
ffffffffc0203e36:	00002517          	auipc	a0,0x2
ffffffffc0203e3a:	d1250513          	addi	a0,a0,-750 # ffffffffc0205b48 <commands+0x970>
ffffffffc0203e3e:	b8afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203e42:	00003697          	auipc	a3,0x3
ffffffffc0203e46:	bb668693          	addi	a3,a3,-1098 # ffffffffc02069f8 <default_pmm_manager+0x358>
ffffffffc0203e4a:	00002617          	auipc	a2,0x2
ffffffffc0203e4e:	ab660613          	addi	a2,a2,-1354 # ffffffffc0205900 <commands+0x728>
ffffffffc0203e52:	18800593          	li	a1,392
ffffffffc0203e56:	00003517          	auipc	a0,0x3
ffffffffc0203e5a:	88250513          	addi	a0,a0,-1918 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203e5e:	b6afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203e62:	00003697          	auipc	a3,0x3
ffffffffc0203e66:	b4e68693          	addi	a3,a3,-1202 # ffffffffc02069b0 <default_pmm_manager+0x310>
ffffffffc0203e6a:	00002617          	auipc	a2,0x2
ffffffffc0203e6e:	a9660613          	addi	a2,a2,-1386 # ffffffffc0205900 <commands+0x728>
ffffffffc0203e72:	18600593          	li	a1,390
ffffffffc0203e76:	00003517          	auipc	a0,0x3
ffffffffc0203e7a:	86250513          	addi	a0,a0,-1950 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203e7e:	b4afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203e82:	00003697          	auipc	a3,0x3
ffffffffc0203e86:	b5e68693          	addi	a3,a3,-1186 # ffffffffc02069e0 <default_pmm_manager+0x340>
ffffffffc0203e8a:	00002617          	auipc	a2,0x2
ffffffffc0203e8e:	a7660613          	addi	a2,a2,-1418 # ffffffffc0205900 <commands+0x728>
ffffffffc0203e92:	18500593          	li	a1,389
ffffffffc0203e96:	00003517          	auipc	a0,0x3
ffffffffc0203e9a:	84250513          	addi	a0,a0,-1982 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203e9e:	b2afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203ea2:	00003697          	auipc	a3,0x3
ffffffffc0203ea6:	b0e68693          	addi	a3,a3,-1266 # ffffffffc02069b0 <default_pmm_manager+0x310>
ffffffffc0203eaa:	00002617          	auipc	a2,0x2
ffffffffc0203eae:	a5660613          	addi	a2,a2,-1450 # ffffffffc0205900 <commands+0x728>
ffffffffc0203eb2:	18200593          	li	a1,386
ffffffffc0203eb6:	00003517          	auipc	a0,0x3
ffffffffc0203eba:	82250513          	addi	a0,a0,-2014 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ebe:	b0afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203ec2:	00003697          	auipc	a3,0x3
ffffffffc0203ec6:	c4668693          	addi	a3,a3,-954 # ffffffffc0206b08 <default_pmm_manager+0x468>
ffffffffc0203eca:	00002617          	auipc	a2,0x2
ffffffffc0203ece:	a3660613          	addi	a2,a2,-1482 # ffffffffc0205900 <commands+0x728>
ffffffffc0203ed2:	1a600593          	li	a1,422
ffffffffc0203ed6:	00003517          	auipc	a0,0x3
ffffffffc0203eda:	80250513          	addi	a0,a0,-2046 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ede:	aeafc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203ee2:	00003697          	auipc	a3,0x3
ffffffffc0203ee6:	bee68693          	addi	a3,a3,-1042 # ffffffffc0206ad0 <default_pmm_manager+0x430>
ffffffffc0203eea:	00002617          	auipc	a2,0x2
ffffffffc0203eee:	a1660613          	addi	a2,a2,-1514 # ffffffffc0205900 <commands+0x728>
ffffffffc0203ef2:	1a500593          	li	a1,421
ffffffffc0203ef6:	00002517          	auipc	a0,0x2
ffffffffc0203efa:	7e250513          	addi	a0,a0,2018 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203efe:	acafc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f02:	00003697          	auipc	a3,0x3
ffffffffc0203f06:	bb668693          	addi	a3,a3,-1098 # ffffffffc0206ab8 <default_pmm_manager+0x418>
ffffffffc0203f0a:	00002617          	auipc	a2,0x2
ffffffffc0203f0e:	9f660613          	addi	a2,a2,-1546 # ffffffffc0205900 <commands+0x728>
ffffffffc0203f12:	1a100593          	li	a1,417
ffffffffc0203f16:	00002517          	auipc	a0,0x2
ffffffffc0203f1a:	7c250513          	addi	a0,a0,1986 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203f1e:	aaafc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f22:	00003697          	auipc	a3,0x3
ffffffffc0203f26:	afe68693          	addi	a3,a3,-1282 # ffffffffc0206a20 <default_pmm_manager+0x380>
ffffffffc0203f2a:	00002617          	auipc	a2,0x2
ffffffffc0203f2e:	9d660613          	addi	a2,a2,-1578 # ffffffffc0205900 <commands+0x728>
ffffffffc0203f32:	19000593          	li	a1,400
ffffffffc0203f36:	00002517          	auipc	a0,0x2
ffffffffc0203f3a:	7a250513          	addi	a0,a0,1954 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203f3e:	a8afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f42:	00003697          	auipc	a3,0x3
ffffffffc0203f46:	91668693          	addi	a3,a3,-1770 # ffffffffc0206858 <default_pmm_manager+0x1b8>
ffffffffc0203f4a:	00002617          	auipc	a2,0x2
ffffffffc0203f4e:	9b660613          	addi	a2,a2,-1610 # ffffffffc0205900 <commands+0x728>
ffffffffc0203f52:	16a00593          	li	a1,362
ffffffffc0203f56:	00002517          	auipc	a0,0x2
ffffffffc0203f5a:	78250513          	addi	a0,a0,1922 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203f5e:	a6afc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f62:	00002617          	auipc	a2,0x2
ffffffffc0203f66:	bf660613          	addi	a2,a2,-1034 # ffffffffc0205b58 <commands+0x980>
ffffffffc0203f6a:	16d00593          	li	a1,365
ffffffffc0203f6e:	00002517          	auipc	a0,0x2
ffffffffc0203f72:	76a50513          	addi	a0,a0,1898 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203f76:	a52fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f7a:	00003697          	auipc	a3,0x3
ffffffffc0203f7e:	8f668693          	addi	a3,a3,-1802 # ffffffffc0206870 <default_pmm_manager+0x1d0>
ffffffffc0203f82:	00002617          	auipc	a2,0x2
ffffffffc0203f86:	97e60613          	addi	a2,a2,-1666 # ffffffffc0205900 <commands+0x728>
ffffffffc0203f8a:	16b00593          	li	a1,363
ffffffffc0203f8e:	00002517          	auipc	a0,0x2
ffffffffc0203f92:	74a50513          	addi	a0,a0,1866 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203f96:	a32fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203f9a:	00003697          	auipc	a3,0x3
ffffffffc0203f9e:	94e68693          	addi	a3,a3,-1714 # ffffffffc02068e8 <default_pmm_manager+0x248>
ffffffffc0203fa2:	00002617          	auipc	a2,0x2
ffffffffc0203fa6:	95e60613          	addi	a2,a2,-1698 # ffffffffc0205900 <commands+0x728>
ffffffffc0203faa:	17300593          	li	a1,371
ffffffffc0203fae:	00002517          	auipc	a0,0x2
ffffffffc0203fb2:	72a50513          	addi	a0,a0,1834 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203fb6:	a12fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203fba:	00003697          	auipc	a3,0x3
ffffffffc0203fbe:	c0e68693          	addi	a3,a3,-1010 # ffffffffc0206bc8 <default_pmm_manager+0x528>
ffffffffc0203fc2:	00002617          	auipc	a2,0x2
ffffffffc0203fc6:	93e60613          	addi	a2,a2,-1730 # ffffffffc0205900 <commands+0x728>
ffffffffc0203fca:	1af00593          	li	a1,431
ffffffffc0203fce:	00002517          	auipc	a0,0x2
ffffffffc0203fd2:	70a50513          	addi	a0,a0,1802 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203fd6:	9f2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203fda:	00003697          	auipc	a3,0x3
ffffffffc0203fde:	bb668693          	addi	a3,a3,-1098 # ffffffffc0206b90 <default_pmm_manager+0x4f0>
ffffffffc0203fe2:	00002617          	auipc	a2,0x2
ffffffffc0203fe6:	91e60613          	addi	a2,a2,-1762 # ffffffffc0205900 <commands+0x728>
ffffffffc0203fea:	1ac00593          	li	a1,428
ffffffffc0203fee:	00002517          	auipc	a0,0x2
ffffffffc0203ff2:	6ea50513          	addi	a0,a0,1770 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0203ff6:	9d2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0203ffa:	00003697          	auipc	a3,0x3
ffffffffc0203ffe:	b6668693          	addi	a3,a3,-1178 # ffffffffc0206b60 <default_pmm_manager+0x4c0>
ffffffffc0204002:	00002617          	auipc	a2,0x2
ffffffffc0204006:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0205900 <commands+0x728>
ffffffffc020400a:	1a800593          	li	a1,424
ffffffffc020400e:	00002517          	auipc	a0,0x2
ffffffffc0204012:	6ca50513          	addi	a0,a0,1738 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc0204016:	9b2fc0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020401a <tlb_invalidate>:
ffffffffc020401a:	12058073          	sfence.vma	a1
ffffffffc020401e:	8082                	ret

ffffffffc0204020 <pgdir_alloc_page>:
ffffffffc0204020:	7179                	addi	sp,sp,-48
ffffffffc0204022:	e84a                	sd	s2,16(sp)
ffffffffc0204024:	892a                	mv	s2,a0
ffffffffc0204026:	4505                	li	a0,1
ffffffffc0204028:	f022                	sd	s0,32(sp)
ffffffffc020402a:	ec26                	sd	s1,24(sp)
ffffffffc020402c:	e44e                	sd	s3,8(sp)
ffffffffc020402e:	f406                	sd	ra,40(sp)
ffffffffc0204030:	84ae                	mv	s1,a1
ffffffffc0204032:	89b2                	mv	s3,a2
ffffffffc0204034:	f89fe0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
ffffffffc0204038:	842a                	mv	s0,a0
ffffffffc020403a:	cd09                	beqz	a0,ffffffffc0204054 <pgdir_alloc_page+0x34>
ffffffffc020403c:	85aa                	mv	a1,a0
ffffffffc020403e:	86ce                	mv	a3,s3
ffffffffc0204040:	8626                	mv	a2,s1
ffffffffc0204042:	854a                	mv	a0,s2
ffffffffc0204044:	b46ff0ef          	jal	ra,ffffffffc020338a <page_insert>
ffffffffc0204048:	ed21                	bnez	a0,ffffffffc02040a0 <pgdir_alloc_page+0x80>
ffffffffc020404a:	00012797          	auipc	a5,0x12
ffffffffc020404e:	52e7a783          	lw	a5,1326(a5) # ffffffffc0216578 <swap_init_ok>
ffffffffc0204052:	eb89                	bnez	a5,ffffffffc0204064 <pgdir_alloc_page+0x44>
ffffffffc0204054:	70a2                	ld	ra,40(sp)
ffffffffc0204056:	8522                	mv	a0,s0
ffffffffc0204058:	7402                	ld	s0,32(sp)
ffffffffc020405a:	64e2                	ld	s1,24(sp)
ffffffffc020405c:	6942                	ld	s2,16(sp)
ffffffffc020405e:	69a2                	ld	s3,8(sp)
ffffffffc0204060:	6145                	addi	sp,sp,48
ffffffffc0204062:	8082                	ret
ffffffffc0204064:	4681                	li	a3,0
ffffffffc0204066:	8622                	mv	a2,s0
ffffffffc0204068:	85a6                	mv	a1,s1
ffffffffc020406a:	00012517          	auipc	a0,0x12
ffffffffc020406e:	4e653503          	ld	a0,1254(a0) # ffffffffc0216550 <check_mm_struct>
ffffffffc0204072:	ad4fe0ef          	jal	ra,ffffffffc0202346 <swap_map_swappable>
ffffffffc0204076:	4018                	lw	a4,0(s0)
ffffffffc0204078:	fc04                	sd	s1,56(s0)
ffffffffc020407a:	4785                	li	a5,1
ffffffffc020407c:	fcf70ce3          	beq	a4,a5,ffffffffc0204054 <pgdir_alloc_page+0x34>
ffffffffc0204080:	00003697          	auipc	a3,0x3
ffffffffc0204084:	b9068693          	addi	a3,a3,-1136 # ffffffffc0206c10 <default_pmm_manager+0x570>
ffffffffc0204088:	00002617          	auipc	a2,0x2
ffffffffc020408c:	87860613          	addi	a2,a2,-1928 # ffffffffc0205900 <commands+0x728>
ffffffffc0204090:	14800593          	li	a1,328
ffffffffc0204094:	00002517          	auipc	a0,0x2
ffffffffc0204098:	64450513          	addi	a0,a0,1604 # ffffffffc02066d8 <default_pmm_manager+0x38>
ffffffffc020409c:	92cfc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc02040a0:	100027f3          	csrr	a5,sstatus
ffffffffc02040a4:	8b89                	andi	a5,a5,2
ffffffffc02040a6:	eb99                	bnez	a5,ffffffffc02040bc <pgdir_alloc_page+0x9c>
ffffffffc02040a8:	00012797          	auipc	a5,0x12
ffffffffc02040ac:	4f87b783          	ld	a5,1272(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc02040b0:	739c                	ld	a5,32(a5)
ffffffffc02040b2:	8522                	mv	a0,s0
ffffffffc02040b4:	4585                	li	a1,1
ffffffffc02040b6:	9782                	jalr	a5
ffffffffc02040b8:	4401                	li	s0,0
ffffffffc02040ba:	bf69                	j	ffffffffc0204054 <pgdir_alloc_page+0x34>
ffffffffc02040bc:	d08fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc02040c0:	00012797          	auipc	a5,0x12
ffffffffc02040c4:	4e07b783          	ld	a5,1248(a5) # ffffffffc02165a0 <pmm_manager>
ffffffffc02040c8:	739c                	ld	a5,32(a5)
ffffffffc02040ca:	8522                	mv	a0,s0
ffffffffc02040cc:	4585                	li	a1,1
ffffffffc02040ce:	9782                	jalr	a5
ffffffffc02040d0:	4401                	li	s0,0
ffffffffc02040d2:	cecfc0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc02040d6:	bfbd                	j	ffffffffc0204054 <pgdir_alloc_page+0x34>

ffffffffc02040d8 <swapfs_init>:
ffffffffc02040d8:	1141                	addi	sp,sp,-16
ffffffffc02040da:	4505                	li	a0,1
ffffffffc02040dc:	e406                	sd	ra,8(sp)
ffffffffc02040de:	bc6fc0ef          	jal	ra,ffffffffc02004a4 <ide_device_valid>
ffffffffc02040e2:	cd01                	beqz	a0,ffffffffc02040fa <swapfs_init+0x22>
ffffffffc02040e4:	4505                	li	a0,1
ffffffffc02040e6:	bc4fc0ef          	jal	ra,ffffffffc02004aa <ide_device_size>
ffffffffc02040ea:	60a2                	ld	ra,8(sp)
ffffffffc02040ec:	810d                	srli	a0,a0,0x3
ffffffffc02040ee:	00012797          	auipc	a5,0x12
ffffffffc02040f2:	46a7bd23          	sd	a0,1146(a5) # ffffffffc0216568 <max_swap_offset>
ffffffffc02040f6:	0141                	addi	sp,sp,16
ffffffffc02040f8:	8082                	ret
ffffffffc02040fa:	00003617          	auipc	a2,0x3
ffffffffc02040fe:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0206c28 <default_pmm_manager+0x588>
ffffffffc0204102:	45b5                	li	a1,13
ffffffffc0204104:	00003517          	auipc	a0,0x3
ffffffffc0204108:	b4450513          	addi	a0,a0,-1212 # ffffffffc0206c48 <default_pmm_manager+0x5a8>
ffffffffc020410c:	8bcfc0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc0204110 <swapfs_read>:
ffffffffc0204110:	1141                	addi	sp,sp,-16
ffffffffc0204112:	e406                	sd	ra,8(sp)
ffffffffc0204114:	00855793          	srli	a5,a0,0x8
ffffffffc0204118:	cbb1                	beqz	a5,ffffffffc020416c <swapfs_read+0x5c>
ffffffffc020411a:	00012717          	auipc	a4,0x12
ffffffffc020411e:	44e73703          	ld	a4,1102(a4) # ffffffffc0216568 <max_swap_offset>
ffffffffc0204122:	04e7f563          	bgeu	a5,a4,ffffffffc020416c <swapfs_read+0x5c>
ffffffffc0204126:	00012617          	auipc	a2,0x12
ffffffffc020412a:	47263603          	ld	a2,1138(a2) # ffffffffc0216598 <pages>
ffffffffc020412e:	8d91                	sub	a1,a1,a2
ffffffffc0204130:	4065d613          	srai	a2,a1,0x6
ffffffffc0204134:	00003717          	auipc	a4,0x3
ffffffffc0204138:	f4473703          	ld	a4,-188(a4) # ffffffffc0207078 <nbase>
ffffffffc020413c:	963a                	add	a2,a2,a4
ffffffffc020413e:	00c61713          	slli	a4,a2,0xc
ffffffffc0204142:	8331                	srli	a4,a4,0xc
ffffffffc0204144:	00012697          	auipc	a3,0x12
ffffffffc0204148:	44c6b683          	ld	a3,1100(a3) # ffffffffc0216590 <npage>
ffffffffc020414c:	0037959b          	slliw	a1,a5,0x3
ffffffffc0204150:	0632                	slli	a2,a2,0xc
ffffffffc0204152:	02d77963          	bgeu	a4,a3,ffffffffc0204184 <swapfs_read+0x74>
ffffffffc0204156:	60a2                	ld	ra,8(sp)
ffffffffc0204158:	00012797          	auipc	a5,0x12
ffffffffc020415c:	4507b783          	ld	a5,1104(a5) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0204160:	46a1                	li	a3,8
ffffffffc0204162:	963e                	add	a2,a2,a5
ffffffffc0204164:	4505                	li	a0,1
ffffffffc0204166:	0141                	addi	sp,sp,16
ffffffffc0204168:	b48fc06f          	j	ffffffffc02004b0 <ide_read_secs>
ffffffffc020416c:	86aa                	mv	a3,a0
ffffffffc020416e:	00003617          	auipc	a2,0x3
ffffffffc0204172:	af260613          	addi	a2,a2,-1294 # ffffffffc0206c60 <default_pmm_manager+0x5c0>
ffffffffc0204176:	45d1                	li	a1,20
ffffffffc0204178:	00003517          	auipc	a0,0x3
ffffffffc020417c:	ad050513          	addi	a0,a0,-1328 # ffffffffc0206c48 <default_pmm_manager+0x5a8>
ffffffffc0204180:	848fc0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0204184:	86b2                	mv	a3,a2
ffffffffc0204186:	06900593          	li	a1,105
ffffffffc020418a:	00002617          	auipc	a2,0x2
ffffffffc020418e:	9ce60613          	addi	a2,a2,-1586 # ffffffffc0205b58 <commands+0x980>
ffffffffc0204192:	00002517          	auipc	a0,0x2
ffffffffc0204196:	9b650513          	addi	a0,a0,-1610 # ffffffffc0205b48 <commands+0x970>
ffffffffc020419a:	82efc0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020419e <swapfs_write>:
ffffffffc020419e:	1141                	addi	sp,sp,-16
ffffffffc02041a0:	e406                	sd	ra,8(sp)
ffffffffc02041a2:	00855793          	srli	a5,a0,0x8
ffffffffc02041a6:	cbb1                	beqz	a5,ffffffffc02041fa <swapfs_write+0x5c>
ffffffffc02041a8:	00012717          	auipc	a4,0x12
ffffffffc02041ac:	3c073703          	ld	a4,960(a4) # ffffffffc0216568 <max_swap_offset>
ffffffffc02041b0:	04e7f563          	bgeu	a5,a4,ffffffffc02041fa <swapfs_write+0x5c>
ffffffffc02041b4:	00012617          	auipc	a2,0x12
ffffffffc02041b8:	3e463603          	ld	a2,996(a2) # ffffffffc0216598 <pages>
ffffffffc02041bc:	8d91                	sub	a1,a1,a2
ffffffffc02041be:	4065d613          	srai	a2,a1,0x6
ffffffffc02041c2:	00003717          	auipc	a4,0x3
ffffffffc02041c6:	eb673703          	ld	a4,-330(a4) # ffffffffc0207078 <nbase>
ffffffffc02041ca:	963a                	add	a2,a2,a4
ffffffffc02041cc:	00c61713          	slli	a4,a2,0xc
ffffffffc02041d0:	8331                	srli	a4,a4,0xc
ffffffffc02041d2:	00012697          	auipc	a3,0x12
ffffffffc02041d6:	3be6b683          	ld	a3,958(a3) # ffffffffc0216590 <npage>
ffffffffc02041da:	0037959b          	slliw	a1,a5,0x3
ffffffffc02041de:	0632                	slli	a2,a2,0xc
ffffffffc02041e0:	02d77963          	bgeu	a4,a3,ffffffffc0204212 <swapfs_write+0x74>
ffffffffc02041e4:	60a2                	ld	ra,8(sp)
ffffffffc02041e6:	00012797          	auipc	a5,0x12
ffffffffc02041ea:	3c27b783          	ld	a5,962(a5) # ffffffffc02165a8 <va_pa_offset>
ffffffffc02041ee:	46a1                	li	a3,8
ffffffffc02041f0:	963e                	add	a2,a2,a5
ffffffffc02041f2:	4505                	li	a0,1
ffffffffc02041f4:	0141                	addi	sp,sp,16
ffffffffc02041f6:	adefc06f          	j	ffffffffc02004d4 <ide_write_secs>
ffffffffc02041fa:	86aa                	mv	a3,a0
ffffffffc02041fc:	00003617          	auipc	a2,0x3
ffffffffc0204200:	a6460613          	addi	a2,a2,-1436 # ffffffffc0206c60 <default_pmm_manager+0x5c0>
ffffffffc0204204:	45e5                	li	a1,25
ffffffffc0204206:	00003517          	auipc	a0,0x3
ffffffffc020420a:	a4250513          	addi	a0,a0,-1470 # ffffffffc0206c48 <default_pmm_manager+0x5a8>
ffffffffc020420e:	fbbfb0ef          	jal	ra,ffffffffc02001c8 <__panic>
ffffffffc0204212:	86b2                	mv	a3,a2
ffffffffc0204214:	06900593          	li	a1,105
ffffffffc0204218:	00002617          	auipc	a2,0x2
ffffffffc020421c:	94060613          	addi	a2,a2,-1728 # ffffffffc0205b58 <commands+0x980>
ffffffffc0204220:	00002517          	auipc	a0,0x2
ffffffffc0204224:	92850513          	addi	a0,a0,-1752 # ffffffffc0205b48 <commands+0x970>
ffffffffc0204228:	fa1fb0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020422c <switch_to>:
ffffffffc020422c:	00153023          	sd	ra,0(a0)
ffffffffc0204230:	00253423          	sd	sp,8(a0)
ffffffffc0204234:	e900                	sd	s0,16(a0)
ffffffffc0204236:	ed04                	sd	s1,24(a0)
ffffffffc0204238:	03253023          	sd	s2,32(a0)
ffffffffc020423c:	03353423          	sd	s3,40(a0)
ffffffffc0204240:	03453823          	sd	s4,48(a0)
ffffffffc0204244:	03553c23          	sd	s5,56(a0)
ffffffffc0204248:	05653023          	sd	s6,64(a0)
ffffffffc020424c:	05753423          	sd	s7,72(a0)
ffffffffc0204250:	05853823          	sd	s8,80(a0)
ffffffffc0204254:	05953c23          	sd	s9,88(a0)
ffffffffc0204258:	07a53023          	sd	s10,96(a0)
ffffffffc020425c:	07b53423          	sd	s11,104(a0)
ffffffffc0204260:	0005b083          	ld	ra,0(a1)
ffffffffc0204264:	0085b103          	ld	sp,8(a1)
ffffffffc0204268:	6980                	ld	s0,16(a1)
ffffffffc020426a:	6d84                	ld	s1,24(a1)
ffffffffc020426c:	0205b903          	ld	s2,32(a1)
ffffffffc0204270:	0285b983          	ld	s3,40(a1)
ffffffffc0204274:	0305ba03          	ld	s4,48(a1)
ffffffffc0204278:	0385ba83          	ld	s5,56(a1)
ffffffffc020427c:	0405bb03          	ld	s6,64(a1)
ffffffffc0204280:	0485bb83          	ld	s7,72(a1)
ffffffffc0204284:	0505bc03          	ld	s8,80(a1)
ffffffffc0204288:	0585bc83          	ld	s9,88(a1)
ffffffffc020428c:	0605bd03          	ld	s10,96(a1)
ffffffffc0204290:	0685bd83          	ld	s11,104(a1)
ffffffffc0204294:	8082                	ret

ffffffffc0204296 <kernel_thread_entry>:
ffffffffc0204296:	8526                	mv	a0,s1
ffffffffc0204298:	9402                	jalr	s0
ffffffffc020429a:	496000ef          	jal	ra,ffffffffc0204730 <do_exit>

ffffffffc020429e <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc020429e:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02042a0:	0e800513          	li	a0,232
alloc_proc(void) {
ffffffffc02042a4:	e022                	sd	s0,0(sp)
ffffffffc02042a6:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02042a8:	f96fd0ef          	jal	ra,ffffffffc0201a3e <kmalloc>
ffffffffc02042ac:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc02042ae:	c521                	beqz	a0,ffffffffc02042f6 <alloc_proc+0x58>
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */

        proc->state = PROC_UNINIT;
ffffffffc02042b0:	57fd                	li	a5,-1
ffffffffc02042b2:	1782                	slli	a5,a5,0x20
ffffffffc02042b4:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02042b6:	07000613          	li	a2,112
ffffffffc02042ba:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc02042bc:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc02042c0:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02042c4:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc02042c8:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02042cc:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02042d0:	03050513          	addi	a0,a0,48
ffffffffc02042d4:	025000ef          	jal	ra,ffffffffc0204af8 <memset>
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
ffffffffc02042d8:	00012797          	auipc	a5,0x12
ffffffffc02042dc:	2a87b783          	ld	a5,680(a5) # ffffffffc0216580 <boot_cr3>
        proc->tf = NULL;
ffffffffc02042e0:	0a043023          	sd	zero,160(s0)
        proc->cr3 = boot_cr3;
ffffffffc02042e4:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc02042e6:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc02042ea:	4641                	li	a2,16
ffffffffc02042ec:	4581                	li	a1,0
ffffffffc02042ee:	0b440513          	addi	a0,s0,180
ffffffffc02042f2:	007000ef          	jal	ra,ffffffffc0204af8 <memset>
    }
    return proc;
}
ffffffffc02042f6:	60a2                	ld	ra,8(sp)
ffffffffc02042f8:	8522                	mv	a0,s0
ffffffffc02042fa:	6402                	ld	s0,0(sp)
ffffffffc02042fc:	0141                	addi	sp,sp,16
ffffffffc02042fe:	8082                	ret

ffffffffc0204300 <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc0204300:	00012797          	auipc	a5,0x12
ffffffffc0204304:	2b07b783          	ld	a5,688(a5) # ffffffffc02165b0 <current>
ffffffffc0204308:	73c8                	ld	a0,160(a5)
ffffffffc020430a:	863fc06f          	j	ffffffffc0200b6c <forkrets>

ffffffffc020430e <init_main>:
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc020430e:	7179                	addi	sp,sp,-48
ffffffffc0204310:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0204312:	00012497          	auipc	s1,0x12
ffffffffc0204316:	20648493          	addi	s1,s1,518 # ffffffffc0216518 <name.2>
init_main(void *arg) {
ffffffffc020431a:	f022                	sd	s0,32(sp)
ffffffffc020431c:	e84a                	sd	s2,16(sp)
ffffffffc020431e:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204320:	00012917          	auipc	s2,0x12
ffffffffc0204324:	29093903          	ld	s2,656(s2) # ffffffffc02165b0 <current>
    memset(name, 0, sizeof(name));
ffffffffc0204328:	4641                	li	a2,16
ffffffffc020432a:	4581                	li	a1,0
ffffffffc020432c:	8526                	mv	a0,s1
init_main(void *arg) {
ffffffffc020432e:	f406                	sd	ra,40(sp)
ffffffffc0204330:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204332:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc0204336:	7c2000ef          	jal	ra,ffffffffc0204af8 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc020433a:	0b490593          	addi	a1,s2,180
ffffffffc020433e:	463d                	li	a2,15
ffffffffc0204340:	8526                	mv	a0,s1
ffffffffc0204342:	7c8000ef          	jal	ra,ffffffffc0204b0a <memcpy>
ffffffffc0204346:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204348:	85ce                	mv	a1,s3
ffffffffc020434a:	00003517          	auipc	a0,0x3
ffffffffc020434e:	93650513          	addi	a0,a0,-1738 # ffffffffc0206c80 <default_pmm_manager+0x5e0>
ffffffffc0204352:	d7bfb0ef          	jal	ra,ffffffffc02000cc <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc0204356:	85a2                	mv	a1,s0
ffffffffc0204358:	00003517          	auipc	a0,0x3
ffffffffc020435c:	95050513          	addi	a0,a0,-1712 # ffffffffc0206ca8 <default_pmm_manager+0x608>
ffffffffc0204360:	d6dfb0ef          	jal	ra,ffffffffc02000cc <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc0204364:	00003517          	auipc	a0,0x3
ffffffffc0204368:	95450513          	addi	a0,a0,-1708 # ffffffffc0206cb8 <default_pmm_manager+0x618>
ffffffffc020436c:	d61fb0ef          	jal	ra,ffffffffc02000cc <cprintf>
    return 0;
}
ffffffffc0204370:	70a2                	ld	ra,40(sp)
ffffffffc0204372:	7402                	ld	s0,32(sp)
ffffffffc0204374:	64e2                	ld	s1,24(sp)
ffffffffc0204376:	6942                	ld	s2,16(sp)
ffffffffc0204378:	69a2                	ld	s3,8(sp)
ffffffffc020437a:	4501                	li	a0,0
ffffffffc020437c:	6145                	addi	sp,sp,48
ffffffffc020437e:	8082                	ret

ffffffffc0204380 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc0204380:	7179                	addi	sp,sp,-48
ffffffffc0204382:	ec4a                	sd	s2,24(sp)
    if (proc != current) { 
ffffffffc0204384:	00012917          	auipc	s2,0x12
ffffffffc0204388:	22c90913          	addi	s2,s2,556 # ffffffffc02165b0 <current>
proc_run(struct proc_struct *proc) {
ffffffffc020438c:	f026                	sd	s1,32(sp)
    if (proc != current) { 
ffffffffc020438e:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc0204392:	f406                	sd	ra,40(sp)
ffffffffc0204394:	e84e                	sd	s3,16(sp)
    if (proc != current) { 
ffffffffc0204396:	02a48963          	beq	s1,a0,ffffffffc02043c8 <proc_run+0x48>
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020439a:	100027f3          	csrr	a5,sstatus
ffffffffc020439e:	8b89                	andi	a5,a5,2
        intr_disable();
        return 1;
    }
    return 0;
ffffffffc02043a0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02043a2:	e3a1                	bnez	a5,ffffffffc02043e2 <proc_run+0x62>
            lcr3(next->cr3);
ffffffffc02043a4:	755c                	ld	a5,168(a0)

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned int cr3) {
    write_csr(sptbr, SATP32_MODE | (cr3 >> RISCV_PGSHIFT));
ffffffffc02043a6:	80000737          	lui	a4,0x80000
            current = proc;
ffffffffc02043aa:	00a93023          	sd	a0,0(s2)
ffffffffc02043ae:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc02043b2:	8fd9                	or	a5,a5,a4
ffffffffc02043b4:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc02043b8:	03050593          	addi	a1,a0,48
ffffffffc02043bc:	03048513          	addi	a0,s1,48
ffffffffc02043c0:	e6dff0ef          	jal	ra,ffffffffc020422c <switch_to>
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02043c4:	00099863          	bnez	s3,ffffffffc02043d4 <proc_run+0x54>
}
ffffffffc02043c8:	70a2                	ld	ra,40(sp)
ffffffffc02043ca:	7482                	ld	s1,32(sp)
ffffffffc02043cc:	6962                	ld	s2,24(sp)
ffffffffc02043ce:	69c2                	ld	s3,16(sp)
ffffffffc02043d0:	6145                	addi	sp,sp,48
ffffffffc02043d2:	8082                	ret
ffffffffc02043d4:	70a2                	ld	ra,40(sp)
ffffffffc02043d6:	7482                	ld	s1,32(sp)
ffffffffc02043d8:	6962                	ld	s2,24(sp)
ffffffffc02043da:	69c2                	ld	s3,16(sp)
ffffffffc02043dc:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02043de:	9e0fc06f          	j	ffffffffc02005be <intr_enable>
ffffffffc02043e2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02043e4:	9e0fc0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
        return 1;
ffffffffc02043e8:	6522                	ld	a0,8(sp)
ffffffffc02043ea:	4985                	li	s3,1
ffffffffc02043ec:	bf65                	j	ffffffffc02043a4 <proc_run+0x24>

ffffffffc02043ee <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc02043ee:	7179                	addi	sp,sp,-48
ffffffffc02043f0:	ec26                	sd	s1,24(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc02043f2:	00012497          	auipc	s1,0x12
ffffffffc02043f6:	1d648493          	addi	s1,s1,470 # ffffffffc02165c8 <nr_process>
ffffffffc02043fa:	4098                	lw	a4,0(s1)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc02043fc:	f406                	sd	ra,40(sp)
ffffffffc02043fe:	f022                	sd	s0,32(sp)
ffffffffc0204400:	e84a                	sd	s2,16(sp)
ffffffffc0204402:	e44e                	sd	s3,8(sp)
ffffffffc0204404:	e052                	sd	s4,0(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204406:	6785                	lui	a5,0x1
ffffffffc0204408:	26f75163          	bge	a4,a5,ffffffffc020466a <do_fork+0x27c>
ffffffffc020440c:	892e                	mv	s2,a1
ffffffffc020440e:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc0204410:	e8fff0ef          	jal	ra,ffffffffc020429e <alloc_proc>
ffffffffc0204414:	89aa                	mv	s3,a0
    if (!proc) {
ffffffffc0204416:	24050f63          	beqz	a0,ffffffffc0204674 <do_fork+0x286>
    proc->parent = current;//将子进程的父节点设置为当前进程
ffffffffc020441a:	00012a17          	auipc	s4,0x12
ffffffffc020441e:	196a0a13          	addi	s4,s4,406 # ffffffffc02165b0 <current>
ffffffffc0204422:	000a3783          	ld	a5,0(s4)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204426:	4509                	li	a0,2
    proc->parent = current;//将子进程的父节点设置为当前进程
ffffffffc0204428:	02f9b023          	sd	a5,32(s3)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020442c:	b91fe0ef          	jal	ra,ffffffffc0202fbc <alloc_pages>
    if (page != NULL) {
ffffffffc0204430:	1e050763          	beqz	a0,ffffffffc020461e <do_fork+0x230>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0204434:	00012697          	auipc	a3,0x12
ffffffffc0204438:	1646b683          	ld	a3,356(a3) # ffffffffc0216598 <pages>
ffffffffc020443c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204440:	8699                	srai	a3,a3,0x6
ffffffffc0204442:	00003517          	auipc	a0,0x3
ffffffffc0204446:	c3653503          	ld	a0,-970(a0) # ffffffffc0207078 <nbase>
ffffffffc020444a:	96aa                	add	a3,a3,a0
    return &pages[PPN(pa) - nbase];
}

static inline void *
page2kva(struct Page *page) {
    return KADDR(page2pa(page));
ffffffffc020444c:	00c69793          	slli	a5,a3,0xc
ffffffffc0204450:	83b1                	srli	a5,a5,0xc
ffffffffc0204452:	00012717          	auipc	a4,0x12
ffffffffc0204456:	13e73703          	ld	a4,318(a4) # ffffffffc0216590 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc020445a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020445c:	22e7fe63          	bgeu	a5,a4,ffffffffc0204698 <do_fork+0x2aa>
    assert(current->mm == NULL);
ffffffffc0204460:	000a3783          	ld	a5,0(s4)
ffffffffc0204464:	00012717          	auipc	a4,0x12
ffffffffc0204468:	14473703          	ld	a4,324(a4) # ffffffffc02165a8 <va_pa_offset>
ffffffffc020446c:	96ba                	add	a3,a3,a4
ffffffffc020446e:	779c                	ld	a5,40(a5)
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204470:	00d9b823          	sd	a3,16(s3)
    assert(current->mm == NULL);
ffffffffc0204474:	20079263          	bnez	a5,ffffffffc0204678 <do_fork+0x28a>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204478:	6789                	lui	a5,0x2
ffffffffc020447a:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc020447e:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204480:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204482:	0ad9b023          	sd	a3,160(s3)
    *(proc->tf) = *tf;
ffffffffc0204486:	87b6                	mv	a5,a3
ffffffffc0204488:	12040893          	addi	a7,s0,288
ffffffffc020448c:	00063803          	ld	a6,0(a2)
ffffffffc0204490:	6608                	ld	a0,8(a2)
ffffffffc0204492:	6a0c                	ld	a1,16(a2)
ffffffffc0204494:	6e18                	ld	a4,24(a2)
ffffffffc0204496:	0107b023          	sd	a6,0(a5)
ffffffffc020449a:	e788                	sd	a0,8(a5)
ffffffffc020449c:	eb8c                	sd	a1,16(a5)
ffffffffc020449e:	ef98                	sd	a4,24(a5)
ffffffffc02044a0:	02060613          	addi	a2,a2,32
ffffffffc02044a4:	02078793          	addi	a5,a5,32
ffffffffc02044a8:	ff1612e3          	bne	a2,a7,ffffffffc020448c <do_fork+0x9e>
    proc->tf->gpr.a0 = 0;
ffffffffc02044ac:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02044b0:	12090563          	beqz	s2,ffffffffc02045da <do_fork+0x1ec>
ffffffffc02044b4:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02044b8:	00000797          	auipc	a5,0x0
ffffffffc02044bc:	e4878793          	addi	a5,a5,-440 # ffffffffc0204300 <forkret>
ffffffffc02044c0:	02f9b823          	sd	a5,48(s3)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02044c4:	02d9bc23          	sd	a3,56(s3)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02044c8:	100027f3          	csrr	a5,sstatus
ffffffffc02044cc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02044ce:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02044d0:	12079663          	bnez	a5,ffffffffc02045fc <do_fork+0x20e>
    if (++ last_pid >= MAX_PID) {
ffffffffc02044d4:	00007817          	auipc	a6,0x7
ffffffffc02044d8:	b8480813          	addi	a6,a6,-1148 # ffffffffc020b058 <last_pid.1>
ffffffffc02044dc:	00082783          	lw	a5,0(a6)
ffffffffc02044e0:	6709                	lui	a4,0x2
ffffffffc02044e2:	0017851b          	addiw	a0,a5,1
ffffffffc02044e6:	00a82023          	sw	a0,0(a6)
ffffffffc02044ea:	08e55163          	bge	a0,a4,ffffffffc020456c <do_fork+0x17e>
    if (last_pid >= next_safe) {
ffffffffc02044ee:	00007317          	auipc	t1,0x7
ffffffffc02044f2:	b6e30313          	addi	t1,t1,-1170 # ffffffffc020b05c <next_safe.0>
ffffffffc02044f6:	00032783          	lw	a5,0(t1)
ffffffffc02044fa:	00012417          	auipc	s0,0x12
ffffffffc02044fe:	02e40413          	addi	s0,s0,46 # ffffffffc0216528 <proc_list>
ffffffffc0204502:	06f55d63          	bge	a0,a5,ffffffffc020457c <do_fork+0x18e>
    proc->pid = get_pid();//获取当前进程PID
ffffffffc0204506:	00a9a223          	sw	a0,4(s3)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020450a:	45a9                	li	a1,10
ffffffffc020450c:	2501                	sext.w	a0,a0
ffffffffc020450e:	227000ef          	jal	ra,ffffffffc0204f34 <hash32>
ffffffffc0204512:	02051793          	slli	a5,a0,0x20
ffffffffc0204516:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020451a:	0000e797          	auipc	a5,0xe
ffffffffc020451e:	ffe78793          	addi	a5,a5,-2 # ffffffffc0212518 <hash_list>
ffffffffc0204522:	953e                	add	a0,a0,a5
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc0204524:	6510                	ld	a2,8(a0)
ffffffffc0204526:	0d898793          	addi	a5,s3,216
ffffffffc020452a:	6414                	ld	a3,8(s0)
    nr_process ++;//进程数加一
ffffffffc020452c:	4098                	lw	a4,0(s1)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020452e:	e21c                	sd	a5,0(a2)
ffffffffc0204530:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc0204532:	0ec9b023          	sd	a2,224(s3)
    list_add(&proc_list, &(proc->list_link));//加入进程链表
ffffffffc0204536:	0c898793          	addi	a5,s3,200
    elm->prev = prev;
ffffffffc020453a:	0ca9bc23          	sd	a0,216(s3)
    prev->next = next->prev = elm;
ffffffffc020453e:	e29c                	sd	a5,0(a3)
    nr_process ++;//进程数加一
ffffffffc0204540:	2705                	addiw	a4,a4,1
ffffffffc0204542:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204544:	0cd9b823          	sd	a3,208(s3)
    elm->prev = prev;
ffffffffc0204548:	0c89b423          	sd	s0,200(s3)
ffffffffc020454c:	c098                	sw	a4,0(s1)
    if (flag) {
ffffffffc020454e:	0a091b63          	bnez	s2,ffffffffc0204604 <do_fork+0x216>
    wakeup_proc(proc);
ffffffffc0204552:	854e                	mv	a0,s3
ffffffffc0204554:	462000ef          	jal	ra,ffffffffc02049b6 <wakeup_proc>
    ret = proc->pid;
ffffffffc0204558:	0049a503          	lw	a0,4(s3)
}
ffffffffc020455c:	70a2                	ld	ra,40(sp)
ffffffffc020455e:	7402                	ld	s0,32(sp)
ffffffffc0204560:	64e2                	ld	s1,24(sp)
ffffffffc0204562:	6942                	ld	s2,16(sp)
ffffffffc0204564:	69a2                	ld	s3,8(sp)
ffffffffc0204566:	6a02                	ld	s4,0(sp)
ffffffffc0204568:	6145                	addi	sp,sp,48
ffffffffc020456a:	8082                	ret
        last_pid = 1;
ffffffffc020456c:	4785                	li	a5,1
ffffffffc020456e:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0204572:	4505                	li	a0,1
ffffffffc0204574:	00007317          	auipc	t1,0x7
ffffffffc0204578:	ae830313          	addi	t1,t1,-1304 # ffffffffc020b05c <next_safe.0>
    return listelm->next;
ffffffffc020457c:	00012417          	auipc	s0,0x12
ffffffffc0204580:	fac40413          	addi	s0,s0,-84 # ffffffffc0216528 <proc_list>
ffffffffc0204584:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0204588:	6789                	lui	a5,0x2
ffffffffc020458a:	00f32023          	sw	a5,0(t1)
ffffffffc020458e:	86aa                	mv	a3,a0
ffffffffc0204590:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc0204592:	6e89                	lui	t4,0x2
ffffffffc0204594:	088e0063          	beq	t3,s0,ffffffffc0204614 <do_fork+0x226>
ffffffffc0204598:	88ae                	mv	a7,a1
ffffffffc020459a:	87f2                	mv	a5,t3
ffffffffc020459c:	6609                	lui	a2,0x2
ffffffffc020459e:	a811                	j	ffffffffc02045b2 <do_fork+0x1c4>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02045a0:	00e6d663          	bge	a3,a4,ffffffffc02045ac <do_fork+0x1be>
ffffffffc02045a4:	00c75463          	bge	a4,a2,ffffffffc02045ac <do_fork+0x1be>
ffffffffc02045a8:	863a                	mv	a2,a4
ffffffffc02045aa:	4885                	li	a7,1
ffffffffc02045ac:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02045ae:	00878d63          	beq	a5,s0,ffffffffc02045c8 <do_fork+0x1da>
            if (proc->pid == last_pid) {
ffffffffc02045b2:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc02045b6:	fed715e3          	bne	a4,a3,ffffffffc02045a0 <do_fork+0x1b2>
                if (++ last_pid >= next_safe) {
ffffffffc02045ba:	2685                	addiw	a3,a3,1
ffffffffc02045bc:	04c6d763          	bge	a3,a2,ffffffffc020460a <do_fork+0x21c>
ffffffffc02045c0:	679c                	ld	a5,8(a5)
ffffffffc02045c2:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc02045c4:	fe8797e3          	bne	a5,s0,ffffffffc02045b2 <do_fork+0x1c4>
ffffffffc02045c8:	c581                	beqz	a1,ffffffffc02045d0 <do_fork+0x1e2>
ffffffffc02045ca:	00d82023          	sw	a3,0(a6)
ffffffffc02045ce:	8536                	mv	a0,a3
ffffffffc02045d0:	f2088be3          	beqz	a7,ffffffffc0204506 <do_fork+0x118>
ffffffffc02045d4:	00c32023          	sw	a2,0(t1)
ffffffffc02045d8:	b73d                	j	ffffffffc0204506 <do_fork+0x118>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02045da:	8936                	mv	s2,a3
ffffffffc02045dc:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02045e0:	00000797          	auipc	a5,0x0
ffffffffc02045e4:	d2078793          	addi	a5,a5,-736 # ffffffffc0204300 <forkret>
ffffffffc02045e8:	02f9b823          	sd	a5,48(s3)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02045ec:	02d9bc23          	sd	a3,56(s3)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02045f0:	100027f3          	csrr	a5,sstatus
ffffffffc02045f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02045f6:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02045f8:	ec078ee3          	beqz	a5,ffffffffc02044d4 <do_fork+0xe6>
        intr_disable();
ffffffffc02045fc:	fc9fb0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
        return 1;
ffffffffc0204600:	4905                	li	s2,1
ffffffffc0204602:	bdc9                	j	ffffffffc02044d4 <do_fork+0xe6>
        intr_enable();
ffffffffc0204604:	fbbfb0ef          	jal	ra,ffffffffc02005be <intr_enable>
ffffffffc0204608:	b7a9                	j	ffffffffc0204552 <do_fork+0x164>
                    if (last_pid >= MAX_PID) {
ffffffffc020460a:	01d6c363          	blt	a3,t4,ffffffffc0204610 <do_fork+0x222>
                        last_pid = 1;
ffffffffc020460e:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204610:	4585                	li	a1,1
ffffffffc0204612:	b749                	j	ffffffffc0204594 <do_fork+0x1a6>
ffffffffc0204614:	cda9                	beqz	a1,ffffffffc020466e <do_fork+0x280>
ffffffffc0204616:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020461a:	8536                	mv	a0,a3
ffffffffc020461c:	b5ed                	j	ffffffffc0204506 <do_fork+0x118>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020461e:	0109b683          	ld	a3,16(s3)
}

static inline struct Page *
kva2page(void *kva) {
    return pa2page(PADDR(kva));
ffffffffc0204622:	c02007b7          	lui	a5,0xc0200
ffffffffc0204626:	0af6e163          	bltu	a3,a5,ffffffffc02046c8 <do_fork+0x2da>
ffffffffc020462a:	00012797          	auipc	a5,0x12
ffffffffc020462e:	f7e7b783          	ld	a5,-130(a5) # ffffffffc02165a8 <va_pa_offset>
ffffffffc0204632:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0204636:	83b1                	srli	a5,a5,0xc
ffffffffc0204638:	00012717          	auipc	a4,0x12
ffffffffc020463c:	f5873703          	ld	a4,-168(a4) # ffffffffc0216590 <npage>
ffffffffc0204640:	06e7f863          	bgeu	a5,a4,ffffffffc02046b0 <do_fork+0x2c2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204644:	00003717          	auipc	a4,0x3
ffffffffc0204648:	a3473703          	ld	a4,-1484(a4) # ffffffffc0207078 <nbase>
ffffffffc020464c:	8f99                	sub	a5,a5,a4
ffffffffc020464e:	079a                	slli	a5,a5,0x6
ffffffffc0204650:	00012517          	auipc	a0,0x12
ffffffffc0204654:	f4853503          	ld	a0,-184(a0) # ffffffffc0216598 <pages>
ffffffffc0204658:	953e                	add	a0,a0,a5
ffffffffc020465a:	4589                	li	a1,2
ffffffffc020465c:	9f3fe0ef          	jal	ra,ffffffffc020304e <free_pages>
    kfree(proc);
ffffffffc0204660:	854e                	mv	a0,s3
ffffffffc0204662:	c8cfd0ef          	jal	ra,ffffffffc0201aee <kfree>
    ret = -E_NO_MEM;
ffffffffc0204666:	5571                	li	a0,-4
    goto fork_out;
ffffffffc0204668:	bdd5                	j	ffffffffc020455c <do_fork+0x16e>
    int ret = -E_NO_FREE_PROC;
ffffffffc020466a:	556d                	li	a0,-5
ffffffffc020466c:	bdc5                	j	ffffffffc020455c <do_fork+0x16e>
    return last_pid;
ffffffffc020466e:	00082503          	lw	a0,0(a6)
ffffffffc0204672:	bd51                	j	ffffffffc0204506 <do_fork+0x118>
    ret = -E_NO_MEM;
ffffffffc0204674:	5571                	li	a0,-4
    return ret;
ffffffffc0204676:	b5dd                	j	ffffffffc020455c <do_fork+0x16e>
    assert(current->mm == NULL);
ffffffffc0204678:	00002697          	auipc	a3,0x2
ffffffffc020467c:	66068693          	addi	a3,a3,1632 # ffffffffc0206cd8 <default_pmm_manager+0x638>
ffffffffc0204680:	00001617          	auipc	a2,0x1
ffffffffc0204684:	28060613          	addi	a2,a2,640 # ffffffffc0205900 <commands+0x728>
ffffffffc0204688:	10b00593          	li	a1,267
ffffffffc020468c:	00002517          	auipc	a0,0x2
ffffffffc0204690:	66450513          	addi	a0,a0,1636 # ffffffffc0206cf0 <default_pmm_manager+0x650>
ffffffffc0204694:	b35fb0ef          	jal	ra,ffffffffc02001c8 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204698:	00001617          	auipc	a2,0x1
ffffffffc020469c:	4c060613          	addi	a2,a2,1216 # ffffffffc0205b58 <commands+0x980>
ffffffffc02046a0:	06900593          	li	a1,105
ffffffffc02046a4:	00001517          	auipc	a0,0x1
ffffffffc02046a8:	4a450513          	addi	a0,a0,1188 # ffffffffc0205b48 <commands+0x970>
ffffffffc02046ac:	b1dfb0ef          	jal	ra,ffffffffc02001c8 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02046b0:	00001617          	auipc	a2,0x1
ffffffffc02046b4:	47860613          	addi	a2,a2,1144 # ffffffffc0205b28 <commands+0x950>
ffffffffc02046b8:	06200593          	li	a1,98
ffffffffc02046bc:	00001517          	auipc	a0,0x1
ffffffffc02046c0:	48c50513          	addi	a0,a0,1164 # ffffffffc0205b48 <commands+0x970>
ffffffffc02046c4:	b05fb0ef          	jal	ra,ffffffffc02001c8 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02046c8:	00002617          	auipc	a2,0x2
ffffffffc02046cc:	88860613          	addi	a2,a2,-1912 # ffffffffc0205f50 <commands+0xd78>
ffffffffc02046d0:	06e00593          	li	a1,110
ffffffffc02046d4:	00001517          	auipc	a0,0x1
ffffffffc02046d8:	47450513          	addi	a0,a0,1140 # ffffffffc0205b48 <commands+0x970>
ffffffffc02046dc:	aedfb0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc02046e0 <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02046e0:	7129                	addi	sp,sp,-320
ffffffffc02046e2:	fa22                	sd	s0,304(sp)
ffffffffc02046e4:	f626                	sd	s1,296(sp)
ffffffffc02046e6:	f24a                	sd	s2,288(sp)
ffffffffc02046e8:	84ae                	mv	s1,a1
ffffffffc02046ea:	892a                	mv	s2,a0
ffffffffc02046ec:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046ee:	4581                	li	a1,0
ffffffffc02046f0:	12000613          	li	a2,288
ffffffffc02046f4:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02046f6:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046f8:	400000ef          	jal	ra,ffffffffc0204af8 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02046fc:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02046fe:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204700:	100027f3          	csrr	a5,sstatus
ffffffffc0204704:	edd7f793          	andi	a5,a5,-291
ffffffffc0204708:	1207e793          	ori	a5,a5,288
ffffffffc020470c:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020470e:	860a                	mv	a2,sp
ffffffffc0204710:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204714:	00000797          	auipc	a5,0x0
ffffffffc0204718:	b8278793          	addi	a5,a5,-1150 # ffffffffc0204296 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020471c:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020471e:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204720:	ccfff0ef          	jal	ra,ffffffffc02043ee <do_fork>
}
ffffffffc0204724:	70f2                	ld	ra,312(sp)
ffffffffc0204726:	7452                	ld	s0,304(sp)
ffffffffc0204728:	74b2                	ld	s1,296(sp)
ffffffffc020472a:	7912                	ld	s2,288(sp)
ffffffffc020472c:	6131                	addi	sp,sp,320
ffffffffc020472e:	8082                	ret

ffffffffc0204730 <do_exit>:
do_exit(int error_code) {
ffffffffc0204730:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc0204732:	00002617          	auipc	a2,0x2
ffffffffc0204736:	5d660613          	addi	a2,a2,1494 # ffffffffc0206d08 <default_pmm_manager+0x668>
ffffffffc020473a:	17e00593          	li	a1,382
ffffffffc020473e:	00002517          	auipc	a0,0x2
ffffffffc0204742:	5b250513          	addi	a0,a0,1458 # ffffffffc0206cf0 <default_pmm_manager+0x650>
do_exit(int error_code) {
ffffffffc0204746:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0204748:	a81fb0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020474c <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc020474c:	7179                	addi	sp,sp,-48
ffffffffc020474e:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0204750:	00012797          	auipc	a5,0x12
ffffffffc0204754:	dd878793          	addi	a5,a5,-552 # ffffffffc0216528 <proc_list>
ffffffffc0204758:	f406                	sd	ra,40(sp)
ffffffffc020475a:	f022                	sd	s0,32(sp)
ffffffffc020475c:	e84a                	sd	s2,16(sp)
ffffffffc020475e:	e44e                	sd	s3,8(sp)
ffffffffc0204760:	0000e497          	auipc	s1,0xe
ffffffffc0204764:	db848493          	addi	s1,s1,-584 # ffffffffc0212518 <hash_list>
ffffffffc0204768:	e79c                	sd	a5,8(a5)
ffffffffc020476a:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc020476c:	00012717          	auipc	a4,0x12
ffffffffc0204770:	dac70713          	addi	a4,a4,-596 # ffffffffc0216518 <name.2>
ffffffffc0204774:	87a6                	mv	a5,s1
ffffffffc0204776:	e79c                	sd	a5,8(a5)
ffffffffc0204778:	e39c                	sd	a5,0(a5)
ffffffffc020477a:	07c1                	addi	a5,a5,16
ffffffffc020477c:	fef71de3          	bne	a4,a5,ffffffffc0204776 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204780:	b1fff0ef          	jal	ra,ffffffffc020429e <alloc_proc>
ffffffffc0204784:	00012917          	auipc	s2,0x12
ffffffffc0204788:	e3490913          	addi	s2,s2,-460 # ffffffffc02165b8 <idleproc>
ffffffffc020478c:	00a93023          	sd	a0,0(s2)
ffffffffc0204790:	18050d63          	beqz	a0,ffffffffc020492a <proc_init+0x1de>
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204794:	07000513          	li	a0,112
ffffffffc0204798:	aa6fd0ef          	jal	ra,ffffffffc0201a3e <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020479c:	07000613          	li	a2,112
ffffffffc02047a0:	4581                	li	a1,0
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc02047a2:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02047a4:	354000ef          	jal	ra,ffffffffc0204af8 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc02047a8:	00093503          	ld	a0,0(s2)
ffffffffc02047ac:	85a2                	mv	a1,s0
ffffffffc02047ae:	07000613          	li	a2,112
ffffffffc02047b2:	03050513          	addi	a0,a0,48
ffffffffc02047b6:	36c000ef          	jal	ra,ffffffffc0204b22 <memcmp>
ffffffffc02047ba:	89aa                	mv	s3,a0

    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc02047bc:	453d                	li	a0,15
ffffffffc02047be:	a80fd0ef          	jal	ra,ffffffffc0201a3e <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02047c2:	463d                	li	a2,15
ffffffffc02047c4:	4581                	li	a1,0
    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc02047c6:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02047c8:	330000ef          	jal	ra,ffffffffc0204af8 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc02047cc:	00093503          	ld	a0,0(s2)
ffffffffc02047d0:	463d                	li	a2,15
ffffffffc02047d2:	85a2                	mv	a1,s0
ffffffffc02047d4:	0b450513          	addi	a0,a0,180
ffffffffc02047d8:	34a000ef          	jal	ra,ffffffffc0204b22 <memcmp>

    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc02047dc:	00093783          	ld	a5,0(s2)
ffffffffc02047e0:	00012717          	auipc	a4,0x12
ffffffffc02047e4:	da073703          	ld	a4,-608(a4) # ffffffffc0216580 <boot_cr3>
ffffffffc02047e8:	77d4                	ld	a3,168(a5)
ffffffffc02047ea:	0ee68463          	beq	a3,a4,ffffffffc02048d2 <proc_init+0x186>
        cprintf("alloc_proc() correct!\n");

    }
    
    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02047ee:	4709                	li	a4,2
ffffffffc02047f0:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02047f2:	00004717          	auipc	a4,0x4
ffffffffc02047f6:	80e70713          	addi	a4,a4,-2034 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02047fa:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02047fe:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc0204800:	4705                	li	a4,1
ffffffffc0204802:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204804:	4641                	li	a2,16
ffffffffc0204806:	4581                	li	a1,0
ffffffffc0204808:	8522                	mv	a0,s0
ffffffffc020480a:	2ee000ef          	jal	ra,ffffffffc0204af8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020480e:	463d                	li	a2,15
ffffffffc0204810:	00002597          	auipc	a1,0x2
ffffffffc0204814:	54058593          	addi	a1,a1,1344 # ffffffffc0206d50 <default_pmm_manager+0x6b0>
ffffffffc0204818:	8522                	mv	a0,s0
ffffffffc020481a:	2f0000ef          	jal	ra,ffffffffc0204b0a <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc020481e:	00012717          	auipc	a4,0x12
ffffffffc0204822:	daa70713          	addi	a4,a4,-598 # ffffffffc02165c8 <nr_process>
ffffffffc0204826:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204828:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020482c:	4601                	li	a2,0
    nr_process ++;
ffffffffc020482e:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0204830:	00002597          	auipc	a1,0x2
ffffffffc0204834:	52858593          	addi	a1,a1,1320 # ffffffffc0206d58 <default_pmm_manager+0x6b8>
ffffffffc0204838:	00000517          	auipc	a0,0x0
ffffffffc020483c:	ad650513          	addi	a0,a0,-1322 # ffffffffc020430e <init_main>
    nr_process ++;
ffffffffc0204840:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204842:	00012797          	auipc	a5,0x12
ffffffffc0204846:	d6d7b723          	sd	a3,-658(a5) # ffffffffc02165b0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020484a:	e97ff0ef          	jal	ra,ffffffffc02046e0 <kernel_thread>
ffffffffc020484e:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc0204850:	0ea05963          	blez	a0,ffffffffc0204942 <proc_init+0x1f6>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0204854:	6789                	lui	a5,0x2
ffffffffc0204856:	fff5071b          	addiw	a4,a0,-1
ffffffffc020485a:	17f9                	addi	a5,a5,-2
ffffffffc020485c:	2501                	sext.w	a0,a0
ffffffffc020485e:	02e7e363          	bltu	a5,a4,ffffffffc0204884 <proc_init+0x138>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204862:	45a9                	li	a1,10
ffffffffc0204864:	6d0000ef          	jal	ra,ffffffffc0204f34 <hash32>
ffffffffc0204868:	02051793          	slli	a5,a0,0x20
ffffffffc020486c:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204870:	96a6                	add	a3,a3,s1
ffffffffc0204872:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204874:	a029                	j	ffffffffc020487e <proc_init+0x132>
            if (proc->pid == pid) {
ffffffffc0204876:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc020487a:	0a870563          	beq	a4,s0,ffffffffc0204924 <proc_init+0x1d8>
    return listelm->next;
ffffffffc020487e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0204880:	fef69be3          	bne	a3,a5,ffffffffc0204876 <proc_init+0x12a>
    return NULL;
ffffffffc0204884:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204886:	0b478493          	addi	s1,a5,180
ffffffffc020488a:	4641                	li	a2,16
ffffffffc020488c:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020488e:	00012417          	auipc	s0,0x12
ffffffffc0204892:	d3240413          	addi	s0,s0,-718 # ffffffffc02165c0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204896:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204898:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020489a:	25e000ef          	jal	ra,ffffffffc0204af8 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020489e:	463d                	li	a2,15
ffffffffc02048a0:	00002597          	auipc	a1,0x2
ffffffffc02048a4:	4e858593          	addi	a1,a1,1256 # ffffffffc0206d88 <default_pmm_manager+0x6e8>
ffffffffc02048a8:	8526                	mv	a0,s1
ffffffffc02048aa:	260000ef          	jal	ra,ffffffffc0204b0a <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02048ae:	00093783          	ld	a5,0(s2)
ffffffffc02048b2:	c7e1                	beqz	a5,ffffffffc020497a <proc_init+0x22e>
ffffffffc02048b4:	43dc                	lw	a5,4(a5)
ffffffffc02048b6:	e3f1                	bnez	a5,ffffffffc020497a <proc_init+0x22e>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02048b8:	601c                	ld	a5,0(s0)
ffffffffc02048ba:	c3c5                	beqz	a5,ffffffffc020495a <proc_init+0x20e>
ffffffffc02048bc:	43d8                	lw	a4,4(a5)
ffffffffc02048be:	4785                	li	a5,1
ffffffffc02048c0:	08f71d63          	bne	a4,a5,ffffffffc020495a <proc_init+0x20e>
}
ffffffffc02048c4:	70a2                	ld	ra,40(sp)
ffffffffc02048c6:	7402                	ld	s0,32(sp)
ffffffffc02048c8:	64e2                	ld	s1,24(sp)
ffffffffc02048ca:	6942                	ld	s2,16(sp)
ffffffffc02048cc:	69a2                	ld	s3,8(sp)
ffffffffc02048ce:	6145                	addi	sp,sp,48
ffffffffc02048d0:	8082                	ret
    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc02048d2:	73d8                	ld	a4,160(a5)
ffffffffc02048d4:	ff09                	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
ffffffffc02048d6:	f0099ce3          	bnez	s3,ffffffffc02047ee <proc_init+0xa2>
        && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0
ffffffffc02048da:	6394                	ld	a3,0(a5)
ffffffffc02048dc:	577d                	li	a4,-1
ffffffffc02048de:	1702                	slli	a4,a4,0x20
ffffffffc02048e0:	f0e697e3          	bne	a3,a4,ffffffffc02047ee <proc_init+0xa2>
ffffffffc02048e4:	4798                	lw	a4,8(a5)
ffffffffc02048e6:	f00714e3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
        && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL
ffffffffc02048ea:	6b98                	ld	a4,16(a5)
ffffffffc02048ec:	f00711e3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
ffffffffc02048f0:	4f98                	lw	a4,24(a5)
ffffffffc02048f2:	2701                	sext.w	a4,a4
ffffffffc02048f4:	ee071de3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
ffffffffc02048f8:	7398                	ld	a4,32(a5)
ffffffffc02048fa:	ee071ae3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
        && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag
ffffffffc02048fe:	7798                	ld	a4,40(a5)
ffffffffc0204900:	ee0717e3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
ffffffffc0204904:	0b07a703          	lw	a4,176(a5)
ffffffffc0204908:	8d59                	or	a0,a0,a4
ffffffffc020490a:	0005071b          	sext.w	a4,a0
ffffffffc020490e:	ee0710e3          	bnez	a4,ffffffffc02047ee <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0204912:	00002517          	auipc	a0,0x2
ffffffffc0204916:	42650513          	addi	a0,a0,1062 # ffffffffc0206d38 <default_pmm_manager+0x698>
ffffffffc020491a:	fb2fb0ef          	jal	ra,ffffffffc02000cc <cprintf>
    idleproc->pid = 0;
ffffffffc020491e:	00093783          	ld	a5,0(s2)
ffffffffc0204922:	b5f1                	j	ffffffffc02047ee <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204924:	f2878793          	addi	a5,a5,-216
ffffffffc0204928:	bfb9                	j	ffffffffc0204886 <proc_init+0x13a>
        panic("cannot alloc idleproc.\n");
ffffffffc020492a:	00002617          	auipc	a2,0x2
ffffffffc020492e:	3f660613          	addi	a2,a2,1014 # ffffffffc0206d20 <default_pmm_manager+0x680>
ffffffffc0204932:	19600593          	li	a1,406
ffffffffc0204936:	00002517          	auipc	a0,0x2
ffffffffc020493a:	3ba50513          	addi	a0,a0,954 # ffffffffc0206cf0 <default_pmm_manager+0x650>
ffffffffc020493e:	88bfb0ef          	jal	ra,ffffffffc02001c8 <__panic>
        panic("create init_main failed.\n");
ffffffffc0204942:	00002617          	auipc	a2,0x2
ffffffffc0204946:	42660613          	addi	a2,a2,1062 # ffffffffc0206d68 <default_pmm_manager+0x6c8>
ffffffffc020494a:	1b600593          	li	a1,438
ffffffffc020494e:	00002517          	auipc	a0,0x2
ffffffffc0204952:	3a250513          	addi	a0,a0,930 # ffffffffc0206cf0 <default_pmm_manager+0x650>
ffffffffc0204956:	873fb0ef          	jal	ra,ffffffffc02001c8 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020495a:	00002697          	auipc	a3,0x2
ffffffffc020495e:	45e68693          	addi	a3,a3,1118 # ffffffffc0206db8 <default_pmm_manager+0x718>
ffffffffc0204962:	00001617          	auipc	a2,0x1
ffffffffc0204966:	f9e60613          	addi	a2,a2,-98 # ffffffffc0205900 <commands+0x728>
ffffffffc020496a:	1bd00593          	li	a1,445
ffffffffc020496e:	00002517          	auipc	a0,0x2
ffffffffc0204972:	38250513          	addi	a0,a0,898 # ffffffffc0206cf0 <default_pmm_manager+0x650>
ffffffffc0204976:	853fb0ef          	jal	ra,ffffffffc02001c8 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020497a:	00002697          	auipc	a3,0x2
ffffffffc020497e:	41668693          	addi	a3,a3,1046 # ffffffffc0206d90 <default_pmm_manager+0x6f0>
ffffffffc0204982:	00001617          	auipc	a2,0x1
ffffffffc0204986:	f7e60613          	addi	a2,a2,-130 # ffffffffc0205900 <commands+0x728>
ffffffffc020498a:	1bc00593          	li	a1,444
ffffffffc020498e:	00002517          	auipc	a0,0x2
ffffffffc0204992:	36250513          	addi	a0,a0,866 # ffffffffc0206cf0 <default_pmm_manager+0x650>
ffffffffc0204996:	833fb0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc020499a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc020499a:	1141                	addi	sp,sp,-16
ffffffffc020499c:	e022                	sd	s0,0(sp)
ffffffffc020499e:	e406                	sd	ra,8(sp)
ffffffffc02049a0:	00012417          	auipc	s0,0x12
ffffffffc02049a4:	c1040413          	addi	s0,s0,-1008 # ffffffffc02165b0 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc02049a8:	6018                	ld	a4,0(s0)
ffffffffc02049aa:	4f1c                	lw	a5,24(a4)
ffffffffc02049ac:	2781                	sext.w	a5,a5
ffffffffc02049ae:	dff5                	beqz	a5,ffffffffc02049aa <cpu_idle+0x10>
            schedule();
ffffffffc02049b0:	038000ef          	jal	ra,ffffffffc02049e8 <schedule>
ffffffffc02049b4:	bfd5                	j	ffffffffc02049a8 <cpu_idle+0xe>

ffffffffc02049b6 <wakeup_proc>:
ffffffffc02049b6:	411c                	lw	a5,0(a0)
ffffffffc02049b8:	4705                	li	a4,1
ffffffffc02049ba:	37f9                	addiw	a5,a5,-2
ffffffffc02049bc:	00f77563          	bgeu	a4,a5,ffffffffc02049c6 <wakeup_proc+0x10>
ffffffffc02049c0:	4789                	li	a5,2
ffffffffc02049c2:	c11c                	sw	a5,0(a0)
ffffffffc02049c4:	8082                	ret
ffffffffc02049c6:	1141                	addi	sp,sp,-16
ffffffffc02049c8:	00002697          	auipc	a3,0x2
ffffffffc02049cc:	41868693          	addi	a3,a3,1048 # ffffffffc0206de0 <default_pmm_manager+0x740>
ffffffffc02049d0:	00001617          	auipc	a2,0x1
ffffffffc02049d4:	f3060613          	addi	a2,a2,-208 # ffffffffc0205900 <commands+0x728>
ffffffffc02049d8:	45a5                	li	a1,9
ffffffffc02049da:	00002517          	auipc	a0,0x2
ffffffffc02049de:	44650513          	addi	a0,a0,1094 # ffffffffc0206e20 <default_pmm_manager+0x780>
ffffffffc02049e2:	e406                	sd	ra,8(sp)
ffffffffc02049e4:	fe4fb0ef          	jal	ra,ffffffffc02001c8 <__panic>

ffffffffc02049e8 <schedule>:
ffffffffc02049e8:	1141                	addi	sp,sp,-16
ffffffffc02049ea:	e406                	sd	ra,8(sp)
ffffffffc02049ec:	e022                	sd	s0,0(sp)
ffffffffc02049ee:	100027f3          	csrr	a5,sstatus
ffffffffc02049f2:	8b89                	andi	a5,a5,2
ffffffffc02049f4:	4401                	li	s0,0
ffffffffc02049f6:	efbd                	bnez	a5,ffffffffc0204a74 <schedule+0x8c>
ffffffffc02049f8:	00012897          	auipc	a7,0x12
ffffffffc02049fc:	bb88b883          	ld	a7,-1096(a7) # ffffffffc02165b0 <current>
ffffffffc0204a00:	0008ac23          	sw	zero,24(a7)
ffffffffc0204a04:	00012517          	auipc	a0,0x12
ffffffffc0204a08:	bb453503          	ld	a0,-1100(a0) # ffffffffc02165b8 <idleproc>
ffffffffc0204a0c:	04a88e63          	beq	a7,a0,ffffffffc0204a68 <schedule+0x80>
ffffffffc0204a10:	0c888693          	addi	a3,a7,200
ffffffffc0204a14:	00012617          	auipc	a2,0x12
ffffffffc0204a18:	b1460613          	addi	a2,a2,-1260 # ffffffffc0216528 <proc_list>
ffffffffc0204a1c:	87b6                	mv	a5,a3
ffffffffc0204a1e:	4581                	li	a1,0
ffffffffc0204a20:	4809                	li	a6,2
ffffffffc0204a22:	679c                	ld	a5,8(a5)
ffffffffc0204a24:	00c78863          	beq	a5,a2,ffffffffc0204a34 <schedule+0x4c>
ffffffffc0204a28:	f387a703          	lw	a4,-200(a5)
ffffffffc0204a2c:	f3878593          	addi	a1,a5,-200
ffffffffc0204a30:	03070163          	beq	a4,a6,ffffffffc0204a52 <schedule+0x6a>
ffffffffc0204a34:	fef697e3          	bne	a3,a5,ffffffffc0204a22 <schedule+0x3a>
ffffffffc0204a38:	ed89                	bnez	a1,ffffffffc0204a52 <schedule+0x6a>
ffffffffc0204a3a:	451c                	lw	a5,8(a0)
ffffffffc0204a3c:	2785                	addiw	a5,a5,1
ffffffffc0204a3e:	c51c                	sw	a5,8(a0)
ffffffffc0204a40:	00a88463          	beq	a7,a0,ffffffffc0204a48 <schedule+0x60>
ffffffffc0204a44:	93dff0ef          	jal	ra,ffffffffc0204380 <proc_run>
ffffffffc0204a48:	e819                	bnez	s0,ffffffffc0204a5e <schedule+0x76>
ffffffffc0204a4a:	60a2                	ld	ra,8(sp)
ffffffffc0204a4c:	6402                	ld	s0,0(sp)
ffffffffc0204a4e:	0141                	addi	sp,sp,16
ffffffffc0204a50:	8082                	ret
ffffffffc0204a52:	4198                	lw	a4,0(a1)
ffffffffc0204a54:	4789                	li	a5,2
ffffffffc0204a56:	fef712e3          	bne	a4,a5,ffffffffc0204a3a <schedule+0x52>
ffffffffc0204a5a:	852e                	mv	a0,a1
ffffffffc0204a5c:	bff9                	j	ffffffffc0204a3a <schedule+0x52>
ffffffffc0204a5e:	6402                	ld	s0,0(sp)
ffffffffc0204a60:	60a2                	ld	ra,8(sp)
ffffffffc0204a62:	0141                	addi	sp,sp,16
ffffffffc0204a64:	b5bfb06f          	j	ffffffffc02005be <intr_enable>
ffffffffc0204a68:	00012617          	auipc	a2,0x12
ffffffffc0204a6c:	ac060613          	addi	a2,a2,-1344 # ffffffffc0216528 <proc_list>
ffffffffc0204a70:	86b2                	mv	a3,a2
ffffffffc0204a72:	b76d                	j	ffffffffc0204a1c <schedule+0x34>
ffffffffc0204a74:	b51fb0ef          	jal	ra,ffffffffc02005c4 <intr_disable>
ffffffffc0204a78:	4405                	li	s0,1
ffffffffc0204a7a:	bfbd                	j	ffffffffc02049f8 <schedule+0x10>

ffffffffc0204a7c <strlen>:
ffffffffc0204a7c:	00054783          	lbu	a5,0(a0)
ffffffffc0204a80:	872a                	mv	a4,a0
ffffffffc0204a82:	4501                	li	a0,0
ffffffffc0204a84:	cb81                	beqz	a5,ffffffffc0204a94 <strlen+0x18>
ffffffffc0204a86:	0505                	addi	a0,a0,1
ffffffffc0204a88:	00a707b3          	add	a5,a4,a0
ffffffffc0204a8c:	0007c783          	lbu	a5,0(a5)
ffffffffc0204a90:	fbfd                	bnez	a5,ffffffffc0204a86 <strlen+0xa>
ffffffffc0204a92:	8082                	ret
ffffffffc0204a94:	8082                	ret

ffffffffc0204a96 <strnlen>:
ffffffffc0204a96:	4781                	li	a5,0
ffffffffc0204a98:	e589                	bnez	a1,ffffffffc0204aa2 <strnlen+0xc>
ffffffffc0204a9a:	a811                	j	ffffffffc0204aae <strnlen+0x18>
ffffffffc0204a9c:	0785                	addi	a5,a5,1
ffffffffc0204a9e:	00f58863          	beq	a1,a5,ffffffffc0204aae <strnlen+0x18>
ffffffffc0204aa2:	00f50733          	add	a4,a0,a5
ffffffffc0204aa6:	00074703          	lbu	a4,0(a4)
ffffffffc0204aaa:	fb6d                	bnez	a4,ffffffffc0204a9c <strnlen+0x6>
ffffffffc0204aac:	85be                	mv	a1,a5
ffffffffc0204aae:	852e                	mv	a0,a1
ffffffffc0204ab0:	8082                	ret

ffffffffc0204ab2 <strcpy>:
ffffffffc0204ab2:	87aa                	mv	a5,a0
ffffffffc0204ab4:	0005c703          	lbu	a4,0(a1)
ffffffffc0204ab8:	0785                	addi	a5,a5,1
ffffffffc0204aba:	0585                	addi	a1,a1,1
ffffffffc0204abc:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204ac0:	fb75                	bnez	a4,ffffffffc0204ab4 <strcpy+0x2>
ffffffffc0204ac2:	8082                	ret

ffffffffc0204ac4 <strcmp>:
ffffffffc0204ac4:	00054783          	lbu	a5,0(a0)
ffffffffc0204ac8:	0005c703          	lbu	a4,0(a1)
ffffffffc0204acc:	cb89                	beqz	a5,ffffffffc0204ade <strcmp+0x1a>
ffffffffc0204ace:	0505                	addi	a0,a0,1
ffffffffc0204ad0:	0585                	addi	a1,a1,1
ffffffffc0204ad2:	fee789e3          	beq	a5,a4,ffffffffc0204ac4 <strcmp>
ffffffffc0204ad6:	0007851b          	sext.w	a0,a5
ffffffffc0204ada:	9d19                	subw	a0,a0,a4
ffffffffc0204adc:	8082                	ret
ffffffffc0204ade:	4501                	li	a0,0
ffffffffc0204ae0:	bfed                	j	ffffffffc0204ada <strcmp+0x16>

ffffffffc0204ae2 <strchr>:
ffffffffc0204ae2:	00054783          	lbu	a5,0(a0)
ffffffffc0204ae6:	c799                	beqz	a5,ffffffffc0204af4 <strchr+0x12>
ffffffffc0204ae8:	00f58763          	beq	a1,a5,ffffffffc0204af6 <strchr+0x14>
ffffffffc0204aec:	00154783          	lbu	a5,1(a0)
ffffffffc0204af0:	0505                	addi	a0,a0,1
ffffffffc0204af2:	fbfd                	bnez	a5,ffffffffc0204ae8 <strchr+0x6>
ffffffffc0204af4:	4501                	li	a0,0
ffffffffc0204af6:	8082                	ret

ffffffffc0204af8 <memset>:
ffffffffc0204af8:	ca01                	beqz	a2,ffffffffc0204b08 <memset+0x10>
ffffffffc0204afa:	962a                	add	a2,a2,a0
ffffffffc0204afc:	87aa                	mv	a5,a0
ffffffffc0204afe:	0785                	addi	a5,a5,1
ffffffffc0204b00:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0204b04:	fec79de3          	bne	a5,a2,ffffffffc0204afe <memset+0x6>
ffffffffc0204b08:	8082                	ret

ffffffffc0204b0a <memcpy>:
ffffffffc0204b0a:	ca19                	beqz	a2,ffffffffc0204b20 <memcpy+0x16>
ffffffffc0204b0c:	962e                	add	a2,a2,a1
ffffffffc0204b0e:	87aa                	mv	a5,a0
ffffffffc0204b10:	0005c703          	lbu	a4,0(a1)
ffffffffc0204b14:	0585                	addi	a1,a1,1
ffffffffc0204b16:	0785                	addi	a5,a5,1
ffffffffc0204b18:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204b1c:	fec59ae3          	bne	a1,a2,ffffffffc0204b10 <memcpy+0x6>
ffffffffc0204b20:	8082                	ret

ffffffffc0204b22 <memcmp>:
ffffffffc0204b22:	c205                	beqz	a2,ffffffffc0204b42 <memcmp+0x20>
ffffffffc0204b24:	962e                	add	a2,a2,a1
ffffffffc0204b26:	a019                	j	ffffffffc0204b2c <memcmp+0xa>
ffffffffc0204b28:	00c58d63          	beq	a1,a2,ffffffffc0204b42 <memcmp+0x20>
ffffffffc0204b2c:	00054783          	lbu	a5,0(a0)
ffffffffc0204b30:	0005c703          	lbu	a4,0(a1)
ffffffffc0204b34:	0505                	addi	a0,a0,1
ffffffffc0204b36:	0585                	addi	a1,a1,1
ffffffffc0204b38:	fee788e3          	beq	a5,a4,ffffffffc0204b28 <memcmp+0x6>
ffffffffc0204b3c:	40e7853b          	subw	a0,a5,a4
ffffffffc0204b40:	8082                	ret
ffffffffc0204b42:	4501                	li	a0,0
ffffffffc0204b44:	8082                	ret

ffffffffc0204b46 <printnum>:
ffffffffc0204b46:	02069813          	slli	a6,a3,0x20
ffffffffc0204b4a:	7179                	addi	sp,sp,-48
ffffffffc0204b4c:	02085813          	srli	a6,a6,0x20
ffffffffc0204b50:	e052                	sd	s4,0(sp)
ffffffffc0204b52:	03067a33          	remu	s4,a2,a6
ffffffffc0204b56:	f022                	sd	s0,32(sp)
ffffffffc0204b58:	ec26                	sd	s1,24(sp)
ffffffffc0204b5a:	e84a                	sd	s2,16(sp)
ffffffffc0204b5c:	f406                	sd	ra,40(sp)
ffffffffc0204b5e:	e44e                	sd	s3,8(sp)
ffffffffc0204b60:	84aa                	mv	s1,a0
ffffffffc0204b62:	892e                	mv	s2,a1
ffffffffc0204b64:	fff7041b          	addiw	s0,a4,-1
ffffffffc0204b68:	2a01                	sext.w	s4,s4
ffffffffc0204b6a:	03067e63          	bgeu	a2,a6,ffffffffc0204ba6 <printnum+0x60>
ffffffffc0204b6e:	89be                	mv	s3,a5
ffffffffc0204b70:	00805763          	blez	s0,ffffffffc0204b7e <printnum+0x38>
ffffffffc0204b74:	347d                	addiw	s0,s0,-1
ffffffffc0204b76:	85ca                	mv	a1,s2
ffffffffc0204b78:	854e                	mv	a0,s3
ffffffffc0204b7a:	9482                	jalr	s1
ffffffffc0204b7c:	fc65                	bnez	s0,ffffffffc0204b74 <printnum+0x2e>
ffffffffc0204b7e:	1a02                	slli	s4,s4,0x20
ffffffffc0204b80:	00002797          	auipc	a5,0x2
ffffffffc0204b84:	2b878793          	addi	a5,a5,696 # ffffffffc0206e38 <default_pmm_manager+0x798>
ffffffffc0204b88:	020a5a13          	srli	s4,s4,0x20
ffffffffc0204b8c:	9a3e                	add	s4,s4,a5
ffffffffc0204b8e:	7402                	ld	s0,32(sp)
ffffffffc0204b90:	000a4503          	lbu	a0,0(s4)
ffffffffc0204b94:	70a2                	ld	ra,40(sp)
ffffffffc0204b96:	69a2                	ld	s3,8(sp)
ffffffffc0204b98:	6a02                	ld	s4,0(sp)
ffffffffc0204b9a:	85ca                	mv	a1,s2
ffffffffc0204b9c:	87a6                	mv	a5,s1
ffffffffc0204b9e:	6942                	ld	s2,16(sp)
ffffffffc0204ba0:	64e2                	ld	s1,24(sp)
ffffffffc0204ba2:	6145                	addi	sp,sp,48
ffffffffc0204ba4:	8782                	jr	a5
ffffffffc0204ba6:	03065633          	divu	a2,a2,a6
ffffffffc0204baa:	8722                	mv	a4,s0
ffffffffc0204bac:	f9bff0ef          	jal	ra,ffffffffc0204b46 <printnum>
ffffffffc0204bb0:	b7f9                	j	ffffffffc0204b7e <printnum+0x38>

ffffffffc0204bb2 <vprintfmt>:
ffffffffc0204bb2:	7119                	addi	sp,sp,-128
ffffffffc0204bb4:	f4a6                	sd	s1,104(sp)
ffffffffc0204bb6:	f0ca                	sd	s2,96(sp)
ffffffffc0204bb8:	ecce                	sd	s3,88(sp)
ffffffffc0204bba:	e8d2                	sd	s4,80(sp)
ffffffffc0204bbc:	e4d6                	sd	s5,72(sp)
ffffffffc0204bbe:	e0da                	sd	s6,64(sp)
ffffffffc0204bc0:	fc5e                	sd	s7,56(sp)
ffffffffc0204bc2:	f06a                	sd	s10,32(sp)
ffffffffc0204bc4:	fc86                	sd	ra,120(sp)
ffffffffc0204bc6:	f8a2                	sd	s0,112(sp)
ffffffffc0204bc8:	f862                	sd	s8,48(sp)
ffffffffc0204bca:	f466                	sd	s9,40(sp)
ffffffffc0204bcc:	ec6e                	sd	s11,24(sp)
ffffffffc0204bce:	892a                	mv	s2,a0
ffffffffc0204bd0:	84ae                	mv	s1,a1
ffffffffc0204bd2:	8d32                	mv	s10,a2
ffffffffc0204bd4:	8a36                	mv	s4,a3
ffffffffc0204bd6:	02500993          	li	s3,37
ffffffffc0204bda:	5b7d                	li	s6,-1
ffffffffc0204bdc:	00002a97          	auipc	s5,0x2
ffffffffc0204be0:	288a8a93          	addi	s5,s5,648 # ffffffffc0206e64 <default_pmm_manager+0x7c4>
ffffffffc0204be4:	00002b97          	auipc	s7,0x2
ffffffffc0204be8:	45cb8b93          	addi	s7,s7,1116 # ffffffffc0207040 <error_string>
ffffffffc0204bec:	000d4503          	lbu	a0,0(s10)
ffffffffc0204bf0:	001d0413          	addi	s0,s10,1
ffffffffc0204bf4:	01350a63          	beq	a0,s3,ffffffffc0204c08 <vprintfmt+0x56>
ffffffffc0204bf8:	c121                	beqz	a0,ffffffffc0204c38 <vprintfmt+0x86>
ffffffffc0204bfa:	85a6                	mv	a1,s1
ffffffffc0204bfc:	0405                	addi	s0,s0,1
ffffffffc0204bfe:	9902                	jalr	s2
ffffffffc0204c00:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204c04:	ff351ae3          	bne	a0,s3,ffffffffc0204bf8 <vprintfmt+0x46>
ffffffffc0204c08:	00044603          	lbu	a2,0(s0)
ffffffffc0204c0c:	02000793          	li	a5,32
ffffffffc0204c10:	4c81                	li	s9,0
ffffffffc0204c12:	4881                	li	a7,0
ffffffffc0204c14:	5c7d                	li	s8,-1
ffffffffc0204c16:	5dfd                	li	s11,-1
ffffffffc0204c18:	05500513          	li	a0,85
ffffffffc0204c1c:	4825                	li	a6,9
ffffffffc0204c1e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204c22:	0ff5f593          	zext.b	a1,a1
ffffffffc0204c26:	00140d13          	addi	s10,s0,1
ffffffffc0204c2a:	04b56263          	bltu	a0,a1,ffffffffc0204c6e <vprintfmt+0xbc>
ffffffffc0204c2e:	058a                	slli	a1,a1,0x2
ffffffffc0204c30:	95d6                	add	a1,a1,s5
ffffffffc0204c32:	4194                	lw	a3,0(a1)
ffffffffc0204c34:	96d6                	add	a3,a3,s5
ffffffffc0204c36:	8682                	jr	a3
ffffffffc0204c38:	70e6                	ld	ra,120(sp)
ffffffffc0204c3a:	7446                	ld	s0,112(sp)
ffffffffc0204c3c:	74a6                	ld	s1,104(sp)
ffffffffc0204c3e:	7906                	ld	s2,96(sp)
ffffffffc0204c40:	69e6                	ld	s3,88(sp)
ffffffffc0204c42:	6a46                	ld	s4,80(sp)
ffffffffc0204c44:	6aa6                	ld	s5,72(sp)
ffffffffc0204c46:	6b06                	ld	s6,64(sp)
ffffffffc0204c48:	7be2                	ld	s7,56(sp)
ffffffffc0204c4a:	7c42                	ld	s8,48(sp)
ffffffffc0204c4c:	7ca2                	ld	s9,40(sp)
ffffffffc0204c4e:	7d02                	ld	s10,32(sp)
ffffffffc0204c50:	6de2                	ld	s11,24(sp)
ffffffffc0204c52:	6109                	addi	sp,sp,128
ffffffffc0204c54:	8082                	ret
ffffffffc0204c56:	87b2                	mv	a5,a2
ffffffffc0204c58:	00144603          	lbu	a2,1(s0)
ffffffffc0204c5c:	846a                	mv	s0,s10
ffffffffc0204c5e:	00140d13          	addi	s10,s0,1
ffffffffc0204c62:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204c66:	0ff5f593          	zext.b	a1,a1
ffffffffc0204c6a:	fcb572e3          	bgeu	a0,a1,ffffffffc0204c2e <vprintfmt+0x7c>
ffffffffc0204c6e:	85a6                	mv	a1,s1
ffffffffc0204c70:	02500513          	li	a0,37
ffffffffc0204c74:	9902                	jalr	s2
ffffffffc0204c76:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204c7a:	8d22                	mv	s10,s0
ffffffffc0204c7c:	f73788e3          	beq	a5,s3,ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204c80:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0204c84:	1d7d                	addi	s10,s10,-1
ffffffffc0204c86:	ff379de3          	bne	a5,s3,ffffffffc0204c80 <vprintfmt+0xce>
ffffffffc0204c8a:	b78d                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204c8c:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0204c90:	00144603          	lbu	a2,1(s0)
ffffffffc0204c94:	846a                	mv	s0,s10
ffffffffc0204c96:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204c9a:	0006059b          	sext.w	a1,a2
ffffffffc0204c9e:	02d86463          	bltu	a6,a3,ffffffffc0204cc6 <vprintfmt+0x114>
ffffffffc0204ca2:	00144603          	lbu	a2,1(s0)
ffffffffc0204ca6:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204caa:	0186873b          	addw	a4,a3,s8
ffffffffc0204cae:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204cb2:	9f2d                	addw	a4,a4,a1
ffffffffc0204cb4:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204cb8:	0405                	addi	s0,s0,1
ffffffffc0204cba:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0204cbe:	0006059b          	sext.w	a1,a2
ffffffffc0204cc2:	fed870e3          	bgeu	a6,a3,ffffffffc0204ca2 <vprintfmt+0xf0>
ffffffffc0204cc6:	f40ddce3          	bgez	s11,ffffffffc0204c1e <vprintfmt+0x6c>
ffffffffc0204cca:	8de2                	mv	s11,s8
ffffffffc0204ccc:	5c7d                	li	s8,-1
ffffffffc0204cce:	bf81                	j	ffffffffc0204c1e <vprintfmt+0x6c>
ffffffffc0204cd0:	fffdc693          	not	a3,s11
ffffffffc0204cd4:	96fd                	srai	a3,a3,0x3f
ffffffffc0204cd6:	00ddfdb3          	and	s11,s11,a3
ffffffffc0204cda:	00144603          	lbu	a2,1(s0)
ffffffffc0204cde:	2d81                	sext.w	s11,s11
ffffffffc0204ce0:	846a                	mv	s0,s10
ffffffffc0204ce2:	bf35                	j	ffffffffc0204c1e <vprintfmt+0x6c>
ffffffffc0204ce4:	000a2c03          	lw	s8,0(s4)
ffffffffc0204ce8:	00144603          	lbu	a2,1(s0)
ffffffffc0204cec:	0a21                	addi	s4,s4,8
ffffffffc0204cee:	846a                	mv	s0,s10
ffffffffc0204cf0:	bfd9                	j	ffffffffc0204cc6 <vprintfmt+0x114>
ffffffffc0204cf2:	4705                	li	a4,1
ffffffffc0204cf4:	008a0593          	addi	a1,s4,8
ffffffffc0204cf8:	01174463          	blt	a4,a7,ffffffffc0204d00 <vprintfmt+0x14e>
ffffffffc0204cfc:	1a088e63          	beqz	a7,ffffffffc0204eb8 <vprintfmt+0x306>
ffffffffc0204d00:	000a3603          	ld	a2,0(s4)
ffffffffc0204d04:	46c1                	li	a3,16
ffffffffc0204d06:	8a2e                	mv	s4,a1
ffffffffc0204d08:	2781                	sext.w	a5,a5
ffffffffc0204d0a:	876e                	mv	a4,s11
ffffffffc0204d0c:	85a6                	mv	a1,s1
ffffffffc0204d0e:	854a                	mv	a0,s2
ffffffffc0204d10:	e37ff0ef          	jal	ra,ffffffffc0204b46 <printnum>
ffffffffc0204d14:	bde1                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204d16:	000a2503          	lw	a0,0(s4)
ffffffffc0204d1a:	85a6                	mv	a1,s1
ffffffffc0204d1c:	0a21                	addi	s4,s4,8
ffffffffc0204d1e:	9902                	jalr	s2
ffffffffc0204d20:	b5f1                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204d22:	4705                	li	a4,1
ffffffffc0204d24:	008a0593          	addi	a1,s4,8
ffffffffc0204d28:	01174463          	blt	a4,a7,ffffffffc0204d30 <vprintfmt+0x17e>
ffffffffc0204d2c:	18088163          	beqz	a7,ffffffffc0204eae <vprintfmt+0x2fc>
ffffffffc0204d30:	000a3603          	ld	a2,0(s4)
ffffffffc0204d34:	46a9                	li	a3,10
ffffffffc0204d36:	8a2e                	mv	s4,a1
ffffffffc0204d38:	bfc1                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204d3a:	00144603          	lbu	a2,1(s0)
ffffffffc0204d3e:	4c85                	li	s9,1
ffffffffc0204d40:	846a                	mv	s0,s10
ffffffffc0204d42:	bdf1                	j	ffffffffc0204c1e <vprintfmt+0x6c>
ffffffffc0204d44:	85a6                	mv	a1,s1
ffffffffc0204d46:	02500513          	li	a0,37
ffffffffc0204d4a:	9902                	jalr	s2
ffffffffc0204d4c:	b545                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204d4e:	00144603          	lbu	a2,1(s0)
ffffffffc0204d52:	2885                	addiw	a7,a7,1
ffffffffc0204d54:	846a                	mv	s0,s10
ffffffffc0204d56:	b5e1                	j	ffffffffc0204c1e <vprintfmt+0x6c>
ffffffffc0204d58:	4705                	li	a4,1
ffffffffc0204d5a:	008a0593          	addi	a1,s4,8
ffffffffc0204d5e:	01174463          	blt	a4,a7,ffffffffc0204d66 <vprintfmt+0x1b4>
ffffffffc0204d62:	14088163          	beqz	a7,ffffffffc0204ea4 <vprintfmt+0x2f2>
ffffffffc0204d66:	000a3603          	ld	a2,0(s4)
ffffffffc0204d6a:	46a1                	li	a3,8
ffffffffc0204d6c:	8a2e                	mv	s4,a1
ffffffffc0204d6e:	bf69                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204d70:	03000513          	li	a0,48
ffffffffc0204d74:	85a6                	mv	a1,s1
ffffffffc0204d76:	e03e                	sd	a5,0(sp)
ffffffffc0204d78:	9902                	jalr	s2
ffffffffc0204d7a:	85a6                	mv	a1,s1
ffffffffc0204d7c:	07800513          	li	a0,120
ffffffffc0204d80:	9902                	jalr	s2
ffffffffc0204d82:	0a21                	addi	s4,s4,8
ffffffffc0204d84:	6782                	ld	a5,0(sp)
ffffffffc0204d86:	46c1                	li	a3,16
ffffffffc0204d88:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0204d8c:	bfb5                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204d8e:	000a3403          	ld	s0,0(s4)
ffffffffc0204d92:	008a0713          	addi	a4,s4,8
ffffffffc0204d96:	e03a                	sd	a4,0(sp)
ffffffffc0204d98:	14040263          	beqz	s0,ffffffffc0204edc <vprintfmt+0x32a>
ffffffffc0204d9c:	0fb05763          	blez	s11,ffffffffc0204e8a <vprintfmt+0x2d8>
ffffffffc0204da0:	02d00693          	li	a3,45
ffffffffc0204da4:	0cd79163          	bne	a5,a3,ffffffffc0204e66 <vprintfmt+0x2b4>
ffffffffc0204da8:	00044783          	lbu	a5,0(s0)
ffffffffc0204dac:	0007851b          	sext.w	a0,a5
ffffffffc0204db0:	cf85                	beqz	a5,ffffffffc0204de8 <vprintfmt+0x236>
ffffffffc0204db2:	00140a13          	addi	s4,s0,1
ffffffffc0204db6:	05e00413          	li	s0,94
ffffffffc0204dba:	000c4563          	bltz	s8,ffffffffc0204dc4 <vprintfmt+0x212>
ffffffffc0204dbe:	3c7d                	addiw	s8,s8,-1
ffffffffc0204dc0:	036c0263          	beq	s8,s6,ffffffffc0204de4 <vprintfmt+0x232>
ffffffffc0204dc4:	85a6                	mv	a1,s1
ffffffffc0204dc6:	0e0c8e63          	beqz	s9,ffffffffc0204ec2 <vprintfmt+0x310>
ffffffffc0204dca:	3781                	addiw	a5,a5,-32
ffffffffc0204dcc:	0ef47b63          	bgeu	s0,a5,ffffffffc0204ec2 <vprintfmt+0x310>
ffffffffc0204dd0:	03f00513          	li	a0,63
ffffffffc0204dd4:	9902                	jalr	s2
ffffffffc0204dd6:	000a4783          	lbu	a5,0(s4)
ffffffffc0204dda:	3dfd                	addiw	s11,s11,-1
ffffffffc0204ddc:	0a05                	addi	s4,s4,1
ffffffffc0204dde:	0007851b          	sext.w	a0,a5
ffffffffc0204de2:	ffe1                	bnez	a5,ffffffffc0204dba <vprintfmt+0x208>
ffffffffc0204de4:	01b05963          	blez	s11,ffffffffc0204df6 <vprintfmt+0x244>
ffffffffc0204de8:	3dfd                	addiw	s11,s11,-1
ffffffffc0204dea:	85a6                	mv	a1,s1
ffffffffc0204dec:	02000513          	li	a0,32
ffffffffc0204df0:	9902                	jalr	s2
ffffffffc0204df2:	fe0d9be3          	bnez	s11,ffffffffc0204de8 <vprintfmt+0x236>
ffffffffc0204df6:	6a02                	ld	s4,0(sp)
ffffffffc0204df8:	bbd5                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204dfa:	4705                	li	a4,1
ffffffffc0204dfc:	008a0c93          	addi	s9,s4,8
ffffffffc0204e00:	01174463          	blt	a4,a7,ffffffffc0204e08 <vprintfmt+0x256>
ffffffffc0204e04:	08088d63          	beqz	a7,ffffffffc0204e9e <vprintfmt+0x2ec>
ffffffffc0204e08:	000a3403          	ld	s0,0(s4)
ffffffffc0204e0c:	0a044d63          	bltz	s0,ffffffffc0204ec6 <vprintfmt+0x314>
ffffffffc0204e10:	8622                	mv	a2,s0
ffffffffc0204e12:	8a66                	mv	s4,s9
ffffffffc0204e14:	46a9                	li	a3,10
ffffffffc0204e16:	bdcd                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204e18:	000a2783          	lw	a5,0(s4)
ffffffffc0204e1c:	4719                	li	a4,6
ffffffffc0204e1e:	0a21                	addi	s4,s4,8
ffffffffc0204e20:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204e24:	8fb5                	xor	a5,a5,a3
ffffffffc0204e26:	40d786bb          	subw	a3,a5,a3
ffffffffc0204e2a:	02d74163          	blt	a4,a3,ffffffffc0204e4c <vprintfmt+0x29a>
ffffffffc0204e2e:	00369793          	slli	a5,a3,0x3
ffffffffc0204e32:	97de                	add	a5,a5,s7
ffffffffc0204e34:	639c                	ld	a5,0(a5)
ffffffffc0204e36:	cb99                	beqz	a5,ffffffffc0204e4c <vprintfmt+0x29a>
ffffffffc0204e38:	86be                	mv	a3,a5
ffffffffc0204e3a:	00000617          	auipc	a2,0x0
ffffffffc0204e3e:	13e60613          	addi	a2,a2,318 # ffffffffc0204f78 <etext+0x2e>
ffffffffc0204e42:	85a6                	mv	a1,s1
ffffffffc0204e44:	854a                	mv	a0,s2
ffffffffc0204e46:	0ce000ef          	jal	ra,ffffffffc0204f14 <printfmt>
ffffffffc0204e4a:	b34d                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204e4c:	00002617          	auipc	a2,0x2
ffffffffc0204e50:	00c60613          	addi	a2,a2,12 # ffffffffc0206e58 <default_pmm_manager+0x7b8>
ffffffffc0204e54:	85a6                	mv	a1,s1
ffffffffc0204e56:	854a                	mv	a0,s2
ffffffffc0204e58:	0bc000ef          	jal	ra,ffffffffc0204f14 <printfmt>
ffffffffc0204e5c:	bb41                	j	ffffffffc0204bec <vprintfmt+0x3a>
ffffffffc0204e5e:	00002417          	auipc	s0,0x2
ffffffffc0204e62:	ff240413          	addi	s0,s0,-14 # ffffffffc0206e50 <default_pmm_manager+0x7b0>
ffffffffc0204e66:	85e2                	mv	a1,s8
ffffffffc0204e68:	8522                	mv	a0,s0
ffffffffc0204e6a:	e43e                	sd	a5,8(sp)
ffffffffc0204e6c:	c2bff0ef          	jal	ra,ffffffffc0204a96 <strnlen>
ffffffffc0204e70:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204e74:	01b05b63          	blez	s11,ffffffffc0204e8a <vprintfmt+0x2d8>
ffffffffc0204e78:	67a2                	ld	a5,8(sp)
ffffffffc0204e7a:	00078a1b          	sext.w	s4,a5
ffffffffc0204e7e:	3dfd                	addiw	s11,s11,-1
ffffffffc0204e80:	85a6                	mv	a1,s1
ffffffffc0204e82:	8552                	mv	a0,s4
ffffffffc0204e84:	9902                	jalr	s2
ffffffffc0204e86:	fe0d9ce3          	bnez	s11,ffffffffc0204e7e <vprintfmt+0x2cc>
ffffffffc0204e8a:	00044783          	lbu	a5,0(s0)
ffffffffc0204e8e:	00140a13          	addi	s4,s0,1
ffffffffc0204e92:	0007851b          	sext.w	a0,a5
ffffffffc0204e96:	d3a5                	beqz	a5,ffffffffc0204df6 <vprintfmt+0x244>
ffffffffc0204e98:	05e00413          	li	s0,94
ffffffffc0204e9c:	bf39                	j	ffffffffc0204dba <vprintfmt+0x208>
ffffffffc0204e9e:	000a2403          	lw	s0,0(s4)
ffffffffc0204ea2:	b7ad                	j	ffffffffc0204e0c <vprintfmt+0x25a>
ffffffffc0204ea4:	000a6603          	lwu	a2,0(s4)
ffffffffc0204ea8:	46a1                	li	a3,8
ffffffffc0204eaa:	8a2e                	mv	s4,a1
ffffffffc0204eac:	bdb1                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204eae:	000a6603          	lwu	a2,0(s4)
ffffffffc0204eb2:	46a9                	li	a3,10
ffffffffc0204eb4:	8a2e                	mv	s4,a1
ffffffffc0204eb6:	bd89                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204eb8:	000a6603          	lwu	a2,0(s4)
ffffffffc0204ebc:	46c1                	li	a3,16
ffffffffc0204ebe:	8a2e                	mv	s4,a1
ffffffffc0204ec0:	b5a1                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204ec2:	9902                	jalr	s2
ffffffffc0204ec4:	bf09                	j	ffffffffc0204dd6 <vprintfmt+0x224>
ffffffffc0204ec6:	85a6                	mv	a1,s1
ffffffffc0204ec8:	02d00513          	li	a0,45
ffffffffc0204ecc:	e03e                	sd	a5,0(sp)
ffffffffc0204ece:	9902                	jalr	s2
ffffffffc0204ed0:	6782                	ld	a5,0(sp)
ffffffffc0204ed2:	8a66                	mv	s4,s9
ffffffffc0204ed4:	40800633          	neg	a2,s0
ffffffffc0204ed8:	46a9                	li	a3,10
ffffffffc0204eda:	b53d                	j	ffffffffc0204d08 <vprintfmt+0x156>
ffffffffc0204edc:	03b05163          	blez	s11,ffffffffc0204efe <vprintfmt+0x34c>
ffffffffc0204ee0:	02d00693          	li	a3,45
ffffffffc0204ee4:	f6d79de3          	bne	a5,a3,ffffffffc0204e5e <vprintfmt+0x2ac>
ffffffffc0204ee8:	00002417          	auipc	s0,0x2
ffffffffc0204eec:	f6840413          	addi	s0,s0,-152 # ffffffffc0206e50 <default_pmm_manager+0x7b0>
ffffffffc0204ef0:	02800793          	li	a5,40
ffffffffc0204ef4:	02800513          	li	a0,40
ffffffffc0204ef8:	00140a13          	addi	s4,s0,1
ffffffffc0204efc:	bd6d                	j	ffffffffc0204db6 <vprintfmt+0x204>
ffffffffc0204efe:	00002a17          	auipc	s4,0x2
ffffffffc0204f02:	f53a0a13          	addi	s4,s4,-173 # ffffffffc0206e51 <default_pmm_manager+0x7b1>
ffffffffc0204f06:	02800513          	li	a0,40
ffffffffc0204f0a:	02800793          	li	a5,40
ffffffffc0204f0e:	05e00413          	li	s0,94
ffffffffc0204f12:	b565                	j	ffffffffc0204dba <vprintfmt+0x208>

ffffffffc0204f14 <printfmt>:
ffffffffc0204f14:	715d                	addi	sp,sp,-80
ffffffffc0204f16:	02810313          	addi	t1,sp,40
ffffffffc0204f1a:	f436                	sd	a3,40(sp)
ffffffffc0204f1c:	869a                	mv	a3,t1
ffffffffc0204f1e:	ec06                	sd	ra,24(sp)
ffffffffc0204f20:	f83a                	sd	a4,48(sp)
ffffffffc0204f22:	fc3e                	sd	a5,56(sp)
ffffffffc0204f24:	e0c2                	sd	a6,64(sp)
ffffffffc0204f26:	e4c6                	sd	a7,72(sp)
ffffffffc0204f28:	e41a                	sd	t1,8(sp)
ffffffffc0204f2a:	c89ff0ef          	jal	ra,ffffffffc0204bb2 <vprintfmt>
ffffffffc0204f2e:	60e2                	ld	ra,24(sp)
ffffffffc0204f30:	6161                	addi	sp,sp,80
ffffffffc0204f32:	8082                	ret

ffffffffc0204f34 <hash32>:
ffffffffc0204f34:	9e3707b7          	lui	a5,0x9e370
ffffffffc0204f38:	2785                	addiw	a5,a5,1
ffffffffc0204f3a:	02a7853b          	mulw	a0,a5,a0
ffffffffc0204f3e:	02000793          	li	a5,32
ffffffffc0204f42:	9f8d                	subw	a5,a5,a1
ffffffffc0204f44:	00f5553b          	srlw	a0,a0,a5
ffffffffc0204f48:	8082                	ret
