-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "python",
      "c",
      "cpp",
      "rust",
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "scala", -- Chisel/Scala support
      -- add more arguments for adding more treesitter parsers
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        -- Disable highlight for large files to avoid performance issues
        local max_filesize = 500 * 1024 -- 500 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    sync_install = false,
    auto_install = true,
  },
}
