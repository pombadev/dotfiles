# History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000             #How many lines of history to keep in memory
SAVEHIST=10000000             #Number of history entries to save to disk
setopt histignorespace        # ignore commands that start with space
setopt histignoredups         # ignore duplicated commands history list
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# turns on interactive comments
setopt interactivecomments
# turns on spelling correction for commands
# setopt correct

setopt extendedglob

# faux autocomplete menu
# setopt menucomplete

autoload -U compinit && compinit # required for completions
autoload -U promptinit # required for prompts

# from dotfiles
source $HOME/dotfiles/zsh/customize.zsh
