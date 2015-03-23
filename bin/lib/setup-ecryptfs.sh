#!/usr/bin/env bash

tmp=/var/tmp/offsite-backup

set_up() {
    mkdir -p -m 700 "$tmp/${1}-encrypted"
    mkdir -p -m 500 "$tmp/$1"

    mount | grep "on $tmp/$1" && return 1
    mount -t ecryptfs -o rw,nosuid,nodev,relatime,ecryptfs_sig="$(cat ~/.ecryptfs/sig-cache.txt)",ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs "$tmp/${1}-encrypted" "$tmp/$1"
}

set_up dell
set_up desktop