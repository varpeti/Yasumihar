local player = {}

--Kamera
player.x=0
player.y=0
player.r=0
player.s=1
player.speed=100

function player.update(dt)
	for k,key in ipairs(cfg.keys.up) do
		if love.keyboard.isDown(key) then
			player.y=player.y-player.speed*dt
			--break -- Hogy ne tudjon dupla sebességgel menni
		end 
	end
	for k,key in ipairs(cfg.keys.down) do
		if love.keyboard.isDown(key) then
			player.y=player.y+player.speed*dt
			break
		end 
	end
	for k,key in ipairs(cfg.keys.right) do
		if love.keyboard.isDown(key) then
			player.x=player.x+player.speed*dt
			break
		end 
	end
	for k,key in ipairs(cfg.keys.left) do
		if love.keyboard.isDown(key) then
			player.x=player.x-player.speed*dt
			break
		end 
	end
end

function player.keypressed(key)
	for k,key in ipairs(cfg.keys.escape) do
		if love.keyboard.isDown(key) then
			love.event.quit()
			break
		end 
	end
end

function player.keyreleased(key)

end

return player