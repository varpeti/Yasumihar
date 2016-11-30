local player = {}	

player.x = 0
player.y = 0
player.isandroid = love.system.getOS()=="Android"
player.tue = {}
player.kijelol = -1

function player:update(dt)

	player.speed = 1000/ (kamera:gScale())^(1/2)

	if love.keyboard.isDown("d") or (love.mouse.getX()>=kepernyo.Asz*0.95 and not player.isandroid) then
		player.x=player.x+dt*player.speed
	end
	if love.keyboard.isDown("a") or (love.mouse.getX()<=kepernyo.Asz*0.05 and not player.isandroid) then
		player.x=player.x-dt*player.speed
	end
	if love.keyboard.isDown("s") or (love.mouse.getY()>=kepernyo.Am*0.95 and not player.isandroid)  then
	   	player.y=player.y+dt*player.speed
	end
	if love.keyboard.isDown("w") or (love.mouse.getY()<=kepernyo.Am*0.05 and not player.isandroid)  then
	   	player.y=player.y-dt*player.speed
	end

	if kameralock then
		local friction = env:getObj(player.id)
		if not friction then return end
		local body = friction:getBody()
		player.x,player.y = body:getPosition()
		kamera:aRot(body:getAngle())
	end

end

function player.wheelmoved(x,y)
	if y>0 then kamera:rScale(-0.1) end
	if y<0 then kamera:rScale(0.1) end
end

function player.keypressed(key)
	if key == "escape" then
		--love.event.quit()
		env:removeObj()
	end
	if key == "menu" or key=="space" then
		if kameralock then kameralock=false else kameralock=true end
	end
	if key == "f8" then
		DEBUG = not DEBUG
	end
	if key == "f11" then
		if fullsreen then
			kepernyo:setmode(1280,720,0,true)
			fullsreen=false
		else
			kepernyo:setmode(0,0,1,true)
			fullsreen=true
		end
	end
	if key == "b" then
		kiir:new("Ido: "..os.time())
	end
end

function player.keyreleased(key)
	
end

function player.mousepressed(x,y,id,button)
	local t = {}
	t.x=x
	t.y=y
	if id==nil then 
		t.id = button 
	else
		t.id = id
	end
	table.insert(player.tue,t)
	if #player.tue==3 then player.keypressed("menu") end

	x,y  = kamera:worldCoords(x-(kepernyo.Asz/2),y-(kepernyo.Am/2))
	
	if button==1 then
		player.kijelol = -1
		for i=1,env.IDs do
			local fixture = env:getObj(i)
			if fixture~=nil and fixture:testPoint(x,y) then 
				env:kijelol(i)
				--if i~=player.id then env:removeObj(i) end
				player.kijelol = i
			end
		end
	elseif button==2 then
		
	elseif button==3 then
		facreate("Gaia",x,y)
	end
end

function player.touchmoved(x,y,dx,dy,id)
	--kiir:new(#player.tue)
	if player.tue[1]~=nil and player.tue[2]~=nil then
		if player.tue[1].id==id then 
			if ((player.tue[2].x-x)^2+(player.tue[2].y-y)^2)^(1/2)<((player.tue[2].x-player.tue[1].x)^2+(player.tue[2].y-player.tue[1].y)^2)^(1/2) then
				kamera:rScale(0.01)
			else
				kamera:rScale(-0.01)
			end
			player.tue[1].x=x
			player.tue[1].y=y
		end

		if player.tue[2].id==id then
			if ((player.tue[1].x-x)^2+(player.tue[1].y-y)^2)^(1/2)<((player.tue[1].x-player.tue[2].x)^2+(player.tue[1].y-player.tue[2].y)^2)^(1/2) then
				kamera:rScale(0.01)
			else
				kamera:rScale(-0.01)
			end
			player.tue[2].x=x
			player.tue[2].y=y
		end
	elseif player.tue[2]==nil and player.tue[1]~=nil then
		player.x = player.x-dx
		player.y = player.y-dy
	end
end

function player.mousereleased(x,y,id,button)
	table.remove(player.tue,#player.tue)
end

return player