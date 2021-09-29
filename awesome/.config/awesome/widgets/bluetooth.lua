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
-- Bluetooth

function M.get_widget()
  local network = wibox.widget({
    {
      id = "watch_role",
      awful.widget.watch(
        [[bash -c 'nmcli dev status | grep -e "wifi" -e "ethernet" && nmcli dev wifi | grep -e "*"']],
        10,
        function(widget, stdout)




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
        end
        ),
        awful.button({}, 3, function()
          awful.spawn("nm-connection-editor")
        end),
      },
      layout = wibox.layout.fixed.horizontal,
    },
    left = 3 * beautiful.useless_gap,
    --right = 1 * beautiful.useless_gap,
    widget = wibox.container.margin,
  })
  return bluetooth
end

return M

-- }}}1
