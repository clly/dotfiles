#!/usr/bin/env bash

# User specific environment and startup programs

JAVA_HOME=/usr/java/default

if [[ -d $HOME/.dot/bin ]]; then
    PATH=$PATH:$HOME/.dot/bin
fi
# lunar vim is installed here
if [[ -d $HOME/.local/bin ]]; then
    PATH=$PATH:$HOME/.local/bin
fi

PATH=$PATH:$JAVA_HOME/bin:$HOME/bin
PATH="/var/home/connor/.bun/bin:$PATH"

export PATH

function dedupe_path() {
    declare -A dedupe
    declare -a newpath
    local p=""
    # set IFS to : for easy loops
    OLD_IFS=$IFS
    IFS=':'
    for i in $PATH; do
        if [[ ! ${dedupe[$i]+_} ]]; then
            dedupe[$i]=1
            newpath+=( $i )
        fi
    done
    IFS=$OLD_IFS
    # loop over deduplicated path to build new loop
    for k in "${newpath[@]}"; do
        p="${p}:${k}"
    done
    cut -f2- -d: <<< $p
    unset dedupe
    unset newpath
    unset IFS
    unset OLD_IFS
}
