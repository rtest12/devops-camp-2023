#!/bin/bash
#
# t7 - get only the filenames
set -eo pipefail


# Error handling function.
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


# We keep only unique files with extensions, without paths.
for file in $files; do
  echo ${file##*/}
done | sort | uniq
