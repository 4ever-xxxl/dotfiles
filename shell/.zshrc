# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load environment variables
if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

# =============================================================================
# Shell Optimization
# =============================================================================
# Increase history limits for better command recall
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history

# Optimize zsh history
setopt EXTENDED_HISTORY      # save command timestamp
setopt HIST_FIND_NO_DUPS     # ignore duplicates when searching
setopt HIST_IGNORE_ALL_DUPS  # ignore all duplicates in history
setopt HIST_SAVE_NO_DUPS     # don't save duplicate commands
setopt HIST_IGNORE_SPACE     # ignore commands starting with space

# =============================================================================
# Oh-My-Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Disable auto-update to avoid slowdown
zstyle ':omz:update' mode disabled

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  history-substring-search
  autojump
  docker
  python
  command-not-found
  extract
  copybuffer
  sudo
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Powerlevel10k Configuration
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U colors && colors
export GROFF_NO_SGR=1

# =============================================================================
# Node Version Manager (fnm) - Lazy loaded for faster startup
# =============================================================================
fnm_lazy_init() {
  eval "$(fnm env)"
  # Replace this function with the actual fnm init
  unset fnm_lazy_init
}

# Load fnm only when needed (first use of node/npm)
node() { fnm_lazy_init; command node "$@"; }
npm() { fnm_lazy_init; command npm "$@"; }
pnpm() { fnm_lazy_init; command pnpm "$@"; }
yarn() { fnm_lazy_init; command yarn "$@"; }

# =============================================================================
# Conda/Mamba Configuration
# =============================================================================
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# =============================================================================
# Useful Aliases
# =============================================================================
alias ll='ls -lah'
alias la='ls -la'
alias l='ls -l'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Development aliases
alias nvim-config='cd ~/.config/nvim'
alias dotfiles='cd ~/dotfiles'
alias python='python3'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'

# =============================================================================
# Key Bindings & FZF Integration (deferred to avoid instant prompt issues)
# =============================================================================
# FZF will be loaded after instant prompt
{
  if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
  fi
} &>/dev/null

# =============================================================================
# Editor Configuration
# =============================================================================
export EDITOR=nvim
export VISUAL=nvim