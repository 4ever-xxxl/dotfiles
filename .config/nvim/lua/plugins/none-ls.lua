-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  -- Disable none-ls completely to avoid conflicts with LSP servers
  -- Use basedpyright for Python diagnostics and ruff_format for formatting
  enabled = false,
  opts = function(_, opts)
    local null_ls = require "null-ls"
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {})
  end,
}
