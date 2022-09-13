
user/_yield:     file format elf64-littleriscv


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
    int a;
    int x=1;
    
    a=getpid();
   a:	00000097          	auipc	ra,0x0
   e:	3aa080e7          	jalr	938(ra) # 3b4 <getpid>
  12:	862a                	mv	a2,a0
    fprintf(1,"[%d] Parent has pid: %d\n",a,a);
  14:	86aa                	mv	a3,a0
  16:	00001597          	auipc	a1,0x1
  1a:	84a58593          	addi	a1,a1,-1974 # 860 <malloc+0xe6>
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	66e080e7          	jalr	1646(ra) # 68e <fprintf>
    if(fork()==0)
  28:	00000097          	auipc	ra,0x0
  2c:	304080e7          	jalr	772(ra) # 32c <fork>
  30:	e90d                	bnez	a0,62 <main+0x62>
    {
        yield(); // Making sure Parent executes First
  32:	00000097          	auipc	ra,0x0
  36:	3aa080e7          	jalr	938(ra) # 3dc <yield>
        a=getpid();
  3a:	00000097          	auipc	ra,0x0
  3e:	37a080e7          	jalr	890(ra) # 3b4 <getpid>
  42:	862a                	mv	a2,a0
        fprintf(1,"[%d] Child executing %d\n",a,a);
  44:	86aa                	mv	a3,a0
  46:	00001597          	auipc	a1,0x1
  4a:	83a58593          	addi	a1,a1,-1990 # 880 <malloc+0x106>
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	63e080e7          	jalr	1598(ra) # 68e <fprintf>
        fprintf(1,"[%d] Parent Yielded\n",a);
        x=yield();
        fprintf(1,"[%d] Parent got back control. Yield returned: %d\n",a,x);
        wait(0);
    }
    exit(0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	2da080e7          	jalr	730(ra) # 334 <exit>
        a=getpid();
  62:	00000097          	auipc	ra,0x0
  66:	352080e7          	jalr	850(ra) # 3b4 <getpid>
  6a:	84aa                	mv	s1,a0
        fprintf(1,"[%d] Parent executing\n",a);
  6c:	862a                	mv	a2,a0
  6e:	00001597          	auipc	a1,0x1
  72:	83258593          	addi	a1,a1,-1998 # 8a0 <malloc+0x126>
  76:	4505                	li	a0,1
  78:	00000097          	auipc	ra,0x0
  7c:	616080e7          	jalr	1558(ra) # 68e <fprintf>
        fprintf(1,"[%d] Parent Yielded\n",a);
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	83658593          	addi	a1,a1,-1994 # 8b8 <malloc+0x13e>
  8a:	4505                	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	602080e7          	jalr	1538(ra) # 68e <fprintf>
        x=yield();
  94:	00000097          	auipc	ra,0x0
  98:	348080e7          	jalr	840(ra) # 3dc <yield>
  9c:	86aa                	mv	a3,a0
        fprintf(1,"[%d] Parent got back control. Yield returned: %d\n",a,x);
  9e:	8626                	mv	a2,s1
  a0:	00001597          	auipc	a1,0x1
  a4:	83058593          	addi	a1,a1,-2000 # 8d0 <malloc+0x156>
  a8:	4505                	li	a0,1
  aa:	00000097          	auipc	ra,0x0
  ae:	5e4080e7          	jalr	1508(ra) # 68e <fprintf>
        wait(0);
  b2:	4501                	li	a0,0
  b4:	00000097          	auipc	ra,0x0
  b8:	288080e7          	jalr	648(ra) # 33c <wait>
  bc:	bf71                	j	58 <main+0x58>

00000000000000be <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c4:	87aa                	mv	a5,a0
  c6:	0585                	addi	a1,a1,1
  c8:	0785                	addi	a5,a5,1
  ca:	fff5c703          	lbu	a4,-1(a1)
  ce:	fee78fa3          	sb	a4,-1(a5)
  d2:	fb75                	bnez	a4,c6 <strcpy+0x8>
    ;
  return os;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb91                	beqz	a5,f8 <strcmp+0x1e>
  e6:	0005c703          	lbu	a4,0(a1)
  ea:	00f71763          	bne	a4,a5,f8 <strcmp+0x1e>
    p++, q++;
  ee:	0505                	addi	a0,a0,1
  f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f2:	00054783          	lbu	a5,0(a0)
  f6:	fbe5                	bnez	a5,e6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f8:	0005c503          	lbu	a0,0(a1)
}
  fc:	40a7853b          	subw	a0,a5,a0
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strlen>:

