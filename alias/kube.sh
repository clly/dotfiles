#!/usr/bin/env bash

alias kcd='kubectl config set-context $(kubectl config current-context) --namespace '
alias kcu='kubectl config use-context '
alias kc='kubectl config get-contexts'

function minikube_svc() {
    local svc=$1
    if [[ -z $svc ]]; then
        echo "Empty service"
        return 1
    fi

    kubectl get svc $svc -o json | jq -r .spec.clusterIP
}

function kctx() {
    local ctx=$1
    shift
    if [[ -z $ctx ]]; then
        echo "Empty context"
        return 1
    fi

    kubectl --context $1 $@
}
