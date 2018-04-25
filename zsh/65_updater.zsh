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
    npm up -g npm firebase-tools aws-sam-local
}

sdk_u       ()
{
    print_36spacex 🌟
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
    sdk_u
    brew_cask_u
}

bum         () 
{ 
    local all_p=$1

    print_36spacex 🏁
    echo

    gofish_u
    brew_u
    mas_u
    npm_u
    antibody_u
    gcloud_u
    [[ '-a' == "$all_p" ]] && optional_u
    
    echo
    print_36spacex 🛑
}
