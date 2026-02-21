# 🏠 Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg?logo=neovim)](https://neovim.io/)
[![OS](https://img.shields.io/badge/OS-Linux%20%7C%20macOS-blue.svg)](https://www.linux.org/)
[![Shell](https://img.shields.io/badge/Shell-Zsh%20%7C%20Fish-orange.svg)](https://www.zsh.org/)

A professional, modular, and aesthetic configuration for a modern development environment. Optimized for productivity and speed.

[English](README.md) | [简体中文](README.zh-CN.md)

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Quick Start](#-quick-start)
- [Packages](#-packages)
- [Installation](#-installation)
- [Screenshots](#-screenshots)
- [Customization](#-customization)

## 📦 Overview

This repository uses a **package-based structure** to manage configurations for different tools.

- **Shell**: Zsh (Powerlevel10k) & Fish (Fisher).
- **Editor**: Neovim (AstroNvim-based) & Minimal Vim.
- **Terminal**: Alacritty with Catppuccin themes.
- **Tools**: Tmux (TPM), Git, GDB (Dashboard), and more.

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Automatic Installation (Recommended)
The included `install.sh` handles backups, dependencies, and symlinking.

```bash
chmod +x install.sh
./install.sh install
```

To remove symlinks:
```bash
./install.sh uninstall
```

## 🛠 Packages

| Package | Description | Key Features |
| :--- | :--- | :--- |
| **`shell/`** | Zsh & Fish config | P10k theme, syntax highlighting, autosuggestions |
| **`nvim/`** | Neovim (AstroNvim) | IDE-like experience, LSP, Treesitter, DAP |
| **`tmux/`** | Terminal Multiplexer | Vim-style keys, status bar, plugin manager (TPM) |
| **`alacritty/`** | Terminal Emulator | GPU accelerated, Catppuccin & Dawnfox themes |
| **`git/`** | Version Control | Global ignore, custom aliases |
| **`misc/`** | Other configs | Vimrc, GDB Dashboard, Clang-format, Condarc |

## 🔗 Manual Installation

If you prefer to link specific packages manually:

```bash
# Example: Link Zsh config
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc

# Example: Link Neovim config
mkdir -p ~/.config
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim
```

## 🎨 Features

- ✨ **Consistency**: Uniform themes across Terminal, Editor, and Shell.
- 🚀 **Speed**: Minimal overhead and optimized startup times.
- 🛠 **Modular**: Easy to add or remove tools without breaking the system.
- 🛡 **Safe**: Automatic backup of existing configs during installation.

## 🔧 Dependencies

- `zsh`, `tmux`, `git`, `curl` (Core)
- `neovim` 0.9+ (Recommended)
- `stow` (Optional, script-friendly)
- [Nerd Fonts](https://www.nerdfonts.com/) (Required for icons/P10k)

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---
⭐ If you find this helpful, please give it a star!
