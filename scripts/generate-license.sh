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
