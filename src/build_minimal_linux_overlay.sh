#!/bin/sh

# Read the 'OVERLAY_SOFTWARE' property from '.config'
OVERLAY_SOFTWARE="$(grep -i ^OVERLAY_SOFTWARE .config | cut -f2 -d'=')"

if [ "$OVERLAY_SOFTWARE" = "" ] ; then
  echo "There is no overlay software to build."
else
  sh overlay_00_clean.sh

  OVERLAY_PIECES="$(echo $OVERLAY_SOFTWARE | tr ',' ' ')"

  for OVERLAY in $OVERLAY_PIECES
  do
    OVERLAY_SCRIPT=overlay_$OVERLAY.sh
    
    if [ ! -f $OVERLAY_SCRIPT ] ; then
      echo "Error - cannot find overlay script file '$OVERLAY_SCRIPT'."
    else
      echo "Building '$OVERLAY'..."
      sh $OVERLAY_SCRIPT
    fi
  done
fi

