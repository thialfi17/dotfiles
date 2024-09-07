local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.key_map_preference = "Physical"

--config.color_scheme = "GruvboxDark"
config.color_scheme = "GruvboxDark"
config.bold_brightens_ansi_colors = false

config.font = wezterm.font 'Jetbrains Mono Nerd Font'
config.font_size = 13

config .cursor_blink_rate = 0

config.window_frame = {
    font = wezterm.font 'Jetbrains Mono',
    font_size = 11
}

--config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 0.93

config.window_padding = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
}

return config
