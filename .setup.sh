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
    config/cower/config
    config/htop/htoprc
    config/meat/config
    config/mpd/mpd.conf
    config/ranger/rc.conf
    config/ranger/scope.sh
    gitconfig
    hushlogin
    latexmkrc
    nano-syntax
    nanorc
    ncmpc/config
    openvpn
    psqlrc
    ssh/config
    templates
    tmux.conf
    vim
    vimrc
    zprofile
    zshine
    zshrc
)

dotfiles_x=(
    compton.conf
    config/fontconfig/fonts.conf
    config/sublime-text-3/Packages/User
    config/terminator/config
    config/terminator/config-fullscreen
    config/user-dirs.dirs
    config/skippy-xd/skippy-xd.rc
    fonts
    gtkrc-2.0
    icons
    kodi/userdata/advancedsettings.xml
    themes
    xinitrc
    Xmodmap
)

for f in "${dotfiles[@]}"; do mklink "$f"; done
if [[ -f /usr/bin/X ]]; then
    for fx in "${dotfiles_x[@]}"; do mklink "$fx"; done
else
    for fx in "${dotfiles_x[@]}"; do rmlink "$fx"; done
fi

git clone --depth=1 https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim 2> /dev/null
#vim +PluginInstall +qall
#print_info "installed vundles"

if [[ -f /usr/bin/mpd ]]; then
    touch -a ~/.config/mpd/{database,log,pid,state,sticker.sql}
    print_info "created blank files for MPD"
fi

if [ -f /usr/bin/slim ]; then
    [ -d /usr/share/slim ] && sudo cp -R "$this_dir/slim/"* /usr/share/slim/themes
    echo "#!/bin/sh" | sudo tee "/usr/local/bin/xflock4" > /dev/null
    echo "! pgrep slimlock && slimlock ; xset r rate 200 30" | sudo tee -a "/usr/local/bin/xflock4" > /dev/null
    sudo chmod +x "/usr/local/bin/xflock4"
    print_info "installed themes and /usr/local/bin/xflock4 for SLIM"
fi

if [[ -f /usr/lib/xorg/modules/drivers/radeon_drv.so ]]; then
    rm -f ~/.compton.conf
    ln --force --symbolic --relative --no-target-directory --no-dereference "$this_dir/compton-radeon.conf" ~/.compton.conf 2> /dev/null
    print_info "activated compton.conf for Radeon"
fi

if [[ -f /usr/bin/xfconf-query ]]; then
    s() {
        xfconf-query -c "$1" -p "$2" -s "$3" 2> /dev/null
    }
    s keyboards /Default/KeyRepeat/Delay 200
    s keyboards /Default/KeyRepeat/Rate 30
    s keyboard-layout /Default/XkbDisable false
    s keyboard-layout /Default/XkbLayout de
    s keyboard-layout /Default/XkbVariant nodeadkeys
    s xfce4-session /general/SaveOnExit false
    s xfwm4 /general/button_layout "CHM|"
    s xfwm4 /general/mousewheel_rollup false
    s xfwm4 /general/workspace_count 1
    print_info "set configs for Xfce"
fi



if pidof firefox > /dev/null; then
    echo "Firefox running, exit first!"
    read
fi

if [[ -d ~/.mozilla/firefox ]]; then
    profile=$(find ~/.mozilla/firefox -mindepth 1 -maxdepth 1 -type d | head -n 1)
    mkdir -p "$profile/chrome"
    ln --force --symbolic --relative --no-target-directory --no-dereference "$this_dir/userChrome.css" "$profile/chrome/userChrome.css" 2> /dev/null
    print_info "installed firefox userChrome"

    echo 'user_pref("media.peerconnection.enabled", false);' >> "$profile/prefs.js"
    echo 'user_pref("media.peerconnection.turn.disable", true);' >> "$profile/prefs.js"
    echo 'user_pref("media.peerconnection.use_document_iceservers", false);' >> "$profile/prefs.js"
    echo 'user_pref("media.peerconnection.video.enabled", false);' >> "$profile/prefs.js"
    echo 'user_pref("media.peerconnection.identity.timeout", 1);' >> "$profile/prefs.js"
    print_info "added prefs to prefs.js"
fi
