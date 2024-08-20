local wezterm = require 'wezterm'

function Scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'GruvboxDarkHard'
	else
		return 'Gruvbox (Gogh)'
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
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
	left   = '0cell',
	right  = '0cell',
	top    = '0cell',
	bottom = '0cell'
}

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font { family = 'DM Mono', weight = 'Medium' },

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = '#333333',

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = '#333333',
}

config.colors = {
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = '#575757',
	},
}

config.native_macos_fullscreen_mode = false
config.audible_bell = 'Disabled'

return config
