#!/usr/bin/env bash

# shellcheck disable=SC1090

set -euo pipefail
shopt -s expand_aliases

alias cmx='git --git-dir=$HOME/dotfiles --work-tree=$HOME'

ask() {
    echo "Select 1 to continue or 2 to exit."

    reply=""

    while [[ "$reply" == "" ]]; do
        select reply in yes no; do
            if [[ -z $reply ]]; then
                continue
            elif [[ $reply == "yes" ]]; then
                return 0
            else
                return 1
            fi
        done
    done
}

setup() {
    local arg=${1:--i}

    case $arg in
    --install | -i)
        (
            cd ~

            # note: `--recurse-submodules` doesn't work with `--bare` option
            git clone --bare https://github.com/pombadev/dotfiles.git dotfiles

            echo "WARNING! WILL OVERWRITE FILES IF IT EXIST?"

            if ask; then
                cmx checkout -f

                cmx config --local status.showUntrackedFiles no

                cmx submodule update --init --recursive --remote --force

                # shellcheck disable=SC2016
                cmx submodule foreach --recursive 'git checkout $(git remote show origin | grep -ie "HEAD branch:" | cut -d " " -f5); echo'

                shell=$(ps -p $$ -ocomm=)

                case $shell in
                bash | zsh) source ~/."$shell"rc ;;
                *) echo "Unsupported shell to auto reload" ;;
                esac

                echo "If you don't see any changes, restart shell to see changes"
            else
                echo "cleaning up.."
                rm -rf dotfiles
                exit 1
            fi
        )
        ;;
    --uninstall | -u)
        echo "are you sure you want to nuke everything?"
        if ask; then
            (
                cd ~
                rm -rf "$(cmx ls-files)"
                rm -rf ./dotfiles
            )
        else
            echo "doing nothing, bye.."
        fi
        ;;
    *)
        echo "invalid option -- '$arg'"
        echo "available options --install | -i / --uninstall | -u"
        exit 1
        ;;
    esac
}

setup "$@"
