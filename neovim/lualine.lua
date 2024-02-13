require('lualine').setup(
	{
		options = {
			theme = 'everforest',
			icon_enabled = true,
		},
		sections = {
			lualine_a = {},
			--lualine_b = { 'branch', 'diff' },
			--lualine_c = { 'filename', metals_status },
			lualine_c = { 'buffers' },
			lualine_x = { 'tabs' },
			lualine_y = { 'progress' },
			--lualine_z = {'encoding', 'filetype'},
			--lualine_z = {
				--{
					--require("noice").api.statusline.mode.get,
					--cond = require("noice").api.statusline.mode.has,
					--color = { fg = "#ff9e64" },
				--}
			--},
		},
		filetype_names = {
			TelescopePrompt = 'Telescope',
			dashboard = 'Dashboard',
			packer = 'Packer',
			fzf = 'FZF',
			alpha = 'Alpha'
		},
		use_mode_colors = false,

		buffers_color = {
			active = 'lualine_{section}_normal', -- Color for active buffer.
			inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
		},

		symbols = {
			modified = ' ●', -- Text to show when the buffer is modified
			alternate_file = '#', -- Text to show to identify the alternate file
			directory = '', -- Text to show when the buffer is a directory
		},
	}
)
