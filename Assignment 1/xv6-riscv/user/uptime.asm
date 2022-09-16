
user/_uptime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
if(argc!=1)
   8:	4785                	li	a5,1
   a:	02f50063          	beq	a0,a5,2a <main+0x2a>
{
	fprintf(2,"usage: uptime\n");
   e:	00000597          	auipc	a1,0x0
  12:	7ea58593          	addi	a1,a1,2026 # 7f8 <malloc+0xe4>
  16:	4509                	li	a0,2
  18:	00000097          	auipc	ra,0x0
  1c:	610080e7          	jalr	1552(ra) # 628 <fprintf>
	exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	2a4080e7          	jalr	676(ra) # 2c6 <exit>
}
int x=uptime();
  2a:	00000097          	auipc	ra,0x0
  2e:	334080e7          	jalr	820(ra) # 35e <uptime>
  32:	862a                	mv	a2,a0
fprintf(1,"%d\n",x);
  34:	00000597          	auipc	a1,0x0
  38:	7d458593          	addi	a1,a1,2004 # 808 <malloc+0xf4>
  3c:	4505                	li	a0,1
  3e:	00000097          	auipc	ra,0x0
  42:	5ea080e7          	jalr	1514(ra) # 628 <fprintf>
exit(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	27e080e7          	jalr	638(ra) # 2c6 <exit>

0000000000000050 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  50:	1141                	addi	sp,sp,-16
  52:	e422                	sd	s0,8(sp)
  54:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  56:	87aa                	mv	a5,a0
  58:	0585                	addi	a1,a1,1
  5a:	0785                	addi	a5,a5,1
  5c:	fff5c703          	lbu	a4,-1(a1)
  60:	fee78fa3          	sb	a4,-1(a5)
  64:	fb75                	bnez	a4,58 <strcpy+0x8>
    ;
  return os;
}
  66:	6422                	ld	s0,8(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  72:	00054783          	lbu	a5,0(a0)
  76:	cb91                	beqz	a5,8a <strcmp+0x1e>
  78:	0005c703          	lbu	a4,0(a1)
  7c:	00f71763          	bne	a4,a5,8a <strcmp+0x1e>
    p++, q++;
  80:	0505                	addi	a0,a0,1
  82:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	fbe5                	bnez	a5,78 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  8a:	0005c503          	lbu	a0,0(a1)
}
  8e:	40a7853b          	subw	a0,a5,a0
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strlen>:

uint
strlen(const char *s)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cf91                	beqz	a5,be <strlen+0x26>
  a4:	0505                	addi	a0,a0,1
  a6:	87aa                	mv	a5,a0
  a8:	4685                	li	a3,1
  aa:	9e89                	subw	a3,a3,a0
  ac:	00f6853b          	addw	a0,a3,a5
  b0:	0785                	addi	a5,a5,1
  b2:	fff7c703          	lbu	a4,-1(a5)
  b6:	fb7d                	bnez	a4,ac <strlen+0x14>
    ;
  return n;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret
  for(n = 0; s[n]; n++)
  be:	4501                	li	a0,0
  c0:	bfe5                	j	b8 <strlen+0x20>

00000000000000c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c8:	ce09                	beqz	a2,e2 <memset+0x20>
  ca:	87aa                	mv	a5,a0
  cc:	fff6071b          	addiw	a4,a2,-1
  d0:	1702                	slli	a4,a4,0x20
  d2:	9301                	srli	a4,a4,0x20
  d4:	0705                	addi	a4,a4,1
  d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
  d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  dc:	0785                	addi	a5,a5,1
  de:	fee79de3          	bne	a5,a4,d8 <memset+0x16>
  }
  return dst;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb99                	beqz	a5,108 <strchr+0x20>
    if(*s == c)
  f4:	00f58763          	beq	a1,a5,102 <strchr+0x1a>
  for(; *s; s++)
  f8:	0505                	addi	a0,a0,1
  fa:	00054783          	lbu	a5,0(a0)
  fe:	fbfd                	bnez	a5,f4 <strchr+0xc>
      return (char*)s;
  return 0;
 100:	4501                	li	a0,0
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  return 0;
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strchr+0x1a>

