########################################################################
# Homebrew
# Sets brew_prefix to output of the anonymous function
#local brew_prefix=$(brew --prefix)
brew_prefix=$(brew --prefix)
# Non-Homebrew
local opt_prefix=${HOME}/unix/opt
########################################################################
export PATH=/usr/local/sbin:${PATH}
