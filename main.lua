math.randomseed(os.time())

kamera = require('kamera')
player = require('player')
kiir = require('kiir')
env = require('env')
kepernyo = require('kepernyo')
require('fa')


function love.load()
	--ablak beállítások
	kepernyo:goFullscreen()
	Asz=love.graphics.getWidth()
	Am=love.graphics.getHeight()
	Aksz=Asz/2 Akm=Am/2
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Sima változók
	kameralock = false
	DEBUG = false


	env:setCallbacks()

	env:newPlayer("Gaia",{rr=000,gg=200,bb=200})

	env:newObj("Gaia",{-50,-50,-30,50,40,40})
	env:addObj("Gaia",1,{200,200,150,170,180,110,135,167,123,110})
	env:getObj(1):getBody():setPosition(200,0)

	env:newObj("Gaia",{-50,-50,-30,50,40,40})
    env:newObj("Gaia",{200,200,150,170,180,110,135,167,123,110})
	
	env:newPlayer("Player001",{rr=255,gg=255,bb=255})
	player.id = facreate("Player001",-700,-700)

    env:getObj(player.id):getBody():setAngularVelocity(0.3)

	env:getObj(1):getBody():setAngularVelocity(-0.5)

	love.mouse.setPosition(Aksz,Akm)


	kiir:set(nil,nil,10,true,DEBUG,12)

	kiir:new("Gombok:",30)
	kiir:new("WASD, nyilak, egér - kamera mozgás",31)
	kiir:new("SPACE - kameralock",32)
	kiir:new("F8 - Debug",33)
	kiir:new("Görgö - Zoom",34)
	kiir:new("B - kiirteszt",35)
	kiir:new("R - kameraforgatás (kameralock esetében is!)",36)
	kiir:new("ESC - kilépés",37)

end

function love.update(dt)

	env:update(dt) --ez kell a fizikai világ frissítéshez
	
	player:update(dt)
	
	kiir:update(dt)

end

function love.draw()

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:aRot(player.r)
	kamera:set()
	
	env:draw()
	
	local mx,my = kamera:worldCoords(love.mouse:getX()-Aksz,love.mouse:getY()-Akm)
	love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	
	kiir:draw(10,Am-25,nil,DEBUG) --kiirasok

	if DEBUG then love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my,10,10) end

end

function love.wheelmoved( x, y )
	if y>0 then kamera:rScale(-0.1) end
	if y<0 then kamera:rScale(0.1) end
end

--Input eventek (player.lua)

function love.keypressed(key)
	player.keypressed(key)
end

function love.keyreleased(key)
	player.keyreleased(key)
end

function love.touchpressed(id,x,y)
	player.touchpressed(id,x,y)
end

function love.touchmoved(id, x, y, dx, dy)
	player.touchmoved(id, x, y, dx, dy)
end

function love.touchreleased(id,x,y)
	player.touchreleased(id,x,y)
end