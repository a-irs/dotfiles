HISTSIZE=1000000
HISTFILESIZE=1000000
shopt -s globstar  # ** to glob recursive
shopt -s histappend  # append history instead of overwrite
HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with whitespace in history

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    local EXIT="$?"

    local reset='\[\e[0m\]'
    local red='\[\e[1;31m\]'
    local green='\[\e[1;32m\]'
    local yellow='\[\e[1;33m\]'

    user_color=$blue
    [ $UID = 0 ] && user_color=$red
    PS1="${reset}${user_color}\u@${green}\h ${yellow}\w "

    if [ $EXIT != 0 ]; then
        PS1+="${red}$EXIT ${reset}\$ "
    else
        PS1+="${reset}\$ "
    fi
}

[ -f /etc/bashrc ] && . /etc/bashrc
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

export GREP_OPTIONS='--color=auto'

# color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

alias ls='ls -Fhl  --color=auto'
alias la='ls -FhlA --color=auto'
alias ll='ls -Fhl  --color=auto'
alias rd='rmdir'
alias mkdir='mkdir -p'
alias glog='git log --color --patch --stat --decorate --date=relative --all --abbrev-commit'
alias f='find . -name'
alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias e='$EDITOR'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

