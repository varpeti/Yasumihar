MENU = {}
MENU.j = ""

function createmenu(menupontok)
	local x,y = ax,ay
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
	return menu
end

function createmenupont(szoveg,szin,keret)
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

function lines_from(file)
	local f = io.open(file,"rb")
	if f then f:close() else error([[Hiányzik a "]]..file..[[" file]]) end
  	lines = {}
  	for line in io.lines(file) do 
    	lines[#lines + 1] = line
  	end
  	return lines
end

function menuaktival(id)
	local l = lines_from("hu")
	if id=="fo" then
		MENU = createmenu({
			createmenupont(l[1],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[2],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[3],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[4],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[5],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	elseif id=="ujjatek" then
		MENU = createmenu({
			createmenupont(l[6],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[7],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	elseif id=="multi" then
		MENU = createmenu({
			createmenupont(l[9],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[10],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	elseif id=="beall" then
		MENU = createmenu({
			createmenupont(l[11],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[12],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[13],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[14],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
			createmenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	elseif id=="info" then
		MENU = createmenu({
			createmenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	elseif id=="credit" then
		MENU = createmenu({
			createmenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
		})
	end
	MENU.j=id
end

function menupontkattintas(id)
	if MENU.j=="fo" then
		if id==1 then
			menuaktival("ujjatek")
		elseif id==2 then
			menuaktival("info")
		elseif id==3 then
			menuaktival("beall")
		elseif id==4 then
			menuaktival("credit")
		elseif id==5 then
			love.event.quit()
		end

	elseif MENU.j=="ujjatek" then
		if id==1 then
		elseif id==2 then
			menuaktival("multi")
		elseif id==3 then
			menuaktival("fo")
		end
	elseif MENU.j=="multi" then
		if id==1 then
		elseif id==2 then
		elseif id==3 then
			menuaktival("ujjatek")
		end
	elseif MENU.j=="beall" then
		if id==1 then
		elseif id==2 then
		elseif id==3 then
		elseif id==4 then
		elseif id==5 then
			menuaktival("fo")
		end
	elseif MENU.j=="info" then
		if id==1 then
			menuaktival("fo")
		end
	elseif MENU.j=="credit" then
		if id==1 then
		 menuaktival("fo")
		end
	end
end

--LOVE

function love.load()

	ax,ay = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	if (ax*0.075)<(ay*0.1) then
		fontm = love.graphics.newFont(0.075*ax)
	else
		fontm = love.graphics.newFont(0.1*ay)
	end

	local l = lines_from("../lang")
	nyelv = l[1]

	menuaktival("fo")
	
end

function love.update(dt)
end

function love.draw()
 for i,v in ipairs(MENU) do
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

function love.mousepressed(x,y,button,istouch)
	if button==1 then
		for i,v in ipairs(MENU) do
			if v.shape:testPoint(0,0,0,x,y) then menupontkattintas(i) end
		end
	end
end