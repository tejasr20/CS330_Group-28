
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	96013103          	ld	sp,-1696(sp) # 80008960 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	ff070713          	addi	a4,a4,-16 # 80009040 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	0ee78793          	addi	a5,a5,238 # 80006150 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dc678793          	addi	a5,a5,-570 # 80000e72 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	3d0080e7          	jalr	976(ra) # 800024fa <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	77e080e7          	jalr	1918(ra) # 800008b8 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	ff650513          	addi	a0,a0,-10 # 80011180 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a3e080e7          	jalr	-1474(ra) # 80000bd0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	fe648493          	addi	s1,s1,-26 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	07690913          	addi	s2,s2,118 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305863          	blez	s3,80000220 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71463          	bne	a4,a5,800001e4 <consoleread+0x80>
      if(myproc()->killed){
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7d6080e7          	jalr	2006(ra) # 80001996 <myproc>
    800001c8:	551c                	lw	a5,40(a0)
    800001ca:	e7b5                	bnez	a5,80000236 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	f00080e7          	jalr	-256(ra) # 800020d0 <sleep>
    while(cons.r == cons.w){
    800001d8:	0984a783          	lw	a5,152(s1)
    800001dc:	09c4a703          	lw	a4,156(s1)
    800001e0:	fef700e3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e4:	0017871b          	addiw	a4,a5,1
    800001e8:	08e4ac23          	sw	a4,152(s1)
    800001ec:	07f7f713          	andi	a4,a5,127
    800001f0:	9726                	add	a4,a4,s1
    800001f2:	01874703          	lbu	a4,24(a4)
    800001f6:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001fa:	077d0563          	beq	s10,s7,80000264 <consoleread+0x100>
    cbuf = c;
    800001fe:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000202:	4685                	li	a3,1
    80000204:	f9f40613          	addi	a2,s0,-97
    80000208:	85d2                	mv	a1,s4
    8000020a:	8556                	mv	a0,s5
    8000020c:	00002097          	auipc	ra,0x2
    80000210:	298080e7          	jalr	664(ra) # 800024a4 <either_copyout>
    80000214:	01850663          	beq	a0,s8,80000220 <consoleread+0xbc>
    dst++;
    80000218:	0a05                	addi	s4,s4,1
    --n;
    8000021a:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000021c:	f99d1ae3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000220:	00011517          	auipc	a0,0x11
    80000224:	f6050513          	addi	a0,a0,-160 # 80011180 <cons>
    80000228:	00001097          	auipc	ra,0x1
    8000022c:	a5c080e7          	jalr	-1444(ra) # 80000c84 <release>

  return target - n;
    80000230:	413b053b          	subw	a0,s6,s3
    80000234:	a811                	j	80000248 <consoleread+0xe4>
        release(&cons.lock);
    80000236:	00011517          	auipc	a0,0x11
    8000023a:	f4a50513          	addi	a0,a0,-182 # 80011180 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	a46080e7          	jalr	-1466(ra) # 80000c84 <release>
        return -1;
    80000246:	557d                	li	a0,-1
}
    80000248:	70a6                	ld	ra,104(sp)
    8000024a:	7406                	ld	s0,96(sp)
    8000024c:	64e6                	ld	s1,88(sp)
    8000024e:	6946                	ld	s2,80(sp)
    80000250:	69a6                	ld	s3,72(sp)
    80000252:	6a06                	ld	s4,64(sp)
    80000254:	7ae2                	ld	s5,56(sp)
    80000256:	7b42                	ld	s6,48(sp)
    80000258:	7ba2                	ld	s7,40(sp)
    8000025a:	7c02                	ld	s8,32(sp)
    8000025c:	6ce2                	ld	s9,24(sp)
    8000025e:	6d42                	ld	s10,16(sp)
    80000260:	6165                	addi	sp,sp,112
    80000262:	8082                	ret
      if(n < target){
    80000264:	0009871b          	sext.w	a4,s3
    80000268:	fb677ce3          	bgeu	a4,s6,80000220 <consoleread+0xbc>
        cons.r--;
    8000026c:	00011717          	auipc	a4,0x11
    80000270:	faf72623          	sw	a5,-84(a4) # 80011218 <cons+0x98>
    80000274:	b775                	j	80000220 <consoleread+0xbc>

0000000080000276 <consputc>:
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e406                	sd	ra,8(sp)
    8000027a:	e022                	sd	s0,0(sp)
    8000027c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000027e:	10000793          	li	a5,256
    80000282:	00f50a63          	beq	a0,a5,80000296 <consputc+0x20>
    uartputc_sync(c);
    80000286:	00000097          	auipc	ra,0x0
    8000028a:	560080e7          	jalr	1376(ra) # 800007e6 <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	00000097          	auipc	ra,0x0
    8000029c:	54e080e7          	jalr	1358(ra) # 800007e6 <uartputc_sync>
    800002a0:	02000513          	li	a0,32
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	542080e7          	jalr	1346(ra) # 800007e6 <uartputc_sync>
    800002ac:	4521                	li	a0,8
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	538080e7          	jalr	1336(ra) # 800007e6 <uartputc_sync>
    800002b6:	bfe1                	j	8000028e <consputc+0x18>

00000000800002b8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002b8:	1101                	addi	sp,sp,-32
    800002ba:	ec06                	sd	ra,24(sp)
    800002bc:	e822                	sd	s0,16(sp)
    800002be:	e426                	sd	s1,8(sp)
    800002c0:	e04a                	sd	s2,0(sp)
    800002c2:	1000                	addi	s0,sp,32
    800002c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c6:	00011517          	auipc	a0,0x11
    800002ca:	eba50513          	addi	a0,a0,-326 # 80011180 <cons>
    800002ce:	00001097          	auipc	ra,0x1
    800002d2:	902080e7          	jalr	-1790(ra) # 80000bd0 <acquire>

  switch(c){
    800002d6:	47d5                	li	a5,21
    800002d8:	0af48663          	beq	s1,a5,80000384 <consoleintr+0xcc>
    800002dc:	0297ca63          	blt	a5,s1,80000310 <consoleintr+0x58>
    800002e0:	47a1                	li	a5,8
    800002e2:	0ef48763          	beq	s1,a5,800003d0 <consoleintr+0x118>
    800002e6:	47c1                	li	a5,16
    800002e8:	10f49a63          	bne	s1,a5,800003fc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ec:	00002097          	auipc	ra,0x2
    800002f0:	264080e7          	jalr	612(ra) # 80002550 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f4:	00011517          	auipc	a0,0x11
    800002f8:	e8c50513          	addi	a0,a0,-372 # 80011180 <cons>
    800002fc:	00001097          	auipc	ra,0x1
    80000300:	988080e7          	jalr	-1656(ra) # 80000c84 <release>
}
    80000304:	60e2                	ld	ra,24(sp)
    80000306:	6442                	ld	s0,16(sp)
    80000308:	64a2                	ld	s1,8(sp)
    8000030a:	6902                	ld	s2,0(sp)
    8000030c:	6105                	addi	sp,sp,32
    8000030e:	8082                	ret
  switch(c){
    80000310:	07f00793          	li	a5,127
    80000314:	0af48e63          	beq	s1,a5,800003d0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000318:	00011717          	auipc	a4,0x11
    8000031c:	e6870713          	addi	a4,a4,-408 # 80011180 <cons>
    80000320:	0a072783          	lw	a5,160(a4)
    80000324:	09872703          	lw	a4,152(a4)
    80000328:	9f99                	subw	a5,a5,a4
    8000032a:	07f00713          	li	a4,127
    8000032e:	fcf763e3          	bltu	a4,a5,800002f4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000332:	47b5                	li	a5,13
    80000334:	0cf48763          	beq	s1,a5,80000402 <consoleintr+0x14a>
      consputc(c);
    80000338:	8526                	mv	a0,s1
    8000033a:	00000097          	auipc	ra,0x0
    8000033e:	f3c080e7          	jalr	-196(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000342:	00011797          	auipc	a5,0x11
    80000346:	e3e78793          	addi	a5,a5,-450 # 80011180 <cons>
    8000034a:	0a07a703          	lw	a4,160(a5)
    8000034e:	0017069b          	addiw	a3,a4,1
    80000352:	0006861b          	sext.w	a2,a3
    80000356:	0ad7a023          	sw	a3,160(a5)
    8000035a:	07f77713          	andi	a4,a4,127
    8000035e:	97ba                	add	a5,a5,a4
    80000360:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000364:	47a9                	li	a5,10
    80000366:	0cf48563          	beq	s1,a5,80000430 <consoleintr+0x178>
    8000036a:	4791                	li	a5,4
    8000036c:	0cf48263          	beq	s1,a5,80000430 <consoleintr+0x178>
    80000370:	00011797          	auipc	a5,0x11
    80000374:	ea87a783          	lw	a5,-344(a5) # 80011218 <cons+0x98>
    80000378:	0807879b          	addiw	a5,a5,128
    8000037c:	f6f61ce3          	bne	a2,a5,800002f4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000380:	863e                	mv	a2,a5
    80000382:	a07d                	j	80000430 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000384:	00011717          	auipc	a4,0x11
    80000388:	dfc70713          	addi	a4,a4,-516 # 80011180 <cons>
    8000038c:	0a072783          	lw	a5,160(a4)
    80000390:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	00011497          	auipc	s1,0x11
    80000398:	dec48493          	addi	s1,s1,-532 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000039c:	4929                	li	s2,10
    8000039e:	f4f70be3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a2:	37fd                	addiw	a5,a5,-1
    800003a4:	07f7f713          	andi	a4,a5,127
    800003a8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003aa:	01874703          	lbu	a4,24(a4)
    800003ae:	f52703e3          	beq	a4,s2,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003b2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b6:	10000513          	li	a0,256
    800003ba:	00000097          	auipc	ra,0x0
    800003be:	ebc080e7          	jalr	-324(ra) # 80000276 <consputc>
    while(cons.e != cons.w &&
    800003c2:	0a04a783          	lw	a5,160(s1)
    800003c6:	09c4a703          	lw	a4,156(s1)
    800003ca:	fcf71ce3          	bne	a4,a5,800003a2 <consoleintr+0xea>
    800003ce:	b71d                	j	800002f4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d0:	00011717          	auipc	a4,0x11
    800003d4:	db070713          	addi	a4,a4,-592 # 80011180 <cons>
    800003d8:	0a072783          	lw	a5,160(a4)
    800003dc:	09c72703          	lw	a4,156(a4)
    800003e0:	f0f70ae3          	beq	a4,a5,800002f4 <consoleintr+0x3c>
      cons.e--;
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	e2f72d23          	sw	a5,-454(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003ee:	10000513          	li	a0,256
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	e84080e7          	jalr	-380(ra) # 80000276 <consputc>
    800003fa:	bded                	j	800002f4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003fc:	ee048ce3          	beqz	s1,800002f4 <consoleintr+0x3c>
    80000400:	bf21                	j	80000318 <consoleintr+0x60>
      consputc(c);
    80000402:	4529                	li	a0,10
    80000404:	00000097          	auipc	ra,0x0
    80000408:	e72080e7          	jalr	-398(ra) # 80000276 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000040c:	00011797          	auipc	a5,0x11
    80000410:	d7478793          	addi	a5,a5,-652 # 80011180 <cons>
    80000414:	0a07a703          	lw	a4,160(a5)
    80000418:	0017069b          	addiw	a3,a4,1
    8000041c:	0006861b          	sext.w	a2,a3
    80000420:	0ad7a023          	sw	a3,160(a5)
    80000424:	07f77713          	andi	a4,a4,127
    80000428:	97ba                	add	a5,a5,a4
    8000042a:	4729                	li	a4,10
    8000042c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000430:	00011797          	auipc	a5,0x11
    80000434:	dec7a623          	sw	a2,-532(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000438:	00011517          	auipc	a0,0x11
    8000043c:	de050513          	addi	a0,a0,-544 # 80011218 <cons+0x98>
    80000440:	00002097          	auipc	ra,0x2
    80000444:	e1c080e7          	jalr	-484(ra) # 8000225c <wakeup>
    80000448:	b575                	j	800002f4 <consoleintr+0x3c>

000000008000044a <consoleinit>:

void
consoleinit(void)
{
    8000044a:	1141                	addi	sp,sp,-16
    8000044c:	e406                	sd	ra,8(sp)
    8000044e:	e022                	sd	s0,0(sp)
    80000450:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000452:	00008597          	auipc	a1,0x8
    80000456:	bbe58593          	addi	a1,a1,-1090 # 80008010 <etext+0x10>
    8000045a:	00011517          	auipc	a0,0x11
    8000045e:	d2650513          	addi	a0,a0,-730 # 80011180 <cons>
    80000462:	00000097          	auipc	ra,0x0
    80000466:	6de080e7          	jalr	1758(ra) # 80000b40 <initlock>

  uartinit();
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	32c080e7          	jalr	812(ra) # 80000796 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000472:	00021797          	auipc	a5,0x21
    80000476:	4a678793          	addi	a5,a5,1190 # 80021918 <devsw>
    8000047a:	00000717          	auipc	a4,0x0
    8000047e:	cea70713          	addi	a4,a4,-790 # 80000164 <consoleread>
    80000482:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000484:	00000717          	auipc	a4,0x0
    80000488:	c7c70713          	addi	a4,a4,-900 # 80000100 <consolewrite>
    8000048c:	ef98                	sd	a4,24(a5)
}
    8000048e:	60a2                	ld	ra,8(sp)
    80000490:	6402                	ld	s0,0(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret

0000000080000496 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000496:	7179                	addi	sp,sp,-48
    80000498:	f406                	sd	ra,40(sp)
    8000049a:	f022                	sd	s0,32(sp)
    8000049c:	ec26                	sd	s1,24(sp)
    8000049e:	e84a                	sd	s2,16(sp)
    800004a0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a2:	c219                	beqz	a2,800004a8 <printint+0x12>
    800004a4:	08054763          	bltz	a0,80000532 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004a8:	2501                	sext.w	a0,a0
    800004aa:	4881                	li	a7,0
    800004ac:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b2:	2581                	sext.w	a1,a1
    800004b4:	00008617          	auipc	a2,0x8
    800004b8:	b8c60613          	addi	a2,a2,-1140 # 80008040 <digits>
    800004bc:	883a                	mv	a6,a4
    800004be:	2705                	addiw	a4,a4,1
    800004c0:	02b577bb          	remuw	a5,a0,a1
    800004c4:	1782                	slli	a5,a5,0x20
    800004c6:	9381                	srli	a5,a5,0x20
    800004c8:	97b2                	add	a5,a5,a2
    800004ca:	0007c783          	lbu	a5,0(a5)
    800004ce:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d2:	0005079b          	sext.w	a5,a0
    800004d6:	02b5553b          	divuw	a0,a0,a1
    800004da:	0685                	addi	a3,a3,1
    800004dc:	feb7f0e3          	bgeu	a5,a1,800004bc <printint+0x26>

  if(sign)
    800004e0:	00088c63          	beqz	a7,800004f8 <printint+0x62>
    buf[i++] = '-';
    800004e4:	fe070793          	addi	a5,a4,-32
    800004e8:	00878733          	add	a4,a5,s0
    800004ec:	02d00793          	li	a5,45
    800004f0:	fef70823          	sb	a5,-16(a4)
    800004f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004f8:	02e05763          	blez	a4,80000526 <printint+0x90>
    800004fc:	fd040793          	addi	a5,s0,-48
    80000500:	00e784b3          	add	s1,a5,a4
    80000504:	fff78913          	addi	s2,a5,-1
    80000508:	993a                	add	s2,s2,a4
    8000050a:	377d                	addiw	a4,a4,-1
    8000050c:	1702                	slli	a4,a4,0x20
    8000050e:	9301                	srli	a4,a4,0x20
    80000510:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000514:	fff4c503          	lbu	a0,-1(s1)
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	d5e080e7          	jalr	-674(ra) # 80000276 <consputc>
  while(--i >= 0)
    80000520:	14fd                	addi	s1,s1,-1
    80000522:	ff2499e3          	bne	s1,s2,80000514 <printint+0x7e>
}
    80000526:	70a2                	ld	ra,40(sp)
    80000528:	7402                	ld	s0,32(sp)
    8000052a:	64e2                	ld	s1,24(sp)
    8000052c:	6942                	ld	s2,16(sp)
    8000052e:	6145                	addi	sp,sp,48
    80000530:	8082                	ret
    x = -xx;
    80000532:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000536:	4885                	li	a7,1
    x = -xx;
    80000538:	bf95                	j	800004ac <printint+0x16>

000000008000053a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053a:	1101                	addi	sp,sp,-32
    8000053c:	ec06                	sd	ra,24(sp)
    8000053e:	e822                	sd	s0,16(sp)
    80000540:	e426                	sd	s1,8(sp)
    80000542:	1000                	addi	s0,sp,32
    80000544:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000546:	00011797          	auipc	a5,0x11
    8000054a:	ce07ad23          	sw	zero,-774(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000054e:	00008517          	auipc	a0,0x8
    80000552:	aca50513          	addi	a0,a0,-1334 # 80008018 <etext+0x18>
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	02e080e7          	jalr	46(ra) # 80000584 <printf>
  printf(s);
    8000055e:	8526                	mv	a0,s1
    80000560:	00000097          	auipc	ra,0x0
    80000564:	024080e7          	jalr	36(ra) # 80000584 <printf>
  printf("\n");
    80000568:	00008517          	auipc	a0,0x8
    8000056c:	b6050513          	addi	a0,a0,-1184 # 800080c8 <digits+0x88>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	014080e7          	jalr	20(ra) # 80000584 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000578:	4785                	li	a5,1
    8000057a:	00009717          	auipc	a4,0x9
    8000057e:	a8f72323          	sw	a5,-1402(a4) # 80009000 <panicked>
  for(;;)
    80000582:	a001                	j	80000582 <panic+0x48>

0000000080000584 <printf>:
{
    80000584:	7131                	addi	sp,sp,-192
    80000586:	fc86                	sd	ra,120(sp)
    80000588:	f8a2                	sd	s0,112(sp)
    8000058a:	f4a6                	sd	s1,104(sp)
    8000058c:	f0ca                	sd	s2,96(sp)
    8000058e:	ecce                	sd	s3,88(sp)
    80000590:	e8d2                	sd	s4,80(sp)
    80000592:	e4d6                	sd	s5,72(sp)
    80000594:	e0da                	sd	s6,64(sp)
    80000596:	fc5e                	sd	s7,56(sp)
    80000598:	f862                	sd	s8,48(sp)
    8000059a:	f466                	sd	s9,40(sp)
    8000059c:	f06a                	sd	s10,32(sp)
    8000059e:	ec6e                	sd	s11,24(sp)
    800005a0:	0100                	addi	s0,sp,128
    800005a2:	8a2a                	mv	s4,a0
    800005a4:	e40c                	sd	a1,8(s0)
    800005a6:	e810                	sd	a2,16(s0)
    800005a8:	ec14                	sd	a3,24(s0)
    800005aa:	f018                	sd	a4,32(s0)
    800005ac:	f41c                	sd	a5,40(s0)
    800005ae:	03043823          	sd	a6,48(s0)
    800005b2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b6:	00011d97          	auipc	s11,0x11
    800005ba:	c8adad83          	lw	s11,-886(s11) # 80011240 <pr+0x18>
  if(locking)
    800005be:	020d9b63          	bnez	s11,800005f4 <printf+0x70>
  if (fmt == 0)
    800005c2:	040a0263          	beqz	s4,80000606 <printf+0x82>
  va_start(ap, fmt);
    800005c6:	00840793          	addi	a5,s0,8
    800005ca:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005ce:	000a4503          	lbu	a0,0(s4)
    800005d2:	14050f63          	beqz	a0,80000730 <printf+0x1ac>
    800005d6:	4981                	li	s3,0
    if(c != '%'){
    800005d8:	02500a93          	li	s5,37
    switch(c){
    800005dc:	07000b93          	li	s7,112
  consputc('x');
    800005e0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e2:	00008b17          	auipc	s6,0x8
    800005e6:	a5eb0b13          	addi	s6,s6,-1442 # 80008040 <digits>
    switch(c){
    800005ea:	07300c93          	li	s9,115
    800005ee:	06400c13          	li	s8,100
    800005f2:	a82d                	j	8000062c <printf+0xa8>
    acquire(&pr.lock);
    800005f4:	00011517          	auipc	a0,0x11
    800005f8:	c3450513          	addi	a0,a0,-972 # 80011228 <pr>
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	5d4080e7          	jalr	1492(ra) # 80000bd0 <acquire>
    80000604:	bf7d                	j	800005c2 <printf+0x3e>
    panic("null fmt");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a2250513          	addi	a0,a0,-1502 # 80008028 <etext+0x28>
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f2c080e7          	jalr	-212(ra) # 8000053a <panic>
      consputc(c);
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	c60080e7          	jalr	-928(ra) # 80000276 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000061e:	2985                	addiw	s3,s3,1
    80000620:	013a07b3          	add	a5,s4,s3
    80000624:	0007c503          	lbu	a0,0(a5)
    80000628:	10050463          	beqz	a0,80000730 <printf+0x1ac>
    if(c != '%'){
    8000062c:	ff5515e3          	bne	a0,s5,80000616 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000630:	2985                	addiw	s3,s3,1
    80000632:	013a07b3          	add	a5,s4,s3
    80000636:	0007c783          	lbu	a5,0(a5)
    8000063a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000063e:	cbed                	beqz	a5,80000730 <printf+0x1ac>
    switch(c){
    80000640:	05778a63          	beq	a5,s7,80000694 <printf+0x110>
    80000644:	02fbf663          	bgeu	s7,a5,80000670 <printf+0xec>
    80000648:	09978863          	beq	a5,s9,800006d8 <printf+0x154>
    8000064c:	07800713          	li	a4,120
    80000650:	0ce79563          	bne	a5,a4,8000071a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000654:	f8843783          	ld	a5,-120(s0)
    80000658:	00878713          	addi	a4,a5,8
    8000065c:	f8e43423          	sd	a4,-120(s0)
    80000660:	4605                	li	a2,1
    80000662:	85ea                	mv	a1,s10
    80000664:	4388                	lw	a0,0(a5)
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	e30080e7          	jalr	-464(ra) # 80000496 <printint>
      break;
    8000066e:	bf45                	j	8000061e <printf+0x9a>
    switch(c){
    80000670:	09578f63          	beq	a5,s5,8000070e <printf+0x18a>
    80000674:	0b879363          	bne	a5,s8,8000071a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4605                	li	a2,1
    80000686:	45a9                	li	a1,10
    80000688:	4388                	lw	a0,0(a5)
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	e0c080e7          	jalr	-500(ra) # 80000496 <printint>
      break;
    80000692:	b771                	j	8000061e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a4:	03000513          	li	a0,48
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	bce080e7          	jalr	-1074(ra) # 80000276 <consputc>
  consputc('x');
    800006b0:	07800513          	li	a0,120
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	bc2080e7          	jalr	-1086(ra) # 80000276 <consputc>
    800006bc:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006be:	03c95793          	srli	a5,s2,0x3c
    800006c2:	97da                	add	a5,a5,s6
    800006c4:	0007c503          	lbu	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	bae080e7          	jalr	-1106(ra) # 80000276 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d0:	0912                	slli	s2,s2,0x4
    800006d2:	34fd                	addiw	s1,s1,-1
    800006d4:	f4ed                	bnez	s1,800006be <printf+0x13a>
    800006d6:	b7a1                	j	8000061e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	6384                	ld	s1,0(a5)
    800006e6:	cc89                	beqz	s1,80000700 <printf+0x17c>
      for(; *s; s++)
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	d90d                	beqz	a0,8000061e <printf+0x9a>
        consputc(*s);
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	b88080e7          	jalr	-1144(ra) # 80000276 <consputc>
      for(; *s; s++)
    800006f6:	0485                	addi	s1,s1,1
    800006f8:	0004c503          	lbu	a0,0(s1)
    800006fc:	f96d                	bnez	a0,800006ee <printf+0x16a>
    800006fe:	b705                	j	8000061e <printf+0x9a>
        s = "(null)";
    80000700:	00008497          	auipc	s1,0x8
    80000704:	92048493          	addi	s1,s1,-1760 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000708:	02800513          	li	a0,40
    8000070c:	b7cd                	j	800006ee <printf+0x16a>
      consputc('%');
    8000070e:	8556                	mv	a0,s5
    80000710:	00000097          	auipc	ra,0x0
    80000714:	b66080e7          	jalr	-1178(ra) # 80000276 <consputc>
      break;
    80000718:	b719                	j	8000061e <printf+0x9a>
      consputc('%');
    8000071a:	8556                	mv	a0,s5
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	b5a080e7          	jalr	-1190(ra) # 80000276 <consputc>
      consputc(c);
    80000724:	8526                	mv	a0,s1
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b50080e7          	jalr	-1200(ra) # 80000276 <consputc>
      break;
    8000072e:	bdc5                	j	8000061e <printf+0x9a>
  if(locking)
    80000730:	020d9163          	bnez	s11,80000752 <printf+0x1ce>
}
    80000734:	70e6                	ld	ra,120(sp)
    80000736:	7446                	ld	s0,112(sp)
    80000738:	74a6                	ld	s1,104(sp)
    8000073a:	7906                	ld	s2,96(sp)
    8000073c:	69e6                	ld	s3,88(sp)
    8000073e:	6a46                	ld	s4,80(sp)
    80000740:	6aa6                	ld	s5,72(sp)
    80000742:	6b06                	ld	s6,64(sp)
    80000744:	7be2                	ld	s7,56(sp)
    80000746:	7c42                	ld	s8,48(sp)
    80000748:	7ca2                	ld	s9,40(sp)
    8000074a:	7d02                	ld	s10,32(sp)
    8000074c:	6de2                	ld	s11,24(sp)
    8000074e:	6129                	addi	sp,sp,192
    80000750:	8082                	ret
    release(&pr.lock);
    80000752:	00011517          	auipc	a0,0x11
    80000756:	ad650513          	addi	a0,a0,-1322 # 80011228 <pr>
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	52a080e7          	jalr	1322(ra) # 80000c84 <release>
}
    80000762:	bfc9                	j	80000734 <printf+0x1b0>

0000000080000764 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000764:	1101                	addi	sp,sp,-32
    80000766:	ec06                	sd	ra,24(sp)
    80000768:	e822                	sd	s0,16(sp)
    8000076a:	e426                	sd	s1,8(sp)
    8000076c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000076e:	00011497          	auipc	s1,0x11
    80000772:	aba48493          	addi	s1,s1,-1350 # 80011228 <pr>
    80000776:	00008597          	auipc	a1,0x8
    8000077a:	8c258593          	addi	a1,a1,-1854 # 80008038 <etext+0x38>
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	3c0080e7          	jalr	960(ra) # 80000b40 <initlock>
  pr.locking = 1;
    80000788:	4785                	li	a5,1
    8000078a:	cc9c                	sw	a5,24(s1)
}
    8000078c:	60e2                	ld	ra,24(sp)
    8000078e:	6442                	ld	s0,16(sp)
    80000790:	64a2                	ld	s1,8(sp)
    80000792:	6105                	addi	sp,sp,32
    80000794:	8082                	ret

0000000080000796 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000796:	1141                	addi	sp,sp,-16
    80000798:	e406                	sd	ra,8(sp)
    8000079a:	e022                	sd	s0,0(sp)
    8000079c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000079e:	100007b7          	lui	a5,0x10000
    800007a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a6:	f8000713          	li	a4,-128
    800007aa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ae:	470d                	li	a4,3
    800007b0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007b8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007bc:	469d                	li	a3,7
    800007be:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c6:	00008597          	auipc	a1,0x8
    800007ca:	89258593          	addi	a1,a1,-1902 # 80008058 <digits+0x18>
    800007ce:	00011517          	auipc	a0,0x11
    800007d2:	a7a50513          	addi	a0,a0,-1414 # 80011248 <uart_tx_lock>
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	36a080e7          	jalr	874(ra) # 80000b40 <initlock>
}
    800007de:	60a2                	ld	ra,8(sp)
    800007e0:	6402                	ld	s0,0(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e6:	1101                	addi	sp,sp,-32
    800007e8:	ec06                	sd	ra,24(sp)
    800007ea:	e822                	sd	s0,16(sp)
    800007ec:	e426                	sd	s1,8(sp)
    800007ee:	1000                	addi	s0,sp,32
    800007f0:	84aa                	mv	s1,a0
  push_off();
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	392080e7          	jalr	914(ra) # 80000b84 <push_off>

  if(panicked){
    800007fa:	00009797          	auipc	a5,0x9
    800007fe:	8067a783          	lw	a5,-2042(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000802:	10000737          	lui	a4,0x10000
  if(panicked){
    80000806:	c391                	beqz	a5,8000080a <uartputc_sync+0x24>
    for(;;)
    80000808:	a001                	j	80000808 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000080e:	0207f793          	andi	a5,a5,32
    80000812:	dfe5                	beqz	a5,8000080a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000814:	0ff4f513          	zext.b	a0,s1
    80000818:	100007b7          	lui	a5,0x10000
    8000081c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	404080e7          	jalr	1028(ra) # 80000c24 <pop_off>
}
    80000828:	60e2                	ld	ra,24(sp)
    8000082a:	6442                	ld	s0,16(sp)
    8000082c:	64a2                	ld	s1,8(sp)
    8000082e:	6105                	addi	sp,sp,32
    80000830:	8082                	ret

0000000080000832 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000832:	00008797          	auipc	a5,0x8
    80000836:	7d67b783          	ld	a5,2006(a5) # 80009008 <uart_tx_r>
    8000083a:	00008717          	auipc	a4,0x8
    8000083e:	7d673703          	ld	a4,2006(a4) # 80009010 <uart_tx_w>
    80000842:	06f70a63          	beq	a4,a5,800008b6 <uartstart+0x84>
{
    80000846:	7139                	addi	sp,sp,-64
    80000848:	fc06                	sd	ra,56(sp)
    8000084a:	f822                	sd	s0,48(sp)
    8000084c:	f426                	sd	s1,40(sp)
    8000084e:	f04a                	sd	s2,32(sp)
    80000850:	ec4e                	sd	s3,24(sp)
    80000852:	e852                	sd	s4,16(sp)
    80000854:	e456                	sd	s5,8(sp)
    80000856:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000858:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085c:	00011a17          	auipc	s4,0x11
    80000860:	9eca0a13          	addi	s4,s4,-1556 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000864:	00008497          	auipc	s1,0x8
    80000868:	7a448493          	addi	s1,s1,1956 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086c:	00008997          	auipc	s3,0x8
    80000870:	7a498993          	addi	s3,s3,1956 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000878:	02077713          	andi	a4,a4,32
    8000087c:	c705                	beqz	a4,800008a4 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000087e:	01f7f713          	andi	a4,a5,31
    80000882:	9752                	add	a4,a4,s4
    80000884:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000888:	0785                	addi	a5,a5,1
    8000088a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088c:	8526                	mv	a0,s1
    8000088e:	00002097          	auipc	ra,0x2
    80000892:	9ce080e7          	jalr	-1586(ra) # 8000225c <wakeup>
    
    WriteReg(THR, c);
    80000896:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089a:	609c                	ld	a5,0(s1)
    8000089c:	0009b703          	ld	a4,0(s3)
    800008a0:	fcf71ae3          	bne	a4,a5,80000874 <uartstart+0x42>
  }
}
    800008a4:	70e2                	ld	ra,56(sp)
    800008a6:	7442                	ld	s0,48(sp)
    800008a8:	74a2                	ld	s1,40(sp)
    800008aa:	7902                	ld	s2,32(sp)
    800008ac:	69e2                	ld	s3,24(sp)
    800008ae:	6a42                	ld	s4,16(sp)
    800008b0:	6aa2                	ld	s5,8(sp)
    800008b2:	6121                	addi	sp,sp,64
    800008b4:	8082                	ret
    800008b6:	8082                	ret

00000000800008b8 <uartputc>:
{
    800008b8:	7179                	addi	sp,sp,-48
    800008ba:	f406                	sd	ra,40(sp)
    800008bc:	f022                	sd	s0,32(sp)
    800008be:	ec26                	sd	s1,24(sp)
    800008c0:	e84a                	sd	s2,16(sp)
    800008c2:	e44e                	sd	s3,8(sp)
    800008c4:	e052                	sd	s4,0(sp)
    800008c6:	1800                	addi	s0,sp,48
    800008c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ca:	00011517          	auipc	a0,0x11
    800008ce:	97e50513          	addi	a0,a0,-1666 # 80011248 <uart_tx_lock>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	2fe080e7          	jalr	766(ra) # 80000bd0 <acquire>
  if(panicked){
    800008da:	00008797          	auipc	a5,0x8
    800008de:	7267a783          	lw	a5,1830(a5) # 80009000 <panicked>
    800008e2:	c391                	beqz	a5,800008e6 <uartputc+0x2e>
    for(;;)
    800008e4:	a001                	j	800008e4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	72a73703          	ld	a4,1834(a4) # 80009010 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	71a7b783          	ld	a5,1818(a5) # 80009008 <uart_tx_r>
    800008f6:	02078793          	addi	a5,a5,32
    800008fa:	02e79b63          	bne	a5,a4,80000930 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00011997          	auipc	s3,0x11
    80000902:	94a98993          	addi	s3,s3,-1718 # 80011248 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	70248493          	addi	s1,s1,1794 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	70290913          	addi	s2,s2,1794 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00001097          	auipc	ra,0x1
    8000091e:	7b6080e7          	jalr	1974(ra) # 800020d0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	addi	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00011497          	auipc	s1,0x11
    80000934:	91848493          	addi	s1,s1,-1768 # 80011248 <uart_tx_lock>
    80000938:	01f77793          	andi	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000942:	0705                	addi	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	6ce7b623          	sd	a4,1740(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee6080e7          	jalr	-282(ra) # 80000832 <uartstart>
      release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	32e080e7          	jalr	814(ra) # 80000c84 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret

000000008000096e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000096e:	1141                	addi	sp,sp,-16
    80000970:	e422                	sd	s0,8(sp)
    80000972:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000974:	100007b7          	lui	a5,0x10000
    80000978:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097c:	8b85                	andi	a5,a5,1
    8000097e:	cb81                	beqz	a5,8000098e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000980:	100007b7          	lui	a5,0x10000
    80000984:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000988:	6422                	ld	s0,8(sp)
    8000098a:	0141                	addi	sp,sp,16
    8000098c:	8082                	ret
    return -1;
    8000098e:	557d                	li	a0,-1
    80000990:	bfe5                	j	80000988 <uartgetc+0x1a>

0000000080000992 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000992:	1101                	addi	sp,sp,-32
    80000994:	ec06                	sd	ra,24(sp)
    80000996:	e822                	sd	s0,16(sp)
    80000998:	e426                	sd	s1,8(sp)
    8000099a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099c:	54fd                	li	s1,-1
    8000099e:	a029                	j	800009a8 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	918080e7          	jalr	-1768(ra) # 800002b8 <consoleintr>
    int c = uartgetc();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	fc6080e7          	jalr	-58(ra) # 8000096e <uartgetc>
    if(c == -1)
    800009b0:	fe9518e3          	bne	a0,s1,800009a0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b4:	00011497          	auipc	s1,0x11
    800009b8:	89448493          	addi	s1,s1,-1900 # 80011248 <uart_tx_lock>
    800009bc:	8526                	mv	a0,s1
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	212080e7          	jalr	530(ra) # 80000bd0 <acquire>
  uartstart();
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	e6c080e7          	jalr	-404(ra) # 80000832 <uartstart>
  release(&uart_tx_lock);
    800009ce:	8526                	mv	a0,s1
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	2b4080e7          	jalr	692(ra) # 80000c84 <release>
}
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret

00000000800009e2 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e2:	1101                	addi	sp,sp,-32
    800009e4:	ec06                	sd	ra,24(sp)
    800009e6:	e822                	sd	s0,16(sp)
    800009e8:	e426                	sd	s1,8(sp)
    800009ea:	e04a                	sd	s2,0(sp)
    800009ec:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009ee:	03451793          	slli	a5,a0,0x34
    800009f2:	ebb9                	bnez	a5,80000a48 <kfree+0x66>
    800009f4:	84aa                	mv	s1,a0
    800009f6:	00025797          	auipc	a5,0x25
    800009fa:	60a78793          	addi	a5,a5,1546 # 80026000 <end>
    800009fe:	04f56563          	bltu	a0,a5,80000a48 <kfree+0x66>
    80000a02:	47c5                	li	a5,17
    80000a04:	07ee                	slli	a5,a5,0x1b
    80000a06:	04f57163          	bgeu	a0,a5,80000a48 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0a:	6605                	lui	a2,0x1
    80000a0c:	4585                	li	a1,1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	2be080e7          	jalr	702(ra) # 80000ccc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a16:	00011917          	auipc	s2,0x11
    80000a1a:	86a90913          	addi	s2,s2,-1942 # 80011280 <kmem>
    80000a1e:	854a                	mv	a0,s2
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	1b0080e7          	jalr	432(ra) # 80000bd0 <acquire>
  r->next = kmem.freelist;
    80000a28:	01893783          	ld	a5,24(s2)
    80000a2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a32:	854a                	mv	a0,s2
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	250080e7          	jalr	592(ra) # 80000c84 <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6902                	ld	s2,0(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret
    panic("kfree");
    80000a48:	00007517          	auipc	a0,0x7
    80000a4c:	61850513          	addi	a0,a0,1560 # 80008060 <digits+0x20>
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	aea080e7          	jalr	-1302(ra) # 8000053a <panic>

0000000080000a58 <freerange>:
{
    80000a58:	7179                	addi	sp,sp,-48
    80000a5a:	f406                	sd	ra,40(sp)
    80000a5c:	f022                	sd	s0,32(sp)
    80000a5e:	ec26                	sd	s1,24(sp)
    80000a60:	e84a                	sd	s2,16(sp)
    80000a62:	e44e                	sd	s3,8(sp)
    80000a64:	e052                	sd	s4,0(sp)
    80000a66:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a68:	6785                	lui	a5,0x1
    80000a6a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a6e:	00e504b3          	add	s1,a0,a4
    80000a72:	777d                	lui	a4,0xfffff
    80000a74:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a76:	94be                	add	s1,s1,a5
    80000a78:	0095ee63          	bltu	a1,s1,80000a94 <freerange+0x3c>
    80000a7c:	892e                	mv	s2,a1
    kfree(p);
    80000a7e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	6985                	lui	s3,0x1
    kfree(p);
    80000a82:	01448533          	add	a0,s1,s4
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	f5c080e7          	jalr	-164(ra) # 800009e2 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a8e:	94ce                	add	s1,s1,s3
    80000a90:	fe9979e3          	bgeu	s2,s1,80000a82 <freerange+0x2a>
}
    80000a94:	70a2                	ld	ra,40(sp)
    80000a96:	7402                	ld	s0,32(sp)
    80000a98:	64e2                	ld	s1,24(sp)
    80000a9a:	6942                	ld	s2,16(sp)
    80000a9c:	69a2                	ld	s3,8(sp)
    80000a9e:	6a02                	ld	s4,0(sp)
    80000aa0:	6145                	addi	sp,sp,48
    80000aa2:	8082                	ret

0000000080000aa4 <kinit>:
{
    80000aa4:	1141                	addi	sp,sp,-16
    80000aa6:	e406                	sd	ra,8(sp)
    80000aa8:	e022                	sd	s0,0(sp)
    80000aaa:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aac:	00007597          	auipc	a1,0x7
    80000ab0:	5bc58593          	addi	a1,a1,1468 # 80008068 <digits+0x28>
    80000ab4:	00010517          	auipc	a0,0x10
    80000ab8:	7cc50513          	addi	a0,a0,1996 # 80011280 <kmem>
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	084080e7          	jalr	132(ra) # 80000b40 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac4:	45c5                	li	a1,17
    80000ac6:	05ee                	slli	a1,a1,0x1b
    80000ac8:	00025517          	auipc	a0,0x25
    80000acc:	53850513          	addi	a0,a0,1336 # 80026000 <end>
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	f88080e7          	jalr	-120(ra) # 80000a58 <freerange>
}
    80000ad8:	60a2                	ld	ra,8(sp)
    80000ada:	6402                	ld	s0,0(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret

0000000080000ae0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae0:	1101                	addi	sp,sp,-32
    80000ae2:	ec06                	sd	ra,24(sp)
    80000ae4:	e822                	sd	s0,16(sp)
    80000ae6:	e426                	sd	s1,8(sp)
    80000ae8:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aea:	00010497          	auipc	s1,0x10
    80000aee:	79648493          	addi	s1,s1,1942 # 80011280 <kmem>
    80000af2:	8526                	mv	a0,s1
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	0dc080e7          	jalr	220(ra) # 80000bd0 <acquire>
  r = kmem.freelist;
    80000afc:	6c84                	ld	s1,24(s1)
  if(r)
    80000afe:	c885                	beqz	s1,80000b2e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b00:	609c                	ld	a5,0(s1)
    80000b02:	00010517          	auipc	a0,0x10
    80000b06:	77e50513          	addi	a0,a0,1918 # 80011280 <kmem>
    80000b0a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	178080e7          	jalr	376(ra) # 80000c84 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b14:	6605                	lui	a2,0x1
    80000b16:	4595                	li	a1,5
    80000b18:	8526                	mv	a0,s1
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	1b2080e7          	jalr	434(ra) # 80000ccc <memset>
  return (void*)r;
}
    80000b22:	8526                	mv	a0,s1
    80000b24:	60e2                	ld	ra,24(sp)
    80000b26:	6442                	ld	s0,16(sp)
    80000b28:	64a2                	ld	s1,8(sp)
    80000b2a:	6105                	addi	sp,sp,32
    80000b2c:	8082                	ret
  release(&kmem.lock);
    80000b2e:	00010517          	auipc	a0,0x10
    80000b32:	75250513          	addi	a0,a0,1874 # 80011280 <kmem>
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	14e080e7          	jalr	334(ra) # 80000c84 <release>
  if(r)
    80000b3e:	b7d5                	j	80000b22 <kalloc+0x42>

0000000080000b40 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b40:	1141                	addi	sp,sp,-16
    80000b42:	e422                	sd	s0,8(sp)
    80000b44:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b46:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b48:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b4c:	00053823          	sd	zero,16(a0)
}
    80000b50:	6422                	ld	s0,8(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret

0000000080000b56 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b56:	411c                	lw	a5,0(a0)
    80000b58:	e399                	bnez	a5,80000b5e <holding+0x8>
    80000b5a:	4501                	li	a0,0
  return r;
}
    80000b5c:	8082                	ret
{
    80000b5e:	1101                	addi	sp,sp,-32
    80000b60:	ec06                	sd	ra,24(sp)
    80000b62:	e822                	sd	s0,16(sp)
    80000b64:	e426                	sd	s1,8(sp)
    80000b66:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b68:	6904                	ld	s1,16(a0)
    80000b6a:	00001097          	auipc	ra,0x1
    80000b6e:	e10080e7          	jalr	-496(ra) # 8000197a <mycpu>
    80000b72:	40a48533          	sub	a0,s1,a0
    80000b76:	00153513          	seqz	a0,a0
}
    80000b7a:	60e2                	ld	ra,24(sp)
    80000b7c:	6442                	ld	s0,16(sp)
    80000b7e:	64a2                	ld	s1,8(sp)
    80000b80:	6105                	addi	sp,sp,32
    80000b82:	8082                	ret

0000000080000b84 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b84:	1101                	addi	sp,sp,-32
    80000b86:	ec06                	sd	ra,24(sp)
    80000b88:	e822                	sd	s0,16(sp)
    80000b8a:	e426                	sd	s1,8(sp)
    80000b8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b8e:	100024f3          	csrr	s1,sstatus
    80000b92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b98:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9c:	00001097          	auipc	ra,0x1
    80000ba0:	dde080e7          	jalr	-546(ra) # 8000197a <mycpu>
    80000ba4:	5d3c                	lw	a5,120(a0)
    80000ba6:	cf89                	beqz	a5,80000bc0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ba8:	00001097          	auipc	ra,0x1
    80000bac:	dd2080e7          	jalr	-558(ra) # 8000197a <mycpu>
    80000bb0:	5d3c                	lw	a5,120(a0)
    80000bb2:	2785                	addiw	a5,a5,1
    80000bb4:	dd3c                	sw	a5,120(a0)
}
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
    mycpu()->intena = old;
    80000bc0:	00001097          	auipc	ra,0x1
    80000bc4:	dba080e7          	jalr	-582(ra) # 8000197a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc8:	8085                	srli	s1,s1,0x1
    80000bca:	8885                	andi	s1,s1,1
    80000bcc:	dd64                	sw	s1,124(a0)
    80000bce:	bfe9                	j	80000ba8 <push_off+0x24>

0000000080000bd0 <acquire>:
{
    80000bd0:	1101                	addi	sp,sp,-32
    80000bd2:	ec06                	sd	ra,24(sp)
    80000bd4:	e822                	sd	s0,16(sp)
    80000bd6:	e426                	sd	s1,8(sp)
    80000bd8:	1000                	addi	s0,sp,32
    80000bda:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	fa8080e7          	jalr	-88(ra) # 80000b84 <push_off>
  if(holding(lk))
    80000be4:	8526                	mv	a0,s1
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	f70080e7          	jalr	-144(ra) # 80000b56 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bee:	4705                	li	a4,1
  if(holding(lk))
    80000bf0:	e115                	bnez	a0,80000c14 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf2:	87ba                	mv	a5,a4
    80000bf4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bf8:	2781                	sext.w	a5,a5
    80000bfa:	ffe5                	bnez	a5,80000bf2 <acquire+0x22>
  __sync_synchronize();
    80000bfc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	d7a080e7          	jalr	-646(ra) # 8000197a <mycpu>
    80000c08:	e888                	sd	a0,16(s1)
}
    80000c0a:	60e2                	ld	ra,24(sp)
    80000c0c:	6442                	ld	s0,16(sp)
    80000c0e:	64a2                	ld	s1,8(sp)
    80000c10:	6105                	addi	sp,sp,32
    80000c12:	8082                	ret
    panic("acquire");
    80000c14:	00007517          	auipc	a0,0x7
    80000c18:	45c50513          	addi	a0,a0,1116 # 80008070 <digits+0x30>
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	91e080e7          	jalr	-1762(ra) # 8000053a <panic>

0000000080000c24 <pop_off>:

void
pop_off(void)
{
    80000c24:	1141                	addi	sp,sp,-16
    80000c26:	e406                	sd	ra,8(sp)
    80000c28:	e022                	sd	s0,0(sp)
    80000c2a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c2c:	00001097          	auipc	ra,0x1
    80000c30:	d4e080e7          	jalr	-690(ra) # 8000197a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c3a:	e78d                	bnez	a5,80000c64 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05b63          	blez	a5,80000c74 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	0007871b          	sext.w	a4,a5
    80000c48:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4a:	eb09                	bnez	a4,80000c5c <pop_off+0x38>
    80000c4c:	5d7c                	lw	a5,124(a0)
    80000c4e:	c799                	beqz	a5,80000c5c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	41450513          	addi	a0,a0,1044 # 80008078 <digits+0x38>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8ce080e7          	jalr	-1842(ra) # 8000053a <panic>
    panic("pop_off");
    80000c74:	00007517          	auipc	a0,0x7
    80000c78:	41c50513          	addi	a0,a0,1052 # 80008090 <digits+0x50>
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	8be080e7          	jalr	-1858(ra) # 8000053a <panic>

0000000080000c84 <release>:
{
    80000c84:	1101                	addi	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	addi	s0,sp,32
    80000c8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	ec6080e7          	jalr	-314(ra) # 80000b56 <holding>
    80000c98:	c115                	beqz	a0,80000cbc <release+0x38>
  lk->cpu = 0;
    80000c9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca2:	0f50000f          	fence	iorw,ow
    80000ca6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	f7a080e7          	jalr	-134(ra) # 80000c24 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00007517          	auipc	a0,0x7
    80000cc0:	3dc50513          	addi	a0,a0,988 # 80008098 <digits+0x58>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	876080e7          	jalr	-1930(ra) # 8000053a <panic>

0000000080000ccc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e422                	sd	s0,8(sp)
    80000cd0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd2:	ca19                	beqz	a2,80000ce8 <memset+0x1c>
    80000cd4:	87aa                	mv	a5,a0
    80000cd6:	1602                	slli	a2,a2,0x20
    80000cd8:	9201                	srli	a2,a2,0x20
    80000cda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce2:	0785                	addi	a5,a5,1
    80000ce4:	fee79de3          	bne	a5,a4,80000cde <memset+0x12>
  }
  return dst;
}
    80000ce8:	6422                	ld	s0,8(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret

0000000080000cee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cee:	1141                	addi	sp,sp,-16
    80000cf0:	e422                	sd	s0,8(sp)
    80000cf2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf4:	ca05                	beqz	a2,80000d24 <memcmp+0x36>
    80000cf6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	0685                	addi	a3,a3,1
    80000d00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d02:	00054783          	lbu	a5,0(a0)
    80000d06:	0005c703          	lbu	a4,0(a1)
    80000d0a:	00e79863          	bne	a5,a4,80000d1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0e:	0505                	addi	a0,a0,1
    80000d10:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d12:	fed518e3          	bne	a0,a3,80000d02 <memcmp+0x14>
  }

  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	a019                	j	80000d1e <memcmp+0x30>
      return *s1 - *s2;
    80000d1a:	40e7853b          	subw	a0,a5,a4
}
    80000d1e:	6422                	ld	s0,8(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret
  return 0;
    80000d24:	4501                	li	a0,0
    80000d26:	bfe5                	j	80000d1e <memcmp+0x30>

0000000080000d28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e422                	sd	s0,8(sp)
    80000d2c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2e:	c205                	beqz	a2,80000d4e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d30:	02a5e263          	bltu	a1,a0,80000d54 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d34:	1602                	slli	a2,a2,0x20
    80000d36:	9201                	srli	a2,a2,0x20
    80000d38:	00c587b3          	add	a5,a1,a2
{
    80000d3c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3e:	0585                	addi	a1,a1,1
    80000d40:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd9001>
    80000d42:	fff5c683          	lbu	a3,-1(a1)
    80000d46:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4a:	fef59ae3          	bne	a1,a5,80000d3e <memmove+0x16>

  return dst;
}
    80000d4e:	6422                	ld	s0,8(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  if(s < d && s + n > d){
    80000d54:	02061693          	slli	a3,a2,0x20
    80000d58:	9281                	srli	a3,a3,0x20
    80000d5a:	00d58733          	add	a4,a1,a3
    80000d5e:	fce57be3          	bgeu	a0,a4,80000d34 <memmove+0xc>
    d += n;
    80000d62:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d64:	fff6079b          	addiw	a5,a2,-1
    80000d68:	1782                	slli	a5,a5,0x20
    80000d6a:	9381                	srli	a5,a5,0x20
    80000d6c:	fff7c793          	not	a5,a5
    80000d70:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d72:	177d                	addi	a4,a4,-1
    80000d74:	16fd                	addi	a3,a3,-1
    80000d76:	00074603          	lbu	a2,0(a4)
    80000d7a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7e:	fee79ae3          	bne	a5,a4,80000d72 <memmove+0x4a>
    80000d82:	b7f1                	j	80000d4e <memmove+0x26>

0000000080000d84 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e406                	sd	ra,8(sp)
    80000d88:	e022                	sd	s0,0(sp)
    80000d8a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	f9c080e7          	jalr	-100(ra) # 80000d28 <memmove>
}
    80000d94:	60a2                	ld	ra,8(sp)
    80000d96:	6402                	ld	s0,0(sp)
    80000d98:	0141                	addi	sp,sp,16
    80000d9a:	8082                	ret

0000000080000d9c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9c:	1141                	addi	sp,sp,-16
    80000d9e:	e422                	sd	s0,8(sp)
    80000da0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da2:	ce11                	beqz	a2,80000dbe <strncmp+0x22>
    80000da4:	00054783          	lbu	a5,0(a0)
    80000da8:	cf89                	beqz	a5,80000dc2 <strncmp+0x26>
    80000daa:	0005c703          	lbu	a4,0(a1)
    80000dae:	00f71a63          	bne	a4,a5,80000dc2 <strncmp+0x26>
    n--, p++, q++;
    80000db2:	367d                	addiw	a2,a2,-1
    80000db4:	0505                	addi	a0,a0,1
    80000db6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db8:	f675                	bnez	a2,80000da4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dba:	4501                	li	a0,0
    80000dbc:	a809                	j	80000dce <strncmp+0x32>
    80000dbe:	4501                	li	a0,0
    80000dc0:	a039                	j	80000dce <strncmp+0x32>
  if(n == 0)
    80000dc2:	ca09                	beqz	a2,80000dd4 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dc4:	00054503          	lbu	a0,0(a0)
    80000dc8:	0005c783          	lbu	a5,0(a1)
    80000dcc:	9d1d                	subw	a0,a0,a5
}
    80000dce:	6422                	ld	s0,8(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret
    return 0;
    80000dd4:	4501                	li	a0,0
    80000dd6:	bfe5                	j	80000dce <strncmp+0x32>

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dde:	872a                	mv	a4,a0
    80000de0:	8832                	mv	a6,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	01005963          	blez	a6,80000df6 <strncpy+0x1e>
    80000de8:	0705                	addi	a4,a4,1
    80000dea:	0005c783          	lbu	a5,0(a1)
    80000dee:	fef70fa3          	sb	a5,-1(a4)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f7f5                	bnez	a5,80000de0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df6:	86ba                	mv	a3,a4
    80000df8:	00c05c63          	blez	a2,80000e10 <strncpy+0x38>
    *s++ = 0;
    80000dfc:	0685                	addi	a3,a3,1
    80000dfe:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e02:	40d707bb          	subw	a5,a4,a3
    80000e06:	37fd                	addiw	a5,a5,-1
    80000e08:	010787bb          	addw	a5,a5,a6
    80000e0c:	fef048e3          	bgtz	a5,80000dfc <strncpy+0x24>
  return os;
}
    80000e10:	6422                	ld	s0,8(sp)
    80000e12:	0141                	addi	sp,sp,16
    80000e14:	8082                	ret

0000000080000e16 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1c:	02c05363          	blez	a2,80000e42 <safestrcpy+0x2c>
    80000e20:	fff6069b          	addiw	a3,a2,-1
    80000e24:	1682                	slli	a3,a3,0x20
    80000e26:	9281                	srli	a3,a3,0x20
    80000e28:	96ae                	add	a3,a3,a1
    80000e2a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2c:	00d58963          	beq	a1,a3,80000e3e <safestrcpy+0x28>
    80000e30:	0585                	addi	a1,a1,1
    80000e32:	0785                	addi	a5,a5,1
    80000e34:	fff5c703          	lbu	a4,-1(a1)
    80000e38:	fee78fa3          	sb	a4,-1(a5)
    80000e3c:	fb65                	bnez	a4,80000e2c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <strlen>:

int
strlen(const char *s)
{
    80000e48:	1141                	addi	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf91                	beqz	a5,80000e6e <strlen+0x26>
    80000e54:	0505                	addi	a0,a0,1
    80000e56:	87aa                	mv	a5,a0
    80000e58:	4685                	li	a3,1
    80000e5a:	9e89                	subw	a3,a3,a0
    80000e5c:	00f6853b          	addw	a0,a3,a5
    80000e60:	0785                	addi	a5,a5,1
    80000e62:	fff7c703          	lbu	a4,-1(a5)
    80000e66:	fb7d                	bnez	a4,80000e5c <strlen+0x14>
    ;
  return n;
}
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strlen+0x20>

0000000080000e72 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e7a:	00001097          	auipc	ra,0x1
    80000e7e:	af0080e7          	jalr	-1296(ra) # 8000196a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	19670713          	addi	a4,a4,406 # 80009018 <started>
  if(cpuid() == 0){
    80000e8a:	c139                	beqz	a0,80000ed0 <main+0x5e>
    while(started == 0)
    80000e8c:	431c                	lw	a5,0(a4)
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	dff5                	beqz	a5,80000e8c <main+0x1a>
      ;
    __sync_synchronize();
    80000e92:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e96:	00001097          	auipc	ra,0x1
    80000e9a:	ad4080e7          	jalr	-1324(ra) # 8000196a <cpuid>
    80000e9e:	85aa                	mv	a1,a0
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	21850513          	addi	a0,a0,536 # 800080b8 <digits+0x78>
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	6dc080e7          	jalr	1756(ra) # 80000584 <printf>
    kvminithart();    // turn on paging
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	0d8080e7          	jalr	216(ra) # 80000f88 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	c28080e7          	jalr	-984(ra) # 80002ae0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	2d0080e7          	jalr	720(ra) # 80006190 <plicinithart>
  }

  scheduler();        
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	01e080e7          	jalr	30(ra) # 80001ee6 <scheduler>
    consoleinit();
    80000ed0:	fffff097          	auipc	ra,0xfffff
    80000ed4:	57a080e7          	jalr	1402(ra) # 8000044a <consoleinit>
    printfinit();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	88c080e7          	jalr	-1908(ra) # 80000764 <printfinit>
    printf("\n");
    80000ee0:	00007517          	auipc	a0,0x7
    80000ee4:	1e850513          	addi	a0,a0,488 # 800080c8 <digits+0x88>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	69c080e7          	jalr	1692(ra) # 80000584 <printf>
    printf("xv6 kernel is booting\n");
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1b050513          	addi	a0,a0,432 # 800080a0 <digits+0x60>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	68c080e7          	jalr	1676(ra) # 80000584 <printf>
    printf("\n");
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	1c850513          	addi	a0,a0,456 # 800080c8 <digits+0x88>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	67c080e7          	jalr	1660(ra) # 80000584 <printf>
    kinit();         // physical page allocator
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	b94080e7          	jalr	-1132(ra) # 80000aa4 <kinit>
    kvminit();       // create kernel page table
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	322080e7          	jalr	802(ra) # 8000123a <kvminit>
    kvminithart();   // turn on paging
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	068080e7          	jalr	104(ra) # 80000f88 <kvminithart>
    procinit();      // process table
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	992080e7          	jalr	-1646(ra) # 800018ba <procinit>
    trapinit();      // trap vectors
    80000f30:	00002097          	auipc	ra,0x2
    80000f34:	b88080e7          	jalr	-1144(ra) # 80002ab8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f38:	00002097          	auipc	ra,0x2
    80000f3c:	ba8080e7          	jalr	-1112(ra) # 80002ae0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	23a080e7          	jalr	570(ra) # 8000617a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	248080e7          	jalr	584(ra) # 80006190 <plicinithart>
    binit();         // buffer cache
    80000f50:	00002097          	auipc	ra,0x2
    80000f54:	410080e7          	jalr	1040(ra) # 80003360 <binit>
    iinit();         // inode table
    80000f58:	00003097          	auipc	ra,0x3
    80000f5c:	a9e080e7          	jalr	-1378(ra) # 800039f6 <iinit>
    fileinit();      // file table
    80000f60:	00004097          	auipc	ra,0x4
    80000f64:	a50080e7          	jalr	-1456(ra) # 800049b0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	348080e7          	jalr	840(ra) # 800062b0 <virtio_disk_init>
    userinit();      // first user process
    80000f70:	00001097          	auipc	ra,0x1
    80000f74:	d3c080e7          	jalr	-708(ra) # 80001cac <userinit>
    __sync_synchronize();
    80000f78:	0ff0000f          	fence
    started = 1;
    80000f7c:	4785                	li	a5,1
    80000f7e:	00008717          	auipc	a4,0x8
    80000f82:	08f72d23          	sw	a5,154(a4) # 80009018 <started>
    80000f86:	b789                	j	80000ec8 <main+0x56>

0000000080000f88 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f88:	1141                	addi	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	0927b783          	ld	a5,146(a5) # 80009020 <kernel_pagetable>
    80000f96:	83b1                	srli	a5,a5,0xc
    80000f98:	577d                	li	a4,-1
    80000f9a:	177e                	slli	a4,a4,0x3f
    80000f9c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f9e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fa2:	12000073          	sfence.vma
  sfence_vma();
}
    80000fa6:	6422                	ld	s0,8(sp)
    80000fa8:	0141                	addi	sp,sp,16
    80000faa:	8082                	ret

0000000080000fac <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fac:	7139                	addi	sp,sp,-64
    80000fae:	fc06                	sd	ra,56(sp)
    80000fb0:	f822                	sd	s0,48(sp)
    80000fb2:	f426                	sd	s1,40(sp)
    80000fb4:	f04a                	sd	s2,32(sp)
    80000fb6:	ec4e                	sd	s3,24(sp)
    80000fb8:	e852                	sd	s4,16(sp)
    80000fba:	e456                	sd	s5,8(sp)
    80000fbc:	e05a                	sd	s6,0(sp)
    80000fbe:	0080                	addi	s0,sp,64
    80000fc0:	84aa                	mv	s1,a0
    80000fc2:	89ae                	mv	s3,a1
    80000fc4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fc6:	57fd                	li	a5,-1
    80000fc8:	83e9                	srli	a5,a5,0x1a
    80000fca:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fcc:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fce:	04b7f263          	bgeu	a5,a1,80001012 <walk+0x66>
    panic("walk");
    80000fd2:	00007517          	auipc	a0,0x7
    80000fd6:	0fe50513          	addi	a0,a0,254 # 800080d0 <digits+0x90>
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	560080e7          	jalr	1376(ra) # 8000053a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fe2:	060a8663          	beqz	s5,8000104e <walk+0xa2>
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	afa080e7          	jalr	-1286(ra) # 80000ae0 <kalloc>
    80000fee:	84aa                	mv	s1,a0
    80000ff0:	c529                	beqz	a0,8000103a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ff2:	6605                	lui	a2,0x1
    80000ff4:	4581                	li	a1,0
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	cd6080e7          	jalr	-810(ra) # 80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ffe:	00c4d793          	srli	a5,s1,0xc
    80001002:	07aa                	slli	a5,a5,0xa
    80001004:	0017e793          	ori	a5,a5,1
    80001008:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000100c:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    8000100e:	036a0063          	beq	s4,s6,8000102e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001012:	0149d933          	srl	s2,s3,s4
    80001016:	1ff97913          	andi	s2,s2,511
    8000101a:	090e                	slli	s2,s2,0x3
    8000101c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000101e:	00093483          	ld	s1,0(s2)
    80001022:	0014f793          	andi	a5,s1,1
    80001026:	dfd5                	beqz	a5,80000fe2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001028:	80a9                	srli	s1,s1,0xa
    8000102a:	04b2                	slli	s1,s1,0xc
    8000102c:	b7c5                	j	8000100c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000102e:	00c9d513          	srli	a0,s3,0xc
    80001032:	1ff57513          	andi	a0,a0,511
    80001036:	050e                	slli	a0,a0,0x3
    80001038:	9526                	add	a0,a0,s1
}
    8000103a:	70e2                	ld	ra,56(sp)
    8000103c:	7442                	ld	s0,48(sp)
    8000103e:	74a2                	ld	s1,40(sp)
    80001040:	7902                	ld	s2,32(sp)
    80001042:	69e2                	ld	s3,24(sp)
    80001044:	6a42                	ld	s4,16(sp)
    80001046:	6aa2                	ld	s5,8(sp)
    80001048:	6b02                	ld	s6,0(sp)
    8000104a:	6121                	addi	sp,sp,64
    8000104c:	8082                	ret
        return 0;
    8000104e:	4501                	li	a0,0
    80001050:	b7ed                	j	8000103a <walk+0x8e>

0000000080001052 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001052:	57fd                	li	a5,-1
    80001054:	83e9                	srli	a5,a5,0x1a
    80001056:	00b7f463          	bgeu	a5,a1,8000105e <walkaddr+0xc>
    return 0;
    8000105a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000105c:	8082                	ret
{
    8000105e:	1141                	addi	sp,sp,-16
    80001060:	e406                	sd	ra,8(sp)
    80001062:	e022                	sd	s0,0(sp)
    80001064:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001066:	4601                	li	a2,0
    80001068:	00000097          	auipc	ra,0x0
    8000106c:	f44080e7          	jalr	-188(ra) # 80000fac <walk>
  if(pte == 0)
    80001070:	c105                	beqz	a0,80001090 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001072:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001074:	0117f693          	andi	a3,a5,17
    80001078:	4745                	li	a4,17
    return 0;
    8000107a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000107c:	00e68663          	beq	a3,a4,80001088 <walkaddr+0x36>
}
    80001080:	60a2                	ld	ra,8(sp)
    80001082:	6402                	ld	s0,0(sp)
    80001084:	0141                	addi	sp,sp,16
    80001086:	8082                	ret
  pa = PTE2PA(*pte);
    80001088:	83a9                	srli	a5,a5,0xa
    8000108a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000108e:	bfcd                	j	80001080 <walkaddr+0x2e>
    return 0;
    80001090:	4501                	li	a0,0
    80001092:	b7fd                	j	80001080 <walkaddr+0x2e>

0000000080001094 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001094:	715d                	addi	sp,sp,-80
    80001096:	e486                	sd	ra,72(sp)
    80001098:	e0a2                	sd	s0,64(sp)
    8000109a:	fc26                	sd	s1,56(sp)
    8000109c:	f84a                	sd	s2,48(sp)
    8000109e:	f44e                	sd	s3,40(sp)
    800010a0:	f052                	sd	s4,32(sp)
    800010a2:	ec56                	sd	s5,24(sp)
    800010a4:	e85a                	sd	s6,16(sp)
    800010a6:	e45e                	sd	s7,8(sp)
    800010a8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010aa:	c639                	beqz	a2,800010f8 <mappages+0x64>
    800010ac:	8aaa                	mv	s5,a0
    800010ae:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010b0:	777d                	lui	a4,0xfffff
    800010b2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010b6:	fff58993          	addi	s3,a1,-1
    800010ba:	99b2                	add	s3,s3,a2
    800010bc:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c0:	893e                	mv	s2,a5
    800010c2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010c6:	6b85                	lui	s7,0x1
    800010c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010cc:	4605                	li	a2,1
    800010ce:	85ca                	mv	a1,s2
    800010d0:	8556                	mv	a0,s5
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	eda080e7          	jalr	-294(ra) # 80000fac <walk>
    800010da:	cd1d                	beqz	a0,80001118 <mappages+0x84>
    if(*pte & PTE_V)
    800010dc:	611c                	ld	a5,0(a0)
    800010de:	8b85                	andi	a5,a5,1
    800010e0:	e785                	bnez	a5,80001108 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010e2:	80b1                	srli	s1,s1,0xc
    800010e4:	04aa                	slli	s1,s1,0xa
    800010e6:	0164e4b3          	or	s1,s1,s6
    800010ea:	0014e493          	ori	s1,s1,1
    800010ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f0:	05390063          	beq	s2,s3,80001130 <mappages+0x9c>
    a += PGSIZE;
    800010f4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010f6:	bfc9                	j	800010c8 <mappages+0x34>
    panic("mappages: size");
    800010f8:	00007517          	auipc	a0,0x7
    800010fc:	fe050513          	addi	a0,a0,-32 # 800080d8 <digits+0x98>
    80001100:	fffff097          	auipc	ra,0xfffff
    80001104:	43a080e7          	jalr	1082(ra) # 8000053a <panic>
      panic("mappages: remap");
    80001108:	00007517          	auipc	a0,0x7
    8000110c:	fe050513          	addi	a0,a0,-32 # 800080e8 <digits+0xa8>
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	42a080e7          	jalr	1066(ra) # 8000053a <panic>
      return -1;
    80001118:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000111a:	60a6                	ld	ra,72(sp)
    8000111c:	6406                	ld	s0,64(sp)
    8000111e:	74e2                	ld	s1,56(sp)
    80001120:	7942                	ld	s2,48(sp)
    80001122:	79a2                	ld	s3,40(sp)
    80001124:	7a02                	ld	s4,32(sp)
    80001126:	6ae2                	ld	s5,24(sp)
    80001128:	6b42                	ld	s6,16(sp)
    8000112a:	6ba2                	ld	s7,8(sp)
    8000112c:	6161                	addi	sp,sp,80
    8000112e:	8082                	ret
  return 0;
    80001130:	4501                	li	a0,0
    80001132:	b7e5                	j	8000111a <mappages+0x86>

0000000080001134 <kvmmap>:
{
    80001134:	1141                	addi	sp,sp,-16
    80001136:	e406                	sd	ra,8(sp)
    80001138:	e022                	sd	s0,0(sp)
    8000113a:	0800                	addi	s0,sp,16
    8000113c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000113e:	86b2                	mv	a3,a2
    80001140:	863e                	mv	a2,a5
    80001142:	00000097          	auipc	ra,0x0
    80001146:	f52080e7          	jalr	-174(ra) # 80001094 <mappages>
    8000114a:	e509                	bnez	a0,80001154 <kvmmap+0x20>
}
    8000114c:	60a2                	ld	ra,8(sp)
    8000114e:	6402                	ld	s0,0(sp)
    80001150:	0141                	addi	sp,sp,16
    80001152:	8082                	ret
    panic("kvmmap");
    80001154:	00007517          	auipc	a0,0x7
    80001158:	fa450513          	addi	a0,a0,-92 # 800080f8 <digits+0xb8>
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	3de080e7          	jalr	990(ra) # 8000053a <panic>

0000000080001164 <kvmmake>:
{
    80001164:	1101                	addi	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	e04a                	sd	s2,0(sp)
    8000116e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001170:	00000097          	auipc	ra,0x0
    80001174:	970080e7          	jalr	-1680(ra) # 80000ae0 <kalloc>
    80001178:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000117a:	6605                	lui	a2,0x1
    8000117c:	4581                	li	a1,0
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	b4e080e7          	jalr	-1202(ra) # 80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001186:	4719                	li	a4,6
    80001188:	6685                	lui	a3,0x1
    8000118a:	10000637          	lui	a2,0x10000
    8000118e:	100005b7          	lui	a1,0x10000
    80001192:	8526                	mv	a0,s1
    80001194:	00000097          	auipc	ra,0x0
    80001198:	fa0080e7          	jalr	-96(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000119c:	4719                	li	a4,6
    8000119e:	6685                	lui	a3,0x1
    800011a0:	10001637          	lui	a2,0x10001
    800011a4:	100015b7          	lui	a1,0x10001
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f8a080e7          	jalr	-118(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011b2:	4719                	li	a4,6
    800011b4:	004006b7          	lui	a3,0x400
    800011b8:	0c000637          	lui	a2,0xc000
    800011bc:	0c0005b7          	lui	a1,0xc000
    800011c0:	8526                	mv	a0,s1
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	f72080e7          	jalr	-142(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011ca:	00007917          	auipc	s2,0x7
    800011ce:	e3690913          	addi	s2,s2,-458 # 80008000 <etext>
    800011d2:	4729                	li	a4,10
    800011d4:	80007697          	auipc	a3,0x80007
    800011d8:	e2c68693          	addi	a3,a3,-468 # 8000 <_entry-0x7fff8000>
    800011dc:	4605                	li	a2,1
    800011de:	067e                	slli	a2,a2,0x1f
    800011e0:	85b2                	mv	a1,a2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f50080e7          	jalr	-176(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011ec:	4719                	li	a4,6
    800011ee:	46c5                	li	a3,17
    800011f0:	06ee                	slli	a3,a3,0x1b
    800011f2:	412686b3          	sub	a3,a3,s2
    800011f6:	864a                	mv	a2,s2
    800011f8:	85ca                	mv	a1,s2
    800011fa:	8526                	mv	a0,s1
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	f38080e7          	jalr	-200(ra) # 80001134 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001204:	4729                	li	a4,10
    80001206:	6685                	lui	a3,0x1
    80001208:	00006617          	auipc	a2,0x6
    8000120c:	df860613          	addi	a2,a2,-520 # 80007000 <_trampoline>
    80001210:	040005b7          	lui	a1,0x4000
    80001214:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001216:	05b2                	slli	a1,a1,0xc
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	f1a080e7          	jalr	-230(ra) # 80001134 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	600080e7          	jalr	1536(ra) # 80001824 <proc_mapstacks>
}
    8000122c:	8526                	mv	a0,s1
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret

000000008000123a <kvminit>:
{
    8000123a:	1141                	addi	sp,sp,-16
    8000123c:	e406                	sd	ra,8(sp)
    8000123e:	e022                	sd	s0,0(sp)
    80001240:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001242:	00000097          	auipc	ra,0x0
    80001246:	f22080e7          	jalr	-222(ra) # 80001164 <kvmmake>
    8000124a:	00008797          	auipc	a5,0x8
    8000124e:	dca7bb23          	sd	a0,-554(a5) # 80009020 <kernel_pagetable>
}
    80001252:	60a2                	ld	ra,8(sp)
    80001254:	6402                	ld	s0,0(sp)
    80001256:	0141                	addi	sp,sp,16
    80001258:	8082                	ret

000000008000125a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000125a:	715d                	addi	sp,sp,-80
    8000125c:	e486                	sd	ra,72(sp)
    8000125e:	e0a2                	sd	s0,64(sp)
    80001260:	fc26                	sd	s1,56(sp)
    80001262:	f84a                	sd	s2,48(sp)
    80001264:	f44e                	sd	s3,40(sp)
    80001266:	f052                	sd	s4,32(sp)
    80001268:	ec56                	sd	s5,24(sp)
    8000126a:	e85a                	sd	s6,16(sp)
    8000126c:	e45e                	sd	s7,8(sp)
    8000126e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001270:	03459793          	slli	a5,a1,0x34
    80001274:	e795                	bnez	a5,800012a0 <uvmunmap+0x46>
    80001276:	8a2a                	mv	s4,a0
    80001278:	892e                	mv	s2,a1
    8000127a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127c:	0632                	slli	a2,a2,0xc
    8000127e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001282:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001284:	6b05                	lui	s6,0x1
    80001286:	0735e263          	bltu	a1,s3,800012ea <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000128a:	60a6                	ld	ra,72(sp)
    8000128c:	6406                	ld	s0,64(sp)
    8000128e:	74e2                	ld	s1,56(sp)
    80001290:	7942                	ld	s2,48(sp)
    80001292:	79a2                	ld	s3,40(sp)
    80001294:	7a02                	ld	s4,32(sp)
    80001296:	6ae2                	ld	s5,24(sp)
    80001298:	6b42                	ld	s6,16(sp)
    8000129a:	6ba2                	ld	s7,8(sp)
    8000129c:	6161                	addi	sp,sp,80
    8000129e:	8082                	ret
    panic("uvmunmap: not aligned");
    800012a0:	00007517          	auipc	a0,0x7
    800012a4:	e6050513          	addi	a0,a0,-416 # 80008100 <digits+0xc0>
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	292080e7          	jalr	658(ra) # 8000053a <panic>
      panic("uvmunmap: walk");
    800012b0:	00007517          	auipc	a0,0x7
    800012b4:	e6850513          	addi	a0,a0,-408 # 80008118 <digits+0xd8>
    800012b8:	fffff097          	auipc	ra,0xfffff
    800012bc:	282080e7          	jalr	642(ra) # 8000053a <panic>
      panic("uvmunmap: not mapped");
    800012c0:	00007517          	auipc	a0,0x7
    800012c4:	e6850513          	addi	a0,a0,-408 # 80008128 <digits+0xe8>
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	272080e7          	jalr	626(ra) # 8000053a <panic>
      panic("uvmunmap: not a leaf");
    800012d0:	00007517          	auipc	a0,0x7
    800012d4:	e7050513          	addi	a0,a0,-400 # 80008140 <digits+0x100>
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	262080e7          	jalr	610(ra) # 8000053a <panic>
    *pte = 0;
    800012e0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e4:	995a                	add	s2,s2,s6
    800012e6:	fb3972e3          	bgeu	s2,s3,8000128a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012ea:	4601                	li	a2,0
    800012ec:	85ca                	mv	a1,s2
    800012ee:	8552                	mv	a0,s4
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	cbc080e7          	jalr	-836(ra) # 80000fac <walk>
    800012f8:	84aa                	mv	s1,a0
    800012fa:	d95d                	beqz	a0,800012b0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012fc:	6108                	ld	a0,0(a0)
    800012fe:	00157793          	andi	a5,a0,1
    80001302:	dfdd                	beqz	a5,800012c0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001304:	3ff57793          	andi	a5,a0,1023
    80001308:	fd7784e3          	beq	a5,s7,800012d0 <uvmunmap+0x76>
    if(do_free){
    8000130c:	fc0a8ae3          	beqz	s5,800012e0 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001310:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001312:	0532                	slli	a0,a0,0xc
    80001314:	fffff097          	auipc	ra,0xfffff
    80001318:	6ce080e7          	jalr	1742(ra) # 800009e2 <kfree>
    8000131c:	b7d1                	j	800012e0 <uvmunmap+0x86>

000000008000131e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000131e:	1101                	addi	sp,sp,-32
    80001320:	ec06                	sd	ra,24(sp)
    80001322:	e822                	sd	s0,16(sp)
    80001324:	e426                	sd	s1,8(sp)
    80001326:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	7b8080e7          	jalr	1976(ra) # 80000ae0 <kalloc>
    80001330:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001332:	c519                	beqz	a0,80001340 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001334:	6605                	lui	a2,0x1
    80001336:	4581                	li	a1,0
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	994080e7          	jalr	-1644(ra) # 80000ccc <memset>
  return pagetable;
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret

000000008000134c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000134c:	7179                	addi	sp,sp,-48
    8000134e:	f406                	sd	ra,40(sp)
    80001350:	f022                	sd	s0,32(sp)
    80001352:	ec26                	sd	s1,24(sp)
    80001354:	e84a                	sd	s2,16(sp)
    80001356:	e44e                	sd	s3,8(sp)
    80001358:	e052                	sd	s4,0(sp)
    8000135a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000135c:	6785                	lui	a5,0x1
    8000135e:	04f67863          	bgeu	a2,a5,800013ae <uvminit+0x62>
    80001362:	8a2a                	mv	s4,a0
    80001364:	89ae                	mv	s3,a1
    80001366:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	778080e7          	jalr	1912(ra) # 80000ae0 <kalloc>
    80001370:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001372:	6605                	lui	a2,0x1
    80001374:	4581                	li	a1,0
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	956080e7          	jalr	-1706(ra) # 80000ccc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000137e:	4779                	li	a4,30
    80001380:	86ca                	mv	a3,s2
    80001382:	6605                	lui	a2,0x1
    80001384:	4581                	li	a1,0
    80001386:	8552                	mv	a0,s4
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	d0c080e7          	jalr	-756(ra) # 80001094 <mappages>
  memmove(mem, src, sz);
    80001390:	8626                	mv	a2,s1
    80001392:	85ce                	mv	a1,s3
    80001394:	854a                	mv	a0,s2
    80001396:	00000097          	auipc	ra,0x0
    8000139a:	992080e7          	jalr	-1646(ra) # 80000d28 <memmove>
}
    8000139e:	70a2                	ld	ra,40(sp)
    800013a0:	7402                	ld	s0,32(sp)
    800013a2:	64e2                	ld	s1,24(sp)
    800013a4:	6942                	ld	s2,16(sp)
    800013a6:	69a2                	ld	s3,8(sp)
    800013a8:	6a02                	ld	s4,0(sp)
    800013aa:	6145                	addi	sp,sp,48
    800013ac:	8082                	ret
    panic("inituvm: more than a page");
    800013ae:	00007517          	auipc	a0,0x7
    800013b2:	daa50513          	addi	a0,a0,-598 # 80008158 <digits+0x118>
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	184080e7          	jalr	388(ra) # 8000053a <panic>

00000000800013be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013be:	1101                	addi	sp,sp,-32
    800013c0:	ec06                	sd	ra,24(sp)
    800013c2:	e822                	sd	s0,16(sp)
    800013c4:	e426                	sd	s1,8(sp)
    800013c6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013ca:	00b67d63          	bgeu	a2,a1,800013e4 <uvmdealloc+0x26>
    800013ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013d0:	6785                	lui	a5,0x1
    800013d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d4:	00f60733          	add	a4,a2,a5
    800013d8:	76fd                	lui	a3,0xfffff
    800013da:	8f75                	and	a4,a4,a3
    800013dc:	97ae                	add	a5,a5,a1
    800013de:	8ff5                	and	a5,a5,a3
    800013e0:	00f76863          	bltu	a4,a5,800013f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013e4:	8526                	mv	a0,s1
    800013e6:	60e2                	ld	ra,24(sp)
    800013e8:	6442                	ld	s0,16(sp)
    800013ea:	64a2                	ld	s1,8(sp)
    800013ec:	6105                	addi	sp,sp,32
    800013ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013f0:	8f99                	sub	a5,a5,a4
    800013f2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013f4:	4685                	li	a3,1
    800013f6:	0007861b          	sext.w	a2,a5
    800013fa:	85ba                	mv	a1,a4
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	e5e080e7          	jalr	-418(ra) # 8000125a <uvmunmap>
    80001404:	b7c5                	j	800013e4 <uvmdealloc+0x26>

0000000080001406 <uvmalloc>:
  if(newsz < oldsz)
    80001406:	0ab66163          	bltu	a2,a1,800014a8 <uvmalloc+0xa2>
{
    8000140a:	7139                	addi	sp,sp,-64
    8000140c:	fc06                	sd	ra,56(sp)
    8000140e:	f822                	sd	s0,48(sp)
    80001410:	f426                	sd	s1,40(sp)
    80001412:	f04a                	sd	s2,32(sp)
    80001414:	ec4e                	sd	s3,24(sp)
    80001416:	e852                	sd	s4,16(sp)
    80001418:	e456                	sd	s5,8(sp)
    8000141a:	0080                	addi	s0,sp,64
    8000141c:	8aaa                	mv	s5,a0
    8000141e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	95be                	add	a1,a1,a5
    80001426:	77fd                	lui	a5,0xfffff
    80001428:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000142c:	08c9f063          	bgeu	s3,a2,800014ac <uvmalloc+0xa6>
    80001430:	894e                	mv	s2,s3
    mem = kalloc();
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	6ae080e7          	jalr	1710(ra) # 80000ae0 <kalloc>
    8000143a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000143c:	c51d                	beqz	a0,8000146a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000143e:	6605                	lui	a2,0x1
    80001440:	4581                	li	a1,0
    80001442:	00000097          	auipc	ra,0x0
    80001446:	88a080e7          	jalr	-1910(ra) # 80000ccc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000144a:	4779                	li	a4,30
    8000144c:	86a6                	mv	a3,s1
    8000144e:	6605                	lui	a2,0x1
    80001450:	85ca                	mv	a1,s2
    80001452:	8556                	mv	a0,s5
    80001454:	00000097          	auipc	ra,0x0
    80001458:	c40080e7          	jalr	-960(ra) # 80001094 <mappages>
    8000145c:	e905                	bnez	a0,8000148c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000145e:	6785                	lui	a5,0x1
    80001460:	993e                	add	s2,s2,a5
    80001462:	fd4968e3          	bltu	s2,s4,80001432 <uvmalloc+0x2c>
  return newsz;
    80001466:	8552                	mv	a0,s4
    80001468:	a809                	j	8000147a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000146a:	864e                	mv	a2,s3
    8000146c:	85ca                	mv	a1,s2
    8000146e:	8556                	mv	a0,s5
    80001470:	00000097          	auipc	ra,0x0
    80001474:	f4e080e7          	jalr	-178(ra) # 800013be <uvmdealloc>
      return 0;
    80001478:	4501                	li	a0,0
}
    8000147a:	70e2                	ld	ra,56(sp)
    8000147c:	7442                	ld	s0,48(sp)
    8000147e:	74a2                	ld	s1,40(sp)
    80001480:	7902                	ld	s2,32(sp)
    80001482:	69e2                	ld	s3,24(sp)
    80001484:	6a42                	ld	s4,16(sp)
    80001486:	6aa2                	ld	s5,8(sp)
    80001488:	6121                	addi	sp,sp,64
    8000148a:	8082                	ret
      kfree(mem);
    8000148c:	8526                	mv	a0,s1
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	554080e7          	jalr	1364(ra) # 800009e2 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001496:	864e                	mv	a2,s3
    80001498:	85ca                	mv	a1,s2
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	f22080e7          	jalr	-222(ra) # 800013be <uvmdealloc>
      return 0;
    800014a4:	4501                	li	a0,0
    800014a6:	bfd1                	j	8000147a <uvmalloc+0x74>
    return oldsz;
    800014a8:	852e                	mv	a0,a1
}
    800014aa:	8082                	ret
  return newsz;
    800014ac:	8532                	mv	a0,a2
    800014ae:	b7f1                	j	8000147a <uvmalloc+0x74>

00000000800014b0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014b0:	7179                	addi	sp,sp,-48
    800014b2:	f406                	sd	ra,40(sp)
    800014b4:	f022                	sd	s0,32(sp)
    800014b6:	ec26                	sd	s1,24(sp)
    800014b8:	e84a                	sd	s2,16(sp)
    800014ba:	e44e                	sd	s3,8(sp)
    800014bc:	e052                	sd	s4,0(sp)
    800014be:	1800                	addi	s0,sp,48
    800014c0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014c2:	84aa                	mv	s1,a0
    800014c4:	6905                	lui	s2,0x1
    800014c6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014c8:	4985                	li	s3,1
    800014ca:	a829                	j	800014e4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014cc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014ce:	00c79513          	slli	a0,a5,0xc
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	fde080e7          	jalr	-34(ra) # 800014b0 <freewalk>
      pagetable[i] = 0;
    800014da:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014de:	04a1                	addi	s1,s1,8
    800014e0:	03248163          	beq	s1,s2,80001502 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014e4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014e6:	00f7f713          	andi	a4,a5,15
    800014ea:	ff3701e3          	beq	a4,s3,800014cc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014ee:	8b85                	andi	a5,a5,1
    800014f0:	d7fd                	beqz	a5,800014de <freewalk+0x2e>
      panic("freewalk: leaf");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	c8650513          	addi	a0,a0,-890 # 80008178 <digits+0x138>
    800014fa:	fffff097          	auipc	ra,0xfffff
    800014fe:	040080e7          	jalr	64(ra) # 8000053a <panic>
    }
  }
  kfree((void*)pagetable);
    80001502:	8552                	mv	a0,s4
    80001504:	fffff097          	auipc	ra,0xfffff
    80001508:	4de080e7          	jalr	1246(ra) # 800009e2 <kfree>
}
    8000150c:	70a2                	ld	ra,40(sp)
    8000150e:	7402                	ld	s0,32(sp)
    80001510:	64e2                	ld	s1,24(sp)
    80001512:	6942                	ld	s2,16(sp)
    80001514:	69a2                	ld	s3,8(sp)
    80001516:	6a02                	ld	s4,0(sp)
    80001518:	6145                	addi	sp,sp,48
    8000151a:	8082                	ret

000000008000151c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000151c:	1101                	addi	sp,sp,-32
    8000151e:	ec06                	sd	ra,24(sp)
    80001520:	e822                	sd	s0,16(sp)
    80001522:	e426                	sd	s1,8(sp)
    80001524:	1000                	addi	s0,sp,32
    80001526:	84aa                	mv	s1,a0
  if(sz > 0)
    80001528:	e999                	bnez	a1,8000153e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	f84080e7          	jalr	-124(ra) # 800014b0 <freewalk>
}
    80001534:	60e2                	ld	ra,24(sp)
    80001536:	6442                	ld	s0,16(sp)
    80001538:	64a2                	ld	s1,8(sp)
    8000153a:	6105                	addi	sp,sp,32
    8000153c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000153e:	6785                	lui	a5,0x1
    80001540:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001542:	95be                	add	a1,a1,a5
    80001544:	4685                	li	a3,1
    80001546:	00c5d613          	srli	a2,a1,0xc
    8000154a:	4581                	li	a1,0
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	d0e080e7          	jalr	-754(ra) # 8000125a <uvmunmap>
    80001554:	bfd9                	j	8000152a <uvmfree+0xe>

0000000080001556 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001556:	c679                	beqz	a2,80001624 <uvmcopy+0xce>
{
    80001558:	715d                	addi	sp,sp,-80
    8000155a:	e486                	sd	ra,72(sp)
    8000155c:	e0a2                	sd	s0,64(sp)
    8000155e:	fc26                	sd	s1,56(sp)
    80001560:	f84a                	sd	s2,48(sp)
    80001562:	f44e                	sd	s3,40(sp)
    80001564:	f052                	sd	s4,32(sp)
    80001566:	ec56                	sd	s5,24(sp)
    80001568:	e85a                	sd	s6,16(sp)
    8000156a:	e45e                	sd	s7,8(sp)
    8000156c:	0880                	addi	s0,sp,80
    8000156e:	8b2a                	mv	s6,a0
    80001570:	8aae                	mv	s5,a1
    80001572:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001574:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001576:	4601                	li	a2,0
    80001578:	85ce                	mv	a1,s3
    8000157a:	855a                	mv	a0,s6
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	a30080e7          	jalr	-1488(ra) # 80000fac <walk>
    80001584:	c531                	beqz	a0,800015d0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001586:	6118                	ld	a4,0(a0)
    80001588:	00177793          	andi	a5,a4,1
    8000158c:	cbb1                	beqz	a5,800015e0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000158e:	00a75593          	srli	a1,a4,0xa
    80001592:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001596:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000159a:	fffff097          	auipc	ra,0xfffff
    8000159e:	546080e7          	jalr	1350(ra) # 80000ae0 <kalloc>
    800015a2:	892a                	mv	s2,a0
    800015a4:	c939                	beqz	a0,800015fa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015a6:	6605                	lui	a2,0x1
    800015a8:	85de                	mv	a1,s7
    800015aa:	fffff097          	auipc	ra,0xfffff
    800015ae:	77e080e7          	jalr	1918(ra) # 80000d28 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015b2:	8726                	mv	a4,s1
    800015b4:	86ca                	mv	a3,s2
    800015b6:	6605                	lui	a2,0x1
    800015b8:	85ce                	mv	a1,s3
    800015ba:	8556                	mv	a0,s5
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	ad8080e7          	jalr	-1320(ra) # 80001094 <mappages>
    800015c4:	e515                	bnez	a0,800015f0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015c6:	6785                	lui	a5,0x1
    800015c8:	99be                	add	s3,s3,a5
    800015ca:	fb49e6e3          	bltu	s3,s4,80001576 <uvmcopy+0x20>
    800015ce:	a081                	j	8000160e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015d0:	00007517          	auipc	a0,0x7
    800015d4:	bb850513          	addi	a0,a0,-1096 # 80008188 <digits+0x148>
    800015d8:	fffff097          	auipc	ra,0xfffff
    800015dc:	f62080e7          	jalr	-158(ra) # 8000053a <panic>
      panic("uvmcopy: page not present");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bc850513          	addi	a0,a0,-1080 # 800081a8 <digits+0x168>
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	f52080e7          	jalr	-174(ra) # 8000053a <panic>
      kfree(mem);
    800015f0:	854a                	mv	a0,s2
    800015f2:	fffff097          	auipc	ra,0xfffff
    800015f6:	3f0080e7          	jalr	1008(ra) # 800009e2 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015fa:	4685                	li	a3,1
    800015fc:	00c9d613          	srli	a2,s3,0xc
    80001600:	4581                	li	a1,0
    80001602:	8556                	mv	a0,s5
    80001604:	00000097          	auipc	ra,0x0
    80001608:	c56080e7          	jalr	-938(ra) # 8000125a <uvmunmap>
  return -1;
    8000160c:	557d                	li	a0,-1
}
    8000160e:	60a6                	ld	ra,72(sp)
    80001610:	6406                	ld	s0,64(sp)
    80001612:	74e2                	ld	s1,56(sp)
    80001614:	7942                	ld	s2,48(sp)
    80001616:	79a2                	ld	s3,40(sp)
    80001618:	7a02                	ld	s4,32(sp)
    8000161a:	6ae2                	ld	s5,24(sp)
    8000161c:	6b42                	ld	s6,16(sp)
    8000161e:	6ba2                	ld	s7,8(sp)
    80001620:	6161                	addi	sp,sp,80
    80001622:	8082                	ret
  return 0;
    80001624:	4501                	li	a0,0
}
    80001626:	8082                	ret

0000000080001628 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001628:	1141                	addi	sp,sp,-16
    8000162a:	e406                	sd	ra,8(sp)
    8000162c:	e022                	sd	s0,0(sp)
    8000162e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001630:	4601                	li	a2,0
    80001632:	00000097          	auipc	ra,0x0
    80001636:	97a080e7          	jalr	-1670(ra) # 80000fac <walk>
  if(pte == 0)
    8000163a:	c901                	beqz	a0,8000164a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000163c:	611c                	ld	a5,0(a0)
    8000163e:	9bbd                	andi	a5,a5,-17
    80001640:	e11c                	sd	a5,0(a0)
}
    80001642:	60a2                	ld	ra,8(sp)
    80001644:	6402                	ld	s0,0(sp)
    80001646:	0141                	addi	sp,sp,16
    80001648:	8082                	ret
    panic("uvmclear");
    8000164a:	00007517          	auipc	a0,0x7
    8000164e:	b7e50513          	addi	a0,a0,-1154 # 800081c8 <digits+0x188>
    80001652:	fffff097          	auipc	ra,0xfffff
    80001656:	ee8080e7          	jalr	-280(ra) # 8000053a <panic>

000000008000165a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000165a:	c6bd                	beqz	a3,800016c8 <copyout+0x6e>
{
    8000165c:	715d                	addi	sp,sp,-80
    8000165e:	e486                	sd	ra,72(sp)
    80001660:	e0a2                	sd	s0,64(sp)
    80001662:	fc26                	sd	s1,56(sp)
    80001664:	f84a                	sd	s2,48(sp)
    80001666:	f44e                	sd	s3,40(sp)
    80001668:	f052                	sd	s4,32(sp)
    8000166a:	ec56                	sd	s5,24(sp)
    8000166c:	e85a                	sd	s6,16(sp)
    8000166e:	e45e                	sd	s7,8(sp)
    80001670:	e062                	sd	s8,0(sp)
    80001672:	0880                	addi	s0,sp,80
    80001674:	8b2a                	mv	s6,a0
    80001676:	8c2e                	mv	s8,a1
    80001678:	8a32                	mv	s4,a2
    8000167a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000167c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000167e:	6a85                	lui	s5,0x1
    80001680:	a015                	j	800016a4 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001682:	9562                	add	a0,a0,s8
    80001684:	0004861b          	sext.w	a2,s1
    80001688:	85d2                	mv	a1,s4
    8000168a:	41250533          	sub	a0,a0,s2
    8000168e:	fffff097          	auipc	ra,0xfffff
    80001692:	69a080e7          	jalr	1690(ra) # 80000d28 <memmove>

    len -= n;
    80001696:	409989b3          	sub	s3,s3,s1
    src += n;
    8000169a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000169c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016a0:	02098263          	beqz	s3,800016c4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016a4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016a8:	85ca                	mv	a1,s2
    800016aa:	855a                	mv	a0,s6
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	9a6080e7          	jalr	-1626(ra) # 80001052 <walkaddr>
    if(pa0 == 0)
    800016b4:	cd01                	beqz	a0,800016cc <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016b6:	418904b3          	sub	s1,s2,s8
    800016ba:	94d6                	add	s1,s1,s5
    800016bc:	fc99f3e3          	bgeu	s3,s1,80001682 <copyout+0x28>
    800016c0:	84ce                	mv	s1,s3
    800016c2:	b7c1                	j	80001682 <copyout+0x28>
  }
  return 0;
    800016c4:	4501                	li	a0,0
    800016c6:	a021                	j	800016ce <copyout+0x74>
    800016c8:	4501                	li	a0,0
}
    800016ca:	8082                	ret
      return -1;
    800016cc:	557d                	li	a0,-1
}
    800016ce:	60a6                	ld	ra,72(sp)
    800016d0:	6406                	ld	s0,64(sp)
    800016d2:	74e2                	ld	s1,56(sp)
    800016d4:	7942                	ld	s2,48(sp)
    800016d6:	79a2                	ld	s3,40(sp)
    800016d8:	7a02                	ld	s4,32(sp)
    800016da:	6ae2                	ld	s5,24(sp)
    800016dc:	6b42                	ld	s6,16(sp)
    800016de:	6ba2                	ld	s7,8(sp)
    800016e0:	6c02                	ld	s8,0(sp)
    800016e2:	6161                	addi	sp,sp,80
    800016e4:	8082                	ret

00000000800016e6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e6:	caa5                	beqz	a3,80001756 <copyin+0x70>
{
    800016e8:	715d                	addi	sp,sp,-80
    800016ea:	e486                	sd	ra,72(sp)
    800016ec:	e0a2                	sd	s0,64(sp)
    800016ee:	fc26                	sd	s1,56(sp)
    800016f0:	f84a                	sd	s2,48(sp)
    800016f2:	f44e                	sd	s3,40(sp)
    800016f4:	f052                	sd	s4,32(sp)
    800016f6:	ec56                	sd	s5,24(sp)
    800016f8:	e85a                	sd	s6,16(sp)
    800016fa:	e45e                	sd	s7,8(sp)
    800016fc:	e062                	sd	s8,0(sp)
    800016fe:	0880                	addi	s0,sp,80
    80001700:	8b2a                	mv	s6,a0
    80001702:	8a2e                	mv	s4,a1
    80001704:	8c32                	mv	s8,a2
    80001706:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001708:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000170a:	6a85                	lui	s5,0x1
    8000170c:	a01d                	j	80001732 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000170e:	018505b3          	add	a1,a0,s8
    80001712:	0004861b          	sext.w	a2,s1
    80001716:	412585b3          	sub	a1,a1,s2
    8000171a:	8552                	mv	a0,s4
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	60c080e7          	jalr	1548(ra) # 80000d28 <memmove>

    len -= n;
    80001724:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001728:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000172a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000172e:	02098263          	beqz	s3,80001752 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001732:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001736:	85ca                	mv	a1,s2
    80001738:	855a                	mv	a0,s6
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	918080e7          	jalr	-1768(ra) # 80001052 <walkaddr>
    if(pa0 == 0)
    80001742:	cd01                	beqz	a0,8000175a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001744:	418904b3          	sub	s1,s2,s8
    80001748:	94d6                	add	s1,s1,s5
    8000174a:	fc99f2e3          	bgeu	s3,s1,8000170e <copyin+0x28>
    8000174e:	84ce                	mv	s1,s3
    80001750:	bf7d                	j	8000170e <copyin+0x28>
  }
  return 0;
    80001752:	4501                	li	a0,0
    80001754:	a021                	j	8000175c <copyin+0x76>
    80001756:	4501                	li	a0,0
}
    80001758:	8082                	ret
      return -1;
    8000175a:	557d                	li	a0,-1
}
    8000175c:	60a6                	ld	ra,72(sp)
    8000175e:	6406                	ld	s0,64(sp)
    80001760:	74e2                	ld	s1,56(sp)
    80001762:	7942                	ld	s2,48(sp)
    80001764:	79a2                	ld	s3,40(sp)
    80001766:	7a02                	ld	s4,32(sp)
    80001768:	6ae2                	ld	s5,24(sp)
    8000176a:	6b42                	ld	s6,16(sp)
    8000176c:	6ba2                	ld	s7,8(sp)
    8000176e:	6c02                	ld	s8,0(sp)
    80001770:	6161                	addi	sp,sp,80
    80001772:	8082                	ret

0000000080001774 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001774:	c2dd                	beqz	a3,8000181a <copyinstr+0xa6>
{
    80001776:	715d                	addi	sp,sp,-80
    80001778:	e486                	sd	ra,72(sp)
    8000177a:	e0a2                	sd	s0,64(sp)
    8000177c:	fc26                	sd	s1,56(sp)
    8000177e:	f84a                	sd	s2,48(sp)
    80001780:	f44e                	sd	s3,40(sp)
    80001782:	f052                	sd	s4,32(sp)
    80001784:	ec56                	sd	s5,24(sp)
    80001786:	e85a                	sd	s6,16(sp)
    80001788:	e45e                	sd	s7,8(sp)
    8000178a:	0880                	addi	s0,sp,80
    8000178c:	8a2a                	mv	s4,a0
    8000178e:	8b2e                	mv	s6,a1
    80001790:	8bb2                	mv	s7,a2
    80001792:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001794:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001796:	6985                	lui	s3,0x1
    80001798:	a02d                	j	800017c2 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000179a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000179e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017a0:	37fd                	addiw	a5,a5,-1
    800017a2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017a6:	60a6                	ld	ra,72(sp)
    800017a8:	6406                	ld	s0,64(sp)
    800017aa:	74e2                	ld	s1,56(sp)
    800017ac:	7942                	ld	s2,48(sp)
    800017ae:	79a2                	ld	s3,40(sp)
    800017b0:	7a02                	ld	s4,32(sp)
    800017b2:	6ae2                	ld	s5,24(sp)
    800017b4:	6b42                	ld	s6,16(sp)
    800017b6:	6ba2                	ld	s7,8(sp)
    800017b8:	6161                	addi	sp,sp,80
    800017ba:	8082                	ret
    srcva = va0 + PGSIZE;
    800017bc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017c0:	c8a9                	beqz	s1,80001812 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017c2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017c6:	85ca                	mv	a1,s2
    800017c8:	8552                	mv	a0,s4
    800017ca:	00000097          	auipc	ra,0x0
    800017ce:	888080e7          	jalr	-1912(ra) # 80001052 <walkaddr>
    if(pa0 == 0)
    800017d2:	c131                	beqz	a0,80001816 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017d4:	417906b3          	sub	a3,s2,s7
    800017d8:	96ce                	add	a3,a3,s3
    800017da:	00d4f363          	bgeu	s1,a3,800017e0 <copyinstr+0x6c>
    800017de:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017e0:	955e                	add	a0,a0,s7
    800017e2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017e6:	daf9                	beqz	a3,800017bc <copyinstr+0x48>
    800017e8:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017ea:	41650633          	sub	a2,a0,s6
    800017ee:	fff48593          	addi	a1,s1,-1
    800017f2:	95da                	add	a1,a1,s6
    while(n > 0){
    800017f4:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    800017f6:	00f60733          	add	a4,a2,a5
    800017fa:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800017fe:	df51                	beqz	a4,8000179a <copyinstr+0x26>
        *dst = *p;
    80001800:	00e78023          	sb	a4,0(a5)
      --max;
    80001804:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001808:	0785                	addi	a5,a5,1
    while(n > 0){
    8000180a:	fed796e3          	bne	a5,a3,800017f6 <copyinstr+0x82>
      dst++;
    8000180e:	8b3e                	mv	s6,a5
    80001810:	b775                	j	800017bc <copyinstr+0x48>
    80001812:	4781                	li	a5,0
    80001814:	b771                	j	800017a0 <copyinstr+0x2c>
      return -1;
    80001816:	557d                	li	a0,-1
    80001818:	b779                	j	800017a6 <copyinstr+0x32>
  int got_null = 0;
    8000181a:	4781                	li	a5,0
  if(got_null){
    8000181c:	37fd                	addiw	a5,a5,-1
    8000181e:	0007851b          	sext.w	a0,a5
}
    80001822:	8082                	ret

0000000080001824 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80001824:	7139                	addi	sp,sp,-64
    80001826:	fc06                	sd	ra,56(sp)
    80001828:	f822                	sd	s0,48(sp)
    8000182a:	f426                	sd	s1,40(sp)
    8000182c:	f04a                	sd	s2,32(sp)
    8000182e:	ec4e                	sd	s3,24(sp)
    80001830:	e852                	sd	s4,16(sp)
    80001832:	e456                	sd	s5,8(sp)
    80001834:	e05a                	sd	s6,0(sp)
    80001836:	0080                	addi	s0,sp,64
    80001838:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183a:	00010497          	auipc	s1,0x10
    8000183e:	e9648493          	addi	s1,s1,-362 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001842:	8b26                	mv	s6,s1
    80001844:	00006a97          	auipc	s5,0x6
    80001848:	7bca8a93          	addi	s5,s5,1980 # 80008000 <etext>
    8000184c:	04000937          	lui	s2,0x4000
    80001850:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001852:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001854:	00016a17          	auipc	s4,0x16
    80001858:	e7ca0a13          	addi	s4,s4,-388 # 800176d0 <tickslock>
    char *pa = kalloc();
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	284080e7          	jalr	644(ra) # 80000ae0 <kalloc>
    80001864:	862a                	mv	a2,a0
    if(pa == 0)
    80001866:	c131                	beqz	a0,800018aa <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001868:	416485b3          	sub	a1,s1,s6
    8000186c:	859d                	srai	a1,a1,0x7
    8000186e:	000ab783          	ld	a5,0(s5)
    80001872:	02f585b3          	mul	a1,a1,a5
    80001876:	2585                	addiw	a1,a1,1
    80001878:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000187c:	4719                	li	a4,6
    8000187e:	6685                	lui	a3,0x1
    80001880:	40b905b3          	sub	a1,s2,a1
    80001884:	854e                	mv	a0,s3
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	8ae080e7          	jalr	-1874(ra) # 80001134 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188e:	18048493          	addi	s1,s1,384
    80001892:	fd4495e3          	bne	s1,s4,8000185c <proc_mapstacks+0x38>
  }
}
    80001896:	70e2                	ld	ra,56(sp)
    80001898:	7442                	ld	s0,48(sp)
    8000189a:	74a2                	ld	s1,40(sp)
    8000189c:	7902                	ld	s2,32(sp)
    8000189e:	69e2                	ld	s3,24(sp)
    800018a0:	6a42                	ld	s4,16(sp)
    800018a2:	6aa2                	ld	s5,8(sp)
    800018a4:	6b02                	ld	s6,0(sp)
    800018a6:	6121                	addi	sp,sp,64
    800018a8:	8082                	ret
      panic("kalloc");
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	92e50513          	addi	a0,a0,-1746 # 800081d8 <digits+0x198>
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	c88080e7          	jalr	-888(ra) # 8000053a <panic>

00000000800018ba <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018ba:	7139                	addi	sp,sp,-64
    800018bc:	fc06                	sd	ra,56(sp)
    800018be:	f822                	sd	s0,48(sp)
    800018c0:	f426                	sd	s1,40(sp)
    800018c2:	f04a                	sd	s2,32(sp)
    800018c4:	ec4e                	sd	s3,24(sp)
    800018c6:	e852                	sd	s4,16(sp)
    800018c8:	e456                	sd	s5,8(sp)
    800018ca:	e05a                	sd	s6,0(sp)
    800018cc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018ce:	00007597          	auipc	a1,0x7
    800018d2:	91258593          	addi	a1,a1,-1774 # 800081e0 <digits+0x1a0>
    800018d6:	00010517          	auipc	a0,0x10
    800018da:	9ca50513          	addi	a0,a0,-1590 # 800112a0 <pid_lock>
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	262080e7          	jalr	610(ra) # 80000b40 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018e6:	00007597          	auipc	a1,0x7
    800018ea:	90258593          	addi	a1,a1,-1790 # 800081e8 <digits+0x1a8>
    800018ee:	00010517          	auipc	a0,0x10
    800018f2:	9ca50513          	addi	a0,a0,-1590 # 800112b8 <wait_lock>
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	24a080e7          	jalr	586(ra) # 80000b40 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fe:	00010497          	auipc	s1,0x10
    80001902:	dd248493          	addi	s1,s1,-558 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    80001906:	00007b17          	auipc	s6,0x7
    8000190a:	8f2b0b13          	addi	s6,s6,-1806 # 800081f8 <digits+0x1b8>
      p->kstack = KSTACK((int) (p - proc));
    8000190e:	8aa6                	mv	s5,s1
    80001910:	00006a17          	auipc	s4,0x6
    80001914:	6f0a0a13          	addi	s4,s4,1776 # 80008000 <etext>
    80001918:	04000937          	lui	s2,0x4000
    8000191c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000191e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001920:	00016997          	auipc	s3,0x16
    80001924:	db098993          	addi	s3,s3,-592 # 800176d0 <tickslock>
      initlock(&p->lock, "proc");
    80001928:	85da                	mv	a1,s6
    8000192a:	8526                	mv	a0,s1
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	214080e7          	jalr	532(ra) # 80000b40 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001934:	415487b3          	sub	a5,s1,s5
    80001938:	879d                	srai	a5,a5,0x7
    8000193a:	000a3703          	ld	a4,0(s4)
    8000193e:	02e787b3          	mul	a5,a5,a4
    80001942:	2785                	addiw	a5,a5,1
    80001944:	00d7979b          	slliw	a5,a5,0xd
    80001948:	40f907b3          	sub	a5,s2,a5
    8000194c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194e:	18048493          	addi	s1,s1,384
    80001952:	fd349be3          	bne	s1,s3,80001928 <procinit+0x6e>
  }
}
    80001956:	70e2                	ld	ra,56(sp)
    80001958:	7442                	ld	s0,48(sp)
    8000195a:	74a2                	ld	s1,40(sp)
    8000195c:	7902                	ld	s2,32(sp)
    8000195e:	69e2                	ld	s3,24(sp)
    80001960:	6a42                	ld	s4,16(sp)
    80001962:	6aa2                	ld	s5,8(sp)
    80001964:	6b02                	ld	s6,0(sp)
    80001966:	6121                	addi	sp,sp,64
    80001968:	8082                	ret

000000008000196a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000196a:	1141                	addi	sp,sp,-16
    8000196c:	e422                	sd	s0,8(sp)
    8000196e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001970:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001972:	2501                	sext.w	a0,a0
    80001974:	6422                	ld	s0,8(sp)
    80001976:	0141                	addi	sp,sp,16
    80001978:	8082                	ret

000000008000197a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000197a:	1141                	addi	sp,sp,-16
    8000197c:	e422                	sd	s0,8(sp)
    8000197e:	0800                	addi	s0,sp,16
    80001980:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001982:	2781                	sext.w	a5,a5
    80001984:	079e                	slli	a5,a5,0x7
  return c;
}
    80001986:	00010517          	auipc	a0,0x10
    8000198a:	94a50513          	addi	a0,a0,-1718 # 800112d0 <cpus>
    8000198e:	953e                	add	a0,a0,a5
    80001990:	6422                	ld	s0,8(sp)
    80001992:	0141                	addi	sp,sp,16
    80001994:	8082                	ret

0000000080001996 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	1000                	addi	s0,sp,32
  push_off();
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	1e4080e7          	jalr	484(ra) # 80000b84 <push_off>
    800019a8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019aa:	2781                	sext.w	a5,a5
    800019ac:	079e                	slli	a5,a5,0x7
    800019ae:	00010717          	auipc	a4,0x10
    800019b2:	8f270713          	addi	a4,a4,-1806 # 800112a0 <pid_lock>
    800019b6:	97ba                	add	a5,a5,a4
    800019b8:	7b84                	ld	s1,48(a5)
  pop_off();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	26a080e7          	jalr	618(ra) # 80000c24 <pop_off>
  return p;
}
    800019c2:	8526                	mv	a0,s1
    800019c4:	60e2                	ld	ra,24(sp)
    800019c6:	6442                	ld	s0,16(sp)
    800019c8:	64a2                	ld	s1,8(sp)
    800019ca:	6105                	addi	sp,sp,32
    800019cc:	8082                	ret

00000000800019ce <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019ce:	1141                	addi	sp,sp,-16
    800019d0:	e406                	sd	ra,8(sp)
    800019d2:	e022                	sd	s0,0(sp)
    800019d4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019d6:	00000097          	auipc	ra,0x0
    800019da:	fc0080e7          	jalr	-64(ra) # 80001996 <myproc>
    800019de:	fffff097          	auipc	ra,0xfffff
    800019e2:	2a6080e7          	jalr	678(ra) # 80000c84 <release>

  if (first) {
    800019e6:	00007797          	auipc	a5,0x7
    800019ea:	f2a7a783          	lw	a5,-214(a5) # 80008910 <first.1>
    800019ee:	eb89                	bnez	a5,80001a00 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800019f0:	00001097          	auipc	ra,0x1
    800019f4:	108080e7          	jalr	264(ra) # 80002af8 <usertrapret>
}
    800019f8:	60a2                	ld	ra,8(sp)
    800019fa:	6402                	ld	s0,0(sp)
    800019fc:	0141                	addi	sp,sp,16
    800019fe:	8082                	ret
    first = 0;
    80001a00:	00007797          	auipc	a5,0x7
    80001a04:	f007a823          	sw	zero,-240(a5) # 80008910 <first.1>
    fsinit(ROOTDEV);
    80001a08:	4505                	li	a0,1
    80001a0a:	00002097          	auipc	ra,0x2
    80001a0e:	f6c080e7          	jalr	-148(ra) # 80003976 <fsinit>
    80001a12:	bff9                	j	800019f0 <forkret+0x22>

0000000080001a14 <allocpid>:
allocpid() {
    80001a14:	1101                	addi	sp,sp,-32
    80001a16:	ec06                	sd	ra,24(sp)
    80001a18:	e822                	sd	s0,16(sp)
    80001a1a:	e426                	sd	s1,8(sp)
    80001a1c:	e04a                	sd	s2,0(sp)
    80001a1e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a20:	00010917          	auipc	s2,0x10
    80001a24:	88090913          	addi	s2,s2,-1920 # 800112a0 <pid_lock>
    80001a28:	854a                	mv	a0,s2
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	1a6080e7          	jalr	422(ra) # 80000bd0 <acquire>
  pid = nextpid;
    80001a32:	00007797          	auipc	a5,0x7
    80001a36:	ee278793          	addi	a5,a5,-286 # 80008914 <nextpid>
    80001a3a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a3c:	0014871b          	addiw	a4,s1,1
    80001a40:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a42:	854a                	mv	a0,s2
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	240080e7          	jalr	576(ra) # 80000c84 <release>
}
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	60e2                	ld	ra,24(sp)
    80001a50:	6442                	ld	s0,16(sp)
    80001a52:	64a2                	ld	s1,8(sp)
    80001a54:	6902                	ld	s2,0(sp)
    80001a56:	6105                	addi	sp,sp,32
    80001a58:	8082                	ret

0000000080001a5a <proc_pagetable>:
{
    80001a5a:	1101                	addi	sp,sp,-32
    80001a5c:	ec06                	sd	ra,24(sp)
    80001a5e:	e822                	sd	s0,16(sp)
    80001a60:	e426                	sd	s1,8(sp)
    80001a62:	e04a                	sd	s2,0(sp)
    80001a64:	1000                	addi	s0,sp,32
    80001a66:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a68:	00000097          	auipc	ra,0x0
    80001a6c:	8b6080e7          	jalr	-1866(ra) # 8000131e <uvmcreate>
    80001a70:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a72:	c121                	beqz	a0,80001ab2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a74:	4729                	li	a4,10
    80001a76:	00005697          	auipc	a3,0x5
    80001a7a:	58a68693          	addi	a3,a3,1418 # 80007000 <_trampoline>
    80001a7e:	6605                	lui	a2,0x1
    80001a80:	040005b7          	lui	a1,0x4000
    80001a84:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a86:	05b2                	slli	a1,a1,0xc
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	60c080e7          	jalr	1548(ra) # 80001094 <mappages>
    80001a90:	02054863          	bltz	a0,80001ac0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a94:	4719                	li	a4,6
    80001a96:	05893683          	ld	a3,88(s2)
    80001a9a:	6605                	lui	a2,0x1
    80001a9c:	020005b7          	lui	a1,0x2000
    80001aa0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aa2:	05b6                	slli	a1,a1,0xd
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	fffff097          	auipc	ra,0xfffff
    80001aaa:	5ee080e7          	jalr	1518(ra) # 80001094 <mappages>
    80001aae:	02054163          	bltz	a0,80001ad0 <proc_pagetable+0x76>
}
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	60e2                	ld	ra,24(sp)
    80001ab6:	6442                	ld	s0,16(sp)
    80001ab8:	64a2                	ld	s1,8(sp)
    80001aba:	6902                	ld	s2,0(sp)
    80001abc:	6105                	addi	sp,sp,32
    80001abe:	8082                	ret
    uvmfree(pagetable, 0);
    80001ac0:	4581                	li	a1,0
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	00000097          	auipc	ra,0x0
    80001ac8:	a58080e7          	jalr	-1448(ra) # 8000151c <uvmfree>
    return 0;
    80001acc:	4481                	li	s1,0
    80001ace:	b7d5                	j	80001ab2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ad0:	4681                	li	a3,0
    80001ad2:	4605                	li	a2,1
    80001ad4:	040005b7          	lui	a1,0x4000
    80001ad8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ada:	05b2                	slli	a1,a1,0xc
    80001adc:	8526                	mv	a0,s1
    80001ade:	fffff097          	auipc	ra,0xfffff
    80001ae2:	77c080e7          	jalr	1916(ra) # 8000125a <uvmunmap>
    uvmfree(pagetable, 0);
    80001ae6:	4581                	li	a1,0
    80001ae8:	8526                	mv	a0,s1
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	a32080e7          	jalr	-1486(ra) # 8000151c <uvmfree>
    return 0;
    80001af2:	4481                	li	s1,0
    80001af4:	bf7d                	j	80001ab2 <proc_pagetable+0x58>

0000000080001af6 <proc_freepagetable>:
{
    80001af6:	1101                	addi	sp,sp,-32
    80001af8:	ec06                	sd	ra,24(sp)
    80001afa:	e822                	sd	s0,16(sp)
    80001afc:	e426                	sd	s1,8(sp)
    80001afe:	e04a                	sd	s2,0(sp)
    80001b00:	1000                	addi	s0,sp,32
    80001b02:	84aa                	mv	s1,a0
    80001b04:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b06:	4681                	li	a3,0
    80001b08:	4605                	li	a2,1
    80001b0a:	040005b7          	lui	a1,0x4000
    80001b0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b10:	05b2                	slli	a1,a1,0xc
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	748080e7          	jalr	1864(ra) # 8000125a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b1a:	4681                	li	a3,0
    80001b1c:	4605                	li	a2,1
    80001b1e:	020005b7          	lui	a1,0x2000
    80001b22:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b24:	05b6                	slli	a1,a1,0xd
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	732080e7          	jalr	1842(ra) # 8000125a <uvmunmap>
  uvmfree(pagetable, sz);
    80001b30:	85ca                	mv	a1,s2
    80001b32:	8526                	mv	a0,s1
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	9e8080e7          	jalr	-1560(ra) # 8000151c <uvmfree>
}
    80001b3c:	60e2                	ld	ra,24(sp)
    80001b3e:	6442                	ld	s0,16(sp)
    80001b40:	64a2                	ld	s1,8(sp)
    80001b42:	6902                	ld	s2,0(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret

0000000080001b48 <freeproc>:
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
    80001b52:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b54:	6d28                	ld	a0,88(a0)
    80001b56:	c509                	beqz	a0,80001b60 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	e8a080e7          	jalr	-374(ra) # 800009e2 <kfree>
  p->trapframe = 0;
    80001b60:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b64:	68a8                	ld	a0,80(s1)
    80001b66:	c511                	beqz	a0,80001b72 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b68:	64ac                	ld	a1,72(s1)
    80001b6a:	00000097          	auipc	ra,0x0
    80001b6e:	f8c080e7          	jalr	-116(ra) # 80001af6 <proc_freepagetable>
  p->pagetable = 0;
    80001b72:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b76:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b7a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b7e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b82:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b86:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b8a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b8e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b92:	0004ac23          	sw	zero,24(s1)
  p->ctime=0;
    80001b96:	1604b423          	sd	zero,360(s1)
  p->stime=0;
    80001b9a:	1604b823          	sd	zero,368(s1)
  p->etime=0;
    80001b9e:	1604bc23          	sd	zero,376(s1)
}
    80001ba2:	60e2                	ld	ra,24(sp)
    80001ba4:	6442                	ld	s0,16(sp)
    80001ba6:	64a2                	ld	s1,8(sp)
    80001ba8:	6105                	addi	sp,sp,32
    80001baa:	8082                	ret

0000000080001bac <allocproc>:
{
    80001bac:	1101                	addi	sp,sp,-32
    80001bae:	ec06                	sd	ra,24(sp)
    80001bb0:	e822                	sd	s0,16(sp)
    80001bb2:	e426                	sd	s1,8(sp)
    80001bb4:	e04a                	sd	s2,0(sp)
    80001bb6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bb8:	00010497          	auipc	s1,0x10
    80001bbc:	b1848493          	addi	s1,s1,-1256 # 800116d0 <proc>
    80001bc0:	00016917          	auipc	s2,0x16
    80001bc4:	b1090913          	addi	s2,s2,-1264 # 800176d0 <tickslock>
    acquire(&p->lock);
    80001bc8:	8526                	mv	a0,s1
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	006080e7          	jalr	6(ra) # 80000bd0 <acquire>
    if(p->state == UNUSED) {
    80001bd2:	4c9c                	lw	a5,24(s1)
    80001bd4:	cf81                	beqz	a5,80001bec <allocproc+0x40>
      release(&p->lock);
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	fffff097          	auipc	ra,0xfffff
    80001bdc:	0ac080e7          	jalr	172(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be0:	18048493          	addi	s1,s1,384
    80001be4:	ff2492e3          	bne	s1,s2,80001bc8 <allocproc+0x1c>
  return 0;
    80001be8:	4481                	li	s1,0
    80001bea:	a051                	j	80001c6e <allocproc+0xc2>
  p->pid = allocpid();
    80001bec:	00000097          	auipc	ra,0x0
    80001bf0:	e28080e7          	jalr	-472(ra) # 80001a14 <allocpid>
    80001bf4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bf6:	4785                	li	a5,1
    80001bf8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	ee6080e7          	jalr	-282(ra) # 80000ae0 <kalloc>
    80001c02:	892a                	mv	s2,a0
    80001c04:	eca8                	sd	a0,88(s1)
    80001c06:	c93d                	beqz	a0,80001c7c <allocproc+0xd0>
  p->pagetable = proc_pagetable(p);
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00000097          	auipc	ra,0x0
    80001c0e:	e50080e7          	jalr	-432(ra) # 80001a5a <proc_pagetable>
    80001c12:	892a                	mv	s2,a0
    80001c14:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c16:	cd3d                	beqz	a0,80001c94 <allocproc+0xe8>
  memset(&p->context, 0, sizeof(p->context));
    80001c18:	07000613          	li	a2,112
    80001c1c:	4581                	li	a1,0
    80001c1e:	06048513          	addi	a0,s1,96
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	0aa080e7          	jalr	170(ra) # 80000ccc <memset>
  p->context.ra = (uint64)forkret;
    80001c2a:	00000797          	auipc	a5,0x0
    80001c2e:	da478793          	addi	a5,a5,-604 # 800019ce <forkret>
    80001c32:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c34:	60bc                	ld	a5,64(s1)
    80001c36:	6705                	lui	a4,0x1
    80001c38:	97ba                	add	a5,a5,a4
    80001c3a:	f4bc                	sd	a5,104(s1)
  acquire(&tickslock);
    80001c3c:	00016517          	auipc	a0,0x16
    80001c40:	a9450513          	addi	a0,a0,-1388 # 800176d0 <tickslock>
    80001c44:	fffff097          	auipc	ra,0xfffff
    80001c48:	f8c080e7          	jalr	-116(ra) # 80000bd0 <acquire>
  xticks=ticks;
    80001c4c:	00007917          	auipc	s2,0x7
    80001c50:	3e492903          	lw	s2,996(s2) # 80009030 <ticks>
  release(&tickslock);
    80001c54:	00016517          	auipc	a0,0x16
    80001c58:	a7c50513          	addi	a0,a0,-1412 # 800176d0 <tickslock>
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	028080e7          	jalr	40(ra) # 80000c84 <release>
  p->ctime=xticks;
    80001c64:	1902                	slli	s2,s2,0x20
    80001c66:	02095913          	srli	s2,s2,0x20
    80001c6a:	1724b423          	sd	s2,360(s1)
}
    80001c6e:	8526                	mv	a0,s1
    80001c70:	60e2                	ld	ra,24(sp)
    80001c72:	6442                	ld	s0,16(sp)
    80001c74:	64a2                	ld	s1,8(sp)
    80001c76:	6902                	ld	s2,0(sp)
    80001c78:	6105                	addi	sp,sp,32
    80001c7a:	8082                	ret
    freeproc(p);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	eca080e7          	jalr	-310(ra) # 80001b48 <freeproc>
    release(&p->lock);
    80001c86:	8526                	mv	a0,s1
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	ffc080e7          	jalr	-4(ra) # 80000c84 <release>
    return 0;
    80001c90:	84ca                	mv	s1,s2
    80001c92:	bff1                	j	80001c6e <allocproc+0xc2>
    freeproc(p);
    80001c94:	8526                	mv	a0,s1
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	eb2080e7          	jalr	-334(ra) # 80001b48 <freeproc>
    release(&p->lock);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	fe4080e7          	jalr	-28(ra) # 80000c84 <release>
    return 0;
    80001ca8:	84ca                	mv	s1,s2
    80001caa:	b7d1                	j	80001c6e <allocproc+0xc2>

0000000080001cac <userinit>:
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	ef6080e7          	jalr	-266(ra) # 80001bac <allocproc>
    80001cbe:	84aa                	mv	s1,a0
  initproc = p;
    80001cc0:	00007797          	auipc	a5,0x7
    80001cc4:	36a7b423          	sd	a0,872(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cc8:	03400613          	li	a2,52
    80001ccc:	00007597          	auipc	a1,0x7
    80001cd0:	c5458593          	addi	a1,a1,-940 # 80008920 <initcode>
    80001cd4:	6928                	ld	a0,80(a0)
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	676080e7          	jalr	1654(ra) # 8000134c <uvminit>
  p->sz = PGSIZE;
    80001cde:	6785                	lui	a5,0x1
    80001ce0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ce2:	6cb8                	ld	a4,88(s1)
    80001ce4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ce8:	6cb8                	ld	a4,88(s1)
    80001cea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cec:	4641                	li	a2,16
    80001cee:	00006597          	auipc	a1,0x6
    80001cf2:	51258593          	addi	a1,a1,1298 # 80008200 <digits+0x1c0>
    80001cf6:	15848513          	addi	a0,s1,344
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	11c080e7          	jalr	284(ra) # 80000e16 <safestrcpy>
  p->cwd = namei("/");
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	50e50513          	addi	a0,a0,1294 # 80008210 <digits+0x1d0>
    80001d0a:	00002097          	auipc	ra,0x2
    80001d0e:	6a2080e7          	jalr	1698(ra) # 800043ac <namei>
    80001d12:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d16:	478d                	li	a5,3
    80001d18:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	f68080e7          	jalr	-152(ra) # 80000c84 <release>
}
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6105                	addi	sp,sp,32
    80001d2c:	8082                	ret

0000000080001d2e <growproc>:
{
    80001d2e:	1101                	addi	sp,sp,-32
    80001d30:	ec06                	sd	ra,24(sp)
    80001d32:	e822                	sd	s0,16(sp)
    80001d34:	e426                	sd	s1,8(sp)
    80001d36:	e04a                	sd	s2,0(sp)
    80001d38:	1000                	addi	s0,sp,32
    80001d3a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	c5a080e7          	jalr	-934(ra) # 80001996 <myproc>
    80001d44:	892a                	mv	s2,a0
  sz = p->sz;
    80001d46:	652c                	ld	a1,72(a0)
    80001d48:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d4c:	00904f63          	bgtz	s1,80001d6a <growproc+0x3c>
  } else if(n < 0){
    80001d50:	0204cd63          	bltz	s1,80001d8a <growproc+0x5c>
  p->sz = sz;
    80001d54:	1782                	slli	a5,a5,0x20
    80001d56:	9381                	srli	a5,a5,0x20
    80001d58:	04f93423          	sd	a5,72(s2)
  return 0;
    80001d5c:	4501                	li	a0,0
}
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	64a2                	ld	s1,8(sp)
    80001d64:	6902                	ld	s2,0(sp)
    80001d66:	6105                	addi	sp,sp,32
    80001d68:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d6a:	00f4863b          	addw	a2,s1,a5
    80001d6e:	1602                	slli	a2,a2,0x20
    80001d70:	9201                	srli	a2,a2,0x20
    80001d72:	1582                	slli	a1,a1,0x20
    80001d74:	9181                	srli	a1,a1,0x20
    80001d76:	6928                	ld	a0,80(a0)
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	68e080e7          	jalr	1678(ra) # 80001406 <uvmalloc>
    80001d80:	0005079b          	sext.w	a5,a0
    80001d84:	fbe1                	bnez	a5,80001d54 <growproc+0x26>
      return -1;
    80001d86:	557d                	li	a0,-1
    80001d88:	bfd9                	j	80001d5e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d8a:	00f4863b          	addw	a2,s1,a5
    80001d8e:	1602                	slli	a2,a2,0x20
    80001d90:	9201                	srli	a2,a2,0x20
    80001d92:	1582                	slli	a1,a1,0x20
    80001d94:	9181                	srli	a1,a1,0x20
    80001d96:	6928                	ld	a0,80(a0)
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	626080e7          	jalr	1574(ra) # 800013be <uvmdealloc>
    80001da0:	0005079b          	sext.w	a5,a0
    80001da4:	bf45                	j	80001d54 <growproc+0x26>

0000000080001da6 <fork>:
{
    80001da6:	7139                	addi	sp,sp,-64
    80001da8:	fc06                	sd	ra,56(sp)
    80001daa:	f822                	sd	s0,48(sp)
    80001dac:	f426                	sd	s1,40(sp)
    80001dae:	f04a                	sd	s2,32(sp)
    80001db0:	ec4e                	sd	s3,24(sp)
    80001db2:	e852                	sd	s4,16(sp)
    80001db4:	e456                	sd	s5,8(sp)
    80001db6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	bde080e7          	jalr	-1058(ra) # 80001996 <myproc>
    80001dc0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	dea080e7          	jalr	-534(ra) # 80001bac <allocproc>
    80001dca:	10050c63          	beqz	a0,80001ee2 <fork+0x13c>
    80001dce:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dd0:	048ab603          	ld	a2,72(s5)
    80001dd4:	692c                	ld	a1,80(a0)
    80001dd6:	050ab503          	ld	a0,80(s5)
    80001dda:	fffff097          	auipc	ra,0xfffff
    80001dde:	77c080e7          	jalr	1916(ra) # 80001556 <uvmcopy>
    80001de2:	04054863          	bltz	a0,80001e32 <fork+0x8c>
  np->sz = p->sz;
    80001de6:	048ab783          	ld	a5,72(s5)
    80001dea:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dee:	058ab683          	ld	a3,88(s5)
    80001df2:	87b6                	mv	a5,a3
    80001df4:	058a3703          	ld	a4,88(s4)
    80001df8:	12068693          	addi	a3,a3,288
    80001dfc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e00:	6788                	ld	a0,8(a5)
    80001e02:	6b8c                	ld	a1,16(a5)
    80001e04:	6f90                	ld	a2,24(a5)
    80001e06:	01073023          	sd	a6,0(a4)
    80001e0a:	e708                	sd	a0,8(a4)
    80001e0c:	eb0c                	sd	a1,16(a4)
    80001e0e:	ef10                	sd	a2,24(a4)
    80001e10:	02078793          	addi	a5,a5,32
    80001e14:	02070713          	addi	a4,a4,32
    80001e18:	fed792e3          	bne	a5,a3,80001dfc <fork+0x56>
  np->trapframe->a0 = 0;
    80001e1c:	058a3783          	ld	a5,88(s4)
    80001e20:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e24:	0d0a8493          	addi	s1,s5,208
    80001e28:	0d0a0913          	addi	s2,s4,208
    80001e2c:	150a8993          	addi	s3,s5,336
    80001e30:	a00d                	j	80001e52 <fork+0xac>
    freeproc(np);
    80001e32:	8552                	mv	a0,s4
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	d14080e7          	jalr	-748(ra) # 80001b48 <freeproc>
    release(&np->lock);
    80001e3c:	8552                	mv	a0,s4
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	e46080e7          	jalr	-442(ra) # 80000c84 <release>
    return -1;
    80001e46:	597d                	li	s2,-1
    80001e48:	a059                	j	80001ece <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e4a:	04a1                	addi	s1,s1,8
    80001e4c:	0921                	addi	s2,s2,8
    80001e4e:	01348b63          	beq	s1,s3,80001e64 <fork+0xbe>
    if(p->ofile[i])
    80001e52:	6088                	ld	a0,0(s1)
    80001e54:	d97d                	beqz	a0,80001e4a <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e56:	00003097          	auipc	ra,0x3
    80001e5a:	bec080e7          	jalr	-1044(ra) # 80004a42 <filedup>
    80001e5e:	00a93023          	sd	a0,0(s2)
    80001e62:	b7e5                	j	80001e4a <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e64:	150ab503          	ld	a0,336(s5)
    80001e68:	00002097          	auipc	ra,0x2
    80001e6c:	d4a080e7          	jalr	-694(ra) # 80003bb2 <idup>
    80001e70:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e74:	4641                	li	a2,16
    80001e76:	158a8593          	addi	a1,s5,344
    80001e7a:	158a0513          	addi	a0,s4,344
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	f98080e7          	jalr	-104(ra) # 80000e16 <safestrcpy>
  pid = np->pid;
    80001e86:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e8a:	8552                	mv	a0,s4
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	df8080e7          	jalr	-520(ra) # 80000c84 <release>
  acquire(&wait_lock);
    80001e94:	0000f497          	auipc	s1,0xf
    80001e98:	42448493          	addi	s1,s1,1060 # 800112b8 <wait_lock>
    80001e9c:	8526                	mv	a0,s1
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	d32080e7          	jalr	-718(ra) # 80000bd0 <acquire>
  np->parent = p;
    80001ea6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	dd8080e7          	jalr	-552(ra) # 80000c84 <release>
  acquire(&np->lock);
    80001eb4:	8552                	mv	a0,s4
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	d1a080e7          	jalr	-742(ra) # 80000bd0 <acquire>
  np->state = RUNNABLE;
    80001ebe:	478d                	li	a5,3
    80001ec0:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001ec4:	8552                	mv	a0,s4
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	dbe080e7          	jalr	-578(ra) # 80000c84 <release>
}
    80001ece:	854a                	mv	a0,s2
    80001ed0:	70e2                	ld	ra,56(sp)
    80001ed2:	7442                	ld	s0,48(sp)
    80001ed4:	74a2                	ld	s1,40(sp)
    80001ed6:	7902                	ld	s2,32(sp)
    80001ed8:	69e2                	ld	s3,24(sp)
    80001eda:	6a42                	ld	s4,16(sp)
    80001edc:	6aa2                	ld	s5,8(sp)
    80001ede:	6121                	addi	sp,sp,64
    80001ee0:	8082                	ret
    return -1;
    80001ee2:	597d                	li	s2,-1
    80001ee4:	b7ed                	j	80001ece <fork+0x128>

0000000080001ee6 <scheduler>:
{
    80001ee6:	711d                	addi	sp,sp,-96
    80001ee8:	ec86                	sd	ra,88(sp)
    80001eea:	e8a2                	sd	s0,80(sp)
    80001eec:	e4a6                	sd	s1,72(sp)
    80001eee:	e0ca                	sd	s2,64(sp)
    80001ef0:	fc4e                	sd	s3,56(sp)
    80001ef2:	f852                	sd	s4,48(sp)
    80001ef4:	f456                	sd	s5,40(sp)
    80001ef6:	f05a                	sd	s6,32(sp)
    80001ef8:	ec5e                	sd	s7,24(sp)
    80001efa:	e862                	sd	s8,16(sp)
    80001efc:	e466                	sd	s9,8(sp)
    80001efe:	1080                	addi	s0,sp,96
    80001f00:	8792                	mv	a5,tp
  int id = r_tp();
    80001f02:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f04:	00779c13          	slli	s8,a5,0x7
    80001f08:	0000f717          	auipc	a4,0xf
    80001f0c:	39870713          	addi	a4,a4,920 # 800112a0 <pid_lock>
    80001f10:	9762                	add	a4,a4,s8
    80001f12:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f16:	0000f717          	auipc	a4,0xf
    80001f1a:	3c270713          	addi	a4,a4,962 # 800112d8 <cpus+0x8>
    80001f1e:	9c3a                	add	s8,s8,a4
  	acquire(&tickslock);
    80001f20:	00015b17          	auipc	s6,0x15
    80001f24:	7b0b0b13          	addi	s6,s6,1968 # 800176d0 <tickslock>
  	xticks=ticks;
    80001f28:	00007c97          	auipc	s9,0x7
    80001f2c:	108c8c93          	addi	s9,s9,264 # 80009030 <ticks>
        c->proc = p;
    80001f30:	079e                	slli	a5,a5,0x7
    80001f32:	0000fa97          	auipc	s5,0xf
    80001f36:	36ea8a93          	addi	s5,s5,878 # 800112a0 <pid_lock>
    80001f3a:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f3c:	00015997          	auipc	s3,0x15
    80001f40:	79498993          	addi	s3,s3,1940 # 800176d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f48:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f4c:	10079073          	csrw	sstatus,a5
    80001f50:	0000f497          	auipc	s1,0xf
    80001f54:	78048493          	addi	s1,s1,1920 # 800116d0 <proc>
      if(p->state == RUNNABLE) {
    80001f58:	490d                	li	s2,3
        p->state = RUNNING;
    80001f5a:	4b91                	li	s7,4
    80001f5c:	a811                	j	80001f70 <scheduler+0x8a>
      release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d24080e7          	jalr	-732(ra) # 80000c84 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f68:	18048493          	addi	s1,s1,384
    80001f6c:	fd348ce3          	beq	s1,s3,80001f44 <scheduler+0x5e>
      acquire(&p->lock);
    80001f70:	8526                	mv	a0,s1
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	c5e080e7          	jalr	-930(ra) # 80000bd0 <acquire>
      if(p->state == RUNNABLE) {
    80001f7a:	4c9c                	lw	a5,24(s1)
    80001f7c:	ff2791e3          	bne	a5,s2,80001f5e <scheduler+0x78>
        p->state = RUNNING;
    80001f80:	0174ac23          	sw	s7,24(s1)
  	acquire(&tickslock);
    80001f84:	855a                	mv	a0,s6
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	c4a080e7          	jalr	-950(ra) # 80000bd0 <acquire>
  	xticks=ticks;
    80001f8e:	000caa03          	lw	s4,0(s9)
  	release(&tickslock);
    80001f92:	855a                	mv	a0,s6
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	cf0080e7          	jalr	-784(ra) # 80000c84 <release>
  	p->stime=xticks;
    80001f9c:	1a02                	slli	s4,s4,0x20
    80001f9e:	020a5a13          	srli	s4,s4,0x20
    80001fa2:	1744b823          	sd	s4,368(s1)
        c->proc = p;
    80001fa6:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001faa:	06048593          	addi	a1,s1,96
    80001fae:	8562                	mv	a0,s8
    80001fb0:	00001097          	auipc	ra,0x1
    80001fb4:	a9e080e7          	jalr	-1378(ra) # 80002a4e <swtch>
        c->proc = 0;
    80001fb8:	020ab823          	sd	zero,48(s5)
    80001fbc:	b74d                	j	80001f5e <scheduler+0x78>

0000000080001fbe <sched>:
{
    80001fbe:	7179                	addi	sp,sp,-48
    80001fc0:	f406                	sd	ra,40(sp)
    80001fc2:	f022                	sd	s0,32(sp)
    80001fc4:	ec26                	sd	s1,24(sp)
    80001fc6:	e84a                	sd	s2,16(sp)
    80001fc8:	e44e                	sd	s3,8(sp)
    80001fca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	9ca080e7          	jalr	-1590(ra) # 80001996 <myproc>
    80001fd4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	b80080e7          	jalr	-1152(ra) # 80000b56 <holding>
    80001fde:	c93d                	beqz	a0,80002054 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fe2:	2781                	sext.w	a5,a5
    80001fe4:	079e                	slli	a5,a5,0x7
    80001fe6:	0000f717          	auipc	a4,0xf
    80001fea:	2ba70713          	addi	a4,a4,698 # 800112a0 <pid_lock>
    80001fee:	97ba                	add	a5,a5,a4
    80001ff0:	0a87a703          	lw	a4,168(a5)
    80001ff4:	4785                	li	a5,1
    80001ff6:	06f71763          	bne	a4,a5,80002064 <sched+0xa6>
  if(p->state == RUNNING)
    80001ffa:	4c98                	lw	a4,24(s1)
    80001ffc:	4791                	li	a5,4
    80001ffe:	06f70b63          	beq	a4,a5,80002074 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002002:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002006:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002008:	efb5                	bnez	a5,80002084 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000200a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000200c:	0000f917          	auipc	s2,0xf
    80002010:	29490913          	addi	s2,s2,660 # 800112a0 <pid_lock>
    80002014:	2781                	sext.w	a5,a5
    80002016:	079e                	slli	a5,a5,0x7
    80002018:	97ca                	add	a5,a5,s2
    8000201a:	0ac7a983          	lw	s3,172(a5)
    8000201e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002020:	2781                	sext.w	a5,a5
    80002022:	079e                	slli	a5,a5,0x7
    80002024:	0000f597          	auipc	a1,0xf
    80002028:	2b458593          	addi	a1,a1,692 # 800112d8 <cpus+0x8>
    8000202c:	95be                	add	a1,a1,a5
    8000202e:	06048513          	addi	a0,s1,96
    80002032:	00001097          	auipc	ra,0x1
    80002036:	a1c080e7          	jalr	-1508(ra) # 80002a4e <swtch>
    8000203a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000203c:	2781                	sext.w	a5,a5
    8000203e:	079e                	slli	a5,a5,0x7
    80002040:	993e                	add	s2,s2,a5
    80002042:	0b392623          	sw	s3,172(s2)
}
    80002046:	70a2                	ld	ra,40(sp)
    80002048:	7402                	ld	s0,32(sp)
    8000204a:	64e2                	ld	s1,24(sp)
    8000204c:	6942                	ld	s2,16(sp)
    8000204e:	69a2                	ld	s3,8(sp)
    80002050:	6145                	addi	sp,sp,48
    80002052:	8082                	ret
    panic("sched p->lock");
    80002054:	00006517          	auipc	a0,0x6
    80002058:	1c450513          	addi	a0,a0,452 # 80008218 <digits+0x1d8>
    8000205c:	ffffe097          	auipc	ra,0xffffe
    80002060:	4de080e7          	jalr	1246(ra) # 8000053a <panic>
    panic("sched locks");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	1c450513          	addi	a0,a0,452 # 80008228 <digits+0x1e8>
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	4ce080e7          	jalr	1230(ra) # 8000053a <panic>
    panic("sched running");
    80002074:	00006517          	auipc	a0,0x6
    80002078:	1c450513          	addi	a0,a0,452 # 80008238 <digits+0x1f8>
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	4be080e7          	jalr	1214(ra) # 8000053a <panic>
    panic("sched interruptible");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	1c450513          	addi	a0,a0,452 # 80008248 <digits+0x208>
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	4ae080e7          	jalr	1198(ra) # 8000053a <panic>

0000000080002094 <yield>:
{
    80002094:	1101                	addi	sp,sp,-32
    80002096:	ec06                	sd	ra,24(sp)
    80002098:	e822                	sd	s0,16(sp)
    8000209a:	e426                	sd	s1,8(sp)
    8000209c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	8f8080e7          	jalr	-1800(ra) # 80001996 <myproc>
    800020a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	b28080e7          	jalr	-1240(ra) # 80000bd0 <acquire>
  p->state = RUNNABLE;
    800020b0:	478d                	li	a5,3
    800020b2:	cc9c                	sw	a5,24(s1)
  sched();
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	f0a080e7          	jalr	-246(ra) # 80001fbe <sched>
  release(&p->lock);
    800020bc:	8526                	mv	a0,s1
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	bc6080e7          	jalr	-1082(ra) # 80000c84 <release>
}
    800020c6:	60e2                	ld	ra,24(sp)
    800020c8:	6442                	ld	s0,16(sp)
    800020ca:	64a2                	ld	s1,8(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020d0:	7179                	addi	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	e84a                	sd	s2,16(sp)
    800020da:	e44e                	sd	s3,8(sp)
    800020dc:	1800                	addi	s0,sp,48
    800020de:	89aa                	mv	s3,a0
    800020e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	8b4080e7          	jalr	-1868(ra) # 80001996 <myproc>
    800020ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	ae4080e7          	jalr	-1308(ra) # 80000bd0 <acquire>
  release(lk);
    800020f4:	854a                	mv	a0,s2
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	b8e080e7          	jalr	-1138(ra) # 80000c84 <release>

  // Go to sleep.
  p->chan = chan;
    800020fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002102:	4789                	li	a5,2
    80002104:	cc9c                	sw	a5,24(s1)

  sched();
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	eb8080e7          	jalr	-328(ra) # 80001fbe <sched>

  // Tidy up.
  p->chan = 0;
    8000210e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	b70080e7          	jalr	-1168(ra) # 80000c84 <release>
  acquire(lk);
    8000211c:	854a                	mv	a0,s2
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	ab2080e7          	jalr	-1358(ra) # 80000bd0 <acquire>
}
    80002126:	70a2                	ld	ra,40(sp)
    80002128:	7402                	ld	s0,32(sp)
    8000212a:	64e2                	ld	s1,24(sp)
    8000212c:	6942                	ld	s2,16(sp)
    8000212e:	69a2                	ld	s3,8(sp)
    80002130:	6145                	addi	sp,sp,48
    80002132:	8082                	ret

0000000080002134 <wait>:
{
    80002134:	715d                	addi	sp,sp,-80
    80002136:	e486                	sd	ra,72(sp)
    80002138:	e0a2                	sd	s0,64(sp)
    8000213a:	fc26                	sd	s1,56(sp)
    8000213c:	f84a                	sd	s2,48(sp)
    8000213e:	f44e                	sd	s3,40(sp)
    80002140:	f052                	sd	s4,32(sp)
    80002142:	ec56                	sd	s5,24(sp)
    80002144:	e85a                	sd	s6,16(sp)
    80002146:	e45e                	sd	s7,8(sp)
    80002148:	e062                	sd	s8,0(sp)
    8000214a:	0880                	addi	s0,sp,80
    8000214c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	848080e7          	jalr	-1976(ra) # 80001996 <myproc>
    80002156:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002158:	0000f517          	auipc	a0,0xf
    8000215c:	16050513          	addi	a0,a0,352 # 800112b8 <wait_lock>
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	a70080e7          	jalr	-1424(ra) # 80000bd0 <acquire>
    havekids = 0;
    80002168:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000216a:	4a15                	li	s4,5
        havekids = 1;
    8000216c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000216e:	00015997          	auipc	s3,0x15
    80002172:	56298993          	addi	s3,s3,1378 # 800176d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002176:	0000fc17          	auipc	s8,0xf
    8000217a:	142c0c13          	addi	s8,s8,322 # 800112b8 <wait_lock>
    havekids = 0;
    8000217e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002180:	0000f497          	auipc	s1,0xf
    80002184:	55048493          	addi	s1,s1,1360 # 800116d0 <proc>
    80002188:	a0bd                	j	800021f6 <wait+0xc2>
          pid = np->pid;
    8000218a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000218e:	000b0e63          	beqz	s6,800021aa <wait+0x76>
    80002192:	4691                	li	a3,4
    80002194:	02c48613          	addi	a2,s1,44
    80002198:	85da                	mv	a1,s6
    8000219a:	05093503          	ld	a0,80(s2)
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	4bc080e7          	jalr	1212(ra) # 8000165a <copyout>
    800021a6:	02054563          	bltz	a0,800021d0 <wait+0x9c>
          freeproc(np);
    800021aa:	8526                	mv	a0,s1
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	99c080e7          	jalr	-1636(ra) # 80001b48 <freeproc>
          release(&np->lock);
    800021b4:	8526                	mv	a0,s1
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	ace080e7          	jalr	-1330(ra) # 80000c84 <release>
          release(&wait_lock);
    800021be:	0000f517          	auipc	a0,0xf
    800021c2:	0fa50513          	addi	a0,a0,250 # 800112b8 <wait_lock>
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	abe080e7          	jalr	-1346(ra) # 80000c84 <release>
          return pid;
    800021ce:	a09d                	j	80002234 <wait+0x100>
            release(&np->lock);
    800021d0:	8526                	mv	a0,s1
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	ab2080e7          	jalr	-1358(ra) # 80000c84 <release>
            release(&wait_lock);
    800021da:	0000f517          	auipc	a0,0xf
    800021de:	0de50513          	addi	a0,a0,222 # 800112b8 <wait_lock>
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	aa2080e7          	jalr	-1374(ra) # 80000c84 <release>
            return -1;
    800021ea:	59fd                	li	s3,-1
    800021ec:	a0a1                	j	80002234 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800021ee:	18048493          	addi	s1,s1,384
    800021f2:	03348463          	beq	s1,s3,8000221a <wait+0xe6>
      if(np->parent == p){
    800021f6:	7c9c                	ld	a5,56(s1)
    800021f8:	ff279be3          	bne	a5,s2,800021ee <wait+0xba>
        acquire(&np->lock);
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	9d2080e7          	jalr	-1582(ra) # 80000bd0 <acquire>
        if(np->state == ZOMBIE){
    80002206:	4c9c                	lw	a5,24(s1)
    80002208:	f94781e3          	beq	a5,s4,8000218a <wait+0x56>
        release(&np->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	a76080e7          	jalr	-1418(ra) # 80000c84 <release>
        havekids = 1;
    80002216:	8756                	mv	a4,s5
    80002218:	bfd9                	j	800021ee <wait+0xba>
    if(!havekids || p->killed){
    8000221a:	c701                	beqz	a4,80002222 <wait+0xee>
    8000221c:	02892783          	lw	a5,40(s2)
    80002220:	c79d                	beqz	a5,8000224e <wait+0x11a>
      release(&wait_lock);
    80002222:	0000f517          	auipc	a0,0xf
    80002226:	09650513          	addi	a0,a0,150 # 800112b8 <wait_lock>
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	a5a080e7          	jalr	-1446(ra) # 80000c84 <release>
      return -1;
    80002232:	59fd                	li	s3,-1
}
    80002234:	854e                	mv	a0,s3
    80002236:	60a6                	ld	ra,72(sp)
    80002238:	6406                	ld	s0,64(sp)
    8000223a:	74e2                	ld	s1,56(sp)
    8000223c:	7942                	ld	s2,48(sp)
    8000223e:	79a2                	ld	s3,40(sp)
    80002240:	7a02                	ld	s4,32(sp)
    80002242:	6ae2                	ld	s5,24(sp)
    80002244:	6b42                	ld	s6,16(sp)
    80002246:	6ba2                	ld	s7,8(sp)
    80002248:	6c02                	ld	s8,0(sp)
    8000224a:	6161                	addi	sp,sp,80
    8000224c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000224e:	85e2                	mv	a1,s8
    80002250:	854a                	mv	a0,s2
    80002252:	00000097          	auipc	ra,0x0
    80002256:	e7e080e7          	jalr	-386(ra) # 800020d0 <sleep>
    havekids = 0;
    8000225a:	b715                	j	8000217e <wait+0x4a>

000000008000225c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000225c:	7139                	addi	sp,sp,-64
    8000225e:	fc06                	sd	ra,56(sp)
    80002260:	f822                	sd	s0,48(sp)
    80002262:	f426                	sd	s1,40(sp)
    80002264:	f04a                	sd	s2,32(sp)
    80002266:	ec4e                	sd	s3,24(sp)
    80002268:	e852                	sd	s4,16(sp)
    8000226a:	e456                	sd	s5,8(sp)
    8000226c:	0080                	addi	s0,sp,64
    8000226e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002270:	0000f497          	auipc	s1,0xf
    80002274:	46048493          	addi	s1,s1,1120 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002278:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000227a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000227c:	00015917          	auipc	s2,0x15
    80002280:	45490913          	addi	s2,s2,1108 # 800176d0 <tickslock>
    80002284:	a811                	j	80002298 <wakeup+0x3c>
      }
      release(&p->lock);
    80002286:	8526                	mv	a0,s1
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	9fc080e7          	jalr	-1540(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002290:	18048493          	addi	s1,s1,384
    80002294:	03248663          	beq	s1,s2,800022c0 <wakeup+0x64>
    if(p != myproc()){
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	6fe080e7          	jalr	1790(ra) # 80001996 <myproc>
    800022a0:	fea488e3          	beq	s1,a0,80002290 <wakeup+0x34>
      acquire(&p->lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	92a080e7          	jalr	-1750(ra) # 80000bd0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022ae:	4c9c                	lw	a5,24(s1)
    800022b0:	fd379be3          	bne	a5,s3,80002286 <wakeup+0x2a>
    800022b4:	709c                	ld	a5,32(s1)
    800022b6:	fd4798e3          	bne	a5,s4,80002286 <wakeup+0x2a>
        p->state = RUNNABLE;
    800022ba:	0154ac23          	sw	s5,24(s1)
    800022be:	b7e1                	j	80002286 <wakeup+0x2a>
    }
  }
}
    800022c0:	70e2                	ld	ra,56(sp)
    800022c2:	7442                	ld	s0,48(sp)
    800022c4:	74a2                	ld	s1,40(sp)
    800022c6:	7902                	ld	s2,32(sp)
    800022c8:	69e2                	ld	s3,24(sp)
    800022ca:	6a42                	ld	s4,16(sp)
    800022cc:	6aa2                	ld	s5,8(sp)
    800022ce:	6121                	addi	sp,sp,64
    800022d0:	8082                	ret

00000000800022d2 <reparent>:
{
    800022d2:	7179                	addi	sp,sp,-48
    800022d4:	f406                	sd	ra,40(sp)
    800022d6:	f022                	sd	s0,32(sp)
    800022d8:	ec26                	sd	s1,24(sp)
    800022da:	e84a                	sd	s2,16(sp)
    800022dc:	e44e                	sd	s3,8(sp)
    800022de:	e052                	sd	s4,0(sp)
    800022e0:	1800                	addi	s0,sp,48
    800022e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e4:	0000f497          	auipc	s1,0xf
    800022e8:	3ec48493          	addi	s1,s1,1004 # 800116d0 <proc>
      pp->parent = initproc;
    800022ec:	00007a17          	auipc	s4,0x7
    800022f0:	d3ca0a13          	addi	s4,s4,-708 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f4:	00015997          	auipc	s3,0x15
    800022f8:	3dc98993          	addi	s3,s3,988 # 800176d0 <tickslock>
    800022fc:	a029                	j	80002306 <reparent+0x34>
    800022fe:	18048493          	addi	s1,s1,384
    80002302:	01348d63          	beq	s1,s3,8000231c <reparent+0x4a>
    if(pp->parent == p){
    80002306:	7c9c                	ld	a5,56(s1)
    80002308:	ff279be3          	bne	a5,s2,800022fe <reparent+0x2c>
      pp->parent = initproc;
    8000230c:	000a3503          	ld	a0,0(s4)
    80002310:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002312:	00000097          	auipc	ra,0x0
    80002316:	f4a080e7          	jalr	-182(ra) # 8000225c <wakeup>
    8000231a:	b7d5                	j	800022fe <reparent+0x2c>
}
    8000231c:	70a2                	ld	ra,40(sp)
    8000231e:	7402                	ld	s0,32(sp)
    80002320:	64e2                	ld	s1,24(sp)
    80002322:	6942                	ld	s2,16(sp)
    80002324:	69a2                	ld	s3,8(sp)
    80002326:	6a02                	ld	s4,0(sp)
    80002328:	6145                	addi	sp,sp,48
    8000232a:	8082                	ret

000000008000232c <exit>:
{
    8000232c:	7179                	addi	sp,sp,-48
    8000232e:	f406                	sd	ra,40(sp)
    80002330:	f022                	sd	s0,32(sp)
    80002332:	ec26                	sd	s1,24(sp)
    80002334:	e84a                	sd	s2,16(sp)
    80002336:	e44e                	sd	s3,8(sp)
    80002338:	e052                	sd	s4,0(sp)
    8000233a:	1800                	addi	s0,sp,48
    8000233c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	658080e7          	jalr	1624(ra) # 80001996 <myproc>
    80002346:	89aa                	mv	s3,a0
  if(p == initproc)
    80002348:	00007797          	auipc	a5,0x7
    8000234c:	ce07b783          	ld	a5,-800(a5) # 80009028 <initproc>
    80002350:	0d050493          	addi	s1,a0,208
    80002354:	15050913          	addi	s2,a0,336
    80002358:	02a79363          	bne	a5,a0,8000237e <exit+0x52>
    panic("init exiting");
    8000235c:	00006517          	auipc	a0,0x6
    80002360:	f0450513          	addi	a0,a0,-252 # 80008260 <digits+0x220>
    80002364:	ffffe097          	auipc	ra,0xffffe
    80002368:	1d6080e7          	jalr	470(ra) # 8000053a <panic>
      fileclose(f);
    8000236c:	00002097          	auipc	ra,0x2
    80002370:	728080e7          	jalr	1832(ra) # 80004a94 <fileclose>
      p->ofile[fd] = 0;
    80002374:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002378:	04a1                	addi	s1,s1,8
    8000237a:	01248563          	beq	s1,s2,80002384 <exit+0x58>
    if(p->ofile[fd]){
    8000237e:	6088                	ld	a0,0(s1)
    80002380:	f575                	bnez	a0,8000236c <exit+0x40>
    80002382:	bfdd                	j	80002378 <exit+0x4c>
  begin_op();
    80002384:	00002097          	auipc	ra,0x2
    80002388:	248080e7          	jalr	584(ra) # 800045cc <begin_op>
  iput(p->cwd);
    8000238c:	1509b503          	ld	a0,336(s3)
    80002390:	00002097          	auipc	ra,0x2
    80002394:	a1a080e7          	jalr	-1510(ra) # 80003daa <iput>
  end_op();
    80002398:	00002097          	auipc	ra,0x2
    8000239c:	2b2080e7          	jalr	690(ra) # 8000464a <end_op>
  p->cwd = 0;
    800023a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023a4:	0000f497          	auipc	s1,0xf
    800023a8:	f1448493          	addi	s1,s1,-236 # 800112b8 <wait_lock>
    800023ac:	8526                	mv	a0,s1
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	822080e7          	jalr	-2014(ra) # 80000bd0 <acquire>
  reparent(p);
    800023b6:	854e                	mv	a0,s3
    800023b8:	00000097          	auipc	ra,0x0
    800023bc:	f1a080e7          	jalr	-230(ra) # 800022d2 <reparent>
  wakeup(p->parent);
    800023c0:	0389b503          	ld	a0,56(s3)
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	e98080e7          	jalr	-360(ra) # 8000225c <wakeup>
  acquire(&p->lock);
    800023cc:	854e                	mv	a0,s3
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	802080e7          	jalr	-2046(ra) # 80000bd0 <acquire>
  p->xstate = status;
    800023d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023da:	4795                	li	a5,5
    800023dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023e0:	8526                	mv	a0,s1
    800023e2:	fffff097          	auipc	ra,0xfffff
    800023e6:	8a2080e7          	jalr	-1886(ra) # 80000c84 <release>
  acquire(&tickslock);
    800023ea:	00015517          	auipc	a0,0x15
    800023ee:	2e650513          	addi	a0,a0,742 # 800176d0 <tickslock>
    800023f2:	ffffe097          	auipc	ra,0xffffe
    800023f6:	7de080e7          	jalr	2014(ra) # 80000bd0 <acquire>
  xticks=ticks;
    800023fa:	00007497          	auipc	s1,0x7
    800023fe:	c364a483          	lw	s1,-970(s1) # 80009030 <ticks>
  release(&tickslock);
    80002402:	00015517          	auipc	a0,0x15
    80002406:	2ce50513          	addi	a0,a0,718 # 800176d0 <tickslock>
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	87a080e7          	jalr	-1926(ra) # 80000c84 <release>
  p->etime=xticks;
    80002412:	1482                	slli	s1,s1,0x20
    80002414:	9081                	srli	s1,s1,0x20
    80002416:	1699bc23          	sd	s1,376(s3)
  sched();
    8000241a:	00000097          	auipc	ra,0x0
    8000241e:	ba4080e7          	jalr	-1116(ra) # 80001fbe <sched>
  panic("zombie exit");
    80002422:	00006517          	auipc	a0,0x6
    80002426:	e4e50513          	addi	a0,a0,-434 # 80008270 <digits+0x230>
    8000242a:	ffffe097          	auipc	ra,0xffffe
    8000242e:	110080e7          	jalr	272(ra) # 8000053a <panic>

0000000080002432 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002432:	7179                	addi	sp,sp,-48
    80002434:	f406                	sd	ra,40(sp)
    80002436:	f022                	sd	s0,32(sp)
    80002438:	ec26                	sd	s1,24(sp)
    8000243a:	e84a                	sd	s2,16(sp)
    8000243c:	e44e                	sd	s3,8(sp)
    8000243e:	1800                	addi	s0,sp,48
    80002440:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002442:	0000f497          	auipc	s1,0xf
    80002446:	28e48493          	addi	s1,s1,654 # 800116d0 <proc>
    8000244a:	00015997          	auipc	s3,0x15
    8000244e:	28698993          	addi	s3,s3,646 # 800176d0 <tickslock>
    acquire(&p->lock);
    80002452:	8526                	mv	a0,s1
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	77c080e7          	jalr	1916(ra) # 80000bd0 <acquire>
    if(p->pid == pid){
    8000245c:	589c                	lw	a5,48(s1)
    8000245e:	01278d63          	beq	a5,s2,80002478 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002462:	8526                	mv	a0,s1
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	820080e7          	jalr	-2016(ra) # 80000c84 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000246c:	18048493          	addi	s1,s1,384
    80002470:	ff3491e3          	bne	s1,s3,80002452 <kill+0x20>
  }
  return -1;
    80002474:	557d                	li	a0,-1
    80002476:	a829                	j	80002490 <kill+0x5e>
      p->killed = 1;
    80002478:	4785                	li	a5,1
    8000247a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000247c:	4c98                	lw	a4,24(s1)
    8000247e:	4789                	li	a5,2
    80002480:	00f70f63          	beq	a4,a5,8000249e <kill+0x6c>
      release(&p->lock);
    80002484:	8526                	mv	a0,s1
    80002486:	ffffe097          	auipc	ra,0xffffe
    8000248a:	7fe080e7          	jalr	2046(ra) # 80000c84 <release>
      return 0;
    8000248e:	4501                	li	a0,0
}
    80002490:	70a2                	ld	ra,40(sp)
    80002492:	7402                	ld	s0,32(sp)
    80002494:	64e2                	ld	s1,24(sp)
    80002496:	6942                	ld	s2,16(sp)
    80002498:	69a2                	ld	s3,8(sp)
    8000249a:	6145                	addi	sp,sp,48
    8000249c:	8082                	ret
        p->state = RUNNABLE;
    8000249e:	478d                	li	a5,3
    800024a0:	cc9c                	sw	a5,24(s1)
    800024a2:	b7cd                	j	80002484 <kill+0x52>

00000000800024a4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024a4:	7179                	addi	sp,sp,-48
    800024a6:	f406                	sd	ra,40(sp)
    800024a8:	f022                	sd	s0,32(sp)
    800024aa:	ec26                	sd	s1,24(sp)
    800024ac:	e84a                	sd	s2,16(sp)
    800024ae:	e44e                	sd	s3,8(sp)
    800024b0:	e052                	sd	s4,0(sp)
    800024b2:	1800                	addi	s0,sp,48
    800024b4:	84aa                	mv	s1,a0
    800024b6:	892e                	mv	s2,a1
    800024b8:	89b2                	mv	s3,a2
    800024ba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	4da080e7          	jalr	1242(ra) # 80001996 <myproc>
  if(user_dst){
    800024c4:	c08d                	beqz	s1,800024e6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024c6:	86d2                	mv	a3,s4
    800024c8:	864e                	mv	a2,s3
    800024ca:	85ca                	mv	a1,s2
    800024cc:	6928                	ld	a0,80(a0)
    800024ce:	fffff097          	auipc	ra,0xfffff
    800024d2:	18c080e7          	jalr	396(ra) # 8000165a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024d6:	70a2                	ld	ra,40(sp)
    800024d8:	7402                	ld	s0,32(sp)
    800024da:	64e2                	ld	s1,24(sp)
    800024dc:	6942                	ld	s2,16(sp)
    800024de:	69a2                	ld	s3,8(sp)
    800024e0:	6a02                	ld	s4,0(sp)
    800024e2:	6145                	addi	sp,sp,48
    800024e4:	8082                	ret
    memmove((char *)dst, src, len);
    800024e6:	000a061b          	sext.w	a2,s4
    800024ea:	85ce                	mv	a1,s3
    800024ec:	854a                	mv	a0,s2
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	83a080e7          	jalr	-1990(ra) # 80000d28 <memmove>
    return 0;
    800024f6:	8526                	mv	a0,s1
    800024f8:	bff9                	j	800024d6 <either_copyout+0x32>

00000000800024fa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024fa:	7179                	addi	sp,sp,-48
    800024fc:	f406                	sd	ra,40(sp)
    800024fe:	f022                	sd	s0,32(sp)
    80002500:	ec26                	sd	s1,24(sp)
    80002502:	e84a                	sd	s2,16(sp)
    80002504:	e44e                	sd	s3,8(sp)
    80002506:	e052                	sd	s4,0(sp)
    80002508:	1800                	addi	s0,sp,48
    8000250a:	892a                	mv	s2,a0
    8000250c:	84ae                	mv	s1,a1
    8000250e:	89b2                	mv	s3,a2
    80002510:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	484080e7          	jalr	1156(ra) # 80001996 <myproc>
  if(user_src){
    8000251a:	c08d                	beqz	s1,8000253c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000251c:	86d2                	mv	a3,s4
    8000251e:	864e                	mv	a2,s3
    80002520:	85ca                	mv	a1,s2
    80002522:	6928                	ld	a0,80(a0)
    80002524:	fffff097          	auipc	ra,0xfffff
    80002528:	1c2080e7          	jalr	450(ra) # 800016e6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000252c:	70a2                	ld	ra,40(sp)
    8000252e:	7402                	ld	s0,32(sp)
    80002530:	64e2                	ld	s1,24(sp)
    80002532:	6942                	ld	s2,16(sp)
    80002534:	69a2                	ld	s3,8(sp)
    80002536:	6a02                	ld	s4,0(sp)
    80002538:	6145                	addi	sp,sp,48
    8000253a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000253c:	000a061b          	sext.w	a2,s4
    80002540:	85ce                	mv	a1,s3
    80002542:	854a                	mv	a0,s2
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	7e4080e7          	jalr	2020(ra) # 80000d28 <memmove>
    return 0;
    8000254c:	8526                	mv	a0,s1
    8000254e:	bff9                	j	8000252c <either_copyin+0x32>

0000000080002550 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002550:	715d                	addi	sp,sp,-80
    80002552:	e486                	sd	ra,72(sp)
    80002554:	e0a2                	sd	s0,64(sp)
    80002556:	fc26                	sd	s1,56(sp)
    80002558:	f84a                	sd	s2,48(sp)
    8000255a:	f44e                	sd	s3,40(sp)
    8000255c:	f052                	sd	s4,32(sp)
    8000255e:	ec56                	sd	s5,24(sp)
    80002560:	e85a                	sd	s6,16(sp)
    80002562:	e45e                	sd	s7,8(sp)
    80002564:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002566:	00006517          	auipc	a0,0x6
    8000256a:	b6250513          	addi	a0,a0,-1182 # 800080c8 <digits+0x88>
    8000256e:	ffffe097          	auipc	ra,0xffffe
    80002572:	016080e7          	jalr	22(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002576:	0000f497          	auipc	s1,0xf
    8000257a:	2b248493          	addi	s1,s1,690 # 80011828 <proc+0x158>
    8000257e:	00015917          	auipc	s2,0x15
    80002582:	2aa90913          	addi	s2,s2,682 # 80017828 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002586:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002588:	00006997          	auipc	s3,0x6
    8000258c:	cf898993          	addi	s3,s3,-776 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80002590:	00006a97          	auipc	s5,0x6
    80002594:	cf8a8a93          	addi	s5,s5,-776 # 80008288 <digits+0x248>
    printf("\n");
    80002598:	00006a17          	auipc	s4,0x6
    8000259c:	b30a0a13          	addi	s4,s4,-1232 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a0:	00006b97          	auipc	s7,0x6
    800025a4:	de8b8b93          	addi	s7,s7,-536 # 80008388 <states.0>
    800025a8:	a00d                	j	800025ca <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025aa:	ed86a583          	lw	a1,-296(a3)
    800025ae:	8556                	mv	a0,s5
    800025b0:	ffffe097          	auipc	ra,0xffffe
    800025b4:	fd4080e7          	jalr	-44(ra) # 80000584 <printf>
    printf("\n");
    800025b8:	8552                	mv	a0,s4
    800025ba:	ffffe097          	auipc	ra,0xffffe
    800025be:	fca080e7          	jalr	-54(ra) # 80000584 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025c2:	18048493          	addi	s1,s1,384
    800025c6:	03248263          	beq	s1,s2,800025ea <procdump+0x9a>
    if(p->state == UNUSED)
    800025ca:	86a6                	mv	a3,s1
    800025cc:	ec04a783          	lw	a5,-320(s1)
    800025d0:	dbed                	beqz	a5,800025c2 <procdump+0x72>
      state = "???";
    800025d2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d4:	fcfb6be3          	bltu	s6,a5,800025aa <procdump+0x5a>
    800025d8:	02079713          	slli	a4,a5,0x20
    800025dc:	01d75793          	srli	a5,a4,0x1d
    800025e0:	97de                	add	a5,a5,s7
    800025e2:	6390                	ld	a2,0(a5)
    800025e4:	f279                	bnez	a2,800025aa <procdump+0x5a>
      state = "???";
    800025e6:	864e                	mv	a2,s3
    800025e8:	b7c9                	j	800025aa <procdump+0x5a>
  }
}
    800025ea:	60a6                	ld	ra,72(sp)
    800025ec:	6406                	ld	s0,64(sp)
    800025ee:	74e2                	ld	s1,56(sp)
    800025f0:	7942                	ld	s2,48(sp)
    800025f2:	79a2                	ld	s3,40(sp)
    800025f4:	7a02                	ld	s4,32(sp)
    800025f6:	6ae2                	ld	s5,24(sp)
    800025f8:	6b42                	ld	s6,16(sp)
    800025fa:	6ba2                	ld	s7,8(sp)
    800025fc:	6161                	addi	sp,sp,80
    800025fe:	8082                	ret

0000000080002600 <getppid>:

int getppid(void){
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
	acquire(&wait_lock);
    8000260a:	0000f517          	auipc	a0,0xf
    8000260e:	cae50513          	addi	a0,a0,-850 # 800112b8 <wait_lock>
    80002612:	ffffe097          	auipc	ra,0xffffe
    80002616:	5be080e7          	jalr	1470(ra) # 80000bd0 <acquire>
	int idp;
	struct proc*p;
	p=myproc();
    8000261a:	fffff097          	auipc	ra,0xfffff
    8000261e:	37c080e7          	jalr	892(ra) # 80001996 <myproc>
	if(p->pid==1) return -1;
    80002622:	5918                	lw	a4,48(a0)
    80002624:	4785                	li	a5,1
    80002626:	02f70263          	beq	a4,a5,8000264a <getppid+0x4a>
	idp=p->parent->pid;
    8000262a:	7d1c                	ld	a5,56(a0)
    8000262c:	5b84                	lw	s1,48(a5)
	release(&wait_lock);
    8000262e:	0000f517          	auipc	a0,0xf
    80002632:	c8a50513          	addi	a0,a0,-886 # 800112b8 <wait_lock>
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	64e080e7          	jalr	1614(ra) # 80000c84 <release>
	return idp;
}
    8000263e:	8526                	mv	a0,s1
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret
	if(p->pid==1) return -1;
    8000264a:	54fd                	li	s1,-1
    8000264c:	bfcd                	j	8000263e <getppid+0x3e>

000000008000264e <waitpid>:

int
waitpid(int id, uint64 addr)
{
    8000264e:	7159                	addi	sp,sp,-112
    80002650:	f486                	sd	ra,104(sp)
    80002652:	f0a2                	sd	s0,96(sp)
    80002654:	eca6                	sd	s1,88(sp)
    80002656:	e8ca                	sd	s2,80(sp)
    80002658:	e4ce                	sd	s3,72(sp)
    8000265a:	e0d2                	sd	s4,64(sp)
    8000265c:	fc56                	sd	s5,56(sp)
    8000265e:	f85a                	sd	s6,48(sp)
    80002660:	f45e                	sd	s7,40(sp)
    80002662:	f062                	sd	s8,32(sp)
    80002664:	ec66                	sd	s9,24(sp)
    80002666:	e86a                	sd	s10,16(sp)
    80002668:	e46e                	sd	s11,8(sp)
    8000266a:	1880                	addi	s0,sp,112
    8000266c:	8a2a                	mv	s4,a0
    8000266e:	8c2e                	mv	s8,a1
  struct proc *np;
  int found, pid;
  struct proc *p = myproc();
    80002670:	fffff097          	auipc	ra,0xfffff
    80002674:	326080e7          	jalr	806(ra) # 80001996 <myproc>
    80002678:	892a                	mv	s2,a0
  //printf("%d\n",id);
  acquire(&wait_lock);
    8000267a:	0000f517          	auipc	a0,0xf
    8000267e:	c3e50513          	addi	a0,a0,-962 # 800112b8 <wait_lock>
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	54e080e7          	jalr	1358(ra) # 80000bd0 <acquire>
  for(;;){
    found = 0;
    8000268a:	4c81                	li	s9,0
        acquire(&np->lock);
        //printf("of proc %d\n",np->pid);
        if(np->pid!=id) continue;
        if(np->pid==id) found=1;
        
        if(np->state == ZOMBIE ){
    8000268c:	4b15                	li	s6,5
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
    8000268e:	4b85                	li	s7,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002690:	00015997          	auipc	s3,0x15
    80002694:	04098993          	addi	s3,s3,64 # 800176d0 <tickslock>
      //printf("inside !found, value of found=%d\n",found);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002698:	0000fd17          	auipc	s10,0xf
    8000269c:	c20d0d13          	addi	s10,s10,-992 # 800112b8 <wait_lock>
    found = 0;
    800026a0:	8ae6                	mv	s5,s9
    for(np = proc; np < &proc[NPROC]; np++){
    800026a2:	0000f497          	auipc	s1,0xf
    800026a6:	02e48493          	addi	s1,s1,46 # 800116d0 <proc>
    800026aa:	a0ad                	j	80002714 <waitpid+0xc6>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800026ac:	000c0e63          	beqz	s8,800026c8 <waitpid+0x7a>
    800026b0:	4691                	li	a3,4
    800026b2:	02c48613          	addi	a2,s1,44
    800026b6:	85e2                	mv	a1,s8
    800026b8:	05093503          	ld	a0,80(s2)
    800026bc:	fffff097          	auipc	ra,0xfffff
    800026c0:	f9e080e7          	jalr	-98(ra) # 8000165a <copyout>
    800026c4:	02054563          	bltz	a0,800026ee <waitpid+0xa0>
          freeproc(np);
    800026c8:	8526                	mv	a0,s1
    800026ca:	fffff097          	auipc	ra,0xfffff
    800026ce:	47e080e7          	jalr	1150(ra) # 80001b48 <freeproc>
          release(&np->lock);
    800026d2:	8526                	mv	a0,s1
    800026d4:	ffffe097          	auipc	ra,0xffffe
    800026d8:	5b0080e7          	jalr	1456(ra) # 80000c84 <release>
          release(&wait_lock);
    800026dc:	0000f517          	auipc	a0,0xf
    800026e0:	bdc50513          	addi	a0,a0,-1060 # 800112b8 <wait_lock>
    800026e4:	ffffe097          	auipc	ra,0xffffe
    800026e8:	5a0080e7          	jalr	1440(ra) # 80000c84 <release>
          return pid;
    800026ec:	a885                	j	8000275c <waitpid+0x10e>
            release(&np->lock);
    800026ee:	8526                	mv	a0,s1
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	594080e7          	jalr	1428(ra) # 80000c84 <release>
            release(&wait_lock);
    800026f8:	0000f517          	auipc	a0,0xf
    800026fc:	bc050513          	addi	a0,a0,-1088 # 800112b8 <wait_lock>
    80002700:	ffffe097          	auipc	ra,0xffffe
    80002704:	584080e7          	jalr	1412(ra) # 80000c84 <release>
            return -1;
    80002708:	5dfd                	li	s11,-1
    8000270a:	a889                	j	8000275c <waitpid+0x10e>
    for(np = proc; np < &proc[NPROC]; np++){
    8000270c:	18048493          	addi	s1,s1,384
    80002710:	03348863          	beq	s1,s3,80002740 <waitpid+0xf2>
      if(np->parent == p ){
    80002714:	7c9c                	ld	a5,56(s1)
    80002716:	ff279be3          	bne	a5,s2,8000270c <waitpid+0xbe>
        acquire(&np->lock);
    8000271a:	8526                	mv	a0,s1
    8000271c:	ffffe097          	auipc	ra,0xffffe
    80002720:	4b4080e7          	jalr	1204(ra) # 80000bd0 <acquire>
        if(np->pid!=id) continue;
    80002724:	0304ad83          	lw	s11,48(s1)
    80002728:	ff4d92e3          	bne	s11,s4,8000270c <waitpid+0xbe>
        if(np->state == ZOMBIE ){
    8000272c:	4c9c                	lw	a5,24(s1)
    8000272e:	f7678fe3          	beq	a5,s6,800026ac <waitpid+0x5e>
        release(&np->lock);
    80002732:	8526                	mv	a0,s1
    80002734:	ffffe097          	auipc	ra,0xffffe
    80002738:	550080e7          	jalr	1360(ra) # 80000c84 <release>
    8000273c:	8ade                	mv	s5,s7
    8000273e:	b7f9                	j	8000270c <waitpid+0xbe>
    if(!found || p->killed){
    80002740:	000a8563          	beqz	s5,8000274a <waitpid+0xfc>
    80002744:	02892783          	lw	a5,40(s2)
    80002748:	cb95                	beqz	a5,8000277c <waitpid+0x12e>
      release(&wait_lock);
    8000274a:	0000f517          	auipc	a0,0xf
    8000274e:	b6e50513          	addi	a0,a0,-1170 # 800112b8 <wait_lock>
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	532080e7          	jalr	1330(ra) # 80000c84 <release>
      return -1;
    8000275a:	5dfd                	li	s11,-1
  }
}
    8000275c:	856e                	mv	a0,s11
    8000275e:	70a6                	ld	ra,104(sp)
    80002760:	7406                	ld	s0,96(sp)
    80002762:	64e6                	ld	s1,88(sp)
    80002764:	6946                	ld	s2,80(sp)
    80002766:	69a6                	ld	s3,72(sp)
    80002768:	6a06                	ld	s4,64(sp)
    8000276a:	7ae2                	ld	s5,56(sp)
    8000276c:	7b42                	ld	s6,48(sp)
    8000276e:	7ba2                	ld	s7,40(sp)
    80002770:	7c02                	ld	s8,32(sp)
    80002772:	6ce2                	ld	s9,24(sp)
    80002774:	6d42                	ld	s10,16(sp)
    80002776:	6da2                	ld	s11,8(sp)
    80002778:	6165                	addi	sp,sp,112
    8000277a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000277c:	85ea                	mv	a1,s10
    8000277e:	854a                	mv	a0,s2
    80002780:	00000097          	auipc	ra,0x0
    80002784:	950080e7          	jalr	-1712(ra) # 800020d0 <sleep>
    found = 0;
    80002788:	bf21                	j	800026a0 <waitpid+0x52>

000000008000278a <ps>:


void ps(void){
    8000278a:	7119                	addi	sp,sp,-128
    8000278c:	fc86                	sd	ra,120(sp)
    8000278e:	f8a2                	sd	s0,112(sp)
    80002790:	f4a6                	sd	s1,104(sp)
    80002792:	f0ca                	sd	s2,96(sp)
    80002794:	ecce                	sd	s3,88(sp)
    80002796:	e8d2                	sd	s4,80(sp)
    80002798:	e4d6                	sd	s5,72(sp)
    8000279a:	e0da                	sd	s6,64(sp)
    8000279c:	fc5e                	sd	s7,56(sp)
    8000279e:	f862                	sd	s8,48(sp)
    800027a0:	f466                	sd	s9,40(sp)
    800027a2:	f06a                	sd	s10,32(sp)
    800027a4:	ec6e                	sd	s11,24(sp)
    800027a6:	0100                	addi	s0,sp,128
  struct proc*p;
  for(p=proc;p<&proc[NPROC];p++) {
    800027a8:	0000f497          	auipc	s1,0xf
    800027ac:	f2848493          	addi	s1,s1,-216 # 800116d0 <proc>
  }
	    int etime=p->etime;
	    if(!etime){
		    uint64 xticks;
		    acquire(&tickslock);
		    xticks=ticks;
    800027b0:	00007d17          	auipc	s10,0x7
    800027b4:	880d0d13          	addi	s10,s10,-1920 # 80009030 <ticks>
      switch (n) {
    800027b8:	00006b17          	auipc	s6,0x6
    800027bc:	ba0b0b13          	addi	s6,s6,-1120 # 80008358 <digits+0x318>
      state="ZOMBIE";
    800027c0:	00006d97          	auipc	s11,0x6
    800027c4:	b18d8d93          	addi	s11,s11,-1256 # 800082d8 <digits+0x298>
    800027c8:	a889                	j	8000281a <ps+0x90>
      switch (n) {
    800027ca:	00006c97          	auipc	s9,0x6
    800027ce:	ad6c8c93          	addi	s9,s9,-1322 # 800082a0 <digits+0x260>
	    int etime=p->etime;
    800027d2:	1784b883          	ld	a7,376(s1)
	    if(!etime){
    800027d6:	0008879b          	sext.w	a5,a7
		    release(&tickslock);
		    etime=xticks-p->stime;
	    }
	    else {
		    etime=etime-p->stime;
    800027da:	40e888bb          	subw	a7,a7,a4
	    if(!etime){
    800027de:	cbd5                	beqz	a5,80002892 <ps+0x108>
    	}
	    uint64 sz=p->sz;
	    //release(&p->lock);
	
	    printf("pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%x\n",pid,ppid,state,cmd,ctime,stime,etime,sz);
    800027e0:	64bc                	ld	a5,72(s1)
    800027e2:	e03e                	sd	a5,0(sp)
    800027e4:	8862                	mv	a6,s8
    800027e6:	87de                	mv	a5,s7
    800027e8:	874e                	mv	a4,s3
    800027ea:	86e6                	mv	a3,s9
    800027ec:	8656                	mv	a2,s5
    800027ee:	85d2                	mv	a1,s4
    800027f0:	00006517          	auipc	a0,0x6
    800027f4:	af050513          	addi	a0,a0,-1296 # 800082e0 <digits+0x2a0>
    800027f8:	ffffe097          	auipc	ra,0xffffe
    800027fc:	d8c080e7          	jalr	-628(ra) # 80000584 <printf>
    }
    release(&p->lock);
    80002800:	8526                	mv	a0,s1
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	482080e7          	jalr	1154(ra) # 80000c84 <release>
  for(p=proc;p<&proc[NPROC];p++) {
    8000280a:	18048493          	addi	s1,s1,384
    8000280e:	00015797          	auipc	a5,0x15
    80002812:	ec278793          	addi	a5,a5,-318 # 800176d0 <tickslock>
    80002816:	0af48563          	beq	s1,a5,800028c0 <ps+0x136>
    acquire(&p->lock);
    8000281a:	89a6                	mv	s3,s1
    8000281c:	8526                	mv	a0,s1
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	3b2080e7          	jalr	946(ra) # 80000bd0 <acquire>
    if(p->state!=UNUSED) {
    80002826:	4c9c                	lw	a5,24(s1)
    80002828:	dfe1                	beqz	a5,80002800 <ps+0x76>
      int pid=p->pid;
    8000282a:	0304aa03          	lw	s4,48(s1)
	    if(p->pid!=1)
    8000282e:	4705                	li	a4,1
	    else ppid=-1;
    80002830:	5afd                	li	s5,-1
	    if(p->pid!=1)
    80002832:	00ea0563          	beq	s4,a4,8000283c <ps+0xb2>
	    ppid=p->parent->pid;
    80002836:	7c98                	ld	a4,56(s1)
    80002838:	03072a83          	lw	s5,48(a4)
	    char* cmd=p->name;
    8000283c:	15898993          	addi	s3,s3,344
	    int ctime=p->ctime;
    80002840:	1684ab83          	lw	s7,360(s1)
	    int stime=p->stime;
    80002844:	1704b703          	ld	a4,368(s1)
    80002848:	00070c1b          	sext.w	s8,a4
      switch (n) {
    8000284c:	4695                	li	a3,5
    8000284e:	02f6ed63          	bltu	a3,a5,80002888 <ps+0xfe>
    80002852:	078a                	slli	a5,a5,0x2
    80002854:	97da                	add	a5,a5,s6
    80002856:	439c                	lw	a5,0(a5)
    80002858:	97da                	add	a5,a5,s6
    8000285a:	8782                	jr	a5
      state="USED";
    8000285c:	00006c97          	auipc	s9,0x6
    80002860:	a4cc8c93          	addi	s9,s9,-1460 # 800082a8 <digits+0x268>
      break;
    80002864:	b7bd                	j	800027d2 <ps+0x48>
      state="SLEEPING";
    80002866:	00006c97          	auipc	s9,0x6
    8000286a:	a4ac8c93          	addi	s9,s9,-1462 # 800082b0 <digits+0x270>
      break;
    8000286e:	b795                	j	800027d2 <ps+0x48>
      state="RUNNABLE";
    80002870:	00006c97          	auipc	s9,0x6
    80002874:	a50c8c93          	addi	s9,s9,-1456 # 800082c0 <digits+0x280>
      break;
    80002878:	bfa9                	j	800027d2 <ps+0x48>
      state="RUNNING";
    8000287a:	00006c97          	auipc	s9,0x6
    8000287e:	a56c8c93          	addi	s9,s9,-1450 # 800082d0 <digits+0x290>
      break;
    80002882:	bf81                	j	800027d2 <ps+0x48>
      state="ZOMBIE";
    80002884:	8cee                	mv	s9,s11
      break;
    80002886:	b7b1                	j	800027d2 <ps+0x48>
      char*state="DEFAULT";
    80002888:	00006c97          	auipc	s9,0x6
    8000288c:	a10c8c93          	addi	s9,s9,-1520 # 80008298 <digits+0x258>
    80002890:	b789                	j	800027d2 <ps+0x48>
		    acquire(&tickslock);
    80002892:	00015517          	auipc	a0,0x15
    80002896:	e3e50513          	addi	a0,a0,-450 # 800176d0 <tickslock>
    8000289a:	ffffe097          	auipc	ra,0xffffe
    8000289e:	336080e7          	jalr	822(ra) # 80000bd0 <acquire>
		    xticks=ticks;
    800028a2:	000d2903          	lw	s2,0(s10)
		    release(&tickslock);
    800028a6:	00015517          	auipc	a0,0x15
    800028aa:	e2a50513          	addi	a0,a0,-470 # 800176d0 <tickslock>
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	3d6080e7          	jalr	982(ra) # 80000c84 <release>
		    etime=xticks-p->stime;
    800028b6:	1704b783          	ld	a5,368(s1)
    800028ba:	40f908bb          	subw	a7,s2,a5
    800028be:	b70d                	j	800027e0 <ps+0x56>
  }
  return;
}
    800028c0:	70e6                	ld	ra,120(sp)
    800028c2:	7446                	ld	s0,112(sp)
    800028c4:	74a6                	ld	s1,104(sp)
    800028c6:	7906                	ld	s2,96(sp)
    800028c8:	69e6                	ld	s3,88(sp)
    800028ca:	6a46                	ld	s4,80(sp)
    800028cc:	6aa6                	ld	s5,72(sp)
    800028ce:	6b06                	ld	s6,64(sp)
    800028d0:	7be2                	ld	s7,56(sp)
    800028d2:	7c42                	ld	s8,48(sp)
    800028d4:	7ca2                	ld	s9,40(sp)
    800028d6:	7d02                	ld	s10,32(sp)
    800028d8:	6de2                	ld	s11,24(sp)
    800028da:	6109                	addi	sp,sp,128
    800028dc:	8082                	ret

00000000800028de <pinfo>:
//   release(&np->lock);

//   return pid;
// }

int pinfo (int id,struct procstat*pstat){
    800028de:	7159                	addi	sp,sp,-112
    800028e0:	f486                	sd	ra,104(sp)
    800028e2:	f0a2                	sd	s0,96(sp)
    800028e4:	eca6                	sd	s1,88(sp)
    800028e6:	e8ca                	sd	s2,80(sp)
    800028e8:	e4ce                	sd	s3,72(sp)
    800028ea:	e0d2                	sd	s4,64(sp)
    800028ec:	fc56                	sd	s5,56(sp)
    800028ee:	f85a                	sd	s6,48(sp)
    800028f0:	f45e                	sd	s7,40(sp)
    800028f2:	f062                	sd	s8,32(sp)
    800028f4:	ec66                	sd	s9,24(sp)
    800028f6:	e86a                	sd	s10,16(sp)
    800028f8:	e46e                	sd	s11,8(sp)
    800028fa:	1880                	addi	s0,sp,112
    800028fc:	8a2a                	mv	s4,a0
    800028fe:	892e                	mv	s2,a1
	struct proc*p;
  for(p=proc;p<&proc[NPROC];p++) {
    80002900:	0000f497          	auipc	s1,0xf
    80002904:	dd048493          	addi	s1,s1,-560 # 800116d0 <proc>
      }
	    int etime=p->etime;
	    if(!etime){
		    uint64 xticks;
		    acquire(&tickslock);
		    xticks=ticks;
    80002908:	00006b17          	auipc	s6,0x6
    8000290c:	728b0b13          	addi	s6,s6,1832 # 80009030 <ticks>
      pstat->state="DEFAULT";
    80002910:	00006d97          	auipc	s11,0x6
    80002914:	988d8d93          	addi	s11,s11,-1656 # 80008298 <digits+0x258>
      switch (n) {
    80002918:	00006a97          	auipc	s5,0x6
    8000291c:	a58a8a93          	addi	s5,s5,-1448 # 80008370 <digits+0x330>
      pstat->state="ZOMBIE";
    80002920:	00006d17          	auipc	s10,0x6
    80002924:	9b8d0d13          	addi	s10,s10,-1608 # 800082d8 <digits+0x298>
      pstat->state="RUNNING";
    80002928:	00006c97          	auipc	s9,0x6
    8000292c:	9a8c8c93          	addi	s9,s9,-1624 # 800082d0 <digits+0x290>
      pstat->state="RUNNABLE";
    80002930:	00006c17          	auipc	s8,0x6
    80002934:	990c0c13          	addi	s8,s8,-1648 # 800082c0 <digits+0x280>
      pstat->state="SLEEPING";
    80002938:	00006b97          	auipc	s7,0x6
    8000293c:	978b8b93          	addi	s7,s7,-1672 # 800082b0 <digits+0x270>
    80002940:	a835                	j	8000297c <pinfo+0x9e>
      pstat->state="DEFAULT";
    80002942:	01b93423          	sd	s11,8(s2)
	    int etime=p->etime;
    80002946:	1784b983          	ld	s3,376(s1)
	    if(!etime){
    8000294a:	0009879b          	sext.w	a5,s3
    8000294e:	cbcd                	beqz	a5,80002a00 <pinfo+0x122>
		    release(&tickslock);
		    etime=xticks-p->stime;
	    }
	    else {
		    etime=etime-p->stime;
    80002950:	1704b783          	ld	a5,368(s1)
    80002954:	40f989bb          	subw	s3,s3,a5
    	}
      pstat->etime=etime;
    80002958:	03392023          	sw	s3,32(s2)
	    pstat->size=p->sz;
    8000295c:	64bc                	ld	a5,72(s1)
    8000295e:	02f93423          	sd	a5,40(s2)
	    //release(&p->lock);
	
    }
    release(&p->lock);
    80002962:	8526                	mv	a0,s1
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	320080e7          	jalr	800(ra) # 80000c84 <release>
  for(p=proc;p<&proc[NPROC];p++) {
    8000296c:	18048493          	addi	s1,s1,384
    80002970:	00015797          	auipc	a5,0x15
    80002974:	d6078793          	addi	a5,a5,-672 # 800176d0 <tickslock>
    80002978:	0af48b63          	beq	s1,a5,80002a2e <pinfo+0x150>
    acquire(&p->lock);
    8000297c:	89a6                	mv	s3,s1
    8000297e:	8526                	mv	a0,s1
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	250080e7          	jalr	592(ra) # 80000bd0 <acquire>
    if(p->pid==id) {
    80002988:	589c                	lw	a5,48(s1)
    8000298a:	fd479ce3          	bne	a5,s4,80002962 <pinfo+0x84>
      pstat->pid=p->pid;
    8000298e:	00f92023          	sw	a5,0(s2)
	    int n=p->state;
    80002992:	4c98                	lw	a4,24(s1)
	    if(p->pid!=1)
    80002994:	4605                	li	a2,1
	    else pstat->ppid=-1;
    80002996:	56fd                	li	a3,-1
	    if(p->pid!=1)
    80002998:	00c78463          	beq	a5,a2,800029a0 <pinfo+0xc2>
	    pstat->ppid=p->parent->pid;
    8000299c:	7c9c                	ld	a5,56(s1)
    8000299e:	5b94                	lw	a3,48(a5)
    800029a0:	00d92223          	sw	a3,4(s2)
	    pstat->command=p->name;
    800029a4:	15898993          	addi	s3,s3,344
    800029a8:	01393823          	sd	s3,16(s2)
	    pstat->ctime=p->ctime;
    800029ac:	1684b783          	ld	a5,360(s1)
    800029b0:	00f92c23          	sw	a5,24(s2)
	    pstat->stime=p->stime;
    800029b4:	1704b783          	ld	a5,368(s1)
    800029b8:	00f92e23          	sw	a5,28(s2)
      switch (n) {
    800029bc:	4795                	li	a5,5
    800029be:	f8e7e2e3          	bltu	a5,a4,80002942 <pinfo+0x64>
    800029c2:	070a                	slli	a4,a4,0x2
    800029c4:	9756                	add	a4,a4,s5
    800029c6:	431c                	lw	a5,0(a4)
    800029c8:	97d6                	add	a5,a5,s5
    800029ca:	8782                	jr	a5
      pstat->state="UNUSED";
    800029cc:	00006797          	auipc	a5,0x6
    800029d0:	8d478793          	addi	a5,a5,-1836 # 800082a0 <digits+0x260>
    800029d4:	00f93423          	sd	a5,8(s2)
      break;
    800029d8:	b7bd                	j	80002946 <pinfo+0x68>
      pstat->state="USED";
    800029da:	00006797          	auipc	a5,0x6
    800029de:	8ce78793          	addi	a5,a5,-1842 # 800082a8 <digits+0x268>
    800029e2:	00f93423          	sd	a5,8(s2)
      break;
    800029e6:	b785                	j	80002946 <pinfo+0x68>
      pstat->state="SLEEPING";
    800029e8:	01793423          	sd	s7,8(s2)
      break;
    800029ec:	bfa9                	j	80002946 <pinfo+0x68>
      pstat->state="RUNNABLE";
    800029ee:	01893423          	sd	s8,8(s2)
      break;
    800029f2:	bf91                	j	80002946 <pinfo+0x68>
      pstat->state="RUNNING";
    800029f4:	01993423          	sd	s9,8(s2)
      break;
    800029f8:	b7b9                	j	80002946 <pinfo+0x68>
      pstat->state="ZOMBIE";
    800029fa:	01a93423          	sd	s10,8(s2)
      break;
    800029fe:	b7a1                	j	80002946 <pinfo+0x68>
		    acquire(&tickslock);
    80002a00:	00015517          	auipc	a0,0x15
    80002a04:	cd050513          	addi	a0,a0,-816 # 800176d0 <tickslock>
    80002a08:	ffffe097          	auipc	ra,0xffffe
    80002a0c:	1c8080e7          	jalr	456(ra) # 80000bd0 <acquire>
		    xticks=ticks;
    80002a10:	000b2983          	lw	s3,0(s6)
		    release(&tickslock);
    80002a14:	00015517          	auipc	a0,0x15
    80002a18:	cbc50513          	addi	a0,a0,-836 # 800176d0 <tickslock>
    80002a1c:	ffffe097          	auipc	ra,0xffffe
    80002a20:	268080e7          	jalr	616(ra) # 80000c84 <release>
		    etime=xticks-p->stime;
    80002a24:	1704b783          	ld	a5,368(s1)
    80002a28:	40f989bb          	subw	s3,s3,a5
    80002a2c:	b735                	j	80002958 <pinfo+0x7a>
  }
  return 0;
}
    80002a2e:	4501                	li	a0,0
    80002a30:	70a6                	ld	ra,104(sp)
    80002a32:	7406                	ld	s0,96(sp)
    80002a34:	64e6                	ld	s1,88(sp)
    80002a36:	6946                	ld	s2,80(sp)
    80002a38:	69a6                	ld	s3,72(sp)
    80002a3a:	6a06                	ld	s4,64(sp)
    80002a3c:	7ae2                	ld	s5,56(sp)
    80002a3e:	7b42                	ld	s6,48(sp)
    80002a40:	7ba2                	ld	s7,40(sp)
    80002a42:	7c02                	ld	s8,32(sp)
    80002a44:	6ce2                	ld	s9,24(sp)
    80002a46:	6d42                	ld	s10,16(sp)
    80002a48:	6da2                	ld	s11,8(sp)
    80002a4a:	6165                	addi	sp,sp,112
    80002a4c:	8082                	ret

0000000080002a4e <swtch>:
    80002a4e:	00153023          	sd	ra,0(a0)
    80002a52:	00253423          	sd	sp,8(a0)
    80002a56:	e900                	sd	s0,16(a0)
    80002a58:	ed04                	sd	s1,24(a0)
    80002a5a:	03253023          	sd	s2,32(a0)
    80002a5e:	03353423          	sd	s3,40(a0)
    80002a62:	03453823          	sd	s4,48(a0)
    80002a66:	03553c23          	sd	s5,56(a0)
    80002a6a:	05653023          	sd	s6,64(a0)
    80002a6e:	05753423          	sd	s7,72(a0)
    80002a72:	05853823          	sd	s8,80(a0)
    80002a76:	05953c23          	sd	s9,88(a0)
    80002a7a:	07a53023          	sd	s10,96(a0)
    80002a7e:	07b53423          	sd	s11,104(a0)
    80002a82:	0005b083          	ld	ra,0(a1)
    80002a86:	0085b103          	ld	sp,8(a1)
    80002a8a:	6980                	ld	s0,16(a1)
    80002a8c:	6d84                	ld	s1,24(a1)
    80002a8e:	0205b903          	ld	s2,32(a1)
    80002a92:	0285b983          	ld	s3,40(a1)
    80002a96:	0305ba03          	ld	s4,48(a1)
    80002a9a:	0385ba83          	ld	s5,56(a1)
    80002a9e:	0405bb03          	ld	s6,64(a1)
    80002aa2:	0485bb83          	ld	s7,72(a1)
    80002aa6:	0505bc03          	ld	s8,80(a1)
    80002aaa:	0585bc83          	ld	s9,88(a1)
    80002aae:	0605bd03          	ld	s10,96(a1)
    80002ab2:	0685bd83          	ld	s11,104(a1)
    80002ab6:	8082                	ret

0000000080002ab8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002ab8:	1141                	addi	sp,sp,-16
    80002aba:	e406                	sd	ra,8(sp)
    80002abc:	e022                	sd	s0,0(sp)
    80002abe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002ac0:	00006597          	auipc	a1,0x6
    80002ac4:	8f858593          	addi	a1,a1,-1800 # 800083b8 <states.0+0x30>
    80002ac8:	00015517          	auipc	a0,0x15
    80002acc:	c0850513          	addi	a0,a0,-1016 # 800176d0 <tickslock>
    80002ad0:	ffffe097          	auipc	ra,0xffffe
    80002ad4:	070080e7          	jalr	112(ra) # 80000b40 <initlock>
}
    80002ad8:	60a2                	ld	ra,8(sp)
    80002ada:	6402                	ld	s0,0(sp)
    80002adc:	0141                	addi	sp,sp,16
    80002ade:	8082                	ret

0000000080002ae0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002ae0:	1141                	addi	sp,sp,-16
    80002ae2:	e422                	sd	s0,8(sp)
    80002ae4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ae6:	00003797          	auipc	a5,0x3
    80002aea:	5da78793          	addi	a5,a5,1498 # 800060c0 <kernelvec>
    80002aee:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002af2:	6422                	ld	s0,8(sp)
    80002af4:	0141                	addi	sp,sp,16
    80002af6:	8082                	ret

0000000080002af8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002af8:	1141                	addi	sp,sp,-16
    80002afa:	e406                	sd	ra,8(sp)
    80002afc:	e022                	sd	s0,0(sp)
    80002afe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	e96080e7          	jalr	-362(ra) # 80001996 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b0c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b0e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002b12:	00004697          	auipc	a3,0x4
    80002b16:	4ee68693          	addi	a3,a3,1262 # 80007000 <_trampoline>
    80002b1a:	00004717          	auipc	a4,0x4
    80002b1e:	4e670713          	addi	a4,a4,1254 # 80007000 <_trampoline>
    80002b22:	8f15                	sub	a4,a4,a3
    80002b24:	040007b7          	lui	a5,0x4000
    80002b28:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b2a:	07b2                	slli	a5,a5,0xc
    80002b2c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b2e:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b32:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002b34:	18002673          	csrr	a2,satp
    80002b38:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b3a:	6d30                	ld	a2,88(a0)
    80002b3c:	6138                	ld	a4,64(a0)
    80002b3e:	6585                	lui	a1,0x1
    80002b40:	972e                	add	a4,a4,a1
    80002b42:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b44:	6d38                	ld	a4,88(a0)
    80002b46:	00000617          	auipc	a2,0x0
    80002b4a:	13860613          	addi	a2,a2,312 # 80002c7e <usertrap>
    80002b4e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002b50:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002b52:	8612                	mv	a2,tp
    80002b54:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b56:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b5a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b5e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b62:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b66:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b68:	6f18                	ld	a4,24(a4)
    80002b6a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b6e:	692c                	ld	a1,80(a0)
    80002b70:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002b72:	00004717          	auipc	a4,0x4
    80002b76:	51e70713          	addi	a4,a4,1310 # 80007090 <userret>
    80002b7a:	8f15                	sub	a4,a4,a3
    80002b7c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002b7e:	577d                	li	a4,-1
    80002b80:	177e                	slli	a4,a4,0x3f
    80002b82:	8dd9                	or	a1,a1,a4
    80002b84:	02000537          	lui	a0,0x2000
    80002b88:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80002b8a:	0536                	slli	a0,a0,0xd
    80002b8c:	9782                	jalr	a5
}
    80002b8e:	60a2                	ld	ra,8(sp)
    80002b90:	6402                	ld	s0,0(sp)
    80002b92:	0141                	addi	sp,sp,16
    80002b94:	8082                	ret

0000000080002b96 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b96:	1101                	addi	sp,sp,-32
    80002b98:	ec06                	sd	ra,24(sp)
    80002b9a:	e822                	sd	s0,16(sp)
    80002b9c:	e426                	sd	s1,8(sp)
    80002b9e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002ba0:	00015497          	auipc	s1,0x15
    80002ba4:	b3048493          	addi	s1,s1,-1232 # 800176d0 <tickslock>
    80002ba8:	8526                	mv	a0,s1
    80002baa:	ffffe097          	auipc	ra,0xffffe
    80002bae:	026080e7          	jalr	38(ra) # 80000bd0 <acquire>
  ticks++;
    80002bb2:	00006517          	auipc	a0,0x6
    80002bb6:	47e50513          	addi	a0,a0,1150 # 80009030 <ticks>
    80002bba:	411c                	lw	a5,0(a0)
    80002bbc:	2785                	addiw	a5,a5,1
    80002bbe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002bc0:	fffff097          	auipc	ra,0xfffff
    80002bc4:	69c080e7          	jalr	1692(ra) # 8000225c <wakeup>
  release(&tickslock);
    80002bc8:	8526                	mv	a0,s1
    80002bca:	ffffe097          	auipc	ra,0xffffe
    80002bce:	0ba080e7          	jalr	186(ra) # 80000c84 <release>
}
    80002bd2:	60e2                	ld	ra,24(sp)
    80002bd4:	6442                	ld	s0,16(sp)
    80002bd6:	64a2                	ld	s1,8(sp)
    80002bd8:	6105                	addi	sp,sp,32
    80002bda:	8082                	ret

0000000080002bdc <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002bdc:	1101                	addi	sp,sp,-32
    80002bde:	ec06                	sd	ra,24(sp)
    80002be0:	e822                	sd	s0,16(sp)
    80002be2:	e426                	sd	s1,8(sp)
    80002be4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002be6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002bea:	00074d63          	bltz	a4,80002c04 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002bee:	57fd                	li	a5,-1
    80002bf0:	17fe                	slli	a5,a5,0x3f
    80002bf2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002bf4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002bf6:	06f70363          	beq	a4,a5,80002c5c <devintr+0x80>
  }
}
    80002bfa:	60e2                	ld	ra,24(sp)
    80002bfc:	6442                	ld	s0,16(sp)
    80002bfe:	64a2                	ld	s1,8(sp)
    80002c00:	6105                	addi	sp,sp,32
    80002c02:	8082                	ret
     (scause & 0xff) == 9){
    80002c04:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80002c08:	46a5                	li	a3,9
    80002c0a:	fed792e3          	bne	a5,a3,80002bee <devintr+0x12>
    int irq = plic_claim();
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	5ba080e7          	jalr	1466(ra) # 800061c8 <plic_claim>
    80002c16:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c18:	47a9                	li	a5,10
    80002c1a:	02f50763          	beq	a0,a5,80002c48 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002c1e:	4785                	li	a5,1
    80002c20:	02f50963          	beq	a0,a5,80002c52 <devintr+0x76>
    return 1;
    80002c24:	4505                	li	a0,1
    } else if(irq){
    80002c26:	d8f1                	beqz	s1,80002bfa <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c28:	85a6                	mv	a1,s1
    80002c2a:	00005517          	auipc	a0,0x5
    80002c2e:	79650513          	addi	a0,a0,1942 # 800083c0 <states.0+0x38>
    80002c32:	ffffe097          	auipc	ra,0xffffe
    80002c36:	952080e7          	jalr	-1710(ra) # 80000584 <printf>
      plic_complete(irq);
    80002c3a:	8526                	mv	a0,s1
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	5b0080e7          	jalr	1456(ra) # 800061ec <plic_complete>
    return 1;
    80002c44:	4505                	li	a0,1
    80002c46:	bf55                	j	80002bfa <devintr+0x1e>
      uartintr();
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	d4a080e7          	jalr	-694(ra) # 80000992 <uartintr>
    80002c50:	b7ed                	j	80002c3a <devintr+0x5e>
      virtio_disk_intr();
    80002c52:	00004097          	auipc	ra,0x4
    80002c56:	a26080e7          	jalr	-1498(ra) # 80006678 <virtio_disk_intr>
    80002c5a:	b7c5                	j	80002c3a <devintr+0x5e>
    if(cpuid() == 0){
    80002c5c:	fffff097          	auipc	ra,0xfffff
    80002c60:	d0e080e7          	jalr	-754(ra) # 8000196a <cpuid>
    80002c64:	c901                	beqz	a0,80002c74 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002c66:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c6a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002c6c:	14479073          	csrw	sip,a5
    return 2;
    80002c70:	4509                	li	a0,2
    80002c72:	b761                	j	80002bfa <devintr+0x1e>
      clockintr();
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	f22080e7          	jalr	-222(ra) # 80002b96 <clockintr>
    80002c7c:	b7ed                	j	80002c66 <devintr+0x8a>

0000000080002c7e <usertrap>:
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	e04a                	sd	s2,0(sp)
    80002c88:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c8a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c8e:	1007f793          	andi	a5,a5,256
    80002c92:	e3ad                	bnez	a5,80002cf4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c94:	00003797          	auipc	a5,0x3
    80002c98:	42c78793          	addi	a5,a5,1068 # 800060c0 <kernelvec>
    80002c9c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002ca0:	fffff097          	auipc	ra,0xfffff
    80002ca4:	cf6080e7          	jalr	-778(ra) # 80001996 <myproc>
    80002ca8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002caa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cac:	14102773          	csrr	a4,sepc
    80002cb0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cb2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002cb6:	47a1                	li	a5,8
    80002cb8:	04f71c63          	bne	a4,a5,80002d10 <usertrap+0x92>
    if(p->killed)
    80002cbc:	551c                	lw	a5,40(a0)
    80002cbe:	e3b9                	bnez	a5,80002d04 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002cc0:	6cb8                	ld	a4,88(s1)
    80002cc2:	6f1c                	ld	a5,24(a4)
    80002cc4:	0791                	addi	a5,a5,4
    80002cc6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ccc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cd0:	10079073          	csrw	sstatus,a5
    syscall();
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	2e0080e7          	jalr	736(ra) # 80002fb4 <syscall>
  if(p->killed)
    80002cdc:	549c                	lw	a5,40(s1)
    80002cde:	ebc1                	bnez	a5,80002d6e <usertrap+0xf0>
  usertrapret();
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	e18080e7          	jalr	-488(ra) # 80002af8 <usertrapret>
}
    80002ce8:	60e2                	ld	ra,24(sp)
    80002cea:	6442                	ld	s0,16(sp)
    80002cec:	64a2                	ld	s1,8(sp)
    80002cee:	6902                	ld	s2,0(sp)
    80002cf0:	6105                	addi	sp,sp,32
    80002cf2:	8082                	ret
    panic("usertrap: not from user mode");
    80002cf4:	00005517          	auipc	a0,0x5
    80002cf8:	6ec50513          	addi	a0,a0,1772 # 800083e0 <states.0+0x58>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	83e080e7          	jalr	-1986(ra) # 8000053a <panic>
      exit(-1);
    80002d04:	557d                	li	a0,-1
    80002d06:	fffff097          	auipc	ra,0xfffff
    80002d0a:	626080e7          	jalr	1574(ra) # 8000232c <exit>
    80002d0e:	bf4d                	j	80002cc0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	ecc080e7          	jalr	-308(ra) # 80002bdc <devintr>
    80002d18:	892a                	mv	s2,a0
    80002d1a:	c501                	beqz	a0,80002d22 <usertrap+0xa4>
  if(p->killed)
    80002d1c:	549c                	lw	a5,40(s1)
    80002d1e:	c3a1                	beqz	a5,80002d5e <usertrap+0xe0>
    80002d20:	a815                	j	80002d54 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d22:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002d26:	5890                	lw	a2,48(s1)
    80002d28:	00005517          	auipc	a0,0x5
    80002d2c:	6d850513          	addi	a0,a0,1752 # 80008400 <states.0+0x78>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	854080e7          	jalr	-1964(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d38:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d3c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d40:	00005517          	auipc	a0,0x5
    80002d44:	6f050513          	addi	a0,a0,1776 # 80008430 <states.0+0xa8>
    80002d48:	ffffe097          	auipc	ra,0xffffe
    80002d4c:	83c080e7          	jalr	-1988(ra) # 80000584 <printf>
    p->killed = 1;
    80002d50:	4785                	li	a5,1
    80002d52:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002d54:	557d                	li	a0,-1
    80002d56:	fffff097          	auipc	ra,0xfffff
    80002d5a:	5d6080e7          	jalr	1494(ra) # 8000232c <exit>
  if(which_dev == 2)
    80002d5e:	4789                	li	a5,2
    80002d60:	f8f910e3          	bne	s2,a5,80002ce0 <usertrap+0x62>
    yield();
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	330080e7          	jalr	816(ra) # 80002094 <yield>
    80002d6c:	bf95                	j	80002ce0 <usertrap+0x62>
  int which_dev = 0;
    80002d6e:	4901                	li	s2,0
    80002d70:	b7d5                	j	80002d54 <usertrap+0xd6>

0000000080002d72 <kerneltrap>:
{
    80002d72:	7179                	addi	sp,sp,-48
    80002d74:	f406                	sd	ra,40(sp)
    80002d76:	f022                	sd	s0,32(sp)
    80002d78:	ec26                	sd	s1,24(sp)
    80002d7a:	e84a                	sd	s2,16(sp)
    80002d7c:	e44e                	sd	s3,8(sp)
    80002d7e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d80:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d84:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d88:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d8c:	1004f793          	andi	a5,s1,256
    80002d90:	cb85                	beqz	a5,80002dc0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d92:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d96:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d98:	ef85                	bnez	a5,80002dd0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d9a:	00000097          	auipc	ra,0x0
    80002d9e:	e42080e7          	jalr	-446(ra) # 80002bdc <devintr>
    80002da2:	cd1d                	beqz	a0,80002de0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002da4:	4789                	li	a5,2
    80002da6:	06f50a63          	beq	a0,a5,80002e1a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002daa:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dae:	10049073          	csrw	sstatus,s1
}
    80002db2:	70a2                	ld	ra,40(sp)
    80002db4:	7402                	ld	s0,32(sp)
    80002db6:	64e2                	ld	s1,24(sp)
    80002db8:	6942                	ld	s2,16(sp)
    80002dba:	69a2                	ld	s3,8(sp)
    80002dbc:	6145                	addi	sp,sp,48
    80002dbe:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002dc0:	00005517          	auipc	a0,0x5
    80002dc4:	69050513          	addi	a0,a0,1680 # 80008450 <states.0+0xc8>
    80002dc8:	ffffd097          	auipc	ra,0xffffd
    80002dcc:	772080e7          	jalr	1906(ra) # 8000053a <panic>
    panic("kerneltrap: interrupts enabled");
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	6a850513          	addi	a0,a0,1704 # 80008478 <states.0+0xf0>
    80002dd8:	ffffd097          	auipc	ra,0xffffd
    80002ddc:	762080e7          	jalr	1890(ra) # 8000053a <panic>
    printf("scause %p\n", scause);
    80002de0:	85ce                	mv	a1,s3
    80002de2:	00005517          	auipc	a0,0x5
    80002de6:	6b650513          	addi	a0,a0,1718 # 80008498 <states.0+0x110>
    80002dea:	ffffd097          	auipc	ra,0xffffd
    80002dee:	79a080e7          	jalr	1946(ra) # 80000584 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002df2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002df6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dfa:	00005517          	auipc	a0,0x5
    80002dfe:	6ae50513          	addi	a0,a0,1710 # 800084a8 <states.0+0x120>
    80002e02:	ffffd097          	auipc	ra,0xffffd
    80002e06:	782080e7          	jalr	1922(ra) # 80000584 <printf>
    panic("kerneltrap");
    80002e0a:	00005517          	auipc	a0,0x5
    80002e0e:	6b650513          	addi	a0,a0,1718 # 800084c0 <states.0+0x138>
    80002e12:	ffffd097          	auipc	ra,0xffffd
    80002e16:	728080e7          	jalr	1832(ra) # 8000053a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e1a:	fffff097          	auipc	ra,0xfffff
    80002e1e:	b7c080e7          	jalr	-1156(ra) # 80001996 <myproc>
    80002e22:	d541                	beqz	a0,80002daa <kerneltrap+0x38>
    80002e24:	fffff097          	auipc	ra,0xfffff
    80002e28:	b72080e7          	jalr	-1166(ra) # 80001996 <myproc>
    80002e2c:	4d18                	lw	a4,24(a0)
    80002e2e:	4791                	li	a5,4
    80002e30:	f6f71de3          	bne	a4,a5,80002daa <kerneltrap+0x38>
    yield();
    80002e34:	fffff097          	auipc	ra,0xfffff
    80002e38:	260080e7          	jalr	608(ra) # 80002094 <yield>
    80002e3c:	b7bd                	j	80002daa <kerneltrap+0x38>

0000000080002e3e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e3e:	1101                	addi	sp,sp,-32
    80002e40:	ec06                	sd	ra,24(sp)
    80002e42:	e822                	sd	s0,16(sp)
    80002e44:	e426                	sd	s1,8(sp)
    80002e46:	1000                	addi	s0,sp,32
    80002e48:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	b4c080e7          	jalr	-1204(ra) # 80001996 <myproc>
  switch (n) {
    80002e52:	4795                	li	a5,5
    80002e54:	0497e163          	bltu	a5,s1,80002e96 <argraw+0x58>
    80002e58:	048a                	slli	s1,s1,0x2
    80002e5a:	00005717          	auipc	a4,0x5
    80002e5e:	69e70713          	addi	a4,a4,1694 # 800084f8 <states.0+0x170>
    80002e62:	94ba                	add	s1,s1,a4
    80002e64:	409c                	lw	a5,0(s1)
    80002e66:	97ba                	add	a5,a5,a4
    80002e68:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e6a:	6d3c                	ld	a5,88(a0)
    80002e6c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret
    return p->trapframe->a1;
    80002e78:	6d3c                	ld	a5,88(a0)
    80002e7a:	7fa8                	ld	a0,120(a5)
    80002e7c:	bfcd                	j	80002e6e <argraw+0x30>
    return p->trapframe->a2;
    80002e7e:	6d3c                	ld	a5,88(a0)
    80002e80:	63c8                	ld	a0,128(a5)
    80002e82:	b7f5                	j	80002e6e <argraw+0x30>
    return p->trapframe->a3;
    80002e84:	6d3c                	ld	a5,88(a0)
    80002e86:	67c8                	ld	a0,136(a5)
    80002e88:	b7dd                	j	80002e6e <argraw+0x30>
    return p->trapframe->a4;
    80002e8a:	6d3c                	ld	a5,88(a0)
    80002e8c:	6bc8                	ld	a0,144(a5)
    80002e8e:	b7c5                	j	80002e6e <argraw+0x30>
    return p->trapframe->a5;
    80002e90:	6d3c                	ld	a5,88(a0)
    80002e92:	6fc8                	ld	a0,152(a5)
    80002e94:	bfe9                	j	80002e6e <argraw+0x30>
  panic("argraw");
    80002e96:	00005517          	auipc	a0,0x5
    80002e9a:	63a50513          	addi	a0,a0,1594 # 800084d0 <states.0+0x148>
    80002e9e:	ffffd097          	auipc	ra,0xffffd
    80002ea2:	69c080e7          	jalr	1692(ra) # 8000053a <panic>

0000000080002ea6 <fetchaddr>:
{
    80002ea6:	1101                	addi	sp,sp,-32
    80002ea8:	ec06                	sd	ra,24(sp)
    80002eaa:	e822                	sd	s0,16(sp)
    80002eac:	e426                	sd	s1,8(sp)
    80002eae:	e04a                	sd	s2,0(sp)
    80002eb0:	1000                	addi	s0,sp,32
    80002eb2:	84aa                	mv	s1,a0
    80002eb4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	ae0080e7          	jalr	-1312(ra) # 80001996 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002ebe:	653c                	ld	a5,72(a0)
    80002ec0:	02f4f863          	bgeu	s1,a5,80002ef0 <fetchaddr+0x4a>
    80002ec4:	00848713          	addi	a4,s1,8
    80002ec8:	02e7e663          	bltu	a5,a4,80002ef4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ecc:	46a1                	li	a3,8
    80002ece:	8626                	mv	a2,s1
    80002ed0:	85ca                	mv	a1,s2
    80002ed2:	6928                	ld	a0,80(a0)
    80002ed4:	fffff097          	auipc	ra,0xfffff
    80002ed8:	812080e7          	jalr	-2030(ra) # 800016e6 <copyin>
    80002edc:	00a03533          	snez	a0,a0
    80002ee0:	40a00533          	neg	a0,a0
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6902                	ld	s2,0(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret
    return -1;
    80002ef0:	557d                	li	a0,-1
    80002ef2:	bfcd                	j	80002ee4 <fetchaddr+0x3e>
    80002ef4:	557d                	li	a0,-1
    80002ef6:	b7fd                	j	80002ee4 <fetchaddr+0x3e>

0000000080002ef8 <fetchstr>:
{
    80002ef8:	7179                	addi	sp,sp,-48
    80002efa:	f406                	sd	ra,40(sp)
    80002efc:	f022                	sd	s0,32(sp)
    80002efe:	ec26                	sd	s1,24(sp)
    80002f00:	e84a                	sd	s2,16(sp)
    80002f02:	e44e                	sd	s3,8(sp)
    80002f04:	1800                	addi	s0,sp,48
    80002f06:	892a                	mv	s2,a0
    80002f08:	84ae                	mv	s1,a1
    80002f0a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	a8a080e7          	jalr	-1398(ra) # 80001996 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002f14:	86ce                	mv	a3,s3
    80002f16:	864a                	mv	a2,s2
    80002f18:	85a6                	mv	a1,s1
    80002f1a:	6928                	ld	a0,80(a0)
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	858080e7          	jalr	-1960(ra) # 80001774 <copyinstr>
  if(err < 0)
    80002f24:	00054763          	bltz	a0,80002f32 <fetchstr+0x3a>
  return strlen(buf);
    80002f28:	8526                	mv	a0,s1
    80002f2a:	ffffe097          	auipc	ra,0xffffe
    80002f2e:	f1e080e7          	jalr	-226(ra) # 80000e48 <strlen>
}
    80002f32:	70a2                	ld	ra,40(sp)
    80002f34:	7402                	ld	s0,32(sp)
    80002f36:	64e2                	ld	s1,24(sp)
    80002f38:	6942                	ld	s2,16(sp)
    80002f3a:	69a2                	ld	s3,8(sp)
    80002f3c:	6145                	addi	sp,sp,48
    80002f3e:	8082                	ret

0000000080002f40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002f40:	1101                	addi	sp,sp,-32
    80002f42:	ec06                	sd	ra,24(sp)
    80002f44:	e822                	sd	s0,16(sp)
    80002f46:	e426                	sd	s1,8(sp)
    80002f48:	1000                	addi	s0,sp,32
    80002f4a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f4c:	00000097          	auipc	ra,0x0
    80002f50:	ef2080e7          	jalr	-270(ra) # 80002e3e <argraw>
    80002f54:	c088                	sw	a0,0(s1)
  return 0;
}
    80002f56:	4501                	li	a0,0
    80002f58:	60e2                	ld	ra,24(sp)
    80002f5a:	6442                	ld	s0,16(sp)
    80002f5c:	64a2                	ld	s1,8(sp)
    80002f5e:	6105                	addi	sp,sp,32
    80002f60:	8082                	ret

0000000080002f62 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002f62:	1101                	addi	sp,sp,-32
    80002f64:	ec06                	sd	ra,24(sp)
    80002f66:	e822                	sd	s0,16(sp)
    80002f68:	e426                	sd	s1,8(sp)
    80002f6a:	1000                	addi	s0,sp,32
    80002f6c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	ed0080e7          	jalr	-304(ra) # 80002e3e <argraw>
    80002f76:	e088                	sd	a0,0(s1)
  return 0;
}
    80002f78:	4501                	li	a0,0
    80002f7a:	60e2                	ld	ra,24(sp)
    80002f7c:	6442                	ld	s0,16(sp)
    80002f7e:	64a2                	ld	s1,8(sp)
    80002f80:	6105                	addi	sp,sp,32
    80002f82:	8082                	ret

0000000080002f84 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f84:	1101                	addi	sp,sp,-32
    80002f86:	ec06                	sd	ra,24(sp)
    80002f88:	e822                	sd	s0,16(sp)
    80002f8a:	e426                	sd	s1,8(sp)
    80002f8c:	e04a                	sd	s2,0(sp)
    80002f8e:	1000                	addi	s0,sp,32
    80002f90:	84ae                	mv	s1,a1
    80002f92:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	eaa080e7          	jalr	-342(ra) # 80002e3e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002f9c:	864a                	mv	a2,s2
    80002f9e:	85a6                	mv	a1,s1
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	f58080e7          	jalr	-168(ra) # 80002ef8 <fetchstr>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	64a2                	ld	s1,8(sp)
    80002fae:	6902                	ld	s2,0(sp)
    80002fb0:	6105                	addi	sp,sp,32
    80002fb2:	8082                	ret

0000000080002fb4 <syscall>:
[SYS_pinfo]   sys_pinfo,
};

void
syscall(void)
{
    80002fb4:	1101                	addi	sp,sp,-32
    80002fb6:	ec06                	sd	ra,24(sp)
    80002fb8:	e822                	sd	s0,16(sp)
    80002fba:	e426                	sd	s1,8(sp)
    80002fbc:	e04a                	sd	s2,0(sp)
    80002fbe:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	9d6080e7          	jalr	-1578(ra) # 80001996 <myproc>
    80002fc8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002fca:	05853903          	ld	s2,88(a0)
    80002fce:	0a893783          	ld	a5,168(s2)
    80002fd2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fd6:	37fd                	addiw	a5,a5,-1
    80002fd8:	4769                	li	a4,26
    80002fda:	00f76f63          	bltu	a4,a5,80002ff8 <syscall+0x44>
    80002fde:	00369713          	slli	a4,a3,0x3
    80002fe2:	00005797          	auipc	a5,0x5
    80002fe6:	52e78793          	addi	a5,a5,1326 # 80008510 <syscalls>
    80002fea:	97ba                	add	a5,a5,a4
    80002fec:	639c                	ld	a5,0(a5)
    80002fee:	c789                	beqz	a5,80002ff8 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002ff0:	9782                	jalr	a5
    80002ff2:	06a93823          	sd	a0,112(s2)
    80002ff6:	a839                	j	80003014 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ff8:	15848613          	addi	a2,s1,344
    80002ffc:	588c                	lw	a1,48(s1)
    80002ffe:	00005517          	auipc	a0,0x5
    80003002:	4da50513          	addi	a0,a0,1242 # 800084d8 <states.0+0x150>
    80003006:	ffffd097          	auipc	ra,0xffffd
    8000300a:	57e080e7          	jalr	1406(ra) # 80000584 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000300e:	6cbc                	ld	a5,88(s1)
    80003010:	577d                	li	a4,-1
    80003012:	fbb8                	sd	a4,112(a5)
  }
}
    80003014:	60e2                	ld	ra,24(sp)
    80003016:	6442                	ld	s0,16(sp)
    80003018:	64a2                	ld	s1,8(sp)
    8000301a:	6902                	ld	s2,0(sp)
    8000301c:	6105                	addi	sp,sp,32
    8000301e:	8082                	ret

0000000080003020 <sys_exit>:
#include "proc.h"
#include "procstat.h"

uint64
sys_exit(void)
{
    80003020:	1101                	addi	sp,sp,-32
    80003022:	ec06                	sd	ra,24(sp)
    80003024:	e822                	sd	s0,16(sp)
    80003026:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80003028:	fec40593          	addi	a1,s0,-20
    8000302c:	4501                	li	a0,0
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	f12080e7          	jalr	-238(ra) # 80002f40 <argint>
    return -1;
    80003036:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003038:	00054963          	bltz	a0,8000304a <sys_exit+0x2a>
  exit(n);
    8000303c:	fec42503          	lw	a0,-20(s0)
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	2ec080e7          	jalr	748(ra) # 8000232c <exit>
  return 0;  // not reached
    80003048:	4781                	li	a5,0
}
    8000304a:	853e                	mv	a0,a5
    8000304c:	60e2                	ld	ra,24(sp)
    8000304e:	6442                	ld	s0,16(sp)
    80003050:	6105                	addi	sp,sp,32
    80003052:	8082                	ret

0000000080003054 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003054:	1141                	addi	sp,sp,-16
    80003056:	e406                	sd	ra,8(sp)
    80003058:	e022                	sd	s0,0(sp)
    8000305a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	93a080e7          	jalr	-1734(ra) # 80001996 <myproc>
}
    80003064:	5908                	lw	a0,48(a0)
    80003066:	60a2                	ld	ra,8(sp)
    80003068:	6402                	ld	s0,0(sp)
    8000306a:	0141                	addi	sp,sp,16
    8000306c:	8082                	ret

000000008000306e <sys_fork>:

uint64
sys_fork(void)
{
    8000306e:	1141                	addi	sp,sp,-16
    80003070:	e406                	sd	ra,8(sp)
    80003072:	e022                	sd	s0,0(sp)
    80003074:	0800                	addi	s0,sp,16
  return fork();
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	d30080e7          	jalr	-720(ra) # 80001da6 <fork>
}
    8000307e:	60a2                	ld	ra,8(sp)
    80003080:	6402                	ld	s0,0(sp)
    80003082:	0141                	addi	sp,sp,16
    80003084:	8082                	ret

0000000080003086 <sys_wait>:

uint64
sys_wait(void)
{
    80003086:	1101                	addi	sp,sp,-32
    80003088:	ec06                	sd	ra,24(sp)
    8000308a:	e822                	sd	s0,16(sp)
    8000308c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000308e:	fe840593          	addi	a1,s0,-24
    80003092:	4501                	li	a0,0
    80003094:	00000097          	auipc	ra,0x0
    80003098:	ece080e7          	jalr	-306(ra) # 80002f62 <argaddr>
    8000309c:	87aa                	mv	a5,a0
    return -1;
    8000309e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800030a0:	0007c863          	bltz	a5,800030b0 <sys_wait+0x2a>
  return wait(p);
    800030a4:	fe843503          	ld	a0,-24(s0)
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	08c080e7          	jalr	140(ra) # 80002134 <wait>
}
    800030b0:	60e2                	ld	ra,24(sp)
    800030b2:	6442                	ld	s0,16(sp)
    800030b4:	6105                	addi	sp,sp,32
    800030b6:	8082                	ret

00000000800030b8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030b8:	7179                	addi	sp,sp,-48
    800030ba:	f406                	sd	ra,40(sp)
    800030bc:	f022                	sd	s0,32(sp)
    800030be:	ec26                	sd	s1,24(sp)
    800030c0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800030c2:	fdc40593          	addi	a1,s0,-36
    800030c6:	4501                	li	a0,0
    800030c8:	00000097          	auipc	ra,0x0
    800030cc:	e78080e7          	jalr	-392(ra) # 80002f40 <argint>
    800030d0:	87aa                	mv	a5,a0
    return -1;
    800030d2:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800030d4:	0207c063          	bltz	a5,800030f4 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800030d8:	fffff097          	auipc	ra,0xfffff
    800030dc:	8be080e7          	jalr	-1858(ra) # 80001996 <myproc>
    800030e0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800030e2:	fdc42503          	lw	a0,-36(s0)
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	c48080e7          	jalr	-952(ra) # 80001d2e <growproc>
    800030ee:	00054863          	bltz	a0,800030fe <sys_sbrk+0x46>
    return -1;
  return addr;
    800030f2:	8526                	mv	a0,s1
}
    800030f4:	70a2                	ld	ra,40(sp)
    800030f6:	7402                	ld	s0,32(sp)
    800030f8:	64e2                	ld	s1,24(sp)
    800030fa:	6145                	addi	sp,sp,48
    800030fc:	8082                	ret
    return -1;
    800030fe:	557d                	li	a0,-1
    80003100:	bfd5                	j	800030f4 <sys_sbrk+0x3c>

0000000080003102 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003102:	7139                	addi	sp,sp,-64
    80003104:	fc06                	sd	ra,56(sp)
    80003106:	f822                	sd	s0,48(sp)
    80003108:	f426                	sd	s1,40(sp)
    8000310a:	f04a                	sd	s2,32(sp)
    8000310c:	ec4e                	sd	s3,24(sp)
    8000310e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003110:	fcc40593          	addi	a1,s0,-52
    80003114:	4501                	li	a0,0
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	e2a080e7          	jalr	-470(ra) # 80002f40 <argint>
    return -1;
    8000311e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003120:	06054563          	bltz	a0,8000318a <sys_sleep+0x88>
  acquire(&tickslock);
    80003124:	00014517          	auipc	a0,0x14
    80003128:	5ac50513          	addi	a0,a0,1452 # 800176d0 <tickslock>
    8000312c:	ffffe097          	auipc	ra,0xffffe
    80003130:	aa4080e7          	jalr	-1372(ra) # 80000bd0 <acquire>
  ticks0 = ticks;
    80003134:	00006917          	auipc	s2,0x6
    80003138:	efc92903          	lw	s2,-260(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    8000313c:	fcc42783          	lw	a5,-52(s0)
    80003140:	cf85                	beqz	a5,80003178 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003142:	00014997          	auipc	s3,0x14
    80003146:	58e98993          	addi	s3,s3,1422 # 800176d0 <tickslock>
    8000314a:	00006497          	auipc	s1,0x6
    8000314e:	ee648493          	addi	s1,s1,-282 # 80009030 <ticks>
    if(myproc()->killed){
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	844080e7          	jalr	-1980(ra) # 80001996 <myproc>
    8000315a:	551c                	lw	a5,40(a0)
    8000315c:	ef9d                	bnez	a5,8000319a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000315e:	85ce                	mv	a1,s3
    80003160:	8526                	mv	a0,s1
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	f6e080e7          	jalr	-146(ra) # 800020d0 <sleep>
  while(ticks - ticks0 < n){
    8000316a:	409c                	lw	a5,0(s1)
    8000316c:	412787bb          	subw	a5,a5,s2
    80003170:	fcc42703          	lw	a4,-52(s0)
    80003174:	fce7efe3          	bltu	a5,a4,80003152 <sys_sleep+0x50>
  }
  release(&tickslock);
    80003178:	00014517          	auipc	a0,0x14
    8000317c:	55850513          	addi	a0,a0,1368 # 800176d0 <tickslock>
    80003180:	ffffe097          	auipc	ra,0xffffe
    80003184:	b04080e7          	jalr	-1276(ra) # 80000c84 <release>
  return 0;
    80003188:	4781                	li	a5,0
}
    8000318a:	853e                	mv	a0,a5
    8000318c:	70e2                	ld	ra,56(sp)
    8000318e:	7442                	ld	s0,48(sp)
    80003190:	74a2                	ld	s1,40(sp)
    80003192:	7902                	ld	s2,32(sp)
    80003194:	69e2                	ld	s3,24(sp)
    80003196:	6121                	addi	sp,sp,64
    80003198:	8082                	ret
      release(&tickslock);
    8000319a:	00014517          	auipc	a0,0x14
    8000319e:	53650513          	addi	a0,a0,1334 # 800176d0 <tickslock>
    800031a2:	ffffe097          	auipc	ra,0xffffe
    800031a6:	ae2080e7          	jalr	-1310(ra) # 80000c84 <release>
      return -1;
    800031aa:	57fd                	li	a5,-1
    800031ac:	bff9                	j	8000318a <sys_sleep+0x88>

00000000800031ae <sys_kill>:

uint64
sys_kill(void)
{
    800031ae:	1101                	addi	sp,sp,-32
    800031b0:	ec06                	sd	ra,24(sp)
    800031b2:	e822                	sd	s0,16(sp)
    800031b4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800031b6:	fec40593          	addi	a1,s0,-20
    800031ba:	4501                	li	a0,0
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	d84080e7          	jalr	-636(ra) # 80002f40 <argint>
    800031c4:	87aa                	mv	a5,a0
    return -1;
    800031c6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800031c8:	0007c863          	bltz	a5,800031d8 <sys_kill+0x2a>
  return kill(pid);
    800031cc:	fec42503          	lw	a0,-20(s0)
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	262080e7          	jalr	610(ra) # 80002432 <kill>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	6105                	addi	sp,sp,32
    800031de:	8082                	ret

00000000800031e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031e0:	1101                	addi	sp,sp,-32
    800031e2:	ec06                	sd	ra,24(sp)
    800031e4:	e822                	sd	s0,16(sp)
    800031e6:	e426                	sd	s1,8(sp)
    800031e8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031ea:	00014517          	auipc	a0,0x14
    800031ee:	4e650513          	addi	a0,a0,1254 # 800176d0 <tickslock>
    800031f2:	ffffe097          	auipc	ra,0xffffe
    800031f6:	9de080e7          	jalr	-1570(ra) # 80000bd0 <acquire>
  xticks = ticks;
    800031fa:	00006497          	auipc	s1,0x6
    800031fe:	e364a483          	lw	s1,-458(s1) # 80009030 <ticks>
  release(&tickslock);
    80003202:	00014517          	auipc	a0,0x14
    80003206:	4ce50513          	addi	a0,a0,1230 # 800176d0 <tickslock>
    8000320a:	ffffe097          	auipc	ra,0xffffe
    8000320e:	a7a080e7          	jalr	-1414(ra) # 80000c84 <release>
  return xticks;
} 
    80003212:	02049513          	slli	a0,s1,0x20
    80003216:	9101                	srli	a0,a0,0x20
    80003218:	60e2                	ld	ra,24(sp)
    8000321a:	6442                	ld	s0,16(sp)
    8000321c:	64a2                	ld	s1,8(sp)
    8000321e:	6105                	addi	sp,sp,32
    80003220:	8082                	ret

0000000080003222 <sys_getppid>:

uint64
sys_getppid(void)
{
    80003222:	1141                	addi	sp,sp,-16
    80003224:	e406                	sd	ra,8(sp)
    80003226:	e022                	sd	s0,0(sp)
    80003228:	0800                	addi	s0,sp,16
  return getppid();
    8000322a:	fffff097          	auipc	ra,0xfffff
    8000322e:	3d6080e7          	jalr	982(ra) # 80002600 <getppid>
}
    80003232:	60a2                	ld	ra,8(sp)
    80003234:	6402                	ld	s0,0(sp)
    80003236:	0141                	addi	sp,sp,16
    80003238:	8082                	ret

000000008000323a <sys_yield>:

uint64
sys_yield(void)
{
    8000323a:	1141                	addi	sp,sp,-16
    8000323c:	e406                	sd	ra,8(sp)
    8000323e:	e022                	sd	s0,0(sp)
    80003240:	0800                	addi	s0,sp,16
  yield();
    80003242:	fffff097          	auipc	ra,0xfffff
    80003246:	e52080e7          	jalr	-430(ra) # 80002094 <yield>
  return 0;
}
    8000324a:	4501                	li	a0,0
    8000324c:	60a2                	ld	ra,8(sp)
    8000324e:	6402                	ld	s0,0(sp)
    80003250:	0141                	addi	sp,sp,16
    80003252:	8082                	ret

0000000080003254 <sys_getpa>:

uint64
sys_getpa(void)
{
    80003254:	1101                	addi	sp,sp,-32
    80003256:	ec06                	sd	ra,24(sp)
    80003258:	e822                	sd	s0,16(sp)
    8000325a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000325c:	fe840593          	addi	a1,s0,-24
    80003260:	4501                	li	a0,0
    80003262:	00000097          	auipc	ra,0x0
    80003266:	d00080e7          	jalr	-768(ra) # 80002f62 <argaddr>
    8000326a:	87aa                	mv	a5,a0
    return -1;
    8000326c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000326e:	0207c263          	bltz	a5,80003292 <sys_getpa+0x3e>
  uint64 addr;
  addr=walkaddr(myproc()->pagetable,p)+(p&(PGSIZE-1));
    80003272:	ffffe097          	auipc	ra,0xffffe
    80003276:	724080e7          	jalr	1828(ra) # 80001996 <myproc>
    8000327a:	fe843583          	ld	a1,-24(s0)
    8000327e:	6928                	ld	a0,80(a0)
    80003280:	ffffe097          	auipc	ra,0xffffe
    80003284:	dd2080e7          	jalr	-558(ra) # 80001052 <walkaddr>
    80003288:	fe843783          	ld	a5,-24(s0)
    8000328c:	17d2                	slli	a5,a5,0x34
    8000328e:	93d1                	srli	a5,a5,0x34
    80003290:	953e                	add	a0,a0,a5
  return addr;
} 
    80003292:	60e2                	ld	ra,24(sp)
    80003294:	6442                	ld	s0,16(sp)
    80003296:	6105                	addi	sp,sp,32
    80003298:	8082                	ret

000000008000329a <sys_waitpid>:

uint64
sys_waitpid(void)
{
    8000329a:	1101                	addi	sp,sp,-32
    8000329c:	ec06                	sd	ra,24(sp)
    8000329e:	e822                	sd	s0,16(sp)
    800032a0:	1000                	addi	s0,sp,32
  int id;	
  uint64 p;
  
  if(argaddr(1, &p) < 0)
    800032a2:	fe040593          	addi	a1,s0,-32
    800032a6:	4505                	li	a0,1
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	cba080e7          	jalr	-838(ra) # 80002f62 <argaddr>
    800032b0:	87aa                	mv	a5,a0
    return -1;
    800032b2:	557d                	li	a0,-1
  if(argaddr(1, &p) < 0)
    800032b4:	0207c663          	bltz	a5,800032e0 <sys_waitpid+0x46>
   if(argint(0, &id)<0)
    800032b8:	fec40593          	addi	a1,s0,-20
    800032bc:	4501                	li	a0,0
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	c82080e7          	jalr	-894(ra) # 80002f40 <argint>
    800032c6:	02054863          	bltz	a0,800032f6 <sys_waitpid+0x5c>
    return -1;
   if(id==-1) return wait(p);
    800032ca:	fec42503          	lw	a0,-20(s0)
    800032ce:	57fd                	li	a5,-1
    800032d0:	00f50c63          	beq	a0,a5,800032e8 <sys_waitpid+0x4e>
  //printf("inside sysproc value of id=%d\n",id);
  return waitpid(id,p);
    800032d4:	fe043583          	ld	a1,-32(s0)
    800032d8:	fffff097          	auipc	ra,0xfffff
    800032dc:	376080e7          	jalr	886(ra) # 8000264e <waitpid>
}
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	6105                	addi	sp,sp,32
    800032e6:	8082                	ret
   if(id==-1) return wait(p);
    800032e8:	fe043503          	ld	a0,-32(s0)
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	e48080e7          	jalr	-440(ra) # 80002134 <wait>
    800032f4:	b7f5                	j	800032e0 <sys_waitpid+0x46>
    return -1;
    800032f6:	557d                	li	a0,-1
    800032f8:	b7e5                	j	800032e0 <sys_waitpid+0x46>

00000000800032fa <sys_ps>:

uint64
sys_ps(void)
{
    800032fa:	1141                	addi	sp,sp,-16
    800032fc:	e406                	sd	ra,8(sp)
    800032fe:	e022                	sd	s0,0(sp)
    80003300:	0800                	addi	s0,sp,16
  ps();
    80003302:	fffff097          	auipc	ra,0xfffff
    80003306:	488080e7          	jalr	1160(ra) # 8000278a <ps>
  return 0;
}
    8000330a:	4501                	li	a0,0
    8000330c:	60a2                	ld	ra,8(sp)
    8000330e:	6402                	ld	s0,0(sp)
    80003310:	0141                	addi	sp,sp,16
    80003312:	8082                	ret

0000000080003314 <sys_pinfo>:
//  return forkf(func);
//}

uint64
sys_pinfo(void)
{
    80003314:	1101                	addi	sp,sp,-32
    80003316:	ec06                	sd	ra,24(sp)
    80003318:	e822                	sd	s0,16(sp)
    8000331a:	1000                	addi	s0,sp,32
  int id;
  uint64 p;
  if(argint(0, &id) < 0)
    8000331c:	fec40593          	addi	a1,s0,-20
    80003320:	4501                	li	a0,0
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c1e080e7          	jalr	-994(ra) # 80002f40 <argint>
    return -1;
    8000332a:	57fd                	li	a5,-1
  if(argint(0, &id) < 0)
    8000332c:	02054563          	bltz	a0,80003356 <sys_pinfo+0x42>
   if(argaddr(1, &p)<0)
    80003330:	fe040593          	addi	a1,s0,-32
    80003334:	4505                	li	a0,1
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	c2c080e7          	jalr	-980(ra) # 80002f62 <argaddr>
    return -1;
    8000333e:	57fd                	li	a5,-1
   if(argaddr(1, &p)<0)
    80003340:	00054b63          	bltz	a0,80003356 <sys_pinfo+0x42>
   struct procstat* pstat=(struct procstat*)p;
  return pinfo(id,pstat);
    80003344:	fe043583          	ld	a1,-32(s0)
    80003348:	fec42503          	lw	a0,-20(s0)
    8000334c:	fffff097          	auipc	ra,0xfffff
    80003350:	592080e7          	jalr	1426(ra) # 800028de <pinfo>
    80003354:	87aa                	mv	a5,a0
}
    80003356:	853e                	mv	a0,a5
    80003358:	60e2                	ld	ra,24(sp)
    8000335a:	6442                	ld	s0,16(sp)
    8000335c:	6105                	addi	sp,sp,32
    8000335e:	8082                	ret

0000000080003360 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003360:	7179                	addi	sp,sp,-48
    80003362:	f406                	sd	ra,40(sp)
    80003364:	f022                	sd	s0,32(sp)
    80003366:	ec26                	sd	s1,24(sp)
    80003368:	e84a                	sd	s2,16(sp)
    8000336a:	e44e                	sd	s3,8(sp)
    8000336c:	e052                	sd	s4,0(sp)
    8000336e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003370:	00005597          	auipc	a1,0x5
    80003374:	28058593          	addi	a1,a1,640 # 800085f0 <syscalls+0xe0>
    80003378:	00014517          	auipc	a0,0x14
    8000337c:	37050513          	addi	a0,a0,880 # 800176e8 <bcache>
    80003380:	ffffd097          	auipc	ra,0xffffd
    80003384:	7c0080e7          	jalr	1984(ra) # 80000b40 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003388:	0001c797          	auipc	a5,0x1c
    8000338c:	36078793          	addi	a5,a5,864 # 8001f6e8 <bcache+0x8000>
    80003390:	0001c717          	auipc	a4,0x1c
    80003394:	5c070713          	addi	a4,a4,1472 # 8001f950 <bcache+0x8268>
    80003398:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000339c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033a0:	00014497          	auipc	s1,0x14
    800033a4:	36048493          	addi	s1,s1,864 # 80017700 <bcache+0x18>
    b->next = bcache.head.next;
    800033a8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033aa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033ac:	00005a17          	auipc	s4,0x5
    800033b0:	24ca0a13          	addi	s4,s4,588 # 800085f8 <syscalls+0xe8>
    b->next = bcache.head.next;
    800033b4:	2b893783          	ld	a5,696(s2)
    800033b8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033ba:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033be:	85d2                	mv	a1,s4
    800033c0:	01048513          	addi	a0,s1,16
    800033c4:	00001097          	auipc	ra,0x1
    800033c8:	4c2080e7          	jalr	1218(ra) # 80004886 <initsleeplock>
    bcache.head.next->prev = b;
    800033cc:	2b893783          	ld	a5,696(s2)
    800033d0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033d2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033d6:	45848493          	addi	s1,s1,1112
    800033da:	fd349de3          	bne	s1,s3,800033b4 <binit+0x54>
  }
}
    800033de:	70a2                	ld	ra,40(sp)
    800033e0:	7402                	ld	s0,32(sp)
    800033e2:	64e2                	ld	s1,24(sp)
    800033e4:	6942                	ld	s2,16(sp)
    800033e6:	69a2                	ld	s3,8(sp)
    800033e8:	6a02                	ld	s4,0(sp)
    800033ea:	6145                	addi	sp,sp,48
    800033ec:	8082                	ret

00000000800033ee <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033ee:	7179                	addi	sp,sp,-48
    800033f0:	f406                	sd	ra,40(sp)
    800033f2:	f022                	sd	s0,32(sp)
    800033f4:	ec26                	sd	s1,24(sp)
    800033f6:	e84a                	sd	s2,16(sp)
    800033f8:	e44e                	sd	s3,8(sp)
    800033fa:	1800                	addi	s0,sp,48
    800033fc:	892a                	mv	s2,a0
    800033fe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003400:	00014517          	auipc	a0,0x14
    80003404:	2e850513          	addi	a0,a0,744 # 800176e8 <bcache>
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	7c8080e7          	jalr	1992(ra) # 80000bd0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003410:	0001c497          	auipc	s1,0x1c
    80003414:	5904b483          	ld	s1,1424(s1) # 8001f9a0 <bcache+0x82b8>
    80003418:	0001c797          	auipc	a5,0x1c
    8000341c:	53878793          	addi	a5,a5,1336 # 8001f950 <bcache+0x8268>
    80003420:	02f48f63          	beq	s1,a5,8000345e <bread+0x70>
    80003424:	873e                	mv	a4,a5
    80003426:	a021                	j	8000342e <bread+0x40>
    80003428:	68a4                	ld	s1,80(s1)
    8000342a:	02e48a63          	beq	s1,a4,8000345e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000342e:	449c                	lw	a5,8(s1)
    80003430:	ff279ce3          	bne	a5,s2,80003428 <bread+0x3a>
    80003434:	44dc                	lw	a5,12(s1)
    80003436:	ff3799e3          	bne	a5,s3,80003428 <bread+0x3a>
      b->refcnt++;
    8000343a:	40bc                	lw	a5,64(s1)
    8000343c:	2785                	addiw	a5,a5,1
    8000343e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003440:	00014517          	auipc	a0,0x14
    80003444:	2a850513          	addi	a0,a0,680 # 800176e8 <bcache>
    80003448:	ffffe097          	auipc	ra,0xffffe
    8000344c:	83c080e7          	jalr	-1988(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    80003450:	01048513          	addi	a0,s1,16
    80003454:	00001097          	auipc	ra,0x1
    80003458:	46c080e7          	jalr	1132(ra) # 800048c0 <acquiresleep>
      return b;
    8000345c:	a8b9                	j	800034ba <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000345e:	0001c497          	auipc	s1,0x1c
    80003462:	53a4b483          	ld	s1,1338(s1) # 8001f998 <bcache+0x82b0>
    80003466:	0001c797          	auipc	a5,0x1c
    8000346a:	4ea78793          	addi	a5,a5,1258 # 8001f950 <bcache+0x8268>
    8000346e:	00f48863          	beq	s1,a5,8000347e <bread+0x90>
    80003472:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003474:	40bc                	lw	a5,64(s1)
    80003476:	cf81                	beqz	a5,8000348e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003478:	64a4                	ld	s1,72(s1)
    8000347a:	fee49de3          	bne	s1,a4,80003474 <bread+0x86>
  panic("bget: no buffers");
    8000347e:	00005517          	auipc	a0,0x5
    80003482:	18250513          	addi	a0,a0,386 # 80008600 <syscalls+0xf0>
    80003486:	ffffd097          	auipc	ra,0xffffd
    8000348a:	0b4080e7          	jalr	180(ra) # 8000053a <panic>
      b->dev = dev;
    8000348e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003492:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003496:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000349a:	4785                	li	a5,1
    8000349c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000349e:	00014517          	auipc	a0,0x14
    800034a2:	24a50513          	addi	a0,a0,586 # 800176e8 <bcache>
    800034a6:	ffffd097          	auipc	ra,0xffffd
    800034aa:	7de080e7          	jalr	2014(ra) # 80000c84 <release>
      acquiresleep(&b->lock);
    800034ae:	01048513          	addi	a0,s1,16
    800034b2:	00001097          	auipc	ra,0x1
    800034b6:	40e080e7          	jalr	1038(ra) # 800048c0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034ba:	409c                	lw	a5,0(s1)
    800034bc:	cb89                	beqz	a5,800034ce <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034be:	8526                	mv	a0,s1
    800034c0:	70a2                	ld	ra,40(sp)
    800034c2:	7402                	ld	s0,32(sp)
    800034c4:	64e2                	ld	s1,24(sp)
    800034c6:	6942                	ld	s2,16(sp)
    800034c8:	69a2                	ld	s3,8(sp)
    800034ca:	6145                	addi	sp,sp,48
    800034cc:	8082                	ret
    virtio_disk_rw(b, 0);
    800034ce:	4581                	li	a1,0
    800034d0:	8526                	mv	a0,s1
    800034d2:	00003097          	auipc	ra,0x3
    800034d6:	f20080e7          	jalr	-224(ra) # 800063f2 <virtio_disk_rw>
    b->valid = 1;
    800034da:	4785                	li	a5,1
    800034dc:	c09c                	sw	a5,0(s1)
  return b;
    800034de:	b7c5                	j	800034be <bread+0xd0>

00000000800034e0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034e0:	1101                	addi	sp,sp,-32
    800034e2:	ec06                	sd	ra,24(sp)
    800034e4:	e822                	sd	s0,16(sp)
    800034e6:	e426                	sd	s1,8(sp)
    800034e8:	1000                	addi	s0,sp,32
    800034ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034ec:	0541                	addi	a0,a0,16
    800034ee:	00001097          	auipc	ra,0x1
    800034f2:	46c080e7          	jalr	1132(ra) # 8000495a <holdingsleep>
    800034f6:	cd01                	beqz	a0,8000350e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034f8:	4585                	li	a1,1
    800034fa:	8526                	mv	a0,s1
    800034fc:	00003097          	auipc	ra,0x3
    80003500:	ef6080e7          	jalr	-266(ra) # 800063f2 <virtio_disk_rw>
}
    80003504:	60e2                	ld	ra,24(sp)
    80003506:	6442                	ld	s0,16(sp)
    80003508:	64a2                	ld	s1,8(sp)
    8000350a:	6105                	addi	sp,sp,32
    8000350c:	8082                	ret
    panic("bwrite");
    8000350e:	00005517          	auipc	a0,0x5
    80003512:	10a50513          	addi	a0,a0,266 # 80008618 <syscalls+0x108>
    80003516:	ffffd097          	auipc	ra,0xffffd
    8000351a:	024080e7          	jalr	36(ra) # 8000053a <panic>

000000008000351e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000351e:	1101                	addi	sp,sp,-32
    80003520:	ec06                	sd	ra,24(sp)
    80003522:	e822                	sd	s0,16(sp)
    80003524:	e426                	sd	s1,8(sp)
    80003526:	e04a                	sd	s2,0(sp)
    80003528:	1000                	addi	s0,sp,32
    8000352a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000352c:	01050913          	addi	s2,a0,16
    80003530:	854a                	mv	a0,s2
    80003532:	00001097          	auipc	ra,0x1
    80003536:	428080e7          	jalr	1064(ra) # 8000495a <holdingsleep>
    8000353a:	c92d                	beqz	a0,800035ac <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000353c:	854a                	mv	a0,s2
    8000353e:	00001097          	auipc	ra,0x1
    80003542:	3d8080e7          	jalr	984(ra) # 80004916 <releasesleep>

  acquire(&bcache.lock);
    80003546:	00014517          	auipc	a0,0x14
    8000354a:	1a250513          	addi	a0,a0,418 # 800176e8 <bcache>
    8000354e:	ffffd097          	auipc	ra,0xffffd
    80003552:	682080e7          	jalr	1666(ra) # 80000bd0 <acquire>
  b->refcnt--;
    80003556:	40bc                	lw	a5,64(s1)
    80003558:	37fd                	addiw	a5,a5,-1
    8000355a:	0007871b          	sext.w	a4,a5
    8000355e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003560:	eb05                	bnez	a4,80003590 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003562:	68bc                	ld	a5,80(s1)
    80003564:	64b8                	ld	a4,72(s1)
    80003566:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003568:	64bc                	ld	a5,72(s1)
    8000356a:	68b8                	ld	a4,80(s1)
    8000356c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000356e:	0001c797          	auipc	a5,0x1c
    80003572:	17a78793          	addi	a5,a5,378 # 8001f6e8 <bcache+0x8000>
    80003576:	2b87b703          	ld	a4,696(a5)
    8000357a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000357c:	0001c717          	auipc	a4,0x1c
    80003580:	3d470713          	addi	a4,a4,980 # 8001f950 <bcache+0x8268>
    80003584:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003586:	2b87b703          	ld	a4,696(a5)
    8000358a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000358c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003590:	00014517          	auipc	a0,0x14
    80003594:	15850513          	addi	a0,a0,344 # 800176e8 <bcache>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	6ec080e7          	jalr	1772(ra) # 80000c84 <release>
}
    800035a0:	60e2                	ld	ra,24(sp)
    800035a2:	6442                	ld	s0,16(sp)
    800035a4:	64a2                	ld	s1,8(sp)
    800035a6:	6902                	ld	s2,0(sp)
    800035a8:	6105                	addi	sp,sp,32
    800035aa:	8082                	ret
    panic("brelse");
    800035ac:	00005517          	auipc	a0,0x5
    800035b0:	07450513          	addi	a0,a0,116 # 80008620 <syscalls+0x110>
    800035b4:	ffffd097          	auipc	ra,0xffffd
    800035b8:	f86080e7          	jalr	-122(ra) # 8000053a <panic>

00000000800035bc <bpin>:

void
bpin(struct buf *b) {
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	1000                	addi	s0,sp,32
    800035c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035c8:	00014517          	auipc	a0,0x14
    800035cc:	12050513          	addi	a0,a0,288 # 800176e8 <bcache>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	600080e7          	jalr	1536(ra) # 80000bd0 <acquire>
  b->refcnt++;
    800035d8:	40bc                	lw	a5,64(s1)
    800035da:	2785                	addiw	a5,a5,1
    800035dc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035de:	00014517          	auipc	a0,0x14
    800035e2:	10a50513          	addi	a0,a0,266 # 800176e8 <bcache>
    800035e6:	ffffd097          	auipc	ra,0xffffd
    800035ea:	69e080e7          	jalr	1694(ra) # 80000c84 <release>
}
    800035ee:	60e2                	ld	ra,24(sp)
    800035f0:	6442                	ld	s0,16(sp)
    800035f2:	64a2                	ld	s1,8(sp)
    800035f4:	6105                	addi	sp,sp,32
    800035f6:	8082                	ret

00000000800035f8 <bunpin>:

void
bunpin(struct buf *b) {
    800035f8:	1101                	addi	sp,sp,-32
    800035fa:	ec06                	sd	ra,24(sp)
    800035fc:	e822                	sd	s0,16(sp)
    800035fe:	e426                	sd	s1,8(sp)
    80003600:	1000                	addi	s0,sp,32
    80003602:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003604:	00014517          	auipc	a0,0x14
    80003608:	0e450513          	addi	a0,a0,228 # 800176e8 <bcache>
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	5c4080e7          	jalr	1476(ra) # 80000bd0 <acquire>
  b->refcnt--;
    80003614:	40bc                	lw	a5,64(s1)
    80003616:	37fd                	addiw	a5,a5,-1
    80003618:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000361a:	00014517          	auipc	a0,0x14
    8000361e:	0ce50513          	addi	a0,a0,206 # 800176e8 <bcache>
    80003622:	ffffd097          	auipc	ra,0xffffd
    80003626:	662080e7          	jalr	1634(ra) # 80000c84 <release>
}
    8000362a:	60e2                	ld	ra,24(sp)
    8000362c:	6442                	ld	s0,16(sp)
    8000362e:	64a2                	ld	s1,8(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003634:	1101                	addi	sp,sp,-32
    80003636:	ec06                	sd	ra,24(sp)
    80003638:	e822                	sd	s0,16(sp)
    8000363a:	e426                	sd	s1,8(sp)
    8000363c:	e04a                	sd	s2,0(sp)
    8000363e:	1000                	addi	s0,sp,32
    80003640:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003642:	00d5d59b          	srliw	a1,a1,0xd
    80003646:	0001c797          	auipc	a5,0x1c
    8000364a:	77e7a783          	lw	a5,1918(a5) # 8001fdc4 <sb+0x1c>
    8000364e:	9dbd                	addw	a1,a1,a5
    80003650:	00000097          	auipc	ra,0x0
    80003654:	d9e080e7          	jalr	-610(ra) # 800033ee <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003658:	0074f713          	andi	a4,s1,7
    8000365c:	4785                	li	a5,1
    8000365e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003662:	14ce                	slli	s1,s1,0x33
    80003664:	90d9                	srli	s1,s1,0x36
    80003666:	00950733          	add	a4,a0,s1
    8000366a:	05874703          	lbu	a4,88(a4)
    8000366e:	00e7f6b3          	and	a3,a5,a4
    80003672:	c69d                	beqz	a3,800036a0 <bfree+0x6c>
    80003674:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003676:	94aa                	add	s1,s1,a0
    80003678:	fff7c793          	not	a5,a5
    8000367c:	8f7d                	and	a4,a4,a5
    8000367e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003682:	00001097          	auipc	ra,0x1
    80003686:	120080e7          	jalr	288(ra) # 800047a2 <log_write>
  brelse(bp);
    8000368a:	854a                	mv	a0,s2
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	e92080e7          	jalr	-366(ra) # 8000351e <brelse>
}
    80003694:	60e2                	ld	ra,24(sp)
    80003696:	6442                	ld	s0,16(sp)
    80003698:	64a2                	ld	s1,8(sp)
    8000369a:	6902                	ld	s2,0(sp)
    8000369c:	6105                	addi	sp,sp,32
    8000369e:	8082                	ret
    panic("freeing free block");
    800036a0:	00005517          	auipc	a0,0x5
    800036a4:	f8850513          	addi	a0,a0,-120 # 80008628 <syscalls+0x118>
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	e92080e7          	jalr	-366(ra) # 8000053a <panic>

00000000800036b0 <balloc>:
{
    800036b0:	711d                	addi	sp,sp,-96
    800036b2:	ec86                	sd	ra,88(sp)
    800036b4:	e8a2                	sd	s0,80(sp)
    800036b6:	e4a6                	sd	s1,72(sp)
    800036b8:	e0ca                	sd	s2,64(sp)
    800036ba:	fc4e                	sd	s3,56(sp)
    800036bc:	f852                	sd	s4,48(sp)
    800036be:	f456                	sd	s5,40(sp)
    800036c0:	f05a                	sd	s6,32(sp)
    800036c2:	ec5e                	sd	s7,24(sp)
    800036c4:	e862                	sd	s8,16(sp)
    800036c6:	e466                	sd	s9,8(sp)
    800036c8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036ca:	0001c797          	auipc	a5,0x1c
    800036ce:	6e27a783          	lw	a5,1762(a5) # 8001fdac <sb+0x4>
    800036d2:	cbc1                	beqz	a5,80003762 <balloc+0xb2>
    800036d4:	8baa                	mv	s7,a0
    800036d6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036d8:	0001cb17          	auipc	s6,0x1c
    800036dc:	6d0b0b13          	addi	s6,s6,1744 # 8001fda8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036e0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036e2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036e4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036e6:	6c89                	lui	s9,0x2
    800036e8:	a831                	j	80003704 <balloc+0x54>
    brelse(bp);
    800036ea:	854a                	mv	a0,s2
    800036ec:	00000097          	auipc	ra,0x0
    800036f0:	e32080e7          	jalr	-462(ra) # 8000351e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036f4:	015c87bb          	addw	a5,s9,s5
    800036f8:	00078a9b          	sext.w	s5,a5
    800036fc:	004b2703          	lw	a4,4(s6)
    80003700:	06eaf163          	bgeu	s5,a4,80003762 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80003704:	41fad79b          	sraiw	a5,s5,0x1f
    80003708:	0137d79b          	srliw	a5,a5,0x13
    8000370c:	015787bb          	addw	a5,a5,s5
    80003710:	40d7d79b          	sraiw	a5,a5,0xd
    80003714:	01cb2583          	lw	a1,28(s6)
    80003718:	9dbd                	addw	a1,a1,a5
    8000371a:	855e                	mv	a0,s7
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	cd2080e7          	jalr	-814(ra) # 800033ee <bread>
    80003724:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003726:	004b2503          	lw	a0,4(s6)
    8000372a:	000a849b          	sext.w	s1,s5
    8000372e:	8762                	mv	a4,s8
    80003730:	faa4fde3          	bgeu	s1,a0,800036ea <balloc+0x3a>
      m = 1 << (bi % 8);
    80003734:	00777693          	andi	a3,a4,7
    80003738:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000373c:	41f7579b          	sraiw	a5,a4,0x1f
    80003740:	01d7d79b          	srliw	a5,a5,0x1d
    80003744:	9fb9                	addw	a5,a5,a4
    80003746:	4037d79b          	sraiw	a5,a5,0x3
    8000374a:	00f90633          	add	a2,s2,a5
    8000374e:	05864603          	lbu	a2,88(a2)
    80003752:	00c6f5b3          	and	a1,a3,a2
    80003756:	cd91                	beqz	a1,80003772 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003758:	2705                	addiw	a4,a4,1
    8000375a:	2485                	addiw	s1,s1,1
    8000375c:	fd471ae3          	bne	a4,s4,80003730 <balloc+0x80>
    80003760:	b769                	j	800036ea <balloc+0x3a>
  panic("balloc: out of blocks");
    80003762:	00005517          	auipc	a0,0x5
    80003766:	ede50513          	addi	a0,a0,-290 # 80008640 <syscalls+0x130>
    8000376a:	ffffd097          	auipc	ra,0xffffd
    8000376e:	dd0080e7          	jalr	-560(ra) # 8000053a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003772:	97ca                	add	a5,a5,s2
    80003774:	8e55                	or	a2,a2,a3
    80003776:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000377a:	854a                	mv	a0,s2
    8000377c:	00001097          	auipc	ra,0x1
    80003780:	026080e7          	jalr	38(ra) # 800047a2 <log_write>
        brelse(bp);
    80003784:	854a                	mv	a0,s2
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	d98080e7          	jalr	-616(ra) # 8000351e <brelse>
  bp = bread(dev, bno);
    8000378e:	85a6                	mv	a1,s1
    80003790:	855e                	mv	a0,s7
    80003792:	00000097          	auipc	ra,0x0
    80003796:	c5c080e7          	jalr	-932(ra) # 800033ee <bread>
    8000379a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000379c:	40000613          	li	a2,1024
    800037a0:	4581                	li	a1,0
    800037a2:	05850513          	addi	a0,a0,88
    800037a6:	ffffd097          	auipc	ra,0xffffd
    800037aa:	526080e7          	jalr	1318(ra) # 80000ccc <memset>
  log_write(bp);
    800037ae:	854a                	mv	a0,s2
    800037b0:	00001097          	auipc	ra,0x1
    800037b4:	ff2080e7          	jalr	-14(ra) # 800047a2 <log_write>
  brelse(bp);
    800037b8:	854a                	mv	a0,s2
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	d64080e7          	jalr	-668(ra) # 8000351e <brelse>
}
    800037c2:	8526                	mv	a0,s1
    800037c4:	60e6                	ld	ra,88(sp)
    800037c6:	6446                	ld	s0,80(sp)
    800037c8:	64a6                	ld	s1,72(sp)
    800037ca:	6906                	ld	s2,64(sp)
    800037cc:	79e2                	ld	s3,56(sp)
    800037ce:	7a42                	ld	s4,48(sp)
    800037d0:	7aa2                	ld	s5,40(sp)
    800037d2:	7b02                	ld	s6,32(sp)
    800037d4:	6be2                	ld	s7,24(sp)
    800037d6:	6c42                	ld	s8,16(sp)
    800037d8:	6ca2                	ld	s9,8(sp)
    800037da:	6125                	addi	sp,sp,96
    800037dc:	8082                	ret

00000000800037de <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800037de:	7179                	addi	sp,sp,-48
    800037e0:	f406                	sd	ra,40(sp)
    800037e2:	f022                	sd	s0,32(sp)
    800037e4:	ec26                	sd	s1,24(sp)
    800037e6:	e84a                	sd	s2,16(sp)
    800037e8:	e44e                	sd	s3,8(sp)
    800037ea:	e052                	sd	s4,0(sp)
    800037ec:	1800                	addi	s0,sp,48
    800037ee:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037f0:	47ad                	li	a5,11
    800037f2:	04b7fe63          	bgeu	a5,a1,8000384e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800037f6:	ff45849b          	addiw	s1,a1,-12
    800037fa:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037fe:	0ff00793          	li	a5,255
    80003802:	0ae7e463          	bltu	a5,a4,800038aa <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003806:	08052583          	lw	a1,128(a0)
    8000380a:	c5b5                	beqz	a1,80003876 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000380c:	00092503          	lw	a0,0(s2)
    80003810:	00000097          	auipc	ra,0x0
    80003814:	bde080e7          	jalr	-1058(ra) # 800033ee <bread>
    80003818:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000381a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000381e:	02049713          	slli	a4,s1,0x20
    80003822:	01e75593          	srli	a1,a4,0x1e
    80003826:	00b784b3          	add	s1,a5,a1
    8000382a:	0004a983          	lw	s3,0(s1)
    8000382e:	04098e63          	beqz	s3,8000388a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003832:	8552                	mv	a0,s4
    80003834:	00000097          	auipc	ra,0x0
    80003838:	cea080e7          	jalr	-790(ra) # 8000351e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000383c:	854e                	mv	a0,s3
    8000383e:	70a2                	ld	ra,40(sp)
    80003840:	7402                	ld	s0,32(sp)
    80003842:	64e2                	ld	s1,24(sp)
    80003844:	6942                	ld	s2,16(sp)
    80003846:	69a2                	ld	s3,8(sp)
    80003848:	6a02                	ld	s4,0(sp)
    8000384a:	6145                	addi	sp,sp,48
    8000384c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000384e:	02059793          	slli	a5,a1,0x20
    80003852:	01e7d593          	srli	a1,a5,0x1e
    80003856:	00b504b3          	add	s1,a0,a1
    8000385a:	0504a983          	lw	s3,80(s1)
    8000385e:	fc099fe3          	bnez	s3,8000383c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003862:	4108                	lw	a0,0(a0)
    80003864:	00000097          	auipc	ra,0x0
    80003868:	e4c080e7          	jalr	-436(ra) # 800036b0 <balloc>
    8000386c:	0005099b          	sext.w	s3,a0
    80003870:	0534a823          	sw	s3,80(s1)
    80003874:	b7e1                	j	8000383c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003876:	4108                	lw	a0,0(a0)
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	e38080e7          	jalr	-456(ra) # 800036b0 <balloc>
    80003880:	0005059b          	sext.w	a1,a0
    80003884:	08b92023          	sw	a1,128(s2)
    80003888:	b751                	j	8000380c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000388a:	00092503          	lw	a0,0(s2)
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	e22080e7          	jalr	-478(ra) # 800036b0 <balloc>
    80003896:	0005099b          	sext.w	s3,a0
    8000389a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000389e:	8552                	mv	a0,s4
    800038a0:	00001097          	auipc	ra,0x1
    800038a4:	f02080e7          	jalr	-254(ra) # 800047a2 <log_write>
    800038a8:	b769                	j	80003832 <bmap+0x54>
  panic("bmap: out of range");
    800038aa:	00005517          	auipc	a0,0x5
    800038ae:	dae50513          	addi	a0,a0,-594 # 80008658 <syscalls+0x148>
    800038b2:	ffffd097          	auipc	ra,0xffffd
    800038b6:	c88080e7          	jalr	-888(ra) # 8000053a <panic>

00000000800038ba <iget>:
{
    800038ba:	7179                	addi	sp,sp,-48
    800038bc:	f406                	sd	ra,40(sp)
    800038be:	f022                	sd	s0,32(sp)
    800038c0:	ec26                	sd	s1,24(sp)
    800038c2:	e84a                	sd	s2,16(sp)
    800038c4:	e44e                	sd	s3,8(sp)
    800038c6:	e052                	sd	s4,0(sp)
    800038c8:	1800                	addi	s0,sp,48
    800038ca:	89aa                	mv	s3,a0
    800038cc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038ce:	0001c517          	auipc	a0,0x1c
    800038d2:	4fa50513          	addi	a0,a0,1274 # 8001fdc8 <itable>
    800038d6:	ffffd097          	auipc	ra,0xffffd
    800038da:	2fa080e7          	jalr	762(ra) # 80000bd0 <acquire>
  empty = 0;
    800038de:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038e0:	0001c497          	auipc	s1,0x1c
    800038e4:	50048493          	addi	s1,s1,1280 # 8001fde0 <itable+0x18>
    800038e8:	0001e697          	auipc	a3,0x1e
    800038ec:	f8868693          	addi	a3,a3,-120 # 80021870 <log>
    800038f0:	a039                	j	800038fe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800038f2:	02090b63          	beqz	s2,80003928 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038f6:	08848493          	addi	s1,s1,136
    800038fa:	02d48a63          	beq	s1,a3,8000392e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038fe:	449c                	lw	a5,8(s1)
    80003900:	fef059e3          	blez	a5,800038f2 <iget+0x38>
    80003904:	4098                	lw	a4,0(s1)
    80003906:	ff3716e3          	bne	a4,s3,800038f2 <iget+0x38>
    8000390a:	40d8                	lw	a4,4(s1)
    8000390c:	ff4713e3          	bne	a4,s4,800038f2 <iget+0x38>
      ip->ref++;
    80003910:	2785                	addiw	a5,a5,1
    80003912:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003914:	0001c517          	auipc	a0,0x1c
    80003918:	4b450513          	addi	a0,a0,1204 # 8001fdc8 <itable>
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	368080e7          	jalr	872(ra) # 80000c84 <release>
      return ip;
    80003924:	8926                	mv	s2,s1
    80003926:	a03d                	j	80003954 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003928:	f7f9                	bnez	a5,800038f6 <iget+0x3c>
    8000392a:	8926                	mv	s2,s1
    8000392c:	b7e9                	j	800038f6 <iget+0x3c>
  if(empty == 0)
    8000392e:	02090c63          	beqz	s2,80003966 <iget+0xac>
  ip->dev = dev;
    80003932:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003936:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000393a:	4785                	li	a5,1
    8000393c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003940:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003944:	0001c517          	auipc	a0,0x1c
    80003948:	48450513          	addi	a0,a0,1156 # 8001fdc8 <itable>
    8000394c:	ffffd097          	auipc	ra,0xffffd
    80003950:	338080e7          	jalr	824(ra) # 80000c84 <release>
}
    80003954:	854a                	mv	a0,s2
    80003956:	70a2                	ld	ra,40(sp)
    80003958:	7402                	ld	s0,32(sp)
    8000395a:	64e2                	ld	s1,24(sp)
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	69a2                	ld	s3,8(sp)
    80003960:	6a02                	ld	s4,0(sp)
    80003962:	6145                	addi	sp,sp,48
    80003964:	8082                	ret
    panic("iget: no inodes");
    80003966:	00005517          	auipc	a0,0x5
    8000396a:	d0a50513          	addi	a0,a0,-758 # 80008670 <syscalls+0x160>
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	bcc080e7          	jalr	-1076(ra) # 8000053a <panic>

0000000080003976 <fsinit>:
fsinit(int dev) {
    80003976:	7179                	addi	sp,sp,-48
    80003978:	f406                	sd	ra,40(sp)
    8000397a:	f022                	sd	s0,32(sp)
    8000397c:	ec26                	sd	s1,24(sp)
    8000397e:	e84a                	sd	s2,16(sp)
    80003980:	e44e                	sd	s3,8(sp)
    80003982:	1800                	addi	s0,sp,48
    80003984:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003986:	4585                	li	a1,1
    80003988:	00000097          	auipc	ra,0x0
    8000398c:	a66080e7          	jalr	-1434(ra) # 800033ee <bread>
    80003990:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003992:	0001c997          	auipc	s3,0x1c
    80003996:	41698993          	addi	s3,s3,1046 # 8001fda8 <sb>
    8000399a:	02000613          	li	a2,32
    8000399e:	05850593          	addi	a1,a0,88
    800039a2:	854e                	mv	a0,s3
    800039a4:	ffffd097          	auipc	ra,0xffffd
    800039a8:	384080e7          	jalr	900(ra) # 80000d28 <memmove>
  brelse(bp);
    800039ac:	8526                	mv	a0,s1
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	b70080e7          	jalr	-1168(ra) # 8000351e <brelse>
  if(sb.magic != FSMAGIC)
    800039b6:	0009a703          	lw	a4,0(s3)
    800039ba:	102037b7          	lui	a5,0x10203
    800039be:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039c2:	02f71263          	bne	a4,a5,800039e6 <fsinit+0x70>
  initlog(dev, &sb);
    800039c6:	0001c597          	auipc	a1,0x1c
    800039ca:	3e258593          	addi	a1,a1,994 # 8001fda8 <sb>
    800039ce:	854a                	mv	a0,s2
    800039d0:	00001097          	auipc	ra,0x1
    800039d4:	b56080e7          	jalr	-1194(ra) # 80004526 <initlog>
}
    800039d8:	70a2                	ld	ra,40(sp)
    800039da:	7402                	ld	s0,32(sp)
    800039dc:	64e2                	ld	s1,24(sp)
    800039de:	6942                	ld	s2,16(sp)
    800039e0:	69a2                	ld	s3,8(sp)
    800039e2:	6145                	addi	sp,sp,48
    800039e4:	8082                	ret
    panic("invalid file system");
    800039e6:	00005517          	auipc	a0,0x5
    800039ea:	c9a50513          	addi	a0,a0,-870 # 80008680 <syscalls+0x170>
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	b4c080e7          	jalr	-1204(ra) # 8000053a <panic>

00000000800039f6 <iinit>:
{
    800039f6:	7179                	addi	sp,sp,-48
    800039f8:	f406                	sd	ra,40(sp)
    800039fa:	f022                	sd	s0,32(sp)
    800039fc:	ec26                	sd	s1,24(sp)
    800039fe:	e84a                	sd	s2,16(sp)
    80003a00:	e44e                	sd	s3,8(sp)
    80003a02:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a04:	00005597          	auipc	a1,0x5
    80003a08:	c9458593          	addi	a1,a1,-876 # 80008698 <syscalls+0x188>
    80003a0c:	0001c517          	auipc	a0,0x1c
    80003a10:	3bc50513          	addi	a0,a0,956 # 8001fdc8 <itable>
    80003a14:	ffffd097          	auipc	ra,0xffffd
    80003a18:	12c080e7          	jalr	300(ra) # 80000b40 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a1c:	0001c497          	auipc	s1,0x1c
    80003a20:	3d448493          	addi	s1,s1,980 # 8001fdf0 <itable+0x28>
    80003a24:	0001e997          	auipc	s3,0x1e
    80003a28:	e5c98993          	addi	s3,s3,-420 # 80021880 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a2c:	00005917          	auipc	s2,0x5
    80003a30:	c7490913          	addi	s2,s2,-908 # 800086a0 <syscalls+0x190>
    80003a34:	85ca                	mv	a1,s2
    80003a36:	8526                	mv	a0,s1
    80003a38:	00001097          	auipc	ra,0x1
    80003a3c:	e4e080e7          	jalr	-434(ra) # 80004886 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a40:	08848493          	addi	s1,s1,136
    80003a44:	ff3498e3          	bne	s1,s3,80003a34 <iinit+0x3e>
}
    80003a48:	70a2                	ld	ra,40(sp)
    80003a4a:	7402                	ld	s0,32(sp)
    80003a4c:	64e2                	ld	s1,24(sp)
    80003a4e:	6942                	ld	s2,16(sp)
    80003a50:	69a2                	ld	s3,8(sp)
    80003a52:	6145                	addi	sp,sp,48
    80003a54:	8082                	ret

0000000080003a56 <ialloc>:
{
    80003a56:	715d                	addi	sp,sp,-80
    80003a58:	e486                	sd	ra,72(sp)
    80003a5a:	e0a2                	sd	s0,64(sp)
    80003a5c:	fc26                	sd	s1,56(sp)
    80003a5e:	f84a                	sd	s2,48(sp)
    80003a60:	f44e                	sd	s3,40(sp)
    80003a62:	f052                	sd	s4,32(sp)
    80003a64:	ec56                	sd	s5,24(sp)
    80003a66:	e85a                	sd	s6,16(sp)
    80003a68:	e45e                	sd	s7,8(sp)
    80003a6a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a6c:	0001c717          	auipc	a4,0x1c
    80003a70:	34872703          	lw	a4,840(a4) # 8001fdb4 <sb+0xc>
    80003a74:	4785                	li	a5,1
    80003a76:	04e7fa63          	bgeu	a5,a4,80003aca <ialloc+0x74>
    80003a7a:	8aaa                	mv	s5,a0
    80003a7c:	8bae                	mv	s7,a1
    80003a7e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a80:	0001ca17          	auipc	s4,0x1c
    80003a84:	328a0a13          	addi	s4,s4,808 # 8001fda8 <sb>
    80003a88:	00048b1b          	sext.w	s6,s1
    80003a8c:	0044d593          	srli	a1,s1,0x4
    80003a90:	018a2783          	lw	a5,24(s4)
    80003a94:	9dbd                	addw	a1,a1,a5
    80003a96:	8556                	mv	a0,s5
    80003a98:	00000097          	auipc	ra,0x0
    80003a9c:	956080e7          	jalr	-1706(ra) # 800033ee <bread>
    80003aa0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003aa2:	05850993          	addi	s3,a0,88
    80003aa6:	00f4f793          	andi	a5,s1,15
    80003aaa:	079a                	slli	a5,a5,0x6
    80003aac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003aae:	00099783          	lh	a5,0(s3)
    80003ab2:	c785                	beqz	a5,80003ada <ialloc+0x84>
    brelse(bp);
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	a6a080e7          	jalr	-1430(ra) # 8000351e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003abc:	0485                	addi	s1,s1,1
    80003abe:	00ca2703          	lw	a4,12(s4)
    80003ac2:	0004879b          	sext.w	a5,s1
    80003ac6:	fce7e1e3          	bltu	a5,a4,80003a88 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003aca:	00005517          	auipc	a0,0x5
    80003ace:	bde50513          	addi	a0,a0,-1058 # 800086a8 <syscalls+0x198>
    80003ad2:	ffffd097          	auipc	ra,0xffffd
    80003ad6:	a68080e7          	jalr	-1432(ra) # 8000053a <panic>
      memset(dip, 0, sizeof(*dip));
    80003ada:	04000613          	li	a2,64
    80003ade:	4581                	li	a1,0
    80003ae0:	854e                	mv	a0,s3
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	1ea080e7          	jalr	490(ra) # 80000ccc <memset>
      dip->type = type;
    80003aea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003aee:	854a                	mv	a0,s2
    80003af0:	00001097          	auipc	ra,0x1
    80003af4:	cb2080e7          	jalr	-846(ra) # 800047a2 <log_write>
      brelse(bp);
    80003af8:	854a                	mv	a0,s2
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	a24080e7          	jalr	-1500(ra) # 8000351e <brelse>
      return iget(dev, inum);
    80003b02:	85da                	mv	a1,s6
    80003b04:	8556                	mv	a0,s5
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	db4080e7          	jalr	-588(ra) # 800038ba <iget>
}
    80003b0e:	60a6                	ld	ra,72(sp)
    80003b10:	6406                	ld	s0,64(sp)
    80003b12:	74e2                	ld	s1,56(sp)
    80003b14:	7942                	ld	s2,48(sp)
    80003b16:	79a2                	ld	s3,40(sp)
    80003b18:	7a02                	ld	s4,32(sp)
    80003b1a:	6ae2                	ld	s5,24(sp)
    80003b1c:	6b42                	ld	s6,16(sp)
    80003b1e:	6ba2                	ld	s7,8(sp)
    80003b20:	6161                	addi	sp,sp,80
    80003b22:	8082                	ret

0000000080003b24 <iupdate>:
{
    80003b24:	1101                	addi	sp,sp,-32
    80003b26:	ec06                	sd	ra,24(sp)
    80003b28:	e822                	sd	s0,16(sp)
    80003b2a:	e426                	sd	s1,8(sp)
    80003b2c:	e04a                	sd	s2,0(sp)
    80003b2e:	1000                	addi	s0,sp,32
    80003b30:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b32:	415c                	lw	a5,4(a0)
    80003b34:	0047d79b          	srliw	a5,a5,0x4
    80003b38:	0001c597          	auipc	a1,0x1c
    80003b3c:	2885a583          	lw	a1,648(a1) # 8001fdc0 <sb+0x18>
    80003b40:	9dbd                	addw	a1,a1,a5
    80003b42:	4108                	lw	a0,0(a0)
    80003b44:	00000097          	auipc	ra,0x0
    80003b48:	8aa080e7          	jalr	-1878(ra) # 800033ee <bread>
    80003b4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b4e:	05850793          	addi	a5,a0,88
    80003b52:	40d8                	lw	a4,4(s1)
    80003b54:	8b3d                	andi	a4,a4,15
    80003b56:	071a                	slli	a4,a4,0x6
    80003b58:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b5a:	04449703          	lh	a4,68(s1)
    80003b5e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b62:	04649703          	lh	a4,70(s1)
    80003b66:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b6a:	04849703          	lh	a4,72(s1)
    80003b6e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b72:	04a49703          	lh	a4,74(s1)
    80003b76:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b7a:	44f8                	lw	a4,76(s1)
    80003b7c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b7e:	03400613          	li	a2,52
    80003b82:	05048593          	addi	a1,s1,80
    80003b86:	00c78513          	addi	a0,a5,12
    80003b8a:	ffffd097          	auipc	ra,0xffffd
    80003b8e:	19e080e7          	jalr	414(ra) # 80000d28 <memmove>
  log_write(bp);
    80003b92:	854a                	mv	a0,s2
    80003b94:	00001097          	auipc	ra,0x1
    80003b98:	c0e080e7          	jalr	-1010(ra) # 800047a2 <log_write>
  brelse(bp);
    80003b9c:	854a                	mv	a0,s2
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	980080e7          	jalr	-1664(ra) # 8000351e <brelse>
}
    80003ba6:	60e2                	ld	ra,24(sp)
    80003ba8:	6442                	ld	s0,16(sp)
    80003baa:	64a2                	ld	s1,8(sp)
    80003bac:	6902                	ld	s2,0(sp)
    80003bae:	6105                	addi	sp,sp,32
    80003bb0:	8082                	ret

0000000080003bb2 <idup>:
{
    80003bb2:	1101                	addi	sp,sp,-32
    80003bb4:	ec06                	sd	ra,24(sp)
    80003bb6:	e822                	sd	s0,16(sp)
    80003bb8:	e426                	sd	s1,8(sp)
    80003bba:	1000                	addi	s0,sp,32
    80003bbc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003bbe:	0001c517          	auipc	a0,0x1c
    80003bc2:	20a50513          	addi	a0,a0,522 # 8001fdc8 <itable>
    80003bc6:	ffffd097          	auipc	ra,0xffffd
    80003bca:	00a080e7          	jalr	10(ra) # 80000bd0 <acquire>
  ip->ref++;
    80003bce:	449c                	lw	a5,8(s1)
    80003bd0:	2785                	addiw	a5,a5,1
    80003bd2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003bd4:	0001c517          	auipc	a0,0x1c
    80003bd8:	1f450513          	addi	a0,a0,500 # 8001fdc8 <itable>
    80003bdc:	ffffd097          	auipc	ra,0xffffd
    80003be0:	0a8080e7          	jalr	168(ra) # 80000c84 <release>
}
    80003be4:	8526                	mv	a0,s1
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6105                	addi	sp,sp,32
    80003bee:	8082                	ret

0000000080003bf0 <ilock>:
{
    80003bf0:	1101                	addi	sp,sp,-32
    80003bf2:	ec06                	sd	ra,24(sp)
    80003bf4:	e822                	sd	s0,16(sp)
    80003bf6:	e426                	sd	s1,8(sp)
    80003bf8:	e04a                	sd	s2,0(sp)
    80003bfa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003bfc:	c115                	beqz	a0,80003c20 <ilock+0x30>
    80003bfe:	84aa                	mv	s1,a0
    80003c00:	451c                	lw	a5,8(a0)
    80003c02:	00f05f63          	blez	a5,80003c20 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003c06:	0541                	addi	a0,a0,16
    80003c08:	00001097          	auipc	ra,0x1
    80003c0c:	cb8080e7          	jalr	-840(ra) # 800048c0 <acquiresleep>
  if(ip->valid == 0){
    80003c10:	40bc                	lw	a5,64(s1)
    80003c12:	cf99                	beqz	a5,80003c30 <ilock+0x40>
}
    80003c14:	60e2                	ld	ra,24(sp)
    80003c16:	6442                	ld	s0,16(sp)
    80003c18:	64a2                	ld	s1,8(sp)
    80003c1a:	6902                	ld	s2,0(sp)
    80003c1c:	6105                	addi	sp,sp,32
    80003c1e:	8082                	ret
    panic("ilock");
    80003c20:	00005517          	auipc	a0,0x5
    80003c24:	aa050513          	addi	a0,a0,-1376 # 800086c0 <syscalls+0x1b0>
    80003c28:	ffffd097          	auipc	ra,0xffffd
    80003c2c:	912080e7          	jalr	-1774(ra) # 8000053a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c30:	40dc                	lw	a5,4(s1)
    80003c32:	0047d79b          	srliw	a5,a5,0x4
    80003c36:	0001c597          	auipc	a1,0x1c
    80003c3a:	18a5a583          	lw	a1,394(a1) # 8001fdc0 <sb+0x18>
    80003c3e:	9dbd                	addw	a1,a1,a5
    80003c40:	4088                	lw	a0,0(s1)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	7ac080e7          	jalr	1964(ra) # 800033ee <bread>
    80003c4a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c4c:	05850593          	addi	a1,a0,88
    80003c50:	40dc                	lw	a5,4(s1)
    80003c52:	8bbd                	andi	a5,a5,15
    80003c54:	079a                	slli	a5,a5,0x6
    80003c56:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c58:	00059783          	lh	a5,0(a1)
    80003c5c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c60:	00259783          	lh	a5,2(a1)
    80003c64:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c68:	00459783          	lh	a5,4(a1)
    80003c6c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c70:	00659783          	lh	a5,6(a1)
    80003c74:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c78:	459c                	lw	a5,8(a1)
    80003c7a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c7c:	03400613          	li	a2,52
    80003c80:	05b1                	addi	a1,a1,12
    80003c82:	05048513          	addi	a0,s1,80
    80003c86:	ffffd097          	auipc	ra,0xffffd
    80003c8a:	0a2080e7          	jalr	162(ra) # 80000d28 <memmove>
    brelse(bp);
    80003c8e:	854a                	mv	a0,s2
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	88e080e7          	jalr	-1906(ra) # 8000351e <brelse>
    ip->valid = 1;
    80003c98:	4785                	li	a5,1
    80003c9a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c9c:	04449783          	lh	a5,68(s1)
    80003ca0:	fbb5                	bnez	a5,80003c14 <ilock+0x24>
      panic("ilock: no type");
    80003ca2:	00005517          	auipc	a0,0x5
    80003ca6:	a2650513          	addi	a0,a0,-1498 # 800086c8 <syscalls+0x1b8>
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	890080e7          	jalr	-1904(ra) # 8000053a <panic>

0000000080003cb2 <iunlock>:
{
    80003cb2:	1101                	addi	sp,sp,-32
    80003cb4:	ec06                	sd	ra,24(sp)
    80003cb6:	e822                	sd	s0,16(sp)
    80003cb8:	e426                	sd	s1,8(sp)
    80003cba:	e04a                	sd	s2,0(sp)
    80003cbc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003cbe:	c905                	beqz	a0,80003cee <iunlock+0x3c>
    80003cc0:	84aa                	mv	s1,a0
    80003cc2:	01050913          	addi	s2,a0,16
    80003cc6:	854a                	mv	a0,s2
    80003cc8:	00001097          	auipc	ra,0x1
    80003ccc:	c92080e7          	jalr	-878(ra) # 8000495a <holdingsleep>
    80003cd0:	cd19                	beqz	a0,80003cee <iunlock+0x3c>
    80003cd2:	449c                	lw	a5,8(s1)
    80003cd4:	00f05d63          	blez	a5,80003cee <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cd8:	854a                	mv	a0,s2
    80003cda:	00001097          	auipc	ra,0x1
    80003cde:	c3c080e7          	jalr	-964(ra) # 80004916 <releasesleep>
}
    80003ce2:	60e2                	ld	ra,24(sp)
    80003ce4:	6442                	ld	s0,16(sp)
    80003ce6:	64a2                	ld	s1,8(sp)
    80003ce8:	6902                	ld	s2,0(sp)
    80003cea:	6105                	addi	sp,sp,32
    80003cec:	8082                	ret
    panic("iunlock");
    80003cee:	00005517          	auipc	a0,0x5
    80003cf2:	9ea50513          	addi	a0,a0,-1558 # 800086d8 <syscalls+0x1c8>
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	844080e7          	jalr	-1980(ra) # 8000053a <panic>

0000000080003cfe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003cfe:	7179                	addi	sp,sp,-48
    80003d00:	f406                	sd	ra,40(sp)
    80003d02:	f022                	sd	s0,32(sp)
    80003d04:	ec26                	sd	s1,24(sp)
    80003d06:	e84a                	sd	s2,16(sp)
    80003d08:	e44e                	sd	s3,8(sp)
    80003d0a:	e052                	sd	s4,0(sp)
    80003d0c:	1800                	addi	s0,sp,48
    80003d0e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d10:	05050493          	addi	s1,a0,80
    80003d14:	08050913          	addi	s2,a0,128
    80003d18:	a021                	j	80003d20 <itrunc+0x22>
    80003d1a:	0491                	addi	s1,s1,4
    80003d1c:	01248d63          	beq	s1,s2,80003d36 <itrunc+0x38>
    if(ip->addrs[i]){
    80003d20:	408c                	lw	a1,0(s1)
    80003d22:	dde5                	beqz	a1,80003d1a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003d24:	0009a503          	lw	a0,0(s3)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	90c080e7          	jalr	-1780(ra) # 80003634 <bfree>
      ip->addrs[i] = 0;
    80003d30:	0004a023          	sw	zero,0(s1)
    80003d34:	b7dd                	j	80003d1a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d36:	0809a583          	lw	a1,128(s3)
    80003d3a:	e185                	bnez	a1,80003d5a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d3c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d40:	854e                	mv	a0,s3
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	de2080e7          	jalr	-542(ra) # 80003b24 <iupdate>
}
    80003d4a:	70a2                	ld	ra,40(sp)
    80003d4c:	7402                	ld	s0,32(sp)
    80003d4e:	64e2                	ld	s1,24(sp)
    80003d50:	6942                	ld	s2,16(sp)
    80003d52:	69a2                	ld	s3,8(sp)
    80003d54:	6a02                	ld	s4,0(sp)
    80003d56:	6145                	addi	sp,sp,48
    80003d58:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d5a:	0009a503          	lw	a0,0(s3)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	690080e7          	jalr	1680(ra) # 800033ee <bread>
    80003d66:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d68:	05850493          	addi	s1,a0,88
    80003d6c:	45850913          	addi	s2,a0,1112
    80003d70:	a021                	j	80003d78 <itrunc+0x7a>
    80003d72:	0491                	addi	s1,s1,4
    80003d74:	01248b63          	beq	s1,s2,80003d8a <itrunc+0x8c>
      if(a[j])
    80003d78:	408c                	lw	a1,0(s1)
    80003d7a:	dde5                	beqz	a1,80003d72 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d7c:	0009a503          	lw	a0,0(s3)
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	8b4080e7          	jalr	-1868(ra) # 80003634 <bfree>
    80003d88:	b7ed                	j	80003d72 <itrunc+0x74>
    brelse(bp);
    80003d8a:	8552                	mv	a0,s4
    80003d8c:	fffff097          	auipc	ra,0xfffff
    80003d90:	792080e7          	jalr	1938(ra) # 8000351e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d94:	0809a583          	lw	a1,128(s3)
    80003d98:	0009a503          	lw	a0,0(s3)
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	898080e7          	jalr	-1896(ra) # 80003634 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003da4:	0809a023          	sw	zero,128(s3)
    80003da8:	bf51                	j	80003d3c <itrunc+0x3e>

0000000080003daa <iput>:
{
    80003daa:	1101                	addi	sp,sp,-32
    80003dac:	ec06                	sd	ra,24(sp)
    80003dae:	e822                	sd	s0,16(sp)
    80003db0:	e426                	sd	s1,8(sp)
    80003db2:	e04a                	sd	s2,0(sp)
    80003db4:	1000                	addi	s0,sp,32
    80003db6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003db8:	0001c517          	auipc	a0,0x1c
    80003dbc:	01050513          	addi	a0,a0,16 # 8001fdc8 <itable>
    80003dc0:	ffffd097          	auipc	ra,0xffffd
    80003dc4:	e10080e7          	jalr	-496(ra) # 80000bd0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dc8:	4498                	lw	a4,8(s1)
    80003dca:	4785                	li	a5,1
    80003dcc:	02f70363          	beq	a4,a5,80003df2 <iput+0x48>
  ip->ref--;
    80003dd0:	449c                	lw	a5,8(s1)
    80003dd2:	37fd                	addiw	a5,a5,-1
    80003dd4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003dd6:	0001c517          	auipc	a0,0x1c
    80003dda:	ff250513          	addi	a0,a0,-14 # 8001fdc8 <itable>
    80003dde:	ffffd097          	auipc	ra,0xffffd
    80003de2:	ea6080e7          	jalr	-346(ra) # 80000c84 <release>
}
    80003de6:	60e2                	ld	ra,24(sp)
    80003de8:	6442                	ld	s0,16(sp)
    80003dea:	64a2                	ld	s1,8(sp)
    80003dec:	6902                	ld	s2,0(sp)
    80003dee:	6105                	addi	sp,sp,32
    80003df0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003df2:	40bc                	lw	a5,64(s1)
    80003df4:	dff1                	beqz	a5,80003dd0 <iput+0x26>
    80003df6:	04a49783          	lh	a5,74(s1)
    80003dfa:	fbf9                	bnez	a5,80003dd0 <iput+0x26>
    acquiresleep(&ip->lock);
    80003dfc:	01048913          	addi	s2,s1,16
    80003e00:	854a                	mv	a0,s2
    80003e02:	00001097          	auipc	ra,0x1
    80003e06:	abe080e7          	jalr	-1346(ra) # 800048c0 <acquiresleep>
    release(&itable.lock);
    80003e0a:	0001c517          	auipc	a0,0x1c
    80003e0e:	fbe50513          	addi	a0,a0,-66 # 8001fdc8 <itable>
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	e72080e7          	jalr	-398(ra) # 80000c84 <release>
    itrunc(ip);
    80003e1a:	8526                	mv	a0,s1
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	ee2080e7          	jalr	-286(ra) # 80003cfe <itrunc>
    ip->type = 0;
    80003e24:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e28:	8526                	mv	a0,s1
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	cfa080e7          	jalr	-774(ra) # 80003b24 <iupdate>
    ip->valid = 0;
    80003e32:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e36:	854a                	mv	a0,s2
    80003e38:	00001097          	auipc	ra,0x1
    80003e3c:	ade080e7          	jalr	-1314(ra) # 80004916 <releasesleep>
    acquire(&itable.lock);
    80003e40:	0001c517          	auipc	a0,0x1c
    80003e44:	f8850513          	addi	a0,a0,-120 # 8001fdc8 <itable>
    80003e48:	ffffd097          	auipc	ra,0xffffd
    80003e4c:	d88080e7          	jalr	-632(ra) # 80000bd0 <acquire>
    80003e50:	b741                	j	80003dd0 <iput+0x26>

0000000080003e52 <iunlockput>:
{
    80003e52:	1101                	addi	sp,sp,-32
    80003e54:	ec06                	sd	ra,24(sp)
    80003e56:	e822                	sd	s0,16(sp)
    80003e58:	e426                	sd	s1,8(sp)
    80003e5a:	1000                	addi	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	e54080e7          	jalr	-428(ra) # 80003cb2 <iunlock>
  iput(ip);
    80003e66:	8526                	mv	a0,s1
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	f42080e7          	jalr	-190(ra) # 80003daa <iput>
}
    80003e70:	60e2                	ld	ra,24(sp)
    80003e72:	6442                	ld	s0,16(sp)
    80003e74:	64a2                	ld	s1,8(sp)
    80003e76:	6105                	addi	sp,sp,32
    80003e78:	8082                	ret

0000000080003e7a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e7a:	1141                	addi	sp,sp,-16
    80003e7c:	e422                	sd	s0,8(sp)
    80003e7e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e80:	411c                	lw	a5,0(a0)
    80003e82:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e84:	415c                	lw	a5,4(a0)
    80003e86:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e88:	04451783          	lh	a5,68(a0)
    80003e8c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e90:	04a51783          	lh	a5,74(a0)
    80003e94:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e98:	04c56783          	lwu	a5,76(a0)
    80003e9c:	e99c                	sd	a5,16(a1)
}
    80003e9e:	6422                	ld	s0,8(sp)
    80003ea0:	0141                	addi	sp,sp,16
    80003ea2:	8082                	ret

0000000080003ea4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ea4:	457c                	lw	a5,76(a0)
    80003ea6:	0ed7e963          	bltu	a5,a3,80003f98 <readi+0xf4>
{
    80003eaa:	7159                	addi	sp,sp,-112
    80003eac:	f486                	sd	ra,104(sp)
    80003eae:	f0a2                	sd	s0,96(sp)
    80003eb0:	eca6                	sd	s1,88(sp)
    80003eb2:	e8ca                	sd	s2,80(sp)
    80003eb4:	e4ce                	sd	s3,72(sp)
    80003eb6:	e0d2                	sd	s4,64(sp)
    80003eb8:	fc56                	sd	s5,56(sp)
    80003eba:	f85a                	sd	s6,48(sp)
    80003ebc:	f45e                	sd	s7,40(sp)
    80003ebe:	f062                	sd	s8,32(sp)
    80003ec0:	ec66                	sd	s9,24(sp)
    80003ec2:	e86a                	sd	s10,16(sp)
    80003ec4:	e46e                	sd	s11,8(sp)
    80003ec6:	1880                	addi	s0,sp,112
    80003ec8:	8baa                	mv	s7,a0
    80003eca:	8c2e                	mv	s8,a1
    80003ecc:	8ab2                	mv	s5,a2
    80003ece:	84b6                	mv	s1,a3
    80003ed0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ed2:	9f35                	addw	a4,a4,a3
    return 0;
    80003ed4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003ed6:	0ad76063          	bltu	a4,a3,80003f76 <readi+0xd2>
  if(off + n > ip->size)
    80003eda:	00e7f463          	bgeu	a5,a4,80003ee2 <readi+0x3e>
    n = ip->size - off;
    80003ede:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ee2:	0a0b0963          	beqz	s6,80003f94 <readi+0xf0>
    80003ee6:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ee8:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003eec:	5cfd                	li	s9,-1
    80003eee:	a82d                	j	80003f28 <readi+0x84>
    80003ef0:	020a1d93          	slli	s11,s4,0x20
    80003ef4:	020ddd93          	srli	s11,s11,0x20
    80003ef8:	05890613          	addi	a2,s2,88
    80003efc:	86ee                	mv	a3,s11
    80003efe:	963a                	add	a2,a2,a4
    80003f00:	85d6                	mv	a1,s5
    80003f02:	8562                	mv	a0,s8
    80003f04:	ffffe097          	auipc	ra,0xffffe
    80003f08:	5a0080e7          	jalr	1440(ra) # 800024a4 <either_copyout>
    80003f0c:	05950d63          	beq	a0,s9,80003f66 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f10:	854a                	mv	a0,s2
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	60c080e7          	jalr	1548(ra) # 8000351e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f1a:	013a09bb          	addw	s3,s4,s3
    80003f1e:	009a04bb          	addw	s1,s4,s1
    80003f22:	9aee                	add	s5,s5,s11
    80003f24:	0569f763          	bgeu	s3,s6,80003f72 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003f28:	000ba903          	lw	s2,0(s7)
    80003f2c:	00a4d59b          	srliw	a1,s1,0xa
    80003f30:	855e                	mv	a0,s7
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	8ac080e7          	jalr	-1876(ra) # 800037de <bmap>
    80003f3a:	0005059b          	sext.w	a1,a0
    80003f3e:	854a                	mv	a0,s2
    80003f40:	fffff097          	auipc	ra,0xfffff
    80003f44:	4ae080e7          	jalr	1198(ra) # 800033ee <bread>
    80003f48:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f4a:	3ff4f713          	andi	a4,s1,1023
    80003f4e:	40ed07bb          	subw	a5,s10,a4
    80003f52:	413b06bb          	subw	a3,s6,s3
    80003f56:	8a3e                	mv	s4,a5
    80003f58:	2781                	sext.w	a5,a5
    80003f5a:	0006861b          	sext.w	a2,a3
    80003f5e:	f8f679e3          	bgeu	a2,a5,80003ef0 <readi+0x4c>
    80003f62:	8a36                	mv	s4,a3
    80003f64:	b771                	j	80003ef0 <readi+0x4c>
      brelse(bp);
    80003f66:	854a                	mv	a0,s2
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	5b6080e7          	jalr	1462(ra) # 8000351e <brelse>
      tot = -1;
    80003f70:	59fd                	li	s3,-1
  }
  return tot;
    80003f72:	0009851b          	sext.w	a0,s3
}
    80003f76:	70a6                	ld	ra,104(sp)
    80003f78:	7406                	ld	s0,96(sp)
    80003f7a:	64e6                	ld	s1,88(sp)
    80003f7c:	6946                	ld	s2,80(sp)
    80003f7e:	69a6                	ld	s3,72(sp)
    80003f80:	6a06                	ld	s4,64(sp)
    80003f82:	7ae2                	ld	s5,56(sp)
    80003f84:	7b42                	ld	s6,48(sp)
    80003f86:	7ba2                	ld	s7,40(sp)
    80003f88:	7c02                	ld	s8,32(sp)
    80003f8a:	6ce2                	ld	s9,24(sp)
    80003f8c:	6d42                	ld	s10,16(sp)
    80003f8e:	6da2                	ld	s11,8(sp)
    80003f90:	6165                	addi	sp,sp,112
    80003f92:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f94:	89da                	mv	s3,s6
    80003f96:	bff1                	j	80003f72 <readi+0xce>
    return 0;
    80003f98:	4501                	li	a0,0
}
    80003f9a:	8082                	ret

0000000080003f9c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f9c:	457c                	lw	a5,76(a0)
    80003f9e:	10d7e863          	bltu	a5,a3,800040ae <writei+0x112>
{
    80003fa2:	7159                	addi	sp,sp,-112
    80003fa4:	f486                	sd	ra,104(sp)
    80003fa6:	f0a2                	sd	s0,96(sp)
    80003fa8:	eca6                	sd	s1,88(sp)
    80003faa:	e8ca                	sd	s2,80(sp)
    80003fac:	e4ce                	sd	s3,72(sp)
    80003fae:	e0d2                	sd	s4,64(sp)
    80003fb0:	fc56                	sd	s5,56(sp)
    80003fb2:	f85a                	sd	s6,48(sp)
    80003fb4:	f45e                	sd	s7,40(sp)
    80003fb6:	f062                	sd	s8,32(sp)
    80003fb8:	ec66                	sd	s9,24(sp)
    80003fba:	e86a                	sd	s10,16(sp)
    80003fbc:	e46e                	sd	s11,8(sp)
    80003fbe:	1880                	addi	s0,sp,112
    80003fc0:	8b2a                	mv	s6,a0
    80003fc2:	8c2e                	mv	s8,a1
    80003fc4:	8ab2                	mv	s5,a2
    80003fc6:	8936                	mv	s2,a3
    80003fc8:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003fca:	00e687bb          	addw	a5,a3,a4
    80003fce:	0ed7e263          	bltu	a5,a3,800040b2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003fd2:	00043737          	lui	a4,0x43
    80003fd6:	0ef76063          	bltu	a4,a5,800040b6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fda:	0c0b8863          	beqz	s7,800040aa <writei+0x10e>
    80003fde:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fe0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003fe4:	5cfd                	li	s9,-1
    80003fe6:	a091                	j	8000402a <writei+0x8e>
    80003fe8:	02099d93          	slli	s11,s3,0x20
    80003fec:	020ddd93          	srli	s11,s11,0x20
    80003ff0:	05848513          	addi	a0,s1,88
    80003ff4:	86ee                	mv	a3,s11
    80003ff6:	8656                	mv	a2,s5
    80003ff8:	85e2                	mv	a1,s8
    80003ffa:	953a                	add	a0,a0,a4
    80003ffc:	ffffe097          	auipc	ra,0xffffe
    80004000:	4fe080e7          	jalr	1278(ra) # 800024fa <either_copyin>
    80004004:	07950263          	beq	a0,s9,80004068 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004008:	8526                	mv	a0,s1
    8000400a:	00000097          	auipc	ra,0x0
    8000400e:	798080e7          	jalr	1944(ra) # 800047a2 <log_write>
    brelse(bp);
    80004012:	8526                	mv	a0,s1
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	50a080e7          	jalr	1290(ra) # 8000351e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000401c:	01498a3b          	addw	s4,s3,s4
    80004020:	0129893b          	addw	s2,s3,s2
    80004024:	9aee                	add	s5,s5,s11
    80004026:	057a7663          	bgeu	s4,s7,80004072 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000402a:	000b2483          	lw	s1,0(s6)
    8000402e:	00a9559b          	srliw	a1,s2,0xa
    80004032:	855a                	mv	a0,s6
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	7aa080e7          	jalr	1962(ra) # 800037de <bmap>
    8000403c:	0005059b          	sext.w	a1,a0
    80004040:	8526                	mv	a0,s1
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	3ac080e7          	jalr	940(ra) # 800033ee <bread>
    8000404a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000404c:	3ff97713          	andi	a4,s2,1023
    80004050:	40ed07bb          	subw	a5,s10,a4
    80004054:	414b86bb          	subw	a3,s7,s4
    80004058:	89be                	mv	s3,a5
    8000405a:	2781                	sext.w	a5,a5
    8000405c:	0006861b          	sext.w	a2,a3
    80004060:	f8f674e3          	bgeu	a2,a5,80003fe8 <writei+0x4c>
    80004064:	89b6                	mv	s3,a3
    80004066:	b749                	j	80003fe8 <writei+0x4c>
      brelse(bp);
    80004068:	8526                	mv	a0,s1
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	4b4080e7          	jalr	1204(ra) # 8000351e <brelse>
  }

  if(off > ip->size)
    80004072:	04cb2783          	lw	a5,76(s6)
    80004076:	0127f463          	bgeu	a5,s2,8000407e <writei+0xe2>
    ip->size = off;
    8000407a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000407e:	855a                	mv	a0,s6
    80004080:	00000097          	auipc	ra,0x0
    80004084:	aa4080e7          	jalr	-1372(ra) # 80003b24 <iupdate>

  return tot;
    80004088:	000a051b          	sext.w	a0,s4
}
    8000408c:	70a6                	ld	ra,104(sp)
    8000408e:	7406                	ld	s0,96(sp)
    80004090:	64e6                	ld	s1,88(sp)
    80004092:	6946                	ld	s2,80(sp)
    80004094:	69a6                	ld	s3,72(sp)
    80004096:	6a06                	ld	s4,64(sp)
    80004098:	7ae2                	ld	s5,56(sp)
    8000409a:	7b42                	ld	s6,48(sp)
    8000409c:	7ba2                	ld	s7,40(sp)
    8000409e:	7c02                	ld	s8,32(sp)
    800040a0:	6ce2                	ld	s9,24(sp)
    800040a2:	6d42                	ld	s10,16(sp)
    800040a4:	6da2                	ld	s11,8(sp)
    800040a6:	6165                	addi	sp,sp,112
    800040a8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040aa:	8a5e                	mv	s4,s7
    800040ac:	bfc9                	j	8000407e <writei+0xe2>
    return -1;
    800040ae:	557d                	li	a0,-1
}
    800040b0:	8082                	ret
    return -1;
    800040b2:	557d                	li	a0,-1
    800040b4:	bfe1                	j	8000408c <writei+0xf0>
    return -1;
    800040b6:	557d                	li	a0,-1
    800040b8:	bfd1                	j	8000408c <writei+0xf0>

00000000800040ba <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800040ba:	1141                	addi	sp,sp,-16
    800040bc:	e406                	sd	ra,8(sp)
    800040be:	e022                	sd	s0,0(sp)
    800040c0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800040c2:	4639                	li	a2,14
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	cd8080e7          	jalr	-808(ra) # 80000d9c <strncmp>
}
    800040cc:	60a2                	ld	ra,8(sp)
    800040ce:	6402                	ld	s0,0(sp)
    800040d0:	0141                	addi	sp,sp,16
    800040d2:	8082                	ret

00000000800040d4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800040d4:	7139                	addi	sp,sp,-64
    800040d6:	fc06                	sd	ra,56(sp)
    800040d8:	f822                	sd	s0,48(sp)
    800040da:	f426                	sd	s1,40(sp)
    800040dc:	f04a                	sd	s2,32(sp)
    800040de:	ec4e                	sd	s3,24(sp)
    800040e0:	e852                	sd	s4,16(sp)
    800040e2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800040e4:	04451703          	lh	a4,68(a0)
    800040e8:	4785                	li	a5,1
    800040ea:	00f71a63          	bne	a4,a5,800040fe <dirlookup+0x2a>
    800040ee:	892a                	mv	s2,a0
    800040f0:	89ae                	mv	s3,a1
    800040f2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800040f4:	457c                	lw	a5,76(a0)
    800040f6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800040f8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040fa:	e79d                	bnez	a5,80004128 <dirlookup+0x54>
    800040fc:	a8a5                	j	80004174 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800040fe:	00004517          	auipc	a0,0x4
    80004102:	5e250513          	addi	a0,a0,1506 # 800086e0 <syscalls+0x1d0>
    80004106:	ffffc097          	auipc	ra,0xffffc
    8000410a:	434080e7          	jalr	1076(ra) # 8000053a <panic>
      panic("dirlookup read");
    8000410e:	00004517          	auipc	a0,0x4
    80004112:	5ea50513          	addi	a0,a0,1514 # 800086f8 <syscalls+0x1e8>
    80004116:	ffffc097          	auipc	ra,0xffffc
    8000411a:	424080e7          	jalr	1060(ra) # 8000053a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000411e:	24c1                	addiw	s1,s1,16
    80004120:	04c92783          	lw	a5,76(s2)
    80004124:	04f4f763          	bgeu	s1,a5,80004172 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004128:	4741                	li	a4,16
    8000412a:	86a6                	mv	a3,s1
    8000412c:	fc040613          	addi	a2,s0,-64
    80004130:	4581                	li	a1,0
    80004132:	854a                	mv	a0,s2
    80004134:	00000097          	auipc	ra,0x0
    80004138:	d70080e7          	jalr	-656(ra) # 80003ea4 <readi>
    8000413c:	47c1                	li	a5,16
    8000413e:	fcf518e3          	bne	a0,a5,8000410e <dirlookup+0x3a>
    if(de.inum == 0)
    80004142:	fc045783          	lhu	a5,-64(s0)
    80004146:	dfe1                	beqz	a5,8000411e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004148:	fc240593          	addi	a1,s0,-62
    8000414c:	854e                	mv	a0,s3
    8000414e:	00000097          	auipc	ra,0x0
    80004152:	f6c080e7          	jalr	-148(ra) # 800040ba <namecmp>
    80004156:	f561                	bnez	a0,8000411e <dirlookup+0x4a>
      if(poff)
    80004158:	000a0463          	beqz	s4,80004160 <dirlookup+0x8c>
        *poff = off;
    8000415c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004160:	fc045583          	lhu	a1,-64(s0)
    80004164:	00092503          	lw	a0,0(s2)
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	752080e7          	jalr	1874(ra) # 800038ba <iget>
    80004170:	a011                	j	80004174 <dirlookup+0xa0>
  return 0;
    80004172:	4501                	li	a0,0
}
    80004174:	70e2                	ld	ra,56(sp)
    80004176:	7442                	ld	s0,48(sp)
    80004178:	74a2                	ld	s1,40(sp)
    8000417a:	7902                	ld	s2,32(sp)
    8000417c:	69e2                	ld	s3,24(sp)
    8000417e:	6a42                	ld	s4,16(sp)
    80004180:	6121                	addi	sp,sp,64
    80004182:	8082                	ret

0000000080004184 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004184:	711d                	addi	sp,sp,-96
    80004186:	ec86                	sd	ra,88(sp)
    80004188:	e8a2                	sd	s0,80(sp)
    8000418a:	e4a6                	sd	s1,72(sp)
    8000418c:	e0ca                	sd	s2,64(sp)
    8000418e:	fc4e                	sd	s3,56(sp)
    80004190:	f852                	sd	s4,48(sp)
    80004192:	f456                	sd	s5,40(sp)
    80004194:	f05a                	sd	s6,32(sp)
    80004196:	ec5e                	sd	s7,24(sp)
    80004198:	e862                	sd	s8,16(sp)
    8000419a:	e466                	sd	s9,8(sp)
    8000419c:	e06a                	sd	s10,0(sp)
    8000419e:	1080                	addi	s0,sp,96
    800041a0:	84aa                	mv	s1,a0
    800041a2:	8b2e                	mv	s6,a1
    800041a4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800041a6:	00054703          	lbu	a4,0(a0)
    800041aa:	02f00793          	li	a5,47
    800041ae:	02f70363          	beq	a4,a5,800041d4 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	7e4080e7          	jalr	2020(ra) # 80001996 <myproc>
    800041ba:	15053503          	ld	a0,336(a0)
    800041be:	00000097          	auipc	ra,0x0
    800041c2:	9f4080e7          	jalr	-1548(ra) # 80003bb2 <idup>
    800041c6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800041c8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800041cc:	4cb5                	li	s9,13
  len = path - s;
    800041ce:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800041d0:	4c05                	li	s8,1
    800041d2:	a87d                	j	80004290 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800041d4:	4585                	li	a1,1
    800041d6:	4505                	li	a0,1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	6e2080e7          	jalr	1762(ra) # 800038ba <iget>
    800041e0:	8a2a                	mv	s4,a0
    800041e2:	b7dd                	j	800041c8 <namex+0x44>
      iunlockput(ip);
    800041e4:	8552                	mv	a0,s4
    800041e6:	00000097          	auipc	ra,0x0
    800041ea:	c6c080e7          	jalr	-916(ra) # 80003e52 <iunlockput>
      return 0;
    800041ee:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800041f0:	8552                	mv	a0,s4
    800041f2:	60e6                	ld	ra,88(sp)
    800041f4:	6446                	ld	s0,80(sp)
    800041f6:	64a6                	ld	s1,72(sp)
    800041f8:	6906                	ld	s2,64(sp)
    800041fa:	79e2                	ld	s3,56(sp)
    800041fc:	7a42                	ld	s4,48(sp)
    800041fe:	7aa2                	ld	s5,40(sp)
    80004200:	7b02                	ld	s6,32(sp)
    80004202:	6be2                	ld	s7,24(sp)
    80004204:	6c42                	ld	s8,16(sp)
    80004206:	6ca2                	ld	s9,8(sp)
    80004208:	6d02                	ld	s10,0(sp)
    8000420a:	6125                	addi	sp,sp,96
    8000420c:	8082                	ret
      iunlock(ip);
    8000420e:	8552                	mv	a0,s4
    80004210:	00000097          	auipc	ra,0x0
    80004214:	aa2080e7          	jalr	-1374(ra) # 80003cb2 <iunlock>
      return ip;
    80004218:	bfe1                	j	800041f0 <namex+0x6c>
      iunlockput(ip);
    8000421a:	8552                	mv	a0,s4
    8000421c:	00000097          	auipc	ra,0x0
    80004220:	c36080e7          	jalr	-970(ra) # 80003e52 <iunlockput>
      return 0;
    80004224:	8a4e                	mv	s4,s3
    80004226:	b7e9                	j	800041f0 <namex+0x6c>
  len = path - s;
    80004228:	40998633          	sub	a2,s3,s1
    8000422c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004230:	09acd863          	bge	s9,s10,800042c0 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004234:	4639                	li	a2,14
    80004236:	85a6                	mv	a1,s1
    80004238:	8556                	mv	a0,s5
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	aee080e7          	jalr	-1298(ra) # 80000d28 <memmove>
    80004242:	84ce                	mv	s1,s3
  while(*path == '/')
    80004244:	0004c783          	lbu	a5,0(s1)
    80004248:	01279763          	bne	a5,s2,80004256 <namex+0xd2>
    path++;
    8000424c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000424e:	0004c783          	lbu	a5,0(s1)
    80004252:	ff278de3          	beq	a5,s2,8000424c <namex+0xc8>
    ilock(ip);
    80004256:	8552                	mv	a0,s4
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	998080e7          	jalr	-1640(ra) # 80003bf0 <ilock>
    if(ip->type != T_DIR){
    80004260:	044a1783          	lh	a5,68(s4)
    80004264:	f98790e3          	bne	a5,s8,800041e4 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004268:	000b0563          	beqz	s6,80004272 <namex+0xee>
    8000426c:	0004c783          	lbu	a5,0(s1)
    80004270:	dfd9                	beqz	a5,8000420e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004272:	865e                	mv	a2,s7
    80004274:	85d6                	mv	a1,s5
    80004276:	8552                	mv	a0,s4
    80004278:	00000097          	auipc	ra,0x0
    8000427c:	e5c080e7          	jalr	-420(ra) # 800040d4 <dirlookup>
    80004280:	89aa                	mv	s3,a0
    80004282:	dd41                	beqz	a0,8000421a <namex+0x96>
    iunlockput(ip);
    80004284:	8552                	mv	a0,s4
    80004286:	00000097          	auipc	ra,0x0
    8000428a:	bcc080e7          	jalr	-1076(ra) # 80003e52 <iunlockput>
    ip = next;
    8000428e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004290:	0004c783          	lbu	a5,0(s1)
    80004294:	01279763          	bne	a5,s2,800042a2 <namex+0x11e>
    path++;
    80004298:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000429a:	0004c783          	lbu	a5,0(s1)
    8000429e:	ff278de3          	beq	a5,s2,80004298 <namex+0x114>
  if(*path == 0)
    800042a2:	cb9d                	beqz	a5,800042d8 <namex+0x154>
  while(*path != '/' && *path != 0)
    800042a4:	0004c783          	lbu	a5,0(s1)
    800042a8:	89a6                	mv	s3,s1
  len = path - s;
    800042aa:	8d5e                	mv	s10,s7
    800042ac:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800042ae:	01278963          	beq	a5,s2,800042c0 <namex+0x13c>
    800042b2:	dbbd                	beqz	a5,80004228 <namex+0xa4>
    path++;
    800042b4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800042b6:	0009c783          	lbu	a5,0(s3)
    800042ba:	ff279ce3          	bne	a5,s2,800042b2 <namex+0x12e>
    800042be:	b7ad                	j	80004228 <namex+0xa4>
    memmove(name, s, len);
    800042c0:	2601                	sext.w	a2,a2
    800042c2:	85a6                	mv	a1,s1
    800042c4:	8556                	mv	a0,s5
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	a62080e7          	jalr	-1438(ra) # 80000d28 <memmove>
    name[len] = 0;
    800042ce:	9d56                	add	s10,s10,s5
    800042d0:	000d0023          	sb	zero,0(s10)
    800042d4:	84ce                	mv	s1,s3
    800042d6:	b7bd                	j	80004244 <namex+0xc0>
  if(nameiparent){
    800042d8:	f00b0ce3          	beqz	s6,800041f0 <namex+0x6c>
    iput(ip);
    800042dc:	8552                	mv	a0,s4
    800042de:	00000097          	auipc	ra,0x0
    800042e2:	acc080e7          	jalr	-1332(ra) # 80003daa <iput>
    return 0;
    800042e6:	4a01                	li	s4,0
    800042e8:	b721                	j	800041f0 <namex+0x6c>

00000000800042ea <dirlink>:
{
    800042ea:	7139                	addi	sp,sp,-64
    800042ec:	fc06                	sd	ra,56(sp)
    800042ee:	f822                	sd	s0,48(sp)
    800042f0:	f426                	sd	s1,40(sp)
    800042f2:	f04a                	sd	s2,32(sp)
    800042f4:	ec4e                	sd	s3,24(sp)
    800042f6:	e852                	sd	s4,16(sp)
    800042f8:	0080                	addi	s0,sp,64
    800042fa:	892a                	mv	s2,a0
    800042fc:	8a2e                	mv	s4,a1
    800042fe:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004300:	4601                	li	a2,0
    80004302:	00000097          	auipc	ra,0x0
    80004306:	dd2080e7          	jalr	-558(ra) # 800040d4 <dirlookup>
    8000430a:	e93d                	bnez	a0,80004380 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000430c:	04c92483          	lw	s1,76(s2)
    80004310:	c49d                	beqz	s1,8000433e <dirlink+0x54>
    80004312:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004314:	4741                	li	a4,16
    80004316:	86a6                	mv	a3,s1
    80004318:	fc040613          	addi	a2,s0,-64
    8000431c:	4581                	li	a1,0
    8000431e:	854a                	mv	a0,s2
    80004320:	00000097          	auipc	ra,0x0
    80004324:	b84080e7          	jalr	-1148(ra) # 80003ea4 <readi>
    80004328:	47c1                	li	a5,16
    8000432a:	06f51163          	bne	a0,a5,8000438c <dirlink+0xa2>
    if(de.inum == 0)
    8000432e:	fc045783          	lhu	a5,-64(s0)
    80004332:	c791                	beqz	a5,8000433e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004334:	24c1                	addiw	s1,s1,16
    80004336:	04c92783          	lw	a5,76(s2)
    8000433a:	fcf4ede3          	bltu	s1,a5,80004314 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000433e:	4639                	li	a2,14
    80004340:	85d2                	mv	a1,s4
    80004342:	fc240513          	addi	a0,s0,-62
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	a92080e7          	jalr	-1390(ra) # 80000dd8 <strncpy>
  de.inum = inum;
    8000434e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004352:	4741                	li	a4,16
    80004354:	86a6                	mv	a3,s1
    80004356:	fc040613          	addi	a2,s0,-64
    8000435a:	4581                	li	a1,0
    8000435c:	854a                	mv	a0,s2
    8000435e:	00000097          	auipc	ra,0x0
    80004362:	c3e080e7          	jalr	-962(ra) # 80003f9c <writei>
    80004366:	872a                	mv	a4,a0
    80004368:	47c1                	li	a5,16
  return 0;
    8000436a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000436c:	02f71863          	bne	a4,a5,8000439c <dirlink+0xb2>
}
    80004370:	70e2                	ld	ra,56(sp)
    80004372:	7442                	ld	s0,48(sp)
    80004374:	74a2                	ld	s1,40(sp)
    80004376:	7902                	ld	s2,32(sp)
    80004378:	69e2                	ld	s3,24(sp)
    8000437a:	6a42                	ld	s4,16(sp)
    8000437c:	6121                	addi	sp,sp,64
    8000437e:	8082                	ret
    iput(ip);
    80004380:	00000097          	auipc	ra,0x0
    80004384:	a2a080e7          	jalr	-1494(ra) # 80003daa <iput>
    return -1;
    80004388:	557d                	li	a0,-1
    8000438a:	b7dd                	j	80004370 <dirlink+0x86>
      panic("dirlink read");
    8000438c:	00004517          	auipc	a0,0x4
    80004390:	37c50513          	addi	a0,a0,892 # 80008708 <syscalls+0x1f8>
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	1a6080e7          	jalr	422(ra) # 8000053a <panic>
    panic("dirlink");
    8000439c:	00004517          	auipc	a0,0x4
    800043a0:	47c50513          	addi	a0,a0,1148 # 80008818 <syscalls+0x308>
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	196080e7          	jalr	406(ra) # 8000053a <panic>

00000000800043ac <namei>:

struct inode*
namei(char *path)
{
    800043ac:	1101                	addi	sp,sp,-32
    800043ae:	ec06                	sd	ra,24(sp)
    800043b0:	e822                	sd	s0,16(sp)
    800043b2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043b4:	fe040613          	addi	a2,s0,-32
    800043b8:	4581                	li	a1,0
    800043ba:	00000097          	auipc	ra,0x0
    800043be:	dca080e7          	jalr	-566(ra) # 80004184 <namex>
}
    800043c2:	60e2                	ld	ra,24(sp)
    800043c4:	6442                	ld	s0,16(sp)
    800043c6:	6105                	addi	sp,sp,32
    800043c8:	8082                	ret

00000000800043ca <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800043ca:	1141                	addi	sp,sp,-16
    800043cc:	e406                	sd	ra,8(sp)
    800043ce:	e022                	sd	s0,0(sp)
    800043d0:	0800                	addi	s0,sp,16
    800043d2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800043d4:	4585                	li	a1,1
    800043d6:	00000097          	auipc	ra,0x0
    800043da:	dae080e7          	jalr	-594(ra) # 80004184 <namex>
}
    800043de:	60a2                	ld	ra,8(sp)
    800043e0:	6402                	ld	s0,0(sp)
    800043e2:	0141                	addi	sp,sp,16
    800043e4:	8082                	ret

00000000800043e6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800043e6:	1101                	addi	sp,sp,-32
    800043e8:	ec06                	sd	ra,24(sp)
    800043ea:	e822                	sd	s0,16(sp)
    800043ec:	e426                	sd	s1,8(sp)
    800043ee:	e04a                	sd	s2,0(sp)
    800043f0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800043f2:	0001d917          	auipc	s2,0x1d
    800043f6:	47e90913          	addi	s2,s2,1150 # 80021870 <log>
    800043fa:	01892583          	lw	a1,24(s2)
    800043fe:	02892503          	lw	a0,40(s2)
    80004402:	fffff097          	auipc	ra,0xfffff
    80004406:	fec080e7          	jalr	-20(ra) # 800033ee <bread>
    8000440a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000440c:	02c92683          	lw	a3,44(s2)
    80004410:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004412:	02d05863          	blez	a3,80004442 <write_head+0x5c>
    80004416:	0001d797          	auipc	a5,0x1d
    8000441a:	48a78793          	addi	a5,a5,1162 # 800218a0 <log+0x30>
    8000441e:	05c50713          	addi	a4,a0,92
    80004422:	36fd                	addiw	a3,a3,-1
    80004424:	02069613          	slli	a2,a3,0x20
    80004428:	01e65693          	srli	a3,a2,0x1e
    8000442c:	0001d617          	auipc	a2,0x1d
    80004430:	47860613          	addi	a2,a2,1144 # 800218a4 <log+0x34>
    80004434:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004436:	4390                	lw	a2,0(a5)
    80004438:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000443a:	0791                	addi	a5,a5,4
    8000443c:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000443e:	fed79ce3          	bne	a5,a3,80004436 <write_head+0x50>
  }
  bwrite(buf);
    80004442:	8526                	mv	a0,s1
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	09c080e7          	jalr	156(ra) # 800034e0 <bwrite>
  brelse(buf);
    8000444c:	8526                	mv	a0,s1
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	0d0080e7          	jalr	208(ra) # 8000351e <brelse>
}
    80004456:	60e2                	ld	ra,24(sp)
    80004458:	6442                	ld	s0,16(sp)
    8000445a:	64a2                	ld	s1,8(sp)
    8000445c:	6902                	ld	s2,0(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret

0000000080004462 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004462:	0001d797          	auipc	a5,0x1d
    80004466:	43a7a783          	lw	a5,1082(a5) # 8002189c <log+0x2c>
    8000446a:	0af05d63          	blez	a5,80004524 <install_trans+0xc2>
{
    8000446e:	7139                	addi	sp,sp,-64
    80004470:	fc06                	sd	ra,56(sp)
    80004472:	f822                	sd	s0,48(sp)
    80004474:	f426                	sd	s1,40(sp)
    80004476:	f04a                	sd	s2,32(sp)
    80004478:	ec4e                	sd	s3,24(sp)
    8000447a:	e852                	sd	s4,16(sp)
    8000447c:	e456                	sd	s5,8(sp)
    8000447e:	e05a                	sd	s6,0(sp)
    80004480:	0080                	addi	s0,sp,64
    80004482:	8b2a                	mv	s6,a0
    80004484:	0001da97          	auipc	s5,0x1d
    80004488:	41ca8a93          	addi	s5,s5,1052 # 800218a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000448c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000448e:	0001d997          	auipc	s3,0x1d
    80004492:	3e298993          	addi	s3,s3,994 # 80021870 <log>
    80004496:	a00d                	j	800044b8 <install_trans+0x56>
    brelse(lbuf);
    80004498:	854a                	mv	a0,s2
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	084080e7          	jalr	132(ra) # 8000351e <brelse>
    brelse(dbuf);
    800044a2:	8526                	mv	a0,s1
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	07a080e7          	jalr	122(ra) # 8000351e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ac:	2a05                	addiw	s4,s4,1
    800044ae:	0a91                	addi	s5,s5,4
    800044b0:	02c9a783          	lw	a5,44(s3)
    800044b4:	04fa5e63          	bge	s4,a5,80004510 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044b8:	0189a583          	lw	a1,24(s3)
    800044bc:	014585bb          	addw	a1,a1,s4
    800044c0:	2585                	addiw	a1,a1,1
    800044c2:	0289a503          	lw	a0,40(s3)
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	f28080e7          	jalr	-216(ra) # 800033ee <bread>
    800044ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800044d0:	000aa583          	lw	a1,0(s5)
    800044d4:	0289a503          	lw	a0,40(s3)
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	f16080e7          	jalr	-234(ra) # 800033ee <bread>
    800044e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800044e2:	40000613          	li	a2,1024
    800044e6:	05890593          	addi	a1,s2,88
    800044ea:	05850513          	addi	a0,a0,88
    800044ee:	ffffd097          	auipc	ra,0xffffd
    800044f2:	83a080e7          	jalr	-1990(ra) # 80000d28 <memmove>
    bwrite(dbuf);  // write dst to disk
    800044f6:	8526                	mv	a0,s1
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	fe8080e7          	jalr	-24(ra) # 800034e0 <bwrite>
    if(recovering == 0)
    80004500:	f80b1ce3          	bnez	s6,80004498 <install_trans+0x36>
      bunpin(dbuf);
    80004504:	8526                	mv	a0,s1
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	0f2080e7          	jalr	242(ra) # 800035f8 <bunpin>
    8000450e:	b769                	j	80004498 <install_trans+0x36>
}
    80004510:	70e2                	ld	ra,56(sp)
    80004512:	7442                	ld	s0,48(sp)
    80004514:	74a2                	ld	s1,40(sp)
    80004516:	7902                	ld	s2,32(sp)
    80004518:	69e2                	ld	s3,24(sp)
    8000451a:	6a42                	ld	s4,16(sp)
    8000451c:	6aa2                	ld	s5,8(sp)
    8000451e:	6b02                	ld	s6,0(sp)
    80004520:	6121                	addi	sp,sp,64
    80004522:	8082                	ret
    80004524:	8082                	ret

0000000080004526 <initlog>:
{
    80004526:	7179                	addi	sp,sp,-48
    80004528:	f406                	sd	ra,40(sp)
    8000452a:	f022                	sd	s0,32(sp)
    8000452c:	ec26                	sd	s1,24(sp)
    8000452e:	e84a                	sd	s2,16(sp)
    80004530:	e44e                	sd	s3,8(sp)
    80004532:	1800                	addi	s0,sp,48
    80004534:	892a                	mv	s2,a0
    80004536:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004538:	0001d497          	auipc	s1,0x1d
    8000453c:	33848493          	addi	s1,s1,824 # 80021870 <log>
    80004540:	00004597          	auipc	a1,0x4
    80004544:	1d858593          	addi	a1,a1,472 # 80008718 <syscalls+0x208>
    80004548:	8526                	mv	a0,s1
    8000454a:	ffffc097          	auipc	ra,0xffffc
    8000454e:	5f6080e7          	jalr	1526(ra) # 80000b40 <initlock>
  log.start = sb->logstart;
    80004552:	0149a583          	lw	a1,20(s3)
    80004556:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004558:	0109a783          	lw	a5,16(s3)
    8000455c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000455e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004562:	854a                	mv	a0,s2
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	e8a080e7          	jalr	-374(ra) # 800033ee <bread>
  log.lh.n = lh->n;
    8000456c:	4d34                	lw	a3,88(a0)
    8000456e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004570:	02d05663          	blez	a3,8000459c <initlog+0x76>
    80004574:	05c50793          	addi	a5,a0,92
    80004578:	0001d717          	auipc	a4,0x1d
    8000457c:	32870713          	addi	a4,a4,808 # 800218a0 <log+0x30>
    80004580:	36fd                	addiw	a3,a3,-1
    80004582:	02069613          	slli	a2,a3,0x20
    80004586:	01e65693          	srli	a3,a2,0x1e
    8000458a:	06050613          	addi	a2,a0,96
    8000458e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004590:	4390                	lw	a2,0(a5)
    80004592:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004594:	0791                	addi	a5,a5,4
    80004596:	0711                	addi	a4,a4,4
    80004598:	fed79ce3          	bne	a5,a3,80004590 <initlog+0x6a>
  brelse(buf);
    8000459c:	fffff097          	auipc	ra,0xfffff
    800045a0:	f82080e7          	jalr	-126(ra) # 8000351e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045a4:	4505                	li	a0,1
    800045a6:	00000097          	auipc	ra,0x0
    800045aa:	ebc080e7          	jalr	-324(ra) # 80004462 <install_trans>
  log.lh.n = 0;
    800045ae:	0001d797          	auipc	a5,0x1d
    800045b2:	2e07a723          	sw	zero,750(a5) # 8002189c <log+0x2c>
  write_head(); // clear the log
    800045b6:	00000097          	auipc	ra,0x0
    800045ba:	e30080e7          	jalr	-464(ra) # 800043e6 <write_head>
}
    800045be:	70a2                	ld	ra,40(sp)
    800045c0:	7402                	ld	s0,32(sp)
    800045c2:	64e2                	ld	s1,24(sp)
    800045c4:	6942                	ld	s2,16(sp)
    800045c6:	69a2                	ld	s3,8(sp)
    800045c8:	6145                	addi	sp,sp,48
    800045ca:	8082                	ret

00000000800045cc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800045cc:	1101                	addi	sp,sp,-32
    800045ce:	ec06                	sd	ra,24(sp)
    800045d0:	e822                	sd	s0,16(sp)
    800045d2:	e426                	sd	s1,8(sp)
    800045d4:	e04a                	sd	s2,0(sp)
    800045d6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800045d8:	0001d517          	auipc	a0,0x1d
    800045dc:	29850513          	addi	a0,a0,664 # 80021870 <log>
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	5f0080e7          	jalr	1520(ra) # 80000bd0 <acquire>
  while(1){
    if(log.committing){
    800045e8:	0001d497          	auipc	s1,0x1d
    800045ec:	28848493          	addi	s1,s1,648 # 80021870 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045f0:	4979                	li	s2,30
    800045f2:	a039                	j	80004600 <begin_op+0x34>
      sleep(&log, &log.lock);
    800045f4:	85a6                	mv	a1,s1
    800045f6:	8526                	mv	a0,s1
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	ad8080e7          	jalr	-1320(ra) # 800020d0 <sleep>
    if(log.committing){
    80004600:	50dc                	lw	a5,36(s1)
    80004602:	fbed                	bnez	a5,800045f4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004604:	5098                	lw	a4,32(s1)
    80004606:	2705                	addiw	a4,a4,1
    80004608:	0007069b          	sext.w	a3,a4
    8000460c:	0027179b          	slliw	a5,a4,0x2
    80004610:	9fb9                	addw	a5,a5,a4
    80004612:	0017979b          	slliw	a5,a5,0x1
    80004616:	54d8                	lw	a4,44(s1)
    80004618:	9fb9                	addw	a5,a5,a4
    8000461a:	00f95963          	bge	s2,a5,8000462c <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000461e:	85a6                	mv	a1,s1
    80004620:	8526                	mv	a0,s1
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	aae080e7          	jalr	-1362(ra) # 800020d0 <sleep>
    8000462a:	bfd9                	j	80004600 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000462c:	0001d517          	auipc	a0,0x1d
    80004630:	24450513          	addi	a0,a0,580 # 80021870 <log>
    80004634:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	64e080e7          	jalr	1614(ra) # 80000c84 <release>
      break;
    }
  }
}
    8000463e:	60e2                	ld	ra,24(sp)
    80004640:	6442                	ld	s0,16(sp)
    80004642:	64a2                	ld	s1,8(sp)
    80004644:	6902                	ld	s2,0(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret

000000008000464a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000464a:	7139                	addi	sp,sp,-64
    8000464c:	fc06                	sd	ra,56(sp)
    8000464e:	f822                	sd	s0,48(sp)
    80004650:	f426                	sd	s1,40(sp)
    80004652:	f04a                	sd	s2,32(sp)
    80004654:	ec4e                	sd	s3,24(sp)
    80004656:	e852                	sd	s4,16(sp)
    80004658:	e456                	sd	s5,8(sp)
    8000465a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000465c:	0001d497          	auipc	s1,0x1d
    80004660:	21448493          	addi	s1,s1,532 # 80021870 <log>
    80004664:	8526                	mv	a0,s1
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	56a080e7          	jalr	1386(ra) # 80000bd0 <acquire>
  log.outstanding -= 1;
    8000466e:	509c                	lw	a5,32(s1)
    80004670:	37fd                	addiw	a5,a5,-1
    80004672:	0007891b          	sext.w	s2,a5
    80004676:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004678:	50dc                	lw	a5,36(s1)
    8000467a:	e7b9                	bnez	a5,800046c8 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000467c:	04091e63          	bnez	s2,800046d8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004680:	0001d497          	auipc	s1,0x1d
    80004684:	1f048493          	addi	s1,s1,496 # 80021870 <log>
    80004688:	4785                	li	a5,1
    8000468a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000468c:	8526                	mv	a0,s1
    8000468e:	ffffc097          	auipc	ra,0xffffc
    80004692:	5f6080e7          	jalr	1526(ra) # 80000c84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004696:	54dc                	lw	a5,44(s1)
    80004698:	06f04763          	bgtz	a5,80004706 <end_op+0xbc>
    acquire(&log.lock);
    8000469c:	0001d497          	auipc	s1,0x1d
    800046a0:	1d448493          	addi	s1,s1,468 # 80021870 <log>
    800046a4:	8526                	mv	a0,s1
    800046a6:	ffffc097          	auipc	ra,0xffffc
    800046aa:	52a080e7          	jalr	1322(ra) # 80000bd0 <acquire>
    log.committing = 0;
    800046ae:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046b2:	8526                	mv	a0,s1
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	ba8080e7          	jalr	-1112(ra) # 8000225c <wakeup>
    release(&log.lock);
    800046bc:	8526                	mv	a0,s1
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	5c6080e7          	jalr	1478(ra) # 80000c84 <release>
}
    800046c6:	a03d                	j	800046f4 <end_op+0xaa>
    panic("log.committing");
    800046c8:	00004517          	auipc	a0,0x4
    800046cc:	05850513          	addi	a0,a0,88 # 80008720 <syscalls+0x210>
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	e6a080e7          	jalr	-406(ra) # 8000053a <panic>
    wakeup(&log);
    800046d8:	0001d497          	auipc	s1,0x1d
    800046dc:	19848493          	addi	s1,s1,408 # 80021870 <log>
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	b7a080e7          	jalr	-1158(ra) # 8000225c <wakeup>
  release(&log.lock);
    800046ea:	8526                	mv	a0,s1
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	598080e7          	jalr	1432(ra) # 80000c84 <release>
}
    800046f4:	70e2                	ld	ra,56(sp)
    800046f6:	7442                	ld	s0,48(sp)
    800046f8:	74a2                	ld	s1,40(sp)
    800046fa:	7902                	ld	s2,32(sp)
    800046fc:	69e2                	ld	s3,24(sp)
    800046fe:	6a42                	ld	s4,16(sp)
    80004700:	6aa2                	ld	s5,8(sp)
    80004702:	6121                	addi	sp,sp,64
    80004704:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004706:	0001da97          	auipc	s5,0x1d
    8000470a:	19aa8a93          	addi	s5,s5,410 # 800218a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000470e:	0001da17          	auipc	s4,0x1d
    80004712:	162a0a13          	addi	s4,s4,354 # 80021870 <log>
    80004716:	018a2583          	lw	a1,24(s4)
    8000471a:	012585bb          	addw	a1,a1,s2
    8000471e:	2585                	addiw	a1,a1,1
    80004720:	028a2503          	lw	a0,40(s4)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	cca080e7          	jalr	-822(ra) # 800033ee <bread>
    8000472c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000472e:	000aa583          	lw	a1,0(s5)
    80004732:	028a2503          	lw	a0,40(s4)
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	cb8080e7          	jalr	-840(ra) # 800033ee <bread>
    8000473e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004740:	40000613          	li	a2,1024
    80004744:	05850593          	addi	a1,a0,88
    80004748:	05848513          	addi	a0,s1,88
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	5dc080e7          	jalr	1500(ra) # 80000d28 <memmove>
    bwrite(to);  // write the log
    80004754:	8526                	mv	a0,s1
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	d8a080e7          	jalr	-630(ra) # 800034e0 <bwrite>
    brelse(from);
    8000475e:	854e                	mv	a0,s3
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	dbe080e7          	jalr	-578(ra) # 8000351e <brelse>
    brelse(to);
    80004768:	8526                	mv	a0,s1
    8000476a:	fffff097          	auipc	ra,0xfffff
    8000476e:	db4080e7          	jalr	-588(ra) # 8000351e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004772:	2905                	addiw	s2,s2,1
    80004774:	0a91                	addi	s5,s5,4
    80004776:	02ca2783          	lw	a5,44(s4)
    8000477a:	f8f94ee3          	blt	s2,a5,80004716 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	c68080e7          	jalr	-920(ra) # 800043e6 <write_head>
    install_trans(0); // Now install writes to home locations
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	cda080e7          	jalr	-806(ra) # 80004462 <install_trans>
    log.lh.n = 0;
    80004790:	0001d797          	auipc	a5,0x1d
    80004794:	1007a623          	sw	zero,268(a5) # 8002189c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	c4e080e7          	jalr	-946(ra) # 800043e6 <write_head>
    800047a0:	bdf5                	j	8000469c <end_op+0x52>

00000000800047a2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	e426                	sd	s1,8(sp)
    800047aa:	e04a                	sd	s2,0(sp)
    800047ac:	1000                	addi	s0,sp,32
    800047ae:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047b0:	0001d917          	auipc	s2,0x1d
    800047b4:	0c090913          	addi	s2,s2,192 # 80021870 <log>
    800047b8:	854a                	mv	a0,s2
    800047ba:	ffffc097          	auipc	ra,0xffffc
    800047be:	416080e7          	jalr	1046(ra) # 80000bd0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800047c2:	02c92603          	lw	a2,44(s2)
    800047c6:	47f5                	li	a5,29
    800047c8:	06c7c563          	blt	a5,a2,80004832 <log_write+0x90>
    800047cc:	0001d797          	auipc	a5,0x1d
    800047d0:	0c07a783          	lw	a5,192(a5) # 8002188c <log+0x1c>
    800047d4:	37fd                	addiw	a5,a5,-1
    800047d6:	04f65e63          	bge	a2,a5,80004832 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800047da:	0001d797          	auipc	a5,0x1d
    800047de:	0b67a783          	lw	a5,182(a5) # 80021890 <log+0x20>
    800047e2:	06f05063          	blez	a5,80004842 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047e6:	4781                	li	a5,0
    800047e8:	06c05563          	blez	a2,80004852 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047ec:	44cc                	lw	a1,12(s1)
    800047ee:	0001d717          	auipc	a4,0x1d
    800047f2:	0b270713          	addi	a4,a4,178 # 800218a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047f6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047f8:	4314                	lw	a3,0(a4)
    800047fa:	04b68c63          	beq	a3,a1,80004852 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800047fe:	2785                	addiw	a5,a5,1
    80004800:	0711                	addi	a4,a4,4
    80004802:	fef61be3          	bne	a2,a5,800047f8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004806:	0621                	addi	a2,a2,8
    80004808:	060a                	slli	a2,a2,0x2
    8000480a:	0001d797          	auipc	a5,0x1d
    8000480e:	06678793          	addi	a5,a5,102 # 80021870 <log>
    80004812:	97b2                	add	a5,a5,a2
    80004814:	44d8                	lw	a4,12(s1)
    80004816:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004818:	8526                	mv	a0,s1
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	da2080e7          	jalr	-606(ra) # 800035bc <bpin>
    log.lh.n++;
    80004822:	0001d717          	auipc	a4,0x1d
    80004826:	04e70713          	addi	a4,a4,78 # 80021870 <log>
    8000482a:	575c                	lw	a5,44(a4)
    8000482c:	2785                	addiw	a5,a5,1
    8000482e:	d75c                	sw	a5,44(a4)
    80004830:	a82d                	j	8000486a <log_write+0xc8>
    panic("too big a transaction");
    80004832:	00004517          	auipc	a0,0x4
    80004836:	efe50513          	addi	a0,a0,-258 # 80008730 <syscalls+0x220>
    8000483a:	ffffc097          	auipc	ra,0xffffc
    8000483e:	d00080e7          	jalr	-768(ra) # 8000053a <panic>
    panic("log_write outside of trans");
    80004842:	00004517          	auipc	a0,0x4
    80004846:	f0650513          	addi	a0,a0,-250 # 80008748 <syscalls+0x238>
    8000484a:	ffffc097          	auipc	ra,0xffffc
    8000484e:	cf0080e7          	jalr	-784(ra) # 8000053a <panic>
  log.lh.block[i] = b->blockno;
    80004852:	00878693          	addi	a3,a5,8
    80004856:	068a                	slli	a3,a3,0x2
    80004858:	0001d717          	auipc	a4,0x1d
    8000485c:	01870713          	addi	a4,a4,24 # 80021870 <log>
    80004860:	9736                	add	a4,a4,a3
    80004862:	44d4                	lw	a3,12(s1)
    80004864:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004866:	faf609e3          	beq	a2,a5,80004818 <log_write+0x76>
  }
  release(&log.lock);
    8000486a:	0001d517          	auipc	a0,0x1d
    8000486e:	00650513          	addi	a0,a0,6 # 80021870 <log>
    80004872:	ffffc097          	auipc	ra,0xffffc
    80004876:	412080e7          	jalr	1042(ra) # 80000c84 <release>
}
    8000487a:	60e2                	ld	ra,24(sp)
    8000487c:	6442                	ld	s0,16(sp)
    8000487e:	64a2                	ld	s1,8(sp)
    80004880:	6902                	ld	s2,0(sp)
    80004882:	6105                	addi	sp,sp,32
    80004884:	8082                	ret

0000000080004886 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004886:	1101                	addi	sp,sp,-32
    80004888:	ec06                	sd	ra,24(sp)
    8000488a:	e822                	sd	s0,16(sp)
    8000488c:	e426                	sd	s1,8(sp)
    8000488e:	e04a                	sd	s2,0(sp)
    80004890:	1000                	addi	s0,sp,32
    80004892:	84aa                	mv	s1,a0
    80004894:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004896:	00004597          	auipc	a1,0x4
    8000489a:	ed258593          	addi	a1,a1,-302 # 80008768 <syscalls+0x258>
    8000489e:	0521                	addi	a0,a0,8
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	2a0080e7          	jalr	672(ra) # 80000b40 <initlock>
  lk->name = name;
    800048a8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048b0:	0204a423          	sw	zero,40(s1)
}
    800048b4:	60e2                	ld	ra,24(sp)
    800048b6:	6442                	ld	s0,16(sp)
    800048b8:	64a2                	ld	s1,8(sp)
    800048ba:	6902                	ld	s2,0(sp)
    800048bc:	6105                	addi	sp,sp,32
    800048be:	8082                	ret

00000000800048c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800048c0:	1101                	addi	sp,sp,-32
    800048c2:	ec06                	sd	ra,24(sp)
    800048c4:	e822                	sd	s0,16(sp)
    800048c6:	e426                	sd	s1,8(sp)
    800048c8:	e04a                	sd	s2,0(sp)
    800048ca:	1000                	addi	s0,sp,32
    800048cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048ce:	00850913          	addi	s2,a0,8
    800048d2:	854a                	mv	a0,s2
    800048d4:	ffffc097          	auipc	ra,0xffffc
    800048d8:	2fc080e7          	jalr	764(ra) # 80000bd0 <acquire>
  while (lk->locked) {
    800048dc:	409c                	lw	a5,0(s1)
    800048de:	cb89                	beqz	a5,800048f0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048e0:	85ca                	mv	a1,s2
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffd097          	auipc	ra,0xffffd
    800048e8:	7ec080e7          	jalr	2028(ra) # 800020d0 <sleep>
  while (lk->locked) {
    800048ec:	409c                	lw	a5,0(s1)
    800048ee:	fbed                	bnez	a5,800048e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800048f0:	4785                	li	a5,1
    800048f2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800048f4:	ffffd097          	auipc	ra,0xffffd
    800048f8:	0a2080e7          	jalr	162(ra) # 80001996 <myproc>
    800048fc:	591c                	lw	a5,48(a0)
    800048fe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004900:	854a                	mv	a0,s2
    80004902:	ffffc097          	auipc	ra,0xffffc
    80004906:	382080e7          	jalr	898(ra) # 80000c84 <release>
}
    8000490a:	60e2                	ld	ra,24(sp)
    8000490c:	6442                	ld	s0,16(sp)
    8000490e:	64a2                	ld	s1,8(sp)
    80004910:	6902                	ld	s2,0(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret

0000000080004916 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004916:	1101                	addi	sp,sp,-32
    80004918:	ec06                	sd	ra,24(sp)
    8000491a:	e822                	sd	s0,16(sp)
    8000491c:	e426                	sd	s1,8(sp)
    8000491e:	e04a                	sd	s2,0(sp)
    80004920:	1000                	addi	s0,sp,32
    80004922:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004924:	00850913          	addi	s2,a0,8
    80004928:	854a                	mv	a0,s2
    8000492a:	ffffc097          	auipc	ra,0xffffc
    8000492e:	2a6080e7          	jalr	678(ra) # 80000bd0 <acquire>
  lk->locked = 0;
    80004932:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004936:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	920080e7          	jalr	-1760(ra) # 8000225c <wakeup>
  release(&lk->lk);
    80004944:	854a                	mv	a0,s2
    80004946:	ffffc097          	auipc	ra,0xffffc
    8000494a:	33e080e7          	jalr	830(ra) # 80000c84 <release>
}
    8000494e:	60e2                	ld	ra,24(sp)
    80004950:	6442                	ld	s0,16(sp)
    80004952:	64a2                	ld	s1,8(sp)
    80004954:	6902                	ld	s2,0(sp)
    80004956:	6105                	addi	sp,sp,32
    80004958:	8082                	ret

000000008000495a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000495a:	7179                	addi	sp,sp,-48
    8000495c:	f406                	sd	ra,40(sp)
    8000495e:	f022                	sd	s0,32(sp)
    80004960:	ec26                	sd	s1,24(sp)
    80004962:	e84a                	sd	s2,16(sp)
    80004964:	e44e                	sd	s3,8(sp)
    80004966:	1800                	addi	s0,sp,48
    80004968:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000496a:	00850913          	addi	s2,a0,8
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffc097          	auipc	ra,0xffffc
    80004974:	260080e7          	jalr	608(ra) # 80000bd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004978:	409c                	lw	a5,0(s1)
    8000497a:	ef99                	bnez	a5,80004998 <holdingsleep+0x3e>
    8000497c:	4481                	li	s1,0
  release(&lk->lk);
    8000497e:	854a                	mv	a0,s2
    80004980:	ffffc097          	auipc	ra,0xffffc
    80004984:	304080e7          	jalr	772(ra) # 80000c84 <release>
  return r;
}
    80004988:	8526                	mv	a0,s1
    8000498a:	70a2                	ld	ra,40(sp)
    8000498c:	7402                	ld	s0,32(sp)
    8000498e:	64e2                	ld	s1,24(sp)
    80004990:	6942                	ld	s2,16(sp)
    80004992:	69a2                	ld	s3,8(sp)
    80004994:	6145                	addi	sp,sp,48
    80004996:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004998:	0284a983          	lw	s3,40(s1)
    8000499c:	ffffd097          	auipc	ra,0xffffd
    800049a0:	ffa080e7          	jalr	-6(ra) # 80001996 <myproc>
    800049a4:	5904                	lw	s1,48(a0)
    800049a6:	413484b3          	sub	s1,s1,s3
    800049aa:	0014b493          	seqz	s1,s1
    800049ae:	bfc1                	j	8000497e <holdingsleep+0x24>

00000000800049b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049b0:	1141                	addi	sp,sp,-16
    800049b2:	e406                	sd	ra,8(sp)
    800049b4:	e022                	sd	s0,0(sp)
    800049b6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049b8:	00004597          	auipc	a1,0x4
    800049bc:	dc058593          	addi	a1,a1,-576 # 80008778 <syscalls+0x268>
    800049c0:	0001d517          	auipc	a0,0x1d
    800049c4:	ff850513          	addi	a0,a0,-8 # 800219b8 <ftable>
    800049c8:	ffffc097          	auipc	ra,0xffffc
    800049cc:	178080e7          	jalr	376(ra) # 80000b40 <initlock>
}
    800049d0:	60a2                	ld	ra,8(sp)
    800049d2:	6402                	ld	s0,0(sp)
    800049d4:	0141                	addi	sp,sp,16
    800049d6:	8082                	ret

00000000800049d8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049d8:	1101                	addi	sp,sp,-32
    800049da:	ec06                	sd	ra,24(sp)
    800049dc:	e822                	sd	s0,16(sp)
    800049de:	e426                	sd	s1,8(sp)
    800049e0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049e2:	0001d517          	auipc	a0,0x1d
    800049e6:	fd650513          	addi	a0,a0,-42 # 800219b8 <ftable>
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	1e6080e7          	jalr	486(ra) # 80000bd0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049f2:	0001d497          	auipc	s1,0x1d
    800049f6:	fde48493          	addi	s1,s1,-34 # 800219d0 <ftable+0x18>
    800049fa:	0001e717          	auipc	a4,0x1e
    800049fe:	f7670713          	addi	a4,a4,-138 # 80022970 <ftable+0xfb8>
    if(f->ref == 0){
    80004a02:	40dc                	lw	a5,4(s1)
    80004a04:	cf99                	beqz	a5,80004a22 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a06:	02848493          	addi	s1,s1,40
    80004a0a:	fee49ce3          	bne	s1,a4,80004a02 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a0e:	0001d517          	auipc	a0,0x1d
    80004a12:	faa50513          	addi	a0,a0,-86 # 800219b8 <ftable>
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	26e080e7          	jalr	622(ra) # 80000c84 <release>
  return 0;
    80004a1e:	4481                	li	s1,0
    80004a20:	a819                	j	80004a36 <filealloc+0x5e>
      f->ref = 1;
    80004a22:	4785                	li	a5,1
    80004a24:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a26:	0001d517          	auipc	a0,0x1d
    80004a2a:	f9250513          	addi	a0,a0,-110 # 800219b8 <ftable>
    80004a2e:	ffffc097          	auipc	ra,0xffffc
    80004a32:	256080e7          	jalr	598(ra) # 80000c84 <release>
}
    80004a36:	8526                	mv	a0,s1
    80004a38:	60e2                	ld	ra,24(sp)
    80004a3a:	6442                	ld	s0,16(sp)
    80004a3c:	64a2                	ld	s1,8(sp)
    80004a3e:	6105                	addi	sp,sp,32
    80004a40:	8082                	ret

0000000080004a42 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a42:	1101                	addi	sp,sp,-32
    80004a44:	ec06                	sd	ra,24(sp)
    80004a46:	e822                	sd	s0,16(sp)
    80004a48:	e426                	sd	s1,8(sp)
    80004a4a:	1000                	addi	s0,sp,32
    80004a4c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a4e:	0001d517          	auipc	a0,0x1d
    80004a52:	f6a50513          	addi	a0,a0,-150 # 800219b8 <ftable>
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	17a080e7          	jalr	378(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    80004a5e:	40dc                	lw	a5,4(s1)
    80004a60:	02f05263          	blez	a5,80004a84 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a64:	2785                	addiw	a5,a5,1
    80004a66:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a68:	0001d517          	auipc	a0,0x1d
    80004a6c:	f5050513          	addi	a0,a0,-176 # 800219b8 <ftable>
    80004a70:	ffffc097          	auipc	ra,0xffffc
    80004a74:	214080e7          	jalr	532(ra) # 80000c84 <release>
  return f;
}
    80004a78:	8526                	mv	a0,s1
    80004a7a:	60e2                	ld	ra,24(sp)
    80004a7c:	6442                	ld	s0,16(sp)
    80004a7e:	64a2                	ld	s1,8(sp)
    80004a80:	6105                	addi	sp,sp,32
    80004a82:	8082                	ret
    panic("filedup");
    80004a84:	00004517          	auipc	a0,0x4
    80004a88:	cfc50513          	addi	a0,a0,-772 # 80008780 <syscalls+0x270>
    80004a8c:	ffffc097          	auipc	ra,0xffffc
    80004a90:	aae080e7          	jalr	-1362(ra) # 8000053a <panic>

0000000080004a94 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a94:	7139                	addi	sp,sp,-64
    80004a96:	fc06                	sd	ra,56(sp)
    80004a98:	f822                	sd	s0,48(sp)
    80004a9a:	f426                	sd	s1,40(sp)
    80004a9c:	f04a                	sd	s2,32(sp)
    80004a9e:	ec4e                	sd	s3,24(sp)
    80004aa0:	e852                	sd	s4,16(sp)
    80004aa2:	e456                	sd	s5,8(sp)
    80004aa4:	0080                	addi	s0,sp,64
    80004aa6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004aa8:	0001d517          	auipc	a0,0x1d
    80004aac:	f1050513          	addi	a0,a0,-240 # 800219b8 <ftable>
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	120080e7          	jalr	288(ra) # 80000bd0 <acquire>
  if(f->ref < 1)
    80004ab8:	40dc                	lw	a5,4(s1)
    80004aba:	06f05163          	blez	a5,80004b1c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004abe:	37fd                	addiw	a5,a5,-1
    80004ac0:	0007871b          	sext.w	a4,a5
    80004ac4:	c0dc                	sw	a5,4(s1)
    80004ac6:	06e04363          	bgtz	a4,80004b2c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004aca:	0004a903          	lw	s2,0(s1)
    80004ace:	0094ca83          	lbu	s5,9(s1)
    80004ad2:	0104ba03          	ld	s4,16(s1)
    80004ad6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004ada:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004ade:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004ae2:	0001d517          	auipc	a0,0x1d
    80004ae6:	ed650513          	addi	a0,a0,-298 # 800219b8 <ftable>
    80004aea:	ffffc097          	auipc	ra,0xffffc
    80004aee:	19a080e7          	jalr	410(ra) # 80000c84 <release>

  if(ff.type == FD_PIPE){
    80004af2:	4785                	li	a5,1
    80004af4:	04f90d63          	beq	s2,a5,80004b4e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004af8:	3979                	addiw	s2,s2,-2
    80004afa:	4785                	li	a5,1
    80004afc:	0527e063          	bltu	a5,s2,80004b3c <fileclose+0xa8>
    begin_op();
    80004b00:	00000097          	auipc	ra,0x0
    80004b04:	acc080e7          	jalr	-1332(ra) # 800045cc <begin_op>
    iput(ff.ip);
    80004b08:	854e                	mv	a0,s3
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	2a0080e7          	jalr	672(ra) # 80003daa <iput>
    end_op();
    80004b12:	00000097          	auipc	ra,0x0
    80004b16:	b38080e7          	jalr	-1224(ra) # 8000464a <end_op>
    80004b1a:	a00d                	j	80004b3c <fileclose+0xa8>
    panic("fileclose");
    80004b1c:	00004517          	auipc	a0,0x4
    80004b20:	c6c50513          	addi	a0,a0,-916 # 80008788 <syscalls+0x278>
    80004b24:	ffffc097          	auipc	ra,0xffffc
    80004b28:	a16080e7          	jalr	-1514(ra) # 8000053a <panic>
    release(&ftable.lock);
    80004b2c:	0001d517          	auipc	a0,0x1d
    80004b30:	e8c50513          	addi	a0,a0,-372 # 800219b8 <ftable>
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	150080e7          	jalr	336(ra) # 80000c84 <release>
  }
}
    80004b3c:	70e2                	ld	ra,56(sp)
    80004b3e:	7442                	ld	s0,48(sp)
    80004b40:	74a2                	ld	s1,40(sp)
    80004b42:	7902                	ld	s2,32(sp)
    80004b44:	69e2                	ld	s3,24(sp)
    80004b46:	6a42                	ld	s4,16(sp)
    80004b48:	6aa2                	ld	s5,8(sp)
    80004b4a:	6121                	addi	sp,sp,64
    80004b4c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b4e:	85d6                	mv	a1,s5
    80004b50:	8552                	mv	a0,s4
    80004b52:	00000097          	auipc	ra,0x0
    80004b56:	34c080e7          	jalr	844(ra) # 80004e9e <pipeclose>
    80004b5a:	b7cd                	j	80004b3c <fileclose+0xa8>

0000000080004b5c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b5c:	715d                	addi	sp,sp,-80
    80004b5e:	e486                	sd	ra,72(sp)
    80004b60:	e0a2                	sd	s0,64(sp)
    80004b62:	fc26                	sd	s1,56(sp)
    80004b64:	f84a                	sd	s2,48(sp)
    80004b66:	f44e                	sd	s3,40(sp)
    80004b68:	0880                	addi	s0,sp,80
    80004b6a:	84aa                	mv	s1,a0
    80004b6c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b6e:	ffffd097          	auipc	ra,0xffffd
    80004b72:	e28080e7          	jalr	-472(ra) # 80001996 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b76:	409c                	lw	a5,0(s1)
    80004b78:	37f9                	addiw	a5,a5,-2
    80004b7a:	4705                	li	a4,1
    80004b7c:	04f76763          	bltu	a4,a5,80004bca <filestat+0x6e>
    80004b80:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b82:	6c88                	ld	a0,24(s1)
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	06c080e7          	jalr	108(ra) # 80003bf0 <ilock>
    stati(f->ip, &st);
    80004b8c:	fb840593          	addi	a1,s0,-72
    80004b90:	6c88                	ld	a0,24(s1)
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	2e8080e7          	jalr	744(ra) # 80003e7a <stati>
    iunlock(f->ip);
    80004b9a:	6c88                	ld	a0,24(s1)
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	116080e7          	jalr	278(ra) # 80003cb2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ba4:	46e1                	li	a3,24
    80004ba6:	fb840613          	addi	a2,s0,-72
    80004baa:	85ce                	mv	a1,s3
    80004bac:	05093503          	ld	a0,80(s2)
    80004bb0:	ffffd097          	auipc	ra,0xffffd
    80004bb4:	aaa080e7          	jalr	-1366(ra) # 8000165a <copyout>
    80004bb8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004bbc:	60a6                	ld	ra,72(sp)
    80004bbe:	6406                	ld	s0,64(sp)
    80004bc0:	74e2                	ld	s1,56(sp)
    80004bc2:	7942                	ld	s2,48(sp)
    80004bc4:	79a2                	ld	s3,40(sp)
    80004bc6:	6161                	addi	sp,sp,80
    80004bc8:	8082                	ret
  return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	bfc5                	j	80004bbc <filestat+0x60>

0000000080004bce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004bce:	7179                	addi	sp,sp,-48
    80004bd0:	f406                	sd	ra,40(sp)
    80004bd2:	f022                	sd	s0,32(sp)
    80004bd4:	ec26                	sd	s1,24(sp)
    80004bd6:	e84a                	sd	s2,16(sp)
    80004bd8:	e44e                	sd	s3,8(sp)
    80004bda:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004bdc:	00854783          	lbu	a5,8(a0)
    80004be0:	c3d5                	beqz	a5,80004c84 <fileread+0xb6>
    80004be2:	84aa                	mv	s1,a0
    80004be4:	89ae                	mv	s3,a1
    80004be6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004be8:	411c                	lw	a5,0(a0)
    80004bea:	4705                	li	a4,1
    80004bec:	04e78963          	beq	a5,a4,80004c3e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004bf0:	470d                	li	a4,3
    80004bf2:	04e78d63          	beq	a5,a4,80004c4c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bf6:	4709                	li	a4,2
    80004bf8:	06e79e63          	bne	a5,a4,80004c74 <fileread+0xa6>
    ilock(f->ip);
    80004bfc:	6d08                	ld	a0,24(a0)
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	ff2080e7          	jalr	-14(ra) # 80003bf0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c06:	874a                	mv	a4,s2
    80004c08:	5094                	lw	a3,32(s1)
    80004c0a:	864e                	mv	a2,s3
    80004c0c:	4585                	li	a1,1
    80004c0e:	6c88                	ld	a0,24(s1)
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	294080e7          	jalr	660(ra) # 80003ea4 <readi>
    80004c18:	892a                	mv	s2,a0
    80004c1a:	00a05563          	blez	a0,80004c24 <fileread+0x56>
      f->off += r;
    80004c1e:	509c                	lw	a5,32(s1)
    80004c20:	9fa9                	addw	a5,a5,a0
    80004c22:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c24:	6c88                	ld	a0,24(s1)
    80004c26:	fffff097          	auipc	ra,0xfffff
    80004c2a:	08c080e7          	jalr	140(ra) # 80003cb2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004c2e:	854a                	mv	a0,s2
    80004c30:	70a2                	ld	ra,40(sp)
    80004c32:	7402                	ld	s0,32(sp)
    80004c34:	64e2                	ld	s1,24(sp)
    80004c36:	6942                	ld	s2,16(sp)
    80004c38:	69a2                	ld	s3,8(sp)
    80004c3a:	6145                	addi	sp,sp,48
    80004c3c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c3e:	6908                	ld	a0,16(a0)
    80004c40:	00000097          	auipc	ra,0x0
    80004c44:	3c0080e7          	jalr	960(ra) # 80005000 <piperead>
    80004c48:	892a                	mv	s2,a0
    80004c4a:	b7d5                	j	80004c2e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c4c:	02451783          	lh	a5,36(a0)
    80004c50:	03079693          	slli	a3,a5,0x30
    80004c54:	92c1                	srli	a3,a3,0x30
    80004c56:	4725                	li	a4,9
    80004c58:	02d76863          	bltu	a4,a3,80004c88 <fileread+0xba>
    80004c5c:	0792                	slli	a5,a5,0x4
    80004c5e:	0001d717          	auipc	a4,0x1d
    80004c62:	cba70713          	addi	a4,a4,-838 # 80021918 <devsw>
    80004c66:	97ba                	add	a5,a5,a4
    80004c68:	639c                	ld	a5,0(a5)
    80004c6a:	c38d                	beqz	a5,80004c8c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c6c:	4505                	li	a0,1
    80004c6e:	9782                	jalr	a5
    80004c70:	892a                	mv	s2,a0
    80004c72:	bf75                	j	80004c2e <fileread+0x60>
    panic("fileread");
    80004c74:	00004517          	auipc	a0,0x4
    80004c78:	b2450513          	addi	a0,a0,-1244 # 80008798 <syscalls+0x288>
    80004c7c:	ffffc097          	auipc	ra,0xffffc
    80004c80:	8be080e7          	jalr	-1858(ra) # 8000053a <panic>
    return -1;
    80004c84:	597d                	li	s2,-1
    80004c86:	b765                	j	80004c2e <fileread+0x60>
      return -1;
    80004c88:	597d                	li	s2,-1
    80004c8a:	b755                	j	80004c2e <fileread+0x60>
    80004c8c:	597d                	li	s2,-1
    80004c8e:	b745                	j	80004c2e <fileread+0x60>

0000000080004c90 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004c90:	715d                	addi	sp,sp,-80
    80004c92:	e486                	sd	ra,72(sp)
    80004c94:	e0a2                	sd	s0,64(sp)
    80004c96:	fc26                	sd	s1,56(sp)
    80004c98:	f84a                	sd	s2,48(sp)
    80004c9a:	f44e                	sd	s3,40(sp)
    80004c9c:	f052                	sd	s4,32(sp)
    80004c9e:	ec56                	sd	s5,24(sp)
    80004ca0:	e85a                	sd	s6,16(sp)
    80004ca2:	e45e                	sd	s7,8(sp)
    80004ca4:	e062                	sd	s8,0(sp)
    80004ca6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004ca8:	00954783          	lbu	a5,9(a0)
    80004cac:	10078663          	beqz	a5,80004db8 <filewrite+0x128>
    80004cb0:	892a                	mv	s2,a0
    80004cb2:	8b2e                	mv	s6,a1
    80004cb4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cb6:	411c                	lw	a5,0(a0)
    80004cb8:	4705                	li	a4,1
    80004cba:	02e78263          	beq	a5,a4,80004cde <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cbe:	470d                	li	a4,3
    80004cc0:	02e78663          	beq	a5,a4,80004cec <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cc4:	4709                	li	a4,2
    80004cc6:	0ee79163          	bne	a5,a4,80004da8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004cca:	0ac05d63          	blez	a2,80004d84 <filewrite+0xf4>
    int i = 0;
    80004cce:	4981                	li	s3,0
    80004cd0:	6b85                	lui	s7,0x1
    80004cd2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004cd6:	6c05                	lui	s8,0x1
    80004cd8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004cdc:	a861                	j	80004d74 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004cde:	6908                	ld	a0,16(a0)
    80004ce0:	00000097          	auipc	ra,0x0
    80004ce4:	22e080e7          	jalr	558(ra) # 80004f0e <pipewrite>
    80004ce8:	8a2a                	mv	s4,a0
    80004cea:	a045                	j	80004d8a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004cec:	02451783          	lh	a5,36(a0)
    80004cf0:	03079693          	slli	a3,a5,0x30
    80004cf4:	92c1                	srli	a3,a3,0x30
    80004cf6:	4725                	li	a4,9
    80004cf8:	0cd76263          	bltu	a4,a3,80004dbc <filewrite+0x12c>
    80004cfc:	0792                	slli	a5,a5,0x4
    80004cfe:	0001d717          	auipc	a4,0x1d
    80004d02:	c1a70713          	addi	a4,a4,-998 # 80021918 <devsw>
    80004d06:	97ba                	add	a5,a5,a4
    80004d08:	679c                	ld	a5,8(a5)
    80004d0a:	cbdd                	beqz	a5,80004dc0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004d0c:	4505                	li	a0,1
    80004d0e:	9782                	jalr	a5
    80004d10:	8a2a                	mv	s4,a0
    80004d12:	a8a5                	j	80004d8a <filewrite+0xfa>
    80004d14:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004d18:	00000097          	auipc	ra,0x0
    80004d1c:	8b4080e7          	jalr	-1868(ra) # 800045cc <begin_op>
      ilock(f->ip);
    80004d20:	01893503          	ld	a0,24(s2)
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	ecc080e7          	jalr	-308(ra) # 80003bf0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d2c:	8756                	mv	a4,s5
    80004d2e:	02092683          	lw	a3,32(s2)
    80004d32:	01698633          	add	a2,s3,s6
    80004d36:	4585                	li	a1,1
    80004d38:	01893503          	ld	a0,24(s2)
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	260080e7          	jalr	608(ra) # 80003f9c <writei>
    80004d44:	84aa                	mv	s1,a0
    80004d46:	00a05763          	blez	a0,80004d54 <filewrite+0xc4>
        f->off += r;
    80004d4a:	02092783          	lw	a5,32(s2)
    80004d4e:	9fa9                	addw	a5,a5,a0
    80004d50:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d54:	01893503          	ld	a0,24(s2)
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	f5a080e7          	jalr	-166(ra) # 80003cb2 <iunlock>
      end_op();
    80004d60:	00000097          	auipc	ra,0x0
    80004d64:	8ea080e7          	jalr	-1814(ra) # 8000464a <end_op>

      if(r != n1){
    80004d68:	009a9f63          	bne	s5,s1,80004d86 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004d6c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d70:	0149db63          	bge	s3,s4,80004d86 <filewrite+0xf6>
      int n1 = n - i;
    80004d74:	413a04bb          	subw	s1,s4,s3
    80004d78:	0004879b          	sext.w	a5,s1
    80004d7c:	f8fbdce3          	bge	s7,a5,80004d14 <filewrite+0x84>
    80004d80:	84e2                	mv	s1,s8
    80004d82:	bf49                	j	80004d14 <filewrite+0x84>
    int i = 0;
    80004d84:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d86:	013a1f63          	bne	s4,s3,80004da4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d8a:	8552                	mv	a0,s4
    80004d8c:	60a6                	ld	ra,72(sp)
    80004d8e:	6406                	ld	s0,64(sp)
    80004d90:	74e2                	ld	s1,56(sp)
    80004d92:	7942                	ld	s2,48(sp)
    80004d94:	79a2                	ld	s3,40(sp)
    80004d96:	7a02                	ld	s4,32(sp)
    80004d98:	6ae2                	ld	s5,24(sp)
    80004d9a:	6b42                	ld	s6,16(sp)
    80004d9c:	6ba2                	ld	s7,8(sp)
    80004d9e:	6c02                	ld	s8,0(sp)
    80004da0:	6161                	addi	sp,sp,80
    80004da2:	8082                	ret
    ret = (i == n ? n : -1);
    80004da4:	5a7d                	li	s4,-1
    80004da6:	b7d5                	j	80004d8a <filewrite+0xfa>
    panic("filewrite");
    80004da8:	00004517          	auipc	a0,0x4
    80004dac:	a0050513          	addi	a0,a0,-1536 # 800087a8 <syscalls+0x298>
    80004db0:	ffffb097          	auipc	ra,0xffffb
    80004db4:	78a080e7          	jalr	1930(ra) # 8000053a <panic>
    return -1;
    80004db8:	5a7d                	li	s4,-1
    80004dba:	bfc1                	j	80004d8a <filewrite+0xfa>
      return -1;
    80004dbc:	5a7d                	li	s4,-1
    80004dbe:	b7f1                	j	80004d8a <filewrite+0xfa>
    80004dc0:	5a7d                	li	s4,-1
    80004dc2:	b7e1                	j	80004d8a <filewrite+0xfa>

0000000080004dc4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004dc4:	7179                	addi	sp,sp,-48
    80004dc6:	f406                	sd	ra,40(sp)
    80004dc8:	f022                	sd	s0,32(sp)
    80004dca:	ec26                	sd	s1,24(sp)
    80004dcc:	e84a                	sd	s2,16(sp)
    80004dce:	e44e                	sd	s3,8(sp)
    80004dd0:	e052                	sd	s4,0(sp)
    80004dd2:	1800                	addi	s0,sp,48
    80004dd4:	84aa                	mv	s1,a0
    80004dd6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004dd8:	0005b023          	sd	zero,0(a1)
    80004ddc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004de0:	00000097          	auipc	ra,0x0
    80004de4:	bf8080e7          	jalr	-1032(ra) # 800049d8 <filealloc>
    80004de8:	e088                	sd	a0,0(s1)
    80004dea:	c551                	beqz	a0,80004e76 <pipealloc+0xb2>
    80004dec:	00000097          	auipc	ra,0x0
    80004df0:	bec080e7          	jalr	-1044(ra) # 800049d8 <filealloc>
    80004df4:	00aa3023          	sd	a0,0(s4)
    80004df8:	c92d                	beqz	a0,80004e6a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004dfa:	ffffc097          	auipc	ra,0xffffc
    80004dfe:	ce6080e7          	jalr	-794(ra) # 80000ae0 <kalloc>
    80004e02:	892a                	mv	s2,a0
    80004e04:	c125                	beqz	a0,80004e64 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004e06:	4985                	li	s3,1
    80004e08:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e0c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e10:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e14:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e18:	00004597          	auipc	a1,0x4
    80004e1c:	9a058593          	addi	a1,a1,-1632 # 800087b8 <syscalls+0x2a8>
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	d20080e7          	jalr	-736(ra) # 80000b40 <initlock>
  (*f0)->type = FD_PIPE;
    80004e28:	609c                	ld	a5,0(s1)
    80004e2a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e2e:	609c                	ld	a5,0(s1)
    80004e30:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e34:	609c                	ld	a5,0(s1)
    80004e36:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e3a:	609c                	ld	a5,0(s1)
    80004e3c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e40:	000a3783          	ld	a5,0(s4)
    80004e44:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e48:	000a3783          	ld	a5,0(s4)
    80004e4c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e50:	000a3783          	ld	a5,0(s4)
    80004e54:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e58:	000a3783          	ld	a5,0(s4)
    80004e5c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004e60:	4501                	li	a0,0
    80004e62:	a025                	j	80004e8a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004e64:	6088                	ld	a0,0(s1)
    80004e66:	e501                	bnez	a0,80004e6e <pipealloc+0xaa>
    80004e68:	a039                	j	80004e76 <pipealloc+0xb2>
    80004e6a:	6088                	ld	a0,0(s1)
    80004e6c:	c51d                	beqz	a0,80004e9a <pipealloc+0xd6>
    fileclose(*f0);
    80004e6e:	00000097          	auipc	ra,0x0
    80004e72:	c26080e7          	jalr	-986(ra) # 80004a94 <fileclose>
  if(*f1)
    80004e76:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e7a:	557d                	li	a0,-1
  if(*f1)
    80004e7c:	c799                	beqz	a5,80004e8a <pipealloc+0xc6>
    fileclose(*f1);
    80004e7e:	853e                	mv	a0,a5
    80004e80:	00000097          	auipc	ra,0x0
    80004e84:	c14080e7          	jalr	-1004(ra) # 80004a94 <fileclose>
  return -1;
    80004e88:	557d                	li	a0,-1
}
    80004e8a:	70a2                	ld	ra,40(sp)
    80004e8c:	7402                	ld	s0,32(sp)
    80004e8e:	64e2                	ld	s1,24(sp)
    80004e90:	6942                	ld	s2,16(sp)
    80004e92:	69a2                	ld	s3,8(sp)
    80004e94:	6a02                	ld	s4,0(sp)
    80004e96:	6145                	addi	sp,sp,48
    80004e98:	8082                	ret
  return -1;
    80004e9a:	557d                	li	a0,-1
    80004e9c:	b7fd                	j	80004e8a <pipealloc+0xc6>

0000000080004e9e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e9e:	1101                	addi	sp,sp,-32
    80004ea0:	ec06                	sd	ra,24(sp)
    80004ea2:	e822                	sd	s0,16(sp)
    80004ea4:	e426                	sd	s1,8(sp)
    80004ea6:	e04a                	sd	s2,0(sp)
    80004ea8:	1000                	addi	s0,sp,32
    80004eaa:	84aa                	mv	s1,a0
    80004eac:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004eae:	ffffc097          	auipc	ra,0xffffc
    80004eb2:	d22080e7          	jalr	-734(ra) # 80000bd0 <acquire>
  if(writable){
    80004eb6:	02090d63          	beqz	s2,80004ef0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004eba:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ebe:	21848513          	addi	a0,s1,536
    80004ec2:	ffffd097          	auipc	ra,0xffffd
    80004ec6:	39a080e7          	jalr	922(ra) # 8000225c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004eca:	2204b783          	ld	a5,544(s1)
    80004ece:	eb95                	bnez	a5,80004f02 <pipeclose+0x64>
    release(&pi->lock);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	ffffc097          	auipc	ra,0xffffc
    80004ed6:	db2080e7          	jalr	-590(ra) # 80000c84 <release>
    kfree((char*)pi);
    80004eda:	8526                	mv	a0,s1
    80004edc:	ffffc097          	auipc	ra,0xffffc
    80004ee0:	b06080e7          	jalr	-1274(ra) # 800009e2 <kfree>
  } else
    release(&pi->lock);
}
    80004ee4:	60e2                	ld	ra,24(sp)
    80004ee6:	6442                	ld	s0,16(sp)
    80004ee8:	64a2                	ld	s1,8(sp)
    80004eea:	6902                	ld	s2,0(sp)
    80004eec:	6105                	addi	sp,sp,32
    80004eee:	8082                	ret
    pi->readopen = 0;
    80004ef0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ef4:	21c48513          	addi	a0,s1,540
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	364080e7          	jalr	868(ra) # 8000225c <wakeup>
    80004f00:	b7e9                	j	80004eca <pipeclose+0x2c>
    release(&pi->lock);
    80004f02:	8526                	mv	a0,s1
    80004f04:	ffffc097          	auipc	ra,0xffffc
    80004f08:	d80080e7          	jalr	-640(ra) # 80000c84 <release>
}
    80004f0c:	bfe1                	j	80004ee4 <pipeclose+0x46>

0000000080004f0e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f0e:	711d                	addi	sp,sp,-96
    80004f10:	ec86                	sd	ra,88(sp)
    80004f12:	e8a2                	sd	s0,80(sp)
    80004f14:	e4a6                	sd	s1,72(sp)
    80004f16:	e0ca                	sd	s2,64(sp)
    80004f18:	fc4e                	sd	s3,56(sp)
    80004f1a:	f852                	sd	s4,48(sp)
    80004f1c:	f456                	sd	s5,40(sp)
    80004f1e:	f05a                	sd	s6,32(sp)
    80004f20:	ec5e                	sd	s7,24(sp)
    80004f22:	e862                	sd	s8,16(sp)
    80004f24:	1080                	addi	s0,sp,96
    80004f26:	84aa                	mv	s1,a0
    80004f28:	8aae                	mv	s5,a1
    80004f2a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	a6a080e7          	jalr	-1430(ra) # 80001996 <myproc>
    80004f34:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	c98080e7          	jalr	-872(ra) # 80000bd0 <acquire>
  while(i < n){
    80004f40:	0b405363          	blez	s4,80004fe6 <pipewrite+0xd8>
  int i = 0;
    80004f44:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f46:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f48:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f4c:	21c48b93          	addi	s7,s1,540
    80004f50:	a089                	j	80004f92 <pipewrite+0x84>
      release(&pi->lock);
    80004f52:	8526                	mv	a0,s1
    80004f54:	ffffc097          	auipc	ra,0xffffc
    80004f58:	d30080e7          	jalr	-720(ra) # 80000c84 <release>
      return -1;
    80004f5c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004f5e:	854a                	mv	a0,s2
    80004f60:	60e6                	ld	ra,88(sp)
    80004f62:	6446                	ld	s0,80(sp)
    80004f64:	64a6                	ld	s1,72(sp)
    80004f66:	6906                	ld	s2,64(sp)
    80004f68:	79e2                	ld	s3,56(sp)
    80004f6a:	7a42                	ld	s4,48(sp)
    80004f6c:	7aa2                	ld	s5,40(sp)
    80004f6e:	7b02                	ld	s6,32(sp)
    80004f70:	6be2                	ld	s7,24(sp)
    80004f72:	6c42                	ld	s8,16(sp)
    80004f74:	6125                	addi	sp,sp,96
    80004f76:	8082                	ret
      wakeup(&pi->nread);
    80004f78:	8562                	mv	a0,s8
    80004f7a:	ffffd097          	auipc	ra,0xffffd
    80004f7e:	2e2080e7          	jalr	738(ra) # 8000225c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f82:	85a6                	mv	a1,s1
    80004f84:	855e                	mv	a0,s7
    80004f86:	ffffd097          	auipc	ra,0xffffd
    80004f8a:	14a080e7          	jalr	330(ra) # 800020d0 <sleep>
  while(i < n){
    80004f8e:	05495d63          	bge	s2,s4,80004fe8 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004f92:	2204a783          	lw	a5,544(s1)
    80004f96:	dfd5                	beqz	a5,80004f52 <pipewrite+0x44>
    80004f98:	0289a783          	lw	a5,40(s3)
    80004f9c:	fbdd                	bnez	a5,80004f52 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004f9e:	2184a783          	lw	a5,536(s1)
    80004fa2:	21c4a703          	lw	a4,540(s1)
    80004fa6:	2007879b          	addiw	a5,a5,512
    80004faa:	fcf707e3          	beq	a4,a5,80004f78 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004fae:	4685                	li	a3,1
    80004fb0:	01590633          	add	a2,s2,s5
    80004fb4:	faf40593          	addi	a1,s0,-81
    80004fb8:	0509b503          	ld	a0,80(s3)
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	72a080e7          	jalr	1834(ra) # 800016e6 <copyin>
    80004fc4:	03650263          	beq	a0,s6,80004fe8 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004fc8:	21c4a783          	lw	a5,540(s1)
    80004fcc:	0017871b          	addiw	a4,a5,1
    80004fd0:	20e4ae23          	sw	a4,540(s1)
    80004fd4:	1ff7f793          	andi	a5,a5,511
    80004fd8:	97a6                	add	a5,a5,s1
    80004fda:	faf44703          	lbu	a4,-81(s0)
    80004fde:	00e78c23          	sb	a4,24(a5)
      i++;
    80004fe2:	2905                	addiw	s2,s2,1
    80004fe4:	b76d                	j	80004f8e <pipewrite+0x80>
  int i = 0;
    80004fe6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004fe8:	21848513          	addi	a0,s1,536
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	270080e7          	jalr	624(ra) # 8000225c <wakeup>
  release(&pi->lock);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	c8e080e7          	jalr	-882(ra) # 80000c84 <release>
  return i;
    80004ffe:	b785                	j	80004f5e <pipewrite+0x50>

0000000080005000 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005000:	715d                	addi	sp,sp,-80
    80005002:	e486                	sd	ra,72(sp)
    80005004:	e0a2                	sd	s0,64(sp)
    80005006:	fc26                	sd	s1,56(sp)
    80005008:	f84a                	sd	s2,48(sp)
    8000500a:	f44e                	sd	s3,40(sp)
    8000500c:	f052                	sd	s4,32(sp)
    8000500e:	ec56                	sd	s5,24(sp)
    80005010:	e85a                	sd	s6,16(sp)
    80005012:	0880                	addi	s0,sp,80
    80005014:	84aa                	mv	s1,a0
    80005016:	892e                	mv	s2,a1
    80005018:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000501a:	ffffd097          	auipc	ra,0xffffd
    8000501e:	97c080e7          	jalr	-1668(ra) # 80001996 <myproc>
    80005022:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005024:	8526                	mv	a0,s1
    80005026:	ffffc097          	auipc	ra,0xffffc
    8000502a:	baa080e7          	jalr	-1110(ra) # 80000bd0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000502e:	2184a703          	lw	a4,536(s1)
    80005032:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005036:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000503a:	02f71463          	bne	a4,a5,80005062 <piperead+0x62>
    8000503e:	2244a783          	lw	a5,548(s1)
    80005042:	c385                	beqz	a5,80005062 <piperead+0x62>
    if(pr->killed){
    80005044:	028a2783          	lw	a5,40(s4)
    80005048:	ebc9                	bnez	a5,800050da <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000504a:	85a6                	mv	a1,s1
    8000504c:	854e                	mv	a0,s3
    8000504e:	ffffd097          	auipc	ra,0xffffd
    80005052:	082080e7          	jalr	130(ra) # 800020d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005056:	2184a703          	lw	a4,536(s1)
    8000505a:	21c4a783          	lw	a5,540(s1)
    8000505e:	fef700e3          	beq	a4,a5,8000503e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005062:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005064:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005066:	05505463          	blez	s5,800050ae <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000506a:	2184a783          	lw	a5,536(s1)
    8000506e:	21c4a703          	lw	a4,540(s1)
    80005072:	02f70e63          	beq	a4,a5,800050ae <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005076:	0017871b          	addiw	a4,a5,1
    8000507a:	20e4ac23          	sw	a4,536(s1)
    8000507e:	1ff7f793          	andi	a5,a5,511
    80005082:	97a6                	add	a5,a5,s1
    80005084:	0187c783          	lbu	a5,24(a5)
    80005088:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000508c:	4685                	li	a3,1
    8000508e:	fbf40613          	addi	a2,s0,-65
    80005092:	85ca                	mv	a1,s2
    80005094:	050a3503          	ld	a0,80(s4)
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	5c2080e7          	jalr	1474(ra) # 8000165a <copyout>
    800050a0:	01650763          	beq	a0,s6,800050ae <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050a4:	2985                	addiw	s3,s3,1
    800050a6:	0905                	addi	s2,s2,1
    800050a8:	fd3a91e3          	bne	s5,s3,8000506a <piperead+0x6a>
    800050ac:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800050ae:	21c48513          	addi	a0,s1,540
    800050b2:	ffffd097          	auipc	ra,0xffffd
    800050b6:	1aa080e7          	jalr	426(ra) # 8000225c <wakeup>
  release(&pi->lock);
    800050ba:	8526                	mv	a0,s1
    800050bc:	ffffc097          	auipc	ra,0xffffc
    800050c0:	bc8080e7          	jalr	-1080(ra) # 80000c84 <release>
  return i;
}
    800050c4:	854e                	mv	a0,s3
    800050c6:	60a6                	ld	ra,72(sp)
    800050c8:	6406                	ld	s0,64(sp)
    800050ca:	74e2                	ld	s1,56(sp)
    800050cc:	7942                	ld	s2,48(sp)
    800050ce:	79a2                	ld	s3,40(sp)
    800050d0:	7a02                	ld	s4,32(sp)
    800050d2:	6ae2                	ld	s5,24(sp)
    800050d4:	6b42                	ld	s6,16(sp)
    800050d6:	6161                	addi	sp,sp,80
    800050d8:	8082                	ret
      release(&pi->lock);
    800050da:	8526                	mv	a0,s1
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	ba8080e7          	jalr	-1112(ra) # 80000c84 <release>
      return -1;
    800050e4:	59fd                	li	s3,-1
    800050e6:	bff9                	j	800050c4 <piperead+0xc4>

00000000800050e8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800050e8:	de010113          	addi	sp,sp,-544
    800050ec:	20113c23          	sd	ra,536(sp)
    800050f0:	20813823          	sd	s0,528(sp)
    800050f4:	20913423          	sd	s1,520(sp)
    800050f8:	21213023          	sd	s2,512(sp)
    800050fc:	ffce                	sd	s3,504(sp)
    800050fe:	fbd2                	sd	s4,496(sp)
    80005100:	f7d6                	sd	s5,488(sp)
    80005102:	f3da                	sd	s6,480(sp)
    80005104:	efde                	sd	s7,472(sp)
    80005106:	ebe2                	sd	s8,464(sp)
    80005108:	e7e6                	sd	s9,456(sp)
    8000510a:	e3ea                	sd	s10,448(sp)
    8000510c:	ff6e                	sd	s11,440(sp)
    8000510e:	1400                	addi	s0,sp,544
    80005110:	892a                	mv	s2,a0
    80005112:	dea43423          	sd	a0,-536(s0)
    80005116:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	87c080e7          	jalr	-1924(ra) # 80001996 <myproc>
    80005122:	84aa                	mv	s1,a0

  begin_op();
    80005124:	fffff097          	auipc	ra,0xfffff
    80005128:	4a8080e7          	jalr	1192(ra) # 800045cc <begin_op>

  if((ip = namei(path)) == 0){
    8000512c:	854a                	mv	a0,s2
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	27e080e7          	jalr	638(ra) # 800043ac <namei>
    80005136:	c93d                	beqz	a0,800051ac <exec+0xc4>
    80005138:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	ab6080e7          	jalr	-1354(ra) # 80003bf0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005142:	04000713          	li	a4,64
    80005146:	4681                	li	a3,0
    80005148:	e5040613          	addi	a2,s0,-432
    8000514c:	4581                	li	a1,0
    8000514e:	8556                	mv	a0,s5
    80005150:	fffff097          	auipc	ra,0xfffff
    80005154:	d54080e7          	jalr	-684(ra) # 80003ea4 <readi>
    80005158:	04000793          	li	a5,64
    8000515c:	00f51a63          	bne	a0,a5,80005170 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005160:	e5042703          	lw	a4,-432(s0)
    80005164:	464c47b7          	lui	a5,0x464c4
    80005168:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000516c:	04f70663          	beq	a4,a5,800051b8 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005170:	8556                	mv	a0,s5
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	ce0080e7          	jalr	-800(ra) # 80003e52 <iunlockput>
    end_op();
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	4d0080e7          	jalr	1232(ra) # 8000464a <end_op>
  }
  return -1;
    80005182:	557d                	li	a0,-1
}
    80005184:	21813083          	ld	ra,536(sp)
    80005188:	21013403          	ld	s0,528(sp)
    8000518c:	20813483          	ld	s1,520(sp)
    80005190:	20013903          	ld	s2,512(sp)
    80005194:	79fe                	ld	s3,504(sp)
    80005196:	7a5e                	ld	s4,496(sp)
    80005198:	7abe                	ld	s5,488(sp)
    8000519a:	7b1e                	ld	s6,480(sp)
    8000519c:	6bfe                	ld	s7,472(sp)
    8000519e:	6c5e                	ld	s8,464(sp)
    800051a0:	6cbe                	ld	s9,456(sp)
    800051a2:	6d1e                	ld	s10,448(sp)
    800051a4:	7dfa                	ld	s11,440(sp)
    800051a6:	22010113          	addi	sp,sp,544
    800051aa:	8082                	ret
    end_op();
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	49e080e7          	jalr	1182(ra) # 8000464a <end_op>
    return -1;
    800051b4:	557d                	li	a0,-1
    800051b6:	b7f9                	j	80005184 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800051b8:	8526                	mv	a0,s1
    800051ba:	ffffd097          	auipc	ra,0xffffd
    800051be:	8a0080e7          	jalr	-1888(ra) # 80001a5a <proc_pagetable>
    800051c2:	8b2a                	mv	s6,a0
    800051c4:	d555                	beqz	a0,80005170 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051c6:	e7042783          	lw	a5,-400(s0)
    800051ca:	e8845703          	lhu	a4,-376(s0)
    800051ce:	c735                	beqz	a4,8000523a <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051d0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051d2:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800051d6:	6a05                	lui	s4,0x1
    800051d8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800051dc:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800051e0:	6d85                	lui	s11,0x1
    800051e2:	7d7d                	lui	s10,0xfffff
    800051e4:	ac1d                	j	8000541a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800051e6:	00003517          	auipc	a0,0x3
    800051ea:	5da50513          	addi	a0,a0,1498 # 800087c0 <syscalls+0x2b0>
    800051ee:	ffffb097          	auipc	ra,0xffffb
    800051f2:	34c080e7          	jalr	844(ra) # 8000053a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800051f6:	874a                	mv	a4,s2
    800051f8:	009c86bb          	addw	a3,s9,s1
    800051fc:	4581                	li	a1,0
    800051fe:	8556                	mv	a0,s5
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	ca4080e7          	jalr	-860(ra) # 80003ea4 <readi>
    80005208:	2501                	sext.w	a0,a0
    8000520a:	1aa91863          	bne	s2,a0,800053ba <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000520e:	009d84bb          	addw	s1,s11,s1
    80005212:	013d09bb          	addw	s3,s10,s3
    80005216:	1f74f263          	bgeu	s1,s7,800053fa <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000521a:	02049593          	slli	a1,s1,0x20
    8000521e:	9181                	srli	a1,a1,0x20
    80005220:	95e2                	add	a1,a1,s8
    80005222:	855a                	mv	a0,s6
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	e2e080e7          	jalr	-466(ra) # 80001052 <walkaddr>
    8000522c:	862a                	mv	a2,a0
    if(pa == 0)
    8000522e:	dd45                	beqz	a0,800051e6 <exec+0xfe>
      n = PGSIZE;
    80005230:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005232:	fd49f2e3          	bgeu	s3,s4,800051f6 <exec+0x10e>
      n = sz - i;
    80005236:	894e                	mv	s2,s3
    80005238:	bf7d                	j	800051f6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000523a:	4481                	li	s1,0
  iunlockput(ip);
    8000523c:	8556                	mv	a0,s5
    8000523e:	fffff097          	auipc	ra,0xfffff
    80005242:	c14080e7          	jalr	-1004(ra) # 80003e52 <iunlockput>
  end_op();
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	404080e7          	jalr	1028(ra) # 8000464a <end_op>
  p = myproc();
    8000524e:	ffffc097          	auipc	ra,0xffffc
    80005252:	748080e7          	jalr	1864(ra) # 80001996 <myproc>
    80005256:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005258:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000525c:	6785                	lui	a5,0x1
    8000525e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005260:	97a6                	add	a5,a5,s1
    80005262:	777d                	lui	a4,0xfffff
    80005264:	8ff9                	and	a5,a5,a4
    80005266:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000526a:	6609                	lui	a2,0x2
    8000526c:	963e                	add	a2,a2,a5
    8000526e:	85be                	mv	a1,a5
    80005270:	855a                	mv	a0,s6
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	194080e7          	jalr	404(ra) # 80001406 <uvmalloc>
    8000527a:	8c2a                	mv	s8,a0
  ip = 0;
    8000527c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000527e:	12050e63          	beqz	a0,800053ba <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005282:	75f9                	lui	a1,0xffffe
    80005284:	95aa                	add	a1,a1,a0
    80005286:	855a                	mv	a0,s6
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	3a0080e7          	jalr	928(ra) # 80001628 <uvmclear>
  stackbase = sp - PGSIZE;
    80005290:	7afd                	lui	s5,0xfffff
    80005292:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005294:	df043783          	ld	a5,-528(s0)
    80005298:	6388                	ld	a0,0(a5)
    8000529a:	c925                	beqz	a0,8000530a <exec+0x222>
    8000529c:	e9040993          	addi	s3,s0,-368
    800052a0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800052a4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800052a6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	ba0080e7          	jalr	-1120(ra) # 80000e48 <strlen>
    800052b0:	0015079b          	addiw	a5,a0,1
    800052b4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052b8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800052bc:	13596363          	bltu	s2,s5,800053e2 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052c0:	df043d83          	ld	s11,-528(s0)
    800052c4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800052c8:	8552                	mv	a0,s4
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	b7e080e7          	jalr	-1154(ra) # 80000e48 <strlen>
    800052d2:	0015069b          	addiw	a3,a0,1
    800052d6:	8652                	mv	a2,s4
    800052d8:	85ca                	mv	a1,s2
    800052da:	855a                	mv	a0,s6
    800052dc:	ffffc097          	auipc	ra,0xffffc
    800052e0:	37e080e7          	jalr	894(ra) # 8000165a <copyout>
    800052e4:	10054363          	bltz	a0,800053ea <exec+0x302>
    ustack[argc] = sp;
    800052e8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800052ec:	0485                	addi	s1,s1,1
    800052ee:	008d8793          	addi	a5,s11,8
    800052f2:	def43823          	sd	a5,-528(s0)
    800052f6:	008db503          	ld	a0,8(s11)
    800052fa:	c911                	beqz	a0,8000530e <exec+0x226>
    if(argc >= MAXARG)
    800052fc:	09a1                	addi	s3,s3,8
    800052fe:	fb3c95e3          	bne	s9,s3,800052a8 <exec+0x1c0>
  sz = sz1;
    80005302:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005306:	4a81                	li	s5,0
    80005308:	a84d                	j	800053ba <exec+0x2d2>
  sp = sz;
    8000530a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000530c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000530e:	00349793          	slli	a5,s1,0x3
    80005312:	f9078793          	addi	a5,a5,-112
    80005316:	97a2                	add	a5,a5,s0
    80005318:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000531c:	00148693          	addi	a3,s1,1
    80005320:	068e                	slli	a3,a3,0x3
    80005322:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005326:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000532a:	01597663          	bgeu	s2,s5,80005336 <exec+0x24e>
  sz = sz1;
    8000532e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005332:	4a81                	li	s5,0
    80005334:	a059                	j	800053ba <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005336:	e9040613          	addi	a2,s0,-368
    8000533a:	85ca                	mv	a1,s2
    8000533c:	855a                	mv	a0,s6
    8000533e:	ffffc097          	auipc	ra,0xffffc
    80005342:	31c080e7          	jalr	796(ra) # 8000165a <copyout>
    80005346:	0a054663          	bltz	a0,800053f2 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000534a:	058bb783          	ld	a5,88(s7)
    8000534e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005352:	de843783          	ld	a5,-536(s0)
    80005356:	0007c703          	lbu	a4,0(a5)
    8000535a:	cf11                	beqz	a4,80005376 <exec+0x28e>
    8000535c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000535e:	02f00693          	li	a3,47
    80005362:	a039                	j	80005370 <exec+0x288>
      last = s+1;
    80005364:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005368:	0785                	addi	a5,a5,1
    8000536a:	fff7c703          	lbu	a4,-1(a5)
    8000536e:	c701                	beqz	a4,80005376 <exec+0x28e>
    if(*s == '/')
    80005370:	fed71ce3          	bne	a4,a3,80005368 <exec+0x280>
    80005374:	bfc5                	j	80005364 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005376:	4641                	li	a2,16
    80005378:	de843583          	ld	a1,-536(s0)
    8000537c:	158b8513          	addi	a0,s7,344
    80005380:	ffffc097          	auipc	ra,0xffffc
    80005384:	a96080e7          	jalr	-1386(ra) # 80000e16 <safestrcpy>
  oldpagetable = p->pagetable;
    80005388:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000538c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005390:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005394:	058bb783          	ld	a5,88(s7)
    80005398:	e6843703          	ld	a4,-408(s0)
    8000539c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000539e:	058bb783          	ld	a5,88(s7)
    800053a2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053a6:	85ea                	mv	a1,s10
    800053a8:	ffffc097          	auipc	ra,0xffffc
    800053ac:	74e080e7          	jalr	1870(ra) # 80001af6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053b0:	0004851b          	sext.w	a0,s1
    800053b4:	bbc1                	j	80005184 <exec+0x9c>
    800053b6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800053ba:	df843583          	ld	a1,-520(s0)
    800053be:	855a                	mv	a0,s6
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	736080e7          	jalr	1846(ra) # 80001af6 <proc_freepagetable>
  if(ip){
    800053c8:	da0a94e3          	bnez	s5,80005170 <exec+0x88>
  return -1;
    800053cc:	557d                	li	a0,-1
    800053ce:	bb5d                	j	80005184 <exec+0x9c>
    800053d0:	de943c23          	sd	s1,-520(s0)
    800053d4:	b7dd                	j	800053ba <exec+0x2d2>
    800053d6:	de943c23          	sd	s1,-520(s0)
    800053da:	b7c5                	j	800053ba <exec+0x2d2>
    800053dc:	de943c23          	sd	s1,-520(s0)
    800053e0:	bfe9                	j	800053ba <exec+0x2d2>
  sz = sz1;
    800053e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053e6:	4a81                	li	s5,0
    800053e8:	bfc9                	j	800053ba <exec+0x2d2>
  sz = sz1;
    800053ea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053ee:	4a81                	li	s5,0
    800053f0:	b7e9                	j	800053ba <exec+0x2d2>
  sz = sz1;
    800053f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053f6:	4a81                	li	s5,0
    800053f8:	b7c9                	j	800053ba <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800053fa:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053fe:	e0843783          	ld	a5,-504(s0)
    80005402:	0017869b          	addiw	a3,a5,1
    80005406:	e0d43423          	sd	a3,-504(s0)
    8000540a:	e0043783          	ld	a5,-512(s0)
    8000540e:	0387879b          	addiw	a5,a5,56
    80005412:	e8845703          	lhu	a4,-376(s0)
    80005416:	e2e6d3e3          	bge	a3,a4,8000523c <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000541a:	2781                	sext.w	a5,a5
    8000541c:	e0f43023          	sd	a5,-512(s0)
    80005420:	03800713          	li	a4,56
    80005424:	86be                	mv	a3,a5
    80005426:	e1840613          	addi	a2,s0,-488
    8000542a:	4581                	li	a1,0
    8000542c:	8556                	mv	a0,s5
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	a76080e7          	jalr	-1418(ra) # 80003ea4 <readi>
    80005436:	03800793          	li	a5,56
    8000543a:	f6f51ee3          	bne	a0,a5,800053b6 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000543e:	e1842783          	lw	a5,-488(s0)
    80005442:	4705                	li	a4,1
    80005444:	fae79de3          	bne	a5,a4,800053fe <exec+0x316>
    if(ph.memsz < ph.filesz)
    80005448:	e4043603          	ld	a2,-448(s0)
    8000544c:	e3843783          	ld	a5,-456(s0)
    80005450:	f8f660e3          	bltu	a2,a5,800053d0 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005454:	e2843783          	ld	a5,-472(s0)
    80005458:	963e                	add	a2,a2,a5
    8000545a:	f6f66ee3          	bltu	a2,a5,800053d6 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000545e:	85a6                	mv	a1,s1
    80005460:	855a                	mv	a0,s6
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	fa4080e7          	jalr	-92(ra) # 80001406 <uvmalloc>
    8000546a:	dea43c23          	sd	a0,-520(s0)
    8000546e:	d53d                	beqz	a0,800053dc <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80005470:	e2843c03          	ld	s8,-472(s0)
    80005474:	de043783          	ld	a5,-544(s0)
    80005478:	00fc77b3          	and	a5,s8,a5
    8000547c:	ff9d                	bnez	a5,800053ba <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000547e:	e2042c83          	lw	s9,-480(s0)
    80005482:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005486:	f60b8ae3          	beqz	s7,800053fa <exec+0x312>
    8000548a:	89de                	mv	s3,s7
    8000548c:	4481                	li	s1,0
    8000548e:	b371                	j	8000521a <exec+0x132>

0000000080005490 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005490:	7179                	addi	sp,sp,-48
    80005492:	f406                	sd	ra,40(sp)
    80005494:	f022                	sd	s0,32(sp)
    80005496:	ec26                	sd	s1,24(sp)
    80005498:	e84a                	sd	s2,16(sp)
    8000549a:	1800                	addi	s0,sp,48
    8000549c:	892e                	mv	s2,a1
    8000549e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800054a0:	fdc40593          	addi	a1,s0,-36
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	a9c080e7          	jalr	-1380(ra) # 80002f40 <argint>
    800054ac:	04054063          	bltz	a0,800054ec <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800054b0:	fdc42703          	lw	a4,-36(s0)
    800054b4:	47bd                	li	a5,15
    800054b6:	02e7ed63          	bltu	a5,a4,800054f0 <argfd+0x60>
    800054ba:	ffffc097          	auipc	ra,0xffffc
    800054be:	4dc080e7          	jalr	1244(ra) # 80001996 <myproc>
    800054c2:	fdc42703          	lw	a4,-36(s0)
    800054c6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd901a>
    800054ca:	078e                	slli	a5,a5,0x3
    800054cc:	953e                	add	a0,a0,a5
    800054ce:	611c                	ld	a5,0(a0)
    800054d0:	c395                	beqz	a5,800054f4 <argfd+0x64>
    return -1;
  if(pfd)
    800054d2:	00090463          	beqz	s2,800054da <argfd+0x4a>
    *pfd = fd;
    800054d6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800054da:	4501                	li	a0,0
  if(pf)
    800054dc:	c091                	beqz	s1,800054e0 <argfd+0x50>
    *pf = f;
    800054de:	e09c                	sd	a5,0(s1)
}
    800054e0:	70a2                	ld	ra,40(sp)
    800054e2:	7402                	ld	s0,32(sp)
    800054e4:	64e2                	ld	s1,24(sp)
    800054e6:	6942                	ld	s2,16(sp)
    800054e8:	6145                	addi	sp,sp,48
    800054ea:	8082                	ret
    return -1;
    800054ec:	557d                	li	a0,-1
    800054ee:	bfcd                	j	800054e0 <argfd+0x50>
    return -1;
    800054f0:	557d                	li	a0,-1
    800054f2:	b7fd                	j	800054e0 <argfd+0x50>
    800054f4:	557d                	li	a0,-1
    800054f6:	b7ed                	j	800054e0 <argfd+0x50>

00000000800054f8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054f8:	1101                	addi	sp,sp,-32
    800054fa:	ec06                	sd	ra,24(sp)
    800054fc:	e822                	sd	s0,16(sp)
    800054fe:	e426                	sd	s1,8(sp)
    80005500:	1000                	addi	s0,sp,32
    80005502:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	492080e7          	jalr	1170(ra) # 80001996 <myproc>
    8000550c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000550e:	0d050793          	addi	a5,a0,208
    80005512:	4501                	li	a0,0
    80005514:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005516:	6398                	ld	a4,0(a5)
    80005518:	cb19                	beqz	a4,8000552e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000551a:	2505                	addiw	a0,a0,1
    8000551c:	07a1                	addi	a5,a5,8
    8000551e:	fed51ce3          	bne	a0,a3,80005516 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005522:	557d                	li	a0,-1
}
    80005524:	60e2                	ld	ra,24(sp)
    80005526:	6442                	ld	s0,16(sp)
    80005528:	64a2                	ld	s1,8(sp)
    8000552a:	6105                	addi	sp,sp,32
    8000552c:	8082                	ret
      p->ofile[fd] = f;
    8000552e:	01a50793          	addi	a5,a0,26
    80005532:	078e                	slli	a5,a5,0x3
    80005534:	963e                	add	a2,a2,a5
    80005536:	e204                	sd	s1,0(a2)
      return fd;
    80005538:	b7f5                	j	80005524 <fdalloc+0x2c>

000000008000553a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000553a:	715d                	addi	sp,sp,-80
    8000553c:	e486                	sd	ra,72(sp)
    8000553e:	e0a2                	sd	s0,64(sp)
    80005540:	fc26                	sd	s1,56(sp)
    80005542:	f84a                	sd	s2,48(sp)
    80005544:	f44e                	sd	s3,40(sp)
    80005546:	f052                	sd	s4,32(sp)
    80005548:	ec56                	sd	s5,24(sp)
    8000554a:	0880                	addi	s0,sp,80
    8000554c:	89ae                	mv	s3,a1
    8000554e:	8ab2                	mv	s5,a2
    80005550:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005552:	fb040593          	addi	a1,s0,-80
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	e74080e7          	jalr	-396(ra) # 800043ca <nameiparent>
    8000555e:	892a                	mv	s2,a0
    80005560:	12050e63          	beqz	a0,8000569c <create+0x162>
    return 0;

  ilock(dp);
    80005564:	ffffe097          	auipc	ra,0xffffe
    80005568:	68c080e7          	jalr	1676(ra) # 80003bf0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000556c:	4601                	li	a2,0
    8000556e:	fb040593          	addi	a1,s0,-80
    80005572:	854a                	mv	a0,s2
    80005574:	fffff097          	auipc	ra,0xfffff
    80005578:	b60080e7          	jalr	-1184(ra) # 800040d4 <dirlookup>
    8000557c:	84aa                	mv	s1,a0
    8000557e:	c921                	beqz	a0,800055ce <create+0x94>
    iunlockput(dp);
    80005580:	854a                	mv	a0,s2
    80005582:	fffff097          	auipc	ra,0xfffff
    80005586:	8d0080e7          	jalr	-1840(ra) # 80003e52 <iunlockput>
    ilock(ip);
    8000558a:	8526                	mv	a0,s1
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	664080e7          	jalr	1636(ra) # 80003bf0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005594:	2981                	sext.w	s3,s3
    80005596:	4789                	li	a5,2
    80005598:	02f99463          	bne	s3,a5,800055c0 <create+0x86>
    8000559c:	0444d783          	lhu	a5,68(s1)
    800055a0:	37f9                	addiw	a5,a5,-2
    800055a2:	17c2                	slli	a5,a5,0x30
    800055a4:	93c1                	srli	a5,a5,0x30
    800055a6:	4705                	li	a4,1
    800055a8:	00f76c63          	bltu	a4,a5,800055c0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800055ac:	8526                	mv	a0,s1
    800055ae:	60a6                	ld	ra,72(sp)
    800055b0:	6406                	ld	s0,64(sp)
    800055b2:	74e2                	ld	s1,56(sp)
    800055b4:	7942                	ld	s2,48(sp)
    800055b6:	79a2                	ld	s3,40(sp)
    800055b8:	7a02                	ld	s4,32(sp)
    800055ba:	6ae2                	ld	s5,24(sp)
    800055bc:	6161                	addi	sp,sp,80
    800055be:	8082                	ret
    iunlockput(ip);
    800055c0:	8526                	mv	a0,s1
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	890080e7          	jalr	-1904(ra) # 80003e52 <iunlockput>
    return 0;
    800055ca:	4481                	li	s1,0
    800055cc:	b7c5                	j	800055ac <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800055ce:	85ce                	mv	a1,s3
    800055d0:	00092503          	lw	a0,0(s2)
    800055d4:	ffffe097          	auipc	ra,0xffffe
    800055d8:	482080e7          	jalr	1154(ra) # 80003a56 <ialloc>
    800055dc:	84aa                	mv	s1,a0
    800055de:	c521                	beqz	a0,80005626 <create+0xec>
  ilock(ip);
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	610080e7          	jalr	1552(ra) # 80003bf0 <ilock>
  ip->major = major;
    800055e8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800055ec:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800055f0:	4a05                	li	s4,1
    800055f2:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800055f6:	8526                	mv	a0,s1
    800055f8:	ffffe097          	auipc	ra,0xffffe
    800055fc:	52c080e7          	jalr	1324(ra) # 80003b24 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005600:	2981                	sext.w	s3,s3
    80005602:	03498a63          	beq	s3,s4,80005636 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005606:	40d0                	lw	a2,4(s1)
    80005608:	fb040593          	addi	a1,s0,-80
    8000560c:	854a                	mv	a0,s2
    8000560e:	fffff097          	auipc	ra,0xfffff
    80005612:	cdc080e7          	jalr	-804(ra) # 800042ea <dirlink>
    80005616:	06054b63          	bltz	a0,8000568c <create+0x152>
  iunlockput(dp);
    8000561a:	854a                	mv	a0,s2
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	836080e7          	jalr	-1994(ra) # 80003e52 <iunlockput>
  return ip;
    80005624:	b761                	j	800055ac <create+0x72>
    panic("create: ialloc");
    80005626:	00003517          	auipc	a0,0x3
    8000562a:	1ba50513          	addi	a0,a0,442 # 800087e0 <syscalls+0x2d0>
    8000562e:	ffffb097          	auipc	ra,0xffffb
    80005632:	f0c080e7          	jalr	-244(ra) # 8000053a <panic>
    dp->nlink++;  // for ".."
    80005636:	04a95783          	lhu	a5,74(s2)
    8000563a:	2785                	addiw	a5,a5,1
    8000563c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005640:	854a                	mv	a0,s2
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	4e2080e7          	jalr	1250(ra) # 80003b24 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000564a:	40d0                	lw	a2,4(s1)
    8000564c:	00003597          	auipc	a1,0x3
    80005650:	1a458593          	addi	a1,a1,420 # 800087f0 <syscalls+0x2e0>
    80005654:	8526                	mv	a0,s1
    80005656:	fffff097          	auipc	ra,0xfffff
    8000565a:	c94080e7          	jalr	-876(ra) # 800042ea <dirlink>
    8000565e:	00054f63          	bltz	a0,8000567c <create+0x142>
    80005662:	00492603          	lw	a2,4(s2)
    80005666:	00003597          	auipc	a1,0x3
    8000566a:	19258593          	addi	a1,a1,402 # 800087f8 <syscalls+0x2e8>
    8000566e:	8526                	mv	a0,s1
    80005670:	fffff097          	auipc	ra,0xfffff
    80005674:	c7a080e7          	jalr	-902(ra) # 800042ea <dirlink>
    80005678:	f80557e3          	bgez	a0,80005606 <create+0xcc>
      panic("create dots");
    8000567c:	00003517          	auipc	a0,0x3
    80005680:	18450513          	addi	a0,a0,388 # 80008800 <syscalls+0x2f0>
    80005684:	ffffb097          	auipc	ra,0xffffb
    80005688:	eb6080e7          	jalr	-330(ra) # 8000053a <panic>
    panic("create: dirlink");
    8000568c:	00003517          	auipc	a0,0x3
    80005690:	18450513          	addi	a0,a0,388 # 80008810 <syscalls+0x300>
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	ea6080e7          	jalr	-346(ra) # 8000053a <panic>
    return 0;
    8000569c:	84aa                	mv	s1,a0
    8000569e:	b739                	j	800055ac <create+0x72>

00000000800056a0 <sys_dup>:
{
    800056a0:	7179                	addi	sp,sp,-48
    800056a2:	f406                	sd	ra,40(sp)
    800056a4:	f022                	sd	s0,32(sp)
    800056a6:	ec26                	sd	s1,24(sp)
    800056a8:	e84a                	sd	s2,16(sp)
    800056aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800056ac:	fd840613          	addi	a2,s0,-40
    800056b0:	4581                	li	a1,0
    800056b2:	4501                	li	a0,0
    800056b4:	00000097          	auipc	ra,0x0
    800056b8:	ddc080e7          	jalr	-548(ra) # 80005490 <argfd>
    return -1;
    800056bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800056be:	02054363          	bltz	a0,800056e4 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800056c2:	fd843903          	ld	s2,-40(s0)
    800056c6:	854a                	mv	a0,s2
    800056c8:	00000097          	auipc	ra,0x0
    800056cc:	e30080e7          	jalr	-464(ra) # 800054f8 <fdalloc>
    800056d0:	84aa                	mv	s1,a0
    return -1;
    800056d2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800056d4:	00054863          	bltz	a0,800056e4 <sys_dup+0x44>
  filedup(f);
    800056d8:	854a                	mv	a0,s2
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	368080e7          	jalr	872(ra) # 80004a42 <filedup>
  return fd;
    800056e2:	87a6                	mv	a5,s1
}
    800056e4:	853e                	mv	a0,a5
    800056e6:	70a2                	ld	ra,40(sp)
    800056e8:	7402                	ld	s0,32(sp)
    800056ea:	64e2                	ld	s1,24(sp)
    800056ec:	6942                	ld	s2,16(sp)
    800056ee:	6145                	addi	sp,sp,48
    800056f0:	8082                	ret

00000000800056f2 <sys_read>:
{
    800056f2:	7179                	addi	sp,sp,-48
    800056f4:	f406                	sd	ra,40(sp)
    800056f6:	f022                	sd	s0,32(sp)
    800056f8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800056fa:	fe840613          	addi	a2,s0,-24
    800056fe:	4581                	li	a1,0
    80005700:	4501                	li	a0,0
    80005702:	00000097          	auipc	ra,0x0
    80005706:	d8e080e7          	jalr	-626(ra) # 80005490 <argfd>
    return -1;
    8000570a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000570c:	04054163          	bltz	a0,8000574e <sys_read+0x5c>
    80005710:	fe440593          	addi	a1,s0,-28
    80005714:	4509                	li	a0,2
    80005716:	ffffe097          	auipc	ra,0xffffe
    8000571a:	82a080e7          	jalr	-2006(ra) # 80002f40 <argint>
    return -1;
    8000571e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005720:	02054763          	bltz	a0,8000574e <sys_read+0x5c>
    80005724:	fd840593          	addi	a1,s0,-40
    80005728:	4505                	li	a0,1
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	838080e7          	jalr	-1992(ra) # 80002f62 <argaddr>
    return -1;
    80005732:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005734:	00054d63          	bltz	a0,8000574e <sys_read+0x5c>
  return fileread(f, p, n);
    80005738:	fe442603          	lw	a2,-28(s0)
    8000573c:	fd843583          	ld	a1,-40(s0)
    80005740:	fe843503          	ld	a0,-24(s0)
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	48a080e7          	jalr	1162(ra) # 80004bce <fileread>
    8000574c:	87aa                	mv	a5,a0
}
    8000574e:	853e                	mv	a0,a5
    80005750:	70a2                	ld	ra,40(sp)
    80005752:	7402                	ld	s0,32(sp)
    80005754:	6145                	addi	sp,sp,48
    80005756:	8082                	ret

0000000080005758 <sys_write>:
{
    80005758:	7179                	addi	sp,sp,-48
    8000575a:	f406                	sd	ra,40(sp)
    8000575c:	f022                	sd	s0,32(sp)
    8000575e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005760:	fe840613          	addi	a2,s0,-24
    80005764:	4581                	li	a1,0
    80005766:	4501                	li	a0,0
    80005768:	00000097          	auipc	ra,0x0
    8000576c:	d28080e7          	jalr	-728(ra) # 80005490 <argfd>
    return -1;
    80005770:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005772:	04054163          	bltz	a0,800057b4 <sys_write+0x5c>
    80005776:	fe440593          	addi	a1,s0,-28
    8000577a:	4509                	li	a0,2
    8000577c:	ffffd097          	auipc	ra,0xffffd
    80005780:	7c4080e7          	jalr	1988(ra) # 80002f40 <argint>
    return -1;
    80005784:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005786:	02054763          	bltz	a0,800057b4 <sys_write+0x5c>
    8000578a:	fd840593          	addi	a1,s0,-40
    8000578e:	4505                	li	a0,1
    80005790:	ffffd097          	auipc	ra,0xffffd
    80005794:	7d2080e7          	jalr	2002(ra) # 80002f62 <argaddr>
    return -1;
    80005798:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000579a:	00054d63          	bltz	a0,800057b4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000579e:	fe442603          	lw	a2,-28(s0)
    800057a2:	fd843583          	ld	a1,-40(s0)
    800057a6:	fe843503          	ld	a0,-24(s0)
    800057aa:	fffff097          	auipc	ra,0xfffff
    800057ae:	4e6080e7          	jalr	1254(ra) # 80004c90 <filewrite>
    800057b2:	87aa                	mv	a5,a0
}
    800057b4:	853e                	mv	a0,a5
    800057b6:	70a2                	ld	ra,40(sp)
    800057b8:	7402                	ld	s0,32(sp)
    800057ba:	6145                	addi	sp,sp,48
    800057bc:	8082                	ret

00000000800057be <sys_close>:
{
    800057be:	1101                	addi	sp,sp,-32
    800057c0:	ec06                	sd	ra,24(sp)
    800057c2:	e822                	sd	s0,16(sp)
    800057c4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800057c6:	fe040613          	addi	a2,s0,-32
    800057ca:	fec40593          	addi	a1,s0,-20
    800057ce:	4501                	li	a0,0
    800057d0:	00000097          	auipc	ra,0x0
    800057d4:	cc0080e7          	jalr	-832(ra) # 80005490 <argfd>
    return -1;
    800057d8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800057da:	02054463          	bltz	a0,80005802 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800057de:	ffffc097          	auipc	ra,0xffffc
    800057e2:	1b8080e7          	jalr	440(ra) # 80001996 <myproc>
    800057e6:	fec42783          	lw	a5,-20(s0)
    800057ea:	07e9                	addi	a5,a5,26
    800057ec:	078e                	slli	a5,a5,0x3
    800057ee:	953e                	add	a0,a0,a5
    800057f0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800057f4:	fe043503          	ld	a0,-32(s0)
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	29c080e7          	jalr	668(ra) # 80004a94 <fileclose>
  return 0;
    80005800:	4781                	li	a5,0
}
    80005802:	853e                	mv	a0,a5
    80005804:	60e2                	ld	ra,24(sp)
    80005806:	6442                	ld	s0,16(sp)
    80005808:	6105                	addi	sp,sp,32
    8000580a:	8082                	ret

000000008000580c <sys_fstat>:
{
    8000580c:	1101                	addi	sp,sp,-32
    8000580e:	ec06                	sd	ra,24(sp)
    80005810:	e822                	sd	s0,16(sp)
    80005812:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005814:	fe840613          	addi	a2,s0,-24
    80005818:	4581                	li	a1,0
    8000581a:	4501                	li	a0,0
    8000581c:	00000097          	auipc	ra,0x0
    80005820:	c74080e7          	jalr	-908(ra) # 80005490 <argfd>
    return -1;
    80005824:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005826:	02054563          	bltz	a0,80005850 <sys_fstat+0x44>
    8000582a:	fe040593          	addi	a1,s0,-32
    8000582e:	4505                	li	a0,1
    80005830:	ffffd097          	auipc	ra,0xffffd
    80005834:	732080e7          	jalr	1842(ra) # 80002f62 <argaddr>
    return -1;
    80005838:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000583a:	00054b63          	bltz	a0,80005850 <sys_fstat+0x44>
  return filestat(f, st);
    8000583e:	fe043583          	ld	a1,-32(s0)
    80005842:	fe843503          	ld	a0,-24(s0)
    80005846:	fffff097          	auipc	ra,0xfffff
    8000584a:	316080e7          	jalr	790(ra) # 80004b5c <filestat>
    8000584e:	87aa                	mv	a5,a0
}
    80005850:	853e                	mv	a0,a5
    80005852:	60e2                	ld	ra,24(sp)
    80005854:	6442                	ld	s0,16(sp)
    80005856:	6105                	addi	sp,sp,32
    80005858:	8082                	ret

000000008000585a <sys_link>:
{
    8000585a:	7169                	addi	sp,sp,-304
    8000585c:	f606                	sd	ra,296(sp)
    8000585e:	f222                	sd	s0,288(sp)
    80005860:	ee26                	sd	s1,280(sp)
    80005862:	ea4a                	sd	s2,272(sp)
    80005864:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005866:	08000613          	li	a2,128
    8000586a:	ed040593          	addi	a1,s0,-304
    8000586e:	4501                	li	a0,0
    80005870:	ffffd097          	auipc	ra,0xffffd
    80005874:	714080e7          	jalr	1812(ra) # 80002f84 <argstr>
    return -1;
    80005878:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000587a:	10054e63          	bltz	a0,80005996 <sys_link+0x13c>
    8000587e:	08000613          	li	a2,128
    80005882:	f5040593          	addi	a1,s0,-176
    80005886:	4505                	li	a0,1
    80005888:	ffffd097          	auipc	ra,0xffffd
    8000588c:	6fc080e7          	jalr	1788(ra) # 80002f84 <argstr>
    return -1;
    80005890:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005892:	10054263          	bltz	a0,80005996 <sys_link+0x13c>
  begin_op();
    80005896:	fffff097          	auipc	ra,0xfffff
    8000589a:	d36080e7          	jalr	-714(ra) # 800045cc <begin_op>
  if((ip = namei(old)) == 0){
    8000589e:	ed040513          	addi	a0,s0,-304
    800058a2:	fffff097          	auipc	ra,0xfffff
    800058a6:	b0a080e7          	jalr	-1270(ra) # 800043ac <namei>
    800058aa:	84aa                	mv	s1,a0
    800058ac:	c551                	beqz	a0,80005938 <sys_link+0xde>
  ilock(ip);
    800058ae:	ffffe097          	auipc	ra,0xffffe
    800058b2:	342080e7          	jalr	834(ra) # 80003bf0 <ilock>
  if(ip->type == T_DIR){
    800058b6:	04449703          	lh	a4,68(s1)
    800058ba:	4785                	li	a5,1
    800058bc:	08f70463          	beq	a4,a5,80005944 <sys_link+0xea>
  ip->nlink++;
    800058c0:	04a4d783          	lhu	a5,74(s1)
    800058c4:	2785                	addiw	a5,a5,1
    800058c6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058ca:	8526                	mv	a0,s1
    800058cc:	ffffe097          	auipc	ra,0xffffe
    800058d0:	258080e7          	jalr	600(ra) # 80003b24 <iupdate>
  iunlock(ip);
    800058d4:	8526                	mv	a0,s1
    800058d6:	ffffe097          	auipc	ra,0xffffe
    800058da:	3dc080e7          	jalr	988(ra) # 80003cb2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800058de:	fd040593          	addi	a1,s0,-48
    800058e2:	f5040513          	addi	a0,s0,-176
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	ae4080e7          	jalr	-1308(ra) # 800043ca <nameiparent>
    800058ee:	892a                	mv	s2,a0
    800058f0:	c935                	beqz	a0,80005964 <sys_link+0x10a>
  ilock(dp);
    800058f2:	ffffe097          	auipc	ra,0xffffe
    800058f6:	2fe080e7          	jalr	766(ra) # 80003bf0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800058fa:	00092703          	lw	a4,0(s2)
    800058fe:	409c                	lw	a5,0(s1)
    80005900:	04f71d63          	bne	a4,a5,8000595a <sys_link+0x100>
    80005904:	40d0                	lw	a2,4(s1)
    80005906:	fd040593          	addi	a1,s0,-48
    8000590a:	854a                	mv	a0,s2
    8000590c:	fffff097          	auipc	ra,0xfffff
    80005910:	9de080e7          	jalr	-1570(ra) # 800042ea <dirlink>
    80005914:	04054363          	bltz	a0,8000595a <sys_link+0x100>
  iunlockput(dp);
    80005918:	854a                	mv	a0,s2
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	538080e7          	jalr	1336(ra) # 80003e52 <iunlockput>
  iput(ip);
    80005922:	8526                	mv	a0,s1
    80005924:	ffffe097          	auipc	ra,0xffffe
    80005928:	486080e7          	jalr	1158(ra) # 80003daa <iput>
  end_op();
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	d1e080e7          	jalr	-738(ra) # 8000464a <end_op>
  return 0;
    80005934:	4781                	li	a5,0
    80005936:	a085                	j	80005996 <sys_link+0x13c>
    end_op();
    80005938:	fffff097          	auipc	ra,0xfffff
    8000593c:	d12080e7          	jalr	-750(ra) # 8000464a <end_op>
    return -1;
    80005940:	57fd                	li	a5,-1
    80005942:	a891                	j	80005996 <sys_link+0x13c>
    iunlockput(ip);
    80005944:	8526                	mv	a0,s1
    80005946:	ffffe097          	auipc	ra,0xffffe
    8000594a:	50c080e7          	jalr	1292(ra) # 80003e52 <iunlockput>
    end_op();
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	cfc080e7          	jalr	-772(ra) # 8000464a <end_op>
    return -1;
    80005956:	57fd                	li	a5,-1
    80005958:	a83d                	j	80005996 <sys_link+0x13c>
    iunlockput(dp);
    8000595a:	854a                	mv	a0,s2
    8000595c:	ffffe097          	auipc	ra,0xffffe
    80005960:	4f6080e7          	jalr	1270(ra) # 80003e52 <iunlockput>
  ilock(ip);
    80005964:	8526                	mv	a0,s1
    80005966:	ffffe097          	auipc	ra,0xffffe
    8000596a:	28a080e7          	jalr	650(ra) # 80003bf0 <ilock>
  ip->nlink--;
    8000596e:	04a4d783          	lhu	a5,74(s1)
    80005972:	37fd                	addiw	a5,a5,-1
    80005974:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005978:	8526                	mv	a0,s1
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	1aa080e7          	jalr	426(ra) # 80003b24 <iupdate>
  iunlockput(ip);
    80005982:	8526                	mv	a0,s1
    80005984:	ffffe097          	auipc	ra,0xffffe
    80005988:	4ce080e7          	jalr	1230(ra) # 80003e52 <iunlockput>
  end_op();
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	cbe080e7          	jalr	-834(ra) # 8000464a <end_op>
  return -1;
    80005994:	57fd                	li	a5,-1
}
    80005996:	853e                	mv	a0,a5
    80005998:	70b2                	ld	ra,296(sp)
    8000599a:	7412                	ld	s0,288(sp)
    8000599c:	64f2                	ld	s1,280(sp)
    8000599e:	6952                	ld	s2,272(sp)
    800059a0:	6155                	addi	sp,sp,304
    800059a2:	8082                	ret

00000000800059a4 <sys_unlink>:
{
    800059a4:	7151                	addi	sp,sp,-240
    800059a6:	f586                	sd	ra,232(sp)
    800059a8:	f1a2                	sd	s0,224(sp)
    800059aa:	eda6                	sd	s1,216(sp)
    800059ac:	e9ca                	sd	s2,208(sp)
    800059ae:	e5ce                	sd	s3,200(sp)
    800059b0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800059b2:	08000613          	li	a2,128
    800059b6:	f3040593          	addi	a1,s0,-208
    800059ba:	4501                	li	a0,0
    800059bc:	ffffd097          	auipc	ra,0xffffd
    800059c0:	5c8080e7          	jalr	1480(ra) # 80002f84 <argstr>
    800059c4:	18054163          	bltz	a0,80005b46 <sys_unlink+0x1a2>
  begin_op();
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	c04080e7          	jalr	-1020(ra) # 800045cc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800059d0:	fb040593          	addi	a1,s0,-80
    800059d4:	f3040513          	addi	a0,s0,-208
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	9f2080e7          	jalr	-1550(ra) # 800043ca <nameiparent>
    800059e0:	84aa                	mv	s1,a0
    800059e2:	c979                	beqz	a0,80005ab8 <sys_unlink+0x114>
  ilock(dp);
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	20c080e7          	jalr	524(ra) # 80003bf0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800059ec:	00003597          	auipc	a1,0x3
    800059f0:	e0458593          	addi	a1,a1,-508 # 800087f0 <syscalls+0x2e0>
    800059f4:	fb040513          	addi	a0,s0,-80
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	6c2080e7          	jalr	1730(ra) # 800040ba <namecmp>
    80005a00:	14050a63          	beqz	a0,80005b54 <sys_unlink+0x1b0>
    80005a04:	00003597          	auipc	a1,0x3
    80005a08:	df458593          	addi	a1,a1,-524 # 800087f8 <syscalls+0x2e8>
    80005a0c:	fb040513          	addi	a0,s0,-80
    80005a10:	ffffe097          	auipc	ra,0xffffe
    80005a14:	6aa080e7          	jalr	1706(ra) # 800040ba <namecmp>
    80005a18:	12050e63          	beqz	a0,80005b54 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005a1c:	f2c40613          	addi	a2,s0,-212
    80005a20:	fb040593          	addi	a1,s0,-80
    80005a24:	8526                	mv	a0,s1
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	6ae080e7          	jalr	1710(ra) # 800040d4 <dirlookup>
    80005a2e:	892a                	mv	s2,a0
    80005a30:	12050263          	beqz	a0,80005b54 <sys_unlink+0x1b0>
  ilock(ip);
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	1bc080e7          	jalr	444(ra) # 80003bf0 <ilock>
  if(ip->nlink < 1)
    80005a3c:	04a91783          	lh	a5,74(s2)
    80005a40:	08f05263          	blez	a5,80005ac4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005a44:	04491703          	lh	a4,68(s2)
    80005a48:	4785                	li	a5,1
    80005a4a:	08f70563          	beq	a4,a5,80005ad4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005a4e:	4641                	li	a2,16
    80005a50:	4581                	li	a1,0
    80005a52:	fc040513          	addi	a0,s0,-64
    80005a56:	ffffb097          	auipc	ra,0xffffb
    80005a5a:	276080e7          	jalr	630(ra) # 80000ccc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a5e:	4741                	li	a4,16
    80005a60:	f2c42683          	lw	a3,-212(s0)
    80005a64:	fc040613          	addi	a2,s0,-64
    80005a68:	4581                	li	a1,0
    80005a6a:	8526                	mv	a0,s1
    80005a6c:	ffffe097          	auipc	ra,0xffffe
    80005a70:	530080e7          	jalr	1328(ra) # 80003f9c <writei>
    80005a74:	47c1                	li	a5,16
    80005a76:	0af51563          	bne	a0,a5,80005b20 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a7a:	04491703          	lh	a4,68(s2)
    80005a7e:	4785                	li	a5,1
    80005a80:	0af70863          	beq	a4,a5,80005b30 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a84:	8526                	mv	a0,s1
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	3cc080e7          	jalr	972(ra) # 80003e52 <iunlockput>
  ip->nlink--;
    80005a8e:	04a95783          	lhu	a5,74(s2)
    80005a92:	37fd                	addiw	a5,a5,-1
    80005a94:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a98:	854a                	mv	a0,s2
    80005a9a:	ffffe097          	auipc	ra,0xffffe
    80005a9e:	08a080e7          	jalr	138(ra) # 80003b24 <iupdate>
  iunlockput(ip);
    80005aa2:	854a                	mv	a0,s2
    80005aa4:	ffffe097          	auipc	ra,0xffffe
    80005aa8:	3ae080e7          	jalr	942(ra) # 80003e52 <iunlockput>
  end_op();
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	b9e080e7          	jalr	-1122(ra) # 8000464a <end_op>
  return 0;
    80005ab4:	4501                	li	a0,0
    80005ab6:	a84d                	j	80005b68 <sys_unlink+0x1c4>
    end_op();
    80005ab8:	fffff097          	auipc	ra,0xfffff
    80005abc:	b92080e7          	jalr	-1134(ra) # 8000464a <end_op>
    return -1;
    80005ac0:	557d                	li	a0,-1
    80005ac2:	a05d                	j	80005b68 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005ac4:	00003517          	auipc	a0,0x3
    80005ac8:	d5c50513          	addi	a0,a0,-676 # 80008820 <syscalls+0x310>
    80005acc:	ffffb097          	auipc	ra,0xffffb
    80005ad0:	a6e080e7          	jalr	-1426(ra) # 8000053a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ad4:	04c92703          	lw	a4,76(s2)
    80005ad8:	02000793          	li	a5,32
    80005adc:	f6e7f9e3          	bgeu	a5,a4,80005a4e <sys_unlink+0xaa>
    80005ae0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ae4:	4741                	li	a4,16
    80005ae6:	86ce                	mv	a3,s3
    80005ae8:	f1840613          	addi	a2,s0,-232
    80005aec:	4581                	li	a1,0
    80005aee:	854a                	mv	a0,s2
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	3b4080e7          	jalr	948(ra) # 80003ea4 <readi>
    80005af8:	47c1                	li	a5,16
    80005afa:	00f51b63          	bne	a0,a5,80005b10 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005afe:	f1845783          	lhu	a5,-232(s0)
    80005b02:	e7a1                	bnez	a5,80005b4a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b04:	29c1                	addiw	s3,s3,16
    80005b06:	04c92783          	lw	a5,76(s2)
    80005b0a:	fcf9ede3          	bltu	s3,a5,80005ae4 <sys_unlink+0x140>
    80005b0e:	b781                	j	80005a4e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005b10:	00003517          	auipc	a0,0x3
    80005b14:	d2850513          	addi	a0,a0,-728 # 80008838 <syscalls+0x328>
    80005b18:	ffffb097          	auipc	ra,0xffffb
    80005b1c:	a22080e7          	jalr	-1502(ra) # 8000053a <panic>
    panic("unlink: writei");
    80005b20:	00003517          	auipc	a0,0x3
    80005b24:	d3050513          	addi	a0,a0,-720 # 80008850 <syscalls+0x340>
    80005b28:	ffffb097          	auipc	ra,0xffffb
    80005b2c:	a12080e7          	jalr	-1518(ra) # 8000053a <panic>
    dp->nlink--;
    80005b30:	04a4d783          	lhu	a5,74(s1)
    80005b34:	37fd                	addiw	a5,a5,-1
    80005b36:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b3a:	8526                	mv	a0,s1
    80005b3c:	ffffe097          	auipc	ra,0xffffe
    80005b40:	fe8080e7          	jalr	-24(ra) # 80003b24 <iupdate>
    80005b44:	b781                	j	80005a84 <sys_unlink+0xe0>
    return -1;
    80005b46:	557d                	li	a0,-1
    80005b48:	a005                	j	80005b68 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005b4a:	854a                	mv	a0,s2
    80005b4c:	ffffe097          	auipc	ra,0xffffe
    80005b50:	306080e7          	jalr	774(ra) # 80003e52 <iunlockput>
  iunlockput(dp);
    80005b54:	8526                	mv	a0,s1
    80005b56:	ffffe097          	auipc	ra,0xffffe
    80005b5a:	2fc080e7          	jalr	764(ra) # 80003e52 <iunlockput>
  end_op();
    80005b5e:	fffff097          	auipc	ra,0xfffff
    80005b62:	aec080e7          	jalr	-1300(ra) # 8000464a <end_op>
  return -1;
    80005b66:	557d                	li	a0,-1
}
    80005b68:	70ae                	ld	ra,232(sp)
    80005b6a:	740e                	ld	s0,224(sp)
    80005b6c:	64ee                	ld	s1,216(sp)
    80005b6e:	694e                	ld	s2,208(sp)
    80005b70:	69ae                	ld	s3,200(sp)
    80005b72:	616d                	addi	sp,sp,240
    80005b74:	8082                	ret

0000000080005b76 <sys_open>:

uint64
sys_open(void)
{
    80005b76:	7131                	addi	sp,sp,-192
    80005b78:	fd06                	sd	ra,184(sp)
    80005b7a:	f922                	sd	s0,176(sp)
    80005b7c:	f526                	sd	s1,168(sp)
    80005b7e:	f14a                	sd	s2,160(sp)
    80005b80:	ed4e                	sd	s3,152(sp)
    80005b82:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b84:	08000613          	li	a2,128
    80005b88:	f5040593          	addi	a1,s0,-176
    80005b8c:	4501                	li	a0,0
    80005b8e:	ffffd097          	auipc	ra,0xffffd
    80005b92:	3f6080e7          	jalr	1014(ra) # 80002f84 <argstr>
    return -1;
    80005b96:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005b98:	0c054163          	bltz	a0,80005c5a <sys_open+0xe4>
    80005b9c:	f4c40593          	addi	a1,s0,-180
    80005ba0:	4505                	li	a0,1
    80005ba2:	ffffd097          	auipc	ra,0xffffd
    80005ba6:	39e080e7          	jalr	926(ra) # 80002f40 <argint>
    80005baa:	0a054863          	bltz	a0,80005c5a <sys_open+0xe4>

  begin_op();
    80005bae:	fffff097          	auipc	ra,0xfffff
    80005bb2:	a1e080e7          	jalr	-1506(ra) # 800045cc <begin_op>

  if(omode & O_CREATE){
    80005bb6:	f4c42783          	lw	a5,-180(s0)
    80005bba:	2007f793          	andi	a5,a5,512
    80005bbe:	cbdd                	beqz	a5,80005c74 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005bc0:	4681                	li	a3,0
    80005bc2:	4601                	li	a2,0
    80005bc4:	4589                	li	a1,2
    80005bc6:	f5040513          	addi	a0,s0,-176
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	970080e7          	jalr	-1680(ra) # 8000553a <create>
    80005bd2:	892a                	mv	s2,a0
    if(ip == 0){
    80005bd4:	c959                	beqz	a0,80005c6a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005bd6:	04491703          	lh	a4,68(s2)
    80005bda:	478d                	li	a5,3
    80005bdc:	00f71763          	bne	a4,a5,80005bea <sys_open+0x74>
    80005be0:	04695703          	lhu	a4,70(s2)
    80005be4:	47a5                	li	a5,9
    80005be6:	0ce7ec63          	bltu	a5,a4,80005cbe <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005bea:	fffff097          	auipc	ra,0xfffff
    80005bee:	dee080e7          	jalr	-530(ra) # 800049d8 <filealloc>
    80005bf2:	89aa                	mv	s3,a0
    80005bf4:	10050263          	beqz	a0,80005cf8 <sys_open+0x182>
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	900080e7          	jalr	-1792(ra) # 800054f8 <fdalloc>
    80005c00:	84aa                	mv	s1,a0
    80005c02:	0e054663          	bltz	a0,80005cee <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005c06:	04491703          	lh	a4,68(s2)
    80005c0a:	478d                	li	a5,3
    80005c0c:	0cf70463          	beq	a4,a5,80005cd4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005c10:	4789                	li	a5,2
    80005c12:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005c16:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005c1a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005c1e:	f4c42783          	lw	a5,-180(s0)
    80005c22:	0017c713          	xori	a4,a5,1
    80005c26:	8b05                	andi	a4,a4,1
    80005c28:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005c2c:	0037f713          	andi	a4,a5,3
    80005c30:	00e03733          	snez	a4,a4
    80005c34:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005c38:	4007f793          	andi	a5,a5,1024
    80005c3c:	c791                	beqz	a5,80005c48 <sys_open+0xd2>
    80005c3e:	04491703          	lh	a4,68(s2)
    80005c42:	4789                	li	a5,2
    80005c44:	08f70f63          	beq	a4,a5,80005ce2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005c48:	854a                	mv	a0,s2
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	068080e7          	jalr	104(ra) # 80003cb2 <iunlock>
  end_op();
    80005c52:	fffff097          	auipc	ra,0xfffff
    80005c56:	9f8080e7          	jalr	-1544(ra) # 8000464a <end_op>

  return fd;
}
    80005c5a:	8526                	mv	a0,s1
    80005c5c:	70ea                	ld	ra,184(sp)
    80005c5e:	744a                	ld	s0,176(sp)
    80005c60:	74aa                	ld	s1,168(sp)
    80005c62:	790a                	ld	s2,160(sp)
    80005c64:	69ea                	ld	s3,152(sp)
    80005c66:	6129                	addi	sp,sp,192
    80005c68:	8082                	ret
      end_op();
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	9e0080e7          	jalr	-1568(ra) # 8000464a <end_op>
      return -1;
    80005c72:	b7e5                	j	80005c5a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005c74:	f5040513          	addi	a0,s0,-176
    80005c78:	ffffe097          	auipc	ra,0xffffe
    80005c7c:	734080e7          	jalr	1844(ra) # 800043ac <namei>
    80005c80:	892a                	mv	s2,a0
    80005c82:	c905                	beqz	a0,80005cb2 <sys_open+0x13c>
    ilock(ip);
    80005c84:	ffffe097          	auipc	ra,0xffffe
    80005c88:	f6c080e7          	jalr	-148(ra) # 80003bf0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c8c:	04491703          	lh	a4,68(s2)
    80005c90:	4785                	li	a5,1
    80005c92:	f4f712e3          	bne	a4,a5,80005bd6 <sys_open+0x60>
    80005c96:	f4c42783          	lw	a5,-180(s0)
    80005c9a:	dba1                	beqz	a5,80005bea <sys_open+0x74>
      iunlockput(ip);
    80005c9c:	854a                	mv	a0,s2
    80005c9e:	ffffe097          	auipc	ra,0xffffe
    80005ca2:	1b4080e7          	jalr	436(ra) # 80003e52 <iunlockput>
      end_op();
    80005ca6:	fffff097          	auipc	ra,0xfffff
    80005caa:	9a4080e7          	jalr	-1628(ra) # 8000464a <end_op>
      return -1;
    80005cae:	54fd                	li	s1,-1
    80005cb0:	b76d                	j	80005c5a <sys_open+0xe4>
      end_op();
    80005cb2:	fffff097          	auipc	ra,0xfffff
    80005cb6:	998080e7          	jalr	-1640(ra) # 8000464a <end_op>
      return -1;
    80005cba:	54fd                	li	s1,-1
    80005cbc:	bf79                	j	80005c5a <sys_open+0xe4>
    iunlockput(ip);
    80005cbe:	854a                	mv	a0,s2
    80005cc0:	ffffe097          	auipc	ra,0xffffe
    80005cc4:	192080e7          	jalr	402(ra) # 80003e52 <iunlockput>
    end_op();
    80005cc8:	fffff097          	auipc	ra,0xfffff
    80005ccc:	982080e7          	jalr	-1662(ra) # 8000464a <end_op>
    return -1;
    80005cd0:	54fd                	li	s1,-1
    80005cd2:	b761                	j	80005c5a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005cd4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005cd8:	04691783          	lh	a5,70(s2)
    80005cdc:	02f99223          	sh	a5,36(s3)
    80005ce0:	bf2d                	j	80005c1a <sys_open+0xa4>
    itrunc(ip);
    80005ce2:	854a                	mv	a0,s2
    80005ce4:	ffffe097          	auipc	ra,0xffffe
    80005ce8:	01a080e7          	jalr	26(ra) # 80003cfe <itrunc>
    80005cec:	bfb1                	j	80005c48 <sys_open+0xd2>
      fileclose(f);
    80005cee:	854e                	mv	a0,s3
    80005cf0:	fffff097          	auipc	ra,0xfffff
    80005cf4:	da4080e7          	jalr	-604(ra) # 80004a94 <fileclose>
    iunlockput(ip);
    80005cf8:	854a                	mv	a0,s2
    80005cfa:	ffffe097          	auipc	ra,0xffffe
    80005cfe:	158080e7          	jalr	344(ra) # 80003e52 <iunlockput>
    end_op();
    80005d02:	fffff097          	auipc	ra,0xfffff
    80005d06:	948080e7          	jalr	-1720(ra) # 8000464a <end_op>
    return -1;
    80005d0a:	54fd                	li	s1,-1
    80005d0c:	b7b9                	j	80005c5a <sys_open+0xe4>

0000000080005d0e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005d0e:	7175                	addi	sp,sp,-144
    80005d10:	e506                	sd	ra,136(sp)
    80005d12:	e122                	sd	s0,128(sp)
    80005d14:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005d16:	fffff097          	auipc	ra,0xfffff
    80005d1a:	8b6080e7          	jalr	-1866(ra) # 800045cc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005d1e:	08000613          	li	a2,128
    80005d22:	f7040593          	addi	a1,s0,-144
    80005d26:	4501                	li	a0,0
    80005d28:	ffffd097          	auipc	ra,0xffffd
    80005d2c:	25c080e7          	jalr	604(ra) # 80002f84 <argstr>
    80005d30:	02054963          	bltz	a0,80005d62 <sys_mkdir+0x54>
    80005d34:	4681                	li	a3,0
    80005d36:	4601                	li	a2,0
    80005d38:	4585                	li	a1,1
    80005d3a:	f7040513          	addi	a0,s0,-144
    80005d3e:	fffff097          	auipc	ra,0xfffff
    80005d42:	7fc080e7          	jalr	2044(ra) # 8000553a <create>
    80005d46:	cd11                	beqz	a0,80005d62 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d48:	ffffe097          	auipc	ra,0xffffe
    80005d4c:	10a080e7          	jalr	266(ra) # 80003e52 <iunlockput>
  end_op();
    80005d50:	fffff097          	auipc	ra,0xfffff
    80005d54:	8fa080e7          	jalr	-1798(ra) # 8000464a <end_op>
  return 0;
    80005d58:	4501                	li	a0,0
}
    80005d5a:	60aa                	ld	ra,136(sp)
    80005d5c:	640a                	ld	s0,128(sp)
    80005d5e:	6149                	addi	sp,sp,144
    80005d60:	8082                	ret
    end_op();
    80005d62:	fffff097          	auipc	ra,0xfffff
    80005d66:	8e8080e7          	jalr	-1816(ra) # 8000464a <end_op>
    return -1;
    80005d6a:	557d                	li	a0,-1
    80005d6c:	b7fd                	j	80005d5a <sys_mkdir+0x4c>

0000000080005d6e <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d6e:	7135                	addi	sp,sp,-160
    80005d70:	ed06                	sd	ra,152(sp)
    80005d72:	e922                	sd	s0,144(sp)
    80005d74:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	856080e7          	jalr	-1962(ra) # 800045cc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d7e:	08000613          	li	a2,128
    80005d82:	f7040593          	addi	a1,s0,-144
    80005d86:	4501                	li	a0,0
    80005d88:	ffffd097          	auipc	ra,0xffffd
    80005d8c:	1fc080e7          	jalr	508(ra) # 80002f84 <argstr>
    80005d90:	04054a63          	bltz	a0,80005de4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005d94:	f6c40593          	addi	a1,s0,-148
    80005d98:	4505                	li	a0,1
    80005d9a:	ffffd097          	auipc	ra,0xffffd
    80005d9e:	1a6080e7          	jalr	422(ra) # 80002f40 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005da2:	04054163          	bltz	a0,80005de4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005da6:	f6840593          	addi	a1,s0,-152
    80005daa:	4509                	li	a0,2
    80005dac:	ffffd097          	auipc	ra,0xffffd
    80005db0:	194080e7          	jalr	404(ra) # 80002f40 <argint>
     argint(1, &major) < 0 ||
    80005db4:	02054863          	bltz	a0,80005de4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005db8:	f6841683          	lh	a3,-152(s0)
    80005dbc:	f6c41603          	lh	a2,-148(s0)
    80005dc0:	458d                	li	a1,3
    80005dc2:	f7040513          	addi	a0,s0,-144
    80005dc6:	fffff097          	auipc	ra,0xfffff
    80005dca:	774080e7          	jalr	1908(ra) # 8000553a <create>
     argint(2, &minor) < 0 ||
    80005dce:	c919                	beqz	a0,80005de4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	082080e7          	jalr	130(ra) # 80003e52 <iunlockput>
  end_op();
    80005dd8:	fffff097          	auipc	ra,0xfffff
    80005ddc:	872080e7          	jalr	-1934(ra) # 8000464a <end_op>
  return 0;
    80005de0:	4501                	li	a0,0
    80005de2:	a031                	j	80005dee <sys_mknod+0x80>
    end_op();
    80005de4:	fffff097          	auipc	ra,0xfffff
    80005de8:	866080e7          	jalr	-1946(ra) # 8000464a <end_op>
    return -1;
    80005dec:	557d                	li	a0,-1
}
    80005dee:	60ea                	ld	ra,152(sp)
    80005df0:	644a                	ld	s0,144(sp)
    80005df2:	610d                	addi	sp,sp,160
    80005df4:	8082                	ret

0000000080005df6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005df6:	7135                	addi	sp,sp,-160
    80005df8:	ed06                	sd	ra,152(sp)
    80005dfa:	e922                	sd	s0,144(sp)
    80005dfc:	e526                	sd	s1,136(sp)
    80005dfe:	e14a                	sd	s2,128(sp)
    80005e00:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005e02:	ffffc097          	auipc	ra,0xffffc
    80005e06:	b94080e7          	jalr	-1132(ra) # 80001996 <myproc>
    80005e0a:	892a                	mv	s2,a0
  
  begin_op();
    80005e0c:	ffffe097          	auipc	ra,0xffffe
    80005e10:	7c0080e7          	jalr	1984(ra) # 800045cc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005e14:	08000613          	li	a2,128
    80005e18:	f6040593          	addi	a1,s0,-160
    80005e1c:	4501                	li	a0,0
    80005e1e:	ffffd097          	auipc	ra,0xffffd
    80005e22:	166080e7          	jalr	358(ra) # 80002f84 <argstr>
    80005e26:	04054b63          	bltz	a0,80005e7c <sys_chdir+0x86>
    80005e2a:	f6040513          	addi	a0,s0,-160
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	57e080e7          	jalr	1406(ra) # 800043ac <namei>
    80005e36:	84aa                	mv	s1,a0
    80005e38:	c131                	beqz	a0,80005e7c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005e3a:	ffffe097          	auipc	ra,0xffffe
    80005e3e:	db6080e7          	jalr	-586(ra) # 80003bf0 <ilock>
  if(ip->type != T_DIR){
    80005e42:	04449703          	lh	a4,68(s1)
    80005e46:	4785                	li	a5,1
    80005e48:	04f71063          	bne	a4,a5,80005e88 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005e4c:	8526                	mv	a0,s1
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	e64080e7          	jalr	-412(ra) # 80003cb2 <iunlock>
  iput(p->cwd);
    80005e56:	15093503          	ld	a0,336(s2)
    80005e5a:	ffffe097          	auipc	ra,0xffffe
    80005e5e:	f50080e7          	jalr	-176(ra) # 80003daa <iput>
  end_op();
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	7e8080e7          	jalr	2024(ra) # 8000464a <end_op>
  p->cwd = ip;
    80005e6a:	14993823          	sd	s1,336(s2)
  return 0;
    80005e6e:	4501                	li	a0,0
}
    80005e70:	60ea                	ld	ra,152(sp)
    80005e72:	644a                	ld	s0,144(sp)
    80005e74:	64aa                	ld	s1,136(sp)
    80005e76:	690a                	ld	s2,128(sp)
    80005e78:	610d                	addi	sp,sp,160
    80005e7a:	8082                	ret
    end_op();
    80005e7c:	ffffe097          	auipc	ra,0xffffe
    80005e80:	7ce080e7          	jalr	1998(ra) # 8000464a <end_op>
    return -1;
    80005e84:	557d                	li	a0,-1
    80005e86:	b7ed                	j	80005e70 <sys_chdir+0x7a>
    iunlockput(ip);
    80005e88:	8526                	mv	a0,s1
    80005e8a:	ffffe097          	auipc	ra,0xffffe
    80005e8e:	fc8080e7          	jalr	-56(ra) # 80003e52 <iunlockput>
    end_op();
    80005e92:	ffffe097          	auipc	ra,0xffffe
    80005e96:	7b8080e7          	jalr	1976(ra) # 8000464a <end_op>
    return -1;
    80005e9a:	557d                	li	a0,-1
    80005e9c:	bfd1                	j	80005e70 <sys_chdir+0x7a>

0000000080005e9e <sys_exec>:

uint64
sys_exec(void)
{
    80005e9e:	7145                	addi	sp,sp,-464
    80005ea0:	e786                	sd	ra,456(sp)
    80005ea2:	e3a2                	sd	s0,448(sp)
    80005ea4:	ff26                	sd	s1,440(sp)
    80005ea6:	fb4a                	sd	s2,432(sp)
    80005ea8:	f74e                	sd	s3,424(sp)
    80005eaa:	f352                	sd	s4,416(sp)
    80005eac:	ef56                	sd	s5,408(sp)
    80005eae:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005eb0:	08000613          	li	a2,128
    80005eb4:	f4040593          	addi	a1,s0,-192
    80005eb8:	4501                	li	a0,0
    80005eba:	ffffd097          	auipc	ra,0xffffd
    80005ebe:	0ca080e7          	jalr	202(ra) # 80002f84 <argstr>
    return -1;
    80005ec2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ec4:	0c054b63          	bltz	a0,80005f9a <sys_exec+0xfc>
    80005ec8:	e3840593          	addi	a1,s0,-456
    80005ecc:	4505                	li	a0,1
    80005ece:	ffffd097          	auipc	ra,0xffffd
    80005ed2:	094080e7          	jalr	148(ra) # 80002f62 <argaddr>
    80005ed6:	0c054263          	bltz	a0,80005f9a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005eda:	10000613          	li	a2,256
    80005ede:	4581                	li	a1,0
    80005ee0:	e4040513          	addi	a0,s0,-448
    80005ee4:	ffffb097          	auipc	ra,0xffffb
    80005ee8:	de8080e7          	jalr	-536(ra) # 80000ccc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005eec:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005ef0:	89a6                	mv	s3,s1
    80005ef2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005ef4:	02000a13          	li	s4,32
    80005ef8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005efc:	00391513          	slli	a0,s2,0x3
    80005f00:	e3040593          	addi	a1,s0,-464
    80005f04:	e3843783          	ld	a5,-456(s0)
    80005f08:	953e                	add	a0,a0,a5
    80005f0a:	ffffd097          	auipc	ra,0xffffd
    80005f0e:	f9c080e7          	jalr	-100(ra) # 80002ea6 <fetchaddr>
    80005f12:	02054a63          	bltz	a0,80005f46 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005f16:	e3043783          	ld	a5,-464(s0)
    80005f1a:	c3b9                	beqz	a5,80005f60 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005f1c:	ffffb097          	auipc	ra,0xffffb
    80005f20:	bc4080e7          	jalr	-1084(ra) # 80000ae0 <kalloc>
    80005f24:	85aa                	mv	a1,a0
    80005f26:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005f2a:	cd11                	beqz	a0,80005f46 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005f2c:	6605                	lui	a2,0x1
    80005f2e:	e3043503          	ld	a0,-464(s0)
    80005f32:	ffffd097          	auipc	ra,0xffffd
    80005f36:	fc6080e7          	jalr	-58(ra) # 80002ef8 <fetchstr>
    80005f3a:	00054663          	bltz	a0,80005f46 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005f3e:	0905                	addi	s2,s2,1
    80005f40:	09a1                	addi	s3,s3,8
    80005f42:	fb491be3          	bne	s2,s4,80005ef8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f46:	f4040913          	addi	s2,s0,-192
    80005f4a:	6088                	ld	a0,0(s1)
    80005f4c:	c531                	beqz	a0,80005f98 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f4e:	ffffb097          	auipc	ra,0xffffb
    80005f52:	a94080e7          	jalr	-1388(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f56:	04a1                	addi	s1,s1,8
    80005f58:	ff2499e3          	bne	s1,s2,80005f4a <sys_exec+0xac>
  return -1;
    80005f5c:	597d                	li	s2,-1
    80005f5e:	a835                	j	80005f9a <sys_exec+0xfc>
      argv[i] = 0;
    80005f60:	0a8e                	slli	s5,s5,0x3
    80005f62:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8fc0>
    80005f66:	00878ab3          	add	s5,a5,s0
    80005f6a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005f6e:	e4040593          	addi	a1,s0,-448
    80005f72:	f4040513          	addi	a0,s0,-192
    80005f76:	fffff097          	auipc	ra,0xfffff
    80005f7a:	172080e7          	jalr	370(ra) # 800050e8 <exec>
    80005f7e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f80:	f4040993          	addi	s3,s0,-192
    80005f84:	6088                	ld	a0,0(s1)
    80005f86:	c911                	beqz	a0,80005f9a <sys_exec+0xfc>
    kfree(argv[i]);
    80005f88:	ffffb097          	auipc	ra,0xffffb
    80005f8c:	a5a080e7          	jalr	-1446(ra) # 800009e2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f90:	04a1                	addi	s1,s1,8
    80005f92:	ff3499e3          	bne	s1,s3,80005f84 <sys_exec+0xe6>
    80005f96:	a011                	j	80005f9a <sys_exec+0xfc>
  return -1;
    80005f98:	597d                	li	s2,-1
}
    80005f9a:	854a                	mv	a0,s2
    80005f9c:	60be                	ld	ra,456(sp)
    80005f9e:	641e                	ld	s0,448(sp)
    80005fa0:	74fa                	ld	s1,440(sp)
    80005fa2:	795a                	ld	s2,432(sp)
    80005fa4:	79ba                	ld	s3,424(sp)
    80005fa6:	7a1a                	ld	s4,416(sp)
    80005fa8:	6afa                	ld	s5,408(sp)
    80005faa:	6179                	addi	sp,sp,464
    80005fac:	8082                	ret

0000000080005fae <sys_pipe>:

uint64
sys_pipe(void)
{
    80005fae:	7139                	addi	sp,sp,-64
    80005fb0:	fc06                	sd	ra,56(sp)
    80005fb2:	f822                	sd	s0,48(sp)
    80005fb4:	f426                	sd	s1,40(sp)
    80005fb6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	9de080e7          	jalr	-1570(ra) # 80001996 <myproc>
    80005fc0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005fc2:	fd840593          	addi	a1,s0,-40
    80005fc6:	4501                	li	a0,0
    80005fc8:	ffffd097          	auipc	ra,0xffffd
    80005fcc:	f9a080e7          	jalr	-102(ra) # 80002f62 <argaddr>
    return -1;
    80005fd0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005fd2:	0e054063          	bltz	a0,800060b2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005fd6:	fc840593          	addi	a1,s0,-56
    80005fda:	fd040513          	addi	a0,s0,-48
    80005fde:	fffff097          	auipc	ra,0xfffff
    80005fe2:	de6080e7          	jalr	-538(ra) # 80004dc4 <pipealloc>
    return -1;
    80005fe6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005fe8:	0c054563          	bltz	a0,800060b2 <sys_pipe+0x104>
  fd0 = -1;
    80005fec:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ff0:	fd043503          	ld	a0,-48(s0)
    80005ff4:	fffff097          	auipc	ra,0xfffff
    80005ff8:	504080e7          	jalr	1284(ra) # 800054f8 <fdalloc>
    80005ffc:	fca42223          	sw	a0,-60(s0)
    80006000:	08054c63          	bltz	a0,80006098 <sys_pipe+0xea>
    80006004:	fc843503          	ld	a0,-56(s0)
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	4f0080e7          	jalr	1264(ra) # 800054f8 <fdalloc>
    80006010:	fca42023          	sw	a0,-64(s0)
    80006014:	06054963          	bltz	a0,80006086 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006018:	4691                	li	a3,4
    8000601a:	fc440613          	addi	a2,s0,-60
    8000601e:	fd843583          	ld	a1,-40(s0)
    80006022:	68a8                	ld	a0,80(s1)
    80006024:	ffffb097          	auipc	ra,0xffffb
    80006028:	636080e7          	jalr	1590(ra) # 8000165a <copyout>
    8000602c:	02054063          	bltz	a0,8000604c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006030:	4691                	li	a3,4
    80006032:	fc040613          	addi	a2,s0,-64
    80006036:	fd843583          	ld	a1,-40(s0)
    8000603a:	0591                	addi	a1,a1,4
    8000603c:	68a8                	ld	a0,80(s1)
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	61c080e7          	jalr	1564(ra) # 8000165a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006046:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006048:	06055563          	bgez	a0,800060b2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000604c:	fc442783          	lw	a5,-60(s0)
    80006050:	07e9                	addi	a5,a5,26
    80006052:	078e                	slli	a5,a5,0x3
    80006054:	97a6                	add	a5,a5,s1
    80006056:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000605a:	fc042783          	lw	a5,-64(s0)
    8000605e:	07e9                	addi	a5,a5,26
    80006060:	078e                	slli	a5,a5,0x3
    80006062:	00f48533          	add	a0,s1,a5
    80006066:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000606a:	fd043503          	ld	a0,-48(s0)
    8000606e:	fffff097          	auipc	ra,0xfffff
    80006072:	a26080e7          	jalr	-1498(ra) # 80004a94 <fileclose>
    fileclose(wf);
    80006076:	fc843503          	ld	a0,-56(s0)
    8000607a:	fffff097          	auipc	ra,0xfffff
    8000607e:	a1a080e7          	jalr	-1510(ra) # 80004a94 <fileclose>
    return -1;
    80006082:	57fd                	li	a5,-1
    80006084:	a03d                	j	800060b2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80006086:	fc442783          	lw	a5,-60(s0)
    8000608a:	0007c763          	bltz	a5,80006098 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000608e:	07e9                	addi	a5,a5,26
    80006090:	078e                	slli	a5,a5,0x3
    80006092:	97a6                	add	a5,a5,s1
    80006094:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006098:	fd043503          	ld	a0,-48(s0)
    8000609c:	fffff097          	auipc	ra,0xfffff
    800060a0:	9f8080e7          	jalr	-1544(ra) # 80004a94 <fileclose>
    fileclose(wf);
    800060a4:	fc843503          	ld	a0,-56(s0)
    800060a8:	fffff097          	auipc	ra,0xfffff
    800060ac:	9ec080e7          	jalr	-1556(ra) # 80004a94 <fileclose>
    return -1;
    800060b0:	57fd                	li	a5,-1
}
    800060b2:	853e                	mv	a0,a5
    800060b4:	70e2                	ld	ra,56(sp)
    800060b6:	7442                	ld	s0,48(sp)
    800060b8:	74a2                	ld	s1,40(sp)
    800060ba:	6121                	addi	sp,sp,64
    800060bc:	8082                	ret
	...

00000000800060c0 <kernelvec>:
    800060c0:	7111                	addi	sp,sp,-256
    800060c2:	e006                	sd	ra,0(sp)
    800060c4:	e40a                	sd	sp,8(sp)
    800060c6:	e80e                	sd	gp,16(sp)
    800060c8:	ec12                	sd	tp,24(sp)
    800060ca:	f016                	sd	t0,32(sp)
    800060cc:	f41a                	sd	t1,40(sp)
    800060ce:	f81e                	sd	t2,48(sp)
    800060d0:	fc22                	sd	s0,56(sp)
    800060d2:	e0a6                	sd	s1,64(sp)
    800060d4:	e4aa                	sd	a0,72(sp)
    800060d6:	e8ae                	sd	a1,80(sp)
    800060d8:	ecb2                	sd	a2,88(sp)
    800060da:	f0b6                	sd	a3,96(sp)
    800060dc:	f4ba                	sd	a4,104(sp)
    800060de:	f8be                	sd	a5,112(sp)
    800060e0:	fcc2                	sd	a6,120(sp)
    800060e2:	e146                	sd	a7,128(sp)
    800060e4:	e54a                	sd	s2,136(sp)
    800060e6:	e94e                	sd	s3,144(sp)
    800060e8:	ed52                	sd	s4,152(sp)
    800060ea:	f156                	sd	s5,160(sp)
    800060ec:	f55a                	sd	s6,168(sp)
    800060ee:	f95e                	sd	s7,176(sp)
    800060f0:	fd62                	sd	s8,184(sp)
    800060f2:	e1e6                	sd	s9,192(sp)
    800060f4:	e5ea                	sd	s10,200(sp)
    800060f6:	e9ee                	sd	s11,208(sp)
    800060f8:	edf2                	sd	t3,216(sp)
    800060fa:	f1f6                	sd	t4,224(sp)
    800060fc:	f5fa                	sd	t5,232(sp)
    800060fe:	f9fe                	sd	t6,240(sp)
    80006100:	c73fc0ef          	jal	ra,80002d72 <kerneltrap>
    80006104:	6082                	ld	ra,0(sp)
    80006106:	6122                	ld	sp,8(sp)
    80006108:	61c2                	ld	gp,16(sp)
    8000610a:	7282                	ld	t0,32(sp)
    8000610c:	7322                	ld	t1,40(sp)
    8000610e:	73c2                	ld	t2,48(sp)
    80006110:	7462                	ld	s0,56(sp)
    80006112:	6486                	ld	s1,64(sp)
    80006114:	6526                	ld	a0,72(sp)
    80006116:	65c6                	ld	a1,80(sp)
    80006118:	6666                	ld	a2,88(sp)
    8000611a:	7686                	ld	a3,96(sp)
    8000611c:	7726                	ld	a4,104(sp)
    8000611e:	77c6                	ld	a5,112(sp)
    80006120:	7866                	ld	a6,120(sp)
    80006122:	688a                	ld	a7,128(sp)
    80006124:	692a                	ld	s2,136(sp)
    80006126:	69ca                	ld	s3,144(sp)
    80006128:	6a6a                	ld	s4,152(sp)
    8000612a:	7a8a                	ld	s5,160(sp)
    8000612c:	7b2a                	ld	s6,168(sp)
    8000612e:	7bca                	ld	s7,176(sp)
    80006130:	7c6a                	ld	s8,184(sp)
    80006132:	6c8e                	ld	s9,192(sp)
    80006134:	6d2e                	ld	s10,200(sp)
    80006136:	6dce                	ld	s11,208(sp)
    80006138:	6e6e                	ld	t3,216(sp)
    8000613a:	7e8e                	ld	t4,224(sp)
    8000613c:	7f2e                	ld	t5,232(sp)
    8000613e:	7fce                	ld	t6,240(sp)
    80006140:	6111                	addi	sp,sp,256
    80006142:	10200073          	sret
    80006146:	00000013          	nop
    8000614a:	00000013          	nop
    8000614e:	0001                	nop

0000000080006150 <timervec>:
    80006150:	34051573          	csrrw	a0,mscratch,a0
    80006154:	e10c                	sd	a1,0(a0)
    80006156:	e510                	sd	a2,8(a0)
    80006158:	e914                	sd	a3,16(a0)
    8000615a:	6d0c                	ld	a1,24(a0)
    8000615c:	7110                	ld	a2,32(a0)
    8000615e:	6194                	ld	a3,0(a1)
    80006160:	96b2                	add	a3,a3,a2
    80006162:	e194                	sd	a3,0(a1)
    80006164:	4589                	li	a1,2
    80006166:	14459073          	csrw	sip,a1
    8000616a:	6914                	ld	a3,16(a0)
    8000616c:	6510                	ld	a2,8(a0)
    8000616e:	610c                	ld	a1,0(a0)
    80006170:	34051573          	csrrw	a0,mscratch,a0
    80006174:	30200073          	mret
	...

000000008000617a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000617a:	1141                	addi	sp,sp,-16
    8000617c:	e422                	sd	s0,8(sp)
    8000617e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006180:	0c0007b7          	lui	a5,0xc000
    80006184:	4705                	li	a4,1
    80006186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006188:	c3d8                	sw	a4,4(a5)
}
    8000618a:	6422                	ld	s0,8(sp)
    8000618c:	0141                	addi	sp,sp,16
    8000618e:	8082                	ret

0000000080006190 <plicinithart>:

void
plicinithart(void)
{
    80006190:	1141                	addi	sp,sp,-16
    80006192:	e406                	sd	ra,8(sp)
    80006194:	e022                	sd	s0,0(sp)
    80006196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006198:	ffffb097          	auipc	ra,0xffffb
    8000619c:	7d2080e7          	jalr	2002(ra) # 8000196a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800061a0:	0085171b          	slliw	a4,a0,0x8
    800061a4:	0c0027b7          	lui	a5,0xc002
    800061a8:	97ba                	add	a5,a5,a4
    800061aa:	40200713          	li	a4,1026
    800061ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800061b2:	00d5151b          	slliw	a0,a0,0xd
    800061b6:	0c2017b7          	lui	a5,0xc201
    800061ba:	97aa                	add	a5,a5,a0
    800061bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800061c0:	60a2                	ld	ra,8(sp)
    800061c2:	6402                	ld	s0,0(sp)
    800061c4:	0141                	addi	sp,sp,16
    800061c6:	8082                	ret

00000000800061c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800061c8:	1141                	addi	sp,sp,-16
    800061ca:	e406                	sd	ra,8(sp)
    800061cc:	e022                	sd	s0,0(sp)
    800061ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061d0:	ffffb097          	auipc	ra,0xffffb
    800061d4:	79a080e7          	jalr	1946(ra) # 8000196a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800061d8:	00d5151b          	slliw	a0,a0,0xd
    800061dc:	0c2017b7          	lui	a5,0xc201
    800061e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800061e2:	43c8                	lw	a0,4(a5)
    800061e4:	60a2                	ld	ra,8(sp)
    800061e6:	6402                	ld	s0,0(sp)
    800061e8:	0141                	addi	sp,sp,16
    800061ea:	8082                	ret

00000000800061ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	772080e7          	jalr	1906(ra) # 8000196a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006200:	00d5151b          	slliw	a0,a0,0xd
    80006204:	0c2017b7          	lui	a5,0xc201
    80006208:	97aa                	add	a5,a5,a0
    8000620a:	c3c4                	sw	s1,4(a5)
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret

0000000080006216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006216:	1141                	addi	sp,sp,-16
    80006218:	e406                	sd	ra,8(sp)
    8000621a:	e022                	sd	s0,0(sp)
    8000621c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000621e:	479d                	li	a5,7
    80006220:	06a7c863          	blt	a5,a0,80006290 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80006224:	0001d717          	auipc	a4,0x1d
    80006228:	ddc70713          	addi	a4,a4,-548 # 80023000 <disk>
    8000622c:	972a                	add	a4,a4,a0
    8000622e:	6789                	lui	a5,0x2
    80006230:	97ba                	add	a5,a5,a4
    80006232:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006236:	e7ad                	bnez	a5,800062a0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006238:	00451793          	slli	a5,a0,0x4
    8000623c:	0001f717          	auipc	a4,0x1f
    80006240:	dc470713          	addi	a4,a4,-572 # 80025000 <disk+0x2000>
    80006244:	6314                	ld	a3,0(a4)
    80006246:	96be                	add	a3,a3,a5
    80006248:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000624c:	6314                	ld	a3,0(a4)
    8000624e:	96be                	add	a3,a3,a5
    80006250:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006254:	6314                	ld	a3,0(a4)
    80006256:	96be                	add	a3,a3,a5
    80006258:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000625c:	6318                	ld	a4,0(a4)
    8000625e:	97ba                	add	a5,a5,a4
    80006260:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006264:	0001d717          	auipc	a4,0x1d
    80006268:	d9c70713          	addi	a4,a4,-612 # 80023000 <disk>
    8000626c:	972a                	add	a4,a4,a0
    8000626e:	6789                	lui	a5,0x2
    80006270:	97ba                	add	a5,a5,a4
    80006272:	4705                	li	a4,1
    80006274:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006278:	0001f517          	auipc	a0,0x1f
    8000627c:	da050513          	addi	a0,a0,-608 # 80025018 <disk+0x2018>
    80006280:	ffffc097          	auipc	ra,0xffffc
    80006284:	fdc080e7          	jalr	-36(ra) # 8000225c <wakeup>
}
    80006288:	60a2                	ld	ra,8(sp)
    8000628a:	6402                	ld	s0,0(sp)
    8000628c:	0141                	addi	sp,sp,16
    8000628e:	8082                	ret
    panic("free_desc 1");
    80006290:	00002517          	auipc	a0,0x2
    80006294:	5d050513          	addi	a0,a0,1488 # 80008860 <syscalls+0x350>
    80006298:	ffffa097          	auipc	ra,0xffffa
    8000629c:	2a2080e7          	jalr	674(ra) # 8000053a <panic>
    panic("free_desc 2");
    800062a0:	00002517          	auipc	a0,0x2
    800062a4:	5d050513          	addi	a0,a0,1488 # 80008870 <syscalls+0x360>
    800062a8:	ffffa097          	auipc	ra,0xffffa
    800062ac:	292080e7          	jalr	658(ra) # 8000053a <panic>

00000000800062b0 <virtio_disk_init>:
{
    800062b0:	1101                	addi	sp,sp,-32
    800062b2:	ec06                	sd	ra,24(sp)
    800062b4:	e822                	sd	s0,16(sp)
    800062b6:	e426                	sd	s1,8(sp)
    800062b8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800062ba:	00002597          	auipc	a1,0x2
    800062be:	5c658593          	addi	a1,a1,1478 # 80008880 <syscalls+0x370>
    800062c2:	0001f517          	auipc	a0,0x1f
    800062c6:	e6650513          	addi	a0,a0,-410 # 80025128 <disk+0x2128>
    800062ca:	ffffb097          	auipc	ra,0xffffb
    800062ce:	876080e7          	jalr	-1930(ra) # 80000b40 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062d2:	100017b7          	lui	a5,0x10001
    800062d6:	4398                	lw	a4,0(a5)
    800062d8:	2701                	sext.w	a4,a4
    800062da:	747277b7          	lui	a5,0x74727
    800062de:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062e2:	0ef71063          	bne	a4,a5,800063c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062e6:	100017b7          	lui	a5,0x10001
    800062ea:	43dc                	lw	a5,4(a5)
    800062ec:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062ee:	4705                	li	a4,1
    800062f0:	0ce79963          	bne	a5,a4,800063c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062f4:	100017b7          	lui	a5,0x10001
    800062f8:	479c                	lw	a5,8(a5)
    800062fa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800062fc:	4709                	li	a4,2
    800062fe:	0ce79263          	bne	a5,a4,800063c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006302:	100017b7          	lui	a5,0x10001
    80006306:	47d8                	lw	a4,12(a5)
    80006308:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000630a:	554d47b7          	lui	a5,0x554d4
    8000630e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006312:	0af71863          	bne	a4,a5,800063c2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006316:	100017b7          	lui	a5,0x10001
    8000631a:	4705                	li	a4,1
    8000631c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000631e:	470d                	li	a4,3
    80006320:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006322:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006324:	c7ffe6b7          	lui	a3,0xc7ffe
    80006328:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    8000632c:	8f75                	and	a4,a4,a3
    8000632e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006330:	472d                	li	a4,11
    80006332:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006334:	473d                	li	a4,15
    80006336:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006338:	6705                	lui	a4,0x1
    8000633a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000633c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006340:	5bdc                	lw	a5,52(a5)
    80006342:	2781                	sext.w	a5,a5
  if(max == 0)
    80006344:	c7d9                	beqz	a5,800063d2 <virtio_disk_init+0x122>
  if(max < NUM)
    80006346:	471d                	li	a4,7
    80006348:	08f77d63          	bgeu	a4,a5,800063e2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000634c:	100014b7          	lui	s1,0x10001
    80006350:	47a1                	li	a5,8
    80006352:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006354:	6609                	lui	a2,0x2
    80006356:	4581                	li	a1,0
    80006358:	0001d517          	auipc	a0,0x1d
    8000635c:	ca850513          	addi	a0,a0,-856 # 80023000 <disk>
    80006360:	ffffb097          	auipc	ra,0xffffb
    80006364:	96c080e7          	jalr	-1684(ra) # 80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006368:	0001d717          	auipc	a4,0x1d
    8000636c:	c9870713          	addi	a4,a4,-872 # 80023000 <disk>
    80006370:	00c75793          	srli	a5,a4,0xc
    80006374:	2781                	sext.w	a5,a5
    80006376:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006378:	0001f797          	auipc	a5,0x1f
    8000637c:	c8878793          	addi	a5,a5,-888 # 80025000 <disk+0x2000>
    80006380:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006382:	0001d717          	auipc	a4,0x1d
    80006386:	cfe70713          	addi	a4,a4,-770 # 80023080 <disk+0x80>
    8000638a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000638c:	0001e717          	auipc	a4,0x1e
    80006390:	c7470713          	addi	a4,a4,-908 # 80024000 <disk+0x1000>
    80006394:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006396:	4705                	li	a4,1
    80006398:	00e78c23          	sb	a4,24(a5)
    8000639c:	00e78ca3          	sb	a4,25(a5)
    800063a0:	00e78d23          	sb	a4,26(a5)
    800063a4:	00e78da3          	sb	a4,27(a5)
    800063a8:	00e78e23          	sb	a4,28(a5)
    800063ac:	00e78ea3          	sb	a4,29(a5)
    800063b0:	00e78f23          	sb	a4,30(a5)
    800063b4:	00e78fa3          	sb	a4,31(a5)
}
    800063b8:	60e2                	ld	ra,24(sp)
    800063ba:	6442                	ld	s0,16(sp)
    800063bc:	64a2                	ld	s1,8(sp)
    800063be:	6105                	addi	sp,sp,32
    800063c0:	8082                	ret
    panic("could not find virtio disk");
    800063c2:	00002517          	auipc	a0,0x2
    800063c6:	4ce50513          	addi	a0,a0,1230 # 80008890 <syscalls+0x380>
    800063ca:	ffffa097          	auipc	ra,0xffffa
    800063ce:	170080e7          	jalr	368(ra) # 8000053a <panic>
    panic("virtio disk has no queue 0");
    800063d2:	00002517          	auipc	a0,0x2
    800063d6:	4de50513          	addi	a0,a0,1246 # 800088b0 <syscalls+0x3a0>
    800063da:	ffffa097          	auipc	ra,0xffffa
    800063de:	160080e7          	jalr	352(ra) # 8000053a <panic>
    panic("virtio disk max queue too short");
    800063e2:	00002517          	auipc	a0,0x2
    800063e6:	4ee50513          	addi	a0,a0,1262 # 800088d0 <syscalls+0x3c0>
    800063ea:	ffffa097          	auipc	ra,0xffffa
    800063ee:	150080e7          	jalr	336(ra) # 8000053a <panic>

00000000800063f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800063f2:	7119                	addi	sp,sp,-128
    800063f4:	fc86                	sd	ra,120(sp)
    800063f6:	f8a2                	sd	s0,112(sp)
    800063f8:	f4a6                	sd	s1,104(sp)
    800063fa:	f0ca                	sd	s2,96(sp)
    800063fc:	ecce                	sd	s3,88(sp)
    800063fe:	e8d2                	sd	s4,80(sp)
    80006400:	e4d6                	sd	s5,72(sp)
    80006402:	e0da                	sd	s6,64(sp)
    80006404:	fc5e                	sd	s7,56(sp)
    80006406:	f862                	sd	s8,48(sp)
    80006408:	f466                	sd	s9,40(sp)
    8000640a:	f06a                	sd	s10,32(sp)
    8000640c:	ec6e                	sd	s11,24(sp)
    8000640e:	0100                	addi	s0,sp,128
    80006410:	8aaa                	mv	s5,a0
    80006412:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006414:	00c52c83          	lw	s9,12(a0)
    80006418:	001c9c9b          	slliw	s9,s9,0x1
    8000641c:	1c82                	slli	s9,s9,0x20
    8000641e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006422:	0001f517          	auipc	a0,0x1f
    80006426:	d0650513          	addi	a0,a0,-762 # 80025128 <disk+0x2128>
    8000642a:	ffffa097          	auipc	ra,0xffffa
    8000642e:	7a6080e7          	jalr	1958(ra) # 80000bd0 <acquire>
  for(int i = 0; i < 3; i++){
    80006432:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006434:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006436:	0001dc17          	auipc	s8,0x1d
    8000643a:	bcac0c13          	addi	s8,s8,-1078 # 80023000 <disk>
    8000643e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80006440:	4b0d                	li	s6,3
    80006442:	a0ad                	j	800064ac <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006444:	00fc0733          	add	a4,s8,a5
    80006448:	975e                	add	a4,a4,s7
    8000644a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000644e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006450:	0207c563          	bltz	a5,8000647a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006454:	2905                	addiw	s2,s2,1
    80006456:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80006458:	19690c63          	beq	s2,s6,800065f0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000645c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000645e:	0001f717          	auipc	a4,0x1f
    80006462:	bba70713          	addi	a4,a4,-1094 # 80025018 <disk+0x2018>
    80006466:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006468:	00074683          	lbu	a3,0(a4)
    8000646c:	fee1                	bnez	a3,80006444 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000646e:	2785                	addiw	a5,a5,1
    80006470:	0705                	addi	a4,a4,1
    80006472:	fe979be3          	bne	a5,s1,80006468 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006476:	57fd                	li	a5,-1
    80006478:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000647a:	01205d63          	blez	s2,80006494 <virtio_disk_rw+0xa2>
    8000647e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006480:	000a2503          	lw	a0,0(s4)
    80006484:	00000097          	auipc	ra,0x0
    80006488:	d92080e7          	jalr	-622(ra) # 80006216 <free_desc>
      for(int j = 0; j < i; j++)
    8000648c:	2d85                	addiw	s11,s11,1
    8000648e:	0a11                	addi	s4,s4,4
    80006490:	ff2d98e3          	bne	s11,s2,80006480 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006494:	0001f597          	auipc	a1,0x1f
    80006498:	c9458593          	addi	a1,a1,-876 # 80025128 <disk+0x2128>
    8000649c:	0001f517          	auipc	a0,0x1f
    800064a0:	b7c50513          	addi	a0,a0,-1156 # 80025018 <disk+0x2018>
    800064a4:	ffffc097          	auipc	ra,0xffffc
    800064a8:	c2c080e7          	jalr	-980(ra) # 800020d0 <sleep>
  for(int i = 0; i < 3; i++){
    800064ac:	f8040a13          	addi	s4,s0,-128
{
    800064b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800064b2:	894e                	mv	s2,s3
    800064b4:	b765                	j	8000645c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800064b6:	0001f697          	auipc	a3,0x1f
    800064ba:	b4a6b683          	ld	a3,-1206(a3) # 80025000 <disk+0x2000>
    800064be:	96ba                	add	a3,a3,a4
    800064c0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064c4:	0001d817          	auipc	a6,0x1d
    800064c8:	b3c80813          	addi	a6,a6,-1220 # 80023000 <disk>
    800064cc:	0001f697          	auipc	a3,0x1f
    800064d0:	b3468693          	addi	a3,a3,-1228 # 80025000 <disk+0x2000>
    800064d4:	6290                	ld	a2,0(a3)
    800064d6:	963a                	add	a2,a2,a4
    800064d8:	00c65583          	lhu	a1,12(a2)
    800064dc:	0015e593          	ori	a1,a1,1
    800064e0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800064e4:	f8842603          	lw	a2,-120(s0)
    800064e8:	628c                	ld	a1,0(a3)
    800064ea:	972e                	add	a4,a4,a1
    800064ec:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800064f0:	20050593          	addi	a1,a0,512
    800064f4:	0592                	slli	a1,a1,0x4
    800064f6:	95c2                	add	a1,a1,a6
    800064f8:	577d                	li	a4,-1
    800064fa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800064fe:	00461713          	slli	a4,a2,0x4
    80006502:	6290                	ld	a2,0(a3)
    80006504:	963a                	add	a2,a2,a4
    80006506:	03078793          	addi	a5,a5,48
    8000650a:	97c2                	add	a5,a5,a6
    8000650c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000650e:	629c                	ld	a5,0(a3)
    80006510:	97ba                	add	a5,a5,a4
    80006512:	4605                	li	a2,1
    80006514:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006516:	629c                	ld	a5,0(a3)
    80006518:	97ba                	add	a5,a5,a4
    8000651a:	4809                	li	a6,2
    8000651c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006520:	629c                	ld	a5,0(a3)
    80006522:	97ba                	add	a5,a5,a4
    80006524:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006528:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000652c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006530:	6698                	ld	a4,8(a3)
    80006532:	00275783          	lhu	a5,2(a4)
    80006536:	8b9d                	andi	a5,a5,7
    80006538:	0786                	slli	a5,a5,0x1
    8000653a:	973e                	add	a4,a4,a5
    8000653c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80006540:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006544:	6698                	ld	a4,8(a3)
    80006546:	00275783          	lhu	a5,2(a4)
    8000654a:	2785                	addiw	a5,a5,1
    8000654c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006550:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006554:	100017b7          	lui	a5,0x10001
    80006558:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000655c:	004aa783          	lw	a5,4(s5)
    80006560:	02c79163          	bne	a5,a2,80006582 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006564:	0001f917          	auipc	s2,0x1f
    80006568:	bc490913          	addi	s2,s2,-1084 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    8000656c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000656e:	85ca                	mv	a1,s2
    80006570:	8556                	mv	a0,s5
    80006572:	ffffc097          	auipc	ra,0xffffc
    80006576:	b5e080e7          	jalr	-1186(ra) # 800020d0 <sleep>
  while(b->disk == 1) {
    8000657a:	004aa783          	lw	a5,4(s5)
    8000657e:	fe9788e3          	beq	a5,s1,8000656e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006582:	f8042903          	lw	s2,-128(s0)
    80006586:	20090713          	addi	a4,s2,512
    8000658a:	0712                	slli	a4,a4,0x4
    8000658c:	0001d797          	auipc	a5,0x1d
    80006590:	a7478793          	addi	a5,a5,-1420 # 80023000 <disk>
    80006594:	97ba                	add	a5,a5,a4
    80006596:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000659a:	0001f997          	auipc	s3,0x1f
    8000659e:	a6698993          	addi	s3,s3,-1434 # 80025000 <disk+0x2000>
    800065a2:	00491713          	slli	a4,s2,0x4
    800065a6:	0009b783          	ld	a5,0(s3)
    800065aa:	97ba                	add	a5,a5,a4
    800065ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800065b0:	854a                	mv	a0,s2
    800065b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800065b6:	00000097          	auipc	ra,0x0
    800065ba:	c60080e7          	jalr	-928(ra) # 80006216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800065be:	8885                	andi	s1,s1,1
    800065c0:	f0ed                	bnez	s1,800065a2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800065c2:	0001f517          	auipc	a0,0x1f
    800065c6:	b6650513          	addi	a0,a0,-1178 # 80025128 <disk+0x2128>
    800065ca:	ffffa097          	auipc	ra,0xffffa
    800065ce:	6ba080e7          	jalr	1722(ra) # 80000c84 <release>
}
    800065d2:	70e6                	ld	ra,120(sp)
    800065d4:	7446                	ld	s0,112(sp)
    800065d6:	74a6                	ld	s1,104(sp)
    800065d8:	7906                	ld	s2,96(sp)
    800065da:	69e6                	ld	s3,88(sp)
    800065dc:	6a46                	ld	s4,80(sp)
    800065de:	6aa6                	ld	s5,72(sp)
    800065e0:	6b06                	ld	s6,64(sp)
    800065e2:	7be2                	ld	s7,56(sp)
    800065e4:	7c42                	ld	s8,48(sp)
    800065e6:	7ca2                	ld	s9,40(sp)
    800065e8:	7d02                	ld	s10,32(sp)
    800065ea:	6de2                	ld	s11,24(sp)
    800065ec:	6109                	addi	sp,sp,128
    800065ee:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065f0:	f8042503          	lw	a0,-128(s0)
    800065f4:	20050793          	addi	a5,a0,512
    800065f8:	0792                	slli	a5,a5,0x4
  if(write)
    800065fa:	0001d817          	auipc	a6,0x1d
    800065fe:	a0680813          	addi	a6,a6,-1530 # 80023000 <disk>
    80006602:	00f80733          	add	a4,a6,a5
    80006606:	01a036b3          	snez	a3,s10
    8000660a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000660e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006612:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006616:	7679                	lui	a2,0xffffe
    80006618:	963e                	add	a2,a2,a5
    8000661a:	0001f697          	auipc	a3,0x1f
    8000661e:	9e668693          	addi	a3,a3,-1562 # 80025000 <disk+0x2000>
    80006622:	6298                	ld	a4,0(a3)
    80006624:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006626:	0a878593          	addi	a1,a5,168
    8000662a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000662c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000662e:	6298                	ld	a4,0(a3)
    80006630:	9732                	add	a4,a4,a2
    80006632:	45c1                	li	a1,16
    80006634:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006636:	6298                	ld	a4,0(a3)
    80006638:	9732                	add	a4,a4,a2
    8000663a:	4585                	li	a1,1
    8000663c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006640:	f8442703          	lw	a4,-124(s0)
    80006644:	628c                	ld	a1,0(a3)
    80006646:	962e                	add	a2,a2,a1
    80006648:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000664c:	0712                	slli	a4,a4,0x4
    8000664e:	6290                	ld	a2,0(a3)
    80006650:	963a                	add	a2,a2,a4
    80006652:	058a8593          	addi	a1,s5,88
    80006656:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006658:	6294                	ld	a3,0(a3)
    8000665a:	96ba                	add	a3,a3,a4
    8000665c:	40000613          	li	a2,1024
    80006660:	c690                	sw	a2,8(a3)
  if(write)
    80006662:	e40d1ae3          	bnez	s10,800064b6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006666:	0001f697          	auipc	a3,0x1f
    8000666a:	99a6b683          	ld	a3,-1638(a3) # 80025000 <disk+0x2000>
    8000666e:	96ba                	add	a3,a3,a4
    80006670:	4609                	li	a2,2
    80006672:	00c69623          	sh	a2,12(a3)
    80006676:	b5b9                	j	800064c4 <virtio_disk_rw+0xd2>

0000000080006678 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006678:	1101                	addi	sp,sp,-32
    8000667a:	ec06                	sd	ra,24(sp)
    8000667c:	e822                	sd	s0,16(sp)
    8000667e:	e426                	sd	s1,8(sp)
    80006680:	e04a                	sd	s2,0(sp)
    80006682:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006684:	0001f517          	auipc	a0,0x1f
    80006688:	aa450513          	addi	a0,a0,-1372 # 80025128 <disk+0x2128>
    8000668c:	ffffa097          	auipc	ra,0xffffa
    80006690:	544080e7          	jalr	1348(ra) # 80000bd0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006694:	10001737          	lui	a4,0x10001
    80006698:	533c                	lw	a5,96(a4)
    8000669a:	8b8d                	andi	a5,a5,3
    8000669c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000669e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800066a2:	0001f797          	auipc	a5,0x1f
    800066a6:	95e78793          	addi	a5,a5,-1698 # 80025000 <disk+0x2000>
    800066aa:	6b94                	ld	a3,16(a5)
    800066ac:	0207d703          	lhu	a4,32(a5)
    800066b0:	0026d783          	lhu	a5,2(a3)
    800066b4:	06f70163          	beq	a4,a5,80006716 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066b8:	0001d917          	auipc	s2,0x1d
    800066bc:	94890913          	addi	s2,s2,-1720 # 80023000 <disk>
    800066c0:	0001f497          	auipc	s1,0x1f
    800066c4:	94048493          	addi	s1,s1,-1728 # 80025000 <disk+0x2000>
    __sync_synchronize();
    800066c8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800066cc:	6898                	ld	a4,16(s1)
    800066ce:	0204d783          	lhu	a5,32(s1)
    800066d2:	8b9d                	andi	a5,a5,7
    800066d4:	078e                	slli	a5,a5,0x3
    800066d6:	97ba                	add	a5,a5,a4
    800066d8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800066da:	20078713          	addi	a4,a5,512
    800066de:	0712                	slli	a4,a4,0x4
    800066e0:	974a                	add	a4,a4,s2
    800066e2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800066e6:	e731                	bnez	a4,80006732 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800066e8:	20078793          	addi	a5,a5,512
    800066ec:	0792                	slli	a5,a5,0x4
    800066ee:	97ca                	add	a5,a5,s2
    800066f0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800066f2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800066f6:	ffffc097          	auipc	ra,0xffffc
    800066fa:	b66080e7          	jalr	-1178(ra) # 8000225c <wakeup>

    disk.used_idx += 1;
    800066fe:	0204d783          	lhu	a5,32(s1)
    80006702:	2785                	addiw	a5,a5,1
    80006704:	17c2                	slli	a5,a5,0x30
    80006706:	93c1                	srli	a5,a5,0x30
    80006708:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000670c:	6898                	ld	a4,16(s1)
    8000670e:	00275703          	lhu	a4,2(a4)
    80006712:	faf71be3          	bne	a4,a5,800066c8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006716:	0001f517          	auipc	a0,0x1f
    8000671a:	a1250513          	addi	a0,a0,-1518 # 80025128 <disk+0x2128>
    8000671e:	ffffa097          	auipc	ra,0xffffa
    80006722:	566080e7          	jalr	1382(ra) # 80000c84 <release>
}
    80006726:	60e2                	ld	ra,24(sp)
    80006728:	6442                	ld	s0,16(sp)
    8000672a:	64a2                	ld	s1,8(sp)
    8000672c:	6902                	ld	s2,0(sp)
    8000672e:	6105                	addi	sp,sp,32
    80006730:	8082                	ret
      panic("virtio_disk_intr status");
    80006732:	00002517          	auipc	a0,0x2
    80006736:	1be50513          	addi	a0,a0,446 # 800088f0 <syscalls+0x3e0>
    8000673a:	ffffa097          	auipc	ra,0xffffa
    8000673e:	e00080e7          	jalr	-512(ra) # 8000053a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
