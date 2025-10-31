vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- === OPTIONS ===
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

-- === DIAGNOSTICS ===
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- === PLUGINS ===
require("lazy").setup({
  -- Colorscheme
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("kanagawa") end },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "rust", "go", "lua", "vim", "vimdoc", "query" },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },

  -- lazydev.nvim (for enhanced Lua completions in config files)
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on Lua files
    opts = {
      library = {
        -- Load Neovim runtime files
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  -- blink.cmp
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "folke/lazydev.nvim" }, -- Critical: ensures module is available
    opts = {
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = {
          function()
            local inline = vim.lsp.inline_completion and vim.lsp.inline_completion.get()
            if inline and inline.items and #inline.items > 0 then
              return { "native_inline" }
            else
              return { "select_next" }
            end
          end,
          "fallback",
        },
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false } },
        },
        keymap = {
          preset = "enter",
          ["<C-y>"] = { "show_and_insert" },
          ["<CR>"] = { "accept_and_enter", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" }, -- lazydev now works
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          lsp = {
            fallbacks = { "buffer", "path" },
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 3,
            opts = {
              friendly_snippets = false,
              search_paths = { vim.fn.stdpath("config") .. "/snippets/nvim" },
            },
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        trigger = { show_on_accept_on_trigger_character = false },
        list = {
          selection = { preselect = false, auto_insert = false },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", gap = 2 },
              { "kind_icon", gap = 1, "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "none",
            max_width = math.floor(vim.o.columns * 0.4),
            max_height = math.floor(vim.o.lines * 0.5),
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },

  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { section_separators = "", component_separators = "" } })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({ spec = { { "<leader>s", group = "[S]earch" } } })
    end,
  },

  -- Utilities
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
  { "folke/todo-comments.nvim", config = true },
})

-- === LSP SETUP ===
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
end)

local on_attach = function(_, bufnr)
  local buf = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  buf("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  buf("n", "K", vim.lsp.buf.hover, "Hover")
  buf("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
end

local lsp_servers = {
  gopls = {
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
        completion = { callSnippet = "Replace" },
      },
    },
  },
}

-- Setup LSP servers
for server_name, server_config in pairs(lsp_servers) do
  vim.lsp.config(server_name, vim.tbl_deep_extend("force", server_config, {
    capabilities = capabilities,
    on_attach = on_attach,
  }))
end

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})
