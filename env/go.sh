#!/usr/bin/env bash

gobin=$(type -P "go")
if [[ -z $gobin ]]; then
    if [[ $SYSTEM != 'Darwin' ]]; then
        export GOROOT="/usr/go/go${GOVERSION}"
    else
        export GOROOT=/usr/go/go$GOVERSION
    fi

    PATH=$GOROOT/bin:$PATH:$GOPATH/bin
    export PATH
fi

export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin

function goSwitch() {
    if [[ -z $1 ]]; then
        return 1
    fi
    local switchedGo=$1
    local goSourcePath="/usr/go/go${switchedGo}.linux-amd64"
    if [[ -d "/usr/go/go${switchedGo}.linux-amd64" ]]; then
        declare -A dedupe
        declare -a newpath
        local p=""
        IFS=':'
        for i in $PATH; do
            if [[ $i == "${GOROOT}/bin" ]]; then
                if [[ ! ${dedupe["${goSourcePath}/bin"]+_} ]]; then
                    echo "Adding go ${switchedGo} to PATH"
                    dedupe["${goSourcePath}/bin"]=1
                    newpath+=( "${goSourcePath}/bin" )
                fi
            else
                if [[ ! ${dedupe[$i]+_} ]]; then
                    dedupe[$i]=1
                    newpath+=( $i )
                fi
            fi
        done
        # loop over deduplicated path to build new loop
        for k in "${newpath[@]}"; do
            p="${p}:${k}"
        done
        echo $p
        export PATH=$(cut -f2- -d: <<< $p)
        export GOROOT=$goSourcePath
        unset IFS
        unset dedupe
        unset newpath
    fi
}
