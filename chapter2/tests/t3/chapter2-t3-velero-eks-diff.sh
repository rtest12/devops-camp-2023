#!/bin/bash
# Task 3 - find namespaces without the backup
set -eo pipefail


readonly VELERO_URL='https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml'
readonly ALL_NAMESPACES_URL='https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt'

# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: ${*}" >&2
  exit "${code}"
}

# Function for checking file existence and downloading it.
# $1 - URL to the file
get_file() {
  local url="$1"
  if ! curl -sSL --head --request GET "${url}" | grep "HTTP/2\ 200" > /dev/null; then
    err 255 "Error getting ${url}"
  else
    curl -sSL "${url}"
  fi
}

# Check if yq is installed.
if ! command -v yq > /dev/null; then
  err 255 'yq is not installed'
fi


# Download from URLs using the get_file function.
backup_namespaces=$(get_file "${VELERO_URL}")
all_namespaces=$(get_file "${ALL_NAMESPACES_URL}")

# Convert the output to an array.
#readarray -t backup_namespaces_array <<< "$backup_namespaces"

# Process the backup namespaces YAML, and extract the included namespaces.
saved_namespaces=$(yq '.spec.source.helm.values | from_yaml | .schedules.[].template.includedNamespaces[]' <<< "${backup_namespaces}")


# We output only those namespaces that are not present in the array of saved namespaces.
for namespace in ${all_namespaces[@]}; do
  if [[ ! "${saved_namespaces[@]}" =~ "${namespace}" ]]; then
    echo "${namespace}"
  fi
done | sort -u
