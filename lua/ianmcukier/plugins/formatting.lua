return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				sql_formatter = {
					prepend_args = { "-c", vim.fn.expand("~/.config/nvim/sql_formatter.json") },
				},
			},
			formatters_by_ft = {
				markdown = { "prettier" },
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				sql = { "sql_formatter" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
