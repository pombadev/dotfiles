#!/usr/bin/env bash zsh
# linting via shellcheck
# shellcheck disable=SC2096

#  ██████╗ ██╗████████╗
# ██╔════╝ ██║╚══██╔══╝
# ██║  ███╗██║   ██║
# ██║   ██║██║   ██║
# ╚██████╔╝██║   ██║
#  ╚═════╝ ╚═╝   ╚═╝

# shellcheck disable=SC2034
branch() {
	echo "$(git rev-parse --abbrev-ref HEAD)"
}

gsm() {
	git submodule foreach --recursive git "$@"

	echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

alias gd='git diff '
alias gi='git commit -am '
alias gl='git log --pretty=format:"%C(bold cyan)%s %C(red)(%h)%Creset%n%C(magenta)%b%n%C(yellow)%cr by %an%Creset" --stat'
alias go='git checkout '
alias gp='git pull origin $(branch)'
alias c='git status'
alias v='git branch -vv'
alias gpr='git pull origin master && git rebase master $(branch)'
alias bp='bash ~/Documents/backups/bp.sh'


# ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗███████╗███████╗
# ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝██║██╔════╝██╔════╝
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║█████╗  ███████╗
# ██║   ██║   ██║   ██║██║     ██║   ██║   ██║██╔══╝  ╚════██║
# ╚██████╔╝   ██║   ██║███████╗██║   ██║   ██║███████╗███████║
#  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝   ╚═╝╚══════╝╚══════╝

# Get running process that matches the passed argument
# If none provided, will show all running processes.
po() {
	# shellcheck disable=SC2009
	ps -aef | grep -i "$1"
}

# String comparison
comp_str() {

	if [[ "$1" == "$2" ]]; then
		echo 'Matched!'
	else
		echo "$1" "&" "$2" 'does not match!'
	fi
}

# Expand URL
expand_url() {
	curl -sI "$1" | sed -n 's/Location: *//p';
}

# Mini calculator
calc() {
	if [[ "$SHELL" =~ 'zsh' ]]; then
		set -o noglob
	elif [[ "$SHELL" =~ 'bash' ]]; then
		set -o localoptions -o noglob
	fi

	echo Answer: "$(echo "scale=3; $*" | /usr/bin/bc -l)"
}

# Either check for internet connectivity or does speedtest
st() {
	if [ -z "$*" ]; then
		ping -c 3 google.com
	else
		speedtest-cli --bytes
	fi
}

# restart network manager
rnet() {
	distro=$(lsb_release -i | rev | cut -d: -f1 | rev | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

	case $distro in
		manjarolinux)
			sudo -k systemctl restart NetworkManager.service ;;

		ubuntu)
			sudo -k service network-manager restart ;;
	esac
}

t() {
	# GREP for string provided by user in a
	# user defined or predefined directory
	# First parameter string to search for
	# Second parameter path to search in

	# Exit if no/whitespace search string provided, exit.
	# There's no point continuing.
	if [[ -z $1 ]]; then
		echo 'Required argument not provided, exiting...'
		exit 1
	fi

	local DEFAULT_DIR=src/scripts/

	GREP_ME() {
		grep --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed} -irHn --color=auto "$1" "$2"
	}

	# If search string is provided but no directory, use default
	# CD-ing to search in the PWD because tilix custom link doesn't
	# work if path is not absolute
	if [[ ! $2 ]] ; then
		if [[ -d $DEFAULT_DIR ]]; then
			cd $DEFAULT_DIR
			# All's good, continue
			GREP_ME "$1" "$PWD"
		else
			# DEFAULT_DIR & scripts/ doesn't exist use pwd
			GREP_ME "$1" "$PWD"
		fi
	# both search string and directory specified use them
	else
		cd "$2"
		GREP_ME "$1" "$PWD"
	fi
}

# gcp - git commit with previews
gcp() {
	local _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
	local _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

	git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" | fzf --no-sort --reverse --tiebreak=index --no-multi --ansi --preview "$_viewGitLogLine"
}

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf --reverse -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo "$pid" | xargs kill -9 -"${1:-9}"
  fi
}

fzf:preview:file() {
	# find "$PWD" -type f | fzf-tmux --reverse -d 100 --preview 'bat {}'
	rg --files --ignore --hidden -g "*" -g "\!.git" | fzf-tmux --reverse -d 100 --preview 'bat --color=always {}'
}

fzf:grep() {
	# local xxx="echo {} | egrep -io '^\\|\..+:' | xargs -I % sh -c 'cat'"

	local match=$(grep -r -nEHI '[[:alnum:]]' "." --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed} | fzf --reverse --cycle)

	if [[ "$match" ]]; then
		local file
		local line

		IFS=: read -r file line _ <<< "$match"

		# subl "$file":"$line" < /dev/tty
		code --goto "$file":"$line" < /dev/tty
	fi
}

fzf:npm:scripts() {
	local match=$(node -e "try { Object.keys(require('./package.json').scripts).forEach(script => console.log(script)) } catch (e) {console.log(e.message)}" | fzf --reverse)

	# echo $match

	if [[ "$match" ]]; then
		local file
		local line

		IFS=: read -r file line _ <<< "$match"

		# subl "$file":"$line" < /dev/tty
		# yarn $file
		command $file
	fi
}

alias bpull='node ~/Documents/dotfiles/git_sync.js'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gh='history | grep'
alias ls='ls --color=auto -hls'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -mhtw'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias g='\gl'
alias open='xdg-open'
alias bat='bat --color=always'
