#!/bin/zsh

export HOMEBREW_BOOTSNAP=1
export HOMEBREW_NO_ENV_HINTS=1

# Assume brew is in here
eval "$(/opt/homebrew/bin/brew shellenv)"

# But then calculate it for other files ¯\_(ツ)_/¯
brew_prefix=$(brew --prefix)

