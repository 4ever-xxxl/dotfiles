# 🏠 Dotfiles

[![License: MIT](https://img.shields.io/badge/许可证-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/编辑器-Neovim%200.9+-green.svg?logo=neovim)](https://neovim.io/)
[![OS](https://img.shields.io/badge/系统-Linux%20%7C%20macOS-blue.svg)](https://www.linux.org/)
[![Shell](https://img.shields.io/badge/Shell-Zsh%20%7C%20Fish-orange.svg)](https://www.zsh.org/)

一套专业、模块化且美观的现代化开发环境配置，专为提高效率和速度而优化。

[English](README.md) | [简体中文](README.zh-CN.md)

---

## 📖 目录

- [概览](#-概览)
- [快速开始](#-快速开始)
- [配置包介绍](#-配置包介绍)
- [安装方法](#-安装方法)
- [功能特性](#-功能特性)
- [自定义](#-自定义)

## 📦 概览

本仓库采用 **包驱动结构 (Package-based)** 来管理不同工具的配置：

- **Shell**: Zsh (Powerlevel10k) 和 Fish (Fisher)。
- **编辑器**: Neovim (基于 AstroNvim) 和 轻量级 Vim。
- **终端**: Alacritty（预装 Catppuccin 主题）。
- **工具**: Tmux (TPM), Git, GDB (Dashboard) 等。

## 🚀 快速开始

### 1. 克隆仓库
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. 自动安装 (推荐)
内置的 `install.sh` 会自动处理备份、依赖检查和软链接创建。

```bash
chmod +x install.sh
./install.sh install
```

如需移除软链接：
```bash
./install.sh uninstall
```

## 🛠 配置包介绍

| 配置包 | 说明 | 核心特性 |
| :--- | :--- | :--- |
| **`shell/`** | Zsh & Fish 配置 | P10k 主题、语法高亮、自动建议 |
| **`nvim/`** | Neovim (AstroNvim) | 类 IDE 体验、LSP、Treesitter、调试支持 |
| **`tmux/`** | 终端复用器 | Vim 风格键位、自定义状态栏、插件管理 (TPM) |
| **`alacritty/`** | 终端模拟器 | GPU 加速、包含 Catppuccin 和 Dawnfox 主题 |
| **`git/`** | 版本控制 | 全局忽略、常用快捷别名 |
| **`misc/`** | 其他工具 | Vimrc、GDB 可视化仪表盘、Clang-format、Conda 镜像配置 |

## 🔗 手动安装

如果您只想手动链接特定模块：

```bash
# 示例：链接 Zsh 配置
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc

# 示例：链接 Neovim 配置
mkdir -p ~/.config
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim
```

## 🎨 功能特性

- ✨ **一致性**: 终端、编辑器和 Shell 之间保持统一的主题色调。
- 🚀 **极致响应**: 极低延迟，针对启动速度进行了深度优化。
- 🛠 **模块化**: 方便地添加或移除配置包，不影响系统其他部分。
- 🛡 **安全备份**: 安装过程中会自动将您原有的配置文件备份到 `~/.dotfiles_backup/`。

## 🔧 依赖项

- `zsh`, `tmux`, `git`, `curl` (核心依赖)
- `neovim` 0.9+ (推荐版本)
- `stow` (可选，方便脚本调用)
- [Nerd Fonts](https://www.nerdfonts.com/) (显示图标和 P10k 提示符必需)

## 📄 许可证

基于 MIT 许可证分发。详见 `LICENSE`。

---
⭐ 如果这些配置对你有帮助，请点一个 star！
