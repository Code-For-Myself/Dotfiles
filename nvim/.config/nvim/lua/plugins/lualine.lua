return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      function()
        return vim.fn.wordcount().words .. " words"
      end,
      cond = function()
        return vim.bo.filetype == "tex" or vim.bo.filetype == "markdown"
      end,
    })
  end,
}
