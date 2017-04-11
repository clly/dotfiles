#!/bin/bash

function update_dot() {
    cd $HOME/.dot
    git pull --rebase > /dev/null
    source .dot/activate
    cd -
}
