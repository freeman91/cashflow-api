#!/bin/sh

# this script runs through crontab on jupiter once a day @ 3am

# crontab contents: 
# -------------------------------------------------------------------------------------------
#
# PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Postgres.app/Contents/Versions/latest/bin
# 0 3 * * * cd ~/production/cashflow && zsh script/jupiter_backup.sh > /tmp/stdout.log 2> /tmp/stderr.log
#
# -------------------------------------------------------------------------------------------

pg_dump -v cashflow_development > ~/postgres/backups/cashflow_jupiter_$(date +%Y%m%d).bak