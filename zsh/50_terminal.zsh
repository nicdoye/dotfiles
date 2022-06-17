#!/bin/zsh

_read::ti_file () {
# https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
    local _ti_file="${HOME}/.${TERM}.ti"
    [ -r "${_tic_file}" ] && tic "${_ti_file}"
}
# SHELL
export EDITOR=nvim
# This is idiotic - setting your editor to vim means it assumes you
# want vim keybindings. Reset to emacs:
bindkey -e
export CLICOLOR=1
_read::ti_file
#
export LSCOLORS=Gxfxcxdxbxegedabagacad
export TERM=xterm-256color
export PURE_CMD_MAX_EXEC_TIME=1
export HISTFILE=${HOME}/.zsh_history
export SAVEHIST=10000000
export HISTSIZE=10000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt prompt_subst
setopt autocd
# Annoying
unsetopt correctall
setopt interactivecomments

# ripgrep config
export RIPGREP_CONFIG_PATH="${dotfiles_dir}/ripgrep/ripgreprc"

# Bizarre zshism
function history () {
    if [ -z "$*" ]; then
        # Bash-style all history
        fc -l 1
    else
        fc -l $*
    fi
}

alias ls='ls --color'

# For git
export GPG_TTY=$(tty)


if whence paas-bom.sh &>> /dev/null && paas-bom.sh | grep -q ^PAAS_TOOL_FULL_CLIENT_VERSION ; then
    echo -e "\033]50;SetProfile=PaaS Full Client\a"
fi
