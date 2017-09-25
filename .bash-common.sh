#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

[ -f ~/.bashperlrc ] && . ~/.bashperlrc
export NODE_PATH=${HOME}/.npm-global/lib/node_modules:/usr/local/lib/node_modules
export GOPATH=$HOME/go
PATH_COMMON=${HOME}/bin:${HOME}/.npm-global/bin:${GOPATH}/bin

