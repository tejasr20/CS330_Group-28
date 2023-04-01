#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "procstat.h"
// #include "sleeplock.h"
#include "condvar.h"
#include "barrier.h"
#include "boundedBuffer.h"
#include<stdlib.h>
// #include "semaphore.h"
#include "semaphore.h"

int sched_policy;

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

struct barrier barriers[10];

struct buffer_elem buffer[20];
struct sem_buffer_elem sem_buffer[20];

struct sleeplock lock_delete;
struct sleeplock lock_insert;
struct sleeplock lock_print;
struct sleeplock lock_sem_delete;
struct sleeplock lock_sem_insert;
struct sleeplock lock_sem_print;

struct semaphore empty;
struct semaphore full;
struct semaphore pro;
struct semaphore con;
int nextp=0;
int nextc=0;

int head=0;
int tail=0;


//Stats
static int batch_start = 0x7FFFFFFF;
static int batchsize = 0;
static int batchsize2 = 0;
static int turnaround = 0;
static int completion_tot = 0;
static int waiting_tot = 0;
static int completion_max = 0;
static int completion_min = 0x7FFFFFFF;
static int num_cpubursts = 0;
static int cpubursts_tot = 0;
static int cpubursts_max = 0;
static int cpubursts_min = 0x7FFFFFFF;
static int num_cpubursts_est = 0;

