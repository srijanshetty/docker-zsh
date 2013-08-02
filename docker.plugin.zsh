_docker_get_all_containers () {
    docker_containers=$(docker ps -a | awk '{print $1}') 
}

_docker_get_images() {
    docker_images=$(docker images | awk 'NR>1{print $1}')
}

_docker ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)
            local -a subcommands
            subcommands=(
                'attach:Attach to a running container'
                'build:Build a container from a Dockerfile'
                'commit:Create a new image from a container changes'
                'diff:Inspect changes on a container filesystem'
                'export:Stream the contents of a container as a tar archive'
                'history:Show the history of an image'
                'images:List images'
                'import:Create a new filesystem image from the contents of a tarball'
                'info:Display system-wide information'
                'insert:Insert a file in an image'
                'inspect:Return low-level information on a container'
                'kill:Kill a running container'
                'login:Register or Login to the docker registry server'
                'logs:Fetch the logs of a container'
                'port:Lookup the public-facing port which is NAT-ed to PRIVATE_PORT'
                'top:Lookup the running processes of a container'
                'ps:List containers'
                'pull:Pull an image or a repository from the docker registry server'
                'push:Push an image or a repository to the docker registry server'
                'restart:Restart a running container'
                'rm:Remove one or more containers'
                'rmi:Remove one or more images'
                'run:Run a command in a new container'
                'search:Search for an image in the docker index'
                'start:Start a stopped container'
                'stop:Stop a running container'
                'tag:Tag an image into a repository'
                'version:Show the docker version information'
                'wait:Block until a container stops, then print its exit code'
            )
            _describe -t commands 'docker' subcommands
        ;;
        (options)
            case $line[1] in
                (attach|diff|export|inspect|kill|logs|port|top|restart|rm|run|start|stop|wait)
                    __docker_containers
                ;;
                (commit)
                    __docker_containers_images
                ;;
                (images)
                    __docker_images
                ;;
            esac
        ;;
    esac
}

__docker_containers_images ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options' && return 0
    if ((CURRENT == 3)); then
        return
    fi

    case $state in
        (command)
            _docker_get_all_containers
            compadd "$@" $(echo $docker_containers)
        ;;
        (options)
            _docker_get_images
            compadd "$@" $(echo $docker_images)
        ;;
        *)
            return
        ;;
    esac
}

__docker_containers ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command'

    case $state in
        (command)
            _docker_get_all_containers
            compadd "$@" $(echo $docker_containers)
        ;;
    esac
}

__docker_images ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command'

    case $state in
        (command)
            _docker_get_images
            compadd "$@" $(echo $docker_images)
        ;;
    esac
}

compdef _docker docker

alias dat='docker attach'
alias dbu='docker build'
alias dco='docker commit'
alias ddi='docker diff'
alias dde='docker export'
alias dhi='docker history'
alias dim='docker images'
alias dimp='docker import'
alias din='docker info'
alias dins='docker insert'
alias dinsp='docker inspect'
alias dk='docker kill'
alias dlogin='docker login'
alias dlogs='docker logs'
alias dport='docker port'
alias dtop='docker top'
alias dps='docker ps'
alias dpull='docker pull'
alias dpush='docker push'
alias dre='docker restart'
alias drm='docker rm'
alias drmi='docker rmi'
alias drun='docker run'
alias dse='docker search'
alias dstart='docker start'
alias dstop='docker stop'
alias dtag='docker tag'
alias dversion='docker version'
alias dwait='docker wait'