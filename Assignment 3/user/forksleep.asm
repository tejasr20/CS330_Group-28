
user/_forksleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int m, n, x;

  if (argc != 3) {
   c:	478d                	li	a5,3
   e:	02f50063          	beq	a0,a5,2e <main+0x2e>
     fprintf(2, "syntax: forksleep m n\nAborting...\n");
  12:	00001597          	auipc	a1,0x1
  16:	94e58593          	addi	a1,a1,-1714 # 960 <malloc+0xe6>
  1a:	4509                	li	a0,2
  1c:	00000097          	auipc	ra,0x0
  20:	772080e7          	jalr	1906(ra) # 78e <fprintf>
     exit(0);
  24:	4501                	li	a0,0
  26:	00000097          	auipc	ra,0x0
  2a:	374080e7          	jalr	884(ra) # 39a <exit>
  2e:	84ae                	mv	s1,a1
  }

  m = atoi(argv[1]);
  30:	6588                	ld	a0,8(a1)
  32:	00000097          	auipc	ra,0x0
  36:	268080e7          	jalr	616(ra) # 29a <atoi>
  3a:	892a                	mv	s2,a0
  if (m <= 0) {
  3c:	02a05b63          	blez	a0,72 <main+0x72>
     fprintf(2, "Invalid input\nAborting...\n");
     exit(0);
  }
  n = atoi(argv[2]);
  40:	6888                	ld	a0,16(s1)
  42:	00000097          	auipc	ra,0x0
  46:	258080e7          	jalr	600(ra) # 29a <atoi>
  4a:	84aa                	mv	s1,a0
  if ((n != 0) && (n != 1)) {
  4c:	0005071b          	sext.w	a4,a0
  50:	4785                	li	a5,1
  52:	02e7fe63          	bgeu	a5,a4,8e <main+0x8e>
     fprintf(2, "Invalid input\nAborting...\n");
  56:	00001597          	auipc	a1,0x1
  5a:	93258593          	addi	a1,a1,-1742 # 988 <malloc+0x10e>
  5e:	4509                	li	a0,2
  60:	00000097          	auipc	ra,0x0
  64:	72e080e7          	jalr	1838(ra) # 78e <fprintf>
     exit(0);
  68:	4501                	li	a0,0
  6a:	00000097          	auipc	ra,0x0
  6e:	330080e7          	jalr	816(ra) # 39a <exit>
     fprintf(2, "Invalid input\nAborting...\n");
  72:	00001597          	auipc	a1,0x1
  76:	91658593          	addi	a1,a1,-1770 # 988 <malloc+0x10e>
  7a:	4509                	li	a0,2
  7c:	00000097          	auipc	ra,0x0
  80:	712080e7          	jalr	1810(ra) # 78e <fprintf>
     exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	314080e7          	jalr	788(ra) # 39a <exit>
  }

  x = fork();
  8e:	00000097          	auipc	ra,0x0
  92:	304080e7          	jalr	772(ra) # 392 <fork>
  if (x < 0) {
  96:	02054d63          	bltz	a0,d0 <main+0xd0>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  9a:	04a05f63          	blez	a0,f8 <main+0xf8>
     if (n) sleep(m);
  9e:	e4b9                	bnez	s1,ec <main+0xec>
     fprintf(1, "%d: Parent.\n", getpid());
  a0:	00000097          	auipc	ra,0x0
  a4:	37a080e7          	jalr	890(ra) # 41a <getpid>
  a8:	862a                	mv	a2,a0
  aa:	00001597          	auipc	a1,0x1
  ae:	91e58593          	addi	a1,a1,-1762 # 9c8 <malloc+0x14e>
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	6da080e7          	jalr	1754(ra) # 78e <fprintf>
     wait(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	2e4080e7          	jalr	740(ra) # 3a2 <wait>
  else {
     if (!n) sleep(m);
     fprintf(1, "%d: Child.\n", getpid());
  }

  exit(0);
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	2d2080e7          	jalr	722(ra) # 39a <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
  d0:	00001597          	auipc	a1,0x1
  d4:	8d858593          	addi	a1,a1,-1832 # 9a8 <malloc+0x12e>
  d8:	4509                	li	a0,2
  da:	00000097          	auipc	ra,0x0
  de:	6b4080e7          	jalr	1716(ra) # 78e <fprintf>
     exit(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	2b6080e7          	jalr	694(ra) # 39a <exit>
     if (n) sleep(m);
  ec:	854a                	mv	a0,s2
  ee:	00000097          	auipc	ra,0x0
  f2:	33c080e7          	jalr	828(ra) # 42a <sleep>
  f6:	b76d                	j	a0 <main+0xa0>
     if (!n) sleep(m);
  f8:	c085                	beqz	s1,118 <main+0x118>
     fprintf(1, "%d: Child.\n", getpid());
  fa:	00000097          	auipc	ra,0x0
  fe:	320080e7          	jalr	800(ra) # 41a <getpid>
 102:	862a                	mv	a2,a0
 104:	00001597          	auipc	a1,0x1
 108:	8d458593          	addi	a1,a1,-1836 # 9d8 <malloc+0x15e>
 10c:	4505                	li	a0,1
 10e:	00000097          	auipc	ra,0x0
 112:	680080e7          	jalr	1664(ra) # 78e <fprintf>
 116:	bf45                	j	c6 <main+0xc6>
     if (!n) sleep(m);
 118:	854a                	mv	a0,s2
 11a:	00000097          	auipc	ra,0x0
 11e:	310080e7          	jalr	784(ra) # 42a <sleep>
 122:	bfe1                	j	fa <main+0xfa>

0000000000000124 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	87aa                	mv	a5,a0
 12c:	0585                	addi	a1,a1,1
 12e:	0785                	addi	a5,a5,1
 130:	fff5c703          	lbu	a4,-1(a1)
 134:	fee78fa3          	sb	a4,-1(a5)
 138:	fb75                	bnez	a4,12c <strcpy+0x8>
    ;
  return os;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cb91                	beqz	a5,15e <strcmp+0x1e>
 14c:	0005c703          	lbu	a4,0(a1)
 150:	00f71763          	bne	a4,a5,15e <strcmp+0x1e>
    p++, q++;
 154:	0505                	addi	a0,a0,1
 156:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 158:	00054783          	lbu	a5,0(a0)
 15c:	fbe5                	bnez	a5,14c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 15e:	0005c503          	lbu	a0,0(a1)
}
 162:	40a7853b          	subw	a0,a5,a0
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strlen>:

uint
strlen(const char *s)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 172:	00054783          	lbu	a5,0(a0)
 176:	cf91                	beqz	a5,192 <strlen+0x26>
 178:	0505                	addi	a0,a0,1
 17a:	87aa                	mv	a5,a0
 17c:	4685                	li	a3,1
 17e:	9e89                	subw	a3,a3,a0
 180:	00f6853b          	addw	a0,a3,a5
 184:	0785                	addi	a5,a5,1
 186:	fff7c703          	lbu	a4,-1(a5)
 18a:	fb7d                	bnez	a4,180 <strlen+0x14>
    ;
  return n;
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  for(n = 0; s[n]; n++)
 192:	4501                	li	a0,0
 194:	bfe5                	j	18c <strlen+0x20>

0000000000000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19c:	ce09                	beqz	a2,1b6 <memset+0x20>
 19e:	87aa                	mv	a5,a0
 1a0:	fff6071b          	addiw	a4,a2,-1
 1a4:	1702                	slli	a4,a4,0x20
 1a6:	9301                	srli	a4,a4,0x20
 1a8:	0705                	addi	a4,a4,1
 1aa:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b0:	0785                	addi	a5,a5,1
 1b2:	fee79de3          	bne	a5,a4,1ac <memset+0x16>
  }
  return dst;
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strchr>:

char*
strchr(const char *s, char c)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	cb99                	beqz	a5,1dc <strchr+0x20>
    if(*s == c)
 1c8:	00f58763          	beq	a1,a5,1d6 <strchr+0x1a>
  for(; *s; s++)
 1cc:	0505                	addi	a0,a0,1
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	fbfd                	bnez	a5,1c8 <strchr+0xc>
      return (char*)s;
  return 0;
 1d4:	4501                	li	a0,0
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  return 0;
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strchr+0x1a>

00000000000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	711d                	addi	sp,sp,-96
 1e2:	ec86                	sd	ra,88(sp)
 1e4:	e8a2                	sd	s0,80(sp)
 1e6:	e4a6                	sd	s1,72(sp)
 1e8:	e0ca                	sd	s2,64(sp)
 1ea:	fc4e                	sd	s3,56(sp)
 1ec:	f852                	sd	s4,48(sp)
 1ee:	f456                	sd	s5,40(sp)
 1f0:	f05a                	sd	s6,32(sp)
 1f2:	ec5e                	sd	s7,24(sp)
 1f4:	1080                	addi	s0,sp,96
 1f6:	8baa                	mv	s7,a0
 1f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fa:	892a                	mv	s2,a0
 1fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fe:	4aa9                	li	s5,10
 200:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 202:	89a6                	mv	s3,s1
 204:	2485                	addiw	s1,s1,1
 206:	0344d863          	bge	s1,s4,236 <gets+0x56>
    cc = read(0, &c, 1);
 20a:	4605                	li	a2,1
 20c:	faf40593          	addi	a1,s0,-81
 210:	4501                	li	a0,0
 212:	00000097          	auipc	ra,0x0
 216:	1a0080e7          	jalr	416(ra) # 3b2 <read>
    if(cc < 1)
 21a:	00a05e63          	blez	a0,236 <gets+0x56>
    buf[i++] = c;
 21e:	faf44783          	lbu	a5,-81(s0)
 222:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 226:	01578763          	beq	a5,s5,234 <gets+0x54>
 22a:	0905                	addi	s2,s2,1
 22c:	fd679be3          	bne	a5,s6,202 <gets+0x22>
  for(i=0; i+1 < max; ){
 230:	89a6                	mv	s3,s1
 232:	a011                	j	236 <gets+0x56>
 234:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 236:	99de                	add	s3,s3,s7
 238:	00098023          	sb	zero,0(s3)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6125                	addi	sp,sp,96
 252:	8082                	ret

0000000000000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	1101                	addi	sp,sp,-32
 256:	ec06                	sd	ra,24(sp)
 258:	e822                	sd	s0,16(sp)
 25a:	e426                	sd	s1,8(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	00000097          	auipc	ra,0x0
 268:	176080e7          	jalr	374(ra) # 3da <open>
  if(fd < 0)
 26c:	02054563          	bltz	a0,296 <stat+0x42>
 270:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 272:	85ca                	mv	a1,s2
 274:	00000097          	auipc	ra,0x0
 278:	17e080e7          	jalr	382(ra) # 3f2 <fstat>
 27c:	892a                	mv	s2,a0
  close(fd);
 27e:	8526                	mv	a0,s1
 280:	00000097          	auipc	ra,0x0
 284:	142080e7          	jalr	322(ra) # 3c2 <close>
  return r;
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	64a2                	ld	s1,8(sp)
 290:	6902                	ld	s2,0(sp)
 292:	6105                	addi	sp,sp,32
 294:	8082                	ret
    return -1;
 296:	597d                	li	s2,-1
 298:	bfc5                	j	288 <stat+0x34>

000000000000029a <atoi>:

int
atoi(const char *s)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a0:	00054603          	lbu	a2,0(a0)
 2a4:	fd06079b          	addiw	a5,a2,-48
 2a8:	0ff7f793          	andi	a5,a5,255
 2ac:	4725                	li	a4,9
 2ae:	02f76963          	bltu	a4,a5,2e0 <atoi+0x46>
 2b2:	86aa                	mv	a3,a0
  n = 0;
 2b4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2b6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2b8:	0685                	addi	a3,a3,1
 2ba:	0025179b          	slliw	a5,a0,0x2
 2be:	9fa9                	addw	a5,a5,a0
 2c0:	0017979b          	slliw	a5,a5,0x1
 2c4:	9fb1                	addw	a5,a5,a2
 2c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ca:	0006c603          	lbu	a2,0(a3)
 2ce:	fd06071b          	addiw	a4,a2,-48
 2d2:	0ff77713          	andi	a4,a4,255
 2d6:	fee5f1e3          	bgeu	a1,a4,2b8 <atoi+0x1e>
  return n;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  n = 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <atoi+0x40>

00000000000002e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ea:	02b57663          	bgeu	a0,a1,316 <memmove+0x32>
    while(n-- > 0)
 2ee:	02c05163          	blez	a2,310 <memmove+0x2c>
 2f2:	fff6079b          	addiw	a5,a2,-1
 2f6:	1782                	slli	a5,a5,0x20
 2f8:	9381                	srli	a5,a5,0x20
 2fa:	0785                	addi	a5,a5,1
 2fc:	97aa                	add	a5,a5,a0
  dst = vdst;
 2fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 300:	0585                	addi	a1,a1,1
 302:	0705                	addi	a4,a4,1
 304:	fff5c683          	lbu	a3,-1(a1)
 308:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
    dst += n;
 316:	00c50733          	add	a4,a0,a2
    src += n;
 31a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31c:	fec05ae3          	blez	a2,310 <memmove+0x2c>
 320:	fff6079b          	addiw	a5,a2,-1
 324:	1782                	slli	a5,a5,0x20
 326:	9381                	srli	a5,a5,0x20
 328:	fff7c793          	not	a5,a5
 32c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32e:	15fd                	addi	a1,a1,-1
 330:	177d                	addi	a4,a4,-1
 332:	0005c683          	lbu	a3,0(a1)
 336:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33a:	fee79ae3          	bne	a5,a4,32e <memmove+0x4a>
 33e:	bfc9                	j	310 <memmove+0x2c>

0000000000000340 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 346:	ca05                	beqz	a2,376 <memcmp+0x36>
 348:	fff6069b          	addiw	a3,a2,-1
 34c:	1682                	slli	a3,a3,0x20
 34e:	9281                	srli	a3,a3,0x20
 350:	0685                	addi	a3,a3,1
 352:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 354:	00054783          	lbu	a5,0(a0)
 358:	0005c703          	lbu	a4,0(a1)
 35c:	00e79863          	bne	a5,a4,36c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 360:	0505                	addi	a0,a0,1
    p2++;
 362:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 364:	fed518e3          	bne	a0,a3,354 <memcmp+0x14>
  }
  return 0;
 368:	4501                	li	a0,0
 36a:	a019                	j	370 <memcmp+0x30>
      return *p1 - *p2;
 36c:	40e7853b          	subw	a0,a5,a4
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  return 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <memcmp+0x30>

000000000000037a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 382:	00000097          	auipc	ra,0x0
 386:	f62080e7          	jalr	-158(ra) # 2e4 <memmove>
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret

0000000000000392 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 392:	4885                	li	a7,1
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exit>:
.global exit
exit:
 li a7, SYS_exit
 39a:	4889                	li	a7,2
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a2:	488d                	li	a7,3
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3aa:	4891                	li	a7,4
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <read>:
.global read
read:
 li a7, SYS_read
 3b2:	4895                	li	a7,5
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <write>:
.global write
write:
 li a7, SYS_write
 3ba:	48c1                	li	a7,16
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <close>:
.global close
close:
 li a7, SYS_close
 3c2:	48d5                	li	a7,21
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ca:	4899                	li	a7,6
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d2:	489d                	li	a7,7
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <open>:
.global open
open:
 li a7, SYS_open
 3da:	48bd                	li	a7,15
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e2:	48c5                	li	a7,17
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ea:	48c9                	li	a7,18
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f2:	48a1                	li	a7,8
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <link>:
.global link
link:
 li a7, SYS_link
 3fa:	48cd                	li	a7,19
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 402:	48d1                	li	a7,20
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40a:	48a5                	li	a7,9
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <dup>:
.global dup
dup:
 li a7, SYS_dup
 412:	48a9                	li	a7,10
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41a:	48ad                	li	a7,11
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 422:	48b1                	li	a7,12
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42a:	48b5                	li	a7,13
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 432:	48b9                	li	a7,14
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 43a:	48d9                	li	a7,22
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <yield>:
.global yield
yield:
 li a7, SYS_yield
 442:	48dd                	li	a7,23
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 44a:	48e1                	li	a7,24
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 452:	48e5                	li	a7,25
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 45a:	48e9                	li	a7,26
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <ps>:
.global ps
ps:
 li a7, SYS_ps
 462:	48ed                	li	a7,27
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 46a:	48f1                	li	a7,28
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 472:	48f5                	li	a7,29
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 47a:	48f9                	li	a7,30
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 482:	48fd                	li	a7,31
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 48a:	02000893          	li	a7,32
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 494:	02100893          	li	a7,33
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 49e:	02200893          	li	a7,34
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 4a8:	02300893          	li	a7,35
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 4b2:	02500893          	li	a7,37
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 4bc:	02400893          	li	a7,36
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 4c6:	02600893          	li	a7,38
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 4d0:	02800893          	li	a7,40
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 4da:	02700893          	li	a7,39
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e4:	1101                	addi	sp,sp,-32
 4e6:	ec06                	sd	ra,24(sp)
 4e8:	e822                	sd	s0,16(sp)
 4ea:	1000                	addi	s0,sp,32
 4ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f0:	4605                	li	a2,1
 4f2:	fef40593          	addi	a1,s0,-17
 4f6:	00000097          	auipc	ra,0x0
 4fa:	ec4080e7          	jalr	-316(ra) # 3ba <write>
}
 4fe:	60e2                	ld	ra,24(sp)
 500:	6442                	ld	s0,16(sp)
 502:	6105                	addi	sp,sp,32
 504:	8082                	ret

0000000000000506 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 506:	7139                	addi	sp,sp,-64
 508:	fc06                	sd	ra,56(sp)
 50a:	f822                	sd	s0,48(sp)
 50c:	f426                	sd	s1,40(sp)
 50e:	f04a                	sd	s2,32(sp)
 510:	ec4e                	sd	s3,24(sp)
 512:	0080                	addi	s0,sp,64
 514:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 516:	c299                	beqz	a3,51c <printint+0x16>
 518:	0805c863          	bltz	a1,5a8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51c:	2581                	sext.w	a1,a1
  neg = 0;
 51e:	4881                	li	a7,0
 520:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 524:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 526:	2601                	sext.w	a2,a2
 528:	00000517          	auipc	a0,0x0
 52c:	4c850513          	addi	a0,a0,1224 # 9f0 <digits>
 530:	883a                	mv	a6,a4
 532:	2705                	addiw	a4,a4,1
 534:	02c5f7bb          	remuw	a5,a1,a2
 538:	1782                	slli	a5,a5,0x20
 53a:	9381                	srli	a5,a5,0x20
 53c:	97aa                	add	a5,a5,a0
 53e:	0007c783          	lbu	a5,0(a5)
 542:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 546:	0005879b          	sext.w	a5,a1
 54a:	02c5d5bb          	divuw	a1,a1,a2
 54e:	0685                	addi	a3,a3,1
 550:	fec7f0e3          	bgeu	a5,a2,530 <printint+0x2a>
  if(neg)
 554:	00088b63          	beqz	a7,56a <printint+0x64>
    buf[i++] = '-';
 558:	fd040793          	addi	a5,s0,-48
 55c:	973e                	add	a4,a4,a5
 55e:	02d00793          	li	a5,45
 562:	fef70823          	sb	a5,-16(a4)
 566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56a:	02e05863          	blez	a4,59a <printint+0x94>
 56e:	fc040793          	addi	a5,s0,-64
 572:	00e78933          	add	s2,a5,a4
 576:	fff78993          	addi	s3,a5,-1
 57a:	99ba                	add	s3,s3,a4
 57c:	377d                	addiw	a4,a4,-1
 57e:	1702                	slli	a4,a4,0x20
 580:	9301                	srli	a4,a4,0x20
 582:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 586:	fff94583          	lbu	a1,-1(s2)
 58a:	8526                	mv	a0,s1
 58c:	00000097          	auipc	ra,0x0
 590:	f58080e7          	jalr	-168(ra) # 4e4 <putc>
  while(--i >= 0)
 594:	197d                	addi	s2,s2,-1
 596:	ff3918e3          	bne	s2,s3,586 <printint+0x80>
}
 59a:	70e2                	ld	ra,56(sp)
 59c:	7442                	ld	s0,48(sp)
 59e:	74a2                	ld	s1,40(sp)
 5a0:	7902                	ld	s2,32(sp)
 5a2:	69e2                	ld	s3,24(sp)
 5a4:	6121                	addi	sp,sp,64
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bf8d                	j	520 <printint+0x1a>

