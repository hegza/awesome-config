local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

-- {{{ Tags
-- Define a tag table which holds all screen tags.
local tile = awful.layout.suit.tile
local lmax = awful.layout.suit.max
-- The ordering of these items determines layout and client priority
local tags = {
    -- layouts in top-bar have to come first in indices (depends on hotkey-stuff)
    names = {
        "A",
        "T",
        "1",        "2",        "3",    "4-www",    "5-www",
        "Q",        "W",        "E",
                    "S",        "D",    "G-stash" },
    layout = {
        lmax,
        tile,
        tile,       lmax,       lmax,   lmax,       lmax,
        tile,       lmax,       lmax,
        lmax,       lmax,   lmax },
    wibox_id = {
        "bottom",
        "top_2_r",
        "top_1",    "top_1",    "top_1", "top_1",   "top_1",
        "top_2",    "top_2",    "top_2",
        "bottom",   "bottom",   "bottom" },
    bg = beautiful.wallpaper_space
}

return tags
