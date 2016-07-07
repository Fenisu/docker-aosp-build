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
  done < <(find /tools -type f \( -name 'arm-eabi-gcc' -or -name 'arm-linux-androideabi-gcc' \) -print0)
  for gcc_index in "${!gcc_tools[@]}"; do
    echo "- [$gcc_index] ${gcc_tools[$gcc_index]}"
  done
  echo -n [*] What version do you want to use? [0-${gcc_index}] \ 
  read answer
  echo "[*] Now run:"
  echo "  source /kernel/.kernel.env"
  echo "export CC=${gcc_tools[$answer]%gcc}" > /kernel/.kernel.env
  echo "export CROSS_COMPILE=${gcc_tools[$answer]%gcc}" >> /kernel/.kernel.env
  echo "export ARCH=arm" >> /kernel/.kernel.env
  echo "export SUBARCH=arm" >> /kernel/.kernel.env
}

main
