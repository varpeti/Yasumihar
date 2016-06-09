local menuk = {}
menuk.k = {}
menuk.j = ""


function menuk:newMenu(id,menupontok)
	local x,y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	local menu = {}
	for i,v in ipairs(menupontok) do
		local menupont = {}
		menupont.shape = love.physics.newPolygonShape(x-x/4,-y/8+(y/3)*i,x-x/4,y/8+(y/3)*i,x+x/4,y/8+(y/3)*i,x+x/4,-y/8+(y/3)*i)
		menupont.szoveg=v.szoveg
		menupont.szin = {}
		menupont.szin.rr = v.szin.rr
		menupont.szin.gg = v.szin.gg 
		menupont.szin.bb = v.szin.bb
		menupont.keret = {}
		menupont.keret.rr = v.keret.rr
		menupont.keret.gg = v.keret.gg
		menupont.keret.bb = v.keret.bb
		menupont.kx = (x-x/4 + x-x/4 + x+x/4 + x+x/4)/4
		menupont.ky = (-y/8+(y/3)*i + y/8+(y/3)*i + y/8+(y/3)*i + -y/8+(y/3)*i)/4
		table.insert(menu,menupont)
	end
	menuk.k[id]=menu
end

function menuk:newMenupont(szoveg,szin,keret)
	local menupont = {}
	menupont.szoveg = szoveg 
	menupont.szin = {}
	menupont.szin.rr = szin[1]
	menupont.szin.gg = szin[2]
	menupont.szin.bb = szin[3] 
	menupont.keret = {}
	menupont.keret.rr = keret[1]
	menupont.keret.gg = keret[2]
	menupont.keret.bb = keret[3] 
	return menupont
end

function menuk:draw()
	for i,v in ipairs(menuk.k[menuk.j]) do
 		local points = {v.shape:getPoints()}
	
		love.graphics.setColor(v.szin.rr,v.szin.gg,v.szin.bb,122)
		love.graphics.polygon("fill",points)
	
		love.graphics.setColor(v.keret.rr,v.keret.gg,v.keret.bb,255)
		love.graphics.polygon("line",points)
	
		love.graphics.setFont(fontm);
		love.graphics.setColor(255,255,255,255)
	
		
		local font = love.graphics.getFont()
		local w,h = font:getWidth(v.szoveg), font:getHeight()
	
		love.graphics.print(v.szoveg,v.kx-(w/2),v.ky-(h/2))
 	end
end

function menuk:OnClick(x,y)
	for i,v in ipairs(menuk.k[menuk.j]) do
		if v.shape:testPoint(0,0,0,x,y) then return i end
	end
	return -1
end

function menuk:set(id)
	if id==nil then
		menuk.k={}
	end
	menuk.j=id
end

function menuk:get()
	return menu.j
end

return menuk