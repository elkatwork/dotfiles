# this file is sourced by all bash shells on startup

# load rvm even if not interactive
if [[ -r "${HOME}/.rvm/scripts/rvm" ]]; then
	source "${HOME}/.rvm/scripts/rvm"
fi

# everything else is for interactive shells only
[[ $- != *i* ]] && return

_BASHRC_DIR="${_BASHRC_DIR:-/home/thi/.bash}"

# make sure all important paths are in PATH
export PATH="${PATH}:~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

source "${_BASHRC_DIR}/detect.sh"
source "${_BASHRC_DIR}/bashcomp.sh"
source "${_BASHRC_DIR}/color.sh"
source "${_BASHRC_DIR}/prompt.sh"

if [[ -r "${_BASHRC_DIR}/${_DISTNAME}.sh" ]]; then
	source "${_BASHRC_DIR}/${_DISTNAME}.sh"
fi


#######################
## setup environment ##
#######################

# find a usable locale
eval unset ${!LC_*} LANG
export LANG="en_US.UTF-8"
export LC_COLLATE="C"

# force a sane editor
export EDITOR=vim

# pager options
if hash less; then
	export PAGER=less
	export MANPAGER=less
	export LESS="-R --ignore-case --long-prompt"
fi

# keychain for ssh
if [[ $USER != root ]]; then
	if hash keychain; then
		if [[ -r ~/.ssh/id_dsa ]]; then
			eval `keychain --eval --quiet ~/.ssh/id_dsa`
		fi
		if [[ -r ~/.ssh/id_rsa ]]; then
			eval `keychain --eval --quiet ~/.ssh/id_rsa`
		fi
	fi
fi


########################
## bash configuration ##
########################

# keep size of history small ...
export HISTCONTROL="ignoreboth:erasedups"

# ... but keep a lot of history
export HISTFILESIZE=5000
export HISTSIZE=5000

# save timestamp in history
export HISTTIMEFORMAT="%Y-%m-%d [%T] "

# check window size after each command
shopt -s checkwinsize

# save multi-line command as one line
shopt -s cmdhist

# append history
shopt -s histappend

# enable recursive globbing
shopt -s globstar

# PgUp PgDn Hack
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

# stty - turn off that @!#$&!@# ctrl-s/q sheel-freeze-stuff
stty -ixon -ixoff

# Ctrl-Q does a Ctrl-W w/ slashes
bind -r "\C-q"
bind '"\C-q": unix-filename-rubout'



#####################
## command aliases ##
#####################

# ls helpers
alias l="ls -lh"
alias la="ls -la"
alias lt="ls -lrt"

# cd helpers
# dirty hack since you cannot define a function called '..'
dotdot() {
	local cdpath=""
	local num=${1:-1}

	while [[ ${num} -gt 0 ]]; do
		cdpath="${cdpath}../"
		num=$((num - 1))
	done

	cdpath="${cdpath}${2}"
	cd ${cdpath}
}

alias ..="dotdot 1"
alias ...="dotdot 2"
alias ....="dotdot 3"

# mkdir + chdir
mkcd() {
	mkdir -p "$1" && cd "$1"
}

# make default what should be default
alias sudo="sudo -H"
alias root="sudo -i"

# ssh helper
alias sshlive='ssh -l root -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -o "GlobalKnownHostsFile /dev/null"'

# chef helper
alias kcu="knife cookbook upload"

# ruby/rvm helpers
alias be="bundle exec"

# easy port listing
alias ports="netstat -tulpen"

# pydf has nicer output
if hash pydf &>/dev/null; then
	alias df=pydf
fi

# diff helper
cdu() {
	colordiff -u "$@" | less
}

sl() {
	sort -u | less
}

# tmux helper
T() {
	tmux attach -t ${1:-default} || tmux new -s ${1:-default}
}

# simple webserver
serve() {
	python -m SimpleHTTPServer ${1:-8080}
}

# Igor's sanity helper:
alias vi="vim"

# unset RUBYOPT here for rvm compat
unset RUBYOPT

# load local bashrc if it exists
if [[ -e ${HOME}/.bashrc.local ]]; then
	source ${HOME}/.bashrc.local
fi

# cleanup
unset _BASHRC_DIR
