return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
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

		lualine.setup({
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "" },
				always_divide_middle = false,
				disabled_filetypes = {
					statusline = {},
					winbar = {},
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
						"lsp_status",
						icon = "",
						symbols = {
							spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
							done = "",
							separator = " ",
						},
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
	end,
}
