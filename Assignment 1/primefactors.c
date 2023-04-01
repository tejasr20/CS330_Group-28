
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int primes[]={2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97};
//global array of primes in between one and hundred : 25 primes 

void primefactors(int n, int ind)
{
	if(n==1 || ind==25) return;
	int p[2];
	int t= pipe(p);
	int temp;
	if(t<0) exit(1); //pipe creation failed 
	int id= fork();
	if(id>0) // 24  
	{
		int power=0;
		while(n%primes[ind]==0 && n>1)
		{
			n/= primes[ind];
			power++;	
			fprintf(1,"%d, ",primes[ind]);
		}
		close(p[0]);
		write(p[1], &n, sizeof(int) );
		close(p[1]);
		if(power!=0) fprintf(1,"[%d]\n",getpid());
		wait(0);
	}
	else
	{
		sleep(0);
		close(p[1]); // child will not write anything 
		read(p[0], &temp, sizeof(int)); // reads value of n from pipe 
		close(p[0]); //close the read end of the pipe 
		primefactors(n, ind+1); // no need for a pipe here because this process is yet to print, so we continue the process with a recursive call 
		exit(0);	
	}
	return;
}

int main(int argc, char *argv[])
{
	if(argc!=2)
	{
		fprintf(2, "usage: primefactors n\n");
		exit(1);        
	}
	int n;
	n=atoi(argv[1]); // converts to integer 
	if(n>100 || n<2)
	{
		fprintf(2, "usage: pipeline n. n must be in between 2 and 100, both inclusive.\n");
		exit(1);
	}
	primefactors(n, 0);
	exit(0);
}
