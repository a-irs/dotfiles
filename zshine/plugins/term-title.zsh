#!/usr/bin/env zsh

zshine_title_idle() {
  local TITLE="%~"
  print -Pn "\e]2;$TITLE:q\a"
}

zshine_title_command() {
  print -Pn "\e]2;%~ | $1:q\a"
}

autoload -U add-zsh-hook
add-zsh-hook precmd  zshine_title_idle
add-zsh-hook preexec zshine_title_command
