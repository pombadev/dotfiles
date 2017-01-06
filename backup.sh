#!/usr/bin/env bash

DEST=Documents/backups

rsync -avh ~/.bashrc ~/$DEST --delete
rsync -avh ~/.bash_aliases ~/$DEST --delete
