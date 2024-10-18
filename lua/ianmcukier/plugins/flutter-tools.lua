return {
	"akinsho/flutter-tools.nvim",
	-- lazy = false,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("flutter-tools").setup({
			flutter_path = vim.fn.expand("$HOME/Develop/flutter/bin/flutter"),
			fvm = false,
			widget_guides = { enabled = true },
			-- closing_tags = {
			-- 	enabled = true,
			-- 	highlight = "LineNr",
			-- 	prefix = "??  ",
			-- 	priority = 0,
			-- },
			dev_log = {
				enabled = true,
				notify_errors = false,
				open_cmd = "botright 15split",
				filter = function(log_line)
					if log_line:find("ImpellerValidationBreak") then
						return false
					end
					return true
				end,
			},
			lsp = {
				capabilities = capabilities,
				settings = {
					showTodos = false,
					completefunctioncalls = true,
					analysisexcludedfolders = {
						vim.fn.expand("$HOME/.pub-cache"),
						-- vim.fn.expand("$HOME/Develop/flutter"),
					},
					renamefileswithclasses = "prompt",
					updateimportsonrename = true,
					enablesnippets = true,
				},
			},
			debugger = {
				-- make these two params true to enable debug mode
				enabled = true,
				run_via_dap = true,
				register_configurations = function(_)
					require("dap").set_log_level("TRACE")
					require("dap").adapters.dart = {
						type = "executable",
						command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
						args = { "flutter" },
					}

					require("dap").configurations.dart = {
						{
							type = "dart",
							request = "launch",
							name = "Launch flutter",
							-- dartSdkPath = 'home/flutter/bin/cache/dart-sdk/',
							-- flutterSdkPath = "~/Develop/flutter/",
							program = "${workspaceFolder}/lib/main.dart",
							cwd = "${workspaceFolder}",
						},
					}
					local dap = require("dap")
					dap.defaults.dart.exception_breakpoints = { "Notice", "Warning", "Error", "Exception" }
					-- uncomment below line if you've launch.json file already in your vscode setup
					require("dap.ext.vscode").load_launchjs()
				end,
			},
			-- dev_log = {
			-- 	-- toggle it when you run without DAP
			-- 	enabled = false,
			-- 	open_cmd = "tabedit",
			-- },
		})

		local make_code_action_params = function()
			local params = vim.lsp.util.make_range_params()
			params.context = {
				diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
			}
			return params
		end

		local execute_code_action = function(kind)
			if not kind then
				return
			end
			local params = make_code_action_params()
			params.context.only = { kind }
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
					else
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end

		-- local list_code_action_kinds = function()
		-- 	local params = make_code_action_params()
		-- 	print(params)
		-- 	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		-- 	for _, res in pairs(result or {}) do
		-- 		print("---")
		-- 		for _, r in pairs(res.result or {}) do
		-- 			-- vim.pretty_print(r)
		-- 			print(r.kind)
		-- 		end
		-- 		print("---")
		-- 	end
		-- end

		-- Keymaps
		require("which-key").add({
			{ "<leader>f", group = "Flutter" },
			{ "<leader>W", group = "Flutter Widget" },
		})
		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
		keymap.set("n", "<leader>fh", "<cmd>FlutterReload<CR>", { desc = "Flutter hot reload" })
		keymap.set("n", "<leader>fr", "<cmd>FlutterRestart<CR>", { desc = "Flutter restart" })
		keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter quit" })

		keymap.set("n", "<leader>wi", function()
			execute_code_action("refactor.flutter.wrap.generic")
		end, { desc = "Add widget" })
		keymap.set("n", "<leader>wd", function()
			execute_code_action("refactor.flutter.removeWidget")
		end, { desc = "Remove widget" })
	end,
}
