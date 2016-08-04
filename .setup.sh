#!/usr/bin/env bash

os="$(uname)"

print_error() { echo -e "\033[1;31m$*\033[0m"; }
print_skip() { echo -e "\033[34m$*\033[0m"; }
print_cleanup() { echo -e "\033[35m$*\033[0m"; }
print_install() { echo -e "\033[33m$*\033[0m"; }

if [[ "$os" = Darwin ]]; then
    this_dir="$(dirname "$(greadlink -f "$0")")"
else
    this_dir="$(dirname "$(readlink -f "$0")")"
fi

rmlink() {
    dest=~/.$1
    [[ -L "$dest" ]] && rm -f "$dest" && print_cleanup "[CLEANUP] removed ${dest/$HOME/\~}"
}

mklink() {
    dest=~/.$1
    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" = "$this_dir/$1" ]]; then
            # print_skip "[SKIP] ${dest/$HOME/\~}"
            return
        fi
    elif [[ -e "$dest" ]]; then
        print_error "[ERROR] ${dest/$HOME/\~} already exists and is no symlink!"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ "$os" = Darwin ]]; then
        gln --force --symbolic --no-target-directory --no-dereference "$this_dir/$1" "$dest"
    else
        ln --force --symbolic --no-target-directory --no-dereference "$this_dir/$1" "$dest"
    fi
    print_install "[INSTALL] ${dest/$HOME/\~}"
}

install() {
    if command -v "$1" > /dev/null 2>&1; then
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

install_always bin hushlogin
install bash bashrc
install beet config/beets/config.yaml
install htop config/htop/htoprc
install mpd config/mpd/mpd.conf
install ncmpcpp config/ncmpcpp/config
install git gitconfig
install nano nanorc nano/syntax
install psql psqlrc
install ranger config/ranger/rc.conf config/ranger/scope.sh
install ssh ssh/config
install tmux tmux.conf
install vim vimrc vim/autoload/plug.vim vim/snip
install zsh zprofile zshrc zshine

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
install xinit xinitrc Xmodmap config/fontconfig/fonts.conf fonts
install compton config/compton.conf

if [[ -f /usr/bin/kupfer ]]; then
    mkdir -p ~/.local/share/kupfer/plugins
    cp -f "$this_dir/kupfer-recdirs.py" ~/.local/share/kupfer/plugins/recdirs.py
else
    rm -f ~/.local/share/kupfer/plugins/recdirs.py
fi
