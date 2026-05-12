#!/usr/bin/env bash
# detect-clipboard.sh — 打印当前平台可用的剪贴板写入命令
#
# 由 tmux 通过 run-shell 调用，结果赋给 @copy_command。
# 优先级：WSL(win32yank) → macOS(pbcopy) → Wayland(wl-copy) → X11(xclip) → xsel
#
# 找不到任何工具时静默退出（空串）；tmux 仍可走 OSC52（set -s set-clipboard on）兜底。

set -eu

if command -v win32yank.exe >/dev/null 2>&1; then
    printf 'win32yank.exe -i --crlf'
elif command -v pbcopy >/dev/null 2>&1; then
    printf 'pbcopy'
elif command -v wl-copy >/dev/null 2>&1; then
    printf 'wl-copy'
elif command -v xclip >/dev/null 2>&1; then
    printf 'xclip -in -selection clipboard'
elif command -v xsel >/dev/null 2>&1; then
    printf 'xsel --clipboard --input'
fi
