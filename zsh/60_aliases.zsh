#!/bin/zsh

if type glances &>> /dev/null; then
    alias   top=glances
fi

if type nvim &>> /dev/null; then
    alias       vim=nvim
fi


# Aliases allow for command line completion, unlike functions
alias       k=kubectl

alias       github="cd ${HOME}/vcs/github.com"
alias       psa='pkill ssh-agent'
alias       setmyokta.sh='setmyokta-nic.sh'

# setmyokta -p wrapper
o () {
    local profile="$1"
    local current_java=$(sdk c java | /usr/bin/awk '{print $4}' | egrep '[[:alnum:]]')
    local working_java='8.0.252.hs-adpt'
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
    local github_user
    local github_project
    local github_gh_url
    local github_user_dir

    local repo_root="${HOME}/vcs/github.com"
    local num_slash=$(awk -F/ '{print NF-1}' <<<"$github_url")

    if [ "$num_slash" = "1" ]; then
        github_user=$(echo $github_url    | cut -f1 -d/)
        github_project=$(echo $github_url | cut -f2 -d/)
        github_gh_url="$github_url"
    else
        local github_user_project
        github_user_project=$(echo $github_url        | cut -f2 -d:)
        github_user=$(echo $github_user_project       | cut -f1 -d/)
        github_project=$(echo $github_user_project    | cut -f2 -d/ | sed -e 's_.git$__' )
        github_gh_url="${github_user}/${github_project}"
    fi

    github_user_dir="${repo_root}/${github_user}"

    mkdir -p "${github_user_dir}" && \
        cd "${github_user_dir}" && \
        gh repo clone "${github_gh_url}" && \
        cd "${github_project}"
}

get::java_version   () {
    sdk current java | grep ^'[[:alnum:]]' | /usr/bin/awk '{print $4}'
}

setmyokta   () {
    sdk use java '8.0.252.hs-adpt'
    cd "${HOME}/.aws"
    setmyokta.sh $*
    cd "${OLDPWD}"
}


# This is only for commands, not functions or aliases
find_cmd    () { whence -p $1 || echo false ; }

pstree      () $(find_cmd pstree) -g2 -w $*

print_sep   () {
    printf -- "---- $*\t------------------------------------------------------\n"
}

print::n    () {
    for i in {1..$1}; echo -n "$2"
    echo
}

bi          () brew info 	$*
bin         () brew install $*
bh          () brew home 	$*

lx          () exa  --long --group-directories-first --group --git $*

youtube-flac () youtube-dl -x --audio-format flac --audio-quality 9 $*

flac2alac	() {
	for file in $*
	do
		ffmpeg -i "${file}" -vn -c:a alac "${file%.flac}.m4a" # cover.jpg
	done
}

# https://gist.github.com/nicdoye/62a2000972ee347123f079b70e994bc2

__nic::grep       ()
{
    local grep_type=$1
    local str=$2

    # ripgrep overrides ggrep and grep
    if type rg &>> /dev/null; then
        if [[ ${grep_type} == '-H' ]]
        then
            rg -N -p --no-heading ${str}
        else
            # Assume -l.
            rg -l ${str}
        fi
        return $?
    fi

    find . -type f -not -path '*/.git/*' -exec grep ${grep_type} ${str} {} \;
}

lgrep       () __nic::grep -l $*
Hgrep       () __nic::grep -H $*

#tiff2png    () {
    #local ifile=$1
    #local ofile=$(dirname "${ifile}")/$(basename "${ifile}" .tiff).png
    #tifftopnm < "${ifile}"| pnmtopng > "${ofile}"
#}

# Running commands in docker
# $1 is the image
di          () docker run --rm -it $*

# Supplied by brew coreutils
md5sum      () ${(%):-g%N} $*
vdir        () ${(%):-g%N} $*

