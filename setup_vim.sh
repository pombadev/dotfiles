#/usr/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

no_plugged_dir() {
	local ITEMS=($HOME/.config/nvim/plugged/*)

	[ ${#ITEMS[@]} -lt 0 ]
}

if command -v vim &> /dev/null; then
	if no_plugged_dir; then
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

		ln -s $PROJECT_ROOT/.config/nvim/init.vim $HOME/.vimrc
	else
		echo "Already configured for vim"
	fi
fi

if command -v nvim &> /dev/null; then
	if no_plugged_dir; then
		curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

		mkdir -p $HOME/.config/nvim/

		ln -s $PROJECT_ROOT/.config/nvim/init.vim $HOME/.config/nvim/
	else
		echo "Already configured for nvim"
	fi
fi

unset no_plugged_dir