uint
strlen(const char *s)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cf91                	beqz	a5,12c <strlen+0x26>
 112:	0505                	addi	a0,a0,1
 114:	87aa                	mv	a5,a0
 116:	4685                	li	a3,1
 118:	9e89                	subw	a3,a3,a0
 11a:	00f6853b          	addw	a0,a3,a5
 11e:	0785                	addi	a5,a5,1
 120:	fff7c703          	lbu	a4,-1(a5)
 124:	fb7d                	bnez	a4,11a <strlen+0x14>
    ;
  return n;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  for(n = 0; s[n]; n++)
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strlen+0x20>

0000000000000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 136:	ce09                	beqz	a2,150 <memset+0x20>
 138:	87aa                	mv	a5,a0
 13a:	fff6071b          	addiw	a4,a2,-1
 13e:	1702                	slli	a4,a4,0x20
 140:	9301                	srli	a4,a4,0x20
 142:	0705                	addi	a4,a4,1
 144:	972a                	add	a4,a4,a0
    cdst[i] = c;
 146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14a:	0785                	addi	a5,a5,1
 14c:	fee79de3          	bne	a5,a4,146 <memset+0x16>
  }
  return dst;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strchr>:

char*
strchr(const char *s, char c)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	cb99                	beqz	a5,176 <strchr+0x20>
    if(*s == c)
 162:	00f58763          	beq	a1,a5,170 <strchr+0x1a>
  for(; *s; s++)
 166:	0505                	addi	a0,a0,1
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbfd                	bnez	a5,162 <strchr+0xc>
      return (char*)s;
  return 0;
 16e:	4501                	li	a0,0
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  return 0;
 176:	4501                	li	a0,0
 178:	bfe5                	j	170 <strchr+0x1a>

