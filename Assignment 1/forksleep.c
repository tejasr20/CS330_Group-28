#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include<stddef.h>


int main(int argc, char *argv[])
{

if(argc!=3)
{
	fprintf(2, "usage: forksleep m n\n");
	exit(1);
}

int m,n;
m=atoi(argv[1]);
n=atoi(argv[2]);
//printf("%d %d\n",m,n);
int pid;
if(n!=0 && n!=1)
{
	fprintf(2, "usage: forksleep m n. n must be 0 or 1.\n");
        exit(1);
}

if(argv[1][0]=='-')
{
	fprintf(2, "usage: forksleep m n. m must be non-negative.\n");
        exit(1);
}


int flag=fork();

if(n==0)
{
	if(flag==0)
	{
		
		sleep(m);
		pid=getpid();
		fprintf(1,"%d: Child\n",pid);
		exit(0);	
	}
	else
	{
		
		//wait(0);
		pid=getpid();
		fprintf(1,"%d: Parent\n",pid);
		wait(0);
	}

}

else if(n==1)
{
	if(flag!=0)
	{
		
		wait(0);
		sleep(m);
		pid=getpid();
		fprintf(1,"%d: Parent\n",pid);
	}
	else
	{
		pid=getpid();
               fprintf(1,"%d: Child\n",pid);
		exit(0);
	}	
}


exit(0);
}
