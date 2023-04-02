#!/bin/bash
#
# Task 2 - Generate kustomization.yaml
set -eo pipefail


err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


# Checks (perms, args, dir-exist)
if ! [[ -r $(pwd) ]]; then
  err "Directory is not readable."
  exit 255
fi

if [[ "$#" -lt 1 ]]; then
  err "At least 1 or more args are expected"
  exit 1
fi

if [[ ! -d "repos" ]]; then
  mkdir repos
fi


# ssh-keys generation
for arg in $@; do
  ssh-keygen -t ed25519 -N "" -C "$arg" -f ./repos/$arg-deploy-key.pem;
done


# Head generation
echo "
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

generatorOptions:
  disableNameSuffixHash: true

secretGenerator:" > ./repos/kustomization.yaml


# Each rep generation
for arg in $@; do
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
      - sshPrivateKey=$arg-deploy-key.pem" >> ./repos/kustomization.yaml
done


# kustomize run
exec kustomize build repos
