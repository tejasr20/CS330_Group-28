
user/_testGetPwaitP:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int m, n, x;

  if (argc != 3) {
   e:	478d                	li	a5,3
  10:	02f50063          	beq	a0,a5,30 <main+0x30>
     fprintf(2, "syntax: testGetPwaitP m n\nAborting...\n");
  14:	00001597          	auipc	a1,0x1
  18:	97458593          	addi	a1,a1,-1676 # 988 <malloc+0xe8>
  1c:	4509                	li	a0,2
  1e:	00000097          	auipc	ra,0x0
  22:	796080e7          	jalr	1942(ra) # 7b4 <fprintf>
     exit(0);
  26:	4501                	li	a0,0
  28:	00000097          	auipc	ra,0x0
  2c:	398080e7          	jalr	920(ra) # 3c0 <exit>
  30:	84ae                	mv	s1,a1
  }

  m = atoi(argv[1]);
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	28c080e7          	jalr	652(ra) # 2c0 <atoi>
  3c:	892a                	mv	s2,a0
  if (m <= 0) {
  3e:	02a05b63          	blez	a0,74 <main+0x74>
     fprintf(2, "Invalid input\nAborting...\n");
     exit(0);
  }
  n = atoi(argv[2]);
  42:	6888                	ld	a0,16(s1)
  44:	00000097          	auipc	ra,0x0
  48:	27c080e7          	jalr	636(ra) # 2c0 <atoi>
  4c:	84aa                	mv	s1,a0
  if ((n != 0) && (n != 1)) {
  4e:	0005071b          	sext.w	a4,a0
  52:	4785                	li	a5,1
  54:	02e7fe63          	bgeu	a5,a4,90 <main+0x90>
     fprintf(2, "Invalid input\nAborting...\n");
  58:	00001597          	auipc	a1,0x1
  5c:	95858593          	addi	a1,a1,-1704 # 9b0 <malloc+0x110>
  60:	4509                	li	a0,2
  62:	00000097          	auipc	ra,0x0
  66:	752080e7          	jalr	1874(ra) # 7b4 <fprintf>
     exit(0);
  6a:	4501                	li	a0,0
  6c:	00000097          	auipc	ra,0x0
  70:	354080e7          	jalr	852(ra) # 3c0 <exit>
     fprintf(2, "Invalid input\nAborting...\n");
  74:	00001597          	auipc	a1,0x1
  78:	93c58593          	addi	a1,a1,-1732 # 9b0 <malloc+0x110>
  7c:	4509                	li	a0,2
  7e:	00000097          	auipc	ra,0x0
  82:	736080e7          	jalr	1846(ra) # 7b4 <fprintf>
     exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	338080e7          	jalr	824(ra) # 3c0 <exit>
  }

  x = fork();
  90:	00000097          	auipc	ra,0x0
  94:	328080e7          	jalr	808(ra) # 3b8 <fork>
  98:	89aa                	mv	s3,a0
  if (x < 0) {
  9a:	04054863          	bltz	a0,ea <main+0xea>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  9e:	06a05a63          	blez	a0,112 <main+0x112>
     if (n) sleep(m);
  a2:	e0b5                	bnez	s1,106 <main+0x106>
     fprintf(1, "%d: Parent.\n", getpid());
  a4:	00000097          	auipc	ra,0x0
  a8:	39c080e7          	jalr	924(ra) # 440 <getpid>
  ac:	862a                	mv	a2,a0
  ae:	00001597          	auipc	a1,0x1
  b2:	94258593          	addi	a1,a1,-1726 # 9f0 <malloc+0x150>
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	6fc080e7          	jalr	1788(ra) # 7b4 <fprintf>
     fprintf(1, "Return value of waitpid=%d\n", waitpid(x, 0));
  c0:	4581                	li	a1,0
  c2:	854e                	mv	a0,s3
  c4:	00000097          	auipc	ra,0x0
  c8:	3bc080e7          	jalr	956(ra) # 480 <waitpid>
  cc:	862a                	mv	a2,a0
  ce:	00001597          	auipc	a1,0x1
  d2:	93258593          	addi	a1,a1,-1742 # a00 <malloc+0x160>
  d6:	4505                	li	a0,1
  d8:	00000097          	auipc	ra,0x0
  dc:	6dc080e7          	jalr	1756(ra) # 7b4 <fprintf>
  else {
     if (!n) sleep(m);
     fprintf(1, "%d: Child with parent %d.\n", getpid(), getppid());
  }

  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2de080e7          	jalr	734(ra) # 3c0 <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
  ea:	00001597          	auipc	a1,0x1
  ee:	8e658593          	addi	a1,a1,-1818 # 9d0 <malloc+0x130>
  f2:	4509                	li	a0,2
  f4:	00000097          	auipc	ra,0x0
  f8:	6c0080e7          	jalr	1728(ra) # 7b4 <fprintf>
     exit(0);
  fc:	4501                	li	a0,0
  fe:	00000097          	auipc	ra,0x0
 102:	2c2080e7          	jalr	706(ra) # 3c0 <exit>
     if (n) sleep(m);
 106:	854a                	mv	a0,s2
 108:	00000097          	auipc	ra,0x0
 10c:	348080e7          	jalr	840(ra) # 450 <sleep>
 110:	bf51                	j	a4 <main+0xa4>
     if (!n) sleep(m);
 112:	c495                	beqz	s1,13e <main+0x13e>
     fprintf(1, "%d: Child with parent %d.\n", getpid(), getppid());
 114:	00000097          	auipc	ra,0x0
 118:	32c080e7          	jalr	812(ra) # 440 <getpid>
 11c:	84aa                	mv	s1,a0
 11e:	00000097          	auipc	ra,0x0
 122:	342080e7          	jalr	834(ra) # 460 <getppid>
 126:	86aa                	mv	a3,a0
 128:	8626                	mv	a2,s1
 12a:	00001597          	auipc	a1,0x1
 12e:	8f658593          	addi	a1,a1,-1802 # a20 <malloc+0x180>
 132:	4505                	li	a0,1
 134:	00000097          	auipc	ra,0x0
 138:	680080e7          	jalr	1664(ra) # 7b4 <fprintf>
 13c:	b755                	j	e0 <main+0xe0>
     if (!n) sleep(m);
 13e:	854a                	mv	a0,s2
 140:	00000097          	auipc	ra,0x0
 144:	310080e7          	jalr	784(ra) # 450 <sleep>
 148:	b7f1                	j	114 <main+0x114>

000000000000014a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0x8>
    ;
  return os;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cb91                	beqz	a5,184 <strcmp+0x1e>
 172:	0005c703          	lbu	a4,0(a1)
 176:	00f71763          	bne	a4,a5,184 <strcmp+0x1e>
    p++, q++;
 17a:	0505                	addi	a0,a0,1
 17c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	fbe5                	bnez	a5,172 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 184:	0005c503          	lbu	a0,0(a1)
}
 188:	40a7853b          	subw	a0,a5,a0
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <strlen>:

