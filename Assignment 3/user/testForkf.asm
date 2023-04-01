
user/_testForkf:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f>:
{
   return x*x;
}

int f (void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   int x = 10;

   fprintf(2, "Hello world! %d\n", g(x));
   8:	06400613          	li	a2,100
   c:	00001597          	auipc	a1,0x1
  10:	8fc58593          	addi	a1,a1,-1796 # 908 <malloc+0xe6>
  14:	4509                	li	a0,2
  16:	00000097          	auipc	ra,0x0
  1a:	720080e7          	jalr	1824(ra) # 736 <fprintf>
   return 0;
}
  1e:	4501                	li	a0,0
  20:	60a2                	ld	ra,8(sp)
  22:	6402                	ld	s0,0(sp)
  24:	0141                	addi	sp,sp,16
  26:	8082                	ret

0000000000000028 <g>:
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
}
  2e:	02a5053b          	mulw	a0,a0,a0
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <main>:

int
main(void)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	addi	s0,sp,16
  int x = forkf(f);
  40:	00000517          	auipc	a0,0x0
  44:	fc050513          	addi	a0,a0,-64 # 0 <f>
  48:	00000097          	auipc	ra,0x0
  4c:	3b2080e7          	jalr	946(ra) # 3fa <forkf>
  if (x < 0) {
  50:	04054163          	bltz	a0,92 <main+0x5a>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  54:	04a05d63          	blez	a0,ae <main+0x76>
     sleep(1);
  58:	4505                	li	a0,1
  5a:	00000097          	auipc	ra,0x0
  5e:	378080e7          	jalr	888(ra) # 3d2 <sleep>
     fprintf(1, "%d: Parent.\n", getpid());
  62:	00000097          	auipc	ra,0x0
  66:	360080e7          	jalr	864(ra) # 3c2 <getpid>
  6a:	862a                	mv	a2,a0
  6c:	00001597          	auipc	a1,0x1
  70:	8d458593          	addi	a1,a1,-1836 # 940 <malloc+0x11e>
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	6c0080e7          	jalr	1728(ra) # 736 <fprintf>
     wait(0);
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	2ca080e7          	jalr	714(ra) # 34a <wait>
  }
  else {
     fprintf(1, "%d: Child.\n", getpid());
  }

  exit(0);
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	2b8080e7          	jalr	696(ra) # 342 <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
  92:	00001597          	auipc	a1,0x1
  96:	88e58593          	addi	a1,a1,-1906 # 920 <malloc+0xfe>
  9a:	4509                	li	a0,2
  9c:	00000097          	auipc	ra,0x0
  a0:	69a080e7          	jalr	1690(ra) # 736 <fprintf>
     exit(0);
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	29c080e7          	jalr	668(ra) # 342 <exit>
     fprintf(1, "%d: Child.\n", getpid());
  ae:	00000097          	auipc	ra,0x0
  b2:	314080e7          	jalr	788(ra) # 3c2 <getpid>
  b6:	862a                	mv	a2,a0
  b8:	00001597          	auipc	a1,0x1
  bc:	89858593          	addi	a1,a1,-1896 # 950 <malloc+0x12e>
  c0:	4505                	li	a0,1
  c2:	00000097          	auipc	ra,0x0
  c6:	674080e7          	jalr	1652(ra) # 736 <fprintf>
  ca:	bf7d                	j	88 <main+0x50>

