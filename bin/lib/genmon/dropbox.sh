#!/usr/bin/env bash

status=$(dropbox-cli status)

if [[ $status == "Dropbox isn't running!" ]]; then
    s=""
elif [[ $status == "Verbindung wird hergestellt ..." ]]; then
    s=" ..."
elif [[ $status == "Startvorgang läuft ..." ]]; then
    s=" ..."
elif [[ $status == *"Indexerstellung"* ]]; then
    s=" ..."
elif [[ $status == *"synchronisiert"* ]]; then
    s=" sync"
elif [[ $status == *"Synchronisation"* ]]; then
    s=" sync"
elif [[ $status == "Dateiliste wird heruntergeladen ..." ]]; then
    s=" sync"
elif [[ $status == "Aktualisiert" ]]; then
    s=" done"
else
    s=$status
fi

echo "<img>$HOME/.bin/lib/genmon/img/dropbox.png</img><txt><span weight=\"normal\" fgcolor=\"White\">$s</span></txt><tool>$status</tool>"
