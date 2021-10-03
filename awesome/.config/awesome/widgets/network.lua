-- awesome_mode: api-level=4:screen=on
-----------------------------------------------------------
-- Includes {{{1
-- Standard awesome libraries
local awful = require("awful") -- Everything related to window management
-- Widget and layout library
local wibox = require("wibox") -- Awesome own generic widget framework
-- Theme handling library
local beautiful = require("beautiful") -- Awesome theme module
-- Notifications
local naughty = require("naughty") -- Notifications
local M = {}

-----------------------------------------------------------
-- Network {{{1

function M.get_widget()
  icon = " i "
  local network = wibox.widget({
    {
      id = "watch_role",
      awful.widget.watch(
        [[bash -c 'cat < /dev/null > /dev/tcp/8.8.8.8/53; echo $?']],
        10,
        function(widget, stdout)
          if tonumber(stdout:match("^%d")) == 0 then  --check if there is a connection.
            icon = "  "
            net = true
            awful.spawn.easy_async([[bash -c 'nmcli dev status | grep -e "wifi" -e "ethernet"']],
            function(getType)  --what type is the connection.
              icon = "1"
              for device, type, state, connection in getType:gmatch(
                "(%g+)%s+(%g+)%s+(connected)%s+(%g+)"
              ) do
                ctype = type
                cconnection = connection
              end
            end)
            if ctype == "wifi" then
              icon = " 直 "
              awful.spawn.easy_async([[bash -c 'nmcli dev wifi | grep ]] .. "\"" .. cconnection .. "\"\'",
              function(getSignal)
                for inuse, bssid, ssid, mode, chan, rate, signal in getSignal:gmatch(
                  "(%g+)%s+(%g+)%s+(%g+)%s+(%g+)%s+(%g+)%s+(%g+%s+%g+)%s+(%g+)%s.-"
                ) do
                  cssid = ssid
                  crate = rate
                  csignal = signal
                end
              end)
            elseif ctype == "ethernet" then
              icon = "  "
            else
              icon = "  "
            end
          else
            net = false
            icon = "  "
          end

--          if ctype == "wifi" then
--            icon = " 直 "
--            awful.spawn.easy_async([[bash -c 'nmcli dev wifi | grep ]] .. "\"" .. cconnection .. "\"\'",
--            function(getSignal)
--              for inuse, bssid, ssid, mode, chan, rate, signal in getSignal:gmatch(
--                "(%g+)%s+(%g+)%s+(%g+)%s+(%g+)%s+(%g+)%s+(%g+%s+%g+)%s+(%g+)%s.-"
--              ) do
--                cssid = ssid
--                crate = rate
--                csignal = signal
--              end
--            end)
--          elseif ctype == "ethernet" then
--            icon = "  "
--          else
--            icon = "  "
--          end
--
          widget:set_markup_silently(
            string.format(
              "<span weight='bold' foreground='%s'>%s</span>",
              beautiful.nord10,
              icon
            )
          )
        end
      ),
      buttons = {
        awful.button({}, 1, function()
          os.execute(
            "wifi toggle"
          )
          naughty.notify({ title = "WIFI", message = " You toggled the wifi switch \n To switch it back, press the symbol again", timeout = 5 })
        end),
        awful.button({}, 3, function()
          awful.spawn("nm-connection-editor")
        end),
        awful.button({}, 2, function()
          if net == true then
            if ctype == "wifi" and csignal ~= nil then
              naughty.notify({message = "SSID     Rate         Signal-strenght\n" .. cssid .. "..." .. crate .. "..." .. csignal .. "..............", title = "WIFI connection:"})
            elseif ctype == "ethernet" then
              naughty.notify({message = cconnection, title = "ETH connection:"})
            elseif csignal == nil then
              naughty.notify({title = "NO connection detected:", message = "Check internet connection or network.lua config."})
            end
          elseif net == false then
            naughty.notify({title = "NO connection:", message = "You are not connected to the internet"})
          else
            naughty.notify({title = "NO connection detected:", message = "Check internet connection or network.lua config."})
          end
        end),
      },
      layout = wibox.layout.fixed.horizontal,
    },
    left = 3 * beautiful.useless_gap,
    --right = 1 * beautiful.useless_gap,
    widget = wibox.container.margin,
  })
  return network
end

return M

-- }}}1
