return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters = {
			sql_formatter = {
				prepend_args = { "-c", vim.fn.stdpath("config") .. "/sql_formatter.json" },
			},
			black = {
				prepend_args = { "--fast" },
			},
			prettier = {
				-- repo-local prettier so project config and plugins resolve
				command = "./node_modules/.bin/prettier",
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
			json = { "prettier" },
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
	},
	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({ lsp_fallback = false, async = false, timeout_ms = 5000 })
			end,
			mode = { "n", "v" },
			desc = "Format file or range",
		},
	},
}
