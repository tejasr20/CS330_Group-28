
user/_semprodconstest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <produce>:
#include "user/user.h"

int num_items, num_prods, num_cons;

int produce (int index, int tid)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
   return index+(num_items*tid);
   6:	00001797          	auipc	a5,0x1
   a:	b727a783          	lw	a5,-1166(a5) # b78 <num_items>
   e:	02b787bb          	mulw	a5,a5,a1
}
  12:	9d3d                	addw	a0,a0,a5
  14:	6422                	ld	s0,8(sp)
  16:	0141                	addi	sp,sp,16
  18:	8082                	ret

000000000000001a <main>:

int
main(int argc, char *argv[])
{
  1a:	7179                	addi	sp,sp,-48
  1c:	f406                	sd	ra,40(sp)
  1e:	f022                	sd	s0,32(sp)
  20:	ec26                	sd	s1,24(sp)
  22:	e84a                	sd	s2,16(sp)
  24:	e44e                	sd	s3,8(sp)
  26:	e052                	sd	s4,0(sp)
  28:	1800                	addi	s0,sp,48
  int i, j;

  if (argc != 4) {
  2a:	4791                	li	a5,4
  2c:	02f50063          	beq	a0,a5,4c <main+0x32>
     fprintf(2, "syntax: semprodconstest number of items to be produced by each producer, number of producers, number of consumers.\nAborting...\n");
  30:	00001597          	auipc	a1,0x1
  34:	a7858593          	addi	a1,a1,-1416 # aa8 <malloc+0xe4>
  38:	4509                	li	a0,2
  3a:	00001097          	auipc	ra,0x1
  3e:	89e080e7          	jalr	-1890(ra) # 8d8 <fprintf>
     exit(0);
  42:	4501                	li	a0,0
  44:	00000097          	auipc	ra,0x0
  48:	4a0080e7          	jalr	1184(ra) # 4e4 <exit>
  4c:	84ae                	mv	s1,a1
  }
  num_items = atoi(argv[1]);
  4e:	6588                	ld	a0,8(a1)
  50:	00000097          	auipc	ra,0x0
  54:	394080e7          	jalr	916(ra) # 3e4 <atoi>
  58:	00001797          	auipc	a5,0x1
  5c:	b2a7a023          	sw	a0,-1248(a5) # b78 <num_items>
  num_prods = atoi(argv[2]);
  60:	6888                	ld	a0,16(s1)
  62:	00000097          	auipc	ra,0x0
  66:	382080e7          	jalr	898(ra) # 3e4 <atoi>
  6a:	00001917          	auipc	s2,0x1
  6e:	b0a90913          	addi	s2,s2,-1270 # b74 <num_prods>
  72:	00a92023          	sw	a0,0(s2)
  num_cons = atoi(argv[3]);
  76:	6c88                	ld	a0,24(s1)
  78:	00000097          	auipc	ra,0x0
  7c:	36c080e7          	jalr	876(ra) # 3e4 <atoi>
  80:	00001797          	auipc	a5,0x1
  84:	aea7a823          	sw	a0,-1296(a5) # b70 <num_cons>
  buffer_sem_init();
  88:	00000097          	auipc	ra,0x0
  8c:	588080e7          	jalr	1416(ra) # 610 <buffer_sem_init>

  printf("Start time: %d\n\n", uptime());
  90:	00000097          	auipc	ra,0x0
  94:	4ec080e7          	jalr	1260(ra) # 57c <uptime>
  98:	85aa                	mv	a1,a0
  9a:	00001517          	auipc	a0,0x1
  9e:	a8e50513          	addi	a0,a0,-1394 # b28 <malloc+0x164>
  a2:	00001097          	auipc	ra,0x1
  a6:	864080e7          	jalr	-1948(ra) # 906 <printf>
  for (i=0; i<num_prods; i++) {
  aa:	00092783          	lw	a5,0(s2)
  ae:	02f05363          	blez	a5,d4 <main+0xba>
  b2:	4901                	li	s2,0
  b4:	00001997          	auipc	s3,0x1
  b8:	ac098993          	addi	s3,s3,-1344 # b74 <num_prods>
     if (fork() == 0) {
  bc:	00000097          	auipc	ra,0x0
  c0:	420080e7          	jalr	1056(ra) # 4dc <fork>
  c4:	84aa                	mv	s1,a0
  c6:	10050563          	beqz	a0,1d0 <main+0x1b6>
  for (i=0; i<num_prods; i++) {
  ca:	2905                	addiw	s2,s2,1
  cc:	0009a783          	lw	a5,0(s3)
  d0:	fef946e3          	blt	s2,a5,bc <main+0xa2>
	for (j=0; j<num_items; j++) sem_produce(produce(j, i));
	exit(0);
     }
  }
  for (i=0; i<num_cons-1; i++) {
  d4:	00001717          	auipc	a4,0x1
  d8:	a9c72703          	lw	a4,-1380(a4) # b70 <num_cons>
  dc:	4785                	li	a5,1
  de:	02e7d463          	bge	a5,a4,106 <main+0xec>
  e2:	4901                	li	s2,0
  e4:	00001997          	auipc	s3,0x1
  e8:	a8c98993          	addi	s3,s3,-1396 # b70 <num_cons>
     if (fork() == 0) {
  ec:	00000097          	auipc	ra,0x0
  f0:	3f0080e7          	jalr	1008(ra) # 4dc <fork>
  f4:	84aa                	mv	s1,a0
  f6:	10050863          	beqz	a0,206 <main+0x1ec>
  for (i=0; i<num_cons-1; i++) {
  fa:	2905                	addiw	s2,s2,1
  fc:	0009a783          	lw	a5,0(s3)
 100:	37fd                	addiw	a5,a5,-1
 102:	fef945e3          	blt	s2,a5,ec <main+0xd2>
        for (j=0; j<(num_items*num_prods)/num_cons; j++) sem_consume();
        exit(0);
     }
  }
  for (j=0; j<(num_items*num_prods)/num_cons; j++) sem_consume();
 106:	00001797          	auipc	a5,0x1
 10a:	a727a783          	lw	a5,-1422(a5) # b78 <num_items>
 10e:	00001717          	auipc	a4,0x1
 112:	a6672703          	lw	a4,-1434(a4) # b74 <num_prods>
 116:	02e787bb          	mulw	a5,a5,a4
 11a:	00001717          	auipc	a4,0x1
 11e:	a5672703          	lw	a4,-1450(a4) # b70 <num_cons>
 122:	02e7c7bb          	divw	a5,a5,a4
 126:	04f05063          	blez	a5,166 <main+0x14c>
 12a:	4481                	li	s1,0
 12c:	00001a17          	auipc	s4,0x1
 130:	a4ca0a13          	addi	s4,s4,-1460 # b78 <num_items>
 134:	00001997          	auipc	s3,0x1
 138:	a4098993          	addi	s3,s3,-1472 # b74 <num_prods>
 13c:	00001917          	auipc	s2,0x1
 140:	a3490913          	addi	s2,s2,-1484 # b70 <num_cons>
 144:	00000097          	auipc	ra,0x0
 148:	4d6080e7          	jalr	1238(ra) # 61a <sem_consume>
 14c:	2485                	addiw	s1,s1,1
 14e:	000a2783          	lw	a5,0(s4)
 152:	0009a703          	lw	a4,0(s3)
 156:	02e787bb          	mulw	a5,a5,a4
 15a:	00092703          	lw	a4,0(s2)
 15e:	02e7c7bb          	divw	a5,a5,a4
 162:	fef4c1e3          	blt	s1,a5,144 <main+0x12a>
  for (i=0; i<num_prods+num_cons-1; i++) wait(0);
 166:	00001797          	auipc	a5,0x1
 16a:	a0e7a783          	lw	a5,-1522(a5) # b74 <num_prods>
 16e:	00001717          	auipc	a4,0x1
 172:	a0272703          	lw	a4,-1534(a4) # b70 <num_cons>
 176:	9fb9                	addw	a5,a5,a4
 178:	4705                	li	a4,1
 17a:	02f75963          	bge	a4,a5,1ac <main+0x192>
 17e:	4481                	li	s1,0
 180:	00001997          	auipc	s3,0x1
 184:	9f498993          	addi	s3,s3,-1548 # b74 <num_prods>
 188:	00001917          	auipc	s2,0x1
 18c:	9e890913          	addi	s2,s2,-1560 # b70 <num_cons>
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	35a080e7          	jalr	858(ra) # 4ec <wait>
 19a:	2485                	addiw	s1,s1,1
 19c:	0009a783          	lw	a5,0(s3)
 1a0:	00092703          	lw	a4,0(s2)
 1a4:	9fb9                	addw	a5,a5,a4
 1a6:	37fd                	addiw	a5,a5,-1
 1a8:	fef4c4e3          	blt	s1,a5,190 <main+0x176>
  printf("\n\nEnd time: %d\n", uptime());
 1ac:	00000097          	auipc	ra,0x0
 1b0:	3d0080e7          	jalr	976(ra) # 57c <uptime>
 1b4:	85aa                	mv	a1,a0
 1b6:	00001517          	auipc	a0,0x1
 1ba:	98a50513          	addi	a0,a0,-1654 # b40 <malloc+0x17c>
 1be:	00000097          	auipc	ra,0x0
 1c2:	748080e7          	jalr	1864(ra) # 906 <printf>
  exit(0);
 1c6:	4501                	li	a0,0
 1c8:	00000097          	auipc	ra,0x0
 1cc:	31c080e7          	jalr	796(ra) # 4e4 <exit>
	for (j=0; j<num_items; j++) sem_produce(produce(j, i));
 1d0:	00001517          	auipc	a0,0x1
 1d4:	9a852503          	lw	a0,-1624(a0) # b78 <num_items>
 1d8:	02a05263          	blez	a0,1fc <main+0x1e2>
 1dc:	00001997          	auipc	s3,0x1
 1e0:	99c98993          	addi	s3,s3,-1636 # b78 <num_items>
   return index+(num_items*tid);
 1e4:	0325053b          	mulw	a0,a0,s2
	for (j=0; j<num_items; j++) sem_produce(produce(j, i));
 1e8:	9d25                	addw	a0,a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	43a080e7          	jalr	1082(ra) # 624 <sem_produce>
 1f2:	2485                	addiw	s1,s1,1
 1f4:	0009a503          	lw	a0,0(s3)
 1f8:	fea4c6e3          	blt	s1,a0,1e4 <main+0x1ca>
	exit(0);
 1fc:	4501                	li	a0,0
 1fe:	00000097          	auipc	ra,0x0
 202:	2e6080e7          	jalr	742(ra) # 4e4 <exit>
        for (j=0; j<(num_items*num_prods)/num_cons; j++) sem_consume();
 206:	00001797          	auipc	a5,0x1
 20a:	9727a783          	lw	a5,-1678(a5) # b78 <num_items>
 20e:	00001717          	auipc	a4,0x1
 212:	96672703          	lw	a4,-1690(a4) # b74 <num_prods>
 216:	02e787bb          	mulw	a5,a5,a4
 21a:	00001717          	auipc	a4,0x1
 21e:	95672703          	lw	a4,-1706(a4) # b70 <num_cons>
 222:	02e7c7bb          	divw	a5,a5,a4
 226:	02f05f63          	blez	a5,264 <main+0x24a>
 22a:	00001a17          	auipc	s4,0x1
 22e:	94ea0a13          	addi	s4,s4,-1714 # b78 <num_items>
 232:	00001997          	auipc	s3,0x1
 236:	94298993          	addi	s3,s3,-1726 # b74 <num_prods>
 23a:	00001917          	auipc	s2,0x1
 23e:	93690913          	addi	s2,s2,-1738 # b70 <num_cons>
 242:	00000097          	auipc	ra,0x0
 246:	3d8080e7          	jalr	984(ra) # 61a <sem_consume>
 24a:	2485                	addiw	s1,s1,1
 24c:	000a2783          	lw	a5,0(s4)
 250:	0009a703          	lw	a4,0(s3)
 254:	02e787bb          	mulw	a5,a5,a4
 258:	00092703          	lw	a4,0(s2)
 25c:	02e7c7bb          	divw	a5,a5,a4
 260:	fef4c1e3          	blt	s1,a5,242 <main+0x228>
        exit(0);
 264:	4501                	li	a0,0
 266:	00000097          	auipc	ra,0x0
 26a:	27e080e7          	jalr	638(ra) # 4e4 <exit>

000000000000026e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 274:	87aa                	mv	a5,a0
 276:	0585                	addi	a1,a1,1
 278:	0785                	addi	a5,a5,1
 27a:	fff5c703          	lbu	a4,-1(a1)
 27e:	fee78fa3          	sb	a4,-1(a5)
 282:	fb75                	bnez	a4,276 <strcpy+0x8>
    ;
  return os;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb91                	beqz	a5,2a8 <strcmp+0x1e>
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00f71763          	bne	a4,a5,2a8 <strcmp+0x1e>
    p++, q++;
 29e:	0505                	addi	a0,a0,1
 2a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbe5                	bnez	a5,296 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a8:	0005c503          	lbu	a0,0(a1)
}
 2ac:	40a7853b          	subw	a0,a5,a0
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strlen>:

uint
strlen(const char *s)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cf91                	beqz	a5,2dc <strlen+0x26>
 2c2:	0505                	addi	a0,a0,1
 2c4:	87aa                	mv	a5,a0
 2c6:	4685                	li	a3,1
 2c8:	9e89                	subw	a3,a3,a0
 2ca:	00f6853b          	addw	a0,a3,a5
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff7c703          	lbu	a4,-1(a5)
 2d4:	fb7d                	bnez	a4,2ca <strlen+0x14>
    ;
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  for(n = 0; s[n]; n++)
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <strlen+0x20>

00000000000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e6:	ce09                	beqz	a2,300 <memset+0x20>
 2e8:	87aa                	mv	a5,a0
 2ea:	fff6071b          	addiw	a4,a2,-1
 2ee:	1702                	slli	a4,a4,0x20
 2f0:	9301                	srli	a4,a4,0x20
 2f2:	0705                	addi	a4,a4,1
 2f4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fa:	0785                	addi	a5,a5,1
 2fc:	fee79de3          	bne	a5,a4,2f6 <memset+0x16>
  }
  return dst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strchr>:

char*
strchr(const char *s, char c)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30c:	00054783          	lbu	a5,0(a0)
 310:	cb99                	beqz	a5,326 <strchr+0x20>
    if(*s == c)
 312:	00f58763          	beq	a1,a5,320 <strchr+0x1a>
  for(; *s; s++)
 316:	0505                	addi	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbfd                	bnez	a5,312 <strchr+0xc>
      return (char*)s;
  return 0;
 31e:	4501                	li	a0,0
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strchr+0x1a>

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	711d                	addi	sp,sp,-96
 32c:	ec86                	sd	ra,88(sp)
 32e:	e8a2                	sd	s0,80(sp)
 330:	e4a6                	sd	s1,72(sp)
 332:	e0ca                	sd	s2,64(sp)
 334:	fc4e                	sd	s3,56(sp)
 336:	f852                	sd	s4,48(sp)
 338:	f456                	sd	s5,40(sp)
 33a:	f05a                	sd	s6,32(sp)
 33c:	ec5e                	sd	s7,24(sp)
 33e:	1080                	addi	s0,sp,96
 340:	8baa                	mv	s7,a0
 342:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 344:	892a                	mv	s2,a0
 346:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 348:	4aa9                	li	s5,10
 34a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34c:	89a6                	mv	s3,s1
 34e:	2485                	addiw	s1,s1,1
 350:	0344d863          	bge	s1,s4,380 <gets+0x56>
    cc = read(0, &c, 1);
 354:	4605                	li	a2,1
 356:	faf40593          	addi	a1,s0,-81
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	1a0080e7          	jalr	416(ra) # 4fc <read>
    if(cc < 1)
 364:	00a05e63          	blez	a0,380 <gets+0x56>
    buf[i++] = c;
 368:	faf44783          	lbu	a5,-81(s0)
 36c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 370:	01578763          	beq	a5,s5,37e <gets+0x54>
 374:	0905                	addi	s2,s2,1
 376:	fd679be3          	bne	a5,s6,34c <gets+0x22>
  for(i=0; i+1 < max; ){
 37a:	89a6                	mv	s3,s1
 37c:	a011                	j	380 <gets+0x56>
 37e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 380:	99de                	add	s3,s3,s7
 382:	00098023          	sb	zero,0(s3)
  return buf;
}
 386:	855e                	mv	a0,s7
 388:	60e6                	ld	ra,88(sp)
 38a:	6446                	ld	s0,80(sp)
 38c:	64a6                	ld	s1,72(sp)
 38e:	6906                	ld	s2,64(sp)
 390:	79e2                	ld	s3,56(sp)
 392:	7a42                	ld	s4,48(sp)
 394:	7aa2                	ld	s5,40(sp)
 396:	7b02                	ld	s6,32(sp)
 398:	6be2                	ld	s7,24(sp)
 39a:	6125                	addi	sp,sp,96
 39c:	8082                	ret

000000000000039e <stat>:

int
stat(const char *n, struct stat *st)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	e426                	sd	s1,8(sp)
 3a6:	e04a                	sd	s2,0(sp)
 3a8:	1000                	addi	s0,sp,32
 3aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ac:	4581                	li	a1,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	176080e7          	jalr	374(ra) # 524 <open>
  if(fd < 0)
 3b6:	02054563          	bltz	a0,3e0 <stat+0x42>
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	00000097          	auipc	ra,0x0
 3c2:	17e080e7          	jalr	382(ra) # 53c <fstat>
 3c6:	892a                	mv	s2,a0
  close(fd);
 3c8:	8526                	mv	a0,s1
 3ca:	00000097          	auipc	ra,0x0
 3ce:	142080e7          	jalr	322(ra) # 50c <close>
  return r;
}
 3d2:	854a                	mv	a0,s2
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	64a2                	ld	s1,8(sp)
 3da:	6902                	ld	s2,0(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret
    return -1;
 3e0:	597d                	li	s2,-1
 3e2:	bfc5                	j	3d2 <stat+0x34>

00000000000003e4 <atoi>:

int
atoi(const char *s)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ea:	00054603          	lbu	a2,0(a0)
 3ee:	fd06079b          	addiw	a5,a2,-48
 3f2:	0ff7f793          	andi	a5,a5,255
 3f6:	4725                	li	a4,9
 3f8:	02f76963          	bltu	a4,a5,42a <atoi+0x46>
 3fc:	86aa                	mv	a3,a0
  n = 0;
 3fe:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 400:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 402:	0685                	addi	a3,a3,1
 404:	0025179b          	slliw	a5,a0,0x2
 408:	9fa9                	addw	a5,a5,a0
 40a:	0017979b          	slliw	a5,a5,0x1
 40e:	9fb1                	addw	a5,a5,a2
 410:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 414:	0006c603          	lbu	a2,0(a3)
 418:	fd06071b          	addiw	a4,a2,-48
 41c:	0ff77713          	andi	a4,a4,255
 420:	fee5f1e3          	bgeu	a1,a4,402 <atoi+0x1e>
  return n;
}
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret
  n = 0;
 42a:	4501                	li	a0,0
 42c:	bfe5                	j	424 <atoi+0x40>

