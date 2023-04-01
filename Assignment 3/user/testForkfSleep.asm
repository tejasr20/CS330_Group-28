
user/_testForkfSleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f>:
{
   return x*x;
}

int f (void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   int x = 10;

   fprintf(2, "Hello world! %d\n", g(x));
   8:	06400613          	li	a2,100
   c:	00001597          	auipc	a1,0x1
  10:	99458593          	addi	a1,a1,-1644 # 9a0 <malloc+0xe6>
  14:	4509                	li	a0,2
  16:	00000097          	auipc	ra,0x0
  1a:	7b8080e7          	jalr	1976(ra) # 7ce <fprintf>
   return 0;
}
  1e:	4501                	li	a0,0
  20:	60a2                	ld	ra,8(sp)
  22:	6402                	ld	s0,0(sp)
  24:	0141                	addi	sp,sp,16
  26:	8082                	ret

0000000000000028 <g>:
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
}
  2e:	02a5053b          	mulw	a0,a0,a0
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <main>:

int
main(int argc, char *argv[])
{
  38:	1101                	addi	sp,sp,-32
  3a:	ec06                	sd	ra,24(sp)
  3c:	e822                	sd	s0,16(sp)
  3e:	e426                	sd	s1,8(sp)
  40:	e04a                	sd	s2,0(sp)
  42:	1000                	addi	s0,sp,32
  int m, n, x;

  if (argc != 3) {
  44:	478d                	li	a5,3
  46:	02f50063          	beq	a0,a5,66 <main+0x2e>
     fprintf(2, "syntax: testForkfSleep m n\nAborting...\n");
  4a:	00001597          	auipc	a1,0x1
  4e:	96e58593          	addi	a1,a1,-1682 # 9b8 <malloc+0xfe>
  52:	4509                	li	a0,2
  54:	00000097          	auipc	ra,0x0
  58:	77a080e7          	jalr	1914(ra) # 7ce <fprintf>
     exit(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	37c080e7          	jalr	892(ra) # 3da <exit>
  66:	84ae                	mv	s1,a1
  }

  m = atoi(argv[1]);
  68:	6588                	ld	a0,8(a1)
  6a:	00000097          	auipc	ra,0x0
  6e:	270080e7          	jalr	624(ra) # 2da <atoi>
  72:	892a                	mv	s2,a0
  if (m <= 0) {
  74:	02a05b63          	blez	a0,aa <main+0x72>
     fprintf(2, "Invalid input\nAborting...\n");
     exit(0);
  }
  n = atoi(argv[2]);
  78:	6888                	ld	a0,16(s1)
  7a:	00000097          	auipc	ra,0x0
  7e:	260080e7          	jalr	608(ra) # 2da <atoi>
  82:	84aa                	mv	s1,a0
  if ((n != 0) && (n != 1)) {
  84:	0005071b          	sext.w	a4,a0
  88:	4785                	li	a5,1
  8a:	02e7fe63          	bgeu	a5,a4,c6 <main+0x8e>
     fprintf(2, "Invalid input\nAborting...\n");
  8e:	00001597          	auipc	a1,0x1
  92:	95258593          	addi	a1,a1,-1710 # 9e0 <malloc+0x126>
  96:	4509                	li	a0,2
  98:	00000097          	auipc	ra,0x0
  9c:	736080e7          	jalr	1846(ra) # 7ce <fprintf>
     exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	338080e7          	jalr	824(ra) # 3da <exit>
     fprintf(2, "Invalid input\nAborting...\n");
  aa:	00001597          	auipc	a1,0x1
  ae:	93658593          	addi	a1,a1,-1738 # 9e0 <malloc+0x126>
  b2:	4509                	li	a0,2
  b4:	00000097          	auipc	ra,0x0
  b8:	71a080e7          	jalr	1818(ra) # 7ce <fprintf>
     exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	31c080e7          	jalr	796(ra) # 3da <exit>
  }

  x = forkf(f);
  c6:	00000517          	auipc	a0,0x0
  ca:	f3a50513          	addi	a0,a0,-198 # 0 <f>
  ce:	00000097          	auipc	ra,0x0
  d2:	3c4080e7          	jalr	964(ra) # 492 <forkf>
  if (x < 0) {
  d6:	02054d63          	bltz	a0,110 <main+0xd8>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  da:	04a05f63          	blez	a0,138 <main+0x100>
     if (n) sleep(m);
  de:	e4b9                	bnez	s1,12c <main+0xf4>
     fprintf(1, "%d: Parent.\n", getpid());
  e0:	00000097          	auipc	ra,0x0
  e4:	37a080e7          	jalr	890(ra) # 45a <getpid>
  e8:	862a                	mv	a2,a0
  ea:	00001597          	auipc	a1,0x1
  ee:	93658593          	addi	a1,a1,-1738 # a20 <malloc+0x166>
  f2:	4505                	li	a0,1
  f4:	00000097          	auipc	ra,0x0
  f8:	6da080e7          	jalr	1754(ra) # 7ce <fprintf>
     wait(0);
  fc:	4501                	li	a0,0
  fe:	00000097          	auipc	ra,0x0
 102:	2e4080e7          	jalr	740(ra) # 3e2 <wait>
  else {
     if (!n) sleep(m);
     fprintf(1, "%d: Child.\n", getpid());
  }

  exit(0);
 106:	4501                	li	a0,0
 108:	00000097          	auipc	ra,0x0
 10c:	2d2080e7          	jalr	722(ra) # 3da <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
 110:	00001597          	auipc	a1,0x1
 114:	8f058593          	addi	a1,a1,-1808 # a00 <malloc+0x146>
 118:	4509                	li	a0,2
 11a:	00000097          	auipc	ra,0x0
 11e:	6b4080e7          	jalr	1716(ra) # 7ce <fprintf>
     exit(0);
 122:	4501                	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	2b6080e7          	jalr	694(ra) # 3da <exit>
     if (n) sleep(m);
 12c:	854a                	mv	a0,s2
 12e:	00000097          	auipc	ra,0x0
 132:	33c080e7          	jalr	828(ra) # 46a <sleep>
 136:	b76d                	j	e0 <main+0xa8>
     if (!n) sleep(m);
 138:	c085                	beqz	s1,158 <main+0x120>
     fprintf(1, "%d: Child.\n", getpid());
 13a:	00000097          	auipc	ra,0x0
 13e:	320080e7          	jalr	800(ra) # 45a <getpid>
 142:	862a                	mv	a2,a0
 144:	00001597          	auipc	a1,0x1
 148:	8ec58593          	addi	a1,a1,-1812 # a30 <malloc+0x176>
 14c:	4505                	li	a0,1
 14e:	00000097          	auipc	ra,0x0
 152:	680080e7          	jalr	1664(ra) # 7ce <fprintf>
 156:	bf45                	j	106 <main+0xce>
     if (!n) sleep(m);
 158:	854a                	mv	a0,s2
 15a:	00000097          	auipc	ra,0x0
 15e:	310080e7          	jalr	784(ra) # 46a <sleep>
 162:	bfe1                	j	13a <main+0x102>

0000000000000164 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	87aa                	mv	a5,a0
 16c:	0585                	addi	a1,a1,1
 16e:	0785                	addi	a5,a5,1
 170:	fff5c703          	lbu	a4,-1(a1)
 174:	fee78fa3          	sb	a4,-1(a5)
 178:	fb75                	bnez	a4,16c <strcpy+0x8>
    ;
  return os;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cb91                	beqz	a5,19e <strcmp+0x1e>
 18c:	0005c703          	lbu	a4,0(a1)
 190:	00f71763          	bne	a4,a5,19e <strcmp+0x1e>
    p++, q++;
 194:	0505                	addi	a0,a0,1
 196:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 198:	00054783          	lbu	a5,0(a0)
 19c:	fbe5                	bnez	a5,18c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19e:	0005c503          	lbu	a0,0(a1)
}
 1a2:	40a7853b          	subw	a0,a5,a0
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strlen>:

uint
strlen(const char *s)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf91                	beqz	a5,1d2 <strlen+0x26>
 1b8:	0505                	addi	a0,a0,1
 1ba:	87aa                	mv	a5,a0
 1bc:	4685                	li	a3,1
 1be:	9e89                	subw	a3,a3,a0
 1c0:	00f6853b          	addw	a0,a3,a5
 1c4:	0785                	addi	a5,a5,1
 1c6:	fff7c703          	lbu	a4,-1(a5)
 1ca:	fb7d                	bnez	a4,1c0 <strlen+0x14>
    ;
  return n;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  for(n = 0; s[n]; n++)
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strlen+0x20>

00000000000001d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1dc:	ce09                	beqz	a2,1f6 <memset+0x20>
 1de:	87aa                	mv	a5,a0
 1e0:	fff6071b          	addiw	a4,a2,-1
 1e4:	1702                	slli	a4,a4,0x20
 1e6:	9301                	srli	a4,a4,0x20
 1e8:	0705                	addi	a4,a4,1
 1ea:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f0:	0785                	addi	a5,a5,1
 1f2:	fee79de3          	bne	a5,a4,1ec <memset+0x16>
  }
  return dst;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  for(; *s; s++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cb99                	beqz	a5,21c <strchr+0x20>
    if(*s == c)
 208:	00f58763          	beq	a1,a5,216 <strchr+0x1a>
  for(; *s; s++)
 20c:	0505                	addi	a0,a0,1
 20e:	00054783          	lbu	a5,0(a0)
 212:	fbfd                	bnez	a5,208 <strchr+0xc>
      return (char*)s;
  return 0;
 214:	4501                	li	a0,0
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
  return 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <strchr+0x1a>

0000000000000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	711d                	addi	sp,sp,-96
 222:	ec86                	sd	ra,88(sp)
 224:	e8a2                	sd	s0,80(sp)
 226:	e4a6                	sd	s1,72(sp)
 228:	e0ca                	sd	s2,64(sp)
 22a:	fc4e                	sd	s3,56(sp)
 22c:	f852                	sd	s4,48(sp)
 22e:	f456                	sd	s5,40(sp)
 230:	f05a                	sd	s6,32(sp)
 232:	ec5e                	sd	s7,24(sp)
 234:	1080                	addi	s0,sp,96
 236:	8baa                	mv	s7,a0
 238:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	892a                	mv	s2,a0
 23c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4aa9                	li	s5,10
 240:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 242:	89a6                	mv	s3,s1
 244:	2485                	addiw	s1,s1,1
 246:	0344d863          	bge	s1,s4,276 <gets+0x56>
    cc = read(0, &c, 1);
 24a:	4605                	li	a2,1
 24c:	faf40593          	addi	a1,s0,-81
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	1a0080e7          	jalr	416(ra) # 3f2 <read>
    if(cc < 1)
 25a:	00a05e63          	blez	a0,276 <gets+0x56>
    buf[i++] = c;
 25e:	faf44783          	lbu	a5,-81(s0)
 262:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 266:	01578763          	beq	a5,s5,274 <gets+0x54>
 26a:	0905                	addi	s2,s2,1
 26c:	fd679be3          	bne	a5,s6,242 <gets+0x22>
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	a011                	j	276 <gets+0x56>
 274:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 276:	99de                	add	s3,s3,s7
 278:	00098023          	sb	zero,0(s3)
  return buf;
}
 27c:	855e                	mv	a0,s7
 27e:	60e6                	ld	ra,88(sp)
 280:	6446                	ld	s0,80(sp)
 282:	64a6                	ld	s1,72(sp)
 284:	6906                	ld	s2,64(sp)
 286:	79e2                	ld	s3,56(sp)
 288:	7a42                	ld	s4,48(sp)
 28a:	7aa2                	ld	s5,40(sp)
 28c:	7b02                	ld	s6,32(sp)
 28e:	6be2                	ld	s7,24(sp)
 290:	6125                	addi	sp,sp,96
 292:	8082                	ret

0000000000000294 <stat>:

int
stat(const char *n, struct stat *st)
{
 294:	1101                	addi	sp,sp,-32
 296:	ec06                	sd	ra,24(sp)
 298:	e822                	sd	s0,16(sp)
 29a:	e426                	sd	s1,8(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	00000097          	auipc	ra,0x0
 2a8:	176080e7          	jalr	374(ra) # 41a <open>
  if(fd < 0)
 2ac:	02054563          	bltz	a0,2d6 <stat+0x42>
 2b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b2:	85ca                	mv	a1,s2
 2b4:	00000097          	auipc	ra,0x0
 2b8:	17e080e7          	jalr	382(ra) # 432 <fstat>
 2bc:	892a                	mv	s2,a0
  close(fd);
 2be:	8526                	mv	a0,s1
 2c0:	00000097          	auipc	ra,0x0
 2c4:	142080e7          	jalr	322(ra) # 402 <close>
  return r;
}
 2c8:	854a                	mv	a0,s2
 2ca:	60e2                	ld	ra,24(sp)
 2cc:	6442                	ld	s0,16(sp)
 2ce:	64a2                	ld	s1,8(sp)
 2d0:	6902                	ld	s2,0(sp)
 2d2:	6105                	addi	sp,sp,32
 2d4:	8082                	ret
    return -1;
 2d6:	597d                	li	s2,-1
 2d8:	bfc5                	j	2c8 <stat+0x34>

00000000000002da <atoi>:

int
atoi(const char *s)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e0:	00054603          	lbu	a2,0(a0)
 2e4:	fd06079b          	addiw	a5,a2,-48
 2e8:	0ff7f793          	andi	a5,a5,255
 2ec:	4725                	li	a4,9
 2ee:	02f76963          	bltu	a4,a5,320 <atoi+0x46>
 2f2:	86aa                	mv	a3,a0
  n = 0;
 2f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f8:	0685                	addi	a3,a3,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb1                	addw	a5,a5,a2
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	0006c603          	lbu	a2,0(a3)
 30e:	fd06071b          	addiw	a4,a2,-48
 312:	0ff77713          	andi	a4,a4,255
 316:	fee5f1e3          	bgeu	a1,a4,2f8 <atoi+0x1e>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x40>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57663          	bgeu	a0,a1,356 <memmove+0x32>
    while(n-- > 0)
 32e:	02c05163          	blez	a2,350 <memmove+0x2c>
 332:	fff6079b          	addiw	a5,a2,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	0785                	addi	a5,a5,1
 33c:	97aa                	add	a5,a5,a0
  dst = vdst;
 33e:	872a                	mv	a4,a0
      *dst++ = *src++;
 340:	0585                	addi	a1,a1,1
 342:	0705                	addi	a4,a4,1
 344:	fff5c683          	lbu	a3,-1(a1)
 348:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35c:	fec05ae3          	blez	a2,350 <memmove+0x2c>
 360:	fff6079b          	addiw	a5,a2,-1
 364:	1782                	slli	a5,a5,0x20
 366:	9381                	srli	a5,a5,0x20
 368:	fff7c793          	not	a5,a5
 36c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36e:	15fd                	addi	a1,a1,-1
 370:	177d                	addi	a4,a4,-1
 372:	0005c683          	lbu	a3,0(a1)
 376:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x4a>
 37e:	bfc9                	j	350 <memmove+0x2c>

0000000000000380 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 386:	ca05                	beqz	a2,3b6 <memcmp+0x36>
 388:	fff6069b          	addiw	a3,a2,-1
 38c:	1682                	slli	a3,a3,0x20
 38e:	9281                	srli	a3,a3,0x20
 390:	0685                	addi	a3,a3,1
 392:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 394:	00054783          	lbu	a5,0(a0)
 398:	0005c703          	lbu	a4,0(a1)
 39c:	00e79863          	bne	a5,a4,3ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a0:	0505                	addi	a0,a0,1
    p2++;
 3a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a4:	fed518e3          	bne	a0,a3,394 <memcmp+0x14>
  }
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	a019                	j	3b0 <memcmp+0x30>
      return *p1 - *p2;
 3ac:	40e7853b          	subw	a0,a5,a4
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <memcmp+0x30>

00000000000003ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c2:	00000097          	auipc	ra,0x0
 3c6:	f62080e7          	jalr	-158(ra) # 324 <memmove>
}
 3ca:	60a2                	ld	ra,8(sp)
 3cc:	6402                	ld	s0,0(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d2:	4885                	li	a7,1
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exit>:
.global exit
exit:
 li a7, SYS_exit
 3da:	4889                	li	a7,2
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e2:	488d                	li	a7,3
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ea:	4891                	li	a7,4
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <read>:
.global read
read:
 li a7, SYS_read
 3f2:	4895                	li	a7,5
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <write>:
.global write
write:
 li a7, SYS_write
 3fa:	48c1                	li	a7,16
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <close>:
.global close
close:
 li a7, SYS_close
 402:	48d5                	li	a7,21
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <kill>:
.global kill
kill:
 li a7, SYS_kill
 40a:	4899                	li	a7,6
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exec>:
.global exec
exec:
 li a7, SYS_exec
 412:	489d                	li	a7,7
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <open>:
.global open
open:
 li a7, SYS_open
 41a:	48bd                	li	a7,15
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 422:	48c5                	li	a7,17
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42a:	48c9                	li	a7,18
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 432:	48a1                	li	a7,8
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <link>:
.global link
link:
 li a7, SYS_link
 43a:	48cd                	li	a7,19
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 442:	48d1                	li	a7,20
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44a:	48a5                	li	a7,9
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <dup>:
.global dup
dup:
 li a7, SYS_dup
 452:	48a9                	li	a7,10
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45a:	48ad                	li	a7,11
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 462:	48b1                	li	a7,12
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46a:	48b5                	li	a7,13
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 472:	48b9                	li	a7,14
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 47a:	48d9                	li	a7,22
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <yield>:
.global yield
yield:
 li a7, SYS_yield
 482:	48dd                	li	a7,23
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 48a:	48e1                	li	a7,24
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 492:	48e5                	li	a7,25
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 49a:	48e9                	li	a7,26
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <ps>:
.global ps
ps:
 li a7, SYS_ps
 4a2:	48ed                	li	a7,27
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 4aa:	48f1                	li	a7,28
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 4b2:	48f5                	li	a7,29
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 4ba:	48f9                	li	a7,30
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 4c2:	48fd                	li	a7,31
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 4ca:	02000893          	li	a7,32
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 4d4:	02100893          	li	a7,33
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 4de:	02200893          	li	a7,34
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 4e8:	02300893          	li	a7,35
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 4f2:	02500893          	li	a7,37
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 4fc:	02400893          	li	a7,36
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 506:	02600893          	li	a7,38
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 510:	02800893          	li	a7,40
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 51a:	02700893          	li	a7,39
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 524:	1101                	addi	sp,sp,-32
 526:	ec06                	sd	ra,24(sp)
 528:	e822                	sd	s0,16(sp)
 52a:	1000                	addi	s0,sp,32
 52c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 530:	4605                	li	a2,1
 532:	fef40593          	addi	a1,s0,-17
 536:	00000097          	auipc	ra,0x0
 53a:	ec4080e7          	jalr	-316(ra) # 3fa <write>
}
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret

0000000000000546 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 546:	7139                	addi	sp,sp,-64
 548:	fc06                	sd	ra,56(sp)
 54a:	f822                	sd	s0,48(sp)
 54c:	f426                	sd	s1,40(sp)
 54e:	f04a                	sd	s2,32(sp)
 550:	ec4e                	sd	s3,24(sp)
 552:	0080                	addi	s0,sp,64
 554:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 556:	c299                	beqz	a3,55c <printint+0x16>
 558:	0805c863          	bltz	a1,5e8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55c:	2581                	sext.w	a1,a1
  neg = 0;
 55e:	4881                	li	a7,0
 560:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 564:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 566:	2601                	sext.w	a2,a2
 568:	00000517          	auipc	a0,0x0
 56c:	4e050513          	addi	a0,a0,1248 # a48 <digits>
 570:	883a                	mv	a6,a4
 572:	2705                	addiw	a4,a4,1
 574:	02c5f7bb          	remuw	a5,a1,a2
 578:	1782                	slli	a5,a5,0x20
 57a:	9381                	srli	a5,a5,0x20
 57c:	97aa                	add	a5,a5,a0
 57e:	0007c783          	lbu	a5,0(a5)
 582:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 586:	0005879b          	sext.w	a5,a1
 58a:	02c5d5bb          	divuw	a1,a1,a2
 58e:	0685                	addi	a3,a3,1
 590:	fec7f0e3          	bgeu	a5,a2,570 <printint+0x2a>
  if(neg)
 594:	00088b63          	beqz	a7,5aa <printint+0x64>
    buf[i++] = '-';
 598:	fd040793          	addi	a5,s0,-48
 59c:	973e                	add	a4,a4,a5
 59e:	02d00793          	li	a5,45
 5a2:	fef70823          	sb	a5,-16(a4)
 5a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5aa:	02e05863          	blez	a4,5da <printint+0x94>
 5ae:	fc040793          	addi	a5,s0,-64
 5b2:	00e78933          	add	s2,a5,a4
 5b6:	fff78993          	addi	s3,a5,-1
 5ba:	99ba                	add	s3,s3,a4
 5bc:	377d                	addiw	a4,a4,-1
 5be:	1702                	slli	a4,a4,0x20
 5c0:	9301                	srli	a4,a4,0x20
 5c2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c6:	fff94583          	lbu	a1,-1(s2)
 5ca:	8526                	mv	a0,s1
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f58080e7          	jalr	-168(ra) # 524 <putc>
  while(--i >= 0)
 5d4:	197d                	addi	s2,s2,-1
 5d6:	ff3918e3          	bne	s2,s3,5c6 <printint+0x80>
}
 5da:	70e2                	ld	ra,56(sp)
 5dc:	7442                	ld	s0,48(sp)
 5de:	74a2                	ld	s1,40(sp)
 5e0:	7902                	ld	s2,32(sp)
 5e2:	69e2                	ld	s3,24(sp)
 5e4:	6121                	addi	sp,sp,64
 5e6:	8082                	ret
    x = -xx;
 5e8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ec:	4885                	li	a7,1
    x = -xx;
 5ee:	bf8d                	j	560 <printint+0x1a>