000000000000010c <gets>:

char*
gets(char *buf, int max)
{
 10c:	711d                	addi	sp,sp,-96
 10e:	ec86                	sd	ra,88(sp)
 110:	e8a2                	sd	s0,80(sp)
 112:	e4a6                	sd	s1,72(sp)
 114:	e0ca                	sd	s2,64(sp)
 116:	fc4e                	sd	s3,56(sp)
 118:	f852                	sd	s4,48(sp)
 11a:	f456                	sd	s5,40(sp)
 11c:	f05a                	sd	s6,32(sp)
 11e:	ec5e                	sd	s7,24(sp)
 120:	1080                	addi	s0,sp,96
 122:	8baa                	mv	s7,a0
 124:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 126:	892a                	mv	s2,a0
 128:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 12a:	4aa9                	li	s5,10
 12c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 12e:	89a6                	mv	s3,s1
 130:	2485                	addiw	s1,s1,1
 132:	0344d863          	bge	s1,s4,162 <gets+0x56>
    cc = read(0, &c, 1);
 136:	4605                	li	a2,1
 138:	faf40593          	addi	a1,s0,-81
 13c:	4501                	li	a0,0
 13e:	00000097          	auipc	ra,0x0
 142:	1a0080e7          	jalr	416(ra) # 2de <read>
    if(cc < 1)
 146:	00a05e63          	blez	a0,162 <gets+0x56>
    buf[i++] = c;
 14a:	faf44783          	lbu	a5,-81(s0)
 14e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 152:	01578763          	beq	a5,s5,160 <gets+0x54>
 156:	0905                	addi	s2,s2,1
 158:	fd679be3          	bne	a5,s6,12e <gets+0x22>
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	a011                	j	162 <gets+0x56>
 160:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 162:	99de                	add	s3,s3,s7
 164:	00098023          	sb	zero,0(s3)
  return buf;
}
 168:	855e                	mv	a0,s7
 16a:	60e6                	ld	ra,88(sp)
 16c:	6446                	ld	s0,80(sp)
 16e:	64a6                	ld	s1,72(sp)
 170:	6906                	ld	s2,64(sp)
 172:	79e2                	ld	s3,56(sp)
 174:	7a42                	ld	s4,48(sp)
 176:	7aa2                	ld	s5,40(sp)
 178:	7b02                	ld	s6,32(sp)
 17a:	6be2                	ld	s7,24(sp)
 17c:	6125                	addi	sp,sp,96
 17e:	8082                	ret

0000000000000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e426                	sd	s1,8(sp)
 188:	e04a                	sd	s2,0(sp)
 18a:	1000                	addi	s0,sp,32
 18c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	4581                	li	a1,0
 190:	00000097          	auipc	ra,0x0
 194:	176080e7          	jalr	374(ra) # 306 <open>
  if(fd < 0)
 198:	02054563          	bltz	a0,1c2 <stat+0x42>
 19c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19e:	85ca                	mv	a1,s2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	17e080e7          	jalr	382(ra) # 31e <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	142080e7          	jalr	322(ra) # 2ee <close>
  return r;
}
 1b4:	854a                	mv	a0,s2
 1b6:	60e2                	ld	ra,24(sp)
 1b8:	6442                	ld	s0,16(sp)
 1ba:	64a2                	ld	s1,8(sp)
 1bc:	6902                	ld	s2,0(sp)
 1be:	6105                	addi	sp,sp,32
 1c0:	8082                	ret
    return -1;
 1c2:	597d                	li	s2,-1
 1c4:	bfc5                	j	1b4 <stat+0x34>

00000000000001c6 <atoi>:

