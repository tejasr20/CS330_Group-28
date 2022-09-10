
user/_pipeline:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <pipeline>:
//#include<unistd.h>
//#include <stdlib.h>

//recursively 
void pipeline(int n, int x) // n processes left, creates a new pipe in each call. Only parent process prints. 
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	fcb42623          	sw	a1,-52(s0)
	if(n==0) return;
   e:	e511                	bnez	a0,1a <pipeline+0x1a>
		close(p[0]); //close the read end of the pipe 
		pipeline(n-1,temp); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
		exit(0);	
	}
	return;
}
  10:	70e2                	ld	ra,56(sp)
  12:	7442                	ld	s0,48(sp)
  14:	74a2                	ld	s1,40(sp)
  16:	6121                	addi	sp,sp,64
  18:	8082                	ret
  1a:	84aa                	mv	s1,a0
	int t=pipe(p);
  1c:	fd840513          	addi	a0,s0,-40
  20:	00000097          	auipc	ra,0x0
  24:	3e4080e7          	jalr	996(ra) # 404 <pipe>
	if (t<0) //pipe creation failed 
  28:	06054d63          	bltz	a0,a2 <pipeline+0xa2>
	int pid= getpid();
  2c:	00000097          	auipc	ra,0x0
  30:	448080e7          	jalr	1096(ra) # 474 <getpid>
	int id = fork();
  34:	00000097          	auipc	ra,0x0
  38:	3b8080e7          	jalr	952(ra) # 3ec <fork>
	if(id>0) //parent process 
  3c:	06a05863          	blez	a0,ac <pipeline+0xac>
		pid=getpid();
  40:	00000097          	auipc	ra,0x0
  44:	434080e7          	jalr	1076(ra) # 474 <getpid>
  48:	84aa                	mv	s1,a0
		x=x+pid;
  4a:	fcc42783          	lw	a5,-52(s0)
  4e:	9fa9                	addw	a5,a5,a0
  50:	fcf42623          	sw	a5,-52(s0)
		write(p[1],&x, sizeof(int)); // writes to pipe 
  54:	4611                	li	a2,4
  56:	fcc40593          	addi	a1,s0,-52
  5a:	fdc42503          	lw	a0,-36(s0)
  5e:	00000097          	auipc	ra,0x0
  62:	3b6080e7          	jalr	950(ra) # 414 <write>
		close(p[1]);
  66:	fdc42503          	lw	a0,-36(s0)
  6a:	00000097          	auipc	ra,0x0
  6e:	3b2080e7          	jalr	946(ra) # 41c <close>
		close(p[0]);
  72:	fd842503          	lw	a0,-40(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	3a6080e7          	jalr	934(ra) # 41c <close>
		fprintf(1,"%d: %d\n",pid,x);
  7e:	fcc42683          	lw	a3,-52(s0)
  82:	8626                	mv	a2,s1
  84:	00001597          	auipc	a1,0x1
  88:	88c58593          	addi	a1,a1,-1908 # 910 <malloc+0xe6>
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	6b0080e7          	jalr	1712(ra) # 73e <fprintf>
		wait(0);
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	364080e7          	jalr	868(ra) # 3fc <wait>
	return;
  a0:	bf85                	j	10 <pipeline+0x10>
			exit(1);
  a2:	4505                	li	a0,1
  a4:	00000097          	auipc	ra,0x0
  a8:	350080e7          	jalr	848(ra) # 3f4 <exit>
		sleep(1);
  ac:	4505                	li	a0,1
  ae:	00000097          	auipc	ra,0x0
  b2:	3d6080e7          	jalr	982(ra) # 484 <sleep>
		close(p[1]); // child will not write anything 
  b6:	fdc42503          	lw	a0,-36(s0)
  ba:	00000097          	auipc	ra,0x0
  be:	362080e7          	jalr	866(ra) # 41c <close>
		pid=getpid();
  c2:	00000097          	auipc	ra,0x0
  c6:	3b2080e7          	jalr	946(ra) # 474 <getpid>
		read(p[0],&temp, sizeof(int)); // reads value of x 
  ca:	4611                	li	a2,4
  cc:	fd440593          	addi	a1,s0,-44
  d0:	fd842503          	lw	a0,-40(s0)
  d4:	00000097          	auipc	ra,0x0
  d8:	338080e7          	jalr	824(ra) # 40c <read>
		close(p[0]); //close the read end of the pipe 
  dc:	fd842503          	lw	a0,-40(s0)
  e0:	00000097          	auipc	ra,0x0
  e4:	33c080e7          	jalr	828(ra) # 41c <close>
		pipeline(n-1,temp); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
  e8:	fd442583          	lw	a1,-44(s0)
  ec:	fff4851b          	addiw	a0,s1,-1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <pipeline>
		exit(0);	
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2fa080e7          	jalr	762(ra) # 3f4 <exit>

0000000000000102 <main>:

int main(int argc, char *argv[])
{
 102:	1101                	addi	sp,sp,-32
 104:	ec06                	sd	ra,24(sp)
 106:	e822                	sd	s0,16(sp)
 108:	e426                	sd	s1,8(sp)
 10a:	e04a                	sd	s2,0(sp)
 10c:	1000                	addi	s0,sp,32
	if(argc!=3)
 10e:	478d                	li	a5,3
 110:	02f50063          	beq	a0,a5,130 <main+0x2e>
	{
		fprintf(2, "usage: pipeline n x\n");
 114:	00001597          	auipc	a1,0x1
 118:	80458593          	addi	a1,a1,-2044 # 918 <malloc+0xee>
 11c:	4509                	li	a0,2
 11e:	00000097          	auipc	ra,0x0
 122:	620080e7          	jalr	1568(ra) # 73e <fprintf>
		exit(1);        
 126:	4505                	li	a0,1
 128:	00000097          	auipc	ra,0x0
 12c:	2cc080e7          	jalr	716(ra) # 3f4 <exit>
 130:	84ae                	mv	s1,a1
	}
	int n,x;
	n=atoi(argv[1]); // converts to integer 
 132:	6588                	ld	a0,8(a1)
 134:	00000097          	auipc	ra,0x0
 138:	1c0080e7          	jalr	448(ra) # 2f4 <atoi>
 13c:	892a                	mv	s2,a0
	x=atoi(argv[2]);
 13e:	6888                	ld	a0,16(s1)
 140:	00000097          	auipc	ra,0x0
 144:	1b4080e7          	jalr	436(ra) # 2f4 <atoi>
 148:	85aa                	mv	a1,a0
	if(n<=0)
 14a:	01205c63          	blez	s2,162 <main+0x60>
		fprintf(2, "usage: pipeline n x. n must be greater than 0.\n");
		exit(1);
	}
	// we have valid inputs now: do we have to check if x is integral? 
	// the second argument is used to make the pid outputs easier to read and verify, each pid is taken wrt the original process pid
	pipeline(n,x);
 14e:	854a                	mv	a0,s2
 150:	00000097          	auipc	ra,0x0
 154:	eb0080e7          	jalr	-336(ra) # 0 <pipeline>
	exit(0);
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	29a080e7          	jalr	666(ra) # 3f4 <exit>
		fprintf(2, "usage: pipeline n x. n must be greater than 0.\n");
 162:	00000597          	auipc	a1,0x0
 166:	7ce58593          	addi	a1,a1,1998 # 930 <malloc+0x106>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	5d2080e7          	jalr	1490(ra) # 73e <fprintf>
		exit(1);
 174:	4505                	li	a0,1
 176:	00000097          	auipc	ra,0x0
 17a:	27e080e7          	jalr	638(ra) # 3f4 <exit>

000000000000017e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 184:	87aa                	mv	a5,a0
 186:	0585                	addi	a1,a1,1
 188:	0785                	addi	a5,a5,1
 18a:	fff5c703          	lbu	a4,-1(a1)
 18e:	fee78fa3          	sb	a4,-1(a5)
 192:	fb75                	bnez	a4,186 <strcpy+0x8>
    ;
  return os;
}
 194:	6422                	ld	s0,8(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cb91                	beqz	a5,1b8 <strcmp+0x1e>
 1a6:	0005c703          	lbu	a4,0(a1)
 1aa:	00f71763          	bne	a4,a5,1b8 <strcmp+0x1e>
    p++, q++;
 1ae:	0505                	addi	a0,a0,1
 1b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	fbe5                	bnez	a5,1a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b8:	0005c503          	lbu	a0,0(a1)
}
 1bc:	40a7853b          	subw	a0,a5,a0
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strlen>:

