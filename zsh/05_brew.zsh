#!/bin/zsh

########################################################################
# Homebrew
# Sets brew_prefix to output of the anonymous function
#local brew_prefix=$(brew --prefix)
brew_prefix=$(brew --prefix)
########################################################################
export PATH=${brew_prefix}/sbin:${PATH}

# DO NOT UNSET. IT IS USED IN OTHER FILES.
#unset brew_prefix
