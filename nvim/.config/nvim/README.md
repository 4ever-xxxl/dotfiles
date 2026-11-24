# AstroNvim user configuration

AstroNvim v6 configuration for Neovim 0.12. The plugin and community-pack selections are based on the previous setup in `nvim-bak`.

## Requirements

- Neovim 0.12 or newer
- Git, `curl`, and `tar`
- `tree-sitter-cli` 0.26.1 or newer, installed from a system package manager
- A C compiler and the standard C++ library

The current `nvim-treesitter` release uses its `main` branch with Neovim 0.12 and requires the parser CLI and compiler when installing parsers. AstroNvim manages parsers through its AstroCore Treesitter settings and runs `:TSUpdate` when updating the plugin.

## Install

This configuration lives in the dotfiles repository. Link it to Neovim's standard config path:

```sh
ln -s ~/dotfiles/nvim/.config/nvim ~/.config/nvim
```

Start Neovim and let `lazy.nvim` install AstroNvim and the configured plugins. Use `:Lazy sync` to synchronize plugins later. Mason-managed language servers, debuggers, and formatters are listed in `lua/plugins/mason.lua`.

## Included language support

AstroCommunity packs are enabled for CMake, C/C++, Go, Java, Lua, Markdown, Python, Rust, Scala, and Verilog. Other configured plugins are listed in `lua/plugins/user.lua`.
