# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  history-substring-search
  autojump
  docker
  python
  nvm
  command-not-found
  extract
  copybuffer
  copypath
  copyfile
  sudo
)

source $ZSH/oh-my-zsh.sh

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/opt/riscv/bin"

autoload -U colors && colors
export GROFF_NO_SGR=1

alias nv="nvim"
alias lg="lazygit"
alias bat="batcat"

export NODE_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

export GALLIUM_DRIVER=d3d12

# Created by `pipx` on 2024-09-28 03:24:56

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fnm
FNM_PATH="/home/lx10ng/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/lx10ng/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Created by `pipx` on 2025-06-26 05:10:19
export PATH="$PATH:/home/lx10ng/.local/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
