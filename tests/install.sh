#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home"
mkdir -p "$HOME/.antidote" "$HOME/.tmux/plugins/tpm"
printf 'private\n' > "$HOME/.env.local"
printf 'original\n' > "$HOME/.zshrc"
ln -s /some/other/config "$HOME/.zsh_plugins.txt"
"$repo/install.sh" install --dry-run shell > /dev/null
[[ ! -d "$HOME/.dotfiles_backup" && ! -L "$HOME/.zshrc" ]]
"$repo/install.sh" install shell > /dev/null
[[ $(cat "$HOME/.env.local") == private && ! -L "$HOME/.env.local" ]]
backup=$(find "$HOME/.dotfiles_backup" -mindepth 1 -maxdepth 1 -type d | head -n 1)
[[ $(cat "$backup/.zshrc") == original ]]
[[ $(readlink "$backup/.zsh_plugins.txt") == /some/other/config ]]
"$repo/install.sh" install shell > /dev/null
rm "$HOME/.zshrc"
ln -s /some/other/config "$HOME/.zshrc"
"$repo/install.sh" uninstall shell > /dev/null
[[ $(readlink "$HOME/.zshrc") == /some/other/config ]]
rm "$HOME/.env.local"
"$repo/install.sh" install shell > /dev/null
[[ -f "$HOME/.env.local" && ! -L "$HOME/.env.local" ]]
[[ $(stat -c '%a' "$HOME/.env.local" 2>/dev/null || stat -f '%Lp' "$HOME/.env.local") == 600 ]]
echo 'installer tests passed'
