#!/bin/bash
#
# Task 4 - get filename without the extension
set -eo pipefail


# Find only regular files and put in var
files=$(find $1 -type f)


# Then we cut off the paths and extensions.
for file in $files; do
  echo ${file%.*}
done


