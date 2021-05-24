#!/bin/zsh

python::script::location    () {
    local python_version='3.9'
    local script_location="${HOME}/Library/Python/${python_version}/bin"
    if [ "${os_name}" = 'darwin' -a -d "${script_location}" ]; then
        export PATH=${script_location}:${PATH}
    fi
}

python::script::location