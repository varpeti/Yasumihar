--local ser = require('ser')
local env = {}
env.IDs=0

--fizikai beállítások
love.physics.setMeter(10) --10 pixel = 1 méter
env.world = love.physics.newWorld(0, 0, true) --vízszintes:0  függőleges: 0

world:setCallbacks(beginContact, endContact, preSolve, postSolve) --Ütközés lekérdezés

env.objs = {}

--[[
	(L) list | (T) table | ( ) number | (E) other
	env L
		IDs
		meter
		world
		objs L
			obj T
				ID
				apos T
					x
					y
				angle
				rpos T
					rx
					ry
					objID
				img T
				szin T
					rr
					gg
					bb
					aa
				szin2 T
					rr
					gg
					bb
					aa
				body E
				shfik L
					shfi T
						shape E
						fixture E
				type (nil: not phy,"static": static,"dynamic": dynamic)
				userdata T
]]

local largeenough

function env:newObj(coords,x,y,type,angle)
	if (#coords/2 < 3) or (#coords/2 > 8) then return -1 end -- három - nyolc szög kell h legyen
	if not largeenough(coords) then return -2 end -- elég nagy e?

	local obj = {}

	self.IDs=self.IDs+1 -- az ID számlálót növelem
	obj.ID=self.IDs -- ID adás

	obj.rpos = {} -- relatív (másik objektumtól tartott pozíció)
	obj.rx = 0
	obj.ry = 0
	obj.objID = -1

	obj.img = nil

	obj.szin = {}
	obj.szin.rr = 0
	obj.szin.gg = 0
	obj.szin.bb = 0
	obj.szin.aa = 255

	obj.szin2 = {}
	obj.szin2.rr = 255
	obj.szin2.gg = 255
	obj.szin2.bb = 255
	obj.szin2.aa = 255

	obj.type = type

	shfik = {}
		shif = {}
		shif.shape = love.physics.newPolygonShape(unpack(coords))


		if obj.type~=nil 
		then --Fizikai
			if obj.type=="static"
				then obj.body = love.physics.newBody(self.world, x, y, "static")
				else obj.body = love.physics.newBody(self.world, x, y, "dynamic")
			end
			obj.body:setUserData(obj.ID) -- UserDatába mentem az ID-jét
			shif.fixture = love.physics.newFixture(obj.body,shif.shape)
			obj.apos = {} -- pozíció (body.getPosition)
			obj.apos.x = obj.body:getX
			obj.apos.y = obj.body:getY
			obj.angle = obj.body:getAngle
		else -- Nem fizikai
			obj.body = nil
			shif.fixture = nil
			obj.apos = {} -- pozíció
			obj.apos.x = x
			obj.apos.y = y
			obj.angle = (angle or 0) 
		end
	table.insert(shfik,shif)

	obj.userdata = nil

	table.insert(objs,obj)
	return obj.ID
end

-- Local

largeenough = function (coords) --checks if a polygon is good enough for box2d's snobby standards.
	--Written by Adam/earthHunter

	-- Calculation of centroids of each triangle

	local centroids = {}

	local anchorX = coords[1]
	local anchorY = coords[2]

	local firstX = coords[3]
	local firstY = coords[4]

	for i = 5, #coords - 1, 2 do

		local x = coords[i]
		local y = coords[i + 1]

		local centroidX = (anchorX + firstX + x) / 3
		local centroidY = (anchorY + firstY + y) / 3

		local area = math.abs(anchorX * firstY + firstX * y + x * anchorY
				- anchorX * y - firstX * anchorY - x * firstY) / 2

		local index = 3 * (i - 3) / 2 - 2

		centroids[index] = area
		centroids[index + 1] = centroidX * area
		centroids[index + 2] = centroidY * area

		firstX = x
		firstY = y

	end

	-- Calculation of polygon's centroid

	local totalArea = 0
	local centroidX = 0
	local centroidY = 0

	for i = 1, #centroids - 2, 3 do

		totalArea = totalArea + centroids[i]
		centroidX = centroidX + centroids[i + 1]
		centroidY = centroidY + centroids[i + 2]

	end

	centroidX = centroidX / totalArea
	centroidY = centroidY / totalArea

	-- Calculation of normals

	local normals = {}

	for i = 1, #coords - 1, 2 do

		local i2 = i + 2

		if (i2 > #coords) then

			i2 = 1

		end

		local tangentX = coords[i2] - coords[i]
		local tangentY = coords[i2 + 1] - coords[i + 1]
		local tangentLen = math.sqrt(tangentX * tangentX + tangentY * tangentY)

		tangentX = tangentX / tangentLen
		tangentY = tangentY / tangentLen

		normals[i] = tangentY
		normals[i + 1] = -tangentX

	end

	-- Projection of vertices in the normal directions
	-- in order to obtain the distance from the centroid
	-- to each side

	-- If a side is too close, the polygon will crash the game

	for i = 1, #coords - 1, 2 do

		local projection = (coords[i] - centroidX) * normals[i]
				+ (coords[i + 1] - centroidY) * normals[i + 1]

		if (math.abs(projection) < 0.04*10) then -- *10 -> meter Vp
			
			return false

		end

	end

	return true

end

return env