static int cpubursts_est_tot = 0;
static int cpubursts_est_max = 0;
static int cpubursts_est_min = 0x7FFFFFFF;
static int estimation_error = 0;
static int estimation_error_instance = 0;

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table at boot time.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->kstack = KSTACK((int) (p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid() {
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  uint xticks;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);

  p->ctime = xticks;
  p->stime = -1;
  p->endtime = -1;

  p->is_batchproc = 0;
  p->cpu_usage = 0;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process,
// with no user memory, but with trampoline pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe just below TRAMPOLINE, for trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// od -t xC initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // allocate one user page and copy init's instructions
  // and data into it.
  uvminit(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
  p->trapframe->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

int
forkf(uint64 faddr)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;
  // Make child to jump to function
  np->trapframe->epc = faddr;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
forkp(int priority)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  np->base_priority = priority;

  np->is_batchproc = 1;
  np->nextburst_estimate = 0;
  np->waittime = 0;

  release(&np->lock);

  batchsize++;
  batchsize2++;

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  np->waitstart = np->ctime;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();
  uint xticks;

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);

  p->endtime = xticks;

  if (p->is_batchproc) {

     if ((xticks - p->burst_start) > 0) {
        num_cpubursts++;
        cpubursts_tot += (xticks - p->burst_start);
        if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
        if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
        if (p->nextburst_estimate > 0) {
           estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
           estimation_error_instance++;
        }
        p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
        if (p->nextburst_estimate > 0) {
           num_cpubursts_est++;
           cpubursts_est_tot += p->nextburst_estimate;
           if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
           if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
        }
     }

     if (p->stime < batch_start) batch_start = p->stime;
     batchsize--;
     turnaround += (p->endtime - p->stime);
     waiting_tot += p->waittime;
     completion_tot += p->endtime;
     if (p->endtime > completion_max) completion_max = p->endtime;
     if (p->endtime < completion_min) completion_min = p->endtime;
     if (batchsize == 0) {
        printf("\nBatch execution time: %d\n", p->endtime - batch_start);
	printf("Average turn-around time: %d\n", turnaround/batchsize2);
	printf("Average waiting time: %d\n", waiting_tot/batchsize2);
	printf("Completion time: avg: %d, max: %d, min: %d\n", completion_tot/batchsize2, completion_max, completion_min);
	if ((sched_policy == SCHED_NPREEMPT_FCFS) || (sched_policy == SCHED_NPREEMPT_SJF)) {
	   printf("CPU bursts: count: %d, avg: %d, max: %d, min: %d\n", num_cpubursts, cpubursts_tot/num_cpubursts, cpubursts_max, cpubursts_min);
	   printf("CPU burst estimates: count: %d, avg: %d, max: %d, min: %d\n", num_cpubursts_est, cpubursts_est_tot/num_cpubursts_est, cpubursts_est_max, cpubursts_est_min);
	   printf("CPU burst estimation error: count: %d, avg: %d\n", estimation_error_instance, estimation_error/estimation_error_instance);
	}
	batchsize2 = 0;
	batch_start = 0x7FFFFFFF;
	turnaround = 0;
	waiting_tot = 0;
	completion_tot = 0;
	completion_max = 0;
	completion_min = 0x7FFFFFFF;
	num_cpubursts = 0;
        cpubursts_tot = 0;
        cpubursts_max = 0;
        cpubursts_min = 0x7FFFFFFF;
	num_cpubursts_est = 0;
        cpubursts_est_tot = 0;
        cpubursts_est_max = 0;
        cpubursts_est_min = 0x7FFFFFFF;
	estimation_error = 0;
        estimation_error_instance = 0;
     }
  }

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      if(np->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if(np->state == ZOMBIE){
          // Found one.
          pid = np->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                  sizeof(np->xstate)) < 0) {
            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || p->killed){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

int
waitpid(int pid, uint64 addr)
{
  struct proc *np;
  struct proc *p = myproc();
  int found=0;

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for child with pid
    for(np = proc; np < &proc[NPROC]; np++){
      if((np->parent == p) && (np->pid == pid)){
	found = 1;
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        if(np->state == ZOMBIE){
           if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                  sizeof(np->xstate)) < 0) {
             release(&np->lock);
             release(&wait_lock);
             return -1;
           }
           freeproc(np);
           release(&np->lock);
           release(&wait_lock);
           return pid;
	}

        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!found || p->killed){
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct proc *q;
  struct cpu *c = mycpu();
  uint xticks;
  int min_burst, min_prio;
  
  c->proc = 0;
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    if (sched_policy == SCHED_NPREEMPT_SJF) {
       min_burst = 0x7FFFFFFF;
       acquire(&tickslock);
       xticks = ticks;
       release(&tickslock);
       q = 0;
       for(p = proc; p < &proc[NPROC]; p++) {
          acquire(&p->lock);
	  if(p->state == RUNNABLE) {
	     if (!p->is_batchproc) {
                if (q) release(&q->lock);
		q = p;  // Allow main to finish
		break;
	     }
             else if (p->nextburst_estimate < min_burst) {
	        min_burst = p->nextburst_estimate;
		if (q) release(&q->lock);
		q = p;
	     }
             else release(&p->lock);
	  }
	  else release(&p->lock);
       }
       if (q) {
          q->state = RUNNING;
          q->waittime += (xticks - q->waitstart);
          q->burst_start = xticks;
          c->proc = q;
          swtch(&c->context, &q->context);

          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
	  release(&q->lock);
       }
    }
    else if (sched_policy == SCHED_PREEMPT_UNIX) {
       min_prio = 0x7FFFFFFF;
       acquire(&tickslock);
       xticks = ticks;
       release(&tickslock);
       for(p = proc; p < &proc[NPROC]; p++) {
          acquire(&p->lock);
	  if(p->state == RUNNABLE) {
	     p->cpu_usage = p->cpu_usage/2;
	     p->priority = p->base_priority + (p->cpu_usage/2);
	  }
	  release(&p->lock);
       }
       q = 0;
       for(p = proc; p < &proc[NPROC]; p++) {
          acquire(&p->lock);
          if(p->state == RUNNABLE) {
             if (!p->is_batchproc) {
                if (q) release(&q->lock);
                q = p;  // Allow main to finish
                break;
             }
             else if (p->priority < min_prio) {
                min_prio = p->priority;
                if (q) release(&q->lock);
                q = p;
             }
             else release(&p->lock);
          }
          else release(&p->lock);
       }
       if (q) {
          q->state = RUNNING;
          q->waittime += (xticks - q->waitstart);
          q->burst_start = xticks;
          c->proc = q;
          swtch(&c->context, &q->context);

          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
          release(&q->lock);
       }
    }
    else {
       for(p = proc; p < &proc[NPROC]; p++) {
          if ((sched_policy != SCHED_NPREEMPT_FCFS) && (sched_policy != SCHED_PREEMPT_RR)) break;
          acquire(&tickslock);
          xticks = ticks;
          release(&tickslock);
          acquire(&p->lock);
          if(p->state == RUNNABLE) {
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
	    p->waittime += (xticks - p->waitstart);
	    p->burst_start = xticks;
            c->proc = p;
            swtch(&c->context, &p->context);

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
          }
          release(&p->lock);
       }
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);

  acquire(&p->lock);
  p->state = RUNNABLE;
  p->waitstart = xticks;
  p->cpu_usage += SCHED_PARAM_CPU_USAGE;
  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
     num_cpubursts++;
     cpubursts_tot += (xticks - p->burst_start);
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
     if (p->nextburst_estimate > 0) {
        estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
	estimation_error_instance++;
     }
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
     if (p->nextburst_estimate > 0) {
        num_cpubursts_est++;
        cpubursts_est_tot += p->nextburst_estimate;
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
     }
  }
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;
  uint xticks;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);

  myproc()->stime = xticks;

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  uint xticks;

  if (!holding(&tickslock)) {
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  p->cpu_usage += (SCHED_PARAM_CPU_USAGE/2);

  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
     num_cpubursts++;
     cpubursts_tot += (xticks - p->burst_start);
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
     if (p->nextburst_estimate > 0) {
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
        estimation_error_instance++;
     }
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
     if (p->nextburst_estimate > 0) {
        num_cpubursts_est++;
        cpubursts_est_tot += p->nextburst_estimate;
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
     }
  }

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;
  uint xticks;

  if (!holding(&tickslock)) {
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
	p->waitstart = xticks;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
  struct proc *p;
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
	p->waitstart = xticks;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

// Print a process listing to console with proper locks held.
// Caution: don't invoke too often; can slow down the machine.
int
ps(void)
{
   static char *states[] = {
  [UNUSED]    "unused",
  [SLEEPING]  "sleep",
  [RUNNABLE]  "runble",
  [RUNNING]   "run",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;
  int ppid, pid;
  uint xticks;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->state == UNUSED) {
      release(&p->lock);
      continue;
    }
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";

    pid = p->pid;
    release(&p->lock);
    acquire(&wait_lock);
    if (p->parent) {
       acquire(&p->parent->lock);
       ppid = p->parent->pid;
       release(&p->parent->lock);
    }
    else ppid = -1;
    release(&wait_lock);

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);

    printf("pid=%d, ppid=%d, state=%s, cmd=%s, ctime=%d, stime=%d, etime=%d, size=%p", pid, ppid, state, p->name, p->ctime, p->stime, (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime, p->sz);
    printf("\n");
  }
  return 0;
}

int
pinfo(int pid, uint64 addr)
{
   struct procstat pstat;

   static char *states[] = {
  [UNUSED]    "unused",
  [SLEEPING]  "sleep",
  [RUNNABLE]  "runble",
  [RUNNING]   "run",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;
  uint xticks;
  int found=0;

  if (pid == -1) {
     p = myproc();
     acquire(&p->lock);
     found=1;
  }
  else {
     for(p = proc; p < &proc[NPROC]; p++){
       acquire(&p->lock);
       if((p->state == UNUSED) || (p->pid != pid)) {
         release(&p->lock);
         continue;
       }
       else {
         found=1;
         break;
       }
     }
  }
  if (found) {
     if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
         state = states[p->state];
     else
         state = "???";

     pstat.pid = p->pid;
     release(&p->lock);
     acquire(&wait_lock);
     if (p->parent) {
        acquire(&p->parent->lock);
        pstat.ppid = p->parent->pid;
        release(&p->parent->lock);
     }
     else pstat.ppid = -1;
     release(&wait_lock);

     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);

     safestrcpy(&pstat.state[0], state, strlen(state)+1);
     safestrcpy(&pstat.command[0], &p->name[0], sizeof(p->name));
     pstat.ctime = p->ctime;
     pstat.stime = p->stime;
     pstat.etime = (p->endtime == -1) ? xticks-p->stime : p->endtime-p->stime;
     pstat.size = p->sz;
     if(copyout(myproc()->pagetable, addr, (char *)&pstat, sizeof(pstat)) < 0) return -1;
     return 0;
  }
  else return -1;
}

int
schedpolicy(int x)
{
   int y = sched_policy;
   sched_policy = x;
   return y;
}


void condsleep(struct cond_t* cv, struct sleeplock* lock)
{
  struct proc *p = myproc();
  uint xticks;

  if (!holding(&tickslock)) {
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  releasesleep(lock);

  // Go to sleep.
  p->chan = cv;
  p->state = SLEEPING;

  p->cpu_usage += (SCHED_PARAM_CPU_USAGE/2);

  if ((p->is_batchproc) && ((xticks - p->burst_start) > 0)) {
     num_cpubursts++;
     cpubursts_tot += (xticks - p->burst_start);
     if (cpubursts_max < (xticks - p->burst_start)) cpubursts_max = xticks - p->burst_start;
     if (cpubursts_min > (xticks - p->burst_start)) cpubursts_min = xticks - p->burst_start;
     if (p->nextburst_estimate > 0) {
	estimation_error += ((p->nextburst_estimate >= (xticks - p->burst_start)) ? (p->nextburst_estimate - (xticks - p->burst_start)) : ((xticks - p->burst_start) - p->nextburst_estimate));
        estimation_error_instance++;
     }
     p->nextburst_estimate = (xticks - p->burst_start) - ((xticks - p->burst_start)*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM + (p->nextburst_estimate*SCHED_PARAM_SJF_A_NUMER)/SCHED_PARAM_SJF_A_DENOM;
     if (p->nextburst_estimate > 0) {
        num_cpubursts_est++;
        cpubursts_est_tot += p->nextburst_estimate;
        if (cpubursts_est_max < p->nextburst_estimate) cpubursts_est_max = p->nextburst_estimate;
        if (cpubursts_est_min > p->nextburst_estimate) cpubursts_est_min = p->nextburst_estimate;
     }
  }

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquiresleep(lock);
}


void
wakeupone(void *chan)
{
  struct proc *p;
  uint xticks;

  if (!holding(&tickslock)) {
     acquire(&tickslock);
     xticks = ticks;
     release(&tickslock);
  }
  else xticks = ticks;
  int flag=0;
  for(p = proc; p < &proc[NPROC]; p++) {
    if(flag)
    {
      return;
    }
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
	p->waitstart = xticks;
  flag=1;
//   return;
      }
      release(&p->lock);
    }
  }
}




int 
barrier_alloc(void)
{
	for(int i=0;i<10;i++)
	{
		if(barriers[i].free==0)
		{
			barriers[i].free=1;
			barriers[i].count=0; // number of threads waiting at the barrier 
			initsleeplock(&(barriers[i].barrier_lock), "barrier_lock");
			initsleeplock(&(barriers[i].print_lock), "print_lock");
			initsleeplock(&(barriers[i].barrier_cond.lk), "print_lock");
			return i;
		}
	}
	return -1;// in case when none of the barriers are free? 
}

// how to implement a barrier? You want n processes to wait on a barrier, when the number of processes waiting 
// becomes the required number then you can release the barrier. So we should wait on a conditional variable cv
// to become equal to n_processes, then you can broadcast to all the processes stuck at the barrier 

int  // bin= barrier instance number, id= barrier array id, and n= number of processes
barrier(int bin, int id, int n)
{
  // int pid=myproc()->pid;
  
  struct proc* p= myproc();
  int pid= p->pid;
	acquiresleep(&(barriers[id].print_lock));
	printf("%d: Entered barrier#%d for barrier array id %d\n",pid,bin, id);
	releasesleep(&(barriers[id].print_lock));
	
	// acquire(&p->lock);
	
	// release(&p->lock);
	acquiresleep(&(barriers[id].barrier_lock));
	barriers[id].count++;
	if (barriers[id].count == n) {
		barriers[id].count = 0;
		wakeup(&(barriers[id].barrier_cond)); //broadcast 
	}
	else cond_wait(&(barriers[id]).barrier_cond,  &(barriers[id].barrier_lock));
	releasesleep(&(barriers[id].barrier_lock));
	acquiresleep(&(barriers[id].print_lock));
	printf("%d: Finished barrier#%d for barrier array id %d\n",pid,bin, id);
	releasesleep(&(barriers[id].print_lock));
	return 0;
}

int  // free barrier_id = id
barrier_free(int id)
{
	// struct barrier temp;
	// temp.free=0;
	// barriers[id]=temp;
  barriers[id].free=0;

	return 0;
}




void buffer_cond_init(void)
{
  // struct buffer buff;
  // buff.head=0;
  // buff.tail=0;
  // for(int i=0;i<20;i++)
  // {
  //   buff.buffer[i].x=-1;
  //   buff.buffer[i].full=0;
  // }
    //  struct sleeplock lock;
    // struct cond_t inserted;
    // struct cond_t deleted;

  // buffer=buff;
	initsleeplock(&(lock_print), "lock_print");
	initsleeplock(&(lock_delete), "lock_delete");
	initsleeplock(&(lock_insert), "lock_insert");
  for(int i=0;i<20;i++)
  {
    // char* s= to_string()
	initsleeplock(&(buffer[i].lock), "lock");
	initsleeplock(&(buffer[i].inserted.lk), "inserted_lock");
	initsleeplock(&(buffer[i].deleted.lk), "deleted_lock");
	buffer[i].x=-1;
    buffer[i].full=0;
  }
  return;
}

void cond_produce(int x)
{
  int index;
  acquiresleep(&lock_insert);
  index=tail;
  tail=(tail+1)%20;
  releasesleep(&lock_insert);
  acquiresleep(&buffer[index].lock);
  while (buffer[index].full) {
    condsleep(&(buffer[index].deleted), &(buffer[index].lock));
  }
  buffer[index].x = x;
  buffer[index].full = 1;
  cond_signal(&(buffer[index].inserted));
  releasesleep(&(buffer[index].lock));
}


int cond_consume(void)
{
  int v, index;
  acquiresleep(&(lock_delete));
  index=head;
  head=(head+1)%20;
  releasesleep(&(lock_delete));
  acquiresleep(&(buffer[index].lock));
  while (!(buffer[index].full)) {
  condsleep(&(buffer[index].inserted), &(buffer[index].lock));
  }
  v = buffer[index].x;
  buffer[index].full = 0;
  cond_signal(&(buffer[index].deleted));
  releasesleep(&(buffer[index].lock));
  acquiresleep(&(lock_print));
  printf("%d ", v); 
  releasesleep(&(lock_print));
  return v;
}


void buffer_sem_init(void)
{
	initsleeplock(&(lock_sem_print), "lock_sem_print");
	initsleeplock(&(lock_sem_delete), "lock_sem_delete");
	initsleeplock(&(lock_sem_insert), "lock_sem_insert");
	sem_init(&(empty),20);
	sem_init(&full,0);
	sem_init(&pro,1);
	sem_init(&con,1);
	for(int i=0;i<20;i++)
	{
		initsleeplock(&(sem_buffer[i].sem_lock), "sem_lock");
		buffer[i].x=-1;
		buffer[i].full=0;
	}
  	return;
}

void sem_produce(int x)
{
//   int index;
//   acquiresleep(&lock_insert);
//   index=tail;
//   tail=(tail+1)%20;
//   releasesleep(&lock_insert);
//   acquiresleep(&buffer[index].lock);
//   while (buffer[index].full) {
//     condsleep(&(buffer[index].deleted), &(buffer[index].lock));
//   }
//   buffer[index].x = x;
//   buffer[index].full = 1;
//   cond_signal(&(buffer[index].inserted));
//   releasesleep(&(buffer[index].lock));
	// int item= x;
	// sem_wait(&pro);
	// index=nextp;
	// nextp=(nextp+1)%20;
	// sem_post(&pro);
	// sem_wait(&empty);
	// __sync_lock_test_and_set(-1,&sem_buffer[index],&item);
	// if(item==-1)
	// {
	// 	sem_post(&full);
	// }
	// else sem_post(&empty);
	sem_wait(&empty);
	sem_wait(&pro);
	buffer[nextp].x= x;
	nextp= (nextp+1)%20;
	sem_post(&pro);
	sem_post(&full);
}


int sem_consume(void)
{
//   int v, index;
//   acquiresleep(&(lock_delete));
//   index=head;
//   head=(head+1)%20;
//   releasesleep(&(lock_delete));
//   acquiresleep(&(buffer[index].lock));
//   while (!(buffer[index].full)) {
//   condsleep(&(buffer[index].inserted), &(buffer[index].lock));
//   }
//   v = buffer[index].x;
//   buffer[index].full = 0;
//   cond_signal(&(buffer[index].deleted));
//   releasesleep(&(buffer[index].lock));
//   acquiresleep(&(lock_print));
//   printf("%d ", v); 
//   releasesleep(&(lock_print));
//   return v;
	// sem_wait(&full);
	// int v;
	// int item=-1;
	// int index=0;
	// while(item==-1)
	// {
	// 	XCHG(&buffer[index],&item);
	// 	index++;
	// }
	// sem_post(&empty);
	// v = buffer[index].x;
  	// buffer[index].full = 0;
	// acquiresleep(&(lock_print));
	// printf("%d ", v); 
	// releasesleep(&(lock_print));
	// return v;
	int v;
	sem_wait(&full);
	sem_wait(&con);
	v= buffer[nextc].x;
	nextc= (nextc+1)%20;
	sem_post(&con);
	sem_post(&empty);
	acquiresleep(&lock_sem_print);
	printf("%d ", v); 
	releasesleep(&lock_sem_print);
	return v;

}


