#!/bin/bash
# Install commonly-used CLI binaries via eget.
# Skips any tool already on PATH so admin-installed versions win.

set -euo pipefail

EGET_BIN="${EGET_BIN:-$HOME/bin}"
export EGET_BIN
mkdir -p "$EGET_BIN"

if ! command -v eget >/dev/null 2>&1 && [[ ! -x "$EGET_BIN/eget" ]]; then
    echo "eget not found. Run 'make eget' first." >&2
    exit 1
fi

EGET="$(command -v eget || echo "$EGET_BIN/eget")"

# Each entry: <github-repo> <binary-name>
# binary-name is what we test for on PATH; it may differ from repo name.
TOOLS=(
    "sharkdp/bat bat"
    "eza-community/eza eza"
    "junegunn/fzf fzf"
    "BurntSushi/ripgrep rg"
    "jqlang/jq jq"
    "mikefarah/yq yq"
    "dandavison/delta delta"
    "cli/cli gh"
    "direnv/direnv direnv"
    "zyedidia/micro micro"
    "sharkdp/hyperfine hyperfine"
    "tealdeer-rs/tealdeer tldr"
)

for entry in "${TOOLS[@]}"; do
    repo="${entry% *}"
    binary="${entry#* }"
    if command -v "$binary" >/dev/null 2>&1; then
        echo "  [skip]    $binary already on PATH at $(command -v "$binary")"
    else
        echo "  [install] $binary from $repo"
        "$EGET" "$repo"
    fi
done

# fzf shell integration: write keybindings/completion to ~/.fzf.zsh.
# The tracked .zshrc sources this file if present.
if command -v fzf >/dev/null 2>&1; then
    if fzf --zsh >/dev/null 2>&1; then
        fzf --zsh > "$HOME/.fzf.zsh"
        echo "  [setup]   wrote fzf zsh integration to ~/.fzf.zsh"
    fi
fi

# Note: git-extras is a shell-script collection, not a release binary,
# so it isn't installable via eget. Install manually if needed:
#   git clone https://github.com/tj/git-extras ~/src/git-extras
#   cd ~/src/git-extras && PREFIX=$HOME/.local make install
