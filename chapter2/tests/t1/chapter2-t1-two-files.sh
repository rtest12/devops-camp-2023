#!/bin/bash
#
# Task 1 - existance of files
set -eo pipefail


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
  echo 'Directory is not readable.'
  exit 255
fi


# Args check
if [[ "$#" -ne 2 ]]; then
  echo 'Error: Two arguments are required'
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
