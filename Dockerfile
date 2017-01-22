# We start with our base OS, Ubuntu 14.04
FROM ubuntu:14.04

# This Dockerfile is HEAVILY based on David Keppler "dave@kepps.net" version
# old mantainer Mike Wallace "mike.wallace@risesoftware.com"
MAINTAINER Ignacio Quezada "dreamtrick@gmail.com

# Add the repositories needed for the packages we're going to install
# These are added to the Ubuntu base, not your host operating system. As are all the packages.
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-security multiverse" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

# All apt-get in one RUN
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#apt-get
RUN apt-get -qq update && apt-get -qqy upgrade && apt-get install -y openjdk-8-jdk \
  bison make zlib1g-dev:i386 zip \  
  git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc python-networkx \
  libssl-dev trousers libyaml-dev libyaml-0-2 vboot-utils pkg-config \
  liblzma-dev cgpt uuid-dev device-tree-compiler \
  unzip nano wget \
  software-properties-common python-software-properties bc \
  && rm -rf /var/lib/apt/lists/*

# Adding a user called 'builder' and setting up CCACHE
RUN useradd --create-home builder

VOLUME ["/aosp", "/ccache", "/tools", "/kernel"]

ENV USE_CCACHE 1
ENV CCACHE_DIR /ccache

COPY scripts/set_sony_patches.sh /usr/local/bin/set_sony_patches.sh
COPY scripts/set_sony_repos.sh /usr/local/bin/set_sony_repos.sh
COPY scripts/help_aosp.sh /usr/local/bin/help_aosp.sh 
COPY scripts/help_kernel.sh /usr/local/bin/help_kernel.sh 
COPY scripts/set_kernel_env.sh /usr/local/bin/set_kernel_env.sh 
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod +x /usr/local/bin/repo

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "\
======================================================================\n\
= Docker AOSP build environment based on Ubuntu 14.04 with openjdk-7 =\n\
======================================================================\n\
\n\
For more info check: https://source.android.com/source/\n\
For specific sony info: http://developer.sonymobile.com/open-devices/aosp-build-instructions/how-to-build-aosp-nougat-for-unlocked-xperia-devices/
\n\
To build AOSP, use:\n\
- help_aosp.sh\n\
\n\
To build the kernel, use:\n\
- help_kernel.sh\n\
\n\
Good Luck!\n" \
 > /etc/motd

USER builder
ENV HOME /home/builder
# aosp build jack-admin fails if no USER env is set
ENV USER builder
# directory where docker -it starts the shell
WORKDIR /aosp

# End of the Dockerfile
