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
// #include "condvar.h"
// #include "sleeplock.h"
void cond_wait (struct cond_t *cv, struct sleeplock *lock)
{
    condsleep(cv,lock);
    return;
}
void cond_signal(struct cond_t *cv)
{
    wakeupone(cv);
    return;
}

void cond_broadcast (struct cond_t *cv)
{
    wakeup(cv);
    return;
}