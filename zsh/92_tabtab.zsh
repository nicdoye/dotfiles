#!/bin/zsh

for file in /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/*.zsh
do
    if test -f "${file}"; then
        . "${file}"
    fi
done &>> /dev/null
