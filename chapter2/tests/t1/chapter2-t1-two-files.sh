#!/bin/bash
#
# Task 1 - existance of files
set -eo pipefail


# Error handling function.
# TODO: add extra argument error_code
err() {
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


# Function for delimiter
print_separator() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}


# Function to generate a random string and write to a file in local folder with permissions
create_file() {
  local file="$1"
  if [[ "$file" == /* ]]; then
    file="${file##*/}"
  fi
  local script_dir=$(dirname "$(realpath "$0")")
  local file_path="$script_dir/$file"
  openssl rand -base64 20 > "$file_path" && chmod 700 "$file_path"
}



# checking permissions
if [[ ! -r "$(pwd)" ]]; then
  err "Directory is not readable."
  exit 255
fi


# Args check
if [[ "$#" -ne 2 ]]; then
  err "Error: Two arguments are required"
  exit 1
fi


# If the file exists and is a regular file - show, if not - create and fill.
for file in "$@"; do
  if [ -e "$file" ]; then
    print_separator
    echo "$file is here:" && cat "$file"
    print_separator
  else
    echo "$file not exist, it will be created."
    create_file "$file"
  fi
done
