// #include "sleeplock.h"
// #include "condvar.h"
// struct cond_t;

struct semaphore{
    struct sleeplock lk;
	struct cond_t* cv; 
	int v;
};	
