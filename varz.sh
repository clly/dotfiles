#!/bin/bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

export GIT_EDITOR="vim"
export GOVERSION="1.15.2.${ARCH}"
export PROJECT_DIR="${HOME}/p"
export DOCKER_PROJECT_DIR="${HOME}/d"
