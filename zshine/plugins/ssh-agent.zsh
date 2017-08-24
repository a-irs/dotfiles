#!/usr/bin/env zsh

# only starts ssh-agent once and shares its ENV between shell sessions
# inspired by: https://unix.stackexchange.com/a/217223

if [[ ! -S ~/.ssh/ssh_auth_sock ]]; then
    eval $(ssh-agent | grep -v '^echo ')
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    ln -sf "$SSH_AGENT_PID" ~/.ssh/ssh_agent_pid
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
export SSH_AGENT_PID=$(find ~/.ssh/ssh_agent_pid -printf %l)

if ! ssh-add -l > /dev/null; then
    printf "\n%s" "$(tput setaf 6)"
    ssh-add
    printf "%s" "$(tput sgr0)"
fi
