
user/_primefactors:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primefactors>:

int primes[]={2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97};
//global array of primes in between one and hundred : 25 primes 

void primefactors(int n, int ind)
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	0880                	addi	s0,sp,80
  10:	faa42e23          	sw	a0,-68(s0)
	if(n==1 || ind==25) return;
  14:	2501                	sext.w	a0,a0
  16:	4785                	li	a5,1
  18:	0af50b63          	beq	a0,a5,ce <primefactors+0xce>
  1c:	89ae                	mv	s3,a1
  1e:	47e5                	li	a5,25
  20:	0af58763          	beq	a1,a5,ce <primefactors+0xce>
	int p[2];
	int t= pipe(p);
  24:	fc840513          	addi	a0,s0,-56
  28:	00000097          	auipc	ra,0x0
  2c:	44e080e7          	jalr	1102(ra) # 476 <pipe>
	int temp;
	if(t<0) exit(1); //pipe creation failed 
  30:	0a054763          	bltz	a0,de <primefactors+0xde>
	int id= fork();
  34:	00000097          	auipc	ra,0x0
  38:	42a080e7          	jalr	1066(ra) # 45e <fork>
	if(id>0) // 24  
  3c:	0ca05563          	blez	a0,106 <primefactors+0x106>
	{
		int power=0;
		while(n%primes[ind]==0 && n>1)
  40:	fbc42783          	lw	a5,-68(s0)
  44:	00299693          	slli	a3,s3,0x2
  48:	00001717          	auipc	a4,0x1
  4c:	9c870713          	addi	a4,a4,-1592 # a10 <primes>
  50:	9736                	add	a4,a4,a3
  52:	4310                	lw	a2,0(a4)
  54:	02c7e4bb          	remw	s1,a5,a2
  58:	ecf5                	bnez	s1,154 <primefactors+0x154>
  5a:	4905                	li	s2,1
		{
			n/= primes[ind];
			power++;	
			fprintf(1,"%d, ",primes[ind]);
  5c:	00001a17          	auipc	s4,0x1
  60:	924a0a13          	addi	s4,s4,-1756 # 980 <malloc+0xe4>
		while(n%primes[ind]==0 && n>1)
  64:	00001717          	auipc	a4,0x1
  68:	9ac70713          	addi	a4,a4,-1620 # a10 <primes>
  6c:	00d709b3          	add	s3,a4,a3
  70:	02f95463          	bge	s2,a5,98 <primefactors+0x98>
			n/= primes[ind];
  74:	02c7c7bb          	divw	a5,a5,a2
  78:	faf42e23          	sw	a5,-68(s0)
			power++;	
  7c:	2485                	addiw	s1,s1,1
			fprintf(1,"%d, ",primes[ind]);
  7e:	85d2                	mv	a1,s4
  80:	854a                	mv	a0,s2
  82:	00000097          	auipc	ra,0x0
  86:	72e080e7          	jalr	1838(ra) # 7b0 <fprintf>
		while(n%primes[ind]==0 && n>1)
  8a:	fbc42783          	lw	a5,-68(s0)
  8e:	0009a603          	lw	a2,0(s3)
  92:	02c7e73b          	remw	a4,a5,a2
  96:	df69                	beqz	a4,70 <primefactors+0x70>
		}
		close(p[0]);
  98:	fc842503          	lw	a0,-56(s0)
  9c:	00000097          	auipc	ra,0x0
  a0:	3f2080e7          	jalr	1010(ra) # 48e <close>
		write(p[1], &n, sizeof(int) );
  a4:	4611                	li	a2,4
  a6:	fbc40593          	addi	a1,s0,-68
  aa:	fcc42503          	lw	a0,-52(s0)
  ae:	00000097          	auipc	ra,0x0
  b2:	3d8080e7          	jalr	984(ra) # 486 <write>
		close(p[1]);
  b6:	fcc42503          	lw	a0,-52(s0)
  ba:	00000097          	auipc	ra,0x0
  be:	3d4080e7          	jalr	980(ra) # 48e <close>
		if(power!=0) fprintf(1,"[%d]\n",getpid());
  c2:	e09d                	bnez	s1,e8 <primefactors+0xe8>
		wait(0);
  c4:	4501                	li	a0,0
  c6:	00000097          	auipc	ra,0x0
  ca:	3a8080e7          	jalr	936(ra) # 46e <wait>
		close(p[0]); //close the read end of the pipe 
		primefactors(n, ind+1); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
		exit(0);	
	}
	return;
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6161                	addi	sp,sp,80
  dc:	8082                	ret
	if(t<0) exit(1); //pipe creation failed 
  de:	4505                	li	a0,1
  e0:	00000097          	auipc	ra,0x0
  e4:	386080e7          	jalr	902(ra) # 466 <exit>
		if(power!=0) fprintf(1,"[%d]\n",getpid());
  e8:	00000097          	auipc	ra,0x0
  ec:	3fe080e7          	jalr	1022(ra) # 4e6 <getpid>
  f0:	862a                	mv	a2,a0
  f2:	00001597          	auipc	a1,0x1
  f6:	89658593          	addi	a1,a1,-1898 # 988 <malloc+0xec>
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	6b4080e7          	jalr	1716(ra) # 7b0 <fprintf>
 104:	b7c1                	j	c4 <primefactors+0xc4>
		sleep(0);
 106:	4501                	li	a0,0
 108:	00000097          	auipc	ra,0x0
 10c:	3ee080e7          	jalr	1006(ra) # 4f6 <sleep>
		close(p[1]); // child will not write anything 
 110:	fcc42503          	lw	a0,-52(s0)
 114:	00000097          	auipc	ra,0x0
 118:	37a080e7          	jalr	890(ra) # 48e <close>
		read(p[0], &temp, sizeof(int)); // reads value of n from pipe 
 11c:	4611                	li	a2,4
 11e:	fc440593          	addi	a1,s0,-60
 122:	fc842503          	lw	a0,-56(s0)
 126:	00000097          	auipc	ra,0x0
 12a:	358080e7          	jalr	856(ra) # 47e <read>
		close(p[0]); //close the read end of the pipe 
 12e:	fc842503          	lw	a0,-56(s0)
 132:	00000097          	auipc	ra,0x0
 136:	35c080e7          	jalr	860(ra) # 48e <close>
		primefactors(n, ind+1); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
 13a:	0019859b          	addiw	a1,s3,1
 13e:	fbc42503          	lw	a0,-68(s0)
 142:	00000097          	auipc	ra,0x0
 146:	ebe080e7          	jalr	-322(ra) # 0 <primefactors>
		exit(0);	
 14a:	4501                	li	a0,0
 14c:	00000097          	auipc	ra,0x0
 150:	31a080e7          	jalr	794(ra) # 466 <exit>
		close(p[0]);
 154:	fc842503          	lw	a0,-56(s0)
 158:	00000097          	auipc	ra,0x0
 15c:	336080e7          	jalr	822(ra) # 48e <close>
		write(p[1], &n, sizeof(int) );
 160:	4611                	li	a2,4
 162:	fbc40593          	addi	a1,s0,-68
 166:	fcc42503          	lw	a0,-52(s0)
 16a:	00000097          	auipc	ra,0x0
 16e:	31c080e7          	jalr	796(ra) # 486 <write>
		close(p[1]);
 172:	fcc42503          	lw	a0,-52(s0)
 176:	00000097          	auipc	ra,0x0
 17a:	318080e7          	jalr	792(ra) # 48e <close>
		if(power!=0) fprintf(1,"[%d]\n",getpid());
 17e:	b799                	j	c4 <primefactors+0xc4>

