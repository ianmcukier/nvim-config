return {
	"tpope/vim-projectionist",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.g.projectionist_heuristics = {
			["*"] = {
				["*.go"] = { alternate = "{}_test.go", type = "source" },
				["*_test.go"] = { alternate = "{}.go", type = "test" },
			},
		}
	end,
	keys = {
		{ "<leader>ta", "<cmd>A<cr>", desc = "Alternate test or implementation" },
	},
}
