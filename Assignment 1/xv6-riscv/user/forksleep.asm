
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
  18:	8f458593          	addi	a1,a1,-1804 # 908 <malloc+0xea>
  1c:	4509                	li	a0,2
  1e:	00000097          	auipc	ra,0x0
  22:	714080e7          	jalr	1812(ra) # 732 <fprintf>
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
  88:	8fc58593          	addi	a1,a1,-1796 # 980 <malloc+0x162>
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	6a4080e7          	jalr	1700(ra) # 732 <fprintf>
		exit(0);	
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	340080e7          	jalr	832(ra) # 3d8 <exit>
	fprintf(2, "usage: forksleep m n. n must be 0 or 1.\n");
  a0:	00001597          	auipc	a1,0x1
  a4:	88058593          	addi	a1,a1,-1920 # 920 <malloc+0x102>
  a8:	4509                	li	a0,2
  aa:	00000097          	auipc	ra,0x0
  ae:	688080e7          	jalr	1672(ra) # 732 <fprintf>
        exit(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	324080e7          	jalr	804(ra) # 3d8 <exit>
	fprintf(2, "usage: forksleep m n. m must be non-negative.\n");
  bc:	00001597          	auipc	a1,0x1
  c0:	89458593          	addi	a1,a1,-1900 # 950 <malloc+0x132>
  c4:	4509                	li	a0,2
  c6:	00000097          	auipc	ra,0x0
  ca:	66c080e7          	jalr	1644(ra) # 732 <fprintf>
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
  e6:	8ae58593          	addi	a1,a1,-1874 # 990 <malloc+0x172>
  ea:	4505                	li	a0,1
  ec:	00000097          	auipc	ra,0x0
  f0:	646080e7          	jalr	1606(ra) # 732 <fprintf>
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
 12c:	86858593          	addi	a1,a1,-1944 # 990 <malloc+0x172>
 130:	4505                	li	a0,1
 132:	00000097          	auipc	ra,0x0
 136:	600080e7          	jalr	1536(ra) # 732 <fprintf>
 13a:	b7d1                	j	fe <main+0xfe>
		pid=getpid();
 13c:	00000097          	auipc	ra,0x0
 140:	31c080e7          	jalr	796(ra) # 458 <getpid>
 144:	862a                	mv	a2,a0
               fprintf(1,"%d: Child\n",pid);
 146:	00001597          	auipc	a1,0x1
 14a:	83a58593          	addi	a1,a1,-1990 # 980 <malloc+0x162>
 14e:	4505                	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	5e2080e7          	jalr	1506(ra) # 732 <fprintf>
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

0000000000000478 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 478:	48d9                	li	a7,22
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <yield>:
.global yield
yield:
 li a7, SYS_yield
 480:	48dd                	li	a7,23
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 488:	1101                	addi	sp,sp,-32
 48a:	ec06                	sd	ra,24(sp)
 48c:	e822                	sd	s0,16(sp)
 48e:	1000                	addi	s0,sp,32
 490:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 494:	4605                	li	a2,1
 496:	fef40593          	addi	a1,s0,-17
 49a:	00000097          	auipc	ra,0x0
 49e:	f5e080e7          	jalr	-162(ra) # 3f8 <write>
}
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6105                	addi	sp,sp,32
 4a8:	8082                	ret

