return {
	"dlyongemallo/diffview-plus.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>hv",
			function()
				if require("diffview.lib").get_current_view() then
					vim.cmd.DiffviewClose()
				else
					vim.cmd.DiffviewOpen()
				end
			end,
			desc = "Toggle diff view",
		},
	},
}
