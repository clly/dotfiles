#!/bin/bash

alias ls='ls --color=always'
alias ll='ls -l --time-style=long-iso'
alias datetimestamp='date +%Y%m%d%H%M%S'
alias srestart='sudo supervisorctl restart'
alias fetch-root-servers='curl -o root.hints https://www.internic.net/domain/named.cache'
alias gpg=gpg2
alias dockc='docker-compose'
alias dexec='docker run --rm -it'
