#!/bin/sh

# This script shuts down the OS after one minute.
sleep 30 && poweroff &

cat << CEOF
[1m  Minimal Linux Live will shut down in 30 seconds.[0m
CEOF

