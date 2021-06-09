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

# shellcheck disable=SC2120
ble-bootstrap() {
    opt=$1

    is-ble-installed() {
        (
            if [ -d "$DOTFILES_SRC"/bash/ble.sh ]; then
                cd "$DOTFILES_SRC"/bash/ble.sh
                if [ -f .git ] && [ "$(git remote get-url origin)" == "https://github.com/akinomyoga/ble.sh.git" ]; then
                    return 0
                fi
            fi

            return 1
        )
    }

    if [[ $opt == "i" ]] || [[ $opt == "install" ]]; then
        (
            if ! is-ble-installed; then
                cd "$DOTFILES_SRC"/bash
                git submodule add https://github.com/akinomyoga/ble.sh.git
                cd ble.sh
                make
            else
                echo "'ble.sh' is already installed."
            fi

        )
    elif [[ $opt == "u" ]] || [[ $opt == "update" ]]; then
        (
            # shellcheck disable=SC2154
            if is-ble-installed && ((_ble_bash)); then
                # shellcheck disable=SC2164
                cd "$DOTFILES_SRC"/bash/ble.sh
                git pull origin master
                make
            fi
        )
    fi

    if [[ $- == *i* ]]; then
        # shellcheck source=/dev/null
        source "$DOTFILES_SRC"/bash/ble.sh/out/ble.sh --noattach --rcfile "$DOTFILES_SRC"/bash/.blerc
        ((_ble_bash)) && ble-attach
    fi
}

ble-bootstrap
