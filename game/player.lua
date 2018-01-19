local player = {}

--Kamera
player.x=0
player.y=0
player.r=0
player.s=1
player.speed=1000

function bind(keys,fv)
	for k,key in ipairs(keys) do
		if love.keyboard.isDown(key) then --Billentyűzet gombok
			fv()
			return
		end
		local mkey = key:match("mouse(%d+)")
		if mkey and love.mouse.isDown(tonumber(mkey)) then
			fv()
			return
		end
	end
end

function player.update(dt)
	bind(cfg.keys.up,   function() player.y=player.y-player.speed*dt end)
	bind(cfg.keys.down, function() player.y=player.y+player.speed*dt end)
	bind(cfg.keys.right,function() player.x=player.x+player.speed*dt end)
	bind(cfg.keys.left, function() player.x=player.x-player.speed*dt end)
end

function player.keypressed(key)
	bind(cfg.keys.escape,love.event.quit)
	if cfg.cvar.debug3 then kiir.add("+"..key,3,{200,200,0}) end
end

function player.keyreleased(key)
	if cfg.cvar.debug3 then kiir.add("-"..key,3,{200,200,0}) end
end

function player.mousepressed(x, y, button, istouch)
	bind(cfg.keys.test, function() kiir.add("TEST",3,{200,200,0}) end)
    if cfg.cvar.debug3 then kiir.add("+mouse"..button,3,{200,200,0}) end
end

function player.mousereleased(x, y, button, istouch)
    if cfg.cvar.debug3 then kiir.add("-mouse"..button,3,{200,200,0}) end
end

function player.wheelmoved(y)
	if cfg.cvar.debug3 then  
    	if y>0 then kiir.add("mouseWheelUp",  3,{200,200,0})
    	else        kiir.add("mouseWheelDown",3,{200,200,0})
    	end
    end
end

return player