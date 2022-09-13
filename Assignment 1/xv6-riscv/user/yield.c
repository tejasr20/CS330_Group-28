#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main()
{
    int a;
    int x=1;
    
    a=getpid();
    fprintf(1,"[%d] Parent has pid: %d\n",a,a);
    if(fork()==0)
    {
        yield(); // Making sure Parent executes First
        a=getpid();
        fprintf(1,"[%d] Child executing %d\n",a,a);
    }
    else{
        a=getpid();
        fprintf(1,"[%d] Parent executing\n",a);
        fprintf(1,"[%d] Parent Yielded\n",a);
        x=yield();
        fprintf(1,"[%d] Parent got back control. Yield returned: %d\n",a,x);
        wait(0);
    }
    exit(0);
}