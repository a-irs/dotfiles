[[ ! -d /srv/infra ]] && return

rm -f ~/.zshrc.d/post/infra-shellenv
source /srv/infra/shellenv
