#!/bin/bash
#
# Task 2 - Generate kustomization.yaml
set -eo pipefail


readonly REPO_DIR='repos'


# Function for printing error messages and exiting with a specific exit code
# $1 - The exit code to use when exiting the script
# $2 - The error message to print
err() {
  local code="$1"
  shift
  echo "[[ERROR]: $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit "$code"
}


# Checking arguments for compliance with repository syntax.
for arg in "$@"; do
  if [[ ! "${arg}" =~ ^[A-Za-z0-9_.-]+$ ]]; then
    err 255 'Invalid repository name.'
  fi
done


# Checking permissions
if [[ ! -r "$(pwd)" ]]; then
  err 255 'Directory is not readable.'
fi

if [[ "$#" -lt 1 ]]; then
  err 255 'At least 1 or more args are expected'
fi

if [[ ! -d "$REPO_DIR" ]]; then
  mkdir "$REPO_DIR"
fi


# ssh-keys generation
for repo_name in "$@"; do
  rm -f "./$REPO_DIR/$repo_name-deploy-key.pem" && ssh-keygen -q -t ed25519 -N "" -C "$repo_name" -f "./$REPO_DIR/$repo_name-deploy-key.pem";
done


# Generate file beginning
cat << EOF > ./$REPO_DIR/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:
EOF

# Generate each repo content
for repo_name in "$@"; do
    cat << EOF >> ./$REPO_DIR/kustomization.yaml
  - name: $repo_name
    namespace: argo-cd
    options:
      labels:
        argocd.argoproj.io/secret-type: $repo_name
    literals:
      - name=$repo_name
      - url=git@github.com:saritasa-nest/$repo_name.git
      - type=git
      - project=default
    files:
      - sshPrivateKey=$repo_name-deploy-key.pem
EOF
done


# kustomize run
exec kustomize build "$REPO_DIR"
