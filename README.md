# ❤️ is where $HOME is

## Setup

```shell
git init --bare $HOME/dotfiles/
alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
```

## Usage

```shell
config status
config add .vimrc
config commit -m "Add vimrc"
config add .config/redshift.conf
config commit -m "Add redshift config"
config push
```

## For new machine

```shell
git clone --separate-git-dir=~/dotfiles /path/to/repo ~
```

## If files already exist

```shell
git clone --separate-git-dir=$HOME/dotfiles /path/to/repo $HOME/myconf-tmp
cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
rm -r ~/myconf-tmp/
alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
```


> Taken all from: https://news.ycombinator.com/item?id=11071754
