# $HOME is where dotfiles are ❤️

Current I'm managing configs with [git bare](https://news.ycombinator.com/item?id=11071754) and help from [atlassian dotfiles tutorial](https://www..com/git/tutorials/dotfiles).

## Installation

```shell
curl -fsSLO https://raw.githubusercontent.com/pombadev/.files/main/mero/installer.sh
bash ./installer.sh
```

command `cx` is provided which is an alias for `git --git-dir=$HOME/dotfiles/ --work-tree=$HOME` to interface with git.

## Usage

```shell
cm add .vimrc
cm commit -m "Add vimrc"
cm push
```