00000000000005f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f0:	7119                	addi	sp,sp,-128
 5f2:	fc86                	sd	ra,120(sp)
 5f4:	f8a2                	sd	s0,112(sp)
 5f6:	f4a6                	sd	s1,104(sp)
 5f8:	f0ca                	sd	s2,96(sp)
 5fa:	ecce                	sd	s3,88(sp)
 5fc:	e8d2                	sd	s4,80(sp)
 5fe:	e4d6                	sd	s5,72(sp)
 600:	e0da                	sd	s6,64(sp)
 602:	fc5e                	sd	s7,56(sp)
 604:	f862                	sd	s8,48(sp)
 606:	f466                	sd	s9,40(sp)
 608:	f06a                	sd	s10,32(sp)
 60a:	ec6e                	sd	s11,24(sp)
 60c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60e:	0005c903          	lbu	s2,0(a1)
 612:	18090f63          	beqz	s2,7b0 <vprintf+0x1c0>
 616:	8aaa                	mv	s5,a0
 618:	8b32                	mv	s6,a2
 61a:	00158493          	addi	s1,a1,1
  state = 0;
 61e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 620:	02500a13          	li	s4,37
      if(c == 'd'){
 624:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 628:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 62c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 630:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 634:	00000b97          	auipc	s7,0x0
 638:	414b8b93          	addi	s7,s7,1044 # a48 <digits>
 63c:	a839                	j	65a <vprintf+0x6a>
        putc(fd, c);
 63e:	85ca                	mv	a1,s2
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	ee2080e7          	jalr	-286(ra) # 524 <putc>
 64a:	a019                	j	650 <vprintf+0x60>
    } else if(state == '%'){
 64c:	01498f63          	beq	s3,s4,66a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 650:	0485                	addi	s1,s1,1
 652:	fff4c903          	lbu	s2,-1(s1)
 656:	14090d63          	beqz	s2,7b0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 65a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 65e:	fe0997e3          	bnez	s3,64c <vprintf+0x5c>
      if(c == '%'){
 662:	fd479ee3          	bne	a5,s4,63e <vprintf+0x4e>
        state = '%';
 666:	89be                	mv	s3,a5
 668:	b7e5                	j	650 <vprintf+0x60>
      if(c == 'd'){
 66a:	05878063          	beq	a5,s8,6aa <vprintf+0xba>
      } else if(c == 'l') {
 66e:	05978c63          	beq	a5,s9,6c6 <vprintf+0xd6>
      } else if(c == 'x') {
 672:	07a78863          	beq	a5,s10,6e2 <vprintf+0xf2>
      } else if(c == 'p') {
 676:	09b78463          	beq	a5,s11,6fe <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 67a:	07300713          	li	a4,115
 67e:	0ce78663          	beq	a5,a4,74a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 682:	06300713          	li	a4,99
 686:	0ee78e63          	beq	a5,a4,782 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 68a:	11478863          	beq	a5,s4,79a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68e:	85d2                	mv	a1,s4
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e92080e7          	jalr	-366(ra) # 524 <putc>
        putc(fd, c);
 69a:	85ca                	mv	a1,s2
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e86080e7          	jalr	-378(ra) # 524 <putc>
      }
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b765                	j	650 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6aa:	008b0913          	addi	s2,s6,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000b2583          	lw	a1,0(s6)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e8e080e7          	jalr	-370(ra) # 546 <printint>
 6c0:	8b4a                	mv	s6,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b771                	j	650 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	008b0913          	addi	s2,s6,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000b2583          	lw	a1,0(s6)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e72080e7          	jalr	-398(ra) # 546 <printint>
 6dc:	8b4a                	mv	s6,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bf85                	j	650 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6e2:	008b0913          	addi	s2,s6,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000b2583          	lw	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e56080e7          	jalr	-426(ra) # 546 <printint>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bf91                	j	650 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6fe:	008b0793          	addi	a5,s6,8
 702:	f8f43423          	sd	a5,-120(s0)
 706:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 70a:	03000593          	li	a1,48
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e14080e7          	jalr	-492(ra) # 524 <putc>
  putc(fd, 'x');
 718:	85ea                	mv	a1,s10
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e08080e7          	jalr	-504(ra) # 524 <putc>
 724:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	03c9d793          	srli	a5,s3,0x3c
 72a:	97de                	add	a5,a5,s7
 72c:	0007c583          	lbu	a1,0(a5)
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	df2080e7          	jalr	-526(ra) # 524 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73a:	0992                	slli	s3,s3,0x4
 73c:	397d                	addiw	s2,s2,-1
 73e:	fe0914e3          	bnez	s2,726 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 742:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 746:	4981                	li	s3,0
 748:	b721                	j	650 <vprintf+0x60>
        s = va_arg(ap, char*);
 74a:	008b0993          	addi	s3,s6,8
 74e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 752:	02090163          	beqz	s2,774 <vprintf+0x184>
        while(*s != 0){
 756:	00094583          	lbu	a1,0(s2)
 75a:	c9a1                	beqz	a1,7aa <vprintf+0x1ba>
          putc(fd, *s);
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	dc6080e7          	jalr	-570(ra) # 524 <putc>
          s++;
 766:	0905                	addi	s2,s2,1
        while(*s != 0){
 768:	00094583          	lbu	a1,0(s2)
 76c:	f9e5                	bnez	a1,75c <vprintf+0x16c>
        s = va_arg(ap, char*);
 76e:	8b4e                	mv	s6,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bdf9                	j	650 <vprintf+0x60>
          s = "(null)";
 774:	00000917          	auipc	s2,0x0
 778:	2cc90913          	addi	s2,s2,716 # a40 <malloc+0x186>
        while(*s != 0){
 77c:	02800593          	li	a1,40
 780:	bff1                	j	75c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 782:	008b0913          	addi	s2,s6,8
 786:	000b4583          	lbu	a1,0(s6)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	d98080e7          	jalr	-616(ra) # 524 <putc>
 794:	8b4a                	mv	s6,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	bd65                	j	650 <vprintf+0x60>
        putc(fd, c);
 79a:	85d2                	mv	a1,s4
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	d86080e7          	jalr	-634(ra) # 524 <putc>
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b565                	j	650 <vprintf+0x60>
        s = va_arg(ap, char*);
 7aa:	8b4e                	mv	s6,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b54d                	j	650 <vprintf+0x60>
    }
  }
}
 7b0:	70e6                	ld	ra,120(sp)
 7b2:	7446                	ld	s0,112(sp)
 7b4:	74a6                	ld	s1,104(sp)
 7b6:	7906                	ld	s2,96(sp)
 7b8:	69e6                	ld	s3,88(sp)
 7ba:	6a46                	ld	s4,80(sp)
 7bc:	6aa6                	ld	s5,72(sp)
 7be:	6b06                	ld	s6,64(sp)
 7c0:	7be2                	ld	s7,56(sp)
 7c2:	7c42                	ld	s8,48(sp)
 7c4:	7ca2                	ld	s9,40(sp)
 7c6:	7d02                	ld	s10,32(sp)
 7c8:	6de2                	ld	s11,24(sp)
 7ca:	6109                	addi	sp,sp,128
 7cc:	8082                	ret

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	addi	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	8622                	mv	a2,s0
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e04080e7          	jalr	-508(ra) # 5f0 <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6161                	addi	sp,sp,80
 7fa:	8082                	ret

00000000000007fc <printf>:

void
printf(const char *fmt, ...)
{
 7fc:	711d                	addi	sp,sp,-96
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	addi	s0,sp,32
 804:	e40c                	sd	a1,8(s0)
 806:	e810                	sd	a2,16(s0)
 808:	ec14                	sd	a3,24(s0)
 80a:	f018                	sd	a4,32(s0)
 80c:	f41c                	sd	a5,40(s0)
 80e:	03043823          	sd	a6,48(s0)
 812:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 816:	00840613          	addi	a2,s0,8
 81a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81e:	85aa                	mv	a1,a0
 820:	4505                	li	a0,1
 822:	00000097          	auipc	ra,0x0
 826:	dce080e7          	jalr	-562(ra) # 5f0 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6125                	addi	sp,sp,96
 830:	8082                	ret

0000000000000832 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 832:	1141                	addi	sp,sp,-16
 834:	e422                	sd	s0,8(sp)
 836:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 838:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	00000797          	auipc	a5,0x0
 840:	2247b783          	ld	a5,548(a5) # a60 <freep>
 844:	a805                	j	874 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 846:	4618                	lw	a4,8(a2)
 848:	9db9                	addw	a1,a1,a4
 84a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	6318                	ld	a4,0(a4)
 852:	fee53823          	sd	a4,-16(a0)
 856:	a091                	j	89a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9e39                	addw	a2,a2,a4
 85e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053703          	ld	a4,-16(a0)
 864:	e398                	sd	a4,0(a5)
 866:	a099                	j	8ac <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	6398                	ld	a4,0(a5)
 86a:	00e7e463          	bltu	a5,a4,872 <free+0x40>
 86e:	00e6ea63          	bltu	a3,a4,882 <free+0x50>
{
 872:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	fed7fae3          	bgeu	a5,a3,868 <free+0x36>
 878:	6398                	ld	a4,0(a5)
 87a:	00e6e463          	bltu	a3,a4,882 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	fee7eae3          	bltu	a5,a4,872 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 882:	ff852583          	lw	a1,-8(a0)
 886:	6390                	ld	a2,0(a5)
 888:	02059713          	slli	a4,a1,0x20
 88c:	9301                	srli	a4,a4,0x20
 88e:	0712                	slli	a4,a4,0x4
 890:	9736                	add	a4,a4,a3
 892:	fae60ae3          	beq	a2,a4,846 <free+0x14>
    bp->s.ptr = p->s.ptr;
 896:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89a:	4790                	lw	a2,8(a5)
 89c:	02061713          	slli	a4,a2,0x20
 8a0:	9301                	srli	a4,a4,0x20
 8a2:	0712                	slli	a4,a4,0x4
 8a4:	973e                	add	a4,a4,a5
 8a6:	fae689e3          	beq	a3,a4,858 <free+0x26>
  } else
    p->s.ptr = bp;
 8aa:	e394                	sd	a3,0(a5)
  freep = p;
 8ac:	00000717          	auipc	a4,0x0
 8b0:	1af73a23          	sd	a5,436(a4) # a60 <freep>
}
 8b4:	6422                	ld	s0,8(sp)
 8b6:	0141                	addi	sp,sp,16
 8b8:	8082                	ret

00000000000008ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ba:	7139                	addi	sp,sp,-64
 8bc:	fc06                	sd	ra,56(sp)
 8be:	f822                	sd	s0,48(sp)
 8c0:	f426                	sd	s1,40(sp)
 8c2:	f04a                	sd	s2,32(sp)
 8c4:	ec4e                	sd	s3,24(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
 8cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ce:	02051493          	slli	s1,a0,0x20
 8d2:	9081                	srli	s1,s1,0x20
 8d4:	04bd                	addi	s1,s1,15
 8d6:	8091                	srli	s1,s1,0x4
 8d8:	0014899b          	addiw	s3,s1,1
 8dc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8de:	00000517          	auipc	a0,0x0
 8e2:	18253503          	ld	a0,386(a0) # a60 <freep>
 8e6:	c515                	beqz	a0,912 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ea:	4798                	lw	a4,8(a5)
 8ec:	02977f63          	bgeu	a4,s1,92a <malloc+0x70>
 8f0:	8a4e                	mv	s4,s3
 8f2:	0009871b          	sext.w	a4,s3
 8f6:	6685                	lui	a3,0x1
 8f8:	00d77363          	bgeu	a4,a3,8fe <malloc+0x44>
 8fc:	6a05                	lui	s4,0x1
 8fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 902:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 906:	00000917          	auipc	s2,0x0
 90a:	15a90913          	addi	s2,s2,346 # a60 <freep>
  if(p == (char*)-1)
 90e:	5afd                	li	s5,-1
 910:	a88d                	j	982 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 912:	00000797          	auipc	a5,0x0
 916:	15678793          	addi	a5,a5,342 # a68 <base>
 91a:	00000717          	auipc	a4,0x0
 91e:	14f73323          	sd	a5,326(a4) # a60 <freep>
 922:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 924:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 928:	b7e1                	j	8f0 <malloc+0x36>
      if(p->s.size == nunits)
 92a:	02e48b63          	beq	s1,a4,960 <malloc+0xa6>
        p->s.size -= nunits;
 92e:	4137073b          	subw	a4,a4,s3
 932:	c798                	sw	a4,8(a5)
        p += p->s.size;
 934:	1702                	slli	a4,a4,0x20
 936:	9301                	srli	a4,a4,0x20
 938:	0712                	slli	a4,a4,0x4
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00000717          	auipc	a4,0x0
 944:	12a73023          	sd	a0,288(a4) # a60 <freep>
      return (void*)(p + 1);
 948:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	74a2                	ld	s1,40(sp)
 952:	7902                	ld	s2,32(sp)
 954:	69e2                	ld	s3,24(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	6121                	addi	sp,sp,64
 95e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	bff1                	j	940 <malloc+0x86>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	00000097          	auipc	ra,0x0
 970:	ec6080e7          	jalr	-314(ra) # 832 <free>
  return freep;
 974:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 978:	d971                	beqz	a0,94c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97c:	4798                	lw	a4,8(a5)
 97e:	fa9776e3          	bgeu	a4,s1,92a <malloc+0x70>
    if(p == freep)
 982:	00093703          	ld	a4,0(s2)
 986:	853e                	mv	a0,a5
 988:	fef719e3          	bne	a4,a5,97a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 98c:	8552                	mv	a0,s4
 98e:	00000097          	auipc	ra,0x0
 992:	ad4080e7          	jalr	-1324(ra) # 462 <sbrk>
  if(p == (char*)-1)
 996:	fd5518e3          	bne	a0,s5,966 <malloc+0xac>
        return 0;
 99a:	4501                	li	a0,0
 99c:	bf45                	j	94c <malloc+0x92>
