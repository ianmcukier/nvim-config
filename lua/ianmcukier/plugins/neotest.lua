---@diagnostic disable: missing-fields
return {
	"nvim-neotest/neotest",
	ft = { "dart", "go" },
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
		vim.keymap.set("n", "<leader>tr", neotest.run.run, { desc = "Run nearest test" })
		vim.keymap.set("n", "<leader>tr", neotest.run.run, { desc = "Run all tests in file" })
		vim.keymap.set("n", "<leader>tr", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Toggle output panel" })
	end,
}
