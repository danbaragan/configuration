#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

[ -f ~/.bashperlrc ] && . ~/.bashperlrc
export GOPATH=$HOME/gobin
COMMON_PATH=${HOME}/bin:${HOME}/.npm-global/bin:

