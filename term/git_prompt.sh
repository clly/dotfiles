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
export PS1="[ $green\h $blue\u@\l \A: $underline\w$reset ] $blue\\$\n ${bold}${red}\$(git_ps1) $reset--> \[$(tput sgr0)\]"