00000000000004aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4aa:	7139                	addi	sp,sp,-64
 4ac:	fc06                	sd	ra,56(sp)
 4ae:	f822                	sd	s0,48(sp)
 4b0:	f426                	sd	s1,40(sp)
 4b2:	f04a                	sd	s2,32(sp)
 4b4:	ec4e                	sd	s3,24(sp)
 4b6:	0080                	addi	s0,sp,64
 4b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ba:	c299                	beqz	a3,4c0 <printint+0x16>
 4bc:	0805c863          	bltz	a1,54c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c0:	2581                	sext.w	a1,a1
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	2601                	sext.w	a2,a2
 4cc:	00000517          	auipc	a0,0x0
 4d0:	4dc50513          	addi	a0,a0,1244 # 9a8 <digits>
 4d4:	883a                	mv	a6,a4
 4d6:	2705                	addiw	a4,a4,1
 4d8:	02c5f7bb          	remuw	a5,a1,a2
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	97aa                	add	a5,a5,a0
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	0005879b          	sext.w	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	addi	a3,a3,1
 4f4:	fec7f0e3          	bgeu	a5,a2,4d4 <printint+0x2a>
  if(neg)
 4f8:	00088b63          	beqz	a7,50e <printint+0x64>
    buf[i++] = '-';
 4fc:	fd040793          	addi	a5,s0,-48
 500:	973e                	add	a4,a4,a5
 502:	02d00793          	li	a5,45
 506:	fef70823          	sb	a5,-16(a4)
 50a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 50e:	02e05863          	blez	a4,53e <printint+0x94>
 512:	fc040793          	addi	a5,s0,-64
 516:	00e78933          	add	s2,a5,a4
 51a:	fff78993          	addi	s3,a5,-1
 51e:	99ba                	add	s3,s3,a4
 520:	377d                	addiw	a4,a4,-1
 522:	1702                	slli	a4,a4,0x20
 524:	9301                	srli	a4,a4,0x20
 526:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52a:	fff94583          	lbu	a1,-1(s2)
 52e:	8526                	mv	a0,s1
 530:	00000097          	auipc	ra,0x0
 534:	f58080e7          	jalr	-168(ra) # 488 <putc>
  while(--i >= 0)
 538:	197d                	addi	s2,s2,-1
 53a:	ff3918e3          	bne	s2,s3,52a <printint+0x80>
}
 53e:	70e2                	ld	ra,56(sp)
 540:	7442                	ld	s0,48(sp)
 542:	74a2                	ld	s1,40(sp)
 544:	7902                	ld	s2,32(sp)
 546:	69e2                	ld	s3,24(sp)
 548:	6121                	addi	sp,sp,64
 54a:	8082                	ret
    x = -xx;
 54c:	40b005bb          	negw	a1,a1
    neg = 1;
 550:	4885                	li	a7,1
    x = -xx;
 552:	bf8d                	j	4c4 <printint+0x1a>

