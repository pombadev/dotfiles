# GIT Stuffs
alias gd='git diff '
alias gi='git commit -am '
alias gl='git log --format=%+s\ %+an\ %+ad\ %+H  --date=local'
alias gm='git merge '
alias go='git checkout '
alias gp='git pull '
alias c='git status'
alias v='git branch -v'

# Utilities #

# Get running process that matches the passed argument
# If none provided, will show all running processes
function po() {
	ps fx | grep -i "$1"
}

alias bpull='bash ~/Documents/backups/bpull.sh'
alias po='po'
alias t='bash ~/Documents/backups/t.sh'
