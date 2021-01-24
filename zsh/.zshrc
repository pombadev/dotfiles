# shellcheck disable=SC1090

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

# DOTFILES_SRC="$(cd "$(dirname "$(readlink -f "${(%):-%x}")")" && git rev-parse --show-toplevel)"
# DOTFILES_SRC="$(git -C "$(dirname "$(readlink -f "${(%):-%x}")")" rev-parse --show-toplevel)"
DOTFILES_SRC=$(
    current_file="${(%):-%x}"
    original_file=$(readlink -f "$current_file")
    file_directory=$(dirname "$original_file")
    cmd="git -C '$file_directory' rev-parse"

    if [ -z "$(eval "$cmd" --show-superproject-working-tree)" ]; then
        eval "$cmd" --show-toplevel
    else
        eval "$cmd" --show-superproject-working-tree
    fi
)

# source my specific stuffs
source "$DOTFILES_SRC/exports.sh"
source "$DOTFILES_SRC/aliases.sh"

alias history='history 1'

# allow packages downgrade
if [[ $(grep -P '^ID=' /etc/os-release) == *manjaro ]]; then
    # shellcheck disable=SC2034
    DOWNGRADE_FROM_ALA=1
fi

# make keymap nicer
if [ -f "$DOTFILES_SRC/zsh/key-bindings.zsh" ]; then
    source "$DOTFILES_SRC/zsh/key-bindings.zsh"
fi

if [ -f "$DOTFILES_SRC/zsh/completion.zsh" ]; then
    source "$DOTFILES_SRC/zsh/completion.zsh"
fi

# fish shell like suggestion
if [ -f "$DOTFILES_SRC/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$DOTFILES_SRC/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# theme
if [ -f "$DOTFILES_SRC/zsh/sublime/sublime.zsh" ]; then
    source "$DOTFILES_SRC/zsh/sublime/sublime.zsh"
fi

if [ -d "$DOTFILES_SRC/zsh/zsh-completions" ]; then
    # $fpath cant cant be quoted
    # shellcheck disable=SC2206
    fpath=("$DOTFILES_SRC/zsh/zsh-completions/src" $fpath)
    # re-init compleations
    compinit
fi

source "$DOTFILES_SRC/common.sh"