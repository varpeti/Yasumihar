require "enet"

local client = {}

function client:init()
	client.host = enet.host_create()
	local file = io.open("port.txt","r")
	client.server = client.host:connect("192.168.0.23:"..file:read("*all")) 
	file:close()
end
	
function client:update(dt)
	local event = client.host:service()
	if not event then return end
	if event.type == "receive" then
		kiir:new("Got message: "..event.data.." "..event.peer:connect_id())
		--event.peer:send("ping")
	elseif event.type == "connect" then
		kiir:new("Connected")
		event.peer:send("ping")
	elseif event.type == "disconnect" then
		kiir:new(event.peer:connect_id() .. " disconnected.")
	end
end

return client