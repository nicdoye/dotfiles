#!/bin/zsh

########################################################################
# ZSH
#
# Brew site functions dir
if test -n "${brew_prefix}"; then
    _site_functions="${brew_prefix}/share/zsh/site-functions"
    fpath+="${_site_functions}"

    for completion in awless; do
        if test -f "${_site_functions}/_${completion}"; then
            # source "${_site_functions}/_${completion}"
        fi
    done
fi

_local_functions="${HOME}/.dotfiles/zfunc"
fpath+="${_local_functions}"

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
#source ${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
########################################################################
    
# I clearly don't understand fpath as some of these things just don't 
# complete, unless I source them :-|
# for i in /usr/local/share/zsh/site-functions/_* ; do j=$(basename $i | sed -e 's/.//'); grep -qL $j ~/.zcompdump || echo $j ; done

for completion in helm kubectl minikube ng
do
    if test -f "${_local_functions}/_${completion}"; then
        # source "${_local_functions}/_${completion}"
    fi
done
