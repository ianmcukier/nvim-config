return {
	"NiamhFerns/project.nvim",
	enabled = false,
	config = function()
		require("project_nvim").setup({
			on_project_selected = function(_, opt)
				require("fzf-lua").files({ cwd = opt.cwd })
			end,
			detection_methods = { "pattern" },
			patterns = { ">projects", ">rumi", "=nvim" },

			-- exclude_dirs = { "~/.config/nvim" },
		})
	end,
}
