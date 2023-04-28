#!/bin/bash
# Task 8 - display new tcp listening connections in the range 10000-10100
set -eo pipefail


# set the port range
readonly PORT_RANGE_START='10000'
readonly PORT_RANGE_END='10100'
readonly SLEEP_SECONDS='1'

# port range expr
port_range="sport >= :$PORT_RANGE_START and sport <= :$PORT_RANGE_END"


# Check if there are any TCP connections listening on the specified port range
while :
do
  if [[ -z $(ss -l "${port_range}" | grep -v "State") ]]; then
    # If there are no listening connections, print a message and wait for 2 seconds
    echo 'No TCP listening sockets found bound to ports in 10000-10100 range'
    sleep "${SLEEP_SECONDS}"
  else
    # If there are listening connections, print their details
    ss -tan "${port_range}" | awk '{printf "%-20s %-20s\n", $4, $5}'
    sleep "${SLEEP_SECONDS}"
    clear
  fi
done
