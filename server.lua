require "enet"

local server = {}

function server:init()
	local file = "port"
	if not love.filesystem.exists(file) then error([[Hiányzik a "]]..file..[[" file]]) end
	server.host = enet.host_create("*:"..love.filesystem.read(file)) 
end

function server:update(dt)
	local event = server.host:service()
	if not event then return end
	if event.type == "receive" then
		kiir:new("Got message: "..event.data.." "..event.peer:connect_id())
		event.peer:send("Pong")
		elseif event.type == "connect" then
		kiir:new("Connected: "..event.peer:connect_id())
		env:newPlayer(event.peer:connect_id())
		event.peer:send(facreate(event.peer:connect_id(),-700,-700))
	elseif event.type == "disconnect" then
		kiir:new(event.peer:connect_id() .. " disconnected.")
	end
end

server.init()

return server