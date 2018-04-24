# vim: set filetype=sh :

########################################################################
# Remember one-liners containing || etc., need to be enclosed by {}
########################################################################

export PAGER=vimpager

__nic_pager () ${PAGER} $*
less        () __nic_pager $*
zless       () __nic_pager $*
bzless      () __nic_pager $*
lzless      () __nic_pager $*
xzless      () __nic_pager $*
more        () __nic_pager $*
zmore       () __nic_pager $*
bzmore      () __nic_pager $*
lzmore      () __nic_pager $*
xzmore      () __nic_pager $*
top         () glances
vim         () nvim $*
github      () cd ${HOME}/vcs/github.com

_java_version   () { 
    sdk current java | grep ^'[[:alnum:]]' | awk '{print $4}' 
}

setmyokta   () {
    sdk use java 8u152-zulu
    cd "${HOME}/.aws"
    setmyokta.sh $*
    cd "${OLDPWD}"
}


# This is only for commands, not functions or aliases
find_cmd    () { whence -p $1 || echo false ; }

pstree      () $(find_cmd pstree) -g2 -w $*
l           () $(find_cmd m) lock

print_sep   ()
{
    printf -- "---- $*\t------------------------------------------------------\n"
}

print_36spacex ()
{
    for i in $(seq 0 35); do echo -n "$1 "; done ; echo
}

print_72x   ()
{
    for i in $(seq 0 71); do echo -n $1; done ; echo
}

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

bi          () brew info 	$* 
bin         () brew install $* 
bh          () brew home 	$*

lx          () exa  --long --group-directories-first --group --git $*
#ls          () exa  --long --group-directories-first --group --git $*

youtube-flac () youtube-dl -x --audio-format flac --audio-quality 9 $* 

flac2alac	() {
	for file in $*
	do
		ffmpeg -i "${file}" -vn -c:a alac "${file%.flac}.m4a" # cover.jpg
	done
}

# https://gist.github.com/nicdoye/62a2000972ee347123f079b70e994bc2

__nic_grep       () 
{
    local grep_type=$1
    local str=$2
    local true_values=( true yes on 1 )
    local prefer_gnu=true
    local prefer_ripgrep=true
    local prefix=''

    # ripgrep overrides ggrep and grep
    if [[ ${true_values[(i)${prefer_ripgrep}]} -le ${#true_values} ]]
    then
        if [[ ${grep_type} == '-H' ]]
        then
            rg -N -p --no-heading ${str}
        else 
            # Assume -l.
            rg -l ${str}
        fi
        return $?
    elif [[ ${true_values[(i)${prefer_gnu}]} -le ${#true_values} ]]
    then
        # prefix=${prefer_gnu+g}
        prefix=g
    fi

    ${prefix}find . -type f -not -path '*/.git/*' -exec ${prefix}grep ${grep_type} ${str} {} \;
}

lgrep       () __nic_grep -l $*
Hgrep       () __nic_grep -H $*

git-all     () { git commit -a -m "$*" && git push }
git-ndoye   () { git-all "$*" ; ssh -At pinf07 'sudo su -lc "puppet-code deploy ndoye --wait"' }
git-remind  () { git branch && git status }

#tiff2png    () {
    #local ifile=$1
    #local ofile=$(dirname "${ifile}")/$(basename "${ifile}" .tiff).png
    #tifftopnm < "${ifile}"| pnmtopng > "${ofile}"
#}

# Running commands in docker
# $1 is the image
di          () docker run --rm -it $*
# Run commands in CentOS docker
# ssh bit doesn't work as there's no client
_di_all     () 
{
    local image=$1
    shift 1

    local pwd=$(pwd)
    local mountpoint=/mnt
    local local_ssh=/root/.ssh
    local remote_ssh=/Users/ndoye/.ssh

    docker run --rm -it     \
        -v /:${mountpoint}  \
        -v ${remote_ssh}:${local_ssh}  \
        -w ${mountpoint}/${pwd} ${image} $*
}

centos          () _di_all ${(%):-%N} $*
fedora          () _di_all ${(%):-%N} $*
ubuntu          () _di_all ${(%):-%N} $* 
debian          () _di_all ${(%):-%N} $* 
alpine          () _di_all ${(%):-%N} $*
# Particular alpine (3.7/latest on 2018.04.09)
alpine-fixed    () _di_all 'alpine@sha256:7b848083f93822dd21b0a2f14a110bd99f6efb4b838d499df6d04a49d0debf8b' $*
# Particular centos (7.4.1708/latest on 2018.04.09)
centos-fixed    () _di_all 'centos@sha256:bc494daa9d9ad7e37f93236fbd2c3f372739997c6336ef3c321e227f336e73d3' $*

# Actual commands
#aws         () di --volume ~/.aws:/root/.aws cgswong/aws:latest aws $*
#curl        () fedora ${(%):-%N} $*
#ggrep       () fedora grep $*

# fedora/docker is faster than native which is faster than alpine/docker
sha1sum     () alpine-fixed ${(%):-%N} $*
sha256sum   () alpine-fixed ${(%):-%N} $* 
sha512sum   () alpine-fixed ${(%):-%N} $* 
# Not in alpine
sha224sum   () centos-fixed ${(%):-%N} $*
sha384sum   () centos-fixed ${(%):-%N} $* 
# Brew/coreutils is faster than fedora/docker which is faster than alpine/docker
#md5sum      () fedora ${(%):-%N} $*

# Native tar is faster than Brew/coreutils tar which is faster than all docker
#gtar        () ubuntu tar $*

# Supplied by brew coreutils
# so each can be defined via:
#shaNsum      () ${(%):-g%N} $*

# fedora/docker is faster than native which is faster than alpine/docker
# But these are the OS versions (shasum is actually perl)

#sha1sum     () shasum -a ${${${(%):-%N}#sha}%sum} $*
#sha224sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
#sha256sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
#sha384sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
#sha512sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*

# Supplied by brew coreutils
md5sum      () ${(%):-g%N} $*
vdir        () ${(%):-g%N} $*
# Supplied by brew (homebrew/dupes) grep
# Nothing to do for ggrep
# Supplied by brew gnu-tar
# Nothing to do for gtar 

# Supplied by nmap dmg
#nmap        () di uzyexe/nmap $*
#irssi       () di -e TERM -u $(id -u):$(id -g) -v /Users/ndoye/.irssi:/home/user/.irssi:ro ${(%):-%N}

# Not used too much yet.
che         () di -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/che:/data eclipse/che start
# Specific terraform version for alf
terraform-0-9-11    () di hashicorp/terraform:0.9.11 $*
terraform-latest    () di hashicorp/terraform:latest $*
packer-latest       () {
    local packer_root='/opt/'
    di -v $PWD:${packer_root} hashicorp/packer:light $(echo $* | sed -E "s_([[:alnum:]_-]*.json)_${packer_root}\1_")
}
