require "enet"

local server = {}

function server:init()

	local file = io.open("port.txt","r")
	server.host = enet.host_create("*:"..file:read("*all")) 
	file:close()
end

function server:update(dt)
	local event = server.host:service()
	if not event then return end
	if event.type == "receive" then
		kiir:new("Got message: "..event.data.." "..event.peer:connect_id())
		event.peer:send("pong")
	elseif event.type == "connect" then
		env:newPlayer(event.peer:connect_id())
		env:newObj(event.peer:connect_id(),{-50,-50,-30,50,40,40})
	elseif event.type == "disconnect" then
		kiir:new(event.peer:connect_id() .. " disconnected.")
	end
end

return server