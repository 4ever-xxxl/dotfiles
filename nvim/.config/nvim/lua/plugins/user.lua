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

  {
    "catppuccin/nvim",
    name = "catppuccin",
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

  -- == Highly Recommended Plugins ==

  -- Quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon.setup {
        global_settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      }
    end,
  },

  -- Fast code formatter (better alternative to none-ls)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        scala = { "scalafmt" },
        chisel = { "scalafmt" },
      },
    },
  },

  -- Code runner
  {
    "CRAG666/code_runner.nvim",
    event = "VeryLazy",
    opts = {
      filestype = {
        python = "python3 $file",
        lua = "lua $file",
        cpp = "cd $dir && g++ -std=c++20 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        rust = "cd $dir && cargo run",
        scala = "cd $dir && scala $fileName",
      },
    },
  },

  -- AI code completion
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          debounce = 75,
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
}
