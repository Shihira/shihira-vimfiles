#!/bin/bash 

if which fcitx-remote; then
    if [[ "$1" == "save-state-and-off" ]]; then
        fcitx-remote > /tmp/fcitx-state # 1: off, 2: on
        fcitx-remote -c
    elif [[ "$1" == "recover-state" ]]; then
        ARGS=("dummy" "-c" "-o")
        state=$(cat /tmp/fcitx-state)
        fcitx-remote ${ARGS[$state]} > /dev/null
    fi
fi

true
