
user/_testyield:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i, y;
  int x = fork();
  10:	00000097          	auipc	ra,0x0
  14:	2fc080e7          	jalr	764(ra) # 30c <fork>
  18:	8a2a                	mv	s4,a0

  for (i=0; i<5; i++) {
  1a:	4481                	li	s1,0
     fprintf(2, "%d: looped %d times", getpid(), i);
  1c:	00001997          	auipc	s3,0x1
  20:	8bc98993          	addi	s3,s3,-1860 # 8d8 <malloc+0xe4>
  for (i=0; i<5; i++) {
  24:	4915                	li	s2,5
     fprintf(2, "%d: looped %d times", getpid(), i);
  26:	00000097          	auipc	ra,0x0
  2a:	36e080e7          	jalr	878(ra) # 394 <getpid>
  2e:	862a                	mv	a2,a0
  30:	86a6                	mv	a3,s1
  32:	85ce                	mv	a1,s3
  34:	4509                	li	a0,2
  36:	00000097          	auipc	ra,0x0
  3a:	6d2080e7          	jalr	1746(ra) # 708 <fprintf>
     yield();
  3e:	00000097          	auipc	ra,0x0
  42:	37e080e7          	jalr	894(ra) # 3bc <yield>
  for (i=0; i<5; i++) {
  46:	2485                	addiw	s1,s1,1
  48:	fd249fe3          	bne	s1,s2,26 <main+0x26>
  }
  if (x > 0) {
  4c:	01404763          	bgtz	s4,5a <main+0x5a>
     printf("%d: before wait\n", getpid());
     y = wait(0);
     printf("%d: after wait for pid %d\n", getpid(), y);
  }
  exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	2c2080e7          	jalr	706(ra) # 314 <exit>
     printf("%d: before wait\n", getpid());
  5a:	00000097          	auipc	ra,0x0
  5e:	33a080e7          	jalr	826(ra) # 394 <getpid>
  62:	85aa                	mv	a1,a0
  64:	00001517          	auipc	a0,0x1
  68:	88c50513          	addi	a0,a0,-1908 # 8f0 <malloc+0xfc>
  6c:	00000097          	auipc	ra,0x0
  70:	6ca080e7          	jalr	1738(ra) # 736 <printf>
     y = wait(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	2a6080e7          	jalr	678(ra) # 31c <wait>
  7e:	84aa                	mv	s1,a0
     printf("%d: after wait for pid %d\n", getpid(), y);
  80:	00000097          	auipc	ra,0x0
  84:	314080e7          	jalr	788(ra) # 394 <getpid>
  88:	85aa                	mv	a1,a0
  8a:	8626                	mv	a2,s1
  8c:	00001517          	auipc	a0,0x1
  90:	87c50513          	addi	a0,a0,-1924 # 908 <malloc+0x114>
  94:	00000097          	auipc	ra,0x0
  98:	6a2080e7          	jalr	1698(ra) # 736 <printf>
  9c:	bf55                	j	50 <main+0x50>

000000000000009e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0x8>
    ;
  return os;
}
  b4:	6422                	ld	s0,8(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cb91                	beqz	a5,d8 <strcmp+0x1e>
  c6:	0005c703          	lbu	a4,0(a1)
  ca:	00f71763          	bne	a4,a5,d8 <strcmp+0x1e>
    p++, q++;
  ce:	0505                	addi	a0,a0,1
  d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbe5                	bnez	a5,c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d8:	0005c503          	lbu	a0,0(a1)
}
  dc:	40a7853b          	subw	a0,a5,a0
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strlen>:

uint
strlen(const char *s)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf91                	beqz	a5,10c <strlen+0x26>
  f2:	0505                	addi	a0,a0,1
  f4:	87aa                	mv	a5,a0
  f6:	4685                	li	a3,1
  f8:	9e89                	subw	a3,a3,a0
  fa:	00f6853b          	addw	a0,a3,a5
  fe:	0785                	addi	a5,a5,1
 100:	fff7c703          	lbu	a4,-1(a5)
 104:	fb7d                	bnez	a4,fa <strlen+0x14>
    ;
  return n;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  for(n = 0; s[n]; n++)
 10c:	4501                	li	a0,0
 10e:	bfe5                	j	106 <strlen+0x20>

0000000000000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 116:	ce09                	beqz	a2,130 <memset+0x20>
 118:	87aa                	mv	a5,a0
 11a:	fff6071b          	addiw	a4,a2,-1
 11e:	1702                	slli	a4,a4,0x20
 120:	9301                	srli	a4,a4,0x20
 122:	0705                	addi	a4,a4,1
 124:	972a                	add	a4,a4,a0
    cdst[i] = c;
 126:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 12a:	0785                	addi	a5,a5,1
 12c:	fee79de3          	bne	a5,a4,126 <memset+0x16>
  }
  return dst;
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <strchr>:

char*
strchr(const char *s, char c)
{
 136:	1141                	addi	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cb99                	beqz	a5,156 <strchr+0x20>
    if(*s == c)
 142:	00f58763          	beq	a1,a5,150 <strchr+0x1a>
  for(; *s; s++)
 146:	0505                	addi	a0,a0,1
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbfd                	bnez	a5,142 <strchr+0xc>
      return (char*)s;
  return 0;
 14e:	4501                	li	a0,0
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  return 0;
 156:	4501                	li	a0,0
 158:	bfe5                	j	150 <strchr+0x1a>

000000000000015a <gets>:

char*
gets(char *buf, int max)
{
 15a:	711d                	addi	sp,sp,-96
 15c:	ec86                	sd	ra,88(sp)
 15e:	e8a2                	sd	s0,80(sp)
 160:	e4a6                	sd	s1,72(sp)
 162:	e0ca                	sd	s2,64(sp)
 164:	fc4e                	sd	s3,56(sp)
 166:	f852                	sd	s4,48(sp)
 168:	f456                	sd	s5,40(sp)
 16a:	f05a                	sd	s6,32(sp)
 16c:	ec5e                	sd	s7,24(sp)
 16e:	1080                	addi	s0,sp,96
 170:	8baa                	mv	s7,a0
 172:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	892a                	mv	s2,a0
 176:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 178:	4aa9                	li	s5,10
 17a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17c:	89a6                	mv	s3,s1
 17e:	2485                	addiw	s1,s1,1
 180:	0344d863          	bge	s1,s4,1b0 <gets+0x56>
    cc = read(0, &c, 1);
 184:	4605                	li	a2,1
 186:	faf40593          	addi	a1,s0,-81
 18a:	4501                	li	a0,0
 18c:	00000097          	auipc	ra,0x0
 190:	1a0080e7          	jalr	416(ra) # 32c <read>
    if(cc < 1)
 194:	00a05e63          	blez	a0,1b0 <gets+0x56>
    buf[i++] = c;
 198:	faf44783          	lbu	a5,-81(s0)
 19c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a0:	01578763          	beq	a5,s5,1ae <gets+0x54>
 1a4:	0905                	addi	s2,s2,1
 1a6:	fd679be3          	bne	a5,s6,17c <gets+0x22>
  for(i=0; i+1 < max; ){
 1aa:	89a6                	mv	s3,s1
 1ac:	a011                	j	1b0 <gets+0x56>
 1ae:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b0:	99de                	add	s3,s3,s7
 1b2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b6:	855e                	mv	a0,s7
 1b8:	60e6                	ld	ra,88(sp)
 1ba:	6446                	ld	s0,80(sp)
 1bc:	64a6                	ld	s1,72(sp)
 1be:	6906                	ld	s2,64(sp)
 1c0:	79e2                	ld	s3,56(sp)
 1c2:	7a42                	ld	s4,48(sp)
 1c4:	7aa2                	ld	s5,40(sp)
 1c6:	7b02                	ld	s6,32(sp)
 1c8:	6be2                	ld	s7,24(sp)
 1ca:	6125                	addi	sp,sp,96
 1cc:	8082                	ret

00000000000001ce <stat>:

int
stat(const char *n, struct stat *st)
{
 1ce:	1101                	addi	sp,sp,-32
 1d0:	ec06                	sd	ra,24(sp)
 1d2:	e822                	sd	s0,16(sp)
 1d4:	e426                	sd	s1,8(sp)
 1d6:	e04a                	sd	s2,0(sp)
 1d8:	1000                	addi	s0,sp,32
 1da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dc:	4581                	li	a1,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	176080e7          	jalr	374(ra) # 354 <open>
  if(fd < 0)
 1e6:	02054563          	bltz	a0,210 <stat+0x42>
 1ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ec:	85ca                	mv	a1,s2
 1ee:	00000097          	auipc	ra,0x0
 1f2:	17e080e7          	jalr	382(ra) # 36c <fstat>
 1f6:	892a                	mv	s2,a0
  close(fd);
 1f8:	8526                	mv	a0,s1
 1fa:	00000097          	auipc	ra,0x0
 1fe:	142080e7          	jalr	322(ra) # 33c <close>
  return r;
}
 202:	854a                	mv	a0,s2
 204:	60e2                	ld	ra,24(sp)
 206:	6442                	ld	s0,16(sp)
 208:	64a2                	ld	s1,8(sp)
 20a:	6902                	ld	s2,0(sp)
 20c:	6105                	addi	sp,sp,32
 20e:	8082                	ret
    return -1;
 210:	597d                	li	s2,-1
 212:	bfc5                	j	202 <stat+0x34>

0000000000000214 <atoi>:

int
atoi(const char *s)
{
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21a:	00054603          	lbu	a2,0(a0)
 21e:	fd06079b          	addiw	a5,a2,-48
 222:	0ff7f793          	andi	a5,a5,255
 226:	4725                	li	a4,9
 228:	02f76963          	bltu	a4,a5,25a <atoi+0x46>
 22c:	86aa                	mv	a3,a0
  n = 0;
 22e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 230:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 232:	0685                	addi	a3,a3,1
 234:	0025179b          	slliw	a5,a0,0x2
 238:	9fa9                	addw	a5,a5,a0
 23a:	0017979b          	slliw	a5,a5,0x1
 23e:	9fb1                	addw	a5,a5,a2
 240:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 244:	0006c603          	lbu	a2,0(a3)
 248:	fd06071b          	addiw	a4,a2,-48
 24c:	0ff77713          	andi	a4,a4,255
 250:	fee5f1e3          	bgeu	a1,a4,232 <atoi+0x1e>
  return n;
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
  n = 0;
 25a:	4501                	li	a0,0
 25c:	bfe5                	j	254 <atoi+0x40>

000000000000025e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 264:	02b57663          	bgeu	a0,a1,290 <memmove+0x32>
    while(n-- > 0)
 268:	02c05163          	blez	a2,28a <memmove+0x2c>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	0785                	addi	a5,a5,1
 276:	97aa                	add	a5,a5,a0
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	addi	a1,a1,1
 27c:	0705                	addi	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 296:	fec05ae3          	blez	a2,28a <memmove+0x2c>
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	addi	a1,a1,-1
 2aa:	177d                	addi	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x4a>
 2b8:	bfc9                	j	28a <memmove+0x2c>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addiw	a3,a2,-1
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	addi	a0,a0,1
    p2++;
 2dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f62080e7          	jalr	-158(ra) # 25e <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <yield>:
.global yield
yield:
 li a7, SYS_yield
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 3c4:	48e1                	li	a7,24
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 3cc:	48e5                	li	a7,25
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 3d4:	48e9                	li	a7,26
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <ps>:
.global ps
ps:
 li a7, SYS_ps
 3dc:	48ed                	li	a7,27
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 3e4:	48f1                	li	a7,28
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 3ec:	48f5                	li	a7,29
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 3f4:	48f9                	li	a7,30
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 3fc:	48fd                	li	a7,31
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 404:	02000893          	li	a7,32
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 40e:	02100893          	li	a7,33
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 418:	02200893          	li	a7,34
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 422:	02300893          	li	a7,35
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 42c:	02500893          	li	a7,37
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 436:	02400893          	li	a7,36
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 440:	02600893          	li	a7,38
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 44a:	02800893          	li	a7,40
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 454:	02700893          	li	a7,39
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	00000097          	auipc	ra,0x0
 474:	ec4080e7          	jalr	-316(ra) # 334 <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	7139                	addi	sp,sp,-64
 482:	fc06                	sd	ra,56(sp)
 484:	f822                	sd	s0,48(sp)
 486:	f426                	sd	s1,40(sp)
 488:	f04a                	sd	s2,32(sp)
 48a:	ec4e                	sd	s3,24(sp)
 48c:	0080                	addi	s0,sp,64
 48e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 490:	c299                	beqz	a3,496 <printint+0x16>
 492:	0805c863          	bltz	a1,522 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 496:	2581                	sext.w	a1,a1
  neg = 0;
 498:	4881                	li	a7,0
 49a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a0:	2601                	sext.w	a2,a2
 4a2:	00000517          	auipc	a0,0x0
 4a6:	48e50513          	addi	a0,a0,1166 # 930 <digits>
 4aa:	883a                	mv	a6,a4
 4ac:	2705                	addiw	a4,a4,1
 4ae:	02c5f7bb          	remuw	a5,a1,a2
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	97aa                	add	a5,a5,a0
 4b8:	0007c783          	lbu	a5,0(a5)
 4bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c0:	0005879b          	sext.w	a5,a1
 4c4:	02c5d5bb          	divuw	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec7f0e3          	bgeu	a5,a2,4aa <printint+0x2a>
  if(neg)
 4ce:	00088b63          	beqz	a7,4e4 <printint+0x64>
    buf[i++] = '-';
 4d2:	fd040793          	addi	a5,s0,-48
 4d6:	973e                	add	a4,a4,a5
 4d8:	02d00793          	li	a5,45
 4dc:	fef70823          	sb	a5,-16(a4)
 4e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e4:	02e05863          	blez	a4,514 <printint+0x94>
 4e8:	fc040793          	addi	a5,s0,-64
 4ec:	00e78933          	add	s2,a5,a4
 4f0:	fff78993          	addi	s3,a5,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	377d                	addiw	a4,a4,-1
 4f8:	1702                	slli	a4,a4,0x20
 4fa:	9301                	srli	a4,a4,0x20
 4fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 500:	fff94583          	lbu	a1,-1(s2)
 504:	8526                	mv	a0,s1
 506:	00000097          	auipc	ra,0x0
 50a:	f58080e7          	jalr	-168(ra) # 45e <putc>
  while(--i >= 0)
 50e:	197d                	addi	s2,s2,-1
 510:	ff3918e3          	bne	s2,s3,500 <printint+0x80>
}
 514:	70e2                	ld	ra,56(sp)
 516:	7442                	ld	s0,48(sp)
 518:	74a2                	ld	s1,40(sp)
 51a:	7902                	ld	s2,32(sp)
 51c:	69e2                	ld	s3,24(sp)
 51e:	6121                	addi	sp,sp,64
 520:	8082                	ret
    x = -xx;
 522:	40b005bb          	negw	a1,a1
    neg = 1;
 526:	4885                	li	a7,1
    x = -xx;
 528:	bf8d                	j	49a <printint+0x1a>

000000000000052a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52a:	7119                	addi	sp,sp,-128
 52c:	fc86                	sd	ra,120(sp)
 52e:	f8a2                	sd	s0,112(sp)
 530:	f4a6                	sd	s1,104(sp)
 532:	f0ca                	sd	s2,96(sp)
 534:	ecce                	sd	s3,88(sp)
 536:	e8d2                	sd	s4,80(sp)
 538:	e4d6                	sd	s5,72(sp)
 53a:	e0da                	sd	s6,64(sp)
 53c:	fc5e                	sd	s7,56(sp)
 53e:	f862                	sd	s8,48(sp)
 540:	f466                	sd	s9,40(sp)
 542:	f06a                	sd	s10,32(sp)
 544:	ec6e                	sd	s11,24(sp)
 546:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 548:	0005c903          	lbu	s2,0(a1)
 54c:	18090f63          	beqz	s2,6ea <vprintf+0x1c0>
 550:	8aaa                	mv	s5,a0
 552:	8b32                	mv	s6,a2
 554:	00158493          	addi	s1,a1,1
  state = 0;
 558:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55a:	02500a13          	li	s4,37
      if(c == 'd'){
 55e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 562:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 566:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 56a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56e:	00000b97          	auipc	s7,0x0
 572:	3c2b8b93          	addi	s7,s7,962 # 930 <digits>
 576:	a839                	j	594 <vprintf+0x6a>
        putc(fd, c);
 578:	85ca                	mv	a1,s2
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	ee2080e7          	jalr	-286(ra) # 45e <putc>
 584:	a019                	j	58a <vprintf+0x60>
    } else if(state == '%'){
 586:	01498f63          	beq	s3,s4,5a4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 58a:	0485                	addi	s1,s1,1
 58c:	fff4c903          	lbu	s2,-1(s1)
 590:	14090d63          	beqz	s2,6ea <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 594:	0009079b          	sext.w	a5,s2
    if(state == 0){
 598:	fe0997e3          	bnez	s3,586 <vprintf+0x5c>
      if(c == '%'){
 59c:	fd479ee3          	bne	a5,s4,578 <vprintf+0x4e>
        state = '%';
 5a0:	89be                	mv	s3,a5
 5a2:	b7e5                	j	58a <vprintf+0x60>
      if(c == 'd'){
 5a4:	05878063          	beq	a5,s8,5e4 <vprintf+0xba>
      } else if(c == 'l') {
 5a8:	05978c63          	beq	a5,s9,600 <vprintf+0xd6>
      } else if(c == 'x') {
 5ac:	07a78863          	beq	a5,s10,61c <vprintf+0xf2>
      } else if(c == 'p') {
 5b0:	09b78463          	beq	a5,s11,638 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b4:	07300713          	li	a4,115
 5b8:	0ce78663          	beq	a5,a4,684 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5bc:	06300713          	li	a4,99
 5c0:	0ee78e63          	beq	a5,a4,6bc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c4:	11478863          	beq	a5,s4,6d4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c8:	85d2                	mv	a1,s4
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e92080e7          	jalr	-366(ra) # 45e <putc>
        putc(fd, c);
 5d4:	85ca                	mv	a1,s2
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e86080e7          	jalr	-378(ra) # 45e <putc>
      }
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b765                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e4:	008b0913          	addi	s2,s6,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000b2583          	lw	a1,0(s6)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e8e080e7          	jalr	-370(ra) # 480 <printint>
 5fa:	8b4a                	mv	s6,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b771                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b0913          	addi	s2,s6,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000b2583          	lw	a1,0(s6)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e72080e7          	jalr	-398(ra) # 480 <printint>
 616:	8b4a                	mv	s6,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	bf85                	j	58a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 61c:	008b0913          	addi	s2,s6,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000b2583          	lw	a1,0(s6)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e56080e7          	jalr	-426(ra) # 480 <printint>
 632:	8b4a                	mv	s6,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	bf91                	j	58a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 638:	008b0793          	addi	a5,s6,8
 63c:	f8f43423          	sd	a5,-120(s0)
 640:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 644:	03000593          	li	a1,48
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e14080e7          	jalr	-492(ra) # 45e <putc>
  putc(fd, 'x');
 652:	85ea                	mv	a1,s10
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e08080e7          	jalr	-504(ra) # 45e <putc>
 65e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	df2080e7          	jalr	-526(ra) # 45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 674:	0992                	slli	s3,s3,0x4
 676:	397d                	addiw	s2,s2,-1
 678:	fe0914e3          	bnez	s2,660 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 67c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 680:	4981                	li	s3,0
 682:	b721                	j	58a <vprintf+0x60>
        s = va_arg(ap, char*);
 684:	008b0993          	addi	s3,s6,8
 688:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 68c:	02090163          	beqz	s2,6ae <vprintf+0x184>
        while(*s != 0){
 690:	00094583          	lbu	a1,0(s2)
 694:	c9a1                	beqz	a1,6e4 <vprintf+0x1ba>
          putc(fd, *s);
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	dc6080e7          	jalr	-570(ra) # 45e <putc>
          s++;
 6a0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9e5                	bnez	a1,696 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6a8:	8b4e                	mv	s6,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bdf9                	j	58a <vprintf+0x60>
          s = "(null)";
 6ae:	00000917          	auipc	s2,0x0
 6b2:	27a90913          	addi	s2,s2,634 # 928 <malloc+0x134>
        while(*s != 0){
 6b6:	02800593          	li	a1,40
 6ba:	bff1                	j	696 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6bc:	008b0913          	addi	s2,s6,8
 6c0:	000b4583          	lbu	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d98080e7          	jalr	-616(ra) # 45e <putc>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd65                	j	58a <vprintf+0x60>
        putc(fd, c);
 6d4:	85d2                	mv	a1,s4
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	d86080e7          	jalr	-634(ra) # 45e <putc>
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b565                	j	58a <vprintf+0x60>
        s = va_arg(ap, char*);
 6e4:	8b4e                	mv	s6,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b54d                	j	58a <vprintf+0x60>
    }
  }
}
 6ea:	70e6                	ld	ra,120(sp)
 6ec:	7446                	ld	s0,112(sp)
 6ee:	74a6                	ld	s1,104(sp)
 6f0:	7906                	ld	s2,96(sp)
 6f2:	69e6                	ld	s3,88(sp)
 6f4:	6a46                	ld	s4,80(sp)
 6f6:	6aa6                	ld	s5,72(sp)
 6f8:	6b06                	ld	s6,64(sp)
 6fa:	7be2                	ld	s7,56(sp)
 6fc:	7c42                	ld	s8,48(sp)
 6fe:	7ca2                	ld	s9,40(sp)
 700:	7d02                	ld	s10,32(sp)
 702:	6de2                	ld	s11,24(sp)
 704:	6109                	addi	sp,sp,128
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	00000097          	auipc	ra,0x0
 72a:	e04080e7          	jalr	-508(ra) # 52a <vprintf>
}
 72e:	60e2                	ld	ra,24(sp)
 730:	6442                	ld	s0,16(sp)
 732:	6161                	addi	sp,sp,80
 734:	8082                	ret

0000000000000736 <printf>:

void
printf(const char *fmt, ...)
{
 736:	711d                	addi	sp,sp,-96
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e40c                	sd	a1,8(s0)
 740:	e810                	sd	a2,16(s0)
 742:	ec14                	sd	a3,24(s0)
 744:	f018                	sd	a4,32(s0)
 746:	f41c                	sd	a5,40(s0)
 748:	03043823          	sd	a6,48(s0)
 74c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	00840613          	addi	a2,s0,8
 754:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 758:	85aa                	mv	a1,a0
 75a:	4505                	li	a0,1
 75c:	00000097          	auipc	ra,0x0
 760:	dce080e7          	jalr	-562(ra) # 52a <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e422                	sd	s0,8(sp)
 770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	00000797          	auipc	a5,0x0
 77a:	1d27b783          	ld	a5,466(a5) # 948 <freep>
 77e:	a805                	j	7ae <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 780:	4618                	lw	a4,8(a2)
 782:	9db9                	addw	a1,a1,a4
 784:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	6398                	ld	a4,0(a5)
 78a:	6318                	ld	a4,0(a4)
 78c:	fee53823          	sd	a4,-16(a0)
 790:	a091                	j	7d4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 792:	ff852703          	lw	a4,-8(a0)
 796:	9e39                	addw	a2,a2,a4
 798:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 79a:	ff053703          	ld	a4,-16(a0)
 79e:	e398                	sd	a4,0(a5)
 7a0:	a099                	j	7e6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e7e463          	bltu	a5,a4,7ac <free+0x40>
 7a8:	00e6ea63          	bltu	a3,a4,7bc <free+0x50>
{
 7ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	fed7fae3          	bgeu	a5,a3,7a2 <free+0x36>
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e6e463          	bltu	a3,a4,7bc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	fee7eae3          	bltu	a5,a4,7ac <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7bc:	ff852583          	lw	a1,-8(a0)
 7c0:	6390                	ld	a2,0(a5)
 7c2:	02059713          	slli	a4,a1,0x20
 7c6:	9301                	srli	a4,a4,0x20
 7c8:	0712                	slli	a4,a4,0x4
 7ca:	9736                	add	a4,a4,a3
 7cc:	fae60ae3          	beq	a2,a4,780 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d4:	4790                	lw	a2,8(a5)
 7d6:	02061713          	slli	a4,a2,0x20
 7da:	9301                	srli	a4,a4,0x20
 7dc:	0712                	slli	a4,a4,0x4
 7de:	973e                	add	a4,a4,a5
 7e0:	fae689e3          	beq	a3,a4,792 <free+0x26>
  } else
    p->s.ptr = bp;
 7e4:	e394                	sd	a3,0(a5)
  freep = p;
 7e6:	00000717          	auipc	a4,0x0
 7ea:	16f73123          	sd	a5,354(a4) # 948 <freep>
}
 7ee:	6422                	ld	s0,8(sp)
 7f0:	0141                	addi	sp,sp,16
 7f2:	8082                	ret

00000000000007f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f4:	7139                	addi	sp,sp,-64
 7f6:	fc06                	sd	ra,56(sp)
 7f8:	f822                	sd	s0,48(sp)
 7fa:	f426                	sd	s1,40(sp)
 7fc:	f04a                	sd	s2,32(sp)
 7fe:	ec4e                	sd	s3,24(sp)
 800:	e852                	sd	s4,16(sp)
 802:	e456                	sd	s5,8(sp)
 804:	e05a                	sd	s6,0(sp)
 806:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 808:	02051493          	slli	s1,a0,0x20
 80c:	9081                	srli	s1,s1,0x20
 80e:	04bd                	addi	s1,s1,15
 810:	8091                	srli	s1,s1,0x4
 812:	0014899b          	addiw	s3,s1,1
 816:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 818:	00000517          	auipc	a0,0x0
 81c:	13053503          	ld	a0,304(a0) # 948 <freep>
 820:	c515                	beqz	a0,84c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 824:	4798                	lw	a4,8(a5)
 826:	02977f63          	bgeu	a4,s1,864 <malloc+0x70>
 82a:	8a4e                	mv	s4,s3
 82c:	0009871b          	sext.w	a4,s3
 830:	6685                	lui	a3,0x1
 832:	00d77363          	bgeu	a4,a3,838 <malloc+0x44>
 836:	6a05                	lui	s4,0x1
 838:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 840:	00000917          	auipc	s2,0x0
 844:	10890913          	addi	s2,s2,264 # 948 <freep>
  if(p == (char*)-1)
 848:	5afd                	li	s5,-1
 84a:	a88d                	j	8bc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 84c:	00000797          	auipc	a5,0x0
 850:	10478793          	addi	a5,a5,260 # 950 <base>
 854:	00000717          	auipc	a4,0x0
 858:	0ef73a23          	sd	a5,244(a4) # 948 <freep>
 85c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 862:	b7e1                	j	82a <malloc+0x36>
      if(p->s.size == nunits)
 864:	02e48b63          	beq	s1,a4,89a <malloc+0xa6>
        p->s.size -= nunits;
 868:	4137073b          	subw	a4,a4,s3
 86c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86e:	1702                	slli	a4,a4,0x20
 870:	9301                	srli	a4,a4,0x20
 872:	0712                	slli	a4,a4,0x4
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00000717          	auipc	a4,0x0
 87e:	0ca73723          	sd	a0,206(a4) # 948 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	74a2                	ld	s1,40(sp)
 88c:	7902                	ld	s2,32(sp)
 88e:	69e2                	ld	s3,24(sp)
 890:	6a42                	ld	s4,16(sp)
 892:	6aa2                	ld	s5,8(sp)
 894:	6b02                	ld	s6,0(sp)
 896:	6121                	addi	sp,sp,64
 898:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 89a:	6398                	ld	a4,0(a5)
 89c:	e118                	sd	a4,0(a0)
 89e:	bff1                	j	87a <malloc+0x86>
  hp->s.size = nu;
 8a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a4:	0541                	addi	a0,a0,16
 8a6:	00000097          	auipc	ra,0x0
 8aa:	ec6080e7          	jalr	-314(ra) # 76c <free>
  return freep;
 8ae:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b2:	d971                	beqz	a0,886 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b6:	4798                	lw	a4,8(a5)
 8b8:	fa9776e3          	bgeu	a4,s1,864 <malloc+0x70>
    if(p == freep)
 8bc:	00093703          	ld	a4,0(s2)
 8c0:	853e                	mv	a0,a5
 8c2:	fef719e3          	bne	a4,a5,8b4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8c6:	8552                	mv	a0,s4
 8c8:	00000097          	auipc	ra,0x0
 8cc:	ad4080e7          	jalr	-1324(ra) # 39c <sbrk>
  if(p == (char*)-1)
 8d0:	fd5518e3          	bne	a0,s5,8a0 <malloc+0xac>
        return 0;
 8d4:	4501                	li	a0,0
 8d6:	bf45                	j	886 <malloc+0x92>
