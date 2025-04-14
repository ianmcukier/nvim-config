return {
	"karb94/neoscroll.nvim",
	event = "VeryLazy",
	enabled = false,
	config = function()
		require("neoscroll").setup({
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-y>", "zt", "zz", "zb" },
		})
	end,
}
