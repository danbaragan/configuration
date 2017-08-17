alias df='df -Th'
alias p='ps -eLf'
alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias docklog="docker inspect --format='{{.LogPath}}'"
alias dockvoldang="docker volume ls -f dangling=true"
alias dockimgdang="docker images -f dangling=true"
