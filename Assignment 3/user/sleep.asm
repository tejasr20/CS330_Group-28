
user/_sleep:     file format elf64-littleriscv


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
  int i;

  if (argc != 2) {
   8:	4789                	li	a5,2
   a:	02f50063          	beq	a0,a5,2a <main+0x2a>
     fprintf(2, "syntax: sleep n\nAborting...\n");
   e:	00001597          	auipc	a1,0x1
  12:	87258593          	addi	a1,a1,-1934 # 880 <malloc+0xe4>
  16:	4509                	li	a0,2
  18:	00000097          	auipc	ra,0x0
  1c:	698080e7          	jalr	1688(ra) # 6b0 <fprintf>
     exit(0);
  20:	4501                	li	a0,0
  22:	00000097          	auipc	ra,0x0
  26:	29a080e7          	jalr	666(ra) # 2bc <exit>
  }

  i = atoi(argv[1]);
  2a:	6588                	ld	a0,8(a1)
  2c:	00000097          	auipc	ra,0x0
  30:	190080e7          	jalr	400(ra) # 1bc <atoi>
  sleep(i);
  34:	00000097          	auipc	ra,0x0
  38:	318080e7          	jalr	792(ra) # 34c <sleep>

  exit(0);
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	27e080e7          	jalr	638(ra) # 2bc <exit>

0000000000000046 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	addi	a1,a1,1
  50:	0785                	addi	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0x8>
    ;
  return os;
}
  5c:	6422                	ld	s0,8(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	cb91                	beqz	a5,80 <strcmp+0x1e>
  6e:	0005c703          	lbu	a4,0(a1)
  72:	00f71763          	bne	a4,a5,80 <strcmp+0x1e>
    p++, q++;
  76:	0505                	addi	a0,a0,1
  78:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	fbe5                	bnez	a5,6e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  80:	0005c503          	lbu	a0,0(a1)
}
  84:	40a7853b          	subw	a0,a5,a0
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret

000000000000008e <strlen>:

uint
strlen(const char *s)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  94:	00054783          	lbu	a5,0(a0)
  98:	cf91                	beqz	a5,b4 <strlen+0x26>
  9a:	0505                	addi	a0,a0,1
  9c:	87aa                	mv	a5,a0
  9e:	4685                	li	a3,1
  a0:	9e89                	subw	a3,a3,a0
  a2:	00f6853b          	addw	a0,a3,a5
  a6:	0785                	addi	a5,a5,1
  a8:	fff7c703          	lbu	a4,-1(a5)
  ac:	fb7d                	bnez	a4,a2 <strlen+0x14>
    ;
  return n;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret
  for(n = 0; s[n]; n++)
  b4:	4501                	li	a0,0
  b6:	bfe5                	j	ae <strlen+0x20>

00000000000000b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  be:	ce09                	beqz	a2,d8 <memset+0x20>
  c0:	87aa                	mv	a5,a0
  c2:	fff6071b          	addiw	a4,a2,-1
  c6:	1702                	slli	a4,a4,0x20
  c8:	9301                	srli	a4,a4,0x20
  ca:	0705                	addi	a4,a4,1
  cc:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d2:	0785                	addi	a5,a5,1
  d4:	fee79de3          	bne	a5,a4,ce <memset+0x16>
  }
  return dst;
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strchr>:

char*
strchr(const char *s, char c)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cb99                	beqz	a5,fe <strchr+0x20>
    if(*s == c)
  ea:	00f58763          	beq	a1,a5,f8 <strchr+0x1a>
  for(; *s; s++)
  ee:	0505                	addi	a0,a0,1
  f0:	00054783          	lbu	a5,0(a0)
  f4:	fbfd                	bnez	a5,ea <strchr+0xc>
      return (char*)s;
  return 0;
  f6:	4501                	li	a0,0
}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  return 0;
  fe:	4501                	li	a0,0
 100:	bfe5                	j	f8 <strchr+0x1a>

