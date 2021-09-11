 -------------------------------------------------------------------------------
-- sr-blackwhite theme
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- {{{ Includes
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")
-- }}}
--------------------------------------------------------------------------------
-- {{{ Variable definitions

local themes_path = gfs.get_themes_dir()
local theme = {}

-- Shape
theme.shape = gears.shape.powerline

-- Colors
theme.background = "#000000" --darkgreen
theme.border_inactive = "#DEDEDE" --grey
theme.border_active = "#DEDEDE" --lightgreen
theme.window_background = "#000000" --black
theme.foreground = "#32a897" --lightgreen
theme.symbol = "#DEDEDE" --lightgray

-- Path of this theme config
theme.config_path = gfs.get_configuration_dir()

-- Set wallpaper
-- wallpaper is set with feh, see feh config

-- Set fonts
theme.font = "Victor Mono Nerd Font 11"
theme.taglist_font = "Victor Mono Nerd Font 11"

-- Window settings
theme.bg_normal = theme.window_background
theme.bg_focus = theme.window_background
theme.bg_urgent = theme.window_background
theme.bg_minimize = theme.window_background
theme.bg_systray = theme.background

theme.fg_normal = theme.foreground
theme.fg_focus = theme.foreground
theme.fg_urgent = theme.foreground
theme.fg_minimize = theme.foreground

theme.useless_gap = 2 --all gaps except horizontal gap between client window and wibar.
theme.border_width = 2 --border width ondly for client window borders.
theme.border_normal = theme.border_inactive
theme.border_focus = theme.border_active
theme.border_marked = theme.border_active
theme.border_floating = theme.border_active

-- Menu settings
theme.menu_fg_normal = theme.symbol --letters in the menu
theme.menu_fg_focus = theme.symbol --letters in the menu

theme.menu_bg_normal = theme.window_background
theme.menu_bg_focus = theme.background

theme.menu_border_width = 1
theme.menu_border_color = theme.border_active
theme.menu_height = 20
theme.menu_width = 140

theme.menu_submenu_icon = themes_path .. "/icons/submenu.png"
theme.menu_font = theme.font

-- Wibox settings
theme.wibox_fg = theme.symbol
theme.wibox_separator_fg = theme.background

theme.wibox_bg = theme.background

theme.wibox_height = 24

theme.wibox_border_width = theme.border_width
theme.wibox_border_color = theme.border_active

-- Widget settings

-- Taglist settings
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
theme.taglist_fg_focus = theme.foreground
theme.taglist_fg_urgent = theme.foreground
theme.taglist_fg_occupied = theme.foreground
theme.taglist_fg_empty = theme.symbol
theme.taglist_fg_volatile = theme.foreground

theme.taglist_bg_focus = theme.background
theme.taglist_bg_urgent = theme.background
theme.taglist_bg_occupied = theme.background
theme.taglist_bg_empty = theme.background
theme.taglist_bg_volatile = theme.background

-- Tasklist settings
theme.tasklist_fg_focus = theme.foreground
theme.tasklist_fg_normal = theme.symbol
theme.tasklist_fg_minimize = theme.symbol
theme.tasklist_fg_urgent = theme.foreground

theme.tasklist_bg_focus = theme.window_background
theme.tasklist_bg_normal = theme.background
theme.tasklist_bg_minimize = theme.background
theme.tasklist_bg_urgent = theme.background

-- Titlebar settings
--them]
-- theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus = themes_path.."default/titlebar/close_focus.png"

-- theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus = themes_path.."default/titlebar/minimize_focus.png"

-- theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive = themes_path.."default/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active = themes_path.."default/titlebar/ontop_focus_active.png"

-- theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive = themes_path.."default/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active = themes_path.."default/titlebar/sticky_focus_active.png"

-- theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive = themes_path.."default/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active = themes_path.."default/titlebar/floating_focus_active.png"

-- theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive = themes_path.."default/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active = themes_path.."default/titlebar/maximized_focus_active.png"

-- Tooltip settings
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]

-- Mouse finder settings
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

-- Prompt settings
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]

--themeHotkey settings
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- Notification settings
theme.notification_font = theme.font
theme.notification_bg = theme.background
theme.notification_bg_critical = theme.background
theme.notification_fg = theme.symbol
theme.notification_width = 300
theme.notification_margin = 4
theme.notification_border_color = theme.foreground
theme.notification_border_width = 3
theme.notification_spacing = theme.useless_gap
-- theme.notification_height = 30
-- notification_[shape|opacity]

-- Layout icons
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_twopane = theme.config_path.."layouts/twopanew.png"
theme.layout_twopaneleft = theme.config_path.."layouts/twopaneleftw.png"
theme.layout_twopanetop = theme.config_path.."layouts/twopanetopw.png"
theme.layout_twopanebottom = theme.config_path.."layouts/twopanebottomw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"
theme.layout_fg = theme.symbol
theme.layout_bg = theme.background

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(20, theme.symbol, theme.background)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- }}}
return theme