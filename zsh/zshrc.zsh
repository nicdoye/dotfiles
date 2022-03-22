#!/bin/zsh

# Run the whole thing in one anonymous function
# to keep rubbish out of global scope - providing declared as local

() {
    # Run this first. Not at the end or you put /usr/local/bin etc. in front of
    # rbenv et al.

    local _bsd_ph=/usr/libexec/path_helper
    [ -x ${_bsd_ph} ] && eval $(${_bsd_ph} -s)

    dotfiles_dir=${HOME}/.dotfiles
    source ${HOME}/.secrets/secrets.zsh ${dotfile_dir}/zsh/<00-99>_*.zsh
}
