#!/usr/bin/env bash
#
#  Set cross compiler environemnt for kernel compilation
#

set -e # fail on unhandled error

gcctool() {
  git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/ /tools/arm-linux-androideabi-4.9/
}
main(){
  echo -n "[*] Do you need to install a cross compiler? [y/N] "
  read gcctools
  if [[ $gcctools == "y" || $gcctools == "Y" ]]; then
    gcctool
  fi
  echo "[*] Looking for *-gcc..."
  gcc_tools=()
  while IFS= read -d $'\0' -r file; do
    gcc_tools=("${gcc_tools[@]}" "$file");
  done < <(find /tools -type f \( -name 'arm-eabi-gcc' -or -name 'arm-linux-androideabi-gcc' -or -name '*-linux-android-gcc' -or -name 'aarch64-linux-android-gcc' \) -print0)
  for gcc_index in "${!gcc_tools[@]}"; do
    echo "- [$gcc_index] ${gcc_tools[$gcc_index]}"
  done
  echo -n "[*] What version do you want to use? [0] "
  read gcc_version
  if [[ $gcc_version == "" ]]; then
    gcc_version=0
  fi
  echo -n "[*] Write the architecture for your ARCH env: [arm64] "
  read archbuild
  if [[ $archbuild == "" ]]; then
    archbuild=arm64
  fi
  echo "export CC=${gcc_tools[$gcc_version]%gcc}" > /kernel/.kernel.env
  echo "export CROSS_COMPILE=${gcc_tools[$gcc_version]%gcc}" >> /kernel/.kernel.env
  echo "export ARCH=${archbuild}" >> /kernel/.kernel.env
  echo "export SUBARCH=${archbuild}" >> /kernel/.kernel.env
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
      mkb=()
      while IFS= read -d $'\0' -r file; do
        mkb=("${mkb[@]}" "$file");
      done < <(find /tools -type f -name 'mkbootimg' -print0)
      if [[ ${#mkb[@]} -ne 1 ]]; then
        for mkb_index in "${!mkb[@]}"; do
          echo "- [$mkb_index] ${mkb[$mkb_index]}"
        done
        echo -n "[*] What mkbootimg do you want to use? [0] "
        read mkb_version
        if [[ $mkb_version == "" ]]; then
          $mkb_version=0
        fi
      else
        mkb_version=0
      fi
      mkb=${mkb[$mkb_version]}
      unmkb=()
      while IFS= read -d $'\0' -r file; do
        unmkb=("${unmkb[@]}" "$file");
      done < <(find /tools -type f -name 'unmkbootimg' -print0)
      if [[ ${#unmkb[@]} -ne 1 ]]; then
        for unmkb_index in "${!unmkb[@]}"; do
          echo "- [$unmkb_index] ${unmkb[$unmkb_index]}"
        done
        echo -n "[*] What mkbootimg do you want to use? [0] "
        read unmkb_version
        if [[ $unmkb_version == "" ]]; then
          $unmkb_version=0
        fi
      else
        unmkb_version=0
      fi
      unmkb=${unmkb[$unmkb_version]}
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
