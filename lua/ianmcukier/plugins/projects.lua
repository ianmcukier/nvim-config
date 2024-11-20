return {
	"NiamhFerns/project.nvim",
	config = function()
		require("project_nvim").setup({
			on_project_selected = function(_, opt)
				require("fzf-lua").files({ cwd = opt.cwd })
			end,
			detection_methods = { "pattern" },
			patterns = { ">projects" },

			exclude_dirs = { "~/.config/nvim" },
		})
	end,
}
