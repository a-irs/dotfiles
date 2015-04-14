#!/usr/bin/env bash

set -e

CDATE=$(date +%Y-%m-%d)
CTIME=$(date +%H-%M)
CSEC=$(date +%s)

# backup current state
mkdir -p /media/data/backups/sql
DEST="/media/data/backups/sql/srv_kodi_${CDATE}_${CTIME}.sql.gz"
o=$(mysqldump -h 127.0.0.1 -u xbmc -pGtquwKYtYdueTbmI --all-databases 2> /dev/null)
[[ -n "$o" ]] && echo "$o" | gzip > "$DEST"

# delete backups older than 7d
limit=$(date --date=@$((CSEC-60*60*24*7)) +%Y-%m-%d)
find /media/data/backups/sql -name "srv_kodi_*" | sort -h | grep -B 10000 "$limit" | xargs -L1 rm -f
