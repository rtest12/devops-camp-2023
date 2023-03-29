#!/bin/bash
set -eo pipefail
# Args check
if [[ "$#" -ne 2 ]]; then
    echo "Error: Two arguments are required"
    exit 1
fi
# Function for delimiter
print_separator() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}
# Function to generate a random string and write to a file with permissions
gen_rand_str() {
    local file="$1"
    openssl rand -base64 20 > "$file" && chmod 700 "$file"
}

if   [[ ! -r `pwd` ]]; then
    echo "Directory is not readable."
    exit 255
elif [[ -e $1 && -e $2 ]]; then
    print_separator
    echo file $1 is here: && cat $1
    print_separator
    echo file $2 is here: && cat $2
    print_separator
elif [[ ! -e $1 && -e $2 ]]; then
    echo file $1 not exist, it will be created. File $2 here:
    print_separator
    cat $2
    print_separator
    gen_rand_str $1
elif [[ ! -e $2 && -e $1 ]]; then
    echo file $2 not exist, it will be created. File $1 here:
    print_separator
    cat $1
    print_separator
    gen_rand_str $2
else echo files dont exist, they will be created. 
    gen_rand_str $1; gen_rand_str $2
fi