#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
int main(int argc, char *argv[])
{
if(argc!=1)
{
	fprintf(2,"usage: uptime\n");
	exit(1);
}
int x=uptime();
fprintf(1,"%d\n",x);
exit(0);
}

