--local 
ser = require ('ser')
local env = {}

love.physics.setMeter(10) --10 pixel = 1 méter

env.world = love.physics.newWorld(0, 0, true) -- világ létrehozása 0, 0 gravitációval
env.IDs = 0 -- számláló

env.playerek = {}

--[[
	DATA T
		ID
		pID
		szin T
			rr
			gg
			bb
		img

	-------------
	PLAYER T (pID indexel)
		teamcolor
			rr
			gg
			bb
]]

--------
--Local
--------

local function createshape(x,y,coords)
	for i=1,#coords,2 do
		coords[i]=coords[i]-x
		coords[i+1]=coords[i+1]-y
	end
	return love.physics.newPolygonShape(unpack(coords))
end

local function CoM(coords)
	local maxx = 0
	local maxy = 0
	local i = 1
	while i<=#coords do
		maxx=maxx+coords[i]
		maxy=maxy+coords[i+1]
		i=i+2
	end
	local o = #coords/2
	return maxx/o, maxy/o -- A tömeg középpont
end

local function DatA(pID,fixture,szin)

	local DATA = {}
		env.IDs = env.IDs+1 -- növelem a számlálót
		DATA.ID = env.IDs

		DATA.szin = {}
		if szin ~= nil then
			DATA.szin.rr = szin.rr
			DATA.szin.gg = szin.gg
			DATA.szin.bb = szin.bb
		else
			DATA.szin.rr = math.random(122,255)
			DATA.szin.gg = math.random(122,255)
			DATA.szin.bb = math.random(122,255)
		end

		DATA.img = nil

		DATA.pID = pID
	fixture:setUserData(DATA) -- az objektumban elhelyezi az adatokat
	env.playerek[pID].mitlat[DATA.ID]={fixture=fixture,ido=255} -- láthatóvá teszi a játékos számára 255=örökre
	return DATA.ID
end

---------
--Global
---------

--set

function env:newPlayer(pID,teamcolor)
	local PLAYER = {}
		if teamcolor ~= nil then
			teamcolor.rr = teamcolor.rr
			teamcolor.gg = teamcolor.gg
			teamcolor.bb = teamcolor.bb
		else
			teamcolor = {}
			teamcolor.rr = math.random(122,255)
			teamcolor.gg = math.random(122,255)
			teamcolor.bb = math.random(122,255)
		end
		PLAYER.teamcolor = teamcolor
		PLAYER.mitlat = {}
	env.playerek[pID]=PLAYER -- pID hez rendeli a szint, és a látható objektumok listáját
end

function env:newObj(pID,coords,szin)

	if #coords<(2*3) or #coords>(2*8) then return end

	local x,y = CoM(coords)

	local body = love.physics.newBody(self.world, x, y, "dynamic") -- test
	local shape = createshape(x,y,coords)-- shape: a coords (0;0) pontja az x,y-on van
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás
	body:setAngularDamping(1) -- Forgás lassulása
	body:setLinearDamping(0.1) -- Lassulás

	return DatA(pID,fixture,szin)
	
end

function env:addObj(pID,ID,coords,szin,fgv,usD,x,y)

	if #coords<(2*3) or #coords>(2*8) then return end

	local x,y = CoM(coords)
	local body = self:getObj(ID):getBody()
	local shape = love.physics.newPolygonShape(unpack(coords)) 
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	return DatA(pID,fixture,szin,fgv,usD,x,y)
end

--func

function env:removeObj(ID)
	if ID~=nil then
		local fixture = self:getObj(ID)
		local body = self:getObj(ID):getBody()
		if #body:getFixtureList()==1 then
			body:destroy()
		else
			fixture:destroy()
		end
	else -- teljes törlés ha nincs paraméter
		for i=1, env.IDs do
			local fixture = env:getObj(i)
			if fixture~=nil then fixture:getBody():destroy() end
		end
		env.IDs=0
	end

end

function env:kijelol(ID)
	kiir:new(ID)
end

--get

function env:getObj(ID)
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			if ID == fixture:getUserData().ID then return fixture end
		end
	end
	return nil 
end

