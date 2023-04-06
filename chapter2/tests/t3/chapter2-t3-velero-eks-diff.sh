#!/bin/bash
#
# Task 3 - find namespaces without the backup
set -eo pipefail


readonly SAVED_NS_URL='https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml'
readonly ALL_NS_URL='https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt'


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit "$code"
}

# File exist check
if curl -s --head  --request GET "$ALL_NS_URL" | grep "404" > /dev/null; then
  err 255 'File with saved namespaces list not found'
fi

if curl -s --head  --request GET "$ALL_NS_URL" | grep "404" > /dev/null; then
  err 255 'File with all namespases list not found'
fi


# Downloading YAML, extracting already saved namespaces into array.
saved_namespaces=$(curl -sSL $SAVED_NS_URL | yq '.spec.source.helm.values | from_yaml | .schedules.[].template.includedNamespaces[]')


# Downloading YAML with all namespaces and saving into array.
all_namespaces=$(curl -sSL "$ALL_NS_URL")


# We output only those namespaces that are not present in the array of saved namespaces.
for val in ${all_namespaces[@]}; do
  if [[ ! ${saved_namespaces[@]} =~ ${val} ]]; then
    echo "$val"
  fi
done
