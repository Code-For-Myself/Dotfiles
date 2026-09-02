return {
  {
    "lervag/vimtex",
    lazy = false, -- vimtex needs to load at startup, not lazily
    init = function()
      vim.g.vimtex_view_method = "zathura" -- see note below on Zotero
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "vimtex" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                onSave = false, -- vimtex already handles compilation
              },
              chktex = {
                onOpenAndSave = true, -- linting for common LaTeX mistakes
              },
            },
          },
        },
      },
    },
  },
}
