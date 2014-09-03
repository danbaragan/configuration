# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

if [ -f ~/.bash-ack_functions ]; then
	ACK_VERSION=1
	if ack --version|grep -q 'ack 2\.'; then
	   ACK_VERSION=2
	fi
	export ACK_VERSION

	. ~/.bash-ack_functions
fi

. /usr/share/git-core/contrib/completion/git-prompt.sh
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
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w $(__git_prompt_color)$(__git_ps1 "(%s)")\[\033[01;34m\]\n=== \$\[\033[00m\] '

# some more ls aliases
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias l='ls -1 --color=auto'
alias df='df -Th'
alias p='ps -eLf'

export TERM=xterm
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"
export LC_COLLATE=C
eval `dircolors -b ~/.dir_colors`