0000000000000102 <gets>:

char*
gets(char *buf, int max)
{
 102:	711d                	addi	sp,sp,-96
 104:	ec86                	sd	ra,88(sp)
 106:	e8a2                	sd	s0,80(sp)
 108:	e4a6                	sd	s1,72(sp)
 10a:	e0ca                	sd	s2,64(sp)
 10c:	fc4e                	sd	s3,56(sp)
 10e:	f852                	sd	s4,48(sp)
 110:	f456                	sd	s5,40(sp)
 112:	f05a                	sd	s6,32(sp)
 114:	ec5e                	sd	s7,24(sp)
 116:	1080                	addi	s0,sp,96
 118:	8baa                	mv	s7,a0
 11a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 120:	4aa9                	li	s5,10
 122:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 124:	89a6                	mv	s3,s1
 126:	2485                	addiw	s1,s1,1
 128:	0344d863          	bge	s1,s4,158 <gets+0x56>
    cc = read(0, &c, 1);
 12c:	4605                	li	a2,1
 12e:	faf40593          	addi	a1,s0,-81
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	1a0080e7          	jalr	416(ra) # 2d4 <read>
    if(cc < 1)
 13c:	00a05e63          	blez	a0,158 <gets+0x56>
    buf[i++] = c;
 140:	faf44783          	lbu	a5,-81(s0)
 144:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 148:	01578763          	beq	a5,s5,156 <gets+0x54>
 14c:	0905                	addi	s2,s2,1
 14e:	fd679be3          	bne	a5,s6,124 <gets+0x22>
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	a011                	j	158 <gets+0x56>
 156:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 158:	99de                	add	s3,s3,s7
 15a:	00098023          	sb	zero,0(s3)
  return buf;
}
 15e:	855e                	mv	a0,s7
 160:	60e6                	ld	ra,88(sp)
 162:	6446                	ld	s0,80(sp)
 164:	64a6                	ld	s1,72(sp)
 166:	6906                	ld	s2,64(sp)
 168:	79e2                	ld	s3,56(sp)
 16a:	7a42                	ld	s4,48(sp)
 16c:	7aa2                	ld	s5,40(sp)
 16e:	7b02                	ld	s6,32(sp)
 170:	6be2                	ld	s7,24(sp)
 172:	6125                	addi	sp,sp,96
 174:	8082                	ret

0000000000000176 <stat>:

int
stat(const char *n, struct stat *st)
{
 176:	1101                	addi	sp,sp,-32
 178:	ec06                	sd	ra,24(sp)
 17a:	e822                	sd	s0,16(sp)
 17c:	e426                	sd	s1,8(sp)
 17e:	e04a                	sd	s2,0(sp)
 180:	1000                	addi	s0,sp,32
 182:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 184:	4581                	li	a1,0
 186:	00000097          	auipc	ra,0x0
 18a:	176080e7          	jalr	374(ra) # 2fc <open>
  if(fd < 0)
 18e:	02054563          	bltz	a0,1b8 <stat+0x42>
 192:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 194:	85ca                	mv	a1,s2
 196:	00000097          	auipc	ra,0x0
 19a:	17e080e7          	jalr	382(ra) # 314 <fstat>
 19e:	892a                	mv	s2,a0
  close(fd);
 1a0:	8526                	mv	a0,s1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	142080e7          	jalr	322(ra) # 2e4 <close>
  return r;
}
 1aa:	854a                	mv	a0,s2
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	64a2                	ld	s1,8(sp)
 1b2:	6902                	ld	s2,0(sp)
 1b4:	6105                	addi	sp,sp,32
 1b6:	8082                	ret
    return -1;
 1b8:	597d                	li	s2,-1
 1ba:	bfc5                	j	1aa <stat+0x34>

00000000000001bc <atoi>:

