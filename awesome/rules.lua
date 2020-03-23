local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

local keys = require("keys")

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     screen = awful.screen.focused,
                     keys = keys.clientkeys,
					 maximized_vertical = false,
					 maximized_horizontal = false,
                     ontop = false,
                     buttons = keys.clientbuttons } },
    -- Define some applications as floating by default
    { rule_any = { class = { "MPlayer", "pinentry", "gimp" } },
      properties = { floating = true } },
    -- Put memo on A
    -- TODO: this puts all things with memo in name to the tag (like vim-fast-memo things)
    { rule = { name = "memo" },
      properties = { tag = "A" }
    },
    -- Put evo on T-toggle
    { rule = { name = "evo" },
      properties = { tag = "T" }
    },
    -- Put saskia-irc on T-toggle, as minimized
    { rule = { name = "saskia-irc" },
      properties = { tag = "T", minimized = true }
    },
	-- Prevent some applications from doing stupid shit
	{ rule = { class = "chromium" }, properties = {opacity = 1, maximized = false, floating = false} },
	{ rule = { instance = "firefox" }, properties = {opacity = 1, maximized = false, floating = false} },
	{ rule = { class = "Telegram" }, properties = {tag = "T", opacity = 1, maximized = false, floating = false} },
	{ rule = { class = "urxvt" }, properties = {opacity = 1, maximized = false, floating = false} },
	{ rule = { class = "alacritty" }, properties = {opacity = 1, maximized = false, floating = false} },
}
-- }}}

