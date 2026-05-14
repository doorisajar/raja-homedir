This is my repository of personal dotfiles used at work and home. 

# Basic usage
- remove old dotfiles
- `make install` (Mac, or Linux with sudo + brew)
- manually install `.zshrc` dependencies
- `omz reload`
- (optional) `make configs` to copy installable config files

## No-sudo Linux flow

On a fresh Linux box where `brew`/`apt` aren't available:

1. `make eget` — bootstrap `eget` into `~/bin`
2. `make eget-tools` — install common binaries (bat, eza, fzf, ripgrep, jq, yq, delta, gh, direnv, micro, hyperfine, tealdeer) via eget, skipping any already on PATH
3. `make dotfiles` — copy tracked dotfiles into `$HOME`

Some contents of `configs` are files that (for now) require manual installation, such as the iTerm2 JSON config. 

# TODOs
- list or detect `.zshrc` dependencies
- consider migrating to chezmoi

# make targets
- `install`: install all deps and copy dotfiles to the homedir
- `check`: compare these dotfiles to the ones in the homedir
- `colorcheck`: run `check` and print the diff in color
- `getlatest`: copy the current dotfiles from homedir
- `echo`: print the list of target file paths
- `brew`: install `homebrew` and various utilities
- `omz`: install `oh-my-zsh`
- `eget`: bootstrap `eget` into `~/bin` (no sudo required)
- `eget-tools`: install common CLI binaries via eget, skipping any already on PATH
- `dotfiles`: copy the dotfiles to their target paths

Pieces are adapted from multiple sources: 

- https://github.com/kenahoo/dotfiles
- https://github.com/zellwk/dotfiles
- https://github.com/evert/dotfiles
