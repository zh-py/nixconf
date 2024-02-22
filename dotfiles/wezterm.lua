local wezterm = require 'wezterm'

local my_framer = wezterm.color.get_builtin_schemes()['Framer (base16)']
my_framer.cursor_fg = '#181818'
my_framer.cursor_bg = '#EEEEEE'
my_framer.compose_cursor = '#20BCFC'
local mux = wezterm.mux
wezterm.on('gui-startup', function()
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local act = wezterm.action
return {
	font_size = 12,
	window_background_opacity = 0.96,
	hide_tab_bar_if_only_one_tab = true,
	default_cursor_style = "SteadyBar",
	cursor_blink_rate = 600,
	default_prog = { "zsh" },
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_decorations = "NONE",
	use_fancy_tab_bar = false,
	adjust_window_size_when_changing_font_size = false,
	inactive_pane_hsb = { saturation = 1, brightness = 1 }, -- s0.9, b0.8
	color_schemes = { ['My Framer'] = my_framer, },
	color_scheme = 'My Framer',
	keys = {
		{ key = 't', mods = 'CMD|SHIFT', action = act.SpawnTab 'CurrentPaneDomain', },
	}
}
