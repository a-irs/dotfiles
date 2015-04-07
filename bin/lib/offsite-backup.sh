#!/usr/bin/env bash

rsync --size-only -rv --delete -e "ssh -p 5522" /media/data/backups/duplicity/ alex@zshine.net:backups/duplicity

export PASSPHRASE=$(cat /duplicity-passphrase)
duplicity --archive-dir=/var/tmp/duplicity /media/data/backups/host scp://alex@zshine/backups/host
duplicity --archive-dir=/var/tmp/duplicity /media/data/backups/sql scp://alex@zshine/backups/sql
duplicity --archive-dir=/var/tmp/duplicity /media/data/backups/privat scp://alex@zshine/backups/privat
duplicity --archive-dir=/var/tmp/duplicity /media/data/backups/studium scp://alex@zshine/backups/studium
unset PASSPHRASE
