#!/usr/bin/env bash

HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups  # don't put duplicate lines or lines starting with whitespace in history
shopt -s globstar 2> /dev/null  # ** to glob recursive
shopt -s histappend  # append history instead of overwrite

is_cmd() { command -v "$1" > /dev/null 2>&1; }

is_cmd vi   && export EDITOR=vi
is_cmd vim  && export EDITOR=vim
is_cmd gls  && ls() { gls "$@"; }
is_cmd dircolors && eval "$(dircolors -b)"

PROMPT_COMMAND=_prompt
_prompt() {
    local EXIT="$?"

    local reset='\[\e[0m\]'
    local red='\[\e[1;31m\]'
    local green='\[\e[1;32m\]'
    local yellow='\[\e[1;33m\]'
    local blue='\[\e[1;34m\]'
    local magenta='\[\e[1;35m\]'

    [[ -n "$SSH_CONNECTION" ]] && local PREFIX="${magenta}[SSH] ${reset}"

    user_color=$blue
    [ $UID = 0 ] && user_color=$red
    PS1="\n${reset}${PREFIX}${user_color}\u${green}@\h ${yellow}\w "

    if [ $EXIT != 0 ]; then
        PS1+="${red}$EXIT ${reset}\$ "
    else
        PS1+="${reset}\$ "
    fi
}

export GREP_OPTIONS='--color=auto'
export CLICOLOR='1'

### color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

### security aliases
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

### convenience aliases
alias ls='ls -Fhl  --color=auto'
alias la='ls -FhlA --color=auto'
alias ll='ls -Fhl  --color=auto'
alias rd='rmdir'
alias mkdir='mkdir -p'
alias f='find . -name'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

true
