math.randomseed(os.time())

kamera = require('kamera')
player = require('player')
kiir = require('kiir')
env = require('env')
kepernyo = require('kepernyo')
server = require('server')
client = require('client')
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

	fmenu = love.graphics.newFont(48)
	fkiiras = love.graphics.newFont(16)
	fkicsi = love.graphics.newFont(10)
	kiir:set(nil,nil,10,true,DEBUG,12)

	env:setCallbacks()

	env:newPlayer("Gaia",{rr=000,gg=200,bb=200})
	
	env:newObj("Gaia",{-50,-50,-30,50,40,40})
	env:addObj("Gaia",1,{200,200,150,170,180,110,135,167,123,110})
	env:getObj(1):getBody():setPosition(200,0)
		
	env:newObj("Gaia",{-50,-50,-30,50,40,40})
    env:newObj("Gaia",{200,200,150,170,180,110,135,167,123,110})
		
	env:newPlayer("Player001",{rr=255,gg=255,bb=255})
	--player.id = facreate("Player001",-700,-700)
		
    --env:getObj(player.id):getBody():setAngularVelocity(0.3)
		
	env:getObj(1):getBody():setAngularVelocity(-1)
		
	love.mouse.setPosition(love.graphics.getWidth()/2,love.graphics.getHeight()/2)

	kiir:new("",46)
	kiir:new("Gombok:",30)
	kiir:new("WASD, egér - kamera mozgás",31)
	kiir:new("SPACE - kameralock",32)
	kiir:new("F8 - Debug",33)
	kiir:new("Görgö - Zoom",34)
	kiir:new("B - kiirteszt",35)
	kiir:new("R - kameraforgatás",36)
	kiir:new("F11 - teljesképernyö",37)
	kiir:new("Kattintás - objektum ID",38)
	kiir:new("",39)
	kiir:new("Android:",40)
	kiir:new("Húzás - kameramozgatás",41)
	kiir:new("2 új - zoom",42)
	kiir:new("3 új - kameralock",43)
	kiir:new("ESC - vissza, kilépés",44)
	kiir:new("",45)
	kiir:new([[Balra fel van a "hajó"]],20)

end

function love.update(dt)

	env:update(dt) --ez kell a fizikai világ frissítéshez

	player:update(dt) --ez kell az irányításhoz

	kiir:update(dt) -- kiírások

	server:update(dt)

	client:update(dt)

end

function love.draw()

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:set()
	
	env:draw()
	
	local mx,my = kamera:worldCoords(love.mouse:getX()-(kepernyo.Asz/2),love.mouse:getY()-(kepernyo.Am/2))
	love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(fkicsi);

	if DEBUG then
		love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my.."\n"..player.kijelol.." kijelolve",10,10)
		local text = ""
		for k,v in pairs(_G) do
			if type(v)~="function" then text = text..k..": "..type(v).."\n" end
		end
		love.graphics.print(text,500,10)
	end

	love.graphics.setFont(fkiiras);
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