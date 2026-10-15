#!/bin/zsh

# Run the whole thing in one anonymous function
# to keep rubbish out of global scope - providing declared as local
#

() {
    # Run this first. Not at the end or you put /usr/local/bin etc. in front of
    # rbenv et al.

    local _bsd_ph=/usr/libexec/path_helper
    [ -x ${_bsd_ph} ] && eval $(${_bsd_ph} -s)

    local perf_test='true'
    dotfiles_dir=${HOME}/.dotfiles

    if [ -z $perf_test ] || [ "$perf_test" != 'true' ]; then
        source ${HOME}/.secrets/secrets.zsh ${dotfiles_dir}/zsh/<00-99>_*.zsh
    else
        local date_cmd time_start time_end
        # Assume either have coreutils installed on macOS or on Linux
        # macOS date will just print 'N' for '%N'
        if whence gdate &>> /dev/null; then
            date_cmd=gdate
        else
            date_cmd=date
        fi

        local perf_file="/tmp/$(uname -s).$($date_cmd +%s).csv"

        for file in ${HOME}/.secrets/secrets.zsh ${dotfiles_dir}/zsh/<00-99>_*.zsh; do
            time_start="$($date_cmd +%s%N)"
            source "${file}"
            time_end="$($date_cmd +%s%N)"
            echo "${file}\t$(( $time_end - $time_start ))" >> "${perf_file}"
        done
    fi
}

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Who is setting this, please?
unsetopt extended_glob

# PaaS Dev Workstation - devcontainer specific settings
# Only apply if running inside the devcontainer (check PAAS_DEVCONTAINER env var)
if [ "$PAAS_DEVCONTAINER" = "1" ]; then
    source /home/paas/.venv-dev/bin/activate
    export JAVA_HOME=/usr/local/sdkman/candidates/java/current
    export PATH="$JAVA_HOME/bin:$PATH"

    # Git branch in prompt function. Emits " (branch)", or " (sha)" on a
    # detached HEAD, and nothing at all outside a repository.
    git_branch() {
      local branch
      branch=$(git symbolic-ref --short HEAD 2>/dev/null) \
        || branch=$(git rev-parse --short HEAD 2>/dev/null) \
        || return 0
      printf ' (%s)' "$branch"
    }

    # Custom prompt (devcontainer indicator: blue "paas-ws", green directory and
    # branch). Single-quoted so prompt_subst re-runs git_branch before every
    # prompt; double quotes would expand it once here and freeze the branch.
    setopt prompt_subst
    PROMPT='%F{blue}paas-ws%f %F{green}%~%f%F{green}$(git_branch)%f $ '
fi
