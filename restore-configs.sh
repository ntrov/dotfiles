#!/usr/bin/env bash
# Restore Cursor and Neovim configs from this dotfiles repo
# Run from: ~/dotfiles/

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME="${HOME:-$HOME}"

echo "==> Restoring configs from $DOTFILES"

# Cursor
mkdir -p "$HOME/.cursor"
[ -d "$DOTFILES/cursor/skills-cursor" ] && cp -R "$DOTFILES/cursor/skills-cursor" "$HOME/.cursor/"
[ -f "$DOTFILES/cursor/mcp.json" ]      && cp "$DOTFILES/cursor/mcp.json" "$HOME/.cursor/"
[ -f "$DOTFILES/cursor/argv.json" ]    && cp "$DOTFILES/cursor/argv.json" "$HOME/.cursor/"
[ -f "$DOTFILES/cursor/blocklist" ]    && cp "$DOTFILES/cursor/blocklist" "$HOME/.cursor/"
[ -f "$DOTFILES/cursor/unified_repo_list.json" ] && cp "$DOTFILES/cursor/unified_repo_list.json" "$HOME/.cursor/"
[ -d "$DOTFILES/cursor/plans" ]        && cp -R "$DOTFILES/cursor/plans" "$HOME/.cursor/"

CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER"
[ -f "$DOTFILES/cursor/User/settings.json" ] && cp "$DOTFILES/cursor/User/settings.json" "$CURSOR_USER/"

# Neovim configs
mkdir -p "$HOME/.config"
[ -d "$DOTFILES/config/nvim" ]        && rsync -a "$DOTFILES/config/nvim/" "$HOME/.config/nvim/"
[ -d "$DOTFILES/config/cursor-nvim" ] && rsync -a "$DOTFILES/config/cursor-nvim/" "$HOME/.config/cursor-nvim/"

# Alacritty
[ -d "$DOTFILES/config/alacritty" ]   && rsync -a "$DOTFILES/config/alacritty/" "$HOME/.config/alacritty/"

# Zsh / Oh My Zsh
[ -f "$DOTFILES/zsh/.zshrc" ]        && cp "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
if [ -d "$HOME/.oh-my-zsh" ] && [ -d "$DOTFILES/zsh/oh-my-zsh/custom" ]; then
  rsync -a "$DOTFILES/zsh/oh-my-zsh/custom/" "$HOME/.oh-my-zsh/custom/"
fi

echo "==> Restore done."
