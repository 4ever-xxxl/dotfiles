#!/usr/bin/env bash
#═══════════════════════════════════════════════════════════════════════════════
#  Dotfiles 自动安装脚本（模块化）
#═══════════════════════════════════════════════════════════════════════════════

# 严格模式：
#   -e            任意命令失败立即退出
#   -u            使用未定义变量报错
#   -o pipefail   管道中任一命令失败即视为整条管道失败
set -euo pipefail

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

# Dry-run 模式：仅预览操作，不实际执行
DRY_RUN=false

#───────────────────────────────────────────────────────────────────────────────
# 工具函数
#───────────────────────────────────────────────────────────────────────────────

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; }

# 错误诊断 trap：捕获任何被 set -e 终止的失败，定位行号与命令
trap 'error "失败于第 $LINENO 行: \`$BASH_COMMAND\` (退出码 $?)"' ERR

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

# clangd 配置路径因平台而异：
#   Linux/BSD  → $XDG_CONFIG_HOME 或 ~/.config/clangd/config.yaml
#   macOS      → ~/Library/Preferences/clangd/config.yaml
# 参考: https://clangd.llvm.org/config
clangd_config_path() {
    if [[ "$(detect_os)" == "macos" ]]; then
        echo "$HOME/Library/Preferences/clangd/config.yaml"
    else
        echo "$HOME/.config/clangd/config.yaml"
    fi
}

#───────────────────────────────────────────────────────────────────────────────
# 包管理器安装
#───────────────────────────────────────────────────────────────────────────────

install_package() {
    local package=$1
    if $DRY_RUN; then
        info "[DRY-RUN] 将安装: $package"
        return
    fi
    local os
    os=$(detect_os)

    case $os in
        arch)
            if ! pacman -Qi "$package" &>/dev/null; then
                info "安装 $package..."
                sudo pacman -S --noconfirm "$package"
            fi
            ;;
        debian)
            if ! dpkg -s "$package" &>/dev/null; then
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
# 安全删除：替代裸 rm -rf，加三道护栏
#   1. 目标非空
#   2. 目标不是根目录 /
#   3. 目标必须在 $HOME 之内（拒绝跨用户删除）
# 同时尊重 DRY_RUN，且使用 -- 防止以 - 开头的路径被当作选项
#───────────────────────────────────────────────────────────────────────────────

