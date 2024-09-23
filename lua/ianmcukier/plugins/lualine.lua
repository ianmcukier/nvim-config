return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"linrongbin16/lsp-progress.nvim",
	},
	config = function()
		require("lsp-progress").setup({})
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		vim.opt.showmode = false
    -- stylua: ignore
    local colors = {
      blue   = '#80a0ff',
      cyan   = '#79dac8',
      black  = '#080808',
      white  = '#c6c6c6',
      red    = '#ff5189',
      violet = '#d183e8',
      grey   = '#303030',
    }

		local bubbles_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.violet },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white, bg = colors.grey },
			},

			insert = { a = { fg = colors.black, bg = colors.blue } },
			visual = { a = { fg = colors.black, bg = colors.cyan } },
			replace = { a = { fg = colors.black, bg = colors.red } },

			inactive = {
				a = { fg = colors.white, bg = colors.grey },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white, bg = colors.grey },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				ignore_focus = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dapui_stacks",
					"dap-repl",
				},
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {},
				lualine_x = {
					function()
						-- return require("lsp-progress").progress({})
						return require("lsp-progress").progress({
							format = function(messages)
								-- local active_clients = vim.lsp.get_clients()
								if #messages > 0 then
									return table.concat(messages, "")
								end
								return ""
								-- if #active_clients <= 0 then
								-- 	return ""
								-- else
								-- 	local client_names = {}
								-- 	for _, client in ipairs(active_clients) do
								-- 		if client and client.name ~= "" then
								-- 			table.insert(client_names, "[" .. client.name .. "]")
								-- 		end
								-- 	end
								-- 	return table.concat(client_names, "")
								-- end
							end,
						})
					end,
					-- {
					-- 	require("noice").api.statusline.mode.get,
					-- 	cond = require("noice").api.statusline.mode.has,
					-- 	color = { fg = "#ff9e64" },
					-- },
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { { "filetype" } },
				lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
			},
			inactive_sections = {
				lualine_a = {
					{
						"filename",
						separator = { left = "" },
						right_padding = 2,
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"filetype",
						separator = { right = "" },
						left_padding = 2,
						draw_empty = true,
						icon_only = true,
					},
				},
			},
			tabline = {},
			extensions = {},
		})
		-- listen lsp-progress event and refresh lualine
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end,
}
