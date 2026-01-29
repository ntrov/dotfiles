#!/usr/bin/env bash
# Install Cursor extensions from extensions.txt (run after restore-configs.sh on a new machine)
# Run from: ~/dotfiles/

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
LIST="$DOTFILES/cursor/extensions.txt"

if [ ! -f "$LIST" ]; then
  echo "==> $LIST not found. Run backup-configs.sh first to create it."
  exit 1
fi

if ! command -v cursor &>/dev/null; then
  echo "==> 'cursor' not in PATH. Install Cursor and try again."
  exit 1
fi

echo "==> Installing Cursor extensions from $LIST"
cat "$LIST" | xargs -L 1 cursor --install-extension
echo "==> Done."
