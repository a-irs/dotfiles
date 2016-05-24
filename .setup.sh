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
    [ -L "$dest" ] && rm -f "$dest" && print_error "removed $dest"
    rmdir --ignore-fail-on-non-empty -p "$(dirname "$dest")" 2> /dev/null
    rmdir --ignore-fail-on-non-empty -p "$(dirname "$(dirname "$dest")")" 2> /dev/null
}

mklink() {
    dest=~/.$1
    mkdir -p "$(dirname "$dest")"
    ln --force --symbolic --no-target-directory --no-dereference "$this_dir/$1" "$dest" 2> /dev/null
    if [[ $? != 0 ]]; then
        print_error "error creating link to $dest"
    else
        print_info "${dest/$HOME/\~} <== ${this_dir/$HOME/\~}/$1"
    fi
}

install() {
    if [[ -f "/usr/bin/$1" ]]; then
        shift
        for f in "$@"; do
            mklink "$f"
        done
    else
        shift
        for f in "$@"; do
            rmlink "$f"
        done
    fi
}

install_always() {
    for f in "$@"; do
        mklink "$f"
    done
}

ln -sf /tmp/ ~/.cache 2> /dev/null
mkdir -p ~/.thumbnails &  2> /dev/null
ln -sf ~/.thumbnails ~/.cache/thumbnails 2> /dev/null

install_always bin hushlogin
install gtk-demo gtkrc-2.0 icons config/user-dirs.dirs
install gtk3-demo config/gtk-3.0/settings.ini
install awesome config/awesome
install redshift config/redshift.conf
install emulationstation emulationstation/es_systems.cfg
install subl3 config/sublime-text-3/Packages/User
install termite config/termite/config
install zathura config/zathura/zathurarc
install kodi kodi/userdata/advancedsettings.xml
install mpv config/mpv/input.conf config/mpv/mpv.conf config/mpv/scripts/convert_script.lua config/mpv/scripts/stats.lua
install retroarch config/retroarch/remap config/retroarch/core-config/gba_bios.bin config/retroarch/core-config/scph5500.bin config/retroarch/core-config/scph5501.bin config/retroarch/core-config/scph5502.bin config/retroarch/retroarch.cfg config/retroarch/retroarch-core-options.cfg
install X xinitrc Xmodmap config/fontconfig/fonts.conf fonts
install beet config/beets/config.yaml
install htop config/htop/htoprc
install mpd config/mpd/mpd.conf
install ncmpcpp config/ncmpcpp/config
install git gitconfig
install latexmk latexmkrc
install nano nanorc nano-syntax
install openvpn openvpn
install psql psqlrc
install ssh ssh/config
install tmux tmux.conf
install zsh zprofile zshrc zshine

install compton config/compton.conf
if lspci | grep -e VGA -e 3D | grep -q AMD; then
    rm -f ~/config/compton.conf
    ln --force --symbolic --no-target-directory --no-dereference "$this_dir/config/compton-radeon.conf" ~/.config/compton.conf 2> /dev/null
    print_info "activated compton.conf for AMD"
fi

if [[ -f /usr/bin/kupfer ]]; then
    mkdir -p ~/.local/share/kupfer/plugins
    cp -f "$this_dir/kupfer-recdirs.py" ~/.local/share/kupfer/plugins/recdirs.py
fi
