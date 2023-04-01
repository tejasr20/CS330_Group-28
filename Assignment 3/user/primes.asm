
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "kernel/types.h"
#include "user/user.h"

void primes (int rfd, int primecount)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	84aa                	mv	s1,a0
  10:	892e                	mv	s2,a1
   int x, y, z, pipefd[2];
   int count = 0;

   if (pipe(pipefd) < 0) {
  12:	fc040513          	addi	a0,s0,-64
  16:	00000097          	auipc	ra,0x0
  1a:	550080e7          	jalr	1360(ra) # 566 <pipe>
  1e:	06054863          	bltz	a0,8e <primes+0x8e>
      fprintf(2, "Error: cannot create pipe\nAborting...\n");
      exit(0);
   }

   if (read(rfd, &x, sizeof(int)) <= 0) {
  22:	4611                	li	a2,4
  24:	fcc40593          	addi	a1,s0,-52
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	544080e7          	jalr	1348(ra) # 56e <read>
  32:	06a05c63          	blez	a0,aa <primes+0xaa>
      fprintf(2, "Error: cannot read from pipe\nAborting...\n");
      exit(0);
   }
   primecount++;
  36:	2905                	addiw	s2,s2,1
   fprintf(1, "%d: prime %d\n", primecount, x);
  38:	fcc42683          	lw	a3,-52(s0)
  3c:	864a                	mv	a2,s2
  3e:	00001597          	auipc	a1,0x1
  42:	b3a58593          	addi	a1,a1,-1222 # b78 <malloc+0x142>
  46:	4505                	li	a0,1
  48:	00001097          	auipc	ra,0x1
  4c:	902080e7          	jalr	-1790(ra) # 94a <fprintf>
   int count = 0;
  50:	4981                	li	s3,0
   while (read(rfd, &y, sizeof(int)) > 0) {
  52:	4611                	li	a2,4
  54:	fc840593          	addi	a1,s0,-56
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	514080e7          	jalr	1300(ra) # 56e <read>
  62:	08a05063          	blez	a0,e2 <primes+0xe2>
      if ((y % x) != 0) {
  66:	fc842783          	lw	a5,-56(s0)
  6a:	fcc42703          	lw	a4,-52(s0)
  6e:	02e7e7bb          	remw	a5,a5,a4
  72:	d3e5                	beqz	a5,52 <primes+0x52>
         if (write(pipefd[1], &y, sizeof(int)) <= 0) {
  74:	4611                	li	a2,4
  76:	fc840593          	addi	a1,s0,-56
  7a:	fc442503          	lw	a0,-60(s0)
  7e:	00000097          	auipc	ra,0x0
  82:	4f8080e7          	jalr	1272(ra) # 576 <write>
  86:	04a05063          	blez	a0,c6 <primes+0xc6>
            fprintf(2, "Error: cannot write to pipe\nAborting...\n");
            exit(0);
         }
	 count++;
  8a:	2985                	addiw	s3,s3,1
  8c:	b7d9                	j	52 <primes+0x52>
      fprintf(2, "Error: cannot create pipe\nAborting...\n");
  8e:	00001597          	auipc	a1,0x1
  92:	a9258593          	addi	a1,a1,-1390 # b20 <malloc+0xea>
  96:	4509                	li	a0,2
  98:	00001097          	auipc	ra,0x1
  9c:	8b2080e7          	jalr	-1870(ra) # 94a <fprintf>
      exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	4b4080e7          	jalr	1204(ra) # 556 <exit>
      fprintf(2, "Error: cannot read from pipe\nAborting...\n");
  aa:	00001597          	auipc	a1,0x1
  ae:	a9e58593          	addi	a1,a1,-1378 # b48 <malloc+0x112>
  b2:	4509                	li	a0,2
  b4:	00001097          	auipc	ra,0x1
  b8:	896080e7          	jalr	-1898(ra) # 94a <fprintf>
      exit(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	498080e7          	jalr	1176(ra) # 556 <exit>
            fprintf(2, "Error: cannot write to pipe\nAborting...\n");
  c6:	00001597          	auipc	a1,0x1
  ca:	ac258593          	addi	a1,a1,-1342 # b88 <malloc+0x152>
  ce:	4509                	li	a0,2
  d0:	00001097          	auipc	ra,0x1
  d4:	87a080e7          	jalr	-1926(ra) # 94a <fprintf>
            exit(0);
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	47c080e7          	jalr	1148(ra) # 556 <exit>
      }
   }
   close(rfd);
  e2:	8526                	mv	a0,s1
  e4:	00000097          	auipc	ra,0x0
  e8:	49a080e7          	jalr	1178(ra) # 57e <close>
   close(pipefd[1]);
  ec:	fc442503          	lw	a0,-60(s0)
  f0:	00000097          	auipc	ra,0x0
  f4:	48e080e7          	jalr	1166(ra) # 57e <close>
   if (count) {
  f8:	04098b63          	beqz	s3,14e <primes+0x14e>
      z = fork();
  fc:	00000097          	auipc	ra,0x0
 100:	452080e7          	jalr	1106(ra) # 54e <fork>
      if (z < 0) {
 104:	02054063          	bltz	a0,124 <primes+0x124>
         fprintf(2, "Error: cannot fork\nAborting...\n");
         exit(0);
      }
      else if (z > 0) {
 108:	02a05c63          	blez	a0,140 <primes+0x140>
	 close(pipefd[0]);
 10c:	fc042503          	lw	a0,-64(s0)
 110:	00000097          	auipc	ra,0x0
 114:	46e080e7          	jalr	1134(ra) # 57e <close>
         wait(0);
 118:	4501                	li	a0,0
 11a:	00000097          	auipc	ra,0x0
 11e:	444080e7          	jalr	1092(ra) # 55e <wait>
 122:	a825                	j	15a <primes+0x15a>
         fprintf(2, "Error: cannot fork\nAborting...\n");
 124:	00001597          	auipc	a1,0x1
 128:	a9458593          	addi	a1,a1,-1388 # bb8 <malloc+0x182>
 12c:	4509                	li	a0,2
 12e:	00001097          	auipc	ra,0x1
 132:	81c080e7          	jalr	-2020(ra) # 94a <fprintf>
         exit(0);
 136:	4501                	li	a0,0
 138:	00000097          	auipc	ra,0x0
 13c:	41e080e7          	jalr	1054(ra) # 556 <exit>
      }
      else primes(pipefd[0], primecount);
 140:	85ca                	mv	a1,s2
 142:	fc042503          	lw	a0,-64(s0)
 146:	00000097          	auipc	ra,0x0
 14a:	eba080e7          	jalr	-326(ra) # 0 <primes>
   }
   else close(pipefd[0]);
 14e:	fc042503          	lw	a0,-64(s0)
 152:	00000097          	auipc	ra,0x0
 156:	42c080e7          	jalr	1068(ra) # 57e <close>
   exit(0);
 15a:	4501                	li	a0,0
 15c:	00000097          	auipc	ra,0x0
 160:	3fa080e7          	jalr	1018(ra) # 556 <exit>

0000000000000164 <main>:
}
     
