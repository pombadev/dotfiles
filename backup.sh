#!/usr/bin/env bash

DEST=~/Documents/backups
SRC=$*

logger "[INCRON] Backing up $SRC to $DEST"

rsync -avh $SRC $DEST --delete
