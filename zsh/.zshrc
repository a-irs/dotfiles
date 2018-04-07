ZSHINE_DIR=~/.zshine

zshine_load=(
    "$ZSHINE_DIR/init.zsh"
    ~/.zshrc.d/*(N)
)

if [[ "$ZSHINE_DEBUG" == 1 ]]; then
    zmodload zsh/datetime
    prof_last=$((EPOCHREALTIME * 1000))
    for fx in ${zshine_load[@]}; do
        [[ -f "$fx" ]] && source "$fx"
        prof_now=$((EPOCHREALTIME * 1000))
        printf "%3d %s -- %s\n" "$((prof_now - prof_last))" "ms" "$fx"
        prof_last=$prof_now
    done
else
    for fx in ${zshine_load[@]}; do
        [[ -f "$fx" ]] && source "$fx"
    done
fi
unset fx
