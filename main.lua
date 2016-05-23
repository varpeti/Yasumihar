MENU = {}
MENU.j = ""

exf = {}
exf.callbacks = {
--"directorydropped",
"draw",
--"errhand",
--"filedropped",
--"focus",
--"gamepadaxis",
--"gamepadpressed",
--"gamepadreleased",
--"joystickadded",
--"joystickaxis",
--"joystickhat",
--"joystickpressed",
--"joystickreleased",
--"joystickremoved",
"keypressed",
"keyreleased",
"load",
--"lowmemory",
--"mousefocus",
"mousemoved",
"mousepressed",
"mousereleased",
"quit",
--"resize",
--"run",
--"textedited",
--"textinput",
--"threaderror",
"touchmoved",
"touchpressed",
"touchreleased",
"update",
--"visible",
"wheelmoved"
}

function exf.run(file, ...)
	if not love.filesystem.exists(file) then
		print("Could not load file .. " .. file)
		return
	end

	-- Clear all callbacks.
	for i, v in ipairs(exf.callbacks) do love[v] = exf.empty end

	love.filesystem.load(file)(...)


	-- Redirect keypress
	local o_keypressed = love.keypressed
	love.keypressed = function(k)
		if k == "escape" then 
			exf.resume()
			local ax,ay = love.graphics.getWidth()/2, love.graphics.getHeight()/2
			if (ax*0.075)<(ay*0.1) then
				fontm = love.graphics.newFont(0.075*ax)
			else
				fontm = love.graphics.newFont(0.1*ay)
			end
			menuaktival("fo")
		end
		o_keypressed(k)
	end
	love.load()
end

function exf.empty() end


function exf.resume()

	for i, v in ipairs(exf.callbacks) do love[v] = exf[v] end

	menuaktival("fo")

end



function createmenu(menupontok)
	local x,y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	if (x*0.075)<(y*0.1) then
		fontm = love.graphics.newFont(0.075*x)
	else
		fontm = love.graphics.newFont(0.1*y)
	end
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
			exf.run("Yasumihar.lua")
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

	love.window.setTitle("Yasumihar - by Váraljai Péter")

	local l = lines_from("lang")
	nyelv = l[1]

	menuaktival("fo")

	exf.resume()
	
end

-- EXF

function exf.update(dt)
end

function exf.draw()
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

function exf.mousepressed(x,y,button,istouch)
	if button==1 then
		for i,v in ipairs(MENU) do
			if v.shape:testPoint(0,0,0,x,y) then menupontkattintas(i) end
		end
	end
end

function exf.keypressed(key)
	if key == "escape" then
		if MENU.j=="fo" then
			love.event.quit()
		elseif MENU.j=="ujjatek" then
			menuaktival("fo")
		elseif MENU.j=="multi" then
			menuaktival("ujjatek")
		elseif MENU.j=="beall" then
			menuaktival("fo")
		elseif MENU.j=="info" then
			menuaktival("fo")
		elseif MENU.j=="credit" then
			menuaktival("fo")
		end
	end 
end