#!/bin/bash

FZF_TMUX_OPTS="-p 80%"
FZF_COLOR='bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
FD_COMMAND=fdfind
FZF_COMMAND=fzf
FZF_TMUX_COMMAND=fzf-tmux
BAT_COMMAND=batcat
BAT_THEME=TwoDark
LS_COMMAND=exa
_MAXDEPTH=3

## set variable `cur` `left` `right`
## `cur` = current word
## `left` = left side string
## `right` = right side string
__init_line() {
	local line="$2" pos="$1" i=0
	local _c _left _right _cur
	local i=$((pos -1))
	while (( i > 0 )); do
		_c="${line:i:1}"
		# printf "#### %2d: '%s'\n" $i "$_c"
		if [[ "$_c" = [[:space:]:=@] ]]; then
			_left="${line:0:i+1}"
			_right="${line:pos}"
			_cur="${line:i+1:$((pos - i - 1))}"
			break
		fi
		i=$((i -1))
	done
	if (( i == 0 )); then
		_left=""
		_right="${line:pos}"
		_cur="${line:0:pos}"
	fi
	if [[ -n "$_right" ]]; then
		if [[ "$_right" = *[[:space:]]* ]]; then
			for (( i=0; i < ${#_right}; i++ )); do
				_c="${_right:i:1}"
				if [[ "$_c" = [[:space:]] ]]; then
					_cur="${_cur}${_right:0:i}"
					_right="${_right:i}"
					break
				fi
			done
		else
			_cur="${_cur}${_right}"
			_right=""
		fi
	fi
	eval cur=\"$_cur\" left=\"$_left\" right=\"$_right\"
}
__find_dir() {
	local cur left right
	__init_line ${READLINE_POINT} "${READLINE_LINE}" || return
	local _dir="$(eval echo ${cur})" _query="" _result=""
	if [ ! -d "${_dir}" ]; then
		# カーソルは以下の一連の文字列がディレクトリでない場合
		if [[ "$_dir" = */* ]]; then
			# 一連の文字列に "/" が含まれている場合
			# query = 後ろから "/" までの文字列
			# dir   = 先頭から最後の "/" までの文字列
			_query="${_dir##*/}"
			_dir="${_dir%/*}"
		else
			_query="${_dir}"
			_dir=""
		fi
	elif [[ "$_dir" != /* ]]; then
		# フルパスでない場合
		if [[ "$_dir" = */* ]]; then
			_query="${_dir##*/}"
			_dir="${_dir%/*}"
		else
			_query="$cur"
			_dir=""
		fi
	fi
	local fzf="${FZF_COMMAND}"
	local fzf_opts=(--prompt "Dir> " \
					--read0 --print0 \
					--reverse \
					--query "${_query}" \
					--preview="${LS_COMMAND} -lFh --color=always {}" \
					--color="${FZF_COLOR}" \
			)
	local fd_opts=(. $_dir -t d --maxdepth ${_MAXDEPTH} --follow --print0)
	if [[ -n "${TMUX}" ]]; then
		fzf="${FZF_TMUX_COMMAND} ${FZF_TMUX_OPTS}"
	fi
	_result=$(${FD_COMMAND} "${fd_opts[@]}" | ${fzf} "${fzf_opts[@]}" | xargs -0 printf "%q ")
	if [[ ${_result} != [[:space:]]* ]]; then
		left="${left}${_result}"
		READLINE_LINE="${left}${right}"
		READLINE_POINT=${#left}
	fi
}

__find_file() {
	local cur left right
	__init_line ${READLINE_POINT} "${READLINE_LINE}" || return
	local _dir="" _query="$(eval echo ${cur})" _result="" fd_opts=()
	if [[ "$_query" = */* ]]; then
		if [[ -d "$_query" ]]; then
			_dir="$_query"
			_query=""
		else
			_dir="${_query%/*}"
			_query="${_query##*/}"
		fi
	elif [[ -d "$_query" ]]; then
		_dir="$_query"
		_query=""
	fi

	local fzf="${FZF_COMMAND}"
	local fzf_opts=(--prompt "File> " \
					--multi \
					--read0 --print0 \
					--reverse \
					--query "${_query}" \
					--preview="file -b {}; ${LS_COMMAND} -ld --color=always {}; [ ! -d \"{}\" ] && ${BAT_COMMAND} --color=always --theme=\"${BAT_THEME}\" {}" \
					--preview-window='+{2}+5/2,~5' \
					--color="${FZF_COLOR}" \
				)
	local fd_opts=(. ${_dir:-} -t f --maxdepth ${_MAXDEPTH} --follow --print0)
	if [[ -n "${TMUX}" ]]; then
		fzf="${FZF_TMUX_COMMAND} ${FZF_TMUX_OPTS}"
	fi
	_result="$(${FD_COMMAND} "${fd_opts[@]}" | ${fzf} "${fzf_opts[@]}" | xargs -x0 printf "%q ")"
	if [[ ${_result} != [[:space:]]* ]]; then
		left="${left}${_result}"
		READLINE_LINE="${left}${right}"
		READLINE_POINT=${#left}
	fi
}

bind -x '"\C-g\C-d":__find_dir'
bind -x '"\C-g\C-f":__find_file'

