docker-aosp-build
=================

Dockerfile to easily build an independent container to build AOSP and kernel, based on Ubuntu 14.04.

How to use it
-------------

To build the container:

     docker build -t aosp docker-aosp-build

To run the container:

    docker run -v /path/to/repo:/aosp -v /path/to/kernel:/kernel \
               -v /path/to/.ccache:/ccache -v /path/to/tools:/tools \
               -i -t aosp /bin/bash


Extras
------
Inside the container you will be greeted by the MOTD:

    ======================================================================
    = Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =
    ======================================================================

    For more info check: https://source.android.com/source/

    To build AOSP, use:
    - help_aosp.sh

    To build the kernel, use:
    - help_kernel.sh

    Good Luck!


Two help scripts are available so you can smoothly build what you need:

run help_aosp.sh
    ======================================================================
    = Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =
    ======================================================================

    ----------------------------------------------------------------------
    -                     Requirements to build AOSP                     -
    ----------------------------------------------------------------------

    - AOSP source at /aosp, can be already there or repo sync'ed now.
    - Set ccache sizeto use the /ccache directory
    - Binaries for the device to build at the appropiate directory
      according to the AOSP manual (/aosp/vendor/), the script
      download-nexus-binaries.sh does this automatically.

    For more info: https://source.android.com/source/downloading.html

    ----------------------------------------------------------------------
    -                            Quick Start                             -
    ----------------------------------------------------------------------

    - repo init -u https://android.googlesource.com/platform/manifest -b android-XXXX
    - repo sync -j N
    - ccache -M 100G
    - download-nexus-binaries.sh
    - make clobber
    - . build/envsetup.sh
    - lunch
    - make -j N

The script download-nexus-binaries.sh will help you download the binary blobs / drivers from the nexus website.

run help_kernel.sh
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
    - make -j N

Advanced
--------

It is fairly simple to "re-use" the same images for new containers.
If you want to compile for two different devices you might want to this instead:

     docker build -t aosp:mako docker-aosp-build

and then:

     docker build -t aosp:dragon docker-aosp-build

To run these containers, it should be instead:

    docker run -v /path/to/repo1:/aosp -v /path/to/.ccache:/ccache -i -t aosp:mako /bin/bash

and:

    docker run -v /path/to/repo2:/aosp -v /path/to/.ccache:/ccache -i -t aosp:dragon /bin/bash



Bugs
====
If you find any bug or want to request a new feature, please use
the [issue tracker](https://github.com/Fenisu/docker-aosp-build/issues)
associated with the project.

Try to be as detailed as possible when filing a bug, preferably providing a
patch or a test case illustrating the issue.

Contact
=======
To get in contact with me, you can send me an email at
dreamtrick@gmail.com

