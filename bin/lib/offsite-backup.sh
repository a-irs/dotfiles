#!/usr/bin/env bash

set -e

send_backup() {
    mount | grep "on /tmp/offsite-backup/$1" || return 1
    [[ $? == 1 ]] && return 1

    rsync -a --delete --numeric-ids "/media/data/backups/host/$1/" "/tmp/offsite-backup/$1"
    rsync -a --compress --delete --numeric-ids "/tmp/offsite-backup/$1-encrypted" alex@zshine.net:backups
    rsync -a --compress --delete --numeric-ids "/tmp/offsite-backup/$1-ecryptfs" alex@zshine.net:backups
    scp "/media/backups/$1/.encfs6.xml" "alex@zshine.net:backups/$1/encfs6.xml"
}

send_backup dell
send_backup desktop
