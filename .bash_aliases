alias grep='grep --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -1'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#docker
alias dockvoldang="docker volume ls -f dangling=true"
alias dockimgdang="docker images -f dangling=true"

alias df='df -h'
alias p='ps -eLf'
alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias docklog="docker inspect --format='{{.LogPath}}'"
alias dockvoldang="docker volume ls -f dangling=true"
alias dockimgdang="docker images -f dangling=true"
alias sha256sum="shasum -a256"
alias sha1sum="shasum"
alias tiga="tig --author=Bărăgan"
alias dc="docker compose"
alias ls1="CLICOLOR_FORCE=1 ls -la|grep --color=never  ' 1 $USER'"
alias black='black --skip-string-normalization'
