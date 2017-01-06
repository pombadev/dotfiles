#!/bin/bash

# Update master
echo -e '\nCheckout and update master\n'
git checkout master && git pull
STATUS_1=$?

# Checking out master branch for each submodules
echo -e '\nChecking out each submodules\n'
git submodule foreach --recursive git checkout master
STATUS_2=$?

# Update submodules recursively
echo -e '\nUpdating each submodules\n'
git submodule foreach --recursive git pull
STATUS_3=$?

# processor needs to be in dev branch
cd src/scripts/processor/ && git checkout dev && git pull
STATUS_4=$?

if [[ $STATUS_1 = 0 && $STATUS_2 = 0 && $STATUS_3 = 0 && $STATUS_4 = 0 ]] ; then

	read -p 'Start dev/watch/continue? <d/w/x> ' PROMPT

	if [ "$PROMPT" = 'd' ]; then
		grunt dev:dev &
	fi

	if [ "$PROMPT" = 'w' ]; then
		grunt run:dev &
	fi

	if [[ "$PROMPT" = 'x' ]]; then
		echo -e '\nEverything is up-to-date\n'
	fi
else
	notify-send 'Something is not quite right, check the terminal for more info!'
fi
