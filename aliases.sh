#!/usr/bin/env bash
# linting via shellcheck
# shellcheck disable=SC2096

# Exit on error. Append "|| true" if you expect an error.
# set -o errexit
# # Exit on error inside any functions or subshells.
# set -o errtrace
# # Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
# set -o nounset
# # Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
# set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

#  ██████╗ ██╗████████╗
# ██╔════╝ ██║╚══██╔══╝
# ██║  ███╗██║   ██║
# ██║   ██║██║   ██║
# ╚██████╔╝██║   ██║
#  ╚═════╝ ╚═╝   ╚═╝

# shellcheck disable=SC2034
branch() {
	git rev-parse --abbrev-ref HEAD
}

gsm() {
	git submodule foreach --recursive git "$@"

	echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

stash-explore() {
	git stash list | fzf --reverse --preview-window=70% --preview '
		local stash=$(echo {} | egrep -roh "^stash+.+}" -)

		git stash show -p $stash | diff-so-fancy
	'
}

clean-git-branches() {
	git branch | grep -E -v "(^\s+dev$|^\s+master|^\*.+$)" | xargs git branch -D
}

alias gd='git diff '
alias gi='git commit -am '
alias gl='git log --pretty=format:"%C(bold cyan)%s %C(red)(%h)%Creset%n%C(magenta)%b%n%C(yellow)%cr by %an%Creset" --stat'
alias go='git checkout '
alias gp='git pull origin $(branch)'
alias gps='git push origin $(branch)'
alias c='git status'
alias v='git branch -vv'
alias gpr='git pull origin master && git rebase master $(branch)'

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
check-url() {
	curl -sI "$1" | sed -n 's/Location: *//p'
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
		speedtest-cli --bytes --no-upload
	fi
}

# restart network manager
rnet() {
	distro=$(lsb_release -i | column -t | cut -d\  -f5 | tr '[:upper:]' '[:lower:]')

	case $distro in
		manjarolinux)
			sudo -k systemctl restart NetworkManager.service
		;;

		ubuntu)
			sudo -k service network-manager restart
		;;
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
		grep -E --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed,build,coverage} -irHn --color=auto "$1" "$2"
	}

	if [[ -z $2 ]]; then
		if [[ -d $DEFAULT_DIR ]]; then
			GREP_ME "$1" "$(pwd)/$DEFAULT_DIR"
		else
			GREP_ME "$1" "$(pwd)"
		fi
	else
		GREP_ME "$1" "$(pwd)/$2"
	fi
}

# gcp - git commit with previews
gcp() {
	local _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
	local _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

	git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" | fzf --no-sort --reverse --tiebreak=index --no-multi --ansi --preview "$_viewGitLogLine"
}

fkill() {
	# shellcheck disable=SC2155
	local PID=$(
		ps -aux |
			sed 1d |
			fzf --sync \
				--border --prompt='⚙ ' \
				--reverse \
				--multi \
				--preview 'echo {} | column -t | cut -d\  -f 3 | xargs pstree -h ' |
			awk '{print $2}'
	)

	[[ -n "$PID" ]] && echo "$PID" | xargs kill -SIGTERM
}

fzf:preview:file() {
	# find "$PWD" -type f | fzf-tmux --reverse -d 100 --preview 'bat {}'
	rg --files --ignore --hidden -g "*" -g "\!.git" | fzf-tmux --reverse -d 100 --preview 'bat --color=always {}'
}

fzf:grep() {
	# local xxx="echo {} | egrep -io '^\\|\..+:' | xargs -I % sh -c 'cat'"

	# shellcheck disable=SC2155
	local match=$(grep -r -nEHI '[[:alnum:]]' "." --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed} | fzf --reverse --cycle)

	if [[ -n "$match" ]]; then
		local file
		local line

		IFS=: read -r file line _ <<< "$match"

		# subl "$file":"$line" < /dev/tty
		code --goto "$file":"$line" < /dev/tty
	fi
}

