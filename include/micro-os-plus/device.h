/*
 * This file is part of the µOS++ project (https://micro-os-plus.github.io/).
 * Copyright (c) 2022-2026 Liviu Ionescu. All rights reserved.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can be
 * obtained from https://opensource.org/licenses/mit.
 */

#ifndef MICRO_OS_PLUS_DEVICE_H_
#define MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------

#if defined(__cplusplus)
#if !(__cplusplus >= 202002L || (defined(_MSVC_LANG) && _MSVC_LANG >= 202002L))
#error "C++20 or higher is required"
#endif
#endif // defined(__cplusplus)

#if __has_include("micro-os-plus/project-config.h")
#include "micro-os-plus/project-config.h"
#endif // __has_include("micro-os-plus/project-config.h")

#if __has_include("micro-os-plus/device-defines.h")
#include "micro-os-plus/device-defines.h"
#endif // __has_include("micro-os-plus/device-defines.h")

// ----------------------------------------------------------------------------

#include "micro-os-plus/architecture.h"

#include "micro-os-plus/architecture-aarch64/exception-handlers.h"

// ----------------------------------------------------------------------------

#if defined(__cplusplus)
extern "C"
{
#endif // defined(__cplusplus)

  // --------------------------------------------------------------------------

#if defined(MICRO_OS_PLUS_DEVICE_QEMU_CORTEX_A72)

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

#if defined(__GNUC__))
#pragma GCC diagnostic push

#if defined(__cplusplus)
//#pragma GCC diagnostic ignored "-Wuseless-cast"
//#pragma GCC diagnostic ignored "-Wold-style-cast"
//#pragma GCC diagnostic ignored "-Wvolatile"
#else
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
#endif // defined(__cplusplus)
#pragma GCC diagnostic ignored "-Wconversion"
#pragma GCC diagnostic ignored "-Wsign-conversion"
#pragma GCC diagnostic ignored "-Wsign-compare"
#pragma GCC diagnostic ignored "-Wswitch-default"
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wpadded"
#pragma GCC diagnostic ignored "-Warith-conversion"
#endif // defined(__GNUC__)

#include "core_ca.h"

#if defined(__GNUC__))
#pragma GCC diagnostic pop
#endif // defined(__GNUC__)

#endif // 0-1

#else
#error "Device not supported"
#endif // defined(MICRO_OS_PLUS_DEVICE_QEMU_CORTEX_*)

#if 0
  extern uint32_t SystemCoreClock; /*!< System Clock Frequency (Core Clock) */

  extern void
  SystemInit (void);
  extern void
  SystemCoreClockUpdate (void);
#endif // 0-1

  // --------------------------------------------------------------------------

#if defined(__cplusplus)
}
#endif // defined(__cplusplus)

// ----------------------------------------------------------------------------

#endif // MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------
