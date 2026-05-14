#!/bin/bash
# Bootstrap eget (https://github.com/zyedidia/eget) into $EGET_BIN.
# Designed for no-sudo Linux boxes where brew isn't available.

set -euo pipefail

EGET_BIN="${EGET_BIN:-$HOME/bin}"
mkdir -p "$EGET_BIN"

if command -v eget >/dev/null 2>&1; then
    echo "eget already installed at $(command -v eget); skipping"
    exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Installing eget into $EGET_BIN"
cd "$tmpdir"
curl -fsSL https://zyedidia.github.io/eget.sh -o eget.sh
bash eget.sh
mv eget "$EGET_BIN/eget"
chmod +x "$EGET_BIN/eget"

echo "Done. Ensure $EGET_BIN is on your PATH (the tracked .zshrc already adds it)."
