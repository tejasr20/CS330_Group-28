
user/_forksleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include<stddef.h>


int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48

if(argc!=3)
   e:	478d                	li	a5,3
  10:	02f50063          	beq	a0,a5,30 <main+0x30>
{
	fprintf(2, "usage: forksleep m n\n");
  14:	00001597          	auipc	a1,0x1
  18:	8e458593          	addi	a1,a1,-1820 # 8f8 <malloc+0xea>
  1c:	4509                	li	a0,2
  1e:	00000097          	auipc	ra,0x0
  22:	704080e7          	jalr	1796(ra) # 722 <fprintf>
	exit(1);
  26:	4505                	li	a0,1
  28:	00000097          	auipc	ra,0x0
  2c:	3b0080e7          	jalr	944(ra) # 3d8 <exit>
  30:	84ae                	mv	s1,a1
}

int m,n;
m=atoi(argv[1]);
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	2a4080e7          	jalr	676(ra) # 2d8 <atoi>
  3c:	89aa                	mv	s3,a0
n=atoi(argv[2]);
  3e:	6888                	ld	a0,16(s1)
  40:	00000097          	auipc	ra,0x0
  44:	298080e7          	jalr	664(ra) # 2d8 <atoi>
  48:	892a                	mv	s2,a0
//printf("%d %d\n",m,n);
int pid;
if(n!=0 && n!=1)
  4a:	0005071b          	sext.w	a4,a0
  4e:	4785                	li	a5,1
  50:	04e7e863          	bltu	a5,a4,a0 <main+0xa0>
{
	fprintf(2, "usage: forksleep m n. n must be 0 or 1.\n");
        exit(1);
}

if(argv[1][0]=='-')
  54:	649c                	ld	a5,8(s1)
  56:	0007c703          	lbu	a4,0(a5)
  5a:	02d00793          	li	a5,45
  5e:	04f70f63          	beq	a4,a5,bc <main+0xbc>
	fprintf(2, "usage: forksleep m n. m must be non-negative.\n");
        exit(1);
}


int flag=fork();
  62:	00000097          	auipc	ra,0x0
  66:	36e080e7          	jalr	878(ra) # 3d0 <fork>

