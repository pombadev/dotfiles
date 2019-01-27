# zsh options
HISTFILE=~/.zsh_history
HISTSIZE=10000000               #How many lines of history to keep in memory
SAVEHIST=10000000               #Number of history entries to save to disk
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY     # add commands to HISTFILE in order of execution
setopt APPENDHISTORY          #append to history
setopt SHARE_HISTORY          # share command history data
setopt COMPLETE_ALIASES

autoload -U compinit && compinit # required for completions

# From dotfiles
source $HOME/dotfiles/aliases.sh
source $HOME/dotfiles/exports
source $HOME/dotfiles/zman.zsh

# sourced from alias
zle -N fzf:preview:file
bindkey '^T' fzf:preview:file

# sourced from alias
zle -N fzf:grep
bindkey '^P' fzf:grep

# sourced from alias
zle -N fzf:npm:scripts
bindkey '^[w' fzf:npm:scripts

alias history='history 1'
