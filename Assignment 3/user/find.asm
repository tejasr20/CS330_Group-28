
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	350080e7          	jalr	848(ra) # 360 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	324080e7          	jalr	804(ra) # 360 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	302080e7          	jalr	770(ra) # 360 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	bd298993          	addi	s3,s3,-1070 # c38 <buf.1155>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	462080e7          	jalr	1122(ra) # 4d8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2e0080e7          	jalr	736(ra) # 360 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2d2080e7          	jalr	722(ra) # 360 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2e2080e7          	jalr	738(ra) # 38a <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <find>:

void
find(char *path, char *fname)
{
  b4:	d8010113          	addi	sp,sp,-640
  b8:	26113c23          	sd	ra,632(sp)
  bc:	26813823          	sd	s0,624(sp)
  c0:	26913423          	sd	s1,616(sp)
  c4:	27213023          	sd	s2,608(sp)
  c8:	25313c23          	sd	s3,600(sp)
  cc:	25413823          	sd	s4,592(sp)
  d0:	25513423          	sd	s5,584(sp)
  d4:	25613023          	sd	s6,576(sp)
  d8:	23713c23          	sd	s7,568(sp)
  dc:	23813823          	sd	s8,560(sp)
  e0:	0500                	addi	s0,sp,640
  e2:	89aa                	mv	s3,a0
  e4:	892e                	mv	s2,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  e6:	4581                	li	a1,0
  e8:	00000097          	auipc	ra,0x0
  ec:	4e6080e7          	jalr	1254(ra) # 5ce <open>
  f0:	04054563          	bltz	a0,13a <find+0x86>
  f4:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  f6:	d8840593          	addi	a1,s0,-632
  fa:	00000097          	auipc	ra,0x0
  fe:	4ec080e7          	jalr	1260(ra) # 5e6 <fstat>
 102:	04054763          	bltz	a0,150 <find+0x9c>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 106:	d9041783          	lh	a5,-624(s0)
 10a:	0007869b          	sext.w	a3,a5
 10e:	4705                	li	a4,1
 110:	06e68063          	beq	a3,a4,170 <find+0xbc>
 114:	4709                	li	a4,2
 116:	06e69f63          	bne	a3,a4,194 <find+0xe0>
  case T_FILE:
    fprintf(2, "find: search path %s is not a directory\n", path);
 11a:	864e                	mv	a2,s3
 11c:	00001597          	auipc	a1,0x1
 120:	a6c58593          	addi	a1,a1,-1428 # b88 <malloc+0x11a>
 124:	4509                	li	a0,2
 126:	00001097          	auipc	ra,0x1
 12a:	85c080e7          	jalr	-1956(ra) # 982 <fprintf>
    close(fd);
 12e:	8526                	mv	a0,s1
 130:	00000097          	auipc	ra,0x0
 134:	486080e7          	jalr	1158(ra) # 5b6 <close>
    return;
 138:	a09d                	j	19e <find+0xea>
    fprintf(2, "find: cannot open %s\n", path);
 13a:	864e                	mv	a2,s3
 13c:	00001597          	auipc	a1,0x1
 140:	a1c58593          	addi	a1,a1,-1508 # b58 <malloc+0xea>
 144:	4509                	li	a0,2
 146:	00001097          	auipc	ra,0x1
 14a:	83c080e7          	jalr	-1988(ra) # 982 <fprintf>
    return;
 14e:	a881                	j	19e <find+0xea>
    fprintf(2, "find: cannot stat %s\n", path);
 150:	864e                	mv	a2,s3
 152:	00001597          	auipc	a1,0x1
 156:	a1e58593          	addi	a1,a1,-1506 # b70 <malloc+0x102>
 15a:	4509                	li	a0,2
 15c:	00001097          	auipc	ra,0x1
 160:	826080e7          	jalr	-2010(ra) # 982 <fprintf>
    close(fd);
 164:	8526                	mv	a0,s1
 166:	00000097          	auipc	ra,0x0
 16a:	450080e7          	jalr	1104(ra) # 5b6 <close>
    return;
 16e:	a805                	j	19e <find+0xea>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 170:	854e                	mv	a0,s3
 172:	00000097          	auipc	ra,0x0
 176:	1ee080e7          	jalr	494(ra) # 360 <strlen>
 17a:	2541                	addiw	a0,a0,16
 17c:	20000793          	li	a5,512
 180:	04a7f663          	bgeu	a5,a0,1cc <find+0x118>
      printf("find: path too long\n");
 184:	00001517          	auipc	a0,0x1
 188:	a3450513          	addi	a0,a0,-1484 # bb8 <malloc+0x14a>
 18c:	00001097          	auipc	ra,0x1
 190:	824080e7          	jalr	-2012(ra) # 9b0 <printf>
         if (strcmp(".", de.name) && strcmp("..", de.name)) find(buf, fname);
      }
    }
    break;
  }
  close(fd);
 194:	8526                	mv	a0,s1
 196:	00000097          	auipc	ra,0x0
 19a:	420080e7          	jalr	1056(ra) # 5b6 <close>
}
 19e:	27813083          	ld	ra,632(sp)
 1a2:	27013403          	ld	s0,624(sp)
 1a6:	26813483          	ld	s1,616(sp)
 1aa:	26013903          	ld	s2,608(sp)
 1ae:	25813983          	ld	s3,600(sp)
 1b2:	25013a03          	ld	s4,592(sp)
 1b6:	24813a83          	ld	s5,584(sp)
 1ba:	24013b03          	ld	s6,576(sp)
 1be:	23813b83          	ld	s7,568(sp)
 1c2:	23013c03          	ld	s8,560(sp)
 1c6:	28010113          	addi	sp,sp,640
 1ca:	8082                	ret
    strcpy(buf, path);
 1cc:	85ce                	mv	a1,s3
 1ce:	db040513          	addi	a0,s0,-592
 1d2:	00000097          	auipc	ra,0x0
 1d6:	146080e7          	jalr	326(ra) # 318 <strcpy>
    p = buf+strlen(buf);
 1da:	db040513          	addi	a0,s0,-592
 1de:	00000097          	auipc	ra,0x0
 1e2:	182080e7          	jalr	386(ra) # 360 <strlen>
 1e6:	02051993          	slli	s3,a0,0x20
 1ea:	0209d993          	srli	s3,s3,0x20
 1ee:	db040793          	addi	a5,s0,-592
 1f2:	99be                	add	s3,s3,a5
    *p++ = '/';
 1f4:	00198a13          	addi	s4,s3,1
 1f8:	02f00793          	li	a5,47
 1fc:	00f98023          	sb	a5,0(s3)
      if (st.type == T_FILE) {
 200:	4a89                	li	s5,2
      else if (st.type == T_DIR) {
 202:	4b05                	li	s6,1
         if (strcmp(".", de.name) && strcmp("..", de.name)) find(buf, fname);
 204:	00001b97          	auipc	s7,0x1
 208:	9d4b8b93          	addi	s7,s7,-1580 # bd8 <malloc+0x16a>
 20c:	00001c17          	auipc	s8,0x1
 210:	9d4c0c13          	addi	s8,s8,-1580 # be0 <malloc+0x172>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 214:	4641                	li	a2,16
 216:	da040593          	addi	a1,s0,-608
 21a:	8526                	mv	a0,s1
 21c:	00000097          	auipc	ra,0x0
 220:	38a080e7          	jalr	906(ra) # 5a6 <read>
 224:	47c1                	li	a5,16
 226:	f6f517e3          	bne	a0,a5,194 <find+0xe0>
      if(de.inum == 0)
 22a:	da045783          	lhu	a5,-608(s0)
 22e:	d3fd                	beqz	a5,214 <find+0x160>
      memmove(p, de.name, DIRSIZ);
 230:	4639                	li	a2,14
 232:	da240593          	addi	a1,s0,-606
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	2a0080e7          	jalr	672(ra) # 4d8 <memmove>
      p[DIRSIZ] = 0;
 240:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 244:	d8840593          	addi	a1,s0,-632
 248:	db040513          	addi	a0,s0,-592
 24c:	00000097          	auipc	ra,0x0
 250:	1fc080e7          	jalr	508(ra) # 448 <stat>
 254:	04054363          	bltz	a0,29a <find+0x1e6>
      if (st.type == T_FILE) {
 258:	d9041783          	lh	a5,-624(s0)
 25c:	0007871b          	sext.w	a4,a5
 260:	05570863          	beq	a4,s5,2b0 <find+0x1fc>
      else if (st.type == T_DIR) {
 264:	2781                	sext.w	a5,a5
 266:	fb6797e3          	bne	a5,s6,214 <find+0x160>
         if (strcmp(".", de.name) && strcmp("..", de.name)) find(buf, fname);
 26a:	da240593          	addi	a1,s0,-606
 26e:	855e                	mv	a0,s7
 270:	00000097          	auipc	ra,0x0
 274:	0c4080e7          	jalr	196(ra) # 334 <strcmp>
 278:	dd51                	beqz	a0,214 <find+0x160>
 27a:	da240593          	addi	a1,s0,-606
 27e:	8562                	mv	a0,s8
 280:	00000097          	auipc	ra,0x0
 284:	0b4080e7          	jalr	180(ra) # 334 <strcmp>
 288:	d551                	beqz	a0,214 <find+0x160>
 28a:	85ca                	mv	a1,s2
 28c:	db040513          	addi	a0,s0,-592
 290:	00000097          	auipc	ra,0x0
 294:	e24080e7          	jalr	-476(ra) # b4 <find>
 298:	bfb5                	j	214 <find+0x160>
        printf("find: cannot stat %s\n", buf);
 29a:	db040593          	addi	a1,s0,-592
 29e:	00001517          	auipc	a0,0x1
 2a2:	8d250513          	addi	a0,a0,-1838 # b70 <malloc+0x102>
 2a6:	00000097          	auipc	ra,0x0
 2aa:	70a080e7          	jalr	1802(ra) # 9b0 <printf>
        continue;
 2ae:	b79d                	j	214 <find+0x160>
         if (!strcmp(fname, de.name)) printf("%s\n", buf);
 2b0:	da240593          	addi	a1,s0,-606
 2b4:	854a                	mv	a0,s2
 2b6:	00000097          	auipc	ra,0x0
 2ba:	07e080e7          	jalr	126(ra) # 334 <strcmp>
 2be:	f939                	bnez	a0,214 <find+0x160>
 2c0:	db040593          	addi	a1,s0,-592
 2c4:	00001517          	auipc	a0,0x1
 2c8:	90c50513          	addi	a0,a0,-1780 # bd0 <malloc+0x162>
 2cc:	00000097          	auipc	ra,0x0
 2d0:	6e4080e7          	jalr	1764(ra) # 9b0 <printf>
 2d4:	b781                	j	214 <find+0x160>

00000000000002d6 <main>:

int
main(int argc, char *argv[])
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  if(argc != 3){
 2de:	470d                	li	a4,3
 2e0:	02e50063          	beq	a0,a4,300 <main+0x2a>
    fprintf(2, "syntax: find path file\nAborting...\n");
 2e4:	00001597          	auipc	a1,0x1
 2e8:	90458593          	addi	a1,a1,-1788 # be8 <malloc+0x17a>
 2ec:	4509                	li	a0,2
 2ee:	00000097          	auipc	ra,0x0
 2f2:	694080e7          	jalr	1684(ra) # 982 <fprintf>
    exit(0);
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	296080e7          	jalr	662(ra) # 58e <exit>
 300:	87ae                	mv	a5,a1
  }
  find (argv[1], argv[2]);
 302:	698c                	ld	a1,16(a1)
 304:	6788                	ld	a0,8(a5)
 306:	00000097          	auipc	ra,0x0
 30a:	dae080e7          	jalr	-594(ra) # b4 <find>
  exit(0);
 30e:	4501                	li	a0,0
 310:	00000097          	auipc	ra,0x0
 314:	27e080e7          	jalr	638(ra) # 58e <exit>

0000000000000318 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31e:	87aa                	mv	a5,a0
 320:	0585                	addi	a1,a1,1
 322:	0785                	addi	a5,a5,1
 324:	fff5c703          	lbu	a4,-1(a1)
 328:	fee78fa3          	sb	a4,-1(a5)
 32c:	fb75                	bnez	a4,320 <strcpy+0x8>
    ;
  return os;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 33a:	00054783          	lbu	a5,0(a0)
 33e:	cb91                	beqz	a5,352 <strcmp+0x1e>
 340:	0005c703          	lbu	a4,0(a1)
 344:	00f71763          	bne	a4,a5,352 <strcmp+0x1e>
    p++, q++;
 348:	0505                	addi	a0,a0,1
 34a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 34c:	00054783          	lbu	a5,0(a0)
 350:	fbe5                	bnez	a5,340 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 352:	0005c503          	lbu	a0,0(a1)
}
 356:	40a7853b          	subw	a0,a5,a0
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <strlen>:

uint
strlen(const char *s)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cf91                	beqz	a5,386 <strlen+0x26>
 36c:	0505                	addi	a0,a0,1
 36e:	87aa                	mv	a5,a0
 370:	4685                	li	a3,1
 372:	9e89                	subw	a3,a3,a0
 374:	00f6853b          	addw	a0,a3,a5
 378:	0785                	addi	a5,a5,1
 37a:	fff7c703          	lbu	a4,-1(a5)
 37e:	fb7d                	bnez	a4,374 <strlen+0x14>
    ;
  return n;
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  for(n = 0; s[n]; n++)
 386:	4501                	li	a0,0
 388:	bfe5                	j	380 <strlen+0x20>

000000000000038a <memset>:

void*
memset(void *dst, int c, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 390:	ce09                	beqz	a2,3aa <memset+0x20>
 392:	87aa                	mv	a5,a0
 394:	fff6071b          	addiw	a4,a2,-1
 398:	1702                	slli	a4,a4,0x20
 39a:	9301                	srli	a4,a4,0x20
 39c:	0705                	addi	a4,a4,1
 39e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a4:	0785                	addi	a5,a5,1
 3a6:	fee79de3          	bne	a5,a4,3a0 <memset+0x16>
  }
  return dst;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	cb99                	beqz	a5,3d0 <strchr+0x20>
    if(*s == c)
 3bc:	00f58763          	beq	a1,a5,3ca <strchr+0x1a>
  for(; *s; s++)
 3c0:	0505                	addi	a0,a0,1
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	fbfd                	bnez	a5,3bc <strchr+0xc>
      return (char*)s;
  return 0;
 3c8:	4501                	li	a0,0
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfe5                	j	3ca <strchr+0x1a>

00000000000003d4 <gets>:

char*
gets(char *buf, int max)
{
 3d4:	711d                	addi	sp,sp,-96
 3d6:	ec86                	sd	ra,88(sp)
 3d8:	e8a2                	sd	s0,80(sp)
 3da:	e4a6                	sd	s1,72(sp)
 3dc:	e0ca                	sd	s2,64(sp)
 3de:	fc4e                	sd	s3,56(sp)
 3e0:	f852                	sd	s4,48(sp)
 3e2:	f456                	sd	s5,40(sp)
 3e4:	f05a                	sd	s6,32(sp)
 3e6:	ec5e                	sd	s7,24(sp)
 3e8:	1080                	addi	s0,sp,96
 3ea:	8baa                	mv	s7,a0
 3ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ee:	892a                	mv	s2,a0
 3f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f2:	4aa9                	li	s5,10
 3f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3f6:	89a6                	mv	s3,s1
 3f8:	2485                	addiw	s1,s1,1
 3fa:	0344d863          	bge	s1,s4,42a <gets+0x56>
    cc = read(0, &c, 1);
 3fe:	4605                	li	a2,1
 400:	faf40593          	addi	a1,s0,-81
 404:	4501                	li	a0,0
 406:	00000097          	auipc	ra,0x0
 40a:	1a0080e7          	jalr	416(ra) # 5a6 <read>
    if(cc < 1)
 40e:	00a05e63          	blez	a0,42a <gets+0x56>
    buf[i++] = c;
 412:	faf44783          	lbu	a5,-81(s0)
 416:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41a:	01578763          	beq	a5,s5,428 <gets+0x54>
 41e:	0905                	addi	s2,s2,1
 420:	fd679be3          	bne	a5,s6,3f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 424:	89a6                	mv	s3,s1
 426:	a011                	j	42a <gets+0x56>
 428:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42a:	99de                	add	s3,s3,s7
 42c:	00098023          	sb	zero,0(s3)
  return buf;
}
 430:	855e                	mv	a0,s7
 432:	60e6                	ld	ra,88(sp)
 434:	6446                	ld	s0,80(sp)
 436:	64a6                	ld	s1,72(sp)
 438:	6906                	ld	s2,64(sp)
 43a:	79e2                	ld	s3,56(sp)
 43c:	7a42                	ld	s4,48(sp)
 43e:	7aa2                	ld	s5,40(sp)
 440:	7b02                	ld	s6,32(sp)
 442:	6be2                	ld	s7,24(sp)
 444:	6125                	addi	sp,sp,96
 446:	8082                	ret

0000000000000448 <stat>:

int
stat(const char *n, struct stat *st)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	e426                	sd	s1,8(sp)
 450:	e04a                	sd	s2,0(sp)
 452:	1000                	addi	s0,sp,32
 454:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 456:	4581                	li	a1,0
 458:	00000097          	auipc	ra,0x0
 45c:	176080e7          	jalr	374(ra) # 5ce <open>
  if(fd < 0)
 460:	02054563          	bltz	a0,48a <stat+0x42>
 464:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 466:	85ca                	mv	a1,s2
 468:	00000097          	auipc	ra,0x0
 46c:	17e080e7          	jalr	382(ra) # 5e6 <fstat>
 470:	892a                	mv	s2,a0
  close(fd);
 472:	8526                	mv	a0,s1
 474:	00000097          	auipc	ra,0x0
 478:	142080e7          	jalr	322(ra) # 5b6 <close>
  return r;
}
 47c:	854a                	mv	a0,s2
 47e:	60e2                	ld	ra,24(sp)
 480:	6442                	ld	s0,16(sp)
 482:	64a2                	ld	s1,8(sp)
 484:	6902                	ld	s2,0(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret
    return -1;
 48a:	597d                	li	s2,-1
 48c:	bfc5                	j	47c <stat+0x34>

000000000000048e <atoi>:

int
atoi(const char *s)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 494:	00054603          	lbu	a2,0(a0)
 498:	fd06079b          	addiw	a5,a2,-48
 49c:	0ff7f793          	andi	a5,a5,255
 4a0:	4725                	li	a4,9
 4a2:	02f76963          	bltu	a4,a5,4d4 <atoi+0x46>
 4a6:	86aa                	mv	a3,a0
  n = 0;
 4a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ac:	0685                	addi	a3,a3,1
 4ae:	0025179b          	slliw	a5,a0,0x2
 4b2:	9fa9                	addw	a5,a5,a0
 4b4:	0017979b          	slliw	a5,a5,0x1
 4b8:	9fb1                	addw	a5,a5,a2
 4ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4be:	0006c603          	lbu	a2,0(a3)
 4c2:	fd06071b          	addiw	a4,a2,-48
 4c6:	0ff77713          	andi	a4,a4,255
 4ca:	fee5f1e3          	bgeu	a1,a4,4ac <atoi+0x1e>
  return n;
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret
  n = 0;
 4d4:	4501                	li	a0,0
 4d6:	bfe5                	j	4ce <atoi+0x40>

00000000000004d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4d8:	1141                	addi	sp,sp,-16
 4da:	e422                	sd	s0,8(sp)
 4dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4de:	02b57663          	bgeu	a0,a1,50a <memmove+0x32>
    while(n-- > 0)
 4e2:	02c05163          	blez	a2,504 <memmove+0x2c>
 4e6:	fff6079b          	addiw	a5,a2,-1
 4ea:	1782                	slli	a5,a5,0x20
 4ec:	9381                	srli	a5,a5,0x20
 4ee:	0785                	addi	a5,a5,1
 4f0:	97aa                	add	a5,a5,a0
  dst = vdst;
 4f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f4:	0585                	addi	a1,a1,1
 4f6:	0705                	addi	a4,a4,1
 4f8:	fff5c683          	lbu	a3,-1(a1)
 4fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 500:	fee79ae3          	bne	a5,a4,4f4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 504:	6422                	ld	s0,8(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret
    dst += n;
 50a:	00c50733          	add	a4,a0,a2
    src += n;
 50e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 510:	fec05ae3          	blez	a2,504 <memmove+0x2c>
 514:	fff6079b          	addiw	a5,a2,-1
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	fff7c793          	not	a5,a5
 520:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 522:	15fd                	addi	a1,a1,-1
 524:	177d                	addi	a4,a4,-1
 526:	0005c683          	lbu	a3,0(a1)
 52a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 52e:	fee79ae3          	bne	a5,a4,522 <memmove+0x4a>
 532:	bfc9                	j	504 <memmove+0x2c>

0000000000000534 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 534:	1141                	addi	sp,sp,-16
 536:	e422                	sd	s0,8(sp)
 538:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 53a:	ca05                	beqz	a2,56a <memcmp+0x36>
 53c:	fff6069b          	addiw	a3,a2,-1
 540:	1682                	slli	a3,a3,0x20
 542:	9281                	srli	a3,a3,0x20
 544:	0685                	addi	a3,a3,1
 546:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 548:	00054783          	lbu	a5,0(a0)
 54c:	0005c703          	lbu	a4,0(a1)
 550:	00e79863          	bne	a5,a4,560 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 554:	0505                	addi	a0,a0,1
    p2++;
 556:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 558:	fed518e3          	bne	a0,a3,548 <memcmp+0x14>
  }
  return 0;
 55c:	4501                	li	a0,0
 55e:	a019                	j	564 <memcmp+0x30>
      return *p1 - *p2;
 560:	40e7853b          	subw	a0,a5,a4
}
 564:	6422                	ld	s0,8(sp)
 566:	0141                	addi	sp,sp,16
 568:	8082                	ret
  return 0;
 56a:	4501                	li	a0,0
 56c:	bfe5                	j	564 <memcmp+0x30>

000000000000056e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 56e:	1141                	addi	sp,sp,-16
 570:	e406                	sd	ra,8(sp)
 572:	e022                	sd	s0,0(sp)
 574:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 576:	00000097          	auipc	ra,0x0
 57a:	f62080e7          	jalr	-158(ra) # 4d8 <memmove>
}
 57e:	60a2                	ld	ra,8(sp)
 580:	6402                	ld	s0,0(sp)
 582:	0141                	addi	sp,sp,16
 584:	8082                	ret

0000000000000586 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 586:	4885                	li	a7,1
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <exit>:
.global exit
exit:
 li a7, SYS_exit
 58e:	4889                	li	a7,2
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <wait>:
.global wait
wait:
 li a7, SYS_wait
 596:	488d                	li	a7,3
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 59e:	4891                	li	a7,4
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <read>:
.global read
read:
 li a7, SYS_read
 5a6:	4895                	li	a7,5
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <write>:
.global write
write:
 li a7, SYS_write
 5ae:	48c1                	li	a7,16
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <close>:
.global close
close:
 li a7, SYS_close
 5b6:	48d5                	li	a7,21
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <kill>:
.global kill
kill:
 li a7, SYS_kill
 5be:	4899                	li	a7,6
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c6:	489d                	li	a7,7
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <open>:
.global open
open:
 li a7, SYS_open
 5ce:	48bd                	li	a7,15
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d6:	48c5                	li	a7,17
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5de:	48c9                	li	a7,18
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e6:	48a1                	li	a7,8
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <link>:
.global link
link:
 li a7, SYS_link
 5ee:	48cd                	li	a7,19
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f6:	48d1                	li	a7,20
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fe:	48a5                	li	a7,9
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <dup>:
.global dup
dup:
 li a7, SYS_dup
 606:	48a9                	li	a7,10
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60e:	48ad                	li	a7,11
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 616:	48b1                	li	a7,12
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 61e:	48b5                	li	a7,13
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 626:	48b9                	li	a7,14
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 62e:	48d9                	li	a7,22
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <yield>:
.global yield
yield:
 li a7, SYS_yield
 636:	48dd                	li	a7,23
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <getpa>:
.global getpa
getpa:
 li a7, SYS_getpa
 63e:	48e1                	li	a7,24
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <forkf>:
.global forkf
forkf:
 li a7, SYS_forkf
 646:	48e5                	li	a7,25
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <waitpid>:
.global waitpid
waitpid:
 li a7, SYS_waitpid
 64e:	48e9                	li	a7,26
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <ps>:
.global ps
ps:
 li a7, SYS_ps
 656:	48ed                	li	a7,27
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 65e:	48f1                	li	a7,28
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <forkp>:
.global forkp
forkp:
 li a7, SYS_forkp
 666:	48f5                	li	a7,29
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <schedpolicy>:
.global schedpolicy
schedpolicy:
 li a7, SYS_schedpolicy
 66e:	48f9                	li	a7,30
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <condsleep>:
.global condsleep
condsleep:
 li a7, SYS_condsleep
 676:	48fd                	li	a7,31
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <barrier_alloc>:
.global barrier_alloc
barrier_alloc:
 li a7, SYS_barrier_alloc
 67e:	02000893          	li	a7,32
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <barrier>:
.global barrier
barrier:
 li a7, SYS_barrier
 688:	02100893          	li	a7,33
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <barrier_free>:
.global barrier_free
barrier_free:
 li a7, SYS_barrier_free
 692:	02200893          	li	a7,34
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <buffer_cond_init>:
.global buffer_cond_init
buffer_cond_init:
 li a7, SYS_buffer_cond_init
 69c:	02300893          	li	a7,35
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <cond_consume>:
.global cond_consume
cond_consume:
 li a7, SYS_cond_consume
 6a6:	02500893          	li	a7,37
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <cond_produce>:
.global cond_produce
cond_produce:
 li a7, SYS_cond_produce
 6b0:	02400893          	li	a7,36
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <buffer_sem_init>:
.global buffer_sem_init
buffer_sem_init:
 li a7, SYS_buffer_sem_init
 6ba:	02600893          	li	a7,38
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <sem_consume>:
.global sem_consume
sem_consume:
 li a7, SYS_sem_consume
 6c4:	02800893          	li	a7,40
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <sem_produce>:
.global sem_produce
sem_produce:
 li a7, SYS_sem_produce
 6ce:	02700893          	li	a7,39
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d8:	1101                	addi	sp,sp,-32
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6e4:	4605                	li	a2,1
 6e6:	fef40593          	addi	a1,s0,-17
 6ea:	00000097          	auipc	ra,0x0
 6ee:	ec4080e7          	jalr	-316(ra) # 5ae <write>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6105                	addi	sp,sp,32
 6f8:	8082                	ret

00000000000006fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6fa:	7139                	addi	sp,sp,-64
 6fc:	fc06                	sd	ra,56(sp)
 6fe:	f822                	sd	s0,48(sp)
 700:	f426                	sd	s1,40(sp)
 702:	f04a                	sd	s2,32(sp)
 704:	ec4e                	sd	s3,24(sp)
 706:	0080                	addi	s0,sp,64
 708:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 70a:	c299                	beqz	a3,710 <printint+0x16>
 70c:	0805c863          	bltz	a1,79c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 710:	2581                	sext.w	a1,a1
  neg = 0;
 712:	4881                	li	a7,0
 714:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 718:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 71a:	2601                	sext.w	a2,a2
 71c:	00000517          	auipc	a0,0x0
 720:	4fc50513          	addi	a0,a0,1276 # c18 <digits>
 724:	883a                	mv	a6,a4
 726:	2705                	addiw	a4,a4,1
 728:	02c5f7bb          	remuw	a5,a1,a2
 72c:	1782                	slli	a5,a5,0x20
 72e:	9381                	srli	a5,a5,0x20
 730:	97aa                	add	a5,a5,a0
 732:	0007c783          	lbu	a5,0(a5)
 736:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 73a:	0005879b          	sext.w	a5,a1
 73e:	02c5d5bb          	divuw	a1,a1,a2
 742:	0685                	addi	a3,a3,1
 744:	fec7f0e3          	bgeu	a5,a2,724 <printint+0x2a>
  if(neg)
 748:	00088b63          	beqz	a7,75e <printint+0x64>
    buf[i++] = '-';
 74c:	fd040793          	addi	a5,s0,-48
 750:	973e                	add	a4,a4,a5
 752:	02d00793          	li	a5,45
 756:	fef70823          	sb	a5,-16(a4)
 75a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 75e:	02e05863          	blez	a4,78e <printint+0x94>
 762:	fc040793          	addi	a5,s0,-64
 766:	00e78933          	add	s2,a5,a4
 76a:	fff78993          	addi	s3,a5,-1
 76e:	99ba                	add	s3,s3,a4
 770:	377d                	addiw	a4,a4,-1
 772:	1702                	slli	a4,a4,0x20
 774:	9301                	srli	a4,a4,0x20
 776:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 77a:	fff94583          	lbu	a1,-1(s2)
 77e:	8526                	mv	a0,s1
 780:	00000097          	auipc	ra,0x0
 784:	f58080e7          	jalr	-168(ra) # 6d8 <putc>
  while(--i >= 0)
 788:	197d                	addi	s2,s2,-1
 78a:	ff3918e3          	bne	s2,s3,77a <printint+0x80>
}
 78e:	70e2                	ld	ra,56(sp)
 790:	7442                	ld	s0,48(sp)
 792:	74a2                	ld	s1,40(sp)
 794:	7902                	ld	s2,32(sp)
 796:	69e2                	ld	s3,24(sp)
 798:	6121                	addi	sp,sp,64
 79a:	8082                	ret
    x = -xx;
 79c:	40b005bb          	negw	a1,a1
    neg = 1;
 7a0:	4885                	li	a7,1
    x = -xx;
 7a2:	bf8d                	j	714 <printint+0x1a>