0000000000000180 <main>:

int main(int argc, char *argv[])
{
 180:	1141                	addi	sp,sp,-16
 182:	e406                	sd	ra,8(sp)
 184:	e022                	sd	s0,0(sp)
 186:	0800                	addi	s0,sp,16
	if(argc!=2)
 188:	4789                	li	a5,2
 18a:	02f50063          	beq	a0,a5,1aa <main+0x2a>
	{
		fprintf(2, "usage: primefactors n\n");
 18e:	00001597          	auipc	a1,0x1
 192:	80258593          	addi	a1,a1,-2046 # 990 <malloc+0xf4>
 196:	4509                	li	a0,2
 198:	00000097          	auipc	ra,0x0
 19c:	618080e7          	jalr	1560(ra) # 7b0 <fprintf>
		exit(1);        
 1a0:	4505                	li	a0,1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	2c4080e7          	jalr	708(ra) # 466 <exit>
	}
	int n;
	n=atoi(argv[1]); // converts to integer 
 1aa:	6588                	ld	a0,8(a1)
 1ac:	00000097          	auipc	ra,0x0
 1b0:	1ba080e7          	jalr	442(ra) # 366 <atoi>
	if(n>100 || n<2)
 1b4:	ffe5071b          	addiw	a4,a0,-2
 1b8:	06200793          	li	a5,98
 1bc:	02e7f063          	bgeu	a5,a4,1dc <main+0x5c>
	{
		fprintf(2, "usage: pipeline n. n must be in between 2 and 100, both inclusive.\n");
 1c0:	00000597          	auipc	a1,0x0
 1c4:	7e858593          	addi	a1,a1,2024 # 9a8 <malloc+0x10c>
 1c8:	4509                	li	a0,2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	5e6080e7          	jalr	1510(ra) # 7b0 <fprintf>
		exit(1);
 1d2:	4505                	li	a0,1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	292080e7          	jalr	658(ra) # 466 <exit>
	}
	primefactors(n, 0);
 1dc:	4581                	li	a1,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	e22080e7          	jalr	-478(ra) # 0 <primefactors>
	exit(0);
 1e6:	4501                	li	a0,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	27e080e7          	jalr	638(ra) # 466 <exit>

00000000000001f0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f6:	87aa                	mv	a5,a0
 1f8:	0585                	addi	a1,a1,1
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff5c703          	lbu	a4,-1(a1)
 200:	fee78fa3          	sb	a4,-1(a5)
 204:	fb75                	bnez	a4,1f8 <strcpy+0x8>
    ;
  return os;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 212:	00054783          	lbu	a5,0(a0)
 216:	cb91                	beqz	a5,22a <strcmp+0x1e>
 218:	0005c703          	lbu	a4,0(a1)
 21c:	00f71763          	bne	a4,a5,22a <strcmp+0x1e>
    p++, q++;
 220:	0505                	addi	a0,a0,1
 222:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 224:	00054783          	lbu	a5,0(a0)
 228:	fbe5                	bnez	a5,218 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 22a:	0005c503          	lbu	a0,0(a1)
}
 22e:	40a7853b          	subw	a0,a5,a0
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strlen>:

