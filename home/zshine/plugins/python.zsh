#!/usr/bin/env zsh

VIRTUAL_ENV_DISABLE_PROMPT=1

venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
    elif [[ -d venv ]]; then
        source venv/bin/activate
    else
        virtualenv --no-download -p python3 venv
        source venv/bin/activate
    fi
}
