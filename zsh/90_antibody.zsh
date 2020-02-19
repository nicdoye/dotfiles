#!/bin/zsh

if type antibody &>> /dev/null; then
    source <(antibody init)
    antibody bundle < "${dotfiles_dir}/antibody/bundles.txt" > ~/.zsh_plugins.sh
fi

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
    local lsb_i="$(lsb_release -i | /usr/bin/awk '{print $2}')"
    local lsb_r="$(lsb_release -r | /usr/bin/awk '{print $2}')"

    # RHEL Hack
    [ "${lsb_i}" = 'RedHatEnterpriseServer' ] && lsb_i='RHEL'

    echo "${lsb_i} ${lsb_r}"
}

# Append if not x86_64
_nic_arch () {
    local os="$@"
    local arch="$(uname -m)"
    [ "${arch}" != 'x86_64' ] && os="${os} ${arch}"
    echo "${os}"
}

type system_profiler &>> /dev/null && \
    _os=$(_nic_macos_os)

type lsb_release &>> /dev/null && \
    _os=$(_nic_lsb_os)

type uname &>> /dev/null && \
    _os=$(_nic_arch "${_os}")

# Move to a function and get working
[ -f /usr/local/share/kube-ps1.sh ] && source /usr/local/share/kube-ps1.sh
KUBE_PS1_SYMBOL_USE_IMG=true
# Usse $(kube_ps1) somewhere

SPACESHIP_HOST_SHOW=always
SPACESHIP_USER_SHOW=always
# 2018.11.29 - Currently broken
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_KUBECONTEXT_SYMBOL="${SPACESHIP_KUBECONTEXT_SYMBOL} "
SPACESHIP_CHAR_SYMBOL="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} ${SPACESHIP_CHAR_SYMBOL}"

# Removed all prefices so hacked this into CHAR SYMBOL. #naughty
#[ -v _os ] && \
    #SPACESHIP_CHAR_PREFIX="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} "

# Pure
#PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f "

