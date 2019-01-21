#!/usr/bin/env bash

DEST=$HOME/Documents/dotfiles
SRC=$*

echo "[$(date +'%a %d %b %Y  %r')] Backing up $SRC to $DEST" > /home/pomba/Desktop/backup.log

rsync -avh "$SRC" $DEST --delete
