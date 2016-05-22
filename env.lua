--local ser = require('ser')
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
	PLAYER T
		pID
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

local function DatA(pID,fixture,szin,teamcolor)

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
		DATA.pID = pID
	fixture:setUserData(DATA)
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
	env.playerek[pID]=PLAYER -- pID hez rendeli a szint
end

function env:newObj(pID,coords,szin)

	if #coords<(2*3) or #coords>(2*8) then return end

	local x,y = CoM(coords)

	local body = love.physics.newBody(self.world, x, y, "dynamic") -- test
	local shape = createshape(x,y,coords)-- shape: a coords (0;0) pontja az x,y-on van
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	return DatA(pID,fixture,szin)
	
end

function env:addObj(pID,ID,coords,szin)

	if #coords<(2*3) or #coords>(2*8) then return end

	local x,y = CoM(coords)
	local body = self:getObj(ID):getBody()
	local shape = love.physics.newPolygonShape(unpack(coords)) 
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	return DatA(pID,fixture,szin)
end

function env:removeObj(ID)
	local fixture = self:getObj(ID)
	local body = self:getObj(ID):getBody()
	if #body:getFixtureList()==1 then
		body:destroy()
	else
		fixture:destroy()
	end

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
			elseif (shapeType == "edge") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			elseif (shapeType == "chain") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			end
			if DEBUG then
				love.graphics.setColor(255,255,255,255)
				local x,y = body:getPosition()
				love.graphics.circle("fill",x,y,5,15)
				love.graphics.print(DATA.ID,x+5,y)
			end
		end
	end		
end

function env:update(dt)
	self.world:update(dt)
end


--Ütközések

function beginContact(a, b, coll)
 	kiir:new("Ütközés: A: "..table.concat({a:getBody():getPosition()},"	").."		B: "..table.concat({b:getBody():getPosition()},"	"),10)
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