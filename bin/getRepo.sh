#!/bin/sh

#######
#  Change for actual use
#######
USER="McSquibbly"

#######
# ensures repository is specified
#######
function usage {
	echo "Usage: getRepo.sh <repository> <FINAL_LOCATION>"
}

if [ "$1" == "" ]
then
	usage
	exit 1
fi

if [ "$2" == "" ]
then
	usage
	exit 1
fi

#########
#	setting cmd args
#########
FINAL_LOCATION=$2
REPOSITORY=$1

#########
#	junk directory for holding git info
#########
echo "Creating junk directory"
mkdir -p /tmp/junk

#########
#	move to junk directory
#########
echo "Moving to junk directory"
cd /tmp/junk

#########
#	Downloading repo
#########
echo "git clone http://github.com/'$USER'/'$REPOSTORY'.git"
git clone http://github.com/$USER/$REPOSITORY.git
repo=/tmp/junk/$REPOSITORY

#########
#	Checking if repo exists
#########

if [ -d /tmp/junk/$1 ]; then
	echo "Successfully downloaded $REPOSITORY"
	echo "Moving to $repo"
	cd $repo
else
	echo "ERROR: Unable to download $REPOSITORY"
	exit 1
fi


##	Moves repository to specified directory and extracts it
git archive --format=tar --prefix=$REPOSITORY/ HEAD | (cd $FINAL_LOCATION && tar xf -)
cd /tmp
echo "Deleting temp files..."
rm -Rf junk
cd $FINAL_LOCATION
echo "Done"
