#!/usr/bin/env bash
set -x
set -euo pipefail
shopt -s expand_aliases

alias cmx='git --git-dir=$(pwd)/dotfiles --work-tree=$(pwd)'

(
    # cd ~ || return

    echo "Cloning ..."
    # note: `--recurse-submodules` doesn't work with `--bare` option
    git clone --bare https://github.com/pombadev/.files.git dotfiles

    echo "Fetch submodules ..."
    sleep 5s
    cmx submodule update --init --recursive

    echo "Checkout ..."
    # warning: will overwrites files on local
    sleep 5s
    cmx checkout -f

    # restart shell
)