uint
strlen(const char *s)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cf91                	beqz	a5,25e <strlen+0x26>
 244:	0505                	addi	a0,a0,1
 246:	87aa                	mv	a5,a0
 248:	4685                	li	a3,1
 24a:	9e89                	subw	a3,a3,a0
 24c:	00f6853b          	addw	a0,a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	fb7d                	bnez	a4,24c <strlen+0x14>
    ;
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  for(n = 0; s[n]; n++)
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strlen+0x20>

0000000000000262 <memset>:

void*
memset(void *dst, int c, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 268:	ce09                	beqz	a2,282 <memset+0x20>
 26a:	87aa                	mv	a5,a0
 26c:	fff6071b          	addiw	a4,a2,-1
 270:	1702                	slli	a4,a4,0x20
 272:	9301                	srli	a4,a4,0x20
 274:	0705                	addi	a4,a4,1
 276:	972a                	add	a4,a4,a0
    cdst[i] = c;
 278:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27c:	0785                	addi	a5,a5,1
 27e:	fee79de3          	bne	a5,a4,278 <memset+0x16>
  }
  return dst;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strchr>:

char*
strchr(const char *s, char c)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb99                	beqz	a5,2a8 <strchr+0x20>
    if(*s == c)
 294:	00f58763          	beq	a1,a5,2a2 <strchr+0x1a>
  for(; *s; s++)
 298:	0505                	addi	a0,a0,1
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbfd                	bnez	a5,294 <strchr+0xc>
      return (char*)s;
  return 0;
 2a0:	4501                	li	a0,0
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	bfe5                	j	2a2 <strchr+0x1a>

00000000000002ac <gets>:

