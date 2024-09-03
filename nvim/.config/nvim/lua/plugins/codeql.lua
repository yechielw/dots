return {
	"pwntester/codeql.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/telescope.nvim",
		"kyazdani42/nvim-web-devicons",
		{
			"s1n7ax/nvim-window-picker",
			tag = "v1.5",
			config = function()
				require("window-picker").setup({
					autoselect_one = true,
					include_current = false,
					filter_rules = {
						bo = {
							filetype = {

								"codeql_panel",
								"codeql_explorer",
								"qf",
								"TelescopePrompt",

								"TelescopeResults",
								"notify",

								"noice",
								"NvimTree",
								"neo-tree",
							},
							buftype = { "terminal" },
						},
					},
					current_win_hl_color = "#e35e4f",
					other_win_hl_color = "#44cc41",
				})
			end,
		},
	},

	opts = {},
}
