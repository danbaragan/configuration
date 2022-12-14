# ~/.bash_profie: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# common settings for login and non-login shell
if [ -f ~/.bash-common.sh ]; then
    . ~/.bash-common.sh
    export PATH=${PATH_COMMON}:${PATH}
fi

#export CFLAGS="-I$(xcrun --show-sdk-path)/usr/include"

if [ -n `which pyenv` ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    [ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh
    # pyenv virtualenvwrapper
fi

[ -f ~/.git-completion.sh ] && . ~/.git-completion.sh

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
#[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

[ -f ~/.bash-local-settings ] && . ~/.bash-local-settings
