#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h" 
// uncomment for xv6 
//#include<stddef.h>
//#include <stdio.h>
//#include<unistd.h>
//#include <stdlib.h>

//recursively 
void pipeline(int n, int x) // n processes left, creates a new pipe in each call. Only parent process prints. 
{
	if(n==0) return;
	int p[2]; // pipe is created 
	int temp;// x is read into temp in child process 
	int t=pipe(p);
	if (t<0) //pipe creation failed 
			exit(1);
	int pid= getpid();
	int id = fork();
	if(id>0) //parent process 
	{
		pid=getpid();
		x=x+pid;
		write(p[1],&x, sizeof(int)); // writes to pipe 
		close(p[1]);
		close(p[0]);
		fprintf(1,"%d: %d\n",pid,x);
		wait(0);
	}
	else //child process 
	{
		sleep(1);
		close(p[1]); // child will not write anything 
		pid=getpid();
		read(p[0],&temp, sizeof(int)); // reads value of x 
		close(p[0]); //close the read end of the pipe 
		pipeline(n-1,temp); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
		exit(0);	
	}
	return;
}

int main(int argc, char *argv[])
{
	if(argc!=3)
	{
		fprintf(2, "usage: pipeline n x\n");
		exit(1);        
	}
	int n,x;
	n=atoi(argv[1]); // converts to integer 
	x=atoi(argv[2]);
	if(n<=0)
	{
		fprintf(2, "usage: pipeline n x. n must be greater than 0.\n");
		exit(1);
	}
	// we have valid inputs now: do we have to check if x is integral? 
	// the second argument is used to make the pid outputs easier to read and verify, each pid is taken wrt the original process pid
	pipeline(n,x);
	exit(0);
}
