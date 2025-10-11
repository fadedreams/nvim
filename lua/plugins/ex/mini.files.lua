return {
  {
    'nvim-mini/mini.files',
    opts = {
      windows = {
        preview = false,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
      },
      options = {
        use_as_default_explorer = true,
        permanent_delete = false,
      },
      content = {
        filter = function(fs_entry)
          return not (fs_entry.name == "__pycache__" or fs_entry.name == ".DS_Store")
        end,
        sort = function(entries)
          local function compare_alphanumerically(e1, e2)
            if e1.is_dir and not e2.is_dir then
              return true
            end
            if not e1.is_dir and e2.is_dir then
              return false
            end
            if e1.pre_digits == e2.pre_digits and e1.digits ~= nil and e2.digits ~= nil then
              return e1.digits < e2.digits
            end
            return e1.lower_name < e2.lower_name
          end
          local sorted = vim.tbl_map(function(entry)
            local pre_digits, digits = entry.name:match '^(%D*)(%d+)'
            if digits ~= nil then
              digits = tonumber(digits)
            end
            return {
              fs_type = entry.fs_type,
              name = entry.name,
              path = entry.path,
              lower_name = entry.name:lower(),
              is_dir = entry.fs_type == 'directory',
              pre_digits = pre_digits,
              digits = digits,
            }
          end, entries)
          table.sort(sorted, compare_alphanumerically)
          return vim.tbl_map(function(x)
            return { name = x.name, fs_type = x.fs_type, path = x.path }
          end, sorted)
        end,
      },
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<c-l>",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "<a-w>",
        trim_left = "<",
        trim_right = ">",
        open_vsplit = "<c-v>",
      },
    },
    keys = {
      {
        '<leader>C',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = '[e]xplorer (directory of open file)',
      },
      {
        '<leader>c',
        function()
          require('mini.files').open(vim.loop.cwd(), true)
        end,
        desc = '[E]xplorer (current working directory)',
      },
      -- {
      --   '<leader>e',
      --   function()
      --     local bufname = vim.api.nvim_buf_get_name(0)
      --     local path = vim.fn.fnamemodify(bufname, ':p')
      --     if path and vim.uv.fs_stat(path) then
      --       require('mini.files').open(bufname, false)
      --     end
      --   end,
      --   desc = 'File explorer',
      -- },
    },
    config = function(_, opts)
      local minifiles = require('mini.files')
      minifiles.setup(opts)

      -- Utility function for yanking paths
      local function yank_path(modifier, path)
        if not path then
          vim.notify("No path to yank", vim.log.levels.WARN)
          return
        end
        local result = vim.fn.fnamemodify(path, modifier)
        vim.fn.setreg('"', result)
        vim.fn.setreg('+', result)
        vim.notify("Yanked: " .. result, vim.log.levels.INFO)
      end

      -- Dotfiles toggle from your config
      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require('mini.files').refresh { content = { filter = new_filter } }
      end

      -- Map split function from new code
      local function map_split(buf_id, lhs, direction)
        local function rhs()
          local window = minifiles.get_explorer_state().target_window
          if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
            return
          end
          local new_target_window
          vim.api.nvim_win_call(window, function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)
          minifiles.set_target_window(new_target_window)
          minifiles.go_in { close_on_file = true }
        end
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
      end

      -- Track explorer state from new code
      local minifiles_explorer_group = vim.api.nvim_create_augroup('mariasolos/minifiles_explorer', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = minifiles_explorer_group,
        pattern = 'MiniFilesExplorerOpen',
        callback = function()
          vim.g.minifiles_active = true
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        group = minifiles_explorer_group,
        pattern = 'MiniFilesExplorerClose',
        callback = function()
          vim.g.minifiles_active = false
        end,
      })

      -- Notify LSPs of file rename/move from new code
      vim.api.nvim_create_autocmd('User', {
        desc = 'Notify LSPs that a file was renamed',
        pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
        callback = function(args)
          local changes = {
            files = {
              {
                oldUri = vim.uri_from_fname(args.data.from),
                newUri = vim.uri_from_fname(args.data.to),
              },
            },
          }
          local will_rename_method, did_rename_method = 'workspace/willRenameFiles', 'workspace/didRenameFiles'
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method(will_rename_method) then
              local res = client:request_sync(will_rename_method, changes, 1000, 0)
              if res and res.result then
                vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
              end
            end
          end
          for _, client in ipairs(clients) do
            if client:supports_method(did_rename_method) then
              client:notify(did_rename_method, changes)
            end
          end
        end,
      })

      -- Combined autocommand for MiniFilesBufferCreate
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Dotfiles toggle keymap from your config
          vim.keymap.set('n', '<c-h>', toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set('i', '<c-h>', toggle_dotfiles, { buffer = buf_id })
          -- Split keymaps from new code
          map_split(buf_id, '<C-s>', 'belowright horizontal')
          map_split(buf_id, '<C-v>', 'belowright vertical')
          -- New yank keymaps
          vim.keymap.set('n', '<localleader>r', function()
            yank_path(':p:.', minifiles.get_fs_entry().path)
          end, { buffer = buf_id, desc = 'Yank relative path' })
          vim.keymap.set('n', '<localleader>p', function()
            yank_path(':p', minifiles.get_fs_entry().path)
          end, { buffer = buf_id, desc = 'Yank absolute path' })
          vim.keymap.set('n', '<localleader>n', function()
            local path = minifiles.get_fs_entry().path
            minifiles.close()
            yank_path(':t', path)
          end, { buffer = buf_id, desc = 'Yank filename' })
        end,
      })
    end,
  },
  -- Disable Neo-tree to avoid conflicts
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   enabled = false,
  -- },
  -- Disable netrw explicitly
  -- {
  --   'vim',
  --   enabled = false,
  --   init = function()
  --     vim.g.loaded_netrw = 1
  --     vim.g.loaded_netrwPlugin = 1
  --   end,
  -- },
}
