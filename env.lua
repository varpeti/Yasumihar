--local ser = require('ser')
local env = {}

love.physics.setMeter(10) --10 pixel = 1 méter

env.world = love.physics.newWorld(0, 0, true) -- világ létrehozása 0, 0 gravitációval
env.IDs = 0 -- számláló

--env.world:setCallbacks(beginContact, endContact, preSolve, postSolve) --Ütközés lekérdezés

--[[
	DATA T
		ID 
		szin1 T
			rr
			gg
			bb
		szin2 T
			rr
			gg
			bb
		img
		rpos
			ID
			x
			y
		stat T
			HP
			Armor
				rr
				gg
				bb
			Energia
		dot T
			dmg
				rr
				gg
				bb
			time
			x
]]

--Local

local function createshape(x,y,coords)
	for i=1,#coords,2 do
		coords[i]=coords[i]+x
		coords[i+1]=coords[i+1]+y
	end
	return love.physics.newPolygonShape(unpack(coords))
end

--Global

function env:ujObj(x,y,coords,gpl,szin1,szin2)
	local body = love.physics.newBody(self.world, x, y, "dynamic") -- test
	local shape
	if gpl then 
		shape = createshape(x,y,coords)-- shape: a coords (0;0) pontja az x,y-on van
	else
		shape = love.physics.newPolygonShape(unpack(coords)) --shape
	end

	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	local DATA = {}
		self.IDs = self.IDs+1 -- növelem a számlálót
		DATA.ID = self.IDs
		DATA.szin1 = {}
		if szin1 ~= nil then
			DATA.szin1.rr = szin1.rr
			DATA.szin1.gg = szin1.gg
			DATA.szin1.bb = szin1.bb
		else
			DATA.szin1.rr = math.random(122,255)
			DATA.szin1.gg = math.random(122,255)
			DATA.szin1.bb = math.random(122,255)
		end
		DATA.szin2 = {}
		if szin2 ~= nil then
			DATA.szin2.rr = szin2.rr
			DATA.szin2.gg = szin2.gg
			DATA.szin2.bb = szin2.bb
		else
			DATA.szin2.rr = math.random(122,255)
			DATA.szin2.gg = math.random(122,255)
			DATA.szin2.bb = math.random(122,255)
		end
	fixture:setUserData(DATA)
	return DATA.ID
end

function env:draw()
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local DATA = fixture:getUserData()
	
			if (shapeType == "circle") then
				local x,y = body:getWorldPoint(shape:getPoint())
				local radius = shape:getRadius()
				love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,255)
				love.graphics.circle("fill",x,y,radius,15)
				love.graphics.setColor(DATA.szin2.rr,DATA.szin2.gg,DATA.szin2.bb,255)
				love.graphics.circle("line",x,y,radius,15)
			elseif (shapeType == "polygon") then
				local points = {body:getWorldPoints(shape:getPoints())}
				love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,255)
				love.graphics.polygon("fill",points)
				love.graphics.setColor(DATA.szin2.rr,DATA.szin2.gg,DATA.szin2.bb,255)
				love.graphics.polygon("line",points)
			elseif (shapeType == "edge") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			elseif (shapeType == "chain") then
				love.graphics.setColor(0,0,0,255)
				love.graphics.line(body:getWorldPoint(shape:getPoint()))
			end
		end
	end		
end

function env:update(dt)
	self.world:update(dt)
end

function env:getObj(id)
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			if id == fixture:getUserData().ID then return fixture end
		end
	end
	return nil
end

return env