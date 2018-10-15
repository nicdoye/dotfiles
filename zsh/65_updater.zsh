#!/bin/zsh

# vim: set filetype=sh :

########################################################################
# Remember one-liners containing || etc., need to be enclosed by {}
########################################################################

# There's no reason for these not to be in global scope
brew_u      () 
{ 
    print_36spacex 🍺
    brew upgrade 
}

gcloud_u    ()
{
    print_36spacex '🌥 '
    gcloud components update --quiet
}

mas_u       ()
{
    print_36spacex 🍎
    mas upgrade
}

antibody_u  ()
{
    print_36spacex 💉
    antibody update
}

npm_u       ()
{
    print_36spacex 🔥
    npm i -g npm
    npm up -g firebase-tools aws-sam-local
}

rust_u      ()
{
    print_36spacex ®
    rustup update
}

sdk_u       ()
{
    print_36spacex 🌟
    sdk selfupdate force
    [[ -s "/Users/ndoye/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ndoye/.sdkman/bin/sdkman-init.sh"
    # There is a chance sdkman could update again between these two commands.
    # which would cause the following to give a prompt :(
    sdk update
}

gofish_u    ()
{
    print_36spacex 🐠
    gofish upgrade
}

brew_cask_u ()
{
    print_36spacex 🛢️
    brew cask outdated
    for cask in $(brew cask outdated | awk '{ print $1 }' |  grep -v chef | xargs)
    do
        brew cask reinstall "$cask"
    done
}

optional_u ()
{
    brew_cask_u
}

bum         () 
{ 
    local all_p=$1

    print_36spacex 🏁
    echo

    gofish_u
    brew_u
    # Uninstalled mas with Mojave
    # mas_u
    npm_u
    antibody_u
    gcloud_u
    rust_u
    # sdk_u
    [[ '-a' == "$all_p" ]] && optional_u
    
    echo
    print_36spacex 🛑
}
