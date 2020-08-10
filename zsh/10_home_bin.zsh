#!/bin/zsh

########################################################################
# Non-Homebrew
unix_home=${HOME}
opt_prefix=${unix_home}/opt
########################################################################
export PATH=${unix_home}/opt/${os_name}/${os_arch}/bin:${PATH}

unset unix_home
unset opt_prefix
