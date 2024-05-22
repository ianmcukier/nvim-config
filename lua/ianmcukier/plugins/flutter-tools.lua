return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      debugger = {
        -- make these two params true to enable debug mode
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          require('dap').set_log_level('TRACE')
          require("dap").adapters.dart = {
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
            args = { "flutter" }
          }

          require("dap").configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch flutter",
              -- dartSdkPath = 'home/flutter/bin/cache/dart-sdk/',
              -- flutterSdkPath = "home/flutter",
              program = "${workspaceFolder}/lib/main.dart",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal"
            }
          }
          local dap = require("dap")
          dap.defaults.dart.exception_breakpoints = { "Notice", "Warning", "Error", "Exception" }
          -- uncomment below line if you've launch.json file already in your vscode setup
          -- require("dap.ext.vscode").load_launchjs()
        end,
      },
      dev_log = {
        -- toggle it when you run without DAP
        enabled = false,
        open_cmd = "tabedit",
      },
    })

    -- Keymaps
    require('which-key').register({
      ["<leader>f"] = {
        name = "Flutter"
      }
    })
    local keymap = vim.keymap

    keymap.set("n", "<leader>ff", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
    keymap.set("n", "<leader>fh", "<cmd>FlutterReload<CR>", { desc = "Flutter hot reload" })
    keymap.set("n", "<leader>fr", "<cmd>FlutterRestart<CR>", { desc = "Flutter restart" })
    keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter quit" })
  end,
}
