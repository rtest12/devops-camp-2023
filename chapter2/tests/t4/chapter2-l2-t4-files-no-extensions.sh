#!/bin/bash
#
# Task 4 - get filename without the extension.
set -eo pipefail


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit "${code}"
}


# Args check
if [ "$#" -ne 1 ]; then
  err  255 'Specify a single directory.'
fi


# Find all regular files in the directory and its subdirectories
find "$1" -type f | while read file; do
# Get the filename without the extension and keep the path
  filename="${file##*/}"
  echo "${file%/*}/${filename%%.*}"
done
