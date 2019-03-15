if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi


[[ -z "$commands[nixos-rebuild]" ]] && return

nxsw() {
    # local now=$(date +%F_%H-%M)
    # sudo NIXOS_LABEL="$now" nixos-rebuild switch "$@"
    sudo nixos-rebuild switch "$@"
}

nxtest() {
    sudo nixos-rebuild dry-activate
}

for p in ${(z)NIX_PROFILES}; do
    fpath+=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions $p/share/zsh/vendor-completions)
done

