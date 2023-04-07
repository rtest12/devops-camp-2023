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
  exit "$code"
}


# Args check
if [ "$#" -ne 1 ]; then
  err  255 'Specify a single directory.'
fi


# Directory exist check
if [ ! -d "$1" ]; then
  err  255 'Directory does not exist.'
fi


# Find only regular files and put in array.
files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(find "$1" -type f -print0)


# Then we cut off the paths and extensions.
for file in "${files[@]}"; do
  echo "${file%%.*}"
done