int
atoi(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cc:	00054603          	lbu	a2,0(a0)
 1d0:	fd06079b          	addiw	a5,a2,-48
 1d4:	0ff7f793          	andi	a5,a5,255
 1d8:	4725                	li	a4,9
 1da:	02f76963          	bltu	a4,a5,20c <atoi+0x46>
 1de:	86aa                	mv	a3,a0
  n = 0;
 1e0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1e2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1e4:	0685                	addi	a3,a3,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb1                	addw	a5,a5,a2
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	0006c603          	lbu	a2,0(a3)
 1fa:	fd06071b          	addiw	a4,a2,-48
 1fe:	0ff77713          	andi	a4,a4,255
 202:	fee5f1e3          	bgeu	a1,a4,1e4 <atoi+0x1e>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x40>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57663          	bgeu	a0,a1,242 <memmove+0x32>
    while(n-- > 0)
 21a:	02c05163          	blez	a2,23c <memmove+0x2c>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	0785                	addi	a5,a5,1
 228:	97aa                	add	a5,a5,a0
  dst = vdst;
 22a:	872a                	mv	a4,a0
      *dst++ = *src++;
 22c:	0585                	addi	a1,a1,1
 22e:	0705                	addi	a4,a4,1
 230:	fff5c683          	lbu	a3,-1(a1)
 234:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 248:	fec05ae3          	blez	a2,23c <memmove+0x2c>
 24c:	fff6079b          	addiw	a5,a2,-1
 250:	1782                	slli	a5,a5,0x20
 252:	9381                	srli	a5,a5,0x20
 254:	fff7c793          	not	a5,a5
 258:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25a:	15fd                	addi	a1,a1,-1
 25c:	177d                	addi	a4,a4,-1
 25e:	0005c683          	lbu	a3,0(a1)
 262:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x4a>
 26a:	bfc9                	j	23c <memmove+0x2c>

000000000000026c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 272:	ca05                	beqz	a2,2a2 <memcmp+0x36>
 274:	fff6069b          	addiw	a3,a2,-1
 278:	1682                	slli	a3,a3,0x20
 27a:	9281                	srli	a3,a3,0x20
 27c:	0685                	addi	a3,a3,1
 27e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 280:	00054783          	lbu	a5,0(a0)
 284:	0005c703          	lbu	a4,0(a1)
 288:	00e79863          	bne	a5,a4,298 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28c:	0505                	addi	a0,a0,1
    p2++;
 28e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 290:	fed518e3          	bne	a0,a3,280 <memcmp+0x14>
  }
  return 0;
 294:	4501                	li	a0,0
 296:	a019                	j	29c <memcmp+0x30>
      return *p1 - *p2;
 298:	40e7853b          	subw	a0,a5,a4
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <memcmp+0x30>

00000000000002a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ae:	00000097          	auipc	ra,0x0
 2b2:	f62080e7          	jalr	-158(ra) # 210 <memmove>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 366:	48d9                	li	a7,22
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <yield>:
.global yield
yield:
 li a7, SYS_yield
 36e:	48dd                	li	a7,23
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 376:	48e1                	li	a7,24
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37e:	1101                	addi	sp,sp,-32
 380:	ec06                	sd	ra,24(sp)
 382:	e822                	sd	s0,16(sp)
 384:	1000                	addi	s0,sp,32
 386:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38a:	4605                	li	a2,1
 38c:	fef40593          	addi	a1,s0,-17
 390:	00000097          	auipc	ra,0x0
 394:	f56080e7          	jalr	-170(ra) # 2e6 <write>
}
 398:	60e2                	ld	ra,24(sp)
 39a:	6442                	ld	s0,16(sp)
 39c:	6105                	addi	sp,sp,32
 39e:	8082                	ret

