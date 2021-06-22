load() {
    for d in /srv/infra ~/git/a-irs/infra; do
        [[ -O "$d" ]] && PATH="$d/ansible/bin:$d/docker/bin:$d/docker-shot/bin:$PATH"
    done
}

load
unfunction load
