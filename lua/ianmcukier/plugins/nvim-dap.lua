return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		local ui = require("dapui")

		require("which-key").add({
			{ "<leader>d", group = "DAP" },
		})
		-- Set breakpoints, get variable values, step into/out of functions, etc.
		vim.keymap.set("n", "<leader>dk", require("dap.ui.widgets").hover, { desc = "Hover" })
		vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step over" })
		vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
		vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
		vim.keymap.set("n", "<leader>dC", function()
			dap.clear_breakpoints()
			require("notify")("Breakpoints cleared", "warn")
		end, { desc = "Clear breakpoints" })
		vim.keymap.set("n", "<leader>dd", ui.toggle, { desc = "UI toggle" })
		vim.keymap.set("n", "<leader>dl", function()
			dap.repl.toggle({}, "tabe")
			vim.cmd("tabn")
		end, { desc = "Open repl" })

		-- Close debugger and clear breakpoints
		vim.keymap.set("n", "<leader>de", function()
			dap.clear_breakpoints()
			ui.toggle({})
			dap.terminate()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
			require("notify")("Debugger session ended", "warn")
		end, { desc = "Close and clear" })
	end,
}
