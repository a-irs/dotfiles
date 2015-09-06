#!/usr/bin/env bash

set -e

CDATE=$(date +%Y-%m-%d)
CTIME=$(date +%H-%M)
CSEC=$(date +%s)

# backup current state
mkdir -p /media/data/backups/sql
DEST="/media/data/backups/sql/${HOSTNAME}_kodi_${CDATE}_${CTIME}.sql.gz"
o=$(mysqldump -h 127.0.0.1 -u xbmc -pGtquwKYtYdueTbmI --all-databases 2> /dev/null)
[[ -n "$o" ]] && echo "$o" | gzip > "$DEST"

# delete files older than 7 days
limit=$(date -d "7 days ago" +%Y%m%d)
for f in /media/data/backups/sql/${HOSTNAME}_kodi_*.sql.gz; do
    d=$(basename "$f")
    d=$(echo "$d" | cut -d_ -f 3)
    d=${d//-/}
    [[ ${d} -lt ${limit} ]] && echo rm -f "$f"
done
