return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- Custom action to delete all buffers except selected ones
      local function delete_all_except_selected(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        if not picker then
          vim.notify("Error: No active picker found", vim.log.levels.ERROR)
          return
        end

        local selected_entries = picker:get_multi_selection()
        -- If no entries are selected, use the current highlighted entry
        if #selected_entries == 0 then
          local current_entry = action_state.get_selected_entry()
          if current_entry then
            selected_entries = { current_entry }
          else
            vim.notify("Error: No buffer selected", vim.log.levels.ERROR)
            actions.close(prompt_bufnr)
            return
          end
        end

        -- Get list of buffer numbers to keep
        local keep_bufnrs = {}
        for _, entry in ipairs(selected_entries) do
          if entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
            table.insert(keep_bufnrs, entry.bufnr)
          end
        end

        -- Get all open buffers
        local all_buffers = vim.api.nvim_list_bufs()
        for _, bufnr in ipairs(all_buffers) do
          -- Check if buffer is valid and not in the keep list
          if vim.api.nvim_buf_is_valid(bufnr) and not vim.tbl_contains(keep_bufnrs, bufnr) then
            -- Only delete loaded buffers that are not modified
            if vim.api.nvim_buf_is_loaded(bufnr) and not vim.api.nvim_buf_get_option(bufnr, "modified") then
              pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
            elseif vim.api.nvim_buf_get_option(bufnr, "modified") then
              vim.notify("Skipping modified buffer: " .. vim.api.nvim_buf_get_name(bufnr), vim.log.levels.WARN)
            end
          end
        end

        -- Close Telescope
        actions.close(prompt_bufnr)
      end

      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
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
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-;>"] = actions.close,
              ["<a-q>"] = actions.send_selected_to_qflist,
              ["<c-q>"] = actions.send_to_qflist,
              ["<CR>"] = actions.select_default,
              ["<C-l>"] = actions.select_default,
              ["<C-a>"] = actions.move_to_top,
              ["<C-e>"] = actions.move_to_bottom,
              ["<C-v>"] = actions.select_vertical,
              ["<C-s>"] = actions.select_horizontal,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-;>"] = actions.close,
              ["<a-q>"] = actions.send_selected_to_qflist,
              ["<c-q>"] = actions.send_to_qflist,
              ["l"] = actions.select_default,
              ["<C-v>"] = actions.select_vertical,
              ["<C-s>"] = actions.select_horizontal,
            },
          },
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_mru = true,
            mappings = {
              i = {
                ["<c-x>"] = "delete_buffer",
                ["<C-d>"] = delete_all_except_selected, -- New keymap to delete all except selected
              },
              n = {
                ["<C-d>"] = delete_all_except_selected, -- Normal mode keymap
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
                height = 0.90,
                width = 0.90,
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
      {
        "<c-j>",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                height = 0.6,
                width = 0.6,
                preview_cutoff = 120,
                prompt_position = "top",
                preview_width = 0.6
              }
            },
          })
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>j",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                height = 0.6,
                width = 0.6,
                preview_cutoff = 120,
                prompt_position = "top",
                preview_width = 0.6
              }
            },
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
      {
        "<leader>v",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
            hidden = true,
            respect_gitignore = false,
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
      },
      {
        "<leader>dt",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
            hidden = true,
            respect_gitignore = false,
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
            },
            attach_mappings = function(_, map)
              map('i', '<CR>', function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                if selection then
                  vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(selection.path))
                end
              end)
              map('n', 'l', function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                if selection then
                  vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(selection.path))
                end
              end)
              return true
            end,
          })
        end,
        noremap = true,
        silent = true,
        desc = "[T]elescope [D]iff",
      }
    },
  }
}