00000000000003a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	7139                	addi	sp,sp,-64
 3a2:	fc06                	sd	ra,56(sp)
 3a4:	f822                	sd	s0,48(sp)
 3a6:	f426                	sd	s1,40(sp)
 3a8:	f04a                	sd	s2,32(sp)
 3aa:	ec4e                	sd	s3,24(sp)
 3ac:	0080                	addi	s0,sp,64
 3ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b0:	c299                	beqz	a3,3b6 <printint+0x16>
 3b2:	0805c863          	bltz	a1,442 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b6:	2581                	sext.w	a1,a1
  neg = 0;
 3b8:	4881                	li	a7,0
 3ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c0:	2601                	sext.w	a2,a2
 3c2:	00000517          	auipc	a0,0x0
 3c6:	45650513          	addi	a0,a0,1110 # 818 <digits>
 3ca:	883a                	mv	a6,a4
 3cc:	2705                	addiw	a4,a4,1
 3ce:	02c5f7bb          	remuw	a5,a1,a2
 3d2:	1782                	slli	a5,a5,0x20
 3d4:	9381                	srli	a5,a5,0x20
 3d6:	97aa                	add	a5,a5,a0
 3d8:	0007c783          	lbu	a5,0(a5)
 3dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e0:	0005879b          	sext.w	a5,a1
 3e4:	02c5d5bb          	divuw	a1,a1,a2
 3e8:	0685                	addi	a3,a3,1
 3ea:	fec7f0e3          	bgeu	a5,a2,3ca <printint+0x2a>
  if(neg)
 3ee:	00088b63          	beqz	a7,404 <printint+0x64>
    buf[i++] = '-';
 3f2:	fd040793          	addi	a5,s0,-48
 3f6:	973e                	add	a4,a4,a5
 3f8:	02d00793          	li	a5,45
 3fc:	fef70823          	sb	a5,-16(a4)
 400:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 404:	02e05863          	blez	a4,434 <printint+0x94>
 408:	fc040793          	addi	a5,s0,-64
 40c:	00e78933          	add	s2,a5,a4
 410:	fff78993          	addi	s3,a5,-1
 414:	99ba                	add	s3,s3,a4
 416:	377d                	addiw	a4,a4,-1
 418:	1702                	slli	a4,a4,0x20
 41a:	9301                	srli	a4,a4,0x20
 41c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 420:	fff94583          	lbu	a1,-1(s2)
 424:	8526                	mv	a0,s1
 426:	00000097          	auipc	ra,0x0
 42a:	f58080e7          	jalr	-168(ra) # 37e <putc>
  while(--i >= 0)
 42e:	197d                	addi	s2,s2,-1
 430:	ff3918e3          	bne	s2,s3,420 <printint+0x80>
}
 434:	70e2                	ld	ra,56(sp)
 436:	7442                	ld	s0,48(sp)
 438:	74a2                	ld	s1,40(sp)
 43a:	7902                	ld	s2,32(sp)
 43c:	69e2                	ld	s3,24(sp)
 43e:	6121                	addi	sp,sp,64
 440:	8082                	ret
    x = -xx;
 442:	40b005bb          	negw	a1,a1
    neg = 1;
 446:	4885                	li	a7,1
    x = -xx;
 448:	bf8d                	j	3ba <printint+0x1a>

