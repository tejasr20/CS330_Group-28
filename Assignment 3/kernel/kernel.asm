
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	c4013103          	ld	sp,-960(sp) # 80009c40 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = TIMER_INTERVAL; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	6661                	lui	a2,0x18
    8000003e:	6a060613          	addi	a2,a2,1696 # 186a0 <_entry-0x7ffe7960>
    80000042:	95b2                	add	a1,a1,a2
    80000044:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000046:	00269713          	slli	a4,a3,0x2
    8000004a:	9736                	add	a4,a4,a3
    8000004c:	00371693          	slli	a3,a4,0x3
    80000050:	0000a717          	auipc	a4,0xa
    80000054:	03070713          	addi	a4,a4,48 # 8000a080 <timer_scratch>
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
    80000062:	00008797          	auipc	a5,0x8
    80000066:	85e78793          	addi	a5,a5,-1954 # 800078c0 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd57ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	de078793          	addi	a5,a5,-544 # 80000e8c <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1
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
    80000112:	04c05663          	blez	a2,8000015e <consolewrite+0x5e>
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
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	082080e7          	jalr	130(ra) # 800031ac <either_copyin>
    80000132:	01550c63          	beq	a0,s5,8000014a <consolewrite+0x4a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	78e080e7          	jalr	1934(ra) # 800008c8 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
  }

  return i;
}
    8000014a:	854a                	mv	a0,s2
    8000014c:	60a6                	ld	ra,72(sp)
    8000014e:	6406                	ld	s0,64(sp)
    80000150:	74e2                	ld	s1,56(sp)
    80000152:	7942                	ld	s2,48(sp)
    80000154:	79a2                	ld	s3,40(sp)
    80000156:	7a02                	ld	s4,32(sp)
    80000158:	6ae2                	ld	s5,24(sp)
    8000015a:	6161                	addi	sp,sp,80
    8000015c:	8082                	ret
  for(i = 0; i < n; i++){
    8000015e:	4901                	li	s2,0
    80000160:	b7ed                	j	8000014a <consolewrite+0x4a>

0000000080000162 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000162:	7119                	addi	sp,sp,-128
    80000164:	fc86                	sd	ra,120(sp)
    80000166:	f8a2                	sd	s0,112(sp)
    80000168:	f4a6                	sd	s1,104(sp)
    8000016a:	f0ca                	sd	s2,96(sp)
    8000016c:	ecce                	sd	s3,88(sp)
    8000016e:	e8d2                	sd	s4,80(sp)
    80000170:	e4d6                	sd	s5,72(sp)
    80000172:	e0da                	sd	s6,64(sp)
    80000174:	fc5e                	sd	s7,56(sp)
    80000176:	f862                	sd	s8,48(sp)
    80000178:	f466                	sd	s9,40(sp)
    8000017a:	f06a                	sd	s10,32(sp)
    8000017c:	ec6e                	sd	s11,24(sp)
    8000017e:	0100                	addi	s0,sp,128
    80000180:	8b2a                	mv	s6,a0
    80000182:	8aae                	mv	s5,a1
    80000184:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000018a:	00012517          	auipc	a0,0x12
    8000018e:	03650513          	addi	a0,a0,54 # 800121c0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a50080e7          	jalr	-1456(ra) # 80000be2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00012497          	auipc	s1,0x12
    8000019e:	02648493          	addi	s1,s1,38 # 800121c0 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	89a6                	mv	s3,s1
    800001a4:	00012917          	auipc	s2,0x12
    800001a8:	0b490913          	addi	s2,s2,180 # 80012258 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001ac:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ae:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b0:	4da9                	li	s11,10
  while(n > 0){
    800001b2:	07405863          	blez	s4,80000222 <consoleread+0xc0>
    while(cons.r == cons.w){
    800001b6:	0984a783          	lw	a5,152(s1)
    800001ba:	09c4a703          	lw	a4,156(s1)
    800001be:	02f71463          	bne	a4,a5,800001e6 <consoleread+0x84>
      if(myproc()->killed){
    800001c2:	00001097          	auipc	ra,0x1
    800001c6:	7f6080e7          	jalr	2038(ra) # 800019b8 <myproc>
    800001ca:	551c                	lw	a5,40(a0)
    800001cc:	e7b5                	bnez	a5,80000238 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001ce:	85ce                	mv	a1,s3
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	588080e7          	jalr	1416(ra) # 8000275a <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fef700e3          	beq	a4,a5,800001c2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e6:	0017871b          	addiw	a4,a5,1
    800001ea:	08e4ac23          	sw	a4,152(s1)
    800001ee:	07f7f713          	andi	a4,a5,127
    800001f2:	9726                	add	a4,a4,s1
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800001fc:	079c0663          	beq	s8,s9,80000268 <consoleread+0x106>
    cbuf = c;
    80000200:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000204:	4685                	li	a3,1
    80000206:	f8f40613          	addi	a2,s0,-113
    8000020a:	85d6                	mv	a1,s5
    8000020c:	855a                	mv	a0,s6
    8000020e:	00003097          	auipc	ra,0x3
    80000212:	f48080e7          	jalr	-184(ra) # 80003156 <either_copyout>
    80000216:	01a50663          	beq	a0,s10,80000222 <consoleread+0xc0>
    dst++;
    8000021a:	0a85                	addi	s5,s5,1
    --n;
    8000021c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000021e:	f9bc1ae3          	bne	s8,s11,800001b2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000222:	00012517          	auipc	a0,0x12
    80000226:	f9e50513          	addi	a0,a0,-98 # 800121c0 <cons>
    8000022a:	00001097          	auipc	ra,0x1
    8000022e:	a6c080e7          	jalr	-1428(ra) # 80000c96 <release>

  return target - n;
    80000232:	414b853b          	subw	a0,s7,s4
    80000236:	a811                	j	8000024a <consoleread+0xe8>
        release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	f8850513          	addi	a0,a0,-120 # 800121c0 <cons>
    80000240:	00001097          	auipc	ra,0x1
    80000244:	a56080e7          	jalr	-1450(ra) # 80000c96 <release>
        return -1;
    80000248:	557d                	li	a0,-1
}
    8000024a:	70e6                	ld	ra,120(sp)
    8000024c:	7446                	ld	s0,112(sp)
    8000024e:	74a6                	ld	s1,104(sp)
    80000250:	7906                	ld	s2,96(sp)
    80000252:	69e6                	ld	s3,88(sp)
    80000254:	6a46                	ld	s4,80(sp)
    80000256:	6aa6                	ld	s5,72(sp)
    80000258:	6b06                	ld	s6,64(sp)
    8000025a:	7be2                	ld	s7,56(sp)
    8000025c:	7c42                	ld	s8,48(sp)
    8000025e:	7ca2                	ld	s9,40(sp)
    80000260:	7d02                	ld	s10,32(sp)
    80000262:	6de2                	ld	s11,24(sp)
    80000264:	6109                	addi	sp,sp,128
    80000266:	8082                	ret
      if(n < target){
    80000268:	000a071b          	sext.w	a4,s4
    8000026c:	fb777be3          	bgeu	a4,s7,80000222 <consoleread+0xc0>
        cons.r--;
    80000270:	00012717          	auipc	a4,0x12
    80000274:	fef72423          	sw	a5,-24(a4) # 80012258 <cons+0x98>
    80000278:	b76d                	j	80000222 <consoleread+0xc0>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50a63          	beq	a0,a5,8000029a <consputc+0x20>
    uartputc_sync(c);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	564080e7          	jalr	1380(ra) # 800007ee <uartputc_sync>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029a:	4521                	li	a0,8
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	552080e7          	jalr	1362(ra) # 800007ee <uartputc_sync>
    800002a4:	02000513          	li	a0,32
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	546080e7          	jalr	1350(ra) # 800007ee <uartputc_sync>
    800002b0:	4521                	li	a0,8
    800002b2:	00000097          	auipc	ra,0x0
    800002b6:	53c080e7          	jalr	1340(ra) # 800007ee <uartputc_sync>
    800002ba:	bfe1                	j	80000292 <consputc+0x18>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	e04a                	sd	s2,0(sp)
    800002c6:	1000                	addi	s0,sp,32
    800002c8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ca:	00012517          	auipc	a0,0x12
    800002ce:	ef650513          	addi	a0,a0,-266 # 800121c0 <cons>
    800002d2:	00001097          	auipc	ra,0x1
    800002d6:	910080e7          	jalr	-1776(ra) # 80000be2 <acquire>

  switch(c){
    800002da:	47d5                	li	a5,21
    800002dc:	0af48663          	beq	s1,a5,80000388 <consoleintr+0xcc>
    800002e0:	0297ca63          	blt	a5,s1,80000314 <consoleintr+0x58>
    800002e4:	47a1                	li	a5,8
    800002e6:	0ef48763          	beq	s1,a5,800003d4 <consoleintr+0x118>
    800002ea:	47c1                	li	a5,16
    800002ec:	10f49a63          	bne	s1,a5,80000400 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f0:	00003097          	auipc	ra,0x3
    800002f4:	f12080e7          	jalr	-238(ra) # 80003202 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f8:	00012517          	auipc	a0,0x12
    800002fc:	ec850513          	addi	a0,a0,-312 # 800121c0 <cons>
    80000300:	00001097          	auipc	ra,0x1
    80000304:	996080e7          	jalr	-1642(ra) # 80000c96 <release>
}
    80000308:	60e2                	ld	ra,24(sp)
    8000030a:	6442                	ld	s0,16(sp)
    8000030c:	64a2                	ld	s1,8(sp)
    8000030e:	6902                	ld	s2,0(sp)
    80000310:	6105                	addi	sp,sp,32
    80000312:	8082                	ret
  switch(c){
    80000314:	07f00793          	li	a5,127
    80000318:	0af48e63          	beq	s1,a5,800003d4 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000031c:	00012717          	auipc	a4,0x12
    80000320:	ea470713          	addi	a4,a4,-348 # 800121c0 <cons>
    80000324:	0a072783          	lw	a5,160(a4)
    80000328:	09872703          	lw	a4,152(a4)
    8000032c:	9f99                	subw	a5,a5,a4
    8000032e:	07f00713          	li	a4,127
    80000332:	fcf763e3          	bltu	a4,a5,800002f8 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000336:	47b5                	li	a5,13
    80000338:	0cf48763          	beq	s1,a5,80000406 <consoleintr+0x14a>
      consputc(c);
    8000033c:	8526                	mv	a0,s1
    8000033e:	00000097          	auipc	ra,0x0
    80000342:	f3c080e7          	jalr	-196(ra) # 8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000346:	00012797          	auipc	a5,0x12
    8000034a:	e7a78793          	addi	a5,a5,-390 # 800121c0 <cons>
    8000034e:	0a07a703          	lw	a4,160(a5)
    80000352:	0017069b          	addiw	a3,a4,1
    80000356:	0006861b          	sext.w	a2,a3
    8000035a:	0ad7a023          	sw	a3,160(a5)
    8000035e:	07f77713          	andi	a4,a4,127
    80000362:	97ba                	add	a5,a5,a4
    80000364:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000368:	47a9                	li	a5,10
    8000036a:	0cf48563          	beq	s1,a5,80000434 <consoleintr+0x178>
    8000036e:	4791                	li	a5,4
    80000370:	0cf48263          	beq	s1,a5,80000434 <consoleintr+0x178>
    80000374:	00012797          	auipc	a5,0x12
    80000378:	ee47a783          	lw	a5,-284(a5) # 80012258 <cons+0x98>
    8000037c:	0807879b          	addiw	a5,a5,128
    80000380:	f6f61ce3          	bne	a2,a5,800002f8 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000384:	863e                	mv	a2,a5
    80000386:	a07d                	j	80000434 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000388:	00012717          	auipc	a4,0x12
    8000038c:	e3870713          	addi	a4,a4,-456 # 800121c0 <cons>
    80000390:	0a072783          	lw	a5,160(a4)
    80000394:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000398:	00012497          	auipc	s1,0x12
    8000039c:	e2848493          	addi	s1,s1,-472 # 800121c0 <cons>
    while(cons.e != cons.w &&
    800003a0:	4929                	li	s2,10
    800003a2:	f4f70be3          	beq	a4,a5,800002f8 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a6:	37fd                	addiw	a5,a5,-1
    800003a8:	07f7f713          	andi	a4,a5,127
    800003ac:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ae:	01874703          	lbu	a4,24(a4)
    800003b2:	f52703e3          	beq	a4,s2,800002f8 <consoleintr+0x3c>
      cons.e--;
    800003b6:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ba:	10000513          	li	a0,256
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	ebc080e7          	jalr	-324(ra) # 8000027a <consputc>
    while(cons.e != cons.w &&
    800003c6:	0a04a783          	lw	a5,160(s1)
    800003ca:	09c4a703          	lw	a4,156(s1)
    800003ce:	fcf71ce3          	bne	a4,a5,800003a6 <consoleintr+0xea>
    800003d2:	b71d                	j	800002f8 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d4:	00012717          	auipc	a4,0x12
    800003d8:	dec70713          	addi	a4,a4,-532 # 800121c0 <cons>
    800003dc:	0a072783          	lw	a5,160(a4)
    800003e0:	09c72703          	lw	a4,156(a4)
    800003e4:	f0f70ae3          	beq	a4,a5,800002f8 <consoleintr+0x3c>
      cons.e--;
    800003e8:	37fd                	addiw	a5,a5,-1
    800003ea:	00012717          	auipc	a4,0x12
    800003ee:	e6f72b23          	sw	a5,-394(a4) # 80012260 <cons+0xa0>
      consputc(BACKSPACE);
    800003f2:	10000513          	li	a0,256
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e84080e7          	jalr	-380(ra) # 8000027a <consputc>
    800003fe:	bded                	j	800002f8 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000400:	ee048ce3          	beqz	s1,800002f8 <consoleintr+0x3c>
    80000404:	bf21                	j	8000031c <consoleintr+0x60>
      consputc(c);
    80000406:	4529                	li	a0,10
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	e72080e7          	jalr	-398(ra) # 8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000410:	00012797          	auipc	a5,0x12
    80000414:	db078793          	addi	a5,a5,-592 # 800121c0 <cons>
    80000418:	0a07a703          	lw	a4,160(a5)
    8000041c:	0017069b          	addiw	a3,a4,1
    80000420:	0006861b          	sext.w	a2,a3
    80000424:	0ad7a023          	sw	a3,160(a5)
    80000428:	07f77713          	andi	a4,a4,127
    8000042c:	97ba                	add	a5,a5,a4
    8000042e:	4729                	li	a4,10
    80000430:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000434:	00012797          	auipc	a5,0x12
    80000438:	e2c7a423          	sw	a2,-472(a5) # 8001225c <cons+0x9c>
        wakeup(&cons.r);
    8000043c:	00012517          	auipc	a0,0x12
    80000440:	e1c50513          	addi	a0,a0,-484 # 80012258 <cons+0x98>
    80000444:	00002097          	auipc	ra,0x2
    80000448:	71c080e7          	jalr	1820(ra) # 80002b60 <wakeup>
    8000044c:	b575                	j	800002f8 <consoleintr+0x3c>

000000008000044e <consoleinit>:

void
consoleinit(void)
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000456:	00009597          	auipc	a1,0x9
    8000045a:	bba58593          	addi	a1,a1,-1094 # 80009010 <etext+0x10>
    8000045e:	00012517          	auipc	a0,0x12
    80000462:	d6250513          	addi	a0,a0,-670 # 800121c0 <cons>
    80000466:	00000097          	auipc	ra,0x0
    8000046a:	6ec080e7          	jalr	1772(ra) # 80000b52 <initlock>

  uartinit();
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	330080e7          	jalr	816(ra) # 8000079e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000476:	00024797          	auipc	a5,0x24
    8000047a:	18278793          	addi	a5,a5,386 # 800245f8 <devsw>
    8000047e:	00000717          	auipc	a4,0x0
    80000482:	ce470713          	addi	a4,a4,-796 # 80000162 <consoleread>
    80000486:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000488:	00000717          	auipc	a4,0x0
    8000048c:	c7870713          	addi	a4,a4,-904 # 80000100 <consolewrite>
    80000490:	ef98                	sd	a4,24(a5)
}
    80000492:	60a2                	ld	ra,8(sp)
    80000494:	6402                	ld	s0,0(sp)
    80000496:	0141                	addi	sp,sp,16
    80000498:	8082                	ret

000000008000049a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049a:	7179                	addi	sp,sp,-48
    8000049c:	f406                	sd	ra,40(sp)
    8000049e:	f022                	sd	s0,32(sp)
    800004a0:	ec26                	sd	s1,24(sp)
    800004a2:	e84a                	sd	s2,16(sp)
    800004a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a6:	c219                	beqz	a2,800004ac <printint+0x12>
    800004a8:	08054663          	bltz	a0,80000534 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ac:	2501                	sext.w	a0,a0
    800004ae:	4881                	li	a7,0
    800004b0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b6:	2581                	sext.w	a1,a1
    800004b8:	00009617          	auipc	a2,0x9
    800004bc:	b8860613          	addi	a2,a2,-1144 # 80009040 <digits>
    800004c0:	883a                	mv	a6,a4
    800004c2:	2705                	addiw	a4,a4,1
    800004c4:	02b577bb          	remuw	a5,a0,a1
    800004c8:	1782                	slli	a5,a5,0x20
    800004ca:	9381                	srli	a5,a5,0x20
    800004cc:	97b2                	add	a5,a5,a2
    800004ce:	0007c783          	lbu	a5,0(a5)
    800004d2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d6:	0005079b          	sext.w	a5,a0
    800004da:	02b5553b          	divuw	a0,a0,a1
    800004de:	0685                	addi	a3,a3,1
    800004e0:	feb7f0e3          	bgeu	a5,a1,800004c0 <printint+0x26>

  if(sign)
    800004e4:	00088b63          	beqz	a7,800004fa <printint+0x60>
    buf[i++] = '-';
    800004e8:	fe040793          	addi	a5,s0,-32
    800004ec:	973e                	add	a4,a4,a5
    800004ee:	02d00793          	li	a5,45
    800004f2:	fef70823          	sb	a5,-16(a4)
    800004f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fa:	02e05763          	blez	a4,80000528 <printint+0x8e>
    800004fe:	fd040793          	addi	a5,s0,-48
    80000502:	00e784b3          	add	s1,a5,a4
    80000506:	fff78913          	addi	s2,a5,-1
    8000050a:	993a                	add	s2,s2,a4
    8000050c:	377d                	addiw	a4,a4,-1
    8000050e:	1702                	slli	a4,a4,0x20
    80000510:	9301                	srli	a4,a4,0x20
    80000512:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000516:	fff4c503          	lbu	a0,-1(s1)
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	d60080e7          	jalr	-672(ra) # 8000027a <consputc>
  while(--i >= 0)
    80000522:	14fd                	addi	s1,s1,-1
    80000524:	ff2499e3          	bne	s1,s2,80000516 <printint+0x7c>
}
    80000528:	70a2                	ld	ra,40(sp)
    8000052a:	7402                	ld	s0,32(sp)
    8000052c:	64e2                	ld	s1,24(sp)
    8000052e:	6942                	ld	s2,16(sp)
    80000530:	6145                	addi	sp,sp,48
    80000532:	8082                	ret
    x = -xx;
    80000534:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000538:	4885                	li	a7,1
    x = -xx;
    8000053a:	bf9d                	j	800004b0 <printint+0x16>

000000008000053c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053c:	1101                	addi	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	addi	s0,sp,32
    80000546:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000548:	00012797          	auipc	a5,0x12
    8000054c:	d207ac23          	sw	zero,-712(a5) # 80012280 <pr+0x18>
  printf("panic: ");
    80000550:	00009517          	auipc	a0,0x9
    80000554:	ac850513          	addi	a0,a0,-1336 # 80009018 <etext+0x18>
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	02e080e7          	jalr	46(ra) # 80000586 <printf>
  printf(s);
    80000560:	8526                	mv	a0,s1
    80000562:	00000097          	auipc	ra,0x0
    80000566:	024080e7          	jalr	36(ra) # 80000586 <printf>
  printf("\n");
    8000056a:	00009517          	auipc	a0,0x9
    8000056e:	34e50513          	addi	a0,a0,846 # 800098b8 <syscalls+0x158>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	014080e7          	jalr	20(ra) # 80000586 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057a:	4785                	li	a5,1
    8000057c:	0000a717          	auipc	a4,0xa
    80000580:	a8f72223          	sw	a5,-1404(a4) # 8000a000 <panicked>
  for(;;)
    80000584:	a001                	j	80000584 <panic+0x48>

0000000080000586 <printf>:
{
    80000586:	7131                	addi	sp,sp,-192
    80000588:	fc86                	sd	ra,120(sp)
    8000058a:	f8a2                	sd	s0,112(sp)
    8000058c:	f4a6                	sd	s1,104(sp)
    8000058e:	f0ca                	sd	s2,96(sp)
    80000590:	ecce                	sd	s3,88(sp)
    80000592:	e8d2                	sd	s4,80(sp)
    80000594:	e4d6                	sd	s5,72(sp)
    80000596:	e0da                	sd	s6,64(sp)
    80000598:	fc5e                	sd	s7,56(sp)
    8000059a:	f862                	sd	s8,48(sp)
    8000059c:	f466                	sd	s9,40(sp)
    8000059e:	f06a                	sd	s10,32(sp)
    800005a0:	ec6e                	sd	s11,24(sp)
    800005a2:	0100                	addi	s0,sp,128
    800005a4:	8a2a                	mv	s4,a0
    800005a6:	e40c                	sd	a1,8(s0)
    800005a8:	e810                	sd	a2,16(s0)
    800005aa:	ec14                	sd	a3,24(s0)
    800005ac:	f018                	sd	a4,32(s0)
    800005ae:	f41c                	sd	a5,40(s0)
    800005b0:	03043823          	sd	a6,48(s0)
    800005b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b8:	00012d97          	auipc	s11,0x12
    800005bc:	cc8dad83          	lw	s11,-824(s11) # 80012280 <pr+0x18>
  if(locking)
    800005c0:	020d9b63          	bnez	s11,800005f6 <printf+0x70>
  if (fmt == 0)
    800005c4:	040a0263          	beqz	s4,80000608 <printf+0x82>
  va_start(ap, fmt);
    800005c8:	00840793          	addi	a5,s0,8
    800005cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d0:	000a4503          	lbu	a0,0(s4)
    800005d4:	16050263          	beqz	a0,80000738 <printf+0x1b2>
    800005d8:	4481                	li	s1,0
    if(c != '%'){
    800005da:	02500a93          	li	s5,37
    switch(c){
    800005de:	07000b13          	li	s6,112
  consputc('x');
    800005e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e4:	00009b97          	auipc	s7,0x9
    800005e8:	a5cb8b93          	addi	s7,s7,-1444 # 80009040 <digits>
    switch(c){
    800005ec:	07300c93          	li	s9,115
    800005f0:	06400c13          	li	s8,100
    800005f4:	a82d                	j	8000062e <printf+0xa8>
    acquire(&pr.lock);
    800005f6:	00012517          	auipc	a0,0x12
    800005fa:	c7250513          	addi	a0,a0,-910 # 80012268 <pr>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	5e4080e7          	jalr	1508(ra) # 80000be2 <acquire>
    80000606:	bf7d                	j	800005c4 <printf+0x3e>
    panic("null fmt");
    80000608:	00009517          	auipc	a0,0x9
    8000060c:	a2050513          	addi	a0,a0,-1504 # 80009028 <etext+0x28>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2c080e7          	jalr	-212(ra) # 8000053c <panic>
      consputc(c);
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	c62080e7          	jalr	-926(ra) # 8000027a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000620:	2485                	addiw	s1,s1,1
    80000622:	009a07b3          	add	a5,s4,s1
    80000626:	0007c503          	lbu	a0,0(a5)
    8000062a:	10050763          	beqz	a0,80000738 <printf+0x1b2>
    if(c != '%'){
    8000062e:	ff5515e3          	bne	a0,s5,80000618 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000632:	2485                	addiw	s1,s1,1
    80000634:	009a07b3          	add	a5,s4,s1
    80000638:	0007c783          	lbu	a5,0(a5)
    8000063c:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000640:	cfe5                	beqz	a5,80000738 <printf+0x1b2>
    switch(c){
    80000642:	05678a63          	beq	a5,s6,80000696 <printf+0x110>
    80000646:	02fb7663          	bgeu	s6,a5,80000672 <printf+0xec>
    8000064a:	09978963          	beq	a5,s9,800006dc <printf+0x156>
    8000064e:	07800713          	li	a4,120
    80000652:	0ce79863          	bne	a5,a4,80000722 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000656:	f8843783          	ld	a5,-120(s0)
    8000065a:	00878713          	addi	a4,a5,8
    8000065e:	f8e43423          	sd	a4,-120(s0)
    80000662:	4605                	li	a2,1
    80000664:	85ea                	mv	a1,s10
    80000666:	4388                	lw	a0,0(a5)
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	e32080e7          	jalr	-462(ra) # 8000049a <printint>
      break;
    80000670:	bf45                	j	80000620 <printf+0x9a>
    switch(c){
    80000672:	0b578263          	beq	a5,s5,80000716 <printf+0x190>
    80000676:	0b879663          	bne	a5,s8,80000722 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	addi	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4605                	li	a2,1
    80000688:	45a9                	li	a1,10
    8000068a:	4388                	lw	a0,0(a5)
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	e0e080e7          	jalr	-498(ra) # 8000049a <printint>
      break;
    80000694:	b771                	j	80000620 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006a6:	03000513          	li	a0,48
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bd0080e7          	jalr	-1072(ra) # 8000027a <consputc>
  consputc('x');
    800006b2:	07800513          	li	a0,120
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bc4080e7          	jalr	-1084(ra) # 8000027a <consputc>
    800006be:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c0:	03c9d793          	srli	a5,s3,0x3c
    800006c4:	97de                	add	a5,a5,s7
    800006c6:	0007c503          	lbu	a0,0(a5)
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	bb0080e7          	jalr	-1104(ra) # 8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d2:	0992                	slli	s3,s3,0x4
    800006d4:	397d                	addiw	s2,s2,-1
    800006d6:	fe0915e3          	bnez	s2,800006c0 <printf+0x13a>
    800006da:	b799                	j	80000620 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	0007b903          	ld	s2,0(a5)
    800006ec:	00090e63          	beqz	s2,80000708 <printf+0x182>
      for(; *s; s++)
    800006f0:	00094503          	lbu	a0,0(s2)
    800006f4:	d515                	beqz	a0,80000620 <printf+0x9a>
        consputc(*s);
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	b84080e7          	jalr	-1148(ra) # 8000027a <consputc>
      for(; *s; s++)
    800006fe:	0905                	addi	s2,s2,1
    80000700:	00094503          	lbu	a0,0(s2)
    80000704:	f96d                	bnez	a0,800006f6 <printf+0x170>
    80000706:	bf29                	j	80000620 <printf+0x9a>
        s = "(null)";
    80000708:	00009917          	auipc	s2,0x9
    8000070c:	91890913          	addi	s2,s2,-1768 # 80009020 <etext+0x20>
      for(; *s; s++)
    80000710:	02800513          	li	a0,40
    80000714:	b7cd                	j	800006f6 <printf+0x170>
      consputc('%');
    80000716:	8556                	mv	a0,s5
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	b62080e7          	jalr	-1182(ra) # 8000027a <consputc>
      break;
    80000720:	b701                	j	80000620 <printf+0x9a>
      consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b56080e7          	jalr	-1194(ra) # 8000027a <consputc>
      consputc(c);
    8000072c:	854a                	mv	a0,s2
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b4c080e7          	jalr	-1204(ra) # 8000027a <consputc>
      break;
    80000736:	b5ed                	j	80000620 <printf+0x9a>
  if(locking)
    80000738:	020d9163          	bnez	s11,8000075a <printf+0x1d4>
}
    8000073c:	70e6                	ld	ra,120(sp)
    8000073e:	7446                	ld	s0,112(sp)
    80000740:	74a6                	ld	s1,104(sp)
    80000742:	7906                	ld	s2,96(sp)
    80000744:	69e6                	ld	s3,88(sp)
    80000746:	6a46                	ld	s4,80(sp)
    80000748:	6aa6                	ld	s5,72(sp)
    8000074a:	6b06                	ld	s6,64(sp)
    8000074c:	7be2                	ld	s7,56(sp)
    8000074e:	7c42                	ld	s8,48(sp)
    80000750:	7ca2                	ld	s9,40(sp)
    80000752:	7d02                	ld	s10,32(sp)
    80000754:	6de2                	ld	s11,24(sp)
    80000756:	6129                	addi	sp,sp,192
    80000758:	8082                	ret
    release(&pr.lock);
    8000075a:	00012517          	auipc	a0,0x12
    8000075e:	b0e50513          	addi	a0,a0,-1266 # 80012268 <pr>
    80000762:	00000097          	auipc	ra,0x0
    80000766:	534080e7          	jalr	1332(ra) # 80000c96 <release>
}
    8000076a:	bfc9                	j	8000073c <printf+0x1b6>

000000008000076c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076c:	1101                	addi	sp,sp,-32
    8000076e:	ec06                	sd	ra,24(sp)
    80000770:	e822                	sd	s0,16(sp)
    80000772:	e426                	sd	s1,8(sp)
    80000774:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000776:	00012497          	auipc	s1,0x12
    8000077a:	af248493          	addi	s1,s1,-1294 # 80012268 <pr>
    8000077e:	00009597          	auipc	a1,0x9
    80000782:	8ba58593          	addi	a1,a1,-1862 # 80009038 <etext+0x38>
    80000786:	8526                	mv	a0,s1
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	3ca080e7          	jalr	970(ra) # 80000b52 <initlock>
  pr.locking = 1;
    80000790:	4785                	li	a5,1
    80000792:	cc9c                	sw	a5,24(s1)
}
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6105                	addi	sp,sp,32
    8000079c:	8082                	ret

000000008000079e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079e:	1141                	addi	sp,sp,-16
    800007a0:	e406                	sd	ra,8(sp)
    800007a2:	e022                	sd	s0,0(sp)
    800007a4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a6:	100007b7          	lui	a5,0x10000
    800007aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ae:	f8000713          	li	a4,-128
    800007b2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b6:	470d                	li	a4,3
    800007b8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c4:	469d                	li	a3,7
    800007c6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ca:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ce:	00009597          	auipc	a1,0x9
    800007d2:	88a58593          	addi	a1,a1,-1910 # 80009058 <digits+0x18>
    800007d6:	00012517          	auipc	a0,0x12
    800007da:	ab250513          	addi	a0,a0,-1358 # 80012288 <uart_tx_lock>
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	374080e7          	jalr	884(ra) # 80000b52 <initlock>
}
    800007e6:	60a2                	ld	ra,8(sp)
    800007e8:	6402                	ld	s0,0(sp)
    800007ea:	0141                	addi	sp,sp,16
    800007ec:	8082                	ret

00000000800007ee <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ee:	1101                	addi	sp,sp,-32
    800007f0:	ec06                	sd	ra,24(sp)
    800007f2:	e822                	sd	s0,16(sp)
    800007f4:	e426                	sd	s1,8(sp)
    800007f6:	1000                	addi	s0,sp,32
    800007f8:	84aa                	mv	s1,a0
  push_off();
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	39c080e7          	jalr	924(ra) # 80000b96 <push_off>

  if(panicked){
    80000802:	00009797          	auipc	a5,0x9
    80000806:	7fe7a783          	lw	a5,2046(a5) # 8000a000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080e:	c391                	beqz	a5,80000812 <uartputc_sync+0x24>
    for(;;)
    80000810:	a001                	j	80000810 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000816:	0ff7f793          	andi	a5,a5,255
    8000081a:	0207f793          	andi	a5,a5,32
    8000081e:	dbf5                	beqz	a5,80000812 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000820:	0ff4f793          	andi	a5,s1,255
    80000824:	10000737          	lui	a4,0x10000
    80000828:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	40a080e7          	jalr	1034(ra) # 80000c36 <pop_off>
}
    80000834:	60e2                	ld	ra,24(sp)
    80000836:	6442                	ld	s0,16(sp)
    80000838:	64a2                	ld	s1,8(sp)
    8000083a:	6105                	addi	sp,sp,32
    8000083c:	8082                	ret

000000008000083e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000083e:	00009717          	auipc	a4,0x9
    80000842:	7ca73703          	ld	a4,1994(a4) # 8000a008 <uart_tx_r>
    80000846:	00009797          	auipc	a5,0x9
    8000084a:	7ca7b783          	ld	a5,1994(a5) # 8000a010 <uart_tx_w>
    8000084e:	06e78c63          	beq	a5,a4,800008c6 <uartstart+0x88>
{
    80000852:	7139                	addi	sp,sp,-64
    80000854:	fc06                	sd	ra,56(sp)
    80000856:	f822                	sd	s0,48(sp)
    80000858:	f426                	sd	s1,40(sp)
    8000085a:	f04a                	sd	s2,32(sp)
    8000085c:	ec4e                	sd	s3,24(sp)
    8000085e:	e852                	sd	s4,16(sp)
    80000860:	e456                	sd	s5,8(sp)
    80000862:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000868:	00012a17          	auipc	s4,0x12
    8000086c:	a20a0a13          	addi	s4,s4,-1504 # 80012288 <uart_tx_lock>
    uart_tx_r += 1;
    80000870:	00009497          	auipc	s1,0x9
    80000874:	79848493          	addi	s1,s1,1944 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000878:	00009997          	auipc	s3,0x9
    8000087c:	79898993          	addi	s3,s3,1944 # 8000a010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000880:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000884:	0ff7f793          	andi	a5,a5,255
    80000888:	0207f793          	andi	a5,a5,32
    8000088c:	c785                	beqz	a5,800008b4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000088e:	01f77793          	andi	a5,a4,31
    80000892:	97d2                	add	a5,a5,s4
    80000894:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80000898:	0705                	addi	a4,a4,1
    8000089a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000089c:	8526                	mv	a0,s1
    8000089e:	00002097          	auipc	ra,0x2
    800008a2:	2c2080e7          	jalr	706(ra) # 80002b60 <wakeup>
    
    WriteReg(THR, c);
    800008a6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008aa:	6098                	ld	a4,0(s1)
    800008ac:	0009b783          	ld	a5,0(s3)
    800008b0:	fce798e3          	bne	a5,a4,80000880 <uartstart+0x42>
  }
}
    800008b4:	70e2                	ld	ra,56(sp)
    800008b6:	7442                	ld	s0,48(sp)
    800008b8:	74a2                	ld	s1,40(sp)
    800008ba:	7902                	ld	s2,32(sp)
    800008bc:	69e2                	ld	s3,24(sp)
    800008be:	6a42                	ld	s4,16(sp)
    800008c0:	6aa2                	ld	s5,8(sp)
    800008c2:	6121                	addi	sp,sp,64
    800008c4:	8082                	ret
    800008c6:	8082                	ret

00000000800008c8 <uartputc>:
{
    800008c8:	7179                	addi	sp,sp,-48
    800008ca:	f406                	sd	ra,40(sp)
    800008cc:	f022                	sd	s0,32(sp)
    800008ce:	ec26                	sd	s1,24(sp)
    800008d0:	e84a                	sd	s2,16(sp)
    800008d2:	e44e                	sd	s3,8(sp)
    800008d4:	e052                	sd	s4,0(sp)
    800008d6:	1800                	addi	s0,sp,48
    800008d8:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008da:	00012517          	auipc	a0,0x12
    800008de:	9ae50513          	addi	a0,a0,-1618 # 80012288 <uart_tx_lock>
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	300080e7          	jalr	768(ra) # 80000be2 <acquire>
  if(panicked){
    800008ea:	00009797          	auipc	a5,0x9
    800008ee:	7167a783          	lw	a5,1814(a5) # 8000a000 <panicked>
    800008f2:	c391                	beqz	a5,800008f6 <uartputc+0x2e>
    for(;;)
    800008f4:	a001                	j	800008f4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008f6:	00009797          	auipc	a5,0x9
    800008fa:	71a7b783          	ld	a5,1818(a5) # 8000a010 <uart_tx_w>
    800008fe:	00009717          	auipc	a4,0x9
    80000902:	70a73703          	ld	a4,1802(a4) # 8000a008 <uart_tx_r>
    80000906:	02070713          	addi	a4,a4,32
    8000090a:	02f71b63          	bne	a4,a5,80000940 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000090e:	00012a17          	auipc	s4,0x12
    80000912:	97aa0a13          	addi	s4,s4,-1670 # 80012288 <uart_tx_lock>
    80000916:	00009497          	auipc	s1,0x9
    8000091a:	6f248493          	addi	s1,s1,1778 # 8000a008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000091e:	00009917          	auipc	s2,0x9
    80000922:	6f290913          	addi	s2,s2,1778 # 8000a010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000926:	85d2                	mv	a1,s4
    80000928:	8526                	mv	a0,s1
    8000092a:	00002097          	auipc	ra,0x2
    8000092e:	e30080e7          	jalr	-464(ra) # 8000275a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000932:	00093783          	ld	a5,0(s2)
    80000936:	6098                	ld	a4,0(s1)
    80000938:	02070713          	addi	a4,a4,32
    8000093c:	fef705e3          	beq	a4,a5,80000926 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000940:	00012497          	auipc	s1,0x12
    80000944:	94848493          	addi	s1,s1,-1720 # 80012288 <uart_tx_lock>
    80000948:	01f7f713          	andi	a4,a5,31
    8000094c:	9726                	add	a4,a4,s1
    8000094e:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80000952:	0785                	addi	a5,a5,1
    80000954:	00009717          	auipc	a4,0x9
    80000958:	6af73e23          	sd	a5,1724(a4) # 8000a010 <uart_tx_w>
      uartstart();
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	ee2080e7          	jalr	-286(ra) # 8000083e <uartstart>
      release(&uart_tx_lock);
    80000964:	8526                	mv	a0,s1
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	330080e7          	jalr	816(ra) # 80000c96 <release>
}
    8000096e:	70a2                	ld	ra,40(sp)
    80000970:	7402                	ld	s0,32(sp)
    80000972:	64e2                	ld	s1,24(sp)
    80000974:	6942                	ld	s2,16(sp)
    80000976:	69a2                	ld	s3,8(sp)
    80000978:	6a02                	ld	s4,0(sp)
    8000097a:	6145                	addi	sp,sp,48
    8000097c:	8082                	ret

000000008000097e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000097e:	1141                	addi	sp,sp,-16
    80000980:	e422                	sd	s0,8(sp)
    80000982:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000098c:	8b85                	andi	a5,a5,1
    8000098e:	cb91                	beqz	a5,800009a2 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000990:	100007b7          	lui	a5,0x10000
    80000994:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000998:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000099c:	6422                	ld	s0,8(sp)
    8000099e:	0141                	addi	sp,sp,16
    800009a0:	8082                	ret
    return -1;
    800009a2:	557d                	li	a0,-1
    800009a4:	bfe5                	j	8000099c <uartgetc+0x1e>

00000000800009a6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009a6:	1101                	addi	sp,sp,-32
    800009a8:	ec06                	sd	ra,24(sp)
    800009aa:	e822                	sd	s0,16(sp)
    800009ac:	e426                	sd	s1,8(sp)
    800009ae:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b0:	54fd                	li	s1,-1
    int c = uartgetc();
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	fcc080e7          	jalr	-52(ra) # 8000097e <uartgetc>
    if(c == -1)
    800009ba:	00950763          	beq	a0,s1,800009c8 <uartintr+0x22>
      break;
    consoleintr(c);
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	8fe080e7          	jalr	-1794(ra) # 800002bc <consoleintr>
  while(1){
    800009c6:	b7f5                	j	800009b2 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009c8:	00012497          	auipc	s1,0x12
    800009cc:	8c048493          	addi	s1,s1,-1856 # 80012288 <uart_tx_lock>
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	210080e7          	jalr	528(ra) # 80000be2 <acquire>
  uartstart();
    800009da:	00000097          	auipc	ra,0x0
    800009de:	e64080e7          	jalr	-412(ra) # 8000083e <uartstart>
  release(&uart_tx_lock);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	2b2080e7          	jalr	690(ra) # 80000c96 <release>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret

00000000800009f6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009f6:	1101                	addi	sp,sp,-32
    800009f8:	ec06                	sd	ra,24(sp)
    800009fa:	e822                	sd	s0,16(sp)
    800009fc:	e426                	sd	s1,8(sp)
    800009fe:	e04a                	sd	s2,0(sp)
    80000a00:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a02:	03451793          	slli	a5,a0,0x34
    80000a06:	ebb9                	bnez	a5,80000a5c <kfree+0x66>
    80000a08:	84aa                	mv	s1,a0
    80000a0a:	00028797          	auipc	a5,0x28
    80000a0e:	5f678793          	addi	a5,a5,1526 # 80029000 <end>
    80000a12:	04f56563          	bltu	a0,a5,80000a5c <kfree+0x66>
    80000a16:	47c5                	li	a5,17
    80000a18:	07ee                	slli	a5,a5,0x1b
    80000a1a:	04f57163          	bgeu	a0,a5,80000a5c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a1e:	6605                	lui	a2,0x1
    80000a20:	4585                	li	a1,1
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	2bc080e7          	jalr	700(ra) # 80000cde <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a2a:	00012917          	auipc	s2,0x12
    80000a2e:	89690913          	addi	s2,s2,-1898 # 800122c0 <kmem>
    80000a32:	854a                	mv	a0,s2
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	1ae080e7          	jalr	430(ra) # 80000be2 <acquire>
  r->next = kmem.freelist;
    80000a3c:	01893783          	ld	a5,24(s2)
    80000a40:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a42:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a46:	854a                	mv	a0,s2
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	24e080e7          	jalr	590(ra) # 80000c96 <release>
}
    80000a50:	60e2                	ld	ra,24(sp)
    80000a52:	6442                	ld	s0,16(sp)
    80000a54:	64a2                	ld	s1,8(sp)
    80000a56:	6902                	ld	s2,0(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret
    panic("kfree");
    80000a5c:	00008517          	auipc	a0,0x8
    80000a60:	60450513          	addi	a0,a0,1540 # 80009060 <digits+0x20>
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	ad8080e7          	jalr	-1320(ra) # 8000053c <panic>

0000000080000a6c <freerange>:
{
    80000a6c:	7179                	addi	sp,sp,-48
    80000a6e:	f406                	sd	ra,40(sp)
    80000a70:	f022                	sd	s0,32(sp)
    80000a72:	ec26                	sd	s1,24(sp)
    80000a74:	e84a                	sd	s2,16(sp)
    80000a76:	e44e                	sd	s3,8(sp)
    80000a78:	e052                	sd	s4,0(sp)
    80000a7a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a7c:	6785                	lui	a5,0x1
    80000a7e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a82:	94aa                	add	s1,s1,a0
    80000a84:	757d                	lui	a0,0xfffff
    80000a86:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a88:	94be                	add	s1,s1,a5
    80000a8a:	0095ee63          	bltu	a1,s1,80000aa6 <freerange+0x3a>
    80000a8e:	892e                	mv	s2,a1
    kfree(p);
    80000a90:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a92:	6985                	lui	s3,0x1
    kfree(p);
    80000a94:	01448533          	add	a0,s1,s4
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	f5e080e7          	jalr	-162(ra) # 800009f6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa0:	94ce                	add	s1,s1,s3
    80000aa2:	fe9979e3          	bgeu	s2,s1,80000a94 <freerange+0x28>
}
    80000aa6:	70a2                	ld	ra,40(sp)
    80000aa8:	7402                	ld	s0,32(sp)
    80000aaa:	64e2                	ld	s1,24(sp)
    80000aac:	6942                	ld	s2,16(sp)
    80000aae:	69a2                	ld	s3,8(sp)
    80000ab0:	6a02                	ld	s4,0(sp)
    80000ab2:	6145                	addi	sp,sp,48
    80000ab4:	8082                	ret

0000000080000ab6 <kinit>:
{
    80000ab6:	1141                	addi	sp,sp,-16
    80000ab8:	e406                	sd	ra,8(sp)
    80000aba:	e022                	sd	s0,0(sp)
    80000abc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000abe:	00008597          	auipc	a1,0x8
    80000ac2:	5aa58593          	addi	a1,a1,1450 # 80009068 <digits+0x28>
    80000ac6:	00011517          	auipc	a0,0x11
    80000aca:	7fa50513          	addi	a0,a0,2042 # 800122c0 <kmem>
    80000ace:	00000097          	auipc	ra,0x0
    80000ad2:	084080e7          	jalr	132(ra) # 80000b52 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ad6:	45c5                	li	a1,17
    80000ad8:	05ee                	slli	a1,a1,0x1b
    80000ada:	00028517          	auipc	a0,0x28
    80000ade:	52650513          	addi	a0,a0,1318 # 80029000 <end>
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	f8a080e7          	jalr	-118(ra) # 80000a6c <freerange>
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret

0000000080000af2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000af2:	1101                	addi	sp,sp,-32
    80000af4:	ec06                	sd	ra,24(sp)
    80000af6:	e822                	sd	s0,16(sp)
    80000af8:	e426                	sd	s1,8(sp)
    80000afa:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000afc:	00011497          	auipc	s1,0x11
    80000b00:	7c448493          	addi	s1,s1,1988 # 800122c0 <kmem>
    80000b04:	8526                	mv	a0,s1
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	0dc080e7          	jalr	220(ra) # 80000be2 <acquire>
  r = kmem.freelist;
    80000b0e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b10:	c885                	beqz	s1,80000b40 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b12:	609c                	ld	a5,0(s1)
    80000b14:	00011517          	auipc	a0,0x11
    80000b18:	7ac50513          	addi	a0,a0,1964 # 800122c0 <kmem>
    80000b1c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	178080e7          	jalr	376(ra) # 80000c96 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b26:	6605                	lui	a2,0x1
    80000b28:	4595                	li	a1,5
    80000b2a:	8526                	mv	a0,s1
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	1b2080e7          	jalr	434(ra) # 80000cde <memset>
  return (void*)r;
}
    80000b34:	8526                	mv	a0,s1
    80000b36:	60e2                	ld	ra,24(sp)
    80000b38:	6442                	ld	s0,16(sp)
    80000b3a:	64a2                	ld	s1,8(sp)
    80000b3c:	6105                	addi	sp,sp,32
    80000b3e:	8082                	ret
  release(&kmem.lock);
    80000b40:	00011517          	auipc	a0,0x11
    80000b44:	78050513          	addi	a0,a0,1920 # 800122c0 <kmem>
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	14e080e7          	jalr	334(ra) # 80000c96 <release>
  if(r)
    80000b50:	b7d5                	j	80000b34 <kalloc+0x42>

0000000080000b52 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b52:	1141                	addi	sp,sp,-16
    80000b54:	e422                	sd	s0,8(sp)
    80000b56:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b58:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b5a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b5e:	00053823          	sd	zero,16(a0)
}
    80000b62:	6422                	ld	s0,8(sp)
    80000b64:	0141                	addi	sp,sp,16
    80000b66:	8082                	ret

0000000080000b68 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b68:	411c                	lw	a5,0(a0)
    80000b6a:	e399                	bnez	a5,80000b70 <holding+0x8>
    80000b6c:	4501                	li	a0,0
  return r;
}
    80000b6e:	8082                	ret
{
    80000b70:	1101                	addi	sp,sp,-32
    80000b72:	ec06                	sd	ra,24(sp)
    80000b74:	e822                	sd	s0,16(sp)
    80000b76:	e426                	sd	s1,8(sp)
    80000b78:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b7a:	6904                	ld	s1,16(a0)
    80000b7c:	00001097          	auipc	ra,0x1
    80000b80:	e20080e7          	jalr	-480(ra) # 8000199c <mycpu>
    80000b84:	40a48533          	sub	a0,s1,a0
    80000b88:	00153513          	seqz	a0,a0
}
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret

0000000080000b96 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b96:	1101                	addi	sp,sp,-32
    80000b98:	ec06                	sd	ra,24(sp)
    80000b9a:	e822                	sd	s0,16(sp)
    80000b9c:	e426                	sd	s1,8(sp)
    80000b9e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ba0:	100024f3          	csrr	s1,sstatus
    80000ba4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ba8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000baa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	dee080e7          	jalr	-530(ra) # 8000199c <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	cf89                	beqz	a5,80000bd2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bba:	00001097          	auipc	ra,0x1
    80000bbe:	de2080e7          	jalr	-542(ra) # 8000199c <mycpu>
    80000bc2:	5d3c                	lw	a5,120(a0)
    80000bc4:	2785                	addiw	a5,a5,1
    80000bc6:	dd3c                	sw	a5,120(a0)
}
    80000bc8:	60e2                	ld	ra,24(sp)
    80000bca:	6442                	ld	s0,16(sp)
    80000bcc:	64a2                	ld	s1,8(sp)
    80000bce:	6105                	addi	sp,sp,32
    80000bd0:	8082                	ret
    mycpu()->intena = old;
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	dca080e7          	jalr	-566(ra) # 8000199c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bda:	8085                	srli	s1,s1,0x1
    80000bdc:	8885                	andi	s1,s1,1
    80000bde:	dd64                	sw	s1,124(a0)
    80000be0:	bfe9                	j	80000bba <push_off+0x24>

0000000080000be2 <acquire>:
{
    80000be2:	1101                	addi	sp,sp,-32
    80000be4:	ec06                	sd	ra,24(sp)
    80000be6:	e822                	sd	s0,16(sp)
    80000be8:	e426                	sd	s1,8(sp)
    80000bea:	1000                	addi	s0,sp,32
    80000bec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	fa8080e7          	jalr	-88(ra) # 80000b96 <push_off>
  if(holding(lk))
    80000bf6:	8526                	mv	a0,s1
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	f70080e7          	jalr	-144(ra) # 80000b68 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c00:	4705                	li	a4,1
  if(holding(lk))
    80000c02:	e115                	bnez	a0,80000c26 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c04:	87ba                	mv	a5,a4
    80000c06:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c0a:	2781                	sext.w	a5,a5
    80000c0c:	ffe5                	bnez	a5,80000c04 <acquire+0x22>
  __sync_synchronize();
    80000c0e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c12:	00001097          	auipc	ra,0x1
    80000c16:	d8a080e7          	jalr	-630(ra) # 8000199c <mycpu>
    80000c1a:	e888                	sd	a0,16(s1)
}
    80000c1c:	60e2                	ld	ra,24(sp)
    80000c1e:	6442                	ld	s0,16(sp)
    80000c20:	64a2                	ld	s1,8(sp)
    80000c22:	6105                	addi	sp,sp,32
    80000c24:	8082                	ret
    panic("acquire");
    80000c26:	00008517          	auipc	a0,0x8
    80000c2a:	44a50513          	addi	a0,a0,1098 # 80009070 <digits+0x30>
    80000c2e:	00000097          	auipc	ra,0x0
    80000c32:	90e080e7          	jalr	-1778(ra) # 8000053c <panic>

0000000080000c36 <pop_off>:

void
pop_off(void)
{
    80000c36:	1141                	addi	sp,sp,-16
    80000c38:	e406                	sd	ra,8(sp)
    80000c3a:	e022                	sd	s0,0(sp)
    80000c3c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c3e:	00001097          	auipc	ra,0x1
    80000c42:	d5e080e7          	jalr	-674(ra) # 8000199c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c4a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4c:	e78d                	bnez	a5,80000c76 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4e:	5d3c                	lw	a5,120(a0)
    80000c50:	02f05b63          	blez	a5,80000c86 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c54:	37fd                	addiw	a5,a5,-1
    80000c56:	0007871b          	sext.w	a4,a5
    80000c5a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5c:	eb09                	bnez	a4,80000c6e <pop_off+0x38>
    80000c5e:	5d7c                	lw	a5,124(a0)
    80000c60:	c799                	beqz	a5,80000c6e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6e:	60a2                	ld	ra,8(sp)
    80000c70:	6402                	ld	s0,0(sp)
    80000c72:	0141                	addi	sp,sp,16
    80000c74:	8082                	ret
    panic("pop_off - interruptible");
    80000c76:	00008517          	auipc	a0,0x8
    80000c7a:	40250513          	addi	a0,a0,1026 # 80009078 <digits+0x38>
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	8be080e7          	jalr	-1858(ra) # 8000053c <panic>
    panic("pop_off");
    80000c86:	00008517          	auipc	a0,0x8
    80000c8a:	40a50513          	addi	a0,a0,1034 # 80009090 <digits+0x50>
    80000c8e:	00000097          	auipc	ra,0x0
    80000c92:	8ae080e7          	jalr	-1874(ra) # 8000053c <panic>

0000000080000c96 <release>:
{
    80000c96:	1101                	addi	sp,sp,-32
    80000c98:	ec06                	sd	ra,24(sp)
    80000c9a:	e822                	sd	s0,16(sp)
    80000c9c:	e426                	sd	s1,8(sp)
    80000c9e:	1000                	addi	s0,sp,32
    80000ca0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ca2:	00000097          	auipc	ra,0x0
    80000ca6:	ec6080e7          	jalr	-314(ra) # 80000b68 <holding>
    80000caa:	c115                	beqz	a0,80000cce <release+0x38>
  lk->cpu = 0;
    80000cac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cb4:	0f50000f          	fence	iorw,ow
    80000cb8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	f7a080e7          	jalr	-134(ra) # 80000c36 <pop_off>
}
    80000cc4:	60e2                	ld	ra,24(sp)
    80000cc6:	6442                	ld	s0,16(sp)
    80000cc8:	64a2                	ld	s1,8(sp)
    80000cca:	6105                	addi	sp,sp,32
    80000ccc:	8082                	ret
    panic("release");
    80000cce:	00008517          	auipc	a0,0x8
    80000cd2:	3ca50513          	addi	a0,a0,970 # 80009098 <digits+0x58>
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	866080e7          	jalr	-1946(ra) # 8000053c <panic>

0000000080000cde <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cde:	1141                	addi	sp,sp,-16
    80000ce0:	e422                	sd	s0,8(sp)
    80000ce2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ce4:	ce09                	beqz	a2,80000cfe <memset+0x20>
    80000ce6:	87aa                	mv	a5,a0
    80000ce8:	fff6071b          	addiw	a4,a2,-1
    80000cec:	1702                	slli	a4,a4,0x20
    80000cee:	9301                	srli	a4,a4,0x20
    80000cf0:	0705                	addi	a4,a4,1
    80000cf2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000cf4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cf8:	0785                	addi	a5,a5,1
    80000cfa:	fee79de3          	bne	a5,a4,80000cf4 <memset+0x16>
  }
  return dst;
}
    80000cfe:	6422                	ld	s0,8(sp)
    80000d00:	0141                	addi	sp,sp,16
    80000d02:	8082                	ret

0000000080000d04 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d04:	1141                	addi	sp,sp,-16
    80000d06:	e422                	sd	s0,8(sp)
    80000d08:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d0a:	ca05                	beqz	a2,80000d3a <memcmp+0x36>
    80000d0c:	fff6069b          	addiw	a3,a2,-1
    80000d10:	1682                	slli	a3,a3,0x20
    80000d12:	9281                	srli	a3,a3,0x20
    80000d14:	0685                	addi	a3,a3,1
    80000d16:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d18:	00054783          	lbu	a5,0(a0)
    80000d1c:	0005c703          	lbu	a4,0(a1)
    80000d20:	00e79863          	bne	a5,a4,80000d30 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d24:	0505                	addi	a0,a0,1
    80000d26:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d28:	fed518e3          	bne	a0,a3,80000d18 <memcmp+0x14>
  }

  return 0;
    80000d2c:	4501                	li	a0,0
    80000d2e:	a019                	j	80000d34 <memcmp+0x30>
      return *s1 - *s2;
    80000d30:	40e7853b          	subw	a0,a5,a4
}
    80000d34:	6422                	ld	s0,8(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret
  return 0;
    80000d3a:	4501                	li	a0,0
    80000d3c:	bfe5                	j	80000d34 <memcmp+0x30>

0000000080000d3e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d3e:	1141                	addi	sp,sp,-16
    80000d40:	e422                	sd	s0,8(sp)
    80000d42:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d44:	ca0d                	beqz	a2,80000d76 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d46:	00a5f963          	bgeu	a1,a0,80000d58 <memmove+0x1a>
    80000d4a:	02061693          	slli	a3,a2,0x20
    80000d4e:	9281                	srli	a3,a3,0x20
    80000d50:	00d58733          	add	a4,a1,a3
    80000d54:	02e56463          	bltu	a0,a4,80000d7c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d58:	fff6079b          	addiw	a5,a2,-1
    80000d5c:	1782                	slli	a5,a5,0x20
    80000d5e:	9381                	srli	a5,a5,0x20
    80000d60:	0785                	addi	a5,a5,1
    80000d62:	97ae                	add	a5,a5,a1
    80000d64:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d66:	0585                	addi	a1,a1,1
    80000d68:	0705                	addi	a4,a4,1
    80000d6a:	fff5c683          	lbu	a3,-1(a1)
    80000d6e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d72:	fef59ae3          	bne	a1,a5,80000d66 <memmove+0x28>

  return dst;
}
    80000d76:	6422                	ld	s0,8(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret
    d += n;
    80000d7c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d7e:	fff6079b          	addiw	a5,a2,-1
    80000d82:	1782                	slli	a5,a5,0x20
    80000d84:	9381                	srli	a5,a5,0x20
    80000d86:	fff7c793          	not	a5,a5
    80000d8a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d8c:	177d                	addi	a4,a4,-1
    80000d8e:	16fd                	addi	a3,a3,-1
    80000d90:	00074603          	lbu	a2,0(a4)
    80000d94:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d98:	fef71ae3          	bne	a4,a5,80000d8c <memmove+0x4e>
    80000d9c:	bfe9                	j	80000d76 <memmove+0x38>

0000000080000d9e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000da6:	00000097          	auipc	ra,0x0
    80000daa:	f98080e7          	jalr	-104(ra) # 80000d3e <memmove>
}
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret

0000000080000db6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e422                	sd	s0,8(sp)
    80000dba:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dbc:	ce11                	beqz	a2,80000dd8 <strncmp+0x22>
    80000dbe:	00054783          	lbu	a5,0(a0)
    80000dc2:	cf89                	beqz	a5,80000ddc <strncmp+0x26>
    80000dc4:	0005c703          	lbu	a4,0(a1)
    80000dc8:	00f71a63          	bne	a4,a5,80000ddc <strncmp+0x26>
    n--, p++, q++;
    80000dcc:	367d                	addiw	a2,a2,-1
    80000dce:	0505                	addi	a0,a0,1
    80000dd0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dd2:	f675                	bnez	a2,80000dbe <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dd4:	4501                	li	a0,0
    80000dd6:	a809                	j	80000de8 <strncmp+0x32>
    80000dd8:	4501                	li	a0,0
    80000dda:	a039                	j	80000de8 <strncmp+0x32>
  if(n == 0)
    80000ddc:	ca09                	beqz	a2,80000dee <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dde:	00054503          	lbu	a0,0(a0)
    80000de2:	0005c783          	lbu	a5,0(a1)
    80000de6:	9d1d                	subw	a0,a0,a5
}
    80000de8:	6422                	ld	s0,8(sp)
    80000dea:	0141                	addi	sp,sp,16
    80000dec:	8082                	ret
    return 0;
    80000dee:	4501                	li	a0,0
    80000df0:	bfe5                	j	80000de8 <strncmp+0x32>

0000000080000df2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000df2:	1141                	addi	sp,sp,-16
    80000df4:	e422                	sd	s0,8(sp)
    80000df6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000df8:	872a                	mv	a4,a0
    80000dfa:	8832                	mv	a6,a2
    80000dfc:	367d                	addiw	a2,a2,-1
    80000dfe:	01005963          	blez	a6,80000e10 <strncpy+0x1e>
    80000e02:	0705                	addi	a4,a4,1
    80000e04:	0005c783          	lbu	a5,0(a1)
    80000e08:	fef70fa3          	sb	a5,-1(a4)
    80000e0c:	0585                	addi	a1,a1,1
    80000e0e:	f7f5                	bnez	a5,80000dfa <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e10:	00c05d63          	blez	a2,80000e2a <strncpy+0x38>
    80000e14:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e16:	0685                	addi	a3,a3,1
    80000e18:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e1c:	fff6c793          	not	a5,a3
    80000e20:	9fb9                	addw	a5,a5,a4
    80000e22:	010787bb          	addw	a5,a5,a6
    80000e26:	fef048e3          	bgtz	a5,80000e16 <strncpy+0x24>
  return os;
}
    80000e2a:	6422                	ld	s0,8(sp)
    80000e2c:	0141                	addi	sp,sp,16
    80000e2e:	8082                	ret

0000000080000e30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e30:	1141                	addi	sp,sp,-16
    80000e32:	e422                	sd	s0,8(sp)
    80000e34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e36:	02c05363          	blez	a2,80000e5c <safestrcpy+0x2c>
    80000e3a:	fff6069b          	addiw	a3,a2,-1
    80000e3e:	1682                	slli	a3,a3,0x20
    80000e40:	9281                	srli	a3,a3,0x20
    80000e42:	96ae                	add	a3,a3,a1
    80000e44:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e46:	00d58963          	beq	a1,a3,80000e58 <safestrcpy+0x28>
    80000e4a:	0585                	addi	a1,a1,1
    80000e4c:	0785                	addi	a5,a5,1
    80000e4e:	fff5c703          	lbu	a4,-1(a1)
    80000e52:	fee78fa3          	sb	a4,-1(a5)
    80000e56:	fb65                	bnez	a4,80000e46 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e58:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <strlen>:

int
strlen(const char *s)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e68:	00054783          	lbu	a5,0(a0)
    80000e6c:	cf91                	beqz	a5,80000e88 <strlen+0x26>
    80000e6e:	0505                	addi	a0,a0,1
    80000e70:	87aa                	mv	a5,a0
    80000e72:	4685                	li	a3,1
    80000e74:	9e89                	subw	a3,a3,a0
    80000e76:	00f6853b          	addw	a0,a3,a5
    80000e7a:	0785                	addi	a5,a5,1
    80000e7c:	fff7c703          	lbu	a4,-1(a5)
    80000e80:	fb7d                	bnez	a4,80000e76 <strlen+0x14>
    ;
  return n;
}
    80000e82:	6422                	ld	s0,8(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e88:	4501                	li	a0,0
    80000e8a:	bfe5                	j	80000e82 <strlen+0x20>

0000000080000e8c <main>:
extern int sched_policy;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e94:	00001097          	auipc	ra,0x1
    80000e98:	af8080e7          	jalr	-1288(ra) # 8000198c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e9c:	00009717          	auipc	a4,0x9
    80000ea0:	17c70713          	addi	a4,a4,380 # 8000a018 <started>
  if(cpuid() == 0){
    80000ea4:	c921                	beqz	a0,80000ef4 <main+0x68>
    while(started == 0)
    80000ea6:	431c                	lw	a5,0(a4)
    80000ea8:	2781                	sext.w	a5,a5
    80000eaa:	dff5                	beqz	a5,80000ea6 <main+0x1a>
      ;
    __sync_synchronize();
    80000eac:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000eb0:	00001097          	auipc	ra,0x1
    80000eb4:	adc080e7          	jalr	-1316(ra) # 8000198c <cpuid>
    80000eb8:	85aa                	mv	a1,a0
    80000eba:	00008517          	auipc	a0,0x8
    80000ebe:	1fe50513          	addi	a0,a0,510 # 800090b8 <digits+0x78>
    80000ec2:	fffff097          	auipc	ra,0xfffff
    80000ec6:	6c4080e7          	jalr	1732(ra) # 80000586 <printf>
    kvminithart();    // turn on paging
    80000eca:	00000097          	auipc	ra,0x0
    80000ece:	0e2080e7          	jalr	226(ra) # 80000fac <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ed2:	00003097          	auipc	ra,0x3
    80000ed6:	0e2080e7          	jalr	226(ra) # 80003fb4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eda:	00007097          	auipc	ra,0x7
    80000ede:	a26080e7          	jalr	-1498(ra) # 80007900 <plicinithart>
  }

  sched_policy = SCHED_PREEMPT_RR;
    80000ee2:	4789                	li	a5,2
    80000ee4:	00009717          	auipc	a4,0x9
    80000ee8:	18f72a23          	sw	a5,404(a4) # 8000a078 <sched_policy>

  scheduler();        
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	30c080e7          	jalr	780(ra) # 800021f8 <scheduler>
    consoleinit();
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	55a080e7          	jalr	1370(ra) # 8000044e <consoleinit>
    printfinit();
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	870080e7          	jalr	-1936(ra) # 8000076c <printfinit>
    printf("\n");
    80000f04:	00009517          	auipc	a0,0x9
    80000f08:	9b450513          	addi	a0,a0,-1612 # 800098b8 <syscalls+0x158>
    80000f0c:	fffff097          	auipc	ra,0xfffff
    80000f10:	67a080e7          	jalr	1658(ra) # 80000586 <printf>
    printf("xv6 kernel is booting\n");
    80000f14:	00008517          	auipc	a0,0x8
    80000f18:	18c50513          	addi	a0,a0,396 # 800090a0 <digits+0x60>
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	66a080e7          	jalr	1642(ra) # 80000586 <printf>
    printf("\n");
    80000f24:	00009517          	auipc	a0,0x9
    80000f28:	99450513          	addi	a0,a0,-1644 # 800098b8 <syscalls+0x158>
    80000f2c:	fffff097          	auipc	ra,0xfffff
    80000f30:	65a080e7          	jalr	1626(ra) # 80000586 <printf>
    kinit();         // physical page allocator
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	b82080e7          	jalr	-1150(ra) # 80000ab6 <kinit>
    kvminit();       // create kernel page table
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	322080e7          	jalr	802(ra) # 8000125e <kvminit>
    kvminithart();   // turn on paging
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	068080e7          	jalr	104(ra) # 80000fac <kvminithart>
    procinit();      // process table
    80000f4c:	00001097          	auipc	ra,0x1
    80000f50:	990080e7          	jalr	-1648(ra) # 800018dc <procinit>
    trapinit();      // trap vectors
    80000f54:	00003097          	auipc	ra,0x3
    80000f58:	038080e7          	jalr	56(ra) # 80003f8c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f5c:	00003097          	auipc	ra,0x3
    80000f60:	058080e7          	jalr	88(ra) # 80003fb4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f64:	00007097          	auipc	ra,0x7
    80000f68:	986080e7          	jalr	-1658(ra) # 800078ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f6c:	00007097          	auipc	ra,0x7
    80000f70:	994080e7          	jalr	-1644(ra) # 80007900 <plicinithart>
    binit();         // buffer cache
    80000f74:	00004097          	auipc	ra,0x4
    80000f78:	b7a080e7          	jalr	-1158(ra) # 80004aee <binit>
    iinit();         // inode table
    80000f7c:	00004097          	auipc	ra,0x4
    80000f80:	20a080e7          	jalr	522(ra) # 80005186 <iinit>
    fileinit();      // file table
    80000f84:	00005097          	auipc	ra,0x5
    80000f88:	1b4080e7          	jalr	436(ra) # 80006138 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f8c:	00007097          	auipc	ra,0x7
    80000f90:	a96080e7          	jalr	-1386(ra) # 80007a22 <virtio_disk_init>
    userinit();      // first user process
    80000f94:	00001097          	auipc	ra,0x1
    80000f98:	d72080e7          	jalr	-654(ra) # 80001d06 <userinit>
    __sync_synchronize();
    80000f9c:	0ff0000f          	fence
    started = 1;
    80000fa0:	4785                	li	a5,1
    80000fa2:	00009717          	auipc	a4,0x9
    80000fa6:	06f72b23          	sw	a5,118(a4) # 8000a018 <started>
    80000faa:	bf25                	j	80000ee2 <main+0x56>

0000000080000fac <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e422                	sd	s0,8(sp)
    80000fb0:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fb2:	00009797          	auipc	a5,0x9
    80000fb6:	06e7b783          	ld	a5,110(a5) # 8000a020 <kernel_pagetable>
    80000fba:	83b1                	srli	a5,a5,0xc
    80000fbc:	577d                	li	a4,-1
    80000fbe:	177e                	slli	a4,a4,0x3f
    80000fc0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fc2:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fc6:	12000073          	sfence.vma
  sfence_vma();
}
    80000fca:	6422                	ld	s0,8(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret

0000000080000fd0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fd0:	7139                	addi	sp,sp,-64
    80000fd2:	fc06                	sd	ra,56(sp)
    80000fd4:	f822                	sd	s0,48(sp)
    80000fd6:	f426                	sd	s1,40(sp)
    80000fd8:	f04a                	sd	s2,32(sp)
    80000fda:	ec4e                	sd	s3,24(sp)
    80000fdc:	e852                	sd	s4,16(sp)
    80000fde:	e456                	sd	s5,8(sp)
    80000fe0:	e05a                	sd	s6,0(sp)
    80000fe2:	0080                	addi	s0,sp,64
    80000fe4:	84aa                	mv	s1,a0
    80000fe6:	89ae                	mv	s3,a1
    80000fe8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fea:	57fd                	li	a5,-1
    80000fec:	83e9                	srli	a5,a5,0x1a
    80000fee:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ff0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ff2:	04b7f263          	bgeu	a5,a1,80001036 <walk+0x66>
    panic("walk");
    80000ff6:	00008517          	auipc	a0,0x8
    80000ffa:	0da50513          	addi	a0,a0,218 # 800090d0 <digits+0x90>
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	53e080e7          	jalr	1342(ra) # 8000053c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001006:	060a8663          	beqz	s5,80001072 <walk+0xa2>
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	ae8080e7          	jalr	-1304(ra) # 80000af2 <kalloc>
    80001012:	84aa                	mv	s1,a0
    80001014:	c529                	beqz	a0,8000105e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001016:	6605                	lui	a2,0x1
    80001018:	4581                	li	a1,0
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	cc4080e7          	jalr	-828(ra) # 80000cde <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001022:	00c4d793          	srli	a5,s1,0xc
    80001026:	07aa                	slli	a5,a5,0xa
    80001028:	0017e793          	ori	a5,a5,1
    8000102c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001030:	3a5d                	addiw	s4,s4,-9
    80001032:	036a0063          	beq	s4,s6,80001052 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001036:	0149d933          	srl	s2,s3,s4
    8000103a:	1ff97913          	andi	s2,s2,511
    8000103e:	090e                	slli	s2,s2,0x3
    80001040:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001042:	00093483          	ld	s1,0(s2)
    80001046:	0014f793          	andi	a5,s1,1
    8000104a:	dfd5                	beqz	a5,80001006 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000104c:	80a9                	srli	s1,s1,0xa
    8000104e:	04b2                	slli	s1,s1,0xc
    80001050:	b7c5                	j	80001030 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001052:	00c9d513          	srli	a0,s3,0xc
    80001056:	1ff57513          	andi	a0,a0,511
    8000105a:	050e                	slli	a0,a0,0x3
    8000105c:	9526                	add	a0,a0,s1
}
    8000105e:	70e2                	ld	ra,56(sp)
    80001060:	7442                	ld	s0,48(sp)
    80001062:	74a2                	ld	s1,40(sp)
    80001064:	7902                	ld	s2,32(sp)
    80001066:	69e2                	ld	s3,24(sp)
    80001068:	6a42                	ld	s4,16(sp)
    8000106a:	6aa2                	ld	s5,8(sp)
    8000106c:	6b02                	ld	s6,0(sp)
    8000106e:	6121                	addi	sp,sp,64
    80001070:	8082                	ret
        return 0;
    80001072:	4501                	li	a0,0
    80001074:	b7ed                	j	8000105e <walk+0x8e>

0000000080001076 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001076:	57fd                	li	a5,-1
    80001078:	83e9                	srli	a5,a5,0x1a
    8000107a:	00b7f463          	bgeu	a5,a1,80001082 <walkaddr+0xc>
    return 0;
    8000107e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001080:	8082                	ret
{
    80001082:	1141                	addi	sp,sp,-16
    80001084:	e406                	sd	ra,8(sp)
    80001086:	e022                	sd	s0,0(sp)
    80001088:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000108a:	4601                	li	a2,0
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	f44080e7          	jalr	-188(ra) # 80000fd0 <walk>
  if(pte == 0)
    80001094:	c105                	beqz	a0,800010b4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001096:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001098:	0117f693          	andi	a3,a5,17
    8000109c:	4745                	li	a4,17
    return 0;
    8000109e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010a0:	00e68663          	beq	a3,a4,800010ac <walkaddr+0x36>
}
    800010a4:	60a2                	ld	ra,8(sp)
    800010a6:	6402                	ld	s0,0(sp)
    800010a8:	0141                	addi	sp,sp,16
    800010aa:	8082                	ret
  pa = PTE2PA(*pte);
    800010ac:	00a7d513          	srli	a0,a5,0xa
    800010b0:	0532                	slli	a0,a0,0xc
  return pa;
    800010b2:	bfcd                	j	800010a4 <walkaddr+0x2e>
    return 0;
    800010b4:	4501                	li	a0,0
    800010b6:	b7fd                	j	800010a4 <walkaddr+0x2e>

00000000800010b8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010b8:	715d                	addi	sp,sp,-80
    800010ba:	e486                	sd	ra,72(sp)
    800010bc:	e0a2                	sd	s0,64(sp)
    800010be:	fc26                	sd	s1,56(sp)
    800010c0:	f84a                	sd	s2,48(sp)
    800010c2:	f44e                	sd	s3,40(sp)
    800010c4:	f052                	sd	s4,32(sp)
    800010c6:	ec56                	sd	s5,24(sp)
    800010c8:	e85a                	sd	s6,16(sp)
    800010ca:	e45e                	sd	s7,8(sp)
    800010cc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010ce:	c205                	beqz	a2,800010ee <mappages+0x36>
    800010d0:	8aaa                	mv	s5,a0
    800010d2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010d4:	77fd                	lui	a5,0xfffff
    800010d6:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800010da:	15fd                	addi	a1,a1,-1
    800010dc:	00c589b3          	add	s3,a1,a2
    800010e0:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800010e4:	8952                	mv	s2,s4
    800010e6:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ea:	6b85                	lui	s7,0x1
    800010ec:	a015                	j	80001110 <mappages+0x58>
    panic("mappages: size");
    800010ee:	00008517          	auipc	a0,0x8
    800010f2:	fea50513          	addi	a0,a0,-22 # 800090d8 <digits+0x98>
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	446080e7          	jalr	1094(ra) # 8000053c <panic>
      panic("mappages: remap");
    800010fe:	00008517          	auipc	a0,0x8
    80001102:	fea50513          	addi	a0,a0,-22 # 800090e8 <digits+0xa8>
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	436080e7          	jalr	1078(ra) # 8000053c <panic>
    a += PGSIZE;
    8000110e:	995e                	add	s2,s2,s7
  for(;;){
    80001110:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001114:	4605                	li	a2,1
    80001116:	85ca                	mv	a1,s2
    80001118:	8556                	mv	a0,s5
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	eb6080e7          	jalr	-330(ra) # 80000fd0 <walk>
    80001122:	cd19                	beqz	a0,80001140 <mappages+0x88>
    if(*pte & PTE_V)
    80001124:	611c                	ld	a5,0(a0)
    80001126:	8b85                	andi	a5,a5,1
    80001128:	fbf9                	bnez	a5,800010fe <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000112a:	80b1                	srli	s1,s1,0xc
    8000112c:	04aa                	slli	s1,s1,0xa
    8000112e:	0164e4b3          	or	s1,s1,s6
    80001132:	0014e493          	ori	s1,s1,1
    80001136:	e104                	sd	s1,0(a0)
    if(a == last)
    80001138:	fd391be3          	bne	s2,s3,8000110e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000113c:	4501                	li	a0,0
    8000113e:	a011                	j	80001142 <mappages+0x8a>
      return -1;
    80001140:	557d                	li	a0,-1
}
    80001142:	60a6                	ld	ra,72(sp)
    80001144:	6406                	ld	s0,64(sp)
    80001146:	74e2                	ld	s1,56(sp)
    80001148:	7942                	ld	s2,48(sp)
    8000114a:	79a2                	ld	s3,40(sp)
    8000114c:	7a02                	ld	s4,32(sp)
    8000114e:	6ae2                	ld	s5,24(sp)
    80001150:	6b42                	ld	s6,16(sp)
    80001152:	6ba2                	ld	s7,8(sp)
    80001154:	6161                	addi	sp,sp,80
    80001156:	8082                	ret

0000000080001158 <kvmmap>:
{
    80001158:	1141                	addi	sp,sp,-16
    8000115a:	e406                	sd	ra,8(sp)
    8000115c:	e022                	sd	s0,0(sp)
    8000115e:	0800                	addi	s0,sp,16
    80001160:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001162:	86b2                	mv	a3,a2
    80001164:	863e                	mv	a2,a5
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	f52080e7          	jalr	-174(ra) # 800010b8 <mappages>
    8000116e:	e509                	bnez	a0,80001178 <kvmmap+0x20>
}
    80001170:	60a2                	ld	ra,8(sp)
    80001172:	6402                	ld	s0,0(sp)
    80001174:	0141                	addi	sp,sp,16
    80001176:	8082                	ret
    panic("kvmmap");
    80001178:	00008517          	auipc	a0,0x8
    8000117c:	f8050513          	addi	a0,a0,-128 # 800090f8 <digits+0xb8>
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	3bc080e7          	jalr	956(ra) # 8000053c <panic>

0000000080001188 <kvmmake>:
{
    80001188:	1101                	addi	sp,sp,-32
    8000118a:	ec06                	sd	ra,24(sp)
    8000118c:	e822                	sd	s0,16(sp)
    8000118e:	e426                	sd	s1,8(sp)
    80001190:	e04a                	sd	s2,0(sp)
    80001192:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001194:	00000097          	auipc	ra,0x0
    80001198:	95e080e7          	jalr	-1698(ra) # 80000af2 <kalloc>
    8000119c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000119e:	6605                	lui	a2,0x1
    800011a0:	4581                	li	a1,0
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	b3c080e7          	jalr	-1220(ra) # 80000cde <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011aa:	4719                	li	a4,6
    800011ac:	6685                	lui	a3,0x1
    800011ae:	10000637          	lui	a2,0x10000
    800011b2:	100005b7          	lui	a1,0x10000
    800011b6:	8526                	mv	a0,s1
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	fa0080e7          	jalr	-96(ra) # 80001158 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011c0:	4719                	li	a4,6
    800011c2:	6685                	lui	a3,0x1
    800011c4:	10001637          	lui	a2,0x10001
    800011c8:	100015b7          	lui	a1,0x10001
    800011cc:	8526                	mv	a0,s1
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f8a080e7          	jalr	-118(ra) # 80001158 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011d6:	4719                	li	a4,6
    800011d8:	004006b7          	lui	a3,0x400
    800011dc:	0c000637          	lui	a2,0xc000
    800011e0:	0c0005b7          	lui	a1,0xc000
    800011e4:	8526                	mv	a0,s1
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	f72080e7          	jalr	-142(ra) # 80001158 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011ee:	00008917          	auipc	s2,0x8
    800011f2:	e1290913          	addi	s2,s2,-494 # 80009000 <etext>
    800011f6:	4729                	li	a4,10
    800011f8:	80008697          	auipc	a3,0x80008
    800011fc:	e0868693          	addi	a3,a3,-504 # 9000 <_entry-0x7fff7000>
    80001200:	4605                	li	a2,1
    80001202:	067e                	slli	a2,a2,0x1f
    80001204:	85b2                	mv	a1,a2
    80001206:	8526                	mv	a0,s1
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	f50080e7          	jalr	-176(ra) # 80001158 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001210:	4719                	li	a4,6
    80001212:	46c5                	li	a3,17
    80001214:	06ee                	slli	a3,a3,0x1b
    80001216:	412686b3          	sub	a3,a3,s2
    8000121a:	864a                	mv	a2,s2
    8000121c:	85ca                	mv	a1,s2
    8000121e:	8526                	mv	a0,s1
    80001220:	00000097          	auipc	ra,0x0
    80001224:	f38080e7          	jalr	-200(ra) # 80001158 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001228:	4729                	li	a4,10
    8000122a:	6685                	lui	a3,0x1
    8000122c:	00007617          	auipc	a2,0x7
    80001230:	dd460613          	addi	a2,a2,-556 # 80008000 <_trampoline>
    80001234:	040005b7          	lui	a1,0x4000
    80001238:	15fd                	addi	a1,a1,-1
    8000123a:	05b2                	slli	a1,a1,0xc
    8000123c:	8526                	mv	a0,s1
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f1a080e7          	jalr	-230(ra) # 80001158 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	5fe080e7          	jalr	1534(ra) # 80001846 <proc_mapstacks>
}
    80001250:	8526                	mv	a0,s1
    80001252:	60e2                	ld	ra,24(sp)
    80001254:	6442                	ld	s0,16(sp)
    80001256:	64a2                	ld	s1,8(sp)
    80001258:	6902                	ld	s2,0(sp)
    8000125a:	6105                	addi	sp,sp,32
    8000125c:	8082                	ret

000000008000125e <kvminit>:
{
    8000125e:	1141                	addi	sp,sp,-16
    80001260:	e406                	sd	ra,8(sp)
    80001262:	e022                	sd	s0,0(sp)
    80001264:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	f22080e7          	jalr	-222(ra) # 80001188 <kvmmake>
    8000126e:	00009797          	auipc	a5,0x9
    80001272:	daa7b923          	sd	a0,-590(a5) # 8000a020 <kernel_pagetable>
}
    80001276:	60a2                	ld	ra,8(sp)
    80001278:	6402                	ld	s0,0(sp)
    8000127a:	0141                	addi	sp,sp,16
    8000127c:	8082                	ret

000000008000127e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000127e:	715d                	addi	sp,sp,-80
    80001280:	e486                	sd	ra,72(sp)
    80001282:	e0a2                	sd	s0,64(sp)
    80001284:	fc26                	sd	s1,56(sp)
    80001286:	f84a                	sd	s2,48(sp)
    80001288:	f44e                	sd	s3,40(sp)
    8000128a:	f052                	sd	s4,32(sp)
    8000128c:	ec56                	sd	s5,24(sp)
    8000128e:	e85a                	sd	s6,16(sp)
    80001290:	e45e                	sd	s7,8(sp)
    80001292:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001294:	03459793          	slli	a5,a1,0x34
    80001298:	e795                	bnez	a5,800012c4 <uvmunmap+0x46>
    8000129a:	8a2a                	mv	s4,a0
    8000129c:	892e                	mv	s2,a1
    8000129e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a0:	0632                	slli	a2,a2,0xc
    800012a2:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012a6:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a8:	6b05                	lui	s6,0x1
    800012aa:	0735e863          	bltu	a1,s3,8000131a <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012ae:	60a6                	ld	ra,72(sp)
    800012b0:	6406                	ld	s0,64(sp)
    800012b2:	74e2                	ld	s1,56(sp)
    800012b4:	7942                	ld	s2,48(sp)
    800012b6:	79a2                	ld	s3,40(sp)
    800012b8:	7a02                	ld	s4,32(sp)
    800012ba:	6ae2                	ld	s5,24(sp)
    800012bc:	6b42                	ld	s6,16(sp)
    800012be:	6ba2                	ld	s7,8(sp)
    800012c0:	6161                	addi	sp,sp,80
    800012c2:	8082                	ret
    panic("uvmunmap: not aligned");
    800012c4:	00008517          	auipc	a0,0x8
    800012c8:	e3c50513          	addi	a0,a0,-452 # 80009100 <digits+0xc0>
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	270080e7          	jalr	624(ra) # 8000053c <panic>
      panic("uvmunmap: walk");
    800012d4:	00008517          	auipc	a0,0x8
    800012d8:	e4450513          	addi	a0,a0,-444 # 80009118 <digits+0xd8>
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	260080e7          	jalr	608(ra) # 8000053c <panic>
      panic("uvmunmap: not mapped");
    800012e4:	00008517          	auipc	a0,0x8
    800012e8:	e4450513          	addi	a0,a0,-444 # 80009128 <digits+0xe8>
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	250080e7          	jalr	592(ra) # 8000053c <panic>
      panic("uvmunmap: not a leaf");
    800012f4:	00008517          	auipc	a0,0x8
    800012f8:	e4c50513          	addi	a0,a0,-436 # 80009140 <digits+0x100>
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	240080e7          	jalr	576(ra) # 8000053c <panic>
      uint64 pa = PTE2PA(*pte);
    80001304:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001306:	0532                	slli	a0,a0,0xc
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	6ee080e7          	jalr	1774(ra) # 800009f6 <kfree>
    *pte = 0;
    80001310:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001314:	995a                	add	s2,s2,s6
    80001316:	f9397ce3          	bgeu	s2,s3,800012ae <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000131a:	4601                	li	a2,0
    8000131c:	85ca                	mv	a1,s2
    8000131e:	8552                	mv	a0,s4
    80001320:	00000097          	auipc	ra,0x0
    80001324:	cb0080e7          	jalr	-848(ra) # 80000fd0 <walk>
    80001328:	84aa                	mv	s1,a0
    8000132a:	d54d                	beqz	a0,800012d4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000132c:	6108                	ld	a0,0(a0)
    8000132e:	00157793          	andi	a5,a0,1
    80001332:	dbcd                	beqz	a5,800012e4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001334:	3ff57793          	andi	a5,a0,1023
    80001338:	fb778ee3          	beq	a5,s7,800012f4 <uvmunmap+0x76>
    if(do_free){
    8000133c:	fc0a8ae3          	beqz	s5,80001310 <uvmunmap+0x92>
    80001340:	b7d1                	j	80001304 <uvmunmap+0x86>

0000000080001342 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001342:	1101                	addi	sp,sp,-32
    80001344:	ec06                	sd	ra,24(sp)
    80001346:	e822                	sd	s0,16(sp)
    80001348:	e426                	sd	s1,8(sp)
    8000134a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000134c:	fffff097          	auipc	ra,0xfffff
    80001350:	7a6080e7          	jalr	1958(ra) # 80000af2 <kalloc>
    80001354:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001356:	c519                	beqz	a0,80001364 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001358:	6605                	lui	a2,0x1
    8000135a:	4581                	li	a1,0
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	982080e7          	jalr	-1662(ra) # 80000cde <memset>
  return pagetable;
}
    80001364:	8526                	mv	a0,s1
    80001366:	60e2                	ld	ra,24(sp)
    80001368:	6442                	ld	s0,16(sp)
    8000136a:	64a2                	ld	s1,8(sp)
    8000136c:	6105                	addi	sp,sp,32
    8000136e:	8082                	ret

0000000080001370 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001370:	7179                	addi	sp,sp,-48
    80001372:	f406                	sd	ra,40(sp)
    80001374:	f022                	sd	s0,32(sp)
    80001376:	ec26                	sd	s1,24(sp)
    80001378:	e84a                	sd	s2,16(sp)
    8000137a:	e44e                	sd	s3,8(sp)
    8000137c:	e052                	sd	s4,0(sp)
    8000137e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001380:	6785                	lui	a5,0x1
    80001382:	04f67863          	bgeu	a2,a5,800013d2 <uvminit+0x62>
    80001386:	8a2a                	mv	s4,a0
    80001388:	89ae                	mv	s3,a1
    8000138a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000138c:	fffff097          	auipc	ra,0xfffff
    80001390:	766080e7          	jalr	1894(ra) # 80000af2 <kalloc>
    80001394:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	944080e7          	jalr	-1724(ra) # 80000cde <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013a2:	4779                	li	a4,30
    800013a4:	86ca                	mv	a3,s2
    800013a6:	6605                	lui	a2,0x1
    800013a8:	4581                	li	a1,0
    800013aa:	8552                	mv	a0,s4
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	d0c080e7          	jalr	-756(ra) # 800010b8 <mappages>
  memmove(mem, src, sz);
    800013b4:	8626                	mv	a2,s1
    800013b6:	85ce                	mv	a1,s3
    800013b8:	854a                	mv	a0,s2
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	984080e7          	jalr	-1660(ra) # 80000d3e <memmove>
}
    800013c2:	70a2                	ld	ra,40(sp)
    800013c4:	7402                	ld	s0,32(sp)
    800013c6:	64e2                	ld	s1,24(sp)
    800013c8:	6942                	ld	s2,16(sp)
    800013ca:	69a2                	ld	s3,8(sp)
    800013cc:	6a02                	ld	s4,0(sp)
    800013ce:	6145                	addi	sp,sp,48
    800013d0:	8082                	ret
    panic("inituvm: more than a page");
    800013d2:	00008517          	auipc	a0,0x8
    800013d6:	d8650513          	addi	a0,a0,-634 # 80009158 <digits+0x118>
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	162080e7          	jalr	354(ra) # 8000053c <panic>

00000000800013e2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013e2:	1101                	addi	sp,sp,-32
    800013e4:	ec06                	sd	ra,24(sp)
    800013e6:	e822                	sd	s0,16(sp)
    800013e8:	e426                	sd	s1,8(sp)
    800013ea:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013ec:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013ee:	00b67d63          	bgeu	a2,a1,80001408 <uvmdealloc+0x26>
    800013f2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013f4:	6785                	lui	a5,0x1
    800013f6:	17fd                	addi	a5,a5,-1
    800013f8:	00f60733          	add	a4,a2,a5
    800013fc:	767d                	lui	a2,0xfffff
    800013fe:	8f71                	and	a4,a4,a2
    80001400:	97ae                	add	a5,a5,a1
    80001402:	8ff1                	and	a5,a5,a2
    80001404:	00f76863          	bltu	a4,a5,80001414 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001408:	8526                	mv	a0,s1
    8000140a:	60e2                	ld	ra,24(sp)
    8000140c:	6442                	ld	s0,16(sp)
    8000140e:	64a2                	ld	s1,8(sp)
    80001410:	6105                	addi	sp,sp,32
    80001412:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001414:	8f99                	sub	a5,a5,a4
    80001416:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001418:	4685                	li	a3,1
    8000141a:	0007861b          	sext.w	a2,a5
    8000141e:	85ba                	mv	a1,a4
    80001420:	00000097          	auipc	ra,0x0
    80001424:	e5e080e7          	jalr	-418(ra) # 8000127e <uvmunmap>
    80001428:	b7c5                	j	80001408 <uvmdealloc+0x26>

000000008000142a <uvmalloc>:
  if(newsz < oldsz)
    8000142a:	0ab66163          	bltu	a2,a1,800014cc <uvmalloc+0xa2>
{
    8000142e:	7139                	addi	sp,sp,-64
    80001430:	fc06                	sd	ra,56(sp)
    80001432:	f822                	sd	s0,48(sp)
    80001434:	f426                	sd	s1,40(sp)
    80001436:	f04a                	sd	s2,32(sp)
    80001438:	ec4e                	sd	s3,24(sp)
    8000143a:	e852                	sd	s4,16(sp)
    8000143c:	e456                	sd	s5,8(sp)
    8000143e:	0080                	addi	s0,sp,64
    80001440:	8aaa                	mv	s5,a0
    80001442:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001444:	6985                	lui	s3,0x1
    80001446:	19fd                	addi	s3,s3,-1
    80001448:	95ce                	add	a1,a1,s3
    8000144a:	79fd                	lui	s3,0xfffff
    8000144c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001450:	08c9f063          	bgeu	s3,a2,800014d0 <uvmalloc+0xa6>
    80001454:	894e                	mv	s2,s3
    mem = kalloc();
    80001456:	fffff097          	auipc	ra,0xfffff
    8000145a:	69c080e7          	jalr	1692(ra) # 80000af2 <kalloc>
    8000145e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001460:	c51d                	beqz	a0,8000148e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001462:	6605                	lui	a2,0x1
    80001464:	4581                	li	a1,0
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	878080e7          	jalr	-1928(ra) # 80000cde <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000146e:	4779                	li	a4,30
    80001470:	86a6                	mv	a3,s1
    80001472:	6605                	lui	a2,0x1
    80001474:	85ca                	mv	a1,s2
    80001476:	8556                	mv	a0,s5
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	c40080e7          	jalr	-960(ra) # 800010b8 <mappages>
    80001480:	e905                	bnez	a0,800014b0 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001482:	6785                	lui	a5,0x1
    80001484:	993e                	add	s2,s2,a5
    80001486:	fd4968e3          	bltu	s2,s4,80001456 <uvmalloc+0x2c>
  return newsz;
    8000148a:	8552                	mv	a0,s4
    8000148c:	a809                	j	8000149e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000148e:	864e                	mv	a2,s3
    80001490:	85ca                	mv	a1,s2
    80001492:	8556                	mv	a0,s5
    80001494:	00000097          	auipc	ra,0x0
    80001498:	f4e080e7          	jalr	-178(ra) # 800013e2 <uvmdealloc>
      return 0;
    8000149c:	4501                	li	a0,0
}
    8000149e:	70e2                	ld	ra,56(sp)
    800014a0:	7442                	ld	s0,48(sp)
    800014a2:	74a2                	ld	s1,40(sp)
    800014a4:	7902                	ld	s2,32(sp)
    800014a6:	69e2                	ld	s3,24(sp)
    800014a8:	6a42                	ld	s4,16(sp)
    800014aa:	6aa2                	ld	s5,8(sp)
    800014ac:	6121                	addi	sp,sp,64
    800014ae:	8082                	ret
      kfree(mem);
    800014b0:	8526                	mv	a0,s1
    800014b2:	fffff097          	auipc	ra,0xfffff
    800014b6:	544080e7          	jalr	1348(ra) # 800009f6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014ba:	864e                	mv	a2,s3
    800014bc:	85ca                	mv	a1,s2
    800014be:	8556                	mv	a0,s5
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	f22080e7          	jalr	-222(ra) # 800013e2 <uvmdealloc>
      return 0;
    800014c8:	4501                	li	a0,0
    800014ca:	bfd1                	j	8000149e <uvmalloc+0x74>
    return oldsz;
    800014cc:	852e                	mv	a0,a1
}
    800014ce:	8082                	ret
  return newsz;
    800014d0:	8532                	mv	a0,a2
    800014d2:	b7f1                	j	8000149e <uvmalloc+0x74>

00000000800014d4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014d4:	7179                	addi	sp,sp,-48
    800014d6:	f406                	sd	ra,40(sp)
    800014d8:	f022                	sd	s0,32(sp)
    800014da:	ec26                	sd	s1,24(sp)
    800014dc:	e84a                	sd	s2,16(sp)
    800014de:	e44e                	sd	s3,8(sp)
    800014e0:	e052                	sd	s4,0(sp)
    800014e2:	1800                	addi	s0,sp,48
    800014e4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014e6:	84aa                	mv	s1,a0
    800014e8:	6905                	lui	s2,0x1
    800014ea:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014ec:	4985                	li	s3,1
    800014ee:	a821                	j	80001506 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014f0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014f2:	0532                	slli	a0,a0,0xc
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	fe0080e7          	jalr	-32(ra) # 800014d4 <freewalk>
      pagetable[i] = 0;
    800014fc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001500:	04a1                	addi	s1,s1,8
    80001502:	03248163          	beq	s1,s2,80001524 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001506:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001508:	00f57793          	andi	a5,a0,15
    8000150c:	ff3782e3          	beq	a5,s3,800014f0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001510:	8905                	andi	a0,a0,1
    80001512:	d57d                	beqz	a0,80001500 <freewalk+0x2c>
      panic("freewalk: leaf");
    80001514:	00008517          	auipc	a0,0x8
    80001518:	c6450513          	addi	a0,a0,-924 # 80009178 <digits+0x138>
    8000151c:	fffff097          	auipc	ra,0xfffff
    80001520:	020080e7          	jalr	32(ra) # 8000053c <panic>
    }
  }
  kfree((void*)pagetable);
    80001524:	8552                	mv	a0,s4
    80001526:	fffff097          	auipc	ra,0xfffff
    8000152a:	4d0080e7          	jalr	1232(ra) # 800009f6 <kfree>
}
    8000152e:	70a2                	ld	ra,40(sp)
    80001530:	7402                	ld	s0,32(sp)
    80001532:	64e2                	ld	s1,24(sp)
    80001534:	6942                	ld	s2,16(sp)
    80001536:	69a2                	ld	s3,8(sp)
    80001538:	6a02                	ld	s4,0(sp)
    8000153a:	6145                	addi	sp,sp,48
    8000153c:	8082                	ret

000000008000153e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000153e:	1101                	addi	sp,sp,-32
    80001540:	ec06                	sd	ra,24(sp)
    80001542:	e822                	sd	s0,16(sp)
    80001544:	e426                	sd	s1,8(sp)
    80001546:	1000                	addi	s0,sp,32
    80001548:	84aa                	mv	s1,a0
  if(sz > 0)
    8000154a:	e999                	bnez	a1,80001560 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	f86080e7          	jalr	-122(ra) # 800014d4 <freewalk>
}
    80001556:	60e2                	ld	ra,24(sp)
    80001558:	6442                	ld	s0,16(sp)
    8000155a:	64a2                	ld	s1,8(sp)
    8000155c:	6105                	addi	sp,sp,32
    8000155e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001560:	6605                	lui	a2,0x1
    80001562:	167d                	addi	a2,a2,-1
    80001564:	962e                	add	a2,a2,a1
    80001566:	4685                	li	a3,1
    80001568:	8231                	srli	a2,a2,0xc
    8000156a:	4581                	li	a1,0
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	d12080e7          	jalr	-750(ra) # 8000127e <uvmunmap>
    80001574:	bfe1                	j	8000154c <uvmfree+0xe>

0000000080001576 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001576:	c679                	beqz	a2,80001644 <uvmcopy+0xce>
{
    80001578:	715d                	addi	sp,sp,-80
    8000157a:	e486                	sd	ra,72(sp)
    8000157c:	e0a2                	sd	s0,64(sp)
    8000157e:	fc26                	sd	s1,56(sp)
    80001580:	f84a                	sd	s2,48(sp)
    80001582:	f44e                	sd	s3,40(sp)
    80001584:	f052                	sd	s4,32(sp)
    80001586:	ec56                	sd	s5,24(sp)
    80001588:	e85a                	sd	s6,16(sp)
    8000158a:	e45e                	sd	s7,8(sp)
    8000158c:	0880                	addi	s0,sp,80
    8000158e:	8b2a                	mv	s6,a0
    80001590:	8aae                	mv	s5,a1
    80001592:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001594:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001596:	4601                	li	a2,0
    80001598:	85ce                	mv	a1,s3
    8000159a:	855a                	mv	a0,s6
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	a34080e7          	jalr	-1484(ra) # 80000fd0 <walk>
    800015a4:	c531                	beqz	a0,800015f0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015a6:	6118                	ld	a4,0(a0)
    800015a8:	00177793          	andi	a5,a4,1
    800015ac:	cbb1                	beqz	a5,80001600 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015ae:	00a75593          	srli	a1,a4,0xa
    800015b2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015b6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	538080e7          	jalr	1336(ra) # 80000af2 <kalloc>
    800015c2:	892a                	mv	s2,a0
    800015c4:	c939                	beqz	a0,8000161a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015c6:	6605                	lui	a2,0x1
    800015c8:	85de                	mv	a1,s7
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	774080e7          	jalr	1908(ra) # 80000d3e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015d2:	8726                	mv	a4,s1
    800015d4:	86ca                	mv	a3,s2
    800015d6:	6605                	lui	a2,0x1
    800015d8:	85ce                	mv	a1,s3
    800015da:	8556                	mv	a0,s5
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	adc080e7          	jalr	-1316(ra) # 800010b8 <mappages>
    800015e4:	e515                	bnez	a0,80001610 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015e6:	6785                	lui	a5,0x1
    800015e8:	99be                	add	s3,s3,a5
    800015ea:	fb49e6e3          	bltu	s3,s4,80001596 <uvmcopy+0x20>
    800015ee:	a081                	j	8000162e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015f0:	00008517          	auipc	a0,0x8
    800015f4:	b9850513          	addi	a0,a0,-1128 # 80009188 <digits+0x148>
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	f44080e7          	jalr	-188(ra) # 8000053c <panic>
      panic("uvmcopy: page not present");
    80001600:	00008517          	auipc	a0,0x8
    80001604:	ba850513          	addi	a0,a0,-1112 # 800091a8 <digits+0x168>
    80001608:	fffff097          	auipc	ra,0xfffff
    8000160c:	f34080e7          	jalr	-204(ra) # 8000053c <panic>
      kfree(mem);
    80001610:	854a                	mv	a0,s2
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	3e4080e7          	jalr	996(ra) # 800009f6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000161a:	4685                	li	a3,1
    8000161c:	00c9d613          	srli	a2,s3,0xc
    80001620:	4581                	li	a1,0
    80001622:	8556                	mv	a0,s5
    80001624:	00000097          	auipc	ra,0x0
    80001628:	c5a080e7          	jalr	-934(ra) # 8000127e <uvmunmap>
  return -1;
    8000162c:	557d                	li	a0,-1
}
    8000162e:	60a6                	ld	ra,72(sp)
    80001630:	6406                	ld	s0,64(sp)
    80001632:	74e2                	ld	s1,56(sp)
    80001634:	7942                	ld	s2,48(sp)
    80001636:	79a2                	ld	s3,40(sp)
    80001638:	7a02                	ld	s4,32(sp)
    8000163a:	6ae2                	ld	s5,24(sp)
    8000163c:	6b42                	ld	s6,16(sp)
    8000163e:	6ba2                	ld	s7,8(sp)
    80001640:	6161                	addi	sp,sp,80
    80001642:	8082                	ret
  return 0;
    80001644:	4501                	li	a0,0
}
    80001646:	8082                	ret

0000000080001648 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001648:	1141                	addi	sp,sp,-16
    8000164a:	e406                	sd	ra,8(sp)
    8000164c:	e022                	sd	s0,0(sp)
    8000164e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001650:	4601                	li	a2,0
    80001652:	00000097          	auipc	ra,0x0
    80001656:	97e080e7          	jalr	-1666(ra) # 80000fd0 <walk>
  if(pte == 0)
    8000165a:	c901                	beqz	a0,8000166a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000165c:	611c                	ld	a5,0(a0)
    8000165e:	9bbd                	andi	a5,a5,-17
    80001660:	e11c                	sd	a5,0(a0)
}
    80001662:	60a2                	ld	ra,8(sp)
    80001664:	6402                	ld	s0,0(sp)
    80001666:	0141                	addi	sp,sp,16
    80001668:	8082                	ret
    panic("uvmclear");
    8000166a:	00008517          	auipc	a0,0x8
    8000166e:	b5e50513          	addi	a0,a0,-1186 # 800091c8 <digits+0x188>
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	eca080e7          	jalr	-310(ra) # 8000053c <panic>

000000008000167a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000167a:	c6bd                	beqz	a3,800016e8 <copyout+0x6e>
{
    8000167c:	715d                	addi	sp,sp,-80
    8000167e:	e486                	sd	ra,72(sp)
    80001680:	e0a2                	sd	s0,64(sp)
    80001682:	fc26                	sd	s1,56(sp)
    80001684:	f84a                	sd	s2,48(sp)
    80001686:	f44e                	sd	s3,40(sp)
    80001688:	f052                	sd	s4,32(sp)
    8000168a:	ec56                	sd	s5,24(sp)
    8000168c:	e85a                	sd	s6,16(sp)
    8000168e:	e45e                	sd	s7,8(sp)
    80001690:	e062                	sd	s8,0(sp)
    80001692:	0880                	addi	s0,sp,80
    80001694:	8b2a                	mv	s6,a0
    80001696:	8c2e                	mv	s8,a1
    80001698:	8a32                	mv	s4,a2
    8000169a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000169c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000169e:	6a85                	lui	s5,0x1
    800016a0:	a015                	j	800016c4 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016a2:	9562                	add	a0,a0,s8
    800016a4:	0004861b          	sext.w	a2,s1
    800016a8:	85d2                	mv	a1,s4
    800016aa:	41250533          	sub	a0,a0,s2
    800016ae:	fffff097          	auipc	ra,0xfffff
    800016b2:	690080e7          	jalr	1680(ra) # 80000d3e <memmove>

    len -= n;
    800016b6:	409989b3          	sub	s3,s3,s1
    src += n;
    800016ba:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016bc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016c0:	02098263          	beqz	s3,800016e4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016c4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016c8:	85ca                	mv	a1,s2
    800016ca:	855a                	mv	a0,s6
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	9aa080e7          	jalr	-1622(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    800016d4:	cd01                	beqz	a0,800016ec <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016d6:	418904b3          	sub	s1,s2,s8
    800016da:	94d6                	add	s1,s1,s5
    if(n > len)
    800016dc:	fc99f3e3          	bgeu	s3,s1,800016a2 <copyout+0x28>
    800016e0:	84ce                	mv	s1,s3
    800016e2:	b7c1                	j	800016a2 <copyout+0x28>
  }
  return 0;
    800016e4:	4501                	li	a0,0
    800016e6:	a021                	j	800016ee <copyout+0x74>
    800016e8:	4501                	li	a0,0
}
    800016ea:	8082                	ret
      return -1;
    800016ec:	557d                	li	a0,-1
}
    800016ee:	60a6                	ld	ra,72(sp)
    800016f0:	6406                	ld	s0,64(sp)
    800016f2:	74e2                	ld	s1,56(sp)
    800016f4:	7942                	ld	s2,48(sp)
    800016f6:	79a2                	ld	s3,40(sp)
    800016f8:	7a02                	ld	s4,32(sp)
    800016fa:	6ae2                	ld	s5,24(sp)
    800016fc:	6b42                	ld	s6,16(sp)
    800016fe:	6ba2                	ld	s7,8(sp)
    80001700:	6c02                	ld	s8,0(sp)
    80001702:	6161                	addi	sp,sp,80
    80001704:	8082                	ret

0000000080001706 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001706:	c6bd                	beqz	a3,80001774 <copyin+0x6e>
{
    80001708:	715d                	addi	sp,sp,-80
    8000170a:	e486                	sd	ra,72(sp)
    8000170c:	e0a2                	sd	s0,64(sp)
    8000170e:	fc26                	sd	s1,56(sp)
    80001710:	f84a                	sd	s2,48(sp)
    80001712:	f44e                	sd	s3,40(sp)
    80001714:	f052                	sd	s4,32(sp)
    80001716:	ec56                	sd	s5,24(sp)
    80001718:	e85a                	sd	s6,16(sp)
    8000171a:	e45e                	sd	s7,8(sp)
    8000171c:	e062                	sd	s8,0(sp)
    8000171e:	0880                	addi	s0,sp,80
    80001720:	8b2a                	mv	s6,a0
    80001722:	8a2e                	mv	s4,a1
    80001724:	8c32                	mv	s8,a2
    80001726:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001728:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000172a:	6a85                	lui	s5,0x1
    8000172c:	a015                	j	80001750 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000172e:	9562                	add	a0,a0,s8
    80001730:	0004861b          	sext.w	a2,s1
    80001734:	412505b3          	sub	a1,a0,s2
    80001738:	8552                	mv	a0,s4
    8000173a:	fffff097          	auipc	ra,0xfffff
    8000173e:	604080e7          	jalr	1540(ra) # 80000d3e <memmove>

    len -= n;
    80001742:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001746:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001748:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000174c:	02098263          	beqz	s3,80001770 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001750:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001754:	85ca                	mv	a1,s2
    80001756:	855a                	mv	a0,s6
    80001758:	00000097          	auipc	ra,0x0
    8000175c:	91e080e7          	jalr	-1762(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    80001760:	cd01                	beqz	a0,80001778 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001762:	418904b3          	sub	s1,s2,s8
    80001766:	94d6                	add	s1,s1,s5
    if(n > len)
    80001768:	fc99f3e3          	bgeu	s3,s1,8000172e <copyin+0x28>
    8000176c:	84ce                	mv	s1,s3
    8000176e:	b7c1                	j	8000172e <copyin+0x28>
  }
  return 0;
    80001770:	4501                	li	a0,0
    80001772:	a021                	j	8000177a <copyin+0x74>
    80001774:	4501                	li	a0,0
}
    80001776:	8082                	ret
      return -1;
    80001778:	557d                	li	a0,-1
}
    8000177a:	60a6                	ld	ra,72(sp)
    8000177c:	6406                	ld	s0,64(sp)
    8000177e:	74e2                	ld	s1,56(sp)
    80001780:	7942                	ld	s2,48(sp)
    80001782:	79a2                	ld	s3,40(sp)
    80001784:	7a02                	ld	s4,32(sp)
    80001786:	6ae2                	ld	s5,24(sp)
    80001788:	6b42                	ld	s6,16(sp)
    8000178a:	6ba2                	ld	s7,8(sp)
    8000178c:	6c02                	ld	s8,0(sp)
    8000178e:	6161                	addi	sp,sp,80
    80001790:	8082                	ret

0000000080001792 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001792:	c6c5                	beqz	a3,8000183a <copyinstr+0xa8>
{
    80001794:	715d                	addi	sp,sp,-80
    80001796:	e486                	sd	ra,72(sp)
    80001798:	e0a2                	sd	s0,64(sp)
    8000179a:	fc26                	sd	s1,56(sp)
    8000179c:	f84a                	sd	s2,48(sp)
    8000179e:	f44e                	sd	s3,40(sp)
    800017a0:	f052                	sd	s4,32(sp)
    800017a2:	ec56                	sd	s5,24(sp)
    800017a4:	e85a                	sd	s6,16(sp)
    800017a6:	e45e                	sd	s7,8(sp)
    800017a8:	0880                	addi	s0,sp,80
    800017aa:	8a2a                	mv	s4,a0
    800017ac:	8b2e                	mv	s6,a1
    800017ae:	8bb2                	mv	s7,a2
    800017b0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017b2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017b4:	6985                	lui	s3,0x1
    800017b6:	a035                	j	800017e2 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017b8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017bc:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017be:	0017b793          	seqz	a5,a5
    800017c2:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017c6:	60a6                	ld	ra,72(sp)
    800017c8:	6406                	ld	s0,64(sp)
    800017ca:	74e2                	ld	s1,56(sp)
    800017cc:	7942                	ld	s2,48(sp)
    800017ce:	79a2                	ld	s3,40(sp)
    800017d0:	7a02                	ld	s4,32(sp)
    800017d2:	6ae2                	ld	s5,24(sp)
    800017d4:	6b42                	ld	s6,16(sp)
    800017d6:	6ba2                	ld	s7,8(sp)
    800017d8:	6161                	addi	sp,sp,80
    800017da:	8082                	ret
    srcva = va0 + PGSIZE;
    800017dc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017e0:	c8a9                	beqz	s1,80001832 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017e2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017e6:	85ca                	mv	a1,s2
    800017e8:	8552                	mv	a0,s4
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	88c080e7          	jalr	-1908(ra) # 80001076 <walkaddr>
    if(pa0 == 0)
    800017f2:	c131                	beqz	a0,80001836 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017f4:	41790833          	sub	a6,s2,s7
    800017f8:	984e                	add	a6,a6,s3
    if(n > max)
    800017fa:	0104f363          	bgeu	s1,a6,80001800 <copyinstr+0x6e>
    800017fe:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001800:	955e                	add	a0,a0,s7
    80001802:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001806:	fc080be3          	beqz	a6,800017dc <copyinstr+0x4a>
    8000180a:	985a                	add	a6,a6,s6
    8000180c:	87da                	mv	a5,s6
      if(*p == '\0'){
    8000180e:	41650633          	sub	a2,a0,s6
    80001812:	14fd                	addi	s1,s1,-1
    80001814:	9b26                	add	s6,s6,s1
    80001816:	00f60733          	add	a4,a2,a5
    8000181a:	00074703          	lbu	a4,0(a4)
    8000181e:	df49                	beqz	a4,800017b8 <copyinstr+0x26>
        *dst = *p;
    80001820:	00e78023          	sb	a4,0(a5)
      --max;
    80001824:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001828:	0785                	addi	a5,a5,1
    while(n > 0){
    8000182a:	ff0796e3          	bne	a5,a6,80001816 <copyinstr+0x84>
      dst++;
    8000182e:	8b42                	mv	s6,a6
    80001830:	b775                	j	800017dc <copyinstr+0x4a>
    80001832:	4781                	li	a5,0
    80001834:	b769                	j	800017be <copyinstr+0x2c>
      return -1;
    80001836:	557d                	li	a0,-1
    80001838:	b779                	j	800017c6 <copyinstr+0x34>
  int got_null = 0;
    8000183a:	4781                	li	a5,0
  if(got_null){
    8000183c:	0017b793          	seqz	a5,a5
    80001840:	40f00533          	neg	a0,a5
}
    80001844:	8082                	ret

0000000080001846 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80001846:	7139                	addi	sp,sp,-64
    80001848:	fc06                	sd	ra,56(sp)
    8000184a:	f822                	sd	s0,48(sp)
    8000184c:	f426                	sd	s1,40(sp)
    8000184e:	f04a                	sd	s2,32(sp)
    80001850:	ec4e                	sd	s3,24(sp)
    80001852:	e852                	sd	s4,16(sp)
    80001854:	e456                	sd	s5,8(sp)
    80001856:	e05a                	sd	s6,0(sp)
    80001858:	0080                	addi	s0,sp,64
    8000185a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185c:	00012497          	auipc	s1,0x12
    80001860:	75448493          	addi	s1,s1,1876 # 80013fb0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001864:	8b26                	mv	s6,s1
    80001866:	00007a97          	auipc	s5,0x7
    8000186a:	79aa8a93          	addi	s5,s5,1946 # 80009000 <etext>
    8000186e:	04000937          	lui	s2,0x4000
    80001872:	197d                	addi	s2,s2,-1
    80001874:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001876:	00019a17          	auipc	s4,0x19
    8000187a:	b3aa0a13          	addi	s4,s4,-1222 # 8001a3b0 <tickslock>
    char *pa = kalloc();
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	274080e7          	jalr	628(ra) # 80000af2 <kalloc>
    80001886:	862a                	mv	a2,a0
    if(pa == 0)
    80001888:	c131                	beqz	a0,800018cc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000188a:	416485b3          	sub	a1,s1,s6
    8000188e:	8591                	srai	a1,a1,0x4
    80001890:	000ab783          	ld	a5,0(s5)
    80001894:	02f585b3          	mul	a1,a1,a5
    80001898:	2585                	addiw	a1,a1,1
    8000189a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000189e:	4719                	li	a4,6
    800018a0:	6685                	lui	a3,0x1
    800018a2:	40b905b3          	sub	a1,s2,a1
    800018a6:	854e                	mv	a0,s3
    800018a8:	00000097          	auipc	ra,0x0
    800018ac:	8b0080e7          	jalr	-1872(ra) # 80001158 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b0:	19048493          	addi	s1,s1,400
    800018b4:	fd4495e3          	bne	s1,s4,8000187e <proc_mapstacks+0x38>
  }
}
    800018b8:	70e2                	ld	ra,56(sp)
    800018ba:	7442                	ld	s0,48(sp)
    800018bc:	74a2                	ld	s1,40(sp)
    800018be:	7902                	ld	s2,32(sp)
    800018c0:	69e2                	ld	s3,24(sp)
    800018c2:	6a42                	ld	s4,16(sp)
    800018c4:	6aa2                	ld	s5,8(sp)
    800018c6:	6b02                	ld	s6,0(sp)
    800018c8:	6121                	addi	sp,sp,64
    800018ca:	8082                	ret
      panic("kalloc");
    800018cc:	00008517          	auipc	a0,0x8
    800018d0:	90c50513          	addi	a0,a0,-1780 # 800091d8 <digits+0x198>
    800018d4:	fffff097          	auipc	ra,0xfffff
    800018d8:	c68080e7          	jalr	-920(ra) # 8000053c <panic>

00000000800018dc <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018dc:	7139                	addi	sp,sp,-64
    800018de:	fc06                	sd	ra,56(sp)
    800018e0:	f822                	sd	s0,48(sp)
    800018e2:	f426                	sd	s1,40(sp)
    800018e4:	f04a                	sd	s2,32(sp)
    800018e6:	ec4e                	sd	s3,24(sp)
    800018e8:	e852                	sd	s4,16(sp)
    800018ea:	e456                	sd	s5,8(sp)
    800018ec:	e05a                	sd	s6,0(sp)
    800018ee:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018f0:	00008597          	auipc	a1,0x8
    800018f4:	8f058593          	addi	a1,a1,-1808 # 800091e0 <digits+0x1a0>
    800018f8:	00011517          	auipc	a0,0x11
    800018fc:	9e850513          	addi	a0,a0,-1560 # 800122e0 <pid_lock>
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	252080e7          	jalr	594(ra) # 80000b52 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001908:	00008597          	auipc	a1,0x8
    8000190c:	8e058593          	addi	a1,a1,-1824 # 800091e8 <digits+0x1a8>
    80001910:	00011517          	auipc	a0,0x11
    80001914:	9e850513          	addi	a0,a0,-1560 # 800122f8 <wait_lock>
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	23a080e7          	jalr	570(ra) # 80000b52 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001920:	00012497          	auipc	s1,0x12
    80001924:	69048493          	addi	s1,s1,1680 # 80013fb0 <proc>
      initlock(&p->lock, "proc");
    80001928:	00008b17          	auipc	s6,0x8
    8000192c:	8d0b0b13          	addi	s6,s6,-1840 # 800091f8 <digits+0x1b8>
      p->kstack = KSTACK((int) (p - proc));
    80001930:	8aa6                	mv	s5,s1
    80001932:	00007a17          	auipc	s4,0x7
    80001936:	6cea0a13          	addi	s4,s4,1742 # 80009000 <etext>
    8000193a:	04000937          	lui	s2,0x4000
    8000193e:	197d                	addi	s2,s2,-1
    80001940:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001942:	00019997          	auipc	s3,0x19
    80001946:	a6e98993          	addi	s3,s3,-1426 # 8001a3b0 <tickslock>
      initlock(&p->lock, "proc");
    8000194a:	85da                	mv	a1,s6
    8000194c:	8526                	mv	a0,s1
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	204080e7          	jalr	516(ra) # 80000b52 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001956:	415487b3          	sub	a5,s1,s5
    8000195a:	8791                	srai	a5,a5,0x4
    8000195c:	000a3703          	ld	a4,0(s4)
    80001960:	02e787b3          	mul	a5,a5,a4
    80001964:	2785                	addiw	a5,a5,1
    80001966:	00d7979b          	slliw	a5,a5,0xd
    8000196a:	40f907b3          	sub	a5,s2,a5
    8000196e:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001970:	19048493          	addi	s1,s1,400
    80001974:	fd349be3          	bne	s1,s3,8000194a <procinit+0x6e>
  }
}
    80001978:	70e2                	ld	ra,56(sp)
    8000197a:	7442                	ld	s0,48(sp)
    8000197c:	74a2                	ld	s1,40(sp)
    8000197e:	7902                	ld	s2,32(sp)
    80001980:	69e2                	ld	s3,24(sp)
    80001982:	6a42                	ld	s4,16(sp)
    80001984:	6aa2                	ld	s5,8(sp)
    80001986:	6b02                	ld	s6,0(sp)
    80001988:	6121                	addi	sp,sp,64
    8000198a:	8082                	ret

000000008000198c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000198c:	1141                	addi	sp,sp,-16
    8000198e:	e422                	sd	s0,8(sp)
    80001990:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001992:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001994:	2501                	sext.w	a0,a0
    80001996:	6422                	ld	s0,8(sp)
    80001998:	0141                	addi	sp,sp,16
    8000199a:	8082                	ret

000000008000199c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000199c:	1141                	addi	sp,sp,-16
    8000199e:	e422                	sd	s0,8(sp)
    800019a0:	0800                	addi	s0,sp,16
    800019a2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019a4:	2781                	sext.w	a5,a5
    800019a6:	079e                	slli	a5,a5,0x7
  return c;
}
    800019a8:	00011517          	auipc	a0,0x11
    800019ac:	96850513          	addi	a0,a0,-1688 # 80012310 <cpus>
    800019b0:	953e                	add	a0,a0,a5
    800019b2:	6422                	ld	s0,8(sp)
    800019b4:	0141                	addi	sp,sp,16
    800019b6:	8082                	ret

00000000800019b8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    800019b8:	1101                	addi	sp,sp,-32
    800019ba:	ec06                	sd	ra,24(sp)
    800019bc:	e822                	sd	s0,16(sp)
    800019be:	e426                	sd	s1,8(sp)
    800019c0:	1000                	addi	s0,sp,32
  push_off();
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	1d4080e7          	jalr	468(ra) # 80000b96 <push_off>
    800019ca:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019cc:	2781                	sext.w	a5,a5
    800019ce:	079e                	slli	a5,a5,0x7
    800019d0:	00011717          	auipc	a4,0x11
    800019d4:	91070713          	addi	a4,a4,-1776 # 800122e0 <pid_lock>
    800019d8:	97ba                	add	a5,a5,a4
    800019da:	7b84                	ld	s1,48(a5)
  pop_off();
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	25a080e7          	jalr	602(ra) # 80000c36 <pop_off>
  return p;
}
    800019e4:	8526                	mv	a0,s1
    800019e6:	60e2                	ld	ra,24(sp)
    800019e8:	6442                	ld	s0,16(sp)
    800019ea:	64a2                	ld	s1,8(sp)
    800019ec:	6105                	addi	sp,sp,32
    800019ee:	8082                	ret

00000000800019f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019f0:	1101                	addi	sp,sp,-32
    800019f2:	ec06                	sd	ra,24(sp)
    800019f4:	e822                	sd	s0,16(sp)
    800019f6:	e426                	sd	s1,8(sp)
    800019f8:	1000                	addi	s0,sp,32
  static int first = 1;
  uint xticks;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019fa:	00000097          	auipc	ra,0x0
    800019fe:	fbe080e7          	jalr	-66(ra) # 800019b8 <myproc>
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	294080e7          	jalr	660(ra) # 80000c96 <release>

  acquire(&tickslock);
    80001a0a:	00019517          	auipc	a0,0x19
    80001a0e:	9a650513          	addi	a0,a0,-1626 # 8001a3b0 <tickslock>
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	1d0080e7          	jalr	464(ra) # 80000be2 <acquire>
  xticks = ticks;
    80001a1a:	00008497          	auipc	s1,0x8
    80001a1e:	6624a483          	lw	s1,1634(s1) # 8000a07c <ticks>
  release(&tickslock);
    80001a22:	00019517          	auipc	a0,0x19
    80001a26:	98e50513          	addi	a0,a0,-1650 # 8001a3b0 <tickslock>
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	26c080e7          	jalr	620(ra) # 80000c96 <release>

  myproc()->stime = xticks;
    80001a32:	00000097          	auipc	ra,0x0
    80001a36:	f86080e7          	jalr	-122(ra) # 800019b8 <myproc>
    80001a3a:	16952a23          	sw	s1,372(a0)

  if (first) {
    80001a3e:	00008797          	auipc	a5,0x8
    80001a42:	1a27a783          	lw	a5,418(a5) # 80009be0 <first.2553>
    80001a46:	eb91                	bnez	a5,80001a5a <forkret+0x6a>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a48:	00002097          	auipc	ra,0x2
    80001a4c:	584080e7          	jalr	1412(ra) # 80003fcc <usertrapret>
}
    80001a50:	60e2                	ld	ra,24(sp)
    80001a52:	6442                	ld	s0,16(sp)
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	6105                	addi	sp,sp,32
    80001a58:	8082                	ret
    first = 0;
    80001a5a:	00008797          	auipc	a5,0x8
    80001a5e:	1807a323          	sw	zero,390(a5) # 80009be0 <first.2553>
    fsinit(ROOTDEV);
    80001a62:	4505                	li	a0,1
    80001a64:	00003097          	auipc	ra,0x3
    80001a68:	6a2080e7          	jalr	1698(ra) # 80005106 <fsinit>
    80001a6c:	bff1                	j	80001a48 <forkret+0x58>

0000000080001a6e <allocpid>:
allocpid() {
    80001a6e:	1101                	addi	sp,sp,-32
    80001a70:	ec06                	sd	ra,24(sp)
    80001a72:	e822                	sd	s0,16(sp)
    80001a74:	e426                	sd	s1,8(sp)
    80001a76:	e04a                	sd	s2,0(sp)
    80001a78:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a7a:	00011917          	auipc	s2,0x11
    80001a7e:	86690913          	addi	s2,s2,-1946 # 800122e0 <pid_lock>
    80001a82:	854a                	mv	a0,s2
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	15e080e7          	jalr	350(ra) # 80000be2 <acquire>
  pid = nextpid;
    80001a8c:	00008797          	auipc	a5,0x8
    80001a90:	16878793          	addi	a5,a5,360 # 80009bf4 <nextpid>
    80001a94:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a96:	0014871b          	addiw	a4,s1,1
    80001a9a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a9c:	854a                	mv	a0,s2
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	1f8080e7          	jalr	504(ra) # 80000c96 <release>
}
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	60e2                	ld	ra,24(sp)
    80001aaa:	6442                	ld	s0,16(sp)
    80001aac:	64a2                	ld	s1,8(sp)
    80001aae:	6902                	ld	s2,0(sp)
    80001ab0:	6105                	addi	sp,sp,32
    80001ab2:	8082                	ret

0000000080001ab4 <proc_pagetable>:
{
    80001ab4:	1101                	addi	sp,sp,-32
    80001ab6:	ec06                	sd	ra,24(sp)
    80001ab8:	e822                	sd	s0,16(sp)
    80001aba:	e426                	sd	s1,8(sp)
    80001abc:	e04a                	sd	s2,0(sp)
    80001abe:	1000                	addi	s0,sp,32
    80001ac0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ac2:	00000097          	auipc	ra,0x0
    80001ac6:	880080e7          	jalr	-1920(ra) # 80001342 <uvmcreate>
    80001aca:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001acc:	c121                	beqz	a0,80001b0c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ace:	4729                	li	a4,10
    80001ad0:	00006697          	auipc	a3,0x6
    80001ad4:	53068693          	addi	a3,a3,1328 # 80008000 <_trampoline>
    80001ad8:	6605                	lui	a2,0x1
    80001ada:	040005b7          	lui	a1,0x4000
    80001ade:	15fd                	addi	a1,a1,-1
    80001ae0:	05b2                	slli	a1,a1,0xc
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	5d6080e7          	jalr	1494(ra) # 800010b8 <mappages>
    80001aea:	02054863          	bltz	a0,80001b1a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aee:	4719                	li	a4,6
    80001af0:	06093683          	ld	a3,96(s2)
    80001af4:	6605                	lui	a2,0x1
    80001af6:	020005b7          	lui	a1,0x2000
    80001afa:	15fd                	addi	a1,a1,-1
    80001afc:	05b6                	slli	a1,a1,0xd
    80001afe:	8526                	mv	a0,s1
    80001b00:	fffff097          	auipc	ra,0xfffff
    80001b04:	5b8080e7          	jalr	1464(ra) # 800010b8 <mappages>
    80001b08:	02054163          	bltz	a0,80001b2a <proc_pagetable+0x76>
}
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	60e2                	ld	ra,24(sp)
    80001b10:	6442                	ld	s0,16(sp)
    80001b12:	64a2                	ld	s1,8(sp)
    80001b14:	6902                	ld	s2,0(sp)
    80001b16:	6105                	addi	sp,sp,32
    80001b18:	8082                	ret
    uvmfree(pagetable, 0);
    80001b1a:	4581                	li	a1,0
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	00000097          	auipc	ra,0x0
    80001b22:	a20080e7          	jalr	-1504(ra) # 8000153e <uvmfree>
    return 0;
    80001b26:	4481                	li	s1,0
    80001b28:	b7d5                	j	80001b0c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b2a:	4681                	li	a3,0
    80001b2c:	4605                	li	a2,1
    80001b2e:	040005b7          	lui	a1,0x4000
    80001b32:	15fd                	addi	a1,a1,-1
    80001b34:	05b2                	slli	a1,a1,0xc
    80001b36:	8526                	mv	a0,s1
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	746080e7          	jalr	1862(ra) # 8000127e <uvmunmap>
    uvmfree(pagetable, 0);
    80001b40:	4581                	li	a1,0
    80001b42:	8526                	mv	a0,s1
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	9fa080e7          	jalr	-1542(ra) # 8000153e <uvmfree>
    return 0;
    80001b4c:	4481                	li	s1,0
    80001b4e:	bf7d                	j	80001b0c <proc_pagetable+0x58>

0000000080001b50 <proc_freepagetable>:
{
    80001b50:	1101                	addi	sp,sp,-32
    80001b52:	ec06                	sd	ra,24(sp)
    80001b54:	e822                	sd	s0,16(sp)
    80001b56:	e426                	sd	s1,8(sp)
    80001b58:	e04a                	sd	s2,0(sp)
    80001b5a:	1000                	addi	s0,sp,32
    80001b5c:	84aa                	mv	s1,a0
    80001b5e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b60:	4681                	li	a3,0
    80001b62:	4605                	li	a2,1
    80001b64:	040005b7          	lui	a1,0x4000
    80001b68:	15fd                	addi	a1,a1,-1
    80001b6a:	05b2                	slli	a1,a1,0xc
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	712080e7          	jalr	1810(ra) # 8000127e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b74:	4681                	li	a3,0
    80001b76:	4605                	li	a2,1
    80001b78:	020005b7          	lui	a1,0x2000
    80001b7c:	15fd                	addi	a1,a1,-1
    80001b7e:	05b6                	slli	a1,a1,0xd
    80001b80:	8526                	mv	a0,s1
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	6fc080e7          	jalr	1788(ra) # 8000127e <uvmunmap>
  uvmfree(pagetable, sz);
    80001b8a:	85ca                	mv	a1,s2
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	00000097          	auipc	ra,0x0
    80001b92:	9b0080e7          	jalr	-1616(ra) # 8000153e <uvmfree>
}
    80001b96:	60e2                	ld	ra,24(sp)
    80001b98:	6442                	ld	s0,16(sp)
    80001b9a:	64a2                	ld	s1,8(sp)
    80001b9c:	6902                	ld	s2,0(sp)
    80001b9e:	6105                	addi	sp,sp,32
    80001ba0:	8082                	ret

0000000080001ba2 <freeproc>:
{
    80001ba2:	1101                	addi	sp,sp,-32
    80001ba4:	ec06                	sd	ra,24(sp)
    80001ba6:	e822                	sd	s0,16(sp)
    80001ba8:	e426                	sd	s1,8(sp)
    80001baa:	1000                	addi	s0,sp,32
    80001bac:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bae:	7128                	ld	a0,96(a0)
    80001bb0:	c509                	beqz	a0,80001bba <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	e44080e7          	jalr	-444(ra) # 800009f6 <kfree>
  p->trapframe = 0;
    80001bba:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001bbe:	6ca8                	ld	a0,88(s1)
    80001bc0:	c511                	beqz	a0,80001bcc <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001bc2:	68ac                	ld	a1,80(s1)
    80001bc4:	00000097          	auipc	ra,0x0
    80001bc8:	f8c080e7          	jalr	-116(ra) # 80001b50 <proc_freepagetable>
  p->pagetable = 0;
    80001bcc:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001bd0:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001bd4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001bd8:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001bdc:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001be0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001be4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001be8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bec:	0004ac23          	sw	zero,24(s1)
}
    80001bf0:	60e2                	ld	ra,24(sp)
    80001bf2:	6442                	ld	s0,16(sp)
    80001bf4:	64a2                	ld	s1,8(sp)
    80001bf6:	6105                	addi	sp,sp,32
    80001bf8:	8082                	ret

0000000080001bfa <allocproc>:
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	e04a                	sd	s2,0(sp)
    80001c04:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c06:	00012497          	auipc	s1,0x12
    80001c0a:	3aa48493          	addi	s1,s1,938 # 80013fb0 <proc>
    80001c0e:	00018917          	auipc	s2,0x18
    80001c12:	7a290913          	addi	s2,s2,1954 # 8001a3b0 <tickslock>
    acquire(&p->lock);
    80001c16:	8526                	mv	a0,s1
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	fca080e7          	jalr	-54(ra) # 80000be2 <acquire>
    if(p->state == UNUSED) {
    80001c20:	4c9c                	lw	a5,24(s1)
    80001c22:	cf81                	beqz	a5,80001c3a <allocproc+0x40>
      release(&p->lock);
    80001c24:	8526                	mv	a0,s1
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	070080e7          	jalr	112(ra) # 80000c96 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c2e:	19048493          	addi	s1,s1,400
    80001c32:	ff2492e3          	bne	s1,s2,80001c16 <allocproc+0x1c>
  return 0;
    80001c36:	4481                	li	s1,0
    80001c38:	a841                	j	80001cc8 <allocproc+0xce>
  p->pid = allocpid();
    80001c3a:	00000097          	auipc	ra,0x0
    80001c3e:	e34080e7          	jalr	-460(ra) # 80001a6e <allocpid>
    80001c42:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c44:	4785                	li	a5,1
    80001c46:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c48:	fffff097          	auipc	ra,0xfffff
    80001c4c:	eaa080e7          	jalr	-342(ra) # 80000af2 <kalloc>
    80001c50:	892a                	mv	s2,a0
    80001c52:	f0a8                	sd	a0,96(s1)
    80001c54:	c149                	beqz	a0,80001cd6 <allocproc+0xdc>
  p->pagetable = proc_pagetable(p);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	e5c080e7          	jalr	-420(ra) # 80001ab4 <proc_pagetable>
    80001c60:	892a                	mv	s2,a0
    80001c62:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001c64:	c549                	beqz	a0,80001cee <allocproc+0xf4>
  memset(&p->context, 0, sizeof(p->context));
    80001c66:	07000613          	li	a2,112
    80001c6a:	4581                	li	a1,0
    80001c6c:	06848513          	addi	a0,s1,104
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	06e080e7          	jalr	110(ra) # 80000cde <memset>
  p->context.ra = (uint64)forkret;
    80001c78:	00000797          	auipc	a5,0x0
    80001c7c:	d7878793          	addi	a5,a5,-648 # 800019f0 <forkret>
    80001c80:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c82:	64bc                	ld	a5,72(s1)
    80001c84:	6705                	lui	a4,0x1
    80001c86:	97ba                	add	a5,a5,a4
    80001c88:	f8bc                	sd	a5,112(s1)
  acquire(&tickslock);
    80001c8a:	00018517          	auipc	a0,0x18
    80001c8e:	72650513          	addi	a0,a0,1830 # 8001a3b0 <tickslock>
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	f50080e7          	jalr	-176(ra) # 80000be2 <acquire>
  xticks = ticks;
    80001c9a:	00008917          	auipc	s2,0x8
    80001c9e:	3e292903          	lw	s2,994(s2) # 8000a07c <ticks>
  release(&tickslock);
    80001ca2:	00018517          	auipc	a0,0x18
    80001ca6:	70e50513          	addi	a0,a0,1806 # 8001a3b0 <tickslock>
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	fec080e7          	jalr	-20(ra) # 80000c96 <release>
  p->ctime = xticks;
    80001cb2:	1724a823          	sw	s2,368(s1)
  p->stime = -1;
    80001cb6:	57fd                	li	a5,-1
    80001cb8:	16f4aa23          	sw	a5,372(s1)
  p->endtime = -1;
    80001cbc:	16f4ac23          	sw	a5,376(s1)
  p->is_batchproc = 0;
    80001cc0:	0204ae23          	sw	zero,60(s1)
  p->cpu_usage = 0;
    80001cc4:	1804a623          	sw	zero,396(s1)
}
    80001cc8:	8526                	mv	a0,s1
    80001cca:	60e2                	ld	ra,24(sp)
    80001ccc:	6442                	ld	s0,16(sp)
    80001cce:	64a2                	ld	s1,8(sp)
    80001cd0:	6902                	ld	s2,0(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret
    freeproc(p);
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	eca080e7          	jalr	-310(ra) # 80001ba2 <freeproc>
    release(&p->lock);
    80001ce0:	8526                	mv	a0,s1
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	fb4080e7          	jalr	-76(ra) # 80000c96 <release>
    return 0;
    80001cea:	84ca                	mv	s1,s2
    80001cec:	bff1                	j	80001cc8 <allocproc+0xce>
    freeproc(p);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	eb2080e7          	jalr	-334(ra) # 80001ba2 <freeproc>
    release(&p->lock);
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	f9c080e7          	jalr	-100(ra) # 80000c96 <release>
    return 0;
    80001d02:	84ca                	mv	s1,s2
    80001d04:	b7d1                	j	80001cc8 <allocproc+0xce>

0000000080001d06 <userinit>:
{
    80001d06:	1101                	addi	sp,sp,-32
    80001d08:	ec06                	sd	ra,24(sp)
    80001d0a:	e822                	sd	s0,16(sp)
    80001d0c:	e426                	sd	s1,8(sp)
    80001d0e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	eea080e7          	jalr	-278(ra) # 80001bfa <allocproc>
    80001d18:	84aa                	mv	s1,a0
  initproc = p;
    80001d1a:	00008797          	auipc	a5,0x8
    80001d1e:	34a7bb23          	sd	a0,854(a5) # 8000a070 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d22:	03400613          	li	a2,52
    80001d26:	00008597          	auipc	a1,0x8
    80001d2a:	eda58593          	addi	a1,a1,-294 # 80009c00 <initcode>
    80001d2e:	6d28                	ld	a0,88(a0)
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	640080e7          	jalr	1600(ra) # 80001370 <uvminit>
  p->sz = PGSIZE;
    80001d38:	6785                	lui	a5,0x1
    80001d3a:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d3c:	70b8                	ld	a4,96(s1)
    80001d3e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d42:	70b8                	ld	a4,96(s1)
    80001d44:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d46:	4641                	li	a2,16
    80001d48:	00007597          	auipc	a1,0x7
    80001d4c:	4b858593          	addi	a1,a1,1208 # 80009200 <digits+0x1c0>
    80001d50:	16048513          	addi	a0,s1,352
    80001d54:	fffff097          	auipc	ra,0xfffff
    80001d58:	0dc080e7          	jalr	220(ra) # 80000e30 <safestrcpy>
  p->cwd = namei("/");
    80001d5c:	00007517          	auipc	a0,0x7
    80001d60:	4b450513          	addi	a0,a0,1204 # 80009210 <digits+0x1d0>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	dd0080e7          	jalr	-560(ra) # 80005b34 <namei>
    80001d6c:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001d70:	478d                	li	a5,3
    80001d72:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	f20080e7          	jalr	-224(ra) # 80000c96 <release>
}
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	64a2                	ld	s1,8(sp)
    80001d84:	6105                	addi	sp,sp,32
    80001d86:	8082                	ret

0000000080001d88 <growproc>:
{
    80001d88:	1101                	addi	sp,sp,-32
    80001d8a:	ec06                	sd	ra,24(sp)
    80001d8c:	e822                	sd	s0,16(sp)
    80001d8e:	e426                	sd	s1,8(sp)
    80001d90:	e04a                	sd	s2,0(sp)
    80001d92:	1000                	addi	s0,sp,32
    80001d94:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	c22080e7          	jalr	-990(ra) # 800019b8 <myproc>
    80001d9e:	892a                	mv	s2,a0
  sz = p->sz;
    80001da0:	692c                	ld	a1,80(a0)
    80001da2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001da6:	00904f63          	bgtz	s1,80001dc4 <growproc+0x3c>
  } else if(n < 0){
    80001daa:	0204cc63          	bltz	s1,80001de2 <growproc+0x5a>
  p->sz = sz;
    80001dae:	1602                	slli	a2,a2,0x20
    80001db0:	9201                	srli	a2,a2,0x20
    80001db2:	04c93823          	sd	a2,80(s2)
  return 0;
    80001db6:	4501                	li	a0,0
}
    80001db8:	60e2                	ld	ra,24(sp)
    80001dba:	6442                	ld	s0,16(sp)
    80001dbc:	64a2                	ld	s1,8(sp)
    80001dbe:	6902                	ld	s2,0(sp)
    80001dc0:	6105                	addi	sp,sp,32
    80001dc2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001dc4:	9e25                	addw	a2,a2,s1
    80001dc6:	1602                	slli	a2,a2,0x20
    80001dc8:	9201                	srli	a2,a2,0x20
    80001dca:	1582                	slli	a1,a1,0x20
    80001dcc:	9181                	srli	a1,a1,0x20
    80001dce:	6d28                	ld	a0,88(a0)
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	65a080e7          	jalr	1626(ra) # 8000142a <uvmalloc>
    80001dd8:	0005061b          	sext.w	a2,a0
    80001ddc:	fa69                	bnez	a2,80001dae <growproc+0x26>
      return -1;
    80001dde:	557d                	li	a0,-1
    80001de0:	bfe1                	j	80001db8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001de2:	9e25                	addw	a2,a2,s1
    80001de4:	1602                	slli	a2,a2,0x20
    80001de6:	9201                	srli	a2,a2,0x20
    80001de8:	1582                	slli	a1,a1,0x20
    80001dea:	9181                	srli	a1,a1,0x20
    80001dec:	6d28                	ld	a0,88(a0)
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	5f4080e7          	jalr	1524(ra) # 800013e2 <uvmdealloc>
    80001df6:	0005061b          	sext.w	a2,a0
    80001dfa:	bf55                	j	80001dae <growproc+0x26>

0000000080001dfc <fork>:
{
    80001dfc:	7179                	addi	sp,sp,-48
    80001dfe:	f406                	sd	ra,40(sp)
    80001e00:	f022                	sd	s0,32(sp)
    80001e02:	ec26                	sd	s1,24(sp)
    80001e04:	e84a                	sd	s2,16(sp)
    80001e06:	e44e                	sd	s3,8(sp)
    80001e08:	e052                	sd	s4,0(sp)
    80001e0a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	bac080e7          	jalr	-1108(ra) # 800019b8 <myproc>
    80001e14:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e16:	00000097          	auipc	ra,0x0
    80001e1a:	de4080e7          	jalr	-540(ra) # 80001bfa <allocproc>
    80001e1e:	10050b63          	beqz	a0,80001f34 <fork+0x138>
    80001e22:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e24:	05093603          	ld	a2,80(s2)
    80001e28:	6d2c                	ld	a1,88(a0)
    80001e2a:	05893503          	ld	a0,88(s2)
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	748080e7          	jalr	1864(ra) # 80001576 <uvmcopy>
    80001e36:	04054663          	bltz	a0,80001e82 <fork+0x86>
  np->sz = p->sz;
    80001e3a:	05093783          	ld	a5,80(s2)
    80001e3e:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e42:	06093683          	ld	a3,96(s2)
    80001e46:	87b6                	mv	a5,a3
    80001e48:	0609b703          	ld	a4,96(s3)
    80001e4c:	12068693          	addi	a3,a3,288
    80001e50:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e54:	6788                	ld	a0,8(a5)
    80001e56:	6b8c                	ld	a1,16(a5)
    80001e58:	6f90                	ld	a2,24(a5)
    80001e5a:	01073023          	sd	a6,0(a4)
    80001e5e:	e708                	sd	a0,8(a4)
    80001e60:	eb0c                	sd	a1,16(a4)
    80001e62:	ef10                	sd	a2,24(a4)
    80001e64:	02078793          	addi	a5,a5,32
    80001e68:	02070713          	addi	a4,a4,32
    80001e6c:	fed792e3          	bne	a5,a3,80001e50 <fork+0x54>
  np->trapframe->a0 = 0;
    80001e70:	0609b783          	ld	a5,96(s3)
    80001e74:	0607b823          	sd	zero,112(a5)
    80001e78:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001e7c:	15800a13          	li	s4,344
    80001e80:	a03d                	j	80001eae <fork+0xb2>
    freeproc(np);
    80001e82:	854e                	mv	a0,s3
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	d1e080e7          	jalr	-738(ra) # 80001ba2 <freeproc>
    release(&np->lock);
    80001e8c:	854e                	mv	a0,s3
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	e08080e7          	jalr	-504(ra) # 80000c96 <release>
    return -1;
    80001e96:	5a7d                	li	s4,-1
    80001e98:	a069                	j	80001f22 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	330080e7          	jalr	816(ra) # 800061ca <filedup>
    80001ea2:	009987b3          	add	a5,s3,s1
    80001ea6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001ea8:	04a1                	addi	s1,s1,8
    80001eaa:	01448763          	beq	s1,s4,80001eb8 <fork+0xbc>
    if(p->ofile[i])
    80001eae:	009907b3          	add	a5,s2,s1
    80001eb2:	6388                	ld	a0,0(a5)
    80001eb4:	f17d                	bnez	a0,80001e9a <fork+0x9e>
    80001eb6:	bfcd                	j	80001ea8 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001eb8:	15893503          	ld	a0,344(s2)
    80001ebc:	00003097          	auipc	ra,0x3
    80001ec0:	484080e7          	jalr	1156(ra) # 80005340 <idup>
    80001ec4:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ec8:	4641                	li	a2,16
    80001eca:	16090593          	addi	a1,s2,352
    80001ece:	16098513          	addi	a0,s3,352
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	f5e080e7          	jalr	-162(ra) # 80000e30 <safestrcpy>
  pid = np->pid;
    80001eda:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001ede:	854e                	mv	a0,s3
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	db6080e7          	jalr	-586(ra) # 80000c96 <release>
  acquire(&wait_lock);
    80001ee8:	00010497          	auipc	s1,0x10
    80001eec:	41048493          	addi	s1,s1,1040 # 800122f8 <wait_lock>
    80001ef0:	8526                	mv	a0,s1
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	cf0080e7          	jalr	-784(ra) # 80000be2 <acquire>
  np->parent = p;
    80001efa:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001efe:	8526                	mv	a0,s1
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	d96080e7          	jalr	-618(ra) # 80000c96 <release>
  acquire(&np->lock);
    80001f08:	854e                	mv	a0,s3
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	cd8080e7          	jalr	-808(ra) # 80000be2 <acquire>
  np->state = RUNNABLE;
    80001f12:	478d                	li	a5,3
    80001f14:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f18:	854e                	mv	a0,s3
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	d7c080e7          	jalr	-644(ra) # 80000c96 <release>
}
    80001f22:	8552                	mv	a0,s4
    80001f24:	70a2                	ld	ra,40(sp)
    80001f26:	7402                	ld	s0,32(sp)
    80001f28:	64e2                	ld	s1,24(sp)
    80001f2a:	6942                	ld	s2,16(sp)
    80001f2c:	69a2                	ld	s3,8(sp)
    80001f2e:	6a02                	ld	s4,0(sp)
    80001f30:	6145                	addi	sp,sp,48
    80001f32:	8082                	ret
    return -1;
    80001f34:	5a7d                	li	s4,-1
    80001f36:	b7f5                	j	80001f22 <fork+0x126>

0000000080001f38 <forkf>:
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	e052                	sd	s4,0(sp)
    80001f46:	1800                	addi	s0,sp,48
    80001f48:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f4a:	00000097          	auipc	ra,0x0
    80001f4e:	a6e080e7          	jalr	-1426(ra) # 800019b8 <myproc>
    80001f52:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	ca6080e7          	jalr	-858(ra) # 80001bfa <allocproc>
    80001f5c:	12050063          	beqz	a0,8000207c <forkf+0x144>
    80001f60:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001f62:	05093603          	ld	a2,80(s2)
    80001f66:	6d2c                	ld	a1,88(a0)
    80001f68:	05893503          	ld	a0,88(s2)
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	60a080e7          	jalr	1546(ra) # 80001576 <uvmcopy>
    80001f74:	04054b63          	bltz	a0,80001fca <forkf+0x92>
  np->sz = p->sz;
    80001f78:	05093783          	ld	a5,80(s2)
    80001f7c:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001f80:	06093683          	ld	a3,96(s2)
    80001f84:	87b6                	mv	a5,a3
    80001f86:	0609b703          	ld	a4,96(s3)
    80001f8a:	12068693          	addi	a3,a3,288
    80001f8e:	0007b883          	ld	a7,0(a5)
    80001f92:	0087b803          	ld	a6,8(a5)
    80001f96:	6b8c                	ld	a1,16(a5)
    80001f98:	6f90                	ld	a2,24(a5)
    80001f9a:	01173023          	sd	a7,0(a4)
    80001f9e:	01073423          	sd	a6,8(a4)
    80001fa2:	eb0c                	sd	a1,16(a4)
    80001fa4:	ef10                	sd	a2,24(a4)
    80001fa6:	02078793          	addi	a5,a5,32
    80001faa:	02070713          	addi	a4,a4,32
    80001fae:	fed790e3          	bne	a5,a3,80001f8e <forkf+0x56>
  np->trapframe->a0 = 0;
    80001fb2:	0609b783          	ld	a5,96(s3)
    80001fb6:	0607b823          	sd	zero,112(a5)
  np->trapframe->epc = faddr;
    80001fba:	0609b783          	ld	a5,96(s3)
    80001fbe:	ef84                	sd	s1,24(a5)
    80001fc0:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001fc4:	15800a13          	li	s4,344
    80001fc8:	a03d                	j	80001ff6 <forkf+0xbe>
    freeproc(np);
    80001fca:	854e                	mv	a0,s3
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	bd6080e7          	jalr	-1066(ra) # 80001ba2 <freeproc>
    release(&np->lock);
    80001fd4:	854e                	mv	a0,s3
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	cc0080e7          	jalr	-832(ra) # 80000c96 <release>
    return -1;
    80001fde:	5a7d                	li	s4,-1
    80001fe0:	a069                	j	8000206a <forkf+0x132>
      np->ofile[i] = filedup(p->ofile[i]);
    80001fe2:	00004097          	auipc	ra,0x4
    80001fe6:	1e8080e7          	jalr	488(ra) # 800061ca <filedup>
    80001fea:	009987b3          	add	a5,s3,s1
    80001fee:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001ff0:	04a1                	addi	s1,s1,8
    80001ff2:	01448763          	beq	s1,s4,80002000 <forkf+0xc8>
    if(p->ofile[i])
    80001ff6:	009907b3          	add	a5,s2,s1
    80001ffa:	6388                	ld	a0,0(a5)
    80001ffc:	f17d                	bnez	a0,80001fe2 <forkf+0xaa>
    80001ffe:	bfcd                	j	80001ff0 <forkf+0xb8>
  np->cwd = idup(p->cwd);
    80002000:	15893503          	ld	a0,344(s2)
    80002004:	00003097          	auipc	ra,0x3
    80002008:	33c080e7          	jalr	828(ra) # 80005340 <idup>
    8000200c:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002010:	4641                	li	a2,16
    80002012:	16090593          	addi	a1,s2,352
    80002016:	16098513          	addi	a0,s3,352
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	e16080e7          	jalr	-490(ra) # 80000e30 <safestrcpy>
  pid = np->pid;
    80002022:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80002026:	854e                	mv	a0,s3
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	c6e080e7          	jalr	-914(ra) # 80000c96 <release>
  acquire(&wait_lock);
    80002030:	00010497          	auipc	s1,0x10
    80002034:	2c848493          	addi	s1,s1,712 # 800122f8 <wait_lock>
    80002038:	8526                	mv	a0,s1
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	ba8080e7          	jalr	-1112(ra) # 80000be2 <acquire>
  np->parent = p;
    80002042:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80002046:	8526                	mv	a0,s1
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	c4e080e7          	jalr	-946(ra) # 80000c96 <release>
  acquire(&np->lock);
    80002050:	854e                	mv	a0,s3
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	b90080e7          	jalr	-1136(ra) # 80000be2 <acquire>
  np->state = RUNNABLE;
    8000205a:	478d                	li	a5,3
    8000205c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002060:	854e                	mv	a0,s3
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	c34080e7          	jalr	-972(ra) # 80000c96 <release>
}
    8000206a:	8552                	mv	a0,s4
    8000206c:	70a2                	ld	ra,40(sp)
    8000206e:	7402                	ld	s0,32(sp)
    80002070:	64e2                	ld	s1,24(sp)
    80002072:	6942                	ld	s2,16(sp)
    80002074:	69a2                	ld	s3,8(sp)
    80002076:	6a02                	ld	s4,0(sp)
    80002078:	6145                	addi	sp,sp,48
    8000207a:	8082                	ret
    return -1;
    8000207c:	5a7d                	li	s4,-1
    8000207e:	b7f5                	j	8000206a <forkf+0x132>

0000000080002080 <forkp>:
{
    80002080:	7139                	addi	sp,sp,-64
    80002082:	fc06                	sd	ra,56(sp)
    80002084:	f822                	sd	s0,48(sp)
    80002086:	f426                	sd	s1,40(sp)
    80002088:	f04a                	sd	s2,32(sp)
    8000208a:	ec4e                	sd	s3,24(sp)
    8000208c:	e852                	sd	s4,16(sp)
    8000208e:	e456                	sd	s5,8(sp)
    80002090:	0080                	addi	s0,sp,64
    80002092:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80002094:	00000097          	auipc	ra,0x0
    80002098:	924080e7          	jalr	-1756(ra) # 800019b8 <myproc>
    8000209c:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	b5c080e7          	jalr	-1188(ra) # 80001bfa <allocproc>
    800020a6:	14050763          	beqz	a0,800021f4 <forkp+0x174>
    800020aa:	892a                	mv	s2,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800020ac:	0509b603          	ld	a2,80(s3)
    800020b0:	6d2c                	ld	a1,88(a0)
    800020b2:	0589b503          	ld	a0,88(s3)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	4c0080e7          	jalr	1216(ra) # 80001576 <uvmcopy>
    800020be:	04054663          	bltz	a0,8000210a <forkp+0x8a>
  np->sz = p->sz;
    800020c2:	0509b783          	ld	a5,80(s3)
    800020c6:	04f93823          	sd	a5,80(s2)
  *(np->trapframe) = *(p->trapframe);
    800020ca:	0609b683          	ld	a3,96(s3)
    800020ce:	87b6                	mv	a5,a3
    800020d0:	06093703          	ld	a4,96(s2)
    800020d4:	12068693          	addi	a3,a3,288
    800020d8:	0007b803          	ld	a6,0(a5)
    800020dc:	6788                	ld	a0,8(a5)
    800020de:	6b8c                	ld	a1,16(a5)
    800020e0:	6f90                	ld	a2,24(a5)
    800020e2:	01073023          	sd	a6,0(a4)
    800020e6:	e708                	sd	a0,8(a4)
    800020e8:	eb0c                	sd	a1,16(a4)
    800020ea:	ef10                	sd	a2,24(a4)
    800020ec:	02078793          	addi	a5,a5,32
    800020f0:	02070713          	addi	a4,a4,32
    800020f4:	fed792e3          	bne	a5,a3,800020d8 <forkp+0x58>
  np->trapframe->a0 = 0;
    800020f8:	06093783          	ld	a5,96(s2)
    800020fc:	0607b823          	sd	zero,112(a5)
    80002100:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80002104:	15800a13          	li	s4,344
    80002108:	a03d                	j	80002136 <forkp+0xb6>
    freeproc(np);
    8000210a:	854a                	mv	a0,s2
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	a96080e7          	jalr	-1386(ra) # 80001ba2 <freeproc>
    release(&np->lock);
    80002114:	854a                	mv	a0,s2
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	b80080e7          	jalr	-1152(ra) # 80000c96 <release>
    return -1;
    8000211e:	5a7d                	li	s4,-1
    80002120:	a0c1                	j	800021e0 <forkp+0x160>
      np->ofile[i] = filedup(p->ofile[i]);
    80002122:	00004097          	auipc	ra,0x4
    80002126:	0a8080e7          	jalr	168(ra) # 800061ca <filedup>
    8000212a:	009907b3          	add	a5,s2,s1
    8000212e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002130:	04a1                	addi	s1,s1,8
    80002132:	01448763          	beq	s1,s4,80002140 <forkp+0xc0>
    if(p->ofile[i])
    80002136:	009987b3          	add	a5,s3,s1
    8000213a:	6388                	ld	a0,0(a5)
    8000213c:	f17d                	bnez	a0,80002122 <forkp+0xa2>
    8000213e:	bfcd                	j	80002130 <forkp+0xb0>
  np->cwd = idup(p->cwd);
    80002140:	1589b503          	ld	a0,344(s3)
    80002144:	00003097          	auipc	ra,0x3
    80002148:	1fc080e7          	jalr	508(ra) # 80005340 <idup>
    8000214c:	14a93c23          	sd	a0,344(s2)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002150:	4641                	li	a2,16
    80002152:	16098593          	addi	a1,s3,352
    80002156:	16090513          	addi	a0,s2,352
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	cd6080e7          	jalr	-810(ra) # 80000e30 <safestrcpy>
  pid = np->pid;
    80002162:	03092a03          	lw	s4,48(s2)
  np->base_priority = priority;
    80002166:	03592a23          	sw	s5,52(s2)
  np->is_batchproc = 1;
    8000216a:	4785                	li	a5,1
    8000216c:	02f92e23          	sw	a5,60(s2)
  np->nextburst_estimate = 0;
    80002170:	18092423          	sw	zero,392(s2)
  np->waittime = 0;
    80002174:	16092e23          	sw	zero,380(s2)
  release(&np->lock);
    80002178:	854a                	mv	a0,s2
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	b1c080e7          	jalr	-1252(ra) # 80000c96 <release>
  batchsize++;
    80002182:	00008717          	auipc	a4,0x8
    80002186:	eda70713          	addi	a4,a4,-294 # 8000a05c <batchsize>
    8000218a:	431c                	lw	a5,0(a4)
    8000218c:	2785                	addiw	a5,a5,1
    8000218e:	c31c                	sw	a5,0(a4)
  batchsize2++;
    80002190:	00008717          	auipc	a4,0x8
    80002194:	ec870713          	addi	a4,a4,-312 # 8000a058 <batchsize2>
    80002198:	431c                	lw	a5,0(a4)
    8000219a:	2785                	addiw	a5,a5,1
    8000219c:	c31c                	sw	a5,0(a4)
  acquire(&wait_lock);
    8000219e:	00010497          	auipc	s1,0x10
    800021a2:	15a48493          	addi	s1,s1,346 # 800122f8 <wait_lock>
    800021a6:	8526                	mv	a0,s1
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	a3a080e7          	jalr	-1478(ra) # 80000be2 <acquire>
  np->parent = p;
    800021b0:	05393023          	sd	s3,64(s2)
  release(&wait_lock);
    800021b4:	8526                	mv	a0,s1
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	ae0080e7          	jalr	-1312(ra) # 80000c96 <release>
  acquire(&np->lock);
    800021be:	854a                	mv	a0,s2
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	a22080e7          	jalr	-1502(ra) # 80000be2 <acquire>
  np->state = RUNNABLE;
    800021c8:	478d                	li	a5,3
    800021ca:	00f92c23          	sw	a5,24(s2)
  np->waitstart = np->ctime;
    800021ce:	17092783          	lw	a5,368(s2)
    800021d2:	18f92023          	sw	a5,384(s2)
  release(&np->lock);
    800021d6:	854a                	mv	a0,s2
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	abe080e7          	jalr	-1346(ra) # 80000c96 <release>
}
    800021e0:	8552                	mv	a0,s4
    800021e2:	70e2                	ld	ra,56(sp)
    800021e4:	7442                	ld	s0,48(sp)
    800021e6:	74a2                	ld	s1,40(sp)
    800021e8:	7902                	ld	s2,32(sp)
    800021ea:	69e2                	ld	s3,24(sp)
    800021ec:	6a42                	ld	s4,16(sp)
    800021ee:	6aa2                	ld	s5,8(sp)
    800021f0:	6121                	addi	sp,sp,64
    800021f2:	8082                	ret
    return -1;
    800021f4:	5a7d                	li	s4,-1
    800021f6:	b7ed                	j	800021e0 <forkp+0x160>

00000000800021f8 <scheduler>:
{
    800021f8:	711d                	addi	sp,sp,-96
    800021fa:	ec86                	sd	ra,88(sp)
    800021fc:	e8a2                	sd	s0,80(sp)
    800021fe:	e4a6                	sd	s1,72(sp)
    80002200:	e0ca                	sd	s2,64(sp)
    80002202:	fc4e                	sd	s3,56(sp)
    80002204:	f852                	sd	s4,48(sp)
    80002206:	f456                	sd	s5,40(sp)
    80002208:	f05a                	sd	s6,32(sp)
    8000220a:	ec5e                	sd	s7,24(sp)
    8000220c:	e862                	sd	s8,16(sp)
    8000220e:	e466                	sd	s9,8(sp)
    80002210:	e06a                	sd	s10,0(sp)
    80002212:	1080                	addi	s0,sp,96
    80002214:	8792                	mv	a5,tp
  int id = r_tp();
    80002216:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002218:	00779a93          	slli	s5,a5,0x7
    8000221c:	00010717          	auipc	a4,0x10
    80002220:	0c470713          	addi	a4,a4,196 # 800122e0 <pid_lock>
    80002224:	9756                	add	a4,a4,s5
    80002226:	02073823          	sd	zero,48(a4)
            swtch(&c->context, &p->context);
    8000222a:	00010717          	auipc	a4,0x10
    8000222e:	0ee70713          	addi	a4,a4,238 # 80012318 <cpus+0x8>
    80002232:	9aba                	add	s5,s5,a4
          xticks = ticks;
    80002234:	00008997          	auipc	s3,0x8
    80002238:	e4898993          	addi	s3,s3,-440 # 8000a07c <ticks>
            c->proc = p;
    8000223c:	079e                	slli	a5,a5,0x7
    8000223e:	00010a17          	auipc	s4,0x10
    80002242:	0a2a0a13          	addi	s4,s4,162 # 800122e0 <pid_lock>
    80002246:	9a3e                	add	s4,s4,a5
       for(p = proc; p < &proc[NPROC]; p++) {
    80002248:	00018917          	auipc	s2,0x18
    8000224c:	16890913          	addi	s2,s2,360 # 8001a3b0 <tickslock>
    80002250:	aca9                	j	800024aa <scheduler+0x2b2>
       acquire(&tickslock);
    80002252:	00018517          	auipc	a0,0x18
    80002256:	15e50513          	addi	a0,a0,350 # 8001a3b0 <tickslock>
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	988080e7          	jalr	-1656(ra) # 80000be2 <acquire>
       xticks = ticks;
    80002262:	0009ad03          	lw	s10,0(s3)
       release(&tickslock);
    80002266:	00018517          	auipc	a0,0x18
    8000226a:	14a50513          	addi	a0,a0,330 # 8001a3b0 <tickslock>
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	a28080e7          	jalr	-1496(ra) # 80000c96 <release>
       min_burst = 0x7FFFFFFF;
    80002276:	80000c37          	lui	s8,0x80000
    8000227a:	fffc4c13          	not	s8,s8
       q = 0;
    8000227e:	4c81                	li	s9,0
       for(p = proc; p < &proc[NPROC]; p++) {
    80002280:	00012497          	auipc	s1,0x12
    80002284:	d3048493          	addi	s1,s1,-720 # 80013fb0 <proc>
	  if(p->state == RUNNABLE) {
    80002288:	4b8d                	li	s7,3
    8000228a:	a0ad                	j	800022f4 <scheduler+0xfc>
                if (q) release(&q->lock);
    8000228c:	000c8763          	beqz	s9,8000229a <scheduler+0xa2>
    80002290:	8566                	mv	a0,s9
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	a04080e7          	jalr	-1532(ra) # 80000c96 <release>
          q->state = RUNNING;
    8000229a:	4791                	li	a5,4
    8000229c:	cc9c                	sw	a5,24(s1)
          q->waittime += (xticks - q->waitstart);
    8000229e:	17c4a783          	lw	a5,380(s1)
    800022a2:	01a787bb          	addw	a5,a5,s10
    800022a6:	1804a703          	lw	a4,384(s1)
    800022aa:	9f99                	subw	a5,a5,a4
    800022ac:	16f4ae23          	sw	a5,380(s1)
          q->burst_start = xticks;
    800022b0:	19a4a223          	sw	s10,388(s1)
          c->proc = q;
    800022b4:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &q->context);
    800022b8:	06848593          	addi	a1,s1,104
    800022bc:	8556                	mv	a0,s5
    800022be:	00002097          	auipc	ra,0x2
    800022c2:	c64080e7          	jalr	-924(ra) # 80003f22 <swtch>
          c->proc = 0;
    800022c6:	020a3823          	sd	zero,48(s4)
	  release(&q->lock);
    800022ca:	8526                	mv	a0,s1
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	9ca080e7          	jalr	-1590(ra) # 80000c96 <release>
    800022d4:	aad9                	j	800024aa <scheduler+0x2b2>
             else release(&p->lock);
    800022d6:	8526                	mv	a0,s1
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	9be080e7          	jalr	-1602(ra) # 80000c96 <release>
    800022e0:	a031                	j	800022ec <scheduler+0xf4>
	  else release(&p->lock);
    800022e2:	8526                	mv	a0,s1
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	9b2080e7          	jalr	-1614(ra) # 80000c96 <release>
       for(p = proc; p < &proc[NPROC]; p++) {
    800022ec:	19048493          	addi	s1,s1,400
    800022f0:	03248d63          	beq	s1,s2,8000232a <scheduler+0x132>
          acquire(&p->lock);
    800022f4:	8526                	mv	a0,s1
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	8ec080e7          	jalr	-1812(ra) # 80000be2 <acquire>
	  if(p->state == RUNNABLE) {
    800022fe:	4c9c                	lw	a5,24(s1)
    80002300:	ff7791e3          	bne	a5,s7,800022e2 <scheduler+0xea>
	     if (!p->is_batchproc) {
    80002304:	5cdc                	lw	a5,60(s1)
    80002306:	d3d9                	beqz	a5,8000228c <scheduler+0x94>
             else if (p->nextburst_estimate < min_burst) {
    80002308:	1884ab03          	lw	s6,392(s1)
    8000230c:	fd8b55e3          	bge	s6,s8,800022d6 <scheduler+0xde>
		if (q) release(&q->lock);
    80002310:	000c8a63          	beqz	s9,80002324 <scheduler+0x12c>
    80002314:	8566                	mv	a0,s9
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	980080e7          	jalr	-1664(ra) # 80000c96 <release>
	        min_burst = p->nextburst_estimate;
    8000231e:	8c5a                	mv	s8,s6
		if (q) release(&q->lock);
    80002320:	8ca6                	mv	s9,s1
    80002322:	b7e9                	j	800022ec <scheduler+0xf4>
	        min_burst = p->nextburst_estimate;
    80002324:	8c5a                	mv	s8,s6
    80002326:	8ca6                	mv	s9,s1
    80002328:	b7d1                	j	800022ec <scheduler+0xf4>
       if (q) {
    8000232a:	180c8063          	beqz	s9,800024aa <scheduler+0x2b2>
    8000232e:	84e6                	mv	s1,s9
    80002330:	b7ad                	j	8000229a <scheduler+0xa2>
       acquire(&tickslock);
    80002332:	00018517          	auipc	a0,0x18
    80002336:	07e50513          	addi	a0,a0,126 # 8001a3b0 <tickslock>
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	8a8080e7          	jalr	-1880(ra) # 80000be2 <acquire>
       xticks = ticks;
    80002342:	0009ab03          	lw	s6,0(s3)
       release(&tickslock);
    80002346:	00018517          	auipc	a0,0x18
    8000234a:	06a50513          	addi	a0,a0,106 # 8001a3b0 <tickslock>
    8000234e:	fffff097          	auipc	ra,0xfffff
    80002352:	948080e7          	jalr	-1720(ra) # 80000c96 <release>
       for(p = proc; p < &proc[NPROC]; p++) {
    80002356:	00012497          	auipc	s1,0x12
    8000235a:	c5a48493          	addi	s1,s1,-934 # 80013fb0 <proc>
	  if(p->state == RUNNABLE) {
    8000235e:	4b8d                	li	s7,3
    80002360:	a811                	j	80002374 <scheduler+0x17c>
	  release(&p->lock);
    80002362:	8526                	mv	a0,s1
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	932080e7          	jalr	-1742(ra) # 80000c96 <release>
       for(p = proc; p < &proc[NPROC]; p++) {
    8000236c:	19048493          	addi	s1,s1,400
    80002370:	03248e63          	beq	s1,s2,800023ac <scheduler+0x1b4>
          acquire(&p->lock);
    80002374:	8526                	mv	a0,s1
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	86c080e7          	jalr	-1940(ra) # 80000be2 <acquire>
	  if(p->state == RUNNABLE) {
    8000237e:	4c9c                	lw	a5,24(s1)
    80002380:	ff7791e3          	bne	a5,s7,80002362 <scheduler+0x16a>
	     p->cpu_usage = p->cpu_usage/2;
    80002384:	18c4a683          	lw	a3,396(s1)
    80002388:	01f6d71b          	srliw	a4,a3,0x1f
    8000238c:	9f35                	addw	a4,a4,a3
    8000238e:	4017571b          	sraiw	a4,a4,0x1
    80002392:	18e4a623          	sw	a4,396(s1)
	     p->priority = p->base_priority + (p->cpu_usage/2);
    80002396:	41f6d79b          	sraiw	a5,a3,0x1f
    8000239a:	01e7d79b          	srliw	a5,a5,0x1e
    8000239e:	9fb5                	addw	a5,a5,a3
    800023a0:	4027d79b          	sraiw	a5,a5,0x2
    800023a4:	58d8                	lw	a4,52(s1)
    800023a6:	9fb9                	addw	a5,a5,a4
    800023a8:	dc9c                	sw	a5,56(s1)
    800023aa:	bf65                	j	80002362 <scheduler+0x16a>
       min_prio = 0x7FFFFFFF;
    800023ac:	80000cb7          	lui	s9,0x80000
    800023b0:	fffccc93          	not	s9,s9
       q = 0;
    800023b4:	4d01                	li	s10,0
       for(p = proc; p < &proc[NPROC]; p++) {
    800023b6:	00012497          	auipc	s1,0x12
    800023ba:	bfa48493          	addi	s1,s1,-1030 # 80013fb0 <proc>
          if(p->state == RUNNABLE) {
    800023be:	4c0d                	li	s8,3
    800023c0:	a0ad                	j	8000242a <scheduler+0x232>
                if (q) release(&q->lock);
    800023c2:	000d0763          	beqz	s10,800023d0 <scheduler+0x1d8>
    800023c6:	856a                	mv	a0,s10
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	8ce080e7          	jalr	-1842(ra) # 80000c96 <release>
          q->state = RUNNING;
    800023d0:	4791                	li	a5,4
    800023d2:	cc9c                	sw	a5,24(s1)
          q->waittime += (xticks - q->waitstart);
    800023d4:	17c4a783          	lw	a5,380(s1)
    800023d8:	016787bb          	addw	a5,a5,s6
    800023dc:	1804a703          	lw	a4,384(s1)
    800023e0:	9f99                	subw	a5,a5,a4
    800023e2:	16f4ae23          	sw	a5,380(s1)
          q->burst_start = xticks;
    800023e6:	1964a223          	sw	s6,388(s1)
          c->proc = q;
    800023ea:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &q->context);
    800023ee:	06848593          	addi	a1,s1,104
    800023f2:	8556                	mv	a0,s5
    800023f4:	00002097          	auipc	ra,0x2
    800023f8:	b2e080e7          	jalr	-1234(ra) # 80003f22 <swtch>
          c->proc = 0;
    800023fc:	020a3823          	sd	zero,48(s4)
          release(&q->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	894080e7          	jalr	-1900(ra) # 80000c96 <release>
    8000240a:	a045                	j	800024aa <scheduler+0x2b2>
             else release(&p->lock);
    8000240c:	8526                	mv	a0,s1
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	888080e7          	jalr	-1912(ra) # 80000c96 <release>
    80002416:	a031                	j	80002422 <scheduler+0x22a>
          else release(&p->lock);
    80002418:	8526                	mv	a0,s1
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	87c080e7          	jalr	-1924(ra) # 80000c96 <release>
       for(p = proc; p < &proc[NPROC]; p++) {
    80002422:	19048493          	addi	s1,s1,400
    80002426:	03248d63          	beq	s1,s2,80002460 <scheduler+0x268>
          acquire(&p->lock);
    8000242a:	8526                	mv	a0,s1
    8000242c:	ffffe097          	auipc	ra,0xffffe
    80002430:	7b6080e7          	jalr	1974(ra) # 80000be2 <acquire>
          if(p->state == RUNNABLE) {
    80002434:	4c9c                	lw	a5,24(s1)
    80002436:	ff8791e3          	bne	a5,s8,80002418 <scheduler+0x220>
             if (!p->is_batchproc) {
    8000243a:	5cdc                	lw	a5,60(s1)
    8000243c:	d3d9                	beqz	a5,800023c2 <scheduler+0x1ca>
             else if (p->priority < min_prio) {
    8000243e:	0384ab83          	lw	s7,56(s1)
    80002442:	fd9bd5e3          	bge	s7,s9,8000240c <scheduler+0x214>
                if (q) release(&q->lock);
    80002446:	000d0a63          	beqz	s10,8000245a <scheduler+0x262>
    8000244a:	856a                	mv	a0,s10
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	84a080e7          	jalr	-1974(ra) # 80000c96 <release>
                min_prio = p->priority;
    80002454:	8cde                	mv	s9,s7
                if (q) release(&q->lock);
    80002456:	8d26                	mv	s10,s1
    80002458:	b7e9                	j	80002422 <scheduler+0x22a>
                min_prio = p->priority;
    8000245a:	8cde                	mv	s9,s7
    8000245c:	8d26                	mv	s10,s1
    8000245e:	b7d1                	j	80002422 <scheduler+0x22a>
       if (q) {
    80002460:	040d0563          	beqz	s10,800024aa <scheduler+0x2b2>
    80002464:	84ea                	mv	s1,s10
    80002466:	b7ad                	j	800023d0 <scheduler+0x1d8>
          acquire(&tickslock);
    80002468:	855a                	mv	a0,s6
    8000246a:	ffffe097          	auipc	ra,0xffffe
    8000246e:	778080e7          	jalr	1912(ra) # 80000be2 <acquire>
          xticks = ticks;
    80002472:	0009ac83          	lw	s9,0(s3)
          release(&tickslock);
    80002476:	855a                	mv	a0,s6
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	81e080e7          	jalr	-2018(ra) # 80000c96 <release>
          acquire(&p->lock);
    80002480:	8526                	mv	a0,s1
    80002482:	ffffe097          	auipc	ra,0xffffe
    80002486:	760080e7          	jalr	1888(ra) # 80000be2 <acquire>
          if(p->state == RUNNABLE) {
    8000248a:	4c9c                	lw	a5,24(s1)
    8000248c:	05878d63          	beq	a5,s8,800024e6 <scheduler+0x2ee>
          release(&p->lock);
    80002490:	8526                	mv	a0,s1
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	804080e7          	jalr	-2044(ra) # 80000c96 <release>
       for(p = proc; p < &proc[NPROC]; p++) {
    8000249a:	19048493          	addi	s1,s1,400
    8000249e:	01248663          	beq	s1,s2,800024aa <scheduler+0x2b2>
          if ((sched_policy != SCHED_NPREEMPT_FCFS) && (sched_policy != SCHED_PREEMPT_RR)) break;
    800024a2:	000ba783          	lw	a5,0(s7) # fffffffffffff000 <end+0xffffffff7ffd6000>
    800024a6:	9bf5                	andi	a5,a5,-3
    800024a8:	d3e1                	beqz	a5,80002468 <scheduler+0x270>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024b2:	10079073          	csrw	sstatus,a5
    if (sched_policy == SCHED_NPREEMPT_SJF) {
    800024b6:	00008797          	auipc	a5,0x8
    800024ba:	bc27a783          	lw	a5,-1086(a5) # 8000a078 <sched_policy>
    800024be:	4705                	li	a4,1
    800024c0:	d8e789e3          	beq	a5,a4,80002252 <scheduler+0x5a>
    else if (sched_policy == SCHED_PREEMPT_UNIX) {
    800024c4:	470d                	li	a4,3
       for(p = proc; p < &proc[NPROC]; p++) {
    800024c6:	00012497          	auipc	s1,0x12
    800024ca:	aea48493          	addi	s1,s1,-1302 # 80013fb0 <proc>
    else if (sched_policy == SCHED_PREEMPT_UNIX) {
    800024ce:	e6e782e3          	beq	a5,a4,80002332 <scheduler+0x13a>
          if ((sched_policy != SCHED_NPREEMPT_FCFS) && (sched_policy != SCHED_PREEMPT_RR)) break;
    800024d2:	00008b97          	auipc	s7,0x8
    800024d6:	ba6b8b93          	addi	s7,s7,-1114 # 8000a078 <sched_policy>
          acquire(&tickslock);
    800024da:	00018b17          	auipc	s6,0x18
    800024de:	ed6b0b13          	addi	s6,s6,-298 # 8001a3b0 <tickslock>
          if(p->state == RUNNABLE) {
    800024e2:	4c0d                	li	s8,3
    800024e4:	bf7d                	j	800024a2 <scheduler+0x2aa>
            p->state = RUNNING;
    800024e6:	4791                	li	a5,4
    800024e8:	cc9c                	sw	a5,24(s1)
	    p->waittime += (xticks - p->waitstart);
    800024ea:	17c4a783          	lw	a5,380(s1)
    800024ee:	019787bb          	addw	a5,a5,s9
    800024f2:	1804a703          	lw	a4,384(s1)
    800024f6:	9f99                	subw	a5,a5,a4
    800024f8:	16f4ae23          	sw	a5,380(s1)
	    p->burst_start = xticks;
    800024fc:	1994a223          	sw	s9,388(s1)
            c->proc = p;
    80002500:	029a3823          	sd	s1,48(s4)
            swtch(&c->context, &p->context);
    80002504:	06848593          	addi	a1,s1,104
    80002508:	8556                	mv	a0,s5
    8000250a:	00002097          	auipc	ra,0x2
    8000250e:	a18080e7          	jalr	-1512(ra) # 80003f22 <swtch>
            c->proc = 0;
    80002512:	020a3823          	sd	zero,48(s4)
    80002516:	bfad                	j	80002490 <scheduler+0x298>

0000000080002518 <sched>:
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	492080e7          	jalr	1170(ra) # 800019b8 <myproc>
    8000252e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	638080e7          	jalr	1592(ra) # 80000b68 <holding>
    80002538:	c93d                	beqz	a0,800025ae <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000253a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000253c:	2781                	sext.w	a5,a5
    8000253e:	079e                	slli	a5,a5,0x7
    80002540:	00010717          	auipc	a4,0x10
    80002544:	da070713          	addi	a4,a4,-608 # 800122e0 <pid_lock>
    80002548:	97ba                	add	a5,a5,a4
    8000254a:	0a87a703          	lw	a4,168(a5)
    8000254e:	4785                	li	a5,1
    80002550:	06f71763          	bne	a4,a5,800025be <sched+0xa6>
  if(p->state == RUNNING)
    80002554:	4c98                	lw	a4,24(s1)
    80002556:	4791                	li	a5,4
    80002558:	06f70b63          	beq	a4,a5,800025ce <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000255c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002560:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002562:	efb5                	bnez	a5,800025de <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002564:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002566:	00010917          	auipc	s2,0x10
    8000256a:	d7a90913          	addi	s2,s2,-646 # 800122e0 <pid_lock>
    8000256e:	2781                	sext.w	a5,a5
    80002570:	079e                	slli	a5,a5,0x7
    80002572:	97ca                	add	a5,a5,s2
    80002574:	0ac7a983          	lw	s3,172(a5)
    80002578:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000257a:	2781                	sext.w	a5,a5
    8000257c:	079e                	slli	a5,a5,0x7
    8000257e:	00010597          	auipc	a1,0x10
    80002582:	d9a58593          	addi	a1,a1,-614 # 80012318 <cpus+0x8>
    80002586:	95be                	add	a1,a1,a5
    80002588:	06848513          	addi	a0,s1,104
    8000258c:	00002097          	auipc	ra,0x2
    80002590:	996080e7          	jalr	-1642(ra) # 80003f22 <swtch>
    80002594:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002596:	2781                	sext.w	a5,a5
    80002598:	079e                	slli	a5,a5,0x7
    8000259a:	97ca                	add	a5,a5,s2
    8000259c:	0b37a623          	sw	s3,172(a5)
}
    800025a0:	70a2                	ld	ra,40(sp)
    800025a2:	7402                	ld	s0,32(sp)
    800025a4:	64e2                	ld	s1,24(sp)
    800025a6:	6942                	ld	s2,16(sp)
    800025a8:	69a2                	ld	s3,8(sp)
    800025aa:	6145                	addi	sp,sp,48
    800025ac:	8082                	ret
    panic("sched p->lock");
    800025ae:	00007517          	auipc	a0,0x7
    800025b2:	c6a50513          	addi	a0,a0,-918 # 80009218 <digits+0x1d8>
    800025b6:	ffffe097          	auipc	ra,0xffffe
    800025ba:	f86080e7          	jalr	-122(ra) # 8000053c <panic>
    panic("sched locks");
    800025be:	00007517          	auipc	a0,0x7
    800025c2:	c6a50513          	addi	a0,a0,-918 # 80009228 <digits+0x1e8>
    800025c6:	ffffe097          	auipc	ra,0xffffe
    800025ca:	f76080e7          	jalr	-138(ra) # 8000053c <panic>
    panic("sched running");
    800025ce:	00007517          	auipc	a0,0x7
    800025d2:	c6a50513          	addi	a0,a0,-918 # 80009238 <digits+0x1f8>
    800025d6:	ffffe097          	auipc	ra,0xffffe
    800025da:	f66080e7          	jalr	-154(ra) # 8000053c <panic>
    panic("sched interruptible");
    800025de:	00007517          	auipc	a0,0x7
    800025e2:	c6a50513          	addi	a0,a0,-918 # 80009248 <digits+0x208>
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	f56080e7          	jalr	-170(ra) # 8000053c <panic>

00000000800025ee <yield>:
{
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	e04a                	sd	s2,0(sp)
    800025f8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800025fa:	fffff097          	auipc	ra,0xfffff
    800025fe:	3be080e7          	jalr	958(ra) # 800019b8 <myproc>
    80002602:	84aa                	mv	s1,a0
  acquire(&tickslock);
    80002604:	00018517          	auipc	a0,0x18
    80002608:	dac50513          	addi	a0,a0,-596 # 8001a3b0 <tickslock>
    8000260c:	ffffe097          	auipc	ra,0xffffe
    80002610:	5d6080e7          	jalr	1494(ra) # 80000be2 <acquire>
  xticks = ticks;
    80002614:	00008917          	auipc	s2,0x8
    80002618:	a6892903          	lw	s2,-1432(s2) # 8000a07c <ticks>
  release(&tickslock);
    8000261c:	00018517          	auipc	a0,0x18
    80002620:	d9450513          	addi	a0,a0,-620 # 8001a3b0 <tickslock>
    80002624:	ffffe097          	auipc	ra,0xffffe
    80002628:	672080e7          	jalr	1650(ra) # 80000c96 <release>
  acquire(&p->lock);
    8000262c:	8526                	mv	a0,s1
    8000262e:	ffffe097          	auipc	ra,0xffffe
    80002632:	5b4080e7          	jalr	1460(ra) # 80000be2 <acquire>
  p->state = RUNNABLE;
    80002636:	478d                	li	a5,3
    80002638:	cc9c                	sw	a5,24(s1)
  p->waitstart = xticks;
    8000263a:	1924a023          	sw	s2,384(s1)
  p->cpu_usage += SCHED_PARAM_CPU_USAGE;
    8000263e:	18c4a783          	lw	a5,396(s1)
    80002642:	0c87879b          	addiw	a5,a5,200
    80002646:	18f4a623          	sw	a5,396(s1)
  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
    8000264a:	5cdc                	lw	a5,60(s1)
    8000264c:	c7ed                	beqz	a5,80002736 <yield+0x148>
    8000264e:	1844a683          	lw	a3,388(s1)
    80002652:	0f268263          	beq	a3,s2,80002736 <yield+0x148>
     num_cpubursts++;
    80002656:	00008717          	auipc	a4,0x8
    8000265a:	9ee70713          	addi	a4,a4,-1554 # 8000a044 <num_cpubursts>
    8000265e:	431c                	lw	a5,0(a4)
    80002660:	2785                	addiw	a5,a5,1
    80002662:	c31c                	sw	a5,0(a4)
     cpubursts_tot += (xticks - p->burst_start);
    80002664:	40d9073b          	subw	a4,s2,a3
    80002668:	0007059b          	sext.w	a1,a4
    8000266c:	00008617          	auipc	a2,0x8
    80002670:	9d460613          	addi	a2,a2,-1580 # 8000a040 <cpubursts_tot>
    80002674:	421c                	lw	a5,0(a2)
    80002676:	9fb9                	addw	a5,a5,a4
    80002678:	c21c                	sw	a5,0(a2)
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
    8000267a:	00008797          	auipc	a5,0x8
    8000267e:	9c27a783          	lw	a5,-1598(a5) # 8000a03c <cpubursts_max>
    80002682:	00b7f663          	bgeu	a5,a1,8000268e <yield+0xa0>
    80002686:	00008797          	auipc	a5,0x8
    8000268a:	9ae7ab23          	sw	a4,-1610(a5) # 8000a03c <cpubursts_max>
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
    8000268e:	00007797          	auipc	a5,0x7
    80002692:	55a7a783          	lw	a5,1370(a5) # 80009be8 <cpubursts_min>
    80002696:	00f5f663          	bgeu	a1,a5,800026a2 <yield+0xb4>
    8000269a:	00007797          	auipc	a5,0x7
    8000269e:	54e7a723          	sw	a4,1358(a5) # 80009be8 <cpubursts_min>
     if (p->nextburst_estimate > 0) {
    800026a2:	1884a603          	lw	a2,392(s1)
    800026a6:	02c05763          	blez	a2,800026d4 <yield+0xe6>
        estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    800026aa:	0006079b          	sext.w	a5,a2
    800026ae:	0ab7e363          	bltu	a5,a1,80002754 <yield+0x166>
    800026b2:	9ebd                	addw	a3,a3,a5
    800026b4:	412686bb          	subw	a3,a3,s2
    800026b8:	00008597          	auipc	a1,0x8
    800026bc:	97458593          	addi	a1,a1,-1676 # 8000a02c <estimation_error>
    800026c0:	419c                	lw	a5,0(a1)
    800026c2:	9ebd                	addw	a3,a3,a5
    800026c4:	c194                	sw	a3,0(a1)
	estimation_error_instance++;
    800026c6:	00008697          	auipc	a3,0x8
    800026ca:	96268693          	addi	a3,a3,-1694 # 8000a028 <estimation_error_instance>
    800026ce:	429c                	lw	a5,0(a3)
    800026d0:	2785                	addiw	a5,a5,1
    800026d2:	c29c                	sw	a5,0(a3)
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
    800026d4:	01f6579b          	srliw	a5,a2,0x1f
    800026d8:	9fb1                	addw	a5,a5,a2
    800026da:	4017d79b          	sraiw	a5,a5,0x1
    800026de:	9fb9                	addw	a5,a5,a4
    800026e0:	0017571b          	srliw	a4,a4,0x1
    800026e4:	9f99                	subw	a5,a5,a4
    800026e6:	0007871b          	sext.w	a4,a5
    800026ea:	18f4a423          	sw	a5,392(s1)
     if (p->nextburst_estimate > 0) {
    800026ee:	04e05463          	blez	a4,80002736 <yield+0x148>
        num_cpubursts_est++;
    800026f2:	00008617          	auipc	a2,0x8
    800026f6:	94660613          	addi	a2,a2,-1722 # 8000a038 <num_cpubursts_est>
    800026fa:	4214                	lw	a3,0(a2)
    800026fc:	2685                	addiw	a3,a3,1
    800026fe:	c214                	sw	a3,0(a2)
        cpubursts_est_tot += p->nextburst_estimate;
    80002700:	00008617          	auipc	a2,0x8
    80002704:	93460613          	addi	a2,a2,-1740 # 8000a034 <cpubursts_est_tot>
    80002708:	4214                	lw	a3,0(a2)
    8000270a:	9ebd                	addw	a3,a3,a5
    8000270c:	c214                	sw	a3,0(a2)
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
    8000270e:	00008697          	auipc	a3,0x8
    80002712:	9226a683          	lw	a3,-1758(a3) # 8000a030 <cpubursts_est_max>
    80002716:	00e6d663          	bge	a3,a4,80002722 <yield+0x134>
    8000271a:	00008697          	auipc	a3,0x8
    8000271e:	90f6ab23          	sw	a5,-1770(a3) # 8000a030 <cpubursts_est_max>
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
    80002722:	00007697          	auipc	a3,0x7
    80002726:	4c26a683          	lw	a3,1218(a3) # 80009be4 <cpubursts_est_min>
    8000272a:	00d75663          	bge	a4,a3,80002736 <yield+0x148>
    8000272e:	00007717          	auipc	a4,0x7
    80002732:	4af72b23          	sw	a5,1206(a4) # 80009be4 <cpubursts_est_min>
  sched();
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	de2080e7          	jalr	-542(ra) # 80002518 <sched>
  release(&p->lock);
    8000273e:	8526                	mv	a0,s1
    80002740:	ffffe097          	auipc	ra,0xffffe
    80002744:	556080e7          	jalr	1366(ra) # 80000c96 <release>
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6902                	ld	s2,0(sp)
    80002750:	6105                	addi	sp,sp,32
    80002752:	8082                	ret
        estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    80002754:	40f706bb          	subw	a3,a4,a5
    80002758:	b785                	j	800026b8 <yield+0xca>

000000008000275a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000275a:	7179                	addi	sp,sp,-48
    8000275c:	f406                	sd	ra,40(sp)
    8000275e:	f022                	sd	s0,32(sp)
    80002760:	ec26                	sd	s1,24(sp)
    80002762:	e84a                	sd	s2,16(sp)
    80002764:	e44e                	sd	s3,8(sp)
    80002766:	e052                	sd	s4,0(sp)
    80002768:	1800                	addi	s0,sp,48
    8000276a:	89aa                	mv	s3,a0
    8000276c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000276e:	fffff097          	auipc	ra,0xfffff
    80002772:	24a080e7          	jalr	586(ra) # 800019b8 <myproc>
    80002776:	84aa                	mv	s1,a0
  uint xticks;

  if (!holding(&tickslock)) {
    80002778:	00018517          	auipc	a0,0x18
    8000277c:	c3850513          	addi	a0,a0,-968 # 8001a3b0 <tickslock>
    80002780:	ffffe097          	auipc	ra,0xffffe
    80002784:	3e8080e7          	jalr	1000(ra) # 80000b68 <holding>
    80002788:	14050863          	beqz	a0,800028d8 <sleep+0x17e>
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
    8000278c:	00008a17          	auipc	s4,0x8
    80002790:	8f0a2a03          	lw	s4,-1808(s4) # 8000a07c <ticks>
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002794:	8526                	mv	a0,s1
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	44c080e7          	jalr	1100(ra) # 80000be2 <acquire>
  release(lk);
    8000279e:	854a                	mv	a0,s2
    800027a0:	ffffe097          	auipc	ra,0xffffe
    800027a4:	4f6080e7          	jalr	1270(ra) # 80000c96 <release>

  // Go to sleep.
  p->chan = chan;
    800027a8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800027ac:	4789                	li	a5,2
    800027ae:	cc9c                	sw	a5,24(s1)

  p->cpu_usage += (SCHED_PARAM_CPU_USAGE/2);
    800027b0:	18c4a783          	lw	a5,396(s1)
    800027b4:	0647879b          	addiw	a5,a5,100
    800027b8:	18f4a623          	sw	a5,396(s1)

  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
    800027bc:	5cdc                	lw	a5,60(s1)
    800027be:	c7ed                	beqz	a5,800028a8 <sleep+0x14e>
    800027c0:	1844a683          	lw	a3,388(s1)
    800027c4:	0f468263          	beq	a3,s4,800028a8 <sleep+0x14e>
     num_cpubursts++;
    800027c8:	00008717          	auipc	a4,0x8
    800027cc:	87c70713          	addi	a4,a4,-1924 # 8000a044 <num_cpubursts>
    800027d0:	431c                	lw	a5,0(a4)
    800027d2:	2785                	addiw	a5,a5,1
    800027d4:	c31c                	sw	a5,0(a4)
     cpubursts_tot += (xticks - p->burst_start);
    800027d6:	40da073b          	subw	a4,s4,a3
    800027da:	0007059b          	sext.w	a1,a4
    800027de:	00008617          	auipc	a2,0x8
    800027e2:	86260613          	addi	a2,a2,-1950 # 8000a040 <cpubursts_tot>
    800027e6:	421c                	lw	a5,0(a2)
    800027e8:	9fb9                	addw	a5,a5,a4
    800027ea:	c21c                	sw	a5,0(a2)
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
    800027ec:	00008797          	auipc	a5,0x8
    800027f0:	8507a783          	lw	a5,-1968(a5) # 8000a03c <cpubursts_max>
    800027f4:	00b7f663          	bgeu	a5,a1,80002800 <sleep+0xa6>
    800027f8:	00008797          	auipc	a5,0x8
    800027fc:	84e7a223          	sw	a4,-1980(a5) # 8000a03c <cpubursts_max>
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
    80002800:	00007797          	auipc	a5,0x7
    80002804:	3e87a783          	lw	a5,1000(a5) # 80009be8 <cpubursts_min>
    80002808:	00f5f663          	bgeu	a1,a5,80002814 <sleep+0xba>
    8000280c:	00007797          	auipc	a5,0x7
    80002810:	3ce7ae23          	sw	a4,988(a5) # 80009be8 <cpubursts_min>
     if (p->nextburst_estimate > 0) {
    80002814:	1884a603          	lw	a2,392(s1)
    80002818:	02c05763          	blez	a2,80002846 <sleep+0xec>
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    8000281c:	0006079b          	sext.w	a5,a2
    80002820:	0eb7e163          	bltu	a5,a1,80002902 <sleep+0x1a8>
    80002824:	9ebd                	addw	a3,a3,a5
    80002826:	414686bb          	subw	a3,a3,s4
    8000282a:	00008597          	auipc	a1,0x8
    8000282e:	80258593          	addi	a1,a1,-2046 # 8000a02c <estimation_error>
    80002832:	419c                	lw	a5,0(a1)
    80002834:	9ebd                	addw	a3,a3,a5
    80002836:	c194                	sw	a3,0(a1)
        estimation_error_instance++;
    80002838:	00007697          	auipc	a3,0x7
    8000283c:	7f068693          	addi	a3,a3,2032 # 8000a028 <estimation_error_instance>
    80002840:	429c                	lw	a5,0(a3)
    80002842:	2785                	addiw	a5,a5,1
    80002844:	c29c                	sw	a5,0(a3)
     }
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
    80002846:	01f6579b          	srliw	a5,a2,0x1f
    8000284a:	9fb1                	addw	a5,a5,a2
    8000284c:	4017d79b          	sraiw	a5,a5,0x1
    80002850:	9fb9                	addw	a5,a5,a4
    80002852:	0017571b          	srliw	a4,a4,0x1
    80002856:	9f99                	subw	a5,a5,a4
    80002858:	0007871b          	sext.w	a4,a5
    8000285c:	18f4a423          	sw	a5,392(s1)
     if (p->nextburst_estimate > 0) {
    80002860:	04e05463          	blez	a4,800028a8 <sleep+0x14e>
        num_cpubursts_est++;
    80002864:	00007617          	auipc	a2,0x7
    80002868:	7d460613          	addi	a2,a2,2004 # 8000a038 <num_cpubursts_est>
    8000286c:	4214                	lw	a3,0(a2)
    8000286e:	2685                	addiw	a3,a3,1
    80002870:	c214                	sw	a3,0(a2)
        cpubursts_est_tot += p->nextburst_estimate;
    80002872:	00007617          	auipc	a2,0x7
    80002876:	7c260613          	addi	a2,a2,1986 # 8000a034 <cpubursts_est_tot>
    8000287a:	4214                	lw	a3,0(a2)
    8000287c:	9ebd                	addw	a3,a3,a5
    8000287e:	c214                	sw	a3,0(a2)
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
    80002880:	00007697          	auipc	a3,0x7
    80002884:	7b06a683          	lw	a3,1968(a3) # 8000a030 <cpubursts_est_max>
    80002888:	00e6d663          	bge	a3,a4,80002894 <sleep+0x13a>
    8000288c:	00007697          	auipc	a3,0x7
    80002890:	7af6a223          	sw	a5,1956(a3) # 8000a030 <cpubursts_est_max>
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
    80002894:	00007697          	auipc	a3,0x7
    80002898:	3506a683          	lw	a3,848(a3) # 80009be4 <cpubursts_est_min>
    8000289c:	00d75663          	bge	a4,a3,800028a8 <sleep+0x14e>
    800028a0:	00007717          	auipc	a4,0x7
    800028a4:	34f72223          	sw	a5,836(a4) # 80009be4 <cpubursts_est_min>
     }
  }

  sched();
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	c70080e7          	jalr	-912(ra) # 80002518 <sched>

  // Tidy up.
  p->chan = 0;
    800028b0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800028b4:	8526                	mv	a0,s1
    800028b6:	ffffe097          	auipc	ra,0xffffe
    800028ba:	3e0080e7          	jalr	992(ra) # 80000c96 <release>
  acquire(lk);
    800028be:	854a                	mv	a0,s2
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	322080e7          	jalr	802(ra) # 80000be2 <acquire>
}
    800028c8:	70a2                	ld	ra,40(sp)
    800028ca:	7402                	ld	s0,32(sp)
    800028cc:	64e2                	ld	s1,24(sp)
    800028ce:	6942                	ld	s2,16(sp)
    800028d0:	69a2                	ld	s3,8(sp)
    800028d2:	6a02                	ld	s4,0(sp)
    800028d4:	6145                	addi	sp,sp,48
    800028d6:	8082                	ret
     acquire(&tickslock);
    800028d8:	00018517          	auipc	a0,0x18
    800028dc:	ad850513          	addi	a0,a0,-1320 # 8001a3b0 <tickslock>
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	302080e7          	jalr	770(ra) # 80000be2 <acquire>
     xticks = ticks;
    800028e8:	00007a17          	auipc	s4,0x7
    800028ec:	794a2a03          	lw	s4,1940(s4) # 8000a07c <ticks>
     release(&tickslock);
    800028f0:	00018517          	auipc	a0,0x18
    800028f4:	ac050513          	addi	a0,a0,-1344 # 8001a3b0 <tickslock>
    800028f8:	ffffe097          	auipc	ra,0xffffe
    800028fc:	39e080e7          	jalr	926(ra) # 80000c96 <release>
    80002900:	bd51                	j	80002794 <sleep+0x3a>
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    80002902:	40f706bb          	subw	a3,a4,a5
    80002906:	b715                	j	8000282a <sleep+0xd0>

0000000080002908 <wait>:
{
    80002908:	715d                	addi	sp,sp,-80
    8000290a:	e486                	sd	ra,72(sp)
    8000290c:	e0a2                	sd	s0,64(sp)
    8000290e:	fc26                	sd	s1,56(sp)
    80002910:	f84a                	sd	s2,48(sp)
    80002912:	f44e                	sd	s3,40(sp)
    80002914:	f052                	sd	s4,32(sp)
    80002916:	ec56                	sd	s5,24(sp)
    80002918:	e85a                	sd	s6,16(sp)
    8000291a:	e45e                	sd	s7,8(sp)
    8000291c:	e062                	sd	s8,0(sp)
    8000291e:	0880                	addi	s0,sp,80
    80002920:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002922:	fffff097          	auipc	ra,0xfffff
    80002926:	096080e7          	jalr	150(ra) # 800019b8 <myproc>
    8000292a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000292c:	00010517          	auipc	a0,0x10
    80002930:	9cc50513          	addi	a0,a0,-1588 # 800122f8 <wait_lock>
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	2ae080e7          	jalr	686(ra) # 80000be2 <acquire>
    havekids = 0;
    8000293c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000293e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002940:	00018997          	auipc	s3,0x18
    80002944:	a7098993          	addi	s3,s3,-1424 # 8001a3b0 <tickslock>
        havekids = 1;
    80002948:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000294a:	00010c17          	auipc	s8,0x10
    8000294e:	9aec0c13          	addi	s8,s8,-1618 # 800122f8 <wait_lock>
    havekids = 0;
    80002952:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002954:	00011497          	auipc	s1,0x11
    80002958:	65c48493          	addi	s1,s1,1628 # 80013fb0 <proc>
    8000295c:	a0bd                	j	800029ca <wait+0xc2>
          pid = np->pid;
    8000295e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002962:	000b0e63          	beqz	s6,8000297e <wait+0x76>
    80002966:	4691                	li	a3,4
    80002968:	02c48613          	addi	a2,s1,44
    8000296c:	85da                	mv	a1,s6
    8000296e:	05893503          	ld	a0,88(s2)
    80002972:	fffff097          	auipc	ra,0xfffff
    80002976:	d08080e7          	jalr	-760(ra) # 8000167a <copyout>
    8000297a:	02054563          	bltz	a0,800029a4 <wait+0x9c>
          freeproc(np);
    8000297e:	8526                	mv	a0,s1
    80002980:	fffff097          	auipc	ra,0xfffff
    80002984:	222080e7          	jalr	546(ra) # 80001ba2 <freeproc>
          release(&np->lock);
    80002988:	8526                	mv	a0,s1
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	30c080e7          	jalr	780(ra) # 80000c96 <release>
          release(&wait_lock);
    80002992:	00010517          	auipc	a0,0x10
    80002996:	96650513          	addi	a0,a0,-1690 # 800122f8 <wait_lock>
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	2fc080e7          	jalr	764(ra) # 80000c96 <release>
          return pid;
    800029a2:	a09d                	j	80002a08 <wait+0x100>
            release(&np->lock);
    800029a4:	8526                	mv	a0,s1
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	2f0080e7          	jalr	752(ra) # 80000c96 <release>
            release(&wait_lock);
    800029ae:	00010517          	auipc	a0,0x10
    800029b2:	94a50513          	addi	a0,a0,-1718 # 800122f8 <wait_lock>
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	2e0080e7          	jalr	736(ra) # 80000c96 <release>
            return -1;
    800029be:	59fd                	li	s3,-1
    800029c0:	a0a1                	j	80002a08 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800029c2:	19048493          	addi	s1,s1,400
    800029c6:	03348463          	beq	s1,s3,800029ee <wait+0xe6>
      if(np->parent == p){
    800029ca:	60bc                	ld	a5,64(s1)
    800029cc:	ff279be3          	bne	a5,s2,800029c2 <wait+0xba>
        acquire(&np->lock);
    800029d0:	8526                	mv	a0,s1
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	210080e7          	jalr	528(ra) # 80000be2 <acquire>
        if(np->state == ZOMBIE){
    800029da:	4c9c                	lw	a5,24(s1)
    800029dc:	f94781e3          	beq	a5,s4,8000295e <wait+0x56>
        release(&np->lock);
    800029e0:	8526                	mv	a0,s1
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	2b4080e7          	jalr	692(ra) # 80000c96 <release>
        havekids = 1;
    800029ea:	8756                	mv	a4,s5
    800029ec:	bfd9                	j	800029c2 <wait+0xba>
    if(!havekids || p->killed){
    800029ee:	c701                	beqz	a4,800029f6 <wait+0xee>
    800029f0:	02892783          	lw	a5,40(s2)
    800029f4:	c79d                	beqz	a5,80002a22 <wait+0x11a>
      release(&wait_lock);
    800029f6:	00010517          	auipc	a0,0x10
    800029fa:	90250513          	addi	a0,a0,-1790 # 800122f8 <wait_lock>
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	298080e7          	jalr	664(ra) # 80000c96 <release>
      return -1;
    80002a06:	59fd                	li	s3,-1
}
    80002a08:	854e                	mv	a0,s3
    80002a0a:	60a6                	ld	ra,72(sp)
    80002a0c:	6406                	ld	s0,64(sp)
    80002a0e:	74e2                	ld	s1,56(sp)
    80002a10:	7942                	ld	s2,48(sp)
    80002a12:	79a2                	ld	s3,40(sp)
    80002a14:	7a02                	ld	s4,32(sp)
    80002a16:	6ae2                	ld	s5,24(sp)
    80002a18:	6b42                	ld	s6,16(sp)
    80002a1a:	6ba2                	ld	s7,8(sp)
    80002a1c:	6c02                	ld	s8,0(sp)
    80002a1e:	6161                	addi	sp,sp,80
    80002a20:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002a22:	85e2                	mv	a1,s8
    80002a24:	854a                	mv	a0,s2
    80002a26:	00000097          	auipc	ra,0x0
    80002a2a:	d34080e7          	jalr	-716(ra) # 8000275a <sleep>
    havekids = 0;
    80002a2e:	b715                	j	80002952 <wait+0x4a>

0000000080002a30 <waitpid>:
{
    80002a30:	711d                	addi	sp,sp,-96
    80002a32:	ec86                	sd	ra,88(sp)
    80002a34:	e8a2                	sd	s0,80(sp)
    80002a36:	e4a6                	sd	s1,72(sp)
    80002a38:	e0ca                	sd	s2,64(sp)
    80002a3a:	fc4e                	sd	s3,56(sp)
    80002a3c:	f852                	sd	s4,48(sp)
    80002a3e:	f456                	sd	s5,40(sp)
    80002a40:	f05a                	sd	s6,32(sp)
    80002a42:	ec5e                	sd	s7,24(sp)
    80002a44:	e862                	sd	s8,16(sp)
    80002a46:	e466                	sd	s9,8(sp)
    80002a48:	1080                	addi	s0,sp,96
    80002a4a:	8a2a                	mv	s4,a0
    80002a4c:	8c2e                	mv	s8,a1
  struct proc *p = myproc();
    80002a4e:	fffff097          	auipc	ra,0xfffff
    80002a52:	f6a080e7          	jalr	-150(ra) # 800019b8 <myproc>
    80002a56:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002a58:	00010517          	auipc	a0,0x10
    80002a5c:	8a050513          	addi	a0,a0,-1888 # 800122f8 <wait_lock>
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	182080e7          	jalr	386(ra) # 80000be2 <acquire>
  int found=0;
    80002a68:	4c81                	li	s9,0
        if(np->state == ZOMBIE){
    80002a6a:	4a95                	li	s5,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002a6c:	00018997          	auipc	s3,0x18
    80002a70:	94498993          	addi	s3,s3,-1724 # 8001a3b0 <tickslock>
	found = 1;
    80002a74:	4b05                	li	s6,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002a76:	00010b97          	auipc	s7,0x10
    80002a7a:	882b8b93          	addi	s7,s7,-1918 # 800122f8 <wait_lock>
    80002a7e:	a0d1                	j	80002b42 <waitpid+0x112>
           if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002a80:	000c0e63          	beqz	s8,80002a9c <waitpid+0x6c>
    80002a84:	4691                	li	a3,4
    80002a86:	02c48613          	addi	a2,s1,44
    80002a8a:	85e2                	mv	a1,s8
    80002a8c:	05893503          	ld	a0,88(s2)
    80002a90:	fffff097          	auipc	ra,0xfffff
    80002a94:	bea080e7          	jalr	-1046(ra) # 8000167a <copyout>
    80002a98:	04054263          	bltz	a0,80002adc <waitpid+0xac>
           freeproc(np);
    80002a9c:	8526                	mv	a0,s1
    80002a9e:	fffff097          	auipc	ra,0xfffff
    80002aa2:	104080e7          	jalr	260(ra) # 80001ba2 <freeproc>
           release(&np->lock);
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	ffffe097          	auipc	ra,0xffffe
    80002aac:	1ee080e7          	jalr	494(ra) # 80000c96 <release>
           release(&wait_lock);
    80002ab0:	00010517          	auipc	a0,0x10
    80002ab4:	84850513          	addi	a0,a0,-1976 # 800122f8 <wait_lock>
    80002ab8:	ffffe097          	auipc	ra,0xffffe
    80002abc:	1de080e7          	jalr	478(ra) # 80000c96 <release>
           return pid;
    80002ac0:	8552                	mv	a0,s4
}
    80002ac2:	60e6                	ld	ra,88(sp)
    80002ac4:	6446                	ld	s0,80(sp)
    80002ac6:	64a6                	ld	s1,72(sp)
    80002ac8:	6906                	ld	s2,64(sp)
    80002aca:	79e2                	ld	s3,56(sp)
    80002acc:	7a42                	ld	s4,48(sp)
    80002ace:	7aa2                	ld	s5,40(sp)
    80002ad0:	7b02                	ld	s6,32(sp)
    80002ad2:	6be2                	ld	s7,24(sp)
    80002ad4:	6c42                	ld	s8,16(sp)
    80002ad6:	6ca2                	ld	s9,8(sp)
    80002ad8:	6125                	addi	sp,sp,96
    80002ada:	8082                	ret
             release(&np->lock);
    80002adc:	8526                	mv	a0,s1
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	1b8080e7          	jalr	440(ra) # 80000c96 <release>
             release(&wait_lock);
    80002ae6:	00010517          	auipc	a0,0x10
    80002aea:	81250513          	addi	a0,a0,-2030 # 800122f8 <wait_lock>
    80002aee:	ffffe097          	auipc	ra,0xffffe
    80002af2:	1a8080e7          	jalr	424(ra) # 80000c96 <release>
             return -1;
    80002af6:	557d                	li	a0,-1
    80002af8:	b7e9                	j	80002ac2 <waitpid+0x92>
    for(np = proc; np < &proc[NPROC]; np++){
    80002afa:	19048493          	addi	s1,s1,400
    80002afe:	03348763          	beq	s1,s3,80002b2c <waitpid+0xfc>
      if((np->parent == p) && (np->pid == pid)){
    80002b02:	60bc                	ld	a5,64(s1)
    80002b04:	ff279be3          	bne	a5,s2,80002afa <waitpid+0xca>
    80002b08:	589c                	lw	a5,48(s1)
    80002b0a:	ff4798e3          	bne	a5,s4,80002afa <waitpid+0xca>
        acquire(&np->lock);
    80002b0e:	8526                	mv	a0,s1
    80002b10:	ffffe097          	auipc	ra,0xffffe
    80002b14:	0d2080e7          	jalr	210(ra) # 80000be2 <acquire>
        if(np->state == ZOMBIE){
    80002b18:	4c9c                	lw	a5,24(s1)
    80002b1a:	f75783e3          	beq	a5,s5,80002a80 <waitpid+0x50>
        release(&np->lock);
    80002b1e:	8526                	mv	a0,s1
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	176080e7          	jalr	374(ra) # 80000c96 <release>
	found = 1;
    80002b28:	8cda                	mv	s9,s6
    80002b2a:	bfc1                	j	80002afa <waitpid+0xca>
    if(!found || p->killed){
    80002b2c:	020c8063          	beqz	s9,80002b4c <waitpid+0x11c>
    80002b30:	02892783          	lw	a5,40(s2)
    80002b34:	ef81                	bnez	a5,80002b4c <waitpid+0x11c>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002b36:	85de                	mv	a1,s7
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	c20080e7          	jalr	-992(ra) # 8000275a <sleep>
    for(np = proc; np < &proc[NPROC]; np++){
    80002b42:	00011497          	auipc	s1,0x11
    80002b46:	46e48493          	addi	s1,s1,1134 # 80013fb0 <proc>
    80002b4a:	bf65                	j	80002b02 <waitpid+0xd2>
      release(&wait_lock);
    80002b4c:	0000f517          	auipc	a0,0xf
    80002b50:	7ac50513          	addi	a0,a0,1964 # 800122f8 <wait_lock>
    80002b54:	ffffe097          	auipc	ra,0xffffe
    80002b58:	142080e7          	jalr	322(ra) # 80000c96 <release>
      return -1;
    80002b5c:	557d                	li	a0,-1
    80002b5e:	b795                	j	80002ac2 <waitpid+0x92>

0000000080002b60 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002b60:	7139                	addi	sp,sp,-64
    80002b62:	fc06                	sd	ra,56(sp)
    80002b64:	f822                	sd	s0,48(sp)
    80002b66:	f426                	sd	s1,40(sp)
    80002b68:	f04a                	sd	s2,32(sp)
    80002b6a:	ec4e                	sd	s3,24(sp)
    80002b6c:	e852                	sd	s4,16(sp)
    80002b6e:	e456                	sd	s5,8(sp)
    80002b70:	e05a                	sd	s6,0(sp)
    80002b72:	0080                	addi	s0,sp,64
    80002b74:	8a2a                	mv	s4,a0
  struct proc *p;
  uint xticks;

  if (!holding(&tickslock)) {
    80002b76:	00018517          	auipc	a0,0x18
    80002b7a:	83a50513          	addi	a0,a0,-1990 # 8001a3b0 <tickslock>
    80002b7e:	ffffe097          	auipc	ra,0xffffe
    80002b82:	fea080e7          	jalr	-22(ra) # 80000b68 <holding>
    80002b86:	c105                	beqz	a0,80002ba6 <wakeup+0x46>
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
    80002b88:	00007b17          	auipc	s6,0x7
    80002b8c:	4f4b2b03          	lw	s6,1268(s6) # 8000a07c <ticks>

  for(p = proc; p < &proc[NPROC]; p++) {
    80002b90:	00011497          	auipc	s1,0x11
    80002b94:	42048493          	addi	s1,s1,1056 # 80013fb0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002b98:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002b9a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002b9c:	00018917          	auipc	s2,0x18
    80002ba0:	81490913          	addi	s2,s2,-2028 # 8001a3b0 <tickslock>
    80002ba4:	a099                	j	80002bea <wakeup+0x8a>
     acquire(&tickslock);
    80002ba6:	00018517          	auipc	a0,0x18
    80002baa:	80a50513          	addi	a0,a0,-2038 # 8001a3b0 <tickslock>
    80002bae:	ffffe097          	auipc	ra,0xffffe
    80002bb2:	034080e7          	jalr	52(ra) # 80000be2 <acquire>
     xticks = ticks;
    80002bb6:	00007b17          	auipc	s6,0x7
    80002bba:	4c6b2b03          	lw	s6,1222(s6) # 8000a07c <ticks>
     release(&tickslock);
    80002bbe:	00017517          	auipc	a0,0x17
    80002bc2:	7f250513          	addi	a0,a0,2034 # 8001a3b0 <tickslock>
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	0d0080e7          	jalr	208(ra) # 80000c96 <release>
    80002bce:	b7c9                	j	80002b90 <wakeup+0x30>
        p->state = RUNNABLE;
    80002bd0:	0154ac23          	sw	s5,24(s1)
	p->waitstart = xticks;
    80002bd4:	1964a023          	sw	s6,384(s1)
      }
      release(&p->lock);
    80002bd8:	8526                	mv	a0,s1
    80002bda:	ffffe097          	auipc	ra,0xffffe
    80002bde:	0bc080e7          	jalr	188(ra) # 80000c96 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002be2:	19048493          	addi	s1,s1,400
    80002be6:	03248463          	beq	s1,s2,80002c0e <wakeup+0xae>
    if(p != myproc()){
    80002bea:	fffff097          	auipc	ra,0xfffff
    80002bee:	dce080e7          	jalr	-562(ra) # 800019b8 <myproc>
    80002bf2:	fea488e3          	beq	s1,a0,80002be2 <wakeup+0x82>
      acquire(&p->lock);
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	ffffe097          	auipc	ra,0xffffe
    80002bfc:	fea080e7          	jalr	-22(ra) # 80000be2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002c00:	4c9c                	lw	a5,24(s1)
    80002c02:	fd379be3          	bne	a5,s3,80002bd8 <wakeup+0x78>
    80002c06:	709c                	ld	a5,32(s1)
    80002c08:	fd4798e3          	bne	a5,s4,80002bd8 <wakeup+0x78>
    80002c0c:	b7d1                	j	80002bd0 <wakeup+0x70>
    }
  }
}
    80002c0e:	70e2                	ld	ra,56(sp)
    80002c10:	7442                	ld	s0,48(sp)
    80002c12:	74a2                	ld	s1,40(sp)
    80002c14:	7902                	ld	s2,32(sp)
    80002c16:	69e2                	ld	s3,24(sp)
    80002c18:	6a42                	ld	s4,16(sp)
    80002c1a:	6aa2                	ld	s5,8(sp)
    80002c1c:	6b02                	ld	s6,0(sp)
    80002c1e:	6121                	addi	sp,sp,64
    80002c20:	8082                	ret

0000000080002c22 <reparent>:
{
    80002c22:	7179                	addi	sp,sp,-48
    80002c24:	f406                	sd	ra,40(sp)
    80002c26:	f022                	sd	s0,32(sp)
    80002c28:	ec26                	sd	s1,24(sp)
    80002c2a:	e84a                	sd	s2,16(sp)
    80002c2c:	e44e                	sd	s3,8(sp)
    80002c2e:	e052                	sd	s4,0(sp)
    80002c30:	1800                	addi	s0,sp,48
    80002c32:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002c34:	00011497          	auipc	s1,0x11
    80002c38:	37c48493          	addi	s1,s1,892 # 80013fb0 <proc>
      pp->parent = initproc;
    80002c3c:	00007a17          	auipc	s4,0x7
    80002c40:	434a0a13          	addi	s4,s4,1076 # 8000a070 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002c44:	00017997          	auipc	s3,0x17
    80002c48:	76c98993          	addi	s3,s3,1900 # 8001a3b0 <tickslock>
    80002c4c:	a029                	j	80002c56 <reparent+0x34>
    80002c4e:	19048493          	addi	s1,s1,400
    80002c52:	01348d63          	beq	s1,s3,80002c6c <reparent+0x4a>
    if(pp->parent == p){
    80002c56:	60bc                	ld	a5,64(s1)
    80002c58:	ff279be3          	bne	a5,s2,80002c4e <reparent+0x2c>
      pp->parent = initproc;
    80002c5c:	000a3503          	ld	a0,0(s4)
    80002c60:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	efe080e7          	jalr	-258(ra) # 80002b60 <wakeup>
    80002c6a:	b7d5                	j	80002c4e <reparent+0x2c>
}
    80002c6c:	70a2                	ld	ra,40(sp)
    80002c6e:	7402                	ld	s0,32(sp)
    80002c70:	64e2                	ld	s1,24(sp)
    80002c72:	6942                	ld	s2,16(sp)
    80002c74:	69a2                	ld	s3,8(sp)
    80002c76:	6a02                	ld	s4,0(sp)
    80002c78:	6145                	addi	sp,sp,48
    80002c7a:	8082                	ret

0000000080002c7c <exit>:
{
    80002c7c:	7179                	addi	sp,sp,-48
    80002c7e:	f406                	sd	ra,40(sp)
    80002c80:	f022                	sd	s0,32(sp)
    80002c82:	ec26                	sd	s1,24(sp)
    80002c84:	e84a                	sd	s2,16(sp)
    80002c86:	e44e                	sd	s3,8(sp)
    80002c88:	e052                	sd	s4,0(sp)
    80002c8a:	1800                	addi	s0,sp,48
    80002c8c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002c8e:	fffff097          	auipc	ra,0xfffff
    80002c92:	d2a080e7          	jalr	-726(ra) # 800019b8 <myproc>
    80002c96:	892a                	mv	s2,a0
  if(p == initproc)
    80002c98:	00007797          	auipc	a5,0x7
    80002c9c:	3d87b783          	ld	a5,984(a5) # 8000a070 <initproc>
    80002ca0:	0d850493          	addi	s1,a0,216
    80002ca4:	15850993          	addi	s3,a0,344
    80002ca8:	02a79363          	bne	a5,a0,80002cce <exit+0x52>
    panic("init exiting");
    80002cac:	00006517          	auipc	a0,0x6
    80002cb0:	5b450513          	addi	a0,a0,1460 # 80009260 <digits+0x220>
    80002cb4:	ffffe097          	auipc	ra,0xffffe
    80002cb8:	888080e7          	jalr	-1912(ra) # 8000053c <panic>
      fileclose(f);
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	560080e7          	jalr	1376(ra) # 8000621c <fileclose>
      p->ofile[fd] = 0;
    80002cc4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002cc8:	04a1                	addi	s1,s1,8
    80002cca:	01348563          	beq	s1,s3,80002cd4 <exit+0x58>
    if(p->ofile[fd]){
    80002cce:	6088                	ld	a0,0(s1)
    80002cd0:	f575                	bnez	a0,80002cbc <exit+0x40>
    80002cd2:	bfdd                	j	80002cc8 <exit+0x4c>
  begin_op();
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	07c080e7          	jalr	124(ra) # 80005d50 <begin_op>
  iput(p->cwd);
    80002cdc:	15893503          	ld	a0,344(s2)
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	858080e7          	jalr	-1960(ra) # 80005538 <iput>
  end_op();
    80002ce8:	00003097          	auipc	ra,0x3
    80002cec:	0e8080e7          	jalr	232(ra) # 80005dd0 <end_op>
  p->cwd = 0;
    80002cf0:	14093c23          	sd	zero,344(s2)
  acquire(&wait_lock);
    80002cf4:	0000f497          	auipc	s1,0xf
    80002cf8:	60448493          	addi	s1,s1,1540 # 800122f8 <wait_lock>
    80002cfc:	8526                	mv	a0,s1
    80002cfe:	ffffe097          	auipc	ra,0xffffe
    80002d02:	ee4080e7          	jalr	-284(ra) # 80000be2 <acquire>
  reparent(p);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	f1a080e7          	jalr	-230(ra) # 80002c22 <reparent>
  wakeup(p->parent);
    80002d10:	04093503          	ld	a0,64(s2)
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	e4c080e7          	jalr	-436(ra) # 80002b60 <wakeup>
  acquire(&p->lock);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	ec4080e7          	jalr	-316(ra) # 80000be2 <acquire>
  p->xstate = status;
    80002d26:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80002d2a:	4795                	li	a5,5
    80002d2c:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002d30:	8526                	mv	a0,s1
    80002d32:	ffffe097          	auipc	ra,0xffffe
    80002d36:	f64080e7          	jalr	-156(ra) # 80000c96 <release>
  acquire(&tickslock);
    80002d3a:	00017517          	auipc	a0,0x17
    80002d3e:	67650513          	addi	a0,a0,1654 # 8001a3b0 <tickslock>
    80002d42:	ffffe097          	auipc	ra,0xffffe
    80002d46:	ea0080e7          	jalr	-352(ra) # 80000be2 <acquire>
  xticks = ticks;
    80002d4a:	00007497          	auipc	s1,0x7
    80002d4e:	3324a483          	lw	s1,818(s1) # 8000a07c <ticks>
  release(&tickslock);
    80002d52:	00017517          	auipc	a0,0x17
    80002d56:	65e50513          	addi	a0,a0,1630 # 8001a3b0 <tickslock>
    80002d5a:	ffffe097          	auipc	ra,0xffffe
    80002d5e:	f3c080e7          	jalr	-196(ra) # 80000c96 <release>
  p->endtime = xticks;
    80002d62:	0004879b          	sext.w	a5,s1
    80002d66:	16f92c23          	sw	a5,376(s2)
  if (p->is_batchproc) {
    80002d6a:	03c92703          	lw	a4,60(s2)
    80002d6e:	16070663          	beqz	a4,80002eda <exit+0x25e>
     if ((xticks - p->burst_start) > 0) {
    80002d72:	18492703          	lw	a4,388(s2)
    80002d76:	0c970f63          	beq	a4,s1,80002e54 <exit+0x1d8>
        num_cpubursts++;
    80002d7a:	00007617          	auipc	a2,0x7
    80002d7e:	2ca60613          	addi	a2,a2,714 # 8000a044 <num_cpubursts>
    80002d82:	4214                	lw	a3,0(a2)
    80002d84:	2685                	addiw	a3,a3,1
    80002d86:	c214                	sw	a3,0(a2)
        cpubursts_tot += (xticks - p->burst_start);
    80002d88:	40e4863b          	subw	a2,s1,a4
    80002d8c:	0006059b          	sext.w	a1,a2
    80002d90:	00007517          	auipc	a0,0x7
    80002d94:	2b050513          	addi	a0,a0,688 # 8000a040 <cpubursts_tot>
    80002d98:	4114                	lw	a3,0(a0)
    80002d9a:	9eb1                	addw	a3,a3,a2
    80002d9c:	c114                	sw	a3,0(a0)
        if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
    80002d9e:	00007697          	auipc	a3,0x7
    80002da2:	29e6a683          	lw	a3,670(a3) # 8000a03c <cpubursts_max>
    80002da6:	00b6f663          	bgeu	a3,a1,80002db2 <exit+0x136>
    80002daa:	00007697          	auipc	a3,0x7
    80002dae:	28c6a923          	sw	a2,658(a3) # 8000a03c <cpubursts_max>
        if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
    80002db2:	00007697          	auipc	a3,0x7
    80002db6:	e366a683          	lw	a3,-458(a3) # 80009be8 <cpubursts_min>
    80002dba:	00d5f663          	bgeu	a1,a3,80002dc6 <exit+0x14a>
    80002dbe:	00007697          	auipc	a3,0x7
    80002dc2:	e2c6a523          	sw	a2,-470(a3) # 80009be8 <cpubursts_min>
        if (p->nextburst_estimate > 0) {
    80002dc6:	18892683          	lw	a3,392(s2)
    80002dca:	02d05663          	blez	a3,80002df6 <exit+0x17a>
           estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    80002dce:	0006851b          	sext.w	a0,a3
    80002dd2:	12b56063          	bltu	a0,a1,80002ef2 <exit+0x276>
    80002dd6:	9f29                	addw	a4,a4,a0
    80002dd8:	9f05                	subw	a4,a4,s1
    80002dda:	00007517          	auipc	a0,0x7
    80002dde:	25250513          	addi	a0,a0,594 # 8000a02c <estimation_error>
    80002de2:	410c                	lw	a1,0(a0)
    80002de4:	9f2d                	addw	a4,a4,a1
    80002de6:	c118                	sw	a4,0(a0)
           estimation_error_instance++;
    80002de8:	00007597          	auipc	a1,0x7
    80002dec:	24058593          	addi	a1,a1,576 # 8000a028 <estimation_error_instance>
    80002df0:	4198                	lw	a4,0(a1)
    80002df2:	2705                	addiw	a4,a4,1
    80002df4:	c198                	sw	a4,0(a1)
        p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
    80002df6:	4709                	li	a4,2
    80002df8:	02e6c73b          	divw	a4,a3,a4
    80002dfc:	9f31                	addw	a4,a4,a2
    80002dfe:	0016561b          	srliw	a2,a2,0x1
    80002e02:	9f11                	subw	a4,a4,a2
    80002e04:	0007069b          	sext.w	a3,a4
    80002e08:	18e92423          	sw	a4,392(s2)
        if (p->nextburst_estimate > 0) {
    80002e0c:	04d05463          	blez	a3,80002e54 <exit+0x1d8>
           num_cpubursts_est++;
    80002e10:	00007597          	auipc	a1,0x7
    80002e14:	22858593          	addi	a1,a1,552 # 8000a038 <num_cpubursts_est>
    80002e18:	4190                	lw	a2,0(a1)
    80002e1a:	2605                	addiw	a2,a2,1
    80002e1c:	c190                	sw	a2,0(a1)
           cpubursts_est_tot += p->nextburst_estimate;
    80002e1e:	00007597          	auipc	a1,0x7
    80002e22:	21658593          	addi	a1,a1,534 # 8000a034 <cpubursts_est_tot>
    80002e26:	4190                	lw	a2,0(a1)
    80002e28:	9e39                	addw	a2,a2,a4
    80002e2a:	c190                	sw	a2,0(a1)
           if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
    80002e2c:	00007617          	auipc	a2,0x7
    80002e30:	20462603          	lw	a2,516(a2) # 8000a030 <cpubursts_est_max>
    80002e34:	00d65663          	bge	a2,a3,80002e40 <exit+0x1c4>
    80002e38:	00007617          	auipc	a2,0x7
    80002e3c:	1ee62c23          	sw	a4,504(a2) # 8000a030 <cpubursts_est_max>
           if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
    80002e40:	00007617          	auipc	a2,0x7
    80002e44:	da462603          	lw	a2,-604(a2) # 80009be4 <cpubursts_est_min>
    80002e48:	00c6d663          	bge	a3,a2,80002e54 <exit+0x1d8>
    80002e4c:	00007697          	auipc	a3,0x7
    80002e50:	d8e6ac23          	sw	a4,-616(a3) # 80009be4 <cpubursts_est_min>
     if (p->stime < batch_start) batch_start = p->stime;
    80002e54:	17492703          	lw	a4,372(s2)
    80002e58:	00007697          	auipc	a3,0x7
    80002e5c:	d986a683          	lw	a3,-616(a3) # 80009bf0 <batch_start>
    80002e60:	00d75663          	bge	a4,a3,80002e6c <exit+0x1f0>
    80002e64:	00007697          	auipc	a3,0x7
    80002e68:	d8e6a623          	sw	a4,-628(a3) # 80009bf0 <batch_start>
     batchsize--;
    80002e6c:	00007617          	auipc	a2,0x7
    80002e70:	1f060613          	addi	a2,a2,496 # 8000a05c <batchsize>
    80002e74:	4214                	lw	a3,0(a2)
    80002e76:	36fd                	addiw	a3,a3,-1
    80002e78:	0006859b          	sext.w	a1,a3
    80002e7c:	c214                	sw	a3,0(a2)
     turnaround += (p->endtime - p->stime);
    80002e7e:	00007697          	auipc	a3,0x7
    80002e82:	1d668693          	addi	a3,a3,470 # 8000a054 <turnaround>
    80002e86:	40e7873b          	subw	a4,a5,a4
    80002e8a:	4290                	lw	a2,0(a3)
    80002e8c:	9f31                	addw	a4,a4,a2
    80002e8e:	c298                	sw	a4,0(a3)
     waiting_tot += p->waittime;
    80002e90:	00007697          	auipc	a3,0x7
    80002e94:	1bc68693          	addi	a3,a3,444 # 8000a04c <waiting_tot>
    80002e98:	17c92703          	lw	a4,380(s2)
    80002e9c:	4290                	lw	a2,0(a3)
    80002e9e:	9f31                	addw	a4,a4,a2
    80002ea0:	c298                	sw	a4,0(a3)
     completion_tot += p->endtime;
    80002ea2:	00007697          	auipc	a3,0x7
    80002ea6:	1ae68693          	addi	a3,a3,430 # 8000a050 <completion_tot>
    80002eaa:	4298                	lw	a4,0(a3)
    80002eac:	9f3d                	addw	a4,a4,a5
    80002eae:	c298                	sw	a4,0(a3)
     if (p->endtime > completion_max) completion_max = p->endtime;
    80002eb0:	00007717          	auipc	a4,0x7
    80002eb4:	19872703          	lw	a4,408(a4) # 8000a048 <completion_max>
    80002eb8:	00f75663          	bge	a4,a5,80002ec4 <exit+0x248>
    80002ebc:	00007717          	auipc	a4,0x7
    80002ec0:	18f72623          	sw	a5,396(a4) # 8000a048 <completion_max>
     if (p->endtime < completion_min) completion_min = p->endtime;
    80002ec4:	00007717          	auipc	a4,0x7
    80002ec8:	d2872703          	lw	a4,-728(a4) # 80009bec <completion_min>
    80002ecc:	00e7d663          	bge	a5,a4,80002ed8 <exit+0x25c>
    80002ed0:	00007717          	auipc	a4,0x7
    80002ed4:	d0f72e23          	sw	a5,-740(a4) # 80009bec <completion_min>
     if (batchsize == 0) {
    80002ed8:	c185                	beqz	a1,80002ef8 <exit+0x27c>
  sched();
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	63e080e7          	jalr	1598(ra) # 80002518 <sched>
  panic("zombie exit");
    80002ee2:	00006517          	auipc	a0,0x6
    80002ee6:	4c650513          	addi	a0,a0,1222 # 800093a8 <digits+0x368>
    80002eea:	ffffd097          	auipc	ra,0xffffd
    80002eee:	652080e7          	jalr	1618(ra) # 8000053c <panic>
           estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    80002ef2:	40a6073b          	subw	a4,a2,a0
    80002ef6:	b5d5                	j	80002dda <exit+0x15e>
        printf("\nBatch execution time: %d\n", p->endtime - batch_start);
    80002ef8:	00007597          	auipc	a1,0x7
    80002efc:	cf85a583          	lw	a1,-776(a1) # 80009bf0 <batch_start>
    80002f00:	40b785bb          	subw	a1,a5,a1
    80002f04:	00006517          	auipc	a0,0x6
    80002f08:	36c50513          	addi	a0,a0,876 # 80009270 <digits+0x230>
    80002f0c:	ffffd097          	auipc	ra,0xffffd
    80002f10:	67a080e7          	jalr	1658(ra) # 80000586 <printf>
	printf("Average turn-around time: %d\n", turnaround/batchsize2);
    80002f14:	00007497          	auipc	s1,0x7
    80002f18:	14448493          	addi	s1,s1,324 # 8000a058 <batchsize2>
    80002f1c:	409c                	lw	a5,0(s1)
    80002f1e:	00007597          	auipc	a1,0x7
    80002f22:	1365a583          	lw	a1,310(a1) # 8000a054 <turnaround>
    80002f26:	02f5c5bb          	divw	a1,a1,a5
    80002f2a:	00006517          	auipc	a0,0x6
    80002f2e:	36650513          	addi	a0,a0,870 # 80009290 <digits+0x250>
    80002f32:	ffffd097          	auipc	ra,0xffffd
    80002f36:	654080e7          	jalr	1620(ra) # 80000586 <printf>
	printf("Average waiting time: %d\n", waiting_tot/batchsize2);
    80002f3a:	409c                	lw	a5,0(s1)
    80002f3c:	00007597          	auipc	a1,0x7
    80002f40:	1105a583          	lw	a1,272(a1) # 8000a04c <waiting_tot>
    80002f44:	02f5c5bb          	divw	a1,a1,a5
    80002f48:	00006517          	auipc	a0,0x6
    80002f4c:	36850513          	addi	a0,a0,872 # 800092b0 <digits+0x270>
    80002f50:	ffffd097          	auipc	ra,0xffffd
    80002f54:	636080e7          	jalr	1590(ra) # 80000586 <printf>
	printf("Completion time: avg: %d, max: %d, min: %d\n", completion_tot/batchsize2, completion_max, completion_min);
    80002f58:	409c                	lw	a5,0(s1)
    80002f5a:	00007697          	auipc	a3,0x7
    80002f5e:	c926a683          	lw	a3,-878(a3) # 80009bec <completion_min>
    80002f62:	00007617          	auipc	a2,0x7
    80002f66:	0e662603          	lw	a2,230(a2) # 8000a048 <completion_max>
    80002f6a:	00007597          	auipc	a1,0x7
    80002f6e:	0e65a583          	lw	a1,230(a1) # 8000a050 <completion_tot>
    80002f72:	02f5c5bb          	divw	a1,a1,a5
    80002f76:	00006517          	auipc	a0,0x6
    80002f7a:	35a50513          	addi	a0,a0,858 # 800092d0 <digits+0x290>
    80002f7e:	ffffd097          	auipc	ra,0xffffd
    80002f82:	608080e7          	jalr	1544(ra) # 80000586 <printf>
	if ((sched_policy == SCHED_NPREEMPT_FCFS) || (sched_policy == SCHED_NPREEMPT_SJF)) {
    80002f86:	00007717          	auipc	a4,0x7
    80002f8a:	0f272703          	lw	a4,242(a4) # 8000a078 <sched_policy>
    80002f8e:	4785                	li	a5,1
    80002f90:	08e7fb63          	bgeu	a5,a4,80003026 <exit+0x3aa>
	batchsize2 = 0;
    80002f94:	00007797          	auipc	a5,0x7
    80002f98:	0c07a223          	sw	zero,196(a5) # 8000a058 <batchsize2>
	batch_start = 0x7FFFFFFF;
    80002f9c:	800007b7          	lui	a5,0x80000
    80002fa0:	fff7c793          	not	a5,a5
    80002fa4:	00007717          	auipc	a4,0x7
    80002fa8:	c4f72623          	sw	a5,-948(a4) # 80009bf0 <batch_start>
	turnaround = 0;
    80002fac:	00007717          	auipc	a4,0x7
    80002fb0:	0a072423          	sw	zero,168(a4) # 8000a054 <turnaround>
	waiting_tot = 0;
    80002fb4:	00007717          	auipc	a4,0x7
    80002fb8:	08072c23          	sw	zero,152(a4) # 8000a04c <waiting_tot>
	completion_tot = 0;
    80002fbc:	00007717          	auipc	a4,0x7
    80002fc0:	08072a23          	sw	zero,148(a4) # 8000a050 <completion_tot>
	completion_max = 0;
    80002fc4:	00007717          	auipc	a4,0x7
    80002fc8:	08072223          	sw	zero,132(a4) # 8000a048 <completion_max>
	completion_min = 0x7FFFFFFF;
    80002fcc:	00007717          	auipc	a4,0x7
    80002fd0:	c2f72023          	sw	a5,-992(a4) # 80009bec <completion_min>
	num_cpubursts = 0;
    80002fd4:	00007717          	auipc	a4,0x7
    80002fd8:	06072823          	sw	zero,112(a4) # 8000a044 <num_cpubursts>
        cpubursts_tot = 0;
    80002fdc:	00007717          	auipc	a4,0x7
    80002fe0:	06072223          	sw	zero,100(a4) # 8000a040 <cpubursts_tot>
        cpubursts_max = 0;
    80002fe4:	00007717          	auipc	a4,0x7
    80002fe8:	04072c23          	sw	zero,88(a4) # 8000a03c <cpubursts_max>
        cpubursts_min = 0x7FFFFFFF;
    80002fec:	00007717          	auipc	a4,0x7
    80002ff0:	bef72e23          	sw	a5,-1028(a4) # 80009be8 <cpubursts_min>
	num_cpubursts_est = 0;
    80002ff4:	00007717          	auipc	a4,0x7
    80002ff8:	04072223          	sw	zero,68(a4) # 8000a038 <num_cpubursts_est>
        cpubursts_est_tot = 0;
    80002ffc:	00007717          	auipc	a4,0x7
    80003000:	02072c23          	sw	zero,56(a4) # 8000a034 <cpubursts_est_tot>
        cpubursts_est_max = 0;
    80003004:	00007717          	auipc	a4,0x7
    80003008:	02072623          	sw	zero,44(a4) # 8000a030 <cpubursts_est_max>
        cpubursts_est_min = 0x7FFFFFFF;
    8000300c:	00007717          	auipc	a4,0x7
    80003010:	bcf72c23          	sw	a5,-1064(a4) # 80009be4 <cpubursts_est_min>
	estimation_error = 0;
    80003014:	00007797          	auipc	a5,0x7
    80003018:	0007ac23          	sw	zero,24(a5) # 8000a02c <estimation_error>
        estimation_error_instance = 0;
    8000301c:	00007797          	auipc	a5,0x7
    80003020:	0007a623          	sw	zero,12(a5) # 8000a028 <estimation_error_instance>
    80003024:	bd5d                	j	80002eda <exit+0x25e>
	   printf("CPU bursts: count: %d, avg: %d, max: %d, min: %d\n", num_cpubursts, cpubursts_tot/num_cpubursts, cpubursts_max, cpubursts_min);
    80003026:	00007597          	auipc	a1,0x7
    8000302a:	01e5a583          	lw	a1,30(a1) # 8000a044 <num_cpubursts>
    8000302e:	00007717          	auipc	a4,0x7
    80003032:	bba72703          	lw	a4,-1094(a4) # 80009be8 <cpubursts_min>
    80003036:	00007697          	auipc	a3,0x7
    8000303a:	0066a683          	lw	a3,6(a3) # 8000a03c <cpubursts_max>
    8000303e:	00007617          	auipc	a2,0x7
    80003042:	00262603          	lw	a2,2(a2) # 8000a040 <cpubursts_tot>
    80003046:	02b6463b          	divw	a2,a2,a1
    8000304a:	00006517          	auipc	a0,0x6
    8000304e:	2b650513          	addi	a0,a0,694 # 80009300 <digits+0x2c0>
    80003052:	ffffd097          	auipc	ra,0xffffd
    80003056:	534080e7          	jalr	1332(ra) # 80000586 <printf>
	   printf("CPU burst estimates: count: %d, avg: %d, max: %d, min: %d\n", num_cpubursts_est, cpubursts_est_tot/num_cpubursts_est, cpubursts_est_max, cpubursts_est_min);
    8000305a:	00007597          	auipc	a1,0x7
    8000305e:	fde5a583          	lw	a1,-34(a1) # 8000a038 <num_cpubursts_est>
    80003062:	00007717          	auipc	a4,0x7
    80003066:	b8272703          	lw	a4,-1150(a4) # 80009be4 <cpubursts_est_min>
    8000306a:	00007697          	auipc	a3,0x7
    8000306e:	fc66a683          	lw	a3,-58(a3) # 8000a030 <cpubursts_est_max>
    80003072:	00007617          	auipc	a2,0x7
    80003076:	fc262603          	lw	a2,-62(a2) # 8000a034 <cpubursts_est_tot>
    8000307a:	02b6463b          	divw	a2,a2,a1
    8000307e:	00006517          	auipc	a0,0x6
    80003082:	2ba50513          	addi	a0,a0,698 # 80009338 <digits+0x2f8>
    80003086:	ffffd097          	auipc	ra,0xffffd
    8000308a:	500080e7          	jalr	1280(ra) # 80000586 <printf>
	   printf("CPU burst estimation error: count: %d, avg: %d\n", estimation_error_instance, estimation_error/estimation_error_instance);
    8000308e:	00007597          	auipc	a1,0x7
    80003092:	f9a5a583          	lw	a1,-102(a1) # 8000a028 <estimation_error_instance>
    80003096:	00007617          	auipc	a2,0x7
    8000309a:	f9662603          	lw	a2,-106(a2) # 8000a02c <estimation_error>
    8000309e:	02b6463b          	divw	a2,a2,a1
    800030a2:	00006517          	auipc	a0,0x6
    800030a6:	2d650513          	addi	a0,a0,726 # 80009378 <digits+0x338>
    800030aa:	ffffd097          	auipc	ra,0xffffd
    800030ae:	4dc080e7          	jalr	1244(ra) # 80000586 <printf>
    800030b2:	b5cd                	j	80002f94 <exit+0x318>

00000000800030b4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800030b4:	7179                	addi	sp,sp,-48
    800030b6:	f406                	sd	ra,40(sp)
    800030b8:	f022                	sd	s0,32(sp)
    800030ba:	ec26                	sd	s1,24(sp)
    800030bc:	e84a                	sd	s2,16(sp)
    800030be:	e44e                	sd	s3,8(sp)
    800030c0:	e052                	sd	s4,0(sp)
    800030c2:	1800                	addi	s0,sp,48
    800030c4:	892a                	mv	s2,a0
  struct proc *p;
  uint xticks;

  acquire(&tickslock);
    800030c6:	00017517          	auipc	a0,0x17
    800030ca:	2ea50513          	addi	a0,a0,746 # 8001a3b0 <tickslock>
    800030ce:	ffffe097          	auipc	ra,0xffffe
    800030d2:	b14080e7          	jalr	-1260(ra) # 80000be2 <acquire>
  xticks = ticks;
    800030d6:	00007a17          	auipc	s4,0x7
    800030da:	fa6a2a03          	lw	s4,-90(s4) # 8000a07c <ticks>
  release(&tickslock);
    800030de:	00017517          	auipc	a0,0x17
    800030e2:	2d250513          	addi	a0,a0,722 # 8001a3b0 <tickslock>
    800030e6:	ffffe097          	auipc	ra,0xffffe
    800030ea:	bb0080e7          	jalr	-1104(ra) # 80000c96 <release>

  for(p = proc; p < &proc[NPROC]; p++){
    800030ee:	00011497          	auipc	s1,0x11
    800030f2:	ec248493          	addi	s1,s1,-318 # 80013fb0 <proc>
    800030f6:	00017997          	auipc	s3,0x17
    800030fa:	2ba98993          	addi	s3,s3,698 # 8001a3b0 <tickslock>
    acquire(&p->lock);
    800030fe:	8526                	mv	a0,s1
    80003100:	ffffe097          	auipc	ra,0xffffe
    80003104:	ae2080e7          	jalr	-1310(ra) # 80000be2 <acquire>
    if(p->pid == pid){
    80003108:	589c                	lw	a5,48(s1)
    8000310a:	01278d63          	beq	a5,s2,80003124 <kill+0x70>
	p->waitstart = xticks;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000310e:	8526                	mv	a0,s1
    80003110:	ffffe097          	auipc	ra,0xffffe
    80003114:	b86080e7          	jalr	-1146(ra) # 80000c96 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003118:	19048493          	addi	s1,s1,400
    8000311c:	ff3491e3          	bne	s1,s3,800030fe <kill+0x4a>
  }
  return -1;
    80003120:	557d                	li	a0,-1
    80003122:	a829                	j	8000313c <kill+0x88>
      p->killed = 1;
    80003124:	4785                	li	a5,1
    80003126:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80003128:	4c98                	lw	a4,24(s1)
    8000312a:	4789                	li	a5,2
    8000312c:	02f70063          	beq	a4,a5,8000314c <kill+0x98>
      release(&p->lock);
    80003130:	8526                	mv	a0,s1
    80003132:	ffffe097          	auipc	ra,0xffffe
    80003136:	b64080e7          	jalr	-1180(ra) # 80000c96 <release>
      return 0;
    8000313a:	4501                	li	a0,0
}
    8000313c:	70a2                	ld	ra,40(sp)
    8000313e:	7402                	ld	s0,32(sp)
    80003140:	64e2                	ld	s1,24(sp)
    80003142:	6942                	ld	s2,16(sp)
    80003144:	69a2                	ld	s3,8(sp)
    80003146:	6a02                	ld	s4,0(sp)
    80003148:	6145                	addi	sp,sp,48
    8000314a:	8082                	ret
        p->state = RUNNABLE;
    8000314c:	478d                	li	a5,3
    8000314e:	cc9c                	sw	a5,24(s1)
	p->waitstart = xticks;
    80003150:	1944a023          	sw	s4,384(s1)
    80003154:	bff1                	j	80003130 <kill+0x7c>

0000000080003156 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003156:	7179                	addi	sp,sp,-48
    80003158:	f406                	sd	ra,40(sp)
    8000315a:	f022                	sd	s0,32(sp)
    8000315c:	ec26                	sd	s1,24(sp)
    8000315e:	e84a                	sd	s2,16(sp)
    80003160:	e44e                	sd	s3,8(sp)
    80003162:	e052                	sd	s4,0(sp)
    80003164:	1800                	addi	s0,sp,48
    80003166:	84aa                	mv	s1,a0
    80003168:	892e                	mv	s2,a1
    8000316a:	89b2                	mv	s3,a2
    8000316c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	84a080e7          	jalr	-1974(ra) # 800019b8 <myproc>
  if(user_dst){
    80003176:	c08d                	beqz	s1,80003198 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80003178:	86d2                	mv	a3,s4
    8000317a:	864e                	mv	a2,s3
    8000317c:	85ca                	mv	a1,s2
    8000317e:	6d28                	ld	a0,88(a0)
    80003180:	ffffe097          	auipc	ra,0xffffe
    80003184:	4fa080e7          	jalr	1274(ra) # 8000167a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80003188:	70a2                	ld	ra,40(sp)
    8000318a:	7402                	ld	s0,32(sp)
    8000318c:	64e2                	ld	s1,24(sp)
    8000318e:	6942                	ld	s2,16(sp)
    80003190:	69a2                	ld	s3,8(sp)
    80003192:	6a02                	ld	s4,0(sp)
    80003194:	6145                	addi	sp,sp,48
    80003196:	8082                	ret
    memmove((char *)dst, src, len);
    80003198:	000a061b          	sext.w	a2,s4
    8000319c:	85ce                	mv	a1,s3
    8000319e:	854a                	mv	a0,s2
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	b9e080e7          	jalr	-1122(ra) # 80000d3e <memmove>
    return 0;
    800031a8:	8526                	mv	a0,s1
    800031aa:	bff9                	j	80003188 <either_copyout+0x32>

00000000800031ac <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800031ac:	7179                	addi	sp,sp,-48
    800031ae:	f406                	sd	ra,40(sp)
    800031b0:	f022                	sd	s0,32(sp)
    800031b2:	ec26                	sd	s1,24(sp)
    800031b4:	e84a                	sd	s2,16(sp)
    800031b6:	e44e                	sd	s3,8(sp)
    800031b8:	e052                	sd	s4,0(sp)
    800031ba:	1800                	addi	s0,sp,48
    800031bc:	892a                	mv	s2,a0
    800031be:	84ae                	mv	s1,a1
    800031c0:	89b2                	mv	s3,a2
    800031c2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800031c4:	ffffe097          	auipc	ra,0xffffe
    800031c8:	7f4080e7          	jalr	2036(ra) # 800019b8 <myproc>
  if(user_src){
    800031cc:	c08d                	beqz	s1,800031ee <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800031ce:	86d2                	mv	a3,s4
    800031d0:	864e                	mv	a2,s3
    800031d2:	85ca                	mv	a1,s2
    800031d4:	6d28                	ld	a0,88(a0)
    800031d6:	ffffe097          	auipc	ra,0xffffe
    800031da:	530080e7          	jalr	1328(ra) # 80001706 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800031de:	70a2                	ld	ra,40(sp)
    800031e0:	7402                	ld	s0,32(sp)
    800031e2:	64e2                	ld	s1,24(sp)
    800031e4:	6942                	ld	s2,16(sp)
    800031e6:	69a2                	ld	s3,8(sp)
    800031e8:	6a02                	ld	s4,0(sp)
    800031ea:	6145                	addi	sp,sp,48
    800031ec:	8082                	ret
    memmove(dst, (char*)src, len);
    800031ee:	000a061b          	sext.w	a2,s4
    800031f2:	85ce                	mv	a1,s3
    800031f4:	854a                	mv	a0,s2
    800031f6:	ffffe097          	auipc	ra,0xffffe
    800031fa:	b48080e7          	jalr	-1208(ra) # 80000d3e <memmove>
    return 0;
    800031fe:	8526                	mv	a0,s1
    80003200:	bff9                	j	800031de <either_copyin+0x32>

0000000080003202 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80003202:	715d                	addi	sp,sp,-80
    80003204:	e486                	sd	ra,72(sp)
    80003206:	e0a2                	sd	s0,64(sp)
    80003208:	fc26                	sd	s1,56(sp)
    8000320a:	f84a                	sd	s2,48(sp)
    8000320c:	f44e                	sd	s3,40(sp)
    8000320e:	f052                	sd	s4,32(sp)
    80003210:	ec56                	sd	s5,24(sp)
    80003212:	e85a                	sd	s6,16(sp)
    80003214:	e45e                	sd	s7,8(sp)
    80003216:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80003218:	00006517          	auipc	a0,0x6
    8000321c:	6a050513          	addi	a0,a0,1696 # 800098b8 <syscalls+0x158>
    80003220:	ffffd097          	auipc	ra,0xffffd
    80003224:	366080e7          	jalr	870(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003228:	00011497          	auipc	s1,0x11
    8000322c:	ee848493          	addi	s1,s1,-280 # 80014110 <proc+0x160>
    80003230:	00017917          	auipc	s2,0x17
    80003234:	2e090913          	addi	s2,s2,736 # 8001a510 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003238:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000323a:	00006997          	auipc	s3,0x6
    8000323e:	17e98993          	addi	s3,s3,382 # 800093b8 <digits+0x378>
    printf("%d %s %s", p->pid, state, p->name);
    80003242:	00006a97          	auipc	s5,0x6
    80003246:	17ea8a93          	addi	s5,s5,382 # 800093c0 <digits+0x380>
    printf("\n");
    8000324a:	00006a17          	auipc	s4,0x6
    8000324e:	66ea0a13          	addi	s4,s4,1646 # 800098b8 <syscalls+0x158>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003252:	00006b97          	auipc	s7,0x6
    80003256:	326b8b93          	addi	s7,s7,806 # 80009578 <states.2594>
    8000325a:	a00d                	j	8000327c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000325c:	ed06a583          	lw	a1,-304(a3)
    80003260:	8556                	mv	a0,s5
    80003262:	ffffd097          	auipc	ra,0xffffd
    80003266:	324080e7          	jalr	804(ra) # 80000586 <printf>
    printf("\n");
    8000326a:	8552                	mv	a0,s4
    8000326c:	ffffd097          	auipc	ra,0xffffd
    80003270:	31a080e7          	jalr	794(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003274:	19048493          	addi	s1,s1,400
    80003278:	03248163          	beq	s1,s2,8000329a <procdump+0x98>
    if(p->state == UNUSED)
    8000327c:	86a6                	mv	a3,s1
    8000327e:	eb84a783          	lw	a5,-328(s1)
    80003282:	dbed                	beqz	a5,80003274 <procdump+0x72>
      state = "???";
    80003284:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003286:	fcfb6be3          	bltu	s6,a5,8000325c <procdump+0x5a>
    8000328a:	1782                	slli	a5,a5,0x20
    8000328c:	9381                	srli	a5,a5,0x20
    8000328e:	078e                	slli	a5,a5,0x3
    80003290:	97de                	add	a5,a5,s7
    80003292:	6390                	ld	a2,0(a5)
    80003294:	f661                	bnez	a2,8000325c <procdump+0x5a>
      state = "???";
    80003296:	864e                	mv	a2,s3
    80003298:	b7d1                	j	8000325c <procdump+0x5a>
  }
}
    8000329a:	60a6                	ld	ra,72(sp)
    8000329c:	6406                	ld	s0,64(sp)
    8000329e:	74e2                	ld	s1,56(sp)
    800032a0:	7942                	ld	s2,48(sp)
    800032a2:	79a2                	ld	s3,40(sp)
    800032a4:	7a02                	ld	s4,32(sp)
    800032a6:	6ae2                	ld	s5,24(sp)
    800032a8:	6b42                	ld	s6,16(sp)
    800032aa:	6ba2                	ld	s7,8(sp)
    800032ac:	6161                	addi	sp,sp,80
    800032ae:	8082                	ret

00000000800032b0 <ps>:

// Print a process listing to console with proper locks held.
// Caution: don't invoke too often; can slow down the machine.
int
ps(void)
{
    800032b0:	7119                	addi	sp,sp,-128
    800032b2:	fc86                	sd	ra,120(sp)
    800032b4:	f8a2                	sd	s0,112(sp)
    800032b6:	f4a6                	sd	s1,104(sp)
    800032b8:	f0ca                	sd	s2,96(sp)
    800032ba:	ecce                	sd	s3,88(sp)
    800032bc:	e8d2                	sd	s4,80(sp)
    800032be:	e4d6                	sd	s5,72(sp)
    800032c0:	e0da                	sd	s6,64(sp)
    800032c2:	fc5e                	sd	s7,56(sp)
    800032c4:	f862                	sd	s8,48(sp)
    800032c6:	f466                	sd	s9,40(sp)
    800032c8:	f06a                	sd	s10,32(sp)
    800032ca:	ec6e                	sd	s11,24(sp)
    800032cc:	0100                	addi	s0,sp,128
  struct proc *p;
  char *state;
  int ppid, pid;
  uint xticks;

  printf("\n");
    800032ce:	00006517          	auipc	a0,0x6
    800032d2:	5ea50513          	addi	a0,a0,1514 # 800098b8 <syscalls+0x158>
    800032d6:	ffffd097          	auipc	ra,0xffffd
    800032da:	2b0080e7          	jalr	688(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800032de:	00011497          	auipc	s1,0x11
    800032e2:	cd248493          	addi	s1,s1,-814 # 80013fb0 <proc>
    acquire(&p->lock);
    if(p->state == UNUSED) {
      release(&p->lock);
      continue;
    }
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800032e6:	4d95                	li	s11,5
    else
      state = "???";

    pid = p->pid;
    release(&p->lock);
    acquire(&wait_lock);
    800032e8:	0000fb97          	auipc	s7,0xf
    800032ec:	010b8b93          	addi	s7,s7,16 # 800122f8 <wait_lock>
    if (p->parent) {
       acquire(&p->parent->lock);
       ppid = p->parent->pid;
       release(&p->parent->lock);
    }
    else ppid = -1;
    800032f0:	5b7d                	li	s6,-1
    release(&wait_lock);

    acquire(&tickslock);
    800032f2:	00017a97          	auipc	s5,0x17
    800032f6:	0bea8a93          	addi	s5,s5,190 # 8001a3b0 <tickslock>
  for(p = proc; p < &proc[NPROC]; p++){
    800032fa:	00017d17          	auipc	s10,0x17
    800032fe:	0b6d0d13          	addi	s10,s10,182 # 8001a3b0 <tickslock>
    80003302:	a85d                	j	800033b8 <ps+0x108>
      release(&p->lock);
    80003304:	8526                	mv	a0,s1
    80003306:	ffffe097          	auipc	ra,0xffffe
    8000330a:	990080e7          	jalr	-1648(ra) # 80000c96 <release>
      continue;
    8000330e:	a04d                	j	800033b0 <ps+0x100>
    pid = p->pid;
    80003310:	0304ac03          	lw	s8,48(s1)
    release(&p->lock);
    80003314:	8526                	mv	a0,s1
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	980080e7          	jalr	-1664(ra) # 80000c96 <release>
    acquire(&wait_lock);
    8000331e:	855e                	mv	a0,s7
    80003320:	ffffe097          	auipc	ra,0xffffe
    80003324:	8c2080e7          	jalr	-1854(ra) # 80000be2 <acquire>
    if (p->parent) {
    80003328:	60a8                	ld	a0,64(s1)
    else ppid = -1;
    8000332a:	8a5a                	mv	s4,s6
    if (p->parent) {
    8000332c:	cd01                	beqz	a0,80003344 <ps+0x94>
       acquire(&p->parent->lock);
    8000332e:	ffffe097          	auipc	ra,0xffffe
    80003332:	8b4080e7          	jalr	-1868(ra) # 80000be2 <acquire>
       ppid = p->parent->pid;
    80003336:	60a8                	ld	a0,64(s1)
    80003338:	03052a03          	lw	s4,48(a0)
       release(&p->parent->lock);
    8000333c:	ffffe097          	auipc	ra,0xffffe
    80003340:	95a080e7          	jalr	-1702(ra) # 80000c96 <release>
    release(&wait_lock);
    80003344:	855e                	mv	a0,s7
    80003346:	ffffe097          	auipc	ra,0xffffe
    8000334a:	950080e7          	jalr	-1712(ra) # 80000c96 <release>
    acquire(&tickslock);
    8000334e:	8556                	mv	a0,s5
    80003350:	ffffe097          	auipc	ra,0xffffe
    80003354:	892080e7          	jalr	-1902(ra) # 80000be2 <acquire>
    xticks = ticks;
    80003358:	00007797          	auipc	a5,0x7
    8000335c:	d2478793          	addi	a5,a5,-732 # 8000a07c <ticks>
    80003360:	0007ac83          	lw	s9,0(a5)
    release(&tickslock);
    80003364:	8556                	mv	a0,s5
    80003366:	ffffe097          	auipc	ra,0xffffe
    8000336a:	930080e7          	jalr	-1744(ra) # 80000c96 <release>

    printf("pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p", pid, ppid, state, p->name, p->ctime, p->stime, (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime, p->sz);
    8000336e:	16090713          	addi	a4,s2,352
    80003372:	1704a783          	lw	a5,368(s1)
    80003376:	1744a803          	lw	a6,372(s1)
    8000337a:	1784a683          	lw	a3,376(s1)
    8000337e:	410688bb          	subw	a7,a3,a6
    80003382:	07668a63          	beq	a3,s6,800033f6 <ps+0x146>
    80003386:	68b4                	ld	a3,80(s1)
    80003388:	e036                	sd	a3,0(sp)
    8000338a:	86ce                	mv	a3,s3
    8000338c:	8652                	mv	a2,s4
    8000338e:	85e2                	mv	a1,s8
    80003390:	00006517          	auipc	a0,0x6
    80003394:	04050513          	addi	a0,a0,64 # 800093d0 <digits+0x390>
    80003398:	ffffd097          	auipc	ra,0xffffd
    8000339c:	1ee080e7          	jalr	494(ra) # 80000586 <printf>
    printf("\n");
    800033a0:	00006517          	auipc	a0,0x6
    800033a4:	51850513          	addi	a0,a0,1304 # 800098b8 <syscalls+0x158>
    800033a8:	ffffd097          	auipc	ra,0xffffd
    800033ac:	1de080e7          	jalr	478(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800033b0:	19048493          	addi	s1,s1,400
    800033b4:	05a48463          	beq	s1,s10,800033fc <ps+0x14c>
    acquire(&p->lock);
    800033b8:	8926                	mv	s2,s1
    800033ba:	8526                	mv	a0,s1
    800033bc:	ffffe097          	auipc	ra,0xffffe
    800033c0:	826080e7          	jalr	-2010(ra) # 80000be2 <acquire>
    if(p->state == UNUSED) {
    800033c4:	4c9c                	lw	a5,24(s1)
    800033c6:	df9d                	beqz	a5,80003304 <ps+0x54>
      state = "???";
    800033c8:	00006997          	auipc	s3,0x6
    800033cc:	ff098993          	addi	s3,s3,-16 # 800093b8 <digits+0x378>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800033d0:	f4fde0e3          	bltu	s11,a5,80003310 <ps+0x60>
    800033d4:	1782                	slli	a5,a5,0x20
    800033d6:	9381                	srli	a5,a5,0x20
    800033d8:	078e                	slli	a5,a5,0x3
    800033da:	00006717          	auipc	a4,0x6
    800033de:	19e70713          	addi	a4,a4,414 # 80009578 <states.2594>
    800033e2:	97ba                	add	a5,a5,a4
    800033e4:	0307b983          	ld	s3,48(a5)
    800033e8:	f20994e3          	bnez	s3,80003310 <ps+0x60>
      state = "???";
    800033ec:	00006997          	auipc	s3,0x6
    800033f0:	fcc98993          	addi	s3,s3,-52 # 800093b8 <digits+0x378>
    800033f4:	bf31                	j	80003310 <ps+0x60>
    printf("pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p", pid, ppid, state, p->name, p->ctime, p->stime, (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime, p->sz);
    800033f6:	410c88bb          	subw	a7,s9,a6
    800033fa:	b771                	j	80003386 <ps+0xd6>
  }
  return 0;
}
    800033fc:	4501                	li	a0,0
    800033fe:	70e6                	ld	ra,120(sp)
    80003400:	7446                	ld	s0,112(sp)
    80003402:	74a6                	ld	s1,104(sp)
    80003404:	7906                	ld	s2,96(sp)
    80003406:	69e6                	ld	s3,88(sp)
    80003408:	6a46                	ld	s4,80(sp)
    8000340a:	6aa6                	ld	s5,72(sp)
    8000340c:	6b06                	ld	s6,64(sp)
    8000340e:	7be2                	ld	s7,56(sp)
    80003410:	7c42                	ld	s8,48(sp)
    80003412:	7ca2                	ld	s9,40(sp)
    80003414:	7d02                	ld	s10,32(sp)
    80003416:	6de2                	ld	s11,24(sp)
    80003418:	6109                	addi	sp,sp,128
    8000341a:	8082                	ret

000000008000341c <pinfo>:

int
pinfo(int pid, uint64 addr)
{
    8000341c:	7159                	addi	sp,sp,-112
    8000341e:	f486                	sd	ra,104(sp)
    80003420:	f0a2                	sd	s0,96(sp)
    80003422:	eca6                	sd	s1,88(sp)
    80003424:	e8ca                	sd	s2,80(sp)
    80003426:	e4ce                	sd	s3,72(sp)
    80003428:	e0d2                	sd	s4,64(sp)
    8000342a:	1880                	addi	s0,sp,112
    8000342c:	892a                	mv	s2,a0
    8000342e:	89ae                	mv	s3,a1
  struct proc *p;
  char *state;
  uint xticks;
  int found=0;

  if (pid == -1) {
    80003430:	57fd                	li	a5,-1
     p = myproc();
     acquire(&p->lock);
     found=1;
  }
  else {
     for(p = proc; p < &proc[NPROC]; p++){
    80003432:	00011497          	auipc	s1,0x11
    80003436:	b7e48493          	addi	s1,s1,-1154 # 80013fb0 <proc>
    8000343a:	00017a17          	auipc	s4,0x17
    8000343e:	f76a0a13          	addi	s4,s4,-138 # 8001a3b0 <tickslock>
  if (pid == -1) {
    80003442:	02f51563          	bne	a0,a5,8000346c <pinfo+0x50>
     p = myproc();
    80003446:	ffffe097          	auipc	ra,0xffffe
    8000344a:	572080e7          	jalr	1394(ra) # 800019b8 <myproc>
    8000344e:	84aa                	mv	s1,a0
     acquire(&p->lock);
    80003450:	ffffd097          	auipc	ra,0xffffd
    80003454:	792080e7          	jalr	1938(ra) # 80000be2 <acquire>
         found=1;
         break;
       }
     }
  }
  if (found) {
    80003458:	a025                	j	80003480 <pinfo+0x64>
         release(&p->lock);
    8000345a:	8526                	mv	a0,s1
    8000345c:	ffffe097          	auipc	ra,0xffffe
    80003460:	83a080e7          	jalr	-1990(ra) # 80000c96 <release>
     for(p = proc; p < &proc[NPROC]; p++){
    80003464:	19048493          	addi	s1,s1,400
    80003468:	13448d63          	beq	s1,s4,800035a2 <pinfo+0x186>
       acquire(&p->lock);
    8000346c:	8526                	mv	a0,s1
    8000346e:	ffffd097          	auipc	ra,0xffffd
    80003472:	774080e7          	jalr	1908(ra) # 80000be2 <acquire>
       if((p->state == UNUSED) || (p->pid != pid)) {
    80003476:	4c9c                	lw	a5,24(s1)
    80003478:	d3ed                	beqz	a5,8000345a <pinfo+0x3e>
    8000347a:	589c                	lw	a5,48(s1)
    8000347c:	fd279fe3          	bne	a5,s2,8000345a <pinfo+0x3e>
     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003480:	4c9c                	lw	a5,24(s1)
    80003482:	4715                	li	a4,5
         state = states[p->state];
     else
         state = "???";
    80003484:	00006917          	auipc	s2,0x6
    80003488:	f3490913          	addi	s2,s2,-204 # 800093b8 <digits+0x378>
     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000348c:	00f76e63          	bltu	a4,a5,800034a8 <pinfo+0x8c>
    80003490:	1782                	slli	a5,a5,0x20
    80003492:	9381                	srli	a5,a5,0x20
    80003494:	078e                	slli	a5,a5,0x3
    80003496:	00006717          	auipc	a4,0x6
    8000349a:	0e270713          	addi	a4,a4,226 # 80009578 <states.2594>
    8000349e:	97ba                	add	a5,a5,a4
    800034a0:	0607b903          	ld	s2,96(a5)
    800034a4:	10090163          	beqz	s2,800035a6 <pinfo+0x18a>

     pstat.pid = p->pid;
    800034a8:	589c                	lw	a5,48(s1)
    800034aa:	f8f42c23          	sw	a5,-104(s0)
     release(&p->lock);
    800034ae:	8526                	mv	a0,s1
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	7e6080e7          	jalr	2022(ra) # 80000c96 <release>
     acquire(&wait_lock);
    800034b8:	0000f517          	auipc	a0,0xf
    800034bc:	e4050513          	addi	a0,a0,-448 # 800122f8 <wait_lock>
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	722080e7          	jalr	1826(ra) # 80000be2 <acquire>
     if (p->parent) {
    800034c8:	60a8                	ld	a0,64(s1)
    800034ca:	c17d                	beqz	a0,800035b0 <pinfo+0x194>
        acquire(&p->parent->lock);
    800034cc:	ffffd097          	auipc	ra,0xffffd
    800034d0:	716080e7          	jalr	1814(ra) # 80000be2 <acquire>
        pstat.ppid = p->parent->pid;
    800034d4:	60a8                	ld	a0,64(s1)
    800034d6:	591c                	lw	a5,48(a0)
    800034d8:	f8f42e23          	sw	a5,-100(s0)
        release(&p->parent->lock);
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	7ba080e7          	jalr	1978(ra) # 80000c96 <release>
     }
     else pstat.ppid = -1;
     release(&wait_lock);
    800034e4:	0000f517          	auipc	a0,0xf
    800034e8:	e1450513          	addi	a0,a0,-492 # 800122f8 <wait_lock>
    800034ec:	ffffd097          	auipc	ra,0xffffd
    800034f0:	7aa080e7          	jalr	1962(ra) # 80000c96 <release>

     acquire(&tickslock);
    800034f4:	00017517          	auipc	a0,0x17
    800034f8:	ebc50513          	addi	a0,a0,-324 # 8001a3b0 <tickslock>
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	6e6080e7          	jalr	1766(ra) # 80000be2 <acquire>
     xticks = ticks;
    80003504:	00007a17          	auipc	s4,0x7
    80003508:	b78a2a03          	lw	s4,-1160(s4) # 8000a07c <ticks>
     release(&tickslock);
    8000350c:	00017517          	auipc	a0,0x17
    80003510:	ea450513          	addi	a0,a0,-348 # 8001a3b0 <tickslock>
    80003514:	ffffd097          	auipc	ra,0xffffd
    80003518:	782080e7          	jalr	1922(ra) # 80000c96 <release>

     safestrcpy(&pstat.state[0], state, strlen(state)+1);
    8000351c:	854a                	mv	a0,s2
    8000351e:	ffffe097          	auipc	ra,0xffffe
    80003522:	944080e7          	jalr	-1724(ra) # 80000e62 <strlen>
    80003526:	0015061b          	addiw	a2,a0,1
    8000352a:	85ca                	mv	a1,s2
    8000352c:	fa040513          	addi	a0,s0,-96
    80003530:	ffffe097          	auipc	ra,0xffffe
    80003534:	900080e7          	jalr	-1792(ra) # 80000e30 <safestrcpy>
     safestrcpy(&pstat.command[0], &p->name[0], sizeof(p->name));
    80003538:	4641                	li	a2,16
    8000353a:	16048593          	addi	a1,s1,352
    8000353e:	fa840513          	addi	a0,s0,-88
    80003542:	ffffe097          	auipc	ra,0xffffe
    80003546:	8ee080e7          	jalr	-1810(ra) # 80000e30 <safestrcpy>
     pstat.ctime = p->ctime;
    8000354a:	1704a783          	lw	a5,368(s1)
    8000354e:	faf42c23          	sw	a5,-72(s0)
     pstat.stime = p->stime;
    80003552:	1744a783          	lw	a5,372(s1)
    80003556:	faf42e23          	sw	a5,-68(s0)
     pstat.etime = (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime;
    8000355a:	1784a703          	lw	a4,376(s1)
    8000355e:	567d                	li	a2,-1
    80003560:	40f706bb          	subw	a3,a4,a5
    80003564:	04c70a63          	beq	a4,a2,800035b8 <pinfo+0x19c>
    80003568:	fcd42023          	sw	a3,-64(s0)
     pstat.size = p->sz;
    8000356c:	68bc                	ld	a5,80(s1)
    8000356e:	fcf43423          	sd	a5,-56(s0)
     if(copyout(myproc()->pagetable, addr, (char *)&pstat, sizeof(pstat)) < 0) return -1;
    80003572:	ffffe097          	auipc	ra,0xffffe
    80003576:	446080e7          	jalr	1094(ra) # 800019b8 <myproc>
    8000357a:	03800693          	li	a3,56
    8000357e:	f9840613          	addi	a2,s0,-104
    80003582:	85ce                	mv	a1,s3
    80003584:	6d28                	ld	a0,88(a0)
    80003586:	ffffe097          	auipc	ra,0xffffe
    8000358a:	0f4080e7          	jalr	244(ra) # 8000167a <copyout>
    8000358e:	41f5551b          	sraiw	a0,a0,0x1f
     return 0;
  }
  else return -1;
}
    80003592:	70a6                	ld	ra,104(sp)
    80003594:	7406                	ld	s0,96(sp)
    80003596:	64e6                	ld	s1,88(sp)
    80003598:	6946                	ld	s2,80(sp)
    8000359a:	69a6                	ld	s3,72(sp)
    8000359c:	6a06                	ld	s4,64(sp)
    8000359e:	6165                	addi	sp,sp,112
    800035a0:	8082                	ret
  else return -1;
    800035a2:	557d                	li	a0,-1
    800035a4:	b7fd                	j	80003592 <pinfo+0x176>
         state = "???";
    800035a6:	00006917          	auipc	s2,0x6
    800035aa:	e1290913          	addi	s2,s2,-494 # 800093b8 <digits+0x378>
    800035ae:	bded                	j	800034a8 <pinfo+0x8c>
     else pstat.ppid = -1;
    800035b0:	57fd                	li	a5,-1
    800035b2:	f8f42e23          	sw	a5,-100(s0)
    800035b6:	b73d                	j	800034e4 <pinfo+0xc8>
     pstat.etime = (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime;
    800035b8:	40fa06bb          	subw	a3,s4,a5
    800035bc:	b775                	j	80003568 <pinfo+0x14c>

00000000800035be <schedpolicy>:

int
schedpolicy(int x)
{
    800035be:	1141                	addi	sp,sp,-16
    800035c0:	e422                	sd	s0,8(sp)
    800035c2:	0800                	addi	s0,sp,16
   int y = sched_policy;
    800035c4:	00007797          	auipc	a5,0x7
    800035c8:	ab478793          	addi	a5,a5,-1356 # 8000a078 <sched_policy>
    800035cc:	4398                	lw	a4,0(a5)
   sched_policy = x;
    800035ce:	c388                	sw	a0,0(a5)
   return y;
}
    800035d0:	853a                	mv	a0,a4
    800035d2:	6422                	ld	s0,8(sp)
    800035d4:	0141                	addi	sp,sp,16
    800035d6:	8082                	ret

00000000800035d8 <condsleep>:


void condsleep(struct cond_t* cv, struct sleeplock* lock)
{
    800035d8:	7179                	addi	sp,sp,-48
    800035da:	f406                	sd	ra,40(sp)
    800035dc:	f022                	sd	s0,32(sp)
    800035de:	ec26                	sd	s1,24(sp)
    800035e0:	e84a                	sd	s2,16(sp)
    800035e2:	e44e                	sd	s3,8(sp)
    800035e4:	e052                	sd	s4,0(sp)
    800035e6:	1800                	addi	s0,sp,48
    800035e8:	89aa                	mv	s3,a0
    800035ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	3cc080e7          	jalr	972(ra) # 800019b8 <myproc>
    800035f4:	84aa                	mv	s1,a0
  uint xticks;

  if (!holding(&tickslock)) {
    800035f6:	00017517          	auipc	a0,0x17
    800035fa:	dba50513          	addi	a0,a0,-582 # 8001a3b0 <tickslock>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	56a080e7          	jalr	1386(ra) # 80000b68 <holding>
    80003606:	14050863          	beqz	a0,80003756 <condsleep+0x17e>
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
    8000360a:	00007a17          	auipc	s4,0x7
    8000360e:	a72a2a03          	lw	s4,-1422(s4) # 8000a07c <ticks>
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80003612:	8526                	mv	a0,s1
    80003614:	ffffd097          	auipc	ra,0xffffd
    80003618:	5ce080e7          	jalr	1486(ra) # 80000be2 <acquire>
  releasesleep(lock);
    8000361c:	854a                	mv	a0,s2
    8000361e:	00003097          	auipc	ra,0x3
    80003622:	a80080e7          	jalr	-1408(ra) # 8000609e <releasesleep>

  // Go to sleep.
  p->chan = cv;
    80003626:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000362a:	4789                	li	a5,2
    8000362c:	cc9c                	sw	a5,24(s1)

  p->cpu_usage += (SCHED_PARAM_CPU_USAGE/2);
    8000362e:	18c4a783          	lw	a5,396(s1)
    80003632:	0647879b          	addiw	a5,a5,100
    80003636:	18f4a623          	sw	a5,396(s1)

  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
    8000363a:	5cdc                	lw	a5,60(s1)
    8000363c:	c7ed                	beqz	a5,80003726 <condsleep+0x14e>
    8000363e:	1844a683          	lw	a3,388(s1)
    80003642:	0f468263          	beq	a3,s4,80003726 <condsleep+0x14e>
     num_cpubursts++;
    80003646:	00007717          	auipc	a4,0x7
    8000364a:	9fe70713          	addi	a4,a4,-1538 # 8000a044 <num_cpubursts>
    8000364e:	431c                	lw	a5,0(a4)
    80003650:	2785                	addiw	a5,a5,1
    80003652:	c31c                	sw	a5,0(a4)
     cpubursts_tot += (xticks - p->burst_start);
    80003654:	40da073b          	subw	a4,s4,a3
    80003658:	0007059b          	sext.w	a1,a4
    8000365c:	00007617          	auipc	a2,0x7
    80003660:	9e460613          	addi	a2,a2,-1564 # 8000a040 <cpubursts_tot>
    80003664:	421c                	lw	a5,0(a2)
    80003666:	9fb9                	addw	a5,a5,a4
    80003668:	c21c                	sw	a5,0(a2)
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
    8000366a:	00007797          	auipc	a5,0x7
    8000366e:	9d27a783          	lw	a5,-1582(a5) # 8000a03c <cpubursts_max>
    80003672:	00b7f663          	bgeu	a5,a1,8000367e <condsleep+0xa6>
    80003676:	00007797          	auipc	a5,0x7
    8000367a:	9ce7a323          	sw	a4,-1594(a5) # 8000a03c <cpubursts_max>
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
    8000367e:	00006797          	auipc	a5,0x6
    80003682:	56a7a783          	lw	a5,1386(a5) # 80009be8 <cpubursts_min>
    80003686:	00f5f663          	bgeu	a1,a5,80003692 <condsleep+0xba>
    8000368a:	00006797          	auipc	a5,0x6
    8000368e:	54e7af23          	sw	a4,1374(a5) # 80009be8 <cpubursts_min>
     if (p->nextburst_estimate > 0) {
    80003692:	1884a603          	lw	a2,392(s1)
    80003696:	02c05763          	blez	a2,800036c4 <condsleep+0xec>
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    8000369a:	0006079b          	sext.w	a5,a2
    8000369e:	0eb7e163          	bltu	a5,a1,80003780 <condsleep+0x1a8>
    800036a2:	9ebd                	addw	a3,a3,a5
    800036a4:	414686bb          	subw	a3,a3,s4
    800036a8:	00007597          	auipc	a1,0x7
    800036ac:	98458593          	addi	a1,a1,-1660 # 8000a02c <estimation_error>
    800036b0:	419c                	lw	a5,0(a1)
    800036b2:	9ebd                	addw	a3,a3,a5
    800036b4:	c194                	sw	a3,0(a1)
        estimation_error_instance++;
    800036b6:	00007697          	auipc	a3,0x7
    800036ba:	97268693          	addi	a3,a3,-1678 # 8000a028 <estimation_error_instance>
    800036be:	429c                	lw	a5,0(a3)
    800036c0:	2785                	addiw	a5,a5,1
    800036c2:	c29c                	sw	a5,0(a3)
     }
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
    800036c4:	01f6579b          	srliw	a5,a2,0x1f
    800036c8:	9fb1                	addw	a5,a5,a2
    800036ca:	4017d79b          	sraiw	a5,a5,0x1
    800036ce:	9fb9                	addw	a5,a5,a4
    800036d0:	0017571b          	srliw	a4,a4,0x1
    800036d4:	9f99                	subw	a5,a5,a4
    800036d6:	0007871b          	sext.w	a4,a5
    800036da:	18f4a423          	sw	a5,392(s1)
     if (p->nextburst_estimate > 0) {
    800036de:	04e05463          	blez	a4,80003726 <condsleep+0x14e>
        num_cpubursts_est++;
    800036e2:	00007617          	auipc	a2,0x7
    800036e6:	95660613          	addi	a2,a2,-1706 # 8000a038 <num_cpubursts_est>
    800036ea:	4214                	lw	a3,0(a2)
    800036ec:	2685                	addiw	a3,a3,1
    800036ee:	c214                	sw	a3,0(a2)
        cpubursts_est_tot += p->nextburst_estimate;
    800036f0:	00007617          	auipc	a2,0x7
    800036f4:	94460613          	addi	a2,a2,-1724 # 8000a034 <cpubursts_est_tot>
    800036f8:	4214                	lw	a3,0(a2)
    800036fa:	9ebd                	addw	a3,a3,a5
    800036fc:	c214                	sw	a3,0(a2)
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
    800036fe:	00007697          	auipc	a3,0x7
    80003702:	9326a683          	lw	a3,-1742(a3) # 8000a030 <cpubursts_est_max>
    80003706:	00e6d663          	bge	a3,a4,80003712 <condsleep+0x13a>
    8000370a:	00007697          	auipc	a3,0x7
    8000370e:	92f6a323          	sw	a5,-1754(a3) # 8000a030 <cpubursts_est_max>
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
    80003712:	00006697          	auipc	a3,0x6
    80003716:	4d26a683          	lw	a3,1234(a3) # 80009be4 <cpubursts_est_min>
    8000371a:	00d75663          	bge	a4,a3,80003726 <condsleep+0x14e>
    8000371e:	00006717          	auipc	a4,0x6
    80003722:	4cf72323          	sw	a5,1222(a4) # 80009be4 <cpubursts_est_min>
     }
  }

  sched();
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	df2080e7          	jalr	-526(ra) # 80002518 <sched>

  // Tidy up.
  p->chan = 0;
    8000372e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80003732:	8526                	mv	a0,s1
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	562080e7          	jalr	1378(ra) # 80000c96 <release>
  acquiresleep(lock);
    8000373c:	854a                	mv	a0,s2
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	90a080e7          	jalr	-1782(ra) # 80006048 <acquiresleep>
}
    80003746:	70a2                	ld	ra,40(sp)
    80003748:	7402                	ld	s0,32(sp)
    8000374a:	64e2                	ld	s1,24(sp)
    8000374c:	6942                	ld	s2,16(sp)
    8000374e:	69a2                	ld	s3,8(sp)
    80003750:	6a02                	ld	s4,0(sp)
    80003752:	6145                	addi	sp,sp,48
    80003754:	8082                	ret
     acquire(&tickslock);
    80003756:	00017517          	auipc	a0,0x17
    8000375a:	c5a50513          	addi	a0,a0,-934 # 8001a3b0 <tickslock>
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	484080e7          	jalr	1156(ra) # 80000be2 <acquire>
     xticks = ticks;
    80003766:	00007a17          	auipc	s4,0x7
    8000376a:	916a2a03          	lw	s4,-1770(s4) # 8000a07c <ticks>
     release(&tickslock);
    8000376e:	00017517          	auipc	a0,0x17
    80003772:	c4250513          	addi	a0,a0,-958 # 8001a3b0 <tickslock>
    80003776:	ffffd097          	auipc	ra,0xffffd
    8000377a:	520080e7          	jalr	1312(ra) # 80000c96 <release>
    8000377e:	bd51                	j	80003612 <condsleep+0x3a>
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
    80003780:	40f706bb          	subw	a3,a4,a5
    80003784:	b715                	j	800036a8 <condsleep+0xd0>

0000000080003786 <wakeupone>:


void
wakeupone(void *chan)
{
    80003786:	711d                	addi	sp,sp,-96
    80003788:	ec86                	sd	ra,88(sp)
    8000378a:	e8a2                	sd	s0,80(sp)
    8000378c:	e4a6                	sd	s1,72(sp)
    8000378e:	e0ca                	sd	s2,64(sp)
    80003790:	fc4e                	sd	s3,56(sp)
    80003792:	f852                	sd	s4,48(sp)
    80003794:	f456                	sd	s5,40(sp)
    80003796:	f05a                	sd	s6,32(sp)
    80003798:	ec5e                	sd	s7,24(sp)
    8000379a:	e862                	sd	s8,16(sp)
    8000379c:	e466                	sd	s9,8(sp)
    8000379e:	1080                	addi	s0,sp,96
    800037a0:	8b2a                	mv	s6,a0
  struct proc *p;
  uint xticks;

  if (!holding(&tickslock)) {
    800037a2:	00017517          	auipc	a0,0x17
    800037a6:	c0e50513          	addi	a0,a0,-1010 # 8001a3b0 <tickslock>
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	3be080e7          	jalr	958(ra) # 80000b68 <holding>
    800037b2:	c115                	beqz	a0,800037d6 <wakeupone+0x50>
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
    800037b4:	00007c97          	auipc	s9,0x7
    800037b8:	8c8cac83          	lw	s9,-1848(s9) # 8000a07c <ticks>
  int flag=0;
  for(p = proc; p < &proc[NPROC]; p++) {
    800037bc:	00010497          	auipc	s1,0x10
    800037c0:	7f448493          	addi	s1,s1,2036 # 80013fb0 <proc>
    800037c4:	00017997          	auipc	s3,0x17
    800037c8:	bec98993          	addi	s3,s3,-1044 # 8001a3b0 <tickslock>
    {
      return;
    }
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800037cc:	4a89                	li	s5,2
    800037ce:	4a01                	li	s4,0
        p->state = RUNNABLE;
    800037d0:	4c0d                	li	s8,3
	p->waitstart = xticks;
  flag=1;
    800037d2:	4b85                	li	s7,1
    800037d4:	a089                	j	80003816 <wakeupone+0x90>
     acquire(&tickslock);
    800037d6:	00017517          	auipc	a0,0x17
    800037da:	bda50513          	addi	a0,a0,-1062 # 8001a3b0 <tickslock>
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	404080e7          	jalr	1028(ra) # 80000be2 <acquire>
     xticks = ticks;
    800037e6:	00007c97          	auipc	s9,0x7
    800037ea:	896cac83          	lw	s9,-1898(s9) # 8000a07c <ticks>
     release(&tickslock);
    800037ee:	00017517          	auipc	a0,0x17
    800037f2:	bc250513          	addi	a0,a0,-1086 # 8001a3b0 <tickslock>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	4a0080e7          	jalr	1184(ra) # 80000c96 <release>
    800037fe:	bf7d                	j	800037bc <wakeupone+0x36>
//   return;
      }
      release(&p->lock);
    80003800:	8526                	mv	a0,s1
    80003802:	ffffd097          	auipc	ra,0xffffd
    80003806:	494080e7          	jalr	1172(ra) # 80000c96 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000380a:	19048493          	addi	s1,s1,400
    8000380e:	05348063          	beq	s1,s3,8000384e <wakeupone+0xc8>
    if(flag)
    80003812:	02091e63          	bnez	s2,8000384e <wakeupone+0xc8>
    if(p != myproc()){
    80003816:	ffffe097          	auipc	ra,0xffffe
    8000381a:	1a2080e7          	jalr	418(ra) # 800019b8 <myproc>
    8000381e:	02a48463          	beq	s1,a0,80003846 <wakeupone+0xc0>
      acquire(&p->lock);
    80003822:	8526                	mv	a0,s1
    80003824:	ffffd097          	auipc	ra,0xffffd
    80003828:	3be080e7          	jalr	958(ra) # 80000be2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000382c:	4c9c                	lw	a5,24(s1)
    8000382e:	8952                	mv	s2,s4
    80003830:	fd5798e3          	bne	a5,s5,80003800 <wakeupone+0x7a>
    80003834:	709c                	ld	a5,32(s1)
    80003836:	fd6795e3          	bne	a5,s6,80003800 <wakeupone+0x7a>
        p->state = RUNNABLE;
    8000383a:	0184ac23          	sw	s8,24(s1)
	p->waitstart = xticks;
    8000383e:	1994a023          	sw	s9,384(s1)
  flag=1;
    80003842:	895e                	mv	s2,s7
    80003844:	bf75                	j	80003800 <wakeupone+0x7a>
  for(p = proc; p < &proc[NPROC]; p++) {
    80003846:	19048493          	addi	s1,s1,400
    8000384a:	fd3496e3          	bne	s1,s3,80003816 <wakeupone+0x90>
    }
  }
}
    8000384e:	60e6                	ld	ra,88(sp)
    80003850:	6446                	ld	s0,80(sp)
    80003852:	64a6                	ld	s1,72(sp)
    80003854:	6906                	ld	s2,64(sp)
    80003856:	79e2                	ld	s3,56(sp)
    80003858:	7a42                	ld	s4,48(sp)
    8000385a:	7aa2                	ld	s5,40(sp)
    8000385c:	7b02                	ld	s6,32(sp)
    8000385e:	6be2                	ld	s7,24(sp)
    80003860:	6c42                	ld	s8,16(sp)
    80003862:	6ca2                	ld	s9,8(sp)
    80003864:	6125                	addi	sp,sp,96
    80003866:	8082                	ret

0000000080003868 <barrier_alloc>:



int 
barrier_alloc(void)
{
    80003868:	7179                	addi	sp,sp,-48
    8000386a:	f406                	sd	ra,40(sp)
    8000386c:	f022                	sd	s0,32(sp)
    8000386e:	ec26                	sd	s1,24(sp)
    80003870:	e84a                	sd	s2,16(sp)
    80003872:	e44e                	sd	s3,8(sp)
    80003874:	1800                	addi	s0,sp,48
	for(int i=0;i<10;i++)
    80003876:	0000f797          	auipc	a5,0xf
    8000387a:	f3278793          	addi	a5,a5,-206 # 800127a8 <barriers+0x98>
    8000387e:	4481                	li	s1,0
    80003880:	46a9                	li	a3,10
	{
		if(barriers[i].free==0)
    80003882:	4398                	lw	a4,0(a5)
    80003884:	cf19                	beqz	a4,800038a2 <barrier_alloc+0x3a>
	for(int i=0;i<10;i++)
    80003886:	2485                	addiw	s1,s1,1
    80003888:	0a078793          	addi	a5,a5,160
    8000388c:	fed49be3          	bne	s1,a3,80003882 <barrier_alloc+0x1a>
			initsleeplock(&(barriers[i].print_lock), "print_lock");
			initsleeplock(&(barriers[i].barrier_cond.lk), "print_lock");
			return i;
		}
	}
	return -1;// in case when none of the barriers are free? 
    80003890:	54fd                	li	s1,-1
}
    80003892:	8526                	mv	a0,s1
    80003894:	70a2                	ld	ra,40(sp)
    80003896:	7402                	ld	s0,32(sp)
    80003898:	64e2                	ld	s1,24(sp)
    8000389a:	6942                	ld	s2,16(sp)
    8000389c:	69a2                	ld	s3,8(sp)
    8000389e:	6145                	addi	sp,sp,48
    800038a0:	8082                	ret
			barriers[i].free=1;
    800038a2:	00249913          	slli	s2,s1,0x2
    800038a6:	009907b3          	add	a5,s2,s1
    800038aa:	00579713          	slli	a4,a5,0x5
    800038ae:	0000f797          	auipc	a5,0xf
    800038b2:	a3278793          	addi	a5,a5,-1486 # 800122e0 <pid_lock>
    800038b6:	97ba                	add	a5,a5,a4
    800038b8:	4705                	li	a4,1
    800038ba:	4ce7a423          	sw	a4,1224(a5)
			barriers[i].count=0; // number of threads waiting at the barrier 
    800038be:	4c07a223          	sw	zero,1220(a5)
			initsleeplock(&(barriers[i].barrier_lock), "barrier_lock");
    800038c2:	9926                	add	s2,s2,s1
    800038c4:	0916                	slli	s2,s2,0x5
    800038c6:	0000f997          	auipc	s3,0xf
    800038ca:	e4a98993          	addi	s3,s3,-438 # 80012710 <barriers>
    800038ce:	00006597          	auipc	a1,0x6
    800038d2:	b5258593          	addi	a1,a1,-1198 # 80009420 <digits+0x3e0>
    800038d6:	01298533          	add	a0,s3,s2
    800038da:	00002097          	auipc	ra,0x2
    800038de:	734080e7          	jalr	1844(ra) # 8000600e <initsleeplock>
			initsleeplock(&(barriers[i].print_lock), "print_lock");
    800038e2:	03090513          	addi	a0,s2,48
    800038e6:	00006597          	auipc	a1,0x6
    800038ea:	b4a58593          	addi	a1,a1,-1206 # 80009430 <digits+0x3f0>
    800038ee:	954e                	add	a0,a0,s3
    800038f0:	00002097          	auipc	ra,0x2
    800038f4:	71e080e7          	jalr	1822(ra) # 8000600e <initsleeplock>
			initsleeplock(&(barriers[i].barrier_cond.lk), "print_lock");
    800038f8:	06090513          	addi	a0,s2,96
    800038fc:	00006597          	auipc	a1,0x6
    80003900:	b3458593          	addi	a1,a1,-1228 # 80009430 <digits+0x3f0>
    80003904:	954e                	add	a0,a0,s3
    80003906:	00002097          	auipc	ra,0x2
    8000390a:	708080e7          	jalr	1800(ra) # 8000600e <initsleeplock>
			return i;
    8000390e:	b751                	j	80003892 <barrier_alloc+0x2a>

0000000080003910 <barrier>:
// becomes the required number then you can release the barrier. So we should wait on a conditional variable cv
// to become equal to n_processes, then you can broadcast to all the processes stuck at the barrier 

int  // bin= barrier instance number, id= barrier array id, and n= number of processes
barrier(int bin, int id, int n)
{
    80003910:	715d                	addi	sp,sp,-80
    80003912:	e486                	sd	ra,72(sp)
    80003914:	e0a2                	sd	s0,64(sp)
    80003916:	fc26                	sd	s1,56(sp)
    80003918:	f84a                	sd	s2,48(sp)
    8000391a:	f44e                	sd	s3,40(sp)
    8000391c:	f052                	sd	s4,32(sp)
    8000391e:	ec56                	sd	s5,24(sp)
    80003920:	e85a                	sd	s6,16(sp)
    80003922:	e45e                	sd	s7,8(sp)
    80003924:	0880                	addi	s0,sp,80
    80003926:	8aaa                	mv	s5,a0
    80003928:	892e                	mv	s2,a1
    8000392a:	8b32                	mv	s6,a2
  // int pid=myproc()->pid;
  
  struct proc* p= myproc();
    8000392c:	ffffe097          	auipc	ra,0xffffe
    80003930:	08c080e7          	jalr	140(ra) # 800019b8 <myproc>
  int pid= p->pid;
    80003934:	03052b83          	lw	s7,48(a0)
	acquiresleep(&(barriers[id].print_lock));
    80003938:	00291493          	slli	s1,s2,0x2
    8000393c:	94ca                	add	s1,s1,s2
    8000393e:	0496                	slli	s1,s1,0x5
    80003940:	0000fa17          	auipc	s4,0xf
    80003944:	dd0a0a13          	addi	s4,s4,-560 # 80012710 <barriers>
    80003948:	03048993          	addi	s3,s1,48
    8000394c:	99d2                	add	s3,s3,s4
    8000394e:	854e                	mv	a0,s3
    80003950:	00002097          	auipc	ra,0x2
    80003954:	6f8080e7          	jalr	1784(ra) # 80006048 <acquiresleep>
	printf("%d: Entered barrier#%d for barrier array id %d\n",pid,bin, id);
    80003958:	86ca                	mv	a3,s2
    8000395a:	8656                	mv	a2,s5
    8000395c:	85de                	mv	a1,s7
    8000395e:	00006517          	auipc	a0,0x6
    80003962:	ae250513          	addi	a0,a0,-1310 # 80009440 <digits+0x400>
    80003966:	ffffd097          	auipc	ra,0xffffd
    8000396a:	c20080e7          	jalr	-992(ra) # 80000586 <printf>
	releasesleep(&(barriers[id].print_lock));
    8000396e:	854e                	mv	a0,s3
    80003970:	00002097          	auipc	ra,0x2
    80003974:	72e080e7          	jalr	1838(ra) # 8000609e <releasesleep>
	
	// acquire(&p->lock);
	
	// release(&p->lock);
	acquiresleep(&(barriers[id].barrier_lock));
    80003978:	9a26                	add	s4,s4,s1
    8000397a:	8552                	mv	a0,s4
    8000397c:	00002097          	auipc	ra,0x2
    80003980:	6cc080e7          	jalr	1740(ra) # 80006048 <acquiresleep>
	barriers[id].count++;
    80003984:	0000f797          	auipc	a5,0xf
    80003988:	95c78793          	addi	a5,a5,-1700 # 800122e0 <pid_lock>
    8000398c:	97a6                	add	a5,a5,s1
    8000398e:	4c47a703          	lw	a4,1220(a5)
    80003992:	2705                	addiw	a4,a4,1
    80003994:	0007069b          	sext.w	a3,a4
    80003998:	4ce7a223          	sw	a4,1220(a5)
	if (barriers[id].count == n) {
    8000399c:	07668263          	beq	a3,s6,80003a00 <barrier+0xf0>
		barriers[id].count = 0;
		wakeup(&(barriers[id].barrier_cond)); //broadcast 
	}
	else cond_wait(&(barriers[id]).barrier_cond,  &(barriers[id].barrier_lock));
    800039a0:	85d2                	mv	a1,s4
    800039a2:	0000f517          	auipc	a0,0xf
    800039a6:	dce50513          	addi	a0,a0,-562 # 80012770 <barriers+0x60>
    800039aa:	9526                	add	a0,a0,s1
    800039ac:	00004097          	auipc	ra,0x4
    800039b0:	55a080e7          	jalr	1370(ra) # 80007f06 <cond_wait>
	releasesleep(&(barriers[id].barrier_lock));
    800039b4:	8552                	mv	a0,s4
    800039b6:	00002097          	auipc	ra,0x2
    800039ba:	6e8080e7          	jalr	1768(ra) # 8000609e <releasesleep>
	acquiresleep(&(barriers[id].print_lock));
    800039be:	854e                	mv	a0,s3
    800039c0:	00002097          	auipc	ra,0x2
    800039c4:	688080e7          	jalr	1672(ra) # 80006048 <acquiresleep>
	printf("%d: Finished barrier#%d for barrier array id %d\n",pid,bin, id);
    800039c8:	86ca                	mv	a3,s2
    800039ca:	8656                	mv	a2,s5
    800039cc:	85de                	mv	a1,s7
    800039ce:	00006517          	auipc	a0,0x6
    800039d2:	aa250513          	addi	a0,a0,-1374 # 80009470 <digits+0x430>
    800039d6:	ffffd097          	auipc	ra,0xffffd
    800039da:	bb0080e7          	jalr	-1104(ra) # 80000586 <printf>
	releasesleep(&(barriers[id].print_lock));
    800039de:	854e                	mv	a0,s3
    800039e0:	00002097          	auipc	ra,0x2
    800039e4:	6be080e7          	jalr	1726(ra) # 8000609e <releasesleep>
	return 0;
}
    800039e8:	4501                	li	a0,0
    800039ea:	60a6                	ld	ra,72(sp)
    800039ec:	6406                	ld	s0,64(sp)
    800039ee:	74e2                	ld	s1,56(sp)
    800039f0:	7942                	ld	s2,48(sp)
    800039f2:	79a2                	ld	s3,40(sp)
    800039f4:	7a02                	ld	s4,32(sp)
    800039f6:	6ae2                	ld	s5,24(sp)
    800039f8:	6b42                	ld	s6,16(sp)
    800039fa:	6ba2                	ld	s7,8(sp)
    800039fc:	6161                	addi	sp,sp,80
    800039fe:	8082                	ret
		barriers[id].count = 0;
    80003a00:	0000f717          	auipc	a4,0xf
    80003a04:	8e070713          	addi	a4,a4,-1824 # 800122e0 <pid_lock>
    80003a08:	009707b3          	add	a5,a4,s1
    80003a0c:	4c07a223          	sw	zero,1220(a5)
		wakeup(&(barriers[id].barrier_cond)); //broadcast 
    80003a10:	0000f517          	auipc	a0,0xf
    80003a14:	d6050513          	addi	a0,a0,-672 # 80012770 <barriers+0x60>
    80003a18:	9526                	add	a0,a0,s1
    80003a1a:	fffff097          	auipc	ra,0xfffff
    80003a1e:	146080e7          	jalr	326(ra) # 80002b60 <wakeup>
    80003a22:	bf49                	j	800039b4 <barrier+0xa4>

0000000080003a24 <barrier_free>:

int  // free barrier_id = id
barrier_free(int id)
{
    80003a24:	1141                	addi	sp,sp,-16
    80003a26:	e422                	sd	s0,8(sp)
    80003a28:	0800                	addi	s0,sp,16
	// struct barrier temp;
	// temp.free=0;
	// barriers[id]=temp;
  barriers[id].free=0;
    80003a2a:	00251793          	slli	a5,a0,0x2
    80003a2e:	97aa                	add	a5,a5,a0
    80003a30:	0796                	slli	a5,a5,0x5
    80003a32:	0000f517          	auipc	a0,0xf
    80003a36:	8ae50513          	addi	a0,a0,-1874 # 800122e0 <pid_lock>
    80003a3a:	97aa                	add	a5,a5,a0
    80003a3c:	4c07a423          	sw	zero,1224(a5)

	return 0;
}
    80003a40:	4501                	li	a0,0
    80003a42:	6422                	ld	s0,8(sp)
    80003a44:	0141                	addi	sp,sp,16
    80003a46:	8082                	ret

0000000080003a48 <buffer_cond_init>:




void buffer_cond_init(void)
{
    80003a48:	7139                	addi	sp,sp,-64
    80003a4a:	fc06                	sd	ra,56(sp)
    80003a4c:	f822                	sd	s0,48(sp)
    80003a4e:	f426                	sd	s1,40(sp)
    80003a50:	f04a                	sd	s2,32(sp)
    80003a52:	ec4e                	sd	s3,24(sp)
    80003a54:	e852                	sd	s4,16(sp)
    80003a56:	e456                	sd	s5,8(sp)
    80003a58:	e05a                	sd	s6,0(sp)
    80003a5a:	0080                	addi	s0,sp,64
    //  struct sleeplock lock;
    // struct cond_t inserted;
    // struct cond_t deleted;

  // buffer=buff;
	initsleeplock(&(lock_print), "lock_print");
    80003a5c:	00006597          	auipc	a1,0x6
    80003a60:	a4c58593          	addi	a1,a1,-1460 # 800094a8 <digits+0x468>
    80003a64:	0000f517          	auipc	a0,0xf
    80003a68:	2ec50513          	addi	a0,a0,748 # 80012d50 <lock_print>
    80003a6c:	00002097          	auipc	ra,0x2
    80003a70:	5a2080e7          	jalr	1442(ra) # 8000600e <initsleeplock>
	initsleeplock(&(lock_delete), "lock_delete");
    80003a74:	00006597          	auipc	a1,0x6
    80003a78:	a4458593          	addi	a1,a1,-1468 # 800094b8 <digits+0x478>
    80003a7c:	0000f517          	auipc	a0,0xf
    80003a80:	30450513          	addi	a0,a0,772 # 80012d80 <lock_delete>
    80003a84:	00002097          	auipc	ra,0x2
    80003a88:	58a080e7          	jalr	1418(ra) # 8000600e <initsleeplock>
	initsleeplock(&(lock_insert), "lock_insert");
    80003a8c:	00006597          	auipc	a1,0x6
    80003a90:	a3c58593          	addi	a1,a1,-1476 # 800094c8 <digits+0x488>
    80003a94:	0000f517          	auipc	a0,0xf
    80003a98:	31c50513          	addi	a0,a0,796 # 80012db0 <lock_insert>
    80003a9c:	00002097          	auipc	ra,0x2
    80003aa0:	572080e7          	jalr	1394(ra) # 8000600e <initsleeplock>
  for(int i=0;i<20;i++)
    80003aa4:	00010497          	auipc	s1,0x10
    80003aa8:	93448493          	addi	s1,s1,-1740 # 800133d8 <buffer+0x8>
    80003aac:	00010b17          	auipc	s6,0x10
    80003ab0:	50cb0b13          	addi	s6,s6,1292 # 80013fb8 <proc+0x8>
  {
    // char* s= to_string()
	initsleeplock(&(buffer[i].lock), "lock");
    80003ab4:	00006a97          	auipc	s5,0x6
    80003ab8:	a3ca8a93          	addi	s5,s5,-1476 # 800094f0 <digits+0x4b0>
	initsleeplock(&(buffer[i].inserted.lk), "inserted_lock");
    80003abc:	00006a17          	auipc	s4,0x6
    80003ac0:	a1ca0a13          	addi	s4,s4,-1508 # 800094d8 <digits+0x498>
	initsleeplock(&(buffer[i].deleted.lk), "deleted_lock");
    80003ac4:	00006997          	auipc	s3,0x6
    80003ac8:	a2498993          	addi	s3,s3,-1500 # 800094e8 <digits+0x4a8>
	buffer[i].x=-1;
    80003acc:	597d                	li	s2,-1
	initsleeplock(&(buffer[i].lock), "lock");
    80003ace:	85d6                	mv	a1,s5
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	00002097          	auipc	ra,0x2
    80003ad6:	53c080e7          	jalr	1340(ra) # 8000600e <initsleeplock>
	initsleeplock(&(buffer[i].inserted.lk), "inserted_lock");
    80003ada:	85d2                	mv	a1,s4
    80003adc:	03048513          	addi	a0,s1,48
    80003ae0:	00002097          	auipc	ra,0x2
    80003ae4:	52e080e7          	jalr	1326(ra) # 8000600e <initsleeplock>
	initsleeplock(&(buffer[i].deleted.lk), "deleted_lock");
    80003ae8:	85ce                	mv	a1,s3
    80003aea:	06048513          	addi	a0,s1,96
    80003aee:	00002097          	auipc	ra,0x2
    80003af2:	520080e7          	jalr	1312(ra) # 8000600e <initsleeplock>
	buffer[i].x=-1;
    80003af6:	ff24ac23          	sw	s2,-8(s1)
    buffer[i].full=0;
    80003afa:	fe04ae23          	sw	zero,-4(s1)
  for(int i=0;i<20;i++)
    80003afe:	09848493          	addi	s1,s1,152
    80003b02:	fd6496e3          	bne	s1,s6,80003ace <buffer_cond_init+0x86>
  }
  return;
}
    80003b06:	70e2                	ld	ra,56(sp)
    80003b08:	7442                	ld	s0,48(sp)
    80003b0a:	74a2                	ld	s1,40(sp)
    80003b0c:	7902                	ld	s2,32(sp)
    80003b0e:	69e2                	ld	s3,24(sp)
    80003b10:	6a42                	ld	s4,16(sp)
    80003b12:	6aa2                	ld	s5,8(sp)
    80003b14:	6b02                	ld	s6,0(sp)
    80003b16:	6121                	addi	sp,sp,64
    80003b18:	8082                	ret

0000000080003b1a <cond_produce>:

void cond_produce(int x)
{
    80003b1a:	7139                	addi	sp,sp,-64
    80003b1c:	fc06                	sd	ra,56(sp)
    80003b1e:	f822                	sd	s0,48(sp)
    80003b20:	f426                	sd	s1,40(sp)
    80003b22:	f04a                	sd	s2,32(sp)
    80003b24:	ec4e                	sd	s3,24(sp)
    80003b26:	e852                	sd	s4,16(sp)
    80003b28:	e456                	sd	s5,8(sp)
    80003b2a:	e05a                	sd	s6,0(sp)
    80003b2c:	0080                	addi	s0,sp,64
    80003b2e:	8b2a                	mv	s6,a0
  int index;
  acquiresleep(&lock_insert);
    80003b30:	0000f497          	auipc	s1,0xf
    80003b34:	28048493          	addi	s1,s1,640 # 80012db0 <lock_insert>
    80003b38:	8526                	mv	a0,s1
    80003b3a:	00002097          	auipc	ra,0x2
    80003b3e:	50e080e7          	jalr	1294(ra) # 80006048 <acquiresleep>
  index=tail;
    80003b42:	00006717          	auipc	a4,0x6
    80003b46:	51e70713          	addi	a4,a4,1310 # 8000a060 <tail>
    80003b4a:	00072a03          	lw	s4,0(a4)
  tail=(tail+1)%20;
    80003b4e:	001a079b          	addiw	a5,s4,1
    80003b52:	46d1                	li	a3,20
    80003b54:	02d7e7bb          	remw	a5,a5,a3
    80003b58:	c31c                	sw	a5,0(a4)
  releasesleep(&lock_insert);
    80003b5a:	8526                	mv	a0,s1
    80003b5c:	00002097          	auipc	ra,0x2
    80003b60:	542080e7          	jalr	1346(ra) # 8000609e <releasesleep>
  acquiresleep(&buffer[index].lock);
    80003b64:	09800a93          	li	s5,152
    80003b68:	035a0ab3          	mul	s5,s4,s5
    80003b6c:	008a8493          	addi	s1,s5,8
    80003b70:	00010917          	auipc	s2,0x10
    80003b74:	86090913          	addi	s2,s2,-1952 # 800133d0 <buffer>
    80003b78:	94ca                	add	s1,s1,s2
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	00002097          	auipc	ra,0x2
    80003b80:	4cc080e7          	jalr	1228(ra) # 80006048 <acquiresleep>
  while (buffer[index].full) {
    80003b84:	9956                	add	s2,s2,s5
    80003b86:	00492783          	lw	a5,4(s2)
    80003b8a:	c785                	beqz	a5,80003bb2 <cond_produce+0x98>
    condsleep(&(buffer[index].deleted), &(buffer[index].lock));
    80003b8c:	00010997          	auipc	s3,0x10
    80003b90:	8ac98993          	addi	s3,s3,-1876 # 80013438 <buffer+0x68>
    80003b94:	99d6                	add	s3,s3,s5
  while (buffer[index].full) {
    80003b96:	00010917          	auipc	s2,0x10
    80003b9a:	83a90913          	addi	s2,s2,-1990 # 800133d0 <buffer>
    80003b9e:	9956                	add	s2,s2,s5
    condsleep(&(buffer[index].deleted), &(buffer[index].lock));
    80003ba0:	85a6                	mv	a1,s1
    80003ba2:	854e                	mv	a0,s3
    80003ba4:	00000097          	auipc	ra,0x0
    80003ba8:	a34080e7          	jalr	-1484(ra) # 800035d8 <condsleep>
  while (buffer[index].full) {
    80003bac:	00492783          	lw	a5,4(s2)
    80003bb0:	fbe5                	bnez	a5,80003ba0 <cond_produce+0x86>
  }
  buffer[index].x = x;
    80003bb2:	00010517          	auipc	a0,0x10
    80003bb6:	81e50513          	addi	a0,a0,-2018 # 800133d0 <buffer>
    80003bba:	09800793          	li	a5,152
    80003bbe:	02fa0a33          	mul	s4,s4,a5
    80003bc2:	9a2a                	add	s4,s4,a0
    80003bc4:	016a2023          	sw	s6,0(s4)
  buffer[index].full = 1;
    80003bc8:	4785                	li	a5,1
    80003bca:	00fa2223          	sw	a5,4(s4)
  cond_signal(&(buffer[index].inserted));
    80003bce:	038a8a93          	addi	s5,s5,56
    80003bd2:	9556                	add	a0,a0,s5
    80003bd4:	00004097          	auipc	ra,0x4
    80003bd8:	34a080e7          	jalr	842(ra) # 80007f1e <cond_signal>
  releasesleep(&(buffer[index].lock));
    80003bdc:	8526                	mv	a0,s1
    80003bde:	00002097          	auipc	ra,0x2
    80003be2:	4c0080e7          	jalr	1216(ra) # 8000609e <releasesleep>
}
    80003be6:	70e2                	ld	ra,56(sp)
    80003be8:	7442                	ld	s0,48(sp)
    80003bea:	74a2                	ld	s1,40(sp)
    80003bec:	7902                	ld	s2,32(sp)
    80003bee:	69e2                	ld	s3,24(sp)
    80003bf0:	6a42                	ld	s4,16(sp)
    80003bf2:	6aa2                	ld	s5,8(sp)
    80003bf4:	6b02                	ld	s6,0(sp)
    80003bf6:	6121                	addi	sp,sp,64
    80003bf8:	8082                	ret

0000000080003bfa <cond_consume>:


int cond_consume(void)
{
    80003bfa:	7139                	addi	sp,sp,-64
    80003bfc:	fc06                	sd	ra,56(sp)
    80003bfe:	f822                	sd	s0,48(sp)
    80003c00:	f426                	sd	s1,40(sp)
    80003c02:	f04a                	sd	s2,32(sp)
    80003c04:	ec4e                	sd	s3,24(sp)
    80003c06:	e852                	sd	s4,16(sp)
    80003c08:	e456                	sd	s5,8(sp)
    80003c0a:	0080                	addi	s0,sp,64
  int v, index;
  acquiresleep(&(lock_delete));
    80003c0c:	0000f497          	auipc	s1,0xf
    80003c10:	17448493          	addi	s1,s1,372 # 80012d80 <lock_delete>
    80003c14:	8526                	mv	a0,s1
    80003c16:	00002097          	auipc	ra,0x2
    80003c1a:	432080e7          	jalr	1074(ra) # 80006048 <acquiresleep>
  index=head;
    80003c1e:	00006717          	auipc	a4,0x6
    80003c22:	44670713          	addi	a4,a4,1094 # 8000a064 <head>
    80003c26:	00072a03          	lw	s4,0(a4)
  head=(head+1)%20;
    80003c2a:	001a079b          	addiw	a5,s4,1
    80003c2e:	46d1                	li	a3,20
    80003c30:	02d7e7bb          	remw	a5,a5,a3
    80003c34:	c31c                	sw	a5,0(a4)
  releasesleep(&(lock_delete));
    80003c36:	8526                	mv	a0,s1
    80003c38:	00002097          	auipc	ra,0x2
    80003c3c:	466080e7          	jalr	1126(ra) # 8000609e <releasesleep>
  acquiresleep(&(buffer[index].lock));
    80003c40:	09800a93          	li	s5,152
    80003c44:	035a0ab3          	mul	s5,s4,s5
    80003c48:	008a8493          	addi	s1,s5,8
    80003c4c:	0000f917          	auipc	s2,0xf
    80003c50:	78490913          	addi	s2,s2,1924 # 800133d0 <buffer>
    80003c54:	94ca                	add	s1,s1,s2
    80003c56:	8526                	mv	a0,s1
    80003c58:	00002097          	auipc	ra,0x2
    80003c5c:	3f0080e7          	jalr	1008(ra) # 80006048 <acquiresleep>
  while (!(buffer[index].full)) {
    80003c60:	9956                	add	s2,s2,s5
    80003c62:	00492783          	lw	a5,4(s2)
    80003c66:	e785                	bnez	a5,80003c8e <cond_consume+0x94>
  condsleep(&(buffer[index].inserted), &(buffer[index].lock));
    80003c68:	0000f997          	auipc	s3,0xf
    80003c6c:	7a098993          	addi	s3,s3,1952 # 80013408 <buffer+0x38>
    80003c70:	99d6                	add	s3,s3,s5
  while (!(buffer[index].full)) {
    80003c72:	0000f917          	auipc	s2,0xf
    80003c76:	75e90913          	addi	s2,s2,1886 # 800133d0 <buffer>
    80003c7a:	9956                	add	s2,s2,s5
  condsleep(&(buffer[index].inserted), &(buffer[index].lock));
    80003c7c:	85a6                	mv	a1,s1
    80003c7e:	854e                	mv	a0,s3
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	958080e7          	jalr	-1704(ra) # 800035d8 <condsleep>
  while (!(buffer[index].full)) {
    80003c88:	00492783          	lw	a5,4(s2)
    80003c8c:	dbe5                	beqz	a5,80003c7c <cond_consume+0x82>
  }
  v = buffer[index].x;
    80003c8e:	0000f517          	auipc	a0,0xf
    80003c92:	74250513          	addi	a0,a0,1858 # 800133d0 <buffer>
    80003c96:	09800793          	li	a5,152
    80003c9a:	02fa0a33          	mul	s4,s4,a5
    80003c9e:	9a2a                	add	s4,s4,a0
    80003ca0:	000a2903          	lw	s2,0(s4)
  buffer[index].full = 0;
    80003ca4:	000a2223          	sw	zero,4(s4)
  cond_signal(&(buffer[index].deleted));
    80003ca8:	068a8a93          	addi	s5,s5,104
    80003cac:	9556                	add	a0,a0,s5
    80003cae:	00004097          	auipc	ra,0x4
    80003cb2:	270080e7          	jalr	624(ra) # 80007f1e <cond_signal>
  releasesleep(&(buffer[index].lock));
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	00002097          	auipc	ra,0x2
    80003cbc:	3e6080e7          	jalr	998(ra) # 8000609e <releasesleep>
  acquiresleep(&(lock_print));
    80003cc0:	0000f497          	auipc	s1,0xf
    80003cc4:	09048493          	addi	s1,s1,144 # 80012d50 <lock_print>
    80003cc8:	8526                	mv	a0,s1
    80003cca:	00002097          	auipc	ra,0x2
    80003cce:	37e080e7          	jalr	894(ra) # 80006048 <acquiresleep>
  printf("%d ", v); 
    80003cd2:	85ca                	mv	a1,s2
    80003cd4:	00006517          	auipc	a0,0x6
    80003cd8:	82450513          	addi	a0,a0,-2012 # 800094f8 <digits+0x4b8>
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	8aa080e7          	jalr	-1878(ra) # 80000586 <printf>
  releasesleep(&(lock_print));
    80003ce4:	8526                	mv	a0,s1
    80003ce6:	00002097          	auipc	ra,0x2
    80003cea:	3b8080e7          	jalr	952(ra) # 8000609e <releasesleep>
  return v;
}
    80003cee:	854a                	mv	a0,s2
    80003cf0:	70e2                	ld	ra,56(sp)
    80003cf2:	7442                	ld	s0,48(sp)
    80003cf4:	74a2                	ld	s1,40(sp)
    80003cf6:	7902                	ld	s2,32(sp)
    80003cf8:	69e2                	ld	s3,24(sp)
    80003cfa:	6a42                	ld	s4,16(sp)
    80003cfc:	6aa2                	ld	s5,8(sp)
    80003cfe:	6121                	addi	sp,sp,64
    80003d00:	8082                	ret

0000000080003d02 <buffer_sem_init>:


void buffer_sem_init(void)
{
    80003d02:	7139                	addi	sp,sp,-64
    80003d04:	fc06                	sd	ra,56(sp)
    80003d06:	f822                	sd	s0,48(sp)
    80003d08:	f426                	sd	s1,40(sp)
    80003d0a:	f04a                	sd	s2,32(sp)
    80003d0c:	ec4e                	sd	s3,24(sp)
    80003d0e:	e852                	sd	s4,16(sp)
    80003d10:	e456                	sd	s5,8(sp)
    80003d12:	0080                	addi	s0,sp,64
	initsleeplock(&(lock_sem_print), "lock_sem_print");
    80003d14:	00005597          	auipc	a1,0x5
    80003d18:	7ec58593          	addi	a1,a1,2028 # 80009500 <digits+0x4c0>
    80003d1c:	0000f517          	auipc	a0,0xf
    80003d20:	0c450513          	addi	a0,a0,196 # 80012de0 <lock_sem_print>
    80003d24:	00002097          	auipc	ra,0x2
    80003d28:	2ea080e7          	jalr	746(ra) # 8000600e <initsleeplock>
	initsleeplock(&(lock_sem_delete), "lock_sem_delete");
    80003d2c:	00005597          	auipc	a1,0x5
    80003d30:	7e458593          	addi	a1,a1,2020 # 80009510 <digits+0x4d0>
    80003d34:	0000f517          	auipc	a0,0xf
    80003d38:	0dc50513          	addi	a0,a0,220 # 80012e10 <lock_sem_delete>
    80003d3c:	00002097          	auipc	ra,0x2
    80003d40:	2d2080e7          	jalr	722(ra) # 8000600e <initsleeplock>
	initsleeplock(&(lock_sem_insert), "lock_sem_insert");
    80003d44:	00005597          	auipc	a1,0x5
    80003d48:	7dc58593          	addi	a1,a1,2012 # 80009520 <digits+0x4e0>
    80003d4c:	0000f517          	auipc	a0,0xf
    80003d50:	0f450513          	addi	a0,a0,244 # 80012e40 <lock_sem_insert>
    80003d54:	00002097          	auipc	ra,0x2
    80003d58:	2ba080e7          	jalr	698(ra) # 8000600e <initsleeplock>
	sem_init(&(empty),20);
    80003d5c:	45d1                	li	a1,20
    80003d5e:	0000f517          	auipc	a0,0xf
    80003d62:	11250513          	addi	a0,a0,274 # 80012e70 <empty>
    80003d66:	00004097          	auipc	ra,0x4
    80003d6a:	1e8080e7          	jalr	488(ra) # 80007f4e <sem_init>
	sem_init(&full,0);
    80003d6e:	4581                	li	a1,0
    80003d70:	0000f517          	auipc	a0,0xf
    80003d74:	14050513          	addi	a0,a0,320 # 80012eb0 <full>
    80003d78:	00004097          	auipc	ra,0x4
    80003d7c:	1d6080e7          	jalr	470(ra) # 80007f4e <sem_init>
	sem_init(&pro,1);
    80003d80:	4585                	li	a1,1
    80003d82:	0000f517          	auipc	a0,0xf
    80003d86:	16e50513          	addi	a0,a0,366 # 80012ef0 <pro>
    80003d8a:	00004097          	auipc	ra,0x4
    80003d8e:	1c4080e7          	jalr	452(ra) # 80007f4e <sem_init>
	sem_init(&con,1);
    80003d92:	4585                	li	a1,1
    80003d94:	0000f517          	auipc	a0,0xf
    80003d98:	19c50513          	addi	a0,a0,412 # 80012f30 <con>
    80003d9c:	00004097          	auipc	ra,0x4
    80003da0:	1b2080e7          	jalr	434(ra) # 80007f4e <sem_init>
	for(int i=0;i<20;i++)
    80003da4:	0000f917          	auipc	s2,0xf
    80003da8:	1d490913          	addi	s2,s2,468 # 80012f78 <sem_buffer+0x8>
    80003dac:	0000f497          	auipc	s1,0xf
    80003db0:	62448493          	addi	s1,s1,1572 # 800133d0 <buffer>
    80003db4:	00010a97          	auipc	s5,0x10
    80003db8:	1fca8a93          	addi	s5,s5,508 # 80013fb0 <proc>
	{
		initsleeplock(&(sem_buffer[i].sem_lock), "sem_lock");
    80003dbc:	00005a17          	auipc	s4,0x5
    80003dc0:	774a0a13          	addi	s4,s4,1908 # 80009530 <digits+0x4f0>
		buffer[i].x=-1;
    80003dc4:	59fd                	li	s3,-1
		initsleeplock(&(sem_buffer[i].sem_lock), "sem_lock");
    80003dc6:	85d2                	mv	a1,s4
    80003dc8:	854a                	mv	a0,s2
    80003dca:	00002097          	auipc	ra,0x2
    80003dce:	244080e7          	jalr	580(ra) # 8000600e <initsleeplock>
		buffer[i].x=-1;
    80003dd2:	0134a023          	sw	s3,0(s1)
		buffer[i].full=0;
    80003dd6:	0004a223          	sw	zero,4(s1)
	for(int i=0;i<20;i++)
    80003dda:	03890913          	addi	s2,s2,56
    80003dde:	09848493          	addi	s1,s1,152
    80003de2:	ff5492e3          	bne	s1,s5,80003dc6 <buffer_sem_init+0xc4>
	}
  	return;
}
    80003de6:	70e2                	ld	ra,56(sp)
    80003de8:	7442                	ld	s0,48(sp)
    80003dea:	74a2                	ld	s1,40(sp)
    80003dec:	7902                	ld	s2,32(sp)
    80003dee:	69e2                	ld	s3,24(sp)
    80003df0:	6a42                	ld	s4,16(sp)
    80003df2:	6aa2                	ld	s5,8(sp)
    80003df4:	6121                	addi	sp,sp,64
    80003df6:	8082                	ret

0000000080003df8 <sem_produce>:

void sem_produce(int x)
{
    80003df8:	1101                	addi	sp,sp,-32
    80003dfa:	ec06                	sd	ra,24(sp)
    80003dfc:	e822                	sd	s0,16(sp)
    80003dfe:	e426                	sd	s1,8(sp)
    80003e00:	e04a                	sd	s2,0(sp)
    80003e02:	1000                	addi	s0,sp,32
    80003e04:	84aa                	mv	s1,a0
	// if(item==-1)
	// {
	// 	sem_post(&full);
	// }
	// else sem_post(&empty);
	sem_wait(&empty);
    80003e06:	0000f517          	auipc	a0,0xf
    80003e0a:	06a50513          	addi	a0,a0,106 # 80012e70 <empty>
    80003e0e:	00004097          	auipc	ra,0x4
    80003e12:	170080e7          	jalr	368(ra) # 80007f7e <sem_wait>
	sem_wait(&pro);
    80003e16:	0000f917          	auipc	s2,0xf
    80003e1a:	0da90913          	addi	s2,s2,218 # 80012ef0 <pro>
    80003e1e:	854a                	mv	a0,s2
    80003e20:	00004097          	auipc	ra,0x4
    80003e24:	15e080e7          	jalr	350(ra) # 80007f7e <sem_wait>
	buffer[nextp].x= x;
    80003e28:	00006617          	auipc	a2,0x6
    80003e2c:	24460613          	addi	a2,a2,580 # 8000a06c <nextp>
    80003e30:	421c                	lw	a5,0(a2)
    80003e32:	09800713          	li	a4,152
    80003e36:	02e786b3          	mul	a3,a5,a4
    80003e3a:	0000f717          	auipc	a4,0xf
    80003e3e:	59670713          	addi	a4,a4,1430 # 800133d0 <buffer>
    80003e42:	9736                	add	a4,a4,a3
    80003e44:	c304                	sw	s1,0(a4)
	nextp= (nextp+1)%20;
    80003e46:	2785                	addiw	a5,a5,1
    80003e48:	4751                	li	a4,20
    80003e4a:	02e7e7bb          	remw	a5,a5,a4
    80003e4e:	c21c                	sw	a5,0(a2)
	sem_post(&pro);
    80003e50:	854a                	mv	a0,s2
    80003e52:	00004097          	auipc	ra,0x4
    80003e56:	172080e7          	jalr	370(ra) # 80007fc4 <sem_post>
	sem_post(&full);
    80003e5a:	0000f517          	auipc	a0,0xf
    80003e5e:	05650513          	addi	a0,a0,86 # 80012eb0 <full>
    80003e62:	00004097          	auipc	ra,0x4
    80003e66:	162080e7          	jalr	354(ra) # 80007fc4 <sem_post>
}
    80003e6a:	60e2                	ld	ra,24(sp)
    80003e6c:	6442                	ld	s0,16(sp)
    80003e6e:	64a2                	ld	s1,8(sp)
    80003e70:	6902                	ld	s2,0(sp)
    80003e72:	6105                	addi	sp,sp,32
    80003e74:	8082                	ret

0000000080003e76 <sem_consume>:


int sem_consume(void)
{
    80003e76:	1101                	addi	sp,sp,-32
    80003e78:	ec06                	sd	ra,24(sp)
    80003e7a:	e822                	sd	s0,16(sp)
    80003e7c:	e426                	sd	s1,8(sp)
    80003e7e:	e04a                	sd	s2,0(sp)
    80003e80:	1000                	addi	s0,sp,32
	// acquiresleep(&(lock_print));
	// printf("%d ", v); 
	// releasesleep(&(lock_print));
	// return v;
	int v;
	sem_wait(&full);
    80003e82:	0000f517          	auipc	a0,0xf
    80003e86:	02e50513          	addi	a0,a0,46 # 80012eb0 <full>
    80003e8a:	00004097          	auipc	ra,0x4
    80003e8e:	0f4080e7          	jalr	244(ra) # 80007f7e <sem_wait>
	sem_wait(&con);
    80003e92:	0000f917          	auipc	s2,0xf
    80003e96:	09e90913          	addi	s2,s2,158 # 80012f30 <con>
    80003e9a:	854a                	mv	a0,s2
    80003e9c:	00004097          	auipc	ra,0x4
    80003ea0:	0e2080e7          	jalr	226(ra) # 80007f7e <sem_wait>
	v= buffer[nextc].x;
    80003ea4:	00006617          	auipc	a2,0x6
    80003ea8:	1c460613          	addi	a2,a2,452 # 8000a068 <nextc>
    80003eac:	421c                	lw	a5,0(a2)
    80003eae:	09800713          	li	a4,152
    80003eb2:	02e786b3          	mul	a3,a5,a4
    80003eb6:	0000f717          	auipc	a4,0xf
    80003eba:	51a70713          	addi	a4,a4,1306 # 800133d0 <buffer>
    80003ebe:	9736                	add	a4,a4,a3
    80003ec0:	4304                	lw	s1,0(a4)
	nextc= (nextc+1)%20;
    80003ec2:	2785                	addiw	a5,a5,1
    80003ec4:	4751                	li	a4,20
    80003ec6:	02e7e7bb          	remw	a5,a5,a4
    80003eca:	c21c                	sw	a5,0(a2)
	sem_post(&con);
    80003ecc:	854a                	mv	a0,s2
    80003ece:	00004097          	auipc	ra,0x4
    80003ed2:	0f6080e7          	jalr	246(ra) # 80007fc4 <sem_post>
	sem_post(&empty);
    80003ed6:	0000f517          	auipc	a0,0xf
    80003eda:	f9a50513          	addi	a0,a0,-102 # 80012e70 <empty>
    80003ede:	00004097          	auipc	ra,0x4
    80003ee2:	0e6080e7          	jalr	230(ra) # 80007fc4 <sem_post>
	acquiresleep(&lock_sem_print);
    80003ee6:	0000f917          	auipc	s2,0xf
    80003eea:	efa90913          	addi	s2,s2,-262 # 80012de0 <lock_sem_print>
    80003eee:	854a                	mv	a0,s2
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	158080e7          	jalr	344(ra) # 80006048 <acquiresleep>
	printf("%d ", v); 
    80003ef8:	85a6                	mv	a1,s1
    80003efa:	00005517          	auipc	a0,0x5
    80003efe:	5fe50513          	addi	a0,a0,1534 # 800094f8 <digits+0x4b8>
    80003f02:	ffffc097          	auipc	ra,0xffffc
    80003f06:	684080e7          	jalr	1668(ra) # 80000586 <printf>
	releasesleep(&lock_sem_print);
    80003f0a:	854a                	mv	a0,s2
    80003f0c:	00002097          	auipc	ra,0x2
    80003f10:	192080e7          	jalr	402(ra) # 8000609e <releasesleep>
	return v;

}
    80003f14:	8526                	mv	a0,s1
    80003f16:	60e2                	ld	ra,24(sp)
    80003f18:	6442                	ld	s0,16(sp)
    80003f1a:	64a2                	ld	s1,8(sp)
    80003f1c:	6902                	ld	s2,0(sp)
    80003f1e:	6105                	addi	sp,sp,32
    80003f20:	8082                	ret

0000000080003f22 <swtch>:
    80003f22:	00153023          	sd	ra,0(a0)
    80003f26:	00253423          	sd	sp,8(a0)
    80003f2a:	e900                	sd	s0,16(a0)
    80003f2c:	ed04                	sd	s1,24(a0)
    80003f2e:	03253023          	sd	s2,32(a0)
    80003f32:	03353423          	sd	s3,40(a0)
    80003f36:	03453823          	sd	s4,48(a0)
    80003f3a:	03553c23          	sd	s5,56(a0)
    80003f3e:	05653023          	sd	s6,64(a0)
    80003f42:	05753423          	sd	s7,72(a0)
    80003f46:	05853823          	sd	s8,80(a0)
    80003f4a:	05953c23          	sd	s9,88(a0)
    80003f4e:	07a53023          	sd	s10,96(a0)
    80003f52:	07b53423          	sd	s11,104(a0)
    80003f56:	0005b083          	ld	ra,0(a1)
    80003f5a:	0085b103          	ld	sp,8(a1)
    80003f5e:	6980                	ld	s0,16(a1)
    80003f60:	6d84                	ld	s1,24(a1)
    80003f62:	0205b903          	ld	s2,32(a1)
    80003f66:	0285b983          	ld	s3,40(a1)
    80003f6a:	0305ba03          	ld	s4,48(a1)
    80003f6e:	0385ba83          	ld	s5,56(a1)
    80003f72:	0405bb03          	ld	s6,64(a1)
    80003f76:	0485bb83          	ld	s7,72(a1)
    80003f7a:	0505bc03          	ld	s8,80(a1)
    80003f7e:	0585bc83          	ld	s9,88(a1)
    80003f82:	0605bd03          	ld	s10,96(a1)
    80003f86:	0685bd83          	ld	s11,104(a1)
    80003f8a:	8082                	ret

0000000080003f8c <trapinit>:

extern int sched_policy;

void
trapinit(void)
{
    80003f8c:	1141                	addi	sp,sp,-16
    80003f8e:	e406                	sd	ra,8(sp)
    80003f90:	e022                	sd	s0,0(sp)
    80003f92:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003f94:	00005597          	auipc	a1,0x5
    80003f98:	67458593          	addi	a1,a1,1652 # 80009608 <states.2619+0x30>
    80003f9c:	00016517          	auipc	a0,0x16
    80003fa0:	41450513          	addi	a0,a0,1044 # 8001a3b0 <tickslock>
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	bae080e7          	jalr	-1106(ra) # 80000b52 <initlock>
}
    80003fac:	60a2                	ld	ra,8(sp)
    80003fae:	6402                	ld	s0,0(sp)
    80003fb0:	0141                	addi	sp,sp,16
    80003fb2:	8082                	ret

0000000080003fb4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003fb4:	1141                	addi	sp,sp,-16
    80003fb6:	e422                	sd	s0,8(sp)
    80003fb8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003fba:	00004797          	auipc	a5,0x4
    80003fbe:	87678793          	addi	a5,a5,-1930 # 80007830 <kernelvec>
    80003fc2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003fc6:	6422                	ld	s0,8(sp)
    80003fc8:	0141                	addi	sp,sp,16
    80003fca:	8082                	ret

0000000080003fcc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003fcc:	1141                	addi	sp,sp,-16
    80003fce:	e406                	sd	ra,8(sp)
    80003fd0:	e022                	sd	s0,0(sp)
    80003fd2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003fd4:	ffffe097          	auipc	ra,0xffffe
    80003fd8:	9e4080e7          	jalr	-1564(ra) # 800019b8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003fdc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003fe0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003fe2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80003fe6:	00004617          	auipc	a2,0x4
    80003fea:	01a60613          	addi	a2,a2,26 # 80008000 <_trampoline>
    80003fee:	00004697          	auipc	a3,0x4
    80003ff2:	01268693          	addi	a3,a3,18 # 80008000 <_trampoline>
    80003ff6:	8e91                	sub	a3,a3,a2
    80003ff8:	040007b7          	lui	a5,0x4000
    80003ffc:	17fd                	addi	a5,a5,-1
    80003ffe:	07b2                	slli	a5,a5,0xc
    80004000:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80004002:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80004006:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80004008:	180026f3          	csrr	a3,satp
    8000400c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000400e:	7138                	ld	a4,96(a0)
    80004010:	6534                	ld	a3,72(a0)
    80004012:	6585                	lui	a1,0x1
    80004014:	96ae                	add	a3,a3,a1
    80004016:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80004018:	7138                	ld	a4,96(a0)
    8000401a:	00000697          	auipc	a3,0x0
    8000401e:	13868693          	addi	a3,a3,312 # 80004152 <usertrap>
    80004022:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80004024:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80004026:	8692                	mv	a3,tp
    80004028:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000402a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000402e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80004032:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80004036:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000403a:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000403c:	6f18                	ld	a4,24(a4)
    8000403e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80004042:	6d2c                	ld	a1,88(a0)
    80004044:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80004046:	00004717          	auipc	a4,0x4
    8000404a:	04a70713          	addi	a4,a4,74 # 80008090 <userret>
    8000404e:	8f11                	sub	a4,a4,a2
    80004050:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80004052:	577d                	li	a4,-1
    80004054:	177e                	slli	a4,a4,0x3f
    80004056:	8dd9                	or	a1,a1,a4
    80004058:	02000537          	lui	a0,0x2000
    8000405c:	157d                	addi	a0,a0,-1
    8000405e:	0536                	slli	a0,a0,0xd
    80004060:	9782                	jalr	a5
}
    80004062:	60a2                	ld	ra,8(sp)
    80004064:	6402                	ld	s0,0(sp)
    80004066:	0141                	addi	sp,sp,16
    80004068:	8082                	ret

000000008000406a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000406a:	1101                	addi	sp,sp,-32
    8000406c:	ec06                	sd	ra,24(sp)
    8000406e:	e822                	sd	s0,16(sp)
    80004070:	e426                	sd	s1,8(sp)
    80004072:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80004074:	00016497          	auipc	s1,0x16
    80004078:	33c48493          	addi	s1,s1,828 # 8001a3b0 <tickslock>
    8000407c:	8526                	mv	a0,s1
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	b64080e7          	jalr	-1180(ra) # 80000be2 <acquire>
  ticks++;
    80004086:	00006517          	auipc	a0,0x6
    8000408a:	ff650513          	addi	a0,a0,-10 # 8000a07c <ticks>
    8000408e:	411c                	lw	a5,0(a0)
    80004090:	2785                	addiw	a5,a5,1
    80004092:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	acc080e7          	jalr	-1332(ra) # 80002b60 <wakeup>
  release(&tickslock);
    8000409c:	8526                	mv	a0,s1
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	bf8080e7          	jalr	-1032(ra) # 80000c96 <release>
}
    800040a6:	60e2                	ld	ra,24(sp)
    800040a8:	6442                	ld	s0,16(sp)
    800040aa:	64a2                	ld	s1,8(sp)
    800040ac:	6105                	addi	sp,sp,32
    800040ae:	8082                	ret

00000000800040b0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800040b0:	1101                	addi	sp,sp,-32
    800040b2:	ec06                	sd	ra,24(sp)
    800040b4:	e822                	sd	s0,16(sp)
    800040b6:	e426                	sd	s1,8(sp)
    800040b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800040ba:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800040be:	00074d63          	bltz	a4,800040d8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800040c2:	57fd                	li	a5,-1
    800040c4:	17fe                	slli	a5,a5,0x3f
    800040c6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800040c8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800040ca:	06f70363          	beq	a4,a5,80004130 <devintr+0x80>
  }
}
    800040ce:	60e2                	ld	ra,24(sp)
    800040d0:	6442                	ld	s0,16(sp)
    800040d2:	64a2                	ld	s1,8(sp)
    800040d4:	6105                	addi	sp,sp,32
    800040d6:	8082                	ret
     (scause & 0xff) == 9){
    800040d8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800040dc:	46a5                	li	a3,9
    800040de:	fed792e3          	bne	a5,a3,800040c2 <devintr+0x12>
    int irq = plic_claim();
    800040e2:	00004097          	auipc	ra,0x4
    800040e6:	856080e7          	jalr	-1962(ra) # 80007938 <plic_claim>
    800040ea:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800040ec:	47a9                	li	a5,10
    800040ee:	02f50763          	beq	a0,a5,8000411c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800040f2:	4785                	li	a5,1
    800040f4:	02f50963          	beq	a0,a5,80004126 <devintr+0x76>
    return 1;
    800040f8:	4505                	li	a0,1
    } else if(irq){
    800040fa:	d8f1                	beqz	s1,800040ce <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800040fc:	85a6                	mv	a1,s1
    800040fe:	00005517          	auipc	a0,0x5
    80004102:	51250513          	addi	a0,a0,1298 # 80009610 <states.2619+0x38>
    80004106:	ffffc097          	auipc	ra,0xffffc
    8000410a:	480080e7          	jalr	1152(ra) # 80000586 <printf>
      plic_complete(irq);
    8000410e:	8526                	mv	a0,s1
    80004110:	00004097          	auipc	ra,0x4
    80004114:	84c080e7          	jalr	-1972(ra) # 8000795c <plic_complete>
    return 1;
    80004118:	4505                	li	a0,1
    8000411a:	bf55                	j	800040ce <devintr+0x1e>
      uartintr();
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	88a080e7          	jalr	-1910(ra) # 800009a6 <uartintr>
    80004124:	b7ed                	j	8000410e <devintr+0x5e>
      virtio_disk_intr();
    80004126:	00004097          	auipc	ra,0x4
    8000412a:	d16080e7          	jalr	-746(ra) # 80007e3c <virtio_disk_intr>
    8000412e:	b7c5                	j	8000410e <devintr+0x5e>
    if(cpuid() == 0){
    80004130:	ffffe097          	auipc	ra,0xffffe
    80004134:	85c080e7          	jalr	-1956(ra) # 8000198c <cpuid>
    80004138:	c901                	beqz	a0,80004148 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000413a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000413e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80004140:	14479073          	csrw	sip,a5
    return 2;
    80004144:	4509                	li	a0,2
    80004146:	b761                	j	800040ce <devintr+0x1e>
      clockintr();
    80004148:	00000097          	auipc	ra,0x0
    8000414c:	f22080e7          	jalr	-222(ra) # 8000406a <clockintr>
    80004150:	b7ed                	j	8000413a <devintr+0x8a>

0000000080004152 <usertrap>:
{
    80004152:	1101                	addi	sp,sp,-32
    80004154:	ec06                	sd	ra,24(sp)
    80004156:	e822                	sd	s0,16(sp)
    80004158:	e426                	sd	s1,8(sp)
    8000415a:	e04a                	sd	s2,0(sp)
    8000415c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000415e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80004162:	1007f793          	andi	a5,a5,256
    80004166:	e3ad                	bnez	a5,800041c8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80004168:	00003797          	auipc	a5,0x3
    8000416c:	6c878793          	addi	a5,a5,1736 # 80007830 <kernelvec>
    80004170:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80004174:	ffffe097          	auipc	ra,0xffffe
    80004178:	844080e7          	jalr	-1980(ra) # 800019b8 <myproc>
    8000417c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000417e:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80004180:	14102773          	csrr	a4,sepc
    80004184:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80004186:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000418a:	47a1                	li	a5,8
    8000418c:	04f71c63          	bne	a4,a5,800041e4 <usertrap+0x92>
    if(p->killed)
    80004190:	551c                	lw	a5,40(a0)
    80004192:	e3b9                	bnez	a5,800041d8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80004194:	70b8                	ld	a4,96(s1)
    80004196:	6f1c                	ld	a5,24(a4)
    80004198:	0791                	addi	a5,a5,4
    8000419a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000419c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800041a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800041a4:	10079073          	csrw	sstatus,a5
    syscall();
    800041a8:	00000097          	auipc	ra,0x0
    800041ac:	2fc080e7          	jalr	764(ra) # 800044a4 <syscall>
  if(p->killed)
    800041b0:	549c                	lw	a5,40(s1)
    800041b2:	efd9                	bnez	a5,80004250 <usertrap+0xfe>
  usertrapret();
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	e18080e7          	jalr	-488(ra) # 80003fcc <usertrapret>
}
    800041bc:	60e2                	ld	ra,24(sp)
    800041be:	6442                	ld	s0,16(sp)
    800041c0:	64a2                	ld	s1,8(sp)
    800041c2:	6902                	ld	s2,0(sp)
    800041c4:	6105                	addi	sp,sp,32
    800041c6:	8082                	ret
    panic("usertrap: not from user mode");
    800041c8:	00005517          	auipc	a0,0x5
    800041cc:	46850513          	addi	a0,a0,1128 # 80009630 <states.2619+0x58>
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	36c080e7          	jalr	876(ra) # 8000053c <panic>
      exit(-1);
    800041d8:	557d                	li	a0,-1
    800041da:	fffff097          	auipc	ra,0xfffff
    800041de:	aa2080e7          	jalr	-1374(ra) # 80002c7c <exit>
    800041e2:	bf4d                	j	80004194 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800041e4:	00000097          	auipc	ra,0x0
    800041e8:	ecc080e7          	jalr	-308(ra) # 800040b0 <devintr>
    800041ec:	892a                	mv	s2,a0
    800041ee:	c501                	beqz	a0,800041f6 <usertrap+0xa4>
  if(p->killed)
    800041f0:	549c                	lw	a5,40(s1)
    800041f2:	c3a1                	beqz	a5,80004232 <usertrap+0xe0>
    800041f4:	a815                	j	80004228 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800041f6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800041fa:	5890                	lw	a2,48(s1)
    800041fc:	00005517          	auipc	a0,0x5
    80004200:	45450513          	addi	a0,a0,1108 # 80009650 <states.2619+0x78>
    80004204:	ffffc097          	auipc	ra,0xffffc
    80004208:	382080e7          	jalr	898(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000420c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80004210:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80004214:	00005517          	auipc	a0,0x5
    80004218:	46c50513          	addi	a0,a0,1132 # 80009680 <states.2619+0xa8>
    8000421c:	ffffc097          	auipc	ra,0xffffc
    80004220:	36a080e7          	jalr	874(ra) # 80000586 <printf>
    p->killed = 1;
    80004224:	4785                	li	a5,1
    80004226:	d49c                	sw	a5,40(s1)
    exit(-1);
    80004228:	557d                	li	a0,-1
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	a52080e7          	jalr	-1454(ra) # 80002c7c <exit>
  if(which_dev == 2) {
    80004232:	4789                	li	a5,2
    80004234:	f8f910e3          	bne	s2,a5,800041b4 <usertrap+0x62>
    if ((sched_policy != SCHED_NPREEMPT_FCFS) && (sched_policy != SCHED_NPREEMPT_SJF)) yield();
    80004238:	00006717          	auipc	a4,0x6
    8000423c:	e4072703          	lw	a4,-448(a4) # 8000a078 <sched_policy>
    80004240:	4785                	li	a5,1
    80004242:	f6e7f9e3          	bgeu	a5,a4,800041b4 <usertrap+0x62>
    80004246:	ffffe097          	auipc	ra,0xffffe
    8000424a:	3a8080e7          	jalr	936(ra) # 800025ee <yield>
    8000424e:	b79d                	j	800041b4 <usertrap+0x62>
  int which_dev = 0;
    80004250:	4901                	li	s2,0
    80004252:	bfd9                	j	80004228 <usertrap+0xd6>

0000000080004254 <kerneltrap>:
{
    80004254:	7179                	addi	sp,sp,-48
    80004256:	f406                	sd	ra,40(sp)
    80004258:	f022                	sd	s0,32(sp)
    8000425a:	ec26                	sd	s1,24(sp)
    8000425c:	e84a                	sd	s2,16(sp)
    8000425e:	e44e                	sd	s3,8(sp)
    80004260:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80004262:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80004266:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000426a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000426e:	1004f793          	andi	a5,s1,256
    80004272:	cb85                	beqz	a5,800042a2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80004274:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80004278:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000427a:	ef85                	bnez	a5,800042b2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000427c:	00000097          	auipc	ra,0x0
    80004280:	e34080e7          	jalr	-460(ra) # 800040b0 <devintr>
    80004284:	cd1d                	beqz	a0,800042c2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    80004286:	4789                	li	a5,2
    80004288:	06f50a63          	beq	a0,a5,800042fc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000428c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80004290:	10049073          	csrw	sstatus,s1
}
    80004294:	70a2                	ld	ra,40(sp)
    80004296:	7402                	ld	s0,32(sp)
    80004298:	64e2                	ld	s1,24(sp)
    8000429a:	6942                	ld	s2,16(sp)
    8000429c:	69a2                	ld	s3,8(sp)
    8000429e:	6145                	addi	sp,sp,48
    800042a0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800042a2:	00005517          	auipc	a0,0x5
    800042a6:	3fe50513          	addi	a0,a0,1022 # 800096a0 <states.2619+0xc8>
    800042aa:	ffffc097          	auipc	ra,0xffffc
    800042ae:	292080e7          	jalr	658(ra) # 8000053c <panic>
    panic("kerneltrap: interrupts enabled");
    800042b2:	00005517          	auipc	a0,0x5
    800042b6:	41650513          	addi	a0,a0,1046 # 800096c8 <states.2619+0xf0>
    800042ba:	ffffc097          	auipc	ra,0xffffc
    800042be:	282080e7          	jalr	642(ra) # 8000053c <panic>
    printf("scause %p\n", scause);
    800042c2:	85ce                	mv	a1,s3
    800042c4:	00005517          	auipc	a0,0x5
    800042c8:	42450513          	addi	a0,a0,1060 # 800096e8 <states.2619+0x110>
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	2ba080e7          	jalr	698(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800042d4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800042d8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800042dc:	00005517          	auipc	a0,0x5
    800042e0:	41c50513          	addi	a0,a0,1052 # 800096f8 <states.2619+0x120>
    800042e4:	ffffc097          	auipc	ra,0xffffc
    800042e8:	2a2080e7          	jalr	674(ra) # 80000586 <printf>
    panic("kerneltrap");
    800042ec:	00005517          	auipc	a0,0x5
    800042f0:	42450513          	addi	a0,a0,1060 # 80009710 <states.2619+0x138>
    800042f4:	ffffc097          	auipc	ra,0xffffc
    800042f8:	248080e7          	jalr	584(ra) # 8000053c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) {
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	6bc080e7          	jalr	1724(ra) # 800019b8 <myproc>
    80004304:	d541                	beqz	a0,8000428c <kerneltrap+0x38>
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	6b2080e7          	jalr	1714(ra) # 800019b8 <myproc>
    8000430e:	4d18                	lw	a4,24(a0)
    80004310:	4791                	li	a5,4
    80004312:	f6f71de3          	bne	a4,a5,8000428c <kerneltrap+0x38>
     if ((sched_policy != SCHED_NPREEMPT_FCFS) && (sched_policy != SCHED_NPREEMPT_SJF)) yield();
    80004316:	00006717          	auipc	a4,0x6
    8000431a:	d6272703          	lw	a4,-670(a4) # 8000a078 <sched_policy>
    8000431e:	4785                	li	a5,1
    80004320:	f6e7f6e3          	bgeu	a5,a4,8000428c <kerneltrap+0x38>
    80004324:	ffffe097          	auipc	ra,0xffffe
    80004328:	2ca080e7          	jalr	714(ra) # 800025ee <yield>
    8000432c:	b785                	j	8000428c <kerneltrap+0x38>

000000008000432e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000432e:	1101                	addi	sp,sp,-32
    80004330:	ec06                	sd	ra,24(sp)
    80004332:	e822                	sd	s0,16(sp)
    80004334:	e426                	sd	s1,8(sp)
    80004336:	1000                	addi	s0,sp,32
    80004338:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	67e080e7          	jalr	1662(ra) # 800019b8 <myproc>
  switch (n) {
    80004342:	4795                	li	a5,5
    80004344:	0497e163          	bltu	a5,s1,80004386 <argraw+0x58>
    80004348:	048a                	slli	s1,s1,0x2
    8000434a:	00005717          	auipc	a4,0x5
    8000434e:	3fe70713          	addi	a4,a4,1022 # 80009748 <states.2619+0x170>
    80004352:	94ba                	add	s1,s1,a4
    80004354:	409c                	lw	a5,0(s1)
    80004356:	97ba                	add	a5,a5,a4
    80004358:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000435a:	713c                	ld	a5,96(a0)
    8000435c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000435e:	60e2                	ld	ra,24(sp)
    80004360:	6442                	ld	s0,16(sp)
    80004362:	64a2                	ld	s1,8(sp)
    80004364:	6105                	addi	sp,sp,32
    80004366:	8082                	ret
    return p->trapframe->a1;
    80004368:	713c                	ld	a5,96(a0)
    8000436a:	7fa8                	ld	a0,120(a5)
    8000436c:	bfcd                	j	8000435e <argraw+0x30>
    return p->trapframe->a2;
    8000436e:	713c                	ld	a5,96(a0)
    80004370:	63c8                	ld	a0,128(a5)
    80004372:	b7f5                	j	8000435e <argraw+0x30>
    return p->trapframe->a3;
    80004374:	713c                	ld	a5,96(a0)
    80004376:	67c8                	ld	a0,136(a5)
    80004378:	b7dd                	j	8000435e <argraw+0x30>
    return p->trapframe->a4;
    8000437a:	713c                	ld	a5,96(a0)
    8000437c:	6bc8                	ld	a0,144(a5)
    8000437e:	b7c5                	j	8000435e <argraw+0x30>
    return p->trapframe->a5;
    80004380:	713c                	ld	a5,96(a0)
    80004382:	6fc8                	ld	a0,152(a5)
    80004384:	bfe9                	j	8000435e <argraw+0x30>
  panic("argraw");
    80004386:	00005517          	auipc	a0,0x5
    8000438a:	39a50513          	addi	a0,a0,922 # 80009720 <states.2619+0x148>
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	1ae080e7          	jalr	430(ra) # 8000053c <panic>

0000000080004396 <fetchaddr>:
{
    80004396:	1101                	addi	sp,sp,-32
    80004398:	ec06                	sd	ra,24(sp)
    8000439a:	e822                	sd	s0,16(sp)
    8000439c:	e426                	sd	s1,8(sp)
    8000439e:	e04a                	sd	s2,0(sp)
    800043a0:	1000                	addi	s0,sp,32
    800043a2:	84aa                	mv	s1,a0
    800043a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800043a6:	ffffd097          	auipc	ra,0xffffd
    800043aa:	612080e7          	jalr	1554(ra) # 800019b8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800043ae:	693c                	ld	a5,80(a0)
    800043b0:	02f4f863          	bgeu	s1,a5,800043e0 <fetchaddr+0x4a>
    800043b4:	00848713          	addi	a4,s1,8
    800043b8:	02e7e663          	bltu	a5,a4,800043e4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800043bc:	46a1                	li	a3,8
    800043be:	8626                	mv	a2,s1
    800043c0:	85ca                	mv	a1,s2
    800043c2:	6d28                	ld	a0,88(a0)
    800043c4:	ffffd097          	auipc	ra,0xffffd
    800043c8:	342080e7          	jalr	834(ra) # 80001706 <copyin>
    800043cc:	00a03533          	snez	a0,a0
    800043d0:	40a00533          	neg	a0,a0
}
    800043d4:	60e2                	ld	ra,24(sp)
    800043d6:	6442                	ld	s0,16(sp)
    800043d8:	64a2                	ld	s1,8(sp)
    800043da:	6902                	ld	s2,0(sp)
    800043dc:	6105                	addi	sp,sp,32
    800043de:	8082                	ret
    return -1;
    800043e0:	557d                	li	a0,-1
    800043e2:	bfcd                	j	800043d4 <fetchaddr+0x3e>
    800043e4:	557d                	li	a0,-1
    800043e6:	b7fd                	j	800043d4 <fetchaddr+0x3e>

00000000800043e8 <fetchstr>:
{
    800043e8:	7179                	addi	sp,sp,-48
    800043ea:	f406                	sd	ra,40(sp)
    800043ec:	f022                	sd	s0,32(sp)
    800043ee:	ec26                	sd	s1,24(sp)
    800043f0:	e84a                	sd	s2,16(sp)
    800043f2:	e44e                	sd	s3,8(sp)
    800043f4:	1800                	addi	s0,sp,48
    800043f6:	892a                	mv	s2,a0
    800043f8:	84ae                	mv	s1,a1
    800043fa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	5bc080e7          	jalr	1468(ra) # 800019b8 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80004404:	86ce                	mv	a3,s3
    80004406:	864a                	mv	a2,s2
    80004408:	85a6                	mv	a1,s1
    8000440a:	6d28                	ld	a0,88(a0)
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	386080e7          	jalr	902(ra) # 80001792 <copyinstr>
  if(err < 0)
    80004414:	00054763          	bltz	a0,80004422 <fetchstr+0x3a>
  return strlen(buf);
    80004418:	8526                	mv	a0,s1
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	a48080e7          	jalr	-1464(ra) # 80000e62 <strlen>
}
    80004422:	70a2                	ld	ra,40(sp)
    80004424:	7402                	ld	s0,32(sp)
    80004426:	64e2                	ld	s1,24(sp)
    80004428:	6942                	ld	s2,16(sp)
    8000442a:	69a2                	ld	s3,8(sp)
    8000442c:	6145                	addi	sp,sp,48
    8000442e:	8082                	ret

0000000080004430 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80004430:	1101                	addi	sp,sp,-32
    80004432:	ec06                	sd	ra,24(sp)
    80004434:	e822                	sd	s0,16(sp)
    80004436:	e426                	sd	s1,8(sp)
    80004438:	1000                	addi	s0,sp,32
    8000443a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000443c:	00000097          	auipc	ra,0x0
    80004440:	ef2080e7          	jalr	-270(ra) # 8000432e <argraw>
    80004444:	c088                	sw	a0,0(s1)
  return 0;
}
    80004446:	4501                	li	a0,0
    80004448:	60e2                	ld	ra,24(sp)
    8000444a:	6442                	ld	s0,16(sp)
    8000444c:	64a2                	ld	s1,8(sp)
    8000444e:	6105                	addi	sp,sp,32
    80004450:	8082                	ret

0000000080004452 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80004452:	1101                	addi	sp,sp,-32
    80004454:	ec06                	sd	ra,24(sp)
    80004456:	e822                	sd	s0,16(sp)
    80004458:	e426                	sd	s1,8(sp)
    8000445a:	1000                	addi	s0,sp,32
    8000445c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000445e:	00000097          	auipc	ra,0x0
    80004462:	ed0080e7          	jalr	-304(ra) # 8000432e <argraw>
    80004466:	e088                	sd	a0,0(s1)
  return 0;
}
    80004468:	4501                	li	a0,0
    8000446a:	60e2                	ld	ra,24(sp)
    8000446c:	6442                	ld	s0,16(sp)
    8000446e:	64a2                	ld	s1,8(sp)
    80004470:	6105                	addi	sp,sp,32
    80004472:	8082                	ret

0000000080004474 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80004474:	1101                	addi	sp,sp,-32
    80004476:	ec06                	sd	ra,24(sp)
    80004478:	e822                	sd	s0,16(sp)
    8000447a:	e426                	sd	s1,8(sp)
    8000447c:	e04a                	sd	s2,0(sp)
    8000447e:	1000                	addi	s0,sp,32
    80004480:	84ae                	mv	s1,a1
    80004482:	8932                	mv	s2,a2
  *ip = argraw(n);
    80004484:	00000097          	auipc	ra,0x0
    80004488:	eaa080e7          	jalr	-342(ra) # 8000432e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000448c:	864a                	mv	a2,s2
    8000448e:	85a6                	mv	a1,s1
    80004490:	00000097          	auipc	ra,0x0
    80004494:	f58080e7          	jalr	-168(ra) # 800043e8 <fetchstr>
}
    80004498:	60e2                	ld	ra,24(sp)
    8000449a:	6442                	ld	s0,16(sp)
    8000449c:	64a2                	ld	s1,8(sp)
    8000449e:	6902                	ld	s2,0(sp)
    800044a0:	6105                	addi	sp,sp,32
    800044a2:	8082                	ret

00000000800044a4 <syscall>:
[SYS_sem_consume] sys_sem_consume,
};

void
syscall(void)
{
    800044a4:	1101                	addi	sp,sp,-32
    800044a6:	ec06                	sd	ra,24(sp)
    800044a8:	e822                	sd	s0,16(sp)
    800044aa:	e426                	sd	s1,8(sp)
    800044ac:	e04a                	sd	s2,0(sp)
    800044ae:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	508080e7          	jalr	1288(ra) # 800019b8 <myproc>
    800044b8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800044ba:	06053903          	ld	s2,96(a0)
    800044be:	0a893783          	ld	a5,168(s2)
    800044c2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800044c6:	37fd                	addiw	a5,a5,-1
    800044c8:	02700713          	li	a4,39
    800044cc:	00f76f63          	bltu	a4,a5,800044ea <syscall+0x46>
    800044d0:	00369713          	slli	a4,a3,0x3
    800044d4:	00005797          	auipc	a5,0x5
    800044d8:	28c78793          	addi	a5,a5,652 # 80009760 <syscalls>
    800044dc:	97ba                	add	a5,a5,a4
    800044de:	639c                	ld	a5,0(a5)
    800044e0:	c789                	beqz	a5,800044ea <syscall+0x46>
    p->trapframe->a0 = syscalls[num]();
    800044e2:	9782                	jalr	a5
    800044e4:	06a93823          	sd	a0,112(s2)
    800044e8:	a839                	j	80004506 <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800044ea:	16048613          	addi	a2,s1,352
    800044ee:	588c                	lw	a1,48(s1)
    800044f0:	00005517          	auipc	a0,0x5
    800044f4:	23850513          	addi	a0,a0,568 # 80009728 <states.2619+0x150>
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	08e080e7          	jalr	142(ra) # 80000586 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80004500:	70bc                	ld	a5,96(s1)
    80004502:	577d                	li	a4,-1
    80004504:	fbb8                	sd	a4,112(a5)
  }
}
    80004506:	60e2                	ld	ra,24(sp)
    80004508:	6442                	ld	s0,16(sp)
    8000450a:	64a2                	ld	s1,8(sp)
    8000450c:	6902                	ld	s2,0(sp)
    8000450e:	6105                	addi	sp,sp,32
    80004510:	8082                	ret

0000000080004512 <sys_exit>:
#include "proc.h"
#include "condvar.h"
// #include "proc.c"
uint64
sys_exit(void)
{
    80004512:	1101                	addi	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000451a:	fec40593          	addi	a1,s0,-20
    8000451e:	4501                	li	a0,0
    80004520:	00000097          	auipc	ra,0x0
    80004524:	f10080e7          	jalr	-240(ra) # 80004430 <argint>
    return -1;
    80004528:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000452a:	00054963          	bltz	a0,8000453c <sys_exit+0x2a>
  exit(n);
    8000452e:	fec42503          	lw	a0,-20(s0)
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	74a080e7          	jalr	1866(ra) # 80002c7c <exit>
  return 0;  // not reached
    8000453a:	4781                	li	a5,0
}
    8000453c:	853e                	mv	a0,a5
    8000453e:	60e2                	ld	ra,24(sp)
    80004540:	6442                	ld	s0,16(sp)
    80004542:	6105                	addi	sp,sp,32
    80004544:	8082                	ret

0000000080004546 <sys_getpid>:

uint64
sys_getpid(void)
{
    80004546:	1141                	addi	sp,sp,-16
    80004548:	e406                	sd	ra,8(sp)
    8000454a:	e022                	sd	s0,0(sp)
    8000454c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000454e:	ffffd097          	auipc	ra,0xffffd
    80004552:	46a080e7          	jalr	1130(ra) # 800019b8 <myproc>
}
    80004556:	5908                	lw	a0,48(a0)
    80004558:	60a2                	ld	ra,8(sp)
    8000455a:	6402                	ld	s0,0(sp)
    8000455c:	0141                	addi	sp,sp,16
    8000455e:	8082                	ret

0000000080004560 <sys_fork>:

uint64
sys_fork(void)
{
    80004560:	1141                	addi	sp,sp,-16
    80004562:	e406                	sd	ra,8(sp)
    80004564:	e022                	sd	s0,0(sp)
    80004566:	0800                	addi	s0,sp,16
  return fork();
    80004568:	ffffe097          	auipc	ra,0xffffe
    8000456c:	894080e7          	jalr	-1900(ra) # 80001dfc <fork>
}
    80004570:	60a2                	ld	ra,8(sp)
    80004572:	6402                	ld	s0,0(sp)
    80004574:	0141                	addi	sp,sp,16
    80004576:	8082                	ret

0000000080004578 <sys_wait>:

uint64
sys_wait(void)
{
    80004578:	1101                	addi	sp,sp,-32
    8000457a:	ec06                	sd	ra,24(sp)
    8000457c:	e822                	sd	s0,16(sp)
    8000457e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80004580:	fe840593          	addi	a1,s0,-24
    80004584:	4501                	li	a0,0
    80004586:	00000097          	auipc	ra,0x0
    8000458a:	ecc080e7          	jalr	-308(ra) # 80004452 <argaddr>
    8000458e:	87aa                	mv	a5,a0
    return -1;
    80004590:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80004592:	0007c863          	bltz	a5,800045a2 <sys_wait+0x2a>
  return wait(p);
    80004596:	fe843503          	ld	a0,-24(s0)
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	36e080e7          	jalr	878(ra) # 80002908 <wait>
}
    800045a2:	60e2                	ld	ra,24(sp)
    800045a4:	6442                	ld	s0,16(sp)
    800045a6:	6105                	addi	sp,sp,32
    800045a8:	8082                	ret

00000000800045aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800045aa:	7179                	addi	sp,sp,-48
    800045ac:	f406                	sd	ra,40(sp)
    800045ae:	f022                	sd	s0,32(sp)
    800045b0:	ec26                	sd	s1,24(sp)
    800045b2:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800045b4:	fdc40593          	addi	a1,s0,-36
    800045b8:	4501                	li	a0,0
    800045ba:	00000097          	auipc	ra,0x0
    800045be:	e76080e7          	jalr	-394(ra) # 80004430 <argint>
    800045c2:	87aa                	mv	a5,a0
    return -1;
    800045c4:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800045c6:	0207c063          	bltz	a5,800045e6 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800045ca:	ffffd097          	auipc	ra,0xffffd
    800045ce:	3ee080e7          	jalr	1006(ra) # 800019b8 <myproc>
    800045d2:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800045d4:	fdc42503          	lw	a0,-36(s0)
    800045d8:	ffffd097          	auipc	ra,0xffffd
    800045dc:	7b0080e7          	jalr	1968(ra) # 80001d88 <growproc>
    800045e0:	00054863          	bltz	a0,800045f0 <sys_sbrk+0x46>
    return -1;
  return addr;
    800045e4:	8526                	mv	a0,s1
}
    800045e6:	70a2                	ld	ra,40(sp)
    800045e8:	7402                	ld	s0,32(sp)
    800045ea:	64e2                	ld	s1,24(sp)
    800045ec:	6145                	addi	sp,sp,48
    800045ee:	8082                	ret
    return -1;
    800045f0:	557d                	li	a0,-1
    800045f2:	bfd5                	j	800045e6 <sys_sbrk+0x3c>

00000000800045f4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800045f4:	7139                	addi	sp,sp,-64
    800045f6:	fc06                	sd	ra,56(sp)
    800045f8:	f822                	sd	s0,48(sp)
    800045fa:	f426                	sd	s1,40(sp)
    800045fc:	f04a                	sd	s2,32(sp)
    800045fe:	ec4e                	sd	s3,24(sp)
    80004600:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80004602:	fcc40593          	addi	a1,s0,-52
    80004606:	4501                	li	a0,0
    80004608:	00000097          	auipc	ra,0x0
    8000460c:	e28080e7          	jalr	-472(ra) # 80004430 <argint>
    return -1;
    80004610:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80004612:	06054563          	bltz	a0,8000467c <sys_sleep+0x88>
  acquire(&tickslock);
    80004616:	00016517          	auipc	a0,0x16
    8000461a:	d9a50513          	addi	a0,a0,-614 # 8001a3b0 <tickslock>
    8000461e:	ffffc097          	auipc	ra,0xffffc
    80004622:	5c4080e7          	jalr	1476(ra) # 80000be2 <acquire>
  ticks0 = ticks;
    80004626:	00006917          	auipc	s2,0x6
    8000462a:	a5692903          	lw	s2,-1450(s2) # 8000a07c <ticks>
  while(ticks - ticks0 < n){
    8000462e:	fcc42783          	lw	a5,-52(s0)
    80004632:	cf85                	beqz	a5,8000466a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80004634:	00016997          	auipc	s3,0x16
    80004638:	d7c98993          	addi	s3,s3,-644 # 8001a3b0 <tickslock>
    8000463c:	00006497          	auipc	s1,0x6
    80004640:	a4048493          	addi	s1,s1,-1472 # 8000a07c <ticks>
    if(myproc()->killed){
    80004644:	ffffd097          	auipc	ra,0xffffd
    80004648:	374080e7          	jalr	884(ra) # 800019b8 <myproc>
    8000464c:	551c                	lw	a5,40(a0)
    8000464e:	ef9d                	bnez	a5,8000468c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80004650:	85ce                	mv	a1,s3
    80004652:	8526                	mv	a0,s1
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	106080e7          	jalr	262(ra) # 8000275a <sleep>
  while(ticks - ticks0 < n){
    8000465c:	409c                	lw	a5,0(s1)
    8000465e:	412787bb          	subw	a5,a5,s2
    80004662:	fcc42703          	lw	a4,-52(s0)
    80004666:	fce7efe3          	bltu	a5,a4,80004644 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000466a:	00016517          	auipc	a0,0x16
    8000466e:	d4650513          	addi	a0,a0,-698 # 8001a3b0 <tickslock>
    80004672:	ffffc097          	auipc	ra,0xffffc
    80004676:	624080e7          	jalr	1572(ra) # 80000c96 <release>
  return 0;
    8000467a:	4781                	li	a5,0
}
    8000467c:	853e                	mv	a0,a5
    8000467e:	70e2                	ld	ra,56(sp)
    80004680:	7442                	ld	s0,48(sp)
    80004682:	74a2                	ld	s1,40(sp)
    80004684:	7902                	ld	s2,32(sp)
    80004686:	69e2                	ld	s3,24(sp)
    80004688:	6121                	addi	sp,sp,64
    8000468a:	8082                	ret
      release(&tickslock);
    8000468c:	00016517          	auipc	a0,0x16
    80004690:	d2450513          	addi	a0,a0,-732 # 8001a3b0 <tickslock>
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	602080e7          	jalr	1538(ra) # 80000c96 <release>
      return -1;
    8000469c:	57fd                	li	a5,-1
    8000469e:	bff9                	j	8000467c <sys_sleep+0x88>

00000000800046a0 <sys_kill>:

uint64
sys_kill(void)
{
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800046a8:	fec40593          	addi	a1,s0,-20
    800046ac:	4501                	li	a0,0
    800046ae:	00000097          	auipc	ra,0x0
    800046b2:	d82080e7          	jalr	-638(ra) # 80004430 <argint>
    800046b6:	87aa                	mv	a5,a0
    return -1;
    800046b8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800046ba:	0007c863          	bltz	a5,800046ca <sys_kill+0x2a>
  return kill(pid);
    800046be:	fec42503          	lw	a0,-20(s0)
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	9f2080e7          	jalr	-1550(ra) # 800030b4 <kill>
}
    800046ca:	60e2                	ld	ra,24(sp)
    800046cc:	6442                	ld	s0,16(sp)
    800046ce:	6105                	addi	sp,sp,32
    800046d0:	8082                	ret

00000000800046d2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800046d2:	1101                	addi	sp,sp,-32
    800046d4:	ec06                	sd	ra,24(sp)
    800046d6:	e822                	sd	s0,16(sp)
    800046d8:	e426                	sd	s1,8(sp)
    800046da:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800046dc:	00016517          	auipc	a0,0x16
    800046e0:	cd450513          	addi	a0,a0,-812 # 8001a3b0 <tickslock>
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	4fe080e7          	jalr	1278(ra) # 80000be2 <acquire>
  xticks = ticks;
    800046ec:	00006497          	auipc	s1,0x6
    800046f0:	9904a483          	lw	s1,-1648(s1) # 8000a07c <ticks>
  release(&tickslock);
    800046f4:	00016517          	auipc	a0,0x16
    800046f8:	cbc50513          	addi	a0,a0,-836 # 8001a3b0 <tickslock>
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	59a080e7          	jalr	1434(ra) # 80000c96 <release>
  return xticks;
}
    80004704:	02049513          	slli	a0,s1,0x20
    80004708:	9101                	srli	a0,a0,0x20
    8000470a:	60e2                	ld	ra,24(sp)
    8000470c:	6442                	ld	s0,16(sp)
    8000470e:	64a2                	ld	s1,8(sp)
    80004710:	6105                	addi	sp,sp,32
    80004712:	8082                	ret

0000000080004714 <sys_getppid>:

uint64
sys_getppid(void)
{
    80004714:	1141                	addi	sp,sp,-16
    80004716:	e406                	sd	ra,8(sp)
    80004718:	e022                	sd	s0,0(sp)
    8000471a:	0800                	addi	s0,sp,16
  if (myproc()->parent) return myproc()->parent->pid;
    8000471c:	ffffd097          	auipc	ra,0xffffd
    80004720:	29c080e7          	jalr	668(ra) # 800019b8 <myproc>
    80004724:	613c                	ld	a5,64(a0)
    80004726:	cb99                	beqz	a5,8000473c <sys_getppid+0x28>
    80004728:	ffffd097          	auipc	ra,0xffffd
    8000472c:	290080e7          	jalr	656(ra) # 800019b8 <myproc>
    80004730:	613c                	ld	a5,64(a0)
    80004732:	5b88                	lw	a0,48(a5)
  else {
     printf("No parent found.\n");
     return 0;
  }
}
    80004734:	60a2                	ld	ra,8(sp)
    80004736:	6402                	ld	s0,0(sp)
    80004738:	0141                	addi	sp,sp,16
    8000473a:	8082                	ret
     printf("No parent found.\n");
    8000473c:	00005517          	auipc	a0,0x5
    80004740:	16c50513          	addi	a0,a0,364 # 800098a8 <syscalls+0x148>
    80004744:	ffffc097          	auipc	ra,0xffffc
    80004748:	e42080e7          	jalr	-446(ra) # 80000586 <printf>
     return 0;
    8000474c:	4501                	li	a0,0
    8000474e:	b7dd                	j	80004734 <sys_getppid+0x20>

0000000080004750 <sys_yield>:

uint64
sys_yield(void)
{
    80004750:	1141                	addi	sp,sp,-16
    80004752:	e406                	sd	ra,8(sp)
    80004754:	e022                	sd	s0,0(sp)
    80004756:	0800                	addi	s0,sp,16
  yield();
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	e96080e7          	jalr	-362(ra) # 800025ee <yield>
  return 0;
}
    80004760:	4501                	li	a0,0
    80004762:	60a2                	ld	ra,8(sp)
    80004764:	6402                	ld	s0,0(sp)
    80004766:	0141                	addi	sp,sp,16
    80004768:	8082                	ret

000000008000476a <sys_getpa>:

uint64
sys_getpa(void)
{
    8000476a:	1101                	addi	sp,sp,-32
    8000476c:	ec06                	sd	ra,24(sp)
    8000476e:	e822                	sd	s0,16(sp)
    80004770:	1000                	addi	s0,sp,32
  uint64 x;
  if (argaddr(0, &x) < 0) return -1;
    80004772:	fe840593          	addi	a1,s0,-24
    80004776:	4501                	li	a0,0
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	cda080e7          	jalr	-806(ra) # 80004452 <argaddr>
    80004780:	87aa                	mv	a5,a0
    80004782:	557d                	li	a0,-1
    80004784:	0207c263          	bltz	a5,800047a8 <sys_getpa+0x3e>
  return walkaddr(myproc()->pagetable, x) + (x & (PGSIZE - 1));
    80004788:	ffffd097          	auipc	ra,0xffffd
    8000478c:	230080e7          	jalr	560(ra) # 800019b8 <myproc>
    80004790:	fe843583          	ld	a1,-24(s0)
    80004794:	6d28                	ld	a0,88(a0)
    80004796:	ffffd097          	auipc	ra,0xffffd
    8000479a:	8e0080e7          	jalr	-1824(ra) # 80001076 <walkaddr>
    8000479e:	fe843783          	ld	a5,-24(s0)
    800047a2:	17d2                	slli	a5,a5,0x34
    800047a4:	93d1                	srli	a5,a5,0x34
    800047a6:	953e                	add	a0,a0,a5
}
    800047a8:	60e2                	ld	ra,24(sp)
    800047aa:	6442                	ld	s0,16(sp)
    800047ac:	6105                	addi	sp,sp,32
    800047ae:	8082                	ret

00000000800047b0 <sys_forkf>:

uint64
sys_forkf(void)
{
    800047b0:	1101                	addi	sp,sp,-32
    800047b2:	ec06                	sd	ra,24(sp)
    800047b4:	e822                	sd	s0,16(sp)
    800047b6:	1000                	addi	s0,sp,32
  uint64 x;
  if (argaddr(0, &x) < 0) return -1;
    800047b8:	fe840593          	addi	a1,s0,-24
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	c94080e7          	jalr	-876(ra) # 80004452 <argaddr>
    800047c6:	87aa                	mv	a5,a0
    800047c8:	557d                	li	a0,-1
    800047ca:	0007c863          	bltz	a5,800047da <sys_forkf+0x2a>
  return forkf(x);
    800047ce:	fe843503          	ld	a0,-24(s0)
    800047d2:	ffffd097          	auipc	ra,0xffffd
    800047d6:	766080e7          	jalr	1894(ra) # 80001f38 <forkf>
}
    800047da:	60e2                	ld	ra,24(sp)
    800047dc:	6442                	ld	s0,16(sp)
    800047de:	6105                	addi	sp,sp,32
    800047e0:	8082                	ret

00000000800047e2 <sys_waitpid>:

uint64
sys_waitpid(void)
{
    800047e2:	1101                	addi	sp,sp,-32
    800047e4:	ec06                	sd	ra,24(sp)
    800047e6:	e822                	sd	s0,16(sp)
    800047e8:	1000                	addi	s0,sp,32
  uint64 p;
  int x;

  if(argint(0, &x) < 0)
    800047ea:	fe440593          	addi	a1,s0,-28
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	c40080e7          	jalr	-960(ra) # 80004430 <argint>
    return -1;
    800047f8:	57fd                	li	a5,-1
  if(argint(0, &x) < 0)
    800047fa:	02054c63          	bltz	a0,80004832 <sys_waitpid+0x50>
  if(argaddr(1, &p) < 0)
    800047fe:	fe840593          	addi	a1,s0,-24
    80004802:	4505                	li	a0,1
    80004804:	00000097          	auipc	ra,0x0
    80004808:	c4e080e7          	jalr	-946(ra) # 80004452 <argaddr>
    8000480c:	04054063          	bltz	a0,8000484c <sys_waitpid+0x6a>
    return -1;

  if (x == -1) return wait(p);
    80004810:	fe442503          	lw	a0,-28(s0)
    80004814:	57fd                	li	a5,-1
    80004816:	02f50363          	beq	a0,a5,8000483c <sys_waitpid+0x5a>
  if ((x == 0) || (x < -1)) return -1;
    8000481a:	57fd                	li	a5,-1
    8000481c:	c919                	beqz	a0,80004832 <sys_waitpid+0x50>
    8000481e:	577d                	li	a4,-1
    80004820:	00e54963          	blt	a0,a4,80004832 <sys_waitpid+0x50>
  return waitpid(x, p);
    80004824:	fe843583          	ld	a1,-24(s0)
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	208080e7          	jalr	520(ra) # 80002a30 <waitpid>
    80004830:	87aa                	mv	a5,a0
}
    80004832:	853e                	mv	a0,a5
    80004834:	60e2                	ld	ra,24(sp)
    80004836:	6442                	ld	s0,16(sp)
    80004838:	6105                	addi	sp,sp,32
    8000483a:	8082                	ret
  if (x == -1) return wait(p);
    8000483c:	fe843503          	ld	a0,-24(s0)
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	0c8080e7          	jalr	200(ra) # 80002908 <wait>
    80004848:	87aa                	mv	a5,a0
    8000484a:	b7e5                	j	80004832 <sys_waitpid+0x50>
    return -1;
    8000484c:	57fd                	li	a5,-1
    8000484e:	b7d5                	j	80004832 <sys_waitpid+0x50>

0000000080004850 <sys_ps>:

uint64
sys_ps(void)
{
    80004850:	1141                	addi	sp,sp,-16
    80004852:	e406                	sd	ra,8(sp)
    80004854:	e022                	sd	s0,0(sp)
    80004856:	0800                	addi	s0,sp,16
   return ps();
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	a58080e7          	jalr	-1448(ra) # 800032b0 <ps>
}
    80004860:	60a2                	ld	ra,8(sp)
    80004862:	6402                	ld	s0,0(sp)
    80004864:	0141                	addi	sp,sp,16
    80004866:	8082                	ret

0000000080004868 <sys_pinfo>:

uint64
sys_pinfo(void)
{
    80004868:	1101                	addi	sp,sp,-32
    8000486a:	ec06                	sd	ra,24(sp)
    8000486c:	e822                	sd	s0,16(sp)
    8000486e:	1000                	addi	s0,sp,32
  uint64 p;
  int x;

  if(argint(0, &x) < 0)
    80004870:	fe440593          	addi	a1,s0,-28
    80004874:	4501                	li	a0,0
    80004876:	00000097          	auipc	ra,0x0
    8000487a:	bba080e7          	jalr	-1094(ra) # 80004430 <argint>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argint(0, &x) < 0)
    80004880:	02054963          	bltz	a0,800048b2 <sys_pinfo+0x4a>
  if(argaddr(1, &p) < 0)
    80004884:	fe840593          	addi	a1,s0,-24
    80004888:	4505                	li	a0,1
    8000488a:	00000097          	auipc	ra,0x0
    8000488e:	bc8080e7          	jalr	-1080(ra) # 80004452 <argaddr>
    80004892:	02054563          	bltz	a0,800048bc <sys_pinfo+0x54>
    return -1;

  if ((x == 0) || (x < -1) || (p == 0)) return -1;
    80004896:	fe442503          	lw	a0,-28(s0)
    8000489a:	57fd                	li	a5,-1
    8000489c:	c919                	beqz	a0,800048b2 <sys_pinfo+0x4a>
    8000489e:	02f54163          	blt	a0,a5,800048c0 <sys_pinfo+0x58>
    800048a2:	fe843583          	ld	a1,-24(s0)
    800048a6:	c591                	beqz	a1,800048b2 <sys_pinfo+0x4a>
  return pinfo(x, p);
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	b74080e7          	jalr	-1164(ra) # 8000341c <pinfo>
    800048b0:	87aa                	mv	a5,a0
}
    800048b2:	853e                	mv	a0,a5
    800048b4:	60e2                	ld	ra,24(sp)
    800048b6:	6442                	ld	s0,16(sp)
    800048b8:	6105                	addi	sp,sp,32
    800048ba:	8082                	ret
    return -1;
    800048bc:	57fd                	li	a5,-1
    800048be:	bfd5                	j	800048b2 <sys_pinfo+0x4a>
  if ((x == 0) || (x < -1) || (p == 0)) return -1;
    800048c0:	57fd                	li	a5,-1
    800048c2:	bfc5                	j	800048b2 <sys_pinfo+0x4a>

00000000800048c4 <sys_forkp>:

uint64
sys_forkp(void)
{
    800048c4:	1101                	addi	sp,sp,-32
    800048c6:	ec06                	sd	ra,24(sp)
    800048c8:	e822                	sd	s0,16(sp)
    800048ca:	1000                	addi	s0,sp,32
  int x;
  if(argint(0, &x) < 0) return -1;
    800048cc:	fec40593          	addi	a1,s0,-20
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	b5e080e7          	jalr	-1186(ra) # 80004430 <argint>
    800048da:	87aa                	mv	a5,a0
    800048dc:	557d                	li	a0,-1
    800048de:	0007c863          	bltz	a5,800048ee <sys_forkp+0x2a>
  return forkp(x);
    800048e2:	fec42503          	lw	a0,-20(s0)
    800048e6:	ffffd097          	auipc	ra,0xffffd
    800048ea:	79a080e7          	jalr	1946(ra) # 80002080 <forkp>
}
    800048ee:	60e2                	ld	ra,24(sp)
    800048f0:	6442                	ld	s0,16(sp)
    800048f2:	6105                	addi	sp,sp,32
    800048f4:	8082                	ret

00000000800048f6 <sys_schedpolicy>:

uint64
sys_schedpolicy(void)
{
    800048f6:	1101                	addi	sp,sp,-32
    800048f8:	ec06                	sd	ra,24(sp)
    800048fa:	e822                	sd	s0,16(sp)
    800048fc:	1000                	addi	s0,sp,32
  int x;
  if(argint(0, &x) < 0) return -1;
    800048fe:	fec40593          	addi	a1,s0,-20
    80004902:	4501                	li	a0,0
    80004904:	00000097          	auipc	ra,0x0
    80004908:	b2c080e7          	jalr	-1236(ra) # 80004430 <argint>
    8000490c:	87aa                	mv	a5,a0
    8000490e:	557d                	li	a0,-1
    80004910:	0007c863          	bltz	a5,80004920 <sys_schedpolicy+0x2a>
  return schedpolicy(x);
    80004914:	fec42503          	lw	a0,-20(s0)
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	ca6080e7          	jalr	-858(ra) # 800035be <schedpolicy>
}
    80004920:	60e2                	ld	ra,24(sp)
    80004922:	6442                	ld	s0,16(sp)
    80004924:	6105                	addi	sp,sp,32
    80004926:	8082                	ret

0000000080004928 <sys_condsleep>:



uint64
sys_condsleep(void)
{
    80004928:	1101                	addi	sp,sp,-32
    8000492a:	ec06                	sd	ra,24(sp)
    8000492c:	e822                	sd	s0,16(sp)
    8000492e:	1000                	addi	s0,sp,32
  uint64 x;
  uint64 y;
  struct cond_t *cv;
  struct sleeplock *lock;
  if(argaddr(0,&x)<0) return -1;
    80004930:	fe840593          	addi	a1,s0,-24
    80004934:	4501                	li	a0,0
    80004936:	00000097          	auipc	ra,0x0
    8000493a:	b1c080e7          	jalr	-1252(ra) # 80004452 <argaddr>
    8000493e:	57fd                	li	a5,-1
    80004940:	02054563          	bltz	a0,8000496a <sys_condsleep+0x42>
  if(argaddr(1,&y)<0) return -1;
    80004944:	fe040593          	addi	a1,s0,-32
    80004948:	4505                	li	a0,1
    8000494a:	00000097          	auipc	ra,0x0
    8000494e:	b08080e7          	jalr	-1272(ra) # 80004452 <argaddr>
    80004952:	57fd                	li	a5,-1
    80004954:	00054b63          	bltz	a0,8000496a <sys_condsleep+0x42>
  cv=(struct cond_t*)(&x);
  lock=(struct sleeplock*)(&y);
  condsleep(cv,lock);
    80004958:	fe040593          	addi	a1,s0,-32
    8000495c:	fe840513          	addi	a0,s0,-24
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	c78080e7          	jalr	-904(ra) # 800035d8 <condsleep>
  return 0;
    80004968:	4781                	li	a5,0
}
    8000496a:	853e                	mv	a0,a5
    8000496c:	60e2                	ld	ra,24(sp)
    8000496e:	6442                	ld	s0,16(sp)
    80004970:	6105                	addi	sp,sp,32
    80004972:	8082                	ret

0000000080004974 <sys_barrier_alloc>:

uint64 sys_barrier_alloc(void)
{
    80004974:	1141                	addi	sp,sp,-16
    80004976:	e406                	sd	ra,8(sp)
    80004978:	e022                	sd	s0,0(sp)
    8000497a:	0800                	addi	s0,sp,16
  return barrier_alloc();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	eec080e7          	jalr	-276(ra) # 80003868 <barrier_alloc>
}
    80004984:	60a2                	ld	ra,8(sp)
    80004986:	6402                	ld	s0,0(sp)
    80004988:	0141                	addi	sp,sp,16
    8000498a:	8082                	ret

000000008000498c <sys_barrier>:

uint64 sys_barrier(void)
{
    8000498c:	1101                	addi	sp,sp,-32
    8000498e:	ec06                	sd	ra,24(sp)
    80004990:	e822                	sd	s0,16(sp)
    80004992:	1000                	addi	s0,sp,32
  int bin,id,n;
  if(argint(0,&bin)<0) return -1;
    80004994:	fec40593          	addi	a1,s0,-20
    80004998:	4501                	li	a0,0
    8000499a:	00000097          	auipc	ra,0x0
    8000499e:	a96080e7          	jalr	-1386(ra) # 80004430 <argint>
    800049a2:	57fd                	li	a5,-1
    800049a4:	04054163          	bltz	a0,800049e6 <sys_barrier+0x5a>
  if(argint(1,&id)<0) return -1;
    800049a8:	fe840593          	addi	a1,s0,-24
    800049ac:	4505                	li	a0,1
    800049ae:	00000097          	auipc	ra,0x0
    800049b2:	a82080e7          	jalr	-1406(ra) # 80004430 <argint>
    800049b6:	57fd                	li	a5,-1
    800049b8:	02054763          	bltz	a0,800049e6 <sys_barrier+0x5a>
  if(argint(2,&n)<0) return -1;
    800049bc:	fe440593          	addi	a1,s0,-28
    800049c0:	4509                	li	a0,2
    800049c2:	00000097          	auipc	ra,0x0
    800049c6:	a6e080e7          	jalr	-1426(ra) # 80004430 <argint>
    800049ca:	57fd                	li	a5,-1
    800049cc:	00054d63          	bltz	a0,800049e6 <sys_barrier+0x5a>
  return barrier(bin,id,n);
    800049d0:	fe442603          	lw	a2,-28(s0)
    800049d4:	fe842583          	lw	a1,-24(s0)
    800049d8:	fec42503          	lw	a0,-20(s0)
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	f34080e7          	jalr	-204(ra) # 80003910 <barrier>
    800049e4:	87aa                	mv	a5,a0
}
    800049e6:	853e                	mv	a0,a5
    800049e8:	60e2                	ld	ra,24(sp)
    800049ea:	6442                	ld	s0,16(sp)
    800049ec:	6105                	addi	sp,sp,32
    800049ee:	8082                	ret

00000000800049f0 <sys_barrier_free>:

uint64 sys_barrier_free(void)
{
    800049f0:	1101                	addi	sp,sp,-32
    800049f2:	ec06                	sd	ra,24(sp)
    800049f4:	e822                	sd	s0,16(sp)
    800049f6:	1000                	addi	s0,sp,32
  int id;
  if(argint(0,&id)<0) return -1;
    800049f8:	fec40593          	addi	a1,s0,-20
    800049fc:	4501                	li	a0,0
    800049fe:	00000097          	auipc	ra,0x0
    80004a02:	a32080e7          	jalr	-1486(ra) # 80004430 <argint>
    80004a06:	87aa                	mv	a5,a0
    80004a08:	557d                	li	a0,-1
    80004a0a:	0007c863          	bltz	a5,80004a1a <sys_barrier_free+0x2a>
  return barrier_free(id);
    80004a0e:	fec42503          	lw	a0,-20(s0)
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	012080e7          	jalr	18(ra) # 80003a24 <barrier_free>
}
    80004a1a:	60e2                	ld	ra,24(sp)
    80004a1c:	6442                	ld	s0,16(sp)
    80004a1e:	6105                	addi	sp,sp,32
    80004a20:	8082                	ret

0000000080004a22 <sys_buffer_cond_init>:

uint64 sys_buffer_cond_init(void)
{
    80004a22:	1141                	addi	sp,sp,-16
    80004a24:	e406                	sd	ra,8(sp)
    80004a26:	e022                	sd	s0,0(sp)
    80004a28:	0800                	addi	s0,sp,16
  buffer_cond_init();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	01e080e7          	jalr	30(ra) # 80003a48 <buffer_cond_init>
  return 0;
}
    80004a32:	4501                	li	a0,0
    80004a34:	60a2                	ld	ra,8(sp)
    80004a36:	6402                	ld	s0,0(sp)
    80004a38:	0141                	addi	sp,sp,16
    80004a3a:	8082                	ret

0000000080004a3c <sys_cond_produce>:

uint64 sys_cond_produce(void)
{
    80004a3c:	1101                	addi	sp,sp,-32
    80004a3e:	ec06                	sd	ra,24(sp)
    80004a40:	e822                	sd	s0,16(sp)
    80004a42:	1000                	addi	s0,sp,32
  int x;
  if(argint(0,&x)<0) return -1;
    80004a44:	fec40593          	addi	a1,s0,-20
    80004a48:	4501                	li	a0,0
    80004a4a:	00000097          	auipc	ra,0x0
    80004a4e:	9e6080e7          	jalr	-1562(ra) # 80004430 <argint>
    80004a52:	57fd                	li	a5,-1
    80004a54:	00054963          	bltz	a0,80004a66 <sys_cond_produce+0x2a>
  cond_produce(x);
    80004a58:	fec42503          	lw	a0,-20(s0)
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	0be080e7          	jalr	190(ra) # 80003b1a <cond_produce>
  return 0;
    80004a64:	4781                	li	a5,0
}
    80004a66:	853e                	mv	a0,a5
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	6105                	addi	sp,sp,32
    80004a6e:	8082                	ret

0000000080004a70 <sys_cond_consume>:

uint64 sys_cond_consume(void)
{
    80004a70:	1141                	addi	sp,sp,-16
    80004a72:	e406                	sd	ra,8(sp)
    80004a74:	e022                	sd	s0,0(sp)
    80004a76:	0800                	addi	s0,sp,16
  return cond_consume();
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	182080e7          	jalr	386(ra) # 80003bfa <cond_consume>
}
    80004a80:	60a2                	ld	ra,8(sp)
    80004a82:	6402                	ld	s0,0(sp)
    80004a84:	0141                	addi	sp,sp,16
    80004a86:	8082                	ret

0000000080004a88 <sys_buffer_sem_init>:

uint64 sys_buffer_sem_init(void)
{
    80004a88:	1141                	addi	sp,sp,-16
    80004a8a:	e406                	sd	ra,8(sp)
    80004a8c:	e022                	sd	s0,0(sp)
    80004a8e:	0800                	addi	s0,sp,16
  buffer_sem_init();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	272080e7          	jalr	626(ra) # 80003d02 <buffer_sem_init>
  return 0;
}
    80004a98:	4501                	li	a0,0
    80004a9a:	60a2                	ld	ra,8(sp)
    80004a9c:	6402                	ld	s0,0(sp)
    80004a9e:	0141                	addi	sp,sp,16
    80004aa0:	8082                	ret

0000000080004aa2 <sys_sem_produce>:

uint64 sys_sem_produce(void)
{
    80004aa2:	1101                	addi	sp,sp,-32
    80004aa4:	ec06                	sd	ra,24(sp)
    80004aa6:	e822                	sd	s0,16(sp)
    80004aa8:	1000                	addi	s0,sp,32
  int x;
  if(argint(0,&x)<0) return -1;
    80004aaa:	fec40593          	addi	a1,s0,-20
    80004aae:	4501                	li	a0,0
    80004ab0:	00000097          	auipc	ra,0x0
    80004ab4:	980080e7          	jalr	-1664(ra) # 80004430 <argint>
    80004ab8:	57fd                	li	a5,-1
    80004aba:	00054963          	bltz	a0,80004acc <sys_sem_produce+0x2a>
  sem_produce(x);
    80004abe:	fec42503          	lw	a0,-20(s0)
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	336080e7          	jalr	822(ra) # 80003df8 <sem_produce>
  return 0;
    80004aca:	4781                	li	a5,0
}
    80004acc:	853e                	mv	a0,a5
    80004ace:	60e2                	ld	ra,24(sp)
    80004ad0:	6442                	ld	s0,16(sp)
    80004ad2:	6105                	addi	sp,sp,32
    80004ad4:	8082                	ret

0000000080004ad6 <sys_sem_consume>:

uint64 sys_sem_consume(void)
{
    80004ad6:	1141                	addi	sp,sp,-16
    80004ad8:	e406                	sd	ra,8(sp)
    80004ada:	e022                	sd	s0,0(sp)
    80004adc:	0800                	addi	s0,sp,16
  return sem_consume();
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	398080e7          	jalr	920(ra) # 80003e76 <sem_consume>
    80004ae6:	60a2                	ld	ra,8(sp)
    80004ae8:	6402                	ld	s0,0(sp)
    80004aea:	0141                	addi	sp,sp,16
    80004aec:	8082                	ret

0000000080004aee <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80004aee:	7179                	addi	sp,sp,-48
    80004af0:	f406                	sd	ra,40(sp)
    80004af2:	f022                	sd	s0,32(sp)
    80004af4:	ec26                	sd	s1,24(sp)
    80004af6:	e84a                	sd	s2,16(sp)
    80004af8:	e44e                	sd	s3,8(sp)
    80004afa:	e052                	sd	s4,0(sp)
    80004afc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004afe:	00005597          	auipc	a1,0x5
    80004b02:	dc258593          	addi	a1,a1,-574 # 800098c0 <syscalls+0x160>
    80004b06:	00016517          	auipc	a0,0x16
    80004b0a:	8c250513          	addi	a0,a0,-1854 # 8001a3c8 <bcache>
    80004b0e:	ffffc097          	auipc	ra,0xffffc
    80004b12:	044080e7          	jalr	68(ra) # 80000b52 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80004b16:	0001e797          	auipc	a5,0x1e
    80004b1a:	8b278793          	addi	a5,a5,-1870 # 800223c8 <bcache+0x8000>
    80004b1e:	0001e717          	auipc	a4,0x1e
    80004b22:	b1270713          	addi	a4,a4,-1262 # 80022630 <bcache+0x8268>
    80004b26:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80004b2a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004b2e:	00016497          	auipc	s1,0x16
    80004b32:	8b248493          	addi	s1,s1,-1870 # 8001a3e0 <bcache+0x18>
    b->next = bcache.head.next;
    80004b36:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80004b38:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80004b3a:	00005a17          	auipc	s4,0x5
    80004b3e:	d8ea0a13          	addi	s4,s4,-626 # 800098c8 <syscalls+0x168>
    b->next = bcache.head.next;
    80004b42:	2b893783          	ld	a5,696(s2)
    80004b46:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80004b48:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80004b4c:	85d2                	mv	a1,s4
    80004b4e:	01048513          	addi	a0,s1,16
    80004b52:	00001097          	auipc	ra,0x1
    80004b56:	4bc080e7          	jalr	1212(ra) # 8000600e <initsleeplock>
    bcache.head.next->prev = b;
    80004b5a:	2b893783          	ld	a5,696(s2)
    80004b5e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80004b60:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004b64:	45848493          	addi	s1,s1,1112
    80004b68:	fd349de3          	bne	s1,s3,80004b42 <binit+0x54>
  }
}
    80004b6c:	70a2                	ld	ra,40(sp)
    80004b6e:	7402                	ld	s0,32(sp)
    80004b70:	64e2                	ld	s1,24(sp)
    80004b72:	6942                	ld	s2,16(sp)
    80004b74:	69a2                	ld	s3,8(sp)
    80004b76:	6a02                	ld	s4,0(sp)
    80004b78:	6145                	addi	sp,sp,48
    80004b7a:	8082                	ret

0000000080004b7c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80004b7c:	7179                	addi	sp,sp,-48
    80004b7e:	f406                	sd	ra,40(sp)
    80004b80:	f022                	sd	s0,32(sp)
    80004b82:	ec26                	sd	s1,24(sp)
    80004b84:	e84a                	sd	s2,16(sp)
    80004b86:	e44e                	sd	s3,8(sp)
    80004b88:	1800                	addi	s0,sp,48
    80004b8a:	89aa                	mv	s3,a0
    80004b8c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80004b8e:	00016517          	auipc	a0,0x16
    80004b92:	83a50513          	addi	a0,a0,-1990 # 8001a3c8 <bcache>
    80004b96:	ffffc097          	auipc	ra,0xffffc
    80004b9a:	04c080e7          	jalr	76(ra) # 80000be2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004b9e:	0001e497          	auipc	s1,0x1e
    80004ba2:	ae24b483          	ld	s1,-1310(s1) # 80022680 <bcache+0x82b8>
    80004ba6:	0001e797          	auipc	a5,0x1e
    80004baa:	a8a78793          	addi	a5,a5,-1398 # 80022630 <bcache+0x8268>
    80004bae:	02f48f63          	beq	s1,a5,80004bec <bread+0x70>
    80004bb2:	873e                	mv	a4,a5
    80004bb4:	a021                	j	80004bbc <bread+0x40>
    80004bb6:	68a4                	ld	s1,80(s1)
    80004bb8:	02e48a63          	beq	s1,a4,80004bec <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80004bbc:	449c                	lw	a5,8(s1)
    80004bbe:	ff379ce3          	bne	a5,s3,80004bb6 <bread+0x3a>
    80004bc2:	44dc                	lw	a5,12(s1)
    80004bc4:	ff2799e3          	bne	a5,s2,80004bb6 <bread+0x3a>
      b->refcnt++;
    80004bc8:	40bc                	lw	a5,64(s1)
    80004bca:	2785                	addiw	a5,a5,1
    80004bcc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004bce:	00015517          	auipc	a0,0x15
    80004bd2:	7fa50513          	addi	a0,a0,2042 # 8001a3c8 <bcache>
    80004bd6:	ffffc097          	auipc	ra,0xffffc
    80004bda:	0c0080e7          	jalr	192(ra) # 80000c96 <release>
      acquiresleep(&b->lock);
    80004bde:	01048513          	addi	a0,s1,16
    80004be2:	00001097          	auipc	ra,0x1
    80004be6:	466080e7          	jalr	1126(ra) # 80006048 <acquiresleep>
      return b;
    80004bea:	a8b9                	j	80004c48 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004bec:	0001e497          	auipc	s1,0x1e
    80004bf0:	a8c4b483          	ld	s1,-1396(s1) # 80022678 <bcache+0x82b0>
    80004bf4:	0001e797          	auipc	a5,0x1e
    80004bf8:	a3c78793          	addi	a5,a5,-1476 # 80022630 <bcache+0x8268>
    80004bfc:	00f48863          	beq	s1,a5,80004c0c <bread+0x90>
    80004c00:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80004c02:	40bc                	lw	a5,64(s1)
    80004c04:	cf81                	beqz	a5,80004c1c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004c06:	64a4                	ld	s1,72(s1)
    80004c08:	fee49de3          	bne	s1,a4,80004c02 <bread+0x86>
  panic("bget: no buffers");
    80004c0c:	00005517          	auipc	a0,0x5
    80004c10:	cc450513          	addi	a0,a0,-828 # 800098d0 <syscalls+0x170>
    80004c14:	ffffc097          	auipc	ra,0xffffc
    80004c18:	928080e7          	jalr	-1752(ra) # 8000053c <panic>
      b->dev = dev;
    80004c1c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80004c20:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80004c24:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80004c28:	4785                	li	a5,1
    80004c2a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004c2c:	00015517          	auipc	a0,0x15
    80004c30:	79c50513          	addi	a0,a0,1948 # 8001a3c8 <bcache>
    80004c34:	ffffc097          	auipc	ra,0xffffc
    80004c38:	062080e7          	jalr	98(ra) # 80000c96 <release>
      acquiresleep(&b->lock);
    80004c3c:	01048513          	addi	a0,s1,16
    80004c40:	00001097          	auipc	ra,0x1
    80004c44:	408080e7          	jalr	1032(ra) # 80006048 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80004c48:	409c                	lw	a5,0(s1)
    80004c4a:	cb89                	beqz	a5,80004c5c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	70a2                	ld	ra,40(sp)
    80004c50:	7402                	ld	s0,32(sp)
    80004c52:	64e2                	ld	s1,24(sp)
    80004c54:	6942                	ld	s2,16(sp)
    80004c56:	69a2                	ld	s3,8(sp)
    80004c58:	6145                	addi	sp,sp,48
    80004c5a:	8082                	ret
    virtio_disk_rw(b, 0);
    80004c5c:	4581                	li	a1,0
    80004c5e:	8526                	mv	a0,s1
    80004c60:	00003097          	auipc	ra,0x3
    80004c64:	f06080e7          	jalr	-250(ra) # 80007b66 <virtio_disk_rw>
    b->valid = 1;
    80004c68:	4785                	li	a5,1
    80004c6a:	c09c                	sw	a5,0(s1)
  return b;
    80004c6c:	b7c5                	j	80004c4c <bread+0xd0>

0000000080004c6e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80004c6e:	1101                	addi	sp,sp,-32
    80004c70:	ec06                	sd	ra,24(sp)
    80004c72:	e822                	sd	s0,16(sp)
    80004c74:	e426                	sd	s1,8(sp)
    80004c76:	1000                	addi	s0,sp,32
    80004c78:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004c7a:	0541                	addi	a0,a0,16
    80004c7c:	00001097          	auipc	ra,0x1
    80004c80:	466080e7          	jalr	1126(ra) # 800060e2 <holdingsleep>
    80004c84:	cd01                	beqz	a0,80004c9c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80004c86:	4585                	li	a1,1
    80004c88:	8526                	mv	a0,s1
    80004c8a:	00003097          	auipc	ra,0x3
    80004c8e:	edc080e7          	jalr	-292(ra) # 80007b66 <virtio_disk_rw>
}
    80004c92:	60e2                	ld	ra,24(sp)
    80004c94:	6442                	ld	s0,16(sp)
    80004c96:	64a2                	ld	s1,8(sp)
    80004c98:	6105                	addi	sp,sp,32
    80004c9a:	8082                	ret
    panic("bwrite");
    80004c9c:	00005517          	auipc	a0,0x5
    80004ca0:	c4c50513          	addi	a0,a0,-948 # 800098e8 <syscalls+0x188>
    80004ca4:	ffffc097          	auipc	ra,0xffffc
    80004ca8:	898080e7          	jalr	-1896(ra) # 8000053c <panic>

0000000080004cac <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80004cac:	1101                	addi	sp,sp,-32
    80004cae:	ec06                	sd	ra,24(sp)
    80004cb0:	e822                	sd	s0,16(sp)
    80004cb2:	e426                	sd	s1,8(sp)
    80004cb4:	e04a                	sd	s2,0(sp)
    80004cb6:	1000                	addi	s0,sp,32
    80004cb8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004cba:	01050913          	addi	s2,a0,16
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	00001097          	auipc	ra,0x1
    80004cc4:	422080e7          	jalr	1058(ra) # 800060e2 <holdingsleep>
    80004cc8:	c92d                	beqz	a0,80004d3a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80004cca:	854a                	mv	a0,s2
    80004ccc:	00001097          	auipc	ra,0x1
    80004cd0:	3d2080e7          	jalr	978(ra) # 8000609e <releasesleep>

  acquire(&bcache.lock);
    80004cd4:	00015517          	auipc	a0,0x15
    80004cd8:	6f450513          	addi	a0,a0,1780 # 8001a3c8 <bcache>
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	f06080e7          	jalr	-250(ra) # 80000be2 <acquire>
  b->refcnt--;
    80004ce4:	40bc                	lw	a5,64(s1)
    80004ce6:	37fd                	addiw	a5,a5,-1
    80004ce8:	0007871b          	sext.w	a4,a5
    80004cec:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004cee:	eb05                	bnez	a4,80004d1e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004cf0:	68bc                	ld	a5,80(s1)
    80004cf2:	64b8                	ld	a4,72(s1)
    80004cf4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80004cf6:	64bc                	ld	a5,72(s1)
    80004cf8:	68b8                	ld	a4,80(s1)
    80004cfa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004cfc:	0001d797          	auipc	a5,0x1d
    80004d00:	6cc78793          	addi	a5,a5,1740 # 800223c8 <bcache+0x8000>
    80004d04:	2b87b703          	ld	a4,696(a5)
    80004d08:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004d0a:	0001e717          	auipc	a4,0x1e
    80004d0e:	92670713          	addi	a4,a4,-1754 # 80022630 <bcache+0x8268>
    80004d12:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80004d14:	2b87b703          	ld	a4,696(a5)
    80004d18:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80004d1a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80004d1e:	00015517          	auipc	a0,0x15
    80004d22:	6aa50513          	addi	a0,a0,1706 # 8001a3c8 <bcache>
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	f70080e7          	jalr	-144(ra) # 80000c96 <release>
}
    80004d2e:	60e2                	ld	ra,24(sp)
    80004d30:	6442                	ld	s0,16(sp)
    80004d32:	64a2                	ld	s1,8(sp)
    80004d34:	6902                	ld	s2,0(sp)
    80004d36:	6105                	addi	sp,sp,32
    80004d38:	8082                	ret
    panic("brelse");
    80004d3a:	00005517          	auipc	a0,0x5
    80004d3e:	bb650513          	addi	a0,a0,-1098 # 800098f0 <syscalls+0x190>
    80004d42:	ffffb097          	auipc	ra,0xffffb
    80004d46:	7fa080e7          	jalr	2042(ra) # 8000053c <panic>

0000000080004d4a <bpin>:

void
bpin(struct buf *b) {
    80004d4a:	1101                	addi	sp,sp,-32
    80004d4c:	ec06                	sd	ra,24(sp)
    80004d4e:	e822                	sd	s0,16(sp)
    80004d50:	e426                	sd	s1,8(sp)
    80004d52:	1000                	addi	s0,sp,32
    80004d54:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80004d56:	00015517          	auipc	a0,0x15
    80004d5a:	67250513          	addi	a0,a0,1650 # 8001a3c8 <bcache>
    80004d5e:	ffffc097          	auipc	ra,0xffffc
    80004d62:	e84080e7          	jalr	-380(ra) # 80000be2 <acquire>
  b->refcnt++;
    80004d66:	40bc                	lw	a5,64(s1)
    80004d68:	2785                	addiw	a5,a5,1
    80004d6a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80004d6c:	00015517          	auipc	a0,0x15
    80004d70:	65c50513          	addi	a0,a0,1628 # 8001a3c8 <bcache>
    80004d74:	ffffc097          	auipc	ra,0xffffc
    80004d78:	f22080e7          	jalr	-222(ra) # 80000c96 <release>
}
    80004d7c:	60e2                	ld	ra,24(sp)
    80004d7e:	6442                	ld	s0,16(sp)
    80004d80:	64a2                	ld	s1,8(sp)
    80004d82:	6105                	addi	sp,sp,32
    80004d84:	8082                	ret

0000000080004d86 <bunpin>:

void
bunpin(struct buf *b) {
    80004d86:	1101                	addi	sp,sp,-32
    80004d88:	ec06                	sd	ra,24(sp)
    80004d8a:	e822                	sd	s0,16(sp)
    80004d8c:	e426                	sd	s1,8(sp)
    80004d8e:	1000                	addi	s0,sp,32
    80004d90:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80004d92:	00015517          	auipc	a0,0x15
    80004d96:	63650513          	addi	a0,a0,1590 # 8001a3c8 <bcache>
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	e48080e7          	jalr	-440(ra) # 80000be2 <acquire>
  b->refcnt--;
    80004da2:	40bc                	lw	a5,64(s1)
    80004da4:	37fd                	addiw	a5,a5,-1
    80004da6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80004da8:	00015517          	auipc	a0,0x15
    80004dac:	62050513          	addi	a0,a0,1568 # 8001a3c8 <bcache>
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	ee6080e7          	jalr	-282(ra) # 80000c96 <release>
}
    80004db8:	60e2                	ld	ra,24(sp)
    80004dba:	6442                	ld	s0,16(sp)
    80004dbc:	64a2                	ld	s1,8(sp)
    80004dbe:	6105                	addi	sp,sp,32
    80004dc0:	8082                	ret

0000000080004dc2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004dc2:	1101                	addi	sp,sp,-32
    80004dc4:	ec06                	sd	ra,24(sp)
    80004dc6:	e822                	sd	s0,16(sp)
    80004dc8:	e426                	sd	s1,8(sp)
    80004dca:	e04a                	sd	s2,0(sp)
    80004dcc:	1000                	addi	s0,sp,32
    80004dce:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004dd0:	00d5d59b          	srliw	a1,a1,0xd
    80004dd4:	0001e797          	auipc	a5,0x1e
    80004dd8:	cd07a783          	lw	a5,-816(a5) # 80022aa4 <sb+0x1c>
    80004ddc:	9dbd                	addw	a1,a1,a5
    80004dde:	00000097          	auipc	ra,0x0
    80004de2:	d9e080e7          	jalr	-610(ra) # 80004b7c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80004de6:	0074f713          	andi	a4,s1,7
    80004dea:	4785                	li	a5,1
    80004dec:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80004df0:	14ce                	slli	s1,s1,0x33
    80004df2:	90d9                	srli	s1,s1,0x36
    80004df4:	00950733          	add	a4,a0,s1
    80004df8:	05874703          	lbu	a4,88(a4)
    80004dfc:	00e7f6b3          	and	a3,a5,a4
    80004e00:	c69d                	beqz	a3,80004e2e <bfree+0x6c>
    80004e02:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80004e04:	94aa                	add	s1,s1,a0
    80004e06:	fff7c793          	not	a5,a5
    80004e0a:	8ff9                	and	a5,a5,a4
    80004e0c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80004e10:	00001097          	auipc	ra,0x1
    80004e14:	118080e7          	jalr	280(ra) # 80005f28 <log_write>
  brelse(bp);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	00000097          	auipc	ra,0x0
    80004e1e:	e92080e7          	jalr	-366(ra) # 80004cac <brelse>
}
    80004e22:	60e2                	ld	ra,24(sp)
    80004e24:	6442                	ld	s0,16(sp)
    80004e26:	64a2                	ld	s1,8(sp)
    80004e28:	6902                	ld	s2,0(sp)
    80004e2a:	6105                	addi	sp,sp,32
    80004e2c:	8082                	ret
    panic("freeing free block");
    80004e2e:	00005517          	auipc	a0,0x5
    80004e32:	aca50513          	addi	a0,a0,-1334 # 800098f8 <syscalls+0x198>
    80004e36:	ffffb097          	auipc	ra,0xffffb
    80004e3a:	706080e7          	jalr	1798(ra) # 8000053c <panic>

0000000080004e3e <balloc>:
{
    80004e3e:	711d                	addi	sp,sp,-96
    80004e40:	ec86                	sd	ra,88(sp)
    80004e42:	e8a2                	sd	s0,80(sp)
    80004e44:	e4a6                	sd	s1,72(sp)
    80004e46:	e0ca                	sd	s2,64(sp)
    80004e48:	fc4e                	sd	s3,56(sp)
    80004e4a:	f852                	sd	s4,48(sp)
    80004e4c:	f456                	sd	s5,40(sp)
    80004e4e:	f05a                	sd	s6,32(sp)
    80004e50:	ec5e                	sd	s7,24(sp)
    80004e52:	e862                	sd	s8,16(sp)
    80004e54:	e466                	sd	s9,8(sp)
    80004e56:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80004e58:	0001e797          	auipc	a5,0x1e
    80004e5c:	c347a783          	lw	a5,-972(a5) # 80022a8c <sb+0x4>
    80004e60:	cbd1                	beqz	a5,80004ef4 <balloc+0xb6>
    80004e62:	8baa                	mv	s7,a0
    80004e64:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004e66:	0001eb17          	auipc	s6,0x1e
    80004e6a:	c22b0b13          	addi	s6,s6,-990 # 80022a88 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004e6e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80004e70:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004e72:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004e74:	6c89                	lui	s9,0x2
    80004e76:	a831                	j	80004e92 <balloc+0x54>
    brelse(bp);
    80004e78:	854a                	mv	a0,s2
    80004e7a:	00000097          	auipc	ra,0x0
    80004e7e:	e32080e7          	jalr	-462(ra) # 80004cac <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004e82:	015c87bb          	addw	a5,s9,s5
    80004e86:	00078a9b          	sext.w	s5,a5
    80004e8a:	004b2703          	lw	a4,4(s6)
    80004e8e:	06eaf363          	bgeu	s5,a4,80004ef4 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80004e92:	41fad79b          	sraiw	a5,s5,0x1f
    80004e96:	0137d79b          	srliw	a5,a5,0x13
    80004e9a:	015787bb          	addw	a5,a5,s5
    80004e9e:	40d7d79b          	sraiw	a5,a5,0xd
    80004ea2:	01cb2583          	lw	a1,28(s6)
    80004ea6:	9dbd                	addw	a1,a1,a5
    80004ea8:	855e                	mv	a0,s7
    80004eaa:	00000097          	auipc	ra,0x0
    80004eae:	cd2080e7          	jalr	-814(ra) # 80004b7c <bread>
    80004eb2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004eb4:	004b2503          	lw	a0,4(s6)
    80004eb8:	000a849b          	sext.w	s1,s5
    80004ebc:	8662                	mv	a2,s8
    80004ebe:	faa4fde3          	bgeu	s1,a0,80004e78 <balloc+0x3a>
      m = 1 << (bi % 8);
    80004ec2:	41f6579b          	sraiw	a5,a2,0x1f
    80004ec6:	01d7d69b          	srliw	a3,a5,0x1d
    80004eca:	00c6873b          	addw	a4,a3,a2
    80004ece:	00777793          	andi	a5,a4,7
    80004ed2:	9f95                	subw	a5,a5,a3
    80004ed4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004ed8:	4037571b          	sraiw	a4,a4,0x3
    80004edc:	00e906b3          	add	a3,s2,a4
    80004ee0:	0586c683          	lbu	a3,88(a3)
    80004ee4:	00d7f5b3          	and	a1,a5,a3
    80004ee8:	cd91                	beqz	a1,80004f04 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004eea:	2605                	addiw	a2,a2,1
    80004eec:	2485                	addiw	s1,s1,1
    80004eee:	fd4618e3          	bne	a2,s4,80004ebe <balloc+0x80>
    80004ef2:	b759                	j	80004e78 <balloc+0x3a>
  panic("balloc: out of blocks");
    80004ef4:	00005517          	auipc	a0,0x5
    80004ef8:	a1c50513          	addi	a0,a0,-1508 # 80009910 <syscalls+0x1b0>
    80004efc:	ffffb097          	auipc	ra,0xffffb
    80004f00:	640080e7          	jalr	1600(ra) # 8000053c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004f04:	974a                	add	a4,a4,s2
    80004f06:	8fd5                	or	a5,a5,a3
    80004f08:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80004f0c:	854a                	mv	a0,s2
    80004f0e:	00001097          	auipc	ra,0x1
    80004f12:	01a080e7          	jalr	26(ra) # 80005f28 <log_write>
        brelse(bp);
    80004f16:	854a                	mv	a0,s2
    80004f18:	00000097          	auipc	ra,0x0
    80004f1c:	d94080e7          	jalr	-620(ra) # 80004cac <brelse>
  bp = bread(dev, bno);
    80004f20:	85a6                	mv	a1,s1
    80004f22:	855e                	mv	a0,s7
    80004f24:	00000097          	auipc	ra,0x0
    80004f28:	c58080e7          	jalr	-936(ra) # 80004b7c <bread>
    80004f2c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80004f2e:	40000613          	li	a2,1024
    80004f32:	4581                	li	a1,0
    80004f34:	05850513          	addi	a0,a0,88
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	da6080e7          	jalr	-602(ra) # 80000cde <memset>
  log_write(bp);
    80004f40:	854a                	mv	a0,s2
    80004f42:	00001097          	auipc	ra,0x1
    80004f46:	fe6080e7          	jalr	-26(ra) # 80005f28 <log_write>
  brelse(bp);
    80004f4a:	854a                	mv	a0,s2
    80004f4c:	00000097          	auipc	ra,0x0
    80004f50:	d60080e7          	jalr	-672(ra) # 80004cac <brelse>
}
    80004f54:	8526                	mv	a0,s1
    80004f56:	60e6                	ld	ra,88(sp)
    80004f58:	6446                	ld	s0,80(sp)
    80004f5a:	64a6                	ld	s1,72(sp)
    80004f5c:	6906                	ld	s2,64(sp)
    80004f5e:	79e2                	ld	s3,56(sp)
    80004f60:	7a42                	ld	s4,48(sp)
    80004f62:	7aa2                	ld	s5,40(sp)
    80004f64:	7b02                	ld	s6,32(sp)
    80004f66:	6be2                	ld	s7,24(sp)
    80004f68:	6c42                	ld	s8,16(sp)
    80004f6a:	6ca2                	ld	s9,8(sp)
    80004f6c:	6125                	addi	sp,sp,96
    80004f6e:	8082                	ret

0000000080004f70 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80004f70:	7179                	addi	sp,sp,-48
    80004f72:	f406                	sd	ra,40(sp)
    80004f74:	f022                	sd	s0,32(sp)
    80004f76:	ec26                	sd	s1,24(sp)
    80004f78:	e84a                	sd	s2,16(sp)
    80004f7a:	e44e                	sd	s3,8(sp)
    80004f7c:	e052                	sd	s4,0(sp)
    80004f7e:	1800                	addi	s0,sp,48
    80004f80:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80004f82:	47ad                	li	a5,11
    80004f84:	04b7fe63          	bgeu	a5,a1,80004fe0 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80004f88:	ff45849b          	addiw	s1,a1,-12
    80004f8c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80004f90:	0ff00793          	li	a5,255
    80004f94:	0ae7e363          	bltu	a5,a4,8000503a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80004f98:	08052583          	lw	a1,128(a0)
    80004f9c:	c5ad                	beqz	a1,80005006 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80004f9e:	00092503          	lw	a0,0(s2)
    80004fa2:	00000097          	auipc	ra,0x0
    80004fa6:	bda080e7          	jalr	-1062(ra) # 80004b7c <bread>
    80004faa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80004fac:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80004fb0:	02049593          	slli	a1,s1,0x20
    80004fb4:	9181                	srli	a1,a1,0x20
    80004fb6:	058a                	slli	a1,a1,0x2
    80004fb8:	00b784b3          	add	s1,a5,a1
    80004fbc:	0004a983          	lw	s3,0(s1)
    80004fc0:	04098d63          	beqz	s3,8000501a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80004fc4:	8552                	mv	a0,s4
    80004fc6:	00000097          	auipc	ra,0x0
    80004fca:	ce6080e7          	jalr	-794(ra) # 80004cac <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80004fce:	854e                	mv	a0,s3
    80004fd0:	70a2                	ld	ra,40(sp)
    80004fd2:	7402                	ld	s0,32(sp)
    80004fd4:	64e2                	ld	s1,24(sp)
    80004fd6:	6942                	ld	s2,16(sp)
    80004fd8:	69a2                	ld	s3,8(sp)
    80004fda:	6a02                	ld	s4,0(sp)
    80004fdc:	6145                	addi	sp,sp,48
    80004fde:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80004fe0:	02059493          	slli	s1,a1,0x20
    80004fe4:	9081                	srli	s1,s1,0x20
    80004fe6:	048a                	slli	s1,s1,0x2
    80004fe8:	94aa                	add	s1,s1,a0
    80004fea:	0504a983          	lw	s3,80(s1)
    80004fee:	fe0990e3          	bnez	s3,80004fce <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80004ff2:	4108                	lw	a0,0(a0)
    80004ff4:	00000097          	auipc	ra,0x0
    80004ff8:	e4a080e7          	jalr	-438(ra) # 80004e3e <balloc>
    80004ffc:	0005099b          	sext.w	s3,a0
    80005000:	0534a823          	sw	s3,80(s1)
    80005004:	b7e9                	j	80004fce <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80005006:	4108                	lw	a0,0(a0)
    80005008:	00000097          	auipc	ra,0x0
    8000500c:	e36080e7          	jalr	-458(ra) # 80004e3e <balloc>
    80005010:	0005059b          	sext.w	a1,a0
    80005014:	08b92023          	sw	a1,128(s2)
    80005018:	b759                	j	80004f9e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000501a:	00092503          	lw	a0,0(s2)
    8000501e:	00000097          	auipc	ra,0x0
    80005022:	e20080e7          	jalr	-480(ra) # 80004e3e <balloc>
    80005026:	0005099b          	sext.w	s3,a0
    8000502a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000502e:	8552                	mv	a0,s4
    80005030:	00001097          	auipc	ra,0x1
    80005034:	ef8080e7          	jalr	-264(ra) # 80005f28 <log_write>
    80005038:	b771                	j	80004fc4 <bmap+0x54>
  panic("bmap: out of range");
    8000503a:	00005517          	auipc	a0,0x5
    8000503e:	8ee50513          	addi	a0,a0,-1810 # 80009928 <syscalls+0x1c8>
    80005042:	ffffb097          	auipc	ra,0xffffb
    80005046:	4fa080e7          	jalr	1274(ra) # 8000053c <panic>

000000008000504a <iget>:
{
    8000504a:	7179                	addi	sp,sp,-48
    8000504c:	f406                	sd	ra,40(sp)
    8000504e:	f022                	sd	s0,32(sp)
    80005050:	ec26                	sd	s1,24(sp)
    80005052:	e84a                	sd	s2,16(sp)
    80005054:	e44e                	sd	s3,8(sp)
    80005056:	e052                	sd	s4,0(sp)
    80005058:	1800                	addi	s0,sp,48
    8000505a:	89aa                	mv	s3,a0
    8000505c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000505e:	0001e517          	auipc	a0,0x1e
    80005062:	a4a50513          	addi	a0,a0,-1462 # 80022aa8 <itable>
    80005066:	ffffc097          	auipc	ra,0xffffc
    8000506a:	b7c080e7          	jalr	-1156(ra) # 80000be2 <acquire>
  empty = 0;
    8000506e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80005070:	0001e497          	auipc	s1,0x1e
    80005074:	a5048493          	addi	s1,s1,-1456 # 80022ac0 <itable+0x18>
    80005078:	0001f697          	auipc	a3,0x1f
    8000507c:	4d868693          	addi	a3,a3,1240 # 80024550 <log>
    80005080:	a039                	j	8000508e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80005082:	02090b63          	beqz	s2,800050b8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80005086:	08848493          	addi	s1,s1,136
    8000508a:	02d48a63          	beq	s1,a3,800050be <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000508e:	449c                	lw	a5,8(s1)
    80005090:	fef059e3          	blez	a5,80005082 <iget+0x38>
    80005094:	4098                	lw	a4,0(s1)
    80005096:	ff3716e3          	bne	a4,s3,80005082 <iget+0x38>
    8000509a:	40d8                	lw	a4,4(s1)
    8000509c:	ff4713e3          	bne	a4,s4,80005082 <iget+0x38>
      ip->ref++;
    800050a0:	2785                	addiw	a5,a5,1
    800050a2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800050a4:	0001e517          	auipc	a0,0x1e
    800050a8:	a0450513          	addi	a0,a0,-1532 # 80022aa8 <itable>
    800050ac:	ffffc097          	auipc	ra,0xffffc
    800050b0:	bea080e7          	jalr	-1046(ra) # 80000c96 <release>
      return ip;
    800050b4:	8926                	mv	s2,s1
    800050b6:	a03d                	j	800050e4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800050b8:	f7f9                	bnez	a5,80005086 <iget+0x3c>
    800050ba:	8926                	mv	s2,s1
    800050bc:	b7e9                	j	80005086 <iget+0x3c>
  if(empty == 0)
    800050be:	02090c63          	beqz	s2,800050f6 <iget+0xac>
  ip->dev = dev;
    800050c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800050c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800050ca:	4785                	li	a5,1
    800050cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800050d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800050d4:	0001e517          	auipc	a0,0x1e
    800050d8:	9d450513          	addi	a0,a0,-1580 # 80022aa8 <itable>
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	bba080e7          	jalr	-1094(ra) # 80000c96 <release>
}
    800050e4:	854a                	mv	a0,s2
    800050e6:	70a2                	ld	ra,40(sp)
    800050e8:	7402                	ld	s0,32(sp)
    800050ea:	64e2                	ld	s1,24(sp)
    800050ec:	6942                	ld	s2,16(sp)
    800050ee:	69a2                	ld	s3,8(sp)
    800050f0:	6a02                	ld	s4,0(sp)
    800050f2:	6145                	addi	sp,sp,48
    800050f4:	8082                	ret
    panic("iget: no inodes");
    800050f6:	00005517          	auipc	a0,0x5
    800050fa:	84a50513          	addi	a0,a0,-1974 # 80009940 <syscalls+0x1e0>
    800050fe:	ffffb097          	auipc	ra,0xffffb
    80005102:	43e080e7          	jalr	1086(ra) # 8000053c <panic>

0000000080005106 <fsinit>:
fsinit(int dev) {
    80005106:	7179                	addi	sp,sp,-48
    80005108:	f406                	sd	ra,40(sp)
    8000510a:	f022                	sd	s0,32(sp)
    8000510c:	ec26                	sd	s1,24(sp)
    8000510e:	e84a                	sd	s2,16(sp)
    80005110:	e44e                	sd	s3,8(sp)
    80005112:	1800                	addi	s0,sp,48
    80005114:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80005116:	4585                	li	a1,1
    80005118:	00000097          	auipc	ra,0x0
    8000511c:	a64080e7          	jalr	-1436(ra) # 80004b7c <bread>
    80005120:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80005122:	0001e997          	auipc	s3,0x1e
    80005126:	96698993          	addi	s3,s3,-1690 # 80022a88 <sb>
    8000512a:	02000613          	li	a2,32
    8000512e:	05850593          	addi	a1,a0,88
    80005132:	854e                	mv	a0,s3
    80005134:	ffffc097          	auipc	ra,0xffffc
    80005138:	c0a080e7          	jalr	-1014(ra) # 80000d3e <memmove>
  brelse(bp);
    8000513c:	8526                	mv	a0,s1
    8000513e:	00000097          	auipc	ra,0x0
    80005142:	b6e080e7          	jalr	-1170(ra) # 80004cac <brelse>
  if(sb.magic != FSMAGIC)
    80005146:	0009a703          	lw	a4,0(s3)
    8000514a:	102037b7          	lui	a5,0x10203
    8000514e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80005152:	02f71263          	bne	a4,a5,80005176 <fsinit+0x70>
  initlog(dev, &sb);
    80005156:	0001e597          	auipc	a1,0x1e
    8000515a:	93258593          	addi	a1,a1,-1742 # 80022a88 <sb>
    8000515e:	854a                	mv	a0,s2
    80005160:	00001097          	auipc	ra,0x1
    80005164:	b4c080e7          	jalr	-1204(ra) # 80005cac <initlog>
}
    80005168:	70a2                	ld	ra,40(sp)
    8000516a:	7402                	ld	s0,32(sp)
    8000516c:	64e2                	ld	s1,24(sp)
    8000516e:	6942                	ld	s2,16(sp)
    80005170:	69a2                	ld	s3,8(sp)
    80005172:	6145                	addi	sp,sp,48
    80005174:	8082                	ret
    panic("invalid file system");
    80005176:	00004517          	auipc	a0,0x4
    8000517a:	7da50513          	addi	a0,a0,2010 # 80009950 <syscalls+0x1f0>
    8000517e:	ffffb097          	auipc	ra,0xffffb
    80005182:	3be080e7          	jalr	958(ra) # 8000053c <panic>

0000000080005186 <iinit>:
{
    80005186:	7179                	addi	sp,sp,-48
    80005188:	f406                	sd	ra,40(sp)
    8000518a:	f022                	sd	s0,32(sp)
    8000518c:	ec26                	sd	s1,24(sp)
    8000518e:	e84a                	sd	s2,16(sp)
    80005190:	e44e                	sd	s3,8(sp)
    80005192:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80005194:	00004597          	auipc	a1,0x4
    80005198:	7d458593          	addi	a1,a1,2004 # 80009968 <syscalls+0x208>
    8000519c:	0001e517          	auipc	a0,0x1e
    800051a0:	90c50513          	addi	a0,a0,-1780 # 80022aa8 <itable>
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	9ae080e7          	jalr	-1618(ra) # 80000b52 <initlock>
  for(i = 0; i < NINODE; i++) {
    800051ac:	0001e497          	auipc	s1,0x1e
    800051b0:	92448493          	addi	s1,s1,-1756 # 80022ad0 <itable+0x28>
    800051b4:	0001f997          	auipc	s3,0x1f
    800051b8:	3ac98993          	addi	s3,s3,940 # 80024560 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800051bc:	00004917          	auipc	s2,0x4
    800051c0:	7b490913          	addi	s2,s2,1972 # 80009970 <syscalls+0x210>
    800051c4:	85ca                	mv	a1,s2
    800051c6:	8526                	mv	a0,s1
    800051c8:	00001097          	auipc	ra,0x1
    800051cc:	e46080e7          	jalr	-442(ra) # 8000600e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800051d0:	08848493          	addi	s1,s1,136
    800051d4:	ff3498e3          	bne	s1,s3,800051c4 <iinit+0x3e>
}
    800051d8:	70a2                	ld	ra,40(sp)
    800051da:	7402                	ld	s0,32(sp)
    800051dc:	64e2                	ld	s1,24(sp)
    800051de:	6942                	ld	s2,16(sp)
    800051e0:	69a2                	ld	s3,8(sp)
    800051e2:	6145                	addi	sp,sp,48
    800051e4:	8082                	ret

00000000800051e6 <ialloc>:
{
    800051e6:	715d                	addi	sp,sp,-80
    800051e8:	e486                	sd	ra,72(sp)
    800051ea:	e0a2                	sd	s0,64(sp)
    800051ec:	fc26                	sd	s1,56(sp)
    800051ee:	f84a                	sd	s2,48(sp)
    800051f0:	f44e                	sd	s3,40(sp)
    800051f2:	f052                	sd	s4,32(sp)
    800051f4:	ec56                	sd	s5,24(sp)
    800051f6:	e85a                	sd	s6,16(sp)
    800051f8:	e45e                	sd	s7,8(sp)
    800051fa:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800051fc:	0001e717          	auipc	a4,0x1e
    80005200:	89872703          	lw	a4,-1896(a4) # 80022a94 <sb+0xc>
    80005204:	4785                	li	a5,1
    80005206:	04e7fa63          	bgeu	a5,a4,8000525a <ialloc+0x74>
    8000520a:	8aaa                	mv	s5,a0
    8000520c:	8bae                	mv	s7,a1
    8000520e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80005210:	0001ea17          	auipc	s4,0x1e
    80005214:	878a0a13          	addi	s4,s4,-1928 # 80022a88 <sb>
    80005218:	00048b1b          	sext.w	s6,s1
    8000521c:	0044d593          	srli	a1,s1,0x4
    80005220:	018a2783          	lw	a5,24(s4)
    80005224:	9dbd                	addw	a1,a1,a5
    80005226:	8556                	mv	a0,s5
    80005228:	00000097          	auipc	ra,0x0
    8000522c:	954080e7          	jalr	-1708(ra) # 80004b7c <bread>
    80005230:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80005232:	05850993          	addi	s3,a0,88
    80005236:	00f4f793          	andi	a5,s1,15
    8000523a:	079a                	slli	a5,a5,0x6
    8000523c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000523e:	00099783          	lh	a5,0(s3)
    80005242:	c785                	beqz	a5,8000526a <ialloc+0x84>
    brelse(bp);
    80005244:	00000097          	auipc	ra,0x0
    80005248:	a68080e7          	jalr	-1432(ra) # 80004cac <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000524c:	0485                	addi	s1,s1,1
    8000524e:	00ca2703          	lw	a4,12(s4)
    80005252:	0004879b          	sext.w	a5,s1
    80005256:	fce7e1e3          	bltu	a5,a4,80005218 <ialloc+0x32>
  panic("ialloc: no inodes");
    8000525a:	00004517          	auipc	a0,0x4
    8000525e:	71e50513          	addi	a0,a0,1822 # 80009978 <syscalls+0x218>
    80005262:	ffffb097          	auipc	ra,0xffffb
    80005266:	2da080e7          	jalr	730(ra) # 8000053c <panic>
      memset(dip, 0, sizeof(*dip));
    8000526a:	04000613          	li	a2,64
    8000526e:	4581                	li	a1,0
    80005270:	854e                	mv	a0,s3
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	a6c080e7          	jalr	-1428(ra) # 80000cde <memset>
      dip->type = type;
    8000527a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000527e:	854a                	mv	a0,s2
    80005280:	00001097          	auipc	ra,0x1
    80005284:	ca8080e7          	jalr	-856(ra) # 80005f28 <log_write>
      brelse(bp);
    80005288:	854a                	mv	a0,s2
    8000528a:	00000097          	auipc	ra,0x0
    8000528e:	a22080e7          	jalr	-1502(ra) # 80004cac <brelse>
      return iget(dev, inum);
    80005292:	85da                	mv	a1,s6
    80005294:	8556                	mv	a0,s5
    80005296:	00000097          	auipc	ra,0x0
    8000529a:	db4080e7          	jalr	-588(ra) # 8000504a <iget>
}
    8000529e:	60a6                	ld	ra,72(sp)
    800052a0:	6406                	ld	s0,64(sp)
    800052a2:	74e2                	ld	s1,56(sp)
    800052a4:	7942                	ld	s2,48(sp)
    800052a6:	79a2                	ld	s3,40(sp)
    800052a8:	7a02                	ld	s4,32(sp)
    800052aa:	6ae2                	ld	s5,24(sp)
    800052ac:	6b42                	ld	s6,16(sp)
    800052ae:	6ba2                	ld	s7,8(sp)
    800052b0:	6161                	addi	sp,sp,80
    800052b2:	8082                	ret

00000000800052b4 <iupdate>:
{
    800052b4:	1101                	addi	sp,sp,-32
    800052b6:	ec06                	sd	ra,24(sp)
    800052b8:	e822                	sd	s0,16(sp)
    800052ba:	e426                	sd	s1,8(sp)
    800052bc:	e04a                	sd	s2,0(sp)
    800052be:	1000                	addi	s0,sp,32
    800052c0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800052c2:	415c                	lw	a5,4(a0)
    800052c4:	0047d79b          	srliw	a5,a5,0x4
    800052c8:	0001d597          	auipc	a1,0x1d
    800052cc:	7d85a583          	lw	a1,2008(a1) # 80022aa0 <sb+0x18>
    800052d0:	9dbd                	addw	a1,a1,a5
    800052d2:	4108                	lw	a0,0(a0)
    800052d4:	00000097          	auipc	ra,0x0
    800052d8:	8a8080e7          	jalr	-1880(ra) # 80004b7c <bread>
    800052dc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800052de:	05850793          	addi	a5,a0,88
    800052e2:	40c8                	lw	a0,4(s1)
    800052e4:	893d                	andi	a0,a0,15
    800052e6:	051a                	slli	a0,a0,0x6
    800052e8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800052ea:	04449703          	lh	a4,68(s1)
    800052ee:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800052f2:	04649703          	lh	a4,70(s1)
    800052f6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800052fa:	04849703          	lh	a4,72(s1)
    800052fe:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80005302:	04a49703          	lh	a4,74(s1)
    80005306:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000530a:	44f8                	lw	a4,76(s1)
    8000530c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000530e:	03400613          	li	a2,52
    80005312:	05048593          	addi	a1,s1,80
    80005316:	0531                	addi	a0,a0,12
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	a26080e7          	jalr	-1498(ra) # 80000d3e <memmove>
  log_write(bp);
    80005320:	854a                	mv	a0,s2
    80005322:	00001097          	auipc	ra,0x1
    80005326:	c06080e7          	jalr	-1018(ra) # 80005f28 <log_write>
  brelse(bp);
    8000532a:	854a                	mv	a0,s2
    8000532c:	00000097          	auipc	ra,0x0
    80005330:	980080e7          	jalr	-1664(ra) # 80004cac <brelse>
}
    80005334:	60e2                	ld	ra,24(sp)
    80005336:	6442                	ld	s0,16(sp)
    80005338:	64a2                	ld	s1,8(sp)
    8000533a:	6902                	ld	s2,0(sp)
    8000533c:	6105                	addi	sp,sp,32
    8000533e:	8082                	ret

0000000080005340 <idup>:
{
    80005340:	1101                	addi	sp,sp,-32
    80005342:	ec06                	sd	ra,24(sp)
    80005344:	e822                	sd	s0,16(sp)
    80005346:	e426                	sd	s1,8(sp)
    80005348:	1000                	addi	s0,sp,32
    8000534a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000534c:	0001d517          	auipc	a0,0x1d
    80005350:	75c50513          	addi	a0,a0,1884 # 80022aa8 <itable>
    80005354:	ffffc097          	auipc	ra,0xffffc
    80005358:	88e080e7          	jalr	-1906(ra) # 80000be2 <acquire>
  ip->ref++;
    8000535c:	449c                	lw	a5,8(s1)
    8000535e:	2785                	addiw	a5,a5,1
    80005360:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80005362:	0001d517          	auipc	a0,0x1d
    80005366:	74650513          	addi	a0,a0,1862 # 80022aa8 <itable>
    8000536a:	ffffc097          	auipc	ra,0xffffc
    8000536e:	92c080e7          	jalr	-1748(ra) # 80000c96 <release>
}
    80005372:	8526                	mv	a0,s1
    80005374:	60e2                	ld	ra,24(sp)
    80005376:	6442                	ld	s0,16(sp)
    80005378:	64a2                	ld	s1,8(sp)
    8000537a:	6105                	addi	sp,sp,32
    8000537c:	8082                	ret

000000008000537e <ilock>:
{
    8000537e:	1101                	addi	sp,sp,-32
    80005380:	ec06                	sd	ra,24(sp)
    80005382:	e822                	sd	s0,16(sp)
    80005384:	e426                	sd	s1,8(sp)
    80005386:	e04a                	sd	s2,0(sp)
    80005388:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000538a:	c115                	beqz	a0,800053ae <ilock+0x30>
    8000538c:	84aa                	mv	s1,a0
    8000538e:	451c                	lw	a5,8(a0)
    80005390:	00f05f63          	blez	a5,800053ae <ilock+0x30>
  acquiresleep(&ip->lock);
    80005394:	0541                	addi	a0,a0,16
    80005396:	00001097          	auipc	ra,0x1
    8000539a:	cb2080e7          	jalr	-846(ra) # 80006048 <acquiresleep>
  if(ip->valid == 0){
    8000539e:	40bc                	lw	a5,64(s1)
    800053a0:	cf99                	beqz	a5,800053be <ilock+0x40>
}
    800053a2:	60e2                	ld	ra,24(sp)
    800053a4:	6442                	ld	s0,16(sp)
    800053a6:	64a2                	ld	s1,8(sp)
    800053a8:	6902                	ld	s2,0(sp)
    800053aa:	6105                	addi	sp,sp,32
    800053ac:	8082                	ret
    panic("ilock");
    800053ae:	00004517          	auipc	a0,0x4
    800053b2:	5e250513          	addi	a0,a0,1506 # 80009990 <syscalls+0x230>
    800053b6:	ffffb097          	auipc	ra,0xffffb
    800053ba:	186080e7          	jalr	390(ra) # 8000053c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800053be:	40dc                	lw	a5,4(s1)
    800053c0:	0047d79b          	srliw	a5,a5,0x4
    800053c4:	0001d597          	auipc	a1,0x1d
    800053c8:	6dc5a583          	lw	a1,1756(a1) # 80022aa0 <sb+0x18>
    800053cc:	9dbd                	addw	a1,a1,a5
    800053ce:	4088                	lw	a0,0(s1)
    800053d0:	fffff097          	auipc	ra,0xfffff
    800053d4:	7ac080e7          	jalr	1964(ra) # 80004b7c <bread>
    800053d8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800053da:	05850593          	addi	a1,a0,88
    800053de:	40dc                	lw	a5,4(s1)
    800053e0:	8bbd                	andi	a5,a5,15
    800053e2:	079a                	slli	a5,a5,0x6
    800053e4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800053e6:	00059783          	lh	a5,0(a1)
    800053ea:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800053ee:	00259783          	lh	a5,2(a1)
    800053f2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800053f6:	00459783          	lh	a5,4(a1)
    800053fa:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800053fe:	00659783          	lh	a5,6(a1)
    80005402:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80005406:	459c                	lw	a5,8(a1)
    80005408:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000540a:	03400613          	li	a2,52
    8000540e:	05b1                	addi	a1,a1,12
    80005410:	05048513          	addi	a0,s1,80
    80005414:	ffffc097          	auipc	ra,0xffffc
    80005418:	92a080e7          	jalr	-1750(ra) # 80000d3e <memmove>
    brelse(bp);
    8000541c:	854a                	mv	a0,s2
    8000541e:	00000097          	auipc	ra,0x0
    80005422:	88e080e7          	jalr	-1906(ra) # 80004cac <brelse>
    ip->valid = 1;
    80005426:	4785                	li	a5,1
    80005428:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000542a:	04449783          	lh	a5,68(s1)
    8000542e:	fbb5                	bnez	a5,800053a2 <ilock+0x24>
      panic("ilock: no type");
    80005430:	00004517          	auipc	a0,0x4
    80005434:	56850513          	addi	a0,a0,1384 # 80009998 <syscalls+0x238>
    80005438:	ffffb097          	auipc	ra,0xffffb
    8000543c:	104080e7          	jalr	260(ra) # 8000053c <panic>

0000000080005440 <iunlock>:
{
    80005440:	1101                	addi	sp,sp,-32
    80005442:	ec06                	sd	ra,24(sp)
    80005444:	e822                	sd	s0,16(sp)
    80005446:	e426                	sd	s1,8(sp)
    80005448:	e04a                	sd	s2,0(sp)
    8000544a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000544c:	c905                	beqz	a0,8000547c <iunlock+0x3c>
    8000544e:	84aa                	mv	s1,a0
    80005450:	01050913          	addi	s2,a0,16
    80005454:	854a                	mv	a0,s2
    80005456:	00001097          	auipc	ra,0x1
    8000545a:	c8c080e7          	jalr	-884(ra) # 800060e2 <holdingsleep>
    8000545e:	cd19                	beqz	a0,8000547c <iunlock+0x3c>
    80005460:	449c                	lw	a5,8(s1)
    80005462:	00f05d63          	blez	a5,8000547c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80005466:	854a                	mv	a0,s2
    80005468:	00001097          	auipc	ra,0x1
    8000546c:	c36080e7          	jalr	-970(ra) # 8000609e <releasesleep>
}
    80005470:	60e2                	ld	ra,24(sp)
    80005472:	6442                	ld	s0,16(sp)
    80005474:	64a2                	ld	s1,8(sp)
    80005476:	6902                	ld	s2,0(sp)
    80005478:	6105                	addi	sp,sp,32
    8000547a:	8082                	ret
    panic("iunlock");
    8000547c:	00004517          	auipc	a0,0x4
    80005480:	52c50513          	addi	a0,a0,1324 # 800099a8 <syscalls+0x248>
    80005484:	ffffb097          	auipc	ra,0xffffb
    80005488:	0b8080e7          	jalr	184(ra) # 8000053c <panic>

000000008000548c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000548c:	7179                	addi	sp,sp,-48
    8000548e:	f406                	sd	ra,40(sp)
    80005490:	f022                	sd	s0,32(sp)
    80005492:	ec26                	sd	s1,24(sp)
    80005494:	e84a                	sd	s2,16(sp)
    80005496:	e44e                	sd	s3,8(sp)
    80005498:	e052                	sd	s4,0(sp)
    8000549a:	1800                	addi	s0,sp,48
    8000549c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000549e:	05050493          	addi	s1,a0,80
    800054a2:	08050913          	addi	s2,a0,128
    800054a6:	a021                	j	800054ae <itrunc+0x22>
    800054a8:	0491                	addi	s1,s1,4
    800054aa:	01248d63          	beq	s1,s2,800054c4 <itrunc+0x38>
    if(ip->addrs[i]){
    800054ae:	408c                	lw	a1,0(s1)
    800054b0:	dde5                	beqz	a1,800054a8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800054b2:	0009a503          	lw	a0,0(s3)
    800054b6:	00000097          	auipc	ra,0x0
    800054ba:	90c080e7          	jalr	-1780(ra) # 80004dc2 <bfree>
      ip->addrs[i] = 0;
    800054be:	0004a023          	sw	zero,0(s1)
    800054c2:	b7dd                	j	800054a8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800054c4:	0809a583          	lw	a1,128(s3)
    800054c8:	e185                	bnez	a1,800054e8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800054ca:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800054ce:	854e                	mv	a0,s3
    800054d0:	00000097          	auipc	ra,0x0
    800054d4:	de4080e7          	jalr	-540(ra) # 800052b4 <iupdate>
}
    800054d8:	70a2                	ld	ra,40(sp)
    800054da:	7402                	ld	s0,32(sp)
    800054dc:	64e2                	ld	s1,24(sp)
    800054de:	6942                	ld	s2,16(sp)
    800054e0:	69a2                	ld	s3,8(sp)
    800054e2:	6a02                	ld	s4,0(sp)
    800054e4:	6145                	addi	sp,sp,48
    800054e6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800054e8:	0009a503          	lw	a0,0(s3)
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	690080e7          	jalr	1680(ra) # 80004b7c <bread>
    800054f4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800054f6:	05850493          	addi	s1,a0,88
    800054fa:	45850913          	addi	s2,a0,1112
    800054fe:	a811                	j	80005512 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80005500:	0009a503          	lw	a0,0(s3)
    80005504:	00000097          	auipc	ra,0x0
    80005508:	8be080e7          	jalr	-1858(ra) # 80004dc2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000550c:	0491                	addi	s1,s1,4
    8000550e:	01248563          	beq	s1,s2,80005518 <itrunc+0x8c>
      if(a[j])
    80005512:	408c                	lw	a1,0(s1)
    80005514:	dde5                	beqz	a1,8000550c <itrunc+0x80>
    80005516:	b7ed                	j	80005500 <itrunc+0x74>
    brelse(bp);
    80005518:	8552                	mv	a0,s4
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	792080e7          	jalr	1938(ra) # 80004cac <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80005522:	0809a583          	lw	a1,128(s3)
    80005526:	0009a503          	lw	a0,0(s3)
    8000552a:	00000097          	auipc	ra,0x0
    8000552e:	898080e7          	jalr	-1896(ra) # 80004dc2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80005532:	0809a023          	sw	zero,128(s3)
    80005536:	bf51                	j	800054ca <itrunc+0x3e>

0000000080005538 <iput>:
{
    80005538:	1101                	addi	sp,sp,-32
    8000553a:	ec06                	sd	ra,24(sp)
    8000553c:	e822                	sd	s0,16(sp)
    8000553e:	e426                	sd	s1,8(sp)
    80005540:	e04a                	sd	s2,0(sp)
    80005542:	1000                	addi	s0,sp,32
    80005544:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80005546:	0001d517          	auipc	a0,0x1d
    8000554a:	56250513          	addi	a0,a0,1378 # 80022aa8 <itable>
    8000554e:	ffffb097          	auipc	ra,0xffffb
    80005552:	694080e7          	jalr	1684(ra) # 80000be2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80005556:	4498                	lw	a4,8(s1)
    80005558:	4785                	li	a5,1
    8000555a:	02f70363          	beq	a4,a5,80005580 <iput+0x48>
  ip->ref--;
    8000555e:	449c                	lw	a5,8(s1)
    80005560:	37fd                	addiw	a5,a5,-1
    80005562:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80005564:	0001d517          	auipc	a0,0x1d
    80005568:	54450513          	addi	a0,a0,1348 # 80022aa8 <itable>
    8000556c:	ffffb097          	auipc	ra,0xffffb
    80005570:	72a080e7          	jalr	1834(ra) # 80000c96 <release>
}
    80005574:	60e2                	ld	ra,24(sp)
    80005576:	6442                	ld	s0,16(sp)
    80005578:	64a2                	ld	s1,8(sp)
    8000557a:	6902                	ld	s2,0(sp)
    8000557c:	6105                	addi	sp,sp,32
    8000557e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80005580:	40bc                	lw	a5,64(s1)
    80005582:	dff1                	beqz	a5,8000555e <iput+0x26>
    80005584:	04a49783          	lh	a5,74(s1)
    80005588:	fbf9                	bnez	a5,8000555e <iput+0x26>
    acquiresleep(&ip->lock);
    8000558a:	01048913          	addi	s2,s1,16
    8000558e:	854a                	mv	a0,s2
    80005590:	00001097          	auipc	ra,0x1
    80005594:	ab8080e7          	jalr	-1352(ra) # 80006048 <acquiresleep>
    release(&itable.lock);
    80005598:	0001d517          	auipc	a0,0x1d
    8000559c:	51050513          	addi	a0,a0,1296 # 80022aa8 <itable>
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	6f6080e7          	jalr	1782(ra) # 80000c96 <release>
    itrunc(ip);
    800055a8:	8526                	mv	a0,s1
    800055aa:	00000097          	auipc	ra,0x0
    800055ae:	ee2080e7          	jalr	-286(ra) # 8000548c <itrunc>
    ip->type = 0;
    800055b2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800055b6:	8526                	mv	a0,s1
    800055b8:	00000097          	auipc	ra,0x0
    800055bc:	cfc080e7          	jalr	-772(ra) # 800052b4 <iupdate>
    ip->valid = 0;
    800055c0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800055c4:	854a                	mv	a0,s2
    800055c6:	00001097          	auipc	ra,0x1
    800055ca:	ad8080e7          	jalr	-1320(ra) # 8000609e <releasesleep>
    acquire(&itable.lock);
    800055ce:	0001d517          	auipc	a0,0x1d
    800055d2:	4da50513          	addi	a0,a0,1242 # 80022aa8 <itable>
    800055d6:	ffffb097          	auipc	ra,0xffffb
    800055da:	60c080e7          	jalr	1548(ra) # 80000be2 <acquire>
    800055de:	b741                	j	8000555e <iput+0x26>

00000000800055e0 <iunlockput>:
{
    800055e0:	1101                	addi	sp,sp,-32
    800055e2:	ec06                	sd	ra,24(sp)
    800055e4:	e822                	sd	s0,16(sp)
    800055e6:	e426                	sd	s1,8(sp)
    800055e8:	1000                	addi	s0,sp,32
    800055ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800055ec:	00000097          	auipc	ra,0x0
    800055f0:	e54080e7          	jalr	-428(ra) # 80005440 <iunlock>
  iput(ip);
    800055f4:	8526                	mv	a0,s1
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	f42080e7          	jalr	-190(ra) # 80005538 <iput>
}
    800055fe:	60e2                	ld	ra,24(sp)
    80005600:	6442                	ld	s0,16(sp)
    80005602:	64a2                	ld	s1,8(sp)
    80005604:	6105                	addi	sp,sp,32
    80005606:	8082                	ret

0000000080005608 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80005608:	1141                	addi	sp,sp,-16
    8000560a:	e422                	sd	s0,8(sp)
    8000560c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000560e:	411c                	lw	a5,0(a0)
    80005610:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80005612:	415c                	lw	a5,4(a0)
    80005614:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80005616:	04451783          	lh	a5,68(a0)
    8000561a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000561e:	04a51783          	lh	a5,74(a0)
    80005622:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80005626:	04c56783          	lwu	a5,76(a0)
    8000562a:	e99c                	sd	a5,16(a1)
}
    8000562c:	6422                	ld	s0,8(sp)
    8000562e:	0141                	addi	sp,sp,16
    80005630:	8082                	ret

0000000080005632 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80005632:	457c                	lw	a5,76(a0)
    80005634:	0ed7e963          	bltu	a5,a3,80005726 <readi+0xf4>
{
    80005638:	7159                	addi	sp,sp,-112
    8000563a:	f486                	sd	ra,104(sp)
    8000563c:	f0a2                	sd	s0,96(sp)
    8000563e:	eca6                	sd	s1,88(sp)
    80005640:	e8ca                	sd	s2,80(sp)
    80005642:	e4ce                	sd	s3,72(sp)
    80005644:	e0d2                	sd	s4,64(sp)
    80005646:	fc56                	sd	s5,56(sp)
    80005648:	f85a                	sd	s6,48(sp)
    8000564a:	f45e                	sd	s7,40(sp)
    8000564c:	f062                	sd	s8,32(sp)
    8000564e:	ec66                	sd	s9,24(sp)
    80005650:	e86a                	sd	s10,16(sp)
    80005652:	e46e                	sd	s11,8(sp)
    80005654:	1880                	addi	s0,sp,112
    80005656:	8baa                	mv	s7,a0
    80005658:	8c2e                	mv	s8,a1
    8000565a:	8ab2                	mv	s5,a2
    8000565c:	84b6                	mv	s1,a3
    8000565e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80005660:	9f35                	addw	a4,a4,a3
    return 0;
    80005662:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80005664:	0ad76063          	bltu	a4,a3,80005704 <readi+0xd2>
  if(off + n > ip->size)
    80005668:	00e7f463          	bgeu	a5,a4,80005670 <readi+0x3e>
    n = ip->size - off;
    8000566c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005670:	0a0b0963          	beqz	s6,80005722 <readi+0xf0>
    80005674:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80005676:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000567a:	5cfd                	li	s9,-1
    8000567c:	a82d                	j	800056b6 <readi+0x84>
    8000567e:	020a1d93          	slli	s11,s4,0x20
    80005682:	020ddd93          	srli	s11,s11,0x20
    80005686:	05890613          	addi	a2,s2,88
    8000568a:	86ee                	mv	a3,s11
    8000568c:	963a                	add	a2,a2,a4
    8000568e:	85d6                	mv	a1,s5
    80005690:	8562                	mv	a0,s8
    80005692:	ffffe097          	auipc	ra,0xffffe
    80005696:	ac4080e7          	jalr	-1340(ra) # 80003156 <either_copyout>
    8000569a:	05950d63          	beq	a0,s9,800056f4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000569e:	854a                	mv	a0,s2
    800056a0:	fffff097          	auipc	ra,0xfffff
    800056a4:	60c080e7          	jalr	1548(ra) # 80004cac <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800056a8:	013a09bb          	addw	s3,s4,s3
    800056ac:	009a04bb          	addw	s1,s4,s1
    800056b0:	9aee                	add	s5,s5,s11
    800056b2:	0569f763          	bgeu	s3,s6,80005700 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800056b6:	000ba903          	lw	s2,0(s7)
    800056ba:	00a4d59b          	srliw	a1,s1,0xa
    800056be:	855e                	mv	a0,s7
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	8b0080e7          	jalr	-1872(ra) # 80004f70 <bmap>
    800056c8:	0005059b          	sext.w	a1,a0
    800056cc:	854a                	mv	a0,s2
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	4ae080e7          	jalr	1198(ra) # 80004b7c <bread>
    800056d6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800056d8:	3ff4f713          	andi	a4,s1,1023
    800056dc:	40ed07bb          	subw	a5,s10,a4
    800056e0:	413b06bb          	subw	a3,s6,s3
    800056e4:	8a3e                	mv	s4,a5
    800056e6:	2781                	sext.w	a5,a5
    800056e8:	0006861b          	sext.w	a2,a3
    800056ec:	f8f679e3          	bgeu	a2,a5,8000567e <readi+0x4c>
    800056f0:	8a36                	mv	s4,a3
    800056f2:	b771                	j	8000567e <readi+0x4c>
      brelse(bp);
    800056f4:	854a                	mv	a0,s2
    800056f6:	fffff097          	auipc	ra,0xfffff
    800056fa:	5b6080e7          	jalr	1462(ra) # 80004cac <brelse>
      tot = -1;
    800056fe:	59fd                	li	s3,-1
  }
  return tot;
    80005700:	0009851b          	sext.w	a0,s3
}
    80005704:	70a6                	ld	ra,104(sp)
    80005706:	7406                	ld	s0,96(sp)
    80005708:	64e6                	ld	s1,88(sp)
    8000570a:	6946                	ld	s2,80(sp)
    8000570c:	69a6                	ld	s3,72(sp)
    8000570e:	6a06                	ld	s4,64(sp)
    80005710:	7ae2                	ld	s5,56(sp)
    80005712:	7b42                	ld	s6,48(sp)
    80005714:	7ba2                	ld	s7,40(sp)
    80005716:	7c02                	ld	s8,32(sp)
    80005718:	6ce2                	ld	s9,24(sp)
    8000571a:	6d42                	ld	s10,16(sp)
    8000571c:	6da2                	ld	s11,8(sp)
    8000571e:	6165                	addi	sp,sp,112
    80005720:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005722:	89da                	mv	s3,s6
    80005724:	bff1                	j	80005700 <readi+0xce>
    return 0;
    80005726:	4501                	li	a0,0
}
    80005728:	8082                	ret

000000008000572a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000572a:	457c                	lw	a5,76(a0)
    8000572c:	10d7e863          	bltu	a5,a3,8000583c <writei+0x112>
{
    80005730:	7159                	addi	sp,sp,-112
    80005732:	f486                	sd	ra,104(sp)
    80005734:	f0a2                	sd	s0,96(sp)
    80005736:	eca6                	sd	s1,88(sp)
    80005738:	e8ca                	sd	s2,80(sp)
    8000573a:	e4ce                	sd	s3,72(sp)
    8000573c:	e0d2                	sd	s4,64(sp)
    8000573e:	fc56                	sd	s5,56(sp)
    80005740:	f85a                	sd	s6,48(sp)
    80005742:	f45e                	sd	s7,40(sp)
    80005744:	f062                	sd	s8,32(sp)
    80005746:	ec66                	sd	s9,24(sp)
    80005748:	e86a                	sd	s10,16(sp)
    8000574a:	e46e                	sd	s11,8(sp)
    8000574c:	1880                	addi	s0,sp,112
    8000574e:	8b2a                	mv	s6,a0
    80005750:	8c2e                	mv	s8,a1
    80005752:	8ab2                	mv	s5,a2
    80005754:	8936                	mv	s2,a3
    80005756:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80005758:	00e687bb          	addw	a5,a3,a4
    8000575c:	0ed7e263          	bltu	a5,a3,80005840 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80005760:	00043737          	lui	a4,0x43
    80005764:	0ef76063          	bltu	a4,a5,80005844 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005768:	0c0b8863          	beqz	s7,80005838 <writei+0x10e>
    8000576c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000576e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80005772:	5cfd                	li	s9,-1
    80005774:	a091                	j	800057b8 <writei+0x8e>
    80005776:	02099d93          	slli	s11,s3,0x20
    8000577a:	020ddd93          	srli	s11,s11,0x20
    8000577e:	05848513          	addi	a0,s1,88
    80005782:	86ee                	mv	a3,s11
    80005784:	8656                	mv	a2,s5
    80005786:	85e2                	mv	a1,s8
    80005788:	953a                	add	a0,a0,a4
    8000578a:	ffffe097          	auipc	ra,0xffffe
    8000578e:	a22080e7          	jalr	-1502(ra) # 800031ac <either_copyin>
    80005792:	07950263          	beq	a0,s9,800057f6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80005796:	8526                	mv	a0,s1
    80005798:	00000097          	auipc	ra,0x0
    8000579c:	790080e7          	jalr	1936(ra) # 80005f28 <log_write>
    brelse(bp);
    800057a0:	8526                	mv	a0,s1
    800057a2:	fffff097          	auipc	ra,0xfffff
    800057a6:	50a080e7          	jalr	1290(ra) # 80004cac <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800057aa:	01498a3b          	addw	s4,s3,s4
    800057ae:	0129893b          	addw	s2,s3,s2
    800057b2:	9aee                	add	s5,s5,s11
    800057b4:	057a7663          	bgeu	s4,s7,80005800 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800057b8:	000b2483          	lw	s1,0(s6)
    800057bc:	00a9559b          	srliw	a1,s2,0xa
    800057c0:	855a                	mv	a0,s6
    800057c2:	fffff097          	auipc	ra,0xfffff
    800057c6:	7ae080e7          	jalr	1966(ra) # 80004f70 <bmap>
    800057ca:	0005059b          	sext.w	a1,a0
    800057ce:	8526                	mv	a0,s1
    800057d0:	fffff097          	auipc	ra,0xfffff
    800057d4:	3ac080e7          	jalr	940(ra) # 80004b7c <bread>
    800057d8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800057da:	3ff97713          	andi	a4,s2,1023
    800057de:	40ed07bb          	subw	a5,s10,a4
    800057e2:	414b86bb          	subw	a3,s7,s4
    800057e6:	89be                	mv	s3,a5
    800057e8:	2781                	sext.w	a5,a5
    800057ea:	0006861b          	sext.w	a2,a3
    800057ee:	f8f674e3          	bgeu	a2,a5,80005776 <writei+0x4c>
    800057f2:	89b6                	mv	s3,a3
    800057f4:	b749                	j	80005776 <writei+0x4c>
      brelse(bp);
    800057f6:	8526                	mv	a0,s1
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	4b4080e7          	jalr	1204(ra) # 80004cac <brelse>
  }

  if(off > ip->size)
    80005800:	04cb2783          	lw	a5,76(s6)
    80005804:	0127f463          	bgeu	a5,s2,8000580c <writei+0xe2>
    ip->size = off;
    80005808:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000580c:	855a                	mv	a0,s6
    8000580e:	00000097          	auipc	ra,0x0
    80005812:	aa6080e7          	jalr	-1370(ra) # 800052b4 <iupdate>

  return tot;
    80005816:	000a051b          	sext.w	a0,s4
}
    8000581a:	70a6                	ld	ra,104(sp)
    8000581c:	7406                	ld	s0,96(sp)
    8000581e:	64e6                	ld	s1,88(sp)
    80005820:	6946                	ld	s2,80(sp)
    80005822:	69a6                	ld	s3,72(sp)
    80005824:	6a06                	ld	s4,64(sp)
    80005826:	7ae2                	ld	s5,56(sp)
    80005828:	7b42                	ld	s6,48(sp)
    8000582a:	7ba2                	ld	s7,40(sp)
    8000582c:	7c02                	ld	s8,32(sp)
    8000582e:	6ce2                	ld	s9,24(sp)
    80005830:	6d42                	ld	s10,16(sp)
    80005832:	6da2                	ld	s11,8(sp)
    80005834:	6165                	addi	sp,sp,112
    80005836:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005838:	8a5e                	mv	s4,s7
    8000583a:	bfc9                	j	8000580c <writei+0xe2>
    return -1;
    8000583c:	557d                	li	a0,-1
}
    8000583e:	8082                	ret
    return -1;
    80005840:	557d                	li	a0,-1
    80005842:	bfe1                	j	8000581a <writei+0xf0>
    return -1;
    80005844:	557d                	li	a0,-1
    80005846:	bfd1                	j	8000581a <writei+0xf0>

0000000080005848 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80005848:	1141                	addi	sp,sp,-16
    8000584a:	e406                	sd	ra,8(sp)
    8000584c:	e022                	sd	s0,0(sp)
    8000584e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80005850:	4639                	li	a2,14
    80005852:	ffffb097          	auipc	ra,0xffffb
    80005856:	564080e7          	jalr	1380(ra) # 80000db6 <strncmp>
}
    8000585a:	60a2                	ld	ra,8(sp)
    8000585c:	6402                	ld	s0,0(sp)
    8000585e:	0141                	addi	sp,sp,16
    80005860:	8082                	ret

0000000080005862 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005862:	7139                	addi	sp,sp,-64
    80005864:	fc06                	sd	ra,56(sp)
    80005866:	f822                	sd	s0,48(sp)
    80005868:	f426                	sd	s1,40(sp)
    8000586a:	f04a                	sd	s2,32(sp)
    8000586c:	ec4e                	sd	s3,24(sp)
    8000586e:	e852                	sd	s4,16(sp)
    80005870:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005872:	04451703          	lh	a4,68(a0)
    80005876:	4785                	li	a5,1
    80005878:	00f71a63          	bne	a4,a5,8000588c <dirlookup+0x2a>
    8000587c:	892a                	mv	s2,a0
    8000587e:	89ae                	mv	s3,a1
    80005880:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005882:	457c                	lw	a5,76(a0)
    80005884:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80005886:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005888:	e79d                	bnez	a5,800058b6 <dirlookup+0x54>
    8000588a:	a8a5                	j	80005902 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000588c:	00004517          	auipc	a0,0x4
    80005890:	12450513          	addi	a0,a0,292 # 800099b0 <syscalls+0x250>
    80005894:	ffffb097          	auipc	ra,0xffffb
    80005898:	ca8080e7          	jalr	-856(ra) # 8000053c <panic>
      panic("dirlookup read");
    8000589c:	00004517          	auipc	a0,0x4
    800058a0:	12c50513          	addi	a0,a0,300 # 800099c8 <syscalls+0x268>
    800058a4:	ffffb097          	auipc	ra,0xffffb
    800058a8:	c98080e7          	jalr	-872(ra) # 8000053c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800058ac:	24c1                	addiw	s1,s1,16
    800058ae:	04c92783          	lw	a5,76(s2)
    800058b2:	04f4f763          	bgeu	s1,a5,80005900 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058b6:	4741                	li	a4,16
    800058b8:	86a6                	mv	a3,s1
    800058ba:	fc040613          	addi	a2,s0,-64
    800058be:	4581                	li	a1,0
    800058c0:	854a                	mv	a0,s2
    800058c2:	00000097          	auipc	ra,0x0
    800058c6:	d70080e7          	jalr	-656(ra) # 80005632 <readi>
    800058ca:	47c1                	li	a5,16
    800058cc:	fcf518e3          	bne	a0,a5,8000589c <dirlookup+0x3a>
    if(de.inum == 0)
    800058d0:	fc045783          	lhu	a5,-64(s0)
    800058d4:	dfe1                	beqz	a5,800058ac <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800058d6:	fc240593          	addi	a1,s0,-62
    800058da:	854e                	mv	a0,s3
    800058dc:	00000097          	auipc	ra,0x0
    800058e0:	f6c080e7          	jalr	-148(ra) # 80005848 <namecmp>
    800058e4:	f561                	bnez	a0,800058ac <dirlookup+0x4a>
      if(poff)
    800058e6:	000a0463          	beqz	s4,800058ee <dirlookup+0x8c>
        *poff = off;
    800058ea:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800058ee:	fc045583          	lhu	a1,-64(s0)
    800058f2:	00092503          	lw	a0,0(s2)
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	754080e7          	jalr	1876(ra) # 8000504a <iget>
    800058fe:	a011                	j	80005902 <dirlookup+0xa0>
  return 0;
    80005900:	4501                	li	a0,0
}
    80005902:	70e2                	ld	ra,56(sp)
    80005904:	7442                	ld	s0,48(sp)
    80005906:	74a2                	ld	s1,40(sp)
    80005908:	7902                	ld	s2,32(sp)
    8000590a:	69e2                	ld	s3,24(sp)
    8000590c:	6a42                	ld	s4,16(sp)
    8000590e:	6121                	addi	sp,sp,64
    80005910:	8082                	ret

0000000080005912 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005912:	711d                	addi	sp,sp,-96
    80005914:	ec86                	sd	ra,88(sp)
    80005916:	e8a2                	sd	s0,80(sp)
    80005918:	e4a6                	sd	s1,72(sp)
    8000591a:	e0ca                	sd	s2,64(sp)
    8000591c:	fc4e                	sd	s3,56(sp)
    8000591e:	f852                	sd	s4,48(sp)
    80005920:	f456                	sd	s5,40(sp)
    80005922:	f05a                	sd	s6,32(sp)
    80005924:	ec5e                	sd	s7,24(sp)
    80005926:	e862                	sd	s8,16(sp)
    80005928:	e466                	sd	s9,8(sp)
    8000592a:	1080                	addi	s0,sp,96
    8000592c:	84aa                	mv	s1,a0
    8000592e:	8b2e                	mv	s6,a1
    80005930:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80005932:	00054703          	lbu	a4,0(a0)
    80005936:	02f00793          	li	a5,47
    8000593a:	02f70363          	beq	a4,a5,80005960 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000593e:	ffffc097          	auipc	ra,0xffffc
    80005942:	07a080e7          	jalr	122(ra) # 800019b8 <myproc>
    80005946:	15853503          	ld	a0,344(a0)
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	9f6080e7          	jalr	-1546(ra) # 80005340 <idup>
    80005952:	89aa                	mv	s3,a0
  while(*path == '/')
    80005954:	02f00913          	li	s2,47
  len = path - s;
    80005958:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000595a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000595c:	4c05                	li	s8,1
    8000595e:	a865                	j	80005a16 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80005960:	4585                	li	a1,1
    80005962:	4505                	li	a0,1
    80005964:	fffff097          	auipc	ra,0xfffff
    80005968:	6e6080e7          	jalr	1766(ra) # 8000504a <iget>
    8000596c:	89aa                	mv	s3,a0
    8000596e:	b7dd                	j	80005954 <namex+0x42>
      iunlockput(ip);
    80005970:	854e                	mv	a0,s3
    80005972:	00000097          	auipc	ra,0x0
    80005976:	c6e080e7          	jalr	-914(ra) # 800055e0 <iunlockput>
      return 0;
    8000597a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000597c:	854e                	mv	a0,s3
    8000597e:	60e6                	ld	ra,88(sp)
    80005980:	6446                	ld	s0,80(sp)
    80005982:	64a6                	ld	s1,72(sp)
    80005984:	6906                	ld	s2,64(sp)
    80005986:	79e2                	ld	s3,56(sp)
    80005988:	7a42                	ld	s4,48(sp)
    8000598a:	7aa2                	ld	s5,40(sp)
    8000598c:	7b02                	ld	s6,32(sp)
    8000598e:	6be2                	ld	s7,24(sp)
    80005990:	6c42                	ld	s8,16(sp)
    80005992:	6ca2                	ld	s9,8(sp)
    80005994:	6125                	addi	sp,sp,96
    80005996:	8082                	ret
      iunlock(ip);
    80005998:	854e                	mv	a0,s3
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	aa6080e7          	jalr	-1370(ra) # 80005440 <iunlock>
      return ip;
    800059a2:	bfe9                	j	8000597c <namex+0x6a>
      iunlockput(ip);
    800059a4:	854e                	mv	a0,s3
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	c3a080e7          	jalr	-966(ra) # 800055e0 <iunlockput>
      return 0;
    800059ae:	89d2                	mv	s3,s4
    800059b0:	b7f1                	j	8000597c <namex+0x6a>
  len = path - s;
    800059b2:	40b48633          	sub	a2,s1,a1
    800059b6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800059ba:	094cd463          	bge	s9,s4,80005a42 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800059be:	4639                	li	a2,14
    800059c0:	8556                	mv	a0,s5
    800059c2:	ffffb097          	auipc	ra,0xffffb
    800059c6:	37c080e7          	jalr	892(ra) # 80000d3e <memmove>
  while(*path == '/')
    800059ca:	0004c783          	lbu	a5,0(s1)
    800059ce:	01279763          	bne	a5,s2,800059dc <namex+0xca>
    path++;
    800059d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800059d4:	0004c783          	lbu	a5,0(s1)
    800059d8:	ff278de3          	beq	a5,s2,800059d2 <namex+0xc0>
    ilock(ip);
    800059dc:	854e                	mv	a0,s3
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	9a0080e7          	jalr	-1632(ra) # 8000537e <ilock>
    if(ip->type != T_DIR){
    800059e6:	04499783          	lh	a5,68(s3)
    800059ea:	f98793e3          	bne	a5,s8,80005970 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800059ee:	000b0563          	beqz	s6,800059f8 <namex+0xe6>
    800059f2:	0004c783          	lbu	a5,0(s1)
    800059f6:	d3cd                	beqz	a5,80005998 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800059f8:	865e                	mv	a2,s7
    800059fa:	85d6                	mv	a1,s5
    800059fc:	854e                	mv	a0,s3
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	e64080e7          	jalr	-412(ra) # 80005862 <dirlookup>
    80005a06:	8a2a                	mv	s4,a0
    80005a08:	dd51                	beqz	a0,800059a4 <namex+0x92>
    iunlockput(ip);
    80005a0a:	854e                	mv	a0,s3
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	bd4080e7          	jalr	-1068(ra) # 800055e0 <iunlockput>
    ip = next;
    80005a14:	89d2                	mv	s3,s4
  while(*path == '/')
    80005a16:	0004c783          	lbu	a5,0(s1)
    80005a1a:	05279763          	bne	a5,s2,80005a68 <namex+0x156>
    path++;
    80005a1e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80005a20:	0004c783          	lbu	a5,0(s1)
    80005a24:	ff278de3          	beq	a5,s2,80005a1e <namex+0x10c>
  if(*path == 0)
    80005a28:	c79d                	beqz	a5,80005a56 <namex+0x144>
    path++;
    80005a2a:	85a6                	mv	a1,s1
  len = path - s;
    80005a2c:	8a5e                	mv	s4,s7
    80005a2e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80005a30:	01278963          	beq	a5,s2,80005a42 <namex+0x130>
    80005a34:	dfbd                	beqz	a5,800059b2 <namex+0xa0>
    path++;
    80005a36:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80005a38:	0004c783          	lbu	a5,0(s1)
    80005a3c:	ff279ce3          	bne	a5,s2,80005a34 <namex+0x122>
    80005a40:	bf8d                	j	800059b2 <namex+0xa0>
    memmove(name, s, len);
    80005a42:	2601                	sext.w	a2,a2
    80005a44:	8556                	mv	a0,s5
    80005a46:	ffffb097          	auipc	ra,0xffffb
    80005a4a:	2f8080e7          	jalr	760(ra) # 80000d3e <memmove>
    name[len] = 0;
    80005a4e:	9a56                	add	s4,s4,s5
    80005a50:	000a0023          	sb	zero,0(s4)
    80005a54:	bf9d                	j	800059ca <namex+0xb8>
  if(nameiparent){
    80005a56:	f20b03e3          	beqz	s6,8000597c <namex+0x6a>
    iput(ip);
    80005a5a:	854e                	mv	a0,s3
    80005a5c:	00000097          	auipc	ra,0x0
    80005a60:	adc080e7          	jalr	-1316(ra) # 80005538 <iput>
    return 0;
    80005a64:	4981                	li	s3,0
    80005a66:	bf19                	j	8000597c <namex+0x6a>
  if(*path == 0)
    80005a68:	d7fd                	beqz	a5,80005a56 <namex+0x144>
  while(*path != '/' && *path != 0)
    80005a6a:	0004c783          	lbu	a5,0(s1)
    80005a6e:	85a6                	mv	a1,s1
    80005a70:	b7d1                	j	80005a34 <namex+0x122>

0000000080005a72 <dirlink>:
{
    80005a72:	7139                	addi	sp,sp,-64
    80005a74:	fc06                	sd	ra,56(sp)
    80005a76:	f822                	sd	s0,48(sp)
    80005a78:	f426                	sd	s1,40(sp)
    80005a7a:	f04a                	sd	s2,32(sp)
    80005a7c:	ec4e                	sd	s3,24(sp)
    80005a7e:	e852                	sd	s4,16(sp)
    80005a80:	0080                	addi	s0,sp,64
    80005a82:	892a                	mv	s2,a0
    80005a84:	8a2e                	mv	s4,a1
    80005a86:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005a88:	4601                	li	a2,0
    80005a8a:	00000097          	auipc	ra,0x0
    80005a8e:	dd8080e7          	jalr	-552(ra) # 80005862 <dirlookup>
    80005a92:	e93d                	bnez	a0,80005b08 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a94:	04c92483          	lw	s1,76(s2)
    80005a98:	c49d                	beqz	s1,80005ac6 <dirlink+0x54>
    80005a9a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a9c:	4741                	li	a4,16
    80005a9e:	86a6                	mv	a3,s1
    80005aa0:	fc040613          	addi	a2,s0,-64
    80005aa4:	4581                	li	a1,0
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	b8a080e7          	jalr	-1142(ra) # 80005632 <readi>
    80005ab0:	47c1                	li	a5,16
    80005ab2:	06f51163          	bne	a0,a5,80005b14 <dirlink+0xa2>
    if(de.inum == 0)
    80005ab6:	fc045783          	lhu	a5,-64(s0)
    80005aba:	c791                	beqz	a5,80005ac6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005abc:	24c1                	addiw	s1,s1,16
    80005abe:	04c92783          	lw	a5,76(s2)
    80005ac2:	fcf4ede3          	bltu	s1,a5,80005a9c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80005ac6:	4639                	li	a2,14
    80005ac8:	85d2                	mv	a1,s4
    80005aca:	fc240513          	addi	a0,s0,-62
    80005ace:	ffffb097          	auipc	ra,0xffffb
    80005ad2:	324080e7          	jalr	804(ra) # 80000df2 <strncpy>
  de.inum = inum;
    80005ad6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ada:	4741                	li	a4,16
    80005adc:	86a6                	mv	a3,s1
    80005ade:	fc040613          	addi	a2,s0,-64
    80005ae2:	4581                	li	a1,0
    80005ae4:	854a                	mv	a0,s2
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	c44080e7          	jalr	-956(ra) # 8000572a <writei>
    80005aee:	872a                	mv	a4,a0
    80005af0:	47c1                	li	a5,16
  return 0;
    80005af2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005af4:	02f71863          	bne	a4,a5,80005b24 <dirlink+0xb2>
}
    80005af8:	70e2                	ld	ra,56(sp)
    80005afa:	7442                	ld	s0,48(sp)
    80005afc:	74a2                	ld	s1,40(sp)
    80005afe:	7902                	ld	s2,32(sp)
    80005b00:	69e2                	ld	s3,24(sp)
    80005b02:	6a42                	ld	s4,16(sp)
    80005b04:	6121                	addi	sp,sp,64
    80005b06:	8082                	ret
    iput(ip);
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	a30080e7          	jalr	-1488(ra) # 80005538 <iput>
    return -1;
    80005b10:	557d                	li	a0,-1
    80005b12:	b7dd                	j	80005af8 <dirlink+0x86>
      panic("dirlink read");
    80005b14:	00004517          	auipc	a0,0x4
    80005b18:	ec450513          	addi	a0,a0,-316 # 800099d8 <syscalls+0x278>
    80005b1c:	ffffb097          	auipc	ra,0xffffb
    80005b20:	a20080e7          	jalr	-1504(ra) # 8000053c <panic>
    panic("dirlink");
    80005b24:	00004517          	auipc	a0,0x4
    80005b28:	fc450513          	addi	a0,a0,-60 # 80009ae8 <syscalls+0x388>
    80005b2c:	ffffb097          	auipc	ra,0xffffb
    80005b30:	a10080e7          	jalr	-1520(ra) # 8000053c <panic>

0000000080005b34 <namei>:

struct inode*
namei(char *path)
{
    80005b34:	1101                	addi	sp,sp,-32
    80005b36:	ec06                	sd	ra,24(sp)
    80005b38:	e822                	sd	s0,16(sp)
    80005b3a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005b3c:	fe040613          	addi	a2,s0,-32
    80005b40:	4581                	li	a1,0
    80005b42:	00000097          	auipc	ra,0x0
    80005b46:	dd0080e7          	jalr	-560(ra) # 80005912 <namex>
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	6105                	addi	sp,sp,32
    80005b50:	8082                	ret

0000000080005b52 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005b52:	1141                	addi	sp,sp,-16
    80005b54:	e406                	sd	ra,8(sp)
    80005b56:	e022                	sd	s0,0(sp)
    80005b58:	0800                	addi	s0,sp,16
    80005b5a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80005b5c:	4585                	li	a1,1
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	db4080e7          	jalr	-588(ra) # 80005912 <namex>
}
    80005b66:	60a2                	ld	ra,8(sp)
    80005b68:	6402                	ld	s0,0(sp)
    80005b6a:	0141                	addi	sp,sp,16
    80005b6c:	8082                	ret

0000000080005b6e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005b6e:	1101                	addi	sp,sp,-32
    80005b70:	ec06                	sd	ra,24(sp)
    80005b72:	e822                	sd	s0,16(sp)
    80005b74:	e426                	sd	s1,8(sp)
    80005b76:	e04a                	sd	s2,0(sp)
    80005b78:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80005b7a:	0001f917          	auipc	s2,0x1f
    80005b7e:	9d690913          	addi	s2,s2,-1578 # 80024550 <log>
    80005b82:	01892583          	lw	a1,24(s2)
    80005b86:	02892503          	lw	a0,40(s2)
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	ff2080e7          	jalr	-14(ra) # 80004b7c <bread>
    80005b92:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80005b94:	02c92683          	lw	a3,44(s2)
    80005b98:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80005b9a:	02d05763          	blez	a3,80005bc8 <write_head+0x5a>
    80005b9e:	0001f797          	auipc	a5,0x1f
    80005ba2:	9e278793          	addi	a5,a5,-1566 # 80024580 <log+0x30>
    80005ba6:	05c50713          	addi	a4,a0,92
    80005baa:	36fd                	addiw	a3,a3,-1
    80005bac:	1682                	slli	a3,a3,0x20
    80005bae:	9281                	srli	a3,a3,0x20
    80005bb0:	068a                	slli	a3,a3,0x2
    80005bb2:	0001f617          	auipc	a2,0x1f
    80005bb6:	9d260613          	addi	a2,a2,-1582 # 80024584 <log+0x34>
    80005bba:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80005bbc:	4390                	lw	a2,0(a5)
    80005bbe:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005bc0:	0791                	addi	a5,a5,4
    80005bc2:	0711                	addi	a4,a4,4
    80005bc4:	fed79ce3          	bne	a5,a3,80005bbc <write_head+0x4e>
  }
  bwrite(buf);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	fffff097          	auipc	ra,0xfffff
    80005bce:	0a4080e7          	jalr	164(ra) # 80004c6e <bwrite>
  brelse(buf);
    80005bd2:	8526                	mv	a0,s1
    80005bd4:	fffff097          	auipc	ra,0xfffff
    80005bd8:	0d8080e7          	jalr	216(ra) # 80004cac <brelse>
}
    80005bdc:	60e2                	ld	ra,24(sp)
    80005bde:	6442                	ld	s0,16(sp)
    80005be0:	64a2                	ld	s1,8(sp)
    80005be2:	6902                	ld	s2,0(sp)
    80005be4:	6105                	addi	sp,sp,32
    80005be6:	8082                	ret

0000000080005be8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80005be8:	0001f797          	auipc	a5,0x1f
    80005bec:	9947a783          	lw	a5,-1644(a5) # 8002457c <log+0x2c>
    80005bf0:	0af05d63          	blez	a5,80005caa <install_trans+0xc2>
{
    80005bf4:	7139                	addi	sp,sp,-64
    80005bf6:	fc06                	sd	ra,56(sp)
    80005bf8:	f822                	sd	s0,48(sp)
    80005bfa:	f426                	sd	s1,40(sp)
    80005bfc:	f04a                	sd	s2,32(sp)
    80005bfe:	ec4e                	sd	s3,24(sp)
    80005c00:	e852                	sd	s4,16(sp)
    80005c02:	e456                	sd	s5,8(sp)
    80005c04:	e05a                	sd	s6,0(sp)
    80005c06:	0080                	addi	s0,sp,64
    80005c08:	8b2a                	mv	s6,a0
    80005c0a:	0001fa97          	auipc	s5,0x1f
    80005c0e:	976a8a93          	addi	s5,s5,-1674 # 80024580 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005c12:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005c14:	0001f997          	auipc	s3,0x1f
    80005c18:	93c98993          	addi	s3,s3,-1732 # 80024550 <log>
    80005c1c:	a035                	j	80005c48 <install_trans+0x60>
      bunpin(dbuf);
    80005c1e:	8526                	mv	a0,s1
    80005c20:	fffff097          	auipc	ra,0xfffff
    80005c24:	166080e7          	jalr	358(ra) # 80004d86 <bunpin>
    brelse(lbuf);
    80005c28:	854a                	mv	a0,s2
    80005c2a:	fffff097          	auipc	ra,0xfffff
    80005c2e:	082080e7          	jalr	130(ra) # 80004cac <brelse>
    brelse(dbuf);
    80005c32:	8526                	mv	a0,s1
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	078080e7          	jalr	120(ra) # 80004cac <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005c3c:	2a05                	addiw	s4,s4,1
    80005c3e:	0a91                	addi	s5,s5,4
    80005c40:	02c9a783          	lw	a5,44(s3)
    80005c44:	04fa5963          	bge	s4,a5,80005c96 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005c48:	0189a583          	lw	a1,24(s3)
    80005c4c:	014585bb          	addw	a1,a1,s4
    80005c50:	2585                	addiw	a1,a1,1
    80005c52:	0289a503          	lw	a0,40(s3)
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	f26080e7          	jalr	-218(ra) # 80004b7c <bread>
    80005c5e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005c60:	000aa583          	lw	a1,0(s5)
    80005c64:	0289a503          	lw	a0,40(s3)
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	f14080e7          	jalr	-236(ra) # 80004b7c <bread>
    80005c70:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005c72:	40000613          	li	a2,1024
    80005c76:	05890593          	addi	a1,s2,88
    80005c7a:	05850513          	addi	a0,a0,88
    80005c7e:	ffffb097          	auipc	ra,0xffffb
    80005c82:	0c0080e7          	jalr	192(ra) # 80000d3e <memmove>
    bwrite(dbuf);  // write dst to disk
    80005c86:	8526                	mv	a0,s1
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	fe6080e7          	jalr	-26(ra) # 80004c6e <bwrite>
    if(recovering == 0)
    80005c90:	f80b1ce3          	bnez	s6,80005c28 <install_trans+0x40>
    80005c94:	b769                	j	80005c1e <install_trans+0x36>
}
    80005c96:	70e2                	ld	ra,56(sp)
    80005c98:	7442                	ld	s0,48(sp)
    80005c9a:	74a2                	ld	s1,40(sp)
    80005c9c:	7902                	ld	s2,32(sp)
    80005c9e:	69e2                	ld	s3,24(sp)
    80005ca0:	6a42                	ld	s4,16(sp)
    80005ca2:	6aa2                	ld	s5,8(sp)
    80005ca4:	6b02                	ld	s6,0(sp)
    80005ca6:	6121                	addi	sp,sp,64
    80005ca8:	8082                	ret
    80005caa:	8082                	ret

0000000080005cac <initlog>:
{
    80005cac:	7179                	addi	sp,sp,-48
    80005cae:	f406                	sd	ra,40(sp)
    80005cb0:	f022                	sd	s0,32(sp)
    80005cb2:	ec26                	sd	s1,24(sp)
    80005cb4:	e84a                	sd	s2,16(sp)
    80005cb6:	e44e                	sd	s3,8(sp)
    80005cb8:	1800                	addi	s0,sp,48
    80005cba:	892a                	mv	s2,a0
    80005cbc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80005cbe:	0001f497          	auipc	s1,0x1f
    80005cc2:	89248493          	addi	s1,s1,-1902 # 80024550 <log>
    80005cc6:	00004597          	auipc	a1,0x4
    80005cca:	d2258593          	addi	a1,a1,-734 # 800099e8 <syscalls+0x288>
    80005cce:	8526                	mv	a0,s1
    80005cd0:	ffffb097          	auipc	ra,0xffffb
    80005cd4:	e82080e7          	jalr	-382(ra) # 80000b52 <initlock>
  log.start = sb->logstart;
    80005cd8:	0149a583          	lw	a1,20(s3)
    80005cdc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80005cde:	0109a783          	lw	a5,16(s3)
    80005ce2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80005ce4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80005ce8:	854a                	mv	a0,s2
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	e92080e7          	jalr	-366(ra) # 80004b7c <bread>
  log.lh.n = lh->n;
    80005cf2:	4d3c                	lw	a5,88(a0)
    80005cf4:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005cf6:	02f05563          	blez	a5,80005d20 <initlog+0x74>
    80005cfa:	05c50713          	addi	a4,a0,92
    80005cfe:	0001f697          	auipc	a3,0x1f
    80005d02:	88268693          	addi	a3,a3,-1918 # 80024580 <log+0x30>
    80005d06:	37fd                	addiw	a5,a5,-1
    80005d08:	1782                	slli	a5,a5,0x20
    80005d0a:	9381                	srli	a5,a5,0x20
    80005d0c:	078a                	slli	a5,a5,0x2
    80005d0e:	06050613          	addi	a2,a0,96
    80005d12:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80005d14:	4310                	lw	a2,0(a4)
    80005d16:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80005d18:	0711                	addi	a4,a4,4
    80005d1a:	0691                	addi	a3,a3,4
    80005d1c:	fef71ce3          	bne	a4,a5,80005d14 <initlog+0x68>
  brelse(buf);
    80005d20:	fffff097          	auipc	ra,0xfffff
    80005d24:	f8c080e7          	jalr	-116(ra) # 80004cac <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80005d28:	4505                	li	a0,1
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	ebe080e7          	jalr	-322(ra) # 80005be8 <install_trans>
  log.lh.n = 0;
    80005d32:	0001f797          	auipc	a5,0x1f
    80005d36:	8407a523          	sw	zero,-1974(a5) # 8002457c <log+0x2c>
  write_head(); // clear the log
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	e34080e7          	jalr	-460(ra) # 80005b6e <write_head>
}
    80005d42:	70a2                	ld	ra,40(sp)
    80005d44:	7402                	ld	s0,32(sp)
    80005d46:	64e2                	ld	s1,24(sp)
    80005d48:	6942                	ld	s2,16(sp)
    80005d4a:	69a2                	ld	s3,8(sp)
    80005d4c:	6145                	addi	sp,sp,48
    80005d4e:	8082                	ret

0000000080005d50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80005d50:	1101                	addi	sp,sp,-32
    80005d52:	ec06                	sd	ra,24(sp)
    80005d54:	e822                	sd	s0,16(sp)
    80005d56:	e426                	sd	s1,8(sp)
    80005d58:	e04a                	sd	s2,0(sp)
    80005d5a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80005d5c:	0001e517          	auipc	a0,0x1e
    80005d60:	7f450513          	addi	a0,a0,2036 # 80024550 <log>
    80005d64:	ffffb097          	auipc	ra,0xffffb
    80005d68:	e7e080e7          	jalr	-386(ra) # 80000be2 <acquire>
  while(1){
    if(log.committing){
    80005d6c:	0001e497          	auipc	s1,0x1e
    80005d70:	7e448493          	addi	s1,s1,2020 # 80024550 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005d74:	4979                	li	s2,30
    80005d76:	a039                	j	80005d84 <begin_op+0x34>
      sleep(&log, &log.lock);
    80005d78:	85a6                	mv	a1,s1
    80005d7a:	8526                	mv	a0,s1
    80005d7c:	ffffd097          	auipc	ra,0xffffd
    80005d80:	9de080e7          	jalr	-1570(ra) # 8000275a <sleep>
    if(log.committing){
    80005d84:	50dc                	lw	a5,36(s1)
    80005d86:	fbed                	bnez	a5,80005d78 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005d88:	509c                	lw	a5,32(s1)
    80005d8a:	0017871b          	addiw	a4,a5,1
    80005d8e:	0007069b          	sext.w	a3,a4
    80005d92:	0027179b          	slliw	a5,a4,0x2
    80005d96:	9fb9                	addw	a5,a5,a4
    80005d98:	0017979b          	slliw	a5,a5,0x1
    80005d9c:	54d8                	lw	a4,44(s1)
    80005d9e:	9fb9                	addw	a5,a5,a4
    80005da0:	00f95963          	bge	s2,a5,80005db2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80005da4:	85a6                	mv	a1,s1
    80005da6:	8526                	mv	a0,s1
    80005da8:	ffffd097          	auipc	ra,0xffffd
    80005dac:	9b2080e7          	jalr	-1614(ra) # 8000275a <sleep>
    80005db0:	bfd1                	j	80005d84 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80005db2:	0001e517          	auipc	a0,0x1e
    80005db6:	79e50513          	addi	a0,a0,1950 # 80024550 <log>
    80005dba:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80005dbc:	ffffb097          	auipc	ra,0xffffb
    80005dc0:	eda080e7          	jalr	-294(ra) # 80000c96 <release>
      break;
    }
  }
}
    80005dc4:	60e2                	ld	ra,24(sp)
    80005dc6:	6442                	ld	s0,16(sp)
    80005dc8:	64a2                	ld	s1,8(sp)
    80005dca:	6902                	ld	s2,0(sp)
    80005dcc:	6105                	addi	sp,sp,32
    80005dce:	8082                	ret

0000000080005dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005dd0:	7139                	addi	sp,sp,-64
    80005dd2:	fc06                	sd	ra,56(sp)
    80005dd4:	f822                	sd	s0,48(sp)
    80005dd6:	f426                	sd	s1,40(sp)
    80005dd8:	f04a                	sd	s2,32(sp)
    80005dda:	ec4e                	sd	s3,24(sp)
    80005ddc:	e852                	sd	s4,16(sp)
    80005dde:	e456                	sd	s5,8(sp)
    80005de0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005de2:	0001e497          	auipc	s1,0x1e
    80005de6:	76e48493          	addi	s1,s1,1902 # 80024550 <log>
    80005dea:	8526                	mv	a0,s1
    80005dec:	ffffb097          	auipc	ra,0xffffb
    80005df0:	df6080e7          	jalr	-522(ra) # 80000be2 <acquire>
  log.outstanding -= 1;
    80005df4:	509c                	lw	a5,32(s1)
    80005df6:	37fd                	addiw	a5,a5,-1
    80005df8:	0007891b          	sext.w	s2,a5
    80005dfc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80005dfe:	50dc                	lw	a5,36(s1)
    80005e00:	efb9                	bnez	a5,80005e5e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80005e02:	06091663          	bnez	s2,80005e6e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80005e06:	0001e497          	auipc	s1,0x1e
    80005e0a:	74a48493          	addi	s1,s1,1866 # 80024550 <log>
    80005e0e:	4785                	li	a5,1
    80005e10:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005e12:	8526                	mv	a0,s1
    80005e14:	ffffb097          	auipc	ra,0xffffb
    80005e18:	e82080e7          	jalr	-382(ra) # 80000c96 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005e1c:	54dc                	lw	a5,44(s1)
    80005e1e:	06f04763          	bgtz	a5,80005e8c <end_op+0xbc>
    acquire(&log.lock);
    80005e22:	0001e497          	auipc	s1,0x1e
    80005e26:	72e48493          	addi	s1,s1,1838 # 80024550 <log>
    80005e2a:	8526                	mv	a0,s1
    80005e2c:	ffffb097          	auipc	ra,0xffffb
    80005e30:	db6080e7          	jalr	-586(ra) # 80000be2 <acquire>
    log.committing = 0;
    80005e34:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005e38:	8526                	mv	a0,s1
    80005e3a:	ffffd097          	auipc	ra,0xffffd
    80005e3e:	d26080e7          	jalr	-730(ra) # 80002b60 <wakeup>
    release(&log.lock);
    80005e42:	8526                	mv	a0,s1
    80005e44:	ffffb097          	auipc	ra,0xffffb
    80005e48:	e52080e7          	jalr	-430(ra) # 80000c96 <release>
}
    80005e4c:	70e2                	ld	ra,56(sp)
    80005e4e:	7442                	ld	s0,48(sp)
    80005e50:	74a2                	ld	s1,40(sp)
    80005e52:	7902                	ld	s2,32(sp)
    80005e54:	69e2                	ld	s3,24(sp)
    80005e56:	6a42                	ld	s4,16(sp)
    80005e58:	6aa2                	ld	s5,8(sp)
    80005e5a:	6121                	addi	sp,sp,64
    80005e5c:	8082                	ret
    panic("log.committing");
    80005e5e:	00004517          	auipc	a0,0x4
    80005e62:	b9250513          	addi	a0,a0,-1134 # 800099f0 <syscalls+0x290>
    80005e66:	ffffa097          	auipc	ra,0xffffa
    80005e6a:	6d6080e7          	jalr	1750(ra) # 8000053c <panic>
    wakeup(&log);
    80005e6e:	0001e497          	auipc	s1,0x1e
    80005e72:	6e248493          	addi	s1,s1,1762 # 80024550 <log>
    80005e76:	8526                	mv	a0,s1
    80005e78:	ffffd097          	auipc	ra,0xffffd
    80005e7c:	ce8080e7          	jalr	-792(ra) # 80002b60 <wakeup>
  release(&log.lock);
    80005e80:	8526                	mv	a0,s1
    80005e82:	ffffb097          	auipc	ra,0xffffb
    80005e86:	e14080e7          	jalr	-492(ra) # 80000c96 <release>
  if(do_commit){
    80005e8a:	b7c9                	j	80005e4c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005e8c:	0001ea97          	auipc	s5,0x1e
    80005e90:	6f4a8a93          	addi	s5,s5,1780 # 80024580 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005e94:	0001ea17          	auipc	s4,0x1e
    80005e98:	6bca0a13          	addi	s4,s4,1724 # 80024550 <log>
    80005e9c:	018a2583          	lw	a1,24(s4)
    80005ea0:	012585bb          	addw	a1,a1,s2
    80005ea4:	2585                	addiw	a1,a1,1
    80005ea6:	028a2503          	lw	a0,40(s4)
    80005eaa:	fffff097          	auipc	ra,0xfffff
    80005eae:	cd2080e7          	jalr	-814(ra) # 80004b7c <bread>
    80005eb2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005eb4:	000aa583          	lw	a1,0(s5)
    80005eb8:	028a2503          	lw	a0,40(s4)
    80005ebc:	fffff097          	auipc	ra,0xfffff
    80005ec0:	cc0080e7          	jalr	-832(ra) # 80004b7c <bread>
    80005ec4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80005ec6:	40000613          	li	a2,1024
    80005eca:	05850593          	addi	a1,a0,88
    80005ece:	05848513          	addi	a0,s1,88
    80005ed2:	ffffb097          	auipc	ra,0xffffb
    80005ed6:	e6c080e7          	jalr	-404(ra) # 80000d3e <memmove>
    bwrite(to);  // write the log
    80005eda:	8526                	mv	a0,s1
    80005edc:	fffff097          	auipc	ra,0xfffff
    80005ee0:	d92080e7          	jalr	-622(ra) # 80004c6e <bwrite>
    brelse(from);
    80005ee4:	854e                	mv	a0,s3
    80005ee6:	fffff097          	auipc	ra,0xfffff
    80005eea:	dc6080e7          	jalr	-570(ra) # 80004cac <brelse>
    brelse(to);
    80005eee:	8526                	mv	a0,s1
    80005ef0:	fffff097          	auipc	ra,0xfffff
    80005ef4:	dbc080e7          	jalr	-580(ra) # 80004cac <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005ef8:	2905                	addiw	s2,s2,1
    80005efa:	0a91                	addi	s5,s5,4
    80005efc:	02ca2783          	lw	a5,44(s4)
    80005f00:	f8f94ee3          	blt	s2,a5,80005e9c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	c6a080e7          	jalr	-918(ra) # 80005b6e <write_head>
    install_trans(0); // Now install writes to home locations
    80005f0c:	4501                	li	a0,0
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	cda080e7          	jalr	-806(ra) # 80005be8 <install_trans>
    log.lh.n = 0;
    80005f16:	0001e797          	auipc	a5,0x1e
    80005f1a:	6607a323          	sw	zero,1638(a5) # 8002457c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	c50080e7          	jalr	-944(ra) # 80005b6e <write_head>
    80005f26:	bdf5                	j	80005e22 <end_op+0x52>

0000000080005f28 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005f28:	1101                	addi	sp,sp,-32
    80005f2a:	ec06                	sd	ra,24(sp)
    80005f2c:	e822                	sd	s0,16(sp)
    80005f2e:	e426                	sd	s1,8(sp)
    80005f30:	e04a                	sd	s2,0(sp)
    80005f32:	1000                	addi	s0,sp,32
    80005f34:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005f36:	0001e917          	auipc	s2,0x1e
    80005f3a:	61a90913          	addi	s2,s2,1562 # 80024550 <log>
    80005f3e:	854a                	mv	a0,s2
    80005f40:	ffffb097          	auipc	ra,0xffffb
    80005f44:	ca2080e7          	jalr	-862(ra) # 80000be2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005f48:	02c92603          	lw	a2,44(s2)
    80005f4c:	47f5                	li	a5,29
    80005f4e:	06c7c563          	blt	a5,a2,80005fb8 <log_write+0x90>
    80005f52:	0001e797          	auipc	a5,0x1e
    80005f56:	61a7a783          	lw	a5,1562(a5) # 8002456c <log+0x1c>
    80005f5a:	37fd                	addiw	a5,a5,-1
    80005f5c:	04f65e63          	bge	a2,a5,80005fb8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005f60:	0001e797          	auipc	a5,0x1e
    80005f64:	6107a783          	lw	a5,1552(a5) # 80024570 <log+0x20>
    80005f68:	06f05063          	blez	a5,80005fc8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005f6c:	4781                	li	a5,0
    80005f6e:	06c05563          	blez	a2,80005fd8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005f72:	44cc                	lw	a1,12(s1)
    80005f74:	0001e717          	auipc	a4,0x1e
    80005f78:	60c70713          	addi	a4,a4,1548 # 80024580 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005f7c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005f7e:	4314                	lw	a3,0(a4)
    80005f80:	04b68c63          	beq	a3,a1,80005fd8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80005f84:	2785                	addiw	a5,a5,1
    80005f86:	0711                	addi	a4,a4,4
    80005f88:	fef61be3          	bne	a2,a5,80005f7e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005f8c:	0621                	addi	a2,a2,8
    80005f8e:	060a                	slli	a2,a2,0x2
    80005f90:	0001e797          	auipc	a5,0x1e
    80005f94:	5c078793          	addi	a5,a5,1472 # 80024550 <log>
    80005f98:	963e                	add	a2,a2,a5
    80005f9a:	44dc                	lw	a5,12(s1)
    80005f9c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005f9e:	8526                	mv	a0,s1
    80005fa0:	fffff097          	auipc	ra,0xfffff
    80005fa4:	daa080e7          	jalr	-598(ra) # 80004d4a <bpin>
    log.lh.n++;
    80005fa8:	0001e717          	auipc	a4,0x1e
    80005fac:	5a870713          	addi	a4,a4,1448 # 80024550 <log>
    80005fb0:	575c                	lw	a5,44(a4)
    80005fb2:	2785                	addiw	a5,a5,1
    80005fb4:	d75c                	sw	a5,44(a4)
    80005fb6:	a835                	j	80005ff2 <log_write+0xca>
    panic("too big a transaction");
    80005fb8:	00004517          	auipc	a0,0x4
    80005fbc:	a4850513          	addi	a0,a0,-1464 # 80009a00 <syscalls+0x2a0>
    80005fc0:	ffffa097          	auipc	ra,0xffffa
    80005fc4:	57c080e7          	jalr	1404(ra) # 8000053c <panic>
    panic("log_write outside of trans");
    80005fc8:	00004517          	auipc	a0,0x4
    80005fcc:	a5050513          	addi	a0,a0,-1456 # 80009a18 <syscalls+0x2b8>
    80005fd0:	ffffa097          	auipc	ra,0xffffa
    80005fd4:	56c080e7          	jalr	1388(ra) # 8000053c <panic>
  log.lh.block[i] = b->blockno;
    80005fd8:	00878713          	addi	a4,a5,8
    80005fdc:	00271693          	slli	a3,a4,0x2
    80005fe0:	0001e717          	auipc	a4,0x1e
    80005fe4:	57070713          	addi	a4,a4,1392 # 80024550 <log>
    80005fe8:	9736                	add	a4,a4,a3
    80005fea:	44d4                	lw	a3,12(s1)
    80005fec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005fee:	faf608e3          	beq	a2,a5,80005f9e <log_write+0x76>
  }
  release(&log.lock);
    80005ff2:	0001e517          	auipc	a0,0x1e
    80005ff6:	55e50513          	addi	a0,a0,1374 # 80024550 <log>
    80005ffa:	ffffb097          	auipc	ra,0xffffb
    80005ffe:	c9c080e7          	jalr	-868(ra) # 80000c96 <release>
}
    80006002:	60e2                	ld	ra,24(sp)
    80006004:	6442                	ld	s0,16(sp)
    80006006:	64a2                	ld	s1,8(sp)
    80006008:	6902                	ld	s2,0(sp)
    8000600a:	6105                	addi	sp,sp,32
    8000600c:	8082                	ret

000000008000600e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000600e:	1101                	addi	sp,sp,-32
    80006010:	ec06                	sd	ra,24(sp)
    80006012:	e822                	sd	s0,16(sp)
    80006014:	e426                	sd	s1,8(sp)
    80006016:	e04a                	sd	s2,0(sp)
    80006018:	1000                	addi	s0,sp,32
    8000601a:	84aa                	mv	s1,a0
    8000601c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000601e:	00004597          	auipc	a1,0x4
    80006022:	a1a58593          	addi	a1,a1,-1510 # 80009a38 <syscalls+0x2d8>
    80006026:	0521                	addi	a0,a0,8
    80006028:	ffffb097          	auipc	ra,0xffffb
    8000602c:	b2a080e7          	jalr	-1238(ra) # 80000b52 <initlock>
  lk->name = name;
    80006030:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80006034:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80006038:	0204a423          	sw	zero,40(s1)
}
    8000603c:	60e2                	ld	ra,24(sp)
    8000603e:	6442                	ld	s0,16(sp)
    80006040:	64a2                	ld	s1,8(sp)
    80006042:	6902                	ld	s2,0(sp)
    80006044:	6105                	addi	sp,sp,32
    80006046:	8082                	ret

0000000080006048 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80006048:	1101                	addi	sp,sp,-32
    8000604a:	ec06                	sd	ra,24(sp)
    8000604c:	e822                	sd	s0,16(sp)
    8000604e:	e426                	sd	s1,8(sp)
    80006050:	e04a                	sd	s2,0(sp)
    80006052:	1000                	addi	s0,sp,32
    80006054:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80006056:	00850913          	addi	s2,a0,8
    8000605a:	854a                	mv	a0,s2
    8000605c:	ffffb097          	auipc	ra,0xffffb
    80006060:	b86080e7          	jalr	-1146(ra) # 80000be2 <acquire>
  while (lk->locked) {
    80006064:	409c                	lw	a5,0(s1)
    80006066:	cb89                	beqz	a5,80006078 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80006068:	85ca                	mv	a1,s2
    8000606a:	8526                	mv	a0,s1
    8000606c:	ffffc097          	auipc	ra,0xffffc
    80006070:	6ee080e7          	jalr	1774(ra) # 8000275a <sleep>
  while (lk->locked) {
    80006074:	409c                	lw	a5,0(s1)
    80006076:	fbed                	bnez	a5,80006068 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80006078:	4785                	li	a5,1
    8000607a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000607c:	ffffc097          	auipc	ra,0xffffc
    80006080:	93c080e7          	jalr	-1732(ra) # 800019b8 <myproc>
    80006084:	591c                	lw	a5,48(a0)
    80006086:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80006088:	854a                	mv	a0,s2
    8000608a:	ffffb097          	auipc	ra,0xffffb
    8000608e:	c0c080e7          	jalr	-1012(ra) # 80000c96 <release>
}
    80006092:	60e2                	ld	ra,24(sp)
    80006094:	6442                	ld	s0,16(sp)
    80006096:	64a2                	ld	s1,8(sp)
    80006098:	6902                	ld	s2,0(sp)
    8000609a:	6105                	addi	sp,sp,32
    8000609c:	8082                	ret

000000008000609e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000609e:	1101                	addi	sp,sp,-32
    800060a0:	ec06                	sd	ra,24(sp)
    800060a2:	e822                	sd	s0,16(sp)
    800060a4:	e426                	sd	s1,8(sp)
    800060a6:	e04a                	sd	s2,0(sp)
    800060a8:	1000                	addi	s0,sp,32
    800060aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800060ac:	00850913          	addi	s2,a0,8
    800060b0:	854a                	mv	a0,s2
    800060b2:	ffffb097          	auipc	ra,0xffffb
    800060b6:	b30080e7          	jalr	-1232(ra) # 80000be2 <acquire>
  lk->locked = 0;
    800060ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800060be:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800060c2:	8526                	mv	a0,s1
    800060c4:	ffffd097          	auipc	ra,0xffffd
    800060c8:	a9c080e7          	jalr	-1380(ra) # 80002b60 <wakeup>
  release(&lk->lk);
    800060cc:	854a                	mv	a0,s2
    800060ce:	ffffb097          	auipc	ra,0xffffb
    800060d2:	bc8080e7          	jalr	-1080(ra) # 80000c96 <release>
}
    800060d6:	60e2                	ld	ra,24(sp)
    800060d8:	6442                	ld	s0,16(sp)
    800060da:	64a2                	ld	s1,8(sp)
    800060dc:	6902                	ld	s2,0(sp)
    800060de:	6105                	addi	sp,sp,32
    800060e0:	8082                	ret

00000000800060e2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800060e2:	7179                	addi	sp,sp,-48
    800060e4:	f406                	sd	ra,40(sp)
    800060e6:	f022                	sd	s0,32(sp)
    800060e8:	ec26                	sd	s1,24(sp)
    800060ea:	e84a                	sd	s2,16(sp)
    800060ec:	e44e                	sd	s3,8(sp)
    800060ee:	1800                	addi	s0,sp,48
    800060f0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800060f2:	00850913          	addi	s2,a0,8
    800060f6:	854a                	mv	a0,s2
    800060f8:	ffffb097          	auipc	ra,0xffffb
    800060fc:	aea080e7          	jalr	-1302(ra) # 80000be2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80006100:	409c                	lw	a5,0(s1)
    80006102:	ef99                	bnez	a5,80006120 <holdingsleep+0x3e>
    80006104:	4481                	li	s1,0
  release(&lk->lk);
    80006106:	854a                	mv	a0,s2
    80006108:	ffffb097          	auipc	ra,0xffffb
    8000610c:	b8e080e7          	jalr	-1138(ra) # 80000c96 <release>
  return r;
}
    80006110:	8526                	mv	a0,s1
    80006112:	70a2                	ld	ra,40(sp)
    80006114:	7402                	ld	s0,32(sp)
    80006116:	64e2                	ld	s1,24(sp)
    80006118:	6942                	ld	s2,16(sp)
    8000611a:	69a2                	ld	s3,8(sp)
    8000611c:	6145                	addi	sp,sp,48
    8000611e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80006120:	0284a983          	lw	s3,40(s1)
    80006124:	ffffc097          	auipc	ra,0xffffc
    80006128:	894080e7          	jalr	-1900(ra) # 800019b8 <myproc>
    8000612c:	5904                	lw	s1,48(a0)
    8000612e:	413484b3          	sub	s1,s1,s3
    80006132:	0014b493          	seqz	s1,s1
    80006136:	bfc1                	j	80006106 <holdingsleep+0x24>

0000000080006138 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80006138:	1141                	addi	sp,sp,-16
    8000613a:	e406                	sd	ra,8(sp)
    8000613c:	e022                	sd	s0,0(sp)
    8000613e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80006140:	00004597          	auipc	a1,0x4
    80006144:	90858593          	addi	a1,a1,-1784 # 80009a48 <syscalls+0x2e8>
    80006148:	0001e517          	auipc	a0,0x1e
    8000614c:	55050513          	addi	a0,a0,1360 # 80024698 <ftable>
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	a02080e7          	jalr	-1534(ra) # 80000b52 <initlock>
}
    80006158:	60a2                	ld	ra,8(sp)
    8000615a:	6402                	ld	s0,0(sp)
    8000615c:	0141                	addi	sp,sp,16
    8000615e:	8082                	ret

0000000080006160 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80006160:	1101                	addi	sp,sp,-32
    80006162:	ec06                	sd	ra,24(sp)
    80006164:	e822                	sd	s0,16(sp)
    80006166:	e426                	sd	s1,8(sp)
    80006168:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000616a:	0001e517          	auipc	a0,0x1e
    8000616e:	52e50513          	addi	a0,a0,1326 # 80024698 <ftable>
    80006172:	ffffb097          	auipc	ra,0xffffb
    80006176:	a70080e7          	jalr	-1424(ra) # 80000be2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000617a:	0001e497          	auipc	s1,0x1e
    8000617e:	53648493          	addi	s1,s1,1334 # 800246b0 <ftable+0x18>
    80006182:	0001f717          	auipc	a4,0x1f
    80006186:	4ce70713          	addi	a4,a4,1230 # 80025650 <ftable+0xfb8>
    if(f->ref == 0){
    8000618a:	40dc                	lw	a5,4(s1)
    8000618c:	cf99                	beqz	a5,800061aa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000618e:	02848493          	addi	s1,s1,40
    80006192:	fee49ce3          	bne	s1,a4,8000618a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80006196:	0001e517          	auipc	a0,0x1e
    8000619a:	50250513          	addi	a0,a0,1282 # 80024698 <ftable>
    8000619e:	ffffb097          	auipc	ra,0xffffb
    800061a2:	af8080e7          	jalr	-1288(ra) # 80000c96 <release>
  return 0;
    800061a6:	4481                	li	s1,0
    800061a8:	a819                	j	800061be <filealloc+0x5e>
      f->ref = 1;
    800061aa:	4785                	li	a5,1
    800061ac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800061ae:	0001e517          	auipc	a0,0x1e
    800061b2:	4ea50513          	addi	a0,a0,1258 # 80024698 <ftable>
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	ae0080e7          	jalr	-1312(ra) # 80000c96 <release>
}
    800061be:	8526                	mv	a0,s1
    800061c0:	60e2                	ld	ra,24(sp)
    800061c2:	6442                	ld	s0,16(sp)
    800061c4:	64a2                	ld	s1,8(sp)
    800061c6:	6105                	addi	sp,sp,32
    800061c8:	8082                	ret

00000000800061ca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800061ca:	1101                	addi	sp,sp,-32
    800061cc:	ec06                	sd	ra,24(sp)
    800061ce:	e822                	sd	s0,16(sp)
    800061d0:	e426                	sd	s1,8(sp)
    800061d2:	1000                	addi	s0,sp,32
    800061d4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800061d6:	0001e517          	auipc	a0,0x1e
    800061da:	4c250513          	addi	a0,a0,1218 # 80024698 <ftable>
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	a04080e7          	jalr	-1532(ra) # 80000be2 <acquire>
  if(f->ref < 1)
    800061e6:	40dc                	lw	a5,4(s1)
    800061e8:	02f05263          	blez	a5,8000620c <filedup+0x42>
    panic("filedup");
  f->ref++;
    800061ec:	2785                	addiw	a5,a5,1
    800061ee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800061f0:	0001e517          	auipc	a0,0x1e
    800061f4:	4a850513          	addi	a0,a0,1192 # 80024698 <ftable>
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	a9e080e7          	jalr	-1378(ra) # 80000c96 <release>
  return f;
}
    80006200:	8526                	mv	a0,s1
    80006202:	60e2                	ld	ra,24(sp)
    80006204:	6442                	ld	s0,16(sp)
    80006206:	64a2                	ld	s1,8(sp)
    80006208:	6105                	addi	sp,sp,32
    8000620a:	8082                	ret
    panic("filedup");
    8000620c:	00004517          	auipc	a0,0x4
    80006210:	84450513          	addi	a0,a0,-1980 # 80009a50 <syscalls+0x2f0>
    80006214:	ffffa097          	auipc	ra,0xffffa
    80006218:	328080e7          	jalr	808(ra) # 8000053c <panic>

000000008000621c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000621c:	7139                	addi	sp,sp,-64
    8000621e:	fc06                	sd	ra,56(sp)
    80006220:	f822                	sd	s0,48(sp)
    80006222:	f426                	sd	s1,40(sp)
    80006224:	f04a                	sd	s2,32(sp)
    80006226:	ec4e                	sd	s3,24(sp)
    80006228:	e852                	sd	s4,16(sp)
    8000622a:	e456                	sd	s5,8(sp)
    8000622c:	0080                	addi	s0,sp,64
    8000622e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80006230:	0001e517          	auipc	a0,0x1e
    80006234:	46850513          	addi	a0,a0,1128 # 80024698 <ftable>
    80006238:	ffffb097          	auipc	ra,0xffffb
    8000623c:	9aa080e7          	jalr	-1622(ra) # 80000be2 <acquire>
  if(f->ref < 1)
    80006240:	40dc                	lw	a5,4(s1)
    80006242:	06f05163          	blez	a5,800062a4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80006246:	37fd                	addiw	a5,a5,-1
    80006248:	0007871b          	sext.w	a4,a5
    8000624c:	c0dc                	sw	a5,4(s1)
    8000624e:	06e04363          	bgtz	a4,800062b4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80006252:	0004a903          	lw	s2,0(s1)
    80006256:	0094ca83          	lbu	s5,9(s1)
    8000625a:	0104ba03          	ld	s4,16(s1)
    8000625e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80006262:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80006266:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000626a:	0001e517          	auipc	a0,0x1e
    8000626e:	42e50513          	addi	a0,a0,1070 # 80024698 <ftable>
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	a24080e7          	jalr	-1500(ra) # 80000c96 <release>

  if(ff.type == FD_PIPE){
    8000627a:	4785                	li	a5,1
    8000627c:	04f90d63          	beq	s2,a5,800062d6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80006280:	3979                	addiw	s2,s2,-2
    80006282:	4785                	li	a5,1
    80006284:	0527e063          	bltu	a5,s2,800062c4 <fileclose+0xa8>
    begin_op();
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	ac8080e7          	jalr	-1336(ra) # 80005d50 <begin_op>
    iput(ff.ip);
    80006290:	854e                	mv	a0,s3
    80006292:	fffff097          	auipc	ra,0xfffff
    80006296:	2a6080e7          	jalr	678(ra) # 80005538 <iput>
    end_op();
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	b36080e7          	jalr	-1226(ra) # 80005dd0 <end_op>
    800062a2:	a00d                	j	800062c4 <fileclose+0xa8>
    panic("fileclose");
    800062a4:	00003517          	auipc	a0,0x3
    800062a8:	7b450513          	addi	a0,a0,1972 # 80009a58 <syscalls+0x2f8>
    800062ac:	ffffa097          	auipc	ra,0xffffa
    800062b0:	290080e7          	jalr	656(ra) # 8000053c <panic>
    release(&ftable.lock);
    800062b4:	0001e517          	auipc	a0,0x1e
    800062b8:	3e450513          	addi	a0,a0,996 # 80024698 <ftable>
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	9da080e7          	jalr	-1574(ra) # 80000c96 <release>
  }
}
    800062c4:	70e2                	ld	ra,56(sp)
    800062c6:	7442                	ld	s0,48(sp)
    800062c8:	74a2                	ld	s1,40(sp)
    800062ca:	7902                	ld	s2,32(sp)
    800062cc:	69e2                	ld	s3,24(sp)
    800062ce:	6a42                	ld	s4,16(sp)
    800062d0:	6aa2                	ld	s5,8(sp)
    800062d2:	6121                	addi	sp,sp,64
    800062d4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800062d6:	85d6                	mv	a1,s5
    800062d8:	8552                	mv	a0,s4
    800062da:	00000097          	auipc	ra,0x0
    800062de:	34c080e7          	jalr	844(ra) # 80006626 <pipeclose>
    800062e2:	b7cd                	j	800062c4 <fileclose+0xa8>

00000000800062e4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800062e4:	715d                	addi	sp,sp,-80
    800062e6:	e486                	sd	ra,72(sp)
    800062e8:	e0a2                	sd	s0,64(sp)
    800062ea:	fc26                	sd	s1,56(sp)
    800062ec:	f84a                	sd	s2,48(sp)
    800062ee:	f44e                	sd	s3,40(sp)
    800062f0:	0880                	addi	s0,sp,80
    800062f2:	84aa                	mv	s1,a0
    800062f4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800062f6:	ffffb097          	auipc	ra,0xffffb
    800062fa:	6c2080e7          	jalr	1730(ra) # 800019b8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800062fe:	409c                	lw	a5,0(s1)
    80006300:	37f9                	addiw	a5,a5,-2
    80006302:	4705                	li	a4,1
    80006304:	04f76763          	bltu	a4,a5,80006352 <filestat+0x6e>
    80006308:	892a                	mv	s2,a0
    ilock(f->ip);
    8000630a:	6c88                	ld	a0,24(s1)
    8000630c:	fffff097          	auipc	ra,0xfffff
    80006310:	072080e7          	jalr	114(ra) # 8000537e <ilock>
    stati(f->ip, &st);
    80006314:	fb840593          	addi	a1,s0,-72
    80006318:	6c88                	ld	a0,24(s1)
    8000631a:	fffff097          	auipc	ra,0xfffff
    8000631e:	2ee080e7          	jalr	750(ra) # 80005608 <stati>
    iunlock(f->ip);
    80006322:	6c88                	ld	a0,24(s1)
    80006324:	fffff097          	auipc	ra,0xfffff
    80006328:	11c080e7          	jalr	284(ra) # 80005440 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000632c:	46e1                	li	a3,24
    8000632e:	fb840613          	addi	a2,s0,-72
    80006332:	85ce                	mv	a1,s3
    80006334:	05893503          	ld	a0,88(s2)
    80006338:	ffffb097          	auipc	ra,0xffffb
    8000633c:	342080e7          	jalr	834(ra) # 8000167a <copyout>
    80006340:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80006344:	60a6                	ld	ra,72(sp)
    80006346:	6406                	ld	s0,64(sp)
    80006348:	74e2                	ld	s1,56(sp)
    8000634a:	7942                	ld	s2,48(sp)
    8000634c:	79a2                	ld	s3,40(sp)
    8000634e:	6161                	addi	sp,sp,80
    80006350:	8082                	ret
  return -1;
    80006352:	557d                	li	a0,-1
    80006354:	bfc5                	j	80006344 <filestat+0x60>

0000000080006356 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80006356:	7179                	addi	sp,sp,-48
    80006358:	f406                	sd	ra,40(sp)
    8000635a:	f022                	sd	s0,32(sp)
    8000635c:	ec26                	sd	s1,24(sp)
    8000635e:	e84a                	sd	s2,16(sp)
    80006360:	e44e                	sd	s3,8(sp)
    80006362:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80006364:	00854783          	lbu	a5,8(a0)
    80006368:	c3d5                	beqz	a5,8000640c <fileread+0xb6>
    8000636a:	84aa                	mv	s1,a0
    8000636c:	89ae                	mv	s3,a1
    8000636e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80006370:	411c                	lw	a5,0(a0)
    80006372:	4705                	li	a4,1
    80006374:	04e78963          	beq	a5,a4,800063c6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006378:	470d                	li	a4,3
    8000637a:	04e78d63          	beq	a5,a4,800063d4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000637e:	4709                	li	a4,2
    80006380:	06e79e63          	bne	a5,a4,800063fc <fileread+0xa6>
    ilock(f->ip);
    80006384:	6d08                	ld	a0,24(a0)
    80006386:	fffff097          	auipc	ra,0xfffff
    8000638a:	ff8080e7          	jalr	-8(ra) # 8000537e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000638e:	874a                	mv	a4,s2
    80006390:	5094                	lw	a3,32(s1)
    80006392:	864e                	mv	a2,s3
    80006394:	4585                	li	a1,1
    80006396:	6c88                	ld	a0,24(s1)
    80006398:	fffff097          	auipc	ra,0xfffff
    8000639c:	29a080e7          	jalr	666(ra) # 80005632 <readi>
    800063a0:	892a                	mv	s2,a0
    800063a2:	00a05563          	blez	a0,800063ac <fileread+0x56>
      f->off += r;
    800063a6:	509c                	lw	a5,32(s1)
    800063a8:	9fa9                	addw	a5,a5,a0
    800063aa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800063ac:	6c88                	ld	a0,24(s1)
    800063ae:	fffff097          	auipc	ra,0xfffff
    800063b2:	092080e7          	jalr	146(ra) # 80005440 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800063b6:	854a                	mv	a0,s2
    800063b8:	70a2                	ld	ra,40(sp)
    800063ba:	7402                	ld	s0,32(sp)
    800063bc:	64e2                	ld	s1,24(sp)
    800063be:	6942                	ld	s2,16(sp)
    800063c0:	69a2                	ld	s3,8(sp)
    800063c2:	6145                	addi	sp,sp,48
    800063c4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800063c6:	6908                	ld	a0,16(a0)
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	3c8080e7          	jalr	968(ra) # 80006790 <piperead>
    800063d0:	892a                	mv	s2,a0
    800063d2:	b7d5                	j	800063b6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800063d4:	02451783          	lh	a5,36(a0)
    800063d8:	03079693          	slli	a3,a5,0x30
    800063dc:	92c1                	srli	a3,a3,0x30
    800063de:	4725                	li	a4,9
    800063e0:	02d76863          	bltu	a4,a3,80006410 <fileread+0xba>
    800063e4:	0792                	slli	a5,a5,0x4
    800063e6:	0001e717          	auipc	a4,0x1e
    800063ea:	21270713          	addi	a4,a4,530 # 800245f8 <devsw>
    800063ee:	97ba                	add	a5,a5,a4
    800063f0:	639c                	ld	a5,0(a5)
    800063f2:	c38d                	beqz	a5,80006414 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800063f4:	4505                	li	a0,1
    800063f6:	9782                	jalr	a5
    800063f8:	892a                	mv	s2,a0
    800063fa:	bf75                	j	800063b6 <fileread+0x60>
    panic("fileread");
    800063fc:	00003517          	auipc	a0,0x3
    80006400:	66c50513          	addi	a0,a0,1644 # 80009a68 <syscalls+0x308>
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	138080e7          	jalr	312(ra) # 8000053c <panic>
    return -1;
    8000640c:	597d                	li	s2,-1
    8000640e:	b765                	j	800063b6 <fileread+0x60>
      return -1;
    80006410:	597d                	li	s2,-1
    80006412:	b755                	j	800063b6 <fileread+0x60>
    80006414:	597d                	li	s2,-1
    80006416:	b745                	j	800063b6 <fileread+0x60>

0000000080006418 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006418:	715d                	addi	sp,sp,-80
    8000641a:	e486                	sd	ra,72(sp)
    8000641c:	e0a2                	sd	s0,64(sp)
    8000641e:	fc26                	sd	s1,56(sp)
    80006420:	f84a                	sd	s2,48(sp)
    80006422:	f44e                	sd	s3,40(sp)
    80006424:	f052                	sd	s4,32(sp)
    80006426:	ec56                	sd	s5,24(sp)
    80006428:	e85a                	sd	s6,16(sp)
    8000642a:	e45e                	sd	s7,8(sp)
    8000642c:	e062                	sd	s8,0(sp)
    8000642e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80006430:	00954783          	lbu	a5,9(a0)
    80006434:	10078663          	beqz	a5,80006540 <filewrite+0x128>
    80006438:	892a                	mv	s2,a0
    8000643a:	8aae                	mv	s5,a1
    8000643c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000643e:	411c                	lw	a5,0(a0)
    80006440:	4705                	li	a4,1
    80006442:	02e78263          	beq	a5,a4,80006466 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006446:	470d                	li	a4,3
    80006448:	02e78663          	beq	a5,a4,80006474 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000644c:	4709                	li	a4,2
    8000644e:	0ee79163          	bne	a5,a4,80006530 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80006452:	0ac05d63          	blez	a2,8000650c <filewrite+0xf4>
    int i = 0;
    80006456:	4981                	li	s3,0
    80006458:	6b05                	lui	s6,0x1
    8000645a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000645e:	6b85                	lui	s7,0x1
    80006460:	c00b8b9b          	addiw	s7,s7,-1024
    80006464:	a861                	j	800064fc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80006466:	6908                	ld	a0,16(a0)
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	22e080e7          	jalr	558(ra) # 80006696 <pipewrite>
    80006470:	8a2a                	mv	s4,a0
    80006472:	a045                	j	80006512 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006474:	02451783          	lh	a5,36(a0)
    80006478:	03079693          	slli	a3,a5,0x30
    8000647c:	92c1                	srli	a3,a3,0x30
    8000647e:	4725                	li	a4,9
    80006480:	0cd76263          	bltu	a4,a3,80006544 <filewrite+0x12c>
    80006484:	0792                	slli	a5,a5,0x4
    80006486:	0001e717          	auipc	a4,0x1e
    8000648a:	17270713          	addi	a4,a4,370 # 800245f8 <devsw>
    8000648e:	97ba                	add	a5,a5,a4
    80006490:	679c                	ld	a5,8(a5)
    80006492:	cbdd                	beqz	a5,80006548 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80006494:	4505                	li	a0,1
    80006496:	9782                	jalr	a5
    80006498:	8a2a                	mv	s4,a0
    8000649a:	a8a5                	j	80006512 <filewrite+0xfa>
    8000649c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800064a0:	00000097          	auipc	ra,0x0
    800064a4:	8b0080e7          	jalr	-1872(ra) # 80005d50 <begin_op>
      ilock(f->ip);
    800064a8:	01893503          	ld	a0,24(s2)
    800064ac:	fffff097          	auipc	ra,0xfffff
    800064b0:	ed2080e7          	jalr	-302(ra) # 8000537e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800064b4:	8762                	mv	a4,s8
    800064b6:	02092683          	lw	a3,32(s2)
    800064ba:	01598633          	add	a2,s3,s5
    800064be:	4585                	li	a1,1
    800064c0:	01893503          	ld	a0,24(s2)
    800064c4:	fffff097          	auipc	ra,0xfffff
    800064c8:	266080e7          	jalr	614(ra) # 8000572a <writei>
    800064cc:	84aa                	mv	s1,a0
    800064ce:	00a05763          	blez	a0,800064dc <filewrite+0xc4>
        f->off += r;
    800064d2:	02092783          	lw	a5,32(s2)
    800064d6:	9fa9                	addw	a5,a5,a0
    800064d8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800064dc:	01893503          	ld	a0,24(s2)
    800064e0:	fffff097          	auipc	ra,0xfffff
    800064e4:	f60080e7          	jalr	-160(ra) # 80005440 <iunlock>
      end_op();
    800064e8:	00000097          	auipc	ra,0x0
    800064ec:	8e8080e7          	jalr	-1816(ra) # 80005dd0 <end_op>

      if(r != n1){
    800064f0:	009c1f63          	bne	s8,s1,8000650e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800064f4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800064f8:	0149db63          	bge	s3,s4,8000650e <filewrite+0xf6>
      int n1 = n - i;
    800064fc:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80006500:	84be                	mv	s1,a5
    80006502:	2781                	sext.w	a5,a5
    80006504:	f8fb5ce3          	bge	s6,a5,8000649c <filewrite+0x84>
    80006508:	84de                	mv	s1,s7
    8000650a:	bf49                	j	8000649c <filewrite+0x84>
    int i = 0;
    8000650c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000650e:	013a1f63          	bne	s4,s3,8000652c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80006512:	8552                	mv	a0,s4
    80006514:	60a6                	ld	ra,72(sp)
    80006516:	6406                	ld	s0,64(sp)
    80006518:	74e2                	ld	s1,56(sp)
    8000651a:	7942                	ld	s2,48(sp)
    8000651c:	79a2                	ld	s3,40(sp)
    8000651e:	7a02                	ld	s4,32(sp)
    80006520:	6ae2                	ld	s5,24(sp)
    80006522:	6b42                	ld	s6,16(sp)
    80006524:	6ba2                	ld	s7,8(sp)
    80006526:	6c02                	ld	s8,0(sp)
    80006528:	6161                	addi	sp,sp,80
    8000652a:	8082                	ret
    ret = (i == n ? n : -1);
    8000652c:	5a7d                	li	s4,-1
    8000652e:	b7d5                	j	80006512 <filewrite+0xfa>
    panic("filewrite");
    80006530:	00003517          	auipc	a0,0x3
    80006534:	54850513          	addi	a0,a0,1352 # 80009a78 <syscalls+0x318>
    80006538:	ffffa097          	auipc	ra,0xffffa
    8000653c:	004080e7          	jalr	4(ra) # 8000053c <panic>
    return -1;
    80006540:	5a7d                	li	s4,-1
    80006542:	bfc1                	j	80006512 <filewrite+0xfa>
      return -1;
    80006544:	5a7d                	li	s4,-1
    80006546:	b7f1                	j	80006512 <filewrite+0xfa>
    80006548:	5a7d                	li	s4,-1
    8000654a:	b7e1                	j	80006512 <filewrite+0xfa>

000000008000654c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000654c:	7179                	addi	sp,sp,-48
    8000654e:	f406                	sd	ra,40(sp)
    80006550:	f022                	sd	s0,32(sp)
    80006552:	ec26                	sd	s1,24(sp)
    80006554:	e84a                	sd	s2,16(sp)
    80006556:	e44e                	sd	s3,8(sp)
    80006558:	e052                	sd	s4,0(sp)
    8000655a:	1800                	addi	s0,sp,48
    8000655c:	84aa                	mv	s1,a0
    8000655e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80006560:	0005b023          	sd	zero,0(a1)
    80006564:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006568:	00000097          	auipc	ra,0x0
    8000656c:	bf8080e7          	jalr	-1032(ra) # 80006160 <filealloc>
    80006570:	e088                	sd	a0,0(s1)
    80006572:	c551                	beqz	a0,800065fe <pipealloc+0xb2>
    80006574:	00000097          	auipc	ra,0x0
    80006578:	bec080e7          	jalr	-1044(ra) # 80006160 <filealloc>
    8000657c:	00aa3023          	sd	a0,0(s4)
    80006580:	c92d                	beqz	a0,800065f2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006582:	ffffa097          	auipc	ra,0xffffa
    80006586:	570080e7          	jalr	1392(ra) # 80000af2 <kalloc>
    8000658a:	892a                	mv	s2,a0
    8000658c:	c125                	beqz	a0,800065ec <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000658e:	4985                	li	s3,1
    80006590:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80006594:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80006598:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000659c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800065a0:	00003597          	auipc	a1,0x3
    800065a4:	4e858593          	addi	a1,a1,1256 # 80009a88 <syscalls+0x328>
    800065a8:	ffffa097          	auipc	ra,0xffffa
    800065ac:	5aa080e7          	jalr	1450(ra) # 80000b52 <initlock>
  (*f0)->type = FD_PIPE;
    800065b0:	609c                	ld	a5,0(s1)
    800065b2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800065b6:	609c                	ld	a5,0(s1)
    800065b8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800065bc:	609c                	ld	a5,0(s1)
    800065be:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800065c2:	609c                	ld	a5,0(s1)
    800065c4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800065c8:	000a3783          	ld	a5,0(s4)
    800065cc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800065d0:	000a3783          	ld	a5,0(s4)
    800065d4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800065d8:	000a3783          	ld	a5,0(s4)
    800065dc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800065e0:	000a3783          	ld	a5,0(s4)
    800065e4:	0127b823          	sd	s2,16(a5)
  return 0;
    800065e8:	4501                	li	a0,0
    800065ea:	a025                	j	80006612 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800065ec:	6088                	ld	a0,0(s1)
    800065ee:	e501                	bnez	a0,800065f6 <pipealloc+0xaa>
    800065f0:	a039                	j	800065fe <pipealloc+0xb2>
    800065f2:	6088                	ld	a0,0(s1)
    800065f4:	c51d                	beqz	a0,80006622 <pipealloc+0xd6>
    fileclose(*f0);
    800065f6:	00000097          	auipc	ra,0x0
    800065fa:	c26080e7          	jalr	-986(ra) # 8000621c <fileclose>
  if(*f1)
    800065fe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80006602:	557d                	li	a0,-1
  if(*f1)
    80006604:	c799                	beqz	a5,80006612 <pipealloc+0xc6>
    fileclose(*f1);
    80006606:	853e                	mv	a0,a5
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	c14080e7          	jalr	-1004(ra) # 8000621c <fileclose>
  return -1;
    80006610:	557d                	li	a0,-1
}
    80006612:	70a2                	ld	ra,40(sp)
    80006614:	7402                	ld	s0,32(sp)
    80006616:	64e2                	ld	s1,24(sp)
    80006618:	6942                	ld	s2,16(sp)
    8000661a:	69a2                	ld	s3,8(sp)
    8000661c:	6a02                	ld	s4,0(sp)
    8000661e:	6145                	addi	sp,sp,48
    80006620:	8082                	ret
  return -1;
    80006622:	557d                	li	a0,-1
    80006624:	b7fd                	j	80006612 <pipealloc+0xc6>

0000000080006626 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006626:	1101                	addi	sp,sp,-32
    80006628:	ec06                	sd	ra,24(sp)
    8000662a:	e822                	sd	s0,16(sp)
    8000662c:	e426                	sd	s1,8(sp)
    8000662e:	e04a                	sd	s2,0(sp)
    80006630:	1000                	addi	s0,sp,32
    80006632:	84aa                	mv	s1,a0
    80006634:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80006636:	ffffa097          	auipc	ra,0xffffa
    8000663a:	5ac080e7          	jalr	1452(ra) # 80000be2 <acquire>
  if(writable){
    8000663e:	02090d63          	beqz	s2,80006678 <pipeclose+0x52>
    pi->writeopen = 0;
    80006642:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80006646:	21848513          	addi	a0,s1,536
    8000664a:	ffffc097          	auipc	ra,0xffffc
    8000664e:	516080e7          	jalr	1302(ra) # 80002b60 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006652:	2204b783          	ld	a5,544(s1)
    80006656:	eb95                	bnez	a5,8000668a <pipeclose+0x64>
    release(&pi->lock);
    80006658:	8526                	mv	a0,s1
    8000665a:	ffffa097          	auipc	ra,0xffffa
    8000665e:	63c080e7          	jalr	1596(ra) # 80000c96 <release>
    kfree((char*)pi);
    80006662:	8526                	mv	a0,s1
    80006664:	ffffa097          	auipc	ra,0xffffa
    80006668:	392080e7          	jalr	914(ra) # 800009f6 <kfree>
  } else
    release(&pi->lock);
}
    8000666c:	60e2                	ld	ra,24(sp)
    8000666e:	6442                	ld	s0,16(sp)
    80006670:	64a2                	ld	s1,8(sp)
    80006672:	6902                	ld	s2,0(sp)
    80006674:	6105                	addi	sp,sp,32
    80006676:	8082                	ret
    pi->readopen = 0;
    80006678:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000667c:	21c48513          	addi	a0,s1,540
    80006680:	ffffc097          	auipc	ra,0xffffc
    80006684:	4e0080e7          	jalr	1248(ra) # 80002b60 <wakeup>
    80006688:	b7e9                	j	80006652 <pipeclose+0x2c>
    release(&pi->lock);
    8000668a:	8526                	mv	a0,s1
    8000668c:	ffffa097          	auipc	ra,0xffffa
    80006690:	60a080e7          	jalr	1546(ra) # 80000c96 <release>
}
    80006694:	bfe1                	j	8000666c <pipeclose+0x46>

0000000080006696 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006696:	7159                	addi	sp,sp,-112
    80006698:	f486                	sd	ra,104(sp)
    8000669a:	f0a2                	sd	s0,96(sp)
    8000669c:	eca6                	sd	s1,88(sp)
    8000669e:	e8ca                	sd	s2,80(sp)
    800066a0:	e4ce                	sd	s3,72(sp)
    800066a2:	e0d2                	sd	s4,64(sp)
    800066a4:	fc56                	sd	s5,56(sp)
    800066a6:	f85a                	sd	s6,48(sp)
    800066a8:	f45e                	sd	s7,40(sp)
    800066aa:	f062                	sd	s8,32(sp)
    800066ac:	ec66                	sd	s9,24(sp)
    800066ae:	1880                	addi	s0,sp,112
    800066b0:	84aa                	mv	s1,a0
    800066b2:	8aae                	mv	s5,a1
    800066b4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800066b6:	ffffb097          	auipc	ra,0xffffb
    800066ba:	302080e7          	jalr	770(ra) # 800019b8 <myproc>
    800066be:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800066c0:	8526                	mv	a0,s1
    800066c2:	ffffa097          	auipc	ra,0xffffa
    800066c6:	520080e7          	jalr	1312(ra) # 80000be2 <acquire>
  while(i < n){
    800066ca:	0d405163          	blez	s4,8000678c <pipewrite+0xf6>
    800066ce:	8ba6                	mv	s7,s1
  int i = 0;
    800066d0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800066d2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800066d4:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800066d8:	21c48c13          	addi	s8,s1,540
    800066dc:	a08d                	j	8000673e <pipewrite+0xa8>
      release(&pi->lock);
    800066de:	8526                	mv	a0,s1
    800066e0:	ffffa097          	auipc	ra,0xffffa
    800066e4:	5b6080e7          	jalr	1462(ra) # 80000c96 <release>
      return -1;
    800066e8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800066ea:	854a                	mv	a0,s2
    800066ec:	70a6                	ld	ra,104(sp)
    800066ee:	7406                	ld	s0,96(sp)
    800066f0:	64e6                	ld	s1,88(sp)
    800066f2:	6946                	ld	s2,80(sp)
    800066f4:	69a6                	ld	s3,72(sp)
    800066f6:	6a06                	ld	s4,64(sp)
    800066f8:	7ae2                	ld	s5,56(sp)
    800066fa:	7b42                	ld	s6,48(sp)
    800066fc:	7ba2                	ld	s7,40(sp)
    800066fe:	7c02                	ld	s8,32(sp)
    80006700:	6ce2                	ld	s9,24(sp)
    80006702:	6165                	addi	sp,sp,112
    80006704:	8082                	ret
      wakeup(&pi->nread);
    80006706:	8566                	mv	a0,s9
    80006708:	ffffc097          	auipc	ra,0xffffc
    8000670c:	458080e7          	jalr	1112(ra) # 80002b60 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006710:	85de                	mv	a1,s7
    80006712:	8562                	mv	a0,s8
    80006714:	ffffc097          	auipc	ra,0xffffc
    80006718:	046080e7          	jalr	70(ra) # 8000275a <sleep>
    8000671c:	a839                	j	8000673a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000671e:	21c4a783          	lw	a5,540(s1)
    80006722:	0017871b          	addiw	a4,a5,1
    80006726:	20e4ae23          	sw	a4,540(s1)
    8000672a:	1ff7f793          	andi	a5,a5,511
    8000672e:	97a6                	add	a5,a5,s1
    80006730:	f9f44703          	lbu	a4,-97(s0)
    80006734:	00e78c23          	sb	a4,24(a5)
      i++;
    80006738:	2905                	addiw	s2,s2,1
  while(i < n){
    8000673a:	03495d63          	bge	s2,s4,80006774 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000673e:	2204a783          	lw	a5,544(s1)
    80006742:	dfd1                	beqz	a5,800066de <pipewrite+0x48>
    80006744:	0289a783          	lw	a5,40(s3)
    80006748:	fbd9                	bnez	a5,800066de <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000674a:	2184a783          	lw	a5,536(s1)
    8000674e:	21c4a703          	lw	a4,540(s1)
    80006752:	2007879b          	addiw	a5,a5,512
    80006756:	faf708e3          	beq	a4,a5,80006706 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000675a:	4685                	li	a3,1
    8000675c:	01590633          	add	a2,s2,s5
    80006760:	f9f40593          	addi	a1,s0,-97
    80006764:	0589b503          	ld	a0,88(s3)
    80006768:	ffffb097          	auipc	ra,0xffffb
    8000676c:	f9e080e7          	jalr	-98(ra) # 80001706 <copyin>
    80006770:	fb6517e3          	bne	a0,s6,8000671e <pipewrite+0x88>
  wakeup(&pi->nread);
    80006774:	21848513          	addi	a0,s1,536
    80006778:	ffffc097          	auipc	ra,0xffffc
    8000677c:	3e8080e7          	jalr	1000(ra) # 80002b60 <wakeup>
  release(&pi->lock);
    80006780:	8526                	mv	a0,s1
    80006782:	ffffa097          	auipc	ra,0xffffa
    80006786:	514080e7          	jalr	1300(ra) # 80000c96 <release>
  return i;
    8000678a:	b785                	j	800066ea <pipewrite+0x54>
  int i = 0;
    8000678c:	4901                	li	s2,0
    8000678e:	b7dd                	j	80006774 <pipewrite+0xde>

0000000080006790 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006790:	715d                	addi	sp,sp,-80
    80006792:	e486                	sd	ra,72(sp)
    80006794:	e0a2                	sd	s0,64(sp)
    80006796:	fc26                	sd	s1,56(sp)
    80006798:	f84a                	sd	s2,48(sp)
    8000679a:	f44e                	sd	s3,40(sp)
    8000679c:	f052                	sd	s4,32(sp)
    8000679e:	ec56                	sd	s5,24(sp)
    800067a0:	e85a                	sd	s6,16(sp)
    800067a2:	0880                	addi	s0,sp,80
    800067a4:	84aa                	mv	s1,a0
    800067a6:	892e                	mv	s2,a1
    800067a8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800067aa:	ffffb097          	auipc	ra,0xffffb
    800067ae:	20e080e7          	jalr	526(ra) # 800019b8 <myproc>
    800067b2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800067b4:	8b26                	mv	s6,s1
    800067b6:	8526                	mv	a0,s1
    800067b8:	ffffa097          	auipc	ra,0xffffa
    800067bc:	42a080e7          	jalr	1066(ra) # 80000be2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067c0:	2184a703          	lw	a4,536(s1)
    800067c4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800067c8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067cc:	02f71463          	bne	a4,a5,800067f4 <piperead+0x64>
    800067d0:	2244a783          	lw	a5,548(s1)
    800067d4:	c385                	beqz	a5,800067f4 <piperead+0x64>
    if(pr->killed){
    800067d6:	028a2783          	lw	a5,40(s4)
    800067da:	ebc1                	bnez	a5,8000686a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800067dc:	85da                	mv	a1,s6
    800067de:	854e                	mv	a0,s3
    800067e0:	ffffc097          	auipc	ra,0xffffc
    800067e4:	f7a080e7          	jalr	-134(ra) # 8000275a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800067e8:	2184a703          	lw	a4,536(s1)
    800067ec:	21c4a783          	lw	a5,540(s1)
    800067f0:	fef700e3          	beq	a4,a5,800067d0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800067f4:	09505263          	blez	s5,80006878 <piperead+0xe8>
    800067f8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800067fa:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800067fc:	2184a783          	lw	a5,536(s1)
    80006800:	21c4a703          	lw	a4,540(s1)
    80006804:	02f70d63          	beq	a4,a5,8000683e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80006808:	0017871b          	addiw	a4,a5,1
    8000680c:	20e4ac23          	sw	a4,536(s1)
    80006810:	1ff7f793          	andi	a5,a5,511
    80006814:	97a6                	add	a5,a5,s1
    80006816:	0187c783          	lbu	a5,24(a5)
    8000681a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000681e:	4685                	li	a3,1
    80006820:	fbf40613          	addi	a2,s0,-65
    80006824:	85ca                	mv	a1,s2
    80006826:	058a3503          	ld	a0,88(s4)
    8000682a:	ffffb097          	auipc	ra,0xffffb
    8000682e:	e50080e7          	jalr	-432(ra) # 8000167a <copyout>
    80006832:	01650663          	beq	a0,s6,8000683e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006836:	2985                	addiw	s3,s3,1
    80006838:	0905                	addi	s2,s2,1
    8000683a:	fd3a91e3          	bne	s5,s3,800067fc <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000683e:	21c48513          	addi	a0,s1,540
    80006842:	ffffc097          	auipc	ra,0xffffc
    80006846:	31e080e7          	jalr	798(ra) # 80002b60 <wakeup>
  release(&pi->lock);
    8000684a:	8526                	mv	a0,s1
    8000684c:	ffffa097          	auipc	ra,0xffffa
    80006850:	44a080e7          	jalr	1098(ra) # 80000c96 <release>
  return i;
}
    80006854:	854e                	mv	a0,s3
    80006856:	60a6                	ld	ra,72(sp)
    80006858:	6406                	ld	s0,64(sp)
    8000685a:	74e2                	ld	s1,56(sp)
    8000685c:	7942                	ld	s2,48(sp)
    8000685e:	79a2                	ld	s3,40(sp)
    80006860:	7a02                	ld	s4,32(sp)
    80006862:	6ae2                	ld	s5,24(sp)
    80006864:	6b42                	ld	s6,16(sp)
    80006866:	6161                	addi	sp,sp,80
    80006868:	8082                	ret
      release(&pi->lock);
    8000686a:	8526                	mv	a0,s1
    8000686c:	ffffa097          	auipc	ra,0xffffa
    80006870:	42a080e7          	jalr	1066(ra) # 80000c96 <release>
      return -1;
    80006874:	59fd                	li	s3,-1
    80006876:	bff9                	j	80006854 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006878:	4981                	li	s3,0
    8000687a:	b7d1                	j	8000683e <piperead+0xae>

000000008000687c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000687c:	df010113          	addi	sp,sp,-528
    80006880:	20113423          	sd	ra,520(sp)
    80006884:	20813023          	sd	s0,512(sp)
    80006888:	ffa6                	sd	s1,504(sp)
    8000688a:	fbca                	sd	s2,496(sp)
    8000688c:	f7ce                	sd	s3,488(sp)
    8000688e:	f3d2                	sd	s4,480(sp)
    80006890:	efd6                	sd	s5,472(sp)
    80006892:	ebda                	sd	s6,464(sp)
    80006894:	e7de                	sd	s7,456(sp)
    80006896:	e3e2                	sd	s8,448(sp)
    80006898:	ff66                	sd	s9,440(sp)
    8000689a:	fb6a                	sd	s10,432(sp)
    8000689c:	f76e                	sd	s11,424(sp)
    8000689e:	0c00                	addi	s0,sp,528
    800068a0:	84aa                	mv	s1,a0
    800068a2:	dea43c23          	sd	a0,-520(s0)
    800068a6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800068aa:	ffffb097          	auipc	ra,0xffffb
    800068ae:	10e080e7          	jalr	270(ra) # 800019b8 <myproc>
    800068b2:	892a                	mv	s2,a0

  begin_op();
    800068b4:	fffff097          	auipc	ra,0xfffff
    800068b8:	49c080e7          	jalr	1180(ra) # 80005d50 <begin_op>

  if((ip = namei(path)) == 0){
    800068bc:	8526                	mv	a0,s1
    800068be:	fffff097          	auipc	ra,0xfffff
    800068c2:	276080e7          	jalr	630(ra) # 80005b34 <namei>
    800068c6:	c92d                	beqz	a0,80006938 <exec+0xbc>
    800068c8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800068ca:	fffff097          	auipc	ra,0xfffff
    800068ce:	ab4080e7          	jalr	-1356(ra) # 8000537e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800068d2:	04000713          	li	a4,64
    800068d6:	4681                	li	a3,0
    800068d8:	e5040613          	addi	a2,s0,-432
    800068dc:	4581                	li	a1,0
    800068de:	8526                	mv	a0,s1
    800068e0:	fffff097          	auipc	ra,0xfffff
    800068e4:	d52080e7          	jalr	-686(ra) # 80005632 <readi>
    800068e8:	04000793          	li	a5,64
    800068ec:	00f51a63          	bne	a0,a5,80006900 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800068f0:	e5042703          	lw	a4,-432(s0)
    800068f4:	464c47b7          	lui	a5,0x464c4
    800068f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800068fc:	04f70463          	beq	a4,a5,80006944 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80006900:	8526                	mv	a0,s1
    80006902:	fffff097          	auipc	ra,0xfffff
    80006906:	cde080e7          	jalr	-802(ra) # 800055e0 <iunlockput>
    end_op();
    8000690a:	fffff097          	auipc	ra,0xfffff
    8000690e:	4c6080e7          	jalr	1222(ra) # 80005dd0 <end_op>
  }
  return -1;
    80006912:	557d                	li	a0,-1
}
    80006914:	20813083          	ld	ra,520(sp)
    80006918:	20013403          	ld	s0,512(sp)
    8000691c:	74fe                	ld	s1,504(sp)
    8000691e:	795e                	ld	s2,496(sp)
    80006920:	79be                	ld	s3,488(sp)
    80006922:	7a1e                	ld	s4,480(sp)
    80006924:	6afe                	ld	s5,472(sp)
    80006926:	6b5e                	ld	s6,464(sp)
    80006928:	6bbe                	ld	s7,456(sp)
    8000692a:	6c1e                	ld	s8,448(sp)
    8000692c:	7cfa                	ld	s9,440(sp)
    8000692e:	7d5a                	ld	s10,432(sp)
    80006930:	7dba                	ld	s11,424(sp)
    80006932:	21010113          	addi	sp,sp,528
    80006936:	8082                	ret
    end_op();
    80006938:	fffff097          	auipc	ra,0xfffff
    8000693c:	498080e7          	jalr	1176(ra) # 80005dd0 <end_op>
    return -1;
    80006940:	557d                	li	a0,-1
    80006942:	bfc9                	j	80006914 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80006944:	854a                	mv	a0,s2
    80006946:	ffffb097          	auipc	ra,0xffffb
    8000694a:	16e080e7          	jalr	366(ra) # 80001ab4 <proc_pagetable>
    8000694e:	8baa                	mv	s7,a0
    80006950:	d945                	beqz	a0,80006900 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006952:	e7042983          	lw	s3,-400(s0)
    80006956:	e8845783          	lhu	a5,-376(s0)
    8000695a:	c7ad                	beqz	a5,800069c4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000695c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000695e:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80006960:	6c85                	lui	s9,0x1
    80006962:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80006966:	def43823          	sd	a5,-528(s0)
    8000696a:	a42d                	j	80006b94 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000696c:	00003517          	auipc	a0,0x3
    80006970:	12450513          	addi	a0,a0,292 # 80009a90 <syscalls+0x330>
    80006974:	ffffa097          	auipc	ra,0xffffa
    80006978:	bc8080e7          	jalr	-1080(ra) # 8000053c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000697c:	8756                	mv	a4,s5
    8000697e:	012d86bb          	addw	a3,s11,s2
    80006982:	4581                	li	a1,0
    80006984:	8526                	mv	a0,s1
    80006986:	fffff097          	auipc	ra,0xfffff
    8000698a:	cac080e7          	jalr	-852(ra) # 80005632 <readi>
    8000698e:	2501                	sext.w	a0,a0
    80006990:	1aaa9963          	bne	s5,a0,80006b42 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80006994:	6785                	lui	a5,0x1
    80006996:	0127893b          	addw	s2,a5,s2
    8000699a:	77fd                	lui	a5,0xfffff
    8000699c:	01478a3b          	addw	s4,a5,s4
    800069a0:	1f897163          	bgeu	s2,s8,80006b82 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800069a4:	02091593          	slli	a1,s2,0x20
    800069a8:	9181                	srli	a1,a1,0x20
    800069aa:	95ea                	add	a1,a1,s10
    800069ac:	855e                	mv	a0,s7
    800069ae:	ffffa097          	auipc	ra,0xffffa
    800069b2:	6c8080e7          	jalr	1736(ra) # 80001076 <walkaddr>
    800069b6:	862a                	mv	a2,a0
    if(pa == 0)
    800069b8:	d955                	beqz	a0,8000696c <exec+0xf0>
      n = PGSIZE;
    800069ba:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800069bc:	fd9a70e3          	bgeu	s4,s9,8000697c <exec+0x100>
      n = sz - i;
    800069c0:	8ad2                	mv	s5,s4
    800069c2:	bf6d                	j	8000697c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800069c4:	4901                	li	s2,0
  iunlockput(ip);
    800069c6:	8526                	mv	a0,s1
    800069c8:	fffff097          	auipc	ra,0xfffff
    800069cc:	c18080e7          	jalr	-1000(ra) # 800055e0 <iunlockput>
  end_op();
    800069d0:	fffff097          	auipc	ra,0xfffff
    800069d4:	400080e7          	jalr	1024(ra) # 80005dd0 <end_op>
  p = myproc();
    800069d8:	ffffb097          	auipc	ra,0xffffb
    800069dc:	fe0080e7          	jalr	-32(ra) # 800019b8 <myproc>
    800069e0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800069e2:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800069e6:	6785                	lui	a5,0x1
    800069e8:	17fd                	addi	a5,a5,-1
    800069ea:	993e                	add	s2,s2,a5
    800069ec:	757d                	lui	a0,0xfffff
    800069ee:	00a977b3          	and	a5,s2,a0
    800069f2:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800069f6:	6609                	lui	a2,0x2
    800069f8:	963e                	add	a2,a2,a5
    800069fa:	85be                	mv	a1,a5
    800069fc:	855e                	mv	a0,s7
    800069fe:	ffffb097          	auipc	ra,0xffffb
    80006a02:	a2c080e7          	jalr	-1492(ra) # 8000142a <uvmalloc>
    80006a06:	8b2a                	mv	s6,a0
  ip = 0;
    80006a08:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80006a0a:	12050c63          	beqz	a0,80006b42 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80006a0e:	75f9                	lui	a1,0xffffe
    80006a10:	95aa                	add	a1,a1,a0
    80006a12:	855e                	mv	a0,s7
    80006a14:	ffffb097          	auipc	ra,0xffffb
    80006a18:	c34080e7          	jalr	-972(ra) # 80001648 <uvmclear>
  stackbase = sp - PGSIZE;
    80006a1c:	7c7d                	lui	s8,0xfffff
    80006a1e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80006a20:	e0043783          	ld	a5,-512(s0)
    80006a24:	6388                	ld	a0,0(a5)
    80006a26:	c535                	beqz	a0,80006a92 <exec+0x216>
    80006a28:	e9040993          	addi	s3,s0,-368
    80006a2c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80006a30:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80006a32:	ffffa097          	auipc	ra,0xffffa
    80006a36:	430080e7          	jalr	1072(ra) # 80000e62 <strlen>
    80006a3a:	2505                	addiw	a0,a0,1
    80006a3c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80006a40:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80006a44:	13896363          	bltu	s2,s8,80006b6a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80006a48:	e0043d83          	ld	s11,-512(s0)
    80006a4c:	000dba03          	ld	s4,0(s11)
    80006a50:	8552                	mv	a0,s4
    80006a52:	ffffa097          	auipc	ra,0xffffa
    80006a56:	410080e7          	jalr	1040(ra) # 80000e62 <strlen>
    80006a5a:	0015069b          	addiw	a3,a0,1
    80006a5e:	8652                	mv	a2,s4
    80006a60:	85ca                	mv	a1,s2
    80006a62:	855e                	mv	a0,s7
    80006a64:	ffffb097          	auipc	ra,0xffffb
    80006a68:	c16080e7          	jalr	-1002(ra) # 8000167a <copyout>
    80006a6c:	10054363          	bltz	a0,80006b72 <exec+0x2f6>
    ustack[argc] = sp;
    80006a70:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006a74:	0485                	addi	s1,s1,1
    80006a76:	008d8793          	addi	a5,s11,8
    80006a7a:	e0f43023          	sd	a5,-512(s0)
    80006a7e:	008db503          	ld	a0,8(s11)
    80006a82:	c911                	beqz	a0,80006a96 <exec+0x21a>
    if(argc >= MAXARG)
    80006a84:	09a1                	addi	s3,s3,8
    80006a86:	fb3c96e3          	bne	s9,s3,80006a32 <exec+0x1b6>
  sz = sz1;
    80006a8a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80006a8e:	4481                	li	s1,0
    80006a90:	a84d                	j	80006b42 <exec+0x2c6>
  sp = sz;
    80006a92:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80006a94:	4481                	li	s1,0
  ustack[argc] = 0;
    80006a96:	00349793          	slli	a5,s1,0x3
    80006a9a:	f9040713          	addi	a4,s0,-112
    80006a9e:	97ba                	add	a5,a5,a4
    80006aa0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80006aa4:	00148693          	addi	a3,s1,1
    80006aa8:	068e                	slli	a3,a3,0x3
    80006aaa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80006aae:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80006ab2:	01897663          	bgeu	s2,s8,80006abe <exec+0x242>
  sz = sz1;
    80006ab6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80006aba:	4481                	li	s1,0
    80006abc:	a059                	j	80006b42 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006abe:	e9040613          	addi	a2,s0,-368
    80006ac2:	85ca                	mv	a1,s2
    80006ac4:	855e                	mv	a0,s7
    80006ac6:	ffffb097          	auipc	ra,0xffffb
    80006aca:	bb4080e7          	jalr	-1100(ra) # 8000167a <copyout>
    80006ace:	0a054663          	bltz	a0,80006b7a <exec+0x2fe>
  p->trapframe->a1 = sp;
    80006ad2:	060ab783          	ld	a5,96(s5)
    80006ad6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006ada:	df843783          	ld	a5,-520(s0)
    80006ade:	0007c703          	lbu	a4,0(a5)
    80006ae2:	cf11                	beqz	a4,80006afe <exec+0x282>
    80006ae4:	0785                	addi	a5,a5,1
    if(*s == '/')
    80006ae6:	02f00693          	li	a3,47
    80006aea:	a039                	j	80006af8 <exec+0x27c>
      last = s+1;
    80006aec:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80006af0:	0785                	addi	a5,a5,1
    80006af2:	fff7c703          	lbu	a4,-1(a5)
    80006af6:	c701                	beqz	a4,80006afe <exec+0x282>
    if(*s == '/')
    80006af8:	fed71ce3          	bne	a4,a3,80006af0 <exec+0x274>
    80006afc:	bfc5                	j	80006aec <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80006afe:	4641                	li	a2,16
    80006b00:	df843583          	ld	a1,-520(s0)
    80006b04:	160a8513          	addi	a0,s5,352
    80006b08:	ffffa097          	auipc	ra,0xffffa
    80006b0c:	328080e7          	jalr	808(ra) # 80000e30 <safestrcpy>
  oldpagetable = p->pagetable;
    80006b10:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80006b14:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    80006b18:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80006b1c:	060ab783          	ld	a5,96(s5)
    80006b20:	e6843703          	ld	a4,-408(s0)
    80006b24:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80006b26:	060ab783          	ld	a5,96(s5)
    80006b2a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006b2e:	85ea                	mv	a1,s10
    80006b30:	ffffb097          	auipc	ra,0xffffb
    80006b34:	020080e7          	jalr	32(ra) # 80001b50 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80006b38:	0004851b          	sext.w	a0,s1
    80006b3c:	bbe1                	j	80006914 <exec+0x98>
    80006b3e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80006b42:	e0843583          	ld	a1,-504(s0)
    80006b46:	855e                	mv	a0,s7
    80006b48:	ffffb097          	auipc	ra,0xffffb
    80006b4c:	008080e7          	jalr	8(ra) # 80001b50 <proc_freepagetable>
  if(ip){
    80006b50:	da0498e3          	bnez	s1,80006900 <exec+0x84>
  return -1;
    80006b54:	557d                	li	a0,-1
    80006b56:	bb7d                	j	80006914 <exec+0x98>
    80006b58:	e1243423          	sd	s2,-504(s0)
    80006b5c:	b7dd                	j	80006b42 <exec+0x2c6>
    80006b5e:	e1243423          	sd	s2,-504(s0)
    80006b62:	b7c5                	j	80006b42 <exec+0x2c6>
    80006b64:	e1243423          	sd	s2,-504(s0)
    80006b68:	bfe9                	j	80006b42 <exec+0x2c6>
  sz = sz1;
    80006b6a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80006b6e:	4481                	li	s1,0
    80006b70:	bfc9                	j	80006b42 <exec+0x2c6>
  sz = sz1;
    80006b72:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80006b76:	4481                	li	s1,0
    80006b78:	b7e9                	j	80006b42 <exec+0x2c6>
  sz = sz1;
    80006b7a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80006b7e:	4481                	li	s1,0
    80006b80:	b7c9                	j	80006b42 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006b82:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006b86:	2b05                	addiw	s6,s6,1
    80006b88:	0389899b          	addiw	s3,s3,56
    80006b8c:	e8845783          	lhu	a5,-376(s0)
    80006b90:	e2fb5be3          	bge	s6,a5,800069c6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80006b94:	2981                	sext.w	s3,s3
    80006b96:	03800713          	li	a4,56
    80006b9a:	86ce                	mv	a3,s3
    80006b9c:	e1840613          	addi	a2,s0,-488
    80006ba0:	4581                	li	a1,0
    80006ba2:	8526                	mv	a0,s1
    80006ba4:	fffff097          	auipc	ra,0xfffff
    80006ba8:	a8e080e7          	jalr	-1394(ra) # 80005632 <readi>
    80006bac:	03800793          	li	a5,56
    80006bb0:	f8f517e3          	bne	a0,a5,80006b3e <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80006bb4:	e1842783          	lw	a5,-488(s0)
    80006bb8:	4705                	li	a4,1
    80006bba:	fce796e3          	bne	a5,a4,80006b86 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80006bbe:	e4043603          	ld	a2,-448(s0)
    80006bc2:	e3843783          	ld	a5,-456(s0)
    80006bc6:	f8f669e3          	bltu	a2,a5,80006b58 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006bca:	e2843783          	ld	a5,-472(s0)
    80006bce:	963e                	add	a2,a2,a5
    80006bd0:	f8f667e3          	bltu	a2,a5,80006b5e <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80006bd4:	85ca                	mv	a1,s2
    80006bd6:	855e                	mv	a0,s7
    80006bd8:	ffffb097          	auipc	ra,0xffffb
    80006bdc:	852080e7          	jalr	-1966(ra) # 8000142a <uvmalloc>
    80006be0:	e0a43423          	sd	a0,-504(s0)
    80006be4:	d141                	beqz	a0,80006b64 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80006be6:	e2843d03          	ld	s10,-472(s0)
    80006bea:	df043783          	ld	a5,-528(s0)
    80006bee:	00fd77b3          	and	a5,s10,a5
    80006bf2:	fba1                	bnez	a5,80006b42 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006bf4:	e2042d83          	lw	s11,-480(s0)
    80006bf8:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006bfc:	f80c03e3          	beqz	s8,80006b82 <exec+0x306>
    80006c00:	8a62                	mv	s4,s8
    80006c02:	4901                	li	s2,0
    80006c04:	b345                	j	800069a4 <exec+0x128>

0000000080006c06 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006c06:	7179                	addi	sp,sp,-48
    80006c08:	f406                	sd	ra,40(sp)
    80006c0a:	f022                	sd	s0,32(sp)
    80006c0c:	ec26                	sd	s1,24(sp)
    80006c0e:	e84a                	sd	s2,16(sp)
    80006c10:	1800                	addi	s0,sp,48
    80006c12:	892e                	mv	s2,a1
    80006c14:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80006c16:	fdc40593          	addi	a1,s0,-36
    80006c1a:	ffffe097          	auipc	ra,0xffffe
    80006c1e:	816080e7          	jalr	-2026(ra) # 80004430 <argint>
    80006c22:	04054063          	bltz	a0,80006c62 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006c26:	fdc42703          	lw	a4,-36(s0)
    80006c2a:	47bd                	li	a5,15
    80006c2c:	02e7ed63          	bltu	a5,a4,80006c66 <argfd+0x60>
    80006c30:	ffffb097          	auipc	ra,0xffffb
    80006c34:	d88080e7          	jalr	-632(ra) # 800019b8 <myproc>
    80006c38:	fdc42703          	lw	a4,-36(s0)
    80006c3c:	01a70793          	addi	a5,a4,26
    80006c40:	078e                	slli	a5,a5,0x3
    80006c42:	953e                	add	a0,a0,a5
    80006c44:	651c                	ld	a5,8(a0)
    80006c46:	c395                	beqz	a5,80006c6a <argfd+0x64>
    return -1;
  if(pfd)
    80006c48:	00090463          	beqz	s2,80006c50 <argfd+0x4a>
    *pfd = fd;
    80006c4c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006c50:	4501                	li	a0,0
  if(pf)
    80006c52:	c091                	beqz	s1,80006c56 <argfd+0x50>
    *pf = f;
    80006c54:	e09c                	sd	a5,0(s1)
}
    80006c56:	70a2                	ld	ra,40(sp)
    80006c58:	7402                	ld	s0,32(sp)
    80006c5a:	64e2                	ld	s1,24(sp)
    80006c5c:	6942                	ld	s2,16(sp)
    80006c5e:	6145                	addi	sp,sp,48
    80006c60:	8082                	ret
    return -1;
    80006c62:	557d                	li	a0,-1
    80006c64:	bfcd                	j	80006c56 <argfd+0x50>
    return -1;
    80006c66:	557d                	li	a0,-1
    80006c68:	b7fd                	j	80006c56 <argfd+0x50>
    80006c6a:	557d                	li	a0,-1
    80006c6c:	b7ed                	j	80006c56 <argfd+0x50>

0000000080006c6e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80006c6e:	1101                	addi	sp,sp,-32
    80006c70:	ec06                	sd	ra,24(sp)
    80006c72:	e822                	sd	s0,16(sp)
    80006c74:	e426                	sd	s1,8(sp)
    80006c76:	1000                	addi	s0,sp,32
    80006c78:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006c7a:	ffffb097          	auipc	ra,0xffffb
    80006c7e:	d3e080e7          	jalr	-706(ra) # 800019b8 <myproc>
    80006c82:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006c84:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd60d8>
    80006c88:	4501                	li	a0,0
    80006c8a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80006c8c:	6398                	ld	a4,0(a5)
    80006c8e:	cb19                	beqz	a4,80006ca4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80006c90:	2505                	addiw	a0,a0,1
    80006c92:	07a1                	addi	a5,a5,8
    80006c94:	fed51ce3          	bne	a0,a3,80006c8c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006c98:	557d                	li	a0,-1
}
    80006c9a:	60e2                	ld	ra,24(sp)
    80006c9c:	6442                	ld	s0,16(sp)
    80006c9e:	64a2                	ld	s1,8(sp)
    80006ca0:	6105                	addi	sp,sp,32
    80006ca2:	8082                	ret
      p->ofile[fd] = f;
    80006ca4:	01a50793          	addi	a5,a0,26
    80006ca8:	078e                	slli	a5,a5,0x3
    80006caa:	963e                	add	a2,a2,a5
    80006cac:	e604                	sd	s1,8(a2)
      return fd;
    80006cae:	b7f5                	j	80006c9a <fdalloc+0x2c>

0000000080006cb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006cb0:	715d                	addi	sp,sp,-80
    80006cb2:	e486                	sd	ra,72(sp)
    80006cb4:	e0a2                	sd	s0,64(sp)
    80006cb6:	fc26                	sd	s1,56(sp)
    80006cb8:	f84a                	sd	s2,48(sp)
    80006cba:	f44e                	sd	s3,40(sp)
    80006cbc:	f052                	sd	s4,32(sp)
    80006cbe:	ec56                	sd	s5,24(sp)
    80006cc0:	0880                	addi	s0,sp,80
    80006cc2:	89ae                	mv	s3,a1
    80006cc4:	8ab2                	mv	s5,a2
    80006cc6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006cc8:	fb040593          	addi	a1,s0,-80
    80006ccc:	fffff097          	auipc	ra,0xfffff
    80006cd0:	e86080e7          	jalr	-378(ra) # 80005b52 <nameiparent>
    80006cd4:	892a                	mv	s2,a0
    80006cd6:	12050f63          	beqz	a0,80006e14 <create+0x164>
    return 0;

  ilock(dp);
    80006cda:	ffffe097          	auipc	ra,0xffffe
    80006cde:	6a4080e7          	jalr	1700(ra) # 8000537e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006ce2:	4601                	li	a2,0
    80006ce4:	fb040593          	addi	a1,s0,-80
    80006ce8:	854a                	mv	a0,s2
    80006cea:	fffff097          	auipc	ra,0xfffff
    80006cee:	b78080e7          	jalr	-1160(ra) # 80005862 <dirlookup>
    80006cf2:	84aa                	mv	s1,a0
    80006cf4:	c921                	beqz	a0,80006d44 <create+0x94>
    iunlockput(dp);
    80006cf6:	854a                	mv	a0,s2
    80006cf8:	fffff097          	auipc	ra,0xfffff
    80006cfc:	8e8080e7          	jalr	-1816(ra) # 800055e0 <iunlockput>
    ilock(ip);
    80006d00:	8526                	mv	a0,s1
    80006d02:	ffffe097          	auipc	ra,0xffffe
    80006d06:	67c080e7          	jalr	1660(ra) # 8000537e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006d0a:	2981                	sext.w	s3,s3
    80006d0c:	4789                	li	a5,2
    80006d0e:	02f99463          	bne	s3,a5,80006d36 <create+0x86>
    80006d12:	0444d783          	lhu	a5,68(s1)
    80006d16:	37f9                	addiw	a5,a5,-2
    80006d18:	17c2                	slli	a5,a5,0x30
    80006d1a:	93c1                	srli	a5,a5,0x30
    80006d1c:	4705                	li	a4,1
    80006d1e:	00f76c63          	bltu	a4,a5,80006d36 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80006d22:	8526                	mv	a0,s1
    80006d24:	60a6                	ld	ra,72(sp)
    80006d26:	6406                	ld	s0,64(sp)
    80006d28:	74e2                	ld	s1,56(sp)
    80006d2a:	7942                	ld	s2,48(sp)
    80006d2c:	79a2                	ld	s3,40(sp)
    80006d2e:	7a02                	ld	s4,32(sp)
    80006d30:	6ae2                	ld	s5,24(sp)
    80006d32:	6161                	addi	sp,sp,80
    80006d34:	8082                	ret
    iunlockput(ip);
    80006d36:	8526                	mv	a0,s1
    80006d38:	fffff097          	auipc	ra,0xfffff
    80006d3c:	8a8080e7          	jalr	-1880(ra) # 800055e0 <iunlockput>
    return 0;
    80006d40:	4481                	li	s1,0
    80006d42:	b7c5                	j	80006d22 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80006d44:	85ce                	mv	a1,s3
    80006d46:	00092503          	lw	a0,0(s2)
    80006d4a:	ffffe097          	auipc	ra,0xffffe
    80006d4e:	49c080e7          	jalr	1180(ra) # 800051e6 <ialloc>
    80006d52:	84aa                	mv	s1,a0
    80006d54:	c529                	beqz	a0,80006d9e <create+0xee>
  ilock(ip);
    80006d56:	ffffe097          	auipc	ra,0xffffe
    80006d5a:	628080e7          	jalr	1576(ra) # 8000537e <ilock>
  ip->major = major;
    80006d5e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80006d62:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80006d66:	4785                	li	a5,1
    80006d68:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006d6c:	8526                	mv	a0,s1
    80006d6e:	ffffe097          	auipc	ra,0xffffe
    80006d72:	546080e7          	jalr	1350(ra) # 800052b4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80006d76:	2981                	sext.w	s3,s3
    80006d78:	4785                	li	a5,1
    80006d7a:	02f98a63          	beq	s3,a5,80006dae <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80006d7e:	40d0                	lw	a2,4(s1)
    80006d80:	fb040593          	addi	a1,s0,-80
    80006d84:	854a                	mv	a0,s2
    80006d86:	fffff097          	auipc	ra,0xfffff
    80006d8a:	cec080e7          	jalr	-788(ra) # 80005a72 <dirlink>
    80006d8e:	06054b63          	bltz	a0,80006e04 <create+0x154>
  iunlockput(dp);
    80006d92:	854a                	mv	a0,s2
    80006d94:	fffff097          	auipc	ra,0xfffff
    80006d98:	84c080e7          	jalr	-1972(ra) # 800055e0 <iunlockput>
  return ip;
    80006d9c:	b759                	j	80006d22 <create+0x72>
    panic("create: ialloc");
    80006d9e:	00003517          	auipc	a0,0x3
    80006da2:	d1250513          	addi	a0,a0,-750 # 80009ab0 <syscalls+0x350>
    80006da6:	ffff9097          	auipc	ra,0xffff9
    80006daa:	796080e7          	jalr	1942(ra) # 8000053c <panic>
    dp->nlink++;  // for ".."
    80006dae:	04a95783          	lhu	a5,74(s2)
    80006db2:	2785                	addiw	a5,a5,1
    80006db4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80006db8:	854a                	mv	a0,s2
    80006dba:	ffffe097          	auipc	ra,0xffffe
    80006dbe:	4fa080e7          	jalr	1274(ra) # 800052b4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006dc2:	40d0                	lw	a2,4(s1)
    80006dc4:	00003597          	auipc	a1,0x3
    80006dc8:	cfc58593          	addi	a1,a1,-772 # 80009ac0 <syscalls+0x360>
    80006dcc:	8526                	mv	a0,s1
    80006dce:	fffff097          	auipc	ra,0xfffff
    80006dd2:	ca4080e7          	jalr	-860(ra) # 80005a72 <dirlink>
    80006dd6:	00054f63          	bltz	a0,80006df4 <create+0x144>
    80006dda:	00492603          	lw	a2,4(s2)
    80006dde:	00003597          	auipc	a1,0x3
    80006de2:	cea58593          	addi	a1,a1,-790 # 80009ac8 <syscalls+0x368>
    80006de6:	8526                	mv	a0,s1
    80006de8:	fffff097          	auipc	ra,0xfffff
    80006dec:	c8a080e7          	jalr	-886(ra) # 80005a72 <dirlink>
    80006df0:	f80557e3          	bgez	a0,80006d7e <create+0xce>
      panic("create dots");
    80006df4:	00003517          	auipc	a0,0x3
    80006df8:	cdc50513          	addi	a0,a0,-804 # 80009ad0 <syscalls+0x370>
    80006dfc:	ffff9097          	auipc	ra,0xffff9
    80006e00:	740080e7          	jalr	1856(ra) # 8000053c <panic>
    panic("create: dirlink");
    80006e04:	00003517          	auipc	a0,0x3
    80006e08:	cdc50513          	addi	a0,a0,-804 # 80009ae0 <syscalls+0x380>
    80006e0c:	ffff9097          	auipc	ra,0xffff9
    80006e10:	730080e7          	jalr	1840(ra) # 8000053c <panic>
    return 0;
    80006e14:	84aa                	mv	s1,a0
    80006e16:	b731                	j	80006d22 <create+0x72>

0000000080006e18 <sys_dup>:
{
    80006e18:	7179                	addi	sp,sp,-48
    80006e1a:	f406                	sd	ra,40(sp)
    80006e1c:	f022                	sd	s0,32(sp)
    80006e1e:	ec26                	sd	s1,24(sp)
    80006e20:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006e22:	fd840613          	addi	a2,s0,-40
    80006e26:	4581                	li	a1,0
    80006e28:	4501                	li	a0,0
    80006e2a:	00000097          	auipc	ra,0x0
    80006e2e:	ddc080e7          	jalr	-548(ra) # 80006c06 <argfd>
    return -1;
    80006e32:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006e34:	02054363          	bltz	a0,80006e5a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80006e38:	fd843503          	ld	a0,-40(s0)
    80006e3c:	00000097          	auipc	ra,0x0
    80006e40:	e32080e7          	jalr	-462(ra) # 80006c6e <fdalloc>
    80006e44:	84aa                	mv	s1,a0
    return -1;
    80006e46:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80006e48:	00054963          	bltz	a0,80006e5a <sys_dup+0x42>
  filedup(f);
    80006e4c:	fd843503          	ld	a0,-40(s0)
    80006e50:	fffff097          	auipc	ra,0xfffff
    80006e54:	37a080e7          	jalr	890(ra) # 800061ca <filedup>
  return fd;
    80006e58:	87a6                	mv	a5,s1
}
    80006e5a:	853e                	mv	a0,a5
    80006e5c:	70a2                	ld	ra,40(sp)
    80006e5e:	7402                	ld	s0,32(sp)
    80006e60:	64e2                	ld	s1,24(sp)
    80006e62:	6145                	addi	sp,sp,48
    80006e64:	8082                	ret

0000000080006e66 <sys_read>:
{
    80006e66:	7179                	addi	sp,sp,-48
    80006e68:	f406                	sd	ra,40(sp)
    80006e6a:	f022                	sd	s0,32(sp)
    80006e6c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006e6e:	fe840613          	addi	a2,s0,-24
    80006e72:	4581                	li	a1,0
    80006e74:	4501                	li	a0,0
    80006e76:	00000097          	auipc	ra,0x0
    80006e7a:	d90080e7          	jalr	-624(ra) # 80006c06 <argfd>
    return -1;
    80006e7e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006e80:	04054163          	bltz	a0,80006ec2 <sys_read+0x5c>
    80006e84:	fe440593          	addi	a1,s0,-28
    80006e88:	4509                	li	a0,2
    80006e8a:	ffffd097          	auipc	ra,0xffffd
    80006e8e:	5a6080e7          	jalr	1446(ra) # 80004430 <argint>
    return -1;
    80006e92:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006e94:	02054763          	bltz	a0,80006ec2 <sys_read+0x5c>
    80006e98:	fd840593          	addi	a1,s0,-40
    80006e9c:	4505                	li	a0,1
    80006e9e:	ffffd097          	auipc	ra,0xffffd
    80006ea2:	5b4080e7          	jalr	1460(ra) # 80004452 <argaddr>
    return -1;
    80006ea6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006ea8:	00054d63          	bltz	a0,80006ec2 <sys_read+0x5c>
  return fileread(f, p, n);
    80006eac:	fe442603          	lw	a2,-28(s0)
    80006eb0:	fd843583          	ld	a1,-40(s0)
    80006eb4:	fe843503          	ld	a0,-24(s0)
    80006eb8:	fffff097          	auipc	ra,0xfffff
    80006ebc:	49e080e7          	jalr	1182(ra) # 80006356 <fileread>
    80006ec0:	87aa                	mv	a5,a0
}
    80006ec2:	853e                	mv	a0,a5
    80006ec4:	70a2                	ld	ra,40(sp)
    80006ec6:	7402                	ld	s0,32(sp)
    80006ec8:	6145                	addi	sp,sp,48
    80006eca:	8082                	ret

0000000080006ecc <sys_write>:
{
    80006ecc:	7179                	addi	sp,sp,-48
    80006ece:	f406                	sd	ra,40(sp)
    80006ed0:	f022                	sd	s0,32(sp)
    80006ed2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006ed4:	fe840613          	addi	a2,s0,-24
    80006ed8:	4581                	li	a1,0
    80006eda:	4501                	li	a0,0
    80006edc:	00000097          	auipc	ra,0x0
    80006ee0:	d2a080e7          	jalr	-726(ra) # 80006c06 <argfd>
    return -1;
    80006ee4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006ee6:	04054163          	bltz	a0,80006f28 <sys_write+0x5c>
    80006eea:	fe440593          	addi	a1,s0,-28
    80006eee:	4509                	li	a0,2
    80006ef0:	ffffd097          	auipc	ra,0xffffd
    80006ef4:	540080e7          	jalr	1344(ra) # 80004430 <argint>
    return -1;
    80006ef8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006efa:	02054763          	bltz	a0,80006f28 <sys_write+0x5c>
    80006efe:	fd840593          	addi	a1,s0,-40
    80006f02:	4505                	li	a0,1
    80006f04:	ffffd097          	auipc	ra,0xffffd
    80006f08:	54e080e7          	jalr	1358(ra) # 80004452 <argaddr>
    return -1;
    80006f0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80006f0e:	00054d63          	bltz	a0,80006f28 <sys_write+0x5c>
  return filewrite(f, p, n);
    80006f12:	fe442603          	lw	a2,-28(s0)
    80006f16:	fd843583          	ld	a1,-40(s0)
    80006f1a:	fe843503          	ld	a0,-24(s0)
    80006f1e:	fffff097          	auipc	ra,0xfffff
    80006f22:	4fa080e7          	jalr	1274(ra) # 80006418 <filewrite>
    80006f26:	87aa                	mv	a5,a0
}
    80006f28:	853e                	mv	a0,a5
    80006f2a:	70a2                	ld	ra,40(sp)
    80006f2c:	7402                	ld	s0,32(sp)
    80006f2e:	6145                	addi	sp,sp,48
    80006f30:	8082                	ret

0000000080006f32 <sys_close>:
{
    80006f32:	1101                	addi	sp,sp,-32
    80006f34:	ec06                	sd	ra,24(sp)
    80006f36:	e822                	sd	s0,16(sp)
    80006f38:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80006f3a:	fe040613          	addi	a2,s0,-32
    80006f3e:	fec40593          	addi	a1,s0,-20
    80006f42:	4501                	li	a0,0
    80006f44:	00000097          	auipc	ra,0x0
    80006f48:	cc2080e7          	jalr	-830(ra) # 80006c06 <argfd>
    return -1;
    80006f4c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006f4e:	02054463          	bltz	a0,80006f76 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80006f52:	ffffb097          	auipc	ra,0xffffb
    80006f56:	a66080e7          	jalr	-1434(ra) # 800019b8 <myproc>
    80006f5a:	fec42783          	lw	a5,-20(s0)
    80006f5e:	07e9                	addi	a5,a5,26
    80006f60:	078e                	slli	a5,a5,0x3
    80006f62:	97aa                	add	a5,a5,a0
    80006f64:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80006f68:	fe043503          	ld	a0,-32(s0)
    80006f6c:	fffff097          	auipc	ra,0xfffff
    80006f70:	2b0080e7          	jalr	688(ra) # 8000621c <fileclose>
  return 0;
    80006f74:	4781                	li	a5,0
}
    80006f76:	853e                	mv	a0,a5
    80006f78:	60e2                	ld	ra,24(sp)
    80006f7a:	6442                	ld	s0,16(sp)
    80006f7c:	6105                	addi	sp,sp,32
    80006f7e:	8082                	ret

0000000080006f80 <sys_fstat>:
{
    80006f80:	1101                	addi	sp,sp,-32
    80006f82:	ec06                	sd	ra,24(sp)
    80006f84:	e822                	sd	s0,16(sp)
    80006f86:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80006f88:	fe840613          	addi	a2,s0,-24
    80006f8c:	4581                	li	a1,0
    80006f8e:	4501                	li	a0,0
    80006f90:	00000097          	auipc	ra,0x0
    80006f94:	c76080e7          	jalr	-906(ra) # 80006c06 <argfd>
    return -1;
    80006f98:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80006f9a:	02054563          	bltz	a0,80006fc4 <sys_fstat+0x44>
    80006f9e:	fe040593          	addi	a1,s0,-32
    80006fa2:	4505                	li	a0,1
    80006fa4:	ffffd097          	auipc	ra,0xffffd
    80006fa8:	4ae080e7          	jalr	1198(ra) # 80004452 <argaddr>
    return -1;
    80006fac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80006fae:	00054b63          	bltz	a0,80006fc4 <sys_fstat+0x44>
  return filestat(f, st);
    80006fb2:	fe043583          	ld	a1,-32(s0)
    80006fb6:	fe843503          	ld	a0,-24(s0)
    80006fba:	fffff097          	auipc	ra,0xfffff
    80006fbe:	32a080e7          	jalr	810(ra) # 800062e4 <filestat>
    80006fc2:	87aa                	mv	a5,a0
}
    80006fc4:	853e                	mv	a0,a5
    80006fc6:	60e2                	ld	ra,24(sp)
    80006fc8:	6442                	ld	s0,16(sp)
    80006fca:	6105                	addi	sp,sp,32
    80006fcc:	8082                	ret

0000000080006fce <sys_link>:
{
    80006fce:	7169                	addi	sp,sp,-304
    80006fd0:	f606                	sd	ra,296(sp)
    80006fd2:	f222                	sd	s0,288(sp)
    80006fd4:	ee26                	sd	s1,280(sp)
    80006fd6:	ea4a                	sd	s2,272(sp)
    80006fd8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006fda:	08000613          	li	a2,128
    80006fde:	ed040593          	addi	a1,s0,-304
    80006fe2:	4501                	li	a0,0
    80006fe4:	ffffd097          	auipc	ra,0xffffd
    80006fe8:	490080e7          	jalr	1168(ra) # 80004474 <argstr>
    return -1;
    80006fec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006fee:	10054e63          	bltz	a0,8000710a <sys_link+0x13c>
    80006ff2:	08000613          	li	a2,128
    80006ff6:	f5040593          	addi	a1,s0,-176
    80006ffa:	4505                	li	a0,1
    80006ffc:	ffffd097          	auipc	ra,0xffffd
    80007000:	478080e7          	jalr	1144(ra) # 80004474 <argstr>
    return -1;
    80007004:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007006:	10054263          	bltz	a0,8000710a <sys_link+0x13c>
  begin_op();
    8000700a:	fffff097          	auipc	ra,0xfffff
    8000700e:	d46080e7          	jalr	-698(ra) # 80005d50 <begin_op>
  if((ip = namei(old)) == 0){
    80007012:	ed040513          	addi	a0,s0,-304
    80007016:	fffff097          	auipc	ra,0xfffff
    8000701a:	b1e080e7          	jalr	-1250(ra) # 80005b34 <namei>
    8000701e:	84aa                	mv	s1,a0
    80007020:	c551                	beqz	a0,800070ac <sys_link+0xde>
  ilock(ip);
    80007022:	ffffe097          	auipc	ra,0xffffe
    80007026:	35c080e7          	jalr	860(ra) # 8000537e <ilock>
  if(ip->type == T_DIR){
    8000702a:	04449703          	lh	a4,68(s1)
    8000702e:	4785                	li	a5,1
    80007030:	08f70463          	beq	a4,a5,800070b8 <sys_link+0xea>
  ip->nlink++;
    80007034:	04a4d783          	lhu	a5,74(s1)
    80007038:	2785                	addiw	a5,a5,1
    8000703a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000703e:	8526                	mv	a0,s1
    80007040:	ffffe097          	auipc	ra,0xffffe
    80007044:	274080e7          	jalr	628(ra) # 800052b4 <iupdate>
  iunlock(ip);
    80007048:	8526                	mv	a0,s1
    8000704a:	ffffe097          	auipc	ra,0xffffe
    8000704e:	3f6080e7          	jalr	1014(ra) # 80005440 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80007052:	fd040593          	addi	a1,s0,-48
    80007056:	f5040513          	addi	a0,s0,-176
    8000705a:	fffff097          	auipc	ra,0xfffff
    8000705e:	af8080e7          	jalr	-1288(ra) # 80005b52 <nameiparent>
    80007062:	892a                	mv	s2,a0
    80007064:	c935                	beqz	a0,800070d8 <sys_link+0x10a>
  ilock(dp);
    80007066:	ffffe097          	auipc	ra,0xffffe
    8000706a:	318080e7          	jalr	792(ra) # 8000537e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000706e:	00092703          	lw	a4,0(s2)
    80007072:	409c                	lw	a5,0(s1)
    80007074:	04f71d63          	bne	a4,a5,800070ce <sys_link+0x100>
    80007078:	40d0                	lw	a2,4(s1)
    8000707a:	fd040593          	addi	a1,s0,-48
    8000707e:	854a                	mv	a0,s2
    80007080:	fffff097          	auipc	ra,0xfffff
    80007084:	9f2080e7          	jalr	-1550(ra) # 80005a72 <dirlink>
    80007088:	04054363          	bltz	a0,800070ce <sys_link+0x100>
  iunlockput(dp);
    8000708c:	854a                	mv	a0,s2
    8000708e:	ffffe097          	auipc	ra,0xffffe
    80007092:	552080e7          	jalr	1362(ra) # 800055e0 <iunlockput>
  iput(ip);
    80007096:	8526                	mv	a0,s1
    80007098:	ffffe097          	auipc	ra,0xffffe
    8000709c:	4a0080e7          	jalr	1184(ra) # 80005538 <iput>
  end_op();
    800070a0:	fffff097          	auipc	ra,0xfffff
    800070a4:	d30080e7          	jalr	-720(ra) # 80005dd0 <end_op>
  return 0;
    800070a8:	4781                	li	a5,0
    800070aa:	a085                	j	8000710a <sys_link+0x13c>
    end_op();
    800070ac:	fffff097          	auipc	ra,0xfffff
    800070b0:	d24080e7          	jalr	-732(ra) # 80005dd0 <end_op>
    return -1;
    800070b4:	57fd                	li	a5,-1
    800070b6:	a891                	j	8000710a <sys_link+0x13c>
    iunlockput(ip);
    800070b8:	8526                	mv	a0,s1
    800070ba:	ffffe097          	auipc	ra,0xffffe
    800070be:	526080e7          	jalr	1318(ra) # 800055e0 <iunlockput>
    end_op();
    800070c2:	fffff097          	auipc	ra,0xfffff
    800070c6:	d0e080e7          	jalr	-754(ra) # 80005dd0 <end_op>
    return -1;
    800070ca:	57fd                	li	a5,-1
    800070cc:	a83d                	j	8000710a <sys_link+0x13c>
    iunlockput(dp);
    800070ce:	854a                	mv	a0,s2
    800070d0:	ffffe097          	auipc	ra,0xffffe
    800070d4:	510080e7          	jalr	1296(ra) # 800055e0 <iunlockput>
  ilock(ip);
    800070d8:	8526                	mv	a0,s1
    800070da:	ffffe097          	auipc	ra,0xffffe
    800070de:	2a4080e7          	jalr	676(ra) # 8000537e <ilock>
  ip->nlink--;
    800070e2:	04a4d783          	lhu	a5,74(s1)
    800070e6:	37fd                	addiw	a5,a5,-1
    800070e8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800070ec:	8526                	mv	a0,s1
    800070ee:	ffffe097          	auipc	ra,0xffffe
    800070f2:	1c6080e7          	jalr	454(ra) # 800052b4 <iupdate>
  iunlockput(ip);
    800070f6:	8526                	mv	a0,s1
    800070f8:	ffffe097          	auipc	ra,0xffffe
    800070fc:	4e8080e7          	jalr	1256(ra) # 800055e0 <iunlockput>
  end_op();
    80007100:	fffff097          	auipc	ra,0xfffff
    80007104:	cd0080e7          	jalr	-816(ra) # 80005dd0 <end_op>
  return -1;
    80007108:	57fd                	li	a5,-1
}
    8000710a:	853e                	mv	a0,a5
    8000710c:	70b2                	ld	ra,296(sp)
    8000710e:	7412                	ld	s0,288(sp)
    80007110:	64f2                	ld	s1,280(sp)
    80007112:	6952                	ld	s2,272(sp)
    80007114:	6155                	addi	sp,sp,304
    80007116:	8082                	ret

0000000080007118 <sys_unlink>:
{
    80007118:	7151                	addi	sp,sp,-240
    8000711a:	f586                	sd	ra,232(sp)
    8000711c:	f1a2                	sd	s0,224(sp)
    8000711e:	eda6                	sd	s1,216(sp)
    80007120:	e9ca                	sd	s2,208(sp)
    80007122:	e5ce                	sd	s3,200(sp)
    80007124:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80007126:	08000613          	li	a2,128
    8000712a:	f3040593          	addi	a1,s0,-208
    8000712e:	4501                	li	a0,0
    80007130:	ffffd097          	auipc	ra,0xffffd
    80007134:	344080e7          	jalr	836(ra) # 80004474 <argstr>
    80007138:	18054163          	bltz	a0,800072ba <sys_unlink+0x1a2>
  begin_op();
    8000713c:	fffff097          	auipc	ra,0xfffff
    80007140:	c14080e7          	jalr	-1004(ra) # 80005d50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007144:	fb040593          	addi	a1,s0,-80
    80007148:	f3040513          	addi	a0,s0,-208
    8000714c:	fffff097          	auipc	ra,0xfffff
    80007150:	a06080e7          	jalr	-1530(ra) # 80005b52 <nameiparent>
    80007154:	84aa                	mv	s1,a0
    80007156:	c979                	beqz	a0,8000722c <sys_unlink+0x114>
  ilock(dp);
    80007158:	ffffe097          	auipc	ra,0xffffe
    8000715c:	226080e7          	jalr	550(ra) # 8000537e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007160:	00003597          	auipc	a1,0x3
    80007164:	96058593          	addi	a1,a1,-1696 # 80009ac0 <syscalls+0x360>
    80007168:	fb040513          	addi	a0,s0,-80
    8000716c:	ffffe097          	auipc	ra,0xffffe
    80007170:	6dc080e7          	jalr	1756(ra) # 80005848 <namecmp>
    80007174:	14050a63          	beqz	a0,800072c8 <sys_unlink+0x1b0>
    80007178:	00003597          	auipc	a1,0x3
    8000717c:	95058593          	addi	a1,a1,-1712 # 80009ac8 <syscalls+0x368>
    80007180:	fb040513          	addi	a0,s0,-80
    80007184:	ffffe097          	auipc	ra,0xffffe
    80007188:	6c4080e7          	jalr	1732(ra) # 80005848 <namecmp>
    8000718c:	12050e63          	beqz	a0,800072c8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80007190:	f2c40613          	addi	a2,s0,-212
    80007194:	fb040593          	addi	a1,s0,-80
    80007198:	8526                	mv	a0,s1
    8000719a:	ffffe097          	auipc	ra,0xffffe
    8000719e:	6c8080e7          	jalr	1736(ra) # 80005862 <dirlookup>
    800071a2:	892a                	mv	s2,a0
    800071a4:	12050263          	beqz	a0,800072c8 <sys_unlink+0x1b0>
  ilock(ip);
    800071a8:	ffffe097          	auipc	ra,0xffffe
    800071ac:	1d6080e7          	jalr	470(ra) # 8000537e <ilock>
  if(ip->nlink < 1)
    800071b0:	04a91783          	lh	a5,74(s2)
    800071b4:	08f05263          	blez	a5,80007238 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800071b8:	04491703          	lh	a4,68(s2)
    800071bc:	4785                	li	a5,1
    800071be:	08f70563          	beq	a4,a5,80007248 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800071c2:	4641                	li	a2,16
    800071c4:	4581                	li	a1,0
    800071c6:	fc040513          	addi	a0,s0,-64
    800071ca:	ffffa097          	auipc	ra,0xffffa
    800071ce:	b14080e7          	jalr	-1260(ra) # 80000cde <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800071d2:	4741                	li	a4,16
    800071d4:	f2c42683          	lw	a3,-212(s0)
    800071d8:	fc040613          	addi	a2,s0,-64
    800071dc:	4581                	li	a1,0
    800071de:	8526                	mv	a0,s1
    800071e0:	ffffe097          	auipc	ra,0xffffe
    800071e4:	54a080e7          	jalr	1354(ra) # 8000572a <writei>
    800071e8:	47c1                	li	a5,16
    800071ea:	0af51563          	bne	a0,a5,80007294 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800071ee:	04491703          	lh	a4,68(s2)
    800071f2:	4785                	li	a5,1
    800071f4:	0af70863          	beq	a4,a5,800072a4 <sys_unlink+0x18c>
  iunlockput(dp);
    800071f8:	8526                	mv	a0,s1
    800071fa:	ffffe097          	auipc	ra,0xffffe
    800071fe:	3e6080e7          	jalr	998(ra) # 800055e0 <iunlockput>
  ip->nlink--;
    80007202:	04a95783          	lhu	a5,74(s2)
    80007206:	37fd                	addiw	a5,a5,-1
    80007208:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000720c:	854a                	mv	a0,s2
    8000720e:	ffffe097          	auipc	ra,0xffffe
    80007212:	0a6080e7          	jalr	166(ra) # 800052b4 <iupdate>
  iunlockput(ip);
    80007216:	854a                	mv	a0,s2
    80007218:	ffffe097          	auipc	ra,0xffffe
    8000721c:	3c8080e7          	jalr	968(ra) # 800055e0 <iunlockput>
  end_op();
    80007220:	fffff097          	auipc	ra,0xfffff
    80007224:	bb0080e7          	jalr	-1104(ra) # 80005dd0 <end_op>
  return 0;
    80007228:	4501                	li	a0,0
    8000722a:	a84d                	j	800072dc <sys_unlink+0x1c4>
    end_op();
    8000722c:	fffff097          	auipc	ra,0xfffff
    80007230:	ba4080e7          	jalr	-1116(ra) # 80005dd0 <end_op>
    return -1;
    80007234:	557d                	li	a0,-1
    80007236:	a05d                	j	800072dc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80007238:	00003517          	auipc	a0,0x3
    8000723c:	8b850513          	addi	a0,a0,-1864 # 80009af0 <syscalls+0x390>
    80007240:	ffff9097          	auipc	ra,0xffff9
    80007244:	2fc080e7          	jalr	764(ra) # 8000053c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007248:	04c92703          	lw	a4,76(s2)
    8000724c:	02000793          	li	a5,32
    80007250:	f6e7f9e3          	bgeu	a5,a4,800071c2 <sys_unlink+0xaa>
    80007254:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007258:	4741                	li	a4,16
    8000725a:	86ce                	mv	a3,s3
    8000725c:	f1840613          	addi	a2,s0,-232
    80007260:	4581                	li	a1,0
    80007262:	854a                	mv	a0,s2
    80007264:	ffffe097          	auipc	ra,0xffffe
    80007268:	3ce080e7          	jalr	974(ra) # 80005632 <readi>
    8000726c:	47c1                	li	a5,16
    8000726e:	00f51b63          	bne	a0,a5,80007284 <sys_unlink+0x16c>
    if(de.inum != 0)
    80007272:	f1845783          	lhu	a5,-232(s0)
    80007276:	e7a1                	bnez	a5,800072be <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007278:	29c1                	addiw	s3,s3,16
    8000727a:	04c92783          	lw	a5,76(s2)
    8000727e:	fcf9ede3          	bltu	s3,a5,80007258 <sys_unlink+0x140>
    80007282:	b781                	j	800071c2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80007284:	00003517          	auipc	a0,0x3
    80007288:	88450513          	addi	a0,a0,-1916 # 80009b08 <syscalls+0x3a8>
    8000728c:	ffff9097          	auipc	ra,0xffff9
    80007290:	2b0080e7          	jalr	688(ra) # 8000053c <panic>
    panic("unlink: writei");
    80007294:	00003517          	auipc	a0,0x3
    80007298:	88c50513          	addi	a0,a0,-1908 # 80009b20 <syscalls+0x3c0>
    8000729c:	ffff9097          	auipc	ra,0xffff9
    800072a0:	2a0080e7          	jalr	672(ra) # 8000053c <panic>
    dp->nlink--;
    800072a4:	04a4d783          	lhu	a5,74(s1)
    800072a8:	37fd                	addiw	a5,a5,-1
    800072aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800072ae:	8526                	mv	a0,s1
    800072b0:	ffffe097          	auipc	ra,0xffffe
    800072b4:	004080e7          	jalr	4(ra) # 800052b4 <iupdate>
    800072b8:	b781                	j	800071f8 <sys_unlink+0xe0>
    return -1;
    800072ba:	557d                	li	a0,-1
    800072bc:	a005                	j	800072dc <sys_unlink+0x1c4>
    iunlockput(ip);
    800072be:	854a                	mv	a0,s2
    800072c0:	ffffe097          	auipc	ra,0xffffe
    800072c4:	320080e7          	jalr	800(ra) # 800055e0 <iunlockput>
  iunlockput(dp);
    800072c8:	8526                	mv	a0,s1
    800072ca:	ffffe097          	auipc	ra,0xffffe
    800072ce:	316080e7          	jalr	790(ra) # 800055e0 <iunlockput>
  end_op();
    800072d2:	fffff097          	auipc	ra,0xfffff
    800072d6:	afe080e7          	jalr	-1282(ra) # 80005dd0 <end_op>
  return -1;
    800072da:	557d                	li	a0,-1
}
    800072dc:	70ae                	ld	ra,232(sp)
    800072de:	740e                	ld	s0,224(sp)
    800072e0:	64ee                	ld	s1,216(sp)
    800072e2:	694e                	ld	s2,208(sp)
    800072e4:	69ae                	ld	s3,200(sp)
    800072e6:	616d                	addi	sp,sp,240
    800072e8:	8082                	ret

00000000800072ea <sys_open>:

uint64
sys_open(void)
{
    800072ea:	7131                	addi	sp,sp,-192
    800072ec:	fd06                	sd	ra,184(sp)
    800072ee:	f922                	sd	s0,176(sp)
    800072f0:	f526                	sd	s1,168(sp)
    800072f2:	f14a                	sd	s2,160(sp)
    800072f4:	ed4e                	sd	s3,152(sp)
    800072f6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800072f8:	08000613          	li	a2,128
    800072fc:	f5040593          	addi	a1,s0,-176
    80007300:	4501                	li	a0,0
    80007302:	ffffd097          	auipc	ra,0xffffd
    80007306:	172080e7          	jalr	370(ra) # 80004474 <argstr>
    return -1;
    8000730a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000730c:	0c054163          	bltz	a0,800073ce <sys_open+0xe4>
    80007310:	f4c40593          	addi	a1,s0,-180
    80007314:	4505                	li	a0,1
    80007316:	ffffd097          	auipc	ra,0xffffd
    8000731a:	11a080e7          	jalr	282(ra) # 80004430 <argint>
    8000731e:	0a054863          	bltz	a0,800073ce <sys_open+0xe4>

  begin_op();
    80007322:	fffff097          	auipc	ra,0xfffff
    80007326:	a2e080e7          	jalr	-1490(ra) # 80005d50 <begin_op>

  if(omode & O_CREATE){
    8000732a:	f4c42783          	lw	a5,-180(s0)
    8000732e:	2007f793          	andi	a5,a5,512
    80007332:	cbdd                	beqz	a5,800073e8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80007334:	4681                	li	a3,0
    80007336:	4601                	li	a2,0
    80007338:	4589                	li	a1,2
    8000733a:	f5040513          	addi	a0,s0,-176
    8000733e:	00000097          	auipc	ra,0x0
    80007342:	972080e7          	jalr	-1678(ra) # 80006cb0 <create>
    80007346:	892a                	mv	s2,a0
    if(ip == 0){
    80007348:	c959                	beqz	a0,800073de <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000734a:	04491703          	lh	a4,68(s2)
    8000734e:	478d                	li	a5,3
    80007350:	00f71763          	bne	a4,a5,8000735e <sys_open+0x74>
    80007354:	04695703          	lhu	a4,70(s2)
    80007358:	47a5                	li	a5,9
    8000735a:	0ce7ec63          	bltu	a5,a4,80007432 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000735e:	fffff097          	auipc	ra,0xfffff
    80007362:	e02080e7          	jalr	-510(ra) # 80006160 <filealloc>
    80007366:	89aa                	mv	s3,a0
    80007368:	10050263          	beqz	a0,8000746c <sys_open+0x182>
    8000736c:	00000097          	auipc	ra,0x0
    80007370:	902080e7          	jalr	-1790(ra) # 80006c6e <fdalloc>
    80007374:	84aa                	mv	s1,a0
    80007376:	0e054663          	bltz	a0,80007462 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000737a:	04491703          	lh	a4,68(s2)
    8000737e:	478d                	li	a5,3
    80007380:	0cf70463          	beq	a4,a5,80007448 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80007384:	4789                	li	a5,2
    80007386:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000738a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000738e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80007392:	f4c42783          	lw	a5,-180(s0)
    80007396:	0017c713          	xori	a4,a5,1
    8000739a:	8b05                	andi	a4,a4,1
    8000739c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800073a0:	0037f713          	andi	a4,a5,3
    800073a4:	00e03733          	snez	a4,a4
    800073a8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800073ac:	4007f793          	andi	a5,a5,1024
    800073b0:	c791                	beqz	a5,800073bc <sys_open+0xd2>
    800073b2:	04491703          	lh	a4,68(s2)
    800073b6:	4789                	li	a5,2
    800073b8:	08f70f63          	beq	a4,a5,80007456 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800073bc:	854a                	mv	a0,s2
    800073be:	ffffe097          	auipc	ra,0xffffe
    800073c2:	082080e7          	jalr	130(ra) # 80005440 <iunlock>
  end_op();
    800073c6:	fffff097          	auipc	ra,0xfffff
    800073ca:	a0a080e7          	jalr	-1526(ra) # 80005dd0 <end_op>

  return fd;
}
    800073ce:	8526                	mv	a0,s1
    800073d0:	70ea                	ld	ra,184(sp)
    800073d2:	744a                	ld	s0,176(sp)
    800073d4:	74aa                	ld	s1,168(sp)
    800073d6:	790a                	ld	s2,160(sp)
    800073d8:	69ea                	ld	s3,152(sp)
    800073da:	6129                	addi	sp,sp,192
    800073dc:	8082                	ret
      end_op();
    800073de:	fffff097          	auipc	ra,0xfffff
    800073e2:	9f2080e7          	jalr	-1550(ra) # 80005dd0 <end_op>
      return -1;
    800073e6:	b7e5                	j	800073ce <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800073e8:	f5040513          	addi	a0,s0,-176
    800073ec:	ffffe097          	auipc	ra,0xffffe
    800073f0:	748080e7          	jalr	1864(ra) # 80005b34 <namei>
    800073f4:	892a                	mv	s2,a0
    800073f6:	c905                	beqz	a0,80007426 <sys_open+0x13c>
    ilock(ip);
    800073f8:	ffffe097          	auipc	ra,0xffffe
    800073fc:	f86080e7          	jalr	-122(ra) # 8000537e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80007400:	04491703          	lh	a4,68(s2)
    80007404:	4785                	li	a5,1
    80007406:	f4f712e3          	bne	a4,a5,8000734a <sys_open+0x60>
    8000740a:	f4c42783          	lw	a5,-180(s0)
    8000740e:	dba1                	beqz	a5,8000735e <sys_open+0x74>
      iunlockput(ip);
    80007410:	854a                	mv	a0,s2
    80007412:	ffffe097          	auipc	ra,0xffffe
    80007416:	1ce080e7          	jalr	462(ra) # 800055e0 <iunlockput>
      end_op();
    8000741a:	fffff097          	auipc	ra,0xfffff
    8000741e:	9b6080e7          	jalr	-1610(ra) # 80005dd0 <end_op>
      return -1;
    80007422:	54fd                	li	s1,-1
    80007424:	b76d                	j	800073ce <sys_open+0xe4>
      end_op();
    80007426:	fffff097          	auipc	ra,0xfffff
    8000742a:	9aa080e7          	jalr	-1622(ra) # 80005dd0 <end_op>
      return -1;
    8000742e:	54fd                	li	s1,-1
    80007430:	bf79                	j	800073ce <sys_open+0xe4>
    iunlockput(ip);
    80007432:	854a                	mv	a0,s2
    80007434:	ffffe097          	auipc	ra,0xffffe
    80007438:	1ac080e7          	jalr	428(ra) # 800055e0 <iunlockput>
    end_op();
    8000743c:	fffff097          	auipc	ra,0xfffff
    80007440:	994080e7          	jalr	-1644(ra) # 80005dd0 <end_op>
    return -1;
    80007444:	54fd                	li	s1,-1
    80007446:	b761                	j	800073ce <sys_open+0xe4>
    f->type = FD_DEVICE;
    80007448:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000744c:	04691783          	lh	a5,70(s2)
    80007450:	02f99223          	sh	a5,36(s3)
    80007454:	bf2d                	j	8000738e <sys_open+0xa4>
    itrunc(ip);
    80007456:	854a                	mv	a0,s2
    80007458:	ffffe097          	auipc	ra,0xffffe
    8000745c:	034080e7          	jalr	52(ra) # 8000548c <itrunc>
    80007460:	bfb1                	j	800073bc <sys_open+0xd2>
      fileclose(f);
    80007462:	854e                	mv	a0,s3
    80007464:	fffff097          	auipc	ra,0xfffff
    80007468:	db8080e7          	jalr	-584(ra) # 8000621c <fileclose>
    iunlockput(ip);
    8000746c:	854a                	mv	a0,s2
    8000746e:	ffffe097          	auipc	ra,0xffffe
    80007472:	172080e7          	jalr	370(ra) # 800055e0 <iunlockput>
    end_op();
    80007476:	fffff097          	auipc	ra,0xfffff
    8000747a:	95a080e7          	jalr	-1702(ra) # 80005dd0 <end_op>
    return -1;
    8000747e:	54fd                	li	s1,-1
    80007480:	b7b9                	j	800073ce <sys_open+0xe4>

0000000080007482 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80007482:	7175                	addi	sp,sp,-144
    80007484:	e506                	sd	ra,136(sp)
    80007486:	e122                	sd	s0,128(sp)
    80007488:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000748a:	fffff097          	auipc	ra,0xfffff
    8000748e:	8c6080e7          	jalr	-1850(ra) # 80005d50 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80007492:	08000613          	li	a2,128
    80007496:	f7040593          	addi	a1,s0,-144
    8000749a:	4501                	li	a0,0
    8000749c:	ffffd097          	auipc	ra,0xffffd
    800074a0:	fd8080e7          	jalr	-40(ra) # 80004474 <argstr>
    800074a4:	02054963          	bltz	a0,800074d6 <sys_mkdir+0x54>
    800074a8:	4681                	li	a3,0
    800074aa:	4601                	li	a2,0
    800074ac:	4585                	li	a1,1
    800074ae:	f7040513          	addi	a0,s0,-144
    800074b2:	fffff097          	auipc	ra,0xfffff
    800074b6:	7fe080e7          	jalr	2046(ra) # 80006cb0 <create>
    800074ba:	cd11                	beqz	a0,800074d6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800074bc:	ffffe097          	auipc	ra,0xffffe
    800074c0:	124080e7          	jalr	292(ra) # 800055e0 <iunlockput>
  end_op();
    800074c4:	fffff097          	auipc	ra,0xfffff
    800074c8:	90c080e7          	jalr	-1780(ra) # 80005dd0 <end_op>
  return 0;
    800074cc:	4501                	li	a0,0
}
    800074ce:	60aa                	ld	ra,136(sp)
    800074d0:	640a                	ld	s0,128(sp)
    800074d2:	6149                	addi	sp,sp,144
    800074d4:	8082                	ret
    end_op();
    800074d6:	fffff097          	auipc	ra,0xfffff
    800074da:	8fa080e7          	jalr	-1798(ra) # 80005dd0 <end_op>
    return -1;
    800074de:	557d                	li	a0,-1
    800074e0:	b7fd                	j	800074ce <sys_mkdir+0x4c>

00000000800074e2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800074e2:	7135                	addi	sp,sp,-160
    800074e4:	ed06                	sd	ra,152(sp)
    800074e6:	e922                	sd	s0,144(sp)
    800074e8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800074ea:	fffff097          	auipc	ra,0xfffff
    800074ee:	866080e7          	jalr	-1946(ra) # 80005d50 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800074f2:	08000613          	li	a2,128
    800074f6:	f7040593          	addi	a1,s0,-144
    800074fa:	4501                	li	a0,0
    800074fc:	ffffd097          	auipc	ra,0xffffd
    80007500:	f78080e7          	jalr	-136(ra) # 80004474 <argstr>
    80007504:	04054a63          	bltz	a0,80007558 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80007508:	f6c40593          	addi	a1,s0,-148
    8000750c:	4505                	li	a0,1
    8000750e:	ffffd097          	auipc	ra,0xffffd
    80007512:	f22080e7          	jalr	-222(ra) # 80004430 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80007516:	04054163          	bltz	a0,80007558 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000751a:	f6840593          	addi	a1,s0,-152
    8000751e:	4509                	li	a0,2
    80007520:	ffffd097          	auipc	ra,0xffffd
    80007524:	f10080e7          	jalr	-240(ra) # 80004430 <argint>
     argint(1, &major) < 0 ||
    80007528:	02054863          	bltz	a0,80007558 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000752c:	f6841683          	lh	a3,-152(s0)
    80007530:	f6c41603          	lh	a2,-148(s0)
    80007534:	458d                	li	a1,3
    80007536:	f7040513          	addi	a0,s0,-144
    8000753a:	fffff097          	auipc	ra,0xfffff
    8000753e:	776080e7          	jalr	1910(ra) # 80006cb0 <create>
     argint(2, &minor) < 0 ||
    80007542:	c919                	beqz	a0,80007558 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007544:	ffffe097          	auipc	ra,0xffffe
    80007548:	09c080e7          	jalr	156(ra) # 800055e0 <iunlockput>
  end_op();
    8000754c:	fffff097          	auipc	ra,0xfffff
    80007550:	884080e7          	jalr	-1916(ra) # 80005dd0 <end_op>
  return 0;
    80007554:	4501                	li	a0,0
    80007556:	a031                	j	80007562 <sys_mknod+0x80>
    end_op();
    80007558:	fffff097          	auipc	ra,0xfffff
    8000755c:	878080e7          	jalr	-1928(ra) # 80005dd0 <end_op>
    return -1;
    80007560:	557d                	li	a0,-1
}
    80007562:	60ea                	ld	ra,152(sp)
    80007564:	644a                	ld	s0,144(sp)
    80007566:	610d                	addi	sp,sp,160
    80007568:	8082                	ret

000000008000756a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000756a:	7135                	addi	sp,sp,-160
    8000756c:	ed06                	sd	ra,152(sp)
    8000756e:	e922                	sd	s0,144(sp)
    80007570:	e526                	sd	s1,136(sp)
    80007572:	e14a                	sd	s2,128(sp)
    80007574:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007576:	ffffa097          	auipc	ra,0xffffa
    8000757a:	442080e7          	jalr	1090(ra) # 800019b8 <myproc>
    8000757e:	892a                	mv	s2,a0
  
  begin_op();
    80007580:	ffffe097          	auipc	ra,0xffffe
    80007584:	7d0080e7          	jalr	2000(ra) # 80005d50 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007588:	08000613          	li	a2,128
    8000758c:	f6040593          	addi	a1,s0,-160
    80007590:	4501                	li	a0,0
    80007592:	ffffd097          	auipc	ra,0xffffd
    80007596:	ee2080e7          	jalr	-286(ra) # 80004474 <argstr>
    8000759a:	04054b63          	bltz	a0,800075f0 <sys_chdir+0x86>
    8000759e:	f6040513          	addi	a0,s0,-160
    800075a2:	ffffe097          	auipc	ra,0xffffe
    800075a6:	592080e7          	jalr	1426(ra) # 80005b34 <namei>
    800075aa:	84aa                	mv	s1,a0
    800075ac:	c131                	beqz	a0,800075f0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800075ae:	ffffe097          	auipc	ra,0xffffe
    800075b2:	dd0080e7          	jalr	-560(ra) # 8000537e <ilock>
  if(ip->type != T_DIR){
    800075b6:	04449703          	lh	a4,68(s1)
    800075ba:	4785                	li	a5,1
    800075bc:	04f71063          	bne	a4,a5,800075fc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800075c0:	8526                	mv	a0,s1
    800075c2:	ffffe097          	auipc	ra,0xffffe
    800075c6:	e7e080e7          	jalr	-386(ra) # 80005440 <iunlock>
  iput(p->cwd);
    800075ca:	15893503          	ld	a0,344(s2)
    800075ce:	ffffe097          	auipc	ra,0xffffe
    800075d2:	f6a080e7          	jalr	-150(ra) # 80005538 <iput>
  end_op();
    800075d6:	ffffe097          	auipc	ra,0xffffe
    800075da:	7fa080e7          	jalr	2042(ra) # 80005dd0 <end_op>
  p->cwd = ip;
    800075de:	14993c23          	sd	s1,344(s2)
  return 0;
    800075e2:	4501                	li	a0,0
}
    800075e4:	60ea                	ld	ra,152(sp)
    800075e6:	644a                	ld	s0,144(sp)
    800075e8:	64aa                	ld	s1,136(sp)
    800075ea:	690a                	ld	s2,128(sp)
    800075ec:	610d                	addi	sp,sp,160
    800075ee:	8082                	ret
    end_op();
    800075f0:	ffffe097          	auipc	ra,0xffffe
    800075f4:	7e0080e7          	jalr	2016(ra) # 80005dd0 <end_op>
    return -1;
    800075f8:	557d                	li	a0,-1
    800075fa:	b7ed                	j	800075e4 <sys_chdir+0x7a>
    iunlockput(ip);
    800075fc:	8526                	mv	a0,s1
    800075fe:	ffffe097          	auipc	ra,0xffffe
    80007602:	fe2080e7          	jalr	-30(ra) # 800055e0 <iunlockput>
    end_op();
    80007606:	ffffe097          	auipc	ra,0xffffe
    8000760a:	7ca080e7          	jalr	1994(ra) # 80005dd0 <end_op>
    return -1;
    8000760e:	557d                	li	a0,-1
    80007610:	bfd1                	j	800075e4 <sys_chdir+0x7a>

0000000080007612 <sys_exec>:

uint64
sys_exec(void)
{
    80007612:	7145                	addi	sp,sp,-464
    80007614:	e786                	sd	ra,456(sp)
    80007616:	e3a2                	sd	s0,448(sp)
    80007618:	ff26                	sd	s1,440(sp)
    8000761a:	fb4a                	sd	s2,432(sp)
    8000761c:	f74e                	sd	s3,424(sp)
    8000761e:	f352                	sd	s4,416(sp)
    80007620:	ef56                	sd	s5,408(sp)
    80007622:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007624:	08000613          	li	a2,128
    80007628:	f4040593          	addi	a1,s0,-192
    8000762c:	4501                	li	a0,0
    8000762e:	ffffd097          	auipc	ra,0xffffd
    80007632:	e46080e7          	jalr	-442(ra) # 80004474 <argstr>
    return -1;
    80007636:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80007638:	0c054a63          	bltz	a0,8000770c <sys_exec+0xfa>
    8000763c:	e3840593          	addi	a1,s0,-456
    80007640:	4505                	li	a0,1
    80007642:	ffffd097          	auipc	ra,0xffffd
    80007646:	e10080e7          	jalr	-496(ra) # 80004452 <argaddr>
    8000764a:	0c054163          	bltz	a0,8000770c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000764e:	10000613          	li	a2,256
    80007652:	4581                	li	a1,0
    80007654:	e4040513          	addi	a0,s0,-448
    80007658:	ffff9097          	auipc	ra,0xffff9
    8000765c:	686080e7          	jalr	1670(ra) # 80000cde <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80007660:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80007664:	89a6                	mv	s3,s1
    80007666:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80007668:	02000a13          	li	s4,32
    8000766c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007670:	00391513          	slli	a0,s2,0x3
    80007674:	e3040593          	addi	a1,s0,-464
    80007678:	e3843783          	ld	a5,-456(s0)
    8000767c:	953e                	add	a0,a0,a5
    8000767e:	ffffd097          	auipc	ra,0xffffd
    80007682:	d18080e7          	jalr	-744(ra) # 80004396 <fetchaddr>
    80007686:	02054a63          	bltz	a0,800076ba <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000768a:	e3043783          	ld	a5,-464(s0)
    8000768e:	c3b9                	beqz	a5,800076d4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007690:	ffff9097          	auipc	ra,0xffff9
    80007694:	462080e7          	jalr	1122(ra) # 80000af2 <kalloc>
    80007698:	85aa                	mv	a1,a0
    8000769a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000769e:	cd11                	beqz	a0,800076ba <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800076a0:	6605                	lui	a2,0x1
    800076a2:	e3043503          	ld	a0,-464(s0)
    800076a6:	ffffd097          	auipc	ra,0xffffd
    800076aa:	d42080e7          	jalr	-702(ra) # 800043e8 <fetchstr>
    800076ae:	00054663          	bltz	a0,800076ba <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800076b2:	0905                	addi	s2,s2,1
    800076b4:	09a1                	addi	s3,s3,8
    800076b6:	fb491be3          	bne	s2,s4,8000766c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800076ba:	10048913          	addi	s2,s1,256
    800076be:	6088                	ld	a0,0(s1)
    800076c0:	c529                	beqz	a0,8000770a <sys_exec+0xf8>
    kfree(argv[i]);
    800076c2:	ffff9097          	auipc	ra,0xffff9
    800076c6:	334080e7          	jalr	820(ra) # 800009f6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800076ca:	04a1                	addi	s1,s1,8
    800076cc:	ff2499e3          	bne	s1,s2,800076be <sys_exec+0xac>
  return -1;
    800076d0:	597d                	li	s2,-1
    800076d2:	a82d                	j	8000770c <sys_exec+0xfa>
      argv[i] = 0;
    800076d4:	0a8e                	slli	s5,s5,0x3
    800076d6:	fc040793          	addi	a5,s0,-64
    800076da:	9abe                	add	s5,s5,a5
    800076dc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800076e0:	e4040593          	addi	a1,s0,-448
    800076e4:	f4040513          	addi	a0,s0,-192
    800076e8:	fffff097          	auipc	ra,0xfffff
    800076ec:	194080e7          	jalr	404(ra) # 8000687c <exec>
    800076f0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800076f2:	10048993          	addi	s3,s1,256
    800076f6:	6088                	ld	a0,0(s1)
    800076f8:	c911                	beqz	a0,8000770c <sys_exec+0xfa>
    kfree(argv[i]);
    800076fa:	ffff9097          	auipc	ra,0xffff9
    800076fe:	2fc080e7          	jalr	764(ra) # 800009f6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007702:	04a1                	addi	s1,s1,8
    80007704:	ff3499e3          	bne	s1,s3,800076f6 <sys_exec+0xe4>
    80007708:	a011                	j	8000770c <sys_exec+0xfa>
  return -1;
    8000770a:	597d                	li	s2,-1
}
    8000770c:	854a                	mv	a0,s2
    8000770e:	60be                	ld	ra,456(sp)
    80007710:	641e                	ld	s0,448(sp)
    80007712:	74fa                	ld	s1,440(sp)
    80007714:	795a                	ld	s2,432(sp)
    80007716:	79ba                	ld	s3,424(sp)
    80007718:	7a1a                	ld	s4,416(sp)
    8000771a:	6afa                	ld	s5,408(sp)
    8000771c:	6179                	addi	sp,sp,464
    8000771e:	8082                	ret

0000000080007720 <sys_pipe>:

uint64
sys_pipe(void)
{
    80007720:	7139                	addi	sp,sp,-64
    80007722:	fc06                	sd	ra,56(sp)
    80007724:	f822                	sd	s0,48(sp)
    80007726:	f426                	sd	s1,40(sp)
    80007728:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000772a:	ffffa097          	auipc	ra,0xffffa
    8000772e:	28e080e7          	jalr	654(ra) # 800019b8 <myproc>
    80007732:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80007734:	fd840593          	addi	a1,s0,-40
    80007738:	4501                	li	a0,0
    8000773a:	ffffd097          	auipc	ra,0xffffd
    8000773e:	d18080e7          	jalr	-744(ra) # 80004452 <argaddr>
    return -1;
    80007742:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80007744:	0e054063          	bltz	a0,80007824 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80007748:	fc840593          	addi	a1,s0,-56
    8000774c:	fd040513          	addi	a0,s0,-48
    80007750:	fffff097          	auipc	ra,0xfffff
    80007754:	dfc080e7          	jalr	-516(ra) # 8000654c <pipealloc>
    return -1;
    80007758:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000775a:	0c054563          	bltz	a0,80007824 <sys_pipe+0x104>
  fd0 = -1;
    8000775e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007762:	fd043503          	ld	a0,-48(s0)
    80007766:	fffff097          	auipc	ra,0xfffff
    8000776a:	508080e7          	jalr	1288(ra) # 80006c6e <fdalloc>
    8000776e:	fca42223          	sw	a0,-60(s0)
    80007772:	08054c63          	bltz	a0,8000780a <sys_pipe+0xea>
    80007776:	fc843503          	ld	a0,-56(s0)
    8000777a:	fffff097          	auipc	ra,0xfffff
    8000777e:	4f4080e7          	jalr	1268(ra) # 80006c6e <fdalloc>
    80007782:	fca42023          	sw	a0,-64(s0)
    80007786:	06054863          	bltz	a0,800077f6 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000778a:	4691                	li	a3,4
    8000778c:	fc440613          	addi	a2,s0,-60
    80007790:	fd843583          	ld	a1,-40(s0)
    80007794:	6ca8                	ld	a0,88(s1)
    80007796:	ffffa097          	auipc	ra,0xffffa
    8000779a:	ee4080e7          	jalr	-284(ra) # 8000167a <copyout>
    8000779e:	02054063          	bltz	a0,800077be <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800077a2:	4691                	li	a3,4
    800077a4:	fc040613          	addi	a2,s0,-64
    800077a8:	fd843583          	ld	a1,-40(s0)
    800077ac:	0591                	addi	a1,a1,4
    800077ae:	6ca8                	ld	a0,88(s1)
    800077b0:	ffffa097          	auipc	ra,0xffffa
    800077b4:	eca080e7          	jalr	-310(ra) # 8000167a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800077b8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800077ba:	06055563          	bgez	a0,80007824 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800077be:	fc442783          	lw	a5,-60(s0)
    800077c2:	07e9                	addi	a5,a5,26
    800077c4:	078e                	slli	a5,a5,0x3
    800077c6:	97a6                	add	a5,a5,s1
    800077c8:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800077cc:	fc042503          	lw	a0,-64(s0)
    800077d0:	0569                	addi	a0,a0,26
    800077d2:	050e                	slli	a0,a0,0x3
    800077d4:	9526                	add	a0,a0,s1
    800077d6:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800077da:	fd043503          	ld	a0,-48(s0)
    800077de:	fffff097          	auipc	ra,0xfffff
    800077e2:	a3e080e7          	jalr	-1474(ra) # 8000621c <fileclose>
    fileclose(wf);
    800077e6:	fc843503          	ld	a0,-56(s0)
    800077ea:	fffff097          	auipc	ra,0xfffff
    800077ee:	a32080e7          	jalr	-1486(ra) # 8000621c <fileclose>
    return -1;
    800077f2:	57fd                	li	a5,-1
    800077f4:	a805                	j	80007824 <sys_pipe+0x104>
    if(fd0 >= 0)
    800077f6:	fc442783          	lw	a5,-60(s0)
    800077fa:	0007c863          	bltz	a5,8000780a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800077fe:	01a78513          	addi	a0,a5,26
    80007802:	050e                	slli	a0,a0,0x3
    80007804:	9526                	add	a0,a0,s1
    80007806:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000780a:	fd043503          	ld	a0,-48(s0)
    8000780e:	fffff097          	auipc	ra,0xfffff
    80007812:	a0e080e7          	jalr	-1522(ra) # 8000621c <fileclose>
    fileclose(wf);
    80007816:	fc843503          	ld	a0,-56(s0)
    8000781a:	fffff097          	auipc	ra,0xfffff
    8000781e:	a02080e7          	jalr	-1534(ra) # 8000621c <fileclose>
    return -1;
    80007822:	57fd                	li	a5,-1
}
    80007824:	853e                	mv	a0,a5
    80007826:	70e2                	ld	ra,56(sp)
    80007828:	7442                	ld	s0,48(sp)
    8000782a:	74a2                	ld	s1,40(sp)
    8000782c:	6121                	addi	sp,sp,64
    8000782e:	8082                	ret

0000000080007830 <kernelvec>:
    80007830:	7111                	addi	sp,sp,-256
    80007832:	e006                	sd	ra,0(sp)
    80007834:	e40a                	sd	sp,8(sp)
    80007836:	e80e                	sd	gp,16(sp)
    80007838:	ec12                	sd	tp,24(sp)
    8000783a:	f016                	sd	t0,32(sp)
    8000783c:	f41a                	sd	t1,40(sp)
    8000783e:	f81e                	sd	t2,48(sp)
    80007840:	fc22                	sd	s0,56(sp)
    80007842:	e0a6                	sd	s1,64(sp)
    80007844:	e4aa                	sd	a0,72(sp)
    80007846:	e8ae                	sd	a1,80(sp)
    80007848:	ecb2                	sd	a2,88(sp)
    8000784a:	f0b6                	sd	a3,96(sp)
    8000784c:	f4ba                	sd	a4,104(sp)
    8000784e:	f8be                	sd	a5,112(sp)
    80007850:	fcc2                	sd	a6,120(sp)
    80007852:	e146                	sd	a7,128(sp)
    80007854:	e54a                	sd	s2,136(sp)
    80007856:	e94e                	sd	s3,144(sp)
    80007858:	ed52                	sd	s4,152(sp)
    8000785a:	f156                	sd	s5,160(sp)
    8000785c:	f55a                	sd	s6,168(sp)
    8000785e:	f95e                	sd	s7,176(sp)
    80007860:	fd62                	sd	s8,184(sp)
    80007862:	e1e6                	sd	s9,192(sp)
    80007864:	e5ea                	sd	s10,200(sp)
    80007866:	e9ee                	sd	s11,208(sp)
    80007868:	edf2                	sd	t3,216(sp)
    8000786a:	f1f6                	sd	t4,224(sp)
    8000786c:	f5fa                	sd	t5,232(sp)
    8000786e:	f9fe                	sd	t6,240(sp)
    80007870:	9e5fc0ef          	jal	ra,80004254 <kerneltrap>
    80007874:	6082                	ld	ra,0(sp)
    80007876:	6122                	ld	sp,8(sp)
    80007878:	61c2                	ld	gp,16(sp)
    8000787a:	7282                	ld	t0,32(sp)
    8000787c:	7322                	ld	t1,40(sp)
    8000787e:	73c2                	ld	t2,48(sp)
    80007880:	7462                	ld	s0,56(sp)
    80007882:	6486                	ld	s1,64(sp)
    80007884:	6526                	ld	a0,72(sp)
    80007886:	65c6                	ld	a1,80(sp)
    80007888:	6666                	ld	a2,88(sp)
    8000788a:	7686                	ld	a3,96(sp)
    8000788c:	7726                	ld	a4,104(sp)
    8000788e:	77c6                	ld	a5,112(sp)
    80007890:	7866                	ld	a6,120(sp)
    80007892:	688a                	ld	a7,128(sp)
    80007894:	692a                	ld	s2,136(sp)
    80007896:	69ca                	ld	s3,144(sp)
    80007898:	6a6a                	ld	s4,152(sp)
    8000789a:	7a8a                	ld	s5,160(sp)
    8000789c:	7b2a                	ld	s6,168(sp)
    8000789e:	7bca                	ld	s7,176(sp)
    800078a0:	7c6a                	ld	s8,184(sp)
    800078a2:	6c8e                	ld	s9,192(sp)
    800078a4:	6d2e                	ld	s10,200(sp)
    800078a6:	6dce                	ld	s11,208(sp)
    800078a8:	6e6e                	ld	t3,216(sp)
    800078aa:	7e8e                	ld	t4,224(sp)
    800078ac:	7f2e                	ld	t5,232(sp)
    800078ae:	7fce                	ld	t6,240(sp)
    800078b0:	6111                	addi	sp,sp,256
    800078b2:	10200073          	sret
    800078b6:	00000013          	nop
    800078ba:	00000013          	nop
    800078be:	0001                	nop

00000000800078c0 <timervec>:
    800078c0:	34051573          	csrrw	a0,mscratch,a0
    800078c4:	e10c                	sd	a1,0(a0)
    800078c6:	e510                	sd	a2,8(a0)
    800078c8:	e914                	sd	a3,16(a0)
    800078ca:	6d0c                	ld	a1,24(a0)
    800078cc:	7110                	ld	a2,32(a0)
    800078ce:	6194                	ld	a3,0(a1)
    800078d0:	96b2                	add	a3,a3,a2
    800078d2:	e194                	sd	a3,0(a1)
    800078d4:	4589                	li	a1,2
    800078d6:	14459073          	csrw	sip,a1
    800078da:	6914                	ld	a3,16(a0)
    800078dc:	6510                	ld	a2,8(a0)
    800078de:	610c                	ld	a1,0(a0)
    800078e0:	34051573          	csrrw	a0,mscratch,a0
    800078e4:	30200073          	mret
	...

00000000800078ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800078ea:	1141                	addi	sp,sp,-16
    800078ec:	e422                	sd	s0,8(sp)
    800078ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800078f0:	0c0007b7          	lui	a5,0xc000
    800078f4:	4705                	li	a4,1
    800078f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800078f8:	c3d8                	sw	a4,4(a5)
}
    800078fa:	6422                	ld	s0,8(sp)
    800078fc:	0141                	addi	sp,sp,16
    800078fe:	8082                	ret

0000000080007900 <plicinithart>:

void
plicinithart(void)
{
    80007900:	1141                	addi	sp,sp,-16
    80007902:	e406                	sd	ra,8(sp)
    80007904:	e022                	sd	s0,0(sp)
    80007906:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80007908:	ffffa097          	auipc	ra,0xffffa
    8000790c:	084080e7          	jalr	132(ra) # 8000198c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80007910:	0085171b          	slliw	a4,a0,0x8
    80007914:	0c0027b7          	lui	a5,0xc002
    80007918:	97ba                	add	a5,a5,a4
    8000791a:	40200713          	li	a4,1026
    8000791e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007922:	00d5151b          	slliw	a0,a0,0xd
    80007926:	0c2017b7          	lui	a5,0xc201
    8000792a:	953e                	add	a0,a0,a5
    8000792c:	00052023          	sw	zero,0(a0)
}
    80007930:	60a2                	ld	ra,8(sp)
    80007932:	6402                	ld	s0,0(sp)
    80007934:	0141                	addi	sp,sp,16
    80007936:	8082                	ret

0000000080007938 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007938:	1141                	addi	sp,sp,-16
    8000793a:	e406                	sd	ra,8(sp)
    8000793c:	e022                	sd	s0,0(sp)
    8000793e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80007940:	ffffa097          	auipc	ra,0xffffa
    80007944:	04c080e7          	jalr	76(ra) # 8000198c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80007948:	00d5179b          	slliw	a5,a0,0xd
    8000794c:	0c201537          	lui	a0,0xc201
    80007950:	953e                	add	a0,a0,a5
  return irq;
}
    80007952:	4148                	lw	a0,4(a0)
    80007954:	60a2                	ld	ra,8(sp)
    80007956:	6402                	ld	s0,0(sp)
    80007958:	0141                	addi	sp,sp,16
    8000795a:	8082                	ret

000000008000795c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000795c:	1101                	addi	sp,sp,-32
    8000795e:	ec06                	sd	ra,24(sp)
    80007960:	e822                	sd	s0,16(sp)
    80007962:	e426                	sd	s1,8(sp)
    80007964:	1000                	addi	s0,sp,32
    80007966:	84aa                	mv	s1,a0
  int hart = cpuid();
    80007968:	ffffa097          	auipc	ra,0xffffa
    8000796c:	024080e7          	jalr	36(ra) # 8000198c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80007970:	00d5151b          	slliw	a0,a0,0xd
    80007974:	0c2017b7          	lui	a5,0xc201
    80007978:	97aa                	add	a5,a5,a0
    8000797a:	c3c4                	sw	s1,4(a5)
}
    8000797c:	60e2                	ld	ra,24(sp)
    8000797e:	6442                	ld	s0,16(sp)
    80007980:	64a2                	ld	s1,8(sp)
    80007982:	6105                	addi	sp,sp,32
    80007984:	8082                	ret

0000000080007986 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80007986:	1141                	addi	sp,sp,-16
    80007988:	e406                	sd	ra,8(sp)
    8000798a:	e022                	sd	s0,0(sp)
    8000798c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000798e:	479d                	li	a5,7
    80007990:	06a7c963          	blt	a5,a0,80007a02 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80007994:	0001e797          	auipc	a5,0x1e
    80007998:	66c78793          	addi	a5,a5,1644 # 80026000 <disk>
    8000799c:	00a78733          	add	a4,a5,a0
    800079a0:	6789                	lui	a5,0x2
    800079a2:	97ba                	add	a5,a5,a4
    800079a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800079a8:	e7ad                	bnez	a5,80007a12 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800079aa:	00451793          	slli	a5,a0,0x4
    800079ae:	00020717          	auipc	a4,0x20
    800079b2:	65270713          	addi	a4,a4,1618 # 80028000 <disk+0x2000>
    800079b6:	6314                	ld	a3,0(a4)
    800079b8:	96be                	add	a3,a3,a5
    800079ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800079be:	6314                	ld	a3,0(a4)
    800079c0:	96be                	add	a3,a3,a5
    800079c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800079c6:	6314                	ld	a3,0(a4)
    800079c8:	96be                	add	a3,a3,a5
    800079ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800079ce:	6318                	ld	a4,0(a4)
    800079d0:	97ba                	add	a5,a5,a4
    800079d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800079d6:	0001e797          	auipc	a5,0x1e
    800079da:	62a78793          	addi	a5,a5,1578 # 80026000 <disk>
    800079de:	97aa                	add	a5,a5,a0
    800079e0:	6509                	lui	a0,0x2
    800079e2:	953e                	add	a0,a0,a5
    800079e4:	4785                	li	a5,1
    800079e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800079ea:	00020517          	auipc	a0,0x20
    800079ee:	62e50513          	addi	a0,a0,1582 # 80028018 <disk+0x2018>
    800079f2:	ffffb097          	auipc	ra,0xffffb
    800079f6:	16e080e7          	jalr	366(ra) # 80002b60 <wakeup>
}
    800079fa:	60a2                	ld	ra,8(sp)
    800079fc:	6402                	ld	s0,0(sp)
    800079fe:	0141                	addi	sp,sp,16
    80007a00:	8082                	ret
    panic("free_desc 1");
    80007a02:	00002517          	auipc	a0,0x2
    80007a06:	12e50513          	addi	a0,a0,302 # 80009b30 <syscalls+0x3d0>
    80007a0a:	ffff9097          	auipc	ra,0xffff9
    80007a0e:	b32080e7          	jalr	-1230(ra) # 8000053c <panic>
    panic("free_desc 2");
    80007a12:	00002517          	auipc	a0,0x2
    80007a16:	12e50513          	addi	a0,a0,302 # 80009b40 <syscalls+0x3e0>
    80007a1a:	ffff9097          	auipc	ra,0xffff9
    80007a1e:	b22080e7          	jalr	-1246(ra) # 8000053c <panic>

0000000080007a22 <virtio_disk_init>:
{
    80007a22:	1101                	addi	sp,sp,-32
    80007a24:	ec06                	sd	ra,24(sp)
    80007a26:	e822                	sd	s0,16(sp)
    80007a28:	e426                	sd	s1,8(sp)
    80007a2a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80007a2c:	00002597          	auipc	a1,0x2
    80007a30:	12458593          	addi	a1,a1,292 # 80009b50 <syscalls+0x3f0>
    80007a34:	00020517          	auipc	a0,0x20
    80007a38:	6f450513          	addi	a0,a0,1780 # 80028128 <disk+0x2128>
    80007a3c:	ffff9097          	auipc	ra,0xffff9
    80007a40:	116080e7          	jalr	278(ra) # 80000b52 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007a44:	100017b7          	lui	a5,0x10001
    80007a48:	4398                	lw	a4,0(a5)
    80007a4a:	2701                	sext.w	a4,a4
    80007a4c:	747277b7          	lui	a5,0x74727
    80007a50:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80007a54:	0ef71163          	bne	a4,a5,80007b36 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80007a58:	100017b7          	lui	a5,0x10001
    80007a5c:	43dc                	lw	a5,4(a5)
    80007a5e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007a60:	4705                	li	a4,1
    80007a62:	0ce79a63          	bne	a5,a4,80007b36 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80007a66:	100017b7          	lui	a5,0x10001
    80007a6a:	479c                	lw	a5,8(a5)
    80007a6c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80007a6e:	4709                	li	a4,2
    80007a70:	0ce79363          	bne	a5,a4,80007b36 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80007a74:	100017b7          	lui	a5,0x10001
    80007a78:	47d8                	lw	a4,12(a5)
    80007a7a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80007a7c:	554d47b7          	lui	a5,0x554d4
    80007a80:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007a84:	0af71963          	bne	a4,a5,80007b36 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80007a88:	100017b7          	lui	a5,0x10001
    80007a8c:	4705                	li	a4,1
    80007a8e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007a90:	470d                	li	a4,3
    80007a92:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007a94:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80007a96:	c7ffe737          	lui	a4,0xc7ffe
    80007a9a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd575f>
    80007a9e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007aa0:	2701                	sext.w	a4,a4
    80007aa2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007aa4:	472d                	li	a4,11
    80007aa6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007aa8:	473d                	li	a4,15
    80007aaa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80007aac:	6705                	lui	a4,0x1
    80007aae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80007ab0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007ab4:	5bdc                	lw	a5,52(a5)
    80007ab6:	2781                	sext.w	a5,a5
  if(max == 0)
    80007ab8:	c7d9                	beqz	a5,80007b46 <virtio_disk_init+0x124>
  if(max < NUM)
    80007aba:	471d                	li	a4,7
    80007abc:	08f77d63          	bgeu	a4,a5,80007b56 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007ac0:	100014b7          	lui	s1,0x10001
    80007ac4:	47a1                	li	a5,8
    80007ac6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80007ac8:	6609                	lui	a2,0x2
    80007aca:	4581                	li	a1,0
    80007acc:	0001e517          	auipc	a0,0x1e
    80007ad0:	53450513          	addi	a0,a0,1332 # 80026000 <disk>
    80007ad4:	ffff9097          	auipc	ra,0xffff9
    80007ad8:	20a080e7          	jalr	522(ra) # 80000cde <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80007adc:	0001e717          	auipc	a4,0x1e
    80007ae0:	52470713          	addi	a4,a4,1316 # 80026000 <disk>
    80007ae4:	00c75793          	srli	a5,a4,0xc
    80007ae8:	2781                	sext.w	a5,a5
    80007aea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80007aec:	00020797          	auipc	a5,0x20
    80007af0:	51478793          	addi	a5,a5,1300 # 80028000 <disk+0x2000>
    80007af4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80007af6:	0001e717          	auipc	a4,0x1e
    80007afa:	58a70713          	addi	a4,a4,1418 # 80026080 <disk+0x80>
    80007afe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80007b00:	0001f717          	auipc	a4,0x1f
    80007b04:	50070713          	addi	a4,a4,1280 # 80027000 <disk+0x1000>
    80007b08:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80007b0a:	4705                	li	a4,1
    80007b0c:	00e78c23          	sb	a4,24(a5)
    80007b10:	00e78ca3          	sb	a4,25(a5)
    80007b14:	00e78d23          	sb	a4,26(a5)
    80007b18:	00e78da3          	sb	a4,27(a5)
    80007b1c:	00e78e23          	sb	a4,28(a5)
    80007b20:	00e78ea3          	sb	a4,29(a5)
    80007b24:	00e78f23          	sb	a4,30(a5)
    80007b28:	00e78fa3          	sb	a4,31(a5)
}
    80007b2c:	60e2                	ld	ra,24(sp)
    80007b2e:	6442                	ld	s0,16(sp)
    80007b30:	64a2                	ld	s1,8(sp)
    80007b32:	6105                	addi	sp,sp,32
    80007b34:	8082                	ret
    panic("could not find virtio disk");
    80007b36:	00002517          	auipc	a0,0x2
    80007b3a:	02a50513          	addi	a0,a0,42 # 80009b60 <syscalls+0x400>
    80007b3e:	ffff9097          	auipc	ra,0xffff9
    80007b42:	9fe080e7          	jalr	-1538(ra) # 8000053c <panic>
    panic("virtio disk has no queue 0");
    80007b46:	00002517          	auipc	a0,0x2
    80007b4a:	03a50513          	addi	a0,a0,58 # 80009b80 <syscalls+0x420>
    80007b4e:	ffff9097          	auipc	ra,0xffff9
    80007b52:	9ee080e7          	jalr	-1554(ra) # 8000053c <panic>
    panic("virtio disk max queue too short");
    80007b56:	00002517          	auipc	a0,0x2
    80007b5a:	04a50513          	addi	a0,a0,74 # 80009ba0 <syscalls+0x440>
    80007b5e:	ffff9097          	auipc	ra,0xffff9
    80007b62:	9de080e7          	jalr	-1570(ra) # 8000053c <panic>

0000000080007b66 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80007b66:	7159                	addi	sp,sp,-112
    80007b68:	f486                	sd	ra,104(sp)
    80007b6a:	f0a2                	sd	s0,96(sp)
    80007b6c:	eca6                	sd	s1,88(sp)
    80007b6e:	e8ca                	sd	s2,80(sp)
    80007b70:	e4ce                	sd	s3,72(sp)
    80007b72:	e0d2                	sd	s4,64(sp)
    80007b74:	fc56                	sd	s5,56(sp)
    80007b76:	f85a                	sd	s6,48(sp)
    80007b78:	f45e                	sd	s7,40(sp)
    80007b7a:	f062                	sd	s8,32(sp)
    80007b7c:	ec66                	sd	s9,24(sp)
    80007b7e:	e86a                	sd	s10,16(sp)
    80007b80:	1880                	addi	s0,sp,112
    80007b82:	892a                	mv	s2,a0
    80007b84:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80007b86:	00c52c83          	lw	s9,12(a0)
    80007b8a:	001c9c9b          	slliw	s9,s9,0x1
    80007b8e:	1c82                	slli	s9,s9,0x20
    80007b90:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80007b94:	00020517          	auipc	a0,0x20
    80007b98:	59450513          	addi	a0,a0,1428 # 80028128 <disk+0x2128>
    80007b9c:	ffff9097          	auipc	ra,0xffff9
    80007ba0:	046080e7          	jalr	70(ra) # 80000be2 <acquire>
  for(int i = 0; i < 3; i++){
    80007ba4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80007ba6:	4c21                	li	s8,8
      disk.free[i] = 0;
    80007ba8:	0001eb97          	auipc	s7,0x1e
    80007bac:	458b8b93          	addi	s7,s7,1112 # 80026000 <disk>
    80007bb0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80007bb2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80007bb4:	8a4e                	mv	s4,s3
    80007bb6:	a051                	j	80007c3a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80007bb8:	00fb86b3          	add	a3,s7,a5
    80007bbc:	96da                	add	a3,a3,s6
    80007bbe:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80007bc2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80007bc4:	0207c563          	bltz	a5,80007bee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80007bc8:	2485                	addiw	s1,s1,1
    80007bca:	0711                	addi	a4,a4,4
    80007bcc:	25548063          	beq	s1,s5,80007e0c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80007bd0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80007bd2:	00020697          	auipc	a3,0x20
    80007bd6:	44668693          	addi	a3,a3,1094 # 80028018 <disk+0x2018>
    80007bda:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80007bdc:	0006c583          	lbu	a1,0(a3)
    80007be0:	fde1                	bnez	a1,80007bb8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80007be2:	2785                	addiw	a5,a5,1
    80007be4:	0685                	addi	a3,a3,1
    80007be6:	ff879be3          	bne	a5,s8,80007bdc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80007bea:	57fd                	li	a5,-1
    80007bec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80007bee:	02905a63          	blez	s1,80007c22 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80007bf2:	f9042503          	lw	a0,-112(s0)
    80007bf6:	00000097          	auipc	ra,0x0
    80007bfa:	d90080e7          	jalr	-624(ra) # 80007986 <free_desc>
      for(int j = 0; j < i; j++)
    80007bfe:	4785                	li	a5,1
    80007c00:	0297d163          	bge	a5,s1,80007c22 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80007c04:	f9442503          	lw	a0,-108(s0)
    80007c08:	00000097          	auipc	ra,0x0
    80007c0c:	d7e080e7          	jalr	-642(ra) # 80007986 <free_desc>
      for(int j = 0; j < i; j++)
    80007c10:	4789                	li	a5,2
    80007c12:	0097d863          	bge	a5,s1,80007c22 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80007c16:	f9842503          	lw	a0,-104(s0)
    80007c1a:	00000097          	auipc	ra,0x0
    80007c1e:	d6c080e7          	jalr	-660(ra) # 80007986 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80007c22:	00020597          	auipc	a1,0x20
    80007c26:	50658593          	addi	a1,a1,1286 # 80028128 <disk+0x2128>
    80007c2a:	00020517          	auipc	a0,0x20
    80007c2e:	3ee50513          	addi	a0,a0,1006 # 80028018 <disk+0x2018>
    80007c32:	ffffb097          	auipc	ra,0xffffb
    80007c36:	b28080e7          	jalr	-1240(ra) # 8000275a <sleep>
  for(int i = 0; i < 3; i++){
    80007c3a:	f9040713          	addi	a4,s0,-112
    80007c3e:	84ce                	mv	s1,s3
    80007c40:	bf41                	j	80007bd0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80007c42:	20058713          	addi	a4,a1,512
    80007c46:	00471693          	slli	a3,a4,0x4
    80007c4a:	0001e717          	auipc	a4,0x1e
    80007c4e:	3b670713          	addi	a4,a4,950 # 80026000 <disk>
    80007c52:	9736                	add	a4,a4,a3
    80007c54:	4685                	li	a3,1
    80007c56:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80007c5a:	20058713          	addi	a4,a1,512
    80007c5e:	00471693          	slli	a3,a4,0x4
    80007c62:	0001e717          	auipc	a4,0x1e
    80007c66:	39e70713          	addi	a4,a4,926 # 80026000 <disk>
    80007c6a:	9736                	add	a4,a4,a3
    80007c6c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80007c70:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80007c74:	7679                	lui	a2,0xffffe
    80007c76:	963e                	add	a2,a2,a5
    80007c78:	00020697          	auipc	a3,0x20
    80007c7c:	38868693          	addi	a3,a3,904 # 80028000 <disk+0x2000>
    80007c80:	6298                	ld	a4,0(a3)
    80007c82:	9732                	add	a4,a4,a2
    80007c84:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80007c86:	6298                	ld	a4,0(a3)
    80007c88:	9732                	add	a4,a4,a2
    80007c8a:	4541                	li	a0,16
    80007c8c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80007c8e:	6298                	ld	a4,0(a3)
    80007c90:	9732                	add	a4,a4,a2
    80007c92:	4505                	li	a0,1
    80007c94:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80007c98:	f9442703          	lw	a4,-108(s0)
    80007c9c:	6288                	ld	a0,0(a3)
    80007c9e:	962a                	add	a2,a2,a0
    80007ca0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd500e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80007ca4:	0712                	slli	a4,a4,0x4
    80007ca6:	6290                	ld	a2,0(a3)
    80007ca8:	963a                	add	a2,a2,a4
    80007caa:	05890513          	addi	a0,s2,88
    80007cae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007cb0:	6294                	ld	a3,0(a3)
    80007cb2:	96ba                	add	a3,a3,a4
    80007cb4:	40000613          	li	a2,1024
    80007cb8:	c690                	sw	a2,8(a3)
  if(write)
    80007cba:	140d0063          	beqz	s10,80007dfa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80007cbe:	00020697          	auipc	a3,0x20
    80007cc2:	3426b683          	ld	a3,834(a3) # 80028000 <disk+0x2000>
    80007cc6:	96ba                	add	a3,a3,a4
    80007cc8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80007ccc:	0001e817          	auipc	a6,0x1e
    80007cd0:	33480813          	addi	a6,a6,820 # 80026000 <disk>
    80007cd4:	00020517          	auipc	a0,0x20
    80007cd8:	32c50513          	addi	a0,a0,812 # 80028000 <disk+0x2000>
    80007cdc:	6114                	ld	a3,0(a0)
    80007cde:	96ba                	add	a3,a3,a4
    80007ce0:	00c6d603          	lhu	a2,12(a3)
    80007ce4:	00166613          	ori	a2,a2,1
    80007ce8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80007cec:	f9842683          	lw	a3,-104(s0)
    80007cf0:	6110                	ld	a2,0(a0)
    80007cf2:	9732                	add	a4,a4,a2
    80007cf4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80007cf8:	20058613          	addi	a2,a1,512
    80007cfc:	0612                	slli	a2,a2,0x4
    80007cfe:	9642                	add	a2,a2,a6
    80007d00:	577d                	li	a4,-1
    80007d02:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007d06:	00469713          	slli	a4,a3,0x4
    80007d0a:	6114                	ld	a3,0(a0)
    80007d0c:	96ba                	add	a3,a3,a4
    80007d0e:	03078793          	addi	a5,a5,48
    80007d12:	97c2                	add	a5,a5,a6
    80007d14:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80007d16:	611c                	ld	a5,0(a0)
    80007d18:	97ba                	add	a5,a5,a4
    80007d1a:	4685                	li	a3,1
    80007d1c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007d1e:	611c                	ld	a5,0(a0)
    80007d20:	97ba                	add	a5,a5,a4
    80007d22:	4809                	li	a6,2
    80007d24:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80007d28:	611c                	ld	a5,0(a0)
    80007d2a:	973e                	add	a4,a4,a5
    80007d2c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007d30:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80007d34:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80007d38:	6518                	ld	a4,8(a0)
    80007d3a:	00275783          	lhu	a5,2(a4)
    80007d3e:	8b9d                	andi	a5,a5,7
    80007d40:	0786                	slli	a5,a5,0x1
    80007d42:	97ba                	add	a5,a5,a4
    80007d44:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80007d48:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80007d4c:	6518                	ld	a4,8(a0)
    80007d4e:	00275783          	lhu	a5,2(a4)
    80007d52:	2785                	addiw	a5,a5,1
    80007d54:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80007d58:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80007d5c:	100017b7          	lui	a5,0x10001
    80007d60:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007d64:	00492703          	lw	a4,4(s2)
    80007d68:	4785                	li	a5,1
    80007d6a:	02f71163          	bne	a4,a5,80007d8c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    80007d6e:	00020997          	auipc	s3,0x20
    80007d72:	3ba98993          	addi	s3,s3,954 # 80028128 <disk+0x2128>
  while(b->disk == 1) {
    80007d76:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80007d78:	85ce                	mv	a1,s3
    80007d7a:	854a                	mv	a0,s2
    80007d7c:	ffffb097          	auipc	ra,0xffffb
    80007d80:	9de080e7          	jalr	-1570(ra) # 8000275a <sleep>
  while(b->disk == 1) {
    80007d84:	00492783          	lw	a5,4(s2)
    80007d88:	fe9788e3          	beq	a5,s1,80007d78 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    80007d8c:	f9042903          	lw	s2,-112(s0)
    80007d90:	20090793          	addi	a5,s2,512
    80007d94:	00479713          	slli	a4,a5,0x4
    80007d98:	0001e797          	auipc	a5,0x1e
    80007d9c:	26878793          	addi	a5,a5,616 # 80026000 <disk>
    80007da0:	97ba                	add	a5,a5,a4
    80007da2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80007da6:	00020997          	auipc	s3,0x20
    80007daa:	25a98993          	addi	s3,s3,602 # 80028000 <disk+0x2000>
    80007dae:	00491713          	slli	a4,s2,0x4
    80007db2:	0009b783          	ld	a5,0(s3)
    80007db6:	97ba                	add	a5,a5,a4
    80007db8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007dbc:	854a                	mv	a0,s2
    80007dbe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80007dc2:	00000097          	auipc	ra,0x0
    80007dc6:	bc4080e7          	jalr	-1084(ra) # 80007986 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80007dca:	8885                	andi	s1,s1,1
    80007dcc:	f0ed                	bnez	s1,80007dae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80007dce:	00020517          	auipc	a0,0x20
    80007dd2:	35a50513          	addi	a0,a0,858 # 80028128 <disk+0x2128>
    80007dd6:	ffff9097          	auipc	ra,0xffff9
    80007dda:	ec0080e7          	jalr	-320(ra) # 80000c96 <release>
}
    80007dde:	70a6                	ld	ra,104(sp)
    80007de0:	7406                	ld	s0,96(sp)
    80007de2:	64e6                	ld	s1,88(sp)
    80007de4:	6946                	ld	s2,80(sp)
    80007de6:	69a6                	ld	s3,72(sp)
    80007de8:	6a06                	ld	s4,64(sp)
    80007dea:	7ae2                	ld	s5,56(sp)
    80007dec:	7b42                	ld	s6,48(sp)
    80007dee:	7ba2                	ld	s7,40(sp)
    80007df0:	7c02                	ld	s8,32(sp)
    80007df2:	6ce2                	ld	s9,24(sp)
    80007df4:	6d42                	ld	s10,16(sp)
    80007df6:	6165                	addi	sp,sp,112
    80007df8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80007dfa:	00020697          	auipc	a3,0x20
    80007dfe:	2066b683          	ld	a3,518(a3) # 80028000 <disk+0x2000>
    80007e02:	96ba                	add	a3,a3,a4
    80007e04:	4609                	li	a2,2
    80007e06:	00c69623          	sh	a2,12(a3)
    80007e0a:	b5c9                	j	80007ccc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007e0c:	f9042583          	lw	a1,-112(s0)
    80007e10:	20058793          	addi	a5,a1,512
    80007e14:	0792                	slli	a5,a5,0x4
    80007e16:	0001e517          	auipc	a0,0x1e
    80007e1a:	29250513          	addi	a0,a0,658 # 800260a8 <disk+0xa8>
    80007e1e:	953e                	add	a0,a0,a5
  if(write)
    80007e20:	e20d11e3          	bnez	s10,80007c42 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80007e24:	20058713          	addi	a4,a1,512
    80007e28:	00471693          	slli	a3,a4,0x4
    80007e2c:	0001e717          	auipc	a4,0x1e
    80007e30:	1d470713          	addi	a4,a4,468 # 80026000 <disk>
    80007e34:	9736                	add	a4,a4,a3
    80007e36:	0a072423          	sw	zero,168(a4)
    80007e3a:	b505                	j	80007c5a <virtio_disk_rw+0xf4>

0000000080007e3c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007e3c:	1101                	addi	sp,sp,-32
    80007e3e:	ec06                	sd	ra,24(sp)
    80007e40:	e822                	sd	s0,16(sp)
    80007e42:	e426                	sd	s1,8(sp)
    80007e44:	e04a                	sd	s2,0(sp)
    80007e46:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007e48:	00020517          	auipc	a0,0x20
    80007e4c:	2e050513          	addi	a0,a0,736 # 80028128 <disk+0x2128>
    80007e50:	ffff9097          	auipc	ra,0xffff9
    80007e54:	d92080e7          	jalr	-622(ra) # 80000be2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80007e58:	10001737          	lui	a4,0x10001
    80007e5c:	533c                	lw	a5,96(a4)
    80007e5e:	8b8d                	andi	a5,a5,3
    80007e60:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80007e62:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80007e66:	00020797          	auipc	a5,0x20
    80007e6a:	19a78793          	addi	a5,a5,410 # 80028000 <disk+0x2000>
    80007e6e:	6b94                	ld	a3,16(a5)
    80007e70:	0207d703          	lhu	a4,32(a5)
    80007e74:	0026d783          	lhu	a5,2(a3)
    80007e78:	06f70163          	beq	a4,a5,80007eda <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007e7c:	0001e917          	auipc	s2,0x1e
    80007e80:	18490913          	addi	s2,s2,388 # 80026000 <disk>
    80007e84:	00020497          	auipc	s1,0x20
    80007e88:	17c48493          	addi	s1,s1,380 # 80028000 <disk+0x2000>
    __sync_synchronize();
    80007e8c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007e90:	6898                	ld	a4,16(s1)
    80007e92:	0204d783          	lhu	a5,32(s1)
    80007e96:	8b9d                	andi	a5,a5,7
    80007e98:	078e                	slli	a5,a5,0x3
    80007e9a:	97ba                	add	a5,a5,a4
    80007e9c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007e9e:	20078713          	addi	a4,a5,512
    80007ea2:	0712                	slli	a4,a4,0x4
    80007ea4:	974a                	add	a4,a4,s2
    80007ea6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80007eaa:	e731                	bnez	a4,80007ef6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007eac:	20078793          	addi	a5,a5,512
    80007eb0:	0792                	slli	a5,a5,0x4
    80007eb2:	97ca                	add	a5,a5,s2
    80007eb4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80007eb6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007eba:	ffffb097          	auipc	ra,0xffffb
    80007ebe:	ca6080e7          	jalr	-858(ra) # 80002b60 <wakeup>

    disk.used_idx += 1;
    80007ec2:	0204d783          	lhu	a5,32(s1)
    80007ec6:	2785                	addiw	a5,a5,1
    80007ec8:	17c2                	slli	a5,a5,0x30
    80007eca:	93c1                	srli	a5,a5,0x30
    80007ecc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007ed0:	6898                	ld	a4,16(s1)
    80007ed2:	00275703          	lhu	a4,2(a4)
    80007ed6:	faf71be3          	bne	a4,a5,80007e8c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80007eda:	00020517          	auipc	a0,0x20
    80007ede:	24e50513          	addi	a0,a0,590 # 80028128 <disk+0x2128>
    80007ee2:	ffff9097          	auipc	ra,0xffff9
    80007ee6:	db4080e7          	jalr	-588(ra) # 80000c96 <release>
}
    80007eea:	60e2                	ld	ra,24(sp)
    80007eec:	6442                	ld	s0,16(sp)
    80007eee:	64a2                	ld	s1,8(sp)
    80007ef0:	6902                	ld	s2,0(sp)
    80007ef2:	6105                	addi	sp,sp,32
    80007ef4:	8082                	ret
      panic("virtio_disk_intr status");
    80007ef6:	00002517          	auipc	a0,0x2
    80007efa:	cca50513          	addi	a0,a0,-822 # 80009bc0 <syscalls+0x460>
    80007efe:	ffff8097          	auipc	ra,0xffff8
    80007f02:	63e080e7          	jalr	1598(ra) # 8000053c <panic>

0000000080007f06 <cond_wait>:
#include "defs.h"
#include "proc.h"
// #include "condvar.h"
// #include "sleeplock.h"
void cond_wait (struct cond_t *cv, struct sleeplock *lock)
{
    80007f06:	1141                	addi	sp,sp,-16
    80007f08:	e406                	sd	ra,8(sp)
    80007f0a:	e022                	sd	s0,0(sp)
    80007f0c:	0800                	addi	s0,sp,16
    condsleep(cv,lock);
    80007f0e:	ffffb097          	auipc	ra,0xffffb
    80007f12:	6ca080e7          	jalr	1738(ra) # 800035d8 <condsleep>
    return;
}
    80007f16:	60a2                	ld	ra,8(sp)
    80007f18:	6402                	ld	s0,0(sp)
    80007f1a:	0141                	addi	sp,sp,16
    80007f1c:	8082                	ret

0000000080007f1e <cond_signal>:
void cond_signal(struct cond_t *cv)
{
    80007f1e:	1141                	addi	sp,sp,-16
    80007f20:	e406                	sd	ra,8(sp)
    80007f22:	e022                	sd	s0,0(sp)
    80007f24:	0800                	addi	s0,sp,16
    wakeupone(cv);
    80007f26:	ffffc097          	auipc	ra,0xffffc
    80007f2a:	860080e7          	jalr	-1952(ra) # 80003786 <wakeupone>
    return;
}
    80007f2e:	60a2                	ld	ra,8(sp)
    80007f30:	6402                	ld	s0,0(sp)
    80007f32:	0141                	addi	sp,sp,16
    80007f34:	8082                	ret

0000000080007f36 <cond_broadcast>:

void cond_broadcast (struct cond_t *cv)
{
    80007f36:	1141                	addi	sp,sp,-16
    80007f38:	e406                	sd	ra,8(sp)
    80007f3a:	e022                	sd	s0,0(sp)
    80007f3c:	0800                	addi	s0,sp,16
    wakeup(cv);
    80007f3e:	ffffb097          	auipc	ra,0xffffb
    80007f42:	c22080e7          	jalr	-990(ra) # 80002b60 <wakeup>
    return;
    80007f46:	60a2                	ld	ra,8(sp)
    80007f48:	6402                	ld	s0,0(sp)
    80007f4a:	0141                	addi	sp,sp,16
    80007f4c:	8082                	ret

0000000080007f4e <sem_init>:
#include "semaphore.h"
// #include "condvar.h"
// #include "sleeplock.h"

void sem_init(struct semaphore *s, int x)
{
    80007f4e:	1101                	addi	sp,sp,-32
    80007f50:	ec06                	sd	ra,24(sp)
    80007f52:	e822                	sd	s0,16(sp)
    80007f54:	e426                	sd	s1,8(sp)
    80007f56:	e04a                	sd	s2,0(sp)
    80007f58:	1000                	addi	s0,sp,32
    80007f5a:	84aa                	mv	s1,a0
    80007f5c:	892e                	mv	s2,a1
	// initsleeplock(&(s->cv->lk),"sem_cv_lock");
	initsleeplock(&(s->lk),"sem_lock");
    80007f5e:	00001597          	auipc	a1,0x1
    80007f62:	5d258593          	addi	a1,a1,1490 # 80009530 <digits+0x4f0>
    80007f66:	ffffe097          	auipc	ra,0xffffe
    80007f6a:	0a8080e7          	jalr	168(ra) # 8000600e <initsleeplock>
	s->v= x;
    80007f6e:	0324ac23          	sw	s2,56(s1)
    return;
}
    80007f72:	60e2                	ld	ra,24(sp)
    80007f74:	6442                	ld	s0,16(sp)
    80007f76:	64a2                	ld	s1,8(sp)
    80007f78:	6902                	ld	s2,0(sp)
    80007f7a:	6105                	addi	sp,sp,32
    80007f7c:	8082                	ret

0000000080007f7e <sem_wait>:

void sem_wait(struct semaphore *s)
{
    80007f7e:	1101                	addi	sp,sp,-32
    80007f80:	ec06                	sd	ra,24(sp)
    80007f82:	e822                	sd	s0,16(sp)
    80007f84:	e426                	sd	s1,8(sp)
    80007f86:	e04a                	sd	s2,0(sp)
    80007f88:	1000                	addi	s0,sp,32
    80007f8a:	84aa                	mv	s1,a0
    acquiresleep(&(s->lk));
    80007f8c:	892a                	mv	s2,a0
    80007f8e:	ffffe097          	auipc	ra,0xffffe
    80007f92:	0ba080e7          	jalr	186(ra) # 80006048 <acquiresleep>
	while(s->v==0)
    80007f96:	5c9c                	lw	a5,56(s1)
    80007f98:	eb89                	bnez	a5,80007faa <sem_wait+0x2c>
	{
		condsleep(s->cv,&(s->lk));
    80007f9a:	85ca                	mv	a1,s2
    80007f9c:	7888                	ld	a0,48(s1)
    80007f9e:	ffffb097          	auipc	ra,0xffffb
    80007fa2:	63a080e7          	jalr	1594(ra) # 800035d8 <condsleep>
	while(s->v==0)
    80007fa6:	5c9c                	lw	a5,56(s1)
    80007fa8:	dbed                	beqz	a5,80007f9a <sem_wait+0x1c>
	}
	s->v= s->v -1;
    80007faa:	37fd                	addiw	a5,a5,-1
    80007fac:	dc9c                	sw	a5,56(s1)
	releasesleep(&(s->lk));
    80007fae:	8526                	mv	a0,s1
    80007fb0:	ffffe097          	auipc	ra,0xffffe
    80007fb4:	0ee080e7          	jalr	238(ra) # 8000609e <releasesleep>
	return;
}
    80007fb8:	60e2                	ld	ra,24(sp)
    80007fba:	6442                	ld	s0,16(sp)
    80007fbc:	64a2                	ld	s1,8(sp)
    80007fbe:	6902                	ld	s2,0(sp)
    80007fc0:	6105                	addi	sp,sp,32
    80007fc2:	8082                	ret

0000000080007fc4 <sem_post>:

void sem_post(struct semaphore *s)
{
    80007fc4:	1101                	addi	sp,sp,-32
    80007fc6:	ec06                	sd	ra,24(sp)
    80007fc8:	e822                	sd	s0,16(sp)
    80007fca:	e426                	sd	s1,8(sp)
    80007fcc:	1000                	addi	s0,sp,32
    80007fce:	84aa                	mv	s1,a0
    acquiresleep(&(s->lk));
    80007fd0:	ffffe097          	auipc	ra,0xffffe
    80007fd4:	078080e7          	jalr	120(ra) # 80006048 <acquiresleep>
	s->v= s->v +1;
    80007fd8:	5c9c                	lw	a5,56(s1)
    80007fda:	2785                	addiw	a5,a5,1
    80007fdc:	dc9c                	sw	a5,56(s1)
	cond_signal((s->cv));
    80007fde:	7888                	ld	a0,48(s1)
    80007fe0:	00000097          	auipc	ra,0x0
    80007fe4:	f3e080e7          	jalr	-194(ra) # 80007f1e <cond_signal>
	releasesleep(&(s->lk));
    80007fe8:	8526                	mv	a0,s1
    80007fea:	ffffe097          	auipc	ra,0xffffe
    80007fee:	0b4080e7          	jalr	180(ra) # 8000609e <releasesleep>
    return;
}
    80007ff2:	60e2                	ld	ra,24(sp)
    80007ff4:	6442                	ld	s0,16(sp)
    80007ff6:	64a2                	ld	s1,8(sp)
    80007ff8:	6105                	addi	sp,sp,32
    80007ffa:	8082                	ret
    80007ffc:	0000                	unimp
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
