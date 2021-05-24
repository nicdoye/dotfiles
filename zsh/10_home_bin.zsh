#!/bin/zsh

home::bin::dir  () {
    local home_bin_dir="${HOME}/opt/${os_name}/${os_arch}/bin"
    if [ -d "${home_bin_dir}" ]; then
        export PATH=${home_bin_dir}:${PATH}
    fi
}

home::bin::dir