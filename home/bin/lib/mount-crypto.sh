#!/usr/bin/env bash

set -e

IMG=/media/data4/cryptodisk-sdc.img

MOUNTPOINT=/media/crypto
MAPPER_NAME=luks

if [[ $1 == close || $1 == umount ]]; then
    set +e
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

mkdir -p "$MOUNTPOINT"
mount "/dev/mapper/$MAPPER_NAME" "$MOUNTPOINT"
cd "$MOUNTPOINT"
