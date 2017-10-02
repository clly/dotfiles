#!/bin/bash

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
    if [ -f "${HOME}/.dot/activate" ]; then
        source "${HOME}/.dot/activate"
    else
        echo "Run get_dot() to get your dotfiles"
    fi
    
    function get_dot() {
        cd $HOME
        git clone git@github.com:clly/dotfiles.git .dot
        source .dot/activate
        cd -
    }
fi

