#!/usr/bin/env bash

set -e

error() {
    echo -e "\033[31;1m>>> $1\033[0m"
    exit 1
}

[[ -z "$1" ]] && error "usage: reinstall.sh <output file from pacman -Qeq>"
[[ ! -f "$1" ]] && error "$1 is not a file"
[[ $UID != 0 ]] && ! which sudo &> /dev/null && error "sudo is missing: install it first as root: pacman -S sudo"

explicit_pkgs=$(cut -d " " -f 1 "$1" | sort)
all_pkgs=$(pacman -Slq | sort)
aur_pkgs=$(comm -23 <(echo "$explicit_pkgs") <(echo "$all_pkgs"))
pac_pkgs=$(comm -13 <(echo "$aur_pkgs") <(echo "$explicit_pkgs"))

echo -e "\n\033[33;1m>>> OFFICIAL PACKAGES:\033[0m\n"
echo "$pac_pkgs" | column -c "$(tput cols)"
echo -e "\n\033[33;1m>>> AUR PACKAGES:\033[0m\n"
echo "$aur_pkgs" | column -c "$(tput cols)"
echo -e "\n\033[31;1m>>> INSTALLATION WILL BE UNATTENDED. TYPE \"YES\" TO CONTINUE:\033[0m\n"
read YES
[[ "$YES" != "YES" ]] && exit 1

echo ""
if [[ $UID == 0 ]]; then
    pacman -S --needed --noconfirm $pac_pkgs
else
    sudo pacman -S --needed --noconfirm $pac_pkgs
fi

if [[ $UID == 0 ]]; then
    echo -e "\n\033[31;1m>>> AUR-PACKAGES COULD NOT BE INSTALLED BECAUSE MAKEPKG MUST BE RUN AS A NON-ROOT USER.\033[0m"
    exit 1
fi

if ! which yaourt &> /dev/null; then
    cd "$(mktemp -d)"
    curl "https://aur.archlinux.org/packages/pa/package-query/PKGBUILD" > PKGBUILD && makepkg --needed --asdeps -cirs --noconfirm
    curl "https://aur.archlinux.org/packages/ya/yaourt/PKGBUILD" > PKGBUILD && makepkg --needed -cirs --noconfirm
fi
yaourt -S --needed --noconfirm "$aur_pkgs"

echo -e "\n\033[32;1m>>> DONE\033[0m\n"
