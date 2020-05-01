#!/usr/bin/env bash

# shellcheck disable=SC2164

SYS_DATA_DIR=${XDG_DATA_HOME:-$HOME/.local/share}
LOOKUP_DIR=${LOOKUP_DIR:-$SYS_DATA_DIR/lookup}

readonly -A plugins=(
	[tldr]="https://github.com/tldr-pages/tldr.git"
	[eg]="https://github.com/srsudar/eg.git"
	[cheatsheets]="https://github.com/cheat/cheatsheets.git"
)

lookup::print() {
	local lang=${2:-bash}

	if command -v bat &> /dev/null; then
		bat --number --language "$lang" <<< "$1"
	else
		cat --number <<< "$1"
	fi
}

lookup::get_os() {
	 case $(uname -s) in
		Darwin)					echo "osx"		;;
		Linux)					echo "linux"	;;
		SunOS)					echo "sunos"	;;
		CYGWIN*|MINGW32*|MSYS*) echo "windows"	;;
		*)						echo "common"	;;
	esac
}

lookup::usage() {
	cat <<EFO
lookup v0.2

USAGE:
    lookup [FLAG] [OPTIONS] [query]

OPTIONS:
    -h, --help              Prints help information
    -u --update             Update databases
    --init                  [Re]Initilize \`lookup\`

FLAG:
    -b, -bro                Query data from http://bropages.org/
    -c, -cht.sh             Query data from https://cheat.sh/
    -C, -commandlinefu      Query data from https://www.commandlinefu.com
    -e, -eg                 Query data from https://github.com/srsudar/eg
    -t, -tldr               Query data from https://tldr.sh/
    -x, -cheatsheets        Query data from https://github.com/cheat/cheatsheets
EFO
}

lookup::init() {
	if [ ! -d "$LOOKUP_DIR" ]; then
		mkdir -p "$LOOKUP_DIR"
	fi

	if ! lookup::is_init; then
		(
			cd "$LOOKUP_DIR"

			for plugin in "${!plugins[@]}"; do
				if ! lookup::has_plugin "$plugin" "${plugins[$plugin]}"; then
					git clone --progress "${plugins[$plugin]}" &
				fi
			done

			wait < <(jobs -p)

			echo
		)
	else
		echo "Already initialized!"
	fi
}

lookup::has_plugin() {
	(
		cd "$LOOKUP_DIR/$1" 2> /dev/null || return 1

		test "$(git config --get remote.origin.url 2> /dev/null)" == "$2" || return 1
	)

	return $?
}

lookup::is_init() {
	local exit_code=0

	for plugin in "${!plugins[@]}"; do
		if ! lookup::has_plugin "$plugin" "${plugins[$plugin]}"; then
			exit_code=$((exit_code += 1))
		fi
	done

	return $exit_code
}

lookup::update() {
	(
		cd "$LOOKUP_DIR"

		if lookup::is_init; then
			for plugin in "${!plugins[@]}"; do
				cd "$plugin"
				echo "Updating '$plugin'"
				git pull 1> /dev/null &

				# shellcheck disable=SC2103
				cd - &> /dev/null
			done
		else
			echo "lookup is not initialized, please run \`lookup --init\`"
		fi

		wait < <(jobs -p)
	)
}

lookup::not_found() {
	printf "%s No results found for '%s'$(tput init)\n" "$(tput setaf 11)" "$*"
}

lookup::tldr() {
	cd "$LOOKUP_DIR/tldr" || echo "tldr error"
	local result

	result=$(find pages/common pages/"$(lookup::get_os)" -iname "$1.md")

	if [[ -n "$result" ]]; then
		# sed will remove
		# these: {{, }}, `
		# from the input
		lookup::print "$(sed -e 's/`\|{{\|}}//g' -e 's/^>\|^-/#/g' "$result")"
	else
		lookup::not_found "$*"
	fi
}

lookup::commandlinefu() {
	local result

	result="$(curl -s "https://www.commandlinefu.com/commands/matching/$*/$(printf "%s" "$*" | base64)/plaintext" | tail -n +3)"

	if [[ -n "$result" ]]; then
		lookup::print "$result"
	else
		lookup::not_found "$*"
	fi

}

lookup::bropages() {
	local output

	output="$(curl -s -H "Content-Type: application/json" "http://bropages.org/$*.json")"

	if [[ "$output" == "<h1>Page Not Found</h1>" ]]; then
		output="$(curl -s -H "Content-Type: application/json" "http://bropages.org/search/$*.json" | jq '.[]')"
	fi

	if [[ -z $output ]]; then
		lookup::not_found "$*"
	else
		lookup::print "$(jq -r '.[] | .msg' <<< "$output")"
	fi
}

lookup::eg() {
	cd "$LOOKUP_DIR/eg" || echo "eg error"
	local result

	result=$(find eg/examples -iname "$1.md")

	if [[ -n "$result" ]]; then
		lookup::print "$(cat "$result")" md
	else
		lookup::not_found "$*"
	fi
}

lookup::cht.sh() {
	curl -s "cheat.sh/$*" | command less -RFEN
}

lookup::cheatsheets() {
	cd "$LOOKUP_DIR/cheatsheets" || echo "cheatsheet error"

	local result

	result="$(find . -iname "$1")"

	if [[ -n "$result" ]]; then
		lookup::print "$(sed -E '/---/d' <<< "$(sed -E '/tags: \[.+\]/d' "$result")")"
	else
		lookup::not_found "$*"
	fi
}

lookup::main() {
	if ! lookup::is_init; then
		echo "lookup hasn't been initialized, initilizing..."
		lookup::init
		lookup::usage
		return 0
	fi

	if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
		lookup::usage
		return 0
	fi

	if [[ $1 == "--update" ]] || [[ $1 == "-u" ]]; then
		lookup::update
		return 0
	fi

	if [[ $1 == "--init" ]]; then
		lookup::init
		return 0
	fi

	# if [[ "$1" =~ ^(-.+?) ]]; then
	# 	echo "Passing $1"
	# fi

	while getopts "tecbCx" arg; do
		case $arg in
			t) provider=tldr; shift ;;
			b) provider=bro; shift ;;
			e) provider=eg; shift ;;
			c) provider=cht.sh; shift ;;
			C) provider=commandlinefu; shift ;;
			x) provider=cheatsheets; shift ;;
			*) return 1 ;;
		esac
	done

	if [[ $# -eq 0 ]]; then
		lookup::usage
		return 1
	fi

	provider=${provider:-tldr}

	if [[ $provider == "tldr" ]]; then
		lookup::tldr "$*"
	fi

	if [[ $provider == "commandlinefu" ]]; then
		lookup::commandlinefu "$*"
	fi

	if [[ $provider == "bro" ]]; then
		lookup::bropages "$*"
	fi

	if [[ $provider == "eg" ]]; then
		lookup::eg "$*"
	fi

	if [[ $provider == "cht.sh" ]]; then
		lookup::cht.sh "$*"
	fi

	if [[ $provider == "cheatsheets" ]]; then
		lookup::cheatsheets "$*"
	fi
}

lookup::main "$@"
