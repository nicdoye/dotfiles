########################################################################
# Non-Homebrew
unix_home=${HOME}
opt_prefix=${unix_home}/opt
########################################################################
export PATH=${unix_home}/bin:${unix_home}/sbin:${PATH}
export PATH=${opt_prefix}/istio/bin:${PATH}
export PATH=${PATH}:${opt_prefix}/kubebuilder/bin
unset unix_home
unset opt_prefix
