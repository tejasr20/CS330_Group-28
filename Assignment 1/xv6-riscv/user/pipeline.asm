
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
  88:	89c58593          	addi	a1,a1,-1892 # 920 <malloc+0xe6>
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	6c0080e7          	jalr	1728(ra) # 74e <fprintf>
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
 118:	81458593          	addi	a1,a1,-2028 # 928 <malloc+0xee>
 11c:	4509                	li	a0,2
 11e:	00000097          	auipc	ra,0x0
 122:	630080e7          	jalr	1584(ra) # 74e <fprintf>
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
 166:	7de58593          	addi	a1,a1,2014 # 940 <malloc+0x106>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	5e2080e7          	jalr	1506(ra) # 74e <fprintf>
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

000000000000049c <yield>:
.global yield
yield:
 li a7, SYS_yield
 49c:	48dd                	li	a7,23
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a4:	1101                	addi	sp,sp,-32
 4a6:	ec06                	sd	ra,24(sp)
 4a8:	e822                	sd	s0,16(sp)
 4aa:	1000                	addi	s0,sp,32
 4ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b0:	4605                	li	a2,1
 4b2:	fef40593          	addi	a1,s0,-17
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f5e080e7          	jalr	-162(ra) # 414 <write>
}
 4be:	60e2                	ld	ra,24(sp)
 4c0:	6442                	ld	s0,16(sp)
 4c2:	6105                	addi	sp,sp,32
 4c4:	8082                	ret

00000000000004c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c6:	7139                	addi	sp,sp,-64
 4c8:	fc06                	sd	ra,56(sp)
 4ca:	f822                	sd	s0,48(sp)
 4cc:	f426                	sd	s1,40(sp)
 4ce:	f04a                	sd	s2,32(sp)
 4d0:	ec4e                	sd	s3,24(sp)
 4d2:	0080                	addi	s0,sp,64
 4d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d6:	c299                	beqz	a3,4dc <printint+0x16>
 4d8:	0805c863          	bltz	a1,568 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4dc:	2581                	sext.w	a1,a1
  neg = 0;
 4de:	4881                	li	a7,0
 4e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e6:	2601                	sext.w	a2,a2
 4e8:	00000517          	auipc	a0,0x0
 4ec:	49050513          	addi	a0,a0,1168 # 978 <digits>
 4f0:	883a                	mv	a6,a4
 4f2:	2705                	addiw	a4,a4,1
 4f4:	02c5f7bb          	remuw	a5,a1,a2
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	97aa                	add	a5,a5,a0
 4fe:	0007c783          	lbu	a5,0(a5)
 502:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 506:	0005879b          	sext.w	a5,a1
 50a:	02c5d5bb          	divuw	a1,a1,a2
 50e:	0685                	addi	a3,a3,1
 510:	fec7f0e3          	bgeu	a5,a2,4f0 <printint+0x2a>
  if(neg)
 514:	00088b63          	beqz	a7,52a <printint+0x64>
    buf[i++] = '-';
 518:	fd040793          	addi	a5,s0,-48
 51c:	973e                	add	a4,a4,a5
 51e:	02d00793          	li	a5,45
 522:	fef70823          	sb	a5,-16(a4)
 526:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52a:	02e05863          	blez	a4,55a <printint+0x94>
 52e:	fc040793          	addi	a5,s0,-64
 532:	00e78933          	add	s2,a5,a4
 536:	fff78993          	addi	s3,a5,-1
 53a:	99ba                	add	s3,s3,a4
 53c:	377d                	addiw	a4,a4,-1
 53e:	1702                	slli	a4,a4,0x20
 540:	9301                	srli	a4,a4,0x20
 542:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 546:	fff94583          	lbu	a1,-1(s2)
 54a:	8526                	mv	a0,s1
 54c:	00000097          	auipc	ra,0x0
 550:	f58080e7          	jalr	-168(ra) # 4a4 <putc>
  while(--i >= 0)
 554:	197d                	addi	s2,s2,-1
 556:	ff3918e3          	bne	s2,s3,546 <printint+0x80>
}
 55a:	70e2                	ld	ra,56(sp)
 55c:	7442                	ld	s0,48(sp)
 55e:	74a2                	ld	s1,40(sp)
 560:	7902                	ld	s2,32(sp)
 562:	69e2                	ld	s3,24(sp)
 564:	6121                	addi	sp,sp,64
 566:	8082                	ret
    x = -xx;
 568:	40b005bb          	negw	a1,a1
    neg = 1;
 56c:	4885                	li	a7,1
    x = -xx;
 56e:	bf8d                	j	4e0 <printint+0x1a>