int
main(int argc, char *argv[])
{
 164:	7179                	addi	sp,sp,-48
 166:	f406                	sd	ra,40(sp)
 168:	f022                	sd	s0,32(sp)
 16a:	ec26                	sd	s1,24(sp)
 16c:	e84a                	sd	s2,16(sp)
 16e:	1800                	addi	s0,sp,48
  int pipefd[2], x, y, i, count=0, primecount=1;

  if (argc != 2) {
 170:	4789                	li	a5,2
 172:	02f50063          	beq	a0,a5,192 <main+0x2e>
     fprintf(2, "syntax: primes n\nAborting...\n");
 176:	00001597          	auipc	a1,0x1
 17a:	a6258593          	addi	a1,a1,-1438 # bd8 <malloc+0x1a2>
 17e:	4509                	li	a0,2
 180:	00000097          	auipc	ra,0x0
 184:	7ca080e7          	jalr	1994(ra) # 94a <fprintf>
     exit(0);
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	3cc080e7          	jalr	972(ra) # 556 <exit>
  }
  y = atoi(argv[1]);
 192:	6588                	ld	a0,8(a1)
 194:	00000097          	auipc	ra,0x0
 198:	2c2080e7          	jalr	706(ra) # 456 <atoi>
 19c:	84aa                	mv	s1,a0
  if (y < 2) {
 19e:	4785                	li	a5,1
 1a0:	02a7dc63          	bge	a5,a0,1d8 <main+0x74>
     fprintf(2, "Invalid input\nAborting...\n");
     exit(0);
  }

  if (pipe(pipefd) < 0) {
 1a4:	fd840513          	addi	a0,s0,-40
 1a8:	00000097          	auipc	ra,0x0
 1ac:	3be080e7          	jalr	958(ra) # 566 <pipe>
 1b0:	04054263          	bltz	a0,1f4 <main+0x90>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
     exit(0);
  }

  fprintf(1, "1: prime 2\n");
 1b4:	00001597          	auipc	a1,0x1
 1b8:	a6458593          	addi	a1,a1,-1436 # c18 <malloc+0x1e2>
 1bc:	4505                	li	a0,1
 1be:	00000097          	auipc	ra,0x0
 1c2:	78c080e7          	jalr	1932(ra) # 94a <fprintf>
  for (i=3; i<=y; i++) {
 1c6:	478d                	li	a5,3
 1c8:	fcf42a23          	sw	a5,-44(s0)
 1cc:	4789                	li	a5,2
 1ce:	0e97d863          	bge	a5,s1,2be <main+0x15a>
  int pipefd[2], x, y, i, count=0, primecount=1;
 1d2:	4901                	li	s2,0
  for (i=3; i<=y; i++) {
 1d4:	478d                	li	a5,3
 1d6:	a0a5                	j	23e <main+0xda>
     fprintf(2, "Invalid input\nAborting...\n");
 1d8:	00001597          	auipc	a1,0x1
 1dc:	a2058593          	addi	a1,a1,-1504 # bf8 <malloc+0x1c2>
 1e0:	4509                	li	a0,2
 1e2:	00000097          	auipc	ra,0x0
 1e6:	768080e7          	jalr	1896(ra) # 94a <fprintf>
     exit(0);
 1ea:	4501                	li	a0,0
 1ec:	00000097          	auipc	ra,0x0
 1f0:	36a080e7          	jalr	874(ra) # 556 <exit>
     fprintf(2, "Error: cannot create pipe\nAborting...\n");
 1f4:	00001597          	auipc	a1,0x1
 1f8:	92c58593          	addi	a1,a1,-1748 # b20 <malloc+0xea>
 1fc:	4509                	li	a0,2
 1fe:	00000097          	auipc	ra,0x0
 202:	74c080e7          	jalr	1868(ra) # 94a <fprintf>
     exit(0);
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	34e080e7          	jalr	846(ra) # 556 <exit>
     if ((i%2) != 0) {
        if (write(pipefd[1], &i, sizeof(int)) <= 0) {
           fprintf(2, "Error: cannot write to pipe\nAborting...\n");
 210:	00001597          	auipc	a1,0x1
 214:	97858593          	addi	a1,a1,-1672 # b88 <malloc+0x152>
 218:	4509                	li	a0,2
 21a:	00000097          	auipc	ra,0x0
 21e:	730080e7          	jalr	1840(ra) # 94a <fprintf>
           exit(0);
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	332080e7          	jalr	818(ra) # 556 <exit>
  for (i=3; i<=y; i++) {
 22c:	fd442703          	lw	a4,-44(s0)
 230:	2705                	addiw	a4,a4,1
 232:	0007079b          	sext.w	a5,a4
 236:	fce42a23          	sw	a4,-44(s0)
 23a:	02f4c163          	blt	s1,a5,25c <main+0xf8>
     if ((i%2) != 0) {
 23e:	8b85                	andi	a5,a5,1
 240:	d7f5                	beqz	a5,22c <main+0xc8>
        if (write(pipefd[1], &i, sizeof(int)) <= 0) {
 242:	4611                	li	a2,4
 244:	fd440593          	addi	a1,s0,-44
 248:	fdc42503          	lw	a0,-36(s0)
 24c:	00000097          	auipc	ra,0x0
 250:	32a080e7          	jalr	810(ra) # 576 <write>
 254:	faa05ee3          	blez	a0,210 <main+0xac>
        }
	count++;
 258:	2905                	addiw	s2,s2,1
 25a:	bfc9                	j	22c <main+0xc8>
     }
  }
  close(pipefd[1]);
 25c:	fdc42503          	lw	a0,-36(s0)
 260:	00000097          	auipc	ra,0x0
 264:	31e080e7          	jalr	798(ra) # 57e <close>
  if (count) {
 268:	06090163          	beqz	s2,2ca <main+0x166>
     x = fork();
 26c:	00000097          	auipc	ra,0x0
 270:	2e2080e7          	jalr	738(ra) # 54e <fork>
     if (x < 0) {
 274:	02054063          	bltz	a0,294 <main+0x130>
        fprintf(2, "Error: cannot fork\nAborting...\n");
        exit(0);
     }
     else if (x > 0) {
 278:	02a05c63          	blez	a0,2b0 <main+0x14c>
	close(pipefd[0]);
 27c:	fd842503          	lw	a0,-40(s0)
 280:	00000097          	auipc	ra,0x0
 284:	2fe080e7          	jalr	766(ra) # 57e <close>
        wait(0);
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	2d4080e7          	jalr	724(ra) # 55e <wait>
 292:	a091                	j	2d6 <main+0x172>
        fprintf(2, "Error: cannot fork\nAborting...\n");
 294:	00001597          	auipc	a1,0x1
 298:	92458593          	addi	a1,a1,-1756 # bb8 <malloc+0x182>
 29c:	4509                	li	a0,2
 29e:	00000097          	auipc	ra,0x0
 2a2:	6ac080e7          	jalr	1708(ra) # 94a <fprintf>
        exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	2ae080e7          	jalr	686(ra) # 556 <exit>
     }
     else primes(pipefd[0], primecount);
 2b0:	4585                	li	a1,1
 2b2:	fd842503          	lw	a0,-40(s0)
 2b6:	00000097          	auipc	ra,0x0
 2ba:	d4a080e7          	jalr	-694(ra) # 0 <primes>
  close(pipefd[1]);
 2be:	fdc42503          	lw	a0,-36(s0)
 2c2:	00000097          	auipc	ra,0x0
 2c6:	2bc080e7          	jalr	700(ra) # 57e <close>
  }
  else close(pipefd[0]);
 2ca:	fd842503          	lw	a0,-40(s0)
 2ce:	00000097          	auipc	ra,0x0
 2d2:	2b0080e7          	jalr	688(ra) # 57e <close>

  exit(0);
 2d6:	4501                	li	a0,0
 2d8:	00000097          	auipc	ra,0x0
 2dc:	27e080e7          	jalr	638(ra) # 556 <exit>

00000000000002e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e6:	87aa                	mv	a5,a0
 2e8:	0585                	addi	a1,a1,1
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff5c703          	lbu	a4,-1(a1)
 2f0:	fee78fa3          	sb	a4,-1(a5)
 2f4:	fb75                	bnez	a4,2e8 <strcpy+0x8>
    ;
  return os;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 302:	00054783          	lbu	a5,0(a0)
 306:	cb91                	beqz	a5,31a <strcmp+0x1e>
 308:	0005c703          	lbu	a4,0(a1)
 30c:	00f71763          	bne	a4,a5,31a <strcmp+0x1e>
    p++, q++;
 310:	0505                	addi	a0,a0,1
 312:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 314:	00054783          	lbu	a5,0(a0)
 318:	fbe5                	bnez	a5,308 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 31a:	0005c503          	lbu	a0,0(a1)
}
 31e:	40a7853b          	subw	a0,a5,a0
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret

0000000000000328 <strlen>:

uint
strlen(const char *s)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cf91                	beqz	a5,34e <strlen+0x26>
 334:	0505                	addi	a0,a0,1
 336:	87aa                	mv	a5,a0
 338:	4685                	li	a3,1
 33a:	9e89                	subw	a3,a3,a0
 33c:	00f6853b          	addw	a0,a3,a5
 340:	0785                	addi	a5,a5,1
 342:	fff7c703          	lbu	a4,-1(a5)
 346:	fb7d                	bnez	a4,33c <strlen+0x14>
    ;
  return n;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  for(n = 0; s[n]; n++)
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <strlen+0x20>

0000000000000352 <memset>:

void*
memset(void *dst, int c, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 358:	ce09                	beqz	a2,372 <memset+0x20>
 35a:	87aa                	mv	a5,a0
 35c:	fff6071b          	addiw	a4,a2,-1
 360:	1702                	slli	a4,a4,0x20
 362:	9301                	srli	a4,a4,0x20
 364:	0705                	addi	a4,a4,1
 366:	972a                	add	a4,a4,a0
    cdst[i] = c;
 368:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 36c:	0785                	addi	a5,a5,1
 36e:	fee79de3          	bne	a5,a4,368 <memset+0x16>
  }
  return dst;
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <strchr>:

char*
strchr(const char *s, char c)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 37e:	00054783          	lbu	a5,0(a0)
 382:	cb99                	beqz	a5,398 <strchr+0x20>
    if(*s == c)
 384:	00f58763          	beq	a1,a5,392 <strchr+0x1a>
  for(; *s; s++)
 388:	0505                	addi	a0,a0,1
 38a:	00054783          	lbu	a5,0(a0)
 38e:	fbfd                	bnez	a5,384 <strchr+0xc>
      return (char*)s;
  return 0;
 390:	4501                	li	a0,0
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  return 0;
 398:	4501                	li	a0,0
 39a:	bfe5                	j	392 <strchr+0x1a>

000000000000039c <gets>:

char*
gets(char *buf, int max)
{
 39c:	711d                	addi	sp,sp,-96
 39e:	ec86                	sd	ra,88(sp)
 3a0:	e8a2                	sd	s0,80(sp)
 3a2:	e4a6                	sd	s1,72(sp)
 3a4:	e0ca                	sd	s2,64(sp)
 3a6:	fc4e                	sd	s3,56(sp)
 3a8:	f852                	sd	s4,48(sp)
 3aa:	f456                	sd	s5,40(sp)
 3ac:	f05a                	sd	s6,32(sp)
 3ae:	ec5e                	sd	s7,24(sp)
 3b0:	1080                	addi	s0,sp,96
 3b2:	8baa                	mv	s7,a0
 3b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b6:	892a                	mv	s2,a0
 3b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ba:	4aa9                	li	s5,10
 3bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3be:	89a6                	mv	s3,s1
 3c0:	2485                	addiw	s1,s1,1
 3c2:	0344d863          	bge	s1,s4,3f2 <gets+0x56>
    cc = read(0, &c, 1);
 3c6:	4605                	li	a2,1
 3c8:	faf40593          	addi	a1,s0,-81
 3cc:	4501                	li	a0,0
 3ce:	00000097          	auipc	ra,0x0
 3d2:	1a0080e7          	jalr	416(ra) # 56e <read>
    if(cc < 1)
 3d6:	00a05e63          	blez	a0,3f2 <gets+0x56>
    buf[i++] = c;
 3da:	faf44783          	lbu	a5,-81(s0)
 3de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3e2:	01578763          	beq	a5,s5,3f0 <gets+0x54>
 3e6:	0905                	addi	s2,s2,1
 3e8:	fd679be3          	bne	a5,s6,3be <gets+0x22>
  for(i=0; i+1 < max; ){
 3ec:	89a6                	mv	s3,s1
 3ee:	a011                	j	3f2 <gets+0x56>
 3f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3f2:	99de                	add	s3,s3,s7
 3f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f8:	855e                	mv	a0,s7
 3fa:	60e6                	ld	ra,88(sp)
 3fc:	6446                	ld	s0,80(sp)
 3fe:	64a6                	ld	s1,72(sp)
 400:	6906                	ld	s2,64(sp)
 402:	79e2                	ld	s3,56(sp)
 404:	7a42                	ld	s4,48(sp)
 406:	7aa2                	ld	s5,40(sp)
 408:	7b02                	ld	s6,32(sp)
 40a:	6be2                	ld	s7,24(sp)
 40c:	6125                	addi	sp,sp,96
 40e:	8082                	ret

0000000000000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	1101                	addi	sp,sp,-32
 412:	ec06                	sd	ra,24(sp)
 414:	e822                	sd	s0,16(sp)
 416:	e426                	sd	s1,8(sp)
 418:	e04a                	sd	s2,0(sp)
 41a:	1000                	addi	s0,sp,32
 41c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41e:	4581                	li	a1,0
 420:	00000097          	auipc	ra,0x0
 424:	176080e7          	jalr	374(ra) # 596 <open>
  if(fd < 0)
 428:	02054563          	bltz	a0,452 <stat+0x42>
 42c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 42e:	85ca                	mv	a1,s2
 430:	00000097          	auipc	ra,0x0
 434:	17e080e7          	jalr	382(ra) # 5ae <fstat>
 438:	892a                	mv	s2,a0
  close(fd);
 43a:	8526                	mv	a0,s1
 43c:	00000097          	auipc	ra,0x0
 440:	142080e7          	jalr	322(ra) # 57e <close>
  return r;
}
 444:	854a                	mv	a0,s2
 446:	60e2                	ld	ra,24(sp)
 448:	6442                	ld	s0,16(sp)
 44a:	64a2                	ld	s1,8(sp)
 44c:	6902                	ld	s2,0(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret
    return -1;
 452:	597d                	li	s2,-1
 454:	bfc5                	j	444 <stat+0x34>

0000000000000456 <atoi>:

int
atoi(const char *s)
{
 456:	1141                	addi	sp,sp,-16
 458:	e422                	sd	s0,8(sp)
 45a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 45c:	00054603          	lbu	a2,0(a0)
 460:	fd06079b          	addiw	a5,a2,-48
 464:	0ff7f793          	andi	a5,a5,255
 468:	4725                	li	a4,9
 46a:	02f76963          	bltu	a4,a5,49c <atoi+0x46>
 46e:	86aa                	mv	a3,a0
  n = 0;
 470:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 472:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 474:	0685                	addi	a3,a3,1
 476:	0025179b          	slliw	a5,a0,0x2
 47a:	9fa9                	addw	a5,a5,a0
 47c:	0017979b          	slliw	a5,a5,0x1
 480:	9fb1                	addw	a5,a5,a2
 482:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 486:	0006c603          	lbu	a2,0(a3)
 48a:	fd06071b          	addiw	a4,a2,-48
 48e:	0ff77713          	andi	a4,a4,255
 492:	fee5f1e3          	bgeu	a1,a4,474 <atoi+0x1e>
  return n;
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
  n = 0;
 49c:	4501                	li	a0,0
 49e:	bfe5                	j	496 <atoi+0x40>

00000000000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e422                	sd	s0,8(sp)
 4a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4a6:	02b57663          	bgeu	a0,a1,4d2 <memmove+0x32>
    while(n-- > 0)
 4aa:	02c05163          	blez	a2,4cc <memmove+0x2c>
 4ae:	fff6079b          	addiw	a5,a2,-1
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	0785                	addi	a5,a5,1
 4b8:	97aa                	add	a5,a5,a0
  dst = vdst;
 4ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 4bc:	0585                	addi	a1,a1,1
 4be:	0705                	addi	a4,a4,1
 4c0:	fff5c683          	lbu	a3,-1(a1)
 4c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4c8:	fee79ae3          	bne	a5,a4,4bc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4cc:	6422                	ld	s0,8(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret
    dst += n;
 4d2:	00c50733          	add	a4,a0,a2
    src += n;
 4d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4d8:	fec05ae3          	blez	a2,4cc <memmove+0x2c>
 4dc:	fff6079b          	addiw	a5,a2,-1
 4e0:	1782                	slli	a5,a5,0x20
 4e2:	9381                	srli	a5,a5,0x20
 4e4:	fff7c793          	not	a5,a5
 4e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ea:	15fd                	addi	a1,a1,-1
 4ec:	177d                	addi	a4,a4,-1
 4ee:	0005c683          	lbu	a3,0(a1)
 4f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4f6:	fee79ae3          	bne	a5,a4,4ea <memmove+0x4a>
 4fa:	bfc9                	j	4cc <memmove+0x2c>

00000000000004fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e422                	sd	s0,8(sp)
 500:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 502:	ca05                	beqz	a2,532 <memcmp+0x36>
 504:	fff6069b          	addiw	a3,a2,-1
 508:	1682                	slli	a3,a3,0x20
 50a:	9281                	srli	a3,a3,0x20
 50c:	0685                	addi	a3,a3,1
 50e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 510:	00054783          	lbu	a5,0(a0)
 514:	0005c703          	lbu	a4,0(a1)
 518:	00e79863          	bne	a5,a4,528 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 51c:	0505                	addi	a0,a0,1
    p2++;
 51e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 520:	fed518e3          	bne	a0,a3,510 <memcmp+0x14>
  }
  return 0;
 524:	4501                	li	a0,0
 526:	a019                	j	52c <memcmp+0x30>
      return *p1 - *p2;
 528:	40e7853b          	subw	a0,a5,a4
}
 52c:	6422                	ld	s0,8(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret
  return 0;
 532:	4501                	li	a0,0
 534:	bfe5                	j	52c <memcmp+0x30>

0000000000000536 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e406                	sd	ra,8(sp)
 53a:	e022                	sd	s0,0(sp)
 53c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 53e:	00000097          	auipc	ra,0x0
 542:	f62080e7          	jalr	-158(ra) # 4a0 <memmove>
}
 546:	60a2                	ld	ra,8(sp)
 548:	6402                	ld	s0,0(sp)
 54a:	0141                	addi	sp,sp,16
 54c:	8082                	ret

000000000000054e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54e:	4885                	li	a7,1
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <exit>:
.global exit
exit:
 li a7, SYS_exit
 556:	4889                	li	a7,2
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <wait>:
.global wait
wait:
 li a7, SYS_wait
 55e:	488d                	li	a7,3
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 566:	4891                	li	a7,4
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <read>:
.global read
read:
 li a7, SYS_read
 56e:	4895                	li	a7,5
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <write>:
.global write
write:
 li a7, SYS_write
 576:	48c1                	li	a7,16
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <close>:
.global close
close:
 li a7, SYS_close
 57e:	48d5                	li	a7,21
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <kill>:
.global kill
kill:
 li a7, SYS_kill
 586:	4899                	li	a7,6
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <exec>:
.global exec
exec:
 li a7, SYS_exec
 58e:	489d                	li	a7,7
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <open>:
.global open
open:
 li a7, SYS_open
 596:	48bd                	li	a7,15
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59e:	48c5                	li	a7,17
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a6:	48c9                	li	a7,18
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ae:	48a1                	li	a7,8
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <link>:
.global link
link:
 li a7, SYS_link
 5b6:	48cd                	li	a7,19
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5be:	48d1                	li	a7,20
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c6:	48a5                	li	a7,9
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ce:	48a9                	li	a7,10
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d6:	48ad                	li	a7,11
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5de:	48b1                	li	a7,12
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e6:	48b5                	li	a7,13
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ee:	48b9                	li	a7,14
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 5f6:	48d9                	li	a7,22
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <yield>:
.global yield
yield:
 li a7, SYS_yield
 5fe:	48dd                	li	a7,23
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 606:	48e1                	li	a7,24
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 60e:	48e5                	li	a7,25
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 616:	48e9                	li	a7,26
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <ps>:
.global ps
ps:
 li a7, SYS_ps
 61e:	48ed                	li	a7,27
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 626:	48f1                	li	a7,28
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 62e:	48f5                	li	a7,29
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 636:	48f9                	li	a7,30
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 63e:	48fd                	li	a7,31
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 646:	02000893          	li	a7,32
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 650:	02100893          	li	a7,33
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 65a:	02200893          	li	a7,34
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 664:	02300893          	li	a7,35
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 66e:	02500893          	li	a7,37
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 678:	02400893          	li	a7,36
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 682:	02600893          	li	a7,38
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 68c:	02800893          	li	a7,40
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 696:	02700893          	li	a7,39
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6a0:	1101                	addi	sp,sp,-32
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6ac:	4605                	li	a2,1
 6ae:	fef40593          	addi	a1,s0,-17
 6b2:	00000097          	auipc	ra,0x0
 6b6:	ec4080e7          	jalr	-316(ra) # 576 <write>
}
 6ba:	60e2                	ld	ra,24(sp)
 6bc:	6442                	ld	s0,16(sp)
 6be:	6105                	addi	sp,sp,32
 6c0:	8082                	ret

00000000000006c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c2:	7139                	addi	sp,sp,-64
 6c4:	fc06                	sd	ra,56(sp)
 6c6:	f822                	sd	s0,48(sp)
 6c8:	f426                	sd	s1,40(sp)
 6ca:	f04a                	sd	s2,32(sp)
 6cc:	ec4e                	sd	s3,24(sp)
 6ce:	0080                	addi	s0,sp,64
 6d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6d2:	c299                	beqz	a3,6d8 <printint+0x16>
 6d4:	0805c863          	bltz	a1,764 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6d8:	2581                	sext.w	a1,a1
  neg = 0;
 6da:	4881                	li	a7,0
 6dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6e2:	2601                	sext.w	a2,a2
 6e4:	00000517          	auipc	a0,0x0
 6e8:	54c50513          	addi	a0,a0,1356 # c30 <digits>
 6ec:	883a                	mv	a6,a4
 6ee:	2705                	addiw	a4,a4,1
 6f0:	02c5f7bb          	remuw	a5,a1,a2
 6f4:	1782                	slli	a5,a5,0x20
 6f6:	9381                	srli	a5,a5,0x20
 6f8:	97aa                	add	a5,a5,a0
 6fa:	0007c783          	lbu	a5,0(a5)
 6fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 702:	0005879b          	sext.w	a5,a1
 706:	02c5d5bb          	divuw	a1,a1,a2
 70a:	0685                	addi	a3,a3,1
 70c:	fec7f0e3          	bgeu	a5,a2,6ec <printint+0x2a>
  if(neg)
 710:	00088b63          	beqz	a7,726 <printint+0x64>
    buf[i++] = '-';
 714:	fd040793          	addi	a5,s0,-48
 718:	973e                	add	a4,a4,a5
 71a:	02d00793          	li	a5,45
 71e:	fef70823          	sb	a5,-16(a4)
 722:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 726:	02e05863          	blez	a4,756 <printint+0x94>
 72a:	fc040793          	addi	a5,s0,-64
 72e:	00e78933          	add	s2,a5,a4
 732:	fff78993          	addi	s3,a5,-1
 736:	99ba                	add	s3,s3,a4
 738:	377d                	addiw	a4,a4,-1
 73a:	1702                	slli	a4,a4,0x20
 73c:	9301                	srli	a4,a4,0x20
 73e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 742:	fff94583          	lbu	a1,-1(s2)
 746:	8526                	mv	a0,s1
 748:	00000097          	auipc	ra,0x0
 74c:	f58080e7          	jalr	-168(ra) # 6a0 <putc>
  while(--i >= 0)
 750:	197d                	addi	s2,s2,-1
 752:	ff3918e3          	bne	s2,s3,742 <printint+0x80>
}
 756:	70e2                	ld	ra,56(sp)
 758:	7442                	ld	s0,48(sp)
 75a:	74a2                	ld	s1,40(sp)
 75c:	7902                	ld	s2,32(sp)
 75e:	69e2                	ld	s3,24(sp)
 760:	6121                	addi	sp,sp,64
 762:	8082                	ret
    x = -xx;
 764:	40b005bb          	negw	a1,a1
    neg = 1;
 768:	4885                	li	a7,1
    x = -xx;
 76a:	bf8d                	j	6dc <printint+0x1a>

000000000000076c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 76c:	7119                	addi	sp,sp,-128
 76e:	fc86                	sd	ra,120(sp)
 770:	f8a2                	sd	s0,112(sp)
 772:	f4a6                	sd	s1,104(sp)
 774:	f0ca                	sd	s2,96(sp)
 776:	ecce                	sd	s3,88(sp)
 778:	e8d2                	sd	s4,80(sp)
 77a:	e4d6                	sd	s5,72(sp)
 77c:	e0da                	sd	s6,64(sp)
 77e:	fc5e                	sd	s7,56(sp)
 780:	f862                	sd	s8,48(sp)
 782:	f466                	sd	s9,40(sp)
 784:	f06a                	sd	s10,32(sp)
 786:	ec6e                	sd	s11,24(sp)
 788:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 78a:	0005c903          	lbu	s2,0(a1)
 78e:	18090f63          	beqz	s2,92c <vprintf+0x1c0>
 792:	8aaa                	mv	s5,a0
 794:	8b32                	mv	s6,a2
 796:	00158493          	addi	s1,a1,1
  state = 0;
 79a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 79c:	02500a13          	li	s4,37
      if(c == 'd'){
 7a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7a4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7a8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7ac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b0:	00000b97          	auipc	s7,0x0
 7b4:	480b8b93          	addi	s7,s7,1152 # c30 <digits>
 7b8:	a839                	j	7d6 <vprintf+0x6a>
        putc(fd, c);
 7ba:	85ca                	mv	a1,s2
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	ee2080e7          	jalr	-286(ra) # 6a0 <putc>
 7c6:	a019                	j	7cc <vprintf+0x60>
    } else if(state == '%'){
 7c8:	01498f63          	beq	s3,s4,7e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7cc:	0485                	addi	s1,s1,1
 7ce:	fff4c903          	lbu	s2,-1(s1)
 7d2:	14090d63          	beqz	s2,92c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 7d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7da:	fe0997e3          	bnez	s3,7c8 <vprintf+0x5c>
      if(c == '%'){
 7de:	fd479ee3          	bne	a5,s4,7ba <vprintf+0x4e>
        state = '%';
 7e2:	89be                	mv	s3,a5
 7e4:	b7e5                	j	7cc <vprintf+0x60>
      if(c == 'd'){
 7e6:	05878063          	beq	a5,s8,826 <vprintf+0xba>
      } else if(c == 'l') {
 7ea:	05978c63          	beq	a5,s9,842 <vprintf+0xd6>
      } else if(c == 'x') {
 7ee:	07a78863          	beq	a5,s10,85e <vprintf+0xf2>
      } else if(c == 'p') {
 7f2:	09b78463          	beq	a5,s11,87a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7f6:	07300713          	li	a4,115
 7fa:	0ce78663          	beq	a5,a4,8c6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7fe:	06300713          	li	a4,99
 802:	0ee78e63          	beq	a5,a4,8fe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 806:	11478863          	beq	a5,s4,916 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 80a:	85d2                	mv	a1,s4
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e92080e7          	jalr	-366(ra) # 6a0 <putc>
        putc(fd, c);
 816:	85ca                	mv	a1,s2
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e86080e7          	jalr	-378(ra) # 6a0 <putc>
      }
      state = 0;
 822:	4981                	li	s3,0
 824:	b765                	j	7cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 826:	008b0913          	addi	s2,s6,8
 82a:	4685                	li	a3,1
 82c:	4629                	li	a2,10
 82e:	000b2583          	lw	a1,0(s6)
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e8e080e7          	jalr	-370(ra) # 6c2 <printint>
 83c:	8b4a                	mv	s6,s2
      state = 0;
 83e:	4981                	li	s3,0
 840:	b771                	j	7cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 842:	008b0913          	addi	s2,s6,8
 846:	4681                	li	a3,0
 848:	4629                	li	a2,10
 84a:	000b2583          	lw	a1,0(s6)
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	e72080e7          	jalr	-398(ra) # 6c2 <printint>
 858:	8b4a                	mv	s6,s2
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bf85                	j	7cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 85e:	008b0913          	addi	s2,s6,8
 862:	4681                	li	a3,0
 864:	4641                	li	a2,16
 866:	000b2583          	lw	a1,0(s6)
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	e56080e7          	jalr	-426(ra) # 6c2 <printint>
 874:	8b4a                	mv	s6,s2
      state = 0;
 876:	4981                	li	s3,0
 878:	bf91                	j	7cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 87a:	008b0793          	addi	a5,s6,8
 87e:	f8f43423          	sd	a5,-120(s0)
 882:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 886:	03000593          	li	a1,48
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e14080e7          	jalr	-492(ra) # 6a0 <putc>
  putc(fd, 'x');
 894:	85ea                	mv	a1,s10
 896:	8556                	mv	a0,s5
 898:	00000097          	auipc	ra,0x0
 89c:	e08080e7          	jalr	-504(ra) # 6a0 <putc>
 8a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a2:	03c9d793          	srli	a5,s3,0x3c
 8a6:	97de                	add	a5,a5,s7
 8a8:	0007c583          	lbu	a1,0(a5)
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	df2080e7          	jalr	-526(ra) # 6a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8b6:	0992                	slli	s3,s3,0x4
 8b8:	397d                	addiw	s2,s2,-1
 8ba:	fe0914e3          	bnez	s2,8a2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b721                	j	7cc <vprintf+0x60>
        s = va_arg(ap, char*);
 8c6:	008b0993          	addi	s3,s6,8
 8ca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8ce:	02090163          	beqz	s2,8f0 <vprintf+0x184>
        while(*s != 0){
 8d2:	00094583          	lbu	a1,0(s2)
 8d6:	c9a1                	beqz	a1,926 <vprintf+0x1ba>
          putc(fd, *s);
 8d8:	8556                	mv	a0,s5
 8da:	00000097          	auipc	ra,0x0
 8de:	dc6080e7          	jalr	-570(ra) # 6a0 <putc>
          s++;
 8e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 8e4:	00094583          	lbu	a1,0(s2)
 8e8:	f9e5                	bnez	a1,8d8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 8ea:	8b4e                	mv	s6,s3
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	bdf9                	j	7cc <vprintf+0x60>
          s = "(null)";
 8f0:	00000917          	auipc	s2,0x0
 8f4:	33890913          	addi	s2,s2,824 # c28 <malloc+0x1f2>
        while(*s != 0){
 8f8:	02800593          	li	a1,40
 8fc:	bff1                	j	8d8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8fe:	008b0913          	addi	s2,s6,8
 902:	000b4583          	lbu	a1,0(s6)
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	d98080e7          	jalr	-616(ra) # 6a0 <putc>
 910:	8b4a                	mv	s6,s2
      state = 0;
 912:	4981                	li	s3,0
 914:	bd65                	j	7cc <vprintf+0x60>
        putc(fd, c);
 916:	85d2                	mv	a1,s4
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	d86080e7          	jalr	-634(ra) # 6a0 <putc>
      state = 0;
 922:	4981                	li	s3,0
 924:	b565                	j	7cc <vprintf+0x60>
        s = va_arg(ap, char*);
 926:	8b4e                	mv	s6,s3
      state = 0;
 928:	4981                	li	s3,0
 92a:	b54d                	j	7cc <vprintf+0x60>
    }
  }
}
 92c:	70e6                	ld	ra,120(sp)
 92e:	7446                	ld	s0,112(sp)
 930:	74a6                	ld	s1,104(sp)
 932:	7906                	ld	s2,96(sp)
 934:	69e6                	ld	s3,88(sp)
 936:	6a46                	ld	s4,80(sp)
 938:	6aa6                	ld	s5,72(sp)
 93a:	6b06                	ld	s6,64(sp)
 93c:	7be2                	ld	s7,56(sp)
 93e:	7c42                	ld	s8,48(sp)
 940:	7ca2                	ld	s9,40(sp)
 942:	7d02                	ld	s10,32(sp)
 944:	6de2                	ld	s11,24(sp)
 946:	6109                	addi	sp,sp,128
 948:	8082                	ret

000000000000094a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 94a:	715d                	addi	sp,sp,-80
 94c:	ec06                	sd	ra,24(sp)
 94e:	e822                	sd	s0,16(sp)
 950:	1000                	addi	s0,sp,32
 952:	e010                	sd	a2,0(s0)
 954:	e414                	sd	a3,8(s0)
 956:	e818                	sd	a4,16(s0)
 958:	ec1c                	sd	a5,24(s0)
 95a:	03043023          	sd	a6,32(s0)
 95e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 962:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 966:	8622                	mv	a2,s0
 968:	00000097          	auipc	ra,0x0
 96c:	e04080e7          	jalr	-508(ra) # 76c <vprintf>
}
 970:	60e2                	ld	ra,24(sp)
 972:	6442                	ld	s0,16(sp)
 974:	6161                	addi	sp,sp,80
 976:	8082                	ret

0000000000000978 <printf>:

void
printf(const char *fmt, ...)
{
 978:	711d                	addi	sp,sp,-96
 97a:	ec06                	sd	ra,24(sp)
 97c:	e822                	sd	s0,16(sp)
 97e:	1000                	addi	s0,sp,32
 980:	e40c                	sd	a1,8(s0)
 982:	e810                	sd	a2,16(s0)
 984:	ec14                	sd	a3,24(s0)
 986:	f018                	sd	a4,32(s0)
 988:	f41c                	sd	a5,40(s0)
 98a:	03043823          	sd	a6,48(s0)
 98e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 992:	00840613          	addi	a2,s0,8
 996:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 99a:	85aa                	mv	a1,a0
 99c:	4505                	li	a0,1
 99e:	00000097          	auipc	ra,0x0
 9a2:	dce080e7          	jalr	-562(ra) # 76c <vprintf>
}
 9a6:	60e2                	ld	ra,24(sp)
 9a8:	6442                	ld	s0,16(sp)
 9aa:	6125                	addi	sp,sp,96
 9ac:	8082                	ret

00000000000009ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ae:	1141                	addi	sp,sp,-16
 9b0:	e422                	sd	s0,8(sp)
 9b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b8:	00000797          	auipc	a5,0x0
 9bc:	2907b783          	ld	a5,656(a5) # c48 <freep>
 9c0:	a805                	j	9f0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9c2:	4618                	lw	a4,8(a2)
 9c4:	9db9                	addw	a1,a1,a4
 9c6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ca:	6398                	ld	a4,0(a5)
 9cc:	6318                	ld	a4,0(a4)
 9ce:	fee53823          	sd	a4,-16(a0)
 9d2:	a091                	j	a16 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d4:	ff852703          	lw	a4,-8(a0)
 9d8:	9e39                	addw	a2,a2,a4
 9da:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9dc:	ff053703          	ld	a4,-16(a0)
 9e0:	e398                	sd	a4,0(a5)
 9e2:	a099                	j	a28 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e4:	6398                	ld	a4,0(a5)
 9e6:	00e7e463          	bltu	a5,a4,9ee <free+0x40>
 9ea:	00e6ea63          	bltu	a3,a4,9fe <free+0x50>
{
 9ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f0:	fed7fae3          	bgeu	a5,a3,9e4 <free+0x36>
 9f4:	6398                	ld	a4,0(a5)
 9f6:	00e6e463          	bltu	a3,a4,9fe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fa:	fee7eae3          	bltu	a5,a4,9ee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9fe:	ff852583          	lw	a1,-8(a0)
 a02:	6390                	ld	a2,0(a5)
 a04:	02059713          	slli	a4,a1,0x20
 a08:	9301                	srli	a4,a4,0x20
 a0a:	0712                	slli	a4,a4,0x4
 a0c:	9736                	add	a4,a4,a3
 a0e:	fae60ae3          	beq	a2,a4,9c2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a12:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a16:	4790                	lw	a2,8(a5)
 a18:	02061713          	slli	a4,a2,0x20
 a1c:	9301                	srli	a4,a4,0x20
 a1e:	0712                	slli	a4,a4,0x4
 a20:	973e                	add	a4,a4,a5
 a22:	fae689e3          	beq	a3,a4,9d4 <free+0x26>
  } else
    p->s.ptr = bp;
 a26:	e394                	sd	a3,0(a5)
  freep = p;
 a28:	00000717          	auipc	a4,0x0
 a2c:	22f73023          	sd	a5,544(a4) # c48 <freep>
}
 a30:	6422                	ld	s0,8(sp)
 a32:	0141                	addi	sp,sp,16
 a34:	8082                	ret

0000000000000a36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a36:	7139                	addi	sp,sp,-64
 a38:	fc06                	sd	ra,56(sp)
 a3a:	f822                	sd	s0,48(sp)
 a3c:	f426                	sd	s1,40(sp)
 a3e:	f04a                	sd	s2,32(sp)
 a40:	ec4e                	sd	s3,24(sp)
 a42:	e852                	sd	s4,16(sp)
 a44:	e456                	sd	s5,8(sp)
 a46:	e05a                	sd	s6,0(sp)
 a48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4a:	02051493          	slli	s1,a0,0x20
 a4e:	9081                	srli	s1,s1,0x20
 a50:	04bd                	addi	s1,s1,15
 a52:	8091                	srli	s1,s1,0x4
 a54:	0014899b          	addiw	s3,s1,1
 a58:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a5a:	00000517          	auipc	a0,0x0
 a5e:	1ee53503          	ld	a0,494(a0) # c48 <freep>
 a62:	c515                	beqz	a0,a8e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a66:	4798                	lw	a4,8(a5)
 a68:	02977f63          	bgeu	a4,s1,aa6 <malloc+0x70>
 a6c:	8a4e                	mv	s4,s3
 a6e:	0009871b          	sext.w	a4,s3
 a72:	6685                	lui	a3,0x1
 a74:	00d77363          	bgeu	a4,a3,a7a <malloc+0x44>
 a78:	6a05                	lui	s4,0x1
 a7a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a7e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a82:	00000917          	auipc	s2,0x0
 a86:	1c690913          	addi	s2,s2,454 # c48 <freep>
  if(p == (char*)-1)
 a8a:	5afd                	li	s5,-1
 a8c:	a88d                	j	afe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a8e:	00000797          	auipc	a5,0x0
 a92:	1c278793          	addi	a5,a5,450 # c50 <base>
 a96:	00000717          	auipc	a4,0x0
 a9a:	1af73923          	sd	a5,434(a4) # c48 <freep>
 a9e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa4:	b7e1                	j	a6c <malloc+0x36>
      if(p->s.size == nunits)
 aa6:	02e48b63          	beq	s1,a4,adc <malloc+0xa6>
        p->s.size -= nunits;
 aaa:	4137073b          	subw	a4,a4,s3
 aae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab0:	1702                	slli	a4,a4,0x20
 ab2:	9301                	srli	a4,a4,0x20
 ab4:	0712                	slli	a4,a4,0x4
 ab6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 abc:	00000717          	auipc	a4,0x0
 ac0:	18a73623          	sd	a0,396(a4) # c48 <freep>
      return (void*)(p + 1);
 ac4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ac8:	70e2                	ld	ra,56(sp)
 aca:	7442                	ld	s0,48(sp)
 acc:	74a2                	ld	s1,40(sp)
 ace:	7902                	ld	s2,32(sp)
 ad0:	69e2                	ld	s3,24(sp)
 ad2:	6a42                	ld	s4,16(sp)
 ad4:	6aa2                	ld	s5,8(sp)
 ad6:	6b02                	ld	s6,0(sp)
 ad8:	6121                	addi	sp,sp,64
 ada:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 adc:	6398                	ld	a4,0(a5)
 ade:	e118                	sd	a4,0(a0)
 ae0:	bff1                	j	abc <malloc+0x86>
  hp->s.size = nu;
 ae2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ae6:	0541                	addi	a0,a0,16
 ae8:	00000097          	auipc	ra,0x0
 aec:	ec6080e7          	jalr	-314(ra) # 9ae <free>
  return freep;
 af0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 af4:	d971                	beqz	a0,ac8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 af8:	4798                	lw	a4,8(a5)
 afa:	fa9776e3          	bgeu	a4,s1,aa6 <malloc+0x70>
    if(p == freep)
 afe:	00093703          	ld	a4,0(s2)
 b02:	853e                	mv	a0,a5
 b04:	fef719e3          	bne	a4,a5,af6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b08:	8552                	mv	a0,s4
 b0a:	00000097          	auipc	ra,0x0
 b0e:	ad4080e7          	jalr	-1324(ra) # 5de <sbrk>
  if(p == (char*)-1)
 b12:	fd5518e3          	bne	a0,s5,ae2 <malloc+0xac>
        return 0;
 b16:	4501                	li	a0,0
 b18:	bf45                	j	ac8 <malloc+0x92>
