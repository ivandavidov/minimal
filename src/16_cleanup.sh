#!/bin/sh

# This script is useful if you have executed the MLL build process
# with elevated rights. Ths script recursively reverts the ownership
# of all files back to the original user.

set -e

echo "*** CLEANUP BEGIN ***"

if [ "$(id -u)" = "0" ] ; then
  # Find the original user. Note that this may not always be correct.
  ORIG_USER=`who | head -n 1 | awk '{print \$1}'`

  if [ -n "$var" ]; then
    echo "Applying original ownership to all affected files. This may take a while."
  
    echo "Original user is '$ORIG_USER'."

    # Apply ownership back to original owner for all affected files.
    chown -R $ORIG_USER:$ORIG_USER *
  else
    echo "Original user unknown"
  fi
else
  echo "No need to perform cleanup."
fi

echo "*** CLEANUP END ***"
