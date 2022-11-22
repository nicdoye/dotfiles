#
# OS
#
# OS is a supa-dupa cool tool for making you development easier.
# Link: https://www.os.xyz

# macOS
_nic::macos::os::with::kernel () {
    system_profiler SPSoftwareDataType | \
        grep -w Version | \
        cut -f2 -d: | \
        /usr/bin/awk '{print $1 " " $2}' | xargs
}

_nic::macos::os () {
    system_profiler SPSoftwareDataType -json | \
        jq -r '.SPSoftwareDataType[0].os_version' | \
        /usr/bin/awk '{print $1 " " $2}'
}

_nic::macos::cpu::fans () {
    echo $(osx-cpu-temp -f | tail -2 | awk '{print $7}' | xargs) + 2 / pq | dc
}

_nic::macos::cpu::temp () {
    osx-cpu-temp
}

# Linux
_nic::lsb::os () {
    echo "$(lsb_release -ds | \
            tr -d '"' | \
            sed -e 's/release//' \
                -e 's/([^)]*)//' \
                -e 's/\s\+/ /g' \
                -e 's/\s*$//')"
}

# Append arch
_nic::arch () {
    local os="$@"
    local arch="$(uname -m)"
    #[ "${arch}" != 'x86_64' ] && os="${os} ${arch}"
    os="${os} ${arch}"
    echo "${os}"
}

_nic::redhat::relase::os () {
    local release_file="$1"
    cut -f 1 -d'(' < "$release_file" | \
        cut -f-2 -d. | \
        sed -e 's_release __' \
            -e 's_ $__g'
}

_nic::os::release::os () {
    /usr/bin/grep '^PRETTY_NAME=' /etc/os-release | \
        cut -f2 -d= | \
        tr -d '"' | \
        sed -e 's/([^)]*)//' \
            -e 's/\s\+/ /g' \
            -e 's/\s*$//'
}

os () {
    if type system_profiler &>> /dev/null; then
        _os=$(_nic::macos::os)
    elif [ -r /etc/os-release ]; then
        _os=$(_nic::os::release::os)
    elif type lsb_release &>> /dev/null; then
        _os=$(_nic::lsb::os)
    elif type uname &>> /dev/null; then
        _os="$(uname -s)"
    else
        _os='Unknown'
    fi

    type uname &>> /dev/null && _os=$(_nic::arch "${_os}")
    echo $_os
}

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_OS_SHOW="${SPACESHIP_OS_SHOW=true}"
SPACESHIP_OS_ASYNC="${SPACESHIP_OS_ASYNC=true}"
SPACESHIP_OS_PREFIX="${SPACESHIP_OS_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_OS_SUFFIX="${SPACESHIP_OS_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_OS_SYMBOL="${SPACESHIP_OS_SYMBOL=""}"
#SPACESHIP_CHAR_SYMBOL="%{%b%}%{%B%F{215}%}$_os%{%b%f%}%{%B%} ${SPACESHIP_CHAR_SYMBOL}"
SPACESHIP_OS_COLOR="${SPACESHIP_OS_COLOR="215"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show os status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_os() {
  # If SPACESHIP_OS_SHOW is false, don't show os section
  [[ $SPACESHIP_OS_SHOW == false ]] && return

  # Check if os command is available for execution
  spaceship::exists os || return

  # Show os section only when there are os-specific files in current
  # working directory.

  # spaceship::upsearch utility helps finding files up in the directory tree.
  local is_os_context="$(spaceship::upsearch os.conf)"
  # Here glob qualifiers are used to check if files with specific extension are
  # present in directory. Read more about them here:
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html
  #[[ -n "$is_os_context" || -n *.foo(#qN^/) || -n *.bar(#qN^/) ]] || return

  local os_version="$(os)"

  # Check if tool version is correct
  #[[ $tool_version == "system" ]] && return

  # Display os section
  # spaceship::section utility composes sections. Flags are optional
  spaceship::section::v4 \
    --color "$SPACESHIP_OS_COLOR" \
    --prefix "$SPACESHIP_OS_PREFIX" \
    --suffix "$SPACESHIP_OS_SUFFIX" \
    --symbol "$SPACESHIP_OS_SYMBOL" \
    "$os_version"
}
