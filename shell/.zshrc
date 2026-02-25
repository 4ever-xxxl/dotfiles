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

# Disable auto-update and optimize completion
zstyle ':omz:update' mode disabled
zstyle ':omz:completion' use-cache yes
zstyle ':omz:completion' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Speed up compinit by using a cache file
autoload -Uz compinit
for dump in "$HOME/.zcompdump"(N.mh+24); do
  compinit
done
compinit -C

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  history-substring-search
  docker
  extract
  copybuffer
  sudo
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Key Bindings & FZF Integration
# =============================================================================
# Silent and robust fzf loading to avoid instant prompt warnings
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
# Powerlevel10k Configuration
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -U colors && colors
export GROFF_NO_SGR=1

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
# Editor Configuration
# =============================================================================
export EDITOR=nvim
export VISUAL=nvim