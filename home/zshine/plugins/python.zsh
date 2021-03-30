#!/usr/bin/env zsh

# default: stored in current directory
export MYPY_CACHE_DIR=/tmp/mypy

venv() {
    [[ -n "$VIRTUAL_ENV" ]] && { deactivate; return; }
    [[ $# != 1 ]] && { echo "venv <name>"; return 2; }
    local e=$1

    if [[ -d "$e" ]]; then
        if [[ -f "$e/bin/activate" ]]; then
            source "$e/bin/activate"
        else
            echo "$e already exists and is not a venv"
            return 3
        fi
    else
        python3 -m venv "$e" && source "$e/bin/activate"
    fi
}
