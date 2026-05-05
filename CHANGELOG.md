# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). This project does not currently follow Semantic Versioning — entries are grouped under `[Unreleased]` until tagged.

## [Unreleased]

### Added

- `CONTRIBUTING.md` and `CHANGELOG.md`.
- `LICENSE` file (MIT).
- CI lint job covering `bash -n`, `shellcheck`, and `./install.sh --dry-run`. Lint runs before the OS matrix so syntax errors fail fast.
- CI now verifies all 16 symlinks created by `install.sh` (previously 2: `.zshrc` and `.gitconfig`).
- Cross-platform clangd config path: macOS now links to `~/Library/Preferences/clangd/config.yaml`; Linux still uses `~/.config/clangd/config.yaml`.
- `safe_remove()` helper in `install.sh` with three guards: target must be non-empty, must not be `/`, and must be inside `$HOME`.
- `ERR` trap in `install.sh` reporting line / failed command / exit code on failure.

### Changed

- `install.sh` now runs under `set -euo pipefail` instead of `set -e`.
- Tmux theme switched from Dracula to Catppuccin (mocha) to match Alacritty; the conflicting manual color block (which was being overridden by the plugin at TPM init) was removed.
- README and `GEMINI.md` aligned with the actual stack (Starship instead of Powerlevel10k; no GNU Stow).
- `actions/checkout` bumped from v3 (deprecated) to v4.

### Fixed

- `PATH` additions in `misc/.env` are now guarded with `[ -d ... ]`. Previously, machines without the relevant toolchain (e.g. `/opt/riscv/bin`) would still get those paths injected, slowing command lookup and confusing diagnostics.
- `LD_LIBRARY_PATH` now uses `${VAR:+:$VAR}` to avoid a trailing colon, which Unix interprets as the current directory — a long-standing security footgun.
- `misc/.env.local` permissions enforced to 644 on generation. The live file on the maintainer's machine had drifted to 755 (executable).
- Hardcoded local proxy (`127.0.0.1:7897`) removed from `git/.gitconfig`. Per-machine proxy config should live in `gitconfig-personal` or environment variables.
- Bare `rm -rf "$dest"` in `create_symlink` replaced with `safe_remove`, which refuses to delete `/`, paths outside `$HOME`, or empty targets, and uses `rm -rf --` to neutralise paths starting with `-`.

### Removed

- Tracked `shell/.zcompdump` (zsh-generated cache that was accidentally committed). Added matching ignore patterns to `.gitignore`.
- Empty `scripts/` and `docs/` directories that contained only orphan `__pycache__/`.
