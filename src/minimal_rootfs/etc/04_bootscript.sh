#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh
#  |
#  +--(2) /etc/02_overlay.sh
#          |
#          +-- /etc/03_init.sh
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh (this file)
#                    |       |
#                    |       +-- /etc/autorun/* (all scripts)
#                    |
#                    +--(2) /bin/sh (Alt + F1, main console)
#                    |
#                    +--(2) /bin/sh (Alt + F2)
#                    |
#                    +--(2) /bin/sh (Alt + F3)
#                    |
#                    +--(2) /bin/sh (Alt + F4)

echo -e "Welcome to \\e[1mMinimal \\e[32mLinux \\e[31mLive\\e[0m (/sbin/init)"

# Autorun functionality
if [ -d /etc/autorun ] ; then
for AUTOSCRIPT in /etc/autorun/*
  do
    if [ -f "$AUTOSCRIPT" ] && [ -x "$AUTOSCRIPT" ]; then
      echo -e "Executing \\e[32m$AUTOSCRIPT\\e[0m in subshell."
      $AUTOSCRIPT
    fi
  done
fi

