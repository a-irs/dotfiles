#!/usr/bin/env zsh

ZSHINE_DIR=~/.zshine
os="$(uname)"

# no duplicate entries for path arrays
typeset -gU cdpath fpath mailpath path
[ -d "$HOME/.bin" ] && path=("$HOME/.bin" $path)
[ -d "$HOME/.bin/$HOST" ] && path=("$HOME/.bin/$HOST" $path)
[ -d "$HOME/.gem/ruby/2.3.0/bin" ] && path=("$HOME/.gem/ruby/2.3.0/bin" $path)
fpath+=($ZSHINE_DIR/completion $ZSHINE_DIR/prompts $ZSHINE_DIR/plugins/zshmarks)

# load prompt
autoload -U promptinit
promptinit
setopt prompt_subst
prompt zshine

# zmv file-renaming
autoload -U zmv

zstyle ':completion:*' rehash true # always rehash on completion

export GREP_COLOR='1;32'
export PAGER=less
export TZ='Europe/Berlin'
export REPORTTIME=5

[[ $commands[nano] ]] && export EDITOR=nano
[[ $commands[vi] ]]   && export EDITOR=vi
[[ $commands[vim] ]]  && export EDITOR=vim

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt NOTIFY # Report status of background jobs immediately.
unsetopt BG_NICE # Don't run all background jobs at a lower priority.
unsetopt HUP # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS # Don't report on jobs when shell exit.
setopt LONG_LIST_JOBS # list jobs in the long format (with pid etc.)
setopt HIST_IGNORE_ALL_DUPS # dont add duplicate dommands
setopt HIST_IGNORE_SPACE # do not add commands starting with space to history
setopt HIST_NO_FUNCTIONS # do not add function declarations to history
setopt HIST_NO_STORE # do not add 'history' command to history
setopt HIST_REDUCE_BLANKS # strip spaces etc. when adding to history
setopt HIST_VERIFY # safe history expansion
setopt EXTENDED_HISTORY # add time stamps to history
setopt SHARE_HISTORY # immediately add to history and share with other shells
setopt NOTIFY
setopt HASH_CMDS
setopt HASH_LIST_ALL
setopt COMPLETEINWORD
setopt NOCHECKJOBS
setopt NOHUP
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVECOMMENTS
setopt GLOBDOTS
setopt MULTIOS
unsetopt CORRECTALL
unsetopt CORRECT

if [[ $TERM != *"-256color" ]]; then
    for terminfos in "${HOME}/.terminfo" "/etc/terminfo" "/lib/terminfo" "/usr/share/terminfo"; do
        if [[ -e "$terminfos"/$TERM[1]/${TERM}-256color || -e "$terminfos"/${TERM}-256color ]]; then
            export TERM="${TERM}-256color"
            break
        fi
    done
fi

RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
GREY=$(tput setaf 8)
BOLD_BLACK=$(tput bold; tput setaf 0)
BOLD_RED=$(tput bold; tput setaf 1)
BOLD_GREEN=$(tput bold; tput setaf 2)
BOLD_YELLOW=$(tput bold; tput setaf 3)
BOLD_BLUE=$(tput bold; tput setaf 4)
BOLD_MAGENTA=$(tput bold; tput setaf 5)
BOLD_CYAN=$(tput bold; tput setaf 6)
BOLD_WHITE=$(tput bold; tput setaf 7)
BOLD_GREY=$(tput bold; tput setaf 8)

source "$ZSHINE_DIR/init-plugins.zsh"

