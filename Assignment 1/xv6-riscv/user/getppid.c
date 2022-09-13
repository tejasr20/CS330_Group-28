#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main()
{
    int pid,ppid;
    pid=getpid();
    fprintf(1,"BEFORE FORK: The pid is: %d\n",pid);

    if(fork()==0)
    {
        pid=getpid();
        ppid=getppid();
        fprintf(1,"CHILD: The pid is: %d and ppid is: %d\n",pid,ppid);
    }
    else
    {
        wait(0);
        ppid=getppid();
        fprintf(1,"PARENT: The pid is: %d and ppid is: %d\n",pid,ppid);
    }
    exit(0);
}