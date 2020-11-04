#!/usr/bin/env zsh

# only starts ssh-agent once and shares its ENV between shell sessions
# inspired by: https://unix.stackexchange.com/a/217223

ssh-agent-start() {
    if [[ ! -S ~/.ssh/ssh_auth_sock || ! -d ~/.ssh/ssh_agent_pid ]]; then
        eval $(ssh-agent -t 3600 | grep -v '^echo ')
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
        ln -sf /proc/"$SSH_AGENT_PID" ~/.ssh/ssh_agent_pid
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    export SSH_AGENT_PID=$(basename "$(readlink ~/.ssh/ssh_agent_pid)")
}

ssh-agent-kill() {
    eval $(ssh-agent -k)
    rm -vf ~/.ssh/ssh_auth_sock
    rm -vf ~/.ssh/ssh_agent_pid
    killall -u $USER ssh-agent 2>/dev/null || true
}

ssh-agent-start
