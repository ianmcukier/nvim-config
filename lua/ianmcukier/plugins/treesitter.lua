---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"json", "yaml", "html", "css", "markdown", "markdown_inline", "bash",
				"lua", "luadoc", "vim", "vimdoc", "query", "dockerfile", "gitignore", "c",
				"go", "gomod", "gosum", "gowork", "regex", "sql", "python", "terraform",
				"typescript", "tsx", "javascript", "prisma",
			},
		})
	end,
}