000000000000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	711d                	addi	sp,sp,-96
 17c:	ec86                	sd	ra,88(sp)
 17e:	e8a2                	sd	s0,80(sp)
 180:	e4a6                	sd	s1,72(sp)
 182:	e0ca                	sd	s2,64(sp)
 184:	fc4e                	sd	s3,56(sp)
 186:	f852                	sd	s4,48(sp)
 188:	f456                	sd	s5,40(sp)
 18a:	f05a                	sd	s6,32(sp)
 18c:	ec5e                	sd	s7,24(sp)
 18e:	1080                	addi	s0,sp,96
 190:	8baa                	mv	s7,a0
 192:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 194:	892a                	mv	s2,a0
 196:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 198:	4aa9                	li	s5,10
 19a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 19c:	89a6                	mv	s3,s1
 19e:	2485                	addiw	s1,s1,1
 1a0:	0344d863          	bge	s1,s4,1d0 <gets+0x56>
    cc = read(0, &c, 1);
 1a4:	4605                	li	a2,1
 1a6:	faf40593          	addi	a1,s0,-81
 1aa:	4501                	li	a0,0
 1ac:	00000097          	auipc	ra,0x0
 1b0:	1a0080e7          	jalr	416(ra) # 34c <read>
    if(cc < 1)
 1b4:	00a05e63          	blez	a0,1d0 <gets+0x56>
    buf[i++] = c;
 1b8:	faf44783          	lbu	a5,-81(s0)
 1bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c0:	01578763          	beq	a5,s5,1ce <gets+0x54>
 1c4:	0905                	addi	s2,s2,1
 1c6:	fd679be3          	bne	a5,s6,19c <gets+0x22>
  for(i=0; i+1 < max; ){
 1ca:	89a6                	mv	s3,s1
 1cc:	a011                	j	1d0 <gets+0x56>
 1ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d0:	99de                	add	s3,s3,s7
 1d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d6:	855e                	mv	a0,s7
 1d8:	60e6                	ld	ra,88(sp)
 1da:	6446                	ld	s0,80(sp)
 1dc:	64a6                	ld	s1,72(sp)
 1de:	6906                	ld	s2,64(sp)
 1e0:	79e2                	ld	s3,56(sp)
 1e2:	7a42                	ld	s4,48(sp)
 1e4:	7aa2                	ld	s5,40(sp)
 1e6:	7b02                	ld	s6,32(sp)
 1e8:	6be2                	ld	s7,24(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <stat>:

int
stat(const char *n, struct stat *st)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec06                	sd	ra,24(sp)
 1f2:	e822                	sd	s0,16(sp)
 1f4:	e426                	sd	s1,8(sp)
 1f6:	e04a                	sd	s2,0(sp)
 1f8:	1000                	addi	s0,sp,32
 1fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fc:	4581                	li	a1,0
 1fe:	00000097          	auipc	ra,0x0
 202:	176080e7          	jalr	374(ra) # 374 <open>
  if(fd < 0)
 206:	02054563          	bltz	a0,230 <stat+0x42>
 20a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20c:	85ca                	mv	a1,s2
 20e:	00000097          	auipc	ra,0x0
 212:	17e080e7          	jalr	382(ra) # 38c <fstat>
 216:	892a                	mv	s2,a0
  close(fd);
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	142080e7          	jalr	322(ra) # 35c <close>
  return r;
}
 222:	854a                	mv	a0,s2
 224:	60e2                	ld	ra,24(sp)
 226:	6442                	ld	s0,16(sp)
 228:	64a2                	ld	s1,8(sp)
 22a:	6902                	ld	s2,0(sp)
 22c:	6105                	addi	sp,sp,32
 22e:	8082                	ret
    return -1;
 230:	597d                	li	s2,-1
 232:	bfc5                	j	222 <stat+0x34>

0000000000000234 <atoi>:

int
atoi(const char *s)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23a:	00054603          	lbu	a2,0(a0)
 23e:	fd06079b          	addiw	a5,a2,-48
 242:	0ff7f793          	andi	a5,a5,255
 246:	4725                	li	a4,9
 248:	02f76963          	bltu	a4,a5,27a <atoi+0x46>
 24c:	86aa                	mv	a3,a0
  n = 0;
 24e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 250:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 252:	0685                	addi	a3,a3,1
 254:	0025179b          	slliw	a5,a0,0x2
 258:	9fa9                	addw	a5,a5,a0
 25a:	0017979b          	slliw	a5,a5,0x1
 25e:	9fb1                	addw	a5,a5,a2
 260:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 264:	0006c603          	lbu	a2,0(a3)
 268:	fd06071b          	addiw	a4,a2,-48
 26c:	0ff77713          	andi	a4,a4,255
 270:	fee5f1e3          	bgeu	a1,a4,252 <atoi+0x1e>
  return n;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  n = 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <atoi+0x40>

000000000000027e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 284:	02b57663          	bgeu	a0,a1,2b0 <memmove+0x32>
    while(n-- > 0)
 288:	02c05163          	blez	a2,2aa <memmove+0x2c>
 28c:	fff6079b          	addiw	a5,a2,-1
 290:	1782                	slli	a5,a5,0x20
 292:	9381                	srli	a5,a5,0x20
 294:	0785                	addi	a5,a5,1
 296:	97aa                	add	a5,a5,a0
  dst = vdst;
 298:	872a                	mv	a4,a0
      *dst++ = *src++;
 29a:	0585                	addi	a1,a1,1
 29c:	0705                	addi	a4,a4,1
 29e:	fff5c683          	lbu	a3,-1(a1)
 2a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
    dst += n;
 2b0:	00c50733          	add	a4,a0,a2
    src += n;
 2b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b6:	fec05ae3          	blez	a2,2aa <memmove+0x2c>
 2ba:	fff6079b          	addiw	a5,a2,-1
 2be:	1782                	slli	a5,a5,0x20
 2c0:	9381                	srli	a5,a5,0x20
 2c2:	fff7c793          	not	a5,a5
 2c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c8:	15fd                	addi	a1,a1,-1
 2ca:	177d                	addi	a4,a4,-1
 2cc:	0005c683          	lbu	a3,0(a1)
 2d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d4:	fee79ae3          	bne	a5,a4,2c8 <memmove+0x4a>
 2d8:	bfc9                	j	2aa <memmove+0x2c>

00000000000002da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e0:	ca05                	beqz	a2,310 <memcmp+0x36>
 2e2:	fff6069b          	addiw	a3,a2,-1
 2e6:	1682                	slli	a3,a3,0x20
 2e8:	9281                	srli	a3,a3,0x20
 2ea:	0685                	addi	a3,a3,1
 2ec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	0005c703          	lbu	a4,0(a1)
 2f6:	00e79863          	bne	a5,a4,306 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2fa:	0505                	addi	a0,a0,1
    p2++;
 2fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fe:	fed518e3          	bne	a0,a3,2ee <memcmp+0x14>
  }
  return 0;
 302:	4501                	li	a0,0
 304:	a019                	j	30a <memcmp+0x30>
      return *p1 - *p2;
 306:	40e7853b          	subw	a0,a5,a4
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  return 0;
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <memcmp+0x30>

