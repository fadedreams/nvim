return {
  {
    "folke/trouble.nvim",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_close = false,
      auto_preview = true,
      auto_jump = false,
      focus = true, --focus on the diagnostics window
      follow = true,
      indent_guides = false, -- Disable Tree-sitter indent guides
      multiline = true,
      warn_no_results = true,
      open_no_results = false,
      win = {
        type = "split", -- Use split to avoid floating window issues
        position = "bottom",
        height = 10,
      },
      preview = {
        type = "main",
        scratch = true,
      },
      modes = {
        diagnostics = {
          auto_open = false,
          filter = { buf = 0 }, -- Current buffer diagnostics
        },
      },
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xr", "<cmd>Trouble symbols<cr>", desc = "symbols(Trouble)" },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
