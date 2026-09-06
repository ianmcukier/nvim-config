return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		spec = {
			{ "<leader>s", group = "Search" },
			{ "<leader>h", group = "Git" },
			{ "<leader>x", group = "Trouble" },
			{ "<leader>b", group = "DB" },
			{ "<leader>t", group = "Tests" },
			{ "<leader>l", group = "Location List" },
			{ "<leader>q", group = "QuickFix List" },
			{ "<leader>.", group = "AI" },
			{ "<leader>m", group = "Format" },
		},
	},
}
