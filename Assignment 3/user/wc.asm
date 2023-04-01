
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	a13d8d93          	addi	s11,s11,-1517 # a41 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	998a0a13          	addi	s4,s4,-1640 # 9d0 <malloc+0xe4>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e8080e7          	jalr	488(ra) # 22e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	9ca58593          	addi	a1,a1,-1590 # a40 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3a2080e7          	jalr	930(ra) # 424 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	9b248493          	addi	s1,s1,-1614 # a40 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	93250513          	addi	a0,a0,-1742 # 9e8 <malloc+0xfc>
  be:	00000097          	auipc	ra,0x0
  c2:	770080e7          	jalr	1904(ra) # 82e <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	8f450513          	addi	a0,a0,-1804 # 9d8 <malloc+0xec>
  ec:	00000097          	auipc	ra,0x0
  f0:	742080e7          	jalr	1858(ra) # 82e <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	316080e7          	jalr	790(ra) # 40c <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	320080e7          	jalr	800(ra) # 44c <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2ee080e7          	jalr	750(ra) # 434 <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2b6080e7          	jalr	694(ra) # 40c <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	89a58593          	addi	a1,a1,-1894 # 9f8 <malloc+0x10c>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	29a080e7          	jalr	666(ra) # 40c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	88450513          	addi	a0,a0,-1916 # a00 <malloc+0x114>
 184:	00000097          	auipc	ra,0x0
 188:	6aa080e7          	jalr	1706(ra) # 82e <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	27e080e7          	jalr	638(ra) # 40c <exit>

0000000000000196 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ce09                	beqz	a2,228 <memset+0x20>
 210:	87aa                	mv	a5,a0
 212:	fff6071b          	addiw	a4,a2,-1
 216:	1702                	slli	a4,a4,0x20
 218:	9301                	srli	a4,a4,0x20
 21a:	0705                	addi	a4,a4,1
 21c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 21e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 222:	0785                	addi	a5,a5,1
 224:	fee79de3          	bne	a5,a4,21e <memset+0x16>
  }
  return dst;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strchr>:

char*
strchr(const char *s, char c)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  for(; *s; s++)
 234:	00054783          	lbu	a5,0(a0)
 238:	cb99                	beqz	a5,24e <strchr+0x20>
    if(*s == c)
 23a:	00f58763          	beq	a1,a5,248 <strchr+0x1a>
  for(; *s; s++)
 23e:	0505                	addi	a0,a0,1
 240:	00054783          	lbu	a5,0(a0)
 244:	fbfd                	bnez	a5,23a <strchr+0xc>
      return (char*)s;
  return 0;
 246:	4501                	li	a0,0
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  return 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strchr+0x1a>

0000000000000252 <gets>:

