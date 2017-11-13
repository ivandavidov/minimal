#!/bin/bash

for script in $(ls | grep '^[0-9]*_.*.sh'); do
  echo "$script"
  time ./"$script"
done
