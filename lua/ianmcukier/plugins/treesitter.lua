return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"json", "yaml", "html", "css", "markdown", "markdown_inline", "bash",
			"lua", "luadoc", "vim", "vimdoc", "query", "dockerfile", "gitignore", "c",
			"go", "gomod", "gosum", "gowork", "regex", "sql", "python", "terraform",
			"typescript", "tsx", "javascript", "prisma",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("ianmcukier-treesitter", { clear = true }),
			callback = function(ev)
				-- start() errors for filetypes without an installed parser; those buffers keep regex highlighting
				if not pcall(vim.treesitter.start, ev.buf) then
					return
				end
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
