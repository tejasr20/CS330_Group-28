#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main (int argc, char *argv[])
{
   if (argc != 3) {
      fprintf(2, "Invalid\n");
      exit(1);
   }
 
   int m= atoi(argv[1]);
   int n=atoi(argv[2]);
   if(m<0 || !(n==0 || n==1)) {
    fprintf(2, "Invalid\n");
      exit(1);
   } 
   else {
    int b=fork();
    if(n==0) {
        if(b==0) {
            sleep(m);
            printf("%d: Child. \n",getpid());
            exit(1);
        }
        else {
            printf("%d: Parent. \n",getpid());
            wait(0);
            exit(1);
        }
    }
    else {
        if(b==0) {
            printf("%d: Child.\n",getpid());
            exit(1);
        }
        else {
            sleep(m);
            // wait();
            printf("%d: Parent.\n",getpid());
            exit(1);
        }
    }
   }

   return 0;
}
