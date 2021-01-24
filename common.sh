#!/usr/env bash

if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
	# if not inside a tmux session, and if no session is started, start a new session
	[ -z "${TMUX}" ] && (tmux new-session >/dev/null 2>&1 || tmux)
fi
