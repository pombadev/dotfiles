#!/usr/env bash

export EDITOR=nano
export PATH="$PATH:$HOME/.local/bin"

# allow packages downgrade
if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
    export DOWNGRADE_FROM_ALA=1
fi
