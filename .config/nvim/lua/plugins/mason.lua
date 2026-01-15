-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
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
