#!/bin/bash
# Task 15 - tcpdump.sh

docker run --rm -it \
  --net container:nginx \
  --cap-add=CAP_NET_ADMIN \
  --cap-add=CAP_NET_RAW \
  --name t15 itsthenetwork/alpine-tcpdump -i eth0 port 80 -v -s 262144 -y EN10MB -A