uint
strlen(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cf91                	beqz	a5,1ec <strlen+0x26>
 1d2:	0505                	addi	a0,a0,1
 1d4:	87aa                	mv	a5,a0
 1d6:	4685                	li	a3,1
 1d8:	9e89                	subw	a3,a3,a0
 1da:	00f6853b          	addw	a0,a3,a5
 1de:	0785                	addi	a5,a5,1
 1e0:	fff7c703          	lbu	a4,-1(a5)
 1e4:	fb7d                	bnez	a4,1da <strlen+0x14>
    ;
  return n;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  for(n = 0; s[n]; n++)
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strlen+0x20>

00000000000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f6:	ce09                	beqz	a2,210 <memset+0x20>
 1f8:	87aa                	mv	a5,a0
 1fa:	fff6071b          	addiw	a4,a2,-1
 1fe:	1702                	slli	a4,a4,0x20
 200:	9301                	srli	a4,a4,0x20
 202:	0705                	addi	a4,a4,1
 204:	972a                	add	a4,a4,a0
    cdst[i] = c;
 206:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20a:	0785                	addi	a5,a5,1
 20c:	fee79de3          	bne	a5,a4,206 <memset+0x16>
  }
  return dst;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <strchr>:

char*
strchr(const char *s, char c)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21c:	00054783          	lbu	a5,0(a0)
 220:	cb99                	beqz	a5,236 <strchr+0x20>
    if(*s == c)
 222:	00f58763          	beq	a1,a5,230 <strchr+0x1a>
  for(; *s; s++)
 226:	0505                	addi	a0,a0,1
 228:	00054783          	lbu	a5,0(a0)
 22c:	fbfd                	bnez	a5,222 <strchr+0xc>
      return (char*)s;
  return 0;
 22e:	4501                	li	a0,0
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  return 0;
 236:	4501                	li	a0,0
 238:	bfe5                	j	230 <strchr+0x1a>

