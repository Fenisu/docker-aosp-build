# We start with our base OS, Ubuntu 14.04
FROM ubuntu:14.04

# This Dockerfile is HEAVILY based on David Keppler "dave@kepps.net" version
MAINTAINER Mike Wallace "mike.wallace@risesoftware.com"

# Add the repositories needed for the packages we're going to install
# These are added to the Ubuntu base, not your host operating system. As are all the packages.
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# make multiarch work (only a 14.04 thing?)
#RUN dpkg --add-architecture i386

# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#apt-get
RUN apt-get -qq update && apt-get -qqy upgrade && apt-get install -y openjdk-7-jdk \
  git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip nano wget \
  software-properties-common python-software-properties \
  && rm -rf /var/lib/apt/lists/*

# install the JDK
#RUN apt-get install -y openjdk-7-jdk \
#  git-core gnupg flex bison gperf build-essential \
#  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
#  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
#  libgl1-mesa-dev libxml2-utils xsltproc unzip nano wget

# install all of the tools and libraries that we need.
#RUN apt-get install -y git-core gnupg flex bison gperf build-essential \
#  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
#  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
#  libgl1-mesa-dev libxml2-utils xsltproc unzip nano wget

#RUN apt-get install -y software-properties-common python-software-properties \
# && rm -rf /var/lib/apt/lists/*



# Adding a user called 'builder' and setting up CCACHE
RUN useradd --create-home builder
#RUN mkdir /home/builder
#RUN chown -R builder:builder /home/builder/android
#RUN echo "export USE_CCACHE=1" >> /etc/profile.d/android

VOLUME ["/aosp", "/ccache"]

ENV USE_CCACHE 1
ENV CCACHE_DIR /ccache

COPY scripts/download-nexus-binaries.sh /usr/local/bin/download-nexus-binaries.sh 
#&& chmod +x /usr/local/bin/download-nexus-binaries.sh
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod +x /usr/local/bin/repo

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "\
======================================================================\n\
= Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =\n\
======================================================================\n\
\n\
For more info check: https://source.android.com/source/\n\
\n\
Available commands:\n\
- repo init -u https://android.googlesource.com/platform/manifest -b android-XXXX\n\
- repo sync -j N\n\
- ccache -M 100G\n\
- download-nexus-binaries.sh\n\
- make clobber\n\
- . build/envsetup.sh\n\
- lunch\n\
- make -j N\n" \
 > /etc/motd

USER builder

ENV HOME /home/builder
# aosp build jack-admin fails if no USER env is set
ENV USER builder
WORKDIR /aosp

#ENTRYPOINT ["/bin/bash"]
# End of the Dockerfile
