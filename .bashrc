# shellcheck source=/dev/null
# shellcheck disable=SC2164

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# from now on, bash is assumed to be interactive

DOTFILES_SRC=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
DOTFILES_ROOT=$DOTFILES_SRC/mero
DOTFILES_BASH=$DOTFILES_SRC/mero/bash

shopt -s globstar #  pattern ** used in a path name expansion
shopt -s autocd
shopt -s extglob    #  extended pattern matching
shopt -s histappend #  append to history file specified by `HISTFILE`
shopt -s cmdhist    # save all lines of a multiple-line command in the same history entry
shopt -s lithist    # multi-line commands are saved to the history with embedded newlines

# History command configuration
[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.shell_history"

# unlimited bash history & history file size
export HISTFILESIZE=
export HISTSIZE=

[[ $DISPLAY ]] && shopt -s checkwinsize

# need to install `bash-completion` package
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# source my specific stuffs
source "$DOTFILES_ROOT/scripts/exports.sh"
source "$DOTFILES_ROOT/scripts/aliases.sh"
source "$DOTFILES_ROOT/scripts/funcs.sh"
source "$DOTFILES_ROOT/scripts/bootstraper.sh"

# syntax highlight & fish shell like autocomplete support
if [[ ! -d "$DOTFILES_BASH/ble.sh/out" ]]; then
	make -C "$DOTFILES_BASH/ble.sh" 1>/dev/null
	source "$DOTFILES_BASH/ble.sh/out/ble.sh"
elif [[ -f "$DOTFILES_BASH/ble.sh/out/ble.sh" ]]; then
	source "$DOTFILES_BASH/ble.sh/out/ble.sh"
fi

# apply theme
# if [[ -f $DOTFILES_BASH/simple/prompt.sh ]]; then
# 	source "$DOTFILES_BASH/simple/prompt.sh"
# fi

unset DOTFILES_SRC


if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi