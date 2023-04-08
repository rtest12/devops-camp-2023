#!/bin/bash
#
# Task 6 - get only dirs of the files
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
  err 255 'Two arguments are required.'
fi


# Find only regular files and put in array
files=$(find "$1" -type f)


# Leave only a list of all unique directories, without files
find "$1" -type f | while read file; do
  echo "${file%/*}"
done
