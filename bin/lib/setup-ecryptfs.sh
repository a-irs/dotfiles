#!/usr/bin/env bash

set_up() {
    mkdir -p -m 700 /var/tmp/offsite-backup/${1}-encrypted /var/tmp/offsite-backup/${1}-ecryptfs
    mkdir -p -m 500 /var/tmp/offsite-backup/$1
    echo "/var/tmp/offsite-backup/${1}-encrypted /var/tmp/offsite-backup/${1}-ecryptfs" > /var/tmp/offsite-backup/${1}-ecryptfs/secret.conf
    [ -f /var/tmp/offsite-backup/${1}-ecryptfs/secret.sig ] || bash -c 'read -s -e -r -p "Passphrase: " tmp; echo $tmp | ecryptfs-add-passphrase | cut -d "[" -f 2 | cut -d "]" -f 1 | tail -n +2' > /var/tmp/offsite-backup/${1}-ecryptfs/secret.sig
    mkdir -p ~/.ecryptfs && cp -f /var/tmp/offsite-backup/${1}-ecryptfs/secret.sig ~/.ecryptfs/sig-cache.txt
    
    mount | grep "on /var/tmp/offsite-backup/$1" && return 1
    mount -t ecryptfs -o rw,nosuid,nodev,relatime,ecryptfs_sig=$(cat /var/tmp/offsite-backup/${1}-ecryptfs/secret.sig),ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs /var/tmp/offsite-backup/${1}-encrypted /var/tmp/offsite-backup/$1
}

set_up dell
set_up desktop
