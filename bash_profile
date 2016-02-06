# .bash_profile

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
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export CLICOLOR=1

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$GOPATH/bin:$HOME/bin

export PATH

[[ -n "$SSH_AUTH_SOCK" ]] && eval "$(ssh-agent -s)"

# Set up git bash prompt
green=$(tput setaf 2)
blue=$(tput setaf 4)
bold=$(tput bold)
red=$(tput setaf 1)
reset=$(tput sgr0)
PS1='\u@\[$green\]\h\[$reset\]:\w \[$blue\]$(git_ps1)\[$reset\]\$ '

# Git completion
[ -f $HOME/.git-completion.bash ] && source .git-completion.bash

alias ll='ls -l --time-style=long-iso'
