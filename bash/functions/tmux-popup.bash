#!/bin/bash

function tp {
	if [[ -z "$TMUX" ]]; then
		command "$@"
		return $?
	fi

	local popup_session=popup
	local width="80%" height="80%"
	local session=$(tmux display-message -p "#{session_name}")
	if [[ "$session" = "${popup_session}" ]]; then
		tmux detach-client
	elif (( $# > 0 )); then
		tmux popup -d "#{pane_current_path}" -w$width -h$height -T "$* [#{pane_current_path}]" -- "$@"
	else
		tmux popup -d "#{pane_current_path}" -w$width -h$height -E "tmux new -A -s '${popup_session}'"
	fi
}
function __tmux_popup {
	tp ${READLINE_LINE}
}

bind -x '"\C-g\C-p":__tmux_popup'

