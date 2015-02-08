#!/bin/bash

dest='/run/media/alex/ARCH_USB'
device_label='ARCH_USB'
source='/'

if [[ $EUID -ne 0 ]]; then
    echo "Error! Must be run as root." 2>&1
    exit 1
fi

if [ ! -d "$dest" ]; then
    echo "Error! Destination does not exist. Forgot to mount target?" 2>&1
    exit 2
fi

rsync -aAXxv --delete --stats -h \
--exclude '/swap' \
--exclude '/mnt/*' \
--exclude '/dev/*' \
--exclude '/media/*' \
--exclude '/proc/*' \
--exclude '/tmp/*' \
--exclude '/sys/*' \
--exclude '/lost+found' \
--exclude '/run/*' \
--exclude '/usr/lib/share/gtk-doc/*' \
--exclude '/var/tmp/*' \
--exclude '/var/log/journal/*' \
--exclude '/var/cache/*' \
--exclude '/var/run/*' \
--exclude '/home/alex/downloads/*' \
--exclude '/home/alex/.cache/*' \
--exclude '/home/alex/.xbmc/userdata/Thumbnails/*' \
--exclude '/home/alex/.thumbnails/*' \
--exclude '/home/alex/.dropbox/command_socket' \
--exclude '/home/alex/.dropbox/iface_socket' \
--exclude '/home/alex/.local/share/Trash' \
--exclude '/home/alex/Dropbox/*' \
--exclude '/home/alex/gvfs/*' \
--exclude '/home/alex/.gvfs/*' \
--exclude '/home/alex/.local/share/gvfs-metadata/*' \
--exclude '/home/alex/sync/studium' \
--exclude '/home/alex/sync/tex' \
--exclude '/home/alex/wallpapers' \
$source $dest
touch $dest/$(date '+%Y-%m-%d_%H-%M')


device=$(blkid -L $device_label)
devicecut=$(echo $device | rev | cut -b 2- | rev)
uuid=$(lsblk -no UUID $device)


echo
echo MAKING BOOTABLE FSTAB FOR USB
echo
mv "$dest/etc/fstab" "$dest/etc/fstab.ORIGINAL"
echo "UUID=$uuid / ext4 defaults,noatime 0 0
tmpfs /home/alex/.cache tmpfs mode=1777,noatime 0 0" | tee "$dest/etc/fstab" > /dev/null

echo CUSTOMIZING GRUB.CFG FOR USB-BOOT
echo
mv "$dest/boot/grub/grub.cfg" "$dest/boot/grub/grub.cfg.ORIGINAL"
echo "set timeout=0
set default=0
menuentry 'Arch USB' {
	insmod gzio
	insmod part_msdos
	insmod ext2
	set root='hd0,msdos1'
	if [ x$feature_platform_search_hint = xy ]; then
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  $uuid
	else
	  search --no-floppy --fs-uuid --set=root $uuid
	fi
	linux	/boot/vmlinuz-linux-pf root=UUID=$uuid rw quiet ipv6.disable=1
	initrd	/boot/initramfs-linux-pf.img
}" | tee "$dest/boot/grub/grub.cfg" > /dev/null

echo DISABLING AUTOLOGIN + STARTX
echo
mv "$dest/home/alex/.zprofile" "$dest/home/alex/zprofile.ORIGINAL"
rm -f $dest/home/alex/.zprofile
rm -f $dest/etc/systemd/system/getty@tty1.service.d/autologin.conf

#echo SETTING OPENBOX AS WINDOW-MANAGER WITH DISABLED AUTOSTART
#echo
#mv "$dest/home/alex/.xinitrc" "$dest/home/alex/xinitrc.ORIGINAL"
#echo "exec dbus-launch openbox-session" | tee "$dest/home/alex/.xinitrc" > /dev/null
mkdir "$dest/home/alex/.config/autostart.ORIGINAL/"
mv $dest/home/alex/.config/autostart/* "$dest/home/alex/.config/autostart.ORIGINAL/"
cp "$dest/home/alex/.config/autostart.ORIGINAL/docky.desktop" "$dest/home/alex/.config/autostart/docky.desktop"

echo DISABLING BTSYNC
echo
rm "$dest/etc/systemd/system/multi-user.target.wants/btsync@alex.service"

mv "$dest/etc/issue" "$dest/etc/issue.ORIGINAL"
echo "Arch Linux \r (\n) (\l)

after restoring this bootable image, do not forget to copy back the original files:

/boot/grub/grub.cfg.ORIGINAL
/etc/fstab.ORIGINAL
/etc/issue.ORIGINAL
/home/alex/.config/autostart.ORIGINAL/
/home/alex/zprofile.ORIGINAL

" | tee "$dest/etc/issue" > /dev/null


