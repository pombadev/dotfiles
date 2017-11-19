# GIT Stuffs #

# Prettier git log
function gl() {
	git log --pretty=format:'%Cgreen%s%Creset %Cred(%h)%Creset %n%C(bold blue)%an%Creset %Cred(%cr)%n'
}

function gsm() {
	let local COUNTER=0

	git submodule foreach --recursive \
	git "$@"

	echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

alias gd='git diff '
alias gi='git commit -am '
alias gl='gl'
alias gm='git merge '
alias go='git checkout '
alias gp='git pull '
alias c='git status'
alias v='git branch -v'
alias gpa='git checkout master && git pull && git rebase master pmagar'
alias bp='bash ~/Documents/backups/bp.sh'
alias gsm='gsm'


# Utilities #

# Get running process that matches the passed argument
# If none provided, will show all running processes.
function po() {
	ps -aef | grep -i "$1"
}

# String comparison
function str_comp() {

	[[ "$1" == "$2" ]]

	if [[ "$?" == "0" ]]; then
		echo 'Matched!'
	else
		echo "$1" "&" "$2" 'does not match!'
	fi
}

# Update Guake's tab title 
# function update_dir_name () {
#    builtin cd $@
#    guake -r $(basename $PWD)
# }

# Expand URL
function check() {
	curl -sI $1 | sed -n 's/Location: *//p';
}



alias bpull='go master && gp && gsm checkout master && gsm pull'
alias po='po'
alias t='bash ~/Documents/dotfiles/t.sh'
alias ava='ava -v'
alias st='ping -c 3 google.com'
alias rnet='sudo service network-manager restart'
alias comp='str_comp'
# alias cd='update_dir_name'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias checkurl='check'

# Stuffs
export nm='./node_modules/.bin/'

