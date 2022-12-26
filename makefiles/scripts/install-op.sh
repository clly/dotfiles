#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

ARCH="amd64" && \
    wget "https://cache.agilebits.com/dist/1P/op2/pkg/v2.12.0/op_linux_${ARCH}_v2.12.0.zip" -O op.zip && \
    unzip -d op op.zip && \
    mv op/op ~/bin && \
    rm -r op.zip op

