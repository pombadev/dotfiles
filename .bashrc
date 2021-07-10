# shellcheck source=/dev/null
# shellcheck disable=SC2164

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

shopt -s globstar #  pattern ** used in a path name expansion
shopt -s autocd
shopt -s extglob    #  extended pattern matching
shopt -s histappend #  append to history file specifed by `HISTFILE`
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
source "$DOTFILES_SRC/scripts/exports.sh"
source "$DOTFILES_SRC/scripts/aliases.sh"
source "$DOTFILES_SRC/scripts/common.sh"