uint
strlen(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 198:	00054783          	lbu	a5,0(a0)
 19c:	cf91                	beqz	a5,1b8 <strlen+0x26>
 19e:	0505                	addi	a0,a0,1
 1a0:	87aa                	mv	a5,a0
 1a2:	4685                	li	a3,1
 1a4:	9e89                	subw	a3,a3,a0
 1a6:	00f6853b          	addw	a0,a3,a5
 1aa:	0785                	addi	a5,a5,1
 1ac:	fff7c703          	lbu	a4,-1(a5)
 1b0:	fb7d                	bnez	a4,1a6 <strlen+0x14>
    ;
  return n;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret
  for(n = 0; s[n]; n++)
 1b8:	4501                	li	a0,0
 1ba:	bfe5                	j	1b2 <strlen+0x20>

00000000000001bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1c2:	ce09                	beqz	a2,1dc <memset+0x20>
 1c4:	87aa                	mv	a5,a0
 1c6:	fff6071b          	addiw	a4,a2,-1
 1ca:	1702                	slli	a4,a4,0x20
 1cc:	9301                	srli	a4,a4,0x20
 1ce:	0705                	addi	a4,a4,1
 1d0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1d6:	0785                	addi	a5,a5,1
 1d8:	fee79de3          	bne	a5,a4,1d2 <memset+0x16>
  }
  return dst;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strchr>:

