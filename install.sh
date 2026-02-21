#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════════════
#  Dotfiles 自动安装脚本
#═══════════════════════════════════════════════════════════════════════════════

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 获取脚本所在目录
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#───────────────────────────────────────────────────────────────────────────────
# 工具函数
#───────────────────────────────────────────────────────────────────────────────

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

#───────────────────────────────────────────────────────────────────────────────
# 系统检测
#───────────────────────────────────────────────────────────────────────────────

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/arch-release ]; then
            OS="arch"
        elif [ -f /etc/debian_version ]; then
            OS="debian"
        elif [ -f /etc/fedora-release ]; then
            OS="fedora"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    echo "$OS"
}

#───────────────────────────────────────────────────────────────────────────────
# 包管理器安装函数
#───────────────────────────────────────────────────────────────────────────────

install_package() {
    local package=$1
    local os=$(detect_os)
    
    case $os in
        arch)
            if ! pacman -Qi "$package" &>/dev/null; then
                info "安装 $package..."
                sudo pacman -S --noconfirm "$package"
            fi
            ;;
        debian)
            if ! dpkg -l "$package" &>/dev/null; then
                info "安装 $package..."
                sudo apt-get install -y "$package"
            fi
            ;;
        fedora)
            if ! rpm -q "$package" &>/dev/null; then
                info "安装 $package..."
                sudo dnf install -y "$package"
            fi
            ;;
        macos)
            if ! brew list "$package" &>/dev/null; then
                info "安装 $package..."
                brew install "$package"
            fi
            ;;
        *)
            warning "未知系统，请手动安装 $package"
            ;;
    esac
}

#───────────────────────────────────────────────────────────────────────────────
# 备份现有配置
#───────────────────────────────────────────────────────────────────────────────

