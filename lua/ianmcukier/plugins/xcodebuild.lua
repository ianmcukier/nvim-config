return {
	"wojciech-kulik/xcodebuild.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-tree.lua", -- (optional) to manage project files
		"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
	},
	config = function()
		require("xcodebuild").setup({
			test_explorer = {
				open_command = "topleft 42vsplit Test Explorer", -- command used to open Test Explorer, must create a buffer with "Test Explorer" name
				auto_open = false, -- open Test Explorer when tests are started
			},
			logs = {
				auto_open_on_failed_tests = true, -- open logs when tests failed
			},
		})

		vim.keymap.set("n", "<leader>tR", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" })
		vim.keymap.set("n", "<leader>tr", "<cmd>XcodebuildTestNearest<cr>", { desc = "Run nearest" })
		vim.keymap.set("n", "<leader>te", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })

		vim.keymap.set("n", "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
		vim.keymap.set("n", "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
		vim.keymap.set("n", "<leader>Xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
	end,
}
