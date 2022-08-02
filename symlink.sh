#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd dotfiles

# Build up a list of all the dotfiles (ignoring .git and .gitignore)
dotfiles=()
for f in $(find . -maxdepth 1 -name ".[^.]*" -exec basename {} \; | \
    grep -vE ".git(ignore)?$"); do
  dotfiles+=("$f")
done

echo
echo Symlinking the following dotfiles: $dotfiles
echo Existing files will be backed up with the .old extension

for f in "${dotfiles[@]}"; do
  # Back it up if it already exists
  if [[ -f ~/$f ]]; then
    cp -f ~/$f ~/$f.old
  elif [[ -d ~/$f ]]; then
    cp -rf ~/$f ~/$f.old
  fi
  # And symlink it to the relative directory!
  abs_path=$("$DIR/dotfiles/bin/readlink-f" "$f")
  rel_path="${abs_path#$HOME/}"
  ln -sf $rel_path ~/$f
done

echo
echo Completed symlinking
