#!/usr/bin/env bash

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2164
# shellcheck disable=SC2103


PLUGINS_PATH=$HOME/.zsh/plugins
THEMES_PATH=$HOME/.zsh/themes

source "$HOME"/.zsh/lib/key-bindings.zsh # copied from oh-my-zsh
source "$PLUGINS_PATH"/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$PLUGINS_PATH"/zsh-history-substring-search/zsh-history-substring-search.zsh
source "$PLUGINS_PATH"/z/z.sh
# for more theme check $HOME/.zsh/themes
source "$THEMES_PATH"/geometry/geometry.zsh
GEOMETRY_PROMPT_PLUGINS=(exec_time git)


update_plugins() {
	recursive_pull() {

		for dir in "$1"/*; do
			cd "$dir"

			if [ -d .git ] || git rev-parse --git-dir &> /dev/null 2>&1 ; then
				git pull origin master &
			fi

			cd -
		done
	}

	recursive_pull "$PLUGINS_PATH"
	recursive_pull "$THEMES_PATH"

	unfunction recursive_pull
}
