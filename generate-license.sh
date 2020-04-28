#! /usr/bin/env bash

cache_dir="$HOME/.cache/licenses_generator"

if [[ ! -d "$cache_dir" ]]; then
	echo "Creating cache directory in: $cache_dir"
	mkdir "$cache_dir"
else
	echo "Cache directory exit: $cache_dir"
fi

if [[ ! -f "$cache_dir/licenses.json" ]]; then
	echo "Fetching available licenses list"
	curl -s https://api.github.com/licenses > "$cache_dir/licenses.json"
else
	echo "Licenses list exist in cache directory: $cache_dir/licenses.json"
fi

license=$(jq --raw-output '.[].key' "$cache_dir/licenses.json" | fzf)

if [ -z "$license" ]; then
	echo "License not selected, cannot procceed forward"
	exit 1
fi

echo "Selected license: ${license^^}"

if [[ ! -f "$cache_dir/$license.json" ]]; then
	echo "Fetching ${license^^}"
	curl -s "https://api.github.com/licenses/$license" > "$cache_dir/$license.json"
else
	echo "${license^^} exist in cache"
fi

license_contents=$(jq --raw-output '.body' "$cache_dir/$license.json")

if [ "$license_contents" == "null" ]; then
	echo "License contents missing, please delete $cache_dir and try again"
else

	if [ "$1" == "--write-to-stdout" ]; then
		# todo remove debugging logs
		# because they are also being recirectet
		echo "$license_contents"
	else
		echo "Writing 'LICENSE-${license^^}.md' to '$(pwd)'"
		echo "$license_contents" > "LICENSE-${license^^}".md
	fi

fi
