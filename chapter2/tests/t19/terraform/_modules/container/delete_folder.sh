#!/bin/bash
# Script for deleting a folder with a generated HTML file during the execution of the destroy operation.

target_folder="${PWD}/../../../"
folders=("qa" "dev" "prod" "stage")

for folder in "${folders[@]}"
do
    full_path="${target_folder}${folder}"
    if [ -d "${full_path}" ]; then
        rm -rf "${full_path}"
        echo "${full_path} was deleted."
    fi
done
