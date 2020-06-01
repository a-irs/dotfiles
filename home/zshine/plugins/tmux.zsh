#!/usr/bin/env zsh

[[ ! "$commands[tmux]" ]] && return

[[ "$VIM" || "$EMACS" || "$INSIDE_EMACS" || "$TMUX" || $- != *i* ]] && return

# attach to latest detached session if available
detached_session=$(tmux list-session -F '#{session_name}:#{session_attached}' | grep ':0' | tail -1)
if [[ -n "$detached_session" ]]; then
    exec tmux attach-session -t "${detached_session%:*}" \; display "re-attached session"
else
    exec tmux new-session
fi
