local awful = require("awful")

local layouts = require("layouts")
local tags = require("tags")

-- Create table of tags by name
-- This is created in a highly hacky way atm
tag_by_name = {}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end), -- mod+w replaced by tag W hotkeys

    -- Layout manipulation
    awful.key({ modkey, "Control"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Control"   }, "k", function () awful.client.swap.byidx( -1)    end),
    --awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal, { screen = mouse.screen, tag = mouse.screen.selected_tag }) end),
    awful.key({ modkey,           }, "space",  function () awful.spawn(terminal, { screen = mouse.screen, tag = mouse.screen.selected_tag }) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control", "Shift" }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "z",     function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "x",     function () awful.layout.inc(layouts,  1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Brightness keys
    awful.key({ }, "XF86MonBrightnessDown" , function () awful.util.spawn("xbacklight -dec 5") end),
    awful.key({ }, "XF86MonBrightnessUp" , function () awful.util.spawn("xbacklight -inc 5") end),

    -- Volume keys
    awful.key({ }, "XF86AudioRaiseVolume" , function () awful.util.spawn("amixer sset Master 2%+ ") end),
    awful.key({ }, "XF86AudioLowerVolume" , function () awful.util.spawn("amixer sset Master 2%-") end),
    awful.key({ }, "XF86AudioMute" , function () awful.util.spawn("amixer sset Master toggle") end),

    awful.key({ modkey,           }, "<", function() awful.util.spawn_with_shell("xscreensaver-command --lock") end),

    -- Spawn a new firefox window
    awful.key({ modkey,           }, "i", function() awful.util.spawn_with_shell("firefox -new-window") end),

    -- Unminimize a random client on the current tag
    awful.key({ modkey, "Shift"   }, "n", function() awful.client.restore(s) end),

    -- Prompt
	-- HACK: mouse.screen is nil => replaced it with 1
    awful.key({ modkey,           }, "r", function() mypromptbox[1]:run() end),

    --[[ -- mod+x replaced by awful.tag.viewnext
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    --]]
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
--    awful.key({ "Alt"             }, "F4",     function (c) c:kill()                         end), -- This is not working, unfortunately 31.09.-16
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    --awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    -- Originally 't'
    awful.key({ modkey,           }, "o",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

--- {{{ Bind tag-keys
function bind_default_keys(key, screen, tag, background)
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, key,
                  function ()
                        local screen = mouse.screen
                        if tag then
                            awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, key,
                  function ()
                      local screen = mouse.screen
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus then
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, key,
                  function ()
                      if client.focus then
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end
for s = 1, screen.count() do
    for idx, tag in pairs(awful.tag.gettags(s)) do
        tag_by_name[tag.name] = tag
    end

    -- Bind QWE, ASD to tags
    bind_default_keys("q", s, tag_by_name["Q"], tags.bg)
    bind_default_keys("w", s, tag_by_name["W"], tags.bg)
    bind_default_keys("e", s, tag_by_name["E"], tags.bg)
    bind_default_keys("a", s, tag_by_name["A"], tags.bg)
    bind_default_keys("s", s, tag_by_name["S"], tags.bg)
    bind_default_keys("d", s, tag_by_name["D"], tags.bg)
    -- Bind 1, 2, 3 to tags
    bind_default_keys("#" .. "1" + 9, s, tag_by_name["1"], tags.bg)
    bind_default_keys("#" .. "2" + 9, s, tag_by_name["2"], tags.bg)
    bind_default_keys("#" .. "3" + 9, s, tag_by_name["3"], tags.bg)
    -- Bind 4-www & 5-www
    bind_default_keys("#" .. "4" + 9, s, tag_by_name["4-www"], tags.bg)
    bind_default_keys("#" .. "5" + 9, s, tag_by_name["5-www"], tags.bg)
    -- Bind T
    bind_default_keys("t", s, tag_by_name["T"], tags.bg)
    -- Bind G-stash
    bind_default_keys("g", s, tag_by_name["G-stash"], tags.bg)
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

return {
    clientkeys = clientkeys, clientbuttons = clientbuttons
}

