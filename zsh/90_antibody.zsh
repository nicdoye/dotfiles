source <(antibody init)
antibody bundle < "${dotfiles_dir}/antibody/bundles.txt" > ~/.zsh_plugins.sh
#source ~/.zsh_plugins.sh
#antibody update

# macOS
_nic_macos_os () {
    system_profiler SPSoftwareDataType | grep -w Version | cut -f2 -d: | awk '{print $1 " " $2}' | xargs
}

# Linux
_nic_lsb_os () {
    local lsb_i="$(lsb_release -i | awk '{print $2}')"
    local lsb_r="$(lsb_release -r | awk '{print $2}')"

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

[ -v _os ] && \
    SPACESHIP_CHAR_PREFIX="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} "
    #PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f "