switch::cis () {
    # mode is either enable or disable
    local mode=$1
    local top_level repo old_bool new_bool

    if ! git status &>> /dev/null; then
        echo 'Not in a git repo' > /dev/stderr
        return 1
    fi

    case "$mode" in
        'enable')
            old_bool='false'
            new_bool='true'
            ;;
        'disable')
            old_bool='true'
            new_bool='false'
            ;;
        *)
            echo "Invalid first argumenet '$mode' passed. Should be one of 'enable' or 'disable'" > /dev/stderr
            return 1
            ;;
    esac

    top_level="$(git rev-parse --show-toplevel)"
    repo="$(basename ${top_level})"

    if [ "${repo}" = 'paas-base-ami' ]; then
        local config_file
        for config_file in \
            "${top_level}/playbooks/environments/acs/all.yaml" \
            "${top_level}/playbooks/environments/ldap/all.yaml" \
            "${top_level}/playbooks/environments/acs/acs-all.yaml" \
            "${top_level}/playbooks/environments/ldap/ldap-all.yaml" ; do

            if [ -e "$config_file" ]; then
                if [[ "$OSTYPE" == "linux-gnu" ]]; then
                    sed -i -e "s/cis_enabled: ${old_bool}/cis_enabled: ${new_bool}/" "${config_file}"
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' -e "s/cis_enabled: ${old_bool}/cis_enabled: ${new_bool}/" "${config_file}"
                fi
            fi
        done
    fi
}

alias   disable_cis="switch::cis disable"
alias   enable_cis="switch::cis enable"
alias   cis="switch::cis"

ga          () {
    enable_cis
    git add .
    disable_cis
}

gc          () {
    enable_cis
    git commit -a -m "$*"
    disable_cis
}

# git merge upstream
gmu         () {
    local upstream="$1"
    if [ -z "$upstream" ]; then
        echo 'upstream branch not set' > /dev/stderr
        return
    fi

    # Requires git 2.22.0+ which we don't have on CentOS
    # git branch --show-current
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ -z "$current_branch" ]; then
        echo 'current_branch not set' > /dev/stderr
        return
    fi

    git checkout "${upstream}" || return
    git pull || return
    git checkout ${current_branch} || return
    git merge "${upstream}"
}

alias       gmd="gmu develop"
alias       gm7="gmu acs-v7"

# git checkout and pull
gcp         () {
    local upstream="$1"
    if [ -z "$upstream" ]; then
        echo 'upstream branch not set' > /dev/stderr
        return
    fi

    git checkout "${upstream}" || return
    git pull || return
}

alias       asl="aws sso login"
alias       asla="asl; plx; pls; plc"
alias       aslc="asl; plc"

alias       gdp="gcp develop"
alias       g7p="gcp acs-v7"
gpu         () { enable_cis; git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD) ; disable_cis; }
alias       gcb="git checkout -b"
alias       gp="git pull"
alias       gs="git status"
alias       gdh="git diff head"
alias       gdd="git diff develop"

alias       taa="terragrunt run-all apply"
alias       tda="terragrunt run-all destroy"
alias       tdai="tda --terragrunt-ignore-dependency-errors"
alias       rtaa="taa --terragrunt-source-update"
alias       traa=rtaa
alias       taay="taa --terragrunt-non-interactive -auto-approve -input=false"
alias       tday="tda --terragrunt-non-interactive -auto-approve -input=false"


alias       dssh="aws2-wrap --profile $paas_dev_customers ssh"

sac         () { ssh -A centos@$1 ; }

ssh         () {
    echo -e "\033]50;SetProfile=PaaS Full Client\a"
    /usr/bin/ssh "$@"
    echo -e "\033]50;SetProfile=Tomorrow Night Bright\a"
}

typeset -g alf_repo="${HOME}/vcs/github.com/Alfresco"
typeset -g pba_scripts="${alf_repo}/paas-base-ami/src/main/scripts"

if [ -d "$alf_repo" ]; then
    alias       alf="cd ${alf_repo}"

    paas-local  () {
        local _old_dir="${PWD}"
        cd ${alf_repo}/paas-control-plane/utils
        aws2-wrap --profile default ./paas-local.sh $1
        cd "${_old_dir}"
    }

    alias       pls="paas-local start"
    #alias       plc="paas-local connect"

    plc         () {
        echo -e "\033]50;SetProfile=PaaS Full Client\a"
        paas-local connect
        echo -e "\033]50;SetProfile=Tomorrow Night Bright\a"
    }
    
    plx         () {
        paas-local stop
        if [ "${PAAS_IMAGE_MANAGER_COMMAND}" = 'finch' ]; then
            ${PAAS_IMAGE_MANAGER_COMMAND} rm paas
        fi
    }

    if [ -d "${pba_scripts}" ]; then
        for _file in ${pba_scripts}/build-*.sh; do
            local short_name=$(basename -s .sh "$_file")
            local script_name=$(basename "$_file")

            "$short_name" () {
                local _old_dir="${PWD}"

                cd "${pba_scripts}"
                "./${funcstack[1]}.sh"
                cd "${_old_dir}"
            }
        done
        unset _file
    fi

    _alias::factory () {
        alias "$1"="cd ${alf_repo}/$1"
    }

    for _repo in \
        $(find $alf_repo -mindepth 1 -maxdepth 1 -type d -exec basename {} \;); do
        _alias::factory "$_repo"
    done
    unset _repo

    alias pba=paas-base-ami
    alias pcp=paas-control-plane
    alias pdbi=paas-docker-build-images
    alias ptm=paas-terraform-modules
    alias pt=paas-tool
    alias pbas="cd ${pba_scripts}"
    alias sbs="cd ${src/main/scripts}"
