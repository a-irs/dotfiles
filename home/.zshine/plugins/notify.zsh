[[ -z "$commands[notify-send]" ]] && return

notify-preexec-hook() {
    zsh_notifier_cmd=$1
    zsh_notifier_time=$SECONDS
}

notify-precmd-hook() {
    local time_taken

    if [[ "${zsh_notifier_cmd}" != "" ]]; then
        time_taken=$(( SECONDS - zsh_notifier_time ))
        if (( time_taken > REPORTTIME )); then
            notify-send "'$zsh_notifier_cmd' finished" "exited after $time_taken seconds."
        fi
    fi
    zsh_notifier_cmd=
}

[[ -z $preexec_functions ]] && preexec_functions=()
preexec_functions=($preexec_functions notify-preexec-hook)

[[ -z $precmd_functions ]] && precmd_functions=()
precmd_functions=($precmd_functions notify-precmd-hook)
