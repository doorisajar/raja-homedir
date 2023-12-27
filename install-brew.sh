#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# upgrade installed formulae (if any)
brew upgrade

brew tap homebrew/cask

# shell utils
brew install exa
brew install tmux
brew install micro
brew install tldr

# file utils
brew install jq
brew install yq

# programming language version managers
brew install pyenv
brew install juliaup

brew tap r-lib/rig
brew install --cask rig

brew cleanup
