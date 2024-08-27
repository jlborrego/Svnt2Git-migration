#!/bin/bash

set -e

[ -z "$1" ] || USER="$1"
BDB="repo-obj"
FSFS="repo-obj-fsfs"
SCRIPT_DIR="$(dirname $0)"


# Get regenerated FSFS repo
rsync -av $USER@repo:/home/svn/$BDB/ $SCRIPT_DIR/$FSFS
