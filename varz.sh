#!/bin/bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

export GIT_EDITOR="vim"
export GOVERSION="1.13.5.${ARCH}"
