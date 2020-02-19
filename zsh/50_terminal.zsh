#!/bin/zsh

# SHELL
export EDITOR=nvim
# This is idiotic - setting your editor to vim means it assumes you
# want vim keybindings. Reset to emacs:
bindkey -e
export CLICOLOR=1
# https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
if test -f ~/.${TERM}.ti; then
    tic ~/.${TERM}.ti
fi
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
export RIPGREP_CONFIG_PATH="${HOME}/.dotfiles/ripgrep/ripgreprc"

# Bizarre zshism
# alias history="history 1"
# Equivalent/better as a function.
function history () { 
    if [ -z "$*" ]
    then
        # Bash-style all history
        fc -l 1
    else
        fc -l $*
    fi
}
