-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    event = "User AstroFile",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      run_on_start = false,
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install any other package
        "tree-sitter-cli",

        -- c++
        "clangd",
        "codelldb",
        "clang-format",

        -- lua
        "lua-language-server",
        "stylua",

        -- python
        "basedpyright",
        "debugpy",
        "ruff",

        -- rust
        "rust-analyzer",
        "codelldb",
      },
    },
  },
}