char*
strchr(const char *s, char c)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	cb99                	beqz	a5,202 <strchr+0x20>
    if(*s == c)
 1ee:	00f58763          	beq	a1,a5,1fc <strchr+0x1a>
  for(; *s; s++)
 1f2:	0505                	addi	a0,a0,1
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	fbfd                	bnez	a5,1ee <strchr+0xc>
      return (char*)s;
  return 0;
 1fa:	4501                	li	a0,0
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  return 0;
 202:	4501                	li	a0,0
 204:	bfe5                	j	1fc <strchr+0x1a>

0000000000000206 <gets>:

char*
gets(char *buf, int max)
{
 206:	711d                	addi	sp,sp,-96
 208:	ec86                	sd	ra,88(sp)
 20a:	e8a2                	sd	s0,80(sp)
 20c:	e4a6                	sd	s1,72(sp)
 20e:	e0ca                	sd	s2,64(sp)
 210:	fc4e                	sd	s3,56(sp)
 212:	f852                	sd	s4,48(sp)
 214:	f456                	sd	s5,40(sp)
 216:	f05a                	sd	s6,32(sp)
 218:	ec5e                	sd	s7,24(sp)
 21a:	1080                	addi	s0,sp,96
 21c:	8baa                	mv	s7,a0
 21e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	892a                	mv	s2,a0
 222:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 224:	4aa9                	li	s5,10
 226:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 228:	89a6                	mv	s3,s1
 22a:	2485                	addiw	s1,s1,1
 22c:	0344d863          	bge	s1,s4,25c <gets+0x56>
    cc = read(0, &c, 1);
 230:	4605                	li	a2,1
 232:	faf40593          	addi	a1,s0,-81
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	1a0080e7          	jalr	416(ra) # 3d8 <read>
    if(cc < 1)
 240:	00a05e63          	blez	a0,25c <gets+0x56>
    buf[i++] = c;
 244:	faf44783          	lbu	a5,-81(s0)
 248:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24c:	01578763          	beq	a5,s5,25a <gets+0x54>
 250:	0905                	addi	s2,s2,1
 252:	fd679be3          	bne	a5,s6,228 <gets+0x22>
  for(i=0; i+1 < max; ){
 256:	89a6                	mv	s3,s1
 258:	a011                	j	25c <gets+0x56>
 25a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 25c:	99de                	add	s3,s3,s7
 25e:	00098023          	sb	zero,0(s3)
  return buf;
}
 262:	855e                	mv	a0,s7
 264:	60e6                	ld	ra,88(sp)
 266:	6446                	ld	s0,80(sp)
 268:	64a6                	ld	s1,72(sp)
 26a:	6906                	ld	s2,64(sp)
 26c:	79e2                	ld	s3,56(sp)
 26e:	7a42                	ld	s4,48(sp)
 270:	7aa2                	ld	s5,40(sp)
 272:	7b02                	ld	s6,32(sp)
 274:	6be2                	ld	s7,24(sp)
 276:	6125                	addi	sp,sp,96
 278:	8082                	ret

000000000000027a <stat>:

int
stat(const char *n, struct stat *st)
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
 286:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 288:	4581                	li	a1,0
 28a:	00000097          	auipc	ra,0x0
 28e:	176080e7          	jalr	374(ra) # 400 <open>
  if(fd < 0)
 292:	02054563          	bltz	a0,2bc <stat+0x42>
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	00000097          	auipc	ra,0x0
 29e:	17e080e7          	jalr	382(ra) # 418 <fstat>
 2a2:	892a                	mv	s2,a0
  close(fd);
 2a4:	8526                	mv	a0,s1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	142080e7          	jalr	322(ra) # 3e8 <close>
  return r;
}
 2ae:	854a                	mv	a0,s2
 2b0:	60e2                	ld	ra,24(sp)
 2b2:	6442                	ld	s0,16(sp)
 2b4:	64a2                	ld	s1,8(sp)
 2b6:	6902                	ld	s2,0(sp)
 2b8:	6105                	addi	sp,sp,32
 2ba:	8082                	ret
    return -1;
 2bc:	597d                	li	s2,-1
 2be:	bfc5                	j	2ae <stat+0x34>

