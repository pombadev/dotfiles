# GIT Stuffs #

# Prettier git log
function gl() {
	git log --pretty=format:'%Cgreen%s%Creset %Cred(%h)%Creset %n%C(bold blue)%an%Creset %Cred(%cr)%n'
}

function gsm() {
	# let local COUNTER=0
	git submodule foreach --recursive git "$@"

	echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

alias gd='git diff '
alias gi='git commit -am '
alias gl='gl'
alias gm='git merge '
alias go='git checkout '
alias gp='git pull '
alias c='git status'
alias v='git show-branch --list'
alias gpa='git checkout master && git pull && git rebase master pmagar'
alias bp='bash ~/Documents/backups/bp.sh'
alias gsm='gsm'
alias ls='ls --color=auto -hl'


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


function calc () {
	while getopts ":h:help" option; do
		case $option in
			h | help)
				# echo 'This is a basic calculator, use with caution!'
				echo 'Calculator :)'
				return
			;;
		esac
	done
	# bash version
	# echo Result is: "$(($@))" # fastest but doesnt work on fractions
	# echo Result is: $(expr $(($@))) # fastest but doesnt work on fractions

	# nodejs version
	# node -e "console.log('Result is:', $*)" # slowest
	# python version
	# python -c "print('Result is:', $*)" # slowest but faster than nodejs

	# `bc` version (http://hacktux.com/bash-calculator/)
	# slower than bash but faster than the above languages
	echo Result is: "$(echo "scale=3; $*" | /usr/bin/bc -l)"
}

function st() {
	if [[ ! -z "$@" ]]; then
		speedtest-cli --bytes
	else
		ping -c 3 google.com
	fi
}

function pac() {
	# so that when CTRL+C is pressed, just exit
	trap SIGINT

	if [[ $1 == "i" ]]; then
		sudo pacman -S $2
	elif [[ $1 == "s" ]]; then
		pacman -Ss $2
	fi

	if [[ $? != 0 ]]; then
		echo -e '\n\033[1mNot found, using yaourt....\033[0m\n'

		if [[ $1 == "i" ]]; then
			yaourt -S $2
		elif [[ $1 == "s" ]]; then
			yaourt -Ss $2
		fi
	fi
}

function rnet() {
	distro="$(python -c 'import platform; print(platform.dist()[1].lower())')"

	case $distro in
		manjaro)
			sudo systemctl restart NetworkManager.service
			;;

		ubuntu)
			sudo service network-manager restart
			;;
	esac
}

alias bpull='go master && gp && gsm checkout master && gsm pull'
alias po='po'
alias t='bash ~/Documents/dotfiles/t.sh'
alias ava='ava -v'
alias st='st'
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
# for the lulz
alias vi='vim'
alias vim='vim'
# cal
# alias calc='noglob calc'

# Stuffs
export nm='./node_modules/.bin/'

