#!/usr/bin/env bash

rm=0
if [[ "$1" == rm ]]; then
    rm=1
fi

os="$(uname)"

print_error() { echo -e "\033[1;31m[ERROR] $*\033[0m"; }
print_skip() { echo -e "\033[34m[SKIP] $*\033[0m"; }
print_remove() { echo -e "\033[35m[REMOVE] $*\033[0m"; }
print_install() { echo -e "\033[33m[INSTALL] $*\033[0m"; }

if [[ "$os" = Darwin ]]; then
    this_dir="$(dirname "$(greadlink -f "$0")")"
else
    this_dir="$(dirname "$(readlink -f "$0")")"
fi

rmlink() {
    dest=~/.$1
    [[ -L "$dest" ]] && rm -f "$dest" && print_remove "${dest/$HOME/\~}"
}

mklink() {
    dest=~/.$1
    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" = "$this_dir/$1" ]]; then
            # print_skip "[SKIP] ${dest/$HOME/\~}"
            return
        fi
    elif [[ -e "$dest" ]]; then
        print_error "${dest/$HOME/\~} already exists and is no symlink!"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ "$os" = Darwin ]]; then
        gln --force --symbolic --no-target-directory --no-dereference "$this_dir/$1" "$dest"
    else
        ln --force --symbolic --no-target-directory --no-dereference "$this_dir/$1" "$dest"
    fi
    print_install "${dest/$HOME/\~}"
}

install() {
    if [[ "$rm" == 1 ]]; then
        for f in "$@"; do
            rmlink "$f"
        done
        return
    fi

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
        if [[ "$rm" == 1 ]]; then
            rmlink "$f"
        else
            mklink "$f"
        fi
    done
}

install_always bin hushlogin
install bash bashrc
install beet config/beets/config.yaml
install git gitconfig
install htop config/htop/htoprc
install mpd config/mpd/mpd.conf
install nano nanorc nano/syntax
install ncmpcpp config/ncmpcpp/config
install psql psqlrc
install ranger config/ranger/rc.conf config/ranger/scope.sh
install ssh ssh/config
install tmux tmux.conf
install vim vimrc vim/autoload/plug.vim vim/snip
install zsh zprofile zshrc zshine

install awesome config/awesome
install compton config/compton.conf
install emulationstation emulationstation/es_systems.cfg
install kodi kodi/userdata/advancedsettings.xml
install mpv config/mpv/input.conf config/mpv/mpv.conf config/mpv/scripts/convert_script.lua config/mpv/scripts/stats.lua
install redshift config/redshift.conf
install retroarch config/retroarch/remap config/retroarch/core-config/gba_bios.bin config/retroarch/core-config/scph5500.bin config/retroarch/core-config/scph5501.bin config/retroarch/core-config/scph5502.bin config/retroarch/retroarch.cfg config/retroarch/retroarch-core-options.cfg
install subl3 config/sublime-text-3/Packages/User
install termite config/termite/config
install xinit xinitrc Xmodmap config/fontconfig/fonts.conf fonts gtkrc-2.0 icons config/user-dirs.dirs config/gtk-3.0/settings.ini
install zathura config/zathura/zathurarc

if [[ -f /usr/bin/kupfer ]]; then
    mkdir -p ~/.local/share/kupfer/plugins
    cp -f "$this_dir/kupfer-recdirs.py" ~/.local/share/kupfer/plugins/recdirs.py
else
    rm -f ~/.local/share/kupfer/plugins/recdirs.py
fi

if [[ -d ~/doc/zsh/ ]]; then
    t=~/doc/zsh/$HOSTNAME
    if [[ "$(readlink "$t")" != ~/.zsh_history ]]; then
        ln -sf ~/.zsh_history "$t"
        print_install "[INSTALL] ${t/$HOME/\~}"
    fi
fi

