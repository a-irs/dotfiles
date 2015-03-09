#!/usr/bin/env bash

set -e

send_backup() {
    [ "$(ls -A /tmp/offsite-backup/$1)" ] || exit 1
    rsync -axz --delete --numeric-ids -e 'ssh -p 5522' "/tmp/offsite-backup/$1" alex@zshine.net:backups
    scp -P 5522 "/media/data/backups/host/$1/.encfs6.xml" "alex@zshine.net:backups/$1/encfs6.xml"
}

send_backup dell
send_backup desktop
