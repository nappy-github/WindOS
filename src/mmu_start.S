/**
 * Functions to start the MMU
 * See https://github.com/dwelch67/raspberrypi/tree/master/mmu
 * for more documentation
 */


/**
 * Start the MMU
 * Parameters nedded:
 * The mmu adress (r0)
 * The I and D cache enables (r1)
 */
  .globl start_mmu
start_mmu:
  mov r2,#0

  #ifdef RPI2
    mcr p15,0,r2,c8,c7,0  // Invalidate tlb
    mcr p15,0,r2,c7,c5,6  // BPIALL - Invalidate entire branch predictor array
  #else
    mcr p15,0,r2,c7,c7,0  // invalidate caches
    mcr p15,0,r2,c8,c7,0  // invalidate tlb
    mcr p15,0,r2,c7,c10,4 // DSB ??
  #endif

  mvn r2,#0
  bic r2,#0xC
  mcr p15,0,r2,c3,c0,0  // domain

  mcr p15,0,r0,c2,c0,0  // tlb base
  mcr p15,0,r0,c2,c0,1  //tlb base

  mrc p15,0,r2,c1,c0,0
  orr r2,r2,r1
  mcr p15,0,r2,c1,c0,0

  bx lr


/**
 * Stop the MMU
 */
  .globl stop_mmu
stop_mmu:
  mrc p15,0,r2,c1,c0,0
  bic r2,#0x1000
  bic r2,#0x0004
  bic r2,#0x0001
  mcr p15,0,r2,c1,c0,0
  bx lr

/**
 * Invalidate tlbs. This is used to update the cache directly
 */
  .globl invalidate_tlbs
invalidate_tlbs:
  mov r2,#0
  mcr p15,0,r2,c8,c7,0  ;@ invalidate tlb
  mcr p15,0,r2,c7,c10,4 ;@ DSB ??
  bx lr

