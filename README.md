# $HOME is where dotfiles are ❤️

Current I'm managing configs with [git bare](https://news.ycombinator.com/item?id=11071754) and help from [atlassian dotfiles tutorial](https://www..com/git/tutorials/dotfiles).

## Installation

```shell
curl -fsSLO https://raw.githubusercontent.com/pombadev/dotfiles/master/mero/setup.sh
bash ./setup.sh
```

## Uninstall

```shell
curl -fsSLO https://raw.githubusercontent.com/pombadev/dotfiles/master/mero/setup.sh  
bash ./setup.sh --uninstall
```

command `cx` is provided which is an alias for `git --git-dir=$HOME/dotfiles/ --work-tree=$HOME` to interface with git.

## Usage

```shell
cx add .vimrc
cx commit -m "Add vimrc"
cx push
```
