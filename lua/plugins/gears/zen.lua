return   {
    "folke/zen-mode.nvim",
    -- dependencies = { "folke/twilight.nvim" },
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        -- kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  }
