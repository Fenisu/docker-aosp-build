#!/usr/bin/env bash
#
#  Download Nexus binaries for provided device & build id
#

set -e # fail on unhandled error
set -u # fail on undefined variable

readonly GURL="https://developers.google.com/android/nexus/drivers"
declare -a sysTools=("curl" "wget" "md5sum" "sha1sum")

usage() {
cat <<_EOF
  Usage: $(basename $0) [options]
    OPTIONS:
      -d|--device  : Device AOSP codename (angler, bullhead, etc.)
      -b|--buildID : BuildID string (e.g. MMB29P)
      -o|--output  : Path to AOSP tree (to include in build) (default: $(pwd))
      -t|--blob    : Path to temporary extract blobs (default:  $(pwd)/blob)
_EOF
  exit 1
}

command_exists() {
  type "$1" &> /dev/null
}

check() {
  echo "-- Check"
  # Check that system tools exist
  for i in "${sysTools[@]}"
  do
    if ! command_exists $i; then
      echo "[-] '$i' command not found"
      exit 1
    fi
  done

  DEVICE=""
  DEV_ALIAS=""
  BUILDID=""
  OUTPUT_DIR="$(pwd)"  # Default output dir
  BLOB_DIR="$(pwd)/blob"

  while [[ $# > 1 ]]
  do
    arg="$1"
    case $arg in
      -o|--output)
        OUTPUT_DIR=$(echo "$2" | sed 's:/*$::')
        shift
        ;;
      -d|--device)
        DEVICE=$(echo $2 | tr '[:upper:]' '[:lower:]')
        shift
        ;;
      -b|--buildID)
        BUILDID=$(echo $2 | tr '[:upper:]' '[:lower:]')
        shift
        ;;
      -t|--blob)
        BLOB_DIR=$(echo $2 | sed 's:/*$::')
        shift
        ;;
      *)
        echo "[-] Invalid argument '$1'"
        usage
        ;;
    esac
    shift
  done

  if [[ "$DEVICE" == "" ]]; then
    echo "[-] device codename cannot be empty"
    usage
  fi
  if [[ "$BUILDID" == "" ]]; then
    echo "[-] buildID cannot be empty"
    usage
  fi
  if [[ "$OUTPUT_DIR" == "" || ! -d "$OUTPUT_DIR" ]]; then
    echo "[-] Output directory not found"
    usage
  else
    mkdir -p "$OUTPUT_DIR/blob"
  fi


  echo "[*] Fetch drivers:"
  echo "[*] Device: $DEVICE"
  echo "[*] Build: $BUILDID"
  echo "[*] AOSP path: $OUTPUT_DIR"
  echo "[*] Blob temporary path: $BLOB_DIR"
  echo -n [*] Do you want to continue? [y/n] \ 
  read answer

  if [[ $answer != "y" && $answer != "Y" ]]; then
    exit 2
  fi
  echo -n
}

fetch() {
  echo "-- Fetch"
  #url=$(curl --silent $GURL | grep -i "<a href=.*$DEVICE-$BUILDID" | \
  #      cut -d '"' -f2)
  url=$(curl --silent https://developers.google.com/android/nexus/drivers | \
        grep -i -A 2 "<a href=.*$DEVICE-$BUILDID" | cut -d '"' -f 2 | \
        sed 's/<[^>]*>//g' | tr -d ' ')

  if [ "$url" == "" ]; then
    echo "[-] Binary URL not found"
    exit 1
  fi

  for item in $(echo $url | tr ' ' "\n"); do
    if [[ $item == https* ]]; then
      echo "[*] Downloading binary from '$item'"
      outFile=$BLOB_DIR/$(basename $item)
      wget --quiet -O "$outFile" "$item"
    else
      if [[ ${#item} == 32 ]]; then
        md5=$(md5sum $outFile | cut -d ' ' -f 1)
        if [[ $md5 != $item ]]; then
          echo "[-] MD5 Checksum failed."
          exit 1
        else
          echo "[*] MD5 Checksum OK."
        fi
      elif [[ ${#item} == 40 ]]; then
        sha1=$(sha1sum $outFile | cut -d ' ' -f 1)
        if [[ $sha1 != $item ]]; then
          echo "[-] SHA1 Checksum failed."
          exit 1
        else
          echo "[*] SHA1 Checksum OK."
        fi
      fi
    fi
  done

  echo "[*] Downloading complete."
}

extract() {
  echo "-- Extract"
  for tarfile in $BLOB_DIR/*.tgz; do
    echo "[*] Extracting $tarfile."
    tar xzf $tarfile -C $BLOB_DIR
    if [[ $? -ne 0 ]]; then
      echo "[-] Extraction failed."
      exit 1
    fi
  done
  cd $OUTPUT_DIR
  for extractor_script in $BLOB_DIR/*.sh; do
    echo "[*] Executing extractor $(basename $extractor_script)"
    bash $extractor_script
    if [[ $? -ne 0 ]]; then
      echo "[-] Execution failed."
      exit 1
    else
      echo "[*] Execution of $(basename $extractor_script) done."
    fi
  done
}

main() {
  # Prepare
  check $@

  # Download
  fetch

  # Extract
  extract
}

main $@

exit 0

