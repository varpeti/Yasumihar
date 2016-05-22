local player = {}	

player.speed = 1000
player.x = 0
player.y = 0
player.r = 0
player.id = nil


player.isandroid=love.system.getOS()=="Android"
player.tue = {}

function player:update(dt)

	player.speed = 1000/ (kamera:gScale())^(1/2)

	if love.keyboard.isDown("d") or (love.mouse.getX()>=Asz*0.95 and not player.isandroid) then
		player.x=player.x+dt*player.speed
	end
	if love.keyboard.isDown("a") or (love.mouse.getX()<=Asz*0.05 and not player.isandroid) then
		player.x=player.x-dt*player.speed
	end
	if love.keyboard.isDown("s") or (love.mouse.getY()>=Am*0.95 and not player.isandroid) then
	   	player.y=player.y+dt*player.speed
	end
	if love.keyboard.isDown("w") or (love.mouse.getY()<=Am*0.05 and not player.isandroid) then
	   	player.y=player.y-dt*player.speed
	end
	if love.keyboard.isDown("r")  then
    	player.r=player.r-0.01
  	end
	if kameralock then
		local body = env:getObj(player.id):getBody()
		player.x,player.y = body:getPosition()
		player.r = body:getAngle()
    end
end

function player.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "menu" or key=="space" then
		if kameralock then kameralock=false player.r=0 else kameralock=true end
	end
	if key == "f8" then
		DEBUG = not DEBUG
	end
	if key == "b" then
		kiir:new("Ido: "..os.time())
	end
end

function player.keyreleased(key)
	
end

function player.touchpressed(id,x,y)
	t = {}
	t.x=x
	t.y=y
	t.id=id
	table.insert(player.tue,t)
	if #player.tue==3 then player.keypressed("menu") end
end

function player.touchmoved(id, x, y, dx, dy)

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
	elseif player.tue[2]==nil then
		player.x = player.x-dx
		player.y = player.y-dy
	end
end

function player.touchreleased(id,x,y)
	table.remove(player.tue,#player.tue)
end

return player