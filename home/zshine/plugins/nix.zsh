## nix package manager

if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi

[[ -n "$commands[nix-shell]" ]] && nx-sh() {
    nix-shell --pure -p "$@"
}

## nixos

if [[ -n "$commands[nixos-rebuild]" ]]; then
    nx-sw() {
        # local now=$(date +%F_%H-%M)
        # sudo NIXOS_LABEL="$now" nixos-rebuild switch "$@"
        sudo nixos-rebuild switch "$@"
    }

    nx-test() {
        sudo nixos-rebuild dry-activate
    }

    for p in ${(z)NIX_PROFILES}; do
        fpath+=(
            $p/share/zsh/site-functions
            $p/share/zsh/$ZSH_VERSION/functions
            $p/share/zsh/vendor-completions
        )
    done
fi
