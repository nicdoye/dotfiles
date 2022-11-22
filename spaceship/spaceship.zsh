#!/bin/zsh

SPACESHIP_HOST_SHOW=always
SPACESHIP_USER_SHOW=always
# 2018.11.29 - Currently broken
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_KUBECONTEXT_SYMBOL="${SPACESHIP_KUBECONTEXT_SYMBOL} "
# Get rid of Kube stuff
SPACESHIP_KUBECTL_SHOW=false
SPACESHIP_KUBECTL_CONTEXT_SHOW=false
SPACESHIP_KUBECTL_CONTEXT_SHOW_NAMESPACE=false
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_ANSIBLE_SHOW=false

source "${HOME}/.dotfiles/spaceship/spaceship_section.plugin.zsh"

# Just comment a section if you want to disable it
SPACESHIP_PROMPT_ORDER=(
  # time        # Time stamps section (Disabled)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  # package     # Package version (Disabled)
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode       # Xcode section (Disabled)
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia       # Julia section (Disabled)
  # docker      # Docker section (Disabled)
  aws           # Amazon Web Services section
  # gcloud        # Google Cloud Platform section
  venv          # virtualenv section
  # conda         # conda virtualenv section
  # pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember       # Ember.js section (Disabled)
  # kubecontext   # Kubectl context section
  # terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  # vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  os            # My custom OS section
  char          # Prompt character
)

