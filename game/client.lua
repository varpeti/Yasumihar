if not cfg.cvar.client then return nil end

require('enet')
com = require('game/commands') --nem local h lehessen hívni loadstringel

--------
--Init--
--------

local client = {}
client.host = enet.host_create()
client.server = client.host:connect(cfg.cvar.serverip..":"..cfg.cvar.port)


----------
--Update--
----------

function client.update(dt)
    com.update(dt)

    local event = client.host:service()
    if event then
        if event.type == "receive" then
            kiir.add(event.data,5,{0,255,0})
            pcall(loadstring("com."..event.data))
        elseif event.type == "connect" then
            kiir.add("Connected",5,{0,255,0})
            event.peer:send( "ping" )
        elseif event.type == "disconnect" then
            kiir.add("Disconnected",5,{0,255,0})
        end
    end

    hud.update(dt)
end

--------
--Draw--
--------

function client.draw()
    com.draw()
    love.graphics.print("*",0,0)
end

function client.HUD()
    hud.draw()
end

kiir.add("client",3,{0,255,0})

return client