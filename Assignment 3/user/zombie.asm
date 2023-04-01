
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	290080e7          	jalr	656(ra) # 298 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	28a080e7          	jalr	650(ra) # 2a0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	310080e7          	jalr	784(ra) # 330 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ce09                	beqz	a2,bc <memset+0x20>
  a4:	87aa                	mv	a5,a0
  a6:	fff6071b          	addiw	a4,a2,-1
  aa:	1702                	slli	a4,a4,0x20
  ac:	9301                	srli	a4,a4,0x20
  ae:	0705                	addi	a4,a4,1
  b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x16>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d863          	bge	s1,s4,13c <gets+0x56>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	1a0080e7          	jalr	416(ra) # 2b8 <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x56>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x54>
 130:	0905                	addi	s2,s2,1
 132:	fd679be3          	bne	a5,s6,108 <gets+0x22>
  for(i=0; i+1 < max; ){
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x56>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 168:	4581                	li	a1,0
 16a:	00000097          	auipc	ra,0x0
 16e:	176080e7          	jalr	374(ra) # 2e0 <open>
  if(fd < 0)
 172:	02054563          	bltz	a0,19c <stat+0x42>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	17e080e7          	jalr	382(ra) # 2f8 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	142080e7          	jalr	322(ra) # 2c8 <close>
  return r;
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	64a2                	ld	s1,8(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	597d                	li	s2,-1
 19e:	bfc5                	j	18e <stat+0x34>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054603          	lbu	a2,0(a0)
 1aa:	fd06079b          	addiw	a5,a2,-48
 1ae:	0ff7f793          	andi	a5,a5,255
 1b2:	4725                	li	a4,9
 1b4:	02f76963          	bltu	a4,a5,1e6 <atoi+0x46>
 1b8:	86aa                	mv	a3,a0
  n = 0;
 1ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1be:	0685                	addi	a3,a3,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb1                	addw	a5,a5,a2
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	0006c603          	lbu	a2,0(a3)
 1d4:	fd06071b          	addiw	a4,a2,-48
 1d8:	0ff77713          	andi	a4,a4,255
 1dc:	fee5f1e3          	bgeu	a1,a4,1be <atoi+0x1e>
  return n;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <atoi+0x40>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f0:	02b57663          	bgeu	a0,a1,21c <memmove+0x32>
    while(n-- > 0)
 1f4:	02c05163          	blez	a2,216 <memmove+0x2c>
 1f8:	fff6079b          	addiw	a5,a2,-1
 1fc:	1782                	slli	a5,a5,0x20
 1fe:	9381                	srli	a5,a5,0x20
 200:	0785                	addi	a5,a5,1
 202:	97aa                	add	a5,a5,a0
  dst = vdst;
 204:	872a                	mv	a4,a0
      *dst++ = *src++;
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 212:	fee79ae3          	bne	a5,a4,206 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    dst += n;
 21c:	00c50733          	add	a4,a0,a2
    src += n;
 220:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 222:	fec05ae3          	blez	a2,216 <memmove+0x2c>
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x4a>
 244:	bfc9                	j	216 <memmove+0x2c>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24c:	ca05                	beqz	a2,27c <memcmp+0x36>
 24e:	fff6069b          	addiw	a3,a2,-1
 252:	1682                	slli	a3,a3,0x20
 254:	9281                	srli	a3,a3,0x20
 256:	0685                	addi	a3,a3,1
 258:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 266:	0505                	addi	a0,a0,1
    p2++;
 268:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x14>
  }
  return 0;
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x30>
      return *p1 - *p2;
 272:	40e7853b          	subw	a0,a5,a4
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <memcmp+0x30>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	00000097          	auipc	ra,0x0
 28c:	f62080e7          	jalr	-158(ra) # 1ea <memmove>
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 298:	4885                	li	a7,1
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a0:	4889                	li	a7,2
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a8:	488d                	li	a7,3
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b0:	4891                	li	a7,4
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <read>:
.global read
read:
 li a7, SYS_read
 2b8:	4895                	li	a7,5
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <write>:
.global write
write:
 li a7, SYS_write
 2c0:	48c1                	li	a7,16
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <close>:
.global close
close:
 li a7, SYS_close
 2c8:	48d5                	li	a7,21
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d0:	4899                	li	a7,6
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d8:	489d                	li	a7,7
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <open>:
.global open
open:
 li a7, SYS_open
 2e0:	48bd                	li	a7,15
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e8:	48c5                	li	a7,17
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f0:	48c9                	li	a7,18
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f8:	48a1                	li	a7,8
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <link>:
.global link
link:
 li a7, SYS_link
 300:	48cd                	li	a7,19
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 308:	48d1                	li	a7,20
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 310:	48a5                	li	a7,9
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <dup>:
.global dup
dup:
 li a7, SYS_dup
 318:	48a9                	li	a7,10
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 320:	48ad                	li	a7,11
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 328:	48b1                	li	a7,12
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 330:	48b5                	li	a7,13
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 338:	48b9                	li	a7,14
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 340:	48d9                	li	a7,22
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <yield>:
.global yield
yield:
 li a7, SYS_yield
 348:	48dd                	li	a7,23
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 350:	48e1                	li	a7,24
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 358:	48e5                	li	a7,25
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 360:	48e9                	li	a7,26
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <ps>:
.global ps
ps:
 li a7, SYS_ps
 368:	48ed                	li	a7,27
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 370:	48f1                	li	a7,28
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 378:	48f5                	li	a7,29
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 380:	48f9                	li	a7,30
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 388:	48fd                	li	a7,31
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 390:	02000893          	li	a7,32
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 39a:	02100893          	li	a7,33
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 3a4:	02200893          	li	a7,34
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 3ae:	02300893          	li	a7,35
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 3b8:	02500893          	li	a7,37
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 3c2:	02400893          	li	a7,36
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 3cc:	02600893          	li	a7,38
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 3d6:	02800893          	li	a7,40
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 3e0:	02700893          	li	a7,39
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	ec4080e7          	jalr	-316(ra) # 2c0 <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f426                	sd	s1,40(sp)
 414:	f04a                	sd	s2,32(sp)
 416:	ec4e                	sd	s3,24(sp)
 418:	0080                	addi	s0,sp,64
 41a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41c:	c299                	beqz	a3,422 <printint+0x16>
 41e:	0805c863          	bltz	a1,4ae <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 422:	2581                	sext.w	a1,a1
  neg = 0;
 424:	4881                	li	a7,0
 426:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42c:	2601                	sext.w	a2,a2
 42e:	00000517          	auipc	a0,0x0
 432:	44250513          	addi	a0,a0,1090 # 870 <digits>
 436:	883a                	mv	a6,a4
 438:	2705                	addiw	a4,a4,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44c:	0005879b          	sext.w	a5,a1
 450:	02c5d5bb          	divuw	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f0e3          	bgeu	a5,a2,436 <printint+0x2a>
  if(neg)
 45a:	00088b63          	beqz	a7,470 <printint+0x64>
    buf[i++] = '-';
 45e:	fd040793          	addi	a5,s0,-48
 462:	973e                	add	a4,a4,a5
 464:	02d00793          	li	a5,45
 468:	fef70823          	sb	a5,-16(a4)
 46c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 470:	02e05863          	blez	a4,4a0 <printint+0x94>
 474:	fc040793          	addi	a5,s0,-64
 478:	00e78933          	add	s2,a5,a4
 47c:	fff78993          	addi	s3,a5,-1
 480:	99ba                	add	s3,s3,a4
 482:	377d                	addiw	a4,a4,-1
 484:	1702                	slli	a4,a4,0x20
 486:	9301                	srli	a4,a4,0x20
 488:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48c:	fff94583          	lbu	a1,-1(s2)
 490:	8526                	mv	a0,s1
 492:	00000097          	auipc	ra,0x0
 496:	f58080e7          	jalr	-168(ra) # 3ea <putc>
  while(--i >= 0)
 49a:	197d                	addi	s2,s2,-1
 49c:	ff3918e3          	bne	s2,s3,48c <printint+0x80>
}
 4a0:	70e2                	ld	ra,56(sp)
 4a2:	7442                	ld	s0,48(sp)
 4a4:	74a2                	ld	s1,40(sp)
 4a6:	7902                	ld	s2,32(sp)
 4a8:	69e2                	ld	s3,24(sp)
 4aa:	6121                	addi	sp,sp,64
 4ac:	8082                	ret
    x = -xx;
 4ae:	40b005bb          	negw	a1,a1
    neg = 1;
 4b2:	4885                	li	a7,1
    x = -xx;
 4b4:	bf8d                	j	426 <printint+0x1a>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	7119                	addi	sp,sp,-128
 4b8:	fc86                	sd	ra,120(sp)
 4ba:	f8a2                	sd	s0,112(sp)
 4bc:	f4a6                	sd	s1,104(sp)
 4be:	f0ca                	sd	s2,96(sp)
 4c0:	ecce                	sd	s3,88(sp)
 4c2:	e8d2                	sd	s4,80(sp)
 4c4:	e4d6                	sd	s5,72(sp)
 4c6:	e0da                	sd	s6,64(sp)
 4c8:	fc5e                	sd	s7,56(sp)
 4ca:	f862                	sd	s8,48(sp)
 4cc:	f466                	sd	s9,40(sp)
 4ce:	f06a                	sd	s10,32(sp)
 4d0:	ec6e                	sd	s11,24(sp)
 4d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d4:	0005c903          	lbu	s2,0(a1)
 4d8:	18090f63          	beqz	s2,676 <vprintf+0x1c0>
 4dc:	8aaa                	mv	s5,a0
 4de:	8b32                	mv	s6,a2
 4e0:	00158493          	addi	s1,a1,1
  state = 0;
 4e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e6:	02500a13          	li	s4,37
      if(c == 'd'){
 4ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ee:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fa:	00000b97          	auipc	s7,0x0
 4fe:	376b8b93          	addi	s7,s7,886 # 870 <digits>
 502:	a839                	j	520 <vprintf+0x6a>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	ee2080e7          	jalr	-286(ra) # 3ea <putc>
 510:	a019                	j	516 <vprintf+0x60>
    } else if(state == '%'){
 512:	01498f63          	beq	s3,s4,530 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 516:	0485                	addi	s1,s1,1
 518:	fff4c903          	lbu	s2,-1(s1)
 51c:	14090d63          	beqz	s2,676 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 520:	0009079b          	sext.w	a5,s2
    if(state == 0){
 524:	fe0997e3          	bnez	s3,512 <vprintf+0x5c>
      if(c == '%'){
 528:	fd479ee3          	bne	a5,s4,504 <vprintf+0x4e>
        state = '%';
 52c:	89be                	mv	s3,a5
 52e:	b7e5                	j	516 <vprintf+0x60>
      if(c == 'd'){
 530:	05878063          	beq	a5,s8,570 <vprintf+0xba>
      } else if(c == 'l') {
 534:	05978c63          	beq	a5,s9,58c <vprintf+0xd6>
      } else if(c == 'x') {
 538:	07a78863          	beq	a5,s10,5a8 <vprintf+0xf2>
      } else if(c == 'p') {
 53c:	09b78463          	beq	a5,s11,5c4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 540:	07300713          	li	a4,115
 544:	0ce78663          	beq	a5,a4,610 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 548:	06300713          	li	a4,99
 54c:	0ee78e63          	beq	a5,a4,648 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 550:	11478863          	beq	a5,s4,660 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 554:	85d2                	mv	a1,s4
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e92080e7          	jalr	-366(ra) # 3ea <putc>
        putc(fd, c);
 560:	85ca                	mv	a1,s2
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e86080e7          	jalr	-378(ra) # 3ea <putc>
      }
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b765                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b0913          	addi	s2,s6,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000b2583          	lw	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e8e080e7          	jalr	-370(ra) # 40c <printint>
 586:	8b4a                	mv	s6,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	b771                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b0913          	addi	s2,s6,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000b2583          	lw	a1,0(s6)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e72080e7          	jalr	-398(ra) # 40c <printint>
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bf85                	j	516 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a8:	008b0913          	addi	s2,s6,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000b2583          	lw	a1,0(s6)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e56080e7          	jalr	-426(ra) # 40c <printint>
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bf91                	j	516 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c4:	008b0793          	addi	a5,s6,8
 5c8:	f8f43423          	sd	a5,-120(s0)
 5cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d0:	03000593          	li	a1,48
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e14080e7          	jalr	-492(ra) # 3ea <putc>
  putc(fd, 'x');
 5de:	85ea                	mv	a1,s10
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e08080e7          	jalr	-504(ra) # 3ea <putc>
 5ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ec:	03c9d793          	srli	a5,s3,0x3c
 5f0:	97de                	add	a5,a5,s7
 5f2:	0007c583          	lbu	a1,0(a5)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	df2080e7          	jalr	-526(ra) # 3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 600:	0992                	slli	s3,s3,0x4
 602:	397d                	addiw	s2,s2,-1
 604:	fe0914e3          	bnez	s2,5ec <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 608:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b721                	j	516 <vprintf+0x60>
        s = va_arg(ap, char*);
 610:	008b0993          	addi	s3,s6,8
 614:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 618:	02090163          	beqz	s2,63a <vprintf+0x184>
        while(*s != 0){
 61c:	00094583          	lbu	a1,0(s2)
 620:	c9a1                	beqz	a1,670 <vprintf+0x1ba>
          putc(fd, *s);
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	dc6080e7          	jalr	-570(ra) # 3ea <putc>
          s++;
 62c:	0905                	addi	s2,s2,1
        while(*s != 0){
 62e:	00094583          	lbu	a1,0(s2)
 632:	f9e5                	bnez	a1,622 <vprintf+0x16c>
        s = va_arg(ap, char*);
 634:	8b4e                	mv	s6,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	bdf9                	j	516 <vprintf+0x60>
          s = "(null)";
 63a:	00000917          	auipc	s2,0x0
 63e:	22e90913          	addi	s2,s2,558 # 868 <malloc+0xe8>
        while(*s != 0){
 642:	02800593          	li	a1,40
 646:	bff1                	j	622 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 648:	008b0913          	addi	s2,s6,8
 64c:	000b4583          	lbu	a1,0(s6)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	d98080e7          	jalr	-616(ra) # 3ea <putc>
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd65                	j	516 <vprintf+0x60>
        putc(fd, c);
 660:	85d2                	mv	a1,s4
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	d86080e7          	jalr	-634(ra) # 3ea <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b565                	j	516 <vprintf+0x60>
        s = va_arg(ap, char*);
 670:	8b4e                	mv	s6,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b54d                	j	516 <vprintf+0x60>
    }
  }
}
 676:	70e6                	ld	ra,120(sp)
 678:	7446                	ld	s0,112(sp)
 67a:	74a6                	ld	s1,104(sp)
 67c:	7906                	ld	s2,96(sp)
 67e:	69e6                	ld	s3,88(sp)
 680:	6a46                	ld	s4,80(sp)
 682:	6aa6                	ld	s5,72(sp)
 684:	6b06                	ld	s6,64(sp)
 686:	7be2                	ld	s7,56(sp)
 688:	7c42                	ld	s8,48(sp)
 68a:	7ca2                	ld	s9,40(sp)
 68c:	7d02                	ld	s10,32(sp)
 68e:	6de2                	ld	s11,24(sp)
 690:	6109                	addi	sp,sp,128
 692:	8082                	ret

0000000000000694 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 694:	715d                	addi	sp,sp,-80
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e010                	sd	a2,0(s0)
 69e:	e414                	sd	a3,8(s0)
 6a0:	e818                	sd	a4,16(s0)
 6a2:	ec1c                	sd	a5,24(s0)
 6a4:	03043023          	sd	a6,32(s0)
 6a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b0:	8622                	mv	a2,s0
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e04080e7          	jalr	-508(ra) # 4b6 <vprintf>
}
 6ba:	60e2                	ld	ra,24(sp)
 6bc:	6442                	ld	s0,16(sp)
 6be:	6161                	addi	sp,sp,80
 6c0:	8082                	ret

00000000000006c2 <printf>:

void
printf(const char *fmt, ...)
{
 6c2:	711d                	addi	sp,sp,-96
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	addi	s0,sp,32
 6ca:	e40c                	sd	a1,8(s0)
 6cc:	e810                	sd	a2,16(s0)
 6ce:	ec14                	sd	a3,24(s0)
 6d0:	f018                	sd	a4,32(s0)
 6d2:	f41c                	sd	a5,40(s0)
 6d4:	03043823          	sd	a6,48(s0)
 6d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	00840613          	addi	a2,s0,8
 6e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e4:	85aa                	mv	a1,a0
 6e6:	4505                	li	a0,1
 6e8:	00000097          	auipc	ra,0x0
 6ec:	dce080e7          	jalr	-562(ra) # 4b6 <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6125                	addi	sp,sp,96
 6f6:	8082                	ret

00000000000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e422                	sd	s0,8(sp)
 6fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 702:	00000797          	auipc	a5,0x0
 706:	1867b783          	ld	a5,390(a5) # 888 <freep>
 70a:	a805                	j	73a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70c:	4618                	lw	a4,8(a2)
 70e:	9db9                	addw	a1,a1,a4
 710:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 714:	6398                	ld	a4,0(a5)
 716:	6318                	ld	a4,0(a4)
 718:	fee53823          	sd	a4,-16(a0)
 71c:	a091                	j	760 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71e:	ff852703          	lw	a4,-8(a0)
 722:	9e39                	addw	a2,a2,a4
 724:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 726:	ff053703          	ld	a4,-16(a0)
 72a:	e398                	sd	a4,0(a5)
 72c:	a099                	j	772 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	6398                	ld	a4,0(a5)
 730:	00e7e463          	bltu	a5,a4,738 <free+0x40>
 734:	00e6ea63          	bltu	a3,a4,748 <free+0x50>
{
 738:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	fed7fae3          	bgeu	a5,a3,72e <free+0x36>
 73e:	6398                	ld	a4,0(a5)
 740:	00e6e463          	bltu	a3,a4,748 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	fee7eae3          	bltu	a5,a4,738 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 748:	ff852583          	lw	a1,-8(a0)
 74c:	6390                	ld	a2,0(a5)
 74e:	02059713          	slli	a4,a1,0x20
 752:	9301                	srli	a4,a4,0x20
 754:	0712                	slli	a4,a4,0x4
 756:	9736                	add	a4,a4,a3
 758:	fae60ae3          	beq	a2,a4,70c <free+0x14>
    bp->s.ptr = p->s.ptr;
 75c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 760:	4790                	lw	a2,8(a5)
 762:	02061713          	slli	a4,a2,0x20
 766:	9301                	srli	a4,a4,0x20
 768:	0712                	slli	a4,a4,0x4
 76a:	973e                	add	a4,a4,a5
 76c:	fae689e3          	beq	a3,a4,71e <free+0x26>
  } else
    p->s.ptr = bp;
 770:	e394                	sd	a3,0(a5)
  freep = p;
 772:	00000717          	auipc	a4,0x0
 776:	10f73b23          	sd	a5,278(a4) # 888 <freep>
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	addi	sp,sp,16
 77e:	8082                	ret

0000000000000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	7139                	addi	sp,sp,-64
 782:	fc06                	sd	ra,56(sp)
 784:	f822                	sd	s0,48(sp)
 786:	f426                	sd	s1,40(sp)
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	e852                	sd	s4,16(sp)
 78e:	e456                	sd	s5,8(sp)
 790:	e05a                	sd	s6,0(sp)
 792:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	02051493          	slli	s1,a0,0x20
 798:	9081                	srli	s1,s1,0x20
 79a:	04bd                	addi	s1,s1,15
 79c:	8091                	srli	s1,s1,0x4
 79e:	0014899b          	addiw	s3,s1,1
 7a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a4:	00000517          	auipc	a0,0x0
 7a8:	0e453503          	ld	a0,228(a0) # 888 <freep>
 7ac:	c515                	beqz	a0,7d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b0:	4798                	lw	a4,8(a5)
 7b2:	02977f63          	bgeu	a4,s1,7f0 <malloc+0x70>
 7b6:	8a4e                	mv	s4,s3
 7b8:	0009871b          	sext.w	a4,s3
 7bc:	6685                	lui	a3,0x1
 7be:	00d77363          	bgeu	a4,a3,7c4 <malloc+0x44>
 7c2:	6a05                	lui	s4,0x1
 7c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cc:	00000917          	auipc	s2,0x0
 7d0:	0bc90913          	addi	s2,s2,188 # 888 <freep>
  if(p == (char*)-1)
 7d4:	5afd                	li	s5,-1
 7d6:	a88d                	j	848 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7d8:	00000797          	auipc	a5,0x0
 7dc:	0b878793          	addi	a5,a5,184 # 890 <base>
 7e0:	00000717          	auipc	a4,0x0
 7e4:	0af73423          	sd	a5,168(a4) # 888 <freep>
 7e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ee:	b7e1                	j	7b6 <malloc+0x36>
      if(p->s.size == nunits)
 7f0:	02e48b63          	beq	s1,a4,826 <malloc+0xa6>
        p->s.size -= nunits;
 7f4:	4137073b          	subw	a4,a4,s3
 7f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fa:	1702                	slli	a4,a4,0x20
 7fc:	9301                	srli	a4,a4,0x20
 7fe:	0712                	slli	a4,a4,0x4
 800:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 802:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 806:	00000717          	auipc	a4,0x0
 80a:	08a73123          	sd	a0,130(a4) # 888 <freep>
      return (void*)(p + 1);
 80e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 812:	70e2                	ld	ra,56(sp)
 814:	7442                	ld	s0,48(sp)
 816:	74a2                	ld	s1,40(sp)
 818:	7902                	ld	s2,32(sp)
 81a:	69e2                	ld	s3,24(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
 822:	6121                	addi	sp,sp,64
 824:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	e118                	sd	a4,0(a0)
 82a:	bff1                	j	806 <malloc+0x86>
  hp->s.size = nu;
 82c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 830:	0541                	addi	a0,a0,16
 832:	00000097          	auipc	ra,0x0
 836:	ec6080e7          	jalr	-314(ra) # 6f8 <free>
  return freep;
 83a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83e:	d971                	beqz	a0,812 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	fa9776e3          	bgeu	a4,s1,7f0 <malloc+0x70>
    if(p == freep)
 848:	00093703          	ld	a4,0(s2)
 84c:	853e                	mv	a0,a5
 84e:	fef719e3          	bne	a4,a5,840 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	00000097          	auipc	ra,0x0
 858:	ad4080e7          	jalr	-1324(ra) # 328 <sbrk>
  if(p == (char*)-1)
 85c:	fd5518e3          	bne	a0,s5,82c <malloc+0xac>
        return 0;
 860:	4501                	li	a0,0
 862:	bf45                	j	812 <malloc+0x92>
