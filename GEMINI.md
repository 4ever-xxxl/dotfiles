# GEMINI.md - Dotfiles Project Context

This document provides architectural guidance and engineering standards for maintaining this dotfiles repository.

## 🎯 Project Overview
A personalized development environment configuration (dotfiles) designed for rapid setup and consistency across different Linux distributions (Arch, Debian, Fedora) and macOS.

## 🛠 Engineering Standards

### 1. Configuration Management (GNU Stow)
- **Symlink Strategy**: Uses **GNU Stow** for symlink management. 
- **Package Structure**: Configurations are organized into "packages" (subdirectories) under the root of the repository.
  - `nvim/`: Neovim configuration.
  - `shell/`: Zsh and Fish configurations.
  - `tmux/`: Tmux configuration.
  - `git/`: Git configuration.
  - `alacritty/`: Alacritty terminal configuration.
  - `misc/`: Other configuration files (`.vimrc`, `.env`, etc.).
- **Installation**: Run `./install.sh install` to link all packages to `$HOME`.
- **Uninstall**: Run `./install.sh uninstall` to remove all symlinks created by the script.
- **XDG Compliance**: New configurations SHOULD prioritize `~/.config/<tool>/` within their respective package directory.

### 2. Shell Environment
- **Multi-Shell Support**: The repository maintains both Zsh (primary interactive/legacy) and Fish (modern interactive).
- **Zsh**: Uses Oh-My-Zsh and Powerlevel10k. Customizations should go into `.zshrc` or specific plugin files.
- **Fish**: Managed via `fisher`. Custom functions reside in `.config/fish/functions/`.

### 3. Editor Configuration
- **Neovim**: Based on **AstroNvim**. Customizations should be made within `.config/nvim/lua/plugins/` or `polish.lua` to maintain compatibility with the AstroNvim ecosystem.
- **Vim**: Minimal `.vimrc` for environments where Neovim is unavailable.

### 4. Cross-Platform Compatibility
- **OS Detection**: `install.sh` handles different package managers (`pacman`, `apt`, `dnf`, `brew`).
- **Conditional Logic**: Use OS/environment detection in shell scripts to ensure portability.

## 🔍 Key Files & Directories
- `install.sh`: The entry point for deployment. Handles backups, package installation, and symlinking.
- `.config/nvim/`: Neovim (AstroNvim) configuration.
- `.config/fish/`: Fish shell configuration.
- `.zshrc`: Zsh main configuration.
- `.tmux.conf`: Tmux terminal multiplexer settings.
- `.env`: Machine-specific environment variables (should not contain secrets).

## 🔄 Common Workflows

### Adding a New Configuration
1. Place the configuration file/directory in the repository.
2. Update `install.sh`'s `backup_existing` and `create_symlink` functions to include the new path.
3. Update `README.md` to document the new addition.

### Updating Neovim Plugins
- Since it's AstroNvim-based, use `:Lazy update` within Neovim.
- For structural changes, modify `.config/nvim/lua/plugins/*.lua`.

### Testing Changes
- Before committing, test the `install.sh` logic in a clean environment or container if possible.
- Ensure symlinks are correctly created and old files are backed up.

## ⚠️ Safety & Security
- **No Secrets**: NEVER commit API keys, tokens, or private SSH keys. Use `.env.local` (gitignored) for local overrides if necessary.
- **Backup First**: Always ensure the backup logic in `install.sh` is functional before running it on a new machine.
