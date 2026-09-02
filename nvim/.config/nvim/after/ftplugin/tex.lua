vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
  buffer = true,
  silent = true,
})
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- wrap at word boundaries, not mid-word
vim.opt_local.textwidth = 0 -- don't hard-wrap with inserted newlines; wrap is visual only
vim.opt_local.wrapmargin = 0
vim.opt_local.scrolloff = 999
