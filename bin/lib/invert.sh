#!/usr/bin/env bash

pid=$(pidof redshift)
if [ "$?" -eq 0 ]; then
    kill "$pid" && xcalib -invert -alter
else
    xcalib -clear -alter && redshift&
fi
