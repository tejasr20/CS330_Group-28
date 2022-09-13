
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
  88:	89458593          	addi	a1,a1,-1900 # 918 <malloc+0xe6>
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	6b8080e7          	jalr	1720(ra) # 746 <fprintf>
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
 118:	80c58593          	addi	a1,a1,-2036 # 920 <malloc+0xee>
 11c:	4509                	li	a0,2
 11e:	00000097          	auipc	ra,0x0
 122:	628080e7          	jalr	1576(ra) # 746 <fprintf>
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
 166:	7d658593          	addi	a1,a1,2006 # 938 <malloc+0x106>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	5da080e7          	jalr	1498(ra) # 746 <fprintf>
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

0000000000000494 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 494:	48d9                	li	a7,22
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49c:	1101                	addi	sp,sp,-32
 49e:	ec06                	sd	ra,24(sp)
 4a0:	e822                	sd	s0,16(sp)
 4a2:	1000                	addi	s0,sp,32
 4a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	fef40593          	addi	a1,s0,-17
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f66080e7          	jalr	-154(ra) # 414 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	f04a                	sd	s2,32(sp)
 4c8:	ec4e                	sd	s3,24(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c299                	beqz	a3,4d4 <printint+0x16>
 4d0:	0805c863          	bltz	a1,560 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	49050513          	addi	a0,a0,1168 # 970 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if(neg)
 50c:	00088b63          	beqz	a7,522 <printint+0x64>
    buf[i++] = '-';
 510:	fd040793          	addi	a5,s0,-48
 514:	973e                	add	a4,a4,a5
 516:	02d00793          	li	a5,45
 51a:	fef70823          	sb	a5,-16(a4)
 51e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 522:	02e05863          	blez	a4,552 <printint+0x94>
 526:	fc040793          	addi	a5,s0,-64
 52a:	00e78933          	add	s2,a5,a4
 52e:	fff78993          	addi	s3,a5,-1
 532:	99ba                	add	s3,s3,a4
 534:	377d                	addiw	a4,a4,-1
 536:	1702                	slli	a4,a4,0x20
 538:	9301                	srli	a4,a4,0x20
 53a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53e:	fff94583          	lbu	a1,-1(s2)
 542:	8526                	mv	a0,s1
 544:	00000097          	auipc	ra,0x0
 548:	f58080e7          	jalr	-168(ra) # 49c <putc>
  while(--i >= 0)
 54c:	197d                	addi	s2,s2,-1
 54e:	ff3918e3          	bne	s2,s3,53e <printint+0x80>
}
 552:	70e2                	ld	ra,56(sp)
 554:	7442                	ld	s0,48(sp)
 556:	74a2                	ld	s1,40(sp)
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
 55c:	6121                	addi	sp,sp,64
 55e:	8082                	ret
    x = -xx;
 560:	40b005bb          	negw	a1,a1
    neg = 1;
 564:	4885                	li	a7,1
    x = -xx;
 566:	bf8d                	j	4d8 <printint+0x1a>

