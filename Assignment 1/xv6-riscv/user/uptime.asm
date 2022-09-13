
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
  12:	7da58593          	addi	a1,a1,2010 # 7e8 <malloc+0xe4>
  16:	4509                	li	a0,2
  18:	00000097          	auipc	ra,0x0
  1c:	600080e7          	jalr	1536(ra) # 618 <fprintf>
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
  38:	7c458593          	addi	a1,a1,1988 # 7f8 <malloc+0xf4>
  3c:	4505                	li	a0,1
  3e:	00000097          	auipc	ra,0x0
  42:	5da080e7          	jalr	1498(ra) # 618 <fprintf>
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

000000000000036e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	1000                	addi	s0,sp,32
 376:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37a:	4605                	li	a2,1
 37c:	fef40593          	addi	a1,s0,-17
 380:	00000097          	auipc	ra,0x0
 384:	f66080e7          	jalr	-154(ra) # 2e6 <write>
}
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	6105                	addi	sp,sp,32
 38e:	8082                	ret

0000000000000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	7139                	addi	sp,sp,-64
 392:	fc06                	sd	ra,56(sp)
 394:	f822                	sd	s0,48(sp)
 396:	f426                	sd	s1,40(sp)
 398:	f04a                	sd	s2,32(sp)
 39a:	ec4e                	sd	s3,24(sp)
 39c:	0080                	addi	s0,sp,64
 39e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a0:	c299                	beqz	a3,3a6 <printint+0x16>
 3a2:	0805c863          	bltz	a1,432 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a6:	2581                	sext.w	a1,a1
  neg = 0;
 3a8:	4881                	li	a7,0
 3aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b0:	2601                	sext.w	a2,a2
 3b2:	00000517          	auipc	a0,0x0
 3b6:	45650513          	addi	a0,a0,1110 # 808 <digits>
 3ba:	883a                	mv	a6,a4
 3bc:	2705                	addiw	a4,a4,1
 3be:	02c5f7bb          	remuw	a5,a1,a2
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	97aa                	add	a5,a5,a0
 3c8:	0007c783          	lbu	a5,0(a5)
 3cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d0:	0005879b          	sext.w	a5,a1
 3d4:	02c5d5bb          	divuw	a1,a1,a2
 3d8:	0685                	addi	a3,a3,1
 3da:	fec7f0e3          	bgeu	a5,a2,3ba <printint+0x2a>
  if(neg)
 3de:	00088b63          	beqz	a7,3f4 <printint+0x64>
    buf[i++] = '-';
 3e2:	fd040793          	addi	a5,s0,-48
 3e6:	973e                	add	a4,a4,a5
 3e8:	02d00793          	li	a5,45
 3ec:	fef70823          	sb	a5,-16(a4)
 3f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f4:	02e05863          	blez	a4,424 <printint+0x94>
 3f8:	fc040793          	addi	a5,s0,-64
 3fc:	00e78933          	add	s2,a5,a4
 400:	fff78993          	addi	s3,a5,-1
 404:	99ba                	add	s3,s3,a4
 406:	377d                	addiw	a4,a4,-1
 408:	1702                	slli	a4,a4,0x20
 40a:	9301                	srli	a4,a4,0x20
 40c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 410:	fff94583          	lbu	a1,-1(s2)
 414:	8526                	mv	a0,s1
 416:	00000097          	auipc	ra,0x0
 41a:	f58080e7          	jalr	-168(ra) # 36e <putc>
  while(--i >= 0)
 41e:	197d                	addi	s2,s2,-1
 420:	ff3918e3          	bne	s2,s3,410 <printint+0x80>
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	7902                	ld	s2,32(sp)
 42c:	69e2                	ld	s3,24(sp)
 42e:	6121                	addi	sp,sp,64
 430:	8082                	ret
    x = -xx;
 432:	40b005bb          	negw	a1,a1
    neg = 1;
 436:	4885                	li	a7,1
    x = -xx;
 438:	bf8d                	j	3aa <printint+0x1a>

