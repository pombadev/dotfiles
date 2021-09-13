#!/usr/env bash

generate::gitignore::main() {
	local header="Accept: application/vnd.github.v3+json"
	local url="https://api.github.com/gitignore/templates"

	local selections=$(curl -s -H "$header" "$url" | jq --raw-output '.[]' | fzf --reverse --multi --preview "curl -s -H $header $url/{} | jq --raw-output '.source'")

	for selection in $selections; do
		curl -s -H "$header" "$url/$selection" | jq --raw-output '.source' >> .gitignore
	done
}

generate::gitignore::main