0000000000000554 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 554:	7119                	addi	sp,sp,-128
 556:	fc86                	sd	ra,120(sp)
 558:	f8a2                	sd	s0,112(sp)
 55a:	f4a6                	sd	s1,104(sp)
 55c:	f0ca                	sd	s2,96(sp)
 55e:	ecce                	sd	s3,88(sp)
 560:	e8d2                	sd	s4,80(sp)
 562:	e4d6                	sd	s5,72(sp)
 564:	e0da                	sd	s6,64(sp)
 566:	fc5e                	sd	s7,56(sp)
 568:	f862                	sd	s8,48(sp)
 56a:	f466                	sd	s9,40(sp)
 56c:	f06a                	sd	s10,32(sp)
 56e:	ec6e                	sd	s11,24(sp)
 570:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 572:	0005c903          	lbu	s2,0(a1)
 576:	18090f63          	beqz	s2,714 <vprintf+0x1c0>
 57a:	8aaa                	mv	s5,a0
 57c:	8b32                	mv	s6,a2
 57e:	00158493          	addi	s1,a1,1
  state = 0;
 582:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 584:	02500a13          	li	s4,37
      if(c == 'd'){
 588:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 58c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 590:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 594:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	00000b97          	auipc	s7,0x0
 59c:	410b8b93          	addi	s7,s7,1040 # 9a8 <digits>
 5a0:	a839                	j	5be <vprintf+0x6a>
        putc(fd, c);
 5a2:	85ca                	mv	a1,s2
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	ee2080e7          	jalr	-286(ra) # 488 <putc>
 5ae:	a019                	j	5b4 <vprintf+0x60>
    } else if(state == '%'){
 5b0:	01498f63          	beq	s3,s4,5ce <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b4:	0485                	addi	s1,s1,1
 5b6:	fff4c903          	lbu	s2,-1(s1)
 5ba:	14090d63          	beqz	s2,714 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5be:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c2:	fe0997e3          	bnez	s3,5b0 <vprintf+0x5c>
      if(c == '%'){
 5c6:	fd479ee3          	bne	a5,s4,5a2 <vprintf+0x4e>
        state = '%';
 5ca:	89be                	mv	s3,a5
 5cc:	b7e5                	j	5b4 <vprintf+0x60>
      if(c == 'd'){
 5ce:	05878063          	beq	a5,s8,60e <vprintf+0xba>
      } else if(c == 'l') {
 5d2:	05978c63          	beq	a5,s9,62a <vprintf+0xd6>
      } else if(c == 'x') {
 5d6:	07a78863          	beq	a5,s10,646 <vprintf+0xf2>
      } else if(c == 'p') {
 5da:	09b78463          	beq	a5,s11,662 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5de:	07300713          	li	a4,115
 5e2:	0ce78663          	beq	a5,a4,6ae <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e6:	06300713          	li	a4,99
 5ea:	0ee78e63          	beq	a5,a4,6e6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ee:	11478863          	beq	a5,s4,6fe <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f2:	85d2                	mv	a1,s4
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e92080e7          	jalr	-366(ra) # 488 <putc>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e86080e7          	jalr	-378(ra) # 488 <putc>
      }
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b765                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 60e:	008b0913          	addi	s2,s6,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000b2583          	lw	a1,0(s6)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e8e080e7          	jalr	-370(ra) # 4aa <printint>
 624:	8b4a                	mv	s6,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	b771                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b0913          	addi	s2,s6,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000b2583          	lw	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e72080e7          	jalr	-398(ra) # 4aa <printint>
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bf85                	j	5b4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 646:	008b0913          	addi	s2,s6,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000b2583          	lw	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e56080e7          	jalr	-426(ra) # 4aa <printint>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf91                	j	5b4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 662:	008b0793          	addi	a5,s6,8
 666:	f8f43423          	sd	a5,-120(s0)
 66a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 66e:	03000593          	li	a1,48
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e14080e7          	jalr	-492(ra) # 488 <putc>
  putc(fd, 'x');
 67c:	85ea                	mv	a1,s10
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e08080e7          	jalr	-504(ra) # 488 <putc>
 688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	03c9d793          	srli	a5,s3,0x3c
 68e:	97de                	add	a5,a5,s7
 690:	0007c583          	lbu	a1,0(a5)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	df2080e7          	jalr	-526(ra) # 488 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69e:	0992                	slli	s3,s3,0x4
 6a0:	397d                	addiw	s2,s2,-1
 6a2:	fe0914e3          	bnez	s2,68a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b721                	j	5b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ae:	008b0993          	addi	s3,s6,8
 6b2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b6:	02090163          	beqz	s2,6d8 <vprintf+0x184>
        while(*s != 0){
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	c9a1                	beqz	a1,70e <vprintf+0x1ba>
          putc(fd, *s);
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dc6080e7          	jalr	-570(ra) # 488 <putc>
          s++;
 6ca:	0905                	addi	s2,s2,1
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	f9e5                	bnez	a1,6c0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d2:	8b4e                	mv	s6,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bdf9                	j	5b4 <vprintf+0x60>
          s = "(null)";
 6d8:	00000917          	auipc	s2,0x0
 6dc:	2c890913          	addi	s2,s2,712 # 9a0 <malloc+0x182>
        while(*s != 0){
 6e0:	02800593          	li	a1,40
 6e4:	bff1                	j	6c0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	000b4583          	lbu	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	d98080e7          	jalr	-616(ra) # 488 <putc>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bd65                	j	5b4 <vprintf+0x60>
        putc(fd, c);
 6fe:	85d2                	mv	a1,s4
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	d86080e7          	jalr	-634(ra) # 488 <putc>
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b565                	j	5b4 <vprintf+0x60>
        s = va_arg(ap, char*);
 70e:	8b4e                	mv	s6,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	b54d                	j	5b4 <vprintf+0x60>
    }
  }
}
 714:	70e6                	ld	ra,120(sp)
 716:	7446                	ld	s0,112(sp)
 718:	74a6                	ld	s1,104(sp)
 71a:	7906                	ld	s2,96(sp)
 71c:	69e6                	ld	s3,88(sp)
 71e:	6a46                	ld	s4,80(sp)
 720:	6aa6                	ld	s5,72(sp)
 722:	6b06                	ld	s6,64(sp)
 724:	7be2                	ld	s7,56(sp)
 726:	7c42                	ld	s8,48(sp)
 728:	7ca2                	ld	s9,40(sp)
 72a:	7d02                	ld	s10,32(sp)
 72c:	6de2                	ld	s11,24(sp)
 72e:	6109                	addi	sp,sp,128
 730:	8082                	ret

0000000000000732 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 732:	715d                	addi	sp,sp,-80
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e010                	sd	a2,0(s0)
 73c:	e414                	sd	a3,8(s0)
 73e:	e818                	sd	a4,16(s0)
 740:	ec1c                	sd	a5,24(s0)
 742:	03043023          	sd	a6,32(s0)
 746:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74e:	8622                	mv	a2,s0
 750:	00000097          	auipc	ra,0x0
 754:	e04080e7          	jalr	-508(ra) # 554 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6161                	addi	sp,sp,80
 75e:	8082                	ret

0000000000000760 <printf>:

void
printf(const char *fmt, ...)
{
 760:	711d                	addi	sp,sp,-96
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	00840613          	addi	a2,s0,8
 77e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 782:	85aa                	mv	a1,a0
 784:	4505                	li	a0,1
 786:	00000097          	auipc	ra,0x0
 78a:	dce080e7          	jalr	-562(ra) # 554 <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00000797          	auipc	a5,0x0
 7a4:	2207b783          	ld	a5,544(a5) # 9c0 <freep>
 7a8:	a805                	j	7d8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9db9                	addw	a1,a1,a4
 7ae:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6318                	ld	a4,0(a4)
 7b6:	fee53823          	sd	a4,-16(a0)
 7ba:	a091                	j	7fe <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7bc:	ff852703          	lw	a4,-8(a0)
 7c0:	9e39                	addw	a2,a2,a4
 7c2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c4:	ff053703          	ld	a4,-16(a0)
 7c8:	e398                	sd	a4,0(a5)
 7ca:	a099                	j	810 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x40>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x50>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x36>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059713          	slli	a4,a1,0x20
 7f0:	9301                	srli	a4,a4,0x20
 7f2:	0712                	slli	a4,a4,0x4
 7f4:	9736                	add	a4,a4,a3
 7f6:	fae60ae3          	beq	a2,a4,7aa <free+0x14>
    bp->s.ptr = p->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061713          	slli	a4,a2,0x20
 804:	9301                	srli	a4,a4,0x20
 806:	0712                	slli	a4,a4,0x4
 808:	973e                	add	a4,a4,a5
 80a:	fae689e3          	beq	a3,a4,7bc <free+0x26>
  } else
    p->s.ptr = bp;
 80e:	e394                	sd	a3,0(a5)
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	1af73823          	sd	a5,432(a4) # 9c0 <freep>
}
 818:	6422                	ld	s0,8(sp)
 81a:	0141                	addi	sp,sp,16
 81c:	8082                	ret

