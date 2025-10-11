return {
  {
    "echasnovski/mini.pairs",
    version = false,
    event = { "VeryLazy", "InsertEnter" }, -- Load on InsertEnter for faster activation
    opts = {
      modes = { insert = true, command = true, terminal = false },
      mappings = {
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].', register = { cr = false } }, -- Explicitly enable { }
      },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
    config = function()
      require('mini.pairs').setup()
      vim.keymap.set("i", '"', '"', { noremap = true })
      vim.keymap.set("i", "'", "'", { noremap = true })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "echasnovski/mini.extra",
    },
    opts = function()
      local ai = require("mini.ai")
      return {
        mappings = {
          around = "a", -- 'a' for around (e.g., vac for around class)
          inside = "i", -- 'i' for inside (e.g., vic for inside class)
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
          goto_left = "",
          goto_right = "",
        },
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          i = require("mini.extra").gen_ai_spec.indent(),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- Add class text object
          m = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.outer" }),
        },
      }
    end,
  },
  -- ga , or gA ,
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    version = false, -- Use main branch (latest development version)
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "echasnovski/mini.indentscope",
    event = { "VeryLazy", "BufReadPre", "BufNewFile" }, -- Load on buffer read or new file
    opts = {
      symbol = "│", -- Customize the indent line symbol
      options = {
        try_as_border = true, -- Treat indent as a border
      },
      draw = {
        delay = 0, -- No delay (in ms) for instant drawing
        animation = function()
          return 0
        end, -- Animation function returning 0ms for no animation
        predicate = function(scope)
          return not scope.body.is_incomplete
        end, -- Draw only complete scopes
        priority = 2, -- Symbol priority
      },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts) -- Set up the plugin with options
    end,
  },
  {
    "nvim-mini/mini.cursorword",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    version = false, -- Use main branch
    config = function()
      require("mini.cursorword").setup({
        -- Optional: Customize delay (in milliseconds)
        delay = 100,
      })
    end,
  },
  {
    "echasnovski/mini.diff",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.diff").setup({
        view = {
          -- style = "sign", -- Options: 'sign', 'number', or 'both'
          -- signs = { add = "+", change = "~", delete = "-" }, -- Custom signs for diff
        },
      })
      vim.keymap.set("n", "<leader>df", MiniDiff.toggle_overlay)
    end,
  },
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    version = false, -- Use the main branch (development version)
    -- version = "*", -- Uncomment to use the stable branch
    config = function()
      require("mini.icons").setup({
        -- Optional: Customize configuration (defaults shown in the document)
        style = "glyph", -- Use 'ascii' if your terminal/font doesn't support glyph icons
        -- Add custom configurations if needed, e.g.:
        -- filetype = { python = { icon = "🐍", color = "#3572A5" } },
      })
    end,
  },
  -- {
  --   "echasnovski/mini.notify",
  --   event = "VeryLazy", -- Load lazily on most events
  --   config = function()
  --     require("mini.notify").setup({
  --       -- Customize notification options
  --       lsp_progress = {
  --         enable = true, -- Show LSP progress notifications
  --         duration_last = 5000, -- Duration of last message in ms
  --       },
  --       window = {
  --         max_width_share = 0.6, -- Max width as a share of Nvim window
  --       },
  --     })
  --     -- Optional: Set mini.notify as the default notification handler
  --     vim.notify = require("mini.notify").make_notify()
  --   end,
  -- },
}
