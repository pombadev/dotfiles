# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s globstar #  pattern ** used in a path name expansion
shopt -s autocd
shopt -s extglob #  extended pattern matching
shopt -s histappend #  append to history file specifed by `HISTFILE`
shopt -s cmdhist # save all lines of a multiple-line command in the same history entry
shopt -s lithist # multi-line commands are saved to the history with embedded newlines

# unlimited bash history & history file size
export HISTFILESIZE=
export HISTSIZE=

[[ $DISPLAY ]] && shopt -s checkwinsize

# need to install `bash-completion` package
[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

source ~/dotfiles/aliases.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

eval "$(starship init bash)"

ble-bootstrap() {
	opt=$1

	is-ble-installed() {
		(
			if [ -d ~/dotfiles/bash/ble.sh ]; then
				cd ~/dotfiles/bash/ble.sh
				if  [ -f .git ] && [ $(git remote get-url origin) == "https://github.com/akinomyoga/ble.sh.git" ]; then
					return 0
				fi
			fi

			return 1
		)
	}

	if [[ "$opt" == "i" ]] || [[ "$opt" == "install" ]]; then
		(
			if ! is-ble-installed; then
				cd ~/dotfiles/bash
				git submodule add https://github.com/akinomyoga/ble.sh.git
				cd ble.sh
				make
			else
				echo "'ble.sh' is already installed."
			fi

		)
	elif [[ $opt == "u" ]] || [[ $opt == "update" ]]; then
		(
			if is-ble-installed && ((_ble_bash)); then
				cd ~/dotfiles/bash/ble.sh
				git pull origin master
				make
			fi
		)
	fi

	if [[ $- == *i* ]]; then
		source ~/dotfiles/bash/ble.sh/out/ble.sh --noattach --rcfile ~/dotfiles/bash/.blerc
		((_ble_bash)) && ble-attach
	fi
}

ble-bootstrap
