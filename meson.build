# -----------------------------------------------------------------------------
#
# This file is part of the µOS++ distribution.
#   (https://github.com/micro-os-plus/)
# Copyright (c) 2022 Liviu Ionescu
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/MIT/.
#
# -----------------------------------------------------------------------------

# This file is intended to be consumed by applications with:
#
# `subdir('xpacks/micro-os-plus-devices-qemu-aarch64')`
#
# The result is a dependency that can be referred as:
#
# `dependencies: [micro_os_plus_devices_qemu_aarch64_dependency],`

# Note: the meson configuration is provided only as a proof of concept,
# for production it might need some refinements.

# -----------------------------------------------------------------------------

message('Processing xPack @micro-os-plus/devices-qemu-aarch64...')

# https://mesonbuild.com/Reference-manual_functions.html#declare_dependency
micro_os_plus_devices_qemu_aarch64_dependency = declare_dependency(
  include_directories: include_directories(
    'include',
  ),
  sources: files(
    'src/reset-handler.S',
    'src/interrupt-vectors.S',

    'src/exception-handlers.cpp',
  ),
  compile_args: [
    '-D' + xpack_device_compile_definition
  ],
  dependencies: [
    # xpack_3rd_party_arm_cmsis_core_m_dependency,
    # micro_os_plus_devices_cortexa_dependency,
    # micro_os_plus_startup_dependency,
  ],
)

message('+ -I include')
message('+ src/reset-handler.S')
message('+ src/interrupt-vectors.S')
message('+ src/exception-handlers.cpp')
message('+ -D ' + xpack_device_compile_definition)
message('> micro_os_plus_devices_qemu_aarch64_dependency')

# -----------------------------------------------------------------------------
