#!/bin/sh

cat << CEOF

  Starting 'nweb' on port 80. Serving '/srv/www'.

CEOF

nweb 80 /srv/www
