#!/usr/bin/env bash
#
#  Set cross compiler environemnt for kernel compilation
#

set -e # fail on unhandled error

main(){
  echo "[*] Looking for *-gcc..."
  gcc_tools=()
  while IFS= read -d $'\0' -r file; do
    gcc_tools=("${gcc_tools[@]}" "$file");
  done < <(find /tools -type f \( -name 'arm-eabi-gcc' -or -name 'arm-linux-androideabi-gcc' -or -name '*-linux-android-gcc' \) -print0)
  for gcc_index in "${!gcc_tools[@]}"; do
    echo "- [$gcc_index] ${gcc_tools[$gcc_index]}"
  done
  echo -n "[*] What version do you want to use? [0] " 
  read gccversion
  if [[ $gccversion == "" ]]; then
    answer=0
  fi
  echo -n "[*] Write the architecture for your ARCH env: [arm] "
  read archbuild
  if [[ $archbuild == "" ]]; then
    archbuild=arm
  fi
  echo "export CC=${gcc_tools[$answer]%gcc}" > /kernel/.kernel.env
  echo "export CROSS_COMPILE=${gcc_tools[$answer]%gcc}" >> /kernel/.kernel.env
  echo "export ARCH=$archbuild" >> /kernel/.kernel.env
  echo "export SUBARCH=$archbuild" >> /kernel/.kernel.env
  echo -n "[*] Do you need to install bootimg-tools? [y/N] "
  read bitools
  if [[ $bitools == "y" || $bitools == "Y" ]]; then
    bootimg
    if [[ $? -eq 0 ]]; then
      echo "alias mkbootimg=/tools/bootimg-tools/mkbootimg/mkbootimg" >> /kernel/.kernel.env
      echo "alias unmkbootimg=/tools/bootimg-tools/mkbootimg/unmkbootimg" >> /kernel/.kernel.env
    fi
  else
    echo -n "[*] Is it already installed? [Y/n] "
    read bitools
    if [[ $bitools == "Y" || $bitools == "y" || $bitools == "" ]]; then
      mkb=$(find /tools -type f -name 'mkbootimg' -print0)
      unmkb=$(find /tools -type f -name 'unmkbootimg' -print0)
      if [[ $mkb != "" && $unmkb != "" ]]; then
        echo "alias mkbootimg=${mkb}" >> /kernel/.kernel.env
        echo "alias unmkbootimg=${unmkb}" >> /kernel/.kernel.env
      fi
    fi
  fi
  echo "[*] Now run:"
  echo "  . /kernel/.kernel.env"
}

bootimg(){
  echo "[*] Cloning bootimg-tools into /tools"
  git clone https://github.com/pbatard/bootimg-tools.git /tools/bootimg-tools
  if [[ $? -ne 0 ]]; then
    echo "[-] Source retrieval failed."
    return 1
  fi
  echo "[*] Compiling bootimg-tools.."
  cd /tools/bootimg-tools
  make -j 2
  if [[ $? -ne 0 ]]; then
    echo "[-] Compilation failed."
    return 1
  else
    echo "[*] bootimg-tools ready to use."
  fi
  return 0
}

main

exit 0