fi

aws-migrate-repo    () {
    local oldrepo=$(git remote -v | head -1 | awk '{print $2}')
    local region=$(echo ${oldrepo} | cut -f2 -d.)
    local reponame=$(basename ${oldrepo})
    local newrepo="codecommit::${region}://${reponame}"

    git remote remove origin
    git remote add origin $newrepo
    git fetch
    git branch --set-upstream-to=origin/develop develop
}

reset-lastpass      () {
    pkill -9 LastPass
    pkill -9 LastPassSafari
}

docker::clean::all  () {
    for i in $(docker images --format '{{ .Repository }}:{{ .Tag }}' | sort -u); do
        docker rmi $i
    done
    docker system prune --all --force
}


update::ami         () {
    local ami_id=$1
    local marker='__REPO_AMI_USE2__'

    # update marker with new AMI Id
    echo "Updating Marker ${marker} with ${ami_id}"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if ! find alfresco -maxdepth 1 -name "module.tfvars" \
            -exec sed -i -e "s~\(\/\*${marker}\*\/[[:space:]]\{0,1\}\"\).*\(\"[[:space:]]\{0,1\}\/\*${marker}\*\/\)~\1${ami_id}\2~g" {} \; ; then
            echo "[ERROR] Failed to update module.tfvars AMI Ids"
            return 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then    # Mac OSX
        if ! find alfresco -maxdepth 1 -name "module.tfvars" \
            -exec sed -i '' -e "s~\(\/\*${marker}\*\/[[:space:]]\{0,1\}\"\).*\(\"[[:space:]]\{0,1\}\/\*${marker}\*\/\)~\1${ami_id}\2~g" {} \; ; then
            echo "[ERROR] Failed to update module.tfvars AMI Ids"
            return 1
        fi
    fi
}

delete::secrets     () {
    local prefix=$1
    if [ ${#prefix} -lt 12 ]; then
        echo "[ERROR] Woah - not doing that prefix must be at least 12 chars"
        return 1
    fi

    for secret in $(aws secretsmanager list-secrets --region "$paas_dev_region" --profile "$paas_dev_customers" | jq -r '.SecretList[].Name' | grep -- ^"$prefix"); do
        aws secretsmanager delete-secret \
            --secret-id "$secret" \
            --region "$paas_dev_region" \
            --profile "$paas_dev_customers"
    done
}

delete::asg         () {
    local asg=$1
    aws autoscaling delete-auto-scaling-group \
        --auto-scaling-group-name "$asg" \
        --region "$paas_dev_region" \
        --profile "$paas_dev_customers"
}

terminate::instances    () {
    local name=$1
    local instance_ids id
    if [ ${#name} -lt 12 ]; then
        echo "[ERROR] Woah - not doing that name must be at least 12 chars"
        return 1
    fi

    echo aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" --region $paas_dev_region --profile $paas_dev_customers | jq -r '.Reservations[].Instances[].InstanceId'
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" --region $paas_dev_region --profile $paas_dev_customers | jq -r '.Reservations[].Instances[].InstanceId'

    instance_ids=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" --region $paas_dev_region --profile $paas_dev_customers | jq -r '.Reservations[].Instances[].InstanceId'))

    if [ -z "$instance_ids" ]; then
        echo "[WARN] No instances found"
        echo $instance_ids
    else
        for id in "${instance_ids[@]}"; do
            echo aws ec2 terminate-instances \
                --instance-ids=$id \
                --region $paas_dev_region \
                --profile $paas_dev_customers
        done
    fi
}

unset::aws          () {
    local env
    for env in $(env | grep '^AWS' | cut -f1 -d=); do
        unset "$env"
    done
}

reset::iterm        () {
    echo -e "\033]50;SetProfile=Tomorrow Night Bright\a"
}

