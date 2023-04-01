#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;
int schedp=2;
int batch_size=0;
int k=0;                                //to check for batch size
uint bstime=-1;
uint betime=-1;
uint mincomp=-1;
uint maxcomp=-1;
uint totcomp=-1;
uint turn_time=0;
int num_burst=0,num_burst_est=0,count=0;
uint min_burst=-1,min_burst_est=-1;
uint max_burst=-1,max_burst_est=-1;
uint tot_burst=0,tot_burst_est=0;
uint error_in_est=0,waiting_time=0;
// start() jumps here in supervisor mode on all CPUs.
void
main()
{

  if(cpuid() == 0){
    consoleinit();
    printfinit();
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");
    kinit();         // physical page allocator
    kvminit();       // create kernel page table
    kvminithart();   // turn on paging
    procinit();      // process table
    trapinit();      // trap vectors
    trapinithart();  // install kernel trap vector
    plicinit();      // set up interrupt controller
    plicinithart();  // ask PLIC for device interrupts
    binit();         // buffer cache
    iinit();         // inode table
    fileinit();      // file table
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
      ;
    __sync_synchronize();
    printf("hart %d starting\n", cpuid());
    kvminithart();    // turn on paging
    trapinithart();   // install kernel trap vector
    plicinithart();   // ask PLIC for device interrupts
  }

  scheduler();        
}
