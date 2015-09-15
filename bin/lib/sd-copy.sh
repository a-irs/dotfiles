#!/usr/bin/env bash

DEST=/media/data/photos
SRC=/media/sd-card

control_c() {
  echo -en "\n*** CTRL+C - starting cleanup ***\n"
  sync
  umount -lf "$SRC"
  sync
  exit $?
}

trap control_c SIGINT

delay=0.3
mount "$SRC"
if [ $? -eq 0 ]; then
        echo -e '\a' > /dev/console
        /root/.bin/camcopy.py "$SRC" "$DEST"
        sync
        umount -lf "$SRC"
        sleep 2s
        sync
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console
else
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console
fi
