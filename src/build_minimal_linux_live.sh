#!/bin/sh

set -e

for script in $(ls | grep '^[0-9]*_.*.sh'); do
  echo "Executing script '$script'."
  ./$script
done
