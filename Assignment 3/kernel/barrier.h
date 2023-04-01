// #include "condvar.h"
struct barrier {
//   pthread_mutex_t barrier_mutex;
  struct sleeplock barrier_lock;
  struct sleeplock print_lock;
  struct cond_t barrier_cond;
//   int nthread;      // Number of threads that have reached this round of the barrier
//   int n; //number of processes that should wait at the barrier 
  int id; // barrier id 
  int count; // number of procecces currently waiting at barrier: barrier instance number<= n_barriers
  int free;
};

