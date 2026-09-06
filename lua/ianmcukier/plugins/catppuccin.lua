return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "mocha",
		custom_highlights = function(colors)
			return {
				DiagnosticUnderlineError = { style = { "undercurl" }, sp = colors.red },
				DiffAdd = { bg = "#163a24", fg = "NONE" },
				DiffDelete = { bg = "#4a1f24", fg = "NONE" },
				DiffChange = { bg = "#2a2f3a", fg = "NONE" },
				DiffText = { bg = "#46506a", fg = "NONE", style = { "bold" } },
				CursorLine = { bg = "#232a2e" },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = vim.api.nvim_create_augroup("ianmcukier-diff-cursorline", { clear = true }),
			callback = function()
				if vim.wo.diff then
					vim.wo.cursorline = false
				end
			end,
		})
	end,
}
