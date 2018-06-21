#!/bin sh

# This script shuts down the OS after one minute.
sleep 60 && poweroff &

cat << CEOF
[1m  Minimal Linux Live will shut down in 60 seconds.[0m
CEOF