000000000000043a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43a:	7119                	addi	sp,sp,-128
 43c:	fc86                	sd	ra,120(sp)
 43e:	f8a2                	sd	s0,112(sp)
 440:	f4a6                	sd	s1,104(sp)
 442:	f0ca                	sd	s2,96(sp)
 444:	ecce                	sd	s3,88(sp)
 446:	e8d2                	sd	s4,80(sp)
 448:	e4d6                	sd	s5,72(sp)
 44a:	e0da                	sd	s6,64(sp)
 44c:	fc5e                	sd	s7,56(sp)
 44e:	f862                	sd	s8,48(sp)
 450:	f466                	sd	s9,40(sp)
 452:	f06a                	sd	s10,32(sp)
 454:	ec6e                	sd	s11,24(sp)
 456:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 458:	0005c903          	lbu	s2,0(a1)
 45c:	18090f63          	beqz	s2,5fa <vprintf+0x1c0>
 460:	8aaa                	mv	s5,a0
 462:	8b32                	mv	s6,a2
 464:	00158493          	addi	s1,a1,1
  state = 0;
 468:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46a:	02500a13          	li	s4,37
      if(c == 'd'){
 46e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 472:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 476:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 47a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 47e:	00000b97          	auipc	s7,0x0
 482:	38ab8b93          	addi	s7,s7,906 # 808 <digits>
 486:	a839                	j	4a4 <vprintf+0x6a>
        putc(fd, c);
 488:	85ca                	mv	a1,s2
 48a:	8556                	mv	a0,s5
 48c:	00000097          	auipc	ra,0x0
 490:	ee2080e7          	jalr	-286(ra) # 36e <putc>
 494:	a019                	j	49a <vprintf+0x60>
    } else if(state == '%'){
 496:	01498f63          	beq	s3,s4,4b4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 49a:	0485                	addi	s1,s1,1
 49c:	fff4c903          	lbu	s2,-1(s1)
 4a0:	14090d63          	beqz	s2,5fa <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a8:	fe0997e3          	bnez	s3,496 <vprintf+0x5c>
      if(c == '%'){
 4ac:	fd479ee3          	bne	a5,s4,488 <vprintf+0x4e>
        state = '%';
 4b0:	89be                	mv	s3,a5
 4b2:	b7e5                	j	49a <vprintf+0x60>
      if(c == 'd'){
 4b4:	05878063          	beq	a5,s8,4f4 <vprintf+0xba>
      } else if(c == 'l') {
 4b8:	05978c63          	beq	a5,s9,510 <vprintf+0xd6>
      } else if(c == 'x') {
 4bc:	07a78863          	beq	a5,s10,52c <vprintf+0xf2>
      } else if(c == 'p') {
 4c0:	09b78463          	beq	a5,s11,548 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4c4:	07300713          	li	a4,115
 4c8:	0ce78663          	beq	a5,a4,594 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4cc:	06300713          	li	a4,99
 4d0:	0ee78e63          	beq	a5,a4,5cc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4d4:	11478863          	beq	a5,s4,5e4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d8:	85d2                	mv	a1,s4
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	e92080e7          	jalr	-366(ra) # 36e <putc>
        putc(fd, c);
 4e4:	85ca                	mv	a1,s2
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	e86080e7          	jalr	-378(ra) # 36e <putc>
      }
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b765                	j	49a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4f4:	008b0913          	addi	s2,s6,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000b2583          	lw	a1,0(s6)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	e8e080e7          	jalr	-370(ra) # 390 <printint>
 50a:	8b4a                	mv	s6,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	b771                	j	49a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 510:	008b0913          	addi	s2,s6,8
 514:	4681                	li	a3,0
 516:	4629                	li	a2,10
 518:	000b2583          	lw	a1,0(s6)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e72080e7          	jalr	-398(ra) # 390 <printint>
 526:	8b4a                	mv	s6,s2
      state = 0;
 528:	4981                	li	s3,0
 52a:	bf85                	j	49a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 52c:	008b0913          	addi	s2,s6,8
 530:	4681                	li	a3,0
 532:	4641                	li	a2,16
 534:	000b2583          	lw	a1,0(s6)
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e56080e7          	jalr	-426(ra) # 390 <printint>
 542:	8b4a                	mv	s6,s2
      state = 0;
 544:	4981                	li	s3,0
 546:	bf91                	j	49a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 548:	008b0793          	addi	a5,s6,8
 54c:	f8f43423          	sd	a5,-120(s0)
 550:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 554:	03000593          	li	a1,48
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e14080e7          	jalr	-492(ra) # 36e <putc>
  putc(fd, 'x');
 562:	85ea                	mv	a1,s10
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e08080e7          	jalr	-504(ra) # 36e <putc>
 56e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 570:	03c9d793          	srli	a5,s3,0x3c
 574:	97de                	add	a5,a5,s7
 576:	0007c583          	lbu	a1,0(a5)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	df2080e7          	jalr	-526(ra) # 36e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 584:	0992                	slli	s3,s3,0x4
 586:	397d                	addiw	s2,s2,-1
 588:	fe0914e3          	bnez	s2,570 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 58c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 590:	4981                	li	s3,0
 592:	b721                	j	49a <vprintf+0x60>
        s = va_arg(ap, char*);
 594:	008b0993          	addi	s3,s6,8
 598:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 59c:	02090163          	beqz	s2,5be <vprintf+0x184>
        while(*s != 0){
 5a0:	00094583          	lbu	a1,0(s2)
 5a4:	c9a1                	beqz	a1,5f4 <vprintf+0x1ba>
          putc(fd, *s);
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	dc6080e7          	jalr	-570(ra) # 36e <putc>
          s++;
 5b0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5b2:	00094583          	lbu	a1,0(s2)
 5b6:	f9e5                	bnez	a1,5a6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5b8:	8b4e                	mv	s6,s3
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bdf9                	j	49a <vprintf+0x60>
          s = "(null)";
 5be:	00000917          	auipc	s2,0x0
 5c2:	24290913          	addi	s2,s2,578 # 800 <malloc+0xfc>
        while(*s != 0){
 5c6:	02800593          	li	a1,40
 5ca:	bff1                	j	5a6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5cc:	008b0913          	addi	s2,s6,8
 5d0:	000b4583          	lbu	a1,0(s6)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	d98080e7          	jalr	-616(ra) # 36e <putc>
 5de:	8b4a                	mv	s6,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bd65                	j	49a <vprintf+0x60>
        putc(fd, c);
 5e4:	85d2                	mv	a1,s4
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	d86080e7          	jalr	-634(ra) # 36e <putc>
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b565                	j	49a <vprintf+0x60>
        s = va_arg(ap, char*);
 5f4:	8b4e                	mv	s6,s3
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b54d                	j	49a <vprintf+0x60>
    }
  }
}
 5fa:	70e6                	ld	ra,120(sp)
 5fc:	7446                	ld	s0,112(sp)
 5fe:	74a6                	ld	s1,104(sp)
 600:	7906                	ld	s2,96(sp)
 602:	69e6                	ld	s3,88(sp)
 604:	6a46                	ld	s4,80(sp)
 606:	6aa6                	ld	s5,72(sp)
 608:	6b06                	ld	s6,64(sp)
 60a:	7be2                	ld	s7,56(sp)
 60c:	7c42                	ld	s8,48(sp)
 60e:	7ca2                	ld	s9,40(sp)
 610:	7d02                	ld	s10,32(sp)
 612:	6de2                	ld	s11,24(sp)
 614:	6109                	addi	sp,sp,128
 616:	8082                	ret

0000000000000618 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 618:	715d                	addi	sp,sp,-80
 61a:	ec06                	sd	ra,24(sp)
 61c:	e822                	sd	s0,16(sp)
 61e:	1000                	addi	s0,sp,32
 620:	e010                	sd	a2,0(s0)
 622:	e414                	sd	a3,8(s0)
 624:	e818                	sd	a4,16(s0)
 626:	ec1c                	sd	a5,24(s0)
 628:	03043023          	sd	a6,32(s0)
 62c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 630:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 634:	8622                	mv	a2,s0
 636:	00000097          	auipc	ra,0x0
 63a:	e04080e7          	jalr	-508(ra) # 43a <vprintf>
}
 63e:	60e2                	ld	ra,24(sp)
 640:	6442                	ld	s0,16(sp)
 642:	6161                	addi	sp,sp,80
 644:	8082                	ret

