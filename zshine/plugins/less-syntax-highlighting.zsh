if [ -f /usr/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi
