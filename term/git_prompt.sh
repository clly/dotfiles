#!/bin/bash

# speical functions
function git_ps1() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "("${ref#refs/heads/}")"
}

# Colors for OSX
if [[ $SYSTEM == 'Darwin' ]]; then
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export CLICOLOR=1
fi

# Set up git bash prompt
green=$(tput setaf 2)
blue=$(tput setaf 4)
bold=$(tput bold)
red=$(tput setaf 1)
reset=$(tput sgr0)
underline=$(tput smul)
export PS1="[ \[$(tput setaf 2)\]\h \[$(tput setaf 4)\]\u@\l \A: \[$(tput smul)\]\w\[$(tput sgr0)\] ] \[$(tput setaf 4)\]\\$\n \[$(tput bold)\]\[$(tput setaf 1)\]\$(git_ps1) \[$(tput sgr0)\]--> \[$(tput sgr0)\]"
