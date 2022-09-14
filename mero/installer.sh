#!/usr/bin/env bash

set -euo pipefail
shopt -s expand_aliases

alias cmx='git --git-dir=$HOME/dotfiles --work-tree=$HOME'

(
    cd ~

    # note: `--recurse-submodules` doesn't work with `--bare` option
    git clone --bare https://github.com/pombadev/.files.git dotfiles

    echo "WARNING! WILL OVERWRITE FILES ON LOCAL IF IT EXIST?"
    echo "Select 1/2 to continue"

    reply=""

    while [ "$reply" == "" ]; do
        select reply in yes no; do
            if [ $reply == "yes" ]; then
                cmx checkout -f

                cmx submodule update --init --recursive --remote --force

                case $(ps -p $$ -ocomm=) in
                bash) source ~/.bashrc ;;
                zsh) source ~/.zshrc ;;
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
