# ██╗  ██╗██╗███████╗████████╗ ██████╗ ██████╗ ██╗   ██╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ███████╗
# ██║  ██║██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██╔════╝
# ███████║██║███████╗   ██║   ██║   ██║██████╔╝ ╚████╔╝     ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗███████╗
# ██╔══██║██║╚════██║   ██║   ██║   ██║██╔══██╗  ╚██╔╝      ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║╚════██║
# ██║  ██║██║███████║   ██║   ╚██████╔╝██║  ██║   ██║       ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝███████║
# ╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝

HISTFILE=$HOME/.zsh_history     #Where to save history to disk
HISTSIZE=10000000               #How many lines of history to keep in memory
SAVEHIST=10000000               #Number of history entries to save to disk
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
alias history='history 1'
export HISTTIMEFORMAT="%F %T "

autoload -U compinit && compinit # required for completions

# From dotfiles
source $HOME/Documents/dotfiles/aliases.sh
source $HOME/Documents/dotfiles/zman.zsh
source $HOME/dotfiles/exports

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# sourced from alias
zle -N fzf:preview:file
bindkey '^T' fzf:preview:file

# sourced from alias
zle -N fzf:grep
bindkey '^P' fzf:grep

# sourced from alias
zle -N fzf:npm:scripts
bindkey '^[w' fzf:npm:scripts