npm-scripts() {
	local script

	if command -v jq &> /dev/null; then
		script=$(jq --monochrome-output --raw-output '.scripts | keys[]' package.json | fzf --reverse)
	else
		script=$(node -e "try { Object.keys(require('./package.json').scripts).forEach(script => console.log(script)) } catch (e) {console.log(e.message)}" | fzf --reverse)
	fi

	local pkg_man_with_cmd="npm run"

	if [ -f yarn.lock ]; then
		pkg_man_with_cmd="yarn"
	fi

	if [ -n "$script" ]; then
		echo "$(tput setaf 11) $pkg_man_with_cmd $script$(tput sgr0)"
		sh -c "$pkg_man_with_cmd $script"
	fi
}

dig() {
	if [ -z "$1" ]; then
		echo "Provide a query string to dig up."
		return 0
	fi

	query=$*
	provider=''

	case "$1" in
		t|T)
			provider=tldr
		;;
		e|E)
			provider=eg
		;;
		c|C)
			provider=cht.sh
		;;
	esac

	if [ -n "$provider" ]; then
		"$provider" "${query[@]:1}"
		return 0
	fi

	printf "Digging with 'tldr' ...\n"

	if ! tldr "$query"; then
		printf "\nDigging with 'eg' ...\n"

		TMP_FILE=$(mktemp)

		eg "$query" > "$TMP_FILE"

		if ! grep --color=never "No entry found" "$TMP_FILE"; then
			cat "$TMP_FILE"
		else
			printf "\nDigging with 'cht.sh' ...\n"

			cht.sh "$query"
		fi
	fi
}

serve() {
	if [[ $(python -V) =~ 3 ]]; then
		python3 -m http.server
	elif [[ $(python -V) =~ 2 ]]; then
		python -m SimpleHTTPServer
	fi
}

d() {
	# history -1 | fzf --tac --bind 'enter:execute(echo {} | sed -r "s/ *[0-9]*\*? *//")+abort'
	print -z "$(history -1 | fzf --reverse --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')"
}

pkg() {
	exit_on_sigint() {
		return "$?"
	}

	trap "exit_on_sigint" SIGINT

	case "$1" in
		s|S|search)
			shift

			if ! pacman -Ss "$@"; then
				yay -Ss "$@"
			fi
		;;

		i|I|install)
			shift

			if ! sudo -k pacman -S "$@"; then
				# normally if the above commands fails, this block will never run
				# but when SIGINT (Ctrl+c) is sent it's not recieved by our `exit_on_sigint` function
				# so returning early here.
				# shellcheck disable=SC2181
				if [[ "$?" == "0" ]]; then
					return 1
				fi

				yay -S "$@"
			fi
		;;

		r|R|remove)
			shift

			sudo -k pacman -Rs "$@"
		;;

		p|P|purge)
			sudo -k pacman -Rns "$(pacman -Qttdq)"
		;;

		u|U|update)
			shift

			local pkg_man="yay" && [[ -n "$1" ]] && pkg_man="$1"

			if ! [[ "$pkg_man" =~ (pacman|yay) ]]; then
				echo 'error: unsupported package manager, use either pacman or yay'
				return 1
			fi

			sh -c "$pkg_man -Syyuu --noconfirm"
		;;

		*)
			echo 'pkg - A thin shellscript wrapper for pacman and yay'
			echo 'usage: pkg [option] <packages>'
			echo 'operations:'
			echo -e '\t pkg [s | search] [i | install] [r | remove] <packages>'
			echo -e '\t pkg [p | purge]'
			echo -e '\t pkg [u | upgrade]'
			echo -e '\t pkg [option] <pacman/yay options>'
		;;
	esac

	# remove trap
	trap - SIGINT
}

check-colors() {
	for i in {0..256}; do
		printf "%s %s" "$(tput setaf $i)" $i
		[[ $i == 256 ]] && echo
	done
}

man2pdf() {
	local DEST=${2:-$HOME/Documents}
	man -Tpdf "$1" > "$DEST/$1.pdf"
}

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gh='history | grep'
alias ls='ls --color=auto -hls'
alias df='df -h'
alias free='free -mhtw'
alias np='nano -w PKGBUILD'
alias more=less
alias open='xdg-open'
alias bat='bat --color=always'
alias xcopy='xclip -in -selection clipboard'
alias xpaste='xclip -out -selection clipboard'
alias code='code --disable-gpu'
