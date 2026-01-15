-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE

---@type LazySpec
return {
  -- Remove or comment out unused plugins to improve startup time

  -- == Disabled Examples (uncomment to use) ==

  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },

  -- == Custom Plugins ==

  -- Better highlight colors
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    priority = 1000,
    lazy = true,
  },

  -- Hex color viewer
  {
    "RaafatTurki/hex.nvim",
    event = "VeryLazy",
    config = function() require("hex").setup() end,
  },

  -- TODO comment highlighting
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Session persistence
  {
    "olimorris/persisted.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
