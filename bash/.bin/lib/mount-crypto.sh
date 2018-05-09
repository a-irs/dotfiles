#!/usr/bin/env bash

set -e

UUID=30e17b83-aaa2-4164-9248-00610b01ffed
MOUNTPOINT=/media/crypto
MAPPER_NAME=luks

if [[ $1 == close ]]; then
    umount $MOUNTPOINT
    cryptsetup close $MAPPER_NAME
    rmdir $MOUNTPOINT
    losetup -d /dev/loop0
    exit
fi

losetup --partscan --find --show /media/data4/sdc.img
cryptsetup luksOpen /dev/loop0p1 $MAPPER_NAME
#cryptsetup luksOpen /dev/disk/by-uuid/$UUID $MAPPER_NAME

mkdir -p $MOUNTPOINT
mount /dev/mapper/$MAPPER_NAME $MOUNTPOINT
cd $MOUNTPOINT