char*
gets(char *buf, int max)
{
 2ac:	711d                	addi	sp,sp,-96
 2ae:	ec86                	sd	ra,88(sp)
 2b0:	e8a2                	sd	s0,80(sp)
 2b2:	e4a6                	sd	s1,72(sp)
 2b4:	e0ca                	sd	s2,64(sp)
 2b6:	fc4e                	sd	s3,56(sp)
 2b8:	f852                	sd	s4,48(sp)
 2ba:	f456                	sd	s5,40(sp)
 2bc:	f05a                	sd	s6,32(sp)
 2be:	ec5e                	sd	s7,24(sp)
 2c0:	1080                	addi	s0,sp,96
 2c2:	8baa                	mv	s7,a0
 2c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	892a                	mv	s2,a0
 2c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ca:	4aa9                	li	s5,10
 2cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ce:	89a6                	mv	s3,s1
 2d0:	2485                	addiw	s1,s1,1
 2d2:	0344d863          	bge	s1,s4,302 <gets+0x56>
    cc = read(0, &c, 1);
 2d6:	4605                	li	a2,1
 2d8:	faf40593          	addi	a1,s0,-81
 2dc:	4501                	li	a0,0
 2de:	00000097          	auipc	ra,0x0
 2e2:	1a0080e7          	jalr	416(ra) # 47e <read>
    if(cc < 1)
 2e6:	00a05e63          	blez	a0,302 <gets+0x56>
    buf[i++] = c;
 2ea:	faf44783          	lbu	a5,-81(s0)
 2ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f2:	01578763          	beq	a5,s5,300 <gets+0x54>
 2f6:	0905                	addi	s2,s2,1
 2f8:	fd679be3          	bne	a5,s6,2ce <gets+0x22>
  for(i=0; i+1 < max; ){
 2fc:	89a6                	mv	s3,s1
 2fe:	a011                	j	302 <gets+0x56>
 300:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 302:	99de                	add	s3,s3,s7
 304:	00098023          	sb	zero,0(s3)
  return buf;
}
 308:	855e                	mv	a0,s7
 30a:	60e6                	ld	ra,88(sp)
 30c:	6446                	ld	s0,80(sp)
 30e:	64a6                	ld	s1,72(sp)
 310:	6906                	ld	s2,64(sp)
 312:	79e2                	ld	s3,56(sp)
 314:	7a42                	ld	s4,48(sp)
 316:	7aa2                	ld	s5,40(sp)
 318:	7b02                	ld	s6,32(sp)
 31a:	6be2                	ld	s7,24(sp)
 31c:	6125                	addi	sp,sp,96
 31e:	8082                	ret

0000000000000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	e426                	sd	s1,8(sp)
 328:	e04a                	sd	s2,0(sp)
 32a:	1000                	addi	s0,sp,32
 32c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32e:	4581                	li	a1,0
 330:	00000097          	auipc	ra,0x0
 334:	176080e7          	jalr	374(ra) # 4a6 <open>
  if(fd < 0)
 338:	02054563          	bltz	a0,362 <stat+0x42>
 33c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33e:	85ca                	mv	a1,s2
 340:	00000097          	auipc	ra,0x0
 344:	17e080e7          	jalr	382(ra) # 4be <fstat>
 348:	892a                	mv	s2,a0
  close(fd);
 34a:	8526                	mv	a0,s1
 34c:	00000097          	auipc	ra,0x0
 350:	142080e7          	jalr	322(ra) # 48e <close>
  return r;
}
 354:	854a                	mv	a0,s2
 356:	60e2                	ld	ra,24(sp)
 358:	6442                	ld	s0,16(sp)
 35a:	64a2                	ld	s1,8(sp)
 35c:	6902                	ld	s2,0(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret
    return -1;
 362:	597d                	li	s2,-1
 364:	bfc5                	j	354 <stat+0x34>

0000000000000366 <atoi>:

int
atoi(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36c:	00054603          	lbu	a2,0(a0)
 370:	fd06079b          	addiw	a5,a2,-48
 374:	0ff7f793          	andi	a5,a5,255
 378:	4725                	li	a4,9
 37a:	02f76963          	bltu	a4,a5,3ac <atoi+0x46>
 37e:	86aa                	mv	a3,a0
  n = 0;
 380:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 382:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 384:	0685                	addi	a3,a3,1
 386:	0025179b          	slliw	a5,a0,0x2
 38a:	9fa9                	addw	a5,a5,a0
 38c:	0017979b          	slliw	a5,a5,0x1
 390:	9fb1                	addw	a5,a5,a2
 392:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 396:	0006c603          	lbu	a2,0(a3)
 39a:	fd06071b          	addiw	a4,a2,-48
 39e:	0ff77713          	andi	a4,a4,255
 3a2:	fee5f1e3          	bgeu	a1,a4,384 <atoi+0x1e>
  return n;
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  n = 0;
 3ac:	4501                	li	a0,0
 3ae:	bfe5                	j	3a6 <atoi+0x40>

00000000000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b6:	02b57663          	bgeu	a0,a1,3e2 <memmove+0x32>
    while(n-- > 0)
 3ba:	02c05163          	blez	a2,3dc <memmove+0x2c>
 3be:	fff6079b          	addiw	a5,a2,-1
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	0785                	addi	a5,a5,1
 3c8:	97aa                	add	a5,a5,a0
  dst = vdst;
 3ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 3cc:	0585                	addi	a1,a1,1
 3ce:	0705                	addi	a4,a4,1
 3d0:	fff5c683          	lbu	a3,-1(a1)
 3d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret
    dst += n;
 3e2:	00c50733          	add	a4,a0,a2
    src += n;
 3e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e8:	fec05ae3          	blez	a2,3dc <memmove+0x2c>
 3ec:	fff6079b          	addiw	a5,a2,-1
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	fff7c793          	not	a5,a5
 3f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fa:	15fd                	addi	a1,a1,-1
 3fc:	177d                	addi	a4,a4,-1
 3fe:	0005c683          	lbu	a3,0(a1)
 402:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 406:	fee79ae3          	bne	a5,a4,3fa <memmove+0x4a>
 40a:	bfc9                	j	3dc <memmove+0x2c>

000000000000040c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 412:	ca05                	beqz	a2,442 <memcmp+0x36>
 414:	fff6069b          	addiw	a3,a2,-1
 418:	1682                	slli	a3,a3,0x20
 41a:	9281                	srli	a3,a3,0x20
 41c:	0685                	addi	a3,a3,1
 41e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 420:	00054783          	lbu	a5,0(a0)
 424:	0005c703          	lbu	a4,0(a1)
 428:	00e79863          	bne	a5,a4,438 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 42c:	0505                	addi	a0,a0,1
    p2++;
 42e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 430:	fed518e3          	bne	a0,a3,420 <memcmp+0x14>
  }
  return 0;
 434:	4501                	li	a0,0
 436:	a019                	j	43c <memcmp+0x30>
      return *p1 - *p2;
 438:	40e7853b          	subw	a0,a5,a4
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
  return 0;
 442:	4501                	li	a0,0
 444:	bfe5                	j	43c <memcmp+0x30>

0000000000000446 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 446:	1141                	addi	sp,sp,-16
 448:	e406                	sd	ra,8(sp)
 44a:	e022                	sd	s0,0(sp)
 44c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 44e:	00000097          	auipc	ra,0x0
 452:	f62080e7          	jalr	-158(ra) # 3b0 <memmove>
}
 456:	60a2                	ld	ra,8(sp)
 458:	6402                	ld	s0,0(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret

000000000000045e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 45e:	4885                	li	a7,1
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <exit>:
.global exit
exit:
 li a7, SYS_exit
 466:	4889                	li	a7,2
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <wait>:
.global wait
wait:
 li a7, SYS_wait
 46e:	488d                	li	a7,3
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 476:	4891                	li	a7,4
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <read>:
.global read
read:
 li a7, SYS_read
 47e:	4895                	li	a7,5
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <write>:
.global write
write:
 li a7, SYS_write
 486:	48c1                	li	a7,16
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <close>:
.global close
close:
 li a7, SYS_close
 48e:	48d5                	li	a7,21
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <kill>:
.global kill
kill:
 li a7, SYS_kill
 496:	4899                	li	a7,6
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <exec>:
.global exec
exec:
 li a7, SYS_exec
 49e:	489d                	li	a7,7
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <open>:
.global open
open:
 li a7, SYS_open
 4a6:	48bd                	li	a7,15
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ae:	48c5                	li	a7,17
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b6:	48c9                	li	a7,18
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4be:	48a1                	li	a7,8
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <link>:
.global link
link:
 li a7, SYS_link
 4c6:	48cd                	li	a7,19
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ce:	48d1                	li	a7,20
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d6:	48a5                	li	a7,9
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <dup>:
.global dup
dup:
 li a7, SYS_dup
 4de:	48a9                	li	a7,10
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e6:	48ad                	li	a7,11
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ee:	48b1                	li	a7,12
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f6:	48b5                	li	a7,13
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4fe:	48b9                	li	a7,14
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 506:	1101                	addi	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	1000                	addi	s0,sp,32
 50e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 512:	4605                	li	a2,1
 514:	fef40593          	addi	a1,s0,-17
 518:	00000097          	auipc	ra,0x0
 51c:	f6e080e7          	jalr	-146(ra) # 486 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	f04a                	sd	s2,32(sp)
 532:	ec4e                	sd	s3,24(sp)
 534:	0080                	addi	s0,sp,64
 536:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 538:	c299                	beqz	a3,53e <printint+0x16>
 53a:	0805c863          	bltz	a1,5ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53e:	2581                	sext.w	a1,a1
  neg = 0;
 540:	4881                	li	a7,0
 542:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 546:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 548:	2601                	sext.w	a2,a2
 54a:	00000517          	auipc	a0,0x0
 54e:	4ae50513          	addi	a0,a0,1198 # 9f8 <digits>
 552:	883a                	mv	a6,a4
 554:	2705                	addiw	a4,a4,1
 556:	02c5f7bb          	remuw	a5,a1,a2
 55a:	1782                	slli	a5,a5,0x20
 55c:	9381                	srli	a5,a5,0x20
 55e:	97aa                	add	a5,a5,a0
 560:	0007c783          	lbu	a5,0(a5)
 564:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 568:	0005879b          	sext.w	a5,a1
 56c:	02c5d5bb          	divuw	a1,a1,a2
 570:	0685                	addi	a3,a3,1
 572:	fec7f0e3          	bgeu	a5,a2,552 <printint+0x2a>
  if(neg)
 576:	00088b63          	beqz	a7,58c <printint+0x64>
    buf[i++] = '-';
 57a:	fd040793          	addi	a5,s0,-48
 57e:	973e                	add	a4,a4,a5
 580:	02d00793          	li	a5,45
 584:	fef70823          	sb	a5,-16(a4)
 588:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58c:	02e05863          	blez	a4,5bc <printint+0x94>
 590:	fc040793          	addi	a5,s0,-64
 594:	00e78933          	add	s2,a5,a4
 598:	fff78993          	addi	s3,a5,-1
 59c:	99ba                	add	s3,s3,a4
 59e:	377d                	addiw	a4,a4,-1
 5a0:	1702                	slli	a4,a4,0x20
 5a2:	9301                	srli	a4,a4,0x20
 5a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a8:	fff94583          	lbu	a1,-1(s2)
 5ac:	8526                	mv	a0,s1
 5ae:	00000097          	auipc	ra,0x0
 5b2:	f58080e7          	jalr	-168(ra) # 506 <putc>
  while(--i >= 0)
 5b6:	197d                	addi	s2,s2,-1
 5b8:	ff3918e3          	bne	s2,s3,5a8 <printint+0x80>
}
 5bc:	70e2                	ld	ra,56(sp)
 5be:	7442                	ld	s0,48(sp)
 5c0:	74a2                	ld	s1,40(sp)
 5c2:	7902                	ld	s2,32(sp)
 5c4:	69e2                	ld	s3,24(sp)
 5c6:	6121                	addi	sp,sp,64
 5c8:	8082                	ret
    x = -xx;
 5ca:	40b005bb          	negw	a1,a1
    neg = 1;
 5ce:	4885                	li	a7,1
    x = -xx;
 5d0:	bf8d                	j	542 <printint+0x1a>

