# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f ~/.bash-common.sh ]; then
    . ~/.bash-common.sh
    export PATH=${PATH_COMMON}:/usr/local/bin:${PATH}
else
    export PATH=/usr/local/bin:${PATH}
fi

[ -f ~/.git-completion.sh ] && . ~/.git-completion.sh
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
[ -f ~/.bash-local-settings ] && . ~/.bash-local-settings

eval `dircolors -b ~/.dir_colors`

