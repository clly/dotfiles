#!/bin/bash

# User specific environment and startup programs

JAVA_HOME=/usr/java/default

if [[ -d $HOME/.dot/bin ]]; then
    PATH=$PATH:$HOME/.dot/bin
fi

PATH=$PATH:$JAVA_HOME/bin:$HOME/bin


export PATH

