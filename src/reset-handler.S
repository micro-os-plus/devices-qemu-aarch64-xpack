/*
 * This file is part of the µOS++ project. (https://github.com/micro-os-plus/)
 * Copyright (c) 2022-2026 Liviu Ionescu.
 *
 * Permission to use, copy, modify, and/or distribute this software
 * for any purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can
 * be obtained from https://opensource.org/licenses/mit.
 */

// ----------------------------------------------------------------------------

#if defined(__aarch64__)

// ----------------------------------------------------------------------------

// AArch64 GCC does not support naked functions, so everything should be
// written in assembly.

// modes
// EL0 - User/Application Level (Application code, user programs)
// EL1 - Operating System Level (Linux kernel, embedded OS)
// EL2 - Hypervisor Level
// EL3 - Secure Monitor Level

// In `architecture-cortexa/linker-scripts/sections-flash.ld` there is an
// `ENTRY(Reset_Handler)` to tell QEMU where to start.

    .section .after_vectors,"awx",%progbits

    .align 2
    .globl Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:

#if __ARM_ARCH >= 8

    // Note: Do not use any call here, the stack pointer is set just before
    // calling the startup.

    // Only CPU 0 performs initialization. Other CPUs go into WFI
    // to do this, first work out which CPU this is
    // this code typically is run before any other initialization step.
    mrs   x0, mpidr_el1             // Read Multiprocessor Affinity Register
    and   x0, x0, #3                // Extract CPU ID bits
    cmp   x0, #0
    beq   .Lcpu0_initialize         // If we’re on CPU0 go to the start.

.Lcpu_sleep:
    wfi                             // Other CPUs are left sleeping.
    b     .Lcpu_sleep

.Lcpu0_initialize:
    // --- Set vector base ---
    ldr   x0, = _interrupt_vectors
    msr   vbar_el1, x0

    // --- Enable Advanced SIMD and floating-point ---
    mrs   x0, cpacr_el1             // Architectural Feature Access Control Register.
    orr   x0, x0, #(3 << 20)        // FPEN=0b11 do not trap in EL0 and EL1.
    msr   cpacr_el1, x0

    // --- Disable MMU first ---
    mrs    x0, sctlr_el1
    bic    x0, x0, #(1<<0)          // Disable MMU
    msr    sctlr_el1, x0
    isb

    // --- Enable MMU with transparent mapping (recommended) ---

    // Set Memory Attribute Indirection Register (MAIR_EL1)
    // Index 0: Normal memory, Inner/Outer Write-Back Write-Allocate Cacheable
    // Index 1: Device memory, nGnRnE
    ldr    x0, =0x00ff0400
    msr    mair_el1, x0

    // Configure TCR_EL1 (Translation Control Register)
    // T0SZ=32: 32-bit virtual address space (4GB)
    // TG0=0: 4KB granule for TTBR0_EL1
    // IRGN0=1, ORGN0=1: Inner/Outer Cacheable Write-Back Write-Allocate
    // SH0=3: Inner Shareable
    // EPD1=1: Disable TTBR1_EL1 translations
    mov    x0, #32                  // T0SZ = 32 (32-bit VA space = 4GB)
    orr    x0, x0, #(0x1 << 8)      // IRGN0 = 1 (Inner Cacheable WB WA)
    orr    x0, x0, #(0x1 << 10)     // ORGN0 = 1 (Outer Cacheable WB WA)
    orr    x0, x0, #(0x3 << 12)     // SH0 = 3 (Inner Shareable)
    orr    x0, x0, #(0x1 << 23)     // EPD1 = 1 (Disable TTBR1_EL1)
    msr    tcr_el1, x0

    // Create page tables for transparent mapping
    // Use a fixed address for page tables in RAM (QEMU RAM starts at 0x40000000)
    ldr    x1, =0x40100000          // Page tables at safe RAM offset

    // Clear page table memory (8KB for L1 + L2 tables)
    mov    x2, #0x2000              // 8KB
    mov    x3, #0