000000000000023a <gets>:

char*
gets(char *buf, int max)
{
 23a:	711d                	addi	sp,sp,-96
 23c:	ec86                	sd	ra,88(sp)
 23e:	e8a2                	sd	s0,80(sp)
 240:	e4a6                	sd	s1,72(sp)
 242:	e0ca                	sd	s2,64(sp)
 244:	fc4e                	sd	s3,56(sp)
 246:	f852                	sd	s4,48(sp)
 248:	f456                	sd	s5,40(sp)
 24a:	f05a                	sd	s6,32(sp)
 24c:	ec5e                	sd	s7,24(sp)
 24e:	1080                	addi	s0,sp,96
 250:	8baa                	mv	s7,a0
 252:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 254:	892a                	mv	s2,a0
 256:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 258:	4aa9                	li	s5,10
 25a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 25c:	89a6                	mv	s3,s1
 25e:	2485                	addiw	s1,s1,1
 260:	0344d863          	bge	s1,s4,290 <gets+0x56>
    cc = read(0, &c, 1);
 264:	4605                	li	a2,1
 266:	faf40593          	addi	a1,s0,-81
 26a:	4501                	li	a0,0
 26c:	00000097          	auipc	ra,0x0
 270:	1a0080e7          	jalr	416(ra) # 40c <read>
    if(cc < 1)
 274:	00a05e63          	blez	a0,290 <gets+0x56>
    buf[i++] = c;
 278:	faf44783          	lbu	a5,-81(s0)
 27c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 280:	01578763          	beq	a5,s5,28e <gets+0x54>
 284:	0905                	addi	s2,s2,1
 286:	fd679be3          	bne	a5,s6,25c <gets+0x22>
  for(i=0; i+1 < max; ){
 28a:	89a6                	mv	s3,s1
 28c:	a011                	j	290 <gets+0x56>
 28e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 290:	99de                	add	s3,s3,s7
 292:	00098023          	sb	zero,0(s3)
  return buf;
}
 296:	855e                	mv	a0,s7
 298:	60e6                	ld	ra,88(sp)
 29a:	6446                	ld	s0,80(sp)
 29c:	64a6                	ld	s1,72(sp)
 29e:	6906                	ld	s2,64(sp)
 2a0:	79e2                	ld	s3,56(sp)
 2a2:	7a42                	ld	s4,48(sp)
 2a4:	7aa2                	ld	s5,40(sp)
 2a6:	7b02                	ld	s6,32(sp)
 2a8:	6be2                	ld	s7,24(sp)
 2aa:	6125                	addi	sp,sp,96
 2ac:	8082                	ret

00000000000002ae <stat>:

int
stat(const char *n, struct stat *st)
{
 2ae:	1101                	addi	sp,sp,-32
 2b0:	ec06                	sd	ra,24(sp)
 2b2:	e822                	sd	s0,16(sp)
 2b4:	e426                	sd	s1,8(sp)
 2b6:	e04a                	sd	s2,0(sp)
 2b8:	1000                	addi	s0,sp,32
 2ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2bc:	4581                	li	a1,0
 2be:	00000097          	auipc	ra,0x0
 2c2:	176080e7          	jalr	374(ra) # 434 <open>
  if(fd < 0)
 2c6:	02054563          	bltz	a0,2f0 <stat+0x42>
 2ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2cc:	85ca                	mv	a1,s2
 2ce:	00000097          	auipc	ra,0x0
 2d2:	17e080e7          	jalr	382(ra) # 44c <fstat>
 2d6:	892a                	mv	s2,a0
  close(fd);
 2d8:	8526                	mv	a0,s1
 2da:	00000097          	auipc	ra,0x0
 2de:	142080e7          	jalr	322(ra) # 41c <close>
  return r;
}
 2e2:	854a                	mv	a0,s2
 2e4:	60e2                	ld	ra,24(sp)
 2e6:	6442                	ld	s0,16(sp)
 2e8:	64a2                	ld	s1,8(sp)
 2ea:	6902                	ld	s2,0(sp)
 2ec:	6105                	addi	sp,sp,32
 2ee:	8082                	ret
    return -1;
 2f0:	597d                	li	s2,-1
 2f2:	bfc5                	j	2e2 <stat+0x34>

00000000000002f4 <atoi>:

int
atoi(const char *s)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fa:	00054603          	lbu	a2,0(a0)
 2fe:	fd06079b          	addiw	a5,a2,-48
 302:	0ff7f793          	andi	a5,a5,255
 306:	4725                	li	a4,9
 308:	02f76963          	bltu	a4,a5,33a <atoi+0x46>
 30c:	86aa                	mv	a3,a0
  n = 0;
 30e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 310:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 312:	0685                	addi	a3,a3,1
 314:	0025179b          	slliw	a5,a0,0x2
 318:	9fa9                	addw	a5,a5,a0
 31a:	0017979b          	slliw	a5,a5,0x1
 31e:	9fb1                	addw	a5,a5,a2
 320:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 324:	0006c603          	lbu	a2,0(a3)
 328:	fd06071b          	addiw	a4,a2,-48
 32c:	0ff77713          	andi	a4,a4,255
 330:	fee5f1e3          	bgeu	a1,a4,312 <atoi+0x1e>
  return n;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  n = 0;
 33a:	4501                	li	a0,0
 33c:	bfe5                	j	334 <atoi+0x40>

000000000000033e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 344:	02b57663          	bgeu	a0,a1,370 <memmove+0x32>
    while(n-- > 0)
 348:	02c05163          	blez	a2,36a <memmove+0x2c>
 34c:	fff6079b          	addiw	a5,a2,-1
 350:	1782                	slli	a5,a5,0x20
 352:	9381                	srli	a5,a5,0x20
 354:	0785                	addi	a5,a5,1
 356:	97aa                	add	a5,a5,a0
  dst = vdst;
 358:	872a                	mv	a4,a0
      *dst++ = *src++;
 35a:	0585                	addi	a1,a1,1
 35c:	0705                	addi	a4,a4,1
 35e:	fff5c683          	lbu	a3,-1(a1)
 362:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 366:	fee79ae3          	bne	a5,a4,35a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
    dst += n;
 370:	00c50733          	add	a4,a0,a2
    src += n;
 374:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 376:	fec05ae3          	blez	a2,36a <memmove+0x2c>
 37a:	fff6079b          	addiw	a5,a2,-1
 37e:	1782                	slli	a5,a5,0x20
 380:	9381                	srli	a5,a5,0x20
 382:	fff7c793          	not	a5,a5
 386:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 388:	15fd                	addi	a1,a1,-1
 38a:	177d                	addi	a4,a4,-1
 38c:	0005c683          	lbu	a3,0(a1)
 390:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 394:	fee79ae3          	bne	a5,a4,388 <memmove+0x4a>
 398:	bfc9                	j	36a <memmove+0x2c>

000000000000039a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a0:	ca05                	beqz	a2,3d0 <memcmp+0x36>
 3a2:	fff6069b          	addiw	a3,a2,-1
 3a6:	1682                	slli	a3,a3,0x20
 3a8:	9281                	srli	a3,a3,0x20
 3aa:	0685                	addi	a3,a3,1
 3ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ae:	00054783          	lbu	a5,0(a0)
 3b2:	0005c703          	lbu	a4,0(a1)
 3b6:	00e79863          	bne	a5,a4,3c6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ba:	0505                	addi	a0,a0,1
    p2++;
 3bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3be:	fed518e3          	bne	a0,a3,3ae <memcmp+0x14>
  }
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	a019                	j	3ca <memcmp+0x30>
      return *p1 - *p2;
 3c6:	40e7853b          	subw	a0,a5,a4
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfe5                	j	3ca <memcmp+0x30>

