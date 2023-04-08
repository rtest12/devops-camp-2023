#!/bin/bash
#
# Task 8 - display new tcp listening connections in the range 10000-10100
set -eo pipefail


# set the port range
readonly PORT_RANGE_START='10000'
readonly PORT_RANGE_END='10100'


# port range expr
port_range="sport >= :$PORT_RANGE_START and sport <= :$PORT_RANGE_END"


# Check if there are any TCP connections listening on the specified port range
while :
do
  if [[ -z $(ss -tano "$port_range" | grep -v "State") ]]; then
    # If there are no listening connections, print a message and wait for 2 seconds
    echo 'No TCP listening sockets found bound to ports in 10000-10100 range'
    sleep 2
  else
    # If there are listening connections, print their details
    ss -tano "$port_range" | awk "{printf \"%-20s %-20s\n\", \$4, \$5}"
    sleep 1
    clear
  fi
done