char*
gets(char *buf, int max)
{
 252:	711d                	addi	sp,sp,-96
 254:	ec86                	sd	ra,88(sp)
 256:	e8a2                	sd	s0,80(sp)
 258:	e4a6                	sd	s1,72(sp)
 25a:	e0ca                	sd	s2,64(sp)
 25c:	fc4e                	sd	s3,56(sp)
 25e:	f852                	sd	s4,48(sp)
 260:	f456                	sd	s5,40(sp)
 262:	f05a                	sd	s6,32(sp)
 264:	ec5e                	sd	s7,24(sp)
 266:	1080                	addi	s0,sp,96
 268:	8baa                	mv	s7,a0
 26a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	892a                	mv	s2,a0
 26e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 270:	4aa9                	li	s5,10
 272:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 274:	89a6                	mv	s3,s1
 276:	2485                	addiw	s1,s1,1
 278:	0344d863          	bge	s1,s4,2a8 <gets+0x56>
    cc = read(0, &c, 1);
 27c:	4605                	li	a2,1
 27e:	faf40593          	addi	a1,s0,-81
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	1a0080e7          	jalr	416(ra) # 424 <read>
    if(cc < 1)
 28c:	00a05e63          	blez	a0,2a8 <gets+0x56>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01578763          	beq	a5,s5,2a6 <gets+0x54>
 29c:	0905                	addi	s2,s2,1
 29e:	fd679be3          	bne	a5,s6,274 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a2:	89a6                	mv	s3,s1
 2a4:	a011                	j	2a8 <gets+0x56>
 2a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a8:	99de                	add	s3,s3,s7
 2aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ae:	855e                	mv	a0,s7
 2b0:	60e6                	ld	ra,88(sp)
 2b2:	6446                	ld	s0,80(sp)
 2b4:	64a6                	ld	s1,72(sp)
 2b6:	6906                	ld	s2,64(sp)
 2b8:	79e2                	ld	s3,56(sp)
 2ba:	7a42                	ld	s4,48(sp)
 2bc:	7aa2                	ld	s5,40(sp)
 2be:	7b02                	ld	s6,32(sp)
 2c0:	6be2                	ld	s7,24(sp)
 2c2:	6125                	addi	sp,sp,96
 2c4:	8082                	ret

00000000000002c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c6:	1101                	addi	sp,sp,-32
 2c8:	ec06                	sd	ra,24(sp)
 2ca:	e822                	sd	s0,16(sp)
 2cc:	e426                	sd	s1,8(sp)
 2ce:	e04a                	sd	s2,0(sp)
 2d0:	1000                	addi	s0,sp,32
 2d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d4:	4581                	li	a1,0
 2d6:	00000097          	auipc	ra,0x0
 2da:	176080e7          	jalr	374(ra) # 44c <open>
  if(fd < 0)
 2de:	02054563          	bltz	a0,308 <stat+0x42>
 2e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e4:	85ca                	mv	a1,s2
 2e6:	00000097          	auipc	ra,0x0
 2ea:	17e080e7          	jalr	382(ra) # 464 <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	00000097          	auipc	ra,0x0
 2f6:	142080e7          	jalr	322(ra) # 434 <close>
  return r;
}
 2fa:	854a                	mv	a0,s2
 2fc:	60e2                	ld	ra,24(sp)
 2fe:	6442                	ld	s0,16(sp)
 300:	64a2                	ld	s1,8(sp)
 302:	6902                	ld	s2,0(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    return -1;
 308:	597d                	li	s2,-1
 30a:	bfc5                	j	2fa <stat+0x34>

000000000000030c <atoi>:

int
atoi(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 312:	00054603          	lbu	a2,0(a0)
 316:	fd06079b          	addiw	a5,a2,-48
 31a:	0ff7f793          	andi	a5,a5,255
 31e:	4725                	li	a4,9
 320:	02f76963          	bltu	a4,a5,352 <atoi+0x46>
 324:	86aa                	mv	a3,a0
  n = 0;
 326:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 328:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 32a:	0685                	addi	a3,a3,1
 32c:	0025179b          	slliw	a5,a0,0x2
 330:	9fa9                	addw	a5,a5,a0
 332:	0017979b          	slliw	a5,a5,0x1
 336:	9fb1                	addw	a5,a5,a2
 338:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33c:	0006c603          	lbu	a2,0(a3)
 340:	fd06071b          	addiw	a4,a2,-48
 344:	0ff77713          	andi	a4,a4,255
 348:	fee5f1e3          	bgeu	a1,a4,32a <atoi+0x1e>
  return n;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  n = 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <atoi+0x40>

0000000000000356 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 35c:	02b57663          	bgeu	a0,a1,388 <memmove+0x32>
    while(n-- > 0)
 360:	02c05163          	blez	a2,382 <memmove+0x2c>
 364:	fff6079b          	addiw	a5,a2,-1
 368:	1782                	slli	a5,a5,0x20
 36a:	9381                	srli	a5,a5,0x20
 36c:	0785                	addi	a5,a5,1
 36e:	97aa                	add	a5,a5,a0
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fee79ae3          	bne	a5,a4,372 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
    dst += n;
 388:	00c50733          	add	a4,a0,a2
    src += n;
 38c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38e:	fec05ae3          	blez	a2,382 <memmove+0x2c>
 392:	fff6079b          	addiw	a5,a2,-1
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	fff7c793          	not	a5,a5
 39e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a0:	15fd                	addi	a1,a1,-1
 3a2:	177d                	addi	a4,a4,-1
 3a4:	0005c683          	lbu	a3,0(a1)
 3a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ac:	fee79ae3          	bne	a5,a4,3a0 <memmove+0x4a>
 3b0:	bfc9                	j	382 <memmove+0x2c>

00000000000003b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca05                	beqz	a2,3e8 <memcmp+0x36>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x14>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x30>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <memcmp+0x30>

00000000000003ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f62080e7          	jalr	-158(ra) # 356 <memmove>
}
 3fc:	60a2                	ld	ra,8(sp)
 3fe:	6402                	ld	s0,0(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 404:	4885                	li	a7,1
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <exit>:
.global exit
exit:
 li a7, SYS_exit
 40c:	4889                	li	a7,2
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <wait>:
.global wait
wait:
 li a7, SYS_wait
 414:	488d                	li	a7,3
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41c:	4891                	li	a7,4
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	4895                	li	a7,5
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <write>:
.global write
write:
 li a7, SYS_write
 42c:	48c1                	li	a7,16
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <close>:
.global close
close:
 li a7, SYS_close
 434:	48d5                	li	a7,21
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <kill>:
.global kill
kill:
 li a7, SYS_kill
 43c:	4899                	li	a7,6
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exec>:
.global exec
exec:
 li a7, SYS_exec
 444:	489d                	li	a7,7
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <open>:
.global open
open:
 li a7, SYS_open
 44c:	48bd                	li	a7,15
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 454:	48c5                	li	a7,17
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45c:	48c9                	li	a7,18
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 464:	48a1                	li	a7,8
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <link>:
.global link
link:
 li a7, SYS_link
 46c:	48cd                	li	a7,19
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 474:	48d1                	li	a7,20
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47c:	48a5                	li	a7,9
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dup>:
.global dup
dup:
 li a7, SYS_dup
 484:	48a9                	li	a7,10
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48c:	48ad                	li	a7,11
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 494:	48b1                	li	a7,12
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49c:	48b5                	li	a7,13
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a4:	48b9                	li	a7,14
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4ac:	48d9                	li	a7,22
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <yield>:
.global yield
yield:
 li a7, SYS_yield
 4b4:	48dd                	li	a7,23
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 4bc:	48e1                	li	a7,24
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 4c4:	48e5                	li	a7,25
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 4cc:	48e9                	li	a7,26
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 4d4:	48ed                	li	a7,27
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 4dc:	48f1                	li	a7,28
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 4e4:	48f5                	li	a7,29
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 4ec:	48f9                	li	a7,30
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 4f4:	48fd                	li	a7,31
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 4fc:	02000893          	li	a7,32
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 506:	02100893          	li	a7,33
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 510:	02200893          	li	a7,34
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 51a:	02300893          	li	a7,35
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 524:	02500893          	li	a7,37
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 52e:	02400893          	li	a7,36
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 538:	02600893          	li	a7,38
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 542:	02800893          	li	a7,40
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 54c:	02700893          	li	a7,39
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 556:	1101                	addi	sp,sp,-32
 558:	ec06                	sd	ra,24(sp)
 55a:	e822                	sd	s0,16(sp)
 55c:	1000                	addi	s0,sp,32
 55e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 562:	4605                	li	a2,1
 564:	fef40593          	addi	a1,s0,-17
 568:	00000097          	auipc	ra,0x0
 56c:	ec4080e7          	jalr	-316(ra) # 42c <write>
}
 570:	60e2                	ld	ra,24(sp)
 572:	6442                	ld	s0,16(sp)
 574:	6105                	addi	sp,sp,32
 576:	8082                	ret

0000000000000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	7139                	addi	sp,sp,-64
 57a:	fc06                	sd	ra,56(sp)
 57c:	f822                	sd	s0,48(sp)
 57e:	f426                	sd	s1,40(sp)
 580:	f04a                	sd	s2,32(sp)
 582:	ec4e                	sd	s3,24(sp)
 584:	0080                	addi	s0,sp,64
 586:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 588:	c299                	beqz	a3,58e <printint+0x16>
 58a:	0805c863          	bltz	a1,61a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58e:	2581                	sext.w	a1,a1
  neg = 0;
 590:	4881                	li	a7,0
 592:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 596:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 598:	2601                	sext.w	a2,a2
 59a:	00000517          	auipc	a0,0x0
 59e:	48650513          	addi	a0,a0,1158 # a20 <digits>
 5a2:	883a                	mv	a6,a4
 5a4:	2705                	addiw	a4,a4,1
 5a6:	02c5f7bb          	remuw	a5,a1,a2
 5aa:	1782                	slli	a5,a5,0x20
 5ac:	9381                	srli	a5,a5,0x20
 5ae:	97aa                	add	a5,a5,a0
 5b0:	0007c783          	lbu	a5,0(a5)
 5b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b8:	0005879b          	sext.w	a5,a1
 5bc:	02c5d5bb          	divuw	a1,a1,a2
 5c0:	0685                	addi	a3,a3,1
 5c2:	fec7f0e3          	bgeu	a5,a2,5a2 <printint+0x2a>
  if(neg)
 5c6:	00088b63          	beqz	a7,5dc <printint+0x64>
    buf[i++] = '-';
 5ca:	fd040793          	addi	a5,s0,-48
 5ce:	973e                	add	a4,a4,a5
 5d0:	02d00793          	li	a5,45
 5d4:	fef70823          	sb	a5,-16(a4)
 5d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5dc:	02e05863          	blez	a4,60c <printint+0x94>
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	00000097          	auipc	ra,0x0
 602:	f58080e7          	jalr	-168(ra) # 556 <putc>
  while(--i >= 0)
 606:	197d                	addi	s2,s2,-1
 608:	ff3918e3          	bne	s2,s3,5f8 <printint+0x80>
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	7902                	ld	s2,32(sp)
 614:	69e2                	ld	s3,24(sp)
 616:	6121                	addi	sp,sp,64
 618:	8082                	ret
    x = -xx;
 61a:	40b005bb          	negw	a1,a1
    neg = 1;
 61e:	4885                	li	a7,1
    x = -xx;
 620:	bf8d                	j	592 <printint+0x1a>

0000000000000622 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 622:	7119                	addi	sp,sp,-128
 624:	fc86                	sd	ra,120(sp)
 626:	f8a2                	sd	s0,112(sp)
 628:	f4a6                	sd	s1,104(sp)
 62a:	f0ca                	sd	s2,96(sp)
 62c:	ecce                	sd	s3,88(sp)
 62e:	e8d2                	sd	s4,80(sp)
 630:	e4d6                	sd	s5,72(sp)
 632:	e0da                	sd	s6,64(sp)
 634:	fc5e                	sd	s7,56(sp)
 636:	f862                	sd	s8,48(sp)
 638:	f466                	sd	s9,40(sp)
 63a:	f06a                	sd	s10,32(sp)
 63c:	ec6e                	sd	s11,24(sp)
 63e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 640:	0005c903          	lbu	s2,0(a1)
 644:	18090f63          	beqz	s2,7e2 <vprintf+0x1c0>
 648:	8aaa                	mv	s5,a0
 64a:	8b32                	mv	s6,a2
 64c:	00158493          	addi	s1,a1,1
  state = 0;
 650:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 652:	02500a13          	li	s4,37
      if(c == 'd'){
 656:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 65a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 65e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 662:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	3bab8b93          	addi	s7,s7,954 # a20 <digits>
 66e:	a839                	j	68c <vprintf+0x6a>
        putc(fd, c);
 670:	85ca                	mv	a1,s2
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	ee2080e7          	jalr	-286(ra) # 556 <putc>
 67c:	a019                	j	682 <vprintf+0x60>
    } else if(state == '%'){
 67e:	01498f63          	beq	s3,s4,69c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 682:	0485                	addi	s1,s1,1
 684:	fff4c903          	lbu	s2,-1(s1)
 688:	14090d63          	beqz	s2,7e2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 68c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 690:	fe0997e3          	bnez	s3,67e <vprintf+0x5c>
      if(c == '%'){
 694:	fd479ee3          	bne	a5,s4,670 <vprintf+0x4e>
        state = '%';
 698:	89be                	mv	s3,a5
 69a:	b7e5                	j	682 <vprintf+0x60>
      if(c == 'd'){
 69c:	05878063          	beq	a5,s8,6dc <vprintf+0xba>
      } else if(c == 'l') {
 6a0:	05978c63          	beq	a5,s9,6f8 <vprintf+0xd6>
      } else if(c == 'x') {
 6a4:	07a78863          	beq	a5,s10,714 <vprintf+0xf2>
      } else if(c == 'p') {
 6a8:	09b78463          	beq	a5,s11,730 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6ac:	07300713          	li	a4,115
 6b0:	0ce78663          	beq	a5,a4,77c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b4:	06300713          	li	a4,99
 6b8:	0ee78e63          	beq	a5,a4,7b4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6bc:	11478863          	beq	a5,s4,7cc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c0:	85d2                	mv	a1,s4
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e92080e7          	jalr	-366(ra) # 556 <putc>
        putc(fd, c);
 6cc:	85ca                	mv	a1,s2
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e86080e7          	jalr	-378(ra) # 556 <putc>
      }
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b765                	j	682 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6dc:	008b0913          	addi	s2,s6,8
 6e0:	4685                	li	a3,1
 6e2:	4629                	li	a2,10
 6e4:	000b2583          	lw	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e8e080e7          	jalr	-370(ra) # 578 <printint>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b771                	j	682 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000b2583          	lw	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e72080e7          	jalr	-398(ra) # 578 <printint>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	bf85                	j	682 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 714:	008b0913          	addi	s2,s6,8
 718:	4681                	li	a3,0
 71a:	4641                	li	a2,16
 71c:	000b2583          	lw	a1,0(s6)
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	e56080e7          	jalr	-426(ra) # 578 <printint>
 72a:	8b4a                	mv	s6,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bf91                	j	682 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 730:	008b0793          	addi	a5,s6,8
 734:	f8f43423          	sd	a5,-120(s0)
 738:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 73c:	03000593          	li	a1,48
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e14080e7          	jalr	-492(ra) # 556 <putc>
  putc(fd, 'x');
 74a:	85ea                	mv	a1,s10
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	e08080e7          	jalr	-504(ra) # 556 <putc>
 756:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 758:	03c9d793          	srli	a5,s3,0x3c
 75c:	97de                	add	a5,a5,s7
 75e:	0007c583          	lbu	a1,0(a5)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	df2080e7          	jalr	-526(ra) # 556 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76c:	0992                	slli	s3,s3,0x4
 76e:	397d                	addiw	s2,s2,-1
 770:	fe0914e3          	bnez	s2,758 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 774:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 778:	4981                	li	s3,0
 77a:	b721                	j	682 <vprintf+0x60>
        s = va_arg(ap, char*);
 77c:	008b0993          	addi	s3,s6,8
 780:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 784:	02090163          	beqz	s2,7a6 <vprintf+0x184>
        while(*s != 0){
 788:	00094583          	lbu	a1,0(s2)
 78c:	c9a1                	beqz	a1,7dc <vprintf+0x1ba>
          putc(fd, *s);
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	dc6080e7          	jalr	-570(ra) # 556 <putc>
          s++;
 798:	0905                	addi	s2,s2,1
        while(*s != 0){
 79a:	00094583          	lbu	a1,0(s2)
 79e:	f9e5                	bnez	a1,78e <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a0:	8b4e                	mv	s6,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bdf9                	j	682 <vprintf+0x60>
          s = "(null)";
 7a6:	00000917          	auipc	s2,0x0
 7aa:	27290913          	addi	s2,s2,626 # a18 <malloc+0x12c>
        while(*s != 0){
 7ae:	02800593          	li	a1,40
 7b2:	bff1                	j	78e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	000b4583          	lbu	a1,0(s6)
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	d98080e7          	jalr	-616(ra) # 556 <putc>
 7c6:	8b4a                	mv	s6,s2
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bd65                	j	682 <vprintf+0x60>
        putc(fd, c);
 7cc:	85d2                	mv	a1,s4
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	d86080e7          	jalr	-634(ra) # 556 <putc>
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b565                	j	682 <vprintf+0x60>
        s = va_arg(ap, char*);
 7dc:	8b4e                	mv	s6,s3
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b54d                	j	682 <vprintf+0x60>
    }
  }
}
 7e2:	70e6                	ld	ra,120(sp)
 7e4:	7446                	ld	s0,112(sp)
 7e6:	74a6                	ld	s1,104(sp)
 7e8:	7906                	ld	s2,96(sp)
 7ea:	69e6                	ld	s3,88(sp)
 7ec:	6a46                	ld	s4,80(sp)
 7ee:	6aa6                	ld	s5,72(sp)
 7f0:	6b06                	ld	s6,64(sp)
 7f2:	7be2                	ld	s7,56(sp)
 7f4:	7c42                	ld	s8,48(sp)
 7f6:	7ca2                	ld	s9,40(sp)
 7f8:	7d02                	ld	s10,32(sp)
 7fa:	6de2                	ld	s11,24(sp)
 7fc:	6109                	addi	sp,sp,128
 7fe:	8082                	ret

0000000000000800 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 800:	715d                	addi	sp,sp,-80
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	addi	s0,sp,32
 808:	e010                	sd	a2,0(s0)
 80a:	e414                	sd	a3,8(s0)
 80c:	e818                	sd	a4,16(s0)
 80e:	ec1c                	sd	a5,24(s0)
 810:	03043023          	sd	a6,32(s0)
 814:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81c:	8622                	mv	a2,s0
 81e:	00000097          	auipc	ra,0x0
 822:	e04080e7          	jalr	-508(ra) # 622 <vprintf>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6161                	addi	sp,sp,80
 82c:	8082                	ret

000000000000082e <printf>:

void
printf(const char *fmt, ...)
{
 82e:	711d                	addi	sp,sp,-96
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e40c                	sd	a1,8(s0)
 838:	e810                	sd	a2,16(s0)
 83a:	ec14                	sd	a3,24(s0)
 83c:	f018                	sd	a4,32(s0)
 83e:	f41c                	sd	a5,40(s0)
 840:	03043823          	sd	a6,48(s0)
 844:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	00840613          	addi	a2,s0,8
 84c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 850:	85aa                	mv	a1,a0
 852:	4505                	li	a0,1
 854:	00000097          	auipc	ra,0x0
 858:	dce080e7          	jalr	-562(ra) # 622 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6125                	addi	sp,sp,96
 862:	8082                	ret

0000000000000864 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 864:	1141                	addi	sp,sp,-16
 866:	e422                	sd	s0,8(sp)
 868:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	00000797          	auipc	a5,0x0
 872:	1ca7b783          	ld	a5,458(a5) # a38 <freep>
 876:	a805                	j	8a6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 878:	4618                	lw	a4,8(a2)
 87a:	9db9                	addw	a1,a1,a4
 87c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	6318                	ld	a4,0(a4)
 884:	fee53823          	sd	a4,-16(a0)
 888:	a091                	j	8cc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88a:	ff852703          	lw	a4,-8(a0)
 88e:	9e39                	addw	a2,a2,a4
 890:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 892:	ff053703          	ld	a4,-16(a0)
 896:	e398                	sd	a4,0(a5)
 898:	a099                	j	8de <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89a:	6398                	ld	a4,0(a5)
 89c:	00e7e463          	bltu	a5,a4,8a4 <free+0x40>
 8a0:	00e6ea63          	bltu	a3,a4,8b4 <free+0x50>
{
 8a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a6:	fed7fae3          	bgeu	a5,a3,89a <free+0x36>
 8aa:	6398                	ld	a4,0(a5)
 8ac:	00e6e463          	bltu	a3,a4,8b4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	fee7eae3          	bltu	a5,a4,8a4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b4:	ff852583          	lw	a1,-8(a0)
 8b8:	6390                	ld	a2,0(a5)
 8ba:	02059713          	slli	a4,a1,0x20
 8be:	9301                	srli	a4,a4,0x20
 8c0:	0712                	slli	a4,a4,0x4
 8c2:	9736                	add	a4,a4,a3
 8c4:	fae60ae3          	beq	a2,a4,878 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8cc:	4790                	lw	a2,8(a5)
 8ce:	02061713          	slli	a4,a2,0x20
 8d2:	9301                	srli	a4,a4,0x20
 8d4:	0712                	slli	a4,a4,0x4
 8d6:	973e                	add	a4,a4,a5
 8d8:	fae689e3          	beq	a3,a4,88a <free+0x26>
  } else
    p->s.ptr = bp;
 8dc:	e394                	sd	a3,0(a5)
  freep = p;
 8de:	00000717          	auipc	a4,0x0
 8e2:	14f73d23          	sd	a5,346(a4) # a38 <freep>
}
 8e6:	6422                	ld	s0,8(sp)
 8e8:	0141                	addi	sp,sp,16
 8ea:	8082                	ret

00000000000008ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ec:	7139                	addi	sp,sp,-64
 8ee:	fc06                	sd	ra,56(sp)
 8f0:	f822                	sd	s0,48(sp)
 8f2:	f426                	sd	s1,40(sp)
 8f4:	f04a                	sd	s2,32(sp)
 8f6:	ec4e                	sd	s3,24(sp)
 8f8:	e852                	sd	s4,16(sp)
 8fa:	e456                	sd	s5,8(sp)
 8fc:	e05a                	sd	s6,0(sp)
 8fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 900:	02051493          	slli	s1,a0,0x20
 904:	9081                	srli	s1,s1,0x20
 906:	04bd                	addi	s1,s1,15
 908:	8091                	srli	s1,s1,0x4
 90a:	0014899b          	addiw	s3,s1,1
 90e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 910:	00000517          	auipc	a0,0x0
 914:	12853503          	ld	a0,296(a0) # a38 <freep>
 918:	c515                	beqz	a0,944 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91c:	4798                	lw	a4,8(a5)
 91e:	02977f63          	bgeu	a4,s1,95c <malloc+0x70>
 922:	8a4e                	mv	s4,s3
 924:	0009871b          	sext.w	a4,s3
 928:	6685                	lui	a3,0x1
 92a:	00d77363          	bgeu	a4,a3,930 <malloc+0x44>
 92e:	6a05                	lui	s4,0x1
 930:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 934:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 938:	00000917          	auipc	s2,0x0
 93c:	10090913          	addi	s2,s2,256 # a38 <freep>
  if(p == (char*)-1)
 940:	5afd                	li	s5,-1
 942:	a88d                	j	9b4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 944:	00000797          	auipc	a5,0x0
 948:	2fc78793          	addi	a5,a5,764 # c40 <base>
 94c:	00000717          	auipc	a4,0x0
 950:	0ef73623          	sd	a5,236(a4) # a38 <freep>
 954:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 956:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95a:	b7e1                	j	922 <malloc+0x36>
      if(p->s.size == nunits)
 95c:	02e48b63          	beq	s1,a4,992 <malloc+0xa6>
        p->s.size -= nunits;
 960:	4137073b          	subw	a4,a4,s3
 964:	c798                	sw	a4,8(a5)
        p += p->s.size;
 966:	1702                	slli	a4,a4,0x20
 968:	9301                	srli	a4,a4,0x20
 96a:	0712                	slli	a4,a4,0x4
 96c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 972:	00000717          	auipc	a4,0x0
 976:	0ca73323          	sd	a0,198(a4) # a38 <freep>
      return (void*)(p + 1);
 97a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 97e:	70e2                	ld	ra,56(sp)
 980:	7442                	ld	s0,48(sp)
 982:	74a2                	ld	s1,40(sp)
 984:	7902                	ld	s2,32(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	6121                	addi	sp,sp,64
 990:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 992:	6398                	ld	a4,0(a5)
 994:	e118                	sd	a4,0(a0)
 996:	bff1                	j	972 <malloc+0x86>
  hp->s.size = nu;
 998:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99c:	0541                	addi	a0,a0,16
 99e:	00000097          	auipc	ra,0x0
 9a2:	ec6080e7          	jalr	-314(ra) # 864 <free>
  return freep;
 9a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9aa:	d971                	beqz	a0,97e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ae:	4798                	lw	a4,8(a5)
 9b0:	fa9776e3          	bgeu	a4,s1,95c <malloc+0x70>
    if(p == freep)
 9b4:	00093703          	ld	a4,0(s2)
 9b8:	853e                	mv	a0,a5
 9ba:	fef719e3          	bne	a4,a5,9ac <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9be:	8552                	mv	a0,s4
 9c0:	00000097          	auipc	ra,0x0
 9c4:	ad4080e7          	jalr	-1324(ra) # 494 <sbrk>
  if(p == (char*)-1)
 9c8:	fd5518e3          	bne	a0,s5,998 <malloc+0xac>
        return 0;
 9cc:	4501                	li	a0,0
 9ce:	bf45                	j	97e <malloc+0x92>
