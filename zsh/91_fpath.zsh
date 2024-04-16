#!/bin/zsh


autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

if test -n "${brew_prefix}"; then
    _site_functions="${brew_prefix}/share/zsh/site-functions"
    fpath+="${_site_functions}"

    for completion in brew finch gh git helm kubectl
    do
        if test -f "${_site_functions}/_${completion}"; then
            source "${_site_functions}/_${completion}" 2>/dev/null
        fi
    done
else
    # Inside a container, we don't have brew_prefix
    # git should just work https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
    source <(helm completion zsh)
    source <(kubectl completion zsh)
fi

if type kubecolor &>> /dev/null; then
    compdef kubecolor=kubectl &>> /dev/null
fi

# AWS CLI completion
if _wac="$(whence -p aws_completer)" ; then
    complete -C "$_wac" aws
fi