00000000000007a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7a4:	7119                	addi	sp,sp,-128
 7a6:	fc86                	sd	ra,120(sp)
 7a8:	f8a2                	sd	s0,112(sp)
 7aa:	f4a6                	sd	s1,104(sp)
 7ac:	f0ca                	sd	s2,96(sp)
 7ae:	ecce                	sd	s3,88(sp)
 7b0:	e8d2                	sd	s4,80(sp)
 7b2:	e4d6                	sd	s5,72(sp)
 7b4:	e0da                	sd	s6,64(sp)
 7b6:	fc5e                	sd	s7,56(sp)
 7b8:	f862                	sd	s8,48(sp)
 7ba:	f466                	sd	s9,40(sp)
 7bc:	f06a                	sd	s10,32(sp)
 7be:	ec6e                	sd	s11,24(sp)
 7c0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7c2:	0005c903          	lbu	s2,0(a1)
 7c6:	18090f63          	beqz	s2,964 <vprintf+0x1c0>
 7ca:	8aaa                	mv	s5,a0
 7cc:	8b32                	mv	s6,a2
 7ce:	00158493          	addi	s1,a1,1
  state = 0;
 7d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7d4:	02500a13          	li	s4,37
      if(c == 'd'){
 7d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7dc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7e0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7e4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	00000b97          	auipc	s7,0x0
 7ec:	430b8b93          	addi	s7,s7,1072 # c18 <digits>
 7f0:	a839                	j	80e <vprintf+0x6a>
        putc(fd, c);
 7f2:	85ca                	mv	a1,s2
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	ee2080e7          	jalr	-286(ra) # 6d8 <putc>
 7fe:	a019                	j	804 <vprintf+0x60>
    } else if(state == '%'){
 800:	01498f63          	beq	s3,s4,81e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 804:	0485                	addi	s1,s1,1
 806:	fff4c903          	lbu	s2,-1(s1)
 80a:	14090d63          	beqz	s2,964 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 80e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 812:	fe0997e3          	bnez	s3,800 <vprintf+0x5c>
      if(c == '%'){
 816:	fd479ee3          	bne	a5,s4,7f2 <vprintf+0x4e>
        state = '%';
 81a:	89be                	mv	s3,a5
 81c:	b7e5                	j	804 <vprintf+0x60>
      if(c == 'd'){
 81e:	05878063          	beq	a5,s8,85e <vprintf+0xba>
      } else if(c == 'l') {
 822:	05978c63          	beq	a5,s9,87a <vprintf+0xd6>
      } else if(c == 'x') {
 826:	07a78863          	beq	a5,s10,896 <vprintf+0xf2>
      } else if(c == 'p') {
 82a:	09b78463          	beq	a5,s11,8b2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 82e:	07300713          	li	a4,115
 832:	0ce78663          	beq	a5,a4,8fe <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 836:	06300713          	li	a4,99
 83a:	0ee78e63          	beq	a5,a4,936 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 83e:	11478863          	beq	a5,s4,94e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 842:	85d2                	mv	a1,s4
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	e92080e7          	jalr	-366(ra) # 6d8 <putc>
        putc(fd, c);
 84e:	85ca                	mv	a1,s2
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e86080e7          	jalr	-378(ra) # 6d8 <putc>
      }
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b765                	j	804 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 85e:	008b0913          	addi	s2,s6,8
 862:	4685                	li	a3,1
 864:	4629                	li	a2,10
 866:	000b2583          	lw	a1,0(s6)
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	e8e080e7          	jalr	-370(ra) # 6fa <printint>
 874:	8b4a                	mv	s6,s2
      state = 0;
 876:	4981                	li	s3,0
 878:	b771                	j	804 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 87a:	008b0913          	addi	s2,s6,8
 87e:	4681                	li	a3,0
 880:	4629                	li	a2,10
 882:	000b2583          	lw	a1,0(s6)
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	e72080e7          	jalr	-398(ra) # 6fa <printint>
 890:	8b4a                	mv	s6,s2
      state = 0;
 892:	4981                	li	s3,0
 894:	bf85                	j	804 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 896:	008b0913          	addi	s2,s6,8
 89a:	4681                	li	a3,0
 89c:	4641                	li	a2,16
 89e:	000b2583          	lw	a1,0(s6)
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	e56080e7          	jalr	-426(ra) # 6fa <printint>
 8ac:	8b4a                	mv	s6,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	bf91                	j	804 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8b2:	008b0793          	addi	a5,s6,8
 8b6:	f8f43423          	sd	a5,-120(s0)
 8ba:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8be:	03000593          	li	a1,48
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e14080e7          	jalr	-492(ra) # 6d8 <putc>
  putc(fd, 'x');
 8cc:	85ea                	mv	a1,s10
 8ce:	8556                	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e08080e7          	jalr	-504(ra) # 6d8 <putc>
 8d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8da:	03c9d793          	srli	a5,s3,0x3c
 8de:	97de                	add	a5,a5,s7
 8e0:	0007c583          	lbu	a1,0(a5)
 8e4:	8556                	mv	a0,s5
 8e6:	00000097          	auipc	ra,0x0
 8ea:	df2080e7          	jalr	-526(ra) # 6d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ee:	0992                	slli	s3,s3,0x4
 8f0:	397d                	addiw	s2,s2,-1
 8f2:	fe0914e3          	bnez	s2,8da <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8f6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	b721                	j	804 <vprintf+0x60>
        s = va_arg(ap, char*);
 8fe:	008b0993          	addi	s3,s6,8
 902:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 906:	02090163          	beqz	s2,928 <vprintf+0x184>
        while(*s != 0){
 90a:	00094583          	lbu	a1,0(s2)
 90e:	c9a1                	beqz	a1,95e <vprintf+0x1ba>
          putc(fd, *s);
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	dc6080e7          	jalr	-570(ra) # 6d8 <putc>
          s++;
 91a:	0905                	addi	s2,s2,1
        while(*s != 0){
 91c:	00094583          	lbu	a1,0(s2)
 920:	f9e5                	bnez	a1,910 <vprintf+0x16c>
        s = va_arg(ap, char*);
 922:	8b4e                	mv	s6,s3
      state = 0;
 924:	4981                	li	s3,0
 926:	bdf9                	j	804 <vprintf+0x60>
          s = "(null)";
 928:	00000917          	auipc	s2,0x0
 92c:	2e890913          	addi	s2,s2,744 # c10 <malloc+0x1a2>
        while(*s != 0){
 930:	02800593          	li	a1,40
 934:	bff1                	j	910 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 936:	008b0913          	addi	s2,s6,8
 93a:	000b4583          	lbu	a1,0(s6)
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	d98080e7          	jalr	-616(ra) # 6d8 <putc>
 948:	8b4a                	mv	s6,s2
      state = 0;
 94a:	4981                	li	s3,0
 94c:	bd65                	j	804 <vprintf+0x60>
        putc(fd, c);
 94e:	85d2                	mv	a1,s4
 950:	8556                	mv	a0,s5
 952:	00000097          	auipc	ra,0x0
 956:	d86080e7          	jalr	-634(ra) # 6d8 <putc>
      state = 0;
 95a:	4981                	li	s3,0
 95c:	b565                	j	804 <vprintf+0x60>
        s = va_arg(ap, char*);
 95e:	8b4e                	mv	s6,s3
      state = 0;
 960:	4981                	li	s3,0
 962:	b54d                	j	804 <vprintf+0x60>
    }
  }
}
 964:	70e6                	ld	ra,120(sp)
 966:	7446                	ld	s0,112(sp)
 968:	74a6                	ld	s1,104(sp)
 96a:	7906                	ld	s2,96(sp)
 96c:	69e6                	ld	s3,88(sp)
 96e:	6a46                	ld	s4,80(sp)
 970:	6aa6                	ld	s5,72(sp)
 972:	6b06                	ld	s6,64(sp)
 974:	7be2                	ld	s7,56(sp)
 976:	7c42                	ld	s8,48(sp)
 978:	7ca2                	ld	s9,40(sp)
 97a:	7d02                	ld	s10,32(sp)
 97c:	6de2                	ld	s11,24(sp)
 97e:	6109                	addi	sp,sp,128
 980:	8082                	ret

0000000000000982 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 982:	715d                	addi	sp,sp,-80
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	1000                	addi	s0,sp,32
 98a:	e010                	sd	a2,0(s0)
 98c:	e414                	sd	a3,8(s0)
 98e:	e818                	sd	a4,16(s0)
 990:	ec1c                	sd	a5,24(s0)
 992:	03043023          	sd	a6,32(s0)
 996:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 99a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 99e:	8622                	mv	a2,s0
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e04080e7          	jalr	-508(ra) # 7a4 <vprintf>
}
 9a8:	60e2                	ld	ra,24(sp)
 9aa:	6442                	ld	s0,16(sp)
 9ac:	6161                	addi	sp,sp,80
 9ae:	8082                	ret

00000000000009b0 <printf>:

void
printf(const char *fmt, ...)
{
 9b0:	711d                	addi	sp,sp,-96
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	1000                	addi	s0,sp,32
 9b8:	e40c                	sd	a1,8(s0)
 9ba:	e810                	sd	a2,16(s0)
 9bc:	ec14                	sd	a3,24(s0)
 9be:	f018                	sd	a4,32(s0)
 9c0:	f41c                	sd	a5,40(s0)
 9c2:	03043823          	sd	a6,48(s0)
 9c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ca:	00840613          	addi	a2,s0,8
 9ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9d2:	85aa                	mv	a1,a0
 9d4:	4505                	li	a0,1
 9d6:	00000097          	auipc	ra,0x0
 9da:	dce080e7          	jalr	-562(ra) # 7a4 <vprintf>
}
 9de:	60e2                	ld	ra,24(sp)
 9e0:	6442                	ld	s0,16(sp)
 9e2:	6125                	addi	sp,sp,96
 9e4:	8082                	ret

00000000000009e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e6:	1141                	addi	sp,sp,-16
 9e8:	e422                	sd	s0,8(sp)
 9ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f0:	00000797          	auipc	a5,0x0
 9f4:	2407b783          	ld	a5,576(a5) # c30 <freep>
 9f8:	a805                	j	a28 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9fa:	4618                	lw	a4,8(a2)
 9fc:	9db9                	addw	a1,a1,a4
 9fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a02:	6398                	ld	a4,0(a5)
 a04:	6318                	ld	a4,0(a4)
 a06:	fee53823          	sd	a4,-16(a0)
 a0a:	a091                	j	a4e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a0c:	ff852703          	lw	a4,-8(a0)
 a10:	9e39                	addw	a2,a2,a4
 a12:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a14:	ff053703          	ld	a4,-16(a0)
 a18:	e398                	sd	a4,0(a5)
 a1a:	a099                	j	a60 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1c:	6398                	ld	a4,0(a5)
 a1e:	00e7e463          	bltu	a5,a4,a26 <free+0x40>
 a22:	00e6ea63          	bltu	a3,a4,a36 <free+0x50>
{
 a26:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a28:	fed7fae3          	bgeu	a5,a3,a1c <free+0x36>
 a2c:	6398                	ld	a4,0(a5)
 a2e:	00e6e463          	bltu	a3,a4,a36 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a32:	fee7eae3          	bltu	a5,a4,a26 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a36:	ff852583          	lw	a1,-8(a0)
 a3a:	6390                	ld	a2,0(a5)
 a3c:	02059713          	slli	a4,a1,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	9736                	add	a4,a4,a3
 a46:	fae60ae3          	beq	a2,a4,9fa <free+0x14>
    bp->s.ptr = p->s.ptr;
 a4a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a4e:	4790                	lw	a2,8(a5)
 a50:	02061713          	slli	a4,a2,0x20
 a54:	9301                	srli	a4,a4,0x20
 a56:	0712                	slli	a4,a4,0x4
 a58:	973e                	add	a4,a4,a5
 a5a:	fae689e3          	beq	a3,a4,a0c <free+0x26>
  } else
    p->s.ptr = bp;
 a5e:	e394                	sd	a3,0(a5)
  freep = p;
 a60:	00000717          	auipc	a4,0x0
 a64:	1cf73823          	sd	a5,464(a4) # c30 <freep>
}
 a68:	6422                	ld	s0,8(sp)
 a6a:	0141                	addi	sp,sp,16
 a6c:	8082                	ret

