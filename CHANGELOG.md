# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project does not currently follow Semantic Versioning — entries are grouped under `[Unreleased]` until tagged.

## [Unreleased]

### Added

- **mise integration**: Added `mise` configuration (`shell/.config/mise/config.toml`) to manage development tools and language runtimes (Node.js, Java, Go, Python, Bun, Neovim, Starship, and modern CLI tools like `ripgrep`, `fd`, `fzf`, `lazygit`, etc.) with optimized environment and recommended settings.
- **Modular install.** `./install.sh install nvim tmux` (or any subset of `shell tmux alacritty nvim vim git dev`) — single-module installs instead of all-or-nothing. New subcommands: `list`, `verify`, `paths`. `install`/`uninstall` with no module names preserves the previous "everything" behavior for backward compatibility. `--all` is the explicit synonym.
- **Cross-platform clipboard.** New `tmux/.tmux/scripts/detect-clipboard.sh` probes `win32yank.exe → pbcopy → wl-copy → xclip → xsel` and tmux loads the result into `@copy_command` at config-load time (via `run-shell`, since `#(...)` is not re-evaluated after `#{...}` substitution). OSC52 fallback (`set -s set-clipboard on`) covers SSH sessions. `misc/.vimrc`'s `<leader>y` now probes the same chain instead of hardcoding `clip.exe`.
- `CONTRIBUTING.md` and `CHANGELOG.md`.
- `LICENSE` file (MIT).
- CI lint job covering `bash -n`, `shellcheck`, and `./install.sh --dry-run`. Lint runs before the OS matrix so syntax errors fail fast.
- CI now verifies all 17 symlinks created by `install.sh` (previously 2: `.zshrc` and `.gitconfig`).
- Cross-platform clangd config path: macOS now links to `~/Library/Preferences/clangd/config.yaml`; Linux still uses `~/.config/clangd/config.yaml`.
- `safe_remove()` helper in `install.sh` with three guards: target must be non-empty, must not be `/`, and must be inside `$HOME`.
- `ERR` trap in `install.sh` reporting line / failed command / exit code on failure.

### Changed

- **Tooling Migration to mise**: Migrated runtime managers (`fnm`, `sdkman`, `bun`) and standalone installations (like Starship and AI CLIs) to `mise`.
- **Cleaned Env & Install Scripts**: Removed redundant tool installer code from `install.sh` and obsolete `PATH` extensions/completion scripts from `misc/.env`.
- `install.sh` rewritten around a module manifest (`module_<name>_links` / `module_<name>_preinstall`). The manifest is the single source of truth — CI's `Verify Symlinks` step shrank from ~48 lines of hardcoded `check` calls to `./install.sh verify`, and `Verify Uninstall` derives paths from `./install.sh paths` instead of duplicating the list.
- `install.sh` now runs under `set -euo pipefail` instead of `set -e`.
- Tmux theme switched from Dracula to Catppuccin (mocha) to match Alacritty; the conflicting manual color block (which was being overridden by the plugin at TPM init) was removed.
- README and `GEMINI.md` aligned with the actual stack (Starship instead of Powerlevel10k; no GNU Stow).
- `actions/checkout` bumped from v3 (deprecated) to v4.

### Fixed

- `uninstall_dotfiles` was missing `.gitconfig-personal` and `.gitconfig-work` (installed but never removed). The new manifest-driven uninstall covers all dst paths automatically.
- `PATH` additions in `misc/.env` are now guarded with `[ -d ... ]`. Previously, machines without the relevant toolchain (e.g. `/opt/riscv/bin`) would still get those paths injected, slowing command lookup and confusing diagnostics.
- `LD_LIBRARY_PATH` now uses `${VAR:+:$VAR}` to avoid a trailing colon, which Unix interprets as the current directory — a long-standing security footgun.
- `misc/.env.local` permissions enforced to 644 on generation. The live file on the maintainer's machine had drifted to 755 (executable).
- Hardcoded local proxy (`127.0.0.1:7897`) removed from `git/.gitconfig`. Per-machine proxy config should live in `gitconfig-personal` or environment variables.
- Bare `rm -rf "$dest"` in `create_symlink` replaced with `safe_remove`, which refuses to delete `/`, paths outside `$HOME`, or empty targets, and uses `rm -rf --` to neutralise paths starting with `-`.

### Removed

- Tracked `shell/.zcompdump` (zsh-generated cache that was accidentally committed). Added matching ignore patterns to `.gitignore`.
- Empty `scripts/` and `docs/` directories that contained only orphan `__pycache__/`.
