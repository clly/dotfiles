#!/usr/bin/env bash

#set -eou pipefail

function gmerged() {
    git for-each-ref \
        --format="%(if:notequals=main)%(refname:short)%(then)%(refname:short)%(end)" \
        refs/heads/ \
        --merged
}

function gnmerged() {
    git for-each-ref \
        --format="%(if:notequals=main)%(refname:short)%(then)%(refname:short)%(end)" \
        refs/heads/ \
        --no-merged
}
