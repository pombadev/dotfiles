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

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin light zsh-users/zsh-autosuggestions
zplugin snippet OMZ::lib/key-bindings.zsh
zplugin ice src"sublime.zsh"; zplugin light pjmp/sublime
zplugin light ael-code/zsh-colored-man-pages
