#!/bin/bash
#
# Task 2 - Generate kustomization.yaml
set -eo pipefail


repo_dir=repos


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code=$1
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit "$code"
}


# Checking permissions
if [[ ! -r "$(pwd)" ]]; then
  err 255 'Directory is not readable.'
fi

if [[ "$#" -lt 1 ]]; then
  err 255 'At least 1 or more args are expected'
fi

if [[ ! -d "$repo_dir" ]]; then
  mkdir $repo_dir
fi


# ssh-keys generation
for repo_name in "$@"; do
  rm -f ./$repo_dir/$repo_name-deploy-key.pem* && ssh-keygen -q -t ed25519 -N "" -C "$repo_name" -f ./$repo_dir/$repo_name-deploy-key.pem;
done


# Generate file beginning
echo "
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:" > ./$repo_dir/kustomization.yaml


# Generate each repo content
for arg in "$@"; do
    echo "
  - name: $arg
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: $arg
    literals:
      - name=$arg
      - url=git@github.com:saritasa-nest/$arg.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$arg-deploy-key.pem" >> ./$repo_dir/kustomization.yaml
done


# kustomize run
exec kustomize build $repo_dir
