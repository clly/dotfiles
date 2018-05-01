#!/bin/bash

function update-dot() {
    local force=$1
    cd $HOME/.dot
    if [[ -n $force ]]; then
        update_git_completion
        update_pathogen
    fi
    git pull --rebase > /dev/null
    copyDotFiles
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

function copyDotFiles() {
    cp tmux.conf $HOME/.tmux.conf
    cp vimrc $HOME/.vimrc
    cp gitconfig $HOME/.gitconfig
    cp git-completion.bash $HOME/.git-completion.bash
}

function update_git_completion() {
    curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o git-completion.bash
}

function update_pathogen() {
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function watchers() {
    if [[ ! -d .idea ]]; then
        echo "Project is not a go intellij project"
    fi
    mkdir -p $PWD/.idea
    cp $HOME/.dot/statics/watcherTasks.xml $PWD/.idea/watcherTasks.xml
    echo "Created watcher tasks for go projcet"
}

function notify_missing_stuff() {
    if_exists $HOME/.vimrc && echo "vimrc is missing"
    if_exists $HOME/.tmux.conf && echo "tmux.conf is missing"
    if_exists $HOME/.vim/autoload/pathogen.vim && echo "Pathogen is missing"
    if_exists $HOME/.git-completion.bash && echo "git-completion.bash is missing"
}

function if_exists() {
    if [[ -e $1 ]]; then
        return 0
    else
        return 1
    fi
}

#/**
# * Pulled from eduardo-lago.blogspot.com ram only pxeboot
# * converts an IPv4 address to hexadecimal format completing the missing
# * leading zero
# *
# * @example:
# *   $ hxip 10.10.24.203
# *   0A0A18CB
# *
# * @param $1: the IPv4 address
# */
hxip() {
  ( bc | sed 's/^\([[:digit:]]\|[A-F]\)$/0\1/' | tr -d '\n' ) <<< "obase=16; ${1//./;}"
}

