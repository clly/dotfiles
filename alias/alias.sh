#!/bin/bash

if [[ $SYSTEM == "Darwin" ]]; then
  alias ls='ls -G'
  alias vim='nvim'
else
  alias ls='ls --color=always'
  alias gpg=gpg2
fi
alias ll='ls -l --time-style=long-iso'
alias datetimestamp='date +%Y%m%d%H%M%S'
alias srestart='sudo supervisorctl restart'
alias fetch-root-servers='curl -o root.hints https://www.internic.net/domain/named.cache'

alias dockc='docker-compose'
alias dexec='docker run --rm -it'
alias gpullf='git pull --ff-only'
alias vim=nvim
