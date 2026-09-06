return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = false,
	},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
		{ "<leader>st", function() Snacks.picker.todo_comments({ keywords = { "TODO" } }) end, desc = "Todo" },
	},
}