00000000000000cc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d2:	87aa                	mv	a5,a0
  d4:	0585                	addi	a1,a1,1
  d6:	0785                	addi	a5,a5,1
  d8:	fff5c703          	lbu	a4,-1(a1)
  dc:	fee78fa3          	sb	a4,-1(a5)
  e0:	fb75                	bnez	a4,d4 <strcpy+0x8>
    ;
  return os;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb91                	beqz	a5,106 <strcmp+0x1e>
  f4:	0005c703          	lbu	a4,0(a1)
  f8:	00f71763          	bne	a4,a5,106 <strcmp+0x1e>
    p++, q++;
  fc:	0505                	addi	a0,a0,1
  fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	fbe5                	bnez	a5,f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 106:	0005c503          	lbu	a0,0(a1)
}
 10a:	40a7853b          	subw	a0,a5,a0
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x26>
 120:	0505                	addi	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	4685                	li	a3,1
 126:	9e89                	subw	a3,a3,a0
 128:	00f6853b          	addw	a0,a3,a5
 12c:	0785                	addi	a5,a5,1
 12e:	fff7c703          	lbu	a4,-1(a5)
 132:	fb7d                	bnez	a4,128 <strlen+0x14>
    ;
  return n;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 144:	ce09                	beqz	a2,15e <memset+0x20>
 146:	87aa                	mv	a5,a0
 148:	fff6071b          	addiw	a4,a2,-1
 14c:	1702                	slli	a4,a4,0x20
 14e:	9301                	srli	a4,a4,0x20
 150:	0705                	addi	a4,a4,1
 152:	972a                	add	a4,a4,a0
    cdst[i] = c;
 154:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 158:	0785                	addi	a5,a5,1
 15a:	fee79de3          	bne	a5,a4,154 <memset+0x16>
  }
  return dst;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cb99                	beqz	a5,184 <strchr+0x20>
    if(*s == c)
 170:	00f58763          	beq	a1,a5,17e <strchr+0x1a>
  for(; *s; s++)
 174:	0505                	addi	a0,a0,1
 176:	00054783          	lbu	a5,0(a0)
 17a:	fbfd                	bnez	a5,170 <strchr+0xc>
      return (char*)s;
  return 0;
 17c:	4501                	li	a0,0
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  return 0;
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strchr+0x1a>

0000000000000188 <gets>:

