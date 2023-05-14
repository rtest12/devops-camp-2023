#!/bin/bash
# Task 9 - display new tcp listening connections in the range 10000-10100 into terminator zsh
set -eo pipefail

# The main function to get tcp connections in port range
get_tcp() {
  # Set the port range
  readonly port_range_start='10000'
  readonly port_range_end='10100'
  export port_range="sport >= :$port_range_start and sport <= :$port_range_end"

  print_no_connections() {
    echo "No TCP listening sockets found bound to ports in 10000-10100 range"
    sleep 3
  }

  # Function to get the list of TCP connections in port range, without header
  get_connections() {
    ss -tan "${port_range}" | awk 'NR>1 {printf "%-20s %-20s\n", $4, $5}'
  }

  connections="$(get_connections)"

  # If there are no listening connections, print a message, owerwise show connections
  if [ -z "${connections}" ]; then
    print_no_connections
  else
    echo "Local Address:Port    Peer Address:Port"
    echo "${connections}"
  fi

  # Loop to append connections
  while true; do
    new_connections="$(get_connections)"

    if [ -z "${new_connections}" ]; then
      print_no_connections
      connections="${new_connections}"
    fi


    # If there were no connections before but now there are, print the header again
    if [ -z "${connections}" ] && [ -n "${new_connections}" ]; then
      echo "Local Address:Port    Peer Address:Port"
    fi

    # Compare the new list of connections with the old one and print the unique ones in new_connections
    unique_connections=$(comm -13 <(echo "${connections}" | sort) <(echo "${new_connections}" | sort))

    if [ -n "${unique_connections}" ]; then
      echo "${unique_connections}"
    fi

    connections="${new_connections}"

  done
}


while true; do
    # Retrieve all addresses of Terminator pseudo-interfaces
    pseudo_addresses=$(for pid in $(pgrep -P $(pgrep terminator)); do
        readlink /proc/$pid/fd/0
    done | sort)

    # Use comm to identify new addresses
    new_addresses=$(comm -13 <(printf '%s\n' "${addresses[@]}" | sort) <(echo "$pseudo_addresses"))

    # Add new unique addresses to the addresses array and invoke the get_tcp function for each of them
    for address in $new_addresses
    do
        addresses+=("$address")
        get_tcp >> "$address" 2>&1 &
    done

    sleep 1
done &
