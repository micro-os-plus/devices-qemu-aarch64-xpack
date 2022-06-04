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

#ifndef MICRO_OS_PLUS_DEVICE_H_
#define MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------

#include <micro-os-plus/architecture.h>

// ----------------------------------------------------------------------------

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

  // --------------------------------------------------------------------------

#if defined(DEVICE_QEMU_CORTEX_A72)

// It throws lots of errors, mainly related to truncating integers;
// perhaps CMSIS does not support 64-bit.
#if 0
typedef enum
{
  XXX_IRQn = -1,
} IRQn_Type;

#define __CORTEX_A 5
#define __CA_REV 0x0000U
#define __FPU_PRESENT 1U
#define __GIC_PRESENT 1U
#define __TIM_PRESENT 1U
#define __L2C_PRESENT 0U

// TODO
#define GIC_DISTRIBUTOR_BASE 0xF000
#define GIC_INTERFACE_BASE 0xF100
#define TIMER_BASE 0xF200

#pragma GCC diagnostic push
#ifdef __cplusplus
//#pragma GCC diagnostic ignored "-Wuseless-cast"
//#pragma GCC diagnostic ignored "-Wold-style-cast"
//#pragma GCC diagnostic ignored "-Wvolatile"
#else
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
#endif
#pragma GCC diagnostic ignored "-Wconversion"
#pragma GCC diagnostic ignored "-Wsign-conversion"
#pragma GCC diagnostic ignored "-Wsign-compare"
#pragma GCC diagnostic ignored "-Wswitch-default"
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wpadded"
#pragma GCC diagnostic ignored "-Warith-conversion"

#include "core_ca.h"

#pragma GCC diagnostic pop

#endif

#elif defined(DEVICE_QEMU_CORTEX_A15)

// TODO

#else
#error "Device not supported"
#endif

  extern uint32_t SystemCoreClock; /*!< System Clock Frequency (Core Clock) */

  extern void
  SystemInit (void);
  extern void
  SystemCoreClockUpdate (void);

  // --------------------------------------------------------------------------

#ifdef __cplusplus
}
#endif /* __cplusplus */

// ----------------------------------------------------------------------------

#endif // MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------
