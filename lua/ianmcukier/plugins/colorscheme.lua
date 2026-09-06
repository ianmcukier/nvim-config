return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	-- "rebelot/kanagawa.nvim",
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("catppuccin-mocha")
		-- vim.cmd("colorscheme kanagawa-wave")
		--
		-- -- You can configure highlights by doing something like:
		-- vim.cmd.hi("Comment gui=none")
		local signs = {
			ERROR = "",
			WARN = "",
			HINT = "",
			INFO = "󰠠",
		}
		vim.diagnostic.config({
			virtual_text = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs["ERROR"],
					[vim.diagnostic.severity.WARN] = signs["WARN"],
					[vim.diagnostic.severity.INFO] = signs["INFO"],
					[vim.diagnostic.severity.HINT] = signs["HINT"],
				},
			},
			underline = true,
			float = {
				source = "if_many",
				header = "",
				border = "rounded",
				focusable = false,
			},
			-- float = {
			-- 	border = "rounded",
			-- 	format = function(d)
			-- 		return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
			-- 	end,
			-- },
			-- underline = true,
			-- jump = {
			-- 	float = true,
			-- },
		})

		local hl_groups = { "DiagnosticUnderlineError" }
		for _, hl in ipairs(hl_groups) do
			vim.cmd.highlight(hl .. " gui=undercurl")
		end
	end,
	config = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- Additions (green)
				vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#163a24", fg = "NONE" })

				-- Deletions (red)
				vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4a1f24", fg = "NONE" })

				-- CHANGED lines → must NOT be green
				vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2a2f3a", fg = "NONE" }) -- neutral

				-- Highlight exact changed text
				vim.api.nvim_set_hl(0, "DiffText", { bg = "#46506a", fg = "NONE", bold = true })

				-- CursorLine (keep, but may interfere)
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#232a2e" })
			end,
		})

		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function()
				if vim.wo.diff then
					vim.wo.cursorline = false
				end
			end,
		})
		-- require("kanagawa").setup({
		-- 	theme = "wave",
		-- 	wave = {
		-- 		syn = {
		-- 			parameter = "#ECE9E1",
		-- 		},
		-- 	},
		-- })
	end,
}
