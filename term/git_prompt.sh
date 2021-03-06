#!/bin/bash

# speical functions
function git_ps1() {
    email=$(git config user.email)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    upstream_ref_count=$(git rev-list --count HEAD..FETCH_HEAD 2>/dev/null)
    echo "("${email} ${ref#refs/heads/} ${upstream_ref_count}")"
}

function terraform_ps1() {
    if [[ -f .terraform/environment ]]; then
        cat .terraform/environment 2>/dev/null
    fi
}

function kube_context() {
    if [[ $(which kubectl) ]]; then
        kubectl config current-context 2>/dev/null
    fi
}

# Colors for OSX
if [[ $SYSTEM == 'Darwin' ]]; then
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export CLICOLOR=1
fi

# only execute tput if there's a TERM
if [[ $- = *i* ]]; then
    starship=$(command -v starship)
    if [[ -n $starship ]]; then
        eval "$(starship init bash)"
    else
        # Set up git bash prompt
        green=$(tput setaf 2)
        blue=$(tput setaf 4)
        bold=$(tput bold)
        red=$(tput setaf 1)
        cyan=$(tput setaf 5)
        reset=$(tput sgr0)
        underline=$(tput smul)
        export PS1="[ \[$(tput setaf 2)\]\h \[$(tput setaf 6)\]\u@\l \A: \[$(tput smul)\]\w\[$(tput sgr0)\] ${red}Kube context:\$(kube_context)\[$(tput setaf 4) ]\]\\$\n \[$(tput bold)\]\[$(tput setaf 5)\]\$(git_ps1) \[$(tput sgr0)\]\[$(tput setaf 2)\]\$(terraform_ps1)\[$(tput sgr0)\]--> \[$(tput sgr0)\]"
    fi
fi
