# .bash_profile

SYSTEM=$(uname -s)

# speical functions
function git_ps1 {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "("${ref#refs/heads/}")"
}


# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# Colors for OSX
if [[ $SYSTEM == 'Darwin' ]]; then
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export CLICOLOR=1
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$GOPATH/bin:$HOME/bin

export PATH

# Set up git bash prompt
green=$(tput setaf 2)
blue=$(tput setaf 4)
bold=$(tput bold)
red=$(tput setaf 1)
reset=$(tput sgr0)
PS1='\u@\[$green\]\h\[$reset\]:\w \[$blue\]$(git_ps1)\[$reset\]\$ '

# Git completion
[ -f $HOME/.git-completion.bash ] && source $HOME/.git-completion.bash

alias ll='ls -l --time-style=long-iso'

installgo(){
    sudo id > /dev/null
    local v=$1
    if [[ -z $v ]]; then
        echo "You need to specify a version to install"
        return 1
    fi

    if [[ $SYSTEM == "Darwin" ]]; then
        arch="darwin-amd64"
    else
        arch="linux-amd64"
    fi

    local gp="/usr/go/"
    url="https://storage.googleapis.com/golang/go${v}.${arch}.tar.gz"

    if $(curl -s -I -m 5 -XHEAD $url|grep -q "200 OK"); then
        wget --quiet $url -O /tmp/go.tar.gz
        tar -C /tmp -xf /tmp/go.tar.gz
        sudo mkdir -p "/usr/go/go${v}.${arch}"
        sudo rsync -a /tmp/go/ "/usr/go/go${v}.${arch}"
        echo "Set GOPATH=/usr/go/go${v}.${arch}"
    else
        echo "Maybe this doesn't exist or curl hung. Try again"
    fi
}

gogo(){
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a project name."
        return 1
    fi

    if [[ "$d" = github* ]]; then
        d=$(echo $d | sed 's/.*\///')
    fi
    d=${d%/}

    # search for the project dir in the GOPATH
    local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $GOPATH"
        echo "Maybe you need to 'go get' it ;)"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}