if(n==0)
  6a:	08091f63          	bnez	s2,108 <main+0x108>
{
	if(flag==0)
  6e:	e52d                	bnez	a0,d8 <main+0xd8>
	{
		
		sleep(m);
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	3f6080e7          	jalr	1014(ra) # 468 <sleep>
		pid=getpid();
  7a:	00000097          	auipc	ra,0x0
  7e:	3de080e7          	jalr	990(ra) # 458 <getpid>
  82:	862a                	mv	a2,a0
		fprintf(1,"%d: Child\n",pid);
  84:	00001597          	auipc	a1,0x1
  88:	8ec58593          	addi	a1,a1,-1812 # 970 <malloc+0x162>
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	694080e7          	jalr	1684(ra) # 722 <fprintf>
		exit(0);	
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	340080e7          	jalr	832(ra) # 3d8 <exit>
	fprintf(2, "usage: forksleep m n. n must be 0 or 1.\n");
  a0:	00001597          	auipc	a1,0x1
  a4:	87058593          	addi	a1,a1,-1936 # 910 <malloc+0x102>
  a8:	4509                	li	a0,2
  aa:	00000097          	auipc	ra,0x0
  ae:	678080e7          	jalr	1656(ra) # 722 <fprintf>
        exit(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	324080e7          	jalr	804(ra) # 3d8 <exit>
	fprintf(2, "usage: forksleep m n. m must be non-negative.\n");
  bc:	00001597          	auipc	a1,0x1
  c0:	88458593          	addi	a1,a1,-1916 # 940 <malloc+0x132>
  c4:	4509                	li	a0,2
  c6:	00000097          	auipc	ra,0x0
  ca:	65c080e7          	jalr	1628(ra) # 722 <fprintf>
        exit(1);
  ce:	4505                	li	a0,1
  d0:	00000097          	auipc	ra,0x0
  d4:	308080e7          	jalr	776(ra) # 3d8 <exit>
	}
	else
	{
		
		//wait(0);
		pid=getpid();
  d8:	00000097          	auipc	ra,0x0
  dc:	380080e7          	jalr	896(ra) # 458 <getpid>
  e0:	862a                	mv	a2,a0
		fprintf(1,"%d: Parent\n",pid);
  e2:	00001597          	auipc	a1,0x1
  e6:	89e58593          	addi	a1,a1,-1890 # 980 <malloc+0x172>
  ea:	4505                	li	a0,1
  ec:	00000097          	auipc	ra,0x0
  f0:	636080e7          	jalr	1590(ra) # 722 <fprintf>
		wait(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	2ea080e7          	jalr	746(ra) # 3e0 <wait>
		exit(0);
	}	
}


exit(0);
  fe:	4501                	li	a0,0
 100:	00000097          	auipc	ra,0x0
 104:	2d8080e7          	jalr	728(ra) # 3d8 <exit>
	if(flag!=0)
 108:	c915                	beqz	a0,13c <main+0x13c>
		wait(0);
 10a:	4501                	li	a0,0
 10c:	00000097          	auipc	ra,0x0
 110:	2d4080e7          	jalr	724(ra) # 3e0 <wait>
		sleep(m);
 114:	854e                	mv	a0,s3
 116:	00000097          	auipc	ra,0x0
 11a:	352080e7          	jalr	850(ra) # 468 <sleep>
		pid=getpid();
 11e:	00000097          	auipc	ra,0x0
 122:	33a080e7          	jalr	826(ra) # 458 <getpid>
 126:	862a                	mv	a2,a0
		fprintf(1,"%d: Parent\n",pid);
 128:	00001597          	auipc	a1,0x1
 12c:	85858593          	addi	a1,a1,-1960 # 980 <malloc+0x172>
 130:	4505                	li	a0,1
 132:	00000097          	auipc	ra,0x0
 136:	5f0080e7          	jalr	1520(ra) # 722 <fprintf>
 13a:	b7d1                	j	fe <main+0xfe>
		pid=getpid();
 13c:	00000097          	auipc	ra,0x0
 140:	31c080e7          	jalr	796(ra) # 458 <getpid>
 144:	862a                	mv	a2,a0
               fprintf(1,"%d: Child\n",pid);
 146:	00001597          	auipc	a1,0x1
 14a:	82a58593          	addi	a1,a1,-2006 # 970 <malloc+0x162>
 14e:	4505                	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	5d2080e7          	jalr	1490(ra) # 722 <fprintf>
		exit(0);
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	27e080e7          	jalr	638(ra) # 3d8 <exit>

0000000000000162 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 168:	87aa                	mv	a5,a0
 16a:	0585                	addi	a1,a1,1
 16c:	0785                	addi	a5,a5,1
 16e:	fff5c703          	lbu	a4,-1(a1)
 172:	fee78fa3          	sb	a4,-1(a5)
 176:	fb75                	bnez	a4,16a <strcpy+0x8>
    ;
  return os;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb91                	beqz	a5,19c <strcmp+0x1e>
 18a:	0005c703          	lbu	a4,0(a1)
 18e:	00f71763          	bne	a4,a5,19c <strcmp+0x1e>
    p++, q++;
 192:	0505                	addi	a0,a0,1
 194:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbe5                	bnez	a5,18a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19c:	0005c503          	lbu	a0,0(a1)
}
 1a0:	40a7853b          	subw	a0,a5,a0
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf91                	beqz	a5,1d0 <strlen+0x26>
 1b6:	0505                	addi	a0,a0,1
 1b8:	87aa                	mv	a5,a0
 1ba:	4685                	li	a3,1
 1bc:	9e89                	subw	a3,a3,a0
 1be:	00f6853b          	addw	a0,a3,a5
 1c2:	0785                	addi	a5,a5,1
 1c4:	fff7c703          	lbu	a4,-1(a5)
 1c8:	fb7d                	bnez	a4,1be <strlen+0x14>
    ;
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  for(n = 0; s[n]; n++)
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strlen+0x20>

00000000000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1da:	ce09                	beqz	a2,1f4 <memset+0x20>
 1dc:	87aa                	mv	a5,a0
 1de:	fff6071b          	addiw	a4,a2,-1
 1e2:	1702                	slli	a4,a4,0x20
 1e4:	9301                	srli	a4,a4,0x20
 1e6:	0705                	addi	a4,a4,1
 1e8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ee:	0785                	addi	a5,a5,1
 1f0:	fee79de3          	bne	a5,a4,1ea <memset+0x16>
  }
  return dst;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 200:	00054783          	lbu	a5,0(a0)
 204:	cb99                	beqz	a5,21a <strchr+0x20>
    if(*s == c)
 206:	00f58763          	beq	a1,a5,214 <strchr+0x1a>
  for(; *s; s++)
 20a:	0505                	addi	a0,a0,1
 20c:	00054783          	lbu	a5,0(a0)
 210:	fbfd                	bnez	a5,206 <strchr+0xc>
      return (char*)s;
  return 0;
 212:	4501                	li	a0,0
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
  return 0;
 21a:	4501                	li	a0,0
 21c:	bfe5                	j	214 <strchr+0x1a>

