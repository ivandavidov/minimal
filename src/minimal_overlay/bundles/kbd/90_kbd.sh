#!/bin/sh

# This sample command loads German keyboard layout on boot.
#
# loadkeys de

cat << CEOF

  The default keyboard layout is English (US). You can
  change the keyboard layout to German like this:

    loadkeys de
    
  You can go back to the original US keyboard layout
  like this:
  
    loadkeys us
    
  Alternatively, change the file '90_kbd.sh' in the
  'kbd' bundle and set the layout you want to use.

CEOF
