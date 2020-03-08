local gears = require("gears")
-- Theme handling library
local beautiful = require("beautiful")

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/hegza/.config/awesome/themes/zenburn/theme.lua")

-- {{{ Wallpaper on all screens
if beautiful.wallpaper_space then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper_space, s, true)
    end
end
-- }}}

