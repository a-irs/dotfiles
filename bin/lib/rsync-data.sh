#!/usr/bin/env bash

set -e

TARGET=/media/usb-backup

control_c() {
  echo -en "\n*** CTRL+C - starting cleanup ***\n"
  sync
  umount -lf "$TARGET"
  sync
  umount /mnt || true
  cryptsetup close crypto-usb || true
  losetup -d /dev/loop0 || true
  exit $?
}
trap control_c SIGINT

BACKUP=(
	/media/data/apps
	/media/data/books
	/media/data/games
	/media/data/music
	/media/data/photos
	/media/data/videos/kids
	/media/data/virtualbox
)

delay=0.3

if mount "$TARGET"; then
	echo -e '\a' > /dev/console

        ~/.bin/lib/mount-crypto.sh
        losetup /dev/loop0 $TARGET/crypto.img
        cryptsetup open /dev/loop0 crypto-usb
        mount /dev/mapper/crypto-usb /mnt

        date=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
        rsync -av -h --delete --stats \
                --log-file="/mnt/crypto.log" \
                --backup --backup-dir="/mnt/0-archive/$date/" \
                /media/crypto/ /mnt
        umount /mnt
        cryptsetup close crypto-usb
        losetup -d /dev/loop0

	for d in "${BACKUP[@]}"; do
		date=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
		dir=$(basename "$d")
		rsync -av -h --delete --stats \
		    --log-file="$TARGET/$dir.log" \
		    --backup --backup-dir="$TARGET/0-archive/$dir/$date/" \
		    "$d" \
		    "$TARGET"
	done

	sync
	umount -lf "$TARGET"
	sleep 5s
	sync
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console
else
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console
fi
