
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  int pipefd1[2], pipefd2[2], x;
  char y = '0';
   8:	03000793          	li	a5,48
   c:	fcf40fa3          	sb	a5,-33(s0)

  if (pipe(pipefd1) < 0) {
  10:	fe840513          	addi	a0,s0,-24
  14:	00000097          	auipc	ra,0x0
  18:	47c080e7          	jalr	1148(ra) # 490 <pipe>
  1c:	0a054863          	bltz	a0,cc <main+0xcc>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
     exit(0);
  }

  if (pipe(pipefd2) < 0) {
  20:	fe040513          	addi	a0,s0,-32
  24:	00000097          	auipc	ra,0x0
  28:	46c080e7          	jalr	1132(ra) # 490 <pipe>
  2c:	0a054e63          	bltz	a0,e8 <main+0xe8>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
     exit(0);
  }

  x = fork();
  30:	00000097          	auipc	ra,0x0
  34:	448080e7          	jalr	1096(ra) # 478 <fork>
  if (x < 0) {
  38:	0c054663          	bltz	a0,104 <main+0x104>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  3c:	10a05e63          	blez	a0,158 <main+0x158>
     if (write(pipefd1[1], &y, 1) < 0) {
  40:	4605                	li	a2,1
  42:	fdf40593          	addi	a1,s0,-33
  46:	fec42503          	lw	a0,-20(s0)
  4a:	00000097          	auipc	ra,0x0
  4e:	456080e7          	jalr	1110(ra) # 4a0 <write>
  52:	0c054763          	bltz	a0,120 <main+0x120>
        fprintf(2, "Error: cannot write to pipe\nAborting...\n");
	exit(0);
     }
     if (read(pipefd2[0], &y, 1) < 0) {
  56:	4605                	li	a2,1
  58:	fdf40593          	addi	a1,s0,-33
  5c:	fe042503          	lw	a0,-32(s0)
  60:	00000097          	auipc	ra,0x0
  64:	438080e7          	jalr	1080(ra) # 498 <read>
  68:	0c054a63          	bltz	a0,13c <main+0x13c>
        fprintf(2, "Error: cannot read from pipe\nAborting...\n");
        exit(0);
     }
     fprintf(1, "%d: received pong\n", getpid());
  6c:	00000097          	auipc	ra,0x0
  70:	494080e7          	jalr	1172(ra) # 500 <getpid>
  74:	862a                	mv	a2,a0
  76:	00001597          	auipc	a1,0x1
  7a:	a7a58593          	addi	a1,a1,-1414 # af0 <malloc+0x190>
  7e:	4505                	li	a0,1
  80:	00000097          	auipc	ra,0x0
  84:	7f4080e7          	jalr	2036(ra) # 874 <fprintf>
     close(pipefd1[0]);
  88:	fe842503          	lw	a0,-24(s0)
  8c:	00000097          	auipc	ra,0x0
  90:	41c080e7          	jalr	1052(ra) # 4a8 <close>
     close(pipefd1[1]);
  94:	fec42503          	lw	a0,-20(s0)
  98:	00000097          	auipc	ra,0x0
  9c:	410080e7          	jalr	1040(ra) # 4a8 <close>
     close(pipefd2[0]);
  a0:	fe042503          	lw	a0,-32(s0)
  a4:	00000097          	auipc	ra,0x0
  a8:	404080e7          	jalr	1028(ra) # 4a8 <close>
     close(pipefd2[1]);
  ac:	fe442503          	lw	a0,-28(s0)
  b0:	00000097          	auipc	ra,0x0
  b4:	3f8080e7          	jalr	1016(ra) # 4a8 <close>
     wait(0);
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	3ce080e7          	jalr	974(ra) # 488 <wait>
     close(pipefd1[1]);
     close(pipefd2[0]);
     close(pipefd2[1]);
  }

  exit(0);
  c2:	4501                	li	a0,0
  c4:	00000097          	auipc	ra,0x0
  c8:	3bc080e7          	jalr	956(ra) # 480 <exit>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
  cc:	00001597          	auipc	a1,0x1
  d0:	97c58593          	addi	a1,a1,-1668 # a48 <malloc+0xe8>
  d4:	4509                	li	a0,2
  d6:	00000097          	auipc	ra,0x0
  da:	79e080e7          	jalr	1950(ra) # 874 <fprintf>
     exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	3a0080e7          	jalr	928(ra) # 480 <exit>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
  e8:	00001597          	auipc	a1,0x1
  ec:	96058593          	addi	a1,a1,-1696 # a48 <malloc+0xe8>
  f0:	4509                	li	a0,2
  f2:	00000097          	auipc	ra,0x0
  f6:	782080e7          	jalr	1922(ra) # 874 <fprintf>
     exit(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	384080e7          	jalr	900(ra) # 480 <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
 104:	00001597          	auipc	a1,0x1
 108:	96c58593          	addi	a1,a1,-1684 # a70 <malloc+0x110>
 10c:	4509                	li	a0,2
 10e:	00000097          	auipc	ra,0x0
 112:	766080e7          	jalr	1894(ra) # 874 <fprintf>
     exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	368080e7          	jalr	872(ra) # 480 <exit>
        fprintf(2, "Error: cannot write to pipe\nAborting...\n");
 120:	00001597          	auipc	a1,0x1
 124:	97058593          	addi	a1,a1,-1680 # a90 <malloc+0x130>
 128:	4509                	li	a0,2
 12a:	00000097          	auipc	ra,0x0
 12e:	74a080e7          	jalr	1866(ra) # 874 <fprintf>
	exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	34c080e7          	jalr	844(ra) # 480 <exit>
        fprintf(2, "Error: cannot read from pipe\nAborting...\n");
 13c:	00001597          	auipc	a1,0x1
 140:	98458593          	addi	a1,a1,-1660 # ac0 <malloc+0x160>
 144:	4509                	li	a0,2
 146:	00000097          	auipc	ra,0x0
 14a:	72e080e7          	jalr	1838(ra) # 874 <fprintf>
        exit(0);
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	330080e7          	jalr	816(ra) # 480 <exit>
     if (read(pipefd1[0], &y, 1) < 0) {
 158:	4605                	li	a2,1
 15a:	fdf40593          	addi	a1,s0,-33
 15e:	fe842503          	lw	a0,-24(s0)
 162:	00000097          	auipc	ra,0x0
 166:	336080e7          	jalr	822(ra) # 498 <read>
 16a:	06054463          	bltz	a0,1d2 <main+0x1d2>
     fprintf(1, "%d: received ping\n", getpid());
 16e:	00000097          	auipc	ra,0x0
 172:	392080e7          	jalr	914(ra) # 500 <getpid>
 176:	862a                	mv	a2,a0
 178:	00001597          	auipc	a1,0x1
 17c:	99058593          	addi	a1,a1,-1648 # b08 <malloc+0x1a8>
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	6f2080e7          	jalr	1778(ra) # 874 <fprintf>
     if (write(pipefd2[1], &y, 1) < 0) {
 18a:	4605                	li	a2,1
 18c:	fdf40593          	addi	a1,s0,-33
 190:	fe442503          	lw	a0,-28(s0)
 194:	00000097          	auipc	ra,0x0
 198:	30c080e7          	jalr	780(ra) # 4a0 <write>
 19c:	04054963          	bltz	a0,1ee <main+0x1ee>
     close(pipefd1[0]);
 1a0:	fe842503          	lw	a0,-24(s0)
 1a4:	00000097          	auipc	ra,0x0
 1a8:	304080e7          	jalr	772(ra) # 4a8 <close>
     close(pipefd1[1]);
 1ac:	fec42503          	lw	a0,-20(s0)
 1b0:	00000097          	auipc	ra,0x0
 1b4:	2f8080e7          	jalr	760(ra) # 4a8 <close>
     close(pipefd2[0]);
 1b8:	fe042503          	lw	a0,-32(s0)
 1bc:	00000097          	auipc	ra,0x0
 1c0:	2ec080e7          	jalr	748(ra) # 4a8 <close>
     close(pipefd2[1]);
 1c4:	fe442503          	lw	a0,-28(s0)
 1c8:	00000097          	auipc	ra,0x0
 1cc:	2e0080e7          	jalr	736(ra) # 4a8 <close>
 1d0:	bdcd                	j	c2 <main+0xc2>
        fprintf(2, "Error: cannot read from pipe\nAborting...\n");
 1d2:	00001597          	auipc	a1,0x1
 1d6:	8ee58593          	addi	a1,a1,-1810 # ac0 <malloc+0x160>
 1da:	4509                	li	a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	698080e7          	jalr	1688(ra) # 874 <fprintf>
        exit(0);
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	29a080e7          	jalr	666(ra) # 480 <exit>
        fprintf(2, "Error: cannot write to pipe\nAborting...\n");
 1ee:	00001597          	auipc	a1,0x1
 1f2:	8a258593          	addi	a1,a1,-1886 # a90 <malloc+0x130>
 1f6:	4509                	li	a0,2
 1f8:	00000097          	auipc	ra,0x0
 1fc:	67c080e7          	jalr	1660(ra) # 874 <fprintf>
        exit(0);
 200:	4501                	li	a0,0
 202:	00000097          	auipc	ra,0x0
 206:	27e080e7          	jalr	638(ra) # 480 <exit>

000000000000020a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 210:	87aa                	mv	a5,a0
 212:	0585                	addi	a1,a1,1
 214:	0785                	addi	a5,a5,1
 216:	fff5c703          	lbu	a4,-1(a1)
 21a:	fee78fa3          	sb	a4,-1(a5)
 21e:	fb75                	bnez	a4,212 <strcpy+0x8>
    ;
  return os;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret

0000000000000226 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 22c:	00054783          	lbu	a5,0(a0)
 230:	cb91                	beqz	a5,244 <strcmp+0x1e>
 232:	0005c703          	lbu	a4,0(a1)
 236:	00f71763          	bne	a4,a5,244 <strcmp+0x1e>
    p++, q++;
 23a:	0505                	addi	a0,a0,1
 23c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 23e:	00054783          	lbu	a5,0(a0)
 242:	fbe5                	bnez	a5,232 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 244:	0005c503          	lbu	a0,0(a1)
}
 248:	40a7853b          	subw	a0,a5,a0
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <strlen>:

uint
strlen(const char *s)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	cf91                	beqz	a5,278 <strlen+0x26>
 25e:	0505                	addi	a0,a0,1
 260:	87aa                	mv	a5,a0
 262:	4685                	li	a3,1
 264:	9e89                	subw	a3,a3,a0
 266:	00f6853b          	addw	a0,a3,a5
 26a:	0785                	addi	a5,a5,1
 26c:	fff7c703          	lbu	a4,-1(a5)
 270:	fb7d                	bnez	a4,266 <strlen+0x14>
    ;
  return n;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  for(n = 0; s[n]; n++)
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <strlen+0x20>

000000000000027c <memset>:

void*
memset(void *dst, int c, uint n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 282:	ce09                	beqz	a2,29c <memset+0x20>
 284:	87aa                	mv	a5,a0
 286:	fff6071b          	addiw	a4,a2,-1
 28a:	1702                	slli	a4,a4,0x20
 28c:	9301                	srli	a4,a4,0x20
 28e:	0705                	addi	a4,a4,1
 290:	972a                	add	a4,a4,a0
    cdst[i] = c;
 292:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 296:	0785                	addi	a5,a5,1
 298:	fee79de3          	bne	a5,a4,292 <memset+0x16>
  }
  return dst;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <strchr>:

char*
strchr(const char *s, char c)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	cb99                	beqz	a5,2c2 <strchr+0x20>
    if(*s == c)
 2ae:	00f58763          	beq	a1,a5,2bc <strchr+0x1a>
  for(; *s; s++)
 2b2:	0505                	addi	a0,a0,1
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	fbfd                	bnez	a5,2ae <strchr+0xc>
      return (char*)s;
  return 0;
 2ba:	4501                	li	a0,0
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <strchr+0x1a>

00000000000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	711d                	addi	sp,sp,-96
 2c8:	ec86                	sd	ra,88(sp)
 2ca:	e8a2                	sd	s0,80(sp)
 2cc:	e4a6                	sd	s1,72(sp)
 2ce:	e0ca                	sd	s2,64(sp)
 2d0:	fc4e                	sd	s3,56(sp)
 2d2:	f852                	sd	s4,48(sp)
 2d4:	f456                	sd	s5,40(sp)
 2d6:	f05a                	sd	s6,32(sp)
 2d8:	ec5e                	sd	s7,24(sp)
 2da:	1080                	addi	s0,sp,96
 2dc:	8baa                	mv	s7,a0
 2de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e0:	892a                	mv	s2,a0
 2e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e4:	4aa9                	li	s5,10
 2e6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2e8:	89a6                	mv	s3,s1
 2ea:	2485                	addiw	s1,s1,1
 2ec:	0344d863          	bge	s1,s4,31c <gets+0x56>
    cc = read(0, &c, 1);
 2f0:	4605                	li	a2,1
 2f2:	faf40593          	addi	a1,s0,-81
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	1a0080e7          	jalr	416(ra) # 498 <read>
    if(cc < 1)
 300:	00a05e63          	blez	a0,31c <gets+0x56>
    buf[i++] = c;
 304:	faf44783          	lbu	a5,-81(s0)
 308:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 30c:	01578763          	beq	a5,s5,31a <gets+0x54>
 310:	0905                	addi	s2,s2,1
 312:	fd679be3          	bne	a5,s6,2e8 <gets+0x22>
  for(i=0; i+1 < max; ){
 316:	89a6                	mv	s3,s1
 318:	a011                	j	31c <gets+0x56>
 31a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 31c:	99de                	add	s3,s3,s7
 31e:	00098023          	sb	zero,0(s3)
  return buf;
}
 322:	855e                	mv	a0,s7
 324:	60e6                	ld	ra,88(sp)
 326:	6446                	ld	s0,80(sp)
 328:	64a6                	ld	s1,72(sp)
 32a:	6906                	ld	s2,64(sp)
 32c:	79e2                	ld	s3,56(sp)
 32e:	7a42                	ld	s4,48(sp)
 330:	7aa2                	ld	s5,40(sp)
 332:	7b02                	ld	s6,32(sp)
 334:	6be2                	ld	s7,24(sp)
 336:	6125                	addi	sp,sp,96
 338:	8082                	ret

000000000000033a <stat>:

int
stat(const char *n, struct stat *st)
{
 33a:	1101                	addi	sp,sp,-32
 33c:	ec06                	sd	ra,24(sp)
 33e:	e822                	sd	s0,16(sp)
 340:	e426                	sd	s1,8(sp)
 342:	e04a                	sd	s2,0(sp)
 344:	1000                	addi	s0,sp,32
 346:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 348:	4581                	li	a1,0
 34a:	00000097          	auipc	ra,0x0
 34e:	176080e7          	jalr	374(ra) # 4c0 <open>
  if(fd < 0)
 352:	02054563          	bltz	a0,37c <stat+0x42>
 356:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 358:	85ca                	mv	a1,s2
 35a:	00000097          	auipc	ra,0x0
 35e:	17e080e7          	jalr	382(ra) # 4d8 <fstat>
 362:	892a                	mv	s2,a0
  close(fd);
 364:	8526                	mv	a0,s1
 366:	00000097          	auipc	ra,0x0
 36a:	142080e7          	jalr	322(ra) # 4a8 <close>
  return r;
}
 36e:	854a                	mv	a0,s2
 370:	60e2                	ld	ra,24(sp)
 372:	6442                	ld	s0,16(sp)
 374:	64a2                	ld	s1,8(sp)
 376:	6902                	ld	s2,0(sp)
 378:	6105                	addi	sp,sp,32
 37a:	8082                	ret
    return -1;
 37c:	597d                	li	s2,-1
 37e:	bfc5                	j	36e <stat+0x34>

0000000000000380 <atoi>:

int
atoi(const char *s)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 386:	00054603          	lbu	a2,0(a0)
 38a:	fd06079b          	addiw	a5,a2,-48
 38e:	0ff7f793          	andi	a5,a5,255
 392:	4725                	li	a4,9
 394:	02f76963          	bltu	a4,a5,3c6 <atoi+0x46>
 398:	86aa                	mv	a3,a0
  n = 0;
 39a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 39c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 39e:	0685                	addi	a3,a3,1
 3a0:	0025179b          	slliw	a5,a0,0x2
 3a4:	9fa9                	addw	a5,a5,a0
 3a6:	0017979b          	slliw	a5,a5,0x1
 3aa:	9fb1                	addw	a5,a5,a2
 3ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3b0:	0006c603          	lbu	a2,0(a3)
 3b4:	fd06071b          	addiw	a4,a2,-48
 3b8:	0ff77713          	andi	a4,a4,255
 3bc:	fee5f1e3          	bgeu	a1,a4,39e <atoi+0x1e>
  return n;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  n = 0;
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <atoi+0x40>

00000000000003ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3d0:	02b57663          	bgeu	a0,a1,3fc <memmove+0x32>
    while(n-- > 0)
 3d4:	02c05163          	blez	a2,3f6 <memmove+0x2c>
 3d8:	fff6079b          	addiw	a5,a2,-1
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	0785                	addi	a5,a5,1
 3e2:	97aa                	add	a5,a5,a0
  dst = vdst;
 3e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3e6:	0585                	addi	a1,a1,1
 3e8:	0705                	addi	a4,a4,1
 3ea:	fff5c683          	lbu	a3,-1(a1)
 3ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3f2:	fee79ae3          	bne	a5,a4,3e6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
    dst += n;
 3fc:	00c50733          	add	a4,a0,a2
    src += n;
 400:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 402:	fec05ae3          	blez	a2,3f6 <memmove+0x2c>
 406:	fff6079b          	addiw	a5,a2,-1
 40a:	1782                	slli	a5,a5,0x20
 40c:	9381                	srli	a5,a5,0x20
 40e:	fff7c793          	not	a5,a5
 412:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 414:	15fd                	addi	a1,a1,-1
 416:	177d                	addi	a4,a4,-1
 418:	0005c683          	lbu	a3,0(a1)
 41c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 420:	fee79ae3          	bne	a5,a4,414 <memmove+0x4a>
 424:	bfc9                	j	3f6 <memmove+0x2c>

0000000000000426 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e422                	sd	s0,8(sp)
 42a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 42c:	ca05                	beqz	a2,45c <memcmp+0x36>
 42e:	fff6069b          	addiw	a3,a2,-1
 432:	1682                	slli	a3,a3,0x20
 434:	9281                	srli	a3,a3,0x20
 436:	0685                	addi	a3,a3,1
 438:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 43a:	00054783          	lbu	a5,0(a0)
 43e:	0005c703          	lbu	a4,0(a1)
 442:	00e79863          	bne	a5,a4,452 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 446:	0505                	addi	a0,a0,1
    p2++;
 448:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 44a:	fed518e3          	bne	a0,a3,43a <memcmp+0x14>
  }
  return 0;
 44e:	4501                	li	a0,0
 450:	a019                	j	456 <memcmp+0x30>
      return *p1 - *p2;
 452:	40e7853b          	subw	a0,a5,a4
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
  return 0;
 45c:	4501                	li	a0,0
 45e:	bfe5                	j	456 <memcmp+0x30>

0000000000000460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 460:	1141                	addi	sp,sp,-16
 462:	e406                	sd	ra,8(sp)
 464:	e022                	sd	s0,0(sp)
 466:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 468:	00000097          	auipc	ra,0x0
 46c:	f62080e7          	jalr	-158(ra) # 3ca <memmove>
}
 470:	60a2                	ld	ra,8(sp)
 472:	6402                	ld	s0,0(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 478:	4885                	li	a7,1
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <exit>:
.global exit
exit:
 li a7, SYS_exit
 480:	4889                	li	a7,2
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <wait>:
.global wait
wait:
 li a7, SYS_wait
 488:	488d                	li	a7,3
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 490:	4891                	li	a7,4
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <read>:
.global read
read:
 li a7, SYS_read
 498:	4895                	li	a7,5
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <write>:
.global write
write:
 li a7, SYS_write
 4a0:	48c1                	li	a7,16
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <close>:
.global close
close:
 li a7, SYS_close
 4a8:	48d5                	li	a7,21
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b0:	4899                	li	a7,6
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4b8:	489d                	li	a7,7
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <open>:
.global open
open:
 li a7, SYS_open
 4c0:	48bd                	li	a7,15
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4c8:	48c5                	li	a7,17
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d0:	48c9                	li	a7,18
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4d8:	48a1                	li	a7,8
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <link>:
.global link
link:
 li a7, SYS_link
 4e0:	48cd                	li	a7,19
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4e8:	48d1                	li	a7,20
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f0:	48a5                	li	a7,9
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4f8:	48a9                	li	a7,10
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 500:	48ad                	li	a7,11
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 508:	48b1                	li	a7,12
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 510:	48b5                	li	a7,13
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 518:	48b9                	li	a7,14
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 520:	48d9                	li	a7,22
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <yield>:
.global yield
yield:
 li a7, SYS_yield
 528:	48dd                	li	a7,23
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 530:	48e1                	li	a7,24
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 538:	48e5                	li	a7,25
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 540:	48e9                	li	a7,26
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <ps>:
.global ps
ps:
 li a7, SYS_ps
 548:	48ed                	li	a7,27
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 550:	48f1                	li	a7,28
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 558:	48f5                	li	a7,29
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 560:	48f9                	li	a7,30
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 568:	48fd                	li	a7,31
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 570:	02000893          	li	a7,32
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 57a:	02100893          	li	a7,33
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 584:	02200893          	li	a7,34
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 58e:	02300893          	li	a7,35
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 598:	02500893          	li	a7,37
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 5a2:	02400893          	li	a7,36
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 5ac:	02600893          	li	a7,38
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 5b6:	02800893          	li	a7,40
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 5c0:	02700893          	li	a7,39
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ca:	1101                	addi	sp,sp,-32
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	e822                	sd	s0,16(sp)
 5d0:	1000                	addi	s0,sp,32
 5d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d6:	4605                	li	a2,1
 5d8:	fef40593          	addi	a1,s0,-17
 5dc:	00000097          	auipc	ra,0x0
 5e0:	ec4080e7          	jalr	-316(ra) # 4a0 <write>
}
 5e4:	60e2                	ld	ra,24(sp)
 5e6:	6442                	ld	s0,16(sp)
 5e8:	6105                	addi	sp,sp,32
 5ea:	8082                	ret