00000000000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c6:	00054603          	lbu	a2,0(a0)
 2ca:	fd06079b          	addiw	a5,a2,-48
 2ce:	0ff7f793          	andi	a5,a5,255
 2d2:	4725                	li	a4,9
 2d4:	02f76963          	bltu	a4,a5,306 <atoi+0x46>
 2d8:	86aa                	mv	a3,a0
  n = 0;
 2da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2de:	0685                	addi	a3,a3,1
 2e0:	0025179b          	slliw	a5,a0,0x2
 2e4:	9fa9                	addw	a5,a5,a0
 2e6:	0017979b          	slliw	a5,a5,0x1
 2ea:	9fb1                	addw	a5,a5,a2
 2ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f0:	0006c603          	lbu	a2,0(a3)
 2f4:	fd06071b          	addiw	a4,a2,-48
 2f8:	0ff77713          	andi	a4,a4,255
 2fc:	fee5f1e3          	bgeu	a1,a4,2de <atoi+0x1e>
  return n;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  n = 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <atoi+0x40>

000000000000030a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 310:	02b57663          	bgeu	a0,a1,33c <memmove+0x32>
    while(n-- > 0)
 314:	02c05163          	blez	a2,336 <memmove+0x2c>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	0785                	addi	a5,a5,1
 322:	97aa                	add	a5,a5,a0
  dst = vdst;
 324:	872a                	mv	a4,a0
      *dst++ = *src++;
 326:	0585                	addi	a1,a1,1
 328:	0705                	addi	a4,a4,1
 32a:	fff5c683          	lbu	a3,-1(a1)
 32e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
    dst += n;
 33c:	00c50733          	add	a4,a0,a2
    src += n;
 340:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 342:	fec05ae3          	blez	a2,336 <memmove+0x2c>
 346:	fff6079b          	addiw	a5,a2,-1
 34a:	1782                	slli	a5,a5,0x20
 34c:	9381                	srli	a5,a5,0x20
 34e:	fff7c793          	not	a5,a5
 352:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 354:	15fd                	addi	a1,a1,-1
 356:	177d                	addi	a4,a4,-1
 358:	0005c683          	lbu	a3,0(a1)
 35c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 360:	fee79ae3          	bne	a5,a4,354 <memmove+0x4a>
 364:	bfc9                	j	336 <memmove+0x2c>

0000000000000366 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36c:	ca05                	beqz	a2,39c <memcmp+0x36>
 36e:	fff6069b          	addiw	a3,a2,-1
 372:	1682                	slli	a3,a3,0x20
 374:	9281                	srli	a3,a3,0x20
 376:	0685                	addi	a3,a3,1
 378:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 37a:	00054783          	lbu	a5,0(a0)
 37e:	0005c703          	lbu	a4,0(a1)
 382:	00e79863          	bne	a5,a4,392 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 386:	0505                	addi	a0,a0,1
    p2++;
 388:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 38a:	fed518e3          	bne	a0,a3,37a <memcmp+0x14>
  }
  return 0;
 38e:	4501                	li	a0,0
 390:	a019                	j	396 <memcmp+0x30>
      return *p1 - *p2;
 392:	40e7853b          	subw	a0,a5,a4
}
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
  return 0;
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <memcmp+0x30>