int
atoi(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e422                	sd	s0,8(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c2:	00054603          	lbu	a2,0(a0)
 1c6:	fd06079b          	addiw	a5,a2,-48
 1ca:	0ff7f793          	andi	a5,a5,255
 1ce:	4725                	li	a4,9
 1d0:	02f76963          	bltu	a4,a5,202 <atoi+0x46>
 1d4:	86aa                	mv	a3,a0
  n = 0;
 1d6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1d8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1da:	0685                	addi	a3,a3,1
 1dc:	0025179b          	slliw	a5,a0,0x2
 1e0:	9fa9                	addw	a5,a5,a0
 1e2:	0017979b          	slliw	a5,a5,0x1
 1e6:	9fb1                	addw	a5,a5,a2
 1e8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ec:	0006c603          	lbu	a2,0(a3)
 1f0:	fd06071b          	addiw	a4,a2,-48
 1f4:	0ff77713          	andi	a4,a4,255
 1f8:	fee5f1e3          	bgeu	a1,a4,1da <atoi+0x1e>
  return n;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  n = 0;
 202:	4501                	li	a0,0
 204:	bfe5                	j	1fc <atoi+0x40>

0000000000000206 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20c:	02b57663          	bgeu	a0,a1,238 <memmove+0x32>
    while(n-- > 0)
 210:	02c05163          	blez	a2,232 <memmove+0x2c>
 214:	fff6079b          	addiw	a5,a2,-1
 218:	1782                	slli	a5,a5,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	0785                	addi	a5,a5,1
 21e:	97aa                	add	a5,a5,a0
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	addi	a1,a1,1
 224:	0705                	addi	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x2c>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x4a>
 260:	bfc9                	j	232 <memmove+0x2c>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	00000097          	auipc	ra,0x0
 2a8:	f62080e7          	jalr	-158(ra) # 206 <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <yield>:
.global yield
yield:
 li a7, SYS_yield
 364:	48dd                	li	a7,23
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 36c:	48e1                	li	a7,24
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 374:	48e5                	li	a7,25
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 37c:	48e9                	li	a7,26
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <ps>:
.global ps
ps:
 li a7, SYS_ps
 384:	48ed                	li	a7,27
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 38c:	48f1                	li	a7,28
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 394:	48f5                	li	a7,29
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 39c:	48f9                	li	a7,30
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 3a4:	48fd                	li	a7,31
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 3ac:	02000893          	li	a7,32
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 3b6:	02100893          	li	a7,33
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 3c0:	02200893          	li	a7,34
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 3ca:	02300893          	li	a7,35
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 3d4:	02500893          	li	a7,37
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 3de:	02400893          	li	a7,36
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 3e8:	02600893          	li	a7,38
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 3f2:	02800893          	li	a7,40
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 3fc:	02700893          	li	a7,39
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	00000097          	auipc	ra,0x0
 41c:	ec4080e7          	jalr	-316(ra) # 2dc <write>
}
 420:	60e2                	ld	ra,24(sp)
 422:	6442                	ld	s0,16(sp)
 424:	6105                	addi	sp,sp,32
 426:	8082                	ret

0000000000000428 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 428:	7139                	addi	sp,sp,-64
 42a:	fc06                	sd	ra,56(sp)
 42c:	f822                	sd	s0,48(sp)
 42e:	f426                	sd	s1,40(sp)
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	0080                	addi	s0,sp,64
 436:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x16>
 43a:	0805c863          	bltz	a1,4ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43e:	2581                	sext.w	a1,a1
  neg = 0;
 440:	4881                	li	a7,0
 442:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	2601                	sext.w	a2,a2
 44a:	00000517          	auipc	a0,0x0
 44e:	45e50513          	addi	a0,a0,1118 # 8a8 <digits>
 452:	883a                	mv	a6,a4
 454:	2705                	addiw	a4,a4,1
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97aa                	add	a5,a5,a0
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	0005879b          	sext.w	a5,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fec7f0e3          	bgeu	a5,a2,452 <printint+0x2a>
  if(neg)
 476:	00088b63          	beqz	a7,48c <printint+0x64>
    buf[i++] = '-';
 47a:	fd040793          	addi	a5,s0,-48
 47e:	973e                	add	a4,a4,a5
 480:	02d00793          	li	a5,45
 484:	fef70823          	sb	a5,-16(a4)
 488:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48c:	02e05863          	blez	a4,4bc <printint+0x94>
 490:	fc040793          	addi	a5,s0,-64
 494:	00e78933          	add	s2,a5,a4
 498:	fff78993          	addi	s3,a5,-1
 49c:	99ba                	add	s3,s3,a4
 49e:	377d                	addiw	a4,a4,-1
 4a0:	1702                	slli	a4,a4,0x20
 4a2:	9301                	srli	a4,a4,0x20
 4a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a8:	fff94583          	lbu	a1,-1(s2)
 4ac:	8526                	mv	a0,s1
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f58080e7          	jalr	-168(ra) # 406 <putc>
  while(--i >= 0)
 4b6:	197d                	addi	s2,s2,-1
 4b8:	ff3918e3          	bne	s2,s3,4a8 <printint+0x80>
}
 4bc:	70e2                	ld	ra,56(sp)
 4be:	7442                	ld	s0,48(sp)
 4c0:	74a2                	ld	s1,40(sp)
 4c2:	7902                	ld	s2,32(sp)
 4c4:	69e2                	ld	s3,24(sp)
 4c6:	6121                	addi	sp,sp,64
 4c8:	8082                	ret
    x = -xx;
 4ca:	40b005bb          	negw	a1,a1
    neg = 1;
 4ce:	4885                	li	a7,1
    x = -xx;
 4d0:	bf8d                	j	442 <printint+0x1a>

