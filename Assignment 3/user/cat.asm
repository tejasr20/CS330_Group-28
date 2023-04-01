
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	9b890913          	addi	s2,s2,-1608 # 9c8 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	38c080e7          	jalr	908(ra) # 3ac <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	380080e7          	jalr	896(ra) # 3b4 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	91858593          	addi	a1,a1,-1768 # 958 <malloc+0xe4>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	73e080e7          	jalr	1854(ra) # 788 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	340080e7          	jalr	832(ra) # 394 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	90258593          	addi	a1,a1,-1790 # 970 <malloc+0xfc>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	710080e7          	jalr	1808(ra) # 788 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	312080e7          	jalr	786(ra) # 394 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	31a080e7          	jalr	794(ra) # 3d4 <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2ea080e7          	jalr	746(ra) # 3bc <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2b2080e7          	jalr	690(ra) # 394 <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	29e080e7          	jalr	670(ra) # 394 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	88658593          	addi	a1,a1,-1914 # 988 <malloc+0x114>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	67c080e7          	jalr	1660(ra) # 788 <fprintf>
      exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	27e080e7          	jalr	638(ra) # 394 <exit>

000000000000011e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ce09                	beqz	a2,1b0 <memset+0x20>
 198:	87aa                	mv	a5,a0
 19a:	fff6071b          	addiw	a4,a2,-1
 19e:	1702                	slli	a4,a4,0x20
 1a0:	9301                	srli	a4,a4,0x20
 1a2:	0705                	addi	a4,a4,1
 1a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x16>
  }
  return dst;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cb99                	beqz	a5,1d6 <strchr+0x20>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1a>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  return 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strchr+0x1a>

00000000000001da <gets>:

