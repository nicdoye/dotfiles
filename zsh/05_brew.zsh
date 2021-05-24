#!/bin/zsh

brew::sbin::dir () {
    if type brew &>> /dev/null; then
        brew_prefix=$(brew --prefix)
        export PATH=${brew_prefix}/sbin:${PATH}
        # https://github.com/Homebrew/brew/pull/10374
        export HOMEBREW_BOOTSNAP=1
    fi
}

brew::sbin::dir

# DO NOT UNSET. IT IS USED IN OTHER FILES.
#unset brew_prefix
