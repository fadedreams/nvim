--vim.cmd("colorscheme rose-pine")

vim.opt.guicursor = "a:block-Cursor/lCursor"
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"
vim.opt.isfname:append("@-@")

vim.opt.smoothscroll = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.g.autoformat = false
vim.opt.nu = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.scroll = 10
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
-- vim.opt.colorcolumn = "80"

vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.wo.foldmethod = "expr" -- Set foldmethod to expr
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.fillchars = {fold = " ", foldopen = "", foldsep = " ", foldclose = ""}
vim.opt.fillchars = {fold = " ", foldopen = "", foldsep = " ", foldclose = ""}
vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "indent-heuristic",
    "linematch:60",
    "algorithm:histogram",
    "context:20",
    "iwhiteall",
}

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.shadafile = vim.fn.stdpath("cache") .. "/nvim/shada/main.shada"
vim.opt.undodir = vim.fn.stdpath("cache") .. "/nvim/undo"
vim.opt.undofile = true
-- Set undodir and enable persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 1000

vim.opt.wrap = false
vim.opt.textwidth = 120
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.conceallevel = 0

vim.g.markdown_recommended_style = 0 -- see https://www.reddit.com/r/neovim/comments/z2lhyz/comment/ixjb7je
vim.opt.updatetime = 300
vim.opt.mouse = "a"
vim.opt.wildignore:append({
  -- "*/node_modules/*",        -- Node.js dependencies
  "*.pyc",                  -- Python compiled files
  "__pycache__/*",          -- Python cache directories
  "*/venv/*",               -- Python virtual environments
  "*/.venv/*",              -- Alternative Python virtual environment naming
  "*/target/*",             -- Rust build output
  "*/.cargo/registry/*",    -- Rust package registry
  "*.o",                    -- Go and C/C++ object files
  -- "*/vendor/*",             -- Go vendored dependencies, also used in PHP (Composer)
  "*.lock",                 -- Lock files for various package managers (e.g., Cargo.lock, composer.lock, Gemfile.lock)
  "*.sock",                 -- Unix socket files (common in Ruby/Rails)
  "*/tmp/*",                -- Temporary directories (common in Ruby/Rails and others)
  -- "*.gem",                  -- Ruby gem files
  "*/.bundle/*",            -- Ruby Bundler dependencies
  "*/vendor/bundle/*",      -- Ruby Bundler vendored dependencies
  -- "*.php~",                 -- PHP backup files
  "*/storage/logs/*",       -- Laravel (PHP) log files
  "*/.idea/*",              -- PHPStorm/IDE files (common in PHP development)
  "*.luac",                 -- Lua compiled files
  "*/_build/*",             -- Lua build directories (e.g., for LuaRocks)
  "*.swp",                  -- Vim/Neovim swap files
  "*.bak",                  -- Backup files
  "*.tmp",                  -- Temporary files
})
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- vim.opt.showtabline = 0
vim.opt.tabline = "%!v:lua.require('tabline').setup()"

-- Grep format
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.o.cmdheight = 0 --stick lualine to the bottom

-- Wrap long lines at a character in 'breakat'
-- vim.opt.linebreak = true

-- Don't break lines after a one-letter word
-- vim.cmd('set fo-=1')

-- Avoid comments to continue on new lines
-- vim.opt.formatoptions = vim.o.formatoptions:gsub('cro', '')

-- Keep indentantion on wrapped lines
-- vim.opt.breakindent = true

-- avante views can only be fully collapsed with the global statusline
-- This sets Neovim to use a single statusline for all windows, keeping lualine stuck at the bottom of the screen
-- vim.opt.laststatus = 3
