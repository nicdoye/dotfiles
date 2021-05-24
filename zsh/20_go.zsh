#!/bin/zsh

go::path () {
    export GOPATH=${HOME}/go
    if [ -n "$brew_prefix" ]; then
        export GOROOT="${brew_prefix}/opt/go/libexec"
        export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin
    fi
}

go::path