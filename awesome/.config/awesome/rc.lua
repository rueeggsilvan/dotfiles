--------------------------------------------------------------------------------
-- {{{ Includes

pcall(require, "luarocks.loader")
-- Standard awesome libraries
local gears = require("gears") -- Utilities such as color parsing and objects
local awful = require("awful") -- Everything related to window management
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox") -- Awesome own generic widget framework
-- Theme handling library
local beautiful = require("beautiful") -- Awesome theme module
-- Nofification library
local naughty = require("naughty") -- Notifications
local hotkeys_popup = require("awful.hotkeys_popup")
local twopane = require("layouts.twopane")

-- }}}
--------------------------------------------------------------------------------
-- {{{ Error handling

-- Check if awesome ecountered an error during startup and fell back to another
-- config
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error",
		function (err)
			-- Make sure we don't go into an endless error loop
			if in_error then return end
			in_error = true
			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Oops, an error happened!",
				text = tostring(err)
			})
			in_error = false
			end
	)
end

-- }}}
--------------------------------------------------------------------------------
-- {{{ Variable definitions

-- Default applications
terminal = "alacritty"
browser = "brave"
filemanager = "nemo"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default mod key
modkey = "Mod4"

-- Initialize theme ["blackwhite", "yellow", "blue", "green", "onehalf-dark"]
mytheme = "green"

if mytheme == "blackwhite" or "yellow" or "blue" or "green" then
	beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/sr-" .. mytheme .. "/theme.lua")
else
	beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/onehalf-dark/theme.lua")
end

-- Table of layouts
awful.layout.layouts = {
	awful.layout.suit.tile,
	twopane,
	awful.layout.suit.fair,
	awful.layout.suit.max,
}

-- }}}
--------------------------------------------------------------------------------
-- {{{ Widgets

-- Launcher menu
mymenu = awful.menu({ items = {
		{ "edit config", editor_cmd .. " " .. awesome.conffile },
		{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
		{ "restart", function() awesome.restart() end },
		{ "quit", function() awesome.quit() end },
		{ "shut down", function() awful.spawn("shutdown now") end },
		{ "reboot", function() awful.spawn("reboot") end }
		}
})

-- Launcher widget
mylauncher = wibox.widget {
	{
		image = beautiful.awesome_icon,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	top = 4,
	right = 6,
	left = 8,
	bottom = 4,
	widget = wibox.container.margin,
}

mylauncher:buttons(gears.table.join(
		awful.button({ }, 1,
			function() awful.spawn("rofi -show drun") end
		),  
		awful.button({ }, 3,
			function() mymenu:toggle() end
		)
	)
)

-- Taglist widget
local taglist_buttons = gears.table.join(
	awful.button({        }, 1,
		function(t) t:view_only() end
	),  
	awful.button({ modkey }, 1,
		function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),		
	awful.button({        }, 3,
		awful.tag.viewtoggle
	),		
	awful.button({ modkey }, 3,
		function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),	
	awful.button({        }, 4,
		function(t) awful.tag.viewnext(t.screen) end
	),	
	awful.button({        }, 5,
		function(t) awful.tag.viewprev(t.screen) end
	)
)

local mytaglist = function(s)
	local taglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			spacing = 4,
			spacing_widget = {
				{
					forced_width =  0,
					color = beautiful.wibox_bg,
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},    
			layout = wibox.layout.fixed.horizontal,
		},  
		widget_template = {
			{
				id = "text_role",
				widget = wibox.widget.textbox,
			},
			left = 6,
			right = 6,
			widget = wibox.container.margin,
		},	
		id = "background_role",
		widget = wibox.container.background,
		}
	return taglist
end

-- Layout widget
local layoutbox_buttons = gears.table.join(
	awful.button({ }, 1, function() awful.layout.inc(1) end),
	awful.button({ }, 4, function() awful.layout.inc(1) end),
	awful.button({ }, 5, function() awful.layout.inc(-1) end)
)

local mylayoutbox = function(s)
	local layoutbox = wibox.widget {
		{
			id = "layoutbox_role",
			awful.widget.layoutbox(s),
			opacity = 1,
			layout = wibox.layout.fixed.horizontal,
		},
		top = 6,
		right = 6,
		left = 6,
		bottom = 4,
		widget = wibox.container.margin,
	}
	layoutbox:get_children_by_id("layoutbox_role")[1]:buttons(gears.table.join(
			layoutbox_buttons
		)
	)
	return layoutbox
end

-- Tasklist widget
local tasklist_buttons = gears.table.join(
	awful.button({ }, 3,
		function() awful.menu.client_list({ theme = { width = 250 } }) end
	),
	awful.button({ }, 4,
	function() awful.client.focus.byidx(1) end
	),
	awful.button({ }, 5,
		function() awful.client.focus.byidx(-1) end
	)
)

local mytasklist = function(s)
	local tasklist = awful.widget.tasklist {
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		tasklist_plain_task_name = true,
		buttons = tasklist_buttons,
		layout = {
			spacing = 1,
			spacing_widget = {
				{
					forced_width =  3,
					color = beautiful.wibox_separator_fg,
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						top = 4,
						right = 4,
						bottom = 4,
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 6,
				right = 6,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	}
	return tasklist
end

-- CPU info widget
local cpus = {}
mycpuinfo = wibox.widget {
	{
		id = "watch_role",
		awful.widget.watch([[bash -c "grep '^cpu.' /proc/stat"]], 1,
			function(widget, stdout)
				for line in stdout:gmatch("[^\r\n]+") do
					if line:sub(1, #"cpu") == "cpu" then
						local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
						line:match("(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)")
						local total = user + nice + system + idle + iowait + irq + softirq + steal

						if cpus[name] == nil then cpus[name] = {} end
						local diff_idle = idle - tonumber(cpus[name]['idle_prev'] == nil and 0 or cpus[name]['idle_prev'])
						local diff_total = total - tonumber(cpus[name]['total_prev'] == nil and 0 or cpus[name]['total_prev'])
						cpus[name]["diff_usage"] = ((diff_total - diff_idle) / diff_total)*100

						cpus[name]["total_prev"] = total
						cpus[name]["idle_prev"] = idle
					end
				end
				widget:set_markup_silently(string.format("<span color=%q> :%3.f%%</span>", beautiful.wibox_fg, cpus["cpu"]["diff_usage"]))
			end
		),
		layout = wibox.layout.fixed.horizontal,
	},
	right = 6,
	left = 6,
	widget = wibox.container.margin,
}

-- Mem info widg
local mem = {}
mymeminfo = wibox.widget {
	{
		id = "watch_role",
		awful.widget.watch([[bash -c "grep '^Mem.' /proc/meminfo"]], 1,
			function(widget, stdout)
				for line in stdout:gmatch("[^\r\n]+") do
					if line:sub(1, #"Mem") == "Mem" then
						local name, number, _ = line:match("(%w+):%s+(%d+)%s(%w+)")
						mem[name] = number
					end
				end
				mem["MemUsed"] = tonumber(mem["MemTotal"] == nil and 0 or mem["MemTotal"]) - tonumber(mem["MemAvailable"] == nil and 0 or mem["MemAvailable"])
				widget:set_markup_silently(string.format("<span color=%q> : %3.f%%</span>", beautiful.wibox_fg, mem["MemUsed"]/mem["MemTotal"]*100))
			end
		),
		layout = wibox.layout.fixed.horizontal,
	},
	right = 6,
	left = 6,
	widget = wibox.container.margin,
}
-- battery widget

-- Clock
mytextclock = wibox.widget {
	{
		format = "<span color='" .. beautiful.wibox_fg .. "'> : %a %d. %b %Y %H:%M</span>",
		widget = wibox.widget.textclock,
	},
	right = 6,
	left = 6,
	widget = wibox.container.margin,
}

-- Default separator
myseparator = {
	color = beautiful.wibox_seperator_fg,
	forced_width = 1,
	widget = wibox.widget.separator
}

-- }}}
--------------------------------------------------------------------------------
-- {{{ Wibox


local function set_wibox(s)
	local gap = 2 * beautiful.useless_gap
	-- Create screen specific widgets
	s.mytaglist = mytaglist(s)
	s.mylayoutbox = mylayoutbox(s)
	s.mytasklist = mytasklist(s)
	-- Remove old wibox
	if s.mywibox ~= nil then s.mywibox.visible = false end
	-- Create wibox
	s.mywibox = wibox {
		visible = true,
		opacity = 0.9,
		type = "dock",
		x = s.geometry["x"] + gap,
		y = s.geometry["y"] + gap - 2,
		width = s.geometry["width"] - 3 * gap,
		height = beautiful.wibox_height,
		screen = s,
		bg = beautiful.wibox_bg,
		fg = beautiful.wibox_fg,
		border_width = beautiful.wibox_border_width,
		border_color = beautiful.wibox_border_color,
		--shape = function(cr,w,h)
		--	gears.shape.transform(gears.shape.octogon(cr,w,h,5), gears.shape.rounded_rect(cr, w, h, 8))
		--end
	}
	-- Set wibox struts
	s.mywibox:struts {
		top = 28,
		right = 0,
		left = 0,
		bottom = 0,
	}
	-- Add widgets to the wibox
	s.mywibox:setup {
		{ -- Left widgets
			mylauncher,
			s.mytaglist,
			s.mylayoutbox,
			wibox.widget.separator {
				forced_width = 0,
				color = beautiful.wibox_bg,
			},
			spacing = 1,
			spacing_widget = myseparator,
			layout = wibox.layout.fixed.horizontal(),
		},
		{-- Middle widgets
			s.mytasklist,
			spacing = 1,
			spacing_widget = myseparator,
			layout = wibox.layout.fixed.horizontal
		},
		{ -- Right widgets
			mycpuinfo,
			mymeminfo,
			mytextclock,
			wibox.widget.systray(),
			spacing = 1,
			spacing_widget = myseparator,
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	}
end

-- }}}
--------------------------------------------------------------------------------
-- {{{ Create environment

--Wallpaper was set with feh, see feh config file.

local function set_screen(s)
	set_wibox(s)
end

awful.screen.connect_for_each_screen(
	function(s)
	-- Create taglist
		-- Each screen has its own tag table
		awful.tag({ "www", "dev", "sys", "chat", "mus", "virt", "doc", "vis"}, s, awful.layout.layouts[1])
		-- Set screen
		set_screen(s)
	end
)

-- }}}
--------------------------------------------------------------------------------
-- {{{ Key bindings

-- Set global key bindings
globalkeys = gears.table.join(
	awful.key({ modkey,           }, "Return",
		function() awful.spawn(terminal) end,
		{description = "open a terminal", group = "launcher"}
	),
	awful.key({ modkey,           }, "s",
		function() awful.spawn("steam") end,
		{description = "open steam", group = "launcher"}
	),
	awful.key({ modkey, "Shift"   }, "Return",
		function() awful.spawn("rofi -show drun") end,
		{description = "open dmenu", group = "launcher"}
	),
	awful.key({ modkey,						}, "Tab",
		function() awful.spawn("rofi -show window") end,
		{description = "switch programs", group = "launcher"}
	),
	awful.key({ modkey,           }, "b",
		function() awful.spawn(browser) end,
		{description = "open a browser", group = "launcher"}
	),
	awful.key({ modkey,           }, "f",
		function() awful.spawn(filemanager) end,
		{description = "open a file manager", group = "launcher"}
	),
	awful.key({ modkey,           }, "Escape",
		function() awful.spawn("slock") end,
		{description = "lock the session", group = "awesome"}
	),
	awful.key({ modkey, "Control" }, "q",
		function() awesome.quit() end,
		{description = "quit awesome", group = "awesome"}
	),
	awful.key({ modkey, "Shift"   }, "q",
		function () awesome.restart() end,
		{description = "restart awesome", group = "awesome"}
	),
	awful.key({ modkey, "Shift"   }, "slash",
		function() hotkeys_popup.show_help(nil, awful.screen.focused()) end,
		{description = "display help", group = "awesome"}
	),
	awful.key({ modkey,           }, "space",
		function()
			local screen = awful.screen.focused()
			awful.layout.inc(1, screen)
		end,
		{description = "next layout", group = "layout"}
	),
	awful.key({ modkey, "Shift"   }, "space",
		function()
			local screen = awful.screen.focused()
			awful.layout.inc(-1, screen)
		end,
		{description = "previous layout", group = "layout"}
	),
	awful.key({ modkey,           }, "h",
		function() awful.tag.incmwfact(-0.03, nil) end,
		{description = "minmize the master pane", group = "layout"}
	),
	awful.key({ modkey,           }, "l",
		function() awful.tag.incmwfact(0.03, nil) end,
		{description = "maximize the master pane", group = "layout"}
	),
	awful.key({ modkey,           }, "comma",
		function() awful.tag.incnmaster(-1, nil, true) end,
		{description = "decrease number of master clients", group = "layout"}
	),
	awful.key({ modkey,           }, "period",
		function() awful.tag.incnmaster(1, nil, true) end,
		{description = "increase number of master clients", group = "layout"}
	),
	awful.key({ modkey,           }, "j",
		function() awful.client.focus.byidx(1) end,
		{description = "focus next client", group = "client"}
	),
	awful.key({ modkey,           }, "k",
		function() awful.client.focus.byidx(-1) end,
		{description = "focus previous client", group = "client"}
	),
	awful.key({ modkey, "Shift"   }, "j",
		function() awful.client.swap.byidx(1) end,
		{description = "swap with next client", group = "client"}
	),
	awful.key({ modkey, "Shift"   }, "k",
		function() awful.client.swap.byidx(-1) end,
		{description = "swap with previous client", group = "client"}
	),
	awful.key({ modkey,           }, "w",
		function() awful.screen.focus(1) end,
		{description = "focus screen 1", group = "screen"}
	),
	awful.key({ modkey,           }, "e",
		function() awful.screen.focus(2) end,
		{description = "focus screen 2", group = "screen"}
	),
	awful.key({ modkey,           }, "r",
		function() awful.screen.focus(3) end,
		{description = "focus screen 3", group = "screen"}
	),
	awful.key({                   }, "XF86AudioRaiseVolume",
		function()
			os.execute(string.format("amixer -c 0 sset Master 5+ unmute"))
		end,
		{description = "raise volume", group = "system"}
	),
	awful.key({                   }, "XF86AudioLowerVolume",
		function()
			os.execute(string.format("amixer -c 0 sset Master 5- unmute"))
		end,
		{description = "lower volume", group = "system"}
	),
	awful.key({                   }, "XF86AudioMute",
		function()
			os.execute(string.format("amixer set Master toggle"))
		end,
		{description = "mute volume", group = "system"}
	)
)

-- Set client related key bindings
clientkeys = gears.table.join(
	awful.key({ modkey,           }, "q",
		function(c) c:kill() end,
		{description = "kill the current client", group = "client"}
	),
	awful.key({ modkey,           }, "m",
		function(c) awful.client.setmaster(c) end,
		{description = "set the current client as master", group = "client"}
	),
	awful.key({ modkey, "Shift"   }, "m",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen mode for the current client", group = "client"}
	),
	awful.key({ modkey,           }, "p",
		function(c)
			c.floating = not c.floating
			c:raise()
		end,
		{description = "toggle floating for the current client", group = "client"}
		),
	awful.key({ modkey, "Shift"   }, "w",
		function(c) c:move_to_screen(1) end,
		{description = "move focused client to screen 1", group = "client"}
	),
	awful.key({ modkey, "Shift"   }, "e",
		function(c) c:move_to_screen(2) end,
		{description = "move focused client to screen 2", group = "client"}
	),
	awful.key({ modkey, "Shift"   }, "r",
		function(c) c:move_to_screen(3) end,
		{description = "move focused client to screen 3", group = "client"}
	)
)

-- Set tag  related key bindings
for i = 1, 8 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only
		awful.key({ modkey,           }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "switch to tag " .. awful.screen.focused().tags[i].name , group = "tag"}
		),
		-- Toggle tag display
		awful.key({ modkey, "Shift"   }, "#" .. i + 9,
			function()
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end,
			{description = "move client to tag " .. awful.screen.focused().tags[i].name , group = "tag"}
		)
	)
end

-- Set keys
root.keys(globalkeys)

--- }}}
--------------------------------------------------------------------------------
-- {{{ Mouse bindings

clientbuttons = gears.table.join(
	awful.button({        }, 1,
		function(c)
			client.focus = c
			c:raise()
		end
	),
	awful.button({ modkey }, 1,
		function(c)
			c.floating = true
			c:raise()
			awful.mouse.client.move(c)
		end
	),
	awful.button({ modkey }, 3,
		function(c)
			c.floating = true
			c:raise()
			awful.mouse.client.resize(c)
		end
	)
)

-- }}}
--------------------------------------------------------------------------------
-- {{{ Client rules

-- All new appearing clients will match these rules

awful.rules.rules = {
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen,
		}
	},
	-- Floating clients
	{
		rule_any = {
			class = {
				"Pavucontrol",
				"Xmessage"
			},
			type= {
				"dialog"
			},
		},
   	properties = { floating = true }
	},
  -- Client specific rules
	{
		id = "teams_notification",
		rule_any = {
			name = { "Microsoft Teams Notification" },
		},
		properties = {
			titlebars_enabled = false,
			floating = true,
			focus = false,
			draw_backdrop = false,
			skip_decoration = true,
			skip_taskbar = true,
			ontop = true,
			sticky = true
		},
	},
}

-- }}}
--------------------------------------------------------------------------------
-- {{{ Signals

-- Signal function to execute when a new client appears or is managed by awesome
client.connect_signal("manage",
	function(c)
		if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes
			awful.placement.no_offscreen(c)
		end
		--c.shape = function(cr,w,h)
		--	gears.shape.transform(gears.shape.octogon(cr,w,h,5), gears.shape.rounded_rect(cr, w, h, 8))
		--end
	end
)

-- Focus signals
client.connect_signal("focus",
	function(c)
		c.skip_taskbar = false 
		c.border_color = beautiful.border_focus
		if c.class == "Blender" or "Darktable" or "Steam" or "Brave-browser" or "libreoffice-writer" or "libreoffice-draw" or "libreoffice-calc" or "libreoffice-impress" then
			c.opacity = 1
		else    
			c.opacity = 1
		end
	end
)

client.connect_signal("unfocus",
	function(c)
		c.skip_taskbar = true
		c.opacity = 0.8
		if c.floating == true then
			c.border_color = beautiful.border_floating
		else
			c.border_color = beautiful.border_normal
		end
	end
)

-- }}}
-------------------------------------------------------------------------------
-- {{{ Background

if mytheme == "blackwhite" or "yellow" or "blue" or "green" then
	awful.spawn.with_shell("feh --randomize --bg-fill $HOME/Pictures/wallpaper/" .. mytheme .. "/*")
else 
	awful.spawn.with_shell("feh --randomize --bg-fill $HOME/Pictures/wallpaper/*")
end

-- }}}	
--------------------------------------------------------------------------------
-- {{{ Autostart applications

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
-- }}}
