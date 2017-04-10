#!/bin/bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

export GOVERSION="1.8.1.${ARCH}"
export DOT_SOURCE=$HOME/.dot
