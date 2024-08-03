#!/bin/bash

HISTCONTROL=ignoreboth
HISTIGNORE="cd *:exit*"
HISTTIMEFORMAT="%D-%T# "
HISTSIZE=1000
HISTFILESIZE=2000

if [ -x /usr/bin/fzf ]; then
	__fzf_hist() {
		local LINE="${READLINE_LINE}"
		local RESULT="$(builtin history | fzf -e -n 3.. -q "${LINE}")"
		READLINE_LINE="${RESULT#*# }"
		READLINE_POINT=${#READLINE_LINE}
	}

	bind -x '"\C-r":__fzf_hist'
fi

