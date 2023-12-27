This is my repository of personal dotfiles used at work and home. 

# Basic usage
- remove old dotfiles
- `make install`
- manually install `.zshrc` dependencies
- `omz reload`
- (optional) `make configs` to copy installable config files

Some contents of `configs` are files that (for now) require manual installation, such as the iTerm2 JSON config. 

# TODOs
- list or detect `.zsrhc` dependencies
- don't assume `macos` in `.zshrc` since we might be on Linux

# make targets
- `install`: install all deps and copy dotfiles to the homedir
- `check`: compare these dotfiles to the ones in the homedir
- `colorcheck`: run `check` and print the diff in color
- `getlatest`: copy the current dotfiles from homedir
- `echo`: print the list of target file paths
- `brew`: install `homebrew` and various utilities
- `omz`: install `oh-my-zsh`
- `dotfiles`: copy the dotfiles to their target paths

Pieces are adapted from multiple sources: 

- https://github.com/kenahoo/dotfiles
- https://github.com/zellwk/dotfiles
- https://github.com/evert/dotfiles
