#!/usr/bin/env bash

set -e

function toggleChromium() {
    already_set=false

    set +e
    was_running=false
    if pgrep -x chromium > /dev/null; then
        was_running=true
        killall chromium
    fi
    set -e

    line=$(grep -n "force-device-scale-factor" ~/.local/share/applications/chromium.desktop | cut -f1 -d:)
    value=$(grep "force-device-scale-factor" ~/.local/share/applications/chromium.desktop | rev | cut -d"=" -f 1 | rev | cut -d " " -f 1 | tr -d "[[:space:]]")


    no=1

    if [[ $1 == normal ]]; then
        sed --follow-symlinks -i "$line s|$hi|$no|" ~/.local/share/applications/chromium.desktop
        echo "Chromium: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed --follow-symlinks -i "$line s|$no|$hi|" ~/.local/share/applications/chromium.desktop
        echo "Chromium: HiDPI"
        already_set=true
    fi

    if [[ $value == "$no" && already_set == false ]]; then
        sed --follow-symlinks -i "$line s|$no|$hi|" ~/.local/share/applications/chromium.desktop
        echo "Chromium: normal → HiDPI"
    elif [[ $value == "$hi" && already_set == false ]]; then
        sed --follow-symlinks -i "$line s|$hi|$no|" ~/.local/share/applications/chromium.desktop
        echo "Chromium: HiDPI → normal"
    fi

    #[[ $was_running == true ]] && chromium&

}

function toggleFirefox() {
    already_set=false

    set +e
    was_running=false
    if pgrep -x firefox > /dev/null; then
        was_running=true
        killall firefox
    fi
    set -e

    profile=$(find ~/.mozilla/firefox -mindepth 1 -maxdepth 1 -type d | head -n 1)
    line=$(grep -n "layout.css.devPixelsPerPx" "$profile/prefs.js" | cut -f1 -d:)
    value=$(grep "layout.css.devPixelsPerPx" "$profile/prefs.js" | rev | cut -d' ' -f 1 | cut -d \" -f 2 | rev)

    hi=1.75
    no=-1

    if [[ $1 == normal ]]; then
        sed --follow-symlinks -i "$line s|\"$hi\"|\"$no\"|" "$profile/prefs.js"
        echo "Firefox: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed --follow-symlinks -i "$line s|\"$no\"|\"$hi\"|" "$profile/prefs.js"
        echo "Firefox: HiDPI"
        already_set=true
    fi

    if [[ $value == "$no" && already_set == false ]]; then
        sed --follow-symlinks -i "$line s|\"$no\"|\"$hi\"|" "$profile/prefs.js"
        echo "Firefox: normal → HiDPI"
    elif [[ $value == "$hi" && already_set == false ]]; then
        sed --follow-symlinks -i "$line s|\"$hi\"|\"$no\"|" "$profile/prefs.js"
        echo "Firefox: HiDPI → normal"
    fi

    #[[ $was_running == true ]] && firefox&
}

function toggleSublime() {
    already_set=false

    set +e
    was_running=false
    if pgrep -x subl3 > /dev/null; then
        was_running=true
        killall subl3
    fi
    set -e

    f=~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
    value=$(grep dpi_scale "$f" | cut -d " " -f 2 | tr -d ",")

    hi=1.75
    no=1.0

    if [[ $1 == normal ]]; then
        sed --follow-symlinks -i "s/\"dpi_scale\": $hi/\"dpi_scale\": $no/" "$f"
        echo "subl: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed --follow-symlinks -i "s/\"dpi_scale\": $no/\"dpi_scale\": $hi/" "$f"
        echo "subl: HiDPI"
        already_set=true
    fi

    if [[ $already_set == false && $value == "$no" ]]; then
        sed --follow-symlinks -i "s/\"dpi_scale\": $no/\"dpi_scale\": $hi/" "$f"
        echo "subl: normal → HiDPI"
    elif [[ $already_set == false && $value == "$hi" ]]; then
        sed --follow-symlinks -i "s/\"dpi_scale\": $hi/\"dpi_scale\": $no/" "$f"
        echo "subl: HiDPI → normal"
    fi

    #[[ $was_running == true ]] && subl3&
}

function toggleXresources() {
    already_set=false

    f=~/.Xresources
    value=$(grep Xft.dpi "$f" | rev | cut -d ":" -f 1 | tr -d '[[:space:]]' | rev)

    hi=168
    no=96

    if [[ $1 == normal ]]; then
        sed --follow-symlinks -i "s|Xft.dpi: $hi|Xft.dpi: $no|" "$f"
        echo "Xresources: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed --follow-symlinks -i "s|Xft.dpi: $no|Xft.dpi: $hi|" "$f"
        echo "Xresources: HiDPI"
        already_set=true
    fi

     if [[ $already_set == false && $value == "$hi" ]]; then
        sed --follow-symlinks -i "s|Xft.dpi: $hi|Xft.dpi: $no|" "$f"
        echo "Xresources: HiDPI → normal"
    elif [[ $already_set == false && $value == "$no" ]]; then
        sed --follow-symlinks -i "s|Xft.dpi: $no|Xft.dpi: $hi|" "$f"
        echo "Xresources: normal → HiDPI"
    fi

    echo "awesome.quit()" | awesome-client
}

toggleFirefox "$1"
toggleChromium "$1"
toggleSublime "$1"
toggleXresources "$1"
