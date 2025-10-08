return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          -- Default Telescope settings (if needed)
          layout_strategy = "horizontal",
          sorting_strategy = "ascending", --show results on top
          -- path_display = { shorten = { len = 3, exclude = { 1, -1, -2 } } },
          layout_config = {
            horizontal = {
              height = 0.9,
              width = 0.9,
              preview_cutoff = 120,
              prompt_position = "top",
              preview_width = 0.6
            },
            vertical = {
              height = 0.9,
              width = 0.9,
              preview_cutoff = 40,
              prompt_position = "top"
            }
          },
          mappings = {
            i = { -- Insert mode
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-;>"] = actions.close, -- Close Telescope in insert mode
              ["<a-q>"] = actions.send_selected_to_qflist, -- Selected only
              ["<c-q>"] = actions.send_to_qflist, -- All, no auto-open
              ["<CR>"] = actions.select_default,
              ["<C-m>"] = actions.select_default,
              ["<C-a>"] = actions.move_to_top, -- Move to top of list
              ["<C-e>"] = actions.move_to_bottom, -- Move to bottom of list
              ["<C-v>"] = actions.select_vertical, -- Open in vertical split
              ["<C-s>"] = actions.select_horizontal, -- Open in horizontal split
            },
            n = { -- Normal mode
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-;>"] = actions.close, -- Close Telescope in normal mode
              ["<a-q>"] = actions.send_selected_to_qflist, -- Selected only
              ["<c-q>"] = actions.send_to_qflist, -- All, no auto-open
              ["m"] = actions.select_default,
              ["<C-v>"] = actions.select_vertical, -- Open in vertical split
              ["<C-s>"] = actions.select_horizontal, -- Open in horizontal split
            },
          },
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_mru = true,
            mappings = {
              i = {
                -- ["<c-d>"] = "delete_buffer",
              },
            },
          },
        },
      })
    end,
    keys = {
      {
        "<leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols({
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                height = 0.90, -- Near-fullscreen
                width = 0.90,  -- Near-fullscreen
                preview_cutoff = 120,
                prompt_position = "top",
                preview_width = 0.6
              }
            }
          })
        end,
        noremap = true,
        silent = true,
        desc = "Find Functions (LSP)",
      },
      -- {
      -- "<leader>ft",
      -- "<cmd>TodoTelescope layout_config={height=0.9,width=0.9}<cr>",
      -- noremap = true,
      -- silent = true,
      -- desc = "TODO",
      -- },
      -- {
      --   "<leader>fb",
      --   function()
      --     require("telescope.builtin").buffers()
      --   end,
      --   desc = "Find Buffers",
      -- },
      {
        "<c-j>",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true, -- Sort buffers by most recently used
            -- sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                height = 0.6, -- Smaller height
                width = 0.6,  -- Smaller width
                preview_cutoff = 120,
                prompt_position = "top",
                preview_width = 0.6
              }
            },
            -- winblend = 10, -- Transparency
          })
        end,
        desc = "Find Buffers",
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
    keys = {

      -- {
      --   "<leader>v",
      --   function()
      --     require("telescope").extensions.file_browser.file_browser({
      --       path = vim.fn.expand("%:p:h"), -- Use the current file's directory as path
      --       select_buffer = true,          -- Set select_buffer to true
      --       hidden = true,                 -- Show hidden files and folders
      --       respect_gitignore = false,     -- Do not respect .gitignore (show ignored files)
      --       layout_strategy = "horizontal",
      --       layout_config = {
      --         horizontal = {
      --           height = 0.9,
      --           width = 0.9,
      --           preview_cutoff = 120,
      --           prompt_position = "top",
      --           preview_width = 0.6
      --         }
      --       }
      --     })
      --   end,
      --   noremap = true,
      --   silent = true,
      --   desc = "File Browser",
      -- }
      {
        "<leader>v",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"), -- Use the current file's directory as path
            select_buffer = true,          -- Set select_buffer to true
            hidden = true,                 -- Show hidden files and folders
            respect_gitignore = false,     -- Do not respect .gitignore (show ignored files)
            layout_strategy = "vertical",
            layout_config = {
              vertical = {
                height = 0.9,
                width = 0.6,
                preview_cutoff = 40,
                prompt_position = "top",
                mirror = true,
                preview_height = 0.6
              }
            }
          })
        end,
        noremap = true,
        silent = true,
        desc = "File Browser",
      }

    },
  }
}
