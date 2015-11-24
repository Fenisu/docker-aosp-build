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

RUN apt-get -qq update
RUN apt-get -qqy upgrade

# install the JDK
RUN apt-get install -y openjdk-7-jdk

# install all of the tools and libraries that we need.
RUN apt-get install -y git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip

RUN apt-get install -y software-properties-common python-software-properties



# Adding a user called 'builder' and setting up CCACHE
RUN useradd --create-home builder
RUN echo "export USE_CCACHE=1" >> /etc/profile.d/android
ENV USE_CCACHE 1

USER builder

ENV HOME /home/builder

# End of the Dockerfile
