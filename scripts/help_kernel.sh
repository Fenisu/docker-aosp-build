#!/bin/bash
echo "
======================================================================
= Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =
======================================================================

----------------------------------------------------------------------
-                  Requirements to build the kernel                  -
----------------------------------------------------------------------

- Kernel source at /kernel, can be already there or cloned now.
- Correct version of arm-linux-androideabi-* or arm-eabi-* at /tools
  to compile the specific version of kernel version either from a
  toolchain or ndk (i.e. arm-eabi-4.7 for kernel-3.4).

For more info: https://source.android.com/source/building-kernels.html

----------------------------------------------------------------------
-                            Quick Start                             -
----------------------------------------------------------------------

- cd /kernel
- set_kernel_env.sh
- make clean && make mrproper
- make XXXXX_defconfig
- make menuconfig
- make -j N"