00000000000005b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b0:	7119                	addi	sp,sp,-128
 5b2:	fc86                	sd	ra,120(sp)
 5b4:	f8a2                	sd	s0,112(sp)
 5b6:	f4a6                	sd	s1,104(sp)
 5b8:	f0ca                	sd	s2,96(sp)
 5ba:	ecce                	sd	s3,88(sp)
 5bc:	e8d2                	sd	s4,80(sp)
 5be:	e4d6                	sd	s5,72(sp)
 5c0:	e0da                	sd	s6,64(sp)
 5c2:	fc5e                	sd	s7,56(sp)
 5c4:	f862                	sd	s8,48(sp)
 5c6:	f466                	sd	s9,40(sp)
 5c8:	f06a                	sd	s10,32(sp)
 5ca:	ec6e                	sd	s11,24(sp)
 5cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ce:	0005c903          	lbu	s2,0(a1)
 5d2:	18090f63          	beqz	s2,770 <vprintf+0x1c0>
 5d6:	8aaa                	mv	s5,a0
 5d8:	8b32                	mv	s6,a2
 5da:	00158493          	addi	s1,a1,1
  state = 0;
 5de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e0:	02500a13          	li	s4,37
      if(c == 'd'){
 5e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5e8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5f0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f4:	00000b97          	auipc	s7,0x0
 5f8:	3fcb8b93          	addi	s7,s7,1020 # 9f0 <digits>
 5fc:	a839                	j	61a <vprintf+0x6a>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	ee2080e7          	jalr	-286(ra) # 4e4 <putc>
 60a:	a019                	j	610 <vprintf+0x60>
    } else if(state == '%'){
 60c:	01498f63          	beq	s3,s4,62a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 610:	0485                	addi	s1,s1,1
 612:	fff4c903          	lbu	s2,-1(s1)
 616:	14090d63          	beqz	s2,770 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 61a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 61e:	fe0997e3          	bnez	s3,60c <vprintf+0x5c>
      if(c == '%'){
 622:	fd479ee3          	bne	a5,s4,5fe <vprintf+0x4e>
        state = '%';
 626:	89be                	mv	s3,a5
 628:	b7e5                	j	610 <vprintf+0x60>
      if(c == 'd'){
 62a:	05878063          	beq	a5,s8,66a <vprintf+0xba>
      } else if(c == 'l') {
 62e:	05978c63          	beq	a5,s9,686 <vprintf+0xd6>
      } else if(c == 'x') {
 632:	07a78863          	beq	a5,s10,6a2 <vprintf+0xf2>
      } else if(c == 'p') {
 636:	09b78463          	beq	a5,s11,6be <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 63a:	07300713          	li	a4,115
 63e:	0ce78663          	beq	a5,a4,70a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 642:	06300713          	li	a4,99
 646:	0ee78e63          	beq	a5,a4,742 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 64a:	11478863          	beq	a5,s4,75a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64e:	85d2                	mv	a1,s4
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e92080e7          	jalr	-366(ra) # 4e4 <putc>
        putc(fd, c);
 65a:	85ca                	mv	a1,s2
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e86080e7          	jalr	-378(ra) # 4e4 <putc>
      }
      state = 0;
 666:	4981                	li	s3,0
 668:	b765                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b0913          	addi	s2,s6,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000b2583          	lw	a1,0(s6)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e8e080e7          	jalr	-370(ra) # 506 <printint>
 680:	8b4a                	mv	s6,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	b771                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b0913          	addi	s2,s6,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000b2583          	lw	a1,0(s6)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e72080e7          	jalr	-398(ra) # 506 <printint>
 69c:	8b4a                	mv	s6,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bf85                	j	610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6a2:	008b0913          	addi	s2,s6,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000b2583          	lw	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e56080e7          	jalr	-426(ra) # 506 <printint>
 6b8:	8b4a                	mv	s6,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bf91                	j	610 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6be:	008b0793          	addi	a5,s6,8
 6c2:	f8f43423          	sd	a5,-120(s0)
 6c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ca:	03000593          	li	a1,48
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e14080e7          	jalr	-492(ra) # 4e4 <putc>
  putc(fd, 'x');
 6d8:	85ea                	mv	a1,s10
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e08080e7          	jalr	-504(ra) # 4e4 <putc>
 6e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	03c9d793          	srli	a5,s3,0x3c
 6ea:	97de                	add	a5,a5,s7
 6ec:	0007c583          	lbu	a1,0(a5)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	df2080e7          	jalr	-526(ra) # 4e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	397d                	addiw	s2,s2,-1
 6fe:	fe0914e3          	bnez	s2,6e6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 702:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 706:	4981                	li	s3,0
 708:	b721                	j	610 <vprintf+0x60>
        s = va_arg(ap, char*);
 70a:	008b0993          	addi	s3,s6,8
 70e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 712:	02090163          	beqz	s2,734 <vprintf+0x184>
        while(*s != 0){
 716:	00094583          	lbu	a1,0(s2)
 71a:	c9a1                	beqz	a1,76a <vprintf+0x1ba>
          putc(fd, *s);
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dc6080e7          	jalr	-570(ra) # 4e4 <putc>
          s++;
 726:	0905                	addi	s2,s2,1
        while(*s != 0){
 728:	00094583          	lbu	a1,0(s2)
 72c:	f9e5                	bnez	a1,71c <vprintf+0x16c>
        s = va_arg(ap, char*);
 72e:	8b4e                	mv	s6,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	bdf9                	j	610 <vprintf+0x60>
          s = "(null)";
 734:	00000917          	auipc	s2,0x0
 738:	2b490913          	addi	s2,s2,692 # 9e8 <malloc+0x16e>
        while(*s != 0){
 73c:	02800593          	li	a1,40
 740:	bff1                	j	71c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 742:	008b0913          	addi	s2,s6,8
 746:	000b4583          	lbu	a1,0(s6)
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	d98080e7          	jalr	-616(ra) # 4e4 <putc>
 754:	8b4a                	mv	s6,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	bd65                	j	610 <vprintf+0x60>
        putc(fd, c);
 75a:	85d2                	mv	a1,s4
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	d86080e7          	jalr	-634(ra) # 4e4 <putc>
      state = 0;
 766:	4981                	li	s3,0
 768:	b565                	j	610 <vprintf+0x60>
        s = va_arg(ap, char*);
 76a:	8b4e                	mv	s6,s3
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b54d                	j	610 <vprintf+0x60>
    }
  }
}
 770:	70e6                	ld	ra,120(sp)
 772:	7446                	ld	s0,112(sp)
 774:	74a6                	ld	s1,104(sp)
 776:	7906                	ld	s2,96(sp)
 778:	69e6                	ld	s3,88(sp)
 77a:	6a46                	ld	s4,80(sp)
 77c:	6aa6                	ld	s5,72(sp)
 77e:	6b06                	ld	s6,64(sp)
 780:	7be2                	ld	s7,56(sp)
 782:	7c42                	ld	s8,48(sp)
 784:	7ca2                	ld	s9,40(sp)
 786:	7d02                	ld	s10,32(sp)
 788:	6de2                	ld	s11,24(sp)
 78a:	6109                	addi	sp,sp,128
 78c:	8082                	ret

000000000000078e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78e:	715d                	addi	sp,sp,-80
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e010                	sd	a2,0(s0)
 798:	e414                	sd	a3,8(s0)
 79a:	e818                	sd	a4,16(s0)
 79c:	ec1c                	sd	a5,24(s0)
 79e:	03043023          	sd	a6,32(s0)
 7a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7aa:	8622                	mv	a2,s0
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e04080e7          	jalr	-508(ra) # 5b0 <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6161                	addi	sp,sp,80
 7ba:	8082                	ret

00000000000007bc <printf>:

void
printf(const char *fmt, ...)
{
 7bc:	711d                	addi	sp,sp,-96
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e40c                	sd	a1,8(s0)
 7c6:	e810                	sd	a2,16(s0)
 7c8:	ec14                	sd	a3,24(s0)
 7ca:	f018                	sd	a4,32(s0)
 7cc:	f41c                	sd	a5,40(s0)
 7ce:	03043823          	sd	a6,48(s0)
 7d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d6:	00840613          	addi	a2,s0,8
 7da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7de:	85aa                	mv	a1,a0
 7e0:	4505                	li	a0,1
 7e2:	00000097          	auipc	ra,0x0
 7e6:	dce080e7          	jalr	-562(ra) # 5b0 <vprintf>
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	6125                	addi	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f2:	1141                	addi	sp,sp,-16
 7f4:	e422                	sd	s0,8(sp)
 7f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	00000797          	auipc	a5,0x0
 800:	20c7b783          	ld	a5,524(a5) # a08 <freep>
 804:	a805                	j	834 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 806:	4618                	lw	a4,8(a2)
 808:	9db9                	addw	a1,a1,a4
 80a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	6318                	ld	a4,0(a4)
 812:	fee53823          	sd	a4,-16(a0)
 816:	a091                	j	85a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 818:	ff852703          	lw	a4,-8(a0)
 81c:	9e39                	addw	a2,a2,a4
 81e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 820:	ff053703          	ld	a4,-16(a0)
 824:	e398                	sd	a4,0(a5)
 826:	a099                	j	86c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x40>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x50>
{
 832:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x36>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059713          	slli	a4,a1,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	9736                	add	a4,a4,a3
 852:	fae60ae3          	beq	a2,a4,806 <free+0x14>
    bp->s.ptr = p->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85a:	4790                	lw	a2,8(a5)
 85c:	02061713          	slli	a4,a2,0x20
 860:	9301                	srli	a4,a4,0x20
 862:	0712                	slli	a4,a4,0x4
 864:	973e                	add	a4,a4,a5
 866:	fae689e3          	beq	a3,a4,818 <free+0x26>
  } else
    p->s.ptr = bp;
 86a:	e394                	sd	a3,0(a5)
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	18f73e23          	sd	a5,412(a4) # a08 <freep>
}
 874:	6422                	ld	s0,8(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret

000000000000087a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87a:	7139                	addi	sp,sp,-64
 87c:	fc06                	sd	ra,56(sp)
 87e:	f822                	sd	s0,48(sp)
 880:	f426                	sd	s1,40(sp)
 882:	f04a                	sd	s2,32(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051493          	slli	s1,a0,0x20
 892:	9081                	srli	s1,s1,0x20
 894:	04bd                	addi	s1,s1,15
 896:	8091                	srli	s1,s1,0x4
 898:	0014899b          	addiw	s3,s1,1
 89c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89e:	00000517          	auipc	a0,0x0
 8a2:	16a53503          	ld	a0,362(a0) # a08 <freep>
 8a6:	c515                	beqz	a0,8d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	02977f63          	bgeu	a4,s1,8ea <malloc+0x70>
 8b0:	8a4e                	mv	s4,s3
 8b2:	0009871b          	sext.w	a4,s3
 8b6:	6685                	lui	a3,0x1
 8b8:	00d77363          	bgeu	a4,a3,8be <malloc+0x44>
 8bc:	6a05                	lui	s4,0x1
 8be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c6:	00000917          	auipc	s2,0x0
 8ca:	14290913          	addi	s2,s2,322 # a08 <freep>
  if(p == (char*)-1)
 8ce:	5afd                	li	s5,-1
 8d0:	a88d                	j	942 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	13e78793          	addi	a5,a5,318 # a10 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	12f73723          	sd	a5,302(a4) # a08 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7e1                	j	8b0 <malloc+0x36>
      if(p->s.size == nunits)
 8ea:	02e48b63          	beq	s1,a4,920 <malloc+0xa6>
        p->s.size -= nunits;
 8ee:	4137073b          	subw	a4,a4,s3
 8f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f4:	1702                	slli	a4,a4,0x20
 8f6:	9301                	srli	a4,a4,0x20
 8f8:	0712                	slli	a4,a4,0x4
 8fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 900:	00000717          	auipc	a4,0x0
 904:	10a73423          	sd	a0,264(a4) # a08 <freep>
      return (void*)(p + 1);
 908:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 90c:	70e2                	ld	ra,56(sp)
 90e:	7442                	ld	s0,48(sp)
 910:	74a2                	ld	s1,40(sp)
 912:	7902                	ld	s2,32(sp)
 914:	69e2                	ld	s3,24(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	e118                	sd	a4,0(a0)
 924:	bff1                	j	900 <malloc+0x86>
  hp->s.size = nu;
 926:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92a:	0541                	addi	a0,a0,16
 92c:	00000097          	auipc	ra,0x0
 930:	ec6080e7          	jalr	-314(ra) # 7f2 <free>
  return freep;
 934:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 938:	d971                	beqz	a0,90c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	fa9776e3          	bgeu	a4,s1,8ea <malloc+0x70>
    if(p == freep)
 942:	00093703          	ld	a4,0(s2)
 946:	853e                	mv	a0,a5
 948:	fef719e3          	bne	a4,a5,93a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 94c:	8552                	mv	a0,s4
 94e:	00000097          	auipc	ra,0x0
 952:	ad4080e7          	jalr	-1324(ra) # 422 <sbrk>
  if(p == (char*)-1)
 956:	fd5518e3          	bne	a0,s5,926 <malloc+0xac>
        return 0;
 95a:	4501                	li	a0,0
 95c:	bf45                	j	90c <malloc+0x92>