00000000000003d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f62080e7          	jalr	-158(ra) # 33e <memmove>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ec:	4885                	li	a7,1
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f4:	4889                	li	a7,2
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fc:	488d                	li	a7,3
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 404:	4891                	li	a7,4
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <read>:
.global read
read:
 li a7, SYS_read
 40c:	4895                	li	a7,5
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <write>:
.global write
write:
 li a7, SYS_write
 414:	48c1                	li	a7,16
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <close>:
.global close
close:
 li a7, SYS_close
 41c:	48d5                	li	a7,21
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kill>:
.global kill
kill:
 li a7, SYS_kill
 424:	4899                	li	a7,6
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exec>:
.global exec
exec:
 li a7, SYS_exec
 42c:	489d                	li	a7,7
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <open>:
.global open
open:
 li a7, SYS_open
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43c:	48c5                	li	a7,17
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 444:	48c9                	li	a7,18
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44c:	48a1                	li	a7,8
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <link>:
.global link
link:
 li a7, SYS_link
 454:	48cd                	li	a7,19
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45c:	48d1                	li	a7,20
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 464:	48a5                	li	a7,9
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <dup>:
.global dup
dup:
 li a7, SYS_dup
 46c:	48a9                	li	a7,10
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 474:	48ad                	li	a7,11
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47c:	48b1                	li	a7,12
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 484:	48b5                	li	a7,13
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48c:	48b9                	li	a7,14
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 494:	1101                	addi	sp,sp,-32
 496:	ec06                	sd	ra,24(sp)
 498:	e822                	sd	s0,16(sp)
 49a:	1000                	addi	s0,sp,32
 49c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a0:	4605                	li	a2,1
 4a2:	fef40593          	addi	a1,s0,-17
 4a6:	00000097          	auipc	ra,0x0
 4aa:	f6e080e7          	jalr	-146(ra) # 414 <write>
}
 4ae:	60e2                	ld	ra,24(sp)
 4b0:	6442                	ld	s0,16(sp)
 4b2:	6105                	addi	sp,sp,32
 4b4:	8082                	ret

