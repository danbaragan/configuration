#!/bin/bash
# bash settings common between .bash_profile and .bashrc (both needed on mac)

[ -f ~/.git-prompt.sh ] && . ~/.git-prompt.sh
[ -f ~/.git-completion.sh ] && . ~/.git-completion.sh
[ -f ~/.bashperlrc ] && . ~/.bashperlrc

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

export NODE_PATH=${HOME}/.npm-global/lib/node_modules:/usr/local/lib/node_modules
export GOPATH=$HOME/gobin
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH_COMMON=${HOME}/bin:${HOME}/.npm-global/bin:${GOPATH}/bin:$HOME/.cargo/bin
