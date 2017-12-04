#!/bin/sh

# The default keyboard which is set on boot.
loadkeys us

cat << CEOF
[1m  The default keyboard layout is English (US). You can change the keyboard
  layout to German (for example) like this:

    loadkeys de
    
  You can go back to the original US keyboard layout like this:
  
    loadkeys us
    
  Alternatively, change the file '90_kbd.sh' in the 'kbd' bundle and set the
  keyboard layout you want to use on boot.[0m
CEOF
