#!/bin/zsh

# vim: set filetype=sh :

########################################################################
# Remember one-liners containing || etc., need to be enclosed by {}
########################################################################

# There's no reason for these not to be in global scope
brew_u      () 
{ 
    print::n 27 '🍺 '
    brew upgrade 
}

topgrade_u  ()
{
    print::n 27 '🎩 '
    topgrade 
}

gcloud_u    ()
{
    print::n 27 '🌥 '
    gcloud components update --quiet
}

mas_u       ()
{
    print::n 27 '🍎 '
    mas upgrade
}

antibody_u  ()
{
    print::n 27 '💉 '
    antibody update
}

npm_u       ()
{
    print::n 27 '🔥 '
    npm i -g npm
    npm up -g firebase-tools aws-sam-local @aws-amplify/cli
}

rust_u      ()
{
    print::n 27 '® '
    rustup update
}

sdk_u       ()
{
    print::n 27 '🌟 '
    sdk selfupdate force
    [[ -s "/Users/ndoye/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ndoye/.sdkman/bin/sdkman-init.sh"
    # There is a chance sdkman could update again between these two commands.
    # which would cause the following to give a prompt :(
    sdk update
}

gofish_u    ()
{
    print::n 27 '🐠 '
    gofish upgrade
}

brew_cask_u ()
{
    print::n 27 '🛢️ '
    brew outdated --cask
    for cask in $(brew outdated --cask | /usr/bin/awk '{ print $1 }' |  grep -v chef | xargs)
    do
        brew reinstall "$cask"
    done
}

optional_u ()
{
    brew_cask_u
}

bum_old    () 
{ 
    local all_p=$1

    print::n 27 '🏁 '
    echo

    topgrade_u

    [[ '-a' == "$all_p" ]] && optional_u
    
    echo
    print::n 27 '🛑 '
}

# 2021.01.06 My old updater is deprecated - just use topgrade now
alias bum=topgrade