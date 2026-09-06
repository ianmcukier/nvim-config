---@diagnostic disable: missing-fields
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
		"nvim-neotest/neotest-python",
	},
	config = function()
		require("neotest").setup({
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
				require("neotest-python"),
			},
		})

		require("which-key").add({
			{ "<leader>t", group = "Tests" },
		})
	end,
	keys = {
		{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
		{ "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run all tests in file" },
		{ "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
	},
}
