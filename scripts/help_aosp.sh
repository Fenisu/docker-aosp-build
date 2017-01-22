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
For sony specific info: http://developer.sonymobile.com/open-devices/aosp-build-instructions/how-to-build-aosp-nougat-for-unlocked-xperia-devices/
FOr sony binaries you need to download the binaries from: http://developer.sonymobile.com/open-devices/list-of-devices-and-resources/

----------------------------------------------------------------------
-                            Quick Start                             -
----------------------------------------------------------------------

- repo init -u https://android.googlesource.com/platform/manifest -b android-XXXX
- set_sony_repos.sh
- unzip SW_binaries_for_Xperia_AOSP_M_MR1_v06.zip -d /aosp
- repo sync -j N
- ccache -M 100G
- make clobber
- . build/envsetup.sh
- lunch
- make -j N"
