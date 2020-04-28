#!/usr/bin/env bash

SYS_DATA_DIR=${XDG_DATA_HOME:-$HOME/.local/share}
LOOKUP_DIR=${LOOKUP_DIR:-$SYS_DATA_DIR/lookup}

if [ ! -d "$LOOKUP_DIR" ]; then
	mkdir -p "$LOOKUP_DIR"
fi

lookup::print() {
	lang=${2:-bash}

	if command -v bat &> /dev/null; then
		bat --number --language "$lang" <<< "$1"
	else
		cat --number <<< "$1"
	fi
}

lookup::os() {
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
    lookup [OPTIONS] [query]

OPTIONS:
    -h, --help              Prints help information
    -b, -bro                Query data from http://bropages.org/
    -ch, -cht.sh            Query data from https://cheat.sh/
    -cf, -commandlinefu     Query data from https://www.commandlinefu.com
    -e, -eg                 Query data from https://github.com/srsudar/eg
    -t, -tldr               Query data from https://tldr.sh/
    -cs, -cheatsheets       Query data from https://github.com/cheat/cheatsheets
EFO
}

lookup::init() {
	(
		cd "$LOOKUP_DIR" 2> /dev/null || {
			echo "$LOOKUP_DIR doesnt exist, run \`lookup --repair\`."
			exit 1
		}

		git clone https://github.com/tldr-pages/tldr.git &> /dev/null &

		tldr_pid=$!

		git clone https://github.com/srsudar/eg.git &> /dev/null &

		eg_pid=$!

		git clone https://github.com/cheat/cheatsheets.git &> /dev/null &

		cheatsheet_pid=$!


		echo "Caching tldr, eg, cheatsheet..."
		wait $tldr_pid $eg_pid $cheatsheet_pid
	)
}

lookup::tldr() {
	cd "$LOOKUP_DIR/tldr" || echo "tldr error"
	# find pages/* -iname "$1.md" -exec bat --number {} \;
	local result

	result=$(find pages/common pages/"$(lookup::os)" -iname "$1.md")

	if [[ -n "$result" ]]; then
		# sed will remove {{, }}, ` from the input
		lookup::print "$(sed -e 's/`\|{{\|}}//g' -e 's/^>\|^-/#/g' "$result")"
	else
		echo "no results"
	fi
}

lookup::commandlinefu() {
	encode() {
		python -c 'import base64, sys; print(base64.b64encode("{0}".format(sys.argv[1]).encode()).decode())' "$@"
	}

	lookup::print "$(curl -s "https://www.commandlinefu.com/commands/matching/$*/$(encode "$@")/plaintext" | tail -n +3)"
}

lookup::bropages() {
	local output
	output="$(curl -f -s -H "Content-Type: application/json" "http://bropages.org/$*.json")"

	if [[ -z $output ]]; then
		output="# '$*' not found"
	else
		output="$(jq -r '.[] | .msg' <<< "$output")"
	fi

	lookup::print "$output"
}

lookup::eg() {
	cd "$LOOKUP_DIR/eg" || echo "eg error"
	local result

	result=$(find eg/examples -iname "$1.md")

	if [[ -n "$result" ]]; then
		lookup::print "$(cat "$result")" md
	else
		echo "no results"
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
		echo "no results"
	fi
}

lookup() {
	if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
		lookup::usage
		return 1
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

	provider=${provider:-tldr}

	if [[ $# -eq 0 ]]; then
		lookup::usage
		return 1
	fi

	if [[ $(command ls "$LOOKUP_DIR" | wc -l) -eq 0 ]]; then
		echo "lookup hasn't been initilized, initilizing..."
		lookup::init
	fi

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

lookup "$@"
