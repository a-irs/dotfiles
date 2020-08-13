#!/usr/bin/env bash

set -e

TARGET=/media/usb-backup

control_c() {
  set +e
  echo -en "\n*** CTRL+C - starting cleanup ***\n"
  sync
  umount -lf "$TARGET"
  sync
  umount /mnt
  cryptsetup close crypto-usb
  losetup -D
  exit $?
}
trap control_c SIGINT

BACKUP=(
	/media/data/switch
	/media/data/photos
	/media/data/photos_google
	/media/data/photos_print
	/media/data/apps
	/media/data/books
	/media/data/games
	/media/data/music
	/media/data/videos/kids
)

delay=0.3

if mount "$TARGET"; then
	echo -e '\a' > /dev/console

        ~/.bin/lib/mount-crypto.sh
        lo=$(losetup --partscan --find --show $TARGET/crypto.img)
        cryptsetup open "$lo" crypto-usb
        mount /dev/mapper/crypto-usb /mnt

        date=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
        rsync $* -av -h --delete --stats \
                --log-file="/mnt/crypto.log" \
                --exclude="0-archive/" --exclude="borg/" \
                --backup --backup-dir="/mnt/0-archive/$date/" \
                /media/crypto/ /mnt
        umount /mnt
        cryptsetup close crypto-usb
        losetup -d "$lo"

	for d in "${BACKUP[@]}"; do
		date=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
		dir=$(basename "$d")
		rsync $* -av -h --delete --stats \
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
