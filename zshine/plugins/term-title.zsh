[[ $SSH_CONNECTION ]] && return

function title {
    [[ "$EMACS" == *term* ]] && return

    # if $2 is unset use $1 as default
    # if it is set and empty, leave it as is
    : ${2=$1}

    if [[ "$TERM" == screen* ]]; then
        print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
    elif [[ "$TERM" == xterm* || "$TERM" == rxvt* || "$TERM" == ansi || "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" #set window name
        print -Pn "\e]1;$1:q\a" #set icon (=tab) name
    fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%30<…<%~%<<" #30 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

# Runs before showing the prompt
function termtitle_precmd {
    title "$ZSH_THEME_TERM_TAB_TITLE_IDLE" "$ZSH_THEME_TERM_TITLE_IDLE"
}

# Runs before executing the command
function termtitle_preexec {
    title "%30>…>$1%<<"
    [[ $TMUX && $1 == "ssh "* ]] && title "%45>…>#[fg=colour160]$1%<<"
}

precmd_functions+=(termtitle_precmd)
preexec_functions+=(termtitle_preexec)
