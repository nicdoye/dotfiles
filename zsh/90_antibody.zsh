#!/bin/zsh

# macOS
_nic_macos_os () {
    system_profiler SPSoftwareDataType | grep -w Version | cut -f2 -d: | /usr/bin/awk '{print $1 " " $2}' | xargs
}

_nic_macos_cpu_fans () {
    echo $(osx-cpu-temp -f | tail -2 | awk '{print $7}' | xargs) + 2 / pq | dc
}

_nic_macos_cpu_temp () {
    osx-cpu-temp
}

# Linux
_nic_lsb_os () {
    echo "$(lsb_release -ds | \
            tr -d '"' | \
            sed -e 's/release//' \
                -e 's/([^)]*)//' \
                -e 's/\s\+/ /g' \
                -e 's/\s*$//')"
}

# Append arch
_nic_arch () {
    local os="$@"
    local arch="$(uname -m)"
    #[ "${arch}" != 'x86_64' ] && os="${os} ${arch}"
    os="${os} ${arch}"
    echo "${os}"
}

_nic_os_release_os () {
    echo "$(/usr/bin/grep ^'PRETTY_NAME=' /etc/os-release | \
                cut -f2 -d= | \
                tr -d '"' | \
                sed -e 's/([^)]*)//' \
                    -e 's/\s\+/ /g' \
                    -e 's/\s*$//')"
}

if type system_profiler &>> /dev/null &&; then \
    _os=$(_nic_macos_os)
fi

if [[ -z "${_os}" ]] && type lsb_release &>> /dev/null; then \
    _os=$(_nic_lsb_os)
fi

if [[ -z "${_os}" ]] && [[ -r /etc/os-release ]]; then \
    _os=$(_nic_os_release_os)
fi 

if [ -z "${_os}" ]; then
    _os='Unknown'
fi

type uname &>> /dev/null && \
    _os=$(_nic_arch "${_os}")

if type antibody &>> /dev/null; then
    source <(antibody init)
    if [ $(echo $ZSH_VERSION | cut -f1 -d.) -ge 5 ] && [ $(echo $ZSH_VERSION | cut -f2 -d.) -ge 2 ]; then 
        antibody bundle < "${dotfiles_dir}/antibody/bundles.txt" > ~/.zsh_plugins.sh
    else
        # Spaceship doesn't work on CentOS 7, because zsh is too old. (5.0.x vs 5.2 minimum)
        # https://github.com/denysdovhan/spaceship-prompt/issues/638
        cat "${dotfiles_dir}/antibody/bundles.txt" | \
            /usr/bin/grep -v 'denysdovhan/spaceship-prompt' | \
            antibody bundle > ~/.zsh_plugins.sh
        # Powerline fonts mess up long lines on Linux
        export PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red}) ->%f "
    fi
fi

# Move to a function and get working
#[ -f /usr/local/share/kube-ps1.sh ] && source /usr/local/share/kube-ps1.sh
#KUBE_PS1_SYMBOL_USE_IMG=true
# Usse $(kube_ps1) somewhere

SPACESHIP_HOST_SHOW=always
SPACESHIP_USER_SHOW=always
# 2018.11.29 - Currently broken
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_KUBECONTEXT_SYMBOL="${SPACESHIP_KUBECONTEXT_SYMBOL} "
# Get rid of Kube stuff
SPACESHIP_KUBECTL_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW=false
SPACESHIP_KUBECTL_VERSION_SHOW=false

SPACESHIP_CHAR_SYMBOL="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} ${SPACESHIP_CHAR_SYMBOL}"

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
  pyenv         # Pyenv section
  dotnet        # .NET section
  # ember       # Ember.js section (Disabled)
  # kubecontext   # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  # vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# Removed all prefices so hacked this into CHAR SYMBOL. #naughty
#[ -v _os ] && \
    #SPACESHIP_CHAR_PREFIX="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} "

# Pure
#PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f "

