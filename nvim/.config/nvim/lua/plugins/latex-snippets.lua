return {
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    ft = { "tex", "markdown" }, -- only load for tex/markdown files
    config = function()
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
      require("luasnip-latex-snippets").setup()
      require("luasnip").config.setup({ enable_autosnippets = true })
      local ls = require("luasnip")
      ls.config.setup({ enable_autosnippets = true })
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })
    end,
  },
}
