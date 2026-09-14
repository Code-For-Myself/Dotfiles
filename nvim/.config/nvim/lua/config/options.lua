-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("noice").setup({
  routes = {
    {
      filter = {
        event = "lsp",
        kind = "progress",
        find = "Checking document",
      },
      opts = {
        skip = true,
      },
    },
  },
})
