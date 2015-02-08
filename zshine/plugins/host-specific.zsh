if [[ "$HOST" == srv ]]; then
    alias data="cd /media/data"

    #if [[ x$DISPLAY == x ]]; then
    #    export DISPLAY=dell:0.0
    #fi

    PATH="$PATH:$HOME/.bin/server"
fi

if [[ "$HOST" == dell ]]; then
    #xhost - > /dev/null 2> /dev/null
    #xhost +srv.home > /dev/null 2> /dev/null
fi