00000000000004b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b6:	7139                	addi	sp,sp,-64
 4b8:	fc06                	sd	ra,56(sp)
 4ba:	f822                	sd	s0,48(sp)
 4bc:	f426                	sd	s1,40(sp)
 4be:	f04a                	sd	s2,32(sp)
 4c0:	ec4e                	sd	s3,24(sp)
 4c2:	0080                	addi	s0,sp,64
 4c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c6:	c299                	beqz	a3,4cc <printint+0x16>
 4c8:	0805c863          	bltz	a1,558 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4cc:	2581                	sext.w	a1,a1
  neg = 0;
 4ce:	4881                	li	a7,0
 4d0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d6:	2601                	sext.w	a2,a2
 4d8:	00000517          	auipc	a0,0x0
 4dc:	49050513          	addi	a0,a0,1168 # 968 <digits>
 4e0:	883a                	mv	a6,a4
 4e2:	2705                	addiw	a4,a4,1
 4e4:	02c5f7bb          	remuw	a5,a1,a2
 4e8:	1782                	slli	a5,a5,0x20
 4ea:	9381                	srli	a5,a5,0x20
 4ec:	97aa                	add	a5,a5,a0
 4ee:	0007c783          	lbu	a5,0(a5)
 4f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f6:	0005879b          	sext.w	a5,a1
 4fa:	02c5d5bb          	divuw	a1,a1,a2
 4fe:	0685                	addi	a3,a3,1
 500:	fec7f0e3          	bgeu	a5,a2,4e0 <printint+0x2a>
  if(neg)
 504:	00088b63          	beqz	a7,51a <printint+0x64>
    buf[i++] = '-';
 508:	fd040793          	addi	a5,s0,-48
 50c:	973e                	add	a4,a4,a5
 50e:	02d00793          	li	a5,45
 512:	fef70823          	sb	a5,-16(a4)
 516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 51a:	02e05863          	blez	a4,54a <printint+0x94>
 51e:	fc040793          	addi	a5,s0,-64
 522:	00e78933          	add	s2,a5,a4
 526:	fff78993          	addi	s3,a5,-1
 52a:	99ba                	add	s3,s3,a4
 52c:	377d                	addiw	a4,a4,-1
 52e:	1702                	slli	a4,a4,0x20
 530:	9301                	srli	a4,a4,0x20
 532:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 536:	fff94583          	lbu	a1,-1(s2)
 53a:	8526                	mv	a0,s1
 53c:	00000097          	auipc	ra,0x0
 540:	f58080e7          	jalr	-168(ra) # 494 <putc>
  while(--i >= 0)
 544:	197d                	addi	s2,s2,-1
 546:	ff3918e3          	bne	s2,s3,536 <printint+0x80>
}
 54a:	70e2                	ld	ra,56(sp)
 54c:	7442                	ld	s0,48(sp)
 54e:	74a2                	ld	s1,40(sp)
 550:	7902                	ld	s2,32(sp)
 552:	69e2                	ld	s3,24(sp)
 554:	6121                	addi	sp,sp,64
 556:	8082                	ret
    x = -xx;
 558:	40b005bb          	negw	a1,a1
    neg = 1;
 55c:	4885                	li	a7,1
    x = -xx;
 55e:	bf8d                	j	4d0 <printint+0x1a>

0000000000000560 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 560:	7119                	addi	sp,sp,-128
 562:	fc86                	sd	ra,120(sp)
 564:	f8a2                	sd	s0,112(sp)
 566:	f4a6                	sd	s1,104(sp)
 568:	f0ca                	sd	s2,96(sp)
 56a:	ecce                	sd	s3,88(sp)
 56c:	e8d2                	sd	s4,80(sp)
 56e:	e4d6                	sd	s5,72(sp)
 570:	e0da                	sd	s6,64(sp)
 572:	fc5e                	sd	s7,56(sp)
 574:	f862                	sd	s8,48(sp)
 576:	f466                	sd	s9,40(sp)
 578:	f06a                	sd	s10,32(sp)
 57a:	ec6e                	sd	s11,24(sp)
 57c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57e:	0005c903          	lbu	s2,0(a1)
 582:	18090f63          	beqz	s2,720 <vprintf+0x1c0>
 586:	8aaa                	mv	s5,a0
 588:	8b32                	mv	s6,a2
 58a:	00158493          	addi	s1,a1,1
  state = 0;
 58e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 590:	02500a13          	li	s4,37
      if(c == 'd'){
 594:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 598:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 59c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5a0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a4:	00000b97          	auipc	s7,0x0
 5a8:	3c4b8b93          	addi	s7,s7,964 # 968 <digits>
 5ac:	a839                	j	5ca <vprintf+0x6a>
        putc(fd, c);
 5ae:	85ca                	mv	a1,s2
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	ee2080e7          	jalr	-286(ra) # 494 <putc>
 5ba:	a019                	j	5c0 <vprintf+0x60>
    } else if(state == '%'){
 5bc:	01498f63          	beq	s3,s4,5da <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c0:	0485                	addi	s1,s1,1
 5c2:	fff4c903          	lbu	s2,-1(s1)
 5c6:	14090d63          	beqz	s2,720 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5ca:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ce:	fe0997e3          	bnez	s3,5bc <vprintf+0x5c>
      if(c == '%'){
 5d2:	fd479ee3          	bne	a5,s4,5ae <vprintf+0x4e>
        state = '%';
 5d6:	89be                	mv	s3,a5
 5d8:	b7e5                	j	5c0 <vprintf+0x60>
      if(c == 'd'){
 5da:	05878063          	beq	a5,s8,61a <vprintf+0xba>
      } else if(c == 'l') {
 5de:	05978c63          	beq	a5,s9,636 <vprintf+0xd6>
      } else if(c == 'x') {
 5e2:	07a78863          	beq	a5,s10,652 <vprintf+0xf2>
      } else if(c == 'p') {
 5e6:	09b78463          	beq	a5,s11,66e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5ea:	07300713          	li	a4,115
 5ee:	0ce78663          	beq	a5,a4,6ba <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f2:	06300713          	li	a4,99
 5f6:	0ee78e63          	beq	a5,a4,6f2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5fa:	11478863          	beq	a5,s4,70a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fe:	85d2                	mv	a1,s4
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e92080e7          	jalr	-366(ra) # 494 <putc>
        putc(fd, c);
 60a:	85ca                	mv	a1,s2
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e86080e7          	jalr	-378(ra) # 494 <putc>
      }
      state = 0;
 616:	4981                	li	s3,0
 618:	b765                	j	5c0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b0913          	addi	s2,s6,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000b2583          	lw	a1,0(s6)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e8e080e7          	jalr	-370(ra) # 4b6 <printint>
 630:	8b4a                	mv	s6,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b771                	j	5c0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b0913          	addi	s2,s6,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000b2583          	lw	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e72080e7          	jalr	-398(ra) # 4b6 <printint>
 64c:	8b4a                	mv	s6,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bf85                	j	5c0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 652:	008b0913          	addi	s2,s6,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000b2583          	lw	a1,0(s6)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e56080e7          	jalr	-426(ra) # 4b6 <printint>
 668:	8b4a                	mv	s6,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bf91                	j	5c0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 66e:	008b0793          	addi	a5,s6,8
 672:	f8f43423          	sd	a5,-120(s0)
 676:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e14080e7          	jalr	-492(ra) # 494 <putc>
  putc(fd, 'x');
 688:	85ea                	mv	a1,s10
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e08080e7          	jalr	-504(ra) # 494 <putc>
 694:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	03c9d793          	srli	a5,s3,0x3c
 69a:	97de                	add	a5,a5,s7
 69c:	0007c583          	lbu	a1,0(a5)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	df2080e7          	jalr	-526(ra) # 494 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6aa:	0992                	slli	s3,s3,0x4
 6ac:	397d                	addiw	s2,s2,-1
 6ae:	fe0914e3          	bnez	s2,696 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6b2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b721                	j	5c0 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ba:	008b0993          	addi	s3,s6,8
 6be:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6c2:	02090163          	beqz	s2,6e4 <vprintf+0x184>
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	c9a1                	beqz	a1,71a <vprintf+0x1ba>
          putc(fd, *s);
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	dc6080e7          	jalr	-570(ra) # 494 <putc>
          s++;
 6d6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	f9e5                	bnez	a1,6cc <vprintf+0x16c>
        s = va_arg(ap, char*);
 6de:	8b4e                	mv	s6,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bdf9                	j	5c0 <vprintf+0x60>
          s = "(null)";
 6e4:	00000917          	auipc	s2,0x0
 6e8:	27c90913          	addi	s2,s2,636 # 960 <malloc+0x136>
        while(*s != 0){
 6ec:	02800593          	li	a1,40
 6f0:	bff1                	j	6cc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6f2:	008b0913          	addi	s2,s6,8
 6f6:	000b4583          	lbu	a1,0(s6)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	d98080e7          	jalr	-616(ra) # 494 <putc>
 704:	8b4a                	mv	s6,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bd65                	j	5c0 <vprintf+0x60>
        putc(fd, c);
 70a:	85d2                	mv	a1,s4
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	d86080e7          	jalr	-634(ra) # 494 <putc>
      state = 0;
 716:	4981                	li	s3,0
 718:	b565                	j	5c0 <vprintf+0x60>
        s = va_arg(ap, char*);
 71a:	8b4e                	mv	s6,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b54d                	j	5c0 <vprintf+0x60>
    }
  }
}
 720:	70e6                	ld	ra,120(sp)
 722:	7446                	ld	s0,112(sp)
 724:	74a6                	ld	s1,104(sp)
 726:	7906                	ld	s2,96(sp)
 728:	69e6                	ld	s3,88(sp)
 72a:	6a46                	ld	s4,80(sp)
 72c:	6aa6                	ld	s5,72(sp)
 72e:	6b06                	ld	s6,64(sp)
 730:	7be2                	ld	s7,56(sp)
 732:	7c42                	ld	s8,48(sp)
 734:	7ca2                	ld	s9,40(sp)
 736:	7d02                	ld	s10,32(sp)
 738:	6de2                	ld	s11,24(sp)
 73a:	6109                	addi	sp,sp,128
 73c:	8082                	ret

