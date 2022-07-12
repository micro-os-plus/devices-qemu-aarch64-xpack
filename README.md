[![license](https://img.shields.io/github/license/micro-os-plus/devices-qemu-aarch64-xpack)](https://github.com/micro-os-plus/devices-qemu-aarch64-xpack/blob/xpack/LICENSE)
[![CI on Push](https://github.com/micro-os-plus/devices-qemu-aarch64-xpack/workflows/CI%20on%20Push/badge.svg)](https://github.com/micro-os-plus/devices-qemu-aarch64-xpack/actions?query=workflow%3A%22CI+on+Push%22)

# A source library xPack with the µOS++ QEMU AArch64 board support files

QEMU implements several AArch64 boards, which can be used for running
tests.

- <https://www.qemu.org/docs/master/system/target-arm.html>
- <https://www.qemu.org/docs/master/system/arm/virt.html>

This project provides the initialization code required to build
applications running on these boards.

It is intended to be included in unit tests, which generally do not
need peripherals.

## Maintainer info

This page is addressed to developers who plan to include this source
library into their own projects.

For maintainer info, please see the
[README-MAINTAINER](README-MAINTAINER.md) file.

## Install

As a source library xPacks, the easiest way to add it to a project is via
**xpm**, but it can also be used as any Git project, for example as a submodule.

### Prerequisites

A recent [xpm](https://xpack.github.io/xpm/),
which is a portable [Node.js](https://nodejs.org/) command line application.

For details please follow the instructions in the
[xPack install](https://xpack.github.io/install/) page.

### xpm

Note: the package will be available from npmjs.com at a later date.

For now, it can be installed from GitHub:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install github:micro-os-plus/devices-qemu-aarch64-xpack
```

When ready, this package will be available as
[`@micro-os-plus/devices-qemu-aarch64`](https://www.npmjs.com/package/@micro-os-plus/devices-qemu-aarch64)
from the `npmjs.com` registry:

```sh
cd my-project
xpm init # Unless a package.json is already present

xpm install @micro-os-plus/devices-qemu-aarch64@latest

ls -l xpacks/micro-os-plus-devices-qemu-aarch64
```

### Git submodule

If, for any reason, **xpm** is not available, the next recommended
solution is to link it as a Git submodule below an `xpacks` folder.

```sh
cd my-project
git init # Unless already a Git project
mkdir -p xpacks

git submodule add https://github.com/micro-os-plus/devices-qemu-aarch64-xpack.git \
  xpacks/micro-os-plus-devices-qemu-aarch64-xpack
```

## Branches

Apart from the unused `master` branch, there are two active branches:

- `xpack`, with the latest stable version (default)
- `xpack-develop`, with the current development version

All development is done in the `xpack-develop` branch, and contributions via
Pull Requests should be directed to this branch.

When new releases are published, the `xpack-develop` branch is merged
into `xpack`.

## Developer info

This project can be used as-is for simple tests or blinky projects.

It can also be copied into
the user project, the configuration updated, and content regenerated,
at any time.

### Status

The QEMU AArch64 support is work in progress.

### Limitations

The emulated boards provide a limited range of peripherals, but for
running unit tests these peripherals are not necessary.

The current initialisation code does not touch them.

### Build & integration info

To integrate this package into user projects, consider the following details:

#### Include folders

The following folders should be passed to the compiler during the build:

- `include`

The header files to be included in user project are:

```c
#include <micro-os-plus/device.h>
```

#### Source files

The source files to be added to user projects are:

- `src/boot.S`

#### Preprocessor definitions

- `MICRO_OS_PLUS_INCLUDE_MICRO_OS_PLUS_DIAG_TRACE` to enable the `trace_printf()`
  calls in `Error_Handler()` and `assert_failed()`.

#### Compiler options

- `-std=c++20` or higher for C++ sources
- `-std=c11` for C sources

#### Interrupt handlers

Only the standard AArch64 trap handlers are used.

#### C++ Namespaces

- none

#### C++ Classes

- none

### Examples

TBD

### Known problems

- none

### Tests

TBD

## Change log - incompatible changes

According to [semver](https://semver.org) rules:

> Major version X (X.y.z | X > 0) MUST be incremented if any
backwards incompatible changes are introduced to the public API.

The incompatible changes, in reverse chronological order,
are:

- v2.x: interrupt-vectors & exception-handlers moved here; Reset_Handler
  renamed with capital letters
- v1.x: initial release

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT/),
with all rights reserved to
[Liviu Ionescu](https://github.com/ilg-ul/).
