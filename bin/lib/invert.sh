pid=$(pidof redshift)
if [ "$?" -eq 0 ]; then
    kill $pid && xcalib -invert -alter
else
    xcalib -clear -alter && redshift -l 48.7:13.0 -t 6200:4800 -m vidmode -r&
fi
