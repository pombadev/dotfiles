#!/usr/bin/env zsh

# From dotfiles
source $HOME/dotfiles/aliases.sh

# sourced from alias
zle -N fzf:preview:file
bindkey '^T' fzf:preview:file

# sourced from alias
zle -N fzf:grep
bindkey '^P' fzf:grep

# sourced from alias
# zle -N fzf:npm:scripts
# bindkey '^[w' fzf:npm:scripts
alias history='history 1'

