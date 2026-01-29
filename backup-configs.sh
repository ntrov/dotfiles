#!/usr/bin/env bash
# Backup Cursor and Neovim configs into this dotfiles repo (Git-based approach)
# Run from: ~/dotfiles/

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME="${HOME:-$HOME}"

echo "==> Backing up configs to $DOTFILES"

# Cursor: essential config only (no extensions, projects, cache)
mkdir -p "$DOTFILES/cursor"
[ -d "$HOME/.cursor/skills-cursor" ]     && cp -R "$HOME/.cursor/skills-cursor" "$DOTFILES/cursor/"
[ -f "$HOME/.cursor/mcp.json" ]           && cp "$HOME/.cursor/mcp.json" "$DOTFILES/cursor/"
[ -f "$HOME/.cursor/argv.json" ]          && cp "$HOME/.cursor/argv.json" "$DOTFILES/cursor/"
[ -f "$HOME/.cursor/blocklist" ]          && cp "$HOME/.cursor/blocklist" "$DOTFILES/cursor/"
[ -f "$HOME/.cursor/unified_repo_list.json" ] && cp "$HOME/.cursor/unified_repo_list.json" "$DOTFILES/cursor/"
[ -d "$HOME/.cursor/plans" ]             && cp -R "$HOME/.cursor/plans" "$DOTFILES/cursor/"

# Cursor: User settings (macOS)
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$DOTFILES/cursor/User"
[ -f "$CURSOR_USER/settings.json" ] && cp "$CURSOR_USER/settings.json" "$DOTFILES/cursor/User/"

# Cursor: extension list (for restore on new machine)
if command -v cursor &>/dev/null; then
  cursor --list-extensions > "$DOTFILES/cursor/extensions.txt" 2>/dev/null || true
fi

# Neovim configs
mkdir -p "$DOTFILES/config"
[ -d "$HOME/.config/nvim" ]        && rsync -a --exclude='.git' "$HOME/.config/nvim/" "$DOTFILES/config/nvim/"
[ -d "$HOME/.config/cursor-nvim" ] && rsync -a "$HOME/.config/cursor-nvim/" "$DOTFILES/config/cursor-nvim/"

# Alacritty
[ -d "$HOME/.config/alacritty" ]   && rsync -a "$HOME/.config/alacritty/" "$DOTFILES/config/alacritty/"

# Zsh / Oh My Zsh: .zshrc and custom themes/plugins only (not the full .oh-my-zsh repo)
mkdir -p "$DOTFILES/zsh"
[ -f "$HOME/.zshrc" ]              && cp "$HOME/.zshrc" "$DOTFILES/zsh/.zshrc"
if [ -d "$HOME/.oh-my-zsh/custom" ]; then
  mkdir -p "$DOTFILES/zsh/oh-my-zsh/custom"
  rsync -a --exclude='.git' "$HOME/.oh-my-zsh/custom/" "$DOTFILES/zsh/oh-my-zsh/custom/"
fi

echo "==> Backup done. Commit and push:"
echo "    cd $DOTFILES && git add -A && git status"