00000000000005ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ec:	7139                	addi	sp,sp,-64
 5ee:	fc06                	sd	ra,56(sp)
 5f0:	f822                	sd	s0,48(sp)
 5f2:	f426                	sd	s1,40(sp)
 5f4:	f04a                	sd	s2,32(sp)
 5f6:	ec4e                	sd	s3,24(sp)
 5f8:	0080                	addi	s0,sp,64
 5fa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5fc:	c299                	beqz	a3,602 <printint+0x16>
 5fe:	0805c863          	bltz	a1,68e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 602:	2581                	sext.w	a1,a1
  neg = 0;
 604:	4881                	li	a7,0
 606:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 60a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 60c:	2601                	sext.w	a2,a2
 60e:	00000517          	auipc	a0,0x0
 612:	51a50513          	addi	a0,a0,1306 # b28 <digits>
 616:	883a                	mv	a6,a4
 618:	2705                	addiw	a4,a4,1
 61a:	02c5f7bb          	remuw	a5,a1,a2
 61e:	1782                	slli	a5,a5,0x20
 620:	9381                	srli	a5,a5,0x20
 622:	97aa                	add	a5,a5,a0
 624:	0007c783          	lbu	a5,0(a5)
 628:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 62c:	0005879b          	sext.w	a5,a1
 630:	02c5d5bb          	divuw	a1,a1,a2
 634:	0685                	addi	a3,a3,1
 636:	fec7f0e3          	bgeu	a5,a2,616 <printint+0x2a>
  if(neg)
 63a:	00088b63          	beqz	a7,650 <printint+0x64>
    buf[i++] = '-';
 63e:	fd040793          	addi	a5,s0,-48
 642:	973e                	add	a4,a4,a5
 644:	02d00793          	li	a5,45
 648:	fef70823          	sb	a5,-16(a4)
 64c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 650:	02e05863          	blez	a4,680 <printint+0x94>
 654:	fc040793          	addi	a5,s0,-64
 658:	00e78933          	add	s2,a5,a4
 65c:	fff78993          	addi	s3,a5,-1
 660:	99ba                	add	s3,s3,a4
 662:	377d                	addiw	a4,a4,-1
 664:	1702                	slli	a4,a4,0x20
 666:	9301                	srli	a4,a4,0x20
 668:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 66c:	fff94583          	lbu	a1,-1(s2)
 670:	8526                	mv	a0,s1
 672:	00000097          	auipc	ra,0x0
 676:	f58080e7          	jalr	-168(ra) # 5ca <putc>
  while(--i >= 0)
 67a:	197d                	addi	s2,s2,-1
 67c:	ff3918e3          	bne	s2,s3,66c <printint+0x80>
}
 680:	70e2                	ld	ra,56(sp)
 682:	7442                	ld	s0,48(sp)
 684:	74a2                	ld	s1,40(sp)
 686:	7902                	ld	s2,32(sp)
 688:	69e2                	ld	s3,24(sp)
 68a:	6121                	addi	sp,sp,64
 68c:	8082                	ret
    x = -xx;
 68e:	40b005bb          	negw	a1,a1
    neg = 1;
 692:	4885                	li	a7,1
    x = -xx;
 694:	bf8d                	j	606 <printint+0x1a>

