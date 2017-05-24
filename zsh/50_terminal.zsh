# SHELL
export EDITOR=nvim
# This is idiotic - setting your editor to vim means it assumes you
# want vim keybindings. Reset to emacs:
bindkey -e
export CLICOLOR=1
# https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
tic ~/.${TERM}.ti
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
