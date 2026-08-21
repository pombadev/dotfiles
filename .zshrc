# shellcheck disable=SC1090

# History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.shell_history"
# How many lines of history to keep in memory
HISTSIZE=999999999999999999

# Number of history entries to save to disk
# shellcheck disable=SC2034
SAVEHIST=999999999999999999

# ignore commands that start with space
setopt histignorespace

# ignore duplicated commands history list
setopt histignoredups

# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first

# bash history compatibility
unsetopt extended_history

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

DOTFILES_SRC=$(dirname "${(%):-%x}")
DOTFILES_ROOT=$DOTFILES_SRC/mero
DOTFILES_ZSH=$DOTFILES_SRC/mero/zsh

# required for completions
fpath+=("$DOTFILES_ZSH/zfunc")

if [ -d "$DOTFILES_ZSH/zsh-completions" ]; then
    # $fpath cant be quoted
    # shellcheck disable=SC2206
    fpath=("$DOTFILES_ZSH/zsh-completions/src" $fpath)
fi

if command -v asdf &>/dev/null; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
    fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

if [[ "$(uname)" == "Darwin" ]] && [ -d "$HOME/.docker/completions" ]; then
    fpath=("$HOME/.docker/completions" $fpath)
fi

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# required for prompts
autoload -Uz promptinit && promptinit

# source my specific stuffs
source "$DOTFILES_ROOT/scripts/exports.sh"
source "$DOTFILES_ROOT/scripts/aliases.sh"
source "$DOTFILES_ROOT/scripts/funcs.sh"

alias history='history 1'

# make keymap nicer
if [ -f "$DOTFILES_ZSH/ohmyzsh/lib/key-bindings.zsh" ]; then
    source "$DOTFILES_ZSH/ohmyzsh/lib/key-bindings.zsh"
fi

if [ -f "$DOTFILES_ZSH/ohmyzsh/lib/completion.zsh" ]; then
    source "$DOTFILES_ZSH/ohmyzsh/lib/completion.zsh"
fi

# fish shell like suggestion
if [ -f "$DOTFILES_ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$DOTFILES_ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if command -v starship &> /dev/null; then
    export SPACESHIP_PROMPT_ASYNC=true
    eval "$(starship init zsh)"
fi

if command -v fzf &> /dev/null; then
    ctrl-r-widget() {
        # setting BUFFER will update line editor's buffer
        BUFFER=$(fc -r -l -n 1 | fzf --multi --reverse --info=inline --no-sort --bind 'ctrl-l:clear-query,ctrl-k:clear-selection' --header 'Press CTRL-L to clear query & CTRL-K to clear selection')
        zle end-of-buffer-or-history
        unset FZF_DEFAULT_OPTS
    }

    zle -N ctrl-r-widget

    bindkey '^R' ctrl-r-widget
fi

if command -v opam &> /dev/null; then
    eval "$(opam env)"
fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export PATH="$HOME/fvm/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"



# Added by Antigravity CLI installer
export PATH="/home/pomba/.local/bin:$PATH"


if command -v fresh &> /dev/null; then
    export EDITOR=fresh
fi

# dune
source $HOME/.local/share/dune/env/env.zsh

# >>> Codex installer >>>
export PATH="/home/pomba/.local/bin:$PATH"
# <<< Codex installer <<<
