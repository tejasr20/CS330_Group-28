#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main()
{
    int x;
    x=1;
    int pid=getpid();
    fprintf(1,"[%d] The address of x before fork is: %d\n",pid,getpa(&x));
    if(fork()==0)
    {
        pid=getpid();
        fprintf(1,"[%d] The address of x in child is: %d\n",pid,getpa(&x));
    }
    else
    {
        sleep(10);
        pid=getpid();
        fprintf(1,"[%d] The address of x in parent is: %d\n",pid,getpa(&x));
        wait(0);
    }



    exit(0);
}