.Lclear_tables:
    str    x3, [x1], #8
    subs   x2, x2, #8
    bne    .Lclear_tables

    // --- Reset base address ---
    ldr    x1, =0x40100000          // Reset to page table base

    // --- Setup L1 and L2 tables ---
    // We will use a single L2 table pointed to by the first L1 entry.
    // This L2 table will cover the first 1GB of the VA space.

    // L1 entry 0: points to L2 table for the first 1GB (0x0 to 0x3FFFFFFF)
    add    x2, x1, #0x1000          // L2 table address is L1_base + 4KB
    orr    x2, x2, #0x3             // Table descriptor (11) + Valid
    str    x2, [x1]                 // Store L1 entry 0

    // --- Move to L2 table base ---
    add    x1, x1, #0x1000

    // --- Map Peripherals in L2 table ---
    // Map 2MB block for peripherals at 0x09000000
    // L2 index for 0x09000000 is (0x09000000 >> 21) = 72
    mov    x2, #0x09000000          // Physical address of peripherals
    orr    x2, x2, #0x1             // Valid bit
    orr    x2, x2, #(1 << 2)        // MAIR index 1 (Device nGnRnE)
    orr    x2, x2, #(0x3 << 8)      // Inner Shareable
    orr    x2, x2, #(0x1 << 10)     // Access Flag
    str    x2, [x1, #(72 * 8)]      // Store L2 entry for peripherals

    // --- Map RAM in L2 table ---
    // Map 64MB of RAM starting at 0x40000000
    // L2 index for 0x40000000 is (0x40000000 >> 21) = 512
    // This requires a second L1 entry.
    // L1 index is based on VA bits [38:30] for 4KB granule.
    // L1 index for 0x40000000 is (0x40000000 >> 30) = 1.

    // -- Reset L1 base address ---
    ldr    x1, =0x40100000

    // L1 entry 1: points to L2 table for the 0x40000000 region
    add    x2, x1, #0x2000          // L2 table at L1_base + 8KB
    orr    x2, x2, #0x3             // Table descriptor
    str    x2, [x1, #8]             // Store L1 entry 1

    // --- Move to L2 table for RAM ---
    add    x1, x1, #0x2000

    // Map 64MB of RAM (32 * 2MB blocks).
    mov    x3, #0                   // Loop counter
    mov    x4, #32                  // 32 x 2MB = 64MB
    mov    x5, #0x40000000          // Base RAM address

.Lmap_ram:
    lsl    x2, x3, #21              // Offset = entry * 2MB
    add    x2, x5, x2               // Physical address = base + offset
    orr    x2, x2, #0x1             // Valid bit (Block)
    orr    x2, x2, #(0x3 << 8)      // Inner Shareable (SH=11)
    orr    x2, x2, #(0x1 << 10)     // Access Flag (AF=1)
    // MAIR index 0 is implied (Normal memory)
    str    x2, [x1], #8             // Store entry and advance
    add    x3, x3, #1
    cmp    x3, x4
    bne    .Lmap_ram

    // --- Reset base address to L1 table ---
    ldr    x1, =0x40100000          // Reset to page table base

    // Ensure page table writes are complete.
    dsb    sy

    // Set TTBR0_EL1 to point to our L1 page table.
    msr    ttbr0_el1, x1
    isb

    // --- Invalidate TLB ---
    tlbi   vmalle1
    dsb    sy
    isb

    // Enable MMU only first (no caches) for simplicity.
    // Note: disabling the alignment fault checking is mandatory,
    // the toolchain libraries are not built with -fstrict-align, and
    // will fail.
    mrs    x0, sctlr_el1
    orr    x0, x0, #(1<<0)          // Enable MMU only
    bic    x0, x0, #(1<<1)          // Disable alignment fault checking
    bic    x0, x0, #(1<<2)          // Disable data cache initially
    bic    x0, x0, #(1<<12)         // Disable instruction cache initially
    msr    sctlr_el1, x0
    isb

    // If we get here, MMU is working. Now enable caches.
    mrs    x0, sctlr_el1
    orr    x0, x0, #(1<<2)          // Enable data cache
    orr    x0, x0, #(1<<12)         // Enable instruction cache
    msr    sctlr_el1, x0
    isb

    // --- Test unaligned access ---
    ldr     x0, =(__data_start__+1) // Odd address (unaligned for 64-bit load)
    ldr     x1, [x0]                // This should work with the MMU enabled

    // --- Configure stack ---
    // Address of 4KB page at a PC-relative offset.
    adrp   x0, __stack
    mov    sp, x0

    // Use bl instead of b to have a proper stack record for GDB
    // to display a full stack trace.
    bl     _start

// ----------------------------------------------------------------------------

#else
#error "Unsupported architecture."
#endif

// ----------------------------------------------------------------------------

#endif // defined(__aarch64__)

// ----------------------------------------------------------------------------
