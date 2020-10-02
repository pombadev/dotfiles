#!/usr/bin/env bash

log() {
    local msg=$1
    local level=${2:-1}

    if [[ -z $msg ]]; then
        return 1
    fi

    case $level in
        0)
            printf "$(tput setaf 10)[OK]$(tput init) %s\n" "$msg"
            ;;
        1)
            printf "$(tput setaf 15)[INFO]$(tput init) %s\n" "$msg"
            ;;
        2)
            printf "$(tput setaf 11)[WARN]$(tput init) %s\n" "$msg"
            ;;
        3)
            printf "$(tput setaf 1)[ERROR]$(tput init) %s\n" "$msg"
            ;;

    esac
}

case $SHELL in
    */zsh)
        if [[ ! -L "$HOME/.zshrc" ]]; then
            ln -s "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
            log "Linked: zshrc" 0
        else
            log ".zshrc symlinked already" 2
        fi

        ;;

    */bash)
        if [[ ! -L "$HOME/.bashrc" ]]; then
            ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
            log "Linked: bashrc" 0
        else
            log ".bashrc symlinked already" 2
        fi
        ;;

    *)
        log ".{bash,zsh}rc not symlinked, unsupported shell." 3
        ;;
esac

for config in .config/*; do
    if [[ ! -L "$HOME/.zshrc" ]]; then
        ln -s "$(readlink -f "$config")" "$HOME/$config"
        log "Linked: $config" 0
    else
        log "$config is symlinked already" 2
    fi
done
