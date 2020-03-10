[[ -z "$commands[notify-send]" ]] && return

notify-preexec-hook() {
    zsh_notifier_cmd=$1
    zsh_notifier_time=$SECONDS
}

notify-precmd-hook() {
    local rc=$?
    local time_taken

    if [[ "${zsh_notifier_cmd}" != "" ]]; then
        time_taken=$(( SECONDS - zsh_notifier_time ))
        if (( time_taken > REPORTTIME )); then
            if [[ "$rc" -ne 0 ]]; then
                icon=error
                text=Failed
            else
                icon=info
                text=Finished
            fi
            notify-send -i "$icon" "$zsh_notifier_cmd" "$text after ${time_taken}s."
        fi
    fi
    zsh_notifier_cmd=
}

[[ -z $preexec_functions ]] && preexec_functions=()
preexec_functions=($preexec_functions notify-preexec-hook)

[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions notify-precmd-hook)
