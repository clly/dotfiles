#!/bin/bash

if [[ $SYSTEM != 'Darwin' ]]; then
    export GOROOT="/usr/go/go${GOVERSION}"
fi
export GOPATH=$HOME/go

PATH=$JAVA_HOME/bin:$PATH:$GOPATH/bin:$GOROOT/bin
export PATH
