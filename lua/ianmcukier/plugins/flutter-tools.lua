return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		require("flutter-tools").setup({})

		-- Keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>fr", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
		keymap.set("n", "<leader>fh", "<cmd>FlutterReload<CR>", { desc = "Flutter hot reload" })
		keymap.set("n", "<leader>fs", "<cmd>FlutterRestart<CR>", { desc = "Flutter restart" })
	end,
}
