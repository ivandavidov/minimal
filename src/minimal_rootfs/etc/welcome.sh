#!/bin/sh

# Set cyan color.
echo -en "\\e[$1m"

cat /etc/welcome.txt

# Unset all attributes.
echo -en "\\e[0m"

