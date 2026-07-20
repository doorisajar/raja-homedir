#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# upgrade installed formulae (if any)
brew upgrade

brew tap homebrew/cask

# shell utils
brew install bat
brew install exa
brew install fzf
brew install htop
brew install hyperfine
brew install micro
brew install tealdeer
brew install tmux
brew install direnv

# file utils
brew install jq
brew install yq

# programming language version managers
brew install juliaup
brew install pyenv

# this tap has become untrusted
# brew tap r-lib/rig
# brew install --cask rig

# other useful casks
brew install --cask iterm2

brew cleanup