char*
gets(char *buf, int max)
{
 1da:	711d                	addi	sp,sp,-96
 1dc:	ec86                	sd	ra,88(sp)
 1de:	e8a2                	sd	s0,80(sp)
 1e0:	e4a6                	sd	s1,72(sp)
 1e2:	e0ca                	sd	s2,64(sp)
 1e4:	fc4e                	sd	s3,56(sp)
 1e6:	f852                	sd	s4,48(sp)
 1e8:	f456                	sd	s5,40(sp)
 1ea:	f05a                	sd	s6,32(sp)
 1ec:	ec5e                	sd	s7,24(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f8:	4aa9                	li	s5,10
 1fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fc:	89a6                	mv	s3,s1
 1fe:	2485                	addiw	s1,s1,1
 200:	0344d863          	bge	s1,s4,230 <gets+0x56>
    cc = read(0, &c, 1);
 204:	4605                	li	a2,1
 206:	faf40593          	addi	a1,s0,-81
 20a:	4501                	li	a0,0
 20c:	00000097          	auipc	ra,0x0
 210:	1a0080e7          	jalr	416(ra) # 3ac <read>
    if(cc < 1)
 214:	00a05e63          	blez	a0,230 <gets+0x56>
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 220:	01578763          	beq	a5,s5,22e <gets+0x54>
 224:	0905                	addi	s2,s2,1
 226:	fd679be3          	bne	a5,s6,1fc <gets+0x22>
  for(i=0; i+1 < max; ){
 22a:	89a6                	mv	s3,s1
 22c:	a011                	j	230 <gets+0x56>
 22e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 230:	99de                	add	s3,s3,s7
 232:	00098023          	sb	zero,0(s3)
  return buf;
}
 236:	855e                	mv	a0,s7
 238:	60e6                	ld	ra,88(sp)
 23a:	6446                	ld	s0,80(sp)
 23c:	64a6                	ld	s1,72(sp)
 23e:	6906                	ld	s2,64(sp)
 240:	79e2                	ld	s3,56(sp)
 242:	7a42                	ld	s4,48(sp)
 244:	7aa2                	ld	s5,40(sp)
 246:	7b02                	ld	s6,32(sp)
 248:	6be2                	ld	s7,24(sp)
 24a:	6125                	addi	sp,sp,96
 24c:	8082                	ret

000000000000024e <stat>:

int
stat(const char *n, struct stat *st)
{
 24e:	1101                	addi	sp,sp,-32
 250:	ec06                	sd	ra,24(sp)
 252:	e822                	sd	s0,16(sp)
 254:	e426                	sd	s1,8(sp)
 256:	e04a                	sd	s2,0(sp)
 258:	1000                	addi	s0,sp,32
 25a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25c:	4581                	li	a1,0
 25e:	00000097          	auipc	ra,0x0
 262:	176080e7          	jalr	374(ra) # 3d4 <open>
  if(fd < 0)
 266:	02054563          	bltz	a0,290 <stat+0x42>
 26a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26c:	85ca                	mv	a1,s2
 26e:	00000097          	auipc	ra,0x0
 272:	17e080e7          	jalr	382(ra) # 3ec <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	00000097          	auipc	ra,0x0
 27e:	142080e7          	jalr	322(ra) # 3bc <close>
  return r;
}
 282:	854a                	mv	a0,s2
 284:	60e2                	ld	ra,24(sp)
 286:	6442                	ld	s0,16(sp)
 288:	64a2                	ld	s1,8(sp)
 28a:	6902                	ld	s2,0(sp)
 28c:	6105                	addi	sp,sp,32
 28e:	8082                	ret
    return -1;
 290:	597d                	li	s2,-1
 292:	bfc5                	j	282 <stat+0x34>

0000000000000294 <atoi>:

int
atoi(const char *s)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054603          	lbu	a2,0(a0)
 29e:	fd06079b          	addiw	a5,a2,-48
 2a2:	0ff7f793          	andi	a5,a5,255
 2a6:	4725                	li	a4,9
 2a8:	02f76963          	bltu	a4,a5,2da <atoi+0x46>
 2ac:	86aa                	mv	a3,a0
  n = 0;
 2ae:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2b0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2b2:	0685                	addi	a3,a3,1
 2b4:	0025179b          	slliw	a5,a0,0x2
 2b8:	9fa9                	addw	a5,a5,a0
 2ba:	0017979b          	slliw	a5,a5,0x1
 2be:	9fb1                	addw	a5,a5,a2
 2c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c4:	0006c603          	lbu	a2,0(a3)
 2c8:	fd06071b          	addiw	a4,a2,-48
 2cc:	0ff77713          	andi	a4,a4,255
 2d0:	fee5f1e3          	bgeu	a1,a4,2b2 <atoi+0x1e>
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <atoi+0x40>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57663          	bgeu	a0,a1,310 <memmove+0x32>
    while(n-- > 0)
 2e8:	02c05163          	blez	a2,30a <memmove+0x2c>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	0785                	addi	a5,a5,1
 2f6:	97aa                	add	a5,a5,a0
  dst = vdst;
 2f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fa:	0585                	addi	a1,a1,1
 2fc:	0705                	addi	a4,a4,1
 2fe:	fff5c683          	lbu	a3,-1(a1)
 302:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 316:	fec05ae3          	blez	a2,30a <memmove+0x2c>
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 334:	fee79ae3          	bne	a5,a4,328 <memmove+0x4a>
 338:	bfc9                	j	30a <memmove+0x2c>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	ca05                	beqz	a2,370 <memcmp+0x36>
 342:	fff6069b          	addiw	a3,a2,-1
 346:	1682                	slli	a3,a3,0x20
 348:	9281                	srli	a3,a3,0x20
 34a:	0685                	addi	a3,a3,1
 34c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34e:	00054783          	lbu	a5,0(a0)
 352:	0005c703          	lbu	a4,0(a1)
 356:	00e79863          	bne	a5,a4,366 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35a:	0505                	addi	a0,a0,1
    p2++;
 35c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35e:	fed518e3          	bne	a0,a3,34e <memcmp+0x14>
  }
  return 0;
 362:	4501                	li	a0,0
 364:	a019                	j	36a <memcmp+0x30>
      return *p1 - *p2;
 366:	40e7853b          	subw	a0,a5,a4
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <memcmp+0x30>

0000000000000374 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37c:	00000097          	auipc	ra,0x0
 380:	f62080e7          	jalr	-158(ra) # 2de <memmove>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 434:	48d9                	li	a7,22
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <yield>:
.global yield
yield:
 li a7, SYS_yield
 43c:	48dd                	li	a7,23
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 444:	48e1                	li	a7,24
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 44c:	48e5                	li	a7,25
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 454:	48e9                	li	a7,26
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <ps>:
.global ps
ps:
 li a7, SYS_ps
 45c:	48ed                	li	a7,27
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 464:	48f1                	li	a7,28
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 46c:	48f5                	li	a7,29
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 474:	48f9                	li	a7,30
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 47c:	48fd                	li	a7,31
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 484:	02000893          	li	a7,32
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 48e:	02100893          	li	a7,33
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 498:	02200893          	li	a7,34
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 4a2:	02300893          	li	a7,35
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 4ac:	02500893          	li	a7,37
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 4b6:	02400893          	li	a7,36
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 4c0:	02600893          	li	a7,38
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 4ca:	02800893          	li	a7,40
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 4d4:	02700893          	li	a7,39
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4de:	1101                	addi	sp,sp,-32
 4e0:	ec06                	sd	ra,24(sp)
 4e2:	e822                	sd	s0,16(sp)
 4e4:	1000                	addi	s0,sp,32
 4e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ea:	4605                	li	a2,1
 4ec:	fef40593          	addi	a1,s0,-17
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ec4080e7          	jalr	-316(ra) # 3b4 <write>
}
 4f8:	60e2                	ld	ra,24(sp)
 4fa:	6442                	ld	s0,16(sp)
 4fc:	6105                	addi	sp,sp,32
 4fe:	8082                	ret