safe_remove() {
    local target="${1:-}"

    if [[ -z "$target" ]]; then
        error "safe_remove: 拒绝执行（目标为空）"
        return 1
    fi
    if [[ "$target" == "/" ]]; then
        error "safe_remove: 拒绝删除根目录 /"
        return 1
    fi
    if [[ "$target" != "$HOME"/* ]]; then
        error "safe_remove: 拒绝删除 HOME 之外的路径: $target"
        return 1
    fi

    if $DRY_RUN; then
        info "[DRY-RUN] 将删除: $target"
        return 0
    fi

    info "覆盖前删除已存在文件/目录（已备份）: $target"
    rm -rf -- "$target"
}

#───────────────────────────────────────────────────────────────────────────────
# 创建符号链接
#───────────────────────────────────────────────────────────────────────────────

create_symlink() {
    local src=$1
    local dest=$2

    if $DRY_RUN; then
        info "[DRY-RUN] 将链接: $dest -> $src"
        return
    fi

    # 如果目标已存在且不是符号链接，则删除（已备份）
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        safe_remove "$dest"
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
# 前置依赖安装器
#───────────────────────────────────────────────────────────────────────────────

install_antidote() {
    if $DRY_RUN; then
        info "[DRY-RUN] 跳过 antidote 安装"
        return
    fi
    if [[ ! -d "$HOME/.antidote" ]]; then
        info "安装 antidote 插件管理器..."
        git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
        success "antidote 安装完成"
    else
        success "antidote 已安装"
    fi
}


install_tpm() {
    if $DRY_RUN; then
        info "[DRY-RUN] 跳过 TPM 安装"
        return
    fi
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "安装 TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM 安装完成"
        info "提示: 进入 tmux 后按 prefix + I 安装插件"
    else
        success "TPM 已安装"
    fi
}

check_modern_tools() {
    local missing=()

    command -v nvim     &>/dev/null || missing+=("nvim     (Neovim)       — https://github.com/neovim/neovim/releases")
    command -v eza      &>/dev/null || missing+=("eza      (现代 ls)       — https://github.com/eza-community/eza")
    command -v fzf      &>/dev/null || missing+=("fzf      (模糊搜索)      — https://github.com/junegunn/fzf")
    command -v lazygit  &>/dev/null || missing+=("lazygit  (Git TUI)      — https://github.com/jesseduffield/lazygit")

    # bat 在 Debian/Ubuntu 上叫 batcat
    if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
        missing+=("bat      (现代 cat)      — https://github.com/sharkdp/bat")
    fi

    if [[ ${#missing[@]} -eq 0 ]]; then
        success "所有现代工具已就绪"
    else
        warning "以下工具未安装（已定义别名，建议手动安装）:"
        for tool in "${missing[@]}"; do
            echo "    • $tool"
        done
    fi
}

#═══════════════════════════════════════════════════════════════════════════════
# 模块清单
#───────────────────────────────────────────────────────────────────────────────
# 这是本脚本的唯一信源：新增/移除模块时只改本节，install/uninstall/verify/
# backup/CI 全部自动跟进。
#
# 每个模块定义两个函数（postinstall 可选）：
#   module_<name>_links       → 每行一个 "src=>dst" 对（输出到 stdout）
#   module_<name>_preinstall  → 该模块所需的二进制依赖、模板生成等
#═══════════════════════════════════════════════════════════════════════════════

MODULE_NAMES=(shell tmux alacritty nvim vim git dev)

declare -A MODULE_DESC=(
    [shell]="zsh + fish + starship + antidote + .env"
    [tmux]="tmux.conf + TPM + 跨平台剪贴板脚本"
    [alacritty]="Alacritty + Catppuccin/Dawnfox 主题"
    [nvim]="Neovim (AstroNvim 基础)"
    [vim]="轻量 .vimrc"
    [git]=".gitconfig + personal + work"
    [dev]="gdb + clang-format + clangd + condarc"
)

# --- shell ---------------------------------------------------------------------
module_shell_links() {
    cat <<EOF
$DOTFILES_DIR/shell/.zshrc=>$HOME/.zshrc
$DOTFILES_DIR/shell/.zsh_plugins.txt=>$HOME/.zsh_plugins.txt
$DOTFILES_DIR/shell/.config/fish=>$HOME/.config/fish
$DOTFILES_DIR/shell/.config/mise/config.toml=>$HOME/.config/mise/config.toml
$DOTFILES_DIR/misc/.env=>$HOME/.env
EOF
    # .env.local 仅当源文件已存在时才登记，避免 dangling 链接
    [[ -f "$DOTFILES_DIR/misc/.env.local" ]] \
        && echo "$DOTFILES_DIR/misc/.env.local=>$HOME/.env.local"
}

module_shell_preinstall() {
    install_antidote
    # 模板拷贝 .env.local（仅当 .local 不存在且 .example 存在）
    if [[ ! -f "$DOTFILES_DIR/misc/.env.local" && -f "$DOTFILES_DIR/misc/.env.local.example" ]]; then
        if $DRY_RUN; then
            info "[DRY-RUN] 将从模板创建 misc/.env.local"
        else
            cp "$DOTFILES_DIR/misc/.env.local.example" "$DOTFILES_DIR/misc/.env.local"
            # 环境变量文件不应可执行；显式归一为 644 防止权限漂移
            chmod 644 "$DOTFILES_DIR/misc/.env.local"
            warning "已从模板创建 misc/.env.local，请按需编辑代理、conda 路径等本机配置"
        fi
    fi
}

# --- tmux ----------------------------------------------------------------------
module_tmux_links() {
    cat <<EOF
$DOTFILES_DIR/tmux/.tmux.conf=>$HOME/.tmux.conf
$DOTFILES_DIR/tmux/.tmux/scripts=>$HOME/.tmux/scripts
EOF
}

module_tmux_preinstall() {
    install_tpm
}

# --- alacritty -----------------------------------------------------------------
module_alacritty_links() {
    echo "$DOTFILES_DIR/alacritty/.config/alacritty=>$HOME/.config/alacritty"
}

# --- nvim ----------------------------------------------------------------------
module_nvim_links() {
    echo "$DOTFILES_DIR/nvim/.config/nvim=>$HOME/.config/nvim"
}

# --- vim -----------------------------------------------------------------------
module_vim_links() {
    echo "$DOTFILES_DIR/misc/.vimrc=>$HOME/.vimrc"
}

# --- git -----------------------------------------------------------------------
module_git_links() {
    cat <<EOF
$DOTFILES_DIR/git/.gitconfig=>$HOME/.gitconfig
$DOTFILES_DIR/git/.gitconfig-personal=>$HOME/.gitconfig-personal
$DOTFILES_DIR/git/.gitconfig-work=>$HOME/.gitconfig-work
EOF
}

# --- dev -----------------------------------------------------------------------
module_dev_links() {
    cat <<EOF
$DOTFILES_DIR/misc/.gdbinit=>$HOME/.gdbinit
$DOTFILES_DIR/misc/.clang-format=>$HOME/.clang-format
$DOTFILES_DIR/misc/clangd_config.yaml=>$(clangd_config_path)
$DOTFILES_DIR/misc/.condarc=>$HOME/.condarc
EOF
}

#───────────────────────────────────────────────────────────────────────────────
# 模块 driver
#───────────────────────────────────────────────────────────────────────────────

is_valid_module() {
    local needle=$1 m
    for m in "${MODULE_NAMES[@]}"; do
        [[ "$m" == "$needle" ]] && return 0
    done
    return 1
}

install_module() {
    local name=$1
    echo ""
    echo -e "${CYAN}━━━ 模块: $name (${MODULE_DESC[$name]:-}) ━━━${NC}"

    if declare -F "module_${name}_preinstall" >/dev/null; then
        "module_${name}_preinstall"
    fi

    local src dst line
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        src="${line%%=>*}"
        dst="${line#*=>}"
        create_symlink "$src" "$dst"
    done < <("module_${name}_links")

    if declare -F "module_${name}_postinstall" >/dev/null; then
        "module_${name}_postinstall"
    fi
}

uninstall_module() {
    local name=$1
    echo ""
    echo -e "${CYAN}━━━ 卸载模块: $name ━━━${NC}"

    local dst line
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        dst="${line#*=>}"
        if [[ -L "$dst" ]]; then
            if $DRY_RUN; then
                info "[DRY-RUN] 将移除: $dst"
            else
                rm "$dst"
                success "移除链接: $dst"
            fi
        fi
    done < <("module_${name}_links")
}

verify_module() {
    local name=$1
    local errors=0
    local src dst line actual

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        src="${line%%=>*}"
        dst="${line#*=>}"
        if [[ ! -L "$dst" ]]; then
            error "[$name] 未链接: $dst"
            errors=$((errors + 1))
        else
            actual=$(readlink "$dst")
            if [[ "$actual" != "$src" ]]; then
                error "[$name] 链接错位: $dst -> $actual (期望 $src)"
                errors=$((errors + 1))
            fi
        fi
    done < <("module_${name}_links")

    if [[ "$errors" -eq 0 ]]; then
        success "模块 $name: 链接正确"
        return 0
    fi
    return 1
}

list_modules() {
    echo ""
    echo -e "${PURPLE}可用模块:${NC}"
    echo ""
    local m
    for m in "${MODULE_NAMES[@]}"; do
        printf "  ${GREEN}%-11s${NC} %s\n" "$m" "${MODULE_DESC[$m]:-}"
    done
    echo ""
    echo "用法："
    echo "  $0 install [模块...]    # 默认安装全部"
    echo "  $0 install --all        # 显式装全部"
    echo "  $0 verify  [模块...]    # 校验链接"
    echo "  $0 uninstall [模块...]  # 移除链接"
    echo ""
}

#───────────────────────────────────────────────────────────────────────────────
# 备份现有配置（按选中的模块衍生路径集合）
#───────────────────────────────────────────────────────────────────────────────

backup_existing() {
    if $DRY_RUN; then
        info "[DRY-RUN] 跳过备份"
        return
    fi

    local -a targets=()
    local mod dst line
    for mod in "$@"; do
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            dst="${line#*=>}"
            targets+=("$dst")
        done < <("module_${mod}_links")
    done

    local need_backup=false target
    for target in "${targets[@]}"; do
        if [[ -e "$target" && ! -L "$target" ]]; then
            need_backup=true
            break
        fi
    done

    if ! $need_backup; then
        return
    fi

    local backup_dir
    backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    info "备份现有配置到 $backup_dir"
    mkdir -p "$backup_dir"

    local rel dir
    for target in "${targets[@]}"; do
        if [[ -e "$target" && ! -L "$target" ]]; then
            rel="${target#"$HOME"/}"
            dir=$(dirname "$backup_dir/$rel")
            mkdir -p "$dir"
            cp -r "$target" "$backup_dir/$rel"
            success "备份: $rel"
        fi
    done
}

#───────────────────────────────────────────────────────────────────────────────
# 主流程
#───────────────────────────────────────────────────────────────────────────────

install_dotfiles() {
    local -a modules=("$@")

    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║              🏠 Dotfiles 安装脚本                              ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local os
    os=$(detect_os)
    info "检测到系统: $os"
    info "目标模块: ${modules[*]}"
    echo ""

    echo -e "${CYAN}━━━ 备份现有配置 ━━━${NC}"
    backup_existing "${modules[@]}"
    echo ""

    echo -e "${CYAN}━━━ 检查基础依赖 ━━━${NC}"
    command -v git &>/dev/null || install_package git
    command -v zsh &>/dev/null || install_package zsh
    command -v tmux &>/dev/null || install_package tmux
    command -v vim &>/dev/null || install_package vim
    command -v curl &>/dev/null || install_package curl
    success "基础依赖检查完成"
    echo ""

    echo -e "${CYAN}━━━ 检查现代工具 ━━━${NC}"
    check_modern_tools
    echo ""

    local m
    for m in "${modules[@]}"; do
        install_module "$m"
    done
    echo ""

    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ 安装完成！                                    ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}后续步骤:${NC}"
    echo "  1. 重新启动终端或运行: source ~/.zshrc"
    echo "  2. 如需自定义 Starship 提示符，编辑 ~/.config/starship.toml"
    echo "  3. 进入 tmux 后按 Ctrl+a I 安装 tmux 插件"
    echo "  4. 按需编辑 ~/dotfiles/misc/.env.local"
    echo ""
    echo -e "${BLUE}备份位置: ~/.dotfiles_backup/${NC}"
    echo ""
}

uninstall_dotfiles() {
    local -a modules=("$@")

    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║              🗑️  Dotfiles 卸载                                 ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    info "目标模块: ${modules[*]}"

    local m
    for m in "${modules[@]}"; do
        uninstall_module "$m"
    done

    echo ""
    info "符号链接已移除"
    info "如需恢复原配置，请查看备份目录: ~/.dotfiles_backup/"
    echo ""
}

verify_all() {
    local -a modules=("$@")
    local rc=0 m
    for m in "${modules[@]}"; do
        verify_module "$m" || rc=1
    done
    return "$rc"
}

# 输出选中模块的所有 dst 路径，每行一个。供 CI 卸载后校验等场景使用。
paths_for_modules() {
    local m line
    for m in "$@"; do
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            printf '%s\n' "${line#*=>}"
        done < <("module_${m}_links")
    done
}

#───────────────────────────────────────────────────────────────────────────────
# CLI 解析
#───────────────────────────────────────────────────────────────────────────────

show_help() {
    cat <<EOF
用法: $0 <命令> [选项...] [模块...]

命令:
  install [模块...]       安装指定模块；不带模块名 = 全部
  uninstall [模块...]     卸载指定模块；不带模块名 = 全部
  verify [模块...]        校验链接是否正确（CI 用）
  paths [模块...]         输出选中模块的所有 dst 路径（脚本/CI 用）
  list                    列出可用模块
  help                    显示本帮助

选项:
  --all                   显式选中全部模块
  --dry-run, -n           仅预览，不写入

模块: ${MODULE_NAMES[*]}

示例:
  $0 install                       # 装全部（=当前默认行为）
  $0 install --all                 # 装全部（显式）
  $0 install nvim tmux             # 仅装 nvim + tmux
  $0 install --dry-run shell git   # 预览
  $0 verify                        # 校验全部
  $0 uninstall dev                 # 仅卸载 dev 模块
EOF
}

#───────────────────────────────────────────────────────────────────────────────
# 主入口
#───────────────────────────────────────────────────────────────────────────────

main() {
    local cmd="${1:-install}"

    # 兼容旧调用：./install.sh --dry-run 等价于 ./install.sh install --dry-run
    case "$cmd" in
        --dry-run|-n)
            DRY_RUN=true
            cmd="install"
            shift
            ;;
        install|uninstall|verify|paths|list|help|--help|-h)
            shift
            ;;
        *)
            error "未知命令: $cmd"
            echo ""
            show_help
            exit 1
            ;;
    esac

    # list / help 不需要模块解析
    case "$cmd" in
        list) list_modules; return 0 ;;
        help|--help|-h) show_help; return 0 ;;
    esac

    # 解析剩余参数：分离标志 vs 模块名（在主 shell 内完成，避免 DRY_RUN 落进子壳丢失）
    local all=false
    local -a mod_args=()
    local a
    for a in "$@"; do
        case "$a" in
            --dry-run|-n) DRY_RUN=true ;;
            --all) all=true ;;
            *) mod_args+=("$a") ;;
        esac
    done

    # 解析模块名
    local -a selected=()
    if [[ ${#mod_args[@]} -gt 0 ]] && ! $all; then
        for a in "${mod_args[@]}"; do
            if ! is_valid_module "$a"; then
                error "未知模块: $a"
                info "可用模块: ${MODULE_NAMES[*]}"
                exit 1
            fi
            selected+=("$a")
        done
    else
        selected=("${MODULE_NAMES[@]}")
    fi

    case "$cmd" in
        install)
            if $DRY_RUN; then
                info "=== DRY-RUN 模式：仅预览操作，不写入任何文件 ==="
                echo ""
            fi
            install_dotfiles "${selected[@]}"
            ;;
        uninstall)
            uninstall_dotfiles "${selected[@]}"
            ;;
        verify)
            verify_all "${selected[@]}"
            ;;
        paths)
            paths_for_modules "${selected[@]}"
            ;;
    esac
}

main "$@"