backup_existing() {
    local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    local files_to_backup=(
        ".zshrc"
        ".tmux.conf"
        ".vimrc"
        ".gitconfig"
        ".gdbinit"
        ".clang-format"
        ".condarc"
        ".env"
        ".env.local"
        ".config/nvim"
        ".config/alacritty"
        ".config/fish"
    )
    
    local need_backup=false
    for file in "${files_to_backup[@]}"; do
        local target="$HOME/$file"
        if [[ -e "$target" && ! -L "$target" ]]; then
            need_backup=true
            break
        fi
    done
    
    if $need_backup; then
        info "备份现有配置到 $backup_dir"
        mkdir -p "$backup_dir"
        
        for file in "${files_to_backup[@]}"; do
            local target="$HOME/$file"
            if [[ -e "$target" && ! -L "$target" ]]; then
                local dir=$(dirname "$backup_dir/$file")
                mkdir -p "$dir"
                cp -r "$target" "$backup_dir/$file"
                success "备份: $file"
            fi
        done
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 创建符号链接
#───────────────────────────────────────────────────────────────────────────────

create_symlink() {
    local src=$1
    local dest=$2
    
    # 如果目标已存在且不是符号链接，则跳过（已备份）
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        rm -rf "$dest"
    fi
    
    # 如果已经是正确的符号链接，跳过
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        success "已链接: $dest"
        return
    fi
    
    # 移除旧的符号链接
    [[ -L "$dest" ]] && rm "$dest"
    
    # 确保目标目录存在
    mkdir -p "$(dirname "$dest")"
    
    # 创建符号链接
    ln -s "$src" "$dest"
    success "链接: $dest -> $src"
}

#───────────────────────────────────────────────────────────────────────────────
# 安装 Oh-My-Zsh
#───────────────────────────────────────────────────────────────────────────────

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "安装 Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh-My-Zsh 安装完成"
    else
        success "Oh-My-Zsh 已安装"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 安装 Zsh 插件
#───────────────────────────────────────────────────────────────────────────────

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # Powerlevel10k
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        info "安装 Powerlevel10k 主题..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        success "Powerlevel10k 安装完成"
    else
        success "Powerlevel10k 已安装"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        info "安装 zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        success "zsh-syntax-highlighting 安装完成"
    else
        success "zsh-syntax-highlighting 已安装"
    fi
    
    # zsh-autosuggestions
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        info "安装 zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        success "zsh-autosuggestions 安装完成"
    else
        success "zsh-autosuggestions 已安装"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 安装 TPM (Tmux Plugin Manager)
#───────────────────────────────────────────────────────────────────────────────

install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "安装 TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM 安装完成"
        info "提示: 进入 tmux 后按 prefix + I 安装插件"
    else
        success "TPM 已安装"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 主安装流程
#───────────────────────────────────────────────────────────────────────────────

install_dotfiles() {
    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║              🏠 Dotfiles 安装脚本                              ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local os=$(detect_os)
    info "检测到系统: $os"
    echo ""
    
    # 步骤 1: 备份现有配置
    echo -e "${CYAN}━━━ 步骤 1/5: 备份现有配置 ━━━${NC}"
    backup_existing
    echo ""
    
    # 步骤 2: 安装基础依赖
    echo -e "${CYAN}━━━ 步骤 2/5: 检查基础依赖 ━━━${NC}"
    command -v git &>/dev/null || install_package git
    command -v zsh &>/dev/null || install_package zsh
    command -v tmux &>/dev/null || install_package tmux
    command -v vim &>/dev/null || install_package vim
    command -v curl &>/dev/null || install_package curl
    success "基础依赖检查完成"
    echo ""
    
    # 步骤 3: 安装 Oh-My-Zsh 和插件
    echo -e "${CYAN}━━━ 步骤 3/5: 安装 Zsh 组件 ━━━${NC}"
    install_oh_my_zsh
    install_zsh_plugins
    echo ""
    
    # 步骤 4: 安装 TPM
    echo -e "${CYAN}━━━ 步骤 4/5: 安装 Tmux 插件管理器 ━━━${NC}"
    install_tpm
    echo ""
    
    # 步骤 5: 创建符号链接
    echo -e "${CYAN}━━━ 步骤 5/5: 创建符号链接 ━━━${NC}"
    # Shell 配置
    create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/shell/.config/fish" "$HOME/.config/fish"
    
    # 终端配置
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/alacritty/.config/alacritty" "$HOME/.config/alacritty"
    
    # 编辑器配置
    create_symlink "$DOTFILES_DIR/misc/.vimrc" "$HOME/.vimrc"
    create_symlink "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
    
    # 开发工具配置
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTFILES_DIR/misc/.gdbinit" "$HOME/.gdbinit"
    create_symlink "$DOTFILES_DIR/misc/.clang-format" "$HOME/.clang-format"
    create_symlink "$DOTFILES_DIR/misc/.condarc" "$HOME/.condarc"
    
    # 环境变量
    create_symlink "$DOTFILES_DIR/misc/.env" "$HOME/.env"
    if [[ -f "$DOTFILES_DIR/misc/.env.local" ]]; then
        create_symlink "$DOTFILES_DIR/misc/.env.local" "$HOME/.env.local"
    fi
    echo ""
    
    # 完成
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ 安装完成！                                    ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}后续步骤:${NC}"
    echo "  1. 重新启动终端或运行: source ~/.zshrc"
    echo "  2. 如需配置 Powerlevel10k 主题，运行: p10k configure"
    echo "  3. 进入 tmux 后按 Ctrl+a I 安装 tmux 插件"
    echo ""
    echo -e "${BLUE}备份位置: ~/.dotfiles_backup/${NC}"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 卸载函数
#───────────────────────────────────────────────────────────────────────────────

uninstall_dotfiles() {
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║              🗑️  Dotfiles 卸载                                 ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local files=(
        "$HOME/.zshrc"
        "$HOME/.tmux.conf"
        "$HOME/.vimrc"
        "$HOME/.gitconfig"
        "$HOME/.gdbinit"
        "$HOME/.clang-format"
        "$HOME/.condarc"
        "$HOME/.env"
        "$HOME/.env.local"
        "$HOME/.config/nvim"
        "$HOME/.config/alacritty"
        "$HOME/.config/fish"
    )
    
    for file in "${files[@]}"; do
        if [[ -L "$file" ]]; then
            rm "$file"
            success "移除链接: $file"
        fi
    done
    
    echo ""
    info "符号链接已移除"
    info "如需恢复原配置，请查看备份目录: ~/.dotfiles_backup/"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 帮助信息
#───────────────────────────────────────────────────────────────────────────────

show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  install     安装 dotfiles（默认）"
    echo "  uninstall   卸载 dotfiles（移除符号链接）"
    echo "  help        显示此帮助信息"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 主入口
#───────────────────────────────────────────────────────────────────────────────

main() {
    case "${1:-install}" in
        install)
            install_dotfiles
            ;;
        uninstall)
            uninstall_dotfiles
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