0000000000000500 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	7139                	addi	sp,sp,-64
 502:	fc06                	sd	ra,56(sp)
 504:	f822                	sd	s0,48(sp)
 506:	f426                	sd	s1,40(sp)
 508:	f04a                	sd	s2,32(sp)
 50a:	ec4e                	sd	s3,24(sp)
 50c:	0080                	addi	s0,sp,64
 50e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 510:	c299                	beqz	a3,516 <printint+0x16>
 512:	0805c863          	bltz	a1,5a2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 516:	2581                	sext.w	a1,a1
  neg = 0;
 518:	4881                	li	a7,0
 51a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 51e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 520:	2601                	sext.w	a2,a2
 522:	00000517          	auipc	a0,0x0
 526:	48650513          	addi	a0,a0,1158 # 9a8 <digits>
 52a:	883a                	mv	a6,a4
 52c:	2705                	addiw	a4,a4,1
 52e:	02c5f7bb          	remuw	a5,a1,a2
 532:	1782                	slli	a5,a5,0x20
 534:	9381                	srli	a5,a5,0x20
 536:	97aa                	add	a5,a5,a0
 538:	0007c783          	lbu	a5,0(a5)
 53c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 540:	0005879b          	sext.w	a5,a1
 544:	02c5d5bb          	divuw	a1,a1,a2
 548:	0685                	addi	a3,a3,1
 54a:	fec7f0e3          	bgeu	a5,a2,52a <printint+0x2a>
  if(neg)
 54e:	00088b63          	beqz	a7,564 <printint+0x64>
    buf[i++] = '-';
 552:	fd040793          	addi	a5,s0,-48
 556:	973e                	add	a4,a4,a5
 558:	02d00793          	li	a5,45
 55c:	fef70823          	sb	a5,-16(a4)
 560:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 564:	02e05863          	blez	a4,594 <printint+0x94>
 568:	fc040793          	addi	a5,s0,-64
 56c:	00e78933          	add	s2,a5,a4
 570:	fff78993          	addi	s3,a5,-1
 574:	99ba                	add	s3,s3,a4
 576:	377d                	addiw	a4,a4,-1
 578:	1702                	slli	a4,a4,0x20
 57a:	9301                	srli	a4,a4,0x20
 57c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 580:	fff94583          	lbu	a1,-1(s2)
 584:	8526                	mv	a0,s1
 586:	00000097          	auipc	ra,0x0
 58a:	f58080e7          	jalr	-168(ra) # 4de <putc>
  while(--i >= 0)
 58e:	197d                	addi	s2,s2,-1
 590:	ff3918e3          	bne	s2,s3,580 <printint+0x80>
}
 594:	70e2                	ld	ra,56(sp)
 596:	7442                	ld	s0,48(sp)
 598:	74a2                	ld	s1,40(sp)
 59a:	7902                	ld	s2,32(sp)
 59c:	69e2                	ld	s3,24(sp)
 59e:	6121                	addi	sp,sp,64
 5a0:	8082                	ret
    x = -xx;
 5a2:	40b005bb          	negw	a1,a1
    neg = 1;
 5a6:	4885                	li	a7,1
    x = -xx;
 5a8:	bf8d                	j	51a <printint+0x1a>

