#!/bin/bash
# Task 8 - display new tcp listening connections in the range 10000-10100
set -eo pipefail

# set the port range and others constants
readonly PORT_RANGE_START='10000'
readonly PORT_RANGE_END='10100'
readonly SLEEP_SECONDS='4'
# port range expr
export port_range="sport >= :$PORT_RANGE_START and sport <= :$PORT_RANGE_END"

# list all tcp connections in the port range
ss_output() {
  ss -tan "${port_range}" | awk '{printf "%-20s %-20s\n", $4, $5}'
}

# Initialize the list of existing and new connections
EXISTING_CONNECTIONS=$(ss_output)
NEW_CONNECTIONS_LIST=()

# Loop until there are no more new connections
while :
do
  # Get the list of TCP listening sockets in the specified port range
  NEW_CONNECTIONS=$(ss_output)
    while [[ -z $(ss -ltnp -at "${port_range}" | grep -v "State") ]]
  do
    # If there are no listening connections, print a message and wait for N seconds
    echo "No TCP listening sockets found bound to ports in 10000-10100 range"
    sleep "${SLEEP_SECONDS}"
  done
  # Iterate over each new connection
  while read -r NEW_CONNECTION
  do
    # Check if the new connection is already in the list of existing connections
    if ! [[ "${EXISTING_CONNECTIONS[*]}" =~ "${NEW_CONNECTION}" ]]
    then
      # If the new connection is not in the list of existing connections, add it to the list of new connections
      NEW_CONNECTIONS_LIST+=("${NEW_CONNECTION}")
    fi
  done <<< "${NEW_CONNECTIONS}"
  
  # If there are new connections, display them for N seconds and add them to the list of existing connections
  if [ ${#NEW_CONNECTIONS_LIST[@]} -ne 0 ]; then
    clear
    echo -e "New connections:\nLocal Address:Port   Peer Address:Port"
    for CONNECTION in "${NEW_CONNECTIONS_LIST[@]}"; do
      echo "${CONNECTION}"
      EXISTING_CONNECTIONS+=("${CONNECTION}")
    done
    NEW_CONNECTIONS_LIST=()
    sleep "${SLEEP_SECONDS}"
  else
    # If there are no new connections, display the list of existing connections
    clear
    echo "Existing connections:"
    ss_output
    sleep 1
  fi
done
