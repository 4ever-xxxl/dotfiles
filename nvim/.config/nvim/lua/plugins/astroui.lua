-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "nightfox",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        Pmenu = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        TabLine = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        WinBar = { bg = "NONE" },
        WinBarNC = { bg = "NONE" },
        WinSeparator = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },
        NeoTreeNormal = { bg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE" },
        NeoTreeFloatNormal = { bg = "NONE" },
        NeoTreeFloatBorder = { bg = "NONE" },
        NeoTreeSignColumn = { bg = "NONE" },
        NeoTreeStatusLine = { bg = "NONE" },
        NeoTreeStatusLineNC = { bg = "NONE" },
        NeoTreeVertSplit = { bg = "NONE" },
        NeoTreeWinSeparator = { bg = "NONE" },
        NeoTreeEndOfBuffer = { bg = "NONE" },
        NeoTreeTabActive = { bg = "NONE" },
        NeoTreeTabInactive = { bg = "NONE" },
        NeoTreeTabSeparatorActive = { bg = "NONE" },
        NeoTreeTabSeparatorInactive = { bg = "NONE" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
