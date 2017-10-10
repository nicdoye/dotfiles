source <(antibody init)
antibody bundle < "${dotfiles_dir}/antibody/bundles.txt" > ~/.zsh_plugins.sh
#source ~/.zsh_plugins.sh
#antibody update

type system_profiler &>> /dev/null && \
    _os=$(system_profiler SPSoftwareDataType | grep -w Version | cut -f2 -d: | awk '{print $1 " " $2}' | xargs)

[ -v _os ] && \
    PS1="%}%(12V.%F{242}%12v%f .)%F{green}${_os}%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f "
