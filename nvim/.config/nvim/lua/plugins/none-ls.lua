-- None-ls is completely disabled to avoid conflicts with LSP servers
-- Using basedpyright for Python diagnostics and ruff_format for formatting instead

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  enabled = false,
}
