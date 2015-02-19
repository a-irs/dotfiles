#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

round() {
    if (($1 == 0)); then
        echo 0
    elif (($1 <= 7)); then
        echo 5
    elif (($1 <= 12)); then
        echo 10
    elif (($1 <= 17)); then
        echo 15
    elif (($1 <= 22)); then
        echo 20
    elif (($1 <= 27)); then
        echo 25
    elif (($1 <= 32)); then
        echo 30
    elif (($1 <= 37)); then
        echo 35
    elif (($1 <= 42)); then
        echo 40
    elif (($1 <= 47)); then
        echo 45
    elif (($1 <= 52)); then
        echo 50
    elif (($1 <= 57)); then
        echo 55
    elif (($1 <= 62)); then
        echo 60
    elif (($1 <= 67)); then
        echo 65
    elif (($1 <= 72)); then
        echo 70
    elif (($1 <= 77)); then
        echo 75
    elif (($1 <= 82)); then
        echo 80
    elif (($1 <= 87)); then
        echo 85
    elif (($1 <= 92)); then
        echo 90
    elif (($1 <= 97)); then
        echo 95
    else
        echo 100
    fi
}

ponymix is-muted
if [[ $? == 1 ]]; then
    if [[ "$MONOCHROME" != 1 ]]; then
        color="#B895B5"
        image="$HOME/.bin/lib/genmon/img/speaker_on.png"
    else
        color="white"
        image="$HOME/.bin/lib/genmon/img/monochrome/speaker_on.png"
    fi
else
    color="Grey"
    image="$HOME/.bin/lib/genmon/img/speaker_off.png"
fi

xprop -root | grep PULSE_SERVER &> /dev/null
if [[ $? == 0 ]]; then
    color=orange
    image="$HOME/.bin/lib/genmon/img/speaker_remote.png"
fi

txt=$(round "$(ponymix get-volume)")
[[ $ICONS == 1 ]] && echo -n "<img>$image</img>"
echo "<txt><span weight='bold' fgcolor='$color'>$txt</span></txt>
      <click>ponymix toggle</click>"