000000000000073e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73e:	715d                	addi	sp,sp,-80
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	e010                	sd	a2,0(s0)
 748:	e414                	sd	a3,8(s0)
 74a:	e818                	sd	a4,16(s0)
 74c:	ec1c                	sd	a5,24(s0)
 74e:	03043023          	sd	a6,32(s0)
 752:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75a:	8622                	mv	a2,s0
 75c:	00000097          	auipc	ra,0x0
 760:	e04080e7          	jalr	-508(ra) # 560 <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6161                	addi	sp,sp,80
 76a:	8082                	ret

000000000000076c <printf>:

void
printf(const char *fmt, ...)
{
 76c:	711d                	addi	sp,sp,-96
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e40c                	sd	a1,8(s0)
 776:	e810                	sd	a2,16(s0)
 778:	ec14                	sd	a3,24(s0)
 77a:	f018                	sd	a4,32(s0)
 77c:	f41c                	sd	a5,40(s0)
 77e:	03043823          	sd	a6,48(s0)
 782:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	00840613          	addi	a2,s0,8
 78a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78e:	85aa                	mv	a1,a0
 790:	4505                	li	a0,1
 792:	00000097          	auipc	ra,0x0
 796:	dce080e7          	jalr	-562(ra) # 560 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e422                	sd	s0,8(sp)
 7a6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ac:	00000797          	auipc	a5,0x0
 7b0:	1d47b783          	ld	a5,468(a5) # 980 <freep>
 7b4:	a805                	j	7e4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b6:	4618                	lw	a4,8(a2)
 7b8:	9db9                	addw	a1,a1,a4
 7ba:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	6318                	ld	a4,0(a4)
 7c2:	fee53823          	sd	a4,-16(a0)
 7c6:	a091                	j	80a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9e39                	addw	a2,a2,a4
 7ce:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7d0:	ff053703          	ld	a4,-16(a0)
 7d4:	e398                	sd	a4,0(a5)
 7d6:	a099                	j	81c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e7e463          	bltu	a5,a4,7e2 <free+0x40>
 7de:	00e6ea63          	bltu	a3,a4,7f2 <free+0x50>
{
 7e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	fed7fae3          	bgeu	a5,a3,7d8 <free+0x36>
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e6e463          	bltu	a3,a4,7f2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	fee7eae3          	bltu	a5,a4,7e2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7f2:	ff852583          	lw	a1,-8(a0)
 7f6:	6390                	ld	a2,0(a5)
 7f8:	02059713          	slli	a4,a1,0x20
 7fc:	9301                	srli	a4,a4,0x20
 7fe:	0712                	slli	a4,a4,0x4
 800:	9736                	add	a4,a4,a3
 802:	fae60ae3          	beq	a2,a4,7b6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 806:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 80a:	4790                	lw	a2,8(a5)
 80c:	02061713          	slli	a4,a2,0x20
 810:	9301                	srli	a4,a4,0x20
 812:	0712                	slli	a4,a4,0x4
 814:	973e                	add	a4,a4,a5
 816:	fae689e3          	beq	a3,a4,7c8 <free+0x26>
  } else
    p->s.ptr = bp;
 81a:	e394                	sd	a3,0(a5)
  freep = p;
 81c:	00000717          	auipc	a4,0x0
 820:	16f73223          	sd	a5,356(a4) # 980 <freep>
}
 824:	6422                	ld	s0,8(sp)
 826:	0141                	addi	sp,sp,16
 828:	8082                	ret

