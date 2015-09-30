#!/usr/bin/env zsh

_pwd_alias_hell () {
  if [[ "$(readlink -f ./)" != "$(readlink -f "$(pwd)")" ]] then;
    echo "pwd    = $BOLD_RED$(pwd)${RESET}"
    echo "actual = $BOLD_RED$(readlink -f ./)${RESET}"
  fi
}

autoload add-zsh-hook
add-zsh-hook precmd _pwd_alias_hell
