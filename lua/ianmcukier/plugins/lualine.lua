return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"linrongbin16/lsp-progress.nvim",
	},
	config = function()
		require("lsp-progress").setup({
			spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
			client_format = function(client_name, spinner, series_messages)
				if #series_messages > 0 then
					return spinner .. " " .. client_name
				else
					return nil
				end
			end,
			format = function(messages)
				local clients = vim.lsp.get_clients({
					bufnr = vim.fn.bufnr(),
				})

				if #clients <= 0 then
					return "󰜺 LSP"
				end

				if #messages > 0 then
					return table.concat(messages, " ")
				end

				return " "
			end,
		})

		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		vim.opt.showmode = false
    -- stylua: ignore
    local colors = {
      blue   = '#679eb9',
      cyan   = '#79dac8',
      black  = '#080808',
      white  = '#c6c6c6',
      red    = '#ff5189',
      violet = '#ea9a97',
      grey   = '#313244',
      inactive = '#313244',
      iris = '#c4a7e7'
    }

		local bubbles_theme = {
			normal = {
				a = { fg = colors.inactive, bg = colors.iris, gui = "bold" },
				b = { fg = colors.white, bg = colors.inactive },
				c = { fg = colors.white, bg = colors.inactive },
			},

			insert = { a = { fg = colors.black, bg = colors.white } },
			visual = { a = { fg = colors.black, bg = colors.cyan } },
			replace = { a = { fg = colors.black, bg = colors.red } },
			inactive = { a = { fg = colors.white, bg = colors.inactive } },
		}

		local function diff_source()
			local gitsigns = vim.b.gitsigns_status_dict
			if gitsigns then
				return {
					added = gitsigns.added,
					modified = gitsigns.changed,
					removed = gitsigns.removed,
				}
			end
		end

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "" },
				always_divide_middle = false,
				ignore_focus = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dapui_stacks",
					"dap-repl",
				},
				disabled_filetypes = {
					statusline = {
						-- "alpha",
						"NvimTree",
					},
					winbar = {
						"NvimTree",
						-- "alpha",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						"filename",
						fmt = function(name, context)
							if name == "[No Name] [-]" then
								return ""
							end
							return name
						end,
					},
					"branch",
					{ "diff", source = diff_source },
				},
				lualine_c = {},
				lualine_x = {
					{
						function()
							local msg = require("lsp-progress").progress()
							if msg == "" then
								return "󰜺 LSP"
							else
								return msg
							end
						end,
						color = { fg = colors.iris },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { { "filetype" } },
				lualine_z = {
					{
						"location",
						color = { fg = colors.white, bg = colors.inactive },
						separator = { left = " " },
					},
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						"filename",
						fmt = function(name, context)
							if name == "[No Name] [-]" then
								return ""
							end
							return name
						end,
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"filetype",
						draw_empty = true,
						icon_only = true,
					},
				},
			},
			tabline = {},
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
