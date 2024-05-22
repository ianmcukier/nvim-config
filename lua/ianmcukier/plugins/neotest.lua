---@diagnostic disable: missing-fields
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-go",
    "sidlatau/neotest-dart",
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    local neotest = require("neotest")

    neotest.setup({
      diagnostic = {
        enabled = true,
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      adapters = {
        require("neotest-go"),
        require("neotest-dart"),
      },
    })

    require("which-key").register({
      ["<leader>t"] = {
        name = "Tests"
      }
    })
  end,
  keys = {
    {
      "<leader>tr",
      function()
        require('neotest').run.run()
      end
      ,
      desc = "Run nearest test"
    },
    {
      "<leader>tR",
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end
      ,
      desc = "Run all tests in file"
    },
    -- { "<leader>tR", "<cmd>Neotest run <CR>", desc = "Run nearest test" },
  },
}
