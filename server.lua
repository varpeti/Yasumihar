require "enet"
ser = require ('ser')

server = {}

local function rajz(peer)
	local BB = {}
	for b,body in ipairs(env.world:getBodyList()) do
		local FF = {}
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local DATA = fixture:getUserData()
	
			--[[if (shapeType == "circle") then
				local x,y = body:getWorldPoint(shape:getPoint())
				local radius = shape:getRadius()
				love.graphics.setColor(DATA.szin.rr,DATA.szin.gg,DATA.szin.bb,255)
				love.graphics.circle("fill",x,y,radius,15)
				love.graphics.setColor(env.playerek[DATA.pID].teamcolor.rr,env.playerek[DATA.pID].teamcolor.gg,env.playerek[DATA.pID].teamcolor.bb,255)
				love.graphics.circle("line",x,y,radius,15)
			else]]if (shapeType == "polygon") then
				local points = {body:getWorldPoints(shape:getPoints())}
				local debug = {}
				if DEBUG then 
					local x,y = body:getPosition()
					local kx,ky = body:getWorldPoints(DATA.kx,DATA.ky)
					debug = {DATA.ID,kx,ky,x,y}
				else
					debug = nil
				end
				table.insert(FF,{DATA.szin.rr,DATA.szin.gg,DATA.szin.bb,122,points,env.playerek[DATA.pID].teamcolor.rr,env.playerek[DATA.pID].teamcolor.gg,env.playerek[DATA.pID].teamcolor.bb,255,debug})
			--[[elseif (shapeType == "edge") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			elseif (shapeType == "chain") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))]]
			end
			
			if DATA.usD and DATA.fgv then DATA.fgv(fixture,body,shape,DATA) end-- block update

		end
		table.insert(BB,FF)
	end
	peer:send("fruej3f4t?"..ser(BB))
end

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
				rajz(event.peer)
			end 
			elseif event.type == "connect" then
			--print("Connected: "..event.peer:connect_id())
			env:newPlayer(event.peer:connect_id())
			event.peer:send("ciet3h4jo?"..facreate(event.peer:connect_id(),-700,-700))
		elseif event.type == "disconnect" then
			--print(event.peer:connect_id() .. " disconnected.")
		end
	end

	env:update(dt) --ez kell a fizikai világ frissítéshez

end

return server