00000000000003a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a8:	00000097          	auipc	ra,0x0
 3ac:	f62080e7          	jalr	-158(ra) # 30a <memmove>
}
 3b0:	60a2                	ld	ra,8(sp)
 3b2:	6402                	ld	s0,0(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c8:	488d                	li	a7,3
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d0:	4891                	li	a7,4
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <read>:
.global read
read:
 li a7, SYS_read
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <write>:
.global write
write:
 li a7, SYS_write
 3e0:	48c1                	li	a7,16
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <close>:
.global close
close:
 li a7, SYS_close
 3e8:	48d5                	li	a7,21
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f0:	4899                	li	a7,6
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f8:	489d                	li	a7,7
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <open>:
.global open
open:
 li a7, SYS_open
 400:	48bd                	li	a7,15
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 410:	48c9                	li	a7,18
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <link>:
.global link
link:
 li a7, SYS_link
 420:	48cd                	li	a7,19
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 428:	48d1                	li	a7,20
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 430:	48a5                	li	a7,9
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dup>:
.global dup
dup:
 li a7, SYS_dup
 438:	48a9                	li	a7,10
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 440:	48ad                	li	a7,11
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 448:	48b1                	li	a7,12
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 450:	48b5                	li	a7,13
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 458:	48b9                	li	a7,14
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 460:	48d9                	li	a7,22
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <yield>:
.global yield
yield:
 li a7, SYS_yield
 468:	48dd                	li	a7,23
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 470:	48e1                	li	a7,24
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 478:	48e5                	li	a7,25
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 480:	48e9                	li	a7,26
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <ps>:
.global ps
ps:
 li a7, SYS_ps
 488:	48ed                	li	a7,27
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 490:	48f1                	li	a7,28
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 498:	48f5                	li	a7,29
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 4a0:	48f9                	li	a7,30
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 4a8:	48fd                	li	a7,31
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 4b0:	02000893          	li	a7,32
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 4ba:	02100893          	li	a7,33
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 4c4:	02200893          	li	a7,34
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 4ce:	02300893          	li	a7,35
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 4d8:	02500893          	li	a7,37
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 4e2:	02400893          	li	a7,36
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 4ec:	02600893          	li	a7,38
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 4f6:	02800893          	li	a7,40
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 500:	02700893          	li	a7,39
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	00000097          	auipc	ra,0x0
 520:	ec4080e7          	jalr	-316(ra) # 3e0 <write>
}
 524:	60e2                	ld	ra,24(sp)
 526:	6442                	ld	s0,16(sp)
 528:	6105                	addi	sp,sp,32
 52a:	8082                	ret

000000000000052c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52c:	7139                	addi	sp,sp,-64
 52e:	fc06                	sd	ra,56(sp)
 530:	f822                	sd	s0,48(sp)
 532:	f426                	sd	s1,40(sp)
 534:	f04a                	sd	s2,32(sp)
 536:	ec4e                	sd	s3,24(sp)
 538:	0080                	addi	s0,sp,64
 53a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53c:	c299                	beqz	a3,542 <printint+0x16>
 53e:	0805c863          	bltz	a1,5ce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 542:	2581                	sext.w	a1,a1
  neg = 0;
 544:	4881                	li	a7,0
 546:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54c:	2601                	sext.w	a2,a2
 54e:	00000517          	auipc	a0,0x0
 552:	4fa50513          	addi	a0,a0,1274 # a48 <digits>
 556:	883a                	mv	a6,a4
 558:	2705                	addiw	a4,a4,1
 55a:	02c5f7bb          	remuw	a5,a1,a2
 55e:	1782                	slli	a5,a5,0x20
 560:	9381                	srli	a5,a5,0x20
 562:	97aa                	add	a5,a5,a0
 564:	0007c783          	lbu	a5,0(a5)
 568:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56c:	0005879b          	sext.w	a5,a1
 570:	02c5d5bb          	divuw	a1,a1,a2
 574:	0685                	addi	a3,a3,1
 576:	fec7f0e3          	bgeu	a5,a2,556 <printint+0x2a>
  if(neg)
 57a:	00088b63          	beqz	a7,590 <printint+0x64>
    buf[i++] = '-';
 57e:	fd040793          	addi	a5,s0,-48
 582:	973e                	add	a4,a4,a5
 584:	02d00793          	li	a5,45
 588:	fef70823          	sb	a5,-16(a4)
 58c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 590:	02e05863          	blez	a4,5c0 <printint+0x94>
 594:	fc040793          	addi	a5,s0,-64
 598:	00e78933          	add	s2,a5,a4
 59c:	fff78993          	addi	s3,a5,-1
 5a0:	99ba                	add	s3,s3,a4
 5a2:	377d                	addiw	a4,a4,-1
 5a4:	1702                	slli	a4,a4,0x20
 5a6:	9301                	srli	a4,a4,0x20
 5a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ac:	fff94583          	lbu	a1,-1(s2)
 5b0:	8526                	mv	a0,s1
 5b2:	00000097          	auipc	ra,0x0
 5b6:	f58080e7          	jalr	-168(ra) # 50a <putc>
  while(--i >= 0)
 5ba:	197d                	addi	s2,s2,-1
 5bc:	ff3918e3          	bne	s2,s3,5ac <printint+0x80>
}
 5c0:	70e2                	ld	ra,56(sp)
 5c2:	7442                	ld	s0,48(sp)
 5c4:	74a2                	ld	s1,40(sp)
 5c6:	7902                	ld	s2,32(sp)
 5c8:	69e2                	ld	s3,24(sp)
 5ca:	6121                	addi	sp,sp,64
 5cc:	8082                	ret
    x = -xx;
 5ce:	40b005bb          	negw	a1,a1
    neg = 1;
 5d2:	4885                	li	a7,1
    x = -xx;
 5d4:	bf8d                	j	546 <printint+0x1a>

