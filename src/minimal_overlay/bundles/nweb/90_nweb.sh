#!/bin/sh

nweb 80 /srv/www

cat << CEOF
[1m  'nweb' has been started on port 80, serving '/srv/www'.[0m
CEOF
