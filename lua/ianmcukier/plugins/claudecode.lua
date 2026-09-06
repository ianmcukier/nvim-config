return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	enabled = true,
	lazy = false,
	opts = {
		terminal = {
			provider = "none",
		},
		diff = {
			layout = "vertical",
		},
	},
	keys = {
		{ "<leader>.a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>.r", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
