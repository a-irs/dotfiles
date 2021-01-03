#!/usr/bin/env bash

mountpoint=/media/crypto
crypt=/media/data4/crypto.enc

if [[ $1 == close || $1 == umount ]]; then
    fusermount -u "$mountpoint"
    rmdir "$mountpoint"
else
    mkdir -p "$mountpoint"
    gocryptfs -i 1h "$crypt" "$mountpoint"
fi
