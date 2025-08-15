#!/usr/bin/env bash

set -e

url='https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz'

cd ~/Downloads
curl -OL $url
xattr -c ./nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
cd -

rm -f ~/.local/bin/nvim-nightly
ln -s ~/Downloads/nvim-macos-arm64/bin/nvim ~/.local/bin/nvim-nightly
