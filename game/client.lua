if not cfg.cvar.client then return nil end

require('enet')

local client = {}
client.host = enet.host_create()
client.server = client.host:connect(cfg.cvar.serverip..":"..cfg.cvar.port)

function client.update(dt)
    hud.update(dt)

    local event = client.host:service()
    if event then
        if event.type == "receive" then
            kiir.add(event.data,5,{0,255,0})
        elseif event.type == "connect" then
            kiir.add("Connected",5,{0,255,0})
            event.peer:send( "ping" )
        elseif event.type == "disconnect" then
            kiir.add("Disconnected",5,{0,255,0})
        end
    end
end

function client.draw()
    love.graphics.print("*",0,0)
end

function client.HUD()
    hud.draw()
end

kiir.add("client",3,{0,255,0})

return client