000000000000021e <gets>:

char*
gets(char *buf, int max)
{
 21e:	711d                	addi	sp,sp,-96
 220:	ec86                	sd	ra,88(sp)
 222:	e8a2                	sd	s0,80(sp)
 224:	e4a6                	sd	s1,72(sp)
 226:	e0ca                	sd	s2,64(sp)
 228:	fc4e                	sd	s3,56(sp)
 22a:	f852                	sd	s4,48(sp)
 22c:	f456                	sd	s5,40(sp)
 22e:	f05a                	sd	s6,32(sp)
 230:	ec5e                	sd	s7,24(sp)
 232:	1080                	addi	s0,sp,96
 234:	8baa                	mv	s7,a0
 236:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	892a                	mv	s2,a0
 23a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23c:	4aa9                	li	s5,10
 23e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 240:	89a6                	mv	s3,s1
 242:	2485                	addiw	s1,s1,1
 244:	0344d863          	bge	s1,s4,274 <gets+0x56>
    cc = read(0, &c, 1);
 248:	4605                	li	a2,1
 24a:	faf40593          	addi	a1,s0,-81
 24e:	4501                	li	a0,0
 250:	00000097          	auipc	ra,0x0
 254:	1a0080e7          	jalr	416(ra) # 3f0 <read>
    if(cc < 1)
 258:	00a05e63          	blez	a0,274 <gets+0x56>
    buf[i++] = c;
 25c:	faf44783          	lbu	a5,-81(s0)
 260:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 264:	01578763          	beq	a5,s5,272 <gets+0x54>
 268:	0905                	addi	s2,s2,1
 26a:	fd679be3          	bne	a5,s6,240 <gets+0x22>
  for(i=0; i+1 < max; ){
 26e:	89a6                	mv	s3,s1
 270:	a011                	j	274 <gets+0x56>
 272:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 274:	99de                	add	s3,s3,s7
 276:	00098023          	sb	zero,0(s3)
  return buf;
}
 27a:	855e                	mv	a0,s7
 27c:	60e6                	ld	ra,88(sp)
 27e:	6446                	ld	s0,80(sp)
 280:	64a6                	ld	s1,72(sp)
 282:	6906                	ld	s2,64(sp)
 284:	79e2                	ld	s3,56(sp)
 286:	7a42                	ld	s4,48(sp)
 288:	7aa2                	ld	s5,40(sp)
 28a:	7b02                	ld	s6,32(sp)
 28c:	6be2                	ld	s7,24(sp)
 28e:	6125                	addi	sp,sp,96
 290:	8082                	ret

0000000000000292 <stat>:

int
stat(const char *n, struct stat *st)
{
 292:	1101                	addi	sp,sp,-32
 294:	ec06                	sd	ra,24(sp)
 296:	e822                	sd	s0,16(sp)
 298:	e426                	sd	s1,8(sp)
 29a:	e04a                	sd	s2,0(sp)
 29c:	1000                	addi	s0,sp,32
 29e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a0:	4581                	li	a1,0
 2a2:	00000097          	auipc	ra,0x0
 2a6:	176080e7          	jalr	374(ra) # 418 <open>
  if(fd < 0)
 2aa:	02054563          	bltz	a0,2d4 <stat+0x42>
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	00000097          	auipc	ra,0x0
 2b6:	17e080e7          	jalr	382(ra) # 430 <fstat>
 2ba:	892a                	mv	s2,a0
  close(fd);
 2bc:	8526                	mv	a0,s1
 2be:	00000097          	auipc	ra,0x0
 2c2:	142080e7          	jalr	322(ra) # 400 <close>
  return r;
}
 2c6:	854a                	mv	a0,s2
 2c8:	60e2                	ld	ra,24(sp)
 2ca:	6442                	ld	s0,16(sp)
 2cc:	64a2                	ld	s1,8(sp)
 2ce:	6902                	ld	s2,0(sp)
 2d0:	6105                	addi	sp,sp,32
 2d2:	8082                	ret
    return -1;
 2d4:	597d                	li	s2,-1
 2d6:	bfc5                	j	2c6 <stat+0x34>

00000000000002d8 <atoi>:

int
atoi(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2de:	00054603          	lbu	a2,0(a0)
 2e2:	fd06079b          	addiw	a5,a2,-48
 2e6:	0ff7f793          	andi	a5,a5,255
 2ea:	4725                	li	a4,9
 2ec:	02f76963          	bltu	a4,a5,31e <atoi+0x46>
 2f0:	86aa                	mv	a3,a0
  n = 0;
 2f2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f6:	0685                	addi	a3,a3,1
 2f8:	0025179b          	slliw	a5,a0,0x2
 2fc:	9fa9                	addw	a5,a5,a0
 2fe:	0017979b          	slliw	a5,a5,0x1
 302:	9fb1                	addw	a5,a5,a2
 304:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 308:	0006c603          	lbu	a2,0(a3)
 30c:	fd06071b          	addiw	a4,a2,-48
 310:	0ff77713          	andi	a4,a4,255
 314:	fee5f1e3          	bgeu	a1,a4,2f6 <atoi+0x1e>
  return n;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  n = 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <atoi+0x40>

0000000000000322 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57663          	bgeu	a0,a1,354 <memmove+0x32>
    while(n-- > 0)
 32c:	02c05163          	blez	a2,34e <memmove+0x2c>
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	0785                	addi	a5,a5,1
 33a:	97aa                	add	a5,a5,a0
  dst = vdst;
 33c:	872a                	mv	a4,a0
      *dst++ = *src++;
 33e:	0585                	addi	a1,a1,1
 340:	0705                	addi	a4,a4,1
 342:	fff5c683          	lbu	a3,-1(a1)
 346:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34a:	fee79ae3          	bne	a5,a4,33e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
    dst += n;
 354:	00c50733          	add	a4,a0,a2
    src += n;
 358:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35a:	fec05ae3          	blez	a2,34e <memmove+0x2c>
 35e:	fff6079b          	addiw	a5,a2,-1
 362:	1782                	slli	a5,a5,0x20
 364:	9381                	srli	a5,a5,0x20
 366:	fff7c793          	not	a5,a5
 36a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36c:	15fd                	addi	a1,a1,-1
 36e:	177d                	addi	a4,a4,-1
 370:	0005c683          	lbu	a3,0(a1)
 374:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 378:	fee79ae3          	bne	a5,a4,36c <memmove+0x4a>
 37c:	bfc9                	j	34e <memmove+0x2c>

000000000000037e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 384:	ca05                	beqz	a2,3b4 <memcmp+0x36>
 386:	fff6069b          	addiw	a3,a2,-1
 38a:	1682                	slli	a3,a3,0x20
 38c:	9281                	srli	a3,a3,0x20
 38e:	0685                	addi	a3,a3,1
 390:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 392:	00054783          	lbu	a5,0(a0)
 396:	0005c703          	lbu	a4,0(a1)
 39a:	00e79863          	bne	a5,a4,3aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39e:	0505                	addi	a0,a0,1
    p2++;
 3a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a2:	fed518e3          	bne	a0,a3,392 <memcmp+0x14>
  }
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	a019                	j	3ae <memcmp+0x30>
      return *p1 - *p2;
 3aa:	40e7853b          	subw	a0,a5,a4
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <memcmp+0x30>

00000000000003b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c0:	00000097          	auipc	ra,0x0
 3c4:	f62080e7          	jalr	-158(ra) # 322 <memmove>
}
 3c8:	60a2                	ld	ra,8(sp)
 3ca:	6402                	ld	s0,0(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret

00000000000003d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d0:	4885                	li	a7,1
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d8:	4889                	li	a7,2
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e0:	488d                	li	a7,3
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e8:	4891                	li	a7,4
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <read>:
.global read
read:
 li a7, SYS_read
 3f0:	4895                	li	a7,5
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <write>:
.global write
write:
 li a7, SYS_write
 3f8:	48c1                	li	a7,16
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <close>:
.global close
close:
 li a7, SYS_close
 400:	48d5                	li	a7,21
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <kill>:
.global kill
kill:
 li a7, SYS_kill
 408:	4899                	li	a7,6
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exec>:
.global exec
exec:
 li a7, SYS_exec
 410:	489d                	li	a7,7
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <open>:
.global open
open:
 li a7, SYS_open
 418:	48bd                	li	a7,15
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 420:	48c5                	li	a7,17
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 428:	48c9                	li	a7,18
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 430:	48a1                	li	a7,8
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <link>:
.global link
link:
 li a7, SYS_link
 438:	48cd                	li	a7,19
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 440:	48d1                	li	a7,20
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 448:	48a5                	li	a7,9
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <dup>:
.global dup
dup:
 li a7, SYS_dup
 450:	48a9                	li	a7,10
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 458:	48ad                	li	a7,11
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 460:	48b1                	li	a7,12
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 468:	48b5                	li	a7,13
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 470:	48b9                	li	a7,14
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 478:	1101                	addi	sp,sp,-32
 47a:	ec06                	sd	ra,24(sp)
 47c:	e822                	sd	s0,16(sp)
 47e:	1000                	addi	s0,sp,32
 480:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 484:	4605                	li	a2,1
 486:	fef40593          	addi	a1,s0,-17
 48a:	00000097          	auipc	ra,0x0
 48e:	f6e080e7          	jalr	-146(ra) # 3f8 <write>
}
 492:	60e2                	ld	ra,24(sp)
 494:	6442                	ld	s0,16(sp)
 496:	6105                	addi	sp,sp,32
 498:	8082                	ret

