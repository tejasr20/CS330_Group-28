
user/_testpspinfo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/procstat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	0100                	addi	s0,sp,128
  int m, n, x;
  struct procstat pstat;

  if (argc != 3) {
   e:	478d                	li	a5,3
  10:	02f50063          	beq	a0,a5,30 <main+0x30>
     fprintf(2, "syntax: testpspinfo m n\nAborting...\n");
  14:	00001597          	auipc	a1,0x1
  18:	aa458593          	addi	a1,a1,-1372 # ab8 <malloc+0xea>
  1c:	4509                	li	a0,2
  1e:	00001097          	auipc	ra,0x1
  22:	8c4080e7          	jalr	-1852(ra) # 8e2 <fprintf>
     exit(0);
  26:	4501                	li	a0,0
  28:	00000097          	auipc	ra,0x0
  2c:	4c6080e7          	jalr	1222(ra) # 4ee <exit>
  30:	84ae                	mv	s1,a1
  }

  m = atoi(argv[1]);
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	3ba080e7          	jalr	954(ra) # 3ee <atoi>
  3c:	892a                	mv	s2,a0
  if (m <= 0) {
  3e:	02a05b63          	blez	a0,74 <main+0x74>
     fprintf(2, "Invalid input\nAborting...\n");
     exit(0);
  }
  n = atoi(argv[2]);
  42:	6888                	ld	a0,16(s1)
  44:	00000097          	auipc	ra,0x0
  48:	3aa080e7          	jalr	938(ra) # 3ee <atoi>
  4c:	84aa                	mv	s1,a0
  if ((n != 0) && (n != 1)) {
  4e:	0005071b          	sext.w	a4,a0
  52:	4785                	li	a5,1
  54:	02e7fe63          	bgeu	a5,a4,90 <main+0x90>
     fprintf(2, "Invalid input\nAborting...\n");
  58:	00001597          	auipc	a1,0x1
  5c:	a8858593          	addi	a1,a1,-1400 # ae0 <malloc+0x112>
  60:	4509                	li	a0,2
  62:	00001097          	auipc	ra,0x1
  66:	880080e7          	jalr	-1920(ra) # 8e2 <fprintf>
     exit(0);
  6a:	4501                	li	a0,0
  6c:	00000097          	auipc	ra,0x0
  70:	482080e7          	jalr	1154(ra) # 4ee <exit>
     fprintf(2, "Invalid input\nAborting...\n");
  74:	00001597          	auipc	a1,0x1
  78:	a6c58593          	addi	a1,a1,-1428 # ae0 <malloc+0x112>
  7c:	4509                	li	a0,2
  7e:	00001097          	auipc	ra,0x1
  82:	864080e7          	jalr	-1948(ra) # 8e2 <fprintf>
     exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	466080e7          	jalr	1126(ra) # 4ee <exit>
  }

  x = fork();
  90:	00000097          	auipc	ra,0x0
  94:	456080e7          	jalr	1110(ra) # 4e6 <fork>
  98:	89aa                	mv	s3,a0
  if (x < 0) {
  9a:	0e054e63          	bltz	a0,196 <main+0x196>
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  9e:	14a05463          	blez	a0,1e6 <main+0x1e6>
     if (n) sleep(m);
  a2:	10049863          	bnez	s1,1b2 <main+0x1b2>
     fprintf(1, "%d: Parent.\n", getpid());
  a6:	00000097          	auipc	ra,0x0
  aa:	4c8080e7          	jalr	1224(ra) # 56e <getpid>
  ae:	862a                	mv	a2,a0
  b0:	00001597          	auipc	a1,0x1
  b4:	a7058593          	addi	a1,a1,-1424 # b20 <malloc+0x152>
  b8:	4505                	li	a0,1
  ba:	00001097          	auipc	ra,0x1
  be:	828080e7          	jalr	-2008(ra) # 8e2 <fprintf>
     ps();
  c2:	00000097          	auipc	ra,0x0
  c6:	4f4080e7          	jalr	1268(ra) # 5b6 <ps>
     fprintf(1, "\n");
  ca:	00001597          	auipc	a1,0x1
  ce:	a7658593          	addi	a1,a1,-1418 # b40 <malloc+0x172>
  d2:	4505                	li	a0,1
  d4:	00001097          	auipc	ra,0x1
  d8:	80e080e7          	jalr	-2034(ra) # 8e2 <fprintf>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
  dc:	f9840593          	addi	a1,s0,-104
  e0:	557d                	li	a0,-1
  e2:	00000097          	auipc	ra,0x0
  e6:	4dc080e7          	jalr	1244(ra) # 5be <pinfo>
  ea:	0c054a63          	bltz	a0,1be <main+0x1be>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
  ee:	fc843783          	ld	a5,-56(s0)
  f2:	e43e                	sd	a5,8(sp)
  f4:	fc042783          	lw	a5,-64(s0)
  f8:	e03e                	sd	a5,0(sp)
  fa:	fbc42883          	lw	a7,-68(s0)
  fe:	fb842803          	lw	a6,-72(s0)
 102:	fa840793          	addi	a5,s0,-88
 106:	fa040713          	addi	a4,s0,-96
 10a:	f9c42683          	lw	a3,-100(s0)
 10e:	f9842603          	lw	a2,-104(s0)
 112:	00001597          	auipc	a1,0x1
 116:	a3658593          	addi	a1,a1,-1482 # b48 <malloc+0x17a>
 11a:	4505                	li	a0,1
 11c:	00000097          	auipc	ra,0x0
 120:	7c6080e7          	jalr	1990(ra) # 8e2 <fprintf>
     if (pinfo(x, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 124:	f9840593          	addi	a1,s0,-104
 128:	854e                	mv	a0,s3
 12a:	00000097          	auipc	ra,0x0
 12e:	494080e7          	jalr	1172(ra) # 5be <pinfo>
 132:	0a054063          	bltz	a0,1d2 <main+0x1d2>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
 136:	fc843783          	ld	a5,-56(s0)
 13a:	e43e                	sd	a5,8(sp)
 13c:	fc042783          	lw	a5,-64(s0)
 140:	e03e                	sd	a5,0(sp)
 142:	fbc42883          	lw	a7,-68(s0)
 146:	fb842803          	lw	a6,-72(s0)
 14a:	fa840793          	addi	a5,s0,-88
 14e:	fa040713          	addi	a4,s0,-96
 152:	f9c42683          	lw	a3,-100(s0)
 156:	f9842603          	lw	a2,-104(s0)
 15a:	00001597          	auipc	a1,0x1
 15e:	a3e58593          	addi	a1,a1,-1474 # b98 <malloc+0x1ca>
 162:	4505                	li	a0,1
 164:	00000097          	auipc	ra,0x0
 168:	77e080e7          	jalr	1918(ra) # 8e2 <fprintf>
     fprintf(1, "Return value of waitpid=%d\n", waitpid(x, 0));
 16c:	4581                	li	a1,0
 16e:	854e                	mv	a0,s3
 170:	00000097          	auipc	ra,0x0
 174:	43e080e7          	jalr	1086(ra) # 5ae <waitpid>
 178:	862a                	mv	a2,a0
 17a:	00001597          	auipc	a1,0x1
 17e:	a6e58593          	addi	a1,a1,-1426 # be8 <malloc+0x21a>
 182:	4505                	li	a0,1
 184:	00000097          	auipc	ra,0x0
 188:	75e080e7          	jalr	1886(ra) # 8e2 <fprintf>
     sleep(1);
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
  }

  exit(0);
 18c:	4501                	li	a0,0
 18e:	00000097          	auipc	ra,0x0
 192:	360080e7          	jalr	864(ra) # 4ee <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
 196:	00001597          	auipc	a1,0x1
 19a:	96a58593          	addi	a1,a1,-1686 # b00 <malloc+0x132>
 19e:	4509                	li	a0,2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	742080e7          	jalr	1858(ra) # 8e2 <fprintf>
     exit(0);
 1a8:	4501                	li	a0,0
 1aa:	00000097          	auipc	ra,0x0
 1ae:	344080e7          	jalr	836(ra) # 4ee <exit>
     if (n) sleep(m);
 1b2:	854a                	mv	a0,s2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	3ca080e7          	jalr	970(ra) # 57e <sleep>
 1bc:	b5ed                	j	a6 <main+0xa6>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 1be:	00001597          	auipc	a1,0x1
 1c2:	97258593          	addi	a1,a1,-1678 # b30 <malloc+0x162>
 1c6:	4505                	li	a0,1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	71a080e7          	jalr	1818(ra) # 8e2 <fprintf>
 1d0:	bf91                	j	124 <main+0x124>
     if (pinfo(x, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 1d2:	00001597          	auipc	a1,0x1
 1d6:	95e58593          	addi	a1,a1,-1698 # b30 <malloc+0x162>
 1da:	4505                	li	a0,1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	706080e7          	jalr	1798(ra) # 8e2 <fprintf>
 1e4:	b761                	j	16c <main+0x16c>
     if (!n) sleep(m);
 1e6:	c8ad                	beqz	s1,258 <main+0x258>
     fprintf(1, "%d: Child.\n", getpid());
 1e8:	00000097          	auipc	ra,0x0
 1ec:	386080e7          	jalr	902(ra) # 56e <getpid>
 1f0:	862a                	mv	a2,a0
 1f2:	00001597          	auipc	a1,0x1
 1f6:	a1658593          	addi	a1,a1,-1514 # c08 <malloc+0x23a>
 1fa:	4505                	li	a0,1
 1fc:	00000097          	auipc	ra,0x0
 200:	6e6080e7          	jalr	1766(ra) # 8e2 <fprintf>
     sleep(1);
 204:	4505                	li	a0,1
 206:	00000097          	auipc	ra,0x0
 20a:	378080e7          	jalr	888(ra) # 57e <sleep>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 20e:	f9840593          	addi	a1,s0,-104
 212:	557d                	li	a0,-1
 214:	00000097          	auipc	ra,0x0
 218:	3aa080e7          	jalr	938(ra) # 5be <pinfo>
 21c:	04054463          	bltz	a0,264 <main+0x264>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
 220:	fc843783          	ld	a5,-56(s0)
 224:	e43e                	sd	a5,8(sp)
 226:	fc042783          	lw	a5,-64(s0)
 22a:	e03e                	sd	a5,0(sp)
 22c:	fbc42883          	lw	a7,-68(s0)
 230:	fb842803          	lw	a6,-72(s0)
 234:	fa840793          	addi	a5,s0,-88
 238:	fa040713          	addi	a4,s0,-96
 23c:	f9c42683          	lw	a3,-100(s0)
 240:	f9842603          	lw	a2,-104(s0)
 244:	00001597          	auipc	a1,0x1
 248:	95458593          	addi	a1,a1,-1708 # b98 <malloc+0x1ca>
 24c:	4505                	li	a0,1
 24e:	00000097          	auipc	ra,0x0
 252:	694080e7          	jalr	1684(ra) # 8e2 <fprintf>
 256:	bf1d                	j	18c <main+0x18c>
     if (!n) sleep(m);
 258:	854a                	mv	a0,s2
 25a:	00000097          	auipc	ra,0x0
 25e:	324080e7          	jalr	804(ra) # 57e <sleep>
 262:	b759                	j	1e8 <main+0x1e8>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 264:	00001597          	auipc	a1,0x1
 268:	8cc58593          	addi	a1,a1,-1844 # b30 <malloc+0x162>
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	674080e7          	jalr	1652(ra) # 8e2 <fprintf>
 276:	bf19                	j	18c <main+0x18c>

0000000000000278 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27e:	87aa                	mv	a5,a0
 280:	0585                	addi	a1,a1,1
 282:	0785                	addi	a5,a5,1
 284:	fff5c703          	lbu	a4,-1(a1)
 288:	fee78fa3          	sb	a4,-1(a5)
 28c:	fb75                	bnez	a4,280 <strcpy+0x8>
    ;
  return os;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cb91                	beqz	a5,2b2 <strcmp+0x1e>
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00f71763          	bne	a4,a5,2b2 <strcmp+0x1e>
    p++, q++;
 2a8:	0505                	addi	a0,a0,1
 2aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	fbe5                	bnez	a5,2a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b2:	0005c503          	lbu	a0,0(a1)
}
 2b6:	40a7853b          	subw	a0,a5,a0
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cf91                	beqz	a5,2e6 <strlen+0x26>
 2cc:	0505                	addi	a0,a0,1
 2ce:	87aa                	mv	a5,a0
 2d0:	4685                	li	a3,1
 2d2:	9e89                	subw	a3,a3,a0
 2d4:	00f6853b          	addw	a0,a3,a5
 2d8:	0785                	addi	a5,a5,1
 2da:	fff7c703          	lbu	a4,-1(a5)
 2de:	fb7d                	bnez	a4,2d4 <strlen+0x14>
    ;
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  for(n = 0; s[n]; n++)
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <strlen+0x20>

00000000000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f0:	ce09                	beqz	a2,30a <memset+0x20>
 2f2:	87aa                	mv	a5,a0
 2f4:	fff6071b          	addiw	a4,a2,-1
 2f8:	1702                	slli	a4,a4,0x20
 2fa:	9301                	srli	a4,a4,0x20
 2fc:	0705                	addi	a4,a4,1
 2fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
 300:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x16>
  }
  return dst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cb99                	beqz	a5,330 <strchr+0x20>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1a>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xc>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strchr+0x1a>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 352:	4aa9                	li	s5,10
 354:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	2485                	addiw	s1,s1,1
 35a:	0344d863          	bge	s1,s4,38a <gets+0x56>
    cc = read(0, &c, 1);
 35e:	4605                	li	a2,1
 360:	faf40593          	addi	a1,s0,-81
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	1a0080e7          	jalr	416(ra) # 506 <read>
    if(cc < 1)
 36e:	00a05e63          	blez	a0,38a <gets+0x56>
    buf[i++] = c;
 372:	faf44783          	lbu	a5,-81(s0)
 376:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37a:	01578763          	beq	a5,s5,388 <gets+0x54>
 37e:	0905                	addi	s2,s2,1
 380:	fd679be3          	bne	a5,s6,356 <gets+0x22>
  for(i=0; i+1 < max; ){
 384:	89a6                	mv	s3,s1
 386:	a011                	j	38a <gets+0x56>
 388:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 38a:	99de                	add	s3,s3,s7
 38c:	00098023          	sb	zero,0(s3)
  return buf;
}
 390:	855e                	mv	a0,s7
 392:	60e6                	ld	ra,88(sp)
 394:	6446                	ld	s0,80(sp)
 396:	64a6                	ld	s1,72(sp)
 398:	6906                	ld	s2,64(sp)
 39a:	79e2                	ld	s3,56(sp)
 39c:	7a42                	ld	s4,48(sp)
 39e:	7aa2                	ld	s5,40(sp)
 3a0:	7b02                	ld	s6,32(sp)
 3a2:	6be2                	ld	s7,24(sp)
 3a4:	6125                	addi	sp,sp,96
 3a6:	8082                	ret

00000000000003a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	e426                	sd	s1,8(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	4581                	li	a1,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	176080e7          	jalr	374(ra) # 52e <open>
  if(fd < 0)
 3c0:	02054563          	bltz	a0,3ea <stat+0x42>
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	00000097          	auipc	ra,0x0
 3cc:	17e080e7          	jalr	382(ra) # 546 <fstat>
 3d0:	892a                	mv	s2,a0
  close(fd);
 3d2:	8526                	mv	a0,s1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	142080e7          	jalr	322(ra) # 516 <close>
  return r;
}
 3dc:	854a                	mv	a0,s2
 3de:	60e2                	ld	ra,24(sp)
 3e0:	6442                	ld	s0,16(sp)
 3e2:	64a2                	ld	s1,8(sp)
 3e4:	6902                	ld	s2,0(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret
    return -1;
 3ea:	597d                	li	s2,-1
 3ec:	bfc5                	j	3dc <stat+0x34>

00000000000003ee <atoi>:

int
atoi(const char *s)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f4:	00054603          	lbu	a2,0(a0)
 3f8:	fd06079b          	addiw	a5,a2,-48
 3fc:	0ff7f793          	andi	a5,a5,255
 400:	4725                	li	a4,9
 402:	02f76963          	bltu	a4,a5,434 <atoi+0x46>
 406:	86aa                	mv	a3,a0
  n = 0;
 408:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 40a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 40c:	0685                	addi	a3,a3,1
 40e:	0025179b          	slliw	a5,a0,0x2
 412:	9fa9                	addw	a5,a5,a0
 414:	0017979b          	slliw	a5,a5,0x1
 418:	9fb1                	addw	a5,a5,a2
 41a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 41e:	0006c603          	lbu	a2,0(a3)
 422:	fd06071b          	addiw	a4,a2,-48
 426:	0ff77713          	andi	a4,a4,255
 42a:	fee5f1e3          	bgeu	a1,a4,40c <atoi+0x1e>
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
  n = 0;
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <atoi+0x40>

0000000000000438 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43e:	02b57663          	bgeu	a0,a1,46a <memmove+0x32>
    while(n-- > 0)
 442:	02c05163          	blez	a2,464 <memmove+0x2c>
 446:	fff6079b          	addiw	a5,a2,-1
 44a:	1782                	slli	a5,a5,0x20
 44c:	9381                	srli	a5,a5,0x20
 44e:	0785                	addi	a5,a5,1
 450:	97aa                	add	a5,a5,a0
  dst = vdst;
 452:	872a                	mv	a4,a0
      *dst++ = *src++;
 454:	0585                	addi	a1,a1,1
 456:	0705                	addi	a4,a4,1
 458:	fff5c683          	lbu	a3,-1(a1)
 45c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 460:	fee79ae3          	bne	a5,a4,454 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 470:	fec05ae3          	blez	a2,464 <memmove+0x2c>
 474:	fff6079b          	addiw	a5,a2,-1
 478:	1782                	slli	a5,a5,0x20
 47a:	9381                	srli	a5,a5,0x20
 47c:	fff7c793          	not	a5,a5
 480:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 482:	15fd                	addi	a1,a1,-1
 484:	177d                	addi	a4,a4,-1
 486:	0005c683          	lbu	a3,0(a1)
 48a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48e:	fee79ae3          	bne	a5,a4,482 <memmove+0x4a>
 492:	bfc9                	j	464 <memmove+0x2c>

0000000000000494 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e422                	sd	s0,8(sp)
 498:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 49a:	ca05                	beqz	a2,4ca <memcmp+0x36>
 49c:	fff6069b          	addiw	a3,a2,-1
 4a0:	1682                	slli	a3,a3,0x20
 4a2:	9281                	srli	a3,a3,0x20
 4a4:	0685                	addi	a3,a3,1
 4a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4a8:	00054783          	lbu	a5,0(a0)
 4ac:	0005c703          	lbu	a4,0(a1)
 4b0:	00e79863          	bne	a5,a4,4c0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4b4:	0505                	addi	a0,a0,1
    p2++;
 4b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b8:	fed518e3          	bne	a0,a3,4a8 <memcmp+0x14>
  }
  return 0;
 4bc:	4501                	li	a0,0
 4be:	a019                	j	4c4 <memcmp+0x30>
      return *p1 - *p2;
 4c0:	40e7853b          	subw	a0,a5,a4
}
 4c4:	6422                	ld	s0,8(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret
  return 0;
 4ca:	4501                	li	a0,0
 4cc:	bfe5                	j	4c4 <memcmp+0x30>

00000000000004ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e406                	sd	ra,8(sp)
 4d2:	e022                	sd	s0,0(sp)
 4d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d6:	00000097          	auipc	ra,0x0
 4da:	f62080e7          	jalr	-158(ra) # 438 <memmove>
}
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 58e:	48d9                	li	a7,22
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <yield>:
.global yield
yield:
 li a7, SYS_yield
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 59e:	48e1                	li	a7,24
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 5a6:	48e5                	li	a7,25
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 5ae:	48e9                	li	a7,26
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5b6:	48ed                	li	a7,27
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 5be:	48f1                	li	a7,28
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 5c6:	48f5                	li	a7,29
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 5ce:	48f9                	li	a7,30
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 5d6:	48fd                	li	a7,31
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 5de:	02000893          	li	a7,32
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 5e8:	02100893          	li	a7,33
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 5f2:	02200893          	li	a7,34
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 5fc:	02300893          	li	a7,35
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 606:	02500893          	li	a7,37
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 610:	02400893          	li	a7,36
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 61a:	02600893          	li	a7,38
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 624:	02800893          	li	a7,40
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 62e:	02700893          	li	a7,39
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 638:	1101                	addi	sp,sp,-32
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 644:	4605                	li	a2,1
 646:	fef40593          	addi	a1,s0,-17
 64a:	00000097          	auipc	ra,0x0
 64e:	ec4080e7          	jalr	-316(ra) # 50e <write>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret

000000000000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	7139                	addi	sp,sp,-64
 65c:	fc06                	sd	ra,56(sp)
 65e:	f822                	sd	s0,48(sp)
 660:	f426                	sd	s1,40(sp)
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	0080                	addi	s0,sp,64
 668:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x16>
 66c:	0805c863          	bltz	a1,6fc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 670:	2581                	sext.w	a1,a1
  neg = 0;
 672:	4881                	li	a7,0
 674:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 678:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67a:	2601                	sext.w	a2,a2
 67c:	00000517          	auipc	a0,0x0
 680:	5a450513          	addi	a0,a0,1444 # c20 <digits>
 684:	883a                	mv	a6,a4
 686:	2705                	addiw	a4,a4,1
 688:	02c5f7bb          	remuw	a5,a1,a2
 68c:	1782                	slli	a5,a5,0x20
 68e:	9381                	srli	a5,a5,0x20
 690:	97aa                	add	a5,a5,a0
 692:	0007c783          	lbu	a5,0(a5)
 696:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69a:	0005879b          	sext.w	a5,a1
 69e:	02c5d5bb          	divuw	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fec7f0e3          	bgeu	a5,a2,684 <printint+0x2a>
  if(neg)
 6a8:	00088b63          	beqz	a7,6be <printint+0x64>
    buf[i++] = '-';
 6ac:	fd040793          	addi	a5,s0,-48
 6b0:	973e                	add	a4,a4,a5
 6b2:	02d00793          	li	a5,45
 6b6:	fef70823          	sb	a5,-16(a4)
 6ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6be:	02e05863          	blez	a4,6ee <printint+0x94>
 6c2:	fc040793          	addi	a5,s0,-64
 6c6:	00e78933          	add	s2,a5,a4
 6ca:	fff78993          	addi	s3,a5,-1
 6ce:	99ba                	add	s3,s3,a4
 6d0:	377d                	addiw	a4,a4,-1
 6d2:	1702                	slli	a4,a4,0x20
 6d4:	9301                	srli	a4,a4,0x20
 6d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6da:	fff94583          	lbu	a1,-1(s2)
 6de:	8526                	mv	a0,s1
 6e0:	00000097          	auipc	ra,0x0
 6e4:	f58080e7          	jalr	-168(ra) # 638 <putc>
  while(--i >= 0)
 6e8:	197d                	addi	s2,s2,-1
 6ea:	ff3918e3          	bne	s2,s3,6da <printint+0x80>
}
 6ee:	70e2                	ld	ra,56(sp)
 6f0:	7442                	ld	s0,48(sp)
 6f2:	74a2                	ld	s1,40(sp)
 6f4:	7902                	ld	s2,32(sp)
 6f6:	69e2                	ld	s3,24(sp)
 6f8:	6121                	addi	sp,sp,64
 6fa:	8082                	ret
    x = -xx;
 6fc:	40b005bb          	negw	a1,a1
    neg = 1;
 700:	4885                	li	a7,1
    x = -xx;
 702:	bf8d                	j	674 <printint+0x1a>

