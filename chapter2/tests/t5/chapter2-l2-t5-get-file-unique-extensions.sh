#!/bin/bash
#
# Task 5 - get all unique extensions of files
set -eo pipefail


# args check
if [ "$#" -ne 1 ]; then
  echo "Specify a single directory."
  exit 1
fi

# Find only regular files and put in array
files=$(find $1 -type f)


# Then we cut out the paths and file names, leaving only unique extensions.
for file in $files; do
  list=${file##*/}
  echo ${list##*.}
done | sort | uniq


