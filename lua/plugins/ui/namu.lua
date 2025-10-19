--             keymaps = {
--               toggle = "<Tab>",
--               untoggle = "<S-Tab>",
--               select_all = "<C-a>",
--               clear_all = "<C-l>",
--             },
-- You run :Namu symbols to list all functions in a buffer.
-- Press <C-a> to select all function symbols.
-- Then press <C-y> to yank the text of all selected symbols to the clipboard or <C-o> to send them to CodeCompanion for further processing.
return {
  {
    "bassamsdata/namu.nvim",
    lazy = true, -- Enable lazy loading
    -- event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    opts = {
      global = {
        window = {
          relative = "editor",
          auto_size = true,
          width_ratio = 0.4,
          min_width = 20,
          max_width = 60,
          min_height = 1,
          max_height = 30,
          padding = 1,
          border = "rounded",
          title_pos = "left",
          show_footer = true,
          footer_pos = "right",
          style = "minimal",
        },
        row_position = "top10_right",
        debug = true, -- Enable debug mode to log issues
      },
      namu_symbols = {
        enable = true,
        options = {}, -- Inherit global settings
      },
      workspace = {
        enable = true,
        options = {}, -- Inherit global settings
      },
      ui_select = { enable = false }, -- Disable ui_select for simplicity
    },
    keys = {
      { "<leader>sw", ":Namu symbols<cr>", desc = "[N]amu Jump to LSP symbol", silent = true },
      { "<leader>ss", ":Namu workspace<cr>", desc = "[N]amu LSP Symbols - Workspace", silent = true },
    },
  },
}
