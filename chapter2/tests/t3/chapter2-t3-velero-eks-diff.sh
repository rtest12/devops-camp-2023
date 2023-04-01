#!/bin/bash
#
# Task 3 - find namespaces without the backup
set -eo pipefail

# Downloading YAML, extracting already saved namespaces into array.
# Here we are using the from_yaml filter to convert a multi-line string into a YAML data structure,
# after which we can use the dot notation to access the value of includedNamespaces.
# See my explanation in the PR 
savedns=($(curl -sSL https://gist.github.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/velero.yaml \
  | yq eval '.spec.source.helm.values | from_yaml | .schedules.system.template.includedNamespaces[]' ))


# Downloading YAML with all namespaces and saving into array.
allns=($(curl -sSL https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/kubernetes-namespaces.txt ))

# We output only those namespaces that are not present in the second array.
for val in ${allns[@]}; do
  if [[ ! ${savedns[@]} =~ ${val} ]]; then
    echo $val
  fi
done
