return {{
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  dependencies = {
    {"windwp/nvim-ts-autotag", opts = {}},
    {"nvim-treesitter/nvim-treesitter-context", opts = {enable = false}},
  },
  cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo"},
  build = ":TSUpdate",
  lazy = vim.fn.argc(-1) == 0,
  config = function()
    local configs = require("nvim-treesitter.configs")
    local parsers = require("nvim-treesitter.parsers")

    configs.setup({
      ensure_installed = {
        "bash",
        "css",
        "diff",
        "dockerfile",
        "go",
        "gomod",
        "gowork",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "prisma",
        "python",
        "regex",
        "rust",
        "scss",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "toml",
      },
      highlight = {enable = true},
      indent = {enable = true},
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader>ti",
          scope_incremental = "<leader>ts",
          node_incremental = "v",
          node_decremental = "V",
        },
      },
    })

    local parser_configs = parsers.get_parser_configs()
    parser_configs.tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}
  end,
},

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true, -- Enable the plugin by default
      multiwindow = false, -- Disable multiwindow support (optional)
      max_lines = 0, -- No limit on context lines (default)
      min_window_height = 0, -- No minimum window height (default)
      line_numbers = true, -- Show line numbers in context (default)
      multiline_threshold = 20, -- Max lines for a single context (default)
      trim_scope = "outer", -- Discard outer lines if max_lines exceeded (default)
      mode = "cursor", -- Update context based on cursor position (default)
      separator = nil, -- No separator by default
      zindex = 20, -- Z-index for context window (default)
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      --TODO: change k
      vim.keymap.set("n", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
      vim.keymap.set("i", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
    end,
  },

}
