#!/usr/bin/env bash

set -euo pipefail
shopt -s expand_aliases

alias cm='git --git-dir=$HOME/dotfiles --work-tree=$HOME'

(
cd ~ || return

# note: `--recurse-submodules` doesn't work with `--bare` option
git clone --bare https://github.com/pombadev/.files.git dotfiles

cm submodule update --init --recursive

# warning: will overwrites files on local
cm checkout -f

# restart shell
)
