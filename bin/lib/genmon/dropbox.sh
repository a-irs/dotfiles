#!/usr/bin/env bash

status=$(dropbox status)

if [[ $status == "Dropbox isn't running!" ]]; then
    s=""
elif [[ $status == "Verbindung wird hergestellt ..." ]]; then
    s=" ..."
elif [[ $status == "Startvorgang läuft ..." ]]; then
    s=" ..."
elif [[ $status == *"Indexerstellung"* ]]; then
    s=" ..."
elif [[ $status == *"snychronisiert"* ]]; then
    s=" synchronisiere"
elif [[ $status == *"Synchronisation"* ]]; then
    s=" synchronisiere"
elif [[ $status == "Dateiliste wird heruntergeladen ..." ]]; then
    s=" synchronisiere"
elif [[ $status == "Aktualisiert" ]]; then
    s=" aktualisiert"
else
    s=$status
fi

echo "<img>$HOME/.bin/lib/genmon/img/dropbox.png</img><txt><span weight=\"normal\" fgcolor=\"White\">$s</span></txt><tool>$status</tool>"
