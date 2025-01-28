#!/usr/bin/env bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

if [[ $SYSTEM =~ [Ll]inux* ]]; then
    release=$(command -v lsb_release || true)
    if [[ -n $release ]]; then
        id=$(lsb_release --id)
    elif [[ -f /etc/redhat-release ]]; then
        id=$(cat /etc/redhat-release)
    fi	
fi

case $id in
    *Ubuntu)
        export pkg=$(which apt)
        export os="Ubuntu"
        ;;
    *Fedora*)
	export pkg=$(command -v rpm-ostree)
        export os="Fedora"
        ;;
    *)
        echo "unknown os"
        export os="unknown"
        ;;
esac
