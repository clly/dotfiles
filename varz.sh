#!/bin/bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

export GOVERSION="1.9.2.${ARCH}"
export GIT_EDITOR="vim"
