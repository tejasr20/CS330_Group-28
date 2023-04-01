
user/_barriertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	0880                	addi	s0,sp,80
  int i, j, n, r, barrier_id;

  if (argc != 3) {
  16:	478d                	li	a5,3
  18:	02f50063          	beq	a0,a5,38 <main+0x38>
     fprintf(2, "syntax: barriertest numprocs numrounds\nAborting...\n");
  1c:	00001597          	auipc	a1,0x1
  20:	92458593          	addi	a1,a1,-1756 # 940 <malloc+0xe6>
  24:	4509                	li	a0,2
  26:	00000097          	auipc	ra,0x0
  2a:	748080e7          	jalr	1864(ra) # 76e <fprintf>
     exit(0);
  2e:	4501                	li	a0,0
  30:	00000097          	auipc	ra,0x0
  34:	34a080e7          	jalr	842(ra) # 37a <exit>
  38:	84ae                	mv	s1,a1
  }

  n = atoi(argv[1]);
  3a:	6588                	ld	a0,8(a1)
  3c:	00000097          	auipc	ra,0x0
  40:	23e080e7          	jalr	574(ra) # 27a <atoi>
  44:	89aa                	mv	s3,a0
  r = atoi(argv[2]);
  46:	6888                	ld	a0,16(s1)
  48:	00000097          	auipc	ra,0x0
  4c:	232080e7          	jalr	562(ra) # 27a <atoi>
  50:	8aaa                	mv	s5,a0

  barrier_id = barrier_alloc();
  52:	00000097          	auipc	ra,0x0
  56:	418080e7          	jalr	1048(ra) # 46a <barrier_alloc>
  5a:	8a2a                	mv	s4,a0
  fprintf(1, "%d: got barrier array id %d\n\n", getpid(), barrier_id);
  5c:	00000097          	auipc	ra,0x0
  60:	39e080e7          	jalr	926(ra) # 3fa <getpid>
  64:	862a                	mv	a2,a0
  66:	86d2                	mv	a3,s4
  68:	00001597          	auipc	a1,0x1
  6c:	91058593          	addi	a1,a1,-1776 # 978 <malloc+0x11e>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	6fc080e7          	jalr	1788(ra) # 76e <fprintf>
  for (i=0; i<n-1; i++) {
  7a:	fff98b9b          	addiw	s7,s3,-1
  7e:	09705063          	blez	s7,fe <main+0xfe>
  82:	8b5e                	mv	s6,s7
  84:	4901                	li	s2,0
     if (fork() == 0) {
  86:	00000097          	auipc	ra,0x0
  8a:	2ec080e7          	jalr	748(ra) # 372 <fork>
  8e:	84aa                	mv	s1,a0
  90:	c531                	beqz	a0,dc <main+0xdc>
  for (i=0; i<n-1; i++) {
  92:	2905                	addiw	s2,s2,1
  94:	ff2b19e3          	bne	s6,s2,86 <main+0x86>
	}
	exit(0);
     }
  }
  
  for (j=0; j<r; j++) {
  98:	01505f63          	blez	s5,b6 <main+0xb6>
  9c:	4481                	li	s1,0
     barrier(j, barrier_id, n);
  9e:	864e                	mv	a2,s3
  a0:	85d2                	mv	a1,s4
  a2:	8526                	mv	a0,s1
  a4:	00000097          	auipc	ra,0x0
  a8:	3d0080e7          	jalr	976(ra) # 474 <barrier>
  for (j=0; j<r; j++) {
  ac:	2485                	addiw	s1,s1,1
  ae:	ff54c8e3          	blt	s1,s5,9e <main+0x9e>
  }
  for (i=0; i<n-1; i++) wait(0);
  b2:	01705b63          	blez	s7,c8 <main+0xc8>
  for (j=0; j<r; j++) {
  b6:	4481                	li	s1,0
  for (i=0; i<n-1; i++) wait(0);
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	2c8080e7          	jalr	712(ra) # 382 <wait>
  c2:	2485                	addiw	s1,s1,1
  c4:	ff74cae3          	blt	s1,s7,b8 <main+0xb8>
  barrier_free(barrier_id);
  c8:	8552                	mv	a0,s4
  ca:	00000097          	auipc	ra,0x0
  ce:	3b4080e7          	jalr	948(ra) # 47e <barrier_free>
  exit(0);
  d2:	4501                	li	a0,0
  d4:	00000097          	auipc	ra,0x0
  d8:	2a6080e7          	jalr	678(ra) # 37a <exit>
        for (j=0; j<r; j++) {
  dc:	01505c63          	blez	s5,f4 <main+0xf4>
	   barrier(j, barrier_id, n);
  e0:	864e                	mv	a2,s3
  e2:	85d2                	mv	a1,s4
  e4:	8526                	mv	a0,s1
  e6:	00000097          	auipc	ra,0x0
  ea:	38e080e7          	jalr	910(ra) # 474 <barrier>
        for (j=0; j<r; j++) {
  ee:	2485                	addiw	s1,s1,1
  f0:	fe9a98e3          	bne	s5,s1,e0 <main+0xe0>
	exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	284080e7          	jalr	644(ra) # 37a <exit>
  for (j=0; j<r; j++) {
  fe:	f9504fe3          	bgtz	s5,9c <main+0x9c>
 102:	b7d9                	j	c8 <main+0xc8>

0000000000000104 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10a:	87aa                	mv	a5,a0
 10c:	0585                	addi	a1,a1,1
 10e:	0785                	addi	a5,a5,1
 110:	fff5c703          	lbu	a4,-1(a1)
 114:	fee78fa3          	sb	a4,-1(a5)
 118:	fb75                	bnez	a4,10c <strcpy+0x8>
    ;
  return os;
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb91                	beqz	a5,13e <strcmp+0x1e>
 12c:	0005c703          	lbu	a4,0(a1)
 130:	00f71763          	bne	a4,a5,13e <strcmp+0x1e>
    p++, q++;
 134:	0505                	addi	a0,a0,1
 136:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbe5                	bnez	a5,12c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 13e:	0005c503          	lbu	a0,0(a1)
}
 142:	40a7853b          	subw	a0,a5,a0
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <strlen>:

uint
strlen(const char *s)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf91                	beqz	a5,172 <strlen+0x26>
 158:	0505                	addi	a0,a0,1
 15a:	87aa                	mv	a5,a0
 15c:	4685                	li	a3,1
 15e:	9e89                	subw	a3,a3,a0
 160:	00f6853b          	addw	a0,a3,a5
 164:	0785                	addi	a5,a5,1
 166:	fff7c703          	lbu	a4,-1(a5)
 16a:	fb7d                	bnez	a4,160 <strlen+0x14>
    ;
  return n;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for(n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfe5                	j	16c <strlen+0x20>

0000000000000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17c:	ce09                	beqz	a2,196 <memset+0x20>
 17e:	87aa                	mv	a5,a0
 180:	fff6071b          	addiw	a4,a2,-1
 184:	1702                	slli	a4,a4,0x20
 186:	9301                	srli	a4,a4,0x20
 188:	0705                	addi	a4,a4,1
 18a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 18c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 190:	0785                	addi	a5,a5,1
 192:	fee79de3          	bne	a5,a4,18c <memset+0x16>
  }
  return dst;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb99                	beqz	a5,1bc <strchr+0x20>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1a>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xc>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret
  return 0;
 1bc:	4501                	li	a0,0
 1be:	bfe5                	j	1b6 <strchr+0x1a>

00000000000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	711d                	addi	sp,sp,-96
 1c2:	ec86                	sd	ra,88(sp)
 1c4:	e8a2                	sd	s0,80(sp)
 1c6:	e4a6                	sd	s1,72(sp)
 1c8:	e0ca                	sd	s2,64(sp)
 1ca:	fc4e                	sd	s3,56(sp)
 1cc:	f852                	sd	s4,48(sp)
 1ce:	f456                	sd	s5,40(sp)
 1d0:	f05a                	sd	s6,32(sp)
 1d2:	ec5e                	sd	s7,24(sp)
 1d4:	1080                	addi	s0,sp,96
 1d6:	8baa                	mv	s7,a0
 1d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	892a                	mv	s2,a0
 1dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1de:	4aa9                	li	s5,10
 1e0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e2:	89a6                	mv	s3,s1
 1e4:	2485                	addiw	s1,s1,1
 1e6:	0344d863          	bge	s1,s4,216 <gets+0x56>
    cc = read(0, &c, 1);
 1ea:	4605                	li	a2,1
 1ec:	faf40593          	addi	a1,s0,-81
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	1a0080e7          	jalr	416(ra) # 392 <read>
    if(cc < 1)
 1fa:	00a05e63          	blez	a0,216 <gets+0x56>
    buf[i++] = c;
 1fe:	faf44783          	lbu	a5,-81(s0)
 202:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 206:	01578763          	beq	a5,s5,214 <gets+0x54>
 20a:	0905                	addi	s2,s2,1
 20c:	fd679be3          	bne	a5,s6,1e2 <gets+0x22>
  for(i=0; i+1 < max; ){
 210:	89a6                	mv	s3,s1
 212:	a011                	j	216 <gets+0x56>
 214:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 216:	99de                	add	s3,s3,s7
 218:	00098023          	sb	zero,0(s3)
  return buf;
}
 21c:	855e                	mv	a0,s7
 21e:	60e6                	ld	ra,88(sp)
 220:	6446                	ld	s0,80(sp)
 222:	64a6                	ld	s1,72(sp)
 224:	6906                	ld	s2,64(sp)
 226:	79e2                	ld	s3,56(sp)
 228:	7a42                	ld	s4,48(sp)
 22a:	7aa2                	ld	s5,40(sp)
 22c:	7b02                	ld	s6,32(sp)
 22e:	6be2                	ld	s7,24(sp)
 230:	6125                	addi	sp,sp,96
 232:	8082                	ret

0000000000000234 <stat>:

int
stat(const char *n, struct stat *st)
{
 234:	1101                	addi	sp,sp,-32
 236:	ec06                	sd	ra,24(sp)
 238:	e822                	sd	s0,16(sp)
 23a:	e426                	sd	s1,8(sp)
 23c:	e04a                	sd	s2,0(sp)
 23e:	1000                	addi	s0,sp,32
 240:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 242:	4581                	li	a1,0
 244:	00000097          	auipc	ra,0x0
 248:	176080e7          	jalr	374(ra) # 3ba <open>
  if(fd < 0)
 24c:	02054563          	bltz	a0,276 <stat+0x42>
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	00000097          	auipc	ra,0x0
 258:	17e080e7          	jalr	382(ra) # 3d2 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	00000097          	auipc	ra,0x0
 264:	142080e7          	jalr	322(ra) # 3a2 <close>
  return r;
}
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	64a2                	ld	s1,8(sp)
 270:	6902                	ld	s2,0(sp)
 272:	6105                	addi	sp,sp,32
 274:	8082                	ret
    return -1;
 276:	597d                	li	s2,-1
 278:	bfc5                	j	268 <stat+0x34>

000000000000027a <atoi>:

int
atoi(const char *s)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 280:	00054603          	lbu	a2,0(a0)
 284:	fd06079b          	addiw	a5,a2,-48
 288:	0ff7f793          	andi	a5,a5,255
 28c:	4725                	li	a4,9
 28e:	02f76963          	bltu	a4,a5,2c0 <atoi+0x46>
 292:	86aa                	mv	a3,a0
  n = 0;
 294:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 296:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 298:	0685                	addi	a3,a3,1
 29a:	0025179b          	slliw	a5,a0,0x2
 29e:	9fa9                	addw	a5,a5,a0
 2a0:	0017979b          	slliw	a5,a5,0x1
 2a4:	9fb1                	addw	a5,a5,a2
 2a6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2aa:	0006c603          	lbu	a2,0(a3)
 2ae:	fd06071b          	addiw	a4,a2,-48
 2b2:	0ff77713          	andi	a4,a4,255
 2b6:	fee5f1e3          	bgeu	a1,a4,298 <atoi+0x1e>
  return n;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  n = 0;
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <atoi+0x40>

00000000000002c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ca:	02b57663          	bgeu	a0,a1,2f6 <memmove+0x32>
    while(n-- > 0)
 2ce:	02c05163          	blez	a2,2f0 <memmove+0x2c>
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	0785                	addi	a5,a5,1
 2dc:	97aa                	add	a5,a5,a0
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x2c>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x4a>
 31e:	bfc9                	j	2f0 <memmove+0x2c>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	00000097          	auipc	ra,0x0
 366:	f62080e7          	jalr	-158(ra) # 2c4 <memmove>
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret

0000000000000372 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 372:	4885                	li	a7,1
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exit>:
.global exit
exit:
 li a7, SYS_exit
 37a:	4889                	li	a7,2
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <wait>:
.global wait
wait:
 li a7, SYS_wait
 382:	488d                	li	a7,3
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38a:	4891                	li	a7,4
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <read>:
.global read
read:
 li a7, SYS_read
 392:	4895                	li	a7,5
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <write>:
.global write
write:
 li a7, SYS_write
 39a:	48c1                	li	a7,16
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <close>:
.global close
close:
 li a7, SYS_close
 3a2:	48d5                	li	a7,21
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3aa:	4899                	li	a7,6
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b2:	489d                	li	a7,7
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c2:	48c5                	li	a7,17
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ca:	48c9                	li	a7,18
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ea:	48a5                	li	a7,9
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f2:	48a9                	li	a7,10
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fa:	48ad                	li	a7,11
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 402:	48b1                	li	a7,12
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40a:	48b5                	li	a7,13
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 412:	48b9                	li	a7,14
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 41a:	48d9                	li	a7,22
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <yield>:
.global yield
yield:
 li a7, SYS_yield
 422:	48dd                	li	a7,23
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 42a:	48e1                	li	a7,24
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 432:	48e5                	li	a7,25
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 43a:	48e9                	li	a7,26
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <ps>:
.global ps
ps:
 li a7, SYS_ps
 442:	48ed                	li	a7,27
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 44a:	48f1                	li	a7,28
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 452:	48f5                	li	a7,29
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 45a:	48f9                	li	a7,30
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 462:	48fd                	li	a7,31
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 46a:	02000893          	li	a7,32
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 474:	02100893          	li	a7,33
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 47e:	02200893          	li	a7,34
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 488:	02300893          	li	a7,35
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 492:	02500893          	li	a7,37
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 49c:	02400893          	li	a7,36
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 4a6:	02600893          	li	a7,38
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 4b0:	02800893          	li	a7,40
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 4ba:	02700893          	li	a7,39
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c4:	1101                	addi	sp,sp,-32
 4c6:	ec06                	sd	ra,24(sp)
 4c8:	e822                	sd	s0,16(sp)
 4ca:	1000                	addi	s0,sp,32
 4cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d0:	4605                	li	a2,1
 4d2:	fef40593          	addi	a1,s0,-17
 4d6:	00000097          	auipc	ra,0x0
 4da:	ec4080e7          	jalr	-316(ra) # 39a <write>
}
 4de:	60e2                	ld	ra,24(sp)
 4e0:	6442                	ld	s0,16(sp)
 4e2:	6105                	addi	sp,sp,32
 4e4:	8082                	ret

00000000000004e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e6:	7139                	addi	sp,sp,-64
 4e8:	fc06                	sd	ra,56(sp)
 4ea:	f822                	sd	s0,48(sp)
 4ec:	f426                	sd	s1,40(sp)
 4ee:	f04a                	sd	s2,32(sp)
 4f0:	ec4e                	sd	s3,24(sp)
 4f2:	0080                	addi	s0,sp,64
 4f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f6:	c299                	beqz	a3,4fc <printint+0x16>
 4f8:	0805c863          	bltz	a1,588 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fc:	2581                	sext.w	a1,a1
  neg = 0;
 4fe:	4881                	li	a7,0
 500:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 504:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 506:	2601                	sext.w	a2,a2
 508:	00000517          	auipc	a0,0x0
 50c:	49850513          	addi	a0,a0,1176 # 9a0 <digits>
 510:	883a                	mv	a6,a4
 512:	2705                	addiw	a4,a4,1
 514:	02c5f7bb          	remuw	a5,a1,a2
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	97aa                	add	a5,a5,a0
 51e:	0007c783          	lbu	a5,0(a5)
 522:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 526:	0005879b          	sext.w	a5,a1
 52a:	02c5d5bb          	divuw	a1,a1,a2
 52e:	0685                	addi	a3,a3,1
 530:	fec7f0e3          	bgeu	a5,a2,510 <printint+0x2a>
  if(neg)
 534:	00088b63          	beqz	a7,54a <printint+0x64>
    buf[i++] = '-';
 538:	fd040793          	addi	a5,s0,-48
 53c:	973e                	add	a4,a4,a5
 53e:	02d00793          	li	a5,45
 542:	fef70823          	sb	a5,-16(a4)
 546:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 54a:	02e05863          	blez	a4,57a <printint+0x94>
 54e:	fc040793          	addi	a5,s0,-64
 552:	00e78933          	add	s2,a5,a4
 556:	fff78993          	addi	s3,a5,-1
 55a:	99ba                	add	s3,s3,a4
 55c:	377d                	addiw	a4,a4,-1
 55e:	1702                	slli	a4,a4,0x20
 560:	9301                	srli	a4,a4,0x20
 562:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 566:	fff94583          	lbu	a1,-1(s2)
 56a:	8526                	mv	a0,s1
 56c:	00000097          	auipc	ra,0x0
 570:	f58080e7          	jalr	-168(ra) # 4c4 <putc>
  while(--i >= 0)
 574:	197d                	addi	s2,s2,-1
 576:	ff3918e3          	bne	s2,s3,566 <printint+0x80>
}
 57a:	70e2                	ld	ra,56(sp)
 57c:	7442                	ld	s0,48(sp)
 57e:	74a2                	ld	s1,40(sp)
 580:	7902                	ld	s2,32(sp)
 582:	69e2                	ld	s3,24(sp)
 584:	6121                	addi	sp,sp,64
 586:	8082                	ret
    x = -xx;
 588:	40b005bb          	negw	a1,a1
    neg = 1;
 58c:	4885                	li	a7,1
    x = -xx;
 58e:	bf8d                	j	500 <printint+0x1a>

0000000000000590 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 590:	7119                	addi	sp,sp,-128
 592:	fc86                	sd	ra,120(sp)
 594:	f8a2                	sd	s0,112(sp)
 596:	f4a6                	sd	s1,104(sp)
 598:	f0ca                	sd	s2,96(sp)
 59a:	ecce                	sd	s3,88(sp)
 59c:	e8d2                	sd	s4,80(sp)
 59e:	e4d6                	sd	s5,72(sp)
 5a0:	e0da                	sd	s6,64(sp)
 5a2:	fc5e                	sd	s7,56(sp)
 5a4:	f862                	sd	s8,48(sp)
 5a6:	f466                	sd	s9,40(sp)
 5a8:	f06a                	sd	s10,32(sp)
 5aa:	ec6e                	sd	s11,24(sp)
 5ac:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ae:	0005c903          	lbu	s2,0(a1)
 5b2:	18090f63          	beqz	s2,750 <vprintf+0x1c0>
 5b6:	8aaa                	mv	s5,a0
 5b8:	8b32                	mv	s6,a2
 5ba:	00158493          	addi	s1,a1,1
  state = 0;
 5be:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c0:	02500a13          	li	s4,37
      if(c == 'd'){
 5c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5c8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5cc:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5d0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d4:	00000b97          	auipc	s7,0x0
 5d8:	3ccb8b93          	addi	s7,s7,972 # 9a0 <digits>
 5dc:	a839                	j	5fa <vprintf+0x6a>
        putc(fd, c);
 5de:	85ca                	mv	a1,s2
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	ee2080e7          	jalr	-286(ra) # 4c4 <putc>
 5ea:	a019                	j	5f0 <vprintf+0x60>
    } else if(state == '%'){
 5ec:	01498f63          	beq	s3,s4,60a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5f0:	0485                	addi	s1,s1,1
 5f2:	fff4c903          	lbu	s2,-1(s1)
 5f6:	14090d63          	beqz	s2,750 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5fa:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5fe:	fe0997e3          	bnez	s3,5ec <vprintf+0x5c>
      if(c == '%'){
 602:	fd479ee3          	bne	a5,s4,5de <vprintf+0x4e>
        state = '%';
 606:	89be                	mv	s3,a5
 608:	b7e5                	j	5f0 <vprintf+0x60>
      if(c == 'd'){
 60a:	05878063          	beq	a5,s8,64a <vprintf+0xba>
      } else if(c == 'l') {
 60e:	05978c63          	beq	a5,s9,666 <vprintf+0xd6>
      } else if(c == 'x') {
 612:	07a78863          	beq	a5,s10,682 <vprintf+0xf2>
      } else if(c == 'p') {
 616:	09b78463          	beq	a5,s11,69e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 61a:	07300713          	li	a4,115
 61e:	0ce78663          	beq	a5,a4,6ea <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 622:	06300713          	li	a4,99
 626:	0ee78e63          	beq	a5,a4,722 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 62a:	11478863          	beq	a5,s4,73a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62e:	85d2                	mv	a1,s4
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e92080e7          	jalr	-366(ra) # 4c4 <putc>
        putc(fd, c);
 63a:	85ca                	mv	a1,s2
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e86080e7          	jalr	-378(ra) # 4c4 <putc>
      }
      state = 0;
 646:	4981                	li	s3,0
 648:	b765                	j	5f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 64a:	008b0913          	addi	s2,s6,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000b2583          	lw	a1,0(s6)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e8e080e7          	jalr	-370(ra) # 4e6 <printint>
 660:	8b4a                	mv	s6,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	b771                	j	5f0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	008b0913          	addi	s2,s6,8
 66a:	4681                	li	a3,0
 66c:	4629                	li	a2,10
 66e:	000b2583          	lw	a1,0(s6)
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e72080e7          	jalr	-398(ra) # 4e6 <printint>
 67c:	8b4a                	mv	s6,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bf85                	j	5f0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 682:	008b0913          	addi	s2,s6,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000b2583          	lw	a1,0(s6)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e56080e7          	jalr	-426(ra) # 4e6 <printint>
 698:	8b4a                	mv	s6,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bf91                	j	5f0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 69e:	008b0793          	addi	a5,s6,8
 6a2:	f8f43423          	sd	a5,-120(s0)
 6a6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6aa:	03000593          	li	a1,48
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e14080e7          	jalr	-492(ra) # 4c4 <putc>
  putc(fd, 'x');
 6b8:	85ea                	mv	a1,s10
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e08080e7          	jalr	-504(ra) # 4c4 <putc>
 6c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	03c9d793          	srli	a5,s3,0x3c
 6ca:	97de                	add	a5,a5,s7
 6cc:	0007c583          	lbu	a1,0(a5)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	df2080e7          	jalr	-526(ra) # 4c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6da:	0992                	slli	s3,s3,0x4
 6dc:	397d                	addiw	s2,s2,-1
 6de:	fe0914e3          	bnez	s2,6c6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6e2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b721                	j	5f0 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ea:	008b0993          	addi	s3,s6,8
 6ee:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6f2:	02090163          	beqz	s2,714 <vprintf+0x184>
        while(*s != 0){
 6f6:	00094583          	lbu	a1,0(s2)
 6fa:	c9a1                	beqz	a1,74a <vprintf+0x1ba>
          putc(fd, *s);
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	dc6080e7          	jalr	-570(ra) # 4c4 <putc>
          s++;
 706:	0905                	addi	s2,s2,1
        while(*s != 0){
 708:	00094583          	lbu	a1,0(s2)
 70c:	f9e5                	bnez	a1,6fc <vprintf+0x16c>
        s = va_arg(ap, char*);
 70e:	8b4e                	mv	s6,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	bdf9                	j	5f0 <vprintf+0x60>
          s = "(null)";
 714:	00000917          	auipc	s2,0x0
 718:	28490913          	addi	s2,s2,644 # 998 <malloc+0x13e>
        while(*s != 0){
 71c:	02800593          	li	a1,40
 720:	bff1                	j	6fc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 722:	008b0913          	addi	s2,s6,8
 726:	000b4583          	lbu	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	d98080e7          	jalr	-616(ra) # 4c4 <putc>
 734:	8b4a                	mv	s6,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bd65                	j	5f0 <vprintf+0x60>
        putc(fd, c);
 73a:	85d2                	mv	a1,s4
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	d86080e7          	jalr	-634(ra) # 4c4 <putc>
      state = 0;
 746:	4981                	li	s3,0
 748:	b565                	j	5f0 <vprintf+0x60>
        s = va_arg(ap, char*);
 74a:	8b4e                	mv	s6,s3
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b54d                	j	5f0 <vprintf+0x60>
    }
  }
}
 750:	70e6                	ld	ra,120(sp)
 752:	7446                	ld	s0,112(sp)
 754:	74a6                	ld	s1,104(sp)
 756:	7906                	ld	s2,96(sp)
 758:	69e6                	ld	s3,88(sp)
 75a:	6a46                	ld	s4,80(sp)
 75c:	6aa6                	ld	s5,72(sp)
 75e:	6b06                	ld	s6,64(sp)
 760:	7be2                	ld	s7,56(sp)
 762:	7c42                	ld	s8,48(sp)
 764:	7ca2                	ld	s9,40(sp)
 766:	7d02                	ld	s10,32(sp)
 768:	6de2                	ld	s11,24(sp)
 76a:	6109                	addi	sp,sp,128
 76c:	8082                	ret

000000000000076e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76e:	715d                	addi	sp,sp,-80
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e010                	sd	a2,0(s0)
 778:	e414                	sd	a3,8(s0)
 77a:	e818                	sd	a4,16(s0)
 77c:	ec1c                	sd	a5,24(s0)
 77e:	03043023          	sd	a6,32(s0)
 782:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78a:	8622                	mv	a2,s0
 78c:	00000097          	auipc	ra,0x0
 790:	e04080e7          	jalr	-508(ra) # 590 <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6161                	addi	sp,sp,80
 79a:	8082                	ret

000000000000079c <printf>:

void
printf(const char *fmt, ...)
{
 79c:	711d                	addi	sp,sp,-96
 79e:	ec06                	sd	ra,24(sp)
 7a0:	e822                	sd	s0,16(sp)
 7a2:	1000                	addi	s0,sp,32
 7a4:	e40c                	sd	a1,8(s0)
 7a6:	e810                	sd	a2,16(s0)
 7a8:	ec14                	sd	a3,24(s0)
 7aa:	f018                	sd	a4,32(s0)
 7ac:	f41c                	sd	a5,40(s0)
 7ae:	03043823          	sd	a6,48(s0)
 7b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b6:	00840613          	addi	a2,s0,8
 7ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7be:	85aa                	mv	a1,a0
 7c0:	4505                	li	a0,1
 7c2:	00000097          	auipc	ra,0x0
 7c6:	dce080e7          	jalr	-562(ra) # 590 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	1141                	addi	sp,sp,-16
 7d4:	e422                	sd	s0,8(sp)
 7d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	00000797          	auipc	a5,0x0
 7e0:	1dc7b783          	ld	a5,476(a5) # 9b8 <freep>
 7e4:	a805                	j	814 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e6:	4618                	lw	a4,8(a2)
 7e8:	9db9                	addw	a1,a1,a4
 7ea:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	6318                	ld	a4,0(a4)
 7f2:	fee53823          	sd	a4,-16(a0)
 7f6:	a091                	j	83a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f8:	ff852703          	lw	a4,-8(a0)
 7fc:	9e39                	addw	a2,a2,a4
 7fe:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 800:	ff053703          	ld	a4,-16(a0)
 804:	e398                	sd	a4,0(a5)
 806:	a099                	j	84c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	6398                	ld	a4,0(a5)
 80a:	00e7e463          	bltu	a5,a4,812 <free+0x40>
 80e:	00e6ea63          	bltu	a3,a4,822 <free+0x50>
{
 812:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	fed7fae3          	bgeu	a5,a3,808 <free+0x36>
 818:	6398                	ld	a4,0(a5)
 81a:	00e6e463          	bltu	a3,a4,822 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	fee7eae3          	bltu	a5,a4,812 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 822:	ff852583          	lw	a1,-8(a0)
 826:	6390                	ld	a2,0(a5)
 828:	02059713          	slli	a4,a1,0x20
 82c:	9301                	srli	a4,a4,0x20
 82e:	0712                	slli	a4,a4,0x4
 830:	9736                	add	a4,a4,a3
 832:	fae60ae3          	beq	a2,a4,7e6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 836:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 83a:	4790                	lw	a2,8(a5)
 83c:	02061713          	slli	a4,a2,0x20
 840:	9301                	srli	a4,a4,0x20
 842:	0712                	slli	a4,a4,0x4
 844:	973e                	add	a4,a4,a5
 846:	fae689e3          	beq	a3,a4,7f8 <free+0x26>
  } else
    p->s.ptr = bp;
 84a:	e394                	sd	a3,0(a5)
  freep = p;
 84c:	00000717          	auipc	a4,0x0
 850:	16f73623          	sd	a5,364(a4) # 9b8 <freep>
}
 854:	6422                	ld	s0,8(sp)
 856:	0141                	addi	sp,sp,16
 858:	8082                	ret

000000000000085a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85a:	7139                	addi	sp,sp,-64
 85c:	fc06                	sd	ra,56(sp)
 85e:	f822                	sd	s0,48(sp)
 860:	f426                	sd	s1,40(sp)
 862:	f04a                	sd	s2,32(sp)
 864:	ec4e                	sd	s3,24(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
 86c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86e:	02051493          	slli	s1,a0,0x20
 872:	9081                	srli	s1,s1,0x20
 874:	04bd                	addi	s1,s1,15
 876:	8091                	srli	s1,s1,0x4
 878:	0014899b          	addiw	s3,s1,1
 87c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87e:	00000517          	auipc	a0,0x0
 882:	13a53503          	ld	a0,314(a0) # 9b8 <freep>
 886:	c515                	beqz	a0,8b2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88a:	4798                	lw	a4,8(a5)
 88c:	02977f63          	bgeu	a4,s1,8ca <malloc+0x70>
 890:	8a4e                	mv	s4,s3
 892:	0009871b          	sext.w	a4,s3
 896:	6685                	lui	a3,0x1
 898:	00d77363          	bgeu	a4,a3,89e <malloc+0x44>
 89c:	6a05                	lui	s4,0x1
 89e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a6:	00000917          	auipc	s2,0x0
 8aa:	11290913          	addi	s2,s2,274 # 9b8 <freep>
  if(p == (char*)-1)
 8ae:	5afd                	li	s5,-1
 8b0:	a88d                	j	922 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8b2:	00000797          	auipc	a5,0x0
 8b6:	10e78793          	addi	a5,a5,270 # 9c0 <base>
 8ba:	00000717          	auipc	a4,0x0
 8be:	0ef73f23          	sd	a5,254(a4) # 9b8 <freep>
 8c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c8:	b7e1                	j	890 <malloc+0x36>
      if(p->s.size == nunits)
 8ca:	02e48b63          	beq	s1,a4,900 <malloc+0xa6>
        p->s.size -= nunits;
 8ce:	4137073b          	subw	a4,a4,s3
 8d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d4:	1702                	slli	a4,a4,0x20
 8d6:	9301                	srli	a4,a4,0x20
 8d8:	0712                	slli	a4,a4,0x4
 8da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	0ca73c23          	sd	a0,216(a4) # 9b8 <freep>
      return (void*)(p + 1);
 8e8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	7902                	ld	s2,32(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
 8fc:	6121                	addi	sp,sp,64
 8fe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	bff1                	j	8e0 <malloc+0x86>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	00000097          	auipc	ra,0x0
 910:	ec6080e7          	jalr	-314(ra) # 7d2 <free>
  return freep;
 914:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 918:	d971                	beqz	a0,8ec <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91c:	4798                	lw	a4,8(a5)
 91e:	fa9776e3          	bgeu	a4,s1,8ca <malloc+0x70>
    if(p == freep)
 922:	00093703          	ld	a4,0(s2)
 926:	853e                	mv	a0,a5
 928:	fef719e3          	bne	a4,a5,91a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 92c:	8552                	mv	a0,s4
 92e:	00000097          	auipc	ra,0x0
 932:	ad4080e7          	jalr	-1324(ra) # 402 <sbrk>
  if(p == (char*)-1)
 936:	fd5518e3          	bne	a0,s5,906 <malloc+0xac>
        return 0;
 93a:	4501                	li	a0,0
 93c:	bf45                	j	8ec <malloc+0x92>
