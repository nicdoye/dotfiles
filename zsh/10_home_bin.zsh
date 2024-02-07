#!/bin/zsh

home::bin::dir  () {
    local home_os_bin_arch_dir="${HOME}/opt/${os_name}/${os_arch}/bin"
    if [ -d "${home_os_bin_arch_dir}" ]; then
        export PATH=${home_os_bin_arch_dir}:${PATH}
    fi

    local home_os_bin_dir="${HOME}/opt/${os_name}/bin"
    if [ -d "${home_os_bin_dir}" ]; then
        export PATH=${home_os_bin_dir}:${PATH}
    fi

    local home_bin_dir="${HOME}/opt/bin"
    if [ -d "${home_bin_dir}" ]; then
        export PATH=${home_bin_dir}:${PATH}
    fi
}

home::bin::dir