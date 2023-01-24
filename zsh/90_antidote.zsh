#!/bin/zsh

declare _antidote_file
if [ "$(uname -s)" = 'Linux' ]; then
    _antidote_file="${HOME}/opt/antidote/antidote.zsh"
    if locale -a | grep -q en_GB.utf8; then
        export LANG=en_GB.UTF-8
    else
        export LANG=C.UTF-8
    fi
else
    _antidote_file="/opt/homebrew/opt/antidote/share/antidote/antidote.zsh"
fi

if [ -f "$_antidote_file" ]; then
    source "$_antidote_file"
else
    echo "[WARN] No antidote file ${_antidote_file}" &>> /dev/stderr
fi

# Spaceship doesn't work on CentOS 7, because zsh is too old. (5.0.x vs 5.2 minimum)
if [ $(echo $ZSH_VERSION | cut -f1 -d.) -lt 5 ] || \
    [ $(echo $ZSH_VERSION | cut -f1 -d.) -eq 5 ] && \
    [ $(echo $ZSH_VERSION | cut -f2 -d.) -lt 2 ]; then
    # Spaceship doesn't work on CentOS 7, because zsh is too old. (5.0.x vs 5.2 minimum)
    # https://github.com/denysdovhan/spaceship-prompt/issues/638

    export PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red}) ->%f "
fi

export SPACESHIP_CONFIG="${HOME}/.dotfiles/spaceship/spaceship.zsh"
if [ -f "${HOME}/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-spaceship-prompt-SLASH-spaceship-prompt/spaceship.zsh" ]; then
    # Old style (work laptop)
    source "${HOME}/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-spaceship-prompt-SLASH-spaceship-prompt/spaceship.zsh"
elif [ -f "${HOME}/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-spaceship-prompt-SLASH-spaceship-prompt/spaceship.zsh" ]; then
    # New style (home laptop)
    source "${HOME}/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-spaceship-prompt-SLASH-spaceship-prompt/spaceship.zsh"
fi

if type antidote &>> /dev/null; then
    source <(antidote init)
    antidote load
elif type antibody &>> /dev/null; then
    source <(antibody init)
fi