00000000000005d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d2:	7119                	addi	sp,sp,-128
 5d4:	fc86                	sd	ra,120(sp)
 5d6:	f8a2                	sd	s0,112(sp)
 5d8:	f4a6                	sd	s1,104(sp)
 5da:	f0ca                	sd	s2,96(sp)
 5dc:	ecce                	sd	s3,88(sp)
 5de:	e8d2                	sd	s4,80(sp)
 5e0:	e4d6                	sd	s5,72(sp)
 5e2:	e0da                	sd	s6,64(sp)
 5e4:	fc5e                	sd	s7,56(sp)
 5e6:	f862                	sd	s8,48(sp)
 5e8:	f466                	sd	s9,40(sp)
 5ea:	f06a                	sd	s10,32(sp)
 5ec:	ec6e                	sd	s11,24(sp)
 5ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f0:	0005c903          	lbu	s2,0(a1)
 5f4:	18090f63          	beqz	s2,792 <vprintf+0x1c0>
 5f8:	8aaa                	mv	s5,a0
 5fa:	8b32                	mv	s6,a2
 5fc:	00158493          	addi	s1,a1,1
  state = 0;
 600:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 602:	02500a13          	li	s4,37
      if(c == 'd'){
 606:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 60a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 60e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 612:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	3e2b8b93          	addi	s7,s7,994 # 9f8 <digits>
 61e:	a839                	j	63c <vprintf+0x6a>
        putc(fd, c);
 620:	85ca                	mv	a1,s2
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	ee2080e7          	jalr	-286(ra) # 506 <putc>
 62c:	a019                	j	632 <vprintf+0x60>
    } else if(state == '%'){
 62e:	01498f63          	beq	s3,s4,64c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 632:	0485                	addi	s1,s1,1
 634:	fff4c903          	lbu	s2,-1(s1)
 638:	14090d63          	beqz	s2,792 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 63c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 640:	fe0997e3          	bnez	s3,62e <vprintf+0x5c>
      if(c == '%'){
 644:	fd479ee3          	bne	a5,s4,620 <vprintf+0x4e>
        state = '%';
 648:	89be                	mv	s3,a5
 64a:	b7e5                	j	632 <vprintf+0x60>
      if(c == 'd'){
 64c:	05878063          	beq	a5,s8,68c <vprintf+0xba>
      } else if(c == 'l') {
 650:	05978c63          	beq	a5,s9,6a8 <vprintf+0xd6>
      } else if(c == 'x') {
 654:	07a78863          	beq	a5,s10,6c4 <vprintf+0xf2>
      } else if(c == 'p') {
 658:	09b78463          	beq	a5,s11,6e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 65c:	07300713          	li	a4,115
 660:	0ce78663          	beq	a5,a4,72c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 664:	06300713          	li	a4,99
 668:	0ee78e63          	beq	a5,a4,764 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 66c:	11478863          	beq	a5,s4,77c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 670:	85d2                	mv	a1,s4
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e92080e7          	jalr	-366(ra) # 506 <putc>
        putc(fd, c);
 67c:	85ca                	mv	a1,s2
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e86080e7          	jalr	-378(ra) # 506 <putc>
      }
      state = 0;
 688:	4981                	li	s3,0
 68a:	b765                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 68c:	008b0913          	addi	s2,s6,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e8e080e7          	jalr	-370(ra) # 528 <printint>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b771                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b0913          	addi	s2,s6,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000b2583          	lw	a1,0(s6)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e72080e7          	jalr	-398(ra) # 528 <printint>
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bf85                	j	632 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6c4:	008b0913          	addi	s2,s6,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000b2583          	lw	a1,0(s6)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e56080e7          	jalr	-426(ra) # 528 <printint>
 6da:	8b4a                	mv	s6,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bf91                	j	632 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e0:	008b0793          	addi	a5,s6,8
 6e4:	f8f43423          	sd	a5,-120(s0)
 6e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ec:	03000593          	li	a1,48
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e14080e7          	jalr	-492(ra) # 506 <putc>
  putc(fd, 'x');
 6fa:	85ea                	mv	a1,s10
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e08080e7          	jalr	-504(ra) # 506 <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	03c9d793          	srli	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	df2080e7          	jalr	-526(ra) # 506 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	397d                	addiw	s2,s2,-1
 720:	fe0914e3          	bnez	s2,708 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 724:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 728:	4981                	li	s3,0
 72a:	b721                	j	632 <vprintf+0x60>
        s = va_arg(ap, char*);
 72c:	008b0993          	addi	s3,s6,8
 730:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 734:	02090163          	beqz	s2,756 <vprintf+0x184>
        while(*s != 0){
 738:	00094583          	lbu	a1,0(s2)
 73c:	c9a1                	beqz	a1,78c <vprintf+0x1ba>
          putc(fd, *s);
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	dc6080e7          	jalr	-570(ra) # 506 <putc>
          s++;
 748:	0905                	addi	s2,s2,1
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9e5                	bnez	a1,73e <vprintf+0x16c>
        s = va_arg(ap, char*);
 750:	8b4e                	mv	s6,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bdf9                	j	632 <vprintf+0x60>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	29a90913          	addi	s2,s2,666 # 9f0 <malloc+0x154>
        while(*s != 0){
 75e:	02800593          	li	a1,40
 762:	bff1                	j	73e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 764:	008b0913          	addi	s2,s6,8
 768:	000b4583          	lbu	a1,0(s6)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	d98080e7          	jalr	-616(ra) # 506 <putc>
 776:	8b4a                	mv	s6,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	bd65                	j	632 <vprintf+0x60>
        putc(fd, c);
 77c:	85d2                	mv	a1,s4
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d86080e7          	jalr	-634(ra) # 506 <putc>
      state = 0;
 788:	4981                	li	s3,0
 78a:	b565                	j	632 <vprintf+0x60>
        s = va_arg(ap, char*);
 78c:	8b4e                	mv	s6,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	b54d                	j	632 <vprintf+0x60>
    }
  }
}
 792:	70e6                	ld	ra,120(sp)
 794:	7446                	ld	s0,112(sp)
 796:	74a6                	ld	s1,104(sp)
 798:	7906                	ld	s2,96(sp)
 79a:	69e6                	ld	s3,88(sp)
 79c:	6a46                	ld	s4,80(sp)
 79e:	6aa6                	ld	s5,72(sp)
 7a0:	6b06                	ld	s6,64(sp)
 7a2:	7be2                	ld	s7,56(sp)
 7a4:	7c42                	ld	s8,48(sp)
 7a6:	7ca2                	ld	s9,40(sp)
 7a8:	7d02                	ld	s10,32(sp)
 7aa:	6de2                	ld	s11,24(sp)
 7ac:	6109                	addi	sp,sp,128
 7ae:	8082                	ret

00000000000007b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b0:	715d                	addi	sp,sp,-80
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e010                	sd	a2,0(s0)
 7ba:	e414                	sd	a3,8(s0)
 7bc:	e818                	sd	a4,16(s0)
 7be:	ec1c                	sd	a5,24(s0)
 7c0:	03043023          	sd	a6,32(s0)
 7c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7cc:	8622                	mv	a2,s0
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e04080e7          	jalr	-508(ra) # 5d2 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <printf>:

void
printf(const char *fmt, ...)
{
 7de:	711d                	addi	sp,sp,-96
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e40c                	sd	a1,8(s0)
 7e8:	e810                	sd	a2,16(s0)
 7ea:	ec14                	sd	a3,24(s0)
 7ec:	f018                	sd	a4,32(s0)
 7ee:	f41c                	sd	a5,40(s0)
 7f0:	03043823          	sd	a6,48(s0)
 7f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	00840613          	addi	a2,s0,8
 7fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 800:	85aa                	mv	a1,a0
 802:	4505                	li	a0,1
 804:	00000097          	auipc	ra,0x0
 808:	dce080e7          	jalr	-562(ra) # 5d2 <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	1141                	addi	sp,sp,-16
 816:	e422                	sd	s0,8(sp)
 818:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	00000797          	auipc	a5,0x0
 822:	25a7b783          	ld	a5,602(a5) # a78 <freep>
 826:	a805                	j	856 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 828:	4618                	lw	a4,8(a2)
 82a:	9db9                	addw	a1,a1,a4
 82c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	6318                	ld	a4,0(a4)
 834:	fee53823          	sd	a4,-16(a0)
 838:	a091                	j	87c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9e39                	addw	a2,a2,a4
 840:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053703          	ld	a4,-16(a0)
 846:	e398                	sd	a4,0(a5)
 848:	a099                	j	88e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	6398                	ld	a4,0(a5)
 84c:	00e7e463          	bltu	a5,a4,854 <free+0x40>
 850:	00e6ea63          	bltu	a3,a4,864 <free+0x50>
{
 854:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	fed7fae3          	bgeu	a5,a3,84a <free+0x36>
 85a:	6398                	ld	a4,0(a5)
 85c:	00e6e463          	bltu	a3,a4,864 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	fee7eae3          	bltu	a5,a4,854 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 864:	ff852583          	lw	a1,-8(a0)
 868:	6390                	ld	a2,0(a5)
 86a:	02059713          	slli	a4,a1,0x20
 86e:	9301                	srli	a4,a4,0x20
 870:	0712                	slli	a4,a4,0x4
 872:	9736                	add	a4,a4,a3
 874:	fae60ae3          	beq	a2,a4,828 <free+0x14>
    bp->s.ptr = p->s.ptr;
 878:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87c:	4790                	lw	a2,8(a5)
 87e:	02061713          	slli	a4,a2,0x20
 882:	9301                	srli	a4,a4,0x20
 884:	0712                	slli	a4,a4,0x4
 886:	973e                	add	a4,a4,a5
 888:	fae689e3          	beq	a3,a4,83a <free+0x26>
  } else
    p->s.ptr = bp;
 88c:	e394                	sd	a3,0(a5)
  freep = p;
 88e:	00000717          	auipc	a4,0x0
 892:	1ef73523          	sd	a5,490(a4) # a78 <freep>
}
 896:	6422                	ld	s0,8(sp)
 898:	0141                	addi	sp,sp,16
 89a:	8082                	ret

000000000000089c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89c:	7139                	addi	sp,sp,-64
 89e:	fc06                	sd	ra,56(sp)
 8a0:	f822                	sd	s0,48(sp)
 8a2:	f426                	sd	s1,40(sp)
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	e852                	sd	s4,16(sp)
 8aa:	e456                	sd	s5,8(sp)
 8ac:	e05a                	sd	s6,0(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051493          	slli	s1,a0,0x20
 8b4:	9081                	srli	s1,s1,0x20
 8b6:	04bd                	addi	s1,s1,15
 8b8:	8091                	srli	s1,s1,0x4
 8ba:	0014899b          	addiw	s3,s1,1
 8be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c0:	00000517          	auipc	a0,0x0
 8c4:	1b853503          	ld	a0,440(a0) # a78 <freep>
 8c8:	c515                	beqz	a0,8f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	02977f63          	bgeu	a4,s1,90c <malloc+0x70>
 8d2:	8a4e                	mv	s4,s3
 8d4:	0009871b          	sext.w	a4,s3
 8d8:	6685                	lui	a3,0x1
 8da:	00d77363          	bgeu	a4,a3,8e0 <malloc+0x44>
 8de:	6a05                	lui	s4,0x1
 8e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e8:	00000917          	auipc	s2,0x0
 8ec:	19090913          	addi	s2,s2,400 # a78 <freep>
  if(p == (char*)-1)
 8f0:	5afd                	li	s5,-1
 8f2:	a88d                	j	964 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8f4:	00000797          	auipc	a5,0x0
 8f8:	18c78793          	addi	a5,a5,396 # a80 <base>
 8fc:	00000717          	auipc	a4,0x0
 900:	16f73e23          	sd	a5,380(a4) # a78 <freep>
 904:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 906:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90a:	b7e1                	j	8d2 <malloc+0x36>
      if(p->s.size == nunits)
 90c:	02e48b63          	beq	s1,a4,942 <malloc+0xa6>
        p->s.size -= nunits;
 910:	4137073b          	subw	a4,a4,s3
 914:	c798                	sw	a4,8(a5)
        p += p->s.size;
 916:	1702                	slli	a4,a4,0x20
 918:	9301                	srli	a4,a4,0x20
 91a:	0712                	slli	a4,a4,0x4
 91c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 922:	00000717          	auipc	a4,0x0
 926:	14a73b23          	sd	a0,342(a4) # a78 <freep>
      return (void*)(p + 1);
 92a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	74a2                	ld	s1,40(sp)
 934:	7902                	ld	s2,32(sp)
 936:	69e2                	ld	s3,24(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
 93e:	6121                	addi	sp,sp,64
 940:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 942:	6398                	ld	a4,0(a5)
 944:	e118                	sd	a4,0(a0)
 946:	bff1                	j	922 <malloc+0x86>
  hp->s.size = nu;
 948:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94c:	0541                	addi	a0,a0,16
 94e:	00000097          	auipc	ra,0x0
 952:	ec6080e7          	jalr	-314(ra) # 814 <free>
  return freep;
 956:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 95a:	d971                	beqz	a0,92e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	fa9776e3          	bgeu	a4,s1,90c <malloc+0x70>
    if(p == freep)
 964:	00093703          	ld	a4,0(s2)
 968:	853e                	mv	a0,a5
 96a:	fef719e3          	bne	a4,a5,95c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 96e:	8552                	mv	a0,s4
 970:	00000097          	auipc	ra,0x0
 974:	b7e080e7          	jalr	-1154(ra) # 4ee <sbrk>
  if(p == (char*)-1)
 978:	fd5518e3          	bne	a0,s5,948 <malloc+0xac>
        return 0;
 97c:	4501                	li	a0,0
 97e:	bf45                	j	92e <malloc+0x92>
