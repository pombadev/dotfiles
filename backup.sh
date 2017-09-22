#!/usr/bin/env bash

DEST=~/Documents/dotfiles
SRC=$*

logger "[INCRON] Backing up $SRC to $DEST"

rsync -avh $SRC $DEST --delete
