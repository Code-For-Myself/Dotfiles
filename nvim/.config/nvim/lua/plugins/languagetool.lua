return {
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "tex", "markdown" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          cmd = { vim.fn.expand("~/.local/bin/ltex-ls-wrapped") },
          filetypes = { "tex", "markdown", "text" },
          settings = {
            ltex = {
              language = "en-US",
            },
          },
          on_attach = function(client, bufnr)
            require("ltex_extra").setup({
              load_langs = { "en-US" },
              path = vim.fn.expand("~/.config/nvim/ltex"),
            })
          end,
        },
      },
    },
  },
}
