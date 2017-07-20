# vim: set filetype=sh :
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
top         () htop
vim         () nvim $*
pstree      () { 
    local pstree=$(whence -p pstree | head -1)
    if [[ -n ${pstree} ]]
    then
        ${pstree} -g2 -w $*
    else
        return 1
    fi
}


print_sep   ()
{
    printf "---- $*\t------------------------------------------------------\n"
}

bum         () 
{ 
    print_sep "starting upgrades"
    brew_u      () 
    { 
        print_sep "brew upgrade"
        brew upgrade 
    }

    gcloud_u    ()
    {
        print_sep "gcloud update"
        gcloud components update --quiet
    }

    firebase_u  ()
    {
        print_sep "firebase update"
        npm install -g firebase-tools
    }

    mas_u       ()
    {
        print_sep "mas upgrade"
        mas upgrade
    }

    antibody_u  ()
    {
        print_sep "antibody update"
        antibody update
    }

    npm_u       ()
    {
        print_sep "npm upgrade"
        npm install -g npm
    }

    brew_cast_u ()
    {
        print_sep "brew cask list"
        brew cask outdated
        #brew cask reinstall $(brew cask outdated | awk '{print $1}')
    }

    brew_u
    mas_u
    npm_u
    antibody_u
    gcloud_u
    firebase_u

    print_sep "all finished"
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

#ssh         () assh wrapper ssh $*

gitlab      () cd ${HOME}/vcs/gitlab.alfresco.com

hopoff      () ssh hopoff.alfresco.me $*
c6          () ssh ndcentos6vm $*
c7          () ssh ndcentos7vm $*
nd          () c7 $*
13          () ssh pbld13 $*

githost     () ssh git-host-002.orionwt.co.uk $*
bastion     () ssh bastion.it.orionwt.co.uk $*
bellatrix   () ssh bellatrix.orionwt.co.uk $*
test4       () ssh test4.orionwt.co.uk $*

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

centos      () _di_all ${(%):-%N} $*
fedora      () _di_all ${(%):-%N} $*
ubuntu      () _di_all ${(%):-%N} $* 
debian      () _di_all ${(%):-%N} $* 
alpine      () _di_all ${(%):-%N} $*

# Actual commands
#aws         () di --volume ~/.aws:/root/.aws cgswong/aws:latest aws $*
#curl        () fedora ${(%):-%N} $*
#ggrep       () fedora grep $*
#sha1sum     () fedora ${(%):-%N} $*
#sha224sum   () fedora ${(%):-%N} $*
#sha256sum   () fedora ${(%):-%N} $* 
#sha384sum   () fedora ${(%):-%N} $* 
#sha512sum   () fedora ${(%):-%N} $* 
#md5sum      () fedora ${(%):-%N} $*
#gtar        () ubuntu tar $*

# Supplied by brew coreutils
# so each can be defined via:
#shaNsum      () ${(%):-g%N} $*
# But these are the OS versions (shasum is actually perl)
sha1sum     () shasum -a ${${${(%):-%N}#sha}%sum} $*
sha224sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
sha256sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
sha384sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
sha512sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
sha512sum   () shasum -a ${${${(%):-%N}#sha}%sum} $*
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
