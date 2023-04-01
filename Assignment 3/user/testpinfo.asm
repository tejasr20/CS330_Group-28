
user/_testpinfo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/procstat.h"
#include "user/user.h"

int
main(void)
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	1880                	addi	s0,sp,112
  struct procstat pstat;

  int x = fork();
   a:	00000097          	auipc	ra,0x0
   e:	41e080e7          	jalr	1054(ra) # 428 <fork>
  if (x < 0) {
  12:	0e054563          	bltz	a0,fc <main+0xfc>
  16:	84aa                	mv	s1,a0
     fprintf(2, "Error: cannot fork\nAborting...\n");
     exit(0);
  }
  else if (x > 0) {
  18:	12a05463          	blez	a0,140 <main+0x140>
     sleep(1);
  1c:	4505                	li	a0,1
  1e:	00000097          	auipc	ra,0x0
  22:	4a2080e7          	jalr	1186(ra) # 4c0 <sleep>
     fprintf(1, "%d: Parent.\n", getpid());
  26:	00000097          	auipc	ra,0x0
  2a:	48a080e7          	jalr	1162(ra) # 4b0 <getpid>
  2e:	862a                	mv	a2,a0
  30:	00001597          	auipc	a1,0x1
  34:	9e858593          	addi	a1,a1,-1560 # a18 <malloc+0x108>
  38:	4505                	li	a0,1
  3a:	00000097          	auipc	ra,0x0
  3e:	7ea080e7          	jalr	2026(ra) # 824 <fprintf>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
  42:	fa840593          	addi	a1,s0,-88
  46:	557d                	li	a0,-1
  48:	00000097          	auipc	ra,0x0
  4c:	4b8080e7          	jalr	1208(ra) # 500 <pinfo>
  50:	0c054463          	bltz	a0,118 <main+0x118>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
  54:	fd843783          	ld	a5,-40(s0)
  58:	e43e                	sd	a5,8(sp)
  5a:	fd042783          	lw	a5,-48(s0)
  5e:	e03e                	sd	a5,0(sp)
  60:	fcc42883          	lw	a7,-52(s0)
  64:	fc842803          	lw	a6,-56(s0)
  68:	fb840793          	addi	a5,s0,-72
  6c:	fb040713          	addi	a4,s0,-80
  70:	fac42683          	lw	a3,-84(s0)
  74:	fa842603          	lw	a2,-88(s0)
  78:	00001597          	auipc	a1,0x1
  7c:	9c858593          	addi	a1,a1,-1592 # a40 <malloc+0x130>
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	7a2080e7          	jalr	1954(ra) # 824 <fprintf>
     if (pinfo(x, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
  8a:	fa840593          	addi	a1,s0,-88
  8e:	8526                	mv	a0,s1
  90:	00000097          	auipc	ra,0x0
  94:	470080e7          	jalr	1136(ra) # 500 <pinfo>
  98:	08054a63          	bltz	a0,12c <main+0x12c>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
  9c:	fd843783          	ld	a5,-40(s0)
  a0:	e43e                	sd	a5,8(sp)
  a2:	fd042783          	lw	a5,-48(s0)
  a6:	e03e                	sd	a5,0(sp)
  a8:	fcc42883          	lw	a7,-52(s0)
  ac:	fc842803          	lw	a6,-56(s0)
  b0:	fb840793          	addi	a5,s0,-72
  b4:	fb040713          	addi	a4,s0,-80
  b8:	fac42683          	lw	a3,-84(s0)
  bc:	fa842603          	lw	a2,-88(s0)
  c0:	00001597          	auipc	a1,0x1
  c4:	9d058593          	addi	a1,a1,-1584 # a90 <malloc+0x180>
  c8:	4505                	li	a0,1
  ca:	00000097          	auipc	ra,0x0
  ce:	75a080e7          	jalr	1882(ra) # 824 <fprintf>
     fprintf(1, "Return value of waitpid=%d\n", waitpid(x, 0));
  d2:	4581                	li	a1,0
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	41a080e7          	jalr	1050(ra) # 4f0 <waitpid>
  de:	862a                	mv	a2,a0
  e0:	00001597          	auipc	a1,0x1
  e4:	a0058593          	addi	a1,a1,-1536 # ae0 <malloc+0x1d0>
  e8:	4505                	li	a0,1
  ea:	00000097          	auipc	ra,0x0
  ee:	73a080e7          	jalr	1850(ra) # 824 <fprintf>
     fprintf(1, "%d: Child.\n", getpid());
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
  }

  exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	33c080e7          	jalr	828(ra) # 430 <exit>
     fprintf(2, "Error: cannot fork\nAborting...\n");
  fc:	00001597          	auipc	a1,0x1
 100:	8fc58593          	addi	a1,a1,-1796 # 9f8 <malloc+0xe8>
 104:	4509                	li	a0,2
 106:	00000097          	auipc	ra,0x0
 10a:	71e080e7          	jalr	1822(ra) # 824 <fprintf>
     exit(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	320080e7          	jalr	800(ra) # 430 <exit>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 118:	00001597          	auipc	a1,0x1
 11c:	91058593          	addi	a1,a1,-1776 # a28 <malloc+0x118>
 120:	4505                	li	a0,1
 122:	00000097          	auipc	ra,0x0
 126:	702080e7          	jalr	1794(ra) # 824 <fprintf>
 12a:	b785                	j	8a <main+0x8a>
     if (pinfo(x, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 12c:	00001597          	auipc	a1,0x1
 130:	8fc58593          	addi	a1,a1,-1796 # a28 <malloc+0x118>
 134:	4505                	li	a0,1
 136:	00000097          	auipc	ra,0x0
 13a:	6ee080e7          	jalr	1774(ra) # 824 <fprintf>
 13e:	bf51                	j	d2 <main+0xd2>
     fprintf(1, "%d: Child.\n", getpid());
 140:	00000097          	auipc	ra,0x0
 144:	370080e7          	jalr	880(ra) # 4b0 <getpid>
 148:	862a                	mv	a2,a0
 14a:	00001597          	auipc	a1,0x1
 14e:	9b658593          	addi	a1,a1,-1610 # b00 <malloc+0x1f0>
 152:	4505                	li	a0,1
 154:	00000097          	auipc	ra,0x0
 158:	6d0080e7          	jalr	1744(ra) # 824 <fprintf>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 15c:	fa840593          	addi	a1,s0,-88
 160:	557d                	li	a0,-1
 162:	00000097          	auipc	ra,0x0
 166:	39e080e7          	jalr	926(ra) # 500 <pinfo>
 16a:	02054e63          	bltz	a0,1a6 <main+0x1a6>
     else fprintf(1, "pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p\n\n", pstat.pid, pstat.ppid, pstat.state, pstat.command, pstat.ctime, pstat.stime, pstat.etime, pstat.size);
 16e:	fd843783          	ld	a5,-40(s0)
 172:	e43e                	sd	a5,8(sp)
 174:	fd042783          	lw	a5,-48(s0)
 178:	e03e                	sd	a5,0(sp)
 17a:	fcc42883          	lw	a7,-52(s0)
 17e:	fc842803          	lw	a6,-56(s0)
 182:	fb840793          	addi	a5,s0,-72
 186:	fb040713          	addi	a4,s0,-80
 18a:	fac42683          	lw	a3,-84(s0)
 18e:	fa842603          	lw	a2,-88(s0)
 192:	00001597          	auipc	a1,0x1
 196:	8fe58593          	addi	a1,a1,-1794 # a90 <malloc+0x180>
 19a:	4505                	li	a0,1
 19c:	00000097          	auipc	ra,0x0
 1a0:	688080e7          	jalr	1672(ra) # 824 <fprintf>
 1a4:	b7b9                	j	f2 <main+0xf2>
     if (pinfo(-1, &pstat) < 0) fprintf(1, "Cannot get pinfo\n");
 1a6:	00001597          	auipc	a1,0x1
 1aa:	88258593          	addi	a1,a1,-1918 # a28 <malloc+0x118>
 1ae:	4505                	li	a0,1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	674080e7          	jalr	1652(ra) # 824 <fprintf>
 1b8:	bf2d                	j	f2 <main+0xf2>

00000000000001ba <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c0:	87aa                	mv	a5,a0
 1c2:	0585                	addi	a1,a1,1
 1c4:	0785                	addi	a5,a5,1
 1c6:	fff5c703          	lbu	a4,-1(a1)
 1ca:	fee78fa3          	sb	a4,-1(a5)
 1ce:	fb75                	bnez	a4,1c2 <strcpy+0x8>
    ;
  return os;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	cb91                	beqz	a5,1f4 <strcmp+0x1e>
 1e2:	0005c703          	lbu	a4,0(a1)
 1e6:	00f71763          	bne	a4,a5,1f4 <strcmp+0x1e>
    p++, q++;
 1ea:	0505                	addi	a0,a0,1
 1ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbe5                	bnez	a5,1e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f4:	0005c503          	lbu	a0,0(a1)
}
 1f8:	40a7853b          	subw	a0,a5,a0
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strlen>:

uint
strlen(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cf91                	beqz	a5,228 <strlen+0x26>
 20e:	0505                	addi	a0,a0,1
 210:	87aa                	mv	a5,a0
 212:	4685                	li	a3,1
 214:	9e89                	subw	a3,a3,a0
 216:	00f6853b          	addw	a0,a3,a5
 21a:	0785                	addi	a5,a5,1
 21c:	fff7c703          	lbu	a4,-1(a5)
 220:	fb7d                	bnez	a4,216 <strlen+0x14>
    ;
  return n;
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  for(n = 0; s[n]; n++)
 228:	4501                	li	a0,0
 22a:	bfe5                	j	222 <strlen+0x20>

000000000000022c <memset>:

void*
memset(void *dst, int c, uint n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 232:	ce09                	beqz	a2,24c <memset+0x20>
 234:	87aa                	mv	a5,a0
 236:	fff6071b          	addiw	a4,a2,-1
 23a:	1702                	slli	a4,a4,0x20
 23c:	9301                	srli	a4,a4,0x20
 23e:	0705                	addi	a4,a4,1
 240:	972a                	add	a4,a4,a0
    cdst[i] = c;
 242:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 246:	0785                	addi	a5,a5,1
 248:	fee79de3          	bne	a5,a4,242 <memset+0x16>
  }
  return dst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <strchr>:

char*
strchr(const char *s, char c)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  for(; *s; s++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	cb99                	beqz	a5,272 <strchr+0x20>
    if(*s == c)
 25e:	00f58763          	beq	a1,a5,26c <strchr+0x1a>
  for(; *s; s++)
 262:	0505                	addi	a0,a0,1
 264:	00054783          	lbu	a5,0(a0)
 268:	fbfd                	bnez	a5,25e <strchr+0xc>
      return (char*)s;
  return 0;
 26a:	4501                	li	a0,0
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strchr+0x1a>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	711d                	addi	sp,sp,-96
 278:	ec86                	sd	ra,88(sp)
 27a:	e8a2                	sd	s0,80(sp)
 27c:	e4a6                	sd	s1,72(sp)
 27e:	e0ca                	sd	s2,64(sp)
 280:	fc4e                	sd	s3,56(sp)
 282:	f852                	sd	s4,48(sp)
 284:	f456                	sd	s5,40(sp)
 286:	f05a                	sd	s6,32(sp)
 288:	ec5e                	sd	s7,24(sp)
 28a:	1080                	addi	s0,sp,96
 28c:	8baa                	mv	s7,a0
 28e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	892a                	mv	s2,a0
 292:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 294:	4aa9                	li	s5,10
 296:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 298:	89a6                	mv	s3,s1
 29a:	2485                	addiw	s1,s1,1
 29c:	0344d863          	bge	s1,s4,2cc <gets+0x56>
    cc = read(0, &c, 1);
 2a0:	4605                	li	a2,1
 2a2:	faf40593          	addi	a1,s0,-81
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	1a0080e7          	jalr	416(ra) # 448 <read>
    if(cc < 1)
 2b0:	00a05e63          	blez	a0,2cc <gets+0x56>
    buf[i++] = c;
 2b4:	faf44783          	lbu	a5,-81(s0)
 2b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2bc:	01578763          	beq	a5,s5,2ca <gets+0x54>
 2c0:	0905                	addi	s2,s2,1
 2c2:	fd679be3          	bne	a5,s6,298 <gets+0x22>
  for(i=0; i+1 < max; ){
 2c6:	89a6                	mv	s3,s1
 2c8:	a011                	j	2cc <gets+0x56>
 2ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2cc:	99de                	add	s3,s3,s7
 2ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d2:	855e                	mv	a0,s7
 2d4:	60e6                	ld	ra,88(sp)
 2d6:	6446                	ld	s0,80(sp)
 2d8:	64a6                	ld	s1,72(sp)
 2da:	6906                	ld	s2,64(sp)
 2dc:	79e2                	ld	s3,56(sp)
 2de:	7a42                	ld	s4,48(sp)
 2e0:	7aa2                	ld	s5,40(sp)
 2e2:	7b02                	ld	s6,32(sp)
 2e4:	6be2                	ld	s7,24(sp)
 2e6:	6125                	addi	sp,sp,96
 2e8:	8082                	ret

00000000000002ea <stat>:

int
stat(const char *n, struct stat *st)
{
 2ea:	1101                	addi	sp,sp,-32
 2ec:	ec06                	sd	ra,24(sp)
 2ee:	e822                	sd	s0,16(sp)
 2f0:	e426                	sd	s1,8(sp)
 2f2:	e04a                	sd	s2,0(sp)
 2f4:	1000                	addi	s0,sp,32
 2f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f8:	4581                	li	a1,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	176080e7          	jalr	374(ra) # 470 <open>
  if(fd < 0)
 302:	02054563          	bltz	a0,32c <stat+0x42>
 306:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 308:	85ca                	mv	a1,s2
 30a:	00000097          	auipc	ra,0x0
 30e:	17e080e7          	jalr	382(ra) # 488 <fstat>
 312:	892a                	mv	s2,a0
  close(fd);
 314:	8526                	mv	a0,s1
 316:	00000097          	auipc	ra,0x0
 31a:	142080e7          	jalr	322(ra) # 458 <close>
  return r;
}
 31e:	854a                	mv	a0,s2
 320:	60e2                	ld	ra,24(sp)
 322:	6442                	ld	s0,16(sp)
 324:	64a2                	ld	s1,8(sp)
 326:	6902                	ld	s2,0(sp)
 328:	6105                	addi	sp,sp,32
 32a:	8082                	ret
    return -1;
 32c:	597d                	li	s2,-1
 32e:	bfc5                	j	31e <stat+0x34>

0000000000000330 <atoi>:

int
atoi(const char *s)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 336:	00054603          	lbu	a2,0(a0)
 33a:	fd06079b          	addiw	a5,a2,-48
 33e:	0ff7f793          	andi	a5,a5,255
 342:	4725                	li	a4,9
 344:	02f76963          	bltu	a4,a5,376 <atoi+0x46>
 348:	86aa                	mv	a3,a0
  n = 0;
 34a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 34c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 34e:	0685                	addi	a3,a3,1
 350:	0025179b          	slliw	a5,a0,0x2
 354:	9fa9                	addw	a5,a5,a0
 356:	0017979b          	slliw	a5,a5,0x1
 35a:	9fb1                	addw	a5,a5,a2
 35c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 360:	0006c603          	lbu	a2,0(a3)
 364:	fd06071b          	addiw	a4,a2,-48
 368:	0ff77713          	andi	a4,a4,255
 36c:	fee5f1e3          	bgeu	a1,a4,34e <atoi+0x1e>
  return n;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  n = 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <atoi+0x40>

000000000000037a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e422                	sd	s0,8(sp)
 37e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 380:	02b57663          	bgeu	a0,a1,3ac <memmove+0x32>
    while(n-- > 0)
 384:	02c05163          	blez	a2,3a6 <memmove+0x2c>
 388:	fff6079b          	addiw	a5,a2,-1
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	0785                	addi	a5,a5,1
 392:	97aa                	add	a5,a5,a0
  dst = vdst;
 394:	872a                	mv	a4,a0
      *dst++ = *src++;
 396:	0585                	addi	a1,a1,1
 398:	0705                	addi	a4,a4,1
 39a:	fff5c683          	lbu	a3,-1(a1)
 39e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a2:	fee79ae3          	bne	a5,a4,396 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
    dst += n;
 3ac:	00c50733          	add	a4,a0,a2
    src += n;
 3b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b2:	fec05ae3          	blez	a2,3a6 <memmove+0x2c>
 3b6:	fff6079b          	addiw	a5,a2,-1
 3ba:	1782                	slli	a5,a5,0x20
 3bc:	9381                	srli	a5,a5,0x20
 3be:	fff7c793          	not	a5,a5
 3c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c4:	15fd                	addi	a1,a1,-1
 3c6:	177d                	addi	a4,a4,-1
 3c8:	0005c683          	lbu	a3,0(a1)
 3cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d0:	fee79ae3          	bne	a5,a4,3c4 <memmove+0x4a>
 3d4:	bfc9                	j	3a6 <memmove+0x2c>

00000000000003d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3dc:	ca05                	beqz	a2,40c <memcmp+0x36>
 3de:	fff6069b          	addiw	a3,a2,-1
 3e2:	1682                	slli	a3,a3,0x20
 3e4:	9281                	srli	a3,a3,0x20
 3e6:	0685                	addi	a3,a3,1
 3e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ea:	00054783          	lbu	a5,0(a0)
 3ee:	0005c703          	lbu	a4,0(a1)
 3f2:	00e79863          	bne	a5,a4,402 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3f6:	0505                	addi	a0,a0,1
    p2++;
 3f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3fa:	fed518e3          	bne	a0,a3,3ea <memcmp+0x14>
  }
  return 0;
 3fe:	4501                	li	a0,0
 400:	a019                	j	406 <memcmp+0x30>
      return *p1 - *p2;
 402:	40e7853b          	subw	a0,a5,a4
}
 406:	6422                	ld	s0,8(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret
  return 0;
 40c:	4501                	li	a0,0
 40e:	bfe5                	j	406 <memcmp+0x30>

0000000000000410 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 410:	1141                	addi	sp,sp,-16
 412:	e406                	sd	ra,8(sp)
 414:	e022                	sd	s0,0(sp)
 416:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 418:	00000097          	auipc	ra,0x0
 41c:	f62080e7          	jalr	-158(ra) # 37a <memmove>
}
 420:	60a2                	ld	ra,8(sp)
 422:	6402                	ld	s0,0(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret

0000000000000428 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 428:	4885                	li	a7,1
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <exit>:
.global exit
exit:
 li a7, SYS_exit
 430:	4889                	li	a7,2
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <wait>:
.global wait
wait:
 li a7, SYS_wait
 438:	488d                	li	a7,3
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 440:	4891                	li	a7,4
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <read>:
.global read
read:
 li a7, SYS_read
 448:	4895                	li	a7,5
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <write>:
.global write
write:
 li a7, SYS_write
 450:	48c1                	li	a7,16
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <close>:
.global close
close:
 li a7, SYS_close
 458:	48d5                	li	a7,21
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <kill>:
.global kill
kill:
 li a7, SYS_kill
 460:	4899                	li	a7,6
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <exec>:
.global exec
exec:
 li a7, SYS_exec
 468:	489d                	li	a7,7
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <open>:
.global open
open:
 li a7, SYS_open
 470:	48bd                	li	a7,15
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 478:	48c5                	li	a7,17
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 480:	48c9                	li	a7,18
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 488:	48a1                	li	a7,8
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <link>:
.global link
link:
 li a7, SYS_link
 490:	48cd                	li	a7,19
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 498:	48d1                	li	a7,20
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a0:	48a5                	li	a7,9
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a8:	48a9                	li	a7,10
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b0:	48ad                	li	a7,11
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b8:	48b1                	li	a7,12
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c0:	48b5                	li	a7,13
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c8:	48b9                	li	a7,14
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4d0:	48d9                	li	a7,22
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <yield>:
.global yield
yield:
 li a7, SYS_yield
 4d8:	48dd                	li	a7,23
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 4e0:	48e1                	li	a7,24
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 4e8:	48e5                	li	a7,25
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 4f0:	48e9                	li	a7,26
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 4f8:	48ed                	li	a7,27
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 500:	48f1                	li	a7,28
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 508:	48f5                	li	a7,29
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 510:	48f9                	li	a7,30
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 518:	48fd                	li	a7,31
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 520:	02000893          	li	a7,32
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 52a:	02100893          	li	a7,33
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 534:	02200893          	li	a7,34
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 53e:	02300893          	li	a7,35
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 548:	02500893          	li	a7,37
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 552:	02400893          	li	a7,36
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 55c:	02600893          	li	a7,38
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 566:	02800893          	li	a7,40
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 570:	02700893          	li	a7,39
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57a:	1101                	addi	sp,sp,-32
 57c:	ec06                	sd	ra,24(sp)
 57e:	e822                	sd	s0,16(sp)
 580:	1000                	addi	s0,sp,32
 582:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 586:	4605                	li	a2,1
 588:	fef40593          	addi	a1,s0,-17
 58c:	00000097          	auipc	ra,0x0
 590:	ec4080e7          	jalr	-316(ra) # 450 <write>
}
 594:	60e2                	ld	ra,24(sp)
 596:	6442                	ld	s0,16(sp)
 598:	6105                	addi	sp,sp,32
 59a:	8082                	ret

000000000000059c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59c:	7139                	addi	sp,sp,-64
 59e:	fc06                	sd	ra,56(sp)
 5a0:	f822                	sd	s0,48(sp)
 5a2:	f426                	sd	s1,40(sp)
 5a4:	f04a                	sd	s2,32(sp)
 5a6:	ec4e                	sd	s3,24(sp)
 5a8:	0080                	addi	s0,sp,64
 5aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ac:	c299                	beqz	a3,5b2 <printint+0x16>
 5ae:	0805c863          	bltz	a1,63e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b2:	2581                	sext.w	a1,a1
  neg = 0;
 5b4:	4881                	li	a7,0
 5b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5bc:	2601                	sext.w	a2,a2
 5be:	00000517          	auipc	a0,0x0
 5c2:	55a50513          	addi	a0,a0,1370 # b18 <digits>
 5c6:	883a                	mv	a6,a4
 5c8:	2705                	addiw	a4,a4,1
 5ca:	02c5f7bb          	remuw	a5,a1,a2
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	97aa                	add	a5,a5,a0
 5d4:	0007c783          	lbu	a5,0(a5)
 5d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5dc:	0005879b          	sext.w	a5,a1
 5e0:	02c5d5bb          	divuw	a1,a1,a2
 5e4:	0685                	addi	a3,a3,1
 5e6:	fec7f0e3          	bgeu	a5,a2,5c6 <printint+0x2a>
  if(neg)
 5ea:	00088b63          	beqz	a7,600 <printint+0x64>
    buf[i++] = '-';
 5ee:	fd040793          	addi	a5,s0,-48
 5f2:	973e                	add	a4,a4,a5
 5f4:	02d00793          	li	a5,45
 5f8:	fef70823          	sb	a5,-16(a4)
 5fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 600:	02e05863          	blez	a4,630 <printint+0x94>
 604:	fc040793          	addi	a5,s0,-64
 608:	00e78933          	add	s2,a5,a4
 60c:	fff78993          	addi	s3,a5,-1
 610:	99ba                	add	s3,s3,a4
 612:	377d                	addiw	a4,a4,-1
 614:	1702                	slli	a4,a4,0x20
 616:	9301                	srli	a4,a4,0x20
 618:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 61c:	fff94583          	lbu	a1,-1(s2)
 620:	8526                	mv	a0,s1
 622:	00000097          	auipc	ra,0x0
 626:	f58080e7          	jalr	-168(ra) # 57a <putc>
  while(--i >= 0)
 62a:	197d                	addi	s2,s2,-1
 62c:	ff3918e3          	bne	s2,s3,61c <printint+0x80>
}
 630:	70e2                	ld	ra,56(sp)
 632:	7442                	ld	s0,48(sp)
 634:	74a2                	ld	s1,40(sp)
 636:	7902                	ld	s2,32(sp)
 638:	69e2                	ld	s3,24(sp)
 63a:	6121                	addi	sp,sp,64
 63c:	8082                	ret
    x = -xx;
 63e:	40b005bb          	negw	a1,a1
    neg = 1;
 642:	4885                	li	a7,1
    x = -xx;
 644:	bf8d                	j	5b6 <printint+0x1a>

0000000000000646 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 646:	7119                	addi	sp,sp,-128
 648:	fc86                	sd	ra,120(sp)
 64a:	f8a2                	sd	s0,112(sp)
 64c:	f4a6                	sd	s1,104(sp)
 64e:	f0ca                	sd	s2,96(sp)
 650:	ecce                	sd	s3,88(sp)
 652:	e8d2                	sd	s4,80(sp)
 654:	e4d6                	sd	s5,72(sp)
 656:	e0da                	sd	s6,64(sp)
 658:	fc5e                	sd	s7,56(sp)
 65a:	f862                	sd	s8,48(sp)
 65c:	f466                	sd	s9,40(sp)
 65e:	f06a                	sd	s10,32(sp)
 660:	ec6e                	sd	s11,24(sp)
 662:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 664:	0005c903          	lbu	s2,0(a1)
 668:	18090f63          	beqz	s2,806 <vprintf+0x1c0>
 66c:	8aaa                	mv	s5,a0
 66e:	8b32                	mv	s6,a2
 670:	00158493          	addi	s1,a1,1
  state = 0;
 674:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 676:	02500a13          	li	s4,37
      if(c == 'd'){
 67a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 67e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 682:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 686:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	48eb8b93          	addi	s7,s7,1166 # b18 <digits>
 692:	a839                	j	6b0 <vprintf+0x6a>
        putc(fd, c);
 694:	85ca                	mv	a1,s2
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	ee2080e7          	jalr	-286(ra) # 57a <putc>
 6a0:	a019                	j	6a6 <vprintf+0x60>
    } else if(state == '%'){
 6a2:	01498f63          	beq	s3,s4,6c0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a6:	0485                	addi	s1,s1,1
 6a8:	fff4c903          	lbu	s2,-1(s1)
 6ac:	14090d63          	beqz	s2,806 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b4:	fe0997e3          	bnez	s3,6a2 <vprintf+0x5c>
      if(c == '%'){
 6b8:	fd479ee3          	bne	a5,s4,694 <vprintf+0x4e>
        state = '%';
 6bc:	89be                	mv	s3,a5
 6be:	b7e5                	j	6a6 <vprintf+0x60>
      if(c == 'd'){
 6c0:	05878063          	beq	a5,s8,700 <vprintf+0xba>
      } else if(c == 'l') {
 6c4:	05978c63          	beq	a5,s9,71c <vprintf+0xd6>
      } else if(c == 'x') {
 6c8:	07a78863          	beq	a5,s10,738 <vprintf+0xf2>
      } else if(c == 'p') {
 6cc:	09b78463          	beq	a5,s11,754 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6d0:	07300713          	li	a4,115
 6d4:	0ce78663          	beq	a5,a4,7a0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d8:	06300713          	li	a4,99
 6dc:	0ee78e63          	beq	a5,a4,7d8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6e0:	11478863          	beq	a5,s4,7f0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e4:	85d2                	mv	a1,s4
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e92080e7          	jalr	-366(ra) # 57a <putc>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e86080e7          	jalr	-378(ra) # 57a <putc>
      }
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b765                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 700:	008b0913          	addi	s2,s6,8
 704:	4685                	li	a3,1
 706:	4629                	li	a2,10
 708:	000b2583          	lw	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e8e080e7          	jalr	-370(ra) # 59c <printint>
 716:	8b4a                	mv	s6,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b771                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	008b0913          	addi	s2,s6,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000b2583          	lw	a1,0(s6)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e72080e7          	jalr	-398(ra) # 59c <printint>
 732:	8b4a                	mv	s6,s2
      state = 0;
 734:	4981                	li	s3,0
 736:	bf85                	j	6a6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 738:	008b0913          	addi	s2,s6,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000b2583          	lw	a1,0(s6)
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e56080e7          	jalr	-426(ra) # 59c <printint>
 74e:	8b4a                	mv	s6,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	bf91                	j	6a6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 754:	008b0793          	addi	a5,s6,8
 758:	f8f43423          	sd	a5,-120(s0)
 75c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 760:	03000593          	li	a1,48
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e14080e7          	jalr	-492(ra) # 57a <putc>
  putc(fd, 'x');
 76e:	85ea                	mv	a1,s10
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	e08080e7          	jalr	-504(ra) # 57a <putc>
 77a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77c:	03c9d793          	srli	a5,s3,0x3c
 780:	97de                	add	a5,a5,s7
 782:	0007c583          	lbu	a1,0(a5)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	df2080e7          	jalr	-526(ra) # 57a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	0992                	slli	s3,s3,0x4
 792:	397d                	addiw	s2,s2,-1
 794:	fe0914e3          	bnez	s2,77c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 798:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b721                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 7a0:	008b0993          	addi	s3,s6,8
 7a4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a8:	02090163          	beqz	s2,7ca <vprintf+0x184>
        while(*s != 0){
 7ac:	00094583          	lbu	a1,0(s2)
 7b0:	c9a1                	beqz	a1,800 <vprintf+0x1ba>
          putc(fd, *s);
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	dc6080e7          	jalr	-570(ra) # 57a <putc>
          s++;
 7bc:	0905                	addi	s2,s2,1
        while(*s != 0){
 7be:	00094583          	lbu	a1,0(s2)
 7c2:	f9e5                	bnez	a1,7b2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c4:	8b4e                	mv	s6,s3
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bdf9                	j	6a6 <vprintf+0x60>
          s = "(null)";
 7ca:	00000917          	auipc	s2,0x0
 7ce:	34690913          	addi	s2,s2,838 # b10 <malloc+0x200>
        while(*s != 0){
 7d2:	02800593          	li	a1,40
 7d6:	bff1                	j	7b2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d8:	008b0913          	addi	s2,s6,8
 7dc:	000b4583          	lbu	a1,0(s6)
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	d98080e7          	jalr	-616(ra) # 57a <putc>
 7ea:	8b4a                	mv	s6,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd65                	j	6a6 <vprintf+0x60>
        putc(fd, c);
 7f0:	85d2                	mv	a1,s4
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	d86080e7          	jalr	-634(ra) # 57a <putc>
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b565                	j	6a6 <vprintf+0x60>
        s = va_arg(ap, char*);
 800:	8b4e                	mv	s6,s3
      state = 0;
 802:	4981                	li	s3,0
 804:	b54d                	j	6a6 <vprintf+0x60>
    }
  }
}
 806:	70e6                	ld	ra,120(sp)
 808:	7446                	ld	s0,112(sp)
 80a:	74a6                	ld	s1,104(sp)
 80c:	7906                	ld	s2,96(sp)
 80e:	69e6                	ld	s3,88(sp)
 810:	6a46                	ld	s4,80(sp)
 812:	6aa6                	ld	s5,72(sp)
 814:	6b06                	ld	s6,64(sp)
 816:	7be2                	ld	s7,56(sp)
 818:	7c42                	ld	s8,48(sp)
 81a:	7ca2                	ld	s9,40(sp)
 81c:	7d02                	ld	s10,32(sp)
 81e:	6de2                	ld	s11,24(sp)
 820:	6109                	addi	sp,sp,128
 822:	8082                	ret

0000000000000824 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 824:	715d                	addi	sp,sp,-80
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e010                	sd	a2,0(s0)
 82e:	e414                	sd	a3,8(s0)
 830:	e818                	sd	a4,16(s0)
 832:	ec1c                	sd	a5,24(s0)
 834:	03043023          	sd	a6,32(s0)
 838:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 840:	8622                	mv	a2,s0
 842:	00000097          	auipc	ra,0x0
 846:	e04080e7          	jalr	-508(ra) # 646 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6161                	addi	sp,sp,80
 850:	8082                	ret

0000000000000852 <printf>:

void
printf(const char *fmt, ...)
{
 852:	711d                	addi	sp,sp,-96
 854:	ec06                	sd	ra,24(sp)
 856:	e822                	sd	s0,16(sp)
 858:	1000                	addi	s0,sp,32
 85a:	e40c                	sd	a1,8(s0)
 85c:	e810                	sd	a2,16(s0)
 85e:	ec14                	sd	a3,24(s0)
 860:	f018                	sd	a4,32(s0)
 862:	f41c                	sd	a5,40(s0)
 864:	03043823          	sd	a6,48(s0)
 868:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	00840613          	addi	a2,s0,8
 870:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 874:	85aa                	mv	a1,a0
 876:	4505                	li	a0,1
 878:	00000097          	auipc	ra,0x0
 87c:	dce080e7          	jalr	-562(ra) # 646 <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e422                	sd	s0,8(sp)
 88c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	00000797          	auipc	a5,0x0
 896:	29e7b783          	ld	a5,670(a5) # b30 <freep>
 89a:	a805                	j	8ca <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89c:	4618                	lw	a4,8(a2)
 89e:	9db9                	addw	a1,a1,a4
 8a0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	6318                	ld	a4,0(a4)
 8a8:	fee53823          	sd	a4,-16(a0)
 8ac:	a091                	j	8f0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ae:	ff852703          	lw	a4,-8(a0)
 8b2:	9e39                	addw	a2,a2,a4
 8b4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b6:	ff053703          	ld	a4,-16(a0)
 8ba:	e398                	sd	a4,0(a5)
 8bc:	a099                	j	902 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e7e463          	bltu	a5,a4,8c8 <free+0x40>
 8c4:	00e6ea63          	bltu	a3,a4,8d8 <free+0x50>
{
 8c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ca:	fed7fae3          	bgeu	a5,a3,8be <free+0x36>
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e6e463          	bltu	a3,a4,8d8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	fee7eae3          	bltu	a5,a4,8c8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d8:	ff852583          	lw	a1,-8(a0)
 8dc:	6390                	ld	a2,0(a5)
 8de:	02059713          	slli	a4,a1,0x20
 8e2:	9301                	srli	a4,a4,0x20
 8e4:	0712                	slli	a4,a4,0x4
 8e6:	9736                	add	a4,a4,a3
 8e8:	fae60ae3          	beq	a2,a4,89c <free+0x14>
    bp->s.ptr = p->s.ptr;
 8ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f0:	4790                	lw	a2,8(a5)
 8f2:	02061713          	slli	a4,a2,0x20
 8f6:	9301                	srli	a4,a4,0x20
 8f8:	0712                	slli	a4,a4,0x4
 8fa:	973e                	add	a4,a4,a5
 8fc:	fae689e3          	beq	a3,a4,8ae <free+0x26>
  } else
    p->s.ptr = bp;
 900:	e394                	sd	a3,0(a5)
  freep = p;
 902:	00000717          	auipc	a4,0x0
 906:	22f73723          	sd	a5,558(a4) # b30 <freep>
}
 90a:	6422                	ld	s0,8(sp)
 90c:	0141                	addi	sp,sp,16
 90e:	8082                	ret

0000000000000910 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 910:	7139                	addi	sp,sp,-64
 912:	fc06                	sd	ra,56(sp)
 914:	f822                	sd	s0,48(sp)
 916:	f426                	sd	s1,40(sp)
 918:	f04a                	sd	s2,32(sp)
 91a:	ec4e                	sd	s3,24(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 934:	00000517          	auipc	a0,0x0
 938:	1fc53503          	ld	a0,508(a0) # b30 <freep>
 93c:	c515                	beqz	a0,968 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	02977f63          	bgeu	a4,s1,980 <malloc+0x70>
 946:	8a4e                	mv	s4,s3
 948:	0009871b          	sext.w	a4,s3
 94c:	6685                	lui	a3,0x1
 94e:	00d77363          	bgeu	a4,a3,954 <malloc+0x44>
 952:	6a05                	lui	s4,0x1
 954:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 958:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95c:	00000917          	auipc	s2,0x0
 960:	1d490913          	addi	s2,s2,468 # b30 <freep>
  if(p == (char*)-1)
 964:	5afd                	li	s5,-1
 966:	a88d                	j	9d8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 968:	00000797          	auipc	a5,0x0
 96c:	1d078793          	addi	a5,a5,464 # b38 <base>
 970:	00000717          	auipc	a4,0x0
 974:	1cf73023          	sd	a5,448(a4) # b30 <freep>
 978:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97e:	b7e1                	j	946 <malloc+0x36>
      if(p->s.size == nunits)
 980:	02e48b63          	beq	s1,a4,9b6 <malloc+0xa6>
        p->s.size -= nunits;
 984:	4137073b          	subw	a4,a4,s3
 988:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98a:	1702                	slli	a4,a4,0x20
 98c:	9301                	srli	a4,a4,0x20
 98e:	0712                	slli	a4,a4,0x4
 990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 996:	00000717          	auipc	a4,0x0
 99a:	18a73d23          	sd	a0,410(a4) # b30 <freep>
      return (void*)(p + 1);
 99e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a2:	70e2                	ld	ra,56(sp)
 9a4:	7442                	ld	s0,48(sp)
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	7902                	ld	s2,32(sp)
 9aa:	69e2                	ld	s3,24(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
 9b2:	6121                	addi	sp,sp,64
 9b4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b6:	6398                	ld	a4,0(a5)
 9b8:	e118                	sd	a4,0(a0)
 9ba:	bff1                	j	996 <malloc+0x86>
  hp->s.size = nu;
 9bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c0:	0541                	addi	a0,a0,16
 9c2:	00000097          	auipc	ra,0x0
 9c6:	ec6080e7          	jalr	-314(ra) # 888 <free>
  return freep;
 9ca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ce:	d971                	beqz	a0,9a2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d2:	4798                	lw	a4,8(a5)
 9d4:	fa9776e3          	bgeu	a4,s1,980 <malloc+0x70>
    if(p == freep)
 9d8:	00093703          	ld	a4,0(s2)
 9dc:	853e                	mv	a0,a5
 9de:	fef719e3          	bne	a4,a5,9d0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9e2:	8552                	mv	a0,s4
 9e4:	00000097          	auipc	ra,0x0
 9e8:	ad4080e7          	jalr	-1324(ra) # 4b8 <sbrk>
  if(p == (char*)-1)
 9ec:	fd5518e3          	bne	a0,s5,9bc <malloc+0xac>
        return 0;
 9f0:	4501                	li	a0,0
 9f2:	bf45                	j	9a2 <malloc+0x92>
