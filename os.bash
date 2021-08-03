#!/usr/bin/env bash

id=$(lsb_release --id)

case $id in
    *Ubuntu)
        export pkg=$(which apt)
        export os="Ubuntu"
        ;;
    *)
        echo "unknown os"
        exit 1
        ;;
esac
