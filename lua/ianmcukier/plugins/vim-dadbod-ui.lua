return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_disable_mappings = 1
		vim.g.db_ui_execute_on_save = 0
	end,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("ianmcukier-dbui", { clear = true }),
			pattern = "dbui",
			callback = function(ev)
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, remap = true, desc = desc })
				end
				map("<CR>", "<Plug>(DBUI_SelectLine)", "Select")
				map("d", "<Plug>(DBUI_DeleteLine)", "Delete")
				map("s", "<Plug>(DBUI_SaveQuery)", "Save query")
			end,
		})
	end,
	keys = {
		{ "<leader>bb", "<cmd>DBUIToggle<cr>", desc = "UI Toggle" },
		{ "<leader>bq", "<Plug>(DBUI_ExecuteQuery)", mode = { "n", "v" }, desc = "Query" },
	},
}
