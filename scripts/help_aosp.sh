#!/bin/bash
echo "
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
- make -j N"
