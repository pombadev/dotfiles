# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# shellcheck disable=SC1090

# History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zhistory"
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

fpath+=$DOTFILES_SRC/zsh/zfunc

# source my specific stuffs
source "$DOTFILES_SRC/scripts/exports.sh"
source "$DOTFILES_SRC/scripts/aliases.sh"

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
if [ -f "$DOTFILES_SRC/zsh/powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source "$DOTFILES_SRC/zsh/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [ -d "$DOTFILES_SRC/zsh/zsh-completions" ]; then
    # $fpath cant cant be quoted
    # shellcheck disable=SC2206
    fpath=("$DOTFILES_SRC/zsh/zsh-completions/src" $fpath)
    # re-init compleations
    compinit
fi

source "$DOTFILES_SRC/scripts/common.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
