#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

[ -f ~/.git-prompt.sh ] && . ~/.git-prompt.sh
[ -f ~/.git-completion.sh ] && . ~/.git-completion.sh
[ -f ~/.bashperlrc ] && . ~/.bashperlrc
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export NODE_PATH=${HOME}/.npm-global/lib/node_modules:/usr/local/lib/node_modules
export GOPATH=$HOME/go
PATH_COMMON=${HOME}/bin:${HOME}/.npm-global/bin:${GOPATH}/bin:$HOME/.cargo/bin

