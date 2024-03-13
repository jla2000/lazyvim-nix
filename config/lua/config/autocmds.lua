-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Disable formatting for these file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp.j2", "java" },
  callback = function()
    vim.b.autoformat = false
  end,
})
