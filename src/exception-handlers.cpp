/*
 * This file is part of the µOS++ distribution.
 *   (https://github.com/micro-os-plus/)
 * Copyright (c) 2014 Liviu Ionescu.
 *
 * Permission to use, copy, modify, and/or distribute this software
 * for any purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can
 * be obtained from https://opensource.org/licenses/MIT/.
 */

// ----------------------------------------------------------------------------

#if defined(__aarch64__)

// ----------------------------------------------------------------------------

#if defined(MICRO_OS_PLUS_INCLUDE_CONFIG_H)
#include <micro-os-plus/config.h>
#endif // MICRO_OS_PLUS_INCLUDE_CONFIG_H

// #include <micro-os-plus/device.h>
#include <micro-os-plus/architecture-aarch64/exception-handlers.h>

// #include <micro-os-plus/diag/trace.h>

// #include <string.h>

// ----------------------------------------------------------------------------

// using namespace micro_os_plus;

// ----------------------------------------------------------------------------

extern "C"
{
  void
  common_trap_handler (exception_frame*);
}

void
common_trap_handler (exception_frame*)
{
  // TODO
  return;
}

// ----------------------------------------------------------------------------

#endif // defined(__aarch64__)

// ----------------------------------------------------------------------------
