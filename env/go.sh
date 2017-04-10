#!/bin/bash

export GOROOT="/usr/go/go${GOVERSION}"
export GOPATH=$HOME/git/go

PATH=$JAVA_HOME/bin:$PATH:$GOPATH/bin:$GOROOT/bin
export PATH
