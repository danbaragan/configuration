# ~/.bash_profie: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    *color*) color_prompt=yes;;
esac

White="[m[K"
Red="[0;31m[K"
Green="[0;32m[K"
Yellow="[0;33mK"
Blue="[0;34mK"
__git_prompt_color() {
	git_status=$(git status 2>&1)
	if echo $git_status|grep -q -e"Not a git repository"; then
		echo "$White"
	elif echo $git_status|grep -q -i -e"Changes to be committed:" -e"Changes not staged for commit:" -e"Unmerged paths:" -e"untracked"; then
		echo "$Red"
    elif echo $git_status|grep -q -e"Your branch \(and\|is ahead\|is behind\)"; then
		echo "$Yellow"
	else
		echo "$Blue"
	fi
}
[ -f ~/.git-prompt.sh ] && . ~/.git-prompt.sh
[ -f ~/.git-completion.sh ] && . ~/.git-completion.sh
if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w $(__git_prompt_color)$(__git_ps1 "(%s)")\[\033[01;34m\]\n--- \$\[\033[00m\] '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 "(%s)")\n---\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


alias grep='grep --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -1'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f ~/.bash-ack_functions ] && . ~/.bash-ack_functions

export ARCHFLAGS="-arch x86_64"
export PIP_REQUIRE_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs
[ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh

gpip() {
    PIP_REQUIRE_VIRTUALENV='' pip "$@"
}

gpip3() {
    PIP_REQUIRE_VIRTUALENV='' pip3 "$@"
}


export LC_COLLATE=C
export LC_NUMERIC="en_US.UTF-8"
export TERM=xterm-256color

export CLICOLOR=1
export LSCOLORS=ExGxFxDxCxgxdxabafacae

# system vim; not brew...
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

PS4='(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]} - [${SHLVL},${BASH_SUBSHELL}, $?]
'

if [ -f ~/.bash-common.sh ]; then
    . ~/.bash-common.sh
    export PATH=${HOME}/bin:${HOME}/.npm-global/bin:$GOPATH:${PATH}
fi

[ -f ~/.bashLocalSettings ] && . ~/.bashLocalSettings
