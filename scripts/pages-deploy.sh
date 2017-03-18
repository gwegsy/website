#!/bin/sh

# Based on github.com/DevProgress/onboarding

set -e
pwd
remote=$(git config remote.origin.url)

rm -rf public
HUGO_ENV=production hugo -v

mkdir gh-pages-branch
cd gh-pages-branch

git config --global user.email "deploy@coderdojonavan.ie" > /dev/null 2>&1
git config --global user.name "CoderDojoNavan Deploy" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"

if git rev-parse --verify origin/gh-pages > /dev/null 2> &1
	git checkout gh-pages
	git rm -rf .
else
	git checkout --orphan gh-pages
fi

cp -a ../public .

git add -A
git commit --allow-empty -m "Deploying to pages on `date` [ci skip]"
git push --force --quiet origin gh-pages

cd ..
rm -rf gh-pages-branch

echo "Finished deployment"
