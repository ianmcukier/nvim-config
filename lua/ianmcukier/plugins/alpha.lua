return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		-- Create a new namespace to manage the extmark simulating the cursorline
		local ns_id = vim.api.nvim_create_namespace("CursorlineSim")

		-- this function will be called every time Alpha moves the cursor when the user uses J/k to navigate
		local function simulate_cursorline()
			-- Get the row number of the cursor
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

			-- Get the content of the current line
			local line = vim.api.nvim_get_current_line()

			-- Find first and last characters of the current line
			local first_non_whitespace = line:find("%S")
			local last_non_whitespace = line:find("%S%s*$")

			-- If line has content
			if first_non_whitespace then
				-- Remove the previous extmark
				vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

				-- Adjust the starting point to be a little bit before the first
				-- character (unless already at the beginning of the line).
				local start_col = math.max(first_non_whitespace - 3, 0)

				-- Adjust the ending point to be a little bit after the last character.
				local end_col = math.min(last_non_whitespace + 1, #line)

				-- Apply the virtual text.
				vim.api.nvim_buf_set_extmark(0, ns_id, row - 1, start_col, {
					virt_text = { { string.sub(line, first_non_whitespace - 2, end_col) .. "  ", "CursorLine" } }, -- Sur le texte
					virt_text_pos = "overlay",
				})
			end
		end

		-- Override the api.nvim.nvim_win_get_cursor() to apply the simulated
		-- cursorline every time Alpha move the cursor.
		--
		-- Save the previous version of the vim.api.nvim_win_get_cursor() function.
		local original_set_cursor = vim.api.nvim_win_set_cursor
		-- Redefine the function
		vim.api.nvim_win_set_cursor = function(win, pos)
			-- call the original function to keep the normal behavior
			original_set_cursor(win, pos)
			-- update the simulated cursorline position
			simulate_cursorline()
		end

		-- Hide the text cursor once Alpha is ready
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			desc = "hide cursor for alpha",
			callback = function()
				local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
				hl.blend = 100
				vim.api.nvim_set_hl(0, "Cursor", hl)
				vim.opt.guicursor:append("a:Cursor/lCursor")
			end,
		})

		-- Restore original settings and function when Alpha is closed
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaClosed",
			desc = "show cursor after alpha",
			callback = function()
				local hl = vim.api.nvim_get_hl_by_name("Cursor", true)
				hl.blend = 0
				vim.api.nvim_set_hl(0, "Cursor", hl)
				vim.opt.guicursor:remove("a:Cursor/lCursor")
				-- restore the original vim.api.nvim_win_set_cursor() function
				vim.api.nvim_win_set_cursor = original_set_cursor
			end,
		})

		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local function footer()
			local date = vim.fn.strftime("  %d/%m/%Y ")
			local time = vim.fn.strftime("  %H:%M:%S ")
			local stats = require("lazy").stats()
			local plugins = "  " .. stats.loaded .. "/" .. stats.count .. " plugins "

			return date .. time .. plugins
		end

		-- Set header
		dashboard.section.header.val = {
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⣿⣿⣿⣿⡇⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢻⣿⣿⣿⠀⠀⠀⢹⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡉⠛⠿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠘⣿⣿⠇⠀⠀⠀⠸⣿⣿⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠙⠻⣿⣿⣿⣿⠃⠀⠀⣿⡿⠀⠀⠀⠀⠀⣿⡏⠀⣿⣿⣿⣿⠿⣻⣿⣿⡿⠟⠉⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠈⠛⢿⡏⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⡿⠀⢰⣿⡿⠟⢁⣴⠿⠛⠉⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⣍⡙⠛⠿⣿⣿⣧⠀⠀⠀⠈⠁⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠿⠋⠀⠐⠋⠁⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡉⠻⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠛⠋⠉⠉⠁⠈⠁⠀⠀⠀⢠⠆⠀⠀⠀⠀⠀⠀⠉⠲⣄⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⣀⠀⠀⢠⡄⠀⠀⠀⠀⠈⠣⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡿⠷⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣀⠀⠀⠀⠀⢀⣤⣶⡿⠋⠀⠀⠀⠉⠛⢷⣦⣤⣀⡀⢀⣼⣦⡀⠀⣠⣾⠿⠛⠛⠛⠛⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠶⠶⠆⠀⠀⠀⠀⠀⠈⣿⣶⣤⣶⣾⠿⠋⠁⠀⠀⢀⣀⣀⣀⣀⡀⠀⠙⠻⣿⣿⣿⡋⢳⣄⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠿⠋⠁⠀⠀⣠⠴⠛⠉⠀⠀⠀⠀⠉⠓⠦⣄⠈⠙⠻⡇⠀⠹⣆⠀⠋⠉⠙⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⢀⡜⠁⢀⣠⣴⣾⣿⣿⣿⣶⣤⣀⣈⡇⠀⢠⣧⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⢀⣀⣹⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣦⣉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡞⡇⠀⠀⠀⠀⢾⣦⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⣼⢾⡄⠀⠀⠹⣄⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣵⣿⡀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⢠⠏⠛⢹⠀⠀⠀⠹⣶⠒⢺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⡀⠀⠀⠀⠀⠠⡏⢀⢀⠈⢷⡀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⡿⠿⢿⠏⠀⠀⠀⠀⢀⣯⣀⣠⣤⣶⣿⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⢣⠀⠸⠦⠄⠛⠀⠀⠀⠀⠀⠀⠙⠲⠤⠤⠤⠤⠞⠃⠀⠀⡰⠤⠴⠋⠀⠀⠉⠛⠿⣿⣿⣞⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠳⢄⣀⣀⡠⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⢀⢀⣀⣀⣀⣀⣀⣀⣀⣈⠻⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⢀⣤⠀⠀⠈⠉⠉⡀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠁⣇⣈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣀⣴⣶⣿⣿⡇⠀⠀⢀⣤⣶⣿⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡽⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢀⣰⣾⣿⣿⣿⡏⣰⢰⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣇⣷⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⢿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣹",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⢿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠉⠙⠒⠢⢤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⢦⣀⠀⠀⠀⠉⠑⠒⠤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠈⠑⠦⣀⠀⠀⠀⠀⠀⠈⠉⠓⠶⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⡀⠈⠳⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠀⠠⢤⣀⠐⠒⠒⠂⠉⠉⠁⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿",
		}

		-- Set menu
		local opts = {
			position = "center",
			cursor = 3,
			width = 0,
			hl = "hl_group",
		}

		dashboard.section.buttons.val = {
			dashboard.button("SPC sp", "  Select Project", "<cmd>Telescope projects<CR>"),
			dashboard.button("SPC ee", "  Open File Explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC sf", "  Search Files", "<cmd>FzfLua files<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts = opts
		end

		dashboard.section.footer.val = footer()
		dashboard.section.footer.opts.hl = "Constant"
		dashboard.opts.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 3 },
			dashboard.section.footer,
		}
		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
