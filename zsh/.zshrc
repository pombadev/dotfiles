# History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000               #How many lines of history to keep in memory
SAVEHIST=10000000               #Number of history entries to save to disk
setopt histignorespace        # ignore commands that start with space
setopt histignoredups         # ignore duplicated commands history list

setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# More info http://zsh.sourceforge.net/Intro/intro_16.html

# turns on interactive comments
setopt interactivecomments
# turns on spelling correction for commands
# setopt correct

setopt extendedglob

# faux autocomplete menu
# setopt menucomplete

autoload -U compinit && compinit # required for completions
autoload -U promptinit # required for prompts

# export TERM=xterm

# From dotfiles
source $HOME/dotfiles/aliases.sh
source $HOME/dotfiles/exports

# Personal stuffs
[ -r $HOME/.byobu/prompt ] && source $HOME/.byobu/prompt
# sourced from alias
zle -N fzf:preview:file
bindkey '^T' fzf:preview:file

# sourced from alias
zle -N fzf:grep
bindkey '^P' fzf:grep

# sourced from alias
zle -N fzf:npm:scripts
bindkey '^[w' fzf:npm:scripts
alias history='history 1'

# source $HOME/.zman/zman.zsh

# zman use 'sublime/sublime.zsh'
# zman use 'zsh-autosuggestions/zsh-autosuggestions.zsh'
# zman use 'zsh-colored-man-pages/colored-man-pages.plugin.zsh'
# zman use 'zsh-history-substring-search/zsh-history-substring-search.zsh'

export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:/home/pomba/.gem/ruby/2.6.0/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# http://zsh.sourceforge.net/Doc/Release/Parameters.html
# REPORTTIME=3

export PATH=$PATH:$HOME/.poetry/bin

### Added by Zplugin's installer
source '/home/pomba/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin light zsh-users/zsh-autosuggestions
# zplugin light zdharma/fast-syntax-highlighting
zplugin snippet OMZ::lib/key-bindings.zsh

# zplugin ice pick"async.zsh" src"pure.zsh"; zplugin light sindresorhus/pure
# zplugin ice pick"lib/" src"spaceship.zsh"; zplugin light denysdovhan/spaceship-prompt
zplugin ice src"sublime.zsh"; zplugin light pjmp/sublime
# zplugin ice src"powerlevel9k.zsh-theme"; zplugin light romkatv/powerlevel10k
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="🐧 "
# zplugin snippet https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-classic.zsh
# zplugin snippet https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-lean.zsh
# zplugin snippet https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-pure.zsh
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs command_execution_time)

export PATH=$PATH:$HOME/go/bin
