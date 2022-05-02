#!/usr/env bash

alias bat='bat --color=always'
alias c='git status'
alias df='df -h'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias free='free -mhtw'
alias gc='git checkout'
alias gh='history | grep'
alias gi='git commit -am '
alias gl='git log --pretty=format:"%C(bold cyan)%s %C(red)(%h)%Creset%n%C(magenta)%b%n%C(yellow)%cr by %an%Creset" --stat'
alias gll="git log --pretty=format:'%Cred%h%Creset -%C(white bold) %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp='git pull origin $(branch)'
alias gps='git push origin $(branch)'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto -hls'
alias more=less
alias open='xdg-open'
alias v='git branch -vv'
alias gd='git diff'

less() {
	local OPTS='--use-color --status-column --QUIT-AT-EOF --quit-if-one-screen --incsearch --mouse'

	# https://serverfault.com/a/156510
	# detect not piped
	if [[ -t 0 ]]; then
		command less "$OPTS" --LINE-NUMBERS "$@"
	else
		command less "$OPTS" "$@"
	fi
}

if command -v xclip &>/dev/null; then
	alias xcopy='xclip -in -selection clipboard'
	alias xpaste='xclip -out -selection clipboard'
fi

# if command -v delta &>/dev/null; then
# 	alias gd="GIT_PAGER='delta --line-numbers --navigate --keep-plus-minus-markers --hyperlinks --side-by-side' git diff"
# else
# 	alias gd='git diff'
# fi
