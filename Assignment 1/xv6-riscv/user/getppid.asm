
user/_getppid:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    int pid,ppid;
    pid=getpid();
   a:	00000097          	auipc	ra,0x0
   e:	37c080e7          	jalr	892(ra) # 386 <getpid>
  12:	84aa                	mv	s1,a0
    fprintf(1,"BEFORE FORK: The pid is: %d\n",pid);
  14:	862a                	mv	a2,a0
  16:	00001597          	auipc	a1,0x1
  1a:	81258593          	addi	a1,a1,-2030 # 828 <malloc+0xe4>
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	638080e7          	jalr	1592(ra) # 658 <fprintf>

    if(fork()==0)
  28:	00000097          	auipc	ra,0x0
  2c:	2d6080e7          	jalr	726(ra) # 2fe <fork>
  30:	e91d                	bnez	a0,66 <main+0x66>
    {
        pid=getpid();
  32:	00000097          	auipc	ra,0x0
  36:	354080e7          	jalr	852(ra) # 386 <getpid>
  3a:	84aa                	mv	s1,a0
        ppid=getppid();
  3c:	00000097          	auipc	ra,0x0
  40:	36a080e7          	jalr	874(ra) # 3a6 <getppid>
  44:	86aa                	mv	a3,a0
        fprintf(1,"CHILD: The pid is: %d and ppid is: %d\n",pid,ppid);
  46:	8626                	mv	a2,s1
  48:	00001597          	auipc	a1,0x1
  4c:	80058593          	addi	a1,a1,-2048 # 848 <malloc+0x104>
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	606080e7          	jalr	1542(ra) # 658 <fprintf>
        wait(0);
        ppid=getppid();
        fprintf(1,"PARENT: The pid is: %d and ppid is: %d\n",pid,ppid);
    }
    return 0;
  5a:	4501                	li	a0,0
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6105                	addi	sp,sp,32
  64:	8082                	ret
        wait(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	2a6080e7          	jalr	678(ra) # 30e <wait>
        ppid=getppid();
  70:	00000097          	auipc	ra,0x0
  74:	336080e7          	jalr	822(ra) # 3a6 <getppid>
  78:	86aa                	mv	a3,a0
        fprintf(1,"PARENT: The pid is: %d and ppid is: %d\n",pid,ppid);
  7a:	8626                	mv	a2,s1
  7c:	00000597          	auipc	a1,0x0
  80:	7f458593          	addi	a1,a1,2036 # 870 <malloc+0x12c>
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	5d2080e7          	jalr	1490(ra) # 658 <fprintf>
  8e:	b7f1                	j	5a <main+0x5a>

0000000000000090 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0x8>
    ;
  return os;
}
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cb91                	beqz	a5,ca <strcmp+0x1e>
  b8:	0005c703          	lbu	a4,0(a1)
  bc:	00f71763          	bne	a4,a5,ca <strcmp+0x1e>
    p++, q++;
  c0:	0505                	addi	a0,a0,1
  c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	fbe5                	bnez	a5,b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ca:	0005c503          	lbu	a0,0(a1)
}
  ce:	40a7853b          	subw	a0,a5,a0
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strlen>:

uint
strlen(const char *s)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cf91                	beqz	a5,fe <strlen+0x26>
  e4:	0505                	addi	a0,a0,1
  e6:	87aa                	mv	a5,a0
  e8:	4685                	li	a3,1
  ea:	9e89                	subw	a3,a3,a0
  ec:	00f6853b          	addw	a0,a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	fb7d                	bnez	a4,ec <strlen+0x14>
    ;
  return n;
}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  for(n = 0; s[n]; n++)
  fe:	4501                	li	a0,0
 100:	bfe5                	j	f8 <strlen+0x20>

0000000000000102 <memset>:

void*
memset(void *dst, int c, uint n)
{
 102:	1141                	addi	sp,sp,-16
 104:	e422                	sd	s0,8(sp)
 106:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 108:	ce09                	beqz	a2,122 <memset+0x20>
 10a:	87aa                	mv	a5,a0
 10c:	fff6071b          	addiw	a4,a2,-1
 110:	1702                	slli	a4,a4,0x20
 112:	9301                	srli	a4,a4,0x20
 114:	0705                	addi	a4,a4,1
 116:	972a                	add	a4,a4,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x16>
  }
  return dst;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb99                	beqz	a5,148 <strchr+0x20>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1a>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xc>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strchr+0x1a>