char*
gets(char *buf, int max)
{
 188:	711d                	addi	sp,sp,-96
 18a:	ec86                	sd	ra,88(sp)
 18c:	e8a2                	sd	s0,80(sp)
 18e:	e4a6                	sd	s1,72(sp)
 190:	e0ca                	sd	s2,64(sp)
 192:	fc4e                	sd	s3,56(sp)
 194:	f852                	sd	s4,48(sp)
 196:	f456                	sd	s5,40(sp)
 198:	f05a                	sd	s6,32(sp)
 19a:	ec5e                	sd	s7,24(sp)
 19c:	1080                	addi	s0,sp,96
 19e:	8baa                	mv	s7,a0
 1a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a2:	892a                	mv	s2,a0
 1a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a6:	4aa9                	li	s5,10
 1a8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1aa:	89a6                	mv	s3,s1
 1ac:	2485                	addiw	s1,s1,1
 1ae:	0344d863          	bge	s1,s4,1de <gets+0x56>
    cc = read(0, &c, 1);
 1b2:	4605                	li	a2,1
 1b4:	faf40593          	addi	a1,s0,-81
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	1a0080e7          	jalr	416(ra) # 35a <read>
    if(cc < 1)
 1c2:	00a05e63          	blez	a0,1de <gets+0x56>
    buf[i++] = c;
 1c6:	faf44783          	lbu	a5,-81(s0)
 1ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ce:	01578763          	beq	a5,s5,1dc <gets+0x54>
 1d2:	0905                	addi	s2,s2,1
 1d4:	fd679be3          	bne	a5,s6,1aa <gets+0x22>
  for(i=0; i+1 < max; ){
 1d8:	89a6                	mv	s3,s1
 1da:	a011                	j	1de <gets+0x56>
 1dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1de:	99de                	add	s3,s3,s7
 1e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e4:	855e                	mv	a0,s7
 1e6:	60e6                	ld	ra,88(sp)
 1e8:	6446                	ld	s0,80(sp)
 1ea:	64a6                	ld	s1,72(sp)
 1ec:	6906                	ld	s2,64(sp)
 1ee:	79e2                	ld	s3,56(sp)
 1f0:	7a42                	ld	s4,48(sp)
 1f2:	7aa2                	ld	s5,40(sp)
 1f4:	7b02                	ld	s6,32(sp)
 1f6:	6be2                	ld	s7,24(sp)
 1f8:	6125                	addi	sp,sp,96
 1fa:	8082                	ret

00000000000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	1101                	addi	sp,sp,-32
 1fe:	ec06                	sd	ra,24(sp)
 200:	e822                	sd	s0,16(sp)
 202:	e426                	sd	s1,8(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	00000097          	auipc	ra,0x0
 210:	176080e7          	jalr	374(ra) # 382 <open>
  if(fd < 0)
 214:	02054563          	bltz	a0,23e <stat+0x42>
 218:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21a:	85ca                	mv	a1,s2
 21c:	00000097          	auipc	ra,0x0
 220:	17e080e7          	jalr	382(ra) # 39a <fstat>
 224:	892a                	mv	s2,a0
  close(fd);
 226:	8526                	mv	a0,s1
 228:	00000097          	auipc	ra,0x0
 22c:	142080e7          	jalr	322(ra) # 36a <close>
  return r;
}
 230:	854a                	mv	a0,s2
 232:	60e2                	ld	ra,24(sp)
 234:	6442                	ld	s0,16(sp)
 236:	64a2                	ld	s1,8(sp)
 238:	6902                	ld	s2,0(sp)
 23a:	6105                	addi	sp,sp,32
 23c:	8082                	ret
    return -1;
 23e:	597d                	li	s2,-1
 240:	bfc5                	j	230 <stat+0x34>

0000000000000242 <atoi>:

int
atoi(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 248:	00054603          	lbu	a2,0(a0)
 24c:	fd06079b          	addiw	a5,a2,-48
 250:	0ff7f793          	andi	a5,a5,255
 254:	4725                	li	a4,9
 256:	02f76963          	bltu	a4,a5,288 <atoi+0x46>
 25a:	86aa                	mv	a3,a0
  n = 0;
 25c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 25e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 260:	0685                	addi	a3,a3,1
 262:	0025179b          	slliw	a5,a0,0x2
 266:	9fa9                	addw	a5,a5,a0
 268:	0017979b          	slliw	a5,a5,0x1
 26c:	9fb1                	addw	a5,a5,a2
 26e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 272:	0006c603          	lbu	a2,0(a3)
 276:	fd06071b          	addiw	a4,a2,-48
 27a:	0ff77713          	andi	a4,a4,255
 27e:	fee5f1e3          	bgeu	a1,a4,260 <atoi+0x1e>
  return n;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  n = 0;
 288:	4501                	li	a0,0
 28a:	bfe5                	j	282 <atoi+0x40>

000000000000028c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 292:	02b57663          	bgeu	a0,a1,2be <memmove+0x32>
    while(n-- > 0)
 296:	02c05163          	blez	a2,2b8 <memmove+0x2c>
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	0785                	addi	a5,a5,1
 2a4:	97aa                	add	a5,a5,a0
  dst = vdst;
 2a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a8:	0585                	addi	a1,a1,1
 2aa:	0705                	addi	a4,a4,1
 2ac:	fff5c683          	lbu	a3,-1(a1)
 2b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
    dst += n;
 2be:	00c50733          	add	a4,a0,a2
    src += n;
 2c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c4:	fec05ae3          	blez	a2,2b8 <memmove+0x2c>
 2c8:	fff6079b          	addiw	a5,a2,-1
 2cc:	1782                	slli	a5,a5,0x20
 2ce:	9381                	srli	a5,a5,0x20
 2d0:	fff7c793          	not	a5,a5
 2d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d6:	15fd                	addi	a1,a1,-1
 2d8:	177d                	addi	a4,a4,-1
 2da:	0005c683          	lbu	a3,0(a1)
 2de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e2:	fee79ae3          	bne	a5,a4,2d6 <memmove+0x4a>
 2e6:	bfc9                	j	2b8 <memmove+0x2c>

00000000000002e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ee:	ca05                	beqz	a2,31e <memcmp+0x36>
 2f0:	fff6069b          	addiw	a3,a2,-1
 2f4:	1682                	slli	a3,a3,0x20
 2f6:	9281                	srli	a3,a3,0x20
 2f8:	0685                	addi	a3,a3,1
 2fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2fc:	00054783          	lbu	a5,0(a0)
 300:	0005c703          	lbu	a4,0(a1)
 304:	00e79863          	bne	a5,a4,314 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 308:	0505                	addi	a0,a0,1
    p2++;
 30a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30c:	fed518e3          	bne	a0,a3,2fc <memcmp+0x14>
  }
  return 0;
 310:	4501                	li	a0,0
 312:	a019                	j	318 <memcmp+0x30>
      return *p1 - *p2;
 314:	40e7853b          	subw	a0,a5,a4
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  return 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <memcmp+0x30>

0000000000000322 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e406                	sd	ra,8(sp)
 326:	e022                	sd	s0,0(sp)
 328:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32a:	00000097          	auipc	ra,0x0
 32e:	f62080e7          	jalr	-158(ra) # 28c <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33a:	4885                	li	a7,1
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exit>:
.global exit
exit:
 li a7, SYS_exit
 342:	4889                	li	a7,2
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <wait>:
.global wait
wait:
 li a7, SYS_wait
 34a:	488d                	li	a7,3
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 352:	4891                	li	a7,4
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <read>:
.global read
read:
 li a7, SYS_read
 35a:	4895                	li	a7,5
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <close>:
.global close
close:
 li a7, SYS_close
 36a:	48d5                	li	a7,21
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <open>:
.global open
open:
 li a7, SYS_open
 382:	48bd                	li	a7,15
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38a:	48c5                	li	a7,17
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 392:	48c9                	li	a7,18
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39a:	48a1                	li	a7,8
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <link>:
.global link
link:
 li a7, SYS_link
 3a2:	48cd                	li	a7,19
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3aa:	48d1                	li	a7,20
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b2:	48a5                	li	a7,9
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ba:	48a9                	li	a7,10
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c2:	48ad                	li	a7,11
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ca:	48b1                	li	a7,12
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d2:	48b5                	li	a7,13
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3da:	48b9                	li	a7,14
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3e2:	48d9                	li	a7,22
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <yield>:
.global yield
yield:
 li a7, SYS_yield
 3ea:	48dd                	li	a7,23
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 3f2:	48e1                	li	a7,24
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 3fa:	48e5                	li	a7,25
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 402:	48e9                	li	a7,26
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <ps>:
.global ps
ps:
 li a7, SYS_ps
 40a:	48ed                	li	a7,27
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 412:	48f1                	li	a7,28
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 41a:	48f5                	li	a7,29
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 422:	48f9                	li	a7,30
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 42a:	48fd                	li	a7,31
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 432:	02000893          	li	a7,32
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 43c:	02100893          	li	a7,33
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 446:	02200893          	li	a7,34
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 450:	02300893          	li	a7,35
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 45a:	02500893          	li	a7,37
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 464:	02400893          	li	a7,36
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 46e:	02600893          	li	a7,38
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 478:	02800893          	li	a7,40
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 482:	02700893          	li	a7,39
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	ec4080e7          	jalr	-316(ra) # 362 <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	0080                	addi	s0,sp,64
 4bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4be:	c299                	beqz	a3,4c4 <printint+0x16>
 4c0:	0805c863          	bltz	a1,550 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c4:	2581                	sext.w	a1,a1
  neg = 0;
 4c6:	4881                	li	a7,0
 4c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ce:	2601                	sext.w	a2,a2
 4d0:	00000517          	auipc	a0,0x0
 4d4:	49850513          	addi	a0,a0,1176 # 968 <digits>
 4d8:	883a                	mv	a6,a4
 4da:	2705                	addiw	a4,a4,1
 4dc:	02c5f7bb          	remuw	a5,a1,a2
 4e0:	1782                	slli	a5,a5,0x20
 4e2:	9381                	srli	a5,a5,0x20
 4e4:	97aa                	add	a5,a5,a0
 4e6:	0007c783          	lbu	a5,0(a5)
 4ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ee:	0005879b          	sext.w	a5,a1
 4f2:	02c5d5bb          	divuw	a1,a1,a2
 4f6:	0685                	addi	a3,a3,1
 4f8:	fec7f0e3          	bgeu	a5,a2,4d8 <printint+0x2a>
  if(neg)
 4fc:	00088b63          	beqz	a7,512 <printint+0x64>
    buf[i++] = '-';
 500:	fd040793          	addi	a5,s0,-48
 504:	973e                	add	a4,a4,a5
 506:	02d00793          	li	a5,45
 50a:	fef70823          	sb	a5,-16(a4)
 50e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 512:	02e05863          	blez	a4,542 <printint+0x94>
 516:	fc040793          	addi	a5,s0,-64
 51a:	00e78933          	add	s2,a5,a4
 51e:	fff78993          	addi	s3,a5,-1
 522:	99ba                	add	s3,s3,a4
 524:	377d                	addiw	a4,a4,-1
 526:	1702                	slli	a4,a4,0x20
 528:	9301                	srli	a4,a4,0x20
 52a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52e:	fff94583          	lbu	a1,-1(s2)
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	f58080e7          	jalr	-168(ra) # 48c <putc>
  while(--i >= 0)
 53c:	197d                	addi	s2,s2,-1
 53e:	ff3918e3          	bne	s2,s3,52e <printint+0x80>
}
 542:	70e2                	ld	ra,56(sp)
 544:	7442                	ld	s0,48(sp)
 546:	74a2                	ld	s1,40(sp)
 548:	7902                	ld	s2,32(sp)
 54a:	69e2                	ld	s3,24(sp)
 54c:	6121                	addi	sp,sp,64
 54e:	8082                	ret
    x = -xx;
 550:	40b005bb          	negw	a1,a1
    neg = 1;
 554:	4885                	li	a7,1
    x = -xx;
 556:	bf8d                	j	4c8 <printint+0x1a>

0000000000000558 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 558:	7119                	addi	sp,sp,-128
 55a:	fc86                	sd	ra,120(sp)
 55c:	f8a2                	sd	s0,112(sp)
 55e:	f4a6                	sd	s1,104(sp)
 560:	f0ca                	sd	s2,96(sp)
 562:	ecce                	sd	s3,88(sp)
 564:	e8d2                	sd	s4,80(sp)
 566:	e4d6                	sd	s5,72(sp)
 568:	e0da                	sd	s6,64(sp)
 56a:	fc5e                	sd	s7,56(sp)
 56c:	f862                	sd	s8,48(sp)
 56e:	f466                	sd	s9,40(sp)
 570:	f06a                	sd	s10,32(sp)
 572:	ec6e                	sd	s11,24(sp)
 574:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 576:	0005c903          	lbu	s2,0(a1)
 57a:	18090f63          	beqz	s2,718 <vprintf+0x1c0>
 57e:	8aaa                	mv	s5,a0
 580:	8b32                	mv	s6,a2
 582:	00158493          	addi	s1,a1,1
  state = 0;
 586:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 588:	02500a13          	li	s4,37
      if(c == 'd'){
 58c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 590:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 594:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 598:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59c:	00000b97          	auipc	s7,0x0
 5a0:	3ccb8b93          	addi	s7,s7,972 # 968 <digits>
 5a4:	a839                	j	5c2 <vprintf+0x6a>
        putc(fd, c);
 5a6:	85ca                	mv	a1,s2
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ee2080e7          	jalr	-286(ra) # 48c <putc>
 5b2:	a019                	j	5b8 <vprintf+0x60>
    } else if(state == '%'){
 5b4:	01498f63          	beq	s3,s4,5d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b8:	0485                	addi	s1,s1,1
 5ba:	fff4c903          	lbu	s2,-1(s1)
 5be:	14090d63          	beqz	s2,718 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c6:	fe0997e3          	bnez	s3,5b4 <vprintf+0x5c>
      if(c == '%'){
 5ca:	fd479ee3          	bne	a5,s4,5a6 <vprintf+0x4e>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7e5                	j	5b8 <vprintf+0x60>
      if(c == 'd'){
 5d2:	05878063          	beq	a5,s8,612 <vprintf+0xba>
      } else if(c == 'l') {
 5d6:	05978c63          	beq	a5,s9,62e <vprintf+0xd6>
      } else if(c == 'x') {
 5da:	07a78863          	beq	a5,s10,64a <vprintf+0xf2>
      } else if(c == 'p') {
 5de:	09b78463          	beq	a5,s11,666 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e2:	07300713          	li	a4,115
 5e6:	0ce78663          	beq	a5,a4,6b2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ea:	06300713          	li	a4,99
 5ee:	0ee78e63          	beq	a5,a4,6ea <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f2:	11478863          	beq	a5,s4,702 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f6:	85d2                	mv	a1,s4
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e92080e7          	jalr	-366(ra) # 48c <putc>
        putc(fd, c);
 602:	85ca                	mv	a1,s2
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e86080e7          	jalr	-378(ra) # 48c <putc>
      }
      state = 0;
 60e:	4981                	li	s3,0
 610:	b765                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 612:	008b0913          	addi	s2,s6,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000b2583          	lw	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e8e080e7          	jalr	-370(ra) # 4ae <printint>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b771                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b0913          	addi	s2,s6,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000b2583          	lw	a1,0(s6)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e72080e7          	jalr	-398(ra) # 4ae <printint>
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bf85                	j	5b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 64a:	008b0913          	addi	s2,s6,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000b2583          	lw	a1,0(s6)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e56080e7          	jalr	-426(ra) # 4ae <printint>
 660:	8b4a                	mv	s6,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bf91                	j	5b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 666:	008b0793          	addi	a5,s6,8
 66a:	f8f43423          	sd	a5,-120(s0)
 66e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e14080e7          	jalr	-492(ra) # 48c <putc>
  putc(fd, 'x');
 680:	85ea                	mv	a1,s10
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e08080e7          	jalr	-504(ra) # 48c <putc>
 68c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	df2080e7          	jalr	-526(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b721                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b2:	008b0993          	addi	s3,s6,8
 6b6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ba:	02090163          	beqz	s2,6dc <vprintf+0x184>
        while(*s != 0){
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c9a1                	beqz	a1,712 <vprintf+0x1ba>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dc6080e7          	jalr	-570(ra) # 48c <putc>
          s++;
 6ce:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d6:	8b4e                	mv	s6,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bdf9                	j	5b8 <vprintf+0x60>
          s = "(null)";
 6dc:	00000917          	auipc	s2,0x0
 6e0:	28490913          	addi	s2,s2,644 # 960 <malloc+0x13e>
        while(*s != 0){
 6e4:	02800593          	li	a1,40
 6e8:	bff1                	j	6c4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ea:	008b0913          	addi	s2,s6,8
 6ee:	000b4583          	lbu	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d98080e7          	jalr	-616(ra) # 48c <putc>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd65                	j	5b8 <vprintf+0x60>
        putc(fd, c);
 702:	85d2                	mv	a1,s4
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d86080e7          	jalr	-634(ra) # 48c <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b565                	j	5b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 712:	8b4e                	mv	s6,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b54d                	j	5b8 <vprintf+0x60>
    }
  }
}
 718:	70e6                	ld	ra,120(sp)
 71a:	7446                	ld	s0,112(sp)
 71c:	74a6                	ld	s1,104(sp)
 71e:	7906                	ld	s2,96(sp)
 720:	69e6                	ld	s3,88(sp)
 722:	6a46                	ld	s4,80(sp)
 724:	6aa6                	ld	s5,72(sp)
 726:	6b06                	ld	s6,64(sp)
 728:	7be2                	ld	s7,56(sp)
 72a:	7c42                	ld	s8,48(sp)
 72c:	7ca2                	ld	s9,40(sp)
 72e:	7d02                	ld	s10,32(sp)
 730:	6de2                	ld	s11,24(sp)
 732:	6109                	addi	sp,sp,128
 734:	8082                	ret

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	addi	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	8622                	mv	a2,s0
 754:	00000097          	auipc	ra,0x0
 758:	e04080e7          	jalr	-508(ra) # 558 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	00000097          	auipc	ra,0x0
 78e:	dce080e7          	jalr	-562(ra) # 558 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	1141                	addi	sp,sp,-16
 79c:	e422                	sd	s0,8(sp)
 79e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	00000797          	auipc	a5,0x0
 7a8:	1dc7b783          	ld	a5,476(a5) # 980 <freep>
 7ac:	a805                	j	7dc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ae:	4618                	lw	a4,8(a2)
 7b0:	9db9                	addw	a1,a1,a4
 7b2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	6318                	ld	a4,0(a4)
 7ba:	fee53823          	sd	a4,-16(a0)
 7be:	a091                	j	802 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9e39                	addw	a2,a2,a4
 7c6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053703          	ld	a4,-16(a0)
 7cc:	e398                	sd	a4,0(a5)
 7ce:	a099                	j	814 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x40>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x50>
{
 7da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x36>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059713          	slli	a4,a1,0x20
 7f4:	9301                	srli	a4,a4,0x20
 7f6:	0712                	slli	a4,a4,0x4
 7f8:	9736                	add	a4,a4,a3
 7fa:	fae60ae3          	beq	a2,a4,7ae <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 802:	4790                	lw	a2,8(a5)
 804:	02061713          	slli	a4,a2,0x20
 808:	9301                	srli	a4,a4,0x20
 80a:	0712                	slli	a4,a4,0x4
 80c:	973e                	add	a4,a4,a5
 80e:	fae689e3          	beq	a3,a4,7c0 <free+0x26>
  } else
    p->s.ptr = bp;
 812:	e394                	sd	a3,0(a5)
  freep = p;
 814:	00000717          	auipc	a4,0x0
 818:	16f73623          	sd	a5,364(a4) # 980 <freep>
}
 81c:	6422                	ld	s0,8(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f426                	sd	s1,40(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051493          	slli	s1,a0,0x20
 83a:	9081                	srli	s1,s1,0x20
 83c:	04bd                	addi	s1,s1,15
 83e:	8091                	srli	s1,s1,0x4
 840:	0014899b          	addiw	s3,s1,1
 844:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 846:	00000517          	auipc	a0,0x0
 84a:	13a53503          	ld	a0,314(a0) # 980 <freep>
 84e:	c515                	beqz	a0,87a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	02977f63          	bgeu	a4,s1,892 <malloc+0x70>
 858:	8a4e                	mv	s4,s3
 85a:	0009871b          	sext.w	a4,s3
 85e:	6685                	lui	a3,0x1
 860:	00d77363          	bgeu	a4,a3,866 <malloc+0x44>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86e:	00000917          	auipc	s2,0x0
 872:	11290913          	addi	s2,s2,274 # 980 <freep>
  if(p == (char*)-1)
 876:	5afd                	li	s5,-1
 878:	a88d                	j	8ea <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 87a:	00000797          	auipc	a5,0x0
 87e:	10e78793          	addi	a5,a5,270 # 988 <base>
 882:	00000717          	auipc	a4,0x0
 886:	0ef73f23          	sd	a5,254(a4) # 980 <freep>
 88a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 890:	b7e1                	j	858 <malloc+0x36>
      if(p->s.size == nunits)
 892:	02e48b63          	beq	s1,a4,8c8 <malloc+0xa6>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	1702                	slli	a4,a4,0x20
 89e:	9301                	srli	a4,a4,0x20
 8a0:	0712                	slli	a4,a4,0x4
 8a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	0ca73c23          	sd	a0,216(a4) # 980 <freep>
      return (void*)(p + 1);
 8b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	e118                	sd	a4,0(a0)
 8cc:	bff1                	j	8a8 <malloc+0x86>
  hp->s.size = nu;
 8ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d2:	0541                	addi	a0,a0,16
 8d4:	00000097          	auipc	ra,0x0
 8d8:	ec6080e7          	jalr	-314(ra) # 79a <free>
  return freep;
 8dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e0:	d971                	beqz	a0,8b4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	fa9776e3          	bgeu	a4,s1,892 <malloc+0x70>
    if(p == freep)
 8ea:	00093703          	ld	a4,0(s2)
 8ee:	853e                	mv	a0,a5
 8f0:	fef719e3          	bne	a4,a5,8e2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	00000097          	auipc	ra,0x0
 8fa:	ad4080e7          	jalr	-1324(ra) # 3ca <sbrk>
  if(p == (char*)-1)
 8fe:	fd5518e3          	bne	a0,s5,8ce <malloc+0xac>
        return 0;
 902:	4501                	li	a0,0
 904:	bf45                	j	8b4 <malloc+0x92>
