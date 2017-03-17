#!/bin/sh
DIR=$(dirname $0)

cd $DIR/..

if [[ $(git status -s) ]]; then
	echo "The working directory is dirty. Please commit any pending changes"
	exit 1;
fi

echo "Deleting old publications"
rm -rf public
mkdir public

echo "Checking out gh-pages branch into public"
git clone .git --branch gh-pages public

echo "Removing exisiting files"
rm -rf public/*

echo "Generating site"
HUGO_ENV=production hugo -v

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages"

git push origin gh-pages -f
