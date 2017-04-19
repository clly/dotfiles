#!/bin/bash

function update_dot() {
    cd $HOME/.dot
    git pull --rebase > /dev/null
    source activate
    cd -
}

function checkmesoshc() {
    local h=$1
    if [[ -z $h ]]; then
        h=$(hostname)
    fi
    local r=$(curl -w "%{http_code}" -s "$h:5051/slave(1)/health" -o /dev/null)
    if [[ $r == "200" ]]; then
        echo "$h is ok"
    else
        echo "$h is not ok"
    fi
}
