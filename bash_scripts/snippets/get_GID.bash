#!/usr/bin/env bash

# Get GID from GROUPNAME group
awk -F':' '/GROUPNAME/{print $3}' /etc/group
