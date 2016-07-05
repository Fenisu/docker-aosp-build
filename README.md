docker-aosp-build
=================

Dockerfile to easily build an independent container to build AOSP, based on Ubuntu 14.04.

How to use it
-------------

To build the container:

     docker build -t aosp docker-aosp-build

To run the container:

    docker run -v /path/to/repo:/aosp -v /path/to/.ccache:/ccache -i -t aosp /bin/bash


Extras
------
Inside the container you will get greeted by the MOTD:

    ======================================================================
    = Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =
    ======================================================================

    For more info check: https://source.android.com/source/

    Available commands:
    - repo init -u https://android.googlesource.com/platform/manifest -b android-XXXX
    - repo sync -j N
    - ccache -M 100G
    - download-nexus-binaries.sh
    - make clobber
    - . build/envsetup.sh
    - lunch
    - make -j N

The script download-nexus-binaries.sh will help you download the binary blobs / drivers from the nexus website.

Advanced
--------

It is fairly simple to "re-use" the same images for new containers.
If you want to compile for two different devices you might want to this instead:

     docker build -t aosp:nexus4 docker-aosp-build

and then:

     docker build -t aosp:pixel-c docker-aosp-build

To run these containers, it should be instead:

    docker run -v /path/to/repo:/aosp -v /path/to/.ccache:/ccache -i -t aosp:nexus4 /bin/bash

and:

    docker run -v /path/to/repo:/aosp -v /path/to/.ccache:/ccache -i -t aosp:pixel-c /bin/bash



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

