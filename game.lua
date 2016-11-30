local game = {}

function cl()
	client = require('client')
	client:init()
end

function se()
	server = require('server')
	server:init()
end


function love.load(svc)
	if svc=="server" then
		se()
	elseif svc=="client" then
		cl()
	elseif svc=="single" then
		se()
		cl()
	end
	game.svc = svc
end

function love.update(dt)
	if game.svc=="server" then
		server:update(dt)
	elseif game.svc=="client" then
		client:update(dt)
	elseif game.svc=="single" then
		server:update(dt)
		client:update(dt)
	end
end

function love.draw()
	if game.svc=="client" then
		client:draw()
	elseif game.svc=="single" then
		client:draw()
	end
end

--Input eventek (player.lua)

function love.mousepressed(x,y,button,istouch)
	if game.svc=="server" then return end
	if istouch then return end -- touchnál meghívná még1x
	player.mousepressed(x,y,nil,button)
end

function love.mousereleased(x,y,button,istouch)
	if game.svc=="server" then return end
	if istouch then return end
	player.mousereleased(x,y,nil,button)
end

function love.wheelmoved(x,y)
	if game.svc=="server" then return end
	player.wheelmoved(x,y)
end

function love.keypressed(key)
	if game.svc=="server" then return end
	player.keypressed(key)
end

function love.keyreleased(key)
	if game.svc=="server" then return end
	player.keyreleased(key)
end

function love.touchpressed(id,x,y)
	if game.svc=="server" then return end
	player.mousepressed(x,y,id)
end

function love.touchmoved(id,x,y,dx,dy)
	if game.svc=="server" then return end
	player.touchmoved(x,y,dx,dy,id)
end

function love.touchreleased(id,x,y)
	if game.svc=="server" then return end
	player.mousereleased(x,y,id)
end