000000000000044a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44a:	7119                	addi	sp,sp,-128
 44c:	fc86                	sd	ra,120(sp)
 44e:	f8a2                	sd	s0,112(sp)
 450:	f4a6                	sd	s1,104(sp)
 452:	f0ca                	sd	s2,96(sp)
 454:	ecce                	sd	s3,88(sp)
 456:	e8d2                	sd	s4,80(sp)
 458:	e4d6                	sd	s5,72(sp)
 45a:	e0da                	sd	s6,64(sp)
 45c:	fc5e                	sd	s7,56(sp)
 45e:	f862                	sd	s8,48(sp)
 460:	f466                	sd	s9,40(sp)
 462:	f06a                	sd	s10,32(sp)
 464:	ec6e                	sd	s11,24(sp)
 466:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 468:	0005c903          	lbu	s2,0(a1)
 46c:	18090f63          	beqz	s2,60a <vprintf+0x1c0>
 470:	8aaa                	mv	s5,a0
 472:	8b32                	mv	s6,a2
 474:	00158493          	addi	s1,a1,1
  state = 0;
 478:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47a:	02500a13          	li	s4,37
      if(c == 'd'){
 47e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 482:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 486:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 48a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 48e:	00000b97          	auipc	s7,0x0
 492:	38ab8b93          	addi	s7,s7,906 # 818 <digits>
 496:	a839                	j	4b4 <vprintf+0x6a>
        putc(fd, c);
 498:	85ca                	mv	a1,s2
 49a:	8556                	mv	a0,s5
 49c:	00000097          	auipc	ra,0x0
 4a0:	ee2080e7          	jalr	-286(ra) # 37e <putc>
 4a4:	a019                	j	4aa <vprintf+0x60>
    } else if(state == '%'){
 4a6:	01498f63          	beq	s3,s4,4c4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4aa:	0485                	addi	s1,s1,1
 4ac:	fff4c903          	lbu	s2,-1(s1)
 4b0:	14090d63          	beqz	s2,60a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4b4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b8:	fe0997e3          	bnez	s3,4a6 <vprintf+0x5c>
      if(c == '%'){
 4bc:	fd479ee3          	bne	a5,s4,498 <vprintf+0x4e>
        state = '%';
 4c0:	89be                	mv	s3,a5
 4c2:	b7e5                	j	4aa <vprintf+0x60>
      if(c == 'd'){
 4c4:	05878063          	beq	a5,s8,504 <vprintf+0xba>
      } else if(c == 'l') {
 4c8:	05978c63          	beq	a5,s9,520 <vprintf+0xd6>
      } else if(c == 'x') {
 4cc:	07a78863          	beq	a5,s10,53c <vprintf+0xf2>
      } else if(c == 'p') {
 4d0:	09b78463          	beq	a5,s11,558 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4d4:	07300713          	li	a4,115
 4d8:	0ce78663          	beq	a5,a4,5a4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4dc:	06300713          	li	a4,99
 4e0:	0ee78e63          	beq	a5,a4,5dc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4e4:	11478863          	beq	a5,s4,5f4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4e8:	85d2                	mv	a1,s4
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	e92080e7          	jalr	-366(ra) # 37e <putc>
        putc(fd, c);
 4f4:	85ca                	mv	a1,s2
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	e86080e7          	jalr	-378(ra) # 37e <putc>
      }
      state = 0;
 500:	4981                	li	s3,0
 502:	b765                	j	4aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 504:	008b0913          	addi	s2,s6,8
 508:	4685                	li	a3,1
 50a:	4629                	li	a2,10
 50c:	000b2583          	lw	a1,0(s6)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e8e080e7          	jalr	-370(ra) # 3a0 <printint>
 51a:	8b4a                	mv	s6,s2
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b771                	j	4aa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 520:	008b0913          	addi	s2,s6,8
 524:	4681                	li	a3,0
 526:	4629                	li	a2,10
 528:	000b2583          	lw	a1,0(s6)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e72080e7          	jalr	-398(ra) # 3a0 <printint>
 536:	8b4a                	mv	s6,s2
      state = 0;
 538:	4981                	li	s3,0
 53a:	bf85                	j	4aa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 53c:	008b0913          	addi	s2,s6,8
 540:	4681                	li	a3,0
 542:	4641                	li	a2,16
 544:	000b2583          	lw	a1,0(s6)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e56080e7          	jalr	-426(ra) # 3a0 <printint>
 552:	8b4a                	mv	s6,s2
      state = 0;
 554:	4981                	li	s3,0
 556:	bf91                	j	4aa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 558:	008b0793          	addi	a5,s6,8
 55c:	f8f43423          	sd	a5,-120(s0)
 560:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 564:	03000593          	li	a1,48
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	e14080e7          	jalr	-492(ra) # 37e <putc>
  putc(fd, 'x');
 572:	85ea                	mv	a1,s10
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e08080e7          	jalr	-504(ra) # 37e <putc>
 57e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 580:	03c9d793          	srli	a5,s3,0x3c
 584:	97de                	add	a5,a5,s7
 586:	0007c583          	lbu	a1,0(a5)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	df2080e7          	jalr	-526(ra) # 37e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 594:	0992                	slli	s3,s3,0x4
 596:	397d                	addiw	s2,s2,-1
 598:	fe0914e3          	bnez	s2,580 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 59c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b721                	j	4aa <vprintf+0x60>
        s = va_arg(ap, char*);
 5a4:	008b0993          	addi	s3,s6,8
 5a8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ac:	02090163          	beqz	s2,5ce <vprintf+0x184>
        while(*s != 0){
 5b0:	00094583          	lbu	a1,0(s2)
 5b4:	c9a1                	beqz	a1,604 <vprintf+0x1ba>
          putc(fd, *s);
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	dc6080e7          	jalr	-570(ra) # 37e <putc>
          s++;
 5c0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c2:	00094583          	lbu	a1,0(s2)
 5c6:	f9e5                	bnez	a1,5b6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5c8:	8b4e                	mv	s6,s3
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bdf9                	j	4aa <vprintf+0x60>
          s = "(null)";
 5ce:	00000917          	auipc	s2,0x0
 5d2:	24290913          	addi	s2,s2,578 # 810 <malloc+0xfc>
        while(*s != 0){
 5d6:	02800593          	li	a1,40
 5da:	bff1                	j	5b6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5dc:	008b0913          	addi	s2,s6,8
 5e0:	000b4583          	lbu	a1,0(s6)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	d98080e7          	jalr	-616(ra) # 37e <putc>
 5ee:	8b4a                	mv	s6,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bd65                	j	4aa <vprintf+0x60>
        putc(fd, c);
 5f4:	85d2                	mv	a1,s4
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	d86080e7          	jalr	-634(ra) # 37e <putc>
      state = 0;
 600:	4981                	li	s3,0
 602:	b565                	j	4aa <vprintf+0x60>
        s = va_arg(ap, char*);
 604:	8b4e                	mv	s6,s3
      state = 0;
 606:	4981                	li	s3,0
 608:	b54d                	j	4aa <vprintf+0x60>
    }
  }
}
 60a:	70e6                	ld	ra,120(sp)
 60c:	7446                	ld	s0,112(sp)
 60e:	74a6                	ld	s1,104(sp)
 610:	7906                	ld	s2,96(sp)
 612:	69e6                	ld	s3,88(sp)
 614:	6a46                	ld	s4,80(sp)
 616:	6aa6                	ld	s5,72(sp)
 618:	6b06                	ld	s6,64(sp)
 61a:	7be2                	ld	s7,56(sp)
 61c:	7c42                	ld	s8,48(sp)
 61e:	7ca2                	ld	s9,40(sp)
 620:	7d02                	ld	s10,32(sp)
 622:	6de2                	ld	s11,24(sp)
 624:	6109                	addi	sp,sp,128
 626:	8082                	ret

0000000000000628 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 628:	715d                	addi	sp,sp,-80
 62a:	ec06                	sd	ra,24(sp)
 62c:	e822                	sd	s0,16(sp)
 62e:	1000                	addi	s0,sp,32
 630:	e010                	sd	a2,0(s0)
 632:	e414                	sd	a3,8(s0)
 634:	e818                	sd	a4,16(s0)
 636:	ec1c                	sd	a5,24(s0)
 638:	03043023          	sd	a6,32(s0)
 63c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 640:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 644:	8622                	mv	a2,s0
 646:	00000097          	auipc	ra,0x0
 64a:	e04080e7          	jalr	-508(ra) # 44a <vprintf>
}
 64e:	60e2                	ld	ra,24(sp)
 650:	6442                	ld	s0,16(sp)
 652:	6161                	addi	sp,sp,80
 654:	8082                	ret

