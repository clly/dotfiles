#!/bin/bash

alias cover='go test -covermode=count -coverprofile=coverage.out --coverpkg=./... ./... && go tool cover -html=coverage.out && rm coverage.out'
godb() {
    set -x
    if [[ -z $1 ]]; then
        local pkg=$(go list)
    else
        local pkg=$1
    fi

    if [[ -n $2 ]]; then
        local output="-o $2"
    fi

    docker run --rm -it -v "$GOPATH":/go -w "/go$(trim -l $GOPATH $PWD)" golang go build $output -v $pkg
    set +x
}

go-mod-build() {
    set -x
    if [[ -z $1 ]]; then
        local pkg=$(go list)
    else
        local pkg=$1
    fi

    if [[ -n $2 ]]; then
        local output="-o $2"
    fi

    docker run --rm -it -e GO111MODULE=on -v "$GOPATH":/go -w "/go$(trim -l $GOPATH $PWD)" golang go build $output -v $pkg
    set +x
}

gocwd() {
    p=$GOPATH
    if [[ -n $p ]]; then
        $d
    fi
}

installgo(){
    sudo id > /dev/null
    local v=$1

    if [[ $SYSTEM == "Darwin" ]]; then
        arch="darwin-amd64"
    else
        arch="linux-amd64"
    fi

    if [[ -n $v ]]; then
        local goversion="go${v}.${arch}"
    elif [[ -n $GOVERSION ]]; then
        local goversion="go${GOVERSION}"
    else
        echo "You need to specify a version to install"
        return 1
    fi
    echo "Installing version ${goversion}"

    local gp="/usr/go/"
    url="https://storage.googleapis.com/golang/${goversion}.tar.gz"

    if $(curl -s -I -m 5 -XHEAD $url|grep -q "200 "); then
        wget --quiet $url -O /tmp/go.tar.gz
        tar -C /tmp -xf /tmp/go.tar.gz
        sudo mkdir -p "/usr/go/${goversion}"
        sudo rsync -a /tmp/go/ "/usr/go/${goversion}"
        echo "Set GOROOT=/usr/go/${goversion}"
    else
        echo "Maybe this doesn't exist or curl hung. Try again"
    fi
}

gogo(){
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a project name."
        return 1
    fi

    if [[ "$d" = github* ]]; then
        d=$(echo $d | sed 's/.*\///')
    fi
    d=${d%/}

    # search for the project dir in the GOPATH
    local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $GOPATH"
        echo "Maybe you need to 'go get' it ;)"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}
