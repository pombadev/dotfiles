#!/bin/bash

# Update master
echo -e '\n\e[4m\e[1mCheckout and update master\n\e[0m'
git checkout master && git pull origin master
STATUS_1=$?

# Checking out master branch for each submodules
echo -e '\n\e[4m\e[1mChecking out submodules\n\e[0m'
git submodule foreach --recursive git checkout master
STATUS_2=$?

# Update submodules recursively
echo -e '\n\e[4m\e[1mPull submodules\n\e[0m'
git submodule foreach --recursive git pull
STATUS_3=$?

#
# echo -e '\n\e[4m\e[1mUpdating submodules\n\e[0m'
# git submodule update
# STATUS_4=$?

if [[ $STATUS_1 = 0 && $STATUS_2 = 0 && $STATUS_3 = 0 && $STATUS_4 = 0 ]] ; then

	read -p 'Start dev/watch/continue? <d/w/x> ' -n 1 PROMPT

	echo -e '\n'

	if [ "$PROMPT" = 'd' ]; then
		grunt dev:local &
	fi

	if [ "$PROMPT" = 'w' ]; then
		grunt run:local &
	fi

	if [[ "$PROMPT" = 'x' ]]; then
		echo -e '\nEverything is up-to-date\n'
	fi
else
	ICON_PATH=$HOME/Documents/backups
	notify-send "Something's not right, check terminal for more info!" --icon=$ICON_PATH/warning.png
fi
