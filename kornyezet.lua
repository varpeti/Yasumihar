kornyezet = {}
elem = {}
elem.__index = elem
pontok = {}
---
--Típusok:
--[[					 	 R    G    B    A
	0 : Player block 		000, 000, 000, 000 Fehér_szegély
	1 : Sima block 			255, 255, 255, 255 Fehér
	2 : Armored block 		000, 200, 000, 122 Zöld
	3 : Fegyver 			200, 000, 000, 122 Vörös
	4 : Senzor				255, 255, 000, 122 Sárga
	5 : Elrejtő				000, 255, 255, 122 Cián 
	6 : Válotztató			999, 999, 999, 999 ???
	7 : Generátor			000, 000, 200, 122 Kék
	8 : Vezető				200, 150, 000, 122 Narancs
	9 : Void tartó			210, 000, 240, 255 Lila
	10: Void block			090, 000, 200, 255 Lila_szegély
	11: Mozgató  			200, 100, 000, 122 Barna
	12: Haladás megállító   190, 110, 010, 122 Barna
	13: Forgás megállító   	210, 090, 010, 122 Barna
--]]
---

function elem:uj(coords,dps,rr,gg,bb,aa,type)
 	if #coords/2 >= 3 and #coords/2 <= 8 then --a shape 3 és 8 pont között van
 		if largeenough(coords) then
 			local ie = {}
 			setmetatable(ie,elem)
 			local legkx = coords[1]
			local legky = coords[2]
			local maxx = coords[1]
			local maxy = coords[2]
			local i = 1
			while i<=#coords do
				maxx=maxx+coords[i]
				maxy=maxy+coords[i+1]
				if coords[i]  <=legkx then legkx = coords[i]   end -- megkeressük a legkisseb X pontját
				if coords[i+1]<=legky then legky = coords[i+1] end -- megkeressük a legkisseb Y pontját
				i=i+2
			end
			local x = maxx/(#coords/2) -- ez a globális közepe
			local y = maxy/(#coords/2) 
			if dps then ie.body = love.physics.newBody(world, x, y, "dynamic") else ie.body = love.physics.newBody(world, x, y, "static") end
			ie.shacol = {}
			local ishacol = {}

			ishacol.Fixture = love.physics.newFixture(ie.body,creatshape(ie.body,coords),30)

			ishacol.color = {} -- szín
			ishacol.color.rr=rr
			ishacol.color.gg=gg
			ishacol.color.bb=bb
			ishacol.color.aa=aa

			ishacol.lk = {} --lokális közép
			ishacol.lk.kx = x-legkx 
			ishacol.lk.ky = y-legky -- ez a lokális közepe (a bal felső sarokhoz viszonyítva)

			ishacol.spec = {} -- speciális tulajdonságok és válotzóik
			ishacol.spec.type = type

			table.insert(ie.shacol,ishacol)

			table.insert(kornyezet,ie)
    		local i=1
  			while i <= #coords do
				table.remove(coords,i) --ami nem kell megszüntetjük ^^
			end
 		end
 	end
end 

function elem:torol(body)
	local ie,id = bodytoelem(body)
	print(id)
	ie.body:destroy() 
	table.remove(kornyezet,id)
end

function elem:rombol(f)
	if true then return 0 end
	local ie,id = bodytoelem(f:getBody())
	local ii = -1
	if #ie.shacol>1 then
		for i,ishacol in ipairs(ie.shacol) do
			if ishacol.Fixture==f then ii=i end
		end
		if ii~=-1 then 
			table.remove(ie.shacol,ii)
			f:destroy()
		end
	else  
		ie.body:destroy() 
		table.remove(kornyezet,id)
	end
end

function elem:plus(coords,relem,rr,gg,bb,aa, type)
	if #coords/2 >= 3 and #coords/2 <= 8 then --a shape 3 és 8 pont között van
 		if largeenough(coords) then
 			local legkx = coords[1]
			local legky = coords[2]
			local maxx = coords[1]
			local maxy = coords[2]
			local i = 1
			while i<=#coords do
				maxx=maxx+coords[i]
				maxy=maxy+coords[i+1]
				if coords[i]  <=legkx then legkx = coords[i]   end -- megkeressük a legkisseb X pontját
				if coords[i+1]<=legky then legky = coords[i+1] end -- megkeressük a legkisseb Y pontját
				i=i+2
			end
			local x = maxx/(#coords/2) -- ez a globális közepe
			local y = maxy/(#coords/2) 
			local ishacol = {}

			ishacol.Fixture = love.physics.newFixture(relem.body,creatshape(relem.body,coords),30)

			ishacol.color = {} -- szín
			ishacol.color.rr=rr
			ishacol.color.gg=gg
			ishacol.color.bb=bb
			ishacol.color.aa=aa

			ishacol.lk = {} --lokális közép
			ishacol.lk.kx = x-legkx 
			ishacol.lk.ky = y-legky -- ez a lokális közepe (a bal felső sarokhoz viszonyítva)

			table.insert(relem.shacol,ishacol)
 		end
 	end
end

function elem:re()

end

function elem:draw()
	for i,shacol in ipairs(self.shacol) do
		rr,gg,bb,aa = shacol.color.rr,shacol.color.gg,shacol.color.bb,shacol.color.aa
		love.graphics.setColor(rr,gg,bb,aa)
		love.graphics.polygon("fill",self.body:getWorldPoints(shacol.Fixture:getShape():getPoints()))
		love.graphics.setColor(255-rr,255-gg,255-bb,255-aa)
		love.graphics.polygon("line",self.body:getWorldPoints(shacol.Fixture:getShape():getPoints()))
	end
	love.graphics.setColor(255,255,255,255)
end

---
--Egyébb fügvények (saját)
---

function bodytoelem(body)
	for i,elem in ipairs(kornyezet) do
		if body == elem.body then return elem,i end
	end
	return nil,0
end


function creatshape(body, coords)
	local newcoords={}
	for i=1,#coords,2 do
		newcoords[i],newcoords[i+1] = body:getLocalPoint(coords[i], coords[i+1])
	end
	return love.physics.newPolygonShape(unpack(newcoords))
end

---
--Egyébb fügvények (nem saját, esetleg módosított)
---

function getPoints2table(shape) --Készítő: Maurice
	x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7,x8,y8 = shape:getPoints()
	if x4 == nil then
		return {x1,y1,x2,y2,x3,y3}
	end
	if x5 == nil then
		return {x1,y1,x2,y2,x3,y3,x4,y4}
	end
	if x6 == nil then
		return {x1,y1,x2,y2,x3,y3,x4,y4,x5,y5}
	end
	if x7 == nil then
		return {x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6}
	end
	if x8 == nil then
		return {x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7}
	end
	return     {x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,x7,y7,x8,y8}
end

function largeenough(coords) --checks if a polygon is good enough for box2d's snobby standards.
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

		if (math.abs(projection) < 0.04*10) then               -- Old: if (projection < 0.04*meter) then --     Modified by Vp 
			
			return false

		end

	end

	return true

end