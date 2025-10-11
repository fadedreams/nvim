return {
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    config = function()
      require("grug-far").setup({
        keymaps = {
          replace = { n = "A" },
          close = { n = "q" },
        },
        engine = "ripgrep",
        debounceMs = 300,
        windowCreationCommand = "botright vnew", -- Opens window on the right side
      })
      -- Set keybinding to open grug-far with <leader>sr
      vim.keymap.set("n", "<leader>rr", function()
        require("grug-far").open()
      end, { noremap = true, silent = true , desc="Replace normal mode" 

        })
    end,
  },
}
