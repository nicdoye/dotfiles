########################################################################
# ZSH
# Now getting from bundle not brew
#fpath=(${brew_prefix}/share/zsh-completions $fpath)
#autoload -U compinit && compinit
 autoload -U +X compinit && compinit
 autoload -U +X bashcompinit && bashcompinit
#source ${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
########################################################################
    
# This doesnt get sourced as part of the _fpath. Weird.
 source ${brew_prefix}/share/zsh/site-functions/_aws
