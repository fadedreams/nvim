vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.timeoutlen = 300 -- Reduce to 500ms

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
--
-- vim.opt.showtabline = 0
vim.opt.tabline = "%!v:lua.require('tabline').setup()"

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.wo.foldmethod = "expr" -- Set foldmethod to expr
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.clipboard = "unnamedplus"

vim.opt.guicursor = "" -- Make Insert mode cursor a block (like Normal mode)
-- vim.opt.guicursor = "a:block-Cursor/lCursor"
-- vim.opt.cursorline = false

vim.opt.smoothscroll = true
--vim.opt.signcolumn = 'yes'

-- Editor
vim.g.autoformat = false
vim.opt.nu = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.o.cmdheight = 0 --sitck lualine to the bottom

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.shadafile = vim.fn.stdpath("cache") .. "/nvim/shada/main.shada"
vim.opt.undodir = vim.fn.stdpath("cache") .. "/nvim/undo"
vim.opt.undofile = true
-- Set undodir and enable persistent undo
-- Ensure dir exists
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.opt.undofile = true
vim.opt.undolevels = 1000

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
-- vim.opt.signcolumn = "yes" --sign column
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- avante views can only be fully collapsed with the global statusline
-- This sets Neovim to use a single statusline for all windows, keeping lualine stuck at the bottom of the screen
-- vim.opt.laststatus = 3

-- Search
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true

-- vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
vim.opt.cursorline = true --show curosr color

-- vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- Movement
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Coding
vim.opt.fileencoding = "utf-8"
vim.opt.foldmethod = "manual"

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Modes
vim.opt.mouse = "a"
