return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
}
