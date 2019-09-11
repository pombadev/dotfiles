#!/usr/bin/env zsh

# From dotfiles
source $HOME/dotfiles/aliases.sh

# sourced from alias
zle -N fzf:preview:file
bindkey '^T' fzf:preview:file

# sourced from alias
zle -N fzf:grep
bindkey '^P' fzf:grep

# sourced from alias
# zle -N fzf:npm:scripts
# bindkey '^[w' fzf:npm:scripts
alias history='history 1'

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin light zsh-users/zsh-autosuggestions
zplugin snippet OMZ::lib/key-bindings.zsh
zplugin ice src"sublime.zsh"; zplugin light pjmp/sublime
zplugin light ael-code/zsh-colored-man-pages

# execution time
zplugin light popstas/zsh-command-time
ZSH_COMMAND_TIME_MIN_SECONDS=3
zsh_command_time() {
	if [ -n "$ZSH_COMMAND_TIME" ]; then
		hours=$(($ZSH_COMMAND_TIME/3600))
		min=$(($ZSH_COMMAND_TIME/60))
		sec=$(($ZSH_COMMAND_TIME%60))
		if [ "$ZSH_COMMAND_TIME" -le 60 ]; then
			timer_show="$fg[green]$ZSH_COMMAND_TIME s."
		elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 180 ]; then
			timer_show="$fg[yellow]$min min. $sec s."
		else
			if [ "$hours" -gt 0 ]; then
				min=$(($min%60))
				timer_show="$fg[red]$hours h. $min min. $sec s."
			else
				timer_show="$fg[red]$min min. $sec s."
			fi
		fi
		printf "${ZSH_COMMAND_TIME_MSG}\n" "$timer_show"
	fi
}
