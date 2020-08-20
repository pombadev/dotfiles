# History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
# How many lines of history to keep in memory
HISTSIZE=10000000

# Number of history entries to save to disk
# shellcheck disable=SC2034
SAVEHIST=10000000

# ignore commands that start with space
setopt histignorespace

# ignore duplicated commands history list
setopt histignoredups

# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first

# record timestamp of command in HISTFILE
setopt extended_history

# show command with history expansion to user before running it
setopt hist_verify

# add commands to HISTFILE in order of execution
setopt inc_append_history

# share command history data
setopt share_history

# turns on interactive comments
setopt interactivecomments

# turns on spelling correction for commands
# setopt correct

# Extended globbing. Allows using regular expressions with *
setopt extendedglob

# No beep
setopt nobeep

# If a new command is a duplicate, remove the older one
setopt histignorealldups

# required for completions

autoload -Uz compinit && compinit
# required for prompts

autoload -Uz promptinit && promptinit

# not good enough
# zmodload -i zsh/complist
# source /tmp/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# faux autocomplete menu
# setopt menucomplete

# source my specific stuffs
source "$HOME/dotfiles/exports.sh"
source "$HOME/dotfiles/aliases.sh"

alias history='history 1'

# allow packages downgrade
if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
    # shellcheck disable=SC2034
    DOWNGRADE_FROM_ALA=1
fi

# make keymap nicer
if [ -f "$HOME/dotfiles/zsh/key-bindings.zsh" ]; then
    source "$HOME/dotfiles/zsh/key-bindings.zsh"
fi

if [ -f "$HOME/dotfiles/zsh/completion.zsh" ]; then
    source "$HOME/dotfiles/zsh/completion.zsh"
fi

# fish shell like suggestion
if [ -f "$HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# theme
if [ -f "$HOME/dotfiles/zsh/sublime/sublime.zsh" ]; then
    source "$HOME/dotfiles/zsh/sublime/sublime.zsh"
fi
