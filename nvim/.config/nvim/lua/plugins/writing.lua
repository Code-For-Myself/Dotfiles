return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 85,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },
      plugins = {
        options = {
          enabled = true,
          laststatus = 0, -- hide Neovim's statusline while active
        },
        gitsigns = { enabled = false },
        twilight = { enabled = false },
      },
      on_open = function()
        vim.fn.jobstart("hyprctl dispatch fullscreen")
      end,
      on_close = function()
        vim.fn.jobstart("hyprctl dispatch fullscreen")
      end,
    },
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode (fullscreen writing)" },
    },
  },
}
