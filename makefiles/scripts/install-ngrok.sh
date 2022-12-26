#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

curl -o ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar xvzf ngrok.tgz -C ~/bin && rm ngrok.tgz
