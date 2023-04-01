// #include "condvar.h"
// #ifndef "condvar.h"
// #include "condvar.h"
// #endif
struct buffer_elem{
    int x;
    int full;
    struct sleeplock lock;
    struct cond_t inserted;
    struct cond_t deleted;
};
 

struct sem_buffer_elem{
    int x;
    int full;
    struct sleeplock sem_lock;
};


// struct buffer{
//     struct buffer_elem buffer[20];
//     struct sleeplock lock_delete;
//     struct sleeplock lock_insert;
//     struct sleeplock lock_print;
//     int tail;
//     int head;
// };