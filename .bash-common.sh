#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

# somehow we need this for non-login shells too
[ -f ~/.git-prompt.sh ] && . ~/.git-prompt.sh
[ -f ~/.bashperlrc ] && . ~/.bashperlrc

#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export NODE_PATH=${HOME}/.npm-global/lib/node_modules:/usr/local/lib/node_modules
export GOPATH=$HOME/go

export NVM_DIR="$HOME/.nvm"

PATH_COMMON=${HOME}/bin:${HOME}/.npm-global/bin:${GOPATH}/bin:$HOME/.cargo/bin
