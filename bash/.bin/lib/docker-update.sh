#!/usr/bin/env bash

set -e

which docker &> /dev/null
[[ $? -ne 0 ]] && echo "install docker first" && exit 1
[ -z $1 ] && echo "usage: $0 <container-name>" && exit 1

println() {
    echo -e "\n\033[33;1m>>> $1\033[0m"
}

printlne() {
    echo -e "\n\033[31;1m>>> $1\033[0m"
}


### FIND CONTAINER

CID=$(docker ps -a | grep "$1" | awk '{print $1}')
NAME=$(docker ps -a | grep "$1" | awk '{print $NF}')
if [[ "$CID" != "" ]] && [[ "$NAME" != "" ]]; then
    NAME=${NAME##*/}
    NAME=${NAME//:*}
    println "using: $NAME ($CID)"
else
    printlne "no container found matching $1"
    exit
fi


### BUILD NEW IMAGE

BUILD_FILE="/srv/docker/$NAME/build.sh"
if [ -f $BUILD_FILE ]; then
    println "building with $BUILD_FILE"
else
    printlne "building failed! file not found: $BUILD_FILE"
    exit
fi
$BUILD_FILE


### STOP AND REMOVE OLD CONTAINER

println "stopping old container"
docker stop $CID

println "removing old container"
docker rm $CID


### RUN NEW CONTAINER

RUN_FILE="/srv/docker/$NAME/run.sh"
if [ -f $RUN_FILE ]; then
    println "running with $RUN_FILE"
else
    printlne "running failed! file not found: $RUN_FILE"
    exit
fi
$RUN_FILE
