#!/bin/zsh

########################################################################
# ZSH
#
# Brew site functions dir
_site_functions="${brew_prefix}/share/zsh/site-functions"
_local_functions="${HOME}/.dotfiles/zfunc"
fpath+="${_site_functions}"
fpath+="${_local_functions}"

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
#source ${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
########################################################################
    
# I clearly don't understand fpath as some of these things just don't 
# complete, unless I source them :-|
# for i in /usr/local/share/zsh/site-functions/_* ; do j=$(basename $i | sed -e 's/.//'); grep -qL $j ~/.zcompdump || echo $j ; done

for completion in awless 
do
    source "${_site_functions}/_${completion}"
done

for completion in helm kubectl minikube ng
do
    source "${_local_functions}/_${completion}"
done
