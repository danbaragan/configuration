#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

[ -f ~/.bashperlrc ] && . ~/.bashperlrc
export NODE_PATH=${HOME}/.npm-global/lib/node_modules:/usr/local/lib/node_modules
export GOPATH=$HOME/gobin
COMMON_PATH=${HOME}/bin:${HOME}/.npm-global/bin:

export PATH=${COMMON_PATH}:${PATH}

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

