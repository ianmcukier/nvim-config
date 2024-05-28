return {
  "NiamhFerns/project.nvim",
  config = function()
    require("project_nvim").setup {
      on_project_selected = function(_, opt)
        require("fzf-lua").files({ cwd = opt.cwd })
      end
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}