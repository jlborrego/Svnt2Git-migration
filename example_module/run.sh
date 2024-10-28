#!/bin/bash

SCRIPT_DIR=$(dirname $0)
GIT_REPO_NAME="example_module"
GIT_REPO="git@ssh.dev.azure.com:url/$GIT_REPO_NAME"

SVN_REPO_FILES=$SCRIPT_DIR/../path_fsfs_files/
ORGANIZATION="example.com"
RULES_FILE=$3

sudo rm -rf workdir tmp
ln -sf input-rules rules
$SCRIPT_DIR/../svn2git/svn2git.sh $SVN_REPO_FILES $ORGANIZATION

# Repacking git repo
cd workdir/$GIT_REPO_NAME && sudo git repack -a -d -f
cd .. && git clone --bare $GIT_REPO_NAME $GIT_REPO_NAME.git && sudo rm -rf $GIT_REPO_NAME && cd .. 

# Clean unpacked repo
sudo chmod -R 777 workdir

# Migrate repo
cd $SCRIPT_DIR/workdir/$GIT_REPO_NAME.git
LAST_BRANCH=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ | head -n 1)
# Actualiza main para que apunte a la misma referencia que la última rama
git update-ref refs/heads/main refs/heads/$LAST_BRANCH
# Configura HEAD para que apunte a main
git symbolic-ref HEAD refs/heads/main
git push --mirror $GIT_REPO

#Test repo
cd ../..
git clone $GIT_REPO $SCRIPT_DIR/tmp
cd $SCRIPT_DIR/tmp
git remote show origin

# done

cd $SCRIPT_DIR
[ -f rules ] && rm rules