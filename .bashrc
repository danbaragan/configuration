# ~/.bashrc: executed by bash(1) for non-login shells.

if [ -f ~/.bash-common.sh ]; then
    . ~/.bash-common.sh
    export PATH=${PATH_COMMON}:/usr/local/bin:${PATH}
else
    export PATH=/usr/local/bin:${PATH}
fi
