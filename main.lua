menu = require('menu')

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
		end
		o_keypressed(k)
	end

	--menu felszab
	menu:set()

	love.load(...)
end

function exf.empty() end


function exf.resume()

	for i, v in ipairs(exf.callbacks) do love[v] = exf[v] end

	initmenuk()
	menu:set("fo")

end

function lines_from(file)
	if not love.filesystem.exists(file) then error([[Hiányzik a "]]..file..[[" file]]) end
  	local lines = {}
  	for line in love.filesystem.lines(file) do 
    	lines[#lines + 1] = line
  	end
  	return lines
end

function initmenuk()
	local l = lines_from(lines_from("lang")[1])

	menu:newMenu("fo",{
		menu:newMenupont(l[1],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[2],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[3],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[4],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[5],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})
	
	menu:newMenu("ujjatek",{
		menu:newMenupont(l[6],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[7],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})

	menu:newMenu("multi",{
		menu:newMenupont(l[9],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[10],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})
	
	menu:newMenu("beall",{
		menu:newMenupont(l[11],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[12],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[13],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[14],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255}),
		menu:newMenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})
	
	menu:newMenu("info",{
		menu:newMenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})
	
	menu:newMenu("credit",{
		menu:newMenupont(l[8],{math.random(128,255),math.random(128,255),math.random(128,255)},{255,255,255})
	})
end

function menupontkattintas(id)
	if menu:get()=="fo" then
		if id==1 then menu:set("ujjatek")
		elseif id==2 then menu:set("info")
		elseif id==3 then menu:set("beall")
		elseif id==4 then menu:set("credit")
		elseif id==5 then love.event.quit()
		end

	elseif menu:get()=="ujjatek" then
		if id==1 then exf.run("game.lua","single")
		elseif id==2 then menu:set("multi")
		elseif id==3 then menu:set("fo")
		end
	elseif menu:get()=="multi" then
		if id==1 then exf.run("game.lua","server")
		elseif id==2 then exf.run("game.lua","client")
		elseif id==3 then menu:set("ujjatek")
		end
	elseif menu:get()=="beall" then
		if id==1 then
		elseif id==2 then
		elseif id==3 then
		elseif id==4 then
		elseif id==5 then menu:set("fo")
		end
	elseif menu:get()=="info" then
		if id==1 then menu:set("fo")
		end
	elseif menu:get()=="credit" then
		if id==1 then menu:set("fo")
		end
	end
end

--LOVE

function love.load()

	love.window.setTitle("Yasumihar - by Váraljai Péter")

	local l = lines_from("lang")
	nyelv = l[1]

	local ax,ay = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	if (ax*0.075)<(ay*0.1) then
		fontm = love.graphics.newFont(0.075*ax)
	else
		fontm = love.graphics.newFont(0.1*ay)
	end

	initmenuk()

	exf.resume()

	
end

-- EXF

function exf.update(dt)
end

function exf.draw()
  	menu:draw()
end

function exf.mousepressed(x,y,button,istouch)
	if button==1 then
		menupontkattintas(menu:OnClick(x,y))
	end
end

function exf.keypressed(key)
	if key == "escape" then
		if menu:get()=="fo" then
			love.event.quit()
		elseif menu:get()=="ujjatek" then
			menu:set("fo")
		elseif menu:get()=="multi" then
			menu:set("ujjatek")
		elseif menu:get()=="beall" then
			menu:set("fo")
		elseif menu:get()=="info" then
			menu:set("fo")
		elseif menu:get()=="credit" then
			menu:set("fo")
		end
	end 
end