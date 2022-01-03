#!/usr/env bash

generate::gitignore::main() {
	local base_url="https://www.toptal.com/developers/gitignore/api"
	local list_url="$base_url/list?format=lines"

	local selections=$(curl -s "$list_url" | fzf --reverse --multi --preview "curl -s $base_url/{}")

	for selection in $selections; do
		curl -s "$base_url/$selection" >> .gitignore
	done
}

generate::gitignore::main