0000000000000704 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 704:	7119                	addi	sp,sp,-128
 706:	fc86                	sd	ra,120(sp)
 708:	f8a2                	sd	s0,112(sp)
 70a:	f4a6                	sd	s1,104(sp)
 70c:	f0ca                	sd	s2,96(sp)
 70e:	ecce                	sd	s3,88(sp)
 710:	e8d2                	sd	s4,80(sp)
 712:	e4d6                	sd	s5,72(sp)
 714:	e0da                	sd	s6,64(sp)
 716:	fc5e                	sd	s7,56(sp)
 718:	f862                	sd	s8,48(sp)
 71a:	f466                	sd	s9,40(sp)
 71c:	f06a                	sd	s10,32(sp)
 71e:	ec6e                	sd	s11,24(sp)
 720:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 722:	0005c903          	lbu	s2,0(a1)
 726:	18090f63          	beqz	s2,8c4 <vprintf+0x1c0>
 72a:	8aaa                	mv	s5,a0
 72c:	8b32                	mv	s6,a2
 72e:	00158493          	addi	s1,a1,1
  state = 0;
 732:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 734:	02500a13          	li	s4,37
      if(c == 'd'){
 738:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 73c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 740:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 744:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	00000b97          	auipc	s7,0x0
 74c:	4d8b8b93          	addi	s7,s7,1240 # c20 <digits>
 750:	a839                	j	76e <vprintf+0x6a>
        putc(fd, c);
 752:	85ca                	mv	a1,s2
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	ee2080e7          	jalr	-286(ra) # 638 <putc>
 75e:	a019                	j	764 <vprintf+0x60>
    } else if(state == '%'){
 760:	01498f63          	beq	s3,s4,77e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 764:	0485                	addi	s1,s1,1
 766:	fff4c903          	lbu	s2,-1(s1)
 76a:	14090d63          	beqz	s2,8c4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 76e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 772:	fe0997e3          	bnez	s3,760 <vprintf+0x5c>
      if(c == '%'){
 776:	fd479ee3          	bne	a5,s4,752 <vprintf+0x4e>
        state = '%';
 77a:	89be                	mv	s3,a5
 77c:	b7e5                	j	764 <vprintf+0x60>
      if(c == 'd'){
 77e:	05878063          	beq	a5,s8,7be <vprintf+0xba>
      } else if(c == 'l') {
 782:	05978c63          	beq	a5,s9,7da <vprintf+0xd6>
      } else if(c == 'x') {
 786:	07a78863          	beq	a5,s10,7f6 <vprintf+0xf2>
      } else if(c == 'p') {
 78a:	09b78463          	beq	a5,s11,812 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 78e:	07300713          	li	a4,115
 792:	0ce78663          	beq	a5,a4,85e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 796:	06300713          	li	a4,99
 79a:	0ee78e63          	beq	a5,a4,896 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 79e:	11478863          	beq	a5,s4,8ae <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e92080e7          	jalr	-366(ra) # 638 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e86080e7          	jalr	-378(ra) # 638 <putc>
      }
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b765                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7be:	008b0913          	addi	s2,s6,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000b2583          	lw	a1,0(s6)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e8e080e7          	jalr	-370(ra) # 65a <printint>
 7d4:	8b4a                	mv	s6,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b771                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	008b0913          	addi	s2,s6,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000b2583          	lw	a1,0(s6)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e72080e7          	jalr	-398(ra) # 65a <printint>
 7f0:	8b4a                	mv	s6,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bf85                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000b2583          	lw	a1,0(s6)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e56080e7          	jalr	-426(ra) # 65a <printint>
 80c:	8b4a                	mv	s6,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	bf91                	j	764 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 812:	008b0793          	addi	a5,s6,8
 816:	f8f43423          	sd	a5,-120(s0)
 81a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 81e:	03000593          	li	a1,48
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e14080e7          	jalr	-492(ra) # 638 <putc>
  putc(fd, 'x');
 82c:	85ea                	mv	a1,s10
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	e08080e7          	jalr	-504(ra) # 638 <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	03c9d793          	srli	a5,s3,0x3c
 83e:	97de                	add	a5,a5,s7
 840:	0007c583          	lbu	a1,0(a5)
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	df2080e7          	jalr	-526(ra) # 638 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84e:	0992                	slli	s3,s3,0x4
 850:	397d                	addiw	s2,s2,-1
 852:	fe0914e3          	bnez	s2,83a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 856:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b721                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 85e:	008b0993          	addi	s3,s6,8
 862:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 866:	02090163          	beqz	s2,888 <vprintf+0x184>
        while(*s != 0){
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c9a1                	beqz	a1,8be <vprintf+0x1ba>
          putc(fd, *s);
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	dc6080e7          	jalr	-570(ra) # 638 <putc>
          s++;
 87a:	0905                	addi	s2,s2,1
        while(*s != 0){
 87c:	00094583          	lbu	a1,0(s2)
 880:	f9e5                	bnez	a1,870 <vprintf+0x16c>
        s = va_arg(ap, char*);
 882:	8b4e                	mv	s6,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	bdf9                	j	764 <vprintf+0x60>
          s = "(null)";
 888:	00000917          	auipc	s2,0x0
 88c:	39090913          	addi	s2,s2,912 # c18 <malloc+0x24a>
        while(*s != 0){
 890:	02800593          	li	a1,40
 894:	bff1                	j	870 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 896:	008b0913          	addi	s2,s6,8
 89a:	000b4583          	lbu	a1,0(s6)
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d98080e7          	jalr	-616(ra) # 638 <putc>
 8a8:	8b4a                	mv	s6,s2
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd65                	j	764 <vprintf+0x60>
        putc(fd, c);
 8ae:	85d2                	mv	a1,s4
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d86080e7          	jalr	-634(ra) # 638 <putc>
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b565                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 8be:	8b4e                	mv	s6,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b54d                	j	764 <vprintf+0x60>
    }
  }
}
 8c4:	70e6                	ld	ra,120(sp)
 8c6:	7446                	ld	s0,112(sp)
 8c8:	74a6                	ld	s1,104(sp)
 8ca:	7906                	ld	s2,96(sp)
 8cc:	69e6                	ld	s3,88(sp)
 8ce:	6a46                	ld	s4,80(sp)
 8d0:	6aa6                	ld	s5,72(sp)
 8d2:	6b06                	ld	s6,64(sp)
 8d4:	7be2                	ld	s7,56(sp)
 8d6:	7c42                	ld	s8,48(sp)
 8d8:	7ca2                	ld	s9,40(sp)
 8da:	7d02                	ld	s10,32(sp)
 8dc:	6de2                	ld	s11,24(sp)
 8de:	6109                	addi	sp,sp,128
 8e0:	8082                	ret

00000000000008e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e2:	715d                	addi	sp,sp,-80
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	1000                	addi	s0,sp,32
 8ea:	e010                	sd	a2,0(s0)
 8ec:	e414                	sd	a3,8(s0)
 8ee:	e818                	sd	a4,16(s0)
 8f0:	ec1c                	sd	a5,24(s0)
 8f2:	03043023          	sd	a6,32(s0)
 8f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fe:	8622                	mv	a2,s0
 900:	00000097          	auipc	ra,0x0
 904:	e04080e7          	jalr	-508(ra) # 704 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	00000097          	auipc	ra,0x0
 93a:	dce080e7          	jalr	-562(ra) # 704 <vprintf>
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret

0000000000000946 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 946:	1141                	addi	sp,sp,-16
 948:	e422                	sd	s0,8(sp)
 94a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	00000797          	auipc	a5,0x0
 954:	2e87b783          	ld	a5,744(a5) # c38 <freep>
 958:	a805                	j	988 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95a:	4618                	lw	a4,8(a2)
 95c:	9db9                	addw	a1,a1,a4
 95e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	6398                	ld	a4,0(a5)
 964:	6318                	ld	a4,0(a4)
 966:	fee53823          	sd	a4,-16(a0)
 96a:	a091                	j	9ae <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9e39                	addw	a2,a2,a4
 972:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053703          	ld	a4,-16(a0)
 978:	e398                	sd	a4,0(a5)
 97a:	a099                	j	9c0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x40>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x50>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x36>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059713          	slli	a4,a1,0x20
 9a0:	9301                	srli	a4,a4,0x20
 9a2:	0712                	slli	a4,a4,0x4
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60ae3          	beq	a2,a4,95a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061713          	slli	a4,a2,0x20
 9b4:	9301                	srli	a4,a4,0x20
 9b6:	0712                	slli	a4,a4,0x4
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae689e3          	beq	a3,a4,96c <free+0x26>
  } else
    p->s.ptr = bp;
 9be:	e394                	sd	a3,0(a5)
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	26f73c23          	sd	a5,632(a4) # c38 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	24653503          	ld	a0,582(a0) # c38 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	21e90913          	addi	s2,s2,542 # c38 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a88d                	j	a96 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	21a78793          	addi	a5,a5,538 # c40 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	20f73523          	sd	a5,522(a4) # c38 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48b63          	beq	s1,a4,a74 <malloc+0xa6>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	1702                	slli	a4,a4,0x20
 a4a:	9301                	srli	a4,a4,0x20
 a4c:	0712                	slli	a4,a4,0x4
 a4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a54:	00000717          	auipc	a4,0x0
 a58:	1ea73223          	sd	a0,484(a4) # c38 <freep>
      return (void*)(p + 1);
 a5c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a60:	70e2                	ld	ra,56(sp)
 a62:	7442                	ld	s0,48(sp)
 a64:	74a2                	ld	s1,40(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	e118                	sd	a4,0(a0)
 a78:	bff1                	j	a54 <malloc+0x86>
  hp->s.size = nu;
 a7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7e:	0541                	addi	a0,a0,16
 a80:	00000097          	auipc	ra,0x0
 a84:	ec6080e7          	jalr	-314(ra) # 946 <free>
  return freep;
 a88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8c:	d971                	beqz	a0,a60 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a90:	4798                	lw	a4,8(a5)
 a92:	fa9776e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a96:	00093703          	ld	a4,0(s2)
 a9a:	853e                	mv	a0,a5
 a9c:	fef719e3          	bne	a4,a5,a8e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa0:	8552                	mv	a0,s4
 aa2:	00000097          	auipc	ra,0x0
 aa6:	ad4080e7          	jalr	-1324(ra) # 576 <sbrk>
  if(p == (char*)-1)
 aaa:	fd5518e3          	bne	a0,s5,a7a <malloc+0xac>
        return 0;
 aae:	4501                	li	a0,0
 ab0:	bf45                	j	a60 <malloc+0x92>
