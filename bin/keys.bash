#!/usr/bin/env bash

# pets: destfile=/home/connor/bin/keys.bash, mode=0755

set -euo pipefail

DEBUG=${DEBUG:=0}
if [[ $DEBUG != 0 ]]; then
    echo "DEBUG=$DEBUG"
    set -x
fi

trap 'echo failure ${LINENO} "$BASH_COMMAND"' ERR


KEYS_FILE=~/.ssh/authorized_keys
github_keys=$(curl -s https://github.com/clly.keys)
tmp_keys=$(mktemp -d -p ~/.ssh)/keys
tmp_dir=${tmp_keys%%/keys}
trap 'rm -rf ${tmp_dir}' EXIT
ownership="managed-by-keys.bash"


IFS=$'\n' 
current_SHA=""
if [[ -e "${KEYS_FILE}" ]]; then
    current_SHA=$(sha256sum < $KEYS_FILE)
    while IFS= read -r line; do
        grep --quiet "$ownership" <<<"${line}" && continue
        if [[ -n $line ]]; then 
            echo "${line}" >> "${tmp_keys}"
        fi
    done < "$KEYS_FILE"
fi

for key in $github_keys; do
    echo "${key} $ownership" >> "${tmp_keys}"
done

new_SHA=$(sha256sum < "${tmp_keys}")

if [[ $new_SHA != "${current_SHA}" ]]; then
    chmod 0400 "${tmp_keys}"
    mv -f "${tmp_keys}" $KEYS_FILE
fi