000000000000049a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49a:	7139                	addi	sp,sp,-64
 49c:	fc06                	sd	ra,56(sp)
 49e:	f822                	sd	s0,48(sp)
 4a0:	f426                	sd	s1,40(sp)
 4a2:	f04a                	sd	s2,32(sp)
 4a4:	ec4e                	sd	s3,24(sp)
 4a6:	0080                	addi	s0,sp,64
 4a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4aa:	c299                	beqz	a3,4b0 <printint+0x16>
 4ac:	0805c863          	bltz	a1,53c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b0:	2581                	sext.w	a1,a1
  neg = 0;
 4b2:	4881                	li	a7,0
 4b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ba:	2601                	sext.w	a2,a2
 4bc:	00000517          	auipc	a0,0x0
 4c0:	4dc50513          	addi	a0,a0,1244 # 998 <digits>
 4c4:	883a                	mv	a6,a4
 4c6:	2705                	addiw	a4,a4,1
 4c8:	02c5f7bb          	remuw	a5,a1,a2
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	97aa                	add	a5,a5,a0
 4d2:	0007c783          	lbu	a5,0(a5)
 4d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4da:	0005879b          	sext.w	a5,a1
 4de:	02c5d5bb          	divuw	a1,a1,a2
 4e2:	0685                	addi	a3,a3,1
 4e4:	fec7f0e3          	bgeu	a5,a2,4c4 <printint+0x2a>
  if(neg)
 4e8:	00088b63          	beqz	a7,4fe <printint+0x64>
    buf[i++] = '-';
 4ec:	fd040793          	addi	a5,s0,-48
 4f0:	973e                	add	a4,a4,a5
 4f2:	02d00793          	li	a5,45
 4f6:	fef70823          	sb	a5,-16(a4)
 4fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4fe:	02e05863          	blez	a4,52e <printint+0x94>
 502:	fc040793          	addi	a5,s0,-64
 506:	00e78933          	add	s2,a5,a4
 50a:	fff78993          	addi	s3,a5,-1
 50e:	99ba                	add	s3,s3,a4
 510:	377d                	addiw	a4,a4,-1
 512:	1702                	slli	a4,a4,0x20
 514:	9301                	srli	a4,a4,0x20
 516:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 51a:	fff94583          	lbu	a1,-1(s2)
 51e:	8526                	mv	a0,s1
 520:	00000097          	auipc	ra,0x0
 524:	f58080e7          	jalr	-168(ra) # 478 <putc>
  while(--i >= 0)
 528:	197d                	addi	s2,s2,-1
 52a:	ff3918e3          	bne	s2,s3,51a <printint+0x80>
}
 52e:	70e2                	ld	ra,56(sp)
 530:	7442                	ld	s0,48(sp)
 532:	74a2                	ld	s1,40(sp)
 534:	7902                	ld	s2,32(sp)
 536:	69e2                	ld	s3,24(sp)
 538:	6121                	addi	sp,sp,64
 53a:	8082                	ret
    x = -xx;
 53c:	40b005bb          	negw	a1,a1
    neg = 1;
 540:	4885                	li	a7,1
    x = -xx;
 542:	bf8d                	j	4b4 <printint+0x1a>

