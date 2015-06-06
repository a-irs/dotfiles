#!/usr/bin/env bash

status=$(dropbox-cli status)

if [[ $status == "Dropbox isn't running!" ]]; then
    s=""
elif [[ $status == "Verbindung wird hergestellt ..." ]]; then
    s="…"
elif [[ $status == "Startvorgang läuft ..." ]]; then
    s="…"
elif [[ $status == *"Indexerstellung"* ]]; then
    s="…"
elif [[ $status == *"synchronisiert"* ]]; then
    s="○"
elif [[ $status == *"Synchronisation"* ]]; then
    s="○"
elif [[ $status == "Dateiliste wird heruntergeladen ..." ]]; then
    s="○"
elif [[ $status == "Aktualisiert" ]]; then
    s="●"
else
    s="○"
fi

if [[ $1 == awesome ]]; then
    [[ $s == "●" ]] && echo -n " " && exit
    color=LightGrey
    [[ $s == "○" ]] && color=red
    [[ $s == "…" ]] && color=red
    echo -n "<span font='Terminus 7' foreground='$color'>$s</span>   "
else
    echo "<img>$HOME/.bin/lib/genmon/img/dropbox.png</img><txt><span weight=\"normal\" fgcolor=\"White\">$s</span></txt><tool>$status</tool>"
fi