000000000000042e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e422                	sd	s0,8(sp)
 432:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 434:	02b57663          	bgeu	a0,a1,460 <memmove+0x32>
    while(n-- > 0)
 438:	02c05163          	blez	a2,45a <memmove+0x2c>
 43c:	fff6079b          	addiw	a5,a2,-1
 440:	1782                	slli	a5,a5,0x20
 442:	9381                	srli	a5,a5,0x20
 444:	0785                	addi	a5,a5,1
 446:	97aa                	add	a5,a5,a0
  dst = vdst;
 448:	872a                	mv	a4,a0
      *dst++ = *src++;
 44a:	0585                	addi	a1,a1,1
 44c:	0705                	addi	a4,a4,1
 44e:	fff5c683          	lbu	a3,-1(a1)
 452:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 456:	fee79ae3          	bne	a5,a4,44a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
    dst += n;
 460:	00c50733          	add	a4,a0,a2
    src += n;
 464:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 466:	fec05ae3          	blez	a2,45a <memmove+0x2c>
 46a:	fff6079b          	addiw	a5,a2,-1
 46e:	1782                	slli	a5,a5,0x20
 470:	9381                	srli	a5,a5,0x20
 472:	fff7c793          	not	a5,a5
 476:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 478:	15fd                	addi	a1,a1,-1
 47a:	177d                	addi	a4,a4,-1
 47c:	0005c683          	lbu	a3,0(a1)
 480:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 484:	fee79ae3          	bne	a5,a4,478 <memmove+0x4a>
 488:	bfc9                	j	45a <memmove+0x2c>

