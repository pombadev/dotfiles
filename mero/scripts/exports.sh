#!/usr/env bash

export EDITOR=nano
export PATH="$PATH:$HOME/.local/bin"

# allow packages downgrade
if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
    export DOWNGRADE_FROM_ALA=1
fi

if command -v difft &> /dev/null;  then
	export GIT_EXTERNAL_DIFF=difft
fi
