#!/usr/env bash

if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
	# if not inside a tmux session, and if no session is started, start a new session
	[ -z "${TMUX}" ] && (tmux new-session >/dev/null 2>&1 || tmux)
fi

# initialize Ocaml toolchain
if command -v opam &>/dev/null; then
	shell_type=$(ps $$ | tail -n1 | awk -F' ' '{print $NF}')
	ocaml_init_file="$HOME/.opam/opam-init/init.$shell_type"

	if [[ -f $ocaml_init_file ]]; then
		source "$ocaml_init_file"
	fi

	unset shell_type
	unset ocaml_init_file
fi
