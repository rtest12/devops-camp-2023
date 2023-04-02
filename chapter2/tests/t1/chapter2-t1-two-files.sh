#!/bin/bash
#
# Task 1 - existance of files
set -eo pipefail


# Error handling function.
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


# Function for delimiter
print_separator() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}


# Function to generate a random string and write to a file with permissions
create_file() {
  local filecr="$1"
  openssl rand -base64 20 > "$filecr" && chmod 700 "$filecr"
}


# checking permissions
if [[ ! -r $(pwd) ]]; then
  err "Directory is not readable."
  exit 255
fi


# Args check
if [[ "$#" -ne 2 ]]; then
  err "Error: Two arguments are required"
  exit 1
fi


# If the file exists and is a regular file - show, if not - create and fill.
files=("$@")
for file in "${files[@]}"; do
  if [ -e "$file" ]; then
    print_separator
    echo "$file is here": && cat "$file"
    print_separator
  else
    echo "$file not exist, it will be created."
    create_file "$file"
  fi
done
