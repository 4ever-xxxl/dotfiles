# Contributing

Thanks for your interest in improving these dotfiles. The repo is small, so the workflow is light — but a few conventions keep the install path safe to share across machines and the history easy to read.

## Local Development

### Test changes without writing to disk

```bash
./install.sh --dry-run
```

Walks the full install pipeline and prints every action that *would* happen, without creating symlinks, downloading plugins, or invoking package managers.

### Run the same checks CI runs

```bash
bash -n install.sh                  # syntax
shellcheck --severity=error install.sh   # static analysis
./install.sh --dry-run              # full smoke
```

CI fails on any of these. Running them locally before pushing saves a round-trip.

### Full install / uninstall cycle (destructive)

```bash
./install.sh install
./install.sh uninstall
```

`install` backs up existing real files to `~/.dotfiles_backup/<timestamp>/` before symlinking. `uninstall` only removes symlinks; backups stay intact.

## Conventions

### Commit Messages

[Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<optional scope>): <short summary>

<optional body>
```

Types in active use: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`, `style`.

Examples from history:
- `fix(install): harden install.sh with strict mode and safe_remove guard`
- `ci: bump actions/checkout from v3 to v4`
- `refactor(tmux): switch theme to Catppuccin to match Alacritty`

### File Organization

Each tool gets its own top-level directory mirroring its target layout:

| Directory | Targets |
|---|---|
| `shell/` | `~/.zshrc`, `~/.zsh_plugins.txt`, `~/.config/fish` |
| `tmux/` | `~/.tmux.conf` |
| `alacritty/` | `~/.config/alacritty` |
| `nvim/` | `~/.config/nvim` |
| `git/` | `~/.gitconfig`, `~/.gitconfig-personal`, `~/.gitconfig-work` |
| `misc/` | `~/.vimrc`, `~/.gdbinit`, `~/.clang-format`, `~/.condarc`, `~/.env`, etc. |

When you add a new config:

1. Add the source file under the appropriate package directory.
2. Add a `create_symlink` call in `install.sh::install_dotfiles`.
3. Add the target path to the `uninstall_dotfiles` files array.
4. Add a matching `check` line to `.github/workflows/ci.yml`.

### Cross-platform paths

Tools whose config location differs between Linux and macOS (e.g. clangd) should be linked through a helper function in `install.sh`, not hardcoded. See `clangd_config_path()` for the pattern.

### Secrets and personal data

- **Never** commit secrets, tokens, or personal endpoints.
- Machine-specific values (proxy host, conda root, GPU paths, etc.) live in `misc/.env.local`, which is gitignored. The template `misc/.env.local.example` lists the keys.
- Per-machine git identity goes in `git/.gitconfig-personal` or `git/.gitconfig-work`.

### Shell script style

- Scripts use `set -euo pipefail` and an `ERR` trap; preserve those when editing `install.sh`.
- Use `safe_remove` (not bare `rm -rf`) for any new path-deletion logic.
- Guard `PATH` additions with `[ -d "$dir" ] && export PATH=...` so missing tools don't pollute `$PATH`.

## Scope

This is a personal dotfiles repository. Bug fixes (broken symlinks, CI failures, portability, security issues) are always welcome. Opinionated rewrites of working configs probably aren't — open an issue first to discuss.
