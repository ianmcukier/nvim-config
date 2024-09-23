return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	opts = {
		modes = {
			my_diagnostics = {
				mode = "diagnostics",
				filter = {
					["not"] = { severity = vim.diagnostic.severity.INFO },
				},
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle filter.severity={vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR}<cr>",
			desc = "Diagnostics",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>xs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols",
		},
		{
			"<leader>xl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ...",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List",
		},
		{
			"<leader>xf",
			"<cmd>Trouble fzf toggle<cr>",
			desc = "Fzf",
		},
	},
	init = function()
		require("which-key").add({
			{ "<leader>x", group = "Trouble" },
		})
	end,
}
