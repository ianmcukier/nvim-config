---@diagnostic disable: missing-fields
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
		"sidlatau/neotest-dart",
	},
	config = function()
		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		local neotest = require("neotest")

		neotest.setup({
			status = {
				virtual_text = true,
				signs = true,
			},
			output = {
				open_on_run = false,
			},
			discovery = {
				enabled = false,
			},
			adapters = {
				require("neotest-go"),
				require("neotest-dart")({
					command = "flutter",
					use_lsp = true,
					custom_test_method_names = { "blocTest", "testWidgets" },
				}),
			},
		})

		require("which-key").add({
			{ "<leader>t", group = "Tests" },
		})
	end,
	keys = {
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run nearest test",
		},
		{
			"<leader>tR",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run all tests in file",
		},
		{
			"<leader>to",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle output panel",
		},
		-- { "<leader>tR", "<cmd>Neotest run <CR>", desc = "Run nearest test" },
	},
}