000000000000082a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f426                	sd	s1,40(sp)
 832:	f04a                	sd	s2,32(sp)
 834:	ec4e                	sd	s3,24(sp)
 836:	e852                	sd	s4,16(sp)
 838:	e456                	sd	s5,8(sp)
 83a:	e05a                	sd	s6,0(sp)
 83c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83e:	02051493          	slli	s1,a0,0x20
 842:	9081                	srli	s1,s1,0x20
 844:	04bd                	addi	s1,s1,15
 846:	8091                	srli	s1,s1,0x4
 848:	0014899b          	addiw	s3,s1,1
 84c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 84e:	00000517          	auipc	a0,0x0
 852:	13253503          	ld	a0,306(a0) # 980 <freep>
 856:	c515                	beqz	a0,882 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	02977f63          	bgeu	a4,s1,89a <malloc+0x70>
 860:	8a4e                	mv	s4,s3
 862:	0009871b          	sext.w	a4,s3
 866:	6685                	lui	a3,0x1
 868:	00d77363          	bgeu	a4,a3,86e <malloc+0x44>
 86c:	6a05                	lui	s4,0x1
 86e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 872:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 876:	00000917          	auipc	s2,0x0
 87a:	10a90913          	addi	s2,s2,266 # 980 <freep>
  if(p == (char*)-1)
 87e:	5afd                	li	s5,-1
 880:	a88d                	j	8f2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 882:	00000797          	auipc	a5,0x0
 886:	10678793          	addi	a5,a5,262 # 988 <base>
 88a:	00000717          	auipc	a4,0x0
 88e:	0ef73b23          	sd	a5,246(a4) # 980 <freep>
 892:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 894:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 898:	b7e1                	j	860 <malloc+0x36>
      if(p->s.size == nunits)
 89a:	02e48b63          	beq	s1,a4,8d0 <malloc+0xa6>
        p->s.size -= nunits;
 89e:	4137073b          	subw	a4,a4,s3
 8a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a4:	1702                	slli	a4,a4,0x20
 8a6:	9301                	srli	a4,a4,0x20
 8a8:	0712                	slli	a4,a4,0x4
 8aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	0ca73823          	sd	a0,208(a4) # 980 <freep>
      return (void*)(p + 1);
 8b8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	7902                	ld	s2,32(sp)
 8c4:	69e2                	ld	s3,24(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	6121                	addi	sp,sp,64
 8ce:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	bff1                	j	8b0 <malloc+0x86>
  hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8da:	0541                	addi	a0,a0,16
 8dc:	00000097          	auipc	ra,0x0
 8e0:	ec6080e7          	jalr	-314(ra) # 7a2 <free>
  return freep;
 8e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e8:	d971                	beqz	a0,8bc <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	fa9776e3          	bgeu	a4,s1,89a <malloc+0x70>
    if(p == freep)
 8f2:	00093703          	ld	a4,0(s2)
 8f6:	853e                	mv	a0,a5
 8f8:	fef719e3          	bne	a4,a5,8ea <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8fc:	8552                	mv	a0,s4
 8fe:	00000097          	auipc	ra,0x0
 902:	b7e080e7          	jalr	-1154(ra) # 47c <sbrk>
  if(p == (char*)-1)
 906:	fd5518e3          	bne	a0,s5,8d6 <malloc+0xac>
        return 0;
 90a:	4501                	li	a0,0
 90c:	bf45                	j	8bc <malloc+0x92>
