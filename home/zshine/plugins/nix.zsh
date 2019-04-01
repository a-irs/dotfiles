if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi


[[ -z "$commands[nixos-rebuild]" ]] && return

nx-sw() {
    # local now=$(date +%F_%H-%M)
    # sudo NIXOS_LABEL="$now" nixos-rebuild switch "$@"
    sudo nixos-rebuild switch "$@"
}

nx-test() {
    sudo nixos-rebuild dry-activate
}

nx-vm() {
    # do not use nixos-rebuild build-vm, but: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-vm.nix
    # nix-build '<nixpkgs/nixos>' -A vm ???
    # https://nixos.mayflower.consulting/blog/2018/09/11/custom-images/ ???
    # https://news.ycombinator.com/item?id=18364372 ???

    # DO NOT USE:
    # # prepare custom config
    # tmp=$(mktemp -d)
    # cp -r /etc/nixos/* "$tmp"
    # sed -i 's/];/];\nusers.users.root.initialPassword = "root";/' "$tmp/configuration.nix"
    # sed -i 's/];/];\nusers.users.alex.initialPassword = "alex";/' "$tmp/configuration.nix"
    # sed -i 's/];/];\nenvironment.etc."zprofile.local".text = "ln -sfT \/tmp\/shared .dot";/' "$tmp/configuration.nix"
    #
    # # build + run
    # NIXOS_CONFIG="$tmp/configuration.nix" sudo -E nixos-rebuild build-vm
    #
    # SHARED_DIR=/home/alex/.dot QEMU_OPTS='-m 2048' ./result/bin/run-*-vm
    #
    # rm -rf "$tmp"
    # rm -f result
    # rm -i $HOST.qcow2
}

nx-sh() {
    TERM=xterm-256color nix-shell --pure "$@"
}

for p in ${(z)NIX_PROFILES}; do
    fpath+=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions $p/share/zsh/vendor-completions)
done

