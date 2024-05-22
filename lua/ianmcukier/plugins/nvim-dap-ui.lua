return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local ui = require('dapui')
    ui.setup({
      -- mappings = {
      --   open = "o",
      --   remove = "d",
      --   edit = "e",
      --   repl = "r",
      --   toggle = "t",
      -- },
      -- layouts = {
      --   {
      --     elements = {
      --       "scopes",
      --     },
      --     size = 0.3,
      --     position = "left"
      --   },
      --   {
      --     elements = {
      --       "repl",
      --       "breakpoints"
      --     },
      --     size = 0.3,
      --     position = "bottom",
      --   },
      -- },
      -- floating = {
      --   max_height = nil,
      --   max_width = nil,
      --   border = "single",
      --   mappings = {
      --     close = { "q", "<Esc>" },
      --   },
      -- },
      -- windows = { indent = 1 },
    })
    vim.fn.sign_define('DapBreakpoint', { text = '' })
  end
}