0000000000000314 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31c:	00000097          	auipc	ra,0x0
 320:	f62080e7          	jalr	-158(ra) # 27e <memmove>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <write>:
.global write
write:
 li a7, SYS_write
 354:	48c1                	li	a7,16
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <close>:
.global close
close:
 li a7, SYS_close
 35c:	48d5                	li	a7,21
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <kill>:
.global kill
kill:
 li a7, SYS_kill
 364:	4899                	li	a7,6
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exec>:
.global exec
exec:
 li a7, SYS_exec
 36c:	489d                	li	a7,7
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <open>:
.global open
open:
 li a7, SYS_open
 374:	48bd                	li	a7,15
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38c:	48a1                	li	a7,8
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <link>:
.global link
link:
 li a7, SYS_link
 394:	48cd                	li	a7,19
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39c:	48d1                	li	a7,20
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a4:	48a5                	li	a7,9
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ac:	48a9                	li	a7,10
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b4:	48ad                	li	a7,11
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3bc:	48b1                	li	a7,12
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c4:	48b5                	li	a7,13
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3cc:	48b9                	li	a7,14
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3d4:	48d9                	li	a7,22
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <yield>:
.global yield
yield:
 li a7, SYS_yield
 3dc:	48dd                	li	a7,23
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	00000097          	auipc	ra,0x0
 3fa:	f5e080e7          	jalr	-162(ra) # 354 <write>
}
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 406:	7139                	addi	sp,sp,-64
 408:	fc06                	sd	ra,56(sp)
 40a:	f822                	sd	s0,48(sp)
 40c:	f426                	sd	s1,40(sp)
 40e:	f04a                	sd	s2,32(sp)
 410:	ec4e                	sd	s3,24(sp)
 412:	0080                	addi	s0,sp,64
 414:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 416:	c299                	beqz	a3,41c <printint+0x16>
 418:	0805c863          	bltz	a1,4a8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41c:	2581                	sext.w	a1,a1
  neg = 0;
 41e:	4881                	li	a7,0
 420:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 424:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 426:	2601                	sext.w	a2,a2
 428:	00000517          	auipc	a0,0x0
 42c:	4e850513          	addi	a0,a0,1256 # 910 <digits>
 430:	883a                	mv	a6,a4
 432:	2705                	addiw	a4,a4,1
 434:	02c5f7bb          	remuw	a5,a1,a2
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	97aa                	add	a5,a5,a0
 43e:	0007c783          	lbu	a5,0(a5)
 442:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 446:	0005879b          	sext.w	a5,a1
 44a:	02c5d5bb          	divuw	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fec7f0e3          	bgeu	a5,a2,430 <printint+0x2a>
  if(neg)
 454:	00088b63          	beqz	a7,46a <printint+0x64>
    buf[i++] = '-';
 458:	fd040793          	addi	a5,s0,-48
 45c:	973e                	add	a4,a4,a5
 45e:	02d00793          	li	a5,45
 462:	fef70823          	sb	a5,-16(a4)
 466:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46a:	02e05863          	blez	a4,49a <printint+0x94>
 46e:	fc040793          	addi	a5,s0,-64
 472:	00e78933          	add	s2,a5,a4
 476:	fff78993          	addi	s3,a5,-1
 47a:	99ba                	add	s3,s3,a4
 47c:	377d                	addiw	a4,a4,-1
 47e:	1702                	slli	a4,a4,0x20
 480:	9301                	srli	a4,a4,0x20
 482:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 486:	fff94583          	lbu	a1,-1(s2)
 48a:	8526                	mv	a0,s1
 48c:	00000097          	auipc	ra,0x0
 490:	f58080e7          	jalr	-168(ra) # 3e4 <putc>
  while(--i >= 0)
 494:	197d                	addi	s2,s2,-1
 496:	ff3918e3          	bne	s2,s3,486 <printint+0x80>
}
 49a:	70e2                	ld	ra,56(sp)
 49c:	7442                	ld	s0,48(sp)
 49e:	74a2                	ld	s1,40(sp)
 4a0:	7902                	ld	s2,32(sp)
 4a2:	69e2                	ld	s3,24(sp)
 4a4:	6121                	addi	sp,sp,64
 4a6:	8082                	ret
    x = -xx;
 4a8:	40b005bb          	negw	a1,a1
    neg = 1;
 4ac:	4885                	li	a7,1
    x = -xx;
 4ae:	bf8d                	j	420 <printint+0x1a>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	7119                	addi	sp,sp,-128
 4b2:	fc86                	sd	ra,120(sp)
 4b4:	f8a2                	sd	s0,112(sp)
 4b6:	f4a6                	sd	s1,104(sp)
 4b8:	f0ca                	sd	s2,96(sp)
 4ba:	ecce                	sd	s3,88(sp)
 4bc:	e8d2                	sd	s4,80(sp)
 4be:	e4d6                	sd	s5,72(sp)
 4c0:	e0da                	sd	s6,64(sp)
 4c2:	fc5e                	sd	s7,56(sp)
 4c4:	f862                	sd	s8,48(sp)
 4c6:	f466                	sd	s9,40(sp)
 4c8:	f06a                	sd	s10,32(sp)
 4ca:	ec6e                	sd	s11,24(sp)
 4cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c903          	lbu	s2,0(a1)
 4d2:	18090f63          	beqz	s2,670 <vprintf+0x1c0>
 4d6:	8aaa                	mv	s5,a0
 4d8:	8b32                	mv	s6,a2
 4da:	00158493          	addi	s1,a1,1
  state = 0;
 4de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e0:	02500a13          	li	s4,37
      if(c == 'd'){
 4e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4e8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4ec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f4:	00000b97          	auipc	s7,0x0
 4f8:	41cb8b93          	addi	s7,s7,1052 # 910 <digits>
 4fc:	a839                	j	51a <vprintf+0x6a>
        putc(fd, c);
 4fe:	85ca                	mv	a1,s2
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	ee2080e7          	jalr	-286(ra) # 3e4 <putc>
 50a:	a019                	j	510 <vprintf+0x60>
    } else if(state == '%'){
 50c:	01498f63          	beq	s3,s4,52a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 510:	0485                	addi	s1,s1,1
 512:	fff4c903          	lbu	s2,-1(s1)
 516:	14090d63          	beqz	s2,670 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 51a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51e:	fe0997e3          	bnez	s3,50c <vprintf+0x5c>
      if(c == '%'){
 522:	fd479ee3          	bne	a5,s4,4fe <vprintf+0x4e>
        state = '%';
 526:	89be                	mv	s3,a5
 528:	b7e5                	j	510 <vprintf+0x60>
      if(c == 'd'){
 52a:	05878063          	beq	a5,s8,56a <vprintf+0xba>
      } else if(c == 'l') {
 52e:	05978c63          	beq	a5,s9,586 <vprintf+0xd6>
      } else if(c == 'x') {
 532:	07a78863          	beq	a5,s10,5a2 <vprintf+0xf2>
      } else if(c == 'p') {
 536:	09b78463          	beq	a5,s11,5be <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 53a:	07300713          	li	a4,115
 53e:	0ce78663          	beq	a5,a4,60a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 542:	06300713          	li	a4,99
 546:	0ee78e63          	beq	a5,a4,642 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 54a:	11478863          	beq	a5,s4,65a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54e:	85d2                	mv	a1,s4
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e92080e7          	jalr	-366(ra) # 3e4 <putc>
        putc(fd, c);
 55a:	85ca                	mv	a1,s2
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e86080e7          	jalr	-378(ra) # 3e4 <putc>
      }
      state = 0;
 566:	4981                	li	s3,0
 568:	b765                	j	510 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 56a:	008b0913          	addi	s2,s6,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000b2583          	lw	a1,0(s6)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e8e080e7          	jalr	-370(ra) # 406 <printint>
 580:	8b4a                	mv	s6,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b771                	j	510 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b0913          	addi	s2,s6,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000b2583          	lw	a1,0(s6)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e72080e7          	jalr	-398(ra) # 406 <printint>
 59c:	8b4a                	mv	s6,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bf85                	j	510 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000b2583          	lw	a1,0(s6)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e56080e7          	jalr	-426(ra) # 406 <printint>
 5b8:	8b4a                	mv	s6,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf91                	j	510 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5be:	008b0793          	addi	a5,s6,8
 5c2:	f8f43423          	sd	a5,-120(s0)
 5c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ca:	03000593          	li	a1,48
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e14080e7          	jalr	-492(ra) # 3e4 <putc>
  putc(fd, 'x');
 5d8:	85ea                	mv	a1,s10
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e08080e7          	jalr	-504(ra) # 3e4 <putc>
 5e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e6:	03c9d793          	srli	a5,s3,0x3c
 5ea:	97de                	add	a5,a5,s7
 5ec:	0007c583          	lbu	a1,0(a5)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	df2080e7          	jalr	-526(ra) # 3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fa:	0992                	slli	s3,s3,0x4
 5fc:	397d                	addiw	s2,s2,-1
 5fe:	fe0914e3          	bnez	s2,5e6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 602:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 606:	4981                	li	s3,0
 608:	b721                	j	510 <vprintf+0x60>
        s = va_arg(ap, char*);
 60a:	008b0993          	addi	s3,s6,8
 60e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 612:	02090163          	beqz	s2,634 <vprintf+0x184>
        while(*s != 0){
 616:	00094583          	lbu	a1,0(s2)
 61a:	c9a1                	beqz	a1,66a <vprintf+0x1ba>
          putc(fd, *s);
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	dc6080e7          	jalr	-570(ra) # 3e4 <putc>
          s++;
 626:	0905                	addi	s2,s2,1
        while(*s != 0){
 628:	00094583          	lbu	a1,0(s2)
 62c:	f9e5                	bnez	a1,61c <vprintf+0x16c>
        s = va_arg(ap, char*);
 62e:	8b4e                	mv	s6,s3
      state = 0;
 630:	4981                	li	s3,0
 632:	bdf9                	j	510 <vprintf+0x60>
          s = "(null)";
 634:	00000917          	auipc	s2,0x0
 638:	2d490913          	addi	s2,s2,724 # 908 <malloc+0x18e>
        while(*s != 0){
 63c:	02800593          	li	a1,40
 640:	bff1                	j	61c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 642:	008b0913          	addi	s2,s6,8
 646:	000b4583          	lbu	a1,0(s6)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d98080e7          	jalr	-616(ra) # 3e4 <putc>
 654:	8b4a                	mv	s6,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	bd65                	j	510 <vprintf+0x60>
        putc(fd, c);
 65a:	85d2                	mv	a1,s4
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	d86080e7          	jalr	-634(ra) # 3e4 <putc>
      state = 0;
 666:	4981                	li	s3,0
 668:	b565                	j	510 <vprintf+0x60>
        s = va_arg(ap, char*);
 66a:	8b4e                	mv	s6,s3
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b54d                	j	510 <vprintf+0x60>
    }
  }
}
 670:	70e6                	ld	ra,120(sp)
 672:	7446                	ld	s0,112(sp)
 674:	74a6                	ld	s1,104(sp)
 676:	7906                	ld	s2,96(sp)
 678:	69e6                	ld	s3,88(sp)
 67a:	6a46                	ld	s4,80(sp)
 67c:	6aa6                	ld	s5,72(sp)
 67e:	6b06                	ld	s6,64(sp)
 680:	7be2                	ld	s7,56(sp)
 682:	7c42                	ld	s8,48(sp)
 684:	7ca2                	ld	s9,40(sp)
 686:	7d02                	ld	s10,32(sp)
 688:	6de2                	ld	s11,24(sp)
 68a:	6109                	addi	sp,sp,128
 68c:	8082                	ret

000000000000068e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68e:	715d                	addi	sp,sp,-80
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e010                	sd	a2,0(s0)
 698:	e414                	sd	a3,8(s0)
 69a:	e818                	sd	a4,16(s0)
 69c:	ec1c                	sd	a5,24(s0)
 69e:	03043023          	sd	a6,32(s0)
 6a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6aa:	8622                	mv	a2,s0
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e04080e7          	jalr	-508(ra) # 4b0 <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <printf>:

void
printf(const char *fmt, ...)
{
 6bc:	711d                	addi	sp,sp,-96
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e40c                	sd	a1,8(s0)
 6c6:	e810                	sd	a2,16(s0)
 6c8:	ec14                	sd	a3,24(s0)
 6ca:	f018                	sd	a4,32(s0)
 6cc:	f41c                	sd	a5,40(s0)
 6ce:	03043823          	sd	a6,48(s0)
 6d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	00840613          	addi	a2,s0,8
 6da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6de:	85aa                	mv	a1,a0
 6e0:	4505                	li	a0,1
 6e2:	00000097          	auipc	ra,0x0
 6e6:	dce080e7          	jalr	-562(ra) # 4b0 <vprintf>
}
 6ea:	60e2                	ld	ra,24(sp)
 6ec:	6442                	ld	s0,16(sp)
 6ee:	6125                	addi	sp,sp,96
 6f0:	8082                	ret

00000000000006f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f2:	1141                	addi	sp,sp,-16
 6f4:	e422                	sd	s0,8(sp)
 6f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fc:	00000797          	auipc	a5,0x0
 700:	22c7b783          	ld	a5,556(a5) # 928 <freep>
 704:	a805                	j	734 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 706:	4618                	lw	a4,8(a2)
 708:	9db9                	addw	a1,a1,a4
 70a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70e:	6398                	ld	a4,0(a5)
 710:	6318                	ld	a4,0(a4)
 712:	fee53823          	sd	a4,-16(a0)
 716:	a091                	j	75a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 718:	ff852703          	lw	a4,-8(a0)
 71c:	9e39                	addw	a2,a2,a4
 71e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 720:	ff053703          	ld	a4,-16(a0)
 724:	e398                	sd	a4,0(a5)
 726:	a099                	j	76c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	6398                	ld	a4,0(a5)
 72a:	00e7e463          	bltu	a5,a4,732 <free+0x40>
 72e:	00e6ea63          	bltu	a3,a4,742 <free+0x50>
{
 732:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	fed7fae3          	bgeu	a5,a3,728 <free+0x36>
 738:	6398                	ld	a4,0(a5)
 73a:	00e6e463          	bltu	a3,a4,742 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	fee7eae3          	bltu	a5,a4,732 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 742:	ff852583          	lw	a1,-8(a0)
 746:	6390                	ld	a2,0(a5)
 748:	02059713          	slli	a4,a1,0x20
 74c:	9301                	srli	a4,a4,0x20
 74e:	0712                	slli	a4,a4,0x4
 750:	9736                	add	a4,a4,a3
 752:	fae60ae3          	beq	a2,a4,706 <free+0x14>
    bp->s.ptr = p->s.ptr;
 756:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75a:	4790                	lw	a2,8(a5)
 75c:	02061713          	slli	a4,a2,0x20
 760:	9301                	srli	a4,a4,0x20
 762:	0712                	slli	a4,a4,0x4
 764:	973e                	add	a4,a4,a5
 766:	fae689e3          	beq	a3,a4,718 <free+0x26>
  } else
    p->s.ptr = bp;
 76a:	e394                	sd	a3,0(a5)
  freep = p;
 76c:	00000717          	auipc	a4,0x0
 770:	1af73e23          	sd	a5,444(a4) # 928 <freep>
}
 774:	6422                	ld	s0,8(sp)
 776:	0141                	addi	sp,sp,16
 778:	8082                	ret

000000000000077a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77a:	7139                	addi	sp,sp,-64
 77c:	fc06                	sd	ra,56(sp)
 77e:	f822                	sd	s0,48(sp)
 780:	f426                	sd	s1,40(sp)
 782:	f04a                	sd	s2,32(sp)
 784:	ec4e                	sd	s3,24(sp)
 786:	e852                	sd	s4,16(sp)
 788:	e456                	sd	s5,8(sp)
 78a:	e05a                	sd	s6,0(sp)
 78c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78e:	02051493          	slli	s1,a0,0x20
 792:	9081                	srli	s1,s1,0x20
 794:	04bd                	addi	s1,s1,15
 796:	8091                	srli	s1,s1,0x4
 798:	0014899b          	addiw	s3,s1,1
 79c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79e:	00000517          	auipc	a0,0x0
 7a2:	18a53503          	ld	a0,394(a0) # 928 <freep>
 7a6:	c515                	beqz	a0,7d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7aa:	4798                	lw	a4,8(a5)
 7ac:	02977f63          	bgeu	a4,s1,7ea <malloc+0x70>
 7b0:	8a4e                	mv	s4,s3
 7b2:	0009871b          	sext.w	a4,s3
 7b6:	6685                	lui	a3,0x1
 7b8:	00d77363          	bgeu	a4,a3,7be <malloc+0x44>
 7bc:	6a05                	lui	s4,0x1
 7be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c6:	00000917          	auipc	s2,0x0
 7ca:	16290913          	addi	s2,s2,354 # 928 <freep>
  if(p == (char*)-1)
 7ce:	5afd                	li	s5,-1
 7d0:	a88d                	j	842 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7d2:	00000797          	auipc	a5,0x0
 7d6:	15e78793          	addi	a5,a5,350 # 930 <base>
 7da:	00000717          	auipc	a4,0x0
 7de:	14f73723          	sd	a5,334(a4) # 928 <freep>
 7e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e8:	b7e1                	j	7b0 <malloc+0x36>
      if(p->s.size == nunits)
 7ea:	02e48b63          	beq	s1,a4,820 <malloc+0xa6>
        p->s.size -= nunits;
 7ee:	4137073b          	subw	a4,a4,s3
 7f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f4:	1702                	slli	a4,a4,0x20
 7f6:	9301                	srli	a4,a4,0x20
 7f8:	0712                	slli	a4,a4,0x4
 7fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 800:	00000717          	auipc	a4,0x0
 804:	12a73423          	sd	a0,296(a4) # 928 <freep>
      return (void*)(p + 1);
 808:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 80c:	70e2                	ld	ra,56(sp)
 80e:	7442                	ld	s0,48(sp)
 810:	74a2                	ld	s1,40(sp)
 812:	7902                	ld	s2,32(sp)
 814:	69e2                	ld	s3,24(sp)
 816:	6a42                	ld	s4,16(sp)
 818:	6aa2                	ld	s5,8(sp)
 81a:	6b02                	ld	s6,0(sp)
 81c:	6121                	addi	sp,sp,64
 81e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	e118                	sd	a4,0(a0)
 824:	bff1                	j	800 <malloc+0x86>
  hp->s.size = nu;
 826:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82a:	0541                	addi	a0,a0,16
 82c:	00000097          	auipc	ra,0x0
 830:	ec6080e7          	jalr	-314(ra) # 6f2 <free>
  return freep;
 834:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 838:	d971                	beqz	a0,80c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	fa9776e3          	bgeu	a4,s1,7ea <malloc+0x70>
    if(p == freep)
 842:	00093703          	ld	a4,0(s2)
 846:	853e                	mv	a0,a5
 848:	fef719e3          	bne	a4,a5,83a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 84c:	8552                	mv	a0,s4
 84e:	00000097          	auipc	ra,0x0
 852:	b6e080e7          	jalr	-1170(ra) # 3bc <sbrk>
  if(p == (char*)-1)
 856:	fd5518e3          	bne	a0,s5,826 <malloc+0xac>
        return 0;
 85a:	4501                	li	a0,0
 85c:	bf45                	j	80c <malloc+0x92>
