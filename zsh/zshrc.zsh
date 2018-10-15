#!/bin/zsh

# Run the whole thing in one anonymous function
# to keep rubbish out of global scope - providing declared as local

() {
    # Run this first. Not at the end or you put /usr/local/bin etc. in front of
    # rbenv et al.
    eval $(/usr/libexec/path_helper -s)

    export dotfiles_dir="${HOME}/.dotfiles"

    # Utility function - unused
    includer () {
        local filename=$1
        # Removing error, because kubectl one returns 127 o_O
        # [ -f "${filename}" ] && source "${filename}" || echo "Error with or in ${filename}"
        [ -f "${filename}" ] && source "${filename}"
    }

    local secret_zshrc="${HOME}/.secrets/secrets.zsh"
    for file in "${secret_zshrc}" ${dotfiles_dir}/zsh/[0-9][0-9]_*.zsh
    do
        includer ${file}
    done
}

