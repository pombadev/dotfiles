#!/usr/env bash

# linting via shellcheck
# shellcheck disable=SC2096,SC2155

branch() {
	git rev-parse --abbrev-ref HEAD
}

gsm() {
	git submodule foreach --recursive git "$@"

	echo -e '\n\e[32m\e[1mExecuted:\e[0m git submodule foreach --recursive git' "$@" '\n'
}

stash-explore() {
	# git stash list | cut -d \  -f1 | grep -Eo 'stash@{[0-9]{1,}}' | fzf --reverse --preview-window=70% --preview 'git stash show -p {} | diff-so-fancy'
	# git stash list |
	#    fzf --reverse --preview-window=70% --preview 'bat -l diff <<< $(git stash show -p $(echo {} | grep -Eo "stash@{[0-9]{1,}}"))' |
	#    grep --color=none -Eo 'stash@{[0-9]{1,}}'
	local stash=$(git stash list | cut -d \  -f1 | grep -Eo 'stash@{[0-9]{1,}}' | fzf --reverse --preview-window=70% --preview 'bat --color=always --style=numbers <<< `git stash show -p {}`')

	if [[ -n "$stash" ]]; then
		git stash apply "$stash"
	fi
}

clean-git-branches() {
	git branch | grep -E -v "(^\s+dev$|^\s+master|^\*.+$)" | xargs --no-run-if-empty git branch -D
}

# gcp - git commit with previews
gcp() {
	local _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
	local _viewGitLogLine="$_gitLogLineToHash | xargs --no-run-if-empty -I % sh -c"
	local differ="git show --color=always %"

	if command -v &>/dev/null; then
		differ=" | diff-so-fancy"
	fi

	git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" | fzf --no-sort --reverse --tiebreak=index --no-multi --ansi --preview "$_viewGitLogLine '$differ'"
}

qs() {
	local BRANCH=$(shuf /usr/share/dict/words -n 1 | sed "s/'//g")
	git checkout -b "wip/${BRANCH}"
}

# Get running process that matches the passed argument
# If none provided, will show all running processes.
po() {
	# shellcheck disable=SC2009
	ps -aef | grep -i "$1"
}

# String comparison
str-eq() {
	if [[ $1 == "$2" ]]; then
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
	if [[ $SHELL =~ 'zsh' ]]; then
		set -o noglob
	elif [[ $SHELL =~ 'bash' ]]; then
		set -o localoptions -o noglob
	fi

	echo Answer: "$(echo "scale=3; $*" | /usr/bin/bc -l)"
}

# Either check for internet connectivity or does speedtest
st() {
	if command -v librespeed-cli &>/dev/null; then
		librespeed-cli --bytes
	elif command -v speedtest-cli &>/dev/null; then
		speedtest-cli --bytes --no-upload
	else
		ping -c 3 google.com
	fi
}

# restart network manager
rnet() {
	distro=$(grep -e '^NAME=' /etc/os-release | cut -d '=' -f2 | sed s/\"//g | tr '[:upper:]' '[:lower:]')

	case $distro in
	'manjaro linux' | 'arch linux')
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
		grep -E --exclude="yarn.lock" --exclude-dir={.git,.history,node_modules,bower_components,out,vendor,flow-typed,build,coverage} -irHn --color=auto "$1" "$2"
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

fkill() {
	# shellcheck disable=SC2155
	local PID=$(
		ps -aux |
			sed 1d |
			fzf --sync \
				--border \
				--prompt='⚙ ' \
				--reverse \
				--multi \
				--preview 'echo {} | column -t | cut -d\  -f 3 | xargs --no-run-if-empty pstree -h ' |
			awk '{print $2}'
	)

	[[ -n $PID ]] && echo "$PID" | xargs --no-run-if-empty kill -SIGTERM
}

fzf-preview-file() {
	rg --files | fzf --reverse --preview 'bat --color=always {}'
}

fzf-grep() {
	# local xxx="echo {} | egrep -io '^\\|\..+:' | xargs -I % sh -c 'cat'"

	# shellcheck disable=SC2155
	local match=$(grep -r -nEHI '[[:alnum:]]' "." --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor,flow-typed} | fzf --reverse --cycle)

	if [[ -n $match ]]; then
		local file
		local line

		IFS=: read -r file line _ <<<"$match"

		# subl "$file":"$line" < /dev/tty
		code --goto "$file":"$line" </dev/tty
	fi
}

npm-scripts() {
	local script

	if command -v jq &>/dev/null; then
		script=$(jq --monochrome-output --raw-output '.scripts | keys[]' package.json | fzf --reverse)
	else
		script=$(node -e "try { Object.keys(require('./package.json').scripts).forEach(script => console.log(script)) } catch {}" | fzf --reverse)
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

serve() {
	if [[ $(python -V) == Python[[:space:]]3.* ]]; then
		python -m http.server
	elif [[ $(python -V) == Python[[:space:]]2.* ]]; then
		python -m SimpleHTTPServer
	fi
}

print-colors() {
	for i in {0..256}; do
		printf "%s %s" "$(tput setaf "$i")" "$i"
		[[ $i == 256 ]] && echo
	done
}

man2pdf() {
	local app=$1
	local DEST=${2:-$HOME/Documents}

	if command man -w "$app" 1>/dev/null; then
		command man -Tpdf "$app" >"$DEST/$app.pdf"

		printf "'%s' saved in '%s' \n" "$app.pdf" "$DEST"

	else
		echo -n "Do you want to generate pdf from '$app --help'\n"

		select yn in "y" "n"; do
			case $yn in
			y)
				echo "Running: 'man -Tpdf -l - <<< rg --help > ~/$DEST/$app.pdf'"
				man -Tpdf -l - <<<"$($app --help)" >"$DEST/$app.pdf"
				break
				;;
			n)
				break
				;;
			esac
		done
	fi
}

