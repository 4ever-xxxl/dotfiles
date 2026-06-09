# =============================================================================
# History
# =============================================================================
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY      # save command timestamp
setopt HIST_FIND_NO_DUPS     # ignore duplicates when searching
setopt HIST_IGNORE_ALL_DUPS  # ignore all duplicates in history
setopt HIST_SAVE_NO_DUPS     # don't save duplicate commands
setopt HIST_IGNORE_SPACE     # ignore commands starting with space
setopt SHARE_HISTORY         # share history across sessions

# =============================================================================
# Antidote Plugin Manager
# =============================================================================
# Some Oh My Zsh plugins require ZSH_CACHE_DIR to be defined
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
if [[ ! -d "$ZSH_CACHE_DIR/completions" ]]; then
    mkdir -p "$ZSH_CACHE_DIR/completions"
fi
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

if [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
    antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
fi

if command -v zellij &>/dev/null; then
    _zellij_completion="$ZSH_CACHE_DIR/completions/_zellij"
    _zellij_bin="$(command -v zellij)"
    if [[ ! -s "$_zellij_completion" || "$_zellij_completion" -ot "$_zellij_bin" ]]; then
        zellij setup --generate-completion zsh >| "$_zellij_completion" 2>/dev/null || rm -f "$_zellij_completion"
    fi
    unset _zellij_completion _zellij_bin
fi

# =============================================================================
# Completions & Suggestions Configuration
# =============================================================================
# Improve zsh-autosuggestions performance and intelligence
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completion styling (case-insensitive, menu selection)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

autoload -Uz compinit
for dump in "$HOME/.zcompdump"(N.mh+24); do
    compinit
done
compinit -C
# Compile zcompdump for faster startup
if [[ -s "$HOME/.zcompdump" && (! -s "${HOME}/.zcompdump.zwc" || "$HOME/.zcompdump" -nt "${HOME}/.zcompdump.zwc") ]]; then
    zcompile "$HOME/.zcompdump"
fi

# =============================================================================
# Key Bindings
# =============================================================================
# History substring search (plugin must be loaded first via antidote)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# =============================================================================
# FZF Integration
# =============================================================================
if command -v fzf &>/dev/null; then
    _fzf_init=$(fzf --zsh 2>/dev/null)
    if [ $? -eq 0 ]; then
        eval "$_fzf_init"
    elif [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
    fi
    unset _fzf_init
fi

# =============================================================================
# Environment
# =============================================================================
if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

export EDITOR=nvim
export VISUAL=nvim
export GROFF_NO_SGR=1

# =============================================================================
# Starship Prompt
# =============================================================================
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi


# Added by Antigravity CLI installer
export PATH="/home/lx10ng/.local/bin:$PATH"

# =============================================================================
# Login Directory Redirect
# =============================================================================
# 在登陆后跳转回home目录 (避免在 tmux 或 VS Code 终端中重置目录)
if [[ -o login && -z "$TMUX" && "$TERM_PROGRAM" != "vscode" ]]; then
    cd "$HOME"
fi

