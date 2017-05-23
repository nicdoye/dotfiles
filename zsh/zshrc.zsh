# Run the whole thing in one anonymous function
# to keep rubbish out of global scope - providing declared as local

() {
    # Run this first. Not at the end or you put /usr/local/bin etc. in front of
    # rbenv et al.
    eval $(/usr/libexec/path_helper -s)

    export DOTFILES="${HOME}/.dotfiles"

    # Utility function - unused
    includer2 () {
        local filename=$1
        [ -f "${filename}" ] && source "${filename}" || echo "Error with or in ${filename}"
    }

    for file in "${HOME}/.00_secrets.zsh" ${DOTFILES}/zsh/[0-9][0-9]_*.zsh
    do
        includer2 ${file}
    done
}

#source <(antibody init)
#antibody bundle < "${DOTFILES}/antibody/bundles.txt" > ~/.zsh_plugins.sh
#antibody update
