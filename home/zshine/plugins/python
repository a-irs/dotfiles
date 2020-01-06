#!/usr/bin/env zsh

VIRTUAL_ENV_DISABLE_PROMPT=1

venv() {
    [[ -n "$VIRTUAL_ENV" ]] && { deactivate; return; }
    [[ $# != 1 ]] && { echo "venv <name>"; return 2; }
    _venv_generic python3 "$1"
}

venv2() {
    [[ -n "$VIRTUAL_ENV" ]] && { deactivate; return; }
    [[ $# != 1 ]] && { echo "venv2 <name>"; return 2; }
    _venv_generic python2 "$1"
}

_venv_generic() {
    local py=$1
    local e=$2

    if [[ -d "$e" ]]; then
        if [[ -f "$e/bin/activate" ]]; then
            source "$e/bin/activate"
        else
            echo "$e already exists and is not a venv"
            return 3
        fi
    else
        virtualenv --no-download -p "$py" "$e"
        source "$e/bin/activate"
    fi
}
