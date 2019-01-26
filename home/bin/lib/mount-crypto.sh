#!/usr/bin/env bash

set -e

IMG=/media/data4/cryptodisk-sdc.img
# UUID=30e17b83-aaa2-4164-9248-00610b01ffed

MOUNTPOINT=/media/crypto
MAPPER_NAME=luks

if [[ $1 == close || $1 == umount ]]; then
    umount "$MOUNTPOINT"
    cryptsetup close "$MAPPER_NAME"
    rmdir $MOUNTPOINT
    losetup -D
    exit
fi

if mountpoint -q "$MOUNTPOINT"; then
    printf '%s\n' "$MOUNTPOINT is already mounted"
    exit
fi


LOOP=$(losetup --partscan --find --show "$IMG")
cryptsetup luksOpen "${LOOP}p1" "$MAPPER_NAME"
#cryptsetup luksOpen /dev/disk/by-uuid/$UUID $MAPPER_NAME

mkdir -p "$MOUNTPOINT"
mount "/dev/mapper/$MAPPER_NAME" "$MOUNTPOINT"
cd "$MOUNTPOINT"
