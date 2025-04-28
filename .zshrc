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

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

DOTFILES_SRC=$(dirname "${(%):-%x}")
DOTFILES_ROOT=$DOTFILES_SRC/mero
DOTFILES_ZSH=$DOTFILES_SRC/mero/zsh

fpath+=$DOTFILES_ZSH/zfunc

# source "$DOTFILES_ROOT/init.sh"

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
    eval "$(starship init zsh)"
fi

if [ -d "$DOTFILES_ZSH/zsh-completions" ]; then
    # $fpath cant cant be quoted
    # shellcheck disable=SC2206
    fpath=("$DOTFILES_ZSH/zsh-completions/src" $fpath)
    # re-init completions
    compinit
fi

if command -v asdf &> /dev/null; then
    export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

    # append completions to fpath
    fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
    # initialise completions with ZSH's compinit
    autoload -Uz compinit && compinit
fi

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

# doesnt work on mac
# alias which='(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@'

# bun completions
[ -s "/home/pjmp/.bun/_bun" ] && source "/home/pjmp/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if command -v brew &> /dev/null; then
    export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
    export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
fi

# for mac
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# fnm
FNM_PATH="$HOME/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/pomba/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
