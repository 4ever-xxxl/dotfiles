" =============================================================================
"  _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
" | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
" |   ___   __   __      __      ___   __   _   _      _   _   _      _   _   |
" |  / __| |  V  | |    /  \    / __| /  \ | | | |    | | | | / \    | | | |  |
" | | |__  |  |  | |   / /\ \  | |__ | -- | | | |    | |_| |/ _ \   | |_| |  |
" |  \__ \ | |V| | |  / /__\ \  \__ \ \__/  | | |    |  _  / /_\ \  |  _  |  |
" |  ___/ | | | | | / /____\ \  __/ |      | |_|    | | |/ _____ \ | | | |  |
" | |____ | | | | |/ /      \ \|____|      \___/    |_| /_/     \_\|_| |_|  |
" |                                                                         |
" |        A Lightweight Vim Configuration for Quick Edits                  |
" |                                                                         |
" =============================================================================
" -----------------------------------------------------------------------------
" 核心设置 (Core Settings)
" -----------------------------------------------------------------------------
set nocompatible                " 必须！脱离vi兼容模式，拥抱Vim的现代功能
filetype plugin indent on       " 根据文件类型加载插件和缩进规则
syntax on                       " 开启语法高亮
set encoding=utf-8              " 使用UTF-8编码
set fileencodings=utf-8,latin1  " 文件编码检测顺序
" -----------------------------------------------------------------------------
" 用户界面 (UI)
" -----------------------------------------------------------------------------
set number                      " 显示行号
set relativenumber              " 显示相对行号（组合使用，当前行为绝对行号，其他为相对）
set cursorline                  " 高亮当前行
set ruler                       " 在右下角显示光标位置
set showcmd                     " 在右下角显示未完成的命令
set laststatus=2                " 始终显示状态栏
" 搜索高亮
set hlsearch                    " 高亮搜索结果
set incsearch                   " 输入搜索词时即时高亮
set ignorecase                  " 搜索时忽略大小写
set smartcase                   " 如果搜索词中包含大写字母，则不忽略大小写
" 外观
" colorscheme desert            " Vim 内置了几个不错的配色，比如 desert, delek, slate
" -----------------------------------------------------------------------------
" 编辑行为 (Editing Behavior)
" -----------------------------------------------------------------------------
" 缩进
set autoindent                  " 自动缩进
set smartindent                 " 智能缩进
set tabstop=4                   " Tab 宽度为4个空格
set shiftwidth=4                " 自动缩进宽度为4个空格
set expandtab                   " 将Tab转换为空格
" 换行
set wrap                        " 自动换行
set linebreak                   " 在单词边界处换行，而不是在字符中间
" 备份与交换文件 (建议关闭，保持目录清洁)
set nobackup
set nowritebackup
set noswapfile
" 使退格键（backspace）更好用
set backspace=indent,eol,start
" 命令行补全
set wildmenu                    " 开启命令模式下的菜单式补全
set wildmode=longest:full,full  " 补全模式设置
" -----------------------------------------------------------------------------
" 快捷键映射 (Key Mappings)
" -----------------------------------------------------------------------------
" 设置<Leader>键为空格，这是一个非常方便且不会冲突的键
let mapleader = ' '
let g:mapleader = ' '
" 快速保存
nnoremap <leader>w :w<CR>
" 快速退出
nnoremap <leader>q :q<CR>
" 重新加载 .vimrc 文件，使其立即生效
nnoremap <leader>ev :source $MYVIMRC<CR>
" 在可视模式下，可以重复缩进操作
vnoremap < <gv
vnoremap > >gv
" 取消搜索高亮
nnoremap <leader>/ :nohlsearch<CR>
" 使用内置文件浏览器 netrw
" 打开当前文件所在目录的文件浏览器
nnoremap <leader>e :Explore<CR>
" yank打通到windows
vmap <leader>y :w !clip.exe<CR><CR>
