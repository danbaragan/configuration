alias df='df -h'
alias p='ps -eLf'
alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias docklog="docker inspect --format='{{.LogPath}}'"
alias dockvoldang="docker volume ls -f dangling=true"
alias dockimgdang="docker images -f dangling=true"
alias sha256sum="shasum -a256"
alias sha1sum="shasum"
alias tiga="tig --author=Bărăgan"