function env:getPlayerObjs(pID)
	ids = {}
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			if pID == fixture:getUserData().pID then table.insert(ids,fixture:getUserData().ID) end
		end
	end
	return ids
end

function env:getSerObj(pID) -- Viszadaja a régi és az új objektumok serilizált adatait
	--print()
	local ujobjs = {}
	local reobjs = {}
	for i,v in pairs(env.playerek[pID].mitlat) do
		--print(i,v.ido)
		local points = {v.fixture:getBody():getWorldPoints(v.fixture:getShape():getPoints())}
	 	if v.ido>0 then -- ha új objektum lett látható, "v.ido"-ig látható | ha 255 akkor örökre
	 		table.insert(ujobjs,{points,v.fixture:getUserData(),env.playerek[pID].teamcolor}) -- az User data tartalmazza az ID-t
	 		v.ido=-v.ido -- negatívval számol, mert a pozitív az új objektumok ideje
	 	else 	-- 0  és negatív számok = régi objektumok
	 		table.insert(reobjs,{points,v.fixture:getUserData().ID,-v.ido})
	 		if v.ido~=-1 and v.ido~=-255 then
	 			v.ido=v.ido+1 -- Lekérdezésenként "csökken", lehet szerver tickenként vagy dt időnként jobb lenne
	 		elseif v.ido~=-255 then
	 			--print(v.fixture:getUserData().ID)
	 			env.playerek[pID].mitlat[i]=nil
 	 		end
	 	end
	end 
	if #ujobjs>0 then
		return ser(reobjs), ser(ujobjs)
	end
	return ser(reobjs), nil
end

-- draw, update

function env:draw()
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local DATA = fixture:getUserData()
	
			if (shapeType == "circle") then
				local x,y = body:getWorldPoint(shape:getPoint())
				local radius = shape:getRadius()
				love.graphics.setColor(DATA.szin.rr,DATA.szin.gg,DATA.szin.bb,255)
				love.graphics.circle("fill",x,y,radius,15)
				love.graphics.setColor(env.playerek[DATA.pID].teamcolor.rr,env.playerek[DATA.pID].teamcolor.gg,env.playerek[DATA.pID].teamcolor.bb,255)
				love.graphics.circle("line",x,y,radius,15)
			elseif (shapeType == "polygon") then
				local points = {body:getWorldPoints(shape:getPoints())}
				love.graphics.setColor(DATA.szin.rr,DATA.szin.gg,DATA.szin.bb,122)
				love.graphics.polygon("fill",points)
				love.graphics.setColor(env.playerek[DATA.pID].teamcolor.rr,env.playerek[DATA.pID].teamcolor.gg,env.playerek[DATA.pID].teamcolor.bb,255)
				love.graphics.polygon("line",points)
					if DEBUG then 
					local kx,ky = body:getWorldPoints(DATA.kx,DATA.ky)
					love.graphics.setColor(255,255,255,255)
					love.graphics.print(DATA.ID,kx,ky) 
					local x,y = body:getPosition()
					love.graphics.line(x,y,kx,ky)
				end
			elseif (shapeType == "edge") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			elseif (shapeType == "chain") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			end

		end

		if DEBUG then
			love.graphics.setColor(255,255,255,255)
			local x,y = body:getPosition()
			love.graphics.circle("fill",x,y,5,15)
		end
	end	
end

function env:update(dt)
	self.world:update(dt)
end


--Ütközések

function beginContact(a, b, coll)
	--kiir:new("Ütközés: A: "..table.concat({a:getBody():getPosition()},"	").."		B: "..table.concat({b:getBody():getPosition()},"	"),10)
	local aUserData = a:getUserData()
	local bUserData = b:getUserData()
	if aUserData.pID ~= bUserData.pID then
		env.playerek[aUserData.pID].mitlat[bUserData.ID]={fixture=b,ido=254}
		env.playerek[bUserData.pID].mitlat[aUserData.ID]={fixture=a,ido=254}
	end
end

function endContact(a, b, coll)
	
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end

function env:setCallbacks()
	env.world:setCallbacks(beginContact, endContact, preSolve, postSolve) --Ütközés lekérdezés
end

--------
--Vége--
--------

return env