#!/bin/zsh

# Actually does bin and sbin. I want bin before /usr/bin in my path.
brew::sbin::dir () {
    if type brew &>> /dev/null; then
        brew_prefix=$(brew --prefix)
        export PATH=${brew_prefix}/bin:${brew_prefix}/sbin:${PATH}
        # https://github.com/Homebrew/brew/pull/10374
        export HOMEBREW_BOOTSNAP=1
    fi
}

brew::sbin::dir

export HOMEBREW_NO_ENV_HINTS=1

# DO NOT UNSET. IT IS USED IN OTHER FILES.
#unset brew_prefix
