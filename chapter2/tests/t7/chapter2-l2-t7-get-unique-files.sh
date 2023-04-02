#!/bin/bash
#
# t7 - get only the filenames
set -eo pipefail


# args check
if [ "$#" -ne 1 ]; then
  echo "Specify a single directory."
  exit 1
fi


# Find only regular files and put in array.
files=$(find $1 -type f)


# We keep only unique files with extensions, without paths.
for file in $files; do
  echo ${file##*/}
done | sort | uniq
