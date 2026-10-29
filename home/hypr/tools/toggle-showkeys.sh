#!/usr/bin/env bash

if pgrep -x wiv >/dev/null; then
    pkill -x wiv
else
    wiv \
        -a bottom \
        -m 40 \
        -H 20 \
        -b "#f3f6f4e6" \
        -f "#243447" \
        -s "#5b7083" \
        -t 3000
fi
