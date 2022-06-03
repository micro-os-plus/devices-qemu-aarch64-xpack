/*
 * This file is part of the µOS++ distribution.
 *   (https://github.com/micro-os-plus/)
 * Copyright (c) 2022 Liviu Ionescu.
 *
 * Permission to use, copy, modify, and/or distribute this software
 * for any purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can
 * be obtained from https://opensource.org/licenses/MIT/.
 */

# -----------------------------------------------------------------------------

// AArch64 GCC does not support naked functions, so everything should be
// written in assembly.

// In `architecture-cortexa/linker-scripts/sections-flash.ld` there is an
// `ENTRY(reset_handler)` to tell QEMU where to start.

  .section .after_vectors,"awx",%progbits

  .align 2
  .globl reset_handler
  .type reset_handler, %function
reset_handler:

#if defined(__ARM_ARCH_8A)

  // Only CPU 0 performs initialization. Other CPUs go into WFI
  // to do this, first work out which CPU this is
  // this code typically is run before any other initialization step.
  mrs   x0, mpidr_el1 // Read Multiprocessor Affinity Register
  and   x0, x0, #3 // Extract CPU ID bits
  cmp   x0, #0
  beq   .Lcpu0_initialize // If we’re on CPU0 go to the start.

.Lcpu_sleep:
  wfi    // Other CPUs are left sleeping.
  b     .Lcpu_sleep

.Lcpu0_initialize:
  // Set vector base.
  ldr   x1, = _interrupt_vectors
  msr   vbar_el1, x1

  // Enable Advanced SIMD and floating-point.
  mrs   x1, cpacr_el1 // Architectural Feature Access Control Register.
  mov   x0, #(3 << 20) // FPEN=0b11 do not trap in EL0 and EL1.
  orr   x0, x1, x0
  msr   cpacr_el1, x0

  // Configure stack.
  // Address of 4KB page at a PC-relative offset.
  adrp   x0, _initial_main_stack_pointer
  mov    sp, x0

  bl     _start

#elif defined(__ARM_ARCH_7A__)

  // DEN0013D_cortex_a_series_PG.pdf
  // 13.1 Booting a bare-metal system

  // Only CPU 0 performs the initializations. All other CPUs go into WFI.
  // To do this, first work out which CPU this is by reading MPIDR.
  mrc     p15, 0, r1, c0, c0, 5 // Read Multiprocessor Affinity Register
  and     r1, r1, #0x3 // Extract CPU ID bits
  cmp     r1, #0
  beq     .Lcpu0_initialize // If we’re on CPU0 goto the start.

.Lcpu_sleep:
  wfi     // Other CPUs are left sleeping.
  b       .Lcpu_sleep

.Lcpu0_initialize:
  ldr     r0, =_initial_main_stack_pointer
  // Enter each mode in turn and set up the stack pointer
#if 0
  MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
  MOV     SP, R0
  SUB     R0, R0, #FIQ_Stack_Size
  MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
#endif
  mov     sp, r0

  // Disable MMU.
  mrc     p15, 0, r1, c1, c0, 0 // Read Control Register configuration data
  bic     r1, r1, #0x1
  mcr     p15, 0, r1, c1, c0, 0 // Write Control Register configuration data

  // Use bl instead of b to have a proper stack record for GDB
  // to display a full stack trace.
  bl      _start

#else
#error "Unsupported architecture."
#endif
