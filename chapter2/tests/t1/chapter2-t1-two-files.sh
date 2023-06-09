#!/bin/bash
#
# Task 1 - existance of files
set -eo pipefail


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: ${*}" >&2
  exit "${code}"
}


# Function for delimiter
print_separator() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}


# Function to generate a random string and write to a file in a local directory with permissions
create_file() {
  local file="$1"
  file="${file##*/}"
  # Generate random data, write it to the file and set the file permissions
  openssl rand -base64 20 > "${file}" && chmod 700 "${file}"
}


# Checking permissions
if [[ ! -r "$(pwd)" ]]; then
  err 255 'Directory is not readable.'
fi

# Args check
if [[ "$#" -ne 2 ]]; then
  err 1 'Two arguments are required.'
fi


# If the file exists and is a regular file - show, if not - create and fill.
for file in "$@"; do
  if [ -e "${file}" ]; then
    print_separator
    echo "${file} is here:" && cat "${file}"
    print_separator
  else
    echo "${file} not exist, it will be created in a local directory."
    create_file "${file}"
  fi
done
