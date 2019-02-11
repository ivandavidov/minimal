#!/bin/sh

echo "Launching lldpd in background"
lldpd -d &

sleep 1
