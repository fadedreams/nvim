vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.termguicolors = true

vim.keymap.del('n', '<C-l>')
vim.keymap.set('n', '<C-;>', ':nohlsearch<CR>:diffupdate<CR>:redraw!<CR>', { noremap = true, silent = true })
