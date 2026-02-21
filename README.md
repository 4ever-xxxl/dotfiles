# 🏠 Dotfiles

我的个人配置文件集合，用于快速配置新的开发环境。

## 📋 目录

- [包含的配置](#包含的配置)
- [快速开始](#快速开始)
- [详细说明](#详细说明)
- [依赖项](#依赖项)
- [自定义](#自定义)

## 📦 包含的配置

### 终端与 Shell

- **`.zshrc`** - Zsh 配置
  - Powerlevel10k 主题
  - 实用插件（git、语法高亮、自动建议等）
  - 优化的历史记录设置
  - 自定义别名和函数

- **`.config/fish/`** - Fish Shell 配置
  - 交互式 shell 配置
  - 插件列表

- **`.tmux.conf`** - Tmux 终端复用器配置
  - Vim 风格的键位绑定
  - 鼠标支持
  - 自定义状态栏
  - TPM 插件管理器支持

- **`.config/alacritty/`** - Alacritty 终端配置
  - GPU 加速终端模拟器
  - 字体和主题配置
  - 包含多种 Catppuccin 主题

### 编辑器

- **`.vimrc`** - Vim 编辑器配置
  - 轻量级快速编辑配置
  - 语法高亮和行号显示
  - 智能缩进
  - 常用快捷键映射

- **`.config/nvim/`** - Neovim 配置
  - 基于 AstroNvim 的现代化配置

### 开发工具

- **`.gitconfig`** - Git 全局配置
  - 用户信息
  - 常用别名
  - 代理设置（可选）

- **`.gdbinit`** - GDB 调试器配置
  - GDB Dashboard - 模块化可视化界面
  - 增强的调试体验

- **`.clang-format`** - C/C++ 代码格式化
  - 基于 Google 代码风格
  - 统一代码格式

- **`.condarc`** - Conda/Mamba 配置
  - 清华镜像源
  - 加速包下载

### 环境变量

- **`.env`** - 环境变量配置
  - 自定义环境变量
  - 路径配置

## 🚀 快速开始

### 克隆仓库

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 安装配置

**方法 1：自动安装脚本（推荐）** 🚀

```bash
cd ~/dotfiles
./install.sh
```

脚本会自动：
- ✅ 备份现有配置到 `~/.dotfiles_backup/`
- ✅ 检测系统并安装依赖
- ✅ 创建所有符号链接
- ✅ 安装 Oh-My-Zsh 和插件
- ✅ 安装 TPM (Tmux Plugin Manager)

卸载：
```bash
./install.sh uninstall
```

**方法 2：手动符号链接**

```bash
# Zsh & Fish
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/.config/fish ~/.config/fish

# Tmux
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Alacritty
ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/alacritty

# Vim & Neovim
ln -sf ~/dotfiles/misc/.vimrc ~/.vimrc
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# Git & 开发工具
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/misc/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/misc/.clang-format ~/.clang-format
ln -sf ~/dotfiles/misc/.condarc ~/.condarc

# 环境变量
ln -sf ~/dotfiles/misc/.env ~/.env
```

### 重新加载配置

```bash
# Zsh
source ~/.zshrc

# Tmux
tmux source ~/.tmux.conf
```

## 📖 详细说明

### Zsh 配置

**主要特性：**
- 🎨 **Powerlevel10k 主题** - 美观且快速的提示符
- 📝 **增强的历史记录** - 50000 条命令历史
- 🔌 **实用插件**：
  - `git` - Git 别名和函数
  - `zsh-syntax-highlighting` - 命令语法高亮
  - `zsh-autosuggestions` - 基于历史的自动建议
  - `autojump` - 智能目录跳转
  - `docker` - Docker 命令补全
  - 更多...

**前置依赖：**
```bash
# 安装 Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 安装插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Tmux 配置

**主要特性：**
- ⌨️ **Vim 风格键位** - hjkl 导航
- 🖱️ **鼠标支持** - 点击切换窗格
- 📊 **自定义状态栏** - 显示会话、时间等信息
- 🔌 **TPM 插件管理** - Dracula 主题、会话恢复等

**前缀键：** `Ctrl + a`（替代默认的 `Ctrl + b`）

**常用快捷键：**
- `Ctrl+a |` - 垂直分割
- `Ctrl+a -` - 水平分割
- `Ctrl+a hjkl` - 切换窗格（Vim 风格）
- `Alt+方向键` - 快速切换窗格（无需前缀）
- `Ctrl+a r` - 重载配置

**安装 TPM：**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Vim 配置

**主要特性：**
- 📍 行号显示（绝对 + 相对）
- 🎨 语法高亮
- 📏 智能缩进
- 🔍 增强搜索
- ⚡ 轻量快速

### GDB 配置

使用 **GDB Dashboard** 提供更好的调试体验：
- 模块化可视化界面
- 代码、寄存器、堆栈视图
- 增强的输出格式

## 🔧 依赖项

### 必需

- `zsh` - Z Shell
- `tmux` - 终端复用器
- `vim` 或 `neovim` - 文本编辑器
- `git` - 版本控制
- `stow` - 符号链接管理工具（推荐）

### 可选

- `xclip` 或 `xsel` - Tmux 剪贴板支持（Linux）
- `gdb` - 调试器
- `clang-format` - C/C++ 代码格式化
- `autojump` - 智能目录跳转
- Nerd Font - 图标和符号支持

### 安装依赖（Ubuntu/Debian）

```bash
sudo apt update
sudo apt install -y zsh tmux vim neovim git stow xclip gdb clang-format autojump
```

### 安装依赖（macOS）

```bash
brew install zsh tmux vim neovim git stow gdb clang-format autojump
```

## 🎨 自定义

### 修改主题

**Zsh：** 编辑 `.zshrc` 中的 `ZSH_THEME` 变量

**Tmux：** 修改 `.tmux.conf` 中的颜色配置或更换插件主题

### 添加别名

编辑 `.zshrc`，在文件末尾添加：

```bash
# 自定义别名
alias myalias="command"
```

### 修改快捷键

编辑 `.tmux.conf` 或 `.vimrc`，根据注释说明修改键位绑定

## 🔄 更新

```bash
cd ~/dotfiles
git pull
```

重新加载相应的配置文件即可应用更新。

## 📝 备份

在安装这些配置之前，建议备份现有配置：

```bash
mkdir -p ~/.config_backup
cp ~/.zshrc ~/.tmux.conf ~/.vimrc ~/.config_backup/ 2>/dev/null
```

## 🤝 贡献

这是我的个人配置文件，但欢迎提出建议和改进意见！

## 📄 许可

MIT License - 随意使用和修改

---

⭐ 如果这些配置对你有帮助，欢迎 star！
