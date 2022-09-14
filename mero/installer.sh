#!/usr/bin/env bash

# shellcheck disable=SC1090

set -euo pipefail
shopt -s expand_aliases

alias cmx='git --git-dir=$HOME/dotfiles --work-tree=$HOME'

(
    cd ~

    # note: `--recurse-submodules` doesn't work with `--bare` option
    git clone --bare https://github.com/pombadev/dotfiles.git

    echo "WARNING! WILL OVERWRITE FILES ON LOCAL IF IT EXIST?"
    echo "Select 1/2 to continue"

    reply=""

    while [ "$reply" == "" ]; do
        select reply in yes no; do
            if [ $reply == "yes" ]; then
                cmx checkout -f

                cmx config --local status.showUntrackedFiles no

                cmx submodule update --init --recursive --remote --force

                shell=$(ps -p $$ -ocomm=)

                case $shell in
                bash | zsh) source ~/."$shell"rc ;;
                *) echo "Unsupported shell to auto reload" ;;
                esac

                echo "If you don't see any changes, restart shell to see changes"
                exit 0
            else
                echo "cleaning up.."
                rm -rf dotfiles
                exit 1
            fi
        done
    done
)
