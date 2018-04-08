[[ -z "$commands[nix]" ]] && return

n-sw() {
    local date=$(date +%Y%m%d)
    local branch=$(git -C /etc/nixos branch 2>/dev/null | sed -n '/^\* / { s|^\* ||; p; }')
    local rev=$(git -C /etc/nixos rev-parse HEAD)

    local NIXOS_LABEL="$date-$branch-${rev:0:7}"
    echo "$NIXOS_LABEL"
    sudo NIXOS_LABEL=$NIXOS_LABEL nixos-rebuild switch "$@"
}

n-test() {
    sudo nixos-rebuild dry-activate
}
