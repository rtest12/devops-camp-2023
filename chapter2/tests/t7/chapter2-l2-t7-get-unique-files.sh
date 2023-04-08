#!/bin/bash
#
# t7 - get only the filenames
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


# Find only regular files and put in array.
files=$(find "$1" -type f)


# Leave only unique files, without extensions
find "$1" -type f | while read file; do
  echo "${file##*/}"
done | sort -u
