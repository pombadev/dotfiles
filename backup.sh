#!/usr/bin/env bash

DEST=~/Documents/backups
SRC=$*

logger "[INCRON] Backuping $SRC to $DEST"

rsync -avh $SRC $DEST --delete
