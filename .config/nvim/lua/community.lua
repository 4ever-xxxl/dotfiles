-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.verilog" },

  { import = "astrocommunity.recipes.telescope-lsp-mappings" },

  { import = "astrocommunity.completion.cmp-cmdline" },

  { import = "astrocommunity.colorscheme.catppuccin" },
  -- import/override with your plugins folder
  --
  --
  {
    "catppuccin",
    opts = {
      flavour = "latte",
    },
  },
}
