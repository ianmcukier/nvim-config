return {
	"milkypostman/vim-togglelist",
	config = function()
		require("which-key").add({
			{ "<leader>l", group = "Location List" },
			{ "<leader>q", group = "QuickFix List" },
		})
	end,
}
