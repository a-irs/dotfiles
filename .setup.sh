#!/usr/bin/env bash

this_dir="$(dirname "$(readlink -f "$0")")"

print_error() {
    echo -e "\033[1;31m$*\033[0m"
}

print_info() {
    echo -e "\033[33m$*\033[0m"
}

rmlink() {
    dest=~/.$1
    [ -L "$dest" ] && rm -f "$dest"
    rmdir --ignore-fail-on-non-empty -p "$(dirname "$dest")" 2> /dev/null
}

mklink() {
    dest=~/.$1
    mkdir -p "$(dirname "$dest")"
    ln --force --symbolic --relative --no-target-directory --no-dereference "$this_dir/$1" "$dest" 2> /dev/null
    if [[ $? != 0 ]]; then
        print_error "error creating link to $dest"
    else
        print_info "${dest/$HOME/\~} <== ${this_dir/$HOME/\~}/$1"
    fi
}

dotfiles=(
    bin
    config/beets/config.yaml
    config/htop/htoprc
    config/mpd/mpd.conf
    config/mopidy/mopidy.conf
    config/ncmpcpp/config
    config/ranger/rc.conf
    config/ranger/scope.sh
    gitconfig
    hushlogin
    latexmkrc
    nano-syntax
    nanorc
    openvpn
    psqlrc
    ssh/config
    tmux.conf
    zprofile
    zshine
    zshrc
)

dotfiles_x=(
    atom/config.cson
    atom/init.coffee
    atom/keymap.cson
    atom/snippets.cson
    atom/styles.less
    compton.conf
    config/redshift.conf
    config/awesome
    config/fontconfig/fonts.conf
    config/gtk-3.0/settings.ini
    config/mpv/input.conf
    config/mpv/mpv.conf
    config/mpv/scripts/convert_script.lua
    config/mpv/scripts/stats.lua
    config/retroarch/retroarch.cfg
    config/sublime-text-3/Packages/User
    config/termite/config
    config/user-dirs.dirs
    config/zathura/zathurarc
    emulationstation/es_systems.cfg
    fonts
    gtkrc-2.0
    icons
    kodi/userdata/advancedsettings.xml
    xinitrc
    Xmodmap
    Xresources
)

for f in "${dotfiles[@]}"; do mklink "$f"; done
if [[ -f /usr/bin/X ]]; then
    for fx in "${dotfiles_x[@]}"; do mklink "$fx"; done
else
    for fx in "${dotfiles_x[@]}"; do rmlink "$fx"; done
fi

if [[ -f /usr/bin/kupfer ]]; then
    mkdir -p ~/.local/share/kupfer/plugins
    cp -f "$this_dir/kupfer-recdirs.py" ~/.local/share/kupfer/plugins/recdirs.py
fi

if [[ -f /usr/lib/xorg/modules/drivers/radeon_drv.so ]]; then
    rm -f ~/.compton.conf
    ln --force --symbolic --relative --no-target-directory --no-dereference "$this_dir/compton-radeon.conf" ~/.compton.conf 2> /dev/null
    print_info "activated compton.conf for Radeon"
fi

if [[ -f /usr/bin/apm ]]; then
    new_packages=$(comm -23 <(cat "$this_dir/atom/PACKAGES.txt" | sort) <(apm ls -b -i | cut -d@ -f 1 | sort))
    [[ -n "$new_packages" ]] && apm install $new_packages
fi
