#!/bin/bash

pushd() {
	local DIR
	if [ $# -eq 0 ]; then
		DIR="${HOME}"
	elif [ "$1" = "-" ]; then
		builtin popd >/dev/null
		return $?
	else
		DIR="$1"
	fi
	builtin pushd "${DIR}" >/dev/null
	return $?
}
alias cd='pushd'

