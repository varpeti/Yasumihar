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
		local body = env:getObj(player.id):getBody()
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
		t.id=id
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
		if player.kijelol~=-1 then
			local szog = 0
			local fixture = env:getObj(player.kijelol)
			if fixture~=nil then 
				local body = fixture:getBody()
				local DATA = fixture:getUserData()
				local sx,sy = body:getWorldPoints(DATA.kx,DATA.ky)
				sx = x-sx
				sy = y-sy
				if sx<0 then 
					szog = 3.141592653589793238462643383279+math.atan(sy/sx)
				else
					szog = math.atan(sy/sx)
				end
				fixture:getUserData().usD={szog=szog,ero=159999,megy=true}
			end
		end
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

function player.fgv(fixture,body,shape,DATA)

	-- UPDATE
	if DATA.usD.megy then
		DATA.usD.ero = DATA.usD.ero or 20000
		if fixture==nil then return end
		local kx, ky = body:getWorldPoints(DATA.kx,DATA.ky)
    	body:applyForce(DATA.usD.ero*math.cos(DATA.usD.szog),DATA.usD.ero*math.sin(DATA.usD.szog),kx,ky)
    end

    --DRAW

    love.graphics.setColor(255,255,000,255)
	local kx, ky = body:getWorldPoints(DATA.kx,DATA.ky)
	if DATA.usD then 
		love.graphics.line(200*math.cos(DATA.usD.szog)+kx,200*math.sin(DATA.usD.szog)+ky,kx,ky)
	end
end

return player