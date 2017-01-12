# GIT Stuffs #

# Prettier git log
function gl() {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit
}

alias gd='git diff '
alias gi='git commit -am '
alias gl='gl'
alias gm='git merge '
alias go='git checkout '
alias gp='git pull '
alias c='git status'
alias v='git branch -v'

# Utilities #

# Get running process that matches the passed argument
# If none provided, will show all running processes.
function po() {
	ps -aef | grep -i "$1"
}

alias bpull='bash ~/Documents/backups/bpull.sh'
alias po='po'
alias t='bash ~/Documents/backups/t.sh'
alias ava='ava -v'
