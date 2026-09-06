return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("ianmcukier-lsp-attach", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				vim.notify("Attached " .. client.name, vim.log.levels.INFO, { title = "LSP" })

				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
				end

				map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
				map("<leader>D", function()
					Snacks.picker.diagnostics_buffer()
				end, "Buffer diagnostics")
				map("<leader>rs", "<cmd>LspRestart<cr>", "Restart LSP")
			end,
		})
	end,
}
