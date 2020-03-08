local awful = require("awful")

function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

--run_once("xbindkeys")

-- {{{ Autostart (only for processes with a unique proc id)
run_once("cbatticon")
run_once("dropbox")
run_once("nm-applet")
awful.spawn.with_shell(terminal .. " -title evo -e zsh -c \"pgrep evo || evo\"")
-- TODO: pgrep can't find the process => leads to duplicates (same for saskia-irc)
--awful.spawn.with_shell("pgrep memo || " .. terminal .. " -title memo -e zsh -c \"vim -S /usr/local/etc/memo/calendar.session\"")
-- }}}

