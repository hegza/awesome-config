local gears = require("gears")
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")
local wibox = require("wibox")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local tags = require("tags")

-- Create an identical tag table for every screen
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- Hides hardcoded tags for improved focus
focus_mode = false

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "toggle focus mode", function()
        if focus_mode then focus_mode = false else focus_mode = true end
    end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. "~/.config/awesome/rc.lua" },
    { "suspend", function() awful.util.spawn_with_shell("pm-suspend") end },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}
-- Create a application startup menu
applicationmenu = {
    { "Terminal (alacritty-zsh)", terminal },
}

mymainmenu = awful.menu({ items = { { "applications", applicationmenu, beautiful.awesome_icon },
                                    { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
top_wibox = {}
bottom_wibox = {}
mypromptbox = {}
mylayoutbox = {}
top_taglist_1 = {}
top_taglist_2 = {}
top_taglist_2_r = {}
bottom_taglist = {}
taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))
-- Custom function for filtering tags
function filter(t, wibox_id)
    for i = 1, #tags.names do
        if (tags.names[i] == t.name) then
            if (tags.wibox_id[i] == wibox_id) then
                if not focus_mode or not (tags.names[i] == "5-fun" or tags.names[i] == "T") then
                    return true
                end
            end
            return false
        end
    end
    return false
end

function filter_focus_mode(t)
    for i = 1, #tags.names do
        if (tags.names[i] == t.name) then
        end
    end
    return false
end

-- Create widgets in all screens
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create taglist widgets
    top_taglist_1[s] = awful.widget.taglist(s, function (t) return filter(t, "top_1") end, taglist_buttons)
    top_taglist_2[s] = awful.widget.taglist(s, function (t) return filter(t, "top_2") end, taglist_buttons)
    top_taglist_2_r[s] = awful.widget.taglist(s, function (t) return filter(t, "top_2_r") end, taglist_buttons)
    bottom_taglist[s] = awful.widget.taglist(s, function (t) return filter(t, "bottom") end, taglist_buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibars
    top_wibox[s] = awful.wibar({ position = "top", height = 25, screen = s })
    bottom_wibox[s] = awful.wibar({ position = "bottom", screen = s })

    -- Create the textboxes for the tasks (<tt> == monospace)
    local task1_text = wibox.widget.textbox("<tt>Code: </tt>")
    local task2_text = wibox.widget.textbox("<tt>Task: </tt>")
    local task3_text = wibox.widget.textbox("<tt>Org: </tt>")

    -- Create two layouts at the top-left corner of the screen...
    local upper_left_layout_1 = wibox.layout.fixed.horizontal()
    upper_left_layout_1:add(task1_text)
    upper_left_layout_1:add(top_taglist_1[s])

    local upper_left_layout_2 = wibox.layout.fixed.horizontal()
    upper_left_layout_2:add(task2_text)
    upper_left_layout_2:add(top_taglist_2[s])
    upper_left_layout_2:add(top_taglist_2_r[s])

    -- ... and set them up in a vertical layout ...
    local upper_left_vlayout = wibox.layout.fixed.vertical()
    upper_left_vlayout:add(upper_left_layout_1)
    upper_left_vlayout:add(upper_left_layout_2)

    -- ... and set that up in a horizontal layout
    local upper_left_hlayout = wibox.layout.fixed.horizontal()
    upper_left_hlayout:add(upper_left_vlayout)
    upper_left_hlayout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Combine top wibar layout
    local top_wibox_layout = wibox.layout.align.horizontal()
    top_wibox_layout:set_left(upper_left_hlayout)
    top_wibox_layout:set_right(right_layout)
    top_wibox[s]:set_widget(top_wibox_layout)

    -- Lowbox widgets that are aligned to the left
    local lower_left_layout = wibox.layout.fixed.horizontal()
    lower_left_layout:add(task3_text)
    lower_left_layout:add(bottom_taglist[s])
    
    local right_layout_bot = wibox.layout.fixed.horizontal()
    right_layout_bot:add(mylauncher)
    
    local layout_bot = wibox.layout.align.horizontal()
    layout_bot:set_left(lower_left_layout)
    layout_bot:set_middle(mytasklist[s])
    layout_bot:set_right(right_layout_bot)

    bottom_wibox[s]:set_widget(layout_bot)
end
-- }}}