000000000000081e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f426                	sd	s1,40(sp)
 826:	f04a                	sd	s2,32(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
 830:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	02051493          	slli	s1,a0,0x20
 836:	9081                	srli	s1,s1,0x20
 838:	04bd                	addi	s1,s1,15
 83a:	8091                	srli	s1,s1,0x4
 83c:	0014899b          	addiw	s3,s1,1
 840:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 842:	00000517          	auipc	a0,0x0
 846:	17e53503          	ld	a0,382(a0) # 9c0 <freep>
 84a:	c515                	beqz	a0,876 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	02977f63          	bgeu	a4,s1,88e <malloc+0x70>
 854:	8a4e                	mv	s4,s3
 856:	0009871b          	sext.w	a4,s3
 85a:	6685                	lui	a3,0x1
 85c:	00d77363          	bgeu	a4,a3,862 <malloc+0x44>
 860:	6a05                	lui	s4,0x1
 862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86a:	00000917          	auipc	s2,0x0
 86e:	15690913          	addi	s2,s2,342 # 9c0 <freep>
  if(p == (char*)-1)
 872:	5afd                	li	s5,-1
 874:	a88d                	j	8e6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 876:	00000797          	auipc	a5,0x0
 87a:	15278793          	addi	a5,a5,338 # 9c8 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	14f73123          	sd	a5,322(a4) # 9c0 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7e1                	j	854 <malloc+0x36>
      if(p->s.size == nunits)
 88e:	02e48b63          	beq	s1,a4,8c4 <malloc+0xa6>
        p->s.size -= nunits;
 892:	4137073b          	subw	a4,a4,s3
 896:	c798                	sw	a4,8(a5)
        p += p->s.size;
 898:	1702                	slli	a4,a4,0x20
 89a:	9301                	srli	a4,a4,0x20
 89c:	0712                	slli	a4,a4,0x4
 89e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	10a73e23          	sd	a0,284(a4) # 9c0 <freep>
      return (void*)(p + 1);
 8ac:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	7902                	ld	s2,32(sp)
 8b8:	69e2                	ld	s3,24(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	6121                	addi	sp,sp,64
 8c2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	bff1                	j	8a4 <malloc+0x86>
  hp->s.size = nu;
 8ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ce:	0541                	addi	a0,a0,16
 8d0:	00000097          	auipc	ra,0x0
 8d4:	ec6080e7          	jalr	-314(ra) # 796 <free>
  return freep;
 8d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8dc:	d971                	beqz	a0,8b0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e0:	4798                	lw	a4,8(a5)
 8e2:	fa9776e3          	bgeu	a4,s1,88e <malloc+0x70>
    if(p == freep)
 8e6:	00093703          	ld	a4,0(s2)
 8ea:	853e                	mv	a0,a5
 8ec:	fef719e3          	bne	a4,a5,8de <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f0:	8552                	mv	a0,s4
 8f2:	00000097          	auipc	ra,0x0
 8f6:	b6e080e7          	jalr	-1170(ra) # 460 <sbrk>
  if(p == (char*)-1)
 8fa:	fd5518e3          	bne	a0,s5,8ca <malloc+0xac>
        return 0;
 8fe:	4501                	li	a0,0
 900:	bf45                	j	8b0 <malloc+0x92>
