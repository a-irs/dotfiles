[[ -O /srv/infra ]] || return

PATH=/srv/infra/ansible/bin:$PATH
PATH=/srv/infra/compose/bin:$PATH
PATH=/srv/infra/docker/bin:$PATH
