return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	opts = {},
	keys = {
		{
			"<leader>S",
			function()
				require("grug-far").open()
			end,
			desc = "Search and replace",
		},
		{
			"<leader>S",
			function()
				require("grug-far").with_visual_selection()
			end,
			mode = "x",
			desc = "Search and replace selection",
		},
	},
}
