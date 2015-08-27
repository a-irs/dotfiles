#!/usr/bin/env bash

limit=90

while true; do
    current_pids=$(ps -Aa -o pid,pcpu | awk --assign maxcpu="$limit" '$2>maxcpu {print $1}')
    if [[ "$current_pids" && "$last_pids" ]]; then
        for current_pid in $current_pids; do
            for last_pid in $last_pids; do
                if [[ "$current_pid" == "$last_pid" ]]; then
                    cmd_name=$(ps -o comm -q "$current_pid" | tail -n 1)
                    [[ $cmd_name == firefox || $cmd_name == VirtualBox || $cmd_name == FALLOUT3.EXE ]] || notify-send -t 0 -u critical "High CPU" "$cmd_name ($current_pid)"
                fi
            done
        done
    fi
    last_pids=$current_pids
    sleep 5
done
