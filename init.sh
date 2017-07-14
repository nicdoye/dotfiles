#!/bin/bash

# Stupid macOS still comes with bash 3.2, so no associative arrays

declare dotfiles_dir=.dotfiles

ln_dot () {
  local dir=$1
  shift
  local files=$*

  pushd ${HOME}
  local file
  for file in ${files[*]}
  do
    ln -s "${dotfiles_dir}/${dir}/${file}" ".${file}"
  done
  popd
}

_git () {
  local dir=git
  local -a files=(gitconfig gitignore_global)
  ln_d ${dir} ${files[*]}
}

_perl () {
  local dir=perl
  local -a files=(perltidyrc)
  ln_d ${dir} ${files[*]}
}

_vim () {
  local dir=vim
  local -a files=(vim vimrc)
  ln_d ${dir} ${files[*]}
}

_zsh () {
  pushd ${HOME}
  ln -s "${dotfiles_dir}/zsh/zshrc.zsh" ".zshrc"
  popd
}

run () {
  _git
  _perl
  _vim
  _zsh
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && run $*

exit 0