0000000000000646 <printf>:

void
printf(const char *fmt, ...)
{
 646:	711d                	addi	sp,sp,-96
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	1000                	addi	s0,sp,32
 64e:	e40c                	sd	a1,8(s0)
 650:	e810                	sd	a2,16(s0)
 652:	ec14                	sd	a3,24(s0)
 654:	f018                	sd	a4,32(s0)
 656:	f41c                	sd	a5,40(s0)
 658:	03043823          	sd	a6,48(s0)
 65c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 660:	00840613          	addi	a2,s0,8
 664:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 668:	85aa                	mv	a1,a0
 66a:	4505                	li	a0,1
 66c:	00000097          	auipc	ra,0x0
 670:	dce080e7          	jalr	-562(ra) # 43a <vprintf>
}
 674:	60e2                	ld	ra,24(sp)
 676:	6442                	ld	s0,16(sp)
 678:	6125                	addi	sp,sp,96
 67a:	8082                	ret

000000000000067c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67c:	1141                	addi	sp,sp,-16
 67e:	e422                	sd	s0,8(sp)
 680:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 682:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 686:	00000797          	auipc	a5,0x0
 68a:	19a7b783          	ld	a5,410(a5) # 820 <freep>
 68e:	a805                	j	6be <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 690:	4618                	lw	a4,8(a2)
 692:	9db9                	addw	a1,a1,a4
 694:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	6398                	ld	a4,0(a5)
 69a:	6318                	ld	a4,0(a4)
 69c:	fee53823          	sd	a4,-16(a0)
 6a0:	a091                	j	6e4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a2:	ff852703          	lw	a4,-8(a0)
 6a6:	9e39                	addw	a2,a2,a4
 6a8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6aa:	ff053703          	ld	a4,-16(a0)
 6ae:	e398                	sd	a4,0(a5)
 6b0:	a099                	j	6f6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	6398                	ld	a4,0(a5)
 6b4:	00e7e463          	bltu	a5,a4,6bc <free+0x40>
 6b8:	00e6ea63          	bltu	a3,a4,6cc <free+0x50>
{
 6bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6be:	fed7fae3          	bgeu	a5,a3,6b2 <free+0x36>
 6c2:	6398                	ld	a4,0(a5)
 6c4:	00e6e463          	bltu	a3,a4,6cc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c8:	fee7eae3          	bltu	a5,a4,6bc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6cc:	ff852583          	lw	a1,-8(a0)
 6d0:	6390                	ld	a2,0(a5)
 6d2:	02059713          	slli	a4,a1,0x20
 6d6:	9301                	srli	a4,a4,0x20
 6d8:	0712                	slli	a4,a4,0x4
 6da:	9736                	add	a4,a4,a3
 6dc:	fae60ae3          	beq	a2,a4,690 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e4:	4790                	lw	a2,8(a5)
 6e6:	02061713          	slli	a4,a2,0x20
 6ea:	9301                	srli	a4,a4,0x20
 6ec:	0712                	slli	a4,a4,0x4
 6ee:	973e                	add	a4,a4,a5
 6f0:	fae689e3          	beq	a3,a4,6a2 <free+0x26>
  } else
    p->s.ptr = bp;
 6f4:	e394                	sd	a3,0(a5)
  freep = p;
 6f6:	00000717          	auipc	a4,0x0
 6fa:	12f73523          	sd	a5,298(a4) # 820 <freep>
}
 6fe:	6422                	ld	s0,8(sp)
 700:	0141                	addi	sp,sp,16
 702:	8082                	ret

