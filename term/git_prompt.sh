#!/bin/bash

# speical functions
function git_ps1 {
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
PS1='\u@\[$green\]\h\[$reset\]:\w \[$blue\]$(git_ps1)\[$reset\]\$ '
