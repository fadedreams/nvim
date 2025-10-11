return {
  "AckslD/nvim-neoclip.lua",
  event = "VeryLazy",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("neoclip").setup({
      history = 1000,
      enable_persistent_history = false,
      length_limit = 1048576,
      continuous_sync = false,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      prompt = nil,
      default_register = '"',
      default_register_macros = "q",
      enable_macro_history = true,
      content_spec_column = true,  -- NEW: Use content-specific column instead of side preview to significantly narrow the width
      dedent_picker_display = true,  -- NEW: Trim leading whitespace in display for cleaner, more compact view
      disable_keycodes_parsing = false,
      initial_mode = "insert",  -- Ensure this is set if you want to override in custom opts
      on_select = {
        move_to_front = false,
        close_telescope = true,
      },
      on_paste = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_replay = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
      },
      on_custom_action = {
        close_telescope = true,
      },
      keys = {
        telescope = {
          i = {
            select = "<cr>",
            paste = "<c-l>",
            replay = "<c-q>",
            delete = "<c-d>",
            edit = "<c-e>",
            custom = {},
          },
          n = {
            select = "<cr>",
            paste = "l",
            replay = "q",
            delete = "d",
            edit = "e",
            custom = {},
          },
        },
      },
    })

    -- NEW: Custom keymap to open Neoclip with narrowed dimensions
    -- Replace <leader>cc with your preferred key (e.g., your existing clipboard keymap)
    -- This uses a vertical layout for better compactness:
    -- - Fixed width of 70 characters (narrow!)
    -- - Fixed height of 25 lines (short!)
    -- - Preview (if enabled) shares the bottom space
    -- - Adjust numbers as needed: smaller width/height = more narrow
    -- - content_spec_column=true above already helps avoid wide horizontal previews
    vim.keymap.set({ "n", "v" }, "<leader>;", function()
      require("telescope").extensions.neoclip.default({
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            width = 70,  -- Narrow width (fixed chars; use 0.6 for 60% of screen)
            height = 25,  -- Short height (fixed lines; use 0.4 for 40% of screen)
            mirror = false,  -- Results above prompt
            preview_height = 0.4,  -- Optional: Limit preview to 40% of total height
          },
        },
        -- Optional: Other picker opts (e.g., match neoclip's initial_mode)
        initial_mode = "insert",
      })
    end, { desc = "Neoclip (narrow)" })

  end,
}
