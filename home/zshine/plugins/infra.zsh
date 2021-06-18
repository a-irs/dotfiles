load() {
    for d in /srv/infra ~/git/a-irs/infra; do
        [[ -O "$d" ]] && PATH="$d/ansible/bin:$d/docker:$d/docker-shot:$PATH"
    done
}

load
unfunction load