0000000000000696 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 696:	7119                	addi	sp,sp,-128
 698:	fc86                	sd	ra,120(sp)
 69a:	f8a2                	sd	s0,112(sp)
 69c:	f4a6                	sd	s1,104(sp)
 69e:	f0ca                	sd	s2,96(sp)
 6a0:	ecce                	sd	s3,88(sp)
 6a2:	e8d2                	sd	s4,80(sp)
 6a4:	e4d6                	sd	s5,72(sp)
 6a6:	e0da                	sd	s6,64(sp)
 6a8:	fc5e                	sd	s7,56(sp)
 6aa:	f862                	sd	s8,48(sp)
 6ac:	f466                	sd	s9,40(sp)
 6ae:	f06a                	sd	s10,32(sp)
 6b0:	ec6e                	sd	s11,24(sp)
 6b2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b4:	0005c903          	lbu	s2,0(a1)
 6b8:	18090f63          	beqz	s2,856 <vprintf+0x1c0>
 6bc:	8aaa                	mv	s5,a0
 6be:	8b32                	mv	s6,a2
 6c0:	00158493          	addi	s1,a1,1
  state = 0;
 6c4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6c6:	02500a13          	li	s4,37
      if(c == 'd'){
 6ca:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6ce:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6d2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6d6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	00000b97          	auipc	s7,0x0
 6de:	44eb8b93          	addi	s7,s7,1102 # b28 <digits>
 6e2:	a839                	j	700 <vprintf+0x6a>
        putc(fd, c);
 6e4:	85ca                	mv	a1,s2
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	ee2080e7          	jalr	-286(ra) # 5ca <putc>
 6f0:	a019                	j	6f6 <vprintf+0x60>
    } else if(state == '%'){
 6f2:	01498f63          	beq	s3,s4,710 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6f6:	0485                	addi	s1,s1,1
 6f8:	fff4c903          	lbu	s2,-1(s1)
 6fc:	14090d63          	beqz	s2,856 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 700:	0009079b          	sext.w	a5,s2
    if(state == 0){
 704:	fe0997e3          	bnez	s3,6f2 <vprintf+0x5c>
      if(c == '%'){
 708:	fd479ee3          	bne	a5,s4,6e4 <vprintf+0x4e>
        state = '%';
 70c:	89be                	mv	s3,a5
 70e:	b7e5                	j	6f6 <vprintf+0x60>
      if(c == 'd'){
 710:	05878063          	beq	a5,s8,750 <vprintf+0xba>
      } else if(c == 'l') {
 714:	05978c63          	beq	a5,s9,76c <vprintf+0xd6>
      } else if(c == 'x') {
 718:	07a78863          	beq	a5,s10,788 <vprintf+0xf2>
      } else if(c == 'p') {
 71c:	09b78463          	beq	a5,s11,7a4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 720:	07300713          	li	a4,115
 724:	0ce78663          	beq	a5,a4,7f0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 728:	06300713          	li	a4,99
 72c:	0ee78e63          	beq	a5,a4,828 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 730:	11478863          	beq	a5,s4,840 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 734:	85d2                	mv	a1,s4
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	e92080e7          	jalr	-366(ra) # 5ca <putc>
        putc(fd, c);
 740:	85ca                	mv	a1,s2
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e86080e7          	jalr	-378(ra) # 5ca <putc>
      }
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b765                	j	6f6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 750:	008b0913          	addi	s2,s6,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000b2583          	lw	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e8e080e7          	jalr	-370(ra) # 5ec <printint>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	b771                	j	6f6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	008b0913          	addi	s2,s6,8
 770:	4681                	li	a3,0
 772:	4629                	li	a2,10
 774:	000b2583          	lw	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	e72080e7          	jalr	-398(ra) # 5ec <printint>
 782:	8b4a                	mv	s6,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bf85                	j	6f6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 788:	008b0913          	addi	s2,s6,8
 78c:	4681                	li	a3,0
 78e:	4641                	li	a2,16
 790:	000b2583          	lw	a1,0(s6)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e56080e7          	jalr	-426(ra) # 5ec <printint>
 79e:	8b4a                	mv	s6,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bf91                	j	6f6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7a4:	008b0793          	addi	a5,s6,8
 7a8:	f8f43423          	sd	a5,-120(s0)
 7ac:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7b0:	03000593          	li	a1,48
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e14080e7          	jalr	-492(ra) # 5ca <putc>
  putc(fd, 'x');
 7be:	85ea                	mv	a1,s10
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e08080e7          	jalr	-504(ra) # 5ca <putc>
 7ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7cc:	03c9d793          	srli	a5,s3,0x3c
 7d0:	97de                	add	a5,a5,s7
 7d2:	0007c583          	lbu	a1,0(a5)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	df2080e7          	jalr	-526(ra) # 5ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e0:	0992                	slli	s3,s3,0x4
 7e2:	397d                	addiw	s2,s2,-1
 7e4:	fe0914e3          	bnez	s2,7cc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b721                	j	6f6 <vprintf+0x60>
        s = va_arg(ap, char*);
 7f0:	008b0993          	addi	s3,s6,8
 7f4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7f8:	02090163          	beqz	s2,81a <vprintf+0x184>
        while(*s != 0){
 7fc:	00094583          	lbu	a1,0(s2)
 800:	c9a1                	beqz	a1,850 <vprintf+0x1ba>
          putc(fd, *s);
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	dc6080e7          	jalr	-570(ra) # 5ca <putc>
          s++;
 80c:	0905                	addi	s2,s2,1
        while(*s != 0){
 80e:	00094583          	lbu	a1,0(s2)
 812:	f9e5                	bnez	a1,802 <vprintf+0x16c>
        s = va_arg(ap, char*);
 814:	8b4e                	mv	s6,s3
      state = 0;
 816:	4981                	li	s3,0
 818:	bdf9                	j	6f6 <vprintf+0x60>
          s = "(null)";
 81a:	00000917          	auipc	s2,0x0
 81e:	30690913          	addi	s2,s2,774 # b20 <malloc+0x1c0>
        while(*s != 0){
 822:	02800593          	li	a1,40
 826:	bff1                	j	802 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 828:	008b0913          	addi	s2,s6,8
 82c:	000b4583          	lbu	a1,0(s6)
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	d98080e7          	jalr	-616(ra) # 5ca <putc>
 83a:	8b4a                	mv	s6,s2
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bd65                	j	6f6 <vprintf+0x60>
        putc(fd, c);
 840:	85d2                	mv	a1,s4
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	d86080e7          	jalr	-634(ra) # 5ca <putc>
      state = 0;
 84c:	4981                	li	s3,0
 84e:	b565                	j	6f6 <vprintf+0x60>
        s = va_arg(ap, char*);
 850:	8b4e                	mv	s6,s3
      state = 0;
 852:	4981                	li	s3,0
 854:	b54d                	j	6f6 <vprintf+0x60>
    }
  }
}
 856:	70e6                	ld	ra,120(sp)
 858:	7446                	ld	s0,112(sp)
 85a:	74a6                	ld	s1,104(sp)
 85c:	7906                	ld	s2,96(sp)
 85e:	69e6                	ld	s3,88(sp)
 860:	6a46                	ld	s4,80(sp)
 862:	6aa6                	ld	s5,72(sp)
 864:	6b06                	ld	s6,64(sp)
 866:	7be2                	ld	s7,56(sp)
 868:	7c42                	ld	s8,48(sp)
 86a:	7ca2                	ld	s9,40(sp)
 86c:	7d02                	ld	s10,32(sp)
 86e:	6de2                	ld	s11,24(sp)
 870:	6109                	addi	sp,sp,128
 872:	8082                	ret

0000000000000874 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 874:	715d                	addi	sp,sp,-80
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	e010                	sd	a2,0(s0)
 87e:	e414                	sd	a3,8(s0)
 880:	e818                	sd	a4,16(s0)
 882:	ec1c                	sd	a5,24(s0)
 884:	03043023          	sd	a6,32(s0)
 888:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 890:	8622                	mv	a2,s0
 892:	00000097          	auipc	ra,0x0
 896:	e04080e7          	jalr	-508(ra) # 696 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6161                	addi	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <printf>:

void
printf(const char *fmt, ...)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	addi	s0,sp,32
 8aa:	e40c                	sd	a1,8(s0)
 8ac:	e810                	sd	a2,16(s0)
 8ae:	ec14                	sd	a3,24(s0)
 8b0:	f018                	sd	a4,32(s0)
 8b2:	f41c                	sd	a5,40(s0)
 8b4:	03043823          	sd	a6,48(s0)
 8b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	00840613          	addi	a2,s0,8
 8c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c4:	85aa                	mv	a1,a0
 8c6:	4505                	li	a0,1
 8c8:	00000097          	auipc	ra,0x0
 8cc:	dce080e7          	jalr	-562(ra) # 696 <vprintf>
}
 8d0:	60e2                	ld	ra,24(sp)
 8d2:	6442                	ld	s0,16(sp)
 8d4:	6125                	addi	sp,sp,96
 8d6:	8082                	ret

00000000000008d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d8:	1141                	addi	sp,sp,-16
 8da:	e422                	sd	s0,8(sp)
 8dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	00000797          	auipc	a5,0x0
 8e6:	25e7b783          	ld	a5,606(a5) # b40 <freep>
 8ea:	a805                	j	91a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ec:	4618                	lw	a4,8(a2)
 8ee:	9db9                	addw	a1,a1,a4
 8f0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	6318                	ld	a4,0(a4)
 8f8:	fee53823          	sd	a4,-16(a0)
 8fc:	a091                	j	940 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8fe:	ff852703          	lw	a4,-8(a0)
 902:	9e39                	addw	a2,a2,a4
 904:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 906:	ff053703          	ld	a4,-16(a0)
 90a:	e398                	sd	a4,0(a5)
 90c:	a099                	j	952 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90e:	6398                	ld	a4,0(a5)
 910:	00e7e463          	bltu	a5,a4,918 <free+0x40>
 914:	00e6ea63          	bltu	a3,a4,928 <free+0x50>
{
 918:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	fed7fae3          	bgeu	a5,a3,90e <free+0x36>
 91e:	6398                	ld	a4,0(a5)
 920:	00e6e463          	bltu	a3,a4,928 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	fee7eae3          	bltu	a5,a4,918 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 928:	ff852583          	lw	a1,-8(a0)
 92c:	6390                	ld	a2,0(a5)
 92e:	02059713          	slli	a4,a1,0x20
 932:	9301                	srli	a4,a4,0x20
 934:	0712                	slli	a4,a4,0x4
 936:	9736                	add	a4,a4,a3
 938:	fae60ae3          	beq	a2,a4,8ec <free+0x14>
    bp->s.ptr = p->s.ptr;
 93c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 940:	4790                	lw	a2,8(a5)
 942:	02061713          	slli	a4,a2,0x20
 946:	9301                	srli	a4,a4,0x20
 948:	0712                	slli	a4,a4,0x4
 94a:	973e                	add	a4,a4,a5
 94c:	fae689e3          	beq	a3,a4,8fe <free+0x26>
  } else
    p->s.ptr = bp;
 950:	e394                	sd	a3,0(a5)
  freep = p;
 952:	00000717          	auipc	a4,0x0
 956:	1ef73723          	sd	a5,494(a4) # b40 <freep>
}
 95a:	6422                	ld	s0,8(sp)
 95c:	0141                	addi	sp,sp,16
 95e:	8082                	ret

0000000000000960 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 960:	7139                	addi	sp,sp,-64
 962:	fc06                	sd	ra,56(sp)
 964:	f822                	sd	s0,48(sp)
 966:	f426                	sd	s1,40(sp)
 968:	f04a                	sd	s2,32(sp)
 96a:	ec4e                	sd	s3,24(sp)
 96c:	e852                	sd	s4,16(sp)
 96e:	e456                	sd	s5,8(sp)
 970:	e05a                	sd	s6,0(sp)
 972:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 974:	02051493          	slli	s1,a0,0x20
 978:	9081                	srli	s1,s1,0x20
 97a:	04bd                	addi	s1,s1,15
 97c:	8091                	srli	s1,s1,0x4
 97e:	0014899b          	addiw	s3,s1,1
 982:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 984:	00000517          	auipc	a0,0x0
 988:	1bc53503          	ld	a0,444(a0) # b40 <freep>
 98c:	c515                	beqz	a0,9b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 990:	4798                	lw	a4,8(a5)
 992:	02977f63          	bgeu	a4,s1,9d0 <malloc+0x70>
 996:	8a4e                	mv	s4,s3
 998:	0009871b          	sext.w	a4,s3
 99c:	6685                	lui	a3,0x1
 99e:	00d77363          	bgeu	a4,a3,9a4 <malloc+0x44>
 9a2:	6a05                	lui	s4,0x1
 9a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ac:	00000917          	auipc	s2,0x0
 9b0:	19490913          	addi	s2,s2,404 # b40 <freep>
  if(p == (char*)-1)
 9b4:	5afd                	li	s5,-1
 9b6:	a88d                	j	a28 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9b8:	00000797          	auipc	a5,0x0
 9bc:	19078793          	addi	a5,a5,400 # b48 <base>
 9c0:	00000717          	auipc	a4,0x0
 9c4:	18f73023          	sd	a5,384(a4) # b40 <freep>
 9c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ce:	b7e1                	j	996 <malloc+0x36>
      if(p->s.size == nunits)
 9d0:	02e48b63          	beq	s1,a4,a06 <malloc+0xa6>
        p->s.size -= nunits;
 9d4:	4137073b          	subw	a4,a4,s3
 9d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9da:	1702                	slli	a4,a4,0x20
 9dc:	9301                	srli	a4,a4,0x20
 9de:	0712                	slli	a4,a4,0x4
 9e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e6:	00000717          	auipc	a4,0x0
 9ea:	14a73d23          	sd	a0,346(a4) # b40 <freep>
      return (void*)(p + 1);
 9ee:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9f2:	70e2                	ld	ra,56(sp)
 9f4:	7442                	ld	s0,48(sp)
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	7902                	ld	s2,32(sp)
 9fa:	69e2                	ld	s3,24(sp)
 9fc:	6a42                	ld	s4,16(sp)
 9fe:	6aa2                	ld	s5,8(sp)
 a00:	6b02                	ld	s6,0(sp)
 a02:	6121                	addi	sp,sp,64
 a04:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a06:	6398                	ld	a4,0(a5)
 a08:	e118                	sd	a4,0(a0)
 a0a:	bff1                	j	9e6 <malloc+0x86>
  hp->s.size = nu;
 a0c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a10:	0541                	addi	a0,a0,16
 a12:	00000097          	auipc	ra,0x0
 a16:	ec6080e7          	jalr	-314(ra) # 8d8 <free>
  return freep;
 a1a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a1e:	d971                	beqz	a0,9f2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a22:	4798                	lw	a4,8(a5)
 a24:	fa9776e3          	bgeu	a4,s1,9d0 <malloc+0x70>
    if(p == freep)
 a28:	00093703          	ld	a4,0(s2)
 a2c:	853e                	mv	a0,a5
 a2e:	fef719e3          	bne	a4,a5,a20 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a32:	8552                	mv	a0,s4
 a34:	00000097          	auipc	ra,0x0
 a38:	ad4080e7          	jalr	-1324(ra) # 508 <sbrk>
  if(p == (char*)-1)
 a3c:	fd5518e3          	bne	a0,s5,a0c <malloc+0xac>
        return 0;
 a40:	4501                	li	a0,0
 a42:	bf45                	j	9f2 <malloc+0x92>
