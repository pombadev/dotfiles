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
	grep --exclude="yarn.lock" --exclude-dir={.git,node_modules,bower_components,out,vendor} -irHn --color=auto "$1" "$2"
}

# If search string is provided but no directory, use default
# CD-ing to search in the PWD because tilix custom link doesn't
# work if path is not absolute
if [[ ! $2 ]] ; then
	if [[ -d $DEFAULT_DIR ]]; then
		cd $DEFAULT_DIR
		# All's good, continue
		GREP_ME "$1" "$PWD"
	elif [[ -d scripts/ ]]; then
		cd scripts/
		# Try scripts/
		GREP_ME "$1" "$PWD"
	else
		# DEFAULT_DIR & scripts/ doesn't exist use pwd
		GREP_ME "$1" "$PWD"
	fi
# both search string and directory specified use them
else
	cd "$2"
	GREP_ME "$1" "$PWD"
fi
