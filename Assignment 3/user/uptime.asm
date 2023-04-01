
user/_uptime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  fprintf(1, "%l ticks\n", uptime());
   8:	00000097          	auipc	ra,0x0
   c:	334080e7          	jalr	820(ra) # 33c <uptime>
  10:	862a                	mv	a2,a0
  12:	00001597          	auipc	a1,0x1
  16:	85658593          	addi	a1,a1,-1962 # 868 <malloc+0xe4>
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	67c080e7          	jalr	1660(ra) # 698 <fprintf>

  exit(0);
  24:	4501                	li	a0,0
  26:	00000097          	auipc	ra,0x0
  2a:	27e080e7          	jalr	638(ra) # 2a4 <exit>

000000000000002e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	87aa                	mv	a5,a0
  36:	0585                	addi	a1,a1,1
  38:	0785                	addi	a5,a5,1
  3a:	fff5c703          	lbu	a4,-1(a1)
  3e:	fee78fa3          	sb	a4,-1(a5)
  42:	fb75                	bnez	a4,36 <strcpy+0x8>
    ;
  return os;
}
  44:	6422                	ld	s0,8(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x1e>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x1e>
    p++, q++;
  5e:	0505                	addi	a0,a0,1
  60:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	6422                	ld	s0,8(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret

0000000000000076 <strlen>:

uint
strlen(const char *s)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x26>
  82:	0505                	addi	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	4685                	li	a3,1
  88:	9e89                	subw	a3,a3,a0
  8a:	00f6853b          	addw	a0,a3,a5
  8e:	0785                	addi	a5,a5,1
  90:	fff7c703          	lbu	a4,-1(a5)
  94:	fb7d                	bnez	a4,8a <strlen+0x14>
    ;
  return n;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfe5                	j	96 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ce09                	beqz	a2,c0 <memset+0x20>
  a8:	87aa                	mv	a5,a0
  aa:	fff6071b          	addiw	a4,a2,-1
  ae:	1702                	slli	a4,a4,0x20
  b0:	9301                	srli	a4,a4,0x20
  b2:	0705                	addi	a4,a4,1
  b4:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ba:	0785                	addi	a5,a5,1
  bc:	fee79de3          	bne	a5,a4,b6 <memset+0x16>
  }
  return dst;
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strchr>:

char*
strchr(const char *s, char c)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb99                	beqz	a5,e6 <strchr+0x20>
    if(*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1a>
  for(; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xc>
      return (char*)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  return 0;
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strchr+0x1a>

00000000000000ea <gets>:

char*
gets(char *buf, int max)
{
  ea:	711d                	addi	sp,sp,-96
  ec:	ec86                	sd	ra,88(sp)
  ee:	e8a2                	sd	s0,80(sp)
  f0:	e4a6                	sd	s1,72(sp)
  f2:	e0ca                	sd	s2,64(sp)
  f4:	fc4e                	sd	s3,56(sp)
  f6:	f852                	sd	s4,48(sp)
  f8:	f456                	sd	s5,40(sp)
  fa:	f05a                	sd	s6,32(sp)
  fc:	ec5e                	sd	s7,24(sp)
  fe:	1080                	addi	s0,sp,96
 100:	8baa                	mv	s7,a0
 102:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 104:	892a                	mv	s2,a0
 106:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 108:	4aa9                	li	s5,10
 10a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10c:	89a6                	mv	s3,s1
 10e:	2485                	addiw	s1,s1,1
 110:	0344d863          	bge	s1,s4,140 <gets+0x56>
    cc = read(0, &c, 1);
 114:	4605                	li	a2,1
 116:	faf40593          	addi	a1,s0,-81
 11a:	4501                	li	a0,0
 11c:	00000097          	auipc	ra,0x0
 120:	1a0080e7          	jalr	416(ra) # 2bc <read>
    if(cc < 1)
 124:	00a05e63          	blez	a0,140 <gets+0x56>
    buf[i++] = c;
 128:	faf44783          	lbu	a5,-81(s0)
 12c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 130:	01578763          	beq	a5,s5,13e <gets+0x54>
 134:	0905                	addi	s2,s2,1
 136:	fd679be3          	bne	a5,s6,10c <gets+0x22>
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	a011                	j	140 <gets+0x56>
 13e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 140:	99de                	add	s3,s3,s7
 142:	00098023          	sb	zero,0(s3)
  return buf;
}
 146:	855e                	mv	a0,s7
 148:	60e6                	ld	ra,88(sp)
 14a:	6446                	ld	s0,80(sp)
 14c:	64a6                	ld	s1,72(sp)
 14e:	6906                	ld	s2,64(sp)
 150:	79e2                	ld	s3,56(sp)
 152:	7a42                	ld	s4,48(sp)
 154:	7aa2                	ld	s5,40(sp)
 156:	7b02                	ld	s6,32(sp)
 158:	6be2                	ld	s7,24(sp)
 15a:	6125                	addi	sp,sp,96
 15c:	8082                	ret

000000000000015e <stat>:

int
stat(const char *n, struct stat *st)
{
 15e:	1101                	addi	sp,sp,-32
 160:	ec06                	sd	ra,24(sp)
 162:	e822                	sd	s0,16(sp)
 164:	e426                	sd	s1,8(sp)
 166:	e04a                	sd	s2,0(sp)
 168:	1000                	addi	s0,sp,32
 16a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16c:	4581                	li	a1,0
 16e:	00000097          	auipc	ra,0x0
 172:	176080e7          	jalr	374(ra) # 2e4 <open>
  if(fd < 0)
 176:	02054563          	bltz	a0,1a0 <stat+0x42>
 17a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17c:	85ca                	mv	a1,s2
 17e:	00000097          	auipc	ra,0x0
 182:	17e080e7          	jalr	382(ra) # 2fc <fstat>
 186:	892a                	mv	s2,a0
  close(fd);
 188:	8526                	mv	a0,s1
 18a:	00000097          	auipc	ra,0x0
 18e:	142080e7          	jalr	322(ra) # 2cc <close>
  return r;
}
 192:	854a                	mv	a0,s2
 194:	60e2                	ld	ra,24(sp)
 196:	6442                	ld	s0,16(sp)
 198:	64a2                	ld	s1,8(sp)
 19a:	6902                	ld	s2,0(sp)
 19c:	6105                	addi	sp,sp,32
 19e:	8082                	ret
    return -1;
 1a0:	597d                	li	s2,-1
 1a2:	bfc5                	j	192 <stat+0x34>

00000000000001a4 <atoi>:

int
atoi(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1aa:	00054603          	lbu	a2,0(a0)
 1ae:	fd06079b          	addiw	a5,a2,-48
 1b2:	0ff7f793          	andi	a5,a5,255
 1b6:	4725                	li	a4,9
 1b8:	02f76963          	bltu	a4,a5,1ea <atoi+0x46>
 1bc:	86aa                	mv	a3,a0
  n = 0;
 1be:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1c0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1c2:	0685                	addi	a3,a3,1
 1c4:	0025179b          	slliw	a5,a0,0x2
 1c8:	9fa9                	addw	a5,a5,a0
 1ca:	0017979b          	slliw	a5,a5,0x1
 1ce:	9fb1                	addw	a5,a5,a2
 1d0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d4:	0006c603          	lbu	a2,0(a3)
 1d8:	fd06071b          	addiw	a4,a2,-48
 1dc:	0ff77713          	andi	a4,a4,255
 1e0:	fee5f1e3          	bgeu	a1,a4,1c2 <atoi+0x1e>
  return n;
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
  n = 0;
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <atoi+0x40>

00000000000001ee <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f4:	02b57663          	bgeu	a0,a1,220 <memmove+0x32>
    while(n-- > 0)
 1f8:	02c05163          	blez	a2,21a <memmove+0x2c>
 1fc:	fff6079b          	addiw	a5,a2,-1
 200:	1782                	slli	a5,a5,0x20
 202:	9381                	srli	a5,a5,0x20
 204:	0785                	addi	a5,a5,1
 206:	97aa                	add	a5,a5,a0
  dst = vdst;
 208:	872a                	mv	a4,a0
      *dst++ = *src++;
 20a:	0585                	addi	a1,a1,1
 20c:	0705                	addi	a4,a4,1
 20e:	fff5c683          	lbu	a3,-1(a1)
 212:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 216:	fee79ae3          	bne	a5,a4,20a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 226:	fec05ae3          	blez	a2,21a <memmove+0x2c>
 22a:	fff6079b          	addiw	a5,a2,-1
 22e:	1782                	slli	a5,a5,0x20
 230:	9381                	srli	a5,a5,0x20
 232:	fff7c793          	not	a5,a5
 236:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 238:	15fd                	addi	a1,a1,-1
 23a:	177d                	addi	a4,a4,-1
 23c:	0005c683          	lbu	a3,0(a1)
 240:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 244:	fee79ae3          	bne	a5,a4,238 <memmove+0x4a>
 248:	bfc9                	j	21a <memmove+0x2c>

000000000000024a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 250:	ca05                	beqz	a2,280 <memcmp+0x36>
 252:	fff6069b          	addiw	a3,a2,-1
 256:	1682                	slli	a3,a3,0x20
 258:	9281                	srli	a3,a3,0x20
 25a:	0685                	addi	a3,a3,1
 25c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25e:	00054783          	lbu	a5,0(a0)
 262:	0005c703          	lbu	a4,0(a1)
 266:	00e79863          	bne	a5,a4,276 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 26a:	0505                	addi	a0,a0,1
    p2++;
 26c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26e:	fed518e3          	bne	a0,a3,25e <memcmp+0x14>
  }
  return 0;
 272:	4501                	li	a0,0
 274:	a019                	j	27a <memcmp+0x30>
      return *p1 - *p2;
 276:	40e7853b          	subw	a0,a5,a4
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  return 0;
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <memcmp+0x30>

0000000000000284 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28c:	00000097          	auipc	ra,0x0
 290:	f62080e7          	jalr	-158(ra) # 1ee <memmove>
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret

000000000000029c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 29c:	4885                	li	a7,1
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a4:	4889                	li	a7,2
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ac:	488d                	li	a7,3
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b4:	4891                	li	a7,4
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <read>:
.global read
read:
 li a7, SYS_read
 2bc:	4895                	li	a7,5
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <write>:
.global write
write:
 li a7, SYS_write
 2c4:	48c1                	li	a7,16
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <close>:
.global close
close:
 li a7, SYS_close
 2cc:	48d5                	li	a7,21
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d4:	4899                	li	a7,6
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2dc:	489d                	li	a7,7
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <open>:
.global open
open:
 li a7, SYS_open
 2e4:	48bd                	li	a7,15
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ec:	48c5                	li	a7,17
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f4:	48c9                	li	a7,18
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2fc:	48a1                	li	a7,8
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <link>:
.global link
link:
 li a7, SYS_link
 304:	48cd                	li	a7,19
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 30c:	48d1                	li	a7,20
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 314:	48a5                	li	a7,9
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <dup>:
.global dup
dup:
 li a7, SYS_dup
 31c:	48a9                	li	a7,10
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 324:	48ad                	li	a7,11
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 32c:	48b1                	li	a7,12
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 334:	48b5                	li	a7,13
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 33c:	48b9                	li	a7,14
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 344:	48d9                	li	a7,22
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <yield>:
.global yield
yield:
 li a7, SYS_yield
 34c:	48dd                	li	a7,23
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 354:	48e1                	li	a7,24
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 35c:	48e5                	li	a7,25
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 364:	48e9                	li	a7,26
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <ps>:
.global ps
ps:
 li a7, SYS_ps
 36c:	48ed                	li	a7,27
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 374:	48f1                	li	a7,28
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 37c:	48f5                	li	a7,29
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 384:	48f9                	li	a7,30
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 38c:	48fd                	li	a7,31
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 394:	02000893          	li	a7,32
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 39e:	02100893          	li	a7,33
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 3a8:	02200893          	li	a7,34
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 3b2:	02300893          	li	a7,35
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 3bc:	02500893          	li	a7,37
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 3c6:	02400893          	li	a7,36
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 3d0:	02600893          	li	a7,38
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 3da:	02800893          	li	a7,40
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 3e4:	02700893          	li	a7,39
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ee:	1101                	addi	sp,sp,-32
 3f0:	ec06                	sd	ra,24(sp)
 3f2:	e822                	sd	s0,16(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fa:	4605                	li	a2,1
 3fc:	fef40593          	addi	a1,s0,-17
 400:	00000097          	auipc	ra,0x0
 404:	ec4080e7          	jalr	-316(ra) # 2c4 <write>
}
 408:	60e2                	ld	ra,24(sp)
 40a:	6442                	ld	s0,16(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret

0000000000000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	7139                	addi	sp,sp,-64
 412:	fc06                	sd	ra,56(sp)
 414:	f822                	sd	s0,48(sp)
 416:	f426                	sd	s1,40(sp)
 418:	f04a                	sd	s2,32(sp)
 41a:	ec4e                	sd	s3,24(sp)
 41c:	0080                	addi	s0,sp,64
 41e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c299                	beqz	a3,426 <printint+0x16>
 422:	0805c863          	bltz	a1,4b2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 426:	2581                	sext.w	a1,a1
  neg = 0;
 428:	4881                	li	a7,0
 42a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 430:	2601                	sext.w	a2,a2
 432:	00000517          	auipc	a0,0x0
 436:	44e50513          	addi	a0,a0,1102 # 880 <digits>
 43a:	883a                	mv	a6,a4
 43c:	2705                	addiw	a4,a4,1
 43e:	02c5f7bb          	remuw	a5,a1,a2
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	97aa                	add	a5,a5,a0
 448:	0007c783          	lbu	a5,0(a5)
 44c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 450:	0005879b          	sext.w	a5,a1
 454:	02c5d5bb          	divuw	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f0e3          	bgeu	a5,a2,43a <printint+0x2a>
  if(neg)
 45e:	00088b63          	beqz	a7,474 <printint+0x64>
    buf[i++] = '-';
 462:	fd040793          	addi	a5,s0,-48
 466:	973e                	add	a4,a4,a5
 468:	02d00793          	li	a5,45
 46c:	fef70823          	sb	a5,-16(a4)
 470:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 474:	02e05863          	blez	a4,4a4 <printint+0x94>
 478:	fc040793          	addi	a5,s0,-64
 47c:	00e78933          	add	s2,a5,a4
 480:	fff78993          	addi	s3,a5,-1
 484:	99ba                	add	s3,s3,a4
 486:	377d                	addiw	a4,a4,-1
 488:	1702                	slli	a4,a4,0x20
 48a:	9301                	srli	a4,a4,0x20
 48c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 490:	fff94583          	lbu	a1,-1(s2)
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	f58080e7          	jalr	-168(ra) # 3ee <putc>
  while(--i >= 0)
 49e:	197d                	addi	s2,s2,-1
 4a0:	ff3918e3          	bne	s2,s3,490 <printint+0x80>
}
 4a4:	70e2                	ld	ra,56(sp)
 4a6:	7442                	ld	s0,48(sp)
 4a8:	74a2                	ld	s1,40(sp)
 4aa:	7902                	ld	s2,32(sp)
 4ac:	69e2                	ld	s3,24(sp)
 4ae:	6121                	addi	sp,sp,64
 4b0:	8082                	ret
    x = -xx;
 4b2:	40b005bb          	negw	a1,a1
    neg = 1;
 4b6:	4885                	li	a7,1
    x = -xx;
 4b8:	bf8d                	j	42a <printint+0x1a>

00000000000004ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ba:	7119                	addi	sp,sp,-128
 4bc:	fc86                	sd	ra,120(sp)
 4be:	f8a2                	sd	s0,112(sp)
 4c0:	f4a6                	sd	s1,104(sp)
 4c2:	f0ca                	sd	s2,96(sp)
 4c4:	ecce                	sd	s3,88(sp)
 4c6:	e8d2                	sd	s4,80(sp)
 4c8:	e4d6                	sd	s5,72(sp)
 4ca:	e0da                	sd	s6,64(sp)
 4cc:	fc5e                	sd	s7,56(sp)
 4ce:	f862                	sd	s8,48(sp)
 4d0:	f466                	sd	s9,40(sp)
 4d2:	f06a                	sd	s10,32(sp)
 4d4:	ec6e                	sd	s11,24(sp)
 4d6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d8:	0005c903          	lbu	s2,0(a1)
 4dc:	18090f63          	beqz	s2,67a <vprintf+0x1c0>
 4e0:	8aaa                	mv	s5,a0
 4e2:	8b32                	mv	s6,a2
 4e4:	00158493          	addi	s1,a1,1
  state = 0;
 4e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ea:	02500a13          	li	s4,37
      if(c == 'd'){
 4ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4f2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4fa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fe:	00000b97          	auipc	s7,0x0
 502:	382b8b93          	addi	s7,s7,898 # 880 <digits>
 506:	a839                	j	524 <vprintf+0x6a>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ee2080e7          	jalr	-286(ra) # 3ee <putc>
 514:	a019                	j	51a <vprintf+0x60>
    } else if(state == '%'){
 516:	01498f63          	beq	s3,s4,534 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 51a:	0485                	addi	s1,s1,1
 51c:	fff4c903          	lbu	s2,-1(s1)
 520:	14090d63          	beqz	s2,67a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 524:	0009079b          	sext.w	a5,s2
    if(state == 0){
 528:	fe0997e3          	bnez	s3,516 <vprintf+0x5c>
      if(c == '%'){
 52c:	fd479ee3          	bne	a5,s4,508 <vprintf+0x4e>
        state = '%';
 530:	89be                	mv	s3,a5
 532:	b7e5                	j	51a <vprintf+0x60>
      if(c == 'd'){
 534:	05878063          	beq	a5,s8,574 <vprintf+0xba>
      } else if(c == 'l') {
 538:	05978c63          	beq	a5,s9,590 <vprintf+0xd6>
      } else if(c == 'x') {
 53c:	07a78863          	beq	a5,s10,5ac <vprintf+0xf2>
      } else if(c == 'p') {
 540:	09b78463          	beq	a5,s11,5c8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 544:	07300713          	li	a4,115
 548:	0ce78663          	beq	a5,a4,614 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54c:	06300713          	li	a4,99
 550:	0ee78e63          	beq	a5,a4,64c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 554:	11478863          	beq	a5,s4,664 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 558:	85d2                	mv	a1,s4
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e92080e7          	jalr	-366(ra) # 3ee <putc>
        putc(fd, c);
 564:	85ca                	mv	a1,s2
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e86080e7          	jalr	-378(ra) # 3ee <putc>
      }
      state = 0;
 570:	4981                	li	s3,0
 572:	b765                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 574:	008b0913          	addi	s2,s6,8
 578:	4685                	li	a3,1
 57a:	4629                	li	a2,10
 57c:	000b2583          	lw	a1,0(s6)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e8e080e7          	jalr	-370(ra) # 410 <printint>
 58a:	8b4a                	mv	s6,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b771                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b0913          	addi	s2,s6,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000b2583          	lw	a1,0(s6)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e72080e7          	jalr	-398(ra) # 410 <printint>
 5a6:	8b4a                	mv	s6,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bf85                	j	51a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ac:	008b0913          	addi	s2,s6,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000b2583          	lw	a1,0(s6)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e56080e7          	jalr	-426(ra) # 410 <printint>
 5c2:	8b4a                	mv	s6,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf91                	j	51a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c8:	008b0793          	addi	a5,s6,8
 5cc:	f8f43423          	sd	a5,-120(s0)
 5d0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d4:	03000593          	li	a1,48
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e14080e7          	jalr	-492(ra) # 3ee <putc>
  putc(fd, 'x');
 5e2:	85ea                	mv	a1,s10
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e08080e7          	jalr	-504(ra) # 3ee <putc>
 5ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	03c9d793          	srli	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	df2080e7          	jalr	-526(ra) # 3ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 604:	0992                	slli	s3,s3,0x4
 606:	397d                	addiw	s2,s2,-1
 608:	fe0914e3          	bnez	s2,5f0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 60c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 610:	4981                	li	s3,0
 612:	b721                	j	51a <vprintf+0x60>
        s = va_arg(ap, char*);
 614:	008b0993          	addi	s3,s6,8
 618:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 61c:	02090163          	beqz	s2,63e <vprintf+0x184>
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	c9a1                	beqz	a1,674 <vprintf+0x1ba>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dc6080e7          	jalr	-570(ra) # 3ee <putc>
          s++;
 630:	0905                	addi	s2,s2,1
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	f9e5                	bnez	a1,626 <vprintf+0x16c>
        s = va_arg(ap, char*);
 638:	8b4e                	mv	s6,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bdf9                	j	51a <vprintf+0x60>
          s = "(null)";
 63e:	00000917          	auipc	s2,0x0
 642:	23a90913          	addi	s2,s2,570 # 878 <malloc+0xf4>
        while(*s != 0){
 646:	02800593          	li	a1,40
 64a:	bff1                	j	626 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 64c:	008b0913          	addi	s2,s6,8
 650:	000b4583          	lbu	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	d98080e7          	jalr	-616(ra) # 3ee <putc>
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bd65                	j	51a <vprintf+0x60>
        putc(fd, c);
 664:	85d2                	mv	a1,s4
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d86080e7          	jalr	-634(ra) # 3ee <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	b565                	j	51a <vprintf+0x60>
        s = va_arg(ap, char*);
 674:	8b4e                	mv	s6,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b54d                	j	51a <vprintf+0x60>
    }
  }
}
 67a:	70e6                	ld	ra,120(sp)
 67c:	7446                	ld	s0,112(sp)
 67e:	74a6                	ld	s1,104(sp)
 680:	7906                	ld	s2,96(sp)
 682:	69e6                	ld	s3,88(sp)
 684:	6a46                	ld	s4,80(sp)
 686:	6aa6                	ld	s5,72(sp)
 688:	6b06                	ld	s6,64(sp)
 68a:	7be2                	ld	s7,56(sp)
 68c:	7c42                	ld	s8,48(sp)
 68e:	7ca2                	ld	s9,40(sp)
 690:	7d02                	ld	s10,32(sp)
 692:	6de2                	ld	s11,24(sp)
 694:	6109                	addi	sp,sp,128
 696:	8082                	ret

0000000000000698 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 698:	715d                	addi	sp,sp,-80
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e010                	sd	a2,0(s0)
 6a2:	e414                	sd	a3,8(s0)
 6a4:	e818                	sd	a4,16(s0)
 6a6:	ec1c                	sd	a5,24(s0)
 6a8:	03043023          	sd	a6,32(s0)
 6ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b4:	8622                	mv	a2,s0
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e04080e7          	jalr	-508(ra) # 4ba <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6161                	addi	sp,sp,80
 6c4:	8082                	ret

00000000000006c6 <printf>:

void
printf(const char *fmt, ...)
{
 6c6:	711d                	addi	sp,sp,-96
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e40c                	sd	a1,8(s0)
 6d0:	e810                	sd	a2,16(s0)
 6d2:	ec14                	sd	a3,24(s0)
 6d4:	f018                	sd	a4,32(s0)
 6d6:	f41c                	sd	a5,40(s0)
 6d8:	03043823          	sd	a6,48(s0)
 6dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	00840613          	addi	a2,s0,8
 6e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e8:	85aa                	mv	a1,a0
 6ea:	4505                	li	a0,1
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dce080e7          	jalr	-562(ra) # 4ba <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6125                	addi	sp,sp,96
 6fa:	8082                	ret

00000000000006fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fc:	1141                	addi	sp,sp,-16
 6fe:	e422                	sd	s0,8(sp)
 700:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 702:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	00000797          	auipc	a5,0x0
 70a:	1927b783          	ld	a5,402(a5) # 898 <freep>
 70e:	a805                	j	73e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 710:	4618                	lw	a4,8(a2)
 712:	9db9                	addw	a1,a1,a4
 714:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 718:	6398                	ld	a4,0(a5)
 71a:	6318                	ld	a4,0(a4)
 71c:	fee53823          	sd	a4,-16(a0)
 720:	a091                	j	764 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 722:	ff852703          	lw	a4,-8(a0)
 726:	9e39                	addw	a2,a2,a4
 728:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 72a:	ff053703          	ld	a4,-16(a0)
 72e:	e398                	sd	a4,0(a5)
 730:	a099                	j	776 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	6398                	ld	a4,0(a5)
 734:	00e7e463          	bltu	a5,a4,73c <free+0x40>
 738:	00e6ea63          	bltu	a3,a4,74c <free+0x50>
{
 73c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	fed7fae3          	bgeu	a5,a3,732 <free+0x36>
 742:	6398                	ld	a4,0(a5)
 744:	00e6e463          	bltu	a3,a4,74c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	fee7eae3          	bltu	a5,a4,73c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 74c:	ff852583          	lw	a1,-8(a0)
 750:	6390                	ld	a2,0(a5)
 752:	02059713          	slli	a4,a1,0x20
 756:	9301                	srli	a4,a4,0x20
 758:	0712                	slli	a4,a4,0x4
 75a:	9736                	add	a4,a4,a3
 75c:	fae60ae3          	beq	a2,a4,710 <free+0x14>
    bp->s.ptr = p->s.ptr;
 760:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 764:	4790                	lw	a2,8(a5)
 766:	02061713          	slli	a4,a2,0x20
 76a:	9301                	srli	a4,a4,0x20
 76c:	0712                	slli	a4,a4,0x4
 76e:	973e                	add	a4,a4,a5
 770:	fae689e3          	beq	a3,a4,722 <free+0x26>
  } else
    p->s.ptr = bp;
 774:	e394                	sd	a3,0(a5)
  freep = p;
 776:	00000717          	auipc	a4,0x0
 77a:	12f73123          	sd	a5,290(a4) # 898 <freep>
}
 77e:	6422                	ld	s0,8(sp)
 780:	0141                	addi	sp,sp,16
 782:	8082                	ret

0000000000000784 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 784:	7139                	addi	sp,sp,-64
 786:	fc06                	sd	ra,56(sp)
 788:	f822                	sd	s0,48(sp)
 78a:	f426                	sd	s1,40(sp)
 78c:	f04a                	sd	s2,32(sp)
 78e:	ec4e                	sd	s3,24(sp)
 790:	e852                	sd	s4,16(sp)
 792:	e456                	sd	s5,8(sp)
 794:	e05a                	sd	s6,0(sp)
 796:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 798:	02051493          	slli	s1,a0,0x20
 79c:	9081                	srli	s1,s1,0x20
 79e:	04bd                	addi	s1,s1,15
 7a0:	8091                	srli	s1,s1,0x4
 7a2:	0014899b          	addiw	s3,s1,1
 7a6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a8:	00000517          	auipc	a0,0x0
 7ac:	0f053503          	ld	a0,240(a0) # 898 <freep>
 7b0:	c515                	beqz	a0,7dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b4:	4798                	lw	a4,8(a5)
 7b6:	02977f63          	bgeu	a4,s1,7f4 <malloc+0x70>
 7ba:	8a4e                	mv	s4,s3
 7bc:	0009871b          	sext.w	a4,s3
 7c0:	6685                	lui	a3,0x1
 7c2:	00d77363          	bgeu	a4,a3,7c8 <malloc+0x44>
 7c6:	6a05                	lui	s4,0x1
 7c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d0:	00000917          	auipc	s2,0x0
 7d4:	0c890913          	addi	s2,s2,200 # 898 <freep>
  if(p == (char*)-1)
 7d8:	5afd                	li	s5,-1
 7da:	a88d                	j	84c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7dc:	00000797          	auipc	a5,0x0
 7e0:	0c478793          	addi	a5,a5,196 # 8a0 <base>
 7e4:	00000717          	auipc	a4,0x0
 7e8:	0af73a23          	sd	a5,180(a4) # 898 <freep>
 7ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f2:	b7e1                	j	7ba <malloc+0x36>
      if(p->s.size == nunits)
 7f4:	02e48b63          	beq	s1,a4,82a <malloc+0xa6>
        p->s.size -= nunits;
 7f8:	4137073b          	subw	a4,a4,s3
 7fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fe:	1702                	slli	a4,a4,0x20
 800:	9301                	srli	a4,a4,0x20
 802:	0712                	slli	a4,a4,0x4
 804:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 806:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 80a:	00000717          	auipc	a4,0x0
 80e:	08a73723          	sd	a0,142(a4) # 898 <freep>
      return (void*)(p + 1);
 812:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 816:	70e2                	ld	ra,56(sp)
 818:	7442                	ld	s0,48(sp)
 81a:	74a2                	ld	s1,40(sp)
 81c:	7902                	ld	s2,32(sp)
 81e:	69e2                	ld	s3,24(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	6121                	addi	sp,sp,64
 828:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	e118                	sd	a4,0(a0)
 82e:	bff1                	j	80a <malloc+0x86>
  hp->s.size = nu;
 830:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 834:	0541                	addi	a0,a0,16
 836:	00000097          	auipc	ra,0x0
 83a:	ec6080e7          	jalr	-314(ra) # 6fc <free>
  return freep;
 83e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 842:	d971                	beqz	a0,816 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	fa9776e3          	bgeu	a4,s1,7f4 <malloc+0x70>
    if(p == freep)
 84c:	00093703          	ld	a4,0(s2)
 850:	853e                	mv	a0,a5
 852:	fef719e3          	bne	a4,a5,844 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 856:	8552                	mv	a0,s4
 858:	00000097          	auipc	ra,0x0
 85c:	ad4080e7          	jalr	-1324(ra) # 32c <sbrk>
  if(p == (char*)-1)
 860:	fd5518e3          	bne	a0,s5,830 <malloc+0xac>
        return 0;
 864:	4501                	li	a0,0
 866:	bf45                	j	816 <malloc+0x92>
