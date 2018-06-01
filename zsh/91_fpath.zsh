########################################################################
# ZSH
# Now getting from bundle not brew
#fpath=(${brew_prefix}/share/zsh-completions $fpath)
#autoload -U compinit && compinit
 autoload -U +X compinit && compinit
 autoload -U +X bashcompinit && bashcompinit
#source ${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
########################################################################
    
# AWS has its own wrapper
for file in aws_zsh_completer.sh _kops
do
    source "${brew_prefix}/share/zsh/site-functions/${file}"
done