00000000000004d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d2:	7119                	addi	sp,sp,-128
 4d4:	fc86                	sd	ra,120(sp)
 4d6:	f8a2                	sd	s0,112(sp)
 4d8:	f4a6                	sd	s1,104(sp)
 4da:	f0ca                	sd	s2,96(sp)
 4dc:	ecce                	sd	s3,88(sp)
 4de:	e8d2                	sd	s4,80(sp)
 4e0:	e4d6                	sd	s5,72(sp)
 4e2:	e0da                	sd	s6,64(sp)
 4e4:	fc5e                	sd	s7,56(sp)
 4e6:	f862                	sd	s8,48(sp)
 4e8:	f466                	sd	s9,40(sp)
 4ea:	f06a                	sd	s10,32(sp)
 4ec:	ec6e                	sd	s11,24(sp)
 4ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	18090f63          	beqz	s2,692 <vprintf+0x1c0>
 4f8:	8aaa                	mv	s5,a0
 4fa:	8b32                	mv	s6,a2
 4fc:	00158493          	addi	s1,a1,1
  state = 0;
 500:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 502:	02500a13          	li	s4,37
      if(c == 'd'){
 506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 50a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 50e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 512:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 516:	00000b97          	auipc	s7,0x0
 51a:	392b8b93          	addi	s7,s7,914 # 8a8 <digits>
 51e:	a839                	j	53c <vprintf+0x6a>
        putc(fd, c);
 520:	85ca                	mv	a1,s2
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	ee2080e7          	jalr	-286(ra) # 406 <putc>
 52c:	a019                	j	532 <vprintf+0x60>
    } else if(state == '%'){
 52e:	01498f63          	beq	s3,s4,54c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 532:	0485                	addi	s1,s1,1
 534:	fff4c903          	lbu	s2,-1(s1)
 538:	14090d63          	beqz	s2,692 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 53c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 540:	fe0997e3          	bnez	s3,52e <vprintf+0x5c>
      if(c == '%'){
 544:	fd479ee3          	bne	a5,s4,520 <vprintf+0x4e>
        state = '%';
 548:	89be                	mv	s3,a5
 54a:	b7e5                	j	532 <vprintf+0x60>
      if(c == 'd'){
 54c:	05878063          	beq	a5,s8,58c <vprintf+0xba>
      } else if(c == 'l') {
 550:	05978c63          	beq	a5,s9,5a8 <vprintf+0xd6>
      } else if(c == 'x') {
 554:	07a78863          	beq	a5,s10,5c4 <vprintf+0xf2>
      } else if(c == 'p') {
 558:	09b78463          	beq	a5,s11,5e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 55c:	07300713          	li	a4,115
 560:	0ce78663          	beq	a5,a4,62c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 564:	06300713          	li	a4,99
 568:	0ee78e63          	beq	a5,a4,664 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 56c:	11478863          	beq	a5,s4,67c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 570:	85d2                	mv	a1,s4
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e92080e7          	jalr	-366(ra) # 406 <putc>
        putc(fd, c);
 57c:	85ca                	mv	a1,s2
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e86080e7          	jalr	-378(ra) # 406 <putc>
      }
      state = 0;
 588:	4981                	li	s3,0
 58a:	b765                	j	532 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 58c:	008b0913          	addi	s2,s6,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000b2583          	lw	a1,0(s6)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e8e080e7          	jalr	-370(ra) # 428 <printint>
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b771                	j	532 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b0913          	addi	s2,s6,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000b2583          	lw	a1,0(s6)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e72080e7          	jalr	-398(ra) # 428 <printint>
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bf85                	j	532 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5c4:	008b0913          	addi	s2,s6,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000b2583          	lw	a1,0(s6)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e56080e7          	jalr	-426(ra) # 428 <printint>
 5da:	8b4a                	mv	s6,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bf91                	j	532 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e0:	008b0793          	addi	a5,s6,8
 5e4:	f8f43423          	sd	a5,-120(s0)
 5e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ec:	03000593          	li	a1,48
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e14080e7          	jalr	-492(ra) # 406 <putc>
  putc(fd, 'x');
 5fa:	85ea                	mv	a1,s10
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e08080e7          	jalr	-504(ra) # 406 <putc>
 606:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 608:	03c9d793          	srli	a5,s3,0x3c
 60c:	97de                	add	a5,a5,s7
 60e:	0007c583          	lbu	a1,0(a5)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	df2080e7          	jalr	-526(ra) # 406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61c:	0992                	slli	s3,s3,0x4
 61e:	397d                	addiw	s2,s2,-1
 620:	fe0914e3          	bnez	s2,608 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 624:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 628:	4981                	li	s3,0
 62a:	b721                	j	532 <vprintf+0x60>
        s = va_arg(ap, char*);
 62c:	008b0993          	addi	s3,s6,8
 630:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 634:	02090163          	beqz	s2,656 <vprintf+0x184>
        while(*s != 0){
 638:	00094583          	lbu	a1,0(s2)
 63c:	c9a1                	beqz	a1,68c <vprintf+0x1ba>
          putc(fd, *s);
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	dc6080e7          	jalr	-570(ra) # 406 <putc>
          s++;
 648:	0905                	addi	s2,s2,1
        while(*s != 0){
 64a:	00094583          	lbu	a1,0(s2)
 64e:	f9e5                	bnez	a1,63e <vprintf+0x16c>
        s = va_arg(ap, char*);
 650:	8b4e                	mv	s6,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	bdf9                	j	532 <vprintf+0x60>
          s = "(null)";
 656:	00000917          	auipc	s2,0x0
 65a:	24a90913          	addi	s2,s2,586 # 8a0 <malloc+0x104>
        while(*s != 0){
 65e:	02800593          	li	a1,40
 662:	bff1                	j	63e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 664:	008b0913          	addi	s2,s6,8
 668:	000b4583          	lbu	a1,0(s6)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	d98080e7          	jalr	-616(ra) # 406 <putc>
 676:	8b4a                	mv	s6,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	bd65                	j	532 <vprintf+0x60>
        putc(fd, c);
 67c:	85d2                	mv	a1,s4
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	d86080e7          	jalr	-634(ra) # 406 <putc>
      state = 0;
 688:	4981                	li	s3,0
 68a:	b565                	j	532 <vprintf+0x60>
        s = va_arg(ap, char*);
 68c:	8b4e                	mv	s6,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b54d                	j	532 <vprintf+0x60>
    }
  }
}
 692:	70e6                	ld	ra,120(sp)
 694:	7446                	ld	s0,112(sp)
 696:	74a6                	ld	s1,104(sp)
 698:	7906                	ld	s2,96(sp)
 69a:	69e6                	ld	s3,88(sp)
 69c:	6a46                	ld	s4,80(sp)
 69e:	6aa6                	ld	s5,72(sp)
 6a0:	6b06                	ld	s6,64(sp)
 6a2:	7be2                	ld	s7,56(sp)
 6a4:	7c42                	ld	s8,48(sp)
 6a6:	7ca2                	ld	s9,40(sp)
 6a8:	7d02                	ld	s10,32(sp)
 6aa:	6de2                	ld	s11,24(sp)
 6ac:	6109                	addi	sp,sp,128
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	addi	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	8622                	mv	a2,s0
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e04080e7          	jalr	-508(ra) # 4d2 <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <printf>:

void
printf(const char *fmt, ...)
{
 6de:	711d                	addi	sp,sp,-96
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e40c                	sd	a1,8(s0)
 6e8:	e810                	sd	a2,16(s0)
 6ea:	ec14                	sd	a3,24(s0)
 6ec:	f018                	sd	a4,32(s0)
 6ee:	f41c                	sd	a5,40(s0)
 6f0:	03043823          	sd	a6,48(s0)
 6f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	00840613          	addi	a2,s0,8
 6fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 700:	85aa                	mv	a1,a0
 702:	4505                	li	a0,1
 704:	00000097          	auipc	ra,0x0
 708:	dce080e7          	jalr	-562(ra) # 4d2 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	1141                	addi	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	00000797          	auipc	a5,0x0
 722:	1a27b783          	ld	a5,418(a5) # 8c0 <freep>
 726:	a805                	j	756 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 728:	4618                	lw	a4,8(a2)
 72a:	9db9                	addw	a1,a1,a4
 72c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	6398                	ld	a4,0(a5)
 732:	6318                	ld	a4,0(a4)
 734:	fee53823          	sd	a4,-16(a0)
 738:	a091                	j	77c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73a:	ff852703          	lw	a4,-8(a0)
 73e:	9e39                	addw	a2,a2,a4
 740:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 742:	ff053703          	ld	a4,-16(a0)
 746:	e398                	sd	a4,0(a5)
 748:	a099                	j	78e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74a:	6398                	ld	a4,0(a5)
 74c:	00e7e463          	bltu	a5,a4,754 <free+0x40>
 750:	00e6ea63          	bltu	a3,a4,764 <free+0x50>
{
 754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	fed7fae3          	bgeu	a5,a3,74a <free+0x36>
 75a:	6398                	ld	a4,0(a5)
 75c:	00e6e463          	bltu	a3,a4,764 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	fee7eae3          	bltu	a5,a4,754 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 764:	ff852583          	lw	a1,-8(a0)
 768:	6390                	ld	a2,0(a5)
 76a:	02059713          	slli	a4,a1,0x20
 76e:	9301                	srli	a4,a4,0x20
 770:	0712                	slli	a4,a4,0x4
 772:	9736                	add	a4,a4,a3
 774:	fae60ae3          	beq	a2,a4,728 <free+0x14>
    bp->s.ptr = p->s.ptr;
 778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77c:	4790                	lw	a2,8(a5)
 77e:	02061713          	slli	a4,a2,0x20
 782:	9301                	srli	a4,a4,0x20
 784:	0712                	slli	a4,a4,0x4
 786:	973e                	add	a4,a4,a5
 788:	fae689e3          	beq	a3,a4,73a <free+0x26>
  } else
    p->s.ptr = bp;
 78c:	e394                	sd	a3,0(a5)
  freep = p;
 78e:	00000717          	auipc	a4,0x0
 792:	12f73923          	sd	a5,306(a4) # 8c0 <freep>
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	ec4e                	sd	s3,24(sp)
 7a8:	e852                	sd	s4,16(sp)
 7aa:	e456                	sd	s5,8(sp)
 7ac:	e05a                	sd	s6,0(sp)
 7ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b0:	02051493          	slli	s1,a0,0x20
 7b4:	9081                	srli	s1,s1,0x20
 7b6:	04bd                	addi	s1,s1,15
 7b8:	8091                	srli	s1,s1,0x4
 7ba:	0014899b          	addiw	s3,s1,1
 7be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c0:	00000517          	auipc	a0,0x0
 7c4:	10053503          	ld	a0,256(a0) # 8c0 <freep>
 7c8:	c515                	beqz	a0,7f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	02977f63          	bgeu	a4,s1,80c <malloc+0x70>
 7d2:	8a4e                	mv	s4,s3
 7d4:	0009871b          	sext.w	a4,s3
 7d8:	6685                	lui	a3,0x1
 7da:	00d77363          	bgeu	a4,a3,7e0 <malloc+0x44>
 7de:	6a05                	lui	s4,0x1
 7e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e8:	00000917          	auipc	s2,0x0
 7ec:	0d890913          	addi	s2,s2,216 # 8c0 <freep>
  if(p == (char*)-1)
 7f0:	5afd                	li	s5,-1
 7f2:	a88d                	j	864 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7f4:	00000797          	auipc	a5,0x0
 7f8:	0d478793          	addi	a5,a5,212 # 8c8 <base>
 7fc:	00000717          	auipc	a4,0x0
 800:	0cf73223          	sd	a5,196(a4) # 8c0 <freep>
 804:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 806:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80a:	b7e1                	j	7d2 <malloc+0x36>
      if(p->s.size == nunits)
 80c:	02e48b63          	beq	s1,a4,842 <malloc+0xa6>
        p->s.size -= nunits;
 810:	4137073b          	subw	a4,a4,s3
 814:	c798                	sw	a4,8(a5)
        p += p->s.size;
 816:	1702                	slli	a4,a4,0x20
 818:	9301                	srli	a4,a4,0x20
 81a:	0712                	slli	a4,a4,0x4
 81c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 822:	00000717          	auipc	a4,0x0
 826:	08a73f23          	sd	a0,158(a4) # 8c0 <freep>
      return (void*)(p + 1);
 82a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82e:	70e2                	ld	ra,56(sp)
 830:	7442                	ld	s0,48(sp)
 832:	74a2                	ld	s1,40(sp)
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	e118                	sd	a4,0(a0)
 846:	bff1                	j	822 <malloc+0x86>
  hp->s.size = nu;
 848:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84c:	0541                	addi	a0,a0,16
 84e:	00000097          	auipc	ra,0x0
 852:	ec6080e7          	jalr	-314(ra) # 714 <free>
  return freep;
 856:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 85a:	d971                	beqz	a0,82e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	fa9776e3          	bgeu	a4,s1,80c <malloc+0x70>
    if(p == freep)
 864:	00093703          	ld	a4,0(s2)
 868:	853e                	mv	a0,a5
 86a:	fef719e3          	bne	a4,a5,85c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 86e:	8552                	mv	a0,s4
 870:	00000097          	auipc	ra,0x0
 874:	ad4080e7          	jalr	-1324(ra) # 344 <sbrk>
  if(p == (char*)-1)
 878:	fd5518e3          	bne	a0,s5,848 <malloc+0xac>
        return 0;
 87c:	4501                	li	a0,0
 87e:	bf45                	j	82e <malloc+0x92>