0000000000000656 <printf>:

void
printf(const char *fmt, ...)
{
 656:	711d                	addi	sp,sp,-96
 658:	ec06                	sd	ra,24(sp)
 65a:	e822                	sd	s0,16(sp)
 65c:	1000                	addi	s0,sp,32
 65e:	e40c                	sd	a1,8(s0)
 660:	e810                	sd	a2,16(s0)
 662:	ec14                	sd	a3,24(s0)
 664:	f018                	sd	a4,32(s0)
 666:	f41c                	sd	a5,40(s0)
 668:	03043823          	sd	a6,48(s0)
 66c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 670:	00840613          	addi	a2,s0,8
 674:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 678:	85aa                	mv	a1,a0
 67a:	4505                	li	a0,1
 67c:	00000097          	auipc	ra,0x0
 680:	dce080e7          	jalr	-562(ra) # 44a <vprintf>
}
 684:	60e2                	ld	ra,24(sp)
 686:	6442                	ld	s0,16(sp)
 688:	6125                	addi	sp,sp,96
 68a:	8082                	ret

000000000000068c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68c:	1141                	addi	sp,sp,-16
 68e:	e422                	sd	s0,8(sp)
 690:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 692:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	00000797          	auipc	a5,0x0
 69a:	19a7b783          	ld	a5,410(a5) # 830 <freep>
 69e:	a805                	j	6ce <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a0:	4618                	lw	a4,8(a2)
 6a2:	9db9                	addw	a1,a1,a4
 6a4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a8:	6398                	ld	a4,0(a5)
 6aa:	6318                	ld	a4,0(a4)
 6ac:	fee53823          	sd	a4,-16(a0)
 6b0:	a091                	j	6f4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b2:	ff852703          	lw	a4,-8(a0)
 6b6:	9e39                	addw	a2,a2,a4
 6b8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ba:	ff053703          	ld	a4,-16(a0)
 6be:	e398                	sd	a4,0(a5)
 6c0:	a099                	j	706 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	6398                	ld	a4,0(a5)
 6c4:	00e7e463          	bltu	a5,a4,6cc <free+0x40>
 6c8:	00e6ea63          	bltu	a3,a4,6dc <free+0x50>
{
 6cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	fed7fae3          	bgeu	a5,a3,6c2 <free+0x36>
 6d2:	6398                	ld	a4,0(a5)
 6d4:	00e6e463          	bltu	a3,a4,6dc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	fee7eae3          	bltu	a5,a4,6cc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6dc:	ff852583          	lw	a1,-8(a0)
 6e0:	6390                	ld	a2,0(a5)
 6e2:	02059713          	slli	a4,a1,0x20
 6e6:	9301                	srli	a4,a4,0x20
 6e8:	0712                	slli	a4,a4,0x4
 6ea:	9736                	add	a4,a4,a3
 6ec:	fae60ae3          	beq	a2,a4,6a0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6f4:	4790                	lw	a2,8(a5)
 6f6:	02061713          	slli	a4,a2,0x20
 6fa:	9301                	srli	a4,a4,0x20
 6fc:	0712                	slli	a4,a4,0x4
 6fe:	973e                	add	a4,a4,a5
 700:	fae689e3          	beq	a3,a4,6b2 <free+0x26>
  } else
    p->s.ptr = bp;
 704:	e394                	sd	a3,0(a5)
  freep = p;
 706:	00000717          	auipc	a4,0x0
 70a:	12f73523          	sd	a5,298(a4) # 830 <freep>
}
 70e:	6422                	ld	s0,8(sp)
 710:	0141                	addi	sp,sp,16
 712:	8082                	ret

