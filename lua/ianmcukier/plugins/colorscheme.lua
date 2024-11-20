return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	dependencies = {
		"folke/lsp-colors.nvim",
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("catppuccin-mocha")
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
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs["ERROR"],
					[vim.diagnostic.severity.WARN] = signs["WARN"],
					[vim.diagnostic.severity.INFO] = signs["HINT"],
					[vim.diagnostic.severity.HINT] = signs["INFO"],
				},
			},
			virtual_text = false,
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
		require("catppuccin").setup({
			color_overrides = {
				mocha = {
					base = "#1c2225",
				},
			},
		})
	end,
}
