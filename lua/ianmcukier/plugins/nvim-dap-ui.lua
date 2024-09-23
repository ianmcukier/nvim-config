---@diagnostic disable: missing-fields
return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local ui = require("dapui")
		ui.setup({
			mappings = {
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						"scopes",
						"breakpoints",
						"stacks",
						-- 'watches',
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						"repl",
						--    'console',
					},
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "rounded", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
		})
		vim.fn.sign_define("DapBreakpoint", { text = "" })
	end,
}
