return {
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 10,
        default_detail = 1,
        bindings = {
          ["q"] = "<Cmd>OverseerClose<CR>",
          ["<CR>"] = "<Cmd>OverseerRun<CR>",
          ["<C-a>"] = "<Cmd>OverseerTaskAction<CR>",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Existing Node.js template
      overseer.register_template({
        name = "Run Node.js",
        builder = function(params)
          return {
            cmd = { "node" },
            args = { params.file or vim.fn.expand("%:p") },
            name = "Node.js: " .. (params.file or vim.fn.expand("%:t")),
            components = { "default" },
          }
        end,
        desc = "Run a Node.js script",
        params = {
          file = {
            desc = "Path to the Node.js script",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "javascript", "typescript" },
        },
      })

      -- Existing Go template
      overseer.register_template({
        name = "Run Go",
        builder = function(params)
          return {
            cmd = { "go" },
            args = { "run", params.file or vim.fn.expand("%:p") },
            name = "Go: " .. (params.file or vim.fn.expand("%:t")),
          }
        end,
        desc = "Run a Go application",
        params = {
          file = {
            desc = "Path to the Go file",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "go" },
        },
      })

      -- Existing Python template
      overseer.register_template({
        name = "Run Python",
        builder = function(params)
          return {
            cmd = { "python3" },
            args = { params.file or vim.fn.expand("%:p") },
            name = "Python: " .. (params.file or vim.fn.expand("%:t")),
          }
        end,
        desc = "Run a Python script",
        params = {
          file = {
            desc = "Path to the Python script",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "python" },
        },
      })

      -- New PHP template
      overseer.register_template({
        name = "Run PHP",
        builder = function(params)
          return {
            cmd = { "php" },
            args = { params.file or vim.fn.expand("%:p") },
            name = "PHP: " .. (params.file or vim.fn.expand("%:t")),
          }
        end,
        desc = "Run a PHP script",
        params = {
          file = {
            desc = "Path to the PHP script",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "php" },
        },
      })

      overseer.register_template({
        name = "Run Ruby",
        builder = function(params)
          return {
            cmd = { "ruby" },
            args = { params.file or vim.fn.expand("%:p") },
            name = "Ruby: " .. (params.file or vim.fn.expand("%:t")),
          }
        end,
        desc = "Run a Ruby script",
        params = {
          file = {
            desc = "Path to the Ruby script",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "ruby" },
        },
      })

      overseer.register_template({
        name = "Run Rust",
        builder = function(params)
          local file = params.file or vim.fn.expand("%:p")
          local is_cargo_project = vim.fn.filereadable(vim.fn.findfile("Cargo.toml", vim.fn.fnamemodify(file, ":h") .. ";")) == 1
          if is_cargo_project then
            return {
              cmd = { "cargo" },
              args = { "run" },
              name = "Rust: cargo run (" .. vim.fn.expand("%:t") .. ")",
              cwd = vim.fn.finddir("Cargo.toml", vim.fn.fnamemodify(file, ":h") .. ";"):match("(.+)/Cargo.toml$"),
            }
          else
            return {
              cmd = { "rustc" },
              args = { file, "-o", vim.fn.expand("%:p:r") .. ".out" },
              name = "Rust: compile and run (" .. vim.fn.expand("%:t") .. ")",
            }
          end
        end,
        desc = "Run a Rust program (cargo run or rustc)",
        params = {
          file = {
            desc = "Path to the Rust file",
            type = "string",
            optional = true,
          },
        },
        condition = {
          filetype = { "rust" },
        },
      })

    end,
    keys = {
      { "<leader>\\t", "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer Task List" },
      { "<leader>\\r", "<Cmd>OverseerRun<CR>", desc = "Run Overseer Task" },
      { "<leader>\\a", "<Cmd>OverseerTaskAction<CR>", desc = "Overseer Task Action" },
      { "<leader>\\b", "<Cmd>OverseerBuild<CR>", desc = "Overseer Build" },
      { "<leader>\\n", "<Cmd>OverseerRunCmd node %:p<CR>", desc = "Run Node.js Script" },
      { "<leader>\\g", "<Cmd>OverseerRunCmd go run %:p<CR>", desc = "Run Go Script" },
      { "<leader>\\p", "<Cmd>OverseerRunCmd python3 %:p<CR>", desc = "Run Python Script" },
      { "<leader>\\h", "<Cmd>OverseerRunCmd php %:p<CR>", desc = "Run PHP Script" },
      { "<leader>\\s", "<Cmd>OverseerRun template=shell<CR>", desc = "Run Shell" },
    },
  },
}
