-- lua/ianmcukier/core/helper.lua
-- Smart hover helper: explicit request/fallback without buf_request_all

local M = {}
local lsp = vim.lsp
local util = vim.lsp.util

-- Helper to get an attached LSP client by name that supports hover
local function get_client(name)
	for _, client in ipairs(lsp.get_active_clients({ bufnr = 0 })) do
		if client.name == name and client.server_capabilities and client.server_capabilities.hoverProvider then
			return client
		end
	end
	return nil
end

--- Perform hover: try TS first, if it returns no content, fallback to Tailwind
function M.smart_hover()
	local bufnr = 0
	local params = util.make_position_params()

	-- 1) Try TypeScript hover
	local ts = get_client("tsserver")
	if ts then
		ts.request("textDocument/hover", params, function(err, result, ctx, config)
			if err then
				return
			end
			local contents = (result and result.contents) or {}
			local lines = util.convert_input_to_markdown_lines(contents)
			lines = util.trim_empty_lines(lines)
			if #lines > 0 then
				util.open_floating_preview(lines, "markdown", { border = "rounded" })
			else
				-- fallback to Tailwind
				local tw = get_client("tailwindcss")
				if tw then
					tw.request("textDocument/hover", params, vim.lsp.handlers["textDocument/hover"], bufnr)
				else
					vim.notify("No hover information available", vim.log.levels.INFO)
				end
			end
		end, bufnr)
		return
	end

	-- 2) No TS client or no hoverProvider: try Tailwind directly
	local tw = get_client("tailwindcss")
	if tw then
		tw.request("textDocument/hover", params, vim.lsp.handlers["textDocument/hover"], bufnr)
	else
		vim.notify("No hover information available", vim.log.levels.INFO)
	end
end

--- Close any floating hover or other floating window
function M.hide_smart_hover()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.relative and cfg.relative ~= "" then
			vim.api.nvim_win_close(win, true)
		end
	end
end

return M
