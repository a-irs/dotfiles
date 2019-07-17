#!/usr/bin/env bash

set -ux

SRC=/dev/disk/by-id/usb-Multiple_Card_Reader_058F63666433-0:0-part1
DEST=/media/data4/photos

MNT=$(mktemp -d)
die() {
    sync && sync
    umount -qlf "$MNT"
    rmdir "$MNT"
    exit $?
}
trap die INT TERM EXIT

if [[ ! -e "$SRC" ]]; then
    echo "SD partition not found"
    exit 1
fi
mount "$SRC" "$MNT" && /usr/bin/vendor_perl/exiftool -v0 -r -o . -FileName<DateTimeOriginal -ext+ AVI -ext+ MP4 -d "$DEST" /%Y/%Y-%m/%Y-%m-%d/%Y%m%d_%H%M%S_%%f.%%ue "$MNT"
