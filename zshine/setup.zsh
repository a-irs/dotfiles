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

# edit current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file ~/.zsh_recent-dirs +
zstyle ':chpwd:*' recent-dirs-max 31

zstyle ':completion:*' rehash true # always rehash on completion

export GREP_COLOR='1;32'
export PAGER=less
export TZ='Europe/Berlin'
export REPORTTIME=5

[[ $commands[nano] ]] && export EDITOR=nano
[[ $commands[vi] ]]   && export EDITOR=vi
[[ $commands[vim] ]]  && export EDITOR=vim

export HISTSIZE=100000
export SAVEHIST=100000
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

ZSHINE_PLUGINS=(
  # magic-paste # auto-quote URLs on paste
  term-title # sets terminal/tab title
  aliases # provides some aliases and functions for daily work
  ls-colors # colors for "ls" command
  virtualenvwrapper # wrapper for python-virtualenv
  syntax-highlighting # provides a syntax highlighted prompt
  less-syntax-highlighting # syntax highlighting for "less" command
  history-substring-search # arrow key up/down history search
  bd # move back in current directory tree (breadcrumb-style)
  auto-ls # launch "ls" when entering directory
  prompt-git # provides functions for a git-prompt
  completion # tweaks for TAB-completion
  bindkey # bind keys for delete, history-search etc.
  fzf # CTRL+T for fuzzy-search of files
  # pwd-hell # show warning message when [[ pwd != readlink -f ./ ]]
  # tmux # autostart tmux
  # notify # notify-send after long command has been completed
  zshmarks # set bookmarks
  zaw # better CTRL+R history search
)
for z in $ZSHINE_PLUGINS; do source "$ZSHINE_DIR/plugins/$z.zsh"; done

# TTY colors // TODO parse from termite config
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P1ff7563" #darkred
    echo -en "\e]P2aae373" #darkgreen
    echo -en "\e]P3fff073" #brown
    echo -en "\e]P4b9d7f8" #darkblue
    echo -en "\e]P5e2afdd" #darkmagenta
    echo -en "\e]P6a8f6fd" #darkcyan
    echo -en "\e]P7d7d7d7" #lightgrey
    echo -en "\e]P86d7367" #darkgrey
    echo -en "\e]P9ff7563" #red
    echo -en "\e]PAaae373" #green
    echo -en "\e]PBf2e575" #yellow
    echo -en "\e]PCaed2fa" #blue
    echo -en "\e]PDe2afdd" #magenta
    echo -en "\e]PEa8f6fd" #cyan
    echo -en "\e]PFd7d7d7" #white
    clear
fi