00000000000005d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d6:	7119                	addi	sp,sp,-128
 5d8:	fc86                	sd	ra,120(sp)
 5da:	f8a2                	sd	s0,112(sp)
 5dc:	f4a6                	sd	s1,104(sp)
 5de:	f0ca                	sd	s2,96(sp)
 5e0:	ecce                	sd	s3,88(sp)
 5e2:	e8d2                	sd	s4,80(sp)
 5e4:	e4d6                	sd	s5,72(sp)
 5e6:	e0da                	sd	s6,64(sp)
 5e8:	fc5e                	sd	s7,56(sp)
 5ea:	f862                	sd	s8,48(sp)
 5ec:	f466                	sd	s9,40(sp)
 5ee:	f06a                	sd	s10,32(sp)
 5f0:	ec6e                	sd	s11,24(sp)
 5f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f4:	0005c903          	lbu	s2,0(a1)
 5f8:	18090f63          	beqz	s2,796 <vprintf+0x1c0>
 5fc:	8aaa                	mv	s5,a0
 5fe:	8b32                	mv	s6,a2
 600:	00158493          	addi	s1,a1,1
  state = 0;
 604:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 606:	02500a13          	li	s4,37
      if(c == 'd'){
 60a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 60e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 612:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 616:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61a:	00000b97          	auipc	s7,0x0
 61e:	42eb8b93          	addi	s7,s7,1070 # a48 <digits>
 622:	a839                	j	640 <vprintf+0x6a>
        putc(fd, c);
 624:	85ca                	mv	a1,s2
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	ee2080e7          	jalr	-286(ra) # 50a <putc>
 630:	a019                	j	636 <vprintf+0x60>
    } else if(state == '%'){
 632:	01498f63          	beq	s3,s4,650 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 636:	0485                	addi	s1,s1,1
 638:	fff4c903          	lbu	s2,-1(s1)
 63c:	14090d63          	beqz	s2,796 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 640:	0009079b          	sext.w	a5,s2
    if(state == 0){
 644:	fe0997e3          	bnez	s3,632 <vprintf+0x5c>
      if(c == '%'){
 648:	fd479ee3          	bne	a5,s4,624 <vprintf+0x4e>
        state = '%';
 64c:	89be                	mv	s3,a5
 64e:	b7e5                	j	636 <vprintf+0x60>
      if(c == 'd'){
 650:	05878063          	beq	a5,s8,690 <vprintf+0xba>
      } else if(c == 'l') {
 654:	05978c63          	beq	a5,s9,6ac <vprintf+0xd6>
      } else if(c == 'x') {
 658:	07a78863          	beq	a5,s10,6c8 <vprintf+0xf2>
      } else if(c == 'p') {
 65c:	09b78463          	beq	a5,s11,6e4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 660:	07300713          	li	a4,115
 664:	0ce78663          	beq	a5,a4,730 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 668:	06300713          	li	a4,99
 66c:	0ee78e63          	beq	a5,a4,768 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 670:	11478863          	beq	a5,s4,780 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 674:	85d2                	mv	a1,s4
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e92080e7          	jalr	-366(ra) # 50a <putc>
        putc(fd, c);
 680:	85ca                	mv	a1,s2
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e86080e7          	jalr	-378(ra) # 50a <putc>
      }
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b765                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 690:	008b0913          	addi	s2,s6,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000b2583          	lw	a1,0(s6)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e8e080e7          	jalr	-370(ra) # 52c <printint>
 6a6:	8b4a                	mv	s6,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b771                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	008b0913          	addi	s2,s6,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000b2583          	lw	a1,0(s6)
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e72080e7          	jalr	-398(ra) # 52c <printint>
 6c2:	8b4a                	mv	s6,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bf85                	j	636 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c8:	008b0913          	addi	s2,s6,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000b2583          	lw	a1,0(s6)
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e56080e7          	jalr	-426(ra) # 52c <printint>
 6de:	8b4a                	mv	s6,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bf91                	j	636 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e4:	008b0793          	addi	a5,s6,8
 6e8:	f8f43423          	sd	a5,-120(s0)
 6ec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f0:	03000593          	li	a1,48
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e14080e7          	jalr	-492(ra) # 50a <putc>
  putc(fd, 'x');
 6fe:	85ea                	mv	a1,s10
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e08080e7          	jalr	-504(ra) # 50a <putc>
 70a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70c:	03c9d793          	srli	a5,s3,0x3c
 710:	97de                	add	a5,a5,s7
 712:	0007c583          	lbu	a1,0(a5)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	df2080e7          	jalr	-526(ra) # 50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 720:	0992                	slli	s3,s3,0x4
 722:	397d                	addiw	s2,s2,-1
 724:	fe0914e3          	bnez	s2,70c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 728:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b721                	j	636 <vprintf+0x60>
        s = va_arg(ap, char*);
 730:	008b0993          	addi	s3,s6,8
 734:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 738:	02090163          	beqz	s2,75a <vprintf+0x184>
        while(*s != 0){
 73c:	00094583          	lbu	a1,0(s2)
 740:	c9a1                	beqz	a1,790 <vprintf+0x1ba>
          putc(fd, *s);
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	dc6080e7          	jalr	-570(ra) # 50a <putc>
          s++;
 74c:	0905                	addi	s2,s2,1
        while(*s != 0){
 74e:	00094583          	lbu	a1,0(s2)
 752:	f9e5                	bnez	a1,742 <vprintf+0x16c>
        s = va_arg(ap, char*);
 754:	8b4e                	mv	s6,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	bdf9                	j	636 <vprintf+0x60>
          s = "(null)";
 75a:	00000917          	auipc	s2,0x0
 75e:	2e690913          	addi	s2,s2,742 # a40 <malloc+0x1a0>
        while(*s != 0){
 762:	02800593          	li	a1,40
 766:	bff1                	j	742 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 768:	008b0913          	addi	s2,s6,8
 76c:	000b4583          	lbu	a1,0(s6)
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	d98080e7          	jalr	-616(ra) # 50a <putc>
 77a:	8b4a                	mv	s6,s2
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bd65                	j	636 <vprintf+0x60>
        putc(fd, c);
 780:	85d2                	mv	a1,s4
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d86080e7          	jalr	-634(ra) # 50a <putc>
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b565                	j	636 <vprintf+0x60>
        s = va_arg(ap, char*);
 790:	8b4e                	mv	s6,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	b54d                	j	636 <vprintf+0x60>
    }
  }
}
 796:	70e6                	ld	ra,120(sp)
 798:	7446                	ld	s0,112(sp)
 79a:	74a6                	ld	s1,104(sp)
 79c:	7906                	ld	s2,96(sp)
 79e:	69e6                	ld	s3,88(sp)
 7a0:	6a46                	ld	s4,80(sp)
 7a2:	6aa6                	ld	s5,72(sp)
 7a4:	6b06                	ld	s6,64(sp)
 7a6:	7be2                	ld	s7,56(sp)
 7a8:	7c42                	ld	s8,48(sp)
 7aa:	7ca2                	ld	s9,40(sp)
 7ac:	7d02                	ld	s10,32(sp)
 7ae:	6de2                	ld	s11,24(sp)
 7b0:	6109                	addi	sp,sp,128
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e04080e7          	jalr	-508(ra) # 5d6 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	00000097          	auipc	ra,0x0
 80c:	dce080e7          	jalr	-562(ra) # 5d6 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6125                	addi	sp,sp,96
 816:	8082                	ret

0000000000000818 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 818:	1141                	addi	sp,sp,-16
 81a:	e422                	sd	s0,8(sp)
 81c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	23e7b783          	ld	a5,574(a5) # a60 <freep>
 82a:	a805                	j	85a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9db9                	addw	a1,a1,a4
 830:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6318                	ld	a4,0(a4)
 838:	fee53823          	sd	a4,-16(a0)
 83c:	a091                	j	880 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83e:	ff852703          	lw	a4,-8(a0)
 842:	9e39                	addw	a2,a2,a4
 844:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 846:	ff053703          	ld	a4,-16(a0)
 84a:	e398                	sd	a4,0(a5)
 84c:	a099                	j	892 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x40>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x50>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x36>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059713          	slli	a4,a1,0x20
 872:	9301                	srli	a4,a4,0x20
 874:	0712                	slli	a4,a4,0x4
 876:	9736                	add	a4,a4,a3
 878:	fae60ae3          	beq	a2,a4,82c <free+0x14>
    bp->s.ptr = p->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061713          	slli	a4,a2,0x20
 886:	9301                	srli	a4,a4,0x20
 888:	0712                	slli	a4,a4,0x4
 88a:	973e                	add	a4,a4,a5
 88c:	fae689e3          	beq	a3,a4,83e <free+0x26>
  } else
    p->s.ptr = bp;
 890:	e394                	sd	a3,0(a5)
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	1cf73723          	sd	a5,462(a4) # a60 <freep>
}
 89a:	6422                	ld	s0,8(sp)
 89c:	0141                	addi	sp,sp,16
 89e:	8082                	ret

00000000000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	7139                	addi	sp,sp,-64
 8a2:	fc06                	sd	ra,56(sp)
 8a4:	f822                	sd	s0,48(sp)
 8a6:	f426                	sd	s1,40(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
 8b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	19c53503          	ld	a0,412(a0) # a60 <freep>
 8cc:	c515                	beqz	a0,8f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	02977f63          	bgeu	a4,s1,910 <malloc+0x70>
 8d6:	8a4e                	mv	s4,s3
 8d8:	0009871b          	sext.w	a4,s3
 8dc:	6685                	lui	a3,0x1
 8de:	00d77363          	bgeu	a4,a3,8e4 <malloc+0x44>
 8e2:	6a05                	lui	s4,0x1
 8e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ec:	00000917          	auipc	s2,0x0
 8f0:	17490913          	addi	s2,s2,372 # a60 <freep>
  if(p == (char*)-1)
 8f4:	5afd                	li	s5,-1
 8f6:	a88d                	j	968 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	17078793          	addi	a5,a5,368 # a68 <base>
 900:	00000717          	auipc	a4,0x0
 904:	16f73023          	sd	a5,352(a4) # a60 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7e1                	j	8d6 <malloc+0x36>
      if(p->s.size == nunits)
 910:	02e48b63          	beq	s1,a4,946 <malloc+0xa6>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	1702                	slli	a4,a4,0x20
 91c:	9301                	srli	a4,a4,0x20
 91e:	0712                	slli	a4,a4,0x4
 920:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 922:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 926:	00000717          	auipc	a4,0x0
 92a:	12a73d23          	sd	a0,314(a4) # a60 <freep>
      return (void*)(p + 1);
 92e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 932:	70e2                	ld	ra,56(sp)
 934:	7442                	ld	s0,48(sp)
 936:	74a2                	ld	s1,40(sp)
 938:	7902                	ld	s2,32(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	bff1                	j	926 <malloc+0x86>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	00000097          	auipc	ra,0x0
 956:	ec6080e7          	jalr	-314(ra) # 818 <free>
  return freep;
 95a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95e:	d971                	beqz	a0,932 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	fa9776e3          	bgeu	a4,s1,910 <malloc+0x70>
    if(p == freep)
 968:	00093703          	ld	a4,0(s2)
 96c:	853e                	mv	a0,a5
 96e:	fef719e3          	bne	a4,a5,960 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 972:	8552                	mv	a0,s4
 974:	00000097          	auipc	ra,0x0
 978:	ad4080e7          	jalr	-1324(ra) # 448 <sbrk>
  if(p == (char*)-1)
 97c:	fd5518e3          	bne	a0,s5,94c <malloc+0xac>
        return 0;
 980:	4501                	li	a0,0
 982:	bf45                	j	932 <malloc+0x92>