0000000000000a6e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a6e:	7139                	addi	sp,sp,-64
 a70:	fc06                	sd	ra,56(sp)
 a72:	f822                	sd	s0,48(sp)
 a74:	f426                	sd	s1,40(sp)
 a76:	f04a                	sd	s2,32(sp)
 a78:	ec4e                	sd	s3,24(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
 a80:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	02051493          	slli	s1,a0,0x20
 a86:	9081                	srli	s1,s1,0x20
 a88:	04bd                	addi	s1,s1,15
 a8a:	8091                	srli	s1,s1,0x4
 a8c:	0014899b          	addiw	s3,s1,1
 a90:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a92:	00000517          	auipc	a0,0x0
 a96:	19e53503          	ld	a0,414(a0) # c30 <freep>
 a9a:	c515                	beqz	a0,ac6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9e:	4798                	lw	a4,8(a5)
 aa0:	02977f63          	bgeu	a4,s1,ade <malloc+0x70>
 aa4:	8a4e                	mv	s4,s3
 aa6:	0009871b          	sext.w	a4,s3
 aaa:	6685                	lui	a3,0x1
 aac:	00d77363          	bgeu	a4,a3,ab2 <malloc+0x44>
 ab0:	6a05                	lui	s4,0x1
 ab2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ab6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aba:	00000917          	auipc	s2,0x0
 abe:	17690913          	addi	s2,s2,374 # c30 <freep>
  if(p == (char*)-1)
 ac2:	5afd                	li	s5,-1
 ac4:	a88d                	j	b36 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ac6:	00000797          	auipc	a5,0x0
 aca:	18278793          	addi	a5,a5,386 # c48 <base>
 ace:	00000717          	auipc	a4,0x0
 ad2:	16f73123          	sd	a5,354(a4) # c30 <freep>
 ad6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 adc:	b7e1                	j	aa4 <malloc+0x36>
      if(p->s.size == nunits)
 ade:	02e48b63          	beq	s1,a4,b14 <malloc+0xa6>
        p->s.size -= nunits;
 ae2:	4137073b          	subw	a4,a4,s3
 ae6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae8:	1702                	slli	a4,a4,0x20
 aea:	9301                	srli	a4,a4,0x20
 aec:	0712                	slli	a4,a4,0x4
 aee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af4:	00000717          	auipc	a4,0x0
 af8:	12a73e23          	sd	a0,316(a4) # c30 <freep>
      return (void*)(p + 1);
 afc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b00:	70e2                	ld	ra,56(sp)
 b02:	7442                	ld	s0,48(sp)
 b04:	74a2                	ld	s1,40(sp)
 b06:	7902                	ld	s2,32(sp)
 b08:	69e2                	ld	s3,24(sp)
 b0a:	6a42                	ld	s4,16(sp)
 b0c:	6aa2                	ld	s5,8(sp)
 b0e:	6b02                	ld	s6,0(sp)
 b10:	6121                	addi	sp,sp,64
 b12:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b14:	6398                	ld	a4,0(a5)
 b16:	e118                	sd	a4,0(a0)
 b18:	bff1                	j	af4 <malloc+0x86>
  hp->s.size = nu;
 b1a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b1e:	0541                	addi	a0,a0,16
 b20:	00000097          	auipc	ra,0x0
 b24:	ec6080e7          	jalr	-314(ra) # 9e6 <free>
  return freep;
 b28:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b2c:	d971                	beqz	a0,b00 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b30:	4798                	lw	a4,8(a5)
 b32:	fa9776e3          	bgeu	a4,s1,ade <malloc+0x70>
    if(p == freep)
 b36:	00093703          	ld	a4,0(s2)
 b3a:	853e                	mv	a0,a5
 b3c:	fef719e3          	bne	a4,a5,b2e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b40:	8552                	mv	a0,s4
 b42:	00000097          	auipc	ra,0x0
 b46:	ad4080e7          	jalr	-1324(ra) # 616 <sbrk>
  if(p == (char*)-1)
 b4a:	fd5518e3          	bne	a0,s5,b1a <malloc+0xac>
        return 0;
 b4e:	4501                	li	a0,0
 b50:	bf45                	j	b00 <malloc+0x92>