0000000000000704 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 704:	7139                	addi	sp,sp,-64
 706:	fc06                	sd	ra,56(sp)
 708:	f822                	sd	s0,48(sp)
 70a:	f426                	sd	s1,40(sp)
 70c:	f04a                	sd	s2,32(sp)
 70e:	ec4e                	sd	s3,24(sp)
 710:	e852                	sd	s4,16(sp)
 712:	e456                	sd	s5,8(sp)
 714:	e05a                	sd	s6,0(sp)
 716:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 718:	02051493          	slli	s1,a0,0x20
 71c:	9081                	srli	s1,s1,0x20
 71e:	04bd                	addi	s1,s1,15
 720:	8091                	srli	s1,s1,0x4
 722:	0014899b          	addiw	s3,s1,1
 726:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 728:	00000517          	auipc	a0,0x0
 72c:	0f853503          	ld	a0,248(a0) # 820 <freep>
 730:	c515                	beqz	a0,75c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 732:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 734:	4798                	lw	a4,8(a5)
 736:	02977f63          	bgeu	a4,s1,774 <malloc+0x70>
 73a:	8a4e                	mv	s4,s3
 73c:	0009871b          	sext.w	a4,s3
 740:	6685                	lui	a3,0x1
 742:	00d77363          	bgeu	a4,a3,748 <malloc+0x44>
 746:	6a05                	lui	s4,0x1
 748:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 74c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 750:	00000917          	auipc	s2,0x0
 754:	0d090913          	addi	s2,s2,208 # 820 <freep>
  if(p == (char*)-1)
 758:	5afd                	li	s5,-1
 75a:	a88d                	j	7cc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 75c:	00000797          	auipc	a5,0x0
 760:	0cc78793          	addi	a5,a5,204 # 828 <base>
 764:	00000717          	auipc	a4,0x0
 768:	0af73e23          	sd	a5,188(a4) # 820 <freep>
 76c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 772:	b7e1                	j	73a <malloc+0x36>
      if(p->s.size == nunits)
 774:	02e48b63          	beq	s1,a4,7aa <malloc+0xa6>
        p->s.size -= nunits;
 778:	4137073b          	subw	a4,a4,s3
 77c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77e:	1702                	slli	a4,a4,0x20
 780:	9301                	srli	a4,a4,0x20
 782:	0712                	slli	a4,a4,0x4
 784:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 786:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 78a:	00000717          	auipc	a4,0x0
 78e:	08a73b23          	sd	a0,150(a4) # 820 <freep>
      return (void*)(p + 1);
 792:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 796:	70e2                	ld	ra,56(sp)
 798:	7442                	ld	s0,48(sp)
 79a:	74a2                	ld	s1,40(sp)
 79c:	7902                	ld	s2,32(sp)
 79e:	69e2                	ld	s3,24(sp)
 7a0:	6a42                	ld	s4,16(sp)
 7a2:	6aa2                	ld	s5,8(sp)
 7a4:	6b02                	ld	s6,0(sp)
 7a6:	6121                	addi	sp,sp,64
 7a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7aa:	6398                	ld	a4,0(a5)
 7ac:	e118                	sd	a4,0(a0)
 7ae:	bff1                	j	78a <malloc+0x86>
  hp->s.size = nu;
 7b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b4:	0541                	addi	a0,a0,16
 7b6:	00000097          	auipc	ra,0x0
 7ba:	ec6080e7          	jalr	-314(ra) # 67c <free>
  return freep;
 7be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c2:	d971                	beqz	a0,796 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	fa9776e3          	bgeu	a4,s1,774 <malloc+0x70>
    if(p == freep)
 7cc:	00093703          	ld	a4,0(s2)
 7d0:	853e                	mv	a0,a5
 7d2:	fef719e3          	bne	a4,a5,7c4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7d6:	8552                	mv	a0,s4
 7d8:	00000097          	auipc	ra,0x0
 7dc:	b76080e7          	jalr	-1162(ra) # 34e <sbrk>
  if(p == (char*)-1)
 7e0:	fd5518e3          	bne	a0,s5,7b0 <malloc+0xac>
        return 0;
 7e4:	4501                	li	a0,0
 7e6:	bf45                	j	796 <malloc+0x92>
