#!/usr/bin/env bash

set -e

b=/media/data/backups

rsync --size-only -rv --delete -e "ssh -p 5522" "$b/duplicity" alex@zshine.net:backups

export PASSPHRASE=$(cat /duplicity-passphrase)
duplicity --archive-dir=/var/tmp/duplicity "$b/host" scp://alex@zshine.net:5522/backups/host
duplicity --archive-dir=/var/tmp/duplicity "$b/sql" scp://alex@zshine.net:5522/backups/sql
duplicity --archive-dir=/var/tmp/duplicity "$b/privat" scp://alex@zshine.net:5522/backups/privat
duplicity --archive-dir=/var/tmp/duplicity "$b/studium" scp://alex@zshine.net:5522/backups/studium
unset PASSPHRASE
