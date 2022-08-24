#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++){
    write(1, argv[i], strlen(argv[i])); // 1 means writing to stdout 
    if(i + 1 < argc){ // place a space if its not the last argument 
      write(1, " ", 1);
    } else {
      write(1, "\n", 1); // newline
    }
  }
  exit(0);
}
