return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- Apply globally to all finders/sources
      hidden = true, -- Show hidden files (dotfiles) by default
      follow = true, -- Follow symlinks by default

      -- Optional: If you want this behavior specifically for file searches,
      -- you can set it under sources instead of globally:
      -- sources = {
      --   files = {
      --     hidden = true,
      --     follow = true,
      --   },
      -- },
    },
  },
  keys = {
    -- Keymap for <leader>fd to open ~/.config or your dotfiles directory
    {
      "<leader>fd",
      function()
        Snacks.picker.files({
          cwd = vim.fn.expand("~/dotfiles"), -- Set root directory to ~/dotfiles
          hidden = true, -- Ensures hidden files are shown for this picker
          follow = true, -- Ensures symlinks are followed for this picker
        })
      end,
      desc = "Find Dotfiles",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.files({
          cwd = vim.fn.expand("~/LaTeX"), -- Set root directory to ~/dotfiles
          hidden = true, -- Ensures hidden files are shown for this picker
          follow = true, -- Ensures symlinks are followed for this picker
        })
      end,
      desc = "Find Dotfiles",
    },
  },
}
