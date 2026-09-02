return {
  -- Syntax highlighting + filetype detection
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
  },

  -- Live preview (renders in browser, updates on save/edit)
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      -- opens in your default browser by default
    },
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle" },
    },
  },

  -- LSP config: hook tinymist into nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onSave", -- auto-export PDF when you save
            semanticTokens = "disable",
          },
        },
      },
    },
  },
}
