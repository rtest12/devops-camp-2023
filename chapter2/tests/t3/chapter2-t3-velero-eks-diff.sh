#!/bin/bash
#
# Task 3 - find namespaces without the backup
set -eo pipefail


readonly VALERO_URL='https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml'
readonly ALL_NAMESPACES_URL='https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt'


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
exit "${code}"
}


# Function for checking file existence and downloading it.
# $1 - URL to the file
# $2 - Var name to save
get_file() {
  local url="$1"
  local save_to_var="$2"
  if ! curl -sSL --head --request GET "${url}" | grep "200" > /dev/null; then
    err 255 "Error getting ${url}"
  else
    declare -g "$save_to_var=$(curl -sSL "${url}")"
  fi
}


# Check if yq is installed.
if ! command -v yq > /dev/null; then
  err 255 'yq is not installed'
fi


get_file "${VALERO_URL}" "valero"
get_file "${ALL_NAMESPACES_URL}" "all_namespaces"


# Processing YAML, extracting namespaces being preserved into an array.
saved_namespaces=$(yq '.spec.source.helm.values | from_yaml | .schedules.[].template.includedNamespaces[]' <<< "${valero}")


# We output only those namespaces that are not present in the array of saved namespaces.
for namespace in ${all_namespaces[@]}; do
  if [[ ! "${saved_namespaces[@]}" =~ "${namespace}" ]]; then
    echo "${namespace}"
  fi
done