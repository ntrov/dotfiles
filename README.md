# Dotfiles

Git-based backup for Cursor and Neovim configs. See [this approach](https://chatgpt.com/share/697a3314-04b8-8000-902f-c340cbed0e0a) (backup config files with Git).

## What’s included

- **Cursor:** `skills-cursor/`, `mcp.json`, `argv.json`, `blocklist`, `plans/`, `User/settings.json` (from Application Support), and `extensions.txt` (extension IDs for reinstall on new machine)
- **Neovim:** `~/.config/nvim/` and `~/.config/cursor-nvim/`
- **Alacritty:** `~/.config/alacritty/`
- **Zsh / Oh My Zsh:** `~/.zshrc` and `~/.oh-my-zsh/custom/` (themes and plugins only; the main Oh My Zsh repo is not stored—install it on new machines).

Excluded: `.cursor/extensions/` (binary blobs; use `extensions.txt` + `restore-extensions.sh` instead), `.cursor/projects/`, caches, logs. Oh My Zsh core is excluded; only your custom themes/plugins are backed up.

## First-time setup

```bash
cd ~/dotfiles
git init
./backup-configs.sh   # copy current configs into this repo
git add -A
git commit -m "Initial backup: Cursor and Neovim configs"
git remote add origin <your-repo-url>   # e.g. GitHub
git push -u origin main
```

## Daily use

**Backup (save current configs into this repo):**

```bash
cd ~/dotfiles && ./backup-configs.sh && git add -A && git commit -m "Backup configs" && git push
```

**Restore (apply configs from this repo to ~/.cursor and ~/.config):**

```bash
cd ~/dotfiles && ./restore-configs.sh
```

## New machine

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles

# Install Oh My Zsh first (if you use it), then restore so .zshrc and custom themes/plugins apply
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

./restore-configs.sh
./restore-extensions.sh   # install Cursor extensions from extensions.txt
```

## Security

If `settings.json` or `mcp.json` contain secrets or tokens, add them to `.gitignore` or use a private repo.
