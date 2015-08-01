#!/bin/bash
# processBrackets.sh
# Version 1.0 (May 19 2010)
# Author: Vincent Tassy <photo@tassy.net>
# Site: http://linuxdarkroom.tassy.net
# This script is released under a CC-GNU GPL License

# A bash script to process sorted bracket directories in one shot

# Changelog
#
# Version 1.0
#	first public release

SELF=`basename $0`	# Ouselve
DIR=""
USEKDE=0		# command line invocation by default
QUIET=0			# not too quiet either ;-)
DIRPREFIX="HDR"		# created directories prefix, i.e. HDR1, HDR2, ...

displayHelp() {
	echo "Process sorted bracket directories."
	echo
	echo "Usage: $SELF [OPTION] DIR"
	echo -e "  --quiet   -q\tQuiet"
	echo -e "  --kde     -k\tDisplay progress with kdialog"
	echo
	echo "Report bugs to <photo@tassy.net>"
}

# test params
while [ "$1" != "" ]; do
	case "$1" in
		"--help" | "-h")
			displayHelp
			exit
			;;
		"--kde")
			USEKDE=1
			;;
		"--quiet" | "-q")
			QUIET=1
			;;
		*)
			DIR=$1
			;;
	esac
	shift
done

if [ -z $DIR ]; then
	displayHelp
	exit
fi

if [ ! -d "$DIR" ]; then
	echo "$DIR is not a valid directory"
	displayHelp
	exit
fi

DIR=$(cd "$DIR" && pwd) #transform to absolute path
DIRS=(`find $DIR -type d -regex ".*/HDR[0-9]+"`)
DIRNUMS=${#DIRS[@]}

if [ $USEKDE = 1 ]; then
	QUIET=1
	tmpfile=`mktemp`
	dbusRef4Dirs=`kdialog --title "Process sorted bracket directories" --progressbar "Initialising" $DIRNUMS`
fi

for (( i = 0 ; i < $DIRNUMS ; i++ )); do
	if [ $USEKDE = 1 ]; then
		qdbus $dbusRef4Dirs setLabelText "Processing stack $(($i+1)) of $DIRNUMS"
		createHDR.sh -a -k ${DIRS[$i]}
		qdbus $dbusRef4Dirs Set "" "value" $i
	elif [ $QUIET = 1 ]; then
		createHDR.sh -a -q ${DIRS[$i]}
	else
		createHDR.sh -a ${DIRS[$i]}
	fi
done

if [ $USEKDE = 1 ]; then
	qdbus $dbusRef4Dirs Set "" "value" $DIRNUMS
	qdbus $dbusRef4Dirs close
fi