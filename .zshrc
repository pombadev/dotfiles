# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

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

# required for completions
autoload -Uz compinit && compinit

# required for prompts
autoload -Uz promptinit && promptinit

# not good enough
# zmodload -i zsh/complist
# source /tmp/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# faux autocomplete menu
# setopt menucomplete

DOTFILES_SRC=$(dirname "${(%):-%x}")
DOTFILES_ROOT=$DOTFILES_SRC/mero
DOTFILES_ZSH=$DOTFILES_SRC/mero/zsh

fpath+=$DOTFILES_ZSH/zfunc

source "$DOTFILES_ROOT/init.sh"

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

# theme
# if [ -f "$DOTFILES_ZSH/powerlevel10k/powerlevel10k.zsh-theme" ]; then
#     source "$DOTFILES_ZSH/powerlevel10k/powerlevel10k.zsh-theme"
# fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

if [ -d "$DOTFILES_ZSH/zsh-completions" ]; then
    # $fpath cant cant be quoted
    # shellcheck disable=SC2206
    fpath=("$DOTFILES_ZSH/zsh-completions/src" $fpath)
    # re-init completions
    compinit
fi

# . "$HOME/.asdf/asdf.sh"
#
# if [ -d "$ASDF_DIR" ]; then
# 	#fpath=("$ASDF_DIR/completions" $fpath)
# 	# re-init completions
# 	# compinit
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# unset DOTFILES_ROOT

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

if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

if command -v opam &> /dev/null; then
    eval "$(opam env)"
fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

if [ -d ~/.local/pkgman ]; then
    PKGMAN_PATH="$(find ~/.local/pkgman -type f -executable -exec sh -c 'dirname $1 | tr "\n" ":"' shell {} \;)"

    export PATH="$PATH:$PKGMAN_PATH"
fi


alias which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@'

# bun completions
[ -s "/home/pjmp/.bun/_bun" ] && source "/home/pjmp/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

