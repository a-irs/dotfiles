#!/usr/bin/env zsh

VIRTUAL_ENV_DISABLE_PROMPT=1

[[ -z "$commands[pipenv]" ]] && return

py-make() {
    mkdir -p "$1" && cd "$1" && pipenv install && SHELL=/bin/zsh pipenv shell
}

py-activate() {
    cd "$1"
    if [[ ! -f "Pipfile" ]]; then
        printf "%s\n" "$1 is not a pipenv environment"
        return 1
    fi
    SHELL=/bin/zsh pipenv shell
}

alias ipython="$HOME/.local/share/virtualenvs/ipython3-*/bin/ipython --no-confirm-exit --no-banner --no-automagic --colors=Linux"
