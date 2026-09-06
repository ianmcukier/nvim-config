# nvim

Personal Neovim configuration. Requires Neovim 0.12 or newer (nvim-treesitter `main` branch).

Started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and Josean Martinez's
[video tutorial](https://www.youtube.com/watch?v=6pAG3BHurdM); rebuilt around snacks.nvim, blink.cmp and lazy.nvim.

## Bootstrap

    brew install neovim tree-sitter-cli
    git clone git@github.com:ianmcukier/nvim.git ~/.config/nvim
    nvim            # lazy.nvim installs pinned plugins, treesitter installs parsers

## Check

    scripts/check.sh

Runs the acceptance checks (plugin tree, lock file, stylua, headless startup, keymap uniqueness,
deprecation health). Run before committing and after every Neovim upgrade.
