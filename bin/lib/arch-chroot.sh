#!/usr/bin/env bash

if [ -z $1 ]; then
    echo "usage: arch-chroot <chroot-dir>"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Error! Must be run as root." 2>&1
    exit 1
fi

CHROOT_DIR=$1

# Create mount points
mount -t proc proc "$CHROOT_DIR/proc/"
mount -t sysfs sys "$CHROOT_DIR/sys/"
mount -o bind /dev "$CHROOT_DIR/dev/"
mkdir -p "$CHROOT_DIR/dev/pts"
mount -t devpts pts "$CHROOT_DIR/dev/pts/"

[ -f "/etc/resolv.conf" ] && cp "/etc/resolv.conf" "$CHROOT_DIR/etc/"

#mkdir -p "$CHROOT_DIR/etc/pacman.d/"
#echo "Server = http://mirror.netcologne.de/archlinux/\$repo/os/\$arch" >> "$CHROOT_DIR/etc/pacman.d/mirrorlist"
#chroot $CHROOT_DIR pacman-key --init
#chroot $CHROOT_DIR pacman-key --populate archlinux
#chroot $CHROOT_DIR pacman -Syu pacman --force
#[ -f "/etc/resolv.conf" ] && cp "/etc/resolv.conf" "$CHROOT_DIR/etc/"
#echo "Server = http://mirror.netcologne.de/archlinux/\$repo/os/\$arch" >> "$CHROOT_DIR/etc/pacman.d/mirrorlist"
chroot $CHROOT_DIR
