#!/bin/zsh

# vim: set filetype=sh :

########################################################################
# Remember one-liners containing || etc., need to be enclosed by {}
########################################################################

# Hack around vimpager being too clever. Use a pre-generated
# vimpager config. 

#__nic_pager () { vim -u ~/.dotfiles/vimpager/vimpager.vim $* ; }
# alias __nic_pager=vim -u ~/.dotfiles/vimpager/vimpager.vim
# export PAGER=__nic_pager

#less        () __nic_pager $*
#zless       () __nic_pager $*
#bzless      () __nic_pager $*
#lzless      () __nic_pager $*
#xzless      () __nic_pager $*
#more        () __nic_pager $*
#zmore       () __nic_pager $*
#bzmore      () __nic_pager $*
#lzmore      () __nic_pager $*
#xzmore      () __nic_pager $*
top         () glances
alias       vim=nvim
# Aliases allow for command line completion, unlike functions
alias       a=aws
alias       b=brew
alias       c=curl
alias       d=docker
alias       g=git
alias       h=helm
alias       i=istioctl
alias       k=kubectl

alias       github="cd ${HOME}/vcs/github.com"
alias       alf="cd ${HOME}/vcs/github.com/Alfresco"
alias       psa='pkill ssh-agent'
alias       setmyokta.sh='setmyokta-nic.sh'

alias       aws=aws2

# setmyokta -p wrapper
o () {
    local profile="$1"
    local current_java=$(sdk c java | /usr/bin/awk '{print $4}' | egrep '[[:alnum:]]')
    local working_java='8.0.202-amzn'
    sdk u java "${working_java}"

    setmyokta.sh -p "${profile}"
    sdk u java "${current_java}"
}

_kube_config () {
    export KUBECONFIG="$1"
    alias kubectl=kubectl-"$2"
    alias helm="helm-$3"
    [ -n "$4" ] && {
        kubens "$4"
        helm="helm-$3 --tiller-namespace $4"
    }
}

# See assoc array in secrets
_aws_profile () {
    source "${HOME}/.secrets/k8s.zsh"
    local profile="${k8s_to_aws_profile[$1]}"
    aws sts get-caller-identity --output text --profile "${profile}" &>> /dev/null
    [ $? != 0 ] && echo "Now run: o ${profile}"
}

# _ibm_kube_config 'lon04' 'nic-ibm-cluster-004'
#_ibm_kube_config () {
#    local datacentre="$1"
#    local cluster="$2"
#    _kube_config "${HOME}/.bluemix/plugins/container-service/clusters/${cluster}/kube-config-${datacentre}-${cluster}.yml" 1.10.4 2.9.1
#}

kc () {
    case "$1" in
        'docker-for-desktop' )
            _kube_config "${HOME}/.kube/desktop/docker-for-desktop.yaml" 1.10.3 2.9.1 nic
            export HELM_HOME=~/.helm
            ;;
        'minikube' )
            _kube_config "${HOME}/.kube/desktop/minikube.yaml" 1.10.3 2.9.1 nic
            export HELM_HOME=~/.helm
            ;;
        'ps' )
            # _aws_profile "$1"
            _kube_config "${HOME}/.kube/alfresco/ps.yaml" 1.9.7 2.8.2 nic
            alias helm="helm-2.8.2 --tls --tiller-namespace nic"
            export HELM_HOME=~/.helm
            ;;
        'insight' )
            # _aws_profile "$1"
            _kube_config "${HOME}/.kube/alfresco/insight-calico.yaml" 1.10.5 2.10.0-rc3 insight
            export TILLER_NAMESPACE='insight'
            export HELM_HOME="${HOME}/.helm/alfresco/insight-calico/insight"
            alias helm="helm-2.10.0-rc3 --tls --tiller-namespace ${TILLER_NAMESPACE}"
            ;;
        'eks-ps' )
            # _aws_profile "$1"
            _kube_config "${HOME}/.kube/alfresco/eks-ps.yaml" 1.10.4 2.9.1 default
            export HELM_HOME=~/.helm
            #export TILLER_NAMESPACE=insight
            #export HELM_HOME=~/.helm/alfresco/1.10-calico/insight/
            #alias helm="helm-2.9.1 --tls --tiller-namespace insight"
            ;;
        'deploy-363-15' )
            export HELM_HOME=~/.helm
            export AWS_PROFILE=engineering-ndoye
            export AWS_REGION=us-east-1
            _kube_config "${HOME}/.kube/alfresco/deploy-363-15.yaml" 1.10.3 2.9.1 nic
            ;;
        * )
            _kube_config "${HOME}/.kube/config" 1.10.4 2.9.1 default
            ;;
    esac
}

#alias nic-ibm-cluster-004='kc ibm'

# Clone github and cd into it.
# Could be made more generic.
ghc         () {
    local github_url=$1
    local repo_root="${HOME}/vcs/github.com"

    local github_user_project=$(echo "${github_url}"    | cut -f2 -d:)
    local github_user=$(echo "${github_user_project}"   | cut -f1 -d/)
    local github_project=$(echo $github_user_project    | cut -f2 -d/ | sed -e 's_.git$__' )
    local github_user_dir="${repo_root}/${github_user}"

    mkdir -p "${github_user_dir}" && \
        cd "${github_user_dir}" && \
        git clone "${github_url}" && \
        cd "${github_project}"
}

_java_version   () { 
    sdk current java | grep ^'[[:alnum:]]' | /usr/bin/awk '{print $4}' 
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
#l           () $(find_cmd m) lock

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

packer-latest       () {
    local packer_root='/opt/'
    di -v $PWD:${packer_root} hashicorp/packer:light $(echo $* | sed -E "s_([[:alnum:]_-]*.json)_${packer_root}\1_")
}

# From Alex
getSecret() {
    opt=SecretString
    while getopts :b: o
    do  case "$o" in
        b) opt=SecretBinary
            shift
            ;;
        [?]) echo >&2 "Usage: $0 [-b]  secret.id"
        esac
    done
    aws secretsmanager get-secret-value --secret-id $1 --region us-east-1 |jq -r .${opt}
}

createSecret() {
aws secretsmanager create-secret --name "${1}" --kms-key-id d18dee8e-6c25-4771-85e9-55c96f5f80c3 --secret-string "${2}" --region us-east-1
}

gdp         () { git checkout develop && git pull; }
gpu         () { git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD) ; }
alias       gcb="git checkout -b"
alias       gp="git pull"
alias       ga="git add ."
alias       gc="git commit -a -m"
alias       gs="git status"

alias       taa="terragrunt apply-all"
alias       tda="terragrunt destroy-all"
