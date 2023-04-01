#include "sleeplock.h"

struct cond_t{
    struct sleeplock lk;
};
