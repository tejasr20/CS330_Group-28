// #include "proc.h"
#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"
#include "semaphore.h"
// #include "condvar.h"
// #include "sleeplock.h"

void sem_init(struct semaphore *s, int x)
{
	// initsleeplock(&(s->cv->lk),"sem_cv_lock");
	// initsleeplock(&(s->lk),"sem_lock");
	s->v= x;
    return;
}

void sem_wait(struct semaphore *s)
{
    acquiresleep(&(s->lk));
	while(s->v==0)
	{
		condsleep(s->cv,&(s->lk));
	}
	s->v= s->v -1;
	releasesleep(&(s->lk));
	return;
}

void sem_post(struct semaphore *s)
{
    acquiresleep(&(s->lk));
	s->v= s->v +1;
	cond_signal((s->cv));
	releasesleep(&(s->lk));
    return;
}
