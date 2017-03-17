#!/bin/sh
DIR=$(dirname $0)

cd $DIR/..

if [[ $(git status -s) ]]
then
	echo "The working directory is dirty. Please commit any pending changes"
	exit 1;
fi

echo "Deleting old publications"
rm -rf public
mkdir public
git workspace prune
rm -rf .git/worktrees/public

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public upstream/gh-pages

echo "Removing exisiting files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages"

git push origin gh-pages -f
