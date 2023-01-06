#!/usr/bin/env bash

# Get IP address
ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'

ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'

ip -o route get to 1.1.1.1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'

[[ $(ip addr | grep enp0s25) != '' ]] && ip addr show dev enp0s25 | sed -n -r 's@.*inet (.*)/.*brd.*@\1@p' || ip addr show dev eth0 | sed -n -r 's@.*inet (.*)/.*brd.*@\1@p' 

# Get IP address with subnet suffix
ip -o -4 addr show | grep "${INTERFACE}" | awk '/scope global/ {print $4}' | head -n 1
