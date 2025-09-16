#!/bin/zsh

podman::path () {
    local podman_path=/opt/podman/bin
    if [ -d "$podman_path" ]; then
        export PATH=${PATH}:${podman_path}
    fi
}

podman::path
