#!/bin/bash
#
# Task 4 - get filename without the extension.
set -eo pipefail


err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


# args check
if [ "$#" -ne 1 ]; then
  err "Specify a single directory."
  exit 1
fi


# Find only regular files and put in array.
files=$(find $1 -type f)


# Then we cut off the paths and extensions.
for file in $files; do
  echo ${file%.*}
done
