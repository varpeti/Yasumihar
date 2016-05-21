local player = {}	

player.speed = 1000
player.x = 0
player.y = 0
player.r = 0
player.kr = 0
player.id = nil

function player:update(dt)

	player.speed = 1000/ (kamera:gScale())^(1/2)

	if love.keyboard.isDown("d") or (love.mouse.getX()>=Asz*0.95 and not isandroid) then
		player.x=player.x+dt*player.speed
	end
	if love.keyboard.isDown("a") or (love.mouse.getX()<=Asz*0.05 and not isandroid) then
		player.x=player.x-dt*player.speed
	end
	if love.keyboard.isDown("s") or (love.mouse.getY()>=Am*0.95 and not isandroid) then
	   	player.y=player.y+dt*player.speed
	end
	if love.keyboard.isDown("w") or (love.mouse.getY()<=Am*0.05 and not isandroid) then
	   	player.y=player.y-dt*player.speed
	end
	if love.keyboard.isDown("r")  then
    	player.kr=player.kr-0.01
  	end
	if kameralock then
		local body = env:getObj(player.id):getBody()
		player.x,player.y = body:getPosition()
		player.r = body:getAngle()
    end
end

return player