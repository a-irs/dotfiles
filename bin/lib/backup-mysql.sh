#!/usr/bin/env bash

set -e

mkdir -p /media/data/backups/sql
DEST="/media/data/backups/sql/srv_kodi_$(date +%Y-%m-%d_%H-%M).sql.gz"
mysqldump -h 127.0.0.1 -u xbmc -pGtquwKYtYdueTbmI --all-databases | gzip > "$DEST"
