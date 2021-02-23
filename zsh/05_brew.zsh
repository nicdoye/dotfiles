#!/bin/zsh

########################################################################
# Homebrew
# Sets brew_prefix to output of the anonymous function
#local brew_prefix=$(brew --prefix)
if type brew &>> /dev/null; then
    brew_prefix=$(brew --prefix)
    export PATH=${brew_prefix}/sbin:${PATH}
    # https://github.com/Homebrew/brew/pull/10374
    export HOMEBREW_BOOTSNAP=1
fi
########################################################################

# DO NOT UNSET. IT IS USED IN OTHER FILES.
#unset brew_prefix