000000000000048a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 490:	ca05                	beqz	a2,4c0 <memcmp+0x36>
 492:	fff6069b          	addiw	a3,a2,-1
 496:	1682                	slli	a3,a3,0x20
 498:	9281                	srli	a3,a3,0x20
 49a:	0685                	addi	a3,a3,1
 49c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	0005c703          	lbu	a4,0(a1)
 4a6:	00e79863          	bne	a5,a4,4b6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4aa:	0505                	addi	a0,a0,1
    p2++;
 4ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ae:	fed518e3          	bne	a0,a3,49e <memcmp+0x14>
  }
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	a019                	j	4ba <memcmp+0x30>
      return *p1 - *p2;
 4b6:	40e7853b          	subw	a0,a5,a4
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
  return 0;
 4c0:	4501                	li	a0,0
 4c2:	bfe5                	j	4ba <memcmp+0x30>

00000000000004c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e406                	sd	ra,8(sp)
 4c8:	e022                	sd	s0,0(sp)
 4ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4cc:	00000097          	auipc	ra,0x0
 4d0:	f62080e7          	jalr	-158(ra) # 42e <memmove>
}
 4d4:	60a2                	ld	ra,8(sp)
 4d6:	6402                	ld	s0,0(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4dc:	4885                	li	a7,1
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e4:	4889                	li	a7,2
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ec:	488d                	li	a7,3
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f4:	4891                	li	a7,4
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <read>:
.global read
read:
 li a7, SYS_read
 4fc:	4895                	li	a7,5
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <write>:
.global write
write:
 li a7, SYS_write
 504:	48c1                	li	a7,16
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <close>:
.global close
close:
 li a7, SYS_close
 50c:	48d5                	li	a7,21
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <kill>:
.global kill
kill:
 li a7, SYS_kill
 514:	4899                	li	a7,6
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <exec>:
.global exec
exec:
 li a7, SYS_exec
 51c:	489d                	li	a7,7
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <open>:
.global open
open:
 li a7, SYS_open
 524:	48bd                	li	a7,15
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 52c:	48c5                	li	a7,17
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 534:	48c9                	li	a7,18
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 53c:	48a1                	li	a7,8
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <link>:
.global link
link:
 li a7, SYS_link
 544:	48cd                	li	a7,19
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 54c:	48d1                	li	a7,20
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 554:	48a5                	li	a7,9
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <dup>:
.global dup
dup:
 li a7, SYS_dup
 55c:	48a9                	li	a7,10
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 564:	48ad                	li	a7,11
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 56c:	48b1                	li	a7,12
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 574:	48b5                	li	a7,13
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 57c:	48b9                	li	a7,14
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 584:	48d9                	li	a7,22
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <yield>:
.global yield
yield:
 li a7, SYS_yield
 58c:	48dd                	li	a7,23
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 594:	48e1                	li	a7,24
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 59c:	48e5                	li	a7,25
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 5a4:	48e9                	li	a7,26
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <ps>:
.global ps
ps:
 li a7, SYS_ps
 5ac:	48ed                	li	a7,27
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 5b4:	48f1                	li	a7,28
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 5bc:	48f5                	li	a7,29
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 5c4:	48f9                	li	a7,30
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 5cc:	48fd                	li	a7,31
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 5d4:	02000893          	li	a7,32
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 5de:	02100893          	li	a7,33
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 5e8:	02200893          	li	a7,34
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 5f2:	02300893          	li	a7,35
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 5fc:	02500893          	li	a7,37
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 606:	02400893          	li	a7,36
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 610:	02600893          	li	a7,38
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 61a:	02800893          	li	a7,40
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 624:	02700893          	li	a7,39
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62e:	1101                	addi	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63a:	4605                	li	a2,1
 63c:	fef40593          	addi	a1,s0,-17
 640:	00000097          	auipc	ra,0x0
 644:	ec4080e7          	jalr	-316(ra) # 504 <write>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6105                	addi	sp,sp,32
 64e:	8082                	ret

0000000000000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	7139                	addi	sp,sp,-64
 652:	fc06                	sd	ra,56(sp)
 654:	f822                	sd	s0,48(sp)
 656:	f426                	sd	s1,40(sp)
 658:	f04a                	sd	s2,32(sp)
 65a:	ec4e                	sd	s3,24(sp)
 65c:	0080                	addi	s0,sp,64
 65e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 660:	c299                	beqz	a3,666 <printint+0x16>
 662:	0805c863          	bltz	a1,6f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 666:	2581                	sext.w	a1,a1
  neg = 0;
 668:	4881                	li	a7,0
 66a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 670:	2601                	sext.w	a2,a2
 672:	00000517          	auipc	a0,0x0
 676:	4e650513          	addi	a0,a0,1254 # b58 <digits>
 67a:	883a                	mv	a6,a4
 67c:	2705                	addiw	a4,a4,1
 67e:	02c5f7bb          	remuw	a5,a1,a2
 682:	1782                	slli	a5,a5,0x20
 684:	9381                	srli	a5,a5,0x20
 686:	97aa                	add	a5,a5,a0
 688:	0007c783          	lbu	a5,0(a5)
 68c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 690:	0005879b          	sext.w	a5,a1
 694:	02c5d5bb          	divuw	a1,a1,a2
 698:	0685                	addi	a3,a3,1
 69a:	fec7f0e3          	bgeu	a5,a2,67a <printint+0x2a>
  if(neg)
 69e:	00088b63          	beqz	a7,6b4 <printint+0x64>
    buf[i++] = '-';
 6a2:	fd040793          	addi	a5,s0,-48
 6a6:	973e                	add	a4,a4,a5
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x94>
 6b8:	fc040793          	addi	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	addi	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	1702                	slli	a4,a4,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f58080e7          	jalr	-168(ra) # 62e <putc>
  while(--i >= 0)
 6de:	197d                	addi	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x80>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf8d                	j	66a <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	7119                	addi	sp,sp,-128
 6fc:	fc86                	sd	ra,120(sp)
 6fe:	f8a2                	sd	s0,112(sp)
 700:	f4a6                	sd	s1,104(sp)
 702:	f0ca                	sd	s2,96(sp)
 704:	ecce                	sd	s3,88(sp)
 706:	e8d2                	sd	s4,80(sp)
 708:	e4d6                	sd	s5,72(sp)
 70a:	e0da                	sd	s6,64(sp)
 70c:	fc5e                	sd	s7,56(sp)
 70e:	f862                	sd	s8,48(sp)
 710:	f466                	sd	s9,40(sp)
 712:	f06a                	sd	s10,32(sp)
 714:	ec6e                	sd	s11,24(sp)
 716:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 718:	0005c903          	lbu	s2,0(a1)
 71c:	18090f63          	beqz	s2,8ba <vprintf+0x1c0>
 720:	8aaa                	mv	s5,a0
 722:	8b32                	mv	s6,a2
 724:	00158493          	addi	s1,a1,1
  state = 0;
 728:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	02500a13          	li	s4,37
      if(c == 'd'){
 72e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 732:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 736:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 73a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	41ab8b93          	addi	s7,s7,1050 # b58 <digits>
 746:	a839                	j	764 <vprintf+0x6a>
        putc(fd, c);
 748:	85ca                	mv	a1,s2
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ee2080e7          	jalr	-286(ra) # 62e <putc>
 754:	a019                	j	75a <vprintf+0x60>
    } else if(state == '%'){
 756:	01498f63          	beq	s3,s4,774 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 75a:	0485                	addi	s1,s1,1
 75c:	fff4c903          	lbu	s2,-1(s1)
 760:	14090d63          	beqz	s2,8ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 764:	0009079b          	sext.w	a5,s2
    if(state == 0){
 768:	fe0997e3          	bnez	s3,756 <vprintf+0x5c>
      if(c == '%'){
 76c:	fd479ee3          	bne	a5,s4,748 <vprintf+0x4e>
        state = '%';
 770:	89be                	mv	s3,a5
 772:	b7e5                	j	75a <vprintf+0x60>
      if(c == 'd'){
 774:	05878063          	beq	a5,s8,7b4 <vprintf+0xba>
      } else if(c == 'l') {
 778:	05978c63          	beq	a5,s9,7d0 <vprintf+0xd6>
      } else if(c == 'x') {
 77c:	07a78863          	beq	a5,s10,7ec <vprintf+0xf2>
      } else if(c == 'p') {
 780:	09b78463          	beq	a5,s11,808 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 784:	07300713          	li	a4,115
 788:	0ce78663          	beq	a5,a4,854 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	06300713          	li	a4,99
 790:	0ee78e63          	beq	a5,a4,88c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 794:	11478863          	beq	a5,s4,8a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 798:	85d2                	mv	a1,s4
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e92080e7          	jalr	-366(ra) # 62e <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e86080e7          	jalr	-378(ra) # 62e <putc>
      }
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b765                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000b2583          	lw	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8e080e7          	jalr	-370(ra) # 650 <printint>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b771                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e72080e7          	jalr	-398(ra) # 650 <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bf85                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000b2583          	lw	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e56080e7          	jalr	-426(ra) # 650 <printint>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bf91                	j	75a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 808:	008b0793          	addi	a5,s6,8
 80c:	f8f43423          	sd	a5,-120(s0)
 810:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e14080e7          	jalr	-492(ra) # 62e <putc>
  putc(fd, 'x');
 822:	85ea                	mv	a1,s10
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e08080e7          	jalr	-504(ra) # 62e <putc>
 82e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 830:	03c9d793          	srli	a5,s3,0x3c
 834:	97de                	add	a5,a5,s7
 836:	0007c583          	lbu	a1,0(a5)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df2080e7          	jalr	-526(ra) # 62e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	0992                	slli	s3,s3,0x4
 846:	397d                	addiw	s2,s2,-1
 848:	fe0914e3          	bnez	s2,830 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 84c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 850:	4981                	li	s3,0
 852:	b721                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 854:	008b0993          	addi	s3,s6,8
 858:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 85c:	02090163          	beqz	s2,87e <vprintf+0x184>
        while(*s != 0){
 860:	00094583          	lbu	a1,0(s2)
 864:	c9a1                	beqz	a1,8b4 <vprintf+0x1ba>
          putc(fd, *s);
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	dc6080e7          	jalr	-570(ra) # 62e <putc>
          s++;
 870:	0905                	addi	s2,s2,1
        while(*s != 0){
 872:	00094583          	lbu	a1,0(s2)
 876:	f9e5                	bnez	a1,866 <vprintf+0x16c>
        s = va_arg(ap, char*);
 878:	8b4e                	mv	s6,s3
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdf9                	j	75a <vprintf+0x60>
          s = "(null)";
 87e:	00000917          	auipc	s2,0x0
 882:	2d290913          	addi	s2,s2,722 # b50 <malloc+0x18c>
        while(*s != 0){
 886:	02800593          	li	a1,40
 88a:	bff1                	j	866 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 88c:	008b0913          	addi	s2,s6,8
 890:	000b4583          	lbu	a1,0(s6)
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	d98080e7          	jalr	-616(ra) # 62e <putc>
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd65                	j	75a <vprintf+0x60>
        putc(fd, c);
 8a4:	85d2                	mv	a1,s4
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	d86080e7          	jalr	-634(ra) # 62e <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b565                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 8b4:	8b4e                	mv	s6,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b54d                	j	75a <vprintf+0x60>
    }
  }
}
 8ba:	70e6                	ld	ra,120(sp)
 8bc:	7446                	ld	s0,112(sp)
 8be:	74a6                	ld	s1,104(sp)
 8c0:	7906                	ld	s2,96(sp)
 8c2:	69e6                	ld	s3,88(sp)
 8c4:	6a46                	ld	s4,80(sp)
 8c6:	6aa6                	ld	s5,72(sp)
 8c8:	6b06                	ld	s6,64(sp)
 8ca:	7be2                	ld	s7,56(sp)
 8cc:	7c42                	ld	s8,48(sp)
 8ce:	7ca2                	ld	s9,40(sp)
 8d0:	7d02                	ld	s10,32(sp)
 8d2:	6de2                	ld	s11,24(sp)
 8d4:	6109                	addi	sp,sp,128
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e04080e7          	jalr	-508(ra) # 6fa <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	dce080e7          	jalr	-562(ra) # 6fa <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	23a7b783          	ld	a5,570(a5) # b80 <freep>
 94e:	a805                	j	97e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9db9                	addw	a1,a1,a4
 954:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6318                	ld	a4,0(a4)
 95c:	fee53823          	sd	a4,-16(a0)
 960:	a091                	j	9a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 962:	ff852703          	lw	a4,-8(a0)
 966:	9e39                	addw	a2,a2,a4
 968:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 96a:	ff053703          	ld	a4,-16(a0)
 96e:	e398                	sd	a4,0(a5)
 970:	a099                	j	9b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	6398                	ld	a4,0(a5)
 974:	00e7e463          	bltu	a5,a4,97c <free+0x40>
 978:	00e6ea63          	bltu	a3,a4,98c <free+0x50>
{
 97c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	fed7fae3          	bgeu	a5,a3,972 <free+0x36>
 982:	6398                	ld	a4,0(a5)
 984:	00e6e463          	bltu	a3,a4,98c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	fee7eae3          	bltu	a5,a4,97c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 98c:	ff852583          	lw	a1,-8(a0)
 990:	6390                	ld	a2,0(a5)
 992:	02059713          	slli	a4,a1,0x20
 996:	9301                	srli	a4,a4,0x20
 998:	0712                	slli	a4,a4,0x4
 99a:	9736                	add	a4,a4,a3
 99c:	fae60ae3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a4:	4790                	lw	a2,8(a5)
 9a6:	02061713          	slli	a4,a2,0x20
 9aa:	9301                	srli	a4,a4,0x20
 9ac:	0712                	slli	a4,a4,0x4
 9ae:	973e                	add	a4,a4,a5
 9b0:	fae689e3          	beq	a3,a4,962 <free+0x26>
  } else
    p->s.ptr = bp;
 9b4:	e394                	sd	a3,0(a5)
  freep = p;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	1cf73523          	sd	a5,458(a4) # b80 <freep>
}
 9be:	6422                	ld	s0,8(sp)
 9c0:	0141                	addi	sp,sp,16
 9c2:	8082                	ret

00000000000009c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c4:	7139                	addi	sp,sp,-64
 9c6:	fc06                	sd	ra,56(sp)
 9c8:	f822                	sd	s0,48(sp)
 9ca:	f426                	sd	s1,40(sp)
 9cc:	f04a                	sd	s2,32(sp)
 9ce:	ec4e                	sd	s3,24(sp)
 9d0:	e852                	sd	s4,16(sp)
 9d2:	e456                	sd	s5,8(sp)
 9d4:	e05a                	sd	s6,0(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e8:	00000517          	auipc	a0,0x0
 9ec:	19853503          	ld	a0,408(a0) # b80 <freep>
 9f0:	c515                	beqz	a0,a1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	02977f63          	bgeu	a4,s1,a34 <malloc+0x70>
 9fa:	8a4e                	mv	s4,s3
 9fc:	0009871b          	sext.w	a4,s3
 a00:	6685                	lui	a3,0x1
 a02:	00d77363          	bgeu	a4,a3,a08 <malloc+0x44>
 a06:	6a05                	lui	s4,0x1
 a08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a10:	00000917          	auipc	s2,0x0
 a14:	17090913          	addi	s2,s2,368 # b80 <freep>
  if(p == (char*)-1)
 a18:	5afd                	li	s5,-1
 a1a:	a88d                	j	a8c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a1c:	00000797          	auipc	a5,0x0
 a20:	16c78793          	addi	a5,a5,364 # b88 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	14f73e23          	sd	a5,348(a4) # b80 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7e1                	j	9fa <malloc+0x36>
      if(p->s.size == nunits)
 a34:	02e48b63          	beq	s1,a4,a6a <malloc+0xa6>
        p->s.size -= nunits;
 a38:	4137073b          	subw	a4,a4,s3
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	1702                	slli	a4,a4,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	12a73b23          	sd	a0,310(a4) # b80 <freep>
      return (void*)(p + 1);
 a52:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	74a2                	ld	s1,40(sp)
 a5c:	7902                	ld	s2,32(sp)
 a5e:	69e2                	ld	s3,24(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
 a66:	6121                	addi	sp,sp,64
 a68:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a6a:	6398                	ld	a4,0(a5)
 a6c:	e118                	sd	a4,0(a0)
 a6e:	bff1                	j	a4a <malloc+0x86>
  hp->s.size = nu;
 a70:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a74:	0541                	addi	a0,a0,16
 a76:	00000097          	auipc	ra,0x0
 a7a:	ec6080e7          	jalr	-314(ra) # 93c <free>
  return freep;
 a7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a82:	d971                	beqz	a0,a56 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	fa9776e3          	bgeu	a4,s1,a34 <malloc+0x70>
    if(p == freep)
 a8c:	00093703          	ld	a4,0(s2)
 a90:	853e                	mv	a0,a5
 a92:	fef719e3          	bne	a4,a5,a84 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	00000097          	auipc	ra,0x0
 a9c:	ad4080e7          	jalr	-1324(ra) # 56c <sbrk>
  if(p == (char*)-1)
 aa0:	fd5518e3          	bne	a0,s5,a70 <malloc+0xac>
        return 0;
 aa4:	4501                	li	a0,0
 aa6:	bf45                	j	a56 <malloc+0x92>
