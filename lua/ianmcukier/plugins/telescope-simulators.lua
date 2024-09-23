return {
	"dimaportenko/telescope-simulators.nvim",
	config = function()
		require("simulators").setup({
			android_emulator = true,
			apple_simulator = true,
		})
	end,
}
