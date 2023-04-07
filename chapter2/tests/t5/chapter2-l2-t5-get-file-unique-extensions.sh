#!/bin/bash
#
# Task 5 - get all unique extensions of files
set -eo pipefail


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit "$code"
}


# args check
if [ "$#" -ne 1 ]; then
  err 255 'Specify a single directory.'
fi

# Find only regular files and put in array
files=$(find "$1" -type f)


# Then we cut out the paths and file names, leaving only unique extensions.
for file in ${files}; do
# local var list
  list=${file##*/}
  if echo "${list}" | grep -q "\."; then
    echo "${list##*.}"
  fi
done | sort -u
