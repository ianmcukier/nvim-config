return {
	"tpope/vim-projectionist",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.g.projectionist_heuristics = {
			["*"] = {
				["*.go"] = {
					alternate = "{}_test.go",
					type = "source",
				},
				["*_test.go"] = {
					alternate = "{}.go",
					type = "test",
				},
			},
		}

		vim.keymap.set("n", "<leader>ta", "<cmd>A<CR>", { desc = "Alternate test or implementation" })
	end,
}