00000000000005aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5aa:	7119                	addi	sp,sp,-128
 5ac:	fc86                	sd	ra,120(sp)
 5ae:	f8a2                	sd	s0,112(sp)
 5b0:	f4a6                	sd	s1,104(sp)
 5b2:	f0ca                	sd	s2,96(sp)
 5b4:	ecce                	sd	s3,88(sp)
 5b6:	e8d2                	sd	s4,80(sp)
 5b8:	e4d6                	sd	s5,72(sp)
 5ba:	e0da                	sd	s6,64(sp)
 5bc:	fc5e                	sd	s7,56(sp)
 5be:	f862                	sd	s8,48(sp)
 5c0:	f466                	sd	s9,40(sp)
 5c2:	f06a                	sd	s10,32(sp)
 5c4:	ec6e                	sd	s11,24(sp)
 5c6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c8:	0005c903          	lbu	s2,0(a1)
 5cc:	18090f63          	beqz	s2,76a <vprintf+0x1c0>
 5d0:	8aaa                	mv	s5,a0
 5d2:	8b32                	mv	s6,a2
 5d4:	00158493          	addi	s1,a1,1
  state = 0;
 5d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5da:	02500a13          	li	s4,37
      if(c == 'd'){
 5de:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5e2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5e6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5ea:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ee:	00000b97          	auipc	s7,0x0
 5f2:	3bab8b93          	addi	s7,s7,954 # 9a8 <digits>
 5f6:	a839                	j	614 <vprintf+0x6a>
        putc(fd, c);
 5f8:	85ca                	mv	a1,s2
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	ee2080e7          	jalr	-286(ra) # 4de <putc>
 604:	a019                	j	60a <vprintf+0x60>
    } else if(state == '%'){
 606:	01498f63          	beq	s3,s4,624 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 60a:	0485                	addi	s1,s1,1
 60c:	fff4c903          	lbu	s2,-1(s1)
 610:	14090d63          	beqz	s2,76a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 614:	0009079b          	sext.w	a5,s2
    if(state == 0){
 618:	fe0997e3          	bnez	s3,606 <vprintf+0x5c>
      if(c == '%'){
 61c:	fd479ee3          	bne	a5,s4,5f8 <vprintf+0x4e>
        state = '%';
 620:	89be                	mv	s3,a5
 622:	b7e5                	j	60a <vprintf+0x60>
      if(c == 'd'){
 624:	05878063          	beq	a5,s8,664 <vprintf+0xba>
      } else if(c == 'l') {
 628:	05978c63          	beq	a5,s9,680 <vprintf+0xd6>
      } else if(c == 'x') {
 62c:	07a78863          	beq	a5,s10,69c <vprintf+0xf2>
      } else if(c == 'p') {
 630:	09b78463          	beq	a5,s11,6b8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 634:	07300713          	li	a4,115
 638:	0ce78663          	beq	a5,a4,704 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63c:	06300713          	li	a4,99
 640:	0ee78e63          	beq	a5,a4,73c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 644:	11478863          	beq	a5,s4,754 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 648:	85d2                	mv	a1,s4
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e92080e7          	jalr	-366(ra) # 4de <putc>
        putc(fd, c);
 654:	85ca                	mv	a1,s2
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e86080e7          	jalr	-378(ra) # 4de <putc>
      }
      state = 0;
 660:	4981                	li	s3,0
 662:	b765                	j	60a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 664:	008b0913          	addi	s2,s6,8
 668:	4685                	li	a3,1
 66a:	4629                	li	a2,10
 66c:	000b2583          	lw	a1,0(s6)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e8e080e7          	jalr	-370(ra) # 500 <printint>
 67a:	8b4a                	mv	s6,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b771                	j	60a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	008b0913          	addi	s2,s6,8
 684:	4681                	li	a3,0
 686:	4629                	li	a2,10
 688:	000b2583          	lw	a1,0(s6)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	e72080e7          	jalr	-398(ra) # 500 <printint>
 696:	8b4a                	mv	s6,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	bf85                	j	60a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 69c:	008b0913          	addi	s2,s6,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000b2583          	lw	a1,0(s6)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e56080e7          	jalr	-426(ra) # 500 <printint>
 6b2:	8b4a                	mv	s6,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bf91                	j	60a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b8:	008b0793          	addi	a5,s6,8
 6bc:	f8f43423          	sd	a5,-120(s0)
 6c0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c4:	03000593          	li	a1,48
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e14080e7          	jalr	-492(ra) # 4de <putc>
  putc(fd, 'x');
 6d2:	85ea                	mv	a1,s10
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	e08080e7          	jalr	-504(ra) # 4de <putc>
 6de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e0:	03c9d793          	srli	a5,s3,0x3c
 6e4:	97de                	add	a5,a5,s7
 6e6:	0007c583          	lbu	a1,0(a5)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	df2080e7          	jalr	-526(ra) # 4de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f4:	0992                	slli	s3,s3,0x4
 6f6:	397d                	addiw	s2,s2,-1
 6f8:	fe0914e3          	bnez	s2,6e0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6fc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 700:	4981                	li	s3,0
 702:	b721                	j	60a <vprintf+0x60>
        s = va_arg(ap, char*);
 704:	008b0993          	addi	s3,s6,8
 708:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 70c:	02090163          	beqz	s2,72e <vprintf+0x184>
        while(*s != 0){
 710:	00094583          	lbu	a1,0(s2)
 714:	c9a1                	beqz	a1,764 <vprintf+0x1ba>
          putc(fd, *s);
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	dc6080e7          	jalr	-570(ra) # 4de <putc>
          s++;
 720:	0905                	addi	s2,s2,1
        while(*s != 0){
 722:	00094583          	lbu	a1,0(s2)
 726:	f9e5                	bnez	a1,716 <vprintf+0x16c>
        s = va_arg(ap, char*);
 728:	8b4e                	mv	s6,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bdf9                	j	60a <vprintf+0x60>
          s = "(null)";
 72e:	00000917          	auipc	s2,0x0
 732:	27290913          	addi	s2,s2,626 # 9a0 <malloc+0x12c>
        while(*s != 0){
 736:	02800593          	li	a1,40
 73a:	bff1                	j	716 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 73c:	008b0913          	addi	s2,s6,8
 740:	000b4583          	lbu	a1,0(s6)
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	d98080e7          	jalr	-616(ra) # 4de <putc>
 74e:	8b4a                	mv	s6,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	bd65                	j	60a <vprintf+0x60>
        putc(fd, c);
 754:	85d2                	mv	a1,s4
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	d86080e7          	jalr	-634(ra) # 4de <putc>
      state = 0;
 760:	4981                	li	s3,0
 762:	b565                	j	60a <vprintf+0x60>
        s = va_arg(ap, char*);
 764:	8b4e                	mv	s6,s3
      state = 0;
 766:	4981                	li	s3,0
 768:	b54d                	j	60a <vprintf+0x60>
    }
  }
}
 76a:	70e6                	ld	ra,120(sp)
 76c:	7446                	ld	s0,112(sp)
 76e:	74a6                	ld	s1,104(sp)
 770:	7906                	ld	s2,96(sp)
 772:	69e6                	ld	s3,88(sp)
 774:	6a46                	ld	s4,80(sp)
 776:	6aa6                	ld	s5,72(sp)
 778:	6b06                	ld	s6,64(sp)
 77a:	7be2                	ld	s7,56(sp)
 77c:	7c42                	ld	s8,48(sp)
 77e:	7ca2                	ld	s9,40(sp)
 780:	7d02                	ld	s10,32(sp)
 782:	6de2                	ld	s11,24(sp)
 784:	6109                	addi	sp,sp,128
 786:	8082                	ret

0000000000000788 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 788:	715d                	addi	sp,sp,-80
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e010                	sd	a2,0(s0)
 792:	e414                	sd	a3,8(s0)
 794:	e818                	sd	a4,16(s0)
 796:	ec1c                	sd	a5,24(s0)
 798:	03043023          	sd	a6,32(s0)
 79c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a4:	8622                	mv	a2,s0
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e04080e7          	jalr	-508(ra) # 5aa <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6161                	addi	sp,sp,80
 7b4:	8082                	ret

00000000000007b6 <printf>:

void
printf(const char *fmt, ...)
{
 7b6:	711d                	addi	sp,sp,-96
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e40c                	sd	a1,8(s0)
 7c0:	e810                	sd	a2,16(s0)
 7c2:	ec14                	sd	a3,24(s0)
 7c4:	f018                	sd	a4,32(s0)
 7c6:	f41c                	sd	a5,40(s0)
 7c8:	03043823          	sd	a6,48(s0)
 7cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	00840613          	addi	a2,s0,8
 7d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d8:	85aa                	mv	a1,a0
 7da:	4505                	li	a0,1
 7dc:	00000097          	auipc	ra,0x0
 7e0:	dce080e7          	jalr	-562(ra) # 5aa <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6125                	addi	sp,sp,96
 7ea:	8082                	ret

00000000000007ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ec:	1141                	addi	sp,sp,-16
 7ee:	e422                	sd	s0,8(sp)
 7f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	00000797          	auipc	a5,0x0
 7fa:	1ca7b783          	ld	a5,458(a5) # 9c0 <freep>
 7fe:	a805                	j	82e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 800:	4618                	lw	a4,8(a2)
 802:	9db9                	addw	a1,a1,a4
 804:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	6318                	ld	a4,0(a4)
 80c:	fee53823          	sd	a4,-16(a0)
 810:	a091                	j	854 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9e39                	addw	a2,a2,a4
 818:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053703          	ld	a4,-16(a0)
 81e:	e398                	sd	a4,0(a5)
 820:	a099                	j	866 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	6398                	ld	a4,0(a5)
 824:	00e7e463          	bltu	a5,a4,82c <free+0x40>
 828:	00e6ea63          	bltu	a3,a4,83c <free+0x50>
{
 82c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	fed7fae3          	bgeu	a5,a3,822 <free+0x36>
 832:	6398                	ld	a4,0(a5)
 834:	00e6e463          	bltu	a3,a4,83c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	fee7eae3          	bltu	a5,a4,82c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 83c:	ff852583          	lw	a1,-8(a0)
 840:	6390                	ld	a2,0(a5)
 842:	02059713          	slli	a4,a1,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	0712                	slli	a4,a4,0x4
 84a:	9736                	add	a4,a4,a3
 84c:	fae60ae3          	beq	a2,a4,800 <free+0x14>
    bp->s.ptr = p->s.ptr;
 850:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 854:	4790                	lw	a2,8(a5)
 856:	02061713          	slli	a4,a2,0x20
 85a:	9301                	srli	a4,a4,0x20
 85c:	0712                	slli	a4,a4,0x4
 85e:	973e                	add	a4,a4,a5
 860:	fae689e3          	beq	a3,a4,812 <free+0x26>
  } else
    p->s.ptr = bp;
 864:	e394                	sd	a3,0(a5)
  freep = p;
 866:	00000717          	auipc	a4,0x0
 86a:	14f73d23          	sd	a5,346(a4) # 9c0 <freep>
}
 86e:	6422                	ld	s0,8(sp)
 870:	0141                	addi	sp,sp,16
 872:	8082                	ret

0000000000000874 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 874:	7139                	addi	sp,sp,-64
 876:	fc06                	sd	ra,56(sp)
 878:	f822                	sd	s0,48(sp)
 87a:	f426                	sd	s1,40(sp)
 87c:	f04a                	sd	s2,32(sp)
 87e:	ec4e                	sd	s3,24(sp)
 880:	e852                	sd	s4,16(sp)
 882:	e456                	sd	s5,8(sp)
 884:	e05a                	sd	s6,0(sp)
 886:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 888:	02051493          	slli	s1,a0,0x20
 88c:	9081                	srli	s1,s1,0x20
 88e:	04bd                	addi	s1,s1,15
 890:	8091                	srli	s1,s1,0x4
 892:	0014899b          	addiw	s3,s1,1
 896:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 898:	00000517          	auipc	a0,0x0
 89c:	12853503          	ld	a0,296(a0) # 9c0 <freep>
 8a0:	c515                	beqz	a0,8cc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	02977f63          	bgeu	a4,s1,8e4 <malloc+0x70>
 8aa:	8a4e                	mv	s4,s3
 8ac:	0009871b          	sext.w	a4,s3
 8b0:	6685                	lui	a3,0x1
 8b2:	00d77363          	bgeu	a4,a3,8b8 <malloc+0x44>
 8b6:	6a05                	lui	s4,0x1
 8b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c0:	00000917          	auipc	s2,0x0
 8c4:	10090913          	addi	s2,s2,256 # 9c0 <freep>
  if(p == (char*)-1)
 8c8:	5afd                	li	s5,-1
 8ca:	a88d                	j	93c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8cc:	00000797          	auipc	a5,0x0
 8d0:	2fc78793          	addi	a5,a5,764 # bc8 <base>
 8d4:	00000717          	auipc	a4,0x0
 8d8:	0ef73623          	sd	a5,236(a4) # 9c0 <freep>
 8dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e2:	b7e1                	j	8aa <malloc+0x36>
      if(p->s.size == nunits)
 8e4:	02e48b63          	beq	s1,a4,91a <malloc+0xa6>
        p->s.size -= nunits;
 8e8:	4137073b          	subw	a4,a4,s3
 8ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ee:	1702                	slli	a4,a4,0x20
 8f0:	9301                	srli	a4,a4,0x20
 8f2:	0712                	slli	a4,a4,0x4
 8f4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fa:	00000717          	auipc	a4,0x0
 8fe:	0ca73323          	sd	a0,198(a4) # 9c0 <freep>
      return (void*)(p + 1);
 902:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 906:	70e2                	ld	ra,56(sp)
 908:	7442                	ld	s0,48(sp)
 90a:	74a2                	ld	s1,40(sp)
 90c:	7902                	ld	s2,32(sp)
 90e:	69e2                	ld	s3,24(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
 916:	6121                	addi	sp,sp,64
 918:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	e118                	sd	a4,0(a0)
 91e:	bff1                	j	8fa <malloc+0x86>
  hp->s.size = nu;
 920:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 924:	0541                	addi	a0,a0,16
 926:	00000097          	auipc	ra,0x0
 92a:	ec6080e7          	jalr	-314(ra) # 7ec <free>
  return freep;
 92e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 932:	d971                	beqz	a0,906 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 934:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 936:	4798                	lw	a4,8(a5)
 938:	fa9776e3          	bgeu	a4,s1,8e4 <malloc+0x70>
    if(p == freep)
 93c:	00093703          	ld	a4,0(s2)
 940:	853e                	mv	a0,a5
 942:	fef719e3          	bne	a4,a5,934 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 946:	8552                	mv	a0,s4
 948:	00000097          	auipc	ra,0x0
 94c:	ad4080e7          	jalr	-1324(ra) # 41c <sbrk>
  if(p == (char*)-1)
 950:	fd5518e3          	bne	a0,s5,920 <malloc+0xac>
        return 0;
 954:	4501                	li	a0,0
 956:	bf45                	j	906 <malloc+0x92>