000000000000014c <gets>:

char*
gets(char *buf, int max)
{
 14c:	711d                	addi	sp,sp,-96
 14e:	ec86                	sd	ra,88(sp)
 150:	e8a2                	sd	s0,80(sp)
 152:	e4a6                	sd	s1,72(sp)
 154:	e0ca                	sd	s2,64(sp)
 156:	fc4e                	sd	s3,56(sp)
 158:	f852                	sd	s4,48(sp)
 15a:	f456                	sd	s5,40(sp)
 15c:	f05a                	sd	s6,32(sp)
 15e:	ec5e                	sd	s7,24(sp)
 160:	1080                	addi	s0,sp,96
 162:	8baa                	mv	s7,a0
 164:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	892a                	mv	s2,a0
 168:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4aa9                	li	s5,10
 16c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	2485                	addiw	s1,s1,1
 172:	0344d863          	bge	s1,s4,1a2 <gets+0x56>
    cc = read(0, &c, 1);
 176:	4605                	li	a2,1
 178:	faf40593          	addi	a1,s0,-81
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	1a0080e7          	jalr	416(ra) # 31e <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x56>
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01578763          	beq	a5,s5,1a0 <gets+0x54>
 196:	0905                	addi	s2,s2,1
 198:	fd679be3          	bne	a5,s6,16e <gets+0x22>
  for(i=0; i+1 < max; ){
 19c:	89a6                	mv	s3,s1
 19e:	a011                	j	1a2 <gets+0x56>
 1a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a2:	99de                	add	s3,s3,s7
 1a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a8:	855e                	mv	a0,s7
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e426                	sd	s1,8(sp)
 1c8:	e04a                	sd	s2,0(sp)
 1ca:	1000                	addi	s0,sp,32
 1cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ce:	4581                	li	a1,0
 1d0:	00000097          	auipc	ra,0x0
 1d4:	176080e7          	jalr	374(ra) # 346 <open>
  if(fd < 0)
 1d8:	02054563          	bltz	a0,202 <stat+0x42>
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	17e080e7          	jalr	382(ra) # 35e <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	142080e7          	jalr	322(ra) # 32e <close>
  return r;
}
 1f4:	854a                	mv	a0,s2
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	64a2                	ld	s1,8(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	597d                	li	s2,-1
 204:	bfc5                	j	1f4 <stat+0x34>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20c:	00054603          	lbu	a2,0(a0)
 210:	fd06079b          	addiw	a5,a2,-48
 214:	0ff7f793          	andi	a5,a5,255
 218:	4725                	li	a4,9
 21a:	02f76963          	bltu	a4,a5,24c <atoi+0x46>
 21e:	86aa                	mv	a3,a0
  n = 0;
 220:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 222:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 224:	0685                	addi	a3,a3,1
 226:	0025179b          	slliw	a5,a0,0x2
 22a:	9fa9                	addw	a5,a5,a0
 22c:	0017979b          	slliw	a5,a5,0x1
 230:	9fb1                	addw	a5,a5,a2
 232:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 236:	0006c603          	lbu	a2,0(a3)
 23a:	fd06071b          	addiw	a4,a2,-48
 23e:	0ff77713          	andi	a4,a4,255
 242:	fee5f1e3          	bgeu	a1,a4,224 <atoi+0x1e>
  return n;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret
  n = 0;
 24c:	4501                	li	a0,0
 24e:	bfe5                	j	246 <atoi+0x40>

0000000000000250 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 256:	02b57663          	bgeu	a0,a1,282 <memmove+0x32>
    while(n-- > 0)
 25a:	02c05163          	blez	a2,27c <memmove+0x2c>
 25e:	fff6079b          	addiw	a5,a2,-1
 262:	1782                	slli	a5,a5,0x20
 264:	9381                	srli	a5,a5,0x20
 266:	0785                	addi	a5,a5,1
 268:	97aa                	add	a5,a5,a0
  dst = vdst;
 26a:	872a                	mv	a4,a0
      *dst++ = *src++;
 26c:	0585                	addi	a1,a1,1
 26e:	0705                	addi	a4,a4,1
 270:	fff5c683          	lbu	a3,-1(a1)
 274:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 278:	fee79ae3          	bne	a5,a4,26c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
    dst += n;
 282:	00c50733          	add	a4,a0,a2
    src += n;
 286:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 288:	fec05ae3          	blez	a2,27c <memmove+0x2c>
 28c:	fff6079b          	addiw	a5,a2,-1
 290:	1782                	slli	a5,a5,0x20
 292:	9381                	srli	a5,a5,0x20
 294:	fff7c793          	not	a5,a5
 298:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29a:	15fd                	addi	a1,a1,-1
 29c:	177d                	addi	a4,a4,-1
 29e:	0005c683          	lbu	a3,0(a1)
 2a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x4a>
 2aa:	bfc9                	j	27c <memmove+0x2c>

00000000000002ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca05                	beqz	a2,2e2 <memcmp+0x36>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x14>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x30>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <memcmp+0x30>

00000000000002e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ee:	00000097          	auipc	ra,0x0
 2f2:	f62080e7          	jalr	-158(ra) # 250 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fe:	4885                	li	a7,1
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exit>:
.global exit
exit:
 li a7, SYS_exit
 306:	4889                	li	a7,2
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <wait>:
.global wait
wait:
 li a7, SYS_wait
 30e:	488d                	li	a7,3
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 316:	4891                	li	a7,4
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <read>:
.global read
read:
 li a7, SYS_read
 31e:	4895                	li	a7,5
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <write>:
.global write
write:
 li a7, SYS_write
 326:	48c1                	li	a7,16
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <close>:
.global close
close:
 li a7, SYS_close
 32e:	48d5                	li	a7,21
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <kill>:
.global kill
kill:
 li a7, SYS_kill
 336:	4899                	li	a7,6
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exec>:
.global exec
exec:
 li a7, SYS_exec
 33e:	489d                	li	a7,7
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <open>:
.global open
open:
 li a7, SYS_open
 346:	48bd                	li	a7,15
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34e:	48c5                	li	a7,17
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 356:	48c9                	li	a7,18
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35e:	48a1                	li	a7,8
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <link>:
.global link
link:
 li a7, SYS_link
 366:	48cd                	li	a7,19
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36e:	48d1                	li	a7,20
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 376:	48a5                	li	a7,9
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dup>:
.global dup
dup:
 li a7, SYS_dup
 37e:	48a9                	li	a7,10
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 386:	48ad                	li	a7,11
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38e:	48b1                	li	a7,12
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 396:	48b5                	li	a7,13
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39e:	48b9                	li	a7,14
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3a6:	48d9                	li	a7,22
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	00000097          	auipc	ra,0x0
 3c4:	f66080e7          	jalr	-154(ra) # 326 <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f426                	sd	s1,40(sp)
 3d8:	f04a                	sd	s2,32(sp)
 3da:	ec4e                	sd	s3,24(sp)
 3dc:	0080                	addi	s0,sp,64
 3de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	c299                	beqz	a3,3e6 <printint+0x16>
 3e2:	0805c863          	bltz	a1,472 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e6:	2581                	sext.w	a1,a1
  neg = 0;
 3e8:	4881                	li	a7,0
 3ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f0:	2601                	sext.w	a2,a2
 3f2:	00000517          	auipc	a0,0x0
 3f6:	4ae50513          	addi	a0,a0,1198 # 8a0 <digits>
 3fa:	883a                	mv	a6,a4
 3fc:	2705                	addiw	a4,a4,1
 3fe:	02c5f7bb          	remuw	a5,a1,a2
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	97aa                	add	a5,a5,a0
 408:	0007c783          	lbu	a5,0(a5)
 40c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 410:	0005879b          	sext.w	a5,a1
 414:	02c5d5bb          	divuw	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fec7f0e3          	bgeu	a5,a2,3fa <printint+0x2a>
  if(neg)
 41e:	00088b63          	beqz	a7,434 <printint+0x64>
    buf[i++] = '-';
 422:	fd040793          	addi	a5,s0,-48
 426:	973e                	add	a4,a4,a5
 428:	02d00793          	li	a5,45
 42c:	fef70823          	sb	a5,-16(a4)
 430:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 434:	02e05863          	blez	a4,464 <printint+0x94>
 438:	fc040793          	addi	a5,s0,-64
 43c:	00e78933          	add	s2,a5,a4
 440:	fff78993          	addi	s3,a5,-1
 444:	99ba                	add	s3,s3,a4
 446:	377d                	addiw	a4,a4,-1
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	fff94583          	lbu	a1,-1(s2)
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	f58080e7          	jalr	-168(ra) # 3ae <putc>
  while(--i >= 0)
 45e:	197d                	addi	s2,s2,-1
 460:	ff3918e3          	bne	s2,s3,450 <printint+0x80>
}
 464:	70e2                	ld	ra,56(sp)
 466:	7442                	ld	s0,48(sp)
 468:	74a2                	ld	s1,40(sp)
 46a:	7902                	ld	s2,32(sp)
 46c:	69e2                	ld	s3,24(sp)
 46e:	6121                	addi	sp,sp,64
 470:	8082                	ret
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4885                	li	a7,1
    x = -xx;
 478:	bf8d                	j	3ea <printint+0x1a>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	7119                	addi	sp,sp,-128
 47c:	fc86                	sd	ra,120(sp)
 47e:	f8a2                	sd	s0,112(sp)
 480:	f4a6                	sd	s1,104(sp)
 482:	f0ca                	sd	s2,96(sp)
 484:	ecce                	sd	s3,88(sp)
 486:	e8d2                	sd	s4,80(sp)
 488:	e4d6                	sd	s5,72(sp)
 48a:	e0da                	sd	s6,64(sp)
 48c:	fc5e                	sd	s7,56(sp)
 48e:	f862                	sd	s8,48(sp)
 490:	f466                	sd	s9,40(sp)
 492:	f06a                	sd	s10,32(sp)
 494:	ec6e                	sd	s11,24(sp)
 496:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 498:	0005c903          	lbu	s2,0(a1)
 49c:	18090f63          	beqz	s2,63a <vprintf+0x1c0>
 4a0:	8aaa                	mv	s5,a0
 4a2:	8b32                	mv	s6,a2
 4a4:	00158493          	addi	s1,a1,1
  state = 0;
 4a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4aa:	02500a13          	li	s4,37
      if(c == 'd'){
 4ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4b2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4b6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ba:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4be:	00000b97          	auipc	s7,0x0
 4c2:	3e2b8b93          	addi	s7,s7,994 # 8a0 <digits>
 4c6:	a839                	j	4e4 <vprintf+0x6a>
        putc(fd, c);
 4c8:	85ca                	mv	a1,s2
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ee2080e7          	jalr	-286(ra) # 3ae <putc>
 4d4:	a019                	j	4da <vprintf+0x60>
    } else if(state == '%'){
 4d6:	01498f63          	beq	s3,s4,4f4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4da:	0485                	addi	s1,s1,1
 4dc:	fff4c903          	lbu	s2,-1(s1)
 4e0:	14090d63          	beqz	s2,63a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e8:	fe0997e3          	bnez	s3,4d6 <vprintf+0x5c>
      if(c == '%'){
 4ec:	fd479ee3          	bne	a5,s4,4c8 <vprintf+0x4e>
        state = '%';
 4f0:	89be                	mv	s3,a5
 4f2:	b7e5                	j	4da <vprintf+0x60>
      if(c == 'd'){
 4f4:	05878063          	beq	a5,s8,534 <vprintf+0xba>
      } else if(c == 'l') {
 4f8:	05978c63          	beq	a5,s9,550 <vprintf+0xd6>
      } else if(c == 'x') {
 4fc:	07a78863          	beq	a5,s10,56c <vprintf+0xf2>
      } else if(c == 'p') {
 500:	09b78463          	beq	a5,s11,588 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 504:	07300713          	li	a4,115
 508:	0ce78663          	beq	a5,a4,5d4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50c:	06300713          	li	a4,99
 510:	0ee78e63          	beq	a5,a4,60c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 514:	11478863          	beq	a5,s4,624 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 518:	85d2                	mv	a1,s4
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e92080e7          	jalr	-366(ra) # 3ae <putc>
        putc(fd, c);
 524:	85ca                	mv	a1,s2
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e86080e7          	jalr	-378(ra) # 3ae <putc>
      }
      state = 0;
 530:	4981                	li	s3,0
 532:	b765                	j	4da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b0913          	addi	s2,s6,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000b2583          	lw	a1,0(s6)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e8e080e7          	jalr	-370(ra) # 3d0 <printint>
 54a:	8b4a                	mv	s6,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b771                	j	4da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	008b0913          	addi	s2,s6,8
 554:	4681                	li	a3,0
 556:	4629                	li	a2,10
 558:	000b2583          	lw	a1,0(s6)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e72080e7          	jalr	-398(ra) # 3d0 <printint>
 566:	8b4a                	mv	s6,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	bf85                	j	4da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 56c:	008b0913          	addi	s2,s6,8
 570:	4681                	li	a3,0
 572:	4641                	li	a2,16
 574:	000b2583          	lw	a1,0(s6)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e56080e7          	jalr	-426(ra) # 3d0 <printint>
 582:	8b4a                	mv	s6,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	bf91                	j	4da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 588:	008b0793          	addi	a5,s6,8
 58c:	f8f43423          	sd	a5,-120(s0)
 590:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 594:	03000593          	li	a1,48
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e14080e7          	jalr	-492(ra) # 3ae <putc>
  putc(fd, 'x');
 5a2:	85ea                	mv	a1,s10
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e08080e7          	jalr	-504(ra) # 3ae <putc>
 5ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b0:	03c9d793          	srli	a5,s3,0x3c
 5b4:	97de                	add	a5,a5,s7
 5b6:	0007c583          	lbu	a1,0(a5)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	df2080e7          	jalr	-526(ra) # 3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c4:	0992                	slli	s3,s3,0x4
 5c6:	397d                	addiw	s2,s2,-1
 5c8:	fe0914e3          	bnez	s2,5b0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5cc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b721                	j	4da <vprintf+0x60>
        s = va_arg(ap, char*);
 5d4:	008b0993          	addi	s3,s6,8
 5d8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5dc:	02090163          	beqz	s2,5fe <vprintf+0x184>
        while(*s != 0){
 5e0:	00094583          	lbu	a1,0(s2)
 5e4:	c9a1                	beqz	a1,634 <vprintf+0x1ba>
          putc(fd, *s);
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	dc6080e7          	jalr	-570(ra) # 3ae <putc>
          s++;
 5f0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5f2:	00094583          	lbu	a1,0(s2)
 5f6:	f9e5                	bnez	a1,5e6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5f8:	8b4e                	mv	s6,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bdf9                	j	4da <vprintf+0x60>
          s = "(null)";
 5fe:	00000917          	auipc	s2,0x0
 602:	29a90913          	addi	s2,s2,666 # 898 <malloc+0x154>
        while(*s != 0){
 606:	02800593          	li	a1,40
 60a:	bff1                	j	5e6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 60c:	008b0913          	addi	s2,s6,8
 610:	000b4583          	lbu	a1,0(s6)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	d98080e7          	jalr	-616(ra) # 3ae <putc>
 61e:	8b4a                	mv	s6,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	bd65                	j	4da <vprintf+0x60>
        putc(fd, c);
 624:	85d2                	mv	a1,s4
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d86080e7          	jalr	-634(ra) # 3ae <putc>
      state = 0;
 630:	4981                	li	s3,0
 632:	b565                	j	4da <vprintf+0x60>
        s = va_arg(ap, char*);
 634:	8b4e                	mv	s6,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	b54d                	j	4da <vprintf+0x60>
    }
  }
}
 63a:	70e6                	ld	ra,120(sp)
 63c:	7446                	ld	s0,112(sp)
 63e:	74a6                	ld	s1,104(sp)
 640:	7906                	ld	s2,96(sp)
 642:	69e6                	ld	s3,88(sp)
 644:	6a46                	ld	s4,80(sp)
 646:	6aa6                	ld	s5,72(sp)
 648:	6b06                	ld	s6,64(sp)
 64a:	7be2                	ld	s7,56(sp)
 64c:	7c42                	ld	s8,48(sp)
 64e:	7ca2                	ld	s9,40(sp)
 650:	7d02                	ld	s10,32(sp)
 652:	6de2                	ld	s11,24(sp)
 654:	6109                	addi	sp,sp,128
 656:	8082                	ret

0000000000000658 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 658:	715d                	addi	sp,sp,-80
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e010                	sd	a2,0(s0)
 662:	e414                	sd	a3,8(s0)
 664:	e818                	sd	a4,16(s0)
 666:	ec1c                	sd	a5,24(s0)
 668:	03043023          	sd	a6,32(s0)
 66c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 670:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 674:	8622                	mv	a2,s0
 676:	00000097          	auipc	ra,0x0
 67a:	e04080e7          	jalr	-508(ra) # 47a <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6161                	addi	sp,sp,80
 684:	8082                	ret

0000000000000686 <printf>:

void
printf(const char *fmt, ...)
{
 686:	711d                	addi	sp,sp,-96
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e40c                	sd	a1,8(s0)
 690:	e810                	sd	a2,16(s0)
 692:	ec14                	sd	a3,24(s0)
 694:	f018                	sd	a4,32(s0)
 696:	f41c                	sd	a5,40(s0)
 698:	03043823          	sd	a6,48(s0)
 69c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a0:	00840613          	addi	a2,s0,8
 6a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a8:	85aa                	mv	a1,a0
 6aa:	4505                	li	a0,1
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dce080e7          	jalr	-562(ra) # 47a <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6125                	addi	sp,sp,96
 6ba:	8082                	ret

00000000000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	00000797          	auipc	a5,0x0
 6ca:	1f27b783          	ld	a5,498(a5) # 8b8 <freep>
 6ce:	a805                	j	6fe <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d0:	4618                	lw	a4,8(a2)
 6d2:	9db9                	addw	a1,a1,a4
 6d4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d8:	6398                	ld	a4,0(a5)
 6da:	6318                	ld	a4,0(a4)
 6dc:	fee53823          	sd	a4,-16(a0)
 6e0:	a091                	j	724 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e2:	ff852703          	lw	a4,-8(a0)
 6e6:	9e39                	addw	a2,a2,a4
 6e8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ea:	ff053703          	ld	a4,-16(a0)
 6ee:	e398                	sd	a4,0(a5)
 6f0:	a099                	j	736 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	6398                	ld	a4,0(a5)
 6f4:	00e7e463          	bltu	a5,a4,6fc <free+0x40>
 6f8:	00e6ea63          	bltu	a3,a4,70c <free+0x50>
{
 6fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	fed7fae3          	bgeu	a5,a3,6f2 <free+0x36>
 702:	6398                	ld	a4,0(a5)
 704:	00e6e463          	bltu	a3,a4,70c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	fee7eae3          	bltu	a5,a4,6fc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 70c:	ff852583          	lw	a1,-8(a0)
 710:	6390                	ld	a2,0(a5)
 712:	02059713          	slli	a4,a1,0x20
 716:	9301                	srli	a4,a4,0x20
 718:	0712                	slli	a4,a4,0x4
 71a:	9736                	add	a4,a4,a3
 71c:	fae60ae3          	beq	a2,a4,6d0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 720:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 724:	4790                	lw	a2,8(a5)
 726:	02061713          	slli	a4,a2,0x20
 72a:	9301                	srli	a4,a4,0x20
 72c:	0712                	slli	a4,a4,0x4
 72e:	973e                	add	a4,a4,a5
 730:	fae689e3          	beq	a3,a4,6e2 <free+0x26>
  } else
    p->s.ptr = bp;
 734:	e394                	sd	a3,0(a5)
  freep = p;
 736:	00000717          	auipc	a4,0x0
 73a:	18f73123          	sd	a5,386(a4) # 8b8 <freep>
}
 73e:	6422                	ld	s0,8(sp)
 740:	0141                	addi	sp,sp,16
 742:	8082                	ret

0000000000000744 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 744:	7139                	addi	sp,sp,-64
 746:	fc06                	sd	ra,56(sp)
 748:	f822                	sd	s0,48(sp)
 74a:	f426                	sd	s1,40(sp)
 74c:	f04a                	sd	s2,32(sp)
 74e:	ec4e                	sd	s3,24(sp)
 750:	e852                	sd	s4,16(sp)
 752:	e456                	sd	s5,8(sp)
 754:	e05a                	sd	s6,0(sp)
 756:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	02051493          	slli	s1,a0,0x20
 75c:	9081                	srli	s1,s1,0x20
 75e:	04bd                	addi	s1,s1,15
 760:	8091                	srli	s1,s1,0x4
 762:	0014899b          	addiw	s3,s1,1
 766:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 768:	00000517          	auipc	a0,0x0
 76c:	15053503          	ld	a0,336(a0) # 8b8 <freep>
 770:	c515                	beqz	a0,79c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 774:	4798                	lw	a4,8(a5)
 776:	02977f63          	bgeu	a4,s1,7b4 <malloc+0x70>
 77a:	8a4e                	mv	s4,s3
 77c:	0009871b          	sext.w	a4,s3
 780:	6685                	lui	a3,0x1
 782:	00d77363          	bgeu	a4,a3,788 <malloc+0x44>
 786:	6a05                	lui	s4,0x1
 788:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 78c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 790:	00000917          	auipc	s2,0x0
 794:	12890913          	addi	s2,s2,296 # 8b8 <freep>
  if(p == (char*)-1)
 798:	5afd                	li	s5,-1
 79a:	a88d                	j	80c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 79c:	00000797          	auipc	a5,0x0
 7a0:	12478793          	addi	a5,a5,292 # 8c0 <base>
 7a4:	00000717          	auipc	a4,0x0
 7a8:	10f73a23          	sd	a5,276(a4) # 8b8 <freep>
 7ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b2:	b7e1                	j	77a <malloc+0x36>
      if(p->s.size == nunits)
 7b4:	02e48b63          	beq	s1,a4,7ea <malloc+0xa6>
        p->s.size -= nunits;
 7b8:	4137073b          	subw	a4,a4,s3
 7bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7be:	1702                	slli	a4,a4,0x20
 7c0:	9301                	srli	a4,a4,0x20
 7c2:	0712                	slli	a4,a4,0x4
 7c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ca:	00000717          	auipc	a4,0x0
 7ce:	0ea73723          	sd	a0,238(a4) # 8b8 <freep>
      return (void*)(p + 1);
 7d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d6:	70e2                	ld	ra,56(sp)
 7d8:	7442                	ld	s0,48(sp)
 7da:	74a2                	ld	s1,40(sp)
 7dc:	7902                	ld	s2,32(sp)
 7de:	69e2                	ld	s3,24(sp)
 7e0:	6a42                	ld	s4,16(sp)
 7e2:	6aa2                	ld	s5,8(sp)
 7e4:	6b02                	ld	s6,0(sp)
 7e6:	6121                	addi	sp,sp,64
 7e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	e118                	sd	a4,0(a0)
 7ee:	bff1                	j	7ca <malloc+0x86>
  hp->s.size = nu;
 7f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f4:	0541                	addi	a0,a0,16
 7f6:	00000097          	auipc	ra,0x0
 7fa:	ec6080e7          	jalr	-314(ra) # 6bc <free>
  return freep;
 7fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 802:	d971                	beqz	a0,7d6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 806:	4798                	lw	a4,8(a5)
 808:	fa9776e3          	bgeu	a4,s1,7b4 <malloc+0x70>
    if(p == freep)
 80c:	00093703          	ld	a4,0(s2)
 810:	853e                	mv	a0,a5
 812:	fef719e3          	bne	a4,a5,804 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 816:	8552                	mv	a0,s4
 818:	00000097          	auipc	ra,0x0
 81c:	b76080e7          	jalr	-1162(ra) # 38e <sbrk>
  if(p == (char*)-1)
 820:	fd5518e3          	bne	a0,s5,7f0 <malloc+0xac>
        return 0;
 824:	4501                	li	a0,0
 826:	bf45                	j	7d6 <malloc+0x92>
