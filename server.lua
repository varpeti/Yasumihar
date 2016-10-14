require "enet"
ser = require ('ser')
env = require('env_server')
require('fa')

server = {}


function server:init()
	--szerver beállítása
	local file = "port"
	if not love.filesystem.exists(file) then error([[Hiányzik a "]]..file..[[" file]]) end
	server.host = enet.host_create("*:"..love.filesystem.read(file)) 

	--env beállításai
	env:setCallbacks()

	env:newPlayer("Gaia",{rr=000,gg=200,bb=200})
	
	env:newObj("Gaia",{-50,-50,-30,50,40,40})
	env:addObj("Gaia",1,{200,200,150,170,180,110,135,167,123,110})
	env:getObj(1):getBody():setPosition(200,0)
		
	env:newObj("Gaia",{-50,-50,-30,50,40,40})
    env:newObj("Gaia",{200,200,150,170,180,110,135,167,123,110})

end

function server:update(dt)
	local event = server.host:service()
	if event then 
		if event.type == "receive" then
			--print("Got message: "..event.data,event.peer:connect_id())
			if event.data=="zt4e2r3st?" then
				event.peer:send("fruej3f4t?"..env:draw(event.peer:connect_id()))
			end 
			elseif event.type == "connect" then
			--print("Connected: "..event.peer:connect_id())
			env:newPlayer(event.peer:connect_id())
			event.peer:send("ciet3h4jo?"..facreate(event.peer:connect_id(),-700,-700))
			env:getObj(env.IDs-1):getBody():setAngularVelocity(-1)
		elseif event.type == "disconnect" then
			--print(event.peer:connect_id() .. " disconnected.")
		end
	end

	env:update(dt) --ez kell a fizikai világ frissítéshez

end

return server