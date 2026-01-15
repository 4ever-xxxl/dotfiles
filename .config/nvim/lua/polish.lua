-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't fit in the normal config locations above can go here

-- Performance optimization: set updatetime for faster LSP feedback
vim.opt.updatetime = 250

-- Ensure stylua is used for Lua formatting
vim.g.stylua_formatting = true
