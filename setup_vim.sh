#/usr/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

if command -v vim &> /dev/null; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	ln -s $PROJECT_ROOT/.config/nvim/init.vim $HOME/.vimrc
fi

if command -v nvim &> /dev/null; then
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	mkdir -p $HOME/.config/nvim/

	ln -s $PROJECT_ROOT/.config/nvim/init.vim $HOME/.config/nvim/
fi

unset no_plugged_dir
