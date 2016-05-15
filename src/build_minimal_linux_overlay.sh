#!/bin/sh

sh overlay_00_clean.sh
sh overlay_01_get_links.sh
sh overlay_02_build_links.sh
sh overlay_03_get_dropbear.sh
sh overlay_04_build_dropbear.sh