0000000000000714 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 714:	7139                	addi	sp,sp,-64
 716:	fc06                	sd	ra,56(sp)
 718:	f822                	sd	s0,48(sp)
 71a:	f426                	sd	s1,40(sp)
 71c:	f04a                	sd	s2,32(sp)
 71e:	ec4e                	sd	s3,24(sp)
 720:	e852                	sd	s4,16(sp)
 722:	e456                	sd	s5,8(sp)
 724:	e05a                	sd	s6,0(sp)
 726:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 728:	02051493          	slli	s1,a0,0x20
 72c:	9081                	srli	s1,s1,0x20
 72e:	04bd                	addi	s1,s1,15
 730:	8091                	srli	s1,s1,0x4
 732:	0014899b          	addiw	s3,s1,1
 736:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 738:	00000517          	auipc	a0,0x0
 73c:	0f853503          	ld	a0,248(a0) # 830 <freep>
 740:	c515                	beqz	a0,76c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 744:	4798                	lw	a4,8(a5)
 746:	02977f63          	bgeu	a4,s1,784 <malloc+0x70>
 74a:	8a4e                	mv	s4,s3
 74c:	0009871b          	sext.w	a4,s3
 750:	6685                	lui	a3,0x1
 752:	00d77363          	bgeu	a4,a3,758 <malloc+0x44>
 756:	6a05                	lui	s4,0x1
 758:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 75c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 760:	00000917          	auipc	s2,0x0
 764:	0d090913          	addi	s2,s2,208 # 830 <freep>
  if(p == (char*)-1)
 768:	5afd                	li	s5,-1
 76a:	a88d                	j	7dc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 76c:	00000797          	auipc	a5,0x0
 770:	0cc78793          	addi	a5,a5,204 # 838 <base>
 774:	00000717          	auipc	a4,0x0
 778:	0af73e23          	sd	a5,188(a4) # 830 <freep>
 77c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 77e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 782:	b7e1                	j	74a <malloc+0x36>
      if(p->s.size == nunits)
 784:	02e48b63          	beq	s1,a4,7ba <malloc+0xa6>
        p->s.size -= nunits;
 788:	4137073b          	subw	a4,a4,s3
 78c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 78e:	1702                	slli	a4,a4,0x20
 790:	9301                	srli	a4,a4,0x20
 792:	0712                	slli	a4,a4,0x4
 794:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 796:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 79a:	00000717          	auipc	a4,0x0
 79e:	08a73b23          	sd	a0,150(a4) # 830 <freep>
      return (void*)(p + 1);
 7a2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a6:	70e2                	ld	ra,56(sp)
 7a8:	7442                	ld	s0,48(sp)
 7aa:	74a2                	ld	s1,40(sp)
 7ac:	7902                	ld	s2,32(sp)
 7ae:	69e2                	ld	s3,24(sp)
 7b0:	6a42                	ld	s4,16(sp)
 7b2:	6aa2                	ld	s5,8(sp)
 7b4:	6b02                	ld	s6,0(sp)
 7b6:	6121                	addi	sp,sp,64
 7b8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	e118                	sd	a4,0(a0)
 7be:	bff1                	j	79a <malloc+0x86>
  hp->s.size = nu;
 7c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c4:	0541                	addi	a0,a0,16
 7c6:	00000097          	auipc	ra,0x0
 7ca:	ec6080e7          	jalr	-314(ra) # 68c <free>
  return freep;
 7ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d2:	d971                	beqz	a0,7a6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d6:	4798                	lw	a4,8(a5)
 7d8:	fa9776e3          	bgeu	a4,s1,784 <malloc+0x70>
    if(p == freep)
 7dc:	00093703          	ld	a4,0(s2)
 7e0:	853e                	mv	a0,a5
 7e2:	fef719e3          	bne	a4,a5,7d4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7e6:	8552                	mv	a0,s4
 7e8:	00000097          	auipc	ra,0x0
 7ec:	b66080e7          	jalr	-1178(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7f0:	fd5518e3          	bne	a0,s5,7c0 <malloc+0xac>
        return 0;
 7f4:	4501                	li	a0,0
 7f6:	bf45                	j	7a6 <malloc+0x92>
