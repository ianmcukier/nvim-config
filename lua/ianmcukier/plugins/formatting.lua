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
				black = {
					prepend_args = { "--fast" },
				},
				prettier = {
					command = "./node_modules/.bin/prettier", -- local prettier in your monorepo
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				svelte = { "prettier" },
				json = { "prettier" }, -- override jsonls
				jsonc = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				python = { "black" },
			},
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 5000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 5000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