update-pkgs() {
	if \command -v yay &>/dev/null; then
		yay -Syu --noconfirm

	elif \command -v paru &>/dev/null; then
		paru -Syu --noconfirm
	fi

	if \command -v snap &>/dev/null; then
		sudo snap refresh
	fi

	if \command -v flatpak &>/dev/null; then
		flatpak update --noninteractive
	fi
}

purge-pkgs() {
	if \command -v flatpak &>/dev/null; then
		flatpak uninstall --unused
	fi

	if \command -v snap &>/dev/null; then
		snap list --all | while read -r snapname _ rev _ _ notes; do
			if [[ $notes == *disabled* ]]; then
				sudo snap remove "$snapname" --revision="$rev"
			fi
		done
	fi

	if \command -v pacman &>/dev/null; then
		# shellcheck disable=SC2155
		local pkgs=$(pacman -Qttdq)
		if [[ -n $pkgs ]]; then
			# quoting will break things
			# shellcheck disable=SC2046
			sudo pacman -Rnsc $(tr '\n' ' ' <<<"$pkgs")
		else
			echo "pacman: No packages to remove"
		fi
	fi
}

rscript() {
	temp_file=$(mktemp)

	cat <<EOF >"$temp_file"
fn main() {
    $1;
}
EOF

	new_temp=$(mktemp)

	# rustc --verbose -C opt-level=z -C panic=abort -C lto -C codegen-units=1 "$temp_file" -o "$new_temp"
	rustc "$temp_file" -o "$new_temp"

	(cd /tmp && "$new_temp")

	rm "$temp_file" "$new_temp"
}

if go env &>/dev/null; then
	gobin() {
		local GO_PATH=$(go env | grep GOPATH | grep -o '"[^"]\+"' | sed -e 's/"//g')

		case $1 in
		l | list)
			find "$GO_PATH"/bin -type f -exec basename {} \;
			;;

		r | remove)
			if [ -z "$2" ]; then
				echo "value cannot be empty"
				return 1
			fi

			local BIN="$GO_PATH/bin/$2"

			if [ -f "$BIN" ]; then
				rm "$BIN"
			else
				echo "$BIN does not exist"
			fi

			;;
		*)
			printf "gobin: unknown command\navailable commands:\n  list\n  remove\n"
			return 1
			;;
		esac
	}
fi

update-git-submodules() {
	# shellcheck disable=SC2016
	git submodule foreach --recursive 'git checkout $(git remote show origin | grep -ie "HEAD branch:" | cut -d " " -f5); git pull; echo -e "\n"'
}

touch() {
	local parent_dir=$(dirname "$1")

	if ! [ -d "$parent_dir" ]; then
		mkdir -p "$parent_dir"
	fi

	$(which --skip-alias --skip-functions touch) "$1"
}

top-commands() {
	count=${1:-20}
	fc -l 1 | awk '($2 !~ "^\\./") { CMD[$2]++; count++; } END { for (a in CMD) { printf ("%4d %5.1f%% %s\n",CMD[a],CMD[a]/count*100,a); } }' | sort -nr | head -n"$count" | nl
}

d() {
	cd "$1" || return 1

	if [ -d "_opam" ] || [ -d "esy.lock" ] && [ -f "dune" ] || [ -f "dune-project" ]; then
		eval "$(opam env)"
	fi
}

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

jrepl () {
	if [[ -t 0 ]]; then
		echo '' | fzf --disabled --print-query --preview "jq --color-output {q} $1" --preview-window='up:99%'
	else
		temp=$(mktemp)
		cat "$@" | tee "$temp" &> /dev/null
		echo '' | fzf --disabled --print-query --preview "jq --color-output {q} $temp" --preview-window='up:99%'
		rm "$temp"
	fi
}

generate-license () {
	local cache_dir="$HOME/.cache/licenses_generator"

	if [[ ! -d "$cache_dir" ]]; then
		echo "Creating cache directory in: $cache_dir"
		mkdir "$cache_dir"
	else
		echo "Cache directory exit: $cache_dir"
	fi

	if [[ ! -f "$cache_dir/licenses.json" ]]; then
		echo "Fetching available licenses list"
		curl -s https://api.github.com/licenses >"$cache_dir/licenses.json"
	else
		echo "Licenses list exist in cache directory: $cache_dir/licenses.json"
	fi

	licenses=$(jq --raw-output '.[].key' "$cache_dir/licenses.json" | fzf --tac --multi --reverse)

	if [ -z "$licenses" ]; then
		echo "License(s) not selected, cannot proceed forward"
		exit 1
	fi

	printf "Selected license(s):\n%s" "${licenses^^}"

	for license in $licenses; do
		if [[ ! -f "$cache_dir/$license.json" ]]; then
			echo "Fetching ${license^^}"
			curl -s "https://api.github.com/licenses/$license" >"$cache_dir/$license.json"
		else
			echo "${license^^} exist in cache"
		fi

		license_contents=$(jq --raw-output '.body' "$cache_dir/$license.json")

		if [ "$license_contents" == "null" ]; then
			echo "License contents missing, please delete $cache_dir and try again"
		else
			echo "Writing 'LICENSE-${license^^}' to '$(pwd)'"
			echo "$license_contents" >"LICENSE-${license^^}"

		fi
	done
}

generate-gitignore() {
	local base_url="https://www.toptal.com/developers/gitignore/api"
	local list_url="$base_url/list?format=lines"

	local selections=$(curl -s "$list_url" | fzf --reverse --multi --preview "curl -s $base_url/{}")

	for selection in $selections; do
		curl -s "$base_url/$selection" >> .gitignore
	done
}
