#!/usr/bin/env bash

export SYSTEM=$(uname -s)
if [[ $SYSTEM == "Darwin" ]]; then
    ARCH="darwin-amd64"
else
    ARCH="linux-amd64"
fi

if [[ $SYSTEM =~ "linux*" ]]; then
	id=$(lsb_release --id)
fi

case $id in
    *Ubuntu)
        export pkg=$(which apt)
        export os="Ubuntu"
        ;;
    *)
        echo "unknown os"
        export os="unknown"
        ;;
esac
