#!/bin/bash
#
# Task 6 - get only dirs of the files
set -eo pipefail


# args check
if [ "$#" -ne 1 ]; then
  echo "Specify a single directory."
  exit 1
fi


# Find only regular files and put in array
files=$(find $1 -type f)


# Extract file names and keep only unique directories.
for file in $files; do
  echo ${file%/*}
done | sort | uniq
