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
if [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
    antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
fi

# =============================================================================
# Completions
# =============================================================================
autoload -Uz compinit
for dump in "$HOME/.zcompdump"(N.mh+24); do
    compinit
done
compinit -C

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
# Conda/Mamba Configuration
# Machine-specific — see misc/.env.local.example to configure for your machine
# !! Contents within this block are managed by 'conda init' !!
# =============================================================================
# >>> conda initialize >>>
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
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
# Starship Prompt
# =============================================================================
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