0000000000000570 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 570:	7119                	addi	sp,sp,-128
 572:	fc86                	sd	ra,120(sp)
 574:	f8a2                	sd	s0,112(sp)
 576:	f4a6                	sd	s1,104(sp)
 578:	f0ca                	sd	s2,96(sp)
 57a:	ecce                	sd	s3,88(sp)
 57c:	e8d2                	sd	s4,80(sp)
 57e:	e4d6                	sd	s5,72(sp)
 580:	e0da                	sd	s6,64(sp)
 582:	fc5e                	sd	s7,56(sp)
 584:	f862                	sd	s8,48(sp)
 586:	f466                	sd	s9,40(sp)
 588:	f06a                	sd	s10,32(sp)
 58a:	ec6e                	sd	s11,24(sp)
 58c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58e:	0005c903          	lbu	s2,0(a1)
 592:	18090f63          	beqz	s2,730 <vprintf+0x1c0>
 596:	8aaa                	mv	s5,a0
 598:	8b32                	mv	s6,a2
 59a:	00158493          	addi	s1,a1,1
  state = 0;
 59e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a0:	02500a13          	li	s4,37
      if(c == 'd'){
 5a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5a8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ac:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5b0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b4:	00000b97          	auipc	s7,0x0
 5b8:	3c4b8b93          	addi	s7,s7,964 # 978 <digits>
 5bc:	a839                	j	5da <vprintf+0x6a>
        putc(fd, c);
 5be:	85ca                	mv	a1,s2
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	ee2080e7          	jalr	-286(ra) # 4a4 <putc>
 5ca:	a019                	j	5d0 <vprintf+0x60>
    } else if(state == '%'){
 5cc:	01498f63          	beq	s3,s4,5ea <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5d0:	0485                	addi	s1,s1,1
 5d2:	fff4c903          	lbu	s2,-1(s1)
 5d6:	14090d63          	beqz	s2,730 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5da:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5de:	fe0997e3          	bnez	s3,5cc <vprintf+0x5c>
      if(c == '%'){
 5e2:	fd479ee3          	bne	a5,s4,5be <vprintf+0x4e>
        state = '%';
 5e6:	89be                	mv	s3,a5
 5e8:	b7e5                	j	5d0 <vprintf+0x60>
      if(c == 'd'){
 5ea:	05878063          	beq	a5,s8,62a <vprintf+0xba>
      } else if(c == 'l') {
 5ee:	05978c63          	beq	a5,s9,646 <vprintf+0xd6>
      } else if(c == 'x') {
 5f2:	07a78863          	beq	a5,s10,662 <vprintf+0xf2>
      } else if(c == 'p') {
 5f6:	09b78463          	beq	a5,s11,67e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5fa:	07300713          	li	a4,115
 5fe:	0ce78663          	beq	a5,a4,6ca <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 602:	06300713          	li	a4,99
 606:	0ee78e63          	beq	a5,a4,702 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 60a:	11478863          	beq	a5,s4,71a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60e:	85d2                	mv	a1,s4
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e92080e7          	jalr	-366(ra) # 4a4 <putc>
        putc(fd, c);
 61a:	85ca                	mv	a1,s2
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e86080e7          	jalr	-378(ra) # 4a4 <putc>
      }
      state = 0;
 626:	4981                	li	s3,0
 628:	b765                	j	5d0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 62a:	008b0913          	addi	s2,s6,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000b2583          	lw	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e8e080e7          	jalr	-370(ra) # 4c6 <printint>
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	b771                	j	5d0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 646:	008b0913          	addi	s2,s6,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000b2583          	lw	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e72080e7          	jalr	-398(ra) # 4c6 <printint>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf85                	j	5d0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 662:	008b0913          	addi	s2,s6,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000b2583          	lw	a1,0(s6)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e56080e7          	jalr	-426(ra) # 4c6 <printint>
 678:	8b4a                	mv	s6,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bf91                	j	5d0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 67e:	008b0793          	addi	a5,s6,8
 682:	f8f43423          	sd	a5,-120(s0)
 686:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 68a:	03000593          	li	a1,48
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e14080e7          	jalr	-492(ra) # 4a4 <putc>
  putc(fd, 'x');
 698:	85ea                	mv	a1,s10
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e08080e7          	jalr	-504(ra) # 4a4 <putc>
 6a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a6:	03c9d793          	srli	a5,s3,0x3c
 6aa:	97de                	add	a5,a5,s7
 6ac:	0007c583          	lbu	a1,0(a5)
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	df2080e7          	jalr	-526(ra) # 4a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ba:	0992                	slli	s3,s3,0x4
 6bc:	397d                	addiw	s2,s2,-1
 6be:	fe0914e3          	bnez	s2,6a6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6c2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b721                	j	5d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ca:	008b0993          	addi	s3,s6,8
 6ce:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6d2:	02090163          	beqz	s2,6f4 <vprintf+0x184>
        while(*s != 0){
 6d6:	00094583          	lbu	a1,0(s2)
 6da:	c9a1                	beqz	a1,72a <vprintf+0x1ba>
          putc(fd, *s);
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	dc6080e7          	jalr	-570(ra) # 4a4 <putc>
          s++;
 6e6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e8:	00094583          	lbu	a1,0(s2)
 6ec:	f9e5                	bnez	a1,6dc <vprintf+0x16c>
        s = va_arg(ap, char*);
 6ee:	8b4e                	mv	s6,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bdf9                	j	5d0 <vprintf+0x60>
          s = "(null)";
 6f4:	00000917          	auipc	s2,0x0
 6f8:	27c90913          	addi	s2,s2,636 # 970 <malloc+0x136>
        while(*s != 0){
 6fc:	02800593          	li	a1,40
 700:	bff1                	j	6dc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 702:	008b0913          	addi	s2,s6,8
 706:	000b4583          	lbu	a1,0(s6)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	d98080e7          	jalr	-616(ra) # 4a4 <putc>
 714:	8b4a                	mv	s6,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bd65                	j	5d0 <vprintf+0x60>
        putc(fd, c);
 71a:	85d2                	mv	a1,s4
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	d86080e7          	jalr	-634(ra) # 4a4 <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	b565                	j	5d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 72a:	8b4e                	mv	s6,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b54d                	j	5d0 <vprintf+0x60>
    }
  }
}
 730:	70e6                	ld	ra,120(sp)
 732:	7446                	ld	s0,112(sp)
 734:	74a6                	ld	s1,104(sp)
 736:	7906                	ld	s2,96(sp)
 738:	69e6                	ld	s3,88(sp)
 73a:	6a46                	ld	s4,80(sp)
 73c:	6aa6                	ld	s5,72(sp)
 73e:	6b06                	ld	s6,64(sp)
 740:	7be2                	ld	s7,56(sp)
 742:	7c42                	ld	s8,48(sp)
 744:	7ca2                	ld	s9,40(sp)
 746:	7d02                	ld	s10,32(sp)
 748:	6de2                	ld	s11,24(sp)
 74a:	6109                	addi	sp,sp,128
 74c:	8082                	ret

000000000000074e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74e:	715d                	addi	sp,sp,-80
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e010                	sd	a2,0(s0)
 758:	e414                	sd	a3,8(s0)
 75a:	e818                	sd	a4,16(s0)
 75c:	ec1c                	sd	a5,24(s0)
 75e:	03043023          	sd	a6,32(s0)
 762:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76a:	8622                	mv	a2,s0
 76c:	00000097          	auipc	ra,0x0
 770:	e04080e7          	jalr	-508(ra) # 570 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void
printf(const char *fmt, ...)
{
 77c:	711d                	addi	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	addi	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	00000097          	auipc	ra,0x0
 7a6:	dce080e7          	jalr	-562(ra) # 570 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00000797          	auipc	a5,0x0
 7c0:	1d47b783          	ld	a5,468(a5) # 990 <freep>
 7c4:	a805                	j	7f4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9db9                	addw	a1,a1,a4
 7ca:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6318                	ld	a4,0(a4)
 7d2:	fee53823          	sd	a4,-16(a0)
 7d6:	a091                	j	81a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d8:	ff852703          	lw	a4,-8(a0)
 7dc:	9e39                	addw	a2,a2,a4
 7de:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7e0:	ff053703          	ld	a4,-16(a0)
 7e4:	e398                	sd	a4,0(a5)
 7e6:	a099                	j	82c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e7e463          	bltu	a5,a4,7f2 <free+0x40>
 7ee:	00e6ea63          	bltu	a3,a4,802 <free+0x50>
{
 7f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fed7fae3          	bgeu	a5,a3,7e8 <free+0x36>
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e6e463          	bltu	a3,a4,802 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	fee7eae3          	bltu	a5,a4,7f2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 802:	ff852583          	lw	a1,-8(a0)
 806:	6390                	ld	a2,0(a5)
 808:	02059713          	slli	a4,a1,0x20
 80c:	9301                	srli	a4,a4,0x20
 80e:	0712                	slli	a4,a4,0x4
 810:	9736                	add	a4,a4,a3
 812:	fae60ae3          	beq	a2,a4,7c6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 816:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81a:	4790                	lw	a2,8(a5)
 81c:	02061713          	slli	a4,a2,0x20
 820:	9301                	srli	a4,a4,0x20
 822:	0712                	slli	a4,a4,0x4
 824:	973e                	add	a4,a4,a5
 826:	fae689e3          	beq	a3,a4,7d8 <free+0x26>
  } else
    p->s.ptr = bp;
 82a:	e394                	sd	a3,0(a5)
  freep = p;
 82c:	00000717          	auipc	a4,0x0
 830:	16f73223          	sd	a5,356(a4) # 990 <freep>
}
 834:	6422                	ld	s0,8(sp)
 836:	0141                	addi	sp,sp,16
 838:	8082                	ret

000000000000083a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83a:	7139                	addi	sp,sp,-64
 83c:	fc06                	sd	ra,56(sp)
 83e:	f822                	sd	s0,48(sp)
 840:	f426                	sd	s1,40(sp)
 842:	f04a                	sd	s2,32(sp)
 844:	ec4e                	sd	s3,24(sp)
 846:	e852                	sd	s4,16(sp)
 848:	e456                	sd	s5,8(sp)
 84a:	e05a                	sd	s6,0(sp)
 84c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	02051493          	slli	s1,a0,0x20
 852:	9081                	srli	s1,s1,0x20
 854:	04bd                	addi	s1,s1,15
 856:	8091                	srli	s1,s1,0x4
 858:	0014899b          	addiw	s3,s1,1
 85c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 85e:	00000517          	auipc	a0,0x0
 862:	13253503          	ld	a0,306(a0) # 990 <freep>
 866:	c515                	beqz	a0,892 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	02977f63          	bgeu	a4,s1,8aa <malloc+0x70>
 870:	8a4e                	mv	s4,s3
 872:	0009871b          	sext.w	a4,s3
 876:	6685                	lui	a3,0x1
 878:	00d77363          	bgeu	a4,a3,87e <malloc+0x44>
 87c:	6a05                	lui	s4,0x1
 87e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 882:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 886:	00000917          	auipc	s2,0x0
 88a:	10a90913          	addi	s2,s2,266 # 990 <freep>
  if(p == (char*)-1)
 88e:	5afd                	li	s5,-1
 890:	a88d                	j	902 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 892:	00000797          	auipc	a5,0x0
 896:	10678793          	addi	a5,a5,262 # 998 <base>
 89a:	00000717          	auipc	a4,0x0
 89e:	0ef73b23          	sd	a5,246(a4) # 990 <freep>
 8a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a8:	b7e1                	j	870 <malloc+0x36>
      if(p->s.size == nunits)
 8aa:	02e48b63          	beq	s1,a4,8e0 <malloc+0xa6>
        p->s.size -= nunits;
 8ae:	4137073b          	subw	a4,a4,s3
 8b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b4:	1702                	slli	a4,a4,0x20
 8b6:	9301                	srli	a4,a4,0x20
 8b8:	0712                	slli	a4,a4,0x4
 8ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c0:	00000717          	auipc	a4,0x0
 8c4:	0ca73823          	sd	a0,208(a4) # 990 <freep>
      return (void*)(p + 1);
 8c8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8cc:	70e2                	ld	ra,56(sp)
 8ce:	7442                	ld	s0,48(sp)
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	7902                	ld	s2,32(sp)
 8d4:	69e2                	ld	s3,24(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	6121                	addi	sp,sp,64
 8de:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	e118                	sd	a4,0(a0)
 8e4:	bff1                	j	8c0 <malloc+0x86>
  hp->s.size = nu;
 8e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ea:	0541                	addi	a0,a0,16
 8ec:	00000097          	auipc	ra,0x0
 8f0:	ec6080e7          	jalr	-314(ra) # 7b2 <free>
  return freep;
 8f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f8:	d971                	beqz	a0,8cc <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	fa9776e3          	bgeu	a4,s1,8aa <malloc+0x70>
    if(p == freep)
 902:	00093703          	ld	a4,0(s2)
 906:	853e                	mv	a0,a5
 908:	fef719e3          	bne	a4,a5,8fa <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 90c:	8552                	mv	a0,s4
 90e:	00000097          	auipc	ra,0x0
 912:	b6e080e7          	jalr	-1170(ra) # 47c <sbrk>
  if(p == (char*)-1)
 916:	fd5518e3          	bne	a0,s5,8e6 <malloc+0xac>
        return 0;
 91a:	4501                	li	a0,0
 91c:	bf45                	j	8cc <malloc+0x92>
