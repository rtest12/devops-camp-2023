#!/bin/bash
if ! [[ -r `pwd` ]]; then
    echo "Directory is not readable."
    exit 255
elif [[ "$#" -lt 2 ]]; then
    echo "At least 2 args are expected"
    exit 1
elif [[ "$#" -gt 2 ]]; then
    echo "Too many args, only 2 args are expected"
    exit 1
elif [[ -e $1 && -f $2 ]]; then
    cat $1 $2
elif [[ ! -e $1 && -e $2 ]]; then
    echo file $1 not exist, it will be created. File $2 here:
    cat $2
    `openssl rand -base64 20 > $1 && chmod 700 $1`
elif [[ ! -e $2 && -e $1 ]]; then
    echo file $2 not exist, it will be created. File $1 here:
    cat $1
    `openssl rand -base64 20 > $2 && chmod 700 $2`
else echo files dont exist, they will be created. 
    `openssl rand -base64 20 > $1 && chmod 700 $1; openssl rand -base64 20 > $2 && chmod 700 $2` 
fi