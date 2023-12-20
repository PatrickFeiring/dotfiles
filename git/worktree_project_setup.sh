#!/usr/bin/env bash
set -e

url=$1
basename=${url##*/}
name=${2:-${basename%.*}}

echo $url
echo $basename
echo $name
exit 0

git clone --bare "$1" .bare
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch origin

git worktree add main
git worktree add review
git worktree add hotfix
