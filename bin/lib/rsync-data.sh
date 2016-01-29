#!/bin/bash

set -e

TARGET=/media/usb-backup

control_c() {
  echo -en "\n*** CTRL+C - starting cleanup ***\n"
  sync
  umount -lf "$TARGET"
  sync
  exit $?
}
trap control_c SIGINT

BACKUP=(
	/media/data/photos
	/media/data/music
	/media/data/books
	/media/data/virtualbox
	/media/data/games
	/media/data/videos/kids
	/dev/disk/by-uuid/30e17b83-aaa2-4164-9248-00610b01ffed
)

delay=0.3

if mount "$TARGET"; then
	echo -e '\a' > /dev/console

	for d in "${BACKUP[@]}"; do
		date=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
		repo=$TARGET/"$(basename "$d")"

		borg init --encryption none "$repo" || true
		borg create --progress --stats --verbose \
		    --one-file-system \
	    	--compression lz4 \
	    	--chunker-params 19,23,21,4095 \
	    	"$repo"::"$date" \
	    	"$d"
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