0000000000000544 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 544:	7119                	addi	sp,sp,-128
 546:	fc86                	sd	ra,120(sp)
 548:	f8a2                	sd	s0,112(sp)
 54a:	f4a6                	sd	s1,104(sp)
 54c:	f0ca                	sd	s2,96(sp)
 54e:	ecce                	sd	s3,88(sp)
 550:	e8d2                	sd	s4,80(sp)
 552:	e4d6                	sd	s5,72(sp)
 554:	e0da                	sd	s6,64(sp)
 556:	fc5e                	sd	s7,56(sp)
 558:	f862                	sd	s8,48(sp)
 55a:	f466                	sd	s9,40(sp)
 55c:	f06a                	sd	s10,32(sp)
 55e:	ec6e                	sd	s11,24(sp)
 560:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 562:	0005c903          	lbu	s2,0(a1)
 566:	18090f63          	beqz	s2,704 <vprintf+0x1c0>
 56a:	8aaa                	mv	s5,a0
 56c:	8b32                	mv	s6,a2
 56e:	00158493          	addi	s1,a1,1
  state = 0;
 572:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 574:	02500a13          	li	s4,37
      if(c == 'd'){
 578:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 57c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 580:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 584:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 588:	00000b97          	auipc	s7,0x0
 58c:	410b8b93          	addi	s7,s7,1040 # 998 <digits>
 590:	a839                	j	5ae <vprintf+0x6a>
        putc(fd, c);
 592:	85ca                	mv	a1,s2
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	ee2080e7          	jalr	-286(ra) # 478 <putc>
 59e:	a019                	j	5a4 <vprintf+0x60>
    } else if(state == '%'){
 5a0:	01498f63          	beq	s3,s4,5be <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5a4:	0485                	addi	s1,s1,1
 5a6:	fff4c903          	lbu	s2,-1(s1)
 5aa:	14090d63          	beqz	s2,704 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5ae:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b2:	fe0997e3          	bnez	s3,5a0 <vprintf+0x5c>
      if(c == '%'){
 5b6:	fd479ee3          	bne	a5,s4,592 <vprintf+0x4e>
        state = '%';
 5ba:	89be                	mv	s3,a5
 5bc:	b7e5                	j	5a4 <vprintf+0x60>
      if(c == 'd'){
 5be:	05878063          	beq	a5,s8,5fe <vprintf+0xba>
      } else if(c == 'l') {
 5c2:	05978c63          	beq	a5,s9,61a <vprintf+0xd6>
      } else if(c == 'x') {
 5c6:	07a78863          	beq	a5,s10,636 <vprintf+0xf2>
      } else if(c == 'p') {
 5ca:	09b78463          	beq	a5,s11,652 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5ce:	07300713          	li	a4,115
 5d2:	0ce78663          	beq	a5,a4,69e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d6:	06300713          	li	a4,99
 5da:	0ee78e63          	beq	a5,a4,6d6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5de:	11478863          	beq	a5,s4,6ee <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e2:	85d2                	mv	a1,s4
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e92080e7          	jalr	-366(ra) # 478 <putc>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e86080e7          	jalr	-378(ra) # 478 <putc>
      }
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b765                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5fe:	008b0913          	addi	s2,s6,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000b2583          	lw	a1,0(s6)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e8e080e7          	jalr	-370(ra) # 49a <printint>
 614:	8b4a                	mv	s6,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b771                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b0913          	addi	s2,s6,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000b2583          	lw	a1,0(s6)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e72080e7          	jalr	-398(ra) # 49a <printint>
 630:	8b4a                	mv	s6,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	bf85                	j	5a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 636:	008b0913          	addi	s2,s6,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000b2583          	lw	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e56080e7          	jalr	-426(ra) # 49a <printint>
 64c:	8b4a                	mv	s6,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bf91                	j	5a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 652:	008b0793          	addi	a5,s6,8
 656:	f8f43423          	sd	a5,-120(s0)
 65a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 65e:	03000593          	li	a1,48
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e14080e7          	jalr	-492(ra) # 478 <putc>
  putc(fd, 'x');
 66c:	85ea                	mv	a1,s10
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e08080e7          	jalr	-504(ra) # 478 <putc>
 678:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	df2080e7          	jalr	-526(ra) # 478 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68e:	0992                	slli	s3,s3,0x4
 690:	397d                	addiw	s2,s2,-1
 692:	fe0914e3          	bnez	s2,67a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 696:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b721                	j	5a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 69e:	008b0993          	addi	s3,s6,8
 6a2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a6:	02090163          	beqz	s2,6c8 <vprintf+0x184>
        while(*s != 0){
 6aa:	00094583          	lbu	a1,0(s2)
 6ae:	c9a1                	beqz	a1,6fe <vprintf+0x1ba>
          putc(fd, *s);
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dc6080e7          	jalr	-570(ra) # 478 <putc>
          s++;
 6ba:	0905                	addi	s2,s2,1
        while(*s != 0){
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	f9e5                	bnez	a1,6b0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6c2:	8b4e                	mv	s6,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bdf9                	j	5a4 <vprintf+0x60>
          s = "(null)";
 6c8:	00000917          	auipc	s2,0x0
 6cc:	2c890913          	addi	s2,s2,712 # 990 <malloc+0x182>
        while(*s != 0){
 6d0:	02800593          	li	a1,40
 6d4:	bff1                	j	6b0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d6:	008b0913          	addi	s2,s6,8
 6da:	000b4583          	lbu	a1,0(s6)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	d98080e7          	jalr	-616(ra) # 478 <putc>
 6e8:	8b4a                	mv	s6,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bd65                	j	5a4 <vprintf+0x60>
        putc(fd, c);
 6ee:	85d2                	mv	a1,s4
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	d86080e7          	jalr	-634(ra) # 478 <putc>
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b565                	j	5a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fe:	8b4e                	mv	s6,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	b54d                	j	5a4 <vprintf+0x60>
    }
  }
}
 704:	70e6                	ld	ra,120(sp)
 706:	7446                	ld	s0,112(sp)
 708:	74a6                	ld	s1,104(sp)
 70a:	7906                	ld	s2,96(sp)
 70c:	69e6                	ld	s3,88(sp)
 70e:	6a46                	ld	s4,80(sp)
 710:	6aa6                	ld	s5,72(sp)
 712:	6b06                	ld	s6,64(sp)
 714:	7be2                	ld	s7,56(sp)
 716:	7c42                	ld	s8,48(sp)
 718:	7ca2                	ld	s9,40(sp)
 71a:	7d02                	ld	s10,32(sp)
 71c:	6de2                	ld	s11,24(sp)
 71e:	6109                	addi	sp,sp,128
 720:	8082                	ret

0000000000000722 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 722:	715d                	addi	sp,sp,-80
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e010                	sd	a2,0(s0)
 72c:	e414                	sd	a3,8(s0)
 72e:	e818                	sd	a4,16(s0)
 730:	ec1c                	sd	a5,24(s0)
 732:	03043023          	sd	a6,32(s0)
 736:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73e:	8622                	mv	a2,s0
 740:	00000097          	auipc	ra,0x0
 744:	e04080e7          	jalr	-508(ra) # 544 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	00000097          	auipc	ra,0x0
 77a:	dce080e7          	jalr	-562(ra) # 544 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret

0000000000000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	1141                	addi	sp,sp,-16
 788:	e422                	sd	s0,8(sp)
 78a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	00000797          	auipc	a5,0x0
 794:	2207b783          	ld	a5,544(a5) # 9b0 <freep>
 798:	a805                	j	7c8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79a:	4618                	lw	a4,8(a2)
 79c:	9db9                	addw	a1,a1,a4
 79e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	6398                	ld	a4,0(a5)
 7a4:	6318                	ld	a4,0(a4)
 7a6:	fee53823          	sd	a4,-16(a0)
 7aa:	a091                	j	7ee <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ac:	ff852703          	lw	a4,-8(a0)
 7b0:	9e39                	addw	a2,a2,a4
 7b2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b4:	ff053703          	ld	a4,-16(a0)
 7b8:	e398                	sd	a4,0(a5)
 7ba:	a099                	j	800 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bc:	6398                	ld	a4,0(a5)
 7be:	00e7e463          	bltu	a5,a4,7c6 <free+0x40>
 7c2:	00e6ea63          	bltu	a3,a4,7d6 <free+0x50>
{
 7c6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c8:	fed7fae3          	bgeu	a5,a3,7bc <free+0x36>
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e6e463          	bltu	a3,a4,7d6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	fee7eae3          	bltu	a5,a4,7c6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d6:	ff852583          	lw	a1,-8(a0)
 7da:	6390                	ld	a2,0(a5)
 7dc:	02059713          	slli	a4,a1,0x20
 7e0:	9301                	srli	a4,a4,0x20
 7e2:	0712                	slli	a4,a4,0x4
 7e4:	9736                	add	a4,a4,a3
 7e6:	fae60ae3          	beq	a2,a4,79a <free+0x14>
    bp->s.ptr = p->s.ptr;
 7ea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ee:	4790                	lw	a2,8(a5)
 7f0:	02061713          	slli	a4,a2,0x20
 7f4:	9301                	srli	a4,a4,0x20
 7f6:	0712                	slli	a4,a4,0x4
 7f8:	973e                	add	a4,a4,a5
 7fa:	fae689e3          	beq	a3,a4,7ac <free+0x26>
  } else
    p->s.ptr = bp;
 7fe:	e394                	sd	a3,0(a5)
  freep = p;
 800:	00000717          	auipc	a4,0x0
 804:	1af73823          	sd	a5,432(a4) # 9b0 <freep>
}
 808:	6422                	ld	s0,8(sp)
 80a:	0141                	addi	sp,sp,16
 80c:	8082                	ret

000000000000080e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80e:	7139                	addi	sp,sp,-64
 810:	fc06                	sd	ra,56(sp)
 812:	f822                	sd	s0,48(sp)
 814:	f426                	sd	s1,40(sp)
 816:	f04a                	sd	s2,32(sp)
 818:	ec4e                	sd	s3,24(sp)
 81a:	e852                	sd	s4,16(sp)
 81c:	e456                	sd	s5,8(sp)
 81e:	e05a                	sd	s6,0(sp)
 820:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	02051493          	slli	s1,a0,0x20
 826:	9081                	srli	s1,s1,0x20
 828:	04bd                	addi	s1,s1,15
 82a:	8091                	srli	s1,s1,0x4
 82c:	0014899b          	addiw	s3,s1,1
 830:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 832:	00000517          	auipc	a0,0x0
 836:	17e53503          	ld	a0,382(a0) # 9b0 <freep>
 83a:	c515                	beqz	a0,866 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83e:	4798                	lw	a4,8(a5)
 840:	02977f63          	bgeu	a4,s1,87e <malloc+0x70>
 844:	8a4e                	mv	s4,s3
 846:	0009871b          	sext.w	a4,s3
 84a:	6685                	lui	a3,0x1
 84c:	00d77363          	bgeu	a4,a3,852 <malloc+0x44>
 850:	6a05                	lui	s4,0x1
 852:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 856:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85a:	00000917          	auipc	s2,0x0
 85e:	15690913          	addi	s2,s2,342 # 9b0 <freep>
  if(p == (char*)-1)
 862:	5afd                	li	s5,-1
 864:	a88d                	j	8d6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 866:	00000797          	auipc	a5,0x0
 86a:	15278793          	addi	a5,a5,338 # 9b8 <base>
 86e:	00000717          	auipc	a4,0x0
 872:	14f73123          	sd	a5,322(a4) # 9b0 <freep>
 876:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 878:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87c:	b7e1                	j	844 <malloc+0x36>
      if(p->s.size == nunits)
 87e:	02e48b63          	beq	s1,a4,8b4 <malloc+0xa6>
        p->s.size -= nunits;
 882:	4137073b          	subw	a4,a4,s3
 886:	c798                	sw	a4,8(a5)
        p += p->s.size;
 888:	1702                	slli	a4,a4,0x20
 88a:	9301                	srli	a4,a4,0x20
 88c:	0712                	slli	a4,a4,0x4
 88e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 890:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 894:	00000717          	auipc	a4,0x0
 898:	10a73e23          	sd	a0,284(a4) # 9b0 <freep>
      return (void*)(p + 1);
 89c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a0:	70e2                	ld	ra,56(sp)
 8a2:	7442                	ld	s0,48(sp)
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	7902                	ld	s2,32(sp)
 8a8:	69e2                	ld	s3,24(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
 8b0:	6121                	addi	sp,sp,64
 8b2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	e118                	sd	a4,0(a0)
 8b8:	bff1                	j	894 <malloc+0x86>
  hp->s.size = nu;
 8ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8be:	0541                	addi	a0,a0,16
 8c0:	00000097          	auipc	ra,0x0
 8c4:	ec6080e7          	jalr	-314(ra) # 786 <free>
  return freep;
 8c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8cc:	d971                	beqz	a0,8a0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	fa9776e3          	bgeu	a4,s1,87e <malloc+0x70>
    if(p == freep)
 8d6:	00093703          	ld	a4,0(s2)
 8da:	853e                	mv	a0,a5
 8dc:	fef719e3          	bne	a4,a5,8ce <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8e0:	8552                	mv	a0,s4
 8e2:	00000097          	auipc	ra,0x0
 8e6:	b7e080e7          	jalr	-1154(ra) # 460 <sbrk>
  if(p == (char*)-1)
 8ea:	fd5518e3          	bne	a0,s5,8ba <malloc+0xac>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	bf45                	j	8a0 <malloc+0x92>
