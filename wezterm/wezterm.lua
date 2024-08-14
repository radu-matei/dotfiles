local wezterm = require 'wezterm'

function Scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		-- return 'Gruvbox dark, hard (base16)'
		return 'Gruvbox Dark (Gogh)'
	else
		return 'Gruvbox (Gogh)'
		-- return 'Gruvbox light, hard (base16)'
	end
end

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
	{ family = 'DM Mono',                 weight = 'Medium' },
	{ family = 'SF Mono',                 weight = 'Medium' },
	{ family = 'FiraCode Nerd Font Mono', weight = 'Medium' },
	{ family = 'Iosevka Term SS04',       weight = 'Medium' },
	{ family = 'Iosevka Term Curly',      weight = 'Medium' },
}

config.line_height = 1.08
config.cell_width = 1.00

config.color_scheme = Scheme_for_appearance(wezterm.gui.get_appearance())
config.colors = {
	cursor_bg = '#FF6000',
	cursor_fg = 'black',
	cursor_border = '#52ad70',
	selection_fg = 'black',
	selection_bg = '#FF6000',
}

config.keys = {
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action { SendString = "\x1bb" }
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action { SendString = "\x1bf" }
	},
	{
		key = 'f',
		mods = 'SHIFT|CMD',
		action = wezterm.action.ToggleFullScreen
	}
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
	left   = '0cell',
	right  = '0cell',
	top    = '0cell',
	bottom = '0cell'
}
config.native_macos_fullscreen_mode = false
config.audible_bell = 'Disabled'

return config
