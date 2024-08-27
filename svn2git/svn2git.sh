#!/bin/bash
set -e

SCRIPT_DIR="$(dirname $0)"

# Checking inputs
if [ -z $1 ]; then echo "USAGE: $(basename $0) <svn repo path> [domain]"; exit 2; fi
if [ ! -d $1 ]; then echo "First argument has to be an existing directory"; exit 2; fi
SVN_REPO=$(realpath $1)
if [ ! -f rules ]; then echo "Rules file not found!"; exit 2; fi

# If authors file is present then we add it to the command
if [ -f authors ]; then 
    echo "Found authors file!"
    AUTHORS="--identity-map /tmp/conf/authors"
elif [ -z $2 ]; then 
    echo "You must specify domain or authors file"
    exit
else
    DOMAIN="--identity-domain $2"
    echo "Repo domain: $2"
fi

echo "Ready to import $SVN_REPO"

# Generating folders
[ ! -d workdir ] && mkdir workdir

# Calling svn2git docker
docker run --rm -it \
    -v $(pwd)/workdir:/workdir \
    -v $SVN_REPO:/tmp/svn \
    -v $(pwd):/tmp/conf \
    svn2git \
        /usr/local/svn2git/svn-all-fast-export \
        $AUTHORS \
        $DOMAIN \
        --rules /tmp/conf/rules \
        --add-metadata \
        --svn-branches \
        --debug-rules \
        --svn-ignore \
        --empty-dirs \
        /tmp/svn/
