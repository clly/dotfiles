#!/bin/bash

if [[ $SYSTEM != 'Darwin' ]]; then
    export GOROOT="/usr/go/go${GOVERSION}"
fi
export GOPATH=$HOME/go

PATH=$GOROOT/bin:$PATH:$GOPATH/bin
export PATH
