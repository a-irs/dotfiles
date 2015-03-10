#!/usr/bin/env bash

tmp=/var/tmp/offsite-backup

set_up() {
    mkdir -p -m 700 $tmp/${1}-encrypted $tmp/${1}-ecryptfs
    mkdir -p -m 500 $tmp/$1
    echo "$tmp/${1}-encrypted $tmp/${1}-ecryptfs" > $tmp/${1}-ecryptfs/secret.conf
    [ -f $tmp/${1}-ecryptfs/secret.sig ] || read -s -e -r -p "Passphrase: " t; echo "$t" | ecryptfs-add-passphrase | cut -d "[" -f 2 | cut -d "]" -f 1 | tail -n +2 > $tmp/${1}-ecryptfs/secret.sig
    mkdir -p ~/.ecryptfs && cp -f $tmp/${1}-ecryptfs/secret.sig ~/.ecryptfs/sig-cache.txt

    mount | grep "on $tmp/$1" && return 1
    mount -t ecryptfs -o rw,nosuid,nodev,relatime,ecryptfs_sig="$(cat $tmp/${1}-ecryptfs/secret.sig)",ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs $tmp/${1}-encrypted $tmp/$1
}

set_up dell
set_up desktop
