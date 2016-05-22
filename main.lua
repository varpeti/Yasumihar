math.randomseed(os.time())

kamera = require('kamera')
player = require('player')
kiir = require('kiir')
env = require('env')
kepernyo = require('kepernyo')
server = require('server')
client = require('client')
statusz = require('statusz')
require('fa')


function love.load()
	--ablak beállítások
	kepernyo:setmode(1280,720,0,true,2,1)
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Sima változók
	kameralock = false
	DEBUG = false
	fullsreen = false

end

function love.update(dt)

	statusz:update(dt)

	kiir:update(dt)

end

function love.draw()

	statusz:draw()

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:aRot(player.r)
	kamera:set()
	
	env:draw()
	
	local mx,my = kamera:worldCoords(love.mouse:getX()-(kepernyo.Asz/2),love.mouse:getY()-(kepernyo.Am/2))
	love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)

	if DEBUG then love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my,10,10) end

	kiir:draw(10,kepernyo.Am-25,true,DEBUG) --kiirasok

end

--Input eventek (player.lua)

function love.mousepressed(x,y,button,istouch)
	if istouch then return end -- touchnál meghívná még1x
	player.mousepressed(x,y,nil,button)
end

function love.mousereleased(x,y,button,istouch)
	if istouch then return end
	player.mousereleased(x,y,nil,button)
end

function love.wheelmoved(x,y)
	player.wheelmoved(x,y)
end

function love.keypressed(key)
	player.keypressed(key)
end

function love.keyreleased(key)
	player.keyreleased(key)
end

function love.touchpressed(id,x,y)
	player.mousepressed(x,y,id)
end

function love.touchmoved(id,x,y,dx,dy)
	player.touchmoved(x,y,dx,dy,id)
end

function love.touchreleased(id,x,y)
	player.mousereleased(x,y,id)
end