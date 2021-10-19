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

# Set vault http location environment variable for development work
function dev-vault {
    docker run -p 8200:8200 --name vault vault
    export VAULT_ADDR="http://127.0.0.1:8200"
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

dgo() {
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a docker project name."
        return 1
    fi
    
    # search for the project dir in the PROJECT_DIR
    local path=( `find "${DOCKER_PROJECT_DIR}" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $PROJECT_DIR"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}

pgo(){
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a project name."
        return 1
    fi

    # search for the project dir in the PROJECT_DIR
    local path=( `find "${PROJECT_DIR}" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $PROJECT_DIR"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}

wgo(){
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a project name."
        return 1
    fi

    # search for the project dir in the PROJECT_DIR
    local path=( `find "${WPROJECT_DIR}" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $PROJECT_DIR"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}

unseal() {
    unseal=$(envy exec dev-vault bash -c 'printenv UNSEAL|base64 -d|keybase pgp decrypt')
    curl -XPUT https://localhost:8200/v1/sys/unseal --data-binary @- <<<"{\"key\":\"$unseal\"}"
}

rvault() {
    VAULT_TOKEN=$(envy exec dev-vault bash -c 'printenv ROOT|base64 -d|keybase pgp decrypt')
    VAULT_TOKEN=$VAULT_TOKEN "$@"
}

compact_prompt() {
    export STARSHIP_CONFIG=~/.dot/starship-compact.toml
}
