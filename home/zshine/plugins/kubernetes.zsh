if [[ $commands[kubectl] ]]; then
    source <(kubectl completion zsh)

    alias k=kubectl
    complete -F __start_kubectl k
fi

if [[ $commands[skaffold] ]]; then
    export SKAFFOLD_UPDATE_CHECK=false
fi