0000000000000568 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 568:	7119                	addi	sp,sp,-128
 56a:	fc86                	sd	ra,120(sp)
 56c:	f8a2                	sd	s0,112(sp)
 56e:	f4a6                	sd	s1,104(sp)
 570:	f0ca                	sd	s2,96(sp)
 572:	ecce                	sd	s3,88(sp)
 574:	e8d2                	sd	s4,80(sp)
 576:	e4d6                	sd	s5,72(sp)
 578:	e0da                	sd	s6,64(sp)
 57a:	fc5e                	sd	s7,56(sp)
 57c:	f862                	sd	s8,48(sp)
 57e:	f466                	sd	s9,40(sp)
 580:	f06a                	sd	s10,32(sp)
 582:	ec6e                	sd	s11,24(sp)
 584:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c903          	lbu	s2,0(a1)
 58a:	18090f63          	beqz	s2,728 <vprintf+0x1c0>
 58e:	8aaa                	mv	s5,a0
 590:	8b32                	mv	s6,a2
 592:	00158493          	addi	s1,a1,1
  state = 0;
 596:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 598:	02500a13          	li	s4,37
      if(c == 'd'){
 59c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5a0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5a8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ac:	00000b97          	auipc	s7,0x0
 5b0:	3c4b8b93          	addi	s7,s7,964 # 970 <digits>
 5b4:	a839                	j	5d2 <vprintf+0x6a>
        putc(fd, c);
 5b6:	85ca                	mv	a1,s2
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ee2080e7          	jalr	-286(ra) # 49c <putc>
 5c2:	a019                	j	5c8 <vprintf+0x60>
    } else if(state == '%'){
 5c4:	01498f63          	beq	s3,s4,5e2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c8:	0485                	addi	s1,s1,1
 5ca:	fff4c903          	lbu	s2,-1(s1)
 5ce:	14090d63          	beqz	s2,728 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d6:	fe0997e3          	bnez	s3,5c4 <vprintf+0x5c>
      if(c == '%'){
 5da:	fd479ee3          	bne	a5,s4,5b6 <vprintf+0x4e>
        state = '%';
 5de:	89be                	mv	s3,a5
 5e0:	b7e5                	j	5c8 <vprintf+0x60>
      if(c == 'd'){
 5e2:	05878063          	beq	a5,s8,622 <vprintf+0xba>
      } else if(c == 'l') {
 5e6:	05978c63          	beq	a5,s9,63e <vprintf+0xd6>
      } else if(c == 'x') {
 5ea:	07a78863          	beq	a5,s10,65a <vprintf+0xf2>
      } else if(c == 'p') {
 5ee:	09b78463          	beq	a5,s11,676 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f2:	07300713          	li	a4,115
 5f6:	0ce78663          	beq	a5,a4,6c2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fa:	06300713          	li	a4,99
 5fe:	0ee78e63          	beq	a5,a4,6fa <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 602:	11478863          	beq	a5,s4,712 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 606:	85d2                	mv	a1,s4
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e92080e7          	jalr	-366(ra) # 49c <putc>
        putc(fd, c);
 612:	85ca                	mv	a1,s2
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e86080e7          	jalr	-378(ra) # 49c <putc>
      }
      state = 0;
 61e:	4981                	li	s3,0
 620:	b765                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 622:	008b0913          	addi	s2,s6,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000b2583          	lw	a1,0(s6)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e8e080e7          	jalr	-370(ra) # 4be <printint>
 638:	8b4a                	mv	s6,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b771                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b0913          	addi	s2,s6,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000b2583          	lw	a1,0(s6)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e72080e7          	jalr	-398(ra) # 4be <printint>
 654:	8b4a                	mv	s6,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	bf85                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 65a:	008b0913          	addi	s2,s6,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000b2583          	lw	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e56080e7          	jalr	-426(ra) # 4be <printint>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bf91                	j	5c8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 676:	008b0793          	addi	a5,s6,8
 67a:	f8f43423          	sd	a5,-120(s0)
 67e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 682:	03000593          	li	a1,48
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e14080e7          	jalr	-492(ra) # 49c <putc>
  putc(fd, 'x');
 690:	85ea                	mv	a1,s10
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e08080e7          	jalr	-504(ra) # 49c <putc>
 69c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	df2080e7          	jalr	-526(ra) # 49c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b2:	0992                	slli	s3,s3,0x4
 6b4:	397d                	addiw	s2,s2,-1
 6b6:	fe0914e3          	bnez	s2,69e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ba:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b721                	j	5c8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c2:	008b0993          	addi	s3,s6,8
 6c6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ca:	02090163          	beqz	s2,6ec <vprintf+0x184>
        while(*s != 0){
 6ce:	00094583          	lbu	a1,0(s2)
 6d2:	c9a1                	beqz	a1,722 <vprintf+0x1ba>
          putc(fd, *s);
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	dc6080e7          	jalr	-570(ra) # 49c <putc>
          s++;
 6de:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e0:	00094583          	lbu	a1,0(s2)
 6e4:	f9e5                	bnez	a1,6d4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e6:	8b4e                	mv	s6,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bdf9                	j	5c8 <vprintf+0x60>
          s = "(null)";
 6ec:	00000917          	auipc	s2,0x0
 6f0:	27c90913          	addi	s2,s2,636 # 968 <malloc+0x136>
        while(*s != 0){
 6f4:	02800593          	li	a1,40
 6f8:	bff1                	j	6d4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6fa:	008b0913          	addi	s2,s6,8
 6fe:	000b4583          	lbu	a1,0(s6)
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	d98080e7          	jalr	-616(ra) # 49c <putc>
 70c:	8b4a                	mv	s6,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd65                	j	5c8 <vprintf+0x60>
        putc(fd, c);
 712:	85d2                	mv	a1,s4
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	d86080e7          	jalr	-634(ra) # 49c <putc>
      state = 0;
 71e:	4981                	li	s3,0
 720:	b565                	j	5c8 <vprintf+0x60>
        s = va_arg(ap, char*);
 722:	8b4e                	mv	s6,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	b54d                	j	5c8 <vprintf+0x60>
    }
  }
}
 728:	70e6                	ld	ra,120(sp)
 72a:	7446                	ld	s0,112(sp)
 72c:	74a6                	ld	s1,104(sp)
 72e:	7906                	ld	s2,96(sp)
 730:	69e6                	ld	s3,88(sp)
 732:	6a46                	ld	s4,80(sp)
 734:	6aa6                	ld	s5,72(sp)
 736:	6b06                	ld	s6,64(sp)
 738:	7be2                	ld	s7,56(sp)
 73a:	7c42                	ld	s8,48(sp)
 73c:	7ca2                	ld	s9,40(sp)
 73e:	7d02                	ld	s10,32(sp)
 740:	6de2                	ld	s11,24(sp)
 742:	6109                	addi	sp,sp,128
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 762:	8622                	mv	a2,s0
 764:	00000097          	auipc	ra,0x0
 768:	e04080e7          	jalr	-508(ra) # 568 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6161                	addi	sp,sp,80
 772:	8082                	ret

0000000000000774 <printf>:

void
printf(const char *fmt, ...)
{
 774:	711d                	addi	sp,sp,-96
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e40c                	sd	a1,8(s0)
 77e:	e810                	sd	a2,16(s0)
 780:	ec14                	sd	a3,24(s0)
 782:	f018                	sd	a4,32(s0)
 784:	f41c                	sd	a5,40(s0)
 786:	03043823          	sd	a6,48(s0)
 78a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	00840613          	addi	a2,s0,8
 792:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 796:	85aa                	mv	a1,a0
 798:	4505                	li	a0,1
 79a:	00000097          	auipc	ra,0x0
 79e:	dce080e7          	jalr	-562(ra) # 568 <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e422                	sd	s0,8(sp)
 7ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	00000797          	auipc	a5,0x0
 7b8:	1d47b783          	ld	a5,468(a5) # 988 <freep>
 7bc:	a805                	j	7ec <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7be:	4618                	lw	a4,8(a2)
 7c0:	9db9                	addw	a1,a1,a4
 7c2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	6318                	ld	a4,0(a4)
 7ca:	fee53823          	sd	a4,-16(a0)
 7ce:	a091                	j	812 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d0:	ff852703          	lw	a4,-8(a0)
 7d4:	9e39                	addw	a2,a2,a4
 7d6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	ff053703          	ld	a4,-16(a0)
 7dc:	e398                	sd	a4,0(a5)
 7de:	a099                	j	824 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e7e463          	bltu	a5,a4,7ea <free+0x40>
 7e6:	00e6ea63          	bltu	a3,a4,7fa <free+0x50>
{
 7ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	fed7fae3          	bgeu	a5,a3,7e0 <free+0x36>
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e6e463          	bltu	a3,a4,7fa <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	fee7eae3          	bltu	a5,a4,7ea <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7fa:	ff852583          	lw	a1,-8(a0)
 7fe:	6390                	ld	a2,0(a5)
 800:	02059713          	slli	a4,a1,0x20
 804:	9301                	srli	a4,a4,0x20
 806:	0712                	slli	a4,a4,0x4
 808:	9736                	add	a4,a4,a3
 80a:	fae60ae3          	beq	a2,a4,7be <free+0x14>
    bp->s.ptr = p->s.ptr;
 80e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 812:	4790                	lw	a2,8(a5)
 814:	02061713          	slli	a4,a2,0x20
 818:	9301                	srli	a4,a4,0x20
 81a:	0712                	slli	a4,a4,0x4
 81c:	973e                	add	a4,a4,a5
 81e:	fae689e3          	beq	a3,a4,7d0 <free+0x26>
  } else
    p->s.ptr = bp;
 822:	e394                	sd	a3,0(a5)
  freep = p;
 824:	00000717          	auipc	a4,0x0
 828:	16f73223          	sd	a5,356(a4) # 988 <freep>
}
 82c:	6422                	ld	s0,8(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret

0000000000000832 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 832:	7139                	addi	sp,sp,-64
 834:	fc06                	sd	ra,56(sp)
 836:	f822                	sd	s0,48(sp)
 838:	f426                	sd	s1,40(sp)
 83a:	f04a                	sd	s2,32(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
 844:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 846:	02051493          	slli	s1,a0,0x20
 84a:	9081                	srli	s1,s1,0x20
 84c:	04bd                	addi	s1,s1,15
 84e:	8091                	srli	s1,s1,0x4
 850:	0014899b          	addiw	s3,s1,1
 854:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 856:	00000517          	auipc	a0,0x0
 85a:	13253503          	ld	a0,306(a0) # 988 <freep>
 85e:	c515                	beqz	a0,88a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	02977f63          	bgeu	a4,s1,8a2 <malloc+0x70>
 868:	8a4e                	mv	s4,s3
 86a:	0009871b          	sext.w	a4,s3
 86e:	6685                	lui	a3,0x1
 870:	00d77363          	bgeu	a4,a3,876 <malloc+0x44>
 874:	6a05                	lui	s4,0x1
 876:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87e:	00000917          	auipc	s2,0x0
 882:	10a90913          	addi	s2,s2,266 # 988 <freep>
  if(p == (char*)-1)
 886:	5afd                	li	s5,-1
 888:	a88d                	j	8fa <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 88a:	00000797          	auipc	a5,0x0
 88e:	10678793          	addi	a5,a5,262 # 990 <base>
 892:	00000717          	auipc	a4,0x0
 896:	0ef73b23          	sd	a5,246(a4) # 988 <freep>
 89a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a0:	b7e1                	j	868 <malloc+0x36>
      if(p->s.size == nunits)
 8a2:	02e48b63          	beq	s1,a4,8d8 <malloc+0xa6>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	1702                	slli	a4,a4,0x20
 8ae:	9301                	srli	a4,a4,0x20
 8b0:	0712                	slli	a4,a4,0x4
 8b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b8:	00000717          	auipc	a4,0x0
 8bc:	0ca73823          	sd	a0,208(a4) # 988 <freep>
      return (void*)(p + 1);
 8c0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c4:	70e2                	ld	ra,56(sp)
 8c6:	7442                	ld	s0,48(sp)
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	7902                	ld	s2,32(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	6121                	addi	sp,sp,64
 8d6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	e118                	sd	a4,0(a0)
 8dc:	bff1                	j	8b8 <malloc+0x86>
  hp->s.size = nu;
 8de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e2:	0541                	addi	a0,a0,16
 8e4:	00000097          	auipc	ra,0x0
 8e8:	ec6080e7          	jalr	-314(ra) # 7aa <free>
  return freep;
 8ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f0:	d971                	beqz	a0,8c4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	fa9776e3          	bgeu	a4,s1,8a2 <malloc+0x70>
    if(p == freep)
 8fa:	00093703          	ld	a4,0(s2)
 8fe:	853e                	mv	a0,a5
 900:	fef719e3          	bne	a4,a5,8f2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	00000097          	auipc	ra,0x0
 90a:	b76080e7          	jalr	-1162(ra) # 47c <sbrk>
  if(p == (char*)-1)
 90e:	fd5518e3          	bne	a0,s5,8de <malloc+0xac>
        return 0;
 912:	4501                	li	a0,0
 914:	bf45                	j	8c4 <malloc+0x92>
