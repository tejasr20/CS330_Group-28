struct procstat {
  int pid;     // Process ID
  int ppid;    // Parent ID
//   char state[8];  // Process state
  char* state;
  char* command; // Process name
  int ctime;    // Creation time
  int stime;    // Start time
  int etime;    // Execution time
  uint64 size;  // Process size
};
