#!/usr/bin/env zsh

ZSHINE_DIR=~/.zshine

# no duplicate entries for path arrays
typeset -gU cdpath fpath mailpath path
[ -d "$HOME/.bin" ] && path=("$HOME/.bin" $path)
[ -d "$HOME/.bin/$HOST" ] && path=("$HOME/.bin/$HOST" $path)
[ -d "$HOME/.gem/ruby/2.2.0/bin" ] && path=("$HOME/.gem/ruby/2.2.0/bin" $path)
fpath+=($ZSHINE_DIR/completion $ZSHINE_DIR/prompts)

# load prompt
autoload -U promptinit
promptinit
setopt prompt_subst
prompt zshine

# zmv file-renaming
autoload -U zmv

# auto-escape URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# edit current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file ~/.zsh_recent-dirs +

zstyle ":completion:*:commands" rehash 1 # always rehash on completion

export GREP_COLOR='1;32'
export EDITOR="nano"
export PAGER="less"
export WINEARCH=win32
export TZ='Europe/Berlin'
export REPORTTIME=5

export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history

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

ZSHINE_PLUGINS=(
  term-title # sets terminal/tab title
  aliases # provides some aliases and functions for daily work
  dircolors # set directory/filetype colors
  ls-colors # colors for "ls" command
  virtualenvwrapper # wrapper for python-virtualenv
  syntax-highlighting # provides a syntax highlighted prompt
  less-syntax-highlighting # syntax highlighting for "less" command
  history-substring-search # arrow key up/down history search
  # command-not-found # show needed packages for unknown commands
  bd # move back in current directory tree (breadcrumb-style)
  auto-ls # launch "ls" when entering directory
  prompt-git # provides functions for a git-prompt
  completion # tweaks for TAB-completion
  bindkey # bind keys for delete, history-search etc.
  fzf # CTRL+T for fuzzy-search of files
  zaw # better CTRL+R history search
  # tmux # autostart tmux
#  notify # notify-send after long command has been completed
)
for z in $ZSHINE_PLUGINS; do source "$ZSHINE_DIR/plugins/$z.zsh"; done

export RESET=$(tput sgr0)
export BLACK=$(tput setaf 0)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export MAGENTA=$(tput setaf 5)
export CYAN=$(tput setaf 6)
export WHITE=$(tput setaf 7)
export GREY=$(tput setaf 8)
export BOLD_BLACK=$(tput bold; tput setaf 0)
export BOLD_RED=$(tput bold; tput setaf 1)
export BOLD_GREEN=$(tput bold; tput setaf 2)
export BOLD_YELLOW=$(tput bold; tput setaf 3)
export BOLD_BLUE=$(tput bold; tput setaf 4)
export BOLD_MAGENTA=$(tput bold; tput setaf 5)
export BOLD_CYAN=$(tput bold; tput setaf 6)
export BOLD_WHITE=$(tput bold; tput setaf 7)
export BOLD_GREY=$(tput bold; tput setaf 8)
