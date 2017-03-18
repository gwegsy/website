#!/bin/sh

# Based on github.com/DevProgress/onboarding

set -e
pwd
remote=$(git config remote.origin.url)

user=$(git config user.name)
email=$(git config user.email)

echo -e "\nBuilding the page"
rm -rf public
HUGO_ENV=production hugo -v

echo -e "\nClearing the gh-pages-branch directory"
rm -rf gh-pages-branch
mkdir gh-pages-branch
cd gh-pages-branch

echo -e "\nChanging the default git user"
git config --global user.email "deploy@coderdojonavan.ie" > /dev/null 2>&1
git config --global user.name "CoderDojoNavan Deploy" > /dev/null 2>&1

echo -e "\nIntializing new deployment git repo"
git init
git remote add --fetch origin "$remote"

if git rev-parse --verify origin/gh-pages > /dev/null 2>&1
then 
	git checkout gh-pages
	rm -rf ./*
else
	git checkout --orphan gh-pages
fi

echo -e "\nCloning pages"
cp -a ../public/* ./

git add -A
git commit --allow-empty -m "Deploying to pages on `date` [ci skip]"
git push --force --quiet origin gh-pages

echo -e "\nCleaning up..."
cd ..
rm -rf gh-pages-branch
git config --global user.email "$email" > /dev/null 2>&1
git config --global user.name "$user" > /dev/null 2>&1

echo -e "\n\nFinished deployment"
