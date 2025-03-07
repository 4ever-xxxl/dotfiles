export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    extract 
    sudo
    copybuffer
    copypath
    copyfile
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf
)

source $ZSH/oh-my-zsh.sh

autoload -U colors && colors
export GROFF_NO_SGR=1

export CLASSPATH=/usr/local/lib/antlr-4.9.1-complete.jar:.
alias antlr4='java -jar /usr/local/lib/antlr-4.9.1-complete.jar'

export NEMU_HOME=/home/m1ca/Project/ysyx-workbench/nemu
export AM_HOME=/home/m1ca/Project/ysyx-workbench/abstract-machine
export NPC_HOME=/home/m1ca/Project/ysyx-workbench/npc
export NVBOARD_HOME=/home/m1ca/Project/ysyx-workbench/nvboard

alias nv="nvim"
alias lg="lazygit"
alias bat="batcat"

export NODE_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

export GALLIUM_DRIVER=d3d12

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


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

