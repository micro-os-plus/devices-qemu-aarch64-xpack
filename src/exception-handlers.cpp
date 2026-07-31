/*
 * This file is part of the µOS++ project (https://micro-os-plus.github.io/).
 * Copyright (c) 2014-2026 Liviu Ionescu. All rights reserved.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can be
 * obtained from https://opensource.org/licenses/mit.
 */

// ----------------------------------------------------------------------------

#if defined(__aarch64__)

// ----------------------------------------------------------------------------

#include "micro-os-plus/device.h"

#include "micro-os-plus/diag/trace.h"

// #include <string.h>

// ----------------------------------------------------------------------------

using namespace micro_os_plus;

// ----------------------------------------------------------------------------

extern "C"
{
  void
  common_trap_handler (exception_frame*);
}

void
common_trap_handler (exception_frame* ef)
{
  // TODO
  trace::printf ("\n\n");
  trace::printf ("exception type: %d\n", static_cast<int> (ef->exc_type));
  trace::printf ("esr: %p\n", reinterpret_cast<void*> (ef->exc_esr));
  trace::printf ("sp: %p\n", reinterpret_cast<void*> (ef->exc_sp));
  trace::printf ("elr: %p\n", reinterpret_cast<void*> (ef->exc_elr));
  trace::printf ("spsr: %d\n", static_cast<int> (ef->exc_spsr));

  while (1)
    ;

  return;
}

// ----------------------------------------------------------------------------

#endif // defined(__aarch64__)

// ----------------------------------------------------------------------------
