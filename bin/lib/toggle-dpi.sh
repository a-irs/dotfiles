#!/usr/bin/env bash

set -e

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

    if [[ $1 == normal ]]; then
        sed -i "$line s|\"2\"|\"-1\"|" "$profile/prefs.js"
        echo "Firefox: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed -i "$line s|\"-1\"|\"2\"|" "$profile/prefs.js"
        echo "Firefox: HiDPI"
        already_set=true
    fi

    if [[ $value == "-1" ]]; then
        sed -i "$line s|\"-1\"|\"2\"|" "$profile/prefs.js"
        echo "Firefox: normal → HiDPI"
    elif [[ $value == "2" ]]; then
        sed -i "$line s|\"2\"|\"-1\"|" "$profile/prefs.js"
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

    if [[ $1 == normal ]]; then
        sed -i "s/\"dpi_scale\": 2.0/\"dpi_scale\": 1.0/" "$f"
        echo "subl: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed -i "s/\"dpi_scale\": 1.0/\"dpi_scale\": 2.0/" "$f"
        echo "subl: HiDPI"
        already_set=true
    fi

    if [[ $already_set == false && $value == "1.0" ]]; then
        sed -i "s/\"dpi_scale\": 1.0/\"dpi_scale\": 2.0/" "$f"
        echo "subl: normal → HiDPI"
    elif [[ $already_set == false && $value == "2.0" ]]; then
        sed -i "s/\"dpi_scale\": 2.0/\"dpi_scale\": 1.0/" "$f"
        echo "subl: HiDPI → normal"
    fi

    #[[ $was_running == true ]] && subl3&
}

function toggleXresources() {
    already_set=false

    f=~/.Xresources
    value=$(grep Xft.dpi "$f" | rev | cut -d ":" -f 1 | tr -d '[[:space:]]' | rev)

    if [[ $1 == normal ]]; then
        sed -i "s|Xft.dpi: 192|Xft.dpi: 96|" "$f"
        echo "Xresources: normal"
        already_set=true
    elif [[ $1 == hidpi ]]; then
        sed -i "s|Xft.dpi: 96|Xft.dpi: 192|" "$f"
        echo "Xresources: HiDPI"
        already_set=true
    fi

     if [[ $already_set == false && $value == "192" ]]; then
        sed -i "s|Xft.dpi: 192|Xft.dpi: 96|" "$f"
        echo "Xresources: HiDPI → normal"
    elif [[ $already_set == false && $value == "96" ]]; then
        sed -i "s|Xft.dpi: 96|Xft.dpi: 192|" "$f"
        echo "Xresources: normal → HiDPI"
    fi

    echo "awesome.quit()" | awesome-client
}

toggleFirefox "$1"
toggleSublime "$1"
toggleXresources "$1"
