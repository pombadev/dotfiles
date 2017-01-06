#!/bin/bash

# GREP for string provided by user in a
# user defined or predefined directory
# First parameter string to search for
# Second parameter path to search in

# Exit if no/whitespace search string provided, exit.
# There's no point continuing.
if [[ -z $1 ]]; then
	echo 'Required argument not provided, exiting...'
	exit 1
fi

DEFAULT_DIR=src/scripts/

function GREP_ME() {
	grep --exclude-dir={.git,node_modules,bower_components} -irHn --color=auto "$1" "$2"
}

# If search string is provided but no directory, use default
if [[ ! $2 ]] ; then
	if [[ -d $DEFAULT_DIR ]]; then
		GREP_ME "$1" $DEFAULT_DIR
	else
		# DEFAULT_DIR doesn't exist use pwd
		GREP_ME "$1" "$PWD"
	fi
# both search string and directory specified use them
else
	GREP_ME "$1" "$2"
fi
