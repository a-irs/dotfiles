#!/usr/bin/env bash

DEST="/media/data/backups/host/srv/dump_$(date +%Y-%m-%d_%H-%M).sql.gz"
mysqldump -h 127.0.0.1 -u xbmc -pGtquwKYtYdueTbmI --all-databases | gzip > "$DEST"
