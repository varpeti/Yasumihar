if not cfg.cvar.client then return nil end

require('enet')

local server = {}
server.host = enet.host_create("*:"..cfg.cvar.port)

function server.update(dt)
    local event = server.host:service()
    if event then
        if event.type == "receive" then
            kiir.add(event.peer:connect_id().." "..event.data,5,{100,100,255})
            event.peer:send("newObj({-10,-10,10,-10,10,10,-10,10},{0,0,255,255})")
        elseif event.type == "connect" then
            kiir.add(event.peer:connect_id().." connected",5,{100,100,255})
        elseif event.type == "disconnect" then
            kiir.add(event.peer:connect_id().." disconnected",5,{100,100,255})
        end
    end
end

kiir.add("server",3,{100,100,